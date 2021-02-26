Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60E42326A1C
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 23:39:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbhBZWit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 17:38:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbhBZWis (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 17:38:48 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60B1EC061574
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 14:38:08 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id 133so10451474ybd.5
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 14:38:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fqXd+1VDMln7KEbY9XPEOb9xvpK7BZyJ5JKuJiVcZ8U=;
        b=WL0xFp6X/Jr6tyWYdlwTt5a5le2u933+AV31RPTr35WZ9WEgFMhXV0IYLDFTo8UeS0
         qV9HEkdixK8Z12Vga3jmAm+lPB0QqValnpusInR8Br+dG2eoxqEfyR8k21kw3U0DIsc+
         bzaI31IamXSkliBKR4iZ/DXXUNmmfrwWUuoLuvE/hUB9LVM1JD2O5ItXsNbet5ksDM5y
         Q3xVT3p2Oy7aXt8TJv6L+A36JbD9a0yW4GP2fIv8s7qMWF/F9vGiGo5uUtciql/02UTN
         ZnFywEVXTUOTABOQhqwa6zh+6WJWqdVHgoJO3gfjVzts/s+tTsQfub0s+r7MYtFfUF4O
         xjkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fqXd+1VDMln7KEbY9XPEOb9xvpK7BZyJ5JKuJiVcZ8U=;
        b=UIl01d/7xM4weLCQPzuhmY6dnkYjI1WxEkFMCWSutVaZiAESiTeFd66lfuxnOXk08i
         myynkyJfGxzZGI7my6n6JeR1oLUTPde0Y68hiyHjS+NzLt3HZaowQwK45y9Uqg09rcVD
         GBCoEsv3my4fJc14ocwQN3vhX1R4JHoOXWpWshsURH3DmRVrNxVQMT+xvAWT/9H+W+qA
         E5DXVDSiq8lNPkUMhCOIhet1wM2ek+C4mUZ3C4OIhx8U040vWgc+V7teb4ComYqGckdV
         KQ4DC25gnVXrm4vA4F/Zyb0RAVIKUSaiI/sbbkwiPffd1O2HeJ3y44STbnZowX+FWNnZ
         B4gQ==
X-Gm-Message-State: AOAM533oDMss+IknmQIB082tCs5RzTCf52Aejphx9GN0l/QUd37Iadif
        vGQIuSjjP5qp8iOOVfPN6NgRdpRPiWjnQ/AVDbKxig==
X-Google-Smtp-Source: ABdhPJxgNmqGa/1tPKgAZeIiY07D1x7rEyFwGtSVTT7pHHTCUpFafVII6y/kOkwyK36q1ZTwhls5DUXYevvhsd+ZlHw=
X-Received: by 2002:a25:d016:: with SMTP id h22mr7711727ybg.278.1614379087437;
 Fri, 26 Feb 2021 14:38:07 -0800 (PST)
MIME-Version: 1.0
References: <20210223234130.437831-1-weiwan@google.com> <BN8PR15MB2787694425A1369CA563FCFFBD9E9@BN8PR15MB2787.namprd15.prod.outlook.com>
 <20210224162059.7949b4e1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BN8PR15MB27873FF52B109480173366B8BD9E9@BN8PR15MB2787.namprd15.prod.outlook.com>
 <20210224180329.306b2207@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAEA6p_CEz-CaK_rCyGzRA8=WNspu2Uia5UasJ266f=p5uiqYkw@mail.gmail.com>
 <20210225002115.5f6215d8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAEA6p_DdccvmymRWEtggHgqb9dQ6NjK8rsrA03HH+r7mzt=5uw@mail.gmail.com>
 <20210225150048.23ed87c9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAEA6p_DnoQ8OLm731burXB58d9PfSPNU7_MvbeX_Ly1Grk2XbA@mail.gmail.com>
 <20210225171857.798e6c81@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAKgT0Ucip_cDs0juYN06xoDxFOrzo83JdhSOUEtRLugresQ2fw@mail.gmail.com>
 <CAEA6p_AJYBPMQY2DEy_vhRwrq5fnZR3z0A_-_HN0+S4yc45enQ@mail.gmail.com>
 <20210226133528.66882be1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAEA6p_A2upx2Mza5US8tc0JJSkK3jLZ5z=a3quJtFWytdN5XvA@mail.gmail.com> <CALidq=UWupwXMMYAMMF2GW4ifR0WQJos6VqXPuzQ0_seHGUHdA@mail.gmail.com>
In-Reply-To: <CALidq=UWupwXMMYAMMF2GW4ifR0WQJos6VqXPuzQ0_seHGUHdA@mail.gmail.com>
From:   Wei Wang <weiwan@google.com>
Date:   Fri, 26 Feb 2021 14:37:56 -0800
Message-ID: <CAEA6p_A93G5he_kqMzCZWgOThOT_rkB0WQ1oNA4wLVpthv2H9A@mail.gmail.com>
Subject: Re: [PATCH net] net: fix race between napi kthread mode and busy poll
To:     Martin Zaharinov <micron10@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Alexander Duyck <alexander.duyck@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 26, 2021 at 2:36 PM Martin Zaharinov <micron10@gmail.com> wrote:
>
>
>
> On Sat, Feb 27, 2021, 00:24 Wei Wang <weiwan@google.com> wrote:
>>
>> On Fri, Feb 26, 2021 at 1:35 PM Jakub Kicinski <kuba@kernel.org> wrote:
>> >
>> > On Fri, 26 Feb 2021 10:28:00 -0800 Wei Wang wrote:
>> > > Hi Martin,
>> > > Could you help try the following new patch on your setup and let me
>> > > know if there are still issues?
>> >
>> > FWIW your email got line wrapped for me.
>> >
>> > > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
>> > > index ddf4cfc12615..9ed0f89ccdd5 100644
>> > > --- a/include/linux/netdevice.h
>> > > +++ b/include/linux/netdevice.h
>> > > @@ -357,9 +357,10 @@ enum {
>> > >         NAPI_STATE_NPSVC,               /* Netpoll - don't dequeue
>> > > from poll_list */
>> > >         NAPI_STATE_LISTED,              /* NAPI added to system lists */
>> > >         NAPI_STATE_NO_BUSY_POLL,        /* Do not add in napi_hash, no
>> > > busy polling */
>> > > -       NAPI_STATE_IN_BUSY_POLL,        /* sk_busy_loop() owns this NAPI */
>> > > +       NAPI_STATE_IN_BUSY_POLL,        /* sk_busy_loop() grabs SHED
>> >
>> > nit: SHED -> SCHED
>> Ack.
>>
>> >
>> > > bit and could busy poll */
>> > >         NAPI_STATE_PREFER_BUSY_POLL,    /* prefer busy-polling over
>> > > softirq processing*/
>> > >         NAPI_STATE_THREADED,            /* The poll is performed
>> > > inside its own thread*/
>> > > +       NAPI_STATE_SCHED_BUSY_POLL,     /* Napi is currently scheduled
>> > > in busy poll mode */
>> >
>> > nit: Napi -> NAPI ?
>> Ack.
>>
>> >
>> > >  };
>> > >
>> > >  enum {
>> > > @@ -372,6 +373,7 @@ enum {
>> > >         NAPIF_STATE_IN_BUSY_POLL        = BIT(NAPI_STATE_IN_BUSY_POLL),
>> > >         NAPIF_STATE_PREFER_BUSY_POLL    = BIT(NAPI_STATE_PREFER_BUSY_POLL),
>> > >         NAPIF_STATE_THREADED            = BIT(NAPI_STATE_THREADED),
>> > > +       NAPIF_STATE_SCHED_BUSY_POLL     = BIT(NAPI_STATE_SCHED_BUSY_POLL),
>> > >  };
>> > >
>> > >  enum gro_result {
>> > > diff --git a/net/core/dev.c b/net/core/dev.c
>> > > index 6c5967e80132..c717b67ce137 100644
>> > > --- a/net/core/dev.c
>> > > +++ b/net/core/dev.c
>> > > @@ -1501,15 +1501,14 @@ static int napi_kthread_create(struct napi_struct *n)
>> > >  {
>> > >         int err = 0;
>> > >
>> > > -       /* Create and wake up the kthread once to put it in
>> > > -        * TASK_INTERRUPTIBLE mode to avoid the blocked task
>> > > -        * warning and work with loadavg.
>> > > +       /* Avoid using  kthread_run() here to prevent race
>> > > +        * between softirq and kthread polling.
>> > >          */
>> > > -       n->thread = kthread_run(napi_threaded_poll, n, "napi/%s-%d",
>> > > -                               n->dev->name, n->napi_id);
>> > > +       n->thread = kthread_create(napi_threaded_poll, n, "napi/%s-%d",
>> > > +                                  n->dev->name, n->napi_id);
>> >
>> > I'm not sure this takes care of rapid:
>> >
>> > dev_set_threaded(0)
>> >  # NAPI gets sent to sirq
>> > dev_set_threaded(1)
>> >
>> > since subsequent set_threaded(1) doesn't spawn the thread "afresh".
>> >
>>
>> I think the race between softirq and kthread could be purely dependent
>> on the SCHED bit. In napi_schedule_prep(), we check if SCHED bit is
>> set. And we only call ____napi_schedule() when SCHED bit is not set.
>> In ____napi_schedule(), we either wake up kthread, or raise softirq,
>> never both.
>> So as long as we don't wake up the kthread when creating it, there
>> should not be a chance of race between softirq and kthread.
>>
>> > >         if (IS_ERR(n->thread)) {
>> > >                 err = PTR_ERR(n->thread);
>> > > -               pr_err("kthread_run failed with err %d\n", err);
>> > > +               pr_err("kthread_create failed with err %d\n", err);
>> > >                 n->thread = NULL;
>> > >         }
>> > >
>> > > @@ -6486,6 +6485,7 @@ bool napi_complete_done(struct napi_struct *n,
>> > > int work_done)
>> > >                 WARN_ON_ONCE(!(val & NAPIF_STATE_SCHED));
>> > >
>> > >                 new = val & ~(NAPIF_STATE_MISSED | NAPIF_STATE_SCHED |
>> > > +                             NAPIF_STATE_SCHED_BUSY_POLL |
>> > >                               NAPIF_STATE_PREFER_BUSY_POLL);
>> > >
>> > >                 /* If STATE_MISSED was set, leave STATE_SCHED set,
>> > > @@ -6525,6 +6525,7 @@ static struct napi_struct *napi_by_id(unsigned
>> > > int napi_id)
>> > >
>> > >  static void __busy_poll_stop(struct napi_struct *napi, bool skip_schedule)
>> > >  {
>> > > +       clear_bit(NAPI_STATE_SCHED_BUSY_POLL, &napi->state);
>> > >         if (!skip_schedule) {
>> > >                 gro_normal_list(napi);
>> > >                 __napi_schedule(napi);
>> > > @@ -6624,7 +6625,8 @@ void napi_busy_loop(unsigned int napi_id,
>> > >                         }
>> > >                         if (cmpxchg(&napi->state, val,
>> > >                                     val | NAPIF_STATE_IN_BUSY_POLL |
>> > > -                                         NAPIF_STATE_SCHED) != val) {
>> > > +                                         NAPIF_STATE_SCHED |
>> > > +                                         NAPIF_STATE_SCHED_BUSY_POLL) != val) {
>> > >                                 if (prefer_busy_poll)
>> > >
>> > > set_bit(NAPI_STATE_PREFER_BUSY_POLL, &napi->state);
>> > >                                 goto count;
>> > > @@ -6971,7 +6973,10 @@ static int napi_thread_wait(struct napi_struct *napi)
>> > >         set_current_state(TASK_INTERRUPTIBLE);
>> > >
>> > >         while (!kthread_should_stop() && !napi_disable_pending(napi)) {
>> > > -               if (test_bit(NAPI_STATE_SCHED, &napi->state)) {
>> > > +               unsigned long val = READ_ONCE(napi->state);
>> > > +
>> > > +               if (val & NAPIF_STATE_SCHED &&
>> > > +                   !(val & NAPIF_STATE_SCHED_BUSY_POLL)) {
>> >
>> > Again, not protected from the napi_disable() case AFAICT.
>>
>> Hmmm..... Yes. I think you are right. I missed that napi_disable()
>> also grabs the SCHED bit. In this case, I think we have to use the
>> SCHED_THREADED bit. The SCHED_BUSY_POLL bit is not enough to protect
>> the race between napi_disable() and napi_threaded_poll(). :(
>> Sorry, I missed this point when evaluating both solutions. I will have
>> to switch to use the SCHED_THREADED bit.
>
>
>
> should I wait with the test
> when you fix this?
>
Yes. Please. Sorry for the confusion.

>>
>>
>> >
>> > >                         WARN_ON(!list_empty(&napi->poll_list));
>> > >                         __set_current_state(TASK_RUNNING);
>> > >                         return 0;
