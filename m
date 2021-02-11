Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71992318A4E
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 13:21:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231842AbhBKMVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 07:21:20 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:36570 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231807AbhBKMSO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 07:18:14 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 7EDFD1C0B8A; Thu, 11 Feb 2021 13:17:02 +0100 (CET)
Date:   Thu, 11 Feb 2021 13:17:02 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Claudiu.Beznea@microchip.com, linux@armlinux.org.uk,
        andrew@lunn.ch, davem@davemloft.net, kuba@kernel.org,
        rjw@rjwysocki.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH] net: phy: micrel: reconfigure the phy on resume
Message-ID: <20210211121701.GA31708@amd>
References: <1610120754-14331-1-git-send-email-claudiu.beznea@microchip.com>
 <25ec943f-ddfc-9bcd-ef30-d0baf3c6b2a2@gmail.com>
 <ce20d4f3-3e43-154a-0f57-2c2d42752597@microchip.com>
 <ee0fd287-c737-faa5-eee1-99ffa120540a@gmail.com>
 <ae4e73e9-109f-fdb9-382c-e33513109d1c@microchip.com>
 <7976f7df-c22f-d444-c910-b0462b3d7f61@gmail.com>
 <d9fcf8da-c0b0-0f18-48e9-a7534948bc93@microchip.com>
 <20210114102508.GO1551@shell.armlinux.org.uk>
 <fe4c31a0-b807-0eb2-1223-c07d7580e1fc@microchip.com>
 <56366231-4a1f-48c3-bc29-6421ed834bdf@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="zYM0uCDKw75PZbzx"
Content-Disposition: inline
In-Reply-To: <56366231-4a1f-48c3-bc29-6421ed834bdf@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu 2021-01-14 12:05:21, Heiner Kallweit wrote:
> On 14.01.2021 11:41, Claudiu.Beznea@microchip.com wrote:
> >=20
> >=20
> > On 14.01.2021 12:25, Russell King - ARM Linux admin wrote:
> >>
> >> As I've said, if phylib/PHY driver is not restoring the state of the
> >> PHY on resume from suspend-to-ram, then that's an issue with phylib
> >> and/or the phy driver.
> >=20
> > In the patch I proposed in this thread the restoring is done in PHY dri=
ver.
> > Do you think I should continue the investigation and check if something
> > should be done from the phylib itself?
> >=20
> It was the right move to approach the PM maintainers to clarify whether
> the resume PM callback has to assume that power had been cut off and
> it has to completely reconfigure the device. If they confirm this
> understanding, then:

Power to some devices can be cut during s2ram, yes.

> - the general question remains why there's separate resume and restore
>   callbacks, and what restore is supposed to do that resume doesn't
>   have to do

You'll often have same implementation, yes.

> - it should be sufficient to use mdio_bus_phy_restore also as resume
>   callback (instead of changing each and every PHY driver's resume),
>   because we can expect that somebody cutting off power to the PHY
>   properly suspends the MDIO bus before

If restore works with power cut and power not cut then yes, you should
get away with that.

Best regards,
								Pavel
--=20
http://www.livejournal.com/~pavelmachek

--zYM0uCDKw75PZbzx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmAlID0ACgkQMOfwapXb+vIv2QCgi63lZx/G4VQq5XuwoAFXDZNf
YVoAoJmUbtI7+OYCqXQ1Lww9/y/ctYcK
=UH1n
-----END PGP SIGNATURE-----

--zYM0uCDKw75PZbzx--
