Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5129B431A0D
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 14:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbhJRMxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 08:53:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231617AbhJRMxC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 08:53:02 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9A21C061714
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 05:50:50 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mcS6B-0003Xo-IR; Mon, 18 Oct 2021 14:50:39 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-c2ef-28ab-e0cd-e8fd.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:c2ef:28ab:e0cd:e8fd])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 5DC0C696774;
        Mon, 18 Oct 2021 12:50:36 +0000 (UTC)
Date:   Mon, 18 Oct 2021 14:50:35 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Ulrich Hecht <uli+renesas@fpond.eu>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, linux-can@vger.kernel.org,
        "Lad, Prabhakar" <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Wolfram Sang <wsa@kernel.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Jakub Kicinski <kuba@kernel.org>, mailhol.vincent@wanadoo.fr,
        socketcan@hartkopp.net
Subject: Re: [PATCH 1/3] can: rcar_canfd: Add support for r8a779a0 SoC
Message-ID: <20211018125035.mquerdthczmnazmg@pengutronix.de>
References: <20210924153113.10046-1-uli+renesas@fpond.eu>
 <20210924153113.10046-2-uli+renesas@fpond.eu>
 <CAMuHMdXk2mZntTBe3skSVkcNVjC-PzMwEv_MbH85Mvn1ZkFpHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="4ymvzzrx4bpdikfp"
Content-Disposition: inline
In-Reply-To: <CAMuHMdXk2mZntTBe3skSVkcNVjC-PzMwEv_MbH85Mvn1ZkFpHw@mail.gmail.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--4ymvzzrx4bpdikfp
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 05.10.2021 15:06:22, Geert Uytterhoeven wrote:
> Hi Uli,
>=20
> On Fri, Sep 24, 2021 at 5:38 PM Ulrich Hecht <uli+renesas@fpond.eu> wrote:
> > Adds support for the CANFD IP variant in the V3U SoC.
> >
> > Differences to controllers in other SoCs are limited to an increase in
> > the number of channels from two to eight, an absence of dedicated
> > registers for "classic" CAN mode, and a number of differences in magic
> > numbers (register offsets and layouts).
> >
> > Inspired by BSP patch by Kazuya Mizuguchi.
> >
> > Signed-off-by: Ulrich Hecht <uli+renesas@fpond.eu>
>=20
> Thanks for your patch!
>=20
> > --- a/drivers/net/can/rcar/rcar_canfd.c
> > +++ b/drivers/net/can/rcar/rcar_canfd.c
[...]
> >  /* RSCFDnCFDGERFL / RSCFDnGERFL */
> > +#define RCANFD_GERFL_EEF0_7            GENMASK(23, 16)
> >  #define RCANFD_GERFL_EEF1              BIT(17)
> >  #define RCANFD_GERFL_EEF0              BIT(16)
> >  #define RCANFD_GERFL_CMPOF             BIT(3)  /* CAN FD only */
> > @@ -86,20 +90,24 @@ enum rcanfd_chip_id {
> >  #define RCANFD_GERFL_MES               BIT(1)
> >  #define RCANFD_GERFL_DEF               BIT(0)
> >
> > -#define RCANFD_GERFL_ERR(gpriv, x)     ((x) & (RCANFD_GERFL_EEF1 |\
> > -                                       RCANFD_GERFL_EEF0 | RCANFD_GERF=
L_MES |\
> > -                                       (gpriv->fdmode ?\
> > -                                        RCANFD_GERFL_CMPOF : 0)))
> > +#define RCANFD_GERFL_ERR(gpriv, x)     ((x) & ((IS_V3U ? RCANFD_GERFL_=
EEF0_7 : \
> > +                                       (RCANFD_GERFL_EEF0 | RCANFD_GER=
FL_EEF1)) | \
> > +                                       RCANFD_GERFL_MES | ((gpriv)->fd=
mode ? \
> > +                                       RCANFD_GERFL_CMPOF : 0)))
>=20
> I'm wondering if some of these IS_V3U checks can be avoided, improving
> legibility, by storing a feature struct instead of a chip_id in
> rcar_canfd_of_table[].data?

+1

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--4ymvzzrx4bpdikfp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmFtbZkACgkQqclaivrt
76kNXgf9FSEXYx2nx0/xzXkBNlXSLOsBX+9UdzELtvnrHOp0kp/Px5s/xhOCxMeD
Nehm60XiZSQOlLkJcsM+HSxOjIHTruAwYjBwQtSFEtGj0exwkI91pfzHryqrUpNk
+udG6cOClZbJ57AGO7YI2AZeEzmmmFY6MyJ3xw4TOiCJd+7UcrzHpOLcLZsqqHDw
HwR5Xjt1x331LLNp+pZYLlZ1dKpCa/Lq0qk3Y1zQeT3g3N7xqci7viTC4gJmzuxx
KwQfGxsGFbE/sO3kl6R0SMw47ULc6LvgOeXVt0O4A3hKPqqAKNua/6t8KF4SkpTw
zHRvey2I/hz/yKPWVtsOazJ+siPNOg==
=W1uJ
-----END PGP SIGNATURE-----

--4ymvzzrx4bpdikfp--
