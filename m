Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE80152BD7A
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 16:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238156AbiERN3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 09:29:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238151AbiERN3F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 09:29:05 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 356DE1BE96B
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 06:28:25 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nrJin-0006xP-9T; Wed, 18 May 2022 15:28:13 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id EF3A7814A6;
        Wed, 18 May 2022 13:28:11 +0000 (UTC)
Date:   Wed, 18 May 2022 15:28:11 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        Max Staudt <max@enpas.org>, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 3/4] can: skb:: move can_dropped_invalid_skb and
 can_skb_headroom_valid to skb.c
Message-ID: <20220518132811.xfmwms2cu3bfxgrp@pengutronix.de>
References: <20220517060821.akuqbqxro34tj7x6@pengutronix.de>
 <CAMZ6RqJ3sXYUOpw7hEfDzj14H-vXK_i+eYojBk2Lq=h=7cm7Jg@mail.gmail.com>
 <20220517104545.eslountqjppvcnz2@pengutronix.de>
 <e054f6d4-7ed1-98ac-8364-425f4ef0f760@hartkopp.net>
 <20220517141404.578d188a.max@enpas.org>
 <20220517122153.4r6n6kkbdslsa2hv@pengutronix.de>
 <20220517143921.08458f2c.max@enpas.org>
 <0b505b1f-1ee4-5a2c-3bbf-6e9822f78817@hartkopp.net>
 <CAMZ6RqJ0iCsHT-D5VuYQ9fk42ZEjHStU1yW0RfX1zuJpk5rVtQ@mail.gmail.com>
 <43768ff7-71f8-a6c3-18f8-28609e49eedd@hartkopp.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="43mv6ogbut5bwzf7"
Content-Disposition: inline
In-Reply-To: <43768ff7-71f8-a6c3-18f8-28609e49eedd@hartkopp.net>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--43mv6ogbut5bwzf7
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 18.05.2022 15:10:44, Oliver Hartkopp wrote:
> On 18.05.22 14:03, Vincent MAILHOL wrote:
> > I didn't think this would trigger such a passionate discussion!
>=20
> :-D
>
> Maybe your change was the drop that let the bucket run over ;-)

It's so trivial that everybody feels the urge to say something. :D

> > > But e.g. the people that are running Linux instances in a cloud only
> > > using vcan and vxcan would not need to carry the entire infrastructure
> > > of CAN hardware support and rx-offload.
> >=20
> > Are there really some people running custom builds of the Linux kernel
> > in a cloud environment? The benefit of saving a few kilobytes by not
> > having to carry the entire CAN hardware infrastructure is blown away
> > by the cost of having to maintain a custom build.
>=20
> When looking to the current Kconfig and Makefile content in
> drivers/net/can(/dev) there is also some CONFIG_CAN_LEDS which "depends on
> BROKEN" and builds a leds.o from a non existing leds.c ?!?
>=20
> Oh leds.c is in drivers/net/can/leds.c but not in drivers/net/can/dev/led=
s.c
> where it could build ... ?
>=20
> So what I would suggest is that we always build a can-dev.ko when a CAN
> driver is needed.
>=20
> Then we have different options that may be built-in:
>=20
> 1. netlink hw config interface
> 2. bitrate calculation
> 3. rx-offload
> 4. leds
>=20
> E.g. having the netlink interface without bitrate calculation does not ma=
ke
> sense to me too.

ACK

> > I perfectly follow the idea to split rx-offload. Integrators building
> > some custom firmware for an embedded device might want to strip out
> > any unneeded piece. But I am not convinced by this same argument when
> > applied to v(x)can.
>=20
> It does. I've seen CAN setups (really more than one or two!) in VMs and
> container environments that are fed by Ethernet tunnels - sometimes also =
in
> embedded devices.
>=20
> > A two level split (with or without rx-offload) is what makes the most
> > sense to me.
> >=20
> > Regardless, having the three level split is not harmful. And because
> > there seems to be a consensus on that, I am fine to continue in this
> > direction.
>=20
> Thanks!
>=20
> Should we remove the extra option for the bitrate calculation then?

+1

> And what about the LEDS support depending on BROKEN?
> That was introduced by commit 30f3b42147ba6f ("can: mark led trigger as
> broken") from Uwe as it seems there were some changes in 2018.

There's a proper generic LED trigger now for network devices. So remove
LED triggers, too.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--43mv6ogbut5bwzf7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKE9GgACgkQrX5LkNig
013/Rgf9Eov4y1zksOqRf5lhd3kxutLaOL3d+BBBq7uExlRmSMhiFPOetpn22wWy
jHYM1Pouoq8/Vpznk3EMv2AKlitfeoNtwYHJDAAWwgrhnB4ok0L9/YjDJWwy+e/F
t01PYBs3tXMkII8nGI3wZhiY7rkmtcrcI5IMHoiSC6abpCxOcqp3R6vqyIytC0tH
2hUg5j69Y1Z4+ZtDGuV1oHcizJZ2nVFpzXwguszU+2x2rYZtXSevUzcuSqWhpUHK
XTUlzW+IH/pjL2d4aYSZAkE7ZBhzrY33BMk8Vqk5W5Ko4zjVx4Rn7fDVo4S7UrL2
SEsZnDXDsGJ/iZBie/JoGTe5Z5sfRg==
=51BL
-----END PGP SIGNATURE-----

--43mv6ogbut5bwzf7--
