Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01C56619ED1
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 18:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbiKDRe7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 13:34:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiKDRe5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 13:34:57 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8168311A17;
        Fri,  4 Nov 2022 10:34:55 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id a5so8614357edb.11;
        Fri, 04 Nov 2022 10:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NKWYQa8Wr0va/fSr1q2BSqsviHKSdIuqj6KC3nyRJW0=;
        b=Ajxb6JPUF9fA0Q8rziy6q/lA0S6gXVrIuGBPep6WU+flBJdxTQzY+hCiM4QBkQsDeF
         iNlicXzG/T5/jw6FmLUr3EvoSvV1u0q3lAJDlpbX76fMiEUGxm5CGJL7SJ3D1jNSCoev
         V8IIJNY6IvrVTL9JdJ8IjvXAlE5dtTf9ZSPt2K+IIm6TPfCTZkofSVgwps0zJDoA/7Nu
         G7SdKR7QQ9zeNesS0FLYvO0soteSyhyB0lsP4jig86u/vO4BI2K2LHAMl6prK8wmhQ1h
         /eFUp9fAm5LBvgXnMnK1fie3xFKQmG7mnEPaHsYbtbj3R5m3kvHkh+SZaA9Ngcz3YmCe
         uZ7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NKWYQa8Wr0va/fSr1q2BSqsviHKSdIuqj6KC3nyRJW0=;
        b=qj9356hX/A7lsNX14ryqIkYgoZJ+0Pn5NjbxHtKEDkhp8rm/qxRZ05QQOv04Kx/JOw
         7ukjxZpMj+1FcQbQVIIf0g515j/QQOJeVvGC7AEM0RqjBQOmD2UgQTmSfnGSfLleiYTT
         lq/JsG6aBW/9Dj2cgmC6M3w4ZV59tVnZ4+6pb1Eo2teQiY3okS/5hW75yok17wb9hjQl
         PktHq9hjF8qyRw63CGRWDy6kdMvd76nkBd1oxfehJ3PiLfMuHvdpJ/QQuCuyUnTDRD3C
         rtkMFkVeSaNARX3MDrnSRaRs8LsDe+ugcxAORH8qukqZ72RvkEXUJ9/QU34x+cEUAoOa
         LUgg==
X-Gm-Message-State: ACrzQf3IbYlksXNVww7hAslfK6rsCvEVIWIZ82mz3aAtwC1mSpR5rp1y
        G84fYD59e6GkTl9h+uMLxWE=
X-Google-Smtp-Source: AMsMyM7tAt08H9wi4xyZeJBcNSZn16lwCf112pGFyG0dfvumnBJzmLbuPTDU510QPeqh/5hR/KqEyg==
X-Received: by 2002:a05:6402:a47:b0:462:a70e:31a6 with SMTP id bt7-20020a0564020a4700b00462a70e31a6mr36472039edb.233.1667583293859;
        Fri, 04 Nov 2022 10:34:53 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id j1-20020a17090623e100b007030c97ae62sm2044787ejg.191.2022.11.04.10.34.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 10:34:53 -0700 (PDT)
Date:   Fri, 4 Nov 2022 19:34:51 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] dt-bindings: net: nxp,sja1105: document spi-cpol/cpha
Message-ID: <20221104173451.62fg5qqkfdutfdvh@skbuf>
References: <20221104171557.95871-1-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221104171557.95871-1-krzysztof.kozlowski@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 04, 2022 at 01:15:57PM -0400, Krzysztof Kozlowski wrote:
> Some boards use SJA1105 Ethernet Switch with SPI CPHA, while ones with
> SJA1110 use SPI CPOL, so document this to fix dtbs_check warnings:
> 
>   arch/arm64/boot/dts/freescale/fsl-lx2160a-bluebox3.dtb: ethernet-switch@0: Unevaluated properties are not allowed ('spi-cpol' was unexpected)
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> 
> ---
> 
> Changes since v2:
> 1. Add allOf:if:then, based on feedback from Vladimir.
> 
> Changes since v1:
> 1. Add also cpha
> ---
>  .../bindings/net/dsa/nxp,sja1105.yaml         | 27 ++++++++++++++++---
>  1 file changed, 23 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
> index 1e26d876d146..ac66af3fdd82 100644
> --- a/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
> @@ -12,10 +12,6 @@ description:
>    cs_sck_delay of 500ns. Ensuring that this SPI timing requirement is observed
>    depends on the SPI bus master driver.
>  
> -allOf:
> -  - $ref: "dsa.yaml#"
> -  - $ref: /schemas/spi/spi-peripheral-props.yaml#
> -
>  maintainers:
>    - Vladimir Oltean <vladimir.oltean@nxp.com>
>  
> @@ -36,6 +32,9 @@ properties:
>    reg:
>      maxItems: 1
>  
> +  spi-cpha: true
> +  spi-cpol: true
> +

Why set to true only to set to false under allOf? Can't set to true in allOf?

>    # Optional container node for the 2 internal MDIO buses of the SJA1110
>    # (one for the internal 100base-T1 PHYs and the other for the single
>    # 100base-TX PHY). The "reg" property does not have physical significance.
> @@ -109,6 +108,26 @@ $defs:
>         1860, 1880, 1900, 1920, 1940, 1960, 1980, 2000, 2020, 2040, 2060, 2080,
>         2100, 2120, 2140, 2160, 2180, 2200, 2220, 2240, 2260]
>  
> +allOf:
> +  - $ref: dsa.yaml#
> +  - $ref: /schemas/spi/spi-peripheral-props.yaml#
> +  - if:
> +      properties:
> +        compatible:
> +          enum:
> +            - nxp,sja1105e
> +            - nxp,sja1105t
> +            - nxp,sja1105p
> +            - nxp,sja1105q
> +            - nxp,sja1105r
> +            - nxp,sja1105s
> +    then:
> +      properties:
> +        spi-cpol: false
> +    else:
> +      properties:
> +        spi-cpha: false
> +

The properties should probably also be 'required', since the hardware
doesn't work if they aren't present (omitting them changes the SPI mode
to 0).
