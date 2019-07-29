Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 564BD79CEA
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 01:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729598AbfG2XkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 19:40:13 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:44128 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727165AbfG2XkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 19:40:12 -0400
Received: by mail-ed1-f67.google.com with SMTP id k8so60865408edr.11
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 16:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ah0YDAX4tps31uM94Mog3EfqSRkPQclrjh+Koz9Jenw=;
        b=RFwfg8iX7PIzhtmWOExc85tZCsHL9VICxrk24Xd9r7mZZyqfHONjQVOjXXpJciItpo
         DHLt/qwyvxfn6FPouErAalpLm8MpFto3kaQeFunsXXfjA8GGI0FJFaZgJlSDIRCCiiDy
         /mwwC8aNbd/iWmNxJ7o3BRg+n0etNYTTYyy4vUuWS5krDsJB0s8cLOO+5AWXojrBsKkB
         aDYPzFRW7HmHBGkfFAAVeZZIz0SdBxJD2gXu+BO4YgR4B/JViXfGyCVDheQC6gm3XHG4
         R4Hx2ag8ZIxuOZCTJUrV2BX1K9JXfmG0FZtVT0afpSABFKBcnhWfp/1lLi3+wrfK5wMN
         BFaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ah0YDAX4tps31uM94Mog3EfqSRkPQclrjh+Koz9Jenw=;
        b=TvlNqPOnjfLVJIhMxfSd07dMLbCcEqtfHVSSAdK5fZj534VL9jxgnm70bOI8iDSrtQ
         wnFH/df1SZIfkE5AaL7eQCB0/7tfmy+gpW4/iNdKJeWmKew8IVKqiKDaBY2S9/vvY82L
         I3XjDJbc6Wphm30+nltcPfp0ve1gbzCEYBDBd1r70SjB2wFQgYh+tg1k9eil7zMC+iv1
         MrFGs/z04OPsJa0PYQTdI/3CIevdgYGa8489Ofr+Wty96/DhjsYLmriqLGYp58+dhr4P
         hnZ+sLzpQZGKwV7uRj3QQnVosSo68f2ms2aHBwm9sUUD0PLVDdR8Ugl5Q9a3EHB/ZiGv
         UIuA==
X-Gm-Message-State: APjAAAXErpG/w5GVSFVNCJ9QfMfNhXhh7sqO7/xkFDv9b+3zX4toyFlW
        8MC3WlLEv9SD8ocAN1YRhZRJrZy0CFOa8JR4kgE=
X-Google-Smtp-Source: APXvYqyi9KX6nOEh+P51BqpLYqzxNS/m0IlYw0GYzze5S/3dDoST+DZaT+uyVon4lDkVDCCHkuqIfo5ecy9LsfKLpzM=
X-Received: by 2002:a17:906:9410:: with SMTP id q16mr87000851ejx.90.1564443609577;
 Mon, 29 Jul 2019 16:40:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190723151702.14430-1-asolokha@kb.kras.ru> <20190723151702.14430-2-asolokha@kb.kras.ru>
In-Reply-To: <20190723151702.14430-2-asolokha@kb.kras.ru>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 30 Jul 2019 02:39:58 +0300
Message-ID: <CA+h21hpacLmKzoeKrdE-frZSTsiYCi4rKCObJ4LfAmfrCJ6H9g@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] gianfar: convert to phylink
To:     Arseny Solokha <asolokha@kb.kras.ru>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arseny,

Nice project!

On Wed, 24 Jul 2019 at 03:38, Arseny Solokha <asolokha@kb.kras.ru> wrote:
>
> Convert gianfar to use the phylink API for better SFP modules support.
>
> The driver still uses phylib for serdes configuration over the TBI
> interface, as there seems to be no functionally equivalent API present
> in phylink (yet). phylib usage is basically confined in two functions.
>
> One needs to change their Device Tree accordingly to get working SFP
> support:
>
>  enet1: ethernet@25000 {
>  <...>
>         device_type = "network";
>         model = "eTSEC";
>         compatible = "gianfar";
>         tbi-handle = <&tbi0>;
> +       phy-connection-type = "sgmii";
> +       managed = "in-band-status";
> +       sfp = <&sfp>;
>         max-speed = <1000>;
>
>         mdio@520 {
>                 #address-cells = <1>;
>                 #size-cells = <0>;
>                 compatible = "fsl,gianfar-tbi";
>                 reg = <0x520 0x20>;
>
>                 tbi0: tbi-phy@1f {
>                         reg = <0x1f>;
>                         device_type = "tbi-phy";
>                 };
>         };
> +
> +       sfp: sfp0 {
> +               compatible = "sff,sfp";
> +               i2c-bus = <&i2c1>;
> +               mod-def0-gpios = <&gpio 4 GPIO_ACTIVE_LOW>;
> +               rate-select0-gpios = <&gpio 13 GPIO_ACTIVE_HIGH>;
> +               tx-disable-gpios = <&gpio 5 GPIO_ACTIVE_LOW>;
> +               tx-fault-gpios = <&gpio 12 GPIO_ACTIVE_HIGH>;
> +               los-gpios = <&gpio 3 GPIO_ACTIVE_HIGH>;
> +       };
>  };
>
> Signed-off-by: Arseny Solokha <asolokha@kb.kras.ru>
> ---
>  drivers/net/ethernet/freescale/Kconfig        |   2 +-
>  drivers/net/ethernet/freescale/gianfar.c      | 409 +++++++++---------
>  drivers/net/ethernet/freescale/gianfar.h      |  26 +-
>  .../net/ethernet/freescale/gianfar_ethtool.c  |  79 ++--
>  4 files changed, 251 insertions(+), 265 deletions(-)
>
> diff --git a/drivers/net/ethernet/freescale/Kconfig b/drivers/net/ethernet/freescale/Kconfig
> index 6a7e8993119f..8b51d423b61d 100644
> --- a/drivers/net/ethernet/freescale/Kconfig
> +++ b/drivers/net/ethernet/freescale/Kconfig
> @@ -89,7 +89,7 @@ config GIANFAR
>         tristate "Gianfar Ethernet"
>         depends on HAS_DMA
>         select FSL_PQ_MDIO
> -       select PHYLIB
> +       select PHYLINK
>         select CRC32
>         ---help---
>           This driver supports the Gigabit TSEC on the MPC83xx, MPC85xx,
> diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
> index 7ea19e173339..64c7b174e591 100644
> --- a/drivers/net/ethernet/freescale/gianfar.c
> +++ b/drivers/net/ethernet/freescale/gianfar.c
> @@ -96,6 +96,7 @@
>  #include <linux/mii.h>
>  #include <linux/phy.h>
>  #include <linux/phy_fixed.h>
> +#include <linux/phylink.h>

