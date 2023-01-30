Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE389681DA9
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 23:05:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbjA3WFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 17:05:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbjA3WFp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 17:05:45 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4C02366AB
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 14:05:42 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id d14so12528468wrr.9
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 14:05:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=emChjJeed1eKpYwI+TZyrMB77/b+qmQePLis86Dn8K8=;
        b=fF4QBHq/CayAljWbeGvBRmwAVeRYHWdRGWTDW5oc0VA+rNzgrWKPB6l4dTTecYOF/1
         f5RSzyYBEYaptwLCzcr7Znh4DPP0IKOYRwHL52HFfJgLIUTshE61h4ln6W+sjiE0QETr
         J5s742TG3xlskH4NKaRZhQTpIHroJPQh4uWffpNdpBLuUG/bqiP5ENz+1rX/3QNZXTHA
         9xtimiVFck9WH4GC8meOxr6KXR4167WaVm6e1IYdEIhvh3yMhik2yqwKi9VNWbhgtfNz
         5xS8D6GdmxoBR4FtOub17+v8o8lJiIiPoyzU8cb4pFZg106naVfFkWDVz3CKu8CQaWCR
         RxDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=emChjJeed1eKpYwI+TZyrMB77/b+qmQePLis86Dn8K8=;
        b=uDP5ChDKhIey4nMtgg2IL9QlJu60skFmPeeAib4BHz3/MIosWj0Ep5GtNe1V1swjxf
         Y8FQlQ7TQp/l5CtXwMW9eKDyCBqy9MSc6ry/5pDsyx06gFiqRYjYLwQdW/Stfy/OX24D
         mRZhUqWDJz8VJUmWGVMjVO0cHov4BBOOzkofX+/SE3BD1MWS4JcdhvC0/9ha4eX8fUzC
         oI2sFv+d0PO1w8Cxd339/FA/CxdARxLf5CDRNpnlF/AKRflcrkQEVKbNX7dmlKz3LHvO
         gUBm5rrphgN0YNk3lL4bjLS7yknPmWvBU2lOq2Oeu4TJO6V3rxD1lv/HD5JCNOxZjNgt
         9a6g==
X-Gm-Message-State: AO0yUKUkzQ6s7RvQaMWZSx8k2U0yPqmwY4SFOsY15hW+qFYlDPCVnfH6
        ZskVQCYr2zlqumXHxr4AXfyWwg==
X-Google-Smtp-Source: AK7set/q/q0k9a9lQBsL6bgV46xu7DFQ7Ahv4AtNiE/p5jjyWJWrbre/yVqDiB0Onvne9eV6NvNyoA==
X-Received: by 2002:adf:f041:0:b0:2bf:e45d:8e06 with SMTP id t1-20020adff041000000b002bfe45d8e06mr5871579wro.70.1675116341060;
        Mon, 30 Jan 2023 14:05:41 -0800 (PST)
Received: from linaro.org ([94.52.112.99])
        by smtp.gmail.com with ESMTPSA id u13-20020a5d514d000000b002be2f18938csm12847786wrt.41.2023.01.30.14.05.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 14:05:40 -0800 (PST)
Date:   Tue, 31 Jan 2023 00:05:38 +0200
From:   Abel Vesa <abel.vesa@linaro.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Abel Vesa <abelvesa@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Lee Jones <lee@kernel.org>, kernel@pengutronix.de,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Russell King <linux@armlinux.org.uk>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-clk@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 16/19] clk: imx6ul: add ethernet refclock mux support
Message-ID: <Y9g/Mpt+MywfJ6bx@linaro.org>
References: <20230117061453.3723649-1-o.rempel@pengutronix.de>
 <20230117061453.3723649-17-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230117061453.3723649-17-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23-01-17 07:14:50, Oleksij Rempel wrote:
