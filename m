Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52907328A9D
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 19:20:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239631AbhCASUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 13:20:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239424AbhCASRg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 13:17:36 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0F3AC06178C
        for <netdev@vger.kernel.org>; Mon,  1 Mar 2021 10:16:56 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id b10so17929867ybn.3
        for <netdev@vger.kernel.org>; Mon, 01 Mar 2021 10:16:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1/VjnvcPuJxO7/paEY6ICI9381BuU9pj16ZSZ8LXnT8=;
        b=gIScon4JGGcyeEYxCbBUeAU+2Su9ifu4PHv0HrQsRK8BT1KOIcpcrf9k91zJZpjGp1
         X8UadC27AkyXgU6endb1U1b+/VX2N+9vGnt3mKtzpGREvLtvEwdJ4k2K9EWIyZbvaacp
         jUfHdh7pCYhHMn7Rg8lNjoyzuW4LLpZ9oNitOf42tKXAwCLc1MdMhilnvxovQh6skL/n
         lZi/wi+myO/MITMkxMrlhhrrlsutzYes8mGjmCOj3MQg5rL9i84ZsRqkmuiqg7l9Fclb
         Zhc+SUfA4yxronoYOBrPdk+rIPoUrgkl650cU+8vzBPSi3n7UbUvbRPBMlt4f8E9cNDa
         r8wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1/VjnvcPuJxO7/paEY6ICI9381BuU9pj16ZSZ8LXnT8=;
        b=O76Mu0uchA/S1vc60j7jQ986N78wLPZokHs11dNZ56G3NmEMh1SKG7dtNqjdX6w413
         6r+gffaXMy3tddx7GApoVH+2MAh//35qovSsawkX1Lf77AqeXhZldSWpdErCRK0fbxBl
         X4isR40HC8ebkkzpSpZoD8rQ2+rdvWXToYCIHvhhII7AnRm/PaoR+djxPlv9csWnmqbw
         9Q+IVmsQPlQsmvWKAoEIApcRhS1jJaGlR+c5iVCfAX5w08D5IU9xkvi0jmRsxZEw9KGO
         qAPyjCryOWFU3TBQAXRwSyYagNd5Fx9WkfKJL4FAbpSxhXPEtaBOpflgp+2QiXLml9kb
         e30w==
X-Gm-Message-State: AOAM531NQMz7TsOi8Z8rM7D/ysaNcwhpXoQpRL5mCSsC2kX9GoeXDxIm
        P8Ibe7k97eQ1+dP3HKgSpXAxbsYr0qh99gCOPHOrSlti/3o=
X-Google-Smtp-Source: ABdhPJwCaEk+j6i1aGTuIsdtLH1Khk03rsi62AvUWb6Ajr4RyJN8uTD3Yyxki2dOVwwYZKJmOltY5P32Y9OcQWq1oPI=
X-Received: by 2002:a25:9706:: with SMTP id d6mr24388022ybo.139.1614622616067;
 Mon, 01 Mar 2021 10:16:56 -0800 (PST)
MIME-Version: 1.0
References: <20210227003047.1051347-1-weiwan@google.com> <20210226164803.4413571f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAEA6p_CJx7K1Fab1C0Qkw=1VNnDaV9qwB_UUtikPMoqNUUWJuA@mail.gmail.com>
 <20210226172240.24d626e5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAEA6p_B6baYFZnEOMS=Nmvg0kA_qB=7ip4S96ys9ZoJWfOiOCA@mail.gmail.com>
 <20210226180833.09c98110@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAEA6p_ABZfs3zyQ+90cC1P8T8w94Lz4RvvBdQHQsHXEPP5aexQ@mail.gmail.com>
 <CAEA6p_DtTG6ryiG3GkxaySJeNcYF=RfkgCYTc-T-mHqMwL2-Gw@mail.gmail.com> <20210228111710.4e82a88e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210228111710.4e82a88e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Wei Wang <weiwan@google.com>
Date:   Mon, 1 Mar 2021 10:16:45 -0800
Message-ID: <CAEA6p_BrxajA3EpdWcnMbBJPse45PU_KUUzWM0V-9T6LrhK8ww@mail.gmail.com>
Subject: Re: [PATCH net v2] net: fix race between napi kthread mode and busy poll
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Alexander Duyck <alexanderduyck@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Martin Zaharinov <micron10@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 28, 2021 at 11:17 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sat, 27 Feb 2021 15:23:56 -0800 Wei Wang wrote:
> > > > Indeed, looks like the task will be in WAKING state until it runs?
> > > > We can switch the check in ____napi_schedule() from
> > > >
> > > >         if (thread->state == TASK_RUNNING)
> > > >
> > > > to
> > > >
> > > >         if (!(thread->state & TASK_INTERRUPTIBLE))
> > > >
> > > > ?
> > >
> > > Hmm... I am not very sure what state the thread will be put in after
> > > kthread_create(). Could it be in TASK_INTERRUPTIBLE?
> >
> > I did a printk and confirmed that the thread->state is
> > TASK_UNINTERRUPTIBLE after kthread_create() is called.
> > So I think if we change the above state to:
> >           if (thread->state != TASK_INTERRUPTIBLE)
> >                   set_bit(NAPI_STATE_SCHED_THREADED, &napi->state);
> > It should work.
>
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 6c5967e80132..43607523ee99 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -1501,17 +1501,18 @@ static int napi_kthread_create(struct napi_struct *n)
> >  {
> >         int err = 0;
> >
> > -       /* Create and wake up the kthread once to put it in
> > -        * TASK_INTERRUPTIBLE mode to avoid the blocked task
> > -        * warning and work with loadavg.
> > +       /* Avoid waking up the kthread during creation to prevent
> > +        * potential race.
> >          */
> > -       n->thread = kthread_run(napi_threaded_poll, n, "napi/%s-%d",
> > -                               n->dev->name, n->napi_id);
> > +       n->thread = kthread_create(napi_threaded_poll, n, "napi/%s-%d",
> > +                                  n->dev->name, n->napi_id);
>
> Does kthread_run() make the thread go into TASK_INTERRUPTIBLE ?
> It just calls wake_up_process(), which according to a comment in the
> kdoc..
>
>  * Conceptually does:
>  *
>  *   If (@state & @p->state) @p->state = TASK_RUNNING.
>
> So I think we could safely stick to kthread_run() if the condition in
> at the NAPI wake point checks for INTERRUPTIBLE?

I think so. kthread_run() wakes up the kthread and kthread_wait_poll()
should put it to INTERRUPTIBLE mode and schedule() will make it go to
sleep, and wait for the next napi_schedule().
I've also tested on my setup and saw no issues.
