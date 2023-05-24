Return-Path: <netdev+bounces-5058-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F33E770F90A
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 16:46:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 35DF328106B
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 14:46:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9224A18C0B;
	Wed, 24 May 2023 14:46:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A8A6084A
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 14:46:12 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B23C198;
	Wed, 24 May 2023 07:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1684939558; x=1716475558;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IOW2mQwwE+kyQXOCEFL5atd8PojNqCYbkJrirSmYhlY=;
  b=HiBCgZ5nW+fy1+dJ/t76QWZGLu1daA7pf6wZ+qRIrDzl9sXE36XbXyYg
   U75dFhi2EWtVhmFTLE3FdU+sGKBWvm8Vl6OCrepDj7+fYWgyinip70pAv
   egljt5qAMnYSxFip9j7pDvAQklYp6GapcbQqNujWDh/YLDy0de7VKt+yN
   bsPorkDeA4HyMgOBJvTpbk3V/GVnBZPotzazs/mIqwrQfZUvr4RPIvljF
   IDPXx6Q/8BorgHWBb3E1n+5S87CEtJb9pLpbd/GzSevJZrYWKc9w619BG
   ksoAd4OfhJFiNXhVIe4aBWofuWdy2iOrTSTquxcz5WXWHaSmLnbNLgzro
   A==;
X-IronPort-AV: E=Sophos;i="6.00,189,1681196400"; 
   d="scan'208";a="226814349"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 May 2023 07:45:05 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 24 May 2023 07:45:04 -0700
Received: from CHE-LT-I17164LX.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Wed, 24 May 2023 07:44:59 -0700
From: Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
To: <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <ramon.nordin.rodriguez@ferroamp.se>
CC: <horatiu.vultur@microchip.com>, <Woojung.Huh@microchip.com>,
	<Nicolas.Ferre@microchip.com>, <Thorsten.Kummermehr@microchip.com>,
	"Parthiban Veerasooran" <Parthiban.Veerasooran@microchip.com>
Subject: [PATCH net-next v3 6/6] net: phy: microchip_t1s: add support for Microchip LAN865x Rev.B0 PHYs
Date: Wed, 24 May 2023 20:15:39 +0530
Message-ID: <20230524144539.62618-7-Parthiban.Veerasooran@microchip.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230524144539.62618-1-Parthiban.Veerasooran@microchip.com>
References: <20230524144539.62618-1-Parthiban.Veerasooran@microchip.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add support for the Microchip LAN865x Rev.B0 10BASE-T1S Internal PHYs
(LAN8650/1). The LAN865x combines a Media Access Controller (MAC) and an
internal 10BASE-T1S Ethernet PHY to access 10BASE‑T1S networks. As
LAN867X and LAN865X are using the same function for the read_status,
rename the function as lan86xx_read_status.

Signed-off-by: Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
---
 drivers/net/phy/microchip_t1s.c | 184 +++++++++++++++++++++++++++++++-
 1 file changed, 181 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/microchip_t1s.c b/drivers/net/phy/microchip_t1s.c
index 6f9e197d8623..00c4c23906ce 100644
--- a/drivers/net/phy/microchip_t1s.c
+++ b/drivers/net/phy/microchip_t1s.c
@@ -4,6 +4,7 @@
  *
  * Support: Microchip Phys:
  *  lan8670/1/2 Rev.B1
+ *  lan8650/1 Rev.B0 Internal PHYs
  */
 
 #include <linux/kernel.h>
@@ -11,11 +12,19 @@
 #include <linux/phy.h>
 
 #define PHY_ID_LAN867X_REVB1 0x0007C162
+#define PHY_ID_LAN865X_REVB0 0x0007C1B3
 
 #define LAN867X_REG_STS2 0x0019
 
 #define LAN867x_RESET_COMPLETE_STS BIT(11)
 
