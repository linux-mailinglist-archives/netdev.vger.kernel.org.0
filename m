Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A319D530002
	for <lists+netdev@lfdr.de>; Sun, 22 May 2022 02:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245547AbiEVAcg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 20:32:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347420AbiEVAcb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 20:32:31 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F1B540A26
        for <netdev@vger.kernel.org>; Sat, 21 May 2022 17:32:30 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id y12so12136084ior.7
        for <netdev@vger.kernel.org>; Sat, 21 May 2022 17:32:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O/hJEGVRLdpoiwk4u/5VFj9MSjRvGNpyvBvim/3YzJc=;
        b=YUScAgYBJ4o4GLBfTX+dczvlWRsAM4gTN0nLkhrhs21rT1KH/5ATRKSxjnf4akTbFI
         +GkP+SVxWcswc0Mvk635r1ZiawvlTm8GdthMiuDzFMxiIm7N4yAay4I0pH6gY9u0nfZS
         cpZs7aK1CvNWItzR/ao8ExkEN0bLK1XtkkhnZN0An2qioTybQgYiW9en/ONaYVWjHR/U
         kWU+Ys3XlM+06K/woCqUBGNo3Xsw04mF2di0YcCON5pLpeQ7NFS25zT1vUcAy/wet2IU
         GKjZ6DV4iC3HlcJgp7zf6JqhfHHhABgI/cnLUFwoHxzYaGZJB1Z6/4WdCn+m0MS7AajD
         B5Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O/hJEGVRLdpoiwk4u/5VFj9MSjRvGNpyvBvim/3YzJc=;
        b=NYi4ZkrXeXD2RFIsZjlbdXydNjVYpVCP5B0C3mj2vDC0eR0FSR0MmfJ/SaQC23/41J
         ghKBytdM7EQ329xaA4tf1WgUMS/Z1WS8k7JK7wEUMJYf3c0HxBLaVhchxiECIxw3RcNu
         UjcXUZr280Dcgr1kGjsjNqmRcJcbZ80ExdW7vEdeDA44SVji18mpI48uDHZbI3Y4EGRU
         NS/3F2DNfngZGcP9oTe1ujhvhYqSvnu4FMqOAUIJxvkU/sQ/PiQgP1Sx7/NnyOxg85KN
         5Fm1C2g+Bfek9bcZW0qncZnBJvQjNbdjDdYEKi+3l4vSIrK8aSLgpocOAGyXzYo6LPVB
         5MKg==
X-Gm-Message-State: AOAM530SceuhP2UH+6KcOfYSXj2lEQlhUYlSVYjXJD4nEvjgLemFty3O
        4perCEDcXNXJZNKXmDpllz9IXw==
X-Google-Smtp-Source: ABdhPJx4/EiguPUhstcKxYnhAFO2U4V/4+lh739Tnt4W1ouT+YoYogNMQmURmxaqN2myLHqd3ORH8Q==
X-Received: by 2002:a5d:8b91:0:b0:65e:47bb:bc36 with SMTP id p17-20020a5d8b91000000b0065e47bbbc36mr6662671iol.130.1653179549988;
        Sat, 21 May 2022 17:32:29 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id g8-20020a02c548000000b0032b5e78bfcbsm1757115jaj.135.2022.05.21.17.32.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 May 2022 17:32:29 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 3/9] net: ipa: specify RX aggregation time limit in config data
Date:   Sat, 21 May 2022 19:32:17 -0500
Message-Id: <20220522003223.1123705-4-elder@linaro.org>
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

Don't assume that a 500 microsecond time limit should be used for
all receive endpoints that support aggregation.  Instead, specify
the time limit to use in the configuration data.

Set a 500 microsecond limit for all existing RX endpoints, as before.

Checking for overflow for the time limit field is a bit complicated.
Rather than duplicate a lot of code in ipa_endpoint_data_valid_one(),
call WARN() if any value is found to be too large when encoding it.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_data-v3.1.c   |  2 ++
 drivers/net/ipa/ipa_data-v3.5.1.c |  2 ++
 drivers/net/ipa/ipa_data-v4.11.c  |  2 ++
 drivers/net/ipa/ipa_data-v4.2.c   |  2 ++
 drivers/net/ipa/ipa_data-v4.5.c   |  2 ++
 drivers/net/ipa/ipa_data-v4.9.c   |  2 ++
 drivers/net/ipa/ipa_endpoint.c    | 21 +++++++++++++++++----
 drivers/net/ipa/ipa_endpoint.h    |  6 ++++++
 8 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ipa/ipa_data-v3.1.c b/drivers/net/ipa/ipa_data-v3.1.c
