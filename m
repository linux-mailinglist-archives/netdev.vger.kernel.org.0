Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD9C62D3D9B
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 09:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727505AbgLIIiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 03:38:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726855AbgLIIiZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 03:38:25 -0500
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4387C0613D6
        for <netdev@vger.kernel.org>; Wed,  9 Dec 2020 00:37:44 -0800 (PST)
Received: by mail-lf1-x142.google.com with SMTP id u18so1960535lfd.9
        for <netdev@vger.kernel.org>; Wed, 09 Dec 2020 00:37:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version:content-transfer-encoding;
        bh=dHFT6/VqY0a+XbmKSwopDxpj/WMHqFaIQcBkbCZgZ7k=;
        b=XDVm1BtI8A1p1nfTuyNIzhwrVGJ1EpT4n793tYjaVHB9rNOrCw7O2PhDVJSI3FPA5b
         Pqgs0BKLxYiDUUqHGnqLMdYXY0/wU31VY1W5fzaiz/wIy2AAezFsazKWpTG3PJPLvAiO
         j+AAJDV6yLGiELnOvGfFOQdec+llpuWUGiRVJMQ85WeofY1yJ27eBHDUKY0+1aKGtJEC
         NEVxWjsBFWIzWFxmKiNLT2a9Rasx2qv7BAV+Rb3Q46jnv3CmrfIfkU/IeqczUagMgqPR
         sv5qRSMXx2DKUl8fXCwBr2kD28eiCLUsaLfFyI550QUAx0r2RyoF72d1nzXfe66CmtjJ
         uzow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=dHFT6/VqY0a+XbmKSwopDxpj/WMHqFaIQcBkbCZgZ7k=;
        b=uWbidHq0Cw97++y638jcrg5Blwbbqw0ZUJgaKMFxPLq/BE9olnYaz5ubgrDhbL7gho
         gLKv7zNqabJivjO+z8Uae/kvbIuawGXB9Ufvf1iGTqKhFg5EniRU7LYPPSBvLIVyb/l9
         0UR0uE5pGb+eab3eG96WwtckSRXUW83Lg0SDKk0wqrrpOad/5h6xribmSMTWbKsPjrqp
         ROk7iZDdb9TV9MsbJKFowG9Q6myRO4WwsGfAKLWjgwpj9ZMQNTIL0ojUi+tFJ6WLVbej
         7JIim3pmMXOjVMnqI5GUZCe73cpV2vb9g9LUFFHKnZzfMQ8hhfreb/LNYXpxM9IedfcT
         2zcA==
X-Gm-Message-State: AOAM530PdFCk6ekhLj+8FhWJglWS7d2eMwK+rSlrDhwyGgzm0Xs78uam
        TSUHIWqRF972w5ivOSmJBVuRcdVUUUYQH/sr
X-Google-Smtp-Source: ABdhPJxJD0UUOXTiHbNSvDcxEbBDmu+GbV6NC+JFwfL4NZG0WI3FNdUtcRj450EG0OwOW4lnSRkMcQ==
X-Received: by 2002:a05:6512:333c:: with SMTP id l28mr614668lfe.164.1607503061238;
        Wed, 09 Dec 2020 00:37:41 -0800 (PST)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id a22sm96326lfl.11.2020.12.09.00.37.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 00:37:40 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 2/4] net: dsa: Link aggregation support
In-Reply-To: <20201208163751.4c73gkdmy4byv3rp@skbuf>
References: <20201202091356.24075-1-tobias@waldekranz.com> <20201202091356.24075-3-tobias@waldekranz.com> <20201208112350.kuvlaxqto37igczk@skbuf> <87mtyo5n40.fsf@waldekranz.com> <20201208163751.4c73gkdmy4byv3rp@skbuf>
Date:   Wed, 09 Dec 2020 09:37:39 +0100
Message-ID: <87k0tr5q98.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 08, 2020 at 18:37, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Tue, Dec 08, 2020 at 04:33:19PM +0100, Tobias Waldekranz wrote:
>> On Tue, Dec 08, 2020 at 13:23, Vladimir Oltean <olteanv@gmail.com> wrote:
>> > Sorry it took so long. I wanted to understand:
>> > (a) where are the challenged for drivers to uniformly support software
>> >     bridging when they already have code for bridge offloading. I found
>> >     the following issues:
>> >     - We have taggers that unconditionally set skb->offload_fwd_mark =
=3D 1,
>> >       which kind of prevents software bridging. I'm not sure what the
>> >       fix for these should be.
>>
>> At least on mv88e6xxx you would not be able to determine this simply
>> from looking at the tag. Both in standalone mode and bridged mode, you
>> would receive FORWARDs with the same source. You could look at
>> dp->bridge_dev to figure it out though.
>
> Yes, but that raises the question whether it should be DSA that fixes it
> up globally for everyone, like in dsa_switch_rcv:
>
> 	if (!dp->bridge_dev)
> 		skb->offload_fwd_mark =3D 0;
>
> with a nice comment above that everyone can refer to,
> or make each and every tagger do this. I'm leaning towards the latter.

