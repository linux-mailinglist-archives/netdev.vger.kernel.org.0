Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1F3360DADC
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 08:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233058AbiJZGAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 02:00:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233062AbiJZF7y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 01:59:54 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88AB326485;
        Tue, 25 Oct 2022 22:59:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666763983; x=1698299983;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=e5Kq3BI41zG7Mb7tUnxFyLEKFKAvkFrcPX3TCynoDug=;
  b=1NTGSoUoTgc0P3zIT18AIK/Q/eIKC0w8z8sbAp6ifiWgKTuvCGgPmmS4
   OudV9n+vF0yCRnUo3yZ3irYizTwqPAuF1PsDmc7juikMmLoQDEMEP0zUd
   E25GerY1FvClNzCZ4IsZ3t4qVaui6gQM0yXc2UJLyyHdh6XfuWImt+Afg
   RTx0g9IFRvfUIunJUMzF8lAPNtzykm6ORJu8ApXoHY4uz6LnnVibRog8N
   8oN+nJu+1NG1V1ZsmjYNB1b+uW+XVmlgHYTI2OZnFekfooL7FkZCnND7X
   pqWh6wPJLw4M5W0Q0fqhSwGOoyO/a9LI4igQhR+0460zyMoB5lyVvpe4V
   A==;
X-IronPort-AV: E=Sophos;i="5.95,213,1661842800"; 
   d="scan'208";a="197064979"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Oct 2022 22:59:38 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 25 Oct 2022 22:59:35 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 25 Oct 2022 22:59:31 -0700
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <lxu@maxlinear.com>,
        <hkallweit1@gmail.com>, <pabeni@redhat.com>, <edumazet@google.com>,
        <linux@armlinux.org.uk>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <Ian.Saturley@microchip.com>
Subject: [PATCH net-next V1 2/2] net: phy: mxl-gpy: Add PHY Auto/MDI/MDI-X set driver for GPY211 chips
Date:   Wed, 26 Oct 2022 11:29:18 +0530
Message-ID: <20221026055918.4225-3-Raju.Lakkaraju@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221026055918.4225-1-Raju.Lakkaraju@microchip.com>
References: <20221026055918.4225-1-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for MDI-X status and configuration for GPY211 chips

Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
---
Change List:
============

V0 -> V1:
 - Remove the error prints in driver functions
 - Change the gpy_update_interface() return type
 
 drivers/net/phy/mxl-gpy.c | 72 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 71 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/mxl-gpy.c b/drivers/net/phy/mxl-gpy.c
index 1383af3c2677..27c0f161623e 100644
--- a/drivers/net/phy/mxl-gpy.c
+++ b/drivers/net/phy/mxl-gpy.c
@@ -29,6 +29,10 @@
 #define PHY_ID_GPY241BM		0x67C9DE80
 #define PHY_ID_GPY245B		0x67C9DEC0
 
+#define PHY_CTL1		0x13
+#define PHY_CTL1_MDICD		BIT(3)
+#define PHY_CTL1_MDIAB		BIT(2)
+#define PHY_CTL1_AMDIX		BIT(0)
 #define PHY_MIISTAT		0x18	/* MII state */
 #define PHY_IMASK		0x19	/* interrupt mask */
 #define PHY_ISTAT		0x1A	/* interrupt status */
@@ -59,6 +63,13 @@
 #define PHY_FWV_MAJOR_MASK	GENMASK(11, 8)
 #define PHY_FWV_MINOR_MASK	GENMASK(7, 0)
 
+#define PHY_PMA_MGBT_POLARITY	0x82
+#define PHY_MDI_MDI_X_MASK	GENMASK(1, 0)
+#define PHY_MDI_MDI_X_NORMAL	0x3
+#define PHY_MDI_MDI_X_AB	0x2
+#define PHY_MDI_MDI_X_CD	0x1
+#define PHY_MDI_MDI_X_CROSS	0x0
+
 /* SGMII */
 #define VSPEC1_SGMII_CTRL	0x08
 #define VSPEC1_SGMII_CTRL_ANEN	BIT(12)		/* Aneg enable */
@@ -289,6 +300,33 @@ static bool gpy_sgmii_aneg_en(struct phy_device *phydev)
 	return (ret & VSPEC1_SGMII_CTRL_ANEN) ? true : false;
 }
 
+static int gpy_config_mdix(struct phy_device *phydev, u8 ctrl)
+{
+	int ret;
+	u16 val;
+
+	switch (ctrl) {
+	case ETH_TP_MDI_AUTO:
+		val = PHY_CTL1_AMDIX;
+		break;
+	case ETH_TP_MDI_X:
+		val = (PHY_CTL1_MDIAB | PHY_CTL1_MDICD);
+		break;
+	case ETH_TP_MDI:
+		val = 0;
+		break;
+	default:
+		return 0;
+	}
+
+	ret =  phy_modify(phydev, PHY_CTL1, PHY_CTL1_AMDIX | PHY_CTL1_MDIAB |
+			  PHY_CTL1_MDICD, val);
+	if (ret < 0)
+		return ret;
+
+	return genphy_c45_restart_aneg(phydev);
+}
+
 static int gpy_config_aneg(struct phy_device *phydev)
 {
 	bool changed = false;
@@ -304,6 +342,10 @@ static int gpy_config_aneg(struct phy_device *phydev)
 			: genphy_c45_pma_setup_forced(phydev);
 	}
 
+	ret = gpy_config_mdix(phydev,  phydev->mdix_ctrl);
+	if (ret < 0)
+		return ret;
+
 	ret = genphy_c45_an_config_aneg(phydev);
 	if (ret < 0)
 		return ret;
@@ -370,6 +412,34 @@ static int gpy_config_aneg(struct phy_device *phydev)
 			      VSPEC1_SGMII_CTRL_ANRS, VSPEC1_SGMII_CTRL_ANRS);
 }
 
+static int gpy_update_mdix(struct phy_device *phydev)
+{
+	int ret;
+
+	ret = phy_read(phydev, PHY_CTL1);
+	if (ret < 0)
+		return ret;
+
+	if (ret & PHY_CTL1_AMDIX)
+		phydev->mdix_ctrl = ETH_TP_MDI_AUTO;
+	else
+		if (ret & PHY_CTL1_MDICD || ret & PHY_CTL1_MDIAB)
+			phydev->mdix_ctrl = ETH_TP_MDI_X;
+		else
+			phydev->mdix_ctrl = ETH_TP_MDI;
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, PHY_PMA_MGBT_POLARITY);
+	if (ret < 0)
+		return ret;
+
+	if ((ret & PHY_MDI_MDI_X_MASK) < PHY_MDI_MDI_X_NORMAL)
+		phydev->mdix = ETH_TP_MDI_X;
+	else
+		phydev->mdix = ETH_TP_MDI;
+
+	return 0;
+}
+
 static int gpy_update_interface(struct phy_device *phydev)
 {
 	int ret;
@@ -421,7 +491,7 @@ static int gpy_update_interface(struct phy_device *phydev)
 			return ret;
 	}
 
-	return 0;
+	return gpy_update_mdix(phydev);
 }
 
 static int gpy_read_status(struct phy_device *phydev)
-- 
2.25.1

