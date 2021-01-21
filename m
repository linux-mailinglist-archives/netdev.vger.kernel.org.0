Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2FB2FE210
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 06:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbhAUFyR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 00:54:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727280AbhAUDh2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 22:37:28 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1886FC0613C1
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 19:36:03 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id y19so1398591iov.2
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 19:36:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tXLAlT46nn7nYT27XteJtGHnS8LZWqgSRLJE/saO8dU=;
        b=ivQNKoQroGmWasiFIF0fh90R0FsjcvlJQeTXSHOCJ0PRbS45YX8KzpqCVABn/uvZEv
         O+mmgaJH6cPQtD0KNH6GpQ2nOjPoCfZkeqPoUi3Ai/nT/UccEGfcEYepiPkwDs3jfEQJ
         JYCmDcf3kv9IOTCNJMsu2QZGhjhSLIDksCpAMSQzwdxYviPT2AgKKt1z9CaIzzIDhpUD
         so4n2bBoZMR5jyX/td/S2Y/ngA8uD7SR5me6caASGOYvtDMa0KtA9IKJTmIRZj9PGgwD
         a+mQWyLuCjhV7Fs26hQGjfn2HdkIXRNacI3Yk/Qjs/RwBZSn+iuXzXZq0r/PMFAmPRkN
         vAyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tXLAlT46nn7nYT27XteJtGHnS8LZWqgSRLJE/saO8dU=;
        b=MPNdaNX5vMb1Dx2B30i5AIR7KX2pY1msh/rxplnabRgJix9f9MVZaOvlws9y6mKI5H
         IIbv83g5o26M05rbHOSBSCoxgiT+weVv2kF3Koz0BHM0fU6xE71JpzHeIMZA1CsCl9bP
         ctC5q/vA9bkaZISxOxEsm8dYPtvFXrQ2FhSHBt8p53zpahGe0XIWhXh+ntmE/uGB8tD8
         y6wimCH3jAw87gn0tEDUkK5M9qKhOTNA9T3S4p5uaTGoqbvutgXhS7xvNqjU+cE4IZfL
         0O0D9aKMiKHUGMSpDqVJPV4stR7WsEQRP9Txc+A/63C5QCoKKcHTSFbQ/7CQCUfMBCqY
         0xxw==
X-Gm-Message-State: AOAM530PwQeD+lPVsvl7ccC99Srapjwcpkj8/ZQcqiTUEZLbbhNLjsXl
        Oi+yShHErkw3hRRLDvzw6BVlrJpi0iS21agLEgY=
X-Google-Smtp-Source: ABdhPJwTUZv6HLHDbY222OqtgdCGbVFSpmvBRoZ7XMP0JMbaN9wQFqj9hi6b+3gx2qV7XCiBp/bASgDm76ws2QSwkQg=
X-Received: by 2002:a5d:934d:: with SMTP id i13mr9159207ioo.187.1611200162333;
 Wed, 20 Jan 2021 19:36:02 -0800 (PST)
MIME-Version: 1.0
References: <20210120033455.4034611-1-weiwan@google.com> <20210120033455.4034611-4-weiwan@google.com>
 <CAKgT0UdKXjPM7sf2qKntEZQWgmDq0yfTOtcfevkZFY11kVK4Qg@mail.gmail.com> <CAEA6p_BnN7uMzR49xYFM3xDgsh8iFBfK5ahHgooXBF-bFz+wcg@mail.gmail.com>
In-Reply-To: <CAEA6p_BnN7uMzR49xYFM3xDgsh8iFBfK5ahHgooXBF-bFz+wcg@mail.gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 20 Jan 2021 19:35:51 -0800
Message-ID: <CAKgT0UcwUxr7wMzt3cYoE3TqZHe_FuG5bWn3a_eUbHpkSJMDLQ@mail.gmail.com>
Subject: Re: [PATCH net-next v7 3/3] net: add sysfs attribute to control napi
 threaded mode
