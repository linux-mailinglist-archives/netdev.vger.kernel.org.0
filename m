Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ACA73BAA71
	for <lists+netdev@lfdr.de>; Sun,  4 Jul 2021 00:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbhGCWHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Jul 2021 18:07:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbhGCWHF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Jul 2021 18:07:05 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3C3BC061762
        for <netdev@vger.kernel.org>; Sat,  3 Jul 2021 15:04:29 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id r20so4275419ljd.10
        for <netdev@vger.kernel.org>; Sat, 03 Jul 2021 15:04:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=okdp90Yfcba26hN1esNZqS1HVRaNvnmmGNRxv0IzGOA=;
        b=UkDNKK6P5Q6tEKjRB/ZpGzLc6DljGaMUwdfOO3uFNsCTsK6iqOOkvmQcfi/BYdsebx
         6Yq6vw3qhyPBlQJ9BoupRYOVhwKQRZePFla1TNyO+XGvAX9vudjaTSGaLRw7ZghuZPli
         2ZaTivyuOiy/O35PC7twa3732RDd7PEDgO+4zcgWQcO06dGxeM+OmJ+ZA9JedXryxxL/
         qOTd9b18JGJWiMjpzLth19IC2/XI9OjVR0fBiH+wgD1en6h9bfzJhe4izj8vrX7sNc1R
         jkKCTtszDqcUEjYq1ehWIK3Ulkjf9OIeU5AEKNgD1tOVxW0f0Ctxrqoufz3lWzaJGQgm
         fkTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=okdp90Yfcba26hN1esNZqS1HVRaNvnmmGNRxv0IzGOA=;
        b=ueBUnkbbM9Q/FCEYzmhi3G+LgzvO4Xni8ddnAuGVhRJ+UeU/g8qhDL5D9KAfsYpevp
         k+zl7a9NMUYrW3P/25p8+9W/aSUWLYHMbVQnLsX//pPjbXY3T8OdygyLsiicebigvrWr
         0mHBgKIyBAB+1o0jvJ6oreWB2Yiy73HcCPpljUv9N7Mn+BR78NWny3dp+Gw3br5Gxy3Q
         Iu3/YH6crsYXEem5hdjyOLNDv6qf9vh9Rz4yq9Qyr2CmX/B7LlvFIUWoJF6PEBkzOm5E
         cy64AvX7ATB5hfw+XeaGc6VRv6ym33bxVE2yKrBlB+7pKSg1P/AvvGpm39mk1QMiasEf
         eUUg==
X-Gm-Message-State: AOAM531z44klnlC8tID3gHcJD1Gq0QPNDKJPwPEHTNbaspHQd3Rki/RQ
        KgH8wdcdBN3Q8KtiP+wP0SWdyw==
X-Google-Smtp-Source: ABdhPJxTMAsHczz51ZHc3ERw1L5KSdX5BTupf/L8bZ9CfpJtQ4LW0DRa9vuH+SDSeGGcw/SCPy9nSQ==
X-Received: by 2002:a2e:9752:: with SMTP id f18mr2787950ljj.165.1625349867934;
        Sat, 03 Jul 2021 15:04:27 -0700 (PDT)
Received: from wkz-x280 (h-81-170-220-178.A259.priv.bahnhof.se. [81.170.220.178])
        by smtp.gmail.com with ESMTPSA id d24sm639710lfa.243.2021.07.03.15.04.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Jul 2021 15:04:27 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
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
In-Reply-To: <20210703115705.1034112-1-vladimir.oltean@nxp.com>
References: <20210703115705.1034112-1-vladimir.oltean@nxp.com>
Date:   Sun, 04 Jul 2021 00:04:26 +0200
Message-ID: <871r8f836d.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 03, 2021 at 14:56, Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
> For this series I have taken Tobias' work from here:
> https://patchwork.kernel.org/project/netdevbpf/cover/20210426170411.1789186-1-tobias@waldekranz.com/
> and made the following changes:
> - I collected and integrated (hopefully all of) Nikolay's, Ido's and my
>   feedback on the bridge driver changes. Otherwise, the structure of the
>   bridge changes is pretty much the same as Tobias left it.
> - I basically rewrote the DSA infrastructure for the data plane
>   forwarding offload, based on the commonalities with another switch
>   driver for which I implemented this feature (not submitted here)
> - I adapted mv88e6xxx to use the new infrastructure, hopefully it still
>   works but I didn't test that

Hi Vladimir,

Sorry that I have dropped the ball on this series. I have actually had a
v1 of this queued up for a while. Unfortunately I ran into mv88e6xxx
specific problems. (See below)

