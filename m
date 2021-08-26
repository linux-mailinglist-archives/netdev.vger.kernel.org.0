Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF673F9109
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 01:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243823AbhHZXqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 19:46:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234234AbhHZXqX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 19:46:23 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 512E7C0613CF
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 16:45:35 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id r4so9136915ybp.4
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 16:45:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9fdkKBUGl01Q5ysFzMSm+4+TBF7Tm331OpzjnKaBdos=;
        b=hT52B5VK3P7s25HYCG6F7LC+rm6WDgBdytLlUkPhTLHpH7M4kb/yIEDQtLbNiZpdtq
         15lvEzZH/ujIRCvZefW41aM9KITdpVw7/u3OSzaQ0w5vOwvGNlPZr1tFjO0al+hGm4+x
         3k73grBFqzajNdUfaY7Zjx1S//GbYbKpUxDb4b9PpU333fVsgyHUHXQi+R0SqkC7VtMb
         Q1dJcaMez9Lp58pzEw83RhrXPEiZj3EbcdeVwVLjgTjX7OLNyE1gcyfvqk8m5ko8s/Os
         AGOfNqUPzb/mSVO0Y/R8LPOdsAc0SgTdo80vLWiF+az9giBf5MCuL5lfOVMbIubYqMoN
         8+FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9fdkKBUGl01Q5ysFzMSm+4+TBF7Tm331OpzjnKaBdos=;
        b=ufpTM9aum631ScsEdHMylWYIEU9g+GKS3lxhiVQPLtXp7wzKSX8DkHa8MTkQ6BfltJ
         CaE6Q6FNlaMKW17yVz7UwpLuc+5vW2oCWebBqHSnnh+Q12ZRi6wcPJng15TM3T/3QYLI
         WeT5wTO9B4W/aA7KoXA+giCYcnqwLrY1SADEZs/BLi+/kYA+FVh+v8rXsV6BUJS9RMnc
         MddI4iwFxGFGN1GqGbUwIX0+Fl4HI6UGQfAXsTKLRtyKSRrNDGWE/NSbnm/yF09uDPos
         ZVlz12PD3RdA8VcX3CfzbGxL0qP1y2/qR6n/8ecqekxcg8KE3qe8wjeGvsRFNFEMzs5l
         Aj9Q==
X-Gm-Message-State: AOAM533GWWWw75STpGplyaDPiGsEqd4nstTnjgqhPHJ5xIza/fjOTIew
        IHj+yinYHV5cLScLFOYl8C0lDXKXnR2SHcwCVeDFsg==
X-Google-Smtp-Source: ABdhPJxNfX9XwZaJX2ECVXfhsuNmkCZO54nNcdTXUGAuK+btk0oWS/AycCXg7TrEMb/SQ7mneqv3lgb+e+lsQf7KgqQ=
X-Received: by 2002:a25:bdc6:: with SMTP id g6mr1542288ybk.310.1630021534162;
 Thu, 26 Aug 2021 16:45:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210826074526.825517-1-saravanak@google.com> <20210826074526.825517-2-saravanak@google.com>
 <YSeTdb6DbHbBYabN@lunn.ch> <CAGETcx-pSi60NtMM=59cve8kN9ff9fgepQ5R=uJ3Gynzh=0_BA@mail.gmail.com>
 <YSf/Mps9E77/6kZX@lunn.ch>
In-Reply-To: <YSf/Mps9E77/6kZX@lunn.ch>
From:   Saravana Kannan <saravanak@google.com>
Date:   Thu, 26 Aug 2021 16:44:58 -0700
Message-ID: <CAGETcx_h6moWbS7m4hPm6Ub3T0tWayUQkppjevkYyiA=8AmACw@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] driver core: fw_devlink: Add support for FWNODE_FLAG_BROKEN_PARENT
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        Alvin Sipraga <ALSI@bang-olufsen.dk>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 26, 2021 at 1:53 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > The  DT node in [2] is probed by realtek_smi_probe() [3]. The call flow is:
> > realtek_smi_probe()
> >   -> dsa_register_switch()
> >     -> dsa_switch_probe()
> >       -> dsa_tree_setup()
> >         -> dsa_tree_setup_switches()
> >           -> dsa_switch_setup()
> >             -> ds->ops->setup(ds)
> >               -> rtl8366rb_setup()
> >                 -> realtek_smi_setup_mdio()
> >                   -> of_mdiobus_register()
> >                      This scans the MDIO bus/DT and device_add()s the PHYs
> >           -> dsa_port_setup()
> >             -> dsa_port_link_register_of()
> >               -> dsa_port_phylink_register()
> >                 -> phylink_of_phy_connect()
> >                   -> phylink_fwnode_phy_connect()
> >                     -> phy_attach_direct()
> >                        This checks if PHY device has already probed (by
> >                        checking for dev->driver). If not, it forces the
> >                        probe of the PHY using one of the generic PHY
> >                        drivers.
> >
> > So within dsa_register_switch() the PHY device is added and then
> > expected to have probed in the same thread/calling context. As stated
> > earlier, this is not guaranteed by the driver core.
>
> Have you looked at:
>
> commit 16983507742cbcaa5592af530872a82e82fb9c51
> Author: Heiner Kallweit <hkallweit1@gmail.com>
> Date:   Fri Mar 27 01:00:22 2020 +0100
>
>     net: phy: probe PHY drivers synchronously
>
> See the full commit message, but the code change is:
>
> iff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 3b8f6b0b47b5..d543df282365 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -2577,6 +2577,7 @@ int phy_driver_register(struct phy_driver *new_driver, struct module *owner)
>         new_driver->mdiodrv.driver.probe = phy_probe;
>         new_driver->mdiodrv.driver.remove = phy_remove;
>         new_driver->mdiodrv.driver.owner = owner;
> +       new_driver->mdiodrv.driver.probe_type = PROBE_FORCE_SYNCHRONOUS;
>
>         retval = driver_register(&new_driver->mdiodrv.driver);
>         if (retval) {
>
> How does this add to the overall picture?

Doesn't add much to the discussion. In the example I gave, the driver
already does synchronous probing. If the device can't probe
successfully because a supplier isn't ready, it doesn't matter if it's
a synchronous probe. The probe would still be deferred and we'll hit
the same issue. Even in the situation the commit [5] describes, if
parallelized probing is done and the PHY depended on something (say a
clock), you'd still end up not probing the PHY even if the driver is
present and the generic PHY would end up force probing it.

[5] - https://lore.kernel.org/netdev/612b81d5-c4c1-5e20-a667-893eeeef0bf5@gmail.com/

-Saravana