You can remove linux/phy.h.
You (PHYLINK, actually) broke .ndo_change_carrier, and therefore
commit 6211d46713c5 ("gianfar: Add change_carrier() for Fixed PHYs").
If we were honest, we should probably revert that commit entirely now.
Once you do that, you can remove linux/phy_fixed.h as well.

>  #include <linux/of.h>
>  #include <linux/of_net.h>
>
> @@ -117,8 +118,18 @@ static int gfar_change_mtu(struct net_device *dev, int new_mtu);
>  static irqreturn_t gfar_error(int irq, void *dev_id);
>  static irqreturn_t gfar_transmit(int irq, void *dev_id);
>  static irqreturn_t gfar_interrupt(int irq, void *dev_id);
> -static void adjust_link(struct net_device *dev);
> -static noinline void gfar_update_link_state(struct gfar_private *priv);
> +static void gfar_phylink_validate(struct phylink_config *config,
> +                                 unsigned long *supported,
> +                                 struct phylink_link_state *state);
> +static int gfar_mac_link_state(struct phylink_config *config,
> +                              struct phylink_link_state *state);
> +static void gfar_mac_config(struct phylink_config *config, unsigned int mode,
> +                           const struct phylink_link_state *state);
> +static void gfar_mac_an_restart(struct phylink_config *config);
> +static void gfar_mac_link_down(struct phylink_config *config, unsigned int mode,
> +                              phy_interface_t interface);
> +static void gfar_mac_link_up(struct phylink_config *config, unsigned int mode,
> +                            phy_interface_t interface, struct phy_device *phy);

Please do not add to this forward declaration madness. A cleanup patch
in this area would be highly appreciated.

