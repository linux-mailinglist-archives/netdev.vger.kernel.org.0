Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BADE55EB434
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 00:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbiIZWKB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 18:10:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbiIZWJu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 18:09:50 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54A20A441
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 15:09:46 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id n192so5225974iod.3
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 15:09:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=VyYzmvYjF7oyQI2VKMwDEZ7mq4X8E3L/KZJlNQrS7mE=;
        b=vF14dxP3tQ6yVjgt6ntoGH5n6gZGDsD+6kEDYeFdx57rYv+i6QSnsOli5prBcEGsR6
         o2+k/GkhuPwfIIgiBJ9hIwbjbHDk/MDwxMh59aUEdQ3X2T5nFf9t5j9P8vfpFWBPJGWl
         AdJCaQCJMrkYscwaysUdBQmWQ2/1IZtoEgDVYf2AUFEiBB0RucnxzOOl7zTiQmMCmmNJ
         pm4aTtPdFe8IWAykEIG+Zm3oU0JKZf9wI+ggU11ZNDuKe318I3RaWXq3RbHsRbE8Nspy
         SE8/2UVsUjYcb+IE6kjrNkOdBSRkaSuOoTSi6glf4QMzqWrF0atZ4iK9rXIqSuWZ1aj7
         gfxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=VyYzmvYjF7oyQI2VKMwDEZ7mq4X8E3L/KZJlNQrS7mE=;
        b=YEjCGtCcQMSbkAqCSUZkRJtOBgUOnNwg3Q/aEm3S1mftd6kPcgWBwT07dYmP7lDB+M
         zmpoCTRb52wLY0TJM0KLr2tHUgAqXOz2vyyzSHWHuL2dl6D5g1H+T5sjjM7UQbOI0T3Q
         w/CLtmnIBR2zyTL3LT8/XUGq9j5vhOORiiMfyPTklgIvdnuxAtdvd6/Wo1D+aK5sqSEY
         Og/PeBypQSmUy06lDrZ3xd8Mi5WQgUle5PO26nSuz7dP2znEnlWLg1Vc1dblgzhonB87
         qmXKF6/HfaONk6OTkWgMrBoZw3E1/n5vdDDK75pdO4mEW2qqfp3OFUfOcHoF7EGOrhOJ
         UnWw==
X-Gm-Message-State: ACrzQf0zPGQ+xWULAH2jqGx11Br5crxmGUhCBzoauuFvL76yssZdfk7o
        1lgHSgtp9fs5x85fSGlQ4oQyLA==
X-Google-Smtp-Source: AMsMyM4IPS5gamiOeMf++h1oxaygf92VndQT028TORKpthSt4g8oQBQ5YIjDVAnY77KYYNUwlqdsOQ==
X-Received: by 2002:a6b:670b:0:b0:6a0:d9db:5ae5 with SMTP id b11-20020a6b670b000000b006a0d9db5ae5mr10056418ioc.62.1664230185737;
        Mon, 26 Sep 2022 15:09:45 -0700 (PDT)
Received: from localhost.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id z20-20020a027a54000000b003567503cf92sm7631600jad.82.2022.09.26.15.09.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 15:09:45 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 02/15] net: ipa: use IPA register IDs to determine offsets
Date:   Mon, 26 Sep 2022 17:09:18 -0500
Message-Id: <20220926220931.3261749-3-elder@linaro.org>
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

Expose two inline functions that return the offset for a register
whose ID is provided; one of them takes an additional argument
that's used for registers that are parameterized.  These both use
a common helper function __ipa_reg_offset(), which just uses the
offset symbols already defined.

Replace all references to the offset macros defined for IPA
registers with calls to ipa_reg_offset() or ipa_reg_n_offset().

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_cmd.c       |   4 +-
 drivers/net/ipa/ipa_endpoint.c  | 108 +++++++++++++++++++----------
 drivers/net/ipa/ipa_interrupt.c |  23 +++----
 drivers/net/ipa/ipa_main.c      |  49 ++++++++-----
 drivers/net/ipa/ipa_mem.c       |   6 +-
 drivers/net/ipa/ipa_reg.c       | 118 +++++++++++++++++++++++++++++++-
 drivers/net/ipa/ipa_reg.h       |  13 ++++
 drivers/net/ipa/ipa_resource.c  |  24 ++++---
 drivers/net/ipa/ipa_table.c     |   9 ++-
 drivers/net/ipa/ipa_uc.c        |   4 +-
 10 files changed, 271 insertions(+), 87 deletions(-)

