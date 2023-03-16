Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14BF56BC835
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 09:06:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbjCPIGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 04:06:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230373AbjCPIGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 04:06:25 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0382664B3E
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 01:06:08 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id z21so4199442edb.4
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 01:06:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678953966;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6OsjiDE3NuSgDjET5WMD6UNfNrRCIGptQw+4KyflP4M=;
        b=CwY1cgzXszkGS4WESkxCLBSPnvMH/NZrsLWq2/QLedh/OR5tbm1AMfxmZ6E8ESvi3B
         UW7DKuDh7v7p0idaBeWAoIK4SYgA3wOjjfrMuGEDO7A+fWPHbgbfxW6q/X8JIqCYACGL
         AJAS5SoMevqLaqMZJYrDU6j56SRYBawRkl1YZtIyZPtRenxzp/1VL0x4tU6dJwd8x7W8
         4H1gfbz+pvV4V2dBpwgpkzBOfkHToXFHMaN5l8iWjdci5hNWUirygOsfEh/DjJBbY2UE
         25Rb7LrLzci7lkUI8AR8Yp5p58FzgtFT3tc6L8nIYgvac+Va9/4CKFC1V8ShGjvfFhBK
         drNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678953966;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6OsjiDE3NuSgDjET5WMD6UNfNrRCIGptQw+4KyflP4M=;
        b=OP9JkwaKDkjEMu9P2ZJh5f6evfpZA8P6T7lClO7RT5u2SaFk/Chz1JvEVOC2KpyW+g
         JoUOp9mwtuqjCVEfcHJNx4z+IHuRiq9NLwAEuyIKIvM+w+A2ik7jbu7m+B/F8iwomxnb
         VrRhEnrcJiScLxydQUjz864m7Jft9UXnsoVClNXzhmHW4SKkloinZv/VSl2s8bDnbDME
         fYFBP364+b4HcIt3CX/3TrNQCd+c2WaoYO8/ga2NKCC3cHsitCP5+nz92vH0AWVTSXNW
         jc/r789mc/ary/q69v5QyaVYcvuC4awKJDMNUmVV0kB+7E5Zc5g2cSqEi4ZSPdmCArVv
         ZM+Q==
X-Gm-Message-State: AO0yUKWgAAOJZ8bywHnF1tRmHy10wNRoPFEplhvpT3t5C6YDq0cdhThv
        1VclBUmVJEySpWe78zZDnnxoAA==
X-Google-Smtp-Source: AK7set+0+bYA3DjoEwcKwtIg4+mtWmSsVYB0+wwlaUkKsDgFBzV1Gz6/yFNUpM4ZJuB480jjnWZYuw==
X-Received: by 2002:aa7:c40b:0:b0:4fe:96a9:ab0a with SMTP id j11-20020aa7c40b000000b004fe96a9ab0amr5517331edq.1.1678953966456;
        Thu, 16 Mar 2023 01:06:06 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:9827:5f65:8269:a95f? ([2a02:810d:15c0:828:9827:5f65:8269:a95f])
        by smtp.gmail.com with ESMTPSA id r24-20020a50d698000000b004af71e8cc3dsm3436547edi.60.2023.03.16.01.06.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Mar 2023 01:06:06 -0700 (PDT)
Message-ID: <78224241-00a3-2e8e-4763-603b27ac3b83@linaro.org>
Date:   Thu, 16 Mar 2023 09:06:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next 09/16] dt-bindings: net: dwmac: Prohibit
 additional props in AXI-config
Content-Language: en-US
To:     Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     Serge Semin <fancer.lancer@gmail.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Biao Huang <biao.huang@mediatek.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20230313225103.30512-1-Sergey.Semin@baikalelectronics.ru>
 <20230313225103.30512-10-Sergey.Semin@baikalelectronics.ru>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230313225103.30512-10-Sergey.Semin@baikalelectronics.ru>
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

On 13/03/2023 23:50, Serge Semin wrote:
> Currently DT-schema of the AXI-bus config sub-node prohibits to have
> unknown properties by using the unevaluatedProperties property. It's
> overkill for the sub-node which doesn't use any combining schemas
> keywords (allOf, anyOf, etc). Instead more natural is to use
> additionalProperties to prohibit for that.
> 
> Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
> ---
>  Documentation/devicetree/bindings/net/snps,dwmac.yaml | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> index 89be67e55c3e..d1b2910b799b 100644
> --- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> @@ -466,7 +466,6 @@ properties:
>  
>    stmmac-axi-config:
>      type: object
> -    unevaluatedProperties: false
>      description:
>        AXI BUS Mode parameters.
>  
> @@ -518,6 +517,8 @@ properties:
>          description:
>            rebuild INCRx Burst
>  
> +    additionalProperties: false

But why moving it? Keep the same placement.

Best regards,
Krzysztof

