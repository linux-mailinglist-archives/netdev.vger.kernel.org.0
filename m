Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BBCF5975EF
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 20:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241263AbiHQSnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 14:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241074AbiHQSnd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 14:43:33 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54554BF6C;
        Wed, 17 Aug 2022 11:43:20 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 3BADD5C017F;
        Wed, 17 Aug 2022 14:43:19 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 17 Aug 2022 14:43:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1660761799; x=1660848199; bh=ba
        v66PMTSC/VY8B9jYgWNMdcK75gc9L0KS6MRDdO0Fo=; b=Ckx9KIq+O0QtkgDiW0
        aaZWqZSbHBb3jxg4p5CymV9WpVKqnw8VWP+muH6SiOlc7D8ezJZrkT8+Skffkt1K
        k55TQdoM1INwG+C4ERmJ9CMSWv0WYRhRxt0ReDo/ZwmcLRwdIGUGOTBR05T742Z/
        3Ee1uGjU8PNNxog0HsjleVmJ7sMQqidwrxA483gzf/GrFVoppK/J1CTfmwhJTd49
        sn3cdqjGUqt7M1t/llBI0xvPktAIDpZf4jWGBso2xR6BIu/J4Ikjwoj00Uk0VWfk
        TezRK4TryNX32yV9gEZ6ndWh0WXfVHIfUDPFEYiKPaphQF1cl+wDSGn5Wv9S8w8x
        BwEA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1660761799; x=1660848199; bh=bav66PMTSC/VY
        8B9jYgWNMdcK75gc9L0KS6MRDdO0Fo=; b=w2evElmi+YbnGcfU5hpbo1Q7hg7Xw
        hllTc17ojp+F3kHxClJCUG1580MVViRiWyqEuYetFwnX3zxpdhQK3StZOtIUM9D5
        hNQMJEOl6hjWDTQYx2UKsWfJbjGi85KTyk09b8x6ESNaAqPs3dq0DNL3T7umoo0K
        pfUSDgd5Qe1rUY4Qh6Iras5JQ8s2mI4/AsjBkG8yIRespKvPxeDqJYpdD105oZjM
        MY782qqmyNM1Q95/WitI3PzBcbxYcQEgauyQkOwiHt5sZo5mGaaLqctPwQ8qinZZ
        T9unT9DtEoXci9B1eqozLUqsWSKz8epop2UoJPeqB9wEDLVqhrFX6/YhA==
X-ME-Sender: <xms:xzb9YndnLEAmAS1FReE0YnzeRq2I5Hntb-rLSNjcBHjdst7qcOfyOA>
    <xme:xzb9YtMThxOfKvHaHCahuD4XgL22XZ5j-cPPikJH0mhp2HDX58O98zswhCyUT9Mud
    lM9QF5lU4rR-IzQCA>
X-ME-Received: <xmr:xzb9YghbN-SNTk_ydr5bXzQFUyer_Gpo0MZ860kQ6QWgwzSz2Aldlu2KyIeBsFOnpCSYWgcg0P80-1ASo_rsDbSZvPJMde5_M0ru>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdehiedguddvlecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdejtddmnecujfgurhephf
    fvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepffgrnhhivghlucgiuhcu
    oegugihusegugihuuhhurdighiiiqeenucggtffrrghtthgvrhhnpefgfefggeejhfduie
    ekvdeuteffleeifeeuvdfhheejleejjeekgfffgefhtddtteenucevlhhushhtvghrufhi
    iigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegugihusegugihuuhhurdighiii
X-ME-Proxy: <xmx:xzb9Yo9engdzsislxcyXqxmQoR10VIPnArzOJtS1iNzFe1UMc-EA7A>
    <xmx:xzb9YjuBevFWHe70YvDUMTQvWm5cEl28w0nQC_Q7_dkjFU3SdL5URw>
    <xmx:xzb9YnGkjq6i7KD92ZOSHw3OaE3uikDywh4KxQzKrhEcZu196pm5oQ>
    <xmx:xzb9YknYP4SIJ0PUSjuOKppQqg-kR-WjgSn7-VPhOycr82DolUdtwQ>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 17 Aug 2022 14:43:18 -0400 (EDT)
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, memxor@gmail.com
Cc:     Daniel Xu <dxu@dxuuu.xyz>, pablo@netfilter.org, fw@strlen.de,
        toke@kernel.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v2 3/4] bpf: Add support for writing to nf_conn:mark
Date:   Wed, 17 Aug 2022 12:43:01 -0600
Message-Id: <edbca42217a73161903a50ba07ec63c5fa5fde00.1660761470.git.dxu@dxuuu.xyz>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <cover.1660761470.git.dxu@dxuuu.xyz>
References: <cover.1660761470.git.dxu@dxuuu.xyz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        PDS_OTHER_BAD_TLD,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
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

