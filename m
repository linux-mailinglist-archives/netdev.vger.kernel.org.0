Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE1D04043EB
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 05:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350027AbhIIDWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 23:22:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348278AbhIIDWw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 23:22:52 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97EF3C06175F
        for <netdev@vger.kernel.org>; Wed,  8 Sep 2021 20:21:43 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id v17so1008843ybs.9
        for <netdev@vger.kernel.org>; Wed, 08 Sep 2021 20:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8YnZyCULGnqcZd0fLrlyeK4rzSs6AhptWvt67dnLDT8=;
        b=YghGId8sKz4u5VkN8b0Ru7l49uiXYSclofN0tSz2CVJ41CzsBMqpD8O0aaOh2mAlJ1
         1tUcploRDxNoTlW7WxKuUxcmK8yGZdwkZcKkL/LixzPT37jXAMYJqE/f6C5MvMlPceFI
         GgFCgofxNXqNkHuthxEB2mfXkIJwS+Ej7t9Bzo47iiGXbCHOWX2lXyIpQyyJP85bsiJe
         ghvbcCJKlHJ7QSBEoc0n446ZcCM3jBguFrh6UbZQSmTAV5DHXrPr0PnQPw1974jCYNxm
         OZHgLizPMo8rlfN+WHBCmvDci0icEBCwK6RyCmnRto/I1u672ykmt44mwXlPVP+/8p0j
         DQEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8YnZyCULGnqcZd0fLrlyeK4rzSs6AhptWvt67dnLDT8=;
        b=KxQw7+nPB5Hhx1erhVLxOD/518F3WcsjlIds7zwhvPojqV6tqul/j8tuKARdFWWH9l
         sP9hKmEkakcAHi4cuPF+tWAVZ8hiS7KJr6zD+W0Di1jmu6vJMSl72WZcNTsreV6Gqgf8
         Xr0iJpo6KRZju0ixuwB2sXl+CD4o7Ln+YzWfaiuyfvmAC+BxqDg2IZj+16tlJ5Hph7eu
         ZydQNUBxWDrF+ng3GCEDii3iI0HfgcocPiQ3MhFpwJsDiSIY+U5d3BhUHmLi5CbxIbYm
         oVSDINGwyyzRyVoNP2lzdgS7uCLzcUjbgYvaYCzQAgJ+POmIjbYjlahFiy1axgD7lAqj
         zJvg==
X-Gm-Message-State: AOAM532fuh34VCy+GJcVNzTkZgA8nt90xeX/JSGoryp1WWHEU2QMEK1o
        yIJ5o/+Af/DV75HAMbE0GRHHJw1tJMROJYXbWr91Ow==
X-Google-Smtp-Source: ABdhPJzsSAE/wB59k3dycIIkaVTSfZ6g8qit5UoN40NMbycJuW1AasAwrrJI0bB3PIkyGRgRNz4iXz2pcp+Ovj+IB9o=
X-Received: by 2002:a25:e0d4:: with SMTP id x203mr868719ybg.391.1631157701709;
 Wed, 08 Sep 2021 20:21:41 -0700 (PDT)
MIME-Version: 1.0
References: <YSf/Mps9E77/6kZX@lunn.ch> <CAGETcx_h6moWbS7m4hPm6Ub3T0tWayUQkppjevkYyiA=8AmACw@mail.gmail.com>
 <YSg+dRPSX9/ph6tb@lunn.ch> <CAGETcx_r8LSxV5=GQ-1qPjh7qGbCqTsSoSkQfxAKL5q+znRoWg@mail.gmail.com>
 <YSjsQmx8l4MXNvP+@lunn.ch> <CAGETcx_vMNZbT-5vCAvvpQNMMHy-19oR-mSfrg6=eSO49vLScQ@mail.gmail.com>
 <YSlG4XRGrq5D1/WU@lunn.ch> <CAGETcx-ZvENq8tFZ9wb_BCPZabpZcqPrguY5rsg4fSNdOAB+Kw@mail.gmail.com>
 <YSpr/BOZj2PKoC8B@lunn.ch> <CAGETcx_mjY10WzaOvb=vuojbodK7pvY1srvKmimu4h6xWkeQuQ@mail.gmail.com>
 <YTll0i6Rz3WAAYzs@lunn.ch>
In-Reply-To: <YTll0i6Rz3WAAYzs@lunn.ch>
From:   Saravana Kannan <saravanak@google.com>
Date:   Wed, 8 Sep 2021 20:21:05 -0700
Message-ID: <CAGETcx_U--ayNCo2GH1-EuzuD9usywjQm+B57X_YwFOjA3e+3Q@mail.gmail.com>
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

