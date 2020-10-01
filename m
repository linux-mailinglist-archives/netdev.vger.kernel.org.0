Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E07C9280A5C
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 00:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728090AbgJAWmU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 18:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726741AbgJAWmU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 18:42:20 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 138DFC0613D0
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 15:42:20 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id q1so33156ilt.6
        for <netdev@vger.kernel.org>; Thu, 01 Oct 2020 15:42:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hbC46zk8AEIfKvKFSrj1Y8ZUxQtUCIJLz6NlQOJ8Inw=;
        b=NbSyq83eGyIyPaMLRetf7fMOmLveRA9zH7775Hz2UIWXVcRTxKcGYhItN+b4naeZGC
         AVsfuob0HGKK1xf54wrhU/gbtgjHTuFh851wuYwzLFXy5yTYiREc9hZKW0eEE8ALkQEu
         CBhGauLw46U+FxWzM4ZyBB3A+ZALleP1eblpg/sSaW0CHxJu9E7fh6NVBhZdmliz/Y6n
         JKVfu7Lxs6sEYwVXhzHilVfNxlQ9LX+GAJoISsesxh1Nl7q/krFGHgVMG3hjI/9r5D8n
         rkq8k+w7asgMRUwUKJnM6eL5HUG/XkANPbg55I08e90ePirb7Xo/zZOm2V2gsbEiB3Jk
         sqQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hbC46zk8AEIfKvKFSrj1Y8ZUxQtUCIJLz6NlQOJ8Inw=;
        b=gb39ADZZ9rFuW6V9fjYd3O9JmuV9TFgii0Le58U7+Y8u26ihiE6Yq7WsO0CSTeSZ+5
         bD1XryUl8d8ipzvIWp+ZeasIyopzvJIYDKx7KZhtbLzAq6DQwH3dpOswzb32UKOav8NM
         3HcCtaGAcOeoH2AbfI56k4FWA62fi1b4+zqcdUgCSBkwWMyj+7VyZMOCHIsFPn/TshII
         FN4zVD3N0h4jJXS6t+F3O9gOoQl+EOKXuw13fOVHshyJq4xJsgd4+WhiKxeDQMOTNHuS
         hnz05oxOeU+4tMDQlLEjrWdXcCPBiNOLK00qzODCnwAQTla5dDsTrWjk0tBvVEhpXJG2
         cvdg==
X-Gm-Message-State: AOAM531bO4Tn89x2lz9gEBwm8cGc+2LyjyAVMi5nYzjk8Kkl9AI5C9bo
        aPIeJtYzAge4LJ4vQXvnC9HL+/tOJyQNebgYz2v9pw==
X-Google-Smtp-Source: ABdhPJzus9/rUjuzoLLH0ag2+CTJAt2hcAdulAEx4Gd/U2HjHKhN/acQf5tUaflCZ6HTcTSBMb6AN/L/ohf27D9CPOs=
X-Received: by 2002:a05:6e02:dc1:: with SMTP id l1mr4248100ilj.74.1601592139153;
 Thu, 01 Oct 2020 15:42:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200930192140.4192859-1-weiwan@google.com> <20200930192140.4192859-6-weiwan@google.com>
 <03d4edde-dce3-b263-39eb-d217f06936da@nbd.name> <CAEA6p_AsJuGb3C2MmWNDQYaZQtcCQc2CHdqcSPiH9i9NmPZMdQ@mail.gmail.com>
 <e9fdabda-72b1-fabd-8522-38965a62744c@nbd.name> <CANn89iL0dVFZ1QxMsJd4mT=idtb+AwLE4cFQy9DLzN0heUrqVQ@mail.gmail.com>
 <f1c7ed6f-ca02-1a1b-1489-1af05325832e@nbd.name> <CAEA6p_CYoOmqtP8DDFJw=RKRjDUZ+CrFWgUtiYrgJMjDq3gEag@mail.gmail.com>
 <032b71b1-42b9-81d4-81e2-cebd53c77099@nbd.name>
In-Reply-To: <032b71b1-42b9-81d4-81e2-cebd53c77099@nbd.name>
From:   Wei Wang <weiwan@google.com>
Date:   Thu, 1 Oct 2020 15:42:07 -0700
Message-ID: <CAEA6p_ABdyVBK0dRGfDLda9noDknBXM9BGxB-WHAgS0OtkBrTw@mail.gmail.com>
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

