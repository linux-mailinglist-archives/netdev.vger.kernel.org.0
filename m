Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9FE068F949
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 21:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232405AbjBHU6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 15:58:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232080AbjBHU6j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 15:58:39 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D4DE4DBD0
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 12:57:45 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id o13so33497ilt.4
        for <netdev@vger.kernel.org>; Wed, 08 Feb 2023 12:57:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MUN3kTgPmEqEZGQzRFKr0wDbbe3YIiIT8K5iN8MtK/Q=;
        b=UZbiBKKHhVsO0bFh0ybTd6QwKiDPssqX40n8Nta7ByOPgORida+nTOave2o2Xu0/L4
         gmFmVnzDY0hA9j5d420+pzdBUV+tmeeE2VZUryQKwydN3xgf/dPoS6IvehBFczFcoLs+
         KEt+S7KI7PmjWdzLS9LgwXSpoJ87rpeAHkfQeAYgIAOQ4f/sFMn3wvRGXk9XVTiZ56+f
         BZXum1XGX/CK9GBsU4982B6+xoy56HlnQfxaPxb5APJ9awiU6BW9qLumTUSkOvzmM4id
         /WXxLy7c9WybPfKQX5y0Ho9Xe55uC2mAIRd3moP/Zdyo2z8fo5ieSGosnwUNuPPQQ/TU
         W0hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MUN3kTgPmEqEZGQzRFKr0wDbbe3YIiIT8K5iN8MtK/Q=;
        b=5km/ttFApdvrtyYd9m4c9n0ByfOVXo0m2TGhIoy+z7py+7vxarGaQ+ZuK6ROXfzmOK
         uaTNi/vuxTmiLx2pKR/yfwo0GQB+r6dKgK/dS4fjn616ebggn3+YfWaj7Q4WQs2KLUD+
         SGJ5Nj0IwdzgB1r9ysJkHofmR7hTfWqtWjKgrWSHJKi5g5dX7ylh2KT4JNeoiMPhTHK9
         G8WqgLFd0NJAb5Hiw+r9Z+uNjRgMKQsAaDxd/WUWSbw3dPkXlRgXL/zjWU7/+RRQ6VmX
         hkpewUB4ZzHrSS9LFeeuBnKMovy3Zq/xxRP/XwlFjGzUeQuq2VVyiRYVaIZG+grosjxz
         D9GQ==
X-Gm-Message-State: AO0yUKU0xh5iYLwASZ+ePs+Yq1aabEpzZ37tWW6T/NSecuNxyIQwMRiC
        XbkzN9/IgGR0W5oLpiIhZM3QRw==
X-Google-Smtp-Source: AK7set+34NQmhXSq2Q9qiwyHRgQL8nVAY1+HVGYTsuEV2VnklGCElYfuz1Tzv2xujIOxl5AH6VUzHQ==
X-Received: by 2002:a05:6e02:216c:b0:313:ee3f:2b2b with SMTP id s12-20020a056e02216c00b00313ee3f2b2bmr4953079ilv.8.1675889864991;
        Wed, 08 Feb 2023 12:57:44 -0800 (PST)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id r6-20020a922a06000000b0031093e9c7fasm5236704ile.85.2023.02.08.12.57.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 12:57:32 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 9/9] net: ipa: generalize register field functions
Date:   Wed,  8 Feb 2023 14:56:53 -0600
Message-Id: <20230208205653.177700-10-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230208205653.177700-1-elder@linaro.org>
References: <20230208205653.177700-1-elder@linaro.org>
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

Rename functions related to register fields so they don't appear to
be IPA-specific, and move their definitions into "reg.h":
    ipa_reg_fmask()	-> reg_fmask()
    ipa_reg_bit()	-> reg_bit()
    ipa_reg_field_max()	-> reg_field_max()
    ipa_reg_encode()	-> reg_encode()
    ipa_reg_decode()	-> reg_decode()

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 119 ++++++++++++++++-----------------
 drivers/net/ipa/ipa_main.c     |  68 +++++++++----------
 drivers/net/ipa/ipa_mem.c      |   6 +-
 drivers/net/ipa/ipa_reg.h      |  56 +---------------
 drivers/net/ipa/ipa_resource.c |   8 +--
 drivers/net/ipa/ipa_table.c    |  16 ++---
 drivers/net/ipa/ipa_uc.c       |   2 +-
 drivers/net/ipa/reg.h          |  51 ++++++++++++++
 8 files changed, 161 insertions(+), 165 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index b78503304883d..2ee80ed140b72 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -304,7 +304,7 @@ static bool ipa_endpoint_data_valid_one(struct ipa *ipa, u32 count,
 					     rx_config->aggr_hard_limit);
 		reg = ipa_reg(ipa, ENDP_INIT_AGGR);
 
-		limit = ipa_reg_field_max(reg, BYTE_LIMIT);
+		limit = reg_field_max(reg, BYTE_LIMIT);
 		if (aggr_size > limit) {
 			dev_err(dev, "aggregated size too large for RX endpoint %u (%u KB > %u KB)\n",
 				data->endpoint_id, aggr_size, limit);
@@ -464,7 +464,7 @@ ipa_endpoint_init_ctrl(struct ipa_endpoint *endpoint, bool suspend_delay)
 	val = ioread32(ipa->reg_virt + offset);
 
 	field_id = endpoint->toward_ipa ? ENDP_DELAY : ENDP_SUSPEND;
-	mask = ipa_reg_bit(reg, field_id);
+	mask = reg_bit(reg, field_id);
 
 	state = !!(val & mask);
 
@@ -658,7 +658,7 @@ static void ipa_endpoint_init_cfg(struct ipa_endpoint *endpoint)
 
 			/* Checksum header offset is in 4-byte units */
 			off = sizeof(struct rmnet_map_header) / sizeof(u32);
-			val |= ipa_reg_encode(reg, CS_METADATA_HDR_OFFSET, off);
+			val |= reg_encode(reg, CS_METADATA_HDR_OFFSET, off);
 
 			enabled = version < IPA_VERSION_4_5
 					? IPA_CS_OFFLOAD_UL
@@ -671,7 +671,7 @@ static void ipa_endpoint_init_cfg(struct ipa_endpoint *endpoint)
 	} else {
 		enabled = IPA_CS_OFFLOAD_NONE;
 	}
