Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BDB6619680
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 13:47:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbiKDMrP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 08:47:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbiKDMrN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 08:47:13 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0EF92D773
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 05:47:12 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id z30so2913522qkz.13
        for <netdev@vger.kernel.org>; Fri, 04 Nov 2022 05:47:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=37mgEruhzOSlqZ+AcYORFybB/gGWQo+VZHLBQmJiMoM=;
        b=BVPbR9YsKWOme9ZskiqPQIIYzkD0tcEbm0Ea2nXnJVjjtKtLQKQVwbHTWyguqA8GeE
         ZwozPyIy5A6dk/u/qj7ncM6caMoIYS+anC+qd8K4yYooPBO3lEU4UUCYi4FdTnJoDZ4p
         fuGN0x0M3TmDKalqBjCWwUpo+uBDOYiRF2t0sXDbsHO2i2yFaVh3gQjOV9S4FW/BQNaK
         2uUjMcAb8hs30Xwlsccpbiqja6C8yUEnkWLorpi4B7hVzwitqjZqV6N9HM2OkINh/lYN
         FazpP+Md6bRPr3+V4fAdSp1r8YblbiO8T2MY0/nUhgNGJZJU1yxXv7CNdOIqYfK0XPoe
         9KIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=37mgEruhzOSlqZ+AcYORFybB/gGWQo+VZHLBQmJiMoM=;
        b=WoKIzYWsSiij9cZiPqXLcN69VJTc/OKwSPaz9ytodHdb7VDh8GiGNsW5z55X6jQP/t
         Yl4u9uwlKbyP+Vz3+xxsGADLT9SwL5yz45bvlLrqBLzElY91/0kLxbPRfieojwYm1js7
         m88cYtp1ORg+N+U0w3bxVfstoISCU5vlc6XsOUlEQyCzUbnHr0XH/EG5sDFu5EEvTEk7
         yAHXLHcpE9JQdFyHOMILPW2gAFF3w4abn/+rkSeIiEixqrp8vBFH/85Jh/bXkYxfGLIb
         +DAz5ulu3SEbdJ69SoYqb99ri7v7nWu+mNHA72E3Geh3MxduDryWxSaC/7scaIWB70Mk
         YTwg==
X-Gm-Message-State: ACrzQf3OceROQKxpjYjnmZ+b7QQSXbJJgLEwud/2dxOcxEmnqzemd1qi
        H/BY5bteBMyjoeM36gBVtRHiBQ==
X-Google-Smtp-Source: AMsMyM4Nvwfygk8PY62m55LKV09JKXF4xGrl6XXRn5kN1Ai92ahoM1HKa+1rJFx5/fpc8z08WJIEpg==
X-Received: by 2002:a05:620a:138d:b0:6fa:2e05:6083 with SMTP id k13-20020a05620a138d00b006fa2e056083mr20187243qki.287.1667566031861;
        Fri, 04 Nov 2022 05:47:11 -0700 (PDT)
Received: from ?IPV6:2601:586:5000:570:aad6:acd8:4ed9:299b? ([2601:586:5000:570:aad6:acd8:4ed9:299b])
        by smtp.gmail.com with ESMTPSA id bi11-20020a05620a318b00b006eeca296c00sm2770054qkb.104.2022.11.04.05.47.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Nov 2022 05:47:11 -0700 (PDT)
Message-ID: <9fca87df-c879-828c-84c3-a870bbd87038@linaro.org>
Date:   Fri, 4 Nov 2022 08:47:09 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 3/4] arm64: dts: fsd: Add Ethernet support for FSYS0 Block
 of FSD SoC
Content-Language: en-US
To:     Sriranjani P <sriranjani.p@samsung.com>, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        devicetree@vger.kernel.org,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Jayati Sahu <jayati.sahu@samsung.com>
References: <20221104120517.77980-1-sriranjani.p@samsung.com>
 <CGME20221104115902epcas5p209442971ba9f4cb001a933bda3c50b25@epcas5p2.samsung.com>
 <20221104120517.77980-4-sriranjani.p@samsung.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221104120517.77980-4-sriranjani.p@samsung.com>
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

On 04/11/2022 08:05, Sriranjani P wrote:
> The FSD SoC contains two instances of Synopsys DWC QoS Ethernet IP, one
> in FSYS0 block and other in PERIC block.
> 
> Adds device tree node for Ethernet in FSYS0 Block and enables the same for
> FSD platform.
> 
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
> Cc: Richard Cochran <richardcochran@gmail.com>
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> Signed-off-by: Jayati Sahu <jayati.sahu@samsung.com>
> Signed-off-by: Sriranjani P <sriranjani.p@samsung.com>
> ---

Please use scripts/get_maintainers.pl to get a list of necessary people
and lists to CC.  It might happen, that command when run on an older
kernel, gives you outdated entries.  Therefore please be sure you base
your patches on recent Linux kernel.

Best regards,
Krzysztof

