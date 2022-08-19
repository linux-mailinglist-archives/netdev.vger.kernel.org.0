Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9D759A951
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 01:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244186AbiHSXYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 19:24:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244167AbiHSXYA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 19:24:00 -0400
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E2A92B1A8;
        Fri, 19 Aug 2022 16:23:57 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 8FC1F32006F5;
        Fri, 19 Aug 2022 19:23:55 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 19 Aug 2022 19:23:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1660951435; x=1661037835; bh=L5
        vAqiJE4kokg/Vh7ETIeF5/UA8uNN9Xc4UPrUPYQQY=; b=OWcPNgZjRbls++M4xq
        eStd8ZvCrxFlt5AYFfspmYwQXw7W1l/Wvn/85BLjOSFo/XQ7A3bPsJTDSpx1uyZR
        eaDH/NxX3vCcdjW8KvFzNTJP1CI2Ueyo9kS0pOEc2J5+yerRFysl1hLqIF+3k/Kj
        o+Swtd1dLFo4Ssf1HUuiPkbsoO+Xo6cMj2mrXJWvPKkRboPr1zeOihPPI92ePqZz
        Xlfmk4p7MVDM3a59aQmlCop/J47OtQ6TFa5oSqecG1752NDS5cLIbWlqigsYMwLZ
        VMK/1JjdIQXgRow+kH1VbezaCM0TDVcMu+S4nl87PYa9igyF677bkH3Z5qpAwNSF
        Sukg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1660951435; x=1661037835; bh=L5vAqiJE4kokg
        /Vh7ETIeF5/UA8uNN9Xc4UPrUPYQQY=; b=aEcRbHGFJlx9b7cos99q9TJ8ln35x
        ZVhZOkg+SNQ/xRYvP8TsTuL4sbauoqxARlcw//sCa8G725HWOkhhdwERQRPbBygY
        ziWAv2+VNzjy8qZjqkBvqmaYTdet+IoCFtbMiADHQy1JNDth9/USX47NYndZ+hiH
        Oev0Oo31aX8yWBMXlvX3GJPfLnxoZMU22nAWOR9G/CIgMrpTxZY15aXv8650hPCk
        NoSa+UPgPZ6Oj7wu1B2E6P96UQZVeH32wOVYmLTjhZyoTHCUPTr258QQ5rLAhoh/
        xGQiaYaw0qibJz8mmA82seDDMDWIKY0x3Qds2b4yAytwSL83IcZnuHvzA==
X-ME-Sender: <xms:ixsAYwwFjkSgcqWAG_w29H6dytoa0MAxv5mz0OtrfYbHMhZhjnu5rQ>
    <xme:ixsAY0QKByAH1T8BVi0cmGnHdDQTZaPzXPfdOcTc1SBySAWjnq44m8rB_FPFzv209
    cO6BEftG1xjpjQPPA>
X-ME-Received: <xmr:ixsAYyXPSFyH6WuxvDGkETdWPmKdST6MEQNHoUyrBMLs5XZ9M2xHa3GcwBw3k_z3iTwNNUbuil-P6C1XmnbudlAmyfErHTw9c_Wq>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdeivddgvdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdljedtmdenucfjughrpefhvf
    evufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffrghnihgvlhcuighuuceo
    ugiguhesugiguhhuuhdrgiihiieqnecuggftrfgrthhtvghrnhepgfefgfegjefhudeike
    dvueetffelieefuedvhfehjeeljeejkefgffeghfdttdetnecuvehluhhsthgvrhfuihii
    vgepudenucfrrghrrghmpehmrghilhhfrhhomhepugiguhesugiguhhuuhdrgiihii
