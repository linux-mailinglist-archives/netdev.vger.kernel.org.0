Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3D6256CD3
	for <lists+netdev@lfdr.de>; Sun, 30 Aug 2020 10:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728679AbgH3Iej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Aug 2020 04:34:39 -0400
Received: from inva020.nxp.com ([92.121.34.13]:57150 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbgH3Ieh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Aug 2020 04:34:37 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id BD0C51A0505;
        Sun, 30 Aug 2020 10:34:35 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id B00071A03D0;
        Sun, 30 Aug 2020 10:34:35 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 4A0DD20305;
        Sun, 30 Aug 2020 10:34:35 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        andrew@lunn.ch, linux@armlinux.org.uk, f.fainelli@gmail.com,
        olteanv@gmail.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v5 2/5] net: phylink: consider QSGMII interface mode in phylink_mii_c22_pcs_get_state
Date:   Sun, 30 Aug 2020 11:33:59 +0300
Message-Id: <20200830083402.11047-3-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200830083402.11047-1-ioana.ciornei@nxp.com>
References: <20200830083402.11047-1-ioana.ciornei@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The same link partner advertisement word is used for both QSGMII and
SGMII, thus treat both interface modes using the same
phylink_decode_sgmii_word() function.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>
---
Changes in v5:
- none

 drivers/net/phy/phylink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index d7810c908bb3..0219ddf94e92 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -2404,6 +2404,7 @@ void phylink_mii_c22_pcs_get_state(struct mdio_device *pcs,
 		break;
 
 	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_QSGMII:
 		phylink_decode_sgmii_word(state, lpa);
 		break;
 
-- 
2.25.1

