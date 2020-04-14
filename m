Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49DB91A8E3E
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 00:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2634168AbgDNWJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 18:09:04 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:62077 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2634148AbgDNWI7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 18:08:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1586902138; x=1618438138;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=fZB95YONdpVrDdQcOMBzWeU4LIePphdR6yyMD4Me79s=;
  b=jqU+2UnPnbRfT6HKohL6gKbJAY81jc3Vq2AY8aVxHv5fhRZY9bUS206s
   s7a6dEIfoT9AD6z9Z5bbLBlZ4PdwE6uWwBQH2ymaFur3uGr6fqgapyEoD
   w/9Gfwhdl9ydfM2I5sdf5e3MI5DO9bT16VkRRZxryo1ZxhmGddPZ0sN/U
   ygtUX1xsnlcsiJsFR/K+KgjKTLB2yVKI0PPcrAVTp4tS+VGLiNFOO1nCP
   g+0k/IYG09fx2Ud+078CYjUKb3z/58n/h+ok07a027yYMJ9fQ1ti7v7cf
   SFYjxTONj09ncEPCRB7vfcpiI1nHSJdZ7wbEev6fKCE5sig3hoTECT1Ds
   A==;
IronPort-SDR: Re+tLpu1Ws5DpDQS6sklXHcrcTIDns4dMp2x2vGY8caTw+G5+i2fBfUe5165gW7QXnGEnDHLY9
 KxXRD3jAxT92ZxL9fFdm2xiCwTtieQyGowmu/ziDVt0kWdR4tnUEMVVorNu/Zc4s2gjXhBkH8U
 CV9smbBH834rc1PdAf1CoE7uHLe4sLSB+0GKlTD2COIoQQ87FXsUuz+BzydyMcENlReBnfzTww
 Y79e6cW3Rzh8ZuzsNt3nKp/rW8sNbgwbqY1FBPJF/1s3143TXx470IFFLNlwE1BACzxzQdphQj
 QuQ=
X-IronPort-AV: E=Sophos;i="5.72,384,1580799600"; 
   d="scan'208";a="72198052"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Apr 2020 15:08:56 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 14 Apr 2020 15:08:56 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Tue, 14 Apr 2020 15:08:41 -0700
Date:   Wed, 15 Apr 2020 00:08:55 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     <davem@davemloft.net>, <alexandre.belloni@bootlin.com>,
        <antoine.tenart@bootlin.com>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <vivien.didelot@gmail.com>,
        <joergen.andreasen@microchip.com>, <allan.nielsen@microchip.com>,
        <claudiu.manoil@nxp.com>, <netdev@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <alexandru.marginean@nxp.com>,
        <xiaoliang.yang_1@nxp.com>, <yangbo.lu@nxp.com>, <po.liu@nxp.com>,
        <jiri@mellanox.com>, <idosch@idosch.org>, <kuba@kernel.org>
Subject: Re: [PATCH net] net: mscc: ocelot: fix untagged packet drops when
 enslaving to vlan aware bridge
