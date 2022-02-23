Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15C464C1AAE
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 19:12:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240617AbiBWSNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 13:13:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233265AbiBWSNS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 13:13:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DFF548314;
        Wed, 23 Feb 2022 10:12:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2723C614AD;
        Wed, 23 Feb 2022 18:12:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27C6DC340E7;
        Wed, 23 Feb 2022 18:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645639969;
        bh=ibRgnubvV0+p6x08BNOIt36v4cEWtV/u2v8MQUXB0AA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M7CjAzoEC2i57dNhhJUdlGUGCKqf9hRsy0ypIqosbjxeCb1eZ7gnJ5Pd19+43jOTC
         XF26CcFOulFoGaju+Gf93TWBRgYyknaoK3P945Xqgw7WyD2Od56GhU1bx6ZC7e8mGM
         2kAZ4bK5r7f5ll3oEs2bRSQ0SEKq6WK8tzwBR5EIIeU2e0aFg4NFh/6Z58BlD5pYP2
         L1PpgEj/Qbcu9NOHiIyYfB29k2a9x+5iLSl3odlMWaC+WbOpKL4feS5A2OzDDT2TNM
         Jx3Xd5A/Gypw4H0R3lUXQfzL7pWt1hEhWHEDKiCKsvEJmTY9IZ0QjPG5PCBygDla0d
         8LpM5lWvIHt7Q==
Date:   Wed, 23 Feb 2022 18:12:41 +0000
From:   Mark Brown <broonie@kernel.org>
To:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
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
Message-ID: <YhZ5GdNmMiyLeMdq@sirena.org.uk>
Mail-Followup-To: =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
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
 <YhZxyluc7gYhmAuh@sirena.org.uk>
 <20220223185927.2d272e3a@fixe.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="aioSh2WXTdqVU4I3"
Content-Disposition: inline
In-Reply-To: <20220223185927.2d272e3a@fixe.home>
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


--aioSh2WXTdqVU4I3
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 23, 2022 at 06:59:27PM +0100, Cl=E9ment L=E9ger wrote:
> Mark Brown <broonie@kernel.org> a =E9crit :

> > This doesn't look like it's trying to use a DT on an ACPI system though?

> Ideally no, but it is a possibility mentionned by Andrew, use DT
> overlays on an ACPI system. This series did not took this way (yet).
> Andrew mentionned that it could potentially be done but judging by your
> comment, i'm not sure you agree with that.

That seems like it's opening a can of worms that might be best left
closed.

> > There's been some discussion on how to handle loadable descriptions for
> > things like FPGA but I don't recall it ever having got anywhere concrete
> > - I could have missed something.  Those are dynamic cases which are more
> > trouble though.  For something that's a PCI card it's not clear that we
> > can't just statically instanitate the devices from kernel code, that was
> > how the MFD subsystem started off although it's now primarily applied to
> > other applications.  That looks to be what's going on here?

> Yes, in this series, I used the MFD susbsytems with mfd_cells. These
> cells are attached with a swnode. Then, needed subsystems are
> modified to use the fwnode API to be able to use them with
> devices that have a swnode as a primary node.

Note that not all subsystems are going to be a good fit for fwnode, it's
concerning for the areas where ACPI and DT have substantially different
models like regulators.

> > There were separately some issues with people trying to create
> > completely swnode based enumeration mechanisms for things that required
> > totally independent code for handling swnodes which seemed very
> > concerning but it's not clear to me if that's what's going on here.

> The card is described entirely using swnode that in a MFD PCI
> driver, everything is described statically. The "enumeration" is static
> since all the devices are described in the driver and registered using
> mfd_add_device() at probe time. Thus, I don't think it adds an
> enumeration mechanism like you mention but I may be wrong.

This was all on the side parsing the swnodes rather than injecting the
data.

--aioSh2WXTdqVU4I3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmIWeRkACgkQJNaLcl1U
h9De9Af9HAjJF+uaedpeEh9o3qAvgjP/PjGuPe8DDeRUH58tPmJ83dCsKdhiU/l3
/JGzw+qrK0G5CTRxiUSvXLp9r0yEPLjhB5PxK0uWS0ml8qXsk75dsgY+JW8wNsWn
y8SRadWu+oqc55LqBzJXK9FvZWF5/56+DWEYv9/+qhWvdTmvYU8x2n8X2XcBVm96
iSFYBZdt8zF24j81TmlzKdmReVWEBTgk2O59eSlOM98O+pwwX97NjrQ4ih0QD/T1
jMHsXA9X0dm4skQVieOo3of7Fy1Awn/5b1bCjed/gHZHCvEZGsp1wDS4u3+iWCce
njl1APIIambBTHA0JU24pDHV/w7OQA==
=0VBQ
-----END PGP SIGNATURE-----

--aioSh2WXTdqVU4I3--
