Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE8FC558924
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 21:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbiFWTio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 15:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbiFWTiU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 15:38:20 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85DF26147;
        Thu, 23 Jun 2022 12:26:58 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id n16-20020a17090ade9000b001ed15b37424so567856pjv.3;
        Thu, 23 Jun 2022 12:26:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bDFbJEdB/P3JixXhBUuV2BjLPDM1rKcR6tflUpF/Kko=;
        b=TNkEkXYrjrsfWdgoYg6LHtS1qowQd8yt22d8xAtK1Jkh7QSKvN9KZ0GEqFXyFAUann
         Mcxw5S5JBlioV9QL5EuQ67TSt6U/ZnXwSqSLm/owo9UTX5+U0FviIQ7rlse/xIkwofmf
         PrW+/1mXfq4dgZkihcGfXHdD58STiSwcjMlnxJO2kuYsX6nEDj5jKlwofFuPLMlPTnkf
         QZn3/lw2qkqE3RGUuD3lqr3PJ7vSoYUqfyAdNyAxGA+zsnPlNXpgAHlbiNUE7f1qSVh3
         uiOiFqU58KlUdRh/A4Yz/JwKacKX9yra+ikbOCg4Xdfn4Q+77Odmd2QUvvvnuXTJoMl5
         LRpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bDFbJEdB/P3JixXhBUuV2BjLPDM1rKcR6tflUpF/Kko=;
        b=TO+RH5cMGRG/3uZAR9McdZrErE33FCXg8zY1/e4OL306tASlrI5fnBN7bn6oAvhFNc
         xtHNSRl02TjO7x2XdIw9d8NPLBXi8N/LBcTg0qiAXNt8iAhgpBP7mhRfhAXEaEL9wGPi
         6JBxgABS+Uu2h74ckEvHuuAC4C2o4s/5oPCmgOXzwfBIMghIJmQDd/rFxkeaH2LF1IhC
         nTurNo+0rroOKlJiO2NyG9VTgb8D+EuJQsaW84sMnUySVcTM1G2J/+fK2DJyFt4zHj5h
         wUzRlCYMI8IqdfswJgKftZQmjmPNLj7ha95lFxrC5eoySdVr/8MhEUMfjU65XRsL0jXX
         gkOA==
X-Gm-Message-State: AJIora+xUusjFEuPANIObFZkQbG9LkJ40dTrrBSCLFiNS9ai0tt7/M5q
        UB/Zutoqq0EPZ1F7LBiuqrVLvorFKwD1Ng==
X-Google-Smtp-Source: AGRyM1s6ow9KD5PbkehQv0VdqsjiWvkXYpuoKqpJC8Qa39Ji7w0UkA+G/S/WgTsbLDbehDNmMjGuhA==
X-Received: by 2002:a17:90b:1651:b0:1ec:f358:3dbd with SMTP id il17-20020a17090b165100b001ecf3583dbdmr5454996pjb.157.1656012417497;
        Thu, 23 Jun 2022 12:26:57 -0700 (PDT)
Received: from localhost ([2405:201:6014:d0c0:79de:f3f4:353c:8616])
        by smtp.gmail.com with ESMTPSA id h11-20020a63b00b000000b0040c99f8bcb7sm10096419pgf.58.2022.06.23.12.26.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 12:26:57 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH bpf-next v5 3/8] net: netfilter: Add kfuncs to allocate and insert CT