index 8ff351aefd23f..00f4e506e6e51 100644
--- a/drivers/net/ipa/ipa_data-v3.1.c
+++ b/drivers/net/ipa/ipa_data-v3.1.c
@@ -103,6 +103,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 				.rx = {
 					.buffer_size	= 8192,
 					.pad_align	= ilog2(sizeof(u32)),
+					.aggr_time_limit = 500,
 				},
 			},
 		},
@@ -150,6 +151,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 				.aggregation	= true,
 				.rx = {
 					.buffer_size	= 8192,
+					.aggr_time_limit = 500,
 					.aggr_close_eof	= true,
 				},
 			},
diff --git a/drivers/net/ipa/ipa_data-v3.5.1.c b/drivers/net/ipa/ipa_data-v3.5.1.c
index d1c466abddb22..b7e32e87733eb 100644
--- a/drivers/net/ipa/ipa_data-v3.5.1.c
+++ b/drivers/net/ipa/ipa_data-v3.5.1.c
@@ -94,6 +94,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 				.rx = {
 					.buffer_size	= 8192,
 					.pad_align	= ilog2(sizeof(u32)),
+					.aggr_time_limit = 500,
 				},
 			},
 		},
@@ -142,6 +143,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 				.aggregation	= true,
 				.rx = {
 					.buffer_size	= 8192,
+					.aggr_time_limit = 500,
 					.aggr_close_eof	= true,
 				},
 			},
diff --git a/drivers/net/ipa/ipa_data-v4.11.c b/drivers/net/ipa/ipa_data-v4.11.c
index b1991cc6f0ca6..1be823e5c5c22 100644
--- a/drivers/net/ipa/ipa_data-v4.11.c
+++ b/drivers/net/ipa/ipa_data-v4.11.c
@@ -88,6 +88,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 				.rx = {
 					.buffer_size	= 8192,
 					.pad_align	= ilog2(sizeof(u32)),
+					.aggr_time_limit = 500,
 				},
 			},
 		},
@@ -135,6 +136,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 				.aggregation	= true,
 				.rx = {
 					.buffer_size	= 32768,
+					.aggr_time_limit = 500,
 					.aggr_close_eof	= true,
 				},
 			},
diff --git a/drivers/net/ipa/ipa_data-v4.2.c b/drivers/net/ipa/ipa_data-v4.2.c
index 1190a43e8743c..683f1f91042f4 100644
--- a/drivers/net/ipa/ipa_data-v4.2.c
+++ b/drivers/net/ipa/ipa_data-v4.2.c
@@ -84,6 +84,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 				.rx = {
 					.buffer_size	= 8192,
 					.pad_align	= ilog2(sizeof(u32)),
+					.aggr_time_limit = 500,
 				},
 			},
 		},
@@ -132,6 +133,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 				.aggregation	= true,
 				.rx = {
 					.buffer_size	= 8192,
+					.aggr_time_limit = 500,
 					.aggr_close_eof	= true,
 				},
 			},
diff --git a/drivers/net/ipa/ipa_data-v4.5.c b/drivers/net/ipa/ipa_data-v4.5.c
index 944f72b0f285e..79398f286a9cf 100644
--- a/drivers/net/ipa/ipa_data-v4.5.c
+++ b/drivers/net/ipa/ipa_data-v4.5.c
@@ -97,6 +97,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 				.rx = {
 					.buffer_size	= 8192,
 					.pad_align	= ilog2(sizeof(u32)),
+					.aggr_time_limit = 500,
 				},
 			},
 		},
@@ -144,6 +145,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 				.aggregation	= true,
 				.rx = {
 					.buffer_size	= 8192,
+					.aggr_time_limit = 500,
 					.aggr_close_eof	= true,
 				},
 			},
diff --git a/drivers/net/ipa/ipa_data-v4.9.c b/drivers/net/ipa/ipa_data-v4.9.c
index 16786bff7ef84..4b96efd05cf22 100644
--- a/drivers/net/ipa/ipa_data-v4.9.c
+++ b/drivers/net/ipa/ipa_data-v4.9.c
@@ -89,6 +89,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 				.rx = {
 					.buffer_size	= 8192,
 					.pad_align	= ilog2(sizeof(u32)),
+					.aggr_time_limit = 500,
 				},
 			},
 		},
@@ -136,6 +137,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 				.aggregation	= true,
 				.rx = {
 					.buffer_size	= 8192,
+					.aggr_time_limit = 500,
 					.aggr_close_eof	= true,
 				},
 			},
diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 6079670bd8605..586529511cf6b 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -35,7 +35,6 @@
 #define IPA_ENDPOINT_QMAP_METADATA_MASK		0x000000ff /* host byte order */
 
 #define IPA_ENDPOINT_RESET_AGGR_RETRY_MAX	3
