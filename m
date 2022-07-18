Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 627EB577F1A
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 11:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233900AbiGRJzw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 05:55:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232852AbiGRJzv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 05:55:51 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8479719C29
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 02:55:50 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oDNTe-0001lV-SN; Mon, 18 Jul 2022 11:55:46 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 19A77B2E5E;
        Mon, 18 Jul 2022 08:33:13 +0000 (UTC)
Date:   Mon, 18 Jul 2022 10:33:12 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Matej Vasilevski <matej.vasilevski@seznam.cz>
Cc:     Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>,
        Naga Sureshkumar Relli <naga.sureshkumar.relli@xilinx.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        Martin Jerabek <martin.jerabek01@gmail.com>
Subject: Re: [PATCH] can: xilinx_can: add support for RX timestamps on Zynq
Message-ID: <20220718083312.4izyuf7iawfbhlnf@pengutronix.de>
References: <20220716120408.450405-1-matej.vasilevski@seznam.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="gia2fzp3imb2fsd2"
Content-Disposition: inline
In-Reply-To: <20220716120408.450405-1-matej.vasilevski@seznam.cz>
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


--gia2fzp3imb2fsd2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 16.07.2022 14:04:09, Matej Vasilevski wrote:
> This patch adds support for hardware RX timestamps from Xilinx Zynq CAN
> controllers. The timestamp is calculated against a timepoint reference
> stored when the first CAN message is received.
>=20
> When CAN bus traffic does not contain long idle pauses (so that
> the clocks would drift by a multiple of the counter rollover time),
> then the hardware timestamps provide precise relative time between
> received messages. This can be used e.g. for latency testing.

Please make use of the existing cyclecounter/timecounter framework. Is
there a way to read the current time from a register? If so, please
setup a worker that does that regularly.

Have a look at the mcp251xfd driver as an example:

https://elixir.bootlin.com/linux/latest/source/drivers/net/can/spi/mcp251xf=
d/mcp251xfd-timestamp.c

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--gia2fzp3imb2fsd2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmLVGsUACgkQrX5LkNig
012x2Qf8DtbUa7HLc54ioRZu/RDkCTzAp/aNoRv1HyZ2f6C63tAWoTG4gyy2dAjT
izMk8XFEArN35ZMYTXT2Ru2zj+HPzIB+U+USe/UKSiHP77yYzSAJCUKGUcGuVvec
OV9hDO/jvnmuNvma4mf1w8KBilnKTICdszrwj9ktu2CwRUxkyeRQzZBHt69P3zPa
JrYXYOLXM6isfbYboh++XbsSxAODzKH9OyiYtuBC6Klr4bzJzerxfGMARfZNZZ5O
eormvK04zBLFDjPyrub//8Gna3aKOzI+kcw/XJVfqNot2LHEyAMJo1KijI4XhSWk
vAB6NI91VMNlDHt4E6jmKBg7Dkargw==
=pHe9
-----END PGP SIGNATURE-----

--gia2fzp3imb2fsd2--
