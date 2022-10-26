Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4485D60DAD7
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 07:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233022AbiJZF7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 01:59:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233007AbiJZF7d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 01:59:33 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C2AABC9E;
        Tue, 25 Oct 2022 22:59:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666763972; x=1698299972;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=g49TENwrwgphz8+ho5iXZTZ4lIXRuj0bNxSD+27xs5E=;
  b=Pqch0BTWPKg8jHpUkl2YNabneLd6UamsVCMxtXiKR5Si/DCGpVosk/OL
   P4rNkssI4qUgT1cliIYm0zBqSL7tHNkqWHCRxhV1k/VWOTj9fAqrW0Gi9
   9cxvPySbzxUYDmz+x7e9+oiE4zARLsq1ztG6NVxAVBScOZhpjm9fWQ8xz
   Mu03DAkLS8miEMDmepYlKhF7ugxhWTGuQKRS8jLVg9Dz1Op6UCV7vZ/a+
   yttXXG34zT1O1uoE6McJ9A1hg9k00JGssIb3sPIjeFaEsabcbOZAzkvnD
   WCRz7wlZhpSy9tJkahv1vF9uocKh6AMIrl2MI7/Rn4VuvkeCehxLS3MED
   w==;
X-IronPort-AV: E=Sophos;i="5.95,213,1661842800"; 
   d="scan'208";a="180546094"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Oct 2022 22:59:31 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 25 Oct 2022 22:59:31 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 25 Oct 2022 22:59:27 -0700
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <lxu@maxlinear.com>,
        <hkallweit1@gmail.com>, <pabeni@redhat.com>, <edumazet@google.com>,
        <linux@armlinux.org.uk>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <Ian.Saturley@microchip.com>
Subject: [PATCH net-next V1 1/2] net: phy: mxl-gpy: Change gpy_update_interface() function return type
Date:   Wed, 26 Oct 2022 11:29:17 +0530
Message-ID: <20221026055918.4225-2-Raju.Lakkaraju@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221026055918.4225-1-Raju.Lakkaraju@microchip.com>
References: <20221026055918.4225-1-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

gpy_update_interface() is called from gpy_read_status() which does
return error codes. gpy_read_status() would benefit from returning
-EINVAL, etc.

Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
---
 drivers/net/phy/mxl-gpy.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/net/phy/mxl-gpy.c b/drivers/net/phy/mxl-gpy.c
index 24bae27eedef..1383af3c2677 100644
--- a/drivers/net/phy/mxl-gpy.c
+++ b/drivers/net/phy/mxl-gpy.c
@@ -370,14 +370,14 @@ static int gpy_config_aneg(struct phy_device *phydev)
 			      VSPEC1_SGMII_CTRL_ANRS, VSPEC1_SGMII_CTRL_ANRS);
 }
 
-static void gpy_update_interface(struct phy_device *phydev)
+static int gpy_update_interface(struct phy_device *phydev)
 {
 	int ret;
 
 	/* Interface mode is fixed for USXGMII and integrated PHY */
 	if (phydev->interface == PHY_INTERFACE_MODE_USXGMII ||
 	    phydev->interface == PHY_INTERFACE_MODE_INTERNAL)
-		return;
+		return -EINVAL;
 
 	/* Automatically switch SERDES interface between SGMII and 2500-BaseX
 	 * according to speed. Disable ANEG in 2500-BaseX mode.
@@ -387,10 +387,12 @@ static void gpy_update_interface(struct phy_device *phydev)
 		phydev->interface = PHY_INTERFACE_MODE_2500BASEX;
 		ret = phy_modify_mmd(phydev, MDIO_MMD_VEND1, VSPEC1_SGMII_CTRL,
 				     VSPEC1_SGMII_CTRL_ANEN, 0);
-		if (ret < 0)
+		if (ret < 0) {
 			phydev_err(phydev,
 				   "Error: Disable of SGMII ANEG failed: %d\n",
 				   ret);
+			return ret;
+		}
 		break;
 	case SPEED_1000:
 	case SPEED_100:
@@ -404,15 +406,22 @@ static void gpy_update_interface(struct phy_device *phydev)
 		ret = phy_modify_mmd(phydev, MDIO_MMD_VEND1, VSPEC1_SGMII_CTRL,
 				     VSPEC1_SGMII_ANEN_ANRS,
 				     VSPEC1_SGMII_ANEN_ANRS);
-		if (ret < 0)
+		if (ret < 0) {
 			phydev_err(phydev,
 				   "Error: Enable of SGMII ANEG failed: %d\n",
 				   ret);
+			return ret;
+		}
 		break;
 	}
 
-	if (phydev->speed == SPEED_2500 || phydev->speed == SPEED_1000)
-		genphy_read_master_slave(phydev);
+	if (phydev->speed == SPEED_2500 || phydev->speed == SPEED_1000) {
+		ret = genphy_read_master_slave(phydev);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
 }
 
 static int gpy_read_status(struct phy_device *phydev)
@@ -463,8 +472,11 @@ static int gpy_read_status(struct phy_device *phydev)
 		break;
 	}
 
-	if (phydev->link)
-		gpy_update_interface(phydev);
+	if (phydev->link) {
+		ret = gpy_update_interface(phydev);
+		if (ret < 0)
+			return ret;
+	}
 
 	return 0;
 }
-- 
2.25.1

