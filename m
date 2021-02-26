Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7576D326A2A
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 23:45:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbhBZWp3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 17:45:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbhBZWpY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 17:45:24 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BADCC061574
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 14:44:43 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id h4so12225180ljl.0
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 14:44:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version:content-transfer-encoding;
        bh=nffnTZ174603b6xKaXM5lKhWIiJFCaAfeT5vkvFcOUY=;
        b=1G5AMK+ReZ2gPRMUs3AL5P2JfY4LYXgiBHOogCVGaktFwkHvIBLuCYDmJ1y6afNEWO
         M+UfWeFPwARbVheLLdlFEzMJuro7hujNlUAA+BMnCMJ8mSZvr60UT1WkYWrGXmc4o4oH
         8JnZMwP867A/GEYvTVYjzKvFGE7SscHXvZLf9hN6QH+BW+A5iQkJJKcv5IchGjQF60Id
         DZArpBfddDtaVJZxJKFGovxoKRaan4m4m9d8d56EZ6jGn8NZ/SwCkjWYXBD4+YYoqcBs
         TvjXtyiCamW97zzVifqJI+agKYzzEoKJlfU5ycVeV/goqy10HcgHKXxXcKMnHSmGYsYN
         XCdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=nffnTZ174603b6xKaXM5lKhWIiJFCaAfeT5vkvFcOUY=;
        b=SbRA56l6w2roYOCETIojn+aki9VTszZ0AMBDXzZwgbNal8MOtSJY1C3EWu/fqQcUuU
         Ccho0Gkjnpoo2lLFs8rg5oyq5Uwqrlp0m+vtdHYdoFncnCfQEi6sOu2vIhsgdydywEK7
         1a6fAvhE/hMf9o/LFx6vl1RO4w4KW2rw2i77ohA0yu7G2Zy7Fs67rg09ouvEJat0Yqfm
         cz+ZSNvTK+wznJmyeE+nSR36LN6dkKQwtIAcetclUsMbfBgwfJDLA0lE3JE6R9B/8g4K
         fGUdSXctqoj26PsTaibAPK8ynEml9FpFm0M9688oq6/0rpkMx3EpAUCX+LXD1GIEBuzO
         qvyg==
X-Gm-Message-State: AOAM533OhwXx+50+q46XgXeIU5WgZsaKpJAWG2/SalDBwoSii4iCu/LT
        MwWIJLF06J06u7JwCzpIaAgGVg==
X-Google-Smtp-Source: ABdhPJzEc6xiIxxn3ZiLPb+VqbOx46Ommyul39T+ztK7vdtTupuVkOkoNpl3ejFdhPzsGQbxDKJxLw==
X-Received: by 2002:a2e:5315:: with SMTP id h21mr2776933ljb.299.1614379481464;
        Fri, 26 Feb 2021 14:44:41 -0800 (PST)
Received: from wkz-x280 (h-236-82.A259.priv.bahnhof.se. [98.128.236.82])
        by smtp.gmail.com with ESMTPSA id 14sm1514543lfr.9.2021.02.26.14.44.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 14:44:40 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        DENG Qingfang <dqfext@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: Re: [RFC PATCH v2 net-next 06/17] net: dsa: add addresses obtained from RX filtering to host addresses
