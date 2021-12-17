Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8224478281
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 02:51:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232116AbhLQBu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 20:50:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232136AbhLQBuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 20:50:55 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACB23C061746;
        Thu, 16 Dec 2021 17:50:55 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id g13so908967pfv.5;
        Thu, 16 Dec 2021 17:50:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3E8zUt6uCKHFg4sPLt8EAZzqodHJOrj/m4M7dnjdBGM=;
        b=j/3/b1umtTDT/+Q5qxCowiLa7ZuWf7EpOD3ZI6SLqPzDd1l3B/Fz26p/O9b89RWXIr
         0DO8WhUn5B6iOHE1IYSl6G6WVvflZpeSuB0sy4AwZgrP2niJKmO7kKXaXsnxf+u4zmoh
         Z/ngez0POiF8kI4NcdoGRQRJZIoGfuojj6ZPvYRTa5zZkzctsxxFSOZRtVSPbi9aIdtV
         px3K8smVGiRtQoZqQMFk3QkQ1H0p+Iiife/HJW2cbSccXHI8laDZdY832te4bEraS/Wu
         pLHFBe7Q3DTSSEKPONR2aDcNbTUv6HX5xN9XpbzF4BJsqEUtghaom8yEw1q8dXs5d0PG
         k8mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3E8zUt6uCKHFg4sPLt8EAZzqodHJOrj/m4M7dnjdBGM=;
        b=ze+nw9jPtuTWXRvNvNWSEXSwtsl30J+MPwJdTCWUrY+hvoIecBqZSQpi4HFzdJCLhX
         FO5T4GoyOsoe7PHB+ZE0f/IO8J1ezq8ivTFM2COG64vev/VG9M2GtjIvuZQX8ah5Poeq
         RgDiDESKiF4RWY2jOpySj03RB/jam4IDm/erROkJ/nBl1xF3fOEzdRtBxGEOPI2jprBT
         zW3M1T/kGkAutCYTaFp8CiOUK7SqbdIv9aH5ivsfRn6nNFIC4vRVez4VFQMD3ZFSFwux
         aUwQ63mHxe54cEtVVg0fzQiQBuO1dxxth3jLdLlGWBt+SotSy3+8T0nLkTj+/F6OXk5p
         bLeQ==
X-Gm-Message-State: AOAM531DnyRC1w+28IlLyernSzoiAWisAGC7o5GwnQ29AtwUYhoPj8Cm
        U5A3aCCew3/a9r5PMP5tHi2cboAW4e4=
X-Google-Smtp-Source: ABdhPJzcOeWnjDW71vdmEImqn/ine+dhrP3q9iMS42SCQn80eVRq7MK0937mup8AHKL+qHHuDpZ+1w==
X-Received: by 2002:aa7:9007:0:b0:4b1:40b9:7046 with SMTP id m7-20020aa79007000000b004b140b97046mr850236pfo.48.1639705854918;
        Thu, 16 Dec 2021 17:50:54 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id g19sm3856679pfc.145.2021.12.16.17.50.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 17:50:54 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH bpf-next v4 07/10] net/netfilter: Add unstable CT lookup helpers for XDP and TC-BPF
Date:   Fri, 17 Dec 2021 07:20:28 +0530
Message-Id: <20211217015031.1278167-8-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211217015031.1278167-1-memxor@gmail.com>
References: <20211217015031.1278167-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=13919; h=from:subject; bh=W6UL6n5bGTtYFJO4M+z5769w1sBVq8BwCQnJf1MX3uI=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhu+vFK/5/MK0hVgphVZJPA50AIhEsTFTWP+tSTYyZ EM8hP46JAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYbvrxQAKCRBM4MiGSL8RytfbD/ 4sQIqjgZB/WBMbuvP7W7GdHmPA6RI/darKASub6IkmmV/nUTGlNg4FmytFOosJRVhUtS7EgzuqgmIT iFcc1mnZrNpEKNcFgRsWsbDFWa0fbqqLnxix1k+nmPPyBZ2TPD5EU/DfzWgbx/AtrInjcnPwstkEBi faaJWlFRexjoBd4q+DS6M9Cl3zKSr1QAP9sevMOpSkf0wOqql7uF6G6bJC6U4qE3eFhMn4gc/WJehl 9rnQ97594/9sw1kalGue25C8CkEAKPseSGxUeG9VSc+AleOZfeZgkZT98ciKL0gKHdqSgobkMyWc13 6iZMLRgq8jysFz/cIf0Kz+mDqVvQe/hwlTPGor+jrkeXgbOUEflmtWKv1qkFXfotIvTaBh0OWQ+8UP Ggvbn5OswFpqiPeLJtz2yGtJpNJ4aHiD2xZkquUjMZk2zBOk+Fq8+Qtzm22+Bxc3OaKXmb+bCOEI4q 0AFbF2hShLzmUq7NxsRXFGrgPm5ZMxEb6YUfY+hzGiM+q7MW1mggLPQywklQXn94huGiPHSp8LKu13 IU9CjXB2QYPUDBuuDfqMZRcePpjBVyE52lIR6Ih866v5xJujjLeJY3Krrs9MLrmilVCTyRz15DccwU 0ZJ+wkZ4Imoz4Eb19zrcXHE+0eu6Ic8hSsXeRE0BlzDIBBlR/cjaXs2lKV4g==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change adds conntrack lookup helpers using the unstable kfunc call
interface for the XDP and TC-BPF hooks. The primary usecase is
implementing a synproxy in XDP, see Maxim's patchset at [0].

