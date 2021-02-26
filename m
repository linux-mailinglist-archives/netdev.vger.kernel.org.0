Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B03EC325B61
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 02:51:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbhBZBut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 20:50:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbhBZBus (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 20:50:48 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 111DBC061574
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 17:50:08 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id l8so7386972ybe.12
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 17:50:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FzmRh0gg2DPckYJh1PrBabdGOdbLWTtqvItwXBdWxgk=;
        b=VkW6CFK0IvSM/8ZMgt+HEBXZa5jDLFnkjToJTQRqz9pt4Hj9gSSTyPqWb45DrhLgT9
         2iDnpwMPLPY17WvQL5W1ArFUSyvrTuz66+pPdul1oU46qUxOSk99cyeZ5f2nCgknOWPV
         f7yXJQpDRT3+116HlVU+ZSMjf1AqVlIXF4tOTs3t3LepOUOt5iNWy0yu+4OFgGkrT37m
         EBdUiNY05QBTxzCpcBZ+nGH3NSGcgnWRi/Me4ozL3jBd0XN78c6deIS9a9glS0BGMuTH
         gnwCNC5T1pz/Ik6mjiLk1S/FsD5B4EbNf89JFPsbjGJmRlloLg/FZanqe2tJZ3u8QDFW
         08HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FzmRh0gg2DPckYJh1PrBabdGOdbLWTtqvItwXBdWxgk=;
        b=Vkbv4hfMbmTsAxKzcIKv5Oo5Of2Bjj3b4NJqV7rLaNKTYv2MSdhlyalU+ywdV/45SH
         bKiVyTQhLEzQKdWyDu8edLgEPHZx8AKgaHxpvtAEfzpxb6iUESmUoRqlIr7SHDNfVh3k
         qBTw/exH6sUFqGaooKaNPnCYtIZB8IX4vnGkicFvhn991FrvNPf9VUUthQdvlHmJG0KD
         YtUe7+aoVhtOUXgBFyKdDtcACmjL/+Nc7G9GDGat3N803AptRiAZE7sl+BURRkYbJ9MV
         eaxLxuJtEyK97nRnwl/RnijIi11BXpQUmJFkcqx4wH3TYrLqm9UsJHtSFgNclMfYiwQo
         88ug==
X-Gm-Message-State: AOAM532DfA281DcG7cC/hAkK9FO9WeS5WxiMXrcywuCUVxw58PXOMbeL
        y8wr6ohHaYxeu89gPZSf2E42sf4QrR2v7qh9BV7vAg==
X-Google-Smtp-Source: ABdhPJyIIWjFYgprmVnwVKusj0CUliStPV7b1qzfPU1f/C7dzm8H9e6BJjA2RifNRUDWuUgMIYsZ2mKT8q9Ko0H2fFE=
X-Received: by 2002:a25:4a84:: with SMTP id x126mr1038706yba.408.1614304205150;
 Thu, 25 Feb 2021 17:50:05 -0800 (PST)
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
From:   Wei Wang <weiwan@google.com>
Date:   Thu, 25 Feb 2021 17:49:53 -0800
Message-ID: <CAEA6p_DDr6vWwA9P8oeSeZrWWuUJQEcoNzeyqwUQEE77uAUO9w@mail.gmail.com>
Subject: Re: [PATCH net] net: fix race between napi kthread mode and busy poll
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Alexander Duyck <alexanderduyck@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Martin Zaharinov <micron10@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 25, 2021 at 5:19 PM Jakub Kicinski <kuba@kernel.org> wrote:
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

I think it's fine. As long as ___napi_schedule() calls
wake_up_process() to wake up the thread when in threaded mode, I think
that serves the purpose.

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
