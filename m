Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 020091DE7D0
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 15:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729926AbgEVNOJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 09:14:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729334AbgEVNOJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 09:14:09 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABFC3C061A0E
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 06:14:08 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id x1so12958429ejd.8
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 06:14:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KauHjzz1ACaqtH7acus3gStR5t0R/uxCddIWBpaKBpk=;
        b=uJYCYvFBReARHrYONN2exbzPCy/9uKGF8pxI8Uh65XgiMiUEZh4UiXIrFgrg9vr/Gj
         tSh67e4S0rU5Hdti+BlupodOtzpuEF+RY0pHV/hN+Nz23wqKsYgOnanajaJTwyQ+fdrP
         jRtZThPih/GK0kRdyvdIq6ELQE/b9ehdNyfF5zRjchkk++x4jffzHUQw9cewJESY0DIF
         ZcCdQfXBi5p9GpMJlHnCMVUS5Kt7aCq2sSW0YfLtzM6l1sjlbbHi6jlm+y5W27q/AERl
         5nU9J0Uydj5om09P8pFYV723JRPrjIF87sxx7xmQlduwSRDZ5E8mQAn2pTOV+17BFNKk
         /dBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KauHjzz1ACaqtH7acus3gStR5t0R/uxCddIWBpaKBpk=;
        b=G1AuscJtbgLMwhZSvGtcpeqvu1vB6BM/I4prpLl85IRVVAarZ/ZnZeq5wbksRSREvu
         aESVD1tPBFm9RVMXi3DCF6H/S7hegL8jtAQAUSRSKCPCWa9fDGztLoY7ZvEnrfvn8hkS
         98Sg/VcC4nY5upxiJ6rlb8XZ0LyoPptJsQQduYaTYi3eKsoX5L2/qGJWgd4f8Ec7JtkS
         OP/QkjA2JnjM0FemZauSyOYR0HHZm28BlstjC0Q8Nv/jh8YSxcoPNUphTChB08kK71CX
         XanKjCkadecgtZceE5ZsO+W5mxFzT7TXKw3osqEB/svrx8OYL3xOXUEyH9BqvdbiBk5v
         TK+g==
X-Gm-Message-State: AOAM530ZEwH7bFvro7zR5kZMcI5xvH0VShKJt7EnJdBU9LaLqPCXFxj5
        MH8OcioK+TnttGoYSyBagdswMbC9tbaeVa0+oz0=
X-Google-Smtp-Source: ABdhPJwJxu3GFaFTMH4BiWIc5mv5G22sIBckJ3LDocghSIKPVs8lh0dH3KtqQVD3YruRxNIB+7Vig64liND6sQ2EZMI=
X-Received: by 2002:a17:906:a843:: with SMTP id dx3mr7674471ejb.396.1590153247253;
 Fri, 22 May 2020 06:14:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200521211036.668624-1-olteanv@gmail.com> <20200521211036.668624-11-olteanv@gmail.com>
 <a906e4d4-2551-7fe6-f2fc-6a7e77be6b4e@cumulusnetworks.com>
In-Reply-To: <a906e4d4-2551-7fe6-f2fc-6a7e77be6b4e@cumulusnetworks.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 22 May 2020 16:13:56 +0300
Message-ID: <CA+h21hq2Uo_ihec56v=AYr_s3dv0XrDzZpQLEotkrSQe803wrw@mail.gmail.com>
Subject: Re: [PATCH RFC net-next 10/13] net: bridge: add port flags for host flooding
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Ivan Vecera <ivecera@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 May 2020 at 15:38, Nikolay Aleksandrov
<nikolay@cumulusnetworks.com> wrote:
>
> On 22/05/2020 00:10, Vladimir Oltean wrote:
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
>
> Can we do this only at port add/del ?
> Right now it will be invoked also by br_port_flags_change() upon BR_AUTO_MASK flag change.
>

Yes, we can do that.
Actually I have some doubts about BR_HOST_BCAST_FLOOD. We can't
disable that in the no-foreign-interface case, can we? For IPv6, it
looks like the stack does take care of installing dev_mc addresses for
the neighbor discovery protocol, but for IPv4 I guess the assumption
is that broadcast ARP should always be processed?

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
> >
>

Thanks,
-Vladimir
