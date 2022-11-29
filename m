Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C99AA63BC07
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 09:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbiK2It4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 03:49:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231314AbiK2Itq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 03:49:46 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97FFC43867
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 00:49:11 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id u27so10390121lfc.9
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 00:49:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mGJb0UounTi8KWPK2n4bjkcjwSmfoW8kL6mvWjcFb4c=;
        b=OyJHgl/U0Ekh2F3VJGU0DzAvt4K/jt1fTBZw+EMuOmEid3o6yHxV6g8Ox9HCScaHXU
         POBxVFLTzRpbNAYvh5ujrpoH3UqAgckzt7+B7kdjlsh4E6hsX4g7ps+GjDzMnHpX6ItL
         23m/tCD+cUOVHL1/ig4BkSZ8WB8/9aJljRFKDC7zfTJQjKV82uR/kQPYfyqYnSZ5WUU7
         w0uW+ihdaCPubIlXoOFGVhpXWDUglTNyf4Kkc3WgT/0+j4uZ0tphQ8CSxK/w7WY+AAGQ
         EEeJnwljePfrBxdtJoy53qrEOW0I1lRg9Gr0Yuo5wOFYsa7+rOW4hOzzRODJOti7pTLJ
         leAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mGJb0UounTi8KWPK2n4bjkcjwSmfoW8kL6mvWjcFb4c=;
        b=UG9Rzh5gCdhEEWWrMLqSWiEuVBWEFJqZq1Xpuopl5OY4un9HfbyFjEK2XdOHjJdygU
         x8qjz3TKRYvCO21Q2g//s2BsMnB1DHACUFvgwhH1GOe2J3m3Tb3BEEy3zYX7ClD6d8Sy
         wS7uUBK7IP9cwqZuK3M1lG5UWs100HzoS1QU1CWYRpmvJnG7ZUWmT57rjhvKcOdbGKqB
         vgmrbKqM8k2dxtfyOZnGX/9t7M050jtNma6ZpIQ190rybp4di7MHW8KyFrsn6a+NO1ez
         YEjITvksJio5D+Q8lUrqpZcaKxf1oRA1TRGasupSrPWnUSHA9QyTZZ4+jnnsLpxPy5Um
         aQOQ==
X-Gm-Message-State: ANoB5plckOnv6fVvtv7fTtCy2v0S2ADAgO08gtBUfWLJFMYEBI6YcPRN
        IQF5CZQLy0AuZdpz9J0WEpks8Q==
X-Google-Smtp-Source: AA0mqf6mX13/IBL/pDIvHjX/0YK6WjThDrOkT/RbE3UdC7rLxGgaO1YlLG5VTFhVULx2UJwc9liXYA==
X-Received: by 2002:a05:6512:33d2:b0:4b5:28fc:36e1 with SMTP id d18-20020a05651233d200b004b528fc36e1mr310302lfg.179.1669711749947;
        Tue, 29 Nov 2022 00:49:09 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id c13-20020a056512324d00b004b40f2e25d3sm2131854lfr.122.2022.11.29.00.49.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Nov 2022 00:49:09 -0800 (PST)
Message-ID: <6f601615-deab-a1df-b951-dca8467039f8@linaro.org>
Date:   Tue, 29 Nov 2022 09:49:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 1/2] dt-bindings: net: rockchip-dwmac: add rk3568 xpcs
 compatible
Content-Language: en-US
To:     Chukun Pan <amadeus@jmu.edu.cn>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Wu <david.wu@rock-chips.com>,
        Rob Herring <robh+dt@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <20221129072714.22880-1-amadeus@jmu.edu.cn>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221129072714.22880-1-amadeus@jmu.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/11/2022 08:27, Chukun Pan wrote:
> The gmac of RK3568 supports RGMII/SGMII/QSGMII interface.
> This patch adds a compatible string for the required clock.
> 
> Signed-off-by: Chukun Pan <amadeus@jmu.edu.cn>
> ---
>  Documentation/devicetree/bindings/net/rockchip-dwmac.yaml | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml b/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml
> index 42fb72b6909d..36b1e82212e7 100644
> --- a/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml
> +++ b/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml
> @@ -68,6 +68,7 @@ properties:
>          - mac_clk_rx
>          - aclk_mac
>          - pclk_mac
> +        - pclk_xpcs
>          - clk_mac_ref
>          - clk_mac_refout
>          - clk_mac_speed
> @@ -90,6 +91,11 @@ properties:
>        The phandle of the syscon node for the peripheral general register file.
>      $ref: /schemas/types.yaml#/definitions/phandle
>  
> +  rockchip,xpcs:
> +    description:
> +      The phandle of the syscon node for the peripheral general register file.

You used the same description as above, so no, you cannot have two
properties which are the same. syscons for GRF are called
"rockchip,grf", aren't they?


Best regards,
Krzysztof

