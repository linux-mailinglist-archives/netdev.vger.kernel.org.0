Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB307455222
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 02:21:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242220AbhKRBYH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 20:24:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242216AbhKRBYB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 20:24:01 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6643AC061766
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 17:21:02 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id s139so10404513oie.13
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 17:21:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aqSZhyWfYsbKTpwS46J6kuVcH8BzoHzzhuZvEn957Zc=;
        b=yzwyCYNBPoMtUOB/VoZOvkS/bfTiZFiI+d3BxMqY833RZOOtiBOXUEPR5IUwiMW+9l
         /pIHBi43kitBruH65fIN6sLQKRoiwHQ9ukljSjGEol/qxWMlErwSE6n2Z8rkCfKQQBPO
         wbGpvsxK+tVIhlhYL9HbBGstgmrUfB7PrU6RpL8xyBuEmxKXg+3KcQCkmRCRPtiujFFc
         PULMkeytYDVwhvXQtKTdL/4/LvVCzsOcV7DElwJdefGt7Uq7ksCOcocFug8mZoYw4zLe
         flyF3etShTPCMQxkwK8RpgH6IbDKNdIlD9yyAoXzKTVb7+aTvSBOkI32sDXFfBvOCZuC
         cakg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aqSZhyWfYsbKTpwS46J6kuVcH8BzoHzzhuZvEn957Zc=;
        b=UHZS/Jgv1tIRhfpz3dd5kwN3mOjTXhEuFhw7YdoyKBh7yFm97NNCiXkdM3pmoo0gDW
         3TWZJssa6B93tA5qut8bMxwUdGEzpWBWEaBbpc7jHzPop2SEYQ48PSmBovPTh0yGghUQ
         k2mOTHddVOTL8kI0dBAdJ45+e09YqKzDSD1rVppubh00RrCiK2G/aYzWGt9XAXqCOyUp
         zrO2A5h2v9jMewtjlj3KLp+CBioYLpS4XiiMTpIz1wFYuvkJbrQfsmp/W2sWt5Q5+gFq
         FhNaK0xmwNLpo4Ru1N4C8BtEuHaO08HZsEb6Mn8gT/fLRgR+2iWHTCTLOOpvETJo7xrP
         Paxg==
X-Gm-Message-State: AOAM530buwmauxykTFCpdbqmpOZdIHT2Rq8uKg3sYXapxgmtu2uanlMm
        dx6FIQtnzs9VyYvgyyporIr0Aw==
X-Google-Smtp-Source: ABdhPJzOTR122IBvOTBe/11LXWOlvqgSGLXL6ePG3iNkd/4HyLYb11OYKBnURf08tRuboiqlNVeiAQ==
X-Received: by 2002:aca:4307:: with SMTP id q7mr4061917oia.3.1637198461459;
        Wed, 17 Nov 2021 17:21:01 -0800 (PST)
