Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3159352D725
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 17:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240606AbiESPMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 11:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240550AbiESPMa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 11:12:30 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B99ACC3D04
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 08:12:28 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id 3so3870892ily.2
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 08:12:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9K81zor/vNDWgLyjh1MeLD26Ld7TFFkGmFoi2TJ8/oY=;
        b=Gm42HtkEfQVMVaJCoQGabbSxtw/s7sExdQrcf2jkmLuikqMTfTX4x3I0E2dWPb+Y5p
         ffuw+YnUIJO9tcAgWqwiceyzeUMDa5rxVQ0gqPfkGpU0jwBNpy5OXySTNWdK3NqmPbj4
         WwAkMW57clvqO4HCbUHf4RkSQPs1FKgRZxg7DKL93eoSbHDKUdlKK5e+GwGdyRaNS9wl
         gVp+3fjXPKYJfh/vZXQEYxWG+ksz10WsfCEu7eNnYKFR7VKgxOrjAo9jg4CS+jH0CBhA
         LmaxC5icO9bF7WePJMz45wBn+7Pc+OeHvMSuJJ4SMle41eivAj+0R71KGAgdpLFGIwQj
         y+lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9K81zor/vNDWgLyjh1MeLD26Ld7TFFkGmFoi2TJ8/oY=;
        b=S5nO7UIdf9Wk8vyja9kaC+fX5UJAydOJWdfew6lDBXDtlAHdoDcguxNJxTZFmFyFoN
         NuezgQHIVIrY7fizuzUKGnB/Ee1X85hXcJmmec1Ddx0Pjrt0jJMGkzlDJvZlXW/t17AB
         ftL+McvcKCsDRxj09twUHycMLIY47hcT4SIOalrEiNlW615uxFSdKAVCRbIMrIyXYQW+
         5KgYg6eCnKxyI32JQHD4je43CbzXQkX4vPhlFCEw3aQHBkFi737C9FtdwubTbV07kVjB
         wP5LK+mUu6uQmhUZ9S6h/lXD+5dcu76OwMuTom42bNeBlGFjifoUOaY9M5G8hxX5dMkc
         bzqg==
X-Gm-Message-State: AOAM532X7Fj5gWIHtq8m3RxUsWbSR56bwxAaWGCHKliFny5kBmgwTKAi
        mEIO6kfqkz7Oz9xHTTo13IrqvQ==
X-Google-Smtp-Source: ABdhPJwcAoSAMJ1T1o0E2qxdlZhqlb2mFulSas6P+uDGqaJdj28xraWqADuzIH2oYmqiInTg2u2R+w==
X-Received: by 2002:a05:6e02:be8:b0:2cf:b8d:5fa with SMTP id d8-20020a056e020be800b002cf0b8d05famr3087951ilu.93.1652973147973;
        Thu, 19 May 2022 08:12:27 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id g6-20020a025b06000000b0032e271a558csm683887jab.168.2022.05.19.08.12.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 08:12:27 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 6/7] net: ipa: rename a few endpoint config data types
Date:   Thu, 19 May 2022 10:12:16 -0500
Message-Id: <20220519151217.654890-7-elder@linaro.org>
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

Rename the just-moved data structure types to drop the "_data"
suffix, to make it more obvious they are no longer meant to be used
just as read-only initialization data.  Rename the fields and
variables of these types to use "config" instead of "data" in the
name.  This is another small step meant to facilitate review.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_data.h     |  8 ++---
 drivers/net/ipa/ipa_endpoint.c | 58 +++++++++++++++++-----------------
 drivers/net/ipa/ipa_endpoint.h | 26 +++++++--------
 drivers/net/ipa/ipa_modem.c    |  2 +-
 4 files changed, 47 insertions(+), 47 deletions(-)

