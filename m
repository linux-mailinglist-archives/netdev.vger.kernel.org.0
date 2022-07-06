Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFC96569392
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 22:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234077AbiGFUtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 16:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233932AbiGFUtQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 16:49:16 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F44518E0C;
        Wed,  6 Jul 2022 13:49:14 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id f190so9483242wma.5;
        Wed, 06 Jul 2022 13:49:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=lYoHz1Fg/1584iuxLfGRJUV0pVNLLTo+tRGLocQgAic=;
        b=qF8n+bThr2rOi+TwTlYMeusIZZd1KAnaLyxdzTUupEPeEY0phpAZ/8+ni3fZickV51
         LTf7TRAoVFadi4at5hjXEczDzbM+ilUpJEc/ujyex1l/GE9LkBLHiEK5ZSLL1mOLJtTT
         SLoXq020YES3i0PyUjWQaPfyF3ZvZgLWFfg8+bVPLWOvHNe0styrmiWMJ2fQSIrlOSNN
         gq6NjEmDwIaT6jidSInI9WScXjtoEihruq6Ycmwr9OY4ryirsovUo0kMX6ZXiLceXqMU
         7CIiPKqKJjALnFpvwQKI2bxsIl9b/KKPJTACdcuBWziomlX7p4+2y8zdQJKyVAZVU+cx
         Sg1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=lYoHz1Fg/1584iuxLfGRJUV0pVNLLTo+tRGLocQgAic=;
        b=43gMfI/aRd29lL+3KuE5Xvm1A+M+t8LNsG58hMXmm0aD7ZTJ7O69y/zPbiGWweILX2
         vl5H03B8Ukd50I+GQG/IxU5hy7Y/qoFByf0dkqsGDBsk/5oirUJYVK5t0e63YjbX36Ll
         Jpsu4kaFTSX1hN+Hh6OAFuRb/8IEnjpn4yra2HSLZUsH0sWzmj2QYIufeDaCw2Vwnx6I
         /Q1ZgYMRuwgYAQ+kbREeFgEI1z8LXOKs7ozAsyKj70BkAvowQPGYSPnkIZBw9JDf0XQL
         mBAH8TLOYBrWL3slc9Ckc2RSSwuzuT6jv2k8RdjD5rl8reJ4bHnBwTFbSdqXM/Dt0QPc
         ifqw==
X-Gm-Message-State: AJIora/3/YEYx8XO1tS9fvq8g5GP/fJ0dcv8v32FY73BN73GDZPPeQBX
        d9s6xM0N2Fnqw33j15UmCMc=
X-Google-Smtp-Source: AGRyM1sN2Gr9pnnf2B9ExEsmV7zQLd1jwNdznYyJukcOts3te12cLDDesVoK11ZQXS7PNS527AU84w==
X-Received: by 2002:a05:600c:1986:b0:3a1:9936:67ff with SMTP id t6-20020a05600c198600b003a1993667ffmr476429wmq.47.1657140552710;
        Wed, 06 Jul 2022 13:49:12 -0700 (PDT)
Received: from orome (p200300e41f12c800f22f74fffe1f3a53.dip0.t-ipconnect.de. [2003:e4:1f12:c800:f22f:74ff:fe1f:3a53])
        by smtp.gmail.com with ESMTPSA id bi18-20020a05600c3d9200b0039c4506bd25sm26412408wmb.14.2022.07.06.13.49.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 13:49:11 -0700 (PDT)
Date:   Wed, 6 Jul 2022 22:49:10 +0200
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Bhadram Varka <vbhadram@nvidia.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, jonathanh@nvidia.com,
        kuba@kernel.org, catalin.marinas@arm.com, will@kernel.org,
        pabeni@redhat.com, davem@davemloft.net, edumazet@google.com
Subject: Re: [PATCH net-next v2 0/9] tegra: Add support for MGBE controller
Message-ID: <YsX1OCJDqSzjf2lo@orome>
References: <20220706031259.53746-1-vbhadram@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="FnJSvki1Pn59tmsf"
Content-Disposition: inline
In-Reply-To: <20220706031259.53746-1-vbhadram@nvidia.com>
User-Agent: Mutt/2.2.6 (2022-06-05)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--FnJSvki1Pn59tmsf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 06, 2022 at 08:42:50AM +0530, Bhadram Varka wrote:
> This series adds the support for MGBE ethernet controller
> which is part of Tegra234 SoC's.
>=20
> Bhadram Varka (3):
>   dt-bindings: net: Add Tegra234 MGBE
>   arm64: defconfig: Enable Tegra MGBE driver
>   stmmac: tegra: Add MGBE support
>=20
> Thierry Reding (6):
>   dt-bindings: power: Add Tegra234 MGBE power domains
>   dt-bindings: Add Tegra234 MGBE clocks and resets
>   dt-bindings: memory: Add Tegra234 MGBE memory clients
>   memory: tegra: Add MGBE memory clients for Tegra234
>   arm64: tegra: Add MGBE nodes on Tegra234
>   arm64: tegra: Enable MGBE on Jetson AGX Orin Developer Kit

I've applied patches 1-3 as well as 4 to the Tegra tree with Krzysztof's
Acked-by tags from v1. Bhadram's out sick, so I'm going to send out an
updated (and hopefully final) version of the DT bindings and driver
patches later on.

Thierry

--FnJSvki1Pn59tmsf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmLF9UYACgkQ3SOs138+
s6H+XxAAjab/OuhiRzrvxRJDUm1gRGCWFt4UxtDBPOem1+/HX1o73rIWM/WTgUaI
/APP+Meoc2YIqv5HOX+xvzs3Ybx9FVPfLcqoCLGOEJsRcr30cXXbPKovisW6mZgH
TQmg0EqHfxqAZz2lRz5kGowPPH+AyG4WBTLTRYbuEnzeu5xZCXRwSkEKOIogq4pK
KXxi8RuTMFWjbzFFi6tWUrphkXCYZHfWudlYYQWR/9PJop0GGx4FCNmrhZQ9M2AG
voNgGw19IO5PkSidJx3Qlsa8futB3Nz09lXYvyNcOF6q6xCOHlcjaO0XhYvwlerN
jXEKkDwaoee1zC2gbNiAoEP2Fn0jxGh+EJ0tCj+QyyR92tl1nq0LGqafKXyh/d90
P1arMcYKoXU8IxcC5jndqho5Wr8wjecA0ekTRqKoi5QPQ7MBetodoBMr1A9AXIgT
iKJTxDBteuOmL66KnCrR/3C7xi0GyAX2uZNaCNx2hIli5D+9gvs3u+YjqBSkMRdR
f7pUI7O2kNh1P84efBWhANMPGzs3Ot531+rmwJRwLdTexyg9JCeKvdYFrei8jHSJ
1jzkNrqIDgoxB9p5ZBqvalZhoRn3q+gEVvC5bABh/8fKO5vLgcPVEic0fHwTNAM/
Ehhk9+R28zzcTIMqnAJbiaJMC+FnO8jAsFr6Upz5xV00ys7naXk=
=ym3B
-----END PGP SIGNATURE-----

--FnJSvki1Pn59tmsf--
