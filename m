Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7265EB438
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 00:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231401AbiIZWKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 18:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231177AbiIZWKA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 18:10:00 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18E69D123
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 15:09:52 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id r134so6403912iod.8
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 15:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=Io8blyxD/XnvAfKkl314iyqHYmUOlRzMg3efDz0eoQY=;
        b=jyhe7ROL0h5kOhC1HX4dhMMmkMjSIEZe18qInxMWdX3N/R8iLg045TWrG5VfWlarvW
         SCyPK31Jkmt3VAEflVymUymxwHDE9EYQlCtpT0CFGo8xIqhFIT7AG8VsXXtCO2X1oopL
         N44fUIDVzeaSDAhKCygKeq8thnlPfactfErsFIFVorVvoGdyU/MjmrzjiWRObMzvN5GS
         /sYgo+xrA35JzoG2TWK8heMPYaxtuz3RWDXg/m8C6CRYm7X2OBMnm9dvjluWvYwOJxGM
         1QN/m9p9dpizo+zgMXtWcaZdeewxEDvlpYRkJd9v3J7eG2/tMpdHe9CZ8ZHdyWY9OaxX
         ducw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=Io8blyxD/XnvAfKkl314iyqHYmUOlRzMg3efDz0eoQY=;
        b=mqhg56W4fVCCqgpi5NE5KApjCfNO+YcFVmlX2gyeOh7+tVEfInlUvJBdKDlyVCmwKC
         VpN4yoeuDGEcaOIWedgiZ3rl5UHqhdehsug0y4Y9e38zB2pZFWutBoArQzHS8Em5tp0o
         Dc0b7C/L/eJzCwvT0XvSUroUDnbl6/jYb2uBZcINdkYAHLiu4dftG9b4QLupL4utgC8P
         yCkMldaBo1Q456ctaVyINYYhU3MuUZ4kIxiHvobPzT9e04xysJ3AVHdimeMDWLfMjnnb
         zDhQfncq7qVh4gbqPHgovvv4g+Y9AL6GPdRJX+L/m1YIChyM1TqGNFApgCj5nIiQcm+x
         Ny9A==
X-Gm-Message-State: ACrzQf1mcxGHwzko3/ETavF64h1/eqiuYKKKOElMvbgHnLW+iOt6IT1T
        NXflH91rRbuASV30tQ20oDeXpw==
X-Google-Smtp-Source: AMsMyM4vwIRlMbKOtShJwUVBkC0MsvQdMSQO2z0G4E/Xwm2IbyY1zIkxgo1Byl/n/E54wjYM1jAg0Q==
X-Received: by 2002:a05:6602:1492:b0:6a1:e50d:ed7 with SMTP id a18-20020a056602149200b006a1e50d0ed7mr10677271iow.145.1664230191606;
        Mon, 26 Sep 2022 15:09:51 -0700 (PDT)
Received: from localhost.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id z20-20020a027a54000000b003567503cf92sm7631600jad.82.2022.09.26.15.09.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 15:09:51 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 05/15] net: ipa: introduce ipa_reg()
Date:   Mon, 26 Sep 2022 17:09:21 -0500
Message-Id: <20220926220931.3261749-6-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220926220931.3261749-1-elder@linaro.org>
References: <20220926220931.3261749-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_FILL_THIS_FORM_SHORT autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create a new function that returns a register descriptor given its
ID.  Change ipa_reg_offset() and ipa_reg_n_offset() so they take a
register descriptor argument rather than an IPA pointer and register
ID.  Have them accept null pointers (and return an invalid 0 offset),
to avoid the need for excessive error checking.  (A warning is issued
whenever ipa_reg() returns 0).

Call ipa_reg() or ipa_reg_n() to look up information about the
register before calls to ipa_reg_offset() and ipa_reg_n_offset().
Delay looking up offsets until they're needed to read or write
registers.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_cmd.c       |   7 +-
 drivers/net/ipa/ipa_endpoint.c  | 120 ++++++++++++++++++--------------
 drivers/net/ipa/ipa_interrupt.c |  40 +++++++----
 drivers/net/ipa/ipa_main.c      |  84 ++++++++++++----------
 drivers/net/ipa/ipa_mem.c       |  11 +--
 drivers/net/ipa/ipa_reg.c       |  11 +--
 drivers/net/ipa/ipa_reg.h       |  13 ++--
 drivers/net/ipa/ipa_resource.c  |  34 ++++-----
 drivers/net/ipa/ipa_table.c     |  14 +++-
 drivers/net/ipa/ipa_uc.c        |   5 +-
 10 files changed, 195 insertions(+), 144 deletions(-)

