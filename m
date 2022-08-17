Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9C71597601
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 20:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241077AbiHQSnl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 14:43:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240995AbiHQSnd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 14:43:33 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EC1063DB;
        Wed, 17 Aug 2022 11:43:18 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 38ADC5C00DD;
        Wed, 17 Aug 2022 14:43:17 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Wed, 17 Aug 2022 14:43:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1660761797; x=1660848197; bh=Wc
        b6Pbj94UhSYNHvOvjVvvYzPv6vZiSSIkN/TpJnmyo=; b=dsbSRSh97mbsxBkdIg
        1WKp3+srmdh3PPQYoZelPg1L2474Kro+GBV98nexBib/5aRt0G6vTS+nzQsyhK5a
        MB5XyK/9wQQl8F15a/h1okBkKCtS58cy8mgfcQxnuvdPa3GkLezKMC3CXD3kwM3W
        irJVv+Q9ojFjLXXS4fN5u3s3O4IMO/QYv/HoiOuM+XWkevXduo7bXlBe6UU6MJMj
        s5ppir4HO1k0JvKLUquApfffqNkWWw6Uxr6MgonsiPXB1MWxCTSCgwfm+TLaymJB
        yEL+Bab44hzH1Axd77qOjnyMmoE9+mLSNiqMS8xr2g9OG75DX525+qtVaIS6vGx6
        N6vw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1660761797; x=1660848197; bh=Wcb6Pbj94UhSY
        NHvOvjVvvYzPv6vZiSSIkN/TpJnmyo=; b=So1//5KHI0YdwPc+seXn3p5tunMR8
        EHjb2H5eikP527eE3AgnDHrE32yp/ulpEjMz/ufdRioCQKJHZ5ZsBxjGC7+zdNhL
        0GgcJZF8vEAmxrhUS8quv4YkSLfRCOshPYcWjvJcmotYnr5rNUNEGUA7GlTtFOsp
        rKvBzjg+OFchvhcZK38Vcr5K/uk2eC7U/PTm6AN8jDK+TfqCqJCEdOULdJ9h8Anv
        02izBwnbh6rlnMxG5sFJsN3jwmXHr13ztbNQArWQAWU03zvwfrmx8rRN2LIh9uq3
        R100RWc6aztAxi8Pvv4iFwV9PQUzOGixb3ADrpQ9Td/MmzXYf61y5RZQw==
X-ME-Sender: <xms:xTb9Yoxd0EZ6Qav-KvYhEYMcXQe9opGEWpQwybNXStPnDxHrgcGOWw>
    <xme:xTb9YsS4yUcmQpSgFgGS9DWiRjI4KmNDfqL5HFm2gfCtcHLraNLZbtz4_FyV4o0iS
    M5XJyvfQsxJHC8XdQ>
X-ME-Received: <xmr:xTb9YqUb9BDBDYamwvmUzJdYxVgdagEsqyeZzxoZDbX4jLpAlFz_Obd9UuOIE2x5sxvIpkbr5M22tXw8GQ78h8wldQABJe8BXn94>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdehiedgudeftdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdejtddmnecujfgurhephf
    fvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepffgrnhhivghlucgiuhcu
    oegugihusegugihuuhhurdighiiiqeenucggtffrrghtthgvrhhnpefgfefggeejhfduie
    ekvdeuteffleeifeeuvdfhheejleejjeekgfffgefhtddtteenucevlhhushhtvghrufhi
    iigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegugihusegugihuuhhurdighiii
X-ME-Proxy: <xmx:xTb9YmhvxV8qAoMNzp5Q2WWhF7a_Nk1_Q2hAEB2dafXYHXNzrYHikA>
    <xmx:xTb9YqCjS0kpndF8NiZQnQi6nhbiFlb8JaERsBi4FJCpKWedrnOrrw>
    <xmx:xTb9YnIHnUJyTo4FtvnBgAxQ1GGveNDcA38Al15nvCyqYEVD2ySOtg>
    <xmx:xTb9Yu5dYujNn8KTGhjNfPZmv6MI6pLGvJuRyiLVxVzHU6flIFASBQ>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 17 Aug 2022 14:43:16 -0400 (EDT)
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, memxor@gmail.com
Cc:     Daniel Xu <dxu@dxuuu.xyz>, pablo@netfilter.org, fw@strlen.de,
        toke@kernel.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v2 1/4] bpf: Remove duplicate PTR_TO_BTF_ID RO check
Date:   Wed, 17 Aug 2022 12:42:59 -0600
Message-Id: <3268db8bc504f4118e1baee5e49f917f0e2767fa.1660761470.git.dxu@dxuuu.xyz>
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

