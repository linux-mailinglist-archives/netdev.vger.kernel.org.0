Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 200174591F4
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 16:57:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240166AbhKVP6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 10:58:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240175AbhKVP6r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 10:58:47 -0500
Received: from laurent.telenet-ops.be (laurent.telenet-ops.be [IPv6:2a02:1800:110:4::f00:19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14632C061756
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 07:55:39 -0800 (PST)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed20:e4da:38c:79e9:48bf])
        by laurent.telenet-ops.be with bizsmtp
        id MTuy2600b4yPVd601TuykT; Mon, 22 Nov 2021 16:55:39 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mpBe6-00EL3O-J0; Mon, 22 Nov 2021 16:54:18 +0100
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mpBe5-00HGyS-F3; Mon, 22 Nov 2021 16:54:17 +0100
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
Subject: [PATCH/RFC 04/17] ARM: OMAP2+: Use bitfield helpers
Date:   Mon, 22 Nov 2021 16:53:57 +0100
Message-Id: <e3ff357481b3db924d1952c40f06adbf03b78733.1637592133.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1637592133.git.geert+renesas@glider.be>
References: <cover.1637592133.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the FIELD_{GET,PREP}() and field_{get,prep}() helpers for const
respective non-const bitfields, instead of open-coding the same
operations.

Remove the definitions of OMAP_POWERSTATEST_SHIFT and
OMAP_POWERSTATE_SHIFT, as they are no longer used.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
Compile-tested only.
Marked RFC, as this depends on [PATCH 01/17], but follows a different
path to upstream.
---
 arch/arm/mach-omap2/clkt2xxx_dpllcore.c     |  5 +-
 arch/arm/mach-omap2/cm2xxx.c                | 11 ++---
 arch/arm/mach-omap2/cm2xxx_3xxx.h           |  9 +---
 arch/arm/mach-omap2/cm33xx.c                |  9 +---
 arch/arm/mach-omap2/cm3xxx.c                |  7 ++-
 arch/arm/mach-omap2/cminst44xx.c            |  9 +---
 arch/arm/mach-omap2/powerdomains3xxx_data.c |  3 +-
 arch/arm/mach-omap2/prm.h                   |  2 -
 arch/arm/mach-omap2/prm2xxx.c               |  4 +-
 arch/arm/mach-omap2/prm2xxx_3xxx.c          |  7 +--
 arch/arm/mach-omap2/prm2xxx_3xxx.h          |  9 +---
 arch/arm/mach-omap2/prm33xx.c               | 53 +++++++--------------
 arch/arm/mach-omap2/prm3xxx.c               |  3 +-
 arch/arm/mach-omap2/prm44xx.c               | 53 +++++++--------------
 arch/arm/mach-omap2/vc.c                    | 12 ++---
 arch/arm/mach-omap2/vp.c                    | 11 +++--
 16 files changed, 77 insertions(+), 130 deletions(-)

diff --git a/arch/arm/mach-omap2/clkt2xxx_dpllcore.c b/arch/arm/mach-omap2/clkt2xxx_dpllcore.c
index 8a9983cb4733dfb1..6a61dc932b24f387 100644
--- a/arch/arm/mach-omap2/clkt2xxx_dpllcore.c
+++ b/arch/arm/mach-omap2/clkt2xxx_dpllcore.c
@@ -17,6 +17,7 @@
  */
 #undef DEBUG
 
+#include <linux/bitfield.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/clk.h>
@@ -151,8 +152,8 @@ int omap2_reprogram_dpllcore(struct clk_hw *hw, unsigned long rate,
 			mult = (rate / 1000000);
 			done_rate = CORE_CLK_SRC_DPLL;
 		}
-		tmpset.cm_clksel1_pll |= (div << __ffs(dd->mult_mask));
-		tmpset.cm_clksel1_pll |= (mult << __ffs(dd->div1_mask));
+		tmpset.cm_clksel1_pll |= field_prep(dd->mult_mask, div);
+		tmpset.cm_clksel1_pll |= field_prep(dd->div1_mask, mult);
 
 		/* Worst case */
 		tmpset.base_sdrc_rfr = SDRC_RFR_CTRL_BYPASS;
diff --git a/arch/arm/mach-omap2/cm2xxx.c b/arch/arm/mach-omap2/cm2xxx.c
index 0827acb605843778..59d35d4d43bec533 100644
--- a/arch/arm/mach-omap2/cm2xxx.c
+++ b/arch/arm/mach-omap2/cm2xxx.c
@@ -8,6 +8,7 @@
  * Rajendra Nayak <rnayak@ti.com>
  */
 
+#include <linux/bitfield.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/delay.h>
@@ -46,7 +47,7 @@ static void _write_clktrctrl(u8 c, s16 module, u32 mask)
 
 	v = omap2_cm_read_mod_reg(module, OMAP2_CM_CLKSTCTRL);
 	v &= ~mask;
-	v |= c << __ffs(mask);
+	v |= field_prep(mask, c);
 	omap2_cm_write_mod_reg(v, module, OMAP2_CM_CLKSTCTRL);
 }
 
