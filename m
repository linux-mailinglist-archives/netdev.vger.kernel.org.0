Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21B7B1DEF6E
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 20:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730893AbgEVSph (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 14:45:37 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:50194 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730810AbgEVSph (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 14:45:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1590173136; x=1621709136;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8gUWPg333bY8WzJ/TXJNRgBNbxE+5dtSX7N301H5CsU=;
  b=jWYFzd0gngbz9zDR+P7U3RQ567W9mAAo9+H0AuFzbaXMsbROiCwAFOKi
   JuKNE7Ed21pAGIwfXwz1OdtrbvhUvWfL1o/yUBUaJ1DOO9infVu1gH3aj
   X/qIqji+PW+i1O5eCYpEmH+Sh6+HJoOh4pkEDUf0T53JwQOQjnEk5W3io
   IleXGhBd8IiH0rk2fJbdo1fKCGnLDHnIHl3vr2ZSOIpPmWKV162MJiwSz
   L544p/BuktXHMWzLd7zz0I0AKtqwdxjYbdEjD8auwQR3Xsb0Ti0R5NxPM
   ehIXCRz2YlL0RZaPsuTdnnnc0Y80LNoTCPs8qFqfvH798BqEIg3fnGb5L
   Q==;
IronPort-SDR: KGFVBMbA/tyFzN4GKceaQTOLnLw8jboA2uXqt2tDQ50pn+QLnwrQfGQcG6d83/or9k4h59yuAn
 AmAjyWK6UJiBaMqUE3eRikI7qMZvQ6bRJAhpddhip0qS8UKwH7jYv78mwxDscvbtk5zPtnkUFF
 Mz5xsWH/r0FKmbkC0NKNIPf8e8rjkvGlRPfJ0lOWhTB6E7r0J4rJlj/g2doxAZMX1UIDvX9gRJ
 Xl4vHYhk07lyern/Sa65zf93sJEAozmjYMbVbWmLAF+7uIzb2rHo+j2HMzizz0KKhrfQLklBzF
 dCo=
X-IronPort-AV: E=Sophos;i="5.73,422,1583218800"; 
   d="scan'208";a="74253326"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 May 2020 11:45:35 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 22 May 2020 11:45:35 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Fri, 22 May 2020 11:45:35 -0700
Date:   Fri, 22 May 2020 20:45:34 +0200
From:   "Allan W. Nielsen" <allan.nielsen@microchip.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jiri Pirko" <jiri@resnulli.us>, Ido Schimmel <idosch@idosch.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Ivan Vecera <ivecera@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>
Subject: Re: [PATCH RFC net-next 10/13] net: bridge: add port flags for host
 flooding
Message-ID: <20200522184534.7hynm6jain76n5dr@ws.localdomain>
References: <20200521211036.668624-1-olteanv@gmail.com>
 <20200521211036.668624-11-olteanv@gmail.com>
 <a906e4d4-2551-7fe6-f2fc-6a7e77be6b4e@cumulusnetworks.com>
 <CA+h21hq2Uo_ihec56v=AYr_s3dv0XrDzZpQLEotkrSQe803wrw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <CA+h21hq2Uo_ihec56v=AYr_s3dv0XrDzZpQLEotkrSQe803wrw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22.05.2020 16:13, Vladimir Oltean wrote:
>EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>
>On Fri, 22 May 2020 at 15:38, Nikolay Aleksandrov
><nikolay@cumulusnetworks.com> wrote:
>>
>> On 22/05/2020 00:10, Vladimir Oltean wrote:
>> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
>> >
>> > In cases where the bridge is offloaded by a switchdev, there are
>> > situations where we can optimize RX filtering towards the host. To be
>> > precise, the host only needs to do termination, which it can do by
>> > responding at the MAC addresses of the slave ports and of the bridge
>> > interface itself. But most notably, it doesn't need to do forwarding,
>> > so there is no need to see packets with unknown destination address.
>> >
>> > But there are, however, cases when a switchdev does need to flood to the
>> > CPU. Such an example is when the switchdev is bridged with a foreign
>> > interface, and since there is no offloaded datapath, packets need to
>> > pass through the CPU. Currently this is the only identified case, but it
>> > can be extended at any time.
>> >
>> > So far, switchdev implementers made driver-level assumptions, such as:
>> > this chip is never integrated in SoCs where it can be bridged with a
>> > foreign interface, so I'll just disable host flooding and save some CPU
>> > cycles. Or: I can never know what else can be bridged with this
>> > switchdev port, so I must leave host flooding enabled in any case.
>> >
>> > Let the bridge drive the host flooding decision, and pass it to
>> > switchdev via the same mechanism as the external flooding flags.
>> >
>> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>> > ---
>> >  include/linux/if_bridge.h |  3 +++
>> >  net/bridge/br_if.c        | 40 +++++++++++++++++++++++++++++++++++++++
>> >  net/bridge/br_switchdev.c |  4 +++-
>> >  3 files changed, 46 insertions(+), 1 deletion(-)
>> >
>> > diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
>> > index b3a8d3054af0..6891a432862d 100644
>> > --- a/include/linux/if_bridge.h
>> > +++ b/include/linux/if_bridge.h
>> > @@ -49,6 +49,9 @@ struct br_ip_list {
>> >  #define BR_ISOLATED          BIT(16)
>> >  #define BR_MRP_AWARE         BIT(17)
>> >  #define BR_MRP_LOST_CONT     BIT(18)
>> > +#define BR_HOST_FLOOD                BIT(19)
>> > +#define BR_HOST_MCAST_FLOOD  BIT(20)
>> > +#define BR_HOST_BCAST_FLOOD  BIT(21)
>> >
>> >  #define BR_DEFAULT_AGEING_TIME       (300 * HZ)
>> >
>> > diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
>> > index a0e9a7937412..aae59d1e619b 100644
>> > --- a/net/bridge/br_if.c
>> > +++ b/net/bridge/br_if.c
>> > @@ -166,6 +166,45 @@ void br_manage_promisc(struct net_bridge *br)
>> >       }
>> >  }
>> >
>> > +static int br_manage_host_flood(struct net_bridge *br)
>> > +{
>> > +     const unsigned long mask = BR_HOST_FLOOD | BR_HOST_MCAST_FLOOD |
>> > +                                BR_HOST_BCAST_FLOOD;
>> > +     struct net_bridge_port *p, *q;
>> > +
>> > +     list_for_each_entry(p, &br->port_list, list) {
>> > +             unsigned long flags = p->flags;
>> > +             bool sw_bridging = false;
>> > +             int err;
>> > +
>> > +             list_for_each_entry(q, &br->port_list, list) {
>> > +                     if (p == q)
>> > +                             continue;
>> > +
>> > +                     if (!netdev_port_same_parent_id(p->dev, q->dev)) {
>> > +                             sw_bridging = true;
>> > +                             break;
>> > +                     }
>> > +             }
>> > +
>> > +             if (sw_bridging)
>> > +                     flags |= mask;
>> > +             else
>> > +                     flags &= ~mask;
>> > +
>> > +             if (flags == p->flags)
>> > +                     continue;
>> > +
>> > +             err = br_switchdev_set_port_flag(p, flags, mask);
>> > +             if (err)
>> > +                     return err;
>> > +
>> > +             p->flags = flags;
>> > +     }
>> > +
>> > +     return 0;
>> > +}
>> > +
>> >  int nbp_backup_change(struct net_bridge_port *p,
>> >                     struct net_device *backup_dev)
>> >  {
>> > @@ -231,6 +270,7 @@ static void nbp_update_port_count(struct net_bridge *br)
>> >               br->auto_cnt = cnt;
>> >               br_manage_promisc(br);
>> >       }
>> > +     br_manage_host_flood(br);
>> >  }
>> >
>>
>> Can we do this only at port add/del ?
>> Right now it will be invoked also by br_port_flags_change() upon BR_AUTO_MASK flag change.
>>
>
>Yes, we can do that.
>Actually I have some doubts about BR_HOST_BCAST_FLOOD. We can't
>disable that in the no-foreign-interface case, can we? For IPv6, it
>looks like the stack does take care of installing dev_mc addresses for
>the neighbor discovery protocol, but for IPv4 I guess the assumption
>is that broadcast ARP should always be processed?

Ideally this should be per VLAN. In case of IPv4, you only need to be
part of the broadcast domain on VLANs with an associated vlan-interface.

>> >  static void nbp_delete_promisc(struct net_bridge_port *p)
>> > diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
>> > index 015209bf44aa..360806ac7463 100644
>> > --- a/net/bridge/br_switchdev.c
>> > +++ b/net/bridge/br_switchdev.c
>> > @@ -56,7 +56,9 @@ bool nbp_switchdev_allowed_egress(const struct net_bridge_port *p,
>> >
>> >  /* Flags that can be offloaded to hardware */
>> >  #define BR_PORT_FLAGS_HW_OFFLOAD (BR_LEARNING | BR_FLOOD | \
>> > -                               BR_MCAST_FLOOD | BR_BCAST_FLOOD)
>> > +                               BR_MCAST_FLOOD | BR_BCAST_FLOOD | \
>> > +                               BR_HOST_FLOOD | BR_HOST_MCAST_FLOOD | \
>> > +                               BR_HOST_BCAST_FLOOD)
>> >
>> >  int br_switchdev_set_port_flag(struct net_bridge_port *p,
>> >                              unsigned long flags,
>> >
>>
>
>Thanks,
>-Vladimir
/Allan
