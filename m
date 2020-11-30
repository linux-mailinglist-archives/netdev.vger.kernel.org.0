Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 501E32C8DFE
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 20:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388327AbgK3TXF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 14:23:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388313AbgK3TW7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 14:22:59 -0500
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5533BC0613D3
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 11:22:14 -0800 (PST)
Received: by mail-il1-x141.google.com with SMTP id t13so12448732ilp.2
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 11:22:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wzGsLUDuufUclEwTEsf9UpqIka7HEUPZOpG/lm/X4VA=;
        b=PIDQWuA1cecSHaKj6Ts7vpkvSv1AIwccDTiyvNAbCFpex7OZq0PHXOmU7I1WtegEEg
         L2LOIR8t/zAAzNkiJ+43ceKaJsb3ed3LOKd5pYjiWFSOu4ThWIgIdWCnxhZTXnRU0brH
         aAQn726Q0tBIDOCaw4YiWQK40oc/iphLxK0WA3vvOHonRVMLP2V5mxaQ78pkwJ2CNEKo
         1gL28ZWJuHsJ8vA3quAAvHbiRLgfNPpMfIZUIPUwgR56Dxp9n2AbG/6+iq7Lb7EZkxFz
         znIzg9XxXsBRgvfDQjoEDsEx106cxkNmcjST5ivtBlk+iIWzr6r4hz1TiB3mUxRDWZrX
         KHRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wzGsLUDuufUclEwTEsf9UpqIka7HEUPZOpG/lm/X4VA=;
        b=A9OGWOBKg8abtQaRn7CBRYY+pdlFntYQINs8xSTR2c0mrt9nRUlyJslFbU97I/UDkx
         kt2GwWTtGMCmJuY0133YIYFxRqfMTFgaQxdo/ZKrdPR4EJ1T/UrKy1qMhL8tJkJ0e/yd
         Xmc+Y1Hm9aniIME0G80CBwIGzKiXuBnQ8ZhM1B1asNdaIydi5Ry/VmCRG1ARG+Pu9dWR
         hPkPooo+4hwoZ4gI0ukPLb/P+HB7nRpF1UzG86bXZ1Sh9XASey/zTaR+4K3oNLYlHzqf
         MMRzvT14frlCl31LDfKNcEGM5d1nt7sTMWGI49Pcejf7MQTHiJrPWEsBpTPpt1DUdDR6
         Rz5g==
X-Gm-Message-State: AOAM533rtp8TW7bd4xRlrsC51Uv3wJEsq1lUGklXzJB1PdLrjsXovsT7
        2jT/7OeuZtU+8J36nIz/aJmPVt2PTAzJnBs9kjvypQ==
X-Google-Smtp-Source: ABdhPJy65Gsrn7FuaFFSCPadxJR+m5p3/Hb/WXTLa288H0ZtvQuo7ICsJ/dQ5y6BL61dLFLXkR/twhLgQcYcE3k6ROg=
X-Received: by 2002:a92:d80e:: with SMTP id y14mr19604845ilm.68.1606764133472;
 Mon, 30 Nov 2020 11:22:13 -0800 (PST)
MIME-Version: 1.0
References: <20201129182435.jgqfjbekqmmtaief@skbuf> <20201129205817.hti2l4hm2fbp2iwy@skbuf>
 <20201129211230.4d704931@hermes.local> <CANn89iKyyCwiKHFvQMqmeAbaR9SzwsCsko49FP+4NBW6+ZXN4w@mail.gmail.com>
 <20201130101405.73901b17@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <20201130184828.x56bwxxiwydsxt3k@skbuf> <b8136636-b729-a045-6266-6e93ba4b83f4@gmail.com>
 <20201130190348.ayg7yn5fieyr4ksy@skbuf>
