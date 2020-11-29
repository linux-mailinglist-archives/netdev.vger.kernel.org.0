Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A63DA2C7B8A
	for <lists+netdev@lfdr.de>; Sun, 29 Nov 2020 23:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728157AbgK2WAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 17:00:41 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:55557 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727691AbgK2WAl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Nov 2020 17:00:41 -0500
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4Ckj2T0t4Qz1qsZx;
        Sun, 29 Nov 2020 22:59:44 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4Ckj2S3Ss5z1sVDm;
        Sun, 29 Nov 2020 22:59:44 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id pzP6I_QFNfeH; Sun, 29 Nov 2020 22:59:42 +0100 (CET)
X-Auth-Info: dJgfE0LZlY9m7mjwc4i9J9VU5e7ylSJ6buofykKUjkw=
Received: from jawa (89-64-5-98.dynamic.chello.pl [89.64.5.98])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Sun, 29 Nov 2020 22:59:42 +0100 (CET)
Date:   Sun, 29 Nov 2020 22:59:11 +0100
From:   Lukasz Majewski <lukma@denx.de>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Fabio Estevam <festevam@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Peng Fan <peng.fan@nxp.com>, stefan.agner@toradex.com,
        krzk@kernel.org, Shawn Guo <shawnguo@kernel.org>
Subject: Re: [RFC 0/4] net: l2switch: Provide support for L2 switch on
 i.MX28 SoC
Message-ID: <20201129225911.7005923a@jawa>
In-Reply-To: <61fc64a6-a02b-3806-49fa-a916c6d9581a@gmail.com>
References: <20201125232459.378-1-lukma@denx.de>
        <20201126123027.ocsykutucnhpmqbt@skbuf>
        <20201127003549.3753d64a@jawa>
        <20201127192931.4arbxkttmpfcqpz5@skbuf>
        <20201128013310.38ecf9c7@jawa>
        <61fc64a6-a02b-3806-49fa-a916c6d9581a@gmail.com>
Organization: denx.de
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/K+PQFzJqwHBgG6i5AagWYqo"; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/K+PQFzJqwHBgG6i5AagWYqo
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Florian,

> On 11/27/2020 4:33 PM, Lukasz Majewski wrote:
> >> So why use DSA at all? What benefit does it bring you? Why not do
> >> the entire switch configuration from within FEC, or a separate
> >> driver very closely related to it? =20
> >=20
> > Mine rationale to use DSA and FEC:
> > - Make as little changes to FEC as possible =20
>=20
> Which is entirely possible if you stick to Vladimir suggestions of
> exporting services for the MTIP switch driver.

Ok.

>=20
> >=20
> > - Provide separate driver to allow programming FDB, MDB, VLAN setup.
> >   This seems straightforward as MTIP has separate memory region
> > (from FEC) for switch configuration, statistics, learning, static
> > table programming. What is even more bizarre FEC and MTIP have the
> > same 8 registers (with different base address and +4 offset :-) ) as
> >   interface to handle DMA0 transfers. =20
>=20
> OK, not sure how that is relevant here? The register organization
> should never ever dictate how to pick a particular subsystem.
>=20
> >=20
> > - According to MTIP description from NXP documentation, there is a
> >   separate register for frame forwarding, so it _shall_ also fit
> > into DSA. =20
>=20
> And yet it does not, Vladimir went into great length into explaining
> what makes the MTIP + dual FEC different here and why it does not
> qualify for DSA.=20

I'm very grateful for this insight and explanation from Vladimir.

> Basically any time you have DMA + integrated switch
> tightly coupled you have what we have coined a "pure switchdev"
> wrapper.

Ok.

>=20
> >=20
> >=20
> > For me it would be enough to have:
> >=20
> > - lan{12} - so I could enable/disable it on demand (control when
> > switch ports are passing or not packets).
> >=20
> > - Use standard net tools (like bridge) to setup FDB/MDB, vlan=20
> >=20
> > - Read statistics from MTIP ports (all of them)
> >=20
> > - I can use lan1 (bridged or not) to send data outside. It would be
> >   also correct to use eth0. =20
>=20
> You know you can do that without having DSA, right? Look at mlxsw,
> look at rocker. You can call multiple times register_netdevice() with
> custom network devices that behave differently whether HW bridging
> offload is offered or not, whether the switch is declared in Device
> Tree or not.

I will look into those examples and try to follow them for MTIP.

>=20
> >=20
> > I'm for the most pragmatic (and simple) solution, which fulfill
> > above requirements. =20
>=20
> The most pragmatic solution is to implement switchdev operations to
> offer HW bridging offload, VLAN programming, FDB/MDB programming.

Ok.

>=20
> It seems to me that you are trying to look for a framework to avoid
> doing a bit of middle layer work between switchdev and the FEC driver
> and that is not setting you for success.

I'm not afraid to rework FEC. I just thought that DSA would be the best
fit for the MTIP. However, after posting the RFC, the community gave me
arguments that I was wrong.

I'm happy for having so detailed feedback :-).


Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/K+PQFzJqwHBgG6i5AagWYqo
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAl/EGa8ACgkQAR8vZIA0
zr3MOAgAnLULxSiPZawSpbxpakkkKghR5WK7CwUeH3zUzYH5bdlEfYG9S0cMfnwM
0/jfi01s7ARwezTnQdigsL0T5leRRgbE5atO/nozhEHs9SJ7ZOCKzVAKA9GxKtXg
Wv4VPk15J80FdXB3+yOikWIhzGQkDm07M/7aVUJxp5jZzlDG0tX4xJb8noNrC82k
2dvo3sb5B92WNfOIH2aPOzqq6TSOw6lKNREnW0id8scXdoUDmtY0WG46x9O3S7a0
ZZIfY8/sibbb8O/400rMd8L4+3vB7xx70ejuNUqNIjtOhIIX2L/vE/s1j3lm4pk3
4y/I5bKJHplE1RBC1Zf61qOm6WqhaA==
=CucV
-----END PGP SIGNATURE-----

--Sig_/K+PQFzJqwHBgG6i5AagWYqo--
