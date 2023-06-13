Return-Path: <netdev+bounces-10487-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A47872EB5C
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 20:57:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 447F2281272
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 18:57:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40EF422D4E;
	Tue, 13 Jun 2023 18:57:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 359091ED4E
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 18:57:40 +0000 (UTC)
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 597CB1BEE
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 11:57:33 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id 38308e7fff4ca-2b227fdda27so51951231fa.1
        for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 11:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686682651; x=1689274651;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zsyyTwvaw/vp2AvSdxNLXUl1Sss7B+R+faApw6mGFPk=;
        b=EpsoCgNUbEr8P/ekHeYMePrH3lx9EnGuaih1xSHCfQ6AaSSa7tJ+X0msbZs5zB0RSh
         Bltvzflx0blflLlM249+PTlK7N38BjYPqzgSrxSeXu4pN3yG6njvv8jc7cWijBiIGKA2
         6K15ceQw5uqBaHvM5VWV/tYfqevE/SUnWSbXPXmth40TgDyy8NJX7ilVxnozDQGaQSZr
         SnXicXCwgT2ajHUDvwtsU+MfImTkCTBqZG45sR346wlpG/Ta1gjS62h3xknna+BzTKG+
         bTpcqwD7/n0NMkoqIJdqnl/lDOYgzFBCp3ZHv8CP7A6SGX8qpgN7xTU61OTuyLZ8X61N
         Wm6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686682651; x=1689274651;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zsyyTwvaw/vp2AvSdxNLXUl1Sss7B+R+faApw6mGFPk=;
        b=c+1tikB98Hpn8V8kmWhsIztMHPLo5l5jV/uSoCQqX8vDs+qiHh/YuxhaqgZAdBiM4y
         kIIvyEOF+tYRNsnLcXv/LukYp9uRfk/Kbb2poX0pgRnNEydGeWv52odRi8wfJ7HhN/4C
         3+2UBxtdexnYMCBga3vlhSRIsyWGN7AUjqxywQFUveTdxIwtOYVDETunCDrS2VIykWHw
         7+TFuJDsvta1UY7B/c0X4pQHggey5+HOYHfVp+kOit9TY8ecPNdMfYVanfMAicjhAitE
         z0xoh0hMra0vwz5yF6t0Ed7TQ5sHj0Twp5BCAh6T7Kfn6LHZimgzT28OCjS6zKxgA9Qz
         KO+g==
X-Gm-Message-State: AC+VfDy1zDSf7rlc7R2sVIltz72sTexvELYxmcxEa83S+5P+UJrgWk2P
	hdZEiwDIcWq9whw9dH3Tec4WhQ==
X-Google-Smtp-Source: ACHHUZ58SPWpBS7mZjv7bdICxXgiAzg0Iw/ZCUujbrRo5NysRIPz5M1A2dBrKoFVdo4w57IT44ob+Q==
X-Received: by 2002:a2e:b98f:0:b0:2b1:fa7c:9131 with SMTP id p15-20020a2eb98f000000b002b1fa7c9131mr3438013ljp.18.1686682651365;
        Tue, 13 Jun 2023 11:57:31 -0700 (PDT)
Received: from [192.168.1.101] (abyj190.neoplus.adsl.tpnet.pl. [83.9.29.190])
        by smtp.gmail.com with ESMTPSA id a11-20020a2e980b000000b002b1c0a663fbsm2258476ljj.77.2023.06.13.11.57.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jun 2023 11:57:30 -0700 (PDT)
Message-ID: <a21cc6ed-e894-7a38-a203-bebcc1c41230@linaro.org>
Date: Tue, 13 Jun 2023 20:57:27 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH 23/26] arm64: dts: qcom: sa8775p: add the first 1Gb
 ethernet interface
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
 <20230612092355.87937-24-brgl@bgdev.pl>
From: Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <20230612092355.87937-24-brgl@bgdev.pl>
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
> Add the node for the first ethernet interface on sa8775p platforms.
> 
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> ---
>  arch/arm64/boot/dts/qcom/sa8775p.dtsi | 30 +++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/qcom/sa8775p.dtsi b/arch/arm64/boot/dts/qcom/sa8775p.dtsi
> index 0e59000a0c82..f43a2a5d1d11 100644
> --- a/arch/arm64/boot/dts/qcom/sa8775p.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sa8775p.dtsi
> @@ -2315,6 +2315,36 @@ cpufreq_hw: cpufreq@18591000 {
>  
>  			#freq-domain-cells = <1>;
>  		};
> +
> +		ethernet0: ethernet@23040000 {
> +			compatible = "qcom,sa8775p-ethqos";
> +			reg = <0x0 0x23040000 0x0 0x10000>,
> +			      <0x0 0x23056000 0x0 0x100>;
> +			reg-names = "stmmaceth", "rgmii";
> +
> +			clocks = <&gcc GCC_EMAC0_AXI_CLK>,
> +				 <&gcc GCC_EMAC0_SLV_AHB_CLK>,
> +				 <&gcc GCC_EMAC0_PTP_CLK>,
> +				 <&gcc GCC_EMAC0_PHY_AUX_CLK>;
> +			clock-names = "stmmaceth", "pclk", "ptp_ref", "phyaux";
Please make this a vertical list, one per line

> +
> +			power-domains = <&gcc EMAC0_GDSC>;
> +
> +			interrupts = <GIC_SPI 946 IRQ_TYPE_LEVEL_HIGH>;
> +			interrupt-names = "macirq";
And another nit, interrupts above clocks would match what I ask others
to do.. Still working on checks/guidelines for this!

Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>

Konrad
> +
> +			phys = <&serdes_phy>;
> +			phy-names = "serdes";
> +
> +			iommus = <&apps_smmu 0x120 0xf>;
> +
> +			snps,tso;
> +			snps,pbl = <32>;
> +			rx-fifo-depth = <16384>;
> +			tx-fifo-depth = <16384>;
> +
> +			status = "disabled";
> +		};
>  	};
>  
>  	arch_timer: timer {

