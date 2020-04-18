Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 640401AEFC3
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 16:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728881AbgDROoq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 10:44:46 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:63765 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728833AbgDROon (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 10:44:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1587221082; x=1618757082;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mDZK0QP8g4s3T7ykXwPmcB/MChcNXpBmfTDO7L022ZY=;
  b=yY9yN6zTnJXJnhz2JQeCdj53NxVPGSZOyGGCTsp/4sCzKC5R/zVTU92S
   ZbLIkgsIdboTSHyzZc7UQ8KQcugB7fhqr99J5OilJzDuNgYe+8kUTLXWN
   FgotGyuVJ115eyGWoA0tp3ydjhXYQAh/MIMt6jDqD18Zo/Vc+McKjiTSi
   1DdIy9SIxfqZrtnG//YgskkDiNfn2zX7uNEqz/xeVWHqS35Hl7ypE4n1k
   6zSvASMVQJevtp5hIemILC6ILgf8LR1S77rRdzUp9epEtSwEB/jmE6DGw
   EPpdqKm9jPle9pLnBmEftJUt7pNuYRQiLoisblBvXm2lxptHSM/8qs6GQ
   g==;
IronPort-SDR: 9nycyirsl00DtlSc+aWZ6i381p0+qmIyKgQBUtHPHWJXrEpmF21Ym9bswM00y2sERTCmEMorq5
 CMfbSe5xhHhVelmUKY7kCzFeqrOXvD0C2NWOaNXu1gGcUX5s0v8AQ/TtbMZybpVnFh8umcWtiX
 47hbSxJbopTotXWdTqB0R0j9WMSI9VhtGpQ9BIPBCPY/F5STYARdOCmGXvNHIWQd6Bid95F578
 xIViEZxCQtpkCPs313o23ZKJEZTuNX02uTG+FRojn/cOyIQcTgLKM1GjZ8eokBlwG75o2lxwUf
 cgA=
X-IronPort-AV: E=Sophos;i="5.72,399,1580799600"; 
   d="scan'208";a="70764314"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Apr 2020 07:44:30 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 18 Apr 2020 07:44:07 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Sat, 18 Apr 2020 07:44:35 -0700
Date:   Sat, 18 Apr 2020 16:44:29 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
CC:     <davem@davemloft.net>, <jiri@resnulli.us>, <ivecera@redhat.com>,
        <kuba@kernel.org>, <roopa@cumulusnetworks.com>,
        <olteanv@gmail.com>, <andrew@lunn.ch>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <UNGLinuxDriver@microchip.com>
Subject: Re: [RFC net-next v5 9/9] bridge: mrp: Integrate MRP into the bridge
Message-ID: <20200418144429.5y2cljj6vytliwvp@soft-dev3.microsemi.net>
References: <20200414112618.3644-1-horatiu.vultur@microchip.com>
 <20200414112618.3644-10-horatiu.vultur@microchip.com>
 <48c8e196-5808-d7c8-25c3-dff8f56dea5b@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <48c8e196-5808-d7c8-25c3-dff8f56dea5b@cumulusnetworks.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 04/18/2020 11:25, Nikolay Aleksandrov wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On 14/04/2020 14:26, Horatiu Vultur wrote:
> > To integrate MRP into the bridge, the bridge needs to do the following:
> > - add new flag(BR_MPP_AWARE) to the net bridge ports, this bit will be set when
> >   the port is added to an MRP instance. In this way it knows if the frame was
> >   received on MRP ring port
> > - detect if the MRP frame was received on MRP ring port in that case it would be
> >   processed otherwise just forward it as usual.
> > - enable parsing of MRP
> > - before whenever the bridge was set up, it would set all the ports in
> >   forwarding state. Add an extra check to not set ports in forwarding state if
> >   the port is an MRP ring port. The reason of this change is that if the MRP
> >   instance initially sets the port in blocked state by setting the bridge up it
> >   would overwrite this setting.
> >
> > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> > ---
> >  include/linux/if_bridge.h |  1 +
> >  net/bridge/br_device.c    |  3 +++
> >  net/bridge/br_if.c        |  2 ++
> >  net/bridge/br_input.c     |  3 +++
> >  net/bridge/br_netlink.c   |  5 +++++
> >  net/bridge/br_private.h   | 35 +++++++++++++++++++++++++++++++++++
> >  net/bridge/br_stp.c       |  6 ++++++
> >  net/bridge/br_stp_if.c    |  5 +++++
> >  8 files changed, 60 insertions(+)
> >
> > diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
> > index 9e57c4411734..10baa9efdae8 100644
> > --- a/include/linux/if_bridge.h
> > +++ b/include/linux/if_bridge.h
> > @@ -47,6 +47,7 @@ struct br_ip_list {
> >  #define BR_BCAST_FLOOD               BIT(14)
> >  #define BR_NEIGH_SUPPRESS    BIT(15)
> >  #define BR_ISOLATED          BIT(16)
> > +#define BR_MRP_AWARE         BIT(17)
> >
> >  #define BR_DEFAULT_AGEING_TIME       (300 * HZ)
> >
> > diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
> > index 0e3dbc5f3c34..8ec1362588af 100644
> > --- a/net/bridge/br_device.c
> > +++ b/net/bridge/br_device.c
> > @@ -463,6 +463,9 @@ void br_dev_setup(struct net_device *dev)
> >       spin_lock_init(&br->lock);
> >       INIT_LIST_HEAD(&br->port_list);
> >       INIT_HLIST_HEAD(&br->fdb_list);
> > +#if IS_ENABLED(CONFIG_BRIDGE_MRP)
> > +     INIT_LIST_HEAD(&br->mrp_list);
> > +#endif
> >       spin_lock_init(&br->hash_lock);
> >
> >       br->bridge_id.prio[0] = 0x80;
> > diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
> > index 4fe30b182ee7..ca685c0cdf95 100644
> > --- a/net/bridge/br_if.c
> > +++ b/net/bridge/br_if.c
> > @@ -333,6 +333,8 @@ static void del_nbp(struct net_bridge_port *p)
> >       br_stp_disable_port(p);
> >       spin_unlock_bh(&br->lock);
> >
> > +     br_mrp_port_del(br, p);
> > +
> >       br_ifinfo_notify(RTM_DELLINK, NULL, p);
> >
> >       list_del_rcu(&p->list);
> > diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
> > index fcc260840028..d5c34f36f0f4 100644
> > --- a/net/bridge/br_input.c
> > +++ b/net/bridge/br_input.c
> > @@ -342,6 +342,9 @@ rx_handler_result_t br_handle_frame(struct sk_buff **pskb)
> >               }
> >       }
> >
> > +     if (unlikely(br_mrp_process(p, skb)))
> > +             return RX_HANDLER_PASS;
> > +
> >  forward:
> >       switch (p->state) {
> >       case BR_STATE_FORWARDING:
> > diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
> > index 43dab4066f91..8826fcd1eb76 100644
> > --- a/net/bridge/br_netlink.c
> > +++ b/net/bridge/br_netlink.c
> > @@ -669,6 +669,11 @@ static int br_afspec(struct net_bridge *br,
> >                       if (err)
> >                               return err;
> >                       break;
> > +             case IFLA_BRIDGE_MRP:
> > +                     err = br_mrp_parse(br, p, attr, cmd, extack);
> > +                     if (err)
> > +                             return err;
> > +                     break;
> >               }
> >       }
> >
> > diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> > index 1f97703a52ff..5835828320b6 100644
> > --- a/net/bridge/br_private.h
> > +++ b/net/bridge/br_private.h
> > @@ -428,6 +428,10 @@ struct net_bridge {
> >       int offload_fwd_mark;
> >  #endif
> >       struct hlist_head               fdb_list;
> > +
> > +#if IS_ENABLED(CONFIG_BRIDGE_MRP)
> > +     struct list_head                __rcu mrp_list;
> > +#endif
> >  };
> >
> >  struct br_input_skb_cb {
> > @@ -1304,6 +1308,37 @@ unsigned long br_timer_value(const struct timer_list *timer);
> >  extern int (*br_fdb_test_addr_hook)(struct net_device *dev, unsigned char *addr);
> >  #endif
> >
> > +/* br_mrp.c */
> > +#if IS_ENABLED(CONFIG_BRIDGE_MRP)
> > +int br_mrp_parse(struct net_bridge *br, struct net_bridge_port *p,
> > +              struct nlattr *attr, int cmd, struct netlink_ext_ack *extack);
> > +int br_mrp_process(struct net_bridge_port *p, struct sk_buff *skb);
> > +bool br_mrp_enabled(struct net_bridge *br);
> > +void br_mrp_port_del(struct net_bridge *br, struct net_bridge_port *p);
> > +#else
> > +static inline int br_mrp_parse(struct net_bridge *br, struct net_bridge_port *p,
> > +                            struct nlattr *attr, int cmd,
> > +                            struct netlink_ext_ack *extack)
> > +{
> > +     return -EOPNOTSUPP;
> > +}
> > +
> > +static inline int br_mrp_process(struct net_bridge_port *p, struct sk_buff *skb)
> > +{
> > +     return 0;
> > +}
> > +
> > +static inline bool br_mrp_enabled(struct net_bridge *br)
> > +{
> > +     return 0;
> > +}
> > +
> > +static inline void br_mrp_port_del(struct net_bridge *br,
> > +                                struct net_bridge_port *p)
> > +{
> > +}
> > +#endif
> > +
> >  /* br_netlink.c */
> >  extern struct rtnl_link_ops br_link_ops;
> >  int br_netlink_init(void);
> > diff --git a/net/bridge/br_stp.c b/net/bridge/br_stp.c
> > index 1f14b8455345..3e88be7aa269 100644
> > --- a/net/bridge/br_stp.c
> > +++ b/net/bridge/br_stp.c
> > @@ -36,6 +36,12 @@ void br_set_state(struct net_bridge_port *p, unsigned int state)
> >       };
> >       int err;
> >
> > +     /* Don't change the state of the ports if they are driven by a different
> > +      * protocol.
> > +      */
> > +     if (p->flags & BR_MRP_AWARE)
> > +             return;
> > +
> >       p->state = state;
> >       err = switchdev_port_attr_set(p->dev, &attr);
> >       if (err && err != -EOPNOTSUPP)
> > diff --git a/net/bridge/br_stp_if.c b/net/bridge/br_stp_if.c
> > index d174d3a566aa..542b212d5033 100644
> > --- a/net/bridge/br_stp_if.c
> > +++ b/net/bridge/br_stp_if.c
> > @@ -200,6 +200,11 @@ void br_stp_set_enabled(struct net_bridge *br, unsigned long val)
> >  {
> >       ASSERT_RTNL();
> >
> > +     if (br_mrp_enabled(br)) {
> > +             br_warn(br, "STP can't be enabled if MRP is already enabled\n");
> 
> It'd be nice if this can be returned in an extack if this function is called from netlink.
> In addition this must return an error - otherwise writing to the sysfs file would be successful
> while nothing will have changed, so the user will think it worked. Check out set_stp_state().
> You can drop the br_warn, just make sure to return proper extack error from netlink (it is
> the preferred interface over sysfs, so simply returning an error for sysfs would be enough).

I will change the declaration of this function to return an error code
and also add the extack as argument.

> 
> > +             return;
> > +     }
> > +
> >       if (val) {
> >               if (br->stp_enabled == BR_NO_STP)
> >                       br_stp_start(br);
> >
> 

-- 
/Horatiu
