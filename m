Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31378316BAD
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 17:50:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232530AbhBJQta (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 11:49:30 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:42813 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232298AbhBJQsn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 11:48:43 -0500
Received: from mwalle01.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:fa59:71ff:fe9b:b851])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 56A4623E6D;
        Wed, 10 Feb 2021 17:47:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1612975677;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ydv6TP3djPCF01UQIpu6z6Bz6TNaGTZqIFeMZSmzyUU=;
        b=qmyGjSCFg20YYQfeTKELbBFp3Galk6ghqQAXE71FbmQyjHFoCkWg7t1uSFtSwCr26n/pvt
        edeX6T5kBdF24CQvZnhQ6/rlZ8rdXPYEtSc6595CJ2qXuh9qSUsjcRhXxxW3bVeX9krCqG
        rGdOdXNmdbokiBCvrDIi4npTu0DZa3o=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next v2 1/9] net: phy: icplus: use PHY_ID_MATCH_MODEL() macro
Date:   Wed, 10 Feb 2021 17:47:38 +0100
Message-Id: <20210210164746.26336-2-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210210164746.26336-1-michael@walle.cc>
References: <20210210164746.26336-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simpify the initializations of the structures. There is no functional
change.

Signed-off-by: Michael Walle <michael@walle.cc>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
Changes since v1:
 - none


 drivers/net/phy/icplus.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/phy/icplus.c b/drivers/net/phy/icplus.c
index b632947cbcdf..4407b1eb1a3d 100644
--- a/drivers/net/phy/icplus.c
+++ b/drivers/net/phy/icplus.c
@@ -47,6 +47,10 @@ MODULE_LICENSE("GPL");
 #define IP101G_DIGITAL_IO_SPEC_CTRL			0x1d
 #define IP101G_DIGITAL_IO_SPEC_CTRL_SEL_INTR32		BIT(2)
 
+#define IP175C_PHY_ID 0x02430d80
+#define IP1001_PHY_ID 0x02430d90
+#define IP101A_PHY_ID 0x02430c54
+
 /* The 32-pin IP101GR package can re-configure the mode of the RXER/INTR_32 pin
  * (pin number 21). The hardware default is RXER (receive error) mode. But it
  * can be configured to interrupt mode manually.
@@ -329,9 +333,8 @@ static irqreturn_t ip101a_g_handle_interrupt(struct phy_device *phydev)
 
 static struct phy_driver icplus_driver[] = {
 {
-	.phy_id		= 0x02430d80,
+	PHY_ID_MATCH_MODEL(IP175C_PHY_ID),
 	.name		= "ICPlus IP175C",
-	.phy_id_mask	= 0x0ffffff0,
 	/* PHY_BASIC_FEATURES */
 	.config_init	= &ip175c_config_init,
 	.config_aneg	= &ip175c_config_aneg,
@@ -339,17 +342,15 @@ static struct phy_driver icplus_driver[] = {
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
 }, {
-	.phy_id		= 0x02430d90,
+	PHY_ID_MATCH_MODEL(IP1001_PHY_ID),
 	.name		= "ICPlus IP1001",
-	.phy_id_mask	= 0x0ffffff0,
 	/* PHY_GBIT_FEATURES */
 	.config_init	= &ip1001_config_init,
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
 }, {
-	.phy_id		= 0x02430c54,
+	PHY_ID_MATCH_MODEL(IP101A_PHY_ID),
 	.name		= "ICPlus IP101A/G",
-	.phy_id_mask	= 0x0ffffff0,
 	/* PHY_BASIC_FEATURES */
 	.probe		= ip101a_g_probe,
 	.config_intr	= ip101a_g_config_intr,
@@ -362,9 +363,9 @@ static struct phy_driver icplus_driver[] = {
 module_phy_driver(icplus_driver);
 
 static struct mdio_device_id __maybe_unused icplus_tbl[] = {
-	{ 0x02430d80, 0x0ffffff0 },
-	{ 0x02430d90, 0x0ffffff0 },
-	{ 0x02430c54, 0x0ffffff0 },
+	{ PHY_ID_MATCH_MODEL(IP175C_PHY_ID) },
+	{ PHY_ID_MATCH_MODEL(IP1001_PHY_ID) },
+	{ PHY_ID_MATCH_MODEL(IP101A_PHY_ID) },
 	{ }
 };
 
-- 
2.20.1

