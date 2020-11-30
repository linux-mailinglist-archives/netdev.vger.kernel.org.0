Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 329CB2C9038
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 22:47:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730272AbgK3Vqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 16:46:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725861AbgK3Vqx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 16:46:53 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0802C0613CF
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 13:46:13 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id t8so13410701iov.8
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 13:46:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e3zgXUT6fATC/QGzJGBru337TjrL7JGd8iPB9ut9mNI=;
        b=sZ5YX1mfTr11fHZzz6JZb6++jU3rCGgsmfiOUxjAd+NLlb0i/h+5wlr6tMg47GnLLp
         rFXqpoxBuyGR1v9TcroSJxIIHtyI9w94QPc8F2nLJdHXHJax1HT5rDN9KSmsmmjBGpt6
         Xm3Q7w4tGu2BcAoTCEYGsavmeXdlav0qLDUZ4MfAXhNz+tvmW/S0gUlxXJH3AWObfhQn
         3hhUb3q2KFl1e5TlRo/syZi6jM6tmBkYG+9nLPVtLK3VCzpMcdzhPdcPlPKcwYIYPJiO
         oqLXnQu8QE5Dl1a2aPtkDxY5ESlKx5EJMK1fxKhX6GWLQvudtyAcXFYKY0hfRhDPWOky
         k3gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e3zgXUT6fATC/QGzJGBru337TjrL7JGd8iPB9ut9mNI=;
        b=s4TS2sJCqht+fD60XM9LpGcMnMbRzTx+gniZyI4WM4ZbL+C0RwKzVAtZ8zR3Dt4M/8
         xCN2NUYV8nb0SIiG3/5hv3EXPu13klSbjWkoBWu5Ccbo6iLXQZseEapDE0iGcbVne/Uz
         ra7mPVncK1BkgJIiQyWzYjkQrhfsoMlvVyr6LPVzlC7+6OQkiqw5uXVrx/NFihFFT4s1
         dJShqEoj44VpWAACprsDoTx9KkRYOIBKhp/sIRBuj8CGQx5c2+380akl3hAs88P5Q/mZ
         6IbSVIwpb3wPYUM66GvBlHctr1eVp0pO+RJbIou7YVgpQHI3mzmEKx5uIXoNUvMGSuYT
         RHlw==
X-Gm-Message-State: AOAM530mP7dVkg/ZSt3Vhv15J5tNryqgV/YvdVKpaEOkEOjdhMUrWjTc
        U1zL8cwEVm1g34Er1jOcDrb2f+Zg1fZybafaZKrbRjEIVfWZnw==
X-Google-Smtp-Source: ABdhPJwDQiVFEnnzniRoTq12RpJr/58ga0TnJfHNOrtGsTNN0Ly5/JY1/bxx64StQg9Bk2+SyfrJPLfVH9C1bHLnfBE=
X-Received: by 2002:a6b:f309:: with SMTP id m9mr15870719ioh.99.1606772772730;
 Mon, 30 Nov 2020 13:46:12 -0800 (PST)
MIME-Version: 1.0
References: <20201130190348.ayg7yn5fieyr4ksy@skbuf> <CANn89i+DYN4j2+MGK3Sh0=YAqmCyw0arcpm2bGO3qVFkzU_B4g@mail.gmail.com>
 <20201130194617.kzfltaqccbbfq6jr@skbuf> <20201130122129.21f9a910@hermes.local>
 <20201130202626.cnwzvzc6yhd745si@skbuf> <CANn89i+H9dVgVE0NbucHizZX2une+bjscjcCT+ZvVNj5YFHYpg@mail.gmail.com>
 <20201130203640.3vspyoswd5r5n3es@skbuf> <CANn89iJ1+P_ihPwyHGwCpkeu1OAj=gf+MAnyWmZvyMg4uMfodw@mail.gmail.com>
 <20201130205053.mb6ouveu3nsts3np@skbuf> <CANn89i+D+7XyYi=x2UxCrMM72GeP3u5MB0-7xruOZJGrERJ5vQ@mail.gmail.com>
 <20201130211158.37ay2uvdwcnegw45@skbuf>
In-Reply-To: <20201130211158.37ay2uvdwcnegw45@skbuf>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 30 Nov 2020 22:46:00 +0100
Message-ID: <CANn89iJGA8qWBJ97nnNGNOuLNUYF5WPnL+qi722KYCD7kvKyCg@mail.gmail.com>
Subject: Re: Correct usage of dev_base_lock in 2020
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jiri Benc <jbenc@redhat.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 30, 2020 at 10:12 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Mon, Nov 30, 2020 at 10:00:16PM +0100, Eric Dumazet wrote:
> > On Mon, Nov 30, 2020 at 9:50 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> > >
> > > On Mon, Nov 30, 2020 at 09:43:01PM +0100, Eric Dumazet wrote:
> > > > Understood, but really dev_base_lock can only be removed _after_ we
> > > > convert all usages to something else (mutex based, and preferably not
> > > > the global RTNL)
> > >
> > > Sure.
> > > A large part of getting rid of dev_base_lock seems to be just:
> > > - deleting the bogus usage from mlx4 infiniband and friends
> > > - converting procfs, sysfs and friends to netdev_lists_mutex
> > > - renaming whatever is left into something related to the RFC 2863
> > >   operstate.
> > >
> > > > Focusing on dev_base_lock seems a distraction really.
> > >
> > > Maybe.
> > > But it's going to be awkward to explain in words what the locking rules
> > > are, when the read side can take optionally the dev_base_lock, RCU, or
> > > netdev_lists_lock, and the write side can take optionally the dev_base_lock,
> > > RTNL, or netdev_lists_lock. Not to mention that anybody grepping for
> > > dev_base_lock will see the current usage and not make a lot out of it.
> > >
> > > I'm not really sure how to order this rework to be honest.
> >
> > We can not have a mix of RCU /rwlock/mutex. It must be one, because of
> > bonding/teaming.
> >
> > So all existing uses of rwlock / RCU need to be removed.
> >
> > This is probably not trivial.
>
> Now, "it's going to look nasty" is one thing, whereas "it won't work" is
> completely different. I think it would work though, so could you expand
> on why you're saying we can't have the mix?

You can not use dev_base_lock() or RCU and call an ndo_get_stats64()
that could sleep.

You can not for example start changing bonding, since bond_get_stats()
could be called from non-sleepable context (net/core/net-procfs.c)

I am still referring to your patch adding :

+       if (!rtnl_locked)
+               rtnl_lock();

This is all I said.
