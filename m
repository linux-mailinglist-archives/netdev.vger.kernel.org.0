Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB213AE458
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 09:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbhFUHt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 03:49:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbhFUHt6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 03:49:58 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF874C061756
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 00:47:44 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lvEeg-0003Qs-AE; Mon, 21 Jun 2021 09:47:38 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:3569:1fb5:40be:61fc])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 366D2640205;
        Mon, 21 Jun 2021 07:47:36 +0000 (UTC)
Date:   Mon, 21 Jun 2021 09:47:35 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Norbert Slusarek <nslusarek@gmx.net>
Cc:     netdev@vger.kernel.org, ore@pengutronix.de, socketcan@hartkopp.net,
        davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH] can: j1939: prevent allocation of j1939 filter for
 optlen = 0
Message-ID: <20210621074735.mnok4c3rr7qwparu@pengutronix.de>
References: <20210620123842.117975-1-nslusarek@gmx.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="6gcb3zubcmxn25nj"
Content-Disposition: inline
In-Reply-To: <20210620123842.117975-1-nslusarek@gmx.net>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--6gcb3zubcmxn25nj
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 20.06.2021 14:38:42, Norbert Slusarek wrote:
> If optval !=3D NULL and optlen =3D 0 are specified for SO_J1939_FILTER in
> j1939_sk_setsockopt(), memdup_sockptr() will return ZERO_PTR for 0 size
> allocation. The new filter will be mistakenly assigned ZERO_PTR.
> This patch checks for optlen !=3D 0 and filter will be assigned NULL
> in case of optlen =3D 0.
>=20
> Fixes: a7b75c5a8c41 ("net: pass a sockptr_t into ->setsockopt")
> Signed-off-by: Norbert Slusarek <nslusarek@gmx.net>

The problem was in the initial commit, too. Changed Fixes tags
accordingly to:

| Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")

applied to linux-can/testing

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--6gcb3zubcmxn25nj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmDQRBQACgkQqclaivrt
76kxCgf/R8rJAam/ugLxow/pQHnX0ulmGuzx4sUFtKVteiR+0tH3loxS1kKb9pfB
GtcftmNRiUUgsctb59YAdMyv34hisbXomrSmOp1sUPhhniLORpT07ss2kojJ4LPq
rY2dqURUHAJ7pBu1tAaEYxyb/N75PcXVOIvEXUkNShl36icFnx5rbaFqAl+l7AnB
30WhNiaW92lkBVfRb7B5rrHY2qcVhl8JI0LNbwFmNeyLTO8OQYJv9VZSPqj7eKlB
nYEOdLmAaZycTl/0AMbA+A9WAbZu4btjqveW6LWgMuf86AZ8FZbjuK5O/qKdPf3e
e5tvl1Fe/4EG7UeDdRxGgiM9Io3nnw==
=SgG9
-----END PGP SIGNATURE-----

--6gcb3zubcmxn25nj--
