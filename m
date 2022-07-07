Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1687656A9AD
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 19:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236365AbiGGRcc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 13:32:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235810AbiGGRcc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 13:32:32 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17FD3313BF
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 10:32:31 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id a8-20020a25a188000000b0066839c45fe8so14029894ybi.17
        for <netdev@vger.kernel.org>; Thu, 07 Jul 2022 10:32:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=ZOW+O9e31Ha/guBWas9C4Qfgb7PDwF3Uvmoup8HsfZM=;
        b=GlhRrt0eoyTgPJ3ZkpprLlEDiblR4c5+StbPFc15B+NgqrsyC9Bgtqd8oORODmdNxC
         PBdDQZrVNljnjTBl7VHyA4sNkyeLqEzJ/d6ivs5fl+ZdeFbUMMHx49jhWnMYtvZpkzvM
         fqpMYiO0hTXxPJjGoK/WtLk2t8edvuQZ7HMwY2GF0gaZYvKy3ctX9VY8JX5m1wBkQGbM
         qHcOTwu5oLwsPaJU+OjdMPCnQoHU9qaTuihen0EmtNlQtbZqw6KQWT0gTV6j9cv9S3pi
         jEanFKfAsUg/1MOqzPKKmsMsQvxLfASvRqt89JMmNLZUknVi0Gtz41bggeKnolcYIxKc
         W5Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=ZOW+O9e31Ha/guBWas9C4Qfgb7PDwF3Uvmoup8HsfZM=;
        b=mKEpeKzgqlyV3I0lIvA5ibCi+9sj+2VXqgh20vRrvzs4gIW8Gt0JvHXlPHVEucc1o1
         KpWa+yNepNZ91VNHqNl3U/r9Wm3N4+IDoU+uQ+JMgb7ynIypp8CGO+9gJVND7h+LlLIn
         qfRoVpZGPTZGC46WTZ3xclAeHGqHm8Qnzk2Kv/ZyyIwmnqp6QcjFqGlF2p8qN/AhMkwW
         ArlfEe+1kQwvEgyDddvwO1/S7npnOfKJJAhRb89wBdpbVdGG2e6+W9d/HJ4E5o8giOCg
         t1zoRwKQ1uiq6I5i5OcYW4DNS18D3RuLrCHPlCtU+fqkvHK5TCPmwXcy/pFZMAwDdr5/
         MgWA==
X-Gm-Message-State: AJIora8p29+DaPduQ6u3/BgaZ65Dz0F7/o70LVrBluZRO1peh1rhtTeA
        sdloHJmBn0D1fBzwhxaYj3AQIwaoePNwI3d2rw==
X-Google-Smtp-Source: AGRyM1vGWOSYKAFjt67H1Pw8yisajdXsVeDlRauvs/71AQuzS3Qdnzm9JaYrsNVLi9oyAnzqltnu/fIwEIq+/G/RPQ==
X-Received: from justinstitt.mtv.corp.google.com ([2620:15c:211:202:4640:519a:f833:9a5])
 (user=justinstitt job=sendgmr) by 2002:a81:17ca:0:b0:31c:9a75:1f2b with SMTP
 id 193-20020a8117ca000000b0031c9a751f2bmr26412666ywx.83.1657215150360; Thu,
 07 Jul 2022 10:32:30 -0700 (PDT)
Date:   Thu,  7 Jul 2022 10:30:40 -0700
Message-Id: <20220707173040.704116-1-justinstitt@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH] net: ipv4: fix clang -Wformat warning
From:   Justin Stitt <justinstitt@google.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        Justin Stitt <justinstitt@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When building with Clang we encounter this warning:
| net/ipv4/ah4.c:513:4: error: format specifies type 'unsigned short' but
| the argument has type 'int' [-Werror,-Wformat]
| aalg_desc->uinfo.auth.icv_fullbits / 8);

`aalg_desc->uinfo.auth.icv_fullbits` is a u16 but due to default
argument promotion becomes an int.

Variadic functions (printf-like) undergo default argument promotion.
Documentation/core-api/printk-formats.rst specifically recommends using
the promoted-to-type's format flag.

As per C11 6.3.1.1:
(https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1548.pdf) `If an int
can represent all values of the original type ..., the value is
converted to an int; otherwise, it is converted to an unsigned int.
These are called the integer promotions.` Thus it makes sense to change
%hu to %d not only to follow this standard but to suppress the warning
as well.

Link: https://github.com/ClangBuiltLinux/linux/issues/378
Signed-off-by: Justin Stitt <justinstitt@google.com>
---
 net/ipv4/ah4.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/ah4.c b/net/ipv4/ah4.c
index 6eea1e9e998d..3bf3d01fb7e3 100644
--- a/net/ipv4/ah4.c
+++ b/net/ipv4/ah4.c
@@ -507,7 +507,7 @@ static int ah_init_state(struct xfrm_state *x)
 
 	if (aalg_desc->uinfo.auth.icv_fullbits/8 !=
 	    crypto_ahash_digestsize(ahash)) {
-		pr_info("%s: %s digestsize %u != %hu\n",
+		pr_info("%s: %s digestsize %u != %d\n",
 			__func__, x->aalg->alg_name,
 			crypto_ahash_digestsize(ahash),
 			aalg_desc->uinfo.auth.icv_fullbits / 8);
-- 
2.37.0.rc0.161.g10f37bed90-goog

