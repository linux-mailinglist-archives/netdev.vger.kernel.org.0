Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3D2B6D6C4D
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 20:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236193AbjDDSgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 14:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236221AbjDDSgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 14:36:22 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C47559FD
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 11:34:27 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id h25so43525601lfv.6
        for <netdev@vger.kernel.org>; Tue, 04 Apr 2023 11:34:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680633265;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=orJHNSBUSwxWAVFJS4pfzA0KQDggc/uVMZltKMKuHVI=;
        b=PfUHGnUuhlmgR3aUQAX/r/U8r/ZYPX2YOetxeW8hJRaBzMotkiA9R1EF5V/gusMeA1
         U1v+FlIHyLCZTiTV0xchtgK/7J2QHmFPFW0+K7Nf3Jhoq9gc37ZVC2G0mq15BeyC0JtV
         gnL3B5nQ8Z8qFRxblML/TWf+vlgV4vFmjPGLDm6JOKixqKIiu8zckICuxtJLx2DZaNVX
         IbWlAz6SQzsSOHdd6afDgL94AHR0nNgkREK4lqVSooo0DagE+yO4K0id2y6VtfP974gw
         AC4bgqrbxYLhBQe+8Q7YqvFpb6I10ByCboefEESi3u1K7lWnhLz3i3C3TrlUpVWI9lzW
         /GKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680633265;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=orJHNSBUSwxWAVFJS4pfzA0KQDggc/uVMZltKMKuHVI=;
        b=yRRf7Yut2VogOQ0WN0sLZ3kXtxdoMZVEPv51EewqpqYrz8l68gYW0cllWX+WqMbO2k
         yv5g1tIlEVsVrNJn/+uK5bC7wrKQ0dyKpdmhoqS7shdF15GlCDgm6QRMtqIkibv7LU0U
         2OLOv8GXWkPZ3lZLmxMmPc7FBqbAyNIZF6l7chofESzxjfcPmJSSbydUrer7V4Jn3sEn
         lw+L7g/b7flwCgS8w8pM33DZ7yfVUlT8hc+hVARm81pCFE9t1Y18kIVHLdO0a1q0Q0Al
         wCjFs4wkFmqwEkK8dxpirf3J/owyaKg++ajCZiDXg94Bc8wqdNeeXpz9kwiHBC2gBc1p
         hrMA==
X-Gm-Message-State: AAQBX9f6+Su1UcbuMMBpZ02DJQ5xHEZile3x3eQ6KnFgtaKwVleSluZv
        ZHokLbMIMXeBFOe+Mw0yvEO2rw==
X-Google-Smtp-Source: AKy350aU2IZ6+6MvmW6lXe5XqjRleRRPL08I9gEp/YNZl9ljG2LZXYXvWdP3hWxAhUYJdI2nZY6+nA==
X-Received: by 2002:ac2:5989:0:b0:4de:e802:b7e3 with SMTP id w9-20020ac25989000000b004dee802b7e3mr923407lfn.19.1680633265603;
        Tue, 04 Apr 2023 11:34:25 -0700 (PDT)
Received: from [192.168.1.101] (abxh37.neoplus.adsl.tpnet.pl. [83.9.1.37])
        by smtp.gmail.com with ESMTPSA id o7-20020a05651238a700b004d887e0e9edsm2439673lft.168.2023.04.04.11.34.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Apr 2023 11:34:25 -0700 (PDT)
Message-ID: <0d2f0792-c7dd-7cdc-3c1c-454f445405aa@linaro.org>
Date:   Tue, 4 Apr 2023 20:34:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v3 2/3] arm64: dts: qcom: sc8280xp: Add ethernet nodes
Content-Language: en-US
To:     Andrew Halaney <ahalaney@redhat.com>, linux-kernel@vger.kernel.org
Cc:     agross@kernel.org, andersson@kernel.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, mturquette@baylibre.com,
        sboyd@kernel.org, richardcochran@gmail.com,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-clk@vger.kernel.org, netdev@vger.kernel.org,
        bmasney@redhat.com, echanude@redhat.com, ncai@quicinc.com,
        jsuraj@qti.qualcomm.com, hisunil@quicinc.com
References: <20230331215804.783439-1-ahalaney@redhat.com>
 <20230331215804.783439-3-ahalaney@redhat.com>
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <20230331215804.783439-3-ahalaney@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 31.03.2023 23:58, Andrew Halaney wrote:
> This platform has 2 MACs integrated in it, go ahead and describe them.
> 
> Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
> ---
> 
> Changes since v2:
>     * Fix spacing (Konrad)
> 
> Changes since v1:
>     * None
> 
>  arch/arm64/boot/dts/qcom/sc8280xp.dtsi | 59 ++++++++++++++++++++++++++
>  1 file changed, 59 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
> index 42bfa9fa5b96..f28ea86b128d 100644
> --- a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
> @@ -761,6 +761,65 @@ soc: soc@0 {
>  		ranges = <0 0 0 0 0x10 0>;
>  		dma-ranges = <0 0 0 0 0x10 0>;
>  
> +		ethernet0: ethernet@20000 {
> +			compatible = "qcom,sc8280xp-ethqos";
> +			reg = <0x0 0x00020000 0x0 0x10000>,
> +			      <0x0 0x00036000 0x0 0x100>;
> +			reg-names = "stmmaceth", "rgmii";
> +
> +			clocks = <&gcc GCC_EMAC0_AXI_CLK>,
> +				 <&gcc GCC_EMAC0_SLV_AHB_CLK>,
> +				 <&gcc GCC_EMAC0_PTP_CLK>,
> +				 <&gcc GCC_EMAC0_RGMII_CLK>;
> +			clock-names = "stmmaceth",
> +				      "pclk",
> +				      "ptp_ref",
> +				      "rgmii";
> +
> +			interrupts = <GIC_SPI 946 IRQ_TYPE_LEVEL_HIGH>,
> +				     <GIC_SPI 936 IRQ_TYPE_LEVEL_HIGH>;
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
Nodes under /soc should be ordered by their unit address, so
in this case it belongs after dispcc1: clock-controller@..

With that fixed:

Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>

Konrad
> +			compatible = "qcom,sc8280xp-ethqos";
> +			reg = <0x0 0x23000000 0x0 0x10000>,
> +			      <0x0 0x23016000 0x0 0x100>;
> +			reg-names = "stmmaceth", "rgmii";
> +
> +			clocks = <&gcc GCC_EMAC1_AXI_CLK>,
> +				 <&gcc GCC_EMAC1_SLV_AHB_CLK>,
> +				 <&gcc GCC_EMAC1_PTP_CLK>,
> +				 <&gcc GCC_EMAC1_RGMII_CLK>;
> +			clock-names = "stmmaceth",
> +				      "pclk",
> +				      "ptp_ref",
> +				      "rgmii";
> +
> +			interrupts = <GIC_SPI 929 IRQ_TYPE_LEVEL_HIGH>,
> +				     <GIC_SPI 919 IRQ_TYPE_LEVEL_HIGH>;
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
