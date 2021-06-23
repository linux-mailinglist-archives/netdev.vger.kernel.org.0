Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE513B1D99
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 17:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbhFWP27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 11:28:59 -0400
Received: from phobos.denx.de ([85.214.62.61]:59696 "EHLO phobos.denx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229523AbhFWP26 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Jun 2021 11:28:58 -0400
Received: from ktm (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 19E73829C0;
        Wed, 23 Jun 2021 17:26:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1624461999;
        bh=Ad2oj8LJDEBPkhxuWus0G9Bt9hK4DhlS4HyiBHvg654=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=THPRWo3k8bKRfB4xqXY9JMDadNC9d3MeboCf46nDaINIBpVSwR9X0esnlT9f2MQXU
         w4CCjBZHmpTy8xG7I2UgQmXIdnHWxisNo3HbnNbzocjoKbePQcUBLEqMXNfvTSyguk
         cafrxJ4kglV1maWFtW8N8l1ACSGmia0iXdRq70Rxr2tVZiCGUIQuOoUlNhNR38eM7m
         mt0CrECiB7qbrVXT9LplsnacExG0gd4BIAGoKp3CypZ0hC6M+FmmlcwIo0EdQsKOfd
         cTEtcYWP2H+UwFvrW/yuUmr1SH1wukAQlvL4G7Hy0iLG/MhvyJRhqzLXgAut+iO9hD
         gM9CGgB0b67AQ==
Date:   Wed, 23 Jun 2021 17:26:31 +0200
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
Subject: Re: [RFC 1/3] ARM: dts: imx28: Add description for L2 switch on XEA
 board
Message-ID: <20210623172631.0b547fcd@ktm>
In-Reply-To: <YNM0Wz1wb4dnCg5/@lunn.ch>
References: <20210622144111.19647-1-lukma@denx.de>
        <20210622144111.19647-2-lukma@denx.de>
        <YNH3mb9fyBjLf0fj@lunn.ch>
        <20210622225134.4811b88f@ktm>
        <YNM0Wz1wb4dnCg5/@lunn.ch>
Organization: denx.de
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/mnqD6czC/DR4qF_Yl8dNP/w"; protocol="application/pgp-signature"
X-Virus-Scanned: clamav-milter 0.103.2 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/mnqD6czC/DR4qF_Yl8dNP/w
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

> On Tue, Jun 22, 2021 at 10:51:34PM +0200, Lukasz Majewski wrote:
> > Hi Andrew,
> >=20
> > > On Tue, Jun 22, 2021 at 04:41:09PM +0200, Lukasz Majewski wrote:
> > > > The 'eth_switch' node is now extendfed to enable support for L2
> > > > switch.
> > > >=20
> > > > Moreover, the mac[01] nodes are defined as well and linked to
> > > > the former with 'phy-handle' property. =20
> > >=20
> > > A phy-handle points to a phy, not a MAC! Don't abuse a well known
> > > DT property like this.
> >=20
> > Ach.... You are right. I will change it.
> >=20
> > Probably 'ethernet' property or 'link' will fit better?
>=20
> You should first work on the overall architecture. I suspect you will
> end up with something more like the DSA binding, and not have the FEC
> nodes at all. Maybe the MDIO busses will appear under the switch?
>=20
> Please don't put minimal changes to the FEC driver has your first
> goal. We want an architecture which is similar to other switchdev
> drivers. Maybe look at drivers/net/ethernet/ti/cpsw_new.c.

I'm a bit confused - as I thought that with switchdev API I could just
extend the current FEC driver to add bridge offload.
This patch series shows that it is doable with little changes
introduced.

However, now it looks like I would need to replace FEC driver and
rewrite it in a way similar to cpsw_new.c, so the switchdev could be
used for both cases - with and without L2 switch offload.

This would be probably conceptually correct, but i.MX FEC driver has
several issues to tackle:

- On some SoCs (vf610, imx287, etc.) the ENET-MAC ports don't have the
  same capabilities (eth1 is a bit special)

- Without switch we need to use DMA0 and DMA1 in the "bypass" switch
  mode (default). When switch is enabled we only use DMA0. The former
  case is best fitted with FEC driver instantiation. The latter with
  DSA or switchdev.

> The cpsw
> driver has an interesting past, it did things the wrong way for a long
> time, but the new switchdev driver has an architecture similar to what
> the FEC driver could be like.
>=20
> 	Andrew

Maybe somebody from NXP can provide input to this discussion - for
example to sched some light on FEC driver (near) future.


Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/mnqD6czC/DR4qF_Yl8dNP/w
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmDTUqcACgkQAR8vZIA0
zr3LfQf/Zot+Z55/glX8vDDtSt6reS9ADWfJ9hMRqPqRB1iCGVQYMISBWCUlH2w+
lurkNGjWqUq72LgyyJuBGgAvm1HDRegCcs0dxFi0b0NtMgfKo+WLc9OqisN0enzQ
QydsMbXG2oB7nGN2PVqx+3TiYBr6wV4tUhS4RzLrtAkPaJOLYqQWEFdP8mnyKNQv
pJeX2BWfkoJTHW2WJp2U+0TrWse7F2yXCaawKOlv0g/2HP3XWAl/htqAUuzQ4b/u
c/0M1O6o936T4Ny7RTkRy9h+KVSSbOzLdwsITltSbQWcupZtTCF011RNmV6z6PeN
LNVsEtp3m+d2z/g9DEu7w0s1hh00KQ==
=Z0Zy
-----END PGP SIGNATURE-----

--Sig_/mnqD6czC/DR4qF_Yl8dNP/w--
