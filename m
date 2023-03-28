Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC8C6CB96E
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 10:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232245AbjC1IbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 04:31:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230263AbjC1IbU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 04:31:20 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 082E0C7;
        Tue, 28 Mar 2023 01:31:18 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 54CDF1C0ABB; Tue, 28 Mar 2023 10:31:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ucw.cz; s=gen1;
        t=1679992277;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NZKxrePiLV6l9V0HmcTkJ0mbMEOMo46hydocfIMAsEM=;
        b=TaQUejS3XvePiDrGtbQ3Wr4dI+7/5Ann4SxcWJnc33K3QFtaE90LrCi65fNBrL6leBXaFY
        caltXj6eY/KUdYbTwcLVSYBx/D3/C+URYSLi2W8eFxu6Vapd7eDoRMlpuR0R7efR5KJ4YC
        AqrjXY8FKBXLwFGBQLqDO6nrIiTOtJg=
Date:   Tue, 28 Mar 2023 10:31:16 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Lee Jones <lee@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        John Crispin <john@phrozen.org>, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [net-next PATCH v6 16/16] arm: mvebu: dt: Add PHY LED support
 for 370-rd WAN port
Message-ID: <ZCKl1A9dZOIAdMY8@duo.ucw.cz>
References: <20230327141031.11904-1-ansuelsmth@gmail.com>
 <20230327141031.11904-17-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="M1XUwPa0tTn2VCRg"
Content-Disposition: inline
In-Reply-To: <20230327141031.11904-17-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--M1XUwPa0tTn2VCRg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon 2023-03-27 16:10:31, Christian Marangi wrote:
> From: Andrew Lunn <andrew@lunn.ch>
>=20
> The WAN port of the 370-RD has a Marvell PHY, with one LED on
> the front panel. List this LED in the device tree.

> @@ -135,6 +136,19 @@ &mdio {
>  	pinctrl-names =3D "default";
>  	phy0: ethernet-phy@0 {
>  		reg =3D <0>;
> +		leds {
> +			#address-cells =3D <1>;
> +			#size-cells =3D <0>;
> +
> +			led@0 {
> +				reg =3D <0>;
> +				label =3D "WAN";
> +				color =3D <LED_COLOR_ID_WHITE>;
> +				function =3D LED_FUNCTION_LAN;
> +				function-enumerator =3D <1>;
> +				linux,default-trigger =3D "netdev";
> +			};

/sys/class/leds/WAN is not acceptable.

Best regards,
							Pavel
--=20
People of Russia, stop Putin before his war on Ukraine escalates.

--M1XUwPa0tTn2VCRg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZCKl1AAKCRAw5/Bqldv6
8oOMAJ94SXgT/9W1NuDgolccPqIAuAiokgCgo5aEvcznB5Zg1V+9XSXaeddQA6M=
=n8Nw
-----END PGP SIGNATURE-----

--M1XUwPa0tTn2VCRg--
