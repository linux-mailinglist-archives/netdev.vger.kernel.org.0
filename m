Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB0C3F1716
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 12:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238267AbhHSKIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 06:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238137AbhHSKIY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 06:08:24 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA0B4C061575
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 03:07:47 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mGexb-00043B-U9; Thu, 19 Aug 2021 12:07:43 +0200
Received: from pengutronix.de (unknown [IPv6:2a02:810a:8940:aa0:5b60:c5f4:67f4:2e1e])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 1CC0766A599;
        Thu, 19 Aug 2021 10:07:42 +0000 (UTC)
Date:   Thu, 19 Aug 2021 12:07:40 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     linux-can <linux-can@vger.kernel.org>,
        Stefan =?utf-8?B?TcOkdGpl?= <Stefan.Maetje@esd.eu>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 1/7] can: netlink: allow user to turn off unsupported
 features
Message-ID: <20210819100740.l4ci5taj6m27x2am@pengutronix.de>
References: <20210815033248.98111-1-mailhol.vincent@wanadoo.fr>
 <20210815033248.98111-2-mailhol.vincent@wanadoo.fr>
 <20210819074514.jkg7fwztzpxecrwb@pengutronix.de>
 <CAMZ6RqL0uT7tNNxRjAYaUNrnsSV6smMQvowttLaqjUrOZ5V1Fg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="lyy5ts6arsg6xxal"
Content-Disposition: inline
In-Reply-To: <CAMZ6RqL0uT7tNNxRjAYaUNrnsSV6smMQvowttLaqjUrOZ5V1Fg@mail.gmail.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--lyy5ts6arsg6xxal
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 19.08.2021 18:24:27, Vincent MAILHOL wrote:
> On Thu. 19 Aug 2021 at 16:45, Marc Kleine-Budde <mkl@pengutronix.de> wrot=
e:
> > On 15.08.2021 12:32:42, Vincent Mailhol wrote:
> > > The sanity checks on the control modes will reject any request related
> > > to an unsupported features, even turning it off.
> > >
> > > Example on an interface which does not support CAN-FD:
> > >
> > > $ ip link set can0 type can bitrate 500000 fd off
> > > RTNETLINK answers: Operation not supported
> > >
> > > This patch lets such command go through (but requests to turn on an
> > > unsupported feature are, of course, still denied).
> > >
> > > Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> >
> > I'm planing to send a pull request to net-next today. I want to do some
> > more tests with this series
>=20
> Ack, I am also preparing a new version. But first, I am just
> waiting for your reply on the tdc-mode {auto, manual, off}. :)

I want to do some proper testing, if it's now working as I'm expecting,
before continuing the discussion. :D

> > but this patch is more or less unrelated,
> > so I can take it in this PR, should I?
>=20
> FYI, the reason to add it to the series is that when setting TDC to
> off, the ip tool sets both CAN_CTRLMODE_TDC_AUTO and
> CAN_CTRLMODE_TDC_MANUAL to zero (which the corresponding bits in
> can_ctrlmode::mask set to 1).  Without this patch, netlink would
> return -ENOTSUPP if the driver only supported one of
> CAN_CTRLMODE_TDC_{AUTO,MANUAL}.

Oh, I see.

> Regardless, this patch makes sense as a standalone, I am fine if
> you include it in your PR.

Why not, reduces the patch amount on your side :)

> Also, if you want, you can include the latest patch of the series as well:
> https://lore.kernel.org/linux-can/20210815033248.98111-8-mailhol.vincent@=
wanadoo.fr/
>=20
> It's a comment fix, it should be pretty harmless.

Ok, makes sense.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--lyy5ts6arsg6xxal
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmEeLWoACgkQqclaivrt
76kV/Af/aQMfgwa5V4mMqsDeBdm/vXj2gp5/xZI0co2GN7kjwo0sXws9VF7Dsg0Z
LIzH79naGLMLfs/3zx1xOpqLCmGNhu9SV+rneZZZtJQ32f18UVD0u34Zg3+SJ3QN
DmPO5TKQFS9c+bDXbBxHGxza2eZTP1L1aGqFU4f4GzGB0HMwD84DV7xqmzmzWA3o
IkqKqYdTcV0zf6H+IqvtXY1TNKHqTbxPajUn4DwQs2XXZzCyw7ynoR3I+BSZmDNW
KEZ5uUBJ4NIYPC5HRfGsftyBfEKARgbzc54Vs0O+b9PPlCR3ucVs15kB4tZbstPn
GlgNuVG9//8vf36wGB1Y2HBiIUCD8g==
=KMQY
-----END PGP SIGNATURE-----

--lyy5ts6arsg6xxal--
