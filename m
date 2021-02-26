Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED2B632634E
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 14:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbhBZN3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 08:29:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbhBZN3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 08:29:18 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0364AC06178A
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 05:28:38 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id b21so3822990eja.4
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 05:28:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=tIaDaKf7Q5vEQhYUlynvCJ/1cWr8O4GPPzWjK9MZvd8=;
        b=UvseYQN4tL1UM4k72Eq7nuEyrejcp12fUzKITXs+c+3siVikGs5QM/Cg5LCtUjMnAj
         UDtDArxClTyrztirndaF9VmqepnAhd97Sf3Lrh3+1Za2oBpu3MtTd0dcw/YHmFbIQ6HQ
         DCIwabccQSbhnvliCcYQyPUgvS0pMekP/DaQ48J4IeChRJWq8kpjVWelYrbT6ysGKy+L
         o+dfhZa2WOMlbD0sAz4SKPdCUWBqA8zm8XLtIYyFfznJu154EKT+s827Xxk6WEgTuuXx
         zaxz3htcr32D0o4EYpYyot4kg5WDbs4dg51l48bvA+vtyTw+Ih+sJ0VIkKJ8J0evO26p
         coCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=tIaDaKf7Q5vEQhYUlynvCJ/1cWr8O4GPPzWjK9MZvd8=;
        b=ixjAZ3cvh8l06SpMBOEk1+yO7G8bFodMpymEdFhFFVgH7M8g/PB8BcVsebVo/tMEme
         rJuMVRqeRghjJsumBpTLZIJEu22TMPaLSISvLvKog7enN+SXtNKpyKL4rwbINUrvKNRc
         6we8WUYtEubV94qS9m79w2QzCEUzsXVAar1OiiBS62Y/hvC+jh/aDA8sITCA9lEmCdUq
         r8TPRAI7A/eyPcQSEC228tINBOh8jGMBhF70bhY7ojUtiTbZGB0Qh4LcosKyfuEukQFi
         7ZyxCHpOmnB1o8kkR06MEJ7ltmUK7Ci005cGgS8cuQEFWi2zos/eMvrIcKgqB9KCEjjT
         MsyA==
X-Gm-Message-State: AOAM532vm0TdIbfF7PBhpLqjvUqvlmbJ2cvY27DPxQhChYwAZtkmC6k6
        khj0jea4Ij8dc99kCvuHiRS3lXu64iI=
X-Google-Smtp-Source: ABdhPJwILMKkf8jx830wmjmcXXD/0Ex1LfANeCaK9P3TsO+U9wkhiMIX8RAZdCTXqdHPNDqzqPTVTg==
X-Received: by 2002:a17:906:dfcc:: with SMTP id jt12mr3381660ejc.31.1614346116524;
        Fri, 26 Feb 2021 05:28:36 -0800 (PST)
Received: from skbuf ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id h22sm613764eji.80.2021.02.26.05.28.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 05:28:35 -0800 (PST)
Date:   Fri, 26 Feb 2021 15:28:34 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
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
Subject: Re: [RFC PATCH v2 net-next 06/17] net: dsa: add addresses obtained
 from RX filtering to host addresses
Message-ID: <20210226132834.dx25pq4x757acujk@skbuf>
References: <20210224114350.2791260-1-olteanv@gmail.com>
 <20210224114350.2791260-7-olteanv@gmail.com>
 <87pn0nqelj.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87pn0nqelj.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 26, 2021 at 11:59:36AM +0100, Tobias Waldekranz wrote:
> On Wed, Feb 24, 2021 at 13:43, Vladimir Oltean <olteanv@gmail.com> wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > In case we have ptp4l running on a bridged DSA switch interface, the PTP
> > traffic is classified as link-local (in the default profile, the MAC
> > addresses are 01:1b:19:00:00:00 and 01:80:c2:00:00:0e), which means it
> > isn't the responsibility of the bridge to make sure it gets trapped to
> > the CPU.
> >
> > The solution is to implement the standard callbacks for dev_uc_add and
> > dev_mc_add, and behave just like any other network interface: ensure
> > that the user space program can see those packets.
>
> So presumably the application would use PACKET_ADD_MEMBERSHIP to set
> this up?
>
> This is a really elegant way of solving this problem I think!

