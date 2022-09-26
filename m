Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF1825EB451
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 00:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231464AbiIZWL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 18:11:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231467AbiIZWLE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 18:11:04 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C1171EAE3
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 15:10:04 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id p3so6379558iof.13
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 15:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=5JhJMoohUXFTNfqEtieuEVlfGQUbNZRFFKfqQhX8KdY=;
        b=PJhbnOzuZQKdnfMAHd2PaCYo9DtzlQ7xCjf3eTPi8lGvCrtglI1F7aMy+mVsJpvxJ6
         wR7HQEBWk/TvRfFJ6XRMq+wYGB2PIgdxChbO3n0xNt2MG73aHicJTVCHwlnsglk01CDo
         6mG5eEF+F0mVzH01dPF7RhiX4UwWG7vWFhlbmavvvJhgCElFuqMM08OcD4YyMhN8sutp
         AQhi8Xgn1rZrdsHNcXdBmhfrOaBOA4atBJroOmpiIbOxex/tw054IzoT8SZ7qoccc/e/
         C0QIN7iN5pCdLh3hhA1hIP8BxO3OAaNIVfmQ/CQmOCNia0ffdnBhOGGHTdNwKGtAyriV
         xn6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=5JhJMoohUXFTNfqEtieuEVlfGQUbNZRFFKfqQhX8KdY=;
        b=kU9K0XMNHzGdlaQKkGbc7HQg7B22OasNYJly3+p2GnIhds6WyW3x1Ct6Ov7niyAdUc
         Wc+KpZ60tSj8JsKVvdUY4I4UwDPb/ajfvhiONVV4UZ1eia6JiGvmJ7Nka47McsedsWJb
         aJDs1rYBFXja0pYQL3II9RtoH/HpHTyptf58F12jc8jYouUYscvAaA83GhpLeIMa3xoR
         OiLBxiJRZnP/7GbiVKnq84jUC3MgURAD4m+2zh3FRlBAoGIKSORhpvNxb5R6h8wjEsKk
         CPDbMwOG84vZL3ZIpJfFLNZiPWm1PrNvuJxryx5ClL2L5fNwM5dBqm9SXq6MwFRrFTH0
         /4zA==
X-Gm-Message-State: ACrzQf1MTsMHZYi9nzDRYL+T3ak6bUaP+oI6WlS0xW3PUco2CQOkwWrN
        2t0K7y7WBmEpKAj0TIJcT1ecNw==
X-Google-Smtp-Source: AMsMyM6Dj3LcAFAsFkzlhasnyZeALfOPkd5o0nSx9WxRG75GJ4Fj6wx03bqUKh0G4KYPWD4QVJQ9Zg==
X-Received: by 2002:a05:6638:24d6:b0:35a:632a:f8a2 with SMTP id y22-20020a05663824d600b0035a632af8a2mr13699300jat.262.1664230204005;
        Mon, 26 Sep 2022 15:10:04 -0700 (PDT)
Received: from localhost.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id z20-20020a027a54000000b003567503cf92sm7631600jad.82.2022.09.26.15.10.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 15:10:02 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 11/15] net: ipa: define even more IPA register fields
Date:   Mon, 26 Sep 2022 17:09:27 -0500
Message-Id: <20220926220931.3261749-12-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220926220931.3261749-1-elder@linaro.org>
References: <20220926220931.3261749-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define the fields for the FLAVOR_0, IDLE_INDICATION_CFG,
QTIME_TIMESTAMP_CFG, TIMERS_XO_CLK_DIV_CFG and TIMERS_PULSE_GRAN_CFG
IPA registers for all supported IPA versions.

Create enumerated types to identify fields for these IPA registers.
Use IPA_REG_FIELDS() to specify the field mask values defined for
these registers, for each supported version of IPA.

Use ipa_reg_bit() and ipa_reg_encode() to build up the values to be
written to these registers.  Use ipa_reg_decode() to extract field
values from the FLAVOR_0 register.

