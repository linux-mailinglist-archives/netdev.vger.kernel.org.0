Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40B1314A25C
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 11:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729835AbgA0K5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 05:57:50 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:18059 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729551AbgA0K5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 05:57:49 -0500
Received-SPF: Pass (esa6.microchip.iphmx.com: domain of
  Allan.Nielsen@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="Allan.Nielsen@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa6.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa6.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Allan.Nielsen@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: QNhJaTy16EpM/aRSUl1INKlDSgPRXSg+ZBFm0fN23vTOb6mIIDDFvN0HB6oe1IuL+SKDut64/s
 gRr2rSJrCi//9Qo1PALI8M+ExaBe+Z++uhxZzMqbFXbVZ2vch4JUQHUnDmZWCHEBi/9KYYGy//
 IQU0Kw/yaDn3I7i2xmxy9Eh27Ber/Dwm9BF9hpHE2UrRRUhXIGJGR8Xj78NGX/scKNyQ8l0aNB
 8YsDnI+H8zCfM5SqYTN74F/rbwBqc2Fd3uufVi8JIUhbLAenNNU63GdhL1JmHIbeXo5ey6WVSv
 Uj4=
X-IronPort-AV: E=Sophos;i="5.70,369,1574146800"; 
   d="scan'208";a="189072"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Jan 2020 03:57:48 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 27 Jan 2020 03:57:48 -0700
Received: from localhost (10.10.85.251) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Mon, 27 Jan 2020 03:57:48 -0700
Date:   Mon, 27 Jan 2020 11:57:46 +0100
From:   "Allan W. Nielsen" <allan.nielsen@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <jiri@resnulli.us>,
        <ivecera@redhat.com>, <davem@davemloft.net>,
        <roopa@cumulusnetworks.com>, <nikolay@cumulusnetworks.com>,
        <anirudh.venkataramanan@intel.com>, <olteanv@gmail.com>,
        <jeffrey.t.kirsher@intel.com>, <UNGLinuxDriver@microchip.com>
Subject: Re: [RFC net-next v3 09/10] net: bridge: mrp: Integrate MRP into the
 bridge
Message-ID: <20200127105746.i2txggfnql4povje@lx-anielsen.microsemi.net>
References: <20200124161828.12206-1-horatiu.vultur@microchip.com>
 <20200124161828.12206-10-horatiu.vultur@microchip.com>
 <20200125161615.GD18311@lunn.ch>
 <20200126130111.o75gskwe2fmfd4g5@soft-dev3.microsemi.net>
 <20200126171251.GK18311@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <20200126171251.GK18311@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26.01.2020 18:12, Andrew Lunn wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Sun, Jan 26, 2020 at 02:01:11PM +0100, Horatiu Vultur wrote:
> > The 01/25/2020 17:16, Andrew Lunn wrote:
> > > EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> > >
> > > >  br_netif_receive_skb(struct net *net, struct sock *sk, struct sk_buff *skb)
> > > > @@ -338,6 +341,17 @@ rx_handler_result_t br_handle_frame(struct sk_buff **pskb)
> > > >                       return RX_HANDLER_CONSUMED;
> > > >               }
> > > >       }
> > > > +#ifdef CONFIG_BRIDGE_MRP
> > > > +     /* If there is no MRP instance do normal forwarding */
> > > > +     if (!p->mrp_aware)
> > > > +             goto forward;
> > > > +
> > > > +     if (skb->protocol == htons(ETH_P_MRP))
> > > > +             return RX_HANDLER_PASS;
> > >
> > > What MAC address is used for these MRP frames? It would make sense to
> > > use a L2 link local destination address, since i assume they are not
> > > supposed to be forwarded by the bridge. If so, you could extend the
> > > if (unlikely(is_link_local_ether_addr(dest))) condition.
> >
> > The MAC addresses used by MRP frames are:
> > 0x1, 0x15, 0x4e, 0x0, 0x0, 0x1 - used by MRP_Test frames
> > 0x1, 0x15, 0x4e, 0x0, 0x0, 0x2 - used by the rest of MRP frames.
> >
> > If we will add support also for MIM/MIC. These requires 2 more MAC
> > addresses:
> > 0x1, 0x15, 0x4e, 0x0, 0x0, 0x3 - used by MRP_InTest frames.
> > 0x1, 0x15, 0x4e, 0x0, 0x0, 0x4 - used by the other MRP interconnect
> > frames.
> 
> Hi Horatiu
> 
> I made the wrong guess about how this protocol worked when i said L2
> link local. These MAC addresses are L2 multicast.
> 
> And you are using a raw socket to receive them into userspace when
> needed.
> 
> 'Thinking allowed' here.
> 
>     +------------------------------------------+
>     |                                          |
>     +-->|H1|<---------->|H2|<---------->|H3|<--+
>     eth0    eth1    eth0    eth1    eth0    eth1
>      ^
>      |
>   Blocked
> 
> 
> There are three major classes of user case here:
> 
> 1) Pure software solution
> You need the software bridge in the client to forward these frames
> from the left side to the right side.
As far as I understand it is not the bridge which forward these frames -
it is the user-space tool. This was to put as much functionality in
user-space and only use the kernel to configure the HW. We can (and
should) discuss if this is the right decision.

