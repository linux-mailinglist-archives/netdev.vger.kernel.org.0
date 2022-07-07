Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA5756A1A8
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 13:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235578AbiGGLwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 07:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235494AbiGGLwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 07:52:07 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B454353D22;
        Thu,  7 Jul 2022 04:52:04 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id d16so19627093wrv.10;
        Thu, 07 Jul 2022 04:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bseFqCjtJuCCHP0G+Vx7dbSlO7wFxBUtK6JlLKCdTIA=;
        b=ZuF1yxoQAZWvMNg6/Bqiyaun6f4IJlBiPmFohxxOaMO72o9L54yj9bIndOcLFSn7p+
         1XOj8dfOJnNvIDNTz2yEMvln51F8K0GlfpZXqH0VaIy0IKSS7/PrObSc3jNwCq9z/vLF
         3ca245tOMWGW73tB/7EZ08oA7nsMlZFIW/cxYG4E6tWlTsoS+n3uHWkgPNoxlz5dxAkQ
         1wjfxdT3UazHGsI+kxJtS7llIF9QTlRonOyISVdfdV9RMNLUgDMmdbST8+AKNKY8rE4+
         VP6uIKrcpbPLbZS+Hi2ZgxoGPfnMlu89iMzEDJ0uTv4yNYrgsAWtIDgOxB6dXwnaRt5c
         ck5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bseFqCjtJuCCHP0G+Vx7dbSlO7wFxBUtK6JlLKCdTIA=;
        b=d4M1pNTR0KZ6trAYuUGPvBQWrIfTGLKdG/W9KX/Wwao/EhXP/AVzrWMwrw/DxcyoiO
         0d3cYggRsMQ3MvvA9ZshK7KPs2y/F1iFQkfRqsKGnzPOwkGrW8X3w0Z9bl2vmgJPo/lo
         oyxcuIiz/SF9wIReysW/Bdl1ZNuLda1Lg+0PdLuz/2WGeQffk+Kym0fMKgBa81w8ZDuL
         nRf8gW5Y1xZq0vUwC+giLu8ucD4WTyF43zHoO1d7ziLrWc01y+jNvPQINMv/f3TW3BSk
         7ehx67LCKOyyge2KCpwSx7fpXA+yxO8hvSWlNnNlLpUsGXJXgXgJ2Vviv0JLvFlQzDGc
         UW9w==
X-Gm-Message-State: AJIora9DOjUvJVPLxfAnfdLccVTFnE/xJYxRCs1fRoi1Uo83FYQlov0p
        6p9Px+wNzOFVu1V8syvTpjgRVgUjZrc+7EKWzn4=
X-Google-Smtp-Source: AGRyM1ul0scktUDMsOh6Er/U8WXq2fu1lln5pxLJVW4oesKe8Dip0gU4+L6Wb9irRzKYJDnaKuhT/Q==
X-Received: by 2002:a05:6000:911:b0:21d:2100:b97b with SMTP id bz17-20020a056000091100b0021d2100b97bmr42788178wrb.649.1657194723943;
        Thu, 07 Jul 2022 04:52:03 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id u2-20020a5d5142000000b0021b966abc19sm37982131wrt.19.2022.07.07.04.52.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 04:52:03 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v4 15/27] io_uring: cache struct io_notif
