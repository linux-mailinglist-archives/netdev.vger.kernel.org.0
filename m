Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 358BF5424B2
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 08:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346123AbiFHCQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 22:16:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445452AbiFHCM2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 22:12:28 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C71161D7867
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 13:27:16 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nyfnA-0004V9-Bf; Tue, 07 Jun 2022 22:27:08 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 07BAC8E60C;
        Tue,  7 Jun 2022 20:27:06 +0000 (UTC)
Date:   Tue, 7 Jun 2022 22:27:06 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        linux-can <linux-can@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Max Staudt <max@enpas.org>, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v5 0/7] can: refactoring of can-dev module and of Kbuild
Message-ID: <20220607202706.7fbongzs3ixzpydm@pengutronix.de>
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220604163000.211077-1-mailhol.vincent@wanadoo.fr>
 <2e8666f3-1bd9-8610-6b72-e56e669d3484@hartkopp.net>
 <CAMZ6RqKWUyf6dZmxG809-yvjg5wbLwPSLtEfv-MgPpJ5ra=iGQ@mail.gmail.com>
 <f161fdd0-415a-8ea1-0aad-3a3a19f1bfa8@hartkopp.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="be3gaq45kmwca64p"
Content-Disposition: inline
In-Reply-To: <f161fdd0-415a-8ea1-0aad-3a3a19f1bfa8@hartkopp.net>
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


--be3gaq45kmwca64p
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 07.06.2022 22:12:46, Oliver Hartkopp wrote:
> So what about:
>=20
>   symbol: CONFIG_NETDEVICES
>   |
>   +-> CAN Device Drivers
>       symbol: CONFIG_CAN_DEV
>       |
>       +-> software/virtual CAN device drivers
>       |   (at time of writing: slcan, vcan, vxcan)
>       |
>       +-> hardware CAN device drivers with Netlink support
>           symbol: CONFIG_CAN_NETLINK (matches previous CONFIG_CAN_DEV)
>           |
>           +-> CAN bit-timing calculation (optional for all drivers)
>           |   symbol: CONFIG_CAN_BITTIMING
>           |
>           +-> CAN rx offload (optional but selected by some drivers)
>           |   symbol: CONFIG_CAN_RX_OFFLOAD
>           |
>           +-> CAN devices drivers
>               (some may select CONFIG_CAN_RX_OFFLOAD)
>=20
> (I also added 'hardware' to CAN device drivers with Netlink support) to h=
ave
> a distinction to 'software/virtual' CAN device drivers)

The line between hardware and software/virtual devices ist blurry, the
new can327 driver uses netlink and the slcan is currently being
converted....

> At least this would help me to understand the new configuration setup.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--be3gaq45kmwca64p
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKftJcACgkQrX5LkNig
010rdwf5AUPYBTdJwcRgNV7YEssM6aMUpKhLxP4yEIJIYnySSUNhKOtPk4M4EUbr
Kotj3KZDHtuwOQWG/IVr+1Amf3D3U1D0O5uJI7MzrUevZB1SJLmLJZINNETlg6OB
Qkc0PTP2QApy8WSp/p5v50p3/JXKI87dnw3voHZaMR3GtWRdV5oLvY6PMXAFonjg
i9jtJebTbTddPujmvBMXW6SglL1f+0Xm52JLC+aMQ4uCnBFMG9f4WxAblZ5JNGJI
PrT74Nh6w9jwOyG46IMUe446DLEAu/v2zvt8nbbknsyM0Pt59+bZYWlrVFU025Dz
6NvUd0zOM47E/CCmCCfb7wIEWIC/Gg==
=XKVp
-----END PGP SIGNATURE-----

--be3gaq45kmwca64p--