> The data plane of the software bridge can be partially offloaded to
> switchdev, in the sense that we can trust the accelerator to:
> (a) look up its FDB (which is more or less in sync with the software
>     bridge FDB) for selecting the destination ports for a packet
> (b) replicate the frame in hardware in case it's a multicast/broadcast,
>     instead of the software bridge having to clone it and send the
>     clones to each net device one at a time. This reduces the bandwidth
>     needed between the CPU and the accelerator, as well as the CPU time
>     spent.
>
> The data path forwarding offload is managed per "hardware domain" - a
> generalization of the "offload_fwd_mark" concept which is being
> introduced in this series. Every packet is delivered only once to each
> hardware domain.
>
> In addition, Tobias said in the original cover letter:
>
> ====================
> ## Overview
>
>    vlan1   vlan2
>        \   /
>    .-----------.
>    |    br0    |
>    '-----------'
>    /   /   \   \
> swp0 swp1 swp2 eth0
>   :   :   :
>   (hwdom 1)
>
> Up to this point, switchdevs have been trusted with offloading
> forwarding between bridge ports, e.g. forwarding a unicast from swp0
> to swp1 or flooding a broadcast from swp2 to swp1 and swp0. This
> series extends forward offloading to include some new classes of
> traffic:
>
> - Locally originating flows, i.e. packets that ingress on br0 that are
>   to be forwarded to one or several of the ports swp{0,1,2}. Notably
>   this also includes routed flows, e.g. a packet ingressing swp0 on
>   VLAN 1 which is then routed over to VLAN 2 by the CPU and then
>   forwarded to swp1 is "locally originating" from br0's point of view.
>
> - Flows originating from "foreign" interfaces, i.e. an interface that
>   is not offloaded by a particular switchdev instance. This includes
>   ports belonging to other switchdev instances. A typical example
>   would be flows from eth0 towards swp{0,1,2}.
>
> The bridge still looks up its FDB/MDB as usual and then notifies the
> switchdev driver that a particular skb should be offloaded if it
> matches one of the classes above. It does so by using the _accel
> version of dev_queue_xmit, supplying its own netdev as the
> "subordinate" device. The driver can react to the presence of the
> subordinate in its .ndo_select_queue in what ever way it needs to make
> sure to forward the skb in much the same way that it would for packets
> ingressing on regular ports.
>
> Hardware domains to which a particular skb has been forwarded are
> recorded so that duplicates are avoided.
>
> The main performance benefit is thus seen on multicast flows. Imagine
> for example that:
>
> - An IP camera is connected to swp0 (VLAN 1)
>
> - The CPU is acting as a multicast router, routing the group from VLAN
>   1 to VLAN 2.
>
> - There are subscribers for the group in question behind both swp1 and
>   swp2 (VLAN 2).
>
> With this offloading in place, the bridge need only send a single skb
> to the driver, which will send it to the hardware marked in such a way
> that the switch will perform the multicast replication according to
> the MDB configuration. Naturally, the number of saved skb_clones
> increase linearly with the number of subscribed ports.
>
> As an extra benefit, on mv88e6xxx, this also allows the switch to
> perform source address learning on these flows, which avoids having to
> sync dynamic FDB entries over slow configuration interfaces like MDIO
> to avoid flows directed towards the CPU being flooded as unknown
> unicast by the switch.
>
>
> ## RFC
>
> - In general, what do you think about this idea?
>
> - hwdom. What do you think about this terminology? Personally I feel
>   that we had too many things called offload_fwd_mark, and that as the
>   use of the bridge internal ID (nbp->offload_fwd_mark) expands, it
>   might be useful to have a separate term for it.
>
> - .dfwd_{add,del}_station. Am I stretching this abstraction too far,
>   and if so do you have any suggestion/preference on how to signal the
>   offloading from the bridge down to the switchdev driver?
>
> - The way that flooding is implemented in br_forward.c (lazily cloning
>   skbs) means that you have to mark the forwarding as completed very
>   early (right after should_deliver in maybe_deliver) in order to
>   avoid duplicates. Is there some way to move this decision point to a
>   later stage that I am missing?
>
> - BR_MULTICAST_TO_UNICAST. Right now, I expect that this series is not
>   compatible with unicast-to-multicast being used on a port. Then
>   again, I think that this would also be broken for regular switchdev
>   bridge offloading as this flag is not offloaded to the switchdev
>   port, so there is no way for the driver to refuse it. Any ideas on
>   how to handle this?
>
>
> ## mv88e6xxx Specifics
>
> Since we are now only receiving a single skb for both unicast and
> multicast flows, we can tag the packets with the FORWARD command
> instead of FROM_CPU. The swich(es) will then forward the packet in
> accordance with its ATU, VTU, STU, and PVT configuration - just like
> for packets ingressing on user ports.
>
> Crucially, FROM_CPU is still used for:
>
> - Ports in standalone mode.
>
> - Flows that are trapped to the CPU and software-forwarded by a
>   bridge. Note that these flows match neither of the classes discussed
>   in the overview.
>
> - Packets that are sent directly to a port netdev without going
>   through the bridge, e.g. lldpd sending out PDU via an AF_PACKET
>   socket.
>
> We thus have a pretty clean separation where the data plane uses
> FORWARDs and the control plane uses TO_/FROM_CPU.
>
> The barrier between different bridges is enforced by port based VLANs
> on mv88e6xxx, which in essence is a mapping from a source device/port
> pair to an allowed set of egress ports.

