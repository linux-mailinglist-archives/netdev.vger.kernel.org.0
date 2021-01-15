Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60BDC2F8928
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 00:10:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727355AbhAOXIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 18:08:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726969AbhAOXIy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 18:08:54 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D74F3C061757
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 15:08:13 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id w18so21373841iot.0
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 15:08:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rB4yAyl4r+Xy6jOggpQTjEE0t73Vr2dPWLnGp8jj7X8=;
        b=A7mIeviJdNxVixhtglVj6gI2TZtxdWM5si3dUiT2g+pJZzYc9FeDqGzd+fkEj6PjOk
         Wzng67Sw/nVsQlS66XdiXfrytC04c4PHtA/Af1Jhxc/efbkEFVHDlmnufQ4X+eK7Sk3N
         hsoJaKLxymQgql/JI/hqNxWvD+4c0H79lhIV/PYaS4dPcgV0dshYmQM/9isQ+pgsBuSg
         ckJiD2cslan1//LDYtZKME6+HzFOwz9G1F6aCPz7difTA2pp+x1TSyC7spW3XxwGsDd/
         0DRhV/VIulxCCxKb2VkQsHH+HPwowOBWiRWJUYvSnyQ1/gNmDgXcKrKhegkuN7LFypxw
         NfvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rB4yAyl4r+Xy6jOggpQTjEE0t73Vr2dPWLnGp8jj7X8=;
        b=F2ACKUDd3//BJJqbdp4MJsPxsstapvckHI5F6ELdQT8nFV/7k3fvzJCVz5nTkyuTvu
         iUNSaomUaIJPA91tjj+He8slE8wf3tfWpwolb2qPia/9f7DtvyzR7eWPuzmgyGSUph/+
         fSShw/8MYGnJ5jM0MmBJUbJan4kdiSd0bUcDGKsOmnMX4cd5ybqNlbfLszcsf1BVkdxu
         mG0kf7KOiHTLf++skCmNw6wnn6f4PvS/lqSsJeGIL9JQZsUcUMTHw7/YYPSRA2n67hq5
         ApwAT483+goZMfadiTnhxGQapx1neX2fVR2gM5MnoVO9q8PiyoVM4s7113Bf6hVzXJEp
         pj9g==
X-Gm-Message-State: AOAM530+aZ42YCzzwZ1HhPayjG2nQGIIjCqDMz4LBl9iLwIH/Dd74tSM
        MTXMCCm+kinR6+GCKihovYE7ALzcV3yRnEr0qLtlxgb/FiM=
X-Google-Smtp-Source: ABdhPJxzQbiLXlOEj2jHarhCcRXVMBeO1xk0SM7iwEJBu4r2qa+yBTeXxqgIb0FNSEGCa/FFo6iD+XPCbuqodo83N7I=
X-Received: by 2002:a5d:9a82:: with SMTP id c2mr10229185iom.38.1610752093232;
 Fri, 15 Jan 2021 15:08:13 -0800 (PST)
MIME-Version: 1.0
References: <20210115003123.1254314-1-weiwan@google.com> <20210115003123.1254314-4-weiwan@google.com>
 <CAKgT0UdRK=KXT40nPmHbCeLixDkwdYEEFbwECnAKBFBjUsPOHQ@mail.gmail.com> <CAEA6p_DN+Cgo2bB6zBXC966g2PiSfOEifY0jR6QKU4mNrVmf2Q@mail.gmail.com>
In-Reply-To: <CAEA6p_DN+Cgo2bB6zBXC966g2PiSfOEifY0jR6QKU4mNrVmf2Q@mail.gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 15 Jan 2021 15:08:02 -0800
Message-ID: <CAKgT0UfgWY9dqOeyajjU7YAmDcAPQik5+4z7UoTB7GbDHUTGUw@mail.gmail.com>
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

On Fri, Jan 15, 2021 at 1:54 PM Wei Wang <weiwan@google.com> wrote:
>
> On Thu, Jan 14, 2021 at 7:34 PM Alexander Duyck
> <alexander.duyck@gmail.com> wrote:
> >
> > On Thu, Jan 14, 2021 at 4:34 PM Wei Wang <weiwan@google.com> wrote:
> > >
> > > This patch adds a new sysfs attribute to the network device class.
> > > Said attribute provides a per-device control to enable/disable the
> > > threaded mode for all the napi instances of the given network device.
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
> > >  net/core/dev.c            | 28 +++++++++++++++++
> > >  net/core/net-sysfs.c      | 63 +++++++++++++++++++++++++++++++++++++++
> > >  3 files changed, 93 insertions(+)
> > >
> > > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > > index c24ed232c746..11ae0c9b9350 100644
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
> > > index edcfec1361e9..d5fb95316ea8 100644
> > > --- a/net/core/dev.c
> > > +++ b/net/core/dev.c
> > > @@ -6754,6 +6754,34 @@ static int napi_set_threaded(struct napi_struct *n, bool threaded)
> > >         return err;
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
> >
> > This doesn't seem right. The NAPI instances can be active while this
> > is occuring can they not? I would think at a minimum you need to go
> > through a napi_disable/napi_enable in order to toggle this value for
> > each NAPI instance. Otherwise aren't you at risk for racing and having
> > a napi_schedule attempt to wake up the thread before it has been
> > allocated?
>
>
> Yes. The napi instance could be active when this occurs. And I think
> it is OK. It is cause napi_set_threaded() only sets
> NAPI_STATE_THREADED bit after successfully created the kthread. And
> ___napi_schedule() only tries to wake up the kthread after testing the
> THREADED bit.

But what do you have guaranteeing that the kthread has been written to
memory? That is what I was getting at. Just because you have written
the value doesn't mean it is in memory yet so you would probably need
an smb_mb__before_atomic() barrier call before you set the bit.

Also I am not sure it is entirely safe to have the instance polling
while you are doing this. That is why I am thinking if the instance is
enabled then a napi_disable/napi_enable would be preferable.