I agree, I think each tagger should have to deal with this complexity
explicitly rather than be "saved" by the framework.

>> >     - Source address is a big problem, but this time not in the sense
>> >       that it traditionally has been. Specifically, due to address
>> >       learning being enabled, the hardware FDB will set destinations to
>> >       take the autonomous fast path. But surprise, the autonomous fast
>> >       path is blocked, because as far as the switch is concerned, the
>> >       ports are standalone and not offloading the bridge. We have driv=
ers
>> >       that don't disable address learning when they operate in standal=
one
>> >       mode, which is something they definitely should do.
>>
>> Some hardware can function with it on (e.g. mv88e6xxx can associate an
>> FDB per port), but there is no reason to do it, so yes it should be
>> disabled.
>
> So how does mv88e6xxx handle the address learning issue currently?

Learning is enabled, but addresses are learned in a separate DB. So they
do not interfere with offloaded traffic. Since the FDB is not consulted
when sending frames from the CPU, it works. But we are needlessly using
up precious rows in the FDB.

>> >     There is nothing actionable for you in this patch set to resolve t=
his.
>> >     I just wanted to get an idea.
>> > (b) Whether struct dsa_lag really brings us any significant benefit. I
>> >     found that it doesn't. It's a lot of code added to the DSA core, t=
hat
>> >     should not really belong in the middle layer. I need to go back and
>> >     quote your motivation in the RFC:
>> >
>> > | All LAG configuration is cached in `struct dsa_lag`s. I realize that
>> > | the standard M.O. of DSA is to read back information from hardware
>> > | when required. With LAGs this becomes very tricky though. For exampl=
e,
>> > | the change of a link state on one switch will require re-balancing of
>> > | LAG hash buckets on another one, which in turn depends on the total
>> > | number of active links in the LAG. Do you agree that this is
>> > | motivated?
>> >
>> >     After reimplementing bonding offload in ocelot, I have found
>> >     struct dsa_lag to not provide any benefit. All the information a
>> >     driver needs is already provided through the
>> >     struct net_device *lag_dev argument given to lag_join and lag_leav=
e,
>> >     and through the struct netdev_lag_lower_state_info *info given to
>> >     lag_change. I will send an RFC to you and the list shortly to prove
>> >     that this information is absolutely sufficient for the driver to do
>> >     decent internal bookkeeping, and that DSA should not really care
>> >     beyond that.
>>
>> Do you have a multi-chip setup? If not then I understand that `struct
>> dsa_lag` does not give you anything extra. In a multi-chip scenario
>> things become harder. Example:
>>
>> .-----.   .-----.
>> | sw0 +---+ sw1 |
>> '-+-+-'3 3'--+--'
>>   1 2        1
>>
>> Let's say that sw0p1, sw0p2 and sw1p1 are in a LAG. This system can hash
>> flows into 8 buckets. So with all ports active you would need an
>> allocation like this:
>>
>> sw0p1: 0,1,2
>> sw0p2: 3,4,5
>> sw1p1: 6,7
>>
>> For some reason, the system determines that sw0p2 is now inactive and
>> the LAG should be rebalanced over the two remaining active links:
>>
>> sw0p1: 0,1,2,3
>> sw0p2: -
>> sw1p1: 4,5,6,7
>>
>> In order for sw0 and sw1 to agree on the assignment they need access to
>> a shared view of the LAG at the tree level, both about the set of active
>> ports and their ordering. This is `struct dsa_lag`s main raison d'=C3=AA=
tre.
>
> Yup, you could do that just like I did with ocelot, aka keep in
> struct dsa_port:
> 	struct net_device *bond;
> 	bool lag_tx_active;
>
> This is enough to replace your usage of:
>
> 	list_for_each_entry(dp, &lag->ports, lag_list) {
> 		...
> 	}
>
> with:
>
> 	list_for_each_entry(dp, &dst->ports, list) {
> 		if (dp->bond !=3D lag_dev)
> 			continue;
>
> 		...
> 	}
>
> and:
>
> 	list_for_each_entry(dp, &lag->tx_ports, lag_tx_list) {
> 		...
> 	}
>
> with:
>
> 	list_for_each_entry(dp, &dst->ports, list) {
> 		if (dp->bond !=3D lag_dev || !dp->lag_tx_active)
> 			continue;
>
> 		...
> 	}
>
> The amount of iteration that you would do would be about the same. Just
> this:
>
> 	struct dsa_lag *lag =3D dsa_lag_by_dev(ds->dst, lag_dev);
>
> would need to be replaced with something more precise, depending on what
> you need the struct dsa_lag pointer for. You use it in crosschip_lag_join
> and in crosschip_lag_leave to call mv88e6xxx_lag_sync_map, where you
> again iterate over the ports in the DSA switch tree. But if you passed
> just the struct net_device *lag_dev directly, you could keep the same
> iteration and do away with the reference-counted struct dsa_lag.
>
>> The same goes for when a port joins/leaves a LAG. For example, if sw1p1
>> was to leave the LAG, we want to make sure that we do not needlessly
>> flood LAG traffic over the backplane (sw0p3<->sw1p3). If you want to
>> solve this at the ds level without `struct dsa_lag`, you need a refcount
>> per backplane port in order to figure out if the leaving port was the
>> last one behind that backplane port.
>
> Humm, why?
> Nothing would change. Just as you start with a map of 0 in
> mv88e6xxx_lag_sync_map, and use dsa_towards_port for every dp that you
> find in the switch tree, I am saying keep that iteration, but don't keep
> those extra lists for the bonded ports and the active bonded ports. Just
> use as a search key the LAG net device itself, and keep an extra bool
> per dp. I think it's really simpler this way, with a lot less overhead
> in terms of data structures, lists and whatnot.

