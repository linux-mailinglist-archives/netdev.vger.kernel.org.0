Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 014BC658A7C
	for <lists+netdev@lfdr.de>; Thu, 29 Dec 2022 09:25:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233067AbiL2IYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 03:24:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbiL2IYP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 03:24:15 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A67E11A16
        for <netdev@vger.kernel.org>; Thu, 29 Dec 2022 00:24:14 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id u12so15050311ljj.11
        for <netdev@vger.kernel.org>; Thu, 29 Dec 2022 00:24:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gBp65jpO3PEExPdtu3hqOSvpNeK/wify2K2KN3pGtSU=;
        b=l9By2aTLtiw1kEWkSbP8F4vkIcYOnHs/y++ZUsVV2tJ3MDW7k6vthjXXa+dFkOGXw/
         7KClNTEWtsZqZ9vOukvaz8GYA6wGf+HICwW8sHN4zC6fiZaCEiN6ROTP/NUnKnHZXJgn
         kxI6VZE6TB0YTYH1TIxqWKBifCIWloTlAxnJqoFHUK9kLZ5ajol8UWhYXnA/C1JjkIQQ
         NvKbfEyFbE8WUc+Ntu2ji+pWFeWI8chiJWDu7jZ0TFSEh2xx8r5zzX2azwFpYkQDi3rh
         CZbcXdp8MqjPA25fNuV1YR3rd8anHIba5bv5psEpBWz51e9DZlVVroW5o8sjwcQlkf+M
         /wmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gBp65jpO3PEExPdtu3hqOSvpNeK/wify2K2KN3pGtSU=;
        b=qBMuFYtc1jubPFs2DJSDunoTeNnb19d1awZZ6XL90PFx74gFAxi0D4Qn/3tilto8eP
         FDo2Af2gfDW4F2tVJp0uFBCH9eTIhuWw4KTblqdxWBNKLf7ts6gESRMCrxXs9yOKrlvb
         Fx75Gyi6yqi/9xj5VepvxDWDw/z4oWmb1vMXar+eWxwKHFErPg6XRzZwj4Pl7QdF/ucW
         NGxT6ox4CHTKv7OUejVublcNiDE+7pN6nfNV0IkFmcxQ6rc3JmtHQts7Xmq4cXhmXm9R
         +fSLtVODpouuM8011sW+Mfwy4XF1uF4IUU2hR2bP0PZutx2kr3BVKGvQBXc5jjSLA/cM
         dMcQ==
X-Gm-Message-State: AFqh2kp6mUyS8Wov1xkZpkVVh9t531No1mba6W4hrRSWG7eo1tz0Io/k
        CWgvCgMAVvLc3WsjZlrZ+FPu/mVMX/X3Rq+K
X-Google-Smtp-Source: AMrXdXtTG6LcBciIa3S5diQyKKuos8SJpSElOgxGtcLp9TTzRopulJQmQfqiinq1ATDSPVppovwd8w==
X-Received: by 2002:a2e:a281:0:b0:277:4450:b334 with SMTP id k1-20020a2ea281000000b002774450b334mr7088827lja.3.1672302252603;
        Thu, 29 Dec 2022 00:24:12 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id u22-20020a2eb816000000b00279f302f652sm2241847ljo.111.2022.12.29.00.24.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Dec 2022 00:24:12 -0800 (PST)
Message-ID: <86e83233-4dde-04dc-ae05-fb38ab774316@linaro.org>
Date:   Thu, 29 Dec 2022 09:24:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2] dt-bindings: net: marvell,orion-mdio: Fix examples
Content-Language: en-US
To:     =?UTF-8?Q?Micha=c5=82_Grzelak?= <mig@semihalf.com>
Cc:     andrew@lunn.ch, chris.packham@alliedtelesis.co.nz,
        davem@davemloft.net, devicetree@vger.kernel.org,
        edumazet@google.com, krzysztof.kozlowski+dt@linaro.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
        upstream@semihalf.com
References: <7f6a2072-f26b-e2f0-9c07-d2ea43c8c4bc@linaro.org>
 <20221228015433.73919-1-mig@semihalf.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221228015433.73919-1-mig@semihalf.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/12/2022 02:54, Michał Grzelak wrote:
> As stated in marvell-orion-mdio.txt deleted in commit 0781434af811f
> ("dt-bindings: net: orion-mdio: Convert to JSON schema") if
> 'interrupts' property is present, width of 'reg' should be 0x84.
> Otherwise, width of 'reg' should be 0x4. Fix 'examples:' and add
> constraints checking whether 'interrupts' property is present
> and validate it against fixed values in reg.
> 
> Signed-off-by: Michał Grzelak <mig@semihalf.com>
> ---
> Changelog:
> v1->v2:
> - remove second example
> - add 'if:' constraint to 'allOf:'
> - move 'allOf:' before 'examples:'
> 
>  .../bindings/net/marvell,orion-mdio.yaml      | 31 ++++++++++++++++---
>  1 file changed, 27 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/marvell,orion-mdio.yaml b/Documentation/devicetree/bindings/net/marvell,orion-mdio.yaml
> index d2906b4a0f59..381cd8edebed 100644
> --- a/Documentation/devicetree/bindings/net/marvell,orion-mdio.yaml
> +++ b/Documentation/devicetree/bindings/net/marvell,orion-mdio.yaml
> @@ -16,9 +16,6 @@ description: |
>    8k has a second unit which provides an interface with the xMDIO bus. This
>    driver handles these interfaces.
>  
> -allOf:
> -  - $ref: "mdio.yaml#"
> -
>  properties:
>    compatible:
>      enum:
> @@ -39,13 +36,39 @@ required:
>    - compatible
>    - reg
>  
> +allOf:
> +

Drop blank line.

> +  - $ref: "mdio.yaml#"

Drop quotes while moving it.

> +
> +  - if:
> +      required:
> +        - interrupts
> +
> +    then:
> +      properties:
> +        reg:
> +          items:
> +            - items:
> +                - $ref: /schemas/types.yaml#/definitions/cell
> +                - const: 0x84
> +
> +    else:
> +      properties:
> +        reg:
> +          items:
> +            - items:
> +                - $ref: /schemas/types.yaml#/definitions/cell
> +                - enum:
> +                    - 0x4
> +                    - 0x10

Rest looks good.

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

