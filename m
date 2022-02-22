Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 477754BF4FB
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 10:48:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbiBVJs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 04:48:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230274AbiBVJs4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 04:48:56 -0500
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82E938CDBD;
        Tue, 22 Feb 2022 01:48:29 -0800 (PST)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 0D04C24000E;
        Tue, 22 Feb 2022 09:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1645523308;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EFAaqhIoJajTkLT+95fOlAru+/AxTHVWX3q/uD+uNdU=;
        b=eAg3o386bJa6y9cGCHbx42R8Tm9kdj+SIwPdnXDvQTrUGO3IzullL5zCABe+VbXtKnDp6B
        IrZ1MycmBt6u13sM0hJIAEi7XNZLihmD5SK9SuRjtT8NmGD3eRVUG1pLJWcbb0PIQUHlVO
        M5tiXKtegLhr4tiXoUSopSd0EczlGZ+2L0fe+IUyNEAbqN1hy4tHgkEu40wVFrcdVlR8/s
        ut9iB78G/W6kLYj3Xn1LOeYWI6WjMVb+SVIG16TN03qHYTM9VEExmrNC68wuf/gvM/nEEK
        dB2blcd5oXMwfoX/59MJ86WrOy8GPGGR39UcgbH2hdb4zEhhJIiy74iQltOH5g==
Date:   Tue, 22 Feb 2022 10:47:05 +0100
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
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
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-i2c <linux-i2c@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: Re: [RFC 02/10] property: add fwnode_get_match_data()
Message-ID: <20220222104705.54a73165@fixe.home>
In-Reply-To: <CAHp75VfduXwRvxkNg=At5jaN-tcP3=utiukEDL35PEv_grK4Pw@mail.gmail.com>
References: <20220221162652.103834-1-clement.leger@bootlin.com>
        <20220221162652.103834-3-clement.leger@bootlin.com>
        <YhPP5GWt7XEv5xx8@smile.fi.intel.com>
        <20220222091902.198ce809@fixe.home>
        <CAHp75VdwfhGKOiGhJ1JsiG+R2ZdHa3N4hz6tyy5BmyFLripV5A@mail.gmail.com>
        <20220222094623.1f7166c3@fixe.home>
        <CAHp75VfduXwRvxkNg=At5jaN-tcP3=utiukEDL35PEv_grK4Pw@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Tue, 22 Feb 2022 10:24:13 +0100,
Andy Shevchenko <andy.shevchenko@gmail.com> a =C3=A9crit :

> > > If you want to use the device on an ACPI based platform, you need to
> > > describe it in ACPI as much as possible. The rest we may discuss. =20
> >
> > Agreed but the PCIe card might also be plugged in a system using a
> > device-tree description (ARM for instance). I should I do that without
> > duplicating the description both in DT and ACPI ? =20
>=20
> Why is it (duplication) a problem?
> Each platform has its own kind of description, so one needs to provide
> it in the format the platform accepts.
>=20

The problem that I see is not only duplication but also that the PCIe
card won't work out of the box and will need a specific SSDT overlays
each time it is used. According to your document about SSDT overlays,
there is no way to load this from the driver. This means that the user
will have to compile a platform specific .aml file to match its
platform configuration. If the user wants to change the PCIe port, than
I guess it will have to load another .aml file. I do not think a user
expect to do so when plugging a PCIe card.

Moreover, the APCI documentation [1] says the following:

"PCI devices, which are below the host bridge, generally do not need to
be described via ACPI. The OS can discover them via the standard PCI
enumeration mechanism, using config accesses to discover and identify
devices and read and size their BARs. However, ACPI may describe PCI
devices if it provides power management or hotplug functionality for
them or if the device has INTx interrupts connected by platform
interrupt controllers and a _PRT is needed to describe those
connections."

The device I want to use (a PCIe switch) does not fall into these
categories so there should be no need to describe it using ACPI.
Regarding the use of software nodes, the documentation also says that:

"The software nodes can be used to complement fwnodes representing real
firmware nodes when they are incomplete, for example missing device
properties, *and to supply the primary fwnode when the firmware lacks
hardware description for a device completely.*"

I think my device falls into this last category but I might be wrong. I
understand that using software_node is probably not the best idea to do
so but I did not found any other convenient way to do it and SSDT
overlays do not really seems to be ideal. I would be glad if you
could provide me with an example of such usage to check if it's really
usable.

Thanks,

[1] https://www.kernel.org/doc/html/latest/PCI/acpi-info.html
--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
