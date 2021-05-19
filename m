Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FCD8389041
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 16:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347273AbhESOP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 10:15:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353959AbhESOPb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 10:15:31 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23A89C06138E;
        Wed, 19 May 2021 07:14:01 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id q5so14199579wrs.4;
        Wed, 19 May 2021 07:14:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tVo/T1yE+q8hSn/v+s7FHlx6RSl5fWFsncg9ZgUqYd4=;
        b=ja2ZjcDrt7cmTWhUsHVsmJb72TBh6EX8jRUdylIlqXda/OcyRsfrXJPfe8JkCQpDi0
         CoLiA9Ax3AH1wfdUuQOw+q+oLC1Bq98vhjQ9A9RbBY2KBdq7GrWznwgCfsl0Nw9vgLdd
         YENnxbNIFRXGpVAlXjISpThNw5lFV2sGV1XFFUYqKU+qdiEiRI3+r+t3zXDQ4nGSsMPu
         GVc8kAUoHeC1ovt3RwdJB8jpC1gxWNNNttR0Pjn+214lJe0E1e5ZO9MkVX9KX87ufq36
         pxkaxMTAoHogIkHUOIMmE+IfDhQDMzRRMwoNr8FD/2e2EpwotYFp95pWyDdv6wloZ/sJ
         1/dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tVo/T1yE+q8hSn/v+s7FHlx6RSl5fWFsncg9ZgUqYd4=;
        b=NT/1qrIiMoVydGJf6bBwxMQG7mBlQEbCIZWOPW7tlb0MsBTBLwrNZwDOKk6ev+IuEi
         5X5CMX0CNqT0pgAubdP49DoB24HpHCjh7UJRfaCERPgsu//P9/DPPVzTvO0HVw4YIp9d
         O73mqzQWkthMC34QhUssKdQTL1X9cMgq2vc1CDzrQpNV4jItwYxPQtlQxdRUwGRYUGCA
         DoIEc7FOIaFlcw/mLscKREdS3RbL9/5m0F/WNNrtqMHqR4Z/Pfn7pQ9Tpu7yxBbTf7OK
         Ba4dY1vNmiMSKLwPWb5QHqIB6GkEqefMS2vqJkmzE3eJipdoK8Sfx+qsj4dlpJcu2u9S
         ahXA==
X-Gm-Message-State: AOAM533WXd+maAAZ2qfVFCbCxJOo0pOSokxSznG9G8ge7o2bCBsETa5L
        hvrwb82l7Ot7mcvEq3ie79T0wUON2A9Ftfqm
X-Google-Smtp-Source: ABdhPJydHbarWJuFz/gt1sqT7MwFSD8jJ0FxcozEW3sGEXSaJNuUT7/R6ohY4VrRyz5nv88754oqLQ==
X-Received: by 2002:adf:a519:: with SMTP id i25mr14971775wrb.312.1621433639769;
        Wed, 19 May 2021 07:13:59 -0700 (PDT)
Received: from localhost.localdomain ([85.255.235.154])
        by smtp.gmail.com with ESMTPSA id z3sm6233569wrq.42.2021.05.19.07.13.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 07:13:59 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Horst Schirmeier <horst.schirmeier@tu-dortmund.de>,
        "Franz-B . Tuneke" <franz-bernhard.tuneke@tu-dortmund.de>,
        Christian Dietrich <stettberger@dokucode.de>
Subject: [PATCH 08/23] io_uring: internally pass CQ indexes
Date:   Wed, 19 May 2021 15:13:19 +0100
Message-Id: <8871c605590f1b1371d66fc37798bed356777ef8.1621424513.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1621424513.git.asml.silence@gmail.com>
References: <cover.1621424513.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow to pass CQ index from SQE to the end CQE generators, but support
only one CQ for now.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c                 | 113 ++++++++++++++++++++++------------
 include/uapi/linux/io_uring.h |   1 +
 2 files changed, 75 insertions(+), 39 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4fecd9da689e..356a5dc90f46 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -90,6 +90,8 @@
 #define IORING_MAX_ENTRIES	32768
 #define IORING_MAX_CQ_ENTRIES	(2 * IORING_MAX_ENTRIES)
 
+#define IO_DEFAULT_CQ		0
+
 /*
  * Shift of 9 is 512 entries, or exactly one page on 64-bit archs
  */
