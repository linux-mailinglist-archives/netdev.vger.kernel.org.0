Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14E0253D714
	for <lists+netdev@lfdr.de>; Sat,  4 Jun 2022 15:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233518AbiFDNw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jun 2022 09:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236484AbiFDNvc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jun 2022 09:51:32 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 383A23139A
        for <netdev@vger.kernel.org>; Sat,  4 Jun 2022 06:51:31 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nxUBb-0005eU-0c; Sat, 04 Jun 2022 15:51:27 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 175828C384;
        Sat,  4 Jun 2022 13:51:26 +0000 (UTC)
Date:   Sat, 4 Jun 2022 15:51:25 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Staudt <max@enpas.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev@vger.kernel.org
Subject: Re: [PATCH v4 3/7] can: bittiming: move bittiming calculation
 functions to calc_bittiming.c
Message-ID: <20220604135125.gdaldwbde5segvxo@pengutronix.de>
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220603102848.17907-1-mailhol.vincent@wanadoo.fr>
 <20220603102848.17907-4-mailhol.vincent@wanadoo.fr>
 <20220604112538.p4hlzgqnodyvftsj@pengutronix.de>
 <CAMZ6RqLg_Enyn1h+sn=o8rc8kkR6r=YaygLy40G9D4=Ug_KxOg@mail.gmail.com>
 <20220604124139.pg2h33zanyqs54q5@pengutronix.de>
 <CAMZ6RqJqSG16fdRE5_uiOmqsDboBgQCanvVNGaG5ZUDwpVoYvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="hu7x2i5eoqf2vu6l"
Content-Disposition: inline
In-Reply-To: <CAMZ6RqJqSG16fdRE5_uiOmqsDboBgQCanvVNGaG5ZUDwpVoYvA@mail.gmail.com>
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


--hu7x2i5eoqf2vu6l
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 04.06.2022 21:56:23, Vincent MAILHOL wrote:
> > I was thinking to order by CONFIG symbol and put the objects without an
> > additional symbol first
> >
> > > By sorting the list, do literally mean to sort each line like this:
> > >
> > > obj-$(CONFIG_CAN_DEV) +=3D can-dev.o
> > > can-dev-$(CONFIG_CAN_CALC_BITTIMING) +=3D calc_bittiming.o
> > > can-dev-$(CONFIG_CAN_DEV) +=3D skb.o
> > > can-dev-$(CONFIG_CAN_NETLINK) +=3D bittiming.o
> > > can-dev-$(CONFIG_CAN_NETLINK) +=3D dev.o
> > > can-dev-$(CONFIG_CAN_NETLINK) +=3D length.o
> > > can-dev-$(CONFIG_CAN_NETLINK) +=3D netlink.o
> > > can-dev-$(CONFIG_CAN_RX_OFFLOAD) +=3D rx-offload.o
> >
> > ...which results in:
> >
> > obj-$(CONFIG_CAN_DEV) +=3D can-dev.o
> >
> > can-dev-y +=3D skb.o
>=20
> I see. But this contradicts the idea to do
> | obj-y +=3D can-dev
> as suggested in:
> https://lore.kernel.org/linux-can/20220604112707.z4zjdjydqy5rkyfe@pengutr=
onix.de/

Doh! That mail was totally wrong - I've send an updated version.

> So, we have to choose between:
> | obj-$(CONFIG_CAN_DEV) +=3D can-dev.o
> |
> | can-dev-y +=3D skb.o
> |
> | can-dev-$(CONFIG_CAN_CALC_BITTIMING) +=3D calc_bittiming.o
> | (...)

+1

> or:
>=20
> | obj-y +=3D can-dev.o
> |
> | can-dev-$(CONFIG_CAN_CALC_BITTIMING) +=3D calc_bittiming.o
> | can-dev-$(CONFIG_CAN_DEV) +=3D skb.o
> | (...)
>=20
> I have a slight preference for the second, but again, wouldn't mind to
> select the first one.

I think if can-dev is added to "obj-y" it will be always complied into
the kernel. It will not be a module, if CONFIG_CAN_DEV configured as a
module (which results in $(CONFIG_CAN_DEV) evaluate to "m").

Sorry for the confusion!

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--hu7x2i5eoqf2vu6l
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKbY1oACgkQrX5LkNig
0123zwf/YDkOnyfVZEWZ6KpNrYxRG2BTMIJuZln8TFlSPSSRDuY5KlbY3I6N+zDd
Ccg/e1lih5sQIuyPu9ijctgEiCatW1cVeDBtk5iDxs3fI5QRRP0XOjfol0247v87
evOjfc8AZMdISZ2oK3+OHyIbLknH13iiaWAQM4UZ+n8xQg3wS2OeueUEKcR/lWMb
48U5iCUjN8I2nKeDw6PsFAdn8yRshJr2Kltg6rWOqFT7NB4uSXBiLnYCaLKeywlF
msTvGA6myPLUvx2HgTclcTFcKmEvkPrWg/y03UqWKEq3h9uEbIMebkN6p5KCBbq7
fbDWie7VnC1Z0sEz/fdrqZ+MEx2PWA==
=Qbeq
-----END PGP SIGNATURE-----

--hu7x2i5eoqf2vu6l--
