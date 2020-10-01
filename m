Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 467D52807B1
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 21:24:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732836AbgJATYz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 15:24:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729990AbgJATYz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 15:24:55 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89068C0613D0
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 12:24:53 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id e5so7398800ils.10
        for <netdev@vger.kernel.org>; Thu, 01 Oct 2020 12:24:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Nq0fgtiINgjnXeQecqRQ6pbbx3ZnofR4OTArXZnt+Ck=;
        b=noCmJ8dIbR6NO2SJL2GGVPKpSKH00vVbUWrvXnspB4GYURFuNp/oC1bkyQ76Ck3r3N
         B0pGHzoNI+ulwT0mE636Iz7TpdsbBxPmdJ/arrzFV8Jrleogq1+zb1MqDcLJ7yRwAUD8
         J4N+5CaS8sEHF1xgUMqs/jwY5IiSgLVmulSPpdvuDxAq67ZgwCA6BneJcI9K09djOClN
         wPMbVxvj22mEZFH87X2ypRhsprhlzAw272yobeM+0xb6+lgYM23zPuODpUFLju/lsKtL
         UBvaRVOrOGOL3+C6MlqoH+KM68jtoHjaXgfhFL/CzsVMHMYlsBx74xl2oReDNKFRvU9h
         RjiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Nq0fgtiINgjnXeQecqRQ6pbbx3ZnofR4OTArXZnt+Ck=;
        b=tlzFrko3j7DWhM4AkHljEDGbWIXJczlE4n+czbRBQ9sehWMOj+3OoWosA+f8qJV9JI
         E8zH6ShisChP2gKXv09cVtJT2CnyMfdqCFbs5OcDg76dq4WvJkND3O4G0TnwQciB+N55
         M1jHWCB2HCfS7i+gysUlAvPrGYfUNKOfWzpHO0MoqED6xocmldEASDXOD7sc4cJzkisH
         SMxIIIBy8dheUN8m97jAyFCHdVerRYJSpqMHw4AzZnmPKvWw93FJk1JD2Ro+a9NAicWO
         2G4qEFz+6PYAPHzBHRXIAE5i1jbmQYzgtkirZAdpbNWG4Ri1LLWUqO8KI6uEN6aai6iV
         rWbg==
X-Gm-Message-State: AOAM532lMiXcglKfHpZQy8WTUaGGErpIoeXg8Cr0SQQSFbsev2yPAKdp
        ooA7m7Ve0S2+hfvso2nsCkh6iHeYAs7wqZa4FVEofQ==
X-Google-Smtp-Source: ABdhPJzCBmN2J2nybs41+bP+Tt8WMoPeFYneGhwILTE0KREbaussxMRTko+eWzJkNjZiaPMHP+6qVVMCOaecvlgfwdM=
X-Received: by 2002:a92:9ad6:: with SMTP id c83mr3463581ill.155.1601580292564;
 Thu, 01 Oct 2020 12:24:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200930192140.4192859-1-weiwan@google.com> <20200930192140.4192859-6-weiwan@google.com>
 <03d4edde-dce3-b263-39eb-d217f06936da@nbd.name> <CAEA6p_AsJuGb3C2MmWNDQYaZQtcCQc2CHdqcSPiH9i9NmPZMdQ@mail.gmail.com>
 <e9fdabda-72b1-fabd-8522-38965a62744c@nbd.name> <CANn89iL0dVFZ1QxMsJd4mT=idtb+AwLE4cFQy9DLzN0heUrqVQ@mail.gmail.com>
 <f1c7ed6f-ca02-1a1b-1489-1af05325832e@nbd.name>
