Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80AE2326F98
	for <lists+netdev@lfdr.de>; Sun, 28 Feb 2021 00:28:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbhB0XYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Feb 2021 18:24:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbhB0XYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Feb 2021 18:24:48 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 398ECC06174A
        for <netdev@vger.kernel.org>; Sat, 27 Feb 2021 15:24:08 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id f4so12876641ybk.11
        for <netdev@vger.kernel.org>; Sat, 27 Feb 2021 15:24:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I2mvV3bQGSDDQ5777uMurFEM0r5Gd0/dBZnoMxiJztY=;
        b=meMpGWaBFEsCUHT/jOLar5Y2yj8t11Ek7SrBptFRxbTXG+lQcdasp0fDZeexJCTSNB
         QFvlnl1Ihhx9rvRtPZvmF/nbXOfZd4SPdpEaCtorGZPv0DeIh8A9HtCKfuvVDu5/nBa9
         1B4Ot/r6DB73/kUXbDT3tcdjcpcXWKtcC0PyeOcmViEy46vANWJhFJpwM/BeW3eLqA/T
         8HVQhSLQCJ0FOdG/a3E7Wb+pFd4p9SoMT8umgSWn9dTDhqJDH/ku/hmhZ5SQdtWOfoht
         8e+f1wCPhXvy63ubsNsWj1WmQxZf+lZ7iy3WBHSV0Z3B6wJD9GhHOzPENn0pjaHJzPCC
         ZNFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I2mvV3bQGSDDQ5777uMurFEM0r5Gd0/dBZnoMxiJztY=;
        b=C+8gbzIuOBBho5R0xVKw7qfDFd88L0MmDTssbtIPH92VFwricYTpBbCs//XM4VzhiD
         g9Cj5ZlGwbjkk2ESGdZwz3Zodw3Yn8rEZs/e3f3EcUCjVO0HGaI9wLkkEVQ0zHSFagyH
         EX5qf7DhNr+vvmMwwakXvwqGfnbO0sYeikvYwqlI2/HWagmnCdjSw2uuoh7VSWF6uGhh
         O59jJjAHkLWZZVFA9NGnL6tsn4M85m7KLIB6RGKJmbzqy87g6xFCX/Dm8QeYRkZTo+UT
         mu83L9Y33Tvjxfl34jdiZLXsiNcrmnogSYzTs6yD+C392bNV8wEhtAlZrYIzSyRCkA0O
         VIhw==
X-Gm-Message-State: AOAM531kfH9T3DRysYCvGkXWGKQCVnlYhDIW8V3RW6//+oqlE37jJCyz
        m+WulHMmt5/J0lP+m1m0S7zUDt65Umnd7xN3nH2WjTgkAB/Gfw==
X-Google-Smtp-Source: ABdhPJy+YYJzECq3MQmuliCWDN2/+CM4tLqNbne5YvHk0UE45D3b9OAK2dbnKmdZrCuKrbcDjoYq/aKt5qUci2lleUE=
X-Received: by 2002:a25:fc3:: with SMTP id 186mr13528727ybp.452.1614468247015;
 Sat, 27 Feb 2021 15:24:07 -0800 (PST)
MIME-Version: 1.0
References: <20210227003047.1051347-1-weiwan@google.com> <20210226164803.4413571f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAEA6p_CJx7K1Fab1C0Qkw=1VNnDaV9qwB_UUtikPMoqNUUWJuA@mail.gmail.com>
 <20210226172240.24d626e5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAEA6p_B6baYFZnEOMS=Nmvg0kA_qB=7ip4S96ys9ZoJWfOiOCA@mail.gmail.com>
 <20210226180833.09c98110@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <CAEA6p_ABZfs3zyQ+90cC1P8T8w94Lz4RvvBdQHQsHXEPP5aexQ@mail.gmail.com>
