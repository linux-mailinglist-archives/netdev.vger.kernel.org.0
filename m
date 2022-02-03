Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2C64A87B8
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 16:34:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351874AbiBCPeW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 10:34:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233431AbiBCPeV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 10:34:21 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AD56C061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 07:34:21 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id k31so10133569ybj.4
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 07:34:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VxfVFMS94lD6zTTVS9qwhDXK9wUQWVtkvYSa7FlPbIM=;
        b=WDHfehPIeqhMmn+2n7eUpvcLuN7CwaE0mftjTzN8/vSm3LpytOgFbBDZHRg13hstq3
         SXzRE+tqtSbr8R4OgF59QmVFEvP5dO+mjzUbBmK5FUuwkpnynjUNUBFUcC83sG00a17b
         npS43YclLV5+O6ibxmdIQX1MYsUEG7ysq6TUnolcRjomf5EWWuvWmfsCxFjOrQc6UAHd
         ZWuVrYemsPc5bpx+kw0nzeNauirqSCcib0JYcNZwkfth4DYNn6c62ywZo0HXUTiA+XjO
         XiJ5vf3iBx37usRIL35Ipyqv4VBsGkonHYBEmO7y59619z4X0TuRs+AxILVcacwesp/O
         0jCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VxfVFMS94lD6zTTVS9qwhDXK9wUQWVtkvYSa7FlPbIM=;
        b=Wb9o2RAb6+StascoJTM2LnVHE9TBopSB7LRGNDo4a0Ij8KUUsloKioBB7WlhHrJnrJ
         BvAEMk0tkK3gyDJCptITcTa+h1itGwl1jINm0+QxfJmCRlWK6/ujguufSuuKIdfvpOYi
         lmTE5uxzwiYooDYLxUlC7ONblQXqikl2amW3TZJYRsrmv2KL2fgberoWL7dv+zMeW4dn
         KVle7doTs4W55rKLr/QtUuUr3oL7M9IU4+5gV8Kq1zVo/gSkPxaTfZMXssODIIWN6fIB
         ERxaVOdizo4Aln2uLQ/GT17qjMTiM82+YKJxsSFxhT2T676BfwFaUXhe3x0faK7Dzo8/
         qW/w==
X-Gm-Message-State: AOAM530xe16/ouMn7uEir8tppDhBk9qBLkeyhY17ViVuLTkIC10FSFvh
        WIjjK311ImCSMMqb9MV9OQOGZUXVN7IzsChF8VTTIG3x8Jv1qIrRuaw=
X-Google-Smtp-Source: ABdhPJxaNFQ1AOWd+GthgoJM8qcPXm4tAPDNKWVYWXN3xX8OvJbhM6tbJ/gLQjCQ96q3YVOcz7XWfSnEYc2teI9S+NI=
X-Received: by 2002:a25:d9c2:: with SMTP id q185mr45447765ybg.293.1643902459845;
 Thu, 03 Feb 2022 07:34:19 -0800 (PST)
MIME-Version: 1.0
References: <20220203015140.3022854-1-eric.dumazet@gmail.com>
 <20220203015140.3022854-3-eric.dumazet@gmail.com> <90c19324a093536f1e0e2e3de3a36df4207a28d3.camel@redhat.com>
