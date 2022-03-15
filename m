Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E81D04D9F6E
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 16:57:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349879AbiCOP6r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 11:58:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241515AbiCOP6n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 11:58:43 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3064856220
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 08:57:31 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id l2so38156580ybe.8
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 08:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c46+0vx5nzhVH+eYceopkQZJH6tfWNEnblJgsWqX3g4=;
        b=eO38hKSR5t+SKc2jZBIYoVRMcsWFzyGldEn8UDkL71lAdV/r6iqCB2NNmH83RGsrK0
         MfN5LJax3voVxrbpZRXcfKMu0KlrN6kshGlbu8Jin9VbYBF765j9E47tSusrrI/AS8eS
         yMcsK5CkUkLxzkv44i1/EEtI4A8IvOn+UclZnS2JLjXAhU6+f6c3WoZGi9eEzAukguTM
         yFaB9N91dd+uab+jJWkYblvxkyxj6jZO+gNHqGBnU3IzTHgOt6tVD7QEccBdm4N+OFNd
         mYG0DeYdqmXoTpHhXXV0cAyzf4R+/DPUOucaxBqfBzDgih/EuQPPoxQJuedMwPE0DTbi
         ZW+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c46+0vx5nzhVH+eYceopkQZJH6tfWNEnblJgsWqX3g4=;
        b=oDpom2+q6qfXcnI8DCq0o1iJ6N9UEj7v0AmWcTOvMmRFNcl+bBbwc5mhfknHrSxpNp
         0f4zb2r7pNhaVkPoghCUGOw4XMV8l44dJPAn1iLoo0N+OsyLGhCKBxdXB+cDmKYVCdoR
         hQqlNql5pqdNppj7XZyz41tYN2qnhJJQgbsWFroSmddy6Q36pnonYb4uIFYRrvZvQASi
         H1QVQ3lvAOmrVFgNjRQdddCU9x8/cEGxHUjXl7hZ2/xtpXDqPmhQjuqOm2df7ayKCi4/
         d6MAXGKAvgFxaJH7aKIh5WuzQa0IrgTlgqaeeyIu/GNXz9onB1ENgx3mmQ7RDtuB8YEb
         MeIA==
X-Gm-Message-State: AOAM533t7Wsc0PZyxgSoExZ/VMFZT2p3AxfOnC2uiWdGrSN359deINWB
        2JkkykOsJyQ5LIbmwW4Y9U4aFcyHSvJXkM71tMJs0Q==
X-Google-Smtp-Source: ABdhPJx2MBVxLt7nuBCutQSG4eOh5PM9LDIoEStd2TcJcol8LxuHcAMMz/wQFRtEbJqn5RSiYFbliqkKXoCaHZjdpGA=
X-Received: by 2002:a25:d9c7:0:b0:628:be42:b671 with SMTP id
 q190-20020a25d9c7000000b00628be42b671mr23726721ybg.387.1647359850046; Tue, 15
 Mar 2022 08:57:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220310054703.849899-1-eric.dumazet@gmail.com>
 <20220310054703.849899-3-eric.dumazet@gmail.com> <52affdb45efe4d08b0ae13ba69097e712182af3e.camel@gmail.com>
In-Reply-To: <52affdb45efe4d08b0ae13ba69097e712182af3e.camel@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 15 Mar 2022 08:57:18 -0700
Message-ID: <CANn89iLXnt+xav7RaEm=8zuaLpOwO1xwnQtCiqN36iSV36Fk9g@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 02/14] ipv6: add dev->gso_ipv6_max_size
To:     Alexander H Duyck <alexander.duyck@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 11, 2022 at 8:22 AM Alexander H Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Wed, 2022-03-09 at 21:46 -0800, Eric Dumazet wrote:
> > From: Coco Li <lixiaoyan@google.com>
> >
> > This enable TCP stack to build TSO packets bigger than
> > 64KB if the driver is LSOv2 compatible.
> >
> > This patch introduces new variable gso_ipv6_max_size
> > that is modifiable through ip link.
> >
> > ip link set dev eth0 gso_ipv6_max_size 185000
> >
> > User input is capped by driver limit (tso_ipv6_max_size)
> > added in previous patch.
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
> > index 61db67222c47664c179b6a5d3b6f15fdf8a02bdd..9ed348d8b6f1195514c3b5f85fbe2c45b3fa997f 100644
> > --- a/include/linux/netdevice.h
> > +++ b/include/linux/netdevice.h
> > @@ -1952,6 +1952,7 @@ enum netdev_ml_priv_type {
> >   *                                   registered
> >   *   @offload_xstats_l3:     L3 HW stats for this netdevice.
> >   *   @tso_ipv6_max_size:     Maximum size of IPv6 TSO packets (driver/NIC limit)
> > + *   @gso_ipv6_max_size:     Maximum size of IPv6 GSO packets (user/admin limit)
> >   *
> >   *   FIXME: cleanup struct net_device such that network protocol info
> >   *   moves out.
> > @@ -2291,6 +2292,7 @@ struct net_device {
> >       netdevice_tracker       dev_registered_tracker;
> >       struct rtnl_hw_stats64  *offload_xstats_l3;
> >       unsigned int            tso_ipv6_max_size;
> > +     unsigned int            gso_ipv6_max_size;
> >  };
> >  #define to_net_dev(d) container_of(d, struct net_device, dev)
> >
>
> Rather than have this as a device specific value would it be
> advantageous to consider making this a namespace specific sysctl value
> instead? Something along the lines of:
>   net.ipv6.conf.*.max_jumbogram_size
>
> It could also be applied generically to the GSO/GRO as the upper limit
> for any frame assembled by the socket or GRO.
>
> The general idea is that might be desirable for admins to be able to
> basically just set the maximum size they want to see for IPv6 frames
> and if we could combine the GRO/GSO logic into a single sysctl that
> could be set on a namespace basis instead of a device basis which would
> be more difficult to track down. We already have the per-device limits
> in the tso_ipv6_max_size for the outgoing frames so it seems like it
> might make sense to make this per network namespace and defaultable
> rather than per device and requiring an update for each device
> instance.
>

At least Google found it was easier to have per device controls, in
terms of testing the feature,
and gradually deploying it.

We have hosts with multiple NIC, of different types. We want to be
able to control BIG TCP on a per device basis.
For instance I had a bug in one of the implementation for one (non
upstream) driver, that I could mitigate
by setting a different limit only for this NIC, until the host can
boot with a fixed kernel.

We use ipvlan, with one private net-ns and IPv6 address per job, we
wanted to deploy BIG TCP on a per job basis

I guess that if you want to add a sysctl, automatically overriding the
per device setting, this could be done later ?
