Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 602DE46E797
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 12:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236701AbhLILbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 06:31:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235897AbhLILba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 06:31:30 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 804B0C061746
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 03:27:57 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mvHaZ-0004Ms-SP; Thu, 09 Dec 2021 12:27:51 +0100
Received: from pengutronix.de (2a03-f580-87bc-d400-d871-9883-c026-3a21.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:d871:9883:c026:3a21])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 3EBC26C087F;
        Thu,  9 Dec 2021 11:27:49 +0000 (UTC)
Date:   Thu, 9 Dec 2021 12:27:48 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Sven Schuchmann <schuchmann@schleissheimer.de>
Cc:     "Thomas.Kopp@microchip.com" <Thomas.Kopp@microchip.com>,
        "pavel.modilaynen@volvocars.com" <pavel.modilaynen@volvocars.com>,
        "drew@beagleboard.org" <drew@beagleboard.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "menschel.p@posteo.de" <menschel.p@posteo.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "will@macchina.cc" <will@macchina.cc>
Subject: Re: [net-next 6/6] can: mcp251xfd: mcp251xfd_regmap_crc_read(): work
 around broken CRC on TBC register
Message-ID: <20211209112748.yixzz4xskw6qm7bw@pengutronix.de>
References: <PR3P174MB0112D073D0E5E080FAAE8510846E9@PR3P174MB0112.EURP174.PROD.OUTLOOK.COM>
 <DM4PR11MB5390BA1C370A5AF90E666F1EFB709@DM4PR11MB5390.namprd11.prod.outlook.com>
 <PA4P190MB1390F869654448440F869BCBD9709@PA4P190MB1390.EURP190.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="oytnvsin3ou5faq2"
Content-Disposition: inline
In-Reply-To: <PA4P190MB1390F869654448440F869BCBD9709@PA4P190MB1390.EURP190.PROD.OUTLOOK.COM>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--oytnvsin3ou5faq2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 09.12.2021 11:17:09, Sven Schuchmann wrote:
> we are also seeing the CRC Errors in our setup (rpi4, Kernel 5.10.x)
> from time to time. I just wanted to post here what I am seeing, maybe
> it helps...
>=20
> [    6.761711] spi_master spi1: will run message pump with realtime prior=
ity
> [    6.778063] mcp251xfd spi1.0 can1: MCP2518FD rev0.0 (-RX_INT -MAB_NO_W=
ARN +CRC_REG +CRC_RX +CRC_TX +ECC -HD c:40.00MHz m:20.00MHz r:17.00MHz e:16=
=2E66MHz) successfully initialized.
>=20
> [ 4327.107856] mcp251xfd spi1.0 canfd1: CRC read error at address 0x0010 =
(length=3D4, data=3D00 cc 62 c4, CRC=3D0xa3a0) retrying.
> [ 7770.163335] mcp251xfd spi1.0 canfd1: CRC read error at address 0x0010 =
(length=3D4, data=3D00 bf 16 d5, CRC=3D0x9d3c) retrying.
> [ 8000.565955] mcp251xfd spi1.0 canfd1: CRC read error at address 0x0010 =
(length=3D4, data=3D00 40 66 fa, CRC=3D0x31d7) retrying.
> [ 9753.658173] mcp251xfd spi1.0 canfd1: CRC read error at address 0x0010 =
(length=3D4, data=3D80 e9 01 4e, CRC=3D0xe862) retrying.

You are using the a back port of my HW timestamp in your v5.10 branch.
So every 45 seconds the TBC register (address 0x0010) is read,
additionally for every CAN error frame.

In the mean time, I've implemented a workaround for the CRC read errors:

| c7eb923c3caf can: mcp251xfd: mcp251xfd_regmap_crc_read(): work around bro=
ken CRC on TBC register
| ef7a8c3e7599 can: mcp251xfd: mcp251xfd_regmap_crc_read_one(): Factor out =
crc check into separate function

It fixes the CRC read error, if the first data byte is 0x00 or 0x80.

These messages should disappear, if you cherry-pick the above patches.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--oytnvsin3ou5faq2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmGx6DEACgkQqclaivrt
76kp2Qf9EiM0aGrx0jhLjB/y5OncFWUnLeSdIIHk0B64gjmdGSgVbLJOTalw1qEl
nDMMrrgt+puckO/jUdKaxOVMBcfwOhSlhyWerK5kELhTIrMhcpyGnrpfFKhuaTo6
3FIdJZw5QNJyVG80iiTHFRsdq9slnwvFlh8bMRmXNqAMA4tO2QktDCd2SF8m1AbI
po/8iScgegYayntJGoKvtGCsxwr7YSycIbPJYn+EUmz4JMRFi52YjAk+0Co54bbP
92+dBlNDIP0r2/kxtioK23F1IsnhHwEZnAb+ZmeE45tOJjeLSuGE1dE8nXn30t94
bNPXjMnZNZNqoVNtiY9OYBtZhETESw==
=YuoW
-----END PGP SIGNATURE-----

--oytnvsin3ou5faq2--
