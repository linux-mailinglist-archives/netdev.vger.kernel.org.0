Return-Path: <netdev+bounces-11117-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 215C5731951
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 14:57:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5915E2816E9
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 12:56:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43ED5125B5;
	Thu, 15 Jun 2023 12:56:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 314B8111AE
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 12:56:55 +0000 (UTC)
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8DEA269E
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 05:56:53 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id 2adb3069b0e04-4f764e92931so3136563e87.2
        for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 05:56:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686833812; x=1689425812;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=v1CbTBRn8vQDvPf6Z2biUED1bJGUXq/a80Hy0PH+rSA=;
        b=pIzCccIMIRGK2q25DpBRdjMSE9rF2EraF12WiZ8h6N7uHRGusZ2WBw7HdRHqX2CeL5
         EKul/KBbvQJkKxXtT093+Wj1U/LHPnCAmqvmia0QrGEdbHfA+Zss1Abfir1yj56IH/9o
         uOGSulxNPYsuDFKg+RHzEHMoS48IYece+jmC5VW4+cnXP4VxKmfwBOr++lmyPuey5vXe
         Pq6ZGehysyoWw4MAO8BKFLiDiFqbT/PklBljqRPuA896y5RlHwx4Tm5/0eWdIxhu0TtZ
         ubzHiTGNXQ4XpK81GBliesQcRh1r6v4SjeNXQbHNPM0IOGA+tRleTV9kXy14TroVf1Lt
         d4gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686833812; x=1689425812;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v1CbTBRn8vQDvPf6Z2biUED1bJGUXq/a80Hy0PH+rSA=;
        b=FpfuPOLwJdJzxdRi/+1M1Qn6nglSZx3WEBhR9ILcET5GABS0pi+Ls0kR72llfbFQv0
         A6fIpn9Mq2IUEpPEoWhcKsrBnvRDAfwkH3rZZS4hd5y/riQ3HD6K4WDSfo0ZZUoiai9N
         elEhJnk2dhnqt47JpWq9iHnB66TYNwGNzGLQYYtx8oLp0HdkgBnESyQxPYjyhtnT3J6d
         I0wmh8w39jvR/fyHL7YNyI4LU4LBNkxvBZJfZPEkCc9NdGTAbrGIclWgJAePgnbpOsXX
         FqzB/64qEVLgVcWbCn+gXM2bQoLNENe/K92d093bjSJK/82gY8BBkpvGYpuE3UK4Y3bb
         w26g==
X-Gm-Message-State: AC+VfDz2qt9U9MgrMwP0tdo45nZShIn60g4crloiqYZ9yF/ms+XdzyO7
	QRiOCap4jmaPZx5OBQz7EIAHrw==
X-Google-Smtp-Source: ACHHUZ4idKi9MKj9dACNe9eMwOfmRi1oqlCWD4/JIb33nDqyZCNa4kpiBxTMJ7GeUtyUjAUAiC/Yng==
X-Received: by 2002:a05:6512:48b:b0:4ef:ed49:fcc2 with SMTP id v11-20020a056512048b00b004efed49fcc2mr11392533lfq.26.1686833811790;
        Thu, 15 Jun 2023 05:56:51 -0700 (PDT)
Received: from [192.168.1.101] (abyj190.neoplus.adsl.tpnet.pl. [83.9.29.190])
        by smtp.gmail.com with ESMTPSA id l9-20020ac25549000000b004f63739e2f1sm2559845lfk.255.2023.06.15.05.56.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jun 2023 05:56:51 -0700 (PDT)
Message-ID: <18103637-c191-9b8f-7983-d0b1591f9024@linaro.org>
Date: Thu, 15 Jun 2023 14:56:49 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH v2 19/23] arm64: dts: qcom: sa8775p: add the SGMII PHY
 node
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
References: <20230615121419.175862-1-brgl@bgdev.pl>
 <20230615121419.175862-20-brgl@bgdev.pl>
From: Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <20230615121419.175862-20-brgl@bgdev.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 15.06.2023 14:14, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> 
> Add the internal SGMII/SerDes PHY node for sa8775p platforms.
> 
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> ---
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>

Konrad
>  arch/arm64/boot/dts/qcom/sa8775p.dtsi | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/qcom/sa8775p.dtsi b/arch/arm64/boot/dts/qcom/sa8775p.dtsi
> index b130136acffe..b6d95813c98c 100644
> --- a/arch/arm64/boot/dts/qcom/sa8775p.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sa8775p.dtsi
> @@ -1837,6 +1837,15 @@ adreno_smmu: iommu@3da0000 {
>  				     <GIC_SPI 687 IRQ_TYPE_LEVEL_HIGH>;
>  		};
>  
> +		serdes0: phy@8901000 {
> +			compatible = "qcom,sa8775p-dwmac-sgmii-phy";
> +			reg = <0x0 0x08901000 0x0 0xe10>;
> +			clocks = <&gcc GCC_SGMI_CLKREF_EN>;
> +			clock-names = "sgmi_ref";
> +			#phy-cells = <0>;
> +			status = "disabled";
> +		};
> +
>  		pdc: interrupt-controller@b220000 {
>  			compatible = "qcom,sa8775p-pdc", "qcom,pdc";
>  			reg = <0x0 0x0b220000 0x0 0x30000>,

