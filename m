Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C32252FD87B
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 19:43:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391932AbhATSMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 13:12:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391883AbhATSIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 13:08:04 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A42F4C061575
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 10:07:20 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id b11so18028828ybj.9
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 10:07:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rt9agXBCZRXHyy2w3zKbOQopPRnF+vH09IKmfA9J9X8=;
        b=mb2CnxUEVovb0MsgD8ADB1cDIzl5TNr3FkMlYdmyyo6Yc0mvxEG/kgED+jNjmLfNym
         Y2KQ1F0XIpoKMGQ2YA1rPySS790IEnrkpuev+cC6uedGqiCxqogF+BZvpurbUPJUhavH
         JROgVAKl6iS0HxT+qxa6qiL3Rsi8Jqv9k42Ht/3GhkGR8ltS5H101NIJQrrRY/blf6yy
         9ke380N1q+/lHW/oXQ79pdeh3V9rwWdzn4g55jjQUKEMB35wkKWRDH823EYiDSIN440o
         obX6RLmJK/EkudaMS/GcGnKxX9/zXGw5lppjXlnEPfFF6n6j3KFlCaL3HCPPo/cSe6yb
         cpTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rt9agXBCZRXHyy2w3zKbOQopPRnF+vH09IKmfA9J9X8=;
        b=tcHgnpWcM1oPkLFhTPtCsVzQ1O3P9NbNO91g6Ix3wls1HOMiY32MdozMzow7P4C7g6
         grwe+7tPkC2Y1Hz1z+exxkejnAvSiCSbqSfV1xXP2BKa0hhtKxDdSL3mt0CISfoelCj9
         VSTaGBsQJrg+w31oZySA9HCwIDaPgFmn0x9brTh2RXvcHwTurMhtOGDFnsw+5vqfiWv0
         /bNn4vDTH/kPoWf1lg69M7fVLr5E7zc7ebjZ2OFQ78RpSY6F5KgH/TL/aaJKF+nXwo7/
         DFwQj9ZkQ2EPfKOjG9k4XQ1zWlwAQU3+Mxa0p0uUIli875YubB+R6UQJ8cN+W0OB531E
         6JUg==
X-Gm-Message-State: AOAM533hxnzwNBcDebyfXBQo9htFhf/8JDgH/P7fzxI5hM1SfBJ4cZve
        NB3xlfhxrvKkbCPOwMbtr0yeVVXCc6GSQH/KIs6IvnCpWZA=
X-Google-Smtp-Source: ABdhPJyYeUBms7LlJKaq9zecBiJTncszZxn0nLFGx/oKxF08JOJklKd4N3Mr979hH0ny6tHr5RBCisxq2MfgFh72bik=
X-Received: by 2002:a25:10c3:: with SMTP id 186mr14657100ybq.195.1611166039659;
 Wed, 20 Jan 2021 10:07:19 -0800 (PST)
MIME-Version: 1.0
References: <20210120033455.4034611-1-weiwan@google.com> <20210120033455.4034611-4-weiwan@google.com>
 <CAKgT0UdKXjPM7sf2qKntEZQWgmDq0yfTOtcfevkZFY11kVK4Qg@mail.gmail.com>
In-Reply-To: <CAKgT0UdKXjPM7sf2qKntEZQWgmDq0yfTOtcfevkZFY11kVK4Qg@mail.gmail.com>
From:   Wei Wang <weiwan@google.com>
Date:   Wed, 20 Jan 2021 10:07:08 -0800
Message-ID: <CAEA6p_BnN7uMzR49xYFM3xDgsh8iFBfK5ahHgooXBF-bFz+wcg@mail.gmail.com>
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