-	val |= ipa_reg_encode(reg, CS_OFFLOAD_EN, enabled);
+	val |= reg_encode(reg, CS_OFFLOAD_EN, enabled);
 	/* CS_GEN_QMB_MASTER_SEL is 0 */
 
 	iowrite32(val, ipa->reg_virt + reg_n_offset(reg, endpoint_id));
@@ -688,7 +688,7 @@ static void ipa_endpoint_init_nat(struct ipa_endpoint *endpoint)
 		return;
 
 	reg = ipa_reg(ipa, ENDP_INIT_NAT);
-	val = ipa_reg_encode(reg, NAT_EN, IPA_NAT_TYPE_BYPASS);
+	val = reg_encode(reg, NAT_EN, IPA_NAT_TYPE_BYPASS);
 
 	iowrite32(val, ipa->reg_virt + reg_n_offset(reg, endpoint_id));
 }
@@ -718,11 +718,11 @@ ipa_qmap_header_size(enum ipa_version version, struct ipa_endpoint *endpoint)
 static u32 ipa_header_size_encode(enum ipa_version version,
 				  const struct reg *reg, u32 header_size)
 {
-	u32 field_max = ipa_reg_field_max(reg, HDR_LEN);
+	u32 field_max = reg_field_max(reg, HDR_LEN);
 	u32 val;
 
 	/* We know field_max can be used as a mask (2^n - 1) */
-	val = ipa_reg_encode(reg, HDR_LEN, header_size & field_max);
+	val = reg_encode(reg, HDR_LEN, header_size & field_max);
 	if (version < IPA_VERSION_4_5) {
 		WARN_ON(header_size > field_max);
 		return val;
@@ -730,8 +730,8 @@ static u32 ipa_header_size_encode(enum ipa_version version,
 
 	/* IPA v4.5 adds a few more most-significant bits */
 	header_size >>= hweight32(field_max);
-	WARN_ON(header_size > ipa_reg_field_max(reg, HDR_LEN_MSB));
-	val |= ipa_reg_encode(reg, HDR_LEN_MSB, header_size);
+	WARN_ON(header_size > reg_field_max(reg, HDR_LEN_MSB));
+	val |= reg_encode(reg, HDR_LEN_MSB, header_size);
 
 	return val;
 }
@@ -740,11 +740,11 @@ static u32 ipa_header_size_encode(enum ipa_version version,
 static u32 ipa_metadata_offset_encode(enum ipa_version version,
 				      const struct reg *reg, u32 offset)
 {
-	u32 field_max = ipa_reg_field_max(reg, HDR_OFST_METADATA);
+	u32 field_max = reg_field_max(reg, HDR_OFST_METADATA);
 	u32 val;
 
 	/* We know field_max can be used as a mask (2^n - 1) */
-	val = ipa_reg_encode(reg, HDR_OFST_METADATA, offset);
+	val = reg_encode(reg, HDR_OFST_METADATA, offset);
 	if (version < IPA_VERSION_4_5) {
 		WARN_ON(offset > field_max);
 		return val;
@@ -752,8 +752,8 @@ static u32 ipa_metadata_offset_encode(enum ipa_version version,
 
 	/* IPA v4.5 adds a few more most-significant bits */
 	offset >>= hweight32(field_max);
-	WARN_ON(offset > ipa_reg_field_max(reg, HDR_OFST_METADATA_MSB));
-	val |= ipa_reg_encode(reg, HDR_OFST_METADATA_MSB, offset);
+	WARN_ON(offset > reg_field_max(reg, HDR_OFST_METADATA_MSB));
+	val |= reg_encode(reg, HDR_OFST_METADATA_MSB, offset);
 
 	return val;
 }
@@ -806,13 +806,13 @@ static void ipa_endpoint_init_hdr(struct ipa_endpoint *endpoint)
 			off = offsetof(struct rmnet_map_header, pkt_len);
 			/* Upper bits are stored in HDR_EXT with IPA v4.5 */
 			if (version >= IPA_VERSION_4_5)
-				off &= ipa_reg_field_max(reg, HDR_OFST_PKT_SIZE);
+				off &= reg_field_max(reg, HDR_OFST_PKT_SIZE);
 
-			val |= ipa_reg_bit(reg, HDR_OFST_PKT_SIZE_VALID);
-			val |= ipa_reg_encode(reg, HDR_OFST_PKT_SIZE, off);
+			val |= reg_bit(reg, HDR_OFST_PKT_SIZE_VALID);
+			val |= reg_encode(reg, HDR_OFST_PKT_SIZE, off);
 		}
 		/* For QMAP TX, metadata offset is 0 (modem assumes this) */
-		val |= ipa_reg_bit(reg, HDR_OFST_METADATA_VALID);
+		val |= reg_bit(reg, HDR_OFST_METADATA_VALID);
 
 		/* HDR_ADDITIONAL_CONST_LEN is 0; (RX only) */
 		/* HDR_A5_MUX is 0 */
@@ -834,7 +834,7 @@ static void ipa_endpoint_init_hdr_ext(struct ipa_endpoint *endpoint)
 	reg = ipa_reg(ipa, ENDP_INIT_HDR_EXT);
 	if (endpoint->config.qmap) {
 		/* We have a header, so we must specify its endianness */
-		val |= ipa_reg_bit(reg, HDR_ENDIANNESS);	/* big endian */
+		val |= reg_bit(reg, HDR_ENDIANNESS);	/* big endian */
 
 		/* A QMAP header contains a 6 bit pad field at offset 0.
 		 * The RMNet driver assumes this field is meaningful in
@@ -844,16 +844,16 @@ static void ipa_endpoint_init_hdr_ext(struct ipa_endpoint *endpoint)
 		 * (although 0) should be ignored.
 		 */
 		if (!endpoint->toward_ipa) {
-			val |= ipa_reg_bit(reg, HDR_TOTAL_LEN_OR_PAD_VALID);
+			val |= reg_bit(reg, HDR_TOTAL_LEN_OR_PAD_VALID);
 			/* HDR_TOTAL_LEN_OR_PAD is 0 (pad, not total_len) */
-			val |= ipa_reg_bit(reg, HDR_PAYLOAD_LEN_INC_PADDING);
+			val |= reg_bit(reg, HDR_PAYLOAD_LEN_INC_PADDING);
 			/* HDR_TOTAL_LEN_OR_PAD_OFFSET is 0 */
 		}
 	}
 
 	/* HDR_PAYLOAD_LEN_INC_PADDING is 0 */
 	if (!endpoint->toward_ipa)
-		val |= ipa_reg_encode(reg, HDR_PAD_TO_ALIGNMENT, pad_align);
+		val |= reg_encode(reg, HDR_PAD_TO_ALIGNMENT, pad_align);
 
 	/* IPA v4.5 adds some most-significant bits to a few fields,
 	 * two of which are defined in the HDR (not HDR_EXT) register.
@@ -861,13 +861,13 @@ static void ipa_endpoint_init_hdr_ext(struct ipa_endpoint *endpoint)
 	if (ipa->version >= IPA_VERSION_4_5) {
 		/* HDR_TOTAL_LEN_OR_PAD_OFFSET is 0, so MSB is 0 */
 		if (endpoint->config.qmap && !endpoint->toward_ipa) {
-			u32 mask = ipa_reg_field_max(reg, HDR_OFST_PKT_SIZE);
+			u32 mask = reg_field_max(reg, HDR_OFST_PKT_SIZE);
 			u32 off;     /* Field offset within header */
 
 			off = offsetof(struct rmnet_map_header, pkt_len);
 			/* Low bits are in the ENDP_INIT_HDR register */
 			off >>= hweight32(mask);
-			val |= ipa_reg_encode(reg, HDR_OFST_PKT_SIZE_MSB, off);
+			val |= reg_encode(reg, HDR_OFST_PKT_SIZE_MSB, off);
 			/* HDR_ADDITIONAL_CONST_LEN is 0 so MSB is 0 */
 		}
 	}
@@ -911,10 +911,10 @@ static void ipa_endpoint_init_mode(struct ipa_endpoint *endpoint)
 		enum ipa_endpoint_name name = endpoint->config.dma_endpoint;
 		u32 dma_endpoint_id = ipa->name_map[name]->endpoint_id;
 
-		val = ipa_reg_encode(reg, ENDP_MODE, IPA_DMA);
-		val |= ipa_reg_encode(reg, DEST_PIPE_INDEX, dma_endpoint_id);
+		val = reg_encode(reg, ENDP_MODE, IPA_DMA);
+		val |= reg_encode(reg, DEST_PIPE_INDEX, dma_endpoint_id);
 	} else {
-		val = ipa_reg_encode(reg, ENDP_MODE, IPA_BASIC);
+		val = reg_encode(reg, ENDP_MODE, IPA_BASIC);
 	}
 	/* All other bits unspecified (and 0) */
 
@@ -972,14 +972,14 @@ static u32 aggr_time_limit_encode(struct ipa *ipa, const struct reg *reg,
 	if (!microseconds)
 		return 0;	/* Nothing to compute if time limit is 0 */
 
-	max = ipa_reg_field_max(reg, TIME_LIMIT);
+	max = reg_field_max(reg, TIME_LIMIT);
 	if (ipa->version >= IPA_VERSION_4_5) {
 		u32 select;
 
 		ticks = ipa_qtime_val(ipa, microseconds, max, &select);
 
-		return ipa_reg_encode(reg, AGGR_GRAN_SEL, select) |
-		       ipa_reg_encode(reg, TIME_LIMIT, ticks);
+		return reg_encode(reg, AGGR_GRAN_SEL, select) |
+		       reg_encode(reg, TIME_LIMIT, ticks);
 	}
 
 	/* We program aggregation granularity in ipa_hardware_config() */
@@ -987,7 +987,7 @@ static u32 aggr_time_limit_encode(struct ipa *ipa, const struct reg *reg,
 	WARN(ticks > max, "aggr_time_limit too large (%u > %u usec)\n",
 	     microseconds, max * IPA_AGGR_GRANULARITY);
 
-	return ipa_reg_encode(reg, TIME_LIMIT, ticks);
+	return reg_encode(reg, TIME_LIMIT, ticks);
 }
 
 static void ipa_endpoint_init_aggr(struct ipa_endpoint *endpoint)
@@ -1005,13 +1005,13 @@ static void ipa_endpoint_init_aggr(struct ipa_endpoint *endpoint)
 			u32 limit;
 
 			rx_config = &endpoint->config.rx;
-			val |= ipa_reg_encode(reg, AGGR_EN, IPA_ENABLE_AGGR);
-			val |= ipa_reg_encode(reg, AGGR_TYPE, IPA_GENERIC);
+			val |= reg_encode(reg, AGGR_EN, IPA_ENABLE_AGGR);
+			val |= reg_encode(reg, AGGR_TYPE, IPA_GENERIC);
 
 			buffer_size = rx_config->buffer_size;
 			limit = ipa_aggr_size_kb(buffer_size - NET_SKB_PAD,
 						 rx_config->aggr_hard_limit);
-			val |= ipa_reg_encode(reg, BYTE_LIMIT, limit);
+			val |= reg_encode(reg, BYTE_LIMIT, limit);
 
 			limit = rx_config->aggr_time_limit;
 			val |= aggr_time_limit_encode(ipa, reg, limit);
@@ -1019,16 +1019,16 @@ static void ipa_endpoint_init_aggr(struct ipa_endpoint *endpoint)
 			/* AGGR_PKT_LIMIT is 0 (unlimited) */
 
 			if (rx_config->aggr_close_eof)
-				val |= ipa_reg_bit(reg, SW_EOF_ACTIVE);
+				val |= reg_bit(reg, SW_EOF_ACTIVE);
 		} else {
-			val |= ipa_reg_encode(reg, AGGR_EN, IPA_ENABLE_DEAGGR);
-			val |= ipa_reg_encode(reg, AGGR_TYPE, IPA_QCMAP);
+			val |= reg_encode(reg, AGGR_EN, IPA_ENABLE_DEAGGR);
+			val |= reg_encode(reg, AGGR_TYPE, IPA_QCMAP);
 			/* other fields ignored */
 		}
 		/* AGGR_FORCE_CLOSE is 0 */
 		/* AGGR_GRAN_SEL is 0 for IPA v4.5 */
 	} else {
-		val |= ipa_reg_encode(reg, AGGR_EN, IPA_BYPASS_AGGR);
+		val |= reg_encode(reg, AGGR_EN, IPA_BYPASS_AGGR);
 		/* other fields ignored */
 	}
 
@@ -1057,14 +1057,14 @@ static u32 hol_block_timer_encode(struct ipa *ipa, const struct reg *reg,
 		return 0;	/* Nothing to compute if timer period is 0 */
 
 	if (ipa->version >= IPA_VERSION_4_5) {
-		u32 max = ipa_reg_field_max(reg, TIMER_LIMIT);
+		u32 max = reg_field_max(reg, TIMER_LIMIT);
 		u32 select;
 		u32 ticks;
 
 		ticks = ipa_qtime_val(ipa, microseconds, max, &select);
 
-		return ipa_reg_encode(reg, TIMER_GRAN_SEL, 1) |
-		       ipa_reg_encode(reg, TIMER_LIMIT, ticks);
+		return reg_encode(reg, TIMER_GRAN_SEL, 1) |
+		       reg_encode(reg, TIMER_LIMIT, ticks);
 	}
 
 	/* Use 64 bit arithmetic to avoid overflow */
@@ -1072,11 +1072,11 @@ static u32 hol_block_timer_encode(struct ipa *ipa, const struct reg *reg,
 	ticks = DIV_ROUND_CLOSEST(microseconds * rate, 128 * USEC_PER_SEC);
 
 	/* We still need the result to fit into the field */
-	WARN_ON(ticks > ipa_reg_field_max(reg, TIMER_BASE_VALUE));
+	WARN_ON(ticks > reg_field_max(reg, TIMER_BASE_VALUE));
 
 	/* IPA v3.5.1 through v4.1 just record the tick count */
 	if (ipa->version < IPA_VERSION_4_2)
-		return ipa_reg_encode(reg, TIMER_BASE_VALUE, (u32)ticks);
+		return reg_encode(reg, TIMER_BASE_VALUE, (u32)ticks);
 
 	/* For IPA v4.2, the tick count is represented by base and
 	 * scale fields within the 32-bit timer register, where:
@@ -1087,7 +1087,7 @@ static u32 hol_block_timer_encode(struct ipa *ipa, const struct reg *reg,
 	 * such that high bit is included.
 	 */
 	high = fls(ticks);		/* 1..32 (or warning above) */
-	width = hweight32(ipa_reg_fmask(reg, TIMER_BASE_VALUE));
+	width = hweight32(reg_fmask(reg, TIMER_BASE_VALUE));
 	scale = high > width ? high - width : 0;
 	if (scale) {
 		/* If we're scaling, round up to get a closer result */
@@ -1097,8 +1097,8 @@ static u32 hol_block_timer_encode(struct ipa *ipa, const struct reg *reg,
 			scale++;
 	}
 
-	val = ipa_reg_encode(reg, TIMER_SCALE, scale);
-	val |= ipa_reg_encode(reg, TIMER_BASE_VALUE, (u32)ticks >> scale);
+	val = reg_encode(reg, TIMER_SCALE, scale);
+	val |= reg_encode(reg, TIMER_BASE_VALUE, (u32)ticks >> scale);
 
 	return val;
 }
@@ -1130,7 +1130,7 @@ ipa_endpoint_init_hol_block_en(struct ipa_endpoint *endpoint, bool enable)
 
 	reg = ipa_reg(ipa, ENDP_INIT_HOL_BLOCK_EN);
 	offset = reg_n_offset(reg, endpoint_id);
-	val = enable ? ipa_reg_bit(reg, HOL_BLOCK_EN) : 0;
+	val = enable ? reg_bit(reg, HOL_BLOCK_EN) : 0;
 
 	iowrite32(val, ipa->reg_virt + offset);
 
@@ -1195,7 +1195,7 @@ static void ipa_endpoint_init_rsrc_grp(struct ipa_endpoint *endpoint)
 	u32 val;
 
 	reg = ipa_reg(ipa, ENDP_INIT_RSRC_GRP);
-	val = ipa_reg_encode(reg, ENDP_RSRC_GRP, resource_group);
+	val = reg_encode(reg, ENDP_RSRC_GRP, resource_group);
 
 	iowrite32(val, ipa->reg_virt + reg_n_offset(reg, endpoint_id));
 }
@@ -1213,12 +1213,12 @@ static void ipa_endpoint_init_seq(struct ipa_endpoint *endpoint)
 	reg = ipa_reg(ipa, ENDP_INIT_SEQ);
 
 	/* Low-order byte configures primary packet processing */
-	val = ipa_reg_encode(reg, SEQ_TYPE, endpoint->config.tx.seq_type);
+	val = reg_encode(reg, SEQ_TYPE, endpoint->config.tx.seq_type);
 
 	/* Second byte (if supported) configures replicated packet processing */
 	if (ipa->version < IPA_VERSION_4_5)
-		val |= ipa_reg_encode(reg, SEQ_REP_TYPE,
-				      endpoint->config.tx.seq_rep_type);
+		val |= reg_encode(reg, SEQ_REP_TYPE,
+				  endpoint->config.tx.seq_rep_type);
 
 	iowrite32(val, ipa->reg_virt + reg_n_offset(reg, endpoint_id));
 }
@@ -1275,7 +1275,7 @@ static void ipa_endpoint_status(struct ipa_endpoint *endpoint)
 
 	reg = ipa_reg(ipa, ENDP_STATUS);
 	if (endpoint->config.status_enable) {
-		val |= ipa_reg_bit(reg, STATUS_EN);
+		val |= reg_bit(reg, STATUS_EN);
 		if (endpoint->toward_ipa) {
 			enum ipa_endpoint_name name;
 			u32 status_endpoint_id;
@@ -1283,8 +1283,7 @@ static void ipa_endpoint_status(struct ipa_endpoint *endpoint)
 			name = endpoint->config.tx.status_endpoint;
 			status_endpoint_id = ipa->name_map[name]->endpoint_id;
 
-			val |= ipa_reg_encode(reg, STATUS_ENDP,
-					      status_endpoint_id);
+			val |= reg_encode(reg, STATUS_ENDP, status_endpoint_id);
 		}
 		/* STATUS_LOCATION is 0, meaning IPA packet status
 		 * precedes the packet (not present for IPA v4.5+)
@@ -1641,11 +1640,11 @@ void ipa_endpoint_default_route_set(struct ipa *ipa, u32 endpoint_id)
 
 	reg = ipa_reg(ipa, ROUTE);
 	/* ROUTE_DIS is 0 */
-	val = ipa_reg_encode(reg, ROUTE_DEF_PIPE, endpoint_id);
-	val |= ipa_reg_bit(reg, ROUTE_DEF_HDR_TABLE);
+	val = reg_encode(reg, ROUTE_DEF_PIPE, endpoint_id);
+	val |= reg_bit(reg, ROUTE_DEF_HDR_TABLE);
 	/* ROUTE_DEF_HDR_OFST is 0 */
-	val |= ipa_reg_encode(reg, ROUTE_FRAG_DEF_PIPE, endpoint_id);
-	val |= ipa_reg_bit(reg, ROUTE_DEF_RETAIN_HDR);
+	val |= reg_encode(reg, ROUTE_FRAG_DEF_PIPE, endpoint_id);
+	val |= reg_bit(reg, ROUTE_DEF_RETAIN_HDR);
 
 	iowrite32(val, ipa->reg_virt + reg_offset(reg));
 }
@@ -2022,9 +2021,9 @@ int ipa_endpoint_config(struct ipa *ipa)
 	val = ioread32(ipa->reg_virt + reg_offset(reg));
 
 	/* Our RX is an IPA producer; our TX is an IPA consumer. */
-	tx_count = ipa_reg_decode(reg, MAX_CONS_PIPES, val);
-	rx_count = ipa_reg_decode(reg, MAX_PROD_PIPES, val);
-	rx_base = ipa_reg_decode(reg, PROD_LOWEST, val);
+	tx_count = reg_decode(reg, MAX_CONS_PIPES, val);
+	rx_count = reg_decode(reg, MAX_PROD_PIPES, val);
+	rx_base = reg_decode(reg, PROD_LOWEST, val);
 
 	limit = rx_base + rx_count;
 	if (limit > IPA_ENDPOINT_MAX) {
diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index c74543db0afb1..6cb7bf96a6269 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -231,7 +231,7 @@ static void ipa_hardware_config_tx(struct ipa *ipa)
 
 	val = ioread32(ipa->reg_virt + offset);
 
-	val &= ~ipa_reg_bit(reg, PA_MASK_EN);
+	val &= ~reg_bit(reg, PA_MASK_EN);
 
 	iowrite32(val, ipa->reg_virt + offset);
 }
@@ -252,11 +252,11 @@ static void ipa_hardware_config_clkon(struct ipa *ipa)
 	reg = ipa_reg(ipa, CLKON_CFG);
 	if (version == IPA_VERSION_3_1) {
 		/* Disable MISC clock gating */
-		val = ipa_reg_bit(reg, CLKON_MISC);
+		val = reg_bit(reg, CLKON_MISC);
 	} else {	/* IPA v4.0+ */
 		/* Enable open global clocks in the CLKON configuration */
-		val = ipa_reg_bit(reg, CLKON_GLOBAL);
-		val |= ipa_reg_bit(reg, GLOBAL_2X_CLK);
+		val = reg_bit(reg, CLKON_GLOBAL);
+		val |= reg_bit(reg, GLOBAL_2X_CLK);
 	}
 
 	iowrite32(val, ipa->reg_virt + reg_offset(reg));
@@ -279,17 +279,17 @@ static void ipa_hardware_config_comp(struct ipa *ipa)
 	val = ioread32(ipa->reg_virt + offset);
 
 	if (ipa->version == IPA_VERSION_4_0) {
-		val &= ~ipa_reg_bit(reg, IPA_QMB_SELECT_CONS_EN);
-		val &= ~ipa_reg_bit(reg, IPA_QMB_SELECT_PROD_EN);
-		val &= ~ipa_reg_bit(reg, IPA_QMB_SELECT_GLOBAL_EN);
+		val &= ~reg_bit(reg, IPA_QMB_SELECT_CONS_EN);
+		val &= ~reg_bit(reg, IPA_QMB_SELECT_PROD_EN);
+		val &= ~reg_bit(reg, IPA_QMB_SELECT_GLOBAL_EN);
 	} else if (ipa->version < IPA_VERSION_4_5) {
-		val |= ipa_reg_bit(reg, GSI_MULTI_AXI_MASTERS_DIS);
+		val |= reg_bit(reg, GSI_MULTI_AXI_MASTERS_DIS);
 	} else {
 		/* For IPA v4.5 FULL_FLUSH_WAIT_RS_CLOSURE_EN is 0 */
 	}
 
-	val |= ipa_reg_bit(reg, GSI_MULTI_INORDER_RD_DIS);
-	val |= ipa_reg_bit(reg, GSI_MULTI_INORDER_WR_DIS);
+	val |= reg_bit(reg, GSI_MULTI_INORDER_RD_DIS);
+	val |= reg_bit(reg, GSI_MULTI_INORDER_WR_DIS);
 
 	iowrite32(val, ipa->reg_virt + offset);
 }
