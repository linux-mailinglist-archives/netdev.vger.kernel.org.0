Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2C07459215
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 16:57:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240260AbhKVP7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 10:59:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240252AbhKVP6t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 10:58:49 -0500
Received: from albert.telenet-ops.be (albert.telenet-ops.be [IPv6:2a02:1800:110:4::f00:1a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE143C0613F8
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 07:55:40 -0800 (PST)
Received: from ramsan.of.borg ([84.195.186.194])
        by albert.telenet-ops.be with bizsmtp
        id MTuy2600P4C55Sk06Tuyyk; Mon, 22 Nov 2021 16:55:40 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mpBe6-00EL3f-JA; Mon, 22 Nov 2021 16:54:18 +0100
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mpBe5-00HGz1-MW; Mon, 22 Nov 2021 16:54:17 +0100
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
Subject: [PATCH/RFC 09/17] iio: imu: st_lsm6dsx: Use bitfield helpers
Date:   Mon, 22 Nov 2021 16:54:02 +0100
Message-Id: <9b479b1a72c95c1c0d52b1782037bcaab7df856b.1637592133.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1637592133.git.geert+renesas@glider.be>
References: <cover.1637592133.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the field_prep() helper, instead of defining a custom macro, or
open-coding the same operation.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
Compile-tested only.
Marked RFC, as this depends on [PATCH 01/17], but follows a different
path to upstream.
---
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h       |  1 -
 .../iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c    |  7 +--
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c  | 45 +++++++++----------
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_shub.c  | 11 ++---
 4 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h
index 6ac4eac36458aa23..5282bdb0942e8d71 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h
@@ -62,7 +62,6 @@ enum st_lsm6dsx_hw_id {
 					 ST_LSM6DSX_SAMPLE_SIZE)
 #define ST_LSM6DSX_MAX_TAGGED_WORD_LEN	((32 / ST_LSM6DSX_TAGGED_SAMPLE_SIZE) \
 					 * ST_LSM6DSX_TAGGED_SAMPLE_SIZE)
-#define ST_LSM6DSX_SHIFT_VAL(val, mask)	(((val) << __ffs(mask)) & (mask))
 
 #define ST_LSM6DSX_CHANNEL_ACC(chan_type, addr, mod, scan_idx)		\
 {									\
diff --git a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c
index 16730a7809643695..80c763b837bfde01 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c
@@ -29,6 +29,7 @@
  * Lorenzo Bianconi <lorenzo.bianconi@st.com>
  * Denis Ciocca <denis.ciocca@st.com>
  */
+#include <linux/bitfield.h>
 #include <linux/module.h>
 #include <linux/iio/kfifo_buf.h>
 #include <linux/iio/iio.h>
@@ -155,7 +156,7 @@ static int st_lsm6dsx_update_decimators(struct st_lsm6dsx_hw *hw)
 
 		dec_reg = &hw->settings->decimator[sensor->id];
 		if (dec_reg->addr) {
-			int val = ST_LSM6DSX_SHIFT_VAL(data, dec_reg->mask);
+			int val = field_prep(dec_reg->mask, data);
 
 			err = st_lsm6dsx_update_bits_locked(hw, dec_reg->addr,
 							    dec_reg->mask,
@@ -177,7 +178,7 @@ static int st_lsm6dsx_update_decimators(struct st_lsm6dsx_hw *hw)
 	if (ts_dec_reg->addr) {
 		int val, ts_dec = !!hw->ts_sip;
 
-		val = ST_LSM6DSX_SHIFT_VAL(ts_dec, ts_dec_reg->mask);
+		val = field_prep(ts_dec_reg->mask, ts_dec);
 		err = st_lsm6dsx_update_bits_locked(hw, ts_dec_reg->addr,
 						    ts_dec_reg->mask, val);
 	}
@@ -215,7 +216,7 @@ static int st_lsm6dsx_set_fifo_odr(struct st_lsm6dsx_sensor *sensor,
 		} else {
 			data = 0;
 		}
-		val = ST_LSM6DSX_SHIFT_VAL(data, batch_reg->mask);
+		val = field_prep(batch_reg->mask, data);
 		return st_lsm6dsx_update_bits_locked(hw, batch_reg->addr,
 						     batch_reg->mask, val);
 	} else {
diff --git a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
index f2cbbc756459b1cb..f7f6783f8842ed98 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
@@ -46,6 +46,7 @@
  * Denis Ciocca <denis.ciocca@st.com>
  */
 
+#include <linux/bitfield.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/delay.h>
@@ -1159,7 +1160,7 @@ int st_lsm6dsx_set_page(struct st_lsm6dsx_hw *hw, bool enable)
 	int err;
 
 	hub_settings = &hw->settings->shub_settings;
-	data = ST_LSM6DSX_SHIFT_VAL(enable, hub_settings->page_mux.mask);
+	data = field_prep(hub_settings->page_mux.mask, enable);
 	err = regmap_update_bits(hw->regmap, hub_settings->page_mux.addr,
 				 hub_settings->page_mux.mask, data);
 	usleep_range(100, 150);
@@ -1220,8 +1221,7 @@ static int st_lsm6dsx_set_full_scale(struct st_lsm6dsx_sensor *sensor,
 	if (i == fs_table->fs_len)
 		return -EINVAL;
 
-	data = ST_LSM6DSX_SHIFT_VAL(fs_table->fs_avl[i].val,
-				    fs_table->reg.mask);
+	data = field_prep(fs_table->reg.mask, fs_table->fs_avl[i].val);
 	err = st_lsm6dsx_update_bits_locked(sensor->hw, fs_table->reg.addr,
 					    fs_table->reg.mask, data);
 	if (err < 0)
@@ -1319,7 +1319,7 @@ st_lsm6dsx_set_odr(struct st_lsm6dsx_sensor *sensor, u32 req_odr)
 	}
 
 	reg = &hw->settings->odr_table[ref_sensor->id].reg;
-	data = ST_LSM6DSX_SHIFT_VAL(val, reg->mask);
+	data = field_prep(reg->mask, val);
 	return st_lsm6dsx_update_bits_locked(hw, reg->addr, reg->mask, data);
 }
 
@@ -1473,7 +1473,7 @@ static int st_lsm6dsx_event_setup(struct st_lsm6dsx_hw *hw, int state)
 
 	reg = &hw->settings->event_settings.enable_reg;
 	if (reg->addr) {
-		data = ST_LSM6DSX_SHIFT_VAL(state, reg->mask);
+		data = field_prep(reg->mask, state);
 		err = st_lsm6dsx_update_bits_locked(hw, reg->addr,
 						    reg->mask, data);
 		if (err < 0)
@@ -1481,7 +1481,7 @@ static int st_lsm6dsx_event_setup(struct st_lsm6dsx_hw *hw, int state)
 	}
 
 	/* Enable wakeup interrupt */
-	data = ST_LSM6DSX_SHIFT_VAL(state, hw->irq_routing->mask);
+	data = field_prep(hw->irq_routing->mask, state);
 	return st_lsm6dsx_update_bits_locked(hw, hw->irq_routing->addr,
 					     hw->irq_routing->mask, data);
 }
@@ -1526,7 +1526,7 @@ st_lsm6dsx_write_event(struct iio_dev *iio_dev,
 		return -EINVAL;
 
 	reg = &hw->settings->event_settings.wakeup_reg;
-	data = ST_LSM6DSX_SHIFT_VAL(val, reg->mask);
+	data = field_prep(reg->mask, val);
 	err = st_lsm6dsx_update_bits_locked(hw, reg->addr,
 					    reg->mask, data);
 	if (err < 0)
@@ -1786,7 +1786,7 @@ static int st_lsm6dsx_init_shub(struct st_lsm6dsx_hw *hw)
 				return err;
 		}
 
-		data = ST_LSM6DSX_SHIFT_VAL(1, hub_settings->pullup_en.mask);
+		data = field_prep(hub_settings->pullup_en.mask, 1);
 		err = regmap_update_bits(hw->regmap,
 					 hub_settings->pullup_en.addr,
 					 hub_settings->pullup_en.mask, data);
@@ -1804,7 +1804,7 @@ static int st_lsm6dsx_init_shub(struct st_lsm6dsx_hw *hw)
 		if (err < 0)
 			return err;
 
-		data = ST_LSM6DSX_SHIFT_VAL(3, hub_settings->aux_sens.mask);
+		data = field_prep(hub_settings->aux_sens.mask, 3);
 		err = regmap_update_bits(hw->regmap,
 					 hub_settings->aux_sens.addr,
 					 hub_settings->aux_sens.mask, data);
@@ -1816,7 +1816,7 @@ static int st_lsm6dsx_init_shub(struct st_lsm6dsx_hw *hw)
 	}
 
 	if (hub_settings->emb_func.addr) {
-		data = ST_LSM6DSX_SHIFT_VAL(1, hub_settings->emb_func.mask);
+		data = field_prep(hub_settings->emb_func.mask, 1);
 		err = regmap_update_bits(hw->regmap,
 					 hub_settings->emb_func.addr,
 					 hub_settings->emb_func.mask, data);
@@ -1833,7 +1833,7 @@ static int st_lsm6dsx_init_hw_timer(struct st_lsm6dsx_hw *hw)
 	ts_settings = &hw->settings->ts_settings;
 	/* enable hw timestamp generation if necessary */
 	if (ts_settings->timer_en.addr) {
-		val = ST_LSM6DSX_SHIFT_VAL(1, ts_settings->timer_en.mask);
+		val = field_prep(ts_settings->timer_en.mask, 1);
 		err = regmap_update_bits(hw->regmap,
 					 ts_settings->timer_en.addr,
 					 ts_settings->timer_en.mask, val);
@@ -1843,7 +1843,7 @@ static int st_lsm6dsx_init_hw_timer(struct st_lsm6dsx_hw *hw)
 
 	/* enable high resolution for hw ts timer if necessary */
 	if (ts_settings->hr_timer.addr) {
-		val = ST_LSM6DSX_SHIFT_VAL(1, ts_settings->hr_timer.mask);
+		val = field_prep(ts_settings->hr_timer.mask, 1);
 		err = regmap_update_bits(hw->regmap,
 					 ts_settings->hr_timer.addr,
 					 ts_settings->hr_timer.mask, val);
@@ -1853,7 +1853,7 @@ static int st_lsm6dsx_init_hw_timer(struct st_lsm6dsx_hw *hw)
 
 	/* enable ts queueing in FIFO if necessary */
 	if (ts_settings->fifo_en.addr) {
-		val = ST_LSM6DSX_SHIFT_VAL(1, ts_settings->fifo_en.mask);
+		val = field_prep(ts_settings->fifo_en.mask, 1);
 		err = regmap_update_bits(hw->regmap,
 					 ts_settings->fifo_en.addr,
 					 ts_settings->fifo_en.mask, val);
@@ -1899,7 +1899,7 @@ static int st_lsm6dsx_reset_device(struct st_lsm6dsx_hw *hw)
 	/* device sw reset */
 	reg = &hw->settings->reset;
 	err = regmap_update_bits(hw->regmap, reg->addr, reg->mask,
-				 ST_LSM6DSX_SHIFT_VAL(1, reg->mask));
+				 field_prep(reg->mask, 1));
 	if (err < 0)
 		return err;
 
@@ -1908,7 +1908,7 @@ static int st_lsm6dsx_reset_device(struct st_lsm6dsx_hw *hw)
 	/* reload trimming parameter */
 	reg = &hw->settings->boot;
 	err = regmap_update_bits(hw->regmap, reg->addr, reg->mask,
-				 ST_LSM6DSX_SHIFT_VAL(1, reg->mask));
+				 field_prep(reg->mask, 1));
 	if (err < 0)
 		return err;
 
@@ -1929,7 +1929,7 @@ static int st_lsm6dsx_init_device(struct st_lsm6dsx_hw *hw)
 	/* enable Block Data Update */
 	reg = &hw->settings->bdu;
 	err = regmap_update_bits(hw->regmap, reg->addr, reg->mask,
-				 ST_LSM6DSX_SHIFT_VAL(1, reg->mask));
+				 field_prep(reg->mask, 1));
 	if (err < 0)
 		return err;
 
@@ -1939,7 +1939,7 @@ static int st_lsm6dsx_init_device(struct st_lsm6dsx_hw *hw)
 		return err;
 
 	err = regmap_update_bits(hw->regmap, reg->addr, reg->mask,
-				 ST_LSM6DSX_SHIFT_VAL(1, reg->mask));
+				 field_prep(reg->mask, 1));
 	if (err < 0)
 		return err;
 
@@ -1947,7 +1947,7 @@ static int st_lsm6dsx_init_device(struct st_lsm6dsx_hw *hw)
 	if (hw->settings->irq_config.lir.addr) {
 		reg = &hw->settings->irq_config.lir;
 		err = regmap_update_bits(hw->regmap, reg->addr, reg->mask,
-					 ST_LSM6DSX_SHIFT_VAL(1, reg->mask));
+					 field_prep(reg->mask, 1));
 		if (err < 0)
 			return err;
 
@@ -1956,7 +1956,7 @@ static int st_lsm6dsx_init_device(struct st_lsm6dsx_hw *hw)
 			reg = &hw->settings->irq_config.clear_on_read;
 			err = regmap_update_bits(hw->regmap,
 					reg->addr, reg->mask,
-					ST_LSM6DSX_SHIFT_VAL(1, reg->mask));
+					field_prep(reg->mask, 1));
 			if (err < 0)
 				return err;
 		}
