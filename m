Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8440D55DB33
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344972AbiF1KjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 06:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344209AbiF1KjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 06:39:16 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 740512E9C7
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 03:39:15 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1o68cc-00089w-0A; Tue, 28 Jun 2022 12:39:06 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 3AD36A0E07;
        Tue, 28 Jun 2022 10:38:54 +0000 (UTC)
Date:   Tue, 28 Jun 2022 12:38:50 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        michael@amarulasolutions.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v4 05/12] can: slcan: use CAN network device driver API
Message-ID: <20220628103850.4g2fyjybokraqz4b@pengutronix.de>
References: <20220614122821.3646071-1-dario.binacchi@amarulasolutions.com>
 <20220614122821.3646071-6-dario.binacchi@amarulasolutions.com>
 <20220628092833.uo66jbnwhh5af6je@pengutronix.de>
 <CABGWkvrdw27T+g==HrknM+52mhvgEDS_4P9__7tsc+aV-oAvCw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="tbsrzes5xfujdruo"
Content-Disposition: inline
In-Reply-To: <CABGWkvrdw27T+g==HrknM+52mhvgEDS_4P9__7tsc+aV-oAvCw@mail.gmail.com>
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


--tbsrzes5xfujdruo
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 28.06.2022 11:48:48, Dario Binacchi wrote:
> Hi Marc,
>=20
> On Tue, Jun 28, 2022 at 11:28 AM Marc Kleine-Budde <mkl@pengutronix.de> w=
rote:
> >
> > On 14.06.2022 14:28:14, Dario Binacchi wrote:
> > > As suggested by commit [1], now the driver uses the functions and the
> > > data structures provided by the CAN network device driver interface.
> > >
> > > Currently the driver doesn't implement a way to set bitrate for SLCAN
> > > based devices via ip tool, so you'll have to do this by slcand or
> > > slcan_attach invocation through the -sX parameter:
> > >
> > > - slcan_attach -f -s6 -o /dev/ttyACM0
> > > - slcand -f -s8 -o /dev/ttyUSB0
> > >
> > > where -s6 in will set adapter's bitrate to 500 Kbit/s and -s8 to
> > > 1Mbit/s.
> > > See the table below for further CAN bitrates:
> > > - s0 ->   10 Kbit/s
> > > - s1 ->   20 Kbit/s
> > > - s2 ->   50 Kbit/s
> > > - s3 ->  100 Kbit/s
> > > - s4 ->  125 Kbit/s
> > > - s5 ->  250 Kbit/s
> > > - s6 ->  500 Kbit/s
> > > - s7 ->  800 Kbit/s
> > > - s8 -> 1000 Kbit/s
> > >
> > > In doing so, the struct can_priv::bittiming.bitrate of the driver is =
not
> > > set and since the open_candev() checks that the bitrate has been set,=
 it
> > > must be a non-zero value, the bitrate is set to a fake value (-1U)
> > > before it is called.
> > >
> > > The patch also changes the slcan_devs locking from rtnl to spin_lock.=
 The
> > > change was tested with a kernel with the CONFIG_PROVE_LOCKING option
> > > enabled that did not show any errors.
> >
> > You're not allowed to call alloc_candev() with a spin_lock held. See
> > today's kernel test robot mail:
> >
> > | https://lore.kernel.org/all/YrpqO5jepAvv4zkf@xsang-OptiPlex-9020
> >
> > I think it's best to keep the rtnl for now.
>=20
> The rtnl_lock() uses a mutex while I used a spin_lock.
>=20
> static DEFINE_MUTEX(rtnl_mutex);
>=20
> void rtnl_lock(void)
> {
> mutex_lock(&rtnl_mutex);
> }
> EXPORT_SYMBOL(rtnl_lock);
>=20
> So might it be worth trying with a mutex instead of rtnl_lock(), or do
> you think it is
> safer to return to rtn_lock () anyway?

As Max pointed out the whole static dev array is not needed at all. Just
keep the rtnl, until removing the array altogether.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--tbsrzes5xfujdruo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmK62jcACgkQrX5LkNig
010jzwf/YtSV3kHaxcOCJQDr/oebHEMDUbH6lToSB5vR4Wo0ADsCZjTs5Z2HwNEv
onCHfInDk50Ky1seqz0GrtIH9mPZIPLFyrQlTtFNfdkluQJy1/JnoZRBzkjMMDkD
PS858Y/ntrQJDAAklT7c2YbNmvN9EkoNDSHMG6lVgB0IDY3+EHHHQKZf1sWh+4wf
3aQ8UHguqfqJWnGC43azlu1SzjVRmVQ322C0e8xyqXmpc/XZ9jHJAW/TWq/+2aD1
8wkZS1gkCyg0eCh4AK5tEHHxNWkhJrDDjB4NBY/G6Yg3RNxwgBOv/gVW2ndQIYJB
nPNJcJ9+iIE2zrUEtHRZSHimkL/ZSQ==
=bC7y
-----END PGP SIGNATURE-----

--tbsrzes5xfujdruo--
