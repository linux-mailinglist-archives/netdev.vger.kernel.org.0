Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50D803F8EF9
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 21:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243603AbhHZTmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 15:42:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40104 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243607AbhHZTmA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 15:42:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630006872;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k7Y1Ok4cyox0DsYgmFPhX/i9rcG3AZ5Q61TPBm3wVYA=;
        b=bGk3jkt8mcTUrsG/oL/7yHE0xkKK9P1/wjvKMEOZKmNmluwDvQCNkkKZhmsxwCndTslaD+
        qOdOqkBLG8I1hp8l20FyF8d0/U27DHne4TIvh8OcYBFELxxai5wZmWl1Tq/99cm1jzKlMK
        1SgvBb1Fu9mUI02BGkwRTUcDO8aCBDs=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-508-9FLyMrY9PDa_1dKXRNRNQA-1; Thu, 26 Aug 2021 15:41:11 -0400
X-MC-Unique: 9FLyMrY9PDa_1dKXRNRNQA-1
Received: by mail-wr1-f69.google.com with SMTP id h14-20020a056000000e00b001575b00eb08so1184837wrx.13
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 12:41:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k7Y1Ok4cyox0DsYgmFPhX/i9rcG3AZ5Q61TPBm3wVYA=;
        b=hOXpr/wK3QICC6l05pSYppLYe3iOaQy0Ub7JFaQJ2Cr4ADAfuRQt5uXr+W4f/jVagP
         LHbfQaHwWXyv+iyyisQOrAGywanaFrdH9LvIB2AX5S0CIiWKYK9LIkiotpxnj4Lj2wJQ
         FM3ckVMRU2pKJj7uK9LFPy+U2IzJ5sde4gQ3wRtD7Yuu3n6H1GRp3S+7zFNJVIAg61LW
         8K4cPNBP35hko2yP1GXz9LhURpirhIMrqE4ih34k8IiXn4ULukCtdfgXlPoifr0y55Gu
         xCdBR8PoEbecrEqanXFWkd5KhwJj5A60Wm6zYtGvDSShmrj9Ag5o3sFaJ+JmbSJvGpTm
         fcEg==
X-Gm-Message-State: AOAM5303sclmSTv+H/JhCv1+c544e2w6I2IsWJxwHs9ApqqNpgLHniPW
        5d+RJuYxwx9L/sNLA7Gdqe1LFQ/h9XvwdSqvNr0lCWJsv/ygSZIuk3FfVK9RbkVE9yPeYBWTNnx
        zMri/uaIt+YUw0RIF
X-Received: by 2002:adf:fb8f:: with SMTP id a15mr6055948wrr.92.1630006869551;
        Thu, 26 Aug 2021 12:41:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJykopySwjKrdyJqFYHgjK0fph8uXk7OdmrjR6/62gjo9cD7ouKp4mlKRx/OXYmQv49Cpaib6w==
X-Received: by 2002:adf:fb8f:: with SMTP id a15mr6055922wrr.92.1630006869317;
        Thu, 26 Aug 2021 12:41:09 -0700 (PDT)
Received: from krava.redhat.com ([83.240.63.86])
        by smtp.gmail.com with ESMTPSA id p9sm9445594wmq.40.2021.08.26.12.41.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 12:41:09 -0700 (PDT)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
Subject: [PATCH bpf-next v4 17/27] bpf: Add multi trampoline attach support
Date:   Thu, 26 Aug 2021 21:39:12 +0200
Message-Id: <20210826193922.66204-18-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210826193922.66204-1-jolsa@kernel.org>
References: <20210826193922.66204-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding new multi trampoline link (BPF_LINK_TYPE_TRACING_MULTI)
as an interface to attach program to multiple functions.

The link_create bpf_attr interface already has 'bpf_prog' file
descriptor, that defines the program to be attached. It must be
loaded with BPF_F_MULTI_FUNC flag.

Adding new multi_btf_ids/multi_btf_ids_cnt link_create bpf_attr
fields that provides BTF ids.

