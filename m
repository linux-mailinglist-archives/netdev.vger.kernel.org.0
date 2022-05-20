Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE0652F377
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 20:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353127AbiETSz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 14:55:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353041AbiETSzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 14:55:46 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48B3018AA92
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 11:55:42 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id d3so6105735ilr.10
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 11:55:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O/hJEGVRLdpoiwk4u/5VFj9MSjRvGNpyvBvim/3YzJc=;
        b=fyxtyUOPH8fSOEgdE0y9DVnA9Bce0Rxr9m/nXyNCi/MjPsaNhmCxa2UksO4vjv15Lb
         Y5yU3BVWRCVO3Yt92Y/b2qOLlGOySjmB3XzP7x1Joj6hRNtCnbmO6oLcq/oXNxbo0cZX
         Cnxmc56jFUZ0/gV8dsF8jKmVw7FuYqzmPJY4U4S86/o1Pn60MOw5HQjTj8nVFXSQPSDz
         c2z0g7P8nilOugVErsywgXgxCKtEkMdYttUlkwby9fCBGs66xz2SR/OIPWrTvXJ6Q2pE
         b5xqZOY3qbpU42XYnsmhYziGMeE8myjJJd7g4xwoAT/U//T6Qlgzm8XfLIwV41mOflhp
         Rauw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O/hJEGVRLdpoiwk4u/5VFj9MSjRvGNpyvBvim/3YzJc=;
        b=ObKx/KcSTzbcjlDlvkN66IiVzHINWqkJDx10NszVCRMpghCDzwUDvZJtoteevoGDPM
         8T6OQHiThJvJOz8zNlDaeUUg2+PaG/LnWcne/t/qFFPBB32Cpth4nxOGqZ2OgW8d8+p1
         FncPpj0lb6j66ePwTrFmKQhuXWRemgppTRSZpdJyw8YjYmf7/AIicHrmh1teggesPr0q
         nFjSqi0QmYT5ZaQJmhe0i7pk0fHCZs2zM2UTF6kjp1ZuWP18etan+ilqS3YVa/fYnsI0
         duhdKVnyjuwt2ROb+AvKNgiNjh41pmlBuAlKbEpzOqAM+aDJMRxZsQfNi4pDTYrXhw8Z
         sRHg==
X-Gm-Message-State: AOAM531IxZbHluS360LW5rz02x7nOkArA3GwuQ1nFauIBnwhoMd7x8d7
        NVfBArj71UCWQgAZJPEcVM5xMg==
X-Google-Smtp-Source: ABdhPJwcAwB3/qjOMNJzHWE4YVnRSuOpM+eHNwES2j1f4iGrDzXRTl+y0z8GItv1yVndQfNBJFS19A==
X-Received: by 2002:a05:6e02:17ce:b0:2d1:1c16:5084 with SMTP id z14-20020a056e0217ce00b002d11c165084mr5995717ilu.88.1653072941585;
        Fri, 20 May 2022 11:55:41 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id a6-20020a056638058600b0032b3a7817acsm871958jar.112.2022.05.20.11.55.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 May 2022 11:55:41 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/8] net: ipa: specify RX aggregation time limit in config data
Date:   Fri, 20 May 2022 13:55:28 -0500
Message-Id: <20220520185533.877920-4-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220520185533.877920-1-elder@linaro.org>
References: <20220520185533.877920-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
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

