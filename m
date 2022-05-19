Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4065D52D728
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 17:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240092AbiESPMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 11:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240555AbiESPMc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 11:12:32 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC6C7DFF7B
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 08:12:29 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id e194so6054412iof.11
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 08:12:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=13kniv4nVSRdkSAo1CohAXB/QL3EO5C2jWevaBVW0i4=;
        b=p+fxlW29U7Jzb6Cl/cXawPgTEjWIF51q5kqqtgzzBNsQ0uJNt4p7X4VtAMu8DEjExr
         i80lZgvqJEptxX++GVRCpzVgGH3BpuID7MRmxdy/FnBZk8JSuOcuRU8M3YzsA6cGr0gl
         41cxG3Xf6eosI3Jnzx7Iibji47egDZxbQgZTbaBTn88hHyvEchC/B2Xvp7HkFxGSxWrn
         e1aM2JMWGOCfuQBVOnIvshyEZhk3nLStCqfFYINBjuf+ZTfUUfzVxhfm4kzafP4Sl9Pc
         asBPObw7h4zp7BTze089HLwDsN7FwKsPsGvCFnvCX1mbMHv6M98nObvT4wsNjOqz8BH3
         RgWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=13kniv4nVSRdkSAo1CohAXB/QL3EO5C2jWevaBVW0i4=;
        b=2/Sgzv/RknbW4cPVmUDXjzghyBTcQdW33ZLClCxJTJw4z5QmMgW2LI2GXlMhp4wnwO
         +5pgOXSuv0MDgSY57tB5Ns22n/1PTNh8em5AdQcAhl5QufYfb3qwKVltkKUOriFvdEPh
         h8p2rklyBGlMkoCJjAFOSd975Wkw7+ymxCBpW5dvKivcvuESwZN7g4v3t51ij0kxOhSk
         /0ZEVW7hAWHce9xHq+DCc3aYlw8pD+ry+MEfea3cNer8XNX/DVE/fqzIlGrV85cGZsBG
         fGFIPJU8t0Z4hCuHvg38din5kghe6GwZNnRLF4xlb4V+FR1OJAaXJ3Yh2kscOI6UQWvc
         R37g==
X-Gm-Message-State: AOAM530ApYE0VH0LNI8svNrI9UghgKOZUN0kLvSkKxqQenYBdRAILvvU
        XLEPT0ZSwPHY9oTgyd+QbV0sDQ==
X-Google-Smtp-Source: ABdhPJxCrx6nP6zhkA3WFb4u0CZDrl4WuDTl4G1meqRL77moprAT2iD5KXIR3ke8E5+V+woM3wYNEQ==
X-Received: by 2002:a05:6638:3792:b0:32b:5cd3:50cd with SMTP id w18-20020a056638379200b0032b5cd350cdmr2932737jal.118.1652973149007;
        Thu, 19 May 2022 08:12:29 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id g6-20020a025b06000000b0032e271a558csm683887jab.168.2022.05.19.08.12.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 08:12:28 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 7/7] net: ipa: save a copy of endpoint default config
Date:   Thu, 19 May 2022 10:12:17 -0500
Message-Id: <20220519151217.654890-8-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220519151217.654890-1-elder@linaro.org>
References: <20220519151217.654890-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All elements of the default endpoint configuration are used in the
code when programming an endpoint for use.  But none of the other
configuration data is ever needed once things are initialized.

So rather than saving a pointer to *all* of the configuration data,
save a copy of only the endpoint configuration portion.

