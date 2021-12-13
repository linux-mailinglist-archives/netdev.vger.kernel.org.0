Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 448A3473683
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 22:22:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243112AbhLMVWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 16:22:50 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:24983 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242541AbhLMVWt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 16:22:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1639430569; x=1670966569;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=cKtFyUbI5ZsEwn1LRJFwjr2PXAzJJzJwsh+m9VKYxxE=;
  b=cF0SiJAOzU3xhenVS/jnS+bLebddY61P18J31UaKe5p+PoTLKye3jfp5
   wECfkVxDT5Beyk6N+EBm+dgjwexqCjCYbEzfoPmifLMnfrAAUb+37TfEg
   HU1idbXbkDdgeioNZIFCLHUi2T2NO7WLRbf8fNyHIkn2wjn77BUmeNaxS
   NgCNOxRPX3IvqNVTJHeeZrrE8fzKvSHniWsQGDWH0drWYKeYBC5Rr7v/8
   JTNvqwhDk8l78XrG3MsruLZpRIHZwl2oGwwBXAnMB8JvTsTbHdQaUiX4j
   cMlLe60qiDudxGFb/UL3jDBfaM1ox2b/1A8qZ8WHs4uNMCMlTvjw9nmVH
   Q==;
IronPort-SDR: qA68z5EI12sk354P2mIZi7vNvZYWcqA3eVs3BotYeit2DNPnlRpT2TILACruL/cEcUv6aBskBe
 +a4abMmkdKHYGL7p5eRmPNP+CXGkBAeI+/nGazy1e+ALtaGvcEPPmTotvtiPO8Fe8rs3l+gN40
 KxTWh1tfIzARmLKLgWUwKKzRGsuRj0rwpWEzqW4lfAX5o+Tvo+vqKHY3RU3MM4K4vBnFHDuPMN
 h3RHYr+yL6ig10bEt6YQ1kA82usVkMAVQGyDHKkBD8mKVA5G01bitrnQjKgzsL1ib5CPpJm/fD
 imHSFF7Ma3Rqj6jOTZvLLvg7
X-IronPort-AV: E=Sophos;i="5.88,203,1635231600"; 
   d="scan'208";a="79411415"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Dec 2021 14:22:48 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 13 Dec 2021 14:22:48 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Mon, 13 Dec 2021 14:22:47 -0700
Date:   Mon, 13 Dec 2021 22:24:50 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH net-next v3 6/6] net: lan966x: Add switchdev support
Message-ID: <20211213212450.ldu5budcx7ybe3nb@soft-dev3-1.localhost>
References: <20211209094615.329379-1-horatiu.vultur@microchip.com>
 <20211209094615.329379-7-horatiu.vultur@microchip.com>
 <20211209133616.2kii2xfz5rioii4o@skbuf>
 <20211209164311.agnofh275znn5t5c@soft-dev3-1.localhost>
 <20211213102529.tzdvekwwngo4zgex@soft-dev3-1.localhost>
 <20211213134319.dp6b3or24pl3p4en@skbuf>
 <20211213142656.tfonhcmmtkelszvf@soft-dev3-1.localhost>
 <20211213142907.7s74smjudcecpgik@skbuf>
 <20211213152824.22odaltycnotozkw@soft-dev3-1.localhost>
 <20211213162504.gc62jvm6csmymtos@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20211213162504.gc62jvm6csmymtos@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 12/13/2021 16:25, Vladimir Oltean wrote:
> 
> On Mon, Dec 13, 2021 at 04:28:24PM +0100, Horatiu Vultur wrote:
> > The 12/13/2021 14:29, Vladimir Oltean wrote:
> > >
> > > On Mon, Dec 13, 2021 at 03:26:56PM +0100, Horatiu Vultur wrote:
> > > > > They are independent of each other. You deduce the interface on which
> > > > > the notifier was emitted using switchdev_notifier_info_to_dev() and act
> > > > > upon it, if lan966x_netdevice_check() is true. The notifier handling
> > > > > code itself is stateless, all the state is per port / per switch.
> > > > > If you register one notifier handler per switch, lan966x_netdevice_check()
> > > > > would return true for each notifier handler instance, and you would
> > > > > handle each event twice, would you not?
> > > >
> > > > That is correct, I will get the event twice which is a problem in the
> > > > lan966x. The function lan966x_netdevice_check should be per instance, in
> > > > this way each instance can filter the events.
> > > > The reason why I am putting the notifier_block inside lan966x is to be
> > > > able to get to the instance of lan966x even if I get a event that is not
> > > > for lan966x port.
> > >
> > > That isn't a problem, every netdevice notifier still sees all events.
> >
> > Yes, that is correct.
> > Sorry maybe I am still confused, but some things are still not right.
> >
> > So lets say there are two lan966x instances(A and B) and each one has 2
> > ports(ethA0, ethA1, ethB0, ethB1).
> > So with the current behaviour, if for example ethA0 is added in vlan
> > 100, then we get two callbacks for each lan966x instance(A and B) because
> > each of them registered. And because of lan966x_netdevice_check() is true
> > for ethA0 will do twice the work.
> > And you propose to have a singleton notifier so we get only 1 callback
> > and will be fine for this case. But if you add for example the bridge in
> > vlan 200 then I will never be able to get to the lan966x instance which
> > is needed in this case.
> 
> I'm not sure what you mean by "you add the bridge in vlan 200" with
> respect to netdevice notifiers. Create an 8021q upper with VID 200 on
> top of a bridge (as that would generate a NETDEV_CHANGEUPPER)?