@@ -311,26 +311,24 @@ ipa_hardware_config_qsb(struct ipa *ipa, const struct ipa_data *data)
 	/* Max outstanding write accesses for QSB masters */
 	reg = ipa_reg(ipa, QSB_MAX_WRITES);
 
-	val = ipa_reg_encode(reg, GEN_QMB_0_MAX_WRITES, data0->max_writes);
+	val = reg_encode(reg, GEN_QMB_0_MAX_WRITES, data0->max_writes);
 	if (data->qsb_count > 1)
-		val |= ipa_reg_encode(reg, GEN_QMB_1_MAX_WRITES,
-				      data1->max_writes);
+		val |= reg_encode(reg, GEN_QMB_1_MAX_WRITES, data1->max_writes);
 
 	iowrite32(val, ipa->reg_virt + reg_offset(reg));
 
 	/* Max outstanding read accesses for QSB masters */
 	reg = ipa_reg(ipa, QSB_MAX_READS);
 
-	val = ipa_reg_encode(reg, GEN_QMB_0_MAX_READS, data0->max_reads);
+	val = reg_encode(reg, GEN_QMB_0_MAX_READS, data0->max_reads);
 	if (ipa->version >= IPA_VERSION_4_0)
-		val |= ipa_reg_encode(reg, GEN_QMB_0_MAX_READS_BEATS,
-				      data0->max_reads_beats);
+		val |= reg_encode(reg, GEN_QMB_0_MAX_READS_BEATS,
+				  data0->max_reads_beats);
 	if (data->qsb_count > 1) {
-		val = ipa_reg_encode(reg, GEN_QMB_1_MAX_READS,
-				     data1->max_reads);
+		val = reg_encode(reg, GEN_QMB_1_MAX_READS, data1->max_reads);
 		if (ipa->version >= IPA_VERSION_4_0)
-			val |= ipa_reg_encode(reg, GEN_QMB_1_MAX_READS_BEATS,
-					      data1->max_reads_beats);
+			val |= reg_encode(reg, GEN_QMB_1_MAX_READS_BEATS,
+					  data1->max_reads_beats);
 	}
 
 	iowrite32(val, ipa->reg_virt + reg_offset(reg));
