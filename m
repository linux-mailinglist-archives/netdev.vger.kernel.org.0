Return-Path: <netdev+bounces-7696-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F37CF72124E
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 22:07:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3F55B1C20A1E
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 20:07:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3CA2FBEF;
	Sat,  3 Jun 2023 20:06:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD96FE57E
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 20:06:36 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5707FE63;
	Sat,  3 Jun 2023 13:06:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1685822768; x=1717358768;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TsLxsv3xXi9m6mmWoE0aW9PejVYA44EX9xzU2QBW0qg=;
  b=Fst6H5fOteeUT33bYBZLL9v36x2k75/zzeVaRWheDlyixMjhu4FwlNaO
   PGo7/ZmgA8VINU0NPibJduhRsymoIvOExpO6BV2pgkzZcZkzsUuYz/xgZ
   2+KaAVV/blp+EriVOky/rwwyvnumDiOTYcWy6Ye18nhzz1iw8r/P4Mo+F
   msln28PXLKKHGZavElPFajyzzk9Vf1JUI942lx8gKIBkauvRSK8thpElE
   kPUKFC1Ya3x5qFAuVT+RYT7vn6C8MvfMPxmIq6laHag0RcxXkTAl7aRZO
   Et7ziO4WF9wi5pbXxXeecj8pf4fQcZwQnpFky/UJcE5CuWf99Em7iQSQF
   Q==;
X-IronPort-AV: E=Sophos;i="6.00,216,1681196400"; 
   d="scan'208";a="216104611"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Jun 2023 13:05:56 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Sat, 3 Jun 2023 13:05:56 -0700
Received: from che-lt-i67070.amer.actel.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Sat, 3 Jun 2023 13:05:43 -0700
From: Varshini Rajendran <varshini.rajendran@microchip.com>
To: <tglx@linutronix.de>, <maz@kernel.org>, <robh+dt@kernel.org>,
	<krzysztof.kozlowski+dt@linaro.org>, <conor+dt@kernel.org>,
	<nicolas.ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
	<claudiu.beznea@microchip.com>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <gregkh@linuxfoundation.org>,
	<linux@armlinux.org.uk>, <mturquette@baylibre.com>, <sboyd@kernel.org>,
	<sre@kernel.org>, <broonie@kernel.org>, <varshini.rajendran@microchip.com>,
	<arnd@arndb.de>, <gregory.clement@bootlin.com>, <sudeep.holla@arm.com>,
	<balamanikandan.gunasundar@microchip.com>, <mihai.sain@microchip.com>,
	<linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
	<linux-usb@vger.kernel.org>, <linux-clk@vger.kernel.org>,
	<linux-pm@vger.kernel.org>
CC: <Hari.PrasathGE@microchip.com>, <cristian.birsan@microchip.com>,
	<durai.manickamkr@microchip.com>, <manikandan.m@microchip.com>,
	<dharma.b@microchip.com>, <nayabbasha.sayed@microchip.com>,
	<balakrishnan.s@microchip.com>
Subject: [PATCH 13/21] clk: at91: sam9x7: add support for HW PLL freq dividers
Date: Sun, 4 Jun 2023 01:32:35 +0530
Message-ID: <20230603200243.243878-14-varshini.rajendran@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230603200243.243878-1-varshini.rajendran@microchip.com>
References: <20230603200243.243878-1-varshini.rajendran@microchip.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add support for hardware dividers for PLL IDs in sam9x7 Soc
PLL_ID_PLLA and PLL_ID_PLLA_DIV2 has /2 hardware dividers each

fcorepllack -----> HW Div = 2 -+--> fpllack
                               |
                               +--> HW Div = 2 ---> fplladiv2ck

Signed-off-by: Varshini Rajendran <varshini.rajendran@microchip.com>
---
 drivers/clk/at91/clk-sam9x60-pll.c | 38 ++++++++++++++++++++++++++----
 drivers/clk/at91/pmc.h             |  1 +
 2 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/drivers/clk/at91/clk-sam9x60-pll.c b/drivers/clk/at91/clk-sam9x60-pll.c
