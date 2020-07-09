Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5740521A940
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 22:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbgGIUoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 16:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbgGIUoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 16:44:02 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F4049C08C5CE;
        Thu,  9 Jul 2020 13:44:01 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id q17so1293272pls.9;
        Thu, 09 Jul 2020 13:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F98Xq0TPUwujCqpqpCpyEGhMelduja476lkv/kxrcaA=;
        b=XnYyusvxdlJ01GPXHVfnFdJIhyuer1pg2f5s6kLoU/l1b6rGuaEbg6H6/UaPkXxdhY
         E1i0JGuJVxJsRuwG1GFbp1VAeQsvpCftNyH2ZHhnClvvci8JaVugOP7Q0GAC44hFxen5
         of2O+mjSCEib4Q2OhupliztYoxPv/dmHLhhkfK/axQBr01ShI18z3sGPYACAsAG+0254
         A3Hayxzaq0903nfrf/bM41bsqmgdnkuYqHwniyyumc21IqTVE2HSYAbuY7QIfd+o3ijh
         BwmFJX2y8L/1Ear8xO/8vbMkPkNH4+WrTidy/y1plMwF38DcrThp1sKIQbZipaigmuO2
         C6ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F98Xq0TPUwujCqpqpCpyEGhMelduja476lkv/kxrcaA=;
        b=g9ctaPkSqb5ANcPeFRSnr9O/LzGCbBeIeMCzKUNq0Qylcgxdf+wICyTfdderKqx6yE
         PXo+wQC1hXz0pqJnpOnxdCzbpRat5anmlH34duSf8H1vbE/bu630UtsOAhvw4VXYcGeR
         U+mCM+Cce9XI4wYsD3bOmIBvG83JMEkk0ivrM3/0/+3Fc/dYAHSzJma8s4+3WHl0A3SO
         1JVwg7gBKVSq5t3svyzSp4kvj6eJrGlumo49ovsfW96m10uC+OBr4YR9bkV7DY9ATsOZ
         92/ZuodL1lmfgnmrX/+xlGnIDnOpRbaeOXhrq6H8kotsQTmgO4Tm9VOwcH5JHDS5wlwV
         o1Hg==
X-Gm-Message-State: AOAM53355KZbC1bnnrh+W6gda4D/3GTTYdo36ESrqJw6JlDwYFrNWRoO
        JyaKXQl1G0wDV6Dj5w0YWKvPQT8GaCBnQGfAjug=
X-Google-Smtp-Source: ABdhPJza7l3USkS+797iURJpwC5v0PMzgRklxF4X/7YMW2QaLbOrw/RFXHxV0pyUUfvN3swft2na8gEiqhuvjQK9X7s=
X-Received: by 2002:a17:90a:a393:: with SMTP id x19mr2036461pjp.228.1594327441558;
 Thu, 09 Jul 2020 13:44:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200709175722.5228-1-calvin.johnson@oss.nxp.com> <20200709175722.5228-5-calvin.johnson@oss.nxp.com>
In-Reply-To: <20200709175722.5228-5-calvin.johnson@oss.nxp.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Thu, 9 Jul 2020 23:43:44 +0300
Message-ID: <CAHp75Vf_wcW3K64uM8i6Cp9rz9jrD-Y3BO6S10Xt8d5Bx3N-Rg@mail.gmail.com>
Subject: Re: [net-next PATCH v4 4/6] net: phy: introduce phy_find_by_fwnode()
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux.cj@gmail.com, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 9, 2020 at 8:57 PM Calvin Johnson
<calvin.johnson@oss.nxp.com> wrote:
>
> The PHYs on an mdiobus are probed and registered using mdiobus_register().
> Later, for connecting these PHYs to MAC, the PHYs registered on the
> mdiobus have to be referenced.
>
> For each MAC node, a property "mdio-handle" is used to reference the
> MDIO bus on which the PHYs are registered. On getting hold of the MDIO
> bus, use phy_find_by_fwnode() to get the PHY connected to the MAC.
>
> Introduce fwnode_mdio_find_bus() to find the mii_bus that corresponds
> to given mii_bus fwnode.

...

> +struct phy_device *phy_find_by_fwnode(struct fwnode_handle *fwnode)
> +{
> +       struct fwnode_handle *fwnode_mdio;
> +       struct mii_bus *mdio;
> +       int addr;
> +       int err;
> +
> +       fwnode_mdio = fwnode_find_reference(fwnode, "mdio-handle", 0);
> +       mdio = fwnode_mdio_find_bus(fwnode_mdio);
> +       fwnode_handle_put(fwnode_mdio);
> +       if (!mdio)
> +               return ERR_PTR(-ENODEV);

> +       err = fwnode_property_read_u32(fwnode, "phy-channel", &addr);
> +       if (err < 0 || addr < 0 || addr >= PHY_MAX_ADDR)
> +               return ERR_PTR(-EINVAL);

I'm wondering why this is written like above and not like below

err = ...
if (err)
  return ERR_PTR(err);
if (...)
 return ERR_PTR(-E...);

?

> +       return mdiobus_get_phy(mdio, addr);
> +}

-- 
With Best Regards,
Andy Shevchenko
