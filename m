Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46D9B53D6D4
	for <lists+netdev@lfdr.de>; Sat,  4 Jun 2022 14:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243390AbiFDMlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jun 2022 08:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242066AbiFDMlr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jun 2022 08:41:47 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C95D31536
        for <netdev@vger.kernel.org>; Sat,  4 Jun 2022 05:41:46 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nxT65-0008AR-Cl; Sat, 04 Jun 2022 14:41:41 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 4A9248C334;
        Sat,  4 Jun 2022 12:41:40 +0000 (UTC)
Date:   Sat, 4 Jun 2022 14:41:39 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Staudt <max@enpas.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev@vger.kernel.org
Subject: Re: [PATCH v4 3/7] can: bittiming: move bittiming calculation
 functions to calc_bittiming.c
Message-ID: <20220604124139.pg2h33zanyqs54q5@pengutronix.de>
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220603102848.17907-1-mailhol.vincent@wanadoo.fr>
 <20220603102848.17907-4-mailhol.vincent@wanadoo.fr>
 <20220604112538.p4hlzgqnodyvftsj@pengutronix.de>
 <CAMZ6RqLg_Enyn1h+sn=o8rc8kkR6r=YaygLy40G9D4=Ug_KxOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ora2vppsbqlisv3t"
Content-Disposition: inline
In-Reply-To: <CAMZ6RqLg_Enyn1h+sn=o8rc8kkR6r=YaygLy40G9D4=Ug_KxOg@mail.gmail.com>
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


--ora2vppsbqlisv3t
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 04.06.2022 21:21:01, Vincent MAILHOL wrote:
> On Sat. 4 June 2022 at 20:25, Marc Kleine-Budde <mkl@pengutronix.de> wrot=
e:
> > On 03.06.2022 19:28:44, Vincent Mailhol wrote:
> > > The canonical way to select or deselect an object during compilation
> > > is to use this pattern in the relevant Makefile:
> > >
> > > bar-$(CONFIG_FOO) :=3D foo.o
> > >
> > > bittiming.c instead uses some #ifdef CONFIG_CAN_CALC_BITTIMG.
> > >
> > > Create a new file named calc_bittiming.c with all the functions which
> > > are conditionally compiled with CONFIG_CAN_CALC_BITTIMG and modify the
> > > Makefile according to above pattern.
> > >
> > > Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> > > ---
> > >  drivers/net/can/Kconfig              |   4 +
> > >  drivers/net/can/dev/Makefile         |   2 +
> > >  drivers/net/can/dev/bittiming.c      | 197 --------------------------
> > >  drivers/net/can/dev/calc_bittiming.c | 202 +++++++++++++++++++++++++=
++
> > >  4 files changed, 208 insertions(+), 197 deletions(-)
> > >  create mode 100644 drivers/net/can/dev/calc_bittiming.c
> > >
> > > diff --git a/drivers/net/can/Kconfig b/drivers/net/can/Kconfig
> > > index b1e47f6c5586..8f3b97aea638 100644
> > > --- a/drivers/net/can/Kconfig
> > > +++ b/drivers/net/can/Kconfig
> > > @@ -96,6 +96,10 @@ config CAN_CALC_BITTIMING
> > >         source clock frequencies. Disabling saves some space, but the=
n the
> > >         bit-timing parameters must be specified directly using the Ne=
tlink
> > >         arguments "tq", "prop_seg", "phase_seg1", "phase_seg2" and "s=
jw".
> > > +
> > > +       The additional features selected by this option will be added=
 to the
> > > +       can-dev module.
> > > +
> > >         If unsure, say Y.
> > >
> > >  config CAN_AT91
> > > diff --git a/drivers/net/can/dev/Makefile b/drivers/net/can/dev/Makef=
ile
> > > index 919f87e36eed..b8a55b1d90cd 100644
> > > --- a/drivers/net/can/dev/Makefile
> > > +++ b/drivers/net/can/dev/Makefile
> > > @@ -9,3 +9,5 @@ can-dev-$(CONFIG_CAN_NETLINK) +=3D dev.o
> > >  can-dev-$(CONFIG_CAN_NETLINK) +=3D length.o
> > >  can-dev-$(CONFIG_CAN_NETLINK) +=3D netlink.o
> > >  can-dev-$(CONFIG_CAN_NETLINK) +=3D rx-offload.o
> > > +
> > > +can-dev-$(CONFIG_CAN_CALC_BITTIMING) +=3D calc_bittiming.o
> >
> > Nitpick:
> > Can we keep this list sorted?
>=20
> My idea was first to group per CONFIG symbol according to the
> different levels: CAN_DEV first, then CAN_NETLINK and finally
> CAN_CALC_BITTIMING and CAN_RX_OFFLOAD. And then only sort by
> alphabetical order within each group.

