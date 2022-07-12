Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCF485727A8
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 22:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233527AbiGLUtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 16:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233820AbiGLUtR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 16:49:17 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 588D5252AE
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 13:49:16 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id c18-20020a17090a8d1200b001ef85196fb4so69756pjo.4
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 13:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=cuvq4bUWwZbFcbUnzZRr8NI/5HR3fBjcZcaAmfqVlFU=;
        b=aEc24jtNuGsFPRPw10yY+5J9BC4+vKg5SgzAyA5BOyeeAZtp1qVYQuov9ZQE9tVSbq
         OyVFIkB4pTY9mG42431wVtIjYTTcusxsK4JI63nPZTrMa9FB+es4cpteK1w3F/lvIR5E
         QUUl+GUxAxs1n4gyikaBH7XIWARwYDpWsOxBz7uXOWFTCwvO4X0+TE2/i8ucGrOa9SF0
         jilaHXW3a+P3hllpuVwfzpRwD/HCeKL9nFtnuCnULaVz6oSEGrXpaG4E7fWRV9n8PjnH
         Ffz+KnvuTlWzBFFrew6SPbOMLvQ7lxyiYlzMa2JTPXsLxDSFijK571xoMS0T7pkQ8+Um
         aQVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=cuvq4bUWwZbFcbUnzZRr8NI/5HR3fBjcZcaAmfqVlFU=;
        b=NJDqCL0+J8vC5Mdo5s0igw3BeucZxhY9ub/FqM2SI4xiR0b/SxqWvr7nuzeCwNzJhQ
         0Jd5vnwPwuvEAaIJRMbKmhmBdzl7zqjXMcwKb9I3/RdOZHsdv1heB0VAn7hcNbW1lqn1
         +VK82YVYGf+8VV+XZJ3dQkXrdlYQpL92UcIxb43S6AWNspbgPvZy6utaFZB0uMrVTNcO
         DS4Kqz0FRbNftW2TZwt3HuRPh6ZIo6k357KCNS7zhBFaMewcSO0Koj+zGM5sgdrm02ay
         2Y8J5TkS6V5cU8vO93JR932i2wCNIMxDP11X+S7+sMbLpUMCmBc6X6jzJGDDcGMjCT8H
         OszQ==
X-Gm-Message-State: AJIora8rl2xS0L1wJaZFHkoWD9MYNJDJyj3m0oEO5f0aXtI3sT6nbzyu
        hwQ3EloVth4daLNmqFHUbEk/stj0JcKfMY9SVQ==
X-Google-Smtp-Source: AGRyM1tbq3ODEHrZNuPHyvvTyeeSArRQcxH/uOHsUPcJw0jQTZ/lUTlEFAAhYIuV6hDuQsMcDrDKTmKIu8fb3tMhoQ==
X-Received: from justinstitt.mtv.corp.google.com ([2620:15c:211:202:b1e8:210d:ae12:d0df])
 (user=justinstitt job=sendgmr) by 2002:a05:6a00:a26:b0:528:9831:d935 with
 SMTP id p38-20020a056a000a2600b005289831d935mr24956851pfh.25.1657658955901;
 Tue, 12 Jul 2022 13:49:15 -0700 (PDT)
Date:   Tue, 12 Jul 2022 13:49:00 -0700
In-Reply-To: <Ys3DwnYiF9eDwr2T@dev-arch.thelio-3990X>
Message-Id: <20220712204900.660569-1-justinstitt@google.com>
Mime-Version: 1.0
References: <Ys3DwnYiF9eDwr2T@dev-arch.thelio-3990X>
X-Mailer: git-send-email 2.37.0.144.g8ac04bfd2-goog
Subject: [PATCH v2] netfilter: xt_TPROXY: remove pr_debug invocations
From:   Justin Stitt <justinstitt@google.com>
To:     nathan@kernel.org
Cc:     coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com,
        fw@strlen.de, justinstitt@google.com, kadlec@netfilter.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, ndesaulniers@google.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pabeni@redhat.com, pablo@netfilter.org, trix@redhat.com
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

pr_debug calls are no longer needed in this file.

Pablo suggested "a patch to remove these pr_debug calls". This patch has
some other beneficial collateral as it also silences multiple Clang
-Wformat warnings that were present in the pr_debug calls.

Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Justin Stitt <justinstitt@google.com>
---
diff from v1 -> v2:
* converted if statement one-liner style
* x == NULL is now !x

 net/netfilter/xt_TPROXY.c | 25 ++-----------------------
 1 file changed, 2 insertions(+), 23 deletions(-)

diff --git a/net/netfilter/xt_TPROXY.c b/net/netfilter/xt_TPROXY.c
index 459d0696c91a..e4bea1d346cf 100644
--- a/net/netfilter/xt_TPROXY.c
+++ b/net/netfilter/xt_TPROXY.c
@@ -74,18 +74,10 @@ tproxy_tg4(struct net *net, struct sk_buff *skb, __be32 laddr, __be16 lport,
 		/* This should be in a separate target, but we don't do multiple
 		   targets on the same rule yet */
 		skb->mark = (skb->mark & ~mark_mask) ^ mark_value;
-
-		pr_debug("redirecting: proto %hhu %pI4:%hu -> %pI4:%hu, mark: %x\n",
-			 iph->protocol, &iph->daddr, ntohs(hp->dest),
-			 &laddr, ntohs(lport), skb->mark);
-
 		nf_tproxy_assign_sock(skb, sk);
 		return NF_ACCEPT;
 	}
 
-	pr_debug("no socket, dropping: proto %hhu %pI4:%hu -> %pI4:%hu, mark: %x\n",
-		 iph->protocol, &iph->saddr, ntohs(hp->source),
-		 &iph->daddr, ntohs(hp->dest), skb->mark);
 	return NF_DROP;
 }
 
@@ -122,16 +114,12 @@ tproxy_tg6_v1(struct sk_buff *skb, const struct xt_action_param *par)
 	int tproto;
 
 	tproto = ipv6_find_hdr(skb, &thoff, -1, NULL, NULL);
-	if (tproto < 0) {
-		pr_debug("unable to find transport header in IPv6 packet, dropping\n");
+	if (tproto < 0)
 		return NF_DROP;
-	}
 
 	hp = skb_header_pointer(skb, thoff, sizeof(_hdr), &_hdr);
-	if (hp == NULL) {
-		pr_debug("unable to grab transport header contents in IPv6 packet, dropping\n");
+	if (!hp)
 		return NF_DROP;
-	}
 
 	/* check if there's an ongoing connection on the packet
 	 * addresses, this happens if the redirect already happened
@@ -168,19 +156,10 @@ tproxy_tg6_v1(struct sk_buff *skb, const struct xt_action_param *par)
 		/* This should be in a separate target, but we don't do multiple
 		   targets on the same rule yet */
 		skb->mark = (skb->mark & ~tgi->mark_mask) ^ tgi->mark_value;
-
-		pr_debug("redirecting: proto %hhu %pI6:%hu -> %pI6:%hu, mark: %x\n",
-			 tproto, &iph->saddr, ntohs(hp->source),
-			 laddr, ntohs(lport), skb->mark);
-
 		nf_tproxy_assign_sock(skb, sk);
 		return NF_ACCEPT;
 	}
 
-	pr_debug("no socket, dropping: proto %hhu %pI6:%hu -> %pI6:%hu, mark: %x\n",
-		 tproto, &iph->saddr, ntohs(hp->source),
-		 &iph->daddr, ntohs(hp->dest), skb->mark);
-
 	return NF_DROP;
 }
 
-- 
2.37.0.144.g8ac04bfd2-goog

