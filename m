Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E19F2371326
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 11:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233082AbhECJpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 05:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231523AbhECJpT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 05:45:19 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7AD2C06174A
        for <netdev@vger.kernel.org>; Mon,  3 May 2021 02:44:24 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id l22so6007098ljc.9
        for <netdev@vger.kernel.org>; Mon, 03 May 2021 02:44:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=OlAv0gf5bGxBurvHZprInL95fFgxTXP2KAM4AC8pLhg=;
        b=xersm7JQIv8QZcgdIjcRe6PWmqUDbX9BDIfmXKuKzlYHQ+mgluo7pU7+ek/O8YSve0
         MAaf4p7mkH55JLriXHZTOtICyNB2sL2kbjNISfy7o/XtChWQUTHfLgKCpY7m4oxe9ICp
         zvGhprdspo2PfExLRD9R2afJZXZUuaTSRFu/HAfYRUcCgZGNROeXL+y8f+YGbslFkHge
         SCI3xpMj/njv7hFo02Xg/SdqXSz17doh/OQf/kktdwmI/yFsWBtMrBQZmLvfOULtRE/H
         FQOmkflquF6xWNQ3aVMPD+YIMg3PVMOaEv76cE976hVItBGptQqB4Kab35Gz0lmYeasJ
         Z5nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=OlAv0gf5bGxBurvHZprInL95fFgxTXP2KAM4AC8pLhg=;
        b=cInWqMqUEK98mQOIzKbrBncUGQyxYZHoeZv5ucs8dBYMPQsYOMSn2m1anYIlcY1rNb
         chlHin0lZ2Nzwmyh+iQOOHFe+iyeeyd3Q1YbZ9y/EWYi9Oz8CstlHlyLhKTJFZwP9OvI
         AnTb5wTGAuo4HMqEV0IthMnSjEctX2+Dn5q1h8E7OI9T0LBqSN1EhakYwVmX61juiCR2
         AKooZhCsdtcNnVw8zWUDlpgj3Qa1/YcQtM8KYSDBKB+FWkKTtJRoOITmuzZ3vG105AIR
         IS5U0ZyNU5+F1kgCPnzendLgx2mYFQ2A6ZUlPCWbNSWJjNNVSfOWgOFEvQRUp/qx0OoK
         GG9A==
X-Gm-Message-State: AOAM531rmAgBP4IcTdFSV10erS3OoKKyMXCqlSvkKOdNCZN8WNzZHYxz
        5AVOLkY3eDAI3WQqj1dFzhfECQ==
X-Google-Smtp-Source: ABdhPJzDa81hKW+JWHxylLqY7xOMFOJFj6TF/4FA8SjOr+8RHkH9n+kYChH7vxWDF7Mf3SIIzpnaFQ==
X-Received: by 2002:a05:651c:33a:: with SMTP id b26mr12749954ljp.220.1620035063182;
        Mon, 03 May 2021 02:44:23 -0700 (PDT)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id n22sm1087863lfu.144.2021.05.03.02.44.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 May 2021 02:44:22 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        roopa@nvidia.com, nikolay@nvidia.com, jiri@resnulli.us,
        stephen@networkplumber.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [RFC net-next 0/9] net: bridge: Forward offloading
In-Reply-To: <YI6+JXDG/4K30G5L@shredder>
References: <20210426170411.1789186-1-tobias@waldekranz.com> <YI6+JXDG/4K30G5L@shredder>
Date:   Mon, 03 May 2021 11:44:21 +0200
Message-ID: <87bl9snocq.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 02, 2021 at 17:58, Ido Schimmel <idosch@idosch.org> wrote:
> On Mon, Apr 26, 2021 at 07:04:02PM +0200, Tobias Waldekranz wrote:
>> ## Overview
>> 
>>    vlan1   vlan2
>>        \   /
>>    .-----------.
>>    |    br0    |
>>    '-----------'
>>    /   /   \   \
>> swp0 swp1 swp2 eth0
>>   :   :   :
>>   (hwdom 1)
>> 
>> Up to this point, switchdevs have been trusted with offloading
>> forwarding between bridge ports, e.g. forwarding a unicast from swp0
>> to swp1 or flooding a broadcast from swp2 to swp1 and swp0. This
>> series extends forward offloading to include some new classes of
>> traffic:
>> 
>> - Locally originating flows, i.e. packets that ingress on br0 that are
>>   to be forwarded to one or several of the ports swp{0,1,2}. Notably
>>   this also includes routed flows, e.g. a packet ingressing swp0 on
>>   VLAN 1 which is then routed over to VLAN 2 by the CPU and then
>>   forwarded to swp1 is "locally originating" from br0's point of view.
>> 
>> - Flows originating from "foreign" interfaces, i.e. an interface that
>>   is not offloaded by a particular switchdev instance. This includes
>>   ports belonging to other switchdev instances. A typical example
>>   would be flows from eth0 towards swp{0,1,2}.
>> 
>> The bridge still looks up its FDB/MDB as usual and then notifies the
>> switchdev driver that a particular skb should be offloaded if it
>> matches one of the classes above. It does so by using the _accel
>> version of dev_queue_xmit, supplying its own netdev as the
>> "subordinate" device. The driver can react to the presence of the
>> subordinate in its .ndo_select_queue in what ever way it needs to make
>> sure to forward the skb in much the same way that it would for packets
>> ingressing on regular ports.
>> 
>> Hardware domains to which a particular skb has been forwarded are
>> recorded so that duplicates are avoided.
>> 
>> The main performance benefit is thus seen on multicast flows. Imagine
>> for example that:
>> 
>> - An IP camera is connected to swp0 (VLAN 1)
>> 
>> - The CPU is acting as a multicast router, routing the group from VLAN
>>   1 to VLAN 2.
>> 
>> - There are subscribers for the group in question behind both swp1 and
>>   swp2 (VLAN 2).
>
> IIUC, this falls under the first use case ("Locally originating flows").
> Do you have a need for this optimization in the forwarding case? Asking
> because it might allow us to avoid unnecessary modifications to the
> forwarding path. I have yet to look at the code, so maybe it's not a big
> deal.

