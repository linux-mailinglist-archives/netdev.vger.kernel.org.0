Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68F625AF27B
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 19:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234270AbiIFR2m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 13:28:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234604AbiIFR2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 13:28:06 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D4F1DA57
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 10:19:50 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id q81so9461064iod.9
        for <netdev@vger.kernel.org>; Tue, 06 Sep 2022 10:19:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=vGV0LErzUVZ+oH6Ahl3yaA3wsEhujDLPCmZWellXY2E=;
        b=fhyOsKBoGlfGVT9fE6T//G3it4Qv/vOjcLFmHO38ILsRfLiLXvp+ayam+rsB5VpbKt
         ZptduDSgOvMw+UEBpcwMDtsCtDWKmWC4/MD6cvmdqkb3bTctUQhE3bgxudC/6/3ZROIu
         5R02jOk0zW/rxhOx1lXDYdmB6FTOwuJtQ3n9a4M/fQw84OENtySHrft/h3xiiTdh+nB3
         HKrnR3/1BKgXTstaqmMufCPCQpZQ73BKYwUzGWEvOia4zugtnGurXldHke/ZpoGvn5gB
         WlR2UuYN2D/lpJgtJOCEX5p6uZEjtCcfF18nsnG4hNdyfOz4Iqw3i4yjBx1mf/ebXsN7
         /Wrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=vGV0LErzUVZ+oH6Ahl3yaA3wsEhujDLPCmZWellXY2E=;
        b=eCYEo33sy48tvXPVbS9ym2bhAcSpsNTZlNvOjRTK+Je3qOMqGC4H/Z4oCFqPnXt2MO
         HOKUXAT6O1+wvyrdnVlBIjCr8VUx5neHjmZ+UX7s/4S5UZ864NqHbGpE3GIp+jB2HY/l
         GuXmOi5mfDbE96T1u2M2+p/l9h/WpuNpn1/lmfEgxzrJXA1Li40fcXi0trceDqVR0V6l
         tcCrqwzbYyPIv8bI7AIDfiVNbdVikKvxu/ViyZn/GRGqWtkmaasJtgUh2x0PiOjHlpry
         uEdzL+ZXRu73U0yGY/pq+ugNHPXsgMelam+Ngv2pzYM1P1wpAxxWcopvhvg+uhJ/Cm+n
         hgaQ==
X-Gm-Message-State: ACgBeo2w3E8hHrDXPK8k92PnN3G3uM7pt6KRUHG2+7uiQCTqxw+hKc9W
        JnoSxuUHlbLKBvo9ynXO937CEg==
X-Google-Smtp-Source: AA6agR4n1LTlHdCfl+Mih055iDKJd42eGpUqbhFXFSCI+CzoZ+ZKWIDBkHhj882oa/5RuGb1q1s2Iw==
X-Received: by 2002:a05:6602:490:b0:678:d781:446d with SMTP id y16-20020a056602049000b00678d781446dmr26173445iov.115.1662484789865;
        Tue, 06 Sep 2022 10:19:49 -0700 (PDT)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id q10-20020a056e020c2a00b002eb3f5fc4easm5292204ilg.27.2022.09.06.10.19.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 10:19:49 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/5] net: ipa: kill all other transaction lists
Date:   Tue,  6 Sep 2022 12:19:40 -0500
Message-Id: <20220906171942.957704-4-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220906171942.957704-1-elder@linaro.org>
References: <20220906171942.957704-1-elder@linaro.org>
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

None of the transaction lists are actually needed any more, because
transaction IDs (which have been shown to be equivalent) are used
instead.  So we can remove all of them, as well as the spinlock
that protects updates to them.

Not requiring a lock simplifies gsi_trans_free() as well; we only
need to check the reference count once to decide whether we've hit
the last reference.

This makes the links field in the gsi_trans structure unused, so get
rid of that as well.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.h       |  6 ----
 drivers/net/ipa/gsi_trans.c | 71 ++++---------------------------------
 drivers/net/ipa/gsi_trans.h |  3 --
 3 files changed, 6 insertions(+), 74 deletions(-)

