Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93D355E59A8
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 05:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbiIVDgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 23:36:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiIVDgc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 23:36:32 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E81E4AA4C9;
        Wed, 21 Sep 2022 20:36:31 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id iw17so7631918plb.0;
        Wed, 21 Sep 2022 20:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=DRlr4S0CdSPmGIBpEz7/6qWP3xmZ7dHXhNXq25Lelfo=;
        b=E8w9Ju0b579ywPoHP7Rh6tU35JZG2Qi3xWsB7kZR+rLcQDWp1cM08sw1D5lrLNnw3F
         YZa77V4Ru6jOaVZUzKlIWepuQ0BjuGI6QGKoGj7QiNHjkM7SA+IsG1NIZv1g98CqDjmY
         04tsTMoMcEMmJYkjqBT98Muat5eD1flAZiiANuDFLMLFIoHWy9Or0AEt/TL8Z4qRYI2t
         5rbU/0sM6hP5OPyUhZGBcNQFZoy4tGZiPOhHZEKYd/tIPOJ6Ti2I5xGPmDyk1yJelmXU
         SQHPKazmoTv2/ta3pLUDKjw94Je2CllGIojgS/7CgGOZA5Hwa/FiUGhRrjyekbhGAbrx
         5c0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=DRlr4S0CdSPmGIBpEz7/6qWP3xmZ7dHXhNXq25Lelfo=;
        b=iVEJrJ/FXdc/xRaKFtSb/kmrxsksRAVISy2d5dqNEuLuCuS3OuWmujsJpQTnxtFcZP
         v0luW7M/d/Sapgc6QfdTfSzf1oKmAnybpElRUC1fWhKGx6lHIb6c1gfMhIQXntglwiXP
         yu/n+h0f56EpOxB7oNu8i7jDiYsweK/WKJpyoEqmHtzkWmH2f8hn564dcuIViFl+re6N
         cXu2eg04jucJv1VWD/fk3q3PjZU1oQs9DT++41+u9rFWGQOSWp4iGE5wfaqIXohdYhH3
         uJ3KpMdEHcXet4ghVMnEgN9pvkYfTKoBglNnK7m1VwFGboeriwlZd6Mfgbldltb8DG/C
         PbKw==
X-Gm-Message-State: ACrzQf3f4fAw0BcWjeBrWFeX61ncorb1ZRi5e+8/i8Yzimj7Gen11g6i
        z9uGpnz7mEWZo0ElxKB6qtc=
X-Google-Smtp-Source: AMsMyM5v5jKc5k7ipnnOiIapTlVN0RgxK4J/JwooeGbdFgmOPw6vHGvS3h3FuG317NAUBGe0NQGmSg==
X-Received: by 2002:a17:903:1110:b0:178:9f67:b524 with SMTP id n16-20020a170903111000b001789f67b524mr1411691plh.50.1663817791390;
        Wed, 21 Sep 2022 20:36:31 -0700 (PDT)
Received: from debian.me (subs28-116-206-12-54.three.co.id. [116.206.12.54])
        by smtp.gmail.com with ESMTPSA id m14-20020a170902db0e00b00172fad607b3sm2800814plx.207.2022.09.21.20.36.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 20:36:30 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id E222C102CFC; Thu, 22 Sep 2022 10:36:25 +0700 (WIB)
Date:   Thu, 22 Sep 2022 10:36:25 +0700
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
        Jonathan Corbet <corbet@lwn.net>,
        kernel test robot <lkp@intel.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        David Jander <david@protonic.nl>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: Re: [PATCH net-next v6 5/7] ethtool: add interface to interact with
 Ethernet Power Equipment
Message-ID: <YyvYOcfrur2mQXGl@debian.me>
References: <20220921124748.73495-1-o.rempel@pengutronix.de>
 <20220921124748.73495-6-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="MTrYSV5QHljcKwmR"
Content-Disposition: inline
In-Reply-To: <20220921124748.73495-6-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--MTrYSV5QHljcKwmR
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 21, 2022 at 02:47:45PM +0200, Oleksij Rempel wrote:
> +PSE_GET
> +=3D=3D=3D=3D=3D=3D=3D
> +
> +Gets PSE attributes.
> +
> +Request contents:
> +
> +  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D  =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +  ``ETHTOOL_A_PSE_HEADER``               nested  request header
> +  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D  =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Kernel response contents:
> +
> +  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D  =3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> +  ``ETHTOOL_A_PSE_HEADER``                nested  reply header
> +  ``ETHTOOL_A_PODL_PSE_ADMIN_STATE``         u32  Operational state of t=
he PoDL
> +                                                  PSE functions
> +  ``ETHTOOL_A_PODL_PSE_PW_D_STATUS``         u32  power detection status=
 of the
> +                                                  PoDL PSE.
> +  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D  =3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> +
> +When set, the optional ``ETHTOOL_A_PODL_PSE_ADMIN_STATE`` attribute iden=
tifies
> +the operational state of the PoDL PSE functions.  The operational state =
of the
> +PSE function can be changed using the ``ETHTOOL_A_PODL_PSE_ADMIN_CONTROL=
``
> +action. This option is corresponding to IEEE 802.3-2018 30.15.1.1.2
> +aPoDLPSEAdminState. Possible values are:

The IEEE 802.3-2018 keyword name can be enclosed within inline code block.

> +When set, the optional ``ETHTOOL_A_PODL_PSE_PW_D_STATUS`` attribute iden=
tifies
> +the power detection status of the PoDL PSE.  The status depend on intern=
al PSE
> +state machine and automatic PD classification support. This option is
> +corresponding to IEEE 802.3-2018 30.15.1.1.3 aPoDLPSEPowerDetectionStatu=
s.

Same here.

> +When set, the optional ``ETHTOOL_A_PODL_PSE_ADMIN_CONTROL`` attribute is=
 used
> +to control PoDL PSE Admin functions. This option is implementing
> +IEEE 802.3-2018 30.15.1.2.1 acPoDLPSEAdminControl. See

Same here too.

Otherwise LGTM.

Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--MTrYSV5QHljcKwmR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCYyvYNAAKCRD2uYlJVVFO
o+8FAP4zK3UmIUdOQH+lNRAv2FK50AeVwbm1AMvGvBlNmvUuMQD/dfXyj23GsJk9
OY1S/EdG8ybdI9p0U3BXMpirdVdCuAs=
=B+4n
-----END PGP SIGNATURE-----

--MTrYSV5QHljcKwmR--
