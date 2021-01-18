Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19F9C2FAACA
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 21:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437724AbhART7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 14:59:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437712AbhART7V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 14:59:21 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95252C061573
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 11:58:41 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id k132so6631701ybf.2
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 11:58:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GjS5nG46nisW4bTD0gQB7WSJfLGWTIi4Eh/jI13XptI=;
        b=GXcu69gXPdotfA0qBkpkeH0idYkQrWxozzLdQFcVg9FNBKO9V0IUd5CseMuAcYO/fv
         HbWJjifrpXjO8xg4MnCLhQ+7UIBCJ2587/y5Uxkl1FubqanRvey0pX4TIdi4zCMv0W6U
         xkTVLUKQ2lmBdsgK7AakQUcFGY+sRVnlGicCYZkU5+/Q5wF2aQ5Ng5zHyRPxrjt+dh7f
         A9fG5iI6j40WI6Fg1zcd3ROY0pGuAU+MpeF44AyhCiDiUwsX+44RfBVE4qYNnSwJBdtz
         HoYpRfmOw8lQO48kmXVqfTbjzUjp5b+7gCdino1i3HwIAkLw1QpkQPtEyPD0aUwtD61f
         TFkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GjS5nG46nisW4bTD0gQB7WSJfLGWTIi4Eh/jI13XptI=;
        b=YaLf64V9q5lo+UB/kxSFem2h7+wVzFUI9/UHidgvWkk56wLAbCrVD52UwBqQHXm3O7
         lvS3nbNQP6Z/wOc6WQyrVXIacjmWNZwb6nEUmXX57WsBAZv7NzlDhQDST1o42ksN8M0r
         JKfLEmM8YMlnM0/dlN3R8CVRsJgODCVpuU/b484iUwnLot3jaNKTLjYBfB+zsRtUpC9b
         6TMkIPT/U5BBBp0Rwv1ACam4bSeJaMy48PGpa8A13NGXltqxGxahLW5lxPqg9XW+bWuD
         jhCTRjC+Cn3e2yx4ZRiBuGM8UPcAHqqZxgeMMOh68LPF0Ka6Vthsd8LbNFeXTk4+ySaI
         BAfw==
X-Gm-Message-State: AOAM531hyHVV1hPtrvvxf/0uJv9ijqyOb0RYHqUZ2tisigF5wN/eMiD9
        g15oPHWwQA7gT4BTqQqqGH9OJDegjkn5jHiARYbcOw==
X-Google-Smtp-Source: ABdhPJwpy4EyMzPlFlRy9FgLfYLQjrH/B+IhLf8S8TC1Rkiwm78P2c8GdjLs9ls33NI2/9TpKXsA/Aq1j8otswyOlCY=
X-Received: by 2002:a25:99c6:: with SMTP id q6mr1119056ybo.408.1610999920614;
 Mon, 18 Jan 2021 11:58:40 -0800 (PST)
MIME-Version: 1.0
References: <20210115003123.1254314-1-weiwan@google.com> <20210115003123.1254314-4-weiwan@google.com>
 <CAKgT0UdRK=KXT40nPmHbCeLixDkwdYEEFbwECnAKBFBjUsPOHQ@mail.gmail.com>
 <CAEA6p_DN+Cgo2bB6zBXC966g2PiSfOEifY0jR6QKU4mNrVmf2Q@mail.gmail.com>
 <CAKgT0UfgWY9dqOeyajjU7YAmDcAPQik5+4z7UoTB7GbDHUTGUw@mail.gmail.com>
 <CAEA6p_CH3-ppNAEV4HR845ZCnXBH3U=S+=N=OwVtE6uiH0VKNA@mail.gmail.com> <CAKgT0UfCVRZz++sTXHKSXvzCTBWGoEoBKC10OasXYiLNq4pCgQ@mail.gmail.com>
In-Reply-To: <CAKgT0UfCVRZz++sTXHKSXvzCTBWGoEoBKC10OasXYiLNq4pCgQ@mail.gmail.com>
From:   Wei Wang <weiwan@google.com>
Date:   Mon, 18 Jan 2021 11:58:29 -0800
Message-ID: <CAEA6p_DcMsVqr9yacK-HYnS9trK7wKBTGFYEMyqG4vgC2k-H=w@mail.gmail.com>
Subject: Re: [PATCH net-next v6 3/3] net: add sysfs attribute to control napi
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