In-Reply-To: <20210226132834.dx25pq4x757acujk@skbuf>
References: <20210224114350.2791260-1-olteanv@gmail.com> <20210224114350.2791260-7-olteanv@gmail.com> <87pn0nqelj.fsf@waldekranz.com> <20210226132834.dx25pq4x757acujk@skbuf>
Date:   Fri, 26 Feb 2021 23:44:40 +0100
Message-ID: <87k0quqwiv.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 26, 2021 at 15:28, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Fri, Feb 26, 2021 at 11:59:36AM +0100, Tobias Waldekranz wrote:
>> On Wed, Feb 24, 2021 at 13:43, Vladimir Oltean <olteanv@gmail.com> wrote:
>> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
>> >
>> > In case we have ptp4l running on a bridged DSA switch interface, the P=
TP
>> > traffic is classified as link-local (in the default profile, the MAC
>> > addresses are 01:1b:19:00:00:00 and 01:80:c2:00:00:0e), which means it
>> > isn't the responsibility of the bridge to make sure it gets trapped to
>> > the CPU.
>> >
>> > The solution is to implement the standard callbacks for dev_uc_add and
>> > dev_mc_add, and behave just like any other network interface: ensure
>> > that the user space program can see those packets.
>>
>> So presumably the application would use PACKET_ADD_MEMBERSHIP to set
>> this up?
>>
>> This is a really elegant way of solving this problem I think!
>
> Yes, using the unmodified *_ADD_MEMBERSHIP UAPI was the intention.
> If that is not possible, the whole idea kinda loses its appeal and we'd
> be better off starting from scratch and figuring out how we'd prefer for
> user space to request (exclusive) address membership.
>
>> One problem I see is that this will not result in packets getting
>> trapped to the CPU, rather they will simply be forwarded.  I.e. with
>> this patch applied, once ptp4l adds the groups it is interested in, my
>> HW FDB will look like this:
>>
>> ADDR                VID  DST   TYPE
>> 01:1b:19:00:00:00     0  cpu0  static
>> 01:80:c2:00:00:0e     0  cpu0  static
>>
>> But this will not allow these groups to ingress on (STP) blocked
>> ports. AFAIK, PTP (certainly LLDP which also uses the latter group)
>> should be able to do that.
>>
>> For mv88e6xxx (but I think this applies to most switches), there are
>> roughly three ways a given multicast group can reach the CPU:
>>
>> 1. Trap: Packet is unconditionally redirected to the CPU, independent
>>    of things like 802.1X or STP state on the ingressing port.
>> 2. Mirror: Send a copy of packets that pass all other ingress policy to
>>    the CPU.
>> 3. Forward: Forward packets that pass all other ingress policy to the
>>    CPU.
>>
>> Entries are now added as "Forward", which means that the group will no
>> longer reach the other local ports. But the command from the application
>> is "I want to see these packets", it says nothing about preventing the
>> group from being forwarded. So I think the default ought to be
>> "Mirror". Additionally, we probably need some way of specifying "Trap"
>> to those applications that need it. E.g. ptp4l could specify
>> PACKET_MR_MULTICAST_TRAP in mr_action or something if it does not want
>> the bridge (or the switch) to forward it.
>>
>> If "Forward" is desired, the existing "bridge mdb" interface seems like
>> the proper one, since it also affects other ports.
>
> I'm not sure I understand your exact requirement.
>
> Let me try to quote from IEEE 802.1Q-2018 clause 8.13.9 "Points of
> attachment and connectivity for Higher Layer Entities". For context,
> this talks about about Higher Layer Entities, aka applications such as
> STP, MRP, ISIS-SPB, whose world view is as though they are connected
> directly to the LAN that the bridge port is connected to, i.e. they
> bypass the MAC relay (forwarding) function.
>
> The spec says:
>
>   Controls placed in the forwarding path have no effect on the ability
>   of a Higher Layer Entity to transmit and receive frames to or from a
>   given LAN using a direct attachment to that LAN (e.g., from entity A
>   to LAN A); they only affect the path taken by any indirect
>   transmission or reception (e.g., from entity A to or from LAN B).
>
> Then there's this drawing:
>
>  +-----------------------+                         +---------------------=
--+
>  | Higher Layer Entity A |                         | Higher Layer Entity =
B |
>  +-----------------------+                         +---------------------=
--+
>             |                                                   |
>             |     +---------------------------------------+     |
>             |     |             MAC Relay Entity          |     |
>             |     |                                       |     |
>             |     |   Port   Filtering Database   Port    |     |
>             |     |  State       Information     State    |     |
>             |     |                                       |     |
>             |     |     /             /             /     |     |
>             +-----|---x/  x---------x/  x---------x/  x---+-----+
>             |     |                                       |     |
>             |     +---------------------------------------+     |
>             |                                                   |
>  +----------------------------+                      +-------------------=
---------+
>  |          |                 |                      |          |        =
         |
