Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AFE122F65A
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 19:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730226AbgG0RPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 13:15:08 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:57871 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728021AbgG0RPH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 13:15:07 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 016D7580770;
        Mon, 27 Jul 2020 13:15:06 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 27 Jul 2020 13:15:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=1kBeH/
        bAXtS+l7dqf8DvHd0VHAEAXCYfHiolY7BvnCw=; b=FHTawGyyYwVx9HzHZGbfVR
        QLtjEipynmOfYg7MAYR/FRYyGjuDa2TeQ/C618lkgP9Fm5J+XqAv+NvhEURjL+H8
        QqVoqMCBp6Ew/L7KvCPeke3MEV7Dev3cI+v30PjtThXfoouojyZ8LgnoEb23+MCu
        vScxv54ZWLIcURy/k1HbyBptanTw5BhKVZPr0BoMTOanLf+baLdc+ACEUXsr0H0F
        5u4Fe+Al1nMNXT31c5tSislvBn0uM/otX5jutfv1CoD4HS1VuEUpZ4tfnedd5gvL
        Z+yi0UNnY77eDZypkCocDYUwpO5RHIi2LIwUcHCIkiq/orkSAijHQttm21AVcvpg
        ==
X-ME-Sender: <xms:mAsfX1U14PmPItdu63GuNWF8Ku_VsAqmZvv2BMywpfnnsyFcSsI7vQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedriedtgdduudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepjeelrddukedurddvrddujeelnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:mAsfX1kvs_x3tkRRufVxRRn-K94jZdKDrFevMbQKLDjvigJyKZbG2Q>
    <xmx:mAsfXxZ3QWD-9Rhm1QYO3vwKO-i_X57k5V-wc_iBZewDD4BZ4KZOxA>
    <xmx:mAsfX4XkCO563NLS1RJnelYvgy1VI6qj3I9dnBXahpT_QGDDovEAzA>
    <xmx:mQsfXx5RNGF7iYfaqmxOx3T_vSMJQzCIQjd1prhdp65Sj5RqbtwOFA>
Received: from localhost (bzq-79-181-2-179.red.bezeqint.net [79.181.2.179])
        by mail.messagingengine.com (Postfix) with ESMTPA id E0C8430600A3;
        Mon, 27 Jul 2020 13:15:03 -0400 (EDT)
Date:   Mon, 27 Jul 2020 20:15:01 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        Ivan Vecera <ivecera@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>
Subject: Re: [PATCH RFC net-next 10/13] net: bridge: add port flags for host
 flooding
Message-ID: <20200727171501.GB1910935@shredder>
References: <20200521211036.668624-1-olteanv@gmail.com>
 <20200521211036.668624-11-olteanv@gmail.com>
 <20200524142609.GB1281067@splinter>
 <CA+h21hpktNFcpwxTXVFikyWfgHkFZDofZ8=qVqraxcUp_EwJqg@mail.gmail.com>
 <20200525201111.GB1449199@splinter>
 <20200723223551.d23ol2oriv474bn4@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200723223551.d23ol2oriv474bn4@skbuf>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 24, 2020 at 01:35:51AM +0300, Vladimir Oltean wrote:
