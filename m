Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC872D1060
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 13:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727786AbgLGMRn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 07:17:43 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:28250 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727377AbgLGMRm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 07:17:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607343461; x=1638879461;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=iHGOWxfZtvERAS2ndiOX258JxP4h/8vCbp16AmM7GnE=;
  b=Wzs4ocmj4nbExX3ugGzawG47NziMfE5QDsgozTJRu22qS2lto9dCCLEs
   H01clZmwulkMBSMZEd42rMpkolM4SVnzeO20AJYLiRh05Bi/kos0HNTRm
   GUlNOTFmnCI28Tez6LksSxyjaKo7IEHPwa26W3hkWLDt061El0oowwC0H
   RgFSErh+gK4Nfv3/YKjYqikpAAc1S86KIVOSaHfgq9+zjActvRznPj3VY
   G3htT+4EZD+brusXBdld28r4rP+K/sdEeXKxE1mIn/s73YQ9UtKQg3YdV
   xQ97CztBewOHALj5v+918gezGLHv1KhFLeCIOIWk7xywHWjyIoZlXXI+u
   w==;
IronPort-SDR: q8MNQtYY8SurIZDAn2ql2e/my3IrSqOfvwmLkRZgJKkp9TNuN7Df8R1B5mUy6HY5SEki2u36vB
 WMdL/VUun+KpnCI8Coto4NrqRQ7OW+9+yEgbiELYmjD+FlleX2Ci9Acz7wu8228h3OxJrQwyko
 9hj7IdMoTIvriQdxamRygA68SUz5gNQywyMQc7n0ZcwWiWAmZIUS+x+P3ep+oWziTSmtQZYDgE
 Tke8xbrqGFaJNHz6H3nQFOTjM5DnQKIedvK/IPCYzF2HuiAeqp8TtGWY4iHMtAkg3xZTtGEbvM
 dIw=
X-IronPort-AV: E=Sophos;i="5.78,399,1599548400"; 
   d="scan'208";a="36409576"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Dec 2020 05:16:36 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 7 Dec 2020 05:16:36 -0700
Received: from m18063-ThinkPad-T460p.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Mon, 7 Dec 2020 05:16:29 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <nicolas.ferre@microchip.com>, <linux@armlinux.org.uk>,
        <paul.walmsley@sifive.com>, <palmer@dabbelt.com>
CC:     <yash.shah@sifive.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-riscv@lists.infradead.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH v2 7/8] net: macb: add support for sama7g5 gem interface
Date:   Mon, 7 Dec 2020 14:15:32 +0200
Message-ID: <1607343333-26552-8-git-send-email-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1607343333-26552-1-git-send-email-claudiu.beznea@microchip.com>
References: <1607343333-26552-1-git-send-email-claudiu.beznea@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for SAMA7G5 gigabit ethernet interface.

Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/cadence/macb_main.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index deb232801edb..ca56476b3a04 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4465,6 +4465,14 @@ static const struct macb_usrio_config macb_default_usrio = {
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
@@ -4558,6 +4566,14 @@ static const struct macb_config zynq_config = {
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
@@ -4575,6 +4591,7 @@ static const struct of_device_id macb_dt_ids[] = {
 	{ .compatible = "cdns,zynqmp-gem", .data = &zynqmp_config},
 	{ .compatible = "cdns,zynq-gem", .data = &zynq_config },
 	{ .compatible = "sifive,fu540-c000-gem", .data = &fu540_c000_config },
+	{ .compatible = "microchip,sama7g5-gem", .data = &sama7g5_gem_config },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, macb_dt_ids);
-- 
2.7.4

