Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CACE9528AA0
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 18:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343727AbiEPQfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 12:35:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343723AbiEPQe7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 12:34:59 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 452FB3B3CD
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 09:34:58 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nqdgF-000191-Fx; Mon, 16 May 2022 18:34:47 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id E6C9E7F95E;
        Mon, 16 May 2022 16:34:45 +0000 (UTC)
Date:   Mon, 16 May 2022 18:34:45 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Rob Herring <robh@kernel.org>
Cc:     Matej Vasilevski <matej.vasilevski@seznam.cz>,
        linux-can@vger.kernel.org, pisa@cmp.felk.cvut.cz,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        ondrej.ille@gmail.com, martin.jerabek01@gmail.com
Subject: Re: [RFC PATCH 2/3] dt-bindings: can: ctucanfd: add properties for
 HW timestamping
Message-ID: <20220516163445.qxz3xlohuquqwbwl@pengutronix.de>
References: <20220512232706.24575-1-matej.vasilevski@seznam.cz>
 <20220512232706.24575-3-matej.vasilevski@seznam.cz>
 <20220516160250.GA2724701-robh@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="lqr77j4ug2nnwbfa"
Content-Disposition: inline
In-Reply-To: <20220516160250.GA2724701-robh@kernel.org>
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


--lqr77j4ug2nnwbfa
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 16.05.2022 11:02:50, Rob Herring wrote:
> On Fri, May 13, 2022 at 01:27:06AM +0200, Matej Vasilevski wrote:
> > Extend dt-bindings for CTU CAN-FD IP core with necessary properties
> > to enable HW timestamping for platform devices. Since the timestamping
> > counter is provided by the system integrator usign those IP cores in
> > their FPGA design, we need to have the properties specified in device t=
ree.
> >=20
> > Signed-off-by: Matej Vasilevski <matej.vasilevski@seznam.cz>
> > ---
> >  .../bindings/net/can/ctu,ctucanfd.yaml        | 34 +++++++++++++++++--
> >  1 file changed, 31 insertions(+), 3 deletions(-)
>=20
> What's the base for this patch? Doesn't apply for me.
>=20
> >=20
> > diff --git a/Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yam=
l b/Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml
> > index fb34d971dcb3..c3693dadbcd8 100644
> > --- a/Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml
> > +++ b/Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml
> > @@ -41,9 +41,35 @@ properties:
> > =20
> >    clocks:
> >      description: |
> > -      phandle of reference clock (100 MHz is appropriate
> > -      for FPGA implementation on Zynq-7000 system).
> > +      Phandle of reference clock (100 MHz is appropriate for FPGA
> > +      implementation on Zynq-7000 system). If you wish to use timestam=
ps
> > +      from the core, add a second phandle with the clock used for time=
stamping
> > +      (can be the same as the first clock).
> > +    maxItems: 2
>=20
> With more than 1, you have to define what each entry is. IOW, use=20
> 'items'.
>=20
> > +
> > +  clock-names:
> > +    description: |
> > +      Specify clock names for the "clocks" property. The first clock n=
ame
> > +      doesn't matter, the second has to be "ts_clk". Timestamping freq=
uency
> > +      is then obtained from the "ts_clk" clock. This takes precedence =
over
> > +      the ts-frequency property.
> > +      You can omit this property if you don't need timestamps.
> > +    maxItems: 2
>=20
> You must define what the names are as a schema.
>=20
> > +
> > +  ts-used-bits:
> > +    description: width of the timestamping counter
> > +    maxItems: 1
> > +    items:
>=20
> Not an array, so you don't need maxItems nor items.
>=20
> > +      minimum: 8
> > +      maximum: 64
> > +
> > +  ts-frequency:
>=20
> Use a standard unit suffix.
>=20
> > +    description: |
> > +      Frequency of the timestamping counter. Set this if you want to g=
et
> > +      timestamps, but you didn't set the timestamping clock in clocks =
property.
> >      maxItems: 1
> > +    items:
>=20
> Not an array.
>=20
>=20
> Is timestamping a common feature for CAN or is this specific to this=20
> controller? In the latter case, you need vendor prefixes on these=20
> properties. In the former case, you need to define them in a common=20
> schema.

This property describes the usable with of the free running timer and
the timestamps generated by it. This is similar to the free running
timer and time stamps as found on PTP capable Ethernet NICs. But the
ctucanfd comes in a hardware description language that can be
parametrized and synthesized into your own FPGA.

To answer your question, timestamping is common in newer CAN cores, but
the width of the timestamping register is usually fixed and thus hard
coded in the driver.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--lqr77j4ug2nnwbfa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKCfSMACgkQrX5LkNig
011vewgAuA1Sw18Cas3A6qb/P1pIqTIiUQirJ5dTpO30ukpTNRklS+3Ea6rZBjlX
43x/xFB7xsE6ib+GBvP/V8N6RNpOGW7pJb0gHfS/XF9NR1hZZuHxqP5twhOJcQnv
QWNZ43/nZaCaLZtr2XXcV7JZ1Ojh559z8m+WaYOymAiiYtWWKz4CuChEU+VndYYl
7pLCwypfb2fxJ++DTsYT45/elS+szphh1He1O8zEa8SwVE5aVwXcy8Rx2bCJKwNc
smRBqkQ82SlXnKgAEoNOFQx+Yz4JblsAk++wE9mHKDKBEYk2+Mo2ChtlEIPP4jPQ
sLhx4+omh/YCIwzluS+QOS49Y1A7Qg==
=qzlR
-----END PGP SIGNATURE-----

--lqr77j4ug2nnwbfa--
