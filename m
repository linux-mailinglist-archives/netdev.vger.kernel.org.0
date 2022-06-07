Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 047C653FD1C
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 13:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239290AbiFGLN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 07:13:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235104AbiFGLNq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 07:13:46 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2528FB54
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 04:13:44 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nyX9R-0001PF-6N; Tue, 07 Jun 2022 13:13:33 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id A60198DC16;
        Tue,  7 Jun 2022 11:13:30 +0000 (UTC)
Date:   Tue, 7 Jun 2022 13:13:30 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        michael@amarulasolutions.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 04/13] can: slcan: use CAN network device driver API
Message-ID: <20220607111330.tkpaplzeupfq3peh@pengutronix.de>
References: <20220607094752.1029295-1-dario.binacchi@amarulasolutions.com>
 <20220607094752.1029295-5-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="77gvozq5fr2tyjf2"
Content-Disposition: inline
In-Reply-To: <20220607094752.1029295-5-dario.binacchi@amarulasolutions.com>
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


--77gvozq5fr2tyjf2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 07.06.2022 11:47:43, Dario Binacchi wrote:
> As suggested by commit [1], now the driver uses the functions and the
> data structures provided by the CAN network device driver interface.
>=20
> There is no way to set bitrate for SLCAN based devices via ip tool, so
  ^^^^^^^^^^^^^^^
Currently the driver doesn't implement a way

> you'll have to do this by slcand/slcan_attach invocation through the
> -sX parameter:
>=20
> - slcan_attach -f -s6 -o /dev/ttyACM0
> - slcand -f -s8 -o /dev/ttyUSB0
>=20
> where -s6 in will set adapter's bitrate to 500 Kbit/s and -s8 to
> 1Mbit/s.
> See the table below for further CAN bitrates:
> - s0 ->   10 Kbit/s
> - s1 ->   20 Kbit/s
> - s2 ->   50 Kbit/s
> - s3 ->  100 Kbit/s
> - s4 ->  125 Kbit/s
> - s5 ->  250 Kbit/s
> - s6 ->  500 Kbit/s
> - s7 ->  800 Kbit/s
> - s8 -> 1000 Kbit/s
>=20
> In doing so, the struct can_priv::bittiming.bitrate of the driver is not
> set and since the open_candev() checks that the bitrate has been set, it
> must be a non-zero value, the bitrate is set to a fake value (-1) before
> it is called.

What does

| ip --details -s -s link show

show as the bit rate?

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--77gvozq5fr2tyjf2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKfMtQACgkQrX5LkNig
013bFAgAtwB15XQxo+UXu+6eKstSkXk5DhOcbTE9ySUMLb/8KMePa+t06IKsQCdl
tULZjuegPUb4ID4a8UXF0Ny3YllLYyu+P3owsmTuKJvzecvJck3y6N2Oe9QlrT29
u9QAjVwKdq6pjrT7uomYOS/9h7LwZqi7CToIhlfwvvQOMkiPgJPw2vfir5TrYwLw
hsWdweeaGH2gZP07S9jpZtO6d4UCzjg5updigH7FQsO73Q+jEvhmDbeO7jpzaFI0
+bITgbgqqdx/dHJIAmROQnXNu7nA/iZd8jUiKiWDjMWmsSCVqfvokpiiHI13aAhy
/H6XQyIvwXHArhYkaV6+RTBruDasOw==
=CCSY
-----END PGP SIGNATURE-----

--77gvozq5fr2tyjf2--
