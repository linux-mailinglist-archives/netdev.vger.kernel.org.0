Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84E4267BD4B
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 21:46:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236634AbjAYUqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 15:46:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236590AbjAYUqE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 15:46:04 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96DE25DC18
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 12:45:57 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id e204so9024952iof.1
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 12:45:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cZyimMjWLBBkvjzcnu+BPtGS7EzWyaqySans44hxkOg=;
        b=FLgRhBeYcoqGPMK6MXbu4YkNjJwnqzL27ahPn1lJ8jo7ERfRcexSP7PsXfB7Yqx3Rk
         +NWGE8AmJRGV51vjHJ8i2Ul/jhYwYhSSOx514+ymrL/fNKe9fbMvFys/zBa5fCmeo8j/
         s8dy33mqtmGVAlbh3lX0XEPsW/fZJaMRjaTdACr62YR1bK/1jVLPalVYinSGVwAR0wA2
         k86GJajTXcXPTvaW/K7wDZb6iot+rTct5FQFpG+vptrcW4WvS8BUoljGCgvz2ZKzsphy
         k9DFQDaomtxPPoNhKlVfm+ZMKYgujVZqklBC4MynuCkEITz5J6poZz9fnhCUW3O8hTMm
         FGvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cZyimMjWLBBkvjzcnu+BPtGS7EzWyaqySans44hxkOg=;
        b=zmq07SOxEjuIqppwDe7TegtUpqPAVVC8n/B5Ag435/cl55afxXSFatuuInNy0iKTtU
         UMMt3h30T8diiTCHY7xqi/RHF1tj/uyJfDwp1GW/YO7g0DWJhWwAWBiMXZHlrgHpnuPu
         APUqjIwq7qsNFKkkGRrXRIWdBNU9UamnPGu1Cbo50z6xEL6QZhvnsn04FwnY/XjFzoqR
         ZGIpQ5sarTrJRO85TJ8q2hZe4QoH7TgVpW95QfW9OvxH5a439lAzgDdh1hvX50jopcl+
         AuRpyljWV8Mli0rD15mKjNZgt49NyTLXCk0XOG3nMgMEHs0FFFy0bzK/tzU47x0BL56S
         kb6w==
X-Gm-Message-State: AFqh2krZBGSUczNFuH0Mb7b8ESWgPjt6GXqgsov0dlggnehUOchXUjLs
        aa2wz8hxrQakTSfH0zO6sX5btw==
X-Google-Smtp-Source: AMrXdXssFJrtYlZ0WeqKmNUE/qQ3IO1uxDtXbkURxiyawtvVLA/DdS8lRhRU13AsvHBJpczO5WMNEg==
X-Received: by 2002:a5e:c910:0:b0:707:a4ff:aca4 with SMTP id z16-20020a5ec910000000b00707a4ffaca4mr14481904iol.1.1674679557136;
        Wed, 25 Jan 2023 12:45:57 -0800 (PST)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id w14-20020a02968e000000b00389c2fe0f9dsm1960696jai.85.2023.01.25.12.45.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 12:45:56 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 7/8] net: ipa: introduce generalized status decoder
Date:   Wed, 25 Jan 2023 14:45:44 -0600
Message-Id: <20230125204545.3788155-8-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230125204545.3788155-1-elder@linaro.org>
References: <20230125204545.3788155-1-elder@linaro.org>
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

Stop assuming the IPA packet status has a fixed format (defined by
a C structure).  Instead, use a function to extract each field from
a block of data interpreted as an IPA packet status.  Define an
enumerated type that identifies the fields that can be extracted.
The current function extracts fields based on the existing
ipa_status structure format (which is no longer used).

Define IPA_STATUS_RULE_MISS, to replace the calls to field_max() to
represent that condition; those depended on the knowing the width of
a filter or router rule in the IPA packet status structure.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 158 +++++++++++++++++++++++++--------
 1 file changed, 120 insertions(+), 38 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 5097eb1bbadb0..3f6c3e2b6ec95 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -81,32 +81,118 @@ enum ipa_status_mask {
 	IPA_STATUS_MASK_BYTE_LIMIT		= BIT(15),
 };
 