Remove the definition of the no-longer-used *_FMASK symbols.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c       |  6 ++--
 drivers/net/ipa/ipa_main.c           | 24 ++++++-------
 drivers/net/ipa/ipa_reg.h            | 43 +++++++++++++++---------
 drivers/net/ipa/reg/ipa_reg-v3.5.1.c | 21 ++++++++++--
 drivers/net/ipa/reg/ipa_reg-v4.11.c  | 50 +++++++++++++++++++++++++---
 drivers/net/ipa/reg/ipa_reg-v4.2.c   | 21 ++++++++++--
 drivers/net/ipa/reg/ipa_reg-v4.5.c   | 49 ++++++++++++++++++++++++---
 drivers/net/ipa/reg/ipa_reg-v4.9.c   | 49 ++++++++++++++++++++++++---
 8 files changed, 213 insertions(+), 50 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 0409f19166b30..24431d8f626b3 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -1854,8 +1854,8 @@ int ipa_endpoint_config(struct ipa *ipa)
 	val = ioread32(ipa->reg_virt + ipa_reg_offset(reg));
 
 	/* Our RX is an IPA producer */
-	rx_base = u32_get_bits(val, IPA_PROD_LOWEST_FMASK);
-	max = rx_base + u32_get_bits(val, IPA_MAX_PROD_PIPES_FMASK);
+	rx_base = ipa_reg_decode(reg, PROD_LOWEST, val);
+	max = rx_base + ipa_reg_decode(reg, MAX_PROD_PIPES, val);
 	if (max > IPA_ENDPOINT_MAX) {
 		dev_err(dev, "too many endpoints (%u > %u)\n",
 			max, IPA_ENDPOINT_MAX);
@@ -1864,7 +1864,7 @@ int ipa_endpoint_config(struct ipa *ipa)
 	rx_mask = GENMASK(max - 1, rx_base);
 
 	/* Our TX is an IPA consumer */
-	max = u32_get_bits(val, IPA_MAX_CONS_PIPES_FMASK);
+	max = ipa_reg_decode(reg, MAX_CONS_PIPES, val);
 	tx_mask = GENMASK(max - 1, 0);
 
 	ipa->available = rx_mask | tx_mask;
diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 23ab566b71dde..a0f6212aa3c35 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -361,31 +361,31 @@ static void ipa_qtime_config(struct ipa *ipa)
 
 	reg = ipa_reg(ipa, QTIME_TIMESTAMP_CFG);
 	/* Set DPL time stamp resolution to use Qtime (instead of 1 msec) */
-	val = u32_encode_bits(DPL_TIMESTAMP_SHIFT, DPL_TIMESTAMP_LSB_FMASK);
-	val |= u32_encode_bits(1, DPL_TIMESTAMP_SEL_FMASK);
+	val = ipa_reg_encode(reg, DPL_TIMESTAMP_LSB, DPL_TIMESTAMP_SHIFT);
+	val |= ipa_reg_bit(reg, DPL_TIMESTAMP_SEL);
 	/* Configure tag and NAT Qtime timestamp resolution as well */
-	val |= u32_encode_bits(TAG_TIMESTAMP_SHIFT, TAG_TIMESTAMP_LSB_FMASK);
-	val |= u32_encode_bits(NAT_TIMESTAMP_SHIFT, NAT_TIMESTAMP_LSB_FMASK);
+	val = ipa_reg_encode(reg, TAG_TIMESTAMP_LSB, TAG_TIMESTAMP_SHIFT);
+	val = ipa_reg_encode(reg, NAT_TIMESTAMP_LSB, NAT_TIMESTAMP_SHIFT);
 
 	iowrite32(val, ipa->reg_virt + ipa_reg_offset(reg));
 
 	/* Set granularity of pulse generators used for other timers */
 	reg = ipa_reg(ipa, TIMERS_PULSE_GRAN_CFG);
-	val = u32_encode_bits(IPA_GRAN_100_US, GRAN_0_FMASK);
-	val |= u32_encode_bits(IPA_GRAN_1_MS, GRAN_1_FMASK);
-	val |= u32_encode_bits(IPA_GRAN_1_MS, GRAN_2_FMASK);
+	val = ipa_reg_encode(reg, PULSE_GRAN_0, IPA_GRAN_100_US);
+	val |= ipa_reg_encode(reg, PULSE_GRAN_1, IPA_GRAN_1_MS);
+	val |= ipa_reg_encode(reg, PULSE_GRAN_2, IPA_GRAN_1_MS);
 
 	iowrite32(val, ipa->reg_virt + ipa_reg_offset(reg));
 
 	/* Actual divider is 1 more than value supplied here */
 	reg = ipa_reg(ipa, TIMERS_XO_CLK_DIV_CFG);
 	offset = ipa_reg_offset(reg);
-	val = u32_encode_bits(IPA_XO_CLOCK_DIVIDER - 1, DIV_VALUE_FMASK);
+	val = ipa_reg_encode(reg, DIV_VALUE, IPA_XO_CLOCK_DIVIDER - 1);
 
 	iowrite32(val, ipa->reg_virt + offset);
 
 	/* Divider value is set; re-enable the common timer clock divider */
-	val |= u32_encode_bits(1, DIV_ENABLE_FMASK);
+	val |= ipa_reg_bit(reg, DIV_ENABLE);
 
 	iowrite32(val, ipa->reg_virt + offset);
 }
