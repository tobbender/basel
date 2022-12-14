#' Risk weights for non defaulted exposures to corporates, institutions, central governments and central banks.
#'
#' Calculates the risk weight according to Sub-Section 2 Article 153 1. iii for non defaulted exposures (0 < PD < 1).
#'
#'
#' @param PD Enter the PD as a decimal number.
#' @param LGD Enter the LGD as a decimal number.
#' @param SME SME exposure = 1: For SME exposures to companies where the total annual sales for the consolidated group of which the firm is a part
#' is less than EUR 50 million, the formula according to Article 153 4. is used. You have to enter the annual sales in parameter S.
#'
#' Default value is 0 for non SME exposure.
#' @param S S is expressed as total annual sales in millions of Euro. It is only used when parameter SME = 1.
#' @param AVC Set the AVC factor to 1.25 for all exposures to large financial sector entities or to unregulated financial
#' sector entities.
#' Default value is 1.
#' @param SK Default value is 1.06 according to the basel formula. You can change the value to 1, e.g. to simulate the effects
#' from basel IV.
#' @param M Maturity value (M) according to article 162 no 1. Institutions that have not received permission to use own LGDs and
#' own conversion factors for exposures to corporates, institutions or central governments and central banks shall assign to exposures
#' arising from repurchase transactions or securities or commodities lending or borrowing transactions a maturity value (M) of 0,5 years
#' and to all other exposures M of 2,5 years.
#'
#' !!! In the basel version 0.1.0 calculation is only implemented with the factor 2.5. !!!
#'
#' Default value is 2.5.
#'
#'
#' @return  Risk weight as a number
#' @export
#'
#' @examples
#'
#' #corporate exposure secured by real estate.
#' PD <- 0.002
#' LGD <- 0.35
#' rw_corp(PD,LGD)
#'
#' #corporate exposure secured by real estate. Simulate Basel IV effects without factor 1.06.
#' PD <- 0.002
#' LGD <- 0.35
#' rw_corp(PD,LGD, SK=1)
#'
#' #corporate exposure secured by real estate to to large financial sector entities with AVC = 1.25.
#' PD <- 0.002
#' LGD <- 0.35
#' rw_corp(PD,LGD, AVC = 1.25)
#'
#' #corporate exposure secured by real estate to SME with annual sales of 30 mio. Euro.
#' PD <- 0.002
#' LGD <- 0.35
#' rw_corp(PD,LGD, SME=1, S=30 )
#'
#'
rw_corp <- function(PD,LGD, SME=0, S=0, AVC=1, SK=1.06, M=2.5){
  stopifnot("PD input must be numeric" = is.numeric(PD))
  stopifnot("LGD input must be numeric" = is.numeric(LGD))
  b <- b(PD)
  R <- corr_R(PD, AVC = AVC, SME=SME, S=S)
  (LGD * stats::pnorm(1 / sqrt(1 - R) * stats::qnorm(PD) + sqrt(R / (1 - R)) * stats::qnorm(0.999)) - LGD * PD) * (1+(M-2.5) * b) / (1-1.5 *b)* 12.5 * SK
}
