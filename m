Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE32665BA77
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 06:40:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236605AbjACFko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 00:40:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbjACFkm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 00:40:42 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 513466412;
        Mon,  2 Jan 2023 21:40:41 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id d10so19432467pgm.13;
        Mon, 02 Jan 2023 21:40:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jN+3BfB0Q05wIYIEbFv5Fgn76887GAPvI8+Gga4joa4=;
        b=DCed/u9gO7Jz0n2Wz9X/g+jLg7RuSPk+j8h4lS7nGbpSmDIX+14X7P702P6WLhLG5Y
         T61lwvBeBcA96xT45JS9X7Op20C7WXAe4byegiyIBDsoF8+MheklDbVO9qJziIH55+Rq
         9LvCxpuHzP8CFco4JFwTdBdXO+9QrMRc/UZMWxorIJrRFyTSqhbHoQgaW0MVT2c16n5+
         ZQvbE3sr8rOK6+bVyH8j/JD1AAAI8hn2SVoYFZlmGg8g72sKYZAKYPg33hS95sEyCvhF
         Ywz6qk4N62sKgWmuk1HtJ35BoCO+TF5kF0fFpDdOXPtjbjReQWnolIQAAH9TAa0btvKc
         VW3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jN+3BfB0Q05wIYIEbFv5Fgn76887GAPvI8+Gga4joa4=;
        b=ghDD2CEKcVSof6tM/tmtdF33P/0/9jNroZx0I05QPcahy5Tovttuk18HRnAI8svfI2
         2O8pbfO969etsdUWxX/vntSn77AJmdIJ/m9bNFGYiQXXIapcAH8AvlUwAVo2gdofN+79
         bgXQLA5vHCA1KX6K8RS+MKcPMqL2Mulf6xpt0bzaOFpIkgFn9XmQNVjnmjnbBz2lX2bK
         Khqh2/p4G63Sl2nJmWGkDyDmYU/RKD0wXL/NP532aPZii1/QZnNt0I5/D+W3qL9H6ONi
         vB6POY9h7zv8Nt4eRj+OAoDt4nzbw737jJ29qsjH2CiVgetWa97+eqWlDbe4exHwW4+n
         2tDQ==
X-Gm-Message-State: AFqh2krTkHD1y2aRoLPbhmMp+dj+Eju3govquwKiABMV1Or3d+LyowTw
        3TaLRWH9LKDfx4HLFC8q51c=
X-Google-Smtp-Source: AMrXdXu5iRa4EjBGXQn6da6IrtNnDaunNo+42pbUSVfJLEbbQwpQ7omg0z7Xy78Pi9+15GWgFvPr7w==
X-Received: by 2002:aa7:9156:0:b0:57e:f1a2:1981 with SMTP id 22-20020aa79156000000b0057ef1a21981mr48523929pfi.8.1672724440795;
        Mon, 02 Jan 2023 21:40:40 -0800 (PST)
Received: from debian.me (subs09a-223-255-225-69.three.co.id. [223.255.225.69])
        by smtp.gmail.com with ESMTPSA id z4-20020aa79f84000000b0057ef1262347sm1221769pfr.19.2023.01.02.21.40.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Jan 2023 21:40:40 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id 2FF0C103DA2; Tue,  3 Jan 2023 12:40:35 +0700 (WIB)
Date:   Tue, 3 Jan 2023 12:40:35 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org,
        Tim Harvey <tharvey@gateworks.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
Subject: Re: [PATCH v7 01/11] leds: add support for hardware driven LEDs
Message-ID: <Y7O/0xkL78JJKxoJ@debian.me>
References: <20221214235438.30271-1-ansuelsmth@gmail.com>
 <20221214235438.30271-2-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="jZaA0sPT633nOohU"
Content-Disposition: inline
In-Reply-To: <20221214235438.30271-2-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--jZaA0sPT633nOohU
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 15, 2022 at 12:54:28AM +0100, Christian Marangi wrote:
> The LED must implement 3 main API:
> - hw_control_status(): This asks the LED driver if hardware mode is
>     enabled or not.
>     Triggers will check if the offload mode is supported and will be
>     activated accordingly. If the trigger can't run in software mode,
>     return -EOPNOTSUPP as the blinking can't be simulated by software.
> - hw_control_start(): This will simply enable the hardware mode for
>     the LED.
>     With this not declared and hw_control_status() returning true,
>     it's assumed that the LED is always in hardware mode.
> - hw_control_stop(): This will simply disable the hardware mode for
>     the LED.
>     With this not declared and hw_control_status() returning true,
>     it's assumed that the LED is always in hardware mode.
>     It's advised to the driver to put the LED in the old state but this
>     is not enforcerd and putting the LED off is also accepted.
>=20

Building htmldocs with Sphinx, I got:

Documentation/leds/leds-class.rst:190: WARNING: Unexpected indentation.
Documentation/leds/leds-class.rst:192: WARNING: Block quote ends without a =
blank line; unexpected unindent.

I have applied the fixup on the API bullet list above:

---- >8 ----

diff --git a/Documentation/leds/leds-class.rst b/Documentation/leds/leds-cl=
ass.rst
index efd2f68c46a7f9..fc16b503747800 100644
--- a/Documentation/leds/leds-class.rst
+++ b/Documentation/leds/leds-class.rst
@@ -186,13 +186,15 @@ supported. By default if a LED driver doesn't declare=
 blink_mode, SOFTWARE_CONTR
 is assumed.
=20
 The LED must implement 3 main API:
+
 - hw_control_status(): This asks the LED driver if hardware mode is enabled
-    or not. Triggers will check if the hardware mode is active and will try
-    to offload their triggers if supported by the driver.
+  or not. Triggers will check if the hardware mode is active and will try
+  to offload their triggers if supported by the driver.
 - hw_control_start(): This will simply enable the hardware mode for the LE=
D.
+
 - hw_control_stop(): This will simply disable the hardware mode for the LE=
D.
-    It's advised to the driver to put the LED in the old state but this is=
 not
-    enforcerd and putting the LED off is also accepted.
+  It's advised to the driver to put the LED in the old state but this is n=
ot
+  enforcerd and putting the LED off is also accepted.
=20
 With HARDWARE_CONTROLLED blink_mode hw_control_status/start/stop is option=
al
 and any software only trigger will reject activation as the LED supports o=
nly

Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--jZaA0sPT633nOohU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY7O/yQAKCRD2uYlJVVFO
o3RgAQCkYHCwtaqG3r2dnJIw3T0Dohj2v5xTIf9HVDrK1ULRlAEAgXCZ0LOWaTB6
mQ4clGk7id4baqPjpghCD7nv0sY9rAc=
=rGUF
-----END PGP SIGNATURE-----

--jZaA0sPT633nOohU--
