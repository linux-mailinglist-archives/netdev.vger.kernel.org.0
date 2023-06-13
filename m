Return-Path: <netdev+bounces-10310-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D662F72DC8B
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 10:35:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E0C071C20C1D
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 08:35:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90DD4210D;
	Tue, 13 Jun 2023 08:35:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8418C1C2B
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 08:35:30 +0000 (UTC)
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FDA613A
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 01:35:28 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id 4fb4d7f45d1cf-51480d3e161so7784761a12.3
        for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 01:35:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686645327; x=1689237327;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Udk48S5fbv1dSJicz4zumka+B8gpUCv6JR8oUWwytFE=;
        b=o9dC8ORhi2FyvFaJyDB1gLfg7fp6jE04zMI9PMsiS1Lau844sKcyC+XT/WNcQrQJy7
         L2cFqSg2VKLxI7pk+NQbhTna72JESVzQooQZqeZ4qdwFGsGCJ6ZL37y2zwkg3vc5rx11
         5XVLU8RBmI34mQ4gU5ZNaBqen96fE9mv+3wT/kbc91A+ZTFYM9zmhB2S/z6BS83QO0tV
         MktH6lJxd+hcHvlaPZ6ccAO0tXdLxRiFlLLctYN1JU2aN63Rnu04ZkqaNJX30K9KwEO8
         OFuKVt9Bp9MtZN3V9RyV8lP6iX+8AlDS10LniseldOE/LFKOq1p8tmOZeMfNkuS+JznP
         0f6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686645327; x=1689237327;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Udk48S5fbv1dSJicz4zumka+B8gpUCv6JR8oUWwytFE=;
        b=FjZ1UaxTXesi1G3kTAy+7vfO4+x5NYKxO1HmYNwLk7bFFAnn9l10k6wEuKy8SMsZiH
         yakUmhTRXaNU/b02kVOmlzrgQYD0gA916MIPEVgLJemsGFY4LKLCvZpkU9e/VS4r0BbC
         CAoOIiDSdJVfKlluBGQDW+7O5YfMk1YpWyJR7t3o8ek++L+6QkCal5YcCYs65plTtGyE
         7Ul/qOwTiNylZUcbmsZlJSS+93a6BqYFBhVb9bJMUaYDIFzUnxmE13mUnLys7/qxG0u5
         YOM6ZeDyqkAqXipHK9a6+FEAjw+ANnMd4831DuW2L+rf+zNnj0EpCA4POgn0KixdExy4
         xjYA==
X-Gm-Message-State: AC+VfDw6dHJQBmVZZMT2luliBUf0ikv0nDEj6aDMCvwOSmzve1fyhlB6
	KJEZVPY2fKqQChWEd3kmI5C8olTcetgxSvx9mmI=
X-Google-Smtp-Source: ACHHUZ5D4gB3CQuOc/H+EBL9HRkHsEZcW5QTsbj6vgPuq8XY2+MuBCT0xx60P2+MpyexNwcAvjYTKg==
X-Received: by 2002:a05:6402:88e:b0:516:81d3:2627 with SMTP id e14-20020a056402088e00b0051681d32627mr7756069edy.0.1686645327009;
        Tue, 13 Jun 2023 01:35:27 -0700 (PDT)
Received: from [192.168.1.20] ([178.197.219.26])
        by smtp.gmail.com with ESMTPSA id f11-20020aa7d84b000000b00514ad0e3167sm6093578eds.71.2023.06.13.01.35.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jun 2023 01:35:26 -0700 (PDT)
Message-ID: <e13aace9-daf4-8052-4ef3-19033a71ca7a@linaro.org>
Date: Tue, 13 Jun 2023 10:35:23 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH net-next 1/8] dt-bindings: net: mediatek,net: add
 mt7988-eth binding
Content-Language: en-US
To: Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
 linux-mediatek@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
 Russell King <linux@armlinux.org.uk>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 Lorenzo Bianconi <lorenzo@kernel.org>, Mark Lee <Mark-MC.Lee@mediatek.com>,
 Sean Wang <sean.wang@mediatek.com>, John Crispin <john@phrozen.org>,
 Felix Fietkau <nbd@nbd.name>, Conor Dooley <conor+dt@kernel.org>,
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
 Rob Herring <robh+dt@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Jakub Kicinski <kuba@kernel.org>, Eric Dumazet <edumazet@google.com>,
 "David S. Miller" <davem@davemloft.net>, Sam Shih <Sam.Shih@mediatek.com>
