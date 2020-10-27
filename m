Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C61429AB36
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 12:52:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2899564AbgJ0Lwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 07:52:55 -0400
Received: from mail-ej1-f67.google.com ([209.85.218.67]:38228 "EHLO
        mail-ej1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439020AbgJ0Lwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 07:52:55 -0400
Received: by mail-ej1-f67.google.com with SMTP id ce10so1802871ejc.5
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 04:52:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TkU6hH2KnGm9OszcGcweUDMti+3FiaF5eDUNMqcFhvk=;
        b=kcXhG4xvX+Agh97+nJl/rE8txAPQI0rVv7X2Y7FCQ8NpTDBP6Zlo7qrOHYkBwirr5c
         q9yqzFvU39EKT3YUmHNETkMSZlQvS1biNXTeHzON+0RXVFxH0XDKrcHpyGDsyGICMug9
         71JM/YuZV3k4dP7BSt4VWTcMpCHyb/zKcN1fA285Lp/EyCz/OqUqznYyBqprqwNMei78
         2KhuLfkH1GiJRjqlHjFZ62dfGlf4EdmXAYgahN/3L3ikxLRT+vAMrpmM8taJO/HbQc7m
         s0sQaX6soAeaWzeL5C9WNBirwnPHfoZff7uwwT7V7UqLNIqTkSAGjfyPP+kK9ZCBQHUP
         vEyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TkU6hH2KnGm9OszcGcweUDMti+3FiaF5eDUNMqcFhvk=;
        b=WUs7wrS7qAshso1oOUvZQewMG+bNrhqHORhlqv/sM8OmpoIWrQMML8wQREyu6/I+wQ
         3lY2JT0o+vsmwXHasSIWZaZCfZnXgsZzPsGDuYAWMVEylsjaXO/C5KKYAYUSpS29tsJc
         J9SAr2k98FtX/Y7NDbdYIHpPBamVxQBcezHlUh/hIjxiuRfaSRnLfZcWcvvodBpKhuva
         pDsT87FLKcSTcOCtG1lSSismrFpcPCG7M3uIApTMALMUjtJi4Dm+pxt2exDtsNWNH7ef
         yyUP/56pIX0pUvf5VWg/u/dPJZe3VC/mDNLIjDVmnjQCeZJDJP8/nbRZUTb5bUNUqjzX
         EohA==
X-Gm-Message-State: AOAM533QW7Uonu0QbXclmAqsHiiB7jTAzGERi9vCtRo12y/opXH5pk6A
        Q/h7lu3r5/d0pZjuS6m4qXw=
X-Google-Smtp-Source: ABdhPJxZ7zf+7G6/NzVnusKKj6zGNYBZPTc0wpPMDHIsAECnBZ/GuMz60D0mk1HPl08Di0T2mnjY3Q==
X-Received: by 2002:a17:906:4d4f:: with SMTP id b15mr1981058ejv.356.1603799571736;
        Tue, 27 Oct 2020 04:52:51 -0700 (PDT)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id ks17sm883481ejb.41.2020.10.27.04.52.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 04:52:51 -0700 (PDT)
Date:   Tue, 27 Oct 2020 13:52:49 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        Ivan Vecera <ivecera@redhat.com>, vyasevich@gmail.com,
        netdev <netdev@vger.kernel.org>, UNGLinuxDriver@microchip.com,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>
Subject: Re: [PATCH RFC net-next 00/13] RX filtering for DSA switches
Message-ID: <20201027115249.hghcrzomx7oknmoq@skbuf>
References: <20200521211036.668624-1-olteanv@gmail.com>
 <20200524140657.GA1281067@splinter>
 <CA+h21hoJwjBt=Uu_tYw3vv2Sze28iRdAAoR3S+LFrKbL6-iuJQ@mail.gmail.com>
 <20200525194808.GA1449199@splinter>
 <CA+h21hq+TULBNRHJRN-_UwR8weBxgzT5v762yNzzkRaM2iGx9A@mail.gmail.com>
 <20200526140159.GA1485802@splinter>
 <CA+h21hqTxbPyQGcfm3qWeD80qAZ_c3xf2FNdSBBdtOu2Hz9FTw@mail.gmail.com>
 <20200528143718.GA1569168@splinter>
 <20200720100037.vsb4kqcgytyacyhz@skbuf>
 <20200727165638.GA1910935@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727165638.GA1910935@shredder>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ido,

On Mon, Jul 27, 2020 at 07:56:38PM +0300, Ido Schimmel wrote:
> > The whole purpose of my patch series is to remove the CPU port from the
> > flood domain of all switchdev net_devices. That means, when an unknown
> > unicast packet ingresses, it will be flooded but not to the CPU. 
> 
> Good. This is what happens in mlxsw today.
> 
> > For frames that the CPU wants to see, there should be a universal
> > mechanism for it to whitelist them, by {DMAC, VID}. Otherwise, things
> > don't scale.
> > 
> > There is one such mechanism already, and that is dev_uc_add(). It used
> > to install an address into a device's RX filter using DMAC only, and
> > Ivan Khoronzhuk's patches have added a new dev_vid_uc_add() that allow
> > additional filtering by VLAN.
> 
> Yes, but please note that when you are talking about packets the CPU
> cares about, then the device is the bridge device. Not its slaves which
> are "promiscuous by definition".

This is not completely true. A switchdev port can have a bridge upper or
not. You are only concentrating on the traffic that the bridge would be
interested in seeing, but I am also thinking of what traffic the CPU
should receive from this port in "standalone" mode. All traffic? Not
so compelling.

> > This is fundamentally because the destination MAC address is parsed by
> > a network card for _termination_ purposes. And because a switch
> > doesn't do _termination_, there is no reason to filter by destination
> > MAC (ignore ACL and such). But a Linux switchdev is capable of
> > termination. In the case of switchdev, termination means sending to
> > the CPU.
> 
> You keep saying "CPU", but it's because you are most likely only
> concerned with switches that are not capable of L3 forwarding. In mlxsw
> we never send packets from the FDB to the CPU, but to the "router port".
> There the packets (whether unicast or multicast) are routed and either
> forwarded to a different port or locally received.

I don't know nearly enough about IP forwarding offload to make a
relevant comment here.

> > 
> > My interpretation of the meaning of dev_uc_add() for switchdev (and
> > therefore, of its opposite - promiscuous mode) is at odds with previous
> > work done for non-switchdev. Take Vlad Yasevich's work "[Bridge] [PATCH
> > net-next 0/8] Non-promisc bidge ports support" for example:
> > 
> > https://lists.linuxfoundation.org/pipermail/bridge/2014-May/008940.html
> > 
> > He is arguing that a bridge port without flood&learn doesn't need
> > promiscuous mode, because all addresses can be statically known, and
> > therefore, he added code to the bridge that does the following:
> > 
> > - syncs the bridge MAC address to all non-promisc bridge slaves, via
> >   dev_uc_add()
> > - syncs the MAC addresses of all static FDB entries on all ingress
> >   non-promisc bridge slave ports, via dev_uc_add()
> > 
> > with the obvious goal that "the bridge slave shouldn't drop these
> > packets".
> 
> Lets say all the ports are not automatic (using Vlad's terminology),
> then packets can only be forwarded based on FDB entries. Any packets
> with a destination MAC not in the FDB will be dropped by the bridge.
> Agree?
> 
> Now, if this is the case, then you know in advance which MACs will not
> be dropped by the bridge. Therefore, you can program only these MACs to
> the Rx filters of the bridge slaves (simple NICs). That way, instead of
> having the bridge (the CPU) waste cycles on dropping packets you can
> drop them in hardware using the NIC's Rx filters.

_if_ there is a bridge.

> > 
> > In my interpretation of dev_uc_add(), I would have expected that:
> > - the bridge MAC address, as well as any other secondary unicast
> >   addresses that the bridge has, by means of its uppers (like macvlan,
> >   802.1q, etc) calling dev_uc_add() on it, would be synced to the bridge
> >   slaves anyway, regardless of whether they're promisc or not
> 
> Is this supposed to be related to previous paragraph about Vald's work?
> I don't really follow.

Yes, of course.

> Anyway, he specifically wrote that "There are some other cases when
> promiscuous mode has to be turned back on. One is when the bridge
> itself if placed in promiscuous mode".
> 
> When you start adding bridge uppers with different MACs then the bridge
> will enter promiscuous mode and all unknown unicast packets will be
> flooded to it. In this case packets without a matching FDB will no
> longer be dropped by the bridge and therefore the NIC can't drop them in
> hardware using its Rx filters anymore.

All would be fine if the bridge would declare IFF_UNICAST_FLT and
propagate its address lists to its slave ports somehow, either through
dev_uc_add/dev_mc_add or through SWITCHDEV_OBJ_ID_HOST_MDB [ and a new
SWITCHDEV_OBJ_ID_HOST_FDB, I can only assume ].

But if we are to introduce a new SWITCHDEV_OBJ_ID_HOST_FDB, then we
would be working around the problem, and the non-bridged switchdev
interfaces would still have no proper way of doing RX filtering.

> > - the static FDB entries are synced to the bridge ports only in the
> >   non-switchdev case. This is because for switchdev, I am treating a
> >   dev_uc_add() as a FDB entry towards the CPU, and therefore this would
> >   overwrite the FDB entry towards the external port.
> 
> OK, so this interpretation of "treating a dev_uc_add() as a FDB entry
> towards the CPU" is wrong.
> 
> You already wrote that "For a switchdev, promisc vs non-promisc doesn't
> mean a thing" and that "[dev_uc_add() is] used to install an address
> into a device's RX filter".
> 
> You can't tell me that switches do not perform Rx filtering and then
> decide to re-purpose a mechanism that is used for Rx filtering...

No, that's exactly what I'm trying to tell you...

> > 
> > In my interpretation, things would have worked neatly for the most part,
> > not only for unicast but also for multicast. For example, an application
> > wants to see a multicast stream, so it calls setsockopt(SOL_SOCKET,
> > PACKET_ADD_MEMBERSHIP, PACKET_MR_MULTICAST) with the multicast address
> > it wants to see. This is translated by the kernel into a dev_mc_add()
> > and sent to the network device. For a non-switchdev, this would have
> > been enough. For a switchdev, if I also installed the address in the
> > CPU's filter, it would have also been enough. Things 'just work' and
> > everybody's happy.
> > 
> > > When you look at it from hardware offload perspective, not every packet
> > > received by the bridge interface should reach the CPU. Actually, most
> > > should not reach it. Otherwise it would mean that every routed packet
> > > would need to go to the CPU, which is not feasible. If you can't perform
> > > routing in hardware, then yes, you need to send such packets to the CPU.
> > > 
> > > In mlxsw we can't perform MAC filtering in the router like in the
> > > software data path, so in order not to route packets we should not, we
> > > only send to the router packets with destination MACs that correspond to
> > > that of the bridge or one of its uppers. We don't flood all unknown
> > > unicast packets there.
> > > 
> > > In the case of hardware offload it's relatively easy to do this sort of
> > > tracking because only a limited set of upper devices topologies are
> > > actually supported. I'm not sure how feasible it is with every
> > > combination of upper devices supported by the kernel. It seems easiest
> > > to just put the bridge interface in promiscuous mode and let upper
> > > layers perform the filtering. Like it is today.
> > > 
> > 
> > Are you suggesting that tracking the uppers is the only way to do what I
> > want?
> 
> I don't see a different way. Your goal is to prevent flooding of unknown
> unicast packets to the CPU. If the bridge is not in promiscuous mode,
> then unknown unicast packets are not flooded to it. Only FDB entries
> pointing to the bridge device should go to the CPU.
>
> The problem starts when the bridge enters promiscuous mode. When does it
> happen? When you start adding uppers that do not inherit the bridge's
> MAC. Why? Because the bridge does not support unicast filtering. It is
> not an easy thing to do when you have multiple levels of stacked
> devices.

No, the problem doesn't start there, or end there. I just think that the
proposed solution would be incomplete if it just relied on tracking
uppers.

Take the case of IEEE 1588 packets. They should be trapped to the CPU
and not forwarded. But the destination address at which PTP packets are
sent is not set in stone, it is something that the profile decides.

How to ensure these packets are trapped to the CPU?
You're probably going to say "devlink trap", but:
- I don't want the PTP packets to be unconditionally trapped. I see it
  as a perfectly valid use case for a switch to be PTP-unaware and just
  let somebody else terminate those packets. But "devlink trap" only
  gives you an option to see what the traps are, not to turn them off.
- The hardware I'm working with doesn't even trap PTP to the CPU by
  default. I would need to hardcode trapping rules in the driver, to
  some multicast addresses I can just guess, then I would report them as
  non-disableable devlink traps.

Applications do call setsockopt with IP_ADD_MEMBERSHIP, IPV6_ADD_MEMBERSHIP
or PACKET_ADD_MEMBERSHIP. However I don't see how that is turning into a
notification that the driver can use, except through dev_mc_add.

Therefore, it simply looks easier to me to stub out the extraneous calls
to dev_uc_add and dev_mc_add, rather than add parallel plumbing into
net/ipv4/igmp.c, for ports that are "promiscuous by default".

What do you think about this example? Isn't it something that should be
supported by design?