Received: from builder.lan (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id e28sm384957oiy.10.2021.11.17.17.21.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 17:21:00 -0800 (PST)
Date:   Wed, 17 Nov 2021 19:20:56 -0600
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     David Heidelberg <david@ixit.cz>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijeshkumar.singh@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Rob Herring <robh+dt@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        ~okias/devicetree@lists.sr.ht, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm64: dts: drop legacy property #stream-id-cells
Message-ID: <YZWqeLCf5G0kt2WF@builder.lan>
References: <20211030103117.33264-1-david@ixit.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211030103117.33264-1-david@ixit.cz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat 30 Oct 05:31 CDT 2021, David Heidelberg wrote:

> Property #stream-id-cells is legacy leftover and isn't currently
> documented nor used.
> 
> Signed-off-by: David Heidelberg <david@ixit.cz>
> ---
>  .../boot/dts/amd/amd-seattle-xgbe-b.dtsi      |  2 --
>  arch/arm64/boot/dts/qcom/msm8996.dtsi         |  1 -
>  arch/arm64/boot/dts/qcom/msm8998.dtsi         |  1 -
>  arch/arm64/boot/dts/qcom/sc7180.dtsi          |  1 -
>  arch/arm64/boot/dts/qcom/sc7280.dtsi          |  1 -
>  arch/arm64/boot/dts/qcom/sdm630.dtsi          |  1 -
>  arch/arm64/boot/dts/qcom/sdm845.dtsi          |  1 -
>  arch/arm64/boot/dts/qcom/sm8150.dtsi          |  1 -
>  arch/arm64/boot/dts/qcom/sm8250.dtsi          |  1 -
>  arch/arm64/boot/dts/xilinx/zynqmp.dtsi        | 28 -------------------

Thanks for the patch, unfortunately amd, qcom and xilinx patches goes
through different maintainers and it would be convenient if it was split
up as such. (And there's the comment about dropping the amd change).

So could you please respin this as a qcom and a xilinx patch? (And note
that to remove any room for confusion, they don't even need to be sent
together in the same series).

Thanks,
Bjorn

>  10 files changed, 38 deletions(-)
> 
> diff --git a/arch/arm64/boot/dts/amd/amd-seattle-xgbe-b.dtsi b/arch/arm64/boot/dts/amd/amd-seattle-xgbe-b.dtsi
> index d97498361ce3..3e9faace47f2 100644
> --- a/arch/arm64/boot/dts/amd/amd-seattle-xgbe-b.dtsi
> +++ b/arch/arm64/boot/dts/amd/amd-seattle-xgbe-b.dtsi
> @@ -55,7 +55,6 @@ xgmac0: xgmac@e0700000 {
>  		clocks = <&xgmacclk0_dma_250mhz>, <&xgmacclk0_ptp_250mhz>;
>  		clock-names = "dma_clk", "ptp_clk";
>  		phy-mode = "xgmii";
> -		#stream-id-cells = <16>;
>  		dma-coherent;
>  	};
>  
> @@ -81,7 +80,6 @@ xgmac1: xgmac@e0900000 {
>  		clocks = <&xgmacclk1_dma_250mhz>, <&xgmacclk1_ptp_250mhz>;
>  		clock-names = "dma_clk", "ptp_clk";
>  		phy-mode = "xgmii";
> -		#stream-id-cells = <16>;
>  		dma-coherent;
>  	};
>  
> diff --git a/arch/arm64/boot/dts/qcom/msm8996.dtsi b/arch/arm64/boot/dts/qcom/msm8996.dtsi
> index 1ac78d9909ab..91bc974aeb0a 100644
> --- a/arch/arm64/boot/dts/qcom/msm8996.dtsi
> +++ b/arch/arm64/boot/dts/qcom/msm8996.dtsi
> @@ -962,7 +962,6 @@ hdmi_phy: hdmi-phy@9a0600 {
>  
>  		gpu: gpu@b00000 {
>  			compatible = "qcom,adreno-530.2", "qcom,adreno";
> -			#stream-id-cells = <16>;
>  
>  			reg = <0x00b00000 0x3f000>;
>  			reg-names = "kgsl_3d0_reg_memory";
> diff --git a/arch/arm64/boot/dts/qcom/msm8998.dtsi b/arch/arm64/boot/dts/qcom/msm8998.dtsi
> index 408f265e277b..f273bc1ff629 100644
> --- a/arch/arm64/boot/dts/qcom/msm8998.dtsi
> +++ b/arch/arm64/boot/dts/qcom/msm8998.dtsi
> @@ -1446,7 +1446,6 @@ adreno_gpu: gpu@5000000 {
>  			iommus = <&adreno_smmu 0>;
>  			operating-points-v2 = <&gpu_opp_table>;
>  			power-domains = <&rpmpd MSM8998_VDDMX>;
> -			#stream-id-cells = <16>;
>  			status = "disabled";
>  
>  			gpu_opp_table: opp-table {
> diff --git a/arch/arm64/boot/dts/qcom/sc7180.dtsi b/arch/arm64/boot/dts/qcom/sc7180.dtsi
> index faf8b807d0ff..2151cd8c8c7a 100644
> --- a/arch/arm64/boot/dts/qcom/sc7180.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sc7180.dtsi
> @@ -1952,7 +1952,6 @@ glink-edge {
>  
>  		gpu: gpu@5000000 {
>  			compatible = "qcom,adreno-618.0", "qcom,adreno";
> -			#stream-id-cells = <16>;
>  			reg = <0 0x05000000 0 0x40000>, <0 0x0509e000 0 0x1000>,
>  				<0 0x05061000 0 0x800>;
>  			reg-names = "kgsl_3d0_reg_memory", "cx_mem", "cx_dbgc";
> diff --git a/arch/arm64/boot/dts/qcom/sc7280.dtsi b/arch/arm64/boot/dts/qcom/sc7280.dtsi
> index 365a2e04e285..2473615bafae 100644
> --- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
> @@ -1747,7 +1747,6 @@ lpass_ag_noc: interconnect@3c40000 {
>  
>  		gpu: gpu@3d00000 {
>  			compatible = "qcom,adreno-635.0", "qcom,adreno";
> -			#stream-id-cells = <16>;
>  			reg = <0 0x03d00000 0 0x40000>,
>  			      <0 0x03d9e000 0 0x1000>,
>  			      <0 0x03d61000 0 0x800>;
> diff --git a/arch/arm64/boot/dts/qcom/sdm630.dtsi b/arch/arm64/boot/dts/qcom/sdm630.dtsi
> index 3e0165bb61c5..d1178e90b15f 100644
> --- a/arch/arm64/boot/dts/qcom/sdm630.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sdm630.dtsi
> @@ -1014,7 +1014,6 @@ sd-cd {
>  
>  		adreno_gpu: gpu@5000000 {
>  			compatible = "qcom,adreno-508.0", "qcom,adreno";
> -			#stream-id-cells = <16>;
>  
>  			reg = <0x05000000 0x40000>;
>  			reg-names = "kgsl_3d0_reg_memory";
> diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
> index 526087586ba4..ff344a9a81a6 100644
> --- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
> @@ -4415,7 +4415,6 @@ dsi1_phy: dsi-phy@ae96400 {
>  
>  		gpu: gpu@5000000 {
>  			compatible = "qcom,adreno-630.2", "qcom,adreno";
> -			#stream-id-cells = <16>;
>  
>  			reg = <0 0x5000000 0 0x40000>, <0 0x509e000 0 0x10>;
>  			reg-names = "kgsl_3d0_reg_memory", "cx_mem";
> diff --git a/arch/arm64/boot/dts/qcom/sm8150.dtsi b/arch/arm64/boot/dts/qcom/sm8150.dtsi
> index 81b4ff2cc4cd..6012322a5984 100644
> --- a/arch/arm64/boot/dts/qcom/sm8150.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sm8150.dtsi
> @@ -1785,7 +1785,6 @@ gpu: gpu@2c00000 {
>  			compatible = "qcom,adreno-640.1",
>  				     "qcom,adreno",
>  				     "amd,imageon";
> -			#stream-id-cells = <16>;
>  
>  			reg = <0 0x02c00000 0 0x40000>;
>  			reg-names = "kgsl_3d0_reg_memory";
> diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
> index 6f6129b39c9c..9e5fc5145191 100644
> --- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
> @@ -1928,7 +1928,6 @@ data {
>  		gpu: gpu@3d00000 {
>  			compatible = "qcom,adreno-650.2",
>  				     "qcom,adreno";
> -			#stream-id-cells = <16>;
>  
>  			reg = <0 0x03d00000 0 0x40000>;
>  			reg-names = "kgsl_3d0_reg_memory";
> diff --git a/arch/arm64/boot/dts/xilinx/zynqmp.dtsi b/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
> index 74e66443e4ce..493719f71fb5 100644
> --- a/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
> +++ b/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
> @@ -262,7 +262,6 @@ fpd_dma_chan1: dma@fd500000 {
>  			interrupts = <0 124 4>;
>  			clock-names = "clk_main", "clk_apb";
>  			xlnx,bus-width = <128>;
> -			#stream-id-cells = <1>;
>  			iommus = <&smmu 0x14e8>;
>  			power-domains = <&zynqmp_firmware PD_GDMA>;
>  		};
> @@ -275,7 +274,6 @@ fpd_dma_chan2: dma@fd510000 {
>  			interrupts = <0 125 4>;
>  			clock-names = "clk_main", "clk_apb";
>  			xlnx,bus-width = <128>;
> -			#stream-id-cells = <1>;
>  			iommus = <&smmu 0x14e9>;
>  			power-domains = <&zynqmp_firmware PD_GDMA>;
>  		};
> @@ -288,7 +286,6 @@ fpd_dma_chan3: dma@fd520000 {
>  			interrupts = <0 126 4>;
>  			clock-names = "clk_main", "clk_apb";
>  			xlnx,bus-width = <128>;
> -			#stream-id-cells = <1>;
>  			iommus = <&smmu 0x14ea>;
>  			power-domains = <&zynqmp_firmware PD_GDMA>;
>  		};
> @@ -301,7 +298,6 @@ fpd_dma_chan4: dma@fd530000 {
>  			interrupts = <0 127 4>;
>  			clock-names = "clk_main", "clk_apb";
>  			xlnx,bus-width = <128>;
> -			#stream-id-cells = <1>;
>  			iommus = <&smmu 0x14eb>;
>  			power-domains = <&zynqmp_firmware PD_GDMA>;
>  		};
> @@ -314,7 +310,6 @@ fpd_dma_chan5: dma@fd540000 {
>  			interrupts = <0 128 4>;
>  			clock-names = "clk_main", "clk_apb";
>  			xlnx,bus-width = <128>;
> -			#stream-id-cells = <1>;
>  			iommus = <&smmu 0x14ec>;
>  			power-domains = <&zynqmp_firmware PD_GDMA>;
>  		};
> @@ -327,7 +322,6 @@ fpd_dma_chan6: dma@fd550000 {
>  			interrupts = <0 129 4>;
>  			clock-names = "clk_main", "clk_apb";
>  			xlnx,bus-width = <128>;
> -			#stream-id-cells = <1>;
>  			iommus = <&smmu 0x14ed>;
>  			power-domains = <&zynqmp_firmware PD_GDMA>;
>  		};
> @@ -340,7 +334,6 @@ fpd_dma_chan7: dma@fd560000 {
>  			interrupts = <0 130 4>;
>  			clock-names = "clk_main", "clk_apb";
>  			xlnx,bus-width = <128>;
> -			#stream-id-cells = <1>;
>  			iommus = <&smmu 0x14ee>;
>  			power-domains = <&zynqmp_firmware PD_GDMA>;
>  		};
> @@ -353,7 +346,6 @@ fpd_dma_chan8: dma@fd570000 {
>  			interrupts = <0 131 4>;
>  			clock-names = "clk_main", "clk_apb";
>  			xlnx,bus-width = <128>;
> -			#stream-id-cells = <1>;
>  			iommus = <&smmu 0x14ef>;
>  			power-domains = <&zynqmp_firmware PD_GDMA>;
>  		};
> @@ -383,7 +375,6 @@ lpd_dma_chan1: dma@ffa80000 {
>  			interrupts = <0 77 4>;
>  			clock-names = "clk_main", "clk_apb";
>  			xlnx,bus-width = <64>;
> -			#stream-id-cells = <1>;
>  			iommus = <&smmu 0x868>;
>  			power-domains = <&zynqmp_firmware PD_ADMA>;
>  		};
> @@ -396,7 +387,6 @@ lpd_dma_chan2: dma@ffa90000 {
>  			interrupts = <0 78 4>;
>  			clock-names = "clk_main", "clk_apb";
>  			xlnx,bus-width = <64>;
> -			#stream-id-cells = <1>;
>  			iommus = <&smmu 0x869>;
>  			power-domains = <&zynqmp_firmware PD_ADMA>;
>  		};
> @@ -409,7 +399,6 @@ lpd_dma_chan3: dma@ffaa0000 {
>  			interrupts = <0 79 4>;
>  			clock-names = "clk_main", "clk_apb";
>  			xlnx,bus-width = <64>;
> -			#stream-id-cells = <1>;
>  			iommus = <&smmu 0x86a>;
>  			power-domains = <&zynqmp_firmware PD_ADMA>;
>  		};
> @@ -422,7 +411,6 @@ lpd_dma_chan4: dma@ffab0000 {
>  			interrupts = <0 80 4>;
>  			clock-names = "clk_main", "clk_apb";
>  			xlnx,bus-width = <64>;
> -			#stream-id-cells = <1>;
>  			iommus = <&smmu 0x86b>;
>  			power-domains = <&zynqmp_firmware PD_ADMA>;
>  		};
> @@ -435,7 +423,6 @@ lpd_dma_chan5: dma@ffac0000 {
>  			interrupts = <0 81 4>;
>  			clock-names = "clk_main", "clk_apb";
>  			xlnx,bus-width = <64>;
> -			#stream-id-cells = <1>;
>  			iommus = <&smmu 0x86c>;
>  			power-domains = <&zynqmp_firmware PD_ADMA>;
>  		};
> @@ -448,7 +435,6 @@ lpd_dma_chan6: dma@ffad0000 {
>  			interrupts = <0 82 4>;
>  			clock-names = "clk_main", "clk_apb";
>  			xlnx,bus-width = <64>;
> -			#stream-id-cells = <1>;
>  			iommus = <&smmu 0x86d>;
>  			power-domains = <&zynqmp_firmware PD_ADMA>;
>  		};
> @@ -461,7 +447,6 @@ lpd_dma_chan7: dma@ffae0000 {
>  			interrupts = <0 83 4>;
>  			clock-names = "clk_main", "clk_apb";
>  			xlnx,bus-width = <64>;
> -			#stream-id-cells = <1>;
>  			iommus = <&smmu 0x86e>;
>  			power-domains = <&zynqmp_firmware PD_ADMA>;
>  		};
> @@ -474,7 +459,6 @@ lpd_dma_chan8: dma@ffaf0000 {
>  			interrupts = <0 84 4>;
>  			clock-names = "clk_main", "clk_apb";
>  			xlnx,bus-width = <64>;
> -			#stream-id-cells = <1>;
>  			iommus = <&smmu 0x86f>;
>  			power-domains = <&zynqmp_firmware PD_ADMA>;
>  		};
> @@ -495,7 +479,6 @@ nand0: nand-controller@ff100000 {
>  			interrupts = <0 14 4>;
>  			#address-cells = <1>;
>  			#size-cells = <0>;
> -			#stream-id-cells = <1>;
>  			iommus = <&smmu 0x872>;
>  			power-domains = <&zynqmp_firmware PD_NAND>;
>  		};
> @@ -509,7 +492,6 @@ gem0: ethernet@ff0b0000 {
>  			clock-names = "pclk", "hclk", "tx_clk";
>  			#address-cells = <1>;
>  			#size-cells = <0>;
> -			#stream-id-cells = <1>;
>  			iommus = <&smmu 0x874>;
>  			power-domains = <&zynqmp_firmware PD_ETH_0>;
>  		};
> @@ -523,7 +505,6 @@ gem1: ethernet@ff0c0000 {
>  			clock-names = "pclk", "hclk", "tx_clk";
>  			#address-cells = <1>;
>  			#size-cells = <0>;
> -			#stream-id-cells = <1>;
>  			iommus = <&smmu 0x875>;
>  			power-domains = <&zynqmp_firmware PD_ETH_1>;
>  		};
> @@ -537,7 +518,6 @@ gem2: ethernet@ff0d0000 {
>  			clock-names = "pclk", "hclk", "tx_clk";
>  			#address-cells = <1>;
>  			#size-cells = <0>;
> -			#stream-id-cells = <1>;
>  			iommus = <&smmu 0x876>;
>  			power-domains = <&zynqmp_firmware PD_ETH_2>;
>  		};
> @@ -551,7 +531,6 @@ gem3: ethernet@ff0e0000 {
>  			clock-names = "pclk", "hclk", "tx_clk";
>  			#address-cells = <1>;
>  			#size-cells = <0>;
> -			#stream-id-cells = <1>;
>  			iommus = <&smmu 0x877>;
>  			power-domains = <&zynqmp_firmware PD_ETH_3>;
>  		};
> @@ -621,7 +600,6 @@ pcie: pcie@fd0e0000 {
>  					<0x0 0x0 0x0 0x2 &pcie_intc 0x2>,
>  					<0x0 0x0 0x0 0x3 &pcie_intc 0x3>,
>  					<0x0 0x0 0x0 0x4 &pcie_intc 0x4>;
> -			#stream-id-cells = <1>;
>  			iommus = <&smmu 0x4d0>;
>  			power-domains = <&zynqmp_firmware PD_PCIE>;
>  			pcie_intc: legacy-interrupt-controller {
> @@ -642,7 +620,6 @@ qspi: spi@ff0f0000 {
>  			      <0x0 0xc0000000 0x0 0x8000000>;
>  			#address-cells = <1>;
>  			#size-cells = <0>;
> -			#stream-id-cells = <1>;
>  			iommus = <&smmu 0x873>;
>  			power-domains = <&zynqmp_firmware PD_QSPI>;
>  		};
> @@ -674,7 +651,6 @@ sata: ahci@fd0c0000 {
>  			interrupts = <0 133 4>;
>  			power-domains = <&zynqmp_firmware PD_SATA>;
>  			resets = <&zynqmp_reset ZYNQMP_RESET_SATA>;
> -			#stream-id-cells = <4>;
>  			iommus = <&smmu 0x4c0>, <&smmu 0x4c1>,
>  				 <&smmu 0x4c2>, <&smmu 0x4c3>;
>  		};
> @@ -686,7 +662,6 @@ sdhci0: mmc@ff160000 {
>  			interrupts = <0 48 4>;
>  			reg = <0x0 0xff160000 0x0 0x1000>;
>  			clock-names = "clk_xin", "clk_ahb";
> -			#stream-id-cells = <1>;
>  			iommus = <&smmu 0x870>;
>  			#clock-cells = <1>;
>  			clock-output-names = "clk_out_sd0", "clk_in_sd0";
> @@ -700,7 +675,6 @@ sdhci1: mmc@ff170000 {
>  			interrupts = <0 49 4>;
>  			reg = <0x0 0xff170000 0x0 0x1000>;
>  			clock-names = "clk_xin", "clk_ahb";
> -			#stream-id-cells = <1>;
>  			iommus = <&smmu 0x871>;
>  			#clock-cells = <1>;
>  			clock-output-names = "clk_out_sd1", "clk_in_sd1";
> @@ -825,7 +799,6 @@ dwc3_0: usb@fe200000 {
>  				interrupt-parent = <&gic>;
>  				interrupt-names = "dwc_usb3", "otg";
>  				interrupts = <0 65 4>, <0 69 4>;
> -				#stream-id-cells = <1>;
>  				iommus = <&smmu 0x860>;
>  				snps,quirk-frame-length-adjustment = <0x20>;
>  				/* dma-coherent; */
> @@ -852,7 +825,6 @@ dwc3_1: usb@fe300000 {
>  				interrupt-parent = <&gic>;
>  				interrupt-names = "dwc_usb3", "otg";
>  				interrupts = <0 70 4>, <0 74 4>;
> -				#stream-id-cells = <1>;
>  				iommus = <&smmu 0x861>;
>  				snps,quirk-frame-length-adjustment = <0x20>;
>  				/* dma-coherent; */
> -- 
> 2.33.0
> 
