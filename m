Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3683056C57D
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 02:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229455AbiGIAhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 20:37:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiGIAhU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 20:37:20 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0917C8E4E1
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 17:37:19 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-31cb93cadf2so2717847b3.11
        for <netdev@vger.kernel.org>; Fri, 08 Jul 2022 17:37:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=nIOdyfUDOuPdVLt7ksu7PVNTjcXNzQQTOJh36uQBLdI=;
        b=NqBR7hRseYFHoMsnRFTk89V8cSnuHJV5mvA3y4Vk33uUrjNCKuHT4pl19gAUNi+Dax
         zwBUmPo6FqBNc7pN2LWNtXwXuOcTnqJMul1rixwFNbf2XBCk+uAtRBgeb4CvFAPrGiG4
         opdiSqMuxHB8ltpTETRZJfhINcS1BoQ5i5hQxO2AWaBweSPmnT0IikalBpA9zuIBh2Xd
         SgGxFHmttmmj30Bw2OhlyM+D39A1L+ewjelBI1UHzvR7iOlV7e54CaCKzcw6izBmIgl/
         5aO+m5GwAXO3eIrMIbedfkYWOji2nUj3eOuBLWq+ZH+gR+U065eF4HsZfOs3Nr7lqog7
         5x8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=nIOdyfUDOuPdVLt7ksu7PVNTjcXNzQQTOJh36uQBLdI=;
        b=YqLcqIZC82s+1qh9z1/ewVIm7HvCOChIfVXM+DbeIxrwjM8+3e5t55VNsgDjqXo1HH
         RnnuxumQb6dKfpdLkShmt243G88O+stbbPRf/3+knn7tvFqejV0LTG381le1gCW7g6Va
         adFmanItLlK7/cuxVUHvute2dWaQP7jXMXP5mXjmtay3kKbMmZIqkihXZoAH+xBsYUHJ
         10eFNdzLtLtU2ddR1wCwOa0Ea+nhwWa2fwTI8WXU3+3aJEqBSABbQAIC46wOyS6Qa7Cm
         w6TD+vH5PKzM7Q1C/6wpNNMTSSSpZONjwHAPv8LJnrs6gdiuGNcSuQBfYi/zQim9enKn
         ivrA==
X-Gm-Message-State: AJIora8Z4UwSQ/gen9P5wD+PRjq1YWVClbXoruTvyoHk1wCmZoIZkYve
        fnEKjPnvIZHKTp+3o7NRvQodMn4PbgV5QgaNow==
X-Google-Smtp-Source: AGRyM1v89wRj4tyQeUzPicy/PVgbMHnA/2Tmjdwr9EP6QeeA76WzOe3kRu9vSoZdIO41TqInLh1rn8X0OFRk2oziZw==
X-Received: from justinstitt.mtv.corp.google.com ([2620:15c:211:202:f21c:9185:9405:36f])
 (user=justinstitt job=sendgmr) by 2002:a25:4290:0:b0:66e:53b2:56ed with SMTP
 id p138-20020a254290000000b0066e53b256edmr6565221yba.254.1657327038369; Fri,
 08 Jul 2022 17:37:18 -0700 (PDT)
Date:   Fri,  8 Jul 2022 17:37:04 -0700
Message-Id: <20220709003704.646568-1-justinstitt@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH v2] net: ipv4: fix clang -Wformat warnings
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
        Justin Stitt <justinstitt@google.com>,
        Joe Perches <joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When building with Clang we encounter these warnings:
| net/ipv4/ah4.c:513:4: error: format specifies type 'unsigned short' but
| the argument has type 'int' [-Werror,-Wformat]
| aalg_desc->uinfo.auth.icv_fullbits / 8);
-
| net/ipv4/esp4.c:1114:5: error: format specifies type 'unsigned short'
| but the argument has type 'int' [-Werror,-Wformat]
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
Suggested-by: Joe Perches <joe@perches.com>
Suggested-by: Nathan Chancellor <nathan@kernel.org>
Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
---
diff from v1 -> v2:
* packaged two related patches together: (Suggested by Nick)
  - https://lore.kernel.org/all/20220707181532.762452-1-justinstitt@google.com/
  - https://lore.kernel.org/all/20220707173040.704116-1-justinstitt@google.com/
* use Joe's suggestion regarding `%u` over `%d`.

 net/ipv4/ah4.c  | 2 +-
 net/ipv4/esp4.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ah4.c b/net/ipv4/ah4.c
index 6eea1e9e998d..f8ad04470d3a 100644
--- a/net/ipv4/ah4.c
+++ b/net/ipv4/ah4.c
@@ -507,7 +507,7 @@ static int ah_init_state(struct xfrm_state *x)
 
 	if (aalg_desc->uinfo.auth.icv_fullbits/8 !=
 	    crypto_ahash_digestsize(ahash)) {
-		pr_info("%s: %s digestsize %u != %hu\n",
+		pr_info("%s: %s digestsize %u != %u\n",
 			__func__, x->aalg->alg_name,
 			crypto_ahash_digestsize(ahash),
 			aalg_desc->uinfo.auth.icv_fullbits / 8);
diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index b21238df3301..b694f352ce7a 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -1108,7 +1108,7 @@ static int esp_init_authenc(struct xfrm_state *x)
 		err = -EINVAL;
 		if (aalg_desc->uinfo.auth.icv_fullbits / 8 !=
 		    crypto_aead_authsize(aead)) {
-			pr_info("ESP: %s digestsize %u != %hu\n",
+			pr_info("ESP: %s digestsize %u != %u\n",
 				x->aalg->alg_name,
 				crypto_aead_authsize(aead),
 				aalg_desc->uinfo.auth.icv_fullbits / 8);
-- 
2.37.0.rc0.161.g10f37bed90-goog

