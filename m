Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA5C67B11B
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 12:24:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235161AbjAYLY1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 06:24:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235069AbjAYLYY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 06:24:24 -0500
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F6145FFE;
        Wed, 25 Jan 2023 03:24:22 -0800 (PST)
Received: from wsk (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 5CFF784EEF;
        Wed, 25 Jan 2023 12:24:19 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1674645860;
        bh=yy5SYnsI9GsvQrKJXSfhwpWWOuEYBonDkwjXV9xnDRs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=xS5KFI5dvMoNIsVHfgTNjdFrBA0GvOZo0WSswAHyS56/M2y6OaPlr7FWj4/7G5p+4
         XEOISKdX1nQpjui/+0F5FirSPnXdkfWZ4lLKSlbp1/lBqxh86Dh7Hu2bLl1KEQJU1M
         qiVY9gIaQrUTl4eCBdFA3rg5gju5zU3LDv+VjgtuIIaYgHshw9VZ4NTj7BxDMU/bfO
         4iWadnn5A5tX3AOOHqEIgVsFSRdQ0R5M/YGxZKk1B9Jh2ANKNaYeovdL5lVAX/NXJe
         C4RnHVPP+C/3VJoZPD+pdDgVvx+5J3Lp9iZjH+5Tf9SAWir1tZvwgiwD366rY4xXnq
         CDwsP9LZ3utdQ==
Date:   Wed, 25 Jan 2023 12:24:12 +0100
From:   Lukasz Majewski <lukma@denx.de>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/3] dsa: marvell: Provide per device information
 about max frame size
Message-ID: <20230125122412.4eb1746d@wsk>
In-Reply-To: <20230116105148.230ef4ae@wsk>
References: <20230106101651.1137755-1-lukma@denx.de>
        <Y8Fno+svcnNY4h/8@shell.armlinux.org.uk>
        <20230116105148.230ef4ae@wsk>
Organization: denx.de
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Gtz=Vu705QfYN/SEYXTOeWF";
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

--Sig_/Gtz=Vu705QfYN/SEYXTOeWF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi,

> Hi Russell,
>=20
> > On Fri, Jan 06, 2023 at 11:16:49AM +0100, Lukasz Majewski wrote: =20
> > > Different Marvell DSA switches support different size of max frame
> > > bytes to be sent. This value corresponds to the memory allocated
> > > in switch to store single frame.
> > >=20
> > > For example mv88e6185 supports max 1632 bytes, which is now
> > > in-driver standard value. On the other hand - mv88e6250 supports
> > > 2048 bytes. To be more interresting - devices supporting jumbo
> > > frames - use yet another value (10240 bytes)
> > >=20
> > > As this value is internal and may be different for each switch IC,
> > > new entry in struct mv88e6xxx_info has been added to store it.
> > >=20
> > > This commit doesn't change the code functionality - it just
> > > provides the max frame size value explicitly - up till now it has
> > > been assigned depending on the callback provided by the IC driver
> > > (e.g. .set_max_frame_size, .port_set_jumbo_size).   =20
> >=20
> > I don't think this patch is correct.
> >=20
> > One of the things that mv88e6xxx_setup_port() does when initialising
> > each port is:
> >=20
> >         if (chip->info->ops->port_set_jumbo_size) {
> >                 err =3D chip->info->ops->port_set_jumbo_size(chip,
> > port, 10218); if (err)
> >                         return err;
> >         }
> >=20
> > There is one implementation of this, which is
> > mv88e6165_port_set_jumbo_size() and that has the effect of setting
> > port register 8 to the largest size. So any chip that supports the
> > port_set_jumbo_size() method will be programmed on initialisation to
> > support this larger size.
> >=20
> > However, you seem to be listing e.g. the 88e6190 (if I'm
> > interpreting the horrid mv88e6xxx_table changes correctly) =20
>=20
> Those changes were requested by the community. Previous versions of
> this patch were just changing things to allow correct operation of the
> switch ICs on which I do work (i.e. 88e6020 and 88e6071).
>=20
> And yes, for 88e6190 the max_frame_size =3D 10240, but (by mistake) the
> same value was not updated for 88e6190X.
>=20
> The question is - how shall I proceed?=20
>=20
> After the discussion about this code - it looks like approach from v3
> [1] seems to be the most non-intrusive for other ICs.
>=20

I would appreciate _any_ hints on how shall I proceed to prepare those
patches, so the community will accept them...

Thanks in advance.

> > as having a maximum
> > frame size of 1522, but it implements this method, supports 10240,
> > and thus is programmed to support frames of that size rather than
> > 1522.=20
>=20
> Links:
>=20
> [1] - https://lore.kernel.org/netdev/Y7M+mWMU+DJPYubp@lunn.ch/T/
>=20
>=20
> Best regards,
>=20
> Lukasz Majewski
>=20
> --
>=20
> DENX Software Engineering GmbH,      Managing Director: Erika Unter
> HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
> Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email:
> lukma@denx.de




Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/Gtz=Vu705QfYN/SEYXTOeWF
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmPREVwACgkQAR8vZIA0
zr2gHggAyDWkVBLirTLFTv/oZIL7rmicP5nurIl7mcaAzpJBd8kfnwDtw4mWjOdD
OIeAr9EP/cfQyU3/52HSlNRrJCqD3boAHDoj/wpPXg7zyJ3iq3p83ICP+LIBzyfm
REi/E0Vt4/KTsrCWvVcswF5QE7SG2DfSUYEywePN5i4HXXKsUWpbm1SwfSCP9OiJ
eokzNIlvEpCV9mUEjQVBXPWh+NxLOlEsHFkoMQtUtKh5jOTYd6EXBTVpnJwLPyJ+
L2mOk0svHXhMXLcQNxzDlTUbjVLK+8HfZQ0ttbFWZb8W/wIvpyVelQwBjtao4Vp7
dRN6OuQkY6zSXnw3AKetHbcFaAZlmA==
=FdgD
-----END PGP SIGNATURE-----

--Sig_/Gtz=Vu705QfYN/SEYXTOeWF--
