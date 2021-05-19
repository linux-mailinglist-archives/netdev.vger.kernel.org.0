Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62198389051
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 16:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354206AbhESOQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 10:16:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353990AbhESOPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 10:15:39 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D045AC06175F;
        Wed, 19 May 2021 07:14:08 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id b7so6787575wmh.5;
        Wed, 19 May 2021 07:14:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZfMi8N0pZ9W/LFQX3/SPx1aTt3/UeZJSyxUGTs5xnSM=;
        b=DKCvsjFafrURQCuJflXsY2aEMYOAJ8DUoHLkntlKnXDpENDibKhvkurYRXl2Ikuu+3
         SVAxuGFvLiiewZOtoZq7pESZAwzQqIOS56aYjlIBdgPdjIKiKVKi0k0viCPjPjL6/ChA
         2dzyn+jsuzMePX1WbJLjDMIVt5tLDKgf940B188vYlbllA3gND6dz3M43ks15oBd34Og
         q/8tuKom9wZU0Z3URjffYjiqTQ184iLbv4qfwwdkfTYohgmzURApva1dYOdJaVgsynjc
         Duo1ZStcQrgICLYBwreFmLdB9cgsam1N9peq71oiDxXvH9DEGsCZMONBJgf25Devtm/Z
         4XHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZfMi8N0pZ9W/LFQX3/SPx1aTt3/UeZJSyxUGTs5xnSM=;
        b=AGkbWR4TlyO275SIcNKnW16RJGHi2ocMqIg3Ll92lFlHEWXWJNIIAmUKGZ7WU5EVa1
         RSX1dJGlIjYkAKkMxw6A7Doi+/za5ankiDKC/SeH1suDzoEQzAhlOiCMJ/TxRy+Zlfx1
         9S5T0Q3ZqtNuhycmNwfACkUGlmmTB7A3Xd8f6aC/McX4j/VxJagSZejZR2p0cwclTOtJ
         h7xzASRy1BOW7/d14Yd6aXxW/i0id5iLuvaOxDTI926fsMg6ubYArJ4tyFaMy7ncs5z/
         9A3D/qourAjJGQvTiKVG2gew0FU+aQ0m6r8rQogptMi8h1E1VM/aar1ezwrilvIm8mn5
         rtdw==
X-Gm-Message-State: AOAM5312ET0gARN1zd5+5HyDghsChKX434y4xX9I5ehHE0t4/xofp2c+
        pm+iiG83WZlkvxrhFT924ko0jxwDz/AJbvi4
X-Google-Smtp-Source: ABdhPJzdXkn8OQjcy54S7MiXoDu+Qf+E9i+8Y9rH17K9BFswuLzN78yl5qnA7dsNftSTiiL0K4BnIw==
X-Received: by 2002:a05:600c:19c8:: with SMTP id u8mr11215829wmq.25.1621433647073;
        Wed, 19 May 2021 07:14:07 -0700 (PDT)
Received: from localhost.localdomain ([85.255.235.154])
        by smtp.gmail.com with ESMTPSA id z3sm6233569wrq.42.2021.05.19.07.14.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 07:14:06 -0700 (PDT)
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
Subject: [PATCH 14/23] io_uring: add support for bpf requests
Date:   Wed, 19 May 2021 15:13:25 +0100
Message-Id: <cc2b848d112d86bd1f4ea3f2813d0a016e44a364.1621424513.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1621424513.git.asml.silence@gmail.com>
References: <cover.1621424513.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wire up a new io_uring operation type IORING_OP_BPF, which executes a
specified BPF program from the registered prog table. It doesn't allow
to do anything useful for now, no BPF functions are allowed apart from
basic ones.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c                 | 92 +++++++++++++++++++++++++++++++++++
 include/uapi/linux/io_uring.h |  1 +
 2 files changed, 93 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b13cbcd5c47b..20fddc5945f2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -682,6 +682,11 @@ struct io_unlink {
 	struct filename			*filename;
 };
 