@@ -379,23 +377,23 @@ static void ipa_qtime_config(struct ipa *ipa)
 
 	reg = ipa_reg(ipa, QTIME_TIMESTAMP_CFG);
 	/* Set DPL time stamp resolution to use Qtime (instead of 1 msec) */
-	val = ipa_reg_encode(reg, DPL_TIMESTAMP_LSB, DPL_TIMESTAMP_SHIFT);
-	val |= ipa_reg_bit(reg, DPL_TIMESTAMP_SEL);
+	val = reg_encode(reg, DPL_TIMESTAMP_LSB, DPL_TIMESTAMP_SHIFT);
+	val |= reg_bit(reg, DPL_TIMESTAMP_SEL);
 	/* Configure tag and NAT Qtime timestamp resolution as well */
-	val = ipa_reg_encode(reg, TAG_TIMESTAMP_LSB, TAG_TIMESTAMP_SHIFT);
-	val = ipa_reg_encode(reg, NAT_TIMESTAMP_LSB, NAT_TIMESTAMP_SHIFT);
+	val = reg_encode(reg, TAG_TIMESTAMP_LSB, TAG_TIMESTAMP_SHIFT);
+	val = reg_encode(reg, NAT_TIMESTAMP_LSB, NAT_TIMESTAMP_SHIFT);
 
 	iowrite32(val, ipa->reg_virt + reg_offset(reg));
 
 	/* Set granularity of pulse generators used for other timers */
 	reg = ipa_reg(ipa, TIMERS_PULSE_GRAN_CFG);
