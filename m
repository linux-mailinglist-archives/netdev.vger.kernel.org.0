Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2329A3214D4
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 12:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbhBVLKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 06:10:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbhBVLKq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 06:10:46 -0500
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2132CC061574
        for <netdev@vger.kernel.org>; Mon, 22 Feb 2021 03:10:06 -0800 (PST)
Received: by mail-qv1-xf34.google.com with SMTP id p12so5819492qvv.5
        for <netdev@vger.kernel.org>; Mon, 22 Feb 2021 03:10:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VlSGrkSeMQMKBMWcSMQE0Ym8oJwRv6gEdAv5SyqvuMA=;
        b=JCh4bVtBNGxGnurNiVkmVfneFvNo2+8wPQI/uwUZZJBodf6kc62pXlCjvyZoqfuo2y
         v5lyxqY190jng958jhwylpedhImqd7D9be9hGwKLhPW5SDIhla6eEN7E+SB4PvezvVO9
         gWQ9MOASqn9GkUQmZdpDmscuTqMKZqkgj+8YeQVWgJbPRFKF9r/JOjTwRXiLgz/lUgLX
         y+ANv0aWAtG1X2mZdJm6aHRfSQn8hLLBOeKZSMQpuvdJy2Xaafq2PKw3+xIQW+5hPqkN
         bRv+7+0Z0VYB4TyBQi0XxuBo7tEgWK+in5CcakkNCyR+5tVReW+EaV4xwBqyWyB6hEOA
         aY3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VlSGrkSeMQMKBMWcSMQE0Ym8oJwRv6gEdAv5SyqvuMA=;
        b=HzJNo5N/qwO24JIgNMma6jIZD08PjgGYeQZurwemDP5DrX/AUhYn6vLAku1QvYzr0X
         UZeOP0gRQexkRaHh833ter/SxMRL/SxG72aHrKWoO6nzCkdJLIzn8F6WHu4hYypejm30
         afZ/fF+QWFSsB69kT3S3V7eOuT8TuvGto+WTbSxvlmLGxqzvBoul0xwz1fYbN/JX3hGb
         KNAjEFZxxzu6FOZtPFrpdiDPMcHddkXZJcEvuKHvVk3y66k7QuaW8iNH5ufxcdSvq8hk
         N1wi3DObkLaKmGRtg6J9W/as3OnP99QD++nIiY9qziA3//A+ynWLVvsndcojVfKA48h1
         NgAw==
X-Gm-Message-State: AOAM532Bd/llsMTv8SblzbRs7znLEXCkOSF9eVTvbLaYq3Re9Sak57ct
        6wmdCR64B/qWTo09NLNIP1Tdck1V/LMB3UD/v0E=
X-Google-Smtp-Source: ABdhPJz9TIV+gp12YwOpGa2gZ6mERju1MLIIA9kg3Zn0yDCosM3YTmYSLl6iqLQGUegC5ESy7XoCwX2SnMgpt/kk/c8=
X-Received: by 2002:a0c:a692:: with SMTP id t18mr20059830qva.18.1613992205359;
 Mon, 22 Feb 2021 03:10:05 -0800 (PST)
