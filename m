Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 735AA3BB89E
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 10:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbhGEIL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 04:11:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbhGEILz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 04:11:55 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07929C061574
        for <netdev@vger.kernel.org>; Mon,  5 Jul 2021 01:09:19 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id p21so9216516lfj.13
        for <netdev@vger.kernel.org>; Mon, 05 Jul 2021 01:09:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=g2yI2dk8kRaKRO8vL7SsgBiEMkt1HoY4zcFE6ApY5Ac=;
        b=qVZOjfs0SXipAFcVittluw6PgqbF9q+D5bSM2KqVCbrfNa1OU4C5NPIMPIlns78xTA
         k3wK4P3DJL6KpuvR3Rvi+AltvY+WhMEvcLjBuWL9HHemXLz8FD7m07DcUFBwr1ZbMMQ8
         ucOjJMdc0VHYqYrDMglZG9qSYFM+Sw/EXPbqXFU/ZK7nPuqn/6Pd1Khzrvv6Vm10Emc6
         YXWJ+VaifDyZsDzSDCQkjt5SKK3HbnZ0sTf3WeTTmPgazBuX77dyHQR84xM6PoTT+dib
         U28k3W64QPZYyGayy1pR/V3TVSFVQl4q7x+OGip3OP9SVptvQq4ROYLfynQYVq/OO0DD
         APug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=g2yI2dk8kRaKRO8vL7SsgBiEMkt1HoY4zcFE6ApY5Ac=;
        b=ma1FpzBbWd+0XzzQJGXedJCqd/fKIv9eCwaaOKnGmlsJinmMNXvGLcldENKkqmVlfZ
         540Sz74SS4VsxBPpN13eTk+vMPFGrAA18ZwiphdbMM37fsuBL3+8YjS7+jIWkkuOepRS
         4e4EyShf3m3BOJ1IjJeaF2uRlfpgxBmOUN5frN9AcuCzd1IpVRG+MTAkYWs3xKDSHp+D
         a5cnCM/Dx2V96/bHcazOL4q4VNbrq5sn2HDkQZxNkQv7V25lkqBYjq1XzT9nCEjrTUG8
         deBvCJuAwUpQ8f58IkWokL2tcOAgiSXvgX8a/4bZFXY1T1VGNAUJu8JEnZiEgeqIK3u5
         MIpg==
X-Gm-Message-State: AOAM531PnQ30APv/apzVm6CGybSkx+h4yMAmh21su68Ta9uhcHlJ+B5H
        NpB3UNh9mTmAKBNjewtkfnxfFA==
X-Google-Smtp-Source: ABdhPJzbraS5HnNUmNB26v5eCgXWuf48AQkbjg39S/U5XqvTi8VyPrxyJfkQbgJlf+5ufooz17OKWw==
X-Received: by 2002:ac2:55af:: with SMTP id y15mr10105583lfg.29.1625472557226;
        Mon, 05 Jul 2021 01:09:17 -0700 (PDT)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id b2sm119932lfb.294.2021.07.05.01.09.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 01:09:16 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [RFC PATCH v2 net-next 00/10] Allow forwarding for the software bridge data path to be offloaded to capable devices
