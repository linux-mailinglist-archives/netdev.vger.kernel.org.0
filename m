Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06C46202A2F
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 13:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729912AbgFULAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 07:00:24 -0400
Received: from inva021.nxp.com ([92.121.34.21]:37146 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729884AbgFULAT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Jun 2020 07:00:19 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 47CCD2004BA;
        Sun, 21 Jun 2020 13:00:16 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 3B7882000F2;
        Sun, 21 Jun 2020 13:00:16 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id B7A22203C2;
        Sun, 21 Jun 2020 13:00:15 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, michael@walle.cc, andrew@lunn.ch,
        linux@armlinux.org.uk, f.fainelli@gmail.com, olteanv@gmail.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v2 2/5] net: phylink: consider QSGMII interface mode in phylink_mii_c22_pcs_get_state
Date:   Sun, 21 Jun 2020 14:00:02 +0300
Message-Id: <20200621110005.23306-3-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200621110005.23306-1-ioana.ciornei@nxp.com>
References: <20200621110005.23306-1-ioana.ciornei@nxp.com>
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