@@ -416,6 +418,7 @@ struct io_ring_ctx {
 	unsigned		cq_extra;
 	struct wait_queue_head	cq_wait;
 	struct io_cqring	cqs[1];
+	unsigned int		cq_nr;
 
 	struct {
 		spinlock_t		completion_lock;
@@ -832,6 +835,7 @@ struct io_kiocb {
 
 	struct io_kiocb			*link;
 	struct percpu_ref		*fixed_rsrc_refs;
+	u16				cq_idx;
 
 	/* used with ctx->iopoll_list with reads/writes */
 	struct list_head		inflight_entry;
@@ -1034,7 +1038,8 @@ static void io_uring_cancel_sqpoll(struct io_sq_data *sqd);
 static struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx);
 
 static bool io_cqring_fill_event(struct io_ring_ctx *ctx, u64 user_data,
-				 long res, unsigned int cflags);
+				 long res, unsigned int cflags,
+				 unsigned int cq_idx);
 static void io_put_req(struct io_kiocb *req);
 static void io_put_req_deferred(struct io_kiocb *req, int nr);
 static void io_dismantle_req(struct io_kiocb *req);
@@ -1207,13 +1212,15 @@ static void io_account_cq_overflow(struct io_ring_ctx *ctx)
 
 static bool req_need_defer(struct io_kiocb *req, u32 seq)
 {
-	if (unlikely(req->flags & REQ_F_IO_DRAIN)) {
-		struct io_ring_ctx *ctx = req->ctx;
-
-		return seq + READ_ONCE(ctx->cq_extra) != ctx->cqs[0].cached_tail;
-	}
+	struct io_ring_ctx *ctx = req->ctx;
+	u32 cnt = 0;
+	int i;
 
-	return false;
+	if (!(req->flags & REQ_F_IO_DRAIN))
+		return false;
+	for (i = 0; i < ctx->cq_nr; i++)
+		cnt += ctx->cqs[i].cached_tail;
+	return seq + READ_ONCE(ctx->cq_extra) != cnt;
 }
 
 static void io_req_track_inflight(struct io_kiocb *req)
@@ -1289,7 +1296,8 @@ static void io_kill_timeout(struct io_kiocb *req, int status)
 		atomic_set(&req->ctx->cq_timeouts,
 			atomic_read(&req->ctx->cq_timeouts) + 1);
 		list_del_init(&req->timeout.list);
-		io_cqring_fill_event(req->ctx, req->user_data, status, 0);
+		io_cqring_fill_event(req->ctx, req->user_data, status, 0,
+				     req->cq_idx);
 		io_put_req_deferred(req, 1);
 	}
 }
@@ -1346,10 +1354,13 @@ static void io_flush_timeouts(struct io_ring_ctx *ctx)
 
 static void io_commit_cqring(struct io_ring_ctx *ctx)
 {
+	int i;
+
 	io_flush_timeouts(ctx);
 
 	/* order cqe stores with ring update */
-	smp_store_release(&ctx->rings->cq.tail, ctx->cqs[0].cached_tail);
+	for (i = 0; i < ctx->cq_nr; i++)
+		smp_store_release(&ctx->cqs[i].rings->cq.tail, ctx->cqs[i].cached_tail);
 
 	if (unlikely(!list_empty(&ctx->defer_list)))
 		__io_queue_deferred(ctx);
@@ -1362,25 +1373,27 @@ static inline bool io_sqring_full(struct io_ring_ctx *ctx)
 	return READ_ONCE(r->sq.tail) - ctx->cached_sq_head == ctx->sq_entries;
 }
 
-static inline unsigned int __io_cqring_events(struct io_ring_ctx *ctx)
+static inline unsigned int __io_cqring_events(struct io_cqring *cq)
 {
-	return ctx->cqs[0].cached_tail - READ_ONCE(ctx->rings->cq.head);
+	return cq->cached_tail - READ_ONCE(cq->rings->cq.head);
 }
 