In-Reply-To: <20210704081132.a2xxvq5sguhpxxxv@skbuf>
References: <20210703115705.1034112-1-vladimir.oltean@nxp.com> <871r8f836d.fsf@waldekranz.com> <20210704081132.a2xxvq5sguhpxxxv@skbuf>
Date:   Mon, 05 Jul 2021 10:09:16 +0200
Message-ID: <87y2al6v2r.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 04, 2021 at 11:11, Vladimir Oltean <olteanv@gmail.com> wrote:
> Hi Tobias,
>
> On Sun, Jul 04, 2021 at 12:04:26AM +0200, Tobias Waldekranz wrote:
>> On Sat, Jul 03, 2021 at 14:56, Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
>> > For this series I have taken Tobias' work from here:
>> > https://patchwork.kernel.org/project/netdevbpf/cover/20210426170411.1789186-1-tobias@waldekranz.com/
>> > and made the following changes:
>> > - I collected and integrated (hopefully all of) Nikolay's, Ido's and my
>> >   feedback on the bridge driver changes. Otherwise, the structure of the
>> >   bridge changes is pretty much the same as Tobias left it.
>> > - I basically rewrote the DSA infrastructure for the data plane
>> >   forwarding offload, based on the commonalities with another switch
>> >   driver for which I implemented this feature (not submitted here)
>> > - I adapted mv88e6xxx to use the new infrastructure, hopefully it still
>> >   works but I didn't test that
>>
>> Hi Vladimir,
>>
>> Sorry that I have dropped the ball on this series. I have actually had a
>> v1 of this queued up for a while. Unfortunately I ran into mv88e6xxx
>> specific problems. (See below)
>>
>> > The data plane of the software bridge can be partially offloaded to
>> > switchdev, in the sense that we can trust the accelerator to:
>> > (a) look up its FDB (which is more or less in sync with the software
>> >     bridge FDB) for selecting the destination ports for a packet
>> > (b) replicate the frame in hardware in case it's a multicast/broadcast,
>> >     instead of the software bridge having to clone it and send the
>> >     clones to each net device one at a time. This reduces the bandwidth
>> >     needed between the CPU and the accelerator, as well as the CPU time
>> >     spent.
>> >
>> > The data path forwarding offload is managed per "hardware domain" - a
>> > generalization of the "offload_fwd_mark" concept which is being
>> > introduced in this series. Every packet is delivered only once to each
>> > hardware domain.
>> >
>> > In addition, Tobias said in the original cover letter:
>> >
>> > ====================
>> > ## Overview
>> >
>> >    vlan1   vlan2
>> >        \   /
>> >    .-----------.
>> >    |    br0    |
>> >    '-----------'
>> >    /   /   \   \
>> > swp0 swp1 swp2 eth0
>> >   :   :   :
>> >   (hwdom 1)
>> >
>> > Up to this point, switchdevs have been trusted with offloading
>> > forwarding between bridge ports, e.g. forwarding a unicast from swp0
>> > to swp1 or flooding a broadcast from swp2 to swp1 and swp0. This
>> > series extends forward offloading to include some new classes of
>> > traffic:
>> >
>> > - Locally originating flows, i.e. packets that ingress on br0 that are
>> >   to be forwarded to one or several of the ports swp{0,1,2}. Notably
>> >   this also includes routed flows, e.g. a packet ingressing swp0 on
>> >   VLAN 1 which is then routed over to VLAN 2 by the CPU and then
>> >   forwarded to swp1 is "locally originating" from br0's point of view.
>> >
>> > - Flows originating from "foreign" interfaces, i.e. an interface that
>> >   is not offloaded by a particular switchdev instance. This includes
>> >   ports belonging to other switchdev instances. A typical example
>> >   would be flows from eth0 towards swp{0,1,2}.
>> >
>> > The bridge still looks up its FDB/MDB as usual and then notifies the
>> > switchdev driver that a particular skb should be offloaded if it
>> > matches one of the classes above. It does so by using the _accel
>> > version of dev_queue_xmit, supplying its own netdev as the
>> > "subordinate" device. The driver can react to the presence of the
>> > subordinate in its .ndo_select_queue in what ever way it needs to make
>> > sure to forward the skb in much the same way that it would for packets
>> > ingressing on regular ports.
>> >
>> > Hardware domains to which a particular skb has been forwarded are
>> > recorded so that duplicates are avoided.
>> >
>> > The main performance benefit is thus seen on multicast flows. Imagine
>> > for example that:
>> >
>> > - An IP camera is connected to swp0 (VLAN 1)
>> >
>> > - The CPU is acting as a multicast router, routing the group from VLAN
>> >   1 to VLAN 2.
>> >
>> > - There are subscribers for the group in question behind both swp1 and
>> >   swp2 (VLAN 2).
>> >
>> > With this offloading in place, the bridge need only send a single skb
>> > to the driver, which will send it to the hardware marked in such a way
>> > that the switch will perform the multicast replication according to
>> > the MDB configuration. Naturally, the number of saved skb_clones
>> > increase linearly with the number of subscribed ports.
>> >
>> > As an extra benefit, on mv88e6xxx, this also allows the switch to
>> > perform source address learning on these flows, which avoids having to
>> > sync dynamic FDB entries over slow configuration interfaces like MDIO
>> > to avoid flows directed towards the CPU being flooded as unknown
>> > unicast by the switch.
>> >
>> >
>> > ## RFC
>> >
>> > - In general, what do you think about this idea?
>> >
>> > - hwdom. What do you think about this terminology? Personally I feel
>> >   that we had too many things called offload_fwd_mark, and that as the
>> >   use of the bridge internal ID (nbp->offload_fwd_mark) expands, it
>> >   might be useful to have a separate term for it.
>> >
>> > - .dfwd_{add,del}_station. Am I stretching this abstraction too far,
>> >   and if so do you have any suggestion/preference on how to signal the
>> >   offloading from the bridge down to the switchdev driver?
>> >
>> > - The way that flooding is implemented in br_forward.c (lazily cloning
>> >   skbs) means that you have to mark the forwarding as completed very
>> >   early (right after should_deliver in maybe_deliver) in order to
>> >   avoid duplicates. Is there some way to move this decision point to a
>> >   later stage that I am missing?
>> >
>> > - BR_MULTICAST_TO_UNICAST. Right now, I expect that this series is not
>> >   compatible with unicast-to-multicast being used on a port. Then
>> >   again, I think that this would also be broken for regular switchdev
>> >   bridge offloading as this flag is not offloaded to the switchdev
>> >   port, so there is no way for the driver to refuse it. Any ideas on
>> >   how to handle this?
>> >
>> >
>> > ## mv88e6xxx Specifics
>> >
>> > Since we are now only receiving a single skb for both unicast and
>> > multicast flows, we can tag the packets with the FORWARD command
>> > instead of FROM_CPU. The swich(es) will then forward the packet in
>> > accordance with its ATU, VTU, STU, and PVT configuration - just like
>> > for packets ingressing on user ports.
>> >
>> > Crucially, FROM_CPU is still used for:
>> >
>> > - Ports in standalone mode.
>> >
>> > - Flows that are trapped to the CPU and software-forwarded by a
>> >   bridge. Note that these flows match neither of the classes discussed
>> >   in the overview.
>> >
>> > - Packets that are sent directly to a port netdev without going
>> >   through the bridge, e.g. lldpd sending out PDU via an AF_PACKET
>> >   socket.
>> >
>> > We thus have a pretty clean separation where the data plane uses
>> > FORWARDs and the control plane uses TO_/FROM_CPU.
>> >
>> > The barrier between different bridges is enforced by port based VLANs
>> > on mv88e6xxx, which in essence is a mapping from a source device/port
>> > pair to an allowed set of egress ports.
>>
>> Unless I am missing something, it turns out that the PVT is not enough
>> to support multiple (non-VLAN filtering) bridges in multi-chip
>> setups. While the isolation barrier works, there is no way of correctly
>> managing automatic learning.
>>
>> > In order to have a FORWARD
>> > frame (which carries a _source_ device/port) correctly mapped by the
>> > PVT, we must use a unique pair for each bridge.
>> >
>> > Fortunately, there is typically lots of unused address space in most
>> > switch trees. When was the last time you saw an mv88e6xxx product
>> > using more than 4 chips? Even if you found one with 16 (!) devices,
>> > you would still have room to allocate 16*16 virtual ports to software
>> > bridges.
>> >
>> > Therefore, the mv88e6xxx driver will allocate a virtual device/port
>> > pair to each bridge that it offloads. All members of the same bridge
>> > are then configured to allow packets from this virtual port in their
>> > PVTs.
>>
>> So while this solution is cute, it does not work in this example:
>>
>>  CPU
>>   | .-----.
>> .-0-1-. .-0-1-.
>> | sw0 | | sw1 |
>> '-2-3-' '-2-3-'
>>
>> - [sw0p2, sw1p2] are attached to one bridge
>> - [sw0p3, sw1p3] are attached to another bridge
>> - Neither bridge uses VLAN filtering
>>
>> Since no VLAN information available in the frames, the source addresses
>> of FORWARDs sent over the DSA link (sw0p1, sw1p0) cannot possibly be
>> separated into different FIDs. They will all be placed in the respective
>> port's default FID. Thus, the two bridges are not isolated with respect
>> to their FDBs.
>>
>> My current plan is therefore to start by reworking how bridges are
>> isolated on mv88e6xxx. Roughly by allocating a reserved VID/FID pair for
>> each non-filtering bridge. Two of these can be easily managed since both
>> VID 0 and 4095 are illegal on the wire but allowed in the VTU - after
>> that it gets tricky. The best scheme I have come up with is to just grab
>> an unused VID when adding any subsequent non-filtering bridge; in the
>> event that that VID is requested by a filtering bridge or a VLAN upper,
>> you move the non-filtering bridge to another currently unused VID.
>>
>> Does that sound reasonable?
>
> I don't think this patch series makes the problem you are describing any
> worse than it already is in mainline, does it?

