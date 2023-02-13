Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8FA4694C70
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 17:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbjBMQWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 11:22:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbjBMQWi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 11:22:38 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56D2FEC65
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 08:22:35 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id v6so444381ilc.10
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 08:22:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/B0LjTJ046KlmSpa6/nQV8ODH85KJkHDvhfz4uqO0hQ=;
        b=lpGhfnhO7pHI4DZfI0A7+vRsRdOuvGrPJg3Kg5IgXSTEqnwG8SxE3Z3rw/Z4uT/jiN
         2llVpbc/6LjG8+9xj2yV7V8HqJ60tF+5dvE5L8FpMRLctNzR3HelXu7z9hqpzCZ/P78A
         XU6x9aLKfe6hQ/6SS0Rbk/iq0y3wgxT41Xmy1PUxxn0kggLS7htTgyVm4v3HBCzM2x3R
         EL0DZccpQmf+i6VzGhczGqNGTVThYgt+HuZfbir0Ekvitu1ndcQFymfkkBvfbxnEP/d7
         wZ1f0H5/i0hzHcjgUMZWYsgWOaF1C+yPN+iOdekc3k5HQnez5jcryiVE9d2oc0B+8Dpr
         Iw4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/B0LjTJ046KlmSpa6/nQV8ODH85KJkHDvhfz4uqO0hQ=;
        b=PUDv0a+VMF1YhrSA3RUQAcDJwobFl+owmqlcjq3+SGLGWJu1CUQZBUCrVlYzJdtgqm
         TCxExf2OKoGdRlgm0Xag6ZJ5seFyyKisSm38BwMCwZpnaygyJvWdoG/6ctwHKFYqZo5E
         tVa86JBCJUAKzez4tCEpDDXhTGZQDyTZT702/O828f3ZzKPvoEvAkIRaym95PaP11YCr
         rq9fz9eIKNpnqRN5jkKJaT7jJqBBrawRwuZf7nDgvJ40BapPRmLxikhNdYtZ6bKr5ETF
         W3xFNZNn0TeZc4qnfygNemqpDoUM+x5ziye5deQ6XL6c22uClsrCyrVjxzClQHHo5Pi4
         TThQ==
X-Gm-Message-State: AO0yUKUafcyOmvctH/59k/Gmjb9YoSuvwcnRlZ+/Sv4JPP6Kl2U2Ez0v
        dLhOO6bryAb58VFyrqBT3pNB8A==
X-Google-Smtp-Source: AK7set9JVEfnrMnZNokPI0PW88A0lFFvCY7O8A9dD3eiItfR6DlrAkGlcfwYgPzAVoMSOVj4EbeqTg==
X-Received: by 2002:a05:6e02:214e:b0:314:fa6:323c with SMTP id d14-20020a056e02214e00b003140fa6323cmr16393727ilv.12.1676305354950;
        Mon, 13 Feb 2023 08:22:34 -0800 (PST)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id x17-20020a92dc51000000b00313cbba0455sm1457831ilq.8.2023.02.13.08.22.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 08:22:34 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/6] net: ipa: define GSI CH_C_QOS register fields
Date:   Mon, 13 Feb 2023 10:22:25 -0600
Message-Id: <20230213162229.604438-3-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230213162229.604438-1-elder@linaro.org>
References: <20230213162229.604438-1-elder@linaro.org>
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

Define the fields within the CH_C_QOS GSI register using an array of
field masks in that register's reg structure.  Use the reg functions
for encoding values in those fields.

One field in the register is present for IPA v4.0-4.2 only, two
others are present starting at IPA v4.5, and one more is there
starting at IPA v4.9.

Drop the "GSI_" prefix in symbols defined in the gsi_prefetch_mode
enumerated type, and define their values using decimal rather than
hexidecimal values.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c                | 13 ++++++-------
 drivers/net/ipa/gsi_reg.h            | 27 +++++++++++++--------------
 drivers/net/ipa/reg/gsi_reg-v3.1.c   | 10 +++++++++-
 drivers/net/ipa/reg/gsi_reg-v3.5.1.c | 10 +++++++++-
 drivers/net/ipa/reg/gsi_reg-v4.0.c   | 11 ++++++++++-
 drivers/net/ipa/reg/gsi_reg-v4.5.c   | 13 ++++++++++++-
 drivers/net/ipa/reg/gsi_reg-v4.9.c   | 14 +++++++++++++-
 7 files changed, 72 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index bdc1f8e8e4282..cbf4b2d843acb 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -889,14 +889,14 @@ static void gsi_channel_program(struct gsi_channel *channel, bool doorbell)
 
 	/* Command channel gets low weighted round-robin priority */
 	if (channel->command)
