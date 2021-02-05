Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8077B311034
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 19:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233660AbhBERBp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 12:01:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233289AbhBEQ77 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 11:59:59 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50285C06174A;
        Fri,  5 Feb 2021 10:41:41 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id n10so5144904pgl.10;
        Fri, 05 Feb 2021 10:41:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hC/UygB6GdsZ6eOraCnag63BwEncrG0x9BtmpVb+yMo=;
        b=TjRy+eWKEXJUVeK/Gsejs2eaRhnLYsV0zq1vBr7NEsVAkz0F+cLP8n/qyRJhBd8RJ0
         i8caCeYZvMwSx3PQRy3U8AhfRs5hqucvRhRetp4ZmWtJqjCOW0HJAW/NTdqZ1mGGjoCW
         mIDuyz974q+SPxzrjIL9HI522rILrBeWl/abgB2nqB3DVt//140xaEpCbIlXkGgtwBp4
         pRbM8YhcnK6Rse+YEa49mhHgDHPaRCcJ0j2reS9o0w+LjupolZFbMeYnVPAkjymxt/QN
         mZ0Ruc/wh3S1ut7QZM8Czq4QjJFDsUQE6xbH/ei2zIONU8XfkXbOtixcQmkWIaNFQf97
         1/pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hC/UygB6GdsZ6eOraCnag63BwEncrG0x9BtmpVb+yMo=;
        b=rhGvD0CSuvE+LuR7zxAg/J5myooHeVfr84Iu3ZuG6IJhAT747gyBiUw0/NR1zb5LwJ
         YA93cFMQBL/q1/5ZZdHHq3aAkhAqOtc1aGVRpXzXEBL2bDmtCsmC6W/eZGLfDhzlRV6l
         Bmh8hA0iiyCBre1awY3ipwbXNtqEAiUd+MVBAohyH1MOK4oCjJiuNx9jjR//j3SG0LTD
         JSyAu57CN8UeuFN/YWA9aN4Ge70vi8C7dZMwPsxeoJs3YdGe1FlnmC0AiGMEIjxQal4Q
         KDSv/1vSjhNd3wbjxYEEt/EsvGRYspJFCGQribOBmy4eGaKXpJqDxhDt2KMdZlUARWlZ
         oxjg==
X-Gm-Message-State: AOAM532z53Ukecx25pkz8Uuyt2Io+BHYS6f6sJ9VCmULuf26MAp+Iwt/
        fk5AT7D46d82HKX3KD7kgM8OdbjILOWd6vA17NU=
X-Google-Smtp-Source: ABdhPJwrOVLtit11sVA7UUmR/FA4HIEYLB0s09rOj5SXdwwlTMX4WOOCacRZCmMo1dZ+2GRXJIpGMQMAWYw6VULr1Og=
X-Received: by 2002:a63:e50:: with SMTP id 16mr5569002pgo.74.1612550500873;
 Fri, 05 Feb 2021 10:41:40 -0800 (PST)
MIME-Version: 1.0
References: <20210122154300.7628-1-calvin.johnson@oss.nxp.com>
 <20210122154300.7628-8-calvin.johnson@oss.nxp.com> <20210205172518.GA18214@lsv03152.swis.in-blr01.nxp.com>
 <CAHp75VdX2gZbt-eYp31wg0r+yih8omGxcTf6cMyhxjMZZYzFuQ@mail.gmail.com>
In-Reply-To: <CAHp75VdX2gZbt-eYp31wg0r+yih8omGxcTf6cMyhxjMZZYzFuQ@mail.gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Fri, 5 Feb 2021 20:41:24 +0200
Message-ID: <CAHp75VdEjNhj5oQTqnnOhnibBAa2CoHf1PAvJi57X0d-6LC3NQ@mail.gmail.com>
Subject: Re: [net-next PATCH v4 07/15] net: mdiobus: Introduce fwnode_mdiobus_register_phy()
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
        "linux.cj" <linux.cj@gmail.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
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

On Fri, Feb 5, 2021 at 8:25 PM Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
> On Fri, Feb 5, 2021 at 7:25 PM Calvin Johnson
> <calvin.johnson@oss.nxp.com> wrote:
> > On Fri, Jan 22, 2021 at 09:12:52PM +0530, Calvin Johnson wrote:
>
> ...
>
> > > +     rc = fwnode_property_match_string(child, "compatible", "ethernet-phy-ieee802.3-c45");
> > With ACPI, I'm facing some problem with fwnode_property_match_string(). It is
> > unable to detect the compatible string and returns -EPROTO.
> >
> > ACPI node for PHY4 is as below:
> >
> >  Device(PHY4) {
> >     Name (_ADR, 0x4)
> >     Name(_CRS, ResourceTemplate() {
> >     Interrupt(ResourceConsumer, Level, ActiveHigh, Shared)
> >     {
> >       AQR_PHY4_IT
> >     }
> >     }) // end of _CRS for PHY4
> >     Name (_DSD, Package () {
> >       ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> >         Package () {

> >           Package () {"compatible", "ethernet-phy-ieee802.3-c45"}

I guess converting this to
           Package () {"compatible", Package() {"ethernet-phy-ieee802.3-c45"}}
will solve it.

> >        }

> >     })
> >   } // end of PHY4
> >
> >  What is see is that in acpi_data_get_property(),
> > propvalue->type = 0x2(ACPI_TYPE_STRING) and type = 0x4(ACPI_TYPE_PACKAGE).
> >
> > Any help please?
> >
> > fwnode_property_match_string() works fine for DT.
>
> Can you show the DT node which works and also input for the
> )match_string() (i.o.w what exactly you are trying to match with)?
>
> --
> With Best Regards,
> Andy Shevchenko



-- 
With Best Regards,
Andy Shevchenko
