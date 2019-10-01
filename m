Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1BA4C2D11
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 08:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732244AbfJAGIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 02:08:17 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:54209 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727848AbfJAGIR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 02:08:17 -0400
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1iFBKY-0005n2-S5; Tue, 01 Oct 2019 08:08:14 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1iFBKW-0006NL-P1; Tue, 01 Oct 2019 08:08:12 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] net: phy: at803x: use PHY_ID_MATCH_EXACT for IDs
Date:   Tue,  1 Oct 2019 08:08:09 +0200
Message-Id: <20191001060811.24291-2-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191001060811.24291-1-o.rempel@pengutronix.de>
References: <20191001060811.24291-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use exact match for all IDs. We have no sanity checks, so we can peek
a device with no exact ID and different register layout.

Suggested-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/phy/at803x.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 6ad8b1c63c34..7895dbe600ac 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -364,9 +364,8 @@ static int at803x_aneg_done(struct phy_device *phydev)
 static struct phy_driver at803x_driver[] = {
 {
 	/* ATHEROS 8035 */
-	.phy_id			= ATH8035_PHY_ID,
+	PHY_ID_MATCH_EXACT(ATH8035_PHY_ID),
 	.name			= "Atheros 8035 ethernet",
-	.phy_id_mask		= AT803X_PHY_ID_MASK,
 	.probe			= at803x_probe,
 	.config_init		= at803x_config_init,
 	.set_wol		= at803x_set_wol,
@@ -378,9 +377,8 @@ static struct phy_driver at803x_driver[] = {
 	.config_intr		= at803x_config_intr,
 }, {
 	/* ATHEROS 8030 */
-	.phy_id			= ATH8030_PHY_ID,
+	PHY_ID_MATCH_EXACT(ATH8030_PHY_ID),
 	.name			= "Atheros 8030 ethernet",
-	.phy_id_mask		= AT803X_PHY_ID_MASK,
 	.probe			= at803x_probe,
 	.config_init		= at803x_config_init,
 	.link_change_notify	= at803x_link_change_notify,
@@ -393,9 +391,8 @@ static struct phy_driver at803x_driver[] = {
 	.config_intr		= at803x_config_intr,
 }, {
 	/* ATHEROS 8031 */
-	.phy_id			= ATH8031_PHY_ID,
+	PHY_ID_MATCH_EXACT(ATH8031_PHY_ID),
 	.name			= "Atheros 8031 ethernet",
-	.phy_id_mask		= AT803X_PHY_ID_MASK,
 	.probe			= at803x_probe,
 	.config_init		= at803x_config_init,
 	.set_wol		= at803x_set_wol,
@@ -411,9 +408,7 @@ static struct phy_driver at803x_driver[] = {
 module_phy_driver(at803x_driver);
 
 static struct mdio_device_id __maybe_unused atheros_tbl[] = {
-	{ ATH8030_PHY_ID, AT803X_PHY_ID_MASK },
-	{ ATH8031_PHY_ID, AT803X_PHY_ID_MASK },
-	{ ATH8035_PHY_ID, AT803X_PHY_ID_MASK },
+	{ PHY_ID_MATCH_VENDOR(ATH8030_PHY_ID) },
 	{ }
 };
 
-- 
2.23.0

