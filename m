Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C74E63BAC0D
	for <lists+netdev@lfdr.de>; Sun,  4 Jul 2021 10:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbhGDIOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Jul 2021 04:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbhGDIOL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Jul 2021 04:14:11 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4C3EC061762
        for <netdev@vger.kernel.org>; Sun,  4 Jul 2021 01:11:35 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id l2so95274edt.1
        for <netdev@vger.kernel.org>; Sun, 04 Jul 2021 01:11:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qfi4cvWP5E/EzQLTsZwopW9c0zJOVMt9TX/Vp18aP7s=;
        b=N+URJQpPSI2Katp4q3ZcqifhNnjZNrwFwcX1PTNoMFoJg9IqUG3ALjsoKHEowxEJjT
         f9oZVEw2SxCP8/zxQ2XZ84MD6GMqcFIGy+nOI+yfj3y+qqLj1Bzoui1Jaf384balXbAg
         y75PD2fCw5506bF993n3WIghCL22vmCxrGGd70nYW7qYZQVWzaPfDRtv0A9oDyy/ieIL
         EVdNRTRSMVdvLExak64+WwkZt78l+RO6YKlStffzWnV/hYPFCOhdSrSA5asPX6WWBmEY
         QIHgbCiCV0pDlhm1q6hnxm7SBMK1tNLxa0QxkkFGl23k4KYBHyjzzTL+K4HmNRljx5Zm
         akBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qfi4cvWP5E/EzQLTsZwopW9c0zJOVMt9TX/Vp18aP7s=;
        b=pnsBOtgNvbemu8ZLdVwUpVHFytopZ/BaxAyZ3VkqMO/94y7xVMuQBEyA8AqjTFINX3
         4psXhG56WbYlCx0FYtrZMyV6J7RyCqN34eXk+4eQehmUpOKfJS/FP2jovmCQeYiwRQ8q
         LgsOwkauDy0HSlfj0SJxDNMQPgYX0E9/TyeRM9Fh8catE0cQpq7+6Bl+OPIcVXx7MH8I
         qf3jk2r/Xd8tuqyFrJmQ/7VkHx7QNcoVG/o+r7uVdSkXKwMB4mHQkfQvHJNOskaLGORh
         fb7vGOE8uhqhivy62Mnq/iOoV/9OWfVMw/NPLGUHlEa52D515/XtUIwcIto3Tkcp+Z89
         qMYA==
X-Gm-Message-State: AOAM531zOW4vx4rwmCWk/o05QLmPKyT7lXGicU9wuH2Zi823+dDKesxm
        Z82fzBAM8lEOEGcz64aGb/U=
X-Google-Smtp-Source: ABdhPJzxPihvOmRgrazRZLnc5EKJeyqANS4zJE3XRuPbP0WE6HH56u/QLofQFQdrmfvrnmfxEG4ung==
X-Received: by 2002:aa7:d34f:: with SMTP id m15mr9241261edr.155.1625386294210;
        Sun, 04 Jul 2021 01:11:34 -0700 (PDT)
Received: from skbuf ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id jx12sm2956531ejb.9.2021.07.04.01.11.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jul 2021 01:11:33 -0700 (PDT)
Date:   Sun, 4 Jul 2021 11:11:32 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
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
Subject: Re: [RFC PATCH v2 net-next 00/10] Allow forwarding for the software
 bridge data path to be offloaded to capable devices
Message-ID: <20210704081132.a2xxvq5sguhpxxxv@skbuf>
References: <20210703115705.1034112-1-vladimir.oltean@nxp.com>
 <871r8f836d.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871r8f836d.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tobias,

