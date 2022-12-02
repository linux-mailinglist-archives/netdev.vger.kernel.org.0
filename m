Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5683E640815
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 15:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233041AbiLBODX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 09:03:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232399AbiLBODW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 09:03:22 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27E90B846D
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 06:03:22 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p16dI-0005uf-O0; Fri, 02 Dec 2022 15:03:16 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:63a6:d4c5:22e2:f72a])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 1DAC31316CF;
        Fri,  2 Dec 2022 14:03:15 +0000 (UTC)
Date:   Fri, 2 Dec 2022 15:03:06 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Markus Schneider-Pargmann <msp@baylibre.com>
Cc:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/15] can: m_can: Optimizations for tcan and peripheral
 chips
Message-ID: <20221202140306.n3iy74ru5f6bxmco@pengutronix.de>
References: <20221116205308.2996556-1-msp@baylibre.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="h23xay4ipaujveqf"
Content-Disposition: inline
In-Reply-To: <20221116205308.2996556-1-msp@baylibre.com>
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


--h23xay4ipaujveqf
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 16.11.2022 21:52:53, Markus Schneider-Pargmann wrote:
> Hi,
>=20
> this series is aimed at optimizing the driver code for tcan chips and
> more generally for peripheral m_can chips.
>=20
> I did different things to improve the performance:
> - Reduce the number of SPI transfers.
> - Reduce the number of interrupts.
> - Enable use of FIFOs.
>=20
> I am working with a tcan4550 in loopback mode attached to a beaglebone
> black. I am currently working on optimizing the receive path as well
> which will be submitted in another series once it is done.

The patches I've not commented on look fine. If you re-spin the series
only containing those, I'll include them in my next pull request, which
I'll send out soonish.

regards,
Marc

> Best,
> Markus
>=20
> Markus Schneider-Pargmann (15):
>   can: m_can: Eliminate double read of TXFQS in tx_handler
>   can: m_can: Wakeup net queue once tx was issued
>   can: m_can: Cache tx putidx and transmits in flight
>   can: m_can: Use transmit event FIFO watermark level interrupt
>   can: m_can: Disable unused interrupts
>   can: m_can: Avoid reading irqstatus twice
>   can: m_can: Read register PSR only on error
>   can: m_can: Count TXE FIFO getidx in the driver
>   can: m_can: Count read getindex in the driver
>   can: m_can: Batch acknowledge rx fifo
>   can: m_can: Batch acknowledge transmit events
>   can: tcan4x5x: Remove invalid write in clear_interrupts
>   can: tcan4x5x: Fix use of register error status mask
>   can: tcan4x5x: Fix register range of first block
>   can: tcan4x5x: Specify separate read/write ranges
>=20
>  drivers/net/can/m_can/m_can.c           | 140 +++++++++++++++---------
>  drivers/net/can/m_can/m_can.h           |   5 +
>  drivers/net/can/m_can/tcan4x5x-core.c   |  19 ++--
>  drivers/net/can/m_can/tcan4x5x-regmap.c |  45 ++++++--
>  4 files changed, 141 insertions(+), 68 deletions(-)
>=20
>=20
> base-commit: 094226ad94f471a9f19e8f8e7140a09c2625abaa
> prerequisite-patch-id: e9df6751d43bb0d1e3b8938d7e93bc1cfa22cef2
> prerequisite-patch-id: dad9ec37af766bcafe54cb156f896267a0f47fe1
> prerequisite-patch-id: f4e6f1a213a31df2741a5fa3baa87aa45ef6707a

BTW: I don't have access to these prerequisite-patch-id.

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--h23xay4ipaujveqf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmOKBZUACgkQrX5LkNig
011+Rgf8DNvEbgHrRjFqYEGfXc5v58YjcpCYXmArBKg7qv0Ozd4akUyIr3jUHxhc
LrcZ9b/tiG0Rykuh0EymiZJOz0xmFFcodRl1TQbMsigE6qNY6mH+ieK3W1CH29d4
ES5yx8tr1sljY8TPGVXGZ8jM3Za5Sq43qP7/O2w10X3/i7BCEYjziHFLyUQUsB36
pEyhStOtL/mwJUSLLipfozz34lt4HiLmetXCVKX84Y1BbdVIeOGkRRSGTqCHIZP7
ILdZSOeYahhqPO3Ep/xNmy65GI2rb4m698nHOdRHr7/+9+RN7xQovOt288mDf2p5
LNfhoUUJRfmceiZHXO20B94C+bbI7w==
=NqYD
-----END PGP SIGNATURE-----

--h23xay4ipaujveqf--