diff --git a/drivers/net/ipa/ipa_cmd.c b/drivers/net/ipa/ipa_cmd.c
index 6dea40259b604..191fb3d0b1e53 100644
--- a/drivers/net/ipa/ipa_cmd.c
+++ b/drivers/net/ipa/ipa_cmd.c
@@ -312,7 +312,7 @@ static bool ipa_cmd_register_write_valid(struct ipa *ipa)
 	 * offset will fit in a register write IPA immediate command.
 	 */
 	if (ipa_table_hash_support(ipa)) {
-		offset = ipa_reg_filt_rout_hash_flush_offset(ipa->version);
+		offset = ipa_reg_offset(ipa, FILT_ROUT_HASH_FLUSH);
 		name = "filter/route hash flush";
 		if (!ipa_cmd_register_write_offset_valid(ipa, name, offset))
 			return false;
@@ -325,7 +325,7 @@ static bool ipa_cmd_register_write_valid(struct ipa *ipa)
 	 * worst case (highest endpoint number) offset of that endpoint
 	 * fits in the register write command field(s) that must hold it.
 	 */
-	offset = IPA_REG_ENDP_STATUS_N_OFFSET(IPA_ENDPOINT_COUNT - 1);
+	offset = ipa_reg_n_offset(ipa, ENDP_STATUS, IPA_ENDPOINT_COUNT - 1);
 	name = "maximal endpoint status";
 	if (!ipa_cmd_register_write_offset_valid(ipa, name, offset))
 		return false;
diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 6db62b6fb6632..a5408b6b05613 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -308,8 +308,8 @@ static struct gsi_trans *ipa_endpoint_trans_alloc(struct ipa_endpoint *endpoint,
 static bool
 ipa_endpoint_init_ctrl(struct ipa_endpoint *endpoint, bool suspend_delay)
 {
-	u32 offset = IPA_REG_ENDP_INIT_CTRL_N_OFFSET(endpoint->endpoint_id);
 	struct ipa *ipa = endpoint->ipa;
+	u32 offset;
 	bool state;
 	u32 mask;
 	u32 val;
@@ -319,6 +319,8 @@ ipa_endpoint_init_ctrl(struct ipa_endpoint *endpoint, bool suspend_delay)
 	else
 		WARN_ON(ipa->version >= IPA_VERSION_4_0);
 
+	offset = ipa_reg_n_offset(ipa, ENDP_INIT_CTRL, endpoint->endpoint_id);
+
 	mask = endpoint->toward_ipa ? ENDP_DELAY_FMASK : ENDP_SUSPEND_FMASK;
 
 	val = ioread32(ipa->reg_virt + offset);
@@ -348,13 +350,11 @@ static bool ipa_endpoint_aggr_active(struct ipa_endpoint *endpoint)
 {
 	u32 mask = BIT(endpoint->endpoint_id);
 	struct ipa *ipa = endpoint->ipa;
-	u32 offset;
 	u32 val;
 
 	WARN_ON(!(mask & ipa->available));
 
-	offset = ipa_reg_state_aggr_active_offset(ipa->version);
-	val = ioread32(ipa->reg_virt + offset);
+	val = ioread32(ipa->reg_virt + ipa_reg_offset(ipa, STATE_AGGR_ACTIVE));
 
 	return !!(val & mask);
 }
@@ -366,7 +366,7 @@ static void ipa_endpoint_force_close(struct ipa_endpoint *endpoint)
 
 	WARN_ON(!(mask & ipa->available));
 
-	iowrite32(mask, ipa->reg_virt + IPA_REG_AGGR_FORCE_CLOSE_OFFSET);
+	iowrite32(mask, ipa->reg_virt + ipa_reg_offset(ipa, AGGR_FORCE_CLOSE));
 }
 
 /**
@@ -474,7 +474,7 @@ int ipa_endpoint_modem_exception_reset_all(struct ipa *ipa)
 		if (!(endpoint->ee_id == GSI_EE_MODEM && endpoint->toward_ipa))
 			continue;
 
-		offset = IPA_REG_ENDP_STATUS_N_OFFSET(endpoint_id);
+		offset = ipa_reg_n_offset(ipa, ENDP_STATUS, endpoint_id);
 
 		/* Value written is 0, and all bits are updated.  That
 		 * means status is disabled on the endpoint, and as a
@@ -494,13 +494,16 @@ int ipa_endpoint_modem_exception_reset_all(struct ipa *ipa)
 
 static void ipa_endpoint_init_cfg(struct ipa_endpoint *endpoint)
 {
-	u32 offset = IPA_REG_ENDP_INIT_CFG_N_OFFSET(endpoint->endpoint_id);
+	struct ipa *ipa = endpoint->ipa;
 	enum ipa_cs_offload_en enabled;
 	u32 val = 0;
+	u32 offset;
+
+	offset = ipa_reg_n_offset(ipa, ENDP_INIT_CFG, endpoint->endpoint_id);
 
 	/* FRAG_OFFLOAD_EN is 0 */
 	if (endpoint->config.checksum) {
-		enum ipa_version version = endpoint->ipa->version;
+		enum ipa_version version = ipa->version;
 
 		if (endpoint->toward_ipa) {
 			u32 off;
@@ -525,21 +528,23 @@ static void ipa_endpoint_init_cfg(struct ipa_endpoint *endpoint)
 	val |= u32_encode_bits(enabled, CS_OFFLOAD_EN_FMASK);
 	/* CS_GEN_QMB_MASTER_SEL is 0 */
 
-	iowrite32(val, endpoint->ipa->reg_virt + offset);
+	iowrite32(val, ipa->reg_virt + offset);
 }
 
 static void ipa_endpoint_init_nat(struct ipa_endpoint *endpoint)
 {
+	struct ipa *ipa = endpoint->ipa;
 	u32 offset;
 	u32 val;
 
 	if (!endpoint->toward_ipa)
 		return;
 
-	offset = IPA_REG_ENDP_INIT_NAT_N_OFFSET(endpoint->endpoint_id);
+	offset = ipa_reg_n_offset(ipa, ENDP_INIT_NAT, endpoint->endpoint_id);
+
 	val = u32_encode_bits(IPA_NAT_BYPASS, NAT_EN_FMASK);
 
-	iowrite32(val, endpoint->ipa->reg_virt + offset);
+	iowrite32(val, ipa->reg_virt + offset);
 }
 
 static u32
@@ -586,9 +591,11 @@ ipa_qmap_header_size(enum ipa_version version, struct ipa_endpoint *endpoint)
  */
 static void ipa_endpoint_init_hdr(struct ipa_endpoint *endpoint)
 {
-	u32 offset = IPA_REG_ENDP_INIT_HDR_N_OFFSET(endpoint->endpoint_id);
 	struct ipa *ipa = endpoint->ipa;
 	u32 val = 0;
+	u32 offset;
+
+	offset = ipa_reg_n_offset(ipa, ENDP_INIT_HDR, endpoint->endpoint_id);
 
 	if (endpoint->config.qmap) {
 		enum ipa_version version = ipa->version;
@@ -599,7 +606,7 @@ static void ipa_endpoint_init_hdr(struct ipa_endpoint *endpoint)
 
 		/* Define how to fill fields in a received QMAP header */
 		if (!endpoint->toward_ipa) {
-			u32 off;	/* Field offset within header */
+			u32 off;     /* Field offset within header */
 
 			/* Where IPA will write the metadata value */
 			off = offsetof(struct rmnet_map_header, mux_id);
@@ -628,10 +635,13 @@ static void ipa_endpoint_init_hdr(struct ipa_endpoint *endpoint)
 
 static void ipa_endpoint_init_hdr_ext(struct ipa_endpoint *endpoint)
 {
-	u32 offset = IPA_REG_ENDP_INIT_HDR_EXT_N_OFFSET(endpoint->endpoint_id);
 	u32 pad_align = endpoint->config.rx.pad_align;
 	struct ipa *ipa = endpoint->ipa;
 	u32 val = 0;
+	u32 offset;
+
+	offset = ipa_reg_n_offset(ipa, ENDP_INIT_HDR_EXT,
+				  endpoint->endpoint_id);
 
 	if (endpoint->config.qmap) {
 		/* We have a header, so we must specify its endianness */
@@ -662,7 +672,7 @@ static void ipa_endpoint_init_hdr_ext(struct ipa_endpoint *endpoint)
 	if (ipa->version >= IPA_VERSION_4_5) {
 		/* HDR_TOTAL_LEN_OR_PAD_OFFSET is 0, so MSB is 0 */
 		if (endpoint->config.qmap && !endpoint->toward_ipa) {
-			u32 off;
+			u32 off;     /* Field offset within header */
 
 			off = offsetof(struct rmnet_map_header, pkt_len);
 			off >>= hweight32(HDR_OFST_PKT_SIZE_FMASK);
@@ -671,40 +681,46 @@ static void ipa_endpoint_init_hdr_ext(struct ipa_endpoint *endpoint)
 			/* HDR_ADDITIONAL_CONST_LEN is 0 so MSB is 0 */
 		}
 	}
+
 	iowrite32(val, ipa->reg_virt + offset);
 }
 
 static void ipa_endpoint_init_hdr_metadata_mask(struct ipa_endpoint *endpoint)
 {
 	u32 endpoint_id = endpoint->endpoint_id;
+	struct ipa *ipa = endpoint->ipa;
 	u32 val = 0;
 	u32 offset;
 
 	if (endpoint->toward_ipa)
 		return;		/* Register not valid for TX endpoints */
 
-	offset = IPA_REG_ENDP_INIT_HDR_METADATA_MASK_N_OFFSET(endpoint_id);
+	offset = ipa_reg_n_offset(ipa, ENDP_INIT_HDR_METADATA_MASK,
+				  endpoint_id);
 
 	/* Note that HDR_ENDIANNESS indicates big endian header fields */
 	if (endpoint->config.qmap)
 		val = (__force u32)cpu_to_be32(IPA_ENDPOINT_QMAP_METADATA_MASK);
 
-	iowrite32(val, endpoint->ipa->reg_virt + offset);
+	iowrite32(val, ipa->reg_virt + offset);
 }
 
 static void ipa_endpoint_init_mode(struct ipa_endpoint *endpoint)
 {
-	u32 offset = IPA_REG_ENDP_INIT_MODE_N_OFFSET(endpoint->endpoint_id);
+	struct ipa *ipa = endpoint->ipa;
+	u32 offset;
 	u32 val;
 
 	if (!endpoint->toward_ipa)
 		return;		/* Register not valid for RX endpoints */
 
+	offset = ipa_reg_n_offset(ipa, ENDP_INIT_MODE, endpoint->endpoint_id);
+
 	if (endpoint->config.dma_mode) {
 		enum ipa_endpoint_name name = endpoint->config.dma_endpoint;
 		u32 dma_endpoint_id;
 
-		dma_endpoint_id = endpoint->ipa->name_map[name]->endpoint_id;
+		dma_endpoint_id = ipa->name_map[name]->endpoint_id;
 
 		val = u32_encode_bits(IPA_DMA, MODE_FMASK);
 		val |= u32_encode_bits(dma_endpoint_id, DEST_PIPE_INDEX_FMASK);
@@ -713,7 +729,7 @@ static void ipa_endpoint_init_mode(struct ipa_endpoint *endpoint)
 	}
 	/* All other bits unspecified (and 0) */
 
-	iowrite32(val, endpoint->ipa->reg_virt + offset);
+	iowrite32(val, ipa->reg_virt + offset);
 }
 
 /* Encoded values for AGGR endpoint register fields */
@@ -798,13 +814,16 @@ static u32 aggr_sw_eof_active_encoded(enum ipa_version version, bool enabled)
 
 static void ipa_endpoint_init_aggr(struct ipa_endpoint *endpoint)
 {
-	u32 offset = IPA_REG_ENDP_INIT_AGGR_N_OFFSET(endpoint->endpoint_id);
-	enum ipa_version version = endpoint->ipa->version;
+	struct ipa *ipa = endpoint->ipa;
 	u32 val = 0;
+	u32 offset;
+
+	offset = ipa_reg_n_offset(ipa, ENDP_INIT_AGGR, endpoint->endpoint_id);
 
 	if (endpoint->config.aggregation) {
 		if (!endpoint->toward_ipa) {
 			const struct ipa_endpoint_rx *rx_config;
+			enum ipa_version version = ipa->version;
 			u32 buffer_size;
 			bool close_eof;
 			u32 limit;
@@ -838,7 +857,7 @@ static void ipa_endpoint_init_aggr(struct ipa_endpoint *endpoint)
 		/* other fields ignored */
 	}
 
-	iowrite32(val, endpoint->ipa->reg_virt + offset);
+	iowrite32(val, ipa->reg_virt + offset);
 }
 
 /* The head-of-line blocking timer is defined as a tick count.  For
@@ -923,8 +942,9 @@ static void ipa_endpoint_init_hol_block_timer(struct ipa_endpoint *endpoint,
 	u32 val;
 
 	/* This should only be changed when HOL_BLOCK_EN is disabled */
-	offset = IPA_REG_ENDP_INIT_HOL_BLOCK_TIMER_N_OFFSET(endpoint_id);
 	val = hol_block_timer_encode(ipa, microseconds);
+
+	offset = ipa_reg_n_offset(ipa, ENDP_INIT_HOL_BLOCK_TIMER, endpoint_id);
 	iowrite32(val, ipa->reg_virt + offset);
 }
 
@@ -932,15 +952,19 @@ static void
 ipa_endpoint_init_hol_block_en(struct ipa_endpoint *endpoint, bool enable)
 {
 	u32 endpoint_id = endpoint->endpoint_id;
+	struct ipa *ipa = endpoint->ipa;
 	u32 offset;
 	u32 val;
 
+	offset = ipa_reg_n_offset(ipa, ENDP_INIT_HOL_BLOCK_EN, endpoint_id);
+
 	val = enable ? HOL_BLOCK_EN_FMASK : 0;
-	offset = IPA_REG_ENDP_INIT_HOL_BLOCK_EN_N_OFFSET(endpoint_id);
-	iowrite32(val, endpoint->ipa->reg_virt + offset);
+
+	iowrite32(val, ipa->reg_virt + offset);
+
 	/* When enabling, the register must be written twice for IPA v4.5+ */
-	if (enable && endpoint->ipa->version >= IPA_VERSION_4_5)
-		iowrite32(val, endpoint->ipa->reg_virt + offset);
+	if (enable && ipa->version >= IPA_VERSION_4_5)
+		iowrite32(val, ipa->reg_virt + offset);
 }
 
 /* Assumes HOL_BLOCK is in disabled state */
@@ -973,47 +997,57 @@ void ipa_endpoint_modem_hol_block_clear_all(struct ipa *ipa)
 
 static void ipa_endpoint_init_deaggr(struct ipa_endpoint *endpoint)
 {
-	u32 offset = IPA_REG_ENDP_INIT_DEAGGR_N_OFFSET(endpoint->endpoint_id);
+	struct ipa *ipa = endpoint->ipa;
 	u32 val = 0;
+	u32 offset;
 
 	if (!endpoint->toward_ipa)
 		return;		/* Register not valid for RX endpoints */
 
+	offset = ipa_reg_n_offset(ipa, ENDP_INIT_DEAGGR, endpoint->endpoint_id);
+
 	/* DEAGGR_HDR_LEN is 0 */
 	/* PACKET_OFFSET_VALID is 0 */
 	/* PACKET_OFFSET_LOCATION is ignored (not valid) */
 	/* MAX_PACKET_LEN is 0 (not enforced) */
 
-	iowrite32(val, endpoint->ipa->reg_virt + offset);
+	iowrite32(val, ipa->reg_virt + offset);
 }
 
 static void ipa_endpoint_init_rsrc_grp(struct ipa_endpoint *endpoint)
 {
-	u32 offset = IPA_REG_ENDP_INIT_RSRC_GRP_N_OFFSET(endpoint->endpoint_id);
 	struct ipa *ipa = endpoint->ipa;
+	u32 offset;
 	u32 val;
 
+	offset = ipa_reg_n_offset(ipa, ENDP_INIT_RSRC_GRP,
+				  endpoint->endpoint_id);
+
 	val = rsrc_grp_encoded(ipa->version, endpoint->config.resource_group);
+
 	iowrite32(val, ipa->reg_virt + offset);
 }
 
 static void ipa_endpoint_init_seq(struct ipa_endpoint *endpoint)
 {
-	u32 offset = IPA_REG_ENDP_INIT_SEQ_N_OFFSET(endpoint->endpoint_id);
+	struct ipa *ipa = endpoint->ipa;
 	u32 val = 0;
+	u32 offset;
 
 	if (!endpoint->toward_ipa)
 		return;		/* Register not valid for RX endpoints */
 
+	offset = ipa_reg_n_offset(ipa, ENDP_INIT_SEQ, endpoint->endpoint_id);
+
 	/* Low-order byte configures primary packet processing */
 	val |= u32_encode_bits(endpoint->config.tx.seq_type, SEQ_TYPE_FMASK);
 
 	/* Second byte (if supported) configures replicated packet processing */
-	if (endpoint->ipa->version < IPA_VERSION_4_5)
+	if (ipa->version < IPA_VERSION_4_5)
 		val |= u32_encode_bits(endpoint->config.tx.seq_rep_type,
 				       SEQ_REP_TYPE_FMASK);
 
-	iowrite32(val, endpoint->ipa->reg_virt + offset);
+	iowrite32(val, ipa->reg_virt + offset);
 }
 
 /**
@@ -1066,7 +1100,7 @@ static void ipa_endpoint_status(struct ipa_endpoint *endpoint)
 	u32 val = 0;
 	u32 offset;
 
-	offset = IPA_REG_ENDP_STATUS_N_OFFSET(endpoint_id);
+	offset = ipa_reg_n_offset(ipa, ENDP_STATUS, endpoint_id);
 
 	if (endpoint->config.status_enable) {
 		val |= STATUS_EN_FMASK;
@@ -1435,7 +1469,7 @@ void ipa_endpoint_default_route_set(struct ipa *ipa, u32 endpoint_id)
 	val |= u32_encode_bits(endpoint_id, ROUTE_FRAG_DEF_PIPE_FMASK);
 	val |= ROUTE_DEF_RETAIN_HDR_FMASK;
 
-	iowrite32(val, ipa->reg_virt + IPA_REG_ROUTE_OFFSET);
+	iowrite32(val, ipa->reg_virt + ipa_reg_offset(ipa, ROUTE));
 }
 
 void ipa_endpoint_default_route_clear(struct ipa *ipa)
@@ -1805,7 +1839,7 @@ int ipa_endpoint_config(struct ipa *ipa)
 	/* Find out about the endpoints supplied by the hardware, and ensure
 	 * the highest one doesn't exceed the number we support.
 	 */
-	val = ioread32(ipa->reg_virt + IPA_REG_FLAVOR_0_OFFSET);
+	val = ioread32(ipa->reg_virt + ipa_reg_offset(ipa, FLAVOR_0));
 
 	/* Our RX is an IPA producer */
 	rx_base = u32_get_bits(val, IPA_PROD_LOWEST_FMASK);
diff --git a/drivers/net/ipa/ipa_interrupt.c b/drivers/net/ipa/ipa_interrupt.c
index 307bed2ee7078..48065c2d55afc 100644
--- a/drivers/net/ipa/ipa_interrupt.c
+++ b/drivers/net/ipa/ipa_interrupt.c
@@ -59,7 +59,7 @@ static void ipa_interrupt_process(struct ipa_interrupt *interrupt, u32 irq_id)
 	/* For microcontroller interrupts, clear the interrupt right away,
 	 * "to avoid clearing unhandled interrupts."
 	 */
-	offset = ipa_reg_irq_clr_offset(ipa->version);
+	offset = ipa_reg_offset(ipa, IPA_IRQ_CLR);
 	if (uc_irq)
 		iowrite32(mask, ipa->reg_virt + offset);
 
@@ -95,7 +95,7 @@ static irqreturn_t ipa_isr_thread(int irq, void *dev_id)
 	 * including conditions whose interrupt is not enabled.  Handle
 	 * only the enabled ones.
 	 */
-	offset = ipa_reg_irq_stts_offset(ipa->version);
+	offset = ipa_reg_offset(ipa, IPA_IRQ_STTS);
 	pending = ioread32(ipa->reg_virt + offset);
 	while ((mask = pending & enabled)) {
 		do {
@@ -112,7 +112,7 @@ static irqreturn_t ipa_isr_thread(int irq, void *dev_id)
 	if (pending) {
 		dev_dbg(dev, "clearing disabled IPA interrupts 0x%08x\n",
 			pending);
-		offset = ipa_reg_irq_clr_offset(ipa->version);
+		offset = ipa_reg_offset(ipa, IPA_IRQ_CLR);
 		iowrite32(pending, ipa->reg_virt + offset);
 	}
 out_power_put:
@@ -137,7 +137,7 @@ static void ipa_interrupt_suspend_control(struct ipa_interrupt *interrupt,
 	if (ipa->version == IPA_VERSION_3_0)
 		return;
 
-	offset = ipa_reg_irq_suspend_en_offset(ipa->version);
+	offset = ipa_reg_offset(ipa, IRQ_SUSPEND_EN);
 	val = ioread32(ipa->reg_virt + offset);
 	if (enable)
 		val |= mask;
@@ -164,18 +164,15 @@ ipa_interrupt_suspend_disable(struct ipa_interrupt *interrupt, u32 endpoint_id)
 void ipa_interrupt_suspend_clear_all(struct ipa_interrupt *interrupt)
 {
 	struct ipa *ipa = interrupt->ipa;
-	u32 offset;
 	u32 val;
 
-	offset = ipa_reg_irq_suspend_info_offset(ipa->version);
-	val = ioread32(ipa->reg_virt + offset);
+	val = ioread32(ipa->reg_virt + ipa_reg_offset(ipa, IRQ_SUSPEND_INFO));
 
 	/* SUSPEND interrupt status isn't cleared on IPA version 3.0 */
 	if (ipa->version == IPA_VERSION_3_0)
 		return;
 
-	offset = ipa_reg_irq_suspend_clr_offset(ipa->version);
-	iowrite32(val, ipa->reg_virt + offset);
+	iowrite32(val, ipa->reg_virt + ipa_reg_offset(ipa, IRQ_SUSPEND_CLR));
 }
 
 /* Simulate arrival of an IPA TX_SUSPEND interrupt */
@@ -198,7 +195,7 @@ void ipa_interrupt_add(struct ipa_interrupt *interrupt,
 
 	/* Update the IPA interrupt mask to enable it */
 	interrupt->enabled |= BIT(ipa_irq);
-	offset = ipa_reg_irq_en_offset(ipa->version);
+	offset = ipa_reg_offset(ipa, IPA_IRQ_EN);
 	iowrite32(interrupt->enabled, ipa->reg_virt + offset);
 }
 
@@ -214,7 +211,7 @@ ipa_interrupt_remove(struct ipa_interrupt *interrupt, enum ipa_irq_id ipa_irq)
 
 	/* Update the IPA interrupt mask to disable it */
 	interrupt->enabled &= ~BIT(ipa_irq);
-	offset = ipa_reg_irq_en_offset(ipa->version);
+	offset = ipa_reg_offset(ipa, IPA_IRQ_EN);
 	iowrite32(interrupt->enabled, ipa->reg_virt + offset);
 
 	interrupt->handler[ipa_irq] = NULL;
@@ -226,7 +223,6 @@ struct ipa_interrupt *ipa_interrupt_config(struct ipa *ipa)
 	struct device *dev = &ipa->pdev->dev;
 	struct ipa_interrupt *interrupt;
 	unsigned int irq;
-	u32 offset;
 	int ret;
 
 	ret = platform_get_irq_byname(ipa->pdev, "ipa");
@@ -244,8 +240,7 @@ struct ipa_interrupt *ipa_interrupt_config(struct ipa *ipa)
 	interrupt->irq = irq;
 
 	/* Start with all IPA interrupts disabled */
-	offset = ipa_reg_irq_en_offset(ipa->version);
-	iowrite32(0, ipa->reg_virt + offset);
+	iowrite32(0, ipa->reg_virt + ipa_reg_offset(ipa, IPA_IRQ_EN));
 
 	ret = request_threaded_irq(irq, NULL, ipa_isr_thread, IRQF_ONESHOT,
 				   "ipa", interrupt);
diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index a552d6edb702d..04eb4a019591d 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -193,23 +193,26 @@ ipa_hardware_config_bcr(struct ipa *ipa, const struct ipa_data *data)
 		return;
 
 	val = data->backward_compat;
-	iowrite32(val, ipa->reg_virt + IPA_REG_BCR_OFFSET);
+
+	iowrite32(val, ipa->reg_virt + ipa_reg_offset(ipa, IPA_BCR));
 }
 
 static void ipa_hardware_config_tx(struct ipa *ipa)
 {
 	enum ipa_version version = ipa->version;
+	u32 offset;
 	u32 val;
 
 	if (version <= IPA_VERSION_4_0 || version >= IPA_VERSION_4_5)
 		return;
 
 	/* Disable PA mask to allow HOLB drop */
-	val = ioread32(ipa->reg_virt + IPA_REG_TX_CFG_OFFSET);
+	offset = ipa_reg_offset(ipa, IPA_TX_CFG);
+	val = ioread32(ipa->reg_virt + offset);
 
 	val &= ~PA_MASK_EN_FMASK;
 
-	iowrite32(val, ipa->reg_virt + IPA_REG_TX_CFG_OFFSET);
+	iowrite32(val, ipa->reg_virt + offset);
 }
 
 static void ipa_hardware_config_clkon(struct ipa *ipa)
@@ -221,6 +224,7 @@ static void ipa_hardware_config_clkon(struct ipa *ipa)
 		return;
 
 	/* Implement some hardware workarounds */
+
 	if (version >= IPA_VERSION_4_0) {
 		/* Enable open global clocks in the CLKON configuration */
 		val = GLOBAL_FMASK | GLOBAL_2X_CLK_FMASK;
@@ -230,19 +234,21 @@ static void ipa_hardware_config_clkon(struct ipa *ipa)
 		return;
 	}
 
-	iowrite32(val, ipa->reg_virt + IPA_REG_CLKON_CFG_OFFSET);
+	iowrite32(val, ipa->reg_virt + ipa_reg_offset(ipa, CLKON_CFG));
 }
 
 /* Configure bus access behavior for IPA components */
 static void ipa_hardware_config_comp(struct ipa *ipa)
 {
+	u32 offset;
 	u32 val;
 
 	/* Nothing to configure prior to IPA v4.0 */
 	if (ipa->version < IPA_VERSION_4_0)
 		return;
 
-	val = ioread32(ipa->reg_virt + IPA_REG_COMP_CFG_OFFSET);
+	offset = ipa_reg_offset(ipa, COMP_CFG);
+	val = ioread32(ipa->reg_virt + offset);
 
 	if (ipa->version == IPA_VERSION_4_0) {
 		val &= ~IPA_QMB_SELECT_CONS_EN_FMASK;
@@ -257,7 +263,7 @@ static void ipa_hardware_config_comp(struct ipa *ipa)
 	val |= GSI_MULTI_INORDER_RD_DIS_FMASK;
 	val |= GSI_MULTI_INORDER_WR_DIS_FMASK;
 
-	iowrite32(val, ipa->reg_virt + IPA_REG_COMP_CFG_OFFSET);
+	iowrite32(val, ipa->reg_virt + offset);
 }
 
 /* Configure DDR and (possibly) PCIe max read/write QSB values */
@@ -278,7 +284,7 @@ ipa_hardware_config_qsb(struct ipa *ipa, const struct ipa_data *data)
 	if (data->qsb_count > 1)
 		val |= u32_encode_bits(data1->max_writes,
 				       GEN_QMB_1_MAX_WRITES_FMASK);
-	iowrite32(val, ipa->reg_virt + IPA_REG_QSB_MAX_WRITES_OFFSET);
+	iowrite32(val, ipa->reg_virt + ipa_reg_offset(ipa, QSB_MAX_WRITES));
 
 	/* Max outstanding read accesses for QSB masters */
 	val = u32_encode_bits(data0->max_reads, GEN_QMB_0_MAX_READS_FMASK);
@@ -292,7 +298,7 @@ ipa_hardware_config_qsb(struct ipa *ipa, const struct ipa_data *data)
 			val |= u32_encode_bits(data1->max_reads_beats,
 					       GEN_QMB_1_MAX_READS_BEATS_FMASK);
 	}
-	iowrite32(val, ipa->reg_virt + IPA_REG_QSB_MAX_READS_OFFSET);
+	iowrite32(val, ipa->reg_virt + ipa_reg_offset(ipa, QSB_MAX_READS));
 }
 
 /* The internal inactivity timer clock is used for the aggregation timer */
@@ -328,10 +334,12 @@ static __always_inline u32 ipa_aggr_granularity_val(u32 usec)
  */
 static void ipa_qtime_config(struct ipa *ipa)
 {
+	u32 offset;
 	u32 val;
 
 	/* Timer clock divider must be disabled when we change the rate */
-	iowrite32(0, ipa->reg_virt + IPA_REG_TIMERS_XO_CLK_DIV_CFG_OFFSET);
+	offset = ipa_reg_offset(ipa, TIMERS_XO_CLK_DIV_CFG);
+	iowrite32(0, ipa->reg_virt + offset);
 
 	/* Set DPL time stamp resolution to use Qtime (instead of 1 msec) */
 	val = u32_encode_bits(DPL_TIMESTAMP_SHIFT, DPL_TIMESTAMP_LSB_FMASK);
@@ -339,34 +347,43 @@ static void ipa_qtime_config(struct ipa *ipa)
 	/* Configure tag and NAT Qtime timestamp resolution as well */
 	val |= u32_encode_bits(TAG_TIMESTAMP_SHIFT, TAG_TIMESTAMP_LSB_FMASK);
 	val |= u32_encode_bits(NAT_TIMESTAMP_SHIFT, NAT_TIMESTAMP_LSB_FMASK);
-	iowrite32(val, ipa->reg_virt + IPA_REG_QTIME_TIMESTAMP_CFG_OFFSET);
+
+	offset = ipa_reg_offset(ipa, QTIME_TIMESTAMP_CFG);
+	iowrite32(val, ipa->reg_virt + offset);
 
 	/* Set granularity of pulse generators used for other timers */
 	val = u32_encode_bits(IPA_GRAN_100_US, GRAN_0_FMASK);
 	val |= u32_encode_bits(IPA_GRAN_1_MS, GRAN_1_FMASK);
 	val |= u32_encode_bits(IPA_GRAN_1_MS, GRAN_2_FMASK);
-	iowrite32(val, ipa->reg_virt + IPA_REG_TIMERS_PULSE_GRAN_CFG_OFFSET);
+
+	offset = ipa_reg_offset(ipa, TIMERS_PULSE_GRAN_CFG);
+	iowrite32(val, ipa->reg_virt + offset);
 
 	/* Actual divider is 1 more than value supplied here */
 	val = u32_encode_bits(IPA_XO_CLOCK_DIVIDER - 1, DIV_VALUE_FMASK);
-	iowrite32(val, ipa->reg_virt + IPA_REG_TIMERS_XO_CLK_DIV_CFG_OFFSET);
+
+	offset = ipa_reg_offset(ipa, TIMERS_XO_CLK_DIV_CFG);
+	iowrite32(val, ipa->reg_virt + offset);
 
 	/* Divider value is set; re-enable the common timer clock divider */
 	val |= u32_encode_bits(1, DIV_ENABLE_FMASK);
-	iowrite32(val, ipa->reg_virt + IPA_REG_TIMERS_XO_CLK_DIV_CFG_OFFSET);
+
+	iowrite32(val, ipa->reg_virt + offset);
 }
 
 /* Before IPA v4.5 timing is controlled by a counter register */
 static void ipa_hardware_config_counter(struct ipa *ipa)
 {
 	u32 granularity;
+	u32 offset;
 	u32 val;
 
 	granularity = ipa_aggr_granularity_val(IPA_AGGR_GRANULARITY);
 
 	val = u32_encode_bits(granularity, AGGR_GRANULARITY_FMASK);
 
-	iowrite32(val, ipa->reg_virt + IPA_REG_COUNTER_CFG_OFFSET);
+	offset = ipa_reg_offset(ipa, COUNTER_CFG);
+	iowrite32(val, ipa->reg_virt + offset);
 }
 
 static void ipa_hardware_config_timing(struct ipa *ipa)
@@ -385,7 +402,7 @@ static void ipa_hardware_config_hashing(struct ipa *ipa)
 		return;
 
 	/* IPA v4.2 does not support hashed tables, so disable them */
-	offset = ipa_reg_filt_rout_hash_en_offset(IPA_VERSION_4_2);
+	offset = ipa_reg_offset(ipa, FILT_ROUT_HASH_EN);
 	iowrite32(0, ipa->reg_virt + offset);
 }
 
@@ -401,7 +418,7 @@ static void ipa_idle_indication_cfg(struct ipa *ipa,
 	if (const_non_idle_enable)
 		val |= CONST_NON_IDLE_ENABLE_FMASK;
 
-	offset = ipa_reg_idle_indication_cfg_offset(ipa->version);
+	offset = ipa_reg_offset(ipa, IDLE_INDICATION_CFG);
 	iowrite32(val, ipa->reg_virt + offset);
 }
 
diff --git a/drivers/net/ipa/ipa_mem.c b/drivers/net/ipa/ipa_mem.c
index 53a1dbeaffa6d..53a777bb08a62 100644
--- a/drivers/net/ipa/ipa_mem.c
+++ b/drivers/net/ipa/ipa_mem.c
@@ -113,7 +113,9 @@ int ipa_mem_setup(struct ipa *ipa)
 	mem = ipa_mem_find(ipa, IPA_MEM_MODEM_PROC_CTX);
 	offset = ipa->mem_offset + mem->offset;
 	val = proc_cntxt_base_addr_encoded(ipa->version, offset);
-	iowrite32(val, ipa->reg_virt + IPA_REG_LOCAL_PKT_PROC_CNTXT_OFFSET);
+
+	offset = ipa_reg_offset(ipa, LOCAL_PKT_PROC_CNTXT);
+	iowrite32(val, ipa->reg_virt + offset);
 
 	return 0;
 }
@@ -314,7 +316,7 @@ int ipa_mem_config(struct ipa *ipa)
 	u32 i;
 
 	/* Check the advertised location and size of the shared memory area */
-	val = ioread32(ipa->reg_virt + IPA_REG_SHARED_MEM_SIZE_OFFSET);
+	val = ioread32(ipa->reg_virt + ipa_reg_offset(ipa, SHARED_MEM_SIZE));
 
 	/* The fields in the register are in 8 byte units */
 	ipa->mem_offset = 8 * u32_get_bits(val, SHARED_MEM_BADDR_FMASK);
diff --git a/drivers/net/ipa/ipa_reg.c b/drivers/net/ipa/ipa_reg.c
index 5d432f9c13f0a..f6269dc66b9f4 100644
--- a/drivers/net/ipa/ipa_reg.c
+++ b/drivers/net/ipa/ipa_reg.c
@@ -65,13 +65,127 @@ static bool ipa_reg_valid(struct ipa *ipa, enum ipa_reg_id reg_id)
 	return valid;
 }
 
+/* Assumes the endpoint transfer direction is valid; 0 is a bad offset */
+u32 __ipa_reg_offset(struct ipa *ipa, enum ipa_reg_id reg_id, u32 n)
+{
+	enum ipa_version version;
+
+	if (!ipa_reg_valid(ipa, reg_id))
+		return 0;
+
+	version = ipa->version;
+
+	switch (reg_id) {
+	case COMP_CFG:
+		return IPA_REG_COMP_CFG_OFFSET;
+	case CLKON_CFG:
+		return IPA_REG_CLKON_CFG_OFFSET;
+	case ROUTE:
+		return IPA_REG_ROUTE_OFFSET;
+	case SHARED_MEM_SIZE:
+		return IPA_REG_SHARED_MEM_SIZE_OFFSET;
+	case QSB_MAX_WRITES:
+		return IPA_REG_QSB_MAX_WRITES_OFFSET;
+	case QSB_MAX_READS:
+		return IPA_REG_QSB_MAX_READS_OFFSET;
+	case FILT_ROUT_HASH_EN:
+		return ipa_reg_filt_rout_hash_en_offset(version);
+	case FILT_ROUT_HASH_FLUSH:
+		return ipa_reg_filt_rout_hash_flush_offset(version);
+	case STATE_AGGR_ACTIVE:
+		return ipa_reg_state_aggr_active_offset(version);
+	case IPA_BCR:
+		return IPA_REG_BCR_OFFSET;
+	case LOCAL_PKT_PROC_CNTXT:
+		return IPA_REG_LOCAL_PKT_PROC_CNTXT_OFFSET;
+	case AGGR_FORCE_CLOSE:
+		return IPA_REG_AGGR_FORCE_CLOSE_OFFSET;
+	case COUNTER_CFG:
+		return IPA_REG_COUNTER_CFG_OFFSET;
+	case IPA_TX_CFG:
+		return IPA_REG_TX_CFG_OFFSET;
+	case FLAVOR_0:
+		return IPA_REG_FLAVOR_0_OFFSET;
+	case IDLE_INDICATION_CFG:
+		return ipa_reg_idle_indication_cfg_offset(version);
+	case QTIME_TIMESTAMP_CFG:
+		return IPA_REG_QTIME_TIMESTAMP_CFG_OFFSET;
+	case TIMERS_XO_CLK_DIV_CFG:
+		return IPA_REG_TIMERS_XO_CLK_DIV_CFG_OFFSET;
+	case TIMERS_PULSE_GRAN_CFG:
+		return IPA_REG_TIMERS_PULSE_GRAN_CFG_OFFSET;
+	case SRC_RSRC_GRP_01_RSRC_TYPE:
+		return IPA_REG_SRC_RSRC_GRP_01_RSRC_TYPE_N_OFFSET(n);
+	case SRC_RSRC_GRP_23_RSRC_TYPE:
+		return IPA_REG_SRC_RSRC_GRP_23_RSRC_TYPE_N_OFFSET(n);
+	case SRC_RSRC_GRP_45_RSRC_TYPE:
+		return IPA_REG_SRC_RSRC_GRP_45_RSRC_TYPE_N_OFFSET(n);
+	case SRC_RSRC_GRP_67_RSRC_TYPE:
+		return IPA_REG_SRC_RSRC_GRP_67_RSRC_TYPE_N_OFFSET(n);
+	case DST_RSRC_GRP_01_RSRC_TYPE:
+		return IPA_REG_DST_RSRC_GRP_01_RSRC_TYPE_N_OFFSET(n);
+	case DST_RSRC_GRP_23_RSRC_TYPE:
+		return IPA_REG_DST_RSRC_GRP_23_RSRC_TYPE_N_OFFSET(n);
+	case DST_RSRC_GRP_45_RSRC_TYPE:
+		return IPA_REG_DST_RSRC_GRP_45_RSRC_TYPE_N_OFFSET(n);
+	case DST_RSRC_GRP_67_RSRC_TYPE:
+		return IPA_REG_DST_RSRC_GRP_67_RSRC_TYPE_N_OFFSET(n);
+	case ENDP_INIT_CTRL:
+		return IPA_REG_ENDP_INIT_CTRL_N_OFFSET(n);
+	case ENDP_INIT_CFG:
+		return IPA_REG_ENDP_INIT_CFG_N_OFFSET(n);
+	case ENDP_INIT_NAT:
+		return IPA_REG_ENDP_INIT_NAT_N_OFFSET(n);
+	case ENDP_INIT_HDR:
+		return IPA_REG_ENDP_INIT_HDR_N_OFFSET(n);
+	case ENDP_INIT_HDR_EXT:
+		return IPA_REG_ENDP_INIT_HDR_EXT_N_OFFSET(n);
+	case ENDP_INIT_HDR_METADATA_MASK:
+		return IPA_REG_ENDP_INIT_HDR_METADATA_MASK_N_OFFSET(n);
+	case ENDP_INIT_MODE:
+		return IPA_REG_ENDP_INIT_MODE_N_OFFSET(n);
+	case ENDP_INIT_AGGR:
+		return IPA_REG_ENDP_INIT_AGGR_N_OFFSET(n);
+	case ENDP_INIT_HOL_BLOCK_EN:
+		return IPA_REG_ENDP_INIT_HOL_BLOCK_EN_N_OFFSET(n);
+	case ENDP_INIT_HOL_BLOCK_TIMER:
+		return IPA_REG_ENDP_INIT_HOL_BLOCK_TIMER_N_OFFSET(n);
+	case ENDP_INIT_DEAGGR:
+		return IPA_REG_ENDP_INIT_DEAGGR_N_OFFSET(n);
+	case ENDP_INIT_RSRC_GRP:
+		return IPA_REG_ENDP_INIT_RSRC_GRP_N_OFFSET(n);
+	case ENDP_INIT_SEQ:
+		return IPA_REG_ENDP_INIT_SEQ_N_OFFSET(n);
+	case ENDP_STATUS:
+		return IPA_REG_ENDP_STATUS_N_OFFSET(n);
+	case ENDP_FILTER_ROUTER_HSH_CFG:
+		return IPA_REG_ENDP_FILTER_ROUTER_HSH_CFG_N_OFFSET(n);
+	/* The IRQ registers below are only used for GSI_EE_AP */
+	case IPA_IRQ_STTS:
+		return ipa_reg_irq_stts_offset(version);
+	case IPA_IRQ_EN:
+		return ipa_reg_irq_en_offset(version);
+	case IPA_IRQ_CLR:
+		return ipa_reg_irq_clr_offset(version);
+	case IPA_IRQ_UC:
+		return ipa_reg_irq_uc_offset(version);
+	case IRQ_SUSPEND_INFO:
+		return ipa_reg_irq_suspend_info_offset(version);
+	case IRQ_SUSPEND_EN:
+		return ipa_reg_irq_suspend_en_offset(version);
+	case IRQ_SUSPEND_CLR:
+		return ipa_reg_irq_suspend_clr_offset(version);
+	default:
+		WARN(true, "bad register id %u???\n", reg_id);
+		return 0;
+	}
+}
+
 int ipa_reg_init(struct ipa *ipa)
 {
 	struct device *dev = &ipa->pdev->dev;
 	struct resource *res;
 
-	(void)ipa_reg_valid;	/* Avoid a warning */
-
 	/* Setup IPA register memory  */
 	res = platform_get_resource_byname(ipa->pdev, IORESOURCE_MEM,
 					   "ipa-reg");
diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
index e897550448c06..a5433103fdd2f 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -898,6 +898,19 @@ ipa_reg_irq_suspend_clr_offset(enum ipa_version version)
 	return ipa_reg_irq_suspend_clr_ee_n_offset(version, GSI_EE_AP);
 }
 
+u32 __ipa_reg_offset(struct ipa *ipa, enum ipa_reg_id reg_id, u32 n);
+
+static inline u32 ipa_reg_offset(struct ipa *ipa, enum ipa_reg_id reg_id)
+{
+	return __ipa_reg_offset(ipa, reg_id, 0);
+}
+
+static inline u32
+ipa_reg_n_offset(struct ipa *ipa, enum ipa_reg_id reg_id, u32 n)
+{
+	return __ipa_reg_offset(ipa, reg_id, n);
+}
+
 int ipa_reg_init(struct ipa *ipa);
 void ipa_reg_exit(struct ipa *ipa);
 
diff --git a/drivers/net/ipa/ipa_resource.c b/drivers/net/ipa/ipa_resource.c
index 06cec71993823..3d8eb8df1f83d 100644
--- a/drivers/net/ipa/ipa_resource.c
+++ b/drivers/net/ipa/ipa_resource.c
@@ -95,28 +95,32 @@ static void ipa_resource_config_src(struct ipa *ipa, u32 resource_type,
 
 	resource = &data->resource_src[resource_type];
 
-	offset = IPA_REG_SRC_RSRC_GRP_01_RSRC_TYPE_N_OFFSET(resource_type);
+	offset = ipa_reg_n_offset(ipa, SRC_RSRC_GRP_01_RSRC_TYPE,
+				  resource_type);
 	ylimits = group_count == 1 ? NULL : &resource->limits[1];
 	ipa_resource_config_common(ipa, offset, &resource->limits[0], ylimits);
 
 	if (group_count < 3)
 		return;
 
-	offset = IPA_REG_SRC_RSRC_GRP_23_RSRC_TYPE_N_OFFSET(resource_type);
+	offset = ipa_reg_n_offset(ipa, SRC_RSRC_GRP_23_RSRC_TYPE,
+				  resource_type);
 	ylimits = group_count == 3 ? NULL : &resource->limits[3];
 	ipa_resource_config_common(ipa, offset, &resource->limits[2], ylimits);
 
 	if (group_count < 5)
 		return;
 
-	offset = IPA_REG_SRC_RSRC_GRP_45_RSRC_TYPE_N_OFFSET(resource_type);
+	offset = ipa_reg_n_offset(ipa, SRC_RSRC_GRP_45_RSRC_TYPE,
+				  resource_type);
 	ylimits = group_count == 5 ? NULL : &resource->limits[5];
 	ipa_resource_config_common(ipa, offset, &resource->limits[4], ylimits);
 
 	if (group_count < 7)
 		return;
 
-	offset = IPA_REG_SRC_RSRC_GRP_67_RSRC_TYPE_N_OFFSET(resource_type);
+	offset = ipa_reg_n_offset(ipa, SRC_RSRC_GRP_67_RSRC_TYPE,
+				  resource_type);
 	ylimits = group_count == 7 ? NULL : &resource->limits[7];
 	ipa_resource_config_common(ipa, offset, &resource->limits[6], ylimits);
 }
@@ -131,28 +135,32 @@ static void ipa_resource_config_dst(struct ipa *ipa, u32 resource_type,
 
 	resource = &data->resource_dst[resource_type];
 
-	offset = IPA_REG_DST_RSRC_GRP_01_RSRC_TYPE_N_OFFSET(resource_type);
+	offset = ipa_reg_n_offset(ipa, DST_RSRC_GRP_01_RSRC_TYPE,
+				  resource_type);
 	ylimits = group_count == 1 ? NULL : &resource->limits[1];
 	ipa_resource_config_common(ipa, offset, &resource->limits[0], ylimits);
 
 	if (group_count < 3)
 		return;
 
-	offset = IPA_REG_DST_RSRC_GRP_23_RSRC_TYPE_N_OFFSET(resource_type);
+	offset = ipa_reg_n_offset(ipa, DST_RSRC_GRP_23_RSRC_TYPE,
+				  resource_type);
 	ylimits = group_count == 3 ? NULL : &resource->limits[3];
 	ipa_resource_config_common(ipa, offset, &resource->limits[2], ylimits);
 
 	if (group_count < 5)
 		return;
 
-	offset = IPA_REG_DST_RSRC_GRP_45_RSRC_TYPE_N_OFFSET(resource_type);
+	offset = ipa_reg_n_offset(ipa, DST_RSRC_GRP_45_RSRC_TYPE,
+				  resource_type);
 	ylimits = group_count == 5 ? NULL : &resource->limits[5];
 	ipa_resource_config_common(ipa, offset, &resource->limits[4], ylimits);
 
 	if (group_count < 7)
 		return;
 
-	offset = IPA_REG_DST_RSRC_GRP_67_RSRC_TYPE_N_OFFSET(resource_type);
+	offset = ipa_reg_n_offset(ipa, DST_RSRC_GRP_67_RSRC_TYPE,
+				  resource_type);
 	ylimits = group_count == 7 ? NULL : &resource->limits[7];
 	ipa_resource_config_common(ipa, offset, &resource->limits[6], ylimits);
 }
diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
index 037cec2fd5942..268e1df75bada 100644
--- a/drivers/net/ipa/ipa_table.c
+++ b/drivers/net/ipa/ipa_table.c
@@ -384,7 +384,7 @@ void ipa_table_reset(struct ipa *ipa, bool modem)
 
 int ipa_table_hash_flush(struct ipa *ipa)
 {
-	u32 offset = ipa_reg_filt_rout_hash_flush_offset(ipa->version);
+	u32 offset = ipa_reg_offset(ipa, FILT_ROUT_HASH_FLUSH);
 	struct gsi_trans *trans;
 	u32 val;
 
@@ -516,10 +516,11 @@ int ipa_table_setup(struct ipa *ipa)
 static void ipa_filter_tuple_zero(struct ipa_endpoint *endpoint)
 {
 	u32 endpoint_id = endpoint->endpoint_id;
+	struct ipa *ipa = endpoint->ipa;
 	u32 offset;
 	u32 val;
 
-	offset = IPA_REG_ENDP_FILTER_ROUTER_HSH_CFG_N_OFFSET(endpoint_id);
+	offset = ipa_reg_n_offset(ipa, ENDP_FILTER_ROUTER_HSH_CFG, endpoint_id);
 
 	val = ioread32(endpoint->ipa->reg_virt + offset);
 
@@ -565,9 +566,11 @@ static bool ipa_route_id_modem(u32 route_id)
  */
 static void ipa_route_tuple_zero(struct ipa *ipa, u32 route_id)
 {
-	u32 offset = IPA_REG_ENDP_FILTER_ROUTER_HSH_CFG_N_OFFSET(route_id);
+	u32 offset;
 	u32 val;
 
+	offset = ipa_reg_n_offset(ipa, ENDP_FILTER_ROUTER_HSH_CFG, route_id);
+
 	val = ioread32(ipa->reg_virt + offset);
 
 	/* Zero all route-related fields, preserving the rest */
diff --git a/drivers/net/ipa/ipa_uc.c b/drivers/net/ipa/ipa_uc.c
index fe11910518d95..dcfc000025ef1 100644
--- a/drivers/net/ipa/ipa_uc.c
+++ b/drivers/net/ipa/ipa_uc.c
@@ -222,7 +222,6 @@ void ipa_uc_power(struct ipa *ipa)
 static void send_uc_command(struct ipa *ipa, u32 command, u32 command_param)
 {
 	struct ipa_uc_mem_area *shared = ipa_uc_shared(ipa);
-	u32 offset;
 	u32 val;
 
 	/* Fill in the command data */
@@ -234,8 +233,7 @@ static void send_uc_command(struct ipa *ipa, u32 command, u32 command_param)
 
 	/* Use an interrupt to tell the microcontroller the command is ready */
 	val = u32_encode_bits(1, UC_INTR_FMASK);
-	offset = ipa_reg_irq_uc_offset(ipa->version);
-	iowrite32(val, ipa->reg_virt + offset);
+	iowrite32(val, ipa->reg_virt + ipa_reg_offset(ipa, IPA_IRQ_UC));
 }
 
 /* Tell the microcontroller the AP is shutting down */
-- 
2.34.1