diff --git a/drivers/net/ipa/ipa_cmd.c b/drivers/net/ipa/ipa_cmd.c
index 191fb3d0b1e53..f762d7d5f31fa 100644
--- a/drivers/net/ipa/ipa_cmd.c
+++ b/drivers/net/ipa/ipa_cmd.c
@@ -305,6 +305,7 @@ static bool ipa_cmd_register_write_offset_valid(struct ipa *ipa,
 /* Check whether offsets passed to register_write are valid */
 static bool ipa_cmd_register_write_valid(struct ipa *ipa)
 {
+	const struct ipa_reg *reg;
 	const char *name;
 	u32 offset;
 
@@ -312,7 +313,8 @@ static bool ipa_cmd_register_write_valid(struct ipa *ipa)
 	 * offset will fit in a register write IPA immediate command.
 	 */
 	if (ipa_table_hash_support(ipa)) {
-		offset = ipa_reg_offset(ipa, FILT_ROUT_HASH_FLUSH);
+		reg = ipa_reg(ipa, FILT_ROUT_HASH_FLUSH);
+		offset = ipa_reg_offset(reg);
 		name = "filter/route hash flush";
 		if (!ipa_cmd_register_write_offset_valid(ipa, name, offset))
 			return false;
@@ -325,7 +327,8 @@ static bool ipa_cmd_register_write_valid(struct ipa *ipa)
 	 * worst case (highest endpoint number) offset of that endpoint
 	 * fits in the register write command field(s) that must hold it.
 	 */
-	offset = ipa_reg_n_offset(ipa, ENDP_STATUS, IPA_ENDPOINT_COUNT - 1);
+	reg = ipa_reg(ipa, ENDP_STATUS);
+	offset = ipa_reg_n_offset(reg, IPA_ENDPOINT_COUNT - 1);
 	name = "maximal endpoint status";
 	if (!ipa_cmd_register_write_offset_valid(ipa, name, offset))
 		return false;
diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index a5408b6b05613..9dc63bc7d57f9 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -309,6 +309,7 @@ static bool
 ipa_endpoint_init_ctrl(struct ipa_endpoint *endpoint, bool suspend_delay)
 {
 	struct ipa *ipa = endpoint->ipa;
+	const struct ipa_reg *reg;
 	u32 offset;
 	bool state;
 	u32 mask;
@@ -319,11 +320,11 @@ ipa_endpoint_init_ctrl(struct ipa_endpoint *endpoint, bool suspend_delay)
 	else
 		WARN_ON(ipa->version >= IPA_VERSION_4_0);
 
-	offset = ipa_reg_n_offset(ipa, ENDP_INIT_CTRL, endpoint->endpoint_id);
-
+	reg = ipa_reg(ipa, ENDP_INIT_CTRL);
 	mask = endpoint->toward_ipa ? ENDP_DELAY_FMASK : ENDP_SUSPEND_FMASK;
-
+	offset = ipa_reg_n_offset(reg, endpoint->endpoint_id);
 	val = ioread32(ipa->reg_virt + offset);
+
 	state = !!(val & mask);
 
 	/* Don't bother if it's already in the requested state */
@@ -350,11 +351,13 @@ static bool ipa_endpoint_aggr_active(struct ipa_endpoint *endpoint)
 {
 	u32 mask = BIT(endpoint->endpoint_id);
 	struct ipa *ipa = endpoint->ipa;
+	const struct ipa_reg *reg;
 	u32 val;
 
 	WARN_ON(!(mask & ipa->available));
 
-	val = ioread32(ipa->reg_virt + ipa_reg_offset(ipa, STATE_AGGR_ACTIVE));
+	reg = ipa_reg(ipa, STATE_AGGR_ACTIVE);
+	val = ioread32(ipa->reg_virt + ipa_reg_offset(reg));
 
 	return !!(val & mask);
 }
@@ -363,10 +366,12 @@ static void ipa_endpoint_force_close(struct ipa_endpoint *endpoint)
 {
 	u32 mask = BIT(endpoint->endpoint_id);
 	struct ipa *ipa = endpoint->ipa;
+	const struct ipa_reg *reg;
 
 	WARN_ON(!(mask & ipa->available));
 
-	iowrite32(mask, ipa->reg_virt + ipa_reg_offset(ipa, AGGR_FORCE_CLOSE));
+	reg = ipa_reg(ipa, AGGR_FORCE_CLOSE);
+	iowrite32(mask, ipa->reg_virt + ipa_reg_offset(reg));
 }
 
 /**
@@ -465,6 +470,7 @@ int ipa_endpoint_modem_exception_reset_all(struct ipa *ipa)
 	while (initialized) {
 		u32 endpoint_id = __ffs(initialized);
 		struct ipa_endpoint *endpoint;
+		const struct ipa_reg *reg;
 		u32 offset;
 
 		initialized ^= BIT(endpoint_id);
@@ -474,7 +480,8 @@ int ipa_endpoint_modem_exception_reset_all(struct ipa *ipa)
 		if (!(endpoint->ee_id == GSI_EE_MODEM && endpoint->toward_ipa))
 			continue;
 
-		offset = ipa_reg_n_offset(ipa, ENDP_STATUS, endpoint_id);
+		reg = ipa_reg(ipa, ENDP_STATUS);
+		offset = ipa_reg_n_offset(reg, endpoint_id);
 
 		/* Value written is 0, and all bits are updated.  That
 		 * means status is disabled on the endpoint, and as a
@@ -494,13 +501,13 @@ int ipa_endpoint_modem_exception_reset_all(struct ipa *ipa)
 
 static void ipa_endpoint_init_cfg(struct ipa_endpoint *endpoint)
 {
+	u32 endpoint_id = endpoint->endpoint_id;
 	struct ipa *ipa = endpoint->ipa;
 	enum ipa_cs_offload_en enabled;
+	const struct ipa_reg *reg;
 	u32 val = 0;
-	u32 offset;
-
-	offset = ipa_reg_n_offset(ipa, ENDP_INIT_CFG, endpoint->endpoint_id);
 
+	reg = ipa_reg(ipa, ENDP_INIT_CFG);
 	/* FRAG_OFFLOAD_EN is 0 */
 	if (endpoint->config.checksum) {
 		enum ipa_version version = ipa->version;
@@ -528,23 +535,23 @@ static void ipa_endpoint_init_cfg(struct ipa_endpoint *endpoint)
 	val |= u32_encode_bits(enabled, CS_OFFLOAD_EN_FMASK);
 	/* CS_GEN_QMB_MASTER_SEL is 0 */
 
-	iowrite32(val, ipa->reg_virt + offset);
+	iowrite32(val, ipa->reg_virt + ipa_reg_n_offset(reg, endpoint_id));
 }
 
 static void ipa_endpoint_init_nat(struct ipa_endpoint *endpoint)
 {
+	u32 endpoint_id = endpoint->endpoint_id;
 	struct ipa *ipa = endpoint->ipa;
-	u32 offset;
+	const struct ipa_reg *reg;
 	u32 val;
 
 	if (!endpoint->toward_ipa)
 		return;
 
-	offset = ipa_reg_n_offset(ipa, ENDP_INIT_NAT, endpoint->endpoint_id);
-
+	reg = ipa_reg(ipa, ENDP_INIT_NAT);
 	val = u32_encode_bits(IPA_NAT_BYPASS, NAT_EN_FMASK);
 
-	iowrite32(val, ipa->reg_virt + offset);
+	iowrite32(val, ipa->reg_virt + ipa_reg_n_offset(reg, endpoint_id));
 }
 
 static u32
@@ -591,12 +598,12 @@ ipa_qmap_header_size(enum ipa_version version, struct ipa_endpoint *endpoint)
  */
 static void ipa_endpoint_init_hdr(struct ipa_endpoint *endpoint)
 {
+	u32 endpoint_id = endpoint->endpoint_id;
 	struct ipa *ipa = endpoint->ipa;
+	const struct ipa_reg *reg;
 	u32 val = 0;
-	u32 offset;
-
-	offset = ipa_reg_n_offset(ipa, ENDP_INIT_HDR, endpoint->endpoint_id);
 
+	reg = ipa_reg(ipa, ENDP_INIT_HDR);
 	if (endpoint->config.qmap) {
 		enum ipa_version version = ipa->version;
 		size_t header_size;
@@ -630,19 +637,18 @@ static void ipa_endpoint_init_hdr(struct ipa_endpoint *endpoint)
 		/* HDR_METADATA_REG_VALID is 0 (TX only, version < v4.5) */
 	}
 
-	iowrite32(val, ipa->reg_virt + offset);
+	iowrite32(val, ipa->reg_virt + ipa_reg_n_offset(reg, endpoint_id));
 }
 
 static void ipa_endpoint_init_hdr_ext(struct ipa_endpoint *endpoint)
 {
 	u32 pad_align = endpoint->config.rx.pad_align;
+	u32 endpoint_id = endpoint->endpoint_id;
 	struct ipa *ipa = endpoint->ipa;
+	const struct ipa_reg *reg;
 	u32 val = 0;
-	u32 offset;
-
-	offset = ipa_reg_n_offset(ipa, ENDP_INIT_HDR_EXT,
-				  endpoint->endpoint_id);
 
+	reg = ipa_reg(ipa, ENDP_INIT_HDR_EXT);
 	if (endpoint->config.qmap) {
 		/* We have a header, so we must specify its endianness */
 		val |= HDR_ENDIANNESS_FMASK;	/* big endian */
@@ -682,21 +688,22 @@ static void ipa_endpoint_init_hdr_ext(struct ipa_endpoint *endpoint)
 		}
 	}
 
-	iowrite32(val, ipa->reg_virt + offset);
+	iowrite32(val, ipa->reg_virt + ipa_reg_n_offset(reg, endpoint_id));
 }
 
 static void ipa_endpoint_init_hdr_metadata_mask(struct ipa_endpoint *endpoint)
 {
 	u32 endpoint_id = endpoint->endpoint_id;
 	struct ipa *ipa = endpoint->ipa;
+	const struct ipa_reg *reg;
 	u32 val = 0;
 	u32 offset;
 
 	if (endpoint->toward_ipa)
 		return;		/* Register not valid for TX endpoints */
 
-	offset = ipa_reg_n_offset(ipa, ENDP_INIT_HDR_METADATA_MASK,
-				  endpoint_id);
+	reg = ipa_reg(ipa,  ENDP_INIT_HDR_METADATA_MASK);
+	offset = ipa_reg_n_offset(reg, endpoint_id);
 
 	/* Note that HDR_ENDIANNESS indicates big endian header fields */
 	if (endpoint->config.qmap)
@@ -708,14 +715,15 @@ static void ipa_endpoint_init_hdr_metadata_mask(struct ipa_endpoint *endpoint)
 static void ipa_endpoint_init_mode(struct ipa_endpoint *endpoint)
 {
 	struct ipa *ipa = endpoint->ipa;
+	const struct ipa_reg *reg;
 	u32 offset;
 	u32 val;
 
 	if (!endpoint->toward_ipa)
 		return;		/* Register not valid for RX endpoints */
 
-	offset = ipa_reg_n_offset(ipa, ENDP_INIT_MODE, endpoint->endpoint_id);
-
+	reg = ipa_reg(ipa, ENDP_INIT_MODE);
+	offset = ipa_reg_n_offset(reg, endpoint->endpoint_id);
 	if (endpoint->config.dma_mode) {
 		enum ipa_endpoint_name name = endpoint->config.dma_endpoint;
 		u32 dma_endpoint_id;
@@ -814,12 +822,12 @@ static u32 aggr_sw_eof_active_encoded(enum ipa_version version, bool enabled)
 
 static void ipa_endpoint_init_aggr(struct ipa_endpoint *endpoint)
 {
+	u32 endpoint_id = endpoint->endpoint_id;
 	struct ipa *ipa = endpoint->ipa;
+	const struct ipa_reg *reg;
 	u32 val = 0;
-	u32 offset;
-
-	offset = ipa_reg_n_offset(ipa, ENDP_INIT_AGGR, endpoint->endpoint_id);
 
+	reg = ipa_reg(ipa, ENDP_INIT_AGGR);
 	if (endpoint->config.aggregation) {
 		if (!endpoint->toward_ipa) {
 			const struct ipa_endpoint_rx *rx_config;
@@ -857,7 +865,7 @@ static void ipa_endpoint_init_aggr(struct ipa_endpoint *endpoint)
 		/* other fields ignored */
 	}
 
-	iowrite32(val, ipa->reg_virt + offset);
+	iowrite32(val, ipa->reg_virt + ipa_reg_n_offset(reg, endpoint_id));
 }
 
 /* The head-of-line blocking timer is defined as a tick count.  For
@@ -938,14 +946,14 @@ static void ipa_endpoint_init_hol_block_timer(struct ipa_endpoint *endpoint,
 {
 	u32 endpoint_id = endpoint->endpoint_id;
 	struct ipa *ipa = endpoint->ipa;
-	u32 offset;
+	const struct ipa_reg *reg;
 	u32 val;
 
 	/* This should only be changed when HOL_BLOCK_EN is disabled */
+	reg = ipa_reg(ipa, ENDP_INIT_HOL_BLOCK_TIMER);
 	val = hol_block_timer_encode(ipa, microseconds);
 
-	offset = ipa_reg_n_offset(ipa, ENDP_INIT_HOL_BLOCK_TIMER, endpoint_id);
-	iowrite32(val, ipa->reg_virt + offset);
+	iowrite32(val, ipa->reg_virt + ipa_reg_n_offset(reg, endpoint_id));
 }
 
 static void
@@ -953,11 +961,12 @@ ipa_endpoint_init_hol_block_en(struct ipa_endpoint *endpoint, bool enable)
 {
 	u32 endpoint_id = endpoint->endpoint_id;
 	struct ipa *ipa = endpoint->ipa;
+	const struct ipa_reg *reg;
 	u32 offset;
 	u32 val;
 
-	offset = ipa_reg_n_offset(ipa, ENDP_INIT_HOL_BLOCK_EN, endpoint_id);
-
+	reg = ipa_reg(ipa, ENDP_INIT_HOL_BLOCK_EN);
+	offset = ipa_reg_n_offset(reg, endpoint_id);
 	val = enable ? HOL_BLOCK_EN_FMASK : 0;
 
 	iowrite32(val, ipa->reg_virt + offset);
@@ -997,47 +1006,47 @@ void ipa_endpoint_modem_hol_block_clear_all(struct ipa *ipa)
 
 static void ipa_endpoint_init_deaggr(struct ipa_endpoint *endpoint)
 {
+	u32 endpoint_id = endpoint->endpoint_id;
 	struct ipa *ipa = endpoint->ipa;
+	const struct ipa_reg *reg;
 	u32 val = 0;
-	u32 offset;
 
 	if (!endpoint->toward_ipa)
 		return;		/* Register not valid for RX endpoints */
 
-	offset = ipa_reg_n_offset(ipa, ENDP_INIT_DEAGGR, endpoint->endpoint_id);
-
+	reg = ipa_reg(ipa, ENDP_INIT_DEAGGR);
 	/* DEAGGR_HDR_LEN is 0 */
 	/* PACKET_OFFSET_VALID is 0 */
 	/* PACKET_OFFSET_LOCATION is ignored (not valid) */
 	/* MAX_PACKET_LEN is 0 (not enforced) */
 
-	iowrite32(val, ipa->reg_virt + offset);
+	iowrite32(val, ipa->reg_virt + ipa_reg_n_offset(reg, endpoint_id));
 }
 
 static void ipa_endpoint_init_rsrc_grp(struct ipa_endpoint *endpoint)
 {
+	u32 endpoint_id = endpoint->endpoint_id;
 	struct ipa *ipa = endpoint->ipa;
-	u32 offset;
+	const struct ipa_reg *reg;
 	u32 val;
 
-	offset = ipa_reg_n_offset(ipa, ENDP_INIT_RSRC_GRP,
-				  endpoint->endpoint_id);
-
+	reg = ipa_reg(ipa, ENDP_INIT_RSRC_GRP);
 	val = rsrc_grp_encoded(ipa->version, endpoint->config.resource_group);
 
-	iowrite32(val, ipa->reg_virt + offset);
+	iowrite32(val, ipa->reg_virt + ipa_reg_n_offset(reg, endpoint_id));
 }
 
 static void ipa_endpoint_init_seq(struct ipa_endpoint *endpoint)
 {
+	u32 endpoint_id = endpoint->endpoint_id;
 	struct ipa *ipa = endpoint->ipa;
+	const struct ipa_reg *reg;
 	u32 val = 0;
-	u32 offset;
 
 	if (!endpoint->toward_ipa)
 		return;		/* Register not valid for RX endpoints */
 
-	offset = ipa_reg_n_offset(ipa, ENDP_INIT_SEQ, endpoint->endpoint_id);
+	reg = ipa_reg(ipa, ENDP_INIT_SEQ);
 
 	/* Low-order byte configures primary packet processing */
 	val |= u32_encode_bits(endpoint->config.tx.seq_type, SEQ_TYPE_FMASK);
@@ -1047,7 +1056,7 @@ static void ipa_endpoint_init_seq(struct ipa_endpoint *endpoint)
 		val |= u32_encode_bits(endpoint->config.tx.seq_rep_type,
 				       SEQ_REP_TYPE_FMASK);
 
-	iowrite32(val, ipa->reg_virt + offset);
+	iowrite32(val, ipa->reg_virt + ipa_reg_n_offset(reg, endpoint_id));
 }
 
 /**
@@ -1097,11 +1106,10 @@ static void ipa_endpoint_status(struct ipa_endpoint *endpoint)
 {
 	u32 endpoint_id = endpoint->endpoint_id;
 	struct ipa *ipa = endpoint->ipa;
+	const struct ipa_reg *reg;
 	u32 val = 0;
-	u32 offset;
-
-	offset = ipa_reg_n_offset(ipa, ENDP_STATUS, endpoint_id);
 
+	reg = ipa_reg(ipa, ENDP_STATUS);
 	if (endpoint->config.status_enable) {
 		val |= STATUS_EN_FMASK;
 		if (endpoint->toward_ipa) {
@@ -1120,7 +1128,7 @@ static void ipa_endpoint_status(struct ipa_endpoint *endpoint)
 		/* STATUS_PKT_SUPPRESS_FMASK is 0 (not present for v3.5.1) */
 	}
 
-	iowrite32(val, ipa->reg_virt + offset);
+	iowrite32(val, ipa->reg_virt + ipa_reg_n_offset(reg, endpoint_id));
 }
 
 static int ipa_endpoint_replenish_one(struct ipa_endpoint *endpoint,
@@ -1460,8 +1468,10 @@ void ipa_endpoint_trans_release(struct ipa_endpoint *endpoint,
 
 void ipa_endpoint_default_route_set(struct ipa *ipa, u32 endpoint_id)
 {
+	const struct ipa_reg *reg;
 	u32 val;
 
+	reg = ipa_reg(ipa, ROUTE);
 	/* ROUTE_DIS is 0 */
 	val = u32_encode_bits(endpoint_id, ROUTE_DEF_PIPE_FMASK);
 	val |= ROUTE_DEF_HDR_TABLE_FMASK;
@@ -1469,7 +1479,7 @@ void ipa_endpoint_default_route_set(struct ipa *ipa, u32 endpoint_id)
 	val |= u32_encode_bits(endpoint_id, ROUTE_FRAG_DEF_PIPE_FMASK);
 	val |= ROUTE_DEF_RETAIN_HDR_FMASK;
 
-	iowrite32(val, ipa->reg_virt + ipa_reg_offset(ipa, ROUTE));
+	iowrite32(val, ipa->reg_virt + ipa_reg_offset(reg));
 }
 
 void ipa_endpoint_default_route_clear(struct ipa *ipa)
@@ -1813,6 +1823,7 @@ void ipa_endpoint_teardown(struct ipa *ipa)
 int ipa_endpoint_config(struct ipa *ipa)
 {
 	struct device *dev = &ipa->pdev->dev;
+	const struct ipa_reg *reg;
 	u32 initialized;
 	u32 rx_base;
 	u32 rx_mask;
@@ -1839,7 +1850,8 @@ int ipa_endpoint_config(struct ipa *ipa)
 	/* Find out about the endpoints supplied by the hardware, and ensure
 	 * the highest one doesn't exceed the number we support.
 	 */
-	val = ioread32(ipa->reg_virt + ipa_reg_offset(ipa, FLAVOR_0));
+	reg = ipa_reg(ipa, FLAVOR_0);
+	val = ioread32(ipa->reg_virt + ipa_reg_offset(reg));
 
 	/* Our RX is an IPA producer */
 	rx_base = u32_get_bits(val, IPA_PROD_LOWEST_FMASK);
diff --git a/drivers/net/ipa/ipa_interrupt.c b/drivers/net/ipa/ipa_interrupt.c
index 48065c2d55afc..d0142b17a2757 100644
--- a/drivers/net/ipa/ipa_interrupt.c
+++ b/drivers/net/ipa/ipa_interrupt.c
@@ -53,13 +53,15 @@ static void ipa_interrupt_process(struct ipa_interrupt *interrupt, u32 irq_id)
 {
 	bool uc_irq = ipa_interrupt_uc(interrupt, irq_id);
 	struct ipa *ipa = interrupt->ipa;
+	const struct ipa_reg *reg;
 	u32 mask = BIT(irq_id);
 	u32 offset;
 
 	/* For microcontroller interrupts, clear the interrupt right away,
 	 * "to avoid clearing unhandled interrupts."
 	 */
-	offset = ipa_reg_offset(ipa, IPA_IRQ_CLR);
+	reg = ipa_reg(ipa, IPA_IRQ_CLR);
+	offset = ipa_reg_offset(reg);
 	if (uc_irq)
 		iowrite32(mask, ipa->reg_virt + offset);
 
@@ -80,6 +82,7 @@ static irqreturn_t ipa_isr_thread(int irq, void *dev_id)
 	struct ipa_interrupt *interrupt = dev_id;
 	struct ipa *ipa = interrupt->ipa;
 	u32 enabled = interrupt->enabled;
+	const struct ipa_reg *reg;
 	struct device *dev;
 	u32 pending;
 	u32 offset;
@@ -95,7 +98,8 @@ static irqreturn_t ipa_isr_thread(int irq, void *dev_id)
 	 * including conditions whose interrupt is not enabled.  Handle
 	 * only the enabled ones.
 	 */
-	offset = ipa_reg_offset(ipa, IPA_IRQ_STTS);
+	reg = ipa_reg(ipa, IPA_IRQ_STTS);
+	offset = ipa_reg_offset(reg);
 	pending = ioread32(ipa->reg_virt + offset);
 	while ((mask = pending & enabled)) {
 		do {
@@ -112,7 +116,8 @@ static irqreturn_t ipa_isr_thread(int irq, void *dev_id)
 	if (pending) {
 		dev_dbg(dev, "clearing disabled IPA interrupts 0x%08x\n",
 			pending);
-		offset = ipa_reg_offset(ipa, IPA_IRQ_CLR);
+		reg = ipa_reg(ipa, IPA_IRQ_CLR);
+		offset = ipa_reg_offset(reg);
 		iowrite32(pending, ipa->reg_virt + offset);
 	}
 out_power_put:
@@ -128,6 +133,7 @@ static void ipa_interrupt_suspend_control(struct ipa_interrupt *interrupt,
 {
 	struct ipa *ipa = interrupt->ipa;
 	u32 mask = BIT(endpoint_id);
+	const struct ipa_reg *reg;
 	u32 offset;
 	u32 val;
 
@@ -137,7 +143,8 @@ static void ipa_interrupt_suspend_control(struct ipa_interrupt *interrupt,
 	if (ipa->version == IPA_VERSION_3_0)
 		return;
 
-	offset = ipa_reg_offset(ipa, IRQ_SUSPEND_EN);
+	reg = ipa_reg(ipa, IRQ_SUSPEND_EN);
+	offset = ipa_reg_offset(reg);
 	val = ioread32(ipa->reg_virt + offset);
 	if (enable)
 		val |= mask;
@@ -164,15 +171,18 @@ ipa_interrupt_suspend_disable(struct ipa_interrupt *interrupt, u32 endpoint_id)
 void ipa_interrupt_suspend_clear_all(struct ipa_interrupt *interrupt)
 {
 	struct ipa *ipa = interrupt->ipa;
+	const struct ipa_reg *reg;
 	u32 val;
 
-	val = ioread32(ipa->reg_virt + ipa_reg_offset(ipa, IRQ_SUSPEND_INFO));
+	reg = ipa_reg(ipa, IRQ_SUSPEND_INFO);
+	val = ioread32(ipa->reg_virt + ipa_reg_offset(reg));
 
 	/* SUSPEND interrupt status isn't cleared on IPA version 3.0 */
 	if (ipa->version == IPA_VERSION_3_0)
 		return;
 
-	iowrite32(val, ipa->reg_virt + ipa_reg_offset(ipa, IRQ_SUSPEND_CLR));
+	reg = ipa_reg(ipa, IRQ_SUSPEND_CLR);
+	iowrite32(val, ipa->reg_virt + ipa_reg_offset(reg));
 }
 
 /* Simulate arrival of an IPA TX_SUSPEND interrupt */
@@ -186,7 +196,7 @@ void ipa_interrupt_add(struct ipa_interrupt *interrupt,
 		       enum ipa_irq_id ipa_irq, ipa_irq_handler_t handler)
 {
 	struct ipa *ipa = interrupt->ipa;
-	u32 offset;
+	const struct ipa_reg *reg;
 
 	if (WARN_ON(ipa_irq >= IPA_IRQ_COUNT))
 		return;
@@ -195,8 +205,9 @@ void ipa_interrupt_add(struct ipa_interrupt *interrupt,
 
 	/* Update the IPA interrupt mask to enable it */
 	interrupt->enabled |= BIT(ipa_irq);
-	offset = ipa_reg_offset(ipa, IPA_IRQ_EN);
-	iowrite32(interrupt->enabled, ipa->reg_virt + offset);
+
+	reg = ipa_reg(ipa, IPA_IRQ_EN);
+	iowrite32(interrupt->enabled, ipa->reg_virt + ipa_reg_offset(reg));
 }
 
 /* Remove the handler for an IPA interrupt type */
@@ -204,15 +215,16 @@ void
 ipa_interrupt_remove(struct ipa_interrupt *interrupt, enum ipa_irq_id ipa_irq)
 {
 	struct ipa *ipa = interrupt->ipa;
-	u32 offset;
+	const struct ipa_reg *reg;
 
 	if (WARN_ON(ipa_irq >= IPA_IRQ_COUNT))
 		return;
 
 	/* Update the IPA interrupt mask to disable it */
 	interrupt->enabled &= ~BIT(ipa_irq);
-	offset = ipa_reg_offset(ipa, IPA_IRQ_EN);
-	iowrite32(interrupt->enabled, ipa->reg_virt + offset);
+
+	reg = ipa_reg(ipa, IPA_IRQ_EN);
+	iowrite32(interrupt->enabled, ipa->reg_virt + ipa_reg_offset(reg));
 
 	interrupt->handler[ipa_irq] = NULL;
 }
@@ -222,6 +234,7 @@ struct ipa_interrupt *ipa_interrupt_config(struct ipa *ipa)
 {
 	struct device *dev = &ipa->pdev->dev;
 	struct ipa_interrupt *interrupt;
+	const struct ipa_reg *reg;
 	unsigned int irq;
 	int ret;
 
@@ -240,7 +253,8 @@ struct ipa_interrupt *ipa_interrupt_config(struct ipa *ipa)
 	interrupt->irq = irq;
 
 	/* Start with all IPA interrupts disabled */
-	iowrite32(0, ipa->reg_virt + ipa_reg_offset(ipa, IPA_IRQ_EN));
+	reg = ipa_reg(ipa, IPA_IRQ_EN);
+	iowrite32(0, ipa->reg_virt + ipa_reg_offset(reg));
 
 	ret = request_threaded_irq(irq, NULL, ipa_isr_thread, IRQF_ONESHOT,
 				   "ipa", interrupt);
diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 04eb4a019591d..37c8666528548 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -186,20 +186,22 @@ static void ipa_teardown(struct ipa *ipa)
 static void
 ipa_hardware_config_bcr(struct ipa *ipa, const struct ipa_data *data)
 {
+	const struct ipa_reg *reg;
 	u32 val;
 
 	/* IPA v4.5+ has no backward compatibility register */
 	if (ipa->version >= IPA_VERSION_4_5)
 		return;
 
+	reg = ipa_reg(ipa, IPA_BCR);
 	val = data->backward_compat;
-
-	iowrite32(val, ipa->reg_virt + ipa_reg_offset(ipa, IPA_BCR));
+	iowrite32(val, ipa->reg_virt + ipa_reg_offset(reg));
 }
 
 static void ipa_hardware_config_tx(struct ipa *ipa)
 {
 	enum ipa_version version = ipa->version;
+	const struct ipa_reg *reg;
 	u32 offset;
 	u32 val;
 
@@ -207,7 +209,9 @@ static void ipa_hardware_config_tx(struct ipa *ipa)
 		return;
 
 	/* Disable PA mask to allow HOLB drop */
-	offset = ipa_reg_offset(ipa, IPA_TX_CFG);
+	reg = ipa_reg(ipa, IPA_TX_CFG);
+	offset = ipa_reg_offset(reg);
+
 	val = ioread32(ipa->reg_virt + offset);
 
 	val &= ~PA_MASK_EN_FMASK;
@@ -218,28 +222,29 @@ static void ipa_hardware_config_tx(struct ipa *ipa)
 static void ipa_hardware_config_clkon(struct ipa *ipa)
 {
 	enum ipa_version version = ipa->version;
+	const struct ipa_reg *reg;
 	u32 val;
 
-	if (version < IPA_VERSION_3_1 || version >= IPA_VERSION_4_5)
+	if (version >= IPA_VERSION_4_5)
+		return;
+
+	if (version < IPA_VERSION_4_0 && version != IPA_VERSION_3_1)
 		return;
 
 	/* Implement some hardware workarounds */
-
-	if (version >= IPA_VERSION_4_0) {
-		/* Enable open global clocks in the CLKON configuration */
-		val = GLOBAL_FMASK | GLOBAL_2X_CLK_FMASK;
-	} else if (version == IPA_VERSION_3_1) {
+	reg = ipa_reg(ipa, CLKON_CFG);
+	if (version == IPA_VERSION_3_1)
 		val = MISC_FMASK;	/* Disable MISC clock gating */
-	} else {
-		return;
-	}
+	else	/* Enable open global clocks in the CLKON configuration */
+		val = GLOBAL_FMASK | GLOBAL_2X_CLK_FMASK;	/* IPA v4.0+ */
 
-	iowrite32(val, ipa->reg_virt + ipa_reg_offset(ipa, CLKON_CFG));
+	iowrite32(val, ipa->reg_virt + ipa_reg_offset(reg));
 }
 
 /* Configure bus access behavior for IPA components */
 static void ipa_hardware_config_comp(struct ipa *ipa)
 {
+	const struct ipa_reg *reg;
 	u32 offset;
 	u32 val;
 
@@ -247,7 +252,8 @@ static void ipa_hardware_config_comp(struct ipa *ipa)
 	if (ipa->version < IPA_VERSION_4_0)
 		return;
 
-	offset = ipa_reg_offset(ipa, COMP_CFG);
+	reg = ipa_reg(ipa, COMP_CFG);
+	offset = ipa_reg_offset(reg);
 	val = ioread32(ipa->reg_virt + offset);
 
 	if (ipa->version == IPA_VERSION_4_0) {
@@ -272,6 +278,7 @@ ipa_hardware_config_qsb(struct ipa *ipa, const struct ipa_data *data)
 {
 	const struct ipa_qsb_data *data0;
 	const struct ipa_qsb_data *data1;
+	const struct ipa_reg *reg;
 	u32 val;
 
 	/* QMB 0 represents DDR; QMB 1 (if present) represents PCIe */
@@ -280,13 +287,18 @@ ipa_hardware_config_qsb(struct ipa *ipa, const struct ipa_data *data)
 		data1 = &data->qsb_data[IPA_QSB_MASTER_PCIE];
 
 	/* Max outstanding write accesses for QSB masters */
+	reg = ipa_reg(ipa, QSB_MAX_WRITES);
+
 	val = u32_encode_bits(data0->max_writes, GEN_QMB_0_MAX_WRITES_FMASK);
 	if (data->qsb_count > 1)
 		val |= u32_encode_bits(data1->max_writes,
 				       GEN_QMB_1_MAX_WRITES_FMASK);
-	iowrite32(val, ipa->reg_virt + ipa_reg_offset(ipa, QSB_MAX_WRITES));
+
+	iowrite32(val, ipa->reg_virt + ipa_reg_offset(reg));
 
 	/* Max outstanding read accesses for QSB masters */
+	reg = ipa_reg(ipa, QSB_MAX_READS);
+
 	val = u32_encode_bits(data0->max_reads, GEN_QMB_0_MAX_READS_FMASK);
 	if (ipa->version >= IPA_VERSION_4_0)
 		val |= u32_encode_bits(data0->max_reads_beats,
@@ -298,7 +310,8 @@ ipa_hardware_config_qsb(struct ipa *ipa, const struct ipa_data *data)
 			val |= u32_encode_bits(data1->max_reads_beats,
 					       GEN_QMB_1_MAX_READS_BEATS_FMASK);
 	}
-	iowrite32(val, ipa->reg_virt + ipa_reg_offset(ipa, QSB_MAX_READS));
+
+	iowrite32(val, ipa->reg_virt + ipa_reg_offset(reg));
 }
 
 /* The internal inactivity timer clock is used for the aggregation timer */
@@ -334,13 +347,15 @@ static __always_inline u32 ipa_aggr_granularity_val(u32 usec)
  */
 static void ipa_qtime_config(struct ipa *ipa)
 {
+	const struct ipa_reg *reg;
 	u32 offset;
 	u32 val;
 
 	/* Timer clock divider must be disabled when we change the rate */
-	offset = ipa_reg_offset(ipa, TIMERS_XO_CLK_DIV_CFG);
-	iowrite32(0, ipa->reg_virt + offset);
+	reg = ipa_reg(ipa, TIMERS_XO_CLK_DIV_CFG);
+	iowrite32(0, ipa->reg_virt + ipa_reg_offset(reg));
 
+	reg = ipa_reg(ipa, QTIME_TIMESTAMP_CFG);
 	/* Set DPL time stamp resolution to use Qtime (instead of 1 msec) */
 	val = u32_encode_bits(DPL_TIMESTAMP_SHIFT, DPL_TIMESTAMP_LSB_FMASK);
 	val |= u32_encode_bits(1, DPL_TIMESTAMP_SEL_FMASK);
@@ -348,21 +363,21 @@ static void ipa_qtime_config(struct ipa *ipa)
 	val |= u32_encode_bits(TAG_TIMESTAMP_SHIFT, TAG_TIMESTAMP_LSB_FMASK);
 	val |= u32_encode_bits(NAT_TIMESTAMP_SHIFT, NAT_TIMESTAMP_LSB_FMASK);
 
-	offset = ipa_reg_offset(ipa, QTIME_TIMESTAMP_CFG);
-	iowrite32(val, ipa->reg_virt + offset);
+	iowrite32(val, ipa->reg_virt + ipa_reg_offset(reg));
 
 	/* Set granularity of pulse generators used for other timers */
+	reg = ipa_reg(ipa, TIMERS_PULSE_GRAN_CFG);
 	val = u32_encode_bits(IPA_GRAN_100_US, GRAN_0_FMASK);
 	val |= u32_encode_bits(IPA_GRAN_1_MS, GRAN_1_FMASK);
 	val |= u32_encode_bits(IPA_GRAN_1_MS, GRAN_2_FMASK);
 
-	offset = ipa_reg_offset(ipa, TIMERS_PULSE_GRAN_CFG);
-	iowrite32(val, ipa->reg_virt + offset);
+	iowrite32(val, ipa->reg_virt + ipa_reg_offset(reg));
 
 	/* Actual divider is 1 more than value supplied here */
+	reg = ipa_reg(ipa, TIMERS_XO_CLK_DIV_CFG);
+	offset = ipa_reg_offset(reg);
 	val = u32_encode_bits(IPA_XO_CLOCK_DIVIDER - 1, DIV_VALUE_FMASK);
 
-	offset = ipa_reg_offset(ipa, TIMERS_XO_CLK_DIV_CFG);
 	iowrite32(val, ipa->reg_virt + offset);
 
 	/* Divider value is set; re-enable the common timer clock divider */
@@ -374,16 +389,13 @@ static void ipa_qtime_config(struct ipa *ipa)
 /* Before IPA v4.5 timing is controlled by a counter register */
 static void ipa_hardware_config_counter(struct ipa *ipa)
 {
-	u32 granularity;
-	u32 offset;
+	u32 granularity = ipa_aggr_granularity_val(IPA_AGGR_GRANULARITY);
+	const struct ipa_reg *reg;
 	u32 val;
 
-	granularity = ipa_aggr_granularity_val(IPA_AGGR_GRANULARITY);
-
+	reg = ipa_reg(ipa, COUNTER_CFG);
 	val = u32_encode_bits(granularity, AGGR_GRANULARITY_FMASK);
-
-	offset = ipa_reg_offset(ipa, COUNTER_CFG);
-	iowrite32(val, ipa->reg_virt + offset);
+	iowrite32(val, ipa->reg_virt + ipa_reg_offset(reg));
 }
 
 static void ipa_hardware_config_timing(struct ipa *ipa)
@@ -396,30 +408,30 @@ static void ipa_hardware_config_timing(struct ipa *ipa)
 
 static void ipa_hardware_config_hashing(struct ipa *ipa)
 {
-	u32 offset;
+	const struct ipa_reg *reg;
 
 	if (ipa->version != IPA_VERSION_4_2)
 		return;
 
 	/* IPA v4.2 does not support hashed tables, so disable them */
-	offset = ipa_reg_offset(ipa, FILT_ROUT_HASH_EN);
-	iowrite32(0, ipa->reg_virt + offset);
+	reg = ipa_reg(ipa, FILT_ROUT_HASH_EN);
+	iowrite32(0, ipa->reg_virt + ipa_reg_offset(reg));
 }
 
 static void ipa_idle_indication_cfg(struct ipa *ipa,
 				    u32 enter_idle_debounce_thresh,
 				    bool const_non_idle_enable)
 {
-	u32 offset;
+	const struct ipa_reg *reg;
 	u32 val;
 
+	reg = ipa_reg(ipa, IDLE_INDICATION_CFG);
 	val = u32_encode_bits(enter_idle_debounce_thresh,
 			      ENTER_IDLE_DEBOUNCE_THRESH_FMASK);
 	if (const_non_idle_enable)
 		val |= CONST_NON_IDLE_ENABLE_FMASK;
 
-	offset = ipa_reg_offset(ipa, IDLE_INDICATION_CFG);
-	iowrite32(val, ipa->reg_virt + offset);
+	iowrite32(val, ipa->reg_virt + ipa_reg_offset(reg));
 }
 
 /**
diff --git a/drivers/net/ipa/ipa_mem.c b/drivers/net/ipa/ipa_mem.c
index 53a777bb08a62..a5d94027cad10 100644
--- a/drivers/net/ipa/ipa_mem.c
+++ b/drivers/net/ipa/ipa_mem.c
@@ -75,6 +75,7 @@ ipa_mem_zero_region_add(struct gsi_trans *trans, enum ipa_mem_id mem_id)
 int ipa_mem_setup(struct ipa *ipa)
 {
 	dma_addr_t addr = ipa->zero_addr;
+	const struct ipa_reg *reg;
 	const struct ipa_mem *mem;
 	struct gsi_trans *trans;
 	u32 offset;
@@ -112,10 +113,10 @@ int ipa_mem_setup(struct ipa *ipa)
 	/* Tell the hardware where the processing context area is located */
 	mem = ipa_mem_find(ipa, IPA_MEM_MODEM_PROC_CTX);
 	offset = ipa->mem_offset + mem->offset;
+
+	reg = ipa_reg(ipa, LOCAL_PKT_PROC_CNTXT);
 	val = proc_cntxt_base_addr_encoded(ipa->version, offset);
-
-	offset = ipa_reg_offset(ipa, LOCAL_PKT_PROC_CNTXT);
-	iowrite32(val, ipa->reg_virt + offset);
+	iowrite32(val, ipa->reg_virt + ipa_reg_offset(reg));
 
 	return 0;
 }
@@ -308,6 +309,7 @@ static bool ipa_mem_size_valid(struct ipa *ipa)
 int ipa_mem_config(struct ipa *ipa)
 {
 	struct device *dev = &ipa->pdev->dev;
+	const struct ipa_reg *reg;
 	const struct ipa_mem *mem;
 	dma_addr_t addr;
 	u32 mem_size;
@@ -316,7 +318,8 @@ int ipa_mem_config(struct ipa *ipa)
 	u32 i;
 
 	/* Check the advertised location and size of the shared memory area */
-	val = ioread32(ipa->reg_virt + ipa_reg_offset(ipa, SHARED_MEM_SIZE));
+	reg = ipa_reg(ipa, SHARED_MEM_SIZE);
+	val = ioread32(ipa->reg_virt + ipa_reg_offset(reg));
 
 	/* The fields in the register are in 8 byte units */
 	ipa->mem_offset = 8 * u32_get_bits(val, SHARED_MEM_BADDR_FMASK);
diff --git a/drivers/net/ipa/ipa_reg.c b/drivers/net/ipa/ipa_reg.c
index 67c01c6973ff8..fb4663bcf14bd 100644
--- a/drivers/net/ipa/ipa_reg.c
+++ b/drivers/net/ipa/ipa_reg.c
@@ -67,17 +67,12 @@ static bool ipa_reg_valid(struct ipa *ipa, enum ipa_reg_id reg_id)
 	return valid && ipa->regs->reg[reg_id];
 }
 
-/* Assumes the endpoint transfer direction is valid; 0 is a bad offset */
-u32 __ipa_reg_offset(struct ipa *ipa, enum ipa_reg_id reg_id, u32 n)
+const struct ipa_reg *ipa_reg(struct ipa *ipa, enum ipa_reg_id reg_id)
 {
-	const struct ipa_reg *reg;
-
 	if (WARN_ON(!ipa_reg_valid(ipa, reg_id)))
-		return 0;
+		return NULL;
 
-	reg = ipa->regs->reg[reg_id];
-
-	return reg->offset + n * reg->stride;
+	return ipa->regs->reg[reg_id];
 }
 
 static const struct ipa_regs *ipa_regs(enum ipa_version version)
diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
index 94c0e9f15e97b..49eec53a375ec 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -746,19 +746,18 @@ extern const struct ipa_regs ipa_regs_v4_5;
 extern const struct ipa_regs ipa_regs_v4_9;
 extern const struct ipa_regs ipa_regs_v4_11;
 
-u32 __ipa_reg_offset(struct ipa *ipa, enum ipa_reg_id reg_id, u32 n);
-
 const struct ipa_reg *ipa_reg(struct ipa *ipa, enum ipa_reg_id reg_id);
 
-static inline u32 ipa_reg_offset(struct ipa *ipa, enum ipa_reg_id reg_id)
+/* Returns 0 for NULL reg; warning will have already been issued */
+static inline u32 ipa_reg_offset(const struct ipa_reg *reg)
 {
-	return __ipa_reg_offset(ipa, reg_id, 0);
+	return reg ? reg->offset : 0;
 }
 
-static inline u32
-ipa_reg_n_offset(struct ipa *ipa, enum ipa_reg_id reg_id, u32 n)
+/* Returns 0 for NULL reg; warning will have already been issued */
+static inline u32 ipa_reg_n_offset(const struct ipa_reg *reg, u32 n)
 {
-	return __ipa_reg_offset(ipa, reg_id, n);
+	return reg ? reg->offset + n * reg->stride : 0;
 }
 
 int ipa_reg_init(struct ipa *ipa);
diff --git a/drivers/net/ipa/ipa_resource.c b/drivers/net/ipa/ipa_resource.c
index 3d8eb8df1f83d..bda2f87ca6dcf 100644
--- a/drivers/net/ipa/ipa_resource.c
+++ b/drivers/net/ipa/ipa_resource.c
@@ -91,36 +91,37 @@ static void ipa_resource_config_src(struct ipa *ipa, u32 resource_type,
 	u32 group_count = data->rsrc_group_src_count;
 	const struct ipa_resource_limits *ylimits;
 	const struct ipa_resource *resource;
+	const struct ipa_reg *reg;
 	u32 offset;
 
 	resource = &data->resource_src[resource_type];
 
-	offset = ipa_reg_n_offset(ipa, SRC_RSRC_GRP_01_RSRC_TYPE,
-				  resource_type);
+	reg = ipa_reg(ipa, SRC_RSRC_GRP_01_RSRC_TYPE);
+	offset = ipa_reg_n_offset(reg, resource_type);
 	ylimits = group_count == 1 ? NULL : &resource->limits[1];
 	ipa_resource_config_common(ipa, offset, &resource->limits[0], ylimits);
 
 	if (group_count < 3)
 		return;
 
-	offset = ipa_reg_n_offset(ipa, SRC_RSRC_GRP_23_RSRC_TYPE,
-				  resource_type);
+	reg = ipa_reg(ipa, SRC_RSRC_GRP_23_RSRC_TYPE);
+	offset = ipa_reg_n_offset(reg, resource_type);
 	ylimits = group_count == 3 ? NULL : &resource->limits[3];
 	ipa_resource_config_common(ipa, offset, &resource->limits[2], ylimits);
 
 	if (group_count < 5)
 		return;
 
-	offset = ipa_reg_n_offset(ipa, SRC_RSRC_GRP_45_RSRC_TYPE,
-				  resource_type);
+	reg = ipa_reg(ipa, SRC_RSRC_GRP_45_RSRC_TYPE);
+	offset = ipa_reg_n_offset(reg, resource_type);
 	ylimits = group_count == 5 ? NULL : &resource->limits[5];
 	ipa_resource_config_common(ipa, offset, &resource->limits[4], ylimits);
 
 	if (group_count < 7)
 		return;
 
-	offset = ipa_reg_n_offset(ipa, SRC_RSRC_GRP_67_RSRC_TYPE,
-				  resource_type);
+	reg = ipa_reg(ipa, SRC_RSRC_GRP_67_RSRC_TYPE);
+	offset = ipa_reg_n_offset(reg, resource_type);
 	ylimits = group_count == 7 ? NULL : &resource->limits[7];
 	ipa_resource_config_common(ipa, offset, &resource->limits[6], ylimits);
 }
@@ -131,36 +132,37 @@ static void ipa_resource_config_dst(struct ipa *ipa, u32 resource_type,
 	u32 group_count = data->rsrc_group_dst_count;
 	const struct ipa_resource_limits *ylimits;
 	const struct ipa_resource *resource;
+	const struct ipa_reg *reg;
 	u32 offset;
 
 	resource = &data->resource_dst[resource_type];
 
-	offset = ipa_reg_n_offset(ipa, DST_RSRC_GRP_01_RSRC_TYPE,
-				  resource_type);
+	reg = ipa_reg(ipa, DST_RSRC_GRP_01_RSRC_TYPE);
+	offset = ipa_reg_n_offset(reg, resource_type);
 	ylimits = group_count == 1 ? NULL : &resource->limits[1];
 	ipa_resource_config_common(ipa, offset, &resource->limits[0], ylimits);
 
 	if (group_count < 3)
 		return;
 
-	offset = ipa_reg_n_offset(ipa, DST_RSRC_GRP_23_RSRC_TYPE,
-				  resource_type);
+	reg = ipa_reg(ipa, DST_RSRC_GRP_23_RSRC_TYPE);
+	offset = ipa_reg_n_offset(reg, resource_type);
 	ylimits = group_count == 3 ? NULL : &resource->limits[3];
 	ipa_resource_config_common(ipa, offset, &resource->limits[2], ylimits);
 
 	if (group_count < 5)
 		return;
 
-	offset = ipa_reg_n_offset(ipa, DST_RSRC_GRP_45_RSRC_TYPE,
-				  resource_type);
+	reg = ipa_reg(ipa, DST_RSRC_GRP_45_RSRC_TYPE);
+	offset = ipa_reg_n_offset(reg, resource_type);
 	ylimits = group_count == 5 ? NULL : &resource->limits[5];
 	ipa_resource_config_common(ipa, offset, &resource->limits[4], ylimits);
 
 	if (group_count < 7)
 		return;
 
-	offset = ipa_reg_n_offset(ipa, DST_RSRC_GRP_67_RSRC_TYPE,
-				  resource_type);
+	reg = ipa_reg(ipa, DST_RSRC_GRP_67_RSRC_TYPE);
+	offset = ipa_reg_n_offset(reg, resource_type);
 	ylimits = group_count == 7 ? NULL : &resource->limits[7];
 	ipa_resource_config_common(ipa, offset, &resource->limits[6], ylimits);
 }
diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
index 268e1df75bada..04747e0842267 100644
--- a/drivers/net/ipa/ipa_table.c
+++ b/drivers/net/ipa/ipa_table.c
@@ -384,8 +384,9 @@ void ipa_table_reset(struct ipa *ipa, bool modem)
 
 int ipa_table_hash_flush(struct ipa *ipa)
 {
-	u32 offset = ipa_reg_offset(ipa, FILT_ROUT_HASH_FLUSH);
+	const struct ipa_reg *reg;
 	struct gsi_trans *trans;
+	u32 offset;
 	u32 val;
 
 	if (!ipa_table_hash_support(ipa))
@@ -397,6 +398,9 @@ int ipa_table_hash_flush(struct ipa *ipa)
 		return -EBUSY;
 	}
 
+	reg = ipa_reg(ipa, FILT_ROUT_HASH_FLUSH);
+	offset = ipa_reg_offset(reg);
+
 	val = IPV4_FILTER_HASH_FMASK | IPV6_FILTER_HASH_FMASK;
 	val |= IPV6_ROUTER_HASH_FMASK | IPV4_ROUTER_HASH_FMASK;
 
@@ -517,10 +521,12 @@ static void ipa_filter_tuple_zero(struct ipa_endpoint *endpoint)
 {
 	u32 endpoint_id = endpoint->endpoint_id;
 	struct ipa *ipa = endpoint->ipa;
+	const struct ipa_reg *reg;
 	u32 offset;
 	u32 val;
 
-	offset = ipa_reg_n_offset(ipa, ENDP_FILTER_ROUTER_HSH_CFG, endpoint_id);
+	reg = ipa_reg(ipa, ENDP_FILTER_ROUTER_HSH_CFG);
+	offset = ipa_reg_n_offset(reg, endpoint_id);
 
 	val = ioread32(endpoint->ipa->reg_virt + offset);
 
@@ -566,10 +572,12 @@ static bool ipa_route_id_modem(u32 route_id)
  */
 static void ipa_route_tuple_zero(struct ipa *ipa, u32 route_id)
 {
+	const struct ipa_reg *reg;
 	u32 offset;
 	u32 val;
 
-	offset = ipa_reg_n_offset(ipa, ENDP_FILTER_ROUTER_HSH_CFG, route_id);
+	reg = ipa_reg(ipa, ENDP_FILTER_ROUTER_HSH_CFG);
+	offset = ipa_reg_n_offset(reg, route_id);
 
 	val = ioread32(ipa->reg_virt + offset);
 
diff --git a/drivers/net/ipa/ipa_uc.c b/drivers/net/ipa/ipa_uc.c
index dcfc000025ef1..35aa12fac22f7 100644
--- a/drivers/net/ipa/ipa_uc.c
+++ b/drivers/net/ipa/ipa_uc.c
@@ -222,6 +222,7 @@ void ipa_uc_power(struct ipa *ipa)
 static void send_uc_command(struct ipa *ipa, u32 command, u32 command_param)
 {
 	struct ipa_uc_mem_area *shared = ipa_uc_shared(ipa);
+	const struct ipa_reg *reg;
 	u32 val;
 
 	/* Fill in the command data */
@@ -232,8 +233,10 @@ static void send_uc_command(struct ipa *ipa, u32 command, u32 command_param)
 	shared->response_param = 0;
 
 	/* Use an interrupt to tell the microcontroller the command is ready */
+	reg = ipa_reg(ipa, IPA_IRQ_UC);
 	val = u32_encode_bits(1, UC_INTR_FMASK);
-	iowrite32(val, ipa->reg_virt + ipa_reg_offset(ipa, IPA_IRQ_UC));
+
+	iowrite32(val, ipa->reg_virt + ipa_reg_offset(reg));
 }
 
 /* Tell the microcontroller the AP is shutting down */
-- 
2.34.1