Message-ID: <20200414220855.xudjjpfn5ejyoj5r@soft-dev3.microsemi.net>
References: <20200414193615.29506-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20200414193615.29506-1-olteanv@gmail.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 04/14/2020 22:36, Vladimir Oltean wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> To rehash a previous explanation given in commit 1c44ce560b4d ("net:
> mscc: ocelot: fix vlan_filtering when enslaving to bridge before link is
> up"), the switch driver operates the in a mode where a single VLAN can
> be transmitted as untagged on a particular egress port. That is the
> "native VLAN on trunk port" use case.
> 
> The configuration for this native VLAN is driven in 2 ways:
>  - Set the egress port rewriter to strip the VLAN tag for the native
>    VID (as it is egress-untagged, after all).
>  - Configure the ingress port to drop untagged and priority-tagged
>    traffic, if there is no native VLAN. The intention of this setting is
>    that a trunk port with no native VLAN should not accept untagged
>    traffic.
> 
> Since both of the above configurations for the native VLAN should only
> be done if VLAN awareness is requested, they are actually done from the
> ocelot_port_vlan_filtering function, after the basic procedure of
> toggling the VLAN awareness flag of the port.
> 
> But there's a problem with that simplistic approach: we are trying to
> juggle with 2 independent variables from a single function:
>  - Native VLAN of the port - its value is held in port->vid.
>  - VLAN awareness state of the port - currently there are some issues
>    here, more on that later*.
> The actual problem can be seen when enslaving the switch ports to a VLAN
> filtering bridge:
>  0. The driver configures a pvid of zero for each port, when in
>     standalone mode. While the bridge configures a default_pvid of 1 for
>     each port that gets added as a slave to it.
>  1. The bridge calls ocelot_port_vlan_filtering with vlan_aware=true.
>     The VLAN-filtering-dependent portion of the native VLAN
>     configuration is done, considering that the native VLAN is 0.
>  2. The bridge calls ocelot_vlan_add with vid=1, pvid=true,
>     untagged=true. The native VLAN changes to 1 (change which gets
>     propagated to hardware).
>  3. ??? - nobody calls ocelot_port_vlan_filtering again, to reapply the
>     VLAN-filtering-dependent portion of the native VLAN configuration,
>     for the new native VLAN of 1. One can notice that after toggling "ip
>     link set dev br0 type bridge vlan_filtering 0 && ip link set dev br0
>     type bridge vlan_filtering 1", the new native VLAN finally makes it
>     through and untagged traffic finally starts flowing again. But
>     obviously that shouldn't be needed.
> 
> So it is clear that 2 independent variables need to both re-trigger the
> native VLAN configuration. So we introduce the second variable as
> ocelot_port->vlan_aware.
> 
> *Actually both the DSA Felix driver and the Ocelot driver already had
> each its own variable:
>  - Ocelot: ocelot_port_private->vlan_aware
>  - Felix: dsa_port->vlan_filtering
> but the common Ocelot library needs to work with a single, common,
> variable, so there is some refactoring done to move the vlan_aware
> property from the private structure into the common ocelot_port
> structure.
> 
> Fixes: 97bb69e1e36e ("net: mscc: ocelot: break apart ocelot_vlan_port_apply")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> To get full VLAN functionality for the Felix DSA driver, we do also need
> someting along the lines of Russell King's patch:
> https://patchwork.ozlabs.org/project/netdev/patch/E1jEB0y-0006iF-5g@rmk-PC.armlinux.org.uk/
> however that is not material for -net.
> 
>  drivers/net/dsa/ocelot/felix.c     |  5 +-
>  drivers/net/ethernet/mscc/ocelot.c | 84 +++++++++++++++---------------
>  drivers/net/ethernet/mscc/ocelot.h |  2 -
>  include/soc/mscc/ocelot.h          |  4 +-
>  4 files changed, 47 insertions(+), 48 deletions(-)
> 
> diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
> index 55bf780b7b0e..53f335d83b37 100644
> --- a/drivers/net/dsa/ocelot/felix.c
> +++ b/drivers/net/dsa/ocelot/felix.c
> @@ -77,11 +77,8 @@ static int felix_fdb_add(struct dsa_switch *ds, int port,
>                          const unsigned char *addr, u16 vid)
>  {
>         struct ocelot *ocelot = ds->priv;
> -       bool vlan_aware;
> 
> -       vlan_aware = dsa_port_is_vlan_filtering(dsa_to_port(ds, port));
> -
> -       return ocelot_fdb_add(ocelot, port, addr, vid, vlan_aware);
> +       return ocelot_fdb_add(ocelot, port, addr, vid);
>  }
> 
>  static int felix_fdb_del(struct dsa_switch *ds, int port,
> diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
> index f9e9d205b551..a6de5f1bd9b1 100644
> --- a/drivers/net/ethernet/mscc/ocelot.c
> +++ b/drivers/net/ethernet/mscc/ocelot.c
> @@ -183,44 +183,47 @@ static void ocelot_vlan_mode(struct ocelot *ocelot, int port,
>         ocelot_write(ocelot, val, ANA_VLANMASK);
>  }
> 
> -void ocelot_port_vlan_filtering(struct ocelot *ocelot, int port,
> -                               bool vlan_aware)
> +static int ocelot_port_set_native_vlan(struct ocelot *ocelot, int port,
> +                                      u16 vid)
>  {
>         struct ocelot_port *ocelot_port = ocelot->ports[port];
> -       u32 val;
> +       u32 val = 0;
> 
> -       if (vlan_aware)
> -               val = ANA_PORT_VLAN_CFG_VLAN_AWARE_ENA |
> -                     ANA_PORT_VLAN_CFG_VLAN_POP_CNT(1);
> -       else
> -               val = 0;
> -       ocelot_rmw_gix(ocelot, val,
> -                      ANA_PORT_VLAN_CFG_VLAN_AWARE_ENA |
> -                      ANA_PORT_VLAN_CFG_VLAN_POP_CNT_M,
> -                      ANA_PORT_VLAN_CFG, port);
> +       if (ocelot_port->vid != vid) {
> +               /* Always permit deleting the native VLAN (vid = 0) */
> +               if (ocelot_port->vid && vid) {
> +                       dev_err(ocelot->dev,
> +                               "Port already has a native VLAN: %d\n",
> +                               ocelot_port->vid);
> +                       return -EBUSY;
> +               }
> +               ocelot_port->vid = vid;
> +       }
> +
> +       ocelot_rmw_gix(ocelot, REW_PORT_VLAN_CFG_PORT_VID(vid),
> +                      REW_PORT_VLAN_CFG_PORT_VID_M,
> +                      REW_PORT_VLAN_CFG, port);
> 
> -       if (vlan_aware && !ocelot_port->vid)
> +       if (ocelot_port->vlan_aware && !ocelot_port->vid)
>                 /* If port is vlan-aware and tagged, drop untagged and priority
>                  * tagged frames.
>                  */
>                 val = ANA_PORT_DROP_CFG_DROP_UNTAGGED_ENA |
>                       ANA_PORT_DROP_CFG_DROP_PRIO_S_TAGGED_ENA |
>                       ANA_PORT_DROP_CFG_DROP_PRIO_C_TAGGED_ENA;
> -       else
> -               val = 0;
>         ocelot_rmw_gix(ocelot, val,
>                        ANA_PORT_DROP_CFG_DROP_UNTAGGED_ENA |
>                        ANA_PORT_DROP_CFG_DROP_PRIO_S_TAGGED_ENA |
>                        ANA_PORT_DROP_CFG_DROP_PRIO_C_TAGGED_ENA,
>                        ANA_PORT_DROP_CFG, port);
> 
> -       if (vlan_aware) {
> +       if (ocelot_port->vlan_aware) {
>                 if (ocelot_port->vid)
>                         /* Tag all frames except when VID == DEFAULT_VLAN */
> -                       val |= REW_TAG_CFG_TAG_CFG(1);
> +                       val = REW_TAG_CFG_TAG_CFG(1);
>                 else
>                         /* Tag all frames */
> -                       val |= REW_TAG_CFG_TAG_CFG(3);
> +                       val = REW_TAG_CFG_TAG_CFG(3);
>         } else {
>                 /* Port tagging disabled. */
>                 val = REW_TAG_CFG_TAG_CFG(0);
> @@ -228,31 +231,31 @@ void ocelot_port_vlan_filtering(struct ocelot *ocelot, int port,
>         ocelot_rmw_gix(ocelot, val,
>                        REW_TAG_CFG_TAG_CFG_M,
>                        REW_TAG_CFG, port);
> +
> +       return 0;
>  }
> -EXPORT_SYMBOL(ocelot_port_vlan_filtering);
> 
> -static int ocelot_port_set_native_vlan(struct ocelot *ocelot, int port,
> -                                      u16 vid)
> +void ocelot_port_vlan_filtering(struct ocelot *ocelot, int port,
> +                               bool vlan_aware)
>  {
>         struct ocelot_port *ocelot_port = ocelot->ports[port];
> +       u32 val;
> 
> -       if (ocelot_port->vid != vid) {
> -               /* Always permit deleting the native VLAN (vid = 0) */
> -               if (ocelot_port->vid && vid) {
> -                       dev_err(ocelot->dev,
> -                               "Port already has a native VLAN: %d\n",
> -                               ocelot_port->vid);
> -                       return -EBUSY;
> -               }
> -               ocelot_port->vid = vid;
> -       }
> +       ocelot_port->vlan_aware = vlan_aware;
> 
> -       ocelot_rmw_gix(ocelot, REW_PORT_VLAN_CFG_PORT_VID(vid),
> -                      REW_PORT_VLAN_CFG_PORT_VID_M,
> -                      REW_PORT_VLAN_CFG, port);
> +       if (vlan_aware)
> +               val = ANA_PORT_VLAN_CFG_VLAN_AWARE_ENA |
> +                     ANA_PORT_VLAN_CFG_VLAN_POP_CNT(1);
> +       else
> +               val = 0;
> +       ocelot_rmw_gix(ocelot, val,
> +                      ANA_PORT_VLAN_CFG_VLAN_AWARE_ENA |
> +                      ANA_PORT_VLAN_CFG_VLAN_POP_CNT_M,
> +                      ANA_PORT_VLAN_CFG, port);
> 
> -       return 0;
> +       ocelot_port_set_native_vlan(ocelot, port, ocelot_port->vid);
>  }
> +EXPORT_SYMBOL(ocelot_port_vlan_filtering);
> 
>  /* Default vlan to clasify for untagged frames (may be zero) */
>  static void ocelot_port_set_pvid(struct ocelot *ocelot, int port, u16 pvid)
> @@ -873,12 +876,12 @@ static void ocelot_get_stats64(struct net_device *dev,
>  }
> 
>  int ocelot_fdb_add(struct ocelot *ocelot, int port,
> -                  const unsigned char *addr, u16 vid, bool vlan_aware)
> +                  const unsigned char *addr, u16 vid)
>  {
>         struct ocelot_port *ocelot_port = ocelot->ports[port];
> 
>         if (!vid) {
> -               if (!vlan_aware)
> +               if (!ocelot_port->vlan_aware)
>                         /* If the bridge is not VLAN aware and no VID was
>                          * provided, set it to pvid to ensure the MAC entry
>                          * matches incoming untagged packets
> @@ -905,7 +908,7 @@ static int ocelot_port_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
>         struct ocelot *ocelot = priv->port.ocelot;
>         int port = priv->chip_port;
> 
> -       return ocelot_fdb_add(ocelot, port, addr, vid, priv->vlan_aware);
> +       return ocelot_fdb_add(ocelot, port, addr, vid);
>  }
> 
>  int ocelot_fdb_del(struct ocelot *ocelot, int port,
> @@ -1496,8 +1499,8 @@ static int ocelot_port_attr_set(struct net_device *dev,
>                 ocelot_port_attr_ageing_set(ocelot, port, attr->u.ageing_time);
>                 break;
>         case SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING:
> -               priv->vlan_aware = attr->u.vlan_filtering;
> -               ocelot_port_vlan_filtering(ocelot, port, priv->vlan_aware);
> +               ocelot_port_vlan_filtering(ocelot, port,
> +                                          attr->u.vlan_filtering);
>                 break;
>         case SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED:
>                 ocelot_port_attr_mc_set(ocelot, port, !attr->u.mc_disabled);
> @@ -1876,7 +1879,6 @@ static int ocelot_netdevice_port_event(struct net_device *dev,
>                         } else {
>                                 err = ocelot_port_bridge_leave(ocelot, port,
>                                                                info->upper_dev);
> -                               priv->vlan_aware = false;
>                         }
>                 }
>                 if (netif_is_lag_master(info->upper_dev)) {
> diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
> index e63bc8743187..7a9c748adda0 100644
> --- a/drivers/net/ethernet/mscc/ocelot.h
> +++ b/drivers/net/ethernet/mscc/ocelot.h
> @@ -57,8 +57,6 @@ struct ocelot_port_private {
>         struct phy_device *phy;
>         u8 chip_port;
> 
> -       u8 vlan_aware;
> -
>         struct phy *serdes;
> 
>         struct ocelot_port_tc tc;
> diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
> index 6f122bd6c3c7..25014c1c91b1 100644
> --- a/include/soc/mscc/ocelot.h
> +++ b/include/soc/mscc/ocelot.h
> @@ -482,6 +482,8 @@ struct ocelot_port {
> 
>         void __iomem                    *regs;
> 
> +       bool                            vlan_aware;
> +
>         /* Ingress default VLAN (pvid) */
>         u16                             pvid;
> 
> @@ -616,7 +618,7 @@ int ocelot_port_bridge_leave(struct ocelot *ocelot, int port,
>  int ocelot_fdb_dump(struct ocelot *ocelot, int port,
>                     dsa_fdb_dump_cb_t *cb, void *data);
>  int ocelot_fdb_add(struct ocelot *ocelot, int port,
> -                  const unsigned char *addr, u16 vid, bool vlan_aware);
> +                  const unsigned char *addr, u16 vid);
>  int ocelot_fdb_del(struct ocelot *ocelot, int port,
>                    const unsigned char *addr, u16 vid);
>  int ocelot_vlan_add(struct ocelot *ocelot, int port, u16 vid, bool pvid,
> --
> 2.17.1
> 

Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>

-- 
/Horatiu
