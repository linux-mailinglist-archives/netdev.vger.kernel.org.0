Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F387531DD4D
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 17:29:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234187AbhBQQ1y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 11:27:54 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:22825 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234170AbhBQQ1w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 11:27:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1613579271; x=1645115271;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WWWl9nm99DtxQeUAk+aM9D9jAqCvHgBA7BfwU7mUjY0=;
  b=di13Uxyb7buB3f5CuuCTWnMLaqOK4WuZwsoIDz5scwGEbbLZSnK32jxP
   XKbUZ2c8yywP31oQzFGXKe7YaKqcDlzfUp0Sx2gGT7ir40XpI8Ozua2M6
   r2EHg7YLcu5Of6CGj5PjElLvQjsee4hnhmUMikzMyMf4hdzD7rFG0gaJw
   VJp3olU64ujuyiHfTnPDgnHuEO/c1Ileysi1V1UrbU+MlbosWJcvO9KcZ
   B43gCsbIqA48eB4PadCgqKN/wB86kQmRnjdp6bvBjSWvL9K2EhleOBzIo
   5iyBa0R4qVXQsUN5NgvookK5RLW4IxHWGt9XKXvA2IMTfHe4pGtAnNvYN
   Q==;
IronPort-SDR: U+HnFyCxcxE5Ob60Nuu8ASQ8qnQL+0jFz3khAFRw4xVcg2KmKPxXCWayan7pb1CD7Z0zWMtMri
 1UmKFvkWLRw1INaCT8pBF0rZhCVOZV0Gk5qmHXyHptjyLT4Em8ABJy8VFbSjhE7ru/pTl/4zNS
 PRSA7uo0eZ85VeG5OmGOkF+iEHkUzEKzuWIfHHCK5OyYWSJg5DcBltNL0GofuS4aLO105CjPOW
 W1w8avln62/K4gmW8vaCAzfFRT5HHU5HRBI7EHjcEhwSOPO2l9k9QZZPa6mVnJhLpszVd9rraf
 aeM=
X-IronPort-AV: E=Sophos;i="5.81,184,1610434800"; 
   d="scan'208";a="44474054"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Feb 2021 09:25:53 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 17 Feb 2021 09:25:53 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Wed, 17 Feb 2021 09:25:53 -0700
Date:   Wed, 17 Feb 2021 17:25:52 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "ivecera@redhat.com" <ivecera@redhat.com>,
        "nikolay@nvidia.com" <nikolay@nvidia.com>,
        "roopa@nvidia.com" <roopa@nvidia.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "rasmus.villemoes@prevas.dk" <rasmus.villemoes@prevas.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>
Subject: Re: [PATCH net-next v4 6/8] net: mscc: ocelot: Add support for MRP
Message-ID: <20210217162552.3q4k73udf4x4kpbr@soft-dev3.localdomain>
References: <20210216214205.32385-1-horatiu.vultur@microchip.com>
 <20210216214205.32385-7-horatiu.vultur@microchip.com>
 <20210217111411.plsod67qdzb5ybpm@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20210217111411.plsod67qdzb5ybpm@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 02/17/2021 11:14, Vladimir Oltean wrote:
