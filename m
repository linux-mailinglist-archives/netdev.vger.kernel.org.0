Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87E163266E3
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 19:29:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbhBZS3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 13:29:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbhBZS26 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 13:28:58 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D145C06174A
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 10:28:12 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id p186so9826184ybg.2
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 10:28:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mHn0ATzyfjQcHe3CflA1/VB607LwtKwjbOunifyzhhI=;
        b=S3JrjlzteKA5IRIrR+MLPMJq+MCo1zQcvD6MzUKwXqvYjd2gkYyT+0uYixJopTWOak
         HW1OmJMecwoceiqcF1CDRXqINziVm0qZrqnl2E5haVIsMosA/6VqGyiC9fZJnO5mPmq9
         bGSc3suwkcCe0MkDn9XTAyv/X/WGY1ZgIAAuSWoX+HYFdMCMd643as0+QE4dKzuz2vls
         6awJJSKRJhI4DtvqjDk3fcJZ6sBjp9keM3+ISYee/efnfuA3TbviMU1AUOF1gsb/pLY6
         IBT76Yy7BmMipGZS9TjAip3G2Ond39MnTXns/lTkif7uqj4WXmtz2CjSg0xB1GFEJLnb
         +97Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mHn0ATzyfjQcHe3CflA1/VB607LwtKwjbOunifyzhhI=;
        b=AWYVFy8INJ28jmwvLzwK9ZtFb+9xESF4gu+7ySQyQyxSejE0ScMWEDY1ehwuDblin5
         VkqZEi7Sixme8cMRRgAP4DHzxYVJntEgSxZi8+4lHBWCpljT9LbPhleQhDwjKPEtOvoF
         9z8pqVdsW2v7BtqhcxfpOvePQZ5AqbrA/f+Shei2CH94BYazdXAThqKKUDsvl4CDNKpV
         kIfhE+Lg5klOt49ODC/qgiKe08ccoki9XqSgGhsvKHkDJIaqWG+0ceQo7EaOPLj94ghT
         i1xu+MYyeUpeR+riD3WkWHCVTMg9UbN551xUetKdZ0Sxzia1pz85dw8A0lbGrcRjUHEk
         WXMg==
X-Gm-Message-State: AOAM530ZarRvzo4AO4RyMaEoqmFWKmzlnmp3QaezB3dCI9cKCOidx5k+
        SnnedQmbUgT4HR9ZWTnOqklaxKphuce3YHIIuPmX0A==
X-Google-Smtp-Source: ABdhPJxdwrYLzBJEQgkuB7VNOtHOerHPlBmjhY6acZV0oLfbp6RnjUh5TIHoX006FwFHDAdK+EYkMaPR4ukAHiQlB6Y=
X-Received: by 2002:a25:2206:: with SMTP id i6mr5778170ybi.351.1614364091595;
 Fri, 26 Feb 2021 10:28:11 -0800 (PST)
MIME-Version: 1.0
References: <20210223234130.437831-1-weiwan@google.com> <20210224155237.221dd0c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANn89iKYLTbQB7K8bFouaGFfeiVo00-TEqsdM10t7Tr94O_tuA@mail.gmail.com>
 <20210224160723.4786a256@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BN8PR15MB2787694425A1369CA563FCFFBD9E9@BN8PR15MB2787.namprd15.prod.outlook.com>
 <20210224162059.7949b4e1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BN8PR15MB27873FF52B109480173366B8BD9E9@BN8PR15MB2787.namprd15.prod.outlook.com>
 <20210224180329.306b2207@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAEA6p_CEz-CaK_rCyGzRA8=WNspu2Uia5UasJ266f=p5uiqYkw@mail.gmail.com>
 <20210225002115.5f6215d8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAEA6p_DdccvmymRWEtggHgqb9dQ6NjK8rsrA03HH+r7mzt=5uw@mail.gmail.com>
 <20210225150048.23ed87c9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAEA6p_DnoQ8OLm731burXB58d9PfSPNU7_MvbeX_Ly1Grk2XbA@mail.gmail.com>
 <20210225171857.798e6c81@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <CAKgT0Ucip_cDs0juYN06xoDxFOrzo83JdhSOUEtRLugresQ2fw@mail.gmail.com>