-		wrr_weight = field_max(WRR_WEIGHT_FMASK);
-	val = u32_encode_bits(wrr_weight, WRR_WEIGHT_FMASK);
+		wrr_weight = reg_field_max(reg, WRR_WEIGHT);
+	val = reg_encode(reg, WRR_WEIGHT, wrr_weight);
 
 	/* Max prefetch is 1 segment (do not set MAX_PREFETCH_FMASK) */
 
 	/* No need to use the doorbell engine starting at IPA v4.0 */
 	if (gsi->version < IPA_VERSION_4_0 && doorbell)
-		val |= USE_DB_ENG_FMASK;
+		val |= reg_bit(reg, USE_DB_ENG);
 
 	/* v4.0 introduces an escape buffer for prefetch.  We use it
 	 * on all but the AP command channel.
@@ -904,14 +904,13 @@ static void gsi_channel_program(struct gsi_channel *channel, bool doorbell)
 	if (gsi->version >= IPA_VERSION_4_0 && !channel->command) {
 		/* If not otherwise set, prefetch buffers are used */
 		if (gsi->version < IPA_VERSION_4_5)
-			val |= USE_ESCAPE_BUF_ONLY_FMASK;
+			val |= reg_bit(reg, USE_ESCAPE_BUF_ONLY);
 		else
-			val |= u32_encode_bits(GSI_ESCAPE_BUF_ONLY,
-					       PREFETCH_MODE_FMASK);
+			val |= reg_encode(reg, PREFETCH_MODE, ESCAPE_BUF_ONLY);
 	}
 	/* All channels set DB_IN_BYTES */
 	if (gsi->version >= IPA_VERSION_4_9)
-		val |= DB_IN_BYTES;
+		val |= reg_bit(reg, DB_IN_BYTES);
 
 	iowrite32(val, gsi->virt + reg_n_offset(reg, channel_id));
 
diff --git a/drivers/net/ipa/gsi_reg.h b/drivers/net/ipa/gsi_reg.h
index 23a0d6a98600c..f625afdfd6d9f 100644
--- a/drivers/net/ipa/gsi_reg.h
+++ b/drivers/net/ipa/gsi_reg.h
@@ -121,23 +121,22 @@ enum gsi_channel_type {
 };
 
 /* CH_C_QOS register */
-#define WRR_WEIGHT_FMASK		GENMASK(3, 0)
-#define MAX_PREFETCH_FMASK		GENMASK(8, 8)
-#define USE_DB_ENG_FMASK		GENMASK(9, 9)
-/* The next field is only present for IPA v4.0, v4.1, and v4.2 */
-#define USE_ESCAPE_BUF_ONLY_FMASK	GENMASK(10, 10)
-/* The next two fields are present for IPA v4.5 and above */
-#define PREFETCH_MODE_FMASK		GENMASK(13, 10)
-#define EMPTY_LVL_THRSHOLD_FMASK	GENMASK(23, 16)
-/* The next field is present for IPA v4.9 and above */
-#define DB_IN_BYTES			GENMASK(24, 24)
+enum gsi_reg_ch_c_qos_field_id {
+	WRR_WEIGHT,
+	MAX_PREFETCH,
+	USE_DB_ENG,
+	USE_ESCAPE_BUF_ONLY,				/* IPA v4.0-4.2 */
+	PREFETCH_MODE,					/* IPA v4.5+ */
+	EMPTY_LVL_THRSHOLD,				/* IPA v4.5+ */
+	DB_IN_BYTES,					/* IPA v4.9+ */
+};
 
 /** enum gsi_prefetch_mode - PREFETCH_MODE field in CH_C_QOS */
 enum gsi_prefetch_mode {
-	GSI_USE_PREFETCH_BUFS			= 0x0,
-	GSI_ESCAPE_BUF_ONLY			= 0x1,
-	GSI_SMART_PREFETCH			= 0x2,
-	GSI_FREE_PREFETCH			= 0x3,
+	USE_PREFETCH_BUFS			= 0,
+	ESCAPE_BUF_ONLY				= 1,
+	SMART_PREFETCH				= 2,
+	FREE_PREFETCH				= 3,
 };
 
 /* EV_CH_E_CNTXT_0 register */