In-Reply-To: <f1c7ed6f-ca02-1a1b-1489-1af05325832e@nbd.name>
From:   Wei Wang <weiwan@google.com>
Date:   Thu, 1 Oct 2020 12:24:41 -0700
Message-ID: <CAEA6p_CYoOmqtP8DDFJw=RKRjDUZ+CrFWgUtiYrgJMjDq3gEag@mail.gmail.com>
Subject: Re: [PATCH net-next 5/5] net: improve napi threaded config
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 1, 2020 at 11:38 AM Felix Fietkau <nbd@nbd.name> wrote:
>
>
> On 2020-10-01 20:03, Eric Dumazet wrote:
> > On Thu, Oct 1, 2020 at 7:12 PM Felix Fietkau <nbd@nbd.name> wrote:
> >>
> >> On 2020-10-01 19:01, Wei Wang wrote:
> >> > On Thu, Oct 1, 2020 at 3:01 AM Felix Fietkau <nbd@nbd.name> wrote:
> >> >>
> >> >>
> >> >> On 2020-09-30 21:21, Wei Wang wrote:
> >> >> > This commit mainly addresses the threaded config to make the switch
> >> >> > between softirq based and kthread based NAPI processing not require
> >> >> > a device down/up.
> >> >> > It also moves the kthread_create() call to the sysfs handler when user
> >> >> > tries to enable "threaded" on napi, and properly handles the
> >> >> > kthread_create() failure. This is because certain drivers do not have
> >> >> > the napi created and linked to the dev when dev_open() is called. So
> >> >> > the previous implementation does not work properly there.
> >> >> >
> >> >> > Signed-off-by: Wei Wang <weiwan@google.com>
> >> >> > ---
> >> >> > Changes since RFC:
> >> >> > changed the thread name to napi/<dev>-<napi-id>
> >> >> >
> >> >> >  net/core/dev.c       | 49 +++++++++++++++++++++++++-------------------
> >> >> >  net/core/net-sysfs.c |  9 +++-----
> >> >> >  2 files changed, 31 insertions(+), 27 deletions(-)
> >> >> >
> >> >> > diff --git a/net/core/dev.c b/net/core/dev.c
> >> >> > index b4f33e442b5e..bf878d3a9d89 100644
> >> >> > --- a/net/core/dev.c
> >> >> > +++ b/net/core/dev.c
> >> >> > @@ -1490,17 +1490,24 @@ EXPORT_SYMBOL(netdev_notify_peers);
> >> >> >
> >> >> >  static int napi_threaded_poll(void *data);
> >> >> >
> >> >> > -static void napi_thread_start(struct napi_struct *n)
> >> >> > +static int napi_kthread_create(struct napi_struct *n)
> >> >> >  {
> >> >> > -     if (test_bit(NAPI_STATE_THREADED, &n->state) && !n->thread)
> >> >> > -             n->thread = kthread_create(napi_threaded_poll, n, "%s-%d",
> >> >> > -                                        n->dev->name, n->napi_id);
> >> >> > +     int err = 0;
> >> >> > +
> >> >> > +     n->thread = kthread_create(napi_threaded_poll, n, "napi/%s-%d",
> >> >> > +                                n->dev->name, n->napi_id);
> >> >> > +     if (IS_ERR(n->thread)) {
> >> >> > +             err = PTR_ERR(n->thread);
> >> >> > +             pr_err("kthread_create failed with err %d\n", err);
> >> >> > +             n->thread = NULL;
> >> >> > +     }
> >> >> > +
> >> >> > +     return err;
> >> >> If I remember correctly, using kthread_create with no explicit first
> >> >> wakeup means the task will sit there and contribute to system loadavg
> >> >> until it is woken up the first time.
> >> >> Shouldn't we use kthread_run here instead?
> >> >>
> >> >
> >> > Right. kthread_create() basically creates the thread and leaves it in
> >> > sleep mode. I think that is what we want. We rely on the next
> >> > ___napi_schedule() call to wake up this thread when there is work to
> >> > do.
> >> But what if you have a device that's basically idle and napi isn't
> >> scheduled until much later? It will get a confusing loadavg until then.
> >> I'd prefer waking up the thread immediately and filtering going back to
> >> sleep once in the thread function before running the loop if
> >> NAPI_STATE_SCHED wasn't set.
> >>
> >
> > I was not aware of this kthread_create() impact on loadavg.
> > This seems like a bug to me. (although I do not care about loadavg)
> >
> > Do you have pointers on some documentation ?

I found this link:
http://www.brendangregg.com/blog/2017-08-08/linux-load-averages.html
It has a section called "Linux Uninterruptible Tasks" which explains
this behavior specifically. But I don't see a good conclusion on why.
Seems to be a convention.
IMHO, this is actually the problem/decision of the loadavg. It should
not impact how the kernel code is implemented. I think it makes more
sense to only wake up the thread when there is work to do.

> I don't have any specific documentation pointers, but this is something
> I observed on several occasions when playing with kthreads.
>
> From what I can find in the loadavg code it seems that tasks in
> TASK_UNINTERRUPTIBLE state are counted for loadavg alongside actually
> runnable tasks. This seems intentional to me, but I don't know why it
> was made like this.
>
> A kthread does not start the thread function until it has been woken up
> at least once, most likely to give the creating code a chance to perform
> some initializations after successfully creating the thread, before the
> thread function starts doing something. Instead, kthread() sets
> TASK_UNINTERRUPTIBLE and calls schedule() once.
>
> > Probably not a big deal, but this seems quite odd to me.
> I've run into enough users that look at loadavg as a measure of system
> load and would likely start reporting bugs if they observe such
> behavior. I'd like to avoid that.
>
> - Felix
