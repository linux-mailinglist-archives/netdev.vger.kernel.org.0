Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB7E2337217
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 13:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232952AbhCKMKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 07:10:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232919AbhCKMJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 07:09:55 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E366C061574;
        Thu, 11 Mar 2021 04:09:55 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id mz6-20020a17090b3786b02900c16cb41d63so9258823pjb.2;
        Thu, 11 Mar 2021 04:09:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Fgejs9NwV9XHSr5esguFyo9ZNJH3pXg6b5W2nj6hE9Y=;
        b=inU5Zx8EGGSu9ee0nwxvKjp/gAnj96crRgmjon+zOWjAbvJB7CIm3DlXUzlRygC/Py
         x17TbBsF4biwzm1xgY5XIRUAB9PMMg7p7SHc+J2teqQ1fotk809vKUZjQxkg8iVzGB6x
         DY8Js1w8UPPl/ENngUg1oNtfRIs24G/i64UZl+7HRNiVvMBb/bXO6xoTIw4qHd0ev+Qf
         IFq2Ovcc3rG3qOh5DeD7px0UynbpOlpQuQ4Cwyzf8g57+Wh1otNdVLzt4/yZ+QsvcVSV
         77p2IYAPDN2gsyKB4Ca9J1rOutvrW0R1gDN6b6je+Xw+xoZ2SMFlbBcowlEF1e6FKZjH
         uQpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Fgejs9NwV9XHSr5esguFyo9ZNJH3pXg6b5W2nj6hE9Y=;
        b=MtYOFd95zIy18FUJTD3DViPlkClkwIuDSS/oJV1suP1WORi7nqw3JBcvyVt2NcB7mM
         AXfP5/kDj7t1j2RdoTiD1BCniYJwbqODrYeYPWFm81NwcCZSmvFp6cO5KFNwD3c1fJXi
         wxE3Hd9RXYDpUlfKReZ98vRVpH5E+nBkqck5BpK1GZQrrFDY5sW2+qwdC2mfImgz73Fq
         TgK+HVTkQnXjHDq+bU1prXhAnVQOXRmaIfTwF0N1atNtprvC4byoCWNpx7cETI1et/5r
         to3Fu5bffAMtfOft2LvQDB3XC8/LqnAGiQbyLjPyzFh9g8+zlXdT+KAC3FPpZ6dReaeo
         mNmw==
X-Gm-Message-State: AOAM5337CSoXx50xNJuaBY7Kqw2mo7CegBhwBsf0UjzKSFkbdTpPUUTt
        Lf8doW4W8cjquBaCyNa3py1MPQqRZJTflJu++vc=
X-Google-Smtp-Source: ABdhPJwpHihmwOjDMAypNOI8HBpk366v1P70tH9iUFlgBuBvxBR5OS42lhnweZRQdWNdWm0tILL6xA21z+6UYXLUudM=
X-Received: by 2002:a17:902:c808:b029:e6:4204:f62f with SMTP id
 u8-20020a170902c808b02900e64204f62fmr7943918plx.0.1615464594250; Thu, 11 Mar
 2021 04:09:54 -0800 (PST)
MIME-Version: 1.0
References: <20210311062011.8054-1-calvin.johnson@oss.nxp.com> <20210311062011.8054-9-calvin.johnson@oss.nxp.com>
In-Reply-To: <20210311062011.8054-9-calvin.johnson@oss.nxp.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Thu, 11 Mar 2021 14:09:37 +0200
Message-ID: <CAHp75VfKoNvBxbj5tKb9NqGGbn36s=uZznm9QDBzkVWYNa=LCA@mail.gmail.com>
Subject: Re: [net-next PATCH v7 08/16] net: mdiobus: Introduce fwnode_mdiobus_register_phy()
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux.cj" <linux.cj@gmail.com>, netdev <netdev@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Frank Rowand <frowand.list@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        devicetree <devicetree@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 11, 2021 at 8:21 AM Calvin Johnson
<calvin.johnson@oss.nxp.com> wrote:
>
> Introduce fwnode_mdiobus_register_phy() to register PHYs on the
> mdiobus. From the compatible string, identify whether the PHY is
> c45 and based on this create a PHY device instance which is
> registered on the mdiobus.

> uninitialized symbol 'mii_ts'
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

I don't think it's important to have it in a history of Git. I would
move this after the cutter '---' line below.

> Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> ---
>
> Changes in v7:
> - Call unregister_mii_timestamper() without NULL check
> - Create fwnode_mdio.c and move fwnode_mdiobus_register_phy()
>
> Changes in v6:
> - Initialize mii_ts to NULL
>
> Changes in v5: None
> Changes in v4: None
> Changes in v3: None
> Changes in v2: None
>
>  MAINTAINERS                    |  1 +
>  drivers/net/mdio/Kconfig       |  9 ++++
>  drivers/net/mdio/Makefile      |  3 +-
>  drivers/net/mdio/fwnode_mdio.c | 77 ++++++++++++++++++++++++++++++++++
>  drivers/net/mdio/of_mdio.c     |  3 +-
>  include/linux/fwnode_mdio.h    | 24 +++++++++++
>  include/linux/of_mdio.h        |  6 ++-
>  7 files changed, 120 insertions(+), 3 deletions(-)
>  create mode 100644 drivers/net/mdio/fwnode_mdio.c
>  create mode 100644 include/linux/fwnode_mdio.h
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index e1fa5ad9bb30..146de41d2656 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6680,6 +6680,7 @@ F:        Documentation/devicetree/bindings/net/mdio*
>  F:     Documentation/devicetree/bindings/net/qca,ar803x.yaml
>  F:     Documentation/networking/phy.rst
>  F:     drivers/net/mdio/
> +F:     drivers/net/mdio/fwnode_mdio.c
>  F:     drivers/net/mdio/of_mdio.c
>  F:     drivers/net/pcs/
>  F:     drivers/net/phy/
> diff --git a/drivers/net/mdio/Kconfig b/drivers/net/mdio/Kconfig
> index a10cc460d7cf..2d5bf5ccffb5 100644
> --- a/drivers/net/mdio/Kconfig
> +++ b/drivers/net/mdio/Kconfig
> @@ -19,6 +19,15 @@ config MDIO_BUS
>           reflects whether the mdio_bus/mdio_device code is built as a
>           loadable module or built-in.
>
> +config FWNODE_MDIO
> +       def_tristate PHYLIB

(Seems "selectable only" item)

> +       depends on ACPI
> +       depends on OF

Wouldn't be better to have
  depends on (ACPI || OF) || COMPILE_TEST

And honestly I don't understand it in either (AND or OR) variant. Why
do you need a dependency like this for fwnode API?

Moreover dependencies don't work for "selectable only" items.

