Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07F682C92D9
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 00:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388938AbgK3Xio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 18:38:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387738AbgK3Xin (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 18:38:43 -0500
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48BB1C0617A6
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 15:37:19 -0800 (PST)
Received: by mail-il1-x144.google.com with SMTP id q1so13094264ilt.6
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 15:37:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9pzSYVU1xS021lAMo10yE/erRoJ8GUJHXYQ95VWiPx4=;
        b=x1MZk3eKkbsYW58GubxIl14zzAAcUc32FIYDsVH7DuMSHuLuqysjAIsSPUfGyY8ZP6
         kKEChsykQRc6/UOWSqv6vakEtwGgwjC0461xxaCe4i4edQGoVyK4GOJxt00Ff+QDWR3o
         ee3EsFFvkSw8gNTxL0ntymgTvdPN9N/QsILhGq+Bq4jUtNyHC6awzCINegdnToAdje9y
         vTq87QP+fYtHIeBYq5hqsP+dnrdbUPyWORl/FZft1YwksIR6kOBa6xdidZrtxOoP4ebe
         6gbSq7sq8xfNCm9z61GXMl8L2/Mz+nNse8Y8NF5e8nyrFH/B3SJir/7hoHZHOayndRGS
         FhnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9pzSYVU1xS021lAMo10yE/erRoJ8GUJHXYQ95VWiPx4=;
        b=A9NmNp0A8Xv4z+4xn4cm/ii2VkJBe7NW01LDthjjT2LVzAP8InGpkJ4XCwkOmdspJK
         JUlIVhHylSmyY5G8x1VxznYxgKIdL1foU2LZYXUywdQSS2YbSsVRhT57wbJlHyoEO59W
         WXSYBYZNaX3qTNHr0Uz3bF2ckAQ7cB1WSdsIO4rMe6fOR7mFpy2hUp+LVE/N/cfPweaG
         HNCCDoy1jjLsN4KtGOnrwv7QNSA0Sw5JmWXPnnM8BZG/jICp+WH5PzJ/yQVzeWLMCDoi
         /IHaD2AGmRBbBDotq6DFVKn5Y9y8CwokoTPTNQUJ80379N/wjTrRV3PvegLafjrbzmIE
         REWg==
X-Gm-Message-State: AOAM5331vQeZxQqdZ3UqT/MtC+xm6BW45nRAB9DchOc/iRtB/rmCaAMk
        qAtwSjyBzTDuidBUsogFMshM/w==
X-Google-Smtp-Source: ABdhPJwt7wyUPVLYlRQ4/yMJryR26YDEeaXgj54adv87I7GZENeACUDhdu2r0iTt1BCM73UFeKeNqw==
X-Received: by 2002:a92:c70b:: with SMTP id a11mr95893ilp.151.1606779438640;
        Mon, 30 Nov 2020 15:37:18 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id o195sm62574ila.38.2020.11.30.15.37.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 15:37:18 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/4] net: ipa: set up IPA v4.5 Qtime configuration
Date:   Mon, 30 Nov 2020 17:37:10 -0600
Message-Id: <20201130233712.29113-3-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201130233712.29113-1-elder@linaro.org>
References: <20201130233712.29113-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPA v4.5 introduces a new unified timer architecture driven on the
19.2 MHz SoC crystal oscillator (XO).  It is independent of the IPA
core clock and avoids some duplication.

Lower-resolution time stamps are derived from this by using only the
high-order bits of the 19.2 MHz Qtime clock.  And timers are derived
from this based on "pulse generators" configured to fire at a fixed
rate based on the Qtime clock.

This patch introduces ipa_qtime_config(), which configures the Qtime
mechanism for use.  It also adds to the IPA register definitions
related to timers and time stamping.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_main.c | 67 +++++++++++++++++++++++++++++++++++---
 drivers/net/ipa/ipa_reg.h  | 30 +++++++++++++++++
 2 files changed, 93 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index f25bcfe51dd4b..d0768452c15cf 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -70,6 +70,14 @@
 #define IPA_FWS_PATH		"ipa_fws.mdt"
 #define IPA_PAS_ID		15
 
