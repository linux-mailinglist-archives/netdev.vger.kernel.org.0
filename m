Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E934C624727
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 17:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232041AbiKJQh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 11:37:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231920AbiKJQhj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 11:37:39 -0500
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA3CA3FBAB
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 08:37:37 -0800 (PST)
Received: from wsk (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 6F20284D17;
        Thu, 10 Nov 2022 17:37:35 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1668098255;
        bh=AXsRkUm5VWNnXJa+MCuBauMJuepoAZHQRfBQtcjHePQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JoFcCUDSAuVFkIxdxCKbla8psj25EmGTRbycNq1FELBElz92SJ67VHj6d2CXMixeB
         m9nnE3uH5XzbloXRA21U5HinVDjWpB0CfFzIQUaui2+yjLYj+mKeHi+0T3om5LamG7
         adldZCJeZhGoUBMUU+ccX//9yZ8NiX6jZ6K1rv28w+vNWbLZGSoer6l6mks2xgIxMS
         daBwEZWpBnxM9IbihUJy7GWYFkwdKFfu4ULe1Ww2XpZOTejUuooWRwjhvOIswYt5kx
         Z+o7/jObc1D8w3BoiGhzd7gN2NP6LysyMQ+NOXMws0brZqq1xfPCj7EiUoor1E100h
         wUk9Dh7wsP7Cw==
Date:   Thu, 10 Nov 2022 17:37:14 +0100
From:   Lukasz Majewski <lukma@denx.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Subject: Re: [PATCH 3/9] net: dsa: mv88e6xxx: implement get_phy_address
Message-ID: <20221110173714.6ea59de5@wsk>
In-Reply-To: <20221108091220.zpxsduscpvgr3zna@skbuf>
References: <20221108082330.2086671-1-lukma@denx.de>
        <20221108082330.2086671-4-lukma@denx.de>
        <20221108091220.zpxsduscpvgr3zna@skbuf>
Organization: denx.de
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/6FeOPE1LNM4fRFp8Uc_mcHx";
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

--Sig_/6FeOPE1LNM4fRFp8Uc_mcHx
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Vladimir,

> On Tue, Nov 08, 2022 at 09:23:24AM +0100, Lukasz Majewski wrote:
> > From: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
> >=20
> > Avoid the need to specify a PHY for each physical port in the
> > device tree when phy_base_addr is not 0 (6250 and 6341 families).
> >=20
> > This change should be backwards-compatible with existing device
> > trees, as it only adds sensible defaults where explicit definitions
> > were required before.
> >=20
> > Signed-off-by: Matthias Schiffer
> > <matthias.schiffer@ew.tq-group.com> =20
>=20
> Needs your Signed-off-by tag as well.

Ok.

>=20
> > --- =20
>=20
> Would it be possible to do like armada-3720-turris-mox.dts does, and
> put the phy-handle in the device tree, avoiding the need for so many
> PHY address translation quirks?

As far as I can tell - the mv88e6xxx driver
(./drivers/net/dsa/mv88e6xxx) now uses hardcoded values for each member
of mv88e6xxx_info struct.

Those values are "port_base_addr" and "phy_base_addr". Those values
could be read from DTS description as pasted below.

>=20
> If you're going to have U-Boot support for this switch as well, the
> phy-handle mechanism is the only thing that U-Boot supports, so device
> trees written in this way will work for both (and can be passed by
> U-Boot to Linux):
>=20
> 	switch1@11 {
> 		compatible =3D "marvell,mv88e6190";
> 		reg =3D <0x11>;
> 		dsa,member =3D <0 1>;
> 		interrupt-parent =3D <&moxtet>;
> 		interrupts =3D <MOXTET_IRQ_PERIDOT(1)>;
> 		status =3D "disabled";
>=20
> 		mdio {
> 			#address-cells =3D <1>;
> 			#size-cells =3D <0>;
>=20
> 			switch1phy1: switch1phy1@1 {
> 				reg =3D <0x1>;
> 			};
>=20
> 			switch1phy2: switch1phy2@2 {
> 				reg =3D <0x2>;
> 			};
>=20
> 			switch1phy3: switch1phy3@3 {
> 				reg =3D <0x3>;
> 			};
>=20
> 			switch1phy4: switch1phy4@4 {
> 				reg =3D <0x4>;
> 			};
>=20
> 			switch1phy5: switch1phy5@5 {
> 				reg =3D <0x5>;
> 			};
>=20
> 			switch1phy6: switch1phy6@6 {
> 				reg =3D <0x6>;
> 			};
>=20
> 			switch1phy7: switch1phy7@7 {
> 				reg =3D <0x7>;
> 			};
>=20
> 			switch1phy8: switch1phy8@8 {
> 				reg =3D <0x8>;
> 			};
> 		};
>=20
> 		ports {
> 			#address-cells =3D <1>;
> 			#size-cells =3D <0>;
>=20
> 			port@1 {
> 				reg =3D <0x1>;
> 				label =3D "lan9";
> 				phy-handle =3D <&switch1phy1>;
> 			};
>=20
> 			port@2 {
> 				reg =3D <0x2>;
> 				label =3D "lan10";
> 				phy-handle =3D <&switch1phy2>;
> 			};
>=20
> 			port@3 {
> 				reg =3D <0x3>;
> 				label =3D "lan11";
> 				phy-handle =3D <&switch1phy3>;
> 			};
>=20
> 			port@4 {
> 				reg =3D <0x4>;
> 				label =3D "lan12";
> 				phy-handle =3D <&switch1phy4>;
> 			};
>=20
> 			port@5 {
> 				reg =3D <0x5>;
> 				label =3D "lan13";
> 				phy-handle =3D <&switch1phy5>;
> 			};
>=20
> 			port@6 {
> 				reg =3D <0x6>;
> 				label =3D "lan14";
> 				phy-handle =3D <&switch1phy6>;
> 			};
>=20
> 			port@7 {
> 				reg =3D <0x7>;
> 				label =3D "lan15";
> 				phy-handle =3D <&switch1phy7>;
> 			};
>=20
> 			port@8 {
> 				reg =3D <0x8>;
> 				label =3D "lan16";
> 				phy-handle =3D <&switch1phy8>;
> 			};
>=20
> 			switch1port9: port@9 {
> 				reg =3D <0x9>;
> 				label =3D "dsa";
> 				phy-mode =3D "2500base-x";
> 				managed =3D "in-band-status";
> 				link =3D <&switch0port10>;
> 			};
>=20
> 			switch1port10: port@a {
> 				reg =3D <0xa>;
> 				label =3D "dsa";
> 				phy-mode =3D "2500base-x";
> 				managed =3D "in-band-status";
> 				link =3D <&switch2port9>;
> 				status =3D "disabled";
> 			};
>=20
> 			port-sfp@a {
> 				reg =3D <0xa>;
> 				label =3D "sfp";
> 				sfp =3D <&sfp>;
> 				phy-mode =3D "sgmii";
> 				managed =3D "in-band-status";
> 				status =3D "disabled";
> 			};
> 		};
> 	};

The u-boot mailine has basic support for mv88e6071 and mv88e6020 (and
also some 'extension' patches which are floating around [1]).

For the current code - I'm using:

 mdio {
        #address-cells =3D <1>;
        #size-cells =3D <0>;

        switch@0 {
            compatible =3D "marvell,mv88e6250";
            reg =3D <0x00>;

            interrupt-parent =3D <&gpio2>;
            interrupts =3D <20 IRQ_TYPE_LEVEL_LOW>;
            interrupt-controller;
            #interrupt-cells =3D <2>;

            ports {
                #address-cells =3D <1>;
                #size-cells =3D <0>;

                port@0 {
                    reg =3D <0>;
                    label =3D "lan1";
                };

                port@1 {
                    reg =3D <1>;
                    label =3D "lan2";
                };

                port@2 {
                    reg =3D <2>;
                    label =3D "lan3";
                };

                port@5 {
                    reg =3D <5>;
                    label =3D "cpu";
                    phy-mode =3D "rgmii-id";
                    ethernet =3D <&fec1>;

                    fixed-link {
                           speed =3D <100>;
                           full-duplex;
                    };
                };
	};


The only "hack" which I see from time to time is the replacement of
'switch@0' with 'switch@8' to take into account the R0_LED/ADDRES4
bootstrap pin value (to shift up ports addresses).


Links:

[1] - https://lists.denx.de/pipermail/u-boot/2021-March/444827.html



Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/6FeOPE1LNM4fRFp8Uc_mcHx
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmNtKLoACgkQAR8vZIA0
zr15Lgf/bI9BJhD+EiAI6EMzm+suHAILtB4jfcXPvH+9alEcgXFfQGZxKSzXVbRW
xgFzQrKjwKPHaFmZMZ4osD0YbhBrkfTbxv8umen0fAmWshTTkaGZ77Y9fw1/cQnh
1/bfE9swr24Qya1wxeFzIZC0kzgHD8z8i9CjR/cN/Zz9PABcCWloIsjUwvqHNQn8
+FSobkve7kxUudLllVD/XHF5/Vhi9hlySaNfQxcDe6VDCAFrMbXcA6O6DZAPRcor
H7hfxXatmaLZ+aB9qgmlA0m+nSHo9zhiADN6kmz08wQpxEZrkuFpKCjrabge40eQ
ggPkYa+HPAQggkEGlZJIvaLaKpZ/zg==
=cDxd
-----END PGP SIGNATURE-----

--Sig_/6FeOPE1LNM4fRFp8Uc_mcHx--