Date:   Fri, 24 Jun 2022 00:56:32 +0530
Message-Id: <20220623192637.3866852-4-memxor@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623192637.3866852-1-memxor@gmail.com>
References: <20220623192637.3866852-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=11966; i=memxor@gmail.com; h=from:subject; bh=hImtfypm4ms+l9z9FG5wGlc8B7doZByfHZBiAQNdJoE=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBitL5Lilul3EBUFRZ+CPl1idOY1kvt8WrzEXGKtRSL Pp/gykuJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYrS+SwAKCRBM4MiGSL8RyocyD/ 0arWBRpaQ4oK/kVmBuyLe9a6WK1MpxJMrylFdrJYr5K7PDwtsZmUuSnTLxXykDsbBa6AobLiS3731q qx7ECPC9+gtHlhBgJr8Kf+olxK9jj5dDGsW3d132BWsOuBkernZqAFISJ0ubLlTLVbJ5cqcDBflYFC eUa28vISQ9OesXGtLFnbv7nT6Ug5ubh/j3bQXw1SirlKGFJKsCW10tCRRw0ejPK+3wzsz7P/vrMvC6 BYPPWOf9mEsOwotFhykhzgOojz5en2oo9Ouu6Gg5P0qYIUN3pubKKkS4BMaqDQMWNAyO02LQC0KO++ lXW9OgL1wENBPrKrYs8tDmij0Mp37MlVs9VmAE9rQliXyTV6yKQqQ78mJ5GjbISI1OWfWGsOZFCQut cAp7lCcz3YZFDxh8HYi9IDYYWY6trLQj1BVnDprSFAnMp1OqWXRRPES/GXSjvobXX+o2AYXfCqFP7W ZbMV8y4OKxBInbJj76tYBfn1IGjTC+2LHXCzAcRWntC0QxQzKWBViaV4mLrJaSvfVUFqvSW4fR8Tuc dYGV0woQzwqwJcaluxhYwyF+cqV1g8rKrwJ8/E6MiIrCUptCDv1CKc9ZwEvySoLl7VkvI+/Hq09PbO x54zJ/o8J6d0oR77M32yhBK/bgW+x0t68DAfngNDFVZWfGdfTbS9dtQ9SXmg==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

Introduce bpf_xdp_ct_alloc, bpf_skb_ct_alloc and bpf_ct_insert_entry
kfuncs in order to insert a new entry from XDP and TC programs.
Introduce bpf_nf_ct_tuple_parse utility routine to consolidate common
code.

We extract out a helper __nf_ct_set_timeout, used by the ctnetlink and
nf_conntrack_bpf code, extract it out to nf_conntrack_core, so that
nf_conntrack_bpf doesn't need a dependency on CONFIG_NF_CT_NETLINK.
Later this helper will be reused as a helper to set timeout of allocated
but not yet inserted CT entry.

The allocation functions return struct nf_conn___init instead of
nf_conn, to distinguish allocated CT from an already inserted or looked
up CT. This is later used to enforce restrictions on what kfuncs
allocated CT can be used with.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Co-developed-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/net/netfilter/nf_conntrack_core.h |  15 ++
 net/netfilter/nf_conntrack_bpf.c          | 213 +++++++++++++++++++---
 net/netfilter/nf_conntrack_netlink.c      |   8 +-
 3 files changed, 209 insertions(+), 27 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index 37866c8386e2..83a60c684e6c 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -84,4 +84,19 @@ void nf_conntrack_lock(spinlock_t *lock);
 
 extern spinlock_t nf_conntrack_expect_lock;
 
+/* ctnetlink code shared by both ctnetlink and nf_conntrack_bpf */
+
+#if (IS_BUILTIN(CONFIG_NF_CONNTRACK) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF)) || \
+    (IS_MODULE(CONFIG_NF_CONNTRACK) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF_MODULES) || \
+    IS_ENABLED(CONFIG_NF_CT_NETLINK))
+
+static inline void __nf_ct_set_timeout(struct nf_conn *ct, u64 timeout)
+{
+	if (timeout > INT_MAX)
+		timeout = INT_MAX;
+	WRITE_ONCE(ct->timeout, nfct_time_stamp + (u32)timeout);
+}
+
+#endif
+
 #endif /* _NF_CONNTRACK_CORE_H */
diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrack_bpf.c
index 5cb1820054fb..1d3c1d1e2d8b 100644
--- a/net/netfilter/nf_conntrack_bpf.c
+++ b/net/netfilter/nf_conntrack_bpf.c
@@ -55,6 +55,94 @@ enum {
 	NF_BPF_CT_OPTS_SZ = 12,
 };
 
