Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 392CE4BFE9D
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 17:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233621AbiBVQcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 11:32:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233875AbiBVQcJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 11:32:09 -0500
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [217.70.183.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E1FA6E54E;
        Tue, 22 Feb 2022 08:31:41 -0800 (PST)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 2F93420003;
        Tue, 22 Feb 2022 16:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1645547500;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DX9NhASmajHZnyC217wOwL7ov42sa2Tz6XVPF8ddW48=;
        b=fxrNoOOksIBC1l5jidCWAAr+FXTdxwIp8gWk4WyB7gClWMLtgcsXyc3A5AR4kvQb8TldMv
        2BWw2VfmwDCecO2uE9h3yultbIRm+SfRJUFKnKcB4r0GOXZ7j9uIrvktXSkufIhm0Fax9S
        FGMZt6csFKJ5F1Yw0euMmULxpV+Y6eI50ruJqz3N69qRQq6EEXqP1pZ+nGrNtFo61aKHQE
        Fue4GuJVvnmemlvUWJ6gT56QOxQ43FonwjGxNUzB4BoEWAfgMREaLy30XEWDrxH/daz3k9
        4ieES7Wfi6/8u47FTCyuIT1BfnD1MxOao7CzI/KejjawmbhpvBZ7rx5w1czB+g==
Date:   Tue, 22 Feb 2022 17:30:19 +0100
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Daniel Scally <djrscally@gmail.com>,
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
Message-ID: <20220222173019.2380dcaf@fixe.home>
In-Reply-To: <YhPOxL++yhNHh+xH@smile.fi.intel.com>
References: <20220221162652.103834-1-clement.leger@bootlin.com>
        <YhPOxL++yhNHh+xH@smile.fi.intel.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Mon, 21 Feb 2022 19:41:24 +0200,
Andy Shevchenko <andriy.shevchenko@linux.intel.com> a =C3=A9crit :

> >=20
> > We thought about adding CONFIG_OF to x86 and potentially describe this
> > card using device-tree overlays but it introduce other problems that
> > also seems difficult to solve (overlay loading without base
> > device-tree, fixup of IRQs, adresses, and so on) and CONFIG_OF is not
> > often enabled on x86 to say the least. =20
>=20
> Why it can't be described by SSDT overlay (if the x86 platform in questio=
n is
> ACPI based)?

This devices uses a SoC for which drivers are already available but are
meant to be used by a device-tree description. These drivers uses the
following subsystems:
- reset (no ACPI support ?)
- clk (no ACPI support ?)
- pinctrl (no ACPI support ?)
- syscon (no ACPI support ?)
- gpio
- phy
- mdio

Converting existing OF support to fwnode support and thus allowing
drivers and subsystems to be compatible with software nodes seemed like
the easiest way to do what I needed by keeping all existing drivers.
With this support, the driver is completely self-contained and does
allow the card to be plugged on whatever platform the user may have.

Again, the PCI card is independent of the platform, I do not really see
why it should be described using platform description language.

> >=20
> > This series introduce a number of changes in multiple subsystems to
> > allow registering and using devices that are described with a
> > software_node description attached to a mfd_cell, making them usable
> > with the fwnode API. It was needed to modify many subsystem where
> > CONFIG_OF was tightly integrated through the use of of_xlate()
> > functions and other of_* calls. New calls have been added to use fwnode
> > API and thus be usable with a wider range of nodes. Functions that are
> > used to get the devices (pinctrl_get, clk_get and so on) also needed
> > to be changed to use the fwnode API internally.
> >=20
> > For instance, the clk framework has been modified to add a
> > fwnode_xlate() callback and a new named fwnode_clk_add_hw_provider()
> > has been added. This function will register a clock using
> > fwnode_xlate() callback. Note that since the fwnode API is compatible
> > with devices that have a of_node member set, it will still be possible
> > to use the driver and get the clocks with CONFIG_OF enabled
> > configurations. =20
>=20
> How does this all is compatible with ACPI approaches?
> I mean we usually do not reintroduce 1:1 DT schemas in ACPI.

For the moment, I only added fwnode API support as an alternative to
support both OF and software nodes. ACPI is not meant to be handled by
this code "as-is". There is for sure some modifications to be made and
I do not know how clocks are handled when using ACPI. Based on some
thread dating back to 2018 [1], it seem it was even not supported at
all.

To be clear, I added the equivalent of the OF support but using
fwnode API because I was interested primarly in using it with software
nodes and still wanted OF support to work. I did not planned it to be
"ACPI compliant" right now since I do not have any knowledge in that
field.

>=20
> I think the CCF should be converted to use fwnode APIs and meanwhile
> we may discuss how to deal with clocks on ACPI platforms, because
> it may be a part of the power management methods.

Ok, before going down that way, should the fwnode support be the "only"
one, ie remove of_clk_register and others and convert them to
fwnode_clk_register for instance or should it be left to avoid
modifying all clock drivers ?

>=20
> > In some subsystems, it was possible to keep OF related function by
> > wrapping the fwnode ones. It is not yet sure if both support
> > (device-tree and fwnode) should still continue to coexists. For instance
> > if fwnode_xlate() and of_xlate() should remain since the fwnode version
> > also supports device-tree. Removing of_xlate() would of course require
> > to modify all drivers that uses it.
> >=20
> > Here is an excerpt of the lan966x description when used as a PCIe card.
> > The complete description is visible at [2]. This part only describe the
> > flexcom controller and the fixed-clock that is used as an input clock.
> >=20
> > static const struct property_entry ddr_clk_props[] =3D {
> >         PROPERTY_ENTRY_U32("clock-frequency", 30000000), =20
>=20
> >         PROPERTY_ENTRY_U32("#clock-cells", 0), =20
>=20
> Why this is used?
>=20

These props actually describes a fixed-clock properties. When adding
fwnode support to clk framework, it was needed to add the
equivalent of of_xlate() for fwnode (fwnode_xlate()). The number of
cells used to describe a reference is still needed to do the
translation using fwnode_property_get_reference_args() and give the
correct arguments to fwnode_xlate().

[1]
https://lore.kernel.org/lkml/914341e7-ca94-054d-6127-522b745006b4@arm.com/T/
--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
