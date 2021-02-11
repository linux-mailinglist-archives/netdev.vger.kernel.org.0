Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C77143192FE
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 20:22:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbhBKTWW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 14:22:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbhBKTWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 14:22:20 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6095C061756
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 11:21:39 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id a25so8773813ljn.0
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 11:21:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Xunu+ENdh+r38XIL6q3M+9sV0a1CJTulNyUPzxZ3qIw=;
        b=nH+ZYQhazXsvHlc9cxsp/+V87qPnTSBB5NMGt0yI2t65aJY9M2AH0N6Wq++YPbFZ1B
         DXwnVQkaGFzj2rqbKdzUiVHZ295hOJkyN+fvuMbiCeDX7tkHmAXWVIZbwPDdz8iZnjY3
         cXtewS0IRMCzlVMWAZAyWs4OCwvhxuFb13hZEAt0o6qX5eMD61LZi87npo//VLvfYLwt
         myeH/70hVMgYumuRxZmTmiPsZ2OIge+d2Rg+LGne5ALtLIN/XGUFpgMHWXK1TU4pTb1O
         cLsHz5EAlpzfDDzpdy3CrRIzeHx6PkrWJA1ZUspa001rq8+FgjcZSG4IoL1UPpphBQXq
         i4aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Xunu+ENdh+r38XIL6q3M+9sV0a1CJTulNyUPzxZ3qIw=;
        b=Urpmhay7u+hl227o//X2brPtojsX5i7p8Qv8Ck0P1OuCsc8cVntseCXjWX1jq0opno
         o4el9U947faSrkmAdFsrakkhA44aJ/oVb3SFi3tkquNXhlvogVzWUdmOIgC2yeImnP8h
         L0DsGlDqnRWBjZwge3KYSjjUB4o/IeMoZetA+bz7cTRuLkRp/qyo03AFU4+Bc5JQnE4K
         Ae/PZBD9NIi/gQlsDW82aJRTP2lVMAcIzoUcRXxzmXtSxA0MauIBfHDsH7pm6zeAUN1q
         asQZIejPKPoDHa/yyc6VQGPolWSsUXGkgf0LnhHtduxEFlQ3ISIbtCq++IStMp7z8H3h
         5bfg==
X-Gm-Message-State: AOAM531WrJ9IPwAyHLGJ2+aAYuL9bANMNwW/SD/l3D93IMBBSpuhgM3m
        RK2n/LjacDOTS3nWLwFOSiW0HWpPve7kXWl4QAY=
X-Google-Smtp-Source: ABdhPJyqvc/9/nHELqL7jI/JeYTPjAQ0XQqPCI4ZKiSIrUAYBumo1ehqDZzrJ8vP0y8Z5mpozfolPnSQA6Js5ILuyQg=
X-Received: by 2002:a05:651c:233:: with SMTP id z19mr5613728ljn.486.1613071298208;
 Thu, 11 Feb 2021 11:21:38 -0800 (PST)
MIME-Version: 1.0
References: <ca64de092db5a2ac80d22eaa9d662520@codeaurora.org>
 <56e72b72-685f-925d-db2d-d245c1557987@gmail.com> <CAEA6p_D+diS7jnpoGk6cncWL8qiAGod2EAp=Vcnc-zWNPg04Jg@mail.gmail.com>
 <307c2de1a2ddbdcd0a346c57da88b394@codeaurora.org> <CAEA6p_ArQdNp=hQCjrsnAo-Xy22d44b=2KdLp7zO7E7XDA4Fog@mail.gmail.com>
 <f10c733a-09f8-2c72-c333-41f9d53e1498@gmail.com> <6a314f7da0f41c899926d9e7ba996337@codeaurora.org>
 <839f0ad6-83c1-1df6-c34d-b844c52ba771@gmail.com> <9f25d75823a73c6f0f556f0905f931d1@codeaurora.org>
 <5905440c-163a-d13e-933e-c9273445a6ed@gmail.com> <CAEA6p_CfmJZuYy7msGm0hi813q92hO2daC_zEZhhj0y3FYJ4LA@mail.gmail.com>
In-Reply-To: <CAEA6p_CfmJZuYy7msGm0hi813q92hO2daC_zEZhhj0y3FYJ4LA@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 11 Feb 2021 11:21:26 -0800
Message-ID: <CAADnVQ+AbH0Xs_fF5mESb2i-TCL0T-inpAX+gtggDbHhA+9djA@mail.gmail.com>
Subject: Re: Refcount mismatch when unregistering netdevice from kernel
To:     Wei Wang <weiwan@google.com>
Cc:     David Ahern <dsahern@gmail.com>, stranche@codeaurora.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Mahesh Bandewar <maheshb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 5, 2021 at 11:11 AM Wei Wang <weiwan@google.com> wrote:
>
> On Mon, Jan 4, 2021 at 8:58 PM David Ahern <dsahern@gmail.com> wrote:
> >
> > On 1/4/21 8:05 PM, stranche@codeaurora.org wrote:
> > >
> > > We're able to reproduce the refcount mismatch after some experimentation
> > > as well.
> > > Essentially, it consists of
> > > 1) adding a default route (ip -6 route add dev XXX default)
> > > 2) forcing the creation of an exception route via manually injecting an
> > > ICMPv6
> > > Packet Too Big into the device.
> > > 3) Replace the default route (ip -6 route change dev XXX default)
> > > 4) Delete the device. (ip link del XXX)
> > >
> > > After adding a call to flush out the exception cache for the route, the
> > > mismatch
> > > is no longer seen:
> > > diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
> > > index 7a0c877..95e4310 100644
> > > --- a/net/ipv6/ip6_fib.c
> > > +++ b/net/ipv6/ip6_fib.c
> > > @@ -1215,6 +1215,7 @@ static int fib6_add_rt2node(struct fib6_node *fn,
> > > struct fib6_info *rt,
> > >                 }
> > >                 nsiblings = iter->fib6_nsiblings;
> > >                 iter->fib6_node = NULL;
> > > +               rt6_flush_exceptions(iter);
> > >                 fib6_purge_rt(iter, fn, info->nl_net);
> > >                 if (rcu_access_pointer(fn->rr_ptr) == iter)
> > >                         fn->rr_ptr = NULL;
> >
> > Ah, I see now. rt6_flush_exceptions is called by fib6_del_route, but
> > that won't handle replace.
> >
> > If you look at fib6_purge_rt it already has a call to remove pcpu
> > entries. This call to flush exceptions should go there and the existing
> > one in fib6_del_route can be removed.
> >
> Thanks for catching this!
> Agree with this proposed fix.

Looks like this fix never landed?
Is it still needed or there was an alternative fix merged?
