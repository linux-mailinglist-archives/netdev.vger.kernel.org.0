Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2A75BE898
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 16:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231675AbiITOT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 10:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231752AbiITOSb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 10:18:31 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA67861D8A;
        Tue, 20 Sep 2022 07:15:51 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 80A155C00B9;
        Tue, 20 Sep 2022 10:15:50 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 20 Sep 2022 10:15:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm1; t=1663683350; x=1663769750; bh=yM
        m4Tog4wIgZDoRdqvldIA+SZ3RNhBYyu0C5pWp05/8=; b=aUkBt8c6YhNTQvtz9m
        d2HNRp3stoopGosW5wJ9VlwZWuFTYMi+Km1EhKQgpeW/ziQ7GisO1G/tWqiAtyaj
        j/k0DC++/a27i8rf+/vaewp6nYwmzoyPEbw3HzY5kxIqCeWu9eOHoi5S8mMYzezg
        v2c3pUBNoIpt3bhVDvUMI8cHZ6B3ekQEoD9AYmGPU75EAVRuLCG3jELLsPYIsEY4
        LmzcbzyPRRNEe2xqqE1432zXvgdAZSpruQLvO0NO8aA0a9Z5IBngxBFPKGdVV5VA
        JaYsYZyEAiya0IH1uUZIQkinDjNSY++JX0AF6gZiT1EFTosC6gkZ+Z4ajW3X2baT
        f2qg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1663683350; x=1663769750; bh=yMm4Tog4wIgZD
        oRdqvldIA+SZ3RNhBYyu0C5pWp05/8=; b=OnXAuNgH4zggejrboYVuWjj5U5RgB
        83LHZ6iec4nvWWR5qRZbeibhleAA6AM30lt4HShN4Ah1gPlnjPRqDk6oXMb3RzB5
        nWfv98HFSQ5uk0FsCR3TrxUkq8rK8tyCYE3RRvXSikLZApvKPGa7AyYZmDxhmYMg
        29HSUdcJsxEuKkweyDaxhw9Yczpr7C6Ffc6Az1S3qIIVkH47/QVMawiGrKfrH4JZ
        CudyQ26wIvMD7zYI4iaBiQjqsq2sqmOD+Rlyxqqg8M6UPPK1mN6rlystYTBQU08n
        JafJcoq0zyiWVtM/y4UkAhRdswMMwTKdEMpusK691qhqanqhZbbVnvF9Q==
X-ME-Sender: <xms:FsspY1kLktwhDyl8lbJpyPtqbWLsufN8PFmyAf5Fgc3FoQlaG95oMw>
    <xme:FsspYw3nYgylXk_39-PeKTMw70UIFPBp9XZ73MI7SWOZlKJK0_1nAPQlxYVfU1xFN
    9pazidGHflZZRtnNw>
X-ME-Received: <xmr:FsspY7pmDl9P08Gx-K45s2NrMov-kWwGLwRzNxYSB6noT3MXXE9Iiki3OhEdWF_eJqzybQpgkWvj7nd2a3f8Wjr8wB1ZZ4ZFac3Baa8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfedvledgjeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdljedtmdenucfjughrpefhvf
    evufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffrghnihgvlhcuighuuceo
    ugiguhesugiguhhuuhdrgiihiieqnecuggftrfgrthhtvghrnhepgfefgfegjefhudeike
    dvueetffelieefuedvhfehjeeljeejkefgffeghfdttdetnecuvehluhhsthgvrhfuihii
    vgeptdenucfrrghrrghmpehmrghilhhfrhhomhepugiguhesugiguhhuuhdrgiihii
X-ME-Proxy: <xmx:FsspY1lFyK3Go-Z59eeDruN3xjjMuXUFGGMY3uYOTQEP1bVlONhAfA>
    <xmx:FsspYz1B40RO5isZxiEZpRqgnp_C4RRw1QEV2Qa7YoFZ7N0Y35Kt4w>
    <xmx:FsspY0sxggzGRnwMdGUloiWtcLNA9y5pqFz8pC1IYqJulcarAc--HQ>
    <xmx:FsspY8ssA-YGpycn4oo56Rm0DxCmR82CPYoDfsJdpgqNYTAU-rZz0Q>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 20 Sep 2022 10:15:49 -0400 (EDT)
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, memxor@gmail.com, martin.lau@linux.dev
Cc:     Daniel Xu <dxu@dxuuu.xyz>, pablo@netfilter.org, fw@strlen.de,
        toke@kernel.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v3 1/3] bpf: Remove unused btf_struct_access stub
Date:   Tue, 20 Sep 2022 08:15:22 -0600
Message-Id: <590e7bd6172ffe0f3d7b51cd40e8ded941aaf7e8.1663683114.git.dxu@dxuuu.xyz>
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

This stub was not being used anywhere.

Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
---
 include/net/netfilter/nf_conntrack_bpf.h | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_bpf.h b/include/net/netfilter/nf_conntrack_bpf.h
index a61a93d1c6dc..9c07d2d59da5 100644
--- a/include/net/netfilter/nf_conntrack_bpf.h
+++ b/include/net/netfilter/nf_conntrack_bpf.h
@@ -3,8 +3,6 @@
 #ifndef _NF_CONNTRACK_BPF_H
 #define _NF_CONNTRACK_BPF_H
 
-#include <linux/bpf.h>
-#include <linux/btf.h>
 #include <linux/kconfig.h>
 #include <linux/mutex.h>
 
@@ -31,16 +29,6 @@ static inline void cleanup_nf_conntrack_bpf(void)
 {
 }
 
-static inline int nf_conntrack_btf_struct_access(struct bpf_verifier_log *log,
-						 const struct btf *btf,
-						 const struct btf_type *t, int off,
-						 int size, enum bpf_access_type atype,
-						 u32 *next_btf_id,
-						 enum bpf_type_flag *flag)
-{
-	return -EACCES;
-}
-
 #endif
 
 #endif /* _NF_CONNTRACK_BPF_H */
-- 
2.37.1

