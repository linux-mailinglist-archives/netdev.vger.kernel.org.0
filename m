Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2207C5EB459
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 00:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231429AbiIZWMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 18:12:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231501AbiIZWL1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 18:11:27 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09E4D286CA
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 15:10:10 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id d8so6382098iof.11
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 15:10:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=DPf6chU44C+1U0d5KVfUQt8OJs7y48uT9aFMZVt2+yo=;
        b=sL3V3g86GzhO7aOFlW5PYsNrbd0baAvuh/rcCqgxbPcjLQP553rv+wL1C3YgMxaJbQ
         CHgX6spiPiBJRzr6PCQkfjA8xmO8RIXTkNq365sZzlU8rdhjGahTypbTlc4b29NP0a6t
         bcR3AY8uwxepexGde6p10hBxRNzINlyRSeRQRcawd3rPtR6ltD6zWM/61gx4NI4F4zO7
         VTtEHenHkG3n3667ZyZKj3qk2+nVstkqhRsuPUAhZktjMkwB2M7E9UlhaFOQdQbua0zV
         bkS8wJHKcjvggokFk2QhmGG5fgOmjacDYUYvEAl8ZBilDjt1vSOvKlj8yc2nI+1uSewT
         xjwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=DPf6chU44C+1U0d5KVfUQt8OJs7y48uT9aFMZVt2+yo=;
        b=Q0nEeygySYgCnisPkehlZJWw84uf7YQwT8ZxkFp9KFPedIdnsDGQmTw8eU95LXzisz
         WBCA8LJ518zz5lryWKHlWhrCITd8fWLuVA9KvQpBUDe3qOClq008Z4NddwlFt9sNR6zI
         40zssn0RwskC5LPThIZkrDUAT4OY1ofSbUOguIJKiT9ZA/g+7RiOX8Rg4BhpEiUKhi7R
         kuFMIezXQwNrqMiw3IEWX7voeg46glgkwkC0albUTdvZF5PxyZ8A+ydeNFoLLb0UanK1
         xYfz9eb7eaErdTfZEizV8P8AI+TuXnH07TGmHBtJDwOs/o7+2pdyL/TcUUPqknTcAh/L
         myJQ==
X-Gm-Message-State: ACrzQf2nrU3MgBVj87vEswIyXfZzaIycI+xAKtTUQoRzv6GlzXdkRJuZ
        uNm6Nj1+s3qttNt80A/gP13J8Q==
X-Google-Smtp-Source: AMsMyM5RiV05HaWWF/hEBbtxxhgZjywRd+TBDf01QFzhKMJpNx523UuJZ/0RP7BdqEkmgA088LGISg==
X-Received: by 2002:a05:6638:14cb:b0:358:4759:be8c with SMTP id l11-20020a05663814cb00b003584759be8cmr12766787jak.13.1664230209839;
        Mon, 26 Sep 2022 15:10:09 -0700 (PDT)
Received: from localhost.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id z20-20020a027a54000000b003567503cf92sm7631600jad.82.2022.09.26.15.10.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 15:10:08 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 14/15] net: ipa: define more IPA endpoint register fields
Date:   Mon, 26 Sep 2022 17:09:30 -0500
Message-Id: <20220926220931.3261749-15-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220926220931.3261749-1-elder@linaro.org>
References: <20220926220931.3261749-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define the fields for the ENDP_INIT_MODE, ENDP_INIT_AGGR,
ENDP_INIT_HOL_BLOCK_EN, and ENDP_INIT_HOL_BLOCK_TIMER IPA
registers for all supported IPA versions.

Create enumerated types to identify fields for these IPA registers.
Use IPA_REG_STRIDE_FIELDS() to specify the field mask values defined
for these registers, for each supported version of IPA.

Change aggr_time_limit_encode() and hol_block_timer_encode() so they
take an ipa_reg pointer, and use those register's fields to compute
their encoded results.  Have aggr_time_limit_encode() take an IPA
pointer rather than version, to match hol_block_timer_encode().