In-Reply-To: <CAKgT0Ucip_cDs0juYN06xoDxFOrzo83JdhSOUEtRLugresQ2fw@mail.gmail.com>
From:   Wei Wang <weiwan@google.com>
Date:   Fri, 26 Feb 2021 10:28:00 -0800
Message-ID: <CAEA6p_AJYBPMQY2DEy_vhRwrq5fnZR3z0A_-_HN0+S4yc45enQ@mail.gmail.com>
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

Hi Martin,
Could you help try the following new patch on your setup and let me
know if there are still issues?

Thanks.
Wei

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index ddf4cfc12615..9ed0f89ccdd5 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -357,9 +357,10 @@ enum {
        NAPI_STATE_NPSVC,               /* Netpoll - don't dequeue
from poll_list */
        NAPI_STATE_LISTED,              /* NAPI added to system lists */
        NAPI_STATE_NO_BUSY_POLL,        /* Do not add in napi_hash, no
busy polling */
-       NAPI_STATE_IN_BUSY_POLL,        /* sk_busy_loop() owns this NAPI */
+       NAPI_STATE_IN_BUSY_POLL,        /* sk_busy_loop() grabs SHED
bit and could busy poll */
        NAPI_STATE_PREFER_BUSY_POLL,    /* prefer busy-polling over
softirq processing*/
        NAPI_STATE_THREADED,            /* The poll is performed
inside its own thread*/
+       NAPI_STATE_SCHED_BUSY_POLL,     /* Napi is currently scheduled
in busy poll mode */
 };

 enum {
@@ -372,6 +373,7 @@ enum {
        NAPIF_STATE_IN_BUSY_POLL        = BIT(NAPI_STATE_IN_BUSY_POLL),
        NAPIF_STATE_PREFER_BUSY_POLL    = BIT(NAPI_STATE_PREFER_BUSY_POLL),
        NAPIF_STATE_THREADED            = BIT(NAPI_STATE_THREADED),
+       NAPIF_STATE_SCHED_BUSY_POLL     = BIT(NAPI_STATE_SCHED_BUSY_POLL),
 };

 enum gro_result {
diff --git a/net/core/dev.c b/net/core/dev.c
index 6c5967e80132..c717b67ce137 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1501,15 +1501,14 @@ static int napi_kthread_create(struct napi_struct *n)
 {
        int err = 0;

-       /* Create and wake up the kthread once to put it in
-        * TASK_INTERRUPTIBLE mode to avoid the blocked task
-        * warning and work with loadavg.
+       /* Avoid using  kthread_run() here to prevent race
+        * between softirq and kthread polling.
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

@@ -6486,6 +6485,7 @@ bool napi_complete_done(struct napi_struct *n,
int work_done)
                WARN_ON_ONCE(!(val & NAPIF_STATE_SCHED));

                new = val & ~(NAPIF_STATE_MISSED | NAPIF_STATE_SCHED |
+                             NAPIF_STATE_SCHED_BUSY_POLL |
                              NAPIF_STATE_PREFER_BUSY_POLL);

                /* If STATE_MISSED was set, leave STATE_SCHED set,
@@ -6525,6 +6525,7 @@ static struct napi_struct *napi_by_id(unsigned
int napi_id)

 static void __busy_poll_stop(struct napi_struct *napi, bool skip_schedule)
 {
+       clear_bit(NAPI_STATE_SCHED_BUSY_POLL, &napi->state);
        if (!skip_schedule) {
                gro_normal_list(napi);
                __napi_schedule(napi);
@@ -6624,7 +6625,8 @@ void napi_busy_loop(unsigned int napi_id,
                        }
                        if (cmpxchg(&napi->state, val,
                                    val | NAPIF_STATE_IN_BUSY_POLL |
-                                         NAPIF_STATE_SCHED) != val) {
+                                         NAPIF_STATE_SCHED |
+                                         NAPIF_STATE_SCHED_BUSY_POLL) != val) {
                                if (prefer_busy_poll)

set_bit(NAPI_STATE_PREFER_BUSY_POLL, &napi->state);
                                goto count;
@@ -6971,7 +6973,10 @@ static int napi_thread_wait(struct napi_struct *napi)
        set_current_state(TASK_INTERRUPTIBLE);

        while (!kthread_should_stop() && !napi_disable_pending(napi)) {
-               if (test_bit(NAPI_STATE_SCHED, &napi->state)) {
+               unsigned long val = READ_ONCE(napi->state);
+
+               if (val & NAPIF_STATE_SCHED &&
+                   !(val & NAPIF_STATE_SCHED_BUSY_POLL)) {
                        WARN_ON(!list_empty(&napi->poll_list));
                        __set_current_state(TASK_RUNNING);
                        return 0;

On Thu, Feb 25, 2021 at 7:52 PM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Thu, Feb 25, 2021 at 5:20 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Thu, 25 Feb 2021 16:16:20 -0800 Wei Wang wrote:
> > > On Thu, Feb 25, 2021 at 3:00 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > > On Thu, 25 Feb 2021 10:29:47 -0800 Wei Wang wrote:
> > > > > Hmm... I don't think the above patch would work. Consider a situation that:
> > > > > 1. At first, the kthread is in sleep mode.
> > > > > 2. Then someone calls napi_schedule() to schedule work on this napi.
> > > > > So ____napi_schedule() is called. But at this moment, the kthread is
> > > > > not yet in RUNNING state. So this function does not set SCHED_THREAD
> > > > > bit.
> > > > > 3. Then wake_up_process() is called to wake up the thread.
> > > > > 4. Then napi_threaded_poll() calls napi_thread_wait().
> > > >
> > > > But how is the task not in running state outside of napi_thread_wait()?
> > > >
> > > > My scheduler knowledge is rudimentary, but AFAIU off CPU tasks which
> > > > were not put to sleep are still in RUNNING state, so unless we set
> > > > INTERRUPTIBLE the task will be running, even if it's stuck in cond_resched().
> > >
> > > I think the thread is only in RUNNING state after wake_up_process() is
> > > called on the thread in ____napi_schedule(). Before that, it should be
> > > in INTERRUPTIBLE state. napi_thread_wait() explicitly calls
> > > set_current_state(TASK_INTERRUPTIBLE) when it finishes 1 round of
> > > polling.
> >
> > Are you concerned about it not being in RUNNING state after it's
> > spawned but before it's first parked?
> >
> > > > > woken is false
> > > > > and SCHED_THREAD bit is not set. So the kthread will go to sleep again
> > > > > (in INTERRUPTIBLE mode) when schedule() is called, and waits to be
> > > > > woken up by the next napi_schedule().
> > > > > That will introduce arbitrary delay for the napi->poll() to be called.
> > > > > Isn't it? Please enlighten me if I did not understand it correctly.
> > > >
> > > > Probably just me not understanding the scheduler :)
> > > >
> > > > > I personally prefer to directly set SCHED_THREAD bit in ____napi_schedule().
> > > > > Or stick with SCHED_BUSY_POLL solution and replace kthread_run() with
> > > > > kthread_create().
> > > >
> > > > Well, I'm fine with that too, no point arguing further if I'm not
> > > > convincing anyone. But we need a fix which fixes the issue completely,
> > > > not just one of three incarnations.
> > >
> > > Alexander and Eric,
> > > Do you guys have preference on which approach to take?
> > > If we keep the current SCHED_BUSY_POLL patch, I think we need to
> > > change kthread_run() to kthread_create() to address the warning Martin
> > > reported.
> > > Or if we choose to set SCHED_THREADED, we could keep kthread_run().
> > > But there is 1 extra set_bit() operation.
> >
> > To be clear extra set_bit() only if thread is running, which if IRQ
> > coalescing works should be rather rare.
>
> I was good with either approach. My preference would be to probably
> use kthread_create regardless as it doesn't make much sense to have
> the thread running until we really need it anyway.