On Wed, Sep 8, 2021 at 6:39 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > --- a/net/dsa/dsa2.c
> > +++ b/net/dsa/dsa2.c
> > @@ -1286,6 +1286,17 @@ static int dsa_switch_parse_of(struct
> > dsa_switch *ds, struct device_node *dn)
> >  {
> >         int err;
> >
> > +       /* A lot of switch devices have their PHYs as child devices and have
> > +        * the PHYs depend on the switch as a supplier (Eg: interrupt
> > +        * controller). With fw_devlink=on, that means the PHYs will defer
> > +        * probe until the probe() of the switch completes. However, the way
> > +        * the DSA framework is designed, the PHYs are expected to be probed
> > +        * successfully before the probe() of the switch completes.
> > +        *
> > +        * So, mark the switch devices as a "broken parent" so that fw_devlink
> > +        * knows not to create device links between PHYs and the parent switch.
> > +        */
> > +       np->fwnode.flags |= FWNODE_FLAG_BROKEN_PARENT;
> >         err = dsa_switch_parse_member_of(ds, dn);
> >         if (err)
> >                 return err;
>
> This does not work. First off, its dn, not np.

My bad. Copy paste error.

> But with that fixed, it
> still does not work. This is too late, the mdio busses have already
> been registered and probed, the PHYs have been found on the busses,
> and the PHYs would of been probed, if not for fw_devlink.

Sigh... looks like some drivers register their mdio bus in their
dsa_switch_ops->setup while others do it in their actual probe
function (which actually makes more sense to me).

>
> What did work was:
>
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index c45ca2473743..45d67d50e35f 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -6249,8 +6249,10 @@ static int mv88e6xxx_probe(struct mdio_device *mdiodev)
>         if (!np && !pdata)
>                 return -EINVAL;
>
> -       if (np)
> +       if (np) {
>                 compat_info = of_device_get_match_data(dev);
> +               np->fwnode.flags |= FWNODE_FLAG_BROKEN_PARENT;
> +       }
>
>         if (pdata) {
>                 compat_info = pdata_device_get_match_data(dev);
>
> This will fix it for mv88e6xxx. But if the same problem occurs in any
> of the other DSA drivers, they will still be broken:
>
> ~/linux/drivers/net/dsa$ grep -r mdiobus_register *
> bcm_sf2.c:      err = mdiobus_register(priv->slave_mii_bus);
> dsa_loop_bdinfo.c:      return mdiobus_register_board_info(&bdinfo, 1);
> lantiq_gswip.c: return of_mdiobus_register(ds->slave_mii_bus, mdio_np);
> mt7530.c:       ret = mdiobus_register(bus);
> mv88e6xxx/chip.c:       err = of_mdiobus_register(bus, np);
> grep: mv88e6xxx/chip.o: binary file matches
> ocelot/seville_vsc9953.c:       rc = mdiobus_register(bus);
> ocelot/felix_vsc9959.c: rc = mdiobus_register(bus);
> qca/ar9331.c:   ret = of_mdiobus_register(mbus, mnp);
> qca8k.c:        return devm_of_mdiobus_register(priv->dev, bus, mdio);
> realtek-smi-core.c:     ret = of_mdiobus_register(smi->slave_mii_bus, mdio_np);

This one would have worked because it registers it in the ->setup()
ops. So it's not a simple grep for of_mdiobus_register(). But your
point stands nonetheless.

> sja1105/sja1105_mdio.c: rc = of_mdiobus_register(bus, np);
> sja1105/sja1105_mdio.c: rc = of_mdiobus_register(bus, np);
> sja1105/sja1105_mdio.c: rc = mdiobus_register(bus);
> sja1105/sja1105_mdio.c:int sja1105_mdiobus_register(struct dsa_switch *ds)
> sja1105/sja1105.h:int sja1105_mdiobus_register(struct dsa_switch *ds);
> sja1105/sja1105_main.c: rc = sja1105_mdiobus_register(ds);
>
> If you are happy to use a big hammer:

I'm okay with this big hammer for now while we figure out something better.

>
> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> index 53f034fc2ef7..7ecd910f7fb8 100644
> --- a/drivers/net/phy/mdio_bus.c
> +++ b/drivers/net/phy/mdio_bus.c
> @@ -525,6 +525,9 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
>             NULL == bus->read || NULL == bus->write)
>                 return -EINVAL;
>
> +       if (bus->parent && bus->parent->of_node)
> +               bus->parent->of_node->fwnode.flags |= FWNODE_FLAG_BROKEN_PARENT;
> +
>         BUG_ON(bus->state != MDIOBUS_ALLOCATED &&
>                bus->state != MDIOBUS_UNREGISTERED);
>
> So basically saying all MDIO busses potentially have a problem.
>
> I also don't like the name FWNODE_FLAG_BROKEN_PARENT. The parents are
> not broken, they work fine, if fw_devlink gets out of the way and
> allows them to do their job.

The parent assuming the child will be probed as soon as it's added is
a broken expectation/assumption. fw_devlink is just catching them
immediately.

Having said that, this is not the hill either of us should choose to
die on. So, how about something like:
FWNODE_FLAG_NEEDS_CHILD_BOUND_ON_ADD

If that works, I can clean up the series with this and the MDIO fix
you mentioned.

> You also asked about why the component framework is not used. DSA has
> been around for a while, the first commit dates back to October
> 2008. Russell Kings first commit for the component framework is
> January 2014. The plain driver model has worked for the last 13 years,
> so there has not been any need to change.

Thanks for the history on why it couldn't have been used earlier.

In the long run, I'd still like to fix this so that the
dsa_tree_setup() doesn't need the flag above. I have some ideas using
device links that'll be much simpler to understand and maintain than
using the component framework. I'll send out patches for that (not
meant for 5.15) later and we can go with the MDIO bus hammer for 5.15.

-Saravana