@@ -435,10 +435,10 @@ static void ipa_idle_indication_cfg(struct ipa *ipa,
 	u32 val;
 
 	reg = ipa_reg(ipa, IDLE_INDICATION_CFG);
-	val = u32_encode_bits(enter_idle_debounce_thresh,
-			      ENTER_IDLE_DEBOUNCE_THRESH_FMASK);
+	val = ipa_reg_encode(reg, ENTER_IDLE_DEBOUNCE_THRESH,
+			     enter_idle_debounce_thresh);
 	if (const_non_idle_enable)
-		val |= CONST_NON_IDLE_ENABLE_FMASK;
+		val |= ipa_reg_bit(reg, CONST_NON_IDLE_ENABLE);
 
 	iowrite32(val, ipa->reg_virt + ipa_reg_offset(reg));
 }
diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
index 841a693a2c387..bdd085a1f31c9 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -316,30 +316,41 @@ enum ipa_reg_ipa_tx_cfg_field_id {
 };
 
 /* FLAVOR_0 register */
-#define IPA_MAX_PIPES_FMASK			GENMASK(3, 0)
-#define IPA_MAX_CONS_PIPES_FMASK		GENMASK(12, 8)
-#define IPA_MAX_PROD_PIPES_FMASK		GENMASK(20, 16)
-#define IPA_PROD_LOWEST_FMASK			GENMASK(27, 24)
+enum ipa_reg_flavor_0_field_id {
+	MAX_PIPES,
+	MAX_CONS_PIPES,
+	MAX_PROD_PIPES,
+	PROD_LOWEST,
+};
 
 /* IDLE_INDICATION_CFG register */
-#define ENTER_IDLE_DEBOUNCE_THRESH_FMASK	GENMASK(15, 0)
-#define CONST_NON_IDLE_ENABLE_FMASK		GENMASK(16, 16)
+enum ipa_reg_idle_indication_cfg_field_id {
+	ENTER_IDLE_DEBOUNCE_THRESH,
+	CONST_NON_IDLE_ENABLE,
+};
 
 /* QTIME_TIMESTAMP_CFG register */
-#define DPL_TIMESTAMP_LSB_FMASK			GENMASK(4, 0)
-#define DPL_TIMESTAMP_SEL_FMASK			GENMASK(7, 7)
-#define TAG_TIMESTAMP_LSB_FMASK			GENMASK(12, 8)
-#define NAT_TIMESTAMP_LSB_FMASK			GENMASK(20, 16)
+enum ipa_reg_qtime_timestamp_cfg_field_id {
+	DPL_TIMESTAMP_LSB,
+	DPL_TIMESTAMP_SEL,
+	TAG_TIMESTAMP_LSB,
+	NAT_TIMESTAMP_LSB,
+};
 
 /* TIMERS_XO_CLK_DIV_CFG register */
-#define DIV_VALUE_FMASK				GENMASK(8, 0)
-#define DIV_ENABLE_FMASK			GENMASK(31, 31)
+enum ipa_reg_timers_xo_clk_div_cfg_field_id {
+	DIV_VALUE,
+	DIV_ENABLE,
+};
 
 /* TIMERS_PULSE_GRAN_CFG register */