> On Mon, May 25, 2020 at 11:11:11PM +0300, Ido Schimmel wrote:
> > On Sun, May 24, 2020 at 07:13:46PM +0300, Vladimir Oltean wrote:
> > > Hi Ido,
> > > 
> > > On Sun, 24 May 2020 at 17:26, Ido Schimmel <idosch@idosch.org> wrote:
> > > >
> > > > On Fri, May 22, 2020 at 12:10:33AM +0300, Vladimir Oltean wrote:
> > > > > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > > > >
> > > > > In cases where the bridge is offloaded by a switchdev, there are
> > > > > situations where we can optimize RX filtering towards the host. To be
> > > > > precise, the host only needs to do termination, which it can do by
> > > > > responding at the MAC addresses of the slave ports and of the bridge
> > > > > interface itself. But most notably, it doesn't need to do forwarding,
> > > > > so there is no need to see packets with unknown destination address.
> > > > >
> > > > > But there are, however, cases when a switchdev does need to flood to the
> > > > > CPU. Such an example is when the switchdev is bridged with a foreign
> > > > > interface, and since there is no offloaded datapath, packets need to
> > > > > pass through the CPU. Currently this is the only identified case, but it
> > > > > can be extended at any time.
> > > > >
> > > > > So far, switchdev implementers made driver-level assumptions, such as:
> > > > > this chip is never integrated in SoCs where it can be bridged with a
> > > > > foreign interface, so I'll just disable host flooding and save some CPU
> > > > > cycles. Or: I can never know what else can be bridged with this
> > > > > switchdev port, so I must leave host flooding enabled in any case.
> > > > >
> > > > > Let the bridge drive the host flooding decision, and pass it to
> > > > > switchdev via the same mechanism as the external flooding flags.
> > > > >
> > > > > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > > > > ---
> > > > >  include/linux/if_bridge.h |  3 +++
> > > > >  net/bridge/br_if.c        | 40 +++++++++++++++++++++++++++++++++++++++
> > > > >  net/bridge/br_switchdev.c |  4 +++-
> > > > >  3 files changed, 46 insertions(+), 1 deletion(-)
> > > > >
> > > > > diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
> > > > > index b3a8d3054af0..6891a432862d 100644
> > > > > --- a/include/linux/if_bridge.h
> > > > > +++ b/include/linux/if_bridge.h
> > > > > @@ -49,6 +49,9 @@ struct br_ip_list {
> > > > >  #define BR_ISOLATED          BIT(16)
> > > > >  #define BR_MRP_AWARE         BIT(17)
> > > > >  #define BR_MRP_LOST_CONT     BIT(18)
> > > > > +#define BR_HOST_FLOOD                BIT(19)
> > > > > +#define BR_HOST_MCAST_FLOOD  BIT(20)
> > > > > +#define BR_HOST_BCAST_FLOOD  BIT(21)
> > > > >
> > > > >  #define BR_DEFAULT_AGEING_TIME       (300 * HZ)
> > > > >
> > > > > diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
> > > > > index a0e9a7937412..aae59d1e619b 100644
> > > > > --- a/net/bridge/br_if.c
> > > > > +++ b/net/bridge/br_if.c
> > > > > @@ -166,6 +166,45 @@ void br_manage_promisc(struct net_bridge *br)
> > > > >       }
> > > > >  }
> > > > >
> > > > > +static int br_manage_host_flood(struct net_bridge *br)
> > > > > +{
> > > > > +     const unsigned long mask = BR_HOST_FLOOD | BR_HOST_MCAST_FLOOD |
> > > > > +                                BR_HOST_BCAST_FLOOD;
> > > > > +     struct net_bridge_port *p, *q;
> > > > > +
> > > > > +     list_for_each_entry(p, &br->port_list, list) {
> > > > > +             unsigned long flags = p->flags;
> > > > > +             bool sw_bridging = false;
> > > > > +             int err;
> > > > > +
> > > > > +             list_for_each_entry(q, &br->port_list, list) {
> > > > > +                     if (p == q)
> > > > > +                             continue;
> > > > > +
> > > > > +                     if (!netdev_port_same_parent_id(p->dev, q->dev)) {
> > > > > +                             sw_bridging = true;
> > > >
> > > > It's not that simple. There are cases where not all bridge slaves have
> > > > the same parent ID and still there is no reason to flood traffic to the
> > > > CPU. VXLAN, for example.
> > > >
> > > > You could argue that the VXLAN device needs to have the same parent ID
> > > > as the physical netdevs member in the bridge, but it will break your
> > > > data path. For example, lets assume your hardware decided to flood a
> > > > packet in L2. The packet will egress all the local ports, but will also
> > > > perform VXLAN encapsulation. The packet continues with the IP of the
> > > > remote VTEP(s) to the underlay router and then encounters a neighbour
> > > > miss exception, which sends it to the CPU for resolution.
> > > >
> > > > Since this exception was encountered in the router the driver would mark
> > > > the packet with 'offload_fwd_mark', as it already performed L2
> > > > forwarding. If the VXLAN device has the same parent ID as the physical
> > > > netdevs, then the Linux bridge will never let it egress, nothing will
> > > > trigger neighbour resolution and the packet will be discarded.
> > > >
> > > 
> > > I wasn't going to argue that.
> > > Ok, so with a bridged VXLAN only certain multicast DMACs corresponding
> > > to multicast IPs should be flooded to the CPU.
> > > Actually Allan's example was a bit simpler, he said that host flooding
> > > can be made a per-VLAN flag. I'm glad that you raised this. So maybe
> > > we should try to define some mechanism by which virtual interfaces can
> > > specify to the bridge that they don't need to see all traffic? Do you
> > > have any ideas?
> > 
> > Maybe, when a port joins a bridge, query member ports if they can
> > forward traffic to it in hardware and based on the answer determine the
> > flooding towards the CPU?
> > 
> 
> Hi Ido, Allan,
> 
> I understand less and less of this. What I don't really understand is,
> if you have a switchdev bridged with a vtep like this:
> 
>  +-------------------------+
>  |           br0           |
>  +-------------------------+
>      |                |
>      |           +--------+
>      |           | vxlan0 |
>      |           +--------+
>      |                |
>  +--------+      +--------+
>  |  swp0  |      |  eth0  |
>  +--------+      +--------+
> 
> why would the swp0 interface care about the remote_ip at all. To the
> traffic seen by swp0, the VXLAN segment doesn't exist. Encapsulation and
> decapsulation all happen outside of the switchdev interface. All that
> switchdev sees is that, from the CPU side, it's talking to a bunch of
> MAC addresses.

I don't understand "Encapsulation and decapsulation all happen outside
of the switchdev interface". What does it mean? Encapsulation and
decapsulation happen in hardware... Frame is received by swp0, forwarded
to hardware VTEP, encapsulated and routed towards its destination. The
CPU does not see the packet. Same with decapsulation.

You patch instructs drivers to flood traffic to the CPU if netdevs with
different parent ID are member in it. I explained that this breaks with
VXLAN.

swp0 and vxlan0 do not have the same parent ID yet this does not mean
packets should be flooded to the CPU. I also explained why they should
not have the same parent ID:

1. Packet is received by swp0
2. Forwarded in hardware to hardware VTEP
3. VTEP performs encapsulation
4. VXLAN packet is routed in hardware
5. VXLAN packet encounters a neighbour miss in router
6. Original packet is trapped to CPU from swp0 because of an unresolved
neighbour
7. Driver marks packet with 'offload_fwd_mark' because it was already L2
forwarded in hardware
8. Packet reaches software bridge
9. bridge does not forward it to swpX netdevs because they share the
same parent ID as swp0 and packet is marked
10. Packet is forwarded to vxlan0
11. Packet is routed in and neighbour is resolved

Since the neighbour is now resolved the next packet will be completely
forwarded in hardware.

If vxlan0 and swp0 had the same parent ID, then step 10 would never
happen and the neighbour would never be resolved.

> 
> The same comment also applies for 8021q, in fact. I did try this
> experiment, to bridge a switchdev with a VLAN sub-interface of another
> port. I don't know why, I used to have the misconception that the desire
> in doing that would be to somehow only extract one VLAN ID from the
> switchdev, and the rest could be kept outside of the CPU's flooding
> domain. But that isn't the case at all. When bridging, I'm bridging the
> _entire_ traffic of swp0 with, say, eth0.100. And, as in the case of
> vxlan, encap/decap all happens outside of switchdev. So, contrary to my
> initial expectation, if I'm receiving on swp0 a packet tagged with VLAN
> 100, it would end up exiting the bridge, on eth0, with 2 VLAN tags with
> ID 100.
> 
> Simply put, I think my change is fine the way it is. Either that, or I
> just don't understand your comment about querying bridge members whether
> they can forward in hardware. How are you dealing with this today?
> 
> Thanks,
> -Vladimir
