Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E37485BE899
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 16:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231658AbiITOTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 10:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231776AbiITOSe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 10:18:34 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79ECC63F12;
        Tue, 20 Sep 2022 07:15:53 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id C0AB95C00E9;
        Tue, 20 Sep 2022 10:15:52 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 20 Sep 2022 10:15:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm1; t=1663683352; x=1663769752; bh=h3
        tqXL2enmCbEW25A7PZJVmWKB9mGq9wPoEsAr2P60U=; b=iJKpovmcTZ0CDzDQQY
        b3af/HYWSTMsYdq7YX8czf9NjKmxVFxtdNiOmdzA/Z8cE6edO7+BH9TxavA/pCiF
        eRDDfndg7sIp8i7pX1HYhnMAz66evwi0PSXn6tuoZBVPo307BOt++dP4Gu58xWex
        9Uc/dq7obM0ox8zOCURwxALdwktJj45XusqDfMsNY6QCrWTcypRYHr4/0X84pfhu
        41iNC+rQkbk/kQCnM5aKOyYYT8UKnvv585A48C2ofbBLY/JygmT183qxMhif1HER
        k/jbQPuIyVfoNcq8Cgvh7z1EoeVahU/RSfyCj8Hf9Agd86+YAvnQKARZoy5KRl2f
        zhgg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1663683352; x=1663769752; bh=h3tqXL2enmCbE
        W25A7PZJVmWKB9mGq9wPoEsAr2P60U=; b=RLtHld6E5I/5XoVwK+qdTVJjbjyrB
        xDuz11mgQpvvW0OrhOEvWgUloCFTtILooSgo13yHyMcQelLQH/g1SazlV1aFF2+C
        b/3CTKvQx3YTtwCmKU9RkKPw2K7je4BaLoPx6F72niAXiWILWNFY+tYP8nTxR1EP
        cx4dTuMPXqw5Emq/AAPpCPa4yU4cczL6DHVSrf6pZuD+lFNBSyhYH4h5wSpR9xp6
        3jNGKVD0fG31uBJF2YHpwGkppZVzv8rFjhCVNlis0QTVPZNFvnDkUNG5VJV2w8ni
        Bk68ZVGzUEnL9LbUDGIhMrJCQS/5Ya+qL2yvI658wBn4hnQE34NjYmalA==
X-ME-Sender: <xms:GMspY8UA8EWof3nBzDrPYqXzpehjnC3RhsmNCaEffShybL8OHhyEkw>
    <xme:GMspYwluczsKaSsllMTe7zWeCmSRMI5nBKICPQ7sKL9JArpJaKJA8MenxRuSkXfOa
    AE-CM3zQLBXAtvTNg>
X-ME-Received: <xmr:GMspYwZIrjozTlc1xzb0dxlrmtmGtTgpuQsPALTjRAFxb2MqWjlXK6J_KAl4iATNXd2ZNbngGtk6hqMr0XzWqTqZg9_qzRCozpaYqOI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfedvledgjeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdljedtmdenucfjughrpefhvf
    evufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffrghnihgvlhcuighuuceo
    ugiguhesugiguhhuuhdrgiihiieqnecuggftrfgrthhtvghrnhepgfefgfegjefhudeike
    dvueetffelieefuedvhfehjeeljeejkefgffeghfdttdetnecuvehluhhsthgvrhfuihii
    vgeptdenucfrrghrrghmpehmrghilhhfrhhomhepugiguhesugiguhhuuhdrgiihii
X-ME-Proxy: <xmx:GMspY7V6VW-QPaaokXghP9HREg6eqPQDrekZQUrjupnuDu9U1XXupQ>
    <xmx:GMspY2mhw4SrO4cVrnqNw1qTW71MUeSuqRRj-cdxMTyPuEo5dNT7aA>
    <xmx:GMspYwesAqZJVxuYTdl3BCpoPwstTpPD5DMBooajzRk0feOkzU8tZQ>
    <xmx:GMspY4fOx_13sQwd4HnZ1qx0ATt5Py_805grmt0ZS7u-EPEQPVsTJg>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 20 Sep 2022 10:15:51 -0400 (EDT)
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, memxor@gmail.com, martin.lau@linux.dev
Cc:     Daniel Xu <dxu@dxuuu.xyz>, pablo@netfilter.org, fw@strlen.de,
        toke@kernel.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v3 3/3] bpf: Move nf_conn extern declarations to filter.h
Date:   Tue, 20 Sep 2022 08:15:24 -0600
Message-Id: <2bd2e0283df36d8a4119605878edb1838d144174.1663683114.git.dxu@dxuuu.xyz>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <cover.1663683114.git.dxu@dxuuu.xyz>
References: <cover.1663683114.git.dxu@dxuuu.xyz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_PASS,T_PDS_OTHER_BAD_TLD autolearn=ham autolearn_force=no
        version=3.4.6
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

Fixes: 864b656f82cc ("bpf: Add support for writing to nf_conn:mark")
Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
---
 include/linux/filter.h                   | 6 ++++++
 include/net/netfilter/nf_conntrack_bpf.h | 6 ------
 net/netfilter/nf_conntrack_bpf.c         | 1 +
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 75335432fcbc..98e28126c24b 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -567,6 +567,12 @@ struct sk_filter {
 
 DECLARE_STATIC_KEY_FALSE(bpf_stats_enabled_key);
 
+extern struct mutex nf_conn_btf_access_lock;
+extern int (*nfct_btf_struct_access)(struct bpf_verifier_log *log, const struct btf *btf,
+				     const struct btf_type *t, int off, int size,
+				     enum bpf_access_type atype, u32 *next_btf_id,
+				     enum bpf_type_flag *flag);
+
 typedef unsigned int (*bpf_dispatcher_fn)(const void *ctx,
 					  const struct bpf_insn *insnsi,
 					  unsigned int (*bpf_func)(const void *,
diff --git a/include/net/netfilter/nf_conntrack_bpf.h b/include/net/netfilter/nf_conntrack_bpf.h
index 1199d4f8e019..e1f1ba3116ef 100644
--- a/include/net/netfilter/nf_conntrack_bpf.h
+++ b/include/net/netfilter/nf_conntrack_bpf.h
@@ -12,12 +12,6 @@
 extern int register_nf_conntrack_bpf(void);
 extern void cleanup_nf_conntrack_bpf(void);
 
-extern struct mutex nf_conn_btf_access_lock;
-extern int (*nfct_btf_struct_access)(struct bpf_verifier_log *log, const struct btf *btf,
-				     const struct btf_type *t, int off, int size,
-				     enum bpf_access_type atype, u32 *next_btf_id,
-				     enum bpf_type_flag *flag);
-
 #else
 
 static inline int register_nf_conntrack_bpf(void)
diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrack_bpf.c
index 29c4efb3da5e..67df64283aef 100644
--- a/net/netfilter/nf_conntrack_bpf.c
+++ b/net/netfilter/nf_conntrack_bpf.c
@@ -9,6 +9,7 @@
 #include <linux/bpf_verifier.h>
 #include <linux/bpf.h>
 #include <linux/btf.h>
+#include <linux/filter.h>
 #include <linux/mutex.h>
 #include <linux/types.h>
 #include <linux/btf_ids.h>
-- 
2.37.1

