Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D98D28046E
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 19:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732507AbgJARBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 13:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732213AbgJARBT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 13:01:19 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 000C4C0613D0
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 10:01:18 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id q1so6841839ilt.6
        for <netdev@vger.kernel.org>; Thu, 01 Oct 2020 10:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iehfSPpuv4hKWiWmJEUx6ZY7Y4Ou0v5svtSmpPErg3Y=;
        b=dSYwucB/nY/CiYeDpmi6AZH/HOd430nMpHkkQb/u7ewHZpWz+8xhNxdGSnjfjMwhJ6
         ZfF+rPHacVel1c6sD2N94SAr0WnoELHWMJbHN+nktKKRmAc+SNIV/nIVsvU8SCqz9hQf
         uiAvUf+oLmUJDqV8G7G3cm9iVbUOR6k66V8cRKSwGApFKcvrKEx3z6jgsToW5f9/4qhU
         61RnWGvZ2zjxZ1Fjbih+iPZh5v5nvPJLL8ZKQRnUgcYTUAM6B13o+4bOl8I8XEaubcSD
         AhDXwxlhix+5r8b7xKjYid7e+HQZtTwz+RupTQrNkj2mdcClvNLFnSq7MJvsgtyH3BGE
         7XJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iehfSPpuv4hKWiWmJEUx6ZY7Y4Ou0v5svtSmpPErg3Y=;
        b=atKVy6J6qzSHZvQjp2VQ2+H1MyZGY9gYsFewW0mwxRU0uLyN2lD3izYnhFgThqX24y
         XAOQarhXdS9SNxe/dV65Og05mVmsQUrr4DdXG0bp12LZ95M6GfQrlWPY0i5jjg5a/Y9c
         CL6/uQTaEHlbiDkht1c4ekpARV8srsL8W+dyS9I/FpHgbDJe3TTseyQd6weVZVKYyvlM
         MCj2jlyF6f8SQTkjZogSKgkSfkWAqE3x8a1A0q8CwqqNbCWJMtVqpU4OW/IhSXqvqON0
         XobvrXD8ARQSbYZ4kGmjmyj8/zVwsxHr90aPY7KyUMHBAnP0/rdqlP/iBNhNlmLbjap1
         NvMw==
X-Gm-Message-State: AOAM531TvGKE7sRsBdxBLe13KLPLnt8N5GEZpvzrkSGJ+SFXf8/Adu0f
        a9jDRjdOFFMtxtE1G9mGIQtqVUl0t+Lpw8MCPMa1+Q==
X-Google-Smtp-Source: ABdhPJyJlFKpuIxLKl6+UMXZe+Ce5h73Z0xP1oXq2rxPGNj7apVfybxGeFJ7R84Qv6ryohPIetNSR1hIMpFvE4rAvxk=
X-Received: by 2002:a05:6e02:dc1:: with SMTP id l1mr3150645ilj.74.1601571677965;
 Thu, 01 Oct 2020 10:01:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200930192140.4192859-1-weiwan@google.com> <20200930192140.4192859-6-weiwan@google.com>
 <03d4edde-dce3-b263-39eb-d217f06936da@nbd.name>
In-Reply-To: <03d4edde-dce3-b263-39eb-d217f06936da@nbd.name>
From:   Wei Wang <weiwan@google.com>
Date:   Thu, 1 Oct 2020 10:01:06 -0700
Message-ID: <CAEA6p_AsJuGb3C2MmWNDQYaZQtcCQc2CHdqcSPiH9i9NmPZMdQ@mail.gmail.com>
Subject: Re: [PATCH net-next 5/5] net: improve napi threaded config
To:     Felix Fietkau <nbd@nbd.name>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 1, 2020 at 3:01 AM Felix Fietkau <nbd@nbd.name> wrote:
>
>
> On 2020-09-30 21:21, Wei Wang wrote:
> > This commit mainly addresses the threaded config to make the switch
> > between softirq based and kthread based NAPI processing not require
> > a device down/up.
> > It also moves the kthread_create() call to the sysfs handler when user
> > tries to enable "threaded" on napi, and properly handles the
> > kthread_create() failure. This is because certain drivers do not have
> > the napi created and linked to the dev when dev_open() is called. So
> > the previous implementation does not work properly there.
> >
> > Signed-off-by: Wei Wang <weiwan@google.com>
> > ---
> > Changes since RFC:
> > changed the thread name to napi/<dev>-<napi-id>
> >
> >  net/core/dev.c       | 49 +++++++++++++++++++++++++-------------------
> >  net/core/net-sysfs.c |  9 +++-----
> >  2 files changed, 31 insertions(+), 27 deletions(-)
> >
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index b4f33e442b5e..bf878d3a9d89 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -1490,17 +1490,24 @@ EXPORT_SYMBOL(netdev_notify_peers);
> >
> >  static int napi_threaded_poll(void *data);
> >
> > -static void napi_thread_start(struct napi_struct *n)
> > +static int napi_kthread_create(struct napi_struct *n)
> >  {
> > -     if (test_bit(NAPI_STATE_THREADED, &n->state) && !n->thread)
> > -             n->thread = kthread_create(napi_threaded_poll, n, "%s-%d",
> > -                                        n->dev->name, n->napi_id);
> > +     int err = 0;
> > +
> > +     n->thread = kthread_create(napi_threaded_poll, n, "napi/%s-%d",
> > +                                n->dev->name, n->napi_id);
> > +     if (IS_ERR(n->thread)) {
> > +             err = PTR_ERR(n->thread);
> > +             pr_err("kthread_create failed with err %d\n", err);
> > +             n->thread = NULL;
> > +     }
> > +
> > +     return err;
> If I remember correctly, using kthread_create with no explicit first
> wakeup means the task will sit there and contribute to system loadavg
> until it is woken up the first time.
> Shouldn't we use kthread_run here instead?
>

Right. kthread_create() basically creates the thread and leaves it in
sleep mode. I think that is what we want. We rely on the next
___napi_schedule() call to wake up this thread when there is work to
do.

> - Felix
