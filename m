Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4861C56BFCC
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 20:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239218AbiGHQ1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 12:27:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239210AbiGHQ0r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 12:26:47 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B5B4823A9;
        Fri,  8 Jul 2022 09:26:38 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id y4so14103836edc.4;
        Fri, 08 Jul 2022 09:26:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jBBGv2MH1xtT+DBQ2dsWqWqy6wixEPAxQTrXzQpDkQs=;
        b=cvlqAEpN2sg9w9CnSuMeir5UJAIyagRXyhs8NEqaBQPNfW9gnq4Z2wh1CKxyYo8fUo
         760Dvsbdeswb/MAjVPM0FCWXrfIqHBbXRx9fz9DhfkcnH/76mmQLswVPmzQBTO0yuKxZ
         byu/K+EPilZaA7iU9JpwS5QGoYOfk8Uhl9ksI6U0xHXFH8Bnj5ly+diptDqrvw5Q0W2c
         yM5rTzNOmPzYH0SQrwZkL6WYvFhvhh5Zt9TqI9l6OWHBuaGV0pMbGpC3C/GFPCLpZsau
         bj8d8L1MRjm8juIR0Fr/wdLSvS5RjyX8q40coPS5Kzw9A3N9cUKUXCYaQ1uWVnCJsfOD
         816g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=jBBGv2MH1xtT+DBQ2dsWqWqy6wixEPAxQTrXzQpDkQs=;
        b=ITIB5wNUTYBDtPuLMfpdTsEKGsofUysZqKGtI3Ri/2IfwjjLbLiYi9m/utWs8Tenj5
         T+U9X7trlcyp1iXE2q2htLwui+Vpv4tVtA53az0s0Ys54Lce5P/pISwowajOlPSy7Hag
         e8Ve9oHh2h9H87Rk/2KcL30ZvVlKuzHvQ6gOPrEt8VUJlMGmRUqL9/SZL4BxjHUZjbio
         7xRAqqP0hMwHykIvrrYjwepRFWCw4hOQmDyjjbUT4yDVVCFOt+AYf8GOo9arGHvdQIf5
         l+eujocgj8zMF5i1rUjVpOBpnQJ6WOe2WkriXamZN1uPZ3h7ZRutP2Muw4p3RQwTQCrY
         df7w==
X-Gm-Message-State: AJIora9ZKrwIEQqblQSzNyHdI3ySIek9WAaNfxHjNgx8y9h0N+ODVraR
        3KEROmmzQwgvj3kpqeCDels=
X-Google-Smtp-Source: AGRyM1u7oYXChVO/BmiWkzkIo1gSmTD1maKStuMsX4d3tsVmc0NIi98coMg5s9e6naOL7hchD2PVRQ==
X-Received: by 2002:a05:6402:248c:b0:437:afe7:818b with SMTP id q12-20020a056402248c00b00437afe7818bmr5867642eda.239.1657297596483;
        Fri, 08 Jul 2022 09:26:36 -0700 (PDT)
Received: from orome (p200300e41f12c800f22f74fffe1f3a53.dip0.t-ipconnect.de. [2003:e4:1f12:c800:f22f:74ff:fe1f:3a53])
        by smtp.gmail.com with ESMTPSA id o3-20020aa7c503000000b0042de8155fa1sm30561839edq.0.2022.07.08.09.26.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 09:26:35 -0700 (PDT)
Date:   Fri, 8 Jul 2022 18:26:33 +0200
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     Jon Hunter <jonathanh@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bhadram Varka <vbhadram@nvidia.com>,
        devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v4 5/9] dt-bindings: net: Add Tegra234 MGBE
Message-ID: <YshauQwRF3oDG1N3@orome>
References: <20220707074818.1481776-1-thierry.reding@gmail.com>
 <20220707074818.1481776-6-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="PAZZeOYfUczfacfr"
Content-Disposition: inline
In-Reply-To: <20220707074818.1481776-6-thierry.reding@gmail.com>
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


