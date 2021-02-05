Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02080311098
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 20:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233711AbhBERSE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 12:18:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233041AbhBERQl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 12:16:41 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DEA4C061756;
        Fri,  5 Feb 2021 10:58:23 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id g15so4343804pjd.2;
        Fri, 05 Feb 2021 10:58:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oStFooJPSyUUPaehiSFgmVTUpU7SYl2th8Aozvagcww=;
        b=ItJfVIaS/zVvcDySM5ApBDGERunskRhZ3z4O5TXYHyiSpMzUgrJX6WwfClue2kx3Lb
         Iwr2Q2pLa4Dza8Uff/8DLU0E9nIaoLYGSNRAD6FYdZ4sd3NHC1SQFU8Grb4KQLGlvB3N
         UxXj1L1A45RefWcslfKPfH43PVjvpsmHbAz4mTKH4qqdvKYjSKaAi8qv4F0QtyMFIN0n
         R0CGBO0eYcSNT3f5V5UhdBA8hs+yhJ9swzpWm3eeuGg5ydqUZ0rVzlPiqwcg7T9/1itn
         3QiK73GGY+pvbVp7V3Q+keN6lvy1aaceeB1fOAgFlVVkMp6wYIYe5YqedV7Bs0I2uYUg
         t0dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oStFooJPSyUUPaehiSFgmVTUpU7SYl2th8Aozvagcww=;
        b=KvjP0cIMNOKvbRMjGMQ2fjIGwMnLlME2lZk43HOzVP9RJlosiN2OASU40BUiVzk7Y5
         jKhypH4CIfgqe7wEgOfascObAj0GPn9JiXrp6Aua999LlKKi7db4Zu/HTSp6PaxcDHVi
         2mnbA4VgZk3UnuXTvHd5hP93/ekaY0HoyCv9kkby1sx2nL9fmj8o4qh5M/tMYQ4TXEdi
         +74LWe0x7cj1GQAc7PfWnGRNU6UdwMP25z41ABZXMRB23jSonMzB/hix+VCqVoMMBtgW
         JS8rW7dItlBETOlqTsySX+Kjnw0KCpXTWsl4UMIcZP+ElRibExDtnSY5ClANloTR0VB6
         qK8Q==
X-Gm-Message-State: AOAM531Urc7UEDbA1VQfQ4Dhzr9s7xD7BntXMn57F76KhrOFuW3sgxiA
        Iq9RGy6iBvRjv3CVZlpdFM+lH66sCFNd17OfKcU=
X-Google-Smtp-Source: ABdhPJw2fpaymWsQn8Lz4ksHt2GmzoGTUAPbpEI7vmF/Pxo1GqyI2pPVxQVzpfj/xlLogFp/04RgxKKeuo5zxeRUUU4=
X-Received: by 2002:a17:902:b190:b029:df:fff2:c345 with SMTP id
 s16-20020a170902b190b02900dffff2c345mr5119652plr.17.1612551503103; Fri, 05
 Feb 2021 10:58:23 -0800 (PST)
MIME-Version: 1.0
References: <20210122154300.7628-1-calvin.johnson@oss.nxp.com>
 <20210122154300.7628-8-calvin.johnson@oss.nxp.com> <20210205172518.GA18214@lsv03152.swis.in-blr01.nxp.com>
 <CAHp75VdX2gZbt-eYp31wg0r+yih8omGxcTf6cMyhxjMZZYzFuQ@mail.gmail.com> <CAHp75VdEjNhj5oQTqnnOhnibBAa2CoHf1PAvJi57X0d-6LC3NQ@mail.gmail.com>
In-Reply-To: <CAHp75VdEjNhj5oQTqnnOhnibBAa2CoHf1PAvJi57X0d-6LC3NQ@mail.gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Fri, 5 Feb 2021 20:58:06 +0200
Message-ID: <CAHp75VcVPfgA-WS+gAH6ugrzaU9_nhRcg0pC07x7XcBha55bPg@mail.gmail.com>
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

On Fri, Feb 5, 2021 at 8:41 PM Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
> On Fri, Feb 5, 2021 at 8:25 PM Andy Shevchenko
> <andy.shevchenko@gmail.com> wrote:
> > On Fri, Feb 5, 2021 at 7:25 PM Calvin Johnson
> > <calvin.johnson@oss.nxp.com> wrote:
> > > On Fri, Jan 22, 2021 at 09:12:52PM +0530, Calvin Johnson wrote:
> >
> > ...
> >
> > > > +     rc = fwnode_property_match_string(child, "compatible", "ethernet-phy-ieee802.3-c45");
> > > With ACPI, I'm facing some problem with fwnode_property_match_string(). It is
> > > unable to detect the compatible string and returns -EPROTO.
> > >
> > > ACPI node for PHY4 is as below:
> > >
> > >  Device(PHY4) {
> > >     Name (_ADR, 0x4)
> > >     Name(_CRS, ResourceTemplate() {
> > >     Interrupt(ResourceConsumer, Level, ActiveHigh, Shared)
> > >     {
> > >       AQR_PHY4_IT
> > >     }
> > >     }) // end of _CRS for PHY4
> > >     Name (_DSD, Package () {
> > >       ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> > >         Package () {
>
> > >           Package () {"compatible", "ethernet-phy-ieee802.3-c45"}
>
> I guess converting this to
>            Package () {"compatible", Package() {"ethernet-phy-ieee802.3-c45"}}
> will solve it.

For the record, it doesn't mean there is no bug in the code. DT treats
a single string as an array, but ACPI doesn't.
And this is specific to _match_string() because it has two passes. And
the first one fails.
While reading a single string as an array of 1 element will work I believe.

> > >        }
>
> > >     })
> > >   } // end of PHY4
> > >
> > >  What is see is that in acpi_data_get_property(),
> > > propvalue->type = 0x2(ACPI_TYPE_STRING) and type = 0x4(ACPI_TYPE_PACKAGE).
> > >
> > > Any help please?
> > >
> > > fwnode_property_match_string() works fine for DT.
> >
> > Can you show the DT node which works and also input for the
> > )match_string() (i.o.w what exactly you are trying to match with)?


-- 
With Best Regards,
Andy Shevchenko
