Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13893207049
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 11:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389920AbgFXJnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 05:43:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:45474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388005AbgFXJnG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 05:43:06 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7102C20885;
        Wed, 24 Jun 2020 09:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592991785;
        bh=rYiMLNyH6eejq1M7FI0t8GXIQIY1y4HUlGHPYP73bvA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iMQawrP4gD/kEbaeFzV0OLvI9+7NVkmw8/GoJ2aEPtRKA/jirfzwFYy0L5Y/OzPCu
         xisKHDnJn2fl+MFySaTny0zOqs4oZxopj5XvUAjHuCdvuRhKkw4v/EbNApMnkwuGh8
         +rPE3Bwi4OtimVg+6yswW8FMP+j9M58H929pco0w=
Date:   Wed, 24 Jun 2020 10:43:02 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Bartosz Golaszewski <brgl@bgdev.pl>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Liam Girdwood <lgirdwood@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Fabien Parent <fparent@baylibre.com>,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: Re: [PATCH 09/15] net: phy: delay PHY driver probe until PHY
 registration
Message-ID: <20200624094302.GA5472@sirena.org.uk>
References: <20200622093744.13685-1-brgl@bgdev.pl>
 <20200622093744.13685-10-brgl@bgdev.pl>
 <20200622133940.GL338481@lunn.ch>
 <20200622135106.GK4560@sirena.org.uk>
 <dca54c57-a3bd-1147-63b2-4631194963f0@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="X1bOJ3K7DJ5YkBrT"
Content-Disposition: inline
In-Reply-To: <dca54c57-a3bd-1147-63b2-4631194963f0@gmail.com>
X-Cookie: So this is it.  We're going to die.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 23, 2020 at 12:49:15PM -0700, Florian Fainelli wrote:
> On 6/22/20 6:51 AM, Mark Brown wrote:

> > If the bus includes power management for the devices on the bus the
> > controller is generally responsible for that rather than the devices,
> > the devices access this via facilities provided by the bus if needed.
> > If the device is enumerated by firmware prior to being physically
> > enumerable then the bus will generally instantiate the device model
> > device and then arrange to wait for the physical device to appear and
> > get joined up with the device model device, typically in such situations
> > the physical device might appear and disappear dynamically at runtime
> > based on what the driver is doing anyway.

> In premise there is nothing that prevents the MDIO bus from taking care
> of the regulators, resets, prior to probing the PHY driver, what is
> complicated here is that we do need to issue a read of the actual PHY to
> know its 32-bit unique identifier and match it with an appropriate
> driver. The way that we have worked around this with if you do not wish
> such a hardware access to be made, is to provide an Ethernet PHY node
> compatible string that encodes that 32-bit OUI directly. In premise the
> same challenges exist with PCI devices/endpoints as well as USB, would
> they have reset or regulator typically attached to them.

That all sounds very normal and is covered by both cases I describe?

> > We could use a pre-probe stage in the device model for hotpluggable
> > buses in embedded contexts where you might need to bring things out of
> > reset or power them up before they'll appear on the bus for enumeration
> > but buses have mostly handled that at their level.

> That sounds like a better solution, are there any subsystems currently
> implementing that, or would this be a generic Linux device driver model
> addition that needs to be done?

Like I say I'm suggesting doing something at the device model level.

--X1bOJ3K7DJ5YkBrT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl7zICMACgkQJNaLcl1U
h9Ca2Af/csONj6LtRsNrXjMLjw4BGVBnwP/tZBvSxig6MizM80Yd7HzvQiUWDAQW
opLo3gkpbl+73elKt2hSf5gktte6pl5jBepYzqd54u71xWQ6bZE4U3ONtKN2Q7eb
b2CIxsthUl15y6Y+spJAGYjqB7+3JSU4j60NpuRAnH25gsxkJyokoyDQNwz3/itl
CJcvpaKru9uCPKXfk960C6SkRpX0kNfFc3yBm7yFTIMeiicFei9o/qdEBzqaRC/8
Plrsjw9hilHtWP4/3AhHXk98OGzuTzYSS78XVYRGBC58Wj7IDO+ytY5mCR7mZdtg
gZPYYA7XHRNX3252/FCJO39GTfJMCg==
=ttw3
-----END PGP SIGNATURE-----

--X1bOJ3K7DJ5YkBrT--
