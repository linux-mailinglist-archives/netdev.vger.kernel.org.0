Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4A4346B60F
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 09:33:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232989AbhLGIhU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 03:37:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231997AbhLGIhT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 03:37:19 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6B71C061746;
        Tue,  7 Dec 2021 00:33:49 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id i5so27868797wrb.2;
        Tue, 07 Dec 2021 00:33:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5w7GJDcAWufEOgwRxxDKQLdJYteK1rDYzUGs71X/NGY=;
        b=AMkLgOPZO03DJEz3tdJo6JpQ9IuUJXONLDsX19CMNOVfJx7gPLKrU7SrYrpY3Eb7bw
         o52Jvv+6LlkQgatItp9J+ki3oyzN8WgzZ2MmqbC8fg2ap/SLlmUmJcNXLjel64vWKsHK
         y7Pfr39wNkrtQu+JKG3M9bDu/sORmwluqLhLN2ewCiw3q2eyOaqT84/PAzHvkBk5Bi29
         piz9ol2mOvYoJkC7/QcPjlnrHjAHsYfVRFHkiJ8RJsmw57vkh15fP5i674j4SnZx9YRB
         FX51hNGKfoRH80wIiKfyPDGvsxy4uLOPFi84eurytYejSoruwQbtjY1LOOPTcSZNNdVQ
         IxeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5w7GJDcAWufEOgwRxxDKQLdJYteK1rDYzUGs71X/NGY=;
        b=F/F2GXFeLpQe4oYa+h08ZfJvSe1gweKydTBombBZbj05B0OKxr34NuA+f351nZP6ij
         YRhEXsHM6clx/yVHnUsmHU3Cgu9xJWFpg+Xh6cu1kSh8u49xLK4Rw862nC8VVli284fx
         QLIYsP8mF1wSTQhL0XICmC3NVmXQL4GLBkpFSC35LE9Wn3XHy691oPkMPpqOd2UaF14v
         2nJrgMxpFxwDL15IuuDVNz3dm4RjftTEzzYw4n2mlHeRumKrkhBRawM3EgGYosYvn+7Z
         0xjUSN8jLr3cVHFNQuwfPl7zmSuZExuY5ej0N0zZdF2Hn0oZ+pUaAYowMlR223gPupCb
         wimw==
X-Gm-Message-State: AOAM530yfO5e5pcy55+oCnEMnjS8GAP6J1Ocauf+bvfT1/qA5sKNEGq2
        L7LALZhImu9CTIoqEjwsPTU=
X-Google-Smtp-Source: ABdhPJz7Lwdj7tU0pXaU19+1uN5CbY2adjHOZl8nh90hv/58XxNJ6ZL3j4RRIhHgIfiJ3mk87Gcfqw==
X-Received: by 2002:a5d:584c:: with SMTP id i12mr48899153wrf.95.1638866028372;
        Tue, 07 Dec 2021 00:33:48 -0800 (PST)
Received: from orome.fritz.box ([193.209.96.43])
        by smtp.gmail.com with ESMTPSA id d6sm14060823wrn.53.2021.12.07.00.33.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 00:33:47 -0800 (PST)
Date:   Tue, 7 Dec 2021 09:33:43 +0100
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Rob Herring <robh@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andreas =?utf-8?Q?F=C3=A4rber?= <afaerber@suse.de>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>,
        Cristian Ciocaltea <cristian.ciocaltea@gmail.com>,
        "G. Jaya Kumaran" <vineetha.g.jaya.kumaran@intel.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Christophe Roullier <christophe.roullier@foss.st.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-actions@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: net: Add missing properties used in examples
