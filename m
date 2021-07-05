Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09B483BB61E
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 06:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbhGEEXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 00:23:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbhGEEXE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 00:23:04 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C5C4C061574
        for <netdev@vger.kernel.org>; Sun,  4 Jul 2021 21:20:28 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id a127so15600439pfa.10
        for <netdev@vger.kernel.org>; Sun, 04 Jul 2021 21:20:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=z2a8D3d1MYOEkel+J6p5R679vD1Jm3PLOrfWEeKX19g=;
        b=tl/bb/DioePjWoIieSaNwVpuYF0Kh6AgpVOG8liXDXY0/bjEOz1acDUtASGlcEpDGo
         5eDgDB0DUpdK2ZORbI+/MOGFj21iwWKik+ryJJQ9DeDm7B9a6JxTOS0Bk0WXvQkSO8gd
         Dc3kPFAZAqdOxCWuMagxXVTZNqOHd0Lfz5BDqp4sfVLAJ3/7FOb29LxiDyJR6MGMmlk9
         3KBTIb0ZezvTW7wWHtqeSlWMqIrIVFdAovmZSU8blDx8jBFpL6pas6fkskWGd7sfwcgP
         V2rpDovNC5d2O1CRLu4ho/tSQf1LpT8mdQe7TwA4BwwF0JSGigA2wzY6QziHMfAZzzWV
         OI5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=z2a8D3d1MYOEkel+J6p5R679vD1Jm3PLOrfWEeKX19g=;
        b=S+U+axB6lta2dN1X7xBBiSwcIu86GCgkdEVFkXkG1272ZQBwfJkz5IFqyRhq/10+6C
         GqB8oAhv/Ps1pcd48GnUh+qQBE/uxvUKn73SBUWqxrVDQnuw/KYQJy5H/8CNfmK0Pi2p
         1BiFLBqWkMVEZ1kY7Wt4TZhnE7xNNJeG/HbW13u++dY1MyHkKI7e7wC4RUJO4JQXHuF3
         Cki4EF1RjBpfpdHJxAKIjcxz+hrkL/jQMncDtCAiK7LXAslEUoXno2qy3eAn7zBX2WR/
         5CHd3A6LPrhHCQAt2u3eza0EldxBCTAEX9eWzYadLnx4TpjA6YxlD175nFBSlAm3K21t
         6/+g==
X-Gm-Message-State: AOAM532Ko3CywmjaNK/v14XQidNQJj304BVXmv2KFkWs3CgOIrOjITD3
        skVqKXgwmGVqdgdwD/LUUfk=
X-Google-Smtp-Source: ABdhPJx3pRB3e8q3X6O2Vxlcuo1j0R4rch6WCbuQdGFXlzXoBD4SSCRk2U0vFAxYT37nhdPjH6hu/A==
X-Received: by 2002:a63:ec15:: with SMTP id j21mr13457554pgh.54.1625458827524;
        Sun, 04 Jul 2021 21:20:27 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id g2sm10054942pjd.55.2021.07.04.21.20.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jul 2021 21:20:26 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [RFC PATCH v2 net-next 00/10] Allow forwarding for the software bridge data path to be offloaded to capable devices
Date:   Mon,  5 Jul 2021 12:20:18 +0800
Message-Id: <20210705042018.137390-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210703115705.1034112-1-vladimir.oltean@nxp.com>
References: <20210703115705.1034112-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Sat, Jul 03, 2021 at 02:56:55PM +0300, Vladimir Oltean wrote:
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
> 
> The data plane of the software bridge can be partially offloaded to
> switchdev, in the sense that we can trust the accelerator to:
> (a) look up its FDB (which is more or less in sync with the software
>     bridge FDB) for selecting the destination ports for a packet
> (b) replicate the frame in hardware in case it's a multicast/broadcast,
>     instead of the software bridge having to clone it and send the
>     clones to each net device one at a time. This reduces the bandwidth
>     needed between the CPU and the accelerator, as well as the CPU time
>     spent.

Many DSA taggers use port bit field in their TX tags, which allows
replication in hardware. (multiple bits set = send to multiple ports)
I wonder if the tagger API can be updated to support this.

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
> pair to an allowed set of egress ports. In order to have a FORWARD
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
> 
