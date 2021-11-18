Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B333D455A3F
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 12:29:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344069AbhKRLbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 06:31:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:51715 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343949AbhKRL3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 06:29:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637234778;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=saUFETjyBrBLEue6scFG9UfDs+1LHN9Kj7f1do4qA6U=;
        b=RZRWvN6YN67hs3j7xTuVjDGqHpZeepEuyKK/wAudhBvWaZTx5y5AEgJwjjuu4su2orZX21
        7zzjgK4vOJEH52mCgQcD5zr7vZQsJZOtIK3rJXZTb56aibzNfb24LLhQmLHiT7fHFo5gNJ
        j4M1OZQXIdjwf4whCnst4HgUsmwR6V8=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-475-3EM7ErLWPxarSiEht7sV7w-1; Thu, 18 Nov 2021 06:26:16 -0500
X-MC-Unique: 3EM7ErLWPxarSiEht7sV7w-1
Received: by mail-ed1-f72.google.com with SMTP id p4-20020aa7d304000000b003e7ef120a37so4972956edq.16
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 03:26:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=saUFETjyBrBLEue6scFG9UfDs+1LHN9Kj7f1do4qA6U=;
        b=R56w72RMygyS3YBDkBE98cTuqUq2gsHxrcVvnwfaIq0M/sayuP/ElN9stzgQSE3j36
         kzHuq+cTZg71j2xw/xEdrmbVpyjCJsYHlTjRGv0cVbzkp/oD3baWu3j8Dq+4pnSbL6SA
         YlAlRA4iy1VdC41e3AKtCUXRFtHsmKL3MC0lA15w9VxPVYpYBehHXVLG9tORBPOIOnEu
         S2ppFHxsnrg163ikXMa2FIHMb2vbljunSjIKcrSW4rDV6cqrRWbz7ULv1HK0Xz3Y5+aq
         uANfc1NetrfOCfLaPHpGkkZtjiPvDHe5/h1H18HQlFUPr5ifgxHjmEUmKEGrH2+o1wMr
         4jWg==
X-Gm-Message-State: AOAM531Ae4YSv8cB2uhMFrKQbv6hQraflGmW5iRzl2fmeD2L2mmK6Pjc
        +BQRVWx9hy1/vfsBSnj2zLQh8ogj5gRz/llY6y8WYtbmENR0jGQFcw0fNmq3wfnJfidWzz/g/UU
        yOUtpAk3PqBYFZrWF
X-Received: by 2002:a05:6402:430e:: with SMTP id m14mr10206840edc.93.1637234775325;
        Thu, 18 Nov 2021 03:26:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzsH1mMFGHxfgayiYeeuaUjyG6xuSK7HKrO9rKbFyOF9P4GU3y1M+Rfv+jh1+A/WoSom5RcNA==
X-Received: by 2002:a05:6402:430e:: with SMTP id m14mr10206785edc.93.1637234775050;
        Thu, 18 Nov 2021 03:26:15 -0800 (PST)
