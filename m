Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE20359C623
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 20:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236686AbiHVS10 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 14:27:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237432AbiHVS0U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 14:26:20 -0400
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B8C5481D0;
        Mon, 22 Aug 2022 11:26:19 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id EF17B3200A61;
        Mon, 22 Aug 2022 14:26:17 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 22 Aug 2022 14:26:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1661192777; x=1661279177; bh=uz
        DweTL6NwrQ9dAqqVb+6n/PTBX1skvwf1XwGmhYWvk=; b=M5CnGtiZYf48K8D3xp
        FYjPaQ5ve+AunDpsNviNfaOA1kos5fbyE2oSXbGRNy6XqWfMnmiiIA1MaXRwAVtG
        Tz50IfcBLwkKOB8J/LTbGx01Ad2M+/emlhFHf8hTih+tmgACOfe0z6kbScEamiqP
        Tp2SS89liJM8XbV4uhd6MhXJjYZdWr8/3GXxTDUYrjx4vgQx9751KJH3njBRAVzp
        Erbf/KRWWMG/FCC9UYUP6xEoBcNE5ySPf+EUvZvn3wBMV/YcquNlmGLUc41tDXDh
        mv16yiUDQGfBeTIkt27WI5h4nRuqc+EypJDzMcLmEN53At3IbLWa0sj77nSX+ARE
        ZCUQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1661192777; x=1661279177; bh=uzDweTL6NwrQ9
        dAqqVb+6n/PTBX1skvwf1XwGmhYWvk=; b=he2aCeh6nAMr94qwdEiwUWXWugW62
        wO8JWuu91W3PsjQkndrNRU1z6p4LXesfmjd7LX4/3OF7qnKM6W5bka7lT/Mt4h4D
        NsT9NEnVHFEvNhFePDjOE784LmshXEo4NPrNp4ci6Qg0+T5Zh2oNaOioMfM6D0GP
        6Ly1x1XM5Du838o7tW+g/mkY8a3T9FffD6rC78p3ZNnicrFokkjudJZN0ivmtwqp
        Wdcy0yI6r5Wzld82JKsFBd2NAS30QiwgcIwqVNMsQOfgKYrN7ABIh5LL40RhnPns
        qms4R2uXtt7x2SL/Q1iFrimpwCoNxjXk3Y+XA3tHsFAWyBM1EX9VMvKfg==
X-ME-Sender: <xms:ScoDY5j9qsCAFPOWaqVnA7TkiMQytCdioXGubE0beijf5TxLL7gmtQ>
    <xme:ScoDY-CluoiwC3tZ1cSnOBr9NWtSQzgJPYDI5ZzfPlKSvamoKOv-yaSGuX8SZo0Ua
    oaW2Ywh9XVcc7Db6Q>
X-ME-Received: <xmr:ScoDY5E4YAoppm4zRXvO8TTeJi12zP2fqoGpdROs2gAW8qmMqUS9c6IMQsDFChSUopo8GPTuj7L5uzx7YNxPk6YTr9OyuHn3RzgG>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdeijedguddvhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdejtddmnecujfgurhephf
    fvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepffgrnhhivghlucgiuhcu
    oegugihusegugihuuhhurdighiiiqeenucggtffrrghtthgvrhhnpefgfefggeejhfduie
    ekvdeuteffleeifeeuvdfhheejleejjeekgfffgefhtddtteenucevlhhushhtvghrufhi
    iigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegugihusegugihuuhhurdighiii
X-ME-Proxy: <xmx:ScoDY-THWQZAwLseJzIuM-7VqWt3VOqgMqDRSAsuiQGn-p05C4KfNA>
    <xmx:ScoDY2y4RJh-LGyVePl_3TKw-3NblrKu9OQVrEcxRlHw6SYGNyjJOQ>
    <xmx:ScoDY04qar9rE2W7Cy_-TDKCs8-UWyYbB-SI5ZRfwTqyeMpwZ4EN3w>
    <xmx:ScoDY45sNxiNiuSRp9rhnY7Sq21dryOZA9-slB92OcQ9CVwmCbwxUQ>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 22 Aug 2022 14:26:16 -0400 (EDT)
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, memxor@gmail.com
Cc:     Daniel Xu <dxu@dxuuu.xyz>, pablo@netfilter.org, fw@strlen.de,
        toke@kernel.org, martin.lau@linux.dev,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v4 4/5] bpf: Add support for writing to nf_conn:mark
