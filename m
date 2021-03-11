Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3B6F337E34
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 20:30:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbhCKTaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 14:30:14 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:27031 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbhCKTaA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 14:30:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615491000; x=1647027000;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0rxFz13zSNAdp0HoScXbT7jgAWIyZz5cVr3MqUsXhTo=;
  b=xCxVrDuJ35BlunkK8MWRCeYTJVF2iXCKVh3NaMU28iz/eR8p1xlguF3S
   qqzrqItdZdSZ0WivARlQB+n6VL/ZROn716zkLhzXTEzBeZb8EjduOFyAn
   Bk8aQHrGxOqzMtsb3CaZdmY8cJo1cBKZXZUuuDp7i87QkEZh9tHH18h+b
   ftiGWtJxB7mkXjo3nEsdw4FkWjxPXT/P+llQL7QKtFQp1GxS2HK8IZcfx
   hZLEpQeOxUa0dpPVfuMdfr2FXd+uTCmkv3rZCZNFHZOXMk/IsfzsIN5AP
   Qe1eMm1B/QcTbfBi+FiCQnUZnn/9Ioz0DpaqWaT10fArXYCLr7ZQUi9Pi
   g==;
IronPort-SDR: U0sgjKeDykDt3P6xVvil3dM8w0fSHUTqoutXmUqaUfUYJ8Ekl5EqzhYNGAlXKceYu1O9IfqCZ6
 lPJOIAFuxjK1mbXuGDU8JEMXjZDD/iY6y/86xuQwc+SYZ06Ty2oS6+veKrXXmtNzVQKFX1Boot
 1FovcR3TYs7/30waZ7HgKFrI/gSqH3XYMotgoBR9Il2dWztARgutlUH5Dch4duwR+fsjEQlkDl
 piN0EJETOtmvUeFpG44rysE2vvSJoL2uk4/m8VgPVuFkbmqkRDdXmtl7u5Ntp7CpLrTxoqECCY
 qjA=
X-IronPort-AV: E=Sophos;i="5.81,241,1610434800"; 
   d="scan'208";a="106855171"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Mar 2021 12:29:59 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 11 Mar 2021 12:29:59 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Thu, 11 Mar 2021 12:29:59 -0700
Date:   Thu, 11 Mar 2021 20:30:08 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <vladimir.oltean@nxp.com>, <claudiu.manoil@nxp.com>,
        <alexandre.belloni@bootlin.com>, <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: ocelot: Extend MRP
Message-ID: <20210311193008.vasrdiephy36fnxa@soft-dev3-1.localhost>
References: <20210310205140.1428791-1-horatiu.vultur@microchip.com>
 <20210311002549.4ilz4fw2t6sdxxtv@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20210311002549.4ilz4fw2t6sdxxtv@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 03/11/2021 02:25, Vladimir Oltean wrote:

Hi Vladimir,

> 
> On Wed, Mar 10, 2021 at 09:51:40PM +0100, Horatiu Vultur wrote:
> > This patch extends MRP support for Ocelot.  It allows to have multiple
> > rings and when the node has the MRC role it forwards MRP Test frames in
> > HW. For MRM there is no change.
> >
> > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> > ---
> >  drivers/net/ethernet/mscc/ocelot.c     |   6 -
> >  drivers/net/ethernet/mscc/ocelot_mrp.c | 229 +++++++++++++++++--------
> >  include/soc/mscc/ocelot.h              |  10 +-
> >  3 files changed, 158 insertions(+), 87 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
> > index 46e5c9136bac..9b79363db17f 100644
> > --- a/drivers/net/ethernet/mscc/ocelot.c
> > +++ b/drivers/net/ethernet/mscc/ocelot.c
> > @@ -772,12 +772,6 @@ int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp, struct sk_buff **nskb)
> >
> >       skb->protocol = eth_type_trans(skb, dev);
> >
> > -#if IS_ENABLED(CONFIG_BRIDGE_MRP)
> > -     if (skb->protocol == cpu_to_be16(ETH_P_MRP) &&
> > -         cpuq & BIT(OCELOT_MRP_CPUQ))
> > -             skb->offload_fwd_mark = 0;
> > -#endif
> > -
> 
> I suppose net/dsa/tag_ocelot.c doesn't need it any longer either?

Yes, that should be removed.

