Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 757B0455A50
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 12:29:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344097AbhKRLcD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 06:32:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:32500 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343777AbhKRLaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 06:30:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637234820;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=trNwr7SPOVoQqmM8yn9ktA9tP84bxy9JXX7Q0ADRDic=;
        b=huVc9GXmlpQsMFxxdT5VzNwEjO6pnzh96RpNiOoBBuyQYjWJ/UEj8MtKua5WIfDP867Q/h
        xSFFFXfMmqaczaxhNvhGZp9wH5qwUSbVhD64aoWVD9ZHS5A3ho3dW6hcuT/CZMzlFfgWjT
        PfMoJOOuoDjpcAr3gAvsbq5YBvDcDDg=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-473-FTzmLfGBMlaDOurPOjn14w-1; Thu, 18 Nov 2021 06:26:59 -0500
X-MC-Unique: FTzmLfGBMlaDOurPOjn14w-1
Received: by mail-ed1-f72.google.com with SMTP id w4-20020aa7cb44000000b003e7c0f7cfffso5017123edt.2
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 03:26:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=trNwr7SPOVoQqmM8yn9ktA9tP84bxy9JXX7Q0ADRDic=;
        b=Q4ofx/+D9eBD36VAzDgJVFSM2ZQ3h8EeYFxgnXrmZoPqItgn4JXB/i1m1JoZXLJk+X
         3F+07qN+cZ0JX0qIgidq9QrzVuM0Uk4KHkEkiTIxeZeL5rfqiNsYNuVo2nUYWkwcyK7M
         OGXCiruL+L5g+zgigfExxZzR5hXAD0GGgu3n2s+o8NQMHsF+ktefM1vcl4c3Sek18n86
         UdFR/hJd9ohGCEdIXFHXIx7CmhD1Xp0cr7Am0llY7PCAskg9n8SjtTW2hEc9X1PbzBHN
         eSgOQRze5Gqfw0l6Qzjt3qtMRiEwVI9ErkCim2wRuu2klzS/Q2lYtE7uZxrATw2bqe5C
         mi/g==
X-Gm-Message-State: AOAM5320fPkN6rTyNfLFssH/LJbXTA8Bw0FWXwElArVL4uRS/4WH0Z62
        2A1PrIN0LxMTsDvsAf94d8RcV74Ek3TOG7Hd/zf4w4X8sWuRdtYkpVlKJZbIcIGmKJYPH//z3Yo
        xYjAoXXSBb0zK4Bws
X-Received: by 2002:a17:906:579a:: with SMTP id k26mr33154972ejq.250.1637234817398;
        Thu, 18 Nov 2021 03:26:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxKJHJ6x9ROA7IxQZgLLzVIxfF3mQIcI90cAxeAkLLzDgP1YWIht9JazeROo4R4KRo8iwygmg==
X-Received: by 2002:a17:906:579a:: with SMTP id k26mr33154947ejq.250.1637234817188;
        Thu, 18 Nov 2021 03:26:57 -0800 (PST)
