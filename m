Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24CF5546853
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 16:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345730AbiFJObB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 10:31:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241014AbiFJOaw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 10:30:52 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE85A5EBCD;
        Fri, 10 Jun 2022 07:30:46 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id l7-20020a17090aaa8700b001dd1a5b9965so2237787pjq.2;
        Fri, 10 Jun 2022 07:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X6sw+uVo9+V5bniSOny1T/rm2LBgg1eN3C+QvtIkJCI=;
        b=pEgY7nSPtxvSt+FjYPPEDWki+DhXVKfr1tlENRecO0g0SaQKz3GEnOw9kBiv4soAeu
         3ztmrNqQJV75ISw27kPmcpcPS9elEkON216GySSnkEF6KPSJmg7PkzUhz3q4yBAzuE+e
         3haxRinMfpt00e0OjmBoDEB7SardKC06SJh1A2vEvNT22Nj37t+/G6Xdrsy4pC8LjO98
         PTFnO5aLPAc0C9Ea+g+b3v+0pHUtDPmfcXf5bJ0chN9CJ+XP1H6928jswi3CmB2LHK/U
         T/YpXiB9v4zyitoN7wyWFHZ/HhaouUS1RtJd+qXtt7QT4ODAB+XtwqIjsxHIswom7RW1
         /FfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=X6sw+uVo9+V5bniSOny1T/rm2LBgg1eN3C+QvtIkJCI=;
        b=h5P7gAHvfiRp0lfY0BsQUVSrg6G3yu+2kSrMrgAghVuoS9DYT1E3CTS3bKm3SG3ags
         0p793M8xme1tJe+HlTx9/OVK9lruHFEG/F1McpGLNeE3SqDh9FcqF6ebdhH8BkIKN40r
         mAqlzOJW2qCdYDxekHr1/ibO++5TYYaVbFPfIqU+/HQzX0O2xesXIEMCwbzCSV0LbWK+
         1KYdGHkgtvbovTOBphzgRIUf96HmcirsznEftWzmQn22KrAaZ5VD6WVams1g0+yNLllq
         5L+70lHlJ7rIjpHgjufVuIvJQYAh5FPso8ZDczwIAgqiTtWBO9gKeVg1/BnYbIKfFZ74
         C7Mw==
X-Gm-Message-State: AOAM530kB8foadPuQIhdJ9AiNA5mF2L9HdV5imeBl1dZSKDhflB9BmlW
        3Y+ePchyM0xotGJ+70bMYp0=
X-Google-Smtp-Source: ABdhPJzfaLRiAtjcwugKh5ceP0Wd7Slm5e4Rd1CNJ3QDY6xchLoOo27Mhvc4LcmYQsk4dkSN+b8yhQ==
X-Received: by 2002:a17:903:18a:b0:166:ba97:8b19 with SMTP id z10-20020a170903018a00b00166ba978b19mr39761433plg.62.1654871446350;
        Fri, 10 Jun 2022 07:30:46 -0700 (PDT)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id s6-20020a170902ea0600b0016232dbd01fsm18851339plg.292.2022.06.10.07.30.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jun 2022 07:30:45 -0700 (PDT)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Staudt <max@enpas.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v6 3/7] can: bittiming: move bittiming calculation functions to calc_bittiming.c
Date:   Fri, 10 Jun 2022 23:30:05 +0900
Message-Id: <20220610143009.323579-4-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220610143009.323579-1-mailhol.vincent@wanadoo.fr>
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220610143009.323579-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The canonical way to select or deselect an object during compilation
is to use this pattern in the relevant Makefile:

bar-$(CONFIG_FOO) := foo.o

bittiming.c instead uses some #ifdef CONFIG_CAN_CALC_BITTIMG.

