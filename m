Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA1A2CEE22
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 13:36:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388063AbgLDMft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 07:35:49 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:51237 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgLDMfs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 07:35:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607085348; x=1638621348;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=UcUlJBmSMSOmv9XOQ1o8b3C5jJGReV2lY9LYt+kzBJI=;
  b=gUr5vZeErRqK5LgvLP1jF8tL+eJHbE2UbwLSWZqSpLA6n4pnamzYWZES
   YmuubrPBFiDHpdpjwAO4R0PkRuoyVHX0u29RPhZcnhaowz1BkQqFOJ9uE
   VLuC+G8gTEEkfQHmkLbFqDPNNUuvVe7rio9HHRq2bXnVtHQnVO7W3DNZd
   ClonRmzMNbAG3sOUmvinJ3oemZhaut0aivFhK78jJnlNaHWJTWJml70jY
   tV3ErlkOgSf58m3lyaJdmlZUWTTfkn7Qxl5C8aTz5+Y6NVBIEG+1oSCfF
   /I33mpXaYcRNAAIP4z00B2v/tJxpOoMrpS11fQ895rpJcRwhka8uaUlNe
   w==;
IronPort-SDR: H0uz4UleAmEnesn+ycDTYguScnHPR4FSqtfBx7lTGbHkWFrIW+HXGanO2fthaLOyWSoyz16RIH
 mTOL5BwV2zlx9NP6t9RtzsuhfDdahIlC2aH5ubx7Z7NGvQ/EsXwN0niPVfnWdJ9QySYRfKENCy
 9TFSKZRLD/4LDIrBg9Zqk/kHlhT07W9KRqNXGf1TcEhHWAw/+xfupGJJ4MbrsfCpP2DUWXBw8O
 nbcK6+/4CixT8Xe6gYZRRJ8m3F4C57HUNK5gAYzLByBLoLJzyv0BdZgp2qxjzhTujymrtCfd6G
 iLk=
X-IronPort-AV: E=Sophos;i="5.78,392,1599548400"; 
   d="scan'208";a="101477134"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Dec 2020 05:34:42 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 4 Dec 2020 05:34:42 -0700
Received: from m18063-ThinkPad-T460p.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Fri, 4 Dec 2020 05:34:35 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <nicolas.ferre@microchip.com>, <linux@armlinux.org.uk>,
        <paul.walmsley@sifive.com>, <palmer@dabbelt.com>
CC:     <yash.shah@sifive.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-riscv@lists.infradead.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH 1/7] net: macb: add userio bits as platform configuration
Date:   Fri, 4 Dec 2020 14:34:15 +0200
Message-ID: <1607085261-25255-2-git-send-email-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1607085261-25255-1-git-send-email-claudiu.beznea@microchip.com>
References: <1607085261-25255-1-git-send-email-claudiu.beznea@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is necessary for SAMA7G5 as it uses different values for
PHY interface and also introduces hdfctlen bit.

Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---
 drivers/net/ethernet/cadence/macb.h      | 10 ++++++++++
 drivers/net/ethernet/cadence/macb_main.c | 28 ++++++++++++++++++++++++----
 2 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index 1f5da4e4f4b2..7daabffe4318 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -1147,6 +1147,14 @@ struct macb_pm_data {
 	u32 usrio;
 };
 
+struct macb_usrio_config {
+	u32 mii;
+	u32 rmii;
+	u32 rgmii;
+	u32 refclk;
+	u32 hdfctlen;
+};
+
 struct macb_config {
 	u32			caps;
 	unsigned int		dma_burst_length;
@@ -1155,6 +1163,7 @@ struct macb_config {
 			    struct clk **rx_clk, struct clk **tsu_clk);
 	int	(*init)(struct platform_device *pdev);
 	int	jumbo_max_len;
+	const struct macb_usrio_config *usrio;
 };
 
 struct tsu_incr {
@@ -1288,6 +1297,7 @@ struct macb {
 	u32	rx_intr_mask;
 
 	struct macb_pm_data pm_data;
+	const struct macb_usrio_config *usrio;
 };
 
 #ifdef CONFIG_MACB_USE_HWSTAMP
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 7b1d195787dc..6d46153a7c4b 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -3913,15 +3913,15 @@ static int macb_init(struct platform_device *pdev)
 	if (!(bp->caps & MACB_CAPS_USRIO_DISABLED)) {
 		val = 0;
 		if (phy_interface_mode_is_rgmii(bp->phy_interface))
-			val = GEM_BIT(RGMII);
+			val = bp->usrio->rgmii;
 		else if (bp->phy_interface == PHY_INTERFACE_MODE_RMII &&
 			 (bp->caps & MACB_CAPS_USRIO_DEFAULT_IS_MII_GMII))
-			val = MACB_BIT(RMII);
+			val = bp->usrio->rmii;
 		else if (!(bp->caps & MACB_CAPS_USRIO_DEFAULT_IS_MII_GMII))
-			val = MACB_BIT(MII);
+			val = bp->usrio->mii;
 
 		if (bp->caps & MACB_CAPS_USRIO_HAS_CLKEN)
-			val |= MACB_BIT(CLKEN);
+			val |= bp->usrio->refclk;
 
 		macb_or_gem_writel(bp, USRIO, val);
 	}
@@ -4439,6 +4439,13 @@ static int fu540_c000_init(struct platform_device *pdev)
 	return macb_init(pdev);
 }
 