+static int bpf_nf_ct_tuple_parse(struct bpf_sock_tuple *bpf_tuple,
+				 u32 tuple_len, u8 protonum, u8 dir,
+				 struct nf_conntrack_tuple *tuple)
+{
+	union nf_inet_addr *src = dir ? &tuple->dst.u3 : &tuple->src.u3;
+	union nf_inet_addr *dst = dir ? &tuple->src.u3 : &tuple->dst.u3;
+	union nf_conntrack_man_proto *sport = dir ? (void *)&tuple->dst.u
+						  : &tuple->src.u;
+	union nf_conntrack_man_proto *dport = dir ? &tuple->src.u
+						  : (void *)&tuple->dst.u;
+
+	if (unlikely(protonum != IPPROTO_TCP && protonum != IPPROTO_UDP))
+		return -EPROTO;
+
+	memset(tuple, 0, sizeof(*tuple));
+
+	switch (tuple_len) {
+	case sizeof(bpf_tuple->ipv4):
+		tuple->src.l3num = AF_INET;
+		src->ip = bpf_tuple->ipv4.saddr;
+		sport->tcp.port = bpf_tuple->ipv4.sport;
+		dst->ip = bpf_tuple->ipv4.daddr;
+		dport->tcp.port = bpf_tuple->ipv4.dport;
+		break;
+	case sizeof(bpf_tuple->ipv6):
+		tuple->src.l3num = AF_INET6;
+		memcpy(src->ip6, bpf_tuple->ipv6.saddr, sizeof(bpf_tuple->ipv6.saddr));
+		sport->tcp.port = bpf_tuple->ipv6.sport;
+		memcpy(dst->ip6, bpf_tuple->ipv6.daddr, sizeof(bpf_tuple->ipv6.daddr));
+		dport->tcp.port = bpf_tuple->ipv6.dport;
+		break;
+	default:
+		return -EAFNOSUPPORT;
+	}
+	tuple->dst.protonum = protonum;
+	tuple->dst.dir = dir;
+
+	return 0;
+}
+
+static struct nf_conn *
+__bpf_nf_ct_alloc_entry(struct net *net, struct bpf_sock_tuple *bpf_tuple,
+			u32 tuple_len, struct bpf_ct_opts *opts, u32 opts_len,
+			u32 timeout)
+{
+	struct nf_conntrack_tuple otuple, rtuple;
+	struct nf_conn *ct;
+	int err;
+
+	if (!opts || !bpf_tuple || opts->reserved[0] || opts->reserved[1] ||
+	    opts_len != NF_BPF_CT_OPTS_SZ)
+		return ERR_PTR(-EINVAL);
+
+	if (unlikely(opts->netns_id < BPF_F_CURRENT_NETNS))
+		return ERR_PTR(-EINVAL);
+
+	err = bpf_nf_ct_tuple_parse(bpf_tuple, tuple_len, opts->l4proto,
+				    IP_CT_DIR_ORIGINAL, &otuple);
+	if (err < 0)
+		return ERR_PTR(err);
+
+	err = bpf_nf_ct_tuple_parse(bpf_tuple, tuple_len, opts->l4proto,
+				    IP_CT_DIR_REPLY, &rtuple);
+	if (err < 0)
+		return ERR_PTR(err);
+
+	if (opts->netns_id >= 0) {
+		net = get_net_ns_by_id(net, opts->netns_id);
+		if (unlikely(!net))
+			return ERR_PTR(-ENONET);
+	}
+
+	ct = nf_conntrack_alloc(net, &nf_ct_zone_dflt, &otuple, &rtuple,
+				GFP_ATOMIC);
+	if (IS_ERR(ct))
+		goto out;
+
+	memset(&ct->proto, 0, sizeof(ct->proto));
+	__nf_ct_set_timeout(ct, timeout * HZ);
+	ct->status |= IPS_CONFIRMED;
+
+out:
+	if (opts->netns_id >= 0)
+		put_net(net);
+
+	return ct;
+}
+
 static struct nf_conn *__bpf_nf_ct_lookup(struct net *net,
 					  struct bpf_sock_tuple *bpf_tuple,
 					  u32 tuple_len, struct bpf_ct_opts *opts,
@@ -63,6 +151,7 @@ static struct nf_conn *__bpf_nf_ct_lookup(struct net *net,
 	struct nf_conntrack_tuple_hash *hash;
 	struct nf_conntrack_tuple tuple;
 	struct nf_conn *ct;
+	int err;
 
 	if (!opts || !bpf_tuple || opts->reserved[0] || opts->reserved[1] ||
 	    opts_len != NF_BPF_CT_OPTS_SZ)
@@ -72,27 +161,10 @@ static struct nf_conn *__bpf_nf_ct_lookup(struct net *net,
 	if (unlikely(opts->netns_id < BPF_F_CURRENT_NETNS))
 		return ERR_PTR(-EINVAL);
 
-	memset(&tuple, 0, sizeof(tuple));
-	switch (tuple_len) {
-	case sizeof(bpf_tuple->ipv4):
-		tuple.src.l3num = AF_INET;
-		tuple.src.u3.ip = bpf_tuple->ipv4.saddr;
-		tuple.src.u.tcp.port = bpf_tuple->ipv4.sport;
-		tuple.dst.u3.ip = bpf_tuple->ipv4.daddr;
-		tuple.dst.u.tcp.port = bpf_tuple->ipv4.dport;
-		break;
-	case sizeof(bpf_tuple->ipv6):
-		tuple.src.l3num = AF_INET6;
-		memcpy(tuple.src.u3.ip6, bpf_tuple->ipv6.saddr, sizeof(bpf_tuple->ipv6.saddr));
-		tuple.src.u.tcp.port = bpf_tuple->ipv6.sport;
-		memcpy(tuple.dst.u3.ip6, bpf_tuple->ipv6.daddr, sizeof(bpf_tuple->ipv6.daddr));
-		tuple.dst.u.tcp.port = bpf_tuple->ipv6.dport;
-		break;
-	default:
-		return ERR_PTR(-EAFNOSUPPORT);
-	}
-
-	tuple.dst.protonum = opts->l4proto;
+	err = bpf_nf_ct_tuple_parse(bpf_tuple, tuple_len, opts->l4proto,
+				    IP_CT_DIR_ORIGINAL, &tuple);
+	if (err < 0)
+		return ERR_PTR(err);
 
 	if (opts->netns_id >= 0) {
 		net = get_net_ns_by_id(net, opts->netns_id);
@@ -116,6 +188,43 @@ __diag_push();
 __diag_ignore_all("-Wmissing-prototypes",
 		  "Global functions as their definitions will be in nf_conntrack BTF");
 
+struct nf_conn___init {
+	struct nf_conn ct;
+};
+
+/* bpf_xdp_ct_alloc - Allocate a new CT entry
+ *
+ * Parameters:
+ * @xdp_ctx	- Pointer to ctx (xdp_md) in XDP program
+ *		    Cannot be NULL
+ * @bpf_tuple	- Pointer to memory representing the tuple to look up
+ *		    Cannot be NULL
+ * @tuple__sz	- Length of the tuple structure
+ *		    Must be one of sizeof(bpf_tuple->ipv4) or
+ *		    sizeof(bpf_tuple->ipv6)
+ * @opts	- Additional options for allocation (documented above)
+ *		    Cannot be NULL
+ * @opts__sz	- Length of the bpf_ct_opts structure
+ *		    Must be NF_BPF_CT_OPTS_SZ (12)
+ */
+struct nf_conn___init *
+bpf_xdp_ct_alloc(struct xdp_md *xdp_ctx, struct bpf_sock_tuple *bpf_tuple,
+		 u32 tuple__sz, struct bpf_ct_opts *opts, u32 opts__sz)
+{
+	struct xdp_buff *ctx = (struct xdp_buff *)xdp_ctx;
+	struct nf_conn *nfct;
+
+	nfct = __bpf_nf_ct_alloc_entry(dev_net(ctx->rxq->dev), bpf_tuple, tuple__sz,
+				       opts, opts__sz, 10);
+	if (IS_ERR(nfct)) {
+		if (opts)
+			opts->error = PTR_ERR(nfct);
+		return NULL;
+	}
+
+	return (struct nf_conn___init *)nfct;
+}
+
 /* bpf_xdp_ct_lookup - Lookup CT entry for the given tuple, and acquire a
  *		       reference to it
  *
@@ -150,6 +259,40 @@ bpf_xdp_ct_lookup(struct xdp_md *xdp_ctx, struct bpf_sock_tuple *bpf_tuple,
 	return nfct;
 }
 
+/* bpf_skb_ct_alloc - Allocate a new CT entry
+ *
+ * Parameters:
+ * @skb_ctx	- Pointer to ctx (__sk_buff) in TC program
+ *		    Cannot be NULL
+ * @bpf_tuple	- Pointer to memory representing the tuple to look up
+ *		    Cannot be NULL
+ * @tuple__sz	- Length of the tuple structure
+ *		    Must be one of sizeof(bpf_tuple->ipv4) or
+ *		    sizeof(bpf_tuple->ipv6)
+ * @opts	- Additional options for allocation (documented above)
+ *		    Cannot be NULL
+ * @opts__sz	- Length of the bpf_ct_opts structure
+ *		    Must be NF_BPF_CT_OPTS_SZ (12)
+ */
+struct nf_conn___init *
+bpf_skb_ct_alloc(struct __sk_buff *skb_ctx, struct bpf_sock_tuple *bpf_tuple,
+		 u32 tuple__sz, struct bpf_ct_opts *opts, u32 opts__sz)
+{
+	struct sk_buff *skb = (struct sk_buff *)skb_ctx;
+	struct nf_conn *nfct;
+	struct net *net;
+
+	net = skb->dev ? dev_net(skb->dev) : sock_net(skb->sk);
+	nfct = __bpf_nf_ct_alloc_entry(net, bpf_tuple, tuple__sz, opts, opts__sz, 10);
+	if (IS_ERR(nfct)) {
+		if (opts)
+			opts->error = PTR_ERR(nfct);
+		return NULL;
+	}
+
+	return (struct nf_conn___init *)nfct;
+}
+
 /* bpf_skb_ct_lookup - Lookup CT entry for the given tuple, and acquire a
  *		       reference to it
  *
@@ -184,6 +327,26 @@ bpf_skb_ct_lookup(struct __sk_buff *skb_ctx, struct bpf_sock_tuple *bpf_tuple,
 	return nfct;
 }
 
+/* bpf_ct_insert_entry - Add the provided entry into a CT map
+ *
+ * This must be invoked for referenced PTR_TO_BTF_ID.
+ *
+ * @nfct__ref	 - Pointer to referenced nf_conn___init object, obtained
+ *		   using bpf_xdp_ct_alloc or bpf_skb_ct_alloc.
+ */
+struct nf_conn *bpf_ct_insert_entry(struct nf_conn___init *nfct__ref)
+{
+	struct nf_conn *nfct = (struct nf_conn *)nfct__ref;
+	int err;
+
+	err = nf_conntrack_hash_check_insert(nfct);
+	if (err < 0) {
+		nf_conntrack_free(nfct);
+		return NULL;
+	}
+	return nfct;
+}
+
 /* bpf_ct_release - Release acquired nf_conn object
  *
  * This must be invoked for referenced PTR_TO_BTF_ID, and the verifier rejects
@@ -204,21 +367,29 @@ void bpf_ct_release(struct nf_conn *nfct)
 __diag_pop()
 
 BTF_SET_START(nf_ct_xdp_check_kfunc_ids)
+BTF_ID(func, bpf_xdp_ct_alloc)
 BTF_ID(func, bpf_xdp_ct_lookup)
+BTF_ID(func, bpf_ct_insert_entry)
 BTF_ID(func, bpf_ct_release)
 BTF_SET_END(nf_ct_xdp_check_kfunc_ids)
 
 BTF_SET_START(nf_ct_tc_check_kfunc_ids)
+BTF_ID(func, bpf_skb_ct_alloc)
 BTF_ID(func, bpf_skb_ct_lookup)
+BTF_ID(func, bpf_ct_insert_entry)
 BTF_ID(func, bpf_ct_release)
 BTF_SET_END(nf_ct_tc_check_kfunc_ids)
 
 BTF_SET_START(nf_ct_acquire_kfunc_ids)
+BTF_ID(func, bpf_xdp_ct_alloc)
 BTF_ID(func, bpf_xdp_ct_lookup)
+BTF_ID(func, bpf_skb_ct_alloc)
 BTF_ID(func, bpf_skb_ct_lookup)
+BTF_ID(func, bpf_ct_insert_entry)
 BTF_SET_END(nf_ct_acquire_kfunc_ids)
 
 BTF_SET_START(nf_ct_release_kfunc_ids)
+BTF_ID(func, bpf_ct_insert_entry)
 BTF_ID(func, bpf_ct_release)
 BTF_SET_END(nf_ct_release_kfunc_ids)
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 722af5e309ba..0729b2f0d44f 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2025,9 +2025,7 @@ static int ctnetlink_change_timeout(struct nf_conn *ct,
 {
 	u64 timeout = (u64)ntohl(nla_get_be32(cda[CTA_TIMEOUT])) * HZ;
 
-	if (timeout > INT_MAX)
-		timeout = INT_MAX;
-	WRITE_ONCE(ct->timeout, nfct_time_stamp + (u32)timeout);
+	__nf_ct_set_timeout(ct, timeout);
 
 	if (test_bit(IPS_DYING_BIT, &ct->status))
 		return -ETIME;
@@ -2292,9 +2290,7 @@ ctnetlink_create_conntrack(struct net *net,
 		goto err1;
 
 	timeout = (u64)ntohl(nla_get_be32(cda[CTA_TIMEOUT])) * HZ;
-	if (timeout > INT_MAX)
-		timeout = INT_MAX;
-	ct->timeout = (u32)timeout + nfct_time_stamp;
+	__nf_ct_set_timeout(ct, timeout);
 
 	rcu_read_lock();
  	if (cda[CTA_HELP]) {
-- 
2.36.1

