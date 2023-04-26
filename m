Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA1AA6EF39F
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 13:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240579AbjDZLqU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 07:46:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240422AbjDZLqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 07:46:18 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DAFC49E1
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 04:46:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1682509577; x=1714045577;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=a6mOPezioK3go7z7Pd63E0ERcqekT30pCSfT1pZTASI=;
  b=bClx8R3KlgKWyaOdis5uVosC8T8AQDb4WVaxDOAt75VGGEDVWpNHXiTR
   MAAZKtyFvLvED6Npog/V+kHyZIjgshB5ivsekMtyUM3yee9qYlOxGC1p0
   qVjapVkQS19baf/UWWRp/W5bsLubt+J16HCJOrq8fW5EiII3cR58nyHvT
   1AdOoB2UFbXyAucHIdUX1i1jgCdTO+XvRAlzy/DPi6/s8KW8hqCofGiIG
   VJQnWe/pA1jMOFLw6lYz6fASdQcNdfpc/p1fwqMKyp6ADbZ0bMRzbkEjr
   5+brTL0R2hHAWKpAmoCNZlMf93JfeyLfZulmygdjfmxVeXzuQq3H8b8gl
   w==;
X-IronPort-AV: E=Sophos;i="5.99,227,1677567600"; 
   d="scan'208";a="149009051"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 Apr 2023 04:46:17 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 26 Apr 2023 04:46:16 -0700
Received: from CHE-LT-I17164LX.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Wed, 26 Apr 2023 04:46:14 -0700
From:   Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
To:     <netdev@vger.kernel.org>, <andrew@lunn.ch>, <davem@davemloft.net>
CC:     <jan.huber@microchip.com>, <thorsten.kummermehr@microchip.com>,
        <ramon.nordin.rodriguez@ferroamp.se>,
        Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
Subject: [PATCH net-next 2/2] net: phy: microchip_t1s: add support for Microchip LAN865x Rev.B0 PHYs
Date:   Wed, 26 Apr 2023 17:16:55 +0530
Message-ID: <20230426114655.93672-3-Parthiban.Veerasooran@microchip.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230426114655.93672-1-Parthiban.Veerasooran@microchip.com>
References: <20230426114655.93672-1-Parthiban.Veerasooran@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for the Microchip LAN865x Rev.B0 10BASE-T1S
Internal PHYs (LAN8650/1). The LAN865x combines a Media Access Controller
(MAC) and an internal 10BASE-T1S Ethernet PHY to access 10BASE‑T1S
networks.

Signed-off-by: Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
---
 drivers/net/phy/microchip_t1s.c | 200 ++++++++++++++++++++++++++++++--
 1 file changed, 191 insertions(+), 9 deletions(-)

diff --git a/drivers/net/phy/microchip_t1s.c b/drivers/net/phy/microchip_t1s.c
index 793fb0210605..3d8d285b3c34 100644
--- a/drivers/net/phy/microchip_t1s.c
+++ b/drivers/net/phy/microchip_t1s.c
@@ -4,6 +4,7 @@
  *
  * Support: Microchip Phys:
  *  lan8670/1/2 Rev.B1
+ *  lan8650/1 Rev.B0 Internal PHYs
  */
 
 #include <linux/kernel.h>
@@ -11,9 +12,10 @@
 #include <linux/phy.h>
 
 #define PHY_ID_LAN867X_REVB1 0x0007C162
+#define PHY_ID_LAN865X_REVB0 0x0007C1B3
 
