Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8D71E153F
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 22:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390414AbgEYUdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 16:33:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389950AbgEYUdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 16:33:02 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F25B5C061A0E
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 13:33:01 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id l5so15945095edn.7
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 13:33:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W/tavxuJu/UvVrbkAT2k7v26RrC4rPQEgnWCBYVfewo=;
        b=sd1blCH4fdHexe+jwbW7smKl1te3l9Ned4l3m6l4D+vVcbG73IfQ9jtehh5mCsBrdw
         J/XNj/c+RY8MPwyWkKrutl+D70854TJana6Dd8ppMU9c2C9NPbPQsAXHDzI2rF+dnZIz
         9G2dSLkRiBfUA9ZAEY3A2T1Z8YTiDT4It3uRKyMryURy71sGufiFvVKLrJ/IbXqOft2/
         /jagGyUrFQ8tV5x346opXf7f7E7QHYRY30RgJuyeNA0V0KdEV2uvqxQv1FjHpA2BvODK
         3J/gWMFJUF9QJXffMVp6wAv4e6VpXB6pZnf0PRiNvStEcPBsOLn3g6+MRQ22Xc/X34AE
         RKtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W/tavxuJu/UvVrbkAT2k7v26RrC4rPQEgnWCBYVfewo=;
        b=un/YLTFbng0AXC9j2oqv8VThILU0cwZy9ScwLrCGZwnrHNP4BJ8qYcBMUbTgnV8AZD
         Fq5lEUA1N/a0IDhTl8v39W85Z2Y3hc6dSvKwlzYJZn/IKLkzYWJ5x2+v9AM8q4mRZI32
         3G9gyYHQb3uqTOCExgTpPJ2xETFTN2zKdYuN+uDcVaG1q+Zn0X+h5Rnowa+DpUxdWD3Y
         OwoTcNnuBW5zyxkTbFPhz3Avh2eT8CdKz1GG6GFCjkAohRCh2ZSyadEiVKdwH3AnZDCf
         4O9W/5LX6jRY2MeThTkJ0gbm6Fc69AFj9lbB7A+1J1mUc6m7EM4IG1gyfvdztyOVc+XB
         fdnw==
X-Gm-Message-State: AOAM531eefthBqQeXvMiaV+20hAnOINhT8+h3203CiRc3Mx4Mx9h+sYT
        H2R+UsT41nNgCFe2z4ErVxiuNqvr1b6SHO5I5TE=
X-Google-Smtp-Source: ABdhPJzvLcRTTz8mzFykNg5WWHW5++iaGaqWYLVUMjToOkVWsF3VDeNRldk0q/0EGL4ZvE4z8L25Ki0mhPEIAXHCWXY=
X-Received: by 2002:a50:bf03:: with SMTP id f3mr17498445edk.368.1590438780625;
 Mon, 25 May 2020 13:33:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200521211036.668624-1-olteanv@gmail.com> <20200521211036.668624-11-olteanv@gmail.com>
 <20200524142609.GB1281067@splinter> <CA+h21hpktNFcpwxTXVFikyWfgHkFZDofZ8=qVqraxcUp_EwJqg@mail.gmail.com>
 <20200525201111.GB1449199@splinter>
In-Reply-To: <20200525201111.GB1449199@splinter>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 25 May 2020 23:32:49 +0300
Message-ID: <CA+h21hpJQvMjdgysyrPDGMN1T-Vve8Bqide0Yw+oQjwnkaucnQ@mail.gmail.com>
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

On Mon, 25 May 2020 at 23:11, Ido Schimmel <idosch@idosch.org> wrote:
>
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

Ok, should this be a new ndo or some already existing mechanism? In
what level of detail does the bridge need to know what filters is the
virtual interface going to apply? Just binary yes/no? In that case,
could it only check for the netdev ops?

> >
> > > > +                             break;
> > > > +                     }
> > > > +             }
> > > > +
> > > > +             if (sw_bridging)
> > > > +                     flags |= mask;
> > > > +             else
> > > > +                     flags &= ~mask;
> > > > +
> > > > +             if (flags == p->flags)
> > > > +                     continue;
> > > > +
> > > > +             err = br_switchdev_set_port_flag(p, flags, mask);
> > > > +             if (err)
> > > > +                     return err;
> > > > +
> > > > +             p->flags = flags;
> > > > +     }
> > > > +
> > > > +     return 0;
> > > > +}
> > > > +
> > > >  int nbp_backup_change(struct net_bridge_port *p,
> > > >                     struct net_device *backup_dev)
> > > >  {
> > > > @@ -231,6 +270,7 @@ static void nbp_update_port_count(struct net_bridge *br)
> > > >               br->auto_cnt = cnt;
> > > >               br_manage_promisc(br);
> > > >       }
> > > > +     br_manage_host_flood(br);
> > > >  }
> > > >
> > > >  static void nbp_delete_promisc(struct net_bridge_port *p)
> > > > diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
> > > > index 015209bf44aa..360806ac7463 100644
> > > > --- a/net/bridge/br_switchdev.c
> > > > +++ b/net/bridge/br_switchdev.c
> > > > @@ -56,7 +56,9 @@ bool nbp_switchdev_allowed_egress(const struct net_bridge_port *p,
> > > >
> > > >  /* Flags that can be offloaded to hardware */
> > > >  #define BR_PORT_FLAGS_HW_OFFLOAD (BR_LEARNING | BR_FLOOD | \
> > > > -                               BR_MCAST_FLOOD | BR_BCAST_FLOOD)
> > > > +                               BR_MCAST_FLOOD | BR_BCAST_FLOOD | \
> > > > +                               BR_HOST_FLOOD | BR_HOST_MCAST_FLOOD | \
> > > > +                               BR_HOST_BCAST_FLOOD)
> > > >
> > > >  int br_switchdev_set_port_flag(struct net_bridge_port *p,
> > > >                              unsigned long flags,
> > > > --
> > > > 2.25.1
> > > >
> >
> > Thanks,
> > -Vladimir

Thanks,
-Vladimir