@@ -1966,7 +1966,7 @@ static int st_lsm6dsx_init_device(struct st_lsm6dsx_hw *hw)
 	if (hw->settings->drdy_mask.addr) {
 		reg = &hw->settings->drdy_mask;
 		err = regmap_update_bits(hw->regmap, reg->addr, reg->mask,
-					 ST_LSM6DSX_SHIFT_VAL(1, reg->mask));
+					 field_prep(reg->mask, 1));
 		if (err < 0)
 			return err;
 	}
@@ -2131,8 +2131,7 @@ static int st_lsm6dsx_irq_setup(struct st_lsm6dsx_hw *hw)
 
 	reg = &hw->settings->irq_config.hla;
 	err = regmap_update_bits(hw->regmap, reg->addr, reg->mask,
-				 ST_LSM6DSX_SHIFT_VAL(irq_active_low,
-						      reg->mask));
+				 field_prep(reg->mask, irq_active_low));
 	if (err < 0)
 		return err;
 
@@ -2141,7 +2140,7 @@ static int st_lsm6dsx_irq_setup(struct st_lsm6dsx_hw *hw)
 	    (pdata && pdata->open_drain)) {
 		reg = &hw->settings->irq_config.od;
 		err = regmap_update_bits(hw->regmap, reg->addr, reg->mask,
-					 ST_LSM6DSX_SHIFT_VAL(1, reg->mask));
+					 field_prep(reg->mask, 1));
 		if (err < 0)
 			return err;
 
