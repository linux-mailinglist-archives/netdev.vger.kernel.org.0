Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91A401E0075
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 18:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728456AbgEXQN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 12:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727899AbgEXQN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 May 2020 12:13:59 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBE27C061A0E
        for <netdev@vger.kernel.org>; Sun, 24 May 2020 09:13:58 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id d24so13134746eds.11
        for <netdev@vger.kernel.org>; Sun, 24 May 2020 09:13:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=niFBneZbZNU/iHxEYy/KsCFZNtnbGs02UBsvtwWtxAQ=;
        b=p0kjE6EIMmwZ7DtR7Kh98V0fPxp3cwdxutwWHshOgf/Y99CCLTJtceXrI8gYuR7xJl
         Y3wtR5Lo47ASlbM9jXtT8LOitRjkY8GcTfECxqriUJP8uelQjohkYw3Rdtg3dPa8dmzS
         pKGbyQnVxiZCDSd34FaIkVoj2TrI8q+EgB+5d1jysIDvNQ5ca3jeNxqyJeftUCfuLJxo
         zL76s9heSBS1khdqDicoCaa/GBEYCqdJTqHcadLXUfrKpM/Fc3SOg8Zs+yASZ3lbWFUp
         FuqHVu4vWmAMrfaMUYp0AQUfdkEs1sPmpqgIRFNIAhVT2PQFCcO6BJJf/UNqFrfIvMsl
         jrBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=niFBneZbZNU/iHxEYy/KsCFZNtnbGs02UBsvtwWtxAQ=;
        b=I3B+mCj64k24hCWDXQl5FCzNQOyU0qcO9ntLhsM/daxpdX8qowNAvTgHdHyBzZ3M53
         /vHMjdoVbpypTiCIWzegw48+dYVpUsrV5eDMOkhM1bWncuPn36h9YwR4mVKbTgUKtQLR
         xy5134sp2Kzemevc9fDmjrpVRkZC5cflKNgTOl+fhX644j47jyOdsJBpHpmIGUqjTg5q
         aD/cw438NIPDvmO0oakZVBg6zVXeKwPcYOYPsDNN1dpNapBE5KsWq252/nYH3zceZyyp
         QhvybPy5UF1zQ4l+H7FAzINBzLf2G082KCbscJZwyNpwiBUUe3GpADQdiSr5cmETeT8O
         ezLg==
X-Gm-Message-State: AOAM531PvUototNVg06ID4IxzZjcEYfdokNpL2aKZ8jQnntksURZK9cg
        db8vMU1vpKwL2Pnr4+zHb06OEhOtPEgQ9dMOC+U3iA==
X-Google-Smtp-Source: ABdhPJx/wc+ZSmvRzBN0fcJrqFfxhcIkTb7lQ2P+keiGYY3HnWZAs2LZdw63tsOsQu/Skkgwhtl/dltxx61hF2P4hDM=
X-Received: by 2002:a50:bf03:: with SMTP id f3mr11998332edk.368.1590336837585;
 Sun, 24 May 2020 09:13:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200521211036.668624-1-olteanv@gmail.com> <20200521211036.668624-11-olteanv@gmail.com>
 <20200524142609.GB1281067@splinter>
In-Reply-To: <20200524142609.GB1281067@splinter>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sun, 24 May 2020 19:13:46 +0300
Message-ID: <CA+h21hpktNFcpwxTXVFikyWfgHkFZDofZ8=qVqraxcUp_EwJqg@mail.gmail.com>
Subject: Re: [PATCH RFC net-next 10/13] net: bridge: add port flags for host flooding
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
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ido,

