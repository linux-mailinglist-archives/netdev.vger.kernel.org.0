Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2541325C2B
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 04:53:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbhBZDw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 22:52:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbhBZDw5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 22:52:57 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AE8FC061574
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 19:52:17 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id c10so6919695ilo.8
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 19:52:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EO0IdbGUg5nhVWZcHyvWO++qUcRPKu+HCEG0ELYYBRQ=;
        b=GpcaTgt5GyBfTKaMzjbqithNVsHVPpN0lM7OcgjIRE2ObPxo/v3Ng9V18Tf+e5oQoT
         Sj+o1y40tuI4RxRGWxP/CYTP7mMAXfYN5tOZhkRLSt8ShHGoeeas/QQOB8dLkotxLPn3
         0pYfbH2QIFmu/HSb1grECPxXyt2QUrFSvig2p2SPG85jRB9EOkgD5hMTRq34xbgoPZ6r
         HV0GNSxyKq3wvP8DiwhSjxlcEdW1NwQiMYLBqjpBbfdIfHL3cWvXatWZ1PuHY//ARE5B
         TcLFEpvO2XPE2Q4NXCQ86J+27iEloxLNPU4qPIB7G1XWDWt3x2ZWqOyOpjHo1QTgXzZu
         IcrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EO0IdbGUg5nhVWZcHyvWO++qUcRPKu+HCEG0ELYYBRQ=;
        b=q3pduOrQa1Vg4jRGIJerUCTmjpsXsWlqUW9dbQhkkkDn1tploej+2cfmi7HXBtQx5m
         XzPvKForW1P3I005iPAGx4FEHKwwvk9WeRJwuAvUNQAnwI5sqU+eWRksRtKjXGhAGsrV
         1euxP6ttFJILaQTYAAjfqSTqi6v0NxJEpA+fYOULP2gmxS+KnJCSQIzP4VAwBvGOwnGc
         WM0RqbWiqK26tyiPYCi9+ULUefse3L0odl0Y7wjgOSp99XVFiA1JCg1ZH+2Vgn98g00N
         SsSfIi9UO94++Y1i0VysbYAd77Tt8RLdZ4HEMQlvKPTh7KxPJlTLSeGld23KRx+gXmKt
         4jeg==
X-Gm-Message-State: AOAM530u5IN6iuEWTmnzvMRt/8YE/31dpjt/DQWuL9frmEmFLQ1odjkp
        Vrgf1qzWBwQGj0Wjs8fUWfsU4afvhMlIg7u9lv0=
X-Google-Smtp-Source: ABdhPJyvc76LwA4dlwJM2DJbxRy0LaivIotGVCB7pYYyRjJYyEDn1WS/ar/pxqKWaG1u1jzxVO1xK8XsXXJaR3WMsaw=
X-Received: by 2002:a92:3f08:: with SMTP id m8mr802523ila.237.1614311536293;
 Thu, 25 Feb 2021 19:52:16 -0800 (PST)
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
 <CAEA6p_DnoQ8OLm731burXB58d9PfSPNU7_MvbeX_Ly1Grk2XbA@mail.gmail.com> <20210225171857.798e6c81@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210225171857.798e6c81@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 25 Feb 2021 19:52:05 -0800
Message-ID: <CAKgT0Ucip_cDs0juYN06xoDxFOrzo83JdhSOUEtRLugresQ2fw@mail.gmail.com>
Subject: Re: [PATCH net] net: fix race between napi kthread mode and busy poll
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Wei Wang <weiwan@google.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Martin Zaharinov <micron10@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 25, 2021 at 5:20 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 25 Feb 2021 16:16:20 -0800 Wei Wang wrote:
> > On Thu, Feb 25, 2021 at 3:00 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > On Thu, 25 Feb 2021 10:29:47 -0800 Wei Wang wrote:
> > > > Hmm... I don't think the above patch would work. Consider a situation that:
> > > > 1. At first, the kthread is in sleep mode.
> > > > 2. Then someone calls napi_schedule() to schedule work on this napi.
> > > > So ____napi_schedule() is called. But at this moment, the kthread is
> > > > not yet in RUNNING state. So this function does not set SCHED_THREAD
> > > > bit.
> > > > 3. Then wake_up_process() is called to wake up the thread.
> > > > 4. Then napi_threaded_poll() calls napi_thread_wait().
> > >
> > > But how is the task not in running state outside of napi_thread_wait()?
> > >
> > > My scheduler knowledge is rudimentary, but AFAIU off CPU tasks which
> > > were not put to sleep are still in RUNNING state, so unless we set
> > > INTERRUPTIBLE the task will be running, even if it's stuck in cond_resched().
> >
> > I think the thread is only in RUNNING state after wake_up_process() is
> > called on the thread in ____napi_schedule(). Before that, it should be
> > in INTERRUPTIBLE state. napi_thread_wait() explicitly calls
> > set_current_state(TASK_INTERRUPTIBLE) when it finishes 1 round of
> > polling.
>
> Are you concerned about it not being in RUNNING state after it's
> spawned but before it's first parked?
>
> > > > woken is false
> > > > and SCHED_THREAD bit is not set. So the kthread will go to sleep again
> > > > (in INTERRUPTIBLE mode) when schedule() is called, and waits to be
> > > > woken up by the next napi_schedule().
> > > > That will introduce arbitrary delay for the napi->poll() to be called.
> > > > Isn't it? Please enlighten me if I did not understand it correctly.
> > >
> > > Probably just me not understanding the scheduler :)
> > >
> > > > I personally prefer to directly set SCHED_THREAD bit in ____napi_schedule().
> > > > Or stick with SCHED_BUSY_POLL solution and replace kthread_run() with
> > > > kthread_create().
> > >
> > > Well, I'm fine with that too, no point arguing further if I'm not
> > > convincing anyone. But we need a fix which fixes the issue completely,
> > > not just one of three incarnations.
> >
> > Alexander and Eric,
> > Do you guys have preference on which approach to take?
> > If we keep the current SCHED_BUSY_POLL patch, I think we need to
> > change kthread_run() to kthread_create() to address the warning Martin
> > reported.
> > Or if we choose to set SCHED_THREADED, we could keep kthread_run().
> > But there is 1 extra set_bit() operation.
>
> To be clear extra set_bit() only if thread is running, which if IRQ
> coalescing works should be rather rare.

I was good with either approach. My preference would be to probably
use kthread_create regardless as it doesn't make much sense to have
the thread running until we really need it anyway.
