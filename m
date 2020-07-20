Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A708225D19
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 13:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728425AbgGTLIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 07:08:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728404AbgGTLIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 07:08:10 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 953DFC061794
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 04:08:09 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id dg28so12453804edb.3
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 04:08:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EIVlje0xMuG4y2V67vBsTV4pOklQcG1EhQ3oQNJrYhU=;
        b=HCTFrEcjb4IF9QwY0/de1v7KGZWVOFW6snXZKpBfg++fSds4CGDWPiWLdf57qp3nnO
         ESqf9oQJGxFbfSZhMLP0Z6s9iKy3iflmis84IDgYUaxpwyNkx1apMZe0+udYtscWwjZD
         /zWUvhG4zM9QD+impXvhscuglN/SkzAYhZJ6+ZyPpLvbMbvrV4biWXSsIhBVYiQgKzLM
         WTlg7QZLNLHDzZ2YHsCGtDg2VssfhCwAQLO4/a5BXSsN0i3rJZDeORjGu/cmCca4s7Sy
         DE94n9HU8QebvPLOdkfoceldm/16X77OLUTRfzupzshFYtlHbHvJZ4fx5RcTj2v32dTf
         liXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EIVlje0xMuG4y2V67vBsTV4pOklQcG1EhQ3oQNJrYhU=;
        b=SPz0ELJxuKsHpOnQnMiSmtL4WU3C3wi6WUuxwiJmnxIswW5CdUy2bfWz7ko5wmMqMX
         6RBef8KRuMk3tY2FJtq2PMDPym+OVWcFjDhZpVyqBY80fv6XwnBs/zuzj+/5tbbtPBz1
         EdhyOu5S2DVk+n/IuQnuDpwRXpSOfDi+exeUh7Il4ZaSLwIJdBrxa/SyYK4P7geGoBGO
         K7OZV1hPiuH1CJTB9UeeLgEZj9e91foYGCInCWSVFGATxY/Dam0belLeBlvk9jSEBpCu
         JHJMmnX8YbKEPxx7334E0pOzKOkknlcW3F8q9UvIcCqQr5Vmx5v3MPVIE/XkV7IXNCQa
         /GcQ==
X-Gm-Message-State: AOAM533cX5tf0UBwhlsno281DSMCo6DcBMqLDs3zN/IwCsJ/XkxWQrhW
        5Nzdz1Kpi0+5RpVy33fOwPE=
X-Google-Smtp-Source: ABdhPJwgx9CSv0NW2anVMgDWL+1QjtT//fbv2uS5BLfOeXXKgXAIS07rAFaOG0YgxkQ+89CrSVwdew==
X-Received: by 2002:aa7:d4ca:: with SMTP id t10mr20931067edr.244.1595243288186;
        Mon, 20 Jul 2020 04:08:08 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id fx16sm2586086ejb.9.2020.07.20.04.08.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 04:08:07 -0700 (PDT)
Date:   Mon, 20 Jul 2020 14:08:05 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     UNGLinuxDriver@microchip.com
Cc:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Ivan Vecera <ivecera@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>
Subject: Re: [PATCH RFC net-next 10/13] net: bridge: add port flags for host
 flooding
Message-ID: <20200720110805.3qr2s6epwfivloxz@skbuf>
References: <20200521211036.668624-1-olteanv@gmail.com>
 <20200521211036.668624-11-olteanv@gmail.com>
 <a906e4d4-2551-7fe6-f2fc-6a7e77be6b4e@cumulusnetworks.com>
 <CA+h21hq2Uo_ihec56v=AYr_s3dv0XrDzZpQLEotkrSQe803wrw@mail.gmail.com>
 <20200522184534.7hynm6jain76n5dr@ws.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522184534.7hynm6jain76n5dr@ws.localdomain>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 22, 2020 at 08:45:34PM +0200, Allan W. Nielsen wrote:
> On 22.05.2020 16:13, Vladimir Oltean wrote:
> > EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> > 
> > On Fri, 22 May 2020 at 15:38, Nikolay Aleksandrov
> > <nikolay@cumulusnetworks.com> wrote:
> > > 
> > > On 22/05/2020 00:10, Vladimir Oltean wrote:
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
> > > 
> > > Can we do this only at port add/del ?
> > > Right now it will be invoked also by br_port_flags_change() upon BR_AUTO_MASK flag change.
> > > 
> > 
> > Yes, we can do that.
> > Actually I have some doubts about BR_HOST_BCAST_FLOOD. We can't
> > disable that in the no-foreign-interface case, can we? For IPv6, it
> > looks like the stack does take care of installing dev_mc addresses for
> > the neighbor discovery protocol, but for IPv4 I guess the assumption
> > is that broadcast ARP should always be processed?
> 
> Ideally this should be per VLAN. In case of IPv4, you only need to be
> part of the broadcast domain on VLANs with an associated vlan-interface.
> 

In Ocelot, what is the mechanism to remove the CPU from the flood domain
of a particular VLAN?

I thought of 2 approaches:

- VLAN_FLOOD_DIS in ANA:ANA_TABLES:VLANTIDX. But this disables flooding
  at the level of the entire VLAN, regardless of source and destination
  ports. So it cannot be used, as it interferes with the VLANs from the
  bridge.

- Removing the CPU from VLAN_PORT_MASK. But the documentation for this
  field says:

      Frames classified to this VLAN can only be 0x3F
      sent to ports in this mask. Note that the CPU
      port module is always member of all VLANs
      and its VLAN membership can therefore not
      be configured through this mask.

So I don't think any of them works.

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
> > > >
> > > 
> > 
> > Thanks,
> > -Vladimir
> /Allan

Thanks,
-Vladimir
