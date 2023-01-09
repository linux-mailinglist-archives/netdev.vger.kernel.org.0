Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17EF7663126
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 21:15:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237264AbjAIUNw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 15:13:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237735AbjAIUNs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 15:13:48 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADF60193EB
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 12:13:46 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id bq39so14860791lfb.0
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 12:13:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZwlI2rC+HzJTLFLMhKZ8XXSbqvnPdbvWS7MaUPnObQo=;
        b=kz3Ist5SxOCjqV2Ocp2A6n17EHolOzFGiqs6Wco9XF+43bgkwP9nBpHWfzG4X/BXQx
         CyGQO1Ofksog/BjasUXnL0yAnmDUZ44XYgH8AYgP6Dnp3dav6Bea9C/x41l56t1mL2Sw
         chgSQ8gIVZWZ0S0UaW5amMhXBDegOHhh9IFm40U2qPAsFRM09/BF0IvMBNsMmmwR6KtA
         8cmvA2FyEnoOMh2ULjMshs5E4J7fz2izE+xtI+I4y42dmYwQMyTcgrXVpI7HVQs4caH4
         KEQ3vy9J0wHOewqQ99+KxtH1TIZOMtJuV/ljHg4FElybP2XRtibuBisf4wIQhKhHdkvW
         xT7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZwlI2rC+HzJTLFLMhKZ8XXSbqvnPdbvWS7MaUPnObQo=;
        b=DNcjUMVhCg58eBwvXO00R3593A2vqWsb8jm2Ze8acu+BBwYcYVrP5ZZl3Eb4gbVADM
         FlxYb2x3sicS1dUf6Wg5/KVkWa3Au46yLHSulxospACyQCE1KIDopQjHTuzlhJ0V0prz
         BHJ3OElw1RnZKPaLC52FqBCIW4EtERxV6N/pfKOK1EiqJmBVmXsNzlyYiUU8Qy+Iu+Qp
         tW4SRZsuYrcFA2EKeZg4YpvgrhQIhp7BIkrGoktcxtriuXXIT0jP59V/zhBSEFagVIPY
         GobntWONb/eYTnekg4NPprz5JYSQ5RXP8KCBVIArpUcjiz/9/3g/B6tVMLXGxJmHAwcy
         jcmA==
X-Gm-Message-State: AFqh2koY6YoXJfTFLhQptz5W6y3gUCenGkFYtr0wLYFl0MqdDSFeNDtp
        /IsLXG1D9/Gxv8YpCLbGh3PWNQ==
X-Google-Smtp-Source: AMrXdXtvNWi+5bMNS3mo/Qw4dk7CPRaMpdh2nLCV4A0yC2G+8sSbxJc6WOy18Yj7EqgI+pgZXWBpcA==
X-Received: by 2002:a05:6512:3601:b0:4b7:13b:259d with SMTP id f1-20020a056512360100b004b7013b259dmr16616174lfs.48.1673295225068;
        Mon, 09 Jan 2023 12:13:45 -0800 (PST)
Received: from ?IPV6:2001:14ba:a085:4d00::8a5? (dzccz6yyyyyyyyyyybcwt-3.rev.dnainternet.fi. [2001:14ba:a085:4d00::8a5])
        by smtp.gmail.com with ESMTPSA id x2-20020a056512130200b004a8f824466bsm1766455lfu.188.2023.01.09.12.13.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Jan 2023 12:13:44 -0800 (PST)
Message-ID: <bca87233-ae9d-00f8-07d3-07afef2cb92c@linaro.org>
Date:   Mon, 9 Jan 2023 22:13:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 00/18] arm64: qcom: add support for sa8775p-ride
Content-Language: en-GB
To:     Bartosz Golaszewski <brgl@bgdev.pl>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
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
From:   Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
In-Reply-To: <20230109174511.1740856-1-brgl@bgdev.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
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

On 09/01/2023 19:44, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> 
> This adds basic support for the Qualcomm sa8775p platform and its reference
> board: sa8775p-ride. The dtsi contains basic SoC description required for
> a simple boot-to-shell. The dts enables boot-to-shell with UART on the
> sa8775p-ride board. There are three new drivers required to boot the board:
> pinctrl, interconnect and GCC clock. Other patches contain various tweaks
> to existing code. More support is coming up.
> 
> Bartosz Golaszewski (15):
>    dt-bindings: clock: sa8775p: add bindings for Qualcomm gcc-sa8775p
>    arm64: defconfig: enable the clock driver for Qualcomm SA8775P
>      platforms
>    dt-bindings: clock: qcom-rpmhcc: document the clock for sa8775p
>    clk: qcom: rpmh: add clocks for sa8775p
>    dt-bindings: interconnect: qcom: document the interconnects for
>      sa8775p
>    arm64: defconfig: enable the interconnect driver for Qualcomm SA8775P
>    dt-bindings: pinctrl: sa8775p: add bindings for qcom,sa8775p-tlmm
>    arm64: defconfig: enable the pinctrl driver for Qualcomm SA8775P
>      platforms
>    dt-bindings: mailbox: qcom-ipcc: document the sa8775p platform
>    dt-bindings: power: qcom,rpmpd: document sa8775p
>    soc: qcom: rmphpd: add power domains for sa8775p
>    dt-bindings: arm-smmu: document the smmu on Qualcomm SA8775P
>    iommu: arm-smmu: qcom: add support for sa8775p
>    dt-bindings: arm: qcom: document the sa8775p reference board
>    arm64: dts: qcom: add initial support for qcom sa8775p-ride
> 
> Shazad Hussain (2):
>    clk: qcom: add the GCC driver for sa8775p

This patch didn't make it to the list. Please check if you can fix or 
split it somehow?

-- 
With best wishes
Dmitry