MIME-Version: 1.0
References: <20210220110356.84399-1-redsky110@gmail.com> <CANn89iKw_GCU6QeDHx31zcjFzqhzjaR2KrSNRON=KbohswHhmg@mail.gmail.com>
In-Reply-To: <CANn89iKw_GCU6QeDHx31zcjFzqhzjaR2KrSNRON=KbohswHhmg@mail.gmail.com>
From:   Honglei Wang <redsky110@gmail.com>
Date:   Mon, 22 Feb 2021 19:09:55 +0800
Message-ID: <CA+kCZ7-AeEHrOo18DMzF1zOGC=b-GrP3XFj5QhPeOoM3U0j6Ow@mail.gmail.com>
Subject: Re: [PATCH] tcp: avoid unnecessary loop if even ports are used up
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 22, 2021 at 3:47 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Sat, Feb 20, 2021 at 12:04 PM Honglei Wang <redsky110@gmail.com> wrote:
> >
> > We are getting port for connect() from even ports firstly now. This
> > makes bind() users have more available slots at odd part. But there is a
> > problem here when the even ports are used up. This happens when there
> > is a flood of short life cycle connections. In this scenario, it starts
> > getting ports from the odd part, but each requirement has to walk all of
> > the even port and the related hash buckets (it probably gets nothing
> > before the workload pressure's gone) before go to the odd part. This
> > makes the code path __inet_hash_connect()->__inet_check_established()
> > and the locks there hot.
> >
> > This patch tries to improve the strategy so we can go faster when the
> > even part is used up. It'll record the last gotten port was odd or even,
> > if it's an odd one, it means there is no available even port for us and
> > we probably can't get an even port this time, neither. So we just walk
> > 1/16 of the whole even ports. If we can get one in this way, it probably
> > means there are more available even part, we'll go back to the old
> > strategy and walk all of them when next connect() comes. If still can't
> > get even port in the 1/16 part, we just go to the odd part directly and
> > avoid doing unnecessary loop.
>
>
> Your patch trades correctness for speed.
>
> Sorry, but adding yet another static (and thus shared) variable
> assuming only one process
> on the physical host attempts a series of connect() is a non starter for me.
>
Actually, the very first start point makes me go into this problem is a
multiple-processes scenario and the hottest point in perf is the spin_lock()
in __inet_check_established(). It spends too much time on buckets walking
which is the critical section of spin_lock().

> Just scanning 1/8 of even ports to decide if none of them is available
> is potentially going to
> not see 7/16 of potential free 4-tuple, and an application needing
> 28,000 4-tuple with SRCIP,DSTIP,DSTPORT being fixed
> might not be able to run anymore.
>
After a bit more deeping based on the case above, I found most of the cpu
cycles spent at INET_MATCH() and it always 'goto not_unique' at last. This
became a bit better when tcp_tw_reuse set to 1, but the code path was still
hot. The 4-tuple were almost not matched when tcp_tw_reuse is 2 in this
workload.

This made me start thinking if we can go faster when walking the ports and
buckets. And in my original opinion, we should be able to scan most of the
even ports in several odd ports touching...

> If you do not care about bind() being able to find a free port, I
> would suggest you add
> a sysctl to simply relax the even/odd strategy that Google has been using
> to avoid all these port exhaustion bugs we had in the past.
> (Although now we use one netns per job, jobs are now isolated and only
> can hurt themselves)
>

Thanks a lot for giving this good suggestion.

Yes, this was the very first idea when I thought about the fix. But before do
more work on this idea, I saw the code of this patch give some performance
improvement. So I think it's not bad as well.. If you think it's not graceful to
just speed up by scanning less ports, it's good for me to do more digging
and work on adding a sysctl to fix the problem completely.

>
>
> >
> >
> > Signed-off-by: Honglei Wang <redsky110@gmail.com>
> > ---
> >  net/ipv4/inet_hashtables.c | 21 +++++++++++++++++++--
> >  1 file changed, 19 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
> > index 45fb450b4522..c95bf5cf9323 100644
> > --- a/net/ipv4/inet_hashtables.c
> > +++ b/net/ipv4/inet_hashtables.c
> > @@ -721,9 +721,10 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
> >         struct net *net = sock_net(sk);
> >         struct inet_bind_bucket *tb;
> >         u32 remaining, offset;
> > -       int ret, i, low, high;
> > +       int ret, i, low, high, span;
> >         static u32 hint;
>
>
> This is an old tree, current kernels do not have this 'static u32 hint' anymore.
>

Really? I just came to the latest 5.11 including Linus' tree and
net-next, seems it's still here at line
725 of inet_hashtables.c.. Do I miss something?

Honglei

>
> >
> >         int l3mdev;
> > +       static bool last_port_is_odd;
> >
> >         if (port) {
> >                 head = &hinfo->bhash[inet_bhashfn(net, port,
> > @@ -756,8 +757,19 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
> >          */
> >         offset &= ~1U;
> >  other_parity_scan:
> > +       /* If the last available port is odd, it means
> > +        * we walked all of the even ports, but got
> > +        * nothing last time. It's telling us the even
> > +        * part is busy to get available port. In this
> > +        * case, we can go a bit faster.
> > +        */
> > +       if (last_port_is_odd && !(offset & 1) && remaining > 32)
> > +               span = 32;
> > +       else
> > +               span = 2;
> > +
> >         port = low + offset;
> > -       for (i = 0; i < remaining; i += 2, port += 2) {
> > +       for (i = 0; i < remaining; i += span, port += span) {
> >                 if (unlikely(port >= high))
> >                         port -= remaining;
> >                 if (inet_is_local_reserved_port(net, port))
> > @@ -806,6 +818,11 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
> >  ok:
> >         hint += i + 2;
> >
> > +       if (offset & 1)
> > +               last_port_is_odd = true;
> > +       else
> > +               last_port_is_odd = false;
> > +
> >         /* Head lock still held and bh's disabled */
> >         inet_bind_hash(sk, tb, port);
> >         if (sk_unhashed(sk)) {
> > --
> > 2.14.1
> >
