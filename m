Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC6E2569BF2
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 09:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234206AbiGGHns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 03:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234795AbiGGHnn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 03:43:43 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE1D32057;
        Thu,  7 Jul 2022 00:43:42 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id z41so22094061ede.1;
        Thu, 07 Jul 2022 00:43:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rZhUFwwUcGSvBvAq/wrcD4Uta9N9rbopPYQWGF5hp1o=;
        b=gHaUAtApfMG0IvE0cUroLhlUkukMdzTQff177ejaQV3M86xD07hqh6MP5288Eq+Jqs
         JDqe9nImg8hc3UUkKGQB8Pjod4uictjopLiiVJarKHCA/+GWe6mXtjOsyzG8Y+EI8bU4
         dII+BzQjdCLJOerEYbOnbBcXCznFOhgYWAfc9ZjmkQ5txk37672gVZpAkTZN1z5dI26o
         ioltqdD1QuBBcsGPvMchBd0AHhyQDysLLkueP/sexpcKTgegqNPNLVD+XxcgZjmBGmjf
         m0q0bFFZOaopdaJxLTq2Eklh9m++kS28ZMGgUscBJB3cGatJUjYfkDNCpQTfDxxrNSyl
         Ei/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=rZhUFwwUcGSvBvAq/wrcD4Uta9N9rbopPYQWGF5hp1o=;
        b=O629Y0G1RH7Xvgz/xCal38LAFiWrJkw+76/sELFMka1n15hjWB170pqHSgiu42p+14
         9EVZEvyINWXkHlR1vbtroPgDhjafOjQzmra/zSHyZqCPOjs1biq2JvZ9U4W5bs8abCpA
         vkNoMnTp8qG67YTdjQWQOgf/tJ6eyc/a+Je2AN28mMISr1sX9OPJH2jIfugFcF6nm49r
         D9PKRjqqcqdDJJCo3+/ZM6oJSRn6yPLKIwXD7yyxy5E1n2Fby4j2KpJg0pycQh9LQFVu
         trfxijyGWVTUDF/OBGFao1DHt976F8gH8XyzaHN8B1RhnxuXsetEri+3Wea4kaB7hgxt
         clYg==
X-Gm-Message-State: AJIora+QPecsR/bItmG3qzMUySoHu8itEgejhiRW5kPdTQiocB8XjMxm
        uIevi3s17anHbaTdcRYqURf6oiYzre0=
X-Google-Smtp-Source: AGRyM1v5G4XnQlNmWTuUA9gsDiHTLwYwEbCQwBCtbMTmbgCQ21aY0puoMVOvpoGoGmc6DUo2L4z8qg==
X-Received: by 2002:a05:6402:1e95:b0:437:ce7f:e17a with SMTP id f21-20020a0564021e9500b00437ce7fe17amr58884437edf.169.1657179821161;
        Thu, 07 Jul 2022 00:43:41 -0700 (PDT)
Received: from orome (p200300e41f12c800f22f74fffe1f3a53.dip0.t-ipconnect.de. [2003:e4:1f12:c800:f22f:74ff:fe1f:3a53])
        by smtp.gmail.com with ESMTPSA id a12-20020a170906670c00b006fe8c831632sm18472588ejp.73.2022.07.07.00.43.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 00:43:40 -0700 (PDT)
Date:   Thu, 7 Jul 2022 09:43:38 +0200
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Rob Herring <robh@kernel.org>, Jon Hunter <jonathanh@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, devicetree@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Bhadram Varka <vbhadram@nvidia.com>,
        linux-tegra@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH v3 5/9] dt-bindings: net: Add Tegra234 MGBE
Message-ID: <YsaOqgbMFf/RpjLv@orome>
References: <20220706213255.1473069-1-thierry.reding@gmail.com>
 <20220706213255.1473069-6-thierry.reding@gmail.com>
 <1657169989.827036.709503.nullmailer@robh.at.kernel.org>
 <YsZ6fus1yNcf/H/Q@orome>
 <173a9087-6a55-13f8-3fc9-897c7f51a09e@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qi4vcEsMPi9TNHn/"
Content-Disposition: inline
In-Reply-To: <173a9087-6a55-13f8-3fc9-897c7f51a09e@linaro.org>
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


