Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1783F256AA9
	for <lists+netdev@lfdr.de>; Sun, 30 Aug 2020 00:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728591AbgH2Wny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Aug 2020 18:43:54 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:55716 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728246AbgH2Wny (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Aug 2020 18:43:54 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id AD3B31C0B80; Sun, 30 Aug 2020 00:43:52 +0200 (CEST)
Date:   Sun, 30 Aug 2020 00:43:51 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>,
        netdev@vger.kernel.org, linux-leds@vger.kernel.org,
        jacek.anaszewski@gmail.com, Dan Murphy <dmurphy@ti.com>,
        =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC leds + net-next v4 0/2] Add support for LEDs on
 Marvell PHYs
Message-ID: <20200829224351.GA29564@duo.ucw.cz>
References: <20200728150530.28827-1-marek.behun@nic.cz>
 <20200807090653.ihnt2arywqtpdzjg@duo.ucw.cz>
 <20200807132920.GB2028541@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="XsQoSWH+UP9D9v3l"
Content-Disposition: inline
In-Reply-To: <20200807132920.GB2028541@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > And no, I don't want phydev name there.
> >=20
> > Ummm. Can we get little more explanation on that? I fear that LED
> > device renaming will be tricky and phydev would work around that
> > nicely.
>=20
> Hi Pavel
>=20
> The phydev name is not particularly nice:
>=20
> !mdio-mux!mdio@1!switch@0!mdio:00
> !mdio-mux!mdio@1!switch@0!mdio:01
> !mdio-mux!mdio@1!switch@0!mdio:02
> !mdio-mux!mdio@2!switch@0!mdio:00
> !mdio-mux!mdio@2!switch@0!mdio:01
> !mdio-mux!mdio@2!switch@0!mdio:02
> !mdio-mux!mdio@4!switch@0!mdio:00
> !mdio-mux!mdio@4!switch@0!mdio:01
> !mdio-mux!mdio@4!switch@0!mdio:02
> 400d0000.ethernet-1:00
> 400d0000.ethernet-1:01
> fixed-0:00

Not nice, I see. In particular, it contains ":"... which would be a
problem.

> The interface name are:
>=20
> 1: lo:
> 2: eth0:
> 3: eth1:
> 4: lan0@eth1:
> 5: lan1@eth1:
> 6: lan2@eth1:
> 7: lan3@eth1:
> 8: lan4@eth1:
> 9: lan5@eth1:
> 10: lan6@eth1:
> 11: lan7@eth1:
> 12: lan8@eth1:
> 13: optical3@eth1:
> 14: optical4@eth1:

OTOH... renaming LEDs when interface is renamed... sounds like a
disaster, too.

> You could make a good guess at matching to two together, but it is
> error prone. Phys are low level things which the user is not really
> involved in. They interact with interface names. ethtool, ip, etc, all
> use interface names. In fact, i don't know of any tool which uses
> phydev names.

So... proposal:

Users should not be dealing with sysfs interface directly, anyway. We
should have a tool for that. It can live in kernel/tools somewhere, I
guess.

Would we name leds phy0:... (with simple incrementing number), and
expose either interface name or phydev name as a attribute?

So user could do

cat /sys/class/leds/phy14:green:foobar/netdev
lan5@eth1:

and we'd have tool hiding that complexity...

Best regards,

									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--XsQoSWH+UP9D9v3l
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX0raJwAKCRAw5/Bqldv6
8sfUAJ0cqJ5B527YHsG7UuRjZhoR1Ld+FQCaAm2iDmKu/TBPUAV8G0hFspvDSEY=
=/Jnn
-----END PGP SIGNATURE-----

--XsQoSWH+UP9D9v3l--
