Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B85B23006E5
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 16:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729148AbhAVPPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 10:15:23 -0500
Received: from mail2.eaton.com ([192.104.67.3]:10401 "EHLO mail2.eaton.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729097AbhAVPPM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 10:15:12 -0500
Received: from mail2.eaton.com (loutcimsva04.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C35A67A09E;
        Fri, 22 Jan 2021 10:14:09 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=eaton.com;
        s=eaton-s2020-01; t=1611328449;
        bh=sXcHRobPia5pIun4fOb1KavkwPIkB/bBIRzAvw5wzHI=; h=From:To:Date;
        b=PEOoyUUH3fFLbYCUCtcTESpeZWQ7ULrpes3lG+YQxus3R6jueDlDMaiwOpDaLpDuE
         d8zBd06FNse8WJwCsjLFpKB6HUAz/TDrjG++/7I6ekV5fSGYxU4t2lYlYXwoy9PHaP
         QMBsX63IvxudSBD6cAGqRGjbNzmH4d7GBw4/q4MUdrF0RxygzhkOCvPuIumTbv3bIQ
         4j4t11VEFFUpfYt6aalTV873q35Psl1lvNXn7VHrnWTEdfTtN3H9tLpmEmSv5/rQZn
         cuwqA8C9rykTvmPGfD7SYd1dtlFQ70ascegBBywR2BgW1EcyQp+DvJMg0uruwUb67n
         ioX6tGi7MgfYw==
Received: from mail2.eaton.com (loutcimsva04.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B47267A0AD;
        Fri, 22 Jan 2021 10:14:09 -0500 (EST)
Received: from SIMTCSGWY03.napa.ad.etn.com (simtcsgwy03.napa.ad.etn.com [151.110.126.189])
        by mail2.eaton.com (Postfix) with ESMTPS;
        Fri, 22 Jan 2021 10:14:09 -0500 (EST)
Received: from localhost (151.110.234.147) by SIMTCSGWY03.napa.ad.etn.com
 (151.110.126.205) with Microsoft SMTP Server id 14.3.487.0; Fri, 22 Jan 2021
 10:14:08 -0500
From:   Laurent Badel <laurentbadel@eaton.com>
To:     Fugang Duan <fugang.duan@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Laurent Badel <laurentbadel@eaton.com>
Subject: [PATCH net 1/1] net: fec: Fix temporary RMII clock reset on link up
Date:   Fri, 22 Jan 2021 16:13:47 +0100
Message-ID: <20210122151347.30417-2-laurentbadel@eaton.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210122151347.30417-1-laurentbadel@eaton.com>
References: <20210122151347.30417-1-laurentbadel@eaton.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-EXCLAIMER-MD-CONFIG: 96b59d02-bc1a-4a40-8c96-611cac62bce9
X-TM-SNTS-SMTP: 3B56337121E69533BB9B3AA5206CFEDBCDA4D10E9F349BD9F3C4B036F91DBB452002:8
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSVA-9.1.0.1988-8.6.0.1013-25928.000
X-TM-AS-Result: No-1.393-7.0-31-10
X-imss-scan-details: No-1.393-7.0-31-10
X-TMASE-Version: IMSVA-9.1.0.1988-8.6.1013-25928.000
X-TMASE-Result: 10-1.392600-10.000000
X-TMASE-MatchedRID: 1sOFX2xm26+YizZS4XBb39WxbZgaqhS03FYvKmZiVnM4WKr1PmPdtdxw
        X69jh9hhExVp/bagDJjktTJlTF/cAihW3rCVLjscB89GKHo03nYO9z+P2gwiBVLDlDlwWhcN39L
        PCVlm+Y6BDuqEfzq88ZbiTEZvM55sEfIWTKnSZvkjCTunWqnclh+qR83NNEVKGlbrk2ODhoOMG4
        UVhKg8D7YzLEm68XGBn80pYGscWYsGbfRE5Gg+Mz8Ckw9b/GFeTJDl9FKHbrn3PK42Skwsg6ip1
        8v0DWYVcwePA9FSeTwzY7ay0wr1I5GaKgWIisUSimHWEC28pk3xuhkRWK22GHqm3WhT4L+k+xgZ
        1yrMGgDA3uQfVY1UMY6HM5rqDwqtOmZFo0L2x1bGtKMKzRqekWMpoQUSruNeoG7bvAx1RNUu988
        e3Ql3KShAXCXbrQFYKwc6ALN0vq+UgECPGydXuCvTD95V4p3C9UElV5SMCCrLt16YWtxzeF9NpZ
        bddHv73iGQYUPZme5uDfx2dqJtIpRMZUCEHkRt
X-TMASE-SNAP-Result: 1.821001.0001-0-1-12:0,22:0,33:0,34:0-0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=EF=BB=BFfec_restart() does a hard reset of the MAC module when the link st=
atus
changes to up. This temporarily resets the R_CNTRL register which controls
the MII mode of the ENET_OUT clock. In the case of RMII, the clock
frequency momentarily drops from 50MHz to 25MHz until the register is
reconfigured. Some link partners do not tolerate this glitch and
invalidate the link causing failure to establish a stable link when using
PHY polling mode. Since as per IEEE802.11 the criteria for link validity=20
are PHY-specific, what the partner should tolerate cannot be assumed, so=20
avoid resetting the MII clock by using software reset instead of hardware=20
reset when the link is up. This is generally relevant only if the SoC=20
provides the clock to an external PHY and the PHY is configured for RMII.

Signed-off-by: Laurent Badel <laurentbadel@eaton.com>
---
 drivers/net/ethernet/freescale/fec.h      | 5 +++++
 drivers/net/ethernet/freescale/fec_main.c | 6 ++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/fr=
eescale/fec.h
index c527f4ee1d3a..0602d5d5d2ee 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -462,6 +462,11 @@ struct bufdesc_ex {
  */
 #define FEC_QUIRK_CLEAR_SETUP_MII	(1 << 17)
=20
+/* Some link partners do not tolerate the momentary reset of the REF_CLK
+ * frequency when the RNCTL register is cleared by hardware reset.
+ */
+#define FEC_QUIRK_NO_HARD_RESET		(1 << 18)
+
 struct bufdesc_prop {
 	int qid;
 	/* Address of Rx and Tx buffers */
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethern=
et/freescale/fec_main.c
index 04f24c66cf36..280ccea4327f 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -100,7 +100,8 @@ static const struct fec_devinfo fec_imx27_info =3D {
 static const struct fec_devinfo fec_imx28_info =3D {
 	.quirks =3D FEC_QUIRK_ENET_MAC | FEC_QUIRK_SWAP_FRAME |
 		  FEC_QUIRK_SINGLE_MDIO | FEC_QUIRK_HAS_RACC |
-		  FEC_QUIRK_HAS_FRREG | FEC_QUIRK_CLEAR_SETUP_MII,
+		  FEC_QUIRK_HAS_FRREG | FEC_QUIRK_CLEAR_SETUP_MII |
+		  FEC_QUIRK_NO_HARD_RESET,
 };
=20
 static const struct fec_devinfo fec_imx6q_info =3D {
@@ -953,7 +954,8 @@ fec_restart(struct net_device *ndev)
 	 * For i.MX6SX SOC, enet use AXI bus, we use disable MAC
 	 * instead of reset MAC itself.
 	 */
-	if (fep->quirks & FEC_QUIRK_HAS_AVB) {
+	if (fep->quirks & FEC_QUIRK_HAS_AVB ||
+	    (fep->quirks & FEC_QUIRK_NO_HARD_RESET) && fep->link) {
 		writel(0, fep->hwp + FEC_ECNTRL);
 	} else {
 		writel(1, fep->hwp + FEC_ECNTRL);
--=20
2.17.1



-----------------------------
Eaton Industries Manufacturing GmbH ~ Registered place of business: Route d=
e la Longeraie 7, 1110, Morges, Switzerland=20

-----------------------------