+#define LAN865X_REG_CFGPARAM_ADDR 0x00D8
+#define LAN865X_REG_CFGPARAM_DATA 0x00D9
+#define LAN865X_REG_CFGPARAM_CTRL 0x00DA
+#define LAN865X_REG_STS2 0x0019
+
+#define LAN865X_CFGPARAM_READ_ENABLE BIT(1)
+
 /* The arrays below are pulled from the following table from AN1699
  * Access MMD Address Value Mask
  * RMW 0x1F 0x00D0 0x0002 0x0E03
@@ -50,6 +59,164 @@ static const u16 lan867x_revb1_fixup_masks[12] = {
 	0x0600, 0x7F00, 0x2000, 0xFFFF,
 };
 
+/* LAN865x Rev.B0 configuration parameters from AN1760 */
+static const u32 lan865x_revb0_fixup_registers[28] = {
+	0x0091, 0x0081, 0x0043, 0x0044,
+	0x0045, 0x0053, 0x0054, 0x0055,
+	0x0040, 0x0050, 0x00D0, 0x00E9,
+	0x00F5, 0x00F4, 0x00F8, 0x00F9,
+	0x00B0, 0x00B1, 0x00B2, 0x00B3,
+	0x00B4, 0x00B5, 0x00B6, 0x00B7,
+	0x00B8, 0x00B9, 0x00BA, 0x00BB,
+};
+
+static const u16 lan865x_revb0_fixup_values[28] = {
+	0x9660, 0x00C0, 0x00FF, 0xFFFF,
+	0x0000, 0x00FF, 0xFFFF, 0x0000,
+	0x0002, 0x0002, 0x5F21, 0x9E50,
+	0x1CF8, 0xC020, 0x9B00, 0x4E53,
+	0x0103, 0x0910, 0x1D26, 0x002A,
+	0x0103, 0x070D, 0x1720, 0x0027,
+	0x0509, 0x0E13, 0x1C25, 0x002B,
+};
+
+static const u16 lan865x_revb0_fixup_cfg_regs[5] = {
+	0x0084, 0x008A, 0x00AD, 0x00AE, 0x00AF
+};
+
+/* Pulled from AN1760 describing 'indirect read'
+ *
+ * write_register(0x4, 0x00D8, addr)
+ * write_register(0x4, 0x00DA, 0x2)
+ * return (int8)(read_register(0x4, 0x00D9))
+ *
+ * 0x4 refers to memory map selector 4, which maps to MDIO_MMD_VEND2
+ */
+static int lan865x_revb0_indirect_read(struct phy_device *phydev, u16 addr)
+{
+	int ret;
+
+	ret = phy_write_mmd(phydev, MDIO_MMD_VEND2, LAN865X_REG_CFGPARAM_ADDR,
+			    addr);
+	if (ret)
+		return ret;
+
+	ret = phy_write_mmd(phydev, MDIO_MMD_VEND2, LAN865X_REG_CFGPARAM_CTRL,
+			    LAN865X_CFGPARAM_READ_ENABLE);
+	if (ret)
+		return ret;
+
+	return phy_read_mmd(phydev, MDIO_MMD_VEND2, LAN865X_REG_CFGPARAM_DATA);
+}
+
+/* This is pulled straight from AN1760 from 'calculation of offset 1' &
+ * 'calculation of offset 2'
+ */
+static int lan865x_generate_cfg_offsets(struct phy_device *phydev, s8 offsets[2])
+{
+	const u16 fixup_regs[2] = {0x0004, 0x0008};
+	int ret;
+
+	for (int i = 0; i < ARRAY_SIZE(fixup_regs); i++) {
+		ret = lan865x_revb0_indirect_read(phydev, fixup_regs[i]);
+		if (ret < 0)
+			return ret;
+		if (ret & BIT(4))
+			offsets[i] = ret | 0xE0;
+		else
+			offsets[i] = ret;
+	}
+
+	return 0;
+}
+
+static int lan865x_read_cfg_params(struct phy_device *phydev, u16 cfg_params[])
+{
+	int ret;
+
+	for (int i = 0; i < ARRAY_SIZE(lan865x_revb0_fixup_cfg_regs); i++) {
+		ret = phy_read_mmd(phydev, MDIO_MMD_VEND2,
+				   lan865x_revb0_fixup_cfg_regs[i]);
+		if (ret < 0)
+			return ret;
+		cfg_params[i] = (u16)ret;
+	}
+
+	return 0;
+}
+
+static int lan865x_write_cfg_params(struct phy_device *phydev, u16 cfg_params[])
+{
+	int ret;
+
+	for (int i = 0; i < ARRAY_SIZE(lan865x_revb0_fixup_cfg_regs); i++) {
+		ret = phy_write_mmd(phydev, MDIO_MMD_VEND2,
+				    lan865x_revb0_fixup_cfg_regs[i],
+				    cfg_params[i]);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int lan865x_setup_cfgparam(struct phy_device *phydev)
+{
+	u16 cfg_params[ARRAY_SIZE(lan865x_revb0_fixup_cfg_regs)];
+	u16 cfg_results[5];
+	s8 offsets[2];
+	int ret;
+
+	ret = lan865x_generate_cfg_offsets(phydev, offsets);
+	if (ret)
+		return ret;
+
+	ret = lan865x_read_cfg_params(phydev, cfg_params);
+	if (ret)
+		return ret;
+
+	cfg_results[0] = (cfg_params[0] & 0x000F) |
+			  FIELD_PREP(GENMASK(15, 10), 9 + offsets[0]) |
+			  FIELD_PREP(GENMASK(15, 4), 14 + offsets[0]);
+	cfg_results[1] = (cfg_params[1] & 0x03FF) |
+			  FIELD_PREP(GENMASK(15, 10), 40 + offsets[1]);
+	cfg_results[2] = (cfg_params[2] & 0xC0C0) |
+			  FIELD_PREP(GENMASK(15, 8), 5 + offsets[0]) |
+			  (9 + offsets[0]);
+	cfg_results[3] = (cfg_params[3] & 0xC0C0) |
+			  FIELD_PREP(GENMASK(15, 8), 9 + offsets[0]) |
+			  (14 + offsets[0]);
+	cfg_results[4] = (cfg_params[4] & 0xC0C0) |
+			  FIELD_PREP(GENMASK(15, 8), 17 + offsets[0]) |
+			  (22 + offsets[0]);
+
+	return lan865x_write_cfg_params(phydev, cfg_results);
+}
+
+static int lan865x_revb0_config_init(struct phy_device *phydev)
+{
+	int ret;
+
+	/* Reference to AN1760
+	 * https://ww1.microchip.com/downloads/aemDocuments/documents/AIS/ProductDocuments/SupportingCollateral/AN-LAN8650-1-Configuration-60001760.pdf
+	 */
+	for (int i = 0; i < ARRAY_SIZE(lan865x_revb0_fixup_registers); i++) {
+		ret = phy_write_mmd(phydev, MDIO_MMD_VEND2,
+				    lan865x_revb0_fixup_registers[i],
+				    lan865x_revb0_fixup_values[i]);
+		if (ret)
+			return ret;
+	}
+	/* Function to calculate and write the configuration parameters in the
+	 * 0x0084, 0x008A, 0x00AD, 0x00AE and 0x00AF registers (from AN1760)
+	 */
+	ret = lan865x_setup_cfgparam(phydev);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
 static int lan867x_revb1_config_init(struct phy_device *phydev)
 {
 	/* HW quirk: Microchip states in the application note (AN1699) for the phy
@@ -107,7 +274,7 @@ static int lan867x_revb1_config_init(struct phy_device *phydev)
 	return 0;
 }
 
-static int lan867x_read_status(struct phy_device *phydev)
+static int lan86xx_read_status(struct phy_device *phydev)
 {
 	/* The phy has some limitations, namely:
 	 *  - always reports link up
@@ -128,17 +295,28 @@ static struct phy_driver microchip_t1s_driver[] = {
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
+		.set_plca_cfg	    = genphy_c45_plca_set_cfg,
+		.get_plca_status    = genphy_c45_plca_get_status,
+	},
 };
 
 module_phy_driver(microchip_t1s_driver);
 
 static struct mdio_device_id __maybe_unused tbl[] = {
 	{ PHY_ID_MATCH_EXACT(PHY_ID_LAN867X_REVB1) },
+	{ PHY_ID_MATCH_EXACT(PHY_ID_LAN865X_REVB0) },
 	{ }
 };
 
-- 
2.34.1


