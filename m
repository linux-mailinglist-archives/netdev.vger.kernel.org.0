Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4382B4CB993
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 09:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231683AbiCCIu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 03:50:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231686AbiCCIuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 03:50:55 -0500
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEAEF175866;
        Thu,  3 Mar 2022 00:50:08 -0800 (PST)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id A7171FF808;
        Thu,  3 Mar 2022 08:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1646297407;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5UW3cjbm8xQStGhB2RvIfU4jnFusyu8R3w5M3pRZH24=;
        b=dANPvPfz8FfZs3WYqIq9bl4LlaLJLTAlJ5KjEa5/oSz4t4sxrd/UksWc73/lSCGG+nrHCd
        mQIxG3Ur43o8TMewlH30a6KsQHToz3ai9gTjVkLYOfs1J0ysL1HCB5xUmtUX3PGTynenxc
        C9JR86pqix6ZdzHmr4NC1Xi/zegZdOfIZIewOvdoXVb8ro7spl0+Vg6PcWaqO+k2QU+Zyr
        IZ/nAzMfgna+2fCIn63SCZP9bEOTTG/pLhMuc694mgQVT8ubQa8/cmDsgN7/OandstlQoA
        RwRHGSWNGI6ycsn7veJsYuVOW0Xp94gZ89qONjeyTS3SL9/Y9UjVGSN76TCcQA==
Date:   Thu, 3 Mar 2022 09:48:40 +0100
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Mark Brown <broonie@kernel.org>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
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
Message-ID: <20220303094840.3b75c4c9@fixe.home>
In-Reply-To: <Yhe/qhFNNiGVHSW1@sirena.org.uk>
References: <20220221162652.103834-1-clement.leger@bootlin.com>
        <20220224154040.2633a4e4@fixe.home>
        <2d3278ef-0126-7b93-319b-543b17bccdc2@redhat.com>
        <20220224174205.43814f3f@fixe.home>
        <Yhe/qhFNNiGVHSW1@sirena.org.uk>
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

Le Thu, 24 Feb 2022 17:26:02 +0000,
Mark Brown <broonie@kernel.org> a =C3=A9crit :

> On Thu, Feb 24, 2022 at 05:42:05PM +0100, Cl=C3=A9ment L=C3=A9ger wrote:
> > Hans de Goede <hdegoede@redhat.com> a =C3=A9crit : =20
>=20
> > > As Mark already mentioned the regulator subsystem has shown to
> > > be a bit problematic here, but you don't seem to need that? =20
>=20
> > Indeed, I don't need this subsystem. However, I'm still not clear why
> > this subsystem in particular is problematic. Just so that I can
> > recognize the other subsystems with the same pattern, could you explain
> > me why it is problematic ?  =20
>=20
> ACPI has a strong concept of how power supply (and general critical
> resources) for devices should be described by firmware which is very
> different to that which DT as it is used in Linux has, confusing that
> model would make it much harder for generic OSs to work with generic
> ACPI systems, and makes it much easier to create unfortunate interactions
> between bits of software expecting ACPI models and bits of software
> expecting DT models for dealing with a device.  Potentially we could
> even run into issues with new versions of Linux if there's timing or
> other changes.  If Linux starts parsing the core DT bindings for
> regulators on ACPI systems then that makes it more likely that system
> integrators who are primarily interested in Linux will produce firmwares
> that run into these issues, perhaps unintentionally through a "this just
> happens to work" process.

Ok that's way more clear.

>=20
> As a result of this we very much do not want to have the regulator code
> parsing DT bindings using the fwnode APIs since that makes it much
> easier for us to end up with a situation where we are interpreting _DSD
> versions of regulator bindings and ending up with people making systems
> that rely on that.  Instead the regulator API is intentional about which
> platform description interfaces it is using.  We could potentially have
> something that is specific to swnode and won't work with general fwnode
> but it's hard to see any advantages for this over the board file based
> mechanism we have already, swnode offers less error detection (typoing
> field names is harder to spot) and the data marshalling takes more code.

Instead of making it specific for swnode, could we make it instead non
working for acpi nodes ? Thus, the parsing would work only for swnode
and device_node, not allowing to use the fwnode support with acpi for
such subsystems (not talking about regulators here).

If switching to board file based mechanism, this means that all drivers
that are used by the PCIe card will have to be modified to support this
mechanism.

>=20
> fwnode is great for things like properties for leaf devices since those
> are basically a free for all on ACPI systems, it allows us to quickly
> and simply apply the work done defining bindings for DT to ACPI systems
> in a way that's compatible with how APCI wants to work.  It's also good
> for cross device bindings that are considered out of scope for ACPI,
> though a bit of caution is needed determining when that's the case.

Ok got it, thanks for the in-depth explanations.

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
