Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B72D2FF278
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 18:53:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389276AbhAURwq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 12:52:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389061AbhAURqx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 12:46:53 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36093C06174A
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 09:46:10 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id k4so2852889ybp.6
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 09:46:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pRj1o/GEsHsAVDnq+hT8otuI8u2O8BV63p4Gz/fOkzA=;
        b=lJZawNa6dS+CVa2+Xw7uDoqiNkMbVY86Yy2kfN7Y5LNz/+1qx2rTn2hAGa6H7cO8Sk
         3KoWX21lZDFn+X6IVzv3nLzgbApqptppMgXMm+QFi8fTJUhY4OF2q++NyBy+m4IwTatc
         oRZtOtDYsNirVemP+sDy1ygSb52dyUpax/H5rpdw1SI+t8JMKbLpPqNN2BFNp6K1EG8R
         m0Hr7B2phd5R+ACQwDT/oRi3dXTLLepiZGTVG8y4fnDx1RumJhjYlDTEkZbRwiIOtNP2
         bAtPkC50CY9yGd9TdhbkFUr6vnK0ptXW1yreFrRL4C+zjR4OV0LgVG6uUDjd7/BFGk6q
         5NgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pRj1o/GEsHsAVDnq+hT8otuI8u2O8BV63p4Gz/fOkzA=;
        b=lK6JiSLrpAOWsDasBU/yINBwPXCEpxJPf+NCdnRP5gsp7to6AjedwUoHdq9Fv24jVS
         Vk+pF7EZFnwLWAo3ddUxI1Qr3ef4Qi4rMfkl+Sc+LusIt3CRsXnNmcRbjMvLnwp+J2iQ
         vyahaZ57nDXHlO7zOygtxGK4MBNTqFVv53M6XzduP1M9VxzAbQHurNBkN1re94f4Yp/O
         Rprw1bGOQOwGT49JVwp4lD63RQ3VOn7XaWJXNuJib/rQvbhdLHHQwOS7Rex9dQpFxyaM
         J8yfPY9IQ06DV9KbhcNwF9sNhSF5CuAwGb8cLZvEUCcMfRwChgKB27JQa+Vy0IHRSl1q
         QRbA==
X-Gm-Message-State: AOAM533FTJ3yG7UPU/EHfrajViVYl5I3uKiyCdonbKX9OKE3XcDdGIxr
        +7YyXJ4iefKONYZ6ZXvBU0WWzSGn8N5fEZgemQ8OQw==
X-Google-Smtp-Source: ABdhPJzeXTjrcOIINm0yfqbGH5M/SDOrmxJbALr27tsO8U4hhafcUkltcRxzTjA9g7enp0n1Ejd/b5wIdLzRnOSaxWo=
X-Received: by 2002:a5b:74c:: with SMTP id s12mr581324ybq.187.1611251169194;
 Thu, 21 Jan 2021 09:46:09 -0800 (PST)
MIME-Version: 1.0
References: <20210120033455.4034611-1-weiwan@google.com> <20210120033455.4034611-4-weiwan@google.com>
 <CAKgT0UdKXjPM7sf2qKntEZQWgmDq0yfTOtcfevkZFY11kVK4Qg@mail.gmail.com>
 <CAEA6p_BnN7uMzR49xYFM3xDgsh8iFBfK5ahHgooXBF-bFz+wcg@mail.gmail.com> <CAKgT0UcwUxr7wMzt3cYoE3TqZHe_FuG5bWn3a_eUbHpkSJMDLQ@mail.gmail.com>
In-Reply-To: <CAKgT0UcwUxr7wMzt3cYoE3TqZHe_FuG5bWn3a_eUbHpkSJMDLQ@mail.gmail.com>
From:   Wei Wang <weiwan@google.com>
Date:   Thu, 21 Jan 2021 09:45:57 -0800
Message-ID: <CAEA6p_C8D1b6R-=_fYezYEiX9zqkwFnDhg4PPR5QNJ39UL-5FQ@mail.gmail.com>
Subject: Re: [PATCH net-next v7 3/3] net: add sysfs attribute to control napi
 threaded mode