I was thinking to order by CONFIG symbol and put the objects without an
additional symbol first

> By sorting the list, do literally mean to sort each line like this:
>=20
> obj-$(CONFIG_CAN_DEV) +=3D can-dev.o
> can-dev-$(CONFIG_CAN_CALC_BITTIMING) +=3D calc_bittiming.o
> can-dev-$(CONFIG_CAN_DEV) +=3D skb.o
> can-dev-$(CONFIG_CAN_NETLINK) +=3D bittiming.o
> can-dev-$(CONFIG_CAN_NETLINK) +=3D dev.o
> can-dev-$(CONFIG_CAN_NETLINK) +=3D length.o
> can-dev-$(CONFIG_CAN_NETLINK) +=3D netlink.o
> can-dev-$(CONFIG_CAN_RX_OFFLOAD) +=3D rx-offload.o

=2E..which results in:

obj-$(CONFIG_CAN_DEV) +=3D can-dev.o

can-dev-y +=3D skb.o

can-dev-$(CONFIG_CAN_CALC_BITTIMING) +=3D calc_bittiming.o
can-dev-$(CONFIG_CAN_NETLINK) +=3D bittiming.o
can-dev-$(CONFIG_CAN_NETLINK) +=3D dev.o
can-dev-$(CONFIG_CAN_NETLINK) +=3D length.o
can-dev-$(CONFIG_CAN_NETLINK) +=3D netlink.o
can-dev-$(CONFIG_CAN_RX_OFFLOAD) +=3D rx-offload.o

> or do you mean to sort by object name (ignoring the config symbol) like t=
hat:
>=20
> obj-$(CONFIG_CAN_DEV) +=3D can-dev.o
> can-dev-$(CONFIG_CAN_NETLINK) +=3D bittiming.o
> can-dev-$(CONFIG_CAN_CALC_BITTIMING) +=3D calc_bittiming.o
> can-dev-$(CONFIG_CAN_NETLINK) +=3D dev.o
> can-dev-$(CONFIG_CAN_NETLINK) +=3D length.o
> can-dev-$(CONFIG_CAN_NETLINK) +=3D netlink.o
> can-dev-$(CONFIG_CAN_RX_OFFLOAD) +=3D rx-offload.o
> can-dev-$(CONFIG_CAN_DEV) +=3D skb.o
>=20
> ?
>=20
> (I honestly do not care so much how we sort the lines. My logic of
> grouping first by CONFIG symbols seems more natural, but I am fine to
> go with any other suggestion).

I think this makes it clear where new files should be added.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--ora2vppsbqlisv3t
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKbUwEACgkQrX5LkNig
01144Af+LO3PBMYwZY4eASmWmqhkOrErkkDcY+BhhTS5F2Yi4HlyoMUJ7d8t4pOR
WPN1TjHExVFZCjN6bRLmuEqntMtS+2b2v91f4vtoncPI6/ygQPEXIqVSGBcQGtuj
zKryoPlqDJpF83LqiS9cE/RH+YjL3wkZB+Qvmsm1EAuInIiwHYphiOvILdeE6frh
lDv3UL5+zfZ4fSY1TNio9yE6Vs1DoPFEXsg7V1xtaoI1Ou+nr3oFXQlkxHwS5c6c
Vhicx/dUNpllJj558HPvLhxp24+/XCA+7xpUM/liaJgTwqs0Au41fxwx35iQZ2Bs
FbpwIdN1vnTOY5htRYQnot3dJtQ72Q==
=eyNK
-----END PGP SIGNATURE-----

--ora2vppsbqlisv3t--
