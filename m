Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55B693EFCB6
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 08:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239160AbhHRG2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 02:28:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238625AbhHRG2H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 02:28:07 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC3E3C0612A6
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 23:27:29 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mGF2W-0007Xm-Bs; Wed, 18 Aug 2021 08:27:04 +0200
Received: from pengutronix.de (unknown [IPv6:2a02:810a:8940:aa0:ed04:8488:5061:54d4])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 7335C66975A;
        Wed, 18 Aug 2021 06:26:59 +0000 (UTC)
Date:   Wed, 18 Aug 2021 08:26:57 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-kernel@vger.kernel.org,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-wireless@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2 59/63] can: flexcan: Use struct_group() to zero struct
 flexcan_regs regions
Message-ID: <20210818062657.6hvn75kf5o5cgey2@pengutronix.de>
References: <20210818060533.3569517-1-keescook@chromium.org>
 <20210818060533.3569517-60-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="kduqcl3tf4g5uel5"
Content-Disposition: inline
In-Reply-To: <20210818060533.3569517-60-keescook@chromium.org>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--kduqcl3tf4g5uel5
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 17.08.2021 23:05:29, Kees Cook wrote:
> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memset(), avoid intentionally writing across
> neighboring fields.
>=20
> Add struct_group() to mark both regions of struct flexcan_regs that get
> initialized to zero. Avoid the future warnings:
>=20
> In function 'fortify_memset_chk',
>     inlined from 'memset_io' at ./include/asm-generic/io.h:1169:2,
>     inlined from 'flexcan_ram_init' at drivers/net/can/flexcan.c:1403:2:
> ./include/linux/fortify-string.h:199:4: warning: call to '__write_overflo=
w_field' declared with attribute warning: detected write beyond size of fie=
ld (1st parameter); maybe use struct_group()? [-Wattribute-warning]
>   199 |    __write_overflow_field(p_size_field, size);
>       |    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> In function 'fortify_memset_chk',
>     inlined from 'memset_io' at ./include/asm-generic/io.h:1169:2,
>     inlined from 'flexcan_ram_init' at drivers/net/can/flexcan.c:1408:3:
> ./include/linux/fortify-string.h:199:4: warning: call to '__write_overflo=
w_field' declared with attribute warning: detected write beyond size of fie=
ld (1st parameter); maybe use struct_group()? [-Wattribute-warning]
>   199 |    __write_overflow_field(p_size_field, size);
>       |    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>=20
> Cc: Wolfgang Grandegger <wg@grandegger.com>
> Cc: Marc Kleine-Budde <mkl@pengutronix.de>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: linux-can@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>

Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>

> -	memset_io(&regs->mb[0][0], 0,
> -		  offsetof(struct flexcan_regs, rx_smb1[3]) -
> -		  offsetof(struct flexcan_regs, mb[0][0]) + 0x4);
> +	memset_io(&regs->init, 0, sizeof(regs->init));

This even makes the code more readable! \o/

>  	if (priv->can.ctrlmode & CAN_CTRLMODE_FD)
> -		memset_io(&regs->tx_smb_fd[0], 0,
> -			  offsetof(struct flexcan_regs, rx_smb1_fd[17]) -
> -			  offsetof(struct flexcan_regs, tx_smb_fd[0]) + 0x4);
> +		memset_io(&regs->init_fd, 0, sizeof(regs->init_fd));
> =20
>  	reg_ctrl2 &=3D ~FLEXCAN_CTRL2_WRMFRZ;
>  	priv->write(reg_ctrl2, &regs->ctrl2);

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--kduqcl3tf4g5uel5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmEcqC4ACgkQqclaivrt
76lMtAf+PLTf+69ONg9/KGwncoo4yvZ5m8bSKHLYfYYuCITf4oOnHWQIBFT3P8Fn
GMKihDcISmFKjqSbFu8aJSqtNFhYzGB0uIUjuhW+15TJRH7SUTZCuT/U6VPXrEWi
qWCGvkl3szxqSpDVrbCW5ChnnsAZ3Nj2pXV+gkB62mvtcwTdqFBczMfbKHNhLHgv
BYjF2uWTN51iadHR3Kese6EccsTaIoCrqZjnGrlJSBVLtt66BT101RY0pE9890e+
+p/LRFYivNeT0DnAObs8TDghwzxWlqfE3nR1QLSvENRbMBSzhEbipc7oz3DQJC4v
WM/41iCaZScHUFfgxPrBqtGtM1p9RA==
=LXIZ
-----END PGP SIGNATURE-----

--kduqcl3tf4g5uel5--