X-ME-Proxy: <xmx:ixsAY-jcGgaLkN8TkVARj7E_PlXOT-JT6m4P2JcCkRQXC5Wc3nyIFQ>
    <xmx:ixsAYyBDDM6x4G2Z-rgz9QERaXOG_3fLMDELX_XBurghhVZpXFcx1g>
    <xmx:ixsAY_Lw7eEN1kUMMCoco2xa4uywe-E69vg64polSvWgSuatmuTGAg>
    <xmx:ixsAYzIkimVMKgCs9qRloB15TpNFAWLzcC2vq9jjdqoTuvgS0hgGZg>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 19 Aug 2022 19:23:54 -0400 (EDT)
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, memxor@gmail.com
Cc:     Daniel Xu <dxu@dxuuu.xyz>, pablo@netfilter.org, fw@strlen.de,
        toke@kernel.org, martin.lau@linux.dev,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v3 4/5] bpf: Add support for writing to nf_conn:mark
Date:   Fri, 19 Aug 2022 17:23:33 -0600
Message-Id: <f44b2eebe48f0653949f59c5bcf23af029490692.1660951028.git.dxu@dxuuu.xyz>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <cover.1660951028.git.dxu@dxuuu.xyz>
References: <cover.1660951028.git.dxu@dxuuu.xyz>
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
 include/net/netfilter/nf_conntrack_bpf.h | 13 +++++
 net/core/filter.c                        | 50 ++++++++++++++++++
 net/netfilter/nf_conntrack_bpf.c         | 64 +++++++++++++++++++++++-
 net/netfilter/nf_conntrack_core.c        |  1 +
 4 files changed, 127 insertions(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_conntrack_bpf.h b/include/net/netfilter/nf_conntrack_bpf.h
index a473b56842c5..4ef89ee5b5a9 100644
--- a/include/net/netfilter/nf_conntrack_bpf.h
+++ b/include/net/netfilter/nf_conntrack_bpf.h
@@ -3,13 +3,22 @@
 #ifndef _NF_CONNTRACK_BPF_H
 #define _NF_CONNTRACK_BPF_H
 
+#include <linux/bpf.h>
 #include <linux/btf.h>
 #include <linux/kconfig.h>
 
+extern int (*nf_conntrack_btf_struct_access)(struct bpf_verifier_log *log,
+					     const struct btf *btf,
+					     const struct btf_type *t, int off,
+					     int size, enum bpf_access_type atype,
+					     u32 *next_btf_id,
+					     enum bpf_type_flag *flag);
+
 #if (IS_BUILTIN(CONFIG_NF_CONNTRACK) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF)) || \
     (IS_MODULE(CONFIG_NF_CONNTRACK) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF_MODULES))
 
 extern int register_nf_conntrack_bpf(void);
+extern void cleanup_nf_conntrack_bpf(void);
 
 #else
 
@@ -18,6 +27,10 @@ static inline int register_nf_conntrack_bpf(void)
 	return 0;
 }
 
+static inline void cleanup_nf_conntrack_bpf(void)
+{
+}
+
 #endif
 
 #endif /* _NF_CONNTRACK_BPF_H */
diff --git a/net/core/filter.c b/net/core/filter.c
index 1acfaffeaf32..e5f48e6030b7 100644
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
@@ -8628,6 +8630,32 @@ static bool tc_cls_act_is_valid_access(int off, int size,
 	return bpf_skb_is_valid_access(off, size, type, prog, info);
 }
 
