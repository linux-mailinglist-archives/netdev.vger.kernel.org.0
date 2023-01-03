Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAB0665BC6E
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 09:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237103AbjACIrD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 03:47:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237066AbjACIqq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 03:46:46 -0500
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BF13FE5;
        Tue,  3 Jan 2023 00:46:44 -0800 (PST)
Received: from wsk (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 0F6BB81120;
        Tue,  3 Jan 2023 09:46:41 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1672735601;
        bh=FZRNOfo8qDLbEayCnZRVV6yMdXNFXN7AYV0C2JCc0Wc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rpYxe7vR1jl7FCp+KxCNipZzIJGDfQQUS7KvJxwrwDizpxDazeYCpt5BQEDN81wLu
         6Nl2BQSyut+olElmuuE0xw7j3KlW6wZcfiyZtjtTTPkrqSVGXiStvIqt23P1daR8MT
         ws5Yn1VFJmOo8GBpptPq3MiPc5NEIUucKowBQ/7njXm0eaM3KPXDaihSNxDoFyVA5W
         0IdMzlhDJksbo3Ql3hLVuLNOEyACq7rY5pJNxPQjicpC5CAjZ6q2kccazFQWL3kqeM
         7c1A7AOpYRSNQwC2DkbaTKGKHb1mZ/EkWqcPV9pBppES0QSVkkDmmTGtfbkirpdIrP
         xwE3BhWid8SUg==
Date:   Tue, 3 Jan 2023 09:46:33 +0100
From:   Lukasz Majewski <lukma@denx.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Subject: Re: [PATCH v3 2/3] net: dsa: mv88e6xxx: add support for MV88E6020
 switch
Message-ID: <20230103094633.40328198@wsk>
In-Reply-To: <Y7M3xg0mJhhr8Xg8@lunn.ch>
References: <20230102150209.985419-1-lukma@denx.de>
        <20230102150209.985419-2-lukma@denx.de>
        <Y7M3xg0mJhhr8Xg8@lunn.ch>
Organization: denx.de
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/v=MSexCL7TfeyWV_xIgfSGY";
 protocol="application/pgp-signature"; micalg=pgp-sha512
X-Virus-Scanned: clamav-milter 0.103.6 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/v=MSexCL7TfeyWV_xIgfSGY
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

> On Mon, Jan 02, 2023 at 04:02:08PM +0100, Lukasz Majewski wrote:
> > From: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
> >=20
> > A mv88e6250 family (i.e. LinkStreet) switch with 2 PHY and RMII
> > ports and no PTP support. =20
>=20
> >  static const struct mv88e6xxx_info mv88e6xxx_table[] =3D {
> > +	[MV88E6020] =3D {
> > +		.prod_num =3D MV88E6XXX_PORT_SWITCH_ID_PROD_6020,
> > +		.family =3D MV88E6XXX_FAMILY_6250,
> > +		.name =3D "Marvell 88E6020",
> > +		.num_databases =3D 64,
> > +		.num_ports =3D 7,
> > +		.num_internal_phys =3D 5, =20
>=20
> You say in the commit message there are two PHYs, yet you have 5 here?
>=20

It looks like mine copy-paste error.

In the documentation there is stated that the 88E6020 device contains
two 10BASE-T/100BASE-TX transceivers (PHYs) and four independent Fast
Ethernet MACs (so it is a 2+2 device).

The 88E6071 is 5+2 device, so I'm going to correct this value to 2.
Also num_ports needs to be updated to 4.

>     Andrew


Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/v=MSexCL7TfeyWV_xIgfSGY
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmOz62kACgkQAR8vZIA0
zr1RPgf9HpBDrIYVK7/JLCxI0tGq8u9eyZLT12kn2zBzhdNqoobcjLrlphDsR+Ur
3bC/Xf+6aGh0Cx9TQtEcm6wWcSCHdxMOMG4wt6vEUMNbBtF76MdOPKzbx8cYz5tv
Za2PBY2Znzt/uGbO3Xafx8zyVIEC3hhQSWFOVzIKtL2eGv5CB6FBVIimtBnzEY1c
dYRbvd72w1uE34PcxaI9ARTngKaUiKG1Dr0YjqmOXUTJUyTRaqZOwsjJQitRlaHf
YJJl+f35tjoVwflShoKF5Aw0/nPNdugddKqUbF5YIBSG7ct7AaEZFJb43qAivZQL
j4BUTTlJARFxEj4e2tLmGTcL9yyqjg==
=9+DG
-----END PGP SIGNATURE-----

--Sig_/v=MSexCL7TfeyWV_xIgfSGY--
