Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7CB6BC84C
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 09:09:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbjCPIJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 04:09:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230184AbjCPIJn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 04:09:43 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 412ED7C965
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 01:09:40 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id ek18so4193383edb.6
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 01:09:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678954179;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qsSpi02AtRNWSprHN4Cl76ayMyVQlvN90GOQNuiLzbY=;
        b=iOdoB48DSlJTxzYGvDakUwMgdpYpWIUL4nfKitoVvMKmpNSyhwjFVq5uG8uzBnOUTW
         x/rivZ/fOZlHihUW0EUlamLr9+U3JqiPhma3II2aEWX2H2cN7KeBfxWXgOitFL3S3jca
         duHj69oaASj2MjNwQZd1rqfDb0suikr7FoD5Rc5SckWkmQMaf3gOUAH8b2ejtUmFp3Lb
         aWFIeNUEtYqYQzPS2/LdlPFDEjFTr34eqfTcbB6ICYL3fwBAQbhXVRairVx5zmKMFpss
         i7boP9CRkkaiO7mbTly7kJanoyzHwc5jtEGZbGklG1O0kvBZlUg+GVImBpiIFZgSS2tz
         fjwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678954179;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qsSpi02AtRNWSprHN4Cl76ayMyVQlvN90GOQNuiLzbY=;
        b=kRv34DxRGOCxYl1/KUujMBp+aHgWWPgf9/BNjHb6BHdfR78w5AQK5WW7gxuAbVNubE
         3GbrWtZbkkMN8smrfjnyym5dFaZ0uxEY5eZDqu9C1UrmJDKK82+qcpkZ6JZ6TK7orxJu
         MPu87lZx9kFcGAkrpERfhm+uipBm1R/XfY5LYsaU/mA9FdSP2UTQUtNhMNLL4vkS7HbK
         mgWEjweVi6YDzGrCPMMMwIl/Sg91XEgsNInVF5Ig8Iut3/0WKCAxLZpE/Sfa5dJQSZ9U
         LXEfyCJpFM5hMUUqpBa1n0E8+zbbc7cjGkd+sXGaaAWoyhIxdZchzO50OXaWAD4a94pZ
         WB4g==
X-Gm-Message-State: AO0yUKUxA2Y9Mpa7dyoV9u1zWVCmJYNW7yBuijKRM5lrcj5r2hlDQNLD
        tzjVrEA2a5m/9JGQUb7tD5vIuQ==
X-Google-Smtp-Source: AK7set9qRwS9KK6hBBohaRF3L5B2ru2zJVrTS4WbmbGRiLcPQJ7BzlvfGx8yi9xnXwYWSRhxP+9xSg==
X-Received: by 2002:a17:907:c22:b0:930:1178:2220 with SMTP id ga34-20020a1709070c2200b0093011782220mr2685504ejc.40.1678954178709;
        Thu, 16 Mar 2023 01:09:38 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:9827:5f65:8269:a95f? ([2a02:810d:15c0:828:9827:5f65:8269:a95f])
        by smtp.gmail.com with ESMTPSA id td10-20020a1709078c8a00b009256a5c3b2dsm3559556ejc.90.2023.03.16.01.09.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Mar 2023 01:09:38 -0700 (PDT)
Message-ID: <faf70823-f87b-ba50-ac72-3552de1cc7e3@linaro.org>
Date:   Thu, 16 Mar 2023 09:09:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next 14/16] dt-bindings: net: dwmac: Use flag
 definition instead of booleans
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
 <20230313225103.30512-15-Sergey.Semin@baikalelectronics.ru>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230313225103.30512-15-Sergey.Semin@baikalelectronics.ru>
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

On 13/03/2023 23:51, Serge Semin wrote:
> Currently some of the boolean properties defined in the DT-schema are
> marked to have the basic boolean type meanwhile the rest referencing the
> /schemas/types.yaml#/definitions/flag schema. For the sake of unification
> let's convert the first group to referencing the pre-defined flag schema.
> Thus bindings will look a bit more coherent and the DT-bindings
> maintainers will have a better control over the booleans defined in the
> schema (if ever needed).
> 
> Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
> ---
>  .../devicetree/bindings/net/snps,dwmac.yaml   | 45 ++++++++++++-------
>  1 file changed, 30 insertions(+), 15 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> index 69be39d55403..a863b5860566 100644
> --- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> @@ -120,11 +120,13 @@ properties:
>          maximum: 12
>  
>        snps,rx-sched-sp:
> -        type: boolean
> +        $ref: /schemas/types.yaml#/definitions/flag
>          description: Strict priority

If ever touching this, it should be other way -> boolean.

Best regards,
Krzysztof

