Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3A6A378091
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 11:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbhEJJzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 05:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231373AbhEJJzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 05:55:19 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE51C061347
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 02:54:13 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lg2c5-0000Jl-Rz; Mon, 10 May 2021 11:54:09 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:80ab:77d5:ac71:3f91])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 4F4086200AF;
        Mon, 10 May 2021 07:43:35 +0000 (UTC)
Date:   Mon, 10 May 2021 09:43:34 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Patrick Menschel <menschel.p@posteo.de>
Cc:     Drew Fustini <drew@beagleboard.org>, netdev@vger.kernel.org,
        linux-can@vger.kernel.org, Will C <will@macchina.cc>
Subject: Re: [net-next 6/6] can: mcp251xfd: mcp251xfd_regmap_crc_read(): work
 around broken CRC on TBC register
Message-ID: <20210510074334.el2yxp3oy2pmbs7d@pengutronix.de>
References: <20210407080118.1916040-1-mkl@pengutronix.de>
 <20210407080118.1916040-7-mkl@pengutronix.de>
 <CAPgEAj6N9d=s1a-P_P0mBe1aV2tQBQ4m6shvbPcPvX7W1NNzJw@mail.gmail.com>
 <a46b95e3-4238-a930-6de3-360f86beaf52@pengutronix.de>
 <20210507072521.3y652xz2kmibjo7d@pengutronix.de>
 <c0048a2a-2a32-00b5-f995-f30453aaeedb@posteo.de>
 <20210507082536.jgmaoyusp3papmlw@pengutronix.de>
 <7cb69acc-ee56-900b-0320-a893f687d850@posteo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="blwrjgfaxnv3raxp"
Content-Disposition: inline
In-Reply-To: <7cb69acc-ee56-900b-0320-a893f687d850@posteo.de>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--blwrjgfaxnv3raxp
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 08.05.2021 18:36:56, Patrick Menschel wrote:
> ### Test conditions ###
>=20
> Since I lacked a true stress test, I wrote one for regular tox with
> pytest collection.
>=20
> https://gitlab.com/Menschel/socketcan/-/blob/master/tests/test_socketcan.=
py#L872
>=20
> It uses mcp0 and mcp1 which are directly connected.
> No CAN FD, just 500k with regular frames, random id and random data.
>=20
> I basically mimic cangen but enhanced with a queue that handles to the
> rx thread what should be compared next.
>=20
> ### Extract from dmesg shows no CRC Errors ###
>=20
> [   30.930608] CAN device driver interface
> [   30.967349] spi_master spi0: will run message pump with realtime prior=
ity
> [   31.054202] mcp251xfd spi0.1 can0: MCP2518FD rev0.0 (-RX_INT
> -MAB_NO_WARN +CRC_REG +CRC_RX +CRC_TX +ECC -HD c:40.00MHz m:20.00MHz
> r:17.00MHz e:16.66MHz) successfully initialized.
> [   31.076906] mcp251xfd spi0.0 can1: MCP2518FD rev0.0 (-RX_INT
> -MAB_NO_WARN +CRC_REG +CRC_RX +CRC_TX +ECC -HD c:40.00MHz m:20.00MHz
> r:17.00MHz e:16.66MHz) successfully initialized.
> [   31.298969] mcp251xfd spi0.0 mcp0: renamed from can1
> [   31.339864] mcp251xfd spi0.1 mcp1: renamed from can0
> [   33.471889] IPv6: ADDRCONF(NETDEV_CHANGE): mcp0: link becomes ready
> [   34.482260] IPv6: ADDRCONF(NETDEV_CHANGE): mcp1: link becomes ready
> [  215.218979] can: controller area network core
> [  215.219146] NET: Registered protocol family 29
> [  215.261599] can: raw protocol
> [  218.745376] can: isotp protocol
> [  220.931150] NOHZ tick-stop error: Non-RCU local softirq work is
> pending, handler #08!!!
> [  220.931274] NOHZ tick-stop error: Non-RCU local softirq work is
> pending, handler #08!!!
> [  220.931395] NOHZ tick-stop error: Non-RCU local softirq work is
> pending, handler #08!!!
> [  220.931518] NOHZ tick-stop error: Non-RCU local softirq work is
> pending, handler #08!!!
> [  220.931643] NOHZ tick-stop error: Non-RCU local softirq work is
> pending, handler #08!!!
> [  220.931768] NOHZ tick-stop error: Non-RCU local softirq work is
> pending, handler #08!!!
> [  220.931893] NOHZ tick-stop error: Non-RCU local softirq work is
> pending, handler #08!!!
> [  222.099822] NOHZ tick-stop error: Non-RCU local softirq work is
> pending, handler #08!!!
> [  222.099901] NOHZ tick-stop error: Non-RCU local softirq work is
> pending, handler #08!!!
> [  222.100022] NOHZ tick-stop error: Non-RCU local softirq work is
> pending, handler #08!!!
> [  222.330438] can: broadcast manager protocol
>=20
> That softirq error has something to do with IsoTp. I was not able to
> trace it back but I have it on multiple boards: pi0w, pi3b, pi3b+.

