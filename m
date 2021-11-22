Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A512545925D
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 16:57:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240365AbhKVQAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 11:00:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240394AbhKVP7r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 10:59:47 -0500
Received: from laurent.telenet-ops.be (laurent.telenet-ops.be [IPv6:2a02:1800:110:4::f00:19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1428DC06139A
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 07:56:23 -0800 (PST)
Received: from ramsan.of.borg ([84.195.186.194])
        by laurent.telenet-ops.be with bizsmtp
        id MTvi2600Z4C55Sk01TviwZ; Mon, 22 Nov 2021 16:56:23 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mpBe6-00EL3i-LK; Mon, 22 Nov 2021 16:54:18 +0100
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mpBe5-00HGzM-PZ; Mon, 22 Nov 2021 16:54:17 +0100
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Tony Lindgren <tony@atomide.com>,
        Russell King <linux@armlinux.org.uk>,
        Rajendra Nayak <rnayak@codeaurora.org>,
        Paul Walmsley <paul@pwsan.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Tero Kristo <kristo@kernel.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Benoit Parrot <bparrot@ti.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andrew Jeffery <andrew@aj.id.au>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Joel Stanley <joel@jms.id.au>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Keerthy <j-keerthy@ti.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>
Cc:     linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-aspeed@lists.ozlabs.org, openbmc@lists.ozlabs.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-pm@vger.kernel.org,
        alsa-devel@alsa-project.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH/RFC 12/17] pinctrl: aspeed: Use bitfield helpers
Date:   Mon, 22 Nov 2021 16:54:05 +0100
Message-Id: <15158715ad2278191e310ac5a8d3dba7cc4fb9cc.1637592133.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1637592133.git.geert+renesas@glider.be>
References: <cover.1637592133.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the field_{get,prep}() helpers, instead of open-coding the same
operations.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
Compile-tested only.
Marked RFC, as this depends on [PATCH 01/17], but follows a different
path to upstream.
---
 drivers/pinctrl/aspeed/pinctrl-aspeed-g4.c | 3 ++-
 drivers/pinctrl/aspeed/pinctrl-aspeed-g5.c | 3 ++-
 drivers/pinctrl/aspeed/pinctrl-aspeed-g6.c | 3 ++-
 drivers/pinctrl/aspeed/pinctrl-aspeed.c    | 5 +++--
 drivers/pinctrl/aspeed/pinmux-aspeed.c     | 6 ++++--
 5 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/pinctrl/aspeed/pinctrl-aspeed-g4.c b/drivers/pinctrl/aspeed/pinctrl-aspeed-g4.c
index bfed0e2746437b4a..bfb2a7b229915a68 100644
--- a/drivers/pinctrl/aspeed/pinctrl-aspeed-g4.c
+++ b/drivers/pinctrl/aspeed/pinctrl-aspeed-g4.c
@@ -2,6 +2,7 @@
 /*
  * Copyright (C) 2016 IBM Corp.
  */
+#include <linux/bitfield.h>
 #include <linux/bitops.h>
 #include <linux/init.h>
 #include <linux/io.h>
@@ -2551,7 +2552,7 @@ static int aspeed_g4_sig_expr_set(struct aspeed_pinmux_data *ctx,
 	for (i = 0; i < expr->ndescs; i++) {
 		const struct aspeed_sig_desc *desc = &expr->descs[i];
 		u32 pattern = enable ? desc->enable : desc->disable;
-		u32 val = (pattern << __ffs(desc->mask));
+		u32 val = field_prep(desc->mask, pattern);
 
 		if (!ctx->maps[desc->ip])
 			return -ENODEV;
diff --git a/drivers/pinctrl/aspeed/pinctrl-aspeed-g5.c b/drivers/pinctrl/aspeed/pinctrl-aspeed-g5.c
index 4c0d26606b6cc7d6..8cc6d9c1f1c78296 100644
--- a/drivers/pinctrl/aspeed/pinctrl-aspeed-g5.c
+++ b/drivers/pinctrl/aspeed/pinctrl-aspeed-g5.c
@@ -2,6 +2,7 @@
 /*
  * Copyright (C) 2016 IBM Corp.
  */
+#include <linux/bitfield.h>
 #include <linux/bitops.h>
 #include <linux/init.h>
 #include <linux/io.h>
@@ -2724,7 +2725,7 @@ static int aspeed_g5_sig_expr_set(struct aspeed_pinmux_data *ctx,
 	for (i = 0; i < expr->ndescs; i++) {
 		const struct aspeed_sig_desc *desc = &expr->descs[i];
 		u32 pattern = enable ? desc->enable : desc->disable;
-		u32 val = (pattern << __ffs(desc->mask));
+		u32 val = field_prep(desc->mask, pattern);
 		struct regmap *map;
 
 		map = aspeed_g5_acquire_regmap(ctx, desc->ip);
diff --git a/drivers/pinctrl/aspeed/pinctrl-aspeed-g6.c b/drivers/pinctrl/aspeed/pinctrl-aspeed-g6.c
index a3fa03bcd9a30577..00f7b69a74e9e743 100644
--- a/drivers/pinctrl/aspeed/pinctrl-aspeed-g6.c
+++ b/drivers/pinctrl/aspeed/pinctrl-aspeed-g6.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /* Copyright (C) 2019 IBM Corp. */
+#include <linux/bitfield.h>
 #include <linux/bitops.h>
 #include <linux/init.h>
 #include <linux/io.h>
@@ -2649,7 +2650,7 @@ static int aspeed_g6_sig_expr_set(struct aspeed_pinmux_data *ctx,
 	for (i = 0; i < expr->ndescs; i++) {
 		const struct aspeed_sig_desc *desc = &expr->descs[i];
 		u32 pattern = enable ? desc->enable : desc->disable;
-		u32 val = (pattern << __ffs(desc->mask));
+		u32 val = field_prep(desc->mask, pattern);
 		bool is_strap;
 
 		if (!ctx->maps[desc->ip])
diff --git a/drivers/pinctrl/aspeed/pinctrl-aspeed.c b/drivers/pinctrl/aspeed/pinctrl-aspeed.c
index c94e24aadf922d2a..839ac48f75836352 100644
--- a/drivers/pinctrl/aspeed/pinctrl-aspeed.c
+++ b/drivers/pinctrl/aspeed/pinctrl-aspeed.c
@@ -3,6 +3,7 @@
  * Copyright (C) 2016 IBM Corp.
  */
 
+#include <linux/bitfield.h>
 #include <linux/mfd/syscon.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
@@ -547,7 +548,7 @@ int aspeed_pin_config_get(struct pinctrl_dev *pctldev, unsigned int offset,
 		return rc;
 
 	pmap = find_pinconf_map(pdata, param, MAP_TYPE_VAL,
-			(val & pconf->mask) >> __ffs(pconf->mask));
+				field_get(pconf->mask, val));
 
 	if (!pmap)
 		return -EINVAL;
@@ -595,7 +596,7 @@ int aspeed_pin_config_set(struct pinctrl_dev *pctldev, unsigned int offset,
 		if (WARN_ON(!pmap))
 			return -EINVAL;
 
-		val = pmap->val << __ffs(pconf->mask);
+		val = field_prep(pconf->mask, pmap->val);
 
 		rc = regmap_update_bits(pdata->scu, pconf->reg,
 					pconf->mask, val);
diff --git a/drivers/pinctrl/aspeed/pinmux-aspeed.c b/drivers/pinctrl/aspeed/pinmux-aspeed.c
index 4aa46383c2c533f0..61ddd550439325ee 100644
--- a/drivers/pinctrl/aspeed/pinmux-aspeed.c
+++ b/drivers/pinctrl/aspeed/pinmux-aspeed.c
@@ -3,6 +3,8 @@
 
 /* Pieces to enable drivers to implement the .set callback */
 
+#include <linux/bitfield.h>
+
 #include "pinmux-aspeed.h"
 
 static const char *const aspeed_pinmux_ips[] = {
@@ -17,7 +19,7 @@ static inline void aspeed_sig_desc_print_val(
 	pr_debug("Want %s%X[0x%08X]=0x%X, got 0x%X from 0x%08X\n",
 			aspeed_pinmux_ips[desc->ip], desc->reg,
 			desc->mask, enable ? desc->enable : desc->disable,
-			(rv & desc->mask) >> __ffs(desc->mask), rv);
+			field_get(desc->mask, rv), rv);
 }
 
 /**
@@ -55,7 +57,7 @@ int aspeed_sig_desc_eval(const struct aspeed_sig_desc *desc,
 	aspeed_sig_desc_print_val(desc, enabled, raw);
 	want = enabled ? desc->enable : desc->disable;
 
-	return ((raw & desc->mask) >> __ffs(desc->mask)) == want;
+	return field_get(desc->mask, raw) == want;
 }
 
 /**
-- 
2.25.1