> (Does the standard give these two ports names)?
Horatiu?

> In the master, the left port is blocked, so the bridge drops them
> anyway. You have a RAW socket open on both eth0 and eth1, so you get
> to see the frames, even if the bridge drops them.
Yes, in the current patch-set such frames are forwarded by the
user-space daemon.

We would properly have better performance if we do this in kernel-space.


> 2) Hardware offload to an MRP unaware switch.
> 
> I'm thinking about a plain switch supported by DSA, Marvell, Broadcom,
> etc. It has no special knowledge of MRP.
We have implemented this on Ocelot - which is not MRP aware at all. Not
sure what facilities Marvell and Broadcom has, but it is not a lot which
is needed.

> Ideally, you want the switch to forward MRP_Test frames left to right
> for a client.
Yes. If we have only 1 ring, then we can do that with a MAC table entry.
If we have more than 1 ring, then we will need a TCAM rule of some kind.

In the what we have today on Ocelot, we do not do this is HW, we do the
forwarding in SW.

BTW: It is not only from left to right, it is also from right to left.
The MRM will inject packets on both ring ports, and monitor both. This
is to detect asymmetrical link down or similar. The two ports are
treated the same. But you can set a priority (the primary/secondary) to
state your preference on what port to use if both are up and the ring is
closed.

> In a master, i think you have a problem, since the port
> is blocked. The hardware is unlikely to recognise these frames as
> special, since they are not in the 01-80-C2-XX-XX-XX block, and let
> them through. So your raw socket is never going to see them, and you
> cannot detect open/closed ring.
Again, I do not know how other HW is designed, but all the SOC's we are
working with, does allow us to add a TCAM rule which can redirect these
frames to the CPU even on a blocked port.

> I don't know how realistic it is to support MRP in this case, and i
> also don't think you can fall back to a pure software solution,
> because the software bridge is going to offload the basic bridge
> operation to the hardware. It would be nice if you could detect this,
> and return -EOPNOTSUPP.
We do want to support this on Ocelot, but you are right, if the current
running bridge, cannot block a port, and still get the MRP frames on
that port, then it cannot support MRM. And this we need to detect in
some way.

> 3) Hardware offload to an MRP aware switch.
> 
> For a client, you tell it which port is left, which is right, and
> assume it forwards the frames. For a master, you again tell it which
> is left, which is right, and ask it send MRP_Test frames out right,
> and report changes in open/closed on the right port. You don't need
> the CPU to see the MRP_Test frames, so the switch has no need to
> forward them to the CPU.
> 
> We should think about the general case of a bridge with many ports,
> and many pairs of ports using MRP. This makes the forwarding of these
> frames interesting. Given that they are multicast, the default action
> of the software bridge is that it will flood them. Does the protocol
> handle seeing MRP_Test from some other loop? Do we need to avoid this?
Yes, we need to avoid. We cannot "just" do normal flooding.

> You could avoid this by adding MDB entries to the bridge. However,
> this does not scale to more then one ring.
I would prefer a solution where the individual drivers can do what is
best on the given HW.

- If we have a 2 ported switch, then flooding seems like a perfect valid
   approach. There will be only 1 ring.
- If we have a many ported switch, then we could use MAC-table entry -
   if the user only configure 1 ring.
   - When adding more rings, it either needs to return error, or use
     other HW facilities.

> I don't think an MDB is associated to an ingress port. So you cannot
> say
Agree.

> 0x1, 0x15, 0x4e, 0x0, 0x0, 0x1 ingress port1 egress port2
> 0x1, 0x15, 0x4e, 0x0, 0x0, 0x1 ingress port3 egress port4
> 
> The best you can say is
> 
> 0x1, 0x15, 0x4e, 0x0, 0x0, 0x1 egress port2, port4
> 
> I'm sure there are other issues i'm missing, but it is interesting to
> think about all this.
Yes, the solution Horatiu has chosen, is not to forward MRP frames,
received in MRP ring ports at all. This is done by the user-space tool.

Again, not sure if this is the right way to do it, but it is what patch
v3 does.

The alternative to this would be to learn the bridge how to forward MRP
frames when it is a MRC. The user-space tool then never needs to do
this, it know that the kernel will take care of this part (either in SW
or in HW).

/Allan
