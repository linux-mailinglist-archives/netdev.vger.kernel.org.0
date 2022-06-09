Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFE48544471
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 09:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233158AbiFIHIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 03:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233834AbiFIHIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 03:08:04 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D680C206106
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 00:08:02 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nzCGm-0003g0-3o; Thu, 09 Jun 2022 09:07:52 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id E149F8FC74;
        Thu,  9 Jun 2022 07:07:49 +0000 (UTC)
Date:   Thu, 9 Jun 2022 09:07:49 +0200
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
Message-ID: <20220609070749.fjcqsw3nuolgr5wh@pengutronix.de>
References: <20220607094752.1029295-1-dario.binacchi@amarulasolutions.com>
 <20220607094752.1029295-5-dario.binacchi@amarulasolutions.com>
 <20220607111330.tkpaplzeupfq3peh@pengutronix.de>
 <CABGWkvotv4Ebm7OSbp=oQ7vwHhR_=sXfAAEkngjLm2faYrUFPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="frh4n6rpdoueeja7"
Content-Disposition: inline
In-Reply-To: <CABGWkvotv4Ebm7OSbp=oQ7vwHhR_=sXfAAEkngjLm2faYrUFPw@mail.gmail.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--frh4n6rpdoueeja7
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 08.06.2022 18:42:09, Dario Binacchi wrote:
> > > In doing so, the struct can_priv::bittiming.bitrate of the driver is =
not
> > > set and since the open_candev() checks that the bitrate has been set,=
 it
> > > must be a non-zero value, the bitrate is set to a fake value (-1) bef=
ore
> > > it is called.
> >
> > What does
> >
> > | ip --details -s -s link show
> >
> > show as the bit rate?
>=20
> # ip --details -s -s link show dev can0

This is the bitrate configured with "ip"?

>  can0: <NOARP,UP,LOWER_UP> mtu 16 qdisc pfifo_fast state UP mode
> DEFAULT group default qlen 10
>     link/can  promiscuity 0 minmtu 0 maxmtu 0
>     can state ERROR-ACTIVE restart-ms 0
>   bitrate 500000 sample-point 0.875
>   tq 41 prop-seg 20 phase-seg1 21 phase-seg2 6 sjw 1
>   slcan: tseg1 2..256 tseg2 1..128 sjw 1..128 brp 1..256 brp-inc 1
>   clock 24000000
>   re-started bus-errors arbit-lost error-warn error-pass bus-off
>   0          0          0          0          0          0
> numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
>     RX: bytes  packets  errors  dropped overrun mcast
>     292        75       0       0       0       0
>     RX errors: length   crc     frame   fifo    missed
>                0        0       0       0       0
>     TX: bytes  packets  errors  dropped carrier collsns
>     0          0        0       0       0       0
>     TX errors: aborted  fifo   window heartbeat transns
>                0        0       0       0       1
>=20
> And after applying your suggestions about using the CAN framework
> support for setting the fixed bit rates (you'll
> find it in V2), this is the output instead:

This looks good.

> # ip --details -s -s link show dev can0
> 5: can0: <NOARP,UP,LOWER_UP> mtu 16 qdisc pfifo_fast state UP mode
> DEFAULT group default qlen 10
>     link/can  promiscuity 0 minmtu 0 maxmtu 0
>     can state ERROR-ACTIVE restart-ms 0
>   bitrate 500000
>      [   10000,    20000,    50000,   100000,   125000,   250000,
>         500000,   800000,  1000000 ]
>   clock 0
>   re-started bus-errors arbit-lost error-warn error-pass bus-off
>   0          0          0          0          0          0
> numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
>     RX: bytes  packets  errors  dropped overrun mcast
>     37307      4789     0       0       0       0
>     RX errors: length   crc     frame   fifo    missed
>                0        0       0       0       0
>     TX: bytes  packets  errors  dropped carrier collsns
>     7276       988      0       0       0       0
>     TX errors: aborted  fifo   window heartbeat transns
>                0        0       0       0       1

Can you configure the bitrate with slcand and show the output of "ip
--details -s -s link show dev can0". I fear it will show 4294967295 as
the bitrate, which I don't like.

A hack would be to replace the -1 by 0 in the CAN netlink code.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--frh4n6rpdoueeja7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKhnEIACgkQrX5LkNig
010WSwgAqA3crYZc6TRJlUHLRrLUxsKdkX7A47KeCFQr0JtvQMjb2Z3VB4DsPmtB
M61CVDQ/NRcS4HuuJqyshQsEknOB14BRkgKcZbYqX8BUpcqz2/ghxr23/7J4UT2B
cg7hDrUoXRb4eUCscBdxNT+RTr5K11voeYrcl9XjJ4/0VrC1mv5gCN0oIN11b8qp
973FZd4FBS5X40coGxvT+KIRu8gYcZ048vnFXsB1/L1T2yX7kEdz4uNzxCBF2ajW
qAuhGBR34vb1JVn4Mhfppkfu0TMIdRV8NsOX4wYzDJCS5EQxc8er1vf/57hW3zkU
JwxEDHoFIZrEuOc+umOO1ZpftIkBbw==
=pLef
-----END PGP SIGNATURE-----

--frh4n6rpdoueeja7--
