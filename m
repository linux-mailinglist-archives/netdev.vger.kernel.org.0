Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 422D26A9633
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 12:28:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbjCCL2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 06:28:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230184AbjCCL2r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 06:28:47 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B27EE5F222
        for <netdev@vger.kernel.org>; Fri,  3 Mar 2023 03:28:25 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id m6so3160078lfq.5
        for <netdev@vger.kernel.org>; Fri, 03 Mar 2023 03:28:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1677842904;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zIEyfJHn9nwX9v5jkEb3Mml1NwAILd6wX1VPBLhmV8k=;
        b=L6JrqYu+FyX5oZB7UCc86qvZC2nGgX2c0s3VWm/Ol7LDmz1ju31M98rBuL2TNdKjsB
         WMoaBX9a86UgVUcos9lD+PLW3VcOcArV9NKna5AxRx8G/QRUfenjOlRMpLltoE/nu9Vf
         AqeohNQohxiH59X0XZbenYk2f8PmgsIfwTcYQObyyJ+sBF0Qktjri8klyiMav4m/O90z
         4a1AR2IkLLz/Ral6esb6Nj7quE6UmqP8Fal4N7ZI0UqT0Az/5tQ8RFMY2oj3eqNdCmiH
         RG8qIrwL/9pZmMfw6sr3mKsFm5JJ9VPgiJL521lmEmvZUA8VbXVsauAdqNL1Yh+1kxKa
         fovA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677842904;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zIEyfJHn9nwX9v5jkEb3Mml1NwAILd6wX1VPBLhmV8k=;
        b=4knEZtveAOVW46IojgufHTc/8QoKVsGKOkwxOy6OA6SgIhqm6DMCYMkG7Iw6uiSJJR
         feo3wkxz8zUG7LPAWXkZYDzaURanrJGCjQdV08iq0XIIIxn6z2uq+tYI32FYchFyQdkK
         /iWeh8Zw813qYCiC3MO6gYxOBV3sgvf8AM6Zxf/1OEPOw120TX2wJF3K5iQ3vD2r3taw
         ZER1uG4GKgiS2UajhRWunjEHfu1pex4VhNyljFMAnNs5wmcFDGnrRr4umUBoCMgM5IG9
         JXSdtj6dt5YCZ3L3MTmqzP3winX7zy5HPGdslMwVAJ57asJqQ5G9kZPUaB3IhqvIKMhm
         07ig==
X-Gm-Message-State: AO0yUKVXEG1Q5uYd/fhYB/g+9x1XycEYjqlBG1+JvmnFHWoKYox0zSJH
        2How6ChACtGco1qpbjf511Rvbg==
X-Google-Smtp-Source: AK7set8gz3IR0Ej3BL25630lurVOHrKBX4z4hGn4Nl4VSby22cKKgVQ5pRWxNONwUeLQRHQOXiHCwA==
X-Received: by 2002:ac2:490f:0:b0:4cc:a166:e27f with SMTP id n15-20020ac2490f000000b004cca166e27fmr478998lfi.3.1677842903780;
        Fri, 03 Mar 2023 03:28:23 -0800 (PST)
Received: from [192.168.1.101] (abym99.neoplus.adsl.tpnet.pl. [83.9.32.99])
        by smtp.gmail.com with ESMTPSA id u13-20020ac251cd000000b004d0b1327b75sm354945lfm.61.2023.03.03.03.28.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Mar 2023 03:28:23 -0800 (PST)
Message-ID: <41665c73-1647-2cb2-bd33-8dc281a97ee5@linaro.org>
Date:   Fri, 3 Mar 2023 12:28:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 1/2] dt-bindings: ath10k: Add vdd-smps supply
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        linux-arm-msm@vger.kernel.org, andersson@kernel.org,
        agross@kernel.org
Cc:     marijn.suijten@somainline.org, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230303024246.2175382-1-konrad.dybcio@linaro.org>
 <8e695c64-6abd-3c1e-8d80-de636d950442@linaro.org>
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <8e695c64-6abd-3c1e-8d80-de636d950442@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3.03.2023 08:12, Krzysztof Kozlowski wrote:
> On 03/03/2023 03:42, Konrad Dybcio wrote:
>> Mention the newly added vdd-smps supply.
> 
> There is no explanation here, but looking at your driver change it
> suggests name is not correct. You named it based on regulator (so the
> provider), not the consumer.

Right, I admit this could have been posted with an RFC tag.
Maybe Kalle knows more.

Konrad
> 
> Best regards,
> Krzysztof
> 
