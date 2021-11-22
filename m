Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2362B459261
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 16:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240405AbhKVQAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 11:00:12 -0500
Received: from leibniz.telenet-ops.be ([195.130.137.77]:52538 "EHLO
        leibniz.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240407AbhKVQAF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 11:00:05 -0500
Received: from baptiste.telenet-ops.be (baptiste.telenet-ops.be [IPv6:2a02:1800:120:4::f00:13])
        by leibniz.telenet-ops.be (Postfix) with ESMTPS id 4HyX2d5TxXzMqgCM
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 16:56:57 +0100 (CET)
Received: from ramsan.of.borg ([84.195.186.194])
        by baptiste.telenet-ops.be with bizsmtp
        id MTwG2600F4C55Sk01TwGVb; Mon, 22 Nov 2021 16:56:57 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mpBe6-00EL3m-Lm; Mon, 22 Nov 2021 16:54:18 +0100
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mpBe5-00HH1L-TK; Mon, 22 Nov 2021 16:54:17 +0100
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
Subject: [PATCH/RFC 15/17] thermal/ti-soc-thermal: Use bitfield helpers
Date:   Mon, 22 Nov 2021 16:54:08 +0100
Message-Id: <37efc6013a24653e316215424b160d613f42dcd5.1637592133.git.geert+renesas@glider.be>
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
 drivers/thermal/ti-soc-thermal/ti-bandgap.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/thermal/ti-soc-thermal/ti-bandgap.c b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
index ea0603b59309f5f0..83a34d698414b177 100644
--- a/drivers/thermal/ti-soc-thermal/ti-bandgap.c
+++ b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
@@ -9,6 +9,7 @@
  *   Eduardo Valentin <eduardo.valentin@ti.com>
  */
 
+#include <linux/bitfield.h>
 #include <linux/clk.h>
 #include <linux/cpu_pm.h>
 #include <linux/device.h>
@@ -80,10 +81,10 @@ do {								\
 	struct temp_sensor_registers *t;			\
 	u32 r;							\
 								\
-	t = bgp->conf->sensors[(id)].registers;		\
+	t = bgp->conf->sensors[(id)].registers;			\
 	r = ti_bandgap_readl(bgp, t->reg);			\
 	r &= ~t->mask;						\
-	r |= (val) << __ffs(t->mask);				\
+	r |= field_prep(t->mask, val);				\
 	ti_bandgap_writel(bgp, r, t->reg);			\
 } while (0)
 
@@ -342,8 +343,7 @@ static void ti_bandgap_read_counter(struct ti_bandgap *bgp, int id,
 
 	tsr = bgp->conf->sensors[id].registers;
 	time = ti_bandgap_readl(bgp, tsr->bgap_counter);
-	time = (time & tsr->counter_mask) >>
-					__ffs(tsr->counter_mask);
+	time = field_get(tsr->counter_mask, time);
 	time = time * 1000 / bgp->clk_rate;
 	*interval = time;
 }
@@ -363,8 +363,7 @@ static void ti_bandgap_read_counter_delay(struct ti_bandgap *bgp, int id,
 	tsr = bgp->conf->sensors[id].registers;
 
 	reg_val = ti_bandgap_readl(bgp, tsr->bgap_mask_ctrl);
-	reg_val = (reg_val & tsr->mask_counter_delay_mask) >>
-				__ffs(tsr->mask_counter_delay_mask);
+	reg_val = field_get(tsr->mask_counter_delay_mask, reg_val);
 	switch (reg_val) {
 	case 0:
 		*interval = 0;
-- 
2.25.1

