Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72C69578023
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 12:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234053AbiGRKuC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 06:50:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233356AbiGRKuB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 06:50:01 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DEF21EC60
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 03:50:01 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oDOK5-0001Ou-TB; Mon, 18 Jul 2022 12:49:57 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id B55DEB3013;
        Mon, 18 Jul 2022 10:49:55 +0000 (UTC)
Date:   Mon, 18 Jul 2022 12:49:55 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Matej Vasilevski <matej.vasilevski@seznam.cz>,
        Michal Simek <michal.simek@xilinx.com>
Cc:     Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>,
        Naga Sureshkumar Relli <naga.sureshkumar.relli@xilinx.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        Martin Jerabek <martin.jerabek01@gmail.com>
Subject: Re: [PATCH] can: xilinx_can: add support for RX timestamps on Zynq
Message-ID: <20220718104955.nrlbfnqyhgmnkkey@pengutronix.de>
References: <20220716120408.450405-1-matej.vasilevski@seznam.cz>
 <20220718083312.4izyuf7iawfbhlnf@pengutronix.de>
 <20220718104003.GA35020@hopium>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="pfdsqhlcnjaht26s"
Content-Disposition: inline
In-Reply-To: <20220718104003.GA35020@hopium>
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


--pfdsqhlcnjaht26s
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I've added Michal Simek on into the loop.

Michal can you figure out if there's an undocumented register to read
the free running time stamp counter of the xilinx_can IP core?

On 18.07.2022 12:40:03, Matej Vasilevski wrote:
> On Mon, Jul 18, 2022 at 10:33:12AM +0200, Marc Kleine-Budde wrote:
> > On 16.07.2022 14:04:09, Matej Vasilevski wrote:
> > > This patch adds support for hardware RX timestamps from Xilinx Zynq C=
AN
> > > controllers. The timestamp is calculated against a timepoint reference
> > > stored when the first CAN message is received.
> > >=20
> > > When CAN bus traffic does not contain long idle pauses (so that
> > > the clocks would drift by a multiple of the counter rollover time),
> > > then the hardware timestamps provide precise relative time between
> > > received messages. This can be used e.g. for latency testing.
> >=20
> > Please make use of the existing cyclecounter/timecounter framework. Is
> > there a way to read the current time from a register? If so, please
> > setup a worker that does that regularly.
> >=20
> > Have a look at the mcp251xfd driver as an example:
> >=20
> > https://elixir.bootlin.com/linux/latest/source/drivers/net/can/spi/mcp2=
51xfd/mcp251xfd-timestamp.c
>=20
> Hi Marc,
>=20
> as Pavel have said, the counter register isn't readable.

Some HW designer successfully ticked the mark [x] HW time stamp support!
But haven't thought on how to use this. No Overflow IRQ and no
possibility to read the free running timer. :/

> I'll try to fit the timecounter/cyclecounter framework and send a v2
> patch if it works well. Thanks for the suggestion, it didn't occur to me
> that I can use it in this case as well.

Maybe it's possible to add the ktimestamp based overflow calculation
there, too.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--pfdsqhlcnjaht26s
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmLVOtAACgkQrX5LkNig
013aLwgAidsrv0tsUNsrX44F5m+C8Lk0ZShqFBKnENmPRPww4rpW71KldW/pQS13
ExUiKV2q/Kvo1oS0mS5qvMg3DONk5BM5bpxZBstpcRkPQuIVwfLmybo7Lou/3d5b
xUdSB3UCLUgAXy4QCz+88jbT1OlbWAOEc44ULXMPgMxQNhLhuM3HF096+n/H8O/M
fqiTCmEKRoKVDCzFu25wKfz/UBbUNfhmSAuuOTlQv7SYRIlf7JczXHpzCYJ1D2Ia
MKBKqgkV00CVoykq2+84RAZHV2qKK2DYlAfZrd/tcAJNZqZDonUq8wyE2kfxsnOB
g82ttpi39qD2ctWXY67v+amA1fLkbw==
=nyKu
-----END PGP SIGNATURE-----

--pfdsqhlcnjaht26s--
