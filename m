Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3BA154AA7F
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 09:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354193AbiFNHXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 03:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354170AbiFNHXE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 03:23:04 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C5BD2F3BA
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 00:22:58 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1o10sq-0002zC-HD; Tue, 14 Jun 2022 09:22:40 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id BFCE09460D;
        Tue, 14 Jun 2022 07:22:37 +0000 (UTC)
Date:   Tue, 14 Jun 2022 09:22:37 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org, michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
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
Subject: Re: [PATCH v3 13/13] can: slcan: extend the protocol with CAN state
 info
Message-ID: <20220614072237.d6crkhtqmbgjlw4e@pengutronix.de>
References: <20220612213927.3004444-1-dario.binacchi@amarulasolutions.com>
 <20220612213927.3004444-14-dario.binacchi@amarulasolutions.com>
 <20220613073706.rk3bve57zi2p3nnz@pengutronix.de>
 <CABGWkvqb3VHEMUaRsxcdL0+85hOSwJAtYWq+JskQ3KG+Hnca5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="6ycy5ldwkhbkgvki"
Content-Disposition: inline
In-Reply-To: <CABGWkvqb3VHEMUaRsxcdL0+85hOSwJAtYWq+JskQ3KG+Hnca5g@mail.gmail.com>
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


--6ycy5ldwkhbkgvki
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 14.06.2022 08:29:57, Dario Binacchi wrote:
> > > +     cmd[SLC_STATE_BE_TXCNT_LEN] =3D 0;
> > > +     if (kstrtou32(cmd, 10, &txerr))
> > > +             return;
> > > +
> > > +     *cmd =3D 0;
> > > +     cmd -=3D SLC_STATE_BE_RXCNT_LEN;
> > > +     if (kstrtou32(cmd, 10, &rxerr))
> > > +             return;
> >
> > Why do you parse TX first and then RX?
>=20
> Since adding the end-of-string character to the counter to be decoded
> invalidates the next one.
> If I had started from the rx counter, I would have found the
> transmission counter always at 0.

Thanks for the explanation.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--6ycy5ldwkhbkgvki
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKoNzoACgkQrX5LkNig
0117wQf/StmunxwhYlB9+A2hn7jBIh3c9dpjj8trKdaPs90i/hSL9awW0mAxFOOp
xy9qN4B3nWyl2lK3sJAEQgRPEJgmvybSP2hqh7+jS8lxsyIEtOIn37nyn/ZpwLrD
actsLV/9Nml+3JZcqss1hgF3fu6WMzpy+fuvokqps3wwU7nDA6CzJLfVBSCDHMQq
iTlsqQWV06RugoXVwDAeR/IznLVkXXJGLQM7YL2i1zxwMU1NUwQHyz/gFFcwkMau
h3rjb22EaUIJqguYrzI6KNkeo0rbPrEkmUIjwfV+A/J2A7aQ328f/tuJlPS4lOnZ
/XS16dNKvjmrX4GoRbtXzvumwz8R9Q==
=xAw3
-----END PGP SIGNATURE-----

--6ycy5ldwkhbkgvki--
