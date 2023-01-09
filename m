Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0AC66323D
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 22:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237740AbjAIVHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 16:07:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238026AbjAIVGH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 16:06:07 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 248E387C32
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 12:59:11 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id f21so5848676ljc.7
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 12:59:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=juyuPJPONha78xbpz7iYzYAItkLt8qpPWXxamUxSsrM=;
        b=cJvLdbiyvt4WHYchX2/l+CT9g5BE14Lx1CykE+gCEIEXPTcogEknF+6WOD5/q92VkK
         4LcGD+2Alll5yyz/EKEIWAtVAh54/wcKQwAUWqdafLDAP2WdfFFuyd+dtqlpb6L2PjZL
         pMaKHVZTVNymu/zykTuvMiZQVqgzatVCpV+tpjAtNKKjyKin4CGYvZBtYKIHXcuYMJkf
         6bA9zFllaJZvXyw0EgULXP3WqMFPD2J1bVDoMfao6KmNyif1giWPjbId/GThW90SUI7r
         A4NtI35ThOsKpNzHWXTEv+LHqF6msM+MEfnVJ3jzZ89ouZaH/SjstURk7bWbkAny7nOs
         7dOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=juyuPJPONha78xbpz7iYzYAItkLt8qpPWXxamUxSsrM=;
        b=71QHbgp6p4pwHmELf2vEWUw1UPYApt60IdeXHIjpDSo2Sfyyg//KPWnkyU+IoSnUwK
         s6LuvwZNYN9vOziMg07idvJbX7GNSAQba6MXCZ9Rb2TxI8t7OFIPXatTFClk2NPuh7Oa
         Z0fr187cm1x02R8qPbpichRcP/oH2MKaJhUCDSG04iST4RaGkO6lndvhwkquXRmJ/S1J
         6xrnUbbRANvnIUjzADOVIJxdPo1JH990fwFRGFDPpxC3Vp1hle+QXkjoEHLBN3I/GT8J
         VC16xdEwyvf5QLPm+3m1F86If+yjG8HYmwx3ecjoXKSmIzhRqqxyuR0yLytsNYMcIhDx
         b/9g==
X-Gm-Message-State: AFqh2kqIIDJLIqDZy4k9SPopYPb73EDRnsoqn09USRKSbfv6w16ufp54
        qd8AiWunvr7LCJlx08k8G+b/lQ==
X-Google-Smtp-Source: AMrXdXsFoag9MtSFnbdYxM3IyTa2CUjeLgJrDl4dleDZQ0e9LavXeDDGCLRsH5rm+9xMocIvMDJ7Yg==
X-Received: by 2002:a2e:b054:0:b0:27f:e465:859e with SMTP id d20-20020a2eb054000000b0027fe465859emr8960942ljl.2.1673297950108;
        Mon, 09 Jan 2023 12:59:10 -0800 (PST)
Received: from [192.168.1.101] (abxi45.neoplus.adsl.tpnet.pl. [83.9.2.45])
        by smtp.gmail.com with ESMTPSA id bj27-20020a2eaa9b000000b0027fd65e4faesm1029211ljb.108.2023.01.09.12.59.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Jan 2023 12:59:09 -0800 (PST)
Message-ID: <59835841-654a-0ef2-6c79-1ba62ff00928@linaro.org>
Date:   Mon, 9 Jan 2023 21:59:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 00/18] arm64: qcom: add support for sa8775p-ride
Content-Language: en-US
To:     Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
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
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <bca87233-ae9d-00f8-07d3-07afef2cb92c@linaro.org>
Content-Type: text/plain; charset=UTF-8
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



On 9.01.2023 21:13, Dmitry Baryshkov wrote:
> On 09/01/2023 19:44, Bartosz Golaszewski wrote:
>> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
>>
>> This adds basic support for the Qualcomm sa8775p platform and its reference
>> board: sa8775p-ride. The dtsi contains basic SoC description required for
>> a simple boot-to-shell. The dts enables boot-to-shell with UART on the
>> sa8775p-ride board. There are three new drivers required to boot the board:
>> pinctrl, interconnect and GCC clock. Other patches contain various tweaks
>> to existing code. More support is coming up.
>>
>> Bartosz Golaszewski (15):
>>    dt-bindings: clock: sa8775p: add bindings for Qualcomm gcc-sa8775p
>>    arm64: defconfig: enable the clock driver for Qualcomm SA8775P
>>      platforms
>>    dt-bindings: clock: qcom-rpmhcc: document the clock for sa8775p
>>    clk: qcom: rpmh: add clocks for sa8775p
>>    dt-bindings: interconnect: qcom: document the interconnects for
>>      sa8775p
>>    arm64: defconfig: enable the interconnect driver for Qualcomm SA8775P
>>    dt-bindings: pinctrl: sa8775p: add bindings for qcom,sa8775p-tlmm
>>    arm64: defconfig: enable the pinctrl driver for Qualcomm SA8775P
>>      platforms
>>    dt-bindings: mailbox: qcom-ipcc: document the sa8775p platform
>>    dt-bindings: power: qcom,rpmpd: document sa8775p
>>    soc: qcom: rmphpd: add power domains for sa8775p
>>    dt-bindings: arm-smmu: document the smmu on Qualcomm SA8775P
>>    iommu: arm-smmu: qcom: add support for sa8775p
>>    dt-bindings: arm: qcom: document the sa8775p reference board
>>    arm64: dts: qcom: add initial support for qcom sa8775p-ride
>>
>> Shazad Hussain (2):
>>    clk: qcom: add the GCC driver for sa8775p
> 
> This patch didn't make it to the list. Please check if you can fix or split it somehow?
It's a known issue with lists clipping messages that are too long.
I'll forward it to you.

Konrad
> 
