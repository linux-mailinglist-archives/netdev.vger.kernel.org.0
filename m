Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4547B4CD18B
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 10:45:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239351AbiCDJqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 04:46:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239329AbiCDJp6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 04:45:58 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6A1C1A41E9;
        Fri,  4 Mar 2022 01:45:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1646387111; x=1677923111;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=c/yEZG9LMz58ypWQ9JNpMFElbdNH/azsVhJQ/llh7Lk=;
  b=bwM/sXLNHXFcW6xtaRUfN0gcVIgaPvFYQ+7Lq3WVrs3kiw5aZMKP+JED
   sEDgx+bsL9j8EPhKdPIqi1psnFRS7AruQ9hRLRC/hk+r1zCsYiC2B9KRK
   yu58nVY87i+R9Kp0EKrnVV/JhFkXYSWct41RXO5ef2dtLyUNLjAi10n4A
   m41orsZ+/+otQcTT3qwVVXCHja8Vgwiqbr19Y2lmn91YxEcBFa9M6aYW6
   mQfpjiUQqM10BTq+9X7dtb5iX1ouFYdwMr6HjMrmLj0rDsYbvzhdzfcgi
   WJtzBGNi9Ua90GIveoiHH+FAXBthxkWFVfmB6KWBotDxtb87M4msBZIwm
   A==;
X-IronPort-AV: E=Sophos;i="5.90,154,1643698800"; 
   d="scan'208";a="87816412"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Mar 2022 02:45:10 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 4 Mar 2022 02:45:10 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 4 Mar 2022 02:45:06 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        <UNGLinuxDriver@microchip.com>
Subject: [PATCH net-next 5/6] net: phy: added the LAN937x phy support
Date:   Fri, 4 Mar 2022 15:14:00 +0530
Message-ID: <20220304094401.31375-6-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220304094401.31375-1-arun.ramadoss@microchip.com>
References: <20220304094401.31375-1-arun.ramadoss@microchip.com>
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

LAN937x T1 switch is based on LAN87xx Phy, so reusing the init script of
the LAN87xx. There is a workaround in accessing the DSP bank register
for LAN937x Phy. Whenever there is a bank switch to DSP registers, then
we need a one dummy read access before proceeding to the actual register
access.

Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/phy/microchip_t1.c | 55 +++++++++++++++++++++++++++++++++-
 1 file changed, 54 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/microchip_t1.c b/drivers/net/phy/microchip_t1.c
index d0bc0125f3ef..6a7836c2961a 100644
--- a/drivers/net/phy/microchip_t1.c
+++ b/drivers/net/phy/microchip_t1.c
@@ -8,13 +8,17 @@
 #include <linux/phy.h>
 #include <linux/ethtool.h>
 #include <linux/ethtool_netlink.h>
+#include <linux/bitfield.h>
 
 #define PHY_ID_LAN87XX				0x0007c150
+#define PHY_ID_LAN937X				0x0007c180
 
 /* External Register Control Register */
 #define LAN87XX_EXT_REG_CTL                     (0x14)
 #define LAN87XX_EXT_REG_CTL_RD_CTL              (0x1000)
 #define LAN87XX_EXT_REG_CTL_WR_CTL              (0x0800)
+#define LAN87XX_REG_BANK_SEL_MASK		GENMASK(10, 8)
+#define LAN87XX_REG_ADDR_MASK			GENMASK(7, 0)
 
 /* External Register Read Data Register */
 #define LAN87XX_EXT_REG_RD_DATA                 (0x15)
@@ -76,7 +80,7 @@
 #define T1_PST_EQ_LCK_STG1_FRZ_CFG	0x6E
 
 #define DRIVER_AUTHOR	"Nisar Sayed <nisar.sayed@microchip.com>"
-#define DRIVER_DESC	"Microchip LAN87XX T1 PHY driver"
+#define DRIVER_DESC	"Microchip LAN87XX/LAN937x T1 PHY driver"
 
 struct access_ereg_val {
 	u8  mode;
@@ -86,6 +90,37 @@ struct access_ereg_val {
 	u16 mask;
 };
 
+static int lan937x_dsp_workaround(struct phy_device *phydev, u16 ereg, u8 bank)
+{
+	u8 prev_bank;
+	int rc = 0;
+	u16 val;
+
+	mutex_lock(&phydev->lock);
+	/* Read previous selected bank */
+	rc = phy_read(phydev, LAN87XX_EXT_REG_CTL);
+	if (rc < 0)
+		goto out_unlock;
+
+	/* store the prev_bank */
+	prev_bank = FIELD_GET(LAN87XX_REG_BANK_SEL_MASK, rc);
+
+	if (bank != prev_bank && bank == PHYACC_ATTR_BANK_DSP) {
+		val = ereg & ~LAN87XX_REG_ADDR_MASK;
+
+		val &= ~LAN87XX_EXT_REG_CTL_WR_CTL;
+		val |= LAN87XX_EXT_REG_CTL_RD_CTL;
+
+		/* access twice for DSP bank change,dummy access */
+		rc = phy_write(phydev, LAN87XX_EXT_REG_CTL, val);
+	}
+
+out_unlock:
+	mutex_unlock(&phydev->lock);
+
+	return rc;
+}
+
 static int access_ereg(struct phy_device *phydev, u8 mode, u8 bank,
 		       u8 offset, u16 val)
 {
@@ -114,6 +149,13 @@ static int access_ereg(struct phy_device *phydev, u8 mode, u8 bank,
 
 	ereg |= (bank << 8) | offset;
 
+	/* DSP bank access workaround for lan937x */
+	if (phydev->phy_id == PHY_ID_LAN937X) {
+		rc = lan937x_dsp_workaround(phydev, ereg, bank);
+		if (rc < 0)
+			return rc;
+	}
+
 	rc = phy_write(phydev, LAN87XX_EXT_REG_CTL, ereg);
 	if (rc < 0)
 		return rc;
@@ -642,6 +684,16 @@ static struct phy_driver microchip_t1_phy_driver[] = {
 		.resume         = genphy_resume,
 		.cable_test_start = lan87xx_cable_test_start,
 		.cable_test_get_status = lan87xx_cable_test_get_status,
+	},
+	{
+		PHY_ID_MATCH_MODEL(PHY_ID_LAN937X),
+		.name		= "Microchip LAN937x T1",
+		.features	= PHY_BASIC_T1_FEATURES,
+		.config_init	= lan87xx_config_init,
+		.suspend	= genphy_suspend,
+		.resume		= genphy_resume,
+		.cable_test_start = lan87xx_cable_test_start,
+		.cable_test_get_status = lan87xx_cable_test_get_status,
 	}
 };
 
@@ -649,6 +701,7 @@ module_phy_driver(microchip_t1_phy_driver);
 
 static struct mdio_device_id __maybe_unused microchip_t1_tbl[] = {
 	{ PHY_ID_MATCH_MODEL(PHY_ID_LAN87XX) },
+	{ PHY_ID_MATCH_MODEL(PHY_ID_LAN937X) },
 	{ }
 };
 
-- 
2.33.0

