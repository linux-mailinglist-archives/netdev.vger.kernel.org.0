Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4A2C5B0A4F
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 18:41:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbiIGQlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 12:41:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiIGQlQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 12:41:16 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 513B36F271;
        Wed,  7 Sep 2022 09:41:15 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id AD3955C012E;
        Wed,  7 Sep 2022 12:41:14 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 07 Sep 2022 12:41:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm1; t=1662568874; x=1662655274; bh=aL
        Me3hfwrfUYHRBTM9OM468pvSm6sK4LPXiHdUtizGA=; b=KY63N1HFip65odDm+0
        5iFjJ5q4V9vmioJBMalPzSEc/F+9bJxSOkY+2VKIz5NO0yGoW9WVtuaw4mcYMVwP
        vXjPezEnH9Jso8YWXqY4bn7R9LT/kl/O6/DgmAAziFYxJHLXr9NG8EMm/1wGa/y+
        AlPU1q3f44RCaYmdmaZOyu5IBQFerfQ3mnnFyjkT1pDnutD3QSqzQqV5tbqDT0k7
        DcMXQTTrEBN67bmih//JxwgWxkxaq6/bLgs1+k7aWR5XeU+wawO0BciwnZjLzHv+
        Erx6UrwdPYEgIyctlpM+FNJHYzDPUpBkkJPqrFuASXtrBw2aZMaFduyDq8IvWyIV
        CH4w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1662568874; x=1662655274; bh=aLMe3hfwrfUYH
        RBTM9OM468pvSm6sK4LPXiHdUtizGA=; b=HjS/kQ3kHFIBygxzNrPtHQ5uM/kqE
        Uuru3pgjg4UtmvTC4+fhQN4GUwuVugMVEnSEAb72LXlO4FRn4wJHKN3/YtUgdwiK
        X66x7ojt6Ia+G7AMmaVfdX2sHoZhWsaHUlVpBGeDRz+jxqAHD1dmk9dwLy0VucNK
        0MEDuEfKAsNN98VDOJzKI3drW7Y4kg6sG5hT78yHY9vGjGoJUNTK1LKniPCRjvdp
        T5LYDSfGiHYjQwBIcp+ZLtGFciZ6S5USTVxQwUYS5dIrciOtMz36l2cgJZytXnIK
        RwwqWiaaA84hy6fN4/GLpL1IL6PReKGJv2BIMKO/GGVj8f6JlmAcAc2HQ==
X-ME-Sender: <xms:qskYY1eO4XBQdvWB2Ceow9vg1f9KiI1CvKj1essYQcjLO1jbGrBYWA>
    <xme:qskYYzPhFahTOpUz0DohboBOaaf9jgL4KHDvDi-DSnPKT_8cxZHF-lYOv0fTNOYCx
    pElom1UY9xQeKYMVA>
X-ME-Received: <xmr:qskYY-gMCQYq05I7oRVCaoW5hix7ORgzU9WvILeqjSpn3Vk2ZOWMiYGvgI4iVgVlnH8DaorYHvQZh6fdBNF8QZ2efa9L8T-CNDI5ySc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfedttddguddtgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdejtddmnecujfgurhephf
    fvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepffgrnhhivghlucgiuhcu
    oegugihusegugihuuhhurdighiiiqeenucggtffrrghtthgvrhhnpefgfefggeejhfduie
    ekvdeuteffleeifeeuvdfhheejleejjeekgfffgefhtddtteenucevlhhushhtvghrufhi
    iigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegugihusegugihuuhhurdighiii
X-ME-Proxy: <xmx:qskYY-9aNg7o1Ek-2mstA-PyO2uGceaL6dPA7yNdPc3_R01Tvm3Mig>
    <xmx:qskYYxs2bzXvDKU7EkgUFamv4jMl_vcFa5d-1scVOn3U6o4Vtp28Xg>
    <xmx:qskYY9HnwHZk23rDQ5bkxEhQAixfFX9YpbI4TCohLr7HLJh7jkW-EQ>
    <xmx:qskYY9GQFFKgc6pdIndOIR4hQVBVNgh5TOjBOOydFitSnGoz67fvsQ>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 7 Sep 2022 12:41:13 -0400 (EDT)
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, memxor@gmail.com
Cc:     Daniel Xu <dxu@dxuuu.xyz>, pablo@netfilter.org, fw@strlen.de,
        toke@kernel.org, martin.lau@linux.dev,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v5 5/6] bpf: Add support for writing to nf_conn:mark
