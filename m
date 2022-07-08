Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01ED356C522
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 02:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239626AbiGHXdy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 19:33:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237856AbiGHXdx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 19:33:53 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC8EA2F66C
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 16:33:50 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id z25so159204lfr.2
        for <netdev@vger.kernel.org>; Fri, 08 Jul 2022 16:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f6TCUIosa5W4/Vb9XWvZYFOtAww3GSDuGtA/pDdfbF4=;
        b=kLfgt0CyeLHwI1Zct0de1ZglNn4qUt2rr5geGoDsSTgx69fJt12j4VOiv3EMjJhrfP
         4EfxQ8s9or1yPVXNnB6Nnv+VmaDKbN+Y8QSK1/izwn1niA9dh2Jau5kg1IoqVeJ2zL+/
         yri/FIwuFlMNvsLB47gk6qvyn8+Hi7j5NeF62JksRYesZuV12v1mWoWdBrJdpgDH47LX
         7qysqkSMPCfQnvyYybnOBfUTIiRSP67jOamssr8f+Pl0B7zgnLGjBqA617wXrmGj+mub
         yU1Nn/n/9oKGz3f0hZFQVGZBJ3ZroXY+pe4WZkE4BpigDyIrjeTx/mys2PDNQj/dfO8I
         3giQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f6TCUIosa5W4/Vb9XWvZYFOtAww3GSDuGtA/pDdfbF4=;
        b=I40+3mRaHGYXmJXg1lvgHrAZwG2hQPBEs410Hab6PcUqTF7lbVMaoMOSawBtb0RyxX
         zRB9+xWuqPSoVNQfPuscpfeVUxPKS2CcK1BFvl+YyGhxnkqsSWL/5AySracoVf7Yjp2k
         oqkaR0TJL7MdAgRSiIAmTgX0wv0DeR8JSFzIKeuDaLzaWnf83AJI7KvmyEdmynqS7JNg
         7NCiNG5nK5apBzoL1ELXeLHebF7JZARpAi1hUpprDrU/+I2C+kGdGZ1xvwZzOUz1YWYx
         jdfeJq/xNKgNd8zhE3tVif6VrVqHlLJbqSstt5sw2sBS2/QWBJAnJ876r4gS3HdoQdJl
         zzcg==
X-Gm-Message-State: AJIora/lnMRB9eXROC9lZpO6aWpaNxpuQ/eC8w9UC5tV8jJDUFM+c0dV
        6zwf1ABiTdrbK80pQirW69H1uRsh0G048qjfm6mkuw==
X-Google-Smtp-Source: AGRyM1sYwzFO76ZbUUlO+uxQCC5vi+M7eJm5XjlDoev9CqoJeGkALjAG+zYM/rC7CZhTfV/eDMYh4GGeHBCX1ORWazI=
X-Received: by 2002:a05:6512:2623:b0:47d:ace7:c804 with SMTP id
 bt35-20020a056512262300b0047dace7c804mr3904909lfb.647.1657323228912; Fri, 08
 Jul 2022 16:33:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220707191745.840590-1-justinstitt@google.com>
In-Reply-To: <20220707191745.840590-1-justinstitt@google.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Fri, 8 Jul 2022 16:33:37 -0700
Message-ID: <CAKwvOd=qjQxGmRD29DrFjhEpbrDHyTUhRfHKJGJ2i-oo_RvF_A@mail.gmail.com>
Subject: Re: [PATCH] netfilter: xt_TPROXY: fix clang -Wformat warnings:
To:     Justin Stitt <justinstitt@google.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Tom Rix <trix@redhat.com>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 7, 2022 at 12:18 PM Justin Stitt <justinstitt@google.com> wrote:
>
> When building with Clang we encounter these warnings:
> | net/netfilter/xt_TPROXY.c:173:5: error: format specifies type 'unsigned
> | char' but the argument has type 'int' [-Werror,-Wformat] tproto,
> | &iph->saddr, ntohs(hp->source),
> -
> | net/netfilter/xt_TPROXY.c:181:4: error: format specifies type 'unsigned
> | char' but the argument has type 'int' [-Werror,-Wformat] tproto,
> | &iph->saddr, ntohs(hp->source),
>
> The format specifier `%hhu` refers to a u8 while tproto is an int. In
> this case we weren't losing any data because ipv6_find_hdr returns an
> int but its return value (nexthdr) is a u8. This u8 gets widened to an
> int when returned from ipv6_find_hdr and assigned to tproto. The
> previous format specifier is functionally fine but still produces a
> warning due to a type mismatch.
>
> The fix is simply to listen to Clang and change `%hhu` to `%d` for both
> instances of the warning.
>
> Link: https://github.com/ClangBuiltLinux/linux/issues/378
> Signed-off-by: Justin Stitt <justinstitt@google.com>

Thanks for the patch, this fixes the warning I observe when building
ARCH=arm64 allmodconfig with -Wno-format removed!
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>

> ---
> It should be noted that for this entire file to build without -Wformat
> warnings you should apply this `ntohs` patch which fixed many, many
> -Wformat warnings in the kernel.
> https://lore.kernel.org/all/20220608223539.470472-1-justinstitt@google.com/
>
>  net/netfilter/xt_TPROXY.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/net/netfilter/xt_TPROXY.c b/net/netfilter/xt_TPROXY.c
> index 459d0696c91a..5d74abffc94f 100644
> --- a/net/netfilter/xt_TPROXY.c
> +++ b/net/netfilter/xt_TPROXY.c
> @@ -169,7 +169,7 @@ tproxy_tg6_v1(struct sk_buff *skb, const struct xt_action_param *par)
>                    targets on the same rule yet */
>                 skb->mark = (skb->mark & ~tgi->mark_mask) ^ tgi->mark_value;
>
> -               pr_debug("redirecting: proto %hhu %pI6:%hu -> %pI6:%hu, mark: %x\n",
> +               pr_debug("redirecting: proto %d %pI6:%hu -> %pI6:%hu, mark: %x\n",
>                          tproto, &iph->saddr, ntohs(hp->source),
>                          laddr, ntohs(lport), skb->mark);
>
> @@ -177,7 +177,7 @@ tproxy_tg6_v1(struct sk_buff *skb, const struct xt_action_param *par)
>                 return NF_ACCEPT;
>         }
>
> -       pr_debug("no socket, dropping: proto %hhu %pI6:%hu -> %pI6:%hu, mark: %x\n",
> +       pr_debug("no socket, dropping: proto %d %pI6:%hu -> %pI6:%hu, mark: %x\n",
>                  tproto, &iph->saddr, ntohs(hp->source),
>                  &iph->daddr, ntohs(hp->dest), skb->mark);
>
> --
> 2.37.0.rc0.161.g10f37bed90-goog
>


-- 
Thanks,
~Nick Desaulniers
