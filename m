Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53D0E5945B2
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 01:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245516AbiHOWCw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 18:02:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350166AbiHOWBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 18:01:53 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D05E112FB8;
        Mon, 15 Aug 2022 12:36:10 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id E22FE5C0100;
        Mon, 15 Aug 2022 15:36:03 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 15 Aug 2022 15:36:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1660592163; x=1660678563; bh=Wc
        b6Pbj94UhSYNHvOvjVvvYzPv6vZiSSIkN/TpJnmyo=; b=KrEF1DWh+zvKxjJ895
        Oy8naFMlbLUVSY8dqRzjqgrJd3nKni+Zh09T/AjK9a0c/dAQ2523oVFd0LZSLCI+
        0ZmXhnA6wIlMNipev4h4785lJtK8AlTBKG6jy19wZfmLihgWqQO52GqVQdOHdDIL
        t+e8XFDWQcGD47OY8ifgsMLTWlBSXPv9QG4uegnbRWeo5+/yIXPYtWV8lK4emFNd
        y7xiGtTntciGZ7QgYyRRsFdyaKjdRZC/NssWpxOvlTLdcEQ2UQzFA6F5eXxqLa2s
        /L6pZPBTkPsSKJXTa2AGs4wAdde1kvy6xGFFFdQbvKB6n9kdRlKmqrHU8lGWLbX0
        kv7g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1660592163; x=1660678563; bh=Wcb6Pbj94UhSY
        NHvOvjVvvYzPv6vZiSSIkN/TpJnmyo=; b=uTOYFmjfsC3q+8Yfb3wB4OA9BPegC
        iCYM/aED/1qmeo2lM1uGVF1ViquL2H5V+8sGGP+Dye7j9OWTIJqyDG9Pni8aLmKJ
        9L3BhqLRzjbpbFzfrc7iu+dABFo8KZEPDYGqgXCkfIKCQtxSx9gKW+RUEC3h3eKv
        D7+ABfCl4yYSm9BvWRNUxjU6Aiitj06Rh3mIw0tRAWhShRDAm5tH7x6/fdCCzVhi
        rogAI2h04J+VpxqnJnXIQkzQySfBYKGAUPZQkhllxX22yWWKiZ2fLgV64dTL/K5s
        PXDGvK9d+dVY68hAib8FeCVonaATAF7mVdCNXlJYZQK9QHWa44tBQf6ag==
X-ME-Sender: <xms:I6D6Yj2p3ifSUyadtDsxGiyeMmiGXJRiEuhog_7qy40S0nzoKHbWEA>
    <xme:I6D6YiH5DDi1B-LUm0uhlyG2KPxm26HSXFihYfPTKkjCRR1uod7Pt_t2zp-W3S4Oe
    I5ae03hwYfue9jUIA>
X-ME-Received: <xmr:I6D6Yj4RJsU3swyOTYBr0vuVI85LKbzr4eZZIy8uN1FdHZ4Jogfv-yQeL-k4rhlmJMbtgfBMHvY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdehvddgudegudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdejtddmnecujfgurhephf
    fvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepffgrnhhivghlucgiuhcu
    oegugihusegugihuuhhurdighiiiqeenucggtffrrghtthgvrhhnpefgfefggeejhfduie
    ekvdeuteffleeifeeuvdfhheejleejjeekgfffgefhtddtteenucevlhhushhtvghrufhi
    iigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegugihusegugihuuhhurdighiii
X-ME-Proxy: <xmx:I6D6Yo13vhJBy7Y8IqMUTDaAgX-xFHPsC1DXwPtrOiabbhKhqEM2yQ>
    <xmx:I6D6YmFZwdIlA4hlfkXn4TJ3E7amIhiTrATDL46pCHMdq_3s2ZoK_w>
    <xmx:I6D6Yp_Q8naXVH4mU9NwZt_MNGbA6XkObESkiLAlLyn_IZerhFmW0g>
    <xmx:I6D6YpCVRGiUn16e5baEF_K92HW-2NYe3i3OLlAXYC2YhX7J0i1cQg>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 15 Aug 2022 15:36:02 -0400 (EDT)
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, memxor@gmail.com
Cc:     Daniel Xu <dxu@dxuuu.xyz>, pablo@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next 1/3] bpf: Remove duplicate PTR_TO_BTF_ID RO check
Date:   Mon, 15 Aug 2022 13:35:46 -0600
Message-Id: <03eb20693dc9d0e5a859471a9e072538a1a366c8.1660592020.git.dxu@dxuuu.xyz>
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