> 
> >       *nskb = skb;
> >
> >       return 0;
> > diff --git a/drivers/net/ethernet/mscc/ocelot_mrp.c b/drivers/net/ethernet/mscc/ocelot_mrp.c
> > index 683da320bfd8..86b36e5d2279 100644
> > --- a/drivers/net/ethernet/mscc/ocelot_mrp.c
> > +++ b/drivers/net/ethernet/mscc/ocelot_mrp.c
> > @@ -1,8 +1,5 @@
> >  // SPDX-License-Identifier: (GPL-2.0 OR MIT)
> >  /* Microsemi Ocelot Switch driver
> > - *
> > - * This contains glue logic between the switchdev driver operations and the
> > - * mscc_ocelot_switch_lib.
> >   *
> >   * Copyright (c) 2017, 2019 Microsemi Corporation
> >   * Copyright 2020-2021 NXP Semiconductors
> > @@ -15,13 +12,33 @@
> >  #include "ocelot.h"
> >  #include "ocelot_vcap.h"
> >
> > -static int ocelot_mrp_del_vcap(struct ocelot *ocelot, int port)
> > +static const u8 mrp_test_dmac[] = {0x01, 0x15, 0x4e, 0x00, 0x00, 0x01 };
> > +static const u8 mrp_control_dmac[] = {0x01, 0x15, 0x4e, 0x00, 0x00, 0x02 };
> > +
> > +static int ocelot_mrp_find_port(struct ocelot *ocelot, struct ocelot_port *p)
> 
> Could this be named:
> struct ocelot_port *ocelot_find_mrp_partner_port(struct ocelot_port *ocelot_port)
> 
> and return NULL instead of zero on "not found"? Zero is a perfectly
> valid port number, definitely not what you want.

I will rename it in the next version.

> 
> > +{
> > +     int i;
> > +
> > +     for (i = 0; i < ocelot->num_phys_ports; ++i) {
> > +             struct ocelot_port *ocelot_port = ocelot->ports[i];
> > +
> > +             if (!ocelot_port || p == ocelot_port)
> > +                     continue;
> > +
> > +             if (ocelot_port->mrp_ring_id == p->mrp_ring_id)
> > +                     return i;
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> > +static int ocelot_mrp_del_vcap(struct ocelot *ocelot, int id)
> >  {
> >       struct ocelot_vcap_block *block_vcap_is2;
> >       struct ocelot_vcap_filter *filter;
> >
> >       block_vcap_is2 = &ocelot->block[VCAP_IS2];
> > -     filter = ocelot_vcap_block_find_filter_by_id(block_vcap_is2, port,
> > +     filter = ocelot_vcap_block_find_filter_by_id(block_vcap_is2, id,
> >                                                    false);
> >       if (!filter)
> >               return 0;
> > @@ -29,6 +46,87 @@ static int ocelot_mrp_del_vcap(struct ocelot *ocelot, int port)
> >       return ocelot_vcap_filter_del(ocelot, filter);
> >  }
> >
> > +static int ocelot_mrp_redirect_add_vcap(struct ocelot *ocelot, int src_port,
> > +                                     int dst_port)
> > +{
> > +     const u8 mrp_test_mask[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
> 
> OCD, but could you add a space between the opening bracket and the first
> 0xff? There's one more place where that should be done.

Good catch, I will update it.

> 
> > +     struct ocelot_vcap_filter *filter;
> > +     int err;
> > +
> > +     filter = kzalloc(sizeof(*filter), GFP_ATOMIC);
> > +     if (!filter)
> > +             return -ENOMEM;
> 
> Why atomic? Isn't SWITCHDEV_OBJ_ID_RING_ROLE_MRP put on the blocking
> notifier call chain?

Yes it is, so I shouldn't use GFP_ATOMIC.

> 
> > +
> > +     filter->key_type = OCELOT_VCAP_KEY_ETYPE;
> > +     filter->prio = 1;
> > +     filter->id.cookie = src_port;
> > +     filter->id.tc_offload = false;
> > +     filter->block_id = VCAP_IS2;
> > +     filter->type = OCELOT_VCAP_FILTER_OFFLOAD;
> > +     filter->ingress_port_mask = BIT(src_port);
> > +     ether_addr_copy(filter->key.etype.dmac.value, mrp_test_dmac);
> > +     ether_addr_copy(filter->key.etype.dmac.mask, mrp_test_mask);
> > +     filter->action.mask_mode = OCELOT_MASK_MODE_REDIRECT;
> > +     filter->action.port_mask = BIT(dst_port);
> > +
> > +     err = ocelot_vcap_filter_add(ocelot, filter, NULL);
> > +     if (err)
> > +             kfree(filter);
> > +
> > +     return err;
> > +}
> > +
> > +static int ocelot_mrp_copy_add_vcap(struct ocelot *ocelot, int port,
> > +                                 int prio, int cookie)
> 
> "cookie" should be unsigned long I think?

Yes, it should be unsigned long.

> 
> > +{
> > +     const u8 mrp_mask[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0x00 };
> > +     struct ocelot_vcap_filter *filter;
> > +     int err;
> > +
> > +     filter = kzalloc(sizeof(*filter), GFP_ATOMIC);
> > +     if (!filter)
> > +             return -ENOMEM;
> > +
> > +     filter->key_type = OCELOT_VCAP_KEY_ETYPE;
> > +     filter->prio = prio;
> > +     filter->id.cookie = cookie;
> > +     filter->id.tc_offload = false;
> > +     filter->block_id = VCAP_IS2;
> > +     filter->type = OCELOT_VCAP_FILTER_OFFLOAD;
> > +     filter->ingress_port_mask = BIT(port);
> > +     /* Here is possible to use control or test dmac because the mask
> > +      * doesn't cover the LSB
> > +      */
> > +     ether_addr_copy(filter->key.etype.dmac.value, mrp_test_dmac);
> > +     ether_addr_copy(filter->key.etype.dmac.mask, mrp_mask);
> > +     filter->action.mask_mode = OCELOT_MASK_MODE_PERMIT_DENY;
> > +     filter->action.port_mask = 0x0;
> > +     filter->action.cpu_copy_ena = true;
> > +     filter->action.cpu_qu_num = OCELOT_MRP_CPUQ;
> > +
> > +     err = ocelot_vcap_filter_add(ocelot, filter, NULL);
> > +     if (err)
> > +             kfree(filter);
> > +
> > +     return err;
> > +}
> > +
> > +static void ocelot_mrp_save_mac(struct ocelot *ocelot,
> > +                             struct ocelot_port *port)
> > +{
> > +     ocelot_mact_learn(ocelot, PGID_MRP, mrp_test_dmac,
> > +                       port->pvid_vlan.vid, ENTRYTYPE_LOCKED);
> > +     ocelot_mact_learn(ocelot, PGID_MRP, mrp_control_dmac,
> > +                       port->pvid_vlan.vid, ENTRYTYPE_LOCKED);
> 
> Let me make sure I understand.
> By learning these multicast addresses, you mark them as 'not unknown' in
> the MAC table, because otherwise they will be flooded, including to the
> CPU port module, and there's no way you can remove the CPU from the
> flood mask, even if the packets get later redirected through VCAP IS2?

Yes, so far you are right.

> I mean that's the reason why we have the policer on the CPU port for the
> drop action in ocelot_vcap_init, no?

I am not sure that would work because I want the action to be redirect
and not policy. Or maybe I am missing something?

> 
> > diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
> > index 425ff29d9389..c41696d2e82b 100644
> > --- a/include/soc/mscc/ocelot.h
> > +++ b/include/soc/mscc/ocelot.h
> > @@ -51,6 +51,7 @@
> >   */
> >
> >  /* Reserve some destination PGIDs at the end of the range:
> > + * PGID_MRP: used for not flooding MRP frames to CPU
> 
> Could this be named PGID_BLACKHOLE or something? It isn't specific to
> MRP if I understand correctly. We should also probably initialize it
> with zero.

It shouldn't matter the value, what is important that the CPU port not
to be set. Because the value of this PGID will not be used in the
fowarding decision.
Currently only MRP is using it so that is the reason for naming it like
that but I can rename it and initialized it to 0 to be more clear.

> 
> >   * PGID_CPU: used for whitelisting certain MAC addresses, such as the addresses
> >   *           of the switch port net devices, towards the CPU port module.
> >   * PGID_UC: the flooding destinations for unknown unicast traffic.
> > @@ -59,6 +60,7 @@
> >   * PGID_MCIPV6: the flooding destinations for IPv6 multicast traffic.
> >   * PGID_BC: the flooding destinations for broadcast traffic.
> >   */
> > +#define PGID_MRP                     57
> >  #define PGID_CPU                     58
> >  #define PGID_UC                              59
> >  #define PGID_MC                              60
> > @@ -611,6 +613,8 @@ struct ocelot_port {
> >
> >       struct net_device               *bond;
> >       bool                            lag_tx_active;
> > +
> > +     u16                             mrp_ring_id;
> >  };
> >
> >  struct ocelot {
> > @@ -679,12 +683,6 @@ struct ocelot {
> >       /* Protects the PTP clock */
> >       spinlock_t                      ptp_clock_lock;
> >       struct ptp_pin_desc             ptp_pins[OCELOT_PTP_PINS_NUM];
> > -
> > -#if IS_ENABLED(CONFIG_BRIDGE_MRP)
> > -     u16                             mrp_ring_id;
> > -     struct net_device               *mrp_p_port;
> > -     struct net_device               *mrp_s_port;
> > -#endif
> >  };
> >
> >  struct ocelot_policer {
> > --
> > 2.30.1
> >

-- 
/Horatiu