Unless I am missing something, it turns out that the PVT is not enough
to support multiple (non-VLAN filtering) bridges in multi-chip
setups. While the isolation barrier works, there is no way of correctly
managing automatic learning.

> In order to have a FORWARD
> frame (which carries a _source_ device/port) correctly mapped by the
> PVT, we must use a unique pair for each bridge.
>
> Fortunately, there is typically lots of unused address space in most
> switch trees. When was the last time you saw an mv88e6xxx product
> using more than 4 chips? Even if you found one with 16 (!) devices,
> you would still have room to allocate 16*16 virtual ports to software
> bridges.
>
> Therefore, the mv88e6xxx driver will allocate a virtual device/port
> pair to each bridge that it offloads. All members of the same bridge
> are then configured to allow packets from this virtual port in their
> PVTs.

So while this solution is cute, it does not work in this example:

 CPU
  | .-----.
.-0-1-. .-0-1-.
| sw0 | | sw1 |
'-2-3-' '-2-3-'

- [sw0p2, sw1p2] are attached to one bridge
- [sw0p3, sw1p3] are attached to another bridge
- Neither bridge uses VLAN filtering

Since no VLAN information available in the frames, the source addresses
of FORWARDs sent over the DSA link (sw0p1, sw1p0) cannot possibly be
separated into different FIDs. They will all be placed in the respective
port's default FID. Thus, the two bridges are not isolated with respect
to their FDBs.

My current plan is therefore to start by reworking how bridges are
isolated on mv88e6xxx. Roughly by allocating a reserved VID/FID pair for
each non-filtering bridge. Two of these can be easily managed since both
VID 0 and 4095 are illegal on the wire but allowed in the VTU - after
that it gets tricky. The best scheme I have come up with is to just grab
an unused VID when adding any subsequent non-filtering bridge; in the
event that that VID is requested by a filtering bridge or a VLAN upper,
you move the non-filtering bridge to another currently unused VID.

Does that sound reasonable?

> ====================
>
> Tobias Waldekranz (5):
>   net: dfwd: constrain existing users to macvlan subordinates
>   net: bridge: disambiguate offload_fwd_mark
>   net: bridge: switchdev: recycle unused hwdoms
>   net: bridge: switchdev: allow the data plane forwarding to be
>     offloaded
>   net: dsa: tag_dsa: offload the bridge forwarding process
>
> Vladimir Oltean (5):
>   net: extract helpers for binding a subordinate device to TX queues
>   net: allow ndo_select_queue to go beyond dev->num_real_tx_queues
>   net: dsa: track the number of switches in a tree
>   net: dsa: add support for bridge forwarding offload
>   net: dsa: mv88e6xxx: map virtual bridges with forwarding offload in
>     the PVT
>
>  drivers/net/dsa/mv88e6xxx/chip.c              | 106 +++++++++++-
>  .../net/ethernet/intel/fm10k/fm10k_netdev.c   |   3 +
>  drivers/net/ethernet/intel/i40e/i40e_main.c   |   3 +
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |   3 +
>  include/linux/if_bridge.h                     |   1 +
>  include/linux/netdevice.h                     |  13 +-
>  include/net/dsa.h                             |  37 ++++
>  net/bridge/br_forward.c                       |  18 +-
>  net/bridge/br_if.c                            |   4 +-
>  net/bridge/br_private.h                       |  49 +++++-
>  net/bridge/br_switchdev.c                     | 163 +++++++++++++++---
>  net/bridge/br_vlan.c                          |  10 +-
>  net/core/dev.c                                |  31 +++-
>  net/dsa/dsa2.c                                |   3 +
>  net/dsa/dsa_priv.h                            |  28 +++
>  net/dsa/port.c                                |  35 ++++
>  net/dsa/slave.c                               | 134 +++++++++++++-
>  net/dsa/switch.c                              |  58 +++++++
>  net/dsa/tag_dsa.c                             |  60 ++++++-
>  19 files changed, 700 insertions(+), 59 deletions(-)
>
> -- 
> 2.25.1