Routed multicast is the most pressing issue. But being able to avoid
issues with learning on flows from the CPU (locally originating and from
foreign interfaces) is a close second. Yes you can handle the second
issue by syncing FDBs but it means lots of extra traffic over an already
congested interface (MDIO).

The overhead is pretty small in this version, and with Nikolay's
suggestions about hiding it behind a static key, it should go down to 0
in v1.

>> With this offloading in place, the bridge need only send a single skb
>> to the driver, which will send it to the hardware marked in such a way
>> that the switch will perform the multicast replication according to
>> the MDB configuration. Naturally, the number of saved skb_clones
>> increase linearly with the number of subscribed ports.
>
> Yes, this is clear. FWIW, Spectrum has something similar. You can send
> packets as either "data" or "control". Data packets are injected via the
> CPU port and forwarded according to the hardware database. Control
> packets are sent as-is via the specified front panel port, bypassing the
> hardware data path. mlxsw is always sending packets as "control".

Marvell has the same concept, but they call "data" "forward" and
"control" "from CPU". mv88e6xxx has thus far also been limited to only
sending control frames. I imagine that many chips will be able to make
use of this acceleration.

>> As an extra benefit, on mv88e6xxx, this also allows the switch to
>> perform source address learning on these flows, which avoids having to
>> sync dynamic FDB entries over slow configuration interfaces like MDIO
>> to avoid flows directed towards the CPU being flooded as unknown
>> unicast by the switch.
>
> Since you are not syncing FDBs, it is possible that you are needlessly
> flooding locally generated packets. This optimization avoids it.

Since the switchdev driver muxes incoming frames to the right port
netdev, the bridge will know the correct port to use on egress. It is
more that return traffic towards the CPU will be flooded by the switch
as unknown unicast.

.-----.   .--------.
| CPU +---0 Switch 1--- A
'-----'   | (fdb)  2--- B
          '--------'

If a ping is sent from CPU to A, A's reply will also be flooded to B
because the CPU's SA has never been seen on a "forward"/"data" packet
and therefore has never been added to the FDB.

>> 
>> 
>> ## RFC
>> 
>> - In general, what do you think about this idea?
>
> Looks sane to me

Glad to hear it, thanks!

>> - hwdom. What do you think about this terminology? Personally I feel
>>   that we had too many things called offload_fwd_mark, and that as the
>>   use of the bridge internal ID (nbp->offload_fwd_mark) expands, it
>>   might be useful to have a separate term for it.
>
> Sounds OK
>
>> 
>> - .dfwd_{add,del}_station. Am I stretching this abstraction too far,
>>   and if so do you have any suggestion/preference on how to signal the
>>   offloading from the bridge down to the switchdev driver?
>
> I was not aware of this interface before the RFC, but your use case
> seems to fit the kdoc: "Called by upper layer devices to accelerate
> switching or other station functionality into hardware".
>
> Do you expect this optimization to only work when physical netdevs are
> enslaved to the bridge? What about LAG/VLANs?

LAGs should definitely work once the .ndo_dfwd_{add,del}_station helpers
are in place.

Stacked VLANs could also be made to work. But they may require some
extra work.

In v1, the bridge will always send offloaded frames with the VLAN
information intact, even if the port is configured to egress the VID
untagged. This is needed so that the driver can determine the correct
VID to use in cases where multiple VIDs are set to egress untagged.

