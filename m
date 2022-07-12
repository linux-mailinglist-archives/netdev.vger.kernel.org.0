Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A78BB572771
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 22:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232533AbiGLUjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 16:39:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232963AbiGLUjM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 16:39:12 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B504E019
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 13:39:10 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id u12so16397239eja.8
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 13:39:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b72alVckcPzZXzPWnEZYO93LPht+qX1JAJRyl2iLreU=;
        b=mKNHNl0MhdwN9VNUIsAeqMYqtN6x7jo+bgZDJ8Tpie4yosu6XpL9u//7HTijR8y1vG
         i2kASpeTvce2Wa/lgJctYYxTQnBK2NHPAYELGKpaUy86poX4Na6fr2pSUYk1TMpvWcbb
         yVxnGkV6/W4sXlR+bT3tj73cPouI7+c9NTh7eYKysF0iDACIl/jGdQbHh/2g0b0bNle3
         fGS04LI/ZrbQSdvz3LyOi/q7N/8lZrJX6+/gPUuTxHJS3l3a+6ntF24oAAjxTjwsHpOM
         soHCKTpG9SfhYUQ7hM1FlXsB/H+J9Dyq7Z9wzGgI6ODre7121pHvIigNUUk+EEvGVa7K
         r1Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b72alVckcPzZXzPWnEZYO93LPht+qX1JAJRyl2iLreU=;
        b=QeDyJxkaJ8ny+WtVELq8zoi0UtpIVLjN5/CGQ/egepOGu1vHvYw2JIzBOOrS/N1Kwt
         7dpn7NRwoX4XORK/wehtxsva1Pq2/uxnwQYV59/n8uC8TzY7PjvFfjZqGzHhtccSZ59r
         3DYNOxbUle+uXCK0m6YXBq7kfJuyuwNCO2fzh2lYo8M6SCbncHfbS9pY3lcSUamJ3liN
         Z9mAhjqLNyIzGPfG20MkoSCdEe3oypSeLdYyuyR38UFNm/m/iSUnT07r9sBG8yo1V2lU
         J+leyiJBzwMe424I8uyC0gaaQoqglnbDsr3vge5fiFoFWPHwcCSbuyIfDXSJ/bCwdiwc
         /Rcw==
X-Gm-Message-State: AJIora/ZDTKmVtP7sytvYzy8spZ3fiVSeKbQQM4pTNyev7iK9TSuwEuR
        2jFL9DBYf6ILhDd9Mnp1XjDYpaAHkgsFwTMGWM3L+w==
X-Google-Smtp-Source: AGRyM1uaOwRObudMR2tqAeKLM1yK768ppKsAI2478AttOzCgGg2aQ3satnFcPqe00VdjLDLOvQ30nGZXYu/XJJo2CzU=
X-Received: by 2002:a17:906:5a67:b0:72b:610d:4aa4 with SMTP id
 my39-20020a1709065a6700b0072b610d4aa4mr10225902ejc.294.1657658348687; Tue, 12
 Jul 2022 13:39:08 -0700 (PDT)
MIME-Version: 1.0
References: <Ys0zZACWwGilTwHx@salvia> <20220712183452.2949361-1-justinstitt@google.com>
 <Ys3DwnYiF9eDwr2T@dev-arch.thelio-3990X>
In-Reply-To: <Ys3DwnYiF9eDwr2T@dev-arch.thelio-3990X>
From:   Justin Stitt <justinstitt@google.com>
Date:   Tue, 12 Jul 2022 13:38:57 -0700
Message-ID: <CAFhGd8qz_QfX-h43koOcr6bKMRvESomgF2siQtkB=7ZRxWbwvA@mail.gmail.com>
Subject: Re: [PATCH] netfilter: xt_TPROXY: remove pr_debug invocations
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     pablo@netfilter.org, coreteam@netfilter.org, davem@davemloft.net,
        edumazet@google.com, fw@strlen.de, kadlec@netfilter.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, ndesaulniers@google.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pabeni@redhat.com, trix@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 12, 2022 at 11:56 AM Nathan Chancellor <nathan@kernel.org> wrote:
