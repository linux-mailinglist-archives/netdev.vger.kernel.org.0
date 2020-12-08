Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBEF92D2FE2
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 17:40:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730437AbgLHQif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 11:38:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730234AbgLHQif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 11:38:35 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2329FC06179C
        for <netdev@vger.kernel.org>; Tue,  8 Dec 2020 08:37:55 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id g20so25503162ejb.1
        for <netdev@vger.kernel.org>; Tue, 08 Dec 2020 08:37:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=x+pCt6EQoSQxNsno5VMsYK/Heh0VeVUAmRA8j6XjBzk=;
        b=CYx944CmMifI7FwZRhDjfjHdSuUaTzRGDV4Tqu5RIh1IJYoLmjIJT4ieBvgUhTXdZp
         RgEXwfFGbgf4XWrttR3HdZDtJryNRku3B4pFvjzYum7ez+17JXkmveHJqT/WsLZVjVMo
         TnpDXMckUjaHcRoWtSSdcyj+QCmJm1/3ZosJTx8OsAZaXH6+bxXXZ+SYNQs6Qv4tuSP8
         WgcoaRDcda2t2sO+1lC5aK8JhfSAr5/O9jmLfLfgFSo1pbA95/y4V6dyrIUyRvncg8Jp
         9FZos/UFg53LiLUcBNuCwXpr1iQ8PJPCr+py2MZ8MHda9crw/wHi06t0tOaPmzDYRz9s
         Xd1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=x+pCt6EQoSQxNsno5VMsYK/Heh0VeVUAmRA8j6XjBzk=;
        b=Oy3ucnorv4GIITGc/hgrnhW+ujmb2Udam+WHbrADKy4p5DrhztRQoTvLCHVxHWmaJg
         e7cHMdo3BOrCdIxwZTqPEABB7XpohzillG99SM16cjyRsWWmec3BqleJTXwv0vZ7SPJI
         ZJm1alqAkWTdQLy4UmD7no/o2dfkpJnoN71ifbwWvqhk3581zQ32vIxTtDN2OuoE8xwI
         zoGbvWK6s91DTceWmQwtyOmMPIY3ryhPpBrMXpTgJlRlrRf4td4TbQQwQVp6vuzJ74Ua
         3D7f1/YBjbqfDMDXT9QuTb8fh5AbaldMAMGlrKCZLp/pPpB87IZolIqMlatnsVAlOHYa
         ssgA==
X-Gm-Message-State: AOAM532xCPIWJs3Cw64f7V/jUCxClmGk0F7YRvb1gArKKXRUfRiQXjAC
        IVk3IdiVlwmScXmsS+ksQ9U=
X-Google-Smtp-Source: ABdhPJz7Fcr7zhiEZOZkddlPNU2BoIdfae8MFjLcVjzOW9bb4v9jOM1F2um8TWnxxVkAxCBoWg6RSQ==
X-Received: by 2002:a17:906:b143:: with SMTP id bt3mr24094881ejb.318.1607445473731;
        Tue, 08 Dec 2020 08:37:53 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id i21sm17870799edt.92.2020.12.08.08.37.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 08:37:53 -0800 (PST)
Date:   Tue, 8 Dec 2020 18:37:51 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 2/4] net: dsa: Link aggregation support
Message-ID: <20201208163751.4c73gkdmy4byv3rp@skbuf>
References: <20201202091356.24075-1-tobias@waldekranz.com>
 <20201202091356.24075-3-tobias@waldekranz.com>
 <20201208112350.kuvlaxqto37igczk@skbuf>
 <87mtyo5n40.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87mtyo5n40.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 08, 2020 at 04:33:19PM +0100, Tobias Waldekranz wrote:
> On Tue, Dec 08, 2020 at 13:23, Vladimir Oltean <olteanv@gmail.com> wrote:
> > Sorry it took so long. I wanted to understand:
> > (a) where are the challenged for drivers to uniformly support software
> >     bridging when they already have code for bridge offloading. I found
> >     the following issues:
> >     - We have taggers that unconditionally set skb->offload_fwd_mark = 1,
> >       which kind of prevents software bridging. I'm not sure what the
> >       fix for these should be.
>
> At least on mv88e6xxx you would not be able to determine this simply
> from looking at the tag. Both in standalone mode and bridged mode, you
> would receive FORWARDs with the same source. You could look at
> dp->bridge_dev to figure it out though.