Date:   Mon, 22 Aug 2022 12:25:54 -0600
Message-Id: <073173502d762faf87bde0ca23e609c84848dd7e.1661192455.git.dxu@dxuuu.xyz>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <cover.1661192455.git.dxu@dxuuu.xyz>
References: <cover.1661192455.git.dxu@dxuuu.xyz>
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
 include/net/netfilter/nf_conntrack_bpf.h | 22 ++++++
 net/core/filter.c                        | 34 +++++++++
 net/netfilter/nf_conntrack_bpf.c         | 91 +++++++++++++++++++++++-
 net/netfilter/nf_conntrack_core.c        |  1 +
 4 files changed, 147 insertions(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_conntrack_bpf.h b/include/net/netfilter/nf_conntrack_bpf.h
index a473b56842c5..6fc03066846b 100644
--- a/include/net/netfilter/nf_conntrack_bpf.h
+++ b/include/net/netfilter/nf_conntrack_bpf.h
@@ -3,6 +3,7 @@
 #ifndef _NF_CONNTRACK_BPF_H
 #define _NF_CONNTRACK_BPF_H
 
+#include <linux/bpf.h>
 #include <linux/btf.h>
 #include <linux/kconfig.h>
 
@@ -10,6 +11,13 @@
     (IS_MODULE(CONFIG_NF_CONNTRACK) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF_MODULES))
 
 extern int register_nf_conntrack_bpf(void);
+extern void cleanup_nf_conntrack_bpf(void);
+extern int nf_conntrack_btf_struct_access(struct bpf_verifier_log *log,
+					  const struct btf *btf,
+					  const struct btf_type *t, int off,
+					  int size, enum bpf_access_type atype,
+					  u32 *next_btf_id,
+					  enum bpf_type_flag *flag);
 
 #else
 
@@ -18,6 +26,20 @@ static inline int register_nf_conntrack_bpf(void)
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
index 1acfaffeaf32..25bdbf6dc76b 100644
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
@@ -8628,6 +8630,21 @@ static bool tc_cls_act_is_valid_access(int off, int size,
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
@@ -8687,6 +8704,21 @@ void bpf_warn_invalid_xdp_action(struct net_device *dev, struct bpf_prog *prog,
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
@@ -10581,6 +10613,7 @@ const struct bpf_verifier_ops tc_cls_act_verifier_ops = {
 	.convert_ctx_access	= tc_cls_act_convert_ctx_access,
 	.gen_prologue		= tc_cls_act_prologue,
 	.gen_ld_abs		= bpf_gen_ld_abs,
+	.btf_struct_access	= tc_cls_act_btf_struct_access,
 };
 
 const struct bpf_prog_ops tc_cls_act_prog_ops = {
@@ -10592,6 +10625,7 @@ const struct bpf_verifier_ops xdp_verifier_ops = {
 	.is_valid_access	= xdp_is_valid_access,
 	.convert_ctx_access	= xdp_convert_ctx_access,
 	.gen_prologue		= bpf_noop_prologue,
+	.btf_struct_access	= xdp_btf_struct_access,
 };
 
 const struct bpf_prog_ops xdp_prog_ops = {
diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrack_bpf.c
index 1cd87b28c9b0..da54355927d4 100644
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
@@ -184,6 +186,79 @@ static struct nf_conn *__bpf_nf_ct_lookup(struct net *net,
 	return ct;
 }
 
+BTF_ID_LIST(btf_nf_conn_ids)
+BTF_ID(struct, nf_conn)
+BTF_ID(struct, nf_conn___init)
+
+static DEFINE_MUTEX(btf_access_lock);
+static int (*nfct_bsa)(struct bpf_verifier_log *log,
+		       const struct btf *btf,
+		       const struct btf_type *t, int off,
+		       int size, enum bpf_access_type atype,
+		       u32 *next_btf_id,
+		       enum bpf_type_flag *flag);
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
+int nf_conntrack_btf_struct_access(struct bpf_verifier_log *log,
+				   const struct btf *btf,
+				   const struct btf_type *t, int off,
+				   int size, enum bpf_access_type atype,
+				   u32 *next_btf_id,
+				   enum bpf_type_flag *flag)
+{
+	int ret = -EACCES;
+
+	mutex_lock(&btf_access_lock);
+	if (nfct_bsa)
+		ret = nfct_bsa(log, btf, t, off, size, atype, next_btf_id, flag);
+	mutex_unlock(&btf_access_lock);
+
+	return ret;
+}
+
 __diag_push();
 __diag_ignore_all("-Wmissing-prototypes",
 		  "Global functions as their definitions will be in nf_conntrack BTF");
@@ -449,5 +524,19 @@ int register_nf_conntrack_bpf(void)
 	int ret;
 
 	ret = register_btf_kfunc_id_set(BPF_PROG_TYPE_XDP, &nf_conntrack_kfunc_set);
-	return ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_CLS, &nf_conntrack_kfunc_set);
+	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_CLS, &nf_conntrack_kfunc_set);
+	if (!ret) {
+		mutex_lock(&btf_access_lock);
+		nfct_bsa = _nf_conntrack_btf_struct_access;
+		mutex_unlock(&btf_access_lock);
+	}
+
+	return ret;
+}
+
+void cleanup_nf_conntrack_bpf(void)
+{
+	mutex_lock(&btf_access_lock);
+	nfct_bsa = NULL;
+	mutex_unlock(&btf_access_lock);
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