Create a new file named calc_bittiming.c with all the functions which
are conditionally compiled with CONFIG_CAN_CALC_BITTIMG and modify the
Makefile according to above pattern.

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 drivers/net/can/Kconfig              |   4 +
 drivers/net/can/dev/Makefile         |   1 +
 drivers/net/can/dev/bittiming.c      | 197 --------------------------
 drivers/net/can/dev/calc_bittiming.c | 202 +++++++++++++++++++++++++++
 4 files changed, 207 insertions(+), 197 deletions(-)
 create mode 100644 drivers/net/can/dev/calc_bittiming.c

diff --git a/drivers/net/can/Kconfig b/drivers/net/can/Kconfig
index 3c692af16676..87470feae6b1 100644
--- a/drivers/net/can/Kconfig
+++ b/drivers/net/can/Kconfig
@@ -96,6 +96,10 @@ config CAN_CALC_BITTIMING
 	  source clock frequencies. Disabling saves some space, but then the
 	  bit-timing parameters must be specified directly using the Netlink
 	  arguments "tq", "prop_seg", "phase_seg1", "phase_seg2" and "sjw".
+
+	  The additional features selected by this option will be added to the
+	  can-dev module.
+
 	  If unsure, say Y.
 
 config CAN_AT91
diff --git a/drivers/net/can/dev/Makefile b/drivers/net/can/dev/Makefile
index 1baaf7020f7c..791e6b297ea3 100644
--- a/drivers/net/can/dev/Makefile
+++ b/drivers/net/can/dev/Makefile
@@ -4,6 +4,7 @@ obj-$(CONFIG_CAN_DEV) += can-dev.o
 
 can-dev-y += skb.o
 
+can-dev-$(CONFIG_CAN_CALC_BITTIMING) += calc_bittiming.o
 can-dev-$(CONFIG_CAN_NETLINK) += bittiming.o
 can-dev-$(CONFIG_CAN_NETLINK) += dev.o
 can-dev-$(CONFIG_CAN_NETLINK) += length.o
diff --git a/drivers/net/can/dev/bittiming.c b/drivers/net/can/dev/bittiming.c
index c1e76f0a5064..7ae80763c960 100644
--- a/drivers/net/can/dev/bittiming.c
+++ b/drivers/net/can/dev/bittiming.c
@@ -4,205 +4,8 @@
  * Copyright (C) 2008-2009 Wolfgang Grandegger <wg@grandegger.com>
  */
 
-#include <linux/units.h>
 #include <linux/can/dev.h>
 
