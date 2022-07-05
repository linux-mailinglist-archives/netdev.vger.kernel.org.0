Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 453E75671FA
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 17:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231960AbiGEPDQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 11:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232282AbiGEPC1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 11:02:27 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9302117A83;
        Tue,  5 Jul 2022 08:02:07 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id b26so17992602wrc.2;
        Tue, 05 Jul 2022 08:02:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ya8qQYe1KtoEMBzW9pCDBd1YyLHf7cpw6uXv6rtRGgo=;
        b=qJgb3nPiM5uOk2DOVZFGqFxetXhonVk+2Yp7g2NFgMEKQIigE6zl6wDa2Jw5+bi9z7
         uAkhuYGcNvQIMN4T7jJCmlZ25MzhsihALwA7079NbeRr4SsH/14TESMxiZHmqKEBxNNe
         NwgV4web0zPNZNOhyZp67+rv6jdTd9mMw7Tk4kXjCnYEGyfpT5UPgvbzWgb+/mVFNRDT
         scxWQPMeNkb6zIc4pU/ZbjQY4Jr/Nt6/lYpZGEv3tADTu1jq2yVi2pUEO/zZFEy4ltSf
         f5NUNvfZ31PRJO/OZslpqFMhmRDSnkzWQWOqghWeRXW1gJOFNHWMaRuRGt1c+pc5KsFL
         TGCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ya8qQYe1KtoEMBzW9pCDBd1YyLHf7cpw6uXv6rtRGgo=;
        b=VbLzLOpCuX+XgF9KJ4qdJMZxtTgiUl/xHleMNBUceKA05uqzLfGz7THHBmYu9n6bMC
         o1DsT7luyWbgjW+TBePVYhIG6y7H03sMB62aN+i43u7YtMKRzO9T/QFRrLjja2pnwrqf
         L8XZc3PCorneOwFZC0iRAD49L1Jpk+AxndWp3zxlqhRNOefCJzdZ3wN3ePuFrF0URZLt
         I+gl2l4x5a26RdCzDLBF72lXRSLp6Y/wuPXn4eBziViTaP9gywmP0KycLNHnkpnbmtEC
         KOB2eWcFLI2aW3ZgEhSxOJfA+ezEf9yC4184cIPoWRWfQ2PIXm5VGX1ia6zvSz3Jcw57
         QkjQ==
X-Gm-Message-State: AJIora+vYjMuGwAHmPp10EdZVIDAo/ttASJFG84UTzETzwDJYoCT4CA7
        iYq8pRh/Mohtv/Add4f8+qsFo8alwjiPOw==
X-Google-Smtp-Source: AGRyM1vUwW9XmUV7WuK8J2o16zZbs2hbd4UedhhHToqg9/fGWrPcDs5HDMPpTFbErf0q5d+FXWCvxA==
X-Received: by 2002:adf:e3cb:0:b0:21b:8de5:ec7d with SMTP id k11-20020adfe3cb000000b0021b8de5ec7dmr33304609wrm.714.1657033326152;
        Tue, 05 Jul 2022 08:02:06 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id k27-20020adfd23b000000b0021d728d687asm2518200wrh.36.2022.07.05.08.02.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 08:02:05 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v3 15/25] io_uring: complete notifiers in tw
Date:   Tue,  5 Jul 2022 16:01:15 +0100
Message-Id: <591b24351034d95bc4f39a3d1cbbb7132109218d.1656318994.git.asml.silence@gmail.com>
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

We need a task context to post CQEs but using wq is too expensive.
Try to complete notifiers using task_work and fall back to wq if fails.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/notif.c | 22 +++++++++++++++++++---
 io_uring/notif.h |  3 +++
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/io_uring/notif.c b/io_uring/notif.c
index ffbd5ce03c36..f795e820de56 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -13,6 +13,11 @@ static void __io_notif_complete_tw(struct callback_head *cb)
 	struct io_notif *notif = container_of(cb, struct io_notif, task_work);
 	struct io_ring_ctx *ctx = notif->ctx;
 
+	if (likely(notif->task)) {
+		io_put_task(notif->task, 1);
+		notif->task = NULL;
+	}
+
 	io_cq_lock(ctx);
 	io_fill_cqe_aux(ctx, notif->tag, 0, notif->seq);
 
@@ -43,6 +48,14 @@ static void io_uring_tx_zerocopy_callback(struct sk_buff *skb,
 
 	if (!refcount_dec_and_test(&uarg->refcnt))
 		return;
+
+	if (likely(notif->task)) {
+		init_task_work(&notif->task_work, __io_notif_complete_tw);
+		if (likely(!task_work_add(notif->task, &notif->task_work,
+					  TWA_SIGNAL)))
+		return;
+	}
+
 	INIT_WORK(&notif->commit_work, io_notif_complete_wq);
 	queue_work(system_unbound_wq, &notif->commit_work);
 }
@@ -134,12 +147,15 @@ __cold int io_notif_unregister(struct io_ring_ctx *ctx)
 	for (i = 0; i < ctx->nr_notif_slots; i++) {
 		struct io_notif_slot *slot = &ctx->notif_slots[i];
 
-		if (slot->notif)
-			io_notif_slot_flush(slot);
+		if (!slot->notif)
+			continue;
+		if (WARN_ON_ONCE(slot->notif->task))
+			slot->notif->task = NULL;
+		io_notif_slot_flush(slot);
 	}
 
 	kvfree(ctx->notif_slots);
 	ctx->notif_slots = NULL;
 	ctx->nr_notif_slots = 0;
 	return 0;
-}
\ No newline at end of file
+}
diff --git a/io_uring/notif.h b/io_uring/notif.h
index b23c9c0515bb..23ca7620fff9 100644
--- a/io_uring/notif.h
+++ b/io_uring/notif.h
@@ -11,6 +11,9 @@ struct io_notif {
 	struct ubuf_info	uarg;
 	struct io_ring_ctx	*ctx;
 
+	/* complete via tw if ->task is non-NULL, fallback to wq otherwise */
+	struct task_struct	*task;
+
 	/* cqe->user_data, io_notif_slot::tag if not overridden */
 	u64			tag;
 	/* see struct io_notif_slot::seq */
-- 
2.36.1