diff --git a/drivers/net/ipa/ipa_data.h b/drivers/net/ipa/ipa_data.h
index d611b5e96497c..e15eb3cd3e333 100644
--- a/drivers/net/ipa/ipa_data.h
+++ b/drivers/net/ipa/ipa_data.h
@@ -98,7 +98,7 @@ struct gsi_channel_data {
 /**
  * struct ipa_endpoint_data - IPA endpoint configuration data
  * @filter_support:	whether endpoint supports filtering
- * @config:		hardware configuration (see above)
+ * @config:		hardware configuration
  *
  * Not all endpoints support the IPA filtering capability.  A filter table
  * defines the filters to apply for those endpoints that support it.  The
@@ -106,12 +106,12 @@ struct gsi_channel_data {
  * for non-AP endpoints.  For this reason we define *all* endpoints used
  * in the system, and indicate whether they support filtering.
  *
- * The remaining endpoint configuration data applies only to AP endpoints.
+ * The remaining endpoint configuration data specifies default hardware
+ * configuration values that apply only to AP endpoints.
  */
 struct ipa_endpoint_data {
 	bool filter_support;
-	/* Everything else is specified only for AP endpoints */
-	struct ipa_endpoint_config_data config;
+	struct ipa_endpoint_config config;
 };
 
 /**
diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 3fcd7c64c9bba..bc95c71d80fc2 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -333,7 +333,7 @@ static void ipa_endpoint_suspend_aggr(struct ipa_endpoint *endpoint)
 {
 	struct ipa *ipa = endpoint->ipa;
 
-	if (!endpoint->data->aggregation)
+	if (!endpoint->config->aggregation)
 		return;
 
 	/* Nothing to do if the endpoint doesn't have aggregation open */
@@ -453,7 +453,7 @@ static void ipa_endpoint_init_cfg(struct ipa_endpoint *endpoint)
 	u32 val = 0;
 
 	/* FRAG_OFFLOAD_EN is 0 */
-	if (endpoint->data->checksum) {
+	if (endpoint->config->checksum) {
 		enum ipa_version version = endpoint->ipa->version;
 
 		if (endpoint->toward_ipa) {
@@ -502,7 +502,7 @@ ipa_qmap_header_size(enum ipa_version version, struct ipa_endpoint *endpoint)
 	u32 header_size = sizeof(struct rmnet_map_header);
 
 	/* Without checksum offload, we just have the MAP header */
-	if (!endpoint->data->checksum)
+	if (!endpoint->config->checksum)
 		return header_size;
 
 	if (version < IPA_VERSION_4_5) {
@@ -544,7 +544,7 @@ static void ipa_endpoint_init_hdr(struct ipa_endpoint *endpoint)
 	struct ipa *ipa = endpoint->ipa;
 	u32 val = 0;
 
-	if (endpoint->data->qmap) {
+	if (endpoint->config->qmap) {
 		enum ipa_version version = ipa->version;
 		size_t header_size;
 
@@ -583,11 +583,11 @@ static void ipa_endpoint_init_hdr(struct ipa_endpoint *endpoint)
 static void ipa_endpoint_init_hdr_ext(struct ipa_endpoint *endpoint)
 {
 	u32 offset = IPA_REG_ENDP_INIT_HDR_EXT_N_OFFSET(endpoint->endpoint_id);
-	u32 pad_align = endpoint->data->rx.pad_align;
+	u32 pad_align = endpoint->config->rx.pad_align;
 	struct ipa *ipa = endpoint->ipa;
 	u32 val = 0;
 
-	if (endpoint->data->qmap) {
+	if (endpoint->config->qmap) {
 		/* We have a header, so we must specify its endianness */
 		val |= HDR_ENDIANNESS_FMASK;	/* big endian */
 
@@ -615,7 +615,7 @@ static void ipa_endpoint_init_hdr_ext(struct ipa_endpoint *endpoint)
 	 */
 	if (ipa->version >= IPA_VERSION_4_5) {
 		/* HDR_TOTAL_LEN_OR_PAD_OFFSET is 0, so MSB is 0 */
-		if (endpoint->data->qmap && !endpoint->toward_ipa) {
+		if (endpoint->config->qmap && !endpoint->toward_ipa) {
 			u32 offset;
 
 			offset = offsetof(struct rmnet_map_header, pkt_len);
@@ -640,7 +640,7 @@ static void ipa_endpoint_init_hdr_metadata_mask(struct ipa_endpoint *endpoint)
 	offset = IPA_REG_ENDP_INIT_HDR_METADATA_MASK_N_OFFSET(endpoint_id);
 
 	/* Note that HDR_ENDIANNESS indicates big endian header fields */
-	if (endpoint->data->qmap)
+	if (endpoint->config->qmap)
 		val = (__force u32)cpu_to_be32(IPA_ENDPOINT_QMAP_METADATA_MASK);
 
 	iowrite32(val, endpoint->ipa->reg_virt + offset);
@@ -654,8 +654,8 @@ static void ipa_endpoint_init_mode(struct ipa_endpoint *endpoint)
 	if (!endpoint->toward_ipa)
 		return;		/* Register not valid for RX endpoints */
 
-	if (endpoint->data->dma_mode) {
-		enum ipa_endpoint_name name = endpoint->data->dma_endpoint;
+	if (endpoint->config->dma_mode) {
+		enum ipa_endpoint_name name = endpoint->config->dma_endpoint;
 		u32 dma_endpoint_id;
 
 		dma_endpoint_id = endpoint->ipa->name_map[name]->endpoint_id;
@@ -741,18 +741,18 @@ static void ipa_endpoint_init_aggr(struct ipa_endpoint *endpoint)
 	enum ipa_version version = endpoint->ipa->version;
 	u32 val = 0;
 
-	if (endpoint->data->aggregation) {
+	if (endpoint->config->aggregation) {
 		if (!endpoint->toward_ipa) {
-			const struct ipa_endpoint_rx_data *rx_data;
+			const struct ipa_endpoint_rx *rx_config;
 			u32 buffer_size;
 			bool close_eof;
 			u32 limit;
 
-			rx_data = &endpoint->data->rx;
+			rx_config = &endpoint->config->rx;
 			val |= u32_encode_bits(IPA_ENABLE_AGGR, AGGR_EN_FMASK);
 			val |= u32_encode_bits(IPA_GENERIC, AGGR_TYPE_FMASK);
 
-			buffer_size = rx_data->buffer_size;
+			buffer_size = rx_config->buffer_size;
 			limit = ipa_aggr_size_kb(buffer_size - NET_SKB_PAD);
 			val |= aggr_byte_limit_encoded(version, limit);
 
@@ -761,7 +761,7 @@ static void ipa_endpoint_init_aggr(struct ipa_endpoint *endpoint)
 
 			/* AGGR_PKT_LIMIT is 0 (unlimited) */
 
-			close_eof = rx_data->aggr_close_eof;
+			close_eof = rx_config->aggr_close_eof;
 			val |= aggr_sw_eof_active_encoded(version, close_eof);
 		} else {
 			val |= u32_encode_bits(IPA_ENABLE_DEAGGR,
@@ -947,7 +947,7 @@ static void ipa_endpoint_init_rsrc_grp(struct ipa_endpoint *endpoint)
 	struct ipa *ipa = endpoint->ipa;
 	u32 val;
 
-	val = rsrc_grp_encoded(ipa->version, endpoint->data->resource_group);
+	val = rsrc_grp_encoded(ipa->version, endpoint->config->resource_group);
 	iowrite32(val, ipa->reg_virt + offset);
 }
 
@@ -960,10 +960,10 @@ static void ipa_endpoint_init_seq(struct ipa_endpoint *endpoint)
 		return;		/* Register not valid for RX endpoints */
 
 	/* Low-order byte configures primary packet processing */
-	val |= u32_encode_bits(endpoint->data->tx.seq_type, SEQ_TYPE_FMASK);
+	val |= u32_encode_bits(endpoint->config->tx.seq_type, SEQ_TYPE_FMASK);
 
 	/* Second byte configures replicated packet processing */
-	val |= u32_encode_bits(endpoint->data->tx.seq_rep_type,
+	val |= u32_encode_bits(endpoint->config->tx.seq_rep_type,
 			       SEQ_REP_TYPE_FMASK);
 
 	iowrite32(val, endpoint->ipa->reg_virt + offset);
@@ -1021,13 +1021,13 @@ static void ipa_endpoint_status(struct ipa_endpoint *endpoint)
 
 	offset = IPA_REG_ENDP_STATUS_N_OFFSET(endpoint_id);
 
-	if (endpoint->data->status_enable) {
+	if (endpoint->config->status_enable) {
 		val |= STATUS_EN_FMASK;
 		if (endpoint->toward_ipa) {
 			enum ipa_endpoint_name name;
 			u32 status_endpoint_id;
 
-			name = endpoint->data->tx.status_endpoint;
+			name = endpoint->config->tx.status_endpoint;
 			status_endpoint_id = ipa->name_map[name]->endpoint_id;
 
 			val |= u32_encode_bits(status_endpoint_id,
@@ -1051,7 +1051,7 @@ static int ipa_endpoint_replenish_one(struct ipa_endpoint *endpoint,
 	u32 len;
 	int ret;
 
-	buffer_size = endpoint->data->rx.buffer_size;
+	buffer_size = endpoint->config->rx.buffer_size;
 	page = dev_alloc_pages(get_order(buffer_size));
 	if (!page)
 		return -ENOMEM;
@@ -1169,7 +1169,7 @@ static void ipa_endpoint_skb_copy(struct ipa_endpoint *endpoint,
 static bool ipa_endpoint_skb_build(struct ipa_endpoint *endpoint,
 				   struct page *page, u32 len)
 {
-	u32 buffer_size = endpoint->data->rx.buffer_size;
+	u32 buffer_size = endpoint->config->rx.buffer_size;
 	struct sk_buff *skb;
 
 	/* Nothing to do if there's no netdev */
@@ -1276,7 +1276,7 @@ static bool ipa_endpoint_status_drop(struct ipa_endpoint *endpoint,
 static void ipa_endpoint_status_parse(struct ipa_endpoint *endpoint,
 				      struct page *page, u32 total_len)
 {
-	u32 buffer_size = endpoint->data->rx.buffer_size;
+	u32 buffer_size = endpoint->config->rx.buffer_size;
 	void *data = page_address(page) + NET_SKB_PAD;
 	u32 unused = buffer_size - total_len;
 	u32 resid = total_len;
@@ -1306,10 +1306,10 @@ static void ipa_endpoint_status_parse(struct ipa_endpoint *endpoint,
 		 * And if checksum offload is enabled a trailer containing
 		 * computed checksum information will be appended.
 		 */
-		align = endpoint->data->rx.pad_align ? : 1;
+		align = endpoint->config->rx.pad_align ? : 1;
 		len = le16_to_cpu(status->pkt_len);
 		len = sizeof(*status) + ALIGN(len, align);
-		if (endpoint->data->checksum)
+		if (endpoint->config->checksum)
 			len += sizeof(struct rmnet_map_dl_csum_trailer);
 
 		if (!ipa_endpoint_status_drop(endpoint, status)) {
@@ -1353,7 +1353,7 @@ static void ipa_endpoint_rx_complete(struct ipa_endpoint *endpoint,
 
 	/* Parse or build a socket buffer using the actual received length */
 	page = trans->data;
-	if (endpoint->data->status_enable)
+	if (endpoint->config->status_enable)
 		ipa_endpoint_status_parse(endpoint, page, trans->len);
 	else if (ipa_endpoint_skb_build(endpoint, page, trans->len))
 		trans->data = NULL;	/* Pages have been consumed */
@@ -1387,7 +1387,7 @@ void ipa_endpoint_trans_release(struct ipa_endpoint *endpoint,
 		struct page *page = trans->data;
 
 		if (page) {
-			u32 buffer_size = endpoint->data->rx.buffer_size;
+			u32 buffer_size = endpoint->config->rx.buffer_size;
 
 			__free_pages(page, get_order(buffer_size));
 		}
@@ -1521,7 +1521,7 @@ static void ipa_endpoint_reset(struct ipa_endpoint *endpoint)
 	 * All other cases just need to reset the underlying GSI channel.
 	 */
 	special = ipa->version < IPA_VERSION_4_0 && !endpoint->toward_ipa &&
-			endpoint->data->aggregation;
+			endpoint->config->aggregation;
 	if (special && ipa_endpoint_aggr_active(endpoint))
 		ret = ipa_endpoint_reset_rx_aggr(endpoint);
 	else
@@ -1836,7 +1836,7 @@ static void ipa_endpoint_init_one(struct ipa *ipa, enum ipa_endpoint_name name,
 	endpoint->channel_id = data->channel_id;
 	endpoint->endpoint_id = data->endpoint_id;
 	endpoint->toward_ipa = data->toward_ipa;
-	endpoint->data = &data->endpoint.config;
+	endpoint->config = &data->endpoint.config;
 
 	ipa->initialized |= BIT(endpoint->endpoint_id);
 }
diff --git a/drivers/net/ipa/ipa_endpoint.h b/drivers/net/ipa/ipa_endpoint.h
index 85fe15b5d983e..e8d1300a60022 100644
--- a/drivers/net/ipa/ipa_endpoint.h
+++ b/drivers/net/ipa/ipa_endpoint.h
@@ -41,7 +41,7 @@ enum ipa_endpoint_name {
 #define IPA_ENDPOINT_MAX		32	/* Max supported by driver */
 
 /**
- * struct ipa_endpoint_tx_data - configuration data for TX endpoints
+ * struct ipa_endpoint_tx - Endpoint configuration for TX endpoints
  * @seq_type:		primary packet processing sequencer type
  * @seq_rep_type:	sequencer type for replication processing
  * @status_endpoint:	endpoint to which status elements are sent
@@ -49,17 +49,17 @@ enum ipa_endpoint_name {
  * The @status_endpoint is only valid if the endpoint's @status_enable
  * flag is set.
  */
-struct ipa_endpoint_tx_data {
+struct ipa_endpoint_tx {
 	enum ipa_seq_type seq_type;
 	enum ipa_seq_rep_type seq_rep_type;
 	enum ipa_endpoint_name status_endpoint;
 };
 
 /**
- * struct ipa_endpoint_rx_data - configuration data for RX endpoints
- * @buffer_size: requested receive buffer size (bytes)
- * @pad_align:	power-of-2 boundary to which packet payload is aligned
- * @aggr_close_eof: whether aggregation closes on end-of-frame
+ * struct ipa_endpoint_rx - Endpoint configuration for RX endpoints
+ * @buffer_size:	requested receive buffer size (bytes)
+ * @pad_align:		power-of-2 boundary to which packet payload is aligned
+ * @aggr_close_eof:	whether aggregation closes on end-of-frame
  *
  * With each packet it transfers, the IPA hardware can perform certain
  * transformations of its packet data.  One of these is adding pad bytes
@@ -70,14 +70,14 @@ struct ipa_endpoint_tx_data {
  * certain criteria are met.  One of those criteria is the sender indicating
  * a "frame" consisting of several transfers has ended.
  */
-struct ipa_endpoint_rx_data {
+struct ipa_endpoint_rx {
 	u32 buffer_size;
 	u32 pad_align;
 	bool aggr_close_eof;
 };
 
 /**
- * struct ipa_endpoint_config_data - IPA endpoint hardware configuration
+ * struct ipa_endpoint_config - IPA endpoint hardware configuration
  * @resource_group:	resource group to assign endpoint to
  * @checksum:		whether checksum offload is enabled
  * @qmap:		whether endpoint uses QMAP protocol
@@ -88,7 +88,7 @@ struct ipa_endpoint_rx_data {
  * @tx:			TX-specific endpoint information (see above)
  * @rx:			RX-specific endpoint information (see above)
  */
-struct ipa_endpoint_config_data {
+struct ipa_endpoint_config {
 	u32 resource_group;
 	bool checksum;
 	bool qmap;
@@ -97,8 +97,8 @@ struct ipa_endpoint_config_data {
 	bool dma_mode;
 	enum ipa_endpoint_name dma_endpoint;
 	union {
-		struct ipa_endpoint_tx_data tx;
-		struct ipa_endpoint_rx_data rx;
+		struct ipa_endpoint_tx tx;
+		struct ipa_endpoint_rx rx;
 	};
 };
 
@@ -122,7 +122,7 @@ enum ipa_replenish_flag {
  * @channel_id:		GSI channel used by the endpoint
  * @endpoint_id:	IPA endpoint number
  * @toward_ipa:		Endpoint direction (true = TX, false = RX)
- * @data:		Endpoint configuration data
+ * @config:		Default endpoint configuration
  * @trans_tre_max:	Maximum number of TRE descriptors per transaction
  * @evt_ring_id:	GSI event ring used by the endpoint
  * @netdev:		Network device pointer, if endpoint uses one
@@ -136,7 +136,7 @@ struct ipa_endpoint {
 	u32 channel_id;
 	u32 endpoint_id;
 	bool toward_ipa;
-	const struct ipa_endpoint_config_data *data;
+	const struct ipa_endpoint_config *config;
 
 	u32 trans_tre_max;
 	u32 evt_ring_id;
diff --git a/drivers/net/ipa/ipa_modem.c b/drivers/net/ipa/ipa_modem.c
index dd6464ced2546..7975e324690bb 100644
--- a/drivers/net/ipa/ipa_modem.c
+++ b/drivers/net/ipa/ipa_modem.c
@@ -129,7 +129,7 @@ ipa_start_xmit(struct sk_buff *skb, struct net_device *netdev)
 		goto err_drop_skb;
 
 	endpoint = ipa->name_map[IPA_ENDPOINT_AP_MODEM_TX];
-	if (endpoint->data->qmap && skb->protocol != htons(ETH_P_MAP))
+	if (endpoint->config->qmap && skb->protocol != htons(ETH_P_MAP))
 		goto err_drop_skb;
 
 	/* The hardware must be powered for us to transmit */
-- 
2.32.0