I meant the following:

ip link add name brA type bridge
ip link add name brB type bridge
ip link set dev ethA0 master brA
ip link set dev ethA1 master brA
ip link set dev ethB0 master brB
ip link set dev ethB1 master brB
bridge vlan add dev brA vid 200 self

After the last command both lan966x instances will get a switchdev blocking
event where event is SWITCHDEV_PORT_OBJ_ADD and obj->id is
SWITCHDEV_OBJ_ID_PORT_VLAN. And in this case the
switchdev_notifier_info_to_dev will return brA.

> If there's a netdevice event on a bridge, the singleton netdevice event
> handler can see if it is a bridge (netif_is_bridge_master), and if it
> is, it can crawl through the bridge's lower interfaces using
> netdev_for_each_lower_dev to see if there is any lan966x interface
> beneath it. If there isn't, nothing to do. Otherwise, you get the
> opportunity to do something for each port under that bridge.

If I start to use switchdev_handle_port_obj_add, then as you mention
will get a callback for each interface under the port and then I need to
look in obj->orig_dev to see if it was a bridge or was a port that was
part of the bridge.

If I don't use switchdev_handle_port_obj_add and implement own function
then there is no way to get to the lan966x instance. I will get two
callbacks but then they can be filtered based on the bridge. If I use
switchdev_handle_port_obj_add then if I have 2 ports under the bridge,
both ports will be called which will do the same work anyway.

So I am not sure how much I will benefit of using
switchdev_handle_port_obj_add in this case.

One important observation in the driver is that I am separating these 2
cases:

bridge vlan add dev brA vid 300 self
bridge vlan add dev ethA0 vid 400

> Maybe I'm not understanding what you're trying to accomplish that's different?

The reason is that I want to use brA to control the CPU port. To decide
which frames to be copy to the CPU. Also to copy as few as possible
frames to CPU.

If we still want to go with the approach of using a singleton notifier
block, then we will still have a problem for netdevice notifier block.
We will get the same issue, can't get to lan966x instance in case the
lan966x callback is called for a different device. And we need this for
the following case:

If for example eth0, eth1 are part of a different IP and eth2, eth3 are
part of lan966x. We would like not to be able to put under the same
bridge interfaces that are part of different IPs (more precisely,
lan966x interfaces can be only under a bridge where lan966x interfaces
are part).

For example the following command should fail:
ip link add name br0 type bridge
ip link set dev eth0 master br0
ip link set dev eth2 master br0

Also the this command should fail:
ip link add name br0 type bridge
ip link set dev eth2 master br0
ip link set dev eth0 master br0

But the following should be accepted:
ip link add name br0 type bridge
ip link set dev eth0 master br0
ip link set dev eth1 master br0
ip link add name br1 type bridge
ip link set dev eth2 master br1
ip link set dev eth3 master br1

Maybe I should also make it explictly that is not allow to have more
than one instance of lan966x for now. And once is needed then add
support for it.

> 
> > That is why if the lan966x_netdevice_check would be per instance, then
> > we can filter like before, we still get call twice but then we filter for
> > each instance. We get the lan966x instance from notifier_block and then
> > we can check if the port netdev_ops is the same as the lan966x
> > netdev_ops.
> >
> > And in the other case we will still be able to get to the lan966x instance
> > in case the bridge is added in a vlan.
> >
> > > DSA intercepts a lot of events which aren't directly emitted for its own
> > > interfaces. You don't gain much by having one more, if anything.
> > >
> > > > > notifier handlers should be registered as singletons, like other drivers
> > > > > do.
> > > >
> > > > It looks like not all the other driver register them as singletone. For
> > > > example: prestera, mlx5, sparx5. (I just have done a git grep for
> > > > register_switchdev_notifier, I have not looked in details at the
> > > > implementation).
> > >
> > > Not all driver writers may have realized that it is an issue that needs
> > > to be thought of.
> >
> > --
> > /Horatiu

-- 
/Horatiu
