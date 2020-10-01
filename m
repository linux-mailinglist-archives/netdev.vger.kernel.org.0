Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 938AC28062C
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 20:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732967AbgJASDg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 14:03:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730029AbgJASDg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 14:03:36 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98460C0613D0
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 11:03:34 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id n16so346837ilm.8
        for <netdev@vger.kernel.org>; Thu, 01 Oct 2020 11:03:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MGfncaNXf3ZlLjOYkE0CYXhheRa1qte1gZDOf7whOh4=;
        b=bMk0eQxWk615dOwbj6tmX+SmuGbya8vj7egai7N7UK9hsKCsuX7XdO/POzjFztWqIf
         faW1/nwjt8fAPU8aJMvARMJJMDVaCgOS+v+BLwk9zVc3ujnkAXxPxUPtk3uirCNIES3Y
         Ud+Kb916wR98tiNzBbBcX++Ehl7Bj21DOA0REy3PQu5KAWVJ6/jJXmWbfQtN8TKgLrD1
         S+3RcHLsQEAz+5ucWbE7DvUnAWQjpgUFdsuI52zz0xdi4N3xx9rmpJKrHo3EXaKBYGk7
         D+mzqyiBwlQNuHBggQCNUZdS2N1YkevQ8Ooy3QXhKKJxNRMim4xNSXHjvLIrkdBpota4
         xZaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MGfncaNXf3ZlLjOYkE0CYXhheRa1qte1gZDOf7whOh4=;
        b=p03tQGEXjIzTX8NvoE37CpjAqh2U6CuBe7bTavQaiXcDIsPTraBvTKzAHsOQnBhbBu
         T6Gscf94peQMOvLPG9Rs5plqftKCfKiXAhNjqrgwnZiDMeD9sGD6H6/qmmLyslZRF5SD
         FCm7ORwmMFpuu+Mne5vymcOThiIwavX9MhBhHxzKxq8q5COv4chHdNoOPmnOdlUbPqK0
         KpleHevENc6WEjoEYyWce7P9HGGnkrUDzgxOVjTBUwTpHqHfTfyZQG3BAtJjO/6yKdvT
         Z9iizFuSuxXpGy7ep7VzOEuY5x+VLYPVTbC1MBQn5CFGiq3azOkSMfYYpB7AJ/VzS/gB
         TIcQ==
X-Gm-Message-State: AOAM5306phFEOasnZ6joIr/yaVbwadybYQRqTcFq08W/wNd7JvCbsfzN
        qyd7YGW1Ws4q+OR7lj3SNJrYrRdGjO2uNqnC4GZPDA==
X-Google-Smtp-Source: ABdhPJw5DHhk+b1erJckwD/POhUXKgdfh/o2mpG3TCQ2MQCTmd7OrYtZNhYFqJrMmm5husp+mrpZOLRJP6ruij3h2IM=
X-Received: by 2002:a92:ba4d:: with SMTP id o74mr3547198ili.205.1601575413663;
 Thu, 01 Oct 2020 11:03:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200930192140.4192859-1-weiwan@google.com> <20200930192140.4192859-6-weiwan@google.com>
 <03d4edde-dce3-b263-39eb-d217f06936da@nbd.name> <CAEA6p_AsJuGb3C2MmWNDQYaZQtcCQc2CHdqcSPiH9i9NmPZMdQ@mail.gmail.com>
 <e9fdabda-72b1-fabd-8522-38965a62744c@nbd.name>
In-Reply-To: <e9fdabda-72b1-fabd-8522-38965a62744c@nbd.name>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 1 Oct 2020 20:03:22 +0200
Message-ID: <CANn89iL0dVFZ1QxMsJd4mT=idtb+AwLE4cFQy9DLzN0heUrqVQ@mail.gmail.com>
Subject: Re: [PATCH net-next 5/5] net: improve napi threaded config
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Wei Wang <weiwan@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 1, 2020 at 7:12 PM Felix Fietkau <nbd@nbd.name> wrote:
>
> On 2020-10-01 19:01, Wei Wang wrote:
> > On Thu, Oct 1, 2020 at 3:01 AM Felix Fietkau <nbd@nbd.name> wrote:
> >>
> >>
> >> On 2020-09-30 21:21, Wei Wang wrote:
> >> > This commit mainly addresses the threaded config to make the switch
> >> > between softirq based and kthread based NAPI processing not require
> >> > a device down/up.
> >> > It also moves the kthread_create() call to the sysfs handler when user
> >> > tries to enable "threaded" on napi, and properly handles the
> >> > kthread_create() failure. This is because certain drivers do not have
> >> > the napi created and linked to the dev when dev_open() is called. So
> >> > the previous implementation does not work properly there.
> >> >
> >> > Signed-off-by: Wei Wang <weiwan@google.com>
> >> > ---
> >> > Changes since RFC:
> >> > changed the thread name to napi/<dev>-<napi-id>
> >> >
> >> >  net/core/dev.c       | 49 +++++++++++++++++++++++++-------------------
> >> >  net/core/net-sysfs.c |  9 +++-----
> >> >  2 files changed, 31 insertions(+), 27 deletions(-)
> >> >
> >> > diff --git a/net/core/dev.c b/net/core/dev.c
> >> > index b4f33e442b5e..bf878d3a9d89 100644
> >> > --- a/net/core/dev.c
> >> > +++ b/net/core/dev.c
> >> > @@ -1490,17 +1490,24 @@ EXPORT_SYMBOL(netdev_notify_peers);
> >> >
> >> >  static int napi_threaded_poll(void *data);
> >> >
> >> > -static void napi_thread_start(struct napi_struct *n)
> >> > +static int napi_kthread_create(struct napi_struct *n)
> >> >  {
> >> > -     if (test_bit(NAPI_STATE_THREADED, &n->state) && !n->thread)
> >> > -             n->thread = kthread_create(napi_threaded_poll, n, "%s-%d",
> >> > -                                        n->dev->name, n->napi_id);
> >> > +     int err = 0;
> >> > +
> >> > +     n->thread = kthread_create(napi_threaded_poll, n, "napi/%s-%d",
> >> > +                                n->dev->name, n->napi_id);
> >> > +     if (IS_ERR(n->thread)) {
> >> > +             err = PTR_ERR(n->thread);
> >> > +             pr_err("kthread_create failed with err %d\n", err);
> >> > +             n->thread = NULL;
> >> > +     }
> >> > +
> >> > +     return err;
> >> If I remember correctly, using kthread_create with no explicit first
> >> wakeup means the task will sit there and contribute to system loadavg
> >> until it is woken up the first time.
> >> Shouldn't we use kthread_run here instead?
> >>
> >
> > Right. kthread_create() basically creates the thread and leaves it in
> > sleep mode. I think that is what we want. We rely on the next
> > ___napi_schedule() call to wake up this thread when there is work to
> > do.
> But what if you have a device that's basically idle and napi isn't
> scheduled until much later? It will get a confusing loadavg until then.
> I'd prefer waking up the thread immediately and filtering going back to
> sleep once in the thread function before running the loop if
> NAPI_STATE_SCHED wasn't set.
>

I was not aware of this kthread_create() impact on loadavg.
This seems like a bug to me. (although I do not care about loadavg)

Do you have pointers on some documentation ?

Probably not a big deal, but this seems quite odd to me.