-	val = ipa_reg_encode(reg, PULSE_GRAN_0, IPA_GRAN_100_US);
-	val |= ipa_reg_encode(reg, PULSE_GRAN_1, IPA_GRAN_1_MS);
+	val = reg_encode(reg, PULSE_GRAN_0, IPA_GRAN_100_US);
+	val |= reg_encode(reg, PULSE_GRAN_1, IPA_GRAN_1_MS);
 	if (ipa->version >= IPA_VERSION_5_0) {
-		val |= ipa_reg_encode(reg, PULSE_GRAN_2, IPA_GRAN_10_MS);
-		val |= ipa_reg_encode(reg, PULSE_GRAN_3, IPA_GRAN_10_MS);
+		val |= reg_encode(reg, PULSE_GRAN_2, IPA_GRAN_10_MS);
+		val |= reg_encode(reg, PULSE_GRAN_3, IPA_GRAN_10_MS);
 	} else {
-		val |= ipa_reg_encode(reg, PULSE_GRAN_2, IPA_GRAN_1_MS);
+		val |= reg_encode(reg, PULSE_GRAN_2, IPA_GRAN_1_MS);
 	}
 
 	iowrite32(val, ipa->reg_virt + reg_offset(reg));
@@ -404,12 +402,12 @@ static void ipa_qtime_config(struct ipa *ipa)
 	reg = ipa_reg(ipa, TIMERS_XO_CLK_DIV_CFG);
 	offset = reg_offset(reg);
 
