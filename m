Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C78A5943B9
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 00:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344229AbiHOWCq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 18:02:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350147AbiHOWBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 18:01:53 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CF4E112FB7;
        Mon, 15 Aug 2022 12:36:10 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 270B35C019F;
        Mon, 15 Aug 2022 15:36:06 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Mon, 15 Aug 2022 15:36:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1660592166; x=1660678566; bh=ba
        v66PMTSC/VY8B9jYgWNMdcK75gc9L0KS6MRDdO0Fo=; b=MKG6XBb5H97YS61px1
        y0qA2EjTU2nG7iZFDr32hZpHkP8TqM7W+dXr1XgkAAywlPLmTfAiUOIyn+rqpRTE
        cmSiWxxUaV2D+EwFkn6C5LbN7xqAqti887VvJlTAwKG4qzqYIVKjC5dkrJCZO54+
        S/PAu/u/vGTl6Hpbg0P2qWR4QQzsDjRez6+m2ei3APkQWWwQK/4bZHOyewA3Ljmr
        yQJF3D9aVQ1sQzcO1JvC6dsV6exDnRpzyPNlKF8XQn0U5XAuoKvdNGvqGZS1jAQV
        sPJ27F4yzmsQ7tN4t0qv8ITYtkKOkFKaF9+Wg3LH902mO3pNPavih6B3niZrNu/k
        HqMw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1660592166; x=1660678566; bh=bav66PMTSC/VY
        8B9jYgWNMdcK75gc9L0KS6MRDdO0Fo=; b=oWHZdtc+ZTD55xjf82gv0R46PXHDC
        nEBndVyy9cMut8/1UDYam64wZu9NCFUbG1zGx80/SwbJjo6inFBXIt3vK6izaf8R
        bzXRR6rzsYoWyM1N5WEf3bysiw314TbcW/19L5wlYxwEVVPFLaBSsU5mHS/HM5yO
        Zc8MXWu9XE9msVZoKQQfR2//8L4ohc7bvqtTUy16+YguvYgi06RkcbJDfpQeq/o6
        s9+0J9/1ydhGYKWwN5xh2jr5lu3IFGnuP66e2z8dfwEGZ4/kfXx2QQWx3lacfImg
        VwI0t+ik9eS9t4Op7ZhnjCoOHDtbiHLT9Mwwor+E1y+mYyoS6Hh1bk+iA==
X-ME-Sender: <xms:JaD6YjMvU9WtketLpI15JLt4AygbBp8ZLtvwUyyhRjrjxz3IlLQ5jQ>
    <xme:JaD6Yt8GzZXokBxA2VLb8Si9gd92tGekCTHw0xkQ-K42JQruCcg7NaNJc4BmmYaZR
    RSrmDHkOFF1EwxgXg>
X-ME-Received: <xmr:JaD6YiSfbKvDrQdNIBuVKqrDHuXSY8-IGj08VIXWSn4NdnvxyuNPvSACYyjzhGYvfrLd9CSIujs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdehvddgudegudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdejtddmnecujfgurhephf
    fvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepffgrnhhivghlucgiuhcu
    oegugihusegugihuuhhurdighiiiqeenucggtffrrghtthgvrhhnpefgfefggeejhfduie
    ekvdeuteffleeifeeuvdfhheejleejjeekgfffgefhtddtteenucevlhhushhtvghrufhi
    iigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegugihusegugihuuhhurdighiii
X-ME-Proxy: <xmx:JqD6YnuGTcYzzssB7lZSrGi25qEPISe_QUhJZmB19zJm9oghGBhHJQ>
    <xmx:JqD6YreIfPVzz-p5LgldL_czrKIWxkF8j0_fKllKoPvHgqFWNClRJA>
    <xmx:JqD6Yj08daQpO7VCn0E1wj-CQHdULUjVWcZpXk-SE2mluGEmMMuyBQ>
    <xmx:JqD6Yv47jSEtpSGzJzy1MKFXIo0LlxO8QYq-j0YrOUhhH4m6nlrvfg>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 15 Aug 2022 15:36:04 -0400 (EDT)
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, memxor@gmail.com
Cc:     Daniel Xu <dxu@dxuuu.xyz>, pablo@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next 2/3] bpf: Add support for writing to nf_conn:mark
Date:   Mon, 15 Aug 2022 13:35:47 -0600
Message-Id: <f850bb7e20950736d9175c61d7e0691098e06182.1660592020.git.dxu@dxuuu.xyz>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <cover.1660592020.git.dxu@dxuuu.xyz>
References: <cover.1660592020.git.dxu@dxuuu.xyz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        PDS_OTHER_BAD_TLD,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support direct writes to nf_conn:mark from TC and XDP prog types. This
is useful when applications want to store per-connection metadata. This
is also particularly useful for applications that run both bpf and
iptables/nftables because the latter can trivially access this metadata.

