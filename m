Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15F6A568453
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 11:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232353AbiGFJwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 05:52:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232300AbiGFJwK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 05:52:10 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD60924082;
        Wed,  6 Jul 2022 02:52:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1657101130; x=1688637130;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=om/UZBrb2XM7I9JkRLhYt07766ef5nyevWuoEb4xepc=;
  b=fL7Yq/NPRTSc7mOzIDjHQQLFenMOK+2CGSEhJIxcuz006wfsNapYe3zi
   9pbjh1a/EWMTbSOFmbqnLuCnAtWvXcx6ghddgPMPUxTRJ42vObqlo8PLz
   NLOs8ABDYsgMz2BegLBZnu1Ow+Sb3xjsBnEhePrH6ZoW5Sa5DKdy4F00f
   l4HAOA0lJQoLOSzqDW81s3DGNyy+Goi96UxTfid6rhrWvW3Te/Cq8iuo4
   x4R0GBRDoj9gN/+J2h4MJ7/1gug8jsIFR50VXLpQwjli1t4S9Va3StvLR
   LVjgrKkdvZjaXnbtcCl8Ru96A9MJViw3qG2wtmfF3klVvgEX1/vYSMtmO
   g==;
X-IronPort-AV: E=Sophos;i="5.92,249,1650956400"; 
   d="scan'208";a="163537889"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Jul 2022 02:52:09 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 6 Jul 2022 02:52:08 -0700
Received: from wendy.microchip.com (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Wed, 6 Jul 2022 02:52:05 -0700
From:   Conor Dooley <conor.dooley@microchip.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        "Conor Dooley" <conor.dooley@microchip.com>
Subject: [net-next PATCH v3 5/5] net: macb: sort init_reset_optional() with other init()s
Date:   Wed, 6 Jul 2022 10:51:29 +0100
Message-ID: <20220706095129.828253-6-conor.dooley@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220706095129.828253-1-conor.dooley@microchip.com>
References: <20220706095129.828253-1-conor.dooley@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

init_reset_optional() is somewhat oddly placed amidst the macb_config
struct definitions. Move it to a more reasonable location alongside
the fu540 init functions.

Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 68 ++++++++++++------------
 1 file changed, 34 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 4423d99c72a7..36a659f2a289 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4600,6 +4600,40 @@ static int fu540_c000_init(struct platform_device *pdev)
 	return macb_init(pdev);
 }
 
+static int init_reset_optional(struct platform_device *pdev)
+{
+	struct net_device *dev = platform_get_drvdata(pdev);
+	struct macb *bp = netdev_priv(dev);
+	int ret;
+
+	if (bp->phy_interface == PHY_INTERFACE_MODE_SGMII) {
+		/* Ensure PHY device used in SGMII mode is ready */
+		bp->sgmii_phy = devm_phy_optional_get(&pdev->dev, NULL);
+
+		if (IS_ERR(bp->sgmii_phy))
+			return dev_err_probe(&pdev->dev, PTR_ERR(bp->sgmii_phy),
+					     "failed to get SGMII PHY\n");
+
+		ret = phy_init(bp->sgmii_phy);
+		if (ret)
+			return dev_err_probe(&pdev->dev, ret,
+					     "failed to init SGMII PHY\n");
+	}
+
+	/* Fully reset controller at hardware level if mapped in device tree */
+	ret = device_reset_optional(&pdev->dev);
+	if (ret) {
+		phy_exit(bp->sgmii_phy);
+		return dev_err_probe(&pdev->dev, ret, "failed to reset controller");
+	}
+
+	ret = macb_init(pdev);
+	if (ret)
+		phy_exit(bp->sgmii_phy);
+
+	return ret;
+}
+
 static const struct macb_usrio_config sama7g5_usrio = {
 	.mii = 0,
 	.rmii = 1,
@@ -4689,40 +4723,6 @@ static const struct macb_config np4_config = {
 	.usrio = &macb_default_usrio,
 };
 
-static int init_reset_optional(struct platform_device *pdev)
-{
-	struct net_device *dev = platform_get_drvdata(pdev);
-	struct macb *bp = netdev_priv(dev);
-	int ret;
-
-	if (bp->phy_interface == PHY_INTERFACE_MODE_SGMII) {
-		/* Ensure PHY device used in SGMII mode is ready */
-		bp->sgmii_phy = devm_phy_optional_get(&pdev->dev, NULL);
-
-		if (IS_ERR(bp->sgmii_phy))
-			return dev_err_probe(&pdev->dev, PTR_ERR(bp->sgmii_phy),
-					     "failed to get SGMII PHY\n");
-
-		ret = phy_init(bp->sgmii_phy);
-		if (ret)
-			return dev_err_probe(&pdev->dev, ret,
-					     "failed to init SGMII PHY\n");
-	}
-
-	/* Fully reset controller at hardware level if mapped in device tree */
-	ret = device_reset_optional(&pdev->dev);
-	if (ret) {
-		phy_exit(bp->sgmii_phy);
-		return dev_err_probe(&pdev->dev, ret, "failed to reset controller");
-	}
-
-	ret = macb_init(pdev);
-	if (ret)
-		phy_exit(bp->sgmii_phy);
-
-	return ret;
-}
-
 static const struct macb_config zynqmp_config = {
 	.caps = MACB_CAPS_GIGABIT_MODE_AVAILABLE |
 		MACB_CAPS_JUMBO |
-- 
2.36.1

