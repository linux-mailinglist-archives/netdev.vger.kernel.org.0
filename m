Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8EA063BD6F
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 10:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232049AbiK2J7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 04:59:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231971AbiK2J7j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 04:59:39 -0500
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5F60140EF
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 01:59:37 -0800 (PST)
Received: by mail-lj1-x22a.google.com with SMTP id d9so823934lja.11
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 01:59:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SFIijkM0HF0q5gjzFvrk41exWokqNfWHGRBYYJ1Hpt4=;
        b=v9jYR0msB6pftjlpufll0omMcSmKFtAmrRZpJvtCEr131u6oadvjLEQMda2Pg9P4wP
         5ysUw+yhtVvKO8JGzgEtW70RlfCxrNSzF3DqgSt864yrdQ66t+ZoCfA4uW/fTVndOZ02
         EwtIdEcD/WXvnB/XDvoW3bMZalQkHG4ucTQZolpKohYzJNToZLd1gM+n0gqfbw344+S+
         dXhMlcTo06GENH7Ec9ATETcD/jqC+tYhGCIye/w5W1HFvHfByvm94oryguwgkUR+h3Y9
         DFRjS2g1GU7ykzFK/XItLxb5Qn3koXmi1bH9MRkl1pdUOpLriCNf0nQGIOb8MxYGENvW
         7y+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SFIijkM0HF0q5gjzFvrk41exWokqNfWHGRBYYJ1Hpt4=;
        b=PJPpXNMJQ70zYxo+hj8W3upxTdm2Yy9bTwFXGUdl7JXbr4T/nSA3ztPAdhEAKcDGm8
         bbRlQ/hsZkoLw9zu5i+rrXIOQSPBt43/K6rUHiUEV1qR6rhd6S+TDAfmZ5m/K+NiX17/
         L1JWS2jaBsNKgfsg2tZB4b1jKWT/0dc2ozgKt4jsF+08r+fKlDcKL3Ewc/P8xTdKomkE
         QAqL0uSmq7xHl6w/framIINpxwrKOL/49TkQ//t9ZjJQSkJQtH1sLdy/u9MtEo2qCGov
         pxUTBDXeVZ7xNbh0Hfy/9eZUobPiuecEkHycv5G0D3rO3cK/xNl9Hjt5pDBNFNVSVycs
         G+FA==
X-Gm-Message-State: ANoB5plyUiRZkAFXE1JXFjyKIVYzCGV9BM4MZUWQ82Jhy+ChuUUFptaE
        G70HCO4sRzFliTBU6pkAONQEEeWyRTi+0+u0
X-Google-Smtp-Source: AA0mqf5Eyirs5mjGcg+rR5YKwG9bX5kIwPGrCsU0fsJ1m8wdtY6+P74muvPVllxHDy/SqTHs+3YucA==
X-Received: by 2002:a2e:940f:0:b0:277:5df:9728 with SMTP id i15-20020a2e940f000000b0027705df9728mr11226113ljh.337.1669715976008;
        Tue, 29 Nov 2022 01:59:36 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id s12-20020a056512214c00b004a2c3fd32edsm2137877lfr.144.2022.11.29.01.59.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Nov 2022 01:59:35 -0800 (PST)
Message-ID: <8eb78282-08c2-24bf-4049-5c610dd781fc@linaro.org>
Date:   Tue, 29 Nov 2022 10:59:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 1/2] dt-bindings: net: rockchip-dwmac: add rk3568 xpcs
 compatible
To:     =?UTF-8?Q?Heiko_St=c3=bcbner?= <heiko@sntech.de>,
        Chukun Pan <amadeus@jmu.edu.cn>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Wu <david.wu@rock-chips.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <20221129072714.22880-1-amadeus@jmu.edu.cn>
 <6f601615-deab-a1df-b951-dca8467039f8@linaro.org> <4692527.5fSG56mABF@diego>
Content-Language: en-US
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <4692527.5fSG56mABF@diego>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/11/2022 10:56, Heiko Stübner wrote:
> Am Dienstag, 29. November 2022, 09:49:08 CET schrieb Krzysztof Kozlowski:
>> On 29/11/2022 08:27, Chukun Pan wrote:
>>> The gmac of RK3568 supports RGMII/SGMII/QSGMII interface.
>>> This patch adds a compatible string for the required clock.
>>>
>>> Signed-off-by: Chukun Pan <amadeus@jmu.edu.cn>
>>> ---
>>>  Documentation/devicetree/bindings/net/rockchip-dwmac.yaml | 6 ++++++
>>>  1 file changed, 6 insertions(+)
>>>
>>> diff --git a/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml b/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml
>>> index 42fb72b6909d..36b1e82212e7 100644
>>> --- a/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml
>>> +++ b/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml
>>> @@ -68,6 +68,7 @@ properties:
>>>          - mac_clk_rx
>>>          - aclk_mac
>>>          - pclk_mac
>>> +        - pclk_xpcs
>>>          - clk_mac_ref
>>>          - clk_mac_refout
>>>          - clk_mac_speed
>>> @@ -90,6 +91,11 @@ properties:
>>>        The phandle of the syscon node for the peripheral general register file.
>>>      $ref: /schemas/types.yaml#/definitions/phandle
>>>  
>>> +  rockchip,xpcs:
>>> +    description:
>>> +      The phandle of the syscon node for the peripheral general register file.
>>
>> You used the same description as above, so no, you cannot have two
>> properties which are the same. syscons for GRF are called
>> "rockchip,grf", aren't they?
> 
> Not necessarily :-) .

OK, then description should have something like "...GRF for foo bar".


Best regards,
Krzysztof