@@ -54,9 +55,7 @@ static bool omap2xxx_cm_is_clkdm_in_hwsup(s16 module, u32 mask)
 {
 	u32 v;
 
-	v = omap2_cm_read_mod_reg(module, OMAP2_CM_CLKSTCTRL);
-	v &= mask;
-	v >>= __ffs(mask);
+	v = field_get(mask, omap2_cm_read_mod_reg(module, OMAP2_CM_CLKSTCTRL));
 
 	return (v == OMAP24XX_CLKSTCTRL_ENABLE_AUTO) ? 1 : 0;
 }
@@ -81,7 +80,7 @@ static void _omap2xxx_set_dpll_autoidle(u8 m)
 
 	v = omap2_cm_read_mod_reg(PLL_MOD, CM_AUTOIDLE);
 	v &= ~OMAP24XX_AUTO_DPLL_MASK;
-	v |= m << OMAP24XX_AUTO_DPLL_SHIFT;
+	v |= FIELD_PREP(OMAP24XX_AUTO_DPLL_MASK, m);
 	omap2_cm_write_mod_reg(v, PLL_MOD, CM_AUTOIDLE);
 }
 
@@ -105,7 +104,7 @@ static void _omap2xxx_set_apll_autoidle(u8 m, u32 mask)
 
 	v = omap2_cm_read_mod_reg(PLL_MOD, CM_AUTOIDLE);
 	v &= ~mask;
-	v |= m << __ffs(mask);
+	v |= field_prep(mask, m);
 	omap2_cm_write_mod_reg(v, PLL_MOD, CM_AUTOIDLE);
 }
 
diff --git a/arch/arm/mach-omap2/cm2xxx_3xxx.h b/arch/arm/mach-omap2/cm2xxx_3xxx.h
index 70944b94cc098d7f..e3214491f1b556fd 100644
--- a/arch/arm/mach-omap2/cm2xxx_3xxx.h
+++ b/arch/arm/mach-omap2/cm2xxx_3xxx.h
@@ -45,6 +45,7 @@
 
 #ifndef __ASSEMBLER__
 
+#include <linux/bitfield.h>
 #include <linux/io.h>
 
 static inline u32 omap2_cm_read_mod_reg(s16 module, u16 idx)
@@ -74,13 +75,7 @@ static inline u32 omap2_cm_rmw_mod_reg_bits(u32 mask, u32 bits, s16 module,
 /* Read a CM register, AND it, and shift the result down to bit 0 */
 static inline u32 omap2_cm_read_mod_bits_shift(s16 domain, s16 idx, u32 mask)
 {
-	u32 v;
-
-	v = omap2_cm_read_mod_reg(domain, idx);
-	v &= mask;
-	v >>= __ffs(mask);
-
-	return v;
+	return field_get(mask, omap2_cm_read_mod_reg(domain, idx));
 }
 
 static inline u32 omap2_cm_set_mod_reg_bits(u32 bits, s16 module, s16 idx)
diff --git a/arch/arm/mach-omap2/cm33xx.c b/arch/arm/mach-omap2/cm33xx.c
index ac4882ebdca33fdf..5479b9587d688885 100644
--- a/arch/arm/mach-omap2/cm33xx.c
+++ b/arch/arm/mach-omap2/cm33xx.c
@@ -16,6 +16,7 @@
  * GNU General Public License for more details.
  */
 
+#include <linux/bitfield.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/errno.h>
@@ -74,13 +75,7 @@ static inline u32 am33xx_cm_rmw_reg_bits(u32 mask, u32 bits, s16 inst, s16 idx)
 
 static inline u32 am33xx_cm_read_reg_bits(u16 inst, s16 idx, u32 mask)
 {
-	u32 v;
-
-	v = am33xx_cm_read_reg(inst, idx);
-	v &= mask;
-	v >>= __ffs(mask);
-
-	return v;
+	return field_get(mask, am33xx_cm_read_reg(inst, idx));
 }
 
 /**
diff --git a/arch/arm/mach-omap2/cm3xxx.c b/arch/arm/mach-omap2/cm3xxx.c
index b03b6123b8fcc8f2..951c6a9cee1e80ba 100644
--- a/arch/arm/mach-omap2/cm3xxx.c
+++ b/arch/arm/mach-omap2/cm3xxx.c
@@ -8,6 +8,7 @@
  * Rajendra Nayak <rnayak@ti.com>
  */
 
+#include <linux/bitfield.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/delay.h>
@@ -35,7 +36,7 @@ static void _write_clktrctrl(u8 c, s16 module, u32 mask)
 
 	v = omap2_cm_read_mod_reg(module, OMAP2_CM_CLKSTCTRL);
 	v &= ~mask;
-	v |= c << __ffs(mask);
+	v |= field_prep(mask, c);
 	omap2_cm_write_mod_reg(v, module, OMAP2_CM_CLKSTCTRL);
 }
 
@@ -43,9 +44,7 @@ static bool omap3xxx_cm_is_clkdm_in_hwsup(s16 module, u32 mask)
 {
 	u32 v;
 
-	v = omap2_cm_read_mod_reg(module, OMAP2_CM_CLKSTCTRL);
-	v &= mask;
-	v >>= __ffs(mask);
+	v = field_get(mask, omap2_cm_read_mod_reg(module, OMAP2_CM_CLKSTCTRL));
 
 	return (v == OMAP34XX_CLKSTCTRL_ENABLE_AUTO) ? 1 : 0;
 }
