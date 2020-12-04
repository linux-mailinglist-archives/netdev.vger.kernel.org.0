Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 325672CEE34
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 13:38:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388288AbgLDMgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 07:36:46 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:16990 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728490AbgLDMgq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 07:36:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607085405; x=1638621405;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=yzKQluhYPffqyE+muc7ujoCkg9zgVEFQBijHQdhkibk=;
  b=vqGtkM75YMfoOea3D/KOTa45oLKJ9zfZZ2LlRf9vujgUEljB0xM/3RYo
   N2JlkjynZnURFzkjYunFM7E7hjEY8AmczXDo6rKNHsoPFJOsAd38BcwEn
   gIGWR4XpIq2hwyC0Zyvz7ENjewOAT7a1ph59CAbAPektIBvgSypDZmWgr
   +9EGtSDWXesACKDEmpzrn4tnka49POVF2d8zHvDzSJcWs5b64dKo7SSqy
   pxX09Rgc25lAqk7DoerGVMv1yIL3XnKqcoVo6StbYznCIBXXj202hQFjG
   hydLea9m+NAPMxV67foMSckktnv0/QRzbUlM/P65e4/ELQXGwwNQtscU8
   w==;
IronPort-SDR: 56pKorbgBMzy4H9gJX9mAjHU66b5Tv7xjzoKOfeQriAozK6hoifvsE7LIZH21kDwzfxU542zbv
 axKxp2m9LCMvba3btBfSSU9Hg5d5uFQ/0xFYFZEJVce4m9q3t94UowO0ExohEx7Df1b44i+cgz
 nLlPpEj3OKh0/NWRv+7i6+lHVGPTZYZyTWrNTsDt5OP5lrbh1yrP0hv1nkUMaWZQ37/wOyN4P5
 NBfpeyxrYTXN2GKn/3keBaSYQNUELc/Xcs12xUPU1/Ef3J8DJA7kz+MbkVaMtkSevAhE4NQj6Z
 sj8=
X-IronPort-AV: E=Sophos;i="5.78,392,1599548400"; 
   d="scan'208";a="106188165"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Dec 2020 05:35:11 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 4 Dec 2020 05:35:11 -0700
Received: from m18063-ThinkPad-T460p.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Fri, 4 Dec 2020 05:35:05 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <nicolas.ferre@microchip.com>, <linux@armlinux.org.uk>,
        <paul.walmsley@sifive.com>, <palmer@dabbelt.com>
CC:     <yash.shah@sifive.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-riscv@lists.infradead.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH 6/7] net: macb: add support for sama7g5 gem interface
Date:   Fri, 4 Dec 2020 14:34:20 +0200
Message-ID: <1607085261-25255-7-git-send-email-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1607085261-25255-1-git-send-email-claudiu.beznea@microchip.com>
References: <1607085261-25255-1-git-send-email-claudiu.beznea@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for SAMA7G5 gigabit ethernet interface.

Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 29d144690b3b..22340e55d4b7 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4461,6 +4461,14 @@ static const struct macb_usrio_config macb_default_usrio = {
 	.refclk = MACB_BIT(CLKEN),
 };
 
+static const struct macb_usrio_config sama7g5_usrio = {
+	.mii = 0,
+	.rmii = 1,
+	.rgmii = 2,
+	.refclk = BIT(2),
+	.hdfctlen = BIT(6),
+};
+
 static const struct macb_config fu540_c000_config = {
 	.caps = MACB_CAPS_GIGABIT_MODE_AVAILABLE | MACB_CAPS_JUMBO |
 		MACB_CAPS_GEM_HAS_PTP,
@@ -4554,6 +4562,14 @@ static const struct macb_config zynq_config = {
 	.usrio = &macb_default_usrio,
 };
 
+static const struct macb_config sama7g5_gem_config = {
+	.caps = MACB_CAPS_GIGABIT_MODE_AVAILABLE | MACB_CAPS_CLK_HW_CHG,
+	.dma_burst_length = 16,
+	.clk_init = macb_clk_init,
+	.init = macb_init,
+	.usrio = &sama7g5_usrio,
+};
+
 static const struct of_device_id macb_dt_ids[] = {
 	{ .compatible = "cdns,at32ap7000-macb" },
 	{ .compatible = "cdns,at91sam9260-macb", .data = &at91sam9260_config },
@@ -4571,6 +4587,7 @@ static const struct of_device_id macb_dt_ids[] = {
 	{ .compatible = "cdns,zynqmp-gem", .data = &zynqmp_config},
 	{ .compatible = "cdns,zynq-gem", .data = &zynq_config },
 	{ .compatible = "sifive,fu540-c000-gem", .data = &fu540_c000_config },
+	{ .compatible = "microchip,sama7g5-gem", .data = &sama7g5_gem_config },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, macb_dt_ids);
-- 
2.7.4

