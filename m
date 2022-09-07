Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 513EB5B0A51
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 18:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbiIGQlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 12:41:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbiIGQlM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 12:41:12 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D11E6F271;
        Wed,  7 Sep 2022 09:41:11 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 866DF5C0138;
        Wed,  7 Sep 2022 12:41:10 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Wed, 07 Sep 2022 12:41:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm1; t=1662568870; x=1662655270; bh=nu
        IsWQomKi3v21TLotEHkYcqbOkQOqi87ofu1RuqWes=; b=bTuqpdIkSK3dYMeOIh
        s1aecXICd/V39pvEK8OpKPgGNcIcOrgtxqdnX5M7LzUGUfC0wTm4/ai2MOI4QIrl
        Z59yHyRxyXvpccdPq+1p4isyMuAiJOQMkTESZWcqa8N+LgZwjj/ZePbi7ts4FuiW
        z+cGjgFRJE4LIRa8FfTbFgbg5dL/vKZXPPBBkvathy+YNYEgAScpfRdG3zdr2eU8
        Gx7rSvQsd42Aycmxr/R6tHRNCOJehZkemg0w7GeA4CDg+XWfoyDLJTUZG0ppzZGE
        nrZFJSavP0Llyz+2JOFu4mdFk8ipyj5D0AOeJGPq6mRD5zxtZ3m9lTlYaAjJVp9n
        Gvrg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1662568870; x=1662655270; bh=nuIsWQomKi3v2
        1TLotEHkYcqbOkQOqi87ofu1RuqWes=; b=1MyGeBcKurSAn3IQJwIlVnfoF+feA
        Xqqcol0CVi6vO7libML0/yy59ZflIfHnhsPTZfleF9258O5ucHBVwvSLX3PXu2jo
        f+Ada6+Tcwkuu3jNBKUVoTbrlvd3IASST5dkdrX+bbW3IA96atMdn6dc+z5swTG/
        RmLAiwhIQXXvnZxATmDU+Z27Y02i2VZ3dxDynLwdDbO93A2vaJjgpGAGdHyDxhB/
        NCaycdcDZhCGrbgNU7jdpadjczYTIQ629On6u4BFk3lCXZQg8fBLfLQcBKxrTkiy
        B6SKQuQIwrtj0eJjeKVoYLRR1U7w3McfAiV/HMytfEksso4rRHWqivQoA==
X-ME-Sender: <xms:pskYYytMu0pP4gUgXrm2ExHxYIT9IkVgiZs0I92dCGNHmlQBkXLZQQ>
    <xme:pskYY3csyOH_dS689Lx1chXI1izfuGWjmV8Bk3EIHFJ14-ZhTO77sUYyhVSn8FMky
    osj864Ig3_hLJWRFA>
X-ME-Received: <xmr:pskYY9wwQiE10ahgril9utqjcwf2Y6njIOFU3DOyNioIbDfLWQCSJkqjWZOaQi1Rqhg7rwX2x5S-GyD6XnShn0HcWrccuw93TndLZJQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfedttddguddtgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdefhedmnecujfgurhephf
    fvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepffgrnhhivghlucgiuhcu
    oegugihusegugihuuhhurdighiiiqeenucggtffrrghtthgvrhhnpefgfefggeejhfduie
    ekvdeuteffleeifeeuvdfhheejleejjeekgfffgefhtddtteenucevlhhushhtvghrufhi
    iigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegugihusegugihuuhhurdighiii
X-ME-Proxy: <xmx:pskYY9Phx7jLWqvEI0-JmX3r7rsSOqLWPTx3nYv1fghmpEWIx1d06A>
    <xmx:pskYYy99xqaABhLIQW0ROLQG-rdrwPGam3WH8LX34_DxyP_U2R-wUw>
    <xmx:pskYY1UjNgGNT4RfKTylXbTGlpjxRLPRjwbRxnNrdaBSBqcNbMrofA>
    <xmx:pskYY1W1H9zJf0-ODL44z_ubttTwyOjxIYfO7iWePimpacxbGpwGNg>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 7 Sep 2022 12:41:09 -0400 (EDT)
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, memxor@gmail.com
Cc:     Daniel Xu <dxu@dxuuu.xyz>, pablo@netfilter.org, fw@strlen.de,
        toke@kernel.org, martin.lau@linux.dev,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v5 1/6] bpf: Remove duplicate PTR_TO_BTF_ID RO check
Date:   Wed,  7 Sep 2022 10:40:36 -0600
Message-Id: <962da2bff1238746589e332ff1aecc49403cd7ce.1662568410.git.dxu@dxuuu.xyz>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <cover.1662568410.git.dxu@dxuuu.xyz>
References: <cover.1662568410.git.dxu@dxuuu.xyz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        PDS_OTHER_BAD_TLD,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
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
index 003f7ba19558..b711f94aa557 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -13447,9 +13447,6 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
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

