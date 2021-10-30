Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22FF34409B7
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 16:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231978AbhJ3OtB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 10:49:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231970AbhJ3Os6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Oct 2021 10:48:58 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE9E9C061570;
        Sat, 30 Oct 2021 07:46:27 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id om14so9224342pjb.5;
        Sat, 30 Oct 2021 07:46:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=x+fSQiK/ie4/d656TncR0Bd5R6MRFP7KjRlv5G3QJqQ=;
        b=NhVRotjCav7kMOmleAsLk4UDw7w5+wIZvTm1YhrO91njm+l/YC4UAqLNjC6MhtvEvV
         /PDvoRAVQlWROzn3G2TwaUaTiEq7yarQz4/dVFNrAt5sy5ZCKXo7DQTrwAlCJGEeVvvL
         M7kJ21sVD0siM8Ow7tchsVQtW9CGM5nvYKjiXw0FwiBZmiLd+4C3gtJCBGCSaH0ySMYh
         KnUMcpPwzAMUacBYUK2YlX3+x7c4cx3kfmL0S56ny4+asUv09GU2J4VCOFKf5y87e7pc
         DZc81cfYNYm/xcZHo967kQTRcFw8TMoFbCkr4AsvU75FZ1cr0yaN+AG93aMMu3AwW8QK
         KSkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x+fSQiK/ie4/d656TncR0Bd5R6MRFP7KjRlv5G3QJqQ=;
        b=YswhRDiZVYG6NH2GR2e8rP8hyQj7xNdZMOEZWg+0Lxm1YcYFLF0JthuRInntVo8qWL
         NU4tG1NZ6iCs594FPD1DRNNiSPqwYbyznUQFY8tTNruk7VohpOYJFvIji0vaJ9FxmYEU
         HteZsuaEEq8L2r49xoNEBL4TqX7xFuCebFdMi2tGgRPNJ+4aDz1C1DJ186mEkfui48M/
         9S7PsOIMTrPoK8i9D+b32ZJMotfSQnqFQMmGBWMl9Axn7MGtFz5LA6KW2P8ggNFmPUfb
         6dybr2yqrWlIHFlC9iGbuAsNuBBSqQl7yoLaA5tA1UcgKx9L/SguAizk3fDKI+XMSQp2
         kTMw==
X-Gm-Message-State: AOAM532h3yi9dUpL27NtsfK/h9+g5hK0y8GGHOo+dfcUYyALTCE9ytB5
        4d3ajas+WaJhPRPWGZQqB90kfHV2RkSjyw==
X-Google-Smtp-Source: ABdhPJzhWvzNalfTfee5QHMl509zqYjC8oe6C+i9bMb0ZrHReoHdvZl1aAyk6AZhnwIlI1xU5d7EGQ==
X-Received: by 2002:a17:90a:6583:: with SMTP id k3mr27082525pjj.147.1635605187137;
        Sat, 30 Oct 2021 07:46:27 -0700 (PDT)
Received: from localhost ([2405:201:6014:d916:31fc:9e49:a605:b093])
        by smtp.gmail.com with ESMTPSA id o22sm11195789pfu.50.2021.10.30.07.46.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Oct 2021 07:46:26 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH RFC bpf-next v1 5/6] net: netfilter: Add unstable CT lookup helper for XDP and TC-BPF