To:     Wei Wang <weiwan@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 20, 2021 at 10:07 AM Wei Wang <weiwan@google.com> wrote:
>
> On Wed, Jan 20, 2021 at 8:13 AM Alexander Duyck
> <alexander.duyck@gmail.com> wrote:
> >
> > On Tue, Jan 19, 2021 at 7:35 PM Wei Wang <weiwan@google.com> wrote:
> > >
> > > This patch adds a new sysfs attribute to the network device class.
> > > Said attribute provides a per-device control to enable/disable the
> > > threaded mode for all the napi instances of the given network device.
> > > User sets it to 1 or 0 to enable or disable threaded mode per device.
> > > However, when user reads from this sysfs entry, it could return:
> > >   1: means all napi instances belonging to this device have threaded
> > > mode enabled.
> > >   0: means all napi instances belonging to this device have threaded
> > > mode disabled.
> > >   -1: means the system fails to enable threaded mode for certain napi
> > > instances when user requests to enable threaded mode. This happens
> > > when the kthread fails to be created for certain napi instances.
> > >
> > > Co-developed-by: Paolo Abeni <pabeni@redhat.com>
> > > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > > Co-developed-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
> > > Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
> > > Co-developed-by: Felix Fietkau <nbd@nbd.name>
> > > Signed-off-by: Felix Fietkau <nbd@nbd.name>
> > > Signed-off-by: Wei Wang <weiwan@google.com>
> > > ---
> > >  include/linux/netdevice.h |  2 ++
> > >  net/core/dev.c            | 28 ++++++++++++++++
> > >  net/core/net-sysfs.c      | 68 +++++++++++++++++++++++++++++++++++++++
> > >  3 files changed, 98 insertions(+)
> > >
> > > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > > index 8cb8d43ea5fa..26c3e8cf4c01 100644
> > > --- a/include/linux/netdevice.h
> > > +++ b/include/linux/netdevice.h
> > > @@ -497,6 +497,8 @@ static inline bool napi_complete(struct napi_struct *n)
> > >         return napi_complete_done(n, 0);
> > >  }
> > >
> > > +int dev_set_threaded(struct net_device *dev, bool threaded);
> > > +
> > >  /**
> > >   *     napi_disable - prevent NAPI from scheduling
> > >   *     @n: NAPI context
> > > diff --git a/net/core/dev.c b/net/core/dev.c
> > > index 7ffa91475856..e71c2fd91595 100644
> > > --- a/net/core/dev.c
> > > +++ b/net/core/dev.c
> > > @@ -6767,6 +6767,34 @@ static int napi_set_threaded(struct napi_struct *n, bool threaded)
> > >         return 0;
> > >  }
> > >
> > > +static void dev_disable_threaded_all(struct net_device *dev)
> > > +{
> > > +       struct napi_struct *napi;
> > > +
> > > +       list_for_each_entry(napi, &dev->napi_list, dev_list)
> > > +               napi_set_threaded(napi, false);
> > > +}
> > > +
> > > +int dev_set_threaded(struct net_device *dev, bool threaded)
> > > +{
> > > +       struct napi_struct *napi;
> > > +       int ret;
> > > +
> > > +       dev->threaded = threaded;
> > > +       list_for_each_entry(napi, &dev->napi_list, dev_list) {
> > > +               ret = napi_set_threaded(napi, threaded);
> > > +               if (ret) {
> > > +                       /* Error occurred on one of the napi,
> > > +                        * reset threaded mode on all napi.
> > > +                        */
> > > +                       dev_disable_threaded_all(dev);
> > > +                       break;
> > > +               }
> > > +       }
> > > +
> > > +       return ret;
> > > +}
> > > +
> >
> > So I have a question about this function. Is there any reason why
> > napi_set_threaded couldn't be broken into two pieces and handled in
> > two passes with the first allocating the kthread and the second
> > setting the threaded bit assuming the allocations all succeeded? The
> > setting or clearing of the bit shouldn't need any return value since
> > it is void and the allocation of the kthread is the piece that can
> > fail. So it seems like it would make sense to see if you can allocate
> > all of the kthreads first before you go through and attempt to enable
> > threaded NAPI.
> >
> > Then you should only need to make a change to netif_napi_add that will
> > allocate the kthread if adding a new instance on a device that is
> > running in threaded mode and if a thread allocation fails you could
> > clear dev->threaded so that when napi_enable is called we don't bother
> > enabling any threaded setups since some of the threads are
> > non-functional.
> >
> If we create kthreads during netif_napi_add() when dev->threaded is
> set, that means the user has to bring down the device, set
> dev->threaded and then bring up the device in order to use threaded
> mode. I think this brings extra steps, while we could have made it
> easier. I believe being able to live switch between on and off without
> device up/down is a good and useful thing.

I think you missed my point. I wasn't saying  you needed to change
this code to call netif_napi_add. What I was suggesting is breaking
this into two passes. The first pass would allocate the kthreads and
call the function you would likely use in the netif_napi_add call, and
the second would set the threaded bit. That way you don't have queues
in limbo during the process where you enable them and then disable
them.

Right now if the device doesn't have any napi instances enabled and
you make this call all it will be doing is setting dev->threaded. So
the thought is to try to reproduce this two step approach at a driver
level.

Then when napi queues are added you would have to add the kthread to
the new napi threads. You are currently doing that in the napi_enable
call. I would argue that it should happen in the netif_napi_add so you
can add them long before the napi is enabled. Unfortunately that still
isn't perfect as it seems some drivers go immediately from
netif_napi_add to napi_enable, however many will add all of their NAPI
instances before they enable them so in that case you could have
similar functionality to this enable call where first pass does the
allocation, and then if it all succeeded you then enable the feature
on all the queues when you call napi_enable and only modify the bit
there instead of trying to do the allocation.

> The other way to do this might be that we always create the kthread
> during netif_napi_add() regardless of the dev->threaded value. And
> when user requests to enable threaded mode, we only enable it, after
> checking every napi has its kthread created.

It doesn't make sense to always allocate the thread. I would only do
that if the netdev has dev->threaded set. Otherwise you can take care
of allocating it here when you toggle the value and leave it allocated
until the napi instance is deleted.

> But this also has its drawbacks. First, it means there will be several
> idle kthreads hanging around even if the user never enables threaded
> mode. Also, there is still the possibility that the kthread creation

As I said, I would only do the allocation if dev->threaded is set
which means the device wants the threaded NAPI.

Also if any allocation fails we should clear the bit on all existing
napi instances and clear dev->threaded. As far as freeing the kthreads
that would probably need to wait until we delete the NAPI instance. So
we would need to add a check somewhere to make sure we aren't
overwriting existing kthreads in the allocation.

> fails. But since netif_napi_add() does not have a return value, no one
> will handle it. Do we just never enable threaded mode in this case? Or
> do we try to recreate the thread when the user tries to enable
> threaded mode through the sysfs interface?

Right now we could handle this the same way we do for napi_enable
which is to not enable the feature if the thread isn't there. The only
difference is I would take it one step further and probably require
that dev->threaded be cleared on an allocation failure. Then before we
set the threaded bit we have to test for it being set and the kthread
is allocated before we allow setting the bit. Otherwise we clear the
threaded bit.