The new link gets multi trampoline (via bpf_trampoline_multi_get)
and links the provided program with embedded trampolines and the
'main' trampoline with new multi link/unlink functions:

  int bpf_trampoline_multi_link_prog(struct bpf_prog *prog,
                                     struct bpf_trampoline_multi *tr);
  int bpf_trampoline_multi_unlink_prog(struct bpf_prog *prog,
                                       struct bpf_trampoline_multi *tr);

If embedded trampoline contains fexit programs, we need to switch
its model to the multi trampoline model (because of the final 'ret'
argument). We keep the count of attached multi func programs for each
trampoline, so we can tell when to switch the model.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/bpf.h            |   5 ++
 include/uapi/linux/bpf.h       |   5 ++
 kernel/bpf/core.c              |   1 +
 kernel/bpf/syscall.c           | 120 +++++++++++++++++++++++++++++++++
 kernel/bpf/trampoline.c        |  87 ++++++++++++++++++++++--
 tools/include/uapi/linux/bpf.h |   5 ++
 6 files changed, 219 insertions(+), 4 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 678b9cd2fa21..3ce4656e2057 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -693,6 +693,7 @@ struct bpf_trampoline {
 	struct module *mod;
 	struct {
 		struct bpf_trampoline *tr;
+		int count;
 	} multi;
 };
 
@@ -747,6 +748,8 @@ void bpf_trampoline_put(struct bpf_trampoline *tr);
 struct bpf_trampoline_multi *bpf_trampoline_multi_get(struct bpf_prog *prog, u32 *ids,
 						      u32 ids_cnt);
 void bpf_trampoline_multi_put(struct bpf_trampoline_multi *multi);
+int bpf_trampoline_multi_link_prog(struct bpf_prog *prog, struct bpf_trampoline_multi *tr);
+int bpf_trampoline_multi_unlink_prog(struct bpf_prog *prog, struct bpf_trampoline_multi *tr);
 #define BPF_DISPATCHER_INIT(_name) {				\
 	.mutex = __MUTEX_INITIALIZER(_name.mutex),		\
 	.func = &_name##_func,					\
@@ -892,6 +895,8 @@ struct bpf_prog_aux {
 	bool tail_call_reachable;
 	bool multi_func;
 	struct bpf_tramp_node tramp_node;
+	struct bpf_tramp_node *multi_node;
+	struct mutex multi_node_mutex;
 	/* BTF_KIND_FUNC_PROTO for valid attach_btf_id */
 	const struct btf_type *attach_func_proto;
 	/* function name for valid attach_btf_id */
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 1f9d336861f0..9533200ffadf 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1008,6 +1008,7 @@ enum bpf_link_type {
 	BPF_LINK_TYPE_NETNS = 5,
 	BPF_LINK_TYPE_XDP = 6,
 	BPF_LINK_TYPE_PERF_EVENT = 7,
+	BPF_LINK_TYPE_TRACING_MULTI = 8,
 
 	MAX_BPF_LINK_TYPE,
 };
@@ -1462,6 +1463,10 @@ union bpf_attr {
 				 */
 				__u64		bpf_cookie;
 			} perf_event;
+			struct {
+				__aligned_u64	multi_btf_ids;		/* addresses to attach */
+				__u32		multi_btf_ids_cnt;	/* addresses count */
+			};
 		};
 	} link_create;
 
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index bad03dde97a2..6c16ac43dd91 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -109,6 +109,7 @@ struct bpf_prog *bpf_prog_alloc_no_stats(unsigned int size, gfp_t gfp_extra_flag
 	INIT_LIST_HEAD_RCU(&fp->aux->ksym.lnode);
 	mutex_init(&fp->aux->used_maps_mutex);
 	mutex_init(&fp->aux->dst_mutex);
+	mutex_init(&fp->aux->multi_node_mutex);
 
 	return fp;
 }
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 537687664bdf..8f1f934a8f26 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -32,6 +32,7 @@
 #include <linux/rcupdate_trace.h>
 #include <linux/memcontrol.h>
 #include <linux/btf_ids.h>