On Sun, 24 May 2020 at 17:26, Ido Schimmel <idosch@idosch.org> wrote:
>
> On Fri, May 22, 2020 at 12:10:33AM +0300, Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > In cases where the bridge is offloaded by a switchdev, there are
> > situations where we can optimize RX filtering towards the host. To be
> > precise, the host only needs to do termination, which it can do by
> > responding at the MAC addresses of the slave ports and of the bridge
> > interface itself. But most notably, it doesn't need to do forwarding,
> > so there is no need to see packets with unknown destination address.
> >
> > But there are, however, cases when a switchdev does need to flood to the
> > CPU. Such an example is when the switchdev is bridged with a foreign
> > interface, and since there is no offloaded datapath, packets need to
> > pass through the CPU. Currently this is the only identified case, but it
> > can be extended at any time.
> >
> > So far, switchdev implementers made driver-level assumptions, such as:
> > this chip is never integrated in SoCs where it can be bridged with a
> > foreign interface, so I'll just disable host flooding and save some CPU
> > cycles. Or: I can never know what else can be bridged with this
> > switchdev port, so I must leave host flooding enabled in any case.
> >
> > Let the bridge drive the host flooding decision, and pass it to
> > switchdev via the same mechanism as the external flooding flags.
> >
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > ---
> >  include/linux/if_bridge.h |  3 +++
> >  net/bridge/br_if.c        | 40 +++++++++++++++++++++++++++++++++++++++
> >  net/bridge/br_switchdev.c |  4 +++-
> >  3 files changed, 46 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
> > index b3a8d3054af0..6891a432862d 100644
> > --- a/include/linux/if_bridge.h
> > +++ b/include/linux/if_bridge.h
> > @@ -49,6 +49,9 @@ struct br_ip_list {
> >  #define BR_ISOLATED          BIT(16)
> >  #define BR_MRP_AWARE         BIT(17)
> >  #define BR_MRP_LOST_CONT     BIT(18)
> > +#define BR_HOST_FLOOD                BIT(19)
> > +#define BR_HOST_MCAST_FLOOD  BIT(20)
> > +#define BR_HOST_BCAST_FLOOD  BIT(21)
> >
> >  #define BR_DEFAULT_AGEING_TIME       (300 * HZ)
> >
> > diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
> > index a0e9a7937412..aae59d1e619b 100644
> > --- a/net/bridge/br_if.c
> > +++ b/net/bridge/br_if.c
> > @@ -166,6 +166,45 @@ void br_manage_promisc(struct net_bridge *br)
> >       }
> >  }
> >
> > +static int br_manage_host_flood(struct net_bridge *br)
> > +{
> > +     const unsigned long mask = BR_HOST_FLOOD | BR_HOST_MCAST_FLOOD |
> > +                                BR_HOST_BCAST_FLOOD;
> > +     struct net_bridge_port *p, *q;
> > +
> > +     list_for_each_entry(p, &br->port_list, list) {
> > +             unsigned long flags = p->flags;
> > +             bool sw_bridging = false;
> > +             int err;
> > +
> > +             list_for_each_entry(q, &br->port_list, list) {
> > +                     if (p == q)
> > +                             continue;
> > +
> > +                     if (!netdev_port_same_parent_id(p->dev, q->dev)) {
> > +                             sw_bridging = true;
>
> It's not that simple. There are cases where not all bridge slaves have
> the same parent ID and still there is no reason to flood traffic to the
> CPU. VXLAN, for example.
>
> You could argue that the VXLAN device needs to have the same parent ID
> as the physical netdevs member in the bridge, but it will break your
> data path. For example, lets assume your hardware decided to flood a
> packet in L2. The packet will egress all the local ports, but will also
> perform VXLAN encapsulation. The packet continues with the IP of the
> remote VTEP(s) to the underlay router and then encounters a neighbour
> miss exception, which sends it to the CPU for resolution.
>
> Since this exception was encountered in the router the driver would mark
> the packet with 'offload_fwd_mark', as it already performed L2
> forwarding. If the VXLAN device has the same parent ID as the physical
> netdevs, then the Linux bridge will never let it egress, nothing will
> trigger neighbour resolution and the packet will be discarded.
>

I wasn't going to argue that.
Ok, so with a bridged VXLAN only certain multicast DMACs corresponding
to multicast IPs should be flooded to the CPU.
Actually Allan's example was a bit simpler, he said that host flooding
can be made a per-VLAN flag. I'm glad that you raised this. So maybe
we should try to define some mechanism by which virtual interfaces can
specify to the bridge that they don't need to see all traffic? Do you
have any ideas?

> > +                             break;
> > +                     }
> > +             }
> > +
> > +             if (sw_bridging)
> > +                     flags |= mask;
> > +             else
> > +                     flags &= ~mask;
> > +
> > +             if (flags == p->flags)
> > +                     continue;
> > +
> > +             err = br_switchdev_set_port_flag(p, flags, mask);
> > +             if (err)
> > +                     return err;
> > +
> > +             p->flags = flags;
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> >  int nbp_backup_change(struct net_bridge_port *p,
> >                     struct net_device *backup_dev)
> >  {
> > @@ -231,6 +270,7 @@ static void nbp_update_port_count(struct net_bridge *br)
> >               br->auto_cnt = cnt;
> >               br_manage_promisc(br);
> >       }
> > +     br_manage_host_flood(br);
> >  }
> >
> >  static void nbp_delete_promisc(struct net_bridge_port *p)
> > diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
> > index 015209bf44aa..360806ac7463 100644
> > --- a/net/bridge/br_switchdev.c
> > +++ b/net/bridge/br_switchdev.c
> > @@ -56,7 +56,9 @@ bool nbp_switchdev_allowed_egress(const struct net_bridge_port *p,
> >
> >  /* Flags that can be offloaded to hardware */
> >  #define BR_PORT_FLAGS_HW_OFFLOAD (BR_LEARNING | BR_FLOOD | \
> > -                               BR_MCAST_FLOOD | BR_BCAST_FLOOD)
> > +                               BR_MCAST_FLOOD | BR_BCAST_FLOOD | \
> > +                               BR_HOST_FLOOD | BR_HOST_MCAST_FLOOD | \
> > +                               BR_HOST_BCAST_FLOOD)
> >
> >  int br_switchdev_set_port_flag(struct net_bridge_port *p,
> >                              unsigned long flags,
> > --
> > 2.25.1
> >

Thanks,
-Vladimir
