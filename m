Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 695835695A0
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 01:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233846AbiGFXJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 19:09:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233168AbiGFXJP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 19:09:15 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6714E1BE88
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 16:09:14 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id y4-20020a25b9c4000000b0066e573fb0fcso6037946ybj.21
        for <netdev@vger.kernel.org>; Wed, 06 Jul 2022 16:09:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=BL8nemdk5jEzjtFa4MSk1HVUJ0DaNKbCAoFg6fYn++s=;
        b=bglLJQL0h0LHXKQkfXprS+IpuekCyezknrwX1b1oldcSMzxc5+EEJF3XGtp3A/3t0A
         n+UK7hqnSo2sXYyAXnzGeqP5+z7VVWjBmiN77PQlDj3puZvNQR2CkJg+FZyoC0dzAQjZ
         xLBRB1+8NZx7VNI4Jz+h2fcGfm34nzXCE5Q7gzTeFvc4X1LCLceKuet9sGBsWFYPOHKj
         OpScw7YhRBAsM4+Z7ZZvHau/4fQPGNPWHheGQjbLFXTGAPmrQPmo1gMLc3NVP18LlLIT
         GSc2YM+56q4+EPWoJ7rw7pUqpPEBwAbjI8S4g4/g52pqsd4QHGppIoZ/4YhFj5OYSTtp
         cj2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=BL8nemdk5jEzjtFa4MSk1HVUJ0DaNKbCAoFg6fYn++s=;
        b=MiQ8bs7R6rSeJ+0YvQVDseRx8GucQor0Z0XafQJFm25pX9LSDwl9rFptLNUd/0exth
         8iTlUWVJtBzQg97hfQh+z4pl13bhgouAeaSp21qiT5HSkI5DSrrUn1gkYa944MoGl8hh
         isVS6y8vRH7BfDztfLu7KXpu6keXfxXw6MMqc0mbXnP57kFlFObWw3y3GuTl6jrTCSGr
         dzKgNDu57PH9hkqAwZarivzrJFJO3b8bTSoLRXMHCy0ClZnYFNqW3HvrIKXdUW+uQpcM
         5jfQTgURe4dJgHKQzsYARMX/d0QkAdUUO3WUgF6Nkq4C49ZY9fMGGDahXknkJkNEDQf0
         7jKw==
X-Gm-Message-State: AJIora8QJA/sBbixx+NXqFrfRSAUQXJDL2d0jjrjCXqgOthayUDl56ab
        0uQaKh+8TzL+pKo6IMl5CPqZmwTs+QU5arI/vg==
X-Google-Smtp-Source: AGRyM1txsNJpY89zwG+BQrlq4nx6igRgprquPYja0YIDI7rQxI9toEk3RzABG7zH+vtUrGf6FLMYfUagNFNB7tZ6Kw==
X-Received: from justinstitt.mtv.corp.google.com ([2620:15c:211:202:aab2:e000:4b5a:a767])
 (user=justinstitt job=sendgmr) by 2002:a0d:d387:0:b0:31c:d2e1:9277 with SMTP
 id v129-20020a0dd387000000b0031cd2e19277mr11472480ywd.421.1657148953698; Wed,
 06 Jul 2022 16:09:13 -0700 (PDT)
Date:   Wed,  6 Jul 2022 16:08:33 -0700
Message-Id: <20220706230833.535238-1-justinstitt@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH] net: l2tp: fix clang -Wformat warning
From:   Justin Stitt <justinstitt@google.com>
To:     James Chapman <jchapman@katalix.com>,
        "David S . Miller" <davem@davemloft.net>,
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

When building with clang we encounter this warning:
| net/l2tp/l2tp_ppp.c:1557:6: error: format specifies type 'unsigned
| short' but the argument has type 'u32' (aka 'unsigned int')
| [-Werror,-Wformat] session->nr, session->ns,

Both session->nr and session->ns are of type u32. The format specifier
previously used is `%hu` which would truncate our unsigned integer from
32 to 16 bits. This doesn't seem like intended behavior, if it is then
perhaps we need to consider suppressing the warning with pragma clauses.

This patch should get us closer to the goal of enabling the -Wformat
flag for Clang builds.

Link: https://github.com/ClangBuiltLinux/linux/issues/378
Signed-off-by: Justin Stitt <justinstitt@google.com>
---
 net/l2tp/l2tp_ppp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index 8be1fdc68a0b..db2e584c625e 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -1553,7 +1553,7 @@ static void pppol2tp_seq_session_show(struct seq_file *m, void *v)
 		   session->lns_mode ? "LNS" : "LAC",
 		   0,
 		   jiffies_to_msecs(session->reorder_timeout));
-	seq_printf(m, "   %hu/%hu %ld/%ld/%ld %ld/%ld/%ld\n",
+	seq_printf(m, "   %u/%u %ld/%ld/%ld %ld/%ld/%ld\n",
 		   session->nr, session->ns,
 		   atomic_long_read(&session->stats.tx_packets),
 		   atomic_long_read(&session->stats.tx_bytes),
-- 
2.37.0.rc0.161.g10f37bed90-goog