Export get_net_ns_by_id as nf_conntrack needs to call it.

Note that we search for acquire, release, and null returning kfuncs in
the intersection of those sets and main set.

This implies that the kfunc_btf_id_list acq_set, rel_set, null_set may
contain BTF ID not in main set, this is explicitly allowed and
recommended (to save on definining more and more sets), since
check_kfunc_call verifier operation would filter out the invalid BTF ID
fairly early, so later checks for acquire, release, and ret_type_null
kfunc will only consider allowed BTF IDs for that program that are
allowed in main set. This is why the nf_conntrack_acq_ids set has BTF
IDs for both xdp and tc hook kfuncs.

  [0]: https://lore.kernel.org/bpf/20211019144655.3483197-1-maximmi@nvidia.com

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/btf.h               |   2 +
 kernel/bpf/btf.c                  |   1 +
 net/core/filter.c                 |  24 +++
 net/core/net_namespace.c          |   1 +
 net/netfilter/nf_conntrack_core.c | 278 ++++++++++++++++++++++++++++++
 5 files changed, 306 insertions(+)

diff --git a/include/linux/btf.h b/include/linux/btf.h
index 64c3784799c5..289d9db6748b 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -363,6 +363,7 @@ bool bpf_is_mod_kfunc_ret_type_null(struct kfunc_btf_id_list *klist,
 
 extern struct kfunc_btf_id_list bpf_tcp_ca_kfunc_list;
 extern struct kfunc_btf_id_list prog_test_kfunc_list;
+extern struct kfunc_btf_id_list xdp_kfunc_list;
 #else
 static inline void register_kfunc_btf_id_set(struct kfunc_btf_id_list *l,
 					     struct kfunc_btf_id_set *s)
@@ -396,6 +397,7 @@ bpf_is_mod_kfunc_ret_type_null(struct kfunc_btf_id_list *klist, u32 kfunc_id,
 
 static struct kfunc_btf_id_list bpf_tcp_ca_kfunc_list __maybe_unused;
 static struct kfunc_btf_id_list prog_test_kfunc_list __maybe_unused;
+static struct kfunc_btf_id_list xdp_kfunc_list __maybe_unused;
 #endif
 
 #endif
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 4983b54c1d81..bce1f98177b9 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6558,6 +6558,7 @@ bool bpf_is_mod_kfunc_ret_type_null(struct kfunc_btf_id_list *klist,
 
 DEFINE_KFUNC_BTF_ID_LIST(bpf_tcp_ca_kfunc_list);
 DEFINE_KFUNC_BTF_ID_LIST(prog_test_kfunc_list);
+DEFINE_KFUNC_BTF_ID_LIST(xdp_kfunc_list);
 
 #endif
 
diff --git a/net/core/filter.c b/net/core/filter.c
index 3f656391af7e..e5efacaa6175 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -10008,11 +10008,35 @@ const struct bpf_prog_ops tc_cls_act_prog_ops = {
 	.test_run		= bpf_prog_test_run_skb,
 };
 
+static bool xdp_check_kfunc_call(u32 kfunc_id, struct module *owner)
+{
+	return bpf_check_mod_kfunc_call(&xdp_kfunc_list, kfunc_id, owner);
+}
+
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
+static bool xdp_is_kfunc_ret_type_null(u32 kfunc_id, struct module *owner)
+{
+	return bpf_is_mod_kfunc_ret_type_null(&xdp_kfunc_list, kfunc_id, owner);
+}
+
 const struct bpf_verifier_ops xdp_verifier_ops = {
 	.get_func_proto		= xdp_func_proto,
 	.is_valid_access	= xdp_is_valid_access,
 	.convert_ctx_access	= xdp_convert_ctx_access,
 	.gen_prologue		= bpf_noop_prologue,
+	.check_kfunc_call	= xdp_check_kfunc_call,
+	.is_acquire_kfunc	= xdp_is_acquire_kfunc,
+	.is_release_kfunc	= xdp_is_release_kfunc,
+	.is_kfunc_ret_type_null = xdp_is_kfunc_ret_type_null,
 };
 
 const struct bpf_prog_ops xdp_prog_ops = {
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 9b7171c40434..3b471781327f 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -299,6 +299,7 @@ struct net *get_net_ns_by_id(const struct net *net, int id)
 
 	return peer;
 }
+EXPORT_SYMBOL_GPL(get_net_ns_by_id);
 
 /*
  * setup_net runs the initializers for the network namespace object.
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 9fbce31baf75..116e1384e446 100644
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
@@ -2457,8 +2460,280 @@ void nf_conntrack_cleanup_start(void)
 	RCU_INIT_POINTER(ip_ct_attach, NULL);
 }
 
+#ifdef CONFIG_DEBUG_INFO_BTF_MODULES
+
+/* Unstable Conntrack Helpers for XDP and TC-BPF hook
+ *
+ * These are called from the XDP and SCHED_CLS BPF programs. Note that it is
+ * allowed to break compatibility for these functions since the interface they
+ * are exposed through to BPF programs is explicitly unstable.
+ */
+
+/* bpf_ct_opts - Options for CT lookup helpers
+ *
+ * Members:
+ * @error      - Out parameter, set for any errors encountered
+ *		 Values:
+ *		   -EINVAL - Passed NULL for bpf_tuple pointer
+ *		   -EINVAL - opts->reserved is not 0
+ *		   -EINVAL - netns_id is less than -1
+ *		   -EINVAL - len__opts isn't NF_BPF_CT_OPTS_SZ (12)
+ *		   -EPROTO - l4proto isn't one of IPPROTO_TCP or IPPROTO_UDP
+ *		   -ENONET - No network namespace found for netns_id
+ *		   -ENOENT - Conntrack lookup could not find entry for tuple
+ *		   -EAFNOSUPPORT - len__tuple isn't one of sizeof(tuple->ipv4)
+ *				   or sizeof(tuple->ipv6)
+ * @l4proto    - Layer 4 protocol
+ *		 Values:
+ *		   IPPROTO_TCP, IPPROTO_UDP
+ * @reserved   - Reserved member, will be reused for more options in future
+ *		 Values:
+ *		   0
+ * @netns_id   - Specify the network namespace for lookup
+ *		 Values:
+ *		   BPF_F_CURRENT_NETNS (-1)
+ *		     Use namespace associated with ctx (xdp_md, __sk_buff)
+ *		   [0, S32_MAX]
+ *		     Network Namespace ID
+ */
+struct bpf_ct_opts {
+	s32 netns_id;
+	s32 error;
+	u8 l4proto;
+	u8 reserved[3];
+};
+
+enum {
+	NF_BPF_CT_OPTS_SZ = 12,
+};
+
+static struct nf_conn *__bpf_nf_ct_lookup(struct net *net,
+					  struct bpf_sock_tuple *bpf_tuple,
+					  u32 tuple_len, u8 protonum,
+					  s32 netns_id)
+{
+	struct nf_conntrack_tuple_hash *hash;
+	struct nf_conntrack_tuple tuple;
+
+	if (unlikely(protonum != IPPROTO_TCP && protonum != IPPROTO_UDP))
+		return ERR_PTR(-EPROTO);
+	if (unlikely(netns_id < BPF_F_CURRENT_NETNS))
+		return ERR_PTR(-EINVAL);
+
+	memset(&tuple, 0, sizeof(tuple));
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
+
+	if (netns_id >= 0) {
+		net = get_net_ns_by_id(net, netns_id);
+		if (unlikely(!net))
+			return ERR_PTR(-ENONET);
+	}
+
+	hash = nf_conntrack_find_get(net, &nf_ct_zone_dflt, &tuple);
+	if (netns_id >= 0)
+		put_net(net);
+	if (!hash)
+		return ERR_PTR(-ENOENT);
+	return nf_ct_tuplehash_to_ctrack(hash);
+}
+
+__diag_push();
+__diag_ignore(GCC, 8, "-Wmissing-prototypes",
+	      "Global functions as their definitions will be in nf_conntrack BTF");
+
+/* bpf_xdp_ct_lookup - Lookup CT entry for the given tuple, and acquire a
+ *		       reference to it
+ *
+ * Parameters:
+ * @xdp_ctx	- Pointer to ctx (xdp_md) in XDP program
+ *		    Cannot be NULL
+ * @bpf_tuple	- Pointer to memory representing the tuple to look up
+ *		    Cannot be NULL
+ * @len__tuple	- Length of the tuple structure
+ *		    Must be one of sizeof(bpf_tuple->ipv4) or
+ *		    sizeof(bpf_tuple->ipv6)
+ * @opts	- Additional options for lookup (documented above)
+ *		    Cannot be NULL
+ * @len__opts	- Length of the bpf_ct_opts structure
+ *		    Must be NF_BPF_CT_OPTS_SZ (12)
+ */
+struct nf_conn *
+bpf_xdp_ct_lookup(struct xdp_md *xdp_ctx, struct bpf_sock_tuple *bpf_tuple,
+		  u32 len__tuple, struct bpf_ct_opts *opts, u32 len__opts)
+{
+	struct xdp_buff *ctx = (struct xdp_buff *)xdp_ctx;
+	struct net *caller_net;
+	struct nf_conn *nfct;
+
+	BUILD_BUG_ON(sizeof(struct bpf_ct_opts) != NF_BPF_CT_OPTS_SZ);
+
+	if (!opts)
+		return NULL;
+	if (!bpf_tuple || opts->reserved[0] || opts->reserved[1] ||
+	    opts->reserved[2] || len__opts != NF_BPF_CT_OPTS_SZ) {
+		opts->error = -EINVAL;
+		return NULL;
+	}
+	caller_net = dev_net(ctx->rxq->dev);
+	nfct = __bpf_nf_ct_lookup(caller_net, bpf_tuple, len__tuple, opts->l4proto,
+				  opts->netns_id);
+	if (IS_ERR(nfct)) {
+		opts->error = PTR_ERR(nfct);
+		return NULL;
+	}
+	return nfct;
+}
+
+/* bpf_skb_ct_lookup - Lookup CT entry for the given tuple, and acquire a
+ *		       reference to it
+ *
+ * Parameters:
+ * @skb_ctx	- Pointer to ctx (__sk_buff) in TC program
+ *		    Cannot be NULL
+ * @bpf_tuple	- Pointer to memory representing the tuple to look up
+ *		    Cannot be NULL
+ * @len__tuple	- Length of the tuple structure
+ *		    Must be one of sizeof(bpf_tuple->ipv4) or
+ *		    sizeof(bpf_tuple->ipv6)
+ * @opts	- Additional options for lookup (documented above)
+ *		    Cannot be NULL
+ * @len__opts	- Length of the bpf_ct_opts structure
+ *		    Must be NF_BPF_CT_OPTS_SZ (12)
+ */
+struct nf_conn *
+bpf_skb_ct_lookup(struct __sk_buff *skb_ctx, struct bpf_sock_tuple *bpf_tuple,
+		  u32 len__tuple, struct bpf_ct_opts *opts, u32 len__opts)
+{
+	struct sk_buff *skb = (struct sk_buff *)skb_ctx;
+	struct net *caller_net;
+	struct nf_conn *nfct;
+
+	BUILD_BUG_ON(sizeof(struct bpf_ct_opts) != NF_BPF_CT_OPTS_SZ);
+
+	if (!opts)
+		return NULL;
+	if (!bpf_tuple || opts->reserved[0] || opts->reserved[1] ||
+	    opts->reserved[2] || len__opts != NF_BPF_CT_OPTS_SZ) {
+		opts->error = -EINVAL;
+		return NULL;
+	}
+	caller_net = skb->dev ? dev_net(skb->dev) : sock_net(skb->sk);
+	nfct = __bpf_nf_ct_lookup(caller_net, bpf_tuple, len__tuple, opts->l4proto,
+				  opts->netns_id);
+	if (IS_ERR(nfct)) {
+		opts->error = PTR_ERR(nfct);
+		return NULL;
+	}
+	return nfct;
+}
+
+/* bpf_ct_release - Release acquired nf_conn object
+ *
+ * This must be invoked for referenced PTR_TO_BTF_ID, and the verifier rejects
+ * the program if any references remain in the program in all of the explored
+ * states.
+ *
+ * Parameters:
+ * @nf_conn	 - Pointer to referenced nf_conn object, obtained using
+ *		   bpf_xdp_ct_lookup or bpf_skb_ct_lookup.
+ */
+void bpf_ct_release(struct nf_conn *nfct)
+{
+	if (!nfct)
+		return;
+	nf_ct_put(nfct);
+}
+
+__diag_pop()
+
+/* XDP hook allowed kfuncs */
+BTF_SET_START(bpf_nf_ct_xdp_ids)
+BTF_ID(func, bpf_xdp_ct_lookup)
+BTF_ID(func, bpf_ct_release)
+BTF_SET_END(bpf_nf_ct_xdp_ids)
+
+/* TC-BPF hook allowed kfuncs */
+BTF_SET_START(bpf_nf_ct_skb_ids)
+BTF_ID(func, bpf_skb_ct_lookup)
+BTF_ID(func, bpf_ct_release)
+BTF_SET_END(bpf_nf_ct_skb_ids)
+
+/* XDP and TC-BPF hook acquire kfuncs */
+BTF_SET_START(bpf_nf_ct_acq_ids)
+BTF_ID(func, bpf_xdp_ct_lookup)
+BTF_ID(func, bpf_skb_ct_lookup)
+BTF_SET_END(bpf_nf_ct_acq_ids)
+
+/* XDP and TC-BPF hook release kfuncs */
+BTF_SET_START(bpf_nf_ct_rel_ids)
+BTF_ID(func, bpf_ct_release)
+BTF_SET_END(bpf_nf_ct_rel_ids)
+
+/* kfuncs that may return NULL PTR_TO_BTF_ID */
+BTF_SET_START(bpf_nf_ct_null_ids)
+BTF_ID(func, bpf_xdp_ct_lookup)
+BTF_ID(func, bpf_skb_ct_lookup)
+BTF_SET_END(bpf_nf_ct_null_ids)
+
+#else
+
+BTF_SET_START(bpf_nf_ct_xdp_ids)
+BTF_SET_END(bpf_nf_ct_xdp_ids)
+
+BTF_SET_START(bpf_nf_ct_skb_ids)
+BTF_SET_END(bpf_nf_ct_skb_ids)
+
+BTF_SET_START(bpf_nf_ct_acq_ids)
+BTF_SET_END(bpf_nf_ct_acq_ids)
+
+BTF_SET_START(bpf_nf_ct_rel_ids)
+BTF_SET_END(bpf_nf_ct_rel_ids)
+
+BTF_SET_START(bpf_nf_ct_null_ids)
+BTF_SET_END(bpf_nf_ct_null_ids)
+
+#endif /* CONFIG_DEBUG_INFO_BTF_MODULES */
+
+static struct kfunc_btf_id_set nf_ct_xdp_kfunc_set = {
+	.owner		= THIS_MODULE,
+	.set		= &bpf_nf_ct_xdp_ids,
+	.acq_set        = &bpf_nf_ct_acq_ids,
+	.rel_set        = &bpf_nf_ct_rel_ids,
+	.null_set       = &bpf_nf_ct_null_ids,
+};
+
+static struct kfunc_btf_id_set nf_ct_skb_kfunc_set = {
+	.owner          = THIS_MODULE,
+	.set            = &bpf_nf_ct_skb_ids,
+	.acq_set	= &bpf_nf_ct_acq_ids,
+	.rel_set	= &bpf_nf_ct_rel_ids,
+	.null_set	= &bpf_nf_ct_null_ids,
+};
+
 void nf_conntrack_cleanup_end(void)
 {
+	unregister_kfunc_btf_id_set(&xdp_kfunc_list, &nf_ct_xdp_kfunc_set);
+	unregister_kfunc_btf_id_set(&prog_test_kfunc_list, &nf_ct_skb_kfunc_set);
+
 	RCU_INIT_POINTER(nf_ct_hook, NULL);
 	cancel_delayed_work_sync(&conntrack_gc_work.dwork);
 	kvfree(nf_conntrack_hash);
@@ -2745,6 +3020,9 @@ int nf_conntrack_init_start(void)
 	conntrack_gc_work_init(&conntrack_gc_work);
 	queue_delayed_work(system_power_efficient_wq, &conntrack_gc_work.dwork, HZ);
 
+	register_kfunc_btf_id_set(&prog_test_kfunc_list, &nf_ct_skb_kfunc_set);
+	register_kfunc_btf_id_set(&xdp_kfunc_list, &nf_ct_xdp_kfunc_set);
+
 	return 0;
 
 err_proto:
-- 
2.34.1

