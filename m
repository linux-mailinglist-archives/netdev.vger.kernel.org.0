Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3A9D3B5D90
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 14:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232956AbhF1MIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 08:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232926AbhF1MIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 08:08:05 -0400
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAB6FC061766;
        Mon, 28 Jun 2021 05:05:36 -0700 (PDT)
Received: from ktm (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 0FCAC82DBA;
        Mon, 28 Jun 2021 14:05:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1624881933;
        bh=UIyRjwy0vFnK2UZowXIaRpxAMqdxk5niHOiRA8DOgxg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=zJ0tKC7qc4492AcJQEgN+To4LYQYAQyDrZ9B0yK+5edUSoaOhpoJAx2UDFMw1WPUI
         lUSSTaTkSxeKqAKLhzJJigposDp0oxaXGJyEMm/0WSpR9haz01yeaDByANk/CTGJ7y
         UyG1g2M+jemyGc6Gn77TqQfVHU0xop8SLE1pcNsyhz51AMhpQvomXqASy1u25PuWLL
         y9X5o/H0s/rucmg8bjMtgWCYbRSjm+yBoJvLKE5Ip6O1tm6mlJtVrDYN8BLkyIAVav
         ktv3laFgdkOZ3JP4TpA9xNuA9oObXzkypNy5nb3dgryNkLrF6Ud9zXfclQbDyPbL4X
         W2Owvz2P6ExZQ==
Date:   Mon, 28 Jun 2021 14:05:26 +0200
From:   Lukasz Majewski <lukma@denx.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Mark Einon <mark.einon@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/3] net: Provide switchdev driver for NXP's More Than IP
 L2 switch
Message-ID: <20210628140526.7417fbf2@ktm>
In-Reply-To: <YNXq1bp7XH8jRyx0@lunn.ch>
References: <20210622144111.19647-1-lukma@denx.de>
        <20210622144111.19647-3-lukma@denx.de>
        <YNH7vS9FgvEhz2fZ@lunn.ch>
        <20210623133704.334a84df@ktm>
        <YNOTKl7ZKk8vhcMR@lunn.ch>
        <20210624125304.36636a44@ktm>
        <YNSJyf5vN4YuTUGb@lunn.ch>
        <20210624163542.5b6d87ee@ktm>
        <YNSuvJsD0HSSshOJ@lunn.ch>
        <20210625115935.132922ff@ktm>
        <YNXq1bp7XH8jRyx0@lunn.ch>
Organization: denx.de
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/oRs4Gqruek3169mZ2ms_wVj"; protocol="application/pgp-signature"
X-Virus-Scanned: clamav-milter 0.103.2 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/oRs4Gqruek3169mZ2ms_wVj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

> > I do believe that I can just extend the L2 switch driver (fec_mtip.c
> > file to be precise) to provide full blown L2 switch functionality
> > without touching the legacy FEC more than in this patch set.
> >=20
> > Would you consider applying this patch series then? =20
>=20
> What is most important is the ABI. If something is merged now, we need
> to ensure it does not block later refactoring to a clean new
> driver. The DT binding is considered ABI. So the DT binding needs to
> be like a traditional switchdev driver. Florian already pointed out,
> you can use a binding very similar to DSA. ti,cpsw-switch.yaml is
> another good example.

The best I could get would be:

&eth_switch {
	compatible =3D "imx,mtip-l2switch";
	reg =3D <0x800f8000 0x400>, <0x800fC000 0x4000>;

	interrupts =3D <100>;
	status =3D "okay";

	ethernet-ports {
		port1@1 {
			reg =3D <1>;
			label =3D "eth0";
			phys =3D <&mac0 0>;
		};

		port2@2 {
			reg =3D <2>;
			label =3D "eth1";
			phys =3D <&mac1 1>;
		};
	};
};

Which would abuse the "phys" properties usages - as 'mac[01]' are
referring to ethernet controllers.

On TI SoCs (e.g. am33xx-l4.dtsi) phys refer to some separate driver
responsible for PHY management. On NXP this is integrated with FEC
driver itself.

>=20
> So before considering merging your changes, i would like to see a
> usable binding.
>=20
> I also don't remember seeing support for STP. Without that, your
> network has broadcast storm problems when there are loops. So i would
> like to see the code needed to put ports into blocking, listening,
> learning, and forwarding states.
>=20
> 	  Andrew




Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/oRs4Gqruek3169mZ2ms_wVj
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmDZuwYACgkQAR8vZIA0
zr2RcAgAuMY1iZZF2X1EHM9gUTLF569/9gcgivWFrvNEChAKx5zHxpIbgzxPAnwm
GzabIwg2N4OIHd1QGNR9zWxba3EnRbAG9+YdcGNIY6XN9wR7qe5LUjLpyg3kyica
hlSc5lqCeXhZYzPEIyUx1t8mc14J7aUw4s09YSkqWFWpDd2vbCgJGuExIM/qrOE9
ZI1ramBtlAMNvA6aJmpTM9tJTIb3Ih9gqqJVSpsLSkn4iVYeYWO0OT0HNncnAf5p
3clvENVZPplWGGwedpyCMyRvu5Q/Ww7pce6YdJ42RmTFeBw0xHjHPbvcrYj+qspD
oapmrFJvImA1Gc1aerNhuLtH+UWgEg==
=ZPz6
-----END PGP SIGNATURE-----

--Sig_/oRs4Gqruek3169mZ2ms_wVj--
