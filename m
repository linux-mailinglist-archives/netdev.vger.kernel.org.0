Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD3735443E8
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 08:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239030AbiFIGie (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 02:38:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237739AbiFIGid (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 02:38:33 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D5C818D
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 23:38:33 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nzBo8-0007b3-Vj; Thu, 09 Jun 2022 08:38:17 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id D39B38FC19;
        Thu,  9 Jun 2022 06:38:13 +0000 (UTC)
Date:   Thu, 9 Jun 2022 08:38:13 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        michael@amarulasolutions.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 11/13] can: slcan: add ethtool support to reset
 adapter errors
Message-ID: <20220609063813.jf5u6iaghoae5dv3@pengutronix.de>
References: <20220607094752.1029295-1-dario.binacchi@amarulasolutions.com>
 <20220607094752.1029295-12-dario.binacchi@amarulasolutions.com>
 <20220607105225.xw33w32en7fd4vmh@pengutronix.de>
 <CABGWkvozX51zeQt16bdh+edsjwqST5A11qtfxYjTvP030DnToQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="meaz6sdtzfonjf73"
Content-Disposition: inline
In-Reply-To: <CABGWkvozX51zeQt16bdh+edsjwqST5A11qtfxYjTvP030DnToQ@mail.gmail.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--meaz6sdtzfonjf73
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 08.06.2022 18:33:08, Dario Binacchi wrote:
> Hi Marc,
>=20
> On Tue, Jun 7, 2022 at 12:52 PM Marc Kleine-Budde <mkl@pengutronix.de> wr=
ote:
> >
> > On 07.06.2022 11:47:50, Dario Binacchi wrote:
> > > This patch adds a private flag to the slcan driver to switch the
> > > "err-rst-on-open" setting on and off.
> > >
> > > "err-rst-on-open" on  - Reset error states on opening command
> > >
> > > "err-rst-on-open" off - Don't reset error states on opening command
> > >                         (default)
> > >
> > > The setting can only be changed if the interface is down:
> > >
> > >     ip link set dev can0 down
> > >     ethtool --set-priv-flags can0 err-rst-on-open {off|on}
> > >     ip link set dev can0 up
> > >
> > > Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
> >
> > I'm a big fan of bringing the device into a well known good state during
> > ifup. What would be the reasons/use cases to not reset the device?
>=20
> Because by default either slcand and slcan_attach don't reset the
> error states, but you must use the `-f' option to do so. So, I
> followed this use case.

Is this a CAN bus error state, like Bus Off or some controller (i.e. non
CAN related) error?

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--meaz6sdtzfonjf73
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKhlVIACgkQrX5LkNig
010rWwf9HB6gWqOXOHUenNrZwAxcodOEWKf9HqdVYBrIidjm28oCSW9rW7SP/L0C
mIA2qgvEybBovK6A7kB1ZEuhlVXdHLn4qvu2iTFEizO0tzw+UV2WvKUwKZkD9OrJ
v6A+hZJ7nNA4d/wimUElQO+o9y8QILrJB/phXF7eYBWhf8glUy1ORQiDfX8aqDsf
hXtzoFAiT50twWqiU+c76uISfN7gebeiavh2kDm4X3pAZm7nrEOCHwTFp6AjFE9P
WhPC+U5zJ9+KO4WN+o9l7BkywxhnpA+1s/29dUdHYvUb73RTEDtnO6rfMAnZS2KN
ilgx2QrRLrl9zLGPZqyx0y3z4OKUgQ==
=zxmi
-----END PGP SIGNATURE-----

--meaz6sdtzfonjf73--