diff --git a/arch/arm/mach-omap2/cminst44xx.c b/arch/arm/mach-omap2/cminst44xx.c
index 46670521b27883ec..e9ca128b14349be2 100644
--- a/arch/arm/mach-omap2/cminst44xx.c
+++ b/arch/arm/mach-omap2/cminst44xx.c
@@ -12,6 +12,7 @@
  * the PRM hardware module.  What a mess...
  */
 
+#include <linux/bitfield.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/errno.h>
@@ -154,13 +155,7 @@ static u32 omap4_cminst_clear_inst_reg_bits(u32 bits, u8 part, u16 inst,
 
 static u32 omap4_cminst_read_inst_reg_bits(u8 part, u16 inst, s16 idx, u32 mask)
 {
-	u32 v;
-
-	v = omap4_cminst_read_inst_reg(part, inst, idx);
-	v &= mask;
-	v >>= __ffs(mask);
-
-	return v;
+	return field_get(mask, omap4_cminst_read_inst_reg(part, inst, idx));
 }
 
 /*
diff --git a/arch/arm/mach-omap2/powerdomains3xxx_data.c b/arch/arm/mach-omap2/powerdomains3xxx_data.c
index 3564fade67e45061..08ae42ddb15b138e 100644
--- a/arch/arm/mach-omap2/powerdomains3xxx_data.c
+++ b/arch/arm/mach-omap2/powerdomains3xxx_data.c
@@ -8,6 +8,7 @@
  * Paul Walmsley, Jouni Högander
  */
 
+#include <linux/bitfield.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/bug.h>
@@ -513,7 +514,7 @@ static struct powerdomain *powerdomains_ti816x[] __initdata = {
 static int ti81xx_pwrdm_set_next_pwrst(struct powerdomain *pwrdm, u8 pwrst)
 {
 	omap2_prm_rmw_mod_reg_bits(OMAP_POWERSTATE_MASK,
-				   (pwrst << OMAP_POWERSTATE_SHIFT),
+				   FIELD_PREP(OMAP_POWERSTATE_MASK, pwrst),
 				   pwrdm->prcm_offs, TI81XX_PM_PWSTCTRL);
 	return 0;
 }
diff --git a/arch/arm/mach-omap2/prm.h b/arch/arm/mach-omap2/prm.h
index 08df78810a5e39e9..c54991e7058e7cd7 100644
--- a/arch/arm/mach-omap2/prm.h
+++ b/arch/arm/mach-omap2/prm.h
@@ -67,7 +67,6 @@ int omap2_prcm_base_init(void);
  *	 PM_PWSTST_DSS, PM_PWSTST_CAM, PM_PWSTST_PER, PM_PWSTST_EMU,
  *	 PM_PWSTST_NEON
  */
-#define OMAP_POWERSTATEST_SHIFT				0
 #define OMAP_POWERSTATEST_MASK				(0x3 << 0)
 
 /*
@@ -80,7 +79,6 @@ int omap2_prcm_base_init(void);
  *	 PM_PWSTCTRL_GFX, PM_PWSTCTRL_DSS, PM_PWSTCTRL_CAM, PM_PWSTCTRL_PER,
  *	 PM_PWSTCTRL_NEON shared bits
  */
-#define OMAP_POWERSTATE_SHIFT				0
 #define OMAP_POWERSTATE_MASK				(0x3 << 0)
 
 /*
diff --git a/arch/arm/mach-omap2/prm2xxx.c b/arch/arm/mach-omap2/prm2xxx.c
index 35a58f54b528f335..e835e381a82b7685 100644
--- a/arch/arm/mach-omap2/prm2xxx.c
+++ b/arch/arm/mach-omap2/prm2xxx.c
@@ -9,6 +9,7 @@
  * Rajendra Nayak <rnayak@ti.com>
  */
 
+#include <linux/bitfield.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/err.h>
@@ -165,7 +166,8 @@ static int omap2xxx_pwrdm_set_next_pwrst(struct powerdomain *pwrdm, u8 pwrst)
 	}
 
 	omap2_prm_rmw_mod_reg_bits(OMAP_POWERSTATE_MASK,
-				   (omap24xx_pwrst << OMAP_POWERSTATE_SHIFT),
+				   FIELD_PREP(OMAP_POWERSTATE_MASK,
+					      omap24xx_pwrst),
 				   pwrdm->prcm_offs, OMAP2_PM_PWSTCTRL);
 	return 0;
 }
diff --git a/arch/arm/mach-omap2/prm2xxx_3xxx.c b/arch/arm/mach-omap2/prm2xxx_3xxx.c
index d983efac6f4ff6f5..8a223ced2bcad25b 100644
--- a/arch/arm/mach-omap2/prm2xxx_3xxx.c
+++ b/arch/arm/mach-omap2/prm2xxx_3xxx.c
@@ -8,6 +8,7 @@
  * Paul Walmsley
  */
 
