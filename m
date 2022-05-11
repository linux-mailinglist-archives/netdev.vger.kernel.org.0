Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59FAD523645
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 16:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245175AbiEKOyu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 10:54:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245176AbiEKOyt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 10:54:49 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22002206054
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 07:54:48 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nonjb-0004hJ-8l; Wed, 11 May 2022 16:54:39 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 0DC5C7BE0D;
        Wed, 11 May 2022 14:54:38 +0000 (UTC)
Date:   Wed, 11 May 2022 16:54:37 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Devid Antonio Filoni <devid.filoni@egluetechnologies.com>,
        kernel@pengutronix.de, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Jander <david@protonic.nl>
Subject: Re: [PATCH 1/1] can: skb: add and set local_origin flag
Message-ID: <20220511145437.oezwkcprqiv5lfda@pengutronix.de>
References: <20220511121913.2696181-1-o.rempel@pengutronix.de>
 <b631b022-72d5-9160-fd13-f33c80dbbe59@hartkopp.net>
 <20220511132421.7o5a3po32l3w2wcr@pengutronix.de>
 <20220511143620.kphwgp2vhjyoecs5@pengutronix.de>
 <002d234f-a7d6-7b1a-72f4-157d7a283446@hartkopp.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="vyh5zz5idfblqisk"
Content-Disposition: inline
In-Reply-To: <002d234f-a7d6-7b1a-72f4-157d7a283446@hartkopp.net>
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


--vyh5zz5idfblqisk
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 11.05.2022 16:50:06, Oliver Hartkopp wrote:
>=20
>=20
> On 5/11/22 16:36, Marc Kleine-Budde wrote:
> > On 11.05.2022 15:24:21, Marc Kleine-Budde wrote:
> > > On 11.05.2022 14:38:32, Oliver Hartkopp wrote:
> > > > IMO this patch does not work as intended.
> > > >=20
> > > > You probably need to revisit every place where can_skb_reserve() is=
 used,
> > > > e.g. in raw_sendmsg().
> > >=20
> > > And the loopback for devices that don't support IFF_ECHO:
> > >=20
> > > | https://elixir.bootlin.com/linux/latest/source/net/can/af_can.c#L257
> >=20
> > BTW: There is a bug with interfaces that don't support IFF_ECHO.
> >=20
> > Assume an invalid CAN frame is passed to can_send() on an interface that
> > doesn't support IFF_ECHO. The above mentioned code does happily generate
> > an echo frame and it's send, even if the driver drops it, due to
> > can_dropped_invalid_skb(dev, skb).
> >=20
> > The echoed back CAN frame is treated in raw_rcv() as if the headroom is=
 valid:
> >=20
> > | https://elixir.bootlin.com/linux/v5.17.6/source/net/can/raw.c#L138
> >=20
> > But as far as I can see the can_skb_headroom_valid() check never has
> > been done. What about this patch?
> >=20
> > index 1fb49d51b25d..fda4807ad165 100644
> > --- a/net/can/af_can.c
> > +++ b/net/can/af_can.c
> > @@ -255,6 +255,9 @@ int can_send(struct sk_buff *skb, int loop)
> >                   */
> >                  if (!(skb->dev->flags & IFF_ECHO)) {
> > +                       if (can_dropped_invalid_skb(dev, skb))
> > +                               return -EINVAL;
> > +
>=20
> Good point!
>=20
> But please check the rest of the code.
> You need 'goto inval_skb;' instead of the return ;-)

Why? To free the skb? That's what can_dropped_invalid_skb() does, too:

| https://elixir.bootlin.com/linux/v5.17.6/source/include/linux/can/skb.h#L=
130

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--vyh5zz5idfblqisk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmJ7zioACgkQrX5LkNig
012WlwgArROLPgtUfP+HtShqIokTztQc8dLjiIYQFXgtmhtezGcgbl16AC+H3PHt
V5jAyFvWWtgB43ckZHOouRPWzt6ZfkGodr30p2svwBJaYG5DXzqI5jzJtaJToMhY
alvKFCii+g+Bx26r1RCl/3r/+JcoYBFQeZx3HmrhMcekmN0RMYx44Fl2A26YFowC
WfrK/tVp37vxSll/HGEs88EQ5FkhVswBgwbdLRWgV+5DoygvufYn3kuxlSN568+j
ChLjzbk24hZ8EQp3oOveLUgDm5CymM8wub2av8tJAzdBwoHeJ2SY5L3M6w+T3WnA
jrO7jfTDEbnDUY8QhvsefTYIgTHuWw==
=kJDD
-----END PGP SIGNATURE-----

--vyh5zz5idfblqisk--
