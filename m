Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26230342E12
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 16:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbhCTP5j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 11:57:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbhCTP5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Mar 2021 11:57:14 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A03DC061762
        for <netdev@vger.kernel.org>; Sat, 20 Mar 2021 08:57:14 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id r8so10852325ilo.8
        for <netdev@vger.kernel.org>; Sat, 20 Mar 2021 08:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6UIku38z3Ht/kehA/YfFBbvS7rjr8VBg4gxX47vdPsw=;
        b=iaSYtFu18drpR8/8jD27YRRynvdZC5h80LwZao4s2IwiwsgDJBwjuT2h8z8nlsVGV3
         FpRKvqiVlLXwSue/hrxjCx2gOvvnI6ZaLF7gfV9VPKtDLbpKTHlGCTfCTtf4ZK532XGK
         to2iUNe9EyLjWAIyH8SQWY0Qy2EcPYk3/HAAQtknRAT7Y6UyCT83NxyscepeprQWuXqn
         2oARSgZtbLK5AtareS7N1XCzcm9fSbymdjZrUPpJPRKQtHzuxFvuNMFSajXT9aaZWDM+
         Kdg4EDxg1UeWCMzFsfhoopeUcEb+gv4AZi8TpLvCgRiPtCsw3GrP12CtiZO2i7goNDhT
         JdaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6UIku38z3Ht/kehA/YfFBbvS7rjr8VBg4gxX47vdPsw=;
        b=gDYGc+bohIbghMVTQuZuBvnRn0O2mP9GonPDp6zo+CklGz+/XrtEOFGbrrFJEAlO6k
         bdySSoPvVKEs7F+/hvrrDGSjDYuAq0U5eVZhrTt/4V/Fq408fUMoDk1+VGdpAFrCENnx
         4hsN1NX44Z6p4YpHqkUkdwi+yIj3yoK5UZfUw4P92ojw2Sy4+/ZhWvtG0feoTBASIBqZ
         3IJI4MrTDYIjLbgizvPGfDquHcalKoJnUMQe22894KC8Mn7VhmmwZGH7aQIeESUba9tt
         6c85FVcUVn5fLaMl5P+cJj5AoMA2Bpyi+ZodWBL7Ozo7UPIG5eNestZNgEeK9H78wUoF
         RNxg==
X-Gm-Message-State: AOAM532EsqWxt16tea3nHvd78kYj8G9Jf9HVb0AObHpZ4vsZXsz77Mpn
        05kvffc/VXH5SQVIgXWJcYuE4w==
X-Google-Smtp-Source: ABdhPJzmEV0Bwg322S/o/jJAcpRjCuQHcyN4KE20pwUuv+8+QY2Vw8A0xYL/SmFMrKXhwzY7G0/UXg==
X-Received: by 2002:a05:6e02:1a8c:: with SMTP id k12mr6369613ilv.14.1616255834044;
        Sat, 20 Mar 2021 08:57:14 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id n16sm4501698ilq.71.2021.03.20.08.57.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Mar 2021 08:57:13 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/5] net: ipa: sequencer type is for TX endpoints only
Date:   Sat, 20 Mar 2021 10:57:06 -0500
Message-Id: <20210320155707.2009962-5-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210320155707.2009962-1-elder@linaro.org>
References: <20210320155707.2009962-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We only program the sequencer type for TX endpoints.  So move the
definition of the sequencer type fields into the TX-specific portion
of the endpoint configuration data.  There's no need to maintain
this in the IPA structure; we can extract it from the configuration
data it points to in the one spot it's needed.

We previously specified the sequencer type for RX endpoints with
INVALID values.  These are no longer needed, so get rid of them.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_data-sc7180.c | 12 +++++-------
 drivers/net/ipa/ipa_data-sdm845.c | 10 ++++------
 drivers/net/ipa/ipa_data.h        | 13 +++++--------
 drivers/net/ipa/ipa_endpoint.c    |  7 +++----
 drivers/net/ipa/ipa_endpoint.h    |  2 --
 drivers/net/ipa/ipa_reg.h         |  2 --
 6 files changed, 17 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ipa/ipa_data-sc7180.c b/drivers/net/ipa/ipa_data-sc7180.c
