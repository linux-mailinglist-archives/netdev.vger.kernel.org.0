Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D705C152099
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 19:46:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727455AbgBDSqx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 13:46:53 -0500
Received: from mail-yw1-f66.google.com ([209.85.161.66]:36690 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727381AbgBDSqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 13:46:52 -0500
Received: by mail-yw1-f66.google.com with SMTP id n184so18766515ywc.3;
        Tue, 04 Feb 2020 10:46:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xqzKkZZwYD8UmTNylzK68UHhE3Ou2TiZoSu6psgptxc=;
        b=llCdtAB8qGVONkL1WDs486cYwq+0N9bCKpYycyW0QBpVz93Ee8uWtEQNHghzDtGGW3
         VRMBr1Y0qOS1SmI6D5ub9m3PmBbp40ycsvjSzeCR2yVbs0FVTzrGcJ8BCYdJHFcgz/8f
         xyA4nkFPh069H3Atlfsb17vQV+lkb+h+NUxFVwlCOdlN5EgwwRGGrFl3iY8OLHBRn4Iy
         SkReHiQi4RGOrUY4tO3n++mqi70SKo+inieoEgT0V5gmNCYQdAwcATJ2YSGSlRA770MD
         Fx8RlM+twW1y7tWzNceS8P4T/c+UXbpsGD7Juf2Wk8pxw7JU/CDUYBpj0PxArDpX+NIH
         YozA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xqzKkZZwYD8UmTNylzK68UHhE3Ou2TiZoSu6psgptxc=;
        b=CyICAuKFoqPOKD2V/CrBFk/ktw8qQc+T+9dknS/NDtUPNRrG2V1HjeK6Sx+JA35EIy
         R6uE6czlW08hrvgn1JdZC5mLA3rNU7br+qyyRfdE1+IOSiUlkQNLIdSFmc3AGz34jdMO
         grluZarHaMkj/t/FP4BKUKu1ApGugLsGENVrSq1PwwEUmxMxZefhiiIEZ1iW4zvM8eeW
         n+FuelG+ne1aHjG4oFE7OPpnXz0Wc6o+34x9bBrmo93duvyMRY5EC5Kj+KPY5+L+VWef
         Om8YlbdqBycRkiLl3SC/XVlQXYqrx5o+HmTtQ4YjgibS7nU3mCcDVqvtyFla9j23Thya
         fI4g==
X-Gm-Message-State: APjAAAWHGsX37Rawj8hxcHV0trQpxVHZlfSpmC/KagUUafevnmyNXdKP
        590ac/ipfEUFBIWG2JGZ3PoYGwbSdE7y2rpXfP0=
X-Google-Smtp-Source: APXvYqyznM3JSsctyFV3LHXcVYtUQMGI945FYzOeF2DwokU04zfTUxXR2Y+b0OsjyVtyk++tp0VZYurDxaRh5YBoKq4=
X-Received: by 2002:a81:3754:: with SMTP id e81mr7045993ywa.404.1580842011687;
 Tue, 04 Feb 2020 10:46:51 -0800 (PST)
MIME-Version: 1.0
References: <20200131153440.20870-1-calvin.johnson@nxp.com>
 <20200131153440.20870-4-calvin.johnson@nxp.com> <6501a53b-40aa-5374-3c4a-6b21824f82fd@gmail.com>
In-Reply-To: <6501a53b-40aa-5374-3c4a-6b21824f82fd@gmail.com>
From:   Calvin Johnson <linux.cj@gmail.com>
Date:   Wed, 5 Feb 2020 00:16:39 +0530
Message-ID: <CAEhpT-VfWhha3B6qS6wFu-PQP9+zb4gxt7=nsrA58cecX21Dog@mail.gmail.com>
Subject: Re: [PATCH v1 3/7] net/fsl: add ACPI support for mdio bus
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Calvin Johnson <calvin.johnson@nxp.com>,
        Jon Nettleton <jon@solid-run.com>, linux@armlinux.org.uk,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        cristian.sovaiala@nxp.com, laurentiu.tudor@nxp.com,
        ioana.ciornei@nxp.com, V.Sethi@nxp.com, pankaj.bansal@nxp.com,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 02, 2020 at 07:44:40PM -0800, Florian Fainelli wrote:
>
>
> On 1/31/2020 7:34 AM, Calvin Johnson wrote:
> > From: Calvin Johnson <calvin.johnson@oss.nxp.com>
> >
> > Add ACPI support for MDIO bus registration while maintaining
> > the existing DT support.
> >
> > Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> > ---
>
> [snip]
>
> >     bus = mdiobus_alloc_size(sizeof(struct mdio_fsl_priv));
> > @@ -263,25 +265,41 @@ static int xgmac_mdio_probe(struct platform_device *pdev)
> >     bus->read = xgmac_mdio_read;
> >     bus->write = xgmac_mdio_write;
> >     bus->parent = &pdev->dev;
> > -   snprintf(bus->id, MII_BUS_ID_SIZE, "%llx", (unsigned long long)res.start);
> > +   snprintf(bus->id, MII_BUS_ID_SIZE, "%llx",
> > +            (unsigned long long)res->start);
>
> You could omit this clean up change.
Sure, will avoid split to newline.
> >
> >     /* Set the PHY base address */
> >     priv = bus->priv;
> > -   priv->mdio_base = of_iomap(np, 0);
> > +   priv->mdio_base = devm_ioremap_resource(&pdev->dev, res);
> >     if (!priv->mdio_base) {
>
> This probably needs to become IS_ERR() instead of a plain NULL check
Ok. Will take care in v2.
>
> >             ret = -ENOMEM;
> >             goto err_ioremap;
> >     }
> >
> > -   priv->is_little_endian = of_property_read_bool(pdev->dev.of_node,
> > -                                                  "little-endian");
> > -
> > -   priv->has_a011043 = of_property_read_bool(pdev->dev.of_node,
> > -                                             "fsl,erratum-a011043");
> > -
> > -   ret = of_mdiobus_register(bus, np);
> > -   if (ret) {
> > -           dev_err(&pdev->dev, "cannot register MDIO bus\n");
> > +   if (is_of_node(pdev->dev.fwnode)) {
> > +           priv->is_little_endian = of_property_read_bool(pdev->dev.of_node,
> > +                                                          "little-endian");
> > +
> > +           priv->has_a011043 = of_property_read_bool(pdev->dev.of_node,
> > +                                                     "fsl,erratum-a011043");
> > +
> > +           ret = of_mdiobus_register(bus, np);
> > +           if (ret) {
> > +                   dev_err(&pdev->dev, "cannot register MDIO bus\n");
> > +                   goto err_registration;
> > +           }
> > +   } else if (is_acpi_node(pdev->dev.fwnode)) {
> > +           priv->is_little_endian =
> > +                   fwnode_property_read_bool(pdev->dev.fwnode,
> > +                                             "little-endian");
> > +           ret = fwnode_mdiobus_register(bus, pdev->dev.fwnode);
> > +           if (ret) {
> > +                   dev_err(&pdev->dev, "cannot register MDIO bus\n");
> > +                   goto err_registration;
> > +           }
>
> The little-endian property read can be moved out of the DT/ACPI paths
> and you can just use device_property_read_bool() for that purpose.
> Having both fwnode_mdiobus_register() and of_mdiobus_register() looks
> fairly redundant, you could quite easily introduce a wrapper:
> device_mdiobus_register() which internally takes the appropriate DT/ACPI
> paths as needed.
Had some difficulty with DT while using fwnode APIs. Will resolve them
and provide better integrated code.

Thanks

Calvin
