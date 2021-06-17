Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C78A43AB1F5
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 13:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232315AbhFQLKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 07:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232174AbhFQLKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 07:10:39 -0400
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27B6AC061574;
        Thu, 17 Jun 2021 04:08:31 -0700 (PDT)
Received: from ktm (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 23EAA82A10;
        Thu, 17 Jun 2021 13:08:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1623928108;
        bh=pcOzzBeQhCrTCv1Dfu8x46w7ZuAgbD8BUEYPJTGCU+Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=a0yNqq3sjmORZW77MSohtqeYYoA3G69lnGi1lbZm/clpKyPHxltJzLbuuajrrAyOn
         wsorzPbdm9VpTy+opuIZG4jp1oFrRDm7veum0LyrKQbi8T+sZsW0EOMFQ8pQD3FLz/
         TnUJ+Y61UNgDnGAzOWRlRPZ93RxTs6+Qk4Sy0wiwBdyc0a31s/ZvmcDpE3E8UNq2bP
         zepudZLJRMB2sAXTVdv7GHawruFhmwI8gQPFLY2xdMb1TonG9kniUI6BY4uodVmZ2t
         xiT38Jd+w+alEYsESWzsxw5sQVw1gXQEz5orYdsQNgC4AdfPfOBRoW45cVgEAtWL3Y
         HGu4nWHgiIXqg==
Date:   Thu, 17 Jun 2021 13:08:21 +0200
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
Message-ID: <20210617130821.465c7522@ktm>
In-Reply-To: <20201127010811.GR2075216@lunn.ch>
References: <20201125232459.378-1-lukma@denx.de>
        <20201126123027.ocsykutucnhpmqbt@skbuf>
        <20201127003549.3753d64a@jawa>
        <20201127010811.GR2075216@lunn.ch>
Organization: denx.de
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/QloJitVVT20CNPsZ=oxvahO"; protocol="application/pgp-signature"
X-Virus-Scanned: clamav-milter 0.103.2 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/QloJitVVT20CNPsZ=oxvahO
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
>=20
> > Do you propose to catch some kind of notification when user calls:
> >=20
> > ip link add name br0 type bridge; ip link set br0 up;
> > ip link set lan1 up; ip link set lan2 up;
> > ip link set lan1 master br0; ip link set lan2 master br0;
> > bridge link

^^^^^^^^^^^^^ [*]

> >=20
> > And then configure the FEC driver to use this L2 switch driver? =20
>=20
> That is what switchdev does. There are various hooks in the network
> stack which call into switchdev to ask it to offload operations to the
> accelerator.

I'm a bit confused about the interfaces that pop up when I do enable
bridging acceleration.

Without bridge I do have:
- eth0 (this is a 'primary' interface -> it also controls MII/PHY for
  eth1)
- eth1 (it uses the MII/PHY control from eth0)

Both interfaces works correctly.

And after starting the bridge (and switchdev) with commands from [*] I
do have:

- br0 (created bridge - need to assign IP to it to communicate outside,
  even when routing is set via eth0, and eth0 has the same IP address)
- eth0 (just is used to control PHY - ifconfig up/down)
- eth1 (just is used to control PHY - ifconfig up/down)

And now the question, how internally shall I tackle the transmission
(i.e. DMA setups)?

Now, I do use some hacks to re-use code for eth0 to perform the
transmission from/to imx28 L2 switch. The eth1 is stopped (it only
controls the PHY - responds to MII interrupts).

The above setup works, and the code adjustment for fec_main.c driver is
really small.

However, I do wonder how conceptually it "mix" with br0 interface? I
could leave br0 as is, but then why do I need to asign the IP address
to it to communicate?
As I need to do it - then conceptually (re-)using eth0 internal
structures (and the driver in fact) looks like some kind of abusement.=20
However, adding the transmission handling to br0 net device would bloat
and potentially duplicate the code.

I would prefer to re-use code from eth0 interface - it would be also
easier to cleanu up after disabling the L2 switch.

Any feedback and help is more than welcome.

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
>=20
>    Andrew



Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/QloJitVVT20CNPsZ=oxvahO
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmDLLSUACgkQAR8vZIA0
zr3aGgf/XSfvHyEfZtP+OBkQl6d44dJrfbj27lGTMqODsZoYWHjMl8tuYiWS8B1p
Bl8uU/Ivn7dMnc9/e5LFqNEMg8W7T5O09L7q45rNNdr2JRXsG5VgUMpFzRUecHau
9l81DsnTAXowlhOnxIKSvSBEqRhsMsbcAwQnLF3sUNv0VgGFp5UxoJB7aOrPAZGy
eh54N+E4aCQcVmf32PYlhF7Dcw6zSlokLpsIA3Kd75o9wtCGpeoTvoc4czt3i/K9
9vZIqUXfvHas9W5i7jszTtL9KZxMGyJrw/543U7+Nz8EapKQ4zqjN7p63t+vbxkg
xWDTktJdRWwFjBFagBHbYI3IYvU/tg==
=Mmkl
-----END PGP SIGNATURE-----

--Sig_/QloJitVVT20CNPsZ=oxvahO--
