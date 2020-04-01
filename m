Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7811E19AF74
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 18:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732377AbgDAQKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 12:10:24 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:3445 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgDAQKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 12:10:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1585757423; x=1617293423;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=f8HUbR5cvKWzDVauqwjQ24njzyfgLggG0ctNNboTQFU=;
  b=fO/jf8TutCoI43KaS47R5OmNfzsK8mCzhq4H++04EYNb8DmU+U67/W4l
   TjYCBsuNR3zM3GC34GpRKVxcpULQdFTVuV9ue4qtnq2HNQfdjW18yojaG
   DQNg1XZT5ZP9fhLOnn1sIjSKPre/8pxGoaBs2bWVZLeEeD23eprbA9GKh
   UCB7QrUz2ZHVv1xnjrcF4Smv0dE5biZRwYDvSoVyWfL/loTU0DVbfdjp/
   uZ5L1uht7GYdGs/QO1T7X7NUwTH26jYyRXe1RU6JAF2VtsSvdbt4Boodq
   KAnjmxv0q0l3oMloPYsfVevpKnumwz/deHJQ8qn8AAXmzP+MM456iReu9
   Q==;
IronPort-SDR: nSyJyqtwj8K4LDMJJsAl9jtCU9KdQnPMRWdqG7FtalZmPDMMK8cR9+PqOgSljtwn5oTvWKMhkH
 H+HGNvrBGM+5ZV5z2P1wQbbRYPK2DNGeBh4VXBQXXT4b8v4tVR0+UW1NWtFawCEZHRCevumLr3
 OXp8IasiePIWCSU2BFpqVF+eFeZCvVSYHHh1zss1U0yyEr7CsGD4Ej7q1OI9AL7MKI7JLFu4uq
 qdZ8pEpbgPt/02Qfq0gsR2jyPwQQuqTj+NHLl8BqvwjVoyIvzUpcaNJoWdix3CyS2lfSgquRmq
 osY=
X-IronPort-AV: E=Sophos;i="5.72,332,1580799600"; 
   d="scan'208";a="7756912"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Apr 2020 09:10:22 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 1 Apr 2020 09:10:22 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Wed, 1 Apr 2020 09:10:22 -0700
Date:   Wed, 1 Apr 2020 18:10:21 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
CC:     <davem@davemloft.net>, <jiri@resnulli.us>, <ivecera@redhat.com>,
        <kuba@kernel.org>, <roopa@cumulusnetworks.com>,
        <olteanv@gmail.com>, <andrew@lunn.ch>,
        <UNGLinuxDriver@microchip.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bridge@lists.linux-foundation.org>
Subject: Re: [RFC net-next v4 8/9] bridge: mrp: Integrate MRP into the bridge
Message-ID: <20200401161021.3s2sqvma7r7wpo7h@soft-dev3.microsemi.net>
References: <20200327092126.15407-1-horatiu.vultur@microchip.com>
 <20200327092126.15407-9-horatiu.vultur@microchip.com>
 <17d9fb2a-cb48-7bb6-cb79-3876ca3a74b2@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <17d9fb2a-cb48-7bb6-cb79-3876ca3a74b2@cumulusnetworks.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nik,

The 03/30/2020 19:16, Nikolay Aleksandrov wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On 27/03/2020 11:21, Horatiu Vultur wrote:
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
> >  net/bridge/br_input.c     |  3 +++
> >  net/bridge/br_netlink.c   |  5 +++++
> >  net/bridge/br_private.h   | 22 ++++++++++++++++++++++
> >  net/bridge/br_stp.c       |  6 ++++++
> >  6 files changed, 40 insertions(+)
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
> > index 43dab4066f91..77bc96745be6 100644
> > --- a/net/bridge/br_netlink.c
> > +++ b/net/bridge/br_netlink.c
> > @@ -669,6 +669,11 @@ static int br_afspec(struct net_bridge *br,
> >                       if (err)
> >                               return err;
> >                       break;
> > +             case IFLA_BRIDGE_MRP:
> > +                     err = br_mrp_parse(br, p, attr, cmd);
> > +                     if (err)
> > +                             return err;
> > +                     break;
> >               }
> >       }
> >
> > diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> > index 1f97703a52ff..38894f2cf98f 100644
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
> > @@ -1304,6 +1308,24 @@ unsigned long br_timer_value(const struct timer_list *timer);
> >  extern int (*br_fdb_test_addr_hook)(struct net_device *dev, unsigned char *addr);
> >  #endif
> >
> > +/* br_mrp.c */
> > +#if IS_ENABLED(CONFIG_BRIDGE_MRP)
> > +int br_mrp_parse(struct net_bridge *br, struct net_bridge_port *p,
> > +              struct nlattr *attr, int cmd);
> > +int br_mrp_process(struct net_bridge_port *p, struct sk_buff *skb);
> > +#else
> > +static inline int br_mrp_parse(struct net_bridge *br, struct net_bridge_port *p,
> > +                            struct nlattr *attr, int cmd)
> > +{
> > +     return -1;
> 
> You should return proper error here.

It will return -EOPNOTSUPP.

> 
> > +}
> > +
> > +static inline int br_mrp_process(struct net_bridge_port *p, struct sk_buff *skb)
> > +{
> > +     return -1;
> 
> The bridge can't possibly work with MRP disabled with this.

Good catch, it will return 0.

> 
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
> 
> Maybe disallow STP type (kernel/user-space/no-stp) changing as well, force it to no-stp.

I am not sure that I understand completely here, do you want me to
disable STP if MRP is started?

> 
> >       p->state = state;
> >       err = switchdev_port_attr_set(p->dev, &attr);
> >       if (err && err != -EOPNOTSUPP)
> >
> 

-- 
/Horatiu