index fd2265d032cc8..621ad15c9e67d 100644
--- a/drivers/net/ipa/ipa_data-sc7180.c
+++ b/drivers/net/ipa/ipa_data-sc7180.c
@@ -31,11 +31,13 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 			.tlv_count	= 20,
 		},
 		.endpoint = {
-			.seq_type	= IPA_SEQ_DMA,
 			.config = {
 				.resource_group	= 0,
 				.dma_mode	= true,
 				.dma_endpoint	= IPA_ENDPOINT_AP_LAN_RX,
+				.tx = {
+					.seq_type = IPA_SEQ_DMA,
+				},
 			},
 		},
 	},
@@ -50,8 +52,6 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 			.tlv_count	= 6,
 		},
 		.endpoint = {
-			.seq_type	= IPA_SEQ_INVALID,
-			.seq_rep_type	= IPA_SEQ_REP_INVALID,
 			.config = {
 				.resource_group	= 0,
 				.aggregation	= true,
@@ -74,14 +74,14 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 		},
 		.endpoint = {
 			.filter_support	= true,
-			.seq_type	= IPA_SEQ_1_PASS_SKIP_LAST_UC,
-			.seq_rep_type	= IPA_SEQ_REP_DMA_PARSER,
 			.config = {
 				.resource_group	= 0,
 				.checksum	= true,
 				.qmap		= true,
 				.status_enable	= true,
 				.tx = {
+					.seq_type = IPA_SEQ_1_PASS_SKIP_LAST_UC,
+					.seq_rep_type = IPA_SEQ_REP_DMA_PARSER,
 					.status_endpoint =
 						IPA_ENDPOINT_MODEM_AP_RX,
 				},
@@ -99,8 +99,6 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 			.tlv_count	= 6,
 		},
 		.endpoint = {
-			.seq_type	= IPA_SEQ_INVALID,
-			.seq_rep_type	= IPA_SEQ_REP_INVALID,
 			.config = {
 				.resource_group	= 0,
 				.checksum	= true,
diff --git a/drivers/net/ipa/ipa_data-sdm845.c b/drivers/net/ipa/ipa_data-sdm845.c
index 7f7625cd96b0d..6b5173f474444 100644
--- a/drivers/net/ipa/ipa_data-sdm845.c
+++ b/drivers/net/ipa/ipa_data-sdm845.c
@@ -36,11 +36,13 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 			.tlv_count	= 20,
 		},
 		.endpoint = {
-			.seq_type	= IPA_SEQ_DMA,
 			.config = {
 				.resource_group	= 1,
 				.dma_mode	= true,
 				.dma_endpoint	= IPA_ENDPOINT_AP_LAN_RX,
+				.tx = {
+					.seq_type = IPA_SEQ_DMA,
+				},
 			},
 		},
 	},
@@ -55,8 +57,6 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 			.tlv_count	= 8,
 		},
 		.endpoint = {
-			.seq_type	= IPA_SEQ_INVALID,
-			.seq_rep_type	= IPA_SEQ_REP_INVALID,
 			.config = {
 				.resource_group	= 1,
 				.aggregation	= true,
@@ -79,13 +79,13 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 		},
 		.endpoint = {
 			.filter_support	= true,
-			.seq_type	= IPA_SEQ_2_PASS_SKIP_LAST_UC,
 			.config = {
 				.resource_group	= 1,
 				.checksum	= true,
 				.qmap		= true,
 				.status_enable	= true,
 				.tx = {
+					.seq_type = IPA_SEQ_2_PASS_SKIP_LAST_UC,
 					.status_endpoint =
 						IPA_ENDPOINT_MODEM_AP_RX,
 				},
@@ -103,8 +103,6 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 			.tlv_count	= 8,
 		},
 		.endpoint = {
-			.seq_type	= IPA_SEQ_INVALID,
-			.seq_rep_type	= IPA_SEQ_REP_INVALID,
 			.config = {
 				.resource_group	= 1,
 				.checksum	= true,
diff --git a/drivers/net/ipa/ipa_data.h b/drivers/net/ipa/ipa_data.h
index 8808941f44afa..caf9b3f9577eb 100644
--- a/drivers/net/ipa/ipa_data.h
+++ b/drivers/net/ipa/ipa_data.h
@@ -97,12 +97,16 @@ struct gsi_channel_data {
 
 /**
  * struct ipa_endpoint_tx_data - configuration data for TX endpoints
+ * @seq_type:		primary packet processing sequencer type
+ * @seq_rep_type:	sequencer type for replication processing
  * @status_endpoint:	endpoint to which status elements are sent
  *
  * The @status_endpoint is only valid if the endpoint's @status_enable
  * flag is set.
  */
 struct ipa_endpoint_tx_data {
+	enum ipa_seq_type seq_type;
+	enum ipa_seq_rep_type seq_rep_type;
 	enum ipa_endpoint_name status_endpoint;
 };
 
@@ -154,8 +158,6 @@ struct ipa_endpoint_config_data {
 /**
  * struct ipa_endpoint_data - IPA endpoint configuration data
  * @filter_support:	whether endpoint supports filtering
- * @seq_type:		primary packet processing sequencer type
- * @seq_rep_type:	sequencer type for replication processing
  * @config:		hardware configuration (see above)
  *
  * Not all endpoints support the IPA filtering capability.  A filter table
@@ -165,15 +167,10 @@ struct ipa_endpoint_config_data {
  * in the system, and indicate whether they support filtering.
  *
  * The remaining endpoint configuration data applies only to AP endpoints.
- * The IPA hardware is implemented by sequencers, and the AP must program
- * the type(s) of these sequencers at initialization time.  The remaining
- * endpoint configuration data is defined above.
  */
 struct ipa_endpoint_data {
 	bool filter_support;
-	/* The next three are specified only for AP endpoints */
-	enum ipa_seq_type seq_type;
-	enum ipa_seq_rep_type seq_rep_type;
+	/* Everything else is specified only for AP endpoints */
 	struct ipa_endpoint_config_data config;
 };
 
diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index aab66bc4f2563..88310d3585574 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -890,10 +890,11 @@ static void ipa_endpoint_init_seq(struct ipa_endpoint *endpoint)
 		return;		/* Register not valid for RX endpoints */
 
 	/* Low-order byte configures primary packet processing */
-	val |= u32_encode_bits(endpoint->seq_type, SEQ_TYPE_FMASK);
+	val |= u32_encode_bits(endpoint->data->tx.seq_type, SEQ_TYPE_FMASK);
 
 	/* Second byte configures replicated packet processing */
-	val |= u32_encode_bits(endpoint->seq_rep_type, SEQ_REP_TYPE_FMASK);
+	val |= u32_encode_bits(endpoint->data->tx.seq_rep_type,
+			       SEQ_REP_TYPE_FMASK);
 
 	iowrite32(val, endpoint->ipa->reg_virt + offset);
 }
@@ -1764,8 +1765,6 @@ static void ipa_endpoint_init_one(struct ipa *ipa, enum ipa_endpoint_name name,
 
 	endpoint->ipa = ipa;
 	endpoint->ee_id = data->ee_id;
-	endpoint->seq_type = data->endpoint.seq_type;
-	endpoint->seq_rep_type = data->endpoint.seq_rep_type;
 	endpoint->channel_id = data->channel_id;
 	endpoint->endpoint_id = data->endpoint_id;
 	endpoint->toward_ipa = data->toward_ipa;
diff --git a/drivers/net/ipa/ipa_endpoint.h b/drivers/net/ipa/ipa_endpoint.h
index c48f5324f83cc..c6c55ea35394f 100644
--- a/drivers/net/ipa/ipa_endpoint.h
+++ b/drivers/net/ipa/ipa_endpoint.h
@@ -46,8 +46,6 @@ enum ipa_endpoint_name {
  */
 struct ipa_endpoint {
 	struct ipa *ipa;
-	enum ipa_seq_type seq_type;
-	enum ipa_seq_rep_type seq_rep_type;
 	enum gsi_ee_id ee_id;
 	u32 channel_id;
 	u32 endpoint_id;
diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
index a7ea11a5d2259..36fe746575f6b 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -602,7 +602,6 @@ enum ipa_seq_type {
 	IPA_SEQ_1_PASS_SKIP_LAST_UC		= 0x06,
 	IPA_SEQ_2_PASS				= 0x0a,
 	IPA_SEQ_3_PASS_SKIP_LAST_UC		= 0x0c,
-	IPA_SEQ_INVALID				= 0x0c,
 };
 
 /**
@@ -615,7 +614,6 @@ enum ipa_seq_type {
  */
 enum ipa_seq_rep_type {
 	IPA_SEQ_REP_DMA_PARSER			= 0x08,
-	IPA_SEQ_REP_INVALID			= 0x0c,
 };
 
 #define IPA_REG_ENDP_STATUS_N_OFFSET(ep) \
-- 
2.27.0

