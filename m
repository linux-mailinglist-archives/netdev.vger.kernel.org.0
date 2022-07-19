Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB3757A623
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 20:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239886AbiGSSK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 14:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239873AbiGSSK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 14:10:27 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D729225E97
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 11:10:25 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id i5so706304ila.6
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 11:10:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RiJ6za5WGQV1BAnIZFKP4V1CTKa7dcOQ4Ym7UXXJgDw=;
        b=MI0cT46VeHZjWnA8I20bS8/dWwD6fXh4FOX8Ip0CBdhoLwLKwSwudRHHyBVKzJ+xio
         7644dM7gQBSvsJRoe0L02+t7zdrDRLpmNuaCG7E5KXu1FJm9QnNgKfBhn7LgcZBqMeKO
         rKbWAbyjZcHB8nFi10JVGlCZfep8jUu2pe8ZTKyvFZghoTzrJT98I1kAb9CUXfk9uFI2
         LQnEm4fWGdJuUfuiHT0qRp+KVNF+cQqT3FT3tu81HyY69Te/G3c5AzeNAc13l5DjUE1W
         U3yw/M7kPinYv8PYTNmfjKU6wmUT8dH6qo08NQFrkGqqg2VNt3tYzuTzY7Q9WJmgvGfw
         DzgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RiJ6za5WGQV1BAnIZFKP4V1CTKa7dcOQ4Ym7UXXJgDw=;
        b=GydoS3ZwbH2ashV0ARHB9uLsl1jsbJOmyGYX9pK0bwga/hwcM6R5EkxSpkNqWT49rf
         17gVkwd4IubfaeKslpxx0vdy4tYPSYbLt6W4lSUnzHKmd7YjP2uh9d48LKGLK1Pm0bDf
         6TmhR3Oo438rxzibgNhrc7wj8QsegrCE4zbuEWhVqrUwjbPrrafnsYWEqzqMlHTssT09
         yCivqcIzTW5nHPBghhbn4kK3SvW3KcPJEAWfqJ1xnp40ryyHSkXhip32Lh9MLsbBqK5I
         dMGgbsMTwJIyEHOTcYTBU66QJBhesM1fA//P2V64IQZ3MK0jhPx7ymW7kneRmuQiE0jk
         P9KA==
X-Gm-Message-State: AJIora+9WcrdWkCyAncaA4BpRMb5Dl6DBtDajksW1GNpwsxd8DnqpA5/
        F+Yjw9a1geBeLCpbUmicuEs+DA==
X-Google-Smtp-Source: AGRyM1tvR+7gAXrdskYPMbxFeak6h5GHdpmtt2p0zWyuTfpwuDxk+dSf7tSEWo6wecMbLvLlSfGqCA==
X-Received: by 2002:a05:6e02:178c:b0:2dc:2783:aac3 with SMTP id y12-20020a056e02178c00b002dc2783aac3mr17297988ilu.142.1658254225533;
        Tue, 19 Jul 2022 11:10:25 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id f6-20020a056e020b4600b002dae42fa5f2sm6089552ilu.56.2022.07.19.11.10.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 11:10:25 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 1/5] net: ipa: add a transaction committed list
Date:   Tue, 19 Jul 2022 13:10:16 -0500
Message-Id: <20220719181020.372697-2-elder@linaro.org>
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

We currently put a transaction on the pending list when it has
been committed.  But until the channel's doorbell rings, these
transactions aren't actually "owned" by the hardware yet.

