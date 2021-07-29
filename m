Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02A9E3DA22D
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 13:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236916AbhG2LbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 07:31:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236840AbhG2LbS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 07:31:18 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68EC2C061765
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 04:31:15 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1m94Fj-0003Hd-QR; Thu, 29 Jul 2021 13:31:03 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:f664:c769:c9a5:5ced])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id B4D1865ADC8;
        Thu, 29 Jul 2021 11:31:01 +0000 (UTC)
Date:   Thu, 29 Jul 2021 13:31:01 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     wg@grandegger.com, davem@davemloft.net, kuba@kernel.org,
        angelo@kernel-space.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] can: flexcan: Fix an uninitialized variable issue
Message-ID: <20210729113101.n5aucrwu56lyqhg7@pengutronix.de>
References: <a55780a2f4c8f1895b6bcbac4d3f8312b2731079.1627557857.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="iwr5k3fcdfx7llyh"
Content-Disposition: inline
In-Reply-To: <a55780a2f4c8f1895b6bcbac4d3f8312b2731079.1627557857.git.christophe.jaillet@wanadoo.fr>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--iwr5k3fcdfx7llyh
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 29.07.2021 13:27:42, Christophe JAILLET wrote:
> If both 'clk_ipg' and 'clk_per' are NULL, we return an un-init value.
> So set 'err' to 0, to return success in such a case.

Thanks for the patch, a similar one has been posted before:
https://lore.kernel.org/linux-can/20210728075428.1493568-1-mkl@pengutronix.=
de/

> Fixes: d9cead75b1c6 ("can: flexcan: add mcf5441x support")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> Another way to fix it is to remove the NULL checks for 'clk_ipg' and
> 'clk_per' that been added in commit d9cead75b1c6.
>=20
> They look useless to me because 'clk_prepare_enable()' returns 0 if it is
> passed a NULL pointer.

ACK, while the common clock framework's clk_prepare_enable() can handle
NULL pointers, the clock framework used on the mcf5441x doesn't.

> Having these explicit tests is maybe informational (i.e. these pointers
> can really be NULL) or have been added to silent a compiler or a static
> checker.
>=20
> So, in case, I've left the tests and just fixed the un-init 'err' variable
> issue.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--iwr5k3fcdfx7llyh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmECkXIACgkQqclaivrt
76liEgf8CJEbFuAHrQs7n44BCSVb8JpZhXWz5uhZssbo6/VqBt1hytspXKvROp4z
FysbdjX6nHDX0vfJpg3uG/d35Zbl8I2iMw4fPE1AdkOlDf96uWwl4M5dkSxuoXx5
BUdXCncRW6BTQV2lXmXyVoxT64U8xE1HmhKcYr4uzJ1SvQxH9bLr5as1YW1tO9d4
/3snPM3X9YFV7kf0UCuqsOJDFmqJr5xWOqX5/WaG8zX59ltbT7VsXImq+vk1Bre8
EMqX+JlmLrjHBGd9rG4vzMAA0AJGSaEpQKLF7bbsIOKelKTR4U/aSkD8FYz/+i+B
6h5IxbMFQDaVabIECJpOhHVyQ36L9g==
=SScx
-----END PGP SIGNATURE-----

--iwr5k3fcdfx7llyh--
