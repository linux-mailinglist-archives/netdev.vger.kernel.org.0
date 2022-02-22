Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5C8C4BFC41
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 16:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232972AbiBVPSn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 10:18:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232357AbiBVPSl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 10:18:41 -0500
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::223])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10E81149B86;
        Tue, 22 Feb 2022 07:18:13 -0800 (PST)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id F2B0C60010;
        Tue, 22 Feb 2022 15:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1645543091;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sUKjasZW1jCb/3Z0/TiPJo6cUX+jFii8PUJTFIJ++ec=;
        b=Cym6tuLgJkn0JINb6E0P3BCm5JYJO5LcLnW+87X5TlDByLTSsQrOya1GLhsi3ErKO2e/JR
        SL/+16MGtqhjBdecsOzndAcOxz8HS7wbpX957VuwnLtSxw+BIP60R9VkO08nGyiBOz1AFS
        9u3Z0DkjapXMLphV9k/Pbq82411V/84MqVMBWRNh8CqSRWnecTpPu1thW6TSW3Bxp6W12p
        dx89ZCTS9IXKpdfdxrgbifOA6udZMZmfIUYXb35eXea9TBxbyL1VbUN7yzPYGzjBMVWW0S
        Nqqyamnh+OsGqlKUA0Eh6wYiWsl3yHZCE2ACWyImcd521AYUazzgxeAtEypSjQ==
Date:   Tue, 22 Feb 2022 16:16:50 +0100
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
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
Message-ID: <20220222161650.1b75825b@fixe.home>
In-Reply-To: <YhS5BnvofimMReDE@kroah.com>
References: <20220221162652.103834-1-clement.leger@bootlin.com>
        <20220221162652.103834-3-clement.leger@bootlin.com>
        <YhPP5GWt7XEv5xx8@smile.fi.intel.com>
        <20220222091902.198ce809@fixe.home>
        <CAHp75VdwfhGKOiGhJ1JsiG+R2ZdHa3N4hz6tyy5BmyFLripV5A@mail.gmail.com>
        <20220222094623.1f7166c3@fixe.home>
        <CAHp75VfduXwRvxkNg=At5jaN-tcP3=utiukEDL35PEv_grK4Pw@mail.gmail.com>
        <20220222104705.54a73165@fixe.home>
        <YhS5BnvofimMReDE@kroah.com>
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

Le Tue, 22 Feb 2022 11:20:54 +0100,
Greg Kroah-Hartman <gregkh@linuxfoundation.org> a =C3=A9crit :

> >=20
> > The problem that I see is not only duplication but also that the PCIe
> > card won't work out of the box and will need a specific SSDT overlays
> > each time it is used. According to your document about SSDT overlays,
> > there is no way to load this from the driver. This means that the user
> > will have to compile a platform specific .aml file to match its
> > platform configuration. If the user wants to change the PCIe port, than
> > I guess it will have to load another .aml file. I do not think a user
> > expect to do so when plugging a PCIe card.
> >=20
> > Moreover, the APCI documentation [1] says the following:
> >=20
> > "PCI devices, which are below the host bridge, generally do not need to
> > be described via ACPI. The OS can discover them via the standard PCI
> > enumeration mechanism, using config accesses to discover and identify
> > devices and read and size their BARs. However, ACPI may describe PCI
> > devices if it provides power management or hotplug functionality for
> > them or if the device has INTx interrupts connected by platform
> > interrupt controllers and a _PRT is needed to describe those
> > connections."
> >=20
> > The device I want to use (a PCIe switch) does not fall into these
> > categories so there should be no need to describe it using ACPI. =20
>=20
> There should not be any need to describe it in any way, the device
> should provide all of the needed information.  PCIe devices do not need
> a DT entry, as that does not make sense.
>=20
> thanks,
>=20
> greg k-h

In my opinion, yes, there should be no need for an "external"
description. Loading any kind of description (either with ACPI or DT)
defeat the purpose of the PCI since the card won't be able to be
plug-and-play anymore on multiple platform.

The driver however should be self-contained and contain its own
"description" of the hardware, no matter the platform on which the card
is plugged. The PCIe card is independent of the platform, I do not
think describing it with a platform specific description language is
maintainable nor user acceptable for the user.

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