+/* Special IPA filter/router rule field value indicating "rule miss" */
+#define IPA_STATUS_RULE_MISS	0x3ff	/* 10-bit filter/router rule fields */
+
 /** The IPA status nat_type field uses enum ipa_nat_type hardware values */
 
-/* Status element provided by hardware */
-struct ipa_status {
-	u8 opcode;		/* enum ipa_status_opcode */
-	u8 exception;		/* enum ipa_status_exception */
-	__le16 mask;		/* enum ipa_status_bit (bitmask) */
-	__le16 pkt_len;
-	u8 endp_src_idx;
-	u8 endp_dst_idx;
-	__le32 metadata;
-	__le32 flags1;
-	__le64 flags2;
-	__le32 flags3;
-	__le32 flags4;
+/* enum ipa_status_field_id - IPA packet status structure field identifiers */
+enum ipa_status_field_id {
+	STATUS_OPCODE,			/* enum ipa_status_opcode */
+	STATUS_EXCEPTION,		/* enum ipa_status_exception */
+	STATUS_MASK,			/* enum ipa_status_mask (bitmask) */
+	STATUS_LENGTH,
+	STATUS_SRC_ENDPOINT,
+	STATUS_DST_ENDPOINT,
+	STATUS_METADATA,
+	STATUS_FILTER_LOCAL,		/* Boolean */
+	STATUS_FILTER_HASH,		/* Boolean */
+	STATUS_FILTER_GLOBAL,		/* Boolean */
+	STATUS_FILTER_RETAIN,		/* Boolean */
+	STATUS_FILTER_RULE_INDEX,
+	STATUS_ROUTER_LOCAL,		/* Boolean */
+	STATUS_ROUTER_HASH,		/* Boolean */
+	STATUS_UCP,			/* Boolean */
+	STATUS_ROUTER_TABLE,
+	STATUS_ROUTER_RULE_INDEX,
+	STATUS_NAT_HIT,			/* Boolean */
+	STATUS_NAT_INDEX,
+	STATUS_NAT_TYPE,		/* enum ipa_nat_type */
+	STATUS_TAG_LOW32,		/* Low-order 32 bits of 48-bit tag */
+	STATUS_TAG_HIGH16,		/* High-order 16 bits of 48-bit tag */
+	STATUS_SEQUENCE,
+	STATUS_TIME_OF_DAY,
+	STATUS_HEADER_LOCAL,		/* Boolean */
+	STATUS_HEADER_OFFSET,
+	STATUS_FRAG_HIT,		/* Boolean */
+	STATUS_FRAG_RULE_INDEX,
 };
 
-/* Field masks for struct ipa_status structure fields */
-#define IPA_STATUS_SRC_IDX_FMASK		GENMASK(4, 0)
-#define IPA_STATUS_DST_IDX_FMASK		GENMASK(4, 0)
-#define IPA_STATUS_FLAGS1_RT_RULE_ID_FMASK	GENMASK(31, 22)
-#define IPA_STATUS_FLAGS2_TAG_FMASK		GENMASK_ULL(63, 16)
-
 /* Size in bytes of an IPA packet status structure */
 #define IPA_STATUS_SIZE			sizeof(__le32[4])
 
+/* IPA status structure decoder; looks up field values for a structure */
+static u32 ipa_status_extract(const void *data, enum ipa_status_field_id field)
+{
+	const __le32 *word = data;
+
+	switch (field) {
+	case STATUS_OPCODE:
+		return le32_get_bits(word[0], GENMASK(7, 0));
+	case STATUS_EXCEPTION:
+		return le32_get_bits(word[0], GENMASK(15, 8));
+	case STATUS_MASK:
+		return le32_get_bits(word[0], GENMASK(31, 16));
+	case STATUS_LENGTH:
+		return le32_get_bits(word[1], GENMASK(15, 0));
+	case STATUS_SRC_ENDPOINT:
+		return le32_get_bits(word[1], GENMASK(20, 16));
+	/* Status word 1, bits 21-23 are reserved */
+	case STATUS_DST_ENDPOINT:
+		return le32_get_bits(word[1], GENMASK(28, 24));
+	/* Status word 1, bits 29-31 are reserved */
+	case STATUS_METADATA:
+		return le32_to_cpu(word[2]);
+	case STATUS_FILTER_LOCAL:
+		return le32_get_bits(word[3], GENMASK(0, 0));
+	case STATUS_FILTER_HASH:
+		return le32_get_bits(word[3], GENMASK(1, 1));
+	case STATUS_FILTER_GLOBAL:
+		return le32_get_bits(word[3], GENMASK(2, 2));
+	case STATUS_FILTER_RETAIN:
+		return le32_get_bits(word[3], GENMASK(3, 3));
+	case STATUS_FILTER_RULE_INDEX:
+		return le32_get_bits(word[3], GENMASK(13, 4));
+	case STATUS_ROUTER_LOCAL:
+		return le32_get_bits(word[3], GENMASK(14, 14));
+	case STATUS_ROUTER_HASH:
+		return le32_get_bits(word[3], GENMASK(15, 15));
+	case STATUS_UCP:
+		return le32_get_bits(word[3], GENMASK(16, 16));
+	case STATUS_ROUTER_TABLE:
+		return le32_get_bits(word[3], GENMASK(21, 17));
+	case STATUS_ROUTER_RULE_INDEX:
+		return le32_get_bits(word[3], GENMASK(31, 22));
+	case STATUS_NAT_HIT:
+		return le32_get_bits(word[4], GENMASK(0, 0));
+	case STATUS_NAT_INDEX:
+		return le32_get_bits(word[4], GENMASK(13, 1));
+	case STATUS_NAT_TYPE:
+		return le32_get_bits(word[4], GENMASK(15, 14));
+	case STATUS_TAG_LOW32:
+		return le32_get_bits(word[4], GENMASK(31, 16)) |
+			(le32_get_bits(word[5], GENMASK(15, 0)) << 16);
+	case STATUS_TAG_HIGH16:
+		return le32_get_bits(word[5], GENMASK(31, 16));
+	case STATUS_SEQUENCE:
+		return le32_get_bits(word[6], GENMASK(7, 0));
+	case STATUS_TIME_OF_DAY:
+		return le32_get_bits(word[6], GENMASK(31, 8));
+	case STATUS_HEADER_LOCAL:
+		return le32_get_bits(word[7], GENMASK(0, 0));
+	case STATUS_HEADER_OFFSET:
+		return le32_get_bits(word[7], GENMASK(10, 1));
+	case STATUS_FRAG_HIT:
+		return le32_get_bits(word[7], GENMASK(11, 11));
+	case STATUS_FRAG_RULE_INDEX:
+		return le32_get_bits(word[7], GENMASK(15, 12));
+	/* Status word 7, bits 16-31 are reserved */
+	default:
+		WARN(true, "%s: bad field_id %u\n", __func__, field);
+		return 0;
+	}
+}
+
 /* Compute the aggregation size value to use for a given buffer size */
 static u32 ipa_aggr_size_kb(u32 rx_buffer_size, bool aggr_hard_limit)
 {
@@ -1355,33 +1441,32 @@ static bool ipa_status_format_packet(enum ipa_status_opcode opcode)
 	}
 }
 
