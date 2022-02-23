Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C625F4C1717
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 16:40:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242232AbiBWPki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 10:40:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242225AbiBWPkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 10:40:35 -0500
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4DCCBD896;
        Wed, 23 Feb 2022 07:40:04 -0800 (PST)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 89B7AC000D;
        Wed, 23 Feb 2022 15:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1645630803;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SIImQW6Wz47dS7gZcpaHZzfA86jdmHRDoD5Bd/gJF4A=;
        b=gIZpZpEmH+0XGOppwuovDbnnlfAWy1UVi32GSrfrYn2T5xalCQSYQpt2C/uYQndCGPW1tJ
        Ey5mcCnRKG2xmE+pWETCoASGM5HM4b+qHYOoJsB+tTwUR2Me2c4X1pr+yppYT3fKQxbQZG
        pPsuhvBc265xwJAsP67JAxzPCL2KPQM888flzeJVgcFUUro8RvceNHNN3QF+INkrKoMG4n
        /0Ig84edaifDW0zLIzhZvQkAslUVbaXM4QjvMXftQWUb5Mkh8qfiajkjoeLUrmTLM8xbc2
        1FzHNY997E409FvkDhcovNNg9Te5W7HpxPmquj2xe59uR75XSV5mt0QkTCVOoQ==
Date:   Wed, 23 Feb 2022 16:38:40 +0100
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Wolfram Sang <wsa@kernel.org>, Peter Rosin <peda@axentia.se>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-i2c@vger.kernel.org,
        netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: Re: [RFC 10/10] net: sfp: add support for fwnode
Message-ID: <20220223163840.444f84fd@fixe.home>
In-Reply-To: <YhZRgnPG5Yd8mvc/@lunn.ch>
References: <20220221162652.103834-1-clement.leger@bootlin.com>
        <20220221162652.103834-11-clement.leger@bootlin.com>
        <YhPSkz8+BIcdb72R@smile.fi.intel.com>
        <20220222142513.026ad98c@fixe.home>
        <YhYZAc5+Q1rN3vhk@smile.fi.intel.com>
        <888f9f1a-ca5a-1250-1423-6c012ec773e2@redhat.com>
        <YhYriwvHJKjrDQRf@shell.armlinux.org.uk>
        <4d611fe8-b82a-1709-507a-56be94263688@redhat.com>
        <20220223151436.4798e5ad@fixe.home>
        <YhZRgnPG5Yd8mvc/@lunn.ch>
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

Le Wed, 23 Feb 2022 16:23:46 +0100,
Andrew Lunn <andrew@lunn.ch> a =C3=A9crit :

> > As Russell asked, I'm also really interested if someone has a solution
> > to reuse device-tree description (overlays ?) to describe such
> > hardware. However, the fact that CONFIG_OF isn't enabled on x86 config
> > seems a bit complicated on this side. =20
>=20
> It does work, intel even used it for one of there tiny x86 SoCs. Maybe
> it was Newton? If you search around you can find maybe a Linux
> Plumbers presentation about DT and x86.

Oh yes, I know it works and I tried loading an overlay using CONFIG_OF
on a x86. Currently it does not works and generate a oops due to the
fact that the lack of "/" node is not handled and that the error path
has probably not been thoroughly tested. Adress remapping for PCI and
lack of PCI bus description might also be a bit cumbersome but maybe
this is the way to go.

I was saying a "bit complicated" as it is not often used and it would
require enabling CONFIG_OF to support this feature as well as allowing
loading overlays without any root node. But this is probably something
that is also achievable.

>=20
> You can probably use a udev rule, triggered by the PCIe device ID to
> load the DT overlay.

Or maybe load the overlay from the PCIe driver ? This would also allow
to introduce some remapping of addresses (see below) inside the driver
maybe.

>=20
> Do you actually need anything from the host other than PCIe? It sounds
> like this card is pretty self contained, so you won't need phandles
> pointing to the host i2c bus, or the hosts GPIOs? You only need
> phandles to your own i2c bus, your own GPIOs? That will make the
> overlay much simpler.

Yes, the device is almost self contained, only the IRQ needs to be
chained with the MSI.

>=20
> 	Andrew



--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
