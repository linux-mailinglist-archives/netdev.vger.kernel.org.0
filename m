Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A98E43B701D
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 11:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232804AbhF2JdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 05:33:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232614AbhF2JdZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 05:33:25 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 600FDC061574;
        Tue, 29 Jun 2021 02:30:58 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id hc16so35097604ejc.12;
        Tue, 29 Jun 2021 02:30:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yvZ97bDp9mHZT1rCoVQBF2nXHl/qApYfkPO+PBbLn+Y=;
        b=jPfMyytsSFlb6mAw83M7R3FcnzMxre1ONIxuPkEaEL0d2mRVTQGTJxOhtEUec5PgEU
         4qjYgp2gdfa2uglQDjkvYiyBMM5zfIeKsNLrhe+bXHJlwJy75T6D9jLn4xfHvG5l6tv+
         AuTAzsgcKVk0z/plhL1gSb6pTQKim5GwU/3GpebXRsprq1z+DKJtyN/ftih0iSDPCYfd
         WJkbjSSgBxMF0ahITZxEpmMfDKxDBGjZRYmDf8RGhCFeBFbH47a51dVOYPTaKBrjhT0U
         Js+n9ynnYViEI97uzI3PsLTRpTV3lh/6ED4D+CG8KAO24jk5EpTLVV6ZNf6lk5sDxYro
         podQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yvZ97bDp9mHZT1rCoVQBF2nXHl/qApYfkPO+PBbLn+Y=;
        b=KLuh7uXeCK2OTcRWf9DE0CjHWHORKfFd6AirQB8Tc3Y8UIq4/iMofxFAJ+XAuylo6v
         MgYIvd/CRfbiQYYKn8Z1qjOGHWZ4KJcsWaJN1vt7QtSZhtCGSDbA4/YF+DYT1jTal88Z
         GIY9U1lWciI7rXkHblcaBPPcLfNRZeAUws8bOX2T+11kx7SBxx5NvhSkbCrz3QgnNzGd
         tvhjh3fG21n2vYRKPuizYKBmNxuNTSkKkJ0X6L2dzQYj5fUAYfy5houPHmG6H55zDeYr
         Mh1g02K8sHdc6xcITcLVwJAHtmzy7GjwIMWInuOTHWoLlTWBvQZ/fkZqSFYRDiFQsSEO
         y7TA==
X-Gm-Message-State: AOAM532SkMz+xCfYavo9DnaocgwLb31wPEpWJr4VynusqCF8TpYPlACo
        myKsDSQ/S/zGh2/VWeZPdn8=
X-Google-Smtp-Source: ABdhPJyiiaqnCVCRQu1yBwIFPNhUwYe25/OzVZFsWf0Y0bceQGeG7TsKivopPkJDabIBqUUNyOwCrA==
X-Received: by 2002:a17:906:bfc9:: with SMTP id us9mr28498727ejb.493.1624959056878;
        Tue, 29 Jun 2021 02:30:56 -0700 (PDT)
Received: from skbuf ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id ay17sm1607026ejb.80.2021.06.29.02.30.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jun 2021 02:30:56 -0700 (PDT)
Date:   Tue, 29 Jun 2021 12:30:55 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Lukasz Majewski <lukma@denx.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Mark Einon <mark.einon@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/3] net: Provide switchdev driver for NXP's More Than IP
 L2 switch
Message-ID: <20210629093055.x5pvcebk4y4f6nem@skbuf>
References: <YNSJyf5vN4YuTUGb@lunn.ch>
 <20210624163542.5b6d87ee@ktm>
 <YNSuvJsD0HSSshOJ@lunn.ch>
 <20210625115935.132922ff@ktm>
 <YNXq1bp7XH8jRyx0@lunn.ch>
 <20210628140526.7417fbf2@ktm>
 <20210628124835.zbuija3hwsnh2zmd@skbuf>
 <20210628161314.37223141@ktm>
 <20210628142329.2y7gmykoy7uh44gd@skbuf>
 <20210629100937.10ce871d@ktm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210629100937.10ce871d@ktm>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 29, 2021 at 10:09:37AM +0200, Lukasz Majewski wrote:
> Hi Vladimir,
>
> > On Mon, Jun 28, 2021 at 04:13:14PM +0200, Lukasz Majewski wrote:
> > > > > > So before considering merging your changes, i would like to
> > > > > > see a usable binding.
> > > > > >
> > > > > > I also don't remember seeing support for STP. Without that,
> > > > > > your network has broadcast storm problems when there are
> > > > > > loops. So i would like to see the code needed to put ports
> > > > > > into blocking, listening, learning, and forwarding states.
> > > > > >
> > > > > > 	  Andrew
> > > >
> > > > I cannot stress enough how important it is for us to see STP
> > > > support and consequently the ndo_start_xmit procedure for switch
> > > > ports.
> > >
> > > Ok.
> > >
> > > > Let me see if I understand correctly. When the switch is enabled,
> > > > eth0 sends packets towards both physical switch ports, and eth1
> > > > sends packets towards none, but eth0 handles the link state of
> > > > switch port 0, and eth1 handles the link state of switch port 1?
> > >
> > > Exactly, this is how FEC driver is utilized for this switch.
> >
> > This is a much bigger problem than anything which has to do with code
> > organization. Linux does not have any sort of support for unmanaged
> > switches.
>
> My impression is similar. This switch cannot easily fit into DSA (lack
> of appending tags)

