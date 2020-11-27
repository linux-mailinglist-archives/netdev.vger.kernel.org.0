Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA3E72C61A4
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 10:26:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728542AbgK0JZj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 04:25:39 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:46839 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726479AbgK0JZi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 04:25:38 -0500
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4Cj8PD5Ps8z1qtdP;
        Fri, 27 Nov 2020 10:25:36 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4Cj8PD3qWQz1sy8T;
        Fri, 27 Nov 2020 10:25:36 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id wKFCwMyZBImG; Fri, 27 Nov 2020 10:25:34 +0100 (CET)
X-Auth-Info: ianmljXdbQK85ES58zeJwixR/kDdN+OwoExd+bYP9O8=
Received: from jawa (89-64-5-98.dynamic.chello.pl [89.64.5.98])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Fri, 27 Nov 2020 10:25:34 +0100 (CET)
Date:   Fri, 27 Nov 2020 10:25:28 +0100
From:   Lukasz Majewski <lukma@denx.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Fabio Estevam <festevam@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Peng Fan <peng.fan@nxp.com>, stefan.agner@toradex.com,
        krzk@kernel.org, Shawn Guo <shawnguo@kernel.org>
Subject: Re: [RFC 0/4] net: l2switch: Provide support for L2 switch on
 i.MX28 SoC
Message-ID: <20201127102528.33737ea4@jawa>
In-Reply-To: <20201127010811.GR2075216@lunn.ch>
References: <20201125232459.378-1-lukma@denx.de>
        <20201126123027.ocsykutucnhpmqbt@skbuf>
        <20201127003549.3753d64a@jawa>
        <20201127010811.GR2075216@lunn.ch>
Organization: denx.de
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/ZUTcj07yviLAI8FZ6erwpu5"; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/ZUTcj07yviLAI8FZ6erwpu5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

> > > I would push back and say that the switch offers bridge
> > > acceleration for the FEC.  =20
> >=20
> > Am I correct, that the "bridge acceleration" means in-hardware
> > support for L2 packet bridging?  =20
>=20
> You should think of the hardware as an accelerator, not a switch. The
> hardware is there to accelerate what linux can already do. You setup a
> software bridge in linux, and then offload L2 switching to the
> accelerator. You setup vlans in linux, and then offload the filtering
> of them to the accelerator. If there is something linux can do, but
> the hardware cannot accelerate, you leave linux to do it in software.

Ok.

>=20
> > Do you propose to catch some kind of notification when user calls:
> >=20
> > ip link add name br0 type bridge; ip link set br0 up;
> > ip link set lan1 up; ip link set lan2 up;
> > ip link set lan1 master br0; ip link set lan2 master br0;
> > bridge link
> >=20
> > And then configure the FEC driver to use this L2 switch driver? =20
>=20
> That is what switchdev does. There are various hooks in the network
> stack which call into switchdev to ask it to offload operations to the
> accelerator.

Ok.

>=20
> > The differences from "normal" DSA switches:
> >=20
> > 1. It uses mapped memory (for its register space) for
> > configuration/statistics gathering (instead of e.g. SPI, I2C) =20
>=20
> That does not matter. And there are memory mapped DSA switches. The
> DSA framework puts no restrictions on how the control plane works.
>=20
> > (Of course the "Section 32.5.8.2" is not available) =20
>=20
> It is in the Vybrid datasheet :-)

Hmm...

I cannot find such chapter in the official documentation from NXP:
"VFxxx Controller Reference Manual, Rev. 0, 10/2016"

Maybe you have more verbose version? Could you share how the document
is named?

>=20
>    Andrew


Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/ZUTcj07yviLAI8FZ6erwpu5
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAl/AxggACgkQAR8vZIA0
zr1hWwgAztQi95LdLdoifqpiMT0HJvIfQeEIBoYi1gdhVa6pKuuyoyAEEphKsLs+
PXv0a85iBITwkbv28qBmF2K70mejPSe65JUUIllRzWuBVcZotACNIlNI8poI0SIW
pCUsTZkxlPSXplQVyKs9c5YkY8KdGZvHdwZ55BITloHLwkngbIWC6f89Zb9mcgHb
w480ibSeaSnCJRB4ZfD0b2+9w3LTqW4nG2SUc2a8fC5hDHzt5YL8rjG33T3Ok0r+
L0PycPjKwA8ybHWduNmt5Ck4G9/AOsfXnWzXYDh7OKCWbz6TlRrQP1BxmIo3WTnU
ZlKcRWcqX+19Itn8CYyHCP7mHZjxqw==
=7wS1
-----END PGP SIGNATURE-----

--Sig_/ZUTcj07yviLAI8FZ6erwpu5--