On Thu, Oct 1, 2020 at 1:48 PM Felix Fietkau <nbd@nbd.name> wrote:
>
>
> On 2020-10-01 21:24, Wei Wang wrote:
> > On Thu, Oct 1, 2020 at 11:38 AM Felix Fietkau <nbd@nbd.name> wrote:
> >>
> >>
> >> On 2020-10-01 20:03, Eric Dumazet wrote:
> >> > On Thu, Oct 1, 2020 at 7:12 PM Felix Fietkau <nbd@nbd.name> wrote:
> >> >>
> >> >> On 2020-10-01 19:01, Wei Wang wrote:
> >> >> > On Thu, Oct 1, 2020 at 3:01 AM Felix Fietkau <nbd@nbd.name> wrote:
> >> >> >>
> >> >> >>
> >> >> >> On 2020-09-30 21:21, Wei Wang wrote:
> >> >> >> > This commit mainly addresses the threaded config to make the switch
> >> >> >> > between softirq based and kthread based NAPI processing not require
> >> >> >> > a device down/up.
> >> >> >> > It also moves the kthread_create() call to the sysfs handler when user
> >> >> >> > tries to enable "threaded" on napi, and properly handles the
> >> >> >> > kthread_create() failure. This is because certain drivers do not have
> >> >> >> > the napi created and linked to the dev when dev_open() is called. So
> >> >> >> > the previous implementation does not work properly there.
> >> >> >> >
> >> >> >> > Signed-off-by: Wei Wang <weiwan@google.com>
> >> >> >> > ---
> >> >> >> > Changes since RFC:
> >> >> >> > changed the thread name to napi/<dev>-<napi-id>
> >> >> >> >
> >> >> >> >  net/core/dev.c       | 49 +++++++++++++++++++++++++-------------------
> >> >> >> >  net/core/net-sysfs.c |  9 +++-----
> >> >> >> >  2 files changed, 31 insertions(+), 27 deletions(-)
> >> >> >> >
> >> >> >> > diff --git a/net/core/dev.c b/net/core/dev.c
> >> >> >> > index b4f33e442b5e..bf878d3a9d89 100644
> >> >> >> > --- a/net/core/dev.c
> >> >> >> > +++ b/net/core/dev.c
> >> >> >> > @@ -1490,17 +1490,24 @@ EXPORT_SYMBOL(netdev_notify_peers);
> >> >> >> >
> >> >> >> >  static int napi_threaded_poll(void *data);
> >> >> >> >
> >> >> >> > -static void napi_thread_start(struct napi_struct *n)
> >> >> >> > +static int napi_kthread_create(struct napi_struct *n)
> >> >> >> >  {
> >> >> >> > -     if (test_bit(NAPI_STATE_THREADED, &n->state) && !n->thread)
> >> >> >> > -             n->thread = kthread_create(napi_threaded_poll, n, "%s-%d",
> >> >> >> > -                                        n->dev->name, n->napi_id);
> >> >> >> > +     int err = 0;
> >> >> >> > +
> >> >> >> > +     n->thread = kthread_create(napi_threaded_poll, n, "napi/%s-%d",
> >> >> >> > +                                n->dev->name, n->napi_id);
> >> >> >> > +     if (IS_ERR(n->thread)) {
> >> >> >> > +             err = PTR_ERR(n->thread);
> >> >> >> > +             pr_err("kthread_create failed with err %d\n", err);
> >> >> >> > +             n->thread = NULL;
> >> >> >> > +     }
> >> >> >> > +
> >> >> >> > +     return err;
> >> >> >> If I remember correctly, using kthread_create with no explicit first
> >> >> >> wakeup means the task will sit there and contribute to system loadavg
> >> >> >> until it is woken up the first time.
> >> >> >> Shouldn't we use kthread_run here instead?
> >> >> >>
> >> >> >
> >> >> > Right. kthread_create() basically creates the thread and leaves it in
> >> >> > sleep mode. I think that is what we want. We rely on the next
> >> >> > ___napi_schedule() call to wake up this thread when there is work to
> >> >> > do.
> >> >> But what if you have a device that's basically idle and napi isn't
> >> >> scheduled until much later? It will get a confusing loadavg until then.
> >> >> I'd prefer waking up the thread immediately and filtering going back to
> >> >> sleep once in the thread function before running the loop if
> >> >> NAPI_STATE_SCHED wasn't set.
> >> >>
> >> >
> >> > I was not aware of this kthread_create() impact on loadavg.
> >> > This seems like a bug to me. (although I do not care about loadavg)
> >> >
> >> > Do you have pointers on some documentation ?
> >
> > I found this link:
> > http://www.brendangregg.com/blog/2017-08-08/linux-load-averages.html
> > It has a section called "Linux Uninterruptible Tasks" which explains
> > this behavior specifically. But I don't see a good conclusion on why.
> > Seems to be a convention.
> > IMHO, this is actually the problem/decision of the loadavg. It should
> > not impact how the kernel code is implemented. I think it makes more
> > sense to only wake up the thread when there is work to do.
> There were other users of kthread where the same issue was fixed.
> With a quick search, I found these commits:
> e890591413819eeb604207ad3261ba617b2ec0bb
> 3f776e8a25a9d281125490562e1cc5bd7c14cf7c
>
> Please note that one of these describes that a kthread that was created
> but not woken was triggering a blocked task warning - so it's not just
> the loadavg that matters here.
>
> All the other users of kthread that I looked at also do an initial
> wakeup of the thread. Not doing it seems like wrong use of the API to me.
>

Thanks Felix for digging up the above commits. Very helpful. I will
change it to kthread_run() in v2.

> - Felix
