Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8592D42C0
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 14:11:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732100AbgLINF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 08:05:58 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:16569 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732080AbgLINFo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 08:05:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607519145; x=1639055145;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=HbDgA1apc3p92KhsV/3GN3NoRKjLIwJad3qyZ2Y7yKk=;
  b=s/kChGpjTL8clkfkE6BUZ9PF8siXh1Mko5SiCb3FPXkgbN44zQk575Sa
   rlN9H1oWF1ibYYj3mz0/TlOHkUvvAA4vw1tDc678mwSPM3JgjSZGKb7xc
   eMTU2pg9fpZ1s15wQzrhJugxzmnNDpqvKFrPH6jHZpF7kF0k2bcDhGaTu
   Z+KsjlrO3crEbCqrAoWTaG6+Aph113ZMVWO6q1A6knFO8itD/qVo5U+33
   ijUrMly+TGhZgN8Vb8QSdfxayQ0bP8zbAZwesZP5775p2hZLIQOLjSewm
   aK6lRQIKJnvzynovNob9lgdZIiLxwq2H5hdPjxkclP0tZHa7M+aDQE1qF
   w==;
IronPort-SDR: UHhmzaQtbbB2lgAaBLeq4Mp1w3jTlP5U4MLAVD007wyqsTrvxDUUZ9sdPUpanh7927ZqLs7QxT
 CQww1BTLYEYUN8azrUeri+C9RyUx9leOYp5wVx8ktHpVFKD5yMo+BDhlgzD716gb6MZYHf7tr4
 VzGrw2Bv0qc2a8f9DhS64bu1H2eYN9maXFfUxpwPj88i3ltumeAeBxLfXpwyVTFLPpt6QZ/yYI
 fBTUxsoA5YQdmuBheBCatVt51SPVYR484lAc8SUzzRkjFpi603N1AA/JWgOABe0wPjebVnTZ2j
 fHM=
X-IronPort-AV: E=Sophos;i="5.78,405,1599548400"; 
   d="scan'208";a="101519674"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Dec 2020 06:04:29 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 9 Dec 2020 06:04:28 -0700
Received: from m18063-ThinkPad-T460p.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Wed, 9 Dec 2020 06:04:22 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <nicolas.ferre@microchip.com>, <linux@armlinux.org.uk>,
        <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
        <natechancellor@gmail.com>, <ndesaulniers@google.com>
CC:     <yash.shah@sifive.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-riscv@lists.infradead.org>,
        <clang-built-linux@googlegroups.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH v3 7/8] net: macb: add support for sama7g5 gem interface
Date:   Wed, 9 Dec 2020 15:03:38 +0200
Message-ID: <1607519019-19103-8-git-send-email-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1607519019-19103-1-git-send-email-claudiu.beznea@microchip.com>
References: <1607519019-19103-1-git-send-email-claudiu.beznea@microchip.com>
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
index 11bf4f8d32e1..5bae44931282 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4472,6 +4472,14 @@ static const struct macb_usrio_config macb_default_usrio = {
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
@@ -4565,6 +4573,14 @@ static const struct macb_config zynq_config = {
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
@@ -4582,6 +4598,7 @@ static const struct of_device_id macb_dt_ids[] = {
 	{ .compatible = "cdns,zynqmp-gem", .data = &zynqmp_config},
 	{ .compatible = "cdns,zynq-gem", .data = &zynq_config },
 	{ .compatible = "sifive,fu540-c000-gem", .data = &fu540_c000_config },
+	{ .compatible = "microchip,sama7g5-gem", .data = &sama7g5_gem_config },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, macb_dt_ids);
-- 
2.7.4