Date:   Wed,  7 Sep 2022 10:40:40 -0600
Message-Id: <ebca06dea366e3e7e861c12f375a548cc4c61108.1662568410.git.dxu@dxuuu.xyz>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <cover.1662568410.git.dxu@dxuuu.xyz>
References: <cover.1662568410.git.dxu@dxuuu.xyz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        PDS_OTHER_BAD_TLD,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
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
 include/net/netfilter/nf_conntrack_bpf.h | 23 +++++++++
 net/core/filter.c                        | 54 +++++++++++++++++++
 net/netfilter/nf_conntrack_bpf.c         | 66 +++++++++++++++++++++++-
 net/netfilter/nf_conntrack_core.c        |  1 +
 4 files changed, 143 insertions(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_conntrack_bpf.h b/include/net/netfilter/nf_conntrack_bpf.h
index a473b56842c5..a61a93d1c6dc 100644
--- a/include/net/netfilter/nf_conntrack_bpf.h
+++ b/include/net/netfilter/nf_conntrack_bpf.h
@@ -3,13 +3,22 @@
 #ifndef _NF_CONNTRACK_BPF_H
 #define _NF_CONNTRACK_BPF_H
 
+#include <linux/bpf.h>
 #include <linux/btf.h>
 #include <linux/kconfig.h>
+#include <linux/mutex.h>
 
 #if (IS_BUILTIN(CONFIG_NF_CONNTRACK) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF)) || \
     (IS_MODULE(CONFIG_NF_CONNTRACK) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF_MODULES))
 
 extern int register_nf_conntrack_bpf(void);
+extern void cleanup_nf_conntrack_bpf(void);
+
+extern struct mutex nf_conn_btf_access_lock;
+extern int (*nfct_bsa)(struct bpf_verifier_log *log, const struct btf *btf,
+		       const struct btf_type *t, int off, int size,
+		       enum bpf_access_type atype, u32 *next_btf_id,
+		       enum bpf_type_flag *flag);
 
 #else
 
@@ -18,6 +27,20 @@ static inline int register_nf_conntrack_bpf(void)
 	return 0;
 }
 
+static inline void cleanup_nf_conntrack_bpf(void)
+{
+}
+
+static inline int nf_conntrack_btf_struct_access(struct bpf_verifier_log *log,
+						 const struct btf *btf,
+						 const struct btf_type *t, int off,
+						 int size, enum bpf_access_type atype,
+						 u32 *next_btf_id,
+						 enum bpf_type_flag *flag)
+{
+	return -EACCES;
+}
+
 #endif
 
 #endif /* _NF_CONNTRACK_BPF_H */
diff --git a/net/core/filter.c b/net/core/filter.c
index e872f45399b0..4b2be211bcbe 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -18,6 +18,7 @@
  */
 
 #include <linux/atomic.h>
+#include <linux/bpf_verifier.h>
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/mm.h>
@@ -8604,6 +8605,36 @@ static bool tc_cls_act_is_valid_access(int off, int size,
 	return bpf_skb_is_valid_access(off, size, type, prog, info);
 }
 