diff --git a/drivers/net/ipa/gsi.h b/drivers/net/ipa/gsi.h
index a3f2d27a7e4b3..84d178a1a7d22 100644
--- a/drivers/net/ipa/gsi.h
+++ b/drivers/net/ipa/gsi.h
@@ -94,12 +94,6 @@ struct gsi_trans_info {
 
 	struct gsi_trans_pool sg_pool;	/* scatterlist pool */
 	struct gsi_trans_pool cmd_pool;	/* command payload DMA pool */
-
-	spinlock_t spinlock;		/* protects updates to the lists */
-	struct list_head committed;	/* committed, awaiting doorbell */
-	struct list_head pending;	/* pending, awaiting completion */
-	struct list_head complete;	/* completed, awaiting poll */
-	struct list_head polled;	/* returned by gsi_channel_poll_one() */
 };
 
 /* Hardware values signifying the state of a channel */
diff --git a/drivers/net/ipa/gsi_trans.c b/drivers/net/ipa/gsi_trans.c
index 254c09824004c..a3ae0ca4813c6 100644
--- a/drivers/net/ipa/gsi_trans.c
+++ b/drivers/net/ipa/gsi_trans.c
@@ -252,75 +252,43 @@ static void gsi_trans_move_committed(struct gsi_trans *trans)
 	struct gsi_channel *channel = &trans->gsi->channel[trans->channel_id];
 	struct gsi_trans_info *trans_info = &channel->trans_info;
 
-	spin_lock_bh(&trans_info->spinlock);
-
-	list_add_tail(&trans->links, &trans_info->committed);
-
-	spin_unlock_bh(&trans_info->spinlock);
-
 	/* This allocated transaction is now committed */
 	trans_info->allocated_id++;
 }
 
-/* Move transactions from the committed list to the pending list */
+/* Move committed transactions to pending state */
 static void gsi_trans_move_pending(struct gsi_trans *trans)
 {
 	struct gsi_channel *channel = &trans->gsi->channel[trans->channel_id];
 	struct gsi_trans_info *trans_info = &channel->trans_info;
 	u16 trans_index = trans - &trans_info->trans[0];
-	struct list_head list;
 	u16 delta;
 
-	spin_lock_bh(&trans_info->spinlock);
-
-	/* Move this transaction and all predecessors to the pending list */
-	list_cut_position(&list, &trans_info->committed, &trans->links);
-	list_splice_tail(&list, &trans_info->pending);
-
-	spin_unlock_bh(&trans_info->spinlock);
-
 	/* These committed transactions are now pending */
 	delta = trans_index - trans_info->committed_id + 1;
 	trans_info->committed_id += delta % channel->tre_count;
 }
 
-/* Move a transaction and all of its predecessors from the pending list
- * to the completed list.
- */
+/* Move pending transactions to completed state */
 void gsi_trans_move_complete(struct gsi_trans *trans)
 {
 	struct gsi_channel *channel = &trans->gsi->channel[trans->channel_id];
 	struct gsi_trans_info *trans_info = &channel->trans_info;
 	u16 trans_index = trans - trans_info->trans;
-	struct list_head list;
 	u16 delta;
 
-	spin_lock_bh(&trans_info->spinlock);
-
-	/* Move this transaction and all predecessors to completed list */
-	list_cut_position(&list, &trans_info->pending, &trans->links);
-	list_splice_tail(&list, &trans_info->complete);
-
-	spin_unlock_bh(&trans_info->spinlock);
-
 	/* These pending transactions are now completed */
 	delta = trans_index - trans_info->pending_id + 1;
 	delta %= channel->tre_count;
 	trans_info->pending_id += delta;
 }
 
-/* Move a transaction from the completed list to the polled list */
+/* Move a transaction from completed to polled state */
 void gsi_trans_move_polled(struct gsi_trans *trans)
 {
 	struct gsi_channel *channel = &trans->gsi->channel[trans->channel_id];
 	struct gsi_trans_info *trans_info = &channel->trans_info;
 
-	spin_lock_bh(&trans_info->spinlock);
-
-	list_move_tail(&trans->links, &trans_info->polled);
-
-	spin_unlock_bh(&trans_info->spinlock);
-
 	/* This completed transaction is now polled */
 	trans_info->completed_id++;
 }
