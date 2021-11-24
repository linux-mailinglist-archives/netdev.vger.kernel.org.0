Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3818345C818
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 15:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346245AbhKXO7W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 09:59:22 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:25134 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244614AbhKXO7V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 09:59:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1637765771; x=1669301771;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=yfqRuYPZmZUcNRxXA/NezxjfFaXgFEveKTueFKQUZuM=;
  b=LWVUADR9xYyKB1jYYAcyV3NBAbS/GyEWr32lPjUohE6z8g605EYIAUwG
   kXGQSrvO/qK08Z1MFWNC29IKP0WW7WKzWg+3OC9glZt/ZkBMgObwb8piu
   oNJ3z2xt6jgsVUBeM/Y8RdO0GCD7yCZf4VnKO4Ch4g7XDzzCXooWfoGxK
   0KdUh00COUAyE+3JDILMUpwLNo4gqnCGOItUa80mv9T/wfwxBr3qwNdjj
   VCucay0/UAbYF5AHv0qroWin2sqXyG7vAARPVs9Iw+Ri+MFeZFLcn5xaZ
   o10qG9Q3jY7EoP/yh0lZkdmOFGUQjIFOz2Euva1cap20FF7CW5pYMK88w
   Q==;
IronPort-SDR: luM2raqHKSksZ2fzMhDCxBPqUkS/7bK/sP6h9se59cQ2YS/bD36ATW29vCHLj2i/sE1fEaz6Tn
 Us04WweuhnIvAIyE//5KYzLGe1/uRBVeThLjnrM7YzHgYHlvNuklLFxnrOOOwsByHplNPfCGqB
 GPxz86gB9xfMv961RRK19fWyxxoi4aYHVitymQ90yN1E89iZKpN1CkqUIc/rGymEAJbht9HQay
 qqi/yhFRKm/xjFtVC7gKGQWYIh00CsRGfotv8VBVpLr2jZmf1nu+AJAFW3VbGLjEGYRUItX8Ml
 SJi6lCCGBsew2uC2pLXxp7lj
X-IronPort-AV: E=Sophos;i="5.87,260,1631602800"; 
   d="scan'208";a="153095423"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Nov 2021 07:56:09 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 24 Nov 2021 07:56:08 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Wed, 24 Nov 2021 07:56:07 -0700
Date:   Wed, 24 Nov 2021 15:58:00 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <p.zabel@pengutronix.de>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v3 3/6] net: lan966x: add port module support
Message-ID: <20211124145800.my4niep3sifqpg55@soft-dev3-1.localhost>
References: <20211124083915.2223065-1-horatiu.vultur@microchip.com>
 <20211124083915.2223065-4-horatiu.vultur@microchip.com>
 <YZ4SB/wX6UT3zrEV@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <YZ4SB/wX6UT3zrEV@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 11/24/2021 10:20, Russell King (Oracle) wrote:
> 
> Hi,

Hi Russel,

