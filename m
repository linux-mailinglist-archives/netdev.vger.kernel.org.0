Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 656B65671ED
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 17:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232576AbiGEPCz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 11:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232562AbiGEPC1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 11:02:27 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02C9A1706F;
        Tue,  5 Jul 2022 08:02:05 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id a5so3274630wrx.12;
        Tue, 05 Jul 2022 08:02:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JlFuNzwa17IK4sUefiCWM0htTtZXIp8c8sCuHSjyyPo=;
        b=nJkXXMS5ZaSo0vfpAlUv17iJ/KfZJX/ijq56/Cx2W/5FVbn34fTomC9YX3h/K4Uenm
         +DqFO4+iFB+U53XLttzvIuLZRLXUT9az0kuY+T1lW51xVdjdZp+PJEluXVoryUaQj8ps
         vK1RPW6cNFzAs6CZVfgGOBE5rJq1FwfafZ8ekS4Z1rKne9kKYm0gHPGi2xkGOdMKwtuN
         OHVUTBs3sigNC+uN6eSGspe6eq6GAisW2I0THpJyIsmUi5rs4BOuf4ez9WNnsJxZvRAj
         EUWNCGEQ34jYmmuXIJ4ZkkGzBOqoa31wNjqJrKDo5wgWvDHTqNPuPefdRG0sYlmtcjx7
         VIbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JlFuNzwa17IK4sUefiCWM0htTtZXIp8c8sCuHSjyyPo=;
        b=ORYOmWLZZTz2p0GcnGRxBJAWnhhXbC8dhd9pqfYyO4DRwJO/ixNAuC0r9fBSkpdIrn
         UfV5zaqlgf83+SAVniWLt4A0xYl1MKDAshUuymHiKUC96fgpr3xpk8wnaFZEK+E/JKiX
         VcPu5duoSolegKLSHjmrkhO0DyKfCtLrb9NOF5tMvLKT8Vn7nGLmuJ4GCjluqBrx/F8A
         2z0HaapPpwSHB9d/7Y3+Jru5W8JrdnRmilZMdGUUOJsB7aazMvKm3nfNBPEl7uzIWwJW
         7tZyVKYRajzKQSp9MV2UFeT3ZJPsy/tgtpCujQ4wRYeSxbo0xV8gAgA1qGr1FAIfbNCA
         3liw==
X-Gm-Message-State: AJIora+RlEBlo4E1v8EmHkdSiRsFjnC35ud7JgXcTF15OFxDMiTSAmrY
        BDqc0YfCGpFtUsgQmT0mJi1fhLeGiNG+Iw==
X-Google-Smtp-Source: AGRyM1sv8UAk+lPdmiZ8A1yUvTEPMMUjXMgJxEMoENk/Q1F3I0i64C75EjxdbD3X6K5v9BwxwxBuww==
X-Received: by 2002:a5d:4346:0:b0:21d:5dfe:b29b with SMTP id u6-20020a5d4346000000b0021d5dfeb29bmr16806951wrr.672.1657033323740;
        Tue, 05 Jul 2022 08:02:03 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id k27-20020adfd23b000000b0021d728d687asm2518200wrh.36.2022.07.05.08.02.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 08:02:03 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v3 13/25] io_uring: export task put
Date:   Tue,  5 Jul 2022 16:01:13 +0100
Message-Id: <6a15bddc42ec7cc83f34e2b00be97ceea413d786.1656318994.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1656318994.git.asml.silence@gmail.com>
References: <cover.1656318994.git.asml.silence@gmail.com>
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

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h | 25 +++++++++++++++++++++++++
 io_uring/io_uring.c            | 11 +----------
 io_uring/io_uring.h            | 10 ++++++++++
 io_uring/tctx.h                | 26 --------------------------
 4 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index a64eb2558e04..26a1504ad24c 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -4,6 +4,7 @@
 #include <linux/blkdev.h>
 #include <linux/task_work.h>
 #include <linux/bitmap.h>
