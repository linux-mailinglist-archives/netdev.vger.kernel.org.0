Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15013389036
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 16:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354034AbhESOPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 10:15:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241049AbhESOPa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 10:15:30 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B715C06138D;
        Wed, 19 May 2021 07:14:00 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id s5-20020a7bc0c50000b0290147d0c21c51so3422815wmh.4;
        Wed, 19 May 2021 07:14:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ynxDMKj1mZvdjVLVE7e+VlFds8wn53Y4eJJTD49qFXs=;
        b=d4Nmrz8vuHnINI7FqKfqaxeKr8lLU6huobBBLU5pcxCAYd/FusFVQnM/auRbVdKdjK
         GUj9rcPT/2uLbjIXGjtUDQcUKTrll1b/HRYh0ZWNypDa2bDjk5166C2Wg2V85BK2JWge
         F386IBsragShMQdfBRNxz60S8UZqrbE7P0tA8jViapoDvSo67V2/+Wm3r8keBQPT/SRJ
         V8d/qebuBvd8DF0VB+ldr8CvlY5ff49NgN/YfT9Jrt3esQfW0YbFVQiLIT3igOjZbwA7
         ce5RhWEwvkYsXzlsTJh2ogsKvGevILWLp/QIxZGBF5Aw+e9zuP5VCQlkaUNJG/qhG1wG
         gAfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ynxDMKj1mZvdjVLVE7e+VlFds8wn53Y4eJJTD49qFXs=;
        b=LU5UhPy809KKxpXvI5QCnhB4frmEFI4V9rCqaU3puea4GWUmBMddsk9gzKa2V0XvBH
         OoegrtQTBAlKkV+zDmLWW8pJyPiix97bnYZmRWnvhKUZRONhePcgb1JDXks9IYY16It/
         vgoNUiHWXz4hUuJGLpQz5z6rTVFFUWzG/escaGOI/gGap0Rr4ZqEqR4qP9fihagIrteZ
         oTHbLrXkk1NElrOiPlc/UZuE2j0fraGfF626bhSuEKJ9X+aQKz5CreLX//eYhNJsjHG0
         D4EtVQK6E6EDvLTssOa9sPyibPs3t4zZ7MI+0+KhC/ds3fKV15K1blrRSUwdsNsLVknZ
         QdoA==
X-Gm-Message-State: AOAM530S2j5TT9qOJ7o2rSNliXdo2qi7GLsHiNZOlvUvzhiiNmW7QlHI
        +reHNG2izPI2r1hHnhvwaaWdj9V58CkemdPR
X-Google-Smtp-Source: ABdhPJybim8WElMlrRnVIC+aKbppRHV5ltL1p3gtqqJJsWN9vAClwKWFPDMnXTv7DBD3Z1ImDoRaPg==
X-Received: by 2002:a05:600c:4b92:: with SMTP id e18mr11779556wmp.71.1621433638539;
        Wed, 19 May 2021 07:13:58 -0700 (PDT)
Received: from localhost.localdomain ([85.255.235.154])
        by smtp.gmail.com with ESMTPSA id z3sm6233569wrq.42.2021.05.19.07.13.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 07:13:58 -0700 (PDT)
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
Subject: [PATCH 07/23] io_uring: extract struct for CQ
Date:   Wed, 19 May 2021 15:13:18 +0100
Message-Id: <9203fb800f78165633f295e17bfcacf3c3409404.1621424513.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1621424513.git.asml.silence@gmail.com>
References: <cover.1621424513.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extract a structure describing an internal completion queue state and
called, struct io_cqring. We need it to support multi-CQ rings.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 47 +++++++++++++++++++++++++----------------------
 1 file changed, 25 insertions(+), 22 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 49a1b6b81d7d..4fecd9da689e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -335,6 +335,12 @@ struct io_submit_state {
 	unsigned int		ios_left;
 };
 