diff --git a/drivers/net/ipa/reg/gsi_reg-v3.1.c b/drivers/net/ipa/reg/gsi_reg-v3.1.c
index 6bed9d547f9af..56cf487ae4fc6 100644
--- a/drivers/net/ipa/reg/gsi_reg-v3.1.c
+++ b/drivers/net/ipa/reg/gsi_reg-v3.1.c
@@ -26,7 +26,15 @@ REG_STRIDE(CH_C_CNTXT_2, ch_c_cntxt_2, 0x0001c008 + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(CH_C_CNTXT_3, ch_c_cntxt_3, 0x0001c00c + 0x4000 * GSI_EE_AP, 0x80);
 
-REG_STRIDE(CH_C_QOS, ch_c_qos, 0x0001c05c + 0x4000 * GSI_EE_AP, 0x80);
+static const u32 reg_ch_c_qos_fmask[] = {
+	[WRR_WEIGHT]					= GENMASK(3, 0),
+						/* Bits 4-7 reserved */
+	[MAX_PREFETCH]					= BIT(8),
+	[USE_DB_ENG]					= BIT(9),
+						/* Bits 10-31 reserved */
+};
+
+REG_STRIDE_FIELDS(CH_C_QOS, ch_c_qos, 0x0001c05c + 0x4000 * GSI_EE_AP, 0x80);
 
 REG(ERROR_LOG, error_log, 0x0001f200 + 0x4000 * GSI_EE_AP);
 
diff --git a/drivers/net/ipa/reg/gsi_reg-v3.5.1.c b/drivers/net/ipa/reg/gsi_reg-v3.5.1.c
index a6d7524c36f9f..866bae3ff530b 100644
--- a/drivers/net/ipa/reg/gsi_reg-v3.5.1.c
+++ b/drivers/net/ipa/reg/gsi_reg-v3.5.1.c
@@ -26,7 +26,15 @@ REG_STRIDE(CH_C_CNTXT_2, ch_c_cntxt_2, 0x0001c008 + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(CH_C_CNTXT_3, ch_c_cntxt_3, 0x0001c00c + 0x4000 * GSI_EE_AP, 0x80);
 
-REG_STRIDE(CH_C_QOS, ch_c_qos, 0x0001c05c + 0x4000 * GSI_EE_AP, 0x80);
+static const u32 reg_ch_c_qos_fmask[] = {
+	[WRR_WEIGHT]					= GENMASK(3, 0),
+						/* Bits 4-7 reserved */
+	[MAX_PREFETCH]					= BIT(8),
+	[USE_DB_ENG]					= BIT(9),
+						/* Bits 10-31 reserved */
+};
+
+REG_STRIDE_FIELDS(CH_C_QOS, ch_c_qos, 0x0001c05c + 0x4000 * GSI_EE_AP, 0x80);
 
 REG(ERROR_LOG, error_log, 0x0001f200 + 0x4000 * GSI_EE_AP);
 
diff --git a/drivers/net/ipa/reg/gsi_reg-v4.0.c b/drivers/net/ipa/reg/gsi_reg-v4.0.c
index 6c066a2571705..060876e4aab41 100644
--- a/drivers/net/ipa/reg/gsi_reg-v4.0.c
+++ b/drivers/net/ipa/reg/gsi_reg-v4.0.c
@@ -26,7 +26,16 @@ REG_STRIDE(CH_C_CNTXT_2, ch_c_cntxt_2, 0x0001c008 + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(CH_C_CNTXT_3, ch_c_cntxt_3, 0x0001c00c + 0x4000 * GSI_EE_AP, 0x80);
 
-REG_STRIDE(CH_C_QOS, ch_c_qos, 0x0001c05c + 0x4000 * GSI_EE_AP, 0x80);
+static const u32 reg_ch_c_qos_fmask[] = {
+	[WRR_WEIGHT]					= GENMASK(3, 0),
+						/* Bits 4-7 reserved */
+	[MAX_PREFETCH]					= BIT(8),
+	[USE_DB_ENG]					= BIT(9),
+	[USE_ESCAPE_BUF_ONLY]				= BIT(10),
+						/* Bits 11-31 reserved */
+};
+
+REG_STRIDE_FIELDS(CH_C_QOS, ch_c_qos, 0x0001c05c + 0x4000 * GSI_EE_AP, 0x80);
 
 REG(ERROR_LOG, error_log, 0x0001f200 + 0x4000 * GSI_EE_AP);
 
diff --git a/drivers/net/ipa/reg/gsi_reg-v4.5.c b/drivers/net/ipa/reg/gsi_reg-v4.5.c
index 538926bb8fc53..98121fd40fd8c 100644
--- a/drivers/net/ipa/reg/gsi_reg-v4.5.c
+++ b/drivers/net/ipa/reg/gsi_reg-v4.5.c
@@ -26,7 +26,18 @@ REG_STRIDE(CH_C_CNTXT_2, ch_c_cntxt_2, 0x0001c008 + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(CH_C_CNTXT_3, ch_c_cntxt_3, 0x0001c00c + 0x4000 * GSI_EE_AP, 0x80);
 
-REG_STRIDE(CH_C_QOS, ch_c_qos, 0x0001c05c + 0x4000 * GSI_EE_AP, 0x80);
+static const u32 reg_ch_c_qos_fmask[] = {
+	[WRR_WEIGHT]					= GENMASK(3, 0),
+						/* Bits 4-7 reserved */
+	[MAX_PREFETCH]					= BIT(8),
+	[USE_DB_ENG]					= BIT(9),
+	[PREFETCH_MODE]					= GENMASK(13, 10),
+						/* Bits 14-15 reserved */
+	[EMPTY_LVL_THRSHOLD]				= GENMASK(23, 16),
+						/* Bits 24-31 reserved */
+};
+
+REG_STRIDE_FIELDS(CH_C_QOS, ch_c_qos, 0x0001c05c + 0x4000 * GSI_EE_AP, 0x80);
 
 REG(ERROR_LOG, error_log, 0x0001f200 + 0x4000 * GSI_EE_AP);
 
diff --git a/drivers/net/ipa/reg/gsi_reg-v4.9.c b/drivers/net/ipa/reg/gsi_reg-v4.9.c
index 1d0be6cbbf800..72ff78863eaaf 100644
--- a/drivers/net/ipa/reg/gsi_reg-v4.9.c
+++ b/drivers/net/ipa/reg/gsi_reg-v4.9.c
@@ -26,7 +26,19 @@ REG_STRIDE(CH_C_CNTXT_2, ch_c_cntxt_2, 0x0001c008 + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(CH_C_CNTXT_3, ch_c_cntxt_3, 0x0001c00c + 0x4000 * GSI_EE_AP, 0x80);
 
-REG_STRIDE(CH_C_QOS, ch_c_qos, 0x0001c05c + 0x4000 * GSI_EE_AP, 0x80);
+static const u32 reg_ch_c_qos_fmask[] = {
+	[WRR_WEIGHT]					= GENMASK(3, 0),
+						/* Bits 4-7 reserved */
+	[MAX_PREFETCH]					= BIT(8),
+	[USE_DB_ENG]					= BIT(9),
+	[PREFETCH_MODE]					= GENMASK(13, 10),
+						/* Bits 14-15 reserved */
+	[EMPTY_LVL_THRSHOLD]				= GENMASK(23, 16),
+	[DB_IN_BYTES]					= BIT(24),
+						/* Bits 25-31 reserved */
+};
+
+REG_STRIDE_FIELDS(CH_C_QOS, ch_c_qos, 0x0001c05c + 0x4000 * GSI_EE_AP, 0x80);
 
 REG(ERROR_LOG, error_log, 0x0001f200 + 0x4000 * GSI_EE_AP);
 
-- 
2.34.1