+struct io_bpf {
+	struct file			*file;
+	struct bpf_prog			*prog;
+};
+
 struct io_completion {
 	struct file			*file;
 	struct list_head		list;
@@ -826,6 +831,7 @@ struct io_kiocb {
 		struct io_shutdown	shutdown;
 		struct io_rename	rename;
 		struct io_unlink	unlink;
+		struct io_bpf		bpf;
 		/* use only after cleaning per-op data, see io_clean_op() */
 		struct io_completion	compl;
 	};
@@ -875,6 +881,9 @@ struct io_defer_entry {
 	u32			seq;
 };
 
+struct io_bpf_ctx {
+};
+
 struct io_op_def {
 	/* needs req->file assigned */
 	unsigned		needs_file : 1;
@@ -1039,6 +1048,7 @@ static const struct io_op_def io_op_defs[] = {
 	},
 	[IORING_OP_RENAMEAT] = {},
 	[IORING_OP_UNLINKAT] = {},
+	[IORING_OP_BPF] = {},
 };
 
 static bool io_disarm_next(struct io_kiocb *req);
@@ -1070,6 +1080,7 @@ static void io_rsrc_put_work(struct work_struct *work);
 static void io_req_task_queue(struct io_kiocb *req);
 static void io_submit_flush_completions(struct io_comp_state *cs,
 					struct io_ring_ctx *ctx);
+static void io_bpf_run(struct io_kiocb *req, unsigned int issue_flags);
 static bool io_poll_remove_waitqs(struct io_kiocb *req);
 static int io_req_prep_async(struct io_kiocb *req);
 
@@ -3931,6 +3942,53 @@ static int io_openat(struct io_kiocb *req, unsigned int issue_flags)
 	return io_openat2(req, issue_flags);
 }
 
+static int io_bpf_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	struct bpf_prog *prog;
+	unsigned int idx;
+
+	if (unlikely(ctx->flags & (IORING_SETUP_IOPOLL|IORING_SETUP_SQPOLL)))
+		return -EINVAL;
+	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
+		return -EINVAL;
+	if (sqe->ioprio || sqe->len || sqe->cancel_flags)
+		return -EINVAL;
+	if (sqe->addr)
+		return -EINVAL;
+
+	idx = READ_ONCE(sqe->off);
+	if (unlikely(idx >= ctx->nr_bpf_progs))
+		return -EFAULT;
+	idx = array_index_nospec(idx, ctx->nr_bpf_progs);
+	prog = ctx->bpf_progs[idx].prog;
+	if (!prog)
+		return -EFAULT;
+
+	req->bpf.prog = prog;
+	return 0;
+}
+
+static void io_bpf_run_task_work(struct callback_head *cb)
+{
+	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
+	struct io_ring_ctx *ctx = req->ctx;
+
+	mutex_lock(&ctx->uring_lock);
+	io_bpf_run(req, 0);
+	mutex_unlock(&ctx->uring_lock);
+}
+
+static int io_bpf(struct io_kiocb *req, unsigned int issue_flags)
+{
+	init_task_work(&req->task_work, io_bpf_run_task_work);
+	if (unlikely(io_req_task_work_add(req))) {
+		req_ref_get(req);
+		io_req_task_queue_fail(req, -ECANCELED);
+	}
+	return 0;
+}
+
 static int io_remove_buffers_prep(struct io_kiocb *req,
 				  const struct io_uring_sqe *sqe)
 {
@@ -6002,6 +6060,8 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return io_renameat_prep(req, sqe);
 	case IORING_OP_UNLINKAT:
 		return io_unlinkat_prep(req, sqe);
+	case IORING_OP_BPF:
+		return io_bpf_prep(req, sqe);
 	}
 
 	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
@@ -6269,6 +6329,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	case IORING_OP_UNLINKAT:
 		ret = io_unlinkat(req, issue_flags);
 		break;
+	case IORING_OP_BPF:
+		ret = io_bpf(req, issue_flags);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
@@ -10303,6 +10366,35 @@ const struct bpf_verifier_ops bpf_io_uring_verifier_ops = {
 	.is_valid_access	= io_bpf_is_valid_access,
 };
 
+static void io_bpf_run(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_bpf_ctx bpf_ctx;
+	struct bpf_prog *prog;
+	int ret = -EAGAIN;
+
+	lockdep_assert_held(&req->ctx->uring_lock);
+
+	if (unlikely(percpu_ref_is_dying(&ctx->refs) ||
+		     atomic_read(&req->task->io_uring->in_idle)))
+		goto done;
+
+	memset(&bpf_ctx, 0, sizeof(bpf_ctx));
+	prog = req->bpf.prog;
+
+	if (prog->aux->sleepable) {
+		rcu_read_lock();
+		bpf_prog_run_pin_on_cpu(req->bpf.prog, &bpf_ctx);
+		rcu_read_unlock();
+	} else {
+		bpf_prog_run_pin_on_cpu(req->bpf.prog, &bpf_ctx);
+	}
+
+	ret = 0;
+done:
+	__io_req_complete(req, issue_flags, ret, 0);
+}
+
 SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
 		void __user *, arg, unsigned int, nr_args)
 {
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index b450f41d7389..25ab804670e1 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -138,6 +138,7 @@ enum {
 	IORING_OP_SHUTDOWN,
 	IORING_OP_RENAMEAT,
 	IORING_OP_UNLINKAT,
+	IORING_OP_BPF,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.31.1