Received: from krava.redhat.com (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id v3sm1613657edc.69.2021.11.18.03.26.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 03:26:56 -0800 (PST)
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
Subject: [PATCH bpf-next 20/29] bpf: Add support for tracing multi link
Date:   Thu, 18 Nov 2021 12:24:46 +0100
Message-Id: <20211118112455.475349-21-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211118112455.475349-1-jolsa@kernel.org>
References: <20211118112455.475349-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding new link to allow to attach program to multiple
function BTF IDs.

New fields are added to bpf_attr::link_create to pass
array of BTF IDs:

  struct {
    __aligned_u64   btf_ids;        /* addresses to attach */
    __u32           btf_ids_cnt;    /* addresses count */
  } multi;

The new link code will load these IDs into bpf_tramp_id
and resolve their ips.

The resolve itself is done as per Andrii's suggestion:

  - lookup all names for given IDs
  - store and sort them by name
  - go through all kallsyms symbols and use bsearch
    to find it in provided names
  - if name is found, store the address for the name
  - resort the names array based on ID

If there are multi symbols of the same name the first one
will be used to resolve the address.

The new link will pass them to the bpf_tramp_attach that
does all the work of attaching.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/uapi/linux/bpf.h       |   5 +
 kernel/bpf/syscall.c           | 252 +++++++++++++++++++++++++++++++++
 kernel/kallsyms.c              |   2 +-
 tools/include/uapi/linux/bpf.h |   5 +
 4 files changed, 263 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index ca05e35e0478..a03a5bc1d141 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1009,6 +1009,7 @@ enum bpf_link_type {
 	BPF_LINK_TYPE_NETNS = 5,
 	BPF_LINK_TYPE_XDP = 6,
 	BPF_LINK_TYPE_PERF_EVENT = 7,
+	BPF_LINK_TYPE_TRACING_MULTI = 8,
 
 	MAX_BPF_LINK_TYPE,
 };
@@ -1470,6 +1471,10 @@ union bpf_attr {
 				 */
 				__u64		bpf_cookie;
 			} perf_event;
+			struct {
+				__aligned_u64	btf_ids;	/* addresses to attach */
+				__u32		btf_ids_cnt;	/* addresses count */
+			} multi;
 		};
 	} link_create;
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index bfbd81869818..e6f48dc9dd48 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -32,6 +32,9 @@
 #include <linux/rcupdate_trace.h>
 #include <linux/memcontrol.h>
 #include <linux/btf_ids.h>
+#include <linux/ftrace.h>
+#include <linux/sort.h>
+#include <linux/bsearch.h>
 
 #define IS_FD_ARRAY(map) ((map)->map_type == BPF_MAP_TYPE_PERF_EVENT_ARRAY || \
 			  (map)->map_type == BPF_MAP_TYPE_CGROUP_ARRAY || \
@@ -2905,6 +2908,251 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog,
 	return err;
 }
 