Date:   Sat, 30 Oct 2021 20:16:08 +0530
Message-Id: <20211030144609.263572-6-memxor@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211030144609.263572-1-memxor@gmail.com>
References: <20211030144609.263572-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=17809; h=from:subject; bh=PaHgmjIvfp3FAwomK2mBIsgmLxOjTa11OM8osL7figo=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhfVoRiUUTUyEE+vMKdTAc6j9su3lFnsyrecVA2FQ+ IpM31lKJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYX1aEQAKCRBM4MiGSL8RyuhCD/ 96YFK9NyEwrdCcygfF4CmBcthhd2kzf6UZHJkLkKyh1x/ctlyCNnBdIK5HD51r74DE4lrMHT73va5g 3JojCBlR8tFtSdwD9gzJX2fCce9dnFQ423kfTRrJr4FcH/KlekfoyBAZzO+ZI0yCf/38tvRLCkb2Pw doWt2xJ/1E4b02vvKTVIKnxcIDX0ttyyWh0yGgQzYxj1iDSbfR1PeHKO/MscvhubfiTajV9oBHeGJv 66eKfrCiLJq/G1CGhNDq0i5MtmJGqGAwpMn9Ye1HrHNAknPfrdhV5lmDaT4I1qfEJRzXVtMChQnRJQ gg13lDnQqqXYTlw7rcduVt4Veg917pnVkUAqpNO+5ZiGqYiFPJAUvT+PRKSiqZcMAIwJ6ttrJkKxZt vde93xQv2eFw7gZSXDDK/I+8UTJRArHx/ZcyBOni4lwIbNlix3TAHTKw9YFnXghpAnAzpjR4eH0XWF vdqQQPBGl2ONAd0gwccp8VqQdvYNyuLY1qdiD/J8dy5cZrD/UFmGFtnR2Mv0uO6NQz8LnPDlYIXSQz V5JZExO2AQpKLJGRz4A18rBl6SEE0WxeL4JM0HFkxWEKr/e/dkuvnxhTA66etYgb05wezuCpOuGnPP LRuv+VTDxCLbEhJJLIIq3QHSihCbHpGheRXIVudZhxBOzupy3UJOcouUyDxQ==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change adds conntrack lookup helpers using the unstable kfunc call
interface for the XDP and TC-BPF hooks.

Also add acquire/release functions (randomly returning NULL), and also
exercise the RET_PTR_TO_BTF_ID_OR_NULL path so that BPF program caller
has to check for NULL before dereferencing the pointer, for the TC hook.
These will be used in selftest.

Export get_net_ns_by_id and btf_type_by_id as nf_conntrack needs to call
them.

[ NOTE: Currently the btf_type check does not work, due to the problem
described in the thread mentioned in the comments ]

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/bpf.h               |  22 +++
 include/linux/btf.h               |   1 +
 kernel/bpf/btf.c                  |   2 +
 net/bpf/test_run.c                |  55 +++++++
 net/core/filter.c                 |  56 +++++++
 net/core/net_namespace.c          |   1 +
 net/netfilter/nf_conntrack_core.c | 255 ++++++++++++++++++++++++++++++
 7 files changed, 392 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 6fb34f0a2758..b4f82aaf68bd 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1647,6 +1647,10 @@ int bpf_prog_test_run_sk_lookup(struct bpf_prog *prog,
 				const union bpf_attr *kattr,
 				union bpf_attr __user *uattr);
 bool bpf_prog_test_check_kfunc_call(u32 kfunc_id, struct module *owner);
+bool bpf_prog_test_is_acquire_kfunc(u32 kfunc_id, struct module *owner);
+bool bpf_prog_test_is_release_kfunc(u32 kfunc_id, struct module *owner);
+enum bpf_return_type bpf_prog_test_get_kfunc_return_type(u32 kfunc_id,
+							 struct module *owner);
 bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 		    const struct bpf_prog *prog,
 		    struct bpf_insn_access_aux *info);
@@ -1874,6 +1878,24 @@ static inline bool bpf_prog_test_check_kfunc_call(u32 kfunc_id,
 	return false;
 }
 
+static inline bool bpf_prog_test_is_acquire_kfunc(u32 kfunc_id,
+						  struct module *owner)
+{
+	return false;
+}
+
+static inline bool bpf_prog_test_is_release_kfunc(u32 kfunc_id,
+						  struct module *owner)
+{
+	return false;
+}
+
+static inline enum bpf_return_type
+bpf_prog_test_get_kfunc_return_type(u32 kfunc_id, struct module *owner)
+{
+	return __BPF_RET_TYPE_MAX;
+}
+
 static inline void bpf_map_put(struct bpf_map *map)
 {
 }
diff --git a/include/linux/btf.h b/include/linux/btf.h
index 464f22bf7d5f..87019548e37c 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -321,5 +321,6 @@ static inline int bpf_btf_mod_struct_access(struct kfunc_btf_id_list *klist,
 
 extern struct kfunc_btf_id_list bpf_tcp_ca_kfunc_list;
 extern struct kfunc_btf_id_list prog_test_kfunc_list;
+extern struct kfunc_btf_id_list xdp_kfunc_list;
 
 #endif
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 8b3c15f4359d..d0e5101b8c2d 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -735,6 +735,7 @@ const struct btf_type *btf_type_by_id(const struct btf *btf, u32 type_id)
 		return NULL;
 	return btf->types[type_id];
 }
