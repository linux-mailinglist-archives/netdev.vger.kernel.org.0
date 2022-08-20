Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BABF59AAD5
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 05:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239981AbiHTDIk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 23:08:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233564AbiHTDIi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 23:08:38 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0528813D61;
        Fri, 19 Aug 2022 20:08:36 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id p9so4739796pfq.13;
        Fri, 19 Aug 2022 20:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=8UAglJHMJxkOTcf2BnuldAe6AgkhGWdLKkc7swqzIfQ=;
        b=HC1Wt7vMa8hBBYpjbK4vCX9Wc+yfeTFv49qXCDRKqnwIMmJe+Sx+WPbo7tr4BCaSSy
         fSAfYBj1ij+nFGX7+GJuDMKFe6ZIdxtJalD2S2eqtviNmQehmULztfHGakn7ut7ckZbx
         RkXdby54LIg5l3sRBfhdAmWvbgVIXzzU5H8jHwu4M7Z4/zwwhrdn5bq3txl3IIuEpLO3
         rLWz4Ausci/SIRnfilFmA3H5dcbyFfSOG38qy4RVEl83G4ynJ+l07TARqnKFxToh2kxM
         l6pnfTtrFXudsUtTKYAAJShysajZZTIv2L59ip4rTq/1JOkP9uDPYzhU0uKwN+J5CM1p
         cIIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=8UAglJHMJxkOTcf2BnuldAe6AgkhGWdLKkc7swqzIfQ=;
        b=DsJe6/FYXTXmSVtXH1NmLCGpL7Kv2KkHbwFDjziA/rFbsc8P4Cd5Sxl+Ef2mA2a2bI
         Qo5AOmEZhEJ5nw3FXXHf6oj/f03geTcMng/hAUSlyP095ezal+g+7H3/eLQ1DheJ8w6y
         ZTypVB761ysiXyQNu8D/b8bxbckVDvKylzGp52PzTVg3a00oa857D3sb844PbufBM/q3
         LtV/iifkjFYZUplDY3u6UUIcHV0C9i5pYCxNIuSPPvxe1npZeTeeOqsqCXVm7vSA1l7X
         tdp3dJI9aOWKiPlRncYY49qYVvbu0Qaf0Fx7TRHMrJ2Xf76hRLw/eCie9W3ubzPQa8uV
         T1VQ==
X-Gm-Message-State: ACgBeo3FkyGutqnDvruv4TcNWk7QatAmoNfO5A4QVTCA4XhWQUJoSbyV
        LJalyVNsmFNXhPR9x/jtUxs=
X-Google-Smtp-Source: AA6agR5biOH1hFN68+X2FV+eg4bhlK9NYrr6clVZ4KX9bi9VK6HKNWoI0Pc5l+6FWU91XcCwAxD2eA==
X-Received: by 2002:a63:e906:0:b0:41b:eba0:8b6d with SMTP id i6-20020a63e906000000b0041beba08b6dmr8471072pgh.501.1660964915470;
        Fri, 19 Aug 2022 20:08:35 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-69.three.co.id. [180.214.232.69])
        by smtp.gmail.com with ESMTPSA id d2-20020a170902cec200b0016c5306917fsm3910435plg.53.2022.08.19.20.08.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Aug 2022 20:08:34 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 8BF9F102B2F; Sat, 20 Aug 2022 10:08:31 +0700 (WIB)
Date:   Sat, 20 Aug 2022 10:08:31 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        David Jander <david@protonic.nl>
Subject: Re: [PATCH net-next v1 7/7] ethtool: add interface to interact with
 Ethernet Power Equipment
Message-ID: <YwBQL7zxJjJSx8TC@debian.me>
References: <20220819120109.3857571-1-o.rempel@pengutronix.de>
 <20220819120109.3857571-8-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="PVHpDvkI+W+zf0ua"
Content-Disposition: inline
In-Reply-To: <20220819120109.3857571-8-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--PVHpDvkI+W+zf0ua
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 19, 2022 at 02:01:09PM +0200, Oleksij Rempel wrote:
> +Kernel response contents:
> +
> +  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D  =3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +  ``ETHTOOL_A_PSE_HEADER``                nested  reply header
> +  ``ETHTOOL_A_PODL_PSE_ADMIN_STATE``          u8  Operational state of t=
he PoDL
> +                                                  PSE functions
> +  ``ETHTOOL_A_PODL_PSE_PW_D_STATUS``          u8  power detection status=
 of the
> +                                                  PoDL PSE.
> +  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D  =3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +

I don't see malformed table warnings on my htmldocs build, although the
table border for the third column is not long enough to cover the
contents.

> +Request contents:
> +
> +  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D  =3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +  ``ETHTOOL_A_PSE_HEADER``                nested  request header
> +  ``ETHTOOL_A_PODL_PSE_ADMIN_CONTROL``        u8  Control PoDL PSE Admin=
 state
> +  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D  =3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +

Same here too.

In that case, I'd like to extend the border, like:

---- >8 ----

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/n=
etworking/ethtool-netlink.rst
index c8b09b57bd65ea..2560cf62d14f4e 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -1641,13 +1641,13 @@ Request contents:
=20
 Kernel response contents:
=20
-  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D  =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D  =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
   ``ETHTOOL_A_PSE_HEADER``                nested  reply header
   ``ETHTOOL_A_PODL_PSE_ADMIN_STATE``          u8  Operational state of the=
 PoDL
                                                   PSE functions
   ``ETHTOOL_A_PODL_PSE_PW_D_STATUS``          u8  power detection status o=
f the
                                                   PoDL PSE.
-  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D  =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D  =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
=20
 The ``ETHTOOL_A_PODL_PSE_ADMIN_STATE`` identifies the operational state of=
 the
 PoDL PSE functions.  The operational state of the PSE function can be chan=
ged
@@ -1673,10 +1673,10 @@ Sets PSE parameters.
=20
 Request contents:
=20
-  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D  =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D  =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
   ``ETHTOOL_A_PSE_HEADER``                nested  request header
   ``ETHTOOL_A_PODL_PSE_ADMIN_CONTROL``        u8  Control PoDL PSE Admin s=
tate
-  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D  =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D  =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
 When set, the optional ``ETHTOOL_A_PODL_PSE_ADMIN_CONTROL`` attribute is u=
sed
 to control PoDL PSE Admin functions. This option is implementing

Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--PVHpDvkI+W+zf0ua
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCYwBQKgAKCRD2uYlJVVFO
oy9/AQDwEH8Bz8WqHqwb641FcoN5aZY4DkOzXgMivWpQ5FhSIAD+J2xBRwk9/A/4
B3CIxXOZo6mTgh0cQALvIAKmZVH8OgE=
=iJp9
-----END PGP SIGNATURE-----

--PVHpDvkI+W+zf0ua--
