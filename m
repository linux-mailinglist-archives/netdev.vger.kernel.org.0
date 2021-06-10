Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C5243A3307
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 20:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbhFJSZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 14:25:38 -0400
Received: from mail-oi1-f169.google.com ([209.85.167.169]:39700 "EHLO
        mail-oi1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbhFJSZh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 14:25:37 -0400
Received: by mail-oi1-f169.google.com with SMTP id m137so3098111oig.6;
        Thu, 10 Jun 2021 11:23:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NrjAV8z5hHfquxlCws5/Kq6Ph5yFfkWzaCR+p+DRkAg=;
        b=Bc30wVGBrcqZPR+diV/b++W+mXpqrGlrBdgdkEYlwUTAvprPgEmlEcvEQ6uM/c1Ooc
         1y1iwXhAZNlkXUXK3REjCIX447Pad0Jwgc7319ULlNH0CS3MHccagbOcXmCd1xWig1uU
         I3DG0eUUk6zniDWyyg4V5Cod+ETeLNAUutK7x/IrzEISJKldPwgSzU6QlSkEBiYYjohn
         HsqcsvG6cCxbPir4fk0aEpMO4/coqVmSI+lqeZr5w6Avi51a77+guRHb5N21HB/7TDMQ
         ZIpXoQV7em0CCIZ3N6bbMfbPXHl0ZNGFFKndE7um62CtyeR47eh4x6M7RZX2OUYiZEhz
         XgJw==
X-Gm-Message-State: AOAM5316B5M72SsdoPsQCAnXhGJYD4d/as0hktEkTaT54bErYphqMikh
        3PMAns+FB8Yb8HIOLo9asGUKWuKMdMyLWZr1uAU=
X-Google-Smtp-Source: ABdhPJzO6Pk7960QzeS+MYDlfjMd4Ve4ahJK1OSm3QEYBDeyqyI7GIjR5sj1UZkM0GLbodBia195zwuR3XDcXaPf44M=
X-Received: by 2002:aca:4487:: with SMTP id r129mr4068119oia.157.1623349409588;
 Thu, 10 Jun 2021 11:23:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210610163917.4138412-1-ciorneiioana@gmail.com> <20210610163917.4138412-16-ciorneiioana@gmail.com>
In-Reply-To: <20210610163917.4138412-16-ciorneiioana@gmail.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Thu, 10 Jun 2021 20:23:18 +0200
Message-ID: <CAJZ5v0gKtsNTqn3gXFrfK_8-6YJ1hmXyNNcfbX4qf7q93HfoQg@mail.gmail.com>
Subject: Re: [PATCH net-next v8 15/15] net: dpaa2-mac: Add ACPI support for
 DPAA2 MAC driver
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, calvin.johnson@nxp.com,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux.cj" <linux.cj@gmail.com>, netdev <netdev@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Len Brown <lenb@kernel.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 10, 2021 at 6:40 PM Ioana Ciornei <ciorneiioana@gmail.com> wrote:
>
> From: Calvin Johnson <calvin.johnson@oss.nxp.com>
>
> Modify dpaa2_mac_get_node() to get the dpmac fwnode from either
> DT or ACPI.
>
> Modify dpaa2_mac_get_if_mode() to get interface mode from dpmac_node
> which is a fwnode.
>
> Modify dpaa2_pcs_create() to create pcs from dpmac_node fwnode.
>
> Modify dpaa2_mac_connect() to support ACPI along with DT.
>
> Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>

From the ACPI side

Acked-by: Rafael J. Wysocki <rafael@kernel.org>

> ---
>
> Changes in v8:
> - adjust code over latest changes applied on the driver
>
> Changes in v7:
> - remove unnecassary checks
>
> Changes in v6:
> - use dev_fwnode()
> - remove useless else
> - replace of_device_is_available() to fwnode_device_is_available()
>
> Changes in v5:
> - replace fwnode_get_id() with OF and ACPI function calls
>
> Changes in v4: None
> Changes in v3: None
> Changes in v2:
> - Refactor OF functions to use fwnode functions
>
>  .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 88 +++++++++++--------
>  .../net/ethernet/freescale/dpaa2/dpaa2-mac.h  |  2 +-
>  2 files changed, 53 insertions(+), 37 deletions(-)
>
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> index 4dfadf2b70d6..ae6d382d8735 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> @@ -1,6 +1,9 @@
>  // SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
>  /* Copyright 2019 NXP */
>
> +#include <linux/acpi.h>
> +#include <linux/property.h>
> +
>  #include "dpaa2-eth.h"
>  #include "dpaa2-mac.h"
>
> @@ -34,39 +37,51 @@ static int phy_mode(enum dpmac_eth_if eth_if, phy_interface_t *if_mode)
>         return 0;
>  }
>
> -/* Caller must call of_node_put on the returned value */
> -static struct device_node *dpaa2_mac_get_node(u16 dpmac_id)
> +static struct fwnode_handle *dpaa2_mac_get_node(struct device *dev,
> +                                               u16 dpmac_id)
>  {
> -       struct device_node *dpmacs, *dpmac = NULL;
> -       u32 id;
> +       struct fwnode_handle *fwnode, *parent, *child  = NULL;
> +       struct device_node *dpmacs = NULL;
>         int err;
> +       u32 id;
>
> -       dpmacs = of_find_node_by_name(NULL, "dpmacs");
> -       if (!dpmacs)
> -               return NULL;
> +       fwnode = dev_fwnode(dev->parent);
> +       if (is_of_node(fwnode)) {
> +               dpmacs = of_find_node_by_name(NULL, "dpmacs");
> +               if (!dpmacs)
> +                       return NULL;
> +               parent = of_fwnode_handle(dpmacs);
> +       } else if (is_acpi_node(fwnode)) {
> +               parent = fwnode;
> +       }
>
> -       while ((dpmac = of_get_next_child(dpmacs, dpmac)) != NULL) {
> -               err = of_property_read_u32(dpmac, "reg", &id);
> +       fwnode_for_each_child_node(parent, child) {
> +               err = -EINVAL;
> +               if (is_acpi_device_node(child))
> +                       err = acpi_get_local_address(ACPI_HANDLE_FWNODE(child), &id);
> +               else if (is_of_node(child))
> +                       err = of_property_read_u32(to_of_node(child), "reg", &id);
>                 if (err)
>                         continue;
> -               if (id == dpmac_id)
> -                       break;
> -       }
>
> +               if (id == dpmac_id) {
> +                       of_node_put(dpmacs);
> +                       return child;
> +               }
> +       }
>         of_node_put(dpmacs);
> -
> -       return dpmac;
> +       return NULL;
>  }
>
> -static int dpaa2_mac_get_if_mode(struct device_node *node,
> +static int dpaa2_mac_get_if_mode(struct fwnode_handle *dpmac_node,
>                                  struct dpmac_attr attr)
>  {
>         phy_interface_t if_mode;
>         int err;
>
> -       err = of_get_phy_mode(node, &if_mode);
> -       if (!err)
> -               return if_mode;
> +       err = fwnode_get_phy_mode(dpmac_node);
> +       if (err > 0)
> +               return err;
>
>         err = phy_mode(attr.eth_if, &if_mode);
>         if (!err)
> @@ -235,26 +250,27 @@ static const struct phylink_mac_ops dpaa2_mac_phylink_ops = {
>  };
>
>  static int dpaa2_pcs_create(struct dpaa2_mac *mac,
> -                           struct device_node *dpmac_node, int id)
> +                           struct fwnode_handle *dpmac_node,
> +                           int id)
>  {
>         struct mdio_device *mdiodev;
> -       struct device_node *node;
> +       struct fwnode_handle *node;
>
> -       node = of_parse_phandle(dpmac_node, "pcs-handle", 0);
> -       if (!node) {
> +       node = fwnode_find_reference(dpmac_node, "pcs-handle", 0);
> +       if (IS_ERR(node)) {
>                 /* do not error out on old DTS files */
>                 netdev_warn(mac->net_dev, "pcs-handle node not found\n");
>                 return 0;
>         }
>
> -       if (!of_device_is_available(node)) {
> +       if (!fwnode_device_is_available(node)) {
>                 netdev_err(mac->net_dev, "pcs-handle node not available\n");
> -               of_node_put(node);
> +               fwnode_handle_put(node);
>                 return -ENODEV;
>         }
>
> -       mdiodev = of_mdio_find_device(node);
> -       of_node_put(node);
> +       mdiodev = fwnode_mdio_find_device(node);
> +       fwnode_handle_put(node);
>         if (!mdiodev)
>                 return -EPROBE_DEFER;
>
> @@ -283,13 +299,13 @@ static void dpaa2_pcs_destroy(struct dpaa2_mac *mac)
>  int dpaa2_mac_connect(struct dpaa2_mac *mac)
>  {
>         struct net_device *net_dev = mac->net_dev;
> -       struct device_node *dpmac_node;
> +       struct fwnode_handle *dpmac_node;
>         struct phylink *phylink;
>         int err;
>
>         mac->if_link_type = mac->attr.link_type;
>
> -       dpmac_node = mac->of_node;
> +       dpmac_node = mac->fw_node;
>         if (!dpmac_node) {
>                 netdev_err(net_dev, "No dpmac@%d node found.\n", mac->attr.id);
>                 return -ENODEV;
> @@ -304,7 +320,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
>          * error out if the interface mode requests them and there is no PHY
>          * to act upon them
>          */
> -       if (of_phy_is_fixed_link(dpmac_node) &&
> +       if (of_phy_is_fixed_link(to_of_node(dpmac_node)) &&
>             (mac->if_mode == PHY_INTERFACE_MODE_RGMII_ID ||
>              mac->if_mode == PHY_INTERFACE_MODE_RGMII_RXID ||
>              mac->if_mode == PHY_INTERFACE_MODE_RGMII_TXID)) {
> @@ -324,7 +340,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
>         mac->phylink_config.type = PHYLINK_NETDEV;
>
>         phylink = phylink_create(&mac->phylink_config,
> -                                of_fwnode_handle(dpmac_node), mac->if_mode,
> +                                dpmac_node, mac->if_mode,
>                                  &dpaa2_mac_phylink_ops);
>         if (IS_ERR(phylink)) {
>                 err = PTR_ERR(phylink);
> @@ -335,9 +351,9 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
>         if (mac->pcs)
>                 phylink_set_pcs(mac->phylink, &mac->pcs->pcs);
>
> -       err = phylink_of_phy_connect(mac->phylink, dpmac_node, 0);
> +       err = phylink_fwnode_phy_connect(mac->phylink, dpmac_node, 0);
>         if (err) {
> -               netdev_err(net_dev, "phylink_of_phy_connect() = %d\n", err);
> +               netdev_err(net_dev, "phylink_fwnode_phy_connect() = %d\n", err);
>                 goto err_phylink_destroy;
>         }
>
> @@ -384,8 +400,8 @@ int dpaa2_mac_open(struct dpaa2_mac *mac)
>         /* Find the device node representing the MAC device and link the device
>          * behind the associated netdev to it.
>          */
> -       mac->of_node = dpaa2_mac_get_node(mac->attr.id);
> -       net_dev->dev.of_node = mac->of_node;
> +       mac->fw_node = dpaa2_mac_get_node(&mac->mc_dev->dev, mac->attr.id);
> +       net_dev->dev.of_node = to_of_node(mac->fw_node);
>
>         return 0;
>
> @@ -399,8 +415,8 @@ void dpaa2_mac_close(struct dpaa2_mac *mac)
>         struct fsl_mc_device *dpmac_dev = mac->mc_dev;
>
>         dpmac_close(mac->mc_io, 0, dpmac_dev->mc_handle);
> -       if (mac->of_node)
> -               of_node_put(mac->of_node);
> +       if (mac->fw_node)
> +               fwnode_handle_put(mac->fw_node);
>  }
>
>  static char dpaa2_mac_ethtool_stats[][ETH_GSTRING_LEN] = {
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
> index 8ebcb3420d02..7842cbb2207a 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
> @@ -24,7 +24,7 @@ struct dpaa2_mac {
>         phy_interface_t if_mode;
>         enum dpmac_link_type if_link_type;
>         struct lynx_pcs *pcs;
> -       struct device_node *of_node;
> +       struct fwnode_handle *fw_node;
>  };
>
>  bool dpaa2_mac_is_type_fixed(struct fsl_mc_device *dpmac_dev,
> --
> 2.31.1
>