>
> Hi Justin,
>
> On Tue, Jul 12, 2022 at 11:34:52AM -0700, Justin Stitt wrote:
> > pr_debug calls are no longer needed in this file.
> >
> > Pablo suggested "a patch to remove these pr_debug calls". This patch has
> > some other beneficial collateral as it also silences multiple Clang
> > -Wformat warnings that were present in the pr_debug calls.
> >
> > Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > Signed-off-by: Justin Stitt <justinstitt@google.com>
>
> Thanks for the patch!
>
> Reviewed-by: Nathan Chancellor <nathan@kernel.org>
>
> Couple of style comments below that probably warrant a v2, you can carry
> the above tag forward for future revisions. No need to give me a
> "Suggested-by".
>
> > ---
> > Suggestion here: https://lore.kernel.org/all/Ys0zZACWwGilTwHx@salvia/
> >
> >  net/netfilter/xt_TPROXY.c | 19 -------------------
> >  1 file changed, 19 deletions(-)
> >
> > diff --git a/net/netfilter/xt_TPROXY.c b/net/netfilter/xt_TPROXY.c
> > index 459d0696c91a..dc7284e6357b 100644
> > --- a/net/netfilter/xt_TPROXY.c
> > +++ b/net/netfilter/xt_TPROXY.c
> > @@ -74,18 +74,10 @@ tproxy_tg4(struct net *net, struct sk_buff *skb, __be32 laddr, __be16 lport,
> >               /* This should be in a separate target, but we don't do multiple
> >                  targets on the same rule yet */
> >               skb->mark = (skb->mark & ~mark_mask) ^ mark_value;
> > -
> > -             pr_debug("redirecting: proto %hhu %pI4:%hu -> %pI4:%hu, mark: %x\n",
> > -                      iph->protocol, &iph->daddr, ntohs(hp->dest),
> > -                      &laddr, ntohs(lport), skb->mark);
> > -
> >               nf_tproxy_assign_sock(skb, sk);
> >               return NF_ACCEPT;
> >       }
> >
> > -     pr_debug("no socket, dropping: proto %hhu %pI4:%hu -> %pI4:%hu, mark: %x\n",
> > -              iph->protocol, &iph->saddr, ntohs(hp->source),
> > -              &iph->daddr, ntohs(hp->dest), skb->mark);
> >       return NF_DROP;
> >  }
> >
> > @@ -123,13 +115,11 @@ tproxy_tg6_v1(struct sk_buff *skb, const struct xt_action_param *par)
> >
> >       tproto = ipv6_find_hdr(skb, &thoff, -1, NULL, NULL);
> >       if (tproto < 0) {
>
> checkpatch.pl should have warned that these if statement braces here and
> below are no longer necessary because there is only one statement within
> them now.
Weirdly, checkpatch.pl gave 0 warnings regarding this patch. At any
rate, v2 is coming shortly. Thanks for the review!

>
>         if (tproto < 0)
>                 return NF_DROP;
>
> I believe it is important to do these types of style cleanups when doing
> a larger change so that people do not try to do them as standalone
> changes, which can irritate maintainers.
>
> > -             pr_debug("unable to find transport header in IPv6 packet, dropping\n");
> >               return NF_DROP;
> >       }
> >
> >       hp = skb_header_pointer(skb, thoff, sizeof(_hdr), &_hdr);
> >       if (hp == NULL) {
> > -             pr_debug("unable to grab transport header contents in IPv6 packet, dropping\n");
> >               return NF_DROP;
> >       }
>
>         if (hp == NULL)
>                 return NF_DROP;
>
> could even go a step farther and make it
>
>         if (!hp)
>                 return NF_DROP;
>
> if there is a warning about that.
>
> >
> > @@ -168,19 +158,10 @@ tproxy_tg6_v1(struct sk_buff *skb, const struct xt_action_param *par)
> >               /* This should be in a separate target, but we don't do multiple
> >                  targets on the same rule yet */
> >               skb->mark = (skb->mark & ~tgi->mark_mask) ^ tgi->mark_value;
> > -
> > -             pr_debug("redirecting: proto %hhu %pI6:%hu -> %pI6:%hu, mark: %x\n",
> > -                      tproto, &iph->saddr, ntohs(hp->source),
> > -                      laddr, ntohs(lport), skb->mark);
> > -
> >               nf_tproxy_assign_sock(skb, sk);
> >               return NF_ACCEPT;
> >       }
> >
> > -     pr_debug("no socket, dropping: proto %hhu %pI6:%hu -> %pI6:%hu, mark: %x\n",
> > -              tproto, &iph->saddr, ntohs(hp->source),
> > -              &iph->daddr, ntohs(hp->dest), skb->mark);
> > -
> >       return NF_DROP;
> >  }
> >
> > --
> > 2.37.0.144.g8ac04bfd2-goog
> >
