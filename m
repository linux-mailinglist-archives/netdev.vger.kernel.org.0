Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3BE760E0C5
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 14:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232289AbiJZMfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 08:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232733AbiJZMfR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 08:35:17 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04F5E3C8FB
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 05:35:16 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1onfcS-0004px-7R; Wed, 26 Oct 2022 14:34:52 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 410C610A4CF;
        Wed, 26 Oct 2022 12:34:47 +0000 (UTC)
Date:   Wed, 26 Oct 2022 14:34:46 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Stefan =?utf-8?B?TcOkdGpl?= <stefan.maetje@esd.eu>,
        Ulrich Hecht <uli+renesas@fpond.eu>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] can: rcar_canfd: Fix channel specific IRQ
 handling for RZ/G2L
Message-ID: <20221026123446.c6ob45mbke5aj7f5@pengutronix.de>
References: <20221025155657.1426948-1-biju.das.jz@bp.renesas.com>
 <20221025155657.1426948-3-biju.das.jz@bp.renesas.com>
 <20221026073608.7h47b2axcayakfnn@pengutronix.de>
 <OS0PR01MB5922FCC50E590DFDD041F99386309@OS0PR01MB5922.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="vaotwjwncsnvez7t"
Content-Disposition: inline
In-Reply-To: <OS0PR01MB5922FCC50E590DFDD041F99386309@OS0PR01MB5922.jpnprd01.prod.outlook.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--vaotwjwncsnvez7t
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 26.10.2022 09:34:41, Biju Das wrote:
> > In a separate patch, please clean up these, too:
> >=20
> > | static void rcar_canfd_handle_global_err(struct rcar_canfd_global
> > | *gpriv, u32 ch) static void rcar_canfd_handle_global_receive(struct
> > | rcar_canfd_global *gpriv, u32 ch) static void
> > | rcar_canfd_channel_remove(struct rcar_canfd_global *gpriv, u32 ch)
> >=20
> > Why are 2 of the above functions called "global" as they work on a
> > specific channel? That can be streamlined, too.
> >=20
>=20
> The function name is as per the hardware manual, Interrupt sources are
> classified into global and channel interrupts.
>=20
> =E2=80=A2 Global interrupts (2 sources):
> =E2=80=94 Receive FIFO interrupt
> =E2=80=94 Global error interrupt
> =E2=80=A2 Channel interrupts (3 sources/channel):

I see. Keep the functions as is.

> Maybe we could change
> "rcar_canfd_handle_global_receive"->"rcar_canfd_handle_channel_receive",
> as from driver point It is not global anymore?? Please let me know.

Never mind - the gpriv and channel numbers are needed sometimes even in
the functions working on a single channel. Never mind. I'll take patches
1 and 2 as they are.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--vaotwjwncsnvez7t
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmNZKWMACgkQrX5LkNig
012qEwf+IRYuA9W199F7lK+OZ9LCZLMzCed0EZnhpRjNzWkunT6lMfTSSNUL1apw
Qyu3cfl+mJzHhyNOJtreY/FewgK012S9YOfoymhIf8UCZh7Q9TFxvHrXqfGWac8A
mD1GjrRPXiljwLJZpCCGGH6sl0XdxU36Oityfen15SCHNVogOYyPH1SlfPbRfAuN
KVc6Hd4DP/lixQtqkHM9kUtVbVEf6g5zT1z74rHRe17uYCWcLl2dK9KNA3JVrkgF
jaQC1f1E0UJRJn/Bk+K3btsjEcOU5vVW6dsvVt89tO2nSPnie1YSubcJQpu+YtLW
P9LuZUV9pgit9+KlAdXD4B65/Syy4A==
=DMUx
-----END PGP SIGNATURE-----

--vaotwjwncsnvez7t--
