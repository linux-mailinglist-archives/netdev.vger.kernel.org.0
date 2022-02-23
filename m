Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBE124C1534
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 15:16:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241454AbiBWOQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 09:16:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239991AbiBWOQc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 09:16:32 -0500
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [217.70.183.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D437BB0EB4;
        Wed, 23 Feb 2022 06:15:59 -0800 (PST)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id F08CF2000A;
        Wed, 23 Feb 2022 14:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1645625758;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K0LLpFNSYlgLgGZDQ4Kn9BMjM80jq/ZjR7pVaVA3M80=;
        b=YOpttUoec2Q3yrM5nfTur2T10hkCCSSXULyFzPRxf4cCqscNd16U5/XUnqd5T6fJCjX9pr
        mGlW2a6e4Lnhb86fGPQXBRzTN6zMOf3hj4N8RXQcStBRlmuN5qT0l6GnGIsSIsZeaGBr0t
        PyFhrKFWTOXvnywkyVR1ahHohjkWbth8+QUMqxrG4BMb2l01EvGZlhYN1NDS/AzaveoX8T
        WE2EMfyuWDl3r0nZ1vvqW935wFEW8bgmQMpSPg252Fi+M/caHt7uYGI57r+6oCyrKYcN4f
        aX+dGpL2vEqLLmuntM2WhdbEM5qDvh0KvnnH2zgFYtYGAE+klAdFk6+9ZvZZuw==
Date:   Wed, 23 Feb 2022 15:14:36 +0100
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Wolfram Sang <wsa@kernel.org>, Peter Rosin <peda@axentia.se>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-i2c@vger.kernel.org,
        netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: Re: [RFC 10/10] net: sfp: add support for fwnode
Message-ID: <20220223151436.4798e5ad@fixe.home>
In-Reply-To: <4d611fe8-b82a-1709-507a-56be94263688@redhat.com>
References: <20220221162652.103834-1-clement.leger@bootlin.com>
        <20220221162652.103834-11-clement.leger@bootlin.com>
        <YhPSkz8+BIcdb72R@smile.fi.intel.com>
        <20220222142513.026ad98c@fixe.home>
        <YhYZAc5+Q1rN3vhk@smile.fi.intel.com>
        <888f9f1a-ca5a-1250-1423-6c012ec773e2@redhat.com>
        <YhYriwvHJKjrDQRf@shell.armlinux.org.uk>
        <4d611fe8-b82a-1709-507a-56be94263688@redhat.com>
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

Le Wed, 23 Feb 2022 14:39:27 +0100,
Hans de Goede <hdegoede@redhat.com> a =C3=A9crit :

> > I think what we need is both approaches. We need a way for the SFP
> > driver (which is a platform_driver) to be used _without_ needing
> > descriptions in firmware. I think we have that for GPIOs, but for an
> > I2C bus, We have i2c_get_adapter() for I2C buses, but that needs the
> > bus number - we could either pass the i2c_adapter or the adapter
> > number through platform data to the SFP driver.
> >=20
> > Or is there another solution to being able to reuse multi-driver
> > based infrastructure that we have developed based on DT descriptions
> > in situations such as an add-in PCI card? =20
>=20
> The use of software fwnode-s as proposed in this patch-set is another
> way to deal with this. There has been work to abstract ACPI vs
> of/dt firmware-nodes into a generic fwnode concept and software-nodes
> are a third way to define fwnode-s for "struct device" devices.
>=20
> Software nodes currently are mainly used as so called secondary
> fwnodes which means they can e.g. add extra properties to cover
> for the firmware description missing some info (which at least
> on ACPI happens more often then we would like).
>=20
> But a software-node can also be used as the primary fwnode for
> a device. So what this patch-set does is move the i2c of/dt
> enumeration code over to the fwnode abstraction (1). This allows
> the driver for the SPF card to attach a software fwnode to the
> device for the i2c-controller which describes the hotplug pins +
> any other always present hw in the same way as it would be done
> in a devicetree fwnode and then the existing of/dt based SPF
> code can be re-used as is.
>=20
> At least that is my understanding of this patch-set.
>=20
> Regards,
>=20
> Hans

Hello Hans, your understanding is totally correct.

This PCIe device actually embeds much more than just a I2C controller.
I should have made that clearer in the cover letter, sorry for the
confusion. The PCIe card is actually using a lan9662x SoC which is
meant to be used as an ethernet switch with 4 ports (2 RJ45 and two
SFPS). In order to use this switch, the following drivers can be reused:
 - lan966x-switch
 - reset-microchip-sparx5
 - lan966x_serdes
 - reset-microchip-lan966x-phy
 - mdio-mscc-miim
 - pinctrl-lan966x
 - atmel-flexcom
 - i2c-at91
 - i2c-mux
 - i2c-mux-pinctrl
 - sfp
 - clk-lan966x
 - lan966x-pci-mfd

All theses drivers are using of_* API and as such only works with a DT
description. One solution that did seems acceptable to me (although
not great)was to use mfd_cells and software_node description
as primary node.

Since I wanted to convert these to be software_node compatible, I had
to modify many subsystems (pinctrl, gpio, i2c, clocks, reset, etc).
This is why I stated in the cover letter that "This series is part of a
larger changeset that touches multiple subsystems". But clearly, it
lacks more context and namely the list of subsystems that needed to be
modify as well as the PCIe card type. I will modify this cover-letter to
add more informations.

So indeed, this series is targetting at using devices which uses a
software_node as a primary node and modifying subsystems to use the
fwnode API in order to make that compatible with these software nodes.
As you said, in order to avoid redefining the match tables and allow
device_get_match_data to work with software_node, the trick was to
reuse the of_table_id

However, I'm not totally happy with that as it seems we are doing what
was done with the "old" platform_data (a bit cleaner maybe since it
allows to reuse the driver with the fwnode API).

As Russell asked, I'm also really interested if someone has a solution
to reuse device-tree description (overlays ?) to describe such
hardware. However, the fact that CONFIG_OF isn't enabled on x86 config
seems a bit complicated on this side. This also requires to load a
device-tree overlay from the filesystem to describe the card, but that
might be something that could be made generic to allow other uses-cases.

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
