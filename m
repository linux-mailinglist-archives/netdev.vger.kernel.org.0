Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0FD5A891B
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 00:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbiHaWk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 18:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232536AbiHaWkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 18:40:25 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A7507C307
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 15:40:23 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id y187so13195924iof.0
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 15:40:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=hjkW+5FH7s1T93UZlntThyQm/ZXADqLvUTT7CWgmonE=;
        b=Nnwv169lcchIRi5N50vLHCVg0GD83gYuwrhUTbKeysdRSeVhUfGyShjZkynN+H9fkz
         Llyy/qD77FnfR+XAHjvR1oWIxt9XRP1OxinTBBrs0rTXoxs9R2LF7GenOozgEgtruMcz
         Ku/swqIu8gVSnXHYcwMIKYQggwfbRaUEjGeHwiLbeW7Gg3yM/YE2I+kyNmPXDO0tWcQh
         txaonBYPfNiaNveIL24qrg8QKDDVT1bctVPwy1PVgdJqXFLLjKwfHU98p+t2EQHHC90P
         v0Uy7L/4laStfaoAg5HcA00OT3mPvGAsk7izfExnF28oQ/VpQOBpdkcqfhcZ2dygSndb
         Clkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=hjkW+5FH7s1T93UZlntThyQm/ZXADqLvUTT7CWgmonE=;
        b=i6skpHDR3Wa/Ag2/wChD4dZnIdt/SOHxvv1ayBcibKatqLDj4BgHaSw5JVtFvYsSXE
         f5ZDcNWXk3eM/QddtWC1FYvlKdhd/ETB5mVLH7EoRxYcR7qxXxHEvTgbBHRvghl0e9bB
         K8PhxQk0rv44gk6+VM4zWH+tGEpwDF6czESwlbQDtn26VvONDKIvWq4T9MLNVQyqbnkQ
         dsjeknrsXXSGtyWCXG4vV4ka7u0W2esA5C31zYX8n+xhewmF8aks/4uKSsHHNoxz83Ak
         eRHWIx3u133RAng38hqf1K5pBfdCtzht/lJk9kdTPVXUe/drVExVD9b8A3281eqdypQP
         LWzQ==
X-Gm-Message-State: ACgBeo2okQHwc7CaJfyIOiYA/A2h0fwKIERGuxvWQVCeZbjIHtiwrsRB
        hMEiLFkM5eMB82rNbOgYF9LX/A==
X-Google-Smtp-Source: AA6agR45AL7Z4KePSZ1jjAe8UmsoVzWr6mvZ/vFqsqKv1g3vR9ZLPuFuj/WzxpSanqjvbTKtI3fPww==
X-Received: by 2002:a05:6638:3892:b0:342:8aa5:a050 with SMTP id b18-20020a056638389200b003428aa5a050mr16835283jav.145.1661985622865;
        Wed, 31 Aug 2022 15:40:22 -0700 (PDT)
Received: from localhost.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id n30-20020a02a19e000000b0034c0db05629sm1392005jah.161.2022.08.31.15.40.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 15:40:22 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/6] net: ipa: use an array for transactions
Date:   Wed, 31 Aug 2022 17:40:12 -0500
Message-Id: <20220831224017.377745-2-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220831224017.377745-1-elder@linaro.org>
References: <20220831224017.377745-1-elder@linaro.org>
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

Transactions are always allocated one at a time.  The maximum number
of them we could ever need occurs if each TRE is assigned to a
transaction.  So a channel requires no more transactions than the
number of TREs in its transfer ring.  That number is known to be a
power-of-2 less than 65536.

The transaction pool abstraction is used for other things, but for
transactions we can use a simple array of transaction structures,
and use a free index to indicate which entry in the array is the
next one free for allocation.

By having the number of elements in the array be a power-of-2, we
can use an ever-incrementing 16-bit free index, and use it modulo
the array size.  Distinguish a "trans_id" (whose value can exceed
the number of entries in the transaction array) from a "trans_index"
(which is less than the number of entries).

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.h       |  4 +++-
 drivers/net/ipa/gsi_trans.c | 39 +++++++++++++++++++++----------------
 2 files changed, 25 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ipa/gsi.h b/drivers/net/ipa/gsi.h
