Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 012DB337C44
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 19:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbhCKSPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 13:15:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbhCKSPB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 13:15:01 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1774C061574;
        Thu, 11 Mar 2021 10:15:01 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id n17so7053724plc.7;
        Thu, 11 Mar 2021 10:15:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dws62jrAOnft9HTIUVBwsXMXaS222scIKagfo6JeNDg=;
        b=UsrBWEUSmoqSxYXawqPv2K0aIpL1I5euE8CjW7R4lm/gaQts9YOXll57qdHI3QvTAl
         Halp7lyd4id0oIVJQXTNvkS9FHZBL42kRBYUrKPJChZK+3Xux4Zw7HFIqpzXV8XX1nUs
         Wxavuf9SJnZYg2BW7vE6x1KJoofSMHEKmiPsh3J6pmTepCOGSmqaOrZUxrKqPEW2C6+k
         Q+IfTPAOwOnHYkUC/vkgCvV4VkmX3tfcPmuP07WjKYWZJpnxlZdWocIIamomXu+pK9ST
         4QsFTy9TSr7zPW3LDdfGHWT83iFpK3AE0rl4vzGEUqFmkplaiIB+MlVxtgJPwkevg/kE
         Y/Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dws62jrAOnft9HTIUVBwsXMXaS222scIKagfo6JeNDg=;
        b=NW193A26ajEoZrdGTOXPGih03FXI3Wrag5W8FEZuMRrsUKgN3PzLC3scDJl58NvyFu
         qcG8NQIpnMx3j3Kesgvdn6Cp/IGvpMcKORoeifKf7SgaiDI/JIxf8x0DAElSixCIEkLq
         GZID8e8gZzzUzV7DSqBiy2iUh4z/wzVEqFnaX2HWKli8WzM0UE0/ybsS2UHThV9/g1qr
         XEFi0MdWGtuhWpo2EF0g0fCLrrc7xXYs66iyFVbEPJJhrBqn9oqXFW5rFEq3cLJ/Z/7r
         xc1WiktKxH6+3A1F8hid9hBQO9Li1nQzRCPb+NNJsUcogYptj5JJGWQpNz/jguMP/8EW
         oxUQ==
X-Gm-Message-State: AOAM530n6ndoNBRRH/bHjPm7J6XqBoa9NNWBkCIrwNr+ix24CVpZTRCY
        ppWKkiCRtKmDUp6+nFRbiWB6yoCYu/hl+mGWGKQ=
X-Google-Smtp-Source: ABdhPJwgL0YGRGL55JayrSg2l+lpYdFJjNs7gzsUjCmXydM88Y9NwFBtJ/YU2wE36U0WbNNGMOvQ0Hb1mQsBI0dyCdM=
X-Received: by 2002:a17:90a:db49:: with SMTP id u9mr10457516pjx.181.1615486501144;
 Thu, 11 Mar 2021 10:15:01 -0800 (PST)
MIME-Version: 1.0
References: <20210311062011.8054-1-calvin.johnson@oss.nxp.com>
 <20210311062011.8054-9-calvin.johnson@oss.nxp.com> <CAHp75VfKoNvBxbj5tKb9NqGGbn36s=uZznm9QDBzkVWYNa=LCA@mail.gmail.com>
 <20210311180010.GC5031@lsv03152.swis.in-blr01.nxp.com>
In-Reply-To: <20210311180010.GC5031@lsv03152.swis.in-blr01.nxp.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Thu, 11 Mar 2021 20:14:44 +0200
Message-ID: <CAHp75VccA=dM8XRe1_ZS28mZ0Ehy_W-yg4_19VOH3KF=+hBu7g@mail.gmail.com>
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

On Thu, Mar 11, 2021 at 8:00 PM Calvin Johnson
<calvin.johnson@oss.nxp.com> wrote:
> On Thu, Mar 11, 2021 at 02:09:37PM +0200, Andy Shevchenko wrote:
> > On Thu, Mar 11, 2021 at 8:21 AM Calvin Johnson
> > <calvin.johnson@oss.nxp.com> wrote:

...

> > > +config FWNODE_MDIO
> > > +       def_tristate PHYLIB
> >
> > (Seems "selectable only" item)
>
> What do you mean by "selectable only" item here? Can you please point to some
> other example?

The Kconfig sections without descriptions are not user-visible.
No user can run menuconfig and check a box with "I want this to be compiled".

tristate // selectable-only
tristate "bla bla bla" // user visible and selectable

> > > +       depends on ACPI
> > > +       depends on OF
> >
> > Wouldn't be better to have
> >   depends on (ACPI || OF) || COMPILE_TEST
> >
> > And honestly I don't understand it in either (AND or OR) variant. Why
> > do you need a dependency like this for fwnode API?
>
> Here, fwnode_mdiobus_register_phy() uses objects from both ACPI and OF.

APIs? Calls? What really fails if we have !ACPI and / or !OF?

> > Moreover dependencies don't work for "selectable only" items.
> >
> > > +       depends on PHYLIB
> > > +       select FIXED_PHY

--
With Best Regards,
Andy Shevchenko