+DEFINE_MUTEX(nf_conn_btf_access_lock);
+EXPORT_SYMBOL_GPL(nf_conn_btf_access_lock);
+
+int (*nfct_bsa)(struct bpf_verifier_log *log, const struct btf *btf,
+		const struct btf_type *t, int off, int size,
+		enum bpf_access_type atype, u32 *next_btf_id,
+		enum bpf_type_flag *flag);
+EXPORT_SYMBOL_GPL(nfct_bsa);
+
+static int tc_cls_act_btf_struct_access(struct bpf_verifier_log *log,
+					const struct btf *btf,
+					const struct btf_type *t, int off,
+					int size, enum bpf_access_type atype,
+					u32 *next_btf_id,
+					enum bpf_type_flag *flag)
+{
+	int ret = -EACCES;
+
+	if (atype == BPF_READ)
+		return btf_struct_access(log, btf, t, off, size, atype, next_btf_id,
+					 flag);
+
+	mutex_lock(&nf_conn_btf_access_lock);
+	if (nfct_bsa)
+		ret = nfct_bsa(log, btf, t, off, size, atype, next_btf_id, flag);
+	mutex_unlock(&nf_conn_btf_access_lock);
+
+	return ret;
+}
+
 static bool __is_valid_xdp_access(int off, int size)
 {
 	if (off < 0 || off >= sizeof(struct xdp_md))
@@ -8663,6 +8694,27 @@ void bpf_warn_invalid_xdp_action(struct net_device *dev, struct bpf_prog *prog,
 }
 EXPORT_SYMBOL_GPL(bpf_warn_invalid_xdp_action);
 
+static int xdp_btf_struct_access(struct bpf_verifier_log *log,
+				 const struct btf *btf,
+				 const struct btf_type *t, int off,
+				 int size, enum bpf_access_type atype,
+				 u32 *next_btf_id,
+				 enum bpf_type_flag *flag)
+{
+	int ret = -EACCES;
+
+	if (atype == BPF_READ)
+		return btf_struct_access(log, btf, t, off, size, atype, next_btf_id,
+					 flag);
+
+	mutex_lock(&nf_conn_btf_access_lock);
+	if (nfct_bsa)
+		ret = nfct_bsa(log, btf, t, off, size, atype, next_btf_id, flag);
+	mutex_unlock(&nf_conn_btf_access_lock);
+
+	return ret;
+}
+
 static bool sock_addr_is_valid_access(int off, int size,
 				      enum bpf_access_type type,
 				      const struct bpf_prog *prog,
@@ -10557,6 +10609,7 @@ const struct bpf_verifier_ops tc_cls_act_verifier_ops = {
 	.convert_ctx_access	= tc_cls_act_convert_ctx_access,
 	.gen_prologue		= tc_cls_act_prologue,
 	.gen_ld_abs		= bpf_gen_ld_abs,
+	.btf_struct_access	= tc_cls_act_btf_struct_access,
 };
 
 const struct bpf_prog_ops tc_cls_act_prog_ops = {
@@ -10568,6 +10621,7 @@ const struct bpf_verifier_ops xdp_verifier_ops = {
 	.is_valid_access	= xdp_is_valid_access,
 	.convert_ctx_access	= xdp_convert_ctx_access,
 	.gen_prologue		= bpf_noop_prologue,
+	.btf_struct_access	= xdp_btf_struct_access,
 };
 
 const struct bpf_prog_ops xdp_prog_ops = {
diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrack_bpf.c
index 1cd87b28c9b0..77eb8e959f61 100644
--- a/net/netfilter/nf_conntrack_bpf.c
+++ b/net/netfilter/nf_conntrack_bpf.c
@@ -6,8 +6,10 @@
  * are exposed through to BPF programs is explicitly unstable.
  */
 
+#include <linux/bpf_verifier.h>
 #include <linux/bpf.h>
 #include <linux/btf.h>
+#include <linux/mutex.h>
 #include <linux/types.h>
 #include <linux/btf_ids.h>
 #include <linux/net_namespace.h>
@@ -184,6 +186,54 @@ static struct nf_conn *__bpf_nf_ct_lookup(struct net *net,
 	return ct;
 }
 
+BTF_ID_LIST(btf_nf_conn_ids)
+BTF_ID(struct, nf_conn)
+BTF_ID(struct, nf_conn___init)
+
+/* Check writes into `struct nf_conn` */
+static int _nf_conntrack_btf_struct_access(struct bpf_verifier_log *log,
+					   const struct btf *btf,
+					   const struct btf_type *t, int off,
+					   int size, enum bpf_access_type atype,
+					   u32 *next_btf_id,
+					   enum bpf_type_flag *flag)
+{
+	const struct btf_type *ncit;
+	const struct btf_type *nct;
+	size_t end;
+
+	ncit = btf_type_by_id(btf, btf_nf_conn_ids[1]);
+	nct = btf_type_by_id(btf, btf_nf_conn_ids[0]);
+
+	if (t != nct && t != ncit) {
+		bpf_log(log, "only read is supported\n");
+		return -EACCES;
+	}
+
+	/* `struct nf_conn` and `struct nf_conn___init` have the same layout
+	 * so we are safe to simply merge offset checks here
+	 */
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
+	return 0;
+}
+
 __diag_push();
 __diag_ignore_all("-Wmissing-prototypes",
 		  "Global functions as their definitions will be in nf_conntrack BTF");
@@ -449,5 +499,19 @@ int register_nf_conntrack_bpf(void)
 	int ret;
 
 	ret = register_btf_kfunc_id_set(BPF_PROG_TYPE_XDP, &nf_conntrack_kfunc_set);
-	return ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_CLS, &nf_conntrack_kfunc_set);
+	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_CLS, &nf_conntrack_kfunc_set);
+	if (!ret) {
+		mutex_lock(&nf_conn_btf_access_lock);
+		nfct_bsa = _nf_conntrack_btf_struct_access;
+		mutex_unlock(&nf_conn_btf_access_lock);
+	}
+
+	return ret;
+}
+
+void cleanup_nf_conntrack_bpf(void)
+{
+	mutex_lock(&nf_conn_btf_access_lock);
+	nfct_bsa = NULL;
+	mutex_unlock(&nf_conn_btf_access_lock);
 }
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index da65c6e8eeeb..0195f60fc43b 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2512,6 +2512,7 @@ static int kill_all(struct nf_conn *i, void *data)
 
 void nf_conntrack_cleanup_start(void)
 {
+	cleanup_nf_conntrack_bpf();
 	conntrack_gc_work.exiting = true;
 }
 
-- 
2.37.1