--qi4vcEsMPi9TNHn/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 07, 2022 at 08:53:32AM +0200, Krzysztof Kozlowski wrote:
> On 07/07/2022 08:17, Thierry Reding wrote:
> > On Wed, Jul 06, 2022 at 10:59:49PM -0600, Rob Herring wrote:
> >> On Wed, 06 Jul 2022 23:32:51 +0200, Thierry Reding wrote:
> >>> From: Bhadram Varka <vbhadram@nvidia.com>
> >>>
> >>> Add device-tree binding documentation for the Multi-Gigabit Ethernet
> >>> (MGBE) controller found on NVIDIA Tegra234 SoCs.
> >>>
> >>> Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
> >>> Signed-off-by: Bhadram Varka <vbhadram@nvidia.com>
> >>> Signed-off-by: Thierry Reding <treding@nvidia.com>
> >>> ---
> >>> Changes in v3:
> >>> - add macsec and macsec-ns interrupt names
> >>> - improve mdio bus node description
> >>> - drop power-domains description
> >>> - improve bindings title
> >>>
> >>> Changes in v2:
> >>> - add supported PHY modes
> >>> - change to dual license
> >>>
> >>>  .../bindings/net/nvidia,tegra234-mgbe.yaml    | 169 ++++++++++++++++=
++
> >>>  1 file changed, 169 insertions(+)
> >>>  create mode 100644 Documentation/devicetree/bindings/net/nvidia,tegr=
a234-mgbe.yaml
> >>>
> >>
> >> My bot found errors running 'make DT_CHECKER_FLAGS=3D-m dt_binding_che=
ck'
> >> on your patch (DT_CHECKER_FLAGS is new in v5.13):
> >>
> >> yamllint warnings/errors:
> >>
> >> dtschema/dtc warnings/errors:
> >> Error: Documentation/devicetree/bindings/net/nvidia,tegra234-mgbe.exam=
ple.dts:53.34-35 syntax error
> >> FATAL ERROR: Unable to parse input tree
> >=20
> > This is an error that you'd get if patch 3 is not applied. Not sure if I
> > managed to confuse the bot somehow, but I cannot reproduce this if I
> > apply the series on top of v5.19-rc1 or linux-next.
>=20
> Patch number 3 does not apply on v5.19-rc1 or linux-next, so maybe the
> bot (which applies on rc1) did not have it.

Good point. I'll rebase v4 on top of v5.19-rc1 then. This shouldn't
cause a problem for net-next because there's no conflict there for patch
9.

I did notice that the devicetree-bindings patchwork instance doesn't
have all of the patches, so perhaps that tripped up the bot as well. Not
sure what happened there, the linux-tegra instance has all 9 patches.

Thierry

--qi4vcEsMPi9TNHn/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmLGjqcACgkQ3SOs138+
s6GG9BAApK9vwxL1fMefuwcIDBNUimcfLISswJTiN9OQg+V2NMrXytex2inKYDSv
jBpo3fMWwF91U4lAVs01WF/CLRmmgJnawx9mF9ttz4CQfN78C4imdwsxj+sZ6sKV
u/B+hMv4zP5/fJDGW3SH9lhog+s0FgQmvDFhRlYEHQ54KLYqCdyvIlwOyszruF+6
8A9o8O08JJbAH3wWutGyKZwKyIF/kvwwKYO7W65BiRaVDkE2vnIkMlKtCcg1zIwv
pwjV2i4VZFOg7u/EFMb0tf49GLmIMLD2FdQ1/ZPaaThBSaJFJvxFMz/dq4+K75YW
f7uasJ65DTNJigM4FcHGgDfwyYH9QT9j19ZL/Yj3do8Rw0nIhDDD5VUeYpJKJ+xT
iL7nsFvYl6+VHEQP5PXJjlXuzBFcKZjOwf9rFtKPWBtg/2KTSfSfC0J8Xkcidkql
eJ/yfxUj24ZSvKP30L0EEN86fIa4HUXjluBUY18cd03XDDPXmKv6qflqAqHnriBm
S6yXCnkUvJxeB2KmTeWYYr3DBg8ZorSJWewo7NcHqLAj1zfEBlVuKvccRxZm1vn+
Po0YfwB7cxhCbXPiqgoIs3cQm6ggcT3vRiNUGZVt4Hoqyf6LiK2Gh5hGXYpmmD8u
W75jc6rtplpQ8qrIPhD0ZAYJFCQCpRyD37A1Em3vy3pU3rft2U8=
=XBl9
-----END PGP SIGNATURE-----

--qi4vcEsMPi9TNHn/--