Add a new "committed" state (and list), to represent transactions
that have been committed but not yet sent to hardware.  Define
"pending" to mean committed transactions that have been sent
to hardware but have not yet completed.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c       |  5 ++++-
 drivers/net/ipa/gsi.h       |  5 +++--
 drivers/net/ipa/gsi_trans.c | 26 ++++++++++++++++++++++----
 3 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 4e46974a69ecd..c70fd4bab1d68 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -718,6 +718,9 @@ static struct gsi_trans *gsi_channel_trans_last(struct gsi_channel *channel)
 	 */
 	if (channel->toward_ipa) {
 		list = &trans_info->alloc;
+		if (!list_empty(list))
+			goto done;
+		list = &trans_info->committed;
 		if (!list_empty(list))
 			goto done;
 		list = &trans_info->pending;
@@ -1363,7 +1366,7 @@ gsi_event_trans(struct gsi *gsi, struct gsi_event *event)
  * first *unfilled* event in the ring (following the last filled one).
  *
  * Events are sequential within the event ring, and transactions are
- * sequential within the transaction pool.
+ * sequential within the transaction array.
  *
  * Note that @index always refers to an element *within* the event ring.
  */
diff --git a/drivers/net/ipa/gsi.h b/drivers/net/ipa/gsi.h
index bad1a78a96ede..1c8941911069d 100644
--- a/drivers/net/ipa/gsi.h
+++ b/drivers/net/ipa/gsi.h
@@ -88,7 +88,8 @@ struct gsi_trans_info {
 
 	spinlock_t spinlock;		/* protects updates to the lists */
 	struct list_head alloc;		/* allocated, not committed */
-	struct list_head pending;	/* committed, awaiting completion */
+	struct list_head committed;	/* committed, awaiting doorbell */
+	struct list_head pending;	/* pending, awaiting completion */
 	struct list_head complete;	/* completed, awaiting poll */
 	struct list_head polled;	/* returned by gsi_channel_poll_one() */
 };
@@ -184,7 +185,7 @@ void gsi_teardown(struct gsi *gsi);
  * @gsi:	GSI pointer
  * @channel_id:	Channel whose limit is to be returned
  *
- * Return:	 The maximum number of TREs oustanding on the channel
+ * Return:	 The maximum number of TREs outstanding on the channel
  */
 u32 gsi_channel_tre_max(struct gsi *gsi, u32 channel_id);
 
diff --git a/drivers/net/ipa/gsi_trans.c b/drivers/net/ipa/gsi_trans.c
index 29496ca15825f..45572ebb76e95 100644
--- a/drivers/net/ipa/gsi_trans.c
+++ b/drivers/net/ipa/gsi_trans.c
@@ -241,15 +241,31 @@ struct gsi_trans *gsi_channel_trans_complete(struct gsi_channel *channel)
 					struct gsi_trans, links);
 }
 
-/* Move a transaction from the allocated list to the pending list */
+/* Move a transaction from the allocated list to the committed list */
+static void gsi_trans_move_committed(struct gsi_trans *trans)
+{
+	struct gsi_channel *channel = &trans->gsi->channel[trans->channel_id];
+	struct gsi_trans_info *trans_info = &channel->trans_info;
+
+	spin_lock_bh(&trans_info->spinlock);
+
+	list_move_tail(&trans->links, &trans_info->committed);
+
+	spin_unlock_bh(&trans_info->spinlock);
+}
+
+/* Move transactions from the committed list to the pending list */
 static void gsi_trans_move_pending(struct gsi_trans *trans)
 {
 	struct gsi_channel *channel = &trans->gsi->channel[trans->channel_id];
 	struct gsi_trans_info *trans_info = &channel->trans_info;
+	struct list_head list;
 
 	spin_lock_bh(&trans_info->spinlock);
 
-	list_move_tail(&trans->links, &trans_info->pending);
+	/* Move this transaction and all predecessors to the pending list */
+	list_cut_position(&list, &trans_info->committed, &trans->links);
+	list_splice_tail(&list, &trans_info->pending);
 
 	spin_unlock_bh(&trans_info->spinlock);
 }
@@ -581,13 +597,14 @@ static void __gsi_trans_commit(struct gsi_trans *trans, bool ring_db)
 	if (channel->toward_ipa)
 		gsi_trans_tx_committed(trans);
 
-	gsi_trans_move_pending(trans);
+	gsi_trans_move_committed(trans);
 
 	/* Ring doorbell if requested, or if all TREs are allocated */
 	if (ring_db || !atomic_read(&channel->trans_info.tre_avail)) {
 		/* Report what we're handing off to hardware for TX channels */
 		if (channel->toward_ipa)
 			gsi_trans_tx_queued(trans);
+		gsi_trans_move_pending(trans);
 		gsi_channel_doorbell(channel);
 	}
 }
@@ -710,7 +727,7 @@ int gsi_channel_trans_init(struct gsi *gsi, u32 channel_id)
 		return -ENOMEM;
 
 	/* We can't use more TREs than there are available in the ring.
-	 * This limits the number of transactions that can be oustanding.
+	 * This limits the number of transactions that can be outstanding.
 	 * Worst case is one TRE per transaction (but we actually limit
 	 * it to something a little less than that).  We allocate resources
 	 * for transactions (including transaction structures) based on
@@ -747,6 +764,7 @@ int gsi_channel_trans_init(struct gsi *gsi, u32 channel_id)
 
 	spin_lock_init(&trans_info->spinlock);
 	INIT_LIST_HEAD(&trans_info->alloc);
+	INIT_LIST_HEAD(&trans_info->committed);
 	INIT_LIST_HEAD(&trans_info->pending);
 	INIT_LIST_HEAD(&trans_info->complete);
 	INIT_LIST_HEAD(&trans_info->polled);
-- 
2.34.1