+typedef int (*btf_struct_access_t)(struct bpf_verifier_log *log,
+				 const struct btf *btf,
+				 const struct btf_type *t, int off, int size,
+				 enum bpf_access_type atype,
+				 u32 *next_btf_id, enum bpf_type_flag *flag);
+
+static int tc_cls_act_btf_struct_access(struct bpf_verifier_log *log,
+					const struct btf *btf,
+					const struct btf_type *t, int off,
+					int size, enum bpf_access_type atype,
+					u32 *next_btf_id,
+					enum bpf_type_flag *flag)
+{
+	btf_struct_access_t sa;
+
+	if (atype == BPF_READ)
+		return btf_struct_access(log, btf, t, off, size, atype, next_btf_id,
+					 flag);
+
+	sa = READ_ONCE(nf_conntrack_btf_struct_access);
+	if (sa)
+		return sa(log, btf, t, off, size, atype, next_btf_id, flag);
+
+	return -EACCES;
+}
+
 static bool __is_valid_xdp_access(int off, int size)
 {
 	if (off < 0 || off >= sizeof(struct xdp_md))
@@ -8687,6 +8715,26 @@ void bpf_warn_invalid_xdp_action(struct net_device *dev, struct bpf_prog *prog,
 }
 EXPORT_SYMBOL_GPL(bpf_warn_invalid_xdp_action);
 
+static int xdp_btf_struct_access(struct bpf_verifier_log *log,
+				 const struct btf *btf,
+				 const struct btf_type *t, int off,
+				 int size, enum bpf_access_type atype,
+				 u32 *next_btf_id,
+				 enum bpf_type_flag *flag)
+{
+	btf_struct_access_t sa;
+
+	if (atype == BPF_READ)
+		return btf_struct_access(log, btf, t, off, size, atype, next_btf_id,
+					 flag);
+
+	sa = READ_ONCE(nf_conntrack_btf_struct_access);
+	if (sa)
+		return sa(log, btf, t, off, size, atype, next_btf_id, flag);
+
+	return -EACCES;
+}
+
 static bool sock_addr_is_valid_access(int off, int size,
 				      enum bpf_access_type type,
 				      const struct bpf_prog *prog,
@@ -10581,6 +10629,7 @@ const struct bpf_verifier_ops tc_cls_act_verifier_ops = {
 	.convert_ctx_access	= tc_cls_act_convert_ctx_access,
 	.gen_prologue		= tc_cls_act_prologue,
 	.gen_ld_abs		= bpf_gen_ld_abs,
+	.btf_struct_access	= tc_cls_act_btf_struct_access,
 };
 
 const struct bpf_prog_ops tc_cls_act_prog_ops = {
@@ -10592,6 +10641,7 @@ const struct bpf_verifier_ops xdp_verifier_ops = {
 	.is_valid_access	= xdp_is_valid_access,
 	.convert_ctx_access	= xdp_convert_ctx_access,
 	.gen_prologue		= bpf_noop_prologue,
+	.btf_struct_access	= xdp_btf_struct_access,
 };
 
 const struct bpf_prog_ops xdp_prog_ops = {
diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrack_bpf.c
index 1cd87b28c9b0..a346b561981a 100644
--- a/net/netfilter/nf_conntrack_bpf.c
+++ b/net/netfilter/nf_conntrack_bpf.c
@@ -6,6 +6,7 @@
  * are exposed through to BPF programs is explicitly unstable.
  */
 
+#include <linux/bpf_verifier.h>
 #include <linux/bpf.h>
 #include <linux/btf.h>
 #include <linux/types.h>
@@ -15,6 +16,13 @@
 #include <net/netfilter/nf_conntrack_bpf.h>
 #include <net/netfilter/nf_conntrack_core.h>
 
+int (*nf_conntrack_btf_struct_access)(struct bpf_verifier_log *log,
+				      const struct btf *btf,
+				      const struct btf_type *t, int off,
+				      int size, enum bpf_access_type atype,
+				      u32 *next_btf_id,
+				      enum bpf_type_flag *flag);
+
 /* bpf_ct_opts - Options for CT lookup helpers
  *
  * Members:
@@ -184,6 +192,51 @@ static struct nf_conn *__bpf_nf_ct_lookup(struct net *net,
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
+	const struct btf_type *ncit = btf_type_by_id(btf, btf_nf_conn_ids[1]);
+	const struct btf_type *nct = btf_type_by_id(btf, btf_nf_conn_ids[0]);
+	size_t end;
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
@@ -449,5 +502,14 @@ int register_nf_conntrack_bpf(void)
 	int ret;
 
 	ret = register_btf_kfunc_id_set(BPF_PROG_TYPE_XDP, &nf_conntrack_kfunc_set);
-	return ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_CLS, &nf_conntrack_kfunc_set);
+	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_CLS, &nf_conntrack_kfunc_set);
+	if (!ret)
+		WRITE_ONCE(nf_conntrack_btf_struct_access, _nf_conntrack_btf_struct_access);
+
+	return ret;
+}
+
+void cleanup_nf_conntrack_bpf(void)
+{
+	WRITE_ONCE(nf_conntrack_btf_struct_access, NULL);
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

