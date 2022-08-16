Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC23F595633
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 11:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbiHPJ1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 05:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233505AbiHPJ1D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 05:27:03 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EA0F124BE5
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 00:44:27 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id u3so13688671lfk.8
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 00:44:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=eW0BKLF2qOs6HIKXDGD1nZcnaClG8yzeNVvRjOtKgmU=;
        b=NKHDJ5lh18mKPYLkddbp9+8g8sxcFvRUMNfHAepw1zkXD8tklVH3aFMh4ewDTGW4LT
         esafB0wz+2fli6fob89gOZ9oQQ2UKbuceCJxU8kQEvqKF765GSS8UjkOjAeAru/M+28G
         H2jeuXm6zbphb2hf+Us4CDZ8OiLys6TTWmyt0lMX8g6PK3/CGnYeBeEOY4jAt7zZplUt
         cp+K4YmLhhI0+MwWCr3+9Et7wwTfbXOej2jq50J38qV6EIa6ygEbM2w8ou72HhMxvUrb
         BWQ6uFs+fqKvyNnuel2HyQuPTUvcJXqdYMbm31sQDaSwGcWPiR5KIXwXjaAyAMNcexyz
         vsPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=eW0BKLF2qOs6HIKXDGD1nZcnaClG8yzeNVvRjOtKgmU=;
        b=XQLhlYi1ZceO0UHUZmgurMVL+uzWr9km/8L8eOeLv3Bv19lbO13FVBxa+O90kcFsr/
         PHqacupu47gIudzCihLGJU1xMFntxYYDgUg96W2V21zvQ3eeJLiX6HKxjzuED6rpyC9e
         qIPmkz+xlQZ8GVvodIyO4TO/7mrP2Q01ZiYtwIq1lHD3g85mGaym349myNtYNonrBhOq
         T2DaZJGJ+MuiXRnjZOqZ1X5mhF0uJ51Sa1KCoD4Zcc9F+PzUWGBumyHYtBuC+aq7Dj1X
         rlLyCGhqkac9rZFpvmSAJpj0EF2qys3lXLvNim1IZfDXKoDMB9o9mKBo7lc6r2gZcMrA
         Q09w==
X-Gm-Message-State: ACgBeo2ztOF5UA0vsaw5ixtJqrwTbo/M3KRTACEUusv1JwEaCkiiT5hn
        +fcFWyEDdo5DaVixOICOIlYFNg==
X-Google-Smtp-Source: AA6agR5IU5HhckObuSpdlJNkE+m2kU5ia/mfjOH6wJr3dBTV9VK8I9kwEk18VjBw1XMcM01PIAtuyQ==
X-Received: by 2002:a05:6512:2a8d:b0:48b:7f1:fe46 with SMTP id dt13-20020a0565122a8d00b0048b07f1fe46mr6171564lfb.261.1660635865972;
        Tue, 16 Aug 2022 00:44:25 -0700 (PDT)
Received: from ?IPV6:2001:14bb:ae:539c:1782:dd68:b0c1:c1a4? (d15l54g8c71znbtrbzt-4.rev.dnainternet.fi. [2001:14bb:ae:539c:1782:dd68:b0c1:c1a4])
        by smtp.gmail.com with ESMTPSA id v8-20020ac25928000000b0048a918717c3sm1304392lfi.57.2022.08.16.00.44.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Aug 2022 00:44:25 -0700 (PDT)
Message-ID: <79e58157-f8f2-6ca8-1aa6-b5cf6c83d9e6@linaro.org>
Date:   Tue, 16 Aug 2022 10:44:23 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v4 1/3] dt-bindings: net: ti: k3-am654-cpsw-nuss: Update
 bindings for J7200 CPSW5G
Content-Language: en-US
To:     Siddharth Vadapalli <s-vadapalli@ti.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        linux@armlinux.org.uk, vladimir.oltean@nxp.com,
        grygorii.strashko@ti.com, vigneshr@ti.com, nsekhar@ti.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, kishon@ti.com
References: <20220816060139.111934-1-s-vadapalli@ti.com>
 <20220816060139.111934-2-s-vadapalli@ti.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220816060139.111934-2-s-vadapalli@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/08/2022 09:01, Siddharth Vadapalli wrote:
> Update bindings for TI K3 J7200 SoC which contains 5 ports (4 external
> ports) CPSW5G module and add compatible for it.
> 
> Changes made:
>     - Add new compatible ti,j7200-cpswxg-nuss for CPSW5G.
>     - Extend pattern properties for new compatible.
>     - Change maximum number of CPSW ports to 4 for new compatible.
> 
> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
> ---
>  .../bindings/net/ti,k3-am654-cpsw-nuss.yaml     | 17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
> index b8281d8be940..5366a367c387 100644
> --- a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
> +++ b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
> @@ -57,6 +57,7 @@ properties:
>        - ti,am654-cpsw-nuss
>        - ti,j721e-cpsw-nuss
>        - ti,am642-cpsw-nuss
> +      - ti,j7200-cpswxg-nuss

Keep some order in the list, so maybe before j721e.

>  
>    reg:
>      maxItems: 1
> @@ -110,7 +111,7 @@ properties:
>          const: 0
>  
>      patternProperties:
> -      port@[1-2]:
> +      "^port@[1-4]$":
>          type: object
>          description: CPSWxG NUSS external ports
>  
> @@ -119,7 +120,7 @@ properties:
>          properties:
>            reg:
>              minimum: 1
> -            maximum: 2
> +            maximum: 4
>              description: CPSW port number
>  
>            phys:
> @@ -151,6 +152,18 @@ properties:
>  
>      additionalProperties: false
>  
> +if:

This goes under allOf just before unevaluated/additionalProperties:false


Best regards,
Krzysztof
