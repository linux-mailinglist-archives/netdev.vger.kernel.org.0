Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4FF46C3ABD
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 20:35:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230410AbjCUTfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 15:35:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230342AbjCUTfA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 15:35:00 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C06C755510
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 12:34:27 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id y20so20544804lfj.2
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 12:34:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679427234;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JMHhMtonsK7206fFrguTPhzlan6ylHN3dFzR3FtCHqU=;
        b=DCkVJgx5M23kD7k2bq7WLI2pRpSdvanRfk8ncagMTwNUQVu7Bjxka0AtqfeIH53IVq
         ut6KpJq0gwl4w0bKU7woofqTwlkgHMYggthFa3SCl+F7I97qFXkWpyDVkHx8yyRAlS6n
         aNXbeNTBmjPs8frGvwiueaLoTnIrbSLW0YIlW7IfVtI8xH3+JWrbeAyy7CY5PgEOrMdJ
         WOj35tpXYPJCbKYONREBkVppfJ7IAtd/S43GdbRnMfvIAkghy6lzWoU/B79NpRVmCNGL
         5rAfZyHrHv4mxOJACUAEH8duhcXsVg1ynpYJYhr6gvNVsyww0ZUkpLmVHGIKSJHGGEqi
         fnRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679427234;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JMHhMtonsK7206fFrguTPhzlan6ylHN3dFzR3FtCHqU=;
        b=2LJ02eJgnQAm+ZqgFU9XA7mxg4jSsU0nG2Evf3S+YLGmaAqMYnuITiaHccjys5DGfx
         bto7/gjl1H0oZmlykwvdvuTQsUiIdItETvS35gcWSRb6QwVMtHksp7XJ4hWoPVHUXlY1
         wpudPTLZXLAJw6PHE/HzEH6cq0Y55dqMtsZqisNDF9g4FMq7mdBgUqQzZce8RuilT9G6
         8zDjDg8xw42JBeHr7sk9A0SXw5KP5zT8RxPqTE2WSurWfQXN7BA6EfbVUgg96gp+H/dW
         QeCh2aRKxW4dTUpJL3Y4waftH8bZK3+/spypNA5Hhcd3K3Ygp2ExuE/Efs4mOUqHSvT9
         tO0g==
X-Gm-Message-State: AO0yUKVSNdwHzoCvGlIdqwxhHnMsEUxjc2fZ7pH/pp8wJeqGbvcgYAZM
        UjEera7x6IKAtQ/8frCDvYPLjw==
X-Google-Smtp-Source: AK7set/7NLnyEkxDSUA9YVO7IO07SEYU/d89whtJ6yXcPqhZfZ0byhUFUgX/8egdo7Ka51f2/nft4w==
X-Received: by 2002:ac2:44da:0:b0:4ea:c730:aac3 with SMTP id d26-20020ac244da000000b004eac730aac3mr1356890lfm.3.1679427233818;
        Tue, 21 Mar 2023 12:33:53 -0700 (PDT)
Received: from [192.168.1.101] (abym238.neoplus.adsl.tpnet.pl. [83.9.32.238])
        by smtp.gmail.com with ESMTPSA id y3-20020ac24463000000b004db00b4c671sm2295208lfl.7.2023.03.21.12.33.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Mar 2023 12:33:53 -0700 (PDT)
Message-ID: <7d4f9662-2eb1-e2d2-193c-e6453dc7b93b@linaro.org>
Date:   Tue, 21 Mar 2023 20:33:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH net-next v2 06/12] arm64: dts: qcom: sc8280xp: Add
 ethernet nodes
Content-Language: en-US
To:     Andrew Halaney <ahalaney@redhat.com>, linux-kernel@vger.kernel.org
Cc:     agross@kernel.org, andersson@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        vkoul@kernel.org, bhupesh.sharma@linaro.org,
        mturquette@baylibre.com, sboyd@kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com, richardcochran@gmail.com,
        linux@armlinux.org.uk, veekhee@apple.com,
        tee.min.tan@linux.intel.com, mohammad.athari.ismail@intel.com,
        jonathanh@nvidia.com, ruppala@nvidia.com, bmasney@redhat.com,
        andrey.konovalov@linaro.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-clk@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, ncai@quicinc.com,
        jsuraj@qti.qualcomm.com, hisunil@quicinc.com, echanude@redhat.com