+#include <linux/llist.h>
 #include <uapi/linux/io_uring.h>
 
 struct io_wq_work_node {
@@ -46,6 +47,30 @@ struct io_hash_table {
 	unsigned		hash_bits;
 };
 
+/*
+ * Arbitrary limit, can be raised if need be
+ */
+#define IO_RINGFD_REG_MAX 16
+
+struct io_uring_task {
+	/* submission side */
+	int				cached_refs;
+	const struct io_ring_ctx 	*last;
+	struct io_wq			*io_wq;
+	struct file			*registered_rings[IO_RINGFD_REG_MAX];
+
+	struct xarray			xa;
+	struct wait_queue_head		wait;
+	atomic_t			in_idle;
+	atomic_t			inflight_tracked;
+	struct percpu_counter		inflight;
+
+	struct { /* task_work */
+		struct llist_head	task_list;
+		struct callback_head	task_work;
+	} ____cacheline_aligned_in_smp;
+};
+
 struct io_uring {
 	u32 head ____cacheline_aligned_in_smp;
 	u32 tail ____cacheline_aligned_in_smp;
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index eff4adca1813..5fbbdcad14fa 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -603,7 +603,7 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx)
 	return ret;
 }
 
-static void __io_put_task(struct task_struct *task, int nr)
+void __io_put_task(struct task_struct *task, int nr)
 {
 	struct io_uring_task *tctx = task->io_uring;
 
@@ -613,15 +613,6 @@ static void __io_put_task(struct task_struct *task, int nr)
 	put_task_struct_many(task, nr);
 }
 
-/* must to be called somewhat shortly after putting a request */
-static inline void io_put_task(struct task_struct *task, int nr)
-{
-	if (likely(task == current))
-		task->io_uring->cached_refs += nr;
-	else
-		__io_put_task(task, nr);
-}
-
 static void io_task_refs_refill(struct io_uring_task *tctx)
 {
 	unsigned int refill = -tctx->cached_refs + IO_TCTX_REFS_CACHE_NR;
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 7b7b63503c02..e978654d1b14 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -59,6 +59,7 @@ void io_wq_submit_work(struct io_wq_work *work);
 
 void io_free_req(struct io_kiocb *req);
 void io_queue_next(struct io_kiocb *req);
+void __io_put_task(struct task_struct *task, int nr);
 
 bool io_match_task_safe(struct io_kiocb *head, struct task_struct *task,
 			bool cancel_all);
@@ -244,4 +245,13 @@ static inline void io_commit_cqring_flush(struct io_ring_ctx *ctx)
 		__io_commit_cqring_flush(ctx);
 }
 
+/* must to be called somewhat shortly after putting a request */
+static inline void io_put_task(struct task_struct *task, int nr)
+{
+	if (likely(task == current))
+		task->io_uring->cached_refs += nr;
+	else
+		__io_put_task(task, nr);
+}
+
 #endif
diff --git a/io_uring/tctx.h b/io_uring/tctx.h
index 8a33ff6e5d91..25974beed4d6 100644
--- a/io_uring/tctx.h
+++ b/io_uring/tctx.h
@@ -1,31 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
 
-#include <linux/llist.h>
-
-/*
- * Arbitrary limit, can be raised if need be
- */
-#define IO_RINGFD_REG_MAX 16
-
-struct io_uring_task {
-	/* submission side */
-	int				cached_refs;
-	const struct io_ring_ctx 	*last;
-	struct io_wq			*io_wq;
-	struct file			*registered_rings[IO_RINGFD_REG_MAX];
-
-	struct xarray			xa;
-	struct wait_queue_head		wait;
-	atomic_t			in_idle;
-	atomic_t			inflight_tracked;
-	struct percpu_counter		inflight;
-
-	struct { /* task_work */
-		struct llist_head	task_list;
-		struct callback_head	task_work;
-	} ____cacheline_aligned_in_smp;
-};
-
 struct io_tctx_node {
 	struct list_head	ctx_node;
 	struct task_struct	*task;
-- 
2.36.1