Message-ID: <Ya8cZ69WGfeh0G4I@orome.fritz.box>
References: <20211206174153.2296977-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jliEij1nEk5boU2d"
Content-Disposition: inline
In-Reply-To: <20211206174153.2296977-1-robh@kernel.org>
User-Agent: Mutt/2.1.3 (987dde4c) (2021-09-10)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--jliEij1nEk5boU2d
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 06, 2021 at 11:41:52AM -0600, Rob Herring wrote:
> With 'unevaluatedProperties' support implemented, the following warnings
> are generated in the net bindings:
>=20
> Documentation/devicetree/bindings/net/actions,owl-emac.example.dt.yaml: e=
thernet@b0310000: Unevaluated properties are not allowed ('mdio' was unexpe=
cted)
> Documentation/devicetree/bindings/net/intel,dwmac-plat.example.dt.yaml: e=
thernet@3a000000: Unevaluated properties are not allowed ('snps,pbl', 'mdio=
0' were unexpected)
> Documentation/devicetree/bindings/net/qca,ar71xx.example.dt.yaml: etherne=
t@19000000: Unevaluated properties are not allowed ('qca,ethcfg' was unexpe=
cted)
> Documentation/devicetree/bindings/net/qca,ar71xx.example.dt.yaml: etherne=
t@1a000000: Unevaluated properties are not allowed ('mdio' was unexpected)
> Documentation/devicetree/bindings/net/stm32-dwmac.example.dt.yaml: ethern=
et@40028000: Unevaluated properties are not allowed ('reg-names', 'snps,pbl=
' were unexpected)
> Documentation/devicetree/bindings/net/ti,cpsw-switch.example.dt.yaml: mdi=
o@1000: Unevaluated properties are not allowed ('clocks', 'clock-names' wer=
e unexpected)
> Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.example.dt.ya=
ml: mdio@f00: Unevaluated properties are not allowed ('clocks', 'clock-name=
s' were unexpected)
>=20
> Add the missing properties/nodes as necessary.
>=20
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: "Andreas F=C3=A4rber" <afaerber@suse.de>
> Cc: Manivannan Sadhasivam <mani@kernel.org>
> Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
> Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
> Cc: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
> Cc: Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
> Cc: "G. Jaya Kumaran" <vineetha.g.jaya.kumaran@intel.com>
> Cc: Oleksij Rempel <o.rempel@pengutronix.de>
> Cc: Christophe Roullier <christophe.roullier@foss.st.com>
> Cc: Grygorii Strashko <grygorii.strashko@ti.com>
> Cc: netdev@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-actions@lists.infradead.org
> Cc: linux-stm32@st-md-mailman.stormreply.com
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>  .../devicetree/bindings/net/actions,owl-emac.yaml          | 3 +++
>  .../devicetree/bindings/net/intel,dwmac-plat.yaml          | 2 +-
>  Documentation/devicetree/bindings/net/qca,ar71xx.yaml      | 5 ++++-
>  Documentation/devicetree/bindings/net/stm32-dwmac.yaml     | 6 ++++++
>  Documentation/devicetree/bindings/net/ti,davinci-mdio.yaml | 7 +++++++
>  .../devicetree/bindings/net/toshiba,visconti-dwmac.yaml    | 5 ++++-
>  6 files changed, 25 insertions(+), 3 deletions(-)
>=20
> diff --git a/Documentation/devicetree/bindings/net/actions,owl-emac.yaml =
b/Documentation/devicetree/bindings/net/actions,owl-emac.yaml
> index 1626e0a821b0..e9c0d6360e74 100644
> --- a/Documentation/devicetree/bindings/net/actions,owl-emac.yaml
> +++ b/Documentation/devicetree/bindings/net/actions,owl-emac.yaml
> @@ -51,6 +51,9 @@ properties:
>      description:
>        Phandle to the device containing custom config.
> =20
> +  mdio:
> +    type: object

In one of the conversions I've been working on, I've used this construct
for the mdio node:

	mdio:
	  $ref: mdio.yaml

In the cases here this may not be necessary because we could also match
on the compatible string, but for the example that I've been working on
there is no compatible string for the MDIO bus, so that's not an option.

On the other hand, it looks like the snps,dwmac-mdio that the examples
here use don't end up including mdio.yaml, so no validation (or rather
only very limited validation) will be performed on their properties and
children.

Thierry

> +
>  required:
>    - compatible
>    - reg
> diff --git a/Documentation/devicetree/bindings/net/intel,dwmac-plat.yaml =
b/Documentation/devicetree/bindings/net/intel,dwmac-plat.yaml
> index 08a3f1f6aea2..52a7fa4f49a4 100644
> --- a/Documentation/devicetree/bindings/net/intel,dwmac-plat.yaml
> +++ b/Documentation/devicetree/bindings/net/intel,dwmac-plat.yaml
> @@ -117,7 +117,7 @@ examples:
>          snps,mtl-tx-config =3D <&mtl_tx_setup>;
>          snps,tso;
> =20
> -        mdio0 {
> +        mdio {
>              #address-cells =3D <1>;
>              #size-cells =3D <0>;
>              compatible =3D "snps,dwmac-mdio";
> diff --git a/Documentation/devicetree/bindings/net/qca,ar71xx.yaml b/Docu=
mentation/devicetree/bindings/net/qca,ar71xx.yaml
> index cf4d35edaa1b..f2bf1094d887 100644
> --- a/Documentation/devicetree/bindings/net/qca,ar71xx.yaml
> +++ b/Documentation/devicetree/bindings/net/qca,ar71xx.yaml
> @@ -62,6 +62,10 @@ properties:
>        - const: mac
>        - const: mdio
> =20
> +
> +  mdio:
> +    type: object
> +
>  required:
>    - compatible
>    - reg
> @@ -85,7 +89,6 @@ examples:
>          reset-names =3D "mac", "mdio";
>          clocks =3D <&pll 1>, <&pll 2>;
>          clock-names =3D "eth", "mdio";
> -        qca,ethcfg =3D <&ethcfg>;
>          phy-mode =3D "mii";
>          phy-handle =3D <&phy_port4>;
>      };
> diff --git a/Documentation/devicetree/bindings/net/stm32-dwmac.yaml b/Doc=
umentation/devicetree/bindings/net/stm32-dwmac.yaml
> index 577f4e284425..86632e9d987e 100644
> --- a/Documentation/devicetree/bindings/net/stm32-dwmac.yaml
> +++ b/Documentation/devicetree/bindings/net/stm32-dwmac.yaml
> @@ -44,6 +44,12 @@ properties:
>                - st,stm32-dwmac
>            - const: snps,dwmac-3.50a
> =20
> +  reg: true
> +
> +  reg-names:
> +    items:
> +      - const: stmmaceth
> +
>    clocks:
>      minItems: 3
>      items:
> diff --git a/Documentation/devicetree/bindings/net/ti,davinci-mdio.yaml b=
/Documentation/devicetree/bindings/net/ti,davinci-mdio.yaml
> index 5728fe23f530..dbfca5ee9139 100644
> --- a/Documentation/devicetree/bindings/net/ti,davinci-mdio.yaml
> +++ b/Documentation/devicetree/bindings/net/ti,davinci-mdio.yaml
> @@ -37,6 +37,13 @@ properties:
>      maximum: 2500000
>      description: MDIO Bus frequency
> =20
> +  clocks:
> +    maxItems: 1
> +
> +  clock-names:
> +    items:
> +      - const: fck
> +
>    ti,hwmods:
>      description: TI hwmod name
>      deprecated: true
> diff --git a/Documentation/devicetree/bindings/net/toshiba,visconti-dwmac=
=2Eyaml b/Documentation/devicetree/bindings/net/toshiba,visconti-dwmac.yaml
> index 59724d18e6f3..f5bec97460e4 100644
> --- a/Documentation/devicetree/bindings/net/toshiba,visconti-dwmac.yaml
> +++ b/Documentation/devicetree/bindings/net/toshiba,visconti-dwmac.yaml
> @@ -42,6 +42,9 @@ properties:
>        - const: stmmaceth
>        - const: phy_ref_clk
> =20
> +  mdio:
> +    type: object
> +
>  required:
>    - compatible
>    - reg
> @@ -71,7 +74,7 @@ examples:
>              phy-mode =3D "rgmii-id";
>              phy-handle =3D <&phy0>;
> =20
> -            mdio0 {
> +            mdio {
>                  #address-cells =3D <0x1>;
>                  #size-cells =3D <0x0>;
>                  compatible =3D "snps,dwmac-mdio";
> --=20
> 2.32.0
>=20

--jliEij1nEk5boU2d
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmGvHGcACgkQ3SOs138+
s6H8Jw//WclnebfLzRqSdyWulOD0fPLCDtxwQKijio6FvjU/kOTbOzrCNOPLASCb
yZVH0hUXMr5h8Rk5BvFp+3SnEZu5zuunMz5MiySM1BU+26yxYM9vePeaz8ke3Lo5
Ar+85QXegvpsqTXQkLTH9XeA2lUftnnM47p/ZGE4zKhGnwItgQGxL3z7KNalN/eM
I8m75rVPcwhpcw261o5Ffuc4FhQjKR0FQOkFVZQNRmMx8t/JAtFzEPjAV9DNwn49
J2hMx4G3acBTCsa7Hnmjp3G1v4+6EffmCCDoe9w6+LOCVMoEks+QKa5ZdIaeVKhP
ZrAswWo1a/pa22WHnDSrfZbr7IRBHVpTGXJurBFYwfXQxAdUR1RcGyNb9QHrMPHZ
DhPR36xMEdmRTJ/6E4xHE0hh0XRjUDthKKAvGHdOVONpNUzFs8eJ4tsMmE2Y/2qM
wL6IgNBN2p4UK0WwE/GH0MfF41eTaMShlZKl+lDd49BXRlG8h38uQRRMnGvtjc6r
OdW3YQPbjDAcV0Dp174DFKyWH00lslf5DbiGsctxlj52THJn7/yIwBGSI66TNZAo
B3T8miFX+rTLdJ8SuviR3mbEynf0AtJBy5P1dUZP9Ux2I21+eop4fT7m4ol8vsUW
vz5PLqWt0xB/ukD1TioMEdY0Yhdv+4kajo7Qlb+FQOQvLkbTiHM=
=dwOt
-----END PGP SIGNATURE-----

--jliEij1nEk5boU2d--