> 
> On Tue, Feb 16, 2021 at 10:42:03PM +0100, Horatiu Vultur wrote:
> > Add basic support for MRP. The HW will just trap all MRP frames on the
> > ring ports to CPU and allow the SW to process them. In this way it is
> > possible to for this node to behave both as MRM and MRC.
> >
> > Current limitations are:
> > - it doesn't support Interconnect roles.
> > - it supports only a single ring.
> > - the HW should be able to do forwarding of MRP Test frames so the SW
> >   will not need to do this. So it would be able to have the role MRC
> >   without SW support.
> >
> > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> > ---
> >  drivers/net/ethernet/mscc/Makefile     |   1 +
> >  drivers/net/ethernet/mscc/ocelot.c     |  10 +-
> >  drivers/net/ethernet/mscc/ocelot_mrp.c | 175 +++++++++++++++++++++++++
> >  drivers/net/ethernet/mscc/ocelot_net.c |  60 +++++++++
> >  include/linux/dsa/ocelot.h             |   5 +
> >  include/soc/mscc/ocelot.h              |  45 +++++++
> >  6 files changed, 295 insertions(+), 1 deletion(-)
> >  create mode 100644 drivers/net/ethernet/mscc/ocelot_mrp.c
> >
> > diff --git a/drivers/net/ethernet/mscc/Makefile b/drivers/net/ethernet/mscc/Makefile
> > index 346bba2730ad..722c27694b21 100644
> > --- a/drivers/net/ethernet/mscc/Makefile
> > +++ b/drivers/net/ethernet/mscc/Makefile
> > @@ -8,6 +8,7 @@ mscc_ocelot_switch_lib-y := \
> >       ocelot_flower.o \
> >       ocelot_ptp.o \
> >       ocelot_devlink.o
> > +mscc_ocelot_switch_lib-$(CONFIG_BRIDGE_MRP) += ocelot_mrp.o
> >  obj-$(CONFIG_MSCC_OCELOT_SWITCH) += mscc_ocelot.o
> >  mscc_ocelot-y := \
> >       ocelot_vsc7514.o \
> > diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
> > index 5d13087c85d6..46e5c9136bac 100644
> > --- a/drivers/net/ethernet/mscc/ocelot.c
> > +++ b/drivers/net/ethernet/mscc/ocelot.c
> > @@ -687,7 +687,7 @@ static int ocelot_xtr_poll_xfh(struct ocelot *ocelot, int grp, u32 *xfh)
> >  int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp, struct sk_buff **nskb)
> >  {
> >       struct skb_shared_hwtstamps *shhwtstamps;
> > -     u64 tod_in_ns, full_ts_in_ns;
> > +     u64 tod_in_ns, full_ts_in_ns, cpuq;
> >       u64 timestamp, src_port, len;
> >       u32 xfh[OCELOT_TAG_LEN / 4];
> >       struct net_device *dev;
> > @@ -704,6 +704,7 @@ int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp, struct sk_buff **nskb)
> >       ocelot_xfh_get_src_port(xfh, &src_port);
> >       ocelot_xfh_get_len(xfh, &len);
> >       ocelot_xfh_get_rew_val(xfh, &timestamp);
> > +     ocelot_xfh_get_cpuq(xfh, &cpuq);
> >
> >       if (WARN_ON(src_port >= ocelot->num_phys_ports))
> >               return -EINVAL;
> > @@ -770,6 +771,13 @@ int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp, struct sk_buff **nskb)
> >               skb->offload_fwd_mark = 1;
> >
> >       skb->protocol = eth_type_trans(skb, dev);
> > +
> > +#if IS_ENABLED(CONFIG_BRIDGE_MRP)
> > +     if (skb->protocol == cpu_to_be16(ETH_P_MRP) &&
> > +         cpuq & BIT(OCELOT_MRP_CPUQ))
> > +             skb->offload_fwd_mark = 0;
> > +#endif

Hi Vladimir,

> 
> Same comment as in DSA, it sounds simpler to me to just do:
> 
>         if ((ocelot->bridge_mask & BIT(src_port)) &&
>             !(cpuq & BIT(OCELOT_MRP_CPUQ)))
>                 skb->offload_fwd_mark = 1;
> 
> When we add support for more packet traps, this check will be more
> amortized anyway.

Yes that looks simpler. But actually I think we can remove this once we
will do the forwarding of the frames in HW. And of course the same will
apply also for DSA driver.

