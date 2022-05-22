Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32EE8530009
	for <lists+netdev@lfdr.de>; Sun, 22 May 2022 02:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347965AbiEVAcd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 20:32:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344568AbiEVAcb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 20:32:31 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B471340930
        for <netdev@vger.kernel.org>; Sat, 21 May 2022 17:32:29 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id e194so12096067iof.11
        for <netdev@vger.kernel.org>; Sat, 21 May 2022 17:32:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hNHj18Pk290f11iq3jTbhbcmsqgCknmENNznS9C6gdk=;
        b=kJTlt5YRoe5urnbQdQT3RvhkSKoiMZ7YR5SIwY3bAn8E+TXLebh7Soug5KbH2Q36fn
         m7yxIBj5gThA0L40Y5ZSAAtAr+Y3ArSQ+bqBscEK8e8hJ0oevxU0iyp45TVowEOdkN9E
         LL/6Ah6mqX5EHQZSQR/Vq9JHoEGB9XGU5ugRe1qxs1lLcsrzyx8A8kHmTT0mJlNw5Ufu
         bS9cZeEkOuujffbZoaK333NKZ97zbhHyUQCIZmapDWPsOK2ty2Wt7beCkjGpcC9gAxy3
         1tdPQ0q4Z9jTuiHGlsTkrkVx3+Xm6N5vuj0HbYbLWfv8pQCYEc8GB4wh2gU6Ks9Mwxxk
         Ir0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hNHj18Pk290f11iq3jTbhbcmsqgCknmENNznS9C6gdk=;
        b=ORer8mOtFTwB5JuVbp5NTK97h7nxq9voiJ8JdEHvmhwCwNi51wqWSTy8l25fCMmFKD
         6oPXA6JBBb4P8pa3/gS/Vv1TzBFmfJ0Kx4VS1s90LgVsTmVTqmxsDMPUKftve2m7X7EV
         44cmSkUNS27iWz8J4uhs3e2DTUEkAOnC6ZYatIOwC48VUYxJwvmLJ6oC2IMJT7457l1a
         Kbfl0iCusMySnX9KY3CSswyBumQcVG2UEvMvQ4NaRz+fz0DtGuO5TRY61bvyHo+vdBPl
         x8m7ObQxxXFIIs22v52jofeJrEZ4LgC7w9g61SJheQ/3Q/wFesxqrbkM5rek7RkvxM5J
         4PJA==
X-Gm-Message-State: AOAM531tS1FKy+9yO52HVVX2mMS0CZz9cJV9uzazxMNh1EZlR+1OsXGm
        IuSYvk6oHbPDx2SXIV6VR4mp5g==
X-Google-Smtp-Source: ABdhPJw3+r3+3wYlOtgN7exHO5itMZ5ZeSIkdzU4nCi1sblSyXkWyfkGlPQHeWPl+aPUd3YeLeOVBQ==
X-Received: by 2002:a05:6638:248c:b0:32e:be23:7160 with SMTP id x12-20020a056638248c00b0032ebe237160mr735222jat.311.1653179548996;
        Sat, 21 May 2022 17:32:28 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id g8-20020a02c548000000b0032b5e78bfcbsm1757115jaj.135.2022.05.21.17.32.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 May 2022 17:32:28 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 2/9] net: ipa: support hard aggregation limits
Date:   Sat, 21 May 2022 19:32:16 -0500
Message-Id: <20220522003223.1123705-3-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220522003223.1123705-1-elder@linaro.org>
References: <20220522003223.1123705-1-elder@linaro.org>
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

Add a new flag for AP receive endpoints that indicates whether
a "hard limit" is used as a criterion for closing aggregation.
Add comments explaining the difference between "hard" and "soft"
aggregation limits.

Pass a flag to ipa_aggr_size_kb() so it computes the proper
aggregation size value whether using hard or soft limits.  Move
that function earlier in "ipa_endpoint.c" so it can be used
without a forward-reference.

Update ipa_endpoint_data_valid_one() so it validates endpoints whose
data indicate a hard aggregation limit is used, and so it reports
set aggregation flags for endpoints without aggregation enabled.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 89 +++++++++++++++++++++-------------
 drivers/net/ipa/ipa_endpoint.h | 15 +++++-
 2 files changed, 69 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 3ad97fbf6884e..6079670bd8605 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -81,6 +81,24 @@ static u32 aggr_byte_limit_max(enum ipa_version version)
 	return field_max(aggr_byte_limit_fmask(false));
 }
 
