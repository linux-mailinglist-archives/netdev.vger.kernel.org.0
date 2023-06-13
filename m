Return-Path: <netdev+bounces-10494-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 11B1672EB80
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 21:04:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C257C281287
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 19:04:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 361FB28C23;
	Tue, 13 Jun 2023 19:04:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299AE3B8D4
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 19:04:16 +0000 (UTC)
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA3081BDB
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 12:04:14 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id 2adb3069b0e04-4f762b3227dso345699e87.1
        for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 12:04:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686683053; x=1689275053;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=woeYYFEiU1y3NclAr5wdCFdPFOi62sLbxPfwISR5Xn8=;
        b=q2bbZiF2Xy2JxkCX8e3y4fFp2cP9iFKv42xyhROdmk2mpDr7LXZfz3AWcU7AxuHxKc
         IBySptwOhOAewBK0W7T3JZWk1l4Kj0ib1b7kfAkZPI6Mp/FlSBZj1SdO4XPDtu53cxh+
         wzJOoSDF5OtB4VFwZt0q+PodkxVuxE0QGoEdHp9BvSX7JmMHiBIIFACiOq9QEDZ5HZeI
         xXZqzZxo83ru7G7QauolFOyXqjc0HfXZRUJgtbKj7CmSdqc+ucEjOfsDf8AdyWXweCr2
         C+2eCONnBG/Stb3+zfI0K/svhD1H7VcMrPRWr7lntdBMeOj9IO7/m0BH9YMeFk5YzD5H
         pxBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686683053; x=1689275053;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=woeYYFEiU1y3NclAr5wdCFdPFOi62sLbxPfwISR5Xn8=;
        b=HYUwLZo0/sVco6t345QVbmLT1ZHYlwixUUoZm9HqtNgmTfZEbxjb+DOX6nabTraOxH
         j9cNIV0IYKk2qaEfEHWWOlAaarmOwULiwF7tRzSMas/YjdjJme3UftwWWJLBEZoy19dJ
         bNhVO3oIPoKeC1dXmqvV/UZdE77b+SfNBC+8JPeL0YwF8s6IvKWqxlVb4XudkzoBVUnS
         jHGMgLGcrWJ53fGB3ks4eYLLh0wY00zv+72oG4cTI03wH0/ezSOIxo72ecnT4VJJzqXY
         d7GGi3vSG93V/D+UXkae0CNkYRTBK7d/s3FsqrymJdcK8Iwm0I7e6nOSH2bjCJ7Kh9LD
         k96Q==
X-Gm-Message-State: AC+VfDxbBTRTStAHhjY4DZq2um8AnjcYr1Lusl/TSIEnJhTyfJl09Pdd
	xNQI3gZM2X/Pf9433xYQA09rnQ==
X-Google-Smtp-Source: ACHHUZ64q3nAkmQiyy1A3DAZ+hVneYytXEVoRe5yh0a8KBFRcAQJiZjhKQQHeFFMapSCKaxVrNlEzA==
X-Received: by 2002:a19:5e11:0:b0:4ac:b7bf:697a with SMTP id s17-20020a195e11000000b004acb7bf697amr4518741lfb.4.1686683053205;
        Tue, 13 Jun 2023 12:04:13 -0700 (PDT)
Received: from [192.168.1.101] (abyj190.neoplus.adsl.tpnet.pl. [83.9.29.190])
        by smtp.gmail.com with ESMTPSA id u7-20020ac243c7000000b004f42718cbb1sm1856560lfl.292.2023.06.13.12.04.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jun 2023 12:04:12 -0700 (PDT)
Message-ID: <7b511c41-4bf5-f7ff-8ae9-5f1bffac50d9@linaro.org>
Date: Tue, 13 Jun 2023 21:04:08 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH 25/26] arm64: dts: qcom: sa8775p-ride: add pin functions
 for ethernet0
Content-Language: en-US
To: Bartosz Golaszewski <brgl@bgdev.pl>, Vinod Koul <vkoul@kernel.org>,
 Bhupesh Sharma <bhupesh.sharma@linaro.org>, Andy Gross <agross@kernel.org>,
 Bjorn Andersson <andersson@kernel.org>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Rob Herring <robh+dt@kernel.org>,
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
 Conor Dooley <conor+dt@kernel.org>,
 Kishon Vijay Abraham I <kishon@kernel.org>,
 Giuseppe Cavallaro <peppe.cavallaro@st.com>,
 Alexandre Torgue <alexandre.torgue@foss.st.com>,
 Jose Abreu <joabreu@synopsys.com>
Cc: netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-phy@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linux-stm32@st-md-mailman.stormreply.com,
 Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
References: <20230612092355.87937-1-brgl@bgdev.pl>
 <20230612092355.87937-26-brgl@bgdev.pl>
From: Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <20230612092355.87937-26-brgl@bgdev.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 12.06.2023 11:23, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> 
> Add the MDC and MDIO pin functions for ethernet0 on sa8775p-ride.
> 
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> ---
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>

Konrad
>  arch/arm64/boot/dts/qcom/sa8775p-ride.dts | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/qcom/sa8775p-ride.dts b/arch/arm64/boot/dts/qcom/sa8775p-ride.dts
> index 7754788ea775..dbd9553aa5c7 100644
> --- a/arch/arm64/boot/dts/qcom/sa8775p-ride.dts
> +++ b/arch/arm64/boot/dts/qcom/sa8775p-ride.dts
> @@ -370,6 +370,22 @@ &spi16 {
>  };
>  
>  &tlmm {
> +	ethernet0_default: ethernet0-default-state {
> +		ethernet0_mdc: ethernet0-mdc-pins {
> +			pins = "gpio8";
> +			function = "emac0_mdc";
> +			drive-strength = <16>;
> +			bias-pull-up;
> +		};
> +
> +		ethernet0_mdio: ethernet0-mdio-pins {
> +			pins = "gpio9";
> +			function = "emac0_mdio";
> +			drive-strength = <16>;
> +			bias-pull-up;
> +		};
> +	};
> +
>  	qup_uart10_default: qup-uart10-state {
>  		pins = "gpio46", "gpio47";
>  		function = "qup1_se3";