Use ipa_reg_encode(), ipa_reg_bit(), and ipa_reg_field_max() to
manipulate values to be written to these registers, remove the
definitions of the various inline functions and *_FMASK symbols that
are now no longer used.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c       | 121 +++++++++++----------------
 drivers/net/ipa/ipa_reg.h            |  89 +++++++-------------
 drivers/net/ipa/reg/ipa_reg-v3.1.c   |  47 +++++++++--
 drivers/net/ipa/reg/ipa_reg-v3.5.1.c |  47 +++++++++--
 drivers/net/ipa/reg/ipa_reg-v4.11.c  |  51 +++++++++--
 drivers/net/ipa/reg/ipa_reg-v4.2.c   |  49 +++++++++--
 drivers/net/ipa/reg/ipa_reg-v4.5.c   |  50 +++++++++--
 drivers/net/ipa/reg/ipa_reg-v4.9.c   |  51 +++++++++--
 8 files changed, 336 insertions(+), 169 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 80310ea745baa..f92964bea83d4 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -72,14 +72,6 @@ struct ipa_status {
 #define IPA_STATUS_FLAGS1_RT_RULE_ID_FMASK	GENMASK(31, 22)
 #define IPA_STATUS_FLAGS2_TAG_FMASK		GENMASK_ULL(63, 16)
 
-static u32 aggr_byte_limit_max(enum ipa_version version)
-{
-	if (version < IPA_VERSION_4_5)
-		return field_max(aggr_byte_limit_fmask(true));
-
-	return field_max(aggr_byte_limit_fmask(false));
-}
-
 /* Compute the aggregation size value to use for a given buffer size */
 static u32 ipa_aggr_size_kb(u32 rx_buffer_size, bool aggr_hard_limit)
 {
@@ -111,6 +103,7 @@ static bool ipa_endpoint_data_valid_one(struct ipa *ipa, u32 count,
 
 	if (!data->toward_ipa) {
 		const struct ipa_endpoint_rx *rx_config;
+		const struct ipa_reg *reg;
 		u32 buffer_size;
 		u32 aggr_size;
 		u32 limit;
@@ -171,7 +164,9 @@ static bool ipa_endpoint_data_valid_one(struct ipa *ipa, u32 count,
 		 */
 		aggr_size = ipa_aggr_size_kb(buffer_size - NET_SKB_PAD,
 					     rx_config->aggr_hard_limit);
-		limit = aggr_byte_limit_max(ipa->version);
+		reg = ipa_reg(ipa, ENDP_INIT_AGGR);
+
+		limit = ipa_reg_field_max(reg, BYTE_LIMIT);
 		if (aggr_size > limit) {
 			dev_err(dev, "aggregated size too large for RX endpoint %u (%u KB > %u KB)\n",
 				data->endpoint_id, aggr_size, limit);
@@ -769,32 +764,21 @@ static void ipa_endpoint_init_mode(struct ipa_endpoint *endpoint)
 		return;		/* Register not valid for RX endpoints */
 
 	reg = ipa_reg(ipa, ENDP_INIT_MODE);
-	offset = ipa_reg_n_offset(reg, endpoint->endpoint_id);
 	if (endpoint->config.dma_mode) {
 		enum ipa_endpoint_name name = endpoint->config.dma_endpoint;
-		u32 dma_endpoint_id;
+		u32 dma_endpoint_id = ipa->name_map[name]->endpoint_id;
 
-		dma_endpoint_id = ipa->name_map[name]->endpoint_id;
-
-		val = u32_encode_bits(IPA_DMA, MODE_FMASK);
-		val |= u32_encode_bits(dma_endpoint_id, DEST_PIPE_INDEX_FMASK);
+		val = ipa_reg_encode(reg, ENDP_MODE, IPA_DMA);
+		val |= ipa_reg_encode(reg, DEST_PIPE_INDEX, dma_endpoint_id);
 	} else {
-		val = u32_encode_bits(IPA_BASIC, MODE_FMASK);
+		val = ipa_reg_encode(reg, ENDP_MODE, IPA_BASIC);
 	}
 	/* All other bits unspecified (and 0) */
 
+	offset = ipa_reg_n_offset(reg, endpoint->endpoint_id);
 	iowrite32(val, ipa->reg_virt + offset);
 }
 
-/* Encoded values for AGGR endpoint register fields */
-static u32 aggr_byte_limit_encoded(enum ipa_version version, u32 limit)
-{
-	if (version < IPA_VERSION_4_5)
-		return u32_encode_bits(limit, aggr_byte_limit_fmask(true));
-
-	return u32_encode_bits(limit, aggr_byte_limit_fmask(false));
-}
-
 /* For IPA v4.5+, times are expressed using Qtime.  The AP uses one of two
  * pulse generators (0 and 1) to measure elapsed time.  In ipa_qtime_config()
  * they're configured to have granularity 100 usec and 1 msec, respectively.
@@ -820,50 +804,39 @@ static int ipa_qtime_val(u32 microseconds, u32 max)
 }
 
 /* Encode the aggregation timer limit (microseconds) based on IPA version */
-static u32 aggr_time_limit_encode(enum ipa_version version, u32 microseconds)
+static u32 aggr_time_limit_encode(struct ipa *ipa, const struct ipa_reg *reg,
+				  u32 microseconds)
 {
-	u32 fmask;
+	u32 max;
 	u32 val;
 
 	if (!microseconds)
 		return 0;	/* Nothing to compute if time limit is 0 */
 
-	if (version >= IPA_VERSION_4_5) {
+	max = ipa_reg_field_max(reg, TIME_LIMIT);
+	if (ipa->version >= IPA_VERSION_4_5) {
 		u32 gran_sel;
 		int ret;
 
 		/* Compute the Qtime limit value to use */
-		fmask = aggr_time_limit_fmask(false);
-		ret = ipa_qtime_val(microseconds, field_max(fmask));
+		ret = ipa_qtime_val(microseconds, max);
 		if (ret < 0) {
 			val = -ret;
-			gran_sel = AGGR_GRAN_SEL_FMASK;
+			gran_sel = ipa_reg_bit(reg, AGGR_GRAN_SEL);
 		} else {
 			val = ret;
 			gran_sel = 0;
 		}
 
-		return gran_sel | u32_encode_bits(val, fmask);
+		return gran_sel | ipa_reg_encode(reg, TIME_LIMIT, val);
 	}
 
-	/* We set aggregation granularity in ipa_hardware_config() */
-	fmask = aggr_time_limit_fmask(true);
+	/* We program aggregation granularity in ipa_hardware_config() */
 	val = DIV_ROUND_CLOSEST(microseconds, IPA_AGGR_GRANULARITY);
-	WARN(val > field_max(fmask),
-	     "aggr_time_limit too large (%u > %u usec)\n",
-	     val, field_max(fmask) * IPA_AGGR_GRANULARITY);
+	WARN(val > max, "aggr_time_limit too large (%u > %u usec)\n",
+	     microseconds, max * IPA_AGGR_GRANULARITY);
 
-	return u32_encode_bits(val, fmask);
-}
-
-static u32 aggr_sw_eof_active_encoded(enum ipa_version version, bool enabled)
-{
-	u32 val = enabled ? 1 : 0;
-
-	if (version < IPA_VERSION_4_5)
-		return u32_encode_bits(val, aggr_sw_eof_active_fmask(true));
-
-	return u32_encode_bits(val, aggr_sw_eof_active_fmask(false));
+	return ipa_reg_encode(reg, TIME_LIMIT, val);
 }
 
 static void ipa_endpoint_init_aggr(struct ipa_endpoint *endpoint)
@@ -877,37 +850,34 @@ static void ipa_endpoint_init_aggr(struct ipa_endpoint *endpoint)
 	if (endpoint->config.aggregation) {
 		if (!endpoint->toward_ipa) {
 			const struct ipa_endpoint_rx *rx_config;
-			enum ipa_version version = ipa->version;
 			u32 buffer_size;
-			bool close_eof;
 			u32 limit;
 
 			rx_config = &endpoint->config.rx;
-			val |= u32_encode_bits(IPA_ENABLE_AGGR, AGGR_EN_FMASK);
-			val |= u32_encode_bits(IPA_GENERIC, AGGR_TYPE_FMASK);
+			val |= ipa_reg_encode(reg, AGGR_EN, IPA_ENABLE_AGGR);
+			val |= ipa_reg_encode(reg, AGGR_TYPE, IPA_GENERIC);
 
 			buffer_size = rx_config->buffer_size;
 			limit = ipa_aggr_size_kb(buffer_size - NET_SKB_PAD,
 						 rx_config->aggr_hard_limit);
-			val |= aggr_byte_limit_encoded(version, limit);
+			val |= ipa_reg_encode(reg, BYTE_LIMIT, limit);
 
 			limit = rx_config->aggr_time_limit;
-			val |= aggr_time_limit_encode(version, limit);
+			val |= aggr_time_limit_encode(ipa, reg, limit);
 
 			/* AGGR_PKT_LIMIT is 0 (unlimited) */
 
-			close_eof = rx_config->aggr_close_eof;
-			val |= aggr_sw_eof_active_encoded(version, close_eof);
+			if (rx_config->aggr_close_eof)
+				val |= ipa_reg_bit(reg, SW_EOF_ACTIVE);
 		} else {
-			val |= u32_encode_bits(IPA_ENABLE_DEAGGR,
-					       AGGR_EN_FMASK);
-			val |= u32_encode_bits(IPA_QCMAP, AGGR_TYPE_FMASK);
+			val |= ipa_reg_encode(reg, AGGR_EN, IPA_ENABLE_DEAGGR);
+			val |= ipa_reg_encode(reg, AGGR_TYPE, IPA_QCMAP);
 			/* other fields ignored */
 		}
 		/* AGGR_FORCE_CLOSE is 0 */
 		/* AGGR_GRAN_SEL is 0 for IPA v4.5 */
 	} else {
-		val |= u32_encode_bits(IPA_BYPASS_AGGR, AGGR_EN_FMASK);
+		val |= ipa_reg_encode(reg, AGGR_EN, IPA_BYPASS_AGGR);
 		/* other fields ignored */
 	}
 
@@ -922,7 +892,8 @@ static void ipa_endpoint_init_aggr(struct ipa_endpoint *endpoint)
  * Return the encoded value representing the timeout period provided
  * that should be written to the ENDP_INIT_HOL_BLOCK_TIMER register.
  */
-static u32 hol_block_timer_encode(struct ipa *ipa, u32 microseconds)
+static u32 hol_block_timer_encode(struct ipa *ipa, const struct ipa_reg *reg,
+				  u32 microseconds)
 {
 	u32 width;
 	u32 scale;
@@ -935,31 +906,33 @@ static u32 hol_block_timer_encode(struct ipa *ipa, u32 microseconds)
 		return 0;	/* Nothing to compute if timer period is 0 */
 
 	if (ipa->version >= IPA_VERSION_4_5) {
+		u32 max = ipa_reg_field_max(reg, TIMER_LIMIT);
 		u32 gran_sel;
 		int ret;
 
 		/* Compute the Qtime limit value to use */
-		ret = ipa_qtime_val(microseconds, field_max(TIME_LIMIT_FMASK));
+		ret = ipa_qtime_val(microseconds, max);
 		if (ret < 0) {
 			val = -ret;
-			gran_sel = GRAN_SEL_FMASK;
+			gran_sel = ipa_reg_bit(reg, TIMER_GRAN_SEL);
 		} else {
 			val = ret;
 			gran_sel = 0;
 		}
 
-		return gran_sel | u32_encode_bits(val, TIME_LIMIT_FMASK);
+		return gran_sel | ipa_reg_encode(reg, TIMER_LIMIT, val);
 	}
 
-	/* Use 64 bit arithmetic to avoid overflow... */
+	/* Use 64 bit arithmetic to avoid overflow */
 	rate = ipa_core_clock_rate(ipa);
 	ticks = DIV_ROUND_CLOSEST(microseconds * rate, 128 * USEC_PER_SEC);
-	/* ...but we still need to fit into a 32-bit register */
-	WARN_ON(ticks > U32_MAX);
+
+	/* We still need the result to fit into the field */
+	WARN_ON(ticks > ipa_reg_field_max(reg, TIMER_BASE_VALUE));
 
 	/* IPA v3.5.1 through v4.1 just record the tick count */
 	if (ipa->version < IPA_VERSION_4_2)
-		return (u32)ticks;
+		return ipa_reg_encode(reg, TIMER_BASE_VALUE, (u32)ticks);
 
 	/* For IPA v4.2, the tick count is represented by base and
 	 * scale fields within the 32-bit timer register, where:
@@ -969,8 +942,8 @@ static u32 hol_block_timer_encode(struct ipa *ipa, u32 microseconds)
 	 * count, and extract the number of bits in the base field
 	 * such that high bit is included.
 	 */
-	high = fls(ticks);		/* 1..32 */
-	width = HWEIGHT32(BASE_VALUE_FMASK);
+	high = fls(ticks);		/* 1..32 (or warning above) */
+	width = hweight32(ipa_reg_fmask(reg, TIMER_BASE_VALUE));
 	scale = high > width ? high - width : 0;
 	if (scale) {
 		/* If we're scaling, round up to get a closer result */
@@ -980,8 +953,8 @@ static u32 hol_block_timer_encode(struct ipa *ipa, u32 microseconds)
 			scale++;
 	}
 
-	val = u32_encode_bits(scale, SCALE_FMASK);
-	val |= u32_encode_bits(ticks >> scale, BASE_VALUE_FMASK);
+	val = ipa_reg_encode(reg, TIMER_SCALE, scale);
+	val |= ipa_reg_encode(reg, TIMER_BASE_VALUE, (u32)ticks >> scale);
 
 	return val;
 }
@@ -997,7 +970,7 @@ static void ipa_endpoint_init_hol_block_timer(struct ipa_endpoint *endpoint,
 
 	/* This should only be changed when HOL_BLOCK_EN is disabled */
 	reg = ipa_reg(ipa, ENDP_INIT_HOL_BLOCK_TIMER);
-	val = hol_block_timer_encode(ipa, microseconds);
+	val = hol_block_timer_encode(ipa, reg, microseconds);
 
 	iowrite32(val, ipa->reg_virt + ipa_reg_n_offset(reg, endpoint_id));
 }
@@ -1013,7 +986,7 @@ ipa_endpoint_init_hol_block_en(struct ipa_endpoint *endpoint, bool enable)
 
 	reg = ipa_reg(ipa, ENDP_INIT_HOL_BLOCK_EN);
 	offset = ipa_reg_n_offset(reg, endpoint_id);
-	val = enable ? HOL_BLOCK_EN_FMASK : 0;
+	val = enable ? ipa_reg_bit(reg, HOL_BLOCK_EN) : 0;
 
 	iowrite32(val, ipa->reg_virt + offset);
 
diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
index bf8191ba2dda7..d4120eeb58cf3 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -433,17 +433,16 @@ enum ipa_reg_endp_init_hdr_ext_field_id {
 };
 
 /* ENDP_INIT_MODE register */
-#define MODE_FMASK				GENMASK(2, 0)
-/* The next field is present for IPA v4.5+ */
-#define DCPH_ENABLE_FMASK			GENMASK(3, 3)
-#define DEST_PIPE_INDEX_FMASK			GENMASK(8, 4)
-#define BYTE_THRESHOLD_FMASK			GENMASK(27, 12)
-#define PIPE_REPLICATION_EN_FMASK		GENMASK(28, 28)
-#define PAD_EN_FMASK				GENMASK(29, 29)
-/* The next field is not present for IPA v4.5+ */
-#define HDR_FTCH_DISABLE_FMASK			GENMASK(30, 30)
-/* The next field is present for IPA v4.9+ */
-#define DRBIP_ACL_ENABLE_FMASK			GENMASK(30, 30)
+enum ipa_reg_endp_init_mode_field_id {
+	ENDP_MODE,
+	DCPH_ENABLE,					/* v4.5+ */
+	DEST_PIPE_INDEX,
+	BYTE_THRESHOLD,
+	PIPE_REPLICATION_EN,
+	PAD_EN,
+	HDR_FTCH_DISABLE,				/* v4.5+ */
+	DRBIP_ACL_ENABLE,				/* v4.9+ */
+};
 
 /** enum ipa_mode - ENDP_INIT_MODE register MODE field value */
 enum ipa_mode {
@@ -454,47 +453,17 @@ enum ipa_mode {
 };
 
 /* ENDP_INIT_AGGR register */
-#define AGGR_EN_FMASK				GENMASK(1, 0)
-#define AGGR_TYPE_FMASK				GENMASK(4, 2)
-
-/* The legacy value is used for IPA hardware before IPA v4.5 */
-static inline u32 aggr_byte_limit_fmask(bool legacy)
-{
-	return legacy ? GENMASK(9, 5) : GENMASK(10, 5);
-}
-
-/* The legacy value is used for IPA hardware before IPA v4.5 */
-static inline u32 aggr_time_limit_fmask(bool legacy)
-{
-	return legacy ? GENMASK(14, 10) : GENMASK(16, 12);
-}
-
-/* The legacy value is used for IPA hardware before IPA v4.5 */
-static inline u32 aggr_pkt_limit_fmask(bool legacy)
-{
-	return legacy ? GENMASK(20, 15) : GENMASK(22, 17);
-}
-
-/* The legacy value is used for IPA hardware before IPA v4.5 */
-static inline u32 aggr_sw_eof_active_fmask(bool legacy)
-{
-	return legacy ? GENMASK(21, 21) : GENMASK(23, 23);
-}
-
-/* The legacy value is used for IPA hardware before IPA v4.5 */
-static inline u32 aggr_force_close_fmask(bool legacy)
-{
-	return legacy ? GENMASK(22, 22) : GENMASK(24, 24);
-}
-
-/* The legacy value is used for IPA hardware before IPA v4.5 */
-static inline u32 aggr_hard_byte_limit_enable_fmask(bool legacy)
-{
-	return legacy ? GENMASK(24, 24) : GENMASK(26, 26);
-}
-
-/* The next field is present for IPA v4.5+ */
-#define AGGR_GRAN_SEL_FMASK			GENMASK(27, 27)
+enum ipa_reg_endp_init_aggr_field_id {
+	AGGR_EN,
+	AGGR_TYPE,
+	BYTE_LIMIT,
+	TIME_LIMIT,
+	PKT_LIMIT,
+	SW_EOF_ACTIVE,
+	FORCE_CLOSE,
+	HARD_BYTE_LIMIT_EN,
+	AGGR_GRAN_SEL,
+};
 
 /** enum ipa_aggr_en - ENDP_INIT_AGGR register AGGR_EN field value */
 enum ipa_aggr_en {
@@ -515,15 +484,17 @@ enum ipa_aggr_type {
 };
 
 /* ENDP_INIT_HOL_BLOCK_EN register */
-#define HOL_BLOCK_EN_FMASK			GENMASK(0, 0)
+enum ipa_reg_endp_init_hol_block_en_field_id {
+	HOL_BLOCK_EN,
+};
 
 /* ENDP_INIT_HOL_BLOCK_TIMER register */
-/* The next two fields are present for IPA v4.2 only */
-#define BASE_VALUE_FMASK			GENMASK(4, 0)
-#define SCALE_FMASK				GENMASK(12, 8)
-/* The next two fields are present for IPA v4.5 */
-#define TIME_LIMIT_FMASK			GENMASK(4, 0)
-#define GRAN_SEL_FMASK				GENMASK(8, 8)
+enum ipa_reg_endp_init_hol_block_timer_field_id {
+	TIMER_BASE_VALUE,				/* Not v4.5+ */
+	TIMER_SCALE,					/* v4.2 only */
+	TIMER_LIMIT,					/* v4.5+ */
+	TIMER_GRAN_SEL,					/* v4.5+ */
+};
 
 /* ENDP_INIT_DEAGGR register */
 #define DEAGGR_HDR_LEN_FMASK			GENMASK(5, 0)
diff --git a/drivers/net/ipa/reg/ipa_reg-v3.1.c b/drivers/net/ipa/reg/ipa_reg-v3.1.c
index ced82061ba625..7fd231807f37d 100644
--- a/drivers/net/ipa/reg/ipa_reg-v3.1.c
+++ b/drivers/net/ipa/reg/ipa_reg-v3.1.c
@@ -294,15 +294,50 @@ IPA_REG_STRIDE_FIELDS(ENDP_INIT_HDR_EXT, endp_init_hdr_ext, 0x00000814, 0x0070);
 IPA_REG_STRIDE(ENDP_INIT_HDR_METADATA_MASK, endp_init_hdr_metadata_mask,
 	       0x00000818, 0x0070);
 
-IPA_REG_STRIDE(ENDP_INIT_MODE, endp_init_mode, 0x00000820, 0x0070);
+static const u32 ipa_reg_endp_init_mode_fmask[] = {
+	[ENDP_MODE]					= GENMASK(2, 0),
+						/* Bit 3 reserved */
+	[DEST_PIPE_INDEX]				= GENMASK(8, 4),
+						/* Bits 9-11 reserved */
+	[BYTE_THRESHOLD]				= GENMASK(27, 12),
+	[PIPE_REPLICATION_EN]				= BIT(28),
+	[PAD_EN]					= BIT(29),
+	[HDR_FTCH_DISABLE]				= BIT(30),
+						/* Bit 31 reserved */
+};
 
-IPA_REG_STRIDE(ENDP_INIT_AGGR, endp_init_aggr, 0x00000824, 0x0070);
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_MODE, endp_init_mode, 0x00000820, 0x0070);
 
-IPA_REG_STRIDE(ENDP_INIT_HOL_BLOCK_EN, endp_init_hol_block_en,
-	       0x0000082c, 0x0070);
+static const u32 ipa_reg_endp_init_aggr_fmask[] = {
+	[AGGR_EN]					= GENMASK(1, 0),
+	[AGGR_TYPE]					= GENMASK(4, 2),
+	[BYTE_LIMIT]					= GENMASK(9, 5),
+	[TIME_LIMIT]					= GENMASK(14, 10),
+	[PKT_LIMIT]					= GENMASK(20, 15),
+	[SW_EOF_ACTIVE]					= BIT(21),
+	[FORCE_CLOSE]					= BIT(22),
+						/* Bit 23 reserved */
+	[HARD_BYTE_LIMIT_EN]				= BIT(24),
+						/* Bits 25-31 reserved */
+};
 
-IPA_REG_STRIDE(ENDP_INIT_HOL_BLOCK_TIMER, endp_init_hol_block_timer,
-	       0x00000830, 0x0070);
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_AGGR, endp_init_aggr, 0x00000824, 0x0070);
+
+static const u32 ipa_reg_endp_init_hol_block_en_fmask[] = {
+	[HOL_BLOCK_EN]					= BIT(0),
+						/* Bits 1-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_HOL_BLOCK_EN, endp_init_hol_block_en,
+		      0x0000082c, 0x0070);
+
+/* Entire register is a tick count */
+static const u32 ipa_reg_endp_init_hol_block_timer_fmask[] = {
+	[TIMER_BASE_VALUE]				= GENMASK(31, 0),
+};
+
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_HOL_BLOCK_TIMER, endp_init_hol_block_timer,
+		      0x00000830, 0x0070);
 
 IPA_REG_STRIDE(ENDP_INIT_DEAGGR, endp_init_deaggr, 0x00000834, 0x0070);
 
diff --git a/drivers/net/ipa/reg/ipa_reg-v3.5.1.c b/drivers/net/ipa/reg/ipa_reg-v3.5.1.c
index d90367eab9ccf..c48958c7bb737 100644
--- a/drivers/net/ipa/reg/ipa_reg-v3.5.1.c
+++ b/drivers/net/ipa/reg/ipa_reg-v3.5.1.c
@@ -273,15 +273,50 @@ IPA_REG_STRIDE_FIELDS(ENDP_INIT_HDR_EXT, endp_init_hdr_ext, 0x00000814, 0x0070);
 IPA_REG_STRIDE(ENDP_INIT_HDR_METADATA_MASK, endp_init_hdr_metadata_mask,
 	       0x00000818, 0x0070);
 
-IPA_REG_STRIDE(ENDP_INIT_MODE, endp_init_mode, 0x00000820, 0x0070);
+static const u32 ipa_reg_endp_init_mode_fmask[] = {
+	[ENDP_MODE]					= GENMASK(2, 0),
+						/* Bit 3 reserved */
+	[DEST_PIPE_INDEX]				= GENMASK(8, 4),
+						/* Bits 9-11 reserved */
+	[BYTE_THRESHOLD]				= GENMASK(27, 12),
+	[PIPE_REPLICATION_EN]				= BIT(28),
+	[PAD_EN]					= BIT(29),
+	[HDR_FTCH_DISABLE]				= BIT(30),
+						/* Bit 31 reserved */
+};
 
-IPA_REG_STRIDE(ENDP_INIT_AGGR, endp_init_aggr, 0x00000824, 0x0070);
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_MODE, endp_init_mode, 0x00000820, 0x0070);
 
-IPA_REG_STRIDE(ENDP_INIT_HOL_BLOCK_EN, endp_init_hol_block_en,
-	       0x0000082c, 0x0070);
+static const u32 ipa_reg_endp_init_aggr_fmask[] = {
+	[AGGR_EN]					= GENMASK(1, 0),
+	[AGGR_TYPE]					= GENMASK(4, 2),
+	[BYTE_LIMIT]					= GENMASK(9, 5),
+	[TIME_LIMIT]					= GENMASK(14, 10),
+	[PKT_LIMIT]					= GENMASK(20, 15),
+	[SW_EOF_ACTIVE]					= BIT(21),
+	[FORCE_CLOSE]					= BIT(22),
+						/* Bit 23 reserved */
+	[HARD_BYTE_LIMIT_EN]				= BIT(24),
+						/* Bits 25-31 reserved */
+};
 
-IPA_REG_STRIDE(ENDP_INIT_HOL_BLOCK_TIMER, endp_init_hol_block_timer,
-	       0x00000830, 0x0070);
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_AGGR, endp_init_aggr, 0x00000824, 0x0070);
+
+static const u32 ipa_reg_endp_init_hol_block_en_fmask[] = {
+	[HOL_BLOCK_EN]					= BIT(0),
+						/* Bits 1-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_HOL_BLOCK_EN, endp_init_hol_block_en,
+		      0x0000082c, 0x0070);
+
+/* Entire register is a tick count */
+static const u32 ipa_reg_endp_init_hol_block_timer_fmask[] = {
+	[TIMER_BASE_VALUE]				= GENMASK(31, 0),
+};
+
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_HOL_BLOCK_TIMER, endp_init_hol_block_timer,
+		      0x00000830, 0x0070);
 
 IPA_REG_STRIDE(ENDP_INIT_DEAGGR, endp_init_deaggr, 0x00000834, 0x0070);
 
diff --git a/drivers/net/ipa/reg/ipa_reg-v4.11.c b/drivers/net/ipa/reg/ipa_reg-v4.11.c
index ed775c8aa79c8..fc1bb039e9ed9 100644
--- a/drivers/net/ipa/reg/ipa_reg-v4.11.c
+++ b/drivers/net/ipa/reg/ipa_reg-v4.11.c
@@ -326,15 +326,54 @@ IPA_REG_STRIDE_FIELDS(ENDP_INIT_HDR_EXT, endp_init_hdr_ext, 0x00000814, 0x0070);
 IPA_REG_STRIDE(ENDP_INIT_HDR_METADATA_MASK, endp_init_hdr_metadata_mask,
 	       0x00000818, 0x0070);
 
-IPA_REG_STRIDE(ENDP_INIT_MODE, endp_init_mode, 0x00000820, 0x0070);
+static const u32 ipa_reg_endp_init_mode_fmask[] = {
+	[ENDP_MODE]					= GENMASK(2, 0),
+	[DCPH_ENABLE]					= BIT(3),
+	[DEST_PIPE_INDEX]				= GENMASK(8, 4),
+						/* Bits 9-11 reserved */
+	[BYTE_THRESHOLD]				= GENMASK(27, 12),
+	[PIPE_REPLICATION_EN]				= BIT(28),
+	[PAD_EN]					= BIT(29),
+	[DRBIP_ACL_ENABLE]				= BIT(30),
+						/* Bit 31 reserved */
+};
 
-IPA_REG_STRIDE(ENDP_INIT_AGGR, endp_init_aggr, 0x00000824, 0x0070);
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_MODE, endp_init_mode, 0x00000820, 0x0070);
 
-IPA_REG_STRIDE(ENDP_INIT_HOL_BLOCK_EN, endp_init_hol_block_en,
-	       0x0000082c, 0x0070);
+static const u32 ipa_reg_endp_init_aggr_fmask[] = {
+	[AGGR_EN]					= GENMASK(1, 0),
+	[AGGR_TYPE]					= GENMASK(4, 2),
+	[BYTE_LIMIT]					= GENMASK(10, 5),
+						/* Bit 11 reserved */
+	[TIME_LIMIT]					= GENMASK(16, 12),
+	[PKT_LIMIT]					= GENMASK(22, 17),
+	[SW_EOF_ACTIVE]					= BIT(23),
+	[FORCE_CLOSE]					= BIT(24),
+						/* Bit 25 reserved */
+	[HARD_BYTE_LIMIT_EN]				= BIT(26),
+	[AGGR_GRAN_SEL]					= BIT(27),
+						/* Bits 28-31 reserved */
+};
 
-IPA_REG_STRIDE(ENDP_INIT_HOL_BLOCK_TIMER, endp_init_hol_block_timer,
-	       0x00000830, 0x0070);
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_AGGR, endp_init_aggr, 0x00000824, 0x0070);
+
+static const u32 ipa_reg_endp_init_hol_block_en_fmask[] = {
+	[HOL_BLOCK_EN]					= BIT(0),
+						/* Bits 1-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_HOL_BLOCK_EN, endp_init_hol_block_en,
+		      0x0000082c, 0x0070);
+
+static const u32 ipa_reg_endp_init_hol_block_timer_fmask[] = {
+	[TIMER_LIMIT]					= GENMASK(4, 0),
+						/* Bits 5-7 reserved */
+	[TIMER_GRAN_SEL]				= BIT(8),
+						/* Bits 9-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_HOL_BLOCK_TIMER, endp_init_hol_block_timer,
+		      0x00000830, 0x0070);
 
 IPA_REG_STRIDE(ENDP_INIT_DEAGGR, endp_init_deaggr, 0x00000834, 0x0070);
 
diff --git a/drivers/net/ipa/reg/ipa_reg-v4.2.c b/drivers/net/ipa/reg/ipa_reg-v4.2.c
index 22e30c7ebac96..b6f59c4afdf96 100644
--- a/drivers/net/ipa/reg/ipa_reg-v4.2.c
+++ b/drivers/net/ipa/reg/ipa_reg-v4.2.c
@@ -296,15 +296,52 @@ IPA_REG_STRIDE_FIELDS(ENDP_INIT_HDR_EXT, endp_init_hdr_ext, 0x00000814, 0x0070);
 IPA_REG_STRIDE(ENDP_INIT_HDR_METADATA_MASK, endp_init_hdr_metadata_mask,
 	       0x00000818, 0x0070);
 
-IPA_REG_STRIDE(ENDP_INIT_MODE, endp_init_mode, 0x00000820, 0x0070);
+static const u32 ipa_reg_endp_init_mode_fmask[] = {
+	[ENDP_MODE]					= GENMASK(2, 0),
+						/* Bit 3 reserved */
+	[DEST_PIPE_INDEX]				= GENMASK(8, 4),
+						/* Bits 9-11 reserved */
+	[BYTE_THRESHOLD]				= GENMASK(27, 12),
+	[PIPE_REPLICATION_EN]				= BIT(28),
+	[PAD_EN]					= BIT(29),
+	[HDR_FTCH_DISABLE]				= BIT(30),
+						/* Bit 31 reserved */
+};
 
-IPA_REG_STRIDE(ENDP_INIT_AGGR, endp_init_aggr, 0x00000824, 0x0070);
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_MODE, endp_init_mode, 0x00000820, 0x0070);
 
-IPA_REG_STRIDE(ENDP_INIT_HOL_BLOCK_EN, endp_init_hol_block_en,
-	       0x0000082c, 0x0070);
+static const u32 ipa_reg_endp_init_aggr_fmask[] = {
+	[AGGR_EN]					= GENMASK(1, 0),
+	[AGGR_TYPE]					= GENMASK(4, 2),
+	[BYTE_LIMIT]					= GENMASK(9, 5),
+	[TIME_LIMIT]					= GENMASK(14, 10),
+	[PKT_LIMIT]					= GENMASK(20, 15),
+	[SW_EOF_ACTIVE]					= BIT(21),
+	[FORCE_CLOSE]					= BIT(22),
+						/* Bit 23 reserved */
+	[HARD_BYTE_LIMIT_EN]				= BIT(24),
+						/* Bits 25-31 reserved */
+};
 
-IPA_REG_STRIDE(ENDP_INIT_HOL_BLOCK_TIMER, endp_init_hol_block_timer,
-	       0x00000830, 0x0070);
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_AGGR, endp_init_aggr, 0x00000824, 0x0070);
+
+static const u32 ipa_reg_endp_init_hol_block_en_fmask[] = {
+	[HOL_BLOCK_EN]					= BIT(0),
+						/* Bits 1-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_HOL_BLOCK_EN, endp_init_hol_block_en,
+		      0x0000082c, 0x0070);
+
+static const u32 ipa_reg_endp_init_hol_block_timer_fmask[] = {
+	[TIMER_BASE_VALUE]				= GENMASK(4, 0),
+						/* Bits 5-7 reserved */
+	[TIMER_SCALE]					= GENMASK(12, 8),
+						/* Bits 9-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_HOL_BLOCK_TIMER, endp_init_hol_block_timer,
+		      0x00000830, 0x0070);
 
 IPA_REG_STRIDE(ENDP_INIT_DEAGGR, endp_init_deaggr, 0x00000834, 0x0070);
 
diff --git a/drivers/net/ipa/reg/ipa_reg-v4.5.c b/drivers/net/ipa/reg/ipa_reg-v4.5.c
index d5739f7d15ca5..6db5ec500aedc 100644
--- a/drivers/net/ipa/reg/ipa_reg-v4.5.c
+++ b/drivers/net/ipa/reg/ipa_reg-v4.5.c
@@ -346,15 +346,53 @@ IPA_REG_STRIDE_FIELDS(ENDP_INIT_HDR_EXT, endp_init_hdr_ext, 0x00000814, 0x0070);
 IPA_REG_STRIDE(ENDP_INIT_HDR_METADATA_MASK, endp_init_hdr_metadata_mask,
 	       0x00000818, 0x0070);
 
-IPA_REG_STRIDE(ENDP_INIT_MODE, endp_init_mode, 0x00000820, 0x0070);
+static const u32 ipa_reg_endp_init_mode_fmask[] = {
+	[ENDP_MODE]					= GENMASK(2, 0),
+	[DCPH_ENABLE]					= BIT(3),
+	[DEST_PIPE_INDEX]				= GENMASK(8, 4),
+						/* Bits 9-11 reserved */
+	[BYTE_THRESHOLD]				= GENMASK(27, 12),
+	[PIPE_REPLICATION_EN]				= BIT(28),
+	[PAD_EN]					= BIT(29),
+						/* Bits 30-31 reserved */
+};
 