Yes, but that raises the question whether it should be DSA that fixes it
up globally for everyone, like in dsa_switch_rcv:

	if (!dp->bridge_dev)
		skb->offload_fwd_mark = 0;

with a nice comment above that everyone can refer to,
or make each and every tagger do this. I'm leaning towards the latter.

> >     - Source address is a big problem, but this time not in the sense
> >       that it traditionally has been. Specifically, due to address
> >       learning being enabled, the hardware FDB will set destinations to
> >       take the autonomous fast path. But surprise, the autonomous fast
> >       path is blocked, because as far as the switch is concerned, the
> >       ports are standalone and not offloading the bridge. We have drivers
> >       that don't disable address learning when they operate in standalone
> >       mode, which is something they definitely should do.
>
> Some hardware can function with it on (e.g. mv88e6xxx can associate an
> FDB per port), but there is no reason to do it, so yes it should be
> disabled.

So how does mv88e6xxx handle the address learning issue currently?

> >     There is nothing actionable for you in this patch set to resolve this.
> >     I just wanted to get an idea.
> > (b) Whether struct dsa_lag really brings us any significant benefit. I
> >     found that it doesn't. It's a lot of code added to the DSA core, that
> >     should not really belong in the middle layer. I need to go back and
> >     quote your motivation in the RFC:
> >
> > | All LAG configuration is cached in `struct dsa_lag`s. I realize that
> > | the standard M.O. of DSA is to read back information from hardware
> > | when required. With LAGs this becomes very tricky though. For example,
> > | the change of a link state on one switch will require re-balancing of
> > | LAG hash buckets on another one, which in turn depends on the total
> > | number of active links in the LAG. Do you agree that this is
> > | motivated?
> >
> >     After reimplementing bonding offload in ocelot, I have found
> >     struct dsa_lag to not provide any benefit. All the information a
> >     driver needs is already provided through the
> >     struct net_device *lag_dev argument given to lag_join and lag_leave,
> >     and through the struct netdev_lag_lower_state_info *info given to
> >     lag_change. I will send an RFC to you and the list shortly to prove
> >     that this information is absolutely sufficient for the driver to do
> >     decent internal bookkeeping, and that DSA should not really care
> >     beyond that.
>
> Do you have a multi-chip setup? If not then I understand that `struct
> dsa_lag` does not give you anything extra. In a multi-chip scenario
> things become harder. Example:
>
> .-----.   .-----.
> | sw0 +---+ sw1 |
> '-+-+-'3 3'--+--'
>   1 2        1
>
> Let's say that sw0p1, sw0p2 and sw1p1 are in a LAG. This system can hash
> flows into 8 buckets. So with all ports active you would need an
> allocation like this:
>
> sw0p1: 0,1,2
> sw0p2: 3,4,5
> sw1p1: 6,7
>
> For some reason, the system determines that sw0p2 is now inactive and
> the LAG should be rebalanced over the two remaining active links:
>
> sw0p1: 0,1,2,3
> sw0p2: -
> sw1p1: 4,5,6,7
>
> In order for sw0 and sw1 to agree on the assignment they need access to
> a shared view of the LAG at the tree level, both about the set of active
> ports and their ordering. This is `struct dsa_lag`s main raison d'être.

Yup, you could do that just like I did with ocelot, aka keep in
struct dsa_port:
	struct net_device *bond;
	bool lag_tx_active;

This is enough to replace your usage of:

	list_for_each_entry(dp, &lag->ports, lag_list) {
		...
	}

with:

	list_for_each_entry(dp, &dst->ports, list) {
		if (dp->bond != lag_dev)
			continue;

		...
	}

and:

	list_for_each_entry(dp, &lag->tx_ports, lag_tx_list) {
		...
	}

with:

	list_for_each_entry(dp, &dst->ports, list) {
		if (dp->bond != lag_dev || !dp->lag_tx_active)
			continue;

		...
	}

The amount of iteration that you would do would be about the same. Just
this:

	struct dsa_lag *lag = dsa_lag_by_dev(ds->dst, lag_dev);

