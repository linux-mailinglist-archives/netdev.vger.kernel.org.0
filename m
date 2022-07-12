Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C1F65727F7
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 22:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234267AbiGLUy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 16:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231556AbiGLUxw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 16:53:52 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED038D0E3B;
        Tue, 12 Jul 2022 13:53:28 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id f2so12810283wrr.6;
        Tue, 12 Jul 2022 13:53:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=S7QIHL9rz0f1Xw6h7UlVdKmXRdlJe5R2rqah9rB6Z1U=;
        b=WmTK37BhXvSOMT0wNwK2oZ6SpVo7QQt/gbQnNtPtgHH92KjlYgZJv0tz3Y50aPG+HX
         IlbmGmgnzmB/T0vLDIQxdYNW3nmvO/OwpNi4oj4G3HSa0RH1yldAdQtFN6gZwvFqxbD4
         EMPoPQjd8Fwnvx4SiBzBT6OAc3qufkddonjOkdlfbkTnmUMyI3etiQZQtkop/RNMt+5g
         fOgA4xHviW6UoqGBDfrIkHsZzle6rJ93MgB9I9KaX97fOfJlHsOhWW01xZqkTGQYVuPW
         +IvZ+4tTOdVk93ASrEiXeM2WWeeCx/rT5avkPPlW3DXhZsxQI41OjCZ5IFgM5ZPcxczr
         8hTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S7QIHL9rz0f1Xw6h7UlVdKmXRdlJe5R2rqah9rB6Z1U=;
        b=cz/pYVxkCUZUs4e7O0EZC+32tr7CZlZsFOQt0LLqwd2bfVDwsem2r/Ujhd9Gvv/sAq
         rGx2vttuNYGzJrxRvmXtwQb8Nx9rf8jHUGLSISt+vmrwh0mjI+aeypQY0sbnY5/XoRbc
         7QmgCI2aeyoK7QUAT3N1LEm77NhNlIP4bPnyErRFjyDssFTgLgDWzKE2O31hrp6aiDog
         BZyc/MsgV+3WnORrhRcCbC3v8O/YvBpqQL7hN688wjELqq18rm1gHfbXbCW86hHWKN5E
         ZRL3NsqzolW5b9Ly5wet+1Khp0ACG7k3RuxG8lwACWVnxcYdd2/5sUs8I8Qj5UnzNsz2
         tqrA==
X-Gm-Message-State: AJIora/0FPU0ALntquVX4aSlnVPTsZuNU2PNvCIeG57L/wA5WR4oJigb
        m/8PGiBvH/IRKadKGxpcJ3ytK5umsPg=
X-Google-Smtp-Source: AGRyM1seF52c451hR69uLK5grok3sZWkfdwfn2W1+GceSC1Rz0Yx94N46AV5vP36NL/vysqrWr9Gbw==
X-Received: by 2002:a5d:588b:0:b0:21d:a918:65a5 with SMTP id n11-20020a5d588b000000b0021da91865a5mr10607375wrf.210.1657659206728;
        Tue, 12 Jul 2022 13:53:26 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id c14-20020a7bc00e000000b003a044fe7fe7sm89833wmb.9.2022.07.12.13.53.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 13:53:26 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v5 16/27] io_uring: complete notifiers in tw
Date:   Tue, 12 Jul 2022 21:52:40 +0100
Message-Id: <089799ab665b10b78fdc614ae6d59fa7ef0d5f91.1657643355.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <cover.1657643355.git.asml.silence@gmail.com>
References: <cover.1657643355.git.asml.silence@gmail.com>
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
index b257db2120b4..aec74f88fc33 100644
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
 	io_fill_cqe_aux(ctx, notif->tag, 0, notif->seq, true);
 
@@ -43,6 +48,14 @@ static void io_uring_tx_zerocopy_callback(struct sk_buff *skb,
 
 	if (!refcount_dec_and_test(&uarg->refcnt))
 		return;
+
+	if (likely(notif->task)) {
+		init_task_work(&notif->task_work, __io_notif_complete_tw);
+		if (likely(!task_work_add(notif->task, &notif->task_work,
+					  TWA_SIGNAL)))
+			return;
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
2.37.0

