Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC2E5459223
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 16:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240266AbhKVP7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 10:59:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240180AbhKVP6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 10:58:15 -0500
Received: from michel.telenet-ops.be (michel.telenet-ops.be [IPv6:2a02:1800:110:4::f00:18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A30AC061759
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 07:55:08 -0800 (PST)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed20:e4da:38c:79e9:48bf])
        by michel.telenet-ops.be with bizsmtp
        id MTuK2600Z4yPVd606TuK7s; Mon, 22 Nov 2021 16:55:06 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mpBe6-00EL3u-UU; Mon, 22 Nov 2021 16:54:18 +0100
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mpBe5-00HH2O-V9; Mon, 22 Nov 2021 16:54:17 +0100
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
Subject: [PATCH/RFC 17/17] rtw89: Use bitfield helpers
Date:   Mon, 22 Nov 2021 16:54:10 +0100
Message-Id: <f7b81122f7596fa004188bfae68f25a68c2d2392.1637592133.git.geert+renesas@glider.be>
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
 drivers/net/wireless/realtek/rtw89/core.h | 38 ++++-------------------
 1 file changed, 6 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index c2885e4dd882f045..f9c0300ec373aaf2 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -2994,81 +2994,55 @@ rtw89_write32_clr(struct rtw89_dev *rtwdev, u32 addr, u32 bit)
 static inline u32
 rtw89_read32_mask(struct rtw89_dev *rtwdev, u32 addr, u32 mask)
 {
-	u32 shift = __ffs(mask);
-	u32 orig;
-	u32 ret;
-
-	orig = rtw89_read32(rtwdev, addr);
-	ret = (orig & mask) >> shift;
-
-	return ret;
+	return field_get(mask, rtw89_read32(rtwdev, addr));
 }
 
 static inline u16
 rtw89_read16_mask(struct rtw89_dev *rtwdev, u32 addr, u32 mask)
 {
-	u32 shift = __ffs(mask);
-	u32 orig;
-	u32 ret;
-
-	orig = rtw89_read16(rtwdev, addr);
-	ret = (orig & mask) >> shift;
-
-	return ret;
+	return field_get(mask, rtw89_read16(rtwdev, addr));
 }
 
 static inline u8
 rtw89_read8_mask(struct rtw89_dev *rtwdev, u32 addr, u32 mask)
 {
-	u32 shift = __ffs(mask);
-	u32 orig;
-	u32 ret;
-
-	orig = rtw89_read8(rtwdev, addr);
-	ret = (orig & mask) >> shift;
-
-	return ret;
+	return field_get(mask, rtw89_read8(rtwdev, addr));
 }
 
 static inline void
 rtw89_write32_mask(struct rtw89_dev *rtwdev, u32 addr, u32 mask, u32 data)
 {
-	u32 shift = __ffs(mask);
 	u32 orig;
 	u32 set;
 
 	WARN(addr & 0x3, "should be 4-byte aligned, addr = 0x%08x\n", addr);
 
 	orig = rtw89_read32(rtwdev, addr);
-	set = (orig & ~mask) | ((data << shift) & mask);
+	set = (orig & ~mask) | field_prep(mask, data);
 	rtw89_write32(rtwdev, addr, set);
 }
 
 static inline void
 rtw89_write16_mask(struct rtw89_dev *rtwdev, u32 addr, u32 mask, u16 data)
 {
-	u32 shift;
 	u16 orig, set;
 
 	mask &= 0xffff;
-	shift = __ffs(mask);
 
 	orig = rtw89_read16(rtwdev, addr);
-	set = (orig & ~mask) | ((data << shift) & mask);
+	set = (orig & ~mask) | field_prep(mask, data);
 	rtw89_write16(rtwdev, addr, set);
 }
 
 static inline void
 rtw89_write8_mask(struct rtw89_dev *rtwdev, u32 addr, u32 mask, u8 data)
 {
-	u32 shift;
 	u8 orig, set;
 
 	mask &= 0xff;
-	shift = __ffs(mask);
 
 	orig = rtw89_read8(rtwdev, addr);
-	set = (orig & ~mask) | ((data << shift) & mask);
+	set = (orig & ~mask) | field_prep(mask, data);
 	rtw89_write8(rtwdev, addr, set);
 }
 
-- 
2.25.1

