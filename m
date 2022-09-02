Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBD925AB9C3
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 23:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbiIBVC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 17:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230441AbiIBVCY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 17:02:24 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAC72266F
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 14:02:23 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id i77so2639144ioa.7
        for <netdev@vger.kernel.org>; Fri, 02 Sep 2022 14:02:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=CapqBxxG2aQ7YyEDkhNervwPkhRRBUyf1g0dzj7goM4=;
        b=eYvg4J5jpvvPaQIqJUqSlwN0mHZaEJbWRNbtYkVhnkl+auAHZJm668yx5tVKTAcoAW
         x2x7jfh0NmBDsRGusvSwypORs2PY5dsaIlcYOF59ojoo/jL63B2G2nMWNjAjcwrTNojY
         NwOgSJldMVyvo/tkvGi5be241KJiL5/XYygVOlKcGDO4IQppVx0FZW/mdVsN3VV6OAtJ
         hBbq2fFciLD12D0RnW/LvsaHnK0TBtmRg8NiYrPERewQQNMrDjQY0zYqkAaPj7Jt5N1H
         ATYx5Iqo6OsagIifZ7u06HwMIVYUQFAIMmWsBHqQeE0Z/7R+gmjL3O6sFeX/dwcdESe8
         jOlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=CapqBxxG2aQ7YyEDkhNervwPkhRRBUyf1g0dzj7goM4=;
        b=wnm9fUO6Mkcq3S/chQRenpZWJ15r3+eiW2gfNP8vyb922qWsJ2VxgHHpX978A56ivp
         isgvTy4B9H6mvuthHoTiBi0iykN9c8Fy3DljiipwXKzOE5hS7CXrFz36ygEH8diy2zke
         JUL/JFwv5fdCRhkY7uHIoQwDej4k29vWk8oezoZUr0D6ARupBQMOjJqt8+7e/tYdlJf6
         cbx4gpetsp3/Xl/q4cBlF4LCFNnE8ZaGkR+YOkakpH8WYwfEdcSXQZVax3fdg/a5jSlJ
         cuPvIAygjdCB6u8XY44q6J/obOCSj3BkR9/YB0nMr93rNSeDpbhjksOMmCd6ynUwR6c8
         qtrw==
X-Gm-Message-State: ACgBeo3NImbpPYRQUXmW3GGPo4jJ1t8m7nuAFquZ6syO2vDj9C1WYoxV
        shfSqrlcAiVDpio4pnptjZGO+g==
X-Google-Smtp-Source: AA6agR7Gnx2ZG9dvb0e7jrJUIVtwH7AObQFpx6Y8qeynDsUXuODKsVVGmdwdmgXxxgNSEvDMdh8Q/Q==
X-Received: by 2002:a05:6638:2042:b0:34c:f22:25b3 with SMTP id t2-20020a056638204200b0034c0f2225b3mr7240077jaj.75.1662152543043;
        Fri, 02 Sep 2022 14:02:23 -0700 (PDT)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id i7-20020a0566022c8700b00689e718d971sm1259208iow.51.2022.09.02.14.02.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Sep 2022 14:02:22 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/6] net: ipa: rework last transaction determination
Date:   Fri,  2 Sep 2022 16:02:13 -0500
Message-Id: <20220902210218.745873-2-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220902210218.745873-1-elder@linaro.org>
References: <20220902210218.745873-1-elder@linaro.org>
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

When quiescing a channel, we find the "last" transaction, which is
the latest one to have been allocated.  (New transaction allocation
will have been prevented by the time this is called.)

Currently we do this by looking for the first non-empty transaction
list in each state, then return the last entry from that last.
Instead, determine the last entry in each list (if any) and return
that entry if found.

Temporarily (locally) introduce list_last_entry_or_null() as a
helper for this, mirroring list_first_entry_or_null().  This macro
definition will be removed by an upcoming patch.

