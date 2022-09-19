Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D8A15BD556
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 21:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbiISTpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 15:45:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbiISTo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 15:44:57 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FEF012D2C;
        Mon, 19 Sep 2022 12:44:55 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 88BBA5C0485;
        Mon, 19 Sep 2022 15:44:54 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Mon, 19 Sep 2022 15:44:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm1; t=1663616694; x=1663703094; bh=Aj
        GZWBeIHap1TSOlC1jQFkXlGehltvgA5iuog4FuANs=; b=V9NsluUDfaYIExb0xU
        8poarDcLEc7ArDyzW+SlA+RkGMGh9p6SBynMSp5IlqxB5vW8Diie3iaSXOzqSJAG
        oEQXSIvu2au++nlvGhhB4YFbcIkFoznupmgvxaHiYbegOhMYFtFDjhaGhnFtraM6
        3ukN55LBuKGrDV8OoM3TIa4ZX+wov2iJd2IQFmqnSGpC38WY6mvuYv8CT2RByy28
        BZN1gjx09pXbzSvxzQOlcuRZWcwEslPdzoP8tKoGfchHCw2+rPCK4oLjsPawIuAA
        K4WYQ4iyW3Iwq97USEgSvXE4UUUELS0PvyLgF2Afp1gGYVumeRqXBacPvvcXTLhV
        TvFw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1663616694; x=1663703094; bh=AjGZWBeIHap1T
        SOlC1jQFkXlGehltvgA5iuog4FuANs=; b=0hzcvi5ARKh3+oiYP3LVgEJ742IJZ
        0dEyXbA8WGaDBnYmDKcO0ojZGbpT4U2wbOdImigVd4HQLFcTUP1Osf/3oXMtX8a6
        5m3Tk1jaRorFbtjfbUMDjSURi/c4XRi86g1UNsX3yGYWf5t6k9hHh20UyCyM0aAg
        6RET41DUPhB4869r3xKiORUDoOjxSUVbNuDKGEYFTvOTDHBd4YMaR6hyxwdif4Eg
        D1c3GcLy9KPo3Z5z9yXCgD022lDXEw7deZ/raS/1wfC75V5ofI6Q3RK5o8eEd4+Y
        i9PO8OWQzdqlctHcafYY6sXpvaMjx4DL4fCHbD8VGh9gyiUb0FmjbLTUg==
X-ME-Sender: <xms:tsYoYwKbvOwThjicKO8kXlMtTIKHyBzo1vfzwcZ4wHEvr0nK4Jazbw>
    <xme:tsYoYwLoXyl2XPVfJt24Df2rJIxaUEqxTX7RU4z6ys4JoXN6Tv1kaaY4gmQyvJBpZ
    fEQ33jjzMrRuxZJOQ>
X-ME-Received: <xmr:tsYoYwvtf127-HyqKJLSg92om8tDUVeVE2DNVUR6PEnS4PHM8yIXAYGwKr7fP7p2WRO4vgl-bAeC7DkQLEibvn7ORCiHV2LkOjFpiWY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfedvjedgudegfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdejtddmnecujfgurhephf
    fvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepffgrnhhivghlucgiuhcu
    oegugihusegugihuuhhurdighiiiqeenucggtffrrghtthgvrhhnpefgfefggeejhfduie
    ekvdeuteffleeifeeuvdfhheejleejjeekgfffgefhtddtteenucevlhhushhtvghrufhi
    iigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegugihusegugihuuhhurdighiii
X-ME-Proxy: <xmx:tsYoY9Y7dxNTzasnhS46Uo3ithrVjaJUZ7EGNMDvMi0nCsPtLyA2oA>
    <xmx:tsYoY3aCEmOjzrOEMmyUFiNzaXb-GxMxsfrNBu_j2GuwYac4G8VJHQ>
    <xmx:tsYoY5AsxuluTniRnzrQpPng_0BHNTiBSG7UYVDitvGiHSs28kTqEg>
    <xmx:tsYoY1CDgFdHXvZWMOTnbPObkFV-TBq6qyTKmgkziWZWcfGHT_acEg>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 19 Sep 2022 15:44:53 -0400 (EDT)
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, memxor@gmail.com, martin.lau@linux.dev
Cc:     Daniel Xu <dxu@dxuuu.xyz>, pablo@netfilter.org, fw@strlen.de,
        toke@kernel.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v2 3/3] bpf: Move nf_conn extern declarations to filter.h
Date:   Mon, 19 Sep 2022 13:44:37 -0600
Message-Id: <3c00fb8d15d543ae3b5df928c191047145c6b5fe.1663616584.git.dxu@dxuuu.xyz>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <cover.1663616584.git.dxu@dxuuu.xyz>
References: <cover.1663616584.git.dxu@dxuuu.xyz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS,T_PDS_OTHER_BAD_TLD
        autolearn=ham autolearn_force=no version=3.4.6
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
 include/net/netfilter/nf_conntrack_bpf.h | 7 +------
 2 files changed, 7 insertions(+), 6 deletions(-)

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
index d1087e4da440..24d1ccc1f8df 100644
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
-extern int (*nfct_btf_struct_access)(struct bpf_verifier_log *log, const struct btf *btf,
-				     const struct btf_type *t, int off, int size,
-				     enum bpf_access_type atype, u32 *next_btf_id,
-				     enum bpf_type_flag *flag);
-
 #else
 
 static inline int register_nf_conntrack_bpf(void)
-- 
2.37.1

