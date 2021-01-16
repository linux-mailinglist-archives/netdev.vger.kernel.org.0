Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1F8E2F8AB0
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 03:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726059AbhAPCTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 21:19:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbhAPCTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 21:19:01 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26414C0613D3
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 18:18:21 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id n4so21886365iow.12
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 18:18:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8M7f+hvc6BNI1bM1cDjdlEub2ljHtbMoDMtqJvvj6Io=;
        b=Cfnrz7EdWQ2ysvzASrI4Upu8a1N7KoG3/xHgDZ8S/18kqIWYZnfjS81pFbNfiU7gGV
         A561AsvKiZVpBhYxanZ3O8sVwYY9Sbu+cKRHnVxy8+zR9PGp2nMDYIIQ0puMMr784/sa
         1iAJ9oExyF945CDqvuSRiqK8DBQ8crXaI2l7TNnnWDIY5d8DRUFpSwVQU/1GkVWp5bIq
         e93dOLUppAOjat55M3gSn/WPI+MqGfD9oiXAvpwcqaCzfy3+JpqDwVWjfrMn/uCpkyGQ
         hteNFz8Chlp8EO/k+T95wTP+u4YVw/UYJzvFuJWFhwwETSj6w2P3iJLQCTRvLMKG12qy
         scrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8M7f+hvc6BNI1bM1cDjdlEub2ljHtbMoDMtqJvvj6Io=;
        b=uQ80nrWotHbpqQ024cI/D9QdeEhUmS8GP/nv7vfFs9ehtOp1lZBAj7OsxbyODoaLFC
         /RkUSh5h5EkEhtRypRDu/tLEnY0C9x5fqHIZrKX4hAOBJwB+IrYa3hesfipkZiB/URrb
         taENt4OuSlEOBxMrAqsEi+4t0Aq1TL3xHDAewocTWbRr98Q9VJdhCXFsfmm+eoihhSQi
         oMPenLPVQ21pzqYFpkK2JSM2ZCXGXTcgK+NcU5mhr8mSWQOdEBbjmFfuvA0ozX/PiNc6
         3qMJu/zXbJFNGLaPC78nX9ovlCjoz9adkI1yqWcV42i9okTFMV9vIdf/4tHwVt9CSTVJ
         V1cw==
X-Gm-Message-State: AOAM532xHBQriH1hLSnJymRgG9UcDONtkndEfc1tp4b352R9lU2Cuwvd
        oiwlB2PSlYoitZkw38/b61B+javyKWc3cBBhwuE=
X-Google-Smtp-Source: ABdhPJwMTSnsleVIHaPVse6Fs9y8pC/ALuSsMQ1R6yGenmtKzbIF7HAbZe+Boqs6ZRCQ/gKw2mVpOMd1wfSPcSzKmRY=
X-Received: by 2002:a05:6602:2c52:: with SMTP id x18mr2380371iov.5.1610763500375;
 Fri, 15 Jan 2021 18:18:20 -0800 (PST)
MIME-Version: 1.0
References: <20210115003123.1254314-1-weiwan@google.com> <20210115003123.1254314-4-weiwan@google.com>
 <CAKgT0UdRK=KXT40nPmHbCeLixDkwdYEEFbwECnAKBFBjUsPOHQ@mail.gmail.com>
 <CAEA6p_DN+Cgo2bB6zBXC966g2PiSfOEifY0jR6QKU4mNrVmf2Q@mail.gmail.com>
 <CAKgT0UfgWY9dqOeyajjU7YAmDcAPQik5+4z7UoTB7GbDHUTGUw@mail.gmail.com> <CAEA6p_CH3-ppNAEV4HR845ZCnXBH3U=S+=N=OwVtE6uiH0VKNA@mail.gmail.com>
In-Reply-To: <CAEA6p_CH3-ppNAEV4HR845ZCnXBH3U=S+=N=OwVtE6uiH0VKNA@mail.gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 15 Jan 2021 18:18:09 -0800
Message-ID: <CAKgT0UfCVRZz++sTXHKSXvzCTBWGoEoBKC10OasXYiLNq4pCgQ@mail.gmail.com>
Subject: Re: [PATCH net-next v6 3/3] net: add sysfs attribute to control napi
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