--PAZZeOYfUczfacfr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 07, 2022 at 09:48:14AM +0200, Thierry Reding wrote:
> From: Bhadram Varka <vbhadram@nvidia.com>
>=20
> Add device-tree binding documentation for the Multi-Gigabit Ethernet
> (MGBE) controller found on NVIDIA Tegra234 SoCs.
>=20
> Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
> Signed-off-by: Bhadram Varka <vbhadram@nvidia.com>
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
> Changes in v4:
> - uses fixed lists of items for clock-names and reset-names
> - add missing maxItems to interrupts property
> - drop minItems where it equals maxItems
> - drop unnecessary blank lines
> - drop redundant comment
>=20
> Changes in v3:
> - add macsec and macsec-ns interrupt names
> - improve mdio bus node description
> - drop power-domains description
> - improve bindings title
>=20
> Changes in v2:
> - add supported PHY modes
> - change to dual license
>=20
>  .../bindings/net/nvidia,tegra234-mgbe.yaml    | 162 ++++++++++++++++++
>  1 file changed, 162 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/nvidia,tegra234=
-mgbe.yaml

Rob, Krzysztof,

any chance I could get a Reviewed-by/Acked-by on this? I'd like to
include patches 5-8 as part of the ARM-SoC PRs for v5.20 (which I need
to send before v5.19-rc6) because it unblocks a number of people and
with networking support we could enable more of our daily testing
coverage.

Thanks,
Thierry

> diff --git a/Documentation/devicetree/bindings/net/nvidia,tegra234-mgbe.y=
aml b/Documentation/devicetree/bindings/net/nvidia,tegra234-mgbe.yaml
> new file mode 100644
> index 000000000000..2bd3efff2485
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/nvidia,tegra234-mgbe.yaml
> @@ -0,0 +1,162 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/nvidia,tegra234-mgbe.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Tegra234 MGBE Multi-Gigabit Ethernet Controller
> +
> +maintainers:
> +  - Thierry Reding <treding@nvidia.com>
> +  - Jon Hunter <jonathanh@nvidia.com>
> +
> +properties:
> +  compatible:
> +    const: nvidia,tegra234-mgbe
> +
> +  reg:
> +    maxItems: 3
> +
> +  reg-names:
> +    items:
> +      - const: hypervisor
> +      - const: mac
> +      - const: xpcs
> +
> +  interrupts:
> +    minItems: 1
> +    maxItems: 3
> +
> +  interrupt-names:
> +    minItems: 1
> +    items:
> +      - const: common
> +      - const: macsec-ns
> +      - const: macsec
> +
> +  clocks:
> +    maxItems: 12
> +
> +  clock-names:
> +    items:
> +      - const: mgbe
> +      - const: mac
> +      - const: mac-divider
> +      - const: ptp-ref
> +      - const: rx-input-m
> +      - const: rx-input
> +      - const: tx
> +      - const: eee-pcs
> +      - const: rx-pcs-input
> +      - const: rx-pcs-m
> +      - const: rx-pcs
> +      - const: tx-pcs
> +
> +  resets:
> +    maxItems: 2
> +
> +  reset-names:
> +    items:
> +      - const: mac
> +      - const: pcs
> +
> +  interconnects:
> +    items:
> +      - description: memory read client
> +      - description: memory write client
> +
> +  interconnect-names:
> +    items:
> +      - const: dma-mem
> +      - const: write
> +
> +  iommus:
> +    maxItems: 1
> +
> +  power-domains:
> +    maxItems: 1
> +
> +  phy-handle: true
> +
> +  phy-mode:
> +    contains:
> +      enum:
> +        - usxgmii
> +        - 10gbase-kr
> +
> +  mdio:
> +    $ref: mdio.yaml#
> +    unevaluatedProperties: false
> +    description:
> +      Optional node for embedded MDIO controller.
> +
> +required:
> +  - compatible
> +  - reg
> +  - interrupts
> +  - interrupt-names
> +  - clocks
> +  - clock-names
> +  - resets
> +  - reset-names
> +  - power-domains
> +  - phy-handle
> +  - phy-mode
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/clock/tegra234-clock.h>
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +    #include <dt-bindings/memory/tegra234-mc.h>
> +    #include <dt-bindings/power/tegra234-powergate.h>
> +    #include <dt-bindings/reset/tegra234-reset.h>
> +
> +    ethernet@6800000 {
> +        compatible =3D "nvidia,tegra234-mgbe";
> +        reg =3D <0x06800000 0x10000>,
> +              <0x06810000 0x10000>,
> +              <0x068a0000 0x10000>;
> +        reg-names =3D "hypervisor", "mac", "xpcs";
> +        interrupts =3D <GIC_SPI 384 IRQ_TYPE_LEVEL_HIGH>;
> +        interrupt-names =3D "common";
> +        clocks =3D <&bpmp TEGRA234_CLK_MGBE0_APP>,
> +                 <&bpmp TEGRA234_CLK_MGBE0_MAC>,
> +                 <&bpmp TEGRA234_CLK_MGBE0_MAC_DIVIDER>,
> +                 <&bpmp TEGRA234_CLK_MGBE0_PTP_REF>,
> +                 <&bpmp TEGRA234_CLK_MGBE0_RX_INPUT_M>,
> +                 <&bpmp TEGRA234_CLK_MGBE0_RX_INPUT>,
> +                 <&bpmp TEGRA234_CLK_MGBE0_TX>,
> +                 <&bpmp TEGRA234_CLK_MGBE0_EEE_PCS>,
> +                 <&bpmp TEGRA234_CLK_MGBE0_RX_PCS_INPUT>,
> +                 <&bpmp TEGRA234_CLK_MGBE0_RX_PCS_M>,
> +                 <&bpmp TEGRA234_CLK_MGBE0_RX_PCS>,
> +                 <&bpmp TEGRA234_CLK_MGBE0_TX_PCS>;
> +        clock-names =3D "mgbe", "mac", "mac-divider", "ptp-ref", "rx-inp=
ut-m",
> +                      "rx-input", "tx", "eee-pcs", "rx-pcs-input", "rx-p=
cs-m",
> +                      "rx-pcs", "tx-pcs";
> +        resets =3D <&bpmp TEGRA234_RESET_MGBE0_MAC>,
> +                 <&bpmp TEGRA234_RESET_MGBE0_PCS>;
> +        reset-names =3D "mac", "pcs";
> +        interconnects =3D <&mc TEGRA234_MEMORY_CLIENT_MGBEARD &emc>,
> +                        <&mc TEGRA234_MEMORY_CLIENT_MGBEAWR &emc>;
> +        interconnect-names =3D "dma-mem", "write";
> +        iommus =3D <&smmu_niso0 TEGRA234_SID_MGBE>;
> +        power-domains =3D <&bpmp TEGRA234_POWER_DOMAIN_MGBEA>;
> +
> +        phy-handle =3D <&mgbe0_phy>;
> +        phy-mode =3D "usxgmii";
> +
> +        mdio {
> +            #address-cells =3D <1>;
> +            #size-cells =3D <0>;
> +
> +            mgbe0_phy: phy@0 {
> +                compatible =3D "ethernet-phy-ieee802.3-c45";
> +                reg =3D <0x0>;
> +
> +                #phy-cells =3D <0>;
> +            };
> +        };
> +    };
> --=20
> 2.36.1
>=20