+/* Shift of 19.2 MHz timestamp to achieve lower resolution timestamps */
+#define DPL_TIMESTAMP_SHIFT	14	/* ~1.172 kHz, ~853 usec per tick */
+#define TAG_TIMESTAMP_SHIFT	14
+#define NAT_TIMESTAMP_SHIFT	24	/* ~1.144 Hz, ~874 msec per tick */
+
+/* Divider for 19.2 MHz crystal oscillator clock to get common timer clock */
+#define IPA_XO_CLOCK_DIVIDER	192	/* 1 is subtracted where used */
+
 /**
  * ipa_suspend_handler() - Handle the suspend IPA interrupt
  * @ipa:	IPA pointer
@@ -292,6 +300,53 @@ static void ipa_hardware_config_qsb(struct ipa *ipa)
 	iowrite32(val, ipa->reg_virt + IPA_REG_QSB_MAX_READS_OFFSET);
 }
 
+/* IPA uses unified Qtime starting at IPA v4.5, implementing various
+ * timestamps and timers independent of the IPA core clock rate.  The
+ * Qtimer is based on a 56-bit timestamp incremented at each tick of
+ * a 19.2 MHz SoC crystal oscillator (XO clock).
+ *
+ * For IPA timestamps (tag, NAT, data path logging) a lower resolution
+ * timestamp is achieved by shifting the Qtimer timestamp value right
+ * some number of bits to produce the low-order bits of the coarser
+ * granularity timestamp.
+ *
+ * For timers, a common timer clock is derived from the XO clock using
+ * a divider (we use 192, to produce a 100kHz timer clock).  From
+ * this common clock, three "pulse generators" are used to produce
+ * timer ticks at a configurable frequency.  IPA timers (such as
+ * those used for aggregation or head-of-line block handling) now
+ * define their period based on one of these pulse generators.
+ */
+static void ipa_qtime_config(struct ipa *ipa)
+{
+	u32 val;
+
+	/* Timer clock divider must be disabled when we change the rate */
+	iowrite32(0, ipa->reg_virt + IPA_REG_TIMERS_XO_CLK_DIV_CFG_OFFSET);
+
+	/* Set DPL time stamp resolution to use Qtime (instead of 1 msec) */
+	val = u32_encode_bits(DPL_TIMESTAMP_SHIFT, DPL_TIMESTAMP_LSB_FMASK);
+	val |= u32_encode_bits(1, DPL_TIMESTAMP_SEL_FMASK);
+	/* Configure tag and NAT Qtime timestamp resolution as well */
+	val |= u32_encode_bits(TAG_TIMESTAMP_SHIFT, TAG_TIMESTAMP_LSB_FMASK);
+	val |= u32_encode_bits(NAT_TIMESTAMP_SHIFT, NAT_TIMESTAMP_LSB_FMASK);
+	iowrite32(val, ipa->reg_virt + IPA_REG_QTIME_TIMESTAMP_CFG_OFFSET);
+
+	/* Set granularity of pulse generators used for other timers */
+	val = u32_encode_bits(IPA_GRAN_100_US, GRAN_0_FMASK);
+	val |= u32_encode_bits(IPA_GRAN_1_MS, GRAN_1_FMASK);
+	val |= u32_encode_bits(IPA_GRAN_1_MS, GRAN_2_FMASK);
+	iowrite32(val, ipa->reg_virt + IPA_REG_TIMERS_PULSE_GRAN_CFG_OFFSET);
+
+	/* Actual divider is 1 more than value supplied here */
+	val = u32_encode_bits(IPA_XO_CLOCK_DIVIDER - 1, DIV_VALUE_FMASK);
+	iowrite32(val, ipa->reg_virt + IPA_REG_TIMERS_XO_CLK_DIV_CFG_OFFSET);
+
+	/* Divider value is set; re-enable the common timer clock divider */
+	val |= u32_encode_bits(1, DIV_ENABLE_FMASK);
+	iowrite32(val, ipa->reg_virt + IPA_REG_TIMERS_XO_CLK_DIV_CFG_OFFSET);
+}
+
 static void ipa_idle_indication_cfg(struct ipa *ipa,
 				    u32 enter_idle_debounce_thresh,
 				    bool const_non_idle_enable)