>  |          x                 |                      |          x        =
         |
>  |    MAC    /                |                      |    MAC    /       =
         |
>  |  Entity  / MAC_Operational |                      |  Entity  / MAC_Ope=
rational |
>  |          x                 |                      |          x        =
         |
>  |          |                 |                      |          |        =
         |
>  +----------------------------+                      +-------------------=
---------+
>             |                                                   |
>             |                                                   |
>             |                                                   |
>    ----------------------------                        ------------------=
----------
>   /       LAN A               /                       /       LAN B      =
         /
>  /                           /                       /                   =
        /
> /---------------------------/                       /--------------------=
-------/
>
> Figure 8-20: Effect of control information on the forwarding path
>
> A one phrase conclusion from the above is that a Higher Layer Entity
> should be able to accept packets from the bridge port regardless of its
> STP state, as long as the MAC is operational.
>
> In my world view, anything sent and received through the swpN DSA
> interfaces, and therefore by injection/extraction through the CPU port,
> represents a Higher Layer Entity.

Yes, I agree.

> So the fact that your Marvell switch treats the CPU port as just another
> destination for forwarding should be hidden away from the externally
> observable behavior. DSA does not really support the switched endpoint
> use case, we should deny attaching IP interfaces to it.
>
> But to your point: we are currently using the .port_fdb_add and
> .port_mdb_add API in DSA to install the host-filtered addresses. This is
> true, and potentially incorrect, since indeed it assumes that the
> underlying mechanism to trap these addresses to the CPU is through the
> FDB/MDB, which will violate the expectation of Higher Layer Entities
> since it goes through the forwarding process.

Well, at least the way it is implemented now. E.g. mv88e6xxx can setup
mirrors/traps via the FDB (ATU), I imagine that many smaller devices
reuse their FDBs for this purpose. So it might be possible to just
extend the API a bit to signal the type of entry required.

> I think we could add a new
> set of APIs in DSA, something like .host_uc_add and .host_mc_add. Then,
> drivers that can't do any better can go ahead and internally call their
> .port_fdb_add and .port_mdb_add.

That might be an ever better way of managing it. That would also make it
easier to design in the difference between trap/mirror from the start.

> Question: If we add .host_uc_add and
> .host_mc_add, should these APIs be per front port?

I think they would have to be per port in order to work in the
standalone case. You need some context to about which FID (or
equivalent) to tie the entry to.

> And if they should,
> should we leave the switch driver the task of reference counting them?

Well, I know you do not like the DSA layer "trying to be helpful", but I
can not imagine a case where some hardware would be interested in having
N callbacks for the same address when N ports are attached to the same
bridge. So I think it would be a service that DSA can provide.

>
> As to why does IEEE 1588 use 01-80-C2-00-00-0E for peer delay in its
> default profile for the L2 transport, I could only find this (quoting
> clause "F.3 Multicast MAC Addresses"):
>
>   To ensure peer delay measurements on ports blocked by (Rapid/Multiple)
>   Spanning Tree Protocols, a reserved address, 01-80-C2-00-00-0E, shall be
>   used as a Destination MAC Address for PTP peer delay mechanism messages.

Yeah that makes sense. You want to make sure that you are already synced
with your neighbor when a topology change occurs.