Yes, using the unmodified *_ADD_MEMBERSHIP UAPI was the intention.
If that is not possible, the whole idea kinda loses its appeal and we'd
be better off starting from scratch and figuring out how we'd prefer for
user space to request (exclusive) address membership.

> One problem I see is that this will not result in packets getting
> trapped to the CPU, rather they will simply be forwarded.  I.e. with
> this patch applied, once ptp4l adds the groups it is interested in, my
> HW FDB will look like this:
>
> ADDR                VID  DST   TYPE
> 01:1b:19:00:00:00     0  cpu0  static
> 01:80:c2:00:00:0e     0  cpu0  static
>
> But this will not allow these groups to ingress on (STP) blocked
> ports. AFAIK, PTP (certainly LLDP which also uses the latter group)
> should be able to do that.
>
> For mv88e6xxx (but I think this applies to most switches), there are
> roughly three ways a given multicast group can reach the CPU:
>
> 1. Trap: Packet is unconditionally redirected to the CPU, independent
>    of things like 802.1X or STP state on the ingressing port.
> 2. Mirror: Send a copy of packets that pass all other ingress policy to
>    the CPU.
> 3. Forward: Forward packets that pass all other ingress policy to the
>    CPU.
>
> Entries are now added as "Forward", which means that the group will no
> longer reach the other local ports. But the command from the application
> is "I want to see these packets", it says nothing about preventing the
> group from being forwarded. So I think the default ought to be
> "Mirror". Additionally, we probably need some way of specifying "Trap"
> to those applications that need it. E.g. ptp4l could specify
> PACKET_MR_MULTICAST_TRAP in mr_action or something if it does not want
> the bridge (or the switch) to forward it.
>
> If "Forward" is desired, the existing "bridge mdb" interface seems like
> the proper one, since it also affects other ports.

I'm not sure I understand your exact requirement.

Let me try to quote from IEEE 802.1Q-2018 clause 8.13.9 "Points of
attachment and connectivity for Higher Layer Entities". For context,
this talks about about Higher Layer Entities, aka applications such as
STP, MRP, ISIS-SPB, whose world view is as though they are connected
directly to the LAN that the bridge port is connected to, i.e. they
bypass the MAC relay (forwarding) function.

The spec says:

  Controls placed in the forwarding path have no effect on the ability
  of a Higher Layer Entity to transmit and receive frames to or from a
  given LAN using a direct attachment to that LAN (e.g., from entity A
  to LAN A); they only affect the path taken by any indirect
  transmission or reception (e.g., from entity A to or from LAN B).

Then there's this drawing:

 +-----------------------+                         +-----------------------+
 | Higher Layer Entity A |                         | Higher Layer Entity B |
 +-----------------------+                         +-----------------------+
            |                                                   |
            |     +---------------------------------------+     |
            |     |             MAC Relay Entity          |     |
            |     |                                       |     |
            |     |   Port   Filtering Database   Port    |     |
            |     |  State       Information     State    |     |
            |     |                                       |     |
            |     |     /             /             /     |     |
            +-----|---x/  x---------x/  x---------x/  x---+-----+
            |     |                                       |     |
            |     +---------------------------------------+     |
            |                                                   |
 +----------------------------+                      +----------------------------+
 |          |                 |                      |          |                 |
 |          x                 |                      |          x                 |
 |    MAC    /                |                      |    MAC    /                |
 |  Entity  / MAC_Operational |                      |  Entity  / MAC_Operational |
 |          x                 |                      |          x                 |
 |          |                 |                      |          |                 |
 +----------------------------+                      +----------------------------+
            |                                                   |
            |                                                   |
            |                                                   |
   ----------------------------                        ----------------------------
  /       LAN A               /                       /       LAN B               /
 /                           /                       /                           /
/---------------------------/                       /---------------------------/

Figure 8-20: Effect of control information on the forwarding path

