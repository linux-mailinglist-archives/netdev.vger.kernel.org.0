Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1D864E9F0
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 12:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbiLPLDV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 06:03:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230425AbiLPLDM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 06:03:12 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B511D554C4
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 03:03:11 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id bp15so2887293lfb.13
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 03:03:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=d7nxly20Q+LIVX2HmOxQ1kGTZsAtQ7HVnD/+lRVkLcY=;
        b=vnZVddSwK8YrdASi377ehaE4VrYO3wUPvQFEPjVKRpnAIfCK+XqC0pvzUair0sN2qE
         iY/b1b+0ou2Q/iBUxcy7H1n9fq/SnuTe6xbbpWKmFoTbi6znOa8tgMqfJuLg9x/DpfNV
         5lECBlZOsk1XK6QiefewW9dkhuKDPprIbWvls7h47dV/PkrawfzuAVDCvEggpmAZRcFV
         JfdGdQjnhfR8Od6QqxrGUaoC4ZuzPV555VLxxRF1yCMaajaw42XRxXBoXq5yvU1b6UT2
         YUf7EO5N0xHcuqM5+PV19XaHVLOrpwFZDwD5r206/lzKvEzB5VbS+rDKPrIrTwQEzvFi
         7FkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d7nxly20Q+LIVX2HmOxQ1kGTZsAtQ7HVnD/+lRVkLcY=;
        b=osMWiQpvezeScs3WPXhqCuErkaG/HxFdYsInXgPoD2UeharY62brymaa1RzEhWMr7q
         hKP/O6A/lpy9GfhbOHpZluClHHtARHSTfT9A5+ajkmn3PqlN0Uz2DlNqpV2s2R3NrBrS
         9omRHxzY1GU7k4OjXJuZ/RZNVpg/ZubGKEdp4sHFZ+qVdhVKFgFnjCWzkqN/ozDy48KZ
         mDqEKK2ukR1JgTcU0rcNbPIuCF6nymN2bY2uH4R5i8xGgXlpEwroxxkJl5fIUL9vWKPq
         MLviIbFYxbx3aAxPTNzYEjejo9zD4/+2opIBvymym9QXQhAvL04rmo0K7qTzbVWc9fxT
         VlrA==
X-Gm-Message-State: AFqh2kokaf+aYRUiMFk7VcPomR1iAsJ+xcelrDRsAyL8qaUqOt3qo64t
        quW3cIxKY87lE2NM1MBdpRvccA==
X-Google-Smtp-Source: AMrXdXtzOYGUjuX1gxXuTmAU3msYzGH4XwL6Xg8wCGYSpE/H9JfkksbAt5csrE1WhWp9OYhyGEMCaw==
X-Received: by 2002:ac2:5a1c:0:b0:4c0:2c1e:1d5b with SMTP id q28-20020ac25a1c000000b004c02c1e1d5bmr439383lfn.63.1671188589735;
        Fri, 16 Dec 2022 03:03:09 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id g6-20020a056512118600b00494a603953dsm191605lfr.89.2022.12.16.03.03.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Dec 2022 03:03:09 -0800 (PST)
Message-ID: <040b56b1-c65c-34c3-e4a1-5cae4428d1d2@linaro.org>
Date:   Fri, 16 Dec 2022 12:03:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2 2/9] dt-bindings: net: snps,dwmac: Update the maxitems
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
References: <20221216070632.11444-1-yanhong.wang@starfivetech.com>
 <20221216070632.11444-3-yanhong.wang@starfivetech.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221216070632.11444-3-yanhong.wang@starfivetech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/12/2022 08:06, Yanhong Wang wrote:
> Some boards(such as StarFive VisionFive v2) require more than one value
> which defined by resets property, so the original definition can not
> meet the requirements. In order to adapt to different requirements,
> adjust the maxitems number from 1 to 3..
> 
> Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
> ---
>  .../devicetree/bindings/net/snps,dwmac.yaml       | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> index e26c3e76ebb7..7870228b4cd3 100644
> --- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> @@ -133,12 +133,19 @@ properties:
>          - ptp_ref
>  
>    resets:
> -    maxItems: 1
> -    description:
> -      MAC Reset signal.
> +    minItems: 1
> +    maxItems: 3
> +    additionalItems: true
> +    items:
> +      - description: MAC Reset signal
>  
>    reset-names:
> -    const: stmmaceth
> +    minItems: 1
> +    maxItems: 3
> +    additionalItems: true
> +    contains:
> +      enum:
> +        - stmmaceth

No, this is highly unspecific and you know affect all the schemas using
snps,dwmac.yaml. Both lists must be specific - for your device and for
others.

Best regards,
Krzysztof