On Fri, Jan 15, 2021 at 4:44 PM Wei Wang <weiwan@google.com> wrote:
>
> On Fri, Jan 15, 2021 at 3:08 PM Alexander Duyck
> <alexander.duyck@gmail.com> wrote:
> >
> > On Fri, Jan 15, 2021 at 1:54 PM Wei Wang <weiwan@google.com> wrote:
> > >
> > > On Thu, Jan 14, 2021 at 7:34 PM Alexander Duyck
> > > <alexander.duyck@gmail.com> wrote:
> > > >
> > > > On Thu, Jan 14, 2021 at 4:34 PM Wei Wang <weiwan@google.com> wrote:
> > > > >
> > > > > This patch adds a new sysfs attribute to the network device class.
> > > > > Said attribute provides a per-device control to enable/disable the
> > > > > threaded mode for all the napi instances of the given network device.
> > > > >
> > > > > Co-developed-by: Paolo Abeni <pabeni@redhat.com>
> > > > > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > > > > Co-developed-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
> > > > > Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
> > > > > Co-developed-by: Felix Fietkau <nbd@nbd.name>
> > > > > Signed-off-by: Felix Fietkau <nbd@nbd.name>
> > > > > Signed-off-by: Wei Wang <weiwan@google.com>
> > > > > ---
> > > > >  include/linux/netdevice.h |  2 ++
> > > > >  net/core/dev.c            | 28 +++++++++++++++++
> > > > >  net/core/net-sysfs.c      | 63 +++++++++++++++++++++++++++++++++++++++
> > > > >  3 files changed, 93 insertions(+)
> > > > >
> > > > > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > > > > index c24ed232c746..11ae0c9b9350 100644
> > > > > --- a/include/linux/netdevice.h
> > > > > +++ b/include/linux/netdevice.h
> > > > > @@ -497,6 +497,8 @@ static inline bool napi_complete(struct napi_struct *n)
> > > > >         return napi_complete_done(n, 0);
> > > > >  }
> > > > >
> > > > > +int dev_set_threaded(struct net_device *dev, bool threaded);
> > > > > +
> > > > >  /**
> > > > >   *     napi_disable - prevent NAPI from scheduling
> > > > >   *     @n: NAPI context
> > > > > diff --git a/net/core/dev.c b/net/core/dev.c
> > > > > index edcfec1361e9..d5fb95316ea8 100644
> > > > > --- a/net/core/dev.c
> > > > > +++ b/net/core/dev.c
> > > > > @@ -6754,6 +6754,34 @@ static int napi_set_threaded(struct napi_struct *n, bool threaded)
> > > > >         return err;
> > > > >  }
> > > > >
> > > > > +static void dev_disable_threaded_all(struct net_device *dev)
> > > > > +{
> > > > > +       struct napi_struct *napi;
> > > > > +
> > > > > +       list_for_each_entry(napi, &dev->napi_list, dev_list)
> > > > > +               napi_set_threaded(napi, false);
> > > > > +}
> > > > > +
> > > > > +int dev_set_threaded(struct net_device *dev, bool threaded)
> > > > > +{
> > > > > +       struct napi_struct *napi;
> > > > > +       int ret;
> > > > > +
> > > > > +       dev->threaded = threaded;
> > > > > +       list_for_each_entry(napi, &dev->napi_list, dev_list) {
> > > > > +               ret = napi_set_threaded(napi, threaded);
> > > > > +               if (ret) {
> > > > > +                       /* Error occurred on one of the napi,
> > > > > +                        * reset threaded mode on all napi.
> > > > > +                        */
> > > > > +                       dev_disable_threaded_all(dev);
> > > > > +                       break;
> > > > > +               }
> > > > > +       }
> > > > > +
> > > > > +       return ret;
> > > >
> > > > This doesn't seem right. The NAPI instances can be active while this
> > > > is occuring can they not? I would think at a minimum you need to go
> > > > through a napi_disable/napi_enable in order to toggle this value for
> > > > each NAPI instance. Otherwise aren't you at risk for racing and having
> > > > a napi_schedule attempt to wake up the thread before it has been
> > > > allocated?
> > >
> > >
> > > Yes. The napi instance could be active when this occurs. And I think
> > > it is OK. It is cause napi_set_threaded() only sets
> > > NAPI_STATE_THREADED bit after successfully created the kthread. And
> > > ___napi_schedule() only tries to wake up the kthread after testing the
> > > THREADED bit.
> >
> > But what do you have guaranteeing that the kthread has been written to
> > memory? That is what I was getting at. Just because you have written
> > the value doesn't mean it is in memory yet so you would probably need
> > an smb_mb__before_atomic() barrier call before you set the bit.
> >
> Noted. Will look into this.
>
> > Also I am not sure it is entirely safe to have the instance polling
> > while you are doing this. That is why I am thinking if the instance is
> > enabled then a napi_disable/napi_enable would be preferable.
> When the napi is actively being polled in threaded mode, we will keep
> rescheduling the kthread and calling __napi_poll() until
> NAPI_SCHED_STATE is cleared by napi_complete_done(). And during the
> next time napi_schedule() is called, we re-evaluate
> NAPI_STATE_THREADED bit to see if we should wake up kthread, or
> generate softirq.
> And for the other way around, if napi is being handled during
> net_rx_action(), toggling the bit won't cause immediate wake-up of the
> kthread, but will wait for NAPI_SCHED_STATE to be cleared, and the
> next time napi_schedule() is called.
> I think it is OK. WDYT?

It is hard to say. The one spot that gives me a bit of concern is the
NAPIF_STATE_MISSED case in napi_complete_done. It is essentially would
become a switchover point between the two while we are actively
polling inside the driver. You end up with NAPI_SCHED_STATE not being
toggled but jumping from one to the other.
