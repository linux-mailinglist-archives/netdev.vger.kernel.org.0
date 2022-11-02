Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EDE661707A
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 23:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231577AbiKBWMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 18:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231391AbiKBWL5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 18:11:57 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BED87BE3D
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 15:11:52 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id n191so16212877iod.13
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 15:11:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I2FQR/TZoXdysImvRhkVYhJLndEF88jeNyajxedG2m8=;
        b=DKGDBHa4ChyspX2xHHiAqwSCoi4N6umabEH/mL+vjxCyao5UcLr5/LWPNvxvQzTRsA
         TQ5cIFIJq7zH9iNQpO8NegI/2BI3pyh4UNK9DtFnwEER9RX1TpSu7YTs6AwP2R36ktPM
         QwHTRTUVeTuGvNlfJrc0MY+5OkobF1EKSACqf51zQFDbT1l0SvcZo9TLxZAZcFq/hq6Y
         uKcxj3CpQWPB8jWcctK94NTmtyv8w4QUOoSkUGnpnnG0hIpCi/JYJe40xsFpzzdrRybo
         1/kEbdIUyJYZO6fFG4ZJBgax82U63sf4/jDMR7l8VN8ypw5nQwq4xCghDZZdgRKUuH8i
         7klQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I2FQR/TZoXdysImvRhkVYhJLndEF88jeNyajxedG2m8=;
        b=QpdhX4rok6sPTr8+Iz1kskf7bxCN065A1GEkEfjfbECUg+mHjdkiK5l5+xwJ2UKeER
         BIuhPKj0SiWqxI+C/PQuQ8S6bJlTErU+2i1hSQQEZ1BqmJNz/7qYmlVSI1dvJVBVcyCH
         NwX2j9roYUus3N3IEldQIeDgqRhqpb6H38T5Z3dzhQyZS8sKATnkuYyFzALaOAbt+LXI
         b8MNkACamIxBwwWrqPkSPulEVNB4D6aFT23ESzZ+CWDK4iMnHsn0r/6tJs78ElZY43Ra
         dLPZJjeEFq+bo1Sg0bnyFU0wtoJf7LaHztcP+jnuYUz7Ox71/ArvOFmPbfCJaxfFnaGz
         LTBQ==
X-Gm-Message-State: ACrzQf2UJP4ZYeFsK0afya7QsJ8/fSApg1ewcH+ioZLo+iypBAAhVXJ+
        Z1uW2iXwwhuCYhPY6v01TK7+WA==
X-Google-Smtp-Source: AMsMyM4uER85x3y9JTLwUW047r+F7dibSl4l9gZO1msij1MzoBhBm9LktXa8+3HLD+Sys1Ng5RI7fA==
X-Received: by 2002:a05:6602:1491:b0:6d2:c228:a157 with SMTP id a17-20020a056602149100b006d2c228a157mr9917401iow.116.1667427111833;
        Wed, 02 Nov 2022 15:11:51 -0700 (PDT)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id f8-20020a02a108000000b0037465a1dd3fsm5073974jag.156.2022.11.02.15.11.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 15:11:51 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 7/9] net: ipa: support more filtering endpoints
Date:   Wed,  2 Nov 2022 17:11:37 -0500
Message-Id: <20221102221139.1091510-8-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221102221139.1091510-1-elder@linaro.org>
References: <20221102221139.1091510-1-elder@linaro.org>
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

Prior to IPA v5.0, there could be no more than 32 endpoints.

A filter table begins with a bitmap indicating which endpoints have
a filter defined.  That bitmap is currently assumed to fit in a
32-bit value.

Starting with IPA v5.0, more than 32 endpoints are supported, so
it's conceivable that a TX endpoint has an ID that exceeds 32.
Increase the size of the field representing endpoints that support
filtering to 64 bits.  Rename the bitmap field "filtered".

Unlike other similar fields, we do not use an (arbitrarily long)
Linux bitmap for this purpose.  The reason is that if a filter table
ever *did* need to support more than 64 TX endpoints, its format
would change in ways we can't anticipate.

Have ipa_endpoint_init() return a negative errno rather than a mask
that indicates which endpoints support filtering, and have that
function assign the "filtered" field directly.

Signed-off-by: Alex Elder <elder@linaro.org>
---
v2: - Don't print a message on bitmap allocation failure
    - Clean up error handling in ipa_endpoint_init()

 drivers/net/ipa/ipa.h          |  4 ++--
 drivers/net/ipa/ipa_endpoint.c | 22 +++++++++++++---------
 drivers/net/ipa/ipa_endpoint.h |  2 +-
 drivers/net/ipa/ipa_main.c     |  7 ++-----
 drivers/net/ipa/ipa_table.c    | 23 +++++++++++------------
 drivers/net/ipa/ipa_table.h    |  6 +++---
 6 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ipa/ipa.h b/drivers/net/ipa/ipa.h