Remove the temporary warnings added by the previous commit.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c         | 28 ++++++++++++++--------------
 drivers/net/ipa/gsi_private.h | 14 ++++++++++++++
 drivers/net/ipa/gsi_trans.c   | 22 ----------------------
 3 files changed, 28 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 9e307eebd33f9..0ea98fa5dee56 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -710,7 +710,6 @@ static void gsi_evt_ring_program(struct gsi *gsi, u32 evt_ring_id)
 static struct gsi_trans *gsi_channel_trans_last(struct gsi_channel *channel)
 {
 	struct gsi_trans_info *trans_info = &channel->trans_info;
-	const struct list_head *list;
 	struct gsi_trans *trans;
 
 	spin_lock_bh(&trans_info->spinlock);
@@ -719,29 +718,30 @@ static struct gsi_trans *gsi_channel_trans_last(struct gsi_channel *channel)
 	 * before we disabled transmits, so check for that.
 	 */
 	if (channel->toward_ipa) {
-		list = &trans_info->alloc;
-		if (!list_empty(list))
+		trans = list_last_entry_or_null(&trans_info->alloc,
+						struct gsi_trans, links);
+		if (trans)
 			goto done;
-		list = &trans_info->committed;
-		if (!list_empty(list))
+		trans = list_last_entry_or_null(&trans_info->committed,
+						struct gsi_trans, links);
+		if (trans)
 			goto done;
-		list = &trans_info->pending;
-		if (!list_empty(list))
+		trans = list_last_entry_or_null(&trans_info->pending,
+						struct gsi_trans, links);
+		if (trans)
 			goto done;
 	}
 
 	/* Otherwise (TX or RX) we want to wait for anything that
 	 * has completed, or has been polled but not released yet.
 	 */
-	list = &trans_info->complete;
-	if (!list_empty(list))
+	trans = list_last_entry_or_null(&trans_info->complete,
+					struct gsi_trans, links);
+	if (trans)
 		goto done;
-	list = &trans_info->polled;
-	if (list_empty(list))
-		list = NULL;
+	trans = list_last_entry_or_null(&trans_info->polled,
+					struct gsi_trans, links);
 done:
-	trans = list ? list_last_entry(list, struct gsi_trans, links) : NULL;
-
 	/* Caller will wait for this, so take a reference */
 	if (trans)
 		refcount_inc(&trans->refcount);
diff --git a/drivers/net/ipa/gsi_private.h b/drivers/net/ipa/gsi_private.h
index 0b2516fa21b5d..51bbc7a40dc2d 100644
--- a/drivers/net/ipa/gsi_private.h
+++ b/drivers/net/ipa/gsi_private.h
@@ -16,6 +16,20 @@ struct gsi_channel;
 
 #define GSI_RING_ELEMENT_SIZE	16	/* bytes; must be a power of 2 */
 
+/**
+ * list_last_entry_or_null - get the last element from a list
+ * @ptr:	the list head to take the element from.
+ * @type:	the type of the struct this is embedded in.
+ * @member:	the name of the list_head within the struct.
+ *
+ * Note that if the list is empty, it returns NULL.
+ */
+#define list_last_entry_or_null(ptr, type, member) ({ \
+	struct list_head *head__ = (ptr); \
+	struct list_head *pos__ = READ_ONCE(head__->prev); \
+	pos__ != head__ ? list_entry(pos__, type, member) : NULL; \
+})
+
 /**
  * gsi_trans_move_complete() - Mark a GSI transaction completed
  * @trans:	Transaction to commit
diff --git a/drivers/net/ipa/gsi_trans.c b/drivers/net/ipa/gsi_trans.c
index 4eef1480c2005..b4a6f2b563566 100644
--- a/drivers/net/ipa/gsi_trans.c
+++ b/drivers/net/ipa/gsi_trans.c
@@ -309,23 +309,15 @@ void gsi_trans_move_polled(struct gsi_trans *trans)
 {
 	struct gsi_channel *channel = &trans->gsi->channel[trans->channel_id];
 	struct gsi_trans_info *trans_info = &channel->trans_info;
-	u16 trans_index;
 
 	spin_lock_bh(&trans_info->spinlock);
 
 	list_move_tail(&trans->links, &trans_info->polled);
 
-	trans = list_first_entry(&trans_info->polled,
-				 struct gsi_trans, links);
-
 	spin_unlock_bh(&trans_info->spinlock);
 
 	/* This completed transaction is now polled */
 	trans_info->completed_id++;
-
-	WARN_ON(trans_info->polled_id == trans_info->completed_id);
-	trans_index = trans_info->polled_id % channel->tre_count;
-	WARN_ON(trans != &trans_info->trans[trans_index]);
 }
 
 /* Reserve some number of TREs on a channel.  Returns true if successful */
@@ -413,11 +405,8 @@ struct gsi_trans *gsi_channel_trans_alloc(struct gsi *gsi, u32 channel_id,
 /* Free a previously-allocated transaction */
 void gsi_trans_free(struct gsi_trans *trans)
 {
-	struct gsi_channel *channel = &trans->gsi->channel[trans->channel_id];
 	refcount_t *refcount = &trans->refcount;
 	struct gsi_trans_info *trans_info;
-	struct gsi_trans *polled;
-	u16 trans_index;
 	bool last;
 
 	/* We must hold the lock to release the last reference */
@@ -433,9 +422,6 @@ void gsi_trans_free(struct gsi_trans *trans)
 	if (last)
 		list_del(&trans->links);
 
-	polled = list_first_entry_or_null(&trans_info->polled,
-					  struct gsi_trans, links);
-
 	spin_unlock_bh(&trans_info->spinlock);
 
 	if (!last)
@@ -456,14 +442,6 @@ void gsi_trans_free(struct gsi_trans *trans)
 	/* This transaction is now free */
 	trans_info->polled_id++;
 
-	if (polled) {
-		trans_index = trans_info->polled_id % channel->tre_count;
-		WARN_ON(polled != &trans_info->trans[trans_index]);
-	} else {
-		WARN_ON(trans_info->polled_id !=
-			trans_info->completed_id);
-	}
-
 	/* Releasing the reserved TREs implicitly frees the sgl[] and
 	 * (if present) info[] arrays, plus the transaction itself.
 	 */
-- 
2.34.1

