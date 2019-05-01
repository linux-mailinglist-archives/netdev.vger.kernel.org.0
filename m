Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5419D10E18
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 22:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726186AbfEAUdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 16:33:41 -0400
Received: from hall.aurel32.net ([195.154.113.88]:57888 "EHLO hall.aurel32.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726077AbfEAUdl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 May 2019 16:33:41 -0400
Received: from [2a01:e35:2fdd:a4e1:fe91:fc89:bc43:b814] (helo=ohm.rr44.fr)
        by hall.aurel32.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <aurelien@aurel32.net>)
        id 1hLvv4-0007Of-EU; Wed, 01 May 2019 22:33:34 +0200
Received: from aurel32 by ohm.rr44.fr with local (Exim 4.92)
        (envelope-from <aurelien@aurel32.net>)
        id 1hLvv2-0005fZ-DI; Wed, 01 May 2019 22:33:32 +0200
Date:   Wed, 1 May 2019 22:33:32 +0200
From:   Aurelien Jarno <aurel32@debian.org>
To:     Uwe =?iso-8859-15?Q?Kleine-K=F6nig?= <uwe@kleine-koenig.org>
Cc:     927825@bugs.debian.org, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        netdev@vger.kernel.org, Marcin Wojtas <mw@semihalf.com>,
        Steve McIntyre <steve@einval.com>
Subject: Re: Bug#927825: arm: mvneta driver used on Armada XP GP boards does
 not receive packets (regression from 4.9)
Message-ID: <20190501203332.GA16945@aurel32.net>
References: <155605060923.15313.17004641650838278623.reportbug@ohm.local>
 <155605060923.15313.17004641650838278623.reportbug@ohm.local>
 <20190425125046.GA7210@aurel32.net>
 <155605060923.15313.17004641650838278623.reportbug@ohm.local>
 <20190425191732.GA28481@aurel32.net>
 <20190430081223.GA7409@taurus.defre.kleine-koenig.org>
 <20190430220421.GA3750@aurel32.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="7JfCtLOvnd9MIVvH"
Content-Disposition: inline
In-Reply-To: <20190430220421.GA3750@aurel32.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On 2019-05-01 00:04, Aurelien Jarno wrote:
> On 2019-04-30 10:12, Uwe Kleine-K=F6nig wrote:
> > > > More precisely the board is a "Marvell Armada XP Development Board
> > > > DB-MV784MP-GP"
> > > >=20
> > > > > anymore. Using tcpdump on both the buildd and a remote host, it a=
ppears
> > > > > that the packets correctly leave the board and that the reception=
 side
> > > > > fails.
> >=20
> > If you can send to a remote host at least ARP (or ND) must be working,
> > so some reception still works, right?
>=20
> I have to try again, but what i have seen is the ARP requests from
> hartmann arriving to the other hosts on the subnet. Steve McIntyre
> (added in Cc:) confirmed me on IRC being able to reproduce the issue on
> another board.

I confirm that. Basically on the other hosts of the same subnet, I can
see the ARP requests:

18:23:45.979860 ARP, Request who-has 172.28.17.1 tell 172.28.17.18, length =
46
18:23:47.002990 ARP, Request who-has 172.28.17.1 tell 172.28.17.18, length =
46
18:23:48.027262 ARP, Request who-has 172.28.17.1 tell 172.28.17.18, length =
46
18:23:52.004248 ARP, Request who-has 172.28.17.1 tell 172.28.17.18, length =
46
18:23:53.019252 ARP, Request who-has 172.28.17.1 tell 172.28.17.18, length =
46
18:23:54.043276 ARP, Request who-has 172.28.17.1 tell 172.28.17.18, length =
46
18:23:58.027937 ARP, Request who-has 172.28.17.1 tell 172.28.17.18, length =
46

172.28.17.1 is the gateway, 172.28.17.18 is hartmann.d.o.=20

> > Is it possible to test a few things on hartmann? I'd suggest:
> >=20
> >  - try (vanilla) 5.1-rc6 with MVNETA=3Dy

I have tried 5.1-rc7 with:

CONFIG_MVNETA_BM_ENABLE=3Dy
CONFIG_MVNETA=3Dy
CONFIG_MVNETA_BM=3Dy

and also with

CONFIG_MVNETA_BM_ENABLE=3Dm
CONFIG_MVNETA=3Dm
CONFIG_MVNETA_BM=3Dm

And the mvneta network driver is not able to receive data in both cases.

Best regards,
Aurelien

--=20
Aurelien Jarno                          GPG: 4096R/1DDD8C9B
aurelien@aurel32.net                 http://www.aurel32.net

--7JfCtLOvnd9MIVvH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEUryGlb40+QrX1Ay4E4jA+JnoM2sFAlzKApwACgkQE4jA+Jno
M2urNxAAhHBUz4Waj/F2us+1M/q3Bu6051EsM2Aw90jBdYlIRplMD2TzuaBR2i6G
Bni6uZcCg/wAI85cnmCTrYZ02dOcdaFYMYZiKt4n5NPWwUtgBh3g+TMtGawDsJG0
sCwzBeHsgs88fwML0zmLhJ964bjMQCkz2ma0+R+9j4df2Y8vV8S50G6DwR7bQ/GP
ObAY3ayWPeZ0Gy5dgZ9457r4K9GWNakYuGPJ2WhCnkgoYEYkSHSwpALiSDTs6mII
3TXDvE2YI/qyV8fqNnivVkK5vgAl16d1NjJ+Lg0HpDs+DV2liXBWF28pKzfJCDzC
h4cFaAIxbwXQ1jY/jBiu37tMgJYP44kYKbVhxzn/L4AmkHBjdhKNl3zPzPF5XTTN
mub0LYM8T9oiGFpswxBalgby1yPKYMD6T4fV5GYJ5Y9+9UedlRbiBzSsWnZSToJ1
zgrF+hZ0xkpTV9QztYcoFAItdtYSeqFCitgO/jItQl4T3TX05ZLeshI/SsX0pnPy
lvHCwtfNwZI79SOe8QEj977oC4z3JQQGCtFzeyqCz23qZFY4YPjArJFYDGOj5N/8
izmF3jxqfhL+d/eY4pElb2USPwmjdjXopedHuCkiYqHc0i1M/NRstX4uLcwVoWDU
iur6TJ+Qrg8qkhC1QRz7Cz55sgHtHG13qb+0RWy7vTGB1JywywA=
=p+3n
-----END PGP SIGNATURE-----

--7JfCtLOvnd9MIVvH--
