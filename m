Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC7F5671F3
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 17:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232677AbiGEPEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 11:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232322AbiGEPCv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 11:02:51 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A9AF18370;
        Tue,  5 Jul 2022 08:02:16 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id d16so11646027wrv.10;
        Tue, 05 Jul 2022 08:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3GBPmgCGqcb6RDnRFlWXFby0D6ygdiWLfcnYQGNqe1E=;
        b=kfI259WQOofrODpNTznY1cByP6vz8zo/Sgx0MHTrgRdHcapBKFmwedqAfkfemhvE80
         tKmj48GasWHLtxnIM0NZt30Aesn98tLdCCingJh5CXa4Rc/YvPyABpAHdo2K2rqQicCn
         bT+qP5su7Nadflia3CIL5puKBt1xixmtlIFlBBKgaLcSZuvIRg/hDlI1uVO6BZWJazfb
         oX/CRfARWFQrCgLgrzDDLE83nHg+OSAX29EAaoVNMyh3nIFJpzQoig6oTl/CXx1XuUiJ
         lf5/qW2cmeXTrD33wH1pZzWIyzIOzoGgR5uVLoqFgLs1hYuLUTgExLoh17wbOGSsAQkG
         mjuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3GBPmgCGqcb6RDnRFlWXFby0D6ygdiWLfcnYQGNqe1E=;
        b=FZ2NVzkdV5r5SW/Lfc0r4Z3kKw2XNayHNHWXuDEc29k0C8T84/WklrdguM9BvuPlNT
         jVoefzuVrxakkt24JSZqsFfT0GLME2T3GJx60y2b5xG36AsKGQCVRl65li6jmpEeIMxp
         Xv8gc3gPAqJD7PMo3kvDxCb3za5mJkn7chJOrWoYkwClFaTST4lVFNuSLL4v/K1AiIuZ
         DdpnWjhVKzIasBuvIELfd7oTbvBAqDOQg+YJePVBp7fMCpW82bdMuAOfnccKfQ7MoRbc
         ufbtO7OhcyZ5+qQIlEBMLnSyGuC/x0cEfQBSlMdsmIoAPPDVzjU7dLyS+a26xfusMpuP
         roiQ==
X-Gm-Message-State: AJIora9WVJzU3WE7n5t2oI5iHpm/cGuE8vWQo0OjNPmBPp8Df14xvwAq
        J7EX6xuHv5w2uKX6JTdvIXfwmTHCb2AlNA==
X-Google-Smtp-Source: AGRyM1vn7lr717+GQspSu4HyZ37BBlyB+iCX5LNqnylcXTTkicw/0usXklZrZCaBhPD0iUCGUz03Ng==
X-Received: by 2002:a5d:4986:0:b0:21d:776c:2f11 with SMTP id r6-20020a5d4986000000b0021d776c2f11mr1566102wrq.119.1657033335288;
        Tue, 05 Jul 2022 08:02:15 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id k27-20020adfd23b000000b0021d728d687asm2518200wrh.36.2022.07.05.08.02.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 08:02:14 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v3 22/25] io_uring: flush notifiers after sendzc
Date:   Tue,  5 Jul 2022 16:01:22 +0100
Message-Id: <4b9bec36993104ac2a1183e81eaca8cce15ffe32.1656318994.git.asml.silence@gmail.com>
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