On Sun, Jul 04, 2021 at 12:04:26AM +0200, Tobias Waldekranz wrote:
> On Sat, Jul 03, 2021 at 14:56, Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
> > For this series I have taken Tobias' work from here:
> > https://patchwork.kernel.org/project/netdevbpf/cover/20210426170411.1789186-1-tobias@waldekranz.com/
> > and made the following changes:
> > - I collected and integrated (hopefully all of) Nikolay's, Ido's and my
> >   feedback on the bridge driver changes. Otherwise, the structure of the
> >   bridge changes is pretty much the same as Tobias left it.
> > - I basically rewrote the DSA infrastructure for the data plane
> >   forwarding offload, based on the commonalities with another switch
> >   driver for which I implemented this feature (not submitted here)
> > - I adapted mv88e6xxx to use the new infrastructure, hopefully it still
> >   works but I didn't test that
>
> Hi Vladimir,
>
> Sorry that I have dropped the ball on this series. I have actually had a
> v1 of this queued up for a while. Unfortunately I ran into mv88e6xxx
> specific problems. (See below)
>
> > The data plane of the software bridge can be partially offloaded to
> > switchdev, in the sense that we can trust the accelerator to:
> > (a) look up its FDB (which is more or less in sync with the software
> >     bridge FDB) for selecting the destination ports for a packet
> > (b) replicate the frame in hardware in case it's a multicast/broadcast,
> >     instead of the software bridge having to clone it and send the
> >     clones to each net device one at a time. This reduces the bandwidth
> >     needed between the CPU and the accelerator, as well as the CPU time
> >     spent.
> >
> > The data path forwarding offload is managed per "hardware domain" - a
> > generalization of the "offload_fwd_mark" concept which is being
> > introduced in this series. Every packet is delivered only once to each
> > hardware domain.
> >
> > In addition, Tobias said in the original cover letter:
> >
> > ====================
> > ## Overview
> >
> >    vlan1   vlan2
> >        \   /
> >    .-----------.
> >    |    br0    |
> >    '-----------'
> >    /   /   \   \
> > swp0 swp1 swp2 eth0
> >   :   :   :
> >   (hwdom 1)
> >
> > Up to this point, switchdevs have been trusted with offloading
> > forwarding between bridge ports, e.g. forwarding a unicast from swp0
> > to swp1 or flooding a broadcast from swp2 to swp1 and swp0. This
> > series extends forward offloading to include some new classes of
> > traffic:
> >
> > - Locally originating flows, i.e. packets that ingress on br0 that are
> >   to be forwarded to one or several of the ports swp{0,1,2}. Notably
> >   this also includes routed flows, e.g. a packet ingressing swp0 on
> >   VLAN 1 which is then routed over to VLAN 2 by the CPU and then
> >   forwarded to swp1 is "locally originating" from br0's point of view.
> >
> > - Flows originating from "foreign" interfaces, i.e. an interface that
> >   is not offloaded by a particular switchdev instance. This includes
> >   ports belonging to other switchdev instances. A typical example
> >   would be flows from eth0 towards swp{0,1,2}.
> >
> > The bridge still looks up its FDB/MDB as usual and then notifies the
> > switchdev driver that a particular skb should be offloaded if it
> > matches one of the classes above. It does so by using the _accel
> > version of dev_queue_xmit, supplying its own netdev as the
> > "subordinate" device. The driver can react to the presence of the
> > subordinate in its .ndo_select_queue in what ever way it needs to make
> > sure to forward the skb in much the same way that it would for packets
> > ingressing on regular ports.
> >
> > Hardware domains to which a particular skb has been forwarded are
> > recorded so that duplicates are avoided.
> >
> > The main performance benefit is thus seen on multicast flows. Imagine
> > for example that:
> >
> > - An IP camera is connected to swp0 (VLAN 1)
> >
> > - The CPU is acting as a multicast router, routing the group from VLAN
> >   1 to VLAN 2.
> >
> > - There are subscribers for the group in question behind both swp1 and
> >   swp2 (VLAN 2).
> >
> > With this offloading in place, the bridge need only send a single skb
> > to the driver, which will send it to the hardware marked in such a way
> > that the switch will perform the multicast replication according to
> > the MDB configuration. Naturally, the number of saved skb_clones
> > increase linearly with the number of subscribed ports.
> >
> > As an extra benefit, on mv88e6xxx, this also allows the switch to
> > perform source address learning on these flows, which avoids having to
> > sync dynamic FDB entries over slow configuration interfaces like MDIO
> > to avoid flows directed towards the CPU being flooded as unknown
> > unicast by the switch.
> >
> >
> > ## RFC
> >
> > - In general, what do you think about this idea?
> >
> > - hwdom. What do you think about this terminology? Personally I feel
> >   that we had too many things called offload_fwd_mark, and that as the
> >   use of the bridge internal ID (nbp->offload_fwd_mark) expands, it
> >   might be useful to have a separate term for it.
> >
> > - .dfwd_{add,del}_station. Am I stretching this abstraction too far,
> >   and if so do you have any suggestion/preference on how to signal the
> >   offloading from the bridge down to the switchdev driver?
> >
> > - The way that flooding is implemented in br_forward.c (lazily cloning
> >   skbs) means that you have to mark the forwarding as completed very
> >   early (right after should_deliver in maybe_deliver) in order to
> >   avoid duplicates. Is there some way to move this decision point to a
> >   later stage that I am missing?
> >
> > - BR_MULTICAST_TO_UNICAST. Right now, I expect that this series is not
> >   compatible with unicast-to-multicast being used on a port. Then
> >   again, I think that this would also be broken for regular switchdev
> >   bridge offloading as this flag is not offloaded to the switchdev
> >   port, so there is no way for the driver to refuse it. Any ideas on
> >   how to handle this?
> >
> >
> > ## mv88e6xxx Specifics
> >
> > Since we are now only receiving a single skb for both unicast and
> > multicast flows, we can tag the packets with the FORWARD command
> > instead of FROM_CPU. The swich(es) will then forward the packet in
> > accordance with its ATU, VTU, STU, and PVT configuration - just like
> > for packets ingressing on user ports.
> >
> > Crucially, FROM_CPU is still used for:
> >
> > - Ports in standalone mode.
> >
> > - Flows that are trapped to the CPU and software-forwarded by a
> >   bridge. Note that these flows match neither of the classes discussed
> >   in the overview.
> >
> > - Packets that are sent directly to a port netdev without going
> >   through the bridge, e.g. lldpd sending out PDU via an AF_PACKET
> >   socket.
> >
> > We thus have a pretty clean separation where the data plane uses
> > FORWARDs and the control plane uses TO_/FROM_CPU.
> >
> > The barrier between different bridges is enforced by port based VLANs
> > on mv88e6xxx, which in essence is a mapping from a source device/port
> > pair to an allowed set of egress ports.
>
> Unless I am missing something, it turns out that the PVT is not enough
> to support multiple (non-VLAN filtering) bridges in multi-chip
> setups. While the isolation barrier works, there is no way of correctly
> managing automatic learning.
>
> > In order to have a FORWARD
> > frame (which carries a _source_ device/port) correctly mapped by the
> > PVT, we must use a unique pair for each bridge.
> >
> > Fortunately, there is typically lots of unused address space in most
> > switch trees. When was the last time you saw an mv88e6xxx product
> > using more than 4 chips? Even if you found one with 16 (!) devices,
> > you would still have room to allocate 16*16 virtual ports to software
> > bridges.
> >
> > Therefore, the mv88e6xxx driver will allocate a virtual device/port
> > pair to each bridge that it offloads. All members of the same bridge
> > are then configured to allow packets from this virtual port in their
> > PVTs.
>
> So while this solution is cute, it does not work in this example:
>
>  CPU
>   | .-----.
> .-0-1-. .-0-1-.
> | sw0 | | sw1 |
> '-2-3-' '-2-3-'
>
> - [sw0p2, sw1p2] are attached to one bridge
> - [sw0p3, sw1p3] are attached to another bridge
> - Neither bridge uses VLAN filtering
>
> Since no VLAN information available in the frames, the source addresses
> of FORWARDs sent over the DSA link (sw0p1, sw1p0) cannot possibly be
> separated into different FIDs. They will all be placed in the respective
> port's default FID. Thus, the two bridges are not isolated with respect
> to their FDBs.
>
> My current plan is therefore to start by reworking how bridges are
> isolated on mv88e6xxx. Roughly by allocating a reserved VID/FID pair for
> each non-filtering bridge. Two of these can be easily managed since both
> VID 0 and 4095 are illegal on the wire but allowed in the VTU - after
> that it gets tricky. The best scheme I have come up with is to just grab
> an unused VID when adding any subsequent non-filtering bridge; in the
> event that that VID is requested by a filtering bridge or a VLAN upper,
> you move the non-filtering bridge to another currently unused VID.
>
> Does that sound reasonable?

