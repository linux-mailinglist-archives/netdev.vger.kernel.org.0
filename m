Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 060994C163E
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 16:13:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241052AbiBWPNo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 10:13:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232062AbiBWPNn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 10:13:43 -0500
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBC77B12E7;
        Wed, 23 Feb 2022 07:13:14 -0800 (PST)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 785A76000B;
        Wed, 23 Feb 2022 15:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1645629193;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bsmqhDPQ9IDgKu3Ou89zWq+VD4eKDFIuIM9PrDvh930=;
        b=epz77kD1Xc1YujS8BJTlKa2wRsM6sUQyzoyVr9f/wbR+PZWRnL5746DQbxG1dCrO8HzJHj
        /u4JJr5/XfbtFqfFocrfJWhyhjgPVA7AW+8xAr92yKRIUAR760AQSHI6/Yrpz/fmM+m7H4
        4ICCazc0t+wkR6sIJoTsFxObEI9PCPkdkYKvQlnBnuFCBJG+9kHM/91Bp71Taoi8hMU4hw
        CUsZS7+4LoB4gjAziUTFr512+rN6wMVPNxSaVxP4Q4TRoRyMPzaHxC9cWrbBnKDC9IVVDN
        DnYEP0zphwazMIVwB0QPZ79lSM/nqUk6LQzY6jeUylc60aHqrvmhDIg7H1k4Aw==
Date:   Wed, 23 Feb 2022 16:11:50 +0100
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Enrico Weigelt <info@metux.net>,
        Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Wolfram Sang <wsa@kernel.org>, Peter Rosin <peda@axentia.se>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-i2c@vger.kernel.org,
        netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: Re: [RFC 00/10] add support for fwnode in i2c mux system and sfp
Message-ID: <20220223161150.664aa5e6@fixe.home>
In-Reply-To: <YhZI1XImMNJgzORb@smile.fi.intel.com>
References: <20220221162652.103834-1-clement.leger@bootlin.com>
        <YhPOxL++yhNHh+xH@smile.fi.intel.com>
        <20220222173019.2380dcaf@fixe.home>
        <YhZI1XImMNJgzORb@smile.fi.intel.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Wed, 23 Feb 2022 16:46:45 +0200,
Andy Shevchenko <andriy.shevchenko@linux.intel.com> a =C3=A9crit :

[...]

> >=20
> > Converting existing OF support to fwnode support and thus allowing
> > drivers and subsystems to be compatible with software nodes seemed like
> > the easiest way to do what I needed by keeping all existing drivers.
> > With this support, the driver is completely self-contained and does
> > allow the card to be plugged on whatever platform the user may have. =20
>=20
> I agree with Hans on the point that converting to / supporting fwnode is
> a good thing by its own.
>=20
> > Again, the PCI card is independent of the platform, I do not really see
> > why it should be described using platform description language. =20
>=20
> Yep, and that why it should cope with the platforms it's designed to be u=
sed
> with.

I don't think PCIe card manufacturer expect them to be used solely on a
x86 platform with ACPI. So why should I used ACPI to describe it (or DT
by the way), that's my point.

[...]

> >=20
> > For the moment, I only added fwnode API support as an alternative to
> > support both OF and software nodes. ACPI is not meant to be handled by
> > this code "as-is". There is for sure some modifications to be made and
> > I do not know how clocks are handled when using ACPI. Based on some
> > thread dating back to 2018 [1], it seem it was even not supported at
> > all.
> >=20
> > To be clear, I added the equivalent of the OF support but using
> > fwnode API because I was interested primarly in using it with software
> > nodes and still wanted OF support to work. I did not planned it to be
> > "ACPI compliant" right now since I do not have any knowledge in that
> > field. =20
>=20
> And here is the problem. We have a few different resource providers
> (a.k.a. firmware interfaces) which we need to cope with.

Understood that but does adding fwnode support means it should work
as-is with both DT and ACPI ? ACPI code is still in place and only the
of part was converted. But maybe you expect the fwnode prot to be
conformant with ACPI.

>=20
> What is going on in this series seems to me quite a violation of the
> layers and technologies. But I guess you may find a supporter of your
> ideas (I mean Enrico). However, I'm on the other side and do not like
> this approach.

As I said in the cover-letter, this approach is the only one that I did
found acceptable without being tied to some firmware description. If you
have another more portable approach, I'm ok with that. But this
solution should ideally work with pinctrl, gpio, clk, reset, phy, i2c,
i2c-mux without rewriting half of the code. And also allows to easily
swap the PCIe card to other slots/computer without having to modify the
description.

>=20
> >=20
> > Ok, before going down that way, should the fwnode support be the "only"
> > one, ie remove of_clk_register and others and convert them to
> > fwnode_clk_register for instance or should it be left to avoid
> > modifying all clock drivers ? =20
>=20
> IRQ domain framework decided to cohabit both, while deprecating the OF on=
e.
> (see "add" vs. "create" APIs there). I think it's a sane choice.

Ok, thanks for the info.

[...]

> > > > static const struct property_entry ddr_clk_props[] =3D {
> > > >         PROPERTY_ENTRY_U32("clock-frequency", 30000000),   =20
> > >  =20
> > > >         PROPERTY_ENTRY_U32("#clock-cells", 0),   =20
> > >=20
> > > Why this is used? =20
> >=20
> > These props actually describes a fixed-clock properties. When adding
> > fwnode support to clk framework, it was needed to add the
> > equivalent of of_xlate() for fwnode (fwnode_xlate()). The number of
> > cells used to describe a reference is still needed to do the
> > translation using fwnode_property_get_reference_args() and give the
> > correct arguments to fwnode_xlate(). =20
>=20
> What you described is the programming (overkilled) point. But does hardwa=
re
> needs this? I.o.w. does it make sense in the _hardware_ description?

This does not makes sense for the hardware of course. It also does not
makes sense for the hardware to provide that in the device-tree though.
I actually think this should be only provided by the drivers but it
might be difficult to parse the descriptions then (either DT or
software_node), at least that's how it works right now.

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