-IPA_REG_STRIDE(ENDP_INIT_AGGR, endp_init_aggr, 0x00000824, 0x0070);
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_MODE, endp_init_mode, 0x00000820, 0x0070);
 
-IPA_REG_STRIDE(ENDP_INIT_HOL_BLOCK_EN, endp_init_hol_block_en,
-	       0x0000082c, 0x0070);
+static const u32 ipa_reg_endp_init_aggr_fmask[] = {
+	[AGGR_EN]					= GENMASK(1, 0),
+	[AGGR_TYPE]					= GENMASK(4, 2),
+	[BYTE_LIMIT]					= GENMASK(10, 5),
+						/* Bit 11 reserved */
+	[TIME_LIMIT]					= GENMASK(16, 12),
+	[PKT_LIMIT]					= GENMASK(22, 17),
+	[SW_EOF_ACTIVE]					= BIT(23),
+	[FORCE_CLOSE]					= BIT(24),
+						/* Bit 25 reserved */
+	[HARD_BYTE_LIMIT_EN]				= BIT(26),
+	[AGGR_GRAN_SEL]					= BIT(27),
+						/* Bits 28-31 reserved */
+};
 
-IPA_REG_STRIDE(ENDP_INIT_HOL_BLOCK_TIMER, endp_init_hol_block_timer,
-	       0x00000830, 0x0070);
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_AGGR, endp_init_aggr, 0x00000824, 0x0070);
+
+static const u32 ipa_reg_endp_init_hol_block_en_fmask[] = {
+	[HOL_BLOCK_EN]					= BIT(0),
+						/* Bits 1-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_HOL_BLOCK_EN, endp_init_hol_block_en,
+		      0x0000082c, 0x0070);
+
+static const u32 ipa_reg_endp_init_hol_block_timer_fmask[] = {
+	[TIMER_LIMIT]					= GENMASK(4, 0),
+						/* Bits 5-7 reserved */
+	[TIMER_GRAN_SEL]				= BIT(8),
+						/* Bits 9-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_HOL_BLOCK_TIMER, endp_init_hol_block_timer,
+		      0x00000830, 0x0070);
 
 IPA_REG_STRIDE(ENDP_INIT_DEAGGR, endp_init_deaggr, 0x00000834, 0x0070);
 
diff --git a/drivers/net/ipa/reg/ipa_reg-v4.9.c b/drivers/net/ipa/reg/ipa_reg-v4.9.c
index 206e7af959623..37dc9292b88c3 100644
--- a/drivers/net/ipa/reg/ipa_reg-v4.9.c
+++ b/drivers/net/ipa/reg/ipa_reg-v4.9.c
@@ -323,15 +323,54 @@ IPA_REG_STRIDE_FIELDS(ENDP_INIT_HDR_EXT, endp_init_hdr_ext, 0x00000814, 0x0070);
 IPA_REG_STRIDE(ENDP_INIT_HDR_METADATA_MASK, endp_init_hdr_metadata_mask,
 	       0x00000818, 0x0070);
 
-IPA_REG_STRIDE(ENDP_INIT_MODE, endp_init_mode, 0x00000820, 0x0070);
+static const u32 ipa_reg_endp_init_mode_fmask[] = {
+	[ENDP_MODE]					= GENMASK(2, 0),
+	[DCPH_ENABLE]					= BIT(3),
+	[DEST_PIPE_INDEX]				= GENMASK(8, 4),
+						/* Bits 9-11 reserved */
+	[BYTE_THRESHOLD]				= GENMASK(27, 12),
+	[PIPE_REPLICATION_EN]				= BIT(28),
+	[PAD_EN]					= BIT(29),
+	[DRBIP_ACL_ENABLE]				= BIT(30),
+						/* Bit 31 reserved */
+};
 