>  static int init_phy(struct net_device *dev);
>  static int gfar_probe(struct platform_device *ofdev);
>  static int gfar_remove(struct platform_device *ofdev);
> @@ -504,6 +515,15 @@ static const struct net_device_ops gfar_netdev_ops = {
>  #endif
>  };
>
> +static const struct phylink_mac_ops gfar_phylink_ops = {
> +       .validate = gfar_phylink_validate,
> +       .mac_link_state = gfar_mac_link_state,
> +       .mac_config = gfar_mac_config,
> +       .mac_an_restart = gfar_mac_an_restart,
> +       .mac_link_down = gfar_mac_link_down,
> +       .mac_link_up = gfar_mac_link_up,
> +};
> +
>  static void gfar_ints_disable(struct gfar_private *priv)
>  {
>         int i;
> @@ -733,6 +753,7 @@ static int gfar_of_init(struct platform_device *ofdev, struct net_device **pdev)
>         struct gfar_private *priv = NULL;
>         struct device_node *np = ofdev->dev.of_node;
>         struct device_node *child = NULL;
> +       struct phylink *phylink;
>         u32 stash_len = 0;
>         u32 stash_idx = 0;
>         unsigned int num_tx_qs, num_rx_qs;
> @@ -891,11 +912,21 @@ static int gfar_of_init(struct platform_device *ofdev, struct net_device **pdev)
>
>         err = of_property_read_string(np, "phy-connection-type", &ctype);
>
> -       /* We only care about rgmii-id.  The rest are autodetected */
> -       if (err == 0 && !strcmp(ctype, "rgmii-id"))
> -               priv->interface = PHY_INTERFACE_MODE_RGMII_ID;
> -       else
> +       /* We only care about rgmii-id and sgmii - the former
> +        * is indistinguishable from rgmii in hardware, and phylink needs
> +        * the latter to be set appropriately for correct phy configuration.
> +        * The rest are autodetected
> +        */
> +       if (err == 0) {
> +               if (!strcmp(ctype, "rgmii-id"))
> +                       priv->interface = PHY_INTERFACE_MODE_RGMII_ID;
> +               else if (!strcmp(ctype, "sgmii"))
> +                       priv->interface = PHY_INTERFACE_MODE_SGMII;
> +               else
> +                       priv->interface = PHY_INTERFACE_MODE_MII;
> +       } else {
>                 priv->interface = PHY_INTERFACE_MODE_MII;
> +       }
>

No. Don't do this. Just do:

    err = of_get_phy_mode(np);
    if (err < 0)
        goto err_grp_init;

    priv->interface = err;

>         if (of_find_property(np, "fsl,magic-packet", NULL))
>                 priv->device_flags |= FSL_GIANFAR_DEV_HAS_MAGIC_PACKET;
> @@ -903,19 +934,21 @@ static int gfar_of_init(struct platform_device *ofdev, struct net_device **pdev)
>         if (of_get_property(np, "fsl,wake-on-filer", NULL))
>                 priv->device_flags |= FSL_GIANFAR_DEV_HAS_WAKE_ON_FILER;
>
> -       priv->phy_node = of_parse_phandle(np, "phy-handle", 0);
> +       priv->device_node = np;
> +       priv->speed = SPEED_UNKNOWN;
>
> -       /* In the case of a fixed PHY, the DT node associated
> -        * to the PHY is the Ethernet MAC DT node.
> -        */
> -       if (!priv->phy_node && of_phy_is_fixed_link(np)) {
> -               err = of_phy_register_fixed_link(np);
> -               if (err)
> -                       goto err_grp_init;
> +       priv->phylink_config.dev = &priv->ndev->dev;
> +       priv->phylink_config.type = PHYLINK_NETDEV;
>
> -               priv->phy_node = of_node_get(np);
> +       phylink = phylink_create(&priv->phylink_config, of_fwnode_handle(np),
> +                                priv->interface, &gfar_phylink_ops);

You introduced a bug here.
of_phy_connect used to take the PHY interface type (for good or bad)
from gfar_get_interface() (which is reconstructing it from the MAC
registers).
You are now passing the PHY interface type to phylink_create from the
"phy-connection-type" DT property.
At the very least, you are breaking LS1021A which uses phy-mode
instead of phy-connection-type (hence my comment above to use the
generic OF helper).
Actually I think you just uncovered a latent bug, in that the DT
bindings for phy-mode didn't mean much at all to the driver - it would
rely on what the bootloader had set up.
Actually DT bindings for phy-connection-type were most likely simply
bolt on on top of gianfar when they figured they couldn't just
auto-detect the various species of required RGMII delays.
But gfar_get_interface is a piece of history that was introduced in
the same commit as the enum phy_interface_t itself: e8a2b6a42073
("[PATCH] PHY: Add support for configuring the PHY connection
interface"). Its time has come.

> +       if (IS_ERR(phylink)) {
> +               err = PTR_ERR(phylink);
> +               goto err_grp_init;
>         }
>
> +       priv->phylink = phylink;
> +
>         /* Find the TBI PHY.  If it's not there, we don't support SGMII */
>         priv->tbi_node = of_parse_phandle(np, "tbi-handle", 0);
>
> @@ -994,7 +1027,7 @@ static int gfar_hwtstamp_get(struct net_device *netdev, struct ifreq *ifr)
>
>  static int gfar_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
>  {
> -       struct phy_device *phydev = dev->phydev;
> +       struct gfar_private *priv = netdev_priv(dev);
>
>         if (!netif_running(dev))
>                 return -EINVAL;
> @@ -1004,10 +1037,7 @@ static int gfar_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
>         if (cmd == SIOCGHWTSTAMP)
>                 return gfar_hwtstamp_get(dev, rq);
>
> -       if (!phydev)
> -               return -ENODEV;
> -
> -       return phy_mii_ioctl(phydev, rq, cmd);
> +       return phylink_mii_ioctl(priv->phylink, rq, cmd);
>  }
>
>  static u32 cluster_entry_per_class(struct gfar_private *priv, u32 rqfar,
> @@ -1307,7 +1337,6 @@ static void gfar_init_addr_hash_table(struct gfar_private *priv)
>   */
>  static int gfar_probe(struct platform_device *ofdev)
>  {
> -       struct device_node *np = ofdev->dev.of_node;
>         struct net_device *dev = NULL;
>         struct gfar_private *priv = NULL;
>         int err = 0, i;
> @@ -1463,12 +1492,10 @@ static int gfar_probe(struct platform_device *ofdev)
>         return 0;
>
>  register_fail:
> -       if (of_phy_is_fixed_link(np))
> -               of_phy_deregister_fixed_link(np);
>         unmap_group_regs(priv);
>         gfar_free_rx_queues(priv);
>         gfar_free_tx_queues(priv);
> -       of_node_put(priv->phy_node);
> +       phylink_destroy(priv->phylink);
>         of_node_put(priv->tbi_node);
>         free_gfar_dev(priv);
>         return err;
> @@ -1477,19 +1504,15 @@ static int gfar_probe(struct platform_device *ofdev)
>  static int gfar_remove(struct platform_device *ofdev)
>  {
>         struct gfar_private *priv = platform_get_drvdata(ofdev);
> -       struct device_node *np = ofdev->dev.of_node;
>
> -       of_node_put(priv->phy_node);
>         of_node_put(priv->tbi_node);
>
>         unregister_netdev(priv->ndev);
>
> -       if (of_phy_is_fixed_link(np))
> -               of_phy_deregister_fixed_link(np);
> -
>         unmap_group_regs(priv);
>         gfar_free_rx_queues(priv);
>         gfar_free_tx_queues(priv);
> +       phylink_destroy(priv->phylink);
>         free_gfar_dev(priv);
>
>         return 0;
> @@ -1643,9 +1666,11 @@ static int gfar_suspend(struct device *dev)
>                 gfar_start_wol_filer(priv);
>
>         } else {
> -               phy_stop(ndev->phydev);
> +               phylink_stop(phy->phylink);
>         }
>
> +       priv->speed = SPEED_UNKNOWN;
> +
>         return 0;
>  }
>
> @@ -1672,7 +1697,7 @@ static int gfar_resume(struct device *dev)
>                 gfar_filer_restore_table(priv);
>
>         } else {
> -               phy_start(ndev->phydev);
> +               phylink_start(priv->phylink);
>         }
>
>         gfar_start(priv);
> @@ -1702,12 +1727,7 @@ static int gfar_restore(struct device *dev)
>
>         gfar_start(priv);
>
> -       priv->oldlink = 0;
> -       priv->oldspeed = 0;
> -       priv->oldduplex = -1;
> -
> -       if (ndev->phydev)
> -               phy_start(ndev->phydev);
> +       phylink_start(priv->phylink);
>
>         netif_device_attach(ndev);
>         enable_napi(priv);
> @@ -1781,46 +1801,26 @@ static phy_interface_t gfar_get_interface(struct net_device *dev)
>   */
>  static int init_phy(struct net_device *dev)
>  {
> -       __ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
>         struct gfar_private *priv = netdev_priv(dev);
>         phy_interface_t interface;
> -       struct phy_device *phydev;
>         struct ethtool_eee edata;
> +       int flags = 0;
> +       int err;
>
> -       linkmode_set_bit_array(phy_10_100_features_array,
> -                              ARRAY_SIZE(phy_10_100_features_array),
> -                              mask);
> -       linkmode_set_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, mask);
> -       linkmode_set_bit(ETHTOOL_LINK_MODE_MII_BIT, mask);
> -       if (priv->device_flags & FSL_GIANFAR_DEV_HAS_GIGABIT)
> -               linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseT_Full_BIT, mask);
> -
> -       priv->oldlink = 0;
> -       priv->oldspeed = 0;
> -       priv->oldduplex = -1;
> -
> -       interface = gfar_get_interface(dev);
> -
> -       phydev = of_phy_connect(dev, priv->phy_node, &adjust_link, 0,
> -                               interface);
> -       if (!phydev) {
> -               dev_err(&dev->dev, "could not attach to PHY\n");
> -               return -ENODEV;
> +       err = phylink_of_phy_connect(priv->phylink, priv->device_node, flags);
> +       if (err) {
> +               netdev_err(dev, "could not attach to PHY: %d\n", err);
> +               return err;

While you're at it, can you say "connect" instead of "attach" here?

>         }
>
> +       priv->tbi_phy = NULL;
> +       interface = gfar_get_interface(dev);

Be consistent and just go for priv->interface. Nobody's changing it anyway.

>         if (interface == PHY_INTERFACE_MODE_SGMII)
>                 gfar_configure_serdes(dev);
>

My gut feeling says that this should be moved to gfar_mac_config.

> -       /* Remove any features not supported by the controller */
> -       linkmode_and(phydev->supported, phydev->supported, mask);
> -       linkmode_copy(phydev->advertising, phydev->supported);
> -
> -       /* Add support for flow control */
> -       phy_support_asym_pause(phydev);
> -
>         /* disable EEE autoneg, EEE not supported by eTSEC */
>         memset(&edata, 0, sizeof(struct ethtool_eee));
> -       phy_ethtool_set_eee(phydev, &edata);
> +       phylink_ethtool_set_eee(priv->phylink, &edata);
>
>         return 0;
>  }
> @@ -1850,6 +1850,8 @@ static void gfar_configure_serdes(struct net_device *dev)
>                 return;
>         }
>
> +       priv->tbi_phy = tbiphy;
> +
>         /* If the link is already up, we must already be ok, and don't need to
>          * configure and reset the TBI<->SerDes link.  Maybe U-Boot configured
>          * everything for us?  Resetting it takes the link down and requires
> @@ -1964,7 +1966,7 @@ void stop_gfar(struct net_device *dev)
>         /* disable ints and gracefully shut down Rx/Tx DMA */
>         gfar_halt(priv);
>
> -       phy_stop(dev->phydev);
> +       phylink_stop(priv->phylink);
>
>         free_skb_resources(priv);
>  }
> @@ -2219,12 +2221,7 @@ int startup_gfar(struct net_device *ndev)
>         /* Start Rx/Tx DMA and enable the interrupts */
>         gfar_start(priv);
>
> -       /* force link state update after mac reset */
> -       priv->oldlink = 0;
> -       priv->oldspeed = 0;
> -       priv->oldduplex = -1;
> -
> -       phy_start(ndev->phydev);
> +       phylink_start(priv->phylink);
>
>         enable_napi(priv);
>
> @@ -2593,7 +2590,7 @@ static int gfar_close(struct net_device *dev)
>         stop_gfar(dev);
>
>         /* Disconnect from the PHY */
> -       phy_disconnect(dev->phydev);
> +       phylink_disconnect_phy(priv->phylink);