-	val = ipa_reg_encode(reg, DIV_VALUE, IPA_XO_CLOCK_DIVIDER - 1);
+	val = reg_encode(reg, DIV_VALUE, IPA_XO_CLOCK_DIVIDER - 1);
 
 	iowrite32(val, ipa->reg_virt + offset);
 
 	/* Divider value is set; re-enable the common timer clock divider */
-	val |= ipa_reg_bit(reg, DIV_ENABLE);
+	val |= reg_bit(reg, DIV_ENABLE);
 
 	iowrite32(val, ipa->reg_virt + offset);
 }
@@ -423,7 +421,7 @@ static void ipa_hardware_config_counter(struct ipa *ipa)
 
 	reg = ipa_reg(ipa, COUNTER_CFG);
 	/* If defined, EOT_COAL_GRANULARITY is 0 */
-	val = ipa_reg_encode(reg, AGGR_GRANULARITY, granularity);
+	val = reg_encode(reg, AGGR_GRANULARITY, granularity);
 	iowrite32(val, ipa->reg_virt + reg_offset(reg));
 }
 
@@ -467,10 +465,10 @@ static void ipa_idle_indication_cfg(struct ipa *ipa,
 		return;
 
 	reg = ipa_reg(ipa, IDLE_INDICATION_CFG);
-	val = ipa_reg_encode(reg, ENTER_IDLE_DEBOUNCE_THRESH,
-			     enter_idle_debounce_thresh);
+	val = reg_encode(reg, ENTER_IDLE_DEBOUNCE_THRESH,
+			 enter_idle_debounce_thresh);
 	if (const_non_idle_enable)
-		val |= ipa_reg_bit(reg, CONST_NON_IDLE_ENABLE);
+		val |= reg_bit(reg, CONST_NON_IDLE_ENABLE);
 
 	iowrite32(val, ipa->reg_virt + reg_offset(reg));
 }
