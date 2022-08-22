Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E69159C621
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 20:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237322AbiHVS1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 14:27:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236695AbiHVS0M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 14:26:12 -0400
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 138CA48C87;
        Mon, 22 Aug 2022 11:26:10 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id F1FF43200A69;
        Mon, 22 Aug 2022 14:26:08 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Mon, 22 Aug 2022 14:26:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1661192768; x=1661279168; bh=3n
        Trx1gGoWVgblHqB1LDPbAAM4EJshkejU88GCgaCtI=; b=upR8m4c22A/BT/IdWR
        rSDZJ7rQwVioVAGaYy5JwthGrwVsu9TRx5AxbaAsINfUD78KM5tbSvPrZh6u8rmH
        JHz9/Xutp0HfvnZ0VebwBZexDObcjl64czkiGcyWSjhNab2S8VzhA9yN9yIYxBdU
        SZIlZCI4CR5/H4CxK0CqJ84jgfN/jj2GBQ0UQojuNh97V0/gT2J+qIntgRaZ6UoJ
        ey/Z5pcxdAyrs4lP5diftSLTe2ZEgQTkEWF5K3yYUk5bW8/sOdlKQJxQusra9cGI
        MhUvKwE/KG1ZGCfn7H7HvIjElJ1PZ7GTlBGtbFtUz3MfWjuzR1MoHCS8UIPbQs7L
        KTnQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1661192768; x=1661279168; bh=3nTrx1gGoWVgb
        lHqB1LDPbAAM4EJshkejU88GCgaCtI=; b=CB2/6f47VBZU/BUcxBhrYzCYjddUU
        T4Yktelw0mk+fO2JFMHs9zAbLZ/+8o3yHjL5fy3GJKM2D6GEKQmVm9kg+uL4fLEq
        RLk5OQl+NZgMob8wgnMXjmw2+ehNw+Cth+SNmuXFfF7yjv2+mKn8IUMlcwHxqmkj
        5SAIPLrhAl83DQ9a8G2DxZ/iyAqum1/gOpb0DPYLkJjbS39Aj3/lt9aMlK4diroT
        dI/xEqUtPACxHLN8e74ufVvEvztGTFIAibFmFk+VPUH24IgXoIe7EyUVOFuwQkTd
        xUdvgPYCteAYS38k2YcvReINSG4EqDnoq0qklgS9+tYDf55IVCKhp4uTQ==
X-ME-Sender: <xms:QMoDY6Anh4wtb8xwRONmy-7LK-w0beDkkkLZmCz2k0G2ym4iRcyECg>
    <xme:QMoDY0i7m9I5XvyPt4pKe2FdRq4vFmXWiwc1bqCFAcVxjick6r7chij9vIqhFeZzP
    7btch3oMXmlbDbtcg>
X-ME-Received: <xmr:QMoDY9nFUaRaiobGmeXmBK4sn7mb_n5Vbu6YVaOxtWaFvKS2YWfvEWQbVJJED4ca3cXQuT1s6_2h0X6Xo2iGCA2epXhQZEMIRPsK>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdeijedguddvhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdefhedmnecujfgurhephf
    fvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepffgrnhhivghlucgiuhcu
    oegugihusegugihuuhhurdighiiiqeenucggtffrrghtthgvrhhnpefgfefggeejhfduie
    ekvdeuteffleeifeeuvdfhheejleejjeekgfffgefhtddtteenucevlhhushhtvghrufhi
    iigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegugihusegugihuuhhurdighiii
X-ME-Proxy: <xmx:QMoDY4yfgUXUEBc78NW8CedH0MyWSoqm4wLViqt10BOtmWS-97HsKg>
    <xmx:QMoDY_R63MZOkRCT4-Bl57ggGPKr7UDmjrpbtD3wYImXVM0caBzQwg>
    <xmx:QMoDYzYuLjRzQ5eDzU3MhMzrUxEvP8IlrFTYAtQ_IYFpU1C8FlbsZA>
    <xmx:QMoDY3Y6JAsA8vFYrn914FRHAwt7APgof62bqql6Q0vUIJ59qgUgOA>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 22 Aug 2022 14:26:07 -0400 (EDT)
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, memxor@gmail.com
Cc:     Daniel Xu <dxu@dxuuu.xyz>, pablo@netfilter.org, fw@strlen.de,
        toke@kernel.org, martin.lau@linux.dev,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v4 1/5] bpf: Remove duplicate PTR_TO_BTF_ID RO check
Date:   Mon, 22 Aug 2022 12:25:51 -0600
Message-Id: <02989104a2f1b3f674530bb6654666a3809a7e5f.1661192455.git.dxu@dxuuu.xyz>
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

Since commit 27ae7997a661 ("bpf: Introduce BPF_PROG_TYPE_STRUCT_OPS")
there has existed bpf_verifier_ops:btf_struct_access. When
btf_struct_access is _unset_ for a prog type, the verifier runs the
default implementation, which is to enforce read only:

        if (env->ops->btf_struct_access) {
                [...]
        } else {
                if (atype != BPF_READ) {
                        verbose(env, "only read is supported\n");
                        return -EACCES;
                }

                [...]
        }

When btf_struct_access is _set_, the expectation is that
btf_struct_access has full control over accesses, including if writes
are allowed.

Rather than carve out an exception for each prog type that may write to
BTF ptrs, delete the redundant check and give full control to
btf_struct_access.

Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 kernel/bpf/verifier.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 2c1f8069f7b7..ca2311bf0cfd 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -13474,9 +13474,6 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
 				insn->code = BPF_LDX | BPF_PROBE_MEM |
 					BPF_SIZE((insn)->code);
 				env->prog->aux->num_exentries++;
-			} else if (resolve_prog_type(env->prog) != BPF_PROG_TYPE_STRUCT_OPS) {
-				verbose(env, "Writes through BTF pointers are not allowed\n");
-				return -EINVAL;
 			}
 			continue;
 		default:
-- 
2.37.1