On Wed, Jan 20, 2021 at 8:13 AM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Tue, Jan 19, 2021 at 7:35 PM Wei Wang <weiwan@google.com> wrote:
> >
> > This patch adds a new sysfs attribute to the network device class.
> > Said attribute provides a per-device control to enable/disable the
> > threaded mode for all the napi instances of the given network device.
> > User sets it to 1 or 0 to enable or disable threaded mode per device.
> > However, when user reads from this sysfs entry, it could return:
> >   1: means all napi instances belonging to this device have threaded
> > mode enabled.
> >   0: means all napi instances belonging to this device have threaded
> > mode disabled.
> >   -1: means the system fails to enable threaded mode for certain napi
> > instances when user requests to enable threaded mode. This happens
> > when the kthread fails to be created for certain napi instances.
> >
> > Co-developed-by: Paolo Abeni <pabeni@redhat.com>
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > Co-developed-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
> > Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
> > Co-developed-by: Felix Fietkau <nbd@nbd.name>
> > Signed-off-by: Felix Fietkau <nbd@nbd.name>
> > Signed-off-by: Wei Wang <weiwan@google.com>
> > ---
> >  include/linux/netdevice.h |  2 ++
> >  net/core/dev.c            | 28 ++++++++++++++++
> >  net/core/net-sysfs.c      | 68 +++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 98 insertions(+)
> >
> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > index 8cb8d43ea5fa..26c3e8cf4c01 100644
> > --- a/include/linux/netdevice.h
> > +++ b/include/linux/netdevice.h
> > @@ -497,6 +497,8 @@ static inline bool napi_complete(struct napi_struct *n)
> >         return napi_complete_done(n, 0);
> >  }
> >
> > +int dev_set_threaded(struct net_device *dev, bool threaded);
> > +
> >  /**
> >   *     napi_disable - prevent NAPI from scheduling
> >   *     @n: NAPI context
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 7ffa91475856..e71c2fd91595 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -6767,6 +6767,34 @@ static int napi_set_threaded(struct napi_struct *n, bool threaded)
> >         return 0;
> >  }
> >
> > +static void dev_disable_threaded_all(struct net_device *dev)
> > +{
> > +       struct napi_struct *napi;
> > +
> > +       list_for_each_entry(napi, &dev->napi_list, dev_list)
> > +               napi_set_threaded(napi, false);
> > +}
> > +
> > +int dev_set_threaded(struct net_device *dev, bool threaded)
> > +{
> > +       struct napi_struct *napi;
> > +       int ret;
> > +
> > +       dev->threaded = threaded;
> > +       list_for_each_entry(napi, &dev->napi_list, dev_list) {
> > +               ret = napi_set_threaded(napi, threaded);
> > +               if (ret) {
> > +                       /* Error occurred on one of the napi,
> > +                        * reset threaded mode on all napi.
> > +                        */
> > +                       dev_disable_threaded_all(dev);
> > +                       break;
> > +               }
> > +       }
> > +
> > +       return ret;
> > +}
> > +
>
> So I have a question about this function. Is there any reason why
> napi_set_threaded couldn't be broken into two pieces and handled in
> two passes with the first allocating the kthread and the second
> setting the threaded bit assuming the allocations all succeeded? The
> setting or clearing of the bit shouldn't need any return value since
> it is void and the allocation of the kthread is the piece that can
> fail. So it seems like it would make sense to see if you can allocate
> all of the kthreads first before you go through and attempt to enable
> threaded NAPI.
>
> Then you should only need to make a change to netif_napi_add that will
> allocate the kthread if adding a new instance on a device that is
> running in threaded mode and if a thread allocation fails you could
> clear dev->threaded so that when napi_enable is called we don't bother
> enabling any threaded setups since some of the threads are
> non-functional.
>
If we create kthreads during netif_napi_add() when dev->threaded is
set, that means the user has to bring down the device, set
dev->threaded and then bring up the device in order to use threaded
mode. I think this brings extra steps, while we could have made it
easier. I believe being able to live switch between on and off without
device up/down is a good and useful thing.
The other way to do this might be that we always create the kthread
during netif_napi_add() regardless of the dev->threaded value. And
when user requests to enable threaded mode, we only enable it, after
checking every napi has its kthread created.
But this also has its drawbacks. First, it means there will be several
idle kthreads hanging around even if the user never enables threaded
mode. Also, there is still the possibility that the kthread creation
fails. But since netif_napi_add() does not have a return value, no one
will handle it. Do we just never enable threaded mode in this case? Or
do we try to recreate the thread when the user tries to enable
threaded mode through the sysfs interface?


> Doing so would guarantee all-or-nothing behavior and you could then
> just use the dev->threaded to signal if the device is running threaded
> or not as you could just clear it if the kthread allocation fails.