> Add ethernet refclock mux support and set it to internal clock by
> default. This configuration will not affect existing boards.
> 
> clock tree before this patch:
> fec1 <- enet1_ref_125m (gate) <- enet1_ref (divider) <-,
>                                                        |- pll6_enet
> fec2 <- enet2_ref_125m (gate) <- enet2_ref (divider) <-´
> 
> after this patch:
> fec1 <- enet1_ref_sel(mux) <- enet1_ref_125m (gate) <- ...
>                `--<> enet1_ref_pad                      |- pll6_enet
> fec2 <- enet2_ref_sel(mux) <- enet2_ref_125m (gate) <- ...
>                `--<> enet2_ref_pad
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> Acked-by: Lee Jones <lee@kernel.org>

Reviewed-by: Abel Vesa <abel.vesa@linaro.org>

> ---
>  drivers/clk/imx/clk-imx6ul.c                | 26 +++++++++++++++++++++
>  include/dt-bindings/clock/imx6ul-clock.h    |  6 ++++-
>  include/linux/mfd/syscon/imx6q-iomuxc-gpr.h |  6 +++--
>  3 files changed, 35 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/clk/imx/clk-imx6ul.c b/drivers/clk/imx/clk-imx6ul.c
> index c3c465c1b0e7..2836adb817b7 100644
> --- a/drivers/clk/imx/clk-imx6ul.c
> +++ b/drivers/clk/imx/clk-imx6ul.c
> @@ -10,6 +10,7 @@
>  #include <linux/err.h>
>  #include <linux/init.h>
>  #include <linux/io.h>
> +#include <linux/mfd/syscon/imx6q-iomuxc-gpr.h>
>  #include <linux/of.h>
>  #include <linux/of_address.h>
>  #include <linux/of_irq.h>
> @@ -94,6 +95,17 @@ static const struct clk_div_table video_div_table[] = {
>  	{ }
>  };
>  
> +static const char * enet1_ref_sels[] = { "enet1_ref_125m", "enet1_ref_pad", };
> +static const u32 enet1_ref_sels_table[] = { IMX6UL_GPR1_ENET1_TX_CLK_DIR,
> +					    IMX6UL_GPR1_ENET1_CLK_SEL };
> +static const u32 enet1_ref_sels_table_mask = IMX6UL_GPR1_ENET1_TX_CLK_DIR |
> +					     IMX6UL_GPR1_ENET1_CLK_SEL;
> +static const char * enet2_ref_sels[] = { "enet2_ref_125m", "enet2_ref_pad", };
> +static const u32 enet2_ref_sels_table[] = { IMX6UL_GPR1_ENET2_TX_CLK_DIR,
> +					    IMX6UL_GPR1_ENET2_CLK_SEL };
> +static const u32 enet2_ref_sels_table_mask = IMX6UL_GPR1_ENET2_TX_CLK_DIR |
> +					     IMX6UL_GPR1_ENET2_CLK_SEL;
> +
>  static u32 share_count_asrc;
>  static u32 share_count_audio;
>  static u32 share_count_sai1;
> @@ -472,6 +484,17 @@ static void __init imx6ul_clocks_init(struct device_node *ccm_node)
>  	/* mask handshake of mmdc */
>  	imx_mmdc_mask_handshake(base, 0);
>  
> +	hws[IMX6UL_CLK_ENET1_REF_PAD] = imx_obtain_fixed_of_clock(ccm_node, "enet1_ref_pad", 0);
> +
> +	hws[IMX6UL_CLK_ENET1_REF_SEL] = imx_clk_gpr_mux("enet1_ref_sel", "fsl,imx6ul-iomuxc-gpr",
> +				IOMUXC_GPR1, enet1_ref_sels, ARRAY_SIZE(enet1_ref_sels),
> +				enet1_ref_sels_table, enet1_ref_sels_table_mask);
> +	hws[IMX6UL_CLK_ENET2_REF_PAD] = imx_obtain_fixed_of_clock(ccm_node, "enet2_ref_pad", 0);
> +
> +	hws[IMX6UL_CLK_ENET2_REF_SEL] = imx_clk_gpr_mux("enet2_ref_sel", "fsl,imx6ul-iomuxc-gpr",
> +				IOMUXC_GPR1, enet2_ref_sels, ARRAY_SIZE(enet2_ref_sels),
> +				enet2_ref_sels_table, enet2_ref_sels_table_mask);
> +
>  	imx_check_clk_hws(hws, IMX6UL_CLK_END);
>  
>  	of_clk_add_hw_provider(np, of_clk_hw_onecell_get, clk_hw_data);
> @@ -516,6 +539,9 @@ static void __init imx6ul_clocks_init(struct device_node *ccm_node)
>  		clk_set_parent(hws[IMX6ULL_CLK_EPDC_PRE_SEL]->clk, hws[IMX6UL_CLK_PLL3_PFD2]->clk);
>  
>  	clk_set_parent(hws[IMX6UL_CLK_ENFC_SEL]->clk, hws[IMX6UL_CLK_PLL2_PFD2]->clk);
> +
> +	clk_set_parent(hws[IMX6UL_CLK_ENET1_REF_SEL]->clk, hws[IMX6UL_CLK_ENET_REF]->clk);
> +	clk_set_parent(hws[IMX6UL_CLK_ENET2_REF_SEL]->clk, hws[IMX6UL_CLK_ENET2_REF]->clk);
>  }
>  
>  CLK_OF_DECLARE(imx6ul, "fsl,imx6ul-ccm", imx6ul_clocks_init);
> diff --git a/include/dt-bindings/clock/imx6ul-clock.h b/include/dt-bindings/clock/imx6ul-clock.h
> index b44920f1edb0..66239ebc0e23 100644
> --- a/include/dt-bindings/clock/imx6ul-clock.h
> +++ b/include/dt-bindings/clock/imx6ul-clock.h
> @@ -257,7 +257,11 @@
>  #define IMX6UL_CLK_GPIO5		248
>  #define IMX6UL_CLK_MMDC_P1_IPG		249
>  #define IMX6UL_CLK_ENET1_REF_125M	250
> +#define IMX6UL_CLK_ENET1_REF_SEL	251
> +#define IMX6UL_CLK_ENET1_REF_PAD	252
> +#define IMX6UL_CLK_ENET2_REF_SEL	253
> +#define IMX6UL_CLK_ENET2_REF_PAD	254
>  
> -#define IMX6UL_CLK_END			251
> +#define IMX6UL_CLK_END			255
>  
>  #endif /* __DT_BINDINGS_CLOCK_IMX6UL_H */
> diff --git a/include/linux/mfd/syscon/imx6q-iomuxc-gpr.h b/include/linux/mfd/syscon/imx6q-iomuxc-gpr.h
> index d4b5e527a7a3..09c6b3184bb0 100644
> --- a/include/linux/mfd/syscon/imx6q-iomuxc-gpr.h
> +++ b/include/linux/mfd/syscon/imx6q-iomuxc-gpr.h
> @@ -451,8 +451,10 @@
>  #define IMX6SX_GPR12_PCIE_RX_EQ_2			(0x2 << 0)
>  
>  /* For imx6ul iomux gpr register field define */
> -#define IMX6UL_GPR1_ENET1_CLK_DIR		(0x1 << 17)
> -#define IMX6UL_GPR1_ENET2_CLK_DIR		(0x1 << 18)
> +#define IMX6UL_GPR1_ENET2_TX_CLK_DIR		BIT(18)
> +#define IMX6UL_GPR1_ENET1_TX_CLK_DIR		BIT(17)
> +#define IMX6UL_GPR1_ENET2_CLK_SEL		BIT(14)
> +#define IMX6UL_GPR1_ENET1_CLK_SEL		BIT(13)
>  #define IMX6UL_GPR1_ENET1_CLK_OUTPUT		(0x1 << 17)
>  #define IMX6UL_GPR1_ENET2_CLK_OUTPUT		(0x1 << 18)
>  #define IMX6UL_GPR1_ENET_CLK_DIR		(0x3 << 17)
> -- 
> 2.30.2
> 
