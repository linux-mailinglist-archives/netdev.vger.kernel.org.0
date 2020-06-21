Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87D2A202D8B
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 00:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730083AbgFUW4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 18:56:01 -0400
Received: from inva021.nxp.com ([92.121.34.21]:54294 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726432AbgFUW4A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Jun 2020 18:56:00 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 6607B2007BC;
        Mon, 22 Jun 2020 00:55:59 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 59ADE20059D;
        Mon, 22 Jun 2020 00:55:59 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id D533D20414;
        Mon, 22 Jun 2020 00:55:58 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, michael@walle.cc, andrew@lunn.ch,
        linux@armlinux.org.uk, f.fainelli@gmail.com, olteanv@gmail.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v3 2/9] net: phylink: consider QSGMII interface mode in phylink_mii_c22_pcs_get_state
Date:   Mon, 22 Jun 2020 01:54:44 +0300
Message-Id: <20200621225451.12435-3-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200621225451.12435-1-ioana.ciornei@nxp.com>
References: <20200621225451.12435-1-ioana.ciornei@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The same link partner advertisement word is used for both QSGMII and
SGMII, thus treat both interface modes using the same
phylink_decode_sgmii_word() function.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - none
Changes in v3:
 - none

 drivers/net/phy/phylink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index f04ccdedda40..117ddbcaaa6e 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -2186,6 +2186,7 @@ void phylink_mii_c22_pcs_get_state(struct mdio_device *pcs,
 		break;
 
 	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_QSGMII:
 		phylink_decode_sgmii_word(state, lpa);
 		break;
 
-- 
2.25.1

