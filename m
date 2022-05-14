Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF795273E0
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 22:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235035AbiENUNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 May 2022 16:13:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbiENUNj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 May 2022 16:13:39 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE2F1140E5
        for <netdev@vger.kernel.org>; Sat, 14 May 2022 13:13:38 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1npy8r-00010h-Ek; Sat, 14 May 2022 22:13:33 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 5CA4D7E427;
        Sat, 14 May 2022 20:13:32 +0000 (UTC)
Date:   Sat, 14 May 2022 22:13:31 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Matej Vasilevski <matej.vasilevski@seznam.cz>
Cc:     devicetree@vger.kernel.org, linux-can@vger.kernel.org,
        pisa@cmp.felk.cvut.cz, ondrej.ille@gmail.com,
        netdev@vger.kernel.org, martin.jerabek01@gmail.com
Subject: Re: [RFC PATCH 1/3] can: ctucanfd: add HW timestamps to RX and error
 CAN frames
Message-ID: <20220514201331.xv5ofxbzrv5ti3bi@pengutronix.de>
References: <20220512232706.24575-1-matej.vasilevski@seznam.cz>
 <20220512232706.24575-2-matej.vasilevski@seznam.cz>
 <20220513114135.lgbda6armyiccj3o@pengutronix.de>
 <20220514091741.GA203806@hopium>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="qf7flepnkiv2qd3k"
Content-Disposition: inline
In-Reply-To: <20220514091741.GA203806@hopium>
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


--qf7flepnkiv2qd3k
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 14.05.2022 11:18:08, Matej Vasilevski wrote:
> > > +	timecounter_init(&priv->tc, &priv->cc, 0);
> >=20
> > You here set the offset of the HW clock to 1.1.1970. The mcp driver sets
> > the offset to current time. I think it's convenient to have the current
> > time here....What do you think.
>=20
> I actually searched in the mailing list and read your conversation with
> Vincent on timestamps starting from 0 or synced to current time.
> https://lore.kernel.org/linux-can/CAMZ6RqL+n4tRy-B-W+fzW5B3QV6Bedrko57pU_=
0TE023Oxw_5w@mail.gmail.com/

Thanks for looking up that discussion. Back than I was arguing for the
start from 0, but in the mean time I added TS support for the mcp251xfd,
which starts with the current time :)

> Then I discussed it with Pavel Pisa and he requested to start from 0.
> Reasons are that system time can change (NTP, daylight saving time,
> user settings etc.), so when it starts from 0 it is clear that it is
> "timestamp time".
>=20
> Are there a lot of CAN drivers synced to system time? I think this would
> be a good argument for syncing, to keep things nice and cohesive in
> the CAN subsystem.
>=20
> Overall I wouldn't want to block this patch over such a minutiae.

ACK

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--qf7flepnkiv2qd3k
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKADWkACgkQrX5LkNig
010EaQf+P4PDQgB1q9NTsep6x1FkFyAyBf5nFcWP7FYQjvbfOq/3Tuq5/LZsZuKQ
/ac++Fw7u6iHtZQAHWg9vtmqlDTHR3UQlBEux7siRQXnUNoNopekN8qYKic5bx71
2aVhD4EmFxOb0jFFhBaOisIi9xmRRXG/kgUyJHQMBPL+gljx3mvbA/PfiIjvCT4L
KNOizvTR0V0DpdhAl7oceu9AJg97qJ+RSOyyZx7q3vke/LB+8uXWSmdGkms1wcbI
duCDQ0sFHOqsUdWnqbxfYh9Ph1aep47fqd5cOygN7zbXPA5XpY1VppQYbdsoU0ez
bfH19KOUpJGU4DPhjj0zXG2bWh78nw==
=6ZCc
-----END PGP SIGNATURE-----

--qf7flepnkiv2qd3k--