+#include <linux/ftrace.h>
 
 #define IS_FD_ARRAY(map) ((map)->map_type == BPF_MAP_TYPE_PERF_EVENT_ARRAY || \
 			  (map)->map_type == BPF_MAP_TYPE_CGROUP_ARRAY || \
@@ -2851,6 +2852,121 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog,
 	return err;
 }
 
+struct bpf_tracing_multi_link {
+	struct bpf_link link;
+	enum bpf_attach_type attach_type;
+	struct bpf_trampoline_multi *multi;
+};
+
+static void bpf_tracing_multi_link_release(struct bpf_link *link)
+{
+	struct bpf_tracing_multi_link *tr_link =
+		container_of(link, struct bpf_tracing_multi_link, link);
+
+	bpf_trampoline_multi_unlink_prog(link->prog, tr_link->multi);
+}
+
+static void bpf_tracing_multi_link_dealloc(struct bpf_link *link)
+{
+	struct bpf_tracing_multi_link *tr_link =
+		container_of(link, struct bpf_tracing_multi_link, link);
+
+	bpf_trampoline_multi_put(tr_link->multi);
+	kfree(tr_link);
+}
+
+static void bpf_tracing_multi_link_show_fdinfo(const struct bpf_link *link,
+					       struct seq_file *seq)
+{
+	struct bpf_tracing_multi_link *tr_link =
+		container_of(link, struct bpf_tracing_multi_link, link);
+
+	seq_printf(seq, "attach_type:\t%d\n", tr_link->attach_type);
+}
+
+static int bpf_tracing_multi_link_fill_link_info(const struct bpf_link *link,
+						 struct bpf_link_info *info)
+{
+	struct bpf_tracing_multi_link *tr_link =
+		container_of(link, struct bpf_tracing_multi_link, link);
+
+	info->tracing.attach_type = tr_link->attach_type;
+	return 0;
+}
+
+static int check_multi_prog_type(struct bpf_prog *prog)
+{
+	if (prog->expected_attach_type != BPF_TRACE_FENTRY &&
+	    prog->expected_attach_type != BPF_TRACE_FEXIT)
+		return -EINVAL;
+	return 0;
+}
+
+static const struct bpf_link_ops bpf_tracing_multi_link_lops = {
+	.release = bpf_tracing_multi_link_release,
+	.dealloc = bpf_tracing_multi_link_dealloc,
+	.show_fdinfo = bpf_tracing_multi_link_show_fdinfo,
+	.fill_link_info = bpf_tracing_multi_link_fill_link_info,
+};
+
+static int bpf_tracing_multi_attach(struct bpf_prog *prog,
+				    const union bpf_attr *attr)
+{
+	void __user *ubtf_ids = u64_to_user_ptr(attr->link_create.multi_btf_ids);
+	u32 size, cnt = attr->link_create.multi_btf_ids_cnt;
+	struct bpf_tracing_multi_link *link = NULL;
+	struct bpf_link_primer link_primer;
+	struct bpf_trampoline_multi *multi = NULL;
+	int err = -EINVAL;
+	u32 *btf_ids;
+
+	if (check_multi_prog_type(prog))
+		return -EINVAL;
+	if (!cnt)
+		return -EINVAL;
+
+	size = cnt * sizeof(*btf_ids);
+	btf_ids = kmalloc(size, GFP_USER | __GFP_NOWARN);
+	if (!btf_ids)
+		return -ENOMEM;
+
+	err = -EFAULT;
+	if (ubtf_ids && copy_from_user(btf_ids, ubtf_ids, size))
+		goto out_free_ids;
+
+	multi = bpf_trampoline_multi_get(prog, btf_ids, cnt);
+	if (IS_ERR(multi)) {
+		err = PTR_ERR(multi);
+		goto out_free_ids;
+	}
+
+	link = kzalloc(sizeof(*link), GFP_USER);
+	if (!link) {
+		err = -ENOMEM;
+		goto out_free;
+	}
+
+	bpf_link_init(&link->link, BPF_LINK_TYPE_TRACING_MULTI,
+		      &bpf_tracing_multi_link_lops, prog);
+	link->attach_type = prog->expected_attach_type;
+	link->multi = multi;
+
+	err = bpf_link_prime(&link->link, &link_primer);
+	if (err)
+		goto out_free;
+	err = bpf_trampoline_multi_link_prog(prog, multi);
+	if (err)
+		goto out_free;
+	return bpf_link_settle(&link_primer);
+
+out_free:
+	bpf_trampoline_multi_put(multi);
+	kfree(link);
+out_free_ids:
+	kfree(btf_ids);
+	return err;
+}
+
 struct bpf_raw_tp_link {
 	struct bpf_link link;
 	struct bpf_raw_event_map *btp;
@@ -3157,6 +3273,8 @@ attach_type_to_prog_type(enum bpf_attach_type attach_type)
 	case BPF_CGROUP_SETSOCKOPT:
 		return BPF_PROG_TYPE_CGROUP_SOCKOPT;
 	case BPF_TRACE_ITER:
+	case BPF_TRACE_FENTRY:
+	case BPF_TRACE_FEXIT:
 		return BPF_PROG_TYPE_TRACING;
 	case BPF_SK_LOOKUP:
 		return BPF_PROG_TYPE_SK_LOOKUP;
@@ -4213,6 +4331,8 @@ static int tracing_bpf_link_attach(const union bpf_attr *attr, bpfptr_t uattr,
 
 	if (prog->expected_attach_type == BPF_TRACE_ITER)
 		return bpf_iter_link_attach(attr, uattr, prog);
+	else if (prog->aux->multi_func)
+		return bpf_tracing_multi_attach(prog, attr);
 	else if (prog->type == BPF_PROG_TYPE_EXT)
 		return bpf_tracing_prog_attach(prog,
 					       attr->link_create.target_fd,
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index d66b76c23d74..6ff5c2512f91 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -30,6 +30,11 @@ static LIST_HEAD(trampoline_multi);
 /* serializes access to trampoline_table */
 static DEFINE_MUTEX(trampoline_mutex);
 
+static bool is_multi_trampoline(struct bpf_trampoline *tr)
+{
+	return tr->key == 0;
+}
+
 void *bpf_jit_alloc_exec_page(void)
 {
 	void *image;
@@ -384,8 +389,21 @@ static struct bpf_tramp_image *bpf_tramp_image_alloc(u64 key, u32 idx)
 	return ERR_PTR(err);
 }
 
+static bool needs_multi_model(struct bpf_trampoline *tr, struct btf_func_model *new)
+{
+	struct bpf_trampoline *multi = tr->multi.tr;
+
+	if (!tr->multi.count || !multi)
+		return false;
+	if (tr->func.model.nr_args >= multi->func.model.nr_args)
+		return false;
+	memcpy(new, &multi->func.model, sizeof(*new));
+	return true;
+}
+
 static int bpf_trampoline_update(struct bpf_trampoline *tr)
 {
+	struct btf_func_model model_multi, *model = &tr->func.model;
 	struct bpf_tramp_image *im;
 	struct bpf_tramp_progs *tprogs;
 	u32 flags = BPF_TRAMP_F_RESTORE_REGS;
@@ -411,15 +429,19 @@ static int bpf_trampoline_update(struct bpf_trampoline *tr)
 	}
 
 	if (tprogs[BPF_TRAMP_FEXIT].nr_progs ||
-	    tprogs[BPF_TRAMP_MODIFY_RETURN].nr_progs)
+	    tprogs[BPF_TRAMP_MODIFY_RETURN].nr_progs) {
 		flags = BPF_TRAMP_F_CALL_ORIG | BPF_TRAMP_F_SKIP_FRAME;
+		if (is_multi_trampoline(tr))
+			flags |= BPF_TRAMP_F_ORIG_STACK;
+		if (needs_multi_model(tr, &model_multi))
+			model = &model_multi;
+	}
 
 	if (ip_arg)
 		flags |= BPF_TRAMP_F_IP_ARG;
 
 	err = arch_prepare_bpf_trampoline(im, im->image, im->image + PAGE_SIZE,
-					  &tr->func.model, flags, tprogs,
-					  tr->func.addr);
+					  model, flags, tprogs, tr->func.addr);
 	if (err < 0)
 		goto out;
 
@@ -507,7 +529,8 @@ int bpf_trampoline_link_prog(struct bpf_tramp_node *node, struct bpf_trampoline
 	if (err) {
 		hlist_del_init(&node->hlist);
 		tr->progs_cnt[kind]--;
-	}
+	} else if (prog->aux->multi_func)
+		tr->multi.count++;
 out:
 	mutex_unlock(&tr->mutex);
 	return err;
@@ -531,6 +554,8 @@ int bpf_trampoline_unlink_prog(struct bpf_tramp_node *node, struct bpf_trampolin
 	}
 	hlist_del_init(&node->hlist);
 	tr->progs_cnt[kind]--;
+	if (prog->aux->multi_func)
+		tr->multi.count--;
 	err = bpf_trampoline_update(tr);
 out:
 	mutex_unlock(&tr->mutex);
@@ -732,6 +757,60 @@ void bpf_trampoline_multi_put(struct bpf_trampoline_multi *multi)
 	mutex_unlock(&trampoline_mutex);
 }
 