+#include <linux/bitfield.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/err.h>
@@ -115,7 +116,7 @@ int omap2_pwrdm_set_mem_onst(struct powerdomain *pwrdm, u8 bank,
 
 	m = omap2_pwrdm_get_mem_bank_onstate_mask(bank);
 
-	omap2_prm_rmw_mod_reg_bits(m, (pwrst << __ffs(m)), pwrdm->prcm_offs,
+	omap2_prm_rmw_mod_reg_bits(m, field_prep(m, pwrst), pwrdm->prcm_offs,
 				   OMAP2_PM_PWSTCTRL);
 
 	return 0;
@@ -128,7 +129,7 @@ int omap2_pwrdm_set_mem_retst(struct powerdomain *pwrdm, u8 bank,
 
 	m = omap2_pwrdm_get_mem_bank_retst_mask(bank);
 
-	omap2_prm_rmw_mod_reg_bits(m, (pwrst << __ffs(m)), pwrdm->prcm_offs,
+	omap2_prm_rmw_mod_reg_bits(m, field_prep(m, pwrst), pwrdm->prcm_offs,
 				   OMAP2_PM_PWSTCTRL);
 
 	return 0;
@@ -158,7 +159,7 @@ int omap2_pwrdm_set_logic_retst(struct powerdomain *pwrdm, u8 pwrst)
 {
 	u32 v;
 
-	v = pwrst << __ffs(OMAP_LOGICRETSTATE_MASK);
+	v = FIELD_PREP(OMAP_LOGICRETSTATE_MASK, pwrst);
 	omap2_prm_rmw_mod_reg_bits(OMAP_LOGICRETSTATE_MASK, v, pwrdm->prcm_offs,
 				   OMAP2_PM_PWSTCTRL);
 
diff --git a/arch/arm/mach-omap2/prm2xxx_3xxx.h b/arch/arm/mach-omap2/prm2xxx_3xxx.h
index 3d803f7182b98f04..5f438cca9f8a3584 100644
--- a/arch/arm/mach-omap2/prm2xxx_3xxx.h
+++ b/arch/arm/mach-omap2/prm2xxx_3xxx.h
@@ -46,6 +46,7 @@
 
 #ifndef __ASSEMBLER__
 
+#include <linux/bitfield.h>
 #include <linux/io.h>
 #include "powerdomain.h"
 
@@ -77,13 +78,7 @@ static inline u32 omap2_prm_rmw_mod_reg_bits(u32 mask, u32 bits, s16 module,
 /* Read a PRM register, AND it, and shift the result down to bit 0 */
 static inline u32 omap2_prm_read_mod_bits_shift(s16 domain, s16 idx, u32 mask)
 {
-	u32 v;
-
-	v = omap2_prm_read_mod_reg(domain, idx);
-	v &= mask;
-	v >>= __ffs(mask);
-
-	return v;
+	return field_get(mask, omap2_prm_read_mod_reg(domain, idx));
 }
 
 static inline u32 omap2_prm_set_mod_reg_bits(u32 bits, s16 module, s16 idx)
diff --git a/arch/arm/mach-omap2/prm33xx.c b/arch/arm/mach-omap2/prm33xx.c
index 9144cc0479afe19c..864420e9c2102df5 100644
--- a/arch/arm/mach-omap2/prm33xx.c
+++ b/arch/arm/mach-omap2/prm33xx.c
@@ -13,6 +13,7 @@
  * GNU General Public License for more details.
  */
 
+#include <linux/bitfield.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/errno.h>
@@ -149,37 +150,29 @@ static int am33xx_prm_deassert_hardreset(u8 shift, u8 st_shift, u8 part,
 static int am33xx_pwrdm_set_next_pwrst(struct powerdomain *pwrdm, u8 pwrst)
 {
 	am33xx_prm_rmw_reg_bits(OMAP_POWERSTATE_MASK,
-				(pwrst << OMAP_POWERSTATE_SHIFT),
+				FIELD_PREP(OMAP_POWERSTATE_MASK, pwrst),
 				pwrdm->prcm_offs, pwrdm->pwrstctrl_offs);
 	return 0;
 }
 
 static int am33xx_pwrdm_read_next_pwrst(struct powerdomain *pwrdm)
 {
-	u32 v;
-
-	v = am33xx_prm_read_reg(pwrdm->prcm_offs,  pwrdm->pwrstctrl_offs);
-	v &= OMAP_POWERSTATE_MASK;
-	v >>= OMAP_POWERSTATE_SHIFT;
+	u32 v = am33xx_prm_read_reg(pwrdm->prcm_offs,  pwrdm->pwrstctrl_offs);
 
-	return v;
+	return FIELD_GET(OMAP_POWERSTATE_MASK, v);
 }
 
 static int am33xx_pwrdm_read_pwrst(struct powerdomain *pwrdm)
 {
-	u32 v;
+	u32 v = am33xx_prm_read_reg(pwrdm->prcm_offs, pwrdm->pwrstst_offs);
 
-	v = am33xx_prm_read_reg(pwrdm->prcm_offs, pwrdm->pwrstst_offs);
-	v &= OMAP_POWERSTATEST_MASK;
-	v >>= OMAP_POWERSTATEST_SHIFT;
-
-	return v;
+	return FIELD_GET(OMAP_POWERSTATEST_MASK, v);
 }
 
 static int am33xx_pwrdm_set_lowpwrstchange(struct powerdomain *pwrdm)
 {
 	am33xx_prm_rmw_reg_bits(AM33XX_LOWPOWERSTATECHANGE_MASK,
-				(1 << AM33XX_LOWPOWERSTATECHANGE_SHIFT),
+				FIELD_PREP(AM33XX_LOWPOWERSTATECHANGE_MASK, 1),
 				pwrdm->prcm_offs, pwrdm->pwrstctrl_offs);
 	return 0;
 }
@@ -200,21 +193,17 @@ static int am33xx_pwrdm_set_logic_retst(struct powerdomain *pwrdm, u8 pwrst)
 	if (!m)
 		return -EINVAL;
 
-	am33xx_prm_rmw_reg_bits(m, (pwrst << __ffs(m)),
-				pwrdm->prcm_offs, pwrdm->pwrstctrl_offs);
+	am33xx_prm_rmw_reg_bits(m, field_prep(m, pwrst), pwrdm->prcm_offs,
+				pwrdm->pwrstctrl_offs);
 
 	return 0;
 }
 
 static int am33xx_pwrdm_read_logic_pwrst(struct powerdomain *pwrdm)
 {
-	u32 v;
+	u32 v = am33xx_prm_read_reg(pwrdm->prcm_offs, pwrdm->pwrstst_offs);
 
-	v = am33xx_prm_read_reg(pwrdm->prcm_offs, pwrdm->pwrstst_offs);
-	v &= AM33XX_LOGICSTATEST_MASK;
-	v >>= AM33XX_LOGICSTATEST_SHIFT;
-
-	return v;
+	return FIELD_GET(AM33XX_LOGICSTATEST_MASK, v);
 }
 
 static int am33xx_pwrdm_read_logic_retst(struct powerdomain *pwrdm)
@@ -226,10 +215,8 @@ static int am33xx_pwrdm_read_logic_retst(struct powerdomain *pwrdm)
 		return -EINVAL;
 
 	v = am33xx_prm_read_reg(pwrdm->prcm_offs, pwrdm->pwrstctrl_offs);
-	v &= m;
-	v >>= __ffs(m);
 
-	return v;
+	return field_get(m, v);
 }
 
 static int am33xx_pwrdm_set_mem_onst(struct powerdomain *pwrdm, u8 bank,
@@ -241,8 +228,8 @@ static int am33xx_pwrdm_set_mem_onst(struct powerdomain *pwrdm, u8 bank,
 	if (!m)
 		return -EINVAL;
 
-	am33xx_prm_rmw_reg_bits(m, (pwrst << __ffs(m)),
-				pwrdm->prcm_offs, pwrdm->pwrstctrl_offs);
+	am33xx_prm_rmw_reg_bits(m, field_prep(m, pwrst), pwrdm->prcm_offs,
+				pwrdm->pwrstctrl_offs);
 
 	return 0;
 }
@@ -256,8 +243,8 @@ static int am33xx_pwrdm_set_mem_retst(struct powerdomain *pwrdm, u8 bank,
 	if (!m)
 		return -EINVAL;
 
-	am33xx_prm_rmw_reg_bits(m, (pwrst << __ffs(m)),
-				pwrdm->prcm_offs, pwrdm->pwrstctrl_offs);
+	am33xx_prm_rmw_reg_bits(m, field_prep(m, pwrst), pwrdm->prcm_offs,
+				pwrdm->pwrstctrl_offs);
 
 	return 0;
 }
@@ -271,10 +258,8 @@ static int am33xx_pwrdm_read_mem_pwrst(struct powerdomain *pwrdm, u8 bank)
 		return -EINVAL;
 
 	v = am33xx_prm_read_reg(pwrdm->prcm_offs, pwrdm->pwrstst_offs);
-	v &= m;
-	v >>= __ffs(m);
 
-	return v;
+	return field_get(m, v);
 }
 
 static int am33xx_pwrdm_read_mem_retst(struct powerdomain *pwrdm, u8 bank)
@@ -286,10 +271,8 @@ static int am33xx_pwrdm_read_mem_retst(struct powerdomain *pwrdm, u8 bank)
 		return -EINVAL;
 
 	v = am33xx_prm_read_reg(pwrdm->prcm_offs, pwrdm->pwrstctrl_offs);
-	v &= m;
-	v >>= __ffs(m);
 
-	return v;
+	return field_get(m, v);
 }
 
 static int am33xx_pwrdm_wait_transition(struct powerdomain *pwrdm)
diff --git a/arch/arm/mach-omap2/prm3xxx.c b/arch/arm/mach-omap2/prm3xxx.c
index 1b442b1285693cd9..88c8963ff602589b 100644
--- a/arch/arm/mach-omap2/prm3xxx.c
+++ b/arch/arm/mach-omap2/prm3xxx.c
@@ -9,6 +9,7 @@
  * Rajendra Nayak <rnayak@ti.com>
  */
 
+#include <linux/bitfield.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/err.h>
@@ -536,7 +537,7 @@ void omap3_prm_save_scratchpad_contents(u32 *ptr)
 static int omap3_pwrdm_set_next_pwrst(struct powerdomain *pwrdm, u8 pwrst)
 {
 	omap2_prm_rmw_mod_reg_bits(OMAP_POWERSTATE_MASK,
-				   (pwrst << OMAP_POWERSTATE_SHIFT),
+				   FIELD_PREP(OMAP_POWERSTATE_MASK, pwrst),
 				   pwrdm->prcm_offs, OMAP2_PM_PWSTCTRL);
 	return 0;
 }
diff --git a/arch/arm/mach-omap2/prm44xx.c b/arch/arm/mach-omap2/prm44xx.c
index 25093c1e5b9ac927..629b0980d301e0a6 100644
--- a/arch/arm/mach-omap2/prm44xx.c
+++ b/arch/arm/mach-omap2/prm44xx.c
@@ -9,6 +9,7 @@
  * Rajendra Nayak <rnayak@ti.com>
  */
 
+#include <linux/bitfield.h>
 #include <linux/cpu_pm.h>
 #include <linux/kernel.h>
 #include <linux/delay.h>
@@ -316,10 +317,8 @@ static void omap44xx_prm_reconfigure_io_chain(void)
 				    inst,
 				    omap4_prcm_irq_setup.pm_ctrl);
 	omap_test_timeout(
-		(((omap4_prm_read_inst_reg(inst,
-					   omap4_prcm_irq_setup.pm_ctrl) &
-		   OMAP4430_WUCLK_STATUS_MASK) >>
-		  OMAP4430_WUCLK_STATUS_SHIFT) == 1),
+		(FIELD_GET(OMAP4430_WUCLK_STATUS_MASK,
+			   omap4_prm_read_inst_reg(inst, omap4_prcm_irq_setup.pm_ctrl)) == 1),
 		MAX_IOPAD_LATCH_TIME, i);
 	if (i == MAX_IOPAD_LATCH_TIME)
 		pr_warn("PRM: I/O chain clock line assertion timed out\n");
@@ -329,10 +328,8 @@ static void omap44xx_prm_reconfigure_io_chain(void)
 				    inst,
 				    omap4_prcm_irq_setup.pm_ctrl);
 	omap_test_timeout(
-		(((omap4_prm_read_inst_reg(inst,
-					   omap4_prcm_irq_setup.pm_ctrl) &
-		   OMAP4430_WUCLK_STATUS_MASK) >>
-		  OMAP4430_WUCLK_STATUS_SHIFT) == 0),
+		(FIELD_GET(OMAP4430_WUCLK_STATUS_MASK,
+			   omap4_prm_read_inst_reg(inst, omap4_prcm_irq_setup.pm_ctrl)) == 0),
 		MAX_IOPAD_LATCH_TIME, i);
 	if (i == MAX_IOPAD_LATCH_TIME)
 		pr_warn("PRM: I/O chain clock line deassertion timed out\n");
@@ -427,7 +424,7 @@ static void omap44xx_prm_clear_context_loss_flags_old(u8 part, s16 inst,
 static int omap4_pwrdm_set_next_pwrst(struct powerdomain *pwrdm, u8 pwrst)
 {
 	omap4_prminst_rmw_inst_reg_bits(OMAP_POWERSTATE_MASK,
-					(pwrst << OMAP_POWERSTATE_SHIFT),
+					FIELD_PREP(OMAP_POWERSTATE_MASK, pwrst),
 					pwrdm->prcm_partition,
 					pwrdm->prcm_offs, OMAP4_PM_PWSTCTRL);
 	return 0;
@@ -439,10 +436,8 @@ static int omap4_pwrdm_read_next_pwrst(struct powerdomain *pwrdm)
 
 	v = omap4_prminst_read_inst_reg(pwrdm->prcm_partition, pwrdm->prcm_offs,
 					OMAP4_PM_PWSTCTRL);
-	v &= OMAP_POWERSTATE_MASK;
-	v >>= OMAP_POWERSTATE_SHIFT;
 
-	return v;
+	return FIELD_GET(OMAP_POWERSTATE_MASK, v);
 }
 
 static int omap4_pwrdm_read_pwrst(struct powerdomain *pwrdm)
@@ -451,10 +446,8 @@ static int omap4_pwrdm_read_pwrst(struct powerdomain *pwrdm)
 
 	v = omap4_prminst_read_inst_reg(pwrdm->prcm_partition, pwrdm->prcm_offs,
 					OMAP4_PM_PWSTST);
-	v &= OMAP_POWERSTATEST_MASK;
-	v >>= OMAP_POWERSTATEST_SHIFT;
 
-	return v;
+	return FIELD_GET(OMAP_POWERSTATEST_MASK, v);
 }
 
 static int omap4_pwrdm_read_prev_pwrst(struct powerdomain *pwrdm)
@@ -463,16 +456,14 @@ static int omap4_pwrdm_read_prev_pwrst(struct powerdomain *pwrdm)
 
 	v = omap4_prminst_read_inst_reg(pwrdm->prcm_partition, pwrdm->prcm_offs,
 					OMAP4_PM_PWSTST);
-	v &= OMAP4430_LASTPOWERSTATEENTERED_MASK;
-	v >>= OMAP4430_LASTPOWERSTATEENTERED_SHIFT;
 
-	return v;
+	return FIELD_GET(OMAP4430_LASTPOWERSTATEENTERED_MASK, v);
 }
 
 static int omap4_pwrdm_set_lowpwrstchange(struct powerdomain *pwrdm)
 {
 	omap4_prminst_rmw_inst_reg_bits(OMAP4430_LOWPOWERSTATECHANGE_MASK,
-					(1 << OMAP4430_LOWPOWERSTATECHANGE_SHIFT),
+					FIELD_PREP(OMAP4430_LOWPOWERSTATECHANGE_MASK, 1),
 					pwrdm->prcm_partition,
 					pwrdm->prcm_offs, OMAP4_PM_PWSTCTRL);
 	return 0;
@@ -491,7 +482,7 @@ static int omap4_pwrdm_set_logic_retst(struct powerdomain *pwrdm, u8 pwrst)
 {
 	u32 v;
 
-	v = pwrst << __ffs(OMAP4430_LOGICRETSTATE_MASK);
+	v = FIELD_PREP(OMAP4430_LOGICRETSTATE_MASK, pwrst);
 	omap4_prminst_rmw_inst_reg_bits(OMAP4430_LOGICRETSTATE_MASK, v,
 					pwrdm->prcm_partition, pwrdm->prcm_offs,
 					OMAP4_PM_PWSTCTRL);
@@ -506,7 +497,7 @@ static int omap4_pwrdm_set_mem_onst(struct powerdomain *pwrdm, u8 bank,
 
 	m = omap2_pwrdm_get_mem_bank_onstate_mask(bank);
 
-	omap4_prminst_rmw_inst_reg_bits(m, (pwrst << __ffs(m)),
+	omap4_prminst_rmw_inst_reg_bits(m, field_prep(m, pwrst),
 					pwrdm->prcm_partition, pwrdm->prcm_offs,
 					OMAP4_PM_PWSTCTRL);
 
@@ -520,7 +511,7 @@ static int omap4_pwrdm_set_mem_retst(struct powerdomain *pwrdm, u8 bank,
 
 	m = omap2_pwrdm_get_mem_bank_retst_mask(bank);
 
-	omap4_prminst_rmw_inst_reg_bits(m, (pwrst << __ffs(m)),
+	omap4_prminst_rmw_inst_reg_bits(m, field_prep(m, pwrst),
 					pwrdm->prcm_partition, pwrdm->prcm_offs,
 					OMAP4_PM_PWSTCTRL);
 
@@ -533,10 +524,8 @@ static int omap4_pwrdm_read_logic_pwrst(struct powerdomain *pwrdm)
 
 	v = omap4_prminst_read_inst_reg(pwrdm->prcm_partition, pwrdm->prcm_offs,
 					OMAP4_PM_PWSTST);
-	v &= OMAP4430_LOGICSTATEST_MASK;
-	v >>= OMAP4430_LOGICSTATEST_SHIFT;
 
-	return v;
+	return FIELD_GET(OMAP4430_LOGICSTATEST_MASK, v);
 }
 
 static int omap4_pwrdm_read_logic_retst(struct powerdomain *pwrdm)
@@ -545,10 +534,8 @@ static int omap4_pwrdm_read_logic_retst(struct powerdomain *pwrdm)
 
 	v = omap4_prminst_read_inst_reg(pwrdm->prcm_partition, pwrdm->prcm_offs,
 					OMAP4_PM_PWSTCTRL);
-	v &= OMAP4430_LOGICRETSTATE_MASK;
-	v >>= OMAP4430_LOGICRETSTATE_SHIFT;
 
-	return v;
+	return FIELD_GET(OMAP4430_LOGICRETSTATE_MASK, v);
 }
 
 /**
@@ -587,10 +574,7 @@ static int omap4_pwrdm_read_mem_pwrst(struct powerdomain *pwrdm, u8 bank)
 
 	v = omap4_prminst_read_inst_reg(pwrdm->prcm_partition, pwrdm->prcm_offs,
 					OMAP4_PM_PWSTST);
-	v &= m;
-	v >>= __ffs(m);
-
-	return v;
+	return field_get(m, v);
 }
 
 static int omap4_pwrdm_read_mem_retst(struct powerdomain *pwrdm, u8 bank)
@@ -601,10 +585,7 @@ static int omap4_pwrdm_read_mem_retst(struct powerdomain *pwrdm, u8 bank)
 
 	v = omap4_prminst_read_inst_reg(pwrdm->prcm_partition, pwrdm->prcm_offs,
 					OMAP4_PM_PWSTCTRL);
-	v &= m;
-	v >>= __ffs(m);
-
-	return v;
+	return field_get(m, v);
 }
 
 /**
diff --git a/arch/arm/mach-omap2/vc.c b/arch/arm/mach-omap2/vc.c
index 86f1ac4c24125ae2..1a836627eee2eaec 100644
--- a/arch/arm/mach-omap2/vc.c
+++ b/arch/arm/mach-omap2/vc.c
@@ -7,6 +7,7 @@
  * License version 2. This program is licensed "as is" without any
  * warranty of any kind, whether express or implied.
  */
+#include <linux/bitfield.h>
 #include <linux/kernel.h>
 #include <linux/delay.h>
 #include <linux/init.h>
@@ -379,9 +380,8 @@ static void omap3_init_voltsetup1(struct voltagedomain *voltdm,
 
 	val = (voltdm->vc_param->on - idle) / voltdm->pmic->slew_rate;
 	val *= voltdm->sys_clk.rate / 8 / 1000000 + 1;
-	val <<= __ffs(voltdm->vfsm->voltsetup_mask);
 	c->voltsetup1 &= ~voltdm->vfsm->voltsetup_mask;
-	c->voltsetup1 |= val;
+	c->voltsetup1 |= field_prep(voltdm->vfsm->voltsetup_mask, val);
 }
 
 /**
@@ -772,7 +772,7 @@ static void __init omap_vc_i2c_init(struct voltagedomain *voltdm)
 	mcode = voltdm->pmic->i2c_mcode;
 	if (mcode)
 		voltdm->rmw(vc->common->i2c_mcode_mask,
-			    mcode << __ffs(vc->common->i2c_mcode_mask),
+			    field_prep(vc->common->i2c_mcode_mask, mcode),
 			    vc->common->i2c_cfg_reg);
 
 	if (cpu_is_omap44xx())
@@ -850,7 +850,7 @@ void __init omap_vc_init_channel(struct voltagedomain *voltdm)
 
 	/* Configure the i2c slave address for this VC */
 	voltdm->rmw(vc->smps_sa_mask,
-		    vc->i2c_slave_addr << __ffs(vc->smps_sa_mask),
+		    field_prep(vc->smps_sa_mask, vc->i2c_slave_addr),
 		    vc->smps_sa_reg);
 	vc->cfg_channel |= vc_cfg_bits->sa;
 
@@ -858,13 +858,13 @@ void __init omap_vc_init_channel(struct voltagedomain *voltdm)
 	 * Configure the PMIC register addresses.
 	 */
 	voltdm->rmw(vc->smps_volra_mask,
-		    vc->volt_reg_addr << __ffs(vc->smps_volra_mask),
+		    field_prep(vc->smps_volra_mask, vc->volt_reg_addr),
 		    vc->smps_volra_reg);
 	vc->cfg_channel |= vc_cfg_bits->rav;
 
 	if (vc->cmd_reg_addr) {
 		voltdm->rmw(vc->smps_cmdra_mask,
-			    vc->cmd_reg_addr << __ffs(vc->smps_cmdra_mask),
+			    field_prep(vc->smps_cmdra_mask, vc->cmd_reg_addr),
 			    vc->smps_cmdra_reg);
 		vc->cfg_channel |= vc_cfg_bits->rac;
 	}
diff --git a/arch/arm/mach-omap2/vp.c b/arch/arm/mach-omap2/vp.c
index a709655b978cbcc9..3071426a5ec116d7 100644
--- a/arch/arm/mach-omap2/vp.c
+++ b/arch/arm/mach-omap2/vp.c
@@ -1,4 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
+#include <linux/bitfield.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 
@@ -22,7 +23,7 @@ static u32 _vp_set_init_voltage(struct voltagedomain *voltdm, u32 volt)
 	vpconfig &= ~(vp->common->vpconfig_initvoltage_mask |
 		      vp->common->vpconfig_forceupdate |
 		      vp->common->vpconfig_initvdd);
-	vpconfig |= vsel << __ffs(vp->common->vpconfig_initvoltage_mask);
+	vpconfig |= field_prep(vp->common->vpconfig_initvoltage_mask, vsel);
 	voltdm->write(vpconfig, vp->vpconfig);
 
 	/* Trigger initVDD value copy to voltage processor */
@@ -73,8 +74,8 @@ void __init omap_vp_init(struct voltagedomain *voltdm)
 	 * VP_CONFIG: error gain is not set here, it will be updated
 	 * on each scale, based on OPP.
 	 */
-	val = (voltdm->pmic->vp_erroroffset <<
-	       __ffs(voltdm->vp->common->vpconfig_erroroffset_mask)) |
+	val = field_prep(voltdm->vp->common->vpconfig_erroroffset_mask,
+			 voltdm->pmic->vp_erroroffset) |
 		vp->common->vpconfig_timeouten;
 	voltdm->write(val, vp->vpconfig);
 
@@ -110,8 +111,8 @@ int omap_vp_update_errorgain(struct voltagedomain *voltdm,
 
 	/* Setting vp errorgain based on the voltage */
 	voltdm->rmw(voltdm->vp->common->vpconfig_errorgain_mask,
-		    volt_data->vp_errgain <<
-		    __ffs(voltdm->vp->common->vpconfig_errorgain_mask),
+		    field_prep(voltdm->vp->common->vpconfig_errorgain_mask,
+			       volt_data->vp_errgain),
 		    voltdm->vp->vpconfig);
 
 	return 0;
-- 
2.25.1