References: <ZIUWGxUV8mxYns_l@makrotopia.org>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <ZIUWGxUV8mxYns_l@makrotopia.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 11/06/2023 02:32, Daniel Golle wrote:
> Introduce DT bindings for the MT7988 SoC to mediatek,net.yaml.
> The MT7988 SoC got 3 Ethernet MACs operating at a maximum of
> 10 Gigabit/sec supported by 2 packet processor engines for
> offloading tasks.
> The first MAC is hard-wired to a built-in switch which exposes
> four 1000Base-T PHYs as user ports.
> It also comes with built-in 2500Base-T PHY which can be used
> with the 2nd GMAC.
> The 2nd and 3rd GMAC can be connected to external PHYs or provide
> SFP(+) cages attached via SGMII, 1000Base-X, 2500Base-X, USXGMII,
> 5GBase-KR or 10GBase-KR.
> 
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> ---
>  .../devicetree/bindings/net/mediatek,net.yaml | 111 ++++++++++++++++++
>  1 file changed, 111 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/mediatek,net.yaml b/Documentation/devicetree/bindings/net/mediatek,net.yaml
> index acb2b2ac4fe1e..f08151a60084b 100644
> --- a/Documentation/devicetree/bindings/net/mediatek,net.yaml
> +++ b/Documentation/devicetree/bindings/net/mediatek,net.yaml
> @@ -23,6 +23,7 @@ properties:
>        - mediatek,mt7629-eth
>        - mediatek,mt7981-eth
>        - mediatek,mt7986-eth
> +      - mediatek,mt7988-eth
>        - ralink,rt5350-eth
>  
>    reg:
> @@ -70,6 +71,22 @@ properties:
>        A list of phandle to the syscon node that handles the SGMII setup which is required for
>        those SoCs equipped with SGMII.
>  
> +  mediatek,toprgu:
> +    $ref: /schemas/types.yaml#/definitions/phandle
> +    description:
> +      Phandle to the mediatek toprgu controller used to provide various clocks
> +      and reset to the system.
> +
> +  mediatek,usxgmiisys:
> +    $ref: /schemas/types.yaml#/definitions/phandle-array
> +    minItems: 2
> +    maxItems: 2
> +    items:
> +      maxItems: 1
> +    description:
> +      A list of phandle to the syscon node that handles the USXGMII setup which is required for
> +      those SoCs equipped with USXGMII.

Why do you need two phandles for the same node?

> +
>    mediatek,wed:
>      $ref: /schemas/types.yaml#/definitions/phandle-array
>      minItems: 2
> @@ -84,6 +101,21 @@ properties:
>      description:
>        Phandle to the mediatek wed-pcie controller.
>  
> +  mediatek,xfi_pextp:

Underscores are not allowed in property names.

> +    $ref: /schemas/types.yaml#/definitions/phandle-array
> +    minItems: 2
> +    maxItems: 2
> +    items:
> +      maxItems: 1
> +    description:
> +      A list of phandle to the syscon node that handles the XFI setup which is required for
> +      those SoCs equipped with XFI.
> +
> +  mediatek,xfi_pll:
> +    $ref: /schemas/types.yaml#/definitions/phandle
> +    description:
> +      Phandle to the XFI PLL unit.

This looks like a clock.

> +
>    dma-coherent: true
>  
>    mdio-bus:
> @@ -290,6 +322,85 @@ allOf:
>            minItems: 2
>            maxItems: 2
>  
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            const: mediatek,mt7988-eth
> +    then:
> +      properties:
> +        interrupts:
> +          minItems: 4
> +
> +        clocks:
> +          minItems: 34
> +          maxItems: 34
> +
> +        clock-names:
> +          items:
> +            - const: crypto
> +            - const: fe
> +            - const: gp2
> +            - const: gp1
> +            - const: gp3
> +            - const: ethwarp_wocpu2
> +            - const: ethwarp_wocpu1
> +            - const: ethwarp_wocpu0
> +            - const: esw
> +            - const: netsys0
> +            - const: netsys1
> +            - const: sgmii_tx250m
> +            - const: sgmii_rx250m
> +            - const: sgmii2_tx250m
> +            - const: sgmii2_rx250m
> +            - const: top_usxgmii0_sel
> +            - const: top_usxgmii1_sel
> +            - const: top_sgm0_sel
> +            - const: top_sgm1_sel
> +            - const: top_xfi_phy0_xtal_sel
> +            - const: top_xfi_phy1_xtal_sel
> +            - const: top_eth_gmii_sel
> +            - const: top_eth_refck_50m_sel
> +            - const: top_eth_sys_200m_sel
> +            - const: top_eth_sys_sel
> +            - const: top_eth_xgmii_sel
> +            - const: top_eth_mii_sel
> +            - const: top_netsys_sel
> +            - const: top_netsys_500m_sel
> +            - const: top_netsys_pao_2x_sel
> +            - const: top_netsys_sync_250m_sel
> +            - const: top_netsys_ppefb_250m_sel
> +            - const: top_netsys_warp_sel
> +            - const: wocpu1
> +            - const: wocpu0
> +            - const: xgp1
> +            - const: xgp2
> +            - const: xgp3
> +
> +        mediatek,sgmiisys:
> +          minItems: 2
> +          maxItems: 2
> +
> +        mediatek,usxgmiisys:
> +          minItems: 2
> +          maxItems: 2

Why do you need this here?

> +
> +        mediatek,xfi_pextp:
> +          minItems: 2
> +          maxItems: 2
> +
> +        mediatek,xfi_pll:
> +          minItems: 1
> +          maxItems: 1
> +
> +        mediatek,infracfg:
> +          minItems: 1
> +          maxItems: 1
> +
> +        mediatek,toprgu:
> +          minItems: 1
> +          maxItems: 1

All this looks redundant.



Best regards,
Krzysztof