@@ -362,10 +417,14 @@ static void ipa_hardware_config(struct ipa *ipa)
 	/* Configure system bus limits */
 	ipa_hardware_config_qsb(ipa);
 
-	/* Configure aggregation granularity */
-	granularity = ipa_aggr_granularity_val(IPA_AGGR_GRANULARITY);
-	val = u32_encode_bits(granularity, AGGR_GRANULARITY_FMASK);
-	iowrite32(val, ipa->reg_virt + IPA_REG_COUNTER_CFG_OFFSET);
+	if (version < IPA_VERSION_4_5) {
+		/* Configure aggregation timer granularity */
+		granularity = ipa_aggr_granularity_val(IPA_AGGR_GRANULARITY);
+		val = u32_encode_bits(granularity, AGGR_GRANULARITY_FMASK);
+		iowrite32(val, ipa->reg_virt + IPA_REG_COUNTER_CFG_OFFSET);
+	} else {
+		ipa_qtime_config(ipa);
+	}
 
 	/* IPA v4.2 does not support hashed tables, so disable them */
 	if (version == IPA_VERSION_4_2) {
diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
index 09dcfa2998f04..e6b0827a244ec 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -223,6 +223,7 @@ static inline u32 ipa_reg_bcr_val(enum ipa_version version)
 /* ipa->available defines the valid bits in the AGGR_FORCE_CLOSE register */
 #define IPA_REG_AGGR_FORCE_CLOSE_OFFSET			0x000001ec
 
+/* The next register is not present for IPA v4.5 */
 #define IPA_REG_COUNTER_CFG_OFFSET			0x000001f0
 #define AGGR_GRANULARITY_FMASK			GENMASK(8, 4)
 
@@ -274,6 +275,35 @@ static inline u32 ipa_reg_idle_indication_cfg_offset(enum ipa_version version)
 #define ENTER_IDLE_DEBOUNCE_THRESH_FMASK	GENMASK(15, 0)
 #define CONST_NON_IDLE_ENABLE_FMASK		GENMASK(16, 16)
 
+/* The next register is present for IPA v4.5 */
+#define IPA_REG_QTIME_TIMESTAMP_CFG_OFFSET		0x0000024c
+#define DPL_TIMESTAMP_LSB_FMASK			GENMASK(4, 0)
+#define DPL_TIMESTAMP_SEL_FMASK			GENMASK(7, 7)
+#define TAG_TIMESTAMP_LSB_FMASK			GENMASK(12, 8)
+#define NAT_TIMESTAMP_LSB_FMASK			GENMASK(20, 16)
+
+/* The next register is present for IPA v4.5 */
+#define IPA_REG_TIMERS_XO_CLK_DIV_CFG_OFFSET		0x00000250
+#define DIV_VALUE_FMASK				GENMASK(8, 0)
+#define DIV_ENABLE_FMASK			GENMASK(31, 31)
+
+/* The next register is present for IPA v4.5 */
+#define IPA_REG_TIMERS_PULSE_GRAN_CFG_OFFSET		0x00000254
+#define GRAN_0_FMASK				GENMASK(2, 0)
+#define GRAN_1_FMASK				GENMASK(5, 3)
+#define GRAN_2_FMASK				GENMASK(8, 6)
+/* Values for GRAN_x fields of TIMERS_PULSE_GRAN_CFG */
+enum ipa_pulse_gran {
+	IPA_GRAN_10_US				= 0x0,
+	IPA_GRAN_20_US				= 0x1,
+	IPA_GRAN_50_US				= 0x2,
+	IPA_GRAN_100_US				= 0x3,
+	IPA_GRAN_1_MS				= 0x4,
+	IPA_GRAN_10_MS				= 0x5,
+	IPA_GRAN_100_MS				= 0x6,
+	IPA_GRAN_655350_US			= 0x7,
+};
+
 /* # IPA source resource groups available based on version */
 static inline u32 ipa_resource_group_src_count(enum ipa_version version)
 {
-- 
2.20.1