> 
> On Wed, Nov 24, 2021 at 09:39:12AM +0100, Horatiu Vultur wrote:
> > +static int lan966x_port_open(struct net_device *dev)
> > +{
> > +     struct lan966x_port *port = netdev_priv(dev);
> > +     struct lan966x *lan966x = port->lan966x;
> > +     int err;
> > +
> > +     if (port->serdes) {
> > +             err = phy_set_mode_ext(port->serdes, PHY_MODE_ETHERNET,
> > +                                    port->config.phy_mode);
> > +             if (err) {
> > +                     netdev_err(dev, "Could not set mode of SerDes\n");
> > +                     return err;
> > +             }
> > +     }
> 
> This could be done in the mac_prepare() method.

Yes, I will move this in mac_prepare()

> 
> > +static void lan966x_cleanup_ports(struct lan966x *lan966x)
> > +{
> > +     struct lan966x_port *port;
> > +     int portno;
> > +
> > +     for (portno = 0; portno < lan966x->num_phys_ports; portno++) {
> > +             port = lan966x->ports[portno];
> > +             if (!port)
> > +                     continue;
> > +
> > +             if (port->phylink) {
> > +                     rtnl_lock();
> > +                     lan966x_port_stop(port->dev);
> > +                     rtnl_unlock();
> > +                     phylink_destroy(port->phylink);
> > +                     port->phylink = NULL;
> > +             }
> > +
> > +             if (port->fwnode)
> > +                     fwnode_handle_put(port->fwnode);
> > +
> > +             if (port->dev)
> > +                     unregister_netdev(port->dev);
> 
> This doesn't look like the correct sequence to me. Shouldn't the net
> device be unregistered first, which will take the port down by doing
> so and make it unavailable to userspace to further manipulate. Then
> we should start tearing other stuff down such as destroying phylink
> and disabling interrupts (in the caller of this.)

I can change the order as you suggested.
Regarding the interrupts, shouldn't they be first disable and then do
all the teardown?

> 
> Don't you need to free the netdev as well at some point?

It is not needed because they are allocated using devm_alloc_etherdev_mqs

> 
> >  static int lan966x_probe_port(struct lan966x *lan966x, u32 p,
> > -                           phy_interface_t phy_mode)
> > +                           phy_interface_t phy_mode,
> > +                           struct fwnode_handle *portnp)
> >  {
> ...
> > +     port->phylink_config.dev = &port->dev->dev;
> > +     port->phylink_config.type = PHYLINK_NETDEV;
> > +     port->phylink_config.pcs_poll = true;
> > +     port->phylink_pcs.poll = true;
> 
> You don't need to set both of these - please omit
> port->phylink_config.pcs_poll.

I will remove it.

> 
> > diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> > index 7a1ff9d19fbf..ce2798db0449 100644
> > --- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> > +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> ...
> > @@ -44,15 +58,48 @@ struct lan966x {
> >       void __iomem *regs[NUM_TARGETS];
> >
> >       int shared_queue_sz;
> > +
> > +     /* interrupts */
> > +     int xtr_irq;
> > +};
> > +
> > +struct lan966x_port_config {
> > +     phy_interface_t portmode;
> > +     phy_interface_t phy_mode;
> 
> What is the difference between "portmode" and "phy_mode"? Does it matter
> if port->config.phy_mode get zeroed when lan966x_port_pcs_set() is
> called from lan966x_pcs_config()? It looks to me like the first call
> will clear phy_mode, setting it to PHY_INTERFACE_MODE_NA from that point
> on.

The purpose was to use portmode to configure the MAC and the phy_mode
to configure the serdes. There are small issues regarding this which
will be fix in the next series also I will add some comments just to
make it clear.

Actually, port->config.phy_mode will not get zeroed. Because right after
the memset it follows: 'config = port->config'.

> 
> > diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_port.c b/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
> > new file mode 100644
> > index 000000000000..ca1b0c8d1bf5
> > --- /dev/null
> > +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
> > @@ -0,0 +1,422 @@
> ...
> > +void lan966x_port_status_get(struct lan966x_port *port,
> > +                          struct phylink_link_state *state)
> > +{
> > +     struct lan966x *lan966x = port->lan966x;
> > +     u16 lp_adv, ld_adv;
> > +     bool link_down;
> > +     u16 bmsr = 0;
> > +     u32 val;
> > +
> > +     val = lan_rd(lan966x, DEV_PCS1G_STICKY(port->chip_port));
> > +     link_down = DEV_PCS1G_STICKY_LINK_DOWN_STICKY_GET(val);
> > +     if (link_down)
> > +             lan_wr(val, lan966x, DEV_PCS1G_STICKY(port->chip_port));
> > +
> > +     /* Get both current Link and Sync status */
> > +     val = lan_rd(lan966x, DEV_PCS1G_LINK_STATUS(port->chip_port));
> > +     state->link = DEV_PCS1G_LINK_STATUS_LINK_STATUS_GET(val) &&
> > +                   DEV_PCS1G_LINK_STATUS_SYNC_STATUS_GET(val);
> > +     state->link &= !link_down;
> > +
> > +     if (port->config.portmode == PHY_INTERFACE_MODE_1000BASEX)
> > +             state->speed = SPEED_1000;
> > +     else if (port->config.portmode == PHY_INTERFACE_MODE_2500BASEX)
> > +             state->speed = SPEED_2500;
> 
> Why not use state->interface? state->interface will be the currently
> configured interface mode (which should be the same as your
> port->config.portmode.)

I will use state->interface.

> 
> > +
> > +     state->duplex = DUPLEX_FULL;
> 
> Also, what is the purpose of initialising state->speed and state->duplex
> here? phylink_mii_c22_pcs_decode_state() will do that for you when
> decoding the advertisements.
> 
> If it's to deal with autoneg disabled, then it ought to be conditional on
> autoneg being disabled and the link being up.

It was the case for autoneg disabled.

> 
> > +
> > +     /* Get PCS ANEG status register */
> > +     val = lan_rd(lan966x, DEV_PCS1G_ANEG_STATUS(port->chip_port));
> > +
> > +     /* Aneg complete provides more information  */
> > +     if (DEV_PCS1G_ANEG_STATUS_ANEG_COMPLETE_GET(val)) {
> > +             lp_adv = DEV_PCS1G_ANEG_STATUS_LP_ADV_GET(val);
> > +             state->an_complete = true;
> > +
> > +             bmsr |= state->link ? BMSR_LSTATUS : 0;
> > +             bmsr |= state->an_complete;
> 
> Shouldn't this be setting BMSR_ANEGCOMPLETE?

That was a silly mistake from my side.

> 
> > +
> > +             if (port->config.portmode == PHY_INTERFACE_MODE_SGMII) {
> > +                     phylink_mii_c22_pcs_decode_state(state, bmsr, lp_adv);
> > +             } else {
> > +                     val = lan_rd(lan966x, DEV_PCS1G_ANEG_CFG(port->chip_port));
> > +                     ld_adv = DEV_PCS1G_ANEG_CFG_ADV_ABILITY_GET(val);
> > +                     phylink_mii_c22_pcs_decode_state(state, bmsr, ld_adv);
> > +             }
> 
> This looks like it can be improved:
> 
>         if (DEV_PCS1G_ANEG_STATUS_ANEG_COMPLETE_GET(val)) {
>                 state->an_complete = true;
> 
>                 bmsr |= state->link ? BMSR_LSTATUS : 0;
>                 bmsr |= BMSR_ANEGCOMPLETE;
> 
>                 if (state->interface == PHY_INTERFACE_MODE_SGMII) {
>                         lp_adv = DEV_PCS1G_ANEG_STATUS_LP_ADV_GET(val);
>                 } else {
>                         val = lan_rd(lan966x, DEV_PCS1G_ANEG_CFG(port->chip_port));
>                         lp_adv = DEV_PCS1G_ANEG_CFG_ADV_ABILITY_GET(val);
>                 }
> 
>                 phylink_mii_c22_pcs_decode_state(state, bmsr, lp_adv);
>         }
> 
> I'm not sure that the non-SGMII code is actually correct though. Which
> advertisement are you extracting by reading the DEV_PCS1G_ANEG_CFG
> register and extracting DEV_PCS1G_ANEG_CFG_ADV_ABILITY_GET ? From the
> code in lan966x_port_pcs_set(), it suggests this is our advertisement,
> but it's supposed to always be the link partner's advertisement being
> passed to phylink_mii_c22_pcs_decode_state().

Actually, like you mentioned it needs to be link partner's advertisement
so that code can be simplified more:

         if (DEV_PCS1G_ANEG_STATUS_ANEG_COMPLETE_GET(val)) {
                 state->an_complete = true;
 
                 bmsr |= state->link ? BMSR_LSTATUS : 0;
                 bmsr |= BMSR_ANEGCOMPLETE;
 
                 lp_adv = DEV_PCS1G_ANEG_STATUS_LP_ADV_GET(val);
                 phylink_mii_c22_pcs_decode_state(state, bmsr, lp_adv);
         }

Because inside phylink_mii_c22_pcs_decode_state, more precisely in
phylink_decode_c37_work, state->advertising will have the local
advertising.

> 
> > +int lan966x_port_pcs_set(struct lan966x_port *port,
> > +                      struct lan966x_port_config *config)
> > +{
> ...
> > +     port->config = *config;
> 
> As mentioned elsewhere, "config" won't have phy_mode set, so this clears
> port->config.phymode to PHY_INTERFACE_MODE_NA, which I think will cause
> e.g. lan966x_port_link_up() not to behave as intended.

Actually, the "config" will still have the phy_mode because config will
get teh value of port->config and after that some fields are changed.

> 
> Thanks.
> 
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

-- 
/Horatiu
