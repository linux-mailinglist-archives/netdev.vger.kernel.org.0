Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 482E357A626
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 20:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239908AbiGSSKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 14:10:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239888AbiGSSK2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 14:10:28 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 994F453D09
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 11:10:27 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id h14so885054ilq.12
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 11:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tjQd+IiiTzNLW2LdbGs9lPQ9GQarVE74SKVcOuBSN/0=;
        b=EO6nnGG7AnCHdAhOKx3ZvF6ZgT16cSGoVTK2lq/NLCf6BjUKWa6H0KbE7hvaWjALeV
         BiVR2FK3/AkDHidYSZtYsMUdlIM3Y0qUgE2oXOAKslRGn92MOh9uiT3nWSIJU/a9rxwd
         CaclPQ0DQE4Wujh6tRa8pCCIlMwe9+49hUD55grWtDedItC0M3UIbYb/zSoWreUtRDaV
         iMDptTymrRSzvdlbOc8HLpuoiSN0s24TtuNyHPSYJY49QLZ/LUHUmW71AyJya3Z+xz6J
         utAwm1Bm9SimKKZVZH3BOAbDqpbG+lDAyvnNHAAbSxNfdh7CiCvuvcJAyvBgnUCBC0jH
         Mi9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tjQd+IiiTzNLW2LdbGs9lPQ9GQarVE74SKVcOuBSN/0=;
        b=R5nQSU5AiUyfXXKIKQexyHpP5XaP1roAvqxLaKgj40f0wPZMHXpgcMFV8N6WxJ2IeC
         MuDnA+tAItMZti53vkW/sOkX+YSafiMV4lOOC8taQpf9Bwklj8DnfoBXlfdghqvVPjfM
         R0xgpC9Ou4K3kS62U2PqQyzZTyPW99FUs02Tgkym5po4QamN7n6PEwpqIxdRHzDgyot6
         FfftyZ+n1jgQUaScoe9TctlXgK9sydzabj3Ks8EeFhuzBluvKM4xoM0LzJpfIwoPqqkV
         Wv/Ip5XE9FILqVf7Gy/mvKJZcLFBEH5SR0m8uwiG0lutKM6GeRJqQSdG9k2UL+rUV1i4
         gt6w==
X-Gm-Message-State: AJIora9jp3e6LlWc1+/hBaRAH+pR1OX883puB4VHJDk1Y/oyq1kOwY5C
        KzI0ow7VTQdT37tcKIvRAXlFXg==
X-Google-Smtp-Source: AGRyM1u7S9eNd8lYMwmXC70qfb3yIKJ3nAd7Nlrel79rGyVB2YMxLPaLX9QSd8SPdAZOrBiXwcDZKw==
X-Received: by 2002:a92:c549:0:b0:2dc:949f:5514 with SMTP id a9-20020a92c549000000b002dc949f5514mr16200897ilj.301.1658254226976;
        Tue, 19 Jul 2022 11:10:26 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id f6-20020a056e020b4600b002dae42fa5f2sm6089552ilu.56.2022.07.19.11.10.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 11:10:26 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 2/5] net: ipa: rearrange transaction initialization
Date:   Tue, 19 Jul 2022 13:10:17 -0500
Message-Id: <20220719181020.372697-3-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220719181020.372697-1-elder@linaro.org>
References: <20220719181020.372697-1-elder@linaro.org>
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

The transaction map is really associated with the transaction pool;
move its definition earlier in the gsi_trans_info structure.

Rearrange initialization in gsi_channel_trans_init() so it
sets the tre_avail value first, then initializes the transaction
pool, and finally allocating the transaction map.

Update comments.

Signed-off-by: Alex Elder <elder@linaro.org>
---
v2: Fixed the misspelling of "outstanding" in two spots.

 drivers/net/ipa/gsi.h       |  3 +-
 drivers/net/ipa/gsi_trans.c | 60 +++++++++++++++++++------------------
 2 files changed, 33 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ipa/gsi.h b/drivers/net/ipa/gsi.h