would need to be replaced with something more precise, depending on what
you need the struct dsa_lag pointer for. You use it in crosschip_lag_join
and in crosschip_lag_leave to call mv88e6xxx_lag_sync_map, where you
again iterate over the ports in the DSA switch tree. But if you passed
just the struct net_device *lag_dev directly, you could keep the same
iteration and do away with the reference-counted struct dsa_lag.

> The same goes for when a port joins/leaves a LAG. For example, if sw1p1
> was to leave the LAG, we want to make sure that we do not needlessly
> flood LAG traffic over the backplane (sw0p3<->sw1p3). If you want to
> solve this at the ds level without `struct dsa_lag`, you need a refcount
> per backplane port in order to figure out if the leaving port was the
> last one behind that backplane port.

Humm, why?
Nothing would change. Just as you start with a map of 0 in
mv88e6xxx_lag_sync_map, and use dsa_towards_port for every dp that you
find in the switch tree, I am saying keep that iteration, but don't keep
those extra lists for the bonded ports and the active bonded ports. Just
use as a search key the LAG net device itself, and keep an extra bool
per dp. I think it's really simpler this way, with a lot less overhead
in terms of data structures, lists and whatnot.

> >     - Remember that the only reason why the DSA framework and the
> >       syntactic sugar exists is that we are presenting the hardware a
> >       unified view for the ports which have a struct net_device registered,
> >       and the ports which don't (DSA links and CPU ports). The argument
> >       really needs to be broken down into two:
> >       - For cross-chip DSA links, I can see why it was convenient for
> >         you to have the dsa_lag_by_dev(ds->dst, lag_dev) helper. But
> >         just as we currently have a struct net_device *bridge_dev in
> >         struct dsa_port, so we could have a struct net_device *bond,
> >         without the extra fat of struct dsa_lag, and reference counting,
> >         active ports, etc etc, would become simpler (actually inexistent
> >         as far as the DSA layer is concerned). Two ports are in the same
> >         bond if they have the same struct net_device *bond, just as they
> >         are bridged if they have the same struct net_device *bridge_dev.
> >       - For CPU ports, this raises an important question, which is
> >         whether LAG on switches with multiple CPU ports is ever going to
> >         be a thing. And if it is, how it is even going to be configured
> >         from the user's perspective. Because on a multi-CPU port system,
> >         you should actually see it as two bonding interfaces back to back.
> >         First, there's the bonding interface that spans the DSA masters.
> >         That needs no hardware offloading. Then there's the bonding
> >         interface that is the mirror image of that, and spans the CPU
> >         ports. I think this is a bit up in the air now. Because with
>
> Aside. On our devices we use the term cpu0, cpu1 etc. to refer to a
> switch port that is connected to a CPU. The CPU side of those
> connections are chan0, chan1 ("channel"). I am not saying we have to
> adopt those, but some unambiguous terms would be great in these
> conversations.

You have me confused. chan0, chan1 are DSA master interfaces? Can we
keep calling them DSA master interfaces, or do you find that confusing?

> >         your struct dsa_lag or without, we still have no bonding device
> >         associated with it, so things like the balancing policy are not
> >         really defined.
> >
>
> I have a different take on that. I do not think you need to create a
> user-visible LAG at all in that case. You just setup the hardware to
> treat the two CPU ports as a static LAG based on the information from
> the DT. Then you attach the same rx handler to both. On tx you hash and
> loadbalance on flows that allow it (FORWARDs on mv88e6xxx) and use the
> primary CPU port for control traffic (FROM_CPU).
>
> The CPU port is completely defined by the DT today, so I do not see why
> we could not add balancing policy to that if it is ever required.

Hashing policy for a bonding interface, defined in DT? Yummm.

> > I would like you to reiterate some of the reasons why you prefer having
> > struct dsa_lag.
>
> I hope I did that already. But I will add that if there was a dst->priv
> for the drivers to use as they see fit, I guess the bookkeeping could be
> moved into the mv88e6xxx driver instead if you feel it pollutes the DSA
> layer. Maybe you can not assume that all chips in a tree use a
> compatible driver though?

I don't think the DSA switch tree is private to anyone.

> Are there any other divers that support multi-chip that might want to
> use the same thing?

Nope.
