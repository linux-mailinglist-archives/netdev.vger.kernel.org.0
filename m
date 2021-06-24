Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73E3B3B2CF5
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 12:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232164AbhFXKzd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 06:55:33 -0400
Received: from phobos.denx.de ([85.214.62.61]:38482 "EHLO phobos.denx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231294AbhFXKzc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 06:55:32 -0400
Received: from ktm (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 7BACF8295B;
        Thu, 24 Jun 2021 12:53:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1624531992;
        bh=0kwS38FN4M1tYLgnE4YcsFV92Xu3zXJ1hbI8I6gufgM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hYNhMrJ5vF109+fw9dRg3JDWD/T+5r9V8Q8lmQHLw7H0+e/gr5RuN2guF3nAPQzOw
         V1HtJhd7GI2Ql1A8SwyS4rKUODhbXidVnRVXdD7afo6x0amazb544y4BxLXzx//Gfy
         PzKuzigrMHYEINDGS+vt/4qaL8DboKmePv5NPgDE0ZcLPISvPI/d86+z9Eq7/YEOdH
         S4z9mQgjQyKlAngggNXmtkBwj6/2n0so4xacFr8bw/YX9RlX4s6xgk7qOiNUa//ST/
         wv7p/CIedX4mBlTZMfnt58kVCjY7VLwmVVIuRRFju0VqwCmTxNHTQpnF8olK2vS9Oz
         zCXIO8cejUkew==
Date:   Thu, 24 Jun 2021 12:53:04 +0200
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
Message-ID: <20210624125304.36636a44@ktm>
In-Reply-To: <YNOTKl7ZKk8vhcMR@lunn.ch>
References: <20210622144111.19647-1-lukma@denx.de>
        <20210622144111.19647-3-lukma@denx.de>
        <YNH7vS9FgvEhz2fZ@lunn.ch>
        <20210623133704.334a84df@ktm>
        <YNOTKl7ZKk8vhcMR@lunn.ch>
Organization: denx.de
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/qtYqIBs1p_KEhl/OXc+e7ue"; protocol="application/pgp-signature"
X-Virus-Scanned: clamav-milter 0.103.2 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/qtYqIBs1p_KEhl/OXc+e7ue
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

> > > Using volatile is generally wrong. Why do you need it? =20
> >=20
> > This was the code, which I took from the legacy driver. I will
> > adjust it. =20
>=20
> It is called 'vendor crap' for a reason.

:-)

>=20
> > > > +	for_each_available_child_of_node(p, port) {
> > > > +		if (of_property_read_u32(port, "reg",
> > > > &port_num))
> > > > +			continue;
> > > > +
> > > > +		priv->n_ports =3D port_num;
> > > > +
> > > > +		fep_np =3D of_parse_phandle(port, "phy-handle",
> > > > 0);   =20
> > >=20
> > > As i said, phy-handle points to a phy. It minimum, you need to
> > > call this mac-handle. But that then makes this switch driver very
> > > different to every other switch driver. =20
> >=20
> > Other drivers (DSA for example) use "ethernet" or "link" properties.
> > Maybe those can be reused? =20
>=20
> Not really. They have well known meanings and they are nothing like
> what you are trying to do. You need a new name. Maybe 'mac-handle'?

Ok.

>=20
>=20
> > > > +		pdev =3D of_find_device_by_node(fep_np);
> > > > +		ndev =3D platform_get_drvdata(pdev);
> > > > +		priv->fep[port_num - 1] =3D netdev_priv(ndev);
> > > > =20
> > >=20
> > > What happens when somebody puts reg=3D<42>; in DT? =20
> >=20
> > I do guess that this will break the code.
> >=20
> > However, DSA DT descriptions also rely on the exact numbering [1]
> > (via e.g. reg property) of the ports. I've followed this paradigm. =20
>=20
> DSA does a range check:
>=20
>         for_each_available_child_of_node(ports, port) {
>                 err =3D of_property_read_u32(port, "reg", &reg);
>                 if (err)
>                         goto out_put_node;
>=20
>                 if (reg >=3D ds->num_ports) {
>                         dev_err(ds->dev, "port %pOF index %u exceeds
> num_ports (%zu)\n", port, reg, ds->num_ports);
>                         err =3D -EINVAL;
>                         goto out_put_node;
>                 }
>=20

Ok.

> > > I would say, your basic structure needs to change, to make it more
> > > like other switchdev drivers. You need to replace the two FEC
> > > device instances with one switchdev driver. =20
> >=20
> > I've used the cpsw_new.c as the example.
> >  =20
> > > The switchdev driver will then
> > > instantiate the two netdevs for the two external MACs. =20
> >=20
> > Then there is a question - what about eth[01], which already
> > exists? =20
>=20
> They don't exist. cpsw_new is not used at the same time as cpsw, it
> replaces it. This new driver would replace the FEC driver.

I see.

> cpsw_new
> makes use of some of the code in the cpsw driver to implement two
> netdevs. This new FEC switch driver would do the same, make use of
> some of the low level code, e.g. for DMA access, MDIO bus, etc.

I'm not sure if the imx28 switch is similar to one from TI (cpsw-3g)
- it looks to me that the bypass mode for both seems to be very
different. For example, on NXP when switch is disabled we need to
handle two DMA[01]. When it is enabled, only one is used. The approach
with two DMAs is best handled with FEC driver instantiation.

>=20
> > To be honest - such driver for L2 switch already has been forward
> > ported by me [2] to v4.19. =20
>=20
> Which is fine, you can do whatever you want in your own fork. But for
> mainline, we need a clean architecture.

This code is a forward port of vendor's (Freescale) old driver. It uses
the _wrong_ approach, but it can (still) be used in production after
some adjustments.

> I'm not convinced your code is
> that clean,

The code from [2] needs some vendor ioctl based tool (or hardcode) to
configure the switch.=20

> and how well future features can be added. Do you have
> support for VLANS? Adding and removing entries to the lookup tables?
> How will IGMP snooping work? How will STP work?

This can be easily added with serving netstack hooks (as it is already
done with cpsw_new) in the new switchdev based version [3] (based on
v5.12).

>=20
>     Andrew

Links:

[3] -
https://source.denx.de/linux/linux-imx28-l2switch/-/commits/imx28-v5.12-L2-=
upstream-switchdev-RFC_v1


Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/qtYqIBs1p_KEhl/OXc+e7ue
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmDUZBAACgkQAR8vZIA0
zr1fjQf/bj+Weys4U7pw90bnkgZGZAKc0+5pyMUIYMeVqymm/3fkReqRmWF4eb57
V3beyUumV8yAzZgf4nIvGf+V5g/lmS3YwYBHCyoZz9hxwBaM923bWXySrgm/1P87
B2SpK02VSn5fpet5etL0WU7Gf0yqKvKWTvU4xKPfGauff65fWt36uO37vNnLh/DM
/BAAWyIXC0CtEAACFUw0WpiGz3igvT3FFKQIzUhcist+ocAew2YiAwOHRnGoRRp+
ip8gG98DcE04CTLqhHOWJggc0+0zOsjsulLkmlajywE6hX9tbOU8HTjJ+Fc74RXw
zEoCdczJLSGE1W9N0PtgBPZxh5Kn6g==
=mlqD
-----END PGP SIGNATURE-----

--Sig_/qtYqIBs1p_KEhl/OXc+e7ue--