In-Reply-To: <20201130190348.ayg7yn5fieyr4ksy@skbuf>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 30 Nov 2020 20:22:01 +0100
Message-ID: <CANn89i+DYN4j2+MGK3Sh0=YAqmCyw0arcpm2bGO3qVFkzU_B4g@mail.gmail.com>
Subject: Re: Correct usage of dev_base_lock in 2020
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev <netdev@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jiri Benc <jbenc@redhat.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 30, 2020 at 8:03 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Mon, Nov 30, 2020 at 08:00:40PM +0100, Eric Dumazet wrote:
> >
> >
> > On 11/30/20 7:48 PM, Vladimir Oltean wrote:
> > > On Mon, Nov 30, 2020 at 10:14:05AM -0800, Jakub Kicinski wrote:
> > >> On Mon, 30 Nov 2020 11:41:10 +0100 Eric Dumazet wrote:
> > >>>> So dev_base_lock dates back to the Big Kernel Lock breakup back in Linux 2.4
> > >>>> (ie before my time). The time has come to get rid of it.
> > >>>>
> > >>>> The use is sysfs is because could be changed to RCU. There have been issues
> > >>>> in the past with sysfs causing lock inversions with the rtnl mutex, that
> > >>>> is why you will see some trylock code there.
> > >>>>
> > >>>> My guess is that dev_base_lock readers exist only because no one bothered to do
> > >>>> the RCU conversion.
> > >>>
> > >>> I think we did, a long time ago.
> > >>>
> > >>> We took care of all ' fast paths' already.
> > >>>
> > >>> Not sure what is needed, current situation does not bother me at all ;)
> > >>
> > >> Perhaps Vladimir has a plan to post separately about it (in that case
> > >> sorry for jumping ahead) but the initial problem was procfs which is
> > >> (hopefully mostly irrelevant by now, and) taking the RCU lock only
> > >> therefore forcing drivers to have re-entrant, non-sleeping
> > >> .ndo_get_stats64 implementations.
> > >
> > > Right, the end reason why I'm even looking at this is because I want to
> > > convert all callers of dev_get_stats to use sleepable context and not
> > > atomic. This makes it easier to gather statistics from devices that have
> > > a firmware, or off-chip devices behind a slow bus like SPI.
> > >
> > > Like Jakub pointed out, some places call dev_get_stats while iterating
> > > through the list of network interfaces - one would be procfs, but not
> > > only. These callers are pure readers, so they use RCU protection. But
> > > that gives us atomic context when calling dev_get_stats. The naive
> > > solution is to convert all those callers to hold the RTNL mutex, which
> > > is the writer-side protection for the network interface lists, and which
> > > is sleepable. In fact I do have a series of 8 patches where I get that
> > > done. But there are some weirder cases, such as the bonding driver,
> > > where I need to do this:
> > >
> > > -----------------------------[cut here]-----------------------------
> > > From 369a0e18a2446cda8ff52d72c02aa144ae6687ec Mon Sep 17 00:00:00 2001
> > > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > > Date: Mon, 30 Nov 2020 02:39:46 +0200
> > > Subject: [PATCH] net: bonding: retrieve device statistics under RTNL, not RCU
> > >
> > > In the effort of making .ndo_get_stats64 be able to sleep, we need to
> > > ensure the callers of dev_get_stats do not use atomic context.
> > >
> > > The bonding driver uses an RCU read-side critical section to ensure the
> > > integrity of the list of network interfaces, because the driver iterates
> > > through all net devices in the netns to find the ones which are its
> > > configured slaves. We still need some protection against an interface
> > > registering or deregistering, and the writer-side lock, the RTNL mutex,
> > > is fine for that, because it offers sleepable context.
> > >
> > > We are taking the RTNL this way (checking for rtnl_is_locked first)
> > > because the RTNL is not guaranteed to be held by all callers of
> > > ndo_get_stats64, in fact there will be work in the future that will
> > > avoid as much RTNL-holding as possible.
> > >
> > > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > > ---
> > >  drivers/net/bonding/bond_main.c | 18 +++++++-----------
> > >  include/net/bonding.h           |  1 -
> > >  2 files changed, 7 insertions(+), 12 deletions(-)
> > >
> > > diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> > > index e0880a3840d7..1d44534e95d2 100644
> > > --- a/drivers/net/bonding/bond_main.c
> > > +++ b/drivers/net/bonding/bond_main.c
> > > @@ -3738,21 +3738,17 @@ static void bond_get_stats(struct net_device *bond_dev,
> > >                        struct rtnl_link_stats64 *stats)
> > >  {
> > >     struct bonding *bond = netdev_priv(bond_dev);
> > > +   bool rtnl_locked = rtnl_is_locked();
> > >     struct rtnl_link_stats64 temp;
> > >     struct list_head *iter;
> > >     struct slave *slave;
> > > -   int nest_level = 0;
> > >
> > > +   if (!rtnl_locked)
> > > +           rtnl_lock();
> >
> > Gosh, do not do that.
> >
> > Convert the bonding ->stats_lock to a mutex instead.
> >
> > Adding more reliance to RTNL is not helping cases where
> > access to stats should not be blocked by other users of RTNL (which can be abused)
>
> I can't, Eric. The bond_for_each_slave() macro needs protection against
> net devices being registered and unregistered.

And ?

A bonding device can absolutely maintain a private list, ready for
bonding ndo_get_stats() use, regardless
of register/unregister logic.

bond_for_each_slave() is simply a macro, you can replace it by something else.