It does not make it worse, no. But assuming that mv88e6xxx will handle
multi-bridge using the VTU in the future (i.e. my suggestion above),
there is no need for inventing virtual DSA dev/port tuples - we can just
use the physical port info as the source and use the VID to signal the
source bridge. So I am hesitant to merge the mv88e6xxx-specific changes.

> I mean even with multiple VLAN-unaware bridges spanning the same single
> switch chip today, it is still true that you can not have two stations
> with the same MAC address, one in one bridge and another in the other
> bridge, right?

That is correct.

> Do you have an example when this causes issues that need to be addressed
> immediately?
>
> I thought the only case where this is a real problem is when you have
> multiple CPU ports or multiple DSA links between 2 switches, because
> then, if learning is enabled, that same MAC address will bounce between
> the 2 ports. For that case, the consensus was that you just can't enable
> address learning on those ports, and you let the software manage the FDB
> in a way that is compatible with multiple CPU ports / DSA links (install
> the MAC DA as a sort of multicast address and let the port forwarding
> matrix choose only one of the 2 destinations based on source port).
>
> Lack of FDB partitioning also used to be a problem when the standalone
> ports were left to do address learning, but that changed too.

Funny you should mention that. The presence of standalone ports is
actually what first shone a light on this issue for me. I was running a
kselftest-like setup like this:

   br0
   / \