I don't think this patch series makes the problem you are describing any
worse than it already is in mainline, does it?

I mean even with multiple VLAN-unaware bridges spanning the same single
switch chip today, it is still true that you can not have two stations
with the same MAC address, one in one bridge and another in the other
bridge, right?

Do you have an example when this causes issues that need to be addressed
immediately?

I thought the only case where this is a real problem is when you have
multiple CPU ports or multiple DSA links between 2 switches, because
then, if learning is enabled, that same MAC address will bounce between
the 2 ports. For that case, the consensus was that you just can't enable
address learning on those ports, and you let the software manage the FDB
in a way that is compatible with multiple CPU ports / DSA links (install
the MAC DA as a sort of multicast address and let the port forwarding
matrix choose only one of the 2 destinations based on source port).

Lack of FDB partitioning also used to be a problem when the standalone
ports were left to do address learning, but that changed too.

The hardware I am working with simply does not have any way to solve
this either - the FDB is simply not partitionable without VLAN
filtering (we have simple shared VLAN filtering, where the VID is
ignored and the FDB lookup is performed with VID 0, but not anything
more complex). So the simple solution I've been advising for people who
want their MAC addresses to be isolated is to create a single VLAN-aware
bridge and manage the VLAN broadcast domains themselves - that seems to
work and is simple to understand and flexible (note that I am going to
send a patch at some point to prevent the user from partitioning a
sja1105 switch tree into multiple VLAN-aware bridges).

Basically unless I'm misunderstanding something, I think what you're
proposing makes theoretical sense, but without a use case behind it it
might just be too much work with no real life benefit.
