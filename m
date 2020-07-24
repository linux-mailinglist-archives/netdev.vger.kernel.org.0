Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA4822C31C
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 12:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbgGXK3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 06:29:06 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:44866 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbgGXK3F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 06:29:05 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 2AACD1C0BD2; Fri, 24 Jul 2020 12:29:02 +0200 (CEST)
Date:   Fri, 24 Jul 2020 12:29:01 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Marek =?utf-8?B?QmVow7pu?= <marek.behun@nic.cz>
Cc:     linux-leds@vger.kernel.org, jacek.anaszewski@gmail.com,
        Dan Murphy <dmurphy@ti.com>,
        =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>,
        netdev@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC leds + net-next v2 0/1] Add support for LEDs on
 Marvell PHYs
Message-ID: <20200724102901.qp65rtkxucauglsp@duo.ucw.cz>
References: <20200723181319.15988-1-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="pj7n3lfazigoupyj"
Content-Disposition: inline
In-Reply-To: <20200723181319.15988-1-marek.behun@nic.cz>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--pj7n3lfazigoupyj
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu 2020-07-23 20:13:18, Marek Beh=FAn wrote:
> Hi,
>=20
> this is v2 of my RFC adding support for LEDs connected to Marvell PHYs.
>=20
> The LED subsystem patches are not contained:
> - the patch adding support for LED private triggers is already accepted
>   in Pavel Machek's for-next tree.
>   If you want to try this patch on top of net-next, please also apply
>   https://git.kernel.org/pub/scm/linux/kernel/git/pavel/linux-leds.git/co=
mmit/?h=3Dfor-next&id=3D93690cdf3060c61dfce813121d0bfc055e7fa30d
> - the other led-trigger patch is not needed in this version of the RFC
>=20
> The main difference from v1 is that only one trigger, named
> "hw-control", is added to the /sys/class/leds/<LED>/trigger file.
>=20
> When this trigger is activated, another file called "hw_control" is
> created in the /sys/class/leds/<LED>/ directory. This file lists
> available HW control modes for this LED in the same way the trigger
> file does for triggers.
>=20
> Example:
>=20
>   # cd /sys/class/leds/eth0\:green\:link/
>   # cat trigger
>   [none] hw-control timer oneshot heartbeat ...
>   # echo hw-control >trigger

Make this "hw-phy-mode" or something. hw-control is a bit too generic.

>   # cat trigger
>   none [hw-control] timer oneshot heartbeat ...
>   # cat hw_control
>   link/nolink link/act/nolink 1000/100/10/nolink act/noact
>   blink-act/noact transmit/notransmit copperlink/else [1000/else]
>   force-hi-z force-blink
>   # echo 1000/100/10/nolink >hw_control
>   # cat hw_control
>   link/nolink link/act/nolink [1000/100/10/nolink] act/noact
>   blink-act/noact transmit/notransmit copperlink/else 1000/else
>   force-hi-z force-blink
>=20
> The benefit here is that only one trigger is registered via LED API.
> I guess there are other PHY drivers which too support HW controlled
> blinking modes. So of this way of controlling PHY LED HW controlled
> modes is accepted, the code creating the hw-control trigger and
> hw_control file should be made into library code so that it can be
> reused.
>=20
> What do you think?

So.. you have 10 of them right now. I guess both hw_control and making
it into the trigger directly is acceptable here.

In future, would you expect having software "1000/100/10/nolink"
triggers I could activate on my scrollock LED (or on GPIO controlled
LEDs) to indicate network activity?

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--pj7n3lfazigoupyj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXxq37QAKCRAw5/Bqldv6
8s8VAKCscET8lo4WWmkdRQg79/ZmaIn60wCgjFAt0j1QgaN7Erm+//4upTRKchY=
=k67K
-----END PGP SIGNATURE-----

--pj7n3lfazigoupyj--