In-Reply-To: <CAEA6p_ABZfs3zyQ+90cC1P8T8w94Lz4RvvBdQHQsHXEPP5aexQ@mail.gmail.com>
From:   Wei Wang <weiwan@google.com>
Date:   Sat, 27 Feb 2021 15:23:56 -0800
Message-ID: <CAEA6p_DtTG6ryiG3GkxaySJeNcYF=RfkgCYTc-T-mHqMwL2-Gw@mail.gmail.com>
Subject: Re: [PATCH net v2] net: fix race between napi kthread mode and busy poll
To:     Jakub Kicinski <kuba@kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Martin Zaharinov <micron10@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 27, 2021 at 11:00 AM Wei Wang <weiwan@google.com> wrote:
>
> On Fri, Feb 26, 2021 at 6:08 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Fri, 26 Feb 2021 17:35:21 -0800 Wei Wang wrote:
> > > On Fri, Feb 26, 2021 at 5:22 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > >
> > > > On Fri, 26 Feb 2021 17:02:17 -0800 Wei Wang wrote:
> > > > >  static int napi_thread_wait(struct napi_struct *napi)
> > > > >  {
> > > > > +       bool woken = false;
> > > > > +
> > > > >         set_current_state(TASK_INTERRUPTIBLE);
> > > > >
> > > > >         while (!kthread_should_stop() && !napi_disable_pending(napi)) {
> > > > > -               if (test_bit(NAPI_STATE_SCHED, &napi->state)) {
> > > > > +               unsigned long state = READ_ONCE(napi->state);
> > > > > +
> > > > > +               if ((state & NAPIF_STATE_SCHED) &&
> > > > > +                   ((state & NAPIF_STATE_SCHED_THREAD) || woken)) {
> > > > >                         WARN_ON(!list_empty(&napi->poll_list));
> > > > >                         __set_current_state(TASK_RUNNING);
> > > > >                         return 0;
> > > > > +               } else {
> > > > > +                       WARN_ON(woken);
> > > > >                 }
> > > > >
> > > > >                 schedule();
> > > > > +               woken = true;
> > > > >                 set_current_state(TASK_INTERRUPTIBLE);
> > > > >         }
> > > > >         __set_current_state(TASK_RUNNING);
> > > > >
> > > > > I don't think it is sufficient to only set SCHED_THREADED bit when the
> > > > > thread is in RUNNING state.
> > > > > In fact, the thread is most likely NOT in RUNNING mode before we call
> > > > > wake_up_process() in ____napi_schedule(), because it has finished the
> > > > > previous round of napi->poll() and SCHED bit was cleared, so
> > > > > napi_thread_wait() sets the state to INTERRUPTIBLE and schedule() call
> > > > > should already put it in sleep.
> > > >
> > > > That's why the check says "|| woken":
> > > >
> > > >         ((state & NAPIF_STATE_SCHED_THREAD) ||  woken))
> > > >
> > > > thread knows it owns the NAPI if:
> > > >
> > > >   (a) the NAPI has the explicit flag set
> > > > or
> > > >   (b) it was just worken up and !kthread_should_stop(), since only
> > > >       someone who just claimed the normal SCHED on thread's behalf
> > > >       will wake it up
> > >
> > > The 'woken' is set after schedule(). If it is the first time
> > > napi_threaded_wait() is called, and SCHED_THREADED is not set, and
> > > woken is not set either, this thread will be put to sleep when it
> > > reaches schedule(), even though there is work waiting to be done on
> > > that napi. And I think this kthread will not be woken up again
> > > afterwards, since the SCHED bit is already grabbed.
> >
> > Indeed, looks like the task will be in WAKING state until it runs?
> > We can switch the check in ____napi_schedule() from
> >
> >         if (thread->state == TASK_RUNNING)
> >
> > to
> >
> >         if (!(thread->state & TASK_INTERRUPTIBLE))
> >
> > ?
>
> Hmm... I am not very sure what state the thread will be put in after
> kthread_create(). Could it be in TASK_INTERRUPTIBLE?

I did a printk and confirmed that the thread->state is
TASK_UNINTERRUPTIBLE after kthread_create() is called.
So I think if we change the above state to:
          if (thread->state != TASK_INTERRUPTIBLE)
                  set_bit(NAPI_STATE_SCHED_THREADED, &napi->state);
It should work.

I tested the following patch on my setup and saw no issues:
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index ddf4cfc12615..682908707c1a 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -360,6 +360,7 @@ enum {
        NAPI_STATE_IN_BUSY_POLL,        /* sk_busy_loop() owns this NAPI */
        NAPI_STATE_PREFER_BUSY_POLL,    /* prefer busy-polling over
softirq processing*/
        NAPI_STATE_THREADED,            /* The poll is performed
inside its own thread*/
+       NAPI_STATE_SCHED_THREADED,      /* Napi is currently scheduled
in threaded mode */
 };

 enum {
@@ -372,6 +373,7 @@ enum {
        NAPIF_STATE_IN_BUSY_POLL        = BIT(NAPI_STATE_IN_BUSY_POLL),
        NAPIF_STATE_PREFER_BUSY_POLL    = BIT(NAPI_STATE_PREFER_BUSY_POLL),
        NAPIF_STATE_THREADED            = BIT(NAPI_STATE_THREADED),
+       NAPIF_STATE_SCHED_THREADED      = BIT(NAPI_STATE_SCHED_THREADED),
 };

 enum gro_result {
diff --git a/net/core/dev.c b/net/core/dev.c
index 6c5967e80132..43607523ee99 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1501,17 +1501,18 @@ static int napi_kthread_create(struct napi_struct *n)
 {
        int err = 0;

-       /* Create and wake up the kthread once to put it in
-        * TASK_INTERRUPTIBLE mode to avoid the blocked task
-        * warning and work with loadavg.
+       /* Avoid waking up the kthread during creation to prevent
+        * potential race.
         */
-       n->thread = kthread_run(napi_threaded_poll, n, "napi/%s-%d",
-                               n->dev->name, n->napi_id);
+       n->thread = kthread_create(napi_threaded_poll, n, "napi/%s-%d",
+                                  n->dev->name, n->napi_id);
        if (IS_ERR(n->thread)) {
                err = PTR_ERR(n->thread);
-               pr_err("kthread_run failed with err %d\n", err);
+               pr_err("kthread_create failed with err %d\n", err);
                n->thread = NULL;
        }
@@ -4294,6 +4295,8 @@ static inline void ____napi_schedule(struct
softnet_data *sd,
                 */
                thread = READ_ONCE(napi->thread);
                if (thread) {
+                       if (thread->state != TASK_INTERRUPTIBLE)
+                               set_bit(NAPI_STATE_SCHED_THREADED,
&napi->state);
                        wake_up_process(thread);
                        return;
                }
@@ -6486,6 +6489,7 @@ bool napi_complete_done(struct napi_struct *n,
int work_done)
                WARN_ON_ONCE(!(val & NAPIF_STATE_SCHED));

                new = val & ~(NAPIF_STATE_MISSED | NAPIF_STATE_SCHED |
+                             NAPIF_STATE_SCHED_THREADED |
                              NAPIF_STATE_PREFER_BUSY_POLL);

                /* If STATE_MISSED was set, leave STATE_SCHED set,
@@ -6968,16 +6972,24 @@ static int napi_poll(struct napi_struct *n,
struct list_head *repoll)

 static int napi_thread_wait(struct napi_struct *napi)
 {
+       bool woken = false;
+
        set_current_state(TASK_INTERRUPTIBLE);

        while (!kthread_should_stop() && !napi_disable_pending(napi)) {
-               if (test_bit(NAPI_STATE_SCHED, &napi->state)) {
+               /* Testing SCHED_THREADED bit here to make sure the current
+                * kthread owns this napi and could poll on this napi.
+                * Testing SCHED bit is not enough because SCHED bit might be
+                * set by some other busy poll thread or by napi_disable().
+                */
+               if (test_bit(NAPI_STATE_SCHED_THREADED, &napi->state)
|| woken) {
                        WARN_ON(!list_empty(&napi->poll_list));
                        __set_current_state(TASK_RUNNING);
                        return 0;
                }

                schedule();
+                /* woken being true indicates this thread owns this napi. */
+               woken = true;
                set_current_state(TASK_INTERRUPTIBLE);
        }
        __set_current_state(TASK_RUNNING);

Jakub, Eric and Alexander,
What do you think of the above patch?
To me, the logic here seems more complicated than the original v2
patch, but it helps save quite some set_bit() in ____napi_schedule().
So it may be worthwhile?