-#define IPA_AGGR_TIME_LIMIT			500	/* microseconds */
 
 /** enum ipa_status_opcode - status element opcode hardware values */
 enum ipa_status_opcode {
@@ -142,6 +141,13 @@ static bool ipa_endpoint_data_valid_one(struct ipa *ipa, u32 count,
 			bool result = true;
 
 			/* No aggregation; check for bogus aggregation data */
+			if (rx_config->aggr_time_limit) {
+				dev_err(dev,
+					"time limit with no aggregation for RX endpoint %u\n",
+					data->endpoint_id);
+				result = false;
+			}
+
 			if (rx_config->aggr_hard_limit) {
 				dev_err(dev, "hard limit with no aggregation for RX endpoint %u\n",
 					data->endpoint_id);
@@ -722,9 +728,13 @@ static u32 aggr_time_limit_encoded(enum ipa_version version, u32 limit)
 
 	if (version < IPA_VERSION_4_5) {
 		/* We set aggregation granularity in ipa_hardware_config() */
-		limit = DIV_ROUND_CLOSEST(limit, IPA_AGGR_GRANULARITY);
+		fmask = aggr_time_limit_fmask(true);
+		val = DIV_ROUND_CLOSEST(limit, IPA_AGGR_GRANULARITY);
+		WARN(val > field_max(fmask),
+		     "aggr_time_limit too large (%u > %u usec)\n",
+		     val, field_max(fmask) * IPA_AGGR_GRANULARITY);
 
-		return u32_encode_bits(limit, aggr_time_limit_fmask(true));
+		return u32_encode_bits(val, fmask);
 	}
 
 	/* IPA v4.5 expresses the time limit using Qtime.  The AP has
@@ -739,6 +749,9 @@ static u32 aggr_time_limit_encoded(enum ipa_version version, u32 limit)
 		/* Have to use pulse generator 1 (millisecond granularity) */
 		gran_sel = AGGR_GRAN_SEL_FMASK;
 		val = DIV_ROUND_CLOSEST(limit, 1000);
+		WARN(val > field_max(fmask),
+		     "aggr_time_limit too large (%u > %u usec)\n",
+		     limit, field_max(fmask) * 1000);
 	} else {
 		/* We can use pulse generator 0 (100 usec granularity) */
 		gran_sel = 0;
@@ -779,7 +792,7 @@ static void ipa_endpoint_init_aggr(struct ipa_endpoint *endpoint)
 						 rx_config->aggr_hard_limit);
 			val |= aggr_byte_limit_encoded(version, limit);
 
-			limit = IPA_AGGR_TIME_LIMIT;
+			limit = rx_config->aggr_time_limit;
 			val |= aggr_time_limit_encoded(version, limit);
 
 			/* AGGR_PKT_LIMIT is 0 (unlimited) */
diff --git a/drivers/net/ipa/ipa_endpoint.h b/drivers/net/ipa/ipa_endpoint.h
index 1e72a9695d3d9..01790c60bee8d 100644
--- a/drivers/net/ipa/ipa_endpoint.h
+++ b/drivers/net/ipa/ipa_endpoint.h
@@ -59,6 +59,7 @@ struct ipa_endpoint_tx {
  * struct ipa_endpoint_rx - Endpoint configuration for RX endpoints
  * @buffer_size:	requested receive buffer size (bytes)
  * @pad_align:		power-of-2 boundary to which packet payload is aligned
+ * @aggr_time_limit:	time before aggregation closes (microseconds)
  * @aggr_hard_limit:	whether aggregation closes before or after boundary
  * @aggr_close_eof:	whether aggregation closes on end-of-frame
  * @holb_drop:		whether to drop packets to avoid head-of-line blocking
@@ -74,6 +75,10 @@ struct ipa_endpoint_tx {
  * Aggregation is "open" while a buffer is being filled, and "closes" when
  * certain criteria are met.
  *
+ * A time limit can be specified to close aggregation.  Aggregation will be
+ * closed if this period passes after data is first written into a receive
+ * buffer.  If not specified, no time limit is imposed.
+ *
  * Insufficient space available in the receive buffer can close aggregation.
  * The aggregation byte limit defines the point (in units of 1024 bytes) in
  * the buffer where aggregation closes.  With a "soft" aggregation limit,
@@ -84,6 +89,7 @@ struct ipa_endpoint_tx {
 struct ipa_endpoint_rx {
 	u32 buffer_size;
 	u32 pad_align;
+	u32 aggr_time_limit;
 	bool aggr_hard_limit;
 	bool aggr_close_eof;
 	bool holb_drop;
-- 
2.32.0

