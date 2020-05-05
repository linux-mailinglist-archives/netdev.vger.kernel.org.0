Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45F381C591B
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 16:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730619AbgEEOWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 10:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730616AbgEEOWH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 10:22:07 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A521AC061A0F;
        Tue,  5 May 2020 07:22:07 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id b8so1072278pgi.11;
        Tue, 05 May 2020 07:22:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DGtEu1KsY1dr41QJrz50PNo/qEe9hhqV40ULoK/JQEY=;
        b=fppBqTIEYFEQOtLCh6kQJwvY3nR8D9p8ij1Nzx+hThzSI07ASyz3kBNezKy+tic7KP
         Zsf+wOm64CalAwkvMC2Mn9o9GRINg584C08ghOx8sZ4R8wGd/azhLscwrtMcgP/mYDnB
         ZgRFeECtreW8oFOaEZr6Qg21KCWVxM01TVWPcQxJ2DMZ9UR37Nzdv0e41hgJ0k7F79h8
         2JYbgfr495aRcvDK02NYDBI3LfbGcvRNNJN+672pBDjqas9b7zmCfil/XJjjqPYnS0P7
         sIoQmrXY0ZceG8GEVLvJ9Y3oGMXtLSJXeRx2/ukitX0em9Qy7H+YEvjg3qurclkmeY3s
         xjnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DGtEu1KsY1dr41QJrz50PNo/qEe9hhqV40ULoK/JQEY=;
        b=r4QbKiuehOirAHmkQXQ9+tylWtr3Hanltq1D8hA0eP7+WTUmIMWi8mq9pHgE+HmzMu
         JinNsrox4nMxR+Z6OvnSaaEZZ/sZ/BiVTfoNlO3ofiPJ9OKLrrWrsGEKQCaZKFYR/BEX
         TijO9TswO0CNGBBRxrTxPa6/bd3y/E32q5y3HurziAfIuKC8V4+j608C8PlfI45TQIYX
         1LQCU1E73fSpkyn5++mF7MaPd6Ym7LO6FuG1fdIc88ZaCdJpmW0izyTg6gBJ9KjaTRHf
         37GjCFttVhTbJIiJWUjGY9sO9FED/QKRvc+2DUxREyEGnI5wWbYIYzAxcZBApT4ldSmm
         CurQ==
X-Gm-Message-State: AGi0PublH/Gc2piZWPhx7oErDGWNGwdyQFs9Zo5gH9jMPlmKmYTNFhqq
        cHAfJs1WGZSH8UKaLtrSPHIxIyeySjkEfb2uUgI=
X-Google-Smtp-Source: APiQypIUZH8pTQ1mbnyQiBF+62SPk1HAQJexRMaWRWP7pjcZ9uW5NVk9E1Cq2JTRPBaIyTEIMjg4XAmxWxh6LToXh94=
X-Received: by 2002:a65:6251:: with SMTP id q17mr3052332pgv.4.1588688527041;
 Tue, 05 May 2020 07:22:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200505132905.10276-1-calvin.johnson@oss.nxp.com> <20200505132905.10276-6-calvin.johnson@oss.nxp.com>
In-Reply-To: <20200505132905.10276-6-calvin.johnson@oss.nxp.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 5 May 2020 17:22:00 +0300
Message-ID: <CAHp75VfOcQiACsOcfWyJSP1dzdYpaCa-_KKf==4YCkaM_Wk3Tg@mail.gmail.com>
Subject: Re: [net-next PATCH v3 5/5] net: mdiobus: Introduce fwnode_mdiobus_register_phy()
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     "Rafael J . Wysocki" <rafael@kernel.org>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        linux.cj@gmail.com, Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Varun Sethi <V.Sethi@nxp.com>,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        netdev <netdev@vger.kernel.org>, Marcin Wojtas <mw@semihalf.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 5, 2020 at 4:30 PM Calvin Johnson
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
> +       struct phy_device *phy;

> +       bool is_c45 = false;

Redundant assignment, see below.

> +       const char *cp;
> +       u32 phy_id;
> +       int rc;
> +

> +       fwnode_property_read_string(child, "compatible", &cp);

Consider rc = ...; otherwise you will have UB below.

> +       if (!strcmp(cp, "ethernet-phy-ieee802.3-c45"))

UB!

> +               is_c45 = true;

is_c45 = !(rc || strcmp(...));

> +       if (!is_c45 && !fwnode_get_phy_id(child, &phy_id))

Perhaps positive conditional

if (is_c45 || fwnode_...(...))
  get_phy_device();
else
  ...

> +               phy = phy_device_create(bus, addr, phy_id, 0, NULL);
> +       else
> +               phy = get_phy_device(bus, addr, is_c45);
> +       if (IS_ERR(phy))
> +               return PTR_ERR(phy);
> +
> +       phy->irq = bus->irq[addr];
> +
> +       /* Associate the fwnode with the device structure so it
> +        * can be looked up later.
> +        */
> +       phy->mdio.dev.fwnode = child;
> +
> +       /* All data is now stored in the phy struct, so register it */
> +       rc = phy_device_register(phy);
> +       if (rc) {
> +               phy_device_free(phy);

> +               fwnode_handle_put(child);

Shouldn't mdio.dev.fwnode be put rather than child (yes, I see the assignment)

> +               return rc;
> +       }
> +
> +       dev_dbg(&bus->dev, "registered phy at address %i\n", addr);
> +
> +       return 0;
> +}

-- 
With Best Regards,
Andy Shevchenko
