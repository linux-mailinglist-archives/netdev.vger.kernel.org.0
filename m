Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEBAC474505
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 15:29:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233891AbhLNO33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 09:29:29 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:8387 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232919AbhLNO33 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 09:29:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1639492170; x=1671028170;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=RgnUyNTsyqjG9HwdXyz4NvpAzmMqYhsNzWPV5HXz11U=;
  b=gJ6BWphZkRCMvMbuV75N6ZAoDqG0r83rnCnCy8ukFnkF6toNrlZDsSLL
   pmiTcXSM8w0Yo/6E8YefAztRVXoBd7LZNUgBUU9cOnwYGe/iKmuA4Jipz
   hYKCLiF1JKd6WEamm9seouZW7jPVPleF5fVAIMjsBeJVmiMR0GNrz31Dv
   YVFWXUwp5/JcDc/HkVOCgidv89AO+dVzjX1mXS2pLOfKnKt2mn2Yyw+1q
   hFZ22rL22wP1n4kIzjkExw0KDuoptDEC5/RkjQjAb55wlLBvujpqCVENR
   sD6MaxjN0y31GbbVZp3gAw3JtU00qyKl5MNTB18d3Bd+fgjjdo34QphU1
   g==;
IronPort-SDR: u2kHEml6m7+XiSbrM9FD/huGTe3BVvEvtNsiyPliICGkt9eqFP7Z7UtXmucm65cd2FXdNnZ/gD
 CfDH/5x1BNU2WY4T21sGrtR5XJTevuKJ6rdDjIrsLV1vMvSOGk1JVSYi0p+IeAtXkxFECUCZvC
 lsbbW8bHgYeVZVquG1XQFUWpu/QRBuxKazOuaQNlw71M9/+jZ2D2+Ao84S5vjkOAaR1o3qsOiO
 ipyM5gXTf1rW/Vrc7Av1IddRwg+9EhDp//2wSe1RUByanM07MkznMP5e+4V7r2GCPNUAAmxQrv
 ZvnlTk95YRBg6z6g9jO607+m
X-IronPort-AV: E=Sophos;i="5.88,205,1635231600"; 
   d="scan'208";a="146619610"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Dec 2021 07:29:28 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 14 Dec 2021 07:29:27 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Tue, 14 Dec 2021 07:29:26 -0700
Date:   Tue, 14 Dec 2021 15:31:29 +0100
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
Message-ID: <20211214143129.his7l6juatvv3nry@soft-dev3-1.localhost>
References: <20211209133616.2kii2xfz5rioii4o@skbuf>
 <20211209164311.agnofh275znn5t5c@soft-dev3-1.localhost>
 <20211213102529.tzdvekwwngo4zgex@soft-dev3-1.localhost>
 <20211213134319.dp6b3or24pl3p4en@skbuf>
 <20211213142656.tfonhcmmtkelszvf@soft-dev3-1.localhost>
 <20211213142907.7s74smjudcecpgik@skbuf>
 <20211213152824.22odaltycnotozkw@soft-dev3-1.localhost>
 <20211213162504.gc62jvm6csmymtos@skbuf>
 <20211213212450.ldu5budcx7ybe3nb@soft-dev3-1.localhost>
 <20211214000151.xiyserx62zq2wpzh@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20211214000151.xiyserx62zq2wpzh@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 12/14/2021 00:01, Vladimir Oltean wrote:

Sorry for late reply, but I spend some time trying out your suggestions.

