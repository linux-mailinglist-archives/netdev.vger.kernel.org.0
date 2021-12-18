Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29A5F479AD7
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 13:54:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233166AbhLRMy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 07:54:29 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:46758 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231748AbhLRMy3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 07:54:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1639832068; x=1671368068;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=HcFjhAznEXBAczPEpg4srLDJShwLa/gxRkb7TVeBqEs=;
  b=LiGy/eki/XHhPF/E00nIzeOXxvVdHgyL1QUCddW8Ql9rn3BCjwpQtZIJ
   OX9u3scXJEBJbAc1rKRG78t01ljoB7OLLSk2l0M04fywpJiaUV21+1uHG
   JMHhAyJceesh2cvFYvi1hLq+z2qHbSYE5WHmlAIN15UKbHlXQCcLi0lTz
   V7mbnP3KGla/EkzfTl8lfWK1QkeVKWMvlViZ61aKSZ1IWurcco2eFVsRo
   SmHjrKIS/kBsAeMGco4ef/d0Jrytx/Z6/Pz7vChBFN/xQ/WZAvRhP+1VT
   ngyuxj5gcf8Jnx1zdYFrV2N/vjmCKvjO/zOJ0HqlOBGK6PZdYRY8KJwUM
   g==;
IronPort-SDR: x3Ee39vpGpS4UjPZJN83YZgTEdXIxCJKVwb/l8XrXyDuW9BzHnDrUfCW4EIAVjdjbYV14YYZyS
 ABgY/9+ut+W2i+j3u6oj9zbOHODqjcZeyIQ8bjqk3uzPUw1cY5m5XHRzAy3n5qc3x/c88+K7Y5
 t9GQa+ppBz9YqEQZnEpFf9vpCOW2T/s7piWAAlYHFZZXcayYt8ez4z+XGINOlITbhWtyFmwLfj
 3DpitpCZRiWoaqNEMgphrXYORs7aYTAtpaRsxUwS2Yck0Rs+sFgeyAP42DQwakhRgnWEaXsMEf
 UXx7+bdUNixmzRYsQoA3OJap
X-IronPort-AV: E=Sophos;i="5.88,216,1635231600"; 
   d="scan'208";a="79993902"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Dec 2021 05:54:28 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sat, 18 Dec 2021 05:54:28 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Sat, 18 Dec 2021 05:54:27 -0700
Date:   Sat, 18 Dec 2021 13:56:32 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH net-next v7 6/9] net: lan966x: Add support to offload the
 forwarding.
Message-ID: <20211218125632.uz4vb55l3t5i43kd@soft-dev3-1.localhost>
References: <20211217155353.460594-1-horatiu.vultur@microchip.com>
 <20211217155353.460594-7-horatiu.vultur@microchip.com>
 <20211217174412.w4jwe2uuwx56ipfg@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20211217174412.w4jwe2uuwx56ipfg@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 12/17/2021 17:44, Vladimir Oltean wrote:
> 
> On Fri, Dec 17, 2021 at 04:53:50PM +0100, Horatiu Vultur wrote:
> > This patch adds basic support to offload in the HW the forwarding of the
> > frames. The driver registers to the switchdev callbacks and implements
> > the callbacks for attributes SWITCHDEV_ATTR_ID_PORT_STP_STATE and
> > SWITCHDEV_ATTR_ID_BRIDGE_AGEING_TIME.
> > It is not allowed to add a lan966x port to a bridge that contains a
> > different interface than lan966x.
> >
> > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> > ---
> >  .../net/ethernet/microchip/lan966x/Kconfig    |   1 +
> >  .../net/ethernet/microchip/lan966x/Makefile   |   2 +-
> >  .../ethernet/microchip/lan966x/lan966x_main.c |  32 +-
> >  .../ethernet/microchip/lan966x/lan966x_main.h |   9 +
> >  .../microchip/lan966x/lan966x_switchdev.c     | 309 ++++++++++++++++++
> >  5 files changed, 351 insertions(+), 2 deletions(-)
> >  create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
> >
> > diff --git a/drivers/net/ethernet/microchip/lan966x/Kconfig b/drivers/net/ethernet/microchip/lan966x/Kconfig
> > index 2860a8c9923d..ac273f84b69e 100644
> > --- a/drivers/net/ethernet/microchip/lan966x/Kconfig
> > +++ b/drivers/net/ethernet/microchip/lan966x/Kconfig
> > @@ -2,6 +2,7 @@ config LAN966X_SWITCH
> >       tristate "Lan966x switch driver"
> >       depends on HAS_IOMEM
> >       depends on OF
> > +     depends on NET_SWITCHDEV
> >       select PHYLINK
> >       select PACKING
> >       help
> > diff --git a/drivers/net/ethernet/microchip/lan966x/Makefile b/drivers/net/ethernet/microchip/lan966x/Makefile
> > index 2989ba528236..974229c51f55 100644
> > --- a/drivers/net/ethernet/microchip/lan966x/Makefile
> > +++ b/drivers/net/ethernet/microchip/lan966x/Makefile
> > @@ -6,4 +6,4 @@
> >  obj-$(CONFIG_LAN966X_SWITCH) += lan966x-switch.o
> >
> >  lan966x-switch-objs  := lan966x_main.o lan966x_phylink.o lan966x_port.o \
> > -                     lan966x_mac.o lan966x_ethtool.o
> > +                     lan966x_mac.o lan966x_ethtool.o lan966x_switchdev.o
> > diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
> > index dc40ac2eb246..5af60234d81d 100644
> > --- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
> > +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
> > @@ -355,6 +355,11 @@ static const struct net_device_ops lan966x_port_netdev_ops = {
> >       .ndo_get_port_parent_id         = lan966x_port_get_parent_id,
> >  };
> >
> > +bool lan966x_netdevice_check(const struct net_device *dev)
> > +{
> > +     return dev->netdev_ops == &lan966x_port_netdev_ops;
> > +}
> > +
> >  static int lan966x_port_xtr_status(struct lan966x *lan966x, u8 grp)
> >  {
> >       return lan_rd(lan966x, QS_XTR_RD(grp));
> > @@ -491,6 +496,9 @@ static irqreturn_t lan966x_xtr_irq_handler(int irq, void *args)
> >
> >               skb->protocol = eth_type_trans(skb, dev);
> >
> > +             if (lan966x->bridge_mask & BIT(src_port))
> > +                     skb->offload_fwd_mark = 1;
> > +
> >               netif_rx_ni(skb);
> >               dev->stats.rx_bytes += len;
> >               dev->stats.rx_packets++;
> > @@ -915,6 +923,7 @@ static int lan966x_remove(struct platform_device *pdev)
> >  {
> >       struct lan966x *lan966x = platform_get_drvdata(pdev);
> >
> > +     lan966x_unregister_notifier_blocks();
> 
> You forgot to delete this from lan966x_remove.

Good catch, I will remove this.

> 
> >       lan966x_cleanup_ports(lan966x);
> >
> >       cancel_delayed_work_sync(&lan966x->stats_work);
> > @@ -934,7 +943,28 @@ static struct platform_driver lan966x_driver = {
> >               .of_match_table = lan966x_match,
> >       },
> >  };
> > -module_platform_driver(lan966x_driver);
> > +
> > +static int __init lan966x_switch_driver_init(void)
> > +{
> > +     int ret;
> > +
> > +     ret = platform_driver_register(&lan966x_driver);
> > +     if (ret)
> > +             return ret;
> > +
> > +     lan966x_register_notifier_blocks();
> 
> I think you might miss some events if you register the notifier blocks
> after you've registered your net devices, so could you move this to be
> first (and reverse the order for the driver exit, too)?

Yes, I will do that.

> 
> > +
> > +     return 0;
> > +}
> > +
> > +static void __exit lan966x_switch_driver_exit(void)
> > +{
> > +     lan966x_unregister_notifier_blocks();
> > +     platform_driver_unregister(&lan966x_driver);
> > +}
> > +
> > +module_init(lan966x_switch_driver_init);
> > +module_exit(lan966x_switch_driver_exit);
> >
> >  MODULE_DESCRIPTION("Microchip LAN966X switch driver");
> >  MODULE_AUTHOR("Horatiu Vultur <horatiu.vultur@microchip.com>");
> > diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> > index fcd5d09a070c..4723a904c13e 100644
> > --- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> > +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> > @@ -75,6 +75,10 @@ struct lan966x {
> >
> >       u8 base_mac[ETH_ALEN];
> >
> > +     struct net_device *bridge;
> > +     u16 bridge_mask;
> > +     u16 bridge_fwd_mask;
> > +
> >       struct list_head mac_entries;
> >       spinlock_t mac_lock; /* lock for mac_entries list */
> >
> > @@ -122,6 +126,11 @@ extern const struct phylink_mac_ops lan966x_phylink_mac_ops;
> >  extern const struct phylink_pcs_ops lan966x_phylink_pcs_ops;
> >  extern const struct ethtool_ops lan966x_ethtool_ops;
> >
> > +bool lan966x_netdevice_check(const struct net_device *dev);
> > +
> > +void lan966x_register_notifier_blocks(void);
> > +void lan966x_unregister_notifier_blocks(void);
> > +
> >  void lan966x_stats_get(struct net_device *dev,
> >                      struct rtnl_link_stats64 *stats);
> >  int lan966x_stats_init(struct lan966x *lan966x);
> > diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
> > new file mode 100644
> > index 000000000000..9db17b677357
> > --- /dev/null
> > +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
> > @@ -0,0 +1,309 @@
> > +// SPDX-License-Identifier: GPL-2.0+
> > +
> > +#include <linux/if_bridge.h>
> > +#include <net/switchdev.h>
> > +
> > +#include "lan966x_main.h"
> > +
> > +static struct notifier_block lan966x_netdevice_nb __read_mostly;
> > +static struct notifier_block lan966x_switchdev_nb __read_mostly;
> > +static struct notifier_block lan966x_switchdev_blocking_nb __read_mostly;
> > +
> > +static void lan966x_update_fwd_mask(struct lan966x *lan966x)
> > +{
> > +     int i;
> > +
> > +     for (i = 0; i < lan966x->num_phys_ports; i++) {
> > +             struct lan966x_port *port = lan966x->ports[i];
> > +             unsigned long mask = 0;
> > +
> > +             if (port && lan966x->bridge_fwd_mask & BIT(i))
> > +                     mask = lan966x->bridge_fwd_mask & ~BIT(i);
> > +
> > +             mask |= BIT(CPU_PORT);
> > +
> > +             lan_wr(ANA_PGID_PGID_SET(mask),
> > +                    lan966x, ANA_PGID(PGID_SRC + i));
> > +     }
> > +}
> > +
> > +static void lan966x_port_stp_state_set(struct lan966x_port *port, u8 state)
> > +{
> > +     struct lan966x *lan966x = port->lan966x;
> > +     bool learn_ena = false;
> > +
> > +     if (state == BR_STATE_FORWARDING || state == BR_STATE_LEARNING)
> > +             learn_ena = true;
> > +
> > +     if (state == BR_STATE_FORWARDING)
> > +             lan966x->bridge_fwd_mask |= BIT(port->chip_port);
> > +     else
> > +             lan966x->bridge_fwd_mask &= ~BIT(port->chip_port);
> > +
> > +     lan_rmw(ANA_PORT_CFG_LEARN_ENA_SET(learn_ena),
> > +             ANA_PORT_CFG_LEARN_ENA,
> > +             lan966x, ANA_PORT_CFG(port->chip_port));
> > +
> > +     lan966x_update_fwd_mask(lan966x);
> > +}
> > +
> > +static void lan966x_port_ageing_set(struct lan966x_port *port,
> > +                                 unsigned long ageing_clock_t)
> > +{
> > +     unsigned long ageing_jiffies = clock_t_to_jiffies(ageing_clock_t);
> > +     u32 ageing_time = jiffies_to_msecs(ageing_jiffies) / 1000;
> > +
> > +     lan966x_mac_set_ageing(port->lan966x, ageing_time);
> > +}
> > +
> > +static int lan966x_port_attr_set(struct net_device *dev, const void *ctx,
> > +                              const struct switchdev_attr *attr,
> > +                              struct netlink_ext_ack *extack)
> > +{
> > +     struct lan966x_port *port = netdev_priv(dev);
> > +     int err = 0;
> > +
> > +     if (ctx && ctx != port)
> > +             return 0;
> > +
> > +     switch (attr->id) {
> > +     case SWITCHDEV_ATTR_ID_PORT_STP_STATE:
> > +             lan966x_port_stp_state_set(port, attr->u.stp_state);
> > +             break;
> > +     case SWITCHDEV_ATTR_ID_BRIDGE_AGEING_TIME:
> > +             lan966x_port_ageing_set(port, attr->u.ageing_time);
> > +             break;
> > +     default:
> > +             err = -EOPNOTSUPP;
> > +             break;
> > +     }
> > +
> > +     return err;
> > +}
> > +
> > +static int lan966x_port_bridge_join(struct lan966x_port *port,
> > +                                 struct net_device *bridge,
> > +                                 struct netlink_ext_ack *extack)
> > +{
> > +     struct lan966x *lan966x = port->lan966x;
> > +     struct net_device *dev = port->dev;
> > +     int err;
> > +
> > +     if (!lan966x->bridge_mask) {
> > +             lan966x->bridge = bridge;
> > +     } else {
> > +             if (lan966x->bridge != bridge) {
> > +                     NL_SET_ERR_MSG_MOD(extack, "Not allow to add port to different bridge");
> > +                     return -ENODEV;
> > +             }
> > +     }
> > +
> > +     err = switchdev_bridge_port_offload(dev, dev, port,
> > +                                         &lan966x_switchdev_nb,
> > +                                         &lan966x_switchdev_blocking_nb,
> > +                                         false, extack);
> > +     if (err)
> > +             return err;
> > +
> > +     lan966x->bridge_mask |= BIT(port->chip_port);
> > +
> > +     return 0;
> > +}
> > +
> > +static void lan966x_port_bridge_leave(struct lan966x_port *port,
> > +                                   struct net_device *bridge)
> > +{
> > +     struct lan966x *lan966x = port->lan966x;
> > +
> > +     lan966x->bridge_mask &= ~BIT(port->chip_port);
> > +
> > +     if (!lan966x->bridge_mask)
> > +             lan966x->bridge = NULL;
> > +
> > +     lan966x_mac_cpu_learn(lan966x, port->dev->dev_addr, PORT_PVID);
> > +}
> > +
> > +static int lan966x_port_changeupper(struct net_device *dev,
> > +                                 struct netdev_notifier_changeupper_info *info)
> > +{
> > +     struct lan966x_port *port = netdev_priv(dev);
> > +     struct netlink_ext_ack *extack;
> > +     int err = 0;
> > +
> > +     extack = netdev_notifier_info_to_extack(&info->info);
> > +
> > +     if (netif_is_bridge_master(info->upper_dev)) {
> > +             if (info->linking)
> > +                     err = lan966x_port_bridge_join(port, info->upper_dev,
> > +                                                    extack);
> > +             else
> > +                     lan966x_port_bridge_leave(port, info->upper_dev);
> > +     }
> > +
> > +     return err;
> > +}
> > +
> > +static int lan966x_port_prechangeupper(struct net_device *dev,
> > +                                    struct netdev_notifier_changeupper_info *info)
> > +{
> > +     struct lan966x_port *port = netdev_priv(dev);
> > +
> > +     if (netif_is_bridge_master(info->upper_dev) && !info->linking)
> > +             switchdev_bridge_port_unoffload(port->dev, port,
> > +                                             &lan966x_switchdev_nb,
> > +                                             &lan966x_switchdev_blocking_nb);
> > +
> > +     return NOTIFY_DONE;
> > +}
> > +
> > +static int lan966x_foreign_bridging_check(struct net_device *bridge,
> > +                                       struct netlink_ext_ack *extack)
> > +{
> > +     struct lan966x *lan966x = NULL;
> > +     bool has_foreign = false;
> > +     struct net_device *dev;
> > +     struct list_head *iter;
> > +
> > +     if (!netif_is_bridge_master(bridge))
> > +             return 0;
> > +
> > +     netdev_for_each_lower_dev(bridge, dev, iter) {
> > +             if (lan966x_netdevice_check(dev)) {
> > +                     struct lan966x_port *port = netdev_priv(dev);
> > +
> > +                     if (lan966x) {
> > +                             /* Bridge already has at least one port of a
> > +                              * lan966x switch inside it, check that it's
> > +                              * the same instance of the driver.
> > +                              */
> > +                             if (port->lan966x != lan966x) {
> > +                                     NL_SET_ERR_MSG_MOD(extack,
> > +                                                        "Bridging between multiple lan966x switches disallowed");
> > +                                     return -EINVAL;
> > +                             }
> > +                     } else {
> > +                             /* This is the first lan966x port inside this
> > +                              * bridge
> > +                              */
> > +                             lan966x = port->lan966x;
> > +                     }
> > +             } else {
> > +                     has_foreign = true;
> > +             }
> > +
> > +             if (lan966x && has_foreign) {
> > +                     NL_SET_ERR_MSG_MOD(extack,
> > +                                        "Bridging lan966x ports with foreign interfaces disallowed");
> > +                     return -EINVAL;
> > +             }
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> > +static int lan966x_bridge_check(struct net_device *dev,
> > +                             struct netdev_notifier_changeupper_info *info)
> > +{
> > +     return lan966x_foreign_bridging_check(info->upper_dev,
> > +                                           info->info.extack);
> > +}
> > +
> > +static int lan966x_netdevice_port_event(struct net_device *dev,
> > +                                     struct notifier_block *nb,
> > +                                     unsigned long event, void *ptr)
> > +{
> > +     int err = 0;
> > +
> > +     if (!lan966x_netdevice_check(dev)) {
> > +             if (event == NETDEV_CHANGEUPPER)
> > +                     return lan966x_bridge_check(dev, ptr);
> > +             return 0;
> > +     }
> > +
> > +     switch (event) {
> > +     case NETDEV_PRECHANGEUPPER:
> > +             err = lan966x_port_prechangeupper(dev, ptr);
> > +             break;
> > +     case NETDEV_CHANGEUPPER:
> > +             err = lan966x_bridge_check(dev, ptr);
> > +             if (err)
> > +                     return err;
> > +
> > +             err = lan966x_port_changeupper(dev, ptr);
> > +             break;
> > +     }
> > +
> > +     return err;
> > +}
> > +
> > +static int lan966x_netdevice_event(struct notifier_block *nb,
> > +                                unsigned long event, void *ptr)
> > +{
> > +     struct net_device *dev = netdev_notifier_info_to_dev(ptr);
> > +     int ret;
> > +
> > +     ret = lan966x_netdevice_port_event(dev, nb, event, ptr);
> > +
> > +     return notifier_from_errno(ret);
> > +}
> > +
> > +static int lan966x_switchdev_event(struct notifier_block *nb,
> > +                                unsigned long event, void *ptr)
> > +{
> > +     struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
> > +     int err;
> > +
> > +     switch (event) {
> > +     case SWITCHDEV_PORT_ATTR_SET:
> > +             err = switchdev_handle_port_attr_set(dev, ptr,
> > +                                                  lan966x_netdevice_check,
> > +                                                  lan966x_port_attr_set);
> > +             return notifier_from_errno(err);
> > +     }
> > +
> > +     return NOTIFY_DONE;
> > +}
> > +
> > +static int lan966x_switchdev_blocking_event(struct notifier_block *nb,
> > +                                         unsigned long event,
> > +                                         void *ptr)
> > +{
> > +     struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
> > +     int err;
> > +
> > +     switch (event) {
> > +     case SWITCHDEV_PORT_ATTR_SET:
> > +             err = switchdev_handle_port_attr_set(dev, ptr,
> > +                                                  lan966x_netdevice_check,
> > +                                                  lan966x_port_attr_set);
> > +             return notifier_from_errno(err);
> > +     }
> > +
> > +     return NOTIFY_DONE;
> > +}
> > +
> > +static struct notifier_block lan966x_netdevice_nb __read_mostly = {
> > +     .notifier_call = lan966x_netdevice_event,
> > +};
> > +
> > +static struct notifier_block lan966x_switchdev_nb __read_mostly = {
> > +     .notifier_call = lan966x_switchdev_event,
> > +};
> > +
> > +static struct notifier_block lan966x_switchdev_blocking_nb __read_mostly = {
> > +     .notifier_call = lan966x_switchdev_blocking_event,
> > +};
> > +
> > +void lan966x_register_notifier_blocks(void)
> > +{
> > +     register_netdevice_notifier(&lan966x_netdevice_nb);
> > +     register_switchdev_notifier(&lan966x_switchdev_nb);
> > +     register_switchdev_blocking_notifier(&lan966x_switchdev_blocking_nb);
> > +}
> > +
> > +void lan966x_unregister_notifier_blocks(void)
> > +{
> > +     unregister_switchdev_blocking_notifier(&lan966x_switchdev_blocking_nb);
> > +     unregister_switchdev_notifier(&lan966x_switchdev_nb);
> > +     unregister_netdevice_notifier(&lan966x_netdevice_nb);
> > +}
> > --
> > 2.33.0
> >

-- 
/Horatiu