+struct io_cqring {
+	unsigned		cached_tail;
+	unsigned		entries;
+	struct io_rings		*rings;
+};
+
 struct io_ring_ctx {
 	struct {
 		struct percpu_ref	refs;
@@ -402,17 +408,14 @@ struct io_ring_ctx {
 	struct xarray		personalities;
 	u32			pers_next;
 
-	struct {
-		unsigned		cached_cq_tail;
-		unsigned		cq_entries;
-		atomic_t		cq_timeouts;
-		unsigned		cq_last_tm_flush;
-		unsigned		cq_extra;
-		unsigned long		cq_check_overflow;
-		struct wait_queue_head	cq_wait;
-		struct fasync_struct	*cq_fasync;
-		struct eventfd_ctx	*cq_ev_fd;
-	} ____cacheline_aligned_in_smp;
+	struct fasync_struct	*cq_fasync;
+	struct eventfd_ctx	*cq_ev_fd;
+	atomic_t		cq_timeouts;
+	unsigned		cq_last_tm_flush;
+	unsigned long		cq_check_overflow;
+	unsigned		cq_extra;
+	struct wait_queue_head	cq_wait;
+	struct io_cqring	cqs[1];
 
 	struct {
 		spinlock_t		completion_lock;
@@ -1207,7 +1210,7 @@ static bool req_need_defer(struct io_kiocb *req, u32 seq)
 	if (unlikely(req->flags & REQ_F_IO_DRAIN)) {
 		struct io_ring_ctx *ctx = req->ctx;
 
-		return seq + READ_ONCE(ctx->cq_extra) != ctx->cached_cq_tail;
+		return seq + READ_ONCE(ctx->cq_extra) != ctx->cqs[0].cached_tail;
 	}
 
 	return false;
@@ -1312,7 +1315,7 @@ static void io_flush_timeouts(struct io_ring_ctx *ctx)
 	if (list_empty(&ctx->timeout_list))
 		return;
 
-	seq = ctx->cached_cq_tail - atomic_read(&ctx->cq_timeouts);
+	seq = ctx->cqs[0].cached_tail - atomic_read(&ctx->cq_timeouts);
 
 	do {
 		u32 events_needed, events_got;
@@ -1346,7 +1349,7 @@ static void io_commit_cqring(struct io_ring_ctx *ctx)
 	io_flush_timeouts(ctx);
 
 	/* order cqe stores with ring update */
-	smp_store_release(&ctx->rings->cq.tail, ctx->cached_cq_tail);
+	smp_store_release(&ctx->rings->cq.tail, ctx->cqs[0].cached_tail);
 
 	if (unlikely(!list_empty(&ctx->defer_list)))
 		__io_queue_deferred(ctx);
@@ -1361,23 +1364,23 @@ static inline bool io_sqring_full(struct io_ring_ctx *ctx)
 
 static inline unsigned int __io_cqring_events(struct io_ring_ctx *ctx)
 {
-	return ctx->cached_cq_tail - READ_ONCE(ctx->rings->cq.head);
+	return ctx->cqs[0].cached_tail - READ_ONCE(ctx->rings->cq.head);
 }
 
 static inline struct io_uring_cqe *io_get_cqe(struct io_ring_ctx *ctx)
 {
 	struct io_rings *rings = ctx->rings;
-	unsigned tail, mask = ctx->cq_entries - 1;
+	unsigned tail, mask = ctx->cqs[0].entries - 1;
 
 	/*
 	 * writes to the cq entry need to come after reading head; the
 	 * control dependency is enough as we're using WRITE_ONCE to
 	 * fill the cq entry
 	 */
-	if (__io_cqring_events(ctx) == ctx->cq_entries)
+	if (__io_cqring_events(ctx) == ctx->cqs[0].entries)
 		return NULL;
 
-	tail = ctx->cached_cq_tail++;
+	tail = ctx->cqs[0].cached_tail++;
 	return &rings->cqes[tail & mask];
 }
 
@@ -1430,7 +1433,7 @@ static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 	unsigned long flags;
 	bool all_flushed, posted;
 
-	if (!force && __io_cqring_events(ctx) == ctx->cq_entries)
+	if (!force && __io_cqring_events(ctx) == ctx->cqs[0].entries)
 		return false;
 
 	posted = false;
@@ -5670,7 +5673,7 @@ static int io_timeout(struct io_kiocb *req, unsigned int issue_flags)
 		goto add;
 	}
 
-	tail = ctx->cached_cq_tail - atomic_read(&ctx->cq_timeouts);
+	tail = ctx->cqs[0].cached_tail - atomic_read(&ctx->cq_timeouts);
 	req->timeout.target_seq = tail + off;
 
 	/* Update the last seq here in case io_flush_timeouts() hasn't.
@@ -9331,7 +9334,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 		if (unlikely(ret))
 			goto out;
 
-		min_complete = min(min_complete, ctx->cq_entries);
+		min_complete = min(min_complete, ctx->cqs[0].entries);
 
 		/*
 		 * When SETUP_IOPOLL and SETUP_SQPOLL are both enabled, user
@@ -9481,7 +9484,7 @@ static int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 
 	/* make sure these are sane, as we already accounted them */
 	ctx->sq_entries = p->sq_entries;
-	ctx->cq_entries = p->cq_entries;
+	ctx->cqs[0].entries = p->cq_entries;
 
 	size = rings_size(p->sq_entries, p->cq_entries, &sq_array_offset);
 	if (size == SIZE_MAX)
-- 
2.31.1