> 
> On Mon, Dec 13, 2021 at 10:24:50PM +0100, Horatiu Vultur wrote:
> > The 12/13/2021 16:25, Vladimir Oltean wrote:
> > >
> > > On Mon, Dec 13, 2021 at 04:28:24PM +0100, Horatiu Vultur wrote:
> > > > The 12/13/2021 14:29, Vladimir Oltean wrote:
> > > > >
> > > > > On Mon, Dec 13, 2021 at 03:26:56PM +0100, Horatiu Vultur wrote:
> > > > > > > They are independent of each other. You deduce the interface on which
> > > > > > > the notifier was emitted using switchdev_notifier_info_to_dev() and act
> > > > > > > upon it, if lan966x_netdevice_check() is true. The notifier handling
> > > > > > > code itself is stateless, all the state is per port / per switch.
> > > > > > > If you register one notifier handler per switch, lan966x_netdevice_check()
> > > > > > > would return true for each notifier handler instance, and you would
> > > > > > > handle each event twice, would you not?
> > > > > >
> > > > > > That is correct, I will get the event twice which is a problem in the
> > > > > > lan966x. The function lan966x_netdevice_check should be per instance, in
> > > > > > this way each instance can filter the events.
> > > > > > The reason why I am putting the notifier_block inside lan966x is to be
> > > > > > able to get to the instance of lan966x even if I get a event that is not
> > > > > > for lan966x port.
> > > > >
> > > > > That isn't a problem, every netdevice notifier still sees all events.
> > > >
> > > > Yes, that is correct.
> > > > Sorry maybe I am still confused, but some things are still not right.
> > > >
> > > > So lets say there are two lan966x instances(A and B) and each one has 2
> > > > ports(ethA0, ethA1, ethB0, ethB1).
> > > > So with the current behaviour, if for example ethA0 is added in vlan
> > > > 100, then we get two callbacks for each lan966x instance(A and B) because
> > > > each of them registered. And because of lan966x_netdevice_check() is true
> > > > for ethA0 will do twice the work.
> > > > And you propose to have a singleton notifier so we get only 1 callback
> > > > and will be fine for this case. But if you add for example the bridge in
> > > > vlan 200 then I will never be able to get to the lan966x instance which
> > > > is needed in this case.
> > >
> > > I'm not sure what you mean by "you add the bridge in vlan 200" with
> > > respect to netdevice notifiers. Create an 8021q upper with VID 200 on
> > > top of a bridge (as that would generate a NETDEV_CHANGEUPPER)?
> >
> > I meant the following:
> >
> > ip link add name brA type bridge
> > ip link add name brB type bridge
> > ip link set dev ethA0 master brA
> > ip link set dev ethA1 master brA
> > ip link set dev ethB0 master brB
> > ip link set dev ethB1 master brB
> > bridge vlan add dev brA vid 200 self
> 
> Ok, so the same as this use case and patch posted by Florian for DSA:
> https://lkml.org/lkml/2018/6/24/300
> we should be getting back to it some day.
> 
> > After the last command both lan966x instances will get a switchdev blocking
> > event where event is SWITCHDEV_PORT_OBJ_ADD and obj->id is
> > SWITCHDEV_OBJ_ID_PORT_VLAN. And in this case the
> > switchdev_notifier_info_to_dev will return brA.
> 
> It returns brA anyway. But the point being, your current code submission
> is something like this (of course, I had to fish these two functions
> from two different patches, because they still aren't properly split):
> 
> static int lan966x_vlan_cpu_add_vlan_mask(struct lan966x *lan966x, u16 vid)
> {
>         lan966x->vlan_mask[vid] |= BIT(CPU_PORT);
>         return lan966x_vlan_set_mask(lan966x, vid);
> }
> 
> static int lan966x_handle_port_vlan_add(struct net_device *dev,
>                                         struct notifier_block *nb,
>                                         const struct switchdev_obj_port_vlan *v)
> {
>         struct lan966x_port *port;
>         struct lan966x *lan966x;
> 
>         /* When adding a port to a vlan, we get a callback for the port but
>          * also for the bridge. When get the callback for the bridge just bail
>          * out. Then when the bridge is added to the vlan, then we get a
>          * callback here but in this case the flags has set:
>          * BRIDGE_VLAN_INFO_BRENTRY. In this case it means that the CPU
>          * port is added to the vlan, so the broadcast frames and unicast frames
>          * with dmac of the bridge should be foward to CPU.
>          */
>         if (netif_is_bridge_master(dev) &&
>             !(v->flags & BRIDGE_VLAN_INFO_BRENTRY))
>                 return 0;
> 
>         lan966x = container_of(nb, struct lan966x, switchdev_blocking_nb);
> 
>         /* In case the port gets called */
>         if (!(netif_is_bridge_master(dev))) {
>                 if (!lan966x_netdevice_check(dev))
>                         return -EOPNOTSUPP;
> 
>                 port = netdev_priv(dev);
>                 return lan966x_vlan_port_add_vlan(port, v->vid,
>                                                   v->flags & BRIDGE_VLAN_INFO_PVID,
>                                                   v->flags & BRIDGE_VLAN_INFO_UNTAGGED);
>         }
> 
>         /* In case the bridge gets called */
>         if (netif_is_bridge_master(dev))
>                 return lan966x_vlan_cpu_add_vlan(lan966x, dev, v->vid);
>                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>                 In which way does this function call, exactly, check
>                 your lan966x's relationship to that bridge?
> 
>         return 0;
> }
> 
> My point being, if you have two veth interfaces in your system just
> minding their own business and being put in an unrelated bridge, and
> that bridge would be put in VLAN 100 too, my understanding is that your
> lan966x driver would sniff that event and add its CPU port to VLAN 100
> too.  

That is correct and my initial thought was to add something like this:

if (netif_is_bridge_master(dev) && lan966x->bridge != dev)
	return 0;

> The reverse is true as well: any removal of a bridge from a VLAN
> would also cause your CPU port to stop being in that VLAN, no matter
> what interfaces may be in that VLAN. How could I say this... "spooky
> action at a distance".

But I don't need to do this if I use 'switchdev_handle_port_obj_add'

> 
> > > If there's a netdevice event on a bridge, the singleton netdevice event
> > > handler can see if it is a bridge (netif_is_bridge_master), and if it
> > > is, it can crawl through the bridge's lower interfaces using
> > > netdev_for_each_lower_dev to see if there is any lan966x interface
> > > beneath it. If there isn't, nothing to do. Otherwise, you get the
> > > opportunity to do something for each port under that bridge.
> >
> > If I start to use switchdev_handle_port_obj_add, then as you mention
> > will get a callback for each interface under the port and then I need to
> > look in obj->orig_dev to see if it was a bridge or was a port that was
> > part of the bridge.
> 
> Oh yes of course. And right now you don't need that because? You think
> you get notifications only of switchdev events emitted by bridges that
> you have a port in?

Actually I need it, it was just a comment.

> 
> > If I don't use switchdev_handle_port_obj_add and implement own function
> > then there is no way to get to the lan966x instance.
> 
> The switchdev_handle_port_obj_add() function isn't magic, and it has an
> actual public implementation, too. Sure you can get to the lan966x
> instance even if you don't use switchdev_handle_port_obj_add() -
> although, it is there for people to use it.

Yes, I can use switchdev_handle_port_obj_add and still get access to
bridge device and to lan966x instance.

> 
> > I will get two callbacks but then they can be filtered based on the
> > bridge. If I use switchdev_handle_port_obj_add then if I have 2 ports
> > under the bridge, both ports will be called which will do the same
> > work anyway.
> 
> And that's a good thing, if you actually think about how you design
> things to actually work. Please consider that you have two distinct
> events: you can join a bridge that is in a VLAN, or the bridge can join
> that VLAN while you have some ports under it. The invariant is that your
> CPU port needs to be in that VLAN only for as long as there is any port
> under that bridge. So it is actually beneficial to use the
> switchdev_handle_* helper. It tells you how many users of the CPU VLAN
> rule there still are. It would be broken to delete it right away, when a
> port leaves the bridge. It would also be broken to not delete it after
> all ports leave: the bridge may have a longer lifetime than the lan966x
> ports beneath them, so there may not be any deletion event that you
> should expect.

I have already some logic in the driver regarding this. To see how many
ports are part of a vlan and also in which vlan is the CPU.

> 
> > So I am not sure how much I will benefit of using
> > switchdev_handle_port_obj_add in this case.
> >
> > One important observation in the driver is that I am separating these 2
> > cases:
> >
> > bridge vlan add dev brA vid 300 self
> > bridge vlan add dev ethA0 vid 400
> 
> Understood, and that's ok. But I'm not convinced it works, though.

I think it would work :)

