Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DCB5389057
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 16:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354235AbhESOQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 10:16:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353991AbhESOPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 10:15:39 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E86A7C061761;
        Wed, 19 May 2021 07:14:09 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id v12so14199302wrq.6;
        Wed, 19 May 2021 07:14:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vVU1uY4IfNnz3Vpp/U7vP1o2Q47qEq5p9Zy12+8Bn0M=;
        b=LlxYu6FcIiLVpg2u8S03Oeqc1AY9D0Old35JFdEyviyAIBvd+CGSqE730ve/FHa5Su
         qNNzpjV5KfXk7XUFM4IJr0Dj8PDEI8RGD/AafWZCNgwnLA1mycoCVzy/om16WI5tmxC0
         ezymZQrQ7TuwdfZ0cVxfaV7bTiPcSA/ZVXGfea9DL1BVg0CN50q4yDofBEpTn5DyiNnW
         2U/yJ19zT2MDd3Q7qyPcWKi4tBzGPSOh38mQsiGkAOpyPdN49sV+k9eaUhkThK1+wlOs
         RMkm5pj3cUEalrR8sxBqQlOOGoffXrTyGdJ0XtQQUW7iPX8oa7MbB2bPWlwQYk/3kSOB
         BcQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vVU1uY4IfNnz3Vpp/U7vP1o2Q47qEq5p9Zy12+8Bn0M=;
        b=VT1Kav35VuYmnvYQ/ASh+dOxj3Jds07Jqp0qD+ebq0sfjzAzlw7Osd5dPredCl/STq
         /NYP+7L16fCaovvRg6RZef33FDecS8ijh+q1OSbElnqrDisdonVLx3ImWqfJkMHn4Kyo
         Xmqj9hUkCGFaMro94npmZ5xGtsr8yIkzC0sGzeH5if0JdfvMf6qwSOl+xuDJVJXjjQtk
         2vAQAu3N7EGJkURC/jVUGdg0bTVT+1GR6HlOj56mIvrQyIejt+P8Fgr0ybQQ+LzxH/kM
         UtANbZp8GjJZ4HJm6UsU8/rR7CnfOdB2fnINWHu7tHcYBUewAUXWRTISdHKyucKfw4eF
         WEbQ==
X-Gm-Message-State: AOAM533AaiKlK1dFVTmUGC0cdjEDg8EAcPWOTJiox0QqfU/pGiejFvfn
        wd35+/C1fWmzG065s8FAVRhbIYrLGsg6AWEz
X-Google-Smtp-Source: ABdhPJzfSmgKzTxEWRG/9Apx4pLQWaCiFZdNWz7k4KIxVRHiBrJi1ixOMCqyUH7c9eBi+vY+ue0eWA==
X-Received: by 2002:adf:e5ce:: with SMTP id a14mr14414798wrn.180.1621433648349;
        Wed, 19 May 2021 07:14:08 -0700 (PDT)
Received: from localhost.localdomain ([85.255.235.154])
        by smtp.gmail.com with ESMTPSA id z3sm6233569wrq.42.2021.05.19.07.14.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 07:14:07 -0700 (PDT)
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
Subject: [PATCH 15/23] io_uring: enable BPF to submit SQEs
Date:   Wed, 19 May 2021 15:13:26 +0100
Message-Id: <8ec8373d406d1fcb41719e641799dcc5c0455db3.1621424513.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1621424513.git.asml.silence@gmail.com>
References: <cover.1621424513.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a BPF_FUNC_iouring_queue_sqe BPF function as a demonstration of
submmiting a new request by a BPF request.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c            | 51 ++++++++++++++++++++++++++++++++++++----
 include/uapi/linux/bpf.h |  1 +
 2 files changed, 48 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 20fddc5945f2..aae786291c57 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -882,6 +882,7 @@ struct io_defer_entry {
 };
 
 struct io_bpf_ctx {
+	struct io_ring_ctx	*ctx;
 };
 
 struct io_op_def {
@@ -6681,7 +6682,8 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 			ret = -EBADF;
 	}
 
-	state->ios_left--;
+	if (state->ios_left > 1)
+		state->ios_left--;
 	return ret;
 }
 
@@ -10345,10 +10347,50 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 	return ret;
 }
 
+BPF_CALL_3(io_bpf_queue_sqe, struct io_bpf_ctx *,		bpf_ctx,
+			     const struct io_uring_sqe *,	sqe,
+			     u32,				sqe_len)
+{
+	struct io_ring_ctx *ctx = bpf_ctx->ctx;
+	struct io_kiocb *req;
+
+	if (sqe_len != sizeof(struct io_uring_sqe))
+		return -EINVAL;
+
+	req = io_alloc_req(ctx);
+	if (unlikely(!req))
+		return -ENOMEM;
+	if (!percpu_ref_tryget_many(&ctx->refs, 1)) {
+		kmem_cache_free(req_cachep, req);
+		return -EAGAIN;
+	}
+	percpu_counter_add(&current->io_uring->inflight, 1);
+	refcount_add(1, &current->usage);
+
+	/* returns number of submitted SQEs or an error */
+	return !io_submit_sqe(ctx, req, sqe);
+}
+
+const struct bpf_func_proto io_bpf_queue_sqe_proto = {
+	.func = io_bpf_queue_sqe,
+	.gpl_only = false,
+	.ret_type = RET_INTEGER,
+	.arg1_type = ARG_PTR_TO_CTX,
+	.arg2_type = ARG_PTR_TO_MEM,
+	.arg3_type = ARG_CONST_SIZE,
+};
+
 static const struct bpf_func_proto *
 io_bpf_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 {
-	return bpf_base_func_proto(func_id);
+	switch (func_id) {
+	case BPF_FUNC_copy_from_user:
+		return prog->aux->sleepable ? &bpf_copy_from_user_proto : NULL;
+	case BPF_FUNC_iouring_queue_sqe:
+		return prog->aux->sleepable ? &io_bpf_queue_sqe_proto : NULL;
+	default:
+		return bpf_base_func_proto(func_id);
+	}
 }
 
 static bool io_bpf_is_valid_access(int off, int size,
@@ -10379,9 +10421,10 @@ static void io_bpf_run(struct io_kiocb *req, unsigned int issue_flags)
 		     atomic_read(&req->task->io_uring->in_idle)))
 		goto done;
 
-	memset(&bpf_ctx, 0, sizeof(bpf_ctx));
+	bpf_ctx.ctx = ctx;
 	prog = req->bpf.prog;
 
+	io_submit_state_start(&ctx->submit_state, 1);
 	if (prog->aux->sleepable) {
 		rcu_read_lock();
 		bpf_prog_run_pin_on_cpu(req->bpf.prog, &bpf_ctx);
@@ -10389,7 +10432,7 @@ static void io_bpf_run(struct io_kiocb *req, unsigned int issue_flags)
 	} else {
 		bpf_prog_run_pin_on_cpu(req->bpf.prog, &bpf_ctx);
 	}
-
+	io_submit_state_end(&ctx->submit_state, ctx);
 	ret = 0;
 done:
 	__io_req_complete(req, issue_flags, ret, 0);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index de544f0fbeef..cc268f749a7d 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4082,6 +4082,7 @@ union bpf_attr {
 	FN(ima_inode_hash),		\
 	FN(sock_from_file),		\
 	FN(check_mtu),			\
+	FN(iouring_queue_sqe),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.31.1