-#define LAN867X_REG_IRQ_1_CTL 0x001C
-#define LAN867X_REG_IRQ_2_CTL 0x001D
+#define LAN86XX_REG_IRQ_1_CTL 0x001C
+#define LAN86XX_REG_IRQ_2_CTL 0x001D
 
 /* The arrays below are pulled from the following table from AN1699
  * Access MMD Address Value Mask
@@ -49,6 +51,174 @@ static const int lan867x_revb1_fixup_masks[12] = {
 	0x0600, 0x7F00, 0x2000, 0xFFFF,
 };
 
+/* LAN865x Rev.B0 configuration parameters from AN1760
+ */
+static const int lan865x_revb0_fixup_registers[28] = {
+	0x0091, 0x0081, 0x0043, 0x0044,
+	0x0045, 0x0053, 0x0054, 0x0055,
+	0x0040, 0x0050, 0x00D0, 0x00E9,
+	0x00F5, 0x00F4, 0x00F8, 0x00F9,
+	0x00B0, 0x00B1, 0x00B2, 0x00B3,
+	0x00B4, 0x00B5, 0x00B6, 0x00B7,
+	0x00B8, 0x00B9, 0x00BA, 0x00BB,
+};
+
+static const int lan865x_revb0_fixup_values[28] = {
+	0x9660, 0x00C0, 0x00FF, 0xFFFF,
+	0x0000, 0x00FF, 0xFFFF, 0x0000,
+	0x0002, 0x0002, 0x5F21, 0x9E50,
+	0x1CF8, 0xC020, 0x9B00, 0x4E53,
+	0x0103, 0x0910, 0x1D26, 0x002A,
+	0x0103, 0x070D, 0x1720, 0x0027,
+	0x0509, 0x0E13, 0x1C25, 0x002B,
+};
+
+/* indirect read pseudocode from AN1760
+ * write_register(0x4, 0x00D8, addr)
+ * write_register(0x4, 0x00DA, 0x2)
+ * return (int8)(read_register(0x4, 0x00D9))
+ */
+static int lan865x_revb0_indirect_read(struct phy_device *phydev, u16 addr)
+{
+	int ret;
+
+	ret = phy_write_mmd(phydev, MDIO_MMD_VEND2, 0xD8, addr);
+	if (ret)
+		return ret;
+
+	ret = phy_write_mmd(phydev, MDIO_MMD_VEND2, 0xDA, 0x0002);
+	if (ret)
+		return ret;
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_VEND2, 0xD9);
+	if (ret < 0)
+		return ret;
+
+	return ret;
+}
+
+static int lan865x_setup_cfgparam(struct phy_device *phydev)
+{
+	s8 offset1;
+	s8 offset2;
+	s8 value;
+	u16 cfgparam;
+	int ret;
+
+	ret = lan865x_revb0_indirect_read(phydev, 0x0004);
+	if (ret < 0)
+		return ret;
+	value = (s8)ret;
+	/* Calculation of configuration offset 1 from AN1760
+	 */
+	if ((value & 0x10) != 0)
+		offset1 = value | 0xE0;
+	else
+		offset1 = value;
+
+	ret = lan865x_revb0_indirect_read(phydev, 0x0008);
+	if (ret < 0)
+		return ret;
+	value = (s8)ret;
+	/* Calculation of configuration offset 2 from AN1760
+	 */
+	if ((value & 0x10) != 0)
+		offset2 = value | 0xE0;
+	else
+		offset2 = value;
+
+	/* calculate and write the configuration parameters in the
+	 * 0x0084, 0x008A, 0x00AD, 0x00AE and 0x00AF registers (from AN1760)
+	 */
+	ret = phy_read_mmd(phydev, MDIO_MMD_VEND2, 0x0084);
+	if (ret < 0)
+		return ret;
+	cfgparam = (ret & 0xF) | (((9 + offset1) << 10) |
+		    ((14 + offset1) << 4));
+	ret = phy_write_mmd(phydev, MDIO_MMD_VEND2, 0x84, cfgparam);
+	if (ret)
+		return ret;
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_VEND2, 0x008A);
+	if (ret < 0)
+		return ret;
+	cfgparam = (ret & 0x3FF) | ((40 + offset2) << 10);
+	ret = phy_write_mmd(phydev, MDIO_MMD_VEND2, 0x8A, cfgparam);
+	if (ret)
+		return ret;
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_VEND2, 0x00AD);
+	if (ret < 0)
+		return ret;
+	cfgparam = (ret & 0xC0C0) | (((5 + offset1) << 8) | (9 + offset1));
+	ret = phy_write_mmd(phydev, MDIO_MMD_VEND2, 0xAD, cfgparam);
+	if (ret)
+		return ret;
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_VEND2, 0x00AE);
+	if (ret < 0)
+		return ret;
+	cfgparam = (ret & 0xC0C0) | (((9 + offset1) << 8) | (14 + offset1));
+	ret = phy_write_mmd(phydev, MDIO_MMD_VEND2, 0xAE, cfgparam);
+	if (ret)
+		return ret;
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_VEND2, 0x00AF);
+	if (ret < 0)
+		return ret;
+	cfgparam = (ret & 0xC0C0) | (((17 + offset1) << 8) | (22 + offset1));
+	return phy_write_mmd(phydev, MDIO_MMD_VEND2, 0xAF, cfgparam);
+}
+
+static int lan865x_revb0_config_init(struct phy_device *phydev)
+{
+	int addr;
+	int value;
+	int ret;
+
+	/* As per AN1760, the below configuration applies only to the LAN8650/1
+	 * hardware revision Rev.B0.
+	 */
+	for (int i = 0; i < ARRAY_SIZE(lan865x_revb0_fixup_registers); i++) {
+		addr = lan865x_revb0_fixup_registers[i];
+		value = lan865x_revb0_fixup_values[i];
+		ret = phy_write_mmd(phydev, MDIO_MMD_VEND2, addr, value);
+		if (ret)
+			return ret;
+	}
+	/* function to calculate and write the configuration parameters in the
+	 * 0x0084, 0x008A, 0x00AD, 0x00AE and 0x00AF registers (from AN1760)
+	 */
+	ret = lan865x_setup_cfgparam(phydev);
+	if (ret < 0)
+		return ret;
+
+	/* disable all the interrupts
+	 */
+	ret = phy_write_mmd(phydev, MDIO_MMD_VEND2, LAN86XX_REG_IRQ_1_CTL, 0xFFFF);
+	if (ret)
+		return ret;
+	return phy_write_mmd(phydev, MDIO_MMD_VEND2, LAN86XX_REG_IRQ_2_CTL, 0xFFFF);
+}
+
+static int lan865x_revb0_plca_set_cfg(struct phy_device *phydev,
+				      const struct phy_plca_cfg *plca_cfg)
+{
+	int ret;
+
+	ret = genphy_c45_plca_set_cfg(phydev, plca_cfg);
+	if (ret)
+		return ret;
+
+	/* Disable the collision detection when PLCA is enabled and enable
+	 * collision detection when CSMA/CD mode is enabled.
+	 */
+	if (plca_cfg->enabled)
+		return phy_write_mmd(phydev, MDIO_MMD_VEND2, 0x0087, 0x0000);
+	else
+		return phy_write_mmd(phydev, MDIO_MMD_VEND2, 0x0087, 0x0083);
+}
+
 static int lan867x_revb1_config_init(struct phy_device *phydev)
 {
 	/* HW quirk: Microchip states in the application note (AN1699) for the phy
@@ -90,13 +260,13 @@ static int lan867x_revb1_config_init(struct phy_device *phydev)
 	 * for it either.
 	 * So we'll just disable all interrupts on the chip.
 	 */
-	err = phy_write_mmd(phydev, MDIO_MMD_VEND2, LAN867X_REG_IRQ_1_CTL, 0xFFFF);
+	err = phy_write_mmd(phydev, MDIO_MMD_VEND2, LAN86XX_REG_IRQ_1_CTL, 0xFFFF);
 	if (err != 0)
 		return err;
-	return phy_write_mmd(phydev, MDIO_MMD_VEND2, LAN867X_REG_IRQ_2_CTL, 0xFFFF);
+	return phy_write_mmd(phydev, MDIO_MMD_VEND2, LAN86XX_REG_IRQ_2_CTL, 0xFFFF);
 }
 