Received: from krava.redhat.com (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id l16sm567137edb.59.2021.11.18.03.26.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 03:26:14 -0800 (PST)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: [PATCH bpf-next 13/29] bpf: Add bpf_tramp_attach layer for trampoline attachment
Date:   Thu, 18 Nov 2021 12:24:39 +0100
Message-Id: <20211118112455.475349-14-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211118112455.475349-1-jolsa@kernel.org>
References: <20211118112455.475349-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding bpf_tramp_attach layer for trampoline attachment to
have extra layer on top of the trampoline. The reason is
that in following changes we will add multiple trampolines
for single program and we need entity to hold them.

The api in nutshell:

  - each bpf_prog holds 'bpf_tramp_attach' object, which holds
    list of 'struct bpf_tramp_node' objects:

    struct bpf_tramp_attach {
      struct bpf_tramp_id *id;
      struct hlist_head nodes;
    };

    This allow us to hold multiple trampolines for each program.

  - bpf_tramp_attach returns 'bpf_tramp_attach' object that
    finds trampoline for given 'id' and adds it to the attach
    object, no actuall program attachment is done, just trampoline
    allocation

  - bpf_tramp_attach_link does the actual attachment of the
    program to trampoline

  - bpf_tramp_attach_unlink unlinks all the trampolines present
    in the attach object

  - bpf_tramp_detach frees all the trampolines in attach object

Currently there'll be only single node added in attach object.

Following patches add support for multiple id trampolines,
and uses multiple nodes in attach object to hold trampoline
for given program.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/bpf.h     |  21 +++++--
 kernel/bpf/core.c       |   5 +-
 kernel/bpf/syscall.c    |  61 ++++++++++----------
 kernel/bpf/trampoline.c | 122 ++++++++++++++++++++++++++++++++--------
 kernel/bpf/verifier.c   |  12 ++--
 5 files changed, 156 insertions(+), 65 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 21f8dbcf3f48..2dbc00904a84 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -679,7 +679,14 @@ struct bpf_tramp_id {
 
 struct bpf_tramp_node {
 	struct hlist_node hlist_tramp;
+	struct hlist_node hlist_attach;
 	struct bpf_prog *prog;
+	struct bpf_trampoline *tr;
+};
+
+struct bpf_tramp_attach {
+	struct bpf_tramp_id *id;
+	struct hlist_head nodes;
 };
 
 struct bpf_trampoline {
@@ -751,9 +758,14 @@ void bpf_tramp_id_init(struct bpf_tramp_id *id,
 		       struct btf *btf, u32 btf_id);
 int bpf_trampoline_link_prog(struct bpf_tramp_node *node, struct bpf_trampoline *tr);
 int bpf_trampoline_unlink_prog(struct bpf_tramp_node *node, struct bpf_trampoline *tr);
-struct bpf_trampoline *bpf_trampoline_get(struct bpf_tramp_id *id,
-					  struct bpf_attach_target_info *tgt_info);
 void bpf_trampoline_put(struct bpf_trampoline *tr);
+
+struct bpf_tramp_attach *bpf_tramp_attach(struct bpf_tramp_id *id,
+					  struct bpf_prog *tgt_prog,
+					  struct bpf_prog *prog);
+void bpf_tramp_detach(struct bpf_tramp_attach *attach);
+int bpf_tramp_attach_link(struct bpf_tramp_attach *attach);
+int bpf_tramp_attach_unlink(struct bpf_tramp_attach *attach);
 #define BPF_DISPATCHER_INIT(_name) {				\
 	.mutex = __MUTEX_INITIALIZER(_name.mutex),		\
 	.func = &_name##_func,					\
@@ -888,8 +900,8 @@ struct bpf_prog_aux {
 	const struct bpf_ctx_arg_aux *ctx_arg_info;
 	struct mutex dst_mutex; /* protects dst_* pointers below, *after* prog becomes visible */
 	struct bpf_prog *dst_prog;
-	struct bpf_trampoline *dst_trampoline;
-	struct bpf_trampoline *trampoline;
+	struct bpf_tramp_attach *dst_attach;
+	struct bpf_tramp_attach *attach;
 	enum bpf_prog_type saved_dst_prog_type;
 	enum bpf_attach_type saved_dst_attach_type;
 	bool verifier_zext; /* Zero extensions has been inserted by verifier. */
@@ -899,7 +911,6 @@ struct bpf_prog_aux {
 	bool sleepable;
 	bool tail_call_reachable;
 	bool multi_func;
-	struct bpf_tramp_node tramp_node;
 	/* BTF_KIND_FUNC_PROTO for valid attach_btf_id */
 	const struct btf_type *attach_func_proto;
 	/* function name for valid attach_btf_id */
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 2eed91153a3f..993ae224e371 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -105,7 +105,6 @@ struct bpf_prog *bpf_prog_alloc_no_stats(unsigned int size, gfp_t gfp_extra_flag
 	fp->aux = aux;
 	fp->aux->prog = fp;
 	fp->jit_requested = ebpf_jit_enabled();
-	fp->aux->tramp_node.prog = fp;
 
 	INIT_LIST_HEAD_RCU(&fp->aux->ksym.lnode);
 	mutex_init(&fp->aux->used_maps_mutex);
@@ -2284,8 +2283,8 @@ static void bpf_prog_free_deferred(struct work_struct *work)
 	if (aux->prog->has_callchain_buf)
 		put_callchain_buffers();
 #endif
-	if (aux->dst_trampoline)
-		bpf_trampoline_put(aux->dst_trampoline);
+	if (aux->dst_attach)
+		bpf_tramp_detach(aux->dst_attach);
 	for (i = 0; i < aux->func_cnt; i++) {
 		/* We can just unlink the subprog poke descriptor table as
 		 * it was originally linked to the main program and is also
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 0d916e3b7676..a65c1862ab68 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2644,32 +2644,32 @@ struct bpf_link *bpf_link_get_from_fd(u32 ufd)
 struct bpf_tracing_link {
 	struct bpf_link link;
 	enum bpf_attach_type attach_type;
-	struct bpf_trampoline *trampoline;
+	struct bpf_tramp_attach *attach;
 	struct bpf_prog *tgt_prog;
 };
 
-static struct bpf_trampoline *link_trampoline(struct bpf_tracing_link *link)
+static struct bpf_tramp_attach *link_attach(struct bpf_tracing_link *link)
 {
 	struct bpf_prog *prog = link->link.prog;
 
 	if (prog->type == BPF_PROG_TYPE_EXT)
-		return link->trampoline;
+		return link->attach;
 	else
-		return prog->aux->trampoline;
+		return prog->aux->attach;
 }
 
 static void bpf_tracing_link_release(struct bpf_link *link)
 {
 	struct bpf_tracing_link *tr_link =
 		container_of(link, struct bpf_tracing_link, link);
-	struct bpf_trampoline *tr = link_trampoline(tr_link);
+	struct bpf_tramp_attach *attach = link_attach(tr_link);
 	struct bpf_prog *prog = link->prog;
 
-	WARN_ON_ONCE(bpf_trampoline_unlink_prog(&link->prog->aux->tramp_node, tr));
+	WARN_ON_ONCE(bpf_tramp_attach_unlink(attach));
 
 	if (prog->type != BPF_PROG_TYPE_EXT)
-		prog->aux->trampoline = NULL;
-	bpf_trampoline_put(tr);
+		prog->aux->attach = NULL;
+	bpf_tramp_detach(attach);
 
 	/* tgt_prog is NULL if target is a kernel function */
 	if (tr_link->tgt_prog)
@@ -2700,11 +2700,11 @@ static int bpf_tracing_link_fill_link_info(const struct bpf_link *link,
 {
 	struct bpf_tracing_link *tr_link =
 		container_of(link, struct bpf_tracing_link, link);
-	struct bpf_trampoline *tr = link_trampoline(tr_link);
+	struct bpf_tramp_attach *attach = link_attach(tr_link);
 
 	info->tracing.attach_type = tr_link->attach_type;
-	info->tracing.target_obj_id = tr->id->obj_id;
-	info->tracing.target_btf_id = tr->id->btf_id;
+	info->tracing.target_obj_id = attach->id->obj_id;
+	info->tracing.target_btf_id = attach->id->btf_id;
 
 	return 0;
 }
@@ -2721,9 +2721,9 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog,
 				   u32 btf_id)
 {
 	bool prog_extension = prog->type == BPF_PROG_TYPE_EXT;
+	struct bpf_tramp_attach *attach = NULL;
 	struct bpf_link_primer link_primer;
 	struct bpf_prog *tgt_prog = NULL;
-	struct bpf_trampoline *tr = NULL;
 	struct bpf_tracing_link *link;
 	struct bpf_tramp_id *id = NULL;
 	int err;
@@ -2793,7 +2793,7 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog,
 
 	mutex_lock(&prog->aux->dst_mutex);
 
-	if (!prog_extension && prog->aux->trampoline) {
+	if (!prog_extension && prog->aux->attach) {
 		err = -EBUSY;
 		goto out_unlock;
 	}
@@ -2816,7 +2816,7 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog,
 	 * - if prog->aux->dst_trampoline and tgt_prog is NULL, the program
 	 *   was detached and is going for re-attachment.
 	 */
-	if (!prog->aux->dst_trampoline && !tgt_prog) {
+	if (!prog->aux->dst_attach && !tgt_prog) {
 		/*
 		 * Allow re-attach for TRACING and LSM programs. If it's
 		 * currently linked, bpf_trampoline_link_prog will fail.
@@ -2839,9 +2839,9 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog,
 		bpf_tramp_id_init(id, NULL, prog->aux->attach_btf, btf_id);
 	}
 
-	if (!prog->aux->dst_trampoline ||
+	if (!prog->aux->dst_attach ||
 	    (!bpf_tramp_id_is_empty(id) &&
-	      bpf_tramp_id_is_equal(id, prog->aux->dst_trampoline->id))) {
+	      bpf_tramp_id_is_equal(id, prog->aux->dst_attach->id))) {
 		/* If there is no saved target, or the specified target is
 		 * different from the destination specified at load time, we
 		 * need a new trampoline and a check for compatibility
@@ -2853,9 +2853,11 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog,
 		if (err)
 			goto out_unlock;
 
-		tr = bpf_trampoline_get(id, &tgt_info);
-		if (!tr) {
-			err = -ENOMEM;
+		id->addr = (void *) tgt_info.tgt_addr;
+
+		attach = bpf_tramp_attach(id, tgt_prog, prog);
+		if (IS_ERR(attach)) {
+			err = PTR_ERR(attach);
 			goto out_unlock;
 		}
 	} else {
@@ -2866,7 +2868,7 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog,
 		 * can only happen once for any program, as the saved values in
 		 * prog->aux are cleared below.
 		 */
-		tr = prog->aux->dst_trampoline;
+		attach = prog->aux->dst_attach;
 		tgt_prog = prog->aux->dst_prog;
 	}
 
@@ -2874,7 +2876,7 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog,
 	if (err)
 		goto out_unlock;
 
-	err = bpf_trampoline_link_prog(&prog->aux->tramp_node, tr);
+	err = bpf_tramp_attach_link(attach);
 	if (err) {
 		bpf_link_cleanup(&link_primer);
 		link = NULL;
@@ -2882,32 +2884,31 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog,
 	}
 
 	link->tgt_prog = tgt_prog;
-
 	if (prog_extension)
-		link->trampoline = tr;
+		link->attach = attach;
 	else
-		prog->aux->trampoline = tr;
+		prog->aux->attach = attach;
 
 	/* Always clear the trampoline and target prog from prog->aux to make
 	 * sure the original attach destination is not kept alive after a
 	 * program is (re-)attached to another target.
 	 */
 	if (prog->aux->dst_prog &&
-	    (tgt_prog_fd || tr != prog->aux->dst_trampoline))
+	    (tgt_prog_fd || attach != prog->aux->dst_attach))
 		/* got extra prog ref from syscall, or attaching to different prog */
 		bpf_prog_put(prog->aux->dst_prog);
-	if (prog->aux->dst_trampoline && tr != prog->aux->dst_trampoline)
+	if (prog->aux->dst_attach && attach != prog->aux->dst_attach)
 		/* we allocated a new trampoline, so free the old one */
-		bpf_trampoline_put(prog->aux->dst_trampoline);
+		bpf_tramp_detach(prog->aux->dst_attach);
 
 	prog->aux->dst_prog = NULL;
-	prog->aux->dst_trampoline = NULL;
+	prog->aux->dst_attach = NULL;
 	mutex_unlock(&prog->aux->dst_mutex);
 
 	return bpf_link_settle(&link_primer);
 out_unlock:
-	if (tr && tr != prog->aux->dst_trampoline)
-		bpf_trampoline_put(tr);
+	if (attach && attach != prog->aux->dst_attach)
+		bpf_tramp_detach(attach);
 	mutex_unlock(&prog->aux->dst_mutex);
 	kfree(link);
 out_put_prog:
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index b6af3e0982d7..16fc4c14319b 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -11,6 +11,7 @@
 #include <linux/rcupdate_wait.h>
 #include <linux/module.h>
 #include <linux/static_call.h>
+#include <linux/bpf_verifier.h>
 
 /* dummy _ops. The verifier will operate on target program's ops. */
 const struct bpf_verifier_ops bpf_extension_verifier_ops = {
@@ -98,7 +99,7 @@ void bpf_tramp_id_free(struct bpf_tramp_id *id)
 	kfree(id);
 }
 
-static struct bpf_trampoline *bpf_trampoline_lookup(struct bpf_tramp_id *id)
+static struct bpf_trampoline *bpf_trampoline_get(struct bpf_tramp_id *id)
 {
 	struct bpf_trampoline *tr;
 	struct hlist_head *head;
@@ -528,26 +529,6 @@ int bpf_trampoline_unlink_prog(struct bpf_tramp_node *node, struct bpf_trampolin
 	return err;
 }
 
-struct bpf_trampoline *bpf_trampoline_get(struct bpf_tramp_id *id,
-					  struct bpf_attach_target_info *tgt_info)
-{
-	struct bpf_trampoline *tr;
-
-	tr = bpf_trampoline_lookup(id);
-	if (!tr)
-		return NULL;
-
-	mutex_lock(&tr->mutex);
-	if (tr->id->addr)
-		goto out;
-
-	memcpy(&tr->func.model, &tgt_info->fmodel, sizeof(tgt_info->fmodel));
-	tr->id->addr = (void *)tgt_info->tgt_addr;
-out:
-	mutex_unlock(&tr->mutex);
-	return tr;
-}
-
 void bpf_trampoline_put(struct bpf_trampoline *tr)
 {
 	if (!tr)
@@ -567,12 +548,109 @@ void bpf_trampoline_put(struct bpf_trampoline *tr)
 	 * multiple rcu callbacks.
 	 */
 	hlist_del(&tr->hlist);
-	bpf_tramp_id_free(tr->id);
 	kfree(tr);
 out:
 	mutex_unlock(&trampoline_mutex);
 }
 
+static struct bpf_tramp_node *node_alloc(struct bpf_trampoline *tr, struct bpf_prog *prog)
+{
+	struct bpf_tramp_node *node;
+
+	node = kzalloc(sizeof(*node), GFP_KERNEL);
+	if (!node)
+		return NULL;
+
+	INIT_HLIST_NODE(&node->hlist_tramp);
+	INIT_HLIST_NODE(&node->hlist_attach);
+	node->prog = prog;
+	node->tr = tr;
+	return node;
+}
+
+static void node_free(struct bpf_tramp_node *node)
+{
+	bpf_trampoline_put(node->tr);
+	kfree(node);
+}
+
+struct bpf_tramp_attach *bpf_tramp_attach(struct bpf_tramp_id *id,
+					  struct bpf_prog *tgt_prog,
+					  struct bpf_prog *prog)
+{
+	struct bpf_trampoline *tr = NULL;
+	struct bpf_tramp_attach *attach;
+	struct bpf_tramp_node *node;
+	int err;
+
+	attach = kzalloc(sizeof(*attach), GFP_KERNEL);
+	if (!attach)
+		return ERR_PTR(-ENOMEM);
+
+	tr = bpf_trampoline_get(id);
+	if (!tr) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	node = node_alloc(tr, prog);
+	if (!node)
+		goto out;
+
+	err = bpf_check_attach_model(prog, tgt_prog, id->btf_id, &tr->func.model);
+	if (err)
+		goto out;
+
+	attach->id = id;
+	hlist_add_head(&node->hlist_attach, &attach->nodes);
+	return attach;
+
+out:
+	bpf_trampoline_put(tr);
+	kfree(attach);
+	return ERR_PTR(err);
+}
+
+void bpf_tramp_detach(struct bpf_tramp_attach *attach)
+{
+	struct bpf_tramp_node *node;
+	struct hlist_node *n;
+
+	hlist_for_each_entry_safe(node, n, &attach->nodes, hlist_attach)
+		node_free(node);
+
+	bpf_tramp_id_free(attach->id);
+	kfree(attach);
+}
+
+int bpf_tramp_attach_link(struct bpf_tramp_attach *attach)
+{
+	struct bpf_tramp_node *node;
+	int err;
+
+	hlist_for_each_entry(node, &attach->nodes, hlist_attach) {
+		err = bpf_trampoline_link_prog(node, node->tr);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+int bpf_tramp_attach_unlink(struct bpf_tramp_attach *attach)
+{
+	struct bpf_tramp_node *node;
+	int err;
+
+	hlist_for_each_entry(node, &attach->nodes, hlist_attach) {
+		err = bpf_trampoline_unlink_prog(node, node->tr);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
 #define NO_START_TIME 1
 static __always_inline u64 notrace bpf_prog_start_time(void)
 {
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index a1e4389b0e9e..e05f39fd2708 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -13928,7 +13928,7 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 	struct bpf_prog *tgt_prog = prog->aux->dst_prog;
 	struct bpf_attach_target_info tgt_info = {};
 	u32 btf_id = prog->aux->attach_btf_id;
-	struct bpf_trampoline *tr;
+	struct bpf_tramp_attach *attach;
 	struct bpf_tramp_id *id;
 	int ret;
 
@@ -14000,13 +14000,15 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 		return -ENOMEM;
 
 	bpf_tramp_id_init(id, tgt_prog, prog->aux->attach_btf, btf_id);
-	tr = bpf_trampoline_get(id, &tgt_info);
-	if (!tr) {
+	id->addr = (void *) tgt_info.tgt_addr;
+
+	attach = bpf_tramp_attach(id, tgt_prog, prog);
+	if (IS_ERR(attach)) {
 		bpf_tramp_id_free(id);
-		return -ENOMEM;
+		return PTR_ERR(attach);
 	}
 
-	prog->aux->dst_trampoline = tr;
+	prog->aux->dst_attach = attach;
 	return 0;
 }
 
-- 
2.31.1