index 23de5f67374cf..4a88aec7e7d92 100644
--- a/drivers/net/ipa/gsi.h
+++ b/drivers/net/ipa/gsi.h
@@ -82,7 +82,9 @@ struct gsi_trans_pool {
 
 struct gsi_trans_info {
 	atomic_t tre_avail;		/* TREs available for allocation */
-	struct gsi_trans_pool pool;	/* transaction pool */
+
+	u16 free_id;			/* first free trans in array */
+	struct gsi_trans *trans;	/* transaction array */
 	struct gsi_trans **map;		/* TRE -> transaction map */
 
 	struct gsi_trans_pool sg_pool;	/* scatterlist pool */
diff --git a/drivers/net/ipa/gsi_trans.c b/drivers/net/ipa/gsi_trans.c
index 18e7e8c405bea..9775e50d0423f 100644
--- a/drivers/net/ipa/gsi_trans.c
+++ b/drivers/net/ipa/gsi_trans.c
@@ -343,20 +343,22 @@ struct gsi_trans *gsi_channel_trans_alloc(struct gsi *gsi, u32 channel_id,
 	struct gsi_channel *channel = &gsi->channel[channel_id];
 	struct gsi_trans_info *trans_info;
 	struct gsi_trans *trans;
+	u16 trans_index;
 
 	if (WARN_ON(tre_count > channel->trans_tre_max))
 		return NULL;
 
 	trans_info = &channel->trans_info;
 
-	/* We reserve the TREs now, but consume them at commit time.
-	 * If there aren't enough available, we're done.
-	 */
+	/* If we can't reserve the TREs for the transaction, we're done */
 	if (!gsi_trans_tre_reserve(trans_info, tre_count))
 		return NULL;
 
-	/* Allocate and initialize non-zero fields in the transaction */
-	trans = gsi_trans_pool_alloc(&trans_info->pool, 1);
+	trans_index = trans_info->free_id % channel->tre_count;
+	trans = &trans_info->trans[trans_index];
+	memset(trans, 0, sizeof(*trans));
+
+	/* Initialize non-zero fields in the transaction */
 	trans->gsi = gsi;
 	trans->channel_id = channel_id;
 	trans->rsvd_count = tre_count;
@@ -367,15 +369,17 @@ struct gsi_trans *gsi_channel_trans_alloc(struct gsi *gsi, u32 channel_id,
 	sg_init_marker(trans->sgl, tre_count);
 
 	trans->direction = direction;
-
-	spin_lock_bh(&trans_info->spinlock);
-
-	list_add_tail(&trans->links, &trans_info->alloc);
-
-	spin_unlock_bh(&trans_info->spinlock);
-
 	refcount_set(&trans->refcount, 1);
 
+	/* This free transaction will now be allocated */
+	trans_info->free_id++;
+
+	spin_lock_bh(&trans_info->spinlock);
+
+	list_add_tail(&trans->links, &trans_info->alloc);
+
+	spin_unlock_bh(&trans_info->spinlock);
+
 	return trans;
 }
 
@@ -736,10 +740,11 @@ int gsi_channel_trans_init(struct gsi *gsi, u32 channel_id)
 	 * modulo that number to determine the next one that's free.
 	 * Transactions are allocated one at a time.
 	 */
-	ret = gsi_trans_pool_init(&trans_info->pool, sizeof(struct gsi_trans),
-				  tre_max, 1);
-	if (ret)
+	trans_info->trans = kcalloc(tre_count, sizeof(*trans_info->trans),
+				    GFP_KERNEL);
+	if (!trans_info->trans)
 		return -ENOMEM;
+	trans_info->free_id = 0;	/* modulo channel->tre_count */
 
 	/* A completion event contains a pointer to the TRE that caused
 	 * the event (which will be the last one used by the transaction).
@@ -777,7 +782,7 @@ int gsi_channel_trans_init(struct gsi *gsi, u32 channel_id)
 err_map_free:
 	kfree(trans_info->map);
 err_trans_free:
-	gsi_trans_pool_exit(&trans_info->pool);
+	kfree(trans_info->trans);
 
 	dev_err(gsi->dev, "error %d initializing channel %u transactions\n",
 		ret, channel_id);
@@ -791,6 +796,6 @@ void gsi_channel_trans_exit(struct gsi_channel *channel)
 	struct gsi_trans_info *trans_info = &channel->trans_info;
 
 	gsi_trans_pool_exit(&trans_info->sg_pool);
-	gsi_trans_pool_exit(&trans_info->pool);
+	kfree(trans_info->trans);
 	kfree(trans_info->map);
 }
-- 
2.34.1

