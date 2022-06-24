Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2935A559E8F
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 18:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbiFXQaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 12:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiFXQaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 12:30:01 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73E3350B28;
        Fri, 24 Jun 2022 09:29:59 -0700 (PDT)
Received: from mercury (dyndsl-091-096-058-064.ewe-ip-backbone.de [91.96.58.64])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: sre)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 0F4F766015BE;
        Fri, 24 Jun 2022 17:29:58 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1656088198;
        bh=QaZgt42tcSM2fIouYrWXNxa2OrSqSnqokF2/KLwky50=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Qiv+kxQbbdqrUrq/M0DDu4aVsPQI0h4JQ/0pmqqaZY6PXtJT8fHXfZqJA1sYjDCAj
         ytMUpOoSe3CMuM3dyiLuyjhCUHcA1LxthDXOwDGKJ+CBucs0JhsyLf4b3RBRWTMGwo
         bsHyuG2HSe4hC1HPgP0u4mAwi4UaWrPEjr0MEcPMlRB4qUOxmTu2Ie8rCZk/P5MUO6
         Hvnz8b/XCgt7uU37G+P9wgS7+1RuOjaTw5qb+9uRrKvVK/5qOO4ZF87eAXtiSPIWE7
         zZpdYnbzLRXsoMnmQe87i3VTM4BN80JIkqnCyEE5BaRgwffW7CA4zE8r47TLLZP/F3
         F2xr0ajdMm1pw==
Received: by mercury (Postfix, from userid 1000)
        id 2B511106042E; Fri, 24 Jun 2022 18:29:56 +0200 (CEST)
Date:   Fri, 24 Jun 2022 18:29:56 +0200
From:   Sebastian Reichel <sebastian.reichel@collabora.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        netdev@vger.kernel.org, linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        David Wu <david.wu@rock-chips.com>, kernel@collabora.com
Subject: Re: [PATCH 1/3] net: ethernet: stmmac: dwmac-rk: Disable delayline
 if it is invalid
Message-ID: <20220624162956.vn4b3va5cz2agvrb@mercury.elektranox.org>
References: <20220623162850.245608-1-sebastian.reichel@collabora.com>
 <20220623162850.245608-2-sebastian.reichel@collabora.com>
 <YrWdnQKVbJR+NrfH@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="krkh3w4k7yaexdpq"
Content-Disposition: inline
In-Reply-To: <YrWdnQKVbJR+NrfH@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--krkh3w4k7yaexdpq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jun 24, 2022 at 01:18:53PM +0200, Andrew Lunn wrote:
> > @@ -1422,7 +1420,7 @@ static struct rk_priv_data *rk_gmac_setup(struct =
platform_device *pdev,
> > =20
> >  	ret =3D of_property_read_u32(dev->of_node, "tx_delay", &value);
> >  	if (ret) {
> > -		bsp_priv->tx_delay =3D 0x30;
> > +		bsp_priv->tx_delay =3D -1;
> >  		dev_err(dev, "Can not read property: tx_delay.");
> >  		dev_err(dev, "set tx_delay to 0x%x\n",
> >  			bsp_priv->tx_delay);
> > @@ -1433,7 +1431,7 @@ static struct rk_priv_data *rk_gmac_setup(struct =
platform_device *pdev,
> > =20
> >  	ret =3D of_property_read_u32(dev->of_node, "rx_delay", &value);
> >  	if (ret) {
> > -		bsp_priv->rx_delay =3D 0x10;
> > +		bsp_priv->rx_delay =3D -1;
> >  		dev_err(dev, "Can not read property: rx_delay.");
> >  		dev_err(dev, "set rx_delay to 0x%x\n",
> >  			bsp_priv->rx_delay);
>=20
> rockchip-dwmac.yaml says:
>=20
>   tx_delay:
>     description: Delay value for TXD timing. Range value is 0~0x7F, 0x30 =
as default.
>     $ref: /schemas/types.yaml#/definitions/uint32
>=20
>   rx_delay:
>     description: Delay value for RXD timing. Range value is 0~0x7F, 0x10 =
as default.
>     $ref: /schemas/types.yaml#/definitions/uint32
>=20
> So it seems to me you are changing the documented default. You cannot
> do that, this is ABI.

Right. I suppose we either need a disable value or an extra property. I
can add support for supplying (-1) from DT. Does that sounds ok to
everyone?

-- Sebastian

--krkh3w4k7yaexdpq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAmK15nwACgkQ2O7X88g7
+pr+qw/+JpJa43HzJHt/hrukXcmtZfUWULGhdkYRYtbo54ubIWzsMeO4WJD9Afoz
GTW7pNQRemEIZlmZEUAn132ly8To/vAMgu/fY+ii1zF171hTDNd19u0RWf8qsgtl
3T7towNEiPz3WZ10n/Lec7qs1lumA48z6/Q2z8wcnvUDlm9EAt82akuyN8nBU203
901LZcUqjumHVgFKR3jOm5tuyQXduCMadb3wdz6GCXq+5gxA9yrqazUxul05hrEE
mkUzC/JngGgnOPG6gq5i7RvET7a7yi+P2kJTuNuSTpsRO6XfukNigNHA7TImAppE
cFTt3Bp9K1sgPq099xDF2kx5Io2fVG8xh967v9Igi7qDHuhKwyStpp8aUm/+zJf6
TAAqltc3Bx6ZDaXShSpvrYOLychQ2l2CSRvGkhtKRtv/SMq1k2du2O/YDmoXnw5E
4EYq5sKuJkGHDZvCBqTjZhd9Qkit7xAVFM4YBdMcmaZG2ZWxyymsD6Y6dYB567v1
1DNzESQYdHeTosolkY6wtu07xOMIiScGIayQr64SffpqImIeli6bVKUtTQexXtDU
JXDdc4hpfqXcMn/e/VQg7k40r9fPAxv11Ay6SXumPHSTCzzv7zQNADk1SdV6t3pI
HTI9XwszIM3gKhjVsjgdbBg43LZM3wlfB/Fcral/BwhLde8D0JQ=
=HpvX
-----END PGP SIGNATURE-----

--krkh3w4k7yaexdpq--