> +       depends on PHYLIB
> +       select FIXED_PHY
> +       help
> +         FWNODE MDIO bus (Ethernet PHY) accessors
> +
>  config OF_MDIO
>         def_tristate PHYLIB
>         depends on OF
> diff --git a/drivers/net/mdio/Makefile b/drivers/net/mdio/Makefile
> index 5c498dde463f..ea5390e2ef84 100644
> --- a/drivers/net/mdio/Makefile
> +++ b/drivers/net/mdio/Makefile
> @@ -1,7 +1,8 @@
>  # SPDX-License-Identifier: GPL-2.0
>  # Makefile for Linux MDIO bus drivers
>
> -obj-$(CONFIG_OF_MDIO)  += of_mdio.o
> +obj-$(CONFIG_FWNODE_MDIO)      += fwnode_mdio.o
> +obj-$(CONFIG_OF_MDIO)          += of_mdio.o
>
>  obj-$(CONFIG_MDIO_ASPEED)              += mdio-aspeed.o
>  obj-$(CONFIG_MDIO_BCM_IPROC)           += mdio-bcm-iproc.o
> diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
> new file mode 100644
> index 000000000000..0982e816a6fb
> --- /dev/null
> +++ b/drivers/net/mdio/fwnode_mdio.c
> @@ -0,0 +1,77 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * fwnode helpers for the MDIO (Ethernet PHY) API
> + *
> + * This file provides helper functions for extracting PHY device information
> + * out of the fwnode and using it to populate an mii_bus.
> + */
> +
> +#include <linux/acpi.h>
> +#include <linux/of.h>
> +#include <linux/of_mdio.h>
> +#include <linux/phy.h>
> +
> +MODULE_AUTHOR("Calvin Johnson <calvin.johnson@oss.nxp.com>");
> +MODULE_LICENSE("GPL");
> +
> +int fwnode_mdiobus_register_phy(struct mii_bus *bus,
> +                               struct fwnode_handle *child, u32 addr)
> +{
> +       struct mii_timestamper *mii_ts = NULL;
> +       struct phy_device *phy;
> +       bool is_c45 = false;
> +       u32 phy_id;
> +       int rc;
> +
> +       if (is_of_node(child)) {
> +               mii_ts = of_find_mii_timestamper(to_of_node(child));
> +               if (IS_ERR(mii_ts))
> +                       return PTR_ERR(mii_ts);
> +       }
> +
> +       rc = fwnode_property_match_string(child, "compatible", "ethernet-phy-ieee802.3-c45");
> +       if (rc >= 0)
> +               is_c45 = true;
> +
> +       if (is_c45 || fwnode_get_phy_id(child, &phy_id))
> +               phy = get_phy_device(bus, addr, is_c45);
> +       else
> +               phy = phy_device_create(bus, addr, phy_id, 0, NULL);
> +       if (IS_ERR(phy)) {
> +               unregister_mii_timestamper(mii_ts);
> +               return PTR_ERR(phy);
> +       }
> +
> +       if (is_acpi_node(child)) {
> +               phy->irq = bus->irq[addr];
> +
> +               /* Associate the fwnode with the device structure so it
> +                * can be looked up later.
> +                */
> +               phy->mdio.dev.fwnode = child;
> +
> +               /* All data is now stored in the phy struct, so register it */
> +               rc = phy_device_register(phy);
> +               if (rc) {
> +                       phy_device_free(phy);
> +                       fwnode_handle_put(phy->mdio.dev.fwnode);
> +                       return rc;
> +               }
> +       } else if (is_of_node(child)) {
> +               rc = of_mdiobus_phy_device_register(bus, phy, to_of_node(child), addr);
> +               if (rc) {
> +                       unregister_mii_timestamper(mii_ts);
> +                       phy_device_free(phy);
> +                       return rc;
> +               }
> +       }
> +
> +       /* phy->mii_ts may already be defined by the PHY driver. A
> +        * mii_timestamper probed via the device tree will still have
> +        * precedence.
> +        */
> +       if (mii_ts)
> +               phy->mii_ts = mii_ts;
> +       return 0;
> +}
> +EXPORT_SYMBOL(fwnode_mdiobus_register_phy);
> diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
> index 48b6b8458c17..db293e0b8249 100644
> --- a/drivers/net/mdio/of_mdio.c
> +++ b/drivers/net/mdio/of_mdio.c
> @@ -32,7 +32,7 @@ static int of_get_phy_id(struct device_node *device, u32 *phy_id)
>         return fwnode_get_phy_id(of_fwnode_handle(device), phy_id);
>  }
>
> -static struct mii_timestamper *of_find_mii_timestamper(struct device_node *node)
> +struct mii_timestamper *of_find_mii_timestamper(struct device_node *node)
>  {
>         struct of_phandle_args arg;
>         int err;
> @@ -49,6 +49,7 @@ static struct mii_timestamper *of_find_mii_timestamper(struct device_node *node)
>
>         return register_mii_timestamper(arg.np, arg.args[0]);
>  }
> +EXPORT_SYMBOL(of_find_mii_timestamper);
>
>  int of_mdiobus_phy_device_register(struct mii_bus *mdio, struct phy_device *phy,
>                               struct device_node *child, u32 addr)
> diff --git a/include/linux/fwnode_mdio.h b/include/linux/fwnode_mdio.h
> new file mode 100644
> index 000000000000..8c0392845916
> --- /dev/null
> +++ b/include/linux/fwnode_mdio.h
> @@ -0,0 +1,24 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * FWNODE helper for the MDIO (Ethernet PHY) API
> + */
> +
> +#ifndef __LINUX_FWNODE_MDIO_H
> +#define __LINUX_FWNODE_MDIO_H
> +
> +#include <linux/phy.h>
> +
> +#if IS_ENABLED(CONFIG_FWNODE_MDIO)
> +int fwnode_mdiobus_register_phy(struct mii_bus *bus,
> +                               struct fwnode_handle *child, u32 addr);
> +
> +#else /* CONFIG_FWNODE_MDIO */
> +static inline int fwnode_mdiobus_register_phy(struct mii_bus *bus,
> +                                             struct fwnode_handle *child,
> +                                             u32 addr)
> +{
> +       return -EINVAL;
> +}
> +#endif
> +
> +#endif /* __LINUX_FWNODE_MDIO_H */
> diff --git a/include/linux/of_mdio.h b/include/linux/of_mdio.h
> index 2b05e7f7c238..e4ee6c4d9431 100644
> --- a/include/linux/of_mdio.h
> +++ b/include/linux/of_mdio.h
> @@ -31,6 +31,7 @@ struct mii_bus *of_mdio_find_bus(struct device_node *mdio_np);
>  int of_phy_register_fixed_link(struct device_node *np);
>  void of_phy_deregister_fixed_link(struct device_node *np);
>  bool of_phy_is_fixed_link(struct device_node *np);
> +struct mii_timestamper *of_find_mii_timestamper(struct device_node *np);
>  int of_mdiobus_phy_device_register(struct mii_bus *mdio, struct phy_device *phy,
>                                    struct device_node *child, u32 addr);
>
> @@ -118,7 +119,10 @@ static inline bool of_phy_is_fixed_link(struct device_node *np)
>  {
>         return false;
>  }
> -
> +static inline struct mii_timestamper *of_find_mii_timestamper(struct device_node *np)
> +{
> +       return NULL;
> +}
>  static inline int of_mdiobus_phy_device_register(struct mii_bus *mdio,
>                                             struct phy_device *phy,
>                                             struct device_node *child, u32 addr)
> --
> 2.17.1
>


-- 
With Best Regards,
Andy Shevchenko