One example use case would be if a bpf prog is responsible for advanced
packet classification and iptables/nftables is later used for routing
due to pre-existing/legacy code.

Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
---
 include/net/netfilter/nf_conntrack_bpf.h | 18 +++++++++
 net/core/filter.c                        | 34 ++++++++++++++++
 net/netfilter/nf_conntrack_bpf.c         | 50 ++++++++++++++++++++++++
 3 files changed, 102 insertions(+)

diff --git a/include/net/netfilter/nf_conntrack_bpf.h b/include/net/netfilter/nf_conntrack_bpf.h
index a473b56842c5..0f584c2bd475 100644
--- a/include/net/netfilter/nf_conntrack_bpf.h
+++ b/include/net/netfilter/nf_conntrack_bpf.h
@@ -3,6 +3,7 @@
 #ifndef _NF_CONNTRACK_BPF_H
 #define _NF_CONNTRACK_BPF_H
 
+#include <linux/bpf.h>
 #include <linux/btf.h>
 #include <linux/kconfig.h>
 
@@ -10,6 +11,12 @@
     (IS_MODULE(CONFIG_NF_CONNTRACK) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF_MODULES))
 
 extern int register_nf_conntrack_bpf(void);
+extern int nf_conntrack_btf_struct_access(struct bpf_verifier_log *log,
+					  const struct btf *btf,
+					  const struct btf_type *t, int off,
+					  int size, enum bpf_access_type atype,
+					  u32 *next_btf_id,
+					  enum bpf_type_flag *flag);
 
 #else
 
@@ -18,6 +25,17 @@ static inline int register_nf_conntrack_bpf(void)
 	return 0;
 }
 
+static inline int
+nf_conntrack_btf_struct_access(struct bpf_verifier_log *log,
+			       const struct btf *btf,
+			       const struct btf_type *t, int off,
+			       int size, enum bpf_access_type atype,
+			       u32 *next_btf_id,
+			       enum bpf_type_flag *flag)
+{
+	return -EACCES;
+}
+
 #endif
 
 #endif /* _NF_CONNTRACK_BPF_H */
diff --git a/net/core/filter.c b/net/core/filter.c
index 5669248aff25..d7b768fe9de7 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -18,6 +18,7 @@
  */
 
 #include <linux/atomic.h>
+#include <linux/bpf_verifier.h>
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/mm.h>
@@ -55,6 +56,7 @@
 #include <net/sock_reuseport.h>
 #include <net/busy_poll.h>
 #include <net/tcp.h>
+#include <net/netfilter/nf_conntrack_bpf.h>
 #include <net/xfrm.h>
 #include <net/udp.h>
 #include <linux/bpf_trace.h>
@@ -8710,6 +8712,21 @@ static bool tc_cls_act_is_valid_access(int off, int size,
 	return bpf_skb_is_valid_access(off, size, type, prog, info);
 }
 
