Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72CCD4308BC
	for <lists+netdev@lfdr.de>; Sun, 17 Oct 2021 14:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245679AbhJQMir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 08:38:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245686AbhJQMio (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 08:38:44 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 229FEC06176A
        for <netdev@vger.kernel.org>; Sun, 17 Oct 2021 05:36:34 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mc5Or-0004sm-Ic; Sun, 17 Oct 2021 14:36:25 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-7b24-848c-3829-1203.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:7b24:848c:3829:1203])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 44EC5695CD8;
        Sun, 17 Oct 2021 12:36:23 +0000 (UTC)
Date:   Sun, 17 Oct 2021 14:36:22 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dongliang Mu <mudongliangabcd@gmail.com>
Cc:     Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>,
        Naga Sureshkumar Relli <naga.sureshkumar.relli@xilinx.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        linux-can@vger.kernel.org,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] driver: net: can: delete napi if register_candev fails
Message-ID: <20211017123622.nfyis7o235tb2qad@pengutronix.de>
References: <20211013040349.2858773-1-mudongliangabcd@gmail.com>
 <CAD-N9QWTP8DLtAN70Xxap+WhNUfh9ixfeDMuNaB2NnpFhuAN8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="dfm43gs7fxhcrzkr"
Content-Disposition: inline
In-Reply-To: <CAD-N9QWTP8DLtAN70Xxap+WhNUfh9ixfeDMuNaB2NnpFhuAN8A@mail.gmail.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--dfm43gs7fxhcrzkr
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 13.10.2021 13:21:09, Dongliang Mu wrote:
> On Wed, Oct 13, 2021 at 12:04 PM Dongliang Mu <mudongliangabcd@gmail.com>=
 wrote:
> >
> > If register_candev fails, xcan_probe does not clean the napi
> > created by netif_napi_add.
> >
>=20
> It seems the netif_napi_del operation is done in the free_candev
> (free_netdev precisely).
>=20
> list_for_each_entry_safe(p, n, &dev->napi_list, dev_list)
>           netif_napi_del(p);
>=20
> And list_add_rcu(&napi->dev_list, &dev->napi_list) is done in the
> netif_napi_add.
>=20
> Therefore, I suggest removing "netif_napi_del" operation in the
> xcan_remove to match probe and remove function.

Sounds reasonable, can you create a patch for this.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--dfm43gs7fxhcrzkr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmFsGMMACgkQqclaivrt
76n7igf8CvP7xI7j1Eqn4NDnUwcP2SDkko7tGu/cFltCOZ6NwQ5DNo+VwAvhQIwA
wO2XgNcA81EuK+TX4Oq0+XjvCbiaVjS2Y3bwHNNVpJbUhDmqiq0QknGGbfwqkTks
OXlv5INJSkVLCvadeTIenBUgB4KLygX0XM0hyZCejRf3SeCM/LJvJuYt6jtxWCjM
qZndqek8+fvgllTBkVO/sv5fvyxDq0JErWfbTuxk6aLI6tiRqBhQgi0li+VHVcSV
F9e7Tw9tSVMo63RhCoAu4Glina1nHl/G/ToEfOgJZjo56a212y2Gfs6QSyW53VCR
oQsEjpBIfaG3B/RFfvw9/70gG4CuwQ==
=KM5O
-----END PGP SIGNATURE-----

--dfm43gs7fxhcrzkr--