A one phrase conclusion from the above is that a Higher Layer Entity
should be able to accept packets from the bridge port regardless of its
STP state, as long as the MAC is operational.

In my world view, anything sent and received through the swpN DSA
interfaces, and therefore by injection/extraction through the CPU port,
represents a Higher Layer Entity.

So the fact that your Marvell switch treats the CPU port as just another
destination for forwarding should be hidden away from the externally
observable behavior. DSA does not really support the switched endpoint
use case, we should deny attaching IP interfaces to it.

But to your point: we are currently using the .port_fdb_add and
.port_mdb_add API in DSA to install the host-filtered addresses. This is
true, and potentially incorrect, since indeed it assumes that the
underlying mechanism to trap these addresses to the CPU is through the
FDB/MDB, which will violate the expectation of Higher Layer Entities
since it goes through the forwarding process. I think we could add a new
set of APIs in DSA, something like .host_uc_add and .host_mc_add. Then,
drivers that can't do any better can go ahead and internally call their
.port_fdb_add and .port_mdb_add. Question: If we add .host_uc_add and
.host_mc_add, should these APIs be per front port? And if they should,
should we leave the switch driver the task of reference counting them?


As to why does IEEE 1588 use 01-80-C2-00-00-0E for peer delay in its
default profile for the L2 transport, I could only find this (quoting
clause "F.3 Multicast MAC Addresses"):

  To ensure peer delay measurements on ports blocked by (Rapid/Multiple)
  Spanning Tree Protocols, a reserved address, 01-80-C2-00-00-0E, shall be
  used as a Destination MAC Address for PTP peer delay mechanism messages.

Basically, unlike end-to-end delay measurements, peer delay is by
definition point-to-point, which in an L2 network mean link-local.
So if your LAN uses the peer delay measurement protocol, then all your
switches must have some sort of PTP awareness. There are 2 cases really:
- You are a Peer-to-peer Transparent Clock, so you must speak the Peer
  Delay protocol yourself. Therefore you must have a Higher Layer Entity
  that consumes the PTP PDUs. So for this case, it doesn't really make
  any difference that the reserved bridge MAC address range is used.
- You are an End-to-end Transparent Clock. These are an oddity of the
  1588 standard which do not speak the Peer Delay protocol, but are
  allowed to forward Peer Delay messages, and update the correctionField
  of those Peer Delay messages that are Events (contain timestamps).
  I would think that this is where having a reserved address for the
  Peer Delay messages would make a difference.


Then, there seems to be the second part of your request, that of address
exclusivity. I think that for addresses that should explicitly be
removed from the hardware data path, the tc-trap action was created for
that exact purpose. However, the question really becomes: does PTP care
enough to know it's running on top of a switchdev interface, so that it
should claim exclusive ownership of that multicast group, or should it
just care enough to say "hey, I'm here, I'm interested in it too"?

For one thing, the 01-80-c2-00-00-0e multicast group is shared, even
IEEE 1588 says so:

  NOTE 2: At its July 17−20, 2006 meeting the IEEE 802.1 Working Group
  approved a motion that included the following text: "re-designate the
  reserved address currently identified for use by 802.1AB as an address
  that can be used by protocols that require the scope of the address to
  be limited to an individual LAN" and "The reserved multicast address
  that IEEE 1588 should use is 01-80-C2-00-00-0E." This address is not
  reserved exclusively for PTP, but rather it is a shared address.

and the bridge driver also supports this odd attribute:

  group_fwd_mask MASK - set the group forward mask. This is the bitmask
  that is applied to decide whether to forward incoming frames destined
  to link-local addresses, ie addresses of the form 01:80:C2:00:00:0X
  (defaults to 0, ie the bridge does not forward any link-local frames).

which by the way seems to be in blatant contradiction of clause
8.13.4 Reserved MAC addresses: "Any frame with a destination address
that is a reserved MAC address shall not be forwarded by a Bridge".

So if ptp4l was to install a trap action by itself, it would potentially
interact in unexpected ways with other uses of that address on the same
system.

Thoughts?
