Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3522361117D
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 14:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbiJ1McX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 08:32:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbiJ1McW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 08:32:22 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C7CF1905F3
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 05:32:22 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ooOWn-00033C-Kh; Fri, 28 Oct 2022 14:32:01 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 3A7D510CBD3;
        Fri, 28 Oct 2022 12:31:57 +0000 (UTC)
Date:   Fri, 28 Oct 2022 14:31:53 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Zhengchao Shao <shaozhengchao@huawei.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@rempel-privat.de, weiyongjun1@huawei.com,
        yuehaibing@huawei.com
Subject: Re: [PATCH net] can: af_can: fix NULL pointer dereference in
 can_rx_register()
Message-ID: <20221028123153.ltdwjbtpr2iatsqz@pengutronix.de>
References: <20221028033342.173528-1-shaozhengchao@huawei.com>
 <d1e728d2-b62f-3646-dd27-8cc36ba7c819@hartkopp.net>
 <20221028074637.3havdrt37qsmbvll@pengutronix.de>
 <773e6b03-c816-5ecb-bd4f-5f214fa347fb@hartkopp.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="qcwpp5t7vsftovkw"
Content-Disposition: inline
In-Reply-To: <773e6b03-c816-5ecb-bd4f-5f214fa347fb@hartkopp.net>
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


--qcwpp5t7vsftovkw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 28.10.2022 13:24:36, Oliver Hartkopp wrote:
> Didn't have remembered that specific discussion.
>=20
> Wouldn't we need this check in can_rx_unregister() and maybe

The kernel should not call can_rx_unregister() if can_rx_register()
fails, but on the other hand we check for ARPHRD_CAN here, too.

> can[|fd|xl]_rcv() then too?
>=20
> As all these functions check for ARPHRD_CAN and later access ml_priv.

Better safe then sorry.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--qcwpp5t7vsftovkw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmNby7YACgkQrX5LkNig
011AwAf9HfNp0x2JzVFVrmhpNGfx871uQTbBXNtvWN3ZxanToxmYqmDP7UOs69Y7
3IQi+a5GNiKZq/AnAmLjWaUXxroIvQYwxTLx+uFjrzpetdNYhLRxj5OGBih04Lqr
ZInYrv1PLocMA8Y2lGaYHK5qQKy7zc9Wy2ZwQ3cdfa/NeWTxohHfPXZTjOZyKjLZ
/cVW5prLT7VUOFasEt3T0UlJ9TaOWttWVYOl29hPklF2jci1lUOqImFNxZWDfT42
6dD/3U8tjXPDSgJZB4dGar5JiQM1fj1zTC+4V1oVbbYJUx6tUxBBJjzGfqOHq3X+
1RbzT7drIYKjZE0cgj3N6qk8ckTt1A==
=o69o
-----END PGP SIGNATURE-----

--qcwpp5t7vsftovkw--
