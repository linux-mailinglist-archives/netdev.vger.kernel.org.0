Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9C8046B5E7
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 09:26:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233057AbhLGIaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 03:30:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232950AbhLGI3g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 03:29:36 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D872C0698C0;
        Tue,  7 Dec 2021 00:26:06 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id d72-20020a1c1d4b000000b00331140f3dc8so1615024wmd.1;
        Tue, 07 Dec 2021 00:26:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8tokgnK1cajfiXWYHRJjTHCytOBJLcV3N0GKQrU0ksQ=;
        b=jddsDhLYDw2hsFDYeltGAG/vU/Am4BIydN1ajF13bfXeetYztxTMYqL4D7FcMqLk6X
         KQK2JP2u5qDwGxHGOfvQHCsZKuMBqQKdvRAg7HXbncolRwbKkCpHxxtYAAp+zX/IfbsG
         o33nB8E+HXEsPXxbtomFJRE4QWis9cdfidwHfNJa8l4sCmlsIuYnG3AOoURmQyezFYtM
         zq6HmsiO2OEke2Bp7bJqBcjyAxoTBvps/GKVHw9C1Kl74dClADxHqCHL/unVFZhjBNXV
         QD3Sh8JGLEHcx222BX7lfTCGJbZSXbOUkDrIciGh9BVyVTMWS2pvttZcTkJnEw9t7dcM
         zIpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8tokgnK1cajfiXWYHRJjTHCytOBJLcV3N0GKQrU0ksQ=;
        b=XOsZLbnu2k7XxNcsXz4sC9zWB/zRaFftVss3grBU36JsQOynrBz8Ney8gk+KWxycp3
         Gk7aHI7YPISpD1rpn2eGZmdDB+cCltlYoGWxVVYCfMlW59ZxrVNcjC2jQ9aThUDhcj2I
         +mTCH/N0NmpSOgXDv6rLkTJkxOK4VK3JyauxSeYb96emlVqUr24t5lC4C8zUFaKNwY/o
         MkyxWEn1qJ8Bvl016GLChiK9ObEIbBLtRU/Nw+xE8hCoFAuVFaRdkyJNodk2ZPqtBC+V
         8Cxdphf81mymxJgI9cxKS6djSbS9weejtm9Yx8fBGhMoHPYdsBhAIHrQNLBZxlfynq/g
         TqsQ==
X-Gm-Message-State: AOAM532qhsSKKZ0y6gYQD9ronQxz2NJsL1pCGE3tfc8TKDakEDN5pnPw
        l/SoaqyRa9h/QNFVZpSwB6BabQjzWvuQaQ==
X-Google-Smtp-Source: ABdhPJzK+dvWyq361qOtw0ZMg6FfM3s5b7uSbCAdhgL3bJXbBoaepTkRAafPjpSZK6z1W8j1/Eg1yA==
X-Received: by 2002:a05:600c:202:: with SMTP id 2mr4969500wmi.167.1638865564981;
        Tue, 07 Dec 2021 00:26:04 -0800 (PST)
Received: from orome.fritz.box ([193.209.96.43])
        by smtp.gmail.com with ESMTPSA id j134sm1901493wmj.3.2021.12.07.00.26.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 00:26:04 -0800 (PST)
Date:   Tue, 7 Dec 2021 09:26:01 +0100
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Rob Herring <robh@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: net: mdio: Allow any child node name
Message-ID: <Ya8amQ7eADPmaHF8@orome.fritz.box>
References: <20211206174139.2296497-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mcN1+O8mIgM0g1ad"
Content-Disposition: inline
In-Reply-To: <20211206174139.2296497-1-robh@kernel.org>
User-Agent: Mutt/2.1.3 (987dde4c) (2021-09-10)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--mcN1+O8mIgM0g1ad
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 06, 2021 at 11:41:39AM -0600, Rob Herring wrote:
> An MDIO bus can have devices other than ethernet PHYs on it, so it
> should allow for any node name rather than just 'ethernet-phy'.
>=20
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>  Documentation/devicetree/bindings/net/mdio.yaml | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Makes sense,

Reviewed-by: Thierry Reding <treding@nvidia.com>

--mcN1+O8mIgM0g1ad
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmGvGpkACgkQ3SOs138+
s6ExOw/7BA9xY/3EA2U3i3/zTrkeGHe+6RAY+w0my3wL7XeH0veXNBVp/fD5XE7M
dPlsnAOmXGArfwYBWFACK1lVri51lzzpcRWJqqi3rek1/PAAyr3Et48VpfeGjixp
YauQLA6K8Bgwnk+q6ME7jMbluJcTA9o4p3gCT+12fB8aIwJlA2j6gZ+NUceNqxgT
xQBpCxYITfefw7Lc+PLevksEHLA/O8IwdPtKerZ7cRpORtfTOerLv/Bph0Zn+Du8
0sDAMxMwjYT/C55RcRJgNzcPfrbE6rXYbtLQY+lnUWi71GFzdQilhArNNzHRTJ9e
RoB4+oNkpDNYwMMc6+iZ4+z6SHjne2EibjgLSMTBrm9uxltx58hMBjewrSENLqen
T1GKfL4jIYnnYd3IZIPt+FlKfhNF+A+XI4qbzJln7+8c+SDA29fn4Ah2DrqnBEk0
7puZmztaIgjC782UDgTIWVoNXt1lZqWaKtc8YWAXnxS3cuQ6Y2vCQENIK1dTq88I
69ekgPLM1wjpDQE42k0Dlp/A53h70A1pDsV/+QqeRmgWqNiBCQzWh4rGMGIYDP5U
W7h1ALvLPNvIhErLSygPgbrc/XM6aNG1wIbKSKR1ui8Ey8+1xeNsWyPPfivubAvJ
w2gUcJ9EYFxkW8MJ/T03nTLRcn4QK0VOAiU7oXZtI9RTJJCklWI=
=Jmw8
-----END PGP SIGNATURE-----

--mcN1+O8mIgM0g1ad--