It is very odd to disconnect from the PHY on ndo_close and connect
back on ndo_open. I don't know of any other driver that does that.
Can't you change the behavior to simply start and stop phylink here?

>
>         gfar_free_irq(priv);
>
> @@ -3387,23 +3384,6 @@ static irqreturn_t gfar_interrupt(int irq, void *grp_id)
>         return IRQ_HANDLED;
>  }
>
> -/* Called every time the controller might need to be made
> - * aware of new link state.  The PHY code conveys this
> - * information through variables in the phydev structure, and this
> - * function converts those variables into the appropriate
> - * register values, and can bring down the device if needed.
> - */
> -static void adjust_link(struct net_device *dev)
> -{
> -       struct gfar_private *priv = netdev_priv(dev);
> -       struct phy_device *phydev = dev->phydev;
> -
> -       if (unlikely(phydev->link != priv->oldlink ||
> -                    (phydev->link && (phydev->duplex != priv->oldduplex ||
> -                                      phydev->speed != priv->oldspeed))))
> -               gfar_update_link_state(priv);
> -}

Getting rid of the cruft from this function deserves its own patch.

> -
>  /* Update the hash table based on the current list of multicast
>   * addresses we subscribe to.  Also, change the promiscuity of
>   * the device based on the flags (this function is called
> @@ -3635,132 +3615,169 @@ static irqreturn_t gfar_error(int irq, void *grp_id)
>         return IRQ_HANDLED;
>  }
>
> -static u32 gfar_get_flowctrl_cfg(struct gfar_private *priv)
> +static void gfar_phylink_validate(struct phylink_config *config,
> +                                 unsigned long *supported,
> +                                 struct phylink_link_state *state)
> +{
> +       struct gfar_private *priv = netdev_priv(to_net_dev(config->dev));
> +       __ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
> +
> +       if (state->interface != PHY_INTERFACE_MODE_NA &&
> +           state->interface != PHY_INTERFACE_MODE_SGMII &&
> +           state->interface != PHY_INTERFACE_MODE_1000BASEX &&

Russell is right, you shouldn't advertise 1000Base-X if there is no
way of making sure that it works.
His question was:

> How is the difference between SGMII and 1000BASE-X handled?

To be honest I don't have a complete answer to that question. The
literature recommends writing 0x01a0 to the MII_ADVERTISE (0x4)
register of the MAC PCS for 1000Base-X, and 0x4001 for SGMII.
The FMan driver which uses the TSEC MAC does exactly that:
https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/tree/drivers/net/ethernet/freescale/fman/fman_dtsec.c#n58
However I can't seem to be able to trace down the definition of bit 14
from 0x4001 - it's reserved in all the manuals I see. I have a hunch
that it selects the format of the Config_Reg base page between
1000Base-X and SGMII.
But the bad news is that gianfar is only configuring the TBI PHY for
the 1000Base-X Config_Reg, even for SGMII PHYs. I'm not quite sure,
but I think that the only reason that this doesn't break in-band AN is
that we don't use in-band AN.

> +           !phy_interface_mode_is_rgmii(state->interface)) {
> +               phylink_zero(supported);
> +               return;
> +       }
> +
> +       phylink_set(mask, Autoneg);
> +       phylink_set(mask, Pause);
> +       phylink_set(mask, Asym_Pause);
> +       phylink_set_port_modes(mask);
> +
> +       phylink_set(mask, 10baseT_Half);
> +       phylink_set(mask, 10baseT_Full);
> +       phylink_set(mask, 100baseT_Half);
> +       phylink_set(mask, 100baseT_Full);
> +
> +       if (priv->device_flags & FSL_GIANFAR_DEV_HAS_GIGABIT) {
> +               phylink_set(mask, 1000baseX_Full);
> +               phylink_set(mask, 1000baseT_Full);
> +       }
> +
> +       linkmode_and(supported, supported, mask);
> +       linkmode_and(state->advertising, state->advertising, mask);
> +}
> +
> +static int gfar_mac_link_state(struct phylink_config *config,
> +                              struct phylink_link_state *state)
> +{
> +       if (state->interface == PHY_INTERFACE_MODE_SGMII ||
> +           state->interface == PHY_INTERFACE_MODE_1000BASEX) {

What if you reduce the indentation level by 1 here, by just exiting if
the interface mode is not SGMII?

> +               struct gfar_private *priv =
> +                       netdev_priv(to_net_dev(config->dev));
> +               u16 tbi_cr;
> +
> +               if (!priv->tbi_phy)
> +                       return -ENODEV;
> +
> +               tbi_cr = phy_read(priv->tbi_phy, MII_TBI_CR);
> +
> +               state->duplex = !!(tbi_cr & TBI_CR_FULL_DUPLEX);

Woah there. Aren't you supposed to first ensure state->an_complete is
ok, based on TBI_MII_Register_Set_SR[AN_Done]? There's also a
Link_Status bit in that register that you could retrieve.

> +               if ((tbi_cr & TBI_CR_SPEED_1000_MASK) == TBI_CR_SPEED_1000_MASK)
> +                       state->speed = SPEED_1000;
> +       }

See the Speed_Bit table from TBI_MII_Register_Set_ANLPBPA_SGMII for
the link partner (aka SGMII PHY) advertisement. You have to do a
logical-and between that and your own. Also please make sure you
really are in SGMII AN and not 1000 Base-X when interpreting registers
4 & 5 as one way or another.

> +
> +       return 1;
> +}
> +
> +static u32 gfar_get_flowctrl_cfg(const struct phylink_link_state *state)
>  {
> -       struct net_device *ndev = priv->ndev;
> -       struct phy_device *phydev = ndev->phydev;
>         u32 val = 0;
>
> -       if (!phydev->duplex)
> +       if (!state->duplex)
>                 return val;
>
> -       if (!priv->pause_aneg_en) {
> -               if (priv->tx_pause_en)
> -                       val |= MACCFG1_TX_FLOW;
> -               if (priv->rx_pause_en)
> -                       val |= MACCFG1_RX_FLOW;
> -       } else {
> -               u16 lcl_adv, rmt_adv;
> -               u8 flowctrl;
> -               /* get link partner capabilities */
> -               rmt_adv = 0;
> -               if (phydev->pause)
> -                       rmt_adv = LPA_PAUSE_CAP;
> -               if (phydev->asym_pause)
> -                       rmt_adv |= LPA_PAUSE_ASYM;
> -
> -               lcl_adv = linkmode_adv_to_lcl_adv_t(phydev->advertising);
> -               flowctrl = mii_resolve_flowctrl_fdx(lcl_adv, rmt_adv);
> -               if (flowctrl & FLOW_CTRL_TX)
> -                       val |= MACCFG1_TX_FLOW;
> -               if (flowctrl & FLOW_CTRL_RX)
> -                       val |= MACCFG1_RX_FLOW;
> -       }
> +       if (state->pause & MLO_PAUSE_TX)
> +               val |= MACCFG1_TX_FLOW;
> +       if (state->pause & MLO_PAUSE_RX)
> +               val |= MACCFG1_RX_FLOW;
>
>         return val;
>  }
>
> -static noinline void gfar_update_link_state(struct gfar_private *priv)
> +static void gfar_mac_config(struct phylink_config *config, unsigned int mode,
> +                           const struct phylink_link_state *state)
>  {
> +       struct gfar_private *priv = netdev_priv(to_net_dev(config->dev));
>         struct gfar __iomem *regs = priv->gfargrp[0].regs;
> -       struct net_device *ndev = priv->ndev;
> -       struct phy_device *phydev = ndev->phydev;
> -       struct gfar_priv_rx_q *rx_queue = NULL;
> -       int i;
> +       u32 maccfg1, new_maccfg1;
> +       u32 maccfg2, new_maccfg2;
> +       u32 ecntrl, new_ecntrl;
> +       u32 tx_flow, new_tx_flow;

Don't introduce new_ variables. Is there any issue if you
unconditionally write to the MAC registers?

>
>         if (unlikely(test_bit(GFAR_RESETTING, &priv->state)))
>                 return;
>
> -       if (phydev->link) {
> -               u32 tempval1 = gfar_read(&regs->maccfg1);
> -               u32 tempval = gfar_read(&regs->maccfg2);
> -               u32 ecntrl = gfar_read(&regs->ecntrl);
> -               u32 tx_flow_oldval = (tempval1 & MACCFG1_TX_FLOW);
> +       if (unlikely(phylink_autoneg_inband(mode)))
> +               return;
>
> -               if (phydev->duplex != priv->oldduplex) {
> -                       if (!(phydev->duplex))
> -                               tempval &= ~(MACCFG2_FULL_DUPLEX);
> -                       else
> -                               tempval |= MACCFG2_FULL_DUPLEX;
> +       maccfg1 = gfar_read(&regs->maccfg1);
> +       maccfg2 = gfar_read(&regs->maccfg2);
> +       ecntrl = gfar_read(&regs->ecntrl);
>
> -                       priv->oldduplex = phydev->duplex;
> -               }
> +       new_maccfg2 = maccfg2 & ~(MACCFG2_FULL_DUPLEX | MACCFG2_IF);
> +       new_ecntrl = ecntrl & ~ECNTRL_R100;
>
> -               if (phydev->speed != priv->oldspeed) {
> -                       switch (phydev->speed) {
> -                       case 1000:
> -                               tempval =
> -                                   ((tempval & ~(MACCFG2_IF)) | MACCFG2_GMII);
> +       if (state->duplex)
> +               new_maccfg2 |= MACCFG2_FULL_DUPLEX;
>
> -                               ecntrl &= ~(ECNTRL_R100);
> -                               break;
> -                       case 100:
> -                       case 10:
> -                               tempval =
> -                                   ((tempval & ~(MACCFG2_IF)) | MACCFG2_MII);
> -
> -                               /* Reduced mode distinguishes
> -                                * between 10 and 100
> -                                */
> -                               if (phydev->speed == SPEED_100)
> -                                       ecntrl |= ECNTRL_R100;
> -                               else
> -                                       ecntrl &= ~(ECNTRL_R100);
> -                               break;
> -                       default:
> -                               netif_warn(priv, link, priv->ndev,
> -                                          "Ack!  Speed (%d) is not 10/100/1000!\n",
> -                                          phydev->speed);

Please 1. remove "Ack!" 2. treat SPEED_UNKNOWN here by setting the MAC
into a low-power state (e.g. 10 Mbps - the power savings are real).
Don't print that Speed -1 is not 10/100/1000, we know that.

> -                               break;
> -                       }
> -
> -                       priv->oldspeed = phydev->speed;
> -               }
> -
> -               tempval1 &= ~(MACCFG1_TX_FLOW | MACCFG1_RX_FLOW);
> -               tempval1 |= gfar_get_flowctrl_cfg(priv);
> -
> -               /* Turn last free buffer recording on */
> -               if ((tempval1 & MACCFG1_TX_FLOW) && !tx_flow_oldval) {
> -                       for (i = 0; i < priv->num_rx_queues; i++) {
> -                               u32 bdp_dma;
> -
> -                               rx_queue = priv->rx_queue[i];
> -                               bdp_dma = gfar_rxbd_dma_lastfree(rx_queue);
> -                               gfar_write(rx_queue->rfbptr, bdp_dma);
> -                       }
> -
> -                       priv->tx_actual_en = 1;
> -               }
> -
> -               if (unlikely(!(tempval1 & MACCFG1_TX_FLOW) && tx_flow_oldval))
> -                       priv->tx_actual_en = 0;
> -
> -               gfar_write(&regs->maccfg1, tempval1);
> -               gfar_write(&regs->maccfg2, tempval);
> -               gfar_write(&regs->ecntrl, ecntrl);
> -
> -               if (!priv->oldlink)
> -                       priv->oldlink = 1;
> -
> -       } else if (priv->oldlink) {
> -               priv->oldlink = 0;
> -               priv->oldspeed = 0;
> -               priv->oldduplex = -1;
> +       switch (state->speed) {
> +       case SPEED_1000:
> +               new_maccfg2 |= MACCFG2_GMII;
> +               break;
> +       case SPEED_100:
> +               new_maccfg2 |= MACCFG2_MII;
> +               new_ecntrl = ecntrl | ECNTRL_R100;
> +               break;
> +       case SPEED_10:
> +               new_maccfg2 |= MACCFG2_MII;
> +               break;
> +       default:
> +               netif_warn(priv, link, priv->ndev,
> +                          "Ack!  Speed (%d) is not 10/100/1000!\n",
> +                          state->speed);
> +               return;
>         }
>
> -       if (netif_msg_link(priv))
> -               phy_print_status(phydev);
> +       priv->speed = state->speed;
> +
> +       new_maccfg1 = maccfg1 & ~(MACCFG1_TX_FLOW | MACCFG1_RX_FLOW);
> +       new_maccfg1 |= gfar_get_flowctrl_cfg(state);
> +
> +       /* Turn last free buffer recording on */
> +       tx_flow = maccfg1 & MACCFG1_TX_FLOW;
> +       new_tx_flow = new_maccfg1 & MACCFG1_TX_FLOW;
> +       if (new_tx_flow && !tx_flow) {
> +               int i;
> +
> +               for (i = 0; i < priv->num_rx_queues; i++) {
> +                       struct gfar_priv_rx_q *rx_queue;
> +                       u32 bdp_dma;
> +
> +                       rx_queue = priv->rx_queue[i];
> +                       bdp_dma = gfar_rxbd_dma_lastfree(rx_queue);
> +                       gfar_write(rx_queue->rfbptr, bdp_dma);
> +               }
> +
> +               priv->tx_actual_en = 1;
> +       } else if (unlikely(!new_tx_flow && tx_flow)) {
> +               priv->tx_actual_en = 0;
> +       }
> +
> +       if (new_maccfg1 != maccfg1)
> +               gfar_write(&regs->maccfg1, new_maccfg1);
> +       if (new_maccfg2 != maccfg2)
> +               gfar_write(&regs->maccfg2, new_maccfg2);
> +       if (new_ecntrl != ecntrl)
> +               gfar_write(&regs->ecntrl, new_ecntrl);
> +}
> +
> +static void gfar_mac_an_restart(struct phylink_config *config)
> +{
> +       /* Not supported */
> +}

What about running gfar_configure_serdes again?

> +
> +static void gfar_mac_link_down(struct phylink_config *config, unsigned int mode,
> +                              phy_interface_t interface)
> +{
> +       /* Not supported */
> +}
> +

What about disabling RX_EN and TX_EN from MACCFG1?

> +static void gfar_mac_link_up(struct phylink_config *config, unsigned int mode,
> +                            phy_interface_t interface, struct phy_device *phy)
> +{
> +       /* Not supported */
>  }
>

What about enabling RX_EN and TX_EN from MACCFG1?

>  static const struct of_device_id gfar_match[] =
> diff --git a/drivers/net/ethernet/freescale/gianfar.h b/drivers/net/ethernet/freescale/gianfar.h
> index f2af96349c7b..0b28b1f60f2d 100644
> --- a/drivers/net/ethernet/freescale/gianfar.h
> +++ b/drivers/net/ethernet/freescale/gianfar.h
> @@ -31,8 +31,7 @@
>  #include <linux/skbuff.h>
>  #include <linux/spinlock.h>
>  #include <linux/mm.h>
> -#include <linux/mii.h>
> -#include <linux/phy.h>
> +#include <linux/phylink.h>
>
>  #include <asm/io.h>
>  #include <asm/irq.h>
> @@ -149,8 +148,13 @@ extern const char gfar_driver_version[];
>  #define GFAR_SUPPORTED_GBIT SUPPORTED_1000baseT_Full
>
>  /* TBI register addresses */
> +#define MII_TBI_CR             0x00
>  #define MII_TBICON             0x11
>
> +/* TBI_CR register bit fields */
> +#define TBI_CR_FULL_DUPLEX     0x0100
> +#define TBI_CR_SPEED_1000_MASK 0x0040
> +

I think BIT() definitions are preferred, even if that means you have
to convert existing code first.

>  /* TBICON register bit fields */
>  #define TBICON_CLK_SELECT      0x0020
>
> @@ -1148,12 +1152,12 @@ struct gfar_private {
>
>         /* PHY stuff */
>         phy_interface_t interface;
> -       struct device_node *phy_node;
> +       struct device_node *device_node;
>         struct device_node *tbi_node;
> -       struct mii_bus *mii_bus;
> -       int oldspeed;
> -       int oldduplex;
> -       int oldlink;
> +       struct phylink *phylink;
> +       struct phylink_config phylink_config;
> +       struct phy_device *tbi_phy;
> +       int speed;
>
>         uint32_t msg_enable;
>
> @@ -1165,11 +1169,7 @@ struct gfar_private {
>                 bd_stash_en:1,
>                 rx_filer_enable:1,
>                 /* Enable priorty based Tx scheduling in Hw */
> -               prio_sched_en:1,
> -               /* Flow control flags */
> -               pause_aneg_en:1,
> -               tx_pause_en:1,
> -               rx_pause_en:1;
> +               prio_sched_en:1;
>
>         /* The total tx and rx ring size for the enabled queues */
>         unsigned int total_tx_ring_size;
> @@ -1333,8 +1333,6 @@ void reset_gfar(struct net_device *dev);
>  void gfar_mac_reset(struct gfar_private *priv);
>  void gfar_halt(struct gfar_private *priv);
>  void gfar_start(struct gfar_private *priv);
> -void gfar_phy_test(struct mii_bus *bus, struct phy_device *phydev, int enable,
> -                  u32 regnum, u32 read);
>  void gfar_configure_coalescing_all(struct gfar_private *priv);
>  int gfar_set_features(struct net_device *dev, netdev_features_t features);
>
> diff --git a/drivers/net/ethernet/freescale/gianfar_ethtool.c b/drivers/net/ethernet/freescale/gianfar_ethtool.c
> index 3433b46b90c1..146b30d07789 100644
> --- a/drivers/net/ethernet/freescale/gianfar_ethtool.c
> +++ b/drivers/net/ethernet/freescale/gianfar_ethtool.c
> @@ -35,7 +35,7 @@
>  #include <asm/types.h>
>  #include <linux/ethtool.h>
>  #include <linux/mii.h>
> -#include <linux/phy.h>
> +#include <linux/phylink.h>
>  #include <linux/sort.h>
>  #include <linux/if_vlan.h>
>  #include <linux/of_platform.h>
> @@ -207,12 +207,10 @@ static void gfar_get_regs(struct net_device *dev, struct ethtool_regs *regs,
>  static unsigned int gfar_usecs2ticks(struct gfar_private *priv,
>                                      unsigned int usecs)
>  {
> -       struct net_device *ndev = priv->ndev;
> -       struct phy_device *phydev = ndev->phydev;

Are you sure this still works? You missed a ndev->phydev check from
gfar_gcoalesce, where this is called from. Technically you can still
check ndev->phydev, it's just that PHYLINK doesn't guarantee you'll
have one (e.g. fixed-link interfaces).

>         unsigned int count;
>
>         /* The timer is different, depending on the interface speed */
> -       switch (phydev->speed) {
> +       switch (priv->speed) {

What about retrieving the speed from phylink_ethtool_ksettings_get,
and using that here? This would save you from introducing a cached
priv->speed.

>         case SPEED_1000:
>                 count = GFAR_GBIT_TIME;
>                 break;
> @@ -234,12 +232,10 @@ static unsigned int gfar_usecs2ticks(struct gfar_private *priv,
>  static unsigned int gfar_ticks2usecs(struct gfar_private *priv,
>                                      unsigned int ticks)
>  {
> -       struct net_device *ndev = priv->ndev;
> -       struct phy_device *phydev = ndev->phydev;
>         unsigned int count;
>
>         /* The timer is different, depending on the interface speed */
> -       switch (phydev->speed) {
> +       switch (priv->speed) {

Same comments as above, but for gfar_scoalesce.

>         case SPEED_1000:
>                 count = GFAR_GBIT_TIME;
>                 break;
> @@ -489,58 +485,15 @@ static void gfar_gpauseparam(struct net_device *dev,
>  {
>         struct gfar_private *priv = netdev_priv(dev);
>
> -       epause->autoneg = !!priv->pause_aneg_en;
> -       epause->rx_pause = !!priv->rx_pause_en;
> -       epause->tx_pause = !!priv->tx_pause_en;
> +       phylink_ethtool_get_pauseparam(priv->phylink, epause);
>  }
>
>  static int gfar_spauseparam(struct net_device *dev,
>                             struct ethtool_pauseparam *epause)
>  {
>         struct gfar_private *priv = netdev_priv(dev);
> -       struct phy_device *phydev = dev->phydev;
> -       struct gfar __iomem *regs = priv->gfargrp[0].regs;
>
> -       if (!phydev)
> -               return -ENODEV;
> -
> -       if (!phy_validate_pause(phydev, epause))
> -               return -EINVAL;
> -
> -       priv->rx_pause_en = priv->tx_pause_en = 0;
> -       phy_set_asym_pause(phydev, epause->rx_pause, epause->tx_pause);
> -       if (epause->rx_pause) {
> -               priv->rx_pause_en = 1;
> -
> -               if (epause->tx_pause) {
> -                       priv->tx_pause_en = 1;
> -               }
> -       } else if (epause->tx_pause) {
> -               priv->tx_pause_en = 1;
> -       }
> -
> -       if (epause->autoneg)
> -               priv->pause_aneg_en = 1;
> -       else
> -               priv->pause_aneg_en = 0;
> -
> -       if (!epause->autoneg) {
> -               u32 tempval = gfar_read(&regs->maccfg1);
> -
> -               tempval &= ~(MACCFG1_TX_FLOW | MACCFG1_RX_FLOW);
> -
> -               priv->tx_actual_en = 0;
> -               if (priv->tx_pause_en) {
> -                       priv->tx_actual_en = 1;
> -                       tempval |= MACCFG1_TX_FLOW;
> -               }
> -
> -               if (priv->rx_pause_en)
> -                       tempval |= MACCFG1_RX_FLOW;
> -               gfar_write(&regs->maccfg1, tempval);
> -       }
> -
> -       return 0;
> +       return phylink_ethtool_set_pauseparam(priv->phylink, epause);
>  }
>
>  int gfar_set_features(struct net_device *dev, netdev_features_t features)
> @@ -1519,6 +1472,24 @@ static int gfar_get_ts_info(struct net_device *dev,
>         return 0;
>  }
>
> +/* Set link ksettings (phy address, speed) for ethtools */

ethtool, not ethtools. Also, I'm not quite sure what you mean by
setting the "phy address" with ethtool.

> +static int gfar_get_link_ksettings(struct net_device *dev,
> +                                  struct ethtool_link_ksettings *cmd)
> +{
> +       struct gfar_private *priv = netdev_priv(dev);
> +
> +       return phylink_ethtool_ksettings_get(priv->phylink, cmd);
> +}
> +
> +/* Get link ksettings for ethtools */
> +static int gfar_set_link_ksettings(struct net_device *dev,
> +                                  const struct ethtool_link_ksettings *cmd)
> +{
> +       struct gfar_private *priv = netdev_priv(dev);
> +
> +       return phylink_ethtool_ksettings_set(priv->phylink, cmd);
> +}
> +
>  const struct ethtool_ops gfar_ethtool_ops = {
>         .get_drvinfo = gfar_gdrvinfo,
>         .get_regs_len = gfar_reglen,
> @@ -1542,6 +1513,6 @@ const struct ethtool_ops gfar_ethtool_ops = {
>         .set_rxnfc = gfar_set_nfc,
>         .get_rxnfc = gfar_get_nfc,
>         .get_ts_info = gfar_get_ts_info,
> -       .get_link_ksettings = phy_ethtool_get_link_ksettings,
> -       .set_link_ksettings = phy_ethtool_set_link_ksettings,
> +       .get_link_ksettings = gfar_get_link_ksettings,
> +       .set_link_ksettings = gfar_set_link_ksettings,
>  };
> --
> 2.22.0
>

Thanks a lot for doing this!
-Vladimir
