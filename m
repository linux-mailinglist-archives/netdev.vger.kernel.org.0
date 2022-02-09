Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAC964AED62
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 09:57:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234743AbiBIIzd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 03:55:33 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:53682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231719AbiBIIz2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 03:55:28 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BED8E032AAE
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 00:55:24 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nHikr-0002oO-56; Wed, 09 Feb 2022 09:55:13 +0100
Received: from pengutronix.de (unknown [195.138.59.174])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 889142EFDF;
        Wed,  9 Feb 2022 08:55:11 +0000 (UTC)
Date:   Wed, 9 Feb 2022 09:55:08 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        linux-can <linux-can@vger.kernel.org>
Subject: Re: [PATCH net-next] can: gw: use call_rcu() instead of costly
 synchronize_rcu()
Message-ID: <20220209085508.q5ydghkqcne5vtyf@pengutronix.de>
References: <20220207190706.1499190-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="q7u5mbyqvpgeonbp"
Content-Disposition: inline
In-Reply-To: <20220207190706.1499190-1-eric.dumazet@gmail.com>
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


--q7u5mbyqvpgeonbp
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 07.02.2022 11:07:06, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
>=20
> Commit fb8696ab14ad ("can: gw: synchronize rcu operations
> before removing gw job entry") added three synchronize_rcu() calls
> to make sure one rcu grace period was observed before freeing
> a "struct cgw_job" (which are tiny objects).
>=20
> This should be converted to call_rcu() to avoid adding delays
> in device / network dismantles.
>=20
> Use the rcu_head that was already in struct cgw_job,
> not yet used.
>=20
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Oliver Hartkopp <socketcan@hartkopp.net>

Added to linux-can-next/testing.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--q7u5mbyqvpgeonbp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmIDgWkACgkQrX5LkNig
013CKwf+NOW3hs6o2V0o7ZLDN8HbNaQ+uoefnBpD5+s27lCh7lg5KzKyFsD17FOp
zwUpOMqnVDLd/PbSJnAREMexe6f28cCvnRv9UUHORIJXSQvTZIxx9hp2+Uq3U9/r
Ts/KTvXdtZV5r57teOeAPDk6WkBekNxXygqgESO8Jth/dRs80kDhWpN6XOL1WN4c
dXYMt0YKw7KHqQSG9f/YDhSBH8XKJenbdtCBukfpG3eGJMt82lDeUTuFCysdgiqY
hCDDk4UQNJ0tJliarViD/zFvc4QHY80IDcb81d+BqtaHKsB9A2KQyKxA6Nc49XcR
7GjM6mLhr8XF5Ze+msvSqUB9jLPj3A==
=bpL8
-----END PGP SIGNATURE-----

--q7u5mbyqvpgeonbp--
