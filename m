Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 817F2660073
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 13:45:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbjAFMpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 07:45:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232992AbjAFMpB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 07:45:01 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11E7774580
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 04:45:00 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id c65-20020a1c3544000000b003cfffd00fc0so3460522wma.1
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 04:44:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4CcYfNDCdkNRPfZfJSmi+1aQkd/P/7ArECeWhjMr1V0=;
        b=b83V4olBWBynd3RZWkoGlDOyYAfO7STAnj82h8oM+CH/sf8n6Qqhvt9lN52tTGBwhz
         JjyltO2oIr2R+bKARi0UXQ0gY2t3nwimCCgFYN1RRrpmMJoUQV6Alcy7itwkiSNcAEvG
         TUQgZZQtSO3GsT2OasGzqdpL335+F9nuQ28HLRufut2k1Wu9FeuaT1JQwSMWnVjlk/4H
         0JP8sOxf/JQZPJfCHbwVGVz8JdiSrfcFvH7uE73KyWnHx9UU/GasmoFSCDSh0j2ug5Ox
         SZMnlaYOVsdBi8lNDdx+JcOiT0CHoVUZ6KytZ6JhJuhAmnDK8OwXqsCyB81Um6sDskWG
         mG8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4CcYfNDCdkNRPfZfJSmi+1aQkd/P/7ArECeWhjMr1V0=;
        b=bMhD1E/VOYt36Sh3lcCSvyUDdP27Q2+3EJn4yiqwbFxQXo+2z/4tOEU8Bh/Dki8ANg
         GPOtQXH2EiVFFK3hRS2279LOGJiLJz1/xYN5mpCoQEcVdU3ueOC+OR0dsy11M1nk0eXg
         TZwGl+r0gHPNkkKHbN1ldEfFlVyd4+AkX5W0+RwfvykgZop1ZUIlfAXthoWqpzxagUhI
         375cHbu3JWhSf29fpBWvQwr+ZNWRuqFlF9y/C0krteSzDGSvIhOKeGYWGqPolPwDcbdk
         lqAEYpSOM2M6VKxgwjATMlfdmMe98jiIMj6hUSEgpApzfWiWot81PZf/yTuSpJVNvk0p
         xhmQ==
X-Gm-Message-State: AFqh2krCvyDDeggxKimCT+iWGzOLTz+nCjYXmTh23FwfpCh1O5t52EGT
        zrbWz0DkYCoEl0gxnwZexwpZhg==
X-Google-Smtp-Source: AMrXdXs0Nw0FZGgzY+MbYpwEJPNEUUEFQs5u3nLUhhi811FU6DLWMstSY+bcsMkqkjrS4iaYBZzupQ==
X-Received: by 2002:a1c:2b04:0:b0:3d3:4f28:40c6 with SMTP id r4-20020a1c2b04000000b003d34f2840c6mr38207151wmr.1.1673009098662;
        Fri, 06 Jan 2023 04:44:58 -0800 (PST)
Received: from [192.168.1.102] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id z14-20020a05600c220e00b003d99fad7511sm1549137wml.22.2023.01.06.04.44.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jan 2023 04:44:58 -0800 (PST)
Message-ID: <2328562d-59a2-f60e-b17b-6cf16392e01f@linaro.org>
Date:   Fri, 6 Jan 2023 13:44:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v3 2/7] dt-bindings: net: snps,dwmac: Update the maxitems
 number of resets and reset-names
Content-Language: en-US
To:     Yanhong Wang <yanhong.wang@starfivetech.com>,
        linux-riscv@lists.infradead.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>
References: <20230106030001.1952-1-yanhong.wang@starfivetech.com>
 <20230106030001.1952-3-yanhong.wang@starfivetech.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230106030001.1952-3-yanhong.wang@starfivetech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/01/2023 03:59, Yanhong Wang wrote:
> Some boards(such as StarFive VisionFive v2) require more than one value
> which defined by resets property, so the original definition can not
> meet the requirements. In order to adapt to different requirements,
> adjust the maxitems number definition.
> 
> Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
> ---
>  .../devicetree/bindings/net/snps,dwmac.yaml   | 36 ++++++++++++++-----
>  1 file changed, 28 insertions(+), 8 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> index e26c3e76ebb7..f7693e8c8d6d 100644
> --- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> @@ -132,14 +132,6 @@ properties:
>          - pclk
>          - ptp_ref
>  
> -  resets:
> -    maxItems: 1
> -    description:
> -      MAC Reset signal.
> -
> -  reset-names:
> -    const: stmmaceth
> -
>    power-domains:
>      maxItems: 1
>  
> @@ -463,6 +455,34 @@ allOf:
>              Enables the TSO feature otherwise it will be managed by
>              MAC HW capability register.
>  
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            const: starfive,jh7110-dwmac
> +

Looking at your next binding patch, this seems a bit clearer. First of
all, this patch on itself has little sense. It's not usable on its own,
because you need the next one.

Probably the snps,dwmac should be just split into common parts used by
devices. It makes code much less readable and unnecessary complicated to
support in one schema both devices and re-usability.

Otherwise I propose to make the resets/reset-names just like clocks are
made: define here wide constraints and update all other users of this
binding to explicitly restrict resets.


Best regards,
Krzysztof