This will eventually allow endpoint configuration to be modifiable
at runtime.  But even before that it means we won't keep a pointer
to configuration data after when no longer needed.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 52 +++++++++++++++++-----------------
 drivers/net/ipa/ipa_endpoint.h |  2 +-
 drivers/net/ipa/ipa_modem.c    |  2 +-
 3 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index bc95c71d80fc2..6010990690bb4 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -333,7 +333,7 @@ static void ipa_endpoint_suspend_aggr(struct ipa_endpoint *endpoint)
 {
 	struct ipa *ipa = endpoint->ipa;
 
-	if (!endpoint->config->aggregation)
+	if (!endpoint->config.aggregation)
 		return;
 
 	/* Nothing to do if the endpoint doesn't have aggregation open */
@@ -453,7 +453,7 @@ static void ipa_endpoint_init_cfg(struct ipa_endpoint *endpoint)
 	u32 val = 0;
 
 	/* FRAG_OFFLOAD_EN is 0 */
-	if (endpoint->config->checksum) {
+	if (endpoint->config.checksum) {
 		enum ipa_version version = endpoint->ipa->version;
 
 		if (endpoint->toward_ipa) {
@@ -502,7 +502,7 @@ ipa_qmap_header_size(enum ipa_version version, struct ipa_endpoint *endpoint)
 	u32 header_size = sizeof(struct rmnet_map_header);
 
 	/* Without checksum offload, we just have the MAP header */
-	if (!endpoint->config->checksum)
+	if (!endpoint->config.checksum)
 		return header_size;
 
 	if (version < IPA_VERSION_4_5) {
@@ -544,7 +544,7 @@ static void ipa_endpoint_init_hdr(struct ipa_endpoint *endpoint)
 	struct ipa *ipa = endpoint->ipa;
 	u32 val = 0;
 
-	if (endpoint->config->qmap) {
+	if (endpoint->config.qmap) {
 		enum ipa_version version = ipa->version;
 		size_t header_size;
 
@@ -583,11 +583,11 @@ static void ipa_endpoint_init_hdr(struct ipa_endpoint *endpoint)
 static void ipa_endpoint_init_hdr_ext(struct ipa_endpoint *endpoint)
 {
 	u32 offset = IPA_REG_ENDP_INIT_HDR_EXT_N_OFFSET(endpoint->endpoint_id);
-	u32 pad_align = endpoint->config->rx.pad_align;
+	u32 pad_align = endpoint->config.rx.pad_align;
 	struct ipa *ipa = endpoint->ipa;
 	u32 val = 0;
 
-	if (endpoint->config->qmap) {
+	if (endpoint->config.qmap) {
 		/* We have a header, so we must specify its endianness */
 		val |= HDR_ENDIANNESS_FMASK;	/* big endian */
 
@@ -615,7 +615,7 @@ static void ipa_endpoint_init_hdr_ext(struct ipa_endpoint *endpoint)
 	 */
 	if (ipa->version >= IPA_VERSION_4_5) {
 		/* HDR_TOTAL_LEN_OR_PAD_OFFSET is 0, so MSB is 0 */
-		if (endpoint->config->qmap && !endpoint->toward_ipa) {
+		if (endpoint->config.qmap && !endpoint->toward_ipa) {
 			u32 offset;
 
 			offset = offsetof(struct rmnet_map_header, pkt_len);
@@ -640,7 +640,7 @@ static void ipa_endpoint_init_hdr_metadata_mask(struct ipa_endpoint *endpoint)
 	offset = IPA_REG_ENDP_INIT_HDR_METADATA_MASK_N_OFFSET(endpoint_id);
 
 	/* Note that HDR_ENDIANNESS indicates big endian header fields */
-	if (endpoint->config->qmap)
+	if (endpoint->config.qmap)
 		val = (__force u32)cpu_to_be32(IPA_ENDPOINT_QMAP_METADATA_MASK);
 
 	iowrite32(val, endpoint->ipa->reg_virt + offset);
@@ -654,8 +654,8 @@ static void ipa_endpoint_init_mode(struct ipa_endpoint *endpoint)
 	if (!endpoint->toward_ipa)
 		return;		/* Register not valid for RX endpoints */
 
-	if (endpoint->config->dma_mode) {
-		enum ipa_endpoint_name name = endpoint->config->dma_endpoint;
+	if (endpoint->config.dma_mode) {
+		enum ipa_endpoint_name name = endpoint->config.dma_endpoint;
 		u32 dma_endpoint_id;
 
 		dma_endpoint_id = endpoint->ipa->name_map[name]->endpoint_id;
@@ -741,14 +741,14 @@ static void ipa_endpoint_init_aggr(struct ipa_endpoint *endpoint)
 	enum ipa_version version = endpoint->ipa->version;
 	u32 val = 0;
 
-	if (endpoint->config->aggregation) {
+	if (endpoint->config.aggregation) {
 		if (!endpoint->toward_ipa) {
 			const struct ipa_endpoint_rx *rx_config;
 			u32 buffer_size;
 			bool close_eof;
 			u32 limit;
 
-			rx_config = &endpoint->config->rx;
+			rx_config = &endpoint->config.rx;
 			val |= u32_encode_bits(IPA_ENABLE_AGGR, AGGR_EN_FMASK);
 			val |= u32_encode_bits(IPA_GENERIC, AGGR_TYPE_FMASK);
 
@@ -947,7 +947,7 @@ static void ipa_endpoint_init_rsrc_grp(struct ipa_endpoint *endpoint)
 	struct ipa *ipa = endpoint->ipa;
 	u32 val;
 
-	val = rsrc_grp_encoded(ipa->version, endpoint->config->resource_group);
+	val = rsrc_grp_encoded(ipa->version, endpoint->config.resource_group);
 	iowrite32(val, ipa->reg_virt + offset);
 }
 
@@ -960,10 +960,10 @@ static void ipa_endpoint_init_seq(struct ipa_endpoint *endpoint)
 		return;		/* Register not valid for RX endpoints */
 
 	/* Low-order byte configures primary packet processing */
-	val |= u32_encode_bits(endpoint->config->tx.seq_type, SEQ_TYPE_FMASK);
+	val |= u32_encode_bits(endpoint->config.tx.seq_type, SEQ_TYPE_FMASK);
 
 	/* Second byte configures replicated packet processing */
-	val |= u32_encode_bits(endpoint->config->tx.seq_rep_type,
+	val |= u32_encode_bits(endpoint->config.tx.seq_rep_type,
 			       SEQ_REP_TYPE_FMASK);
 
 	iowrite32(val, endpoint->ipa->reg_virt + offset);
@@ -1021,13 +1021,13 @@ static void ipa_endpoint_status(struct ipa_endpoint *endpoint)
 
 	offset = IPA_REG_ENDP_STATUS_N_OFFSET(endpoint_id);
 
-	if (endpoint->config->status_enable) {
+	if (endpoint->config.status_enable) {
 		val |= STATUS_EN_FMASK;
 		if (endpoint->toward_ipa) {
 			enum ipa_endpoint_name name;
 			u32 status_endpoint_id;
 
-			name = endpoint->config->tx.status_endpoint;
+			name = endpoint->config.tx.status_endpoint;
 			status_endpoint_id = ipa->name_map[name]->endpoint_id;
 
 			val |= u32_encode_bits(status_endpoint_id,
@@ -1051,7 +1051,7 @@ static int ipa_endpoint_replenish_one(struct ipa_endpoint *endpoint,
 	u32 len;
 	int ret;
 
-	buffer_size = endpoint->config->rx.buffer_size;
+	buffer_size = endpoint->config.rx.buffer_size;
 	page = dev_alloc_pages(get_order(buffer_size));
 	if (!page)
 		return -ENOMEM;
@@ -1169,7 +1169,7 @@ static void ipa_endpoint_skb_copy(struct ipa_endpoint *endpoint,
 static bool ipa_endpoint_skb_build(struct ipa_endpoint *endpoint,
 				   struct page *page, u32 len)
 {
-	u32 buffer_size = endpoint->config->rx.buffer_size;
+	u32 buffer_size = endpoint->config.rx.buffer_size;
 	struct sk_buff *skb;
 
 	/* Nothing to do if there's no netdev */
@@ -1276,7 +1276,7 @@ static bool ipa_endpoint_status_drop(struct ipa_endpoint *endpoint,
 static void ipa_endpoint_status_parse(struct ipa_endpoint *endpoint,
 				      struct page *page, u32 total_len)
 {
-	u32 buffer_size = endpoint->config->rx.buffer_size;
+	u32 buffer_size = endpoint->config.rx.buffer_size;
 	void *data = page_address(page) + NET_SKB_PAD;
 	u32 unused = buffer_size - total_len;
 	u32 resid = total_len;
@@ -1306,10 +1306,10 @@ static void ipa_endpoint_status_parse(struct ipa_endpoint *endpoint,
 		 * And if checksum offload is enabled a trailer containing
 		 * computed checksum information will be appended.
 		 */
-		align = endpoint->config->rx.pad_align ? : 1;
+		align = endpoint->config.rx.pad_align ? : 1;
 		len = le16_to_cpu(status->pkt_len);
 		len = sizeof(*status) + ALIGN(len, align);
-		if (endpoint->config->checksum)
+		if (endpoint->config.checksum)
 			len += sizeof(struct rmnet_map_dl_csum_trailer);
 
 		if (!ipa_endpoint_status_drop(endpoint, status)) {
@@ -1353,7 +1353,7 @@ static void ipa_endpoint_rx_complete(struct ipa_endpoint *endpoint,
 
 	/* Parse or build a socket buffer using the actual received length */
 	page = trans->data;
-	if (endpoint->config->status_enable)
+	if (endpoint->config.status_enable)
 		ipa_endpoint_status_parse(endpoint, page, trans->len);
 	else if (ipa_endpoint_skb_build(endpoint, page, trans->len))
 		trans->data = NULL;	/* Pages have been consumed */
@@ -1387,7 +1387,7 @@ void ipa_endpoint_trans_release(struct ipa_endpoint *endpoint,
 		struct page *page = trans->data;
 
 		if (page) {
-			u32 buffer_size = endpoint->config->rx.buffer_size;
+			u32 buffer_size = endpoint->config.rx.buffer_size;
 
 			__free_pages(page, get_order(buffer_size));
 		}
@@ -1521,7 +1521,7 @@ static void ipa_endpoint_reset(struct ipa_endpoint *endpoint)
 	 * All other cases just need to reset the underlying GSI channel.
 	 */
 	special = ipa->version < IPA_VERSION_4_0 && !endpoint->toward_ipa &&
-			endpoint->config->aggregation;
+			endpoint->config.aggregation;
 	if (special && ipa_endpoint_aggr_active(endpoint))
 		ret = ipa_endpoint_reset_rx_aggr(endpoint);
 	else
@@ -1836,7 +1836,7 @@ static void ipa_endpoint_init_one(struct ipa *ipa, enum ipa_endpoint_name name,
 	endpoint->channel_id = data->channel_id;
 	endpoint->endpoint_id = data->endpoint_id;
 	endpoint->toward_ipa = data->toward_ipa;
-	endpoint->config = &data->endpoint.config;
+	endpoint->config = data->endpoint.config;
 
 	ipa->initialized |= BIT(endpoint->endpoint_id);
 }
diff --git a/drivers/net/ipa/ipa_endpoint.h b/drivers/net/ipa/ipa_endpoint.h
index e8d1300a60022..39a12c249f66d 100644
--- a/drivers/net/ipa/ipa_endpoint.h
+++ b/drivers/net/ipa/ipa_endpoint.h
@@ -136,7 +136,7 @@ struct ipa_endpoint {
 	u32 channel_id;
 	u32 endpoint_id;
 	bool toward_ipa;
-	const struct ipa_endpoint_config *config;
+	struct ipa_endpoint_config config;
 
 	u32 trans_tre_max;
 	u32 evt_ring_id;
diff --git a/drivers/net/ipa/ipa_modem.c b/drivers/net/ipa/ipa_modem.c
index 7975e324690bb..c8b1c4d9c5073 100644
--- a/drivers/net/ipa/ipa_modem.c
+++ b/drivers/net/ipa/ipa_modem.c
@@ -129,7 +129,7 @@ ipa_start_xmit(struct sk_buff *skb, struct net_device *netdev)
 		goto err_drop_skb;
 
 	endpoint = ipa->name_map[IPA_ENDPOINT_AP_MODEM_TX];
-	if (endpoint->config->qmap && skb->protocol != htons(ETH_P_MAP))
+	if (endpoint->config.qmap && skb->protocol != htons(ETH_P_MAP))
 		goto err_drop_skb;
 
 	/* The hardware must be powered for us to transmit */
-- 
2.32.0