+EXPORT_SYMBOL_GPL(btf_type_by_id);
 
 /*
  * Regular int is not a bit field and it must be either
@@ -6502,3 +6503,4 @@ int bpf_btf_mod_struct_access(struct kfunc_btf_id_list *klist,
 
 DEFINE_KFUNC_BTF_ID_LIST(bpf_tcp_ca_kfunc_list);
 DEFINE_KFUNC_BTF_ID_LIST(prog_test_kfunc_list);
+DEFINE_KFUNC_BTF_ID_LIST(xdp_kfunc_list);
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 46dd95755967..a678ddc97e0f 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -232,6 +232,28 @@ struct sock * noinline bpf_kfunc_call_test3(struct sock *sk)
 	return sk;
 }
 
+struct prog_test_ref_kfunc {
+	int a;
+	int b;
+};
+
+static struct prog_test_ref_kfunc prog_test_struct;
+
+noinline struct prog_test_ref_kfunc *bpf_kfunc_call_test_acquire(char *ptr)
+{
+	/* randomly return NULL */
+	if (get_jiffies_64() % 2)
+		return NULL;
+	prog_test_struct.a = 42;
+	prog_test_struct.b = 108;
+	return &prog_test_struct;
+}
+
+noinline void bpf_kfunc_call_test_release(struct prog_test_ref_kfunc *p)
+{
+	return;
+}
+
 __diag_pop();
 
 ALLOW_ERROR_INJECTION(bpf_modify_return_test, ERRNO);
@@ -240,8 +262,14 @@ BTF_SET_START(test_sk_kfunc_ids)
 BTF_ID(func, bpf_kfunc_call_test1)
 BTF_ID(func, bpf_kfunc_call_test2)
 BTF_ID(func, bpf_kfunc_call_test3)
+BTF_ID(func, bpf_kfunc_call_test_acquire)
+BTF_ID(func, bpf_kfunc_call_test_release)
 BTF_SET_END(test_sk_kfunc_ids)
 
+BTF_ID_LIST(test_sk_acq_rel)
+BTF_ID(func, bpf_kfunc_call_test_acquire)
+BTF_ID(func, bpf_kfunc_call_test_release)
+
 bool bpf_prog_test_check_kfunc_call(u32 kfunc_id, struct module *owner)
 {
 	if (btf_id_set_contains(&test_sk_kfunc_ids, kfunc_id))
@@ -249,6 +277,33 @@ bool bpf_prog_test_check_kfunc_call(u32 kfunc_id, struct module *owner)
 	return bpf_check_mod_kfunc_call(&prog_test_kfunc_list, kfunc_id, owner);
 }
 
