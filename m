Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB22A5479CD
	for <lists+netdev@lfdr.de>; Sun, 12 Jun 2022 12:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236148AbiFLKj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jun 2022 06:39:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236122AbiFLKjz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jun 2022 06:39:55 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53B8E65432
        for <netdev@vger.kernel.org>; Sun, 12 Jun 2022 03:39:54 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1o0L0J-000760-Co; Sun, 12 Jun 2022 12:39:35 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 84B4D932DE;
        Sun, 12 Jun 2022 10:39:32 +0000 (UTC)
Date:   Sun, 12 Jun 2022 12:39:31 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        michael@amarulasolutions.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 06/13] can: slcan: allow to send commands to the
 adapter
Message-ID: <20220612103931.3dugmcyn23udmve7@pengutronix.de>
References: <20220607094752.1029295-1-dario.binacchi@amarulasolutions.com>
 <20220607094752.1029295-7-dario.binacchi@amarulasolutions.com>
 <20220609071636.6tbspftu3yclip55@pengutronix.de>
 <CABGWkvp1=DF1uok4ZoCRt1EqpdrgdcytG==Ex6zuWgT5mrvdwQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="rklhevn5ngclcgjp"
Content-Disposition: inline
In-Reply-To: <CABGWkvp1=DF1uok4ZoCRt1EqpdrgdcytG==Ex6zuWgT5mrvdwQ@mail.gmail.com>
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


--rklhevn5ngclcgjp
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 11.06.2022 23:43:47, Dario Binacchi wrote:
> Hi Marc,
>=20
> On Thu, Jun 9, 2022 at 9:16 AM Marc Kleine-Budde <mkl@pengutronix.de> wro=
te:
> >
> > On 07.06.2022 11:47:45, Dario Binacchi wrote:
> > > This is a preparation patch for the upcoming support to change the
> > > bitrate via ip tool, reset the adapter error states via the ethtool A=
PI
> > > and, more generally, send commands to the adapter.
> > >
> > > Since some commands (e. g. setting the bitrate) will be sent before
> > > calling the open_candev(), the netif_running() will return false and =
so
> > > a new flag bit (i. e. SLF_XCMD) for serial transmission has to be add=
ed.
> > >
> > > Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
> >
> > I think this patch can be dropped, let me explain:
> >
> > You don't have to implement the do_set_bittiming callback. It's
> > perfectly OK to set the bitrate during the ndo_open callback after
> > open_candev().
>=20
> I developed what you suggested (i. e. remove the SLF_XCMD bit and set the
> bitrate, as well as send the "F\r" and "O\r" commands, after calling
> the open_candev(),

Note:
Max Staudt noticed that you need a do_set_bittiming() callback if you
have only fixed bitrates. I've create a patch that you can have fixed
bit rate only an no do_set_bittiming() callback.

| https://lore.kernel.org/all/20220611144248.3924903-1-mkl@pengutronix.de/

Or use the can-next/master branch as your base.

> but now I can't send the close command ("C\r") during the ndo_stop() since
> netif_running() returns false. The CAN framework clears netif_running() b=
efore
> calling the ndo_stop(). IMHO the SLF_XCMD bit then becomes necessary to
> transmit the commands to the adapter from the ndo_open() and
> ndo_stop() routines.
> Any suggestions ?

I see. Keep the setting of the bit rate in the ndo_open(), add the
SLF_XCMD so that you can send messages in ndo_close().

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--rklhevn5ngclcgjp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKlwmEACgkQrX5LkNig
013Eowf+KfCAs9Z0OKq+LFT5uWbL1qh9/1/auUskU/+EdODZkaDrh3bVZWFxQ0ZV
6UuRs7QhWOdxz2kJ7Q87dKDtEiRIqhZPkeiByyd5mR3WbluTICxOoMUfjEE50p2T
QQDTh+cfd5dSEy88SMxTt9aBKLasx90rkrSC30sPcdCvVKIXjWuyLbI2XdIKqygl
Vga1xqQXZAKtAJNeMcNhdlfiXtYKp8/fjhhX0qdOxcuIomqrD5mv7wplk4Omq4IU
F5p+PTHMaI26hvMQQtqhjM+5T/TCHfGCkYuw3X8jwRZV++mxNOd439YcCyLIw3Im
+gO8YIp3CoKam9k2szJKMC/z6+bZMw==
=xvcS
-----END PGP SIGNATURE-----

--rklhevn5ngclcgjp--
