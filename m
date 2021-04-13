Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED3AE35DE2A
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 14:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344884AbhDMMBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 08:01:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343934AbhDMMBK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 08:01:10 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD1CBC06175F
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 05:00:50 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lWHin-0003AO-AL; Tue, 13 Apr 2021 14:00:45 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:d93:7b32:b325:ef5e])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 08F7F60DCD2;
        Tue, 13 Apr 2021 12:00:42 +0000 (UTC)
Date:   Tue, 13 Apr 2021 14:00:42 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] can: etas_es58x: fix null pointer dereference when
 handling error frames
Message-ID: <20210413120042.27sfrb4hgrr4ua7x@pengutronix.de>
References: <20210413114242.2760-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="7vvsamthpjzsb2d4"
Content-Disposition: inline
In-Reply-To: <20210413114242.2760-1-mailhol.vincent@wanadoo.fr>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--7vvsamthpjzsb2d4
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 13.04.2021 20:42:42, Vincent Mailhol wrote:
> During the handling of CAN bus errors, a CAN error SKB is allocated
> using alloc_can_err_skb(). Even if the allocation of the SKB fails,
> the function continues in order to do the stats handling.
>=20
> All access to the can_frame pointer (cf) should be guarded by an if
> statement:
> 	if (cf)
>=20
> However, the increment of the rx_bytes stats:
> 	netdev->stats.rx_bytes +=3D cf->can_dlc;
> dereferences the cf pointer and was not guarded by an if condition
> leading to a NULL pointer dereference if the can_err_skb() function
> failed.
>=20
> Replacing the cf->can_dlc by the macro CAN_ERR_DLC (which is the
> length of any CAN error frames) solves this NULL pointer dereference.
>=20
> Fixes: 8537257874e9 ("can: etas_es58x: add core support for ETAS ES58X CA=
N USB interfaces")
> Reported-by: Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>
> Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> ---
> Hi Marc,
>=20
> I am really sorry, but I was just notified about this issue litteraly
> a few minutes after you send the pull request to net-next.

:D

> I am not sure how to proceed. You might either cancel the pull request
> and squash this to 8537257874e9 ("can: etas_es58x: add core support
> for ETAS ES58X CAN USB interfaces") or send it as a separate patch.
>=20
> Please let me know if you need me to do anything.

I'll send a follow-up pull request tomorrow.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--7vvsamthpjzsb2d4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmB1h+cACgkQqclaivrt
76lw3wf8C32JuHk0dtao8qjHSHf9MLq8zaBkN4GxmtHvBMRajZUMxi3VgpXQcxon
Mqu3zDFb57e+WD/7M0bbO2V3Blx6aH34uGKt+loMrZjDspJqo60Ut3yz4qT3sIzN
mMIWYypg0Debofg4c9XKeKsTK5uq/5O7u24nhsGqRH6sw009mNVLB7T2ERaZmW9N
cqpgkG4AzAaPvtgm89EmGSNWd7DsGJFtSZpyRFAu/86nxfx1w8+/qoNSvYs+HdXH
Kn/X+lg3Znzd0GaSUa2YdIjveTZ7OFVw+ZfiTy8/AWcxEzfwrunTGJ7AJJIDR5oU
xwLBtNNKnTvWuNUROuEADqozeiwNuA==
=ILb7
-----END PGP SIGNATURE-----

--7vvsamthpjzsb2d4--