-IPA_REG_STRIDE(ENDP_INIT_AGGR, endp_init_aggr, 0x00000824, 0x0070);
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_MODE, endp_init_mode, 0x00000820, 0x0070);
 
-IPA_REG_STRIDE(ENDP_INIT_HOL_BLOCK_EN, endp_init_hol_block_en,
-	       0x0000082c, 0x0070);
+static const u32 ipa_reg_endp_init_aggr_fmask[] = {
+	[AGGR_EN]					= GENMASK(1, 0),
+	[AGGR_TYPE]					= GENMASK(4, 2),
+	[BYTE_LIMIT]					= GENMASK(10, 5),
+						/* Bit 11 reserved */
+	[TIME_LIMIT]					= GENMASK(16, 12),
+	[PKT_LIMIT]					= GENMASK(22, 17),
+	[SW_EOF_ACTIVE]					= BIT(23),
+	[FORCE_CLOSE]					= BIT(24),
+						/* Bit 25 reserved */
+	[HARD_BYTE_LIMIT_EN]				= BIT(26),
+	[AGGR_GRAN_SEL]					= BIT(27),
+						/* Bits 28-31 reserved */
+};
 
-IPA_REG_STRIDE(ENDP_INIT_HOL_BLOCK_TIMER, endp_init_hol_block_timer,
-	       0x00000830, 0x0070);
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_AGGR, endp_init_aggr, 0x00000824, 0x0070);
+
+static const u32 ipa_reg_endp_init_hol_block_en_fmask[] = {
+	[HOL_BLOCK_EN]					= BIT(0),
+						/* Bits 1-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_HOL_BLOCK_EN, endp_init_hol_block_en,
+		      0x0000082c, 0x0070);
+
+static const u32 ipa_reg_endp_init_hol_block_timer_fmask[] = {
+	[TIMER_LIMIT]					= GENMASK(4, 0),
+						/* Bits 5-7 reserved */
+	[TIMER_GRAN_SEL]				= BIT(8),
+						/* Bits 9-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_HOL_BLOCK_TIMER, endp_init_hol_block_timer,
+		      0x00000830, 0x0070);
 
 IPA_REG_STRIDE(ENDP_INIT_DEAGGR, endp_init_deaggr, 0x00000834, 0x0070);
 
-- 
2.34.1

