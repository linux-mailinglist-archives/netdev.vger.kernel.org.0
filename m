Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B96D3B5FBC
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 16:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232480AbhF1OPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 10:15:49 -0400
Received: from phobos.denx.de ([85.214.62.61]:51236 "EHLO phobos.denx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232465AbhF1OPs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Jun 2021 10:15:48 -0400
Received: from ktm (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 3D93582D99;
        Mon, 28 Jun 2021 16:13:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1624889601;
        bh=rEHKnpCCOjhwWxcMc4pBrXRlstTD75NAJKi157PQKUU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iHZCYUicoJ4sCMdzXa3p2o73NMx0MVeumWQhMDaSusFaxu8myswuUWQCYDPLByMHg
         1yhoEy0UopUwD/HGc2hcFruNkh7PYhQn7Lxcm4qcvpN9JAjI8j0a6ztTrtXJhNFYuF
         c9Tpp3fNniAcBYmo3RRL4F596MIWnpwutZ4yerDw+K4ERxcQhKTLJzJCyA1pEPnIb8
         RAec3Xu0YvGYt0SYyTSMwRyk1aP3cX0dx6E6o/DDS0JyVQmPFC/R9T7YT2YfLhLydo
         jW+SutmF52Gp89FI3mw7I4QsFMfuJSvBZGiQbYxHBZKQwkfbS7HLxRYJx18ZCD3CCG
         dPA/w3A7/5FSw==
Date:   Mon, 28 Jun 2021 16:13:14 +0200
From:   Lukasz Majewski <lukma@denx.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Mark Einon <mark.einon@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/3] net: Provide switchdev driver for NXP's More Than IP
 L2 switch
Message-ID: <20210628161314.37223141@ktm>
In-Reply-To: <20210628124835.zbuija3hwsnh2zmd@skbuf>
References: <YNH7vS9FgvEhz2fZ@lunn.ch>
        <20210623133704.334a84df@ktm>
        <YNOTKl7ZKk8vhcMR@lunn.ch>
        <20210624125304.36636a44@ktm>
        <YNSJyf5vN4YuTUGb@lunn.ch>
        <20210624163542.5b6d87ee@ktm>
        <YNSuvJsD0HSSshOJ@lunn.ch>
        <20210625115935.132922ff@ktm>
        <YNXq1bp7XH8jRyx0@lunn.ch>
        <20210628140526.7417fbf2@ktm>
        <20210628124835.zbuija3hwsnh2zmd@skbuf>
Organization: denx.de
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/iX6di2EciPiCLEusLdw9kdi"; protocol="application/pgp-signature"
X-Virus-Scanned: clamav-milter 0.103.2 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/iX6di2EciPiCLEusLdw9kdi
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Vladimir,

> On Mon, Jun 28, 2021 at 02:05:26PM +0200, Lukasz Majewski wrote:
> > Hi Andrew,
> > =20
> > > > I do believe that I can just extend the L2 switch driver
> > > > (fec_mtip.c file to be precise) to provide full blown L2 switch
> > > > functionality without touching the legacy FEC more than in this
> > > > patch set.
> > > >
> > > > Would you consider applying this patch series then? =20
> > >
> > > What is most important is the ABI. If something is merged now, we
> > > need to ensure it does not block later refactoring to a clean new
> > > driver. The DT binding is considered ABI. So the DT binding needs
> > > to be like a traditional switchdev driver. Florian already
> > > pointed out, you can use a binding very similar to DSA.
> > > ti,cpsw-switch.yaml is another good example. =20
> >
> > The best I could get would be:
> >
> > &eth_switch {
> > 	compatible =3D "imx,mtip-l2switch";
> > 	reg =3D <0x800f8000 0x400>, <0x800fC000 0x4000>;
> >
> > 	interrupts =3D <100>;
> > 	status =3D "okay";
> >
> > 	ethernet-ports {
> > 		port1@1 {
> > 			reg =3D <1>;
> > 			label =3D "eth0";
> > 			phys =3D <&mac0 0>;
> > 		};
> >
> > 		port2@2 {
> > 			reg =3D <2>;
> > 			label =3D "eth1";
> > 			phys =3D <&mac1 1>;
> > 		};
> > 	};
> > };
> >
> > Which would abuse the "phys" properties usages - as 'mac[01]' are
> > referring to ethernet controllers.
> >
> > On TI SoCs (e.g. am33xx-l4.dtsi) phys refer to some separate driver
> > responsible for PHY management. On NXP this is integrated with FEC
> > driver itself. =20
>=20
> If we were really honest, the binding would need to be called
>=20
> port@0 {
> 	puppet =3D <&mac0>;
> };
>=20
> port@1 {
> 	puppet =3D <&mac1>;
> };
>=20
> which speaks for itself as to why accepting "puppet master" drivers is
> not really very compelling. I concur with the recommendation given by
> Andrew and Florian to refactor FEC as a multi-port single driver.

Ok.

>=20
> > >
> > > So before considering merging your changes, i would like to see a
> > > usable binding.
> > >
> > > I also don't remember seeing support for STP. Without that, your
> > > network has broadcast storm problems when there are loops. So i
> > > would like to see the code needed to put ports into blocking,
> > > listening, learning, and forwarding states.
> > >
> > > 	  Andrew =20
>=20
> I cannot stress enough how important it is for us to see STP support
> and consequently the ndo_start_xmit procedure for switch ports.

Ok.

> Let me see if I understand correctly. When the switch is enabled, eth0
> sends packets towards both physical switch ports, and eth1 sends
> packets towards none, but eth0 handles the link state of switch port
> 0, and eth1 handles the link state of switch port 1?

Exactly, this is how FEC driver is utilized for this switch.=20


Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/iX6di2EciPiCLEusLdw9kdi
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmDZ2PoACgkQAR8vZIA0
zr0aUAf9E5BRJ+WcI/6OphC0Lod4LCdW059FQBJGB/ZGFNjGvhtHJ0tfumTNCZjH
lIYBW5IiH3uMKa8LmkqYMJ9jwN0thh/ms+Sis1x7lcQLSEJ182rWh9Ox7KkU8iJK
ig5bj2SLsYOZZ4vypt/XqDBpTkSNeFpn0GCx0DtkxR5Idgu29fO5+e3BGDW2+YFv
KqRMCE+GirfG92vYLv7lrlvjQpaDr/p6jwkjJLFjHrjnTZ6FzsPsCkCD6DxH2p/D
DTrLWcCfUdZi7W0+QdzsB0l51qkwonPvo5jwLb1meP2wQtTnRIFevQE8VxJLfNyE
gBXDQruPm0kIQbWQwUO7GsGsokLGfw==
=n4Sd
-----END PGP SIGNATURE-----

--Sig_/iX6di2EciPiCLEusLdw9kdi--
