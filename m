Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF284326EB6
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 20:04:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbhB0TCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Feb 2021 14:02:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbhB0TBv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Feb 2021 14:01:51 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2865C06174A
        for <netdev@vger.kernel.org>; Sat, 27 Feb 2021 11:01:10 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id d9so12521419ybq.1
        for <netdev@vger.kernel.org>; Sat, 27 Feb 2021 11:01:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mBnfFJ0dDBjAlyPF7g+Q1R7akZi9tN5AIPHMxYhVf0Q=;
        b=to8VLxVVI5Ben/mk9cDB6u9zqtf5CdnsycV6UkO2NhFSzvHRb8NB8qfmDAcogQ3El8
         LIXtCyi66xplfH552Ky+ZHijzQQAQydLU/E9Ts011XpM5jT68bq4JRB9ozq4sju8JOnR
         1VjIKU5rTzS5nfgoCWoIoVlHbl68l/qhIJQmiAhRXQOWkgLa2i3lgoqRaRdmsag9BWvn
         vWc0uqH196KeqDszXYViYajio5geTRIWMPHUZjiQZ5fsxpPOww8b9+9YG4BF380PPt/O
         xSltQwL/b30eTjbvlCvu7+hFJVa/wSmEMSA1dIhunUUCdSXfe1rnPa8WoEJie/99K0as
         fsFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mBnfFJ0dDBjAlyPF7g+Q1R7akZi9tN5AIPHMxYhVf0Q=;
        b=AHbKAylgOTfyoEzJN2XcDEctbAo0tCyoeb+/U6h3hp3v+Teh3W5KajOTopR87BGwjk
         TxNfVoFYP0++TU++SnpkwddHBbGQTZEdgZ5GakUsWh+2H2dXfCuTKei79fnU2j/Tm9zQ
         keX6peHJUnD4MM47sBNt/W88Qy9uDPL3CfPJRI+wC86Ti+3VJQujh+NmRc4yYPPZeVct
         om42FP0OnDkdi/Vm8xfROghnvd4TNOa7R8QwhCikW6rx9Xl4O3sOzwHmkfU+St/1aUYr
         7WmgLI8ermG+C7sJdpbtudZjntyzyqKgzwxHPeGBx5eF+cEs9XhnoqnauB9fi5ik4b1t
         YFOA==
X-Gm-Message-State: AOAM530qyxICSQ1XTxChQPOGWok0zlScFCwPUOGOwLijacPhBsIdf1CJ
        AYfrYjg7Ha+SuxSwGz9KtBUB3F7HY5kq6MznU0czCudzpFA=
X-Google-Smtp-Source: ABdhPJxiTZIY2lWz8k9y2kp+ypMI8cvbiy4FARu+7SG4TgQvDxrreIFF+QC63QidcaXUphp0zslvryMT33wV2p3l+2c=
X-Received: by 2002:a25:d016:: with SMTP id h22mr12770299ybg.278.1614452469163;
 Sat, 27 Feb 2021 11:01:09 -0800 (PST)
MIME-Version: 1.0
References: <20210227003047.1051347-1-weiwan@google.com> <20210226164803.4413571f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAEA6p_CJx7K1Fab1C0Qkw=1VNnDaV9qwB_UUtikPMoqNUUWJuA@mail.gmail.com>
 <20210226172240.24d626e5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAEA6p_B6baYFZnEOMS=Nmvg0kA_qB=7ip4S96ys9ZoJWfOiOCA@mail.gmail.com> <20210226180833.09c98110@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210226180833.09c98110@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Wei Wang <weiwan@google.com>
Date:   Sat, 27 Feb 2021 11:00:58 -0800
Message-ID: <CAEA6p_ABZfs3zyQ+90cC1P8T8w94Lz4RvvBdQHQsHXEPP5aexQ@mail.gmail.com>
Subject: Re: [PATCH net v2] net: fix race between napi kthread mode and busy poll
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Martin Zaharinov <micron10@gmail.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 26, 2021 at 6:08 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 26 Feb 2021 17:35:21 -0800 Wei Wang wrote:
> > On Fri, Feb 26, 2021 at 5:22 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > >
> > > On Fri, 26 Feb 2021 17:02:17 -0800 Wei Wang wrote:
> > > >  static int napi_thread_wait(struct napi_struct *napi)
> > > >  {
> > > > +       bool woken = false;
> > > > +
> > > >         set_current_state(TASK_INTERRUPTIBLE);
> > > >
> > > >         while (!kthread_should_stop() && !napi_disable_pending(napi)) {
> > > > -               if (test_bit(NAPI_STATE_SCHED, &napi->state)) {
> > > > +               unsigned long state = READ_ONCE(napi->state);
> > > > +
> > > > +               if ((state & NAPIF_STATE_SCHED) &&
> > > > +                   ((state & NAPIF_STATE_SCHED_THREAD) || woken)) {
> > > >                         WARN_ON(!list_empty(&napi->poll_list));
> > > >                         __set_current_state(TASK_RUNNING);
> > > >                         return 0;
> > > > +               } else {
> > > > +                       WARN_ON(woken);
> > > >                 }
> > > >
> > > >                 schedule();
> > > > +               woken = true;
> > > >                 set_current_state(TASK_INTERRUPTIBLE);
> > > >         }
> > > >         __set_current_state(TASK_RUNNING);
> > > >
> > > > I don't think it is sufficient to only set SCHED_THREADED bit when the
> > > > thread is in RUNNING state.
> > > > In fact, the thread is most likely NOT in RUNNING mode before we call
> > > > wake_up_process() in ____napi_schedule(), because it has finished the
> > > > previous round of napi->poll() and SCHED bit was cleared, so
> > > > napi_thread_wait() sets the state to INTERRUPTIBLE and schedule() call
> > > > should already put it in sleep.
> > >
> > > That's why the check says "|| woken":
> > >
> > >         ((state & NAPIF_STATE_SCHED_THREAD) ||  woken))
> > >
> > > thread knows it owns the NAPI if:
> > >
> > >   (a) the NAPI has the explicit flag set
> > > or
> > >   (b) it was just worken up and !kthread_should_stop(), since only
> > >       someone who just claimed the normal SCHED on thread's behalf
> > >       will wake it up
> >
> > The 'woken' is set after schedule(). If it is the first time
> > napi_threaded_wait() is called, and SCHED_THREADED is not set, and
> > woken is not set either, this thread will be put to sleep when it
> > reaches schedule(), even though there is work waiting to be done on
> > that napi. And I think this kthread will not be woken up again
> > afterwards, since the SCHED bit is already grabbed.
>
> Indeed, looks like the task will be in WAKING state until it runs?
> We can switch the check in ____napi_schedule() from
>
>         if (thread->state == TASK_RUNNING)
>
> to
>
>         if (!(thread->state & TASK_INTERRUPTIBLE))
>
> ?

Hmm... I am not very sure what state the thread will be put in after
kthread_create(). Could it be in TASK_INTERRUPTIBLE?