swp1 swp3  swp2  swp4

Physically, [swp1, swp2] and [swp3, swp4] where looped externally:

    CPU
     |
.----0----.
|   sw0   |
'-1-2-3-4-'
  '-' '-'

I was testing automatic learning by sending out a broadcast from br0 and
verifying that br0's MAC was learned on port 0 in the ATU - alas, it was
not. The MAC was nowhere to be found.

Moving back to a topology without these loops, I could see that learning
worked as expected.

Not sure how familiar you are with mv88e6xxx at this point, but the way
learning is disabled is by clearing a port's port association vector
(PAV). This does not, however, "disable" learning really. It just
updates the ATU with an all-zero vector, which means "invalidate the
entry".

So, in the example above, when the broadcast is looped back to the
standalone ports, the port's default FID (0) will be used to invalidate
the MAC for br0. Since they all use FID 0, the standalone ports will
nuke the br0's FDB.

> The hardware I am working with simply does not have any way to solve
> this either - the FDB is simply not partitionable without VLAN
> filtering (we have simple shared VLAN filtering, where the VID is
> ignored and the FDB lookup is performed with VID 0, but not anything
> more complex). So the simple solution I've been advising for people who
> want their MAC addresses to be isolated is to create a single VLAN-aware
> bridge and manage the VLAN broadcast domains themselves - that seems to
> work and is simple to understand and flexible (note that I am going to
> send a patch at some point to prevent the user from partitioning a
> sja1105 switch tree into multiple VLAN-aware bridges).

Essentially what I am proposing is to always run mv88e6xxx VLAN-aware
internally. Then if you have bridges that disable VLAN filtering, you
change the ingress policy on the member ports to classify all incoming
traffic as untagged and assign them to the port's PVID. (Note: this is
different from "force PVID" in that you never pop any tags from the
frame)

Is your device capable of operating in that mode?

> Basically unless I'm misunderstanding something, I think what you're
> proposing makes theoretical sense, but without a use case behind it it
> might just be too much work with no real life benefit.

I have not done the tests to prove it, but I am pretty sure that if you
have two bridges where the same MACs are used (which does happen in
redundant topologies, and is why IVL is a thing) you will add MACs to
the ATU with a destination that is not allowed by the PVT. This will
lead to sporadic drops while the address is on the "wrong" port from the
view of one bridge, until that station sends some return traffic. At
that point of course, it will be on the wrong port according to the
other bridge.

I guess I would just rather spend some more time up front to make sure
that we support full isolation between bridges, than spend that same
time debugging issues in production environments later on.