No, this is not why the switch does not fit the DSA model.
DSA assumes that the master interface and the switch are two completely
separate devices which manage themselves independently. Their boundary
is typically at the level of a MAC-to-MAC connection, although vendors
have sometimes blurred this line a bit in the case of integrated
switches. But the key point is that if there are 2 external ports going
to the switch, these should be managed by the switch driver. But when
the switch is sandwiched between the Ethernet controller of the "DSA
master" (the DMA engine of fec0) and the DSA master's MAC (still owned
by fec), the separation isn't quite what DSA expects, is it? Remember
that in the case of the MTIP switch, the fec driver needs to put the
MACs going to the switch in promiscuous mode such that the switch
behaves as a switch and actually forwards packets by MAC DA instead of
dropping them. So the system is much more tightly coupled.

 +---------------------------------------------------------------------------+
 |                                                                           |
 | +--------------+        +--------------------+--------+      +------------+
 | |              |        | MTIP switch        |        |      |            |
 | |   fec 1 DMA  |---x    |                    | Port 2 |------| fec 1 MAC  |
 | |              |        |            \  /    |        |      |            |
 | +--------------+        |             \/     +--------+      +------------+
 |                         |             /\              |                   |
 | +--------------+        +--------+   /  \    +--------+      +------------+
 | |              |        |        |           |        |      |            |
 | |   fec 0 DMA  |--------| Port 0 |           | Port 1 |------| fec 0 MAC  |
 | |              |        |        |           |        |      |            |
 | +--------------+        +--------+-----------+--------+      +------------+
 |                                                                           |
 +---------------------------------------------------------------------------+

Is this DSA? I don't really think so, but you could still try to argue
otherwise.

The opposite is also true. DSA supports switches that don't append tags
to packets (see sja1105). This doesn't make them "less DSA", just more
of a pain to work with.

> nor to switchdev.
>
> The latter is caused by two modes of operation:
>
> - Bypass mode (no switch) -> DMA1 and DMA0 are used
> - Switch mode -> only DMA0 is used
>
>
> Moreover, from my understanding of the CPSW - looks like it uses always
> just a single DMA, and the switching seems to be the default operation
> for two ethernet ports.
>
> The "bypass mode" from NXP's L2 switch seems to be achieved inside the
> CPSW switch, by configuring it to not pass packets between those ports.

I don't exactly see the point you're trying to make here. At the end of
the day, the only thing that matters is what you expose to the user.
With no way (when the switch is enabled) for a socket opened on eth0 to
send/receive packets coming only from the first port, and a socket
opened on eth1 to send/receive packets coming only from the second port,
I think this driver attempt is a pretty far cry from what a switch
driver in Linux is expected to offer, be it modeled as switchdev or DSA.

> > Please try to find out if your switch is supposed to be able
> > to be managed (run control protocols on the CPU).
>
> It can support all the "normal" set of L2 switch features:
>
> - VLANs, lookup table (with learning), filtering and forwarding
>   (Multicast, Broadcast, Unicast), priority queues, IP snooping, etc.
>
> Frames for BPDU are recognized by the switch and can be used to
> implement support for RSTP. However, this switch has a separate address
> space (not covered and accessed by FEC address).
>
> > If not, well, I
> > don't know what to suggest.
>
> For me it looks like the NXP's L2 switch shall be treated _just_ as
> offloading IP block to accelerate switching (NXP already support
> dpaa[2] for example).
>
> The idea with having it configured on demand, when:
> ip link add name br0 type bridge; ip link set br0 up;
> ip link set eth0 master br0;
> ip link set eth1 master br0;
>
> Seems to be a reasonable one. In the above scenario it would work hand
> by hand with FEC drivers (as those would handle PHY communication
> setup and link up/down events).

You seem to imply that we are suggesting something different.

> It would be welcome if the community could come up with some rough idea
> how to proceed with this IP block support

Ok, so what I would do if I really cared that much about mainline
support is I would refactor the FEC driver to offer its core
functionality to a new multi-port driver that is able to handle the FEC
DMA interfaces, the MACs and the switch. EXPORT_SYMBOL_GPL is your
friend.

This driver would probe on a device tree binding with 3 "reg" values: 1
for the fec@800f0000, 1 for the fec@800f4000 and 1 for the switch@800f8000.
No puppet master driver which coordinates other drivers, just a single
driver that, depending on the operating state, manages all the SoC
resources in a way that will offer a sane and consistent view of the
Ethernet ports.

So it will have a different .ndo_start_xmit implementation depending on
whether the switch is bypassed or not (if you need to send a packet on
eth1 and the switch is bypassed, you send it through the DMA interface
of eth1, otherwise you send it through the DMA interface of eth0 in a
way in which the switch will actually route it to the eth1 physical
port).

Then I would implement support for BPDU RX/TX (I haven't looked at the
documentation, but I expect that what this switch offers for control
traffic doesn't scale at high speeds (if it does, great, then send and
receive all your packets as control packets, to have precise port
identification). If it doesn't, you'll need a way to treat your data
plane packets differently from the control plane packets. For the data
plane, you can perhaps borrow some ideas from net/dsa/tag_8021q.c, or
even from Tobias Waldekranz's proposal to just let data plane packets
coming from the bridge slide into the switch with no precise control of
the destination port at all, just let the switch perform FDB lookups for
those packets because the switch hardware FDB is supposed to be more or
less in sync with the bridge software FDB:
https://patchwork.kernel.org/project/netdevbpf/cover/20210426170411.1789186-1-tobias@waldekranz.com/

> (especially that for example imx287 is used in many embedded devices
> and is going to be in active production for next 10+ years).

Well, I guess you have a plan then. There are still 10+ years left to
enjoy the benefits of a proper driver design...