+int bpf_trampoline_multi_link_prog(struct bpf_prog *prog, struct bpf_trampoline_multi *multi)
+{
+	struct bpf_tramp_node *multi_node = NULL;
+	int i, j, err = 0;
+
+	multi_node = kzalloc(sizeof(*multi_node) * multi->tr_cnt, GFP_KERNEL);
+	if (!multi_node)
+		return -ENOMEM;
+
+	mutex_lock(&prog->aux->multi_node_mutex);
+	if (prog->aux->multi_node)
+		err = -EBUSY;
+	else
+		prog->aux->multi_node = multi_node;
+	mutex_unlock(&prog->aux->multi_node_mutex);
+	if (err)
+		goto out_free;
+
+	for (i = 0; i < multi->tr_cnt; i++) {
+		multi_node[i].prog = prog;
+		err = bpf_trampoline_link_prog(&multi_node[i], multi->tr[i]);
+		if (err)
+			goto out_unlink;
+	}
+
+	err = bpf_trampoline_link_prog(&prog->aux->tramp_node, &multi->main);
+	if (!err)
+		return 0;
+
+out_unlink:
+	for (j = 0; j < i; j++)
+		WARN_ON_ONCE(bpf_trampoline_unlink_prog(&multi_node[j], multi->tr[j]));
+
+out_free:
+	kfree(multi_node);
+	return err;
+}
+
+int bpf_trampoline_multi_unlink_prog(struct bpf_prog *prog, struct bpf_trampoline_multi *multi)
+{
+	struct bpf_tramp_node *multi_node = prog->aux->multi_node;
+	int i;
+
+	for (i = 0; i < multi->tr_cnt; i++)
+		WARN_ON_ONCE(bpf_trampoline_unlink_prog(&multi_node[i], multi->tr[i]));
+
+	mutex_lock(&prog->aux->multi_node_mutex);
+	prog->aux->multi_node = NULL;
+	mutex_unlock(&prog->aux->multi_node_mutex);
+
+	kfree(multi_node);
+	return bpf_trampoline_unlink_prog(&prog->aux->tramp_node, &multi->main);
+}
+
 #define NO_START_TIME 1
 static u64 notrace bpf_prog_start_time(void)
 {
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 1f9d336861f0..9533200ffadf 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1008,6 +1008,7 @@ enum bpf_link_type {
 	BPF_LINK_TYPE_NETNS = 5,
 	BPF_LINK_TYPE_XDP = 6,
 	BPF_LINK_TYPE_PERF_EVENT = 7,
+	BPF_LINK_TYPE_TRACING_MULTI = 8,
 
 	MAX_BPF_LINK_TYPE,
 };
@@ -1462,6 +1463,10 @@ union bpf_attr {
 				 */
 				__u64		bpf_cookie;
 			} perf_event;
+			struct {
+				__aligned_u64	multi_btf_ids;		/* addresses to attach */
+				__u32		multi_btf_ids_cnt;	/* addresses count */
+			};
 		};
 	} link_create;
 
-- 
2.31.1