> 
> > +
> >       *nskb = skb;
> >
> >       return 0;
> > diff --git a/drivers/net/ethernet/mscc/ocelot_mrp.c b/drivers/net/ethernet/mscc/ocelot_mrp.c
> > new file mode 100644
> > index 000000000000..683da320bfd8
> > --- /dev/null
> > +++ b/drivers/net/ethernet/mscc/ocelot_mrp.c
> > @@ -0,0 +1,175 @@
> > +// SPDX-License-Identifier: (GPL-2.0 OR MIT)
> > +/* Microsemi Ocelot Switch driver
> > + *
> > + * This contains glue logic between the switchdev driver operations and the
> > + * mscc_ocelot_switch_lib.
> 
> Wrong, this _is_ part of the mscc_ocelot_switch_lib. Which is also the
> reason why some of the code below will not work.

Yes, this was the result of copy - paste.

> 
> > + *
> > + * Copyright (c) 2017, 2019 Microsemi Corporation
> > + * Copyright 2020-2021 NXP Semiconductors
> > + */
> > +
> > +#include <linux/if_bridge.h>
> > +#include <linux/mrp_bridge.h>
> > +#include <soc/mscc/ocelot_vcap.h>
> > +#include <uapi/linux/mrp_bridge.h>
> > +#include "ocelot.h"
> > +#include "ocelot_vcap.h"
> > +
> > +static int ocelot_mrp_del_vcap(struct ocelot *ocelot, int port)
> > +{
> > +     struct ocelot_vcap_block *block_vcap_is2;
> > +     struct ocelot_vcap_filter *filter;
> > +
> > +     block_vcap_is2 = &ocelot->block[VCAP_IS2];
> > +     filter = ocelot_vcap_block_find_filter_by_id(block_vcap_is2, port,
> > +                                                  false);
> > +     if (!filter)
> > +             return 0;
> > +
> > +     return ocelot_vcap_filter_del(ocelot, filter);
> > +}
> > +
> > +int ocelot_mrp_add(struct ocelot *ocelot, int port,
> > +                const struct switchdev_obj_mrp *mrp)
> > +{
> > +     struct ocelot_port *ocelot_port = ocelot->ports[port];
> > +     struct ocelot_port_private *priv;
> > +     struct net_device *dev;
> > +
> > +     if (!ocelot_port)
> > +             return -EOPNOTSUPP;
> > +
> > +     priv = container_of(ocelot_port, struct ocelot_port_private, port);
> > +     dev = priv->dev;
> 
> No, no, no.
> The struct net_device registered by DSA uses a netdev_priv of
> struct dsa_slave_priv. You can't just go ahead and assume that the
> caller of this function uses struct ocelot_port_private.
> 
> Please go to struct ocelot_port and add:
>         bool is_mrp_primary;
>         bool is_mrp_secondary;
> 
> and replace the checks for a net_device with bools.

My bad. I will create a new patch with your suggestion.

> 
> > +
> > +     if (mrp->p_port != dev && mrp->s_port != dev)
> > +             return 0;
> > +
> > +     if (ocelot->mrp_ring_id != 0 &&
> > +         ocelot->mrp_s_port &&
> > +         ocelot->mrp_p_port)
> > +             return -EINVAL;
> > +
> > +     if (mrp->p_port == dev)
> > +             ocelot->mrp_p_port = dev;
> > +
> > +     if (mrp->s_port == dev)
> > +             ocelot->mrp_s_port = dev;
> > +
> > +     ocelot->mrp_ring_id = mrp->ring_id;
> > +
> > +     return 0;
> > +}
> > +EXPORT_SYMBOL(ocelot_mrp_add);
> > +
> > +int ocelot_mrp_del(struct ocelot *ocelot, int port,
> > +                const struct switchdev_obj_mrp *mrp)
> > +{
> > +     struct ocelot_port *ocelot_port = ocelot->ports[port];
> > +     struct ocelot_port_private *priv;
> > +     struct net_device *dev;
> > +
> > +     if (!ocelot_port)
> > +             return -EOPNOTSUPP;
> > +
> > +     priv = container_of(ocelot_port, struct ocelot_port_private, port);
> > +     dev = priv->dev;
> > +
> > +     if (ocelot->mrp_p_port != dev && ocelot->mrp_s_port != dev)
> > +             return 0;
> > +
> > +     if (ocelot->mrp_ring_id == 0 &&
> > +         !ocelot->mrp_s_port &&
> > +         !ocelot->mrp_p_port)
> > +             return -EINVAL;
> > +
> > +     if (ocelot_mrp_del_vcap(ocelot, priv->chip_port))
> > +             return -EINVAL;
> > +
> > +     if (ocelot->mrp_p_port == dev)
> > +             ocelot->mrp_p_port = NULL;
> > +
> > +     if (ocelot->mrp_s_port == dev)
> > +             ocelot->mrp_s_port = NULL;
> > +
> > +     ocelot->mrp_ring_id = 0;
> > +
> > +     return 0;
> > +}
> > +EXPORT_SYMBOL(ocelot_mrp_del);
> > +
> > +int ocelot_mrp_add_ring_role(struct ocelot *ocelot, int port,
> > +                          const struct switchdev_obj_ring_role_mrp *mrp)
> > +{
> > +     struct ocelot_port *ocelot_port = ocelot->ports[port];
> > +     struct ocelot_vcap_filter *filter;
> > +     struct ocelot_port_private *priv;
> > +     struct net_device *dev;
> > +     int err;
> > +
> > +     if (!ocelot_port)
> > +             return -EOPNOTSUPP;
> > +
> > +     priv = container_of(ocelot_port, struct ocelot_port_private, port);
> > +     dev = priv->dev;
> > +
> > +     if (ocelot->mrp_ring_id != mrp->ring_id)
> > +             return -EINVAL;
> > +
> > +     if (!mrp->sw_backup)
> > +             return -EOPNOTSUPP;
> > +
> > +     if (ocelot->mrp_p_port != dev && ocelot->mrp_s_port != dev)
> > +             return 0;
> > +
> > +     filter = kzalloc(sizeof(*filter), GFP_ATOMIC);
> > +     if (!filter)
> > +             return -ENOMEM;
> > +
> > +     filter->key_type = OCELOT_VCAP_KEY_ETYPE;
> > +     filter->prio = 1;
> > +     filter->id.cookie = priv->chip_port;
> 
> You have "port" already. This is also wrong for the reason I stated above:
> no "priv" in the common library.
> 
> > +     filter->id.tc_offload = false;
> > +     filter->block_id = VCAP_IS2;
> > +     filter->type = OCELOT_VCAP_FILTER_OFFLOAD;
> > +     filter->ingress_port_mask = BIT(priv->chip_port);
> > +     *(__be16 *)filter->key.etype.etype.value = htons(ETH_P_MRP);
> > +     *(__be16 *)filter->key.etype.etype.mask = htons(0xffff);
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
> > +EXPORT_SYMBOL(ocelot_mrp_add_ring_role);
> > +
> > +int ocelot_mrp_del_ring_role(struct ocelot *ocelot, int port,
> > +                          const struct switchdev_obj_ring_role_mrp *mrp)
> > +{
> > +     struct ocelot_port *ocelot_port = ocelot->ports[port];
> > +     struct ocelot_port_private *priv;
> > +     struct net_device *dev;
> > +
> > +     if (!ocelot_port)
> > +             return -EOPNOTSUPP;
> > +
> > +     priv = container_of(ocelot_port, struct ocelot_port_private, port);
> > +     dev = priv->dev;
> > +
> > +     if (ocelot->mrp_ring_id != mrp->ring_id)
> > +             return -EINVAL;
> > +
> > +     if (!mrp->sw_backup)
> > +             return -EOPNOTSUPP;
> > +
> > +     if (ocelot->mrp_p_port != dev && ocelot->mrp_s_port != dev)
> > +             return 0;
> > +
> > +     return ocelot_mrp_del_vcap(ocelot, priv->chip_port);
> > +}
> > +EXPORT_SYMBOL(ocelot_mrp_del_ring_role);
> > diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
> > index 6518262532f0..12cb6867a2d0 100644
> > --- a/drivers/net/ethernet/mscc/ocelot_net.c
> > +++ b/drivers/net/ethernet/mscc/ocelot_net.c
> > @@ -1010,6 +1010,52 @@ static int ocelot_port_obj_del_mdb(struct net_device *dev,
> >       return ocelot_port_mdb_del(ocelot, port, mdb);
> >  }
> >
> > +static int ocelot_port_obj_mrp_add(struct net_device *dev,
> > +                                const struct switchdev_obj_mrp *mrp)
> > +{
> > +     struct ocelot_port_private *priv = netdev_priv(dev);
> > +     struct ocelot_port *ocelot_port = &priv->port;
> > +     struct ocelot *ocelot = ocelot_port->ocelot;
> > +     int port = priv->chip_port;
> > +
> > +     return ocelot_mrp_add(ocelot, port, mrp);
> > +}
> > +
> > +static int ocelot_port_obj_mrp_del(struct net_device *dev,
> > +                                const struct switchdev_obj_mrp *mrp)
> > +{
> > +     struct ocelot_port_private *priv = netdev_priv(dev);
> > +     struct ocelot_port *ocelot_port = &priv->port;
> > +     struct ocelot *ocelot = ocelot_port->ocelot;
> > +     int port = priv->chip_port;
> > +
> > +     return ocelot_mrp_del(ocelot, port, mrp);
> > +}
> > +
> > +static int
> > +ocelot_port_obj_mrp_add_ring_role(struct net_device *dev,
> > +                               const struct switchdev_obj_ring_role_mrp *mrp)
> > +{
> > +     struct ocelot_port_private *priv = netdev_priv(dev);
> > +     struct ocelot_port *ocelot_port = &priv->port;
> > +     struct ocelot *ocelot = ocelot_port->ocelot;
> > +     int port = priv->chip_port;
> > +
> > +     return ocelot_mrp_add_ring_role(ocelot, port, mrp);
> > +}
> > +
> > +static int
> > +ocelot_port_obj_mrp_del_ring_role(struct net_device *dev,
> > +                               const struct switchdev_obj_ring_role_mrp *mrp)
> > +{
> > +     struct ocelot_port_private *priv = netdev_priv(dev);
> > +     struct ocelot_port *ocelot_port = &priv->port;
> > +     struct ocelot *ocelot = ocelot_port->ocelot;
> > +     int port = priv->chip_port;
> > +
> > +     return ocelot_mrp_del_ring_role(ocelot, port, mrp);
> > +}
> > +
> >  static int ocelot_port_obj_add(struct net_device *dev,
> >                              const struct switchdev_obj *obj,
> >                              struct netlink_ext_ack *extack)
> > @@ -1024,6 +1070,13 @@ static int ocelot_port_obj_add(struct net_device *dev,
> >       case SWITCHDEV_OBJ_ID_PORT_MDB:
> >               ret = ocelot_port_obj_add_mdb(dev, SWITCHDEV_OBJ_PORT_MDB(obj));
> >               break;
> > +     case SWITCHDEV_OBJ_ID_MRP:
> > +             ret = ocelot_port_obj_mrp_add(dev, SWITCHDEV_OBJ_MRP(obj));
> > +             break;
> > +     case SWITCHDEV_OBJ_ID_RING_ROLE_MRP:
> > +             ret = ocelot_port_obj_mrp_add_ring_role(dev,
> > +                                                     SWITCHDEV_OBJ_RING_ROLE_MRP(obj));
> > +             break;
> >       default:
> >               return -EOPNOTSUPP;
> >       }
> > @@ -1044,6 +1097,13 @@ static int ocelot_port_obj_del(struct net_device *dev,
> >       case SWITCHDEV_OBJ_ID_PORT_MDB:
> >               ret = ocelot_port_obj_del_mdb(dev, SWITCHDEV_OBJ_PORT_MDB(obj));
> >               break;
> > +     case SWITCHDEV_OBJ_ID_MRP:
> > +             ret = ocelot_port_obj_mrp_del(dev, SWITCHDEV_OBJ_MRP(obj));
> > +             break;
> > +     case SWITCHDEV_OBJ_ID_RING_ROLE_MRP:
> > +             ret = ocelot_port_obj_mrp_del_ring_role(dev,
> > +                                                     SWITCHDEV_OBJ_RING_ROLE_MRP(obj));
> > +             break;
> >       default:
> >               return -EOPNOTSUPP;
> >       }
> > diff --git a/include/linux/dsa/ocelot.h b/include/linux/dsa/ocelot.h
> > index c6bc45ae5e03..4265f328681a 100644
> > --- a/include/linux/dsa/ocelot.h
> > +++ b/include/linux/dsa/ocelot.h
> > @@ -160,6 +160,11 @@ static inline void ocelot_xfh_get_src_port(void *extraction, u64 *src_port)
> >       packing(extraction, src_port, 46, 43, OCELOT_TAG_LEN, UNPACK, 0);
> >  }
> >
> > +static inline void ocelot_xfh_get_cpuq(void *extraction, u64 *cpuq)
> > +{
> > +     packing(extraction, cpuq, 28, 20, OCELOT_TAG_LEN, UNPACK, 0);
> > +}
> > +
> >  static inline void ocelot_xfh_get_qos_class(void *extraction, u64 *qos_class)
> >  {
> >       packing(extraction, qos_class, 19, 17, OCELOT_TAG_LEN, UNPACK, 0);
> > diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
> > index 1f2d90976564..425ff29d9389 100644
> > --- a/include/soc/mscc/ocelot.h
> > +++ b/include/soc/mscc/ocelot.h
> > @@ -112,6 +112,8 @@
> >  #define REG_RESERVED_ADDR            0xffffffff
> >  #define REG_RESERVED(reg)            REG(reg, REG_RESERVED_ADDR)
> >
> > +#define OCELOT_MRP_CPUQ                      7
> > +
> >  enum ocelot_target {
> >       ANA = 1,
> >       QS,
> > @@ -677,6 +679,12 @@ struct ocelot {
> >       /* Protects the PTP clock */
> >       spinlock_t                      ptp_clock_lock;
> >       struct ptp_pin_desc             ptp_pins[OCELOT_PTP_PINS_NUM];
> > +
> > +#if IS_ENABLED(CONFIG_BRIDGE_MRP)
> > +     u16                             mrp_ring_id;
> > +     struct net_device               *mrp_p_port;
> > +     struct net_device               *mrp_s_port;
> > +#endif
> 
> I'd rather have this without the ifdeffery, doesn't seem too expensive
> to justify compiling it out. We have a 4K array of VLANs in struct
> ocelot, for god's sake.

I will update this in the next patch.

-- 
/Horatiu