I will remove `struct dsa_lag` in v4.

>> >     - Remember that the only reason why the DSA framework and the
>> >       syntactic sugar exists is that we are presenting the hardware a
>> >       unified view for the ports which have a struct net_device regist=
ered,
>> >       and the ports which don't (DSA links and CPU ports). The argument
>> >       really needs to be broken down into two:
>> >       - For cross-chip DSA links, I can see why it was convenient for
>> >         you to have the dsa_lag_by_dev(ds->dst, lag_dev) helper. But
>> >         just as we currently have a struct net_device *bridge_dev in
>> >         struct dsa_port, so we could have a struct net_device *bond,
>> >         without the extra fat of struct dsa_lag, and reference countin=
g,
>> >         active ports, etc etc, would become simpler (actually inexiste=
nt
>> >         as far as the DSA layer is concerned). Two ports are in the sa=
me
>> >         bond if they have the same struct net_device *bond, just as th=
ey
>> >         are bridged if they have the same struct net_device *bridge_de=
v.
>> >       - For CPU ports, this raises an important question, which is
>> >         whether LAG on switches with multiple CPU ports is ever going =
to
>> >         be a thing. And if it is, how it is even going to be configured
>> >         from the user's perspective. Because on a multi-CPU port syste=
m,
>> >         you should actually see it as two bonding interfaces back to b=
ack.
>> >         First, there's the bonding interface that spans the DSA master=
s.
>> >         That needs no hardware offloading. Then there's the bonding
>> >         interface that is the mirror image of that, and spans the CPU
>> >         ports. I think this is a bit up in the air now. Because with
>>
>> Aside. On our devices we use the term cpu0, cpu1 etc. to refer to a
>> switch port that is connected to a CPU. The CPU side of those
>> connections are chan0, chan1 ("channel"). I am not saying we have to
>> adopt those, but some unambiguous terms would be great in these
>> conversations.
>
> You have me confused. chan0, chan1 are DSA master interfaces? Can we
> keep calling them DSA master interfaces, or do you find that confusing?

Not confusing, just a mouthful. It was just an idea, DSA master
interface works.

>> >         your struct dsa_lag or without, we still have no bonding device
>> >         associated with it, so things like the balancing policy are not
>> >         really defined.
>> >
>>
>> I have a different take on that. I do not think you need to create a
>> user-visible LAG at all in that case. You just setup the hardware to
>> treat the two CPU ports as a static LAG based on the information from
>> the DT. Then you attach the same rx handler to both. On tx you hash and
>> loadbalance on flows that allow it (FORWARDs on mv88e6xxx) and use the
>> primary CPU port for control traffic (FROM_CPU).
>>
>> The CPU port is completely defined by the DT today, so I do not see why
>> we could not add balancing policy to that if it is ever required.
>
> Hashing policy for a bonding interface, defined in DT? Yummm.

Notice the "if it is ever required" part, I can not see why it ever
would be. The driver will know how to get the best loadbalancing out of
the hardware.

>> > I would like you to reiterate some of the reasons why you prefer having
>> > struct dsa_lag.
>>
>> I hope I did that already. But I will add that if there was a dst->priv
>> for the drivers to use as they see fit, I guess the bookkeeping could be
>> moved into the mv88e6xxx driver instead if you feel it pollutes the DSA
>> layer. Maybe you can not assume that all chips in a tree use a
>> compatible driver though?
>
> I don't think the DSA switch tree is private to anyone.

Well I need somewhere to store the association from LAG netdev to LAG
ID. These IDs are shared by all chips in the tree. It could be
replicated on each ds of course, but that does not feel quite right.

>> Are there any other divers that support multi-chip that might want to
>> use the same thing?
>
> Nope.