The softirq error is known and shows up as the mcp251xfd driver raises a
softirq from threaded IRQ context. We're working on fixing this.

> ### Performance ###
>=20
> ## v5.10-rpi/backport-performance-improvements ##
>=20
> I get about 20000 frames in 2 minutes.
>=20
> 2021-05-08 19:00:36 [    INFO] 20336 frames in 0:02:00
> (test_socketcan.py:890)
>=20
> 2021-05-08 19:49:34 [    INFO] 20001 frames in 0:02:00
> (test_socketcan.py:890)
>=20
>=20
> ## regular v5.10 ##
>=20
> 2021-05-08 20:19:55 [    INFO] 20000 frames in 0:02:00
> (test_socketcan.py:890)
>=20
> 2021-05-08 20:22:40 [    INFO] 19995 frames in 0:02:00
> (test_socketcan.py:890)
>=20
> 2021-05-08 20:25:22 [    INFO] 19931 frames in 0:02:00
> (test_socketcan.py:890)
>=20
>=20
> The numbers are slightly better but I count that as tolerance.

Makes sense. But you have only measured number of frames in a given
time. The raspi SPI driver is highly optimized so the changes in the
driver don't show up in those numbers.

Thanks for testing, I'll send a pull request to the raspi kernel.

If you are interested if there are performance benefits on your raspi,
consider measuring the spent CPU time and the number of SPI interrupts.

Measure CPU time by putting the command "time" in front of your test.
Measure SPI Interrupts by looking at /proc/interrupts before and after
the test. Note: there are SPI host controller interrupts and Interrupts
=66rom the mcp251xfd.

On a raspi you probably only have a hand full of SPI host controller
interrupts, as the raspi driver only uses interrupts for long transfers.
There will be a mcp251xfd interrupt per TX-complete and RX CAN message,
maybe a few less if they overlap.

> I also found that there are cross effects. If I run the same test on
> vcan0 before, the frame count goes down to 13000 instead.

The changes only touch the mcp251xfd driver, if you see a difference
with the vcan driver, it's either a change in the kernel somewhere else
or your test setup is sensitive to something you changed without
noticing (starting condition, ...)

> I also have to admit, that I didn't get any crc errors with regular
> v5.10 during that tests.

The CRC errors the patch works around are CRC errors introduced by a
chip erratum, not by electromagnetic interference. In my observation
these CRC errors show up if the register contents changes while the
register is read. The register that changes most is the timer base
counter register. That register is only read if a CAN bus error is
signaled to user space (and this is maximized by enabling bus error
reporting). If it happens to be a CRC error while reading the TBC
register and the CRC can be "corrected" by flipping the upper most bit,
there will be no error message about any CRC errors.

Long story short. You only notice that this patch works, if in a
situation you had CRC errors on the TBC register (that is CAN errors are
reported to user space), you now have an order of magnitude less CRC
errors than before.

> Do I have to change my test?

No need to.

> I can still update that pi3b+ that runs my micro-hil at work. That was
> the one that occasionally had CRC errors.

Thanks again for testing!

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--blwrjgfaxnv3raxp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmCY5CMACgkQqclaivrt
76nNvgf/QWqJ46argscNlnGBhEJ1mLhxO7YwQnKUOLcR5BewaSmMp7InVO3L6bsa
OEaNFwDMihocilzfIx4B2+E39IKxV2lw/NnTYygSK2br4fANx9sgomMcRQJc+AvQ
BZR9AJPA2/DDdJykDthh/eLveurgDzzmg9yM7+xIqN0LZ/z19TjX2gYnR0hbMQfz
BkxaA21VIzXLGzIenju/UknAUtNdZpBthQ8VwE2wSXhowKFXyQaFDZV/IaVSb+Af
CI9128Y3pWDqDgD3UjFZJFdNmzY12NTpGBeqDb9rrGi2pcHeF1sPsQIeuTvztBpY
qJZn4RhBDW0bFzZzG8loujn1i67wzQ==
=//0p
-----END PGP SIGNATURE-----

--blwrjgfaxnv3raxp--
