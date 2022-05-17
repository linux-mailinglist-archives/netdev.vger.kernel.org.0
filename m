Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0D9052A4BC
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 16:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348850AbiEQOXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 10:23:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348868AbiEQOXj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 10:23:39 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C80A84F9FF
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 07:23:37 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nqy6m-00080b-IX; Tue, 17 May 2022 16:23:32 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 6513E8072E;
        Tue, 17 May 2022 14:23:31 +0000 (UTC)
Date:   Tue, 17 May 2022 16:23:30 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Max Staudt <max@enpas.org>
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 3/4] can: skb:: move can_dropped_invalid_skb and
 can_skb_headroom_valid to skb.c
Message-ID: <20220517142330.vm7jqoe6i63ryqtc@pengutronix.de>
References: <CAMZ6RqKZMHXB7rQ70GrXcVE7x7kytAAGfE+MOpSgWgWgp0gD2g@mail.gmail.com>
 <20220517060821.akuqbqxro34tj7x6@pengutronix.de>
 <CAMZ6RqJ3sXYUOpw7hEfDzj14H-vXK_i+eYojBk2Lq=h=7cm7Jg@mail.gmail.com>
 <20220517104545.eslountqjppvcnz2@pengutronix.de>
 <e054f6d4-7ed1-98ac-8364-425f4ef0f760@hartkopp.net>
 <20220517141404.578d188a.max@enpas.org>
 <20220517122153.4r6n6kkbdslsa2hv@pengutronix.de>
 <20220517143921.08458f2c.max@enpas.org>
 <0b505b1f-1ee4-5a2c-3bbf-6e9822f78817@hartkopp.net>
 <20220517154301.5bf99ba9.max@enpas.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="tgwfqoi623ckzpip"
Content-Disposition: inline
In-Reply-To: <20220517154301.5bf99ba9.max@enpas.org>
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


--tgwfqoi623ckzpip
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 17.05.2022 15:43:01, Max Staudt wrote:
> > Oh, I didn't want to introduce two new kernel modules but to have=20
> > can_dev in different 'feature levels'.
>=20
> Which I agree is a nice idea, as long as heisenbugs can be avoided :)
>=20
> (as for the separate modules vs. feature levels of can-dev - sorry, my
> two paragraphs were each referring to a different idea. I mixed them
> into one single email...)
>=20
> Maybe the can-skb and rx-offload parts could be a *visible* sub-option
> of can-dev in Kconfig, which is normally optional, but immediately
> force-selected once a CAN HW driver is selected?

In the ctucanfd driver we made the base driver "invisible" if
COMPILE_TEST is not selected:

| config CAN_CTUCANFD
|         tristate "CTU CAN-FD IP core" if COMPILE_TEST
|=20
| config CAN_CTUCANFD_PCI
|         tristate "CTU CAN-FD IP core PCI/PCIe driver"
|         depends on PCI
|         select CAN_CTUCANFD

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--tgwfqoi623ckzpip
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKDr+AACgkQrX5LkNig
011wSgf/RV+/tPG2xXLH0ovdmc9xiGLHdexWXlcaQGRlACwpK3TzxCdKsnf5EA/r
AOx+7UogJqyoeBxO1lIm4Cqp3vclJ3i2xPjZADpGCvn+yulIZerhqOmEeerae0Bk
CR+/vyCFGJIHERQOOR/B3Wum7pM1kOPHE7V+5DGJikZ59Giyq3Lnf1hAS+qP6I/8
3w/eu8cGzYLkNigVyA+BWkZLm+hx2HH2sSWYNfnxpV5m7usfG+tKI8dROxLttPpx
TgMXWCjyDC63y5V0yXD/B6+TaFFGsrZCOtBgwUP6eVyVyKnxZSYlI8fd4ybY+U7W
mGX8jgAz6iGHy8sukm1eRz5mUxZxJg==
=WKSH
-----END PGP SIGNATURE-----

--tgwfqoi623ckzpip--
