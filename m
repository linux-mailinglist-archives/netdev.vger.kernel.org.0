Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9ED8337236
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 13:15:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233030AbhCKMPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 07:15:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232912AbhCKMOy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 07:14:54 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20A85C061574;
        Thu, 11 Mar 2021 04:14:54 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id bt4so3373342pjb.5;
        Thu, 11 Mar 2021 04:14:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W3eIr7G6gKn2AUO8oRDytYNMU3Kbx5BTjDGWEWAk2yk=;
        b=MY9Kw7kO61zaFCKakmSwfxtI42skpfQRZoDLZ8LLoKW1KOkXoqNUu7q4DrOHH3oHzA
         kFxoeATmjQAd4OZY0yUvWGiqcezlKrkFtrWiyeDUpzHhKHK3p6d9zV9PORuYEd+LvGZD
         lNPkvBxR0vM1bCEbrjViXqU+X7k4ZANrFvg44r66kmtDSFLM5ykuj0lraKwNb1H0/XqM
         +22qNbp1j3MB5DLLj4CWtwf1Xa9yHwibCMVr+OKfznLqxvcAjwFIEtEtrlsGQsVuulUe
         rNsUWhWOpNRvR9RZaS4SfQIkAhYvQE8sIgC/aZozRlvUQ8/QuqG++j28Tb9SsH8neGmG
         5y/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W3eIr7G6gKn2AUO8oRDytYNMU3Kbx5BTjDGWEWAk2yk=;
        b=MZvWbXWjxRNXfoCjZzKLe/toCw7p4sa2wc8fq7N3J/Pk8tlovH/BqAjzmTpTE7ap1O
         kLvs7xFCApG5gvZaCOJWE6RlJucPKex3SyG209NjyVpOvK2ay1njunqqLwj6pxOKuIxK
         nyLtzh4wW+73DNzkk/0x7c2dEKg4HhkKMRuN/DoTRVB4EFK2hCU4mvNFe2QNKtk6KpRy
         1zNs81fDjO+oHBBdrRSZkm9HSk1g+p9hUjWMY0SaLSIgramzQ/+DNiTexspAHwJMmhxW
         LY/X/VQVkluiEgre0zbhC1BkiXyNyIcFWqO8N021aDnsCVUvgKrv/U0Q8IM8G3a7yIz5
         UFaw==
X-Gm-Message-State: AOAM531TZCU/Ti5DOC+sDHi/+wp8MzhPfke4++9PF0umPqA1QPTgABCB
        l8g0U27iy4LYpctl8kRW5otZSbpEUQST6IEjATM=
X-Google-Smtp-Source: ABdhPJwIOTgpiMOskUx83n5/FxNMwXWnll1qmUAvBzDYz23FJ3Cc2kvM5DGugk9LXcwF1NqQX3ndwp9ncR4Lj1ldNA0=
X-Received: by 2002:a17:902:bf0c:b029:e6:2875:aa60 with SMTP id
 bi12-20020a170902bf0cb02900e62875aa60mr7782772plb.17.1615464893431; Thu, 11
 Mar 2021 04:14:53 -0800 (PST)
MIME-Version: 1.0
References: <20210311062011.8054-1-calvin.johnson@oss.nxp.com> <20210311062011.8054-12-calvin.johnson@oss.nxp.com>
In-Reply-To: <20210311062011.8054-12-calvin.johnson@oss.nxp.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Thu, 11 Mar 2021 14:14:37 +0200
Message-ID: <CAHp75VcDzMGgQDWeqR7hxnHXmfobR-CbwcmuMoE57ZMwvNQQ3Q@mail.gmail.com>
Subject: Re: [net-next PATCH v7 11/16] net: mdio: Add ACPI support code for mdio
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
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 11, 2021 at 8:22 AM Calvin Johnson
<calvin.johnson@oss.nxp.com> wrote:
>
> Define acpi_mdiobus_register() to Register mii_bus and create PHYs for
> each ACPI child node.
>
> Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> ---
>
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
>  include/linux/acpi_mdio.h    | 25 ++++++++++++++++
>  5 files changed, 90 insertions(+)
>  create mode 100644 drivers/net/mdio/acpi_mdio.c
>  create mode 100644 include/linux/acpi_mdio.h
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 146de41d2656..051377b7fa94 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6680,6 +6680,7 @@ F:        Documentation/devicetree/bindings/net/mdio*
>  F:     Documentation/devicetree/bindings/net/qca,ar803x.yaml
>  F:     Documentation/networking/phy.rst
>  F:     drivers/net/mdio/
> +F:     drivers/net/mdio/acpi_mdio.c
>  F:     drivers/net/mdio/fwnode_mdio.c
>  F:     drivers/net/mdio/of_mdio.c
>  F:     drivers/net/pcs/
> diff --git a/drivers/net/mdio/Kconfig b/drivers/net/mdio/Kconfig
> index 2d5bf5ccffb5..fc8c787b448f 100644
> --- a/drivers/net/mdio/Kconfig
> +++ b/drivers/net/mdio/Kconfig
> @@ -36,6 +36,13 @@ config OF_MDIO
>         help
>           OpenFirmware MDIO bus (Ethernet PHY) accessors
>
> +config ACPI_MDIO
> +       def_tristate PHYLIB

> +       depends on ACPI
> +       depends on PHYLIB

Same issue, they are no-ops.

I guess you have to surround OF and ACPI and FWNODE variants by

if PHYLIB
...
endif

This will be an equivalent to depends on PHYLIB

and put this into Makefile

ifneq ($(CONFIG_ACPI),)
obj-$(CONFIG_PHYLIB) += acpi_mdio.o
endif

This will give you the rest, i.e. default PHYLIB + depends on ACPI

Similar for OF

> +       help
> +         ACPI MDIO bus (Ethernet PHY) accessors
> +
>  if MDIO_BUS
>
>  config MDIO_DEVRES
> diff --git a/drivers/net/mdio/Makefile b/drivers/net/mdio/Makefile
> index ea5390e2ef84..e8b739a3df1c 100644
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
> index 000000000000..748d261fe2f9
> --- /dev/null
> +++ b/include/linux/acpi_mdio.h
> @@ -0,0 +1,25 @@
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
> +static inline int acpi_mdiobus_register(struct mii_bus *mdio, struct fwnode_handle *fwnode)
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
> 2.17.1
>


-- 
With Best Regards,
Andy Shevchenko