diff --git a/drivers/net/ipa/ipa_mem.c b/drivers/net/ipa/ipa_mem.c
index 20241fac21be5..85096d1efe5b0 100644
--- a/drivers/net/ipa/ipa_mem.c
+++ b/drivers/net/ipa/ipa_mem.c
@@ -115,7 +115,7 @@ int ipa_mem_setup(struct ipa *ipa)
 	offset = ipa->mem_offset + mem->offset;
 
 	reg = ipa_reg(ipa, LOCAL_PKT_PROC_CNTXT);
-	val = ipa_reg_encode(reg, IPA_BASE_ADDR, offset);
+	val = reg_encode(reg, IPA_BASE_ADDR, offset);
 	iowrite32(val, ipa->reg_virt + reg_offset(reg));
 
 	return 0;
@@ -331,10 +331,10 @@ int ipa_mem_config(struct ipa *ipa)
 	val = ioread32(ipa->reg_virt + reg_offset(reg));
 
 	/* The fields in the register are in 8 byte units */
-	ipa->mem_offset = 8 * ipa_reg_decode(reg, MEM_BADDR, val);
+	ipa->mem_offset = 8 * reg_decode(reg, MEM_BADDR, val);
 
 	/* Make sure the end is within the region's mapped space */
-	mem_size = 8 * ipa_reg_decode(reg, MEM_SIZE, val);
+	mem_size = 8 * reg_decode(reg, MEM_SIZE, val);
 
 	/* If the sizes don't match, issue a warning */
 	if (ipa->mem_offset + mem_size < ipa->mem_size) {
diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
index e0f125d70ff27..28aa1351dd488 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -45,9 +45,9 @@ struct ipa;
  * an array of field masks, indexed by field ID.  Two functions are
  * used to access register fields; both take an ipa_reg structure as
  * argument.  To encode a value to be represented in a register field,
- * the value and field ID are passed to ipa_reg_encode().  To extract
+ * the value and field ID are passed to reg_encode().  To extract
  * a value encoded in a register field, the field ID is passed to
- * ipa_reg_decode().  In addition, for single-bit fields, ipa_reg_bit()
+ * reg_decode().  In addition, for single-bit fields, reg_bit()
  * can be used to either encode the bit value, or to generate a mask
  * used to extract the bit value.
  */
@@ -646,58 +646,6 @@ extern const struct regs ipa_regs_v4_7;
 extern const struct regs ipa_regs_v4_9;
 extern const struct regs ipa_regs_v4_11;
 
-/* Return the field mask for a field in a register */
-static inline u32 ipa_reg_fmask(const struct reg *reg, u32 field_id)
-{
-	if (!reg || WARN_ON(field_id >= reg->fcount))
-		return 0;
-
-	return reg->fmask[field_id];
-}
-
-/* Return the mask for a single-bit field in a register */
-static inline u32 ipa_reg_bit(const struct reg *reg, u32 field_id)
-{
-	u32 fmask = ipa_reg_fmask(reg, field_id);
-
-	WARN_ON(!is_power_of_2(fmask));
-
-	return fmask;
-}
-
-/* Encode a value into the given field of a register */
-static inline u32
-ipa_reg_encode(const struct reg *reg, u32 field_id, u32 val)
-{
-	u32 fmask = ipa_reg_fmask(reg, field_id);
-
-	if (!fmask)
-		return 0;
-
-	val <<= __ffs(fmask);
-	if (WARN_ON(val & ~fmask))
-		return 0;
-
-	return val;
-}
-
-/* Given a register value, decode (extract) the value in the given field */
-static inline u32
-ipa_reg_decode(const struct reg *reg, u32 field_id, u32 val)
-{
-	u32 fmask = ipa_reg_fmask(reg, field_id);
-
-	return fmask ? (val & fmask) >> __ffs(fmask) : 0;
-}
-
-/* Return the maximum value representable by the given field; always 2^n - 1 */
-static inline u32 ipa_reg_field_max(const struct reg *reg, u32 field_id)
-{
-	u32 fmask = ipa_reg_fmask(reg, field_id);
-
-	return fmask ? fmask >> __ffs(fmask) : 0;
-}
-
 const struct reg *ipa_reg(struct ipa *ipa, enum ipa_reg_id reg_id);
 
 int ipa_reg_init(struct ipa *ipa);
diff --git a/drivers/net/ipa/ipa_resource.c b/drivers/net/ipa/ipa_resource.c
index b63f130350d59..82c88a744d102 100644
--- a/drivers/net/ipa/ipa_resource.c
+++ b/drivers/net/ipa/ipa_resource.c
@@ -76,11 +76,11 @@ ipa_resource_config_common(struct ipa *ipa, u32 resource_type,
 {
 	u32 val;
 
-	val = ipa_reg_encode(reg, X_MIN_LIM, xlimits->min);
-	val |= ipa_reg_encode(reg, X_MAX_LIM, xlimits->max);
+	val = reg_encode(reg, X_MIN_LIM, xlimits->min);
+	val |= reg_encode(reg, X_MAX_LIM, xlimits->max);
 	if (ylimits) {
-		val |= ipa_reg_encode(reg, Y_MIN_LIM, ylimits->min);
-		val |= ipa_reg_encode(reg, Y_MAX_LIM, ylimits->max);
+		val |= reg_encode(reg, Y_MIN_LIM, ylimits->min);
+		val |= reg_encode(reg, Y_MAX_LIM, ylimits->max);
 	}
 
 	iowrite32(val, ipa->reg_virt + reg_n_offset(reg, resource_type));
diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
index 54327c9f48275..f0529c31d0b6e 100644
--- a/drivers/net/ipa/ipa_table.c
+++ b/drivers/net/ipa/ipa_table.c
@@ -361,16 +361,16 @@ int ipa_table_hash_flush(struct ipa *ipa)
 	if (ipa->version < IPA_VERSION_5_0) {
 		reg = ipa_reg(ipa, FILT_ROUT_HASH_FLUSH);
 
-		val = ipa_reg_bit(reg, IPV6_ROUTER_HASH);
-		val |= ipa_reg_bit(reg, IPV6_FILTER_HASH);
-		val |= ipa_reg_bit(reg, IPV4_ROUTER_HASH);
-		val |= ipa_reg_bit(reg, IPV4_FILTER_HASH);
+		val = reg_bit(reg, IPV6_ROUTER_HASH);
+		val |= reg_bit(reg, IPV6_FILTER_HASH);
+		val |= reg_bit(reg, IPV4_ROUTER_HASH);
+		val |= reg_bit(reg, IPV4_FILTER_HASH);
 	} else {
 		reg = ipa_reg(ipa, FILT_ROUT_CACHE_FLUSH);
 
 		/* IPA v5.0+ uses a unified cache (both IPv4 and IPv6) */
-		val = ipa_reg_bit(reg, ROUTER_CACHE);
-		val |= ipa_reg_bit(reg, FILTER_CACHE);
+		val = reg_bit(reg, ROUTER_CACHE);
+		val |= reg_bit(reg, FILTER_CACHE);
 	}
 
 	ipa_cmd_register_write_add(trans, reg_offset(reg), val, val, false);
@@ -503,7 +503,7 @@ static void ipa_filter_tuple_zero(struct ipa_endpoint *endpoint)
 		val = ioread32(endpoint->ipa->reg_virt + offset);
 
 		/* Zero all filter-related fields, preserving the rest */
-		val &= ~ipa_reg_fmask(reg, FILTER_HASH_MSK_ALL);
+		val &= ~reg_fmask(reg, FILTER_HASH_MSK_ALL);
 	} else {
 		/* IPA v5.0 separates filter and router cache configuration */
 		reg = ipa_reg(ipa, ENDP_FILTER_CACHE_CFG);
@@ -562,7 +562,7 @@ static void ipa_route_tuple_zero(struct ipa *ipa, u32 route_id)
 		val = ioread32(ipa->reg_virt + offset);
 
 		/* Zero all route-related fields, preserving the rest */
-		val &= ~ipa_reg_fmask(reg, ROUTER_HASH_MSK_ALL);
+		val &= ~reg_fmask(reg, ROUTER_HASH_MSK_ALL);
 	} else {
 		/* IPA v5.0 separates filter and router cache configuration */
 		reg = ipa_reg(ipa, ENDP_ROUTER_CACHE_CFG);
diff --git a/drivers/net/ipa/ipa_uc.c b/drivers/net/ipa/ipa_uc.c
index 54ee0a106f35c..7eaa0b4ebed92 100644
--- a/drivers/net/ipa/ipa_uc.c
+++ b/drivers/net/ipa/ipa_uc.c
@@ -243,7 +243,7 @@ static void send_uc_command(struct ipa *ipa, u32 command, u32 command_param)
 
 	/* Use an interrupt to tell the microcontroller the command is ready */
 	reg = ipa_reg(ipa, IPA_IRQ_UC);
-	val = ipa_reg_bit(reg, UC_INTR);
+	val = reg_bit(reg, UC_INTR);
 
 	iowrite32(val, ipa->reg_virt + reg_offset(reg));
 }
diff --git a/drivers/net/ipa/reg.h b/drivers/net/ipa/reg.h
index 3c09e66b34a18..57b457f39b6e2 100644
--- a/drivers/net/ipa/reg.h
+++ b/drivers/net/ipa/reg.h
@@ -67,6 +67,57 @@ static inline const struct reg *reg(const struct regs *regs, u32 reg_id)
 	return regs->reg[reg_id];
 }
 
+/* Return the field mask for a field in a register, or 0 on error */
+static inline u32 reg_fmask(const struct reg *reg, u32 field_id)
+{
+	if (!reg || WARN_ON(field_id >= reg->fcount))
+		return 0;
+
+	return reg->fmask[field_id];
+}
+
+/* Return the mask for a single-bit field in a register, or 0 on error  */
+static inline u32 reg_bit(const struct reg *reg, u32 field_id)
+{
+	u32 fmask = reg_fmask(reg, field_id);
+
+	if (WARN_ON(!is_power_of_2(fmask)))
+		return 0;
+
+	return fmask;
+}
+
+/* Return the maximum value representable by the given field; always 2^n - 1 */
+static inline u32 reg_field_max(const struct reg *reg, u32 field_id)
+{
+	u32 fmask = reg_fmask(reg, field_id);
+
+	return fmask ? fmask >> __ffs(fmask) : 0;
+}
+
+/* Encode a value into the given field of a register */
+static inline u32 reg_encode(const struct reg *reg, u32 field_id, u32 val)
+{
+	u32 fmask = reg_fmask(reg, field_id);
+
+	if (!fmask)
+		return 0;
+
+	val <<= __ffs(fmask);
+	if (WARN_ON(val & ~fmask))
+		return 0;
+
+	return val;
+}
+
+/* Given a register value, decode (extract) the value in the given field */
+static inline u32 reg_decode(const struct reg *reg, u32 field_id, u32 val)
+{
+	u32 fmask = reg_fmask(reg, field_id);
+
+	return fmask ? (val & fmask) >> __ffs(fmask) : 0;
+}
+
 /* Returns 0 for NULL reg; warning should have already been issued */
 static inline u32 reg_offset(const struct reg *reg)
 {
-- 
2.34.1

