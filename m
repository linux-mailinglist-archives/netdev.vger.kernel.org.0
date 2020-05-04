Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DEEC1C34B9
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 10:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728263AbgEDIoW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 04:44:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726351AbgEDIoU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 04:44:20 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92464C061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 01:44:20 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jVWhx-0004Ba-Uo; Mon, 04 May 2020 10:44:13 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1jVWhw-00061L-O0; Mon, 04 May 2020 10:44:12 +0200
Date:   Mon, 4 May 2020 10:44:12 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Marek Vasut <marex@denx.de>, David Jander <david@protonic.nl>,
        devicetree@vger.kernel.org
Subject: Re: [RFC PATCH] dt-bindings: net: nxp,tja11xx: add compatible support
Message-ID: <20200504084412.juhnxip7lg2d3ct5@pengutronix.de>
References: <20200504082617.11326-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="pe24nsds5j3wiypj"
Content-Disposition: inline
In-Reply-To: <20200504082617.11326-1-o.rempel@pengutronix.de>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:26:30 up 170 days, 23:45, 184 users,  load average: 0.17, 0.11,
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


--pe24nsds5j3wiypj
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

here is first attempt to rework this binding. So far I have following
questions and/or issues:
- currently this PHY is identified by ID, not by compatible. Should it
  be probed by compatible?
  Theoretically I can use:
  	compatible =3D "nxp,tja1102", "ethernet-phy-ieee802.3-c22";

  But till now this was used only for nodes with not clear support state
  and seems to be not a welcome solution (at least till now).

- matching by node name patter seems to trigger warning by different
  (not related) bindings. What is a best practice to avoid it?

Regards,
Oleksij

On Mon, May 04, 2020 at 10:26:17AM +0200, Oleksij Rempel wrote:
> ... and correct SPDX-License-Identifier.
>=20
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  .../devicetree/bindings/net/nxp,tja11xx.yaml  | 51 ++++++++++++-------
>  1 file changed, 32 insertions(+), 19 deletions(-)
>=20
> diff --git a/Documentation/devicetree/bindings/net/nxp,tja11xx.yaml b/Doc=
umentation/devicetree/bindings/net/nxp,tja11xx.yaml
> index 42be0255512b3..e4ae8257f3258 100644
> --- a/Documentation/devicetree/bindings/net/nxp,tja11xx.yaml
> +++ b/Documentation/devicetree/bindings/net/nxp,tja11xx.yaml
> @@ -1,4 +1,4 @@
> -# SPDX-License-Identifier: GPL-2.0+
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>  %YAML 1.2
>  ---
>  $id: http://devicetree.org/schemas/net/nxp,tja11xx.yaml#
> @@ -14,25 +14,36 @@ maintainers:
>  description:
>    Bindings for NXP TJA11xx automotive PHYs
> =20
> -allOf:
> -  - $ref: ethernet-phy.yaml#
> +properties:
> +  compatible:
> +    oneOf:
> +      - items:
> +        - enum:
> +          - nxp,tja1102
> +        - const: ethernet-phy-ieee802.3-c22
> =20
> -patternProperties:
> -  "^ethernet-phy@[0-9a-f]+$":
> -    type: object
> -    description: |
> -      Some packages have multiple PHYs. Secondary PHY should be defines =
as
> -      subnode of the first (parent) PHY.
> +  $nodename:
> +    pattern: "^ethernet-phy(@[a-f0-9]+)?$"
> =20
> -    properties:
> -      reg:
> -        minimum: 0
> -        maximum: 31
> -        description:
> -          The ID number for the child PHY. Should be +1 of parent PHY.
> +  reg:
> +    minimum: 0
> +    maximum: 31
> +    description:
> +      The ID number for the child PHY. Should be +1 of parent PHY.
> =20
> -    required:
> -      - reg
> +  '#address-cells':
> +    description: number of address cells for the MDIO bus
> +    const: 1
> +
> +  '#size-cells':
> +    description: number of size cells on the MDIO bus
> +    const: 0
> +
> +required:
> +  - compatible
> +  - reg
> +  - '#address-cells'
> +  - '#size-cells'
> =20
>  examples:
>    - |
> @@ -40,8 +51,9 @@ examples:
>          #address-cells =3D <1>;
>          #size-cells =3D <0>;
> =20
> -        tja1101_phy0: ethernet-phy@4 {
> -            reg =3D <0x4>;
> +        tja1101_phy0: ethernet-phy@1 {
> +            compatible =3D "nxp,tja1101", "ethernet-phy-ieee802.3-c22";
> +            reg =3D <0x1>;
>          };
>      };
>    - |
> @@ -50,6 +62,7 @@ examples:
>          #size-cells =3D <0>;
> =20
>          tja1102_phy0: ethernet-phy@4 {
> +            compatible =3D "nxp,tja1102", "ethernet-phy-ieee802.3-c22";
>              reg =3D <0x4>;
>              #address-cells =3D <1>;
>              #size-cells =3D <0>;
> --=20
> 2.26.2
>=20
>=20

--=20
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--pe24nsds5j3wiypj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEERBNZvwSgvmcMY/T74omh9DUaUbMFAl6v1dgACgkQ4omh9DUa
UbN3bhAAmwBlKUxD8sJbC2KWRGhMPoF1krEfvmCTUqG4Dr9yrhzztnMi2j+GIhmY
JuDcR538mLieGd8iDo0BheWOShryiArR2ze4mvQxAxYYJRqGGFS3oDtBkzDA46hR
LUWfcBE/7VyCI1dNu9vhn8K1GRtqFM4vffihDeoVxwNrSCUPViWabsuF31OZRhYo
mlwRfRuz8UWj8juPwAtsRy4v5hr1cemfA3DLuN7pnvpgMpFv4bWGP9BcYI/ZVVtn
YYFLsw6uuAwC5jcnz7TzQbyPEo68axNvI77n4nKld6SKFjjBQWMsrtxbBtcAYCAL
DOykrEFJe9Mdpz8jutAfo8x6ddVj56Z6EIzsZkiG0Ajvlwurj3pGsdJZX/X8vx0B
WHX2zekiaBxSefDNqeWj84O3bzgbPo0B/lt2Jd3C/jomgn1UPyEBulc/rrQsKNMg
jUs6n9EGyNhuZMg2Q619W0fZ+I12B3GlnRUNCCP1IzGPoBed5KTmYR253pvapDG9
rK2yR9esM1Yo1HAC/oz8omxqVqJLlNNoLu2i1Qzj/MJglUd/bYGijQHtb3Z75HRM
oEnJdOqZuZKzZ8F/uWDGLdq9a6C10JJVetQEyXSK29IEM2x+DDyIY8j/lNszSKL6
2bRYu3qC6p5MauuGaKw9AeRlhVUk5fphLX0UBDBFhAQsx3OLE6s=
=2IeE
-----END PGP SIGNATURE-----

--pe24nsds5j3wiypj--
