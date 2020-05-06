Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 410E51C6747
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 07:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbgEFFLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 01:11:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725821AbgEFFLp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 01:11:45 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1B41C061A0F
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 22:11:44 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jWCLH-0002HK-M7; Wed, 06 May 2020 07:11:35 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1jWCLG-00086W-Ft; Wed, 06 May 2020 07:11:34 +0200
Date:   Wed, 6 May 2020 07:11:34 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Marek Vasut <marex@denx.de>, David Jander <david@protonic.nl>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v1] dt-bindings: net: nxp,tja11xx: rework validation
 support
Message-ID: <20200506051134.mrm4nuqxssw255tl@pengutronix.de>
References: <20200505104215.8975-1-o.rempel@pengutronix.de>
 <20200505140127.GJ208718@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="y6mtvp5pc3cshvwy"
Content-Disposition: inline
In-Reply-To: <20200505140127.GJ208718@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 07:01:44 up 172 days, 20:20, 176 users,  load average: 0.19, 0.10,
 0.09
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--y6mtvp5pc3cshvwy
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 05, 2020 at 04:01:27PM +0200, Andrew Lunn wrote:
> On Tue, May 05, 2020 at 12:42:15PM +0200, Oleksij Rempel wrote:
> > To properly identify this node, we need to use ethernet-phy-id0180.dc80.
> > And add missing required properties.
> >=20
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > ---
> >  .../devicetree/bindings/net/nxp,tja11xx.yaml  | 55 ++++++++++++-------
> >  1 file changed, 35 insertions(+), 20 deletions(-)
> >=20
> > diff --git a/Documentation/devicetree/bindings/net/nxp,tja11xx.yaml b/D=
ocumentation/devicetree/bindings/net/nxp,tja11xx.yaml
> > index 42be0255512b3..cc322107a24a2 100644
> > --- a/Documentation/devicetree/bindings/net/nxp,tja11xx.yaml
> > +++ b/Documentation/devicetree/bindings/net/nxp,tja11xx.yaml
> > @@ -1,4 +1,4 @@
> > -# SPDX-License-Identifier: GPL-2.0+
> > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> >  %YAML 1.2
> >  ---
> >  $id: http://devicetree.org/schemas/net/nxp,tja11xx.yaml#
> > @@ -12,44 +12,59 @@ maintainers:
> >    - Heiner Kallweit <hkallweit1@gmail.com>
> > =20
> >  description:
> > -  Bindings for NXP TJA11xx automotive PHYs
> > +  Bindings for the NXP TJA1102 automotive PHY. This is a dual PHY pack=
age where
> > +  only the first PHY has global configuration register and HW health
> > +  monitoring.
> > =20
> > -allOf:
> > -  - $ref: ethernet-phy.yaml#
> > +properties:
> > +  compatible:
> > +    const: ethernet-phy-id0180.dc80
> > +    description: ethernet-phy-id0180.dc80 used for TJA1102 PHY
> > +
> > +  reg:
> > +    minimum: 0
> > +    maximum: 14
> > +    description:
> > +      The PHY address of the parent PHY.
>=20
> Hi Oleksij
>=20
> reg is normally 0 to 31, since that is the address range for MDIO.=20
> Did you use 14 here because of what strapping allows?

Yes. Only BITs 1:3 are configurable. BIT(0) is always 0 for the PHY0 and 1
for the PHY1

> > +required:
> > +  - compatible
> > +  - reg
> > +  - '#address-cells'
> > +  - '#size-cells'
>=20
> So we have two different meanings of 'required' here.
>=20
> One meaning is the code requires it. compatible is not required, the
> driver will correctly be bind to the device based on its ID registers.
> Is reg also required by the code?
>=20
> The second meaning is about keeping the yaml verifier happy. It seems
> like compatible is needed for the verifier. Is reg also required? We
> do recommend having reg, but the generic code does not require it.

reg is used by:
tja1102_p0_probe()
  tja1102_p1_register()
    of_mdio_parse_addr()

But this is required for the slave PHY. I assume the reg can be
optional for the master PHY. Should I?

Regards,
Oleksij
--=20
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--y6mtvp5pc3cshvwy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEERBNZvwSgvmcMY/T74omh9DUaUbMFAl6yRvkACgkQ4omh9DUa
UbPheA//Te8R3kEDCbeoDdug4dcFxw6htc5AlZmxKUGyHniiMNo5ew1OleQGFEg+
c48xPMKS+5d4hvh5qp/Yw4g4Vl7pE59vVScvU8nX/H1P6FFM4SrQQDDosNGRwIB1
SKaSa/mIfdzCr8tBFM5i3CLnyRjPmYXkkzbBQjUo2spO0HPyMzl3suLvtuPB8mRf
csh9yPAazDtz6MfyI1YiDmJqonRnt/GAOdhBTlkeb2UYkQ4EOWQXkQ5Zu2zgkvOV
z2vwshWm0H1uVnSNXh4Zr3nsZyWHuYRpUBmmcxXFV1wXz66tc0hO56l+iGpVFLRs
lFeA0M1/UNHeCmKX76WrCnnSDIvTuPKdlVWh1GsnhCEums++2LXuP2XMajVPBfXv
oPwIs7xBydzxbShTUgaIpmpC7jGwVT78XFRfzo/2gX/PxrTfcY5DM4SdJvhs+xS3
sV+8Jc7STqrPTYY2iWno3dKf5ESZG66JV++ZHZks6RUK/ttfi438yLVK5AP5RREH
IOKY/xvk3//wFM0UbHwQiC2dV3bvv2T/sdkWopg6/dN3DBjlUGVTeM1B/wYjZeW6
YrWn3aR94IyIbCjEaDqOS0H9+rcSWYJYkh8JBiLiGH2P6aG381rNONYhCZVibekq
pd1dZ+bGGW29K8RcoTtW27FuOcSqn/wqjANviuF5dxBdGXj+OAw=
=K2Aq
-----END PGP SIGNATURE-----

--y6mtvp5pc3cshvwy--