+static const struct macb_usrio_config macb_default_usrio = {
+	.mii = MACB_BIT(MII),
+	.rmii = MACB_BIT(RMII),
+	.rgmii = GEM_BIT(RGMII),
+	.refclk = MACB_BIT(CLKEN),
+};
+
 static const struct macb_config fu540_c000_config = {
 	.caps = MACB_CAPS_GIGABIT_MODE_AVAILABLE | MACB_CAPS_JUMBO |
 		MACB_CAPS_GEM_HAS_PTP,
@@ -4446,12 +4453,14 @@ static const struct macb_config fu540_c000_config = {
 	.clk_init = fu540_c000_clk_init,
 	.init = fu540_c000_init,
 	.jumbo_max_len = 10240,
+	.usrio = &macb_default_usrio,
 };
 
 static const struct macb_config at91sam9260_config = {
 	.caps = MACB_CAPS_USRIO_HAS_CLKEN | MACB_CAPS_USRIO_DEFAULT_IS_MII_GMII,
 	.clk_init = macb_clk_init,
 	.init = macb_init,
+	.usrio = &macb_default_usrio,
 };
 
 static const struct macb_config sama5d3macb_config = {
@@ -4459,6 +4468,7 @@ static const struct macb_config sama5d3macb_config = {
 	      | MACB_CAPS_USRIO_HAS_CLKEN | MACB_CAPS_USRIO_DEFAULT_IS_MII_GMII,
 	.clk_init = macb_clk_init,
 	.init = macb_init,
+	.usrio = &macb_default_usrio,
 };
 
 static const struct macb_config pc302gem_config = {
@@ -4466,6 +4476,7 @@ static const struct macb_config pc302gem_config = {
 	.dma_burst_length = 16,
 	.clk_init = macb_clk_init,
 	.init = macb_init,
+	.usrio = &macb_default_usrio,
 };
 
 static const struct macb_config sama5d2_config = {
@@ -4473,6 +4484,7 @@ static const struct macb_config sama5d2_config = {
 	.dma_burst_length = 16,
 	.clk_init = macb_clk_init,
 	.init = macb_init,
+	.usrio = &macb_default_usrio,
 };
 
 static const struct macb_config sama5d3_config = {
@@ -4482,6 +4494,7 @@ static const struct macb_config sama5d3_config = {
 	.clk_init = macb_clk_init,
 	.init = macb_init,
 	.jumbo_max_len = 10240,
+	.usrio = &macb_default_usrio,
 };
 
 static const struct macb_config sama5d4_config = {
@@ -4489,18 +4502,21 @@ static const struct macb_config sama5d4_config = {
 	.dma_burst_length = 4,
 	.clk_init = macb_clk_init,
 	.init = macb_init,
+	.usrio = &macb_default_usrio,
 };
 
 static const struct macb_config emac_config = {
 	.caps = MACB_CAPS_NEEDS_RSTONUBR | MACB_CAPS_MACB_IS_EMAC,
 	.clk_init = at91ether_clk_init,
 	.init = at91ether_init,
+	.usrio = &macb_default_usrio,
 };
 
 static const struct macb_config np4_config = {
 	.caps = MACB_CAPS_USRIO_DISABLED,
 	.clk_init = macb_clk_init,
 	.init = macb_init,
+	.usrio = &macb_default_usrio,
 };
 
 static const struct macb_config zynqmp_config = {
@@ -4511,6 +4527,7 @@ static const struct macb_config zynqmp_config = {
 	.clk_init = macb_clk_init,
 	.init = macb_init,
 	.jumbo_max_len = 10240,
+	.usrio = &macb_default_usrio,
 };
 
 static const struct macb_config zynq_config = {
@@ -4519,6 +4536,7 @@ static const struct macb_config zynq_config = {
 	.dma_burst_length = 16,
 	.clk_init = macb_clk_init,
 	.init = macb_init,
+	.usrio = &macb_default_usrio,
 };
 
 static const struct of_device_id macb_dt_ids[] = {
@@ -4640,6 +4658,8 @@ static int macb_probe(struct platform_device *pdev)
 		bp->wol |= MACB_WOL_HAS_MAGIC_PACKET;
 	device_set_wakeup_capable(&pdev->dev, bp->wol & MACB_WOL_HAS_MAGIC_PACKET);
 
+	bp->usrio = macb_config->usrio;
+
 	spin_lock_init(&bp->lock);
 
 	/* setup capabilities */
-- 
2.7.4