On Fri, Jan 15, 2021 at 6:18 PM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Fri, Jan 15, 2021 at 4:44 PM Wei Wang <weiwan@google.com> wrote:
> >
> > On Fri, Jan 15, 2021 at 3:08 PM Alexander Duyck
> > <alexander.duyck@gmail.com> wrote:
> > >
> > > On Fri, Jan 15, 2021 at 1:54 PM Wei Wang <weiwan@google.com> wrote:
> > > >
> > > > On Thu, Jan 14, 2021 at 7:34 PM Alexander Duyck
> > > > <alexander.duyck@gmail.com> wrote:
> > > > >
> > > > > On Thu, Jan 14, 2021 at 4:34 PM Wei Wang <weiwan@google.com> wrote:
> > > > > >
> > > > > > This patch adds a new sysfs attribute to the network device class.
> > > > > > Said attribute provides a per-device control to enable/disable the
> > > > > > threaded mode for all the napi instances of the given network device.
> > > > > >
> > > > > > Co-developed-by: Paolo Abeni <pabeni@redhat.com>
> > > > > > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > > > > > Co-developed-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
> > > > > > Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
> > > > > > Co-developed-by: Felix Fietkau <nbd@nbd.name>
> > > > > > Signed-off-by: Felix Fietkau <nbd@nbd.name>
> > > > > > Signed-off-by: Wei Wang <weiwan@google.com>
> > > > > > ---
> > > > > >  include/linux/netdevice.h |  2 ++
> > > > > >  net/core/dev.c            | 28 +++++++++++++++++
> > > > > >  net/core/net-sysfs.c      | 63 +++++++++++++++++++++++++++++++++++++++
> > > > > >  3 files changed, 93 insertions(+)
> > > > > >
> > > > > > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > > > > > index c24ed232c746..11ae0c9b9350 100644
> > > > > > --- a/include/linux/netdevice.h
> > > > > > +++ b/include/linux/netdevice.h
> > > > > > @@ -497,6 +497,8 @@ static inline bool napi_complete(struct napi_struct *n)
> > > > > >         return napi_complete_done(n, 0);
> > > > > >  }
> > > > > >
> > > > > > +int dev_set_threaded(struct net_device *dev, bool threaded);
> > > > > > +
> > > > > >  /**
> > > > > >   *     napi_disable - prevent NAPI from scheduling
> > > > > >   *     @n: NAPI context
> > > > > > diff --git a/net/core/dev.c b/net/core/dev.c
> > > > > > index edcfec1361e9..d5fb95316ea8 100644
> > > > > > --- a/net/core/dev.c
> > > > > > +++ b/net/core/dev.c
> > > > > > @@ -6754,6 +6754,34 @@ static int napi_set_threaded(struct napi_struct *n, bool threaded)
> > > > > >         return err;
> > > > > >  }
> > > > > >
> > > > > > +static void dev_disable_threaded_all(struct net_device *dev)
> > > > > > +{
> > > > > > +       struct napi_struct *napi;
> > > > > > +
> > > > > > +       list_for_each_entry(napi, &dev->napi_list, dev_list)
> > > > > > +               napi_set_threaded(napi, false);
> > > > > > +}
> > > > > > +
> > > > > > +int dev_set_threaded(struct net_device *dev, bool threaded)
> > > > > > +{
> > > > > > +       struct napi_struct *napi;
> > > > > > +       int ret;
> > > > > > +
> > > > > > +       dev->threaded = threaded;
> > > > > > +       list_for_each_entry(napi, &dev->napi_list, dev_list) {
> > > > > > +               ret = napi_set_threaded(napi, threaded);
> > > > > > +               if (ret) {
> > > > > > +                       /* Error occurred on one of the napi,
> > > > > > +                        * reset threaded mode on all napi.
> > > > > > +                        */
> > > > > > +                       dev_disable_threaded_all(dev);
> > > > > > +                       break;
> > > > > > +               }
> > > > > > +       }
> > > > > > +
> > > > > > +       return ret;
> > > > >
> > > > > This doesn't seem right. The NAPI instances can be active while this
> > > > > is occuring can they not? I would think at a minimum you need to go
> > > > > through a napi_disable/napi_enable in order to toggle this value for
> > > > > each NAPI instance. Otherwise aren't you at risk for racing and having
> > > > > a napi_schedule attempt to wake up the thread before it has been
> > > > > allocated?
> > > >
> > > >
> > > > Yes. The napi instance could be active when this occurs. And I think
> > > > it is OK. It is cause napi_set_threaded() only sets
> > > > NAPI_STATE_THREADED bit after successfully created the kthread. And
> > > > ___napi_schedule() only tries to wake up the kthread after testing the
> > > > THREADED bit.
> > >
> > > But what do you have guaranteeing that the kthread has been written to
> > > memory? That is what I was getting at. Just because you have written
> > > the value doesn't mean it is in memory yet so you would probably need
> > > an smb_mb__before_atomic() barrier call before you set the bit.
> > >
> > Noted. Will look into this.
> >
> > > Also I am not sure it is entirely safe to have the instance polling
> > > while you are doing this. That is why I am thinking if the instance is
> > > enabled then a napi_disable/napi_enable would be preferable.
> > When the napi is actively being polled in threaded mode, we will keep
> > rescheduling the kthread and calling __napi_poll() until
> > NAPI_SCHED_STATE is cleared by napi_complete_done(). And during the
> > next time napi_schedule() is called, we re-evaluate
> > NAPI_STATE_THREADED bit to see if we should wake up kthread, or
> > generate softirq.
> > And for the other way around, if napi is being handled during
> > net_rx_action(), toggling the bit won't cause immediate wake-up of the
> > kthread, but will wait for NAPI_SCHED_STATE to be cleared, and the
> > next time napi_schedule() is called.
> > I think it is OK. WDYT?
>
> It is hard to say. The one spot that gives me a bit of concern is the
> NAPIF_STATE_MISSED case in napi_complete_done. It is essentially would
> become a switchover point between the two while we are actively
> polling inside the driver. You end up with NAPI_SCHED_STATE not being
> toggled but jumping from one to the other.

Hmm.. Right. That is the one case where NAPI_SCHED_STATE will not be
toggled, but could potentially change the processing mode.
But still, I don't see any race in this case. The napi instance will
still either be processed in softirq mode by net_rx_action(), or in
the kthread mode, after napi_complete_done() calls __napi_schedule().
