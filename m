Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A60DC22B9A8
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 00:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728166AbgGWWf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 18:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726368AbgGWWf4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 18:35:56 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E95CC0619D3
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 15:35:55 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id bm28so5695567edb.2
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 15:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kGiTMghx4tNsD33Z8kOwzOKM6Id0cIJMw/xtaaq0vq8=;
        b=t3AkZZLCRoujB1tBPeX5d7grcuUwW3b1ZY4M4JVZ5XMukp24LVtgIO3tYuduKTNX8C
         mAL+D+fwaxBAjk7v8KDAIKS/Pal7ryOyX9EqrO4AJoVJCdRp1rGq6ifOcw/uj7oERSDU
         nhy5wISfY+Xazk6JSLy6fiRZEpvUOcqL439ozvOblyG92jLAhZnBmrLjU5t2l6qkc0Wv
         HxDQRxfJcSA9g/8/fgBsWWQfczazBEVrsKipCyg8vIBhfCejB+GisyJLG2I9wwk+IXB/
         j18frjG4pHP6GnLjr+KmMq18iUPOppnskQPqrv1wlCw6ypgTHXHd175JaW3t1g2xXlsi
         eD5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kGiTMghx4tNsD33Z8kOwzOKM6Id0cIJMw/xtaaq0vq8=;
        b=E+oFSiv0r4s1l4jl57bNcf3+dsGI6VkSRhSjgDG1UJqhtD9xfjsIfhyuT72VTY3cVd
         Yce+5jEPkx1U+Lj4InA8UqygNYQTBS6NGdgAcQyA0ehK3tnkv2BX/rMnApUgWw5nL6sL
         F3gMZ2BySWwOzvOPmv8r9PqMszH8xN0eHARDTI8I4CM9ws391WO0PGSeQoTpZS5unb8i
         kxh+ycBPs5gS7CeQNEi6TFUkUCP67/XPNkWjts2wrw6jkG2pAKM87J2DKOJUM0uxa/Hy
         /CdSi9gwdAgkO3ejiM3PcelsR90LGnXYJNwXJWNWJ3vi4WhR/wWldt35jFOQrcMd6k9j
         umJQ==
X-Gm-Message-State: AOAM531VqMZSeBs0qL2FMFv2EqgXbzHGSpHiWHoB5Vt1VI+p44jSEkYq
        WxILi4UST9g+qPfTwsw/05o=
X-Google-Smtp-Source: ABdhPJxZzUHV7+liq8tgslxqXNChuPSbi9v8BbO9j27uTQnBMxrXQ08pD0RD1z4BzIpdv/g2jAqq+A==
X-Received: by 2002:a50:9f22:: with SMTP id b31mr6488208edf.24.1595543754211;
        Thu, 23 Jul 2020 15:35:54 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id x16sm2895116edr.52.2020.07.23.15.35.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 15:35:53 -0700 (PDT)
Date:   Fri, 24 Jul 2020 01:35:51 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ido Schimmel <idosch@idosch.org>
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
Message-ID: <20200723223551.d23ol2oriv474bn4@skbuf>
References: <20200521211036.668624-1-olteanv@gmail.com>
 <20200521211036.668624-11-olteanv@gmail.com>
 <20200524142609.GB1281067@splinter>
 <CA+h21hpktNFcpwxTXVFikyWfgHkFZDofZ8=qVqraxcUp_EwJqg@mail.gmail.com>
 <20200525201111.GB1449199@splinter>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200525201111.GB1449199@splinter>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 25, 2020 at 11:11:11PM +0300, Ido Schimmel wrote:
> On Sun, May 24, 2020 at 07:13:46PM +0300, Vladimir Oltean wrote:
> > Hi Ido,
> > 
> > On Sun, 24 May 2020 at 17:26, Ido Schimmel <idosch@idosch.org> wrote:
> > >
> > > On Fri, May 22, 2020 at 12:10:33AM +0300, Vladimir Oltean wrote:
> > > > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > > >
> > > > In cases where the bridge is offloaded by a switchdev, there are
> > > > situations where we can optimize RX filtering towards the host. To be
> > > > precise, the host only needs to do termination, which it can do by
> > > > responding at the MAC addresses of the slave ports and of the bridge
> > > > interface itself. But most notably, it doesn't need to do forwarding,
> > > > so there is no need to see packets with unknown destination address.
> > > >
> > > > But there are, however, cases when a switchdev does need to flood to the
> > > > CPU. Such an example is when the switchdev is bridged with a foreign
> > > > interface, and since there is no offloaded datapath, packets need to
> > > > pass through the CPU. Currently this is the only identified case, but it
> > > > can be extended at any time.
> > > >
> > > > So far, switchdev implementers made driver-level assumptions, such as:
> > > > this chip is never integrated in SoCs where it can be bridged with a
> > > > foreign interface, so I'll just disable host flooding and save some CPU
> > > > cycles. Or: I can never know what else can be bridged with this
> > > > switchdev port, so I must leave host flooding enabled in any case.
> > > >
> > > > Let the bridge drive the host flooding decision, and pass it to
> > > > switchdev via the same mechanism as the external flooding flags.
> > > >
> > > > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > > > ---
> > > >  include/linux/if_bridge.h |  3 +++
> > > >  net/bridge/br_if.c        | 40 +++++++++++++++++++++++++++++++++++++++
> > > >  net/bridge/br_switchdev.c |  4 +++-
> > > >  3 files changed, 46 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
> > > > index b3a8d3054af0..6891a432862d 100644
> > > > --- a/include/linux/if_bridge.h
> > > > +++ b/include/linux/if_bridge.h
> > > > @@ -49,6 +49,9 @@ struct br_ip_list {
> > > >  #define BR_ISOLATED          BIT(16)
> > > >  #define BR_MRP_AWARE         BIT(17)
> > > >  #define BR_MRP_LOST_CONT     BIT(18)
> > > > +#define BR_HOST_FLOOD                BIT(19)
> > > > +#define BR_HOST_MCAST_FLOOD  BIT(20)
> > > > +#define BR_HOST_BCAST_FLOOD  BIT(21)
> > > >
> > > >  #define BR_DEFAULT_AGEING_TIME       (300 * HZ)
> > > >
> > > > diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
> > > > index a0e9a7937412..aae59d1e619b 100644
> > > > --- a/net/bridge/br_if.c
> > > > +++ b/net/bridge/br_if.c
> > > > @@ -166,6 +166,45 @@ void br_manage_promisc(struct net_bridge *br)
> > > >       }
> > > >  }
> > > >
> > > > +static int br_manage_host_flood(struct net_bridge *br)
> > > > +{
> > > > +     const unsigned long mask = BR_HOST_FLOOD | BR_HOST_MCAST_FLOOD |
> > > > +                                BR_HOST_BCAST_FLOOD;
> > > > +     struct net_bridge_port *p, *q;
> > > > +
> > > > +     list_for_each_entry(p, &br->port_list, list) {
> > > > +             unsigned long flags = p->flags;
> > > > +             bool sw_bridging = false;
> > > > +             int err;
> > > > +
> > > > +             list_for_each_entry(q, &br->port_list, list) {
> > > > +                     if (p == q)
> > > > +                             continue;
> > > > +
> > > > +                     if (!netdev_port_same_parent_id(p->dev, q->dev)) {
> > > > +                             sw_bridging = true;
> > >
> > > It's not that simple. There are cases where not all bridge slaves have
> > > the same parent ID and still there is no reason to flood traffic to the
> > > CPU. VXLAN, for example.
> > >
> > > You could argue that the VXLAN device needs to have the same parent ID
> > > as the physical netdevs member in the bridge, but it will break your
> > > data path. For example, lets assume your hardware decided to flood a
> > > packet in L2. The packet will egress all the local ports, but will also
> > > perform VXLAN encapsulation. The packet continues with the IP of the
> > > remote VTEP(s) to the underlay router and then encounters a neighbour
> > > miss exception, which sends it to the CPU for resolution.
> > >
> > > Since this exception was encountered in the router the driver would mark
> > > the packet with 'offload_fwd_mark', as it already performed L2
> > > forwarding. If the VXLAN device has the same parent ID as the physical
> > > netdevs, then the Linux bridge will never let it egress, nothing will
> > > trigger neighbour resolution and the packet will be discarded.
> > >
> > 
> > I wasn't going to argue that.
> > Ok, so with a bridged VXLAN only certain multicast DMACs corresponding
> > to multicast IPs should be flooded to the CPU.
> > Actually Allan's example was a bit simpler, he said that host flooding
> > can be made a per-VLAN flag. I'm glad that you raised this. So maybe
> > we should try to define some mechanism by which virtual interfaces can
> > specify to the bridge that they don't need to see all traffic? Do you
> > have any ideas?
> 
> Maybe, when a port joins a bridge, query member ports if they can
> forward traffic to it in hardware and based on the answer determine the
> flooding towards the CPU?
> 

Hi Ido, Allan,

I understand less and less of this. What I don't really understand is,
if you have a switchdev bridged with a vtep like this:

 +-------------------------+
 |           br0           |
 +-------------------------+
     |                |
     |           +--------+
     |           | vxlan0 |
     |           +--------+
     |                |
 +--------+      +--------+
 |  swp0  |      |  eth0  |
 +--------+      +--------+

why would the swp0 interface care about the remote_ip at all. To the
traffic seen by swp0, the VXLAN segment doesn't exist. Encapsulation and
decapsulation all happen outside of the switchdev interface. All that
switchdev sees is that, from the CPU side, it's talking to a bunch of
MAC addresses.

The same comment also applies for 8021q, in fact. I did try this
experiment, to bridge a switchdev with a VLAN sub-interface of another
port. I don't know why, I used to have the misconception that the desire
in doing that would be to somehow only extract one VLAN ID from the
switchdev, and the rest could be kept outside of the CPU's flooding
domain. But that isn't the case at all. When bridging, I'm bridging the
_entire_ traffic of swp0 with, say, eth0.100. And, as in the case of
vxlan, encap/decap all happens outside of switchdev. So, contrary to my
initial expectation, if I'm receiving on swp0 a packet tagged with VLAN
100, it would end up exiting the bridge, on eth0, with 2 VLAN tags with
ID 100.

Simply put, I think my change is fine the way it is. Either that, or I
just don't understand your comment about querying bridge members whether
they can forward in hardware. How are you dealing with this today?

Thanks,
-Vladimir
