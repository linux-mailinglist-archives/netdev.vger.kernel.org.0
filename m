Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E27226BC83D
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 09:07:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbjCPIHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 04:07:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbjCPIHo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 04:07:44 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CE7C22C81
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 01:07:41 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id o12so4111234edb.9
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 01:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678954059;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7bLCnphtCoYaOUO/XmDnUvbleV00dxya2UA7xOdtlvI=;
        b=u+eyp6tx+NTpuXn9TcIwnNCAck2h5Llecsjso31eMXyMw55rTgUAJjbxIfx+4TSBFT
         UerMzwj+URTf+h3ZeZlH9UodIHFViAIDtRxcpag1TFBBD/XirFhXki9EAHP6ualP6h5V
         eKZ83H+h/c8l+dooQTR62EfkpIVVCq5fvL1YqVWEiYu1axk+x09kIyH6Xy1Il3EDjI1F
         wqk7QYCu2BDUIz5sjqHPS6Ii0Wyt1ZbYc3Rvh9PseXP3Odau93L66r8pAoN2rm5F61vv
         WwpLAsOfcXazaPQ2TRVl+eqc1W/caEl8RE2VqEKDULsDDup+ZHLtVRQ2YvhS+2nXs7tJ
         l+Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678954059;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7bLCnphtCoYaOUO/XmDnUvbleV00dxya2UA7xOdtlvI=;
        b=y/MSLl3kL7Q/Nn0P2fuDh204e/IUJHzl7tQtCHZa3ZD6Hu6gAep8xgz/5+uTLujdG2
         kfd0CbTsPHPTPt7Bl6F5JR4evDGi8kgdLbop1jEXTEO4pAzEt5k5xmybECONGp9WKmkY
         AY2UoveYaOzE+aBOqGN84AuPJi870AEBvLP+1SGxNydEs1W6fYTVLYHn6IzrCQYFrZn8
         L8y1UrQSXv8QNFLRdsY/oAwrVDL91bsH2Gb73lK6Z5C3xt9NHjRz0i5BEwgN2B15nlCk
         UFcEN6ytfIdtuy62vaF+vM1y1gcMwSANiL7lCro6nyLL4At3Z3LrFMXWXO76gISPTJ+L
         hI3Q==
X-Gm-Message-State: AO0yUKVbBbGd4wXZhhrqEsd7yiBvRtW0eHGvpqMJJ0PzAz64+o5GHl7q
        Sf11kZ4FsB+9EIUPvqZK63KbwA==
X-Google-Smtp-Source: AK7set9E8pty3V37QE7on6sEyxDO7T6KMKBPBTC0gYLiXURZICca8Wpt50shKAdyoNuvMjlI8HEp2A==
X-Received: by 2002:a17:906:bc8f:b0:8e8:602f:847a with SMTP id lv15-20020a170906bc8f00b008e8602f847amr9762171ejb.24.1678954059599;
        Thu, 16 Mar 2023 01:07:39 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:9827:5f65:8269:a95f? ([2a02:810d:15c0:828:9827:5f65:8269:a95f])
        by smtp.gmail.com with ESMTPSA id z17-20020a1709064e1100b008b69aa62efcsm3527336eju.62.2023.03.16.01.07.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Mar 2023 01:07:39 -0700 (PDT)
Message-ID: <543fe511-5d04-f3d9-503e-968d3b1a6f6a@linaro.org>
Date:   Thu, 16 Mar 2023 09:07:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next 11/16] dt-bindings: net: dwmac: Add MTL Rx Queue
 properties constraints
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
 <20230313225103.30512-12-Sergey.Semin@baikalelectronics.ru>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230313225103.30512-12-Sergey.Semin@baikalelectronics.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/03/2023 23:50, Serge Semin wrote:
> Currently none of the MTL Rx Queues QoS-related DT-properties have been
> equipped with the proper constraints. Meanwhile they can be specified at
> least based on the corresponding CSR field sizes or the DW (x|xG)MAC
> IP-core synthesize parameter constraints. Let's do that:
> + snps,rx-queues-to-use - number of Rx queues to utilise is limited w

(...)

> +
>            snps,route-avcp:
>              type: boolean
>              description: AV Untagged Control packets
> @@ -166,6 +173,9 @@ properties:
>            snps,priority:
>              $ref: /schemas/types.yaml#/definitions/uint32
>              description: Bitmask of the tagged frames priorities assigned to the queue
> +            minimum: 0
> +            maximum: 0xFF
> +

lowercase hex

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