In-Reply-To: <90c19324a093536f1e0e2e3de3a36df4207a28d3.camel@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 3 Feb 2022 07:34:08 -0800
Message-ID: <CANn89i+-R11duRgVHoi=sJRJQ3FUVf-oruOzLbjpKAXaatK41A@mail.gmail.com>
Subject: Re: [PATCH net-next 02/15] ipv6: add dev->gso_ipv6_max_size
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 3, 2022 at 12:57 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> Hello,
>
> On Wed, 2022-02-02 at 17:51 -0800, Eric Dumazet wrote:
> > From: Eric Dumazet <edumazet@google.com>
> >
> > This enable TCP stack to build TSO packets bigger than
> > 64KB if the driver is LSOv2 compatible.
> >
> > This patch introduces new variable gso_ipv6_max_size
> > that is modifiable through ip link.
> >
> > ip link set dev eth0 gso_ipv6_max_size 185000
> >
> > User input is capped by driver limit.
> >
> > Signed-off-by: Coco Li <lixiaoyan@google.com>
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > ---
> >  include/linux/netdevice.h          | 12 ++++++++++++
> >  include/uapi/linux/if_link.h       |  1 +
> >  net/core/dev.c                     |  1 +
> >  net/core/rtnetlink.c               | 15 +++++++++++++++
> >  net/core/sock.c                    |  6 ++++++
> >  tools/include/uapi/linux/if_link.h |  1 +
> >  6 files changed, 36 insertions(+)
> >
> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > index b1f68df2b37bc4b623f61cc2c6f0c02ba2afbe02..2a563869ba44f7d48095d36b1395e3fbd8cfff87 100644
> > --- a/include/linux/netdevice.h
> > +++ b/include/linux/netdevice.h
> > @@ -1949,6 +1949,7 @@ enum netdev_ml_priv_type {
> >   *   @linkwatch_dev_tracker: refcount tracker used by linkwatch.
> >   *   @watchdog_dev_tracker:  refcount tracker used by watchdog.
> >   *   @tso_ipv6_max_size:     Maximum size of IPv6 TSO packets (driver/NIC limit)
> > + *   @gso_ipv6_max_size:     Maximum size of IPv6 GSO packets (user/admin limit)
> >   *
> >   *   FIXME: cleanup struct net_device such that network protocol info
> >   *   moves out.
> > @@ -2284,6 +2285,7 @@ struct net_device {
> >       netdevice_tracker       linkwatch_dev_tracker;
> >       netdevice_tracker       watchdog_dev_tracker;
> >       unsigned int            tso_ipv6_max_size;
> > +     unsigned int            gso_ipv6_max_size;
> >  };
> >  #define to_net_dev(d) container_of(d, struct net_device, dev)
> >
> > @@ -4804,6 +4806,10 @@ static inline void netif_set_gso_max_size(struct net_device *dev,
> >  {
> >       /* dev->gso_max_size is read locklessly from sk_setup_caps() */
> >       WRITE_ONCE(dev->gso_max_size, size);
> > +
> > +     /* legacy drivers want to lower gso_max_size, regardless of family. */
> > +     size = min(size, dev->gso_ipv6_max_size);
> > +     WRITE_ONCE(dev->gso_ipv6_max_size, size);
> >  }
> >
> >  static inline void netif_set_gso_max_segs(struct net_device *dev,
> > @@ -4827,6 +4833,12 @@ static inline void netif_set_tso_ipv6_max_size(struct net_device *dev,
> >       dev->tso_ipv6_max_size = size;
> >  }
> >
> > +static inline void netif_set_gso_ipv6_max_size(struct net_device *dev,
> > +                                            unsigned int size)
> > +{
> > +     size = min(size, dev->tso_ipv6_max_size);
> > +     WRITE_ONCE(dev->gso_ipv6_max_size, size);
>
> Dumb questions on my side: should the above be limited to
> tso_ipv6_max_size ? or increasing gso_ipv6_max_size helps even if the
> egress NIC does not support LSOv2?

I thought that " size = min(size, dev->tso_ipv6_max_size);" was doing
exactly that ?

I  will fix the From: tag because patch autor is Coco Li

>
> Should gso_ipv6_max_size be capped to some reasonable value (well lower
> than 4G), to avoid the stack building very complex skbs?
>

Drivers are responsible for choosing the max value, then admins choose
optimal operational values based on their constraints (like device MTU)

Typical LSOv2 values are 256K or 512KB, but we really tested BIG TCP
with 45 4K segments per packet.

> Thanks!
>
> Paolo
>
