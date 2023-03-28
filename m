Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62C696CBE3E
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 13:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232291AbjC1L5h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 07:57:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbjC1L5g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 07:57:36 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CACF7693
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 04:57:35 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id b20so48625746edd.1
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 04:57:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680004654;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RG+eTwEqbkDSJBi1NatlM7PgeUa0/GUARHfUI0qPaV8=;
        b=GJU2xg/v51vJMedUtpVQWw0Y3xQD+5FOXKikQp26eG4k7VteW4qg1HM/hhw34M3JcH
         UxbYOC3owKvWuKZkLGmsPZpBMJaceloa/V72Zto+Mo5ogbwWUclIrgSgc7X3C/uEvAKE
         HhfcfkUwV6Vh3hwJdjiA+6CTEQ/UnJmHDQz9+7kKj7mLBCBi3gE1Q9x8N1VPrMkxKOZE
         qI5fam5Z0wDD52rk8DoQMe7TRWCEGH8625w6AuRrQiiPm6Ej2LIzCZSNhmmD3IDMjclg
         DFJKcbW9NNMQR3oUoOsCeM7dj0zJU5U8tlpVH6DnMstfqAGcL7750oCpEX2m7TrE3LlE
         DAXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680004654;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RG+eTwEqbkDSJBi1NatlM7PgeUa0/GUARHfUI0qPaV8=;
        b=SsWq1u54loAmOaF/pMI7JR/GsWZF1jnP7DHIvshS2pLN0mwMTwtkTrgaQ8sd1G2E2P
         e1xrispmqq+oHKg/dcFQbu1pSSaPMYpPN1BQzBRD0hMq+Ugi1qmWynGyGhBOcvK8FUeu
         NX/51W2ptAeNa80T0LdPsUQOqKL7pIehdFoYwCA5sUfeRxb7TEHd9MFvvbfrJYSQcpp9
         Z1zZGl20ZFU0VFqL+7VzqI3xRbka2qIdBIWvvdR2+xGSV1DaskF0PKb62V9RC9RfIIoA
         V41gWPzscpH68SCIN/+SUCpsWnRejfdrDMIOQOgzzFR8k1JiuXsRTt3GV0fE5KbKG+PX
         0/UA==
X-Gm-Message-State: AAQBX9dxvwk7LxRwq55m7tw6IwitLfDS82kUIGfA/8TiMbnaOX+HQXDJ
        yMLBAEMuaCzdpqXJtVuW8SDu2w==
X-Google-Smtp-Source: AKy350Y9HnV0VgYg9E5b1ZGdqpAjJYGTnN7BA9rplW9wQdUyqK7zNB5omaIdn9MdcMPSZ20p6qilZw==
X-Received: by 2002:a17:906:8581:b0:93e:3127:fc28 with SMTP id v1-20020a170906858100b0093e3127fc28mr16432912ejx.39.1680004653763;
        Tue, 28 Mar 2023 04:57:33 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:9e92:dca6:241d:71b6? ([2a02:810d:15c0:828:9e92:dca6:241d:71b6])
        by smtp.gmail.com with ESMTPSA id fi9-20020a170906da0900b00931faf03db0sm14919700ejb.27.2023.03.28.04.57.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Mar 2023 04:57:33 -0700 (PDT)
Message-ID: <d216b729-fe96-1128-132f-7104a82f5463@linaro.org>
Date:   Tue, 28 Mar 2023 13:57:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v8 4/6] dt-bindings: net: Add support StarFive dwmac
Content-Language: en-US
To:     Samin Guo <samin.guo@starfivetech.com>,
        linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Jose Abreu <joabreu@synopsys.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Conor Dooley <conor@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>,
        Tommaso Merciai <tomm.merciai@gmail.com>
References: <20230324022819.2324-1-samin.guo@starfivetech.com>
 <20230324022819.2324-5-samin.guo@starfivetech.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230324022819.2324-5-samin.guo@starfivetech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/03/2023 03:28, Samin Guo wrote:
> From: Yanhong Wang <yanhong.wang@starfivetech.com>
> 
> Add documentation to describe StarFive dwmac driver(GMAC).
> 
> Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
> Signed-off-by: Samin Guo <samin.guo@starfivetech.com>


> +  starfive,syscon:
> +    $ref: /schemas/types.yaml#/definitions/phandle-array
> +    items:
> +      - items:
> +          - description: phandle to syscon that configures phy mode
> +          - description: Offset of phy mode selection
> +          - description: Shift of phy mode selection
> +    description:
> +      A phandle to syscon with two arguments that configure phy mode.
> +      The argument one is the offset of phy mode selection, the
> +      argument two is the shift of phy mode selection.
> +
> +allOf:
> +  - $ref: snps,dwmac.yaml#
> +
> +unevaluatedProperties: false
> +
> +required:
> +  - compatible
> +  - reg
> +  - clocks
> +  - clock-names
> +  - interrupts
> +  - interrupt-names
> +  - resets
> +  - reset-names

required: goes after properties:

Just like in example-schema.

*With* fix above:

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