index b3012641214c..76273ea74f8b 100644
--- a/drivers/clk/at91/clk-sam9x60-pll.c
+++ b/drivers/clk/at91/clk-sam9x60-pll.c
@@ -73,9 +73,15 @@ static unsigned long sam9x60_frac_pll_recalc_rate(struct clk_hw *hw,
 {
 	struct sam9x60_pll_core *core = to_sam9x60_pll_core(hw);
 	struct sam9x60_frac *frac = to_sam9x60_frac(core);
+	unsigned long freq;
 
-	return parent_rate * (frac->mul + 1) +
+	freq = parent_rate * (frac->mul + 1) +
 		DIV_ROUND_CLOSEST_ULL((u64)parent_rate * frac->frac, (1 << 22));
+
+	if (core->layout->div2)
+		freq >>= 1;
+
+	return freq;
 }
 
 static int sam9x60_frac_pll_set(struct sam9x60_pll_core *core)
@@ -432,6 +438,12 @@ static unsigned long sam9x60_div_pll_recalc_rate(struct clk_hw *hw,
 	return DIV_ROUND_CLOSEST_ULL(parent_rate, (div->div + 1));
 }
 
+static unsigned long sam9x60_fixed_div_pll_recalc_rate(struct clk_hw *hw,
+						       unsigned long parent_rate)
+{
+	return parent_rate >> 1;
+}
+
 static long sam9x60_div_pll_compute_div(struct sam9x60_pll_core *core,
 					unsigned long *parent_rate,
 					unsigned long rate)
@@ -606,6 +618,16 @@ static const struct clk_ops sam9x60_div_pll_ops_chg = {
 	.restore_context = sam9x60_div_pll_restore_context,
 };
 
+static const struct clk_ops sam9x60_fixed_div_pll_ops = {
+	.prepare = sam9x60_div_pll_prepare,
+	.unprepare = sam9x60_div_pll_unprepare,
+	.is_prepared = sam9x60_div_pll_is_prepared,
+	.recalc_rate = sam9x60_fixed_div_pll_recalc_rate,
+	.round_rate = sam9x60_div_pll_round_rate,
+	.save_context = sam9x60_div_pll_save_context,
+	.restore_context = sam9x60_div_pll_restore_context,
+};
+
 struct clk_hw * __init
 sam9x60_clk_register_frac_pll(struct regmap *regmap, spinlock_t *lock,
 			      const char *name, const char *parent_name,
@@ -718,10 +740,16 @@ sam9x60_clk_register_div_pll(struct regmap *regmap, spinlock_t *lock,
 	init.name = name;
 	init.parent_names = &parent_name;
 	init.num_parents = 1;
-	if (flags & CLK_SET_RATE_GATE)
-		init.ops = &sam9x60_div_pll_ops;
-	else
-		init.ops = &sam9x60_div_pll_ops_chg;
+
+	if (layout->div2) {
+		init.ops = &sam9x60_fixed_div_pll_ops;
+	} else {
+		if (flags & CLK_SET_RATE_GATE)
+			init.ops = &sam9x60_div_pll_ops;
+		else
+			init.ops = &sam9x60_div_pll_ops_chg;
+	}
+
 	init.flags = flags;
 
 	div->core.id = id;
diff --git a/drivers/clk/at91/pmc.h b/drivers/clk/at91/pmc.h
index 3e36dcc464c1..1dd01f30bdee 100644
--- a/drivers/clk/at91/pmc.h
+++ b/drivers/clk/at91/pmc.h
@@ -64,6 +64,7 @@ struct clk_pll_layout {
 	u8 frac_shift;
 	u8 div_shift;
 	u8 endiv_shift;
+	u8 div2;
 };
 
 extern const struct clk_pll_layout at91rm9200_pll_layout;
-- 
2.25.1