-static inline struct io_uring_cqe *io_get_cqe(struct io_ring_ctx *ctx)
+static inline struct io_uring_cqe *io_get_cqe(struct io_ring_ctx *ctx,
+					      unsigned int idx)
 {
-	struct io_rings *rings = ctx->rings;
-	unsigned tail, mask = ctx->cqs[0].entries - 1;
+	struct io_cqring *cq = &ctx->cqs[idx];
+	struct io_rings *rings = cq->rings;
+	unsigned tail, mask = cq->entries - 1;
 
 	/*
 	 * writes to the cq entry need to come after reading head; the
 	 * control dependency is enough as we're using WRITE_ONCE to
 	 * fill the cq entry
 	 */
-	if (__io_cqring_events(ctx) == ctx->cqs[0].entries)
+	if (__io_cqring_events(cq) == cq->entries)
 		return NULL;
 
-	tail = ctx->cqs[0].cached_tail++;
+	tail = cq->cached_tail++;
 	return &rings->cqes[tail & mask];
 }
 
@@ -1432,16 +1445,18 @@ static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 {
 	unsigned long flags;
 	bool all_flushed, posted;
+	struct io_cqring *cq = &ctx->cqs[IO_DEFAULT_CQ];
 
-	if (!force && __io_cqring_events(ctx) == ctx->cqs[0].entries)
+	if (!force && __io_cqring_events(cq) == cq->entries)
 		return false;
 
 	posted = false;
 	spin_lock_irqsave(&ctx->completion_lock, flags);
 	while (!list_empty(&ctx->cq_overflow_list)) {
-		struct io_uring_cqe *cqe = io_get_cqe(ctx);
+		struct io_uring_cqe *cqe = io_get_cqe(ctx, IO_DEFAULT_CQ);
 		struct io_overflow_cqe *ocqe;
 
+
 		if (!cqe && !force)
 			break;
 		ocqe = list_first_entry(&ctx->cq_overflow_list,
@@ -1523,12 +1538,17 @@ static inline void req_ref_get(struct io_kiocb *req)
 }
 
 static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
-				     long res, unsigned int cflags)
+				     long res, unsigned int cflags,
+				     unsigned int cq_idx)
 {
 	struct io_overflow_cqe *ocqe;
 
+	if (cq_idx != IO_DEFAULT_CQ)
+		goto overflow;
+
 	ocqe = kmalloc(sizeof(*ocqe), GFP_ATOMIC | __GFP_ACCOUNT);
 	if (!ocqe) {
+overflow:
 		/*
 		 * If we're in ring overflow flush mode, or in task cancel mode,
 		 * or cannot allocate an overflow entry, then we need to drop it
@@ -1550,7 +1570,8 @@ static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
 }
 
 static inline bool __io_cqring_fill_event(struct io_ring_ctx *ctx, u64 user_data,
-					  long res, unsigned int cflags)
+					  long res, unsigned int cflags,
+					  unsigned int cq_idx)
 {
 	struct io_uring_cqe *cqe;
 
@@ -1561,21 +1582,22 @@ static inline bool __io_cqring_fill_event(struct io_ring_ctx *ctx, u64 user_data
 	 * submission (by quite a lot). Increment the overflow count in
 	 * the ring.
 	 */
-	cqe = io_get_cqe(ctx);
+	cqe = io_get_cqe(ctx, cq_idx);
 	if (likely(cqe)) {
 		WRITE_ONCE(cqe->user_data, user_data);
 		WRITE_ONCE(cqe->res, res);
 		WRITE_ONCE(cqe->flags, cflags);
 		return true;
 	}
-	return io_cqring_event_overflow(ctx, user_data, res, cflags);
+	return io_cqring_event_overflow(ctx, user_data, res, cflags, cq_idx);
 }
 
 /* not as hot to bloat with inlining */
 static noinline bool io_cqring_fill_event(struct io_ring_ctx *ctx, u64 user_data,
-					  long res, unsigned int cflags)
+					  long res, unsigned int cflags,
+					  unsigned int cq_idx)
 {
-	return __io_cqring_fill_event(ctx, user_data, res, cflags);
+	return __io_cqring_fill_event(ctx, user_data, res, cflags, cq_idx);
 }
 
 static void io_req_complete_post(struct io_kiocb *req, long res,
@@ -1585,7 +1607,7 @@ static void io_req_complete_post(struct io_kiocb *req, long res,
 	unsigned long flags;
 
 	spin_lock_irqsave(&ctx->completion_lock, flags);
-	__io_cqring_fill_event(ctx, req->user_data, res, cflags);
+	__io_cqring_fill_event(ctx, req->user_data, res, cflags, req->cq_idx);
 	/*
 	 * If we're the last reference to this request, add to our locked
 	 * free_list cache.
@@ -1797,7 +1819,7 @@ static bool io_kill_linked_timeout(struct io_kiocb *req)
 		link->timeout.head = NULL;
 		if (hrtimer_try_to_cancel(&io->timer) != -1) {
 			io_cqring_fill_event(link->ctx, link->user_data,
-					     -ECANCELED, 0);
+					     -ECANCELED, 0, link->cq_idx);
 			io_put_req_deferred(link, 1);
 			return true;
 		}
@@ -1816,7 +1838,8 @@ static void io_fail_links(struct io_kiocb *req)
 		link->link = NULL;
 
 		trace_io_uring_fail_link(req, link);
-		io_cqring_fill_event(link->ctx, link->user_data, -ECANCELED, 0);
+		io_cqring_fill_event(link->ctx, link->user_data, -ECANCELED, 0,
+				     link->cq_idx);
 		io_put_req_deferred(link, 2);
 		link = nxt;
 	}
@@ -2138,7 +2161,7 @@ static void io_submit_flush_completions(struct io_comp_state *cs,
 	for (i = 0; i < nr; i++) {
 		req = cs->reqs[i];
 		__io_cqring_fill_event(ctx, req->user_data, req->result,
-					req->compl.cflags);
+					req->compl.cflags, req->cq_idx);
 	}
 	io_commit_cqring(ctx);
 	spin_unlock_irq(&ctx->completion_lock);
@@ -2201,7 +2224,7 @@ static unsigned io_cqring_events(struct io_ring_ctx *ctx)
 {
 	/* See comment at the top of this file */
 	smp_rmb();
-	return __io_cqring_events(ctx);
+	return __io_cqring_events(&ctx->cqs[IO_DEFAULT_CQ]);
 }
 
 static inline unsigned int io_sqring_entries(struct io_ring_ctx *ctx)
@@ -2278,7 +2301,8 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 		if (req->flags & REQ_F_BUFFER_SELECTED)
 			cflags = io_put_rw_kbuf(req);
 
-		__io_cqring_fill_event(ctx, req->user_data, req->result, cflags);
+		__io_cqring_fill_event(ctx, req->user_data, req->result, cflags,
+					req->cq_idx);
 		(*nr_events)++;
 
 		if (req_ref_put_and_test(req))
@@ -4911,7 +4935,7 @@ static bool io_poll_complete(struct io_kiocb *req, __poll_t mask)
 	}
 	if (req->poll.events & EPOLLONESHOT)
 		flags = 0;