+/* Compute the aggregation size value to use for a given buffer size */
+static u32 ipa_aggr_size_kb(u32 rx_buffer_size, bool aggr_hard_limit)
+{
+	/* A hard aggregation limit will not be crossed; aggregation closes
+	 * if saving incoming data would cross the hard byte limit boundary.
+	 *
+	 * With a soft limit, aggregation closes *after* the size boundary
+	 * has been crossed.  In that case the limit must leave enough space
+	 * after that limit to receive a full MTU of data plus overhead.
+	 */
+	if (!aggr_hard_limit)
+		rx_buffer_size -= IPA_MTU + IPA_RX_BUFFER_OVERHEAD;
+
+	/* The byte limit is encoded as a number of kilobytes */
+
+	return rx_buffer_size / SZ_1K;
+}
+
 static bool ipa_endpoint_data_valid_one(struct ipa *ipa, u32 count,
 			    const struct ipa_gsi_endpoint_data *all_data,
 			    const struct ipa_gsi_endpoint_data *data)
@@ -93,7 +111,9 @@ static bool ipa_endpoint_data_valid_one(struct ipa *ipa, u32 count,
 		return true;
 
 	if (!data->toward_ipa) {
+		const struct ipa_endpoint_rx *rx_config;
 		u32 buffer_size;
+		u32 aggr_size;
 		u32 limit;
 
 		if (data->endpoint.filter_support) {
@@ -107,8 +127,10 @@ static bool ipa_endpoint_data_valid_one(struct ipa *ipa, u32 count,
 		if (data->ee_id != GSI_EE_AP)
 			return true;
 
-		buffer_size = data->endpoint.config.rx.buffer_size;
+		rx_config = &data->endpoint.config.rx;
+
 		/* The buffer size must hold an MTU plus overhead */
+		buffer_size = rx_config->buffer_size;
 		limit = IPA_MTU + IPA_RX_BUFFER_OVERHEAD;
 		if (buffer_size < limit) {
 			dev_err(dev, "RX buffer size too small for RX endpoint %u (%u < %u)\n",
@@ -116,27 +138,39 @@ static bool ipa_endpoint_data_valid_one(struct ipa *ipa, u32 count,
 			return false;
 		}
 
-		/* For an endpoint supporting receive aggregation, the
-		 * aggregation byte limit defines the point at which an
-		 * aggregation window will close.  It is programmed into the
-		 * IPA hardware as a number of KB.  We don't use "hard byte
-		 * limit" aggregation, so we need to supply enough space in
-		 * a receive buffer to hold a complete MTU plus normal skb
-		 * overhead *after* that aggregation byte limit has been
-		 * crossed.
-		 *
-		 * This check just ensures the receive buffer size doesn't
-		 * exceed what's representable in the aggregation limit field.
+		if (!data->endpoint.config.aggregation) {
+			bool result = true;
+
+			/* No aggregation; check for bogus aggregation data */
+			if (rx_config->aggr_hard_limit) {
+				dev_err(dev, "hard limit with no aggregation for RX endpoint %u\n",
+					data->endpoint_id);
+				result = false;
+			}
+
+			if (rx_config->aggr_close_eof) {
+				dev_err(dev, "close EOF with no aggregation for RX endpoint %u\n",
+					data->endpoint_id);
+				result = false;
+			}
+
+			return result;	/* Nothing more to check */
+		}
+
+		/* For an endpoint supporting receive aggregation, the byte
+		 * limit defines the point at which aggregation closes.  This
+		 * check ensures the receive buffer size doesn't result in a
+		 * limit that exceeds what's representable in the aggregation
+		 * byte limit field.
 		 */
-		if (data->endpoint.config.aggregation) {
-			limit += SZ_1K * aggr_byte_limit_max(ipa->version);
-			if (buffer_size - NET_SKB_PAD > limit) {
-				dev_err(dev, "RX buffer size too large for aggregated RX endpoint %u (%u > %u)\n",
-					data->endpoint_id,
-					buffer_size - NET_SKB_PAD, limit);
+		aggr_size = ipa_aggr_size_kb(buffer_size - NET_SKB_PAD,
+					     rx_config->aggr_hard_limit);
+		limit = aggr_byte_limit_max(ipa->version);
+		if (aggr_size > limit) {
+			dev_err(dev, "aggregated size too large for RX endpoint %u (%u KB > %u KB)\n",
+				data->endpoint_id, aggr_size, limit);
 
-				return false;
-			}
+			return false;
 		}
 
 		return true;	/* Nothing more to check for RX */
@@ -670,18 +704,6 @@ static void ipa_endpoint_init_mode(struct ipa_endpoint *endpoint)
 	iowrite32(val, endpoint->ipa->reg_virt + offset);
 }
 
-/* Compute the aggregation size value to use for a given buffer size */
-static u32 ipa_aggr_size_kb(u32 rx_buffer_size)
-{
-	/* We don't use "hard byte limit" aggregation, so we define the
-	 * aggregation limit such that our buffer has enough space *after*
-	 * that limit to receive a full MTU of data, plus overhead.
-	 */
-	rx_buffer_size -= IPA_MTU + IPA_RX_BUFFER_OVERHEAD;
-
-	return rx_buffer_size / SZ_1K;
-}
-
 /* Encoded values for AGGR endpoint register fields */
 static u32 aggr_byte_limit_encoded(enum ipa_version version, u32 limit)
 {
@@ -753,7 +775,8 @@ static void ipa_endpoint_init_aggr(struct ipa_endpoint *endpoint)
 			val |= u32_encode_bits(IPA_GENERIC, AGGR_TYPE_FMASK);
 
 			buffer_size = rx_config->buffer_size;
-			limit = ipa_aggr_size_kb(buffer_size - NET_SKB_PAD);
+			limit = ipa_aggr_size_kb(buffer_size - NET_SKB_PAD,
+						 rx_config->aggr_hard_limit);
 			val |= aggr_byte_limit_encoded(version, limit);
 
 			limit = IPA_AGGR_TIME_LIMIT;
diff --git a/drivers/net/ipa/ipa_endpoint.h b/drivers/net/ipa/ipa_endpoint.h
index 3ab62fb892ec6..1e72a9695d3d9 100644
--- a/drivers/net/ipa/ipa_endpoint.h
+++ b/drivers/net/ipa/ipa_endpoint.h
@@ -59,21 +59,32 @@ struct ipa_endpoint_tx {
  * struct ipa_endpoint_rx - Endpoint configuration for RX endpoints
  * @buffer_size:	requested receive buffer size (bytes)
  * @pad_align:		power-of-2 boundary to which packet payload is aligned
+ * @aggr_hard_limit:	whether aggregation closes before or after boundary
  * @aggr_close_eof:	whether aggregation closes on end-of-frame
  * @holb_drop:		whether to drop packets to avoid head-of-line blocking
  *
+ * The actual size of the receive buffer is rounded up if necessary
+ * to be a power-of-2 number of pages.
+ *
  * With each packet it transfers, the IPA hardware can perform certain
  * transformations of its packet data.  One of these is adding pad bytes
  * to the end of the packet data so the result ends on a power-of-2 boundary.
  *
  * It is also able to aggregate multiple packets into a single receive buffer.
  * Aggregation is "open" while a buffer is being filled, and "closes" when
- * certain criteria are met.  One of those criteria is the sender indicating
- * a "frame" consisting of several transfers has ended.
+ * certain criteria are met.
+ *
+ * Insufficient space available in the receive buffer can close aggregation.
+ * The aggregation byte limit defines the point (in units of 1024 bytes) in
+ * the buffer where aggregation closes.  With a "soft" aggregation limit,
+ * aggregation closes when a packet written to the buffer *crosses* that
+ * aggregation limit.  With a "hard" aggregation limit, aggregation will
+ * close *before* writing a packet that would cross that boundary.
  */
 struct ipa_endpoint_rx {
 	u32 buffer_size;
 	u32 pad_align;
+	bool aggr_hard_limit;
 	bool aggr_close_eof;
 	bool holb_drop;
 };
-- 
2.32.0