Date:   Thu,  7 Jul 2022 12:49:46 +0100
Message-Id: <b033c7240e294a543f8ddd20d39dd272ac771a55.1657194434.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1657194434.git.asml.silence@gmail.com>
References: <cover.1657194434.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kmalloc'ing struct io_notif is too expensive when done frequently, cache
them as many other resources in io_uring. Keep two list, the first one
is from where we're getting notifiers, it's protected by ->uring_lock.
The second is protected by ->completion_lock, to which we queue released
notifiers. Then we splice one list into another when needed.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h |  7 +++++
 io_uring/io_uring.c            |  3 ++
 io_uring/notif.c               | 57 +++++++++++++++++++++++++++++-----
 io_uring/notif.h               |  5 +++
 4 files changed, 65 insertions(+), 7 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 95334e678586..66ab009e7a6b 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -244,6 +244,9 @@ struct io_ring_ctx {
 		struct xarray		io_bl_xa;
 		struct list_head	io_buffers_cache;
 
+		/* struct io_notif cache, protected by uring_lock */
+		struct list_head	notif_list;
+
 		struct io_hash_table	cancel_table_locked;
 		struct list_head	cq_overflow_list;
 		struct list_head	apoll_cache;
@@ -255,6 +258,10 @@ struct io_ring_ctx {
 	struct io_wq_work_list	locked_free_list;
 	unsigned int		locked_free_nr;
 
+	/* struct io_notif cache protected by completion_lock */
+	struct list_head	notif_list_locked;
+	unsigned int		notif_locked_nr;
+
 	const struct cred	*sq_creds;	/* cred used for __io_sq_thread() */
 	struct io_sq_data	*sq_data;	/* if using sq thread polling */
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ad816afe2345..bdc5a2839d94 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -318,6 +318,8 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_WQ_LIST(&ctx->locked_free_list);
 	INIT_DELAYED_WORK(&ctx->fallback_work, io_fallback_req_func);
 	INIT_WQ_LIST(&ctx->submit_state.compl_reqs);
+	INIT_LIST_HEAD(&ctx->notif_list);
+	INIT_LIST_HEAD(&ctx->notif_list_locked);
 	return ctx;
 err:
 	kfree(ctx->dummy_ubuf);
@@ -2498,6 +2500,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	WARN_ON_ONCE(!list_empty(&ctx->ltimeout_list));
 	WARN_ON_ONCE(ctx->notif_slots || ctx->nr_notif_slots);
 
+	io_notif_cache_purge(ctx);
 	io_mem_free(ctx->rings);
 	io_mem_free(ctx->sq_sqes);
 
diff --git a/io_uring/notif.c b/io_uring/notif.c
index 6ee948af6a49..b257db2120b4 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -15,10 +15,12 @@ static void __io_notif_complete_tw(struct callback_head *cb)
 
 	io_cq_lock(ctx);
 	io_fill_cqe_aux(ctx, notif->tag, 0, notif->seq, true);
+
+	list_add(&notif->cache_node, &ctx->notif_list_locked);
+	ctx->notif_locked_nr++;
 	io_cq_unlock_post(ctx);
 
 	percpu_ref_put(&ctx->refs);
-	kfree(notif);
 }
 
 static inline void io_notif_complete(struct io_notif *notif)
@@ -45,21 +47,62 @@ static void io_uring_tx_zerocopy_callback(struct sk_buff *skb,
 	queue_work(system_unbound_wq, &notif->commit_work);
 }
 
+static void io_notif_splice_cached(struct io_ring_ctx *ctx)
+	__must_hold(&ctx->uring_lock)
+{
+	spin_lock(&ctx->completion_lock);
+	list_splice_init(&ctx->notif_list_locked, &ctx->notif_list);
+	ctx->notif_locked_nr = 0;
+	spin_unlock(&ctx->completion_lock);
+}
+
+void io_notif_cache_purge(struct io_ring_ctx *ctx)
+	__must_hold(&ctx->uring_lock)
+{
+	io_notif_splice_cached(ctx);
+
+	while (!list_empty(&ctx->notif_list)) {
+		struct io_notif *notif = list_first_entry(&ctx->notif_list,
+						struct io_notif, cache_node);
+
+		list_del(&notif->cache_node);
+		kfree(notif);
+	}
+}
+
+static inline bool io_notif_has_cached(struct io_ring_ctx *ctx)
+	__must_hold(&ctx->uring_lock)
+{
+	if (likely(!list_empty(&ctx->notif_list)))
+		return true;
+	if (data_race(READ_ONCE(ctx->notif_locked_nr) <= IO_NOTIF_SPLICE_BATCH))
+		return false;
+	io_notif_splice_cached(ctx);
+	return !list_empty(&ctx->notif_list);
+}
+
 struct io_notif *io_alloc_notif(struct io_ring_ctx *ctx,
 				struct io_notif_slot *slot)
 	__must_hold(&ctx->uring_lock)
 {
 	struct io_notif *notif;
 
-	notif = kzalloc(sizeof(*notif), GFP_ATOMIC | __GFP_ACCOUNT);
-	if (!notif)
-		return NULL;
+	if (likely(io_notif_has_cached(ctx))) {
+		notif = list_first_entry(&ctx->notif_list,
+					 struct io_notif, cache_node);
+		list_del(&notif->cache_node);
+	} else {
+		notif = kzalloc(sizeof(*notif), GFP_ATOMIC | __GFP_ACCOUNT);
+		if (!notif)
+			return NULL;
+		/* pre-initialise some fields */
+		notif->ctx = ctx;
+		notif->uarg.flags = SKBFL_ZEROCOPY_FRAG | SKBFL_DONT_ORPHAN;
+		notif->uarg.callback = io_uring_tx_zerocopy_callback;
+	}
 
 	notif->seq = slot->seq++;
 	notif->tag = slot->tag;
-	notif->ctx = ctx;
-	notif->uarg.flags = SKBFL_ZEROCOPY_FRAG | SKBFL_DONT_ORPHAN;
-	notif->uarg.callback = io_uring_tx_zerocopy_callback;
 	/* master ref owned by io_notif_slot, will be dropped on flush */
 	refcount_set(&notif->uarg.refcnt, 1);
 	percpu_ref_get(&ctx->refs);
diff --git a/io_uring/notif.h b/io_uring/notif.h
index 3d7a1d242e17..b23c9c0515bb 100644
--- a/io_uring/notif.h
+++ b/io_uring/notif.h
@@ -5,6 +5,8 @@
 #include <net/sock.h>
 #include <linux/nospec.h>
 
+#define IO_NOTIF_SPLICE_BATCH	32
+
 struct io_notif {
 	struct ubuf_info	uarg;
 	struct io_ring_ctx	*ctx;
@@ -13,6 +15,8 @@ struct io_notif {
 	u64			tag;
 	/* see struct io_notif_slot::seq */
 	u32			seq;
+	/* hook into ctx->notif_list and ctx->notif_list_locked */
+	struct list_head	cache_node;
 
 	union {
 		struct callback_head	task_work;
@@ -41,6 +45,7 @@ struct io_notif_slot {
 };
 
 int io_notif_unregister(struct io_ring_ctx *ctx);
+void io_notif_cache_purge(struct io_ring_ctx *ctx);
 
 struct io_notif *io_alloc_notif(struct io_ring_ctx *ctx,
 				struct io_notif_slot *slot);
-- 
2.36.1