-	if (!io_cqring_fill_event(ctx, req->user_data, error, flags)) {
+	if (!io_cqring_fill_event(ctx, req->user_data, error, flags, req->cq_idx)) {
 		io_poll_remove_waitqs(req);
 		req->poll.done = true;
 		flags = 0;
@@ -5242,7 +5266,8 @@ static bool io_poll_remove_one(struct io_kiocb *req)
 
 	do_complete = io_poll_remove_waitqs(req);
 	if (do_complete) {
-		io_cqring_fill_event(req->ctx, req->user_data, -ECANCELED, 0);
+		io_cqring_fill_event(req->ctx, req->user_data, -ECANCELED, 0,
+				     req->cq_idx);
 		io_commit_cqring(req->ctx);
 		req_set_fail_links(req);
 		io_put_req_deferred(req, 1);
@@ -5494,7 +5519,7 @@ static enum hrtimer_restart io_timeout_fn(struct hrtimer *timer)
 	atomic_set(&req->ctx->cq_timeouts,
 		atomic_read(&req->ctx->cq_timeouts) + 1);
 
-	io_cqring_fill_event(ctx, req->user_data, -ETIME, 0);
+	io_cqring_fill_event(ctx, req->user_data, -ETIME, 0, req->cq_idx);
 	io_commit_cqring(ctx);
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
 
@@ -5536,7 +5561,7 @@ static int io_timeout_cancel(struct io_ring_ctx *ctx, __u64 user_data)
 		return PTR_ERR(req);
 
 	req_set_fail_links(req);
-	io_cqring_fill_event(ctx, req->user_data, -ECANCELED, 0);
+	io_cqring_fill_event(ctx, req->user_data, -ECANCELED, 0, req->cq_idx);
 	io_put_req_deferred(req, 1);
 	return 0;
 }
@@ -5609,7 +5634,7 @@ static int io_timeout_remove(struct io_kiocb *req, unsigned int issue_flags)
 		ret = io_timeout_update(ctx, tr->addr, &tr->ts,
 					io_translate_timeout_mode(tr->flags));
 
-	io_cqring_fill_event(ctx, req->user_data, ret, 0);
+	io_cqring_fill_event(ctx, req->user_data, ret, 0, req->cq_idx);
 	io_commit_cqring(ctx);
 	spin_unlock_irq(&ctx->completion_lock);
 	io_cqring_ev_posted(ctx);
@@ -5761,7 +5786,7 @@ static void io_async_find_and_cancel(struct io_ring_ctx *ctx,
 done:
 	if (!ret)
 		ret = success_ret;
-	io_cqring_fill_event(ctx, req->user_data, ret, 0);
+	io_cqring_fill_event(ctx, req->user_data, ret, 0, req->cq_idx);
 	io_commit_cqring(ctx);
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
 	io_cqring_ev_posted(ctx);
@@ -5818,7 +5843,7 @@ static int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
 
 	spin_lock_irq(&ctx->completion_lock);
 done:
-	io_cqring_fill_event(ctx, req->user_data, ret, 0);
+	io_cqring_fill_event(ctx, req->user_data, ret, 0, req->cq_idx);
 	io_commit_cqring(ctx);
 	spin_unlock_irq(&ctx->completion_lock);
 	io_cqring_ev_posted(ctx);
@@ -6516,6 +6541,11 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	req->result = 0;
 	req->work.creds = NULL;
 
+	req->cq_idx = READ_ONCE(sqe->cq_idx);
+	if (unlikely(req->cq_idx >= ctx->cq_nr)) {
+		req->cq_idx = IO_DEFAULT_CQ;
+		return -EINVAL;
+	}
 	/* enforce forwards compatibility on users */
 	if (unlikely(sqe_flags & ~SQE_VALID_FLAGS))
 		return -EINVAL;
@@ -7548,7 +7578,7 @@ static void __io_rsrc_put_work(struct io_rsrc_node *ref_node)
 
 			io_ring_submit_lock(ctx, lock_ring);
 			spin_lock_irqsave(&ctx->completion_lock, flags);
-			io_cqring_fill_event(ctx, prsrc->tag, 0, 0);
+			io_cqring_fill_event(ctx, prsrc->tag, 0, 0, IO_DEFAULT_CQ);
 			ctx->cq_extra++;
 			io_commit_cqring(ctx);
 			spin_unlock_irqrestore(&ctx->completion_lock, flags);
@@ -9484,7 +9514,6 @@ static int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 
 	/* make sure these are sane, as we already accounted them */
 	ctx->sq_entries = p->sq_entries;
-	ctx->cqs[0].entries = p->cq_entries;
 
 	size = rings_size(p->sq_entries, p->cq_entries, &sq_array_offset);
 	if (size == SIZE_MAX)
@@ -9501,6 +9530,11 @@ static int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 	rings->sq_ring_entries = p->sq_entries;
 	rings->cq_ring_entries = p->cq_entries;
 
+	ctx->cqs[0].cached_tail = 0;
+	ctx->cqs[0].rings = rings;
+	ctx->cqs[0].entries = p->cq_entries;
+	ctx->cq_nr = 1;
+
 	size = array_size(sizeof(struct io_uring_sqe), p->sq_entries);
 	if (size == SIZE_MAX) {
 		io_mem_free(ctx->rings);
@@ -10164,6 +10198,7 @@ static int __init io_uring_init(void)
 	BUILD_BUG_SQE_ELEM(40, __u16,  buf_index);
 	BUILD_BUG_SQE_ELEM(42, __u16,  personality);
 	BUILD_BUG_SQE_ELEM(44, __s32,  splice_fd_in);
+	BUILD_BUG_SQE_ELEM(48, __u16,  cq_idx);
 
 	BUILD_BUG_ON(sizeof(struct io_uring_files_update) !=
 		     sizeof(struct io_uring_rsrc_update));
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index e1ae46683301..c2dfb179360a 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -58,6 +58,7 @@ struct io_uring_sqe {
 			/* personality to use, if used */
 			__u16	personality;
 			__s32	splice_fd_in;
+			__u16	cq_idx;
 		};
 		__u64	__pad2[3];
 	};
-- 
2.31.1