-static bool ipa_endpoint_status_skip(struct ipa_endpoint *endpoint,
-				     const struct ipa_status *status)
+static bool
+ipa_endpoint_status_skip(struct ipa_endpoint *endpoint, const void *data)
 {
 	enum ipa_status_opcode opcode;
 	u32 endpoint_id;
 
-	opcode = status->opcode;
+	opcode = ipa_status_extract(data, STATUS_OPCODE);
 	if (!ipa_status_format_packet(opcode))
 		return true;
 
-	endpoint_id = u8_get_bits(status->endp_dst_idx,
-				  IPA_STATUS_DST_IDX_FMASK);
+	endpoint_id = ipa_status_extract(data, STATUS_DST_ENDPOINT);
 	if (endpoint_id != endpoint->endpoint_id)
 		return true;
 
 	return false;	/* Don't skip this packet, process it */
 }
 
-static bool ipa_endpoint_status_tag_valid(struct ipa_endpoint *endpoint,
-					  const struct ipa_status *status)
+static bool
+ipa_endpoint_status_tag_valid(struct ipa_endpoint *endpoint, const void *data)
 {
 	struct ipa_endpoint *command_endpoint;
 	enum ipa_status_mask status_mask;
 	struct ipa *ipa = endpoint->ipa;
 	u32 endpoint_id;
 
-	status_mask = le16_get_bits(status->mask, IPA_STATUS_MASK_TAG_VALID);
+	status_mask = ipa_status_extract(data, STATUS_MASK);
 	if (!status_mask)
 		return false;	/* No valid tag */
 
@@ -1390,8 +1475,7 @@ static bool ipa_endpoint_status_tag_valid(struct ipa_endpoint *endpoint,
 	 * If the packet came from the AP->command TX endpoint we know
 	 * this packet was sent as part of the pipeline clear process.
 	 */
-	endpoint_id = u8_get_bits(status->endp_src_idx,
-				  IPA_STATUS_SRC_IDX_FMASK);
+	endpoint_id = ipa_status_extract(data, STATUS_SRC_ENDPOINT);
 	command_endpoint = ipa->name_map[IPA_ENDPOINT_AP_COMMAND_TX];
 	if (endpoint_id == command_endpoint->endpoint_id) {
 		complete(&ipa->completion);
@@ -1405,26 +1489,25 @@ static bool ipa_endpoint_status_tag_valid(struct ipa_endpoint *endpoint,
 }
 
 /* Return whether the status indicates the packet should be dropped */
-static bool ipa_endpoint_status_drop(struct ipa_endpoint *endpoint,
-				     const struct ipa_status *status)
+static bool
+ipa_endpoint_status_drop(struct ipa_endpoint *endpoint, const void *data)
 {
 	enum ipa_status_exception exception;
 	u32 rule;
 
 	/* If the status indicates a tagged transfer, we'll drop the packet */
-	if (ipa_endpoint_status_tag_valid(endpoint, status))
+	if (ipa_endpoint_status_tag_valid(endpoint, data))
 		return true;
 
 	/* Deaggregation exceptions we drop; all other types we consume */
-	exception = status->exception;
+	exception = ipa_status_extract(data, STATUS_EXCEPTION);
 	if (exception)
 		return exception == IPA_STATUS_EXCEPTION_DEAGGR;
 
 	/* Drop the packet if it fails to match a routing rule; otherwise no */
-	rule = le32_get_bits(status->flags1,
-			     IPA_STATUS_FLAGS1_RT_RULE_ID_FMASK);
+	rule = ipa_status_extract(data, STATUS_ROUTER_RULE_INDEX);
 
-	return rule == field_max(IPA_STATUS_FLAGS1_RT_RULE_ID_FMASK);
+	return rule == IPA_STATUS_RULE_MISS;
 }
 
 static void ipa_endpoint_status_parse(struct ipa_endpoint *endpoint,
@@ -1436,7 +1519,6 @@ static void ipa_endpoint_status_parse(struct ipa_endpoint *endpoint,
 	u32 resid = total_len;
 
 	while (resid) {
-		const struct ipa_status *status = data;
 		u32 length;
 		u32 align;
 		u32 len;
@@ -1449,7 +1531,7 @@ static void ipa_endpoint_status_parse(struct ipa_endpoint *endpoint,
 		}
 
 		/* Skip over status packets that lack packet data */
-		length = le16_to_cpu(status->pkt_len);
+		length = ipa_status_extract(data, STATUS_LENGTH);
 		if (!length || ipa_endpoint_status_skip(endpoint, data)) {
 			data += IPA_STATUS_SIZE;
 			resid -= IPA_STATUS_SIZE;
-- 
2.34.1

