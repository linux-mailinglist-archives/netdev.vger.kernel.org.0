Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B15802DB30B
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 18:55:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730449AbgLORxg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 12:53:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729584AbgLORxS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 12:53:18 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 437E2C06179C;
        Tue, 15 Dec 2020 09:52:38 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id c22so299551pgg.13;
        Tue, 15 Dec 2020 09:52:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mkDN3OhG3zHdAnqKmxuoGLzOmpvtxuJkY47LUS1oics=;
        b=LvnEcb4Ed6FsrS9J7UIvbGKW9E1moNmJZl8FcXlzJm7XILWLwfsOWyR+BtEefBLXil
         AOrK72cRwPvj007XWHoyeuzGmGfbn04Y3zwTWDdueyCfY4dkpbePe9TrOi2C9PVUsRlY
         +dVUCcT0Ykx5PRrO4Y+DnMyH69mTIUa7ZYeQWOZmj0qBDykLyalroL7Sq5zQwPdac+CA
         mHBYuFSrjbcKKs7XuoHGfgUivqQv9ZC7JEYgSUX8kNqkQPejzyA2aJAMCEEN02NZnDuz
         Z0ANzdcBTVCJzGtcc28B9b2SNUjFrsg0IcA4hNKHrtPQgKIBj1Nj1aMVtJCYt9LlyoA+
         5VuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mkDN3OhG3zHdAnqKmxuoGLzOmpvtxuJkY47LUS1oics=;
        b=MoZj0NltX6PPm8r0vkC48Q0Sc8ep5W2lQBLa6BFXfd8jSMlQ89IpMek0qvv/sYF3oY
         syDRsN+OwAvyKhwvtU8dZ8v4CXXfGvDA7SdlfJS+EC1F8yoVo5fcejC3uzX2YS3m6PsY
         4zrLAvEPSBXyNK00Q4fULXH+S4suMWD/qndf2bBjxI6i0lQZNiobzwwwQiqtdETq2lvg
         uYYfaJUso1+kBfp1X0q6f/jDt3wNBz7mkLYjzl7UQ0ERpIZBQtn+qp280+gzg8qG4Rsm
         3931A8BraS2dRq4lCFkqFgXAAeo9yjPGxjfzt9A/p9Cn37GLcGxw1/8mNRvtXxLDCc8c
         TsUQ==
X-Gm-Message-State: AOAM530kkFm0ap8Er7rfB0c4GymvtZsq24KkyG9/SlZakkth1TJrbOBc
        xww00dcly+BXgiWZygB2nQYVmSilOA+sTb2xoEs=
X-Google-Smtp-Source: ABdhPJwIdEFUP+WJMxPu4F840DYWkR5bZ89GYBArqV8XOJl/TwcyZMgjTqBY9eF7d8NxOsFHOgKyWQHorldsdoQR9Qw=
X-Received: by 2002:a63:b1e:: with SMTP id 30mr30019652pgl.203.1608054757866;
 Tue, 15 Dec 2020 09:52:37 -0800 (PST)
MIME-Version: 1.0
References: <20201215164315.3666-1-calvin.johnson@oss.nxp.com> <20201215164315.3666-9-calvin.johnson@oss.nxp.com>
In-Reply-To: <20201215164315.3666-9-calvin.johnson@oss.nxp.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 15 Dec 2020 19:53:26 +0200
Message-ID: <CAHp75Vf69NuxqcJntQi+CT1QN4cpdr2LYNzo6=t-pBWcWgufPA@mail.gmail.com>
Subject: Re: [net-next PATCH v2 08/14] net: mdiobus: Introduce fwnode_mdiobus_register()
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
        Jon <jon@solid-run.com>, "linux.cj" <linux.cj@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 15, 2020 at 6:44 PM Calvin Johnson
<calvin.johnson@oss.nxp.com> wrote:
>
> Introduce fwnode_mdiobus_register() to register PHYs on the  mdiobus.
> If the fwnode is DT node, then call of_mdiobus_register().
> If it is an ACPI node, then:
>         - disable auto probing of mdiobus
>         - register mdiobus
>         - save fwnode to mdio structure
>         - loop over child nodes & register a phy_device for each PHY

...

> +/**
> + * fwnode_mdiobus_register - Register mii_bus and create PHYs from fwnode
> + * @mdio: pointer to mii_bus structure
> + * @fwnode: pointer to fwnode of MDIO bus.
> + *
> + * This function registers the mii_bus structure and registers a phy_device
> + * for each child node of @fwnode.
> + */
> +int fwnode_mdiobus_register(struct mii_bus *mdio, struct fwnode_handle *fwnode)
> +{
> +       struct fwnode_handle *child;
> +       unsigned long long addr;
> +       acpi_status status;
> +       int ret;
> +
> +       if (is_of_node(fwnode)) {
> +               return of_mdiobus_register(mdio, to_of_node(fwnode));
> +       } else if (is_acpi_node(fwnode)) {

I would rather see this as simple as

     if (is_of_node(fwnode))
               return of_mdiobus_register(mdio, to_of_node(fwnode));
     if (is_acpi_node(fwnode))
               return acpi_mdiobus_register(mdio, fwnode);

where the latter one is defined somewhere in drivers/acpi/.

> +               /* Mask out all PHYs from auto probing. */
> +               mdio->phy_mask = ~0;
> +               ret = mdiobus_register(mdio);
> +               if (ret)
> +                       return ret;
> +
> +               mdio->dev.fwnode = fwnode;
> +       /* Loop over the child nodes and register a phy_device for each PHY */
> +               fwnode_for_each_child_node(fwnode, child) {

> +                       status = acpi_evaluate_integer(ACPI_HANDLE_FWNODE(child),
> +                                                      "_ADR", NULL, &addr);
> +                       if (ACPI_FAILURE(status)) {

Isn't it fwnode_get_id() now?

> +                               pr_debug("_ADR returned %d\n", status);
> +                               continue;
> +                       }

> +                       if (addr < 0 || addr >= PHY_MAX_ADDR)
> +                               continue;

addr can't be less than 0.

> +                       ret = fwnode_mdiobus_register_phy(mdio, child, addr);
> +                       if (ret == -ENODEV)
> +                               dev_err(&mdio->dev,
> +                                       "MDIO device at address %lld is missing.\n",
> +                                       addr);
> +               }
> +               return 0;
> +       }
> +       return -EINVAL;
> +}

-- 
With Best Regards,
Andy Shevchenko