> Basically, unlike end-to-end delay measurements, peer delay is by
> definition point-to-point, which in an L2 network mean link-local.
> So if your LAN uses the peer delay measurement protocol, then all your
> switches must have some sort of PTP awareness. There are 2 cases really:
> - You are a Peer-to-peer Transparent Clock, so you must speak the Peer
>   Delay protocol yourself. Therefore you must have a Higher Layer Entity
>   that consumes the PTP PDUs. So for this case, it doesn't really make
>   any difference that the reserved bridge MAC address range is used.
> - You are an End-to-end Transparent Clock. These are an oddity of the
>   1588 standard which do not speak the Peer Delay protocol, but are
>   allowed to forward Peer Delay messages, and update the correctionField
>   of those Peer Delay messages that are Events (contain timestamps).
>   I would think that this is where having a reserved address for the
>   Peer Delay messages would make a difference.
>
>
> Then, there seems to be the second part of your request, that of address
> exclusivity. I think that for addresses that should explicitly be
> removed from the hardware data path, the tc-trap action was created for
> that exact purpose.

Maybe. Tc-trap is a weird creature in that it seems to violate the rule
that in order for an offload to be accepted into the kernel, a software
implementation needs to be in place first. The exception, as I
understand it, is for things that do not make sense in software
(e.g. cut-through switching).

Trapping a packet, blocking bridging, certainly seems like something
that can be done in software. The fact that this was not done means that
it is hard to add it now without potentially breaking existing
use-cases.

Now when a tc trap filter is added, the switch will trap it to the CPU,
the switchdev driver will _not_ set OFM. The result is that the frame is
software forwarded by the bridge. Even if you hack the driver to pretend
that it was HW forwarded (setting OFM), that will not stop the bridge
from forwarding it to foreign interfaces.

One idea could be to implement the software version of "trap" to mean
that sch_handle_ingress could return a signal to
__netif_receive_skb_core to skip any rx handlers and only consider
device specific protocol handlers. A kind of "RX_HANDLER_EXACT with a
twist". Again, this is hard to add after the fact, but you should at
least be able to get the old behavior with "skip_sw".

> However, the question really becomes: does PTP care
> enough to know it's running on top of a switchdev interface, so that it
> should claim exclusive ownership of that multicast group, or should it
> just care enough to say "hey, I'm here, I'm interested in it too"?

Ideally it would not know about switchdev, but maybe it should care
whether it is running on top of a bridge, since that has implications
for how PTP frames should be forwarded (or not).

> For one thing, the 01-80-c2-00-00-0e multicast group is shared, even
> IEEE 1588 says so:
>
>   NOTE 2: At its July 17=E2=88=9220, 2006 meeting the IEEE 802.1 Working =
Group
>   approved a motion that included the following text: "re-designate the
>   reserved address currently identified for use by 802.1AB as an address
>   that can be used by protocols that require the scope of the address to
>   be limited to an individual LAN" and "The reserved multicast address
>   that IEEE 1588 should use is 01-80-C2-00-00-0E." This address is not
>   reserved exclusively for PTP, but rather it is a shared address.
>
> and the bridge driver also supports this odd attribute:
>
>   group_fwd_mask MASK - set the group forward mask. This is the bitmask
>   that is applied to decide whether to forward incoming frames destined
>   to link-local addresses, ie addresses of the form 01:80:C2:00:00:0X
>   (defaults to 0, ie the bridge does not forward any link-local frames).
>
> which by the way seems to be in blatant contradiction of clause
> 8.13.4 Reserved MAC addresses: "Any frame with a destination address
> that is a reserved MAC address shall not be forwarded by a Bridge".

Well, the set of addresses that are reserved vary based on the type of
bridge (Tables 8-1, 8-2, and 8-3). So this setting allows you to choose
the applicable set.

Additionally, there are cases where you want to emulate a $10 switch (or
even hub) which does _no_ kind of filtering at all.

> So if ptp4l was to install a trap action by itself, it would potentially
> interact in unexpected ways with other uses of that address on the same
> system.

Yeah that is a problem. The easy way out is probably "that is the
admin's problem". A middle way could be to warn/abort if the trap is not
in place. You could also go all the way and reference count filters I
suppose.