index 1c8941911069d..c197df64e69a2 100644
--- a/drivers/net/ipa/gsi.h
+++ b/drivers/net/ipa/gsi.h
@@ -82,9 +82,10 @@ struct gsi_trans_pool {
 struct gsi_trans_info {
 	atomic_t tre_avail;		/* TREs available for allocation */
 	struct gsi_trans_pool pool;	/* transaction pool */
+	struct gsi_trans **map;		/* TRE -> transaction map */
+
 	struct gsi_trans_pool sg_pool;	/* scatterlist pool */
 	struct gsi_trans_pool cmd_pool;	/* command payload DMA pool */
-	struct gsi_trans **map;		/* TRE -> transaction map */
 
 	spinlock_t spinlock;		/* protects updates to the lists */
 	struct list_head alloc;		/* allocated, not committed */
diff --git a/drivers/net/ipa/gsi_trans.c b/drivers/net/ipa/gsi_trans.c
index 45572ebb76e95..3f52932e9e413 100644
--- a/drivers/net/ipa/gsi_trans.c
+++ b/drivers/net/ipa/gsi_trans.c
@@ -709,6 +709,7 @@ void gsi_trans_read_byte_done(struct gsi *gsi, u32 channel_id)
 int gsi_channel_trans_init(struct gsi *gsi, u32 channel_id)
 {
 	struct gsi_channel *channel = &gsi->channel[channel_id];
+	u32 tre_count = channel->tre_count;
 	struct gsi_trans_info *trans_info;
 	u32 tre_max;
 	int ret;
@@ -716,30 +717,40 @@ int gsi_channel_trans_init(struct gsi *gsi, u32 channel_id)
 	/* Ensure the size of a channel element is what's expected */
 	BUILD_BUG_ON(sizeof(struct gsi_tre) != GSI_RING_ELEMENT_SIZE);
 
-	/* The map array is used to determine what transaction is associated
-	 * with a TRE that the hardware reports has completed.  We need one
-	 * map entry per TRE.
-	 */
 	trans_info = &channel->trans_info;
-	trans_info->map = kcalloc(channel->tre_count, sizeof(*trans_info->map),
-				  GFP_KERNEL);
-	if (!trans_info->map)
-		return -ENOMEM;
 
-	/* We can't use more TREs than there are available in the ring.
+	/* The tre_avail field is what ultimately limits the number of
+	 * outstanding transactions and their resources.  A transaction
+	 * allocation succeeds only if the TREs available are sufficient
+	 * for what the transaction might need.
+	 */
+	tre_max = gsi_channel_tre_max(channel->gsi, channel_id);
+	atomic_set(&trans_info->tre_avail, tre_max);
+
+	/* We can't use more TREs than the number available in the ring.
 	 * This limits the number of transactions that can be outstanding.
 	 * Worst case is one TRE per transaction (but we actually limit
-	 * it to something a little less than that).  We allocate resources
-	 * for transactions (including transaction structures) based on
-	 * this maximum number.
+	 * it to something a little less than that).  By allocating a
+	 * power-of-two number of transactions we can use an index
+	 * modulo that number to determine the next one that's free.
+	 * Transactions are allocated one at a time.
 	 */
-	tre_max = gsi_channel_tre_max(channel->gsi, channel_id);
-
-	/* Transactions are allocated one at a time. */
 	ret = gsi_trans_pool_init(&trans_info->pool, sizeof(struct gsi_trans),
 				  tre_max, 1);
 	if (ret)
-		goto err_kfree;
+		return -ENOMEM;
+
+	/* A completion event contains a pointer to the TRE that caused
+	 * the event (which will be the last one used by the transaction).
+	 * Each entry in this map records the transaction associated
+	 * with a corresponding completed TRE.
+	 */
+	trans_info->map = kcalloc(tre_count, sizeof(*trans_info->map),
+				  GFP_KERNEL);
+	if (!trans_info->map) {
+		ret = -ENOMEM;
+		goto err_trans_free;
+	}
 
 	/* A transaction uses a scatterlist array to represent the data
 	 * transfers implemented by the transaction.  Each scatterlist
@@ -751,16 +762,7 @@ int gsi_channel_trans_init(struct gsi *gsi, u32 channel_id)
 				  sizeof(struct scatterlist),
 				  tre_max, channel->trans_tre_max);
 	if (ret)
-		goto err_trans_pool_exit;
-
-	/* Finally, the tre_avail field is what ultimately limits the number
-	 * of outstanding transactions and their resources.  A transaction
-	 * allocation succeeds only if the TREs available are sufficient for
-	 * what the transaction might need.  Transaction resource pools are
-	 * sized based on the maximum number of outstanding TREs, so there
-	 * will always be resources available if there are TREs available.
-	 */
-	atomic_set(&trans_info->tre_avail, tre_max);
+		goto err_map_free;
 
 	spin_lock_init(&trans_info->spinlock);
 	INIT_LIST_HEAD(&trans_info->alloc);
@@ -771,10 +773,10 @@ int gsi_channel_trans_init(struct gsi *gsi, u32 channel_id)
 
 	return 0;
 
-err_trans_pool_exit:
-	gsi_trans_pool_exit(&trans_info->pool);
-err_kfree:
+err_map_free:
 	kfree(trans_info->map);
+err_trans_free:
+	gsi_trans_pool_exit(&trans_info->pool);
 
 	dev_err(gsi->dev, "error %d initializing channel %u transactions\n",
 		ret, channel_id);
-- 
2.34.1