-#ifdef CONFIG_CAN_CALC_BITTIMING
-#define CAN_CALC_MAX_ERROR 50 /* in one-tenth of a percent */
-
-/* Bit-timing calculation derived from:
- *
- * Code based on LinCAN sources and H8S2638 project
- * Copyright 2004-2006 Pavel Pisa - DCE FELK CVUT cz
- * Copyright 2005      Stanislav Marek
- * email: pisa@cmp.felk.cvut.cz
- *
- * Calculates proper bit-timing parameters for a specified bit-rate
- * and sample-point, which can then be used to set the bit-timing
- * registers of the CAN controller. You can find more information
- * in the header file linux/can/netlink.h.
- */
-static int
-can_update_sample_point(const struct can_bittiming_const *btc,
-			const unsigned int sample_point_nominal, const unsigned int tseg,
-			unsigned int *tseg1_ptr, unsigned int *tseg2_ptr,
-			unsigned int *sample_point_error_ptr)
-{
-	unsigned int sample_point_error, best_sample_point_error = UINT_MAX;
-	unsigned int sample_point, best_sample_point = 0;
-	unsigned int tseg1, tseg2;
-	int i;
-
-	for (i = 0; i <= 1; i++) {
-		tseg2 = tseg + CAN_SYNC_SEG -
-			(sample_point_nominal * (tseg + CAN_SYNC_SEG)) /
-			1000 - i;
-		tseg2 = clamp(tseg2, btc->tseg2_min, btc->tseg2_max);
-		tseg1 = tseg - tseg2;
-		if (tseg1 > btc->tseg1_max) {
-			tseg1 = btc->tseg1_max;
-			tseg2 = tseg - tseg1;
-		}
-
-		sample_point = 1000 * (tseg + CAN_SYNC_SEG - tseg2) /
-			(tseg + CAN_SYNC_SEG);
-		sample_point_error = abs(sample_point_nominal - sample_point);
-
-		if (sample_point <= sample_point_nominal &&
-		    sample_point_error < best_sample_point_error) {
-			best_sample_point = sample_point;
-			best_sample_point_error = sample_point_error;
-			*tseg1_ptr = tseg1;
-			*tseg2_ptr = tseg2;
-		}
-	}
-
-	if (sample_point_error_ptr)
-		*sample_point_error_ptr = best_sample_point_error;
-
-	return best_sample_point;
-}
-
-int can_calc_bittiming(const struct net_device *dev, struct can_bittiming *bt,
-		       const struct can_bittiming_const *btc)
-{
-	struct can_priv *priv = netdev_priv(dev);
-	unsigned int bitrate;			/* current bitrate */
-	unsigned int bitrate_error;		/* difference between current and nominal value */
-	unsigned int best_bitrate_error = UINT_MAX;
-	unsigned int sample_point_error;	/* difference between current and nominal value */
-	unsigned int best_sample_point_error = UINT_MAX;
-	unsigned int sample_point_nominal;	/* nominal sample point */
-	unsigned int best_tseg = 0;		/* current best value for tseg */
-	unsigned int best_brp = 0;		/* current best value for brp */
-	unsigned int brp, tsegall, tseg, tseg1 = 0, tseg2 = 0;
-	u64 v64;
-
-	/* Use CiA recommended sample points */
-	if (bt->sample_point) {
-		sample_point_nominal = bt->sample_point;
-	} else {
-		if (bt->bitrate > 800 * KILO /* BPS */)
-			sample_point_nominal = 750;
-		else if (bt->bitrate > 500 * KILO /* BPS */)
-			sample_point_nominal = 800;
-		else
-			sample_point_nominal = 875;
-	}
-
-	/* tseg even = round down, odd = round up */
-	for (tseg = (btc->tseg1_max + btc->tseg2_max) * 2 + 1;
-	     tseg >= (btc->tseg1_min + btc->tseg2_min) * 2; tseg--) {
-		tsegall = CAN_SYNC_SEG + tseg / 2;
-
-		/* Compute all possible tseg choices (tseg=tseg1+tseg2) */
-		brp = priv->clock.freq / (tsegall * bt->bitrate) + tseg % 2;
-
-		/* choose brp step which is possible in system */
-		brp = (brp / btc->brp_inc) * btc->brp_inc;
-		if (brp < btc->brp_min || brp > btc->brp_max)
-			continue;
-
-		bitrate = priv->clock.freq / (brp * tsegall);
-		bitrate_error = abs(bt->bitrate - bitrate);
-
-		/* tseg brp biterror */
-		if (bitrate_error > best_bitrate_error)
-			continue;
-
-		/* reset sample point error if we have a better bitrate */
-		if (bitrate_error < best_bitrate_error)
-			best_sample_point_error = UINT_MAX;
-
-		can_update_sample_point(btc, sample_point_nominal, tseg / 2,
-					&tseg1, &tseg2, &sample_point_error);
-		if (sample_point_error >= best_sample_point_error)
-			continue;
-
-		best_sample_point_error = sample_point_error;
-		best_bitrate_error = bitrate_error;
-		best_tseg = tseg / 2;
-		best_brp = brp;
-
-		if (bitrate_error == 0 && sample_point_error == 0)
-			break;
-	}
-
-	if (best_bitrate_error) {
-		/* Error in one-tenth of a percent */
-		v64 = (u64)best_bitrate_error * 1000;
-		do_div(v64, bt->bitrate);
-		bitrate_error = (u32)v64;
-		if (bitrate_error > CAN_CALC_MAX_ERROR) {
-			netdev_err(dev,
-				   "bitrate error %d.%d%% too high\n",
-				   bitrate_error / 10, bitrate_error % 10);
-			return -EDOM;
-		}
-		netdev_warn(dev, "bitrate error %d.%d%%\n",
-			    bitrate_error / 10, bitrate_error % 10);
-	}
-
-	/* real sample point */
-	bt->sample_point = can_update_sample_point(btc, sample_point_nominal,
-						   best_tseg, &tseg1, &tseg2,
-						   NULL);
-
-	v64 = (u64)best_brp * 1000 * 1000 * 1000;
-	do_div(v64, priv->clock.freq);
-	bt->tq = (u32)v64;
-	bt->prop_seg = tseg1 / 2;
-	bt->phase_seg1 = tseg1 - bt->prop_seg;
-	bt->phase_seg2 = tseg2;
-
-	/* check for sjw user settings */
-	if (!bt->sjw || !btc->sjw_max) {
-		bt->sjw = 1;
-	} else {
-		/* bt->sjw is at least 1 -> sanitize upper bound to sjw_max */
-		if (bt->sjw > btc->sjw_max)
-			bt->sjw = btc->sjw_max;
-		/* bt->sjw must not be higher than tseg2 */
-		if (tseg2 < bt->sjw)
-			bt->sjw = tseg2;
-	}
-
-	bt->brp = best_brp;
-
-	/* real bitrate */
-	bt->bitrate = priv->clock.freq /
-		(bt->brp * (CAN_SYNC_SEG + tseg1 + tseg2));
-
-	return 0;
-}
-
-void can_calc_tdco(struct can_tdc *tdc, const struct can_tdc_const *tdc_const,
-		   const struct can_bittiming *dbt,
-		   u32 *ctrlmode, u32 ctrlmode_supported)
-
-{
-	if (!tdc_const || !(ctrlmode_supported & CAN_CTRLMODE_TDC_AUTO))
-		return;
-
-	*ctrlmode &= ~CAN_CTRLMODE_TDC_MASK;
-
-	/* As specified in ISO 11898-1 section 11.3.3 "Transmitter
-	 * delay compensation" (TDC) is only applicable if data BRP is
-	 * one or two.
-	 */
-	if (dbt->brp == 1 || dbt->brp == 2) {
-		/* Sample point in clock periods */
-		u32 sample_point_in_tc = (CAN_SYNC_SEG + dbt->prop_seg +
-					  dbt->phase_seg1) * dbt->brp;
-
-		if (sample_point_in_tc < tdc_const->tdco_min)
-			return;
-		tdc->tdco = min(sample_point_in_tc, tdc_const->tdco_max);
-		*ctrlmode |= CAN_CTRLMODE_TDC_AUTO;
-	}
-}
-#endif /* CONFIG_CAN_CALC_BITTIMING */
-
 /* Checks the validity of the specified bit-timing parameters prop_seg,
  * phase_seg1, phase_seg2 and sjw and tries to determine the bitrate
  * prescaler value brp. You can find more information in the header
diff --git a/drivers/net/can/dev/calc_bittiming.c b/drivers/net/can/dev/calc_bittiming.c
new file mode 100644
index 000000000000..d3caa040614d
--- /dev/null
+++ b/drivers/net/can/dev/calc_bittiming.c
@@ -0,0 +1,202 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (C) 2005 Marc Kleine-Budde, Pengutronix
+ * Copyright (C) 2006 Andrey Volkov, Varma Electronics
+ * Copyright (C) 2008-2009 Wolfgang Grandegger <wg@grandegger.com>
+ */
+
+#include <linux/units.h>
+#include <linux/can/dev.h>
+
+#define CAN_CALC_MAX_ERROR 50 /* in one-tenth of a percent */
+
+/* Bit-timing calculation derived from:
+ *
+ * Code based on LinCAN sources and H8S2638 project
+ * Copyright 2004-2006 Pavel Pisa - DCE FELK CVUT cz
+ * Copyright 2005      Stanislav Marek
+ * email: pisa@cmp.felk.cvut.cz
+ *
+ * Calculates proper bit-timing parameters for a specified bit-rate
+ * and sample-point, which can then be used to set the bit-timing
+ * registers of the CAN controller. You can find more information
+ * in the header file linux/can/netlink.h.
+ */
+static int
+can_update_sample_point(const struct can_bittiming_const *btc,
+			const unsigned int sample_point_nominal, const unsigned int tseg,
+			unsigned int *tseg1_ptr, unsigned int *tseg2_ptr,
+			unsigned int *sample_point_error_ptr)
+{
+	unsigned int sample_point_error, best_sample_point_error = UINT_MAX;
+	unsigned int sample_point, best_sample_point = 0;
+	unsigned int tseg1, tseg2;
+	int i;
+
+	for (i = 0; i <= 1; i++) {
+		tseg2 = tseg + CAN_SYNC_SEG -
+			(sample_point_nominal * (tseg + CAN_SYNC_SEG)) /
+			1000 - i;
+		tseg2 = clamp(tseg2, btc->tseg2_min, btc->tseg2_max);
+		tseg1 = tseg - tseg2;
+		if (tseg1 > btc->tseg1_max) {
+			tseg1 = btc->tseg1_max;
+			tseg2 = tseg - tseg1;
+		}
+
+		sample_point = 1000 * (tseg + CAN_SYNC_SEG - tseg2) /
+			(tseg + CAN_SYNC_SEG);
+		sample_point_error = abs(sample_point_nominal - sample_point);
+
+		if (sample_point <= sample_point_nominal &&
+		    sample_point_error < best_sample_point_error) {
+			best_sample_point = sample_point;
+			best_sample_point_error = sample_point_error;
+			*tseg1_ptr = tseg1;
+			*tseg2_ptr = tseg2;
+		}
+	}
+
+	if (sample_point_error_ptr)
+		*sample_point_error_ptr = best_sample_point_error;
+
+	return best_sample_point;
+}
+
+int can_calc_bittiming(const struct net_device *dev, struct can_bittiming *bt,
+		       const struct can_bittiming_const *btc)
+{
+	struct can_priv *priv = netdev_priv(dev);
+	unsigned int bitrate;			/* current bitrate */
+	unsigned int bitrate_error;		/* difference between current and nominal value */
+	unsigned int best_bitrate_error = UINT_MAX;
+	unsigned int sample_point_error;	/* difference between current and nominal value */
+	unsigned int best_sample_point_error = UINT_MAX;
+	unsigned int sample_point_nominal;	/* nominal sample point */
+	unsigned int best_tseg = 0;		/* current best value for tseg */
+	unsigned int best_brp = 0;		/* current best value for brp */
+	unsigned int brp, tsegall, tseg, tseg1 = 0, tseg2 = 0;
+	u64 v64;
+
+	/* Use CiA recommended sample points */
+	if (bt->sample_point) {
+		sample_point_nominal = bt->sample_point;
+	} else {
+		if (bt->bitrate > 800 * KILO /* BPS */)
+			sample_point_nominal = 750;
+		else if (bt->bitrate > 500 * KILO /* BPS */)
+			sample_point_nominal = 800;
+		else
+			sample_point_nominal = 875;
+	}
+
+	/* tseg even = round down, odd = round up */
+	for (tseg = (btc->tseg1_max + btc->tseg2_max) * 2 + 1;
+	     tseg >= (btc->tseg1_min + btc->tseg2_min) * 2; tseg--) {
+		tsegall = CAN_SYNC_SEG + tseg / 2;
+
+		/* Compute all possible tseg choices (tseg=tseg1+tseg2) */
+		brp = priv->clock.freq / (tsegall * bt->bitrate) + tseg % 2;
+
+		/* choose brp step which is possible in system */
+		brp = (brp / btc->brp_inc) * btc->brp_inc;
+		if (brp < btc->brp_min || brp > btc->brp_max)
+			continue;
+
+		bitrate = priv->clock.freq / (brp * tsegall);
+		bitrate_error = abs(bt->bitrate - bitrate);
+
+		/* tseg brp biterror */
+		if (bitrate_error > best_bitrate_error)
+			continue;
+
+		/* reset sample point error if we have a better bitrate */
+		if (bitrate_error < best_bitrate_error)
+			best_sample_point_error = UINT_MAX;
+
+		can_update_sample_point(btc, sample_point_nominal, tseg / 2,
+					&tseg1, &tseg2, &sample_point_error);
+		if (sample_point_error >= best_sample_point_error)
+			continue;
+
+		best_sample_point_error = sample_point_error;
+		best_bitrate_error = bitrate_error;
+		best_tseg = tseg / 2;
+		best_brp = brp;
+
+		if (bitrate_error == 0 && sample_point_error == 0)
+			break;
+	}
+
+	if (best_bitrate_error) {
+		/* Error in one-tenth of a percent */
+		v64 = (u64)best_bitrate_error * 1000;
+		do_div(v64, bt->bitrate);
+		bitrate_error = (u32)v64;
+		if (bitrate_error > CAN_CALC_MAX_ERROR) {
+			netdev_err(dev,
+				   "bitrate error %d.%d%% too high\n",
+				   bitrate_error / 10, bitrate_error % 10);
+			return -EDOM;
+		}
+		netdev_warn(dev, "bitrate error %d.%d%%\n",
+			    bitrate_error / 10, bitrate_error % 10);
+	}
+
+	/* real sample point */
+	bt->sample_point = can_update_sample_point(btc, sample_point_nominal,
+						   best_tseg, &tseg1, &tseg2,
+						   NULL);
+
+	v64 = (u64)best_brp * 1000 * 1000 * 1000;
+	do_div(v64, priv->clock.freq);
+	bt->tq = (u32)v64;
+	bt->prop_seg = tseg1 / 2;
+	bt->phase_seg1 = tseg1 - bt->prop_seg;
+	bt->phase_seg2 = tseg2;
+
+	/* check for sjw user settings */
+	if (!bt->sjw || !btc->sjw_max) {
+		bt->sjw = 1;
+	} else {
+		/* bt->sjw is at least 1 -> sanitize upper bound to sjw_max */
+		if (bt->sjw > btc->sjw_max)
+			bt->sjw = btc->sjw_max;
+		/* bt->sjw must not be higher than tseg2 */
+		if (tseg2 < bt->sjw)
+			bt->sjw = tseg2;
+	}
+
+	bt->brp = best_brp;
+
+	/* real bitrate */
+	bt->bitrate = priv->clock.freq /
+		(bt->brp * (CAN_SYNC_SEG + tseg1 + tseg2));
+
+	return 0;
+}
+
+void can_calc_tdco(struct can_tdc *tdc, const struct can_tdc_const *tdc_const,
+		   const struct can_bittiming *dbt,
+		   u32 *ctrlmode, u32 ctrlmode_supported)
+
+{
+	if (!tdc_const || !(ctrlmode_supported & CAN_CTRLMODE_TDC_AUTO))
+		return;
+
+	*ctrlmode &= ~CAN_CTRLMODE_TDC_MASK;
+
+	/* As specified in ISO 11898-1 section 11.3.3 "Transmitter
+	 * delay compensation" (TDC) is only applicable if data BRP is
+	 * one or two.
+	 */
+	if (dbt->brp == 1 || dbt->brp == 2) {
+		/* Sample point in clock periods */
+		u32 sample_point_in_tc = (CAN_SYNC_SEG + dbt->prop_seg +
+					  dbt->phase_seg1) * dbt->brp;
+
+		if (sample_point_in_tc < tdc_const->tdco_min)
+			return;
+		tdc->tdco = min(sample_point_in_tc, tdc_const->tdco_max);
+		*ctrlmode |= CAN_CTRLMODE_TDC_AUTO;
+	}
+}
-- 
2.35.1