To:     Alexander Duyck <alexander.duyck@gmail.com>
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

On Wed, Jan 20, 2021 at 7:36 PM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Wed, Jan 20, 2021 at 10:07 AM Wei Wang <weiwan@google.com> wrote:
> >
> > On Wed, Jan 20, 2021 at 8:13 AM Alexander Duyck
> > <alexander.duyck@gmail.com> wrote:
> > >
> > > On Tue, Jan 19, 2021 at 7:35 PM Wei Wang <weiwan@google.com> wrote:
> > > >
> > > > This patch adds a new sysfs attribute to the network device class.
> > > > Said attribute provides a per-device control to enable/disable the
> > > > threaded mode for all the napi instances of the given network device.
> > > > User sets it to 1 or 0 to enable or disable threaded mode per device.
> > > > However, when user reads from this sysfs entry, it could return:
> > > >   1: means all napi instances belonging to this device have threaded
> > > > mode enabled.
> > > >   0: means all napi instances belonging to this device have threaded
> > > > mode disabled.
> > > >   -1: means the system fails to enable threaded mode for certain napi
> > > > instances when user requests to enable threaded mode. This happens
> > > > when the kthread fails to be created for certain napi instances.
> > > >
> > > > Co-developed-by: Paolo Abeni <pabeni@redhat.com>
> > > > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > > > Co-developed-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
> > > > Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
> > > > Co-developed-by: Felix Fietkau <nbd@nbd.name>
> > > > Signed-off-by: Felix Fietkau <nbd@nbd.name>
> > > > Signed-off-by: Wei Wang <weiwan@google.com>
> > > > ---
> > > >  include/linux/netdevice.h |  2 ++
> > > >  net/core/dev.c            | 28 ++++++++++++++++
> > > >  net/core/net-sysfs.c      | 68 +++++++++++++++++++++++++++++++++++++++
> > > >  3 files changed, 98 insertions(+)
> > > >
> > > > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > > > index 8cb8d43ea5fa..26c3e8cf4c01 100644
> > > > --- a/include/linux/netdevice.h
> > > > +++ b/include/linux/netdevice.h
> > > > @@ -497,6 +497,8 @@ static inline bool napi_complete(struct napi_struct *n)
> > > >         return napi_complete_done(n, 0);
> > > >  }
> > > >
> > > > +int dev_set_threaded(struct net_device *dev, bool threaded);
> > > > +
> > > >  /**
> > > >   *     napi_disable - prevent NAPI from scheduling
> > > >   *     @n: NAPI context
> > > > diff --git a/net/core/dev.c b/net/core/dev.c
> > > > index 7ffa91475856..e71c2fd91595 100644
> > > > --- a/net/core/dev.c
> > > > +++ b/net/core/dev.c
> > > > @@ -6767,6 +6767,34 @@ static int napi_set_threaded(struct napi_struct *n, bool threaded)
> > > >         return 0;
> > > >  }
> > > >
> > > > +static void dev_disable_threaded_all(struct net_device *dev)
> > > > +{
> > > > +       struct napi_struct *napi;
> > > > +
> > > > +       list_for_each_entry(napi, &dev->napi_list, dev_list)
> > > > +               napi_set_threaded(napi, false);
> > > > +}
> > > > +
> > > > +int dev_set_threaded(struct net_device *dev, bool threaded)
> > > > +{
> > > > +       struct napi_struct *napi;
> > > > +       int ret;
> > > > +
> > > > +       dev->threaded = threaded;
> > > > +       list_for_each_entry(napi, &dev->napi_list, dev_list) {
> > > > +               ret = napi_set_threaded(napi, threaded);
> > > > +               if (ret) {
> > > > +                       /* Error occurred on one of the napi,
> > > > +                        * reset threaded mode on all napi.
> > > > +                        */
> > > > +                       dev_disable_threaded_all(dev);
> > > > +                       break;
> > > > +               }
> > > > +       }
> > > > +
> > > > +       return ret;
> > > > +}
> > > > +
> > >
> > > So I have a question about this function. Is there any reason why
> > > napi_set_threaded couldn't be broken into two pieces and handled in
> > > two passes with the first allocating the kthread and the second
> > > setting the threaded bit assuming the allocations all succeeded? The
> > > setting or clearing of the bit shouldn't need any return value since
> > > it is void and the allocation of the kthread is the piece that can
> > > fail. So it seems like it would make sense to see if you can allocate
> > > all of the kthreads first before you go through and attempt to enable
> > > threaded NAPI.
> > >
> > > Then you should only need to make a change to netif_napi_add that will
> > > allocate the kthread if adding a new instance on a device that is
> > > running in threaded mode and if a thread allocation fails you could
> > > clear dev->threaded so that when napi_enable is called we don't bother
> > > enabling any threaded setups since some of the threads are
> > > non-functional.
> > >
> > If we create kthreads during netif_napi_add() when dev->threaded is
> > set, that means the user has to bring down the device, set
> > dev->threaded and then bring up the device in order to use threaded
> > mode. I think this brings extra steps, while we could have made it
> > easier. I believe being able to live switch between on and off without
> > device up/down is a good and useful thing.
>
> I think you missed my point. I wasn't saying  you needed to change
> this code to call netif_napi_add. What I was suggesting is breaking
> this into two passes. The first pass would allocate the kthreads and
> call the function you would likely use in the netif_napi_add call, and
> the second would set the threaded bit. That way you don't have queues
> in limbo during the process where you enable them and then disable
> them.
>
> Right now if the device doesn't have any napi instances enabled and
> you make this call all it will be doing is setting dev->threaded. So
> the thought is to try to reproduce this two step approach at a driver
> level.
>
> Then when napi queues are added you would have to add the kthread to
> the new napi threads. You are currently doing that in the napi_enable
> call. I would argue that it should happen in the netif_napi_add so you
> can add them long before the napi is enabled. Unfortunately that still
> isn't perfect as it seems some drivers go immediately from
> netif_napi_add to napi_enable, however many will add all of their NAPI
> instances before they enable them so in that case you could have
> similar functionality to this enable call where first pass does the
> allocation, and then if it all succeeded you then enable the feature
> on all the queues when you call napi_enable and only modify the bit
> there instead of trying to do the allocation.
>
> > The other way to do this might be that we always create the kthread
> > during netif_napi_add() regardless of the dev->threaded value. And
> > when user requests to enable threaded mode, we only enable it, after
> > checking every napi has its kthread created.
>
> It doesn't make sense to always allocate the thread. I would only do
> that if the netdev has dev->threaded set. Otherwise you can take care
> of allocating it here when you toggle the value and leave it allocated
> until the napi instance is deleted.
>
> > But this also has its drawbacks. First, it means there will be several
> > idle kthreads hanging around even if the user never enables threaded
> > mode. Also, there is still the possibility that the kthread creation
>
> As I said, I would only do the allocation if dev->threaded is set
> which means the device wants the threaded NAPI.
>
> Also if any allocation fails we should clear the bit on all existing
> napi instances and clear dev->threaded. As far as freeing the kthreads
> that would probably need to wait until we delete the NAPI instance. So
> we would need to add a check somewhere to make sure we aren't
> overwriting existing kthreads in the allocation.
>
> > fails. But since netif_napi_add() does not have a return value, no one
> > will handle it. Do we just never enable threaded mode in this case? Or
> > do we try to recreate the thread when the user tries to enable
> > threaded mode through the sysfs interface?
>
> Right now we could handle this the same way we do for napi_enable
> which is to not enable the feature if the thread isn't there. The only
> difference is I would take it one step further and probably require
> that dev->threaded be cleared on an allocation failure. Then before we
> set the threaded bit we have to test for it being set and the kthread
> is allocated before we allow setting the bit. Otherwise we clear the
> threaded bit.

Thanks for the clarification. I think I got it. The only inconsistency
would be the case where you've mentioned that if the driver calls
napi_enable() immediately after netif_napi_add() without adding all
the napi instances in advance. I would ignore that case and still use
dev->threaded to indicate whether threaded mode is enabled or not.
This way, we could get rid of the ternary value on dev->threaded.
