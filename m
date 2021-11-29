Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23B97460B6C
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 01:07:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359721AbhK2AKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 19:10:35 -0500
Received: from mail-ot1-f41.google.com ([209.85.210.41]:41485 "EHLO
        mail-ot1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376257AbhK2AIe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Nov 2021 19:08:34 -0500
Received: by mail-ot1-f41.google.com with SMTP id n17-20020a9d64d1000000b00579cf677301so23047306otl.8;
        Sun, 28 Nov 2021 16:05:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iwSIflfW61r4qMMe5AGMgQ3tkWLIXXhLm1LxJgz7nQY=;
        b=XrIL02VFjvJp6M3gHKT2rbBOdKqOQs6EYNPy8a6OgLBpZLBTp0YIIMNB5l0URo9wyo
         yAEtRVwLUB4YUMxET8TTVOF+4WQQaxMlTZCCawqEW/37VvwLgddzfg1dskJG+DgzRBvr
         iTveORVwXhRWsDaAJJF5eoPrsJs8X2Ix6+j6tqSqF4ymdL+CgII4C3PHSF0GxXT6n4qH
         QmvdURLpFR4h13mNpiHUYePjthzAnYfMbRfLPmZkAEJI11lX24p8M6xp2l+xCcQxFqF0
         8C+AwtxFSyD5EOKdkhraGqpXEqc5xA/ib1rzGl7mQiMZeYtR+Z1hhvrt+PXHrj42LLsx
         aedw==
X-Gm-Message-State: AOAM532UCYsVmKDx6WWu+kU8Suxnjj+c7nNs9pbbP+blhFJjUnrJp441
        fIVA69f17JezLl5ZDirOrQ==
X-Google-Smtp-Source: ABdhPJyAFWt39rMuurc002tPJegnuR2ShMHjadX/k8wY8gGlpo0V3+AB6mJ1nMYec4g9/fhbKE478A==
X-Received: by 2002:a9d:2002:: with SMTP id n2mr41519471ota.95.1638144317562;
        Sun, 28 Nov 2021 16:05:17 -0800 (PST)
Received: from robh.at.kernel.org ([172.58.99.242])
        by smtp.gmail.com with ESMTPSA id w22sm2050772ooc.47.2021.11.28.16.05.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Nov 2021 16:05:17 -0800 (PST)
Received: (nullmailer pid 2854097 invoked by uid 1000);
        Mon, 29 Nov 2021 00:05:13 -0000
Date:   Sun, 28 Nov 2021 18:05:13 -0600
From:   Rob Herring <robh@kernel.org>
To:     Biao Huang <biao.huang@mediatek.com>
Cc:     davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        srv_heupstream@mediatek.com, macpaul.lin@mediatek.com,
        angelogioacchino.delregno@collabora.com, dkirjanov@suse.de
Subject: Re: [PATCH v3 7/7] net-next: dt-bindings: dwmac: add support for
 mt8195
Message-ID: <YaQZOS54BawtWkGO@robh.at.kernel.org>
References: <20211112093918.11061-1-biao.huang@mediatek.com>
 <20211112093918.11061-8-biao.huang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211112093918.11061-8-biao.huang@mediatek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 12, 2021 at 05:39:18PM +0800, Biao Huang wrote:
> Add binding document for the ethernet on mt8195.
> 
> Signed-off-by: Biao Huang <biao.huang@mediatek.com>
> ---
>  .../bindings/net/mediatek-dwmac.yaml          | 86 +++++++++++++++----
>  1 file changed, 70 insertions(+), 16 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml b/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
> index 2eb4781536f7..b27566ed01c6 100644
> --- a/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
> +++ b/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
> @@ -19,12 +19,68 @@ select:
>        contains:
>          enum:
>            - mediatek,mt2712-gmac
> +          - mediatek,mt8195-gmac
>    required:
>      - compatible
>  
>  allOf:
>    - $ref: "snps,dwmac.yaml#"
>    - $ref: "ethernet-controller.yaml#"
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            enum:
> +              - mediatek,mt2712-gmac
> +
> +    then:
> +      properties:
> +        clocks:
> +          minItems: 5
> +          items:
> +            - description: AXI clock
> +            - description: APB clock
> +            - description: MAC Main clock
> +            - description: PTP clock
> +            - description: RMII reference clock provided by MAC
> +
> +        clock-names:
> +          minItems: 5
> +          items:
> +            - const: axi
> +            - const: apb
> +            - const: mac_main
> +            - const: ptp_ref
> +            - const: rmii_internal
> +
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            enum:
> +              - mediatek,mt8195-gmac
> +
> +    then:
> +      properties:
> +        clocks:
> +          minItems: 6
> +          items:
> +            - description: AXI clock
> +            - description: APB clock
> +            - description: MAC clock gate
> +            - description: MAC Main clock
> +            - description: PTP clock
> +            - description: RMII reference clock provided by MAC

Put mac_cg at the end and then the difference is just 5 or 6 clocks and 
you don't have to duplicate everything.


> +
> +        clock-names:
> +          minItems: 6
> +          items:
> +            - const: axi
> +            - const: apb
> +            - const: mac_cg
> +            - const: mac_main
> +            - const: ptp_ref
> +            - const: rmii_internal
>  
>  properties:
>    compatible:
> @@ -33,22 +89,10 @@ properties:
>            - enum:
>                - mediatek,mt2712-gmac
>            - const: snps,dwmac-4.20a
> -
> -  clocks:
> -    items:
> -      - description: AXI clock
> -      - description: APB clock
> -      - description: MAC Main clock
> -      - description: PTP clock
> -      - description: RMII reference clock provided by MAC
> -
> -  clock-names:
> -    items:
> -      - const: axi
> -      - const: apb
> -      - const: mac_main
> -      - const: ptp_ref
> -      - const: rmii_internal
> +      - items:
> +          - enum:
> +              - mediatek,mt8195-gmac
> +          - const: snps,dwmac-5.10a
>  
>    mediatek,pericfg:
>      $ref: /schemas/types.yaml#/definitions/phandle
> @@ -63,6 +107,8 @@ properties:
>        or will round down. Range 0~31*170.
>        For MT2712 RMII/MII interface, Allowed value need to be a multiple of 550,
>        or will round down. Range 0~31*550.
> +      For MT8195 RGMII/RMII/MII interface, Allowed value need to be a multiple of 290,
> +      or will round down. Range 0~31*290.
>  
>    mediatek,rx-delay-ps:
>      description:
> @@ -71,6 +117,8 @@ properties:
>        or will round down. Range 0~31*170.
>        For MT2712 RMII/MII interface, Allowed value need to be a multiple of 550,
>        or will round down. Range 0~31*550.
> +      For MT8195 RGMII/RMII/MII interface, Allowed value need to be a multiple
> +      of 290, or will round down. Range 0~31*290.
>  
>    mediatek,rmii-rxc:
>      type: boolean
> @@ -104,6 +152,12 @@ properties:
>        3. the inside clock, which be sent to MAC, will be inversed in RMII case when
>           the reference clock is from MAC.
>  
> +  mediatek,mac-wol:
> +    type: boolean
> +    description:
> +      If present, indicates that MAC supports WOL(Wake-On-LAN), and MAC WOL will be enabled.
> +      Otherwise, PHY WOL is perferred.
> +
>  required:
>    - compatible
>    - reg
> -- 
> 2.25.1
> 
> 