@@ -383,7 +351,6 @@ struct gsi_trans *gsi_channel_trans_alloc(struct gsi *gsi, u32 channel_id,
 	memset(trans, 0, sizeof(*trans));
 
 	/* Initialize non-zero fields in the transaction */
-	INIT_LIST_HEAD(&trans->links);
 	trans->gsi = gsi;
 	trans->channel_id = channel_id;
 	trans->rsvd_count = tre_count;
@@ -396,7 +363,7 @@ struct gsi_trans *gsi_channel_trans_alloc(struct gsi *gsi, u32 channel_id,
 	trans->direction = direction;
 	refcount_set(&trans->refcount, 1);
 
-	/* This free transaction will now be allocated */
+	/* This free transaction is now allocated */
 	trans_info->free_id++;
 
 	return trans;
@@ -405,31 +372,15 @@ struct gsi_trans *gsi_channel_trans_alloc(struct gsi *gsi, u32 channel_id,
 /* Free a previously-allocated transaction */
 void gsi_trans_free(struct gsi_trans *trans)
 {
-	refcount_t *refcount = &trans->refcount;
 	struct gsi_trans_info *trans_info;
-	bool last;
 
-	/* We must hold the lock to release the last reference */
-	if (refcount_dec_not_one(refcount))
-		return;
-
-	trans_info = &trans->gsi->channel[trans->channel_id].trans_info;
-
-	spin_lock_bh(&trans_info->spinlock);
-
-	/* Reference might have been added before we got the lock */
-	last = refcount_dec_and_test(refcount);
-	if (last)
-		list_del(&trans->links);
-
-	spin_unlock_bh(&trans_info->spinlock);
-
-	if (!last)
+	if (!refcount_dec_and_test(&trans->refcount))
 		return;
 
 	/* Unused transactions are allocated but never committed, pending,
 	 * completed, or polled.
 	 */
+	trans_info = &trans->gsi->channel[trans->channel_id].trans_info;
 	if (!trans->used_count) {
 		trans_info->allocated_id++;
 		trans_info->committed_id++;
@@ -692,11 +643,6 @@ void gsi_channel_trans_cancel_pending(struct gsi_channel *channel)
 	u16 trans_id = trans_info->pending_id;
 
 	/* channel->gsi->mutex is held by caller */
-	spin_lock_bh(&trans_info->spinlock);
-
-	list_splice_tail_init(&trans_info->pending, &trans_info->complete);
-
-	spin_unlock_bh(&trans_info->spinlock);
 
 	/* If there are no pending transactions, we're done */
 	if (trans_id == trans_info->committed_id)
@@ -815,11 +761,6 @@ int gsi_channel_trans_init(struct gsi *gsi, u32 channel_id)
 	if (ret)
 		goto err_map_free;
 
-	spin_lock_init(&trans_info->spinlock);
-	INIT_LIST_HEAD(&trans_info->committed);
-	INIT_LIST_HEAD(&trans_info->pending);
-	INIT_LIST_HEAD(&trans_info->complete);
-	INIT_LIST_HEAD(&trans_info->polled);
 
 	return 0;
 
diff --git a/drivers/net/ipa/gsi_trans.h b/drivers/net/ipa/gsi_trans.h
index 7084507830c21..af8c4c6719d11 100644
--- a/drivers/net/ipa/gsi_trans.h
+++ b/drivers/net/ipa/gsi_trans.h
@@ -29,7 +29,6 @@ struct gsi_trans_pool;
  * struct gsi_trans - a GSI transaction
  *
  * Most fields in this structure for internal use by the transaction core code:
- * @links:	Links for channel transaction lists by state
  * @gsi:	GSI pointer
  * @channel_id: Channel number transaction is associated with
  * @cancelled:	If set by the core code, transaction was cancelled
@@ -50,8 +49,6 @@ struct gsi_trans_pool;
  * received.
  */
 struct gsi_trans {
-	struct list_head links;		/* gsi_channel lists */
-
 	struct gsi *gsi;
 	u8 channel_id;
 
-- 
2.34.1

