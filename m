Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65AE16425FE
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 10:45:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbiLEJpQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 04:45:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230324AbiLEJpO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 04:45:14 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDD7A1903A
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 01:45:13 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p2827-0004t1-VD; Mon, 05 Dec 2022 10:45:08 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:c1b8:7ff9:10eb:2660])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 7D4821362AB;
        Mon,  5 Dec 2022 09:45:06 +0000 (UTC)
Date:   Mon, 5 Dec 2022 10:44:58 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Markus Schneider-Pargmann <msp@baylibre.com>
Cc:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/15] can: tcan4x5x: Fix register range of first block
Message-ID: <20221205094458.xkvlvp7fnygf23fq@pengutronix.de>
References: <20221116205308.2996556-1-msp@baylibre.com>
 <20221116205308.2996556-15-msp@baylibre.com>
 <20221202142810.kmd5m26fnm6lw2jh@pengutronix.de>
 <20221205093013.kpsqyb3fhd5njubm@blmsp>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="d45yhfs3ex7kqilv"
Content-Disposition: inline
In-Reply-To: <20221205093013.kpsqyb3fhd5njubm@blmsp>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--d45yhfs3ex7kqilv
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 05.12.2022 10:30:13, Markus Schneider-Pargmann wrote:
> Hi Marc,
>=20
> On Fri, Dec 02, 2022 at 03:28:10PM +0100, Marc Kleine-Budde wrote:
> > On 16.11.2022 21:53:07, Markus Schneider-Pargmann wrote:
> > > According to the datasheet 0x1c is the last register in the first blo=
ck,
> > > not register 0x2c.
> >=20
> > The datasheet "SLLSF91A =E2=80=93 DECEMBER 2018 =E2=80=93 REVISED JANUA=
RY 2020" says:
> >=20
> > | 8.6.1 Device ID and Interrupt/Diagnostic Flag Registers: 16'h0000 to
> > | 16'h002F
> >=20
> > While the last described register is at 0xc.
>=20
> Sorry, not sure what I looked up here. The last described register is
> 0x10 SPI Error status mask in my datasheet:
> 'SLLSEZ5D =E2=80=93 JANUARY 2018 =E2=80=93 REVISED JUNE 2022'

The TCAN4550-Q1 variant has the 0x10 register documented, while the
TCAN4550 (w/o -Q1) doesn't have.

> I would prefer using the actual registers if that is ok with you, so
> 0x10 here because I assume the remaining registers have internal use or
> maybe don't exist at all?! If there is an undocumented register that
> needs to be used at some point we can still modify the ranges.

I'm fine with using 0x10 as the last register.

> Also it seems the existing ranges are following the same logic and don't
> list the whole range, just the documented registers.
>=20
> The second range is wrong as well. The last register is 0x830, will
> fix.

IIRC I used the register ranges from the section titles ("8.6.1 Device
ID and Interrupt/Diagnostic Flag Registers: 16'h0000 to 16'h002F") when
I added the {wr,rd}_table.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--d45yhfs3ex7kqilv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmONvZYACgkQrX5LkNig
013z1QgAjPwBzVU/x6eVgTdQF2PdBSxxR0pwfZ5/P+K/RPjyWJaXjXlt/gjgeR0Y
GHY6YFgMg1DoyVP8AQmJQzoX+fkNKNbkpbmO8gF034cE5W3Grxz2A4mG7fRYQpnb
u1vQvzfRDROsmr257PgNQHy84zTVjK9l5KSmdSGZxsj+uA/Y8W+1LmsHyQDa3pBZ
qmhhKtCKJ0hkUP7Az7ujfeiKsMzwdXqyvfdcbEzm2ytW89pa9361lTJ0/eCB9Zke
OUin8fexcYc0pzx3fu5BdTt0uU1KWK4gvmR49ku8KtkEJmE9SvReQRbUwvzjY1B8
Kz+lrElpIK7kmuH/3i/poGELti3y5A==
=oU/3
-----END PGP SIGNATURE-----

--d45yhfs3ex7kqilv--
