Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A310C619688
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 13:48:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231940AbiKDMsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 08:48:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231903AbiKDMsd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 08:48:33 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1D3CBE1
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 05:48:31 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id g10so2940984qkl.6
        for <netdev@vger.kernel.org>; Fri, 04 Nov 2022 05:48:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wqi3a7cqHo4gFUwQ2K8FyfWJWVq426ywagQKpCR6FTQ=;
        b=ceYrr4P00mg2C+4LXesfpJ2xHjDKHdtvHNKCey4w9AOIBHLXMjmQIsKUhWfypjJryJ
         oWq1DVFTeKx2bb3TOHIy84crddZ+w0Uk4EISB6W0OYMDRcPpXoCxDFjKbsiJOzrbXxq0
         szAr9OIV1X2DxT4VSzxs8m3mofyW6/xv/m+e8vru1aEUPV9xhDUE4FKM4u8MywqYr+Ob
         n/5OwmJAyDQhUNsresN9GUFsYuJOhjBFrnmXpmkJTd4l4TWy9GikmG3M7JOB204EJQe/
         yRrcrtAlZ0pPD1GbBMLa6bXszAGAopdxZfE2sywzAK+Jeq001QhFcTzUvtfS335heTsa
         9Few==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wqi3a7cqHo4gFUwQ2K8FyfWJWVq426ywagQKpCR6FTQ=;
        b=vzaou5elZPTbAbMcKIuEL6T9jRfwzqU3U+oBP8kY4wL7spb04q4bRqhgyQvCVkH/Tw
         lhzxswiP/wU+6Ej1LLCwrt/5VeqCV+7ZWKabn3h9j/REHJevecb7zwnvzsepf/I1qjrA
         wJIUfoLSYU55BVY6bjBOSEX2rqgjIBjWG55cqmuw4awJrivk+L82JiKzO+L1PfNKUnj0
         O+CNeHOu7CyIqv/+op0Zqhh5jMAxwMxLnf60S386kWnB5iHiaf5NojzqVrD8avgIz0Ks
         kNmzDfrDTO5kCQ4gmsiN6C2J8Sx9jFxn1V91DwlB4en0F4Ee4dIOlW+tonutLqWeLBEC
         ayyQ==
X-Gm-Message-State: ACrzQf0abzwKXZbagKR8qn3oW/LOc2yNYII2VLhkCErKOmH2oRWs4yz1
        nv2aPUuTcio+5Lonoper5TI/GA==
X-Google-Smtp-Source: AMsMyM7hFBnhwzxMdmYULTQCkhwuO6DS/PcegMqy/ry3a33q/5BTspu8Y7iX3IJ6fzly0f3yRTxyig==
X-Received: by 2002:a05:620a:22cf:b0:6fa:1e61:9cda with SMTP id o15-20020a05620a22cf00b006fa1e619cdamr22976665qki.774.1667566110890;
        Fri, 04 Nov 2022 05:48:30 -0700 (PDT)
Received: from ?IPV6:2601:586:5000:570:aad6:acd8:4ed9:299b? ([2601:586:5000:570:aad6:acd8:4ed9:299b])
        by smtp.gmail.com with ESMTPSA id x8-20020ac85388000000b0039cc82a319asm2311507qtp.76.2022.11.04.05.48.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Nov 2022 05:48:30 -0700 (PDT)
Message-ID: <a764159c-e67e-1ee7-4b0f-1a08a06b3b3a@linaro.org>
Date:   Fri, 4 Nov 2022 08:48:28 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 1/4] dt-bindings: net: Add EQoS compatible for FSD SoC
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
 <CGME20221104115841epcas5p490b99811e257b8f3f965748df0a57be5@epcas5p4.samsung.com>
 <20221104120517.77980-2-sriranjani.p@samsung.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221104120517.77980-2-sriranjani.p@samsung.com>
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

On 04/11/2022 08:05, Sriranjani P wrote:
> Add FSD Ethernet compatible in dt-bindings document
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
> Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
> Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> Cc: Jose Abreu <joabreu@synopsys.com>
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> Signed-off-by: Jayati Sahu <jayati.sahu@samsung.com>
> Signed-off-by: Sriranjani P <sriranjani.p@samsung.com>

I did not get cover letter and patch 2. Your CC list is incomplete.

For the record - DTS will not go via net-net but Samsung SoC tree.

Best regards,
Krzysztof

