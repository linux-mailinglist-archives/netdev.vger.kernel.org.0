Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11C4866325E
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 22:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238017AbjAIVLR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 16:11:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237862AbjAIVK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 16:10:59 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06B523BEB4
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 13:03:31 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id cf42so15038773lfb.1
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 13:03:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xvbOJwJCDvAVe4Ypk6TWCIgsg3158YUlrEMw2YNb0Mo=;
        b=J/52Y5D40ZyVHCKzboYRyiaw0gGNjlAz3UGYLftraJb/Js04jRHSkbpc11vqBhJkLY
         b4C0zTCHweLcchOlRsBh01CsYClhxIQQzkMmjDMw1QHCZfbvnFZxkESOW8oiOCsnxXKq
         rWyTPeRhQQX+x+oVnsUSxI/KruU4N+uvaJf5THOLNLhRhuvnjCg79IKXFF66GrW/0Wc+
         mmsUswGH67RNx2OuO0F2OcmuUJXHOBSE0VO6gW3PGZloL7zlZOwmZCKZHr0na50oGjIN
         IsCJX2Zb0bSyKP31k9pPVMwhC0uIEfTDb3T6litAsRybOc4ILP9d+PWWJi4g/A6+tGUH
         HgXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xvbOJwJCDvAVe4Ypk6TWCIgsg3158YUlrEMw2YNb0Mo=;
        b=MSWLGdOtu9++P81fw4IMReNRKms7idVA35xp5keaCAQJPkPi+YsPkZCNEmW2FFJ1y/
         3XYkxIXvW8Ya2XSRxHee/YnDfJULmqavpYjMq/eqLRN7XMO5EuoFIBolMYvuJ8aC3tGl
         60La7wQNOYrsDxruwyAJ1N77CXfX6tEAoZ5gGPUjx526Jin/RiQnUWqX8AYFltgMI1dB
         lyMWL5VL+NMn6mcNePra7Swbm+E44M3bU8Jeuo1mtkSSzIPNMjbOzIOWmDEiP21U/S49
         9n77de92ItD88qrU9vcQXKasVEtrQclHtNHiG26DZfvciTEXetEDSSj3jXPuWujfWqyg
         FezA==
X-Gm-Message-State: AFqh2kq8yNlO+Os11JYlnlyMzvFw7Ay+905JDI+CduLH1vWPHNcGMbla
        ix3zVhdBOZAJW3sVONzn+GHTEA==
X-Google-Smtp-Source: AMrXdXsbI5uSFJDymeTgphPOV5Fli5DX46O6F/LKDz4NKUeOQVAI8vZ1Os79nbfg1VaDx1h2TGA5vQ==
X-Received: by 2002:a05:6512:6d4:b0:4cb:1e1:f380 with SMTP id u20-20020a05651206d400b004cb01e1f380mr17575366lff.40.1673298209192;
        Mon, 09 Jan 2023 13:03:29 -0800 (PST)
Received: from ?IPV6:2001:14ba:a085:4d00::8a5? (dzccz6yyyyyyyyyyybcwt-3.rev.dnainternet.fi. [2001:14ba:a085:4d00::8a5])
        by smtp.gmail.com with ESMTPSA id u6-20020a05651220c600b004cc865fdfdfsm383653lfr.89.2023.01.09.13.03.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Jan 2023 13:03:28 -0800 (PST)
Message-ID: <a185b4e3-011c-c7f2-d18b-5c7486b121eb@linaro.org>
Date:   Mon, 9 Jan 2023 23:03:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 00/18] arm64: qcom: add support for sa8775p-ride
Content-Language: en-GB
To:     Konrad Dybcio <konrad.dybcio@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Georgi Djakov <djakov@kernel.org>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Alex Elder <elder@kernel.org>
Cc:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        iommu@lists.linux.dev, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
References: <20230109174511.1740856-1-brgl@bgdev.pl>
 <bca87233-ae9d-00f8-07d3-07afef2cb92c@linaro.org>
 <59835841-654a-0ef2-6c79-1ba62ff00928@linaro.org>
From:   Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
In-Reply-To: <59835841-654a-0ef2-6c79-1ba62ff00928@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/01/2023 22:59, Konrad Dybcio wrote:
> 
> 
> On 9.01.2023 21:13, Dmitry Baryshkov wrote:
>> On 09/01/2023 19:44, Bartosz Golaszewski wrote:
>>> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
>>>
>>> This adds basic support for the Qualcomm sa8775p platform and its reference
>>> board: sa8775p-ride. The dtsi contains basic SoC description required for
>>> a simple boot-to-shell. The dts enables boot-to-shell with UART on the
>>> sa8775p-ride board. There are three new drivers required to boot the board:
>>> pinctrl, interconnect and GCC clock. Other patches contain various tweaks
>>> to existing code. More support is coming up.
>>>
>>> Bartosz Golaszewski (15):
>>>     dt-bindings: clock: sa8775p: add bindings for Qualcomm gcc-sa8775p
>>>     arm64: defconfig: enable the clock driver for Qualcomm SA8775P
>>>       platforms
>>>     dt-bindings: clock: qcom-rpmhcc: document the clock for sa8775p
>>>     clk: qcom: rpmh: add clocks for sa8775p
>>>     dt-bindings: interconnect: qcom: document the interconnects for
>>>       sa8775p
>>>     arm64: defconfig: enable the interconnect driver for Qualcomm SA8775P
>>>     dt-bindings: pinctrl: sa8775p: add bindings for qcom,sa8775p-tlmm
>>>     arm64: defconfig: enable the pinctrl driver for Qualcomm SA8775P
>>>       platforms
>>>     dt-bindings: mailbox: qcom-ipcc: document the sa8775p platform
>>>     dt-bindings: power: qcom,rpmpd: document sa8775p
>>>     soc: qcom: rmphpd: add power domains for sa8775p
>>>     dt-bindings: arm-smmu: document the smmu on Qualcomm SA8775P
>>>     iommu: arm-smmu: qcom: add support for sa8775p
>>>     dt-bindings: arm: qcom: document the sa8775p reference board
>>>     arm64: dts: qcom: add initial support for qcom sa8775p-ride
>>>
>>> Shazad Hussain (2):
>>>     clk: qcom: add the GCC driver for sa8775p
>>
>> This patch didn't make it to the list. Please check if you can fix or split it somehow?
> It's a known issue with lists clipping messages that are too long.
> I'll forward it to you.

Thank you!

-- 
With best wishes
Dmitry

