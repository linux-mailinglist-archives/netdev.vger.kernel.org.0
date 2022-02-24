Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7451C4C31B8
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 17:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbiBXQoB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 11:44:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbiBXQoA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 11:44:00 -0500
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [217.70.183.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3973141FD5;
        Thu, 24 Feb 2022 08:43:28 -0800 (PST)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 787BA20075;
        Thu, 24 Feb 2022 16:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1645721007;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0EQxRlRvhXsYaAeBTdQmnLrFioYi2KMupY8UbMy+e2c=;
        b=VjQ5dqHmS1G7TSSToTP2aGhOoaqpBOCgE+hYbqw4C5XcXOzcqqB6iSr7Wr8YfhPQ/txU58
        geZulm09XizDt9UDOH89k3avNe+Y+56FES7tORCBqWKR/3d3kxk9RSm8b+0vXpKSp8rjZX
        xJd6WRsIveKQzOKJt1L7OWNQ6I572YnwN8K+hNUpmcUVopQw859fGzQREFgMrgULf9N1rv
        dVmMrgQwQg/ZcE1NhgoVxz68Q+1Xu2CxFkJc2OXnA7+PcSdYcWyeCMejg08ZqSEN8vrlIM
        J5ZW7/k4Q2yE6PaA5ODPq543Vkv6JJL9rTpwGBeTdAU5fFwgVpWCB26mv1ZCdA==
Date:   Thu, 24 Feb 2022 17:42:05 +0100
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Hans de Goede <hdegoede@redhat.com>
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
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-i2c@vger.kernel.org,
        netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: Re: [RFC 00/10] add support for fwnode in i2c mux system and sfp
Message-ID: <20220224174205.43814f3f@fixe.home>
In-Reply-To: <2d3278ef-0126-7b93-319b-543b17bccdc2@redhat.com>
References: <20220221162652.103834-1-clement.leger@bootlin.com>
        <20220224154040.2633a4e4@fixe.home>
        <2d3278ef-0126-7b93-319b-543b17bccdc2@redhat.com>
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

Le Thu, 24 Feb 2022 15:58:04 +0100,
Hans de Goede <hdegoede@redhat.com> a =C3=A9crit :

[...]

> >    can be addressed, but it's not necessarily immediate.
> >=20
> > My preferred solutions would be swnode or device-tree overlays but
> > since there to is no consensus on how to add this support, how
> > can we go on with this series ? =20
>=20
> FWIW I think that the convert subsystems + drivers to use the fwnode
> abstraction layer + use swnode-s approach makes sense. For a bunch of
> x86/ACPI stuff like Type-C muxing/controllers/routing but also MIPI
> cameras we have already been moving in that direction since sometimes
> a bunch of info seems to be hardcoded in Windows drivers rather then
> "spelled out" in the ACPI tables so from the x86 side we are seeing
> a need to have platform glue code which replaces the hardcoding on
> the Windows side and we have been using the fwnode abstraction +
> swnodes for this, so that we can keep using the standard Linux
> abstractions/subsystems for this.
>=20
> As Mark already mentioned the regulator subsystem has shown to
> be a bit problematic here, but you don't seem to need that?

Hi Hans,

Indeed, I don't need this subsystem. However, I'm still not clear why
this subsystem in particular is problematic. Just so that I can
recognize the other subsystems with the same pattern, could you explain
me why it is problematic ?=20

>=20
> Your i2c subsys patches looked reasonable to me. IMHO an important
> thing missing to give you some advice whether to try 1. or 3. first
> is how well / clean the move to the fwnode abstractions would work
> for the other subsystems.

Actually, I did the conversion for pinctrl, gpios, i2c, reset, clk,
syscon, mdio but did not factorized all the of code on top of fwnode
adaptation. I did it completely for mdio and reset subsystems. Porting
them to fwnode was rather straightforward, and almost all the of_* API
now have a fwnode_* variant.

While porting them to fwnode, I mainly had to modify the "register" and
the "get" interface of these subsystems. I did not touched the
enumeration part if we can call it like this and thus all the
CLK_OF_DECLARE() related stuff is left untouched.

>=20
> Have you already converted other subsystems and if yes, can you
> give us a pointer to a branch somewhere with the conversion for
> other subsystems ?

All the preliminary work I did is available at the link at [1]. But as I
said, I did not converted completely all the subsystems, only reset [2]
(for which I tried to convert all the drivers and fatorized OF on top
of fwnode functions) and mdio [3] which proved to be easily portable.

I also modified the clk framework [4] but did not went to the complete
factorization of it. I converted the fixed-clk driver to see how well
it could be done. Biggest difficulty is to keep of_xlate() and
fwnode_xlate() (if we want to do so) to avoid modifying all drivers
(even though not a lot of them implements custom of_xlate() functions).

If backward compatibility is really needed, it can potentially be done,
at the cost of keeping of_xlate() member and by converting the fwnode
stuff to OF world (which is easily doable).

Conversion to fwnode API actually proved to be rather straightforward
except for some specific subsystem (syscon) which I'm not quite happy
with the outcome, but again, I wanted the community feedback before
going further in this way so there is room for improvement.

Regards,

[1] https://github.com/clementleger/linux/tree/fwnode_support
[2] https://github.com/clementleger/linux/tree/fwnode_reset
[3] https://github.com/clementleger/linux/tree/fwnode_mdio
[4] https://github.com/clementleger/linux/tree/fwnode_clk

>=20
> Regards,
>=20
> Hans


--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