-static int lan867x_read_status(struct phy_device *phydev)
+static int lan86xx_read_status(struct phy_device *phydev)
 {
 	/* The phy has some limitations, namely:
 	 *  - always reports link up
@@ -111,23 +281,34 @@ static int lan867x_read_status(struct phy_device *phydev)
 	return 0;
 }
 
-static struct phy_driver lan867x_revb1_driver[] = {
+static struct phy_driver lan86xx_driver[] = {
 	{
 		PHY_ID_MATCH_EXACT(PHY_ID_LAN867X_REVB1),
 		.name               = "LAN867X Rev.B1",
 		.features           = PHY_BASIC_T1S_P2MP_FEATURES,
 		.config_init        = lan867x_revb1_config_init,
-		.read_status        = lan867x_read_status,
+		.read_status        = lan86xx_read_status,
 		.get_plca_cfg	    = genphy_c45_plca_get_cfg,
 		.set_plca_cfg	    = genphy_c45_plca_set_cfg,
 		.get_plca_status    = genphy_c45_plca_get_status,
-	}
+	},
+	{
+		PHY_ID_MATCH_EXACT(PHY_ID_LAN865X_REVB0),
+		.name               = "LAN865X Rev.B0 Internal Phy",
+		.features           = PHY_BASIC_T1S_P2MP_FEATURES,
+		.config_init        = lan865x_revb0_config_init,
+		.read_status        = lan86xx_read_status,
+		.get_plca_cfg	    = genphy_c45_plca_get_cfg,
+		.set_plca_cfg	    = lan865x_revb0_plca_set_cfg,
+		.get_plca_status    = genphy_c45_plca_get_status,
+	},
 };
 
-module_phy_driver(lan867x_revb1_driver);
+module_phy_driver(lan86xx_driver);
 
 static struct mdio_device_id __maybe_unused tbl[] = {
 	{ PHY_ID_MATCH_EXACT(PHY_ID_LAN867X_REVB1) },
+	{ PHY_ID_MATCH_EXACT(PHY_ID_LAN865X_REVB0) },
 	{ }
 };
 
@@ -135,4 +316,5 @@ MODULE_DEVICE_TABLE(mdio, tbl);
 
 MODULE_DESCRIPTION("Microchip 10BASE-T1S Phy driver");
 MODULE_AUTHOR("Ramón Nordin Rodriguez");
+MODULE_AUTHOR("Parthiban Veerasooran <parthiban.veerasooran@microchip.com>");
 MODULE_LICENSE("GPL");
-- 
2.34.1

