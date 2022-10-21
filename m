Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE2AB606FBA
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 07:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbiJUF5j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 01:57:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbiJUF5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 01:57:17 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6549232E4A;
        Thu, 20 Oct 2022 22:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666331834; x=1697867834;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IN5dARwTPVNqEfYY1oKuULXoIYX0VYI8h0OnJQpkk9k=;
  b=LIgHf147mxZB/yVjtM7RIqJ335vH0HPCLe1WYsF1wD4eFvmcNw4De9s9
   fRmfyxxisWjAyAr3OOKn602e/Kb2i5d+1hWwNqdBgZtEhuqHIslPCqWFX
   vAHbBvmdjm0BLY4x3UdvqzF/r00Hn1uqnKqaW8YlO4XYF+CmjOM/lZhfC
   2hwxMXkw7vj6tOIQoobyK1X3mawp3Qco2o7bd9F3giNOrlmIODeUruicb
   yMRJXZuoLSONZlLDHOVLYdyIUkAX36hqfhWvn6hMGIklJWcOHl8nI1riB
   LoQb8G9D/YuhOtWitLgjrFAQLK6xN3Rz+l6/OW7X4UgSYy59kptxR2hzR
   w==;
X-IronPort-AV: E=Sophos;i="5.95,200,1661842800"; 
   d="scan'208";a="185688244"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Oct 2022 22:57:12 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 20 Oct 2022 22:57:11 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Thu, 20 Oct 2022 22:57:07 -0700
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <bryan.whitehead@microchip.com>,
        <hkallweit1@gmail.com>, <pabeni@redhat.com>, <edumazet@google.com>,
        <linux@armlinux.org.uk>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <Ian.Saturley@microchip.com>
Subject: [PATCH net-next 2/2] net: phy: micrel: Add PHY Auto/MDI/MDI-X set driver for KSZ9131
Date:   Fri, 21 Oct 2022 11:26:42 +0530
Message-ID: <20221021055642.255413-3-Raju.Lakkaraju@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221021055642.255413-1-Raju.Lakkaraju@microchip.com>
References: <20221021055642.255413-1-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for MDI-X status and configuration for KSZ9131 chips

Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
---
 drivers/net/phy/micrel.c | 77 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 77 insertions(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 54a17b576eac..40aa52d442f8 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1295,6 +1295,81 @@ static int ksz9131_config_init(struct phy_device *phydev)
 	return 0;
 }
 
+#define MII_KSZPHY_AUTO_MDIX		0x1C
+#define MII_KSZPHY_AUTO_MDI_SET_	BIT(7)
+#define MII_KSZPHY_AUTO_MDIX_SWAP_OFF_	BIT(6)
+
+static int ksz9131_mdix_update(struct phy_device *phydev)
+{
+	int ret;
+
+	ret = phy_read(phydev, MII_KSZPHY_AUTO_MDIX);
+	if (ret < 0)
+		return ret;
+
+	if (ret & MII_KSZPHY_AUTO_MDIX_SWAP_OFF_) {
+		if (ret & MII_KSZPHY_AUTO_MDI_SET_)
+			phydev->mdix_ctrl = ETH_TP_MDI;
+		else
+			phydev->mdix_ctrl = ETH_TP_MDI_X;
+	} else {
+		phydev->mdix_ctrl = ETH_TP_MDI_AUTO;
+	}
+
+	if (ret & MII_KSZPHY_AUTO_MDI_SET_)
+		phydev->mdix = ETH_TP_MDI;
+	else
+		phydev->mdix = ETH_TP_MDI_X;
+
+	return 0;
+}
+
+static int ksz9131_config_mdix(struct phy_device *phydev, u8 ctrl)
+{
+	u16 val;
+
+	switch (ctrl) {
+	case ETH_TP_MDI:
+		val = MII_KSZPHY_AUTO_MDIX_SWAP_OFF_ |
+		      MII_KSZPHY_AUTO_MDI_SET_;
+		break;
+	case ETH_TP_MDI_X:
+		val = MII_KSZPHY_AUTO_MDIX_SWAP_OFF_;
+		break;
+	case ETH_TP_MDI_AUTO:
+		val = 0;
+		break;
+	default:
+		return 0;
+	}
+
+	return phy_modify(phydev, MII_KSZPHY_AUTO_MDIX,
+			  MII_KSZPHY_AUTO_MDIX_SWAP_OFF_ |
+			  MII_KSZPHY_AUTO_MDI_SET_, val);
+}
+
+static int ksz9131_read_status(struct phy_device *phydev)
+{
+	int ret;
+
+	ret = ksz9131_mdix_update(phydev);
+	if (ret < 0)
+		return ret;
+
+	return genphy_read_status(phydev);
+}
+
+static int ksz9131_config_aneg(struct phy_device *phydev)
+{
+	int ret;
+
+	ret = genphy_config_aneg(phydev);
+	if (ret)
+		return ret;
+
+	return ksz9131_config_mdix(phydev, phydev->mdix_ctrl);
+}
+
 #define KSZ8873MLL_GLOBAL_CONTROL_4	0x06
 #define KSZ8873MLL_GLOBAL_CONTROL_4_DUPLEX	BIT(6)
 #define KSZ8873MLL_GLOBAL_CONTROL_4_SPEED	BIT(4)
@@ -3304,6 +3379,8 @@ static struct phy_driver ksphy_driver[] = {
 	.probe		= kszphy_probe,
 	.config_init	= ksz9131_config_init,
 	.config_intr	= kszphy_config_intr,
+	.config_aneg	= ksz9131_config_aneg,
+	.read_status	= ksz9131_read_status,
 	.handle_interrupt = kszphy_handle_interrupt,
 	.get_sset_count = kszphy_get_sset_count,
 	.get_strings	= kszphy_get_strings,
-- 
2.25.1