index c603575e2a58b..557101c2d5838 100644
--- a/drivers/net/ipa/ipa.h
+++ b/drivers/net/ipa/ipa.h
@@ -65,7 +65,7 @@ struct ipa_interrupt;
  * @available_count:	Number of defined bits in the available bitmap
  * @defined:		Bitmap of endpoints defined in config data
  * @available:		Bitmap of endpoints supported by hardware
- * @filter_map:		Bit mask indicating endpoints that support filtering
+ * @filtered:		Bitmap of endpoints that support filtering
  * @set_up:		Bit mask indicating endpoints set up
  * @enabled:		Bit mask indicating endpoints enabled
  * @modem_tx_count:	Number of defined modem TX endoints
@@ -123,7 +123,7 @@ struct ipa {
 	u32 available_count;
 	unsigned long *defined;		/* Defined in configuration data */
 	unsigned long *available;	/* Supported by hardware */
-	u32 filter_map;
+	u64 filtered;			/* Support filtering (AP and modem) */
 	u32 set_up;
 	u32 enabled;
 
diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index a7932e8d0b2bf..03811871dc4aa 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -1973,6 +1973,8 @@ void ipa_endpoint_exit(struct ipa *ipa)
 {
 	u32 endpoint_id;
 
+	ipa->filtered = 0;
+
 	for_each_set_bit(endpoint_id, ipa->defined, ipa->endpoint_count)
 		ipa_endpoint_exit_one(&ipa->endpoint[endpoint_id]);
 
@@ -1984,25 +1986,25 @@ void ipa_endpoint_exit(struct ipa *ipa)
 }
 
 /* Returns a bitmask of endpoints that support filtering, or 0 on error */
-u32 ipa_endpoint_init(struct ipa *ipa, u32 count,
+int ipa_endpoint_init(struct ipa *ipa, u32 count,
 		      const struct ipa_gsi_endpoint_data *data)
 {
 	enum ipa_endpoint_name name;
-	u32 filter_map;
+	u32 filtered;
 
 	BUILD_BUG_ON(!IPA_REPLENISH_BATCH);
 
 	/* Number of endpoints is one more than the maximum ID */
 	ipa->endpoint_count = ipa_endpoint_max(ipa, count, data) + 1;
 	if (!ipa->endpoint_count)
-		return 0;	/* Error */
+		return -EINVAL;
 
 	/* Initialize the defined endpoint bitmap */
 	ipa->defined = bitmap_zalloc(ipa->endpoint_count, GFP_KERNEL);
 	if (!ipa->defined)
-		return 0;	/* Error */
+		return -ENOMEM;
 
-	filter_map = 0;
+	filtered = 0;
 	for (name = 0; name < count; name++, data++) {
 		if (ipa_gsi_endpoint_data_empty(data))
 			continue;	/* Skip over empty slots */
@@ -2010,18 +2012,20 @@ u32 ipa_endpoint_init(struct ipa *ipa, u32 count,
 		ipa_endpoint_init_one(ipa, name, data);
 
 		if (data->endpoint.filter_support)
-			filter_map |= BIT(data->endpoint_id);
+			filtered |= BIT(data->endpoint_id);
 		if (data->ee_id == GSI_EE_MODEM && data->toward_ipa)
 			ipa->modem_tx_count++;
 	}
 
-	if (!ipa_filter_map_valid(ipa, filter_map))
+	if (!ipa_filtered_valid(ipa, filtered))
 		goto err_endpoint_exit;
 
-	return filter_map;	/* Non-zero bitmask */
+	ipa->filtered = filtered;
+
+	return 0;
 
 err_endpoint_exit:
 	ipa_endpoint_exit(ipa);
 
-	return 0;	/* Error */
+	return -EINVAL;
 }
diff --git a/drivers/net/ipa/ipa_endpoint.h b/drivers/net/ipa/ipa_endpoint.h
index d8dfa24f52140..4a5c3bc549df5 100644
--- a/drivers/net/ipa/ipa_endpoint.h
+++ b/drivers/net/ipa/ipa_endpoint.h
@@ -195,7 +195,7 @@ void ipa_endpoint_deconfig(struct ipa *ipa);
 void ipa_endpoint_default_route_set(struct ipa *ipa, u32 endpoint_id);
 void ipa_endpoint_default_route_clear(struct ipa *ipa);
 
-u32 ipa_endpoint_init(struct ipa *ipa, u32 count,
+int ipa_endpoint_init(struct ipa *ipa, u32 count,
 		      const struct ipa_gsi_endpoint_data *data);
 void ipa_endpoint_exit(struct ipa *ipa);
 
diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 8f6a6890697e8..ebb6c9b311eb9 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -788,12 +788,9 @@ static int ipa_probe(struct platform_device *pdev)
 		goto err_mem_exit;
 
 	/* Result is a non-zero mask of endpoints that support filtering */
-	ipa->filter_map = ipa_endpoint_init(ipa, data->endpoint_count,
-					    data->endpoint_data);
-	if (!ipa->filter_map) {
-		ret = -EINVAL;
+	ret = ipa_endpoint_init(ipa, data->endpoint_count, data->endpoint_data);
+	if (ret)
 		goto err_gsi_exit;
-	}
 
 	ret = ipa_table_init(ipa);
 	if (ret)
diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
index 3a14465bf8a64..cc9349a1d4df9 100644
--- a/drivers/net/ipa/ipa_table.c
+++ b/drivers/net/ipa/ipa_table.c
@@ -161,20 +161,20 @@ ipa_table_mem(struct ipa *ipa, bool filter, bool hashed, bool ipv6)
 	return ipa_mem_find(ipa, mem_id);
 }
 
-bool ipa_filter_map_valid(struct ipa *ipa, u32 filter_map)
+bool ipa_filtered_valid(struct ipa *ipa, u64 filtered)
 {
 	struct device *dev = &ipa->pdev->dev;
 	u32 count;
 
-	if (!filter_map) {
+	if (!filtered) {
 		dev_err(dev, "at least one filtering endpoint is required\n");
 
 		return false;
 	}
 
-	count = hweight32(filter_map);
+	count = hweight64(filtered);
 	if (count > ipa->filter_count) {
-		dev_err(dev, "too many filtering endpoints (%u, max %u)\n",
+		dev_err(dev, "too many filtering endpoints (%u > %u)\n",
 			count, ipa->filter_count);
 
 		return false;
@@ -230,12 +230,11 @@ static void ipa_table_reset_add(struct gsi_trans *trans, bool filter,
 static int
 ipa_filter_reset_table(struct ipa *ipa, bool hashed, bool ipv6, bool modem)
 {
-	u32 ep_mask = ipa->filter_map;
-	u32 count = hweight32(ep_mask);
+	u64 ep_mask = ipa->filtered;
 	struct gsi_trans *trans;
 	enum gsi_ee_id ee_id;
 
-	trans = ipa_cmd_trans_alloc(ipa, count);
+	trans = ipa_cmd_trans_alloc(ipa, hweight64(ep_mask));
 	if (!trans) {
 		dev_err(&ipa->pdev->dev,
 			"no transaction for %s filter reset\n",
@@ -405,7 +404,7 @@ static void ipa_table_init_add(struct gsi_trans *trans, bool filter, bool ipv6)
 		 * to hold the bitmap itself.  The size of the hashed filter
 		 * table is either the same as the non-hashed one, or zero.
 		 */
-		count = 1 + hweight32(ipa->filter_map);
+		count = 1 + hweight64(ipa->filtered);
 		hash_count = hash_mem && hash_mem->size ? count : 0;
 	} else {
 		/* The size of a route table region determines the number
@@ -503,7 +502,7 @@ static void ipa_filter_tuple_zero(struct ipa_endpoint *endpoint)
 static void ipa_filter_config(struct ipa *ipa, bool modem)
 {
 	enum gsi_ee_id ee_id = modem ? GSI_EE_MODEM : GSI_EE_AP;
-	u32 ep_mask = ipa->filter_map;
+	u64 ep_mask = ipa->filtered;
 
 	if (!ipa_table_hash_support(ipa))
 		return;
@@ -615,7 +614,7 @@ bool ipa_table_mem_valid(struct ipa *ipa, bool filter)
 		/* Filter tables must able to hold the endpoint bitmap plus
 		 * an entry for each endpoint that supports filtering
 		 */
-		if (count < 1 + hweight32(ipa->filter_map))
+		if (count < 1 + hweight64(ipa->filtered))
 			return false;
 	} else {
 		/* Routing tables must be able to hold all modem entries,
@@ -720,9 +719,9 @@ int ipa_table_init(struct ipa *ipa)
 	 * that option, so there's no shifting required.
 	 */
 	if (ipa->version < IPA_VERSION_5_0)
-		*virt++ = cpu_to_le64((u64)ipa->filter_map << 1);
+		*virt++ = cpu_to_le64(ipa->filtered << 1);
 	else
-		*virt++ = cpu_to_le64((u64)ipa->filter_map);
+		*virt++ = cpu_to_le64(ipa->filtered);
 
 	/* All the rest contain the DMA address of the zero rule */
 	le_addr = cpu_to_le64(addr);
diff --git a/drivers/net/ipa/ipa_table.h b/drivers/net/ipa/ipa_table.h
index 8a4dcd7df4c0f..7cc951904bb48 100644
--- a/drivers/net/ipa/ipa_table.h
+++ b/drivers/net/ipa/ipa_table.h
@@ -11,13 +11,13 @@
 struct ipa;
 
 /**
- * ipa_filter_map_valid() - Validate a filter table endpoint bitmap
+ * ipa_filtered_valid() - Validate a filter table endpoint bitmap
  * @ipa:	IPA pointer
- * @filter_mask: Filter table endpoint bitmap to check
+ * @filtered:	Filter table endpoint bitmap to check
  *
  * Return:	true if all regions are valid, false otherwise
  */
-bool ipa_filter_map_valid(struct ipa *ipa, u32 filter_mask);
+bool ipa_filtered_valid(struct ipa *ipa, u64 filtered);
 
 /**
  * ipa_table_hash_support() - Return true if hashed tables are supported
-- 
2.34.1