diff --git a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_shub.c b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_shub.c
index 99562ba85ee43098..ea0e568c042b4b43 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_shub.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_shub.c
@@ -22,6 +22,7 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  *
  */
+#include <linux/bitfield.h>
 #include <linux/module.h>
 #include <linux/regmap.h>
 #include <linux/iio/iio.h>
@@ -263,7 +264,7 @@ static int st_lsm6dsx_shub_master_enable(struct st_lsm6dsx_sensor *sensor,
 			goto out;
 	}
 
-	data = ST_LSM6DSX_SHIFT_VAL(enable, hub_settings->master_en.mask);
+	data = field_prep(hub_settings->master_en.mask, enable);
 	err = regmap_update_bits(hw->regmap, hub_settings->master_en.addr,
 				 hub_settings->master_en.mask, data);
 
@@ -296,7 +297,7 @@ st_lsm6dsx_shub_read(struct st_lsm6dsx_sensor *sensor, u8 addr,
 	aux_sens = &hw->settings->shub_settings.aux_sens;
 	/* do not overwrite aux_sens */
 	if (slv_addr + 2 == aux_sens->addr)
-		slv_config = ST_LSM6DSX_SHIFT_VAL(3, aux_sens->mask);
+		slv_config = field_prep(aux_sens->mask, 3);
 
 	config[0] = (sensor->ext_info.addr << 1) | 1;
 	config[1] = addr;
@@ -346,7 +347,7 @@ st_lsm6dsx_shub_write(struct st_lsm6dsx_sensor *sensor, u8 addr,
 	if (hub_settings->wr_once.addr) {
 		unsigned int data;
 
-		data = ST_LSM6DSX_SHIFT_VAL(1, hub_settings->wr_once.mask);
+		data = field_prep(hub_settings->wr_once.mask, 1);
 		err = st_lsm6dsx_shub_write_reg_with_mask(hw,
 			hub_settings->wr_once.addr,
 			hub_settings->wr_once.mask,
@@ -395,7 +396,7 @@ st_lsm6dsx_shub_write_with_mask(struct st_lsm6dsx_sensor *sensor,
 	if (err < 0)
 		return err;
 
-	data = ((data & ~mask) | (val << __ffs(mask) & mask));
+	data = (data & ~mask) | field_prep(mask, val);
 
 	return st_lsm6dsx_shub_write(sensor, addr, &data, sizeof(data));
 }
@@ -835,7 +836,7 @@ st_lsm6dsx_shub_check_wai(struct st_lsm6dsx_hw *hw, u8 *i2c_addr,
 	slv_addr = ST_LSM6DSX_SLV_ADDR(0, hub_settings->slv0_addr);
 	/* do not overwrite aux_sens */
 	if (slv_addr + 2 == aux_sens->addr)
-		slv_config = ST_LSM6DSX_SHIFT_VAL(3, aux_sens->mask);
+		slv_config = field_prep(aux_sens->mask, 3);
 
 	for (i = 0; i < ARRAY_SIZE(settings->i2c_addr); i++) {
 		if (!settings->i2c_addr[i])
-- 
2.25.1

