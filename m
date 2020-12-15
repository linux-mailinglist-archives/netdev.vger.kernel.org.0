Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7752E2DB2BE
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 18:37:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731286AbgLORdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 12:33:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731168AbgLORdd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 12:33:33 -0500
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC316C06179C;
        Tue, 15 Dec 2020 09:32:52 -0800 (PST)
Received: by mail-pj1-x1041.google.com with SMTP id lb18so1606829pjb.5;
        Tue, 15 Dec 2020 09:32:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JmNn0//oaLoQtXbQqzmlMo9udtSlRUFo6HHy4TKL3+8=;
        b=JntupVMH82oBE+fE8rEsYTLlRkEpnlGdWeHpkbiiZvaHVfsvnxXxqOqNrSrFg6sxGe
         /s67n7ViJY3ypKM+yVvjf2hllczGAtQjvGtJKDCsUXcXzUt9Y+q0YZ8JdDERwQOvHEiT
         326LhPVkJ866TMII+M1YjRVlL4fWAbI41T4+bg+lQhQKQjCFOEUilQo7c4iOBdt8ZfTW
         LvhFfLAIILSO/bJ2u6qcfGCLNj4CbDn6N+FMTKZJp7gqGZARoocft5TR6QhXwcv9n2gq
         ypT0CdZMvwtkkUDeFj+L/QK7klkTWjdyLm9ktlagOQ0XtQJTn7jR+YwxF37Cq/rai8LS
         4Vrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JmNn0//oaLoQtXbQqzmlMo9udtSlRUFo6HHy4TKL3+8=;
        b=HgOB/D+4JDtey+NEySHpqtRgxc/VLvY7k1eQDzx7jRM5zHKq/RH9ua2H3qmjwF0dLm
         9+zKnDD94k1EksvFVVh765ysGrh8n0sBaFsKl6x4rungUF5bqRjmi4ClK5Om8WZvFa8A
         wteCvq/p5QYS2gfEs/xoZhq/bKdQmoJ5RfwA/Z8LqHW64AClpayrbj0XsE9+gveHHjYZ
         Vbzc2GrIMGcJaYOPPL8BYV2q9602ylECj3VTpt4mXEsFrwi8Ndo6SFLr43H2IhJxW68A
         aLSxu0Tg0j/LjEmXJgsE/kNbJXWUh1JJPKne92JkrrT0Mk+QB+jPg21v5lgl8NwWzpNn
         A+8w==
X-Gm-Message-State: AOAM532EAgRz2FZDLiIy7rXwq8Hjrf9rIrQXWp2WJ4alwdsZa4LjA8Yb
        F+ugo6RJK+2aJG4THZ9segF4Ve6kIC2KHaW6KSE=
X-Google-Smtp-Source: ABdhPJw/U+RUVN+i+bo86WULer/5hlu3yA0lLBg6tsySkVSqhulPLUiQFtJayzVeGmCr0YIAAX1Hl5/+qbjWZ7j++oQ=
X-Received: by 2002:a17:90a:c592:: with SMTP id l18mr31179251pjt.228.1608053572361;
 Tue, 15 Dec 2020 09:32:52 -0800 (PST)
MIME-Version: 1.0
References: <20201215164315.3666-1-calvin.johnson@oss.nxp.com> <20201215164315.3666-7-calvin.johnson@oss.nxp.com>
In-Reply-To: <20201215164315.3666-7-calvin.johnson@oss.nxp.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 15 Dec 2020 19:33:40 +0200
Message-ID: <CAHp75VcY2uOirAXGv5kFvHbNfHcZ6-gPsUMTB-_5AuBkHdu-0A@mail.gmail.com>
Subject: Re: [net-next PATCH v2 06/14] net: mdiobus: Introduce fwnode_mdiobus_register_phy()
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
> Introduce fwnode_mdiobus_register_phy() to register PHYs on the
> mdiobus. From the compatible string, identify whether the PHY is
> c45 and based on this create a PHY device instance which is
> registered on the mdiobus.

...

> +int fwnode_mdiobus_register_phy(struct mii_bus *bus,
> +                               struct fwnode_handle *child, u32 addr)
> +{
> +       struct mii_timestamper *mii_ts;
> +       struct phy_device *phy;
> +       const char *cp;
> +       bool is_c45;
> +       u32 phy_id;
> +       int rc;

> +       if (is_of_node(child)) {
> +               mii_ts = of_find_mii_timestamper(to_of_node(child));
> +               if (IS_ERR(mii_ts))
> +                       return PTR_ERR(mii_ts);
> +       }

Perhaps

               mii_ts = of_find_mii_timestamper(to_of_node(child));

> +
> +       rc = fwnode_property_read_string(child, "compatible", &cp);
> +       is_c45 = !(rc || strcmp(cp, "ethernet-phy-ieee802.3-c45"));
> +
> +       if (is_c45 || fwnode_get_phy_id(child, &phy_id))
> +               phy = get_phy_device(bus, addr, is_c45);
> +       else
> +               phy = phy_device_create(bus, addr, phy_id, 0, NULL);
> +       if (IS_ERR(phy)) {

> +               if (mii_ts && is_of_node(child))
> +                       unregister_mii_timestamper(mii_ts);

if (!IS_ERR_OR_NULL(mii_ts))
 ...

However it points to the question why unregister() doesn't handle the
above cases.
I would expect unconditional call to unregister() here.

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
> +
> +               dev_dbg(&bus->dev, "registered phy at address %i\n", addr);
> +       } else if (is_of_node(child)) {
> +               rc = of_mdiobus_phy_device_register(bus, phy, to_of_node(child), addr);
> +               if (rc) {

> +                       if (mii_ts)
> +                               unregister_mii_timestamper(mii_ts);

Ditto.

> +                       phy_device_free(phy);
> +                       return rc;
> +               }
> +
> +               /* phy->mii_ts may already be defined by the PHY driver. A
> +                * mii_timestamper probed via the device tree will still have
> +                * precedence.
> +                */

> +               if (mii_ts)
> +                       phy->mii_ts = mii_ts;

How is that defined? Do you need to do something with an old pointer?

> +       }
> +       return 0;
> +}

-- 
With Best Regards,
Andy Shevchenko
