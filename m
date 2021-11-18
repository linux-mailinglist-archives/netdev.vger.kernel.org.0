Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B44C7455A4E
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 12:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344010AbhKRLb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 06:31:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:58932 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343683AbhKRL3y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 06:29:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637234814;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TOfVinV1OwrahdFosss8ebQPODUryvfBCcrymxnr+48=;
        b=RKp+ka902JSCl1FWj+WchQta33qycBMeGxN+y1SvoR5OWx8/l90m47n21BS66hgLSi+n69
        bqOQPxRAZFdFGAxHLKrt8CpRa2VNUKPzB4/RzL/qNzTl3FUBxwnAFunYVDNFKyLtDMBRZd
        0zE8+nZea4BRzbmuJ9HcspzMk5BIuLQ=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-281-lX_AMYJIPa65JCWiZ3uI2w-1; Thu, 18 Nov 2021 06:26:53 -0500
X-MC-Unique: lX_AMYJIPa65JCWiZ3uI2w-1
Received: by mail-ed1-f72.google.com with SMTP id b15-20020aa7c6cf000000b003e7cf0f73daso4942553eds.22
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 03:26:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TOfVinV1OwrahdFosss8ebQPODUryvfBCcrymxnr+48=;
        b=LVkZAblIxvLHIvvOEianMm1JIiKSroHnEkVgFywlCqGuqS/26ol8FK6I+dNlHn7aRi
         zKAAkU9573KQIYX+NdZ9dtj8tp6AFvu9xTXzFIrIs5M0jHOvreztBpRt8r5n8AILq1qB
         0BHTimXwM4YZ0YcSJb70GuHTi+AJZVtES5/BuJNtDNWdPqwKSyWKHQPz5BxzaoWWhcdj
         nY0rjPyNbYI9/KD0fgqkdXlxXwPNz4FMMMXAckl0SSy0hbYzx65FHBy/X9+vImbrpVBH
         TQFeXgADNk5qSICSMTgijff/Ri85n4syMAtnOiJmUy64LBtGreTwuCst9mF9hf3CSUVe
         AAtw==
X-Gm-Message-State: AOAM531keZsX9RNk80LY15ZRnQPCvOIueCNQIof7RweesXcxK7ckpsDD
        GNOVMZU1Sh70sj1NRy2ukuypNb76TsJ1hbXzjwLYO8wNNijpsLaH/nAWMV8pWNsIBQEpqPvzvNF
        ZCOCz1sTalQLuPnES
X-Received: by 2002:a05:6402:84a:: with SMTP id b10mr10356566edz.285.1637234811523;
        Thu, 18 Nov 2021 03:26:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxdhtrH0x0C1LuZPAcXgxWcJKClEgNx7h9ri68aOBwa0f7ej6zn7komo/FHcd/h2kPyI6qfSA==
X-Received: by 2002:a05:6402:84a:: with SMTP id b10mr10356500edz.285.1637234811081;
        Thu, 18 Nov 2021 03:26:51 -0800 (PST)
