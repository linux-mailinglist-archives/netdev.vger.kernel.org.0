Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E83F5B5084
	for <lists+netdev@lfdr.de>; Sun, 11 Sep 2022 20:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbiIKSUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Sep 2022 14:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiIKSUK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Sep 2022 14:20:10 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E03A24BE1;
        Sun, 11 Sep 2022 11:20:08 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 6A8BB5C0126;
        Sun, 11 Sep 2022 14:20:05 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Sun, 11 Sep 2022 14:20:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :message-id:mime-version:reply-to:sender:subject:subject:to:to;
         s=fm1; t=1662920405; x=1663006805; bh=tIkFduerBzhi1PO+ItrLMhk8C
        yvYof/UzzFiFOoLjiA=; b=B/1y9hArIf0tWv1GZhy++iSznnHaEztbnlSCAzgfB
        T/flb+nCN/s804fuuQLnfAi8OFReB9WDIBGv6VBtQOxlVmKrcFTk+fH5DRSXdc8J
        DRQMnwct/WcS/uYuol8dUS1dFZyJaHJ5ykqjtozsx12WmJXQgYge+D7WWVPaY66n
        WN2ixuTySc9Mc7s0CUrokVN0bpKVE76JZ+Hv+NRXaFmjGCJ+76/YybkrZJj5cSmM
        FQq4KxBVYt/fqDZux0NJvN95JxlXxu5yJ05oKM5BMiSftOyZkWvTvoHawCdjsSlx
        YiEbTXudC16oHJqgcG3YPqwPwjxidliv8VY6bWUBXvghg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
        1662920405; x=1663006805; bh=tIkFduerBzhi1PO+ItrLMhk8CyvYof/UzzF
        iFOoLjiA=; b=vU7o7uMmWpyEnvxr5mfLiqJ/Sdv2CGRzANetYo/Rk1+AF0k4xT3
        SOz6jzq8Foq71rgQ//K4xPBG7QwK3TASeRFyzz9XuSkdSD1zyGTKKrhqGwurP43y
        iyCm7VKjpgk52xpqxz4rJplxz0pVU82GlA4F9lV7LLblnD76u+GkpAMyx66GQ9M0
        9DVfYdOe6YapbrvVv/av0zmMYVx0dAr2jI9pnc7koTIEzhQoc00cLWmfXzG84VEA
        lrAKPj7a3Ade7gvPF9j+40/KTFuCn/b/2mgOWhMjkblm3V41oXzOnAFnByfqvzg7
        CMpcakxPOw9d+KUbHMM9JFGFdFOBCEmusqQ==
X-ME-Sender: <xms:1SYeY3xcnTT9zWuxSDJVFTcj5Yq7rwMJ-gcDzxlIsS3gLdT-_b5s7A>
    <xme:1SYeY_TkXdrYKlB86srQUZ4as15x5ifHfP_tpgxvMo9stFHhG1Gwwnzdwaq-x-GEf
    9LzQoiEjEwbGqFfPQ>
X-ME-Received: <xmr:1SYeYxUM_vW0N5nJe0UFrhBBvJnSOdzkTUTjQaBXctY5CpvS5T462YEQS7_-T0LFgIsZSDO4fZRIerZqlKYWjXrzcDx4rQZFfPgBlTQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfedutddguddvjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdejtddmnecujfgurhephf
    fvvefufffkofgggfestdekredtredttdenucfhrhhomhepffgrnhhivghlucgiuhcuoegu
    gihusegugihuuhhurdighiiiqeenucggtffrrghtthgvrhhnpedvgefgtefgleehhfeufe
    ekuddvgfeuvdfhgeeljeduudfffffgteeuudeiieekjeenucevlhhushhtvghrufhiiigv
    pedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegugihusegugihuuhhurdighiii
X-ME-Proxy: <xmx:1SYeYxhvRZpLvXzWYnYtsiqp8yeY8P5Xucvs7WWRLqraE35OciNfqA>
    <xmx:1SYeY5Chw4cCjt03HM-RhSI_B03hsoxPi4dd446BHrT5ul75itbbmg>
    <xmx:1SYeY6LGGeO24e9uFyP5VsUaAjSX7wRnoslH-j4rXx-tPf8VJ09Zfw>
    <xmx:1SYeY-LFFt0cjiZCQxZXme3na_zU8lSJzuAieDB04YDKkRNYU15d1g>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Sep 2022 14:20:04 -0400 (EDT)
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, memxor@gmail.com
Cc:     Daniel Xu <dxu@dxuuu.xyz>, pablo@netfilter.org, fw@strlen.de,
        toke@kernel.org, martin.lau@linux.dev,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next] bpf: Move nf_conn extern declarations to filter.h
Date:   Sun, 11 Sep 2022 12:19:53 -0600
Message-Id: <c4cb11c8ffe732b91c175a0fc80d43b2547ca17e.1662920329.git.dxu@dxuuu.xyz>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        FROM_SUSPICIOUS_NTLD_FP,PDS_OTHER_BAD_TLD,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We're seeing the following new warnings on netdev/build_32bit and
netdev/build_allmodconfig_warn CI jobs:

    ../net/core/filter.c:8608:1: warning: symbol
    'nf_conn_btf_access_lock' was not declared. Should it be static?
    ../net/core/filter.c:8611:5: warning: symbol 'nfct_bsa' was not
    declared. Should it be static?

Fix by ensuring extern declaration is present while compiling filter.o.

Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
---
 include/linux/filter.h                   | 6 ++++++
 include/net/netfilter/nf_conntrack_bpf.h | 7 +------
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 527ae1d64e27..96de256b2c8d 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -567,6 +567,12 @@ struct sk_filter {
 
 DECLARE_STATIC_KEY_FALSE(bpf_stats_enabled_key);
 
+extern struct mutex nf_conn_btf_access_lock;
+extern int (*nfct_bsa)(struct bpf_verifier_log *log, const struct btf *btf,
+		       const struct btf_type *t, int off, int size,
+		       enum bpf_access_type atype, u32 *next_btf_id,
+		       enum bpf_type_flag *flag);
+
 typedef unsigned int (*bpf_dispatcher_fn)(const void *ctx,
 					  const struct bpf_insn *insnsi,
 					  unsigned int (*bpf_func)(const void *,
diff --git a/include/net/netfilter/nf_conntrack_bpf.h b/include/net/netfilter/nf_conntrack_bpf.h
index a61a93d1c6dc..cf2c0423d174 100644
--- a/include/net/netfilter/nf_conntrack_bpf.h
+++ b/include/net/netfilter/nf_conntrack_bpf.h
@@ -5,6 +5,7 @@
 
 #include <linux/bpf.h>
 #include <linux/btf.h>
+#include <linux/filter.h>
 #include <linux/kconfig.h>
 #include <linux/mutex.h>
 
@@ -14,12 +15,6 @@
 extern int register_nf_conntrack_bpf(void);
 extern void cleanup_nf_conntrack_bpf(void);
 
-extern struct mutex nf_conn_btf_access_lock;
-extern int (*nfct_bsa)(struct bpf_verifier_log *log, const struct btf *btf,
-		       const struct btf_type *t, int off, int size,
-		       enum bpf_access_type atype, u32 *next_btf_id,
-		       enum bpf_type_flag *flag);
-
 #else
 
 static inline int register_nf_conntrack_bpf(void)
-- 
2.37.1