If any kind of VID translation takes place I think things get very
sticky. Then again, that is maybe not all that defined without this
change applied either?

What is the typical use-case for using an "external" stacked VLAN device
over configuring the VLAN inside the bridge?

>> 
>> - The way that flooding is implemented in br_forward.c (lazily cloning
>>   skbs) means that you have to mark the forwarding as completed very
>>   early (right after should_deliver in maybe_deliver) in order to
>>   avoid duplicates. Is there some way to move this decision point to a
>>   later stage that I am missing?
>> 
>> - BR_MULTICAST_TO_UNICAST. Right now, I expect that this series is not
>>   compatible with unicast-to-multicast being used on a port. Then
>>   again, I think that this would also be broken for regular switchdev
>>   bridge offloading as this flag is not offloaded to the switchdev
>>   port, so there is no way for the driver to refuse it. Any ideas on
>>   how to handle this?
>> 
>> 
>> ## mv88e6xxx Specifics
>> 
>> Since we are now only receiving a single skb for both unicast and
>> multicast flows, we can tag the packets with the FORWARD command
>> instead of FROM_CPU. The swich(es) will then forward the packet in
>> accordance with its ATU, VTU, STU, and PVT configuration - just like
>> for packets ingressing on user ports.
>> 
>> Crucially, FROM_CPU is still used for:
>> 
>> - Ports in standalone mode.
>> 
>> - Flows that are trapped to the CPU and software-forwarded by a
>>   bridge. Note that these flows match neither of the classes discussed
>>   in the overview.
>> 
>> - Packets that are sent directly to a port netdev without going
>>   through the bridge, e.g. lldpd sending out PDU via an AF_PACKET
>>   socket.
>> 
>> We thus have a pretty clean separation where the data plane uses
>> FORWARDs and the control plane uses TO_/FROM_CPU.
>> 
>> The barrier between different bridges is enforced by port based VLANs
>> on mv88e6xxx, which in essence is a mapping from a source device/port
>> pair to an allowed set of egress ports. In order to have a FORWARD
>> frame (which carries a _source_ device/port) correctly mapped by the
>> PVT, we must use a unique pair for each bridge.
>> 
>> Fortunately, there is typically lots of unused address space in most
>> switch trees. When was the last time you saw an mv88e6xxx product
>> using more than 4 chips? Even if you found one with 16 (!) devices,
>> you would still have room to allocate 16*16 virtual ports to software
>> bridges.
>> 
>> Therefore, the mv88e6xxx driver will allocate a virtual device/port
>> pair to each bridge that it offloads. All members of the same bridge
>> are then configured to allow packets from this virtual port in their
>> PVTs.
>> 
>> Tobias Waldekranz (9):
>>   net: dfwd: Constrain existing users to macvlan subordinates
>>   net: bridge: Disambiguate offload_fwd_mark
>>   net: bridge: switchdev: Recycle unused hwdoms
>>   net: bridge: switchdev: Forward offloading
>>   net: dsa: Track port PVIDs
>>   net: dsa: Forward offloading
>>   net: dsa: mv88e6xxx: Allocate a virtual DSA port for each bridge
>>   net: dsa: mv88e6xxx: Map virtual bridge port in PVT
>>   net: dsa: mv88e6xxx: Forward offloading
>> 
>>  MAINTAINERS                                   |   1 +
>>  drivers/net/dsa/mv88e6xxx/Makefile            |   1 +
>>  drivers/net/dsa/mv88e6xxx/chip.c              |  61 ++++++-
>>  drivers/net/dsa/mv88e6xxx/dst.c               | 160 ++++++++++++++++++
>>  drivers/net/dsa/mv88e6xxx/dst.h               |  14 ++
>>  .../net/ethernet/intel/fm10k/fm10k_netdev.c   |   3 +
>>  drivers/net/ethernet/intel/i40e/i40e_main.c   |   3 +
>>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |   3 +
>>  include/linux/dsa/mv88e6xxx.h                 |  13 ++
>>  include/net/dsa.h                             |  13 ++
>>  net/bridge/br_forward.c                       |  11 +-
>>  net/bridge/br_if.c                            |   4 +-
>>  net/bridge/br_private.h                       |  54 +++++-
>>  net/bridge/br_switchdev.c                     | 141 +++++++++++----
>>  net/dsa/port.c                                |  16 +-
>>  net/dsa/slave.c                               |  36 +++-
>>  net/dsa/tag_dsa.c                             |  33 +++-
>>  17 files changed, 510 insertions(+), 57 deletions(-)
>>  create mode 100644 drivers/net/dsa/mv88e6xxx/dst.c
>>  create mode 100644 drivers/net/dsa/mv88e6xxx/dst.h
>>  create mode 100644 include/linux/dsa/mv88e6xxx.h
>> 
>> -- 
>> 2.25.1
>> 
