Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7642C4058
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 13:38:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgKYMiT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 07:38:19 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:44114 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbgKYMiT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 07:38:19 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 75AE61C0B7D; Wed, 25 Nov 2020 13:38:17 +0100 (CET)
Date:   Wed, 25 Nov 2020 13:38:17 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, linux-leds@vger.kernel.org,
        Dan Murphy <dmurphy@ti.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Ben Whitten <ben.whitten@gmail.com>
Subject: Re: [PATCH RFC leds + net-next 7/7] net: phy: marvell: support LEDs
 connected on Marvell PHYs
Message-ID: <20201125123817.GI29328@amd>
References: <20201030114435.20169-1-kabel@kernel.org>
 <20201030114435.20169-8-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="svExV93C05KqedWb"
Content-Disposition: inline
In-Reply-To: <20201030114435.20169-8-kabel@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--svExV93C05KqedWb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> +/* FIXME: Blinking rate is shared by all LEDs on a PHY. Should we check =
whether
> + * another LED is currently blinking with incompatible rate? It would be=
 cleaner
> + * if we in this case failed to offload blinking this LED.
> + * But consider this situation:
> + *   1. user sets LED[1] to blink with period 500ms for some reason. Thi=
s would
> + *      start blinking LED[1] with perion 670ms here

period.

> + *   2. user sets netdev trigger to LED[0] to blink on activity, default=
 there
> + *      is 100ms period, which would translate here to 84ms. This is
> + *      incompatible with the already blinking LED, so we fail to offloa=
d to HW,
> + *      and netdev trigger does software offloading instead.
> + *   3. user unsets blinking od LED[1], so now we theoretically can offl=
oad
> + *      netdev trigger to LED[0], but we don't know about it, and so it =
is left
> + *      in SW triggering until user writes the settings again
> + * This could be solved by the netdev trigger periodically trying to off=
load to
> + * HW if we reported that it is theoretically possible (by returning -EA=
GAIN
> + * instead of -EOPNOTSUPP, for example). Do we want to do this?
> + */

I believe we should check & fallback to software if there's already
incompatible rate in use. No need to periodically re-try to activate
the offload.

Best regards,
								Pavel

--=20
http://www.livejournal.com/~pavelmachek

--svExV93C05KqedWb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl++UDgACgkQMOfwapXb+vLU+QCeIvaVls1D/9bwcT1TryOay98A
4OcAoJb1JLKf2Wm28zSTI1HPjyhcwf2K
=17Ul
-----END PGP SIGNATURE-----

--svExV93C05KqedWb--
