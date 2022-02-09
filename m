Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C97A24AEB61
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 08:46:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233163AbiBIHqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 02:46:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238418AbiBIHpm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 02:45:42 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A643C0612C3
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 23:45:46 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nHhfY-0002CG-C6; Wed, 09 Feb 2022 08:45:40 +0100
Received: from pengutronix.de (unknown [195.138.59.174])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id E62CC2EED2;
        Wed,  9 Feb 2022 07:45:36 +0000 (UTC)
Date:   Wed, 9 Feb 2022 08:45:33 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next] can: gw: use call_rcu() instead of costly
 synchronize_rcu()
Message-ID: <20220209074533.hxjhz7xiqfpdpbgq@pengutronix.de>
References: <20220207190706.1499190-1-eric.dumazet@gmail.com>
 <43ec78a3-2cde-35c4-51e9-de72d00fbe99@hartkopp.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="x4ha2wgcxwosjute"
Content-Disposition: inline
In-Reply-To: <43ec78a3-2cde-35c4-51e9-de72d00fbe99@hartkopp.net>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--x4ha2wgcxwosjute
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 08.02.2022 20:27:31, Oliver Hartkopp wrote:
>=20
>=20
> On 07.02.22 20:07, Eric Dumazet wrote:
> > From: Eric Dumazet <edumazet@google.com>
> >=20
> > Commit fb8696ab14ad ("can: gw: synchronize rcu operations
> > before removing gw job entry") added three synchronize_rcu() calls
> > to make sure one rcu grace period was observed before freeing
> > a "struct cgw_job" (which are tiny objects).
> >=20
> > This should be converted to call_rcu() to avoid adding delays
> > in device / network dismantles.
> >=20
> > Use the rcu_head that was already in struct cgw_job,
> > not yet used.
> >=20
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Cc: Oliver Hartkopp <socketcan@hartkopp.net>
>=20
> Tested-by: Oliver Hartkopp <socketcan@hartkopp.net>

Applied to linux-can-next/testing.

There are several more synchronize_rcu() in net/can. Oliver, can you
create similar patches for those?

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--x4ha2wgcxwosjute
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmIDcRkACgkQrX5LkNig
013dlAf/fZZ7vxoGTT2jONTjBvz0v+28qMw3WUQwnvBHGIrF+O0Js4eOCJ1+nb8w
AtDo82P5oBuhMgPL+/d0LgRioZtm3PeiWgoeyQ0/79koW5ezxrS4g+ZPBpIVNPKO
pFldI09G8pj5g1GJKTrBVG8NMawVhKZxDiRH5035yxd5DcPF+RhBEK6uVw5B6pRB
35jTHoIHHm11r8PUafaCVUiGb87M+iKm8+ugu5gXZJ1Q6KJ2N2mvbA+GJTXJ1q9n
iQ+PORPVzvIn3mWiPSPDS52jCZ1k3ZXC4WQFb2JBfz+1qSZWY7Ec/QTi3ZWmuBub
nhrhEdqn/6zylMibCBGm8NZm7G7iAw==
=uSpk
-----END PGP SIGNATURE-----

--x4ha2wgcxwosjute--
