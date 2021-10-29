Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97DC943FB4E
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 13:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231624AbhJ2LXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 07:23:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231670AbhJ2LXX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 07:23:23 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B983CC061745
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 04:20:54 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mgPwJ-0003Wt-FC; Fri, 29 Oct 2021 13:20:51 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-e533-710f-3fbf-10c2.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:e533:710f:3fbf:10c2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id A68C86A0944;
        Fri, 29 Oct 2021 11:20:50 +0000 (UTC)
Date:   Fri, 29 Oct 2021 13:20:49 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     linux-can <linux-can@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] can: etas_es58x: es58x_rx_err_msg: fix memory leak in
 error path
Message-ID: <20211029112049.j3wbh2aka4qfeq5l@pengutronix.de>
References: <20211026180740.1953265-1-mailhol.vincent@wanadoo.fr>
 <20211027073905.aff3mmonp7a3itrn@pengutronix.de>
 <CAMZ6RqKC2SXsDE2pvNw0LT9TsOHR9W-evTqzv35W+-Dtd-Peow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="3ontns5duwddut54"
Content-Disposition: inline
In-Reply-To: <CAMZ6RqKC2SXsDE2pvNw0LT9TsOHR9W-evTqzv35W+-Dtd-Peow@mail.gmail.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--3ontns5duwddut54
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 27.10.2021 17:48:21, Vincent MAILHOL wrote:
> On Wed. 27 Oct 2021 at 16:39, Marc Kleine-Budde <mkl@pengutronix.de> wrot=
e:
> > On 27.10.2021 03:07:40, Vincent Mailhol wrote:
> > > In es58x_rx_err_msg(), if can->do_set_mode() fails, the function
> > > directly returns without calling netif_rx(skb). This means that the
> > > skb previously allocated by alloc_can_err_skb() is not freed. In other
> > > terms, this is a memory leak.
> > >
> > > This patch simply removes the return statement in the error branch and
> > > let the function continue.
> > >
> > > * Appendix: how the issue was found *
> >
> > Thanks for the explanation, but I think I'll remove the appendix while
> > applying.
>=20
> The commit will have a link to this thread so if you don't mind,
> I suggest to replace the full appendix with:
>=20
> Issue was found with GCC -fanalyzer, please follow the link below
> for details.

Makes sense, good idea.

> You can of course do the same for the m_can patch.

ACK

Added to linux-can/testing, will send it out once v5.15 is out.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--3ontns5duwddut54
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmF72Q8ACgkQqclaivrt
76lmjggAgVEFYhCSrfVs/XJ4BtVqBfoSfVDyDSH72wrrpPjSJmnhF3lpmEYSbtGV
UurPx4ZtIQcwAxEYMshYoN4HLLuM7j3SDJjWrNjKJuaLORG4SiMakohlX4Begpw2
V4p9xBKXxfYxBL0v/9r0+3bz+74bUuBEP42BldIf9h4iGrIGoQO4gPgKOhs5kBqL
6JIInyktdt1cCW2P/Tui2w5axJ557RO6ObEMquXZA41XzrvS8FZxJqE60ic7WRo/
2K+VDhJEO3kvOjuRlBEXM+128pEnRBOmWrf7vH9rFx5tgHxOteXU8pix0nkQM+v9
9IDmxxH1fTEt6+h4pPaBandCRH/wVQ==
=njFK
-----END PGP SIGNATURE-----

--3ontns5duwddut54--
