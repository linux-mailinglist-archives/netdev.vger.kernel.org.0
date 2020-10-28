Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 434B429D78E
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:25:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732953AbgJ1WZe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:25:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732899AbgJ1WZc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:25:32 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACF34C0613CF
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 15:25:31 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id y16so996260ljk.1
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 15:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=q1Gl3OwxpNfDiLTo1PawUEj+eAC7GRaQDxZXZmgtnDw=;
        b=QsbrrC1oJG53pGmD1cLkJXz7xMgtracbE9HIhzh7tiCdtlezZ7IgISjcK3FlXYFJ69
         u2C1TXufNbVIgewLLb3e0+ZMr8yrNh7N/NJF2MK+KDiSf4iCZmmIkopg2XDfTc/78hqq
         kW0IOnFSavZgUfkW7BzuQwYnNyjaGA7C8X1jySsoWmEl2LvWaQvN37bpM+8LwkN4N7Pg
         KwXGVtWnLMS0qiQldIACLbClQLxln2mvn2PXEtJXrNARyKLM61miAhcmA4VOIS/6vvln
         KSUHNLLp+CuSxoZYP68OIDVa+MMj5VwTu2g76KxvyTPqT4kx/mHRxoJzrqEgq7ScErmX
         1hXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=q1Gl3OwxpNfDiLTo1PawUEj+eAC7GRaQDxZXZmgtnDw=;
        b=bnHHDbqkZbW9j5pqSDw+so8KA9EMc7tTCbFBWzhNNv9AoUWwU+2+PtTXOFqmZLz+Z9
         L6Oxr9oJEXp/DlabPiOOqXPRAHH5I7yrbJKnAYPpsMdvfhHWAyvqKXk/vJUwCwDnI1Wq
         3rf4nobjgxFXs9TM41R3Ntbo9ZgdG2rD4qjMYDkj2Ayhvn+F0zdWOISxrFUhHJ7ZpsR0
         WcN05pOvm7lWtT6V1fWsHFXZARfjq9L/DHGmsmNY1pmTvMzzJa1tnSrunEndo51YKABJ
         sA2+3xeBSBQVgN+M1qlqSSlVnol9fU2j4PY4CVRcJH/2ZPwbUmOKlYoWnGG4KY+RmxQ7
         7MlQ==
X-Gm-Message-State: AOAM532x2yoRET3xk5HxQGu8tqhpoKP+ERbNezjkFYJPjmg/+0VADHCy
        iQmSDT2jiCZSf5VyyCNG2ECUtQE7n1U=
X-Google-Smtp-Source: ABdhPJwTMqFMNFBmkx3KJPfeNzKqkI8r6dRQvz/qwqIB5hAC3vmYcGUNd8sdQEQt/jRDrurYkn0g2g==
X-Received: by 2002:a17:907:118c:: with SMTP id uz12mr515441ejb.98.1603910806028;
        Wed, 28 Oct 2020 11:46:46 -0700 (PDT)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id l20sm261590edr.56.2020.10.28.11.46.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 11:46:45 -0700 (PDT)
Date:   Wed, 28 Oct 2020 20:46:44 +0200
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
Message-ID: <20201028184644.p6zm4apo7v4g2xqn@skbuf>
References: <CA+h21hoJwjBt=Uu_tYw3vv2Sze28iRdAAoR3S+LFrKbL6-iuJQ@mail.gmail.com>
 <20200525194808.GA1449199@splinter>
 <CA+h21hq+TULBNRHJRN-_UwR8weBxgzT5v762yNzzkRaM2iGx9A@mail.gmail.com>
 <20200526140159.GA1485802@splinter>
 <CA+h21hqTxbPyQGcfm3qWeD80qAZ_c3xf2FNdSBBdtOu2Hz9FTw@mail.gmail.com>
 <20200528143718.GA1569168@splinter>
 <20200720100037.vsb4kqcgytyacyhz@skbuf>
 <20200727165638.GA1910935@shredder>
 <20201027115249.hghcrzomx7oknmoq@skbuf>
 <20201028144338.GA487915@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201028144338.GA487915@shredder>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 04:43:38PM +0200, Ido Schimmel wrote:
> In "standalone" mode your netdev is like any other netdev and if it does
> not support Rx filtering, then pass everything to the CPU and let it
> filter what it does not want to see. I don't see the problem.  This is
> exactly what mlxsw did before L3 forwarding was introduced. As soon as
> you removed a netdev from a bridge we created an internal bridge between
> the port and the CPU port and flooded everything to the CPU.

Of course I was thinking about the better case where the netdev would
implement NETIF_F_UNICAST_FLT. If it would support filtering when
bridged, it would seem natural to me to also support it when not bridged.