Allow to flush notifiers as a part of sendzc request by setting
IORING_SENDZC_FLUSH flag. When the sendzc request succeedes it will
flush the used [active] notifier.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring.h |  1 +
 io_uring/io_uring.c           | 11 +----------
 io_uring/io_uring.h           | 10 ++++++++++
 io_uring/net.c                |  4 +++-
 io_uring/notif.c              |  2 +-
 io_uring/notif.h              | 11 +++++++++++
 6 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 2509e6184bc7..2fd4e39a14d3 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -277,6 +277,7 @@ enum io_uring_op {
  */
 enum {
 	IORING_SENDZC_FIXED_BUF		= (1U << 0),
+	IORING_SENDZC_FLUSH		= (1U << 1),
 };
 
 /*
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 3b885d65e569..8f4152f01989 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -615,7 +615,7 @@ void __io_put_task(struct task_struct *task, int nr)
 	put_task_struct_many(task, nr);
 }
 
-static void io_task_refs_refill(struct io_uring_task *tctx)
+void io_task_refs_refill(struct io_uring_task *tctx)
 {
 	unsigned int refill = -tctx->cached_refs + IO_TCTX_REFS_CACHE_NR;
 
@@ -624,15 +624,6 @@ static void io_task_refs_refill(struct io_uring_task *tctx)
 	tctx->cached_refs += refill;
 }
 
-static inline void io_get_task_refs(int nr)
-{
-	struct io_uring_task *tctx = current->io_uring;
-
-	tctx->cached_refs -= nr;
-	if (unlikely(tctx->cached_refs < 0))
-		io_task_refs_refill(tctx);
-}
-
 static __cold void io_uring_drop_tctx_refs(struct task_struct *task)
 {
 	struct io_uring_task *tctx = task->io_uring;
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index e978654d1b14..cf154e9c8e28 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -60,6 +60,7 @@ void io_wq_submit_work(struct io_wq_work *work);
 void io_free_req(struct io_kiocb *req);
 void io_queue_next(struct io_kiocb *req);
 void __io_put_task(struct task_struct *task, int nr);
+void io_task_refs_refill(struct io_uring_task *tctx);
 
 bool io_match_task_safe(struct io_kiocb *head, struct task_struct *task,
 			bool cancel_all);
@@ -254,4 +255,13 @@ static inline void io_put_task(struct task_struct *task, int nr)
 		__io_put_task(task, nr);
 }
 
+static inline void io_get_task_refs(int nr)
+{
+	struct io_uring_task *tctx = current->io_uring;
+
+	tctx->cached_refs -= nr;
+	if (unlikely(tctx->cached_refs < 0))
+		io_task_refs_refill(tctx);
+}
+
 #endif
diff --git a/io_uring/net.c b/io_uring/net.c
index 3dfe07749b04..3cd75d69fe70 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -784,7 +784,7 @@ int io_connect(struct io_kiocb *req, unsigned int issue_flags)
 	return IOU_OK;
 }
 
-#define IO_SENDZC_VALID_FLAGS IORING_SENDZC_FIXED_BUF
+#define IO_SENDZC_VALID_FLAGS (IORING_SENDZC_FIXED_BUF|IORING_SENDZC_FLUSH)
 
 int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
@@ -895,6 +895,8 @@ int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 		return ret == -ERESTARTSYS ? -EINTR : ret;
 	}
 
+	if (zc->zc_flags & IORING_SENDZC_FLUSH)
+		io_notif_slot_flush_submit(notif_slot, 0);
 	io_req_set_res(req, ret, 0);
 	return IOU_OK;
 }
diff --git a/io_uring/notif.c b/io_uring/notif.c
index a53acdda9ec0..847535d34c65 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -133,7 +133,7 @@ struct io_notif *io_alloc_notif(struct io_ring_ctx *ctx,
 	return notif;
 }
 
-static void io_notif_slot_flush(struct io_notif_slot *slot)
+void io_notif_slot_flush(struct io_notif_slot *slot)
 	__must_hold(&ctx->uring_lock)
 {
 	struct io_notif *notif = slot->notif;
diff --git a/io_uring/notif.h b/io_uring/notif.h
index 00efe164bdc4..6cd73d7b965b 100644
--- a/io_uring/notif.h
+++ b/io_uring/notif.h
@@ -54,6 +54,7 @@ int io_notif_register(struct io_ring_ctx *ctx,
 int io_notif_unregister(struct io_ring_ctx *ctx);
 void io_notif_cache_purge(struct io_ring_ctx *ctx);
 
+void io_notif_slot_flush(struct io_notif_slot *slot);
 struct io_notif *io_alloc_notif(struct io_ring_ctx *ctx,
 				struct io_notif_slot *slot);
 
@@ -74,3 +75,13 @@ static inline struct io_notif_slot *io_get_notif_slot(struct io_ring_ctx *ctx,
 	idx = array_index_nospec(idx, ctx->nr_notif_slots);
 	return &ctx->notif_slots[idx];
 }
+
+static inline void io_notif_slot_flush_submit(struct io_notif_slot *slot,
+					      unsigned int issue_flags)
+{
+	if (!(issue_flags & IO_URING_F_UNLOCKED)) {
+		slot->notif->task = current;
+		io_get_task_refs(1);
+	}
+	io_notif_slot_flush(slot);
+}
-- 
2.36.1

