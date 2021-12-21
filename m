Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C32447C5A5
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 19:01:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235847AbhLUSBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 13:01:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233046AbhLUSB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 13:01:29 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A4BAC061574
        for <netdev@vger.kernel.org>; Tue, 21 Dec 2021 10:01:29 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id x10so18803837ioj.9
        for <netdev@vger.kernel.org>; Tue, 21 Dec 2021 10:01:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8jLrt0FEkIr/O09JwBAhtxAOeTCrg65/dKVt4uECJkU=;
        b=xgLRVrZ+c8E8s6S3dDxtEB81lK9kGIh6bB3qYGNmgvAUG7VB+kvQGxYphbmTPYHMM4
         1dMVBNpA9jTtjU23Cbz21bB1Tn1Ytfg+5l5YsvyWR1CswX1C1gFkkLVuWOkQT776tC33
         9o+RhRzTChQd5KZAHEscSyIbA5YpZicgqShOs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8jLrt0FEkIr/O09JwBAhtxAOeTCrg65/dKVt4uECJkU=;
        b=GTsaZL1FnZSLW7Z6wnoYVGkubeG8YWFN7IfZqyNk+JBdXSCDWf4LS9gpXWHWGsch0W
         EXHZBmrC/vGKTnpAyyOHxnMky9IEgL8dwjzHNxQvY2Yz5oT8SV6n+aZjH0nHONwoD3d9
         i/NhXxsCDuu6L7uxgNuapbH2wvbu9yrV5YDow6Qg8siyrWYwdgSlNb1+s64RI2irLBom
         lrVK+PRHK30O9JZVZ4rsni1kSIMCGFQNKWEGCNbeFHstFN6WxIAPMIm+vpNqn3DvuH/r
         cGnOhMKLkr2XsmWD3nObZuhqrZYkF7aubqJJnAiLoxhEHt/9jytKa3nv+b5i8u4XIeUU
         kivA==
X-Gm-Message-State: AOAM530AtyxEOA3ccfb7okOzR7gMFgqvtB18tPRly1trY5BmQF5pO4Zq
        GgYVmaD7fNqBuJrYm5nBDizILW9LNBzwC8qb0sM6Xw==
X-Google-Smtp-Source: ABdhPJzjazvF7Lqq5kzwRzcX+uC9xaevQcC1BvoZoyyz3BKm7gz3rut/Op+T6DWZJgWrd1H5nIziiXG1efNNbgwWoIY=
X-Received: by 2002:a5e:d602:: with SMTP id w2mr2311869iom.121.1640109688829;
 Tue, 21 Dec 2021 10:01:28 -0800 (PST)
MIME-Version: 1.0
References: <CALrw=nGtZbuQWdwh26qJA6HbbLsCNZjU4jaY78acbKfAAan+5w@mail.gmail.com>
 <CANn89i+CF0G+Yx_aJMURxBbr0mqDzS5ytQY7RtYh_pY0cOh01A@mail.gmail.com>
 <cf25887f1321e9b346aa3bf487bd55802f7bca80.camel@redhat.com>
 <CALrw=nG5-Qyi8f0j6-dmkVts4viX24j755gEiUNTQDoXzXv1XQ@mail.gmail.com> <3d6d818ff01b363ae7ec6740dc3cd3e62aa16682.camel@redhat.com>
In-Reply-To: <3d6d818ff01b363ae7ec6740dc3cd3e62aa16682.camel@redhat.com>
From:   Ignat Korchagin <ignat@cloudflare.com>
Date:   Tue, 21 Dec 2021 18:01:18 +0000
Message-ID: <CALrw=nEAEqq71Bwn0tJvFum3a1Ht6ynGedjH7uFpfFgSOU1AHg@mail.gmail.com>
Subject: Re: tcp: kernel BUG at net/core/skbuff.c:3574!
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 21, 2021 at 5:31 PM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Tue, 2021-12-21 at 17:16 +0000, Ignat Korchagin wrote:
> > On Tue, Dec 21, 2021 at 3:40 PM Paolo Abeni <pabeni@redhat.com> wrote:
> > >
> > > On Tue, 2021-12-21 at 06:16 -0800, Eric Dumazet wrote:
> > > > On Tue, Dec 21, 2021 at 4:19 AM Ignat Korchagin <ignat@cloudflare.com> wrote:
> > > > >
> > > > > Hi netdev,
> > > > >
> > > > > While trying to reproduce a different rare bug we're seeing in
> > > > > production I've triggered below on 5.15.9 kernel and confirmed on the
> > > > > latest netdev master tree:
> > > > >
> > > >
> > > > Nothing comes to mind. skb_shift() has not been recently changed.
> > > >
> > > > Why are you disabling TSO exactly ?
> > > >
> > > > Is GRO being used on veth needed to trigger the bug ?
> > > > (GRO was added recently to veth, I confess I did not review the patches)
> >
> > Yes, it seems enabling GRO for veth actually enables NAPI codepaths,
> > which trigger this bug (and actually another one we're investigating).
> > Through trial-and-error it seems disabling TSO is more likely to
> > trigger it at least in my dev environment. I'm not sure if this bug is
> > somehow related to the other one we're investigating, but once we have
> > a fix here I can try to verify before posting it to the mailing list.
> >
> > > This is very likely my fault. I'm investigating it right now.
> >
> > Thank you very much! Let me know if I can help somehow.
>
> I'm testing the following patch. Could you please have a spin in your
> testbed, too?

Seems with the patch the BUG does not reproduce for me anymore.

Ignat

> Thanks!
>
> Paolo
> ---
> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> index 38f6da24f460..b490448ca42c 100644
> --- a/drivers/net/veth.c
> +++ b/drivers/net/veth.c
> @@ -711,6 +711,14 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
>         rcu_read_lock();
>         xdp_prog = rcu_dereference(rq->xdp_prog);
>         if (unlikely(!xdp_prog)) {
> +               if (unlikely(skb_shared(skb) || skb_head_is_locked(skb))) {
> +                       struct sk_buff *nskb = skb_copy(skb, GFP_ATOMIC | __GFP_NOWARN);
> +
> +                       if (!nskb)
> +                               goto drop;
> +                       consume_skb(skb);
> +                       skb = nskb;
> +               }
>                 rcu_read_unlock();
>                 goto out;
>         }
>
>
>