> > > > My interpretation of the meaning of dev_uc_add() for switchdev (and
> > > > therefore, of its opposite - promiscuous mode) is at odds with previous
> > > > work done for non-switchdev. Take Vlad Yasevich's work "[Bridge] [PATCH
> > > > net-next 0/8] Non-promisc bidge ports support" for example:
> > > > 
> > > > https://lists.linuxfoundation.org/pipermail/bridge/2014-May/008940.html
> > > > 
> > > > He is arguing that a bridge port without flood&learn doesn't need
> > > > promiscuous mode, because all addresses can be statically known, and
> > > > therefore, he added code to the bridge that does the following:
> > > > 
> > > > - syncs the bridge MAC address to all non-promisc bridge slaves, via
> > > >   dev_uc_add()
> > > > - syncs the MAC addresses of all static FDB entries on all ingress
> > > >   non-promisc bridge slave ports, via dev_uc_add()
> > > > 
> > > > with the obvious goal that "the bridge slave shouldn't drop these
> > > > packets".
> > > 
> > > Lets say all the ports are not automatic (using Vlad's terminology),
> > > then packets can only be forwarded based on FDB entries. Any packets
> > > with a destination MAC not in the FDB will be dropped by the bridge.
> > > Agree?
> > > 
> > > Now, if this is the case, then you know in advance which MACs will not
> > > be dropped by the bridge. Therefore, you can program only these MACs to
> > > the Rx filters of the bridge slaves (simple NICs). That way, instead of
> > > having the bridge (the CPU) waste cycles on dropping packets you can
> > > drop them in hardware using the NIC's Rx filters.
> > 
> > _if_ there is a bridge.
> 
> But he is talking about a bridge... I don't follow. You even wrote "He
> is arguing that a bridge port". So how come there is no bridge?

Well, my problem is with the bridge's use of dev_uc_add, I'm sure you
got that by now. I would be forced to treat dev_uc_add differently
depending on whether or not I am bridged, I don't particularly like
that.

> > But if we are to introduce a new SWITCHDEV_OBJ_ID_HOST_FDB, then we
> > would be working around the problem, and the non-bridged switchdev
> > interfaces would still have no proper way of doing RX filtering.
> 
> What prevents you from implementing ndo_set_rx_mode() in your driver?

Nothing, that's exactly what I did here...

> Let me re-iterate my point again. Rx filtering determines which packets
> can be received by the port. In "standalone" mode where you do not
> support L3 forwarding I agree that the Rx filter determines which
> packets the CPU should see.
> 
> However, in the "non-standalone" mode where your netdevs are enslaved to
> a bridge that you offload, then the bridge's FDB determines which
> packets the CPU should see. The ports themselves are in promiscuous mode
> because the bridge (either SW one or HW one) wants to see all the
> received packets.

Agree. We all agree on this. However, the specifics are a bit fuzzy.

> > Take the case of IEEE 1588 packets. They should be trapped to the CPU
> > and not forwarded. But the destination address at which PTP packets are
> > sent is not set in stone, it is something that the profile decides.
> > 
> > How to ensure these packets are trapped to the CPU?
> > You're probably going to say "devlink trap", but:
> 
> I would say that it is up to the driver to configure this among all the
> rest of the PTP configuration that it needs to do. mlxsw registers the
> PTP trap during init because it is easy, but I assume we could also do
> it when PTP is enabled.

So based on the 

> > - I don't want the PTP packets to be unconditionally trapped. I see it
> >   as a perfectly valid use case for a switch to be PTP-unaware and just
> >   let somebody else terminate those packets. But "devlink trap" only
> >   gives you an option to see what the traps are, not to turn them off.
> > - The hardware I'm working with doesn't even trap PTP to the CPU by
> >   default. I would need to hardcode trapping rules in the driver, to
> >   some multicast addresses I can just guess, then I would report them as
> >   non-disableable devlink traps.
> > 
> > Applications do call setsockopt with IP_ADD_MEMBERSHIP, IPV6_ADD_MEMBERSHIP
> > or PACKET_ADD_MEMBERSHIP. However I don't see how that is turning into a
> > notification that the driver can use, except through dev_mc_add.
> > 
> > Therefore, it simply looks easier to me to stub out the extraneous calls
> > to dev_uc_add and dev_mc_add, rather than add parallel plumbing into
> > net/ipv4/igmp.c, for ports that are "promiscuous by default".
> > 
> > What do you think about this example? Isn't it something that should be
> > supported by design?
> 
> I believe it's already supported. Lets look at the "standalone" and
> "non-standalone" cases:
> 
> 1. Standalone: Your ndo_set_rx_mode() will be called and if you support
> Rx filtering, you can program your filters accordingly. If not, then you
> need to send everything to the CPU

Right, this is kind of what the patch set that we're commenting on is
doing.

> 2. Non-standalone and bridge is multicast aware: An IGMP membership
> report is supposed to be sent via the bridge device (I assume you are
> calling IP_ADD_MEMBERSHIP on the bridge device). This will cause the
> bridge to create an MDB entry indicating that packets to this multicast
> IP should be locally received. Drivers get it via the switchdev
> operation Andrew added.

I am not calling *_ADD_MEMBERSHIP on the bridge device, but on the slave
ports.

For PACKET_ADD_MEMBERSHIP, this should work as-is on swpN even if it's
bridged.

For IP_ADD_MEMBERSHIP, you would need to add some ebtables rules in
order for the bridge data path to not steal traffic on UDP ports 319 and
320 from the slave's data path.

But nonetheless, you get my point. Who will notify me of these multicast
addresses if I'm bridged and I need to terminate L2 or L4 PTP through
the data path of the slave interfaces and not of the bridge.