Received: from krava.redhat.com (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id y17sm170797edd.31.2021.11.18.03.26.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 03:26:50 -0800 (PST)
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
Subject: [PATCH bpf-next 19/29] bpf: Add support to attach trampolines with multiple IDs
Date:   Thu, 18 Nov 2021 12:24:45 +0100
Message-Id: <20211118112455.475349-20-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211118112455.475349-1-jolsa@kernel.org>
References: <20211118112455.475349-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding support to attach trampolines with multiple IDs.

This patch adds support to bpf_tramp_attach function to
attach given program to bpf_tramp_id object that holds
multiple BTF function IDs.

The process of attaching in bpf_tramp_attach is as follows:

  - IDs in bpf_tramp_id object are sorted out to several new
    bpf_tramp_id objects based on number of arguments of each
    ID - so we end up with up to 6 bpf_tramp_id objects, that
    we will create or find suitable trampoline for

  - separating function IDs that have same number of arguments
    save us troubles of handling different argument counts
    within one trampoline

  - now for each such bpf_tramp_id object we do following:

     * search existing trampolines to find match or intersection

     * if there's full match on IDs, we add program to existing
       trampoline and we are done

     * if there's intersection with existing trampoline,
       we split it and add new program to the common part,
       the rest of the IDs are attached to new trampoline

  - we keep trampoline_table as place holder for all trampolines,
    (while the has works only for single ID trampolines) so in case
    there is no multi-id trampoline defined, we still use the fast
    hash trampoline lookup

The bpf_tramp_attach assumes ID array is coming in sorted so it's
possible to run bsearch on it to do all the needed searches.

The splitting of the trampoline use the fact that we carry
'bpf_tramp_attach' object for each bpf_program, so when we split
trampoline that the program is attached to, we just add new
'bpf_tramp_node' object to the program's attach 'nodes'. This way
we keep track of all program's trampolines and it will be properly
detached when the program goes away.

The splitting of the trampoline is done with following steps:

   - lock the trampoline
   - unregister trampoline
   - alloc the duplicate, which means that for all attached programs
     of the original trampoline we create new bpf_tramp_node objects
     and add them to these programs' attach objects
   - then we assign new IDs (common and the rest) to both (original
     and the duplicated) trampolines
   - register both trampolines
   - unlock the original trampoline

This patch only adds bpf_tramp_attach support to attach multiple
ID bpf_tramp_id object. The actual user interface for that comes
in following patch.

Now when each call to bpf_tramp_attach can change any program's attach
object, we need to take trampoline_mutex in both bpf_tramp_attach_link
and bpf_tramp_attach_unlink functions. Perhaps we could add new lock
to bpf_tramp_attach object to get rid of single lock for all.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/bpf.h     |  12 +-
 kernel/bpf/trampoline.c | 717 +++++++++++++++++++++++++++++++++++++---
 2 files changed, 674 insertions(+), 55 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 04ada1d2495e..6ceb3bb39e1d 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -24,6 +24,13 @@
 #include <linux/percpu-refcount.h>
 #include <linux/bpfptr.h>
 #include <linux/refcount.h>
+#ifdef CONFIG_FUNCTION_TRACER
+#ifndef CC_USING_FENTRY
+#define CC_USING_FENTRY
+#endif
+#endif
+#include <linux/ftrace.h>
+#include <linux/types.h>
 
 struct bpf_verifier_env;
 struct bpf_verifier_log;
@@ -703,6 +710,9 @@ struct bpf_trampoline {
 	struct {
 		struct btf_func_model model;
 		bool ftrace_managed;
+#ifdef CONFIG_FUNCTION_TRACER
+		struct ftrace_ops ops;
+#endif
 	} func;
 	/* if !NULL this is BPF_PROG_TYPE_EXT program that extends another BPF
 	 * program by replacing one of its functions. id->addr is the address
@@ -763,7 +773,6 @@ struct bpf_tramp_id *bpf_tramp_id_single(const struct bpf_prog *tgt_prog,
 					 struct bpf_attach_target_info *tgt_info);
 int bpf_trampoline_link_prog(struct bpf_tramp_node *node, struct bpf_trampoline *tr);
 int bpf_trampoline_unlink_prog(struct bpf_tramp_node *node, struct bpf_trampoline *tr);
-void bpf_trampoline_put(struct bpf_trampoline *tr);
 
 struct bpf_tramp_attach *bpf_tramp_attach(struct bpf_tramp_id *id,
 					  struct bpf_prog *tgt_prog,
@@ -831,7 +840,6 @@ static inline struct bpf_trampoline *bpf_trampoline_get(struct bpf_tramp_id *id,
 {
 	return ERR_PTR(-EOPNOTSUPP);
 }
-static inline void bpf_trampoline_put(struct bpf_trampoline *tr) {}
 #define DEFINE_BPF_DISPATCHER(name)
 #define DECLARE_BPF_DISPATCHER(name)
 #define BPF_DISPATCHER_FUNC(name) bpf_dispatcher_nop_func
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 39600fb78c9e..7a9e3126e256 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -12,6 +12,8 @@
 #include <linux/module.h>
 #include <linux/static_call.h>
 #include <linux/bpf_verifier.h>
+#include <linux/bsearch.h>
+#include <linux/minmax.h>
 
 /* dummy _ops. The verifier will operate on target program's ops. */
 const struct bpf_verifier_ops bpf_extension_verifier_ops = {
@@ -24,8 +26,9 @@ const struct bpf_prog_ops bpf_extension_prog_ops = {
 #define TRAMPOLINE_TABLE_SIZE (1 << TRAMPOLINE_HASH_BITS)
 
 static struct hlist_head trampoline_table[TRAMPOLINE_TABLE_SIZE];
+static int nr_bpf_trampoline_multi;
 
-/* serializes access to trampoline_table */
+/* serializes access to trampoline_table, nr_bpf_trampoline_multi */
 static DEFINE_MUTEX(trampoline_mutex);
 
 void *bpf_jit_alloc_exec_page(void)
@@ -62,15 +65,12 @@ void bpf_image_ksym_del(struct bpf_ksym *ksym)
 
 static bool bpf_tramp_id_is_multi(struct bpf_tramp_id *id)
 {
-	return id->cnt > 1;
+	return id && id->cnt > 1;
 }
 
 static u64 bpf_tramp_id_key(struct bpf_tramp_id *id)
 {
-	if (bpf_tramp_id_is_multi(id))
-		return (u64) &id;
-	else
-		return ((u64) id->obj_id << 32) | id->id[0];
+	return ((u64) id->obj_id << 32) | id->id[0];
 }
 
 bool bpf_tramp_id_is_empty(struct bpf_tramp_id *id)
@@ -151,26 +151,14 @@ void bpf_tramp_id_put(struct bpf_tramp_id *id)
 	kfree(id);
 }
 
-static struct bpf_trampoline *bpf_trampoline_get(struct bpf_tramp_id *id)
+static void bpf_trampoline_init(struct bpf_trampoline *tr, struct bpf_tramp_id *id)
 {
-	struct bpf_trampoline *tr;
 	struct hlist_head *head;
 	u64 key;
 	int i;
 
 	key = bpf_tramp_id_key(id);
-	mutex_lock(&trampoline_mutex);
 	head = &trampoline_table[hash_64(key, TRAMPOLINE_HASH_BITS)];
-	hlist_for_each_entry(tr, head, hlist) {
-		if (bpf_tramp_id_is_equal(tr->id, id)) {
-			refcount_inc(&tr->refcnt);
-			goto out;
-		}
-	}
-	tr = kzalloc(sizeof(*tr), GFP_KERNEL);
-	if (!tr)
-		goto out;
-
 	tr->id = bpf_tramp_id_get(id);
 	INIT_HLIST_NODE(&tr->hlist);
 	hlist_add_head(&tr->hlist, head);
@@ -178,11 +166,39 @@ static struct bpf_trampoline *bpf_trampoline_get(struct bpf_tramp_id *id)
 	mutex_init(&tr->mutex);
 	for (i = 0; i < BPF_TRAMP_MAX; i++)
 		INIT_HLIST_HEAD(&tr->progs_hlist[i]);
-out:
-	mutex_unlock(&trampoline_mutex);
+	if (bpf_tramp_id_is_multi(id))
+		nr_bpf_trampoline_multi++;
+}
+
+static struct bpf_trampoline *bpf_trampoline_alloc(struct bpf_tramp_id *id)
+{
+	struct bpf_trampoline *tr;
+
+	tr = kzalloc(sizeof(*tr), GFP_KERNEL);
+	if (!tr)
+		return NULL;
+
+	bpf_trampoline_init(tr, id);
 	return tr;
 }
 
+static struct bpf_trampoline *bpf_trampoline_get(struct bpf_tramp_id *id)
+{
+	struct bpf_trampoline *tr;
+	struct hlist_head *head;
+	u64 key;
+
+	key = bpf_tramp_id_key(id);
+	head = &trampoline_table[hash_64(key, TRAMPOLINE_HASH_BITS)];
+	hlist_for_each_entry(tr, head, hlist) {
+		if (bpf_tramp_id_is_equal(tr->id, id)) {
+			refcount_inc(&tr->refcnt);
+			return tr;
+		}
+	}
+	return bpf_trampoline_alloc(id);
+}
+
 static int bpf_trampoline_module_get(struct bpf_trampoline *tr)
 {
 	struct module *mod;
@@ -220,6 +236,9 @@ static int unregister_fentry(struct bpf_trampoline *tr, void *old_addr)
 	void *ip = tr->id->addr[0];
 	int ret;
 
+	if (bpf_tramp_id_is_multi(tr->id))
+		return unregister_ftrace_direct_multi(&tr->func.ops, (long) old_addr);
+
 	if (tr->func.ftrace_managed)
 		ret = unregister_ftrace_direct((long)ip, (long)old_addr);
 	else
@@ -235,6 +254,9 @@ static int modify_fentry(struct bpf_trampoline *tr, void *old_addr, void *new_ad
 	void *ip = tr->id->addr[0];
 	int ret;
 
+	if (bpf_tramp_id_is_multi(tr->id))
+		return modify_ftrace_direct_multi(&tr->func.ops, (long) new_addr);
+
 	if (tr->func.ftrace_managed)
 		ret = modify_ftrace_direct((long)ip, (long)old_addr, (long)new_addr);
 	else
@@ -248,6 +270,9 @@ static int register_fentry(struct bpf_trampoline *tr, void *new_addr)
 	void *ip = tr->id->addr[0];
 	int ret;
 
+	if (bpf_tramp_id_is_multi(tr->id))
+		return register_ftrace_direct_multi(&tr->func.ops, (long) new_addr);
+
 	ret = is_ftrace_location(ip);
 	if (ret < 0)
 		return ret;
@@ -435,17 +460,19 @@ static int bpf_trampoline_update(struct bpf_trampoline *tr)
 	struct bpf_tramp_progs *tprogs;
 	u32 flags = BPF_TRAMP_F_RESTORE_REGS;
 	bool ip_arg = false;
-	int err, total;
+	int err = 0, total;
 
 	tprogs = bpf_trampoline_get_progs(tr, &total, &ip_arg);
 	if (IS_ERR(tprogs))
 		return PTR_ERR(tprogs);
 
 	if (total == 0) {
-		err = unregister_fentry(tr, tr->cur_image->image);
-		bpf_tramp_image_put(tr->cur_image);
-		tr->cur_image = NULL;
-		tr->selector = 0;
+		if (tr->cur_image) {
+			err = unregister_fentry(tr, tr->cur_image->image);
+			bpf_tramp_image_put(tr->cur_image);
+			tr->cur_image = NULL;
+			tr->selector = 0;
+		}
 		goto out;
 	}
 
@@ -456,8 +483,11 @@ static int bpf_trampoline_update(struct bpf_trampoline *tr)
 	}
 
 	if (tprogs[BPF_TRAMP_FEXIT].nr_progs ||
-	    tprogs[BPF_TRAMP_MODIFY_RETURN].nr_progs)
+	    tprogs[BPF_TRAMP_MODIFY_RETURN].nr_progs) {
 		flags = BPF_TRAMP_F_CALL_ORIG | BPF_TRAMP_F_SKIP_FRAME;
+		if (bpf_tramp_id_is_multi(tr->id))
+			flags |= BPF_TRAMP_F_ORIG_STACK;
+	}
 
 	if (ip_arg)
 		flags |= BPF_TRAMP_F_IP_ARG;
@@ -582,29 +612,29 @@ int bpf_trampoline_unlink_prog(struct bpf_tramp_node *node, struct bpf_trampolin
 	return err;
 }
 
-void bpf_trampoline_put(struct bpf_trampoline *tr)
+static void bpf_trampoline_put(struct bpf_trampoline *tr)
 {
 	if (!tr)
 		return;
-	mutex_lock(&trampoline_mutex);
 	if (!refcount_dec_and_test(&tr->refcnt))
-		goto out;
+		return;
 	WARN_ON_ONCE(mutex_is_locked(&tr->mutex));
 	if (WARN_ON_ONCE(!hlist_empty(&tr->progs_hlist[BPF_TRAMP_FENTRY])))
-		goto out;
+		return;
 	if (WARN_ON_ONCE(!hlist_empty(&tr->progs_hlist[BPF_TRAMP_FEXIT])))
-		goto out;
+		return;
 	/* This code will be executed even when the last bpf_tramp_image
 	 * is alive. All progs are detached from the trampoline and the
 	 * trampoline image is patched with jmp into epilogue to skip
 	 * fexit progs. The fentry-only trampoline will be freed via
 	 * multiple rcu callbacks.
 	 */
+	if (bpf_tramp_id_is_multi(tr->id))
+		nr_bpf_trampoline_multi--;
 	hlist_del(&tr->hlist);
 	bpf_tramp_id_put(tr->id);
+	ftrace_free_filter(&tr->func.ops);
 	kfree(tr);
-out:
-	mutex_unlock(&trampoline_mutex);
 }
 
 static struct bpf_tramp_node *node_alloc(struct bpf_trampoline *tr, struct bpf_prog *prog)
@@ -628,18 +658,442 @@ static void node_free(struct bpf_tramp_node *node)
 	kfree(node);
 }
 
-struct bpf_tramp_attach *bpf_tramp_attach(struct bpf_tramp_id *id,
-					  struct bpf_prog *tgt_prog,
-					  struct bpf_prog *prog)
+static void bpf_func_model_nargs(struct btf_func_model *m, int nr_args)
+{
+	int i;
+
+	for (i = 0; i < nr_args; i++)
+		m->arg_size[i] = 8;
+	m->ret_size = 8;
+	m->nr_args = nr_args;
+}
+
+struct attach_args {
+	int nr_args;
+	struct bpf_prog *tgt_prog;
+	struct bpf_prog *prog;
+};
+
+static int bpf_trampoline_setup(struct bpf_trampoline *tr,
+				struct attach_args *att)
+{
+	struct bpf_tramp_id *id = tr->id;
+
+	if (bpf_tramp_id_is_multi(id)) {
+		bpf_func_model_nargs(&tr->func.model, att->nr_args);
+		return ftrace_set_filter_ips(&tr->func.ops, (long*) id->addr,
+					     id->cnt, 0, 1);
+	} else {
+		return bpf_check_attach_model(att->prog, att->tgt_prog,
+					      id->id[0], &tr->func.model);
+	}
+}
+
+static int
+bpf_trampoline_create(struct bpf_tramp_attach *attach,
+		      struct bpf_tramp_id *id, struct attach_args *att)
 {
 	struct bpf_trampoline *tr = NULL;
-	struct bpf_tramp_attach *attach;
 	struct bpf_tramp_node *node;
 	int err;
 
-	attach = kzalloc(sizeof(*attach), GFP_KERNEL);
-	if (!attach)
-		return ERR_PTR(-ENOMEM);
+	tr = bpf_trampoline_alloc(id);
+	if (!tr) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	err = bpf_trampoline_setup(tr, att);
+	if (err)
+		goto out;
+
+	node = node_alloc(tr, att->prog);
+	if (!node) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	hlist_add_head(&node->hlist_attach, &attach->nodes);
+	return 0;
+
+out:
+	bpf_trampoline_put(tr);
+	return err;
+}
+
+static void bpf_trampoline_dup_destroy(struct bpf_trampoline *tr)
+{
+	struct bpf_tramp_node *node;
+	struct hlist_node *n;
+	int kind;
+
+	if (!tr)
+		return;
+
+	for (kind = 0; kind < BPF_TRAMP_MAX; kind++) {
+		hlist_for_each_entry_safe(node, n, &tr->progs_hlist[kind],
+					  hlist_tramp) {
+			hlist_del(&node->hlist_tramp);
+			hlist_del(&node->hlist_attach);
+			node_free(node);
+		}
+	}
+
+	WARN_ON_ONCE(refcount_read(&tr->refcnt) != 1);
+	bpf_trampoline_put(tr);
+}
+
+static struct bpf_trampoline*
+bpf_trampoline_dup(struct bpf_trampoline *tr, struct bpf_tramp_id *id)
+{
+	struct bpf_tramp_node *node, *iter;
+	struct bpf_trampoline *dup;
+	int kind;
+
+	/* Allocate new trampoline and duplicate all
+	* the program attachments it has.
+	*/
+	dup = bpf_trampoline_alloc(id);
+	if (!dup)
+		return NULL;
+
+	dup->refcnt = tr->refcnt;
+
+	for (kind = 0; kind < BPF_TRAMP_MAX; kind++) {
+		hlist_for_each_entry(iter, &tr->progs_hlist[kind], hlist_tramp) {
+			struct bpf_prog *prog = iter->prog;
+
+			node = node_alloc(dup, prog);
+			if (!node)
+				goto out_free;
+			hlist_add_head(&node->hlist_tramp, &dup->progs_hlist[kind]);
+			hlist_add_head(&node->hlist_attach, &prog->aux->attach->nodes);
+			dup->progs_cnt[kind]++;
+		}
+	}
+	return dup;
+
+out_free:
+	bpf_trampoline_dup_destroy(dup);
+	return NULL;
+}
+
+static int btf_id_cmp(const void *a, const void *b)
+{
+	const u32 *x = a;
+	const u32 *y = b;
+
+	if (*x == *y)
+		return 0;
+	return *x < *y ? -1 : 1;
+}
+
+static void id_add(struct bpf_tramp_id *id, u32 btf_id, void *addr)
+{
+	if (WARN_ON_ONCE(id->cnt >= id->max))
+		return;
+	id->id[id->cnt] = btf_id;
+	id->addr[id->cnt] = addr;
+	id->cnt++;
+}
+
+static struct bpf_tramp_id *id_check(struct bpf_tramp_id *id)
+{
+	if (bpf_tramp_id_is_empty(id)) {
+		bpf_tramp_id_put(id);
+		id = NULL;
+	}
+	return id;
+}
+
+static int id_and(struct bpf_tramp_id *a, struct bpf_tramp_id *b,
+		  struct bpf_tramp_id **pand, struct bpf_tramp_id **pother)
+{
+	struct bpf_tramp_id *and, *other;
+	u32 i, id;
+
+	and = bpf_tramp_id_alloc(min(a->cnt, b->cnt));
+	other = bpf_tramp_id_alloc(max(a->cnt, b->cnt));
+	if (!and || !other) {
+		bpf_tramp_id_put(and);
+		bpf_tramp_id_put(other);
+		return -ENOMEM;
+	}
+
+	and->obj_id = a->obj_id;
+	other->obj_id = a->obj_id;
+
+	for (i = 0; i < a->cnt; i++) {
+		id = a->id[i];
+		if (bsearch(&id, b->id, b->cnt, sizeof(u32), btf_id_cmp))
+			id_add(and, id, a->addr[i]);
+		else
+			id_add(other, id, a->addr[i]);
+	}
+
+	*pand = id_check(and);
+	*pother = id_check(other);
+	return 0;
+}
+
+static int id_sub(struct bpf_tramp_id *a, struct bpf_tramp_id *b,
+		  struct bpf_tramp_id **psub)
+{
+	struct bpf_tramp_id *sub;
+	u32 i, id;
+
+	sub = bpf_tramp_id_alloc(max(a->cnt, b->cnt));
+	if (!sub)
+		return -ENOMEM;
+
+	sub->obj_id = a->obj_id;
+
+	if (a->cnt < b->cnt)
+		swap(a, b);
+
+	for (i = 0; i < a->cnt; i++) {
+		id = a->id[i];
+		if (!bsearch(&id, b->id, b->cnt, sizeof(u32), btf_id_cmp))
+			id_add(sub, id, a->addr[i]);
+	}
+
+	*psub = id_check(sub);
+	return 0;
+}
+
+struct tramp_state {
+	struct bpf_trampoline *tr_common;
+	struct bpf_trampoline *tr_other;
+	struct bpf_tramp_id *id_common;
+	struct bpf_tramp_id *id_other;
+	struct bpf_tramp_id *id;
+};
+
+#define MAX_TRAMP_STATE 20
+
+struct attach_state {
+	struct tramp_state ts[MAX_TRAMP_STATE];
+	int cnt;
+};
+
+static struct tramp_state* tramp_state_get(struct attach_state *state)
+{
+	if (state->cnt == MAX_TRAMP_STATE)
+		return NULL;
+	return &state->ts[state->cnt];
+}
+
+static void state_next(struct attach_state *state)
+{
+	state->cnt++;
+}
+
+static void state_cleanup(struct attach_state *state)
+{
+	struct tramp_state *ts;
+	int i;
+
+	for (i = 0; i < state->cnt; i++) {
+		ts = &state->ts[state->cnt];
+		bpf_tramp_id_put(ts->id_common);
+		bpf_tramp_id_put(ts->id_other);
+		bpf_tramp_id_put(ts->id);
+	}
+}
+
+static int tramp_state_compute(struct attach_state *state,
+			       struct bpf_trampoline *tr,
+			       struct bpf_tramp_id *id,
+			       struct bpf_tramp_id **id_cont)
+{
+	struct bpf_tramp_id *id_new, *id_common, *id_other;
+	struct tramp_state *ts;
+
+	ts = tramp_state_get(state);
+	if (!ts)
+		return -EBUSY;
+
+	/* different playground.. bail out */
+	if (tr->id->obj_id != id->obj_id) {
+		*id_cont = bpf_tramp_id_get(id);
+		return 0;
+	}
+
+	/* complete match with trampoline */
+	if (bpf_tramp_id_is_equal(tr->id, id)) {
+		ts->id_common = bpf_tramp_id_get(id);
+		*id_cont = NULL;
+		goto out;
+	}
+
+	/* find out if there's common set of ids */
+	if (id_and(id, tr->id, &id_common, &id_new))
+		return -ENOMEM;
+
+	/* nothing in common, bail out */
+	if (!id_common) {
+		bpf_tramp_id_put(id_new);
+		*id_cont = bpf_tramp_id_get(id);
+		return 0;
+	}
+
+	/* we have common set, let's get the rest of the matched
+	 * trampoline ids as new id for split trampoline
+	 */
+	if (id_sub(id_common, tr->id, &id_other)) {
+		bpf_tramp_id_put(id_common);
+		bpf_tramp_id_put(id_new);
+		return -ENOMEM;
+	}
+
+	ts->id_common = id_common;
+	ts->id_other = id_other;
+	ts->id = bpf_tramp_id_get(tr->id);
+	*id_cont = id_new;
+
+out:
+	ts->tr_common = tr;
+	state_next(state);
+	return 0;
+}
+
+static int bpf_trampoline_register(struct bpf_trampoline *tr)
+{
+	return bpf_trampoline_update(tr);
+}
+
+static int bpf_trampoline_unregister(struct bpf_trampoline *tr)
+{
+	int err;
+
+	if (!tr->cur_image)
+		return 0;
+	err = unregister_fentry(tr, tr->cur_image->image);
+	bpf_tramp_image_put(tr->cur_image);
+	tr->cur_image = NULL;
+	tr->selector = 0;
+	return err;
+}
+
+static void bpf_trampoline_id_assign(struct bpf_trampoline *tr, struct bpf_tramp_id *id)
+{
+	bool multi1 = bpf_tramp_id_is_multi(tr->id);
+	bool multi2 = bpf_tramp_id_is_multi(id);
+
+	/* We can split into single ID trampolines and that
+	 * might affect nr_bpf_trampoline_multi and the fast
+	 * path trigger, so we need to check on that.
+	 */
+	if (multi1 && !multi2)
+		nr_bpf_trampoline_multi--;
+	if (!multi1 && multi2)
+		nr_bpf_trampoline_multi++;
+
+	tr->id = id;
+}
+
+static int bpf_trampoline_split(struct tramp_state *ts, struct attach_args *att)
+{
+	struct bpf_trampoline *tr_other, *tr_common = ts->tr_common;
+	struct bpf_tramp_id *id_common = ts->id_common;
+	struct bpf_tramp_id *id_other = ts->id_other;
+	int err;
+
+	mutex_lock(&tr_common->mutex);
+
+	err = bpf_trampoline_unregister(tr_common);
+	if (err)
+		goto out;
+
+	tr_other = bpf_trampoline_dup(tr_common, id_other);
+	if (!tr_other) {
+		err = -ENOMEM;
+		goto out_free;
+	}
+
+	err = bpf_trampoline_setup(tr_other, att);
+	if (err)
+		goto out_free;
+
+	bpf_trampoline_id_assign(tr_common, id_common);
+
+	err = bpf_trampoline_setup(tr_common, att);
+	if (err)
+		goto out_free;
+
+	ts->tr_other = tr_other;
+	WARN_ON_ONCE(bpf_trampoline_register(tr_common));
+	WARN_ON_ONCE(bpf_trampoline_register(tr_other));
+
+	mutex_unlock(&tr_common->mutex);
+	return 0;
+
+out_free:
+	bpf_trampoline_dup_destroy(tr_other);
+	tr_common->id = ts->id;
+	WARN_ON_ONCE(bpf_trampoline_register(tr_common));
+out:
+	mutex_unlock(&tr_common->mutex);
+	return err;
+}
+
+static int tramp_state_apply(struct bpf_tramp_attach *attach,
+			     struct tramp_state *ts, struct attach_args *att)
+{
+	struct bpf_tramp_node *node;
+	int err;
+
+	/* The program will be attached to the common part. */
+	node = node_alloc(ts->tr_common, att->prog);
+	if (!node)
+		return -ENOMEM;
+
+	refcount_inc(&ts->tr_common->refcnt);
+
+	/* If there are also 'other' IDs in the trampoline,
+	 * we need to do the split. */
+	if (ts->id_other) {
+		err = bpf_trampoline_split(ts, att);
+		if (err) {
+			node_free(node);
+			return err;
+		}
+	}
+
+	hlist_add_head(&node->hlist_attach, &attach->nodes);
+	return 0;
+}
+
+static int tramp_state_revert(struct tramp_state *ts, struct attach_args *att)
+{
+	struct bpf_trampoline *tr_common = ts->tr_common;
+	int err;
+
+	bpf_trampoline_dup_destroy(ts->tr_other);
+
+	mutex_lock(&tr_common->mutex);
+	err = bpf_trampoline_unregister(tr_common);
+	if (err)
+		goto out;
+
+	tr_common->id = ts->id;
+	err = bpf_trampoline_setup(tr_common, att);
+	if (err)
+		goto out;
+
+	WARN_ON_ONCE(bpf_trampoline_register(tr_common));
+out:
+	mutex_unlock(&tr_common->mutex);
+	return err;
+}
+
+static int
+bpf_tramp_attach_single(struct bpf_tramp_attach *attach,
+			struct bpf_tramp_id *id, struct attach_args *att)
+{
+	struct bpf_trampoline *tr = NULL;
+	struct bpf_tramp_node *node;
+	int err;
 
 	tr = bpf_trampoline_get(id);
 	if (!tr) {
@@ -647,22 +1101,175 @@ struct bpf_tramp_attach *bpf_tramp_attach(struct bpf_tramp_id *id,
 		goto out;
 	}
 
-	node = node_alloc(tr, prog);
+	node = node_alloc(tr, att->prog);
 	if (!node)
 		goto out;
 
-	err = bpf_check_attach_model(prog, tgt_prog, id->id[0], &tr->func.model);
+	err = bpf_check_attach_model(att->prog, att->tgt_prog,
+				     id->id[0], &tr->func.model);
 	if (err)
 		goto out;
 
-	attach->id = id;
 	hlist_add_head(&node->hlist_attach, &attach->nodes);
-	return attach;
+	return 0;
 
 out:
 	bpf_trampoline_put(tr);
-	kfree(attach);
-	return ERR_PTR(err);
+	return err;
+}
+
+#define list_for_each_trampoline(tr, i)					\
+	for (i = 0; i < TRAMPOLINE_TABLE_SIZE; i++)			\
+		hlist_for_each_entry(tr, &trampoline_table[i], hlist)
+
+static int __bpf_tramp_attach(struct bpf_tramp_attach *attach,
+			      struct bpf_tramp_id *id,
+			      struct attach_args *att)
+{
+	struct attach_state state = {};
+	struct bpf_tramp_id *id_cont;
+	struct bpf_trampoline *tr;
+	bool id_put = false;
+	int err = 0, i, j;
+
+	mutex_lock(&trampoline_mutex);
+
+	/* If we are ataching single ID trampoline and there's no multi ID
+	 * trampoline registered, there's no need to iterate all trampolines
+	 * for intersection, we can do the fast path and use hash search.
+	 * */
+	if (!bpf_tramp_id_is_multi(id) && !nr_bpf_trampoline_multi) {
+		err = bpf_tramp_attach_single(attach, id, att);
+		goto out;
+	}
+
+	/* Iterate all trampolines to find all the interesections. */
+	list_for_each_trampoline(tr, i) {
+		err = tramp_state_compute(&state, tr, id, &id_cont);
+		if (err)
+			goto out_multi;
+		id_put = true;
+		id = id_cont;
+		if (!id)
+			goto out_break;
+	}
+out_break:
+
+	/* Do the actuall trampoline splits if there's any .. */
+	for (i = 0; i < state.cnt; i++) {
+		err = tramp_state_apply(attach, &state.ts[i], att);
+		if (err)
+			goto revert;
+	}
+
+	/* .. and create new trampoline if needed. */
+	if (id)
+		err = bpf_trampoline_create(attach, id, att);
+
+revert:
+	/* Attach failed, let's revert already changed trampolines */
+	if (err) {
+		for (j = 0; j < i; j++)
+			WARN_ON_ONCE(tramp_state_revert(&state.ts[j], att));
+	}
+
+out_multi:
+	if (id_put)
+		bpf_tramp_id_put(id);
+out:
+	mutex_unlock(&trampoline_mutex);
+	state_cleanup(&state);
+	return err;
+}
+
+#define MAX_ARGS 7
+
+static void put_args(struct bpf_tramp_id **args)
+{
+	int i;
+
+	for (i = 0; i < MAX_ARGS; i++)
+		bpf_tramp_id_put(args[i]);
+}
+
+static int get_args(struct bpf_tramp_id *id, struct bpf_tramp_id **args,
+		    struct bpf_prog *tgt_prog, struct bpf_prog *prog)
+{
+	const struct btf_type *t;
+	struct bpf_tramp_id *a;
+	const struct btf *btf;
+	int err = -EINVAL;
+	u32 i, nargs;
+
+	btf = tgt_prog ? tgt_prog->aux->btf : prog->aux->attach_btf;
+	if (!btf)
+		return -EINVAL;
+
+	for (i = 0; i < id->cnt; i++){
+		t = btf_type_by_id(btf, id->id[i]);
+		if (!btf_type_is_func(t))
+			goto out_free;
+		t = btf_type_by_id(btf, t->type);
+		if (!btf_type_is_func_proto(t))
+			goto out_free;
+		nargs = btf_type_vlen(t);
+		if (nargs >= MAX_ARGS)
+			goto out_free;
+		a = args[nargs];
+		if (!a) {
+			a = bpf_tramp_id_alloc(id->cnt);
+			if (!a) {
+				err = -ENOMEM;
+				goto out_free;
+			}
+			a->obj_id = id->obj_id;
+			args[nargs] = a;
+		}
+		id_add(a, id->id[i], id->addr[i]);
+	}
+	err = 0;
+out_free:
+	if (err)
+		put_args(args);
+	return err;
+}
+
+struct bpf_tramp_attach *bpf_tramp_attach(struct bpf_tramp_id *id,
+					  struct bpf_prog *tgt_prog,
+					  struct bpf_prog *prog)
+{
+	struct bpf_tramp_id *args[MAX_ARGS] = {};
+	struct bpf_tramp_attach *attach;
+	struct attach_args att = {
+		.tgt_prog = tgt_prog,
+		.prog = prog,
+	};
+	int i, err;
+
+	err = get_args(id, args, tgt_prog, prog);
+	if (err)
+		return ERR_PTR(err);
+
+	attach = kzalloc(sizeof(*attach), GFP_KERNEL);
+	if (!attach)
+		return ERR_PTR(-ENOMEM);
+
+	for (i = 0; i < MAX_ARGS; i++) {
+		if (!args[i] || !args[i]->cnt)
+			continue;
+		att.nr_args = i;
+		err = __bpf_tramp_attach(attach, args[i], &att);
+		if (err)
+			break;
+	}
+
+	if (err)
+		bpf_tramp_detach(attach);
+	else
+		attach->id = id;
+
+	put_args(args);
+	return err ? ERR_PTR(err) : attach;
 }
 
 void bpf_tramp_detach(struct bpf_tramp_attach *attach)
@@ -670,8 +1277,10 @@ void bpf_tramp_detach(struct bpf_tramp_attach *attach)
 	struct bpf_tramp_node *node;
 	struct hlist_node *n;
 
+	mutex_lock(&trampoline_mutex);
 	hlist_for_each_entry_safe(node, n, &attach->nodes, hlist_attach)
 		node_free(node);
+	mutex_unlock(&trampoline_mutex);
 
 	bpf_tramp_id_put(attach->id);
 	kfree(attach);
@@ -682,13 +1291,14 @@ int bpf_tramp_attach_link(struct bpf_tramp_attach *attach)
 	struct bpf_tramp_node *node;
 	int err;
 
+	mutex_lock(&trampoline_mutex);
 	hlist_for_each_entry(node, &attach->nodes, hlist_attach) {
 		err = bpf_trampoline_link_prog(node, node->tr);
 		if (err)
-			return err;
+			break;
 	}
-
-	return 0;
+	mutex_unlock(&trampoline_mutex);
+	return err;
 }
 
 int bpf_tramp_attach_unlink(struct bpf_tramp_attach *attach)
@@ -696,13 +1306,14 @@ int bpf_tramp_attach_unlink(struct bpf_tramp_attach *attach)
 	struct bpf_tramp_node *node;
 	int err;
 
+	mutex_lock(&trampoline_mutex);
 	hlist_for_each_entry(node, &attach->nodes, hlist_attach) {
 		err = bpf_trampoline_unlink_prog(node, node->tr);
 		if (err)
-			return err;
+			break;
 	}
-
-	return 0;
+	mutex_unlock(&trampoline_mutex);
+	return err;
 }
 
 #define NO_START_TIME 1
-- 
2.31.1

