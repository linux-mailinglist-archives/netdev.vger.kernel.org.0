Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB59F2645E4
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 14:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730635AbgIJMWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 08:22:38 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:41312 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730244AbgIJMUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 08:20:11 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 9ADC91C0B9C; Thu, 10 Sep 2020 14:20:02 +0200 (CEST)
Date:   Thu, 10 Sep 2020 14:20:02 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, linux-leds@vger.kernel.org,
        Dan Murphy <dmurphy@ti.com>,
        =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next + leds v2 3/7] net: phy: add simple incrementing
 phyindex member to phy_device struct
Message-ID: <20200910122002.GA7907@duo.ucw.cz>
References: <20200909162552.11032-1-marek.behun@nic.cz>
 <20200909162552.11032-4-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="82I3+IH0IqGh5yIs"
Content-Disposition: inline
In-Reply-To: <20200909162552.11032-4-marek.behun@nic.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> names are not suited for this, since in some situations a PHY device
> name can look like this
>   d0032004.mdio-mii:01
> or even like this
>   /soc/internal-regs@d0000000/mdio@32004/switch0@10/mdio:08
> Clearly this cannot be used as the `device` part of a LED name.
>=20
> Signed-off-by: Marek Beh=FAn <marek.behun@nic.cz>
> ---
>  drivers/net/phy/phy_device.c | 3 +++
>  include/linux/phy.h          | 3 +++
>  2 files changed, 6 insertions(+)
>=20
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 8adfbad0a1e8f..38f56d39f1229 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -9,6 +9,7 @@
> =20
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> =20
> +#include <linux/atomic.h>
>  #include <linux/bitmap.h>
>  #include <linux/delay.h>
>  #include <linux/errno.h>
> @@ -892,6 +893,7 @@ EXPORT_SYMBOL(get_phy_device);
>   */
>  int phy_device_register(struct phy_device *phydev)
>  {
> +	static atomic_t phyindex;
>  	int err;
> =20
>  	err =3D mdiobus_register_device(&phydev->mdio);

I'd put the static out of the function... for greater visibility.

Otherwise: Reviewed-by: Pavel Machek <pavel@ucw.cz>

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--82I3+IH0IqGh5yIs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX1oZ8gAKCRAw5/Bqldv6
8lBYAJ9tS6CVdgWfqKytotcj0k55tsWyTwCggMTOOpigKRw1boHuGHYIF6icthI=
=pvlr
-----END PGP SIGNATURE-----

--82I3+IH0IqGh5yIs--