+struct bpf_tracing_multi_link {
+	struct bpf_link link;
+	enum bpf_attach_type attach_type;
+	struct bpf_tramp_attach *attach;
+};
+
+static void bpf_tracing_multi_link_release(struct bpf_link *link)
+{
+	struct bpf_prog *prog = link->prog;
+	struct bpf_tramp_attach *attach = prog->aux->attach;
+
+	WARN_ON_ONCE(bpf_tramp_attach_unlink(attach));
+
+	if (prog->type != BPF_PROG_TYPE_EXT)
+		prog->aux->attach = NULL;
+	bpf_tramp_detach(attach);
+}
+
+static void bpf_tracing_multi_link_dealloc(struct bpf_link *link)
+{
+	struct bpf_tracing_multi_link *tr_link =
+		container_of(link, struct bpf_tracing_multi_link, link);
+
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
+static const struct bpf_link_ops bpf_tracing_multi_link_lops = {
+	.release = bpf_tracing_multi_link_release,
+	.dealloc = bpf_tracing_multi_link_dealloc,
+	.show_fdinfo = bpf_tracing_multi_link_show_fdinfo,
+	.fill_link_info = bpf_tracing_multi_link_fill_link_info,
+};
+
+static int check_multi_prog_type(struct bpf_prog *prog)
+{
+	if (prog->expected_attach_type != BPF_TRACE_FENTRY &&
+	    prog->expected_attach_type != BPF_TRACE_FEXIT)
+		return -EINVAL;
+	return 0;
+}
+
+static int btf_ids_cmp(const void *a, const void *b)
+{
+	const u32 *x = a;
+	const u32 *y = b;
+
+	if (*x == *y)
+		return 0;
+	return *x < *y ? -1 : 1;
+}
+
+struct resolve_id {
+	const char *name;
+	void *addr;
+	u32 id;
+};
+
+static int rid_name_cmp(const void *a, const void *b)
+{
+	const struct resolve_id *x = a;
+	const struct resolve_id *y = b;
+
+	return strcmp(x->name, y->name);
+}
+
+static int rid_id_cmp(const void *a, const void *b)
+{
+	const struct resolve_id *x = a;
+	const struct resolve_id *y = b;
+
+	if (x->id == y->id)
+		return 0;
+	return x->id < y->id ? -1 : 1;
+}
+
+struct kallsyms_data {
+	struct resolve_id *rid;
+	u32 cnt;
+	u32 found;
+};
+
+static int kallsyms_callback(void *data, const char *name,
+			     struct module *mod, unsigned long addr)
+{
+	struct kallsyms_data *args = data;
+	struct resolve_id *rid, id = {
+		.name = name,
+	};
+
+	rid = bsearch(&id, args->rid, args->cnt, sizeof(*rid), rid_name_cmp);
+	if (rid && !rid->addr) {
+		rid->addr = (void *) addr;
+		args->found++;
+	}
+	return args->found == args->cnt ? 1 : 0;
+}
+
+static int bpf_tramp_id_resolve(struct bpf_tramp_id *id, struct bpf_prog *prog)
+{
+	struct kallsyms_data args;
+	const struct btf_type *t;
+	struct resolve_id *rid;
+	const char *name;
+	struct btf *btf;
+	int err = 0;
+	u32 i;
+
+	btf = prog->aux->attach_btf;
+	if (!btf)
+		return -EINVAL;
+
+	rid = kzalloc(id->cnt * sizeof(*rid), GFP_KERNEL);
+	if (!rid)
+		return -ENOMEM;
+
+	err = -EINVAL;
+	for (i = 0; i < id->cnt; i++) {
+		t = btf_type_by_id(btf, id->id[i]);
+		if (!t)
+			goto out_free;
+
+		name = btf_name_by_offset(btf, t->name_off);
+		if (!name)
+			goto out_free;
+
+		rid[i].name = name;
+		rid[i].id = id->id[i];
+	}
+
+	sort(rid, id->cnt, sizeof(*rid), rid_name_cmp, NULL);
+
+	args.rid = rid;
+	args.cnt = id->cnt;
+	args.found = 0;
+	kallsyms_on_each_symbol(kallsyms_callback, &args);
+
+	sort(rid, id->cnt, sizeof(*rid), rid_id_cmp, NULL);
+
+	for (i = 0; i < id->cnt; i++) {
+		if (!rid[i].addr) {
+			err = -EINVAL;
+			goto out_free;
+		}
+		id->addr[i] = rid[i].addr;
+	}
+	err = 0;
+out_free:
+	kfree(rid);
+	return err;
+}
+
+static int bpf_tracing_multi_attach(struct bpf_prog *prog,
+				    const union bpf_attr *attr)
+{
+	void __user *uids = u64_to_user_ptr(attr->link_create.multi.btf_ids);
+	u32 cnt_size, cnt = attr->link_create.multi.btf_ids_cnt;
+	struct bpf_tracing_multi_link *link = NULL;
+	struct bpf_link_primer link_primer;
+	struct bpf_tramp_attach *attach;
+	struct bpf_tramp_id *id = NULL;
+	int err = -EINVAL;
+
+	if (check_multi_prog_type(prog))
+		return -EINVAL;
+	if (!cnt || !uids)
+		return -EINVAL;
+
+	id = bpf_tramp_id_alloc(cnt);
+	if (!id)
+		return -ENOMEM;
+
+	err = -EFAULT;
+	cnt_size = cnt * sizeof(id->id[0]);
+	if (copy_from_user(id->id, uids, cnt_size))
+		goto out_free_id;
+
+	id->cnt = cnt;
+	id->obj_id = btf_obj_id(prog->aux->attach_btf);
+
+	/* Sort user provided BTF ids, so we can use memcmp
+	 * and bsearch on top of it later.
+	 */
+	sort(id->id, cnt, sizeof(u32), btf_ids_cmp, NULL);
+
+	err = bpf_tramp_id_resolve(id, prog);
+	if (err)
+		goto out_free_id;
+
+	attach = bpf_tramp_attach(id, NULL, prog);
+	if (IS_ERR(attach)) {
+		err = PTR_ERR(attach);
+		goto out_free_id;
+	}
+
+	link = kzalloc(sizeof(*link), GFP_KERNEL);
+	if (!link) {
+		err = -ENOMEM;
+		goto out_detach;
+	}
+
+	bpf_link_init(&link->link, BPF_LINK_TYPE_TRACING_MULTI,
+		      &bpf_tracing_multi_link_lops, prog);
+	link->attach_type = prog->expected_attach_type;
+
+	err = bpf_link_prime(&link->link, &link_primer);
+	if (err) {
+		kfree(link);
+		goto out_detach;
+	}
+
+	err = bpf_tramp_attach_link(attach);
+	if (err) {
+		bpf_link_cleanup(&link_primer);
+		goto out_detach;
+	}
+	prog->aux->attach = attach;
+	return bpf_link_settle(&link_primer);
+
+out_detach:
+	bpf_tramp_detach(attach);
+	return err;
+out_free_id:
+	bpf_tramp_id_put(id);
+	return err;
+}
+
 struct bpf_raw_tp_link {
 	struct bpf_link link;
 	struct bpf_raw_event_map *btp;
@@ -3211,6 +3459,8 @@ attach_type_to_prog_type(enum bpf_attach_type attach_type)
 	case BPF_CGROUP_SETSOCKOPT:
 		return BPF_PROG_TYPE_CGROUP_SOCKOPT;
 	case BPF_TRACE_ITER:
+	case BPF_TRACE_FENTRY:
+	case BPF_TRACE_FEXIT:
 		return BPF_PROG_TYPE_TRACING;
 	case BPF_SK_LOOKUP:
 		return BPF_PROG_TYPE_SK_LOOKUP;
@@ -4270,6 +4520,8 @@ static int tracing_bpf_link_attach(const union bpf_attr *attr, bpfptr_t uattr,
 
 	if (prog->expected_attach_type == BPF_TRACE_ITER)
 		return bpf_iter_link_attach(attr, uattr, prog);
+	else if (prog->aux->multi_func)
+		return bpf_tracing_multi_attach(prog, attr);
 	else if (prog->type == BPF_PROG_TYPE_EXT)
 		return bpf_tracing_prog_attach(prog,
 					       attr->link_create.target_fd,
diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 3011bc33a5ba..904e140c3491 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -224,7 +224,7 @@ unsigned long kallsyms_lookup_name(const char *name)
 	return module_kallsyms_lookup_name(name);
 }
 
-#ifdef CONFIG_LIVEPATCH
+#if  defined(CONFIG_LIVEPATCH) || defined(CONFIG_BPF)
 /*
  * Iterate over all symbols in vmlinux.  For symbols from modules use
  * module_kallsyms_on_each_symbol instead.
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index ca05e35e0478..a03a5bc1d141 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1009,6 +1009,7 @@ enum bpf_link_type {
 	BPF_LINK_TYPE_NETNS = 5,
 	BPF_LINK_TYPE_XDP = 6,
 	BPF_LINK_TYPE_PERF_EVENT = 7,
+	BPF_LINK_TYPE_TRACING_MULTI = 8,
 
 	MAX_BPF_LINK_TYPE,
 };
@@ -1470,6 +1471,10 @@ union bpf_attr {
 				 */
 				__u64		bpf_cookie;
 			} perf_event;
+			struct {
+				__aligned_u64	btf_ids;	/* addresses to attach */
+				__u32		btf_ids_cnt;	/* addresses count */
+			} multi;
 		};
 	} link_create;
 
-- 
2.31.1

