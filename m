Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15F333D164A
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 20:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239097AbhGURmk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 13:42:40 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:35826 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239055AbhGURmk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 13:42:40 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 147D91C0B77; Wed, 21 Jul 2021 20:23:15 +0200 (CEST)
Date:   Wed, 21 Jul 2021 20:23:14 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        kuba@kernel.org, Kurt Kanzenbach <kurt@linutronix.de>,
        netdev@vger.kernel.org, sasha.neftin@intel.com,
        vitaly.lifshits@intel.com, vinicius.gomes@intel.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>
Subject: Re: [PATCH net-next 5/5] igc: Export LEDs
Message-ID: <20210721182314.GA7554@duo.ucw.cz>
References: <20210716212427.821834-1-anthony.l.nguyen@intel.com>
 <20210716212427.821834-6-anthony.l.nguyen@intel.com>
 <f705bcd6-c55c-0b07-612f-38348d85bbee@gmail.com>
 <YPTKB0HGEtsydf9/@lunn.ch>
 <88d23db8-d2d2-5816-6ba1-3bd80738c398@gmail.com>
 <YPbu8xOFDRZWMTBe@lunn.ch>
 <3b7ad100-643e-c173-0d43-52e65d41c8c3@gmail.com>
 <YPgwr2MB5gQVgDff@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="PEIAKu/WMn1b1Hv9"
Content-Disposition: inline
In-Reply-To: <YPgwr2MB5gQVgDff@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed 2021-07-21 16:35:27, Andrew Lunn wrote:
> > Thanks for the hint, Andrew. If I make &netdev->dev the parent,
> > then I get:
> >=20
> > ll /sys/class/leds/
> > total 0
> > lrwxrwxrwx 1 root root 0 Jul 20 21:37 led0 -> ../../devices/pci0000:00/=
0000:00:1d.0/0000:03:00.0/net/enp3s0/led0
> > lrwxrwxrwx 1 root root 0 Jul 20 21:37 led1 -> ../../devices/pci0000:00/=
0000:00:1d.0/0000:03:00.0/net/enp3s0/led1
> > lrwxrwxrwx 1 root root 0 Jul 20 21:37 led2 -> ../../devices/pci0000:00/=
0000:00:1d.0/0000:03:00.0/net/enp3s0/led2
> >=20
> > Now the (linked) LED devices are under /sys/class/net/<ifname>, but sti=
ll
> > the primary LED devices are under /sys/class/leds and their names have
> > to be unique therefore. The LED subsystem takes care of unique names,
> > but in case of a second network interface the LED device name suddenly
> > would be led0_1 (IIRC). So the names wouldn't be predictable, and I thi=
nk
> > that's not what we want.
>=20
> We need input from the LED maintainers, but do we actually need the
> symbolic links in /sys/class/leds/? For this specific use case, not
> generally. Allow an LED to opt out of the /sys/class/leds symlink.
>=20
> If we could drop those, we can relax the naming requirements so that
> the names is unique to a parent device, not globally unique.

Well, I believe we already negotiated acceptable naming with
Marek... Is it unsuitable for some reason?



--=20
http://www.livejournal.com/~pavelmachek

--PEIAKu/WMn1b1Hv9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYPhmEgAKCRAw5/Bqldv6
8mBJAKCEb0emOi5qDSkfBq2L+zhUmNDX9ACgrG/6tjLj4/uNrFftZxnju6hUsf8=
=YoCP
-----END PGP SIGNATURE-----

--PEIAKu/WMn1b1Hv9--