-#define GRAN_0_FMASK				GENMASK(2, 0)
-#define GRAN_1_FMASK				GENMASK(5, 3)
-#define GRAN_2_FMASK				GENMASK(8, 6)
-/* Values for GRAN_x fields of TIMERS_PULSE_GRAN_CFG */
+enum ipa_reg_timers_pulse_gran_cfg_field_id {
+	PULSE_GRAN_0,
+	PULSE_GRAN_1,
+	PULSE_GRAN_2,
+};
+
+/* Values for IPA_GRAN_x fields of TIMERS_PULSE_GRAN_CFG */
 enum ipa_pulse_gran {
 	IPA_GRAN_10_US				= 0x0,
 	IPA_GRAN_20_US				= 0x1,
diff --git a/drivers/net/ipa/reg/ipa_reg-v3.5.1.c b/drivers/net/ipa/reg/ipa_reg-v3.5.1.c
index 8b7c0e7c26dbf..ce63f4a6cc9d8 100644
--- a/drivers/net/ipa/reg/ipa_reg-v3.5.1.c
+++ b/drivers/net/ipa/reg/ipa_reg-v3.5.1.c
@@ -140,9 +140,26 @@ static const u32 ipa_reg_ipa_tx_cfg_fmask[] = {
 
 IPA_REG_FIELDS(IPA_TX_CFG, ipa_tx_cfg, 0x000001fc);
 
-IPA_REG(FLAVOR_0, flavor_0, 0x00000210);
+static const u32 ipa_reg_flavor_0_fmask[] = {
+	[MAX_PIPES]					= GENMASK(3, 0),
+						/* Bits 4-7 reserved */
+	[MAX_CONS_PIPES]				= GENMASK(12, 8),
+						/* Bits 13-15 reserved */
+	[MAX_PROD_PIPES]				= GENMASK(20, 16),
+						/* Bits 21-23 reserved */
+	[PROD_LOWEST]					= GENMASK(27, 24),
+						/* Bits 28-31 reserved */
+};
 
-IPA_REG(IDLE_INDICATION_CFG, idle_indication_cfg, 0x00000220);
+IPA_REG_FIELDS(FLAVOR_0, flavor_0, 0x00000210);
+
+static const u32 ipa_reg_idle_indication_cfg_fmask[] = {
+	[ENTER_IDLE_DEBOUNCE_THRESH]			= GENMASK(15, 0),
+	[CONST_NON_IDLE_ENABLE]				= BIT(16),
+						/* Bits 17-31 reserved */
+};
+
+IPA_REG_FIELDS(IDLE_INDICATION_CFG, idle_indication_cfg, 0x00000220);
 
 IPA_REG_STRIDE(SRC_RSRC_GRP_01_RSRC_TYPE, src_rsrc_grp_01_rsrc_type,
 	       0x00000400, 0x0020);
diff --git a/drivers/net/ipa/reg/ipa_reg-v4.11.c b/drivers/net/ipa/reg/ipa_reg-v4.11.c
index d9b1113035577..77f4b14650ad4 100644
--- a/drivers/net/ipa/reg/ipa_reg-v4.11.c
+++ b/drivers/net/ipa/reg/ipa_reg-v4.11.c
@@ -168,15 +168,55 @@ static const u32 ipa_reg_ipa_tx_cfg_fmask[] = {
 
 IPA_REG_FIELDS(IPA_TX_CFG, ipa_tx_cfg, 0x000001fc);
 
-IPA_REG(FLAVOR_0, flavor_0, 0x00000210);
+static const u32 ipa_reg_flavor_0_fmask[] = {
+	[MAX_PIPES]					= GENMASK(4, 0),
+						/* Bits 5-7 reserved */
+	[MAX_CONS_PIPES]				= GENMASK(12, 8),
+						/* Bits 13-15 reserved */
+	[MAX_PROD_PIPES]				= GENMASK(20, 16),
+						/* Bits 21-23 reserved */
+	[PROD_LOWEST]					= GENMASK(27, 24),
+						/* Bits 28-31 reserved */
+};
 
-IPA_REG(IDLE_INDICATION_CFG, idle_indication_cfg, 0x00000240);
+IPA_REG_FIELDS(FLAVOR_0, flavor_0, 0x00000210);
 
-IPA_REG(QTIME_TIMESTAMP_CFG, qtime_timestamp_cfg, 0x0000024c);
+static const u32 ipa_reg_idle_indication_cfg_fmask[] = {
+	[ENTER_IDLE_DEBOUNCE_THRESH]			= GENMASK(15, 0),
+	[CONST_NON_IDLE_ENABLE]				= BIT(16),
+						/* Bits 17-31 reserved */
+};
 
-IPA_REG(TIMERS_XO_CLK_DIV_CFG, timers_xo_clk_div_cfg, 0x00000250);
+IPA_REG_FIELDS(IDLE_INDICATION_CFG, idle_indication_cfg, 0x00000240);
 
-IPA_REG(TIMERS_PULSE_GRAN_CFG, timers_pulse_gran_cfg, 0x00000254);
+static const u32 ipa_reg_qtime_timestamp_cfg_fmask[] = {
+	[DPL_TIMESTAMP_LSB]				= GENMASK(4, 0),
+						/* Bits 5-6 reserved */
+	[DPL_TIMESTAMP_SEL]				= BIT(7),
+	[TAG_TIMESTAMP_LSB]				= GENMASK(12, 8),
+						/* Bits 13-15 reserved */
+	[NAT_TIMESTAMP_LSB]				= GENMASK(20, 16),
+						/* Bits 21-31 reserved */
+};
+
+IPA_REG_FIELDS(QTIME_TIMESTAMP_CFG, qtime_timestamp_cfg, 0x0000024c);
+
+static const u32 ipa_reg_timers_xo_clk_div_cfg_fmask[] = {
+	[DIV_VALUE]					= GENMASK(8, 0),
+						/* Bits 9-30 reserved */
+	[DIV_ENABLE]					= BIT(31),
+};
+
+IPA_REG_FIELDS(TIMERS_XO_CLK_DIV_CFG, timers_xo_clk_div_cfg, 0x00000250);
+
+static const u32 ipa_reg_timers_pulse_gran_cfg_fmask[] = {
+	[PULSE_GRAN_0]					= GENMASK(2, 0),
+	[PULSE_GRAN_1]					= GENMASK(5, 3),
+	[PULSE_GRAN_2]					= GENMASK(8, 6),
+						/* Bits 9-31 reserved */
+};
+
+IPA_REG_FIELDS(TIMERS_PULSE_GRAN_CFG, timers_pulse_gran_cfg, 0x00000254);
 
 IPA_REG_STRIDE(SRC_RSRC_GRP_01_RSRC_TYPE, src_rsrc_grp_01_rsrc_type,
 	       0x00000400, 0x0020);
diff --git a/drivers/net/ipa/reg/ipa_reg-v4.2.c b/drivers/net/ipa/reg/ipa_reg-v4.2.c
index ddd8bac2c3e0d..a9aca0ecff8ff 100644
--- a/drivers/net/ipa/reg/ipa_reg-v4.2.c
+++ b/drivers/net/ipa/reg/ipa_reg-v4.2.c
@@ -171,9 +171,26 @@ static const u32 ipa_reg_ipa_tx_cfg_fmask[] = {
 
 IPA_REG_FIELDS(IPA_TX_CFG, ipa_tx_cfg, 0x000001fc);
 
-IPA_REG(FLAVOR_0, flavor_0, 0x00000210);
+static const u32 ipa_reg_flavor_0_fmask[] = {
+	[MAX_PIPES]					= GENMASK(3, 0),
+						/* Bits 4-7 reserved */
+	[MAX_CONS_PIPES]				= GENMASK(12, 8),
+						/* Bits 13-15 reserved */
+	[MAX_PROD_PIPES]				= GENMASK(20, 16),
+						/* Bits 21-23 reserved */
+	[PROD_LOWEST]					= GENMASK(27, 24),
+						/* Bits 28-31 reserved */
+};
 
-IPA_REG(IDLE_INDICATION_CFG, idle_indication_cfg, 0x00000240);
+IPA_REG_FIELDS(FLAVOR_0, flavor_0, 0x00000210);
+
+static const u32 ipa_reg_idle_indication_cfg_fmask[] = {
+	[ENTER_IDLE_DEBOUNCE_THRESH]			= GENMASK(15, 0),
+	[CONST_NON_IDLE_ENABLE]				= BIT(16),
+						/* Bits 17-31 reserved */
+};
+
+IPA_REG_FIELDS(IDLE_INDICATION_CFG, idle_indication_cfg, 0x00000240);
 
 IPA_REG_STRIDE(SRC_RSRC_GRP_01_RSRC_TYPE, src_rsrc_grp_01_rsrc_type,
 	       0x00000400, 0x0020);
diff --git a/drivers/net/ipa/reg/ipa_reg-v4.5.c b/drivers/net/ipa/reg/ipa_reg-v4.5.c
index a08e0bb6b5167..9a93725b8efab 100644
--- a/drivers/net/ipa/reg/ipa_reg-v4.5.c
+++ b/drivers/net/ipa/reg/ipa_reg-v4.5.c
@@ -161,15 +161,54 @@ static const u32 ipa_reg_ipa_tx_cfg_fmask[] = {
 
 IPA_REG_FIELDS(IPA_TX_CFG, ipa_tx_cfg, 0x000001fc);
 
-IPA_REG(FLAVOR_0, flavor_0, 0x00000210);
+static const u32 ipa_reg_flavor_0_fmask[] = {
+	[MAX_PIPES]					= GENMASK(3, 0),
+						/* Bits 4-7 reserved */
+	[MAX_CONS_PIPES]				= GENMASK(12, 8),
+						/* Bits 13-15 reserved */
+	[MAX_PROD_PIPES]				= GENMASK(20, 16),
+						/* Bits 21-23 reserved */
+	[PROD_LOWEST]					= GENMASK(27, 24),
+						/* Bits 28-31 reserved */
+};
 
-IPA_REG(IDLE_INDICATION_CFG, idle_indication_cfg, 0x00000240);
+IPA_REG_FIELDS(FLAVOR_0, flavor_0, 0x00000210);
 
-IPA_REG(QTIME_TIMESTAMP_CFG, qtime_timestamp_cfg, 0x0000024c);
+static const u32 ipa_reg_idle_indication_cfg_fmask[] = {
+	[ENTER_IDLE_DEBOUNCE_THRESH]			= GENMASK(15, 0),
+	[CONST_NON_IDLE_ENABLE]				= BIT(16),
+						/* Bits 17-31 reserved */
+};
 
-IPA_REG(TIMERS_XO_CLK_DIV_CFG, timers_xo_clk_div_cfg, 0x00000250);
+IPA_REG_FIELDS(IDLE_INDICATION_CFG, idle_indication_cfg, 0x00000240);
 
-IPA_REG(TIMERS_PULSE_GRAN_CFG, timers_pulse_gran_cfg, 0x00000254);
+static const u32 ipa_reg_qtime_timestamp_cfg_fmask[] = {
+	[DPL_TIMESTAMP_LSB]				= GENMASK(4, 0),
+						/* Bits 5-6 reserved */
+	[DPL_TIMESTAMP_SEL]				= BIT(7),
+	[TAG_TIMESTAMP_LSB]				= GENMASK(12, 8),
+						/* Bits 13-15 reserved */
+	[NAT_TIMESTAMP_LSB]				= GENMASK(20, 16),
+						/* Bits 21-31 reserved */
+};
+
+IPA_REG_FIELDS(QTIME_TIMESTAMP_CFG, qtime_timestamp_cfg, 0x0000024c);
+
+static const u32 ipa_reg_timers_xo_clk_div_cfg_fmask[] = {
+	[DIV_VALUE]					= GENMASK(8, 0),
+						/* Bits 9-30 reserved */
+	[DIV_ENABLE]					= BIT(31),
+};
+
+IPA_REG_FIELDS(TIMERS_XO_CLK_DIV_CFG, timers_xo_clk_div_cfg, 0x00000250);
+
+static const u32 ipa_reg_timers_pulse_gran_cfg_fmask[] = {
+	[PULSE_GRAN_0]					= GENMASK(2, 0),
+	[PULSE_GRAN_1]					= GENMASK(5, 3),
+	[PULSE_GRAN_2]					= GENMASK(8, 6),
+};
+
+IPA_REG_FIELDS(TIMERS_PULSE_GRAN_CFG, timers_pulse_gran_cfg, 0x00000254);
 
 IPA_REG_STRIDE(SRC_RSRC_GRP_01_RSRC_TYPE, src_rsrc_grp_01_rsrc_type,
 	       0x00000400, 0x0020);
diff --git a/drivers/net/ipa/reg/ipa_reg-v4.9.c b/drivers/net/ipa/reg/ipa_reg-v4.9.c
index 1561e9716f86b..4e46466ffb47e 100644
--- a/drivers/net/ipa/reg/ipa_reg-v4.9.c
+++ b/drivers/net/ipa/reg/ipa_reg-v4.9.c
@@ -167,15 +167,54 @@ static const u32 ipa_reg_ipa_tx_cfg_fmask[] = {
 
 IPA_REG_FIELDS(IPA_TX_CFG, ipa_tx_cfg, 0x000001fc);
 
-IPA_REG(FLAVOR_0, flavor_0, 0x00000210);
+static const u32 ipa_reg_flavor_0_fmask[] = {
+	[MAX_PIPES]					= GENMASK(3, 0),
+						/* Bits 4-7 reserved */
+	[MAX_CONS_PIPES]				= GENMASK(12, 8),
+						/* Bits 13-15 reserved */
+	[MAX_PROD_PIPES]				= GENMASK(20, 16),
+						/* Bits 21-23 reserved */
+	[PROD_LOWEST]					= GENMASK(27, 24),
+						/* Bits 28-31 reserved */
+};
 
-IPA_REG(IDLE_INDICATION_CFG, idle_indication_cfg, 0x00000240);
+IPA_REG_FIELDS(FLAVOR_0, flavor_0, 0x00000210);
 
-IPA_REG(QTIME_TIMESTAMP_CFG, qtime_timestamp_cfg, 0x0000024c);
+static const u32 ipa_reg_idle_indication_cfg_fmask[] = {
+	[ENTER_IDLE_DEBOUNCE_THRESH]			= GENMASK(15, 0),
+	[CONST_NON_IDLE_ENABLE]				= BIT(16),
+						/* Bits 17-31 reserved */
+};
 
-IPA_REG(TIMERS_XO_CLK_DIV_CFG, timers_xo_clk_div_cfg, 0x00000250);
+IPA_REG_FIELDS(IDLE_INDICATION_CFG, idle_indication_cfg, 0x00000240);
 
-IPA_REG(TIMERS_PULSE_GRAN_CFG, timers_pulse_gran_cfg, 0x00000254);
+static const u32 ipa_reg_qtime_timestamp_cfg_fmask[] = {
+	[DPL_TIMESTAMP_LSB]				= GENMASK(4, 0),
+						/* Bits 5-6 reserved */
+	[DPL_TIMESTAMP_SEL]				= BIT(7),
+	[TAG_TIMESTAMP_LSB]				= GENMASK(12, 8),
+						/* Bits 13-15 reserved */
+	[NAT_TIMESTAMP_LSB]				= GENMASK(20, 16),
+						/* Bits 21-31 reserved */
+};
+
+IPA_REG_FIELDS(QTIME_TIMESTAMP_CFG, qtime_timestamp_cfg, 0x0000024c);
+
+static const u32 ipa_reg_timers_xo_clk_div_cfg_fmask[] = {
+	[DIV_VALUE]					= GENMASK(8, 0),
+						/* Bits 9-30 reserved */
+	[DIV_ENABLE]					= BIT(31),
+};
+
+IPA_REG_FIELDS(TIMERS_XO_CLK_DIV_CFG, timers_xo_clk_div_cfg, 0x00000250);
+
+static const u32 ipa_reg_timers_pulse_gran_cfg_fmask[] = {
+	[PULSE_GRAN_0]					= GENMASK(2, 0),
+	[PULSE_GRAN_1]					= GENMASK(5, 3),
+	[PULSE_GRAN_2]					= GENMASK(8, 6),
+};
+
+IPA_REG_FIELDS(TIMERS_PULSE_GRAN_CFG, timers_pulse_gran_cfg, 0x00000254);
 
 IPA_REG_STRIDE(SRC_RSRC_GRP_01_RSRC_TYPE, src_rsrc_grp_01_rsrc_type,
 	       0x00000400, 0x0020);
-- 
2.34.1

