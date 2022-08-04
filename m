Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 218B05898AF
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 09:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239272AbiHDHwR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 03:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239253AbiHDHwQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 03:52:16 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DFD52AC5A
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 00:52:15 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oJVeA-0001tT-V6; Thu, 04 Aug 2022 09:51:59 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id D1A6AC288A;
        Thu,  4 Aug 2022 07:51:54 +0000 (UTC)
Date:   Thu, 4 Aug 2022 09:51:52 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Sebastian =?utf-8?B?V8O8cmw=?= <sebastian.wuerl@ororatech.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Stefan =?utf-8?B?TcOkdGpl?= <stefan.maetje@esd.eu>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Christian Pellegrin <chripell@fsfe.org>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] can: mcp251x: Fix race condition on receive interrupt
Message-ID: <20220804075152.kqlp5weoz4grzbpp@pengutronix.de>
References: <20220803185910.5jpufgziqsslnqtf@pengutronix.de>
 <20220804064803.63157-1-sebastian.wuerl@ororatech.com>
 <20220804070603.s3llvccpldtkejln@pengutronix.de>
 <CA+KjhYWukGxZUMMch_vFe=TNYCD0-jmuwO2520oUVDPE2kE1Rw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="wmflnmbvqbtvlyoh"
Content-Disposition: inline
In-Reply-To: <CA+KjhYWukGxZUMMch_vFe=TNYCD0-jmuwO2520oUVDPE2kE1Rw@mail.gmail.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--wmflnmbvqbtvlyoh
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 04.08.2022 09:45:07, Sebastian W=C3=BCrl wrote:
> On Thu, Aug 4, 2022 at 9:06 AM Marc Kleine-Budde <mkl@pengutronix.de> wro=
te:
> >
> > Another optimization idea: Do we need to re-read the eflag1? "eflag" is
> > for error handling only and you're optimizing the good path.
>=20
> I'd argue if a new message entered mailbox 1, this also potentially
> changed the error state, so we need to read it.

Makes sense!

> Thanks a lot for your feedback! Will post v3 soon.
>=20
> Also I'm sorry for spam in anyones inbox, I didn't get my mailing
> program to produce plain-text for the last mail.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--wmflnmbvqbtvlyoh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmLrepUACgkQrX5LkNig
011YJAf+L3PZEy9x/pSHGSUOvoAQF7K7jjRwi1zAeyss+ujiN0gls73XWN8NnoKo
AahPfXB8jdIeclp1wyRxeuuZwbwK2Vk1ZGYhnApeA3C2QLJX5GqsZLh06eovnafA
BF9cnmgKwiH9vZeYBMrJie9RD4wSN7yrGUQoU8G5x+/dBtRrD5TbHmpD8MK6Mx61
PkJ+Yvqs8rLc5WgcUBzrd3Lh3CQ1YcGZhYIuGOPDFD8ZTkSRPEuVREJx9c6VMRgV
B6bNTMD+saWayZdFyGEvtENrOXes16pwDZkL/VsMuY4tP+JqmHISWHvcg6mzhZHP
hkEqiB/Dy3cPaTpTlT0NzcA5RJmj4A==
=yFeG
-----END PGP SIGNATURE-----

--wmflnmbvqbtvlyoh--
