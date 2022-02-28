Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC8D4C6ED4
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 15:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236923AbiB1OGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 09:06:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236921AbiB1OGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 09:06:20 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D7427E09D;
        Mon, 28 Feb 2022 06:05:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1646057140; x=1677593140;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XsqLsrZ+2kdjAygpws5BPzsVNVfSXp8S38OI9aISkeM=;
  b=1LDKjksH/5o7p3UIRDn1bDizld2/Lq8dPHGIw7Yr4gCB5G1aWyAdX7HM
   /4TRU7vm5LudK0cDHw7LK8S58xU5bELGQsqzlC+67rOChRlMBMkj3B3mZ
   n9TPPXG/1LgxmHJuhIsFCqdmpxZ4YGI0Qcg/ZeDmvgclx3xw+DtbG95Ho
   rEnCKAGaUOiwe4xUwAdK4imALoo32XX+AJ1J359EtyCyVwEHK+pYHc/My
   yYgHn8zHqtz6q98ORUVNmfaN16PmThzKCLyYh0lifGuY/WZe2Di/OOhdP
   3zvc9m5EF3aOfDilecmXZ2UD3mkceraDIPA4gUcvt7/fXJbttTyLHSiZE
   w==;
X-IronPort-AV: E=Sophos;i="5.90,142,1643698800"; 
   d="scan'208";a="147501744"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Feb 2022 07:05:39 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 28 Feb 2022 07:05:38 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 28 Feb 2022 07:05:35 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: [RFC PATCH net-next 1/4] net: phy: used the genphy_soft_reset for phy reset in Lan87xx
Date:   Mon, 28 Feb 2022 19:35:07 +0530
Message-ID: <20220228140510.20883-2-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220228140510.20883-1-arun.ramadoss@microchip.com>
References: <20220228140510.20883-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replaced current code for soft resetting phy to genphy_soft_reset
function. And added the macro for LAN87xx Phy ID.

Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/phy/microchip_t1.c | 32 ++++++++++++--------------------
 1 file changed, 12 insertions(+), 20 deletions(-)

diff --git a/drivers/net/phy/microchip_t1.c b/drivers/net/phy/microchip_t1.c
index bc50224d43dd..ece21c1e5716 100644
--- a/drivers/net/phy/microchip_t1.c
+++ b/drivers/net/phy/microchip_t1.c
@@ -9,6 +9,9 @@
 #include <linux/ethtool.h>
 #include <linux/ethtool_netlink.h>
 
+#define LAN87XX_PHY_ID			0x0007c150
+#define MICROCHIP_PHY_ID_MASK		0xfffffff0
+
 /* External Register Control Register */
 #define LAN87XX_EXT_REG_CTL                     (0x14)
 #define LAN87XX_EXT_REG_CTL_RD_CTL              (0x1000)
@@ -197,20 +200,10 @@ static int lan87xx_phy_init(struct phy_device *phydev)
 	if (rc < 0)
 		return rc;
 
-	/* Soft Reset the SMI block */
-	rc = access_ereg_modify_changed(phydev, PHYACC_ATTR_BANK_SMI,
-					0x00, 0x8000, 0x8000);
-	if (rc < 0)
-		return rc;
-
-	/* Check to see if the self-clearing bit is cleared */
-	usleep_range(1000, 2000);
-	rc = access_ereg(phydev, PHYACC_ATTR_MODE_READ,
-			 PHYACC_ATTR_BANK_SMI, 0x00, 0);
+	/* phy Soft reset */
+	rc = genphy_soft_reset(phydev);
 	if (rc < 0)
 		return rc;
-	if ((rc & 0x8000) != 0)
-		return -ETIMEDOUT;
 
 	/* PHY Initialization */
 	for (i = 0; i < ARRAY_SIZE(init); i++) {
@@ -273,6 +266,9 @@ static int lan87xx_config_init(struct phy_device *phydev)
 {
 	int rc = lan87xx_phy_init(phydev);
 
+	if (rc < 0)
+		phydev_err(phydev, "failed to initialize phy\n");
+
 	return rc < 0 ? rc : 0;
 }
 
@@ -506,18 +502,14 @@ static int lan87xx_cable_test_get_status(struct phy_device *phydev,
 
 static struct phy_driver microchip_t1_phy_driver[] = {
 	{
-		.phy_id         = 0x0007c150,
-		.phy_id_mask    = 0xfffffff0,
-		.name           = "Microchip LAN87xx T1",
+		.phy_id         = LAN87XX_PHY_ID,
+		.phy_id_mask    = MICROCHIP_PHY_ID_MASK,
+		.name           = "LAN87xx T1",
 		.flags          = PHY_POLL_CABLE_TEST,
-
 		.features       = PHY_BASIC_T1_FEATURES,
-
 		.config_init	= lan87xx_config_init,
-
 		.config_intr    = lan87xx_phy_config_intr,
 		.handle_interrupt = lan87xx_handle_interrupt,
-
 		.suspend        = genphy_suspend,
 		.resume         = genphy_resume,
 		.cable_test_start = lan87xx_cable_test_start,
@@ -528,7 +520,7 @@ static struct phy_driver microchip_t1_phy_driver[] = {
 module_phy_driver(microchip_t1_phy_driver);
 
 static struct mdio_device_id __maybe_unused microchip_t1_tbl[] = {
-	{ 0x0007c150, 0xfffffff0 },
+	{ LAN87XX_PHY_ID, MICROCHIP_PHY_ID_MASK},
 	{ }
 };
 
-- 
2.33.0