+static int tc_cls_act_btf_struct_access(struct bpf_verifier_log *log,
+					const struct btf *btf,
+					const struct btf_type *t, int off,
+					int size, enum bpf_access_type atype,
+					u32 *next_btf_id,
+					enum bpf_type_flag *flag)
+{
+	if (atype == BPF_READ)
+		return btf_struct_access(log, btf, t, off, size, atype, next_btf_id,
+					 flag);
+
+	return nf_conntrack_btf_struct_access(log, btf, t, off, size, atype,
+					      next_btf_id, flag);
+}
+
 static bool __is_valid_xdp_access(int off, int size)
 {
 	if (off < 0 || off >= sizeof(struct xdp_md))
@@ -8769,6 +8786,21 @@ void bpf_warn_invalid_xdp_action(struct net_device *dev, struct bpf_prog *prog,
 }
 EXPORT_SYMBOL_GPL(bpf_warn_invalid_xdp_action);
 
+static int xdp_btf_struct_access(struct bpf_verifier_log *log,
+				 const struct btf *btf,
+				 const struct btf_type *t, int off,
+				 int size, enum bpf_access_type atype,
+				 u32 *next_btf_id,
+				 enum bpf_type_flag *flag)
+{
+	if (atype == BPF_READ)
+		return btf_struct_access(log, btf, t, off, size, atype, next_btf_id,
+					 flag);
+
+	return nf_conntrack_btf_struct_access(log, btf, t, off, size, atype,
+					      next_btf_id, flag);
+}
+
 static bool sock_addr_is_valid_access(int off, int size,
 				      enum bpf_access_type type,
 				      const struct bpf_prog *prog,
@@ -10663,6 +10695,7 @@ const struct bpf_verifier_ops tc_cls_act_verifier_ops = {
 	.convert_ctx_access	= tc_cls_act_convert_ctx_access,
 	.gen_prologue		= tc_cls_act_prologue,
 	.gen_ld_abs		= bpf_gen_ld_abs,
+	.btf_struct_access	= tc_cls_act_btf_struct_access,
 };
 
 const struct bpf_prog_ops tc_cls_act_prog_ops = {
@@ -10674,6 +10707,7 @@ const struct bpf_verifier_ops xdp_verifier_ops = {
 	.is_valid_access	= xdp_is_valid_access,
 	.convert_ctx_access	= xdp_convert_ctx_access,
 	.gen_prologue		= bpf_noop_prologue,
+	.btf_struct_access	= xdp_btf_struct_access,
 };
 
 const struct bpf_prog_ops xdp_prog_ops = {
diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrack_bpf.c
index 1cd87b28c9b0..8010cc542d17 100644
--- a/net/netfilter/nf_conntrack_bpf.c
+++ b/net/netfilter/nf_conntrack_bpf.c
@@ -6,6 +6,7 @@
  * are exposed through to BPF programs is explicitly unstable.
  */
 
+#include <linux/bpf_verifier.h>
 #include <linux/bpf.h>
 #include <linux/btf.h>
 #include <linux/types.h>
@@ -15,6 +16,8 @@
 #include <net/netfilter/nf_conntrack_bpf.h>
 #include <net/netfilter/nf_conntrack_core.h>
 
+static const struct btf_type *nf_conn_type;
+
 /* bpf_ct_opts - Options for CT lookup helpers
  *
  * Members:
@@ -184,6 +187,53 @@ static struct nf_conn *__bpf_nf_ct_lookup(struct net *net,
 	return ct;
 }
 
+/* Check writes into `struct nf_conn` */
+int nf_conntrack_btf_struct_access(struct bpf_verifier_log *log,
+				   const struct btf *btf,
+				   const struct btf_type *t, int off,
+				   int size, enum bpf_access_type atype,
+				   u32 *next_btf_id,
+				   enum bpf_type_flag *flag)
+{
+	const struct btf_type *nct = READ_ONCE(nf_conn_type);
+	s32 type_id;
+	size_t end;
+
+	if (!nct) {
+		type_id = btf_find_by_name_kind(btf, "nf_conn", BTF_KIND_STRUCT);
+		if (type_id < 0)
+			return -EINVAL;
+
+		nct = btf_type_by_id(btf, type_id);
+		WRITE_ONCE(nf_conn_type, nct);
+	}
+
+	if (t != nct) {
+		bpf_log(log, "only read is supported\n");
+		return -EACCES;
+	}
+
+	switch (off) {
+#if defined(CONFIG_NF_CONNTRACK_MARK)
+	case offsetof(struct nf_conn, mark):
+		end = offsetofend(struct nf_conn, mark);
+		break;
+#endif
+	default:
+		bpf_log(log, "no write support to nf_conn at off %d\n", off);
+		return -EACCES;
+	}
+
+	if (off + size > end) {
+		bpf_log(log,
+			"write access at off %d with size %d beyond the member of nf_conn ended at %zu\n",
+			off, size, end);
+		return -EACCES;
+	}
+
+	return NOT_INIT;
+}
+
 __diag_push();
 __diag_ignore_all("-Wmissing-prototypes",
 		  "Global functions as their definitions will be in nf_conntrack BTF");
-- 
2.37.1

