Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB6AE475D96
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 17:36:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233914AbhLOQfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 11:35:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231538AbhLOQfC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 11:35:02 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD80C061574;
        Wed, 15 Dec 2021 08:35:02 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id z7so15577311edc.11;
        Wed, 15 Dec 2021 08:35:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=pZ+0M1N0s8PQ23qPpZrL1VB+ZXWWUhNL7iVARpa5PlQ=;
        b=bAa/h9zKnOm2xxn7rW0enx5bSkXpoxwT1jWKAS2CjLLSuwzJg4DZgWGgsyIGeOeth6
         ca5vgoorsQgBRcjA1nJHtVgXs8UYvpVS0JeKgHW9EXz+LYp7e4SZSywUxxqCEaAvwmWj
         pklWkV1uKEMMzgzXsQLwo0Ypw6h57Qyly8zbAXlQVOXiRUQKNatbFrS4dlegU8mVG3Iu
         Rzms8Tsu6T2p0/TY47ht5GEuxtPpdobAVev+zdnN+AjuJRVId5CJNoJI9N+LbiFMlesI
         2TZ4wIORMSdKBDi9Jhz9PXUKE+wqSVxOh4tot2hIWWwfZPht9hg5FB/7+9jZJZ421sLC
         WPjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=pZ+0M1N0s8PQ23qPpZrL1VB+ZXWWUhNL7iVARpa5PlQ=;
        b=ZVs0SB/afcawSN5u4CY7OcCr89KohKonDQkfB+eJsOGu+ehxJbhY1v/4VGs9yS3YUF
         /hAxwvEBo8J8l3tdqn9CCgf6WU4VPCDb31KCH46RtHyBP+3QraNHtRF9qKmDaf6lyBK8
         EnNAS87QjHOBOG9v3CXs7NhxcRcXH9It7Xr7PQOdglunOdOfaRISJ3mug5irJjw6KgVj
         N8nIZ780p614JvLqqSKXhUS7DaqRJGC0BFYaBNFyllpod6uq3U7LuyF/i7QZZIsYz9sd
         AzC1ZIXmmYYpYfrqfGvgn4/DCUCSI5J07OTxGogNU0Hzh4kxo+rocSRy63BQTys7Szvu
         H1Jg==
X-Gm-Message-State: AOAM531tzb5CDq8JiQsQemTB0zvZ2Cr9j0bVa0MDaeLD0tRT1gMsCXoC
        K9mA9AycOiazUK0KMOiZRW0=
X-Google-Smtp-Source: ABdhPJyJXXwBTZ1vGOF9xc4EV4b4PAkEUG8gBVXc0QhvIVjx8H2xlp85JEXJ9vtkCZ16etUq7s+rtw==
X-Received: by 2002:a17:907:3d88:: with SMTP id he8mr11341095ejc.565.1639586088957;
        Wed, 15 Dec 2021 08:34:48 -0800 (PST)
Received: from Ansuel-xps. (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id y10sm906625ejk.154.2021.12.15.08.34.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 08:34:48 -0800 (PST)
Message-ID: <61ba1928.1c69fb81.4ef9.360b@mx.google.com>
X-Google-Original-Message-ID: <YboZJY8BdMV0w1LT@Ansuel-xps.>
Date:   Wed, 15 Dec 2021 17:34:45 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next PATCH RFC v6 00/16] Add support for qca8k mdio rw in
 Ethernet packet
References: <20211214224409.5770-1-ansuelsmth@gmail.com>
 <20211215102629.75q6odnxetitfl3w@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211215102629.75q6odnxetitfl3w@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 15, 2021 at 12:26:29PM +0200, Vladimir Oltean wrote:
> On Tue, Dec 14, 2021 at 11:43:53PM +0100, Ansuel Smith wrote:
> > Hi, this is ready but require some additional test on a wider userbase.
> > 
> > The main reason for this is that we notice some routing problem in the
> > switch and it seems assisted learning is needed. Considering mdio is
> > quite slow due to the indirect write using this Ethernet alternative way
> > seems to be quicker.
> > 
> > The qca8k switch supports a special way to pass mdio read/write request
> > using specially crafted Ethernet packet.
> > This works by putting some defined data in the Ethernet header where the
> > mac source and dst should be placed. The Ethernet type header is set to qca
> > header and is set to a mdio read/write type.
> > This is used to communicate to the switch that this is a special packet
> > and should be parsed differently.
> > 
> > Currently we use Ethernet packet for
> > - MIB counter
> > - mdio read/write configuration
> > - phy read/write for each port
> > 
> > Current implementation of this use completion API to wait for the packet
> > to be processed by the tagger and has a timeout that fallback to the
> > legacy mdio way and mutex to enforce one transaction at time.
> > 
> > We now have connect()/disconnect() ops for the tagger. They are used to
> > allocate priv data in the dsa priv. The header still has to be put in
> > global include to make it usable by a dsa driver.
> > They are called when the tag is connect to the dst and the data is freed
> > using discconect on tagger change.
> > 
> > (if someone wonder why the bind function is put at in the general setup
> > function it's because tag is set in the cpu port where the notifier is
> > still not available and we require the notifier to sen the
> > tag_proto_connect() event.
> 
> I don't think this paragraph is true anymore, since the initial binding
> between the switch and the tagger is done from dsa_switch_setup() ->
> dsa_switch_setup_tag_protocol(), which is called once per switch (due to
> the ds->setup bool) and does not require cross-chip notifiers.
> 
> > We now have a tag_proto_connect() for the dsa driver used to put
> > additional data in the tagger priv (that is actually the dsa priv).
> > This is called using a switch event DSA_NOTIFIER_TAG_PROTO_CONNECT.
> 
> Only the dsa_tree_change_tag_proto() code path emits the cross-chip
> notifier event that you mention. The qca8k doesn't support changing the
> tagging protocol, therefore this isn't relevant.
> 
> > Current use for this is adding handler for the Ethernet packet to keep
> > the tagger code as dumb as possible.
> > 
> > The tagger priv implement only the handler for the special packet. All the
> > other stuff is placed in the qca8k_priv and the tagger has to access
> > it under lock.
> > 
> > We use the new API from Vladimir to track if the master port is
> > operational or not. We had to track many thing to reach a usable state.
> > Checking if the port is UP is not enough and tracking a NETDEV_CHANGE is
> > also not enough since it use also for other task. The correct way was
> > both track for interface UP and if a qdisc was assigned to the
> > interface. That tells us the port (and the tagger indirectly) is ready
> > to accept and process packet.
> > 
> > I tested this with multicpu port and with port6 set as the unique port and
> > it's sad.
> > It seems they implemented this feature in a bad way and this is only
> > supported with cpu port0. When cpu port6 is the unique port, the switch
> > doesn't send ack packet. With multicpu port, packet ack are not duplicated
> > and only cpu port0 sends them. This is the same for the MIB counter.
> > For this reason this feature is enabled only when cpu port0 is enabled and
> > operational.
> 
> Let's discuss this a bit (not the hardware limitation, that one is what
> it is). When DSA has multiple CPU ports, right now both host-side
> Ethernet ports are set up as DSA masters. By being a DSA master, I mean
> that dev->dsa_ptr is a non-NULL pointer, so these interfaces expect to
> receive packets that are trapped by the DSA packet_type handlers.
> But due to the way in which dsa_tree_setup_default_cpu() is written,
> by default only the first CPU port will be used. So the host port
> attached to the second CPU port will be a DSA master technically, but it
> will be an inactive one and won't be anyone's master (no dp->cpu_dp will
> point to this master's dev->dsa_ptr). My idea of DSA support for
> multiple CPU ports would be to be able to change the dp->cpu_dp mapping
> through rtnetlink, on a per user port basis (yes, this implies we don't
> have a solution for DSA ports).

I have a similar implementation that was proposed as RFC many times ago.

> My second observation is based on the fact that some switches support a
> single CPU port, yet they are wired using two Ethernet ports towards the
> host. The Felix and Seville switches are structured this way. I think
> some Broadcom switches too.
> Using the rtnetlink user API, a user could be able to migrate all user
> ports between one CPU port and the other, and as long as the
> configuration is valid, the switch driver should accept this (we perform
> DSA master changing while all ports are down, and we could refuse going
> up if e.g. some user ports are assigned to CPU port A and some user
> ports to CPU port B). Nonetheless, the key point is that when a single
> CPU port is used, the other CPU port kinda sits there doing nothing. So
> I also have some patches that make the host port attached to this other
> CPU port be a normal interface (not a DSA master).
> The switch side of things is still a CPU port (not a user port, since
> there still isn't any net device registered for it), but nonetheless, it
> is a CPU port with no DSA tagging over it, hence the reason why the host
> port isn't a DSA master. The patch itself that changes this behavior
> sounds something like "only set up a host port as a DSA master if some
> user ports are assigned to it".
> As to why I'm doing it this way: the device tree should be fixed, and I
> do need to describe the connection between the switch CPU ports and the
> DSA masters via the 'ethernet = <&phandle>;' property. From a hardware
> perspective, both switch ports A and B are CPU ports, equally. But this
> means that DSA won't create a user port for the CPU port B, which would
> be the more natural way to use it.
> Now why this pertains to you: Vivien's initial stab at management over
> Ethernet wanted to decouple a bit the concept of a DSA master (used for
> the network stack) from the concept of a host port used for in-band
> management (used for register access). Whereas our approach here is to
> keep the two coupled, due to us saying "hey, if there's a direct
> connection to the switch, this is a DSA master anyway, is it not?".
> Well, here's one thing which you wouldn't be able to do if I pursue my
> idea with lazy DSA master setup: if you decide to move all your user
> ports using rtnetlink to CPU port 6, then the DSA master of CPU port 0
> will cease to be a DSA master. So that will also prevent the management
> protocol from working.

About the migration problem, wonder if we can just use a refcount that
would represent the user of the master port. The port won't be DSA
master anymore if no user are connected. A switch can increase this ref
if the port is mandatory for some operation. (qca8k on state change
operational would increase the ref and decrease and then the port can be
removed from a DSA master) That should handle all the other switch and
still permit a driver to ""bypass"" this behaviour.

> I don't want to break your use case, but then again, I'm wondering what
> we could do to support the second CPU port working without DSA tagging,
> without changing the device trees to declare it as a user port (which in
> itself isn't bad, it's just that we need to support all use cases with a
> single, unified device tree).

Just some info about the secondary CPU port.
From Documentation the second cpu port in sgmii mode can be used also for
other task so yes we should understand how to handle this. (base-x, mac
and phy) This mode is set based on the phy mode and if the dsa port is a
cpu port. Device tree changes can be accepted as AFAIK due to DSA not
supporting multi cpu, CPU port 6 was never used/defined. (But I'm
not sure... that is the case for all the device we have on openwrt)

Considering that introducing multicpu port would require a
bit of rework, wonder if we should introduce some new bindings/node and
fallback to a legacy (aka force first cpu port as the unique cpu port
and ignore others) in the absence of this new implementation. (Hoping I
didn't get all wrong with the main problem here)
But if I'm not wrong there was at the start some years ago an idea of a
node used to declare master port separate from the generic port node but
it was rejected?

> 
> > Current concern are:
> > - Any hint about the naming? Is calling this mdio Ethernet correct?
> >   Should we use a more ""standard""/significant name? (considering also
> >   other switch will implement this)
> 
> Responded inline to this too, I think "Ethernet management" may be
> clearer than "MDIO Ethernet", but I don't have a strong preference.
> 
> > v6:
> > - Fix some error in ethtool handler caused by rebase/cleanup
> > v5:
> > - Adapt to new API fixes
> > - Fix a wrong logic for noop
> > - Add additional lock for master_state change
> > - Limit mdio Ethernet to cpu port0 (switch limitation)
> > - Add priority to these special packet
> > - Move mdio cache to qca8k_priv
> > v4:
> > - Remove duplicate patch sent by mistake.
> > v3:
> > - Include MIB with Ethernet packet.
> > - Include phy read/write with Ethernet packet.
> > - Reorganize code with new API.
> > - Introuce master tracking by Vladimir
> > v2:
> > - Address all suggestion from Vladimir.
> >   Try to generilize this with connect/disconnect function from the
> >   tagger and tag_proto_connect for the driver.
> > 
> > Ansuel Smith (12):
> >   net: dsa: tag_qca: convert to FIELD macro
> >   net: dsa: tag_qca: move define to include linux/dsa
> >   net: dsa: tag_qca: enable promisc_on_master flag
> >   net: dsa: tag_qca: add define for handling mdio Ethernet packet
> >   net: dsa: tag_qca: add define for handling MIB packet
> >   net: dsa: tag_qca: add support for handling mdio Ethernet and MIB
> >     packet
> >   net: dsa: qca8k: add tracking state of master port
> >   net: dsa: qca8k: add support for mdio read/write in Ethernet packet
> >   net: dsa: qca8k: add support for mib autocast in Ethernet packet
> >   net: dsa: qca8k: add support for phy read/write with mdio Ethernet
> >   net: dsa: qca8k: move page cache to driver priv
> >   net: dsa: qca8k: cache lo and hi for mdio write
> > 
> > Vladimir Oltean (4):
> >   net: dsa: provide switch operations for tracking the master state
> >   net: dsa: stop updating master MTU from master.c
> >   net: dsa: hold rtnl_mutex when calling dsa_master_{setup,teardown}
> >   net: dsa: replay master state events in
> >     dsa_tree_{setup,teardown}_master
> > 
> >  drivers/net/dsa/qca8k.c     | 600 ++++++++++++++++++++++++++++++++++--
> >  drivers/net/dsa/qca8k.h     |  46 ++-
> >  include/linux/dsa/tag_qca.h |  79 +++++
> >  include/net/dsa.h           |  17 +
> >  net/dsa/dsa2.c              |  81 ++++-
> >  net/dsa/dsa_priv.h          |  13 +
> >  net/dsa/master.c            |  29 +-
> >  net/dsa/slave.c             |  32 ++
> >  net/dsa/switch.c            |  15 +
> >  net/dsa/tag_qca.c           |  81 +++--
> >  10 files changed, 901 insertions(+), 92 deletions(-)
> >  create mode 100644 include/linux/dsa/tag_qca.h
> > 
> > -- 
> > 2.33.1
> > 
> 

-- 
	Ansuel
