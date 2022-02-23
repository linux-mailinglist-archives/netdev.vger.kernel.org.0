Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 984094C1A00
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 18:41:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242328AbiBWRmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 12:42:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236603AbiBWRmJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 12:42:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07DDF15A07;
        Wed, 23 Feb 2022 09:41:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B975B8211B;
        Wed, 23 Feb 2022 17:41:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96CE5C340E7;
        Wed, 23 Feb 2022 17:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645638097;
        bh=H8/kL6fZmOVt00+PvcoBOqNgrbzq1+buIdvb6O9tj4Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vHjOWG4IfqW9w3F2UpUjc8yEVLKvTetZHhZA4ZjWIYy4rRLq/hAs2r0rzaE1BYQin
         uL2zu2iev7iO/4/EnRaqCeObTnm53OOvv7GpUOH9angl4oLp+0eteZQK3wN46HKMjV
         TTPfFoRDQT/F1TP/Cn9r4s8BJj2BiEkB2Am3nByJt2AKfwmnxuTnW9LTDkbMNICKQE
         9wy5u/O8hL+VTiHuW68TnvpCBy0AbbbD7i30mBoezqr0YZ7TdUtpZMoaSbLE1Qu6WF
         DGjrX80Z+d6Mwj3XUOCWxXqNGH2zTZmBfgtl8U53VZs0ROS60cFvS87f7mOk3vZiv+
         K5Ut30x+oD99Q==
Date:   Wed, 23 Feb 2022 17:41:30 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>,
        Hans de Goede <hdegoede@redhat.com>,
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
Message-ID: <YhZxyluc7gYhmAuh@sirena.org.uk>
Mail-Followup-To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Enrico Weigelt <info@metux.net>,
        Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Wolfram Sang <wsa@kernel.org>, Peter Rosin <peda@axentia.se>,
        Russell King <linux@armlinux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-i2c@vger.kernel.org,
        netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
References: <20220221162652.103834-1-clement.leger@bootlin.com>
 <YhPOxL++yhNHh+xH@smile.fi.intel.com>
 <20220222173019.2380dcaf@fixe.home>
 <YhZI1XImMNJgzORb@smile.fi.intel.com>
 <20220223161150.664aa5e6@fixe.home>
 <YhZRtads7MGzPEEL@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="slYx1ncARWyiKVPi"
Content-Disposition: inline
In-Reply-To: <YhZRtads7MGzPEEL@smile.fi.intel.com>
X-Cookie: I smell a wumpus.
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--slYx1ncARWyiKVPi
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 23, 2022 at 05:24:37PM +0200, Andy Shevchenko wrote:
> On Wed, Feb 23, 2022 at 04:11:50PM +0100, Cl=E9ment L=E9ger wrote:
> > Le Wed, 23 Feb 2022 16:46:45 +0200,
> > Andy Shevchenko <andriy.shevchenko@linux.intel.com> a =E9crit :

> > > And here is the problem. We have a few different resource providers
> > > (a.k.a. firmware interfaces) which we need to cope with.

> > Understood that but does adding fwnode support means it should work
> > as-is with both DT and ACPI ? ACPI code is still in place and only the
> > of part was converted. But maybe you expect the fwnode prot to be
> > conformant with ACPI.

> Not only me, I believe Mark also was against using pure DT approach on
> ACPI enabled platforms.

I'm not 100% clear on the context here (I did dig about a bit in the
thread on lore but it looks like there's some extra context here) but in
general I don't think there's any enthusiasm for trying to mix different
firmware interfaces on a single system.  Certainly in the case of ACPI
and DT they have substantial differences in system model and trying to
paper over those cracks and integrate the two is a route to trouble.
This doesn't look like it's trying to use a DT on an ACPI system though?

There's been some discussion on how to handle loadable descriptions for
things like FPGA but I don't recall it ever having got anywhere concrete
- I could have missed something.  Those are dynamic cases which are more
trouble though.  For something that's a PCI card it's not clear that we
can't just statically instanitate the devices from kernel code, that was
how the MFD subsystem started off although it's now primarily applied to
other applications.  That looks to be what's going on here?

There were separately some issues with people trying to create
completely swnode based enumeration mechanisms for things that required
totally independent code for handling swnodes which seemed very
concerning but it's not clear to me if that's what's going on here.

> > As I said in the cover-letter, this approach is the only one that I did
> > found acceptable without being tied to some firmware description. If you
> > have another more portable approach, I'm ok with that. But this
> > solution should ideally work with pinctrl, gpio, clk, reset, phy, i2c,
> > i2c-mux without rewriting half of the code. And also allows to easily
> > swap the PCIe card to other slots/computer without having to modify the
> > description.

> My proposal is to use overlays that card provides with itself.
> These are supported mechanisms by Linux kernel.

We have code for DT overlays in the kernel but it's not generically
available.  There's issues with binding onto the platform device tree,
though they're less of a problem with something like this where it seems
to be a separate card with no cross links.

--slYx1ncARWyiKVPi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmIWcckACgkQJNaLcl1U
h9Db4gf+M8HtK75KY/lDyO6mHOnHCTi9s2TYFSv9g6+jgHHMvIJGXRwPi0+TZkLs
NygKC2BM5Vxp7RDB0mvlDUPlil7DtraK4enNmgg8e98bhU8yK1l8QGG5jtuyRHqB
egoqec4s7kmvNvbORlnnX9xPatICuYh1N6775GrntXlLPpasafB41pJbbTP0/uqj
FEAFWx8LSR5bWJhNIHZT3m7e9v2eejbSm8bXcDwOds/lq0GvDoHNspE9+yYKJcwe
0A9HpLte/mJqpLIi5Uah+oiV3epuRF5wba3kwB8vLpUToEX7XR7oUm7NnUEBGETf
lmTR6DPJ/VrBnm6Bh3A0Y2mahC+zBA==
=PA4U
-----END PGP SIGNATURE-----

--slYx1ncARWyiKVPi--