+bool bpf_prog_test_is_acquire_kfunc(u32 kfunc_id, struct module *owner)
+{
+	if (!owner) /* bpf_kfunc_call_test_acquire */
+		return kfunc_id == test_sk_acq_rel[0];
+	return bpf_is_mod_acquire_kfunc(&prog_test_kfunc_list, kfunc_id, owner);
+}
+
+bool bpf_prog_test_is_release_kfunc(u32 kfunc_id, struct module *owner)
+{
+	if (!owner) /* bpf_kfunc_call_test_release */
+		return kfunc_id == test_sk_acq_rel[1];
+	return bpf_is_mod_release_kfunc(&prog_test_kfunc_list, kfunc_id, owner);
+}
+
+enum bpf_return_type bpf_prog_test_get_kfunc_return_type(u32 kfunc_id,
+							 struct module *owner)
+{
+	if (!owner) {
+		if (kfunc_id == test_sk_acq_rel[0])
+			return RET_PTR_TO_BTF_ID_OR_NULL;
+		else
+			return __BPF_RET_TYPE_MAX;
+	}
+	return bpf_get_mod_kfunc_return_type(&prog_test_kfunc_list, kfunc_id,
+					     owner);
+}
+
 static void *bpf_test_init(const union bpf_attr *kattr, u32 size,
 			   u32 headroom, u32 tailroom)
 {
diff --git a/net/core/filter.c b/net/core/filter.c
index 8e8d3b49c297..4e320de4472d 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -9948,6 +9948,12 @@ const struct bpf_prog_ops sk_filter_prog_ops = {
 	.test_run		= bpf_prog_test_run_skb,
 };
 
+static int xdp_btf_struct_access(struct bpf_verifier_log *log,
+				 const struct btf *btf,
+				 const struct btf_type *t, int off,
+				 int size, enum bpf_access_type atype,
+				 u32 *next_btf_id);
+
 const struct bpf_verifier_ops tc_cls_act_verifier_ops = {
 	.get_func_proto		= tc_cls_act_func_proto,
 	.is_valid_access	= tc_cls_act_is_valid_access,
@@ -9955,17 +9961,67 @@ const struct bpf_verifier_ops tc_cls_act_verifier_ops = {
 	.gen_prologue		= tc_cls_act_prologue,
 	.gen_ld_abs		= bpf_gen_ld_abs,
 	.check_kfunc_call	= bpf_prog_test_check_kfunc_call,
+	.is_acquire_kfunc	= bpf_prog_test_is_acquire_kfunc,
+	.is_release_kfunc	= bpf_prog_test_is_release_kfunc,
+	.get_kfunc_return_type  = bpf_prog_test_get_kfunc_return_type,
+	/* resuse the callback, there is nothing xdp specific in it */
+	.btf_struct_access      = xdp_btf_struct_access,
 };
 
 const struct bpf_prog_ops tc_cls_act_prog_ops = {
 	.test_run		= bpf_prog_test_run_skb,
 };
 
+static bool xdp_is_acquire_kfunc(u32 kfunc_id, struct module *owner)
+{
+	return bpf_is_mod_acquire_kfunc(&xdp_kfunc_list, kfunc_id, owner);
+}
+
+static bool xdp_is_release_kfunc(u32 kfunc_id, struct module *owner)
+{
+	return bpf_is_mod_release_kfunc(&xdp_kfunc_list, kfunc_id, owner);
+}
+
+static enum bpf_return_type xdp_get_kfunc_return_type(u32 kfunc_id,
+						      struct module *owner)
+{
+	return bpf_get_mod_kfunc_return_type(&xdp_kfunc_list, kfunc_id, owner);
+}
+
+static int xdp_btf_struct_access(struct bpf_verifier_log *log,
+				 const struct btf *btf,
+				 const struct btf_type *t, int off,
+				 int size, enum bpf_access_type atype,
+				 u32 *next_btf_id)
+{
+	int ret = __BPF_REG_TYPE_MAX;
+	struct module *mod;
+
+	if (atype != BPF_READ)
+		return -EACCES;
+
+	if (btf_is_module(btf)) {
+		mod = btf_try_get_module(btf);
+		if (!mod)
+			return -ENXIO;
+		ret = bpf_btf_mod_struct_access(&xdp_kfunc_list, mod, log, btf, t, off, size,
+						atype, next_btf_id);
+		module_put(mod);
+	}
+	if (ret == __BPF_REG_TYPE_MAX)
+		return btf_struct_access(log, btf, t, off, size, atype, next_btf_id);
+	return ret;
+}
+
 const struct bpf_verifier_ops xdp_verifier_ops = {
 	.get_func_proto		= xdp_func_proto,
 	.is_valid_access	= xdp_is_valid_access,
 	.convert_ctx_access	= xdp_convert_ctx_access,
 	.gen_prologue		= bpf_noop_prologue,
+	.is_acquire_kfunc	= xdp_is_acquire_kfunc,
+	.is_release_kfunc	= xdp_is_release_kfunc,
+	.get_kfunc_return_type  = xdp_get_kfunc_return_type,
+	.btf_struct_access	= xdp_btf_struct_access,
 };
 
 const struct bpf_prog_ops xdp_prog_ops = {
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 202fa5eacd0f..7b4bfe793002 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -299,6 +299,7 @@ struct net *get_net_ns_by_id(const struct net *net, int id)
 
 	return peer;
 }
+EXPORT_SYMBOL_GPL(get_net_ns_by_id);
 
 /*
  * setup_net runs the initializers for the network namespace object.
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 770a63103c7a..69450b5c32f0 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -11,6 +11,9 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/bpf.h>
+#include <linux/btf.h>
+#include <linux/btf_ids.h>
 #include <linux/types.h>
 #include <linux/netfilter.h>
 #include <linux/module.h>
@@ -2451,6 +2454,252 @@ static int kill_all(struct nf_conn *i, void *data)
 	return net_eq(nf_ct_net(i), data);
 }
 
+/* Unstable Kernel Helpers for XDP hook */
+static struct nf_conn *__bpf_nf_ct_lookup(struct net *net,
+					  struct bpf_sock_tuple *bpf_tuple,
+					  u32 tuple_len, u8 protonum,
+					  u64 netns_id, u64 flags)
+{
+	struct nf_conntrack_tuple_hash *hash;
+	struct nf_conntrack_tuple tuple;
+
+	if (flags != IP_CT_DIR_ORIGINAL && flags != IP_CT_DIR_REPLY)
+		return ERR_PTR(-EINVAL);
+
+	memset(&tuple, 0, sizeof(tuple));
+
+	switch (tuple_len) {
+	case sizeof(bpf_tuple->ipv4):
+		tuple.src.l3num = AF_INET;
+		tuple.src.u3.ip = bpf_tuple->ipv4.saddr;
+		tuple.src.u.tcp.port = bpf_tuple->ipv4.sport;
+		tuple.dst.u3.ip = bpf_tuple->ipv4.daddr;
+		tuple.dst.u.tcp.port = bpf_tuple->ipv4.dport;
+		break;
+	case sizeof(bpf_tuple->ipv6):
+		tuple.src.l3num = AF_INET6;
+		memcpy(tuple.src.u3.ip6, bpf_tuple->ipv6.saddr, sizeof(bpf_tuple->ipv6.saddr));
+		tuple.src.u.tcp.port = bpf_tuple->ipv6.sport;
+		memcpy(tuple.dst.u3.ip6, bpf_tuple->ipv6.daddr, sizeof(bpf_tuple->ipv6.daddr));
+		tuple.dst.u.tcp.port = bpf_tuple->ipv6.dport;
+		break;
+	default:
+		return ERR_PTR(-EAFNOSUPPORT);
+	}
+
+	tuple.dst.protonum = protonum;
+	tuple.dst.dir = flags;
+
+	if ((s32)netns_id >= 0) {
+		if ((s32)netns_id > S32_MAX)
+			return ERR_PTR(-EINVAL);
+		net = get_net_ns_by_id(net, netns_id);
+		if (!net)
+			return ERR_PTR(-EINVAL);
+	}
+
+	hash = nf_conntrack_find_get(net, &nf_ct_zone_dflt, &tuple);
+	if ((s32)netns_id >= 0)
+		put_net(net);
+	if (!hash)
+		return ERR_PTR(-ENOENT);
+	return nf_ct_tuplehash_to_ctrack(hash);
+}
+
+static struct nf_conn *bpf_xdp_ct_lookup(struct xdp_md *xdp_ctx,
+					 struct bpf_sock_tuple *bpf_tuple,
+					 u32 tuple_len, u8 protonum,
+					 u64 netns_id, u64 *flags_err)
+{
+	struct xdp_buff *ctx = (struct xdp_buff *)xdp_ctx;
+	struct net *caller_net;
+	struct nf_conn *nfct;
+
+	if (!flags_err)
+		return NULL;
+	if (!bpf_tuple) {
+		*flags_err = -EINVAL;
+		return NULL;
+	}
+	caller_net = dev_net(ctx->rxq->dev);
+	nfct = __bpf_nf_ct_lookup(caller_net, bpf_tuple, tuple_len, protonum,
+				  netns_id, *flags_err);
+	if (IS_ERR(nfct)) {
+		*flags_err = PTR_ERR(nfct);
+		return NULL;
+	}
+	return nfct;
+}
+
+static struct nf_conn *bpf_skb_ct_lookup(struct __sk_buff *skb_ctx,
+					 struct bpf_sock_tuple *bpf_tuple,
+					 u32 tuple_len, u8 protonum,
+					 u64 netns_id, u64 *flags_err)
+{
+	struct sk_buff *skb = (struct sk_buff *)skb_ctx;
+	struct net *caller_net;
+	struct nf_conn *nfct;
+
+	if (!flags_err)
+		return NULL;
+	if (!bpf_tuple) {
+		*flags_err = -EINVAL;
+		return NULL;
+	}
+	caller_net = skb->dev ? dev_net(skb->dev) : sock_net(skb->sk);
+	nfct = __bpf_nf_ct_lookup(caller_net, bpf_tuple, tuple_len, protonum,
+				  netns_id, *flags_err);
+	if (IS_ERR(nfct)) {
+		*flags_err = PTR_ERR(nfct);
+		return NULL;
+	}
+	return nfct;
+}
+
+struct nf_conn *bpf_xdp_ct_lookup_tcp(struct xdp_md *xdp_ctx,
+				      struct bpf_sock_tuple *bpf_tuple,
+				      u32 tuple_len, u64 netns_id,
+				      u64 *flags_err)
+{
+	return bpf_xdp_ct_lookup(xdp_ctx, bpf_tuple, tuple_len, IPPROTO_TCP,
+				 netns_id, flags_err);
+}
+
+struct nf_conn *bpf_xdp_ct_lookup_udp(struct xdp_md *xdp_ctx,
+				      struct bpf_sock_tuple *bpf_tuple,
+				      u32 tuple_len, u64 netns_id,
+				      u64 *flags_err)
+{
+	return bpf_xdp_ct_lookup(xdp_ctx, bpf_tuple, tuple_len, IPPROTO_UDP,
+				 netns_id, flags_err);
+}
+
+struct nf_conn *bpf_skb_ct_lookup_tcp(struct __sk_buff *skb_ctx,
+				      struct bpf_sock_tuple *bpf_tuple,
+				      u32 tuple_len, u64 netns_id,
+				      u64 *flags_err)
+{
+	return bpf_skb_ct_lookup(skb_ctx, bpf_tuple, tuple_len, IPPROTO_TCP,
+				 netns_id, flags_err);
+}
+
+struct nf_conn *bpf_skb_ct_lookup_udp(struct __sk_buff *skb_ctx,
+				      struct bpf_sock_tuple *bpf_tuple,
+				      u32 tuple_len, u64 netns_id,
+				      u64 *flags_err)
+{
+	return bpf_skb_ct_lookup(skb_ctx, bpf_tuple, tuple_len, IPPROTO_UDP,
+				 netns_id, flags_err);
+}
+
+void bpf_ct_release(struct nf_conn *nfct)
+{
+	if (!nfct)
+		return;
+	nf_ct_put(nfct);
+}
+
+BTF_SET_START(nf_conntrack_xdp_ids)
+BTF_ID(func, bpf_xdp_ct_lookup_tcp)
+BTF_ID(func, bpf_xdp_ct_lookup_udp)
+BTF_ID(func, bpf_ct_release)
+BTF_SET_END(nf_conntrack_xdp_ids)
+
+BTF_SET_START(nf_conntrack_skb_ids)
+BTF_ID(func, bpf_skb_ct_lookup_tcp)
+BTF_ID(func, bpf_skb_ct_lookup_udp)
+BTF_ID(func, bpf_ct_release)
+BTF_SET_END(nf_conntrack_skb_ids)
+
+BTF_ID_LIST(nf_conntrack_ids)
+BTF_ID(func, bpf_xdp_ct_lookup_tcp)
+BTF_ID(func, bpf_xdp_ct_lookup_udp)
+BTF_ID(func, bpf_skb_ct_lookup_tcp)
+BTF_ID(func, bpf_skb_ct_lookup_udp)
+BTF_ID(func, bpf_ct_release)
+BTF_ID(struct, nf_conn)
+
+bool nf_is_acquire_kfunc(u32 kfunc_id)
+{
+	return kfunc_id == nf_conntrack_ids[0] ||
+	       kfunc_id == nf_conntrack_ids[1] ||
+	       kfunc_id == nf_conntrack_ids[2] ||
+	       kfunc_id == nf_conntrack_ids[3];
+}
+
+bool nf_is_release_kfunc(u32 kfunc_id)
+{
+	return kfunc_id == nf_conntrack_ids[4];
+}
+
+enum bpf_return_type nf_get_kfunc_return_type(u32 kfunc_id)
+{
+	if (kfunc_id == nf_conntrack_ids[0] ||
+	    kfunc_id == nf_conntrack_ids[1] ||
+	    kfunc_id == nf_conntrack_ids[2] ||
+	    kfunc_id == nf_conntrack_ids[3])
+		return RET_PTR_TO_BTF_ID_OR_NULL;
+	return __BPF_RET_TYPE_MAX;
+}
+
+static int nf_btf_struct_access(struct bpf_verifier_log *log,
+				const struct btf *btf,
+				const struct btf_type *t, int off,
+				int size, enum bpf_access_type atype,
+				u32 *next_btf_id)
+{
+	const struct btf_type *nf_conn_type;
+	size_t end;
+
+	nf_conn_type = btf_type_by_id(btf, nf_conntrack_ids[5]);
+	if (!nf_conn_type)
+		return -EACCES;
+	/* This won't work (not even with btf_struct_ids_match for off == 0),
+	 * see below for the reason:
+	 * https://lore.kernel.org/bpf/20211028014428.rsuq6rkfvqzq23tg@apollo.localdomain
+	 */
+	if (t != nf_conn_type) /* skip */
+		return __BPF_REG_TYPE_MAX;
+
+	if (atype != BPF_READ)
+		return -EACCES;
+
+	switch (off) {
+	case offsetof(struct nf_conn, status):
+		end = offsetofend(struct nf_conn, status);
+		break;
+	/* TODO(v2): We should do it per field offset */
+	case bpf_ctx_range(struct nf_conn, proto):
+		end = offsetofend(struct nf_conn, proto);
+		break;
+	default:
+		return -EACCES;
+	}
+
+	if (off + size > end)
+		return -EACCES;
+
+	return NOT_INIT;
+}
+
+static struct kfunc_btf_id_set nf_ct_xdp_kfunc_set = {
+	.owner                 = THIS_MODULE,
+	.set                   = &nf_conntrack_xdp_ids,
+	.is_acquire_kfunc      = nf_is_acquire_kfunc,
+	.is_release_kfunc      = nf_is_release_kfunc,
+	.get_kfunc_return_type = nf_get_kfunc_return_type,
+	.btf_struct_access     = nf_btf_struct_access,
+};
+
+static struct kfunc_btf_id_set nf_ct_skb_kfunc_set = {
+	.owner                 = THIS_MODULE,
+	.set                   = &nf_conntrack_skb_ids,
+	.is_acquire_kfunc      = nf_is_acquire_kfunc,
+	.is_release_kfunc      = nf_is_release_kfunc,
+	.get_kfunc_return_type = nf_get_kfunc_return_type,
+	.btf_struct_access     = nf_btf_struct_access,
+};
+
 void nf_conntrack_cleanup_start(void)
 {
 	conntrack_gc_work.exiting = true;
@@ -2459,6 +2708,9 @@ void nf_conntrack_cleanup_start(void)
 
 void nf_conntrack_cleanup_end(void)
 {
+	unregister_kfunc_btf_id_set(&xdp_kfunc_list, &nf_ct_xdp_kfunc_set);
+	unregister_kfunc_btf_id_set(&prog_test_kfunc_list, &nf_ct_skb_kfunc_set);
+
 	RCU_INIT_POINTER(nf_ct_hook, NULL);
 	cancel_delayed_work_sync(&conntrack_gc_work.dwork);
 	kvfree(nf_conntrack_hash);
@@ -2745,6 +2997,9 @@ int nf_conntrack_init_start(void)
 	conntrack_gc_work_init(&conntrack_gc_work);
 	queue_delayed_work(system_power_efficient_wq, &conntrack_gc_work.dwork, HZ);
 
+	register_kfunc_btf_id_set(&prog_test_kfunc_list, &nf_ct_skb_kfunc_set);
+	register_kfunc_btf_id_set(&xdp_kfunc_list, &nf_ct_xdp_kfunc_set);
+
 	return 0;
 
 err_proto:
-- 
2.33.1