> 
> > > Maybe I'm not understanding what you're trying to accomplish that's different?
> >
> > The reason is that I want to use brA to control the CPU port. To decide
> > which frames to be copy to the CPU. Also to copy as few as possible
> > frames to CPU.
> >
> > If we still want to go with the approach of using a singleton notifier
> > block, then we will still have a problem for netdevice notifier block.
> > We will get the same issue, can't get to lan966x instance in case the
> > lan966x callback is called for a different device. And we need this for
> > the following case:
> >
> > If for example eth0, eth1 are part of a different IP and eth2, eth3 are
> > part of lan966x. We would like not to be able to put under the same
> > bridge interfaces that are part of different IPs (more precisely,
> > lan966x interfaces can be only under a bridge where lan966x interfaces
> > are part).
> >
> > For example the following command should fail:
> > ip link add name br0 type bridge
> > ip link set dev eth0 master br0
> > ip link set dev eth2 master br0
> >
> > Also the this command should fail:
> > ip link add name br0 type bridge
> > ip link set dev eth2 master br0
> > ip link set dev eth0 master br0
> >
> > But the following should be accepted:
> > ip link add name br0 type bridge
> > ip link set dev eth0 master br0
> > ip link set dev eth1 master br0
> > ip link add name br1 type bridge
> > ip link set dev eth2 master br1
> > ip link set dev eth3 master br1
> 
> You can track NETDEV_PRECHANGEUPPER and deny that, and also provide an
> extack with a reason. That should work, it's been tested.

Yes and that is what I was doing. But I had to keep a list of bridges to
see any of the bridges has any foreign interfaces. The problem was that
I kept the list on the lan966x instance, but that can be fixed easily
by making it static.

> 
> > Maybe I should also make it explictly that is not allow to have more
> > than one instance of lan966x for now. And once is needed then add
> > support for it.
> 
> I don't necessarily see the reason for this, but ok. I don't think you
> should view things as "support for parallel instances of the driver is
> what's complicating the implementation", but rather "catching the events
> in all the permutations that they can happen in is what this driver
> needs to provide a good user experience".

So long story short, I agree with your comments, I can make the
notifier_block as singleton objects and start to use
switchdev_handle_port_obj_add and the other variants.
In this way it should also work "parallel instances of the driver".

-- 
/Horatiu
