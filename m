Return-Path: <netdev+bounces-10496-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3943272EB9C
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 21:08:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D95AA280F02
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 19:08:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0F6230B98;
	Tue, 13 Jun 2023 19:08:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B5C1ED49
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 19:08:22 +0000 (UTC)
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6833199A
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 12:08:19 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id 2adb3069b0e04-4f642a24568so7403041e87.2
        for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 12:08:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686683298; x=1689275298;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=F+tm3+Pdm0PaXfiZEzyRYLx0bL/2PcssnIDcJqEcG00=;
        b=pXvtSrfvSZFtqXr7gBQNbwO93crNLRG5kDvQKUb9i07WRGV8cuKSZdeN2AHPfkSYEV
         s9Kj4TDyZ6xACpGIQJynV4qJHfQP8x2u9sRicGgoFESj5RceIKeBfElicevTTgiNi7RL
         9QVYc+lVnCKM1rsbq+3A8n10G22u07GDwcLiscU3lmCZ6y7WPLfCyTgRAVZA4pyyw5Yn
         JKU8Q+vKxm0IHBX04DCwxktI6OGATGIu3ihwztTO+oNXjo8vTM8yorfcSd8ysJEEaPSj
         +opeKcUuZUOr+FiHdS+JpkxNfEiaACOn71VVmdwpa4d0A54Sj9plaNCeEqJ1uAKxPOTX
         1XpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686683298; x=1689275298;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F+tm3+Pdm0PaXfiZEzyRYLx0bL/2PcssnIDcJqEcG00=;
        b=J/EJiYLIjKuOtCpSRXOpEy7p1aWQhz9AvMiKTOJX/kA2xckLA2xJE8V5qR2GLOcuMi
         nM23bcp9whXwCqPoGgxvKZTenvBWqOwIUXuPzTayPjcPT6eIiPILwDthi2i1dwgThZ+i
         vhO5nCjAIz57qn/Lxk1N8b1KXd+pYCtsQmOYkgFry+ePYCpluAKXjq4/N00wRb/3ayr2
         /Mg4CvtXG0d5FgcM0k8OYuEYziWhRoI1o7YxKfIVxi1HApHvkOXMu3j76h9z8h26yoDz
         aXwx48q2yfaMxncKJOUN/JwtgVWZe/6qqtFj6qQXluebXZFL/8tJzIeN4Z5qXaOmsjTJ
         +ZPg==
X-Gm-Message-State: AC+VfDwiQpL4yxRC6SwBPO8+diYNrg/wSyfIjnFukC8BJRKGfCYgDH5A
	EbLN6HYsDcyp4tnLFcUiIP/ZvA==
X-Google-Smtp-Source: ACHHUZ5hlHejaHU5jlNuZeMW5cevHnRvyHVwiIHOuhObHOVK4r0Ifh+Y4UFnRCtLYlUAMdVar7JMhg==
X-Received: by 2002:a19:e059:0:b0:4d5:8306:4e9a with SMTP id g25-20020a19e059000000b004d583064e9amr6458878lfj.46.1686683298079;
        Tue, 13 Jun 2023 12:08:18 -0700 (PDT)
Received: from [192.168.1.101] (abyj190.neoplus.adsl.tpnet.pl. [83.9.29.190])
        by smtp.gmail.com with ESMTPSA id m5-20020a056512014500b004f73eac0308sm1148576lfo.183.2023.06.13.12.08.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jun 2023 12:08:17 -0700 (PDT)
Message-ID: <cf515539-9a60-c3ae-18af-463651651a27@linaro.org>
Date: Tue, 13 Jun 2023 21:08:14 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH 26/26] arm64: dts: qcom: sa8775p-ride: enable ethernet0
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
 <20230612092355.87937-27-brgl@bgdev.pl>
From: Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <20230612092355.87937-27-brgl@bgdev.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 12.06.2023 11:23, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> 
> Enable the first 1Gb ethernet port on sa8775p-ride development board.
> 
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> ---
I don't know a whole lot about this, but it passes bindings checks
and looks good overall, so:

Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>

Konrad
>  arch/arm64/boot/dts/qcom/sa8775p-ride.dts | 89 +++++++++++++++++++++++
>  1 file changed, 89 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/qcom/sa8775p-ride.dts b/arch/arm64/boot/dts/qcom/sa8775p-ride.dts
> index dbd9553aa5c7..13508271bca8 100644
> --- a/arch/arm64/boot/dts/qcom/sa8775p-ride.dts
> +++ b/arch/arm64/boot/dts/qcom/sa8775p-ride.dts
> @@ -261,6 +261,95 @@ vreg_l8e: ldo8 {
>  	};
>  };
>  
> +&ethernet0 {
> +	phy-mode = "sgmii";
> +	phy-handle = <&sgmii_phy>;
> +	phy-supply = <&vreg_l5a>;
> +
> +	pinctrl-0 = <&ethernet0_default>;
> +	pinctrl-names = "default";
> +
> +	snps,mtl-rx-config = <&mtl_rx_setup>;
> +	snps,mtl-tx-config = <&mtl_tx_setup>;
> +	snps,ps-speed = <1000>;
> +
> +	status = "okay";
> +
> +	mdio {
> +		compatible = "snps,dwmac-mdio";
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		reset-gpios = <&pmm8654au_2_gpios 8 GPIO_ACTIVE_LOW>;
> +		reset-delay-us = <11000>;
> +		reset-post-delay-us = <70000>;
> +
> +		sgmii_phy: phy@8 {
> +			reg = <0x8>;
> +			device_type = "ethernet-phy";
> +		};
> +	};
> +
> +	mtl_rx_setup: rx-queues-config {
> +		snps,rx-queues-to-use = <4>;
> +		snps,rx-sched-sp;
> +
> +		queue0 {
> +			snps,dcb-algorithm;
> +			snps,map-to-dma-channel = <0x0>;
> +			snps,route-up;
> +			snps,priority = <0x1>;
> +		};
> +
> +		queue1 {
> +			snps,dcb-algorithm;
> +			snps,map-to-dma-channel = <0x1>;
> +			snps,route-ptp;
> +		};
> +
> +		queue2 {
> +			snps,avb-algorithm;
> +			snps,map-to-dma-channel = <0x2>;
> +			snps,route-avcp;
> +		};
> +
> +		queue3 {
> +			snps,avb-algorithm;
> +			snps,map-to-dma-channel = <0x3>;
> +			snps,priority = <0xc>;
> +		};
> +	};
> +
> +	mtl_tx_setup: tx-queues-config {
> +		snps,tx-queues-to-use = <4>;
> +		snps,tx-sched-sp;
> +
> +		queue0 {
> +			snps,dcb-algorithm;
> +		};
> +
> +		queue1 {
> +			snps,dcb-algorithm;
> +		};
> +
> +		queue2 {
> +			snps,avb-algorithm;
> +			snps,send_slope = <0x1000>;
> +			snps,idle_slope = <0x1000>;
> +			snps,high_credit = <0x3e800>;
> +			snps,low_credit = <0xffc18000>;
> +		};
> +
> +		queue3 {
> +			snps,avb-algorithm;
> +			snps,send_slope = <0x1000>;
> +			snps,idle_slope = <0x1000>;
> +			snps,high_credit = <0x3e800>;
> +			snps,low_credit = <0xffc18000>;
> +		};
> +	};
> +};
> +
>  &i2c11 {
>  	clock-frequency = <400000>;
>  	pinctrl-0 = <&qup_i2c11_default>;

