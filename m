Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 423A53A32F3
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 20:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231189AbhFJSWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 14:22:01 -0400
Received: from mail-oi1-f173.google.com ([209.85.167.173]:36767 "EHLO
        mail-oi1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231146AbhFJSWA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 14:22:00 -0400
Received: by mail-oi1-f173.google.com with SMTP id r16so2746114oiw.3;
        Thu, 10 Jun 2021 11:20:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Uohm87Etb/rBg5mKs9nVh8ZMC92Dh4yfCsCNdezrbus=;
        b=ZuHQKMIEyYI7w7TMRtfZ+8/us9DvgD0Xhpj6ybehJtj5IT+SPvJ9JJ7EpHcBG0NXvY
         KPBVOf18zef5refUHdYd80Pw3PteB6Yg6F7poR+Xk6xf6+n8j+t5W85oGr3FfwcsUCjf
         KwqLrx8yF90ltJ27IyunrnIbOUorQSTglpw0dYmGlCTSBNU5F1Cts/jwWz+3YCoGXtsh
         qG6bYF5/OB86cYDGsRCAguZ7834JYlsl6V/RpwhjfxFlqW9CkI7V/oNSLPl24Xgb96qC
         aGSTo3mnGJzMK7R1e7lqFZIlQzcIhJD2aHDi+4/4S14V5cCMmKv27bnRfcLNu9c5Mx8M
         /tUQ==
X-Gm-Message-State: AOAM533AXNGO9RVbHrgB6HW2wryhb9/Rf4td/CDQkg1MiDAJH04xULEk
        wJn0/uPnDxfzlRyHzqkk/+Y4LuEbluQqx68JoSU=
X-Google-Smtp-Source: ABdhPJwUR0OJZ0xjx5rmH/6DM0jkwqo3UoA4jvOVwkqjp7T6sOv4W+KMIbv1LEkYGkawwOvrK5OeEn6AeWAXIHvAm7Q=
X-Received: by 2002:aca:b406:: with SMTP id d6mr4403033oif.71.1623349203445;
 Thu, 10 Jun 2021 11:20:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210610163917.4138412-1-ciorneiioana@gmail.com> <20210610163917.4138412-12-ciorneiioana@gmail.com>
In-Reply-To: <20210610163917.4138412-12-ciorneiioana@gmail.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Thu, 10 Jun 2021 20:19:52 +0200
Message-ID: <CAJZ5v0jjkzyxRD=mXkZj5DOgOaBuePwFBqzi_zJ3ZMeVW-Pk9A@mail.gmail.com>
Subject: Re: [PATCH net-next v8 11/15] net: mdio: Add ACPI support code for mdio
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
> Define acpi_mdiobus_register() to Register mii_bus and create PHYs for
> each ACPI child node.
>
> Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> ---
>
> Changes in v8: None
> Changes in v7:
> - Include headers directly used in acpi_mdio.c
>
> Changes in v6:
> - use GENMASK() and ACPI_COMPANION_SET()
> - some cleanup
> - remove unwanted header inclusion
>
> Changes in v5:
> - add missing MODULE_LICENSE()
> - replace fwnode_get_id() with OF and ACPI function calls
>
> Changes in v4: None
> Changes in v3: None
> Changes in v2: None
>
>  MAINTAINERS                  |  1 +
>  drivers/net/mdio/Kconfig     |  7 +++++
>  drivers/net/mdio/Makefile    |  1 +
>  drivers/net/mdio/acpi_mdio.c | 56 ++++++++++++++++++++++++++++++++++++
>  include/linux/acpi_mdio.h    | 26 +++++++++++++++++
>  5 files changed, 91 insertions(+)
>  create mode 100644 drivers/net/mdio/acpi_mdio.c
>  create mode 100644 include/linux/acpi_mdio.h
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index e8f8b6c33a51..2172f594be8f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6811,6 +6811,7 @@ F:        Documentation/devicetree/bindings/net/mdio*
>  F:     Documentation/devicetree/bindings/net/qca,ar803x.yaml
>  F:     Documentation/networking/phy.rst
>  F:     drivers/net/mdio/
> +F:     drivers/net/mdio/acpi_mdio.c
>  F:     drivers/net/mdio/fwnode_mdio.c
>  F:     drivers/net/mdio/of_mdio.c
>  F:     drivers/net/pcs/
> diff --git a/drivers/net/mdio/Kconfig b/drivers/net/mdio/Kconfig
> index 422e9e042a3c..99a6c13a11af 100644
> --- a/drivers/net/mdio/Kconfig
> +++ b/drivers/net/mdio/Kconfig
> @@ -34,6 +34,13 @@ config OF_MDIO
>         help
>           OpenFirmware MDIO bus (Ethernet PHY) accessors
>
> +config ACPI_MDIO
> +       def_tristate PHYLIB
> +       depends on ACPI
> +       depends on PHYLIB
> +       help
> +         ACPI MDIO bus (Ethernet PHY) accessors
> +
>  if MDIO_BUS
>
>  config MDIO_DEVRES
> diff --git a/drivers/net/mdio/Makefile b/drivers/net/mdio/Makefile
> index 2e6813c709eb..15f8dc4042ce 100644
> --- a/drivers/net/mdio/Makefile
> +++ b/drivers/net/mdio/Makefile
> @@ -1,6 +1,7 @@
>  # SPDX-License-Identifier: GPL-2.0
>  # Makefile for Linux MDIO bus drivers
>
> +obj-$(CONFIG_ACPI_MDIO)                += acpi_mdio.o
>  obj-$(CONFIG_FWNODE_MDIO)      += fwnode_mdio.o
>  obj-$(CONFIG_OF_MDIO)          += of_mdio.o
>
> diff --git a/drivers/net/mdio/acpi_mdio.c b/drivers/net/mdio/acpi_mdio.c
> new file mode 100644
> index 000000000000..60a86e3fc246
> --- /dev/null
> +++ b/drivers/net/mdio/acpi_mdio.c
> @@ -0,0 +1,56 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * ACPI helpers for the MDIO (Ethernet PHY) API
> + *
> + * This file provides helper functions for extracting PHY device information
> + * out of the ACPI ASL and using it to populate an mii_bus.
> + */
> +
> +#include <linux/acpi.h>
> +#include <linux/acpi_mdio.h>
> +#include <linux/bits.h>
> +#include <linux/dev_printk.h>
> +#include <linux/fwnode_mdio.h>
> +#include <linux/module.h>
> +#include <linux/types.h>
> +
> +MODULE_AUTHOR("Calvin Johnson <calvin.johnson@oss.nxp.com>");
> +MODULE_LICENSE("GPL");
> +
> +/**
> + * acpi_mdiobus_register - Register mii_bus and create PHYs from the ACPI ASL.
> + * @mdio: pointer to mii_bus structure
> + * @fwnode: pointer to fwnode of MDIO bus.
> + *
> + * This function registers the mii_bus structure and registers a phy_device
> + * for each child node of @fwnode.

It would be good to mention that @fwnode is expected to represent an
ACPI device object corresponding to mdiio and its children are
expected to correspond to the PHY devices on that bus (if my
understanding of this is correct, that is).

With that addressed, please feel free to add

Acked-by: Rafael J. Wysocki <rafael@kernel.org>

to this patch.

> + */
> +int acpi_mdiobus_register(struct mii_bus *mdio, struct fwnode_handle *fwnode)
> +{
> +       struct fwnode_handle *child;
> +       u32 addr;
> +       int ret;
> +
> +       /* Mask out all PHYs from auto probing. */
> +       mdio->phy_mask = GENMASK(31, 0);
> +       ret = mdiobus_register(mdio);
> +       if (ret)
> +               return ret;
> +
> +       ACPI_COMPANION_SET(&mdio->dev, to_acpi_device_node(fwnode));
> +
> +       /* Loop over the child nodes and register a phy_device for each PHY */
> +       fwnode_for_each_child_node(fwnode, child) {
> +               ret = acpi_get_local_address(ACPI_HANDLE_FWNODE(child), &addr);
> +               if (ret || addr >= PHY_MAX_ADDR)
> +                       continue;
> +
> +               ret = fwnode_mdiobus_register_phy(mdio, child, addr);
> +               if (ret == -ENODEV)
> +                       dev_err(&mdio->dev,
> +                               "MDIO device at address %d is missing.\n",
> +                               addr);
> +       }
> +       return 0;
> +}
> +EXPORT_SYMBOL(acpi_mdiobus_register);
> diff --git a/include/linux/acpi_mdio.h b/include/linux/acpi_mdio.h
> new file mode 100644
> index 000000000000..0a24ab7cb66f
> --- /dev/null
> +++ b/include/linux/acpi_mdio.h
> @@ -0,0 +1,26 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * ACPI helper for the MDIO (Ethernet PHY) API
> + */
> +
> +#ifndef __LINUX_ACPI_MDIO_H
> +#define __LINUX_ACPI_MDIO_H
> +
> +#include <linux/phy.h>
> +
> +#if IS_ENABLED(CONFIG_ACPI_MDIO)
> +int acpi_mdiobus_register(struct mii_bus *mdio, struct fwnode_handle *fwnode);
> +#else /* CONFIG_ACPI_MDIO */
> +static inline int
> +acpi_mdiobus_register(struct mii_bus *mdio, struct fwnode_handle *fwnode)
> +{
> +       /*
> +        * Fall back to mdiobus_register() function to register a bus.
> +        * This way, we don't have to keep compat bits around in drivers.
> +        */
> +
> +       return mdiobus_register(mdio);
> +}
> +#endif
> +
> +#endif /* __LINUX_ACPI_MDIO_H */
> --
> 2.31.1
>