--PAZZeOYfUczfacfr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmLIWrcACgkQ3SOs138+
s6Hf9BAAkJXl49/3rIbeF+kR30iLIc2GBm+S3fPN1W2Rw0YNQxYDApBkD9RYmh26
4jsSPO84mWLpkQCku9VZMYO2IHEQ6Awi1E7s3kIWaRLPg6yLQj0vDH0dyRyxskUM
BZaoXTo7nw1KMDyCTxx5ulfvUzRSab6ElPhySzCZIgLxVv1iFwhOBryMmpxEkFj5
LpyqikrZUJv3vpx+tBg3r7Di+qCdi7A7GecTf/OwDu69Jn6dLE6Ao6gAoaPz22ZH
WXxPtbIHUO5/uRgSRWKLrgeFan1eXbe0NyrNHRV9w5z9areQBPZ2kf+qn7PqlnNu
3iFpqBG5ru4Z/Wsbl7uWAbjEFY9RQQz5CCJBeph/p3GkJmLGlaF3AD/QFuJF0pp2
ufd/TgUAylCIRubMJGlkDKWimdmG9sI3hLlZzyTvTR2UTy8ytLWxDFowf7ItA9ls
jAP19R4Z4KpjE7rcXrU5ZjFjSfoByLjAPoXjwW+pmfZCpmI0MelzbhOsaoOG6PUB
iGSDLlJWfMReEBjdwL9xrIFQirj7vKhNXMp8jVoWRDv8Rd6V06krxqcBhRGcmCX2
cWeQ2vShdkqrLKfC9b9TMwh67WK97BS3LFoHVFEMpaAxixX0brq/4LefdbPxWhxx
cAg9pfWkEu0ZU69v8afVQnSUqHOuzmcV7aNuPCEKbgO5CDWRm1g=
=bPMb
-----END PGP SIGNATURE-----

--PAZZeOYfUczfacfr--