References: <20230320221617.236323-1-ahalaney@redhat.com>
 <20230320221617.236323-7-ahalaney@redhat.com>
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <20230320221617.236323-7-ahalaney@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 20.03.2023 23:16, Andrew Halaney wrote:
> This platform has 2 MACs integrated in it, go ahead and describe them.
> 
> Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
> ---
> 
> Changes since v1:
> 	* None
> 
>  arch/arm64/boot/dts/qcom/sc8280xp.dtsi | 53 ++++++++++++++++++++++++++
>  1 file changed, 53 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
> index 0d02599d8867..a63e8e81a8c4 100644
> --- a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
> @@ -761,6 +761,59 @@ soc: soc@0 {
>  		ranges = <0 0 0 0 0x10 0>;
>  		dma-ranges = <0 0 0 0 0x10 0>;
>  
> +		ethernet0: ethernet@20000 {
> +			compatible = "qcom,sc8280xp-ethqos";
> +			reg = <0x0 0x00020000 0x0 0x10000>,
> +				<0x0 0x00036000 0x0 0x100>;
Please correct the indentation here.

> +			reg-names = "stmmaceth", "rgmii";
> +
> +			clocks = <&gcc GCC_EMAC0_AXI_CLK>,
> +				<&gcc GCC_EMAC0_SLV_AHB_CLK>,
> +				<&gcc GCC_EMAC0_PTP_CLK>,
> +				<&gcc GCC_EMAC0_RGMII_CLK>;
Please correct the indentation here.

> +			clock-names = "stmmaceth", "pclk", "ptp_ref", "rgmii";
Please turn this into a vertical list.

> +
> +			interrupts = <GIC_SPI 946 IRQ_TYPE_LEVEL_HIGH>,
> +				<GIC_SPI 936 IRQ_TYPE_LEVEL_HIGH>;
Please correct the indentation here.

Same for the other node.

Konrad
> +			interrupt-names = "macirq", "eth_lpi";
> +			iommus = <&apps_smmu 0x4c0 0xf>;
> +			power-domains = <&gcc EMAC_0_GDSC>;
> +
> +			snps,tso;
> +			snps,pbl = <32>;
> +			rx-fifo-depth = <4096>;
> +			tx-fifo-depth = <4096>;
> +
> +			status = "disabled";
> +		};
> +
> +		ethernet1: ethernet@23000000 {
> +			compatible = "qcom,sc8280xp-ethqos";
> +			reg = <0x0 0x23000000 0x0 0x10000>,
> +				<0x0 0x23016000 0x0 0x100>;
> +			reg-names = "stmmaceth", "rgmii";
> +
> +			clocks = <&gcc GCC_EMAC1_AXI_CLK>,
> +				<&gcc GCC_EMAC1_SLV_AHB_CLK>,
> +				<&gcc GCC_EMAC1_PTP_CLK>,
> +				<&gcc GCC_EMAC1_RGMII_CLK>;
> +			clock-names = "stmmaceth", "pclk", "ptp_ref", "rgmii";
> +
> +			interrupts = <GIC_SPI 929 IRQ_TYPE_LEVEL_HIGH>,
> +				<GIC_SPI 919 IRQ_TYPE_LEVEL_HIGH>;
> +			interrupt-names = "macirq", "eth_lpi";
> +
> +			iommus = <&apps_smmu 0x40 0xf>;
> +			power-domains = <&gcc EMAC_1_GDSC>;
> +
> +			snps,tso;
> +			snps,pbl = <32>;
> +			rx-fifo-depth = <4096>;
> +			tx-fifo-depth = <4096>;
> +
> +			status = "disabled";
> +		};
> +
>  		gcc: clock-controller@100000 {
>  			compatible = "qcom,gcc-sc8280xp";
>  			reg = <0x0 0x00100000 0x0 0x1f0000>;
