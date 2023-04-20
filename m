Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 269386E8FAE
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 12:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234104AbjDTKNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 06:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234244AbjDTKNR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 06:13:17 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 244E56597
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 03:10:13 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id c3so2149311ljf.7
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 03:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681985411; x=1684577411;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UshHJmrBvOjOe+kFqRZqWcq1WGUK4b0DL+yogHh/OJ8=;
        b=fFNqK2kpnL8nMjB/6frDOPJGu+iaEXv1ou8942gBzAYcPAWD2EFA65xFsBQigFfyoZ
         ubP5USdRWNSSBVuB3LC5MXtkUn2NTKf7QRkOxyaa2a52KTSsGEuRzPnlwaI1N9exqZAv
         AIMjC9uIroKP+urHqzqsOySqwBYkjDFytrGDmWz8sE8LEBGGppdGk60ygxUvVfrEExZ4
         7U7bkJGRMpMmxZaNnPYiSjya0vzdArYiCXG9buyLpVQxQgH5mcUCYHs02izxlfQZWKx3
         ATnKHtTYrPP7QRt9lQyNso6PDIN1pwYAkyQAAoN1NAj+0FGuQe7LXbETxo/rNS5wqJPi
         IHwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681985411; x=1684577411;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UshHJmrBvOjOe+kFqRZqWcq1WGUK4b0DL+yogHh/OJ8=;
        b=JQ45qpGCKs4Dc0XB7z0EhezCzlKW6dgDAvhPkTx3grjXoYioieHcP1H7/JpiI9m76g
         LtbzOns8Rd4vLoOY7YqZ6PD2oYVmC6taTBHoRpgCkd4loSMmhuwktg5lrYoUd7u4V2mW
         egTiYbt/pKYcPx0/MO9LpqiVw84V7wNeF0hcUe1DAqgZ7O0N7NKbcNX4AFy8b+4ppyIt
         JSNE2QOydOlqO8dd+14jrAxTxqwW7OtGtp45W8zlFFshe3Qs8OPowIkrzYybXsO3r4Da
         Cf0PyzdmWhlcbbEsEPG/ZIQ+On6OJsl5S/G9GR1bkX5CbscIxD6YGOH0U09ylLcpssyp
         tXUQ==
X-Gm-Message-State: AAQBX9de6GZAD79PoYFrNcs2hAX5EhqB+fD+nCHZBJAKG5/0gdr/jy82
        HfHxuh0y794mFwl7p/JYQ74Lyg==
X-Google-Smtp-Source: AKy350ayoHSDO6XCkJCedmXKKvjN3YgFQS01jqetVZKLilov5d6fEnq36O6QaD/lfJcWaWQnYPqnzg==
X-Received: by 2002:a2e:9d50:0:b0:2a7:6b40:7ea2 with SMTP id y16-20020a2e9d50000000b002a76b407ea2mr324755ljj.14.1681985411250;
        Thu, 20 Apr 2023 03:10:11 -0700 (PDT)
Received: from ?IPV6:2001:14ba:a085:4d00::8a5? (dzccz6yyyyyyyyyyybcwt-3.rev.dnainternet.fi. [2001:14ba:a085:4d00::8a5])
        by smtp.gmail.com with ESMTPSA id j2-20020a2e8242000000b002a8d01905f7sm177536ljh.101.2023.04.20.03.10.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Apr 2023 03:10:10 -0700 (PDT)
Message-ID: <af5435c3-b3a4-af46-444e-023d6ee2304a@linaro.org>
Date:   Thu, 20 Apr 2023 13:10:10 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 4/4] clk: qcom: Add GCC driver support for SDX75
Content-Language: en-GB
To:     Taniya Das <quic_tdas@quicinc.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Michael Turquette <mturquette@baylibre.com>
Cc:     quic_skakitap@quicinc.com, Imran Shaik <quic_imrashai@quicinc.com>,
        linux-arm-msm@vger.kernel.org, linux-clk@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        quic_rohiagar@quicinc.com, netdev@vger.kernel.org
References: <20230419133013.2563-1-quic_tdas@quicinc.com>
 <20230419133013.2563-5-quic_tdas@quicinc.com>
From:   Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
In-Reply-To: <20230419133013.2563-5-quic_tdas@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/04/2023 16:30, Taniya Das wrote:
> From: Imran Shaik <quic_imrashai@quicinc.com>
> 
> Add Global Clock Controller (GCC) support for SDX75 platform.
> 
> Signed-off-by: Imran Shaik <quic_imrashai@quicinc.com>
> Signed-off-by: Taniya Das <quic_tdas@quicinc.com>
> ---
>   drivers/clk/qcom/Kconfig     |    8 +
>   drivers/clk/qcom/Makefile    |    1 +
>   drivers/clk/qcom/gcc-sdx75.c | 2990 ++++++++++++++++++++++++++++++++++
>   3 files changed, 2999 insertions(+)
>   create mode 100644 drivers/clk/qcom/gcc-sdx75.c
> 
> diff --git a/drivers/clk/qcom/Kconfig b/drivers/clk/qcom/Kconfig
> index 5ab4b7dfe3c2..4df48b02bb0c 100644
> --- a/drivers/clk/qcom/Kconfig
> +++ b/drivers/clk/qcom/Kconfig
> @@ -644,6 +644,14 @@ config SDX_GCC_65
>   	  Say Y if you want to use peripheral devices such as UART,
>   	  SPI, I2C, USB, SD/UFS, PCIe etc.
>   
> +config SDX_GCC_75
> +	tristate "SDX75 Global Clock Controller"
> +	select QCOM_GDSC
> +	help
> +	  Support for the global clock controller on SDX75 devices.
> +	  Say Y if you want to use peripheral devices such as UART,
> +	  SPI, I2C, USB, SD/eMMC, PCIe etc.
> +
>   config SM_CAMCC_6350
>   	tristate "SM6350 Camera Clock Controller"
>   	select SM_GCC_6350
> diff --git a/drivers/clk/qcom/Makefile b/drivers/clk/qcom/Makefile
> index c743805a9cbb..0964be5ed4c2 100644
> --- a/drivers/clk/qcom/Makefile
> +++ b/drivers/clk/qcom/Makefile
> @@ -93,6 +93,7 @@ obj-$(CONFIG_SDM_LPASSCC_845) += lpasscc-sdm845.o
>   obj-$(CONFIG_SDM_VIDEOCC_845) += videocc-sdm845.o
>   obj-$(CONFIG_SDX_GCC_55) += gcc-sdx55.o
>   obj-$(CONFIG_SDX_GCC_65) += gcc-sdx65.o
> +obj-$(CONFIG_SDX_GCC_75) += gcc-sdx75.o
>   obj-$(CONFIG_SM_CAMCC_6350) += camcc-sm6350.o
>   obj-$(CONFIG_SM_CAMCC_8250) += camcc-sm8250.o
>   obj-$(CONFIG_SM_CAMCC_8450) += camcc-sm8450.o
> diff --git a/drivers/clk/qcom/gcc-sdx75.c b/drivers/clk/qcom/gcc-sdx75.c
> new file mode 100644
> index 000000000000..25f7e5b81683
> --- /dev/null
> +++ b/drivers/clk/qcom/gcc-sdx75.c
> @@ -0,0 +1,2990 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (c) 2022-2023, Qualcomm Innovation Center, Inc. All rights reserved.
> + */
> +
> +#include <linux/clk-provider.h>
> +#include <linux/module.h>
> +#include <linux/of_device.h>
> +#include <linux/regmap.h>
> +
> +#include <dt-bindings/clock/qcom,gcc-sdx75.h>
> +
> +#include "clk-alpha-pll.h"
> +#include "clk-branch.h"
> +#include "clk-rcg.h"
> +#include "clk-regmap.h"
> +#include "clk-regmap-divider.h"
> +#include "clk-regmap-mux.h"
> +#include "gdsc.h"
> +#include "reset.h"
> +
> +enum {
> +	DT_BI_TCXO,
> +	DT_SLEEP_CLK,
> +};
> +
> +enum {
> +	P_BI_TCXO,
> +	P_EMAC0_SGMIIPHY_MAC_RCLK,
> +	P_EMAC0_SGMIIPHY_MAC_TCLK,
> +	P_EMAC0_SGMIIPHY_RCLK,
> +	P_EMAC0_SGMIIPHY_TCLK,
> +	P_EMAC1_SGMIIPHY_MAC_RCLK,
> +	P_EMAC1_SGMIIPHY_MAC_TCLK,
> +	P_EMAC1_SGMIIPHY_RCLK,
> +	P_EMAC1_SGMIIPHY_TCLK,
> +	P_GPLL0_OUT_EVEN,
> +	P_GPLL0_OUT_MAIN,
> +	P_GPLL4_OUT_MAIN,
> +	P_GPLL5_OUT_MAIN,
> +	P_GPLL6_OUT_MAIN,
> +	P_GPLL8_OUT_MAIN,
> +	P_PCIE20_PHY_AUX_CLK,
> +	P_PCIE_1_PIPE_CLK,
> +	P_PCIE_2_PIPE_CLK,
> +	P_PCIE_PIPE_CLK,
> +	P_SLEEP_CLK,
> +	P_USB3_PHY_WRAPPER_GCC_USB30_PIPE_CLK,
> +};
> +
> +static struct clk_alpha_pll gpll0 = {
> +	.offset = 0x0,
> +	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_LUCID_OLE],
> +	.clkr = {
> +		.enable_reg = 0x7d000,
> +		.enable_mask = BIT(0),
> +		.hw.init = &(const struct clk_init_data) {
> +			.name = "gpll0",
> +			.parent_data = &(const struct clk_parent_data) {
> +				.index = DT_BI_TCXO,
> +			},
> +			.num_parents = 1,
> +			.ops = &clk_alpha_pll_fixed_lucid_ole_ops,
> +		},
> +	},
> +};
> +
> +static const struct clk_div_table post_div_table_gpll0_out_even[] = {
> +	{ 0x1, 2 },
> +	{ }
> +};
> +
> +static struct clk_alpha_pll_postdiv gpll0_out_even = {
> +	.offset = 0x0,
> +	.post_div_shift = 10,
> +	.post_div_table = post_div_table_gpll0_out_even,
> +	.num_post_div = ARRAY_SIZE(post_div_table_gpll0_out_even),
> +	.width = 4,
> +	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_LUCID_OLE],
> +	.clkr.hw.init = &(const struct clk_init_data) {
> +		.name = "gpll0_out_even",
> +		.parent_hws = (const struct clk_hw*[]) {
> +			&gpll0.clkr.hw,
> +		},
> +		.num_parents = 1,
> +		.ops = &clk_alpha_pll_postdiv_lucid_ole_ops,
> +	},
> +};
> +
> +static struct clk_alpha_pll gpll4 = {
> +	.offset = 0x4000,
> +	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_LUCID_OLE],
> +	.clkr = {
> +		.enable_reg = 0x7d000,
> +		.enable_mask = BIT(4),
> +		.hw.init = &(const struct clk_init_data) {
> +			.name = "gpll4",
> +			.parent_data = &(const struct clk_parent_data) {
> +				.index = DT_BI_TCXO,
> +			},
> +			.num_parents = 1,
> +			.ops = &clk_alpha_pll_fixed_lucid_ole_ops,
> +		},
> +	},
> +};
> +
> +static struct clk_alpha_pll gpll5 = {
> +	.offset = 0x5000,
> +	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_LUCID_OLE],
> +	.clkr = {
> +		.enable_reg = 0x7d000,
> +		.enable_mask = BIT(5),
> +		.hw.init = &(const struct clk_init_data) {
> +			.name = "gpll5",
> +			.parent_data = &(const struct clk_parent_data) {
> +				.index = DT_BI_TCXO,
> +			},
> +			.num_parents = 1,
> +			.ops = &clk_alpha_pll_fixed_lucid_ole_ops,
> +		},
> +	},
> +};
> +
> +static struct clk_alpha_pll gpll6 = {
> +	.offset = 0x6000,
> +	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_LUCID_OLE],
> +	.clkr = {
> +		.enable_reg = 0x7d000,
> +		.enable_mask = BIT(6),
> +		.hw.init = &(const struct clk_init_data) {
> +			.name = "gpll6",
> +			.parent_data = &(const struct clk_parent_data) {
> +				.index = DT_BI_TCXO,
> +			},
> +			.num_parents = 1,
> +			.ops = &clk_alpha_pll_fixed_lucid_ole_ops,
> +		},
> +	},
> +};
> +
> +static struct clk_alpha_pll gpll8 = {
> +	.offset = 0x8000,
> +	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_LUCID_OLE],
> +	.clkr = {
> +		.enable_reg = 0x7d000,
> +		.enable_mask = BIT(8),
> +		.hw.init = &(const struct clk_init_data) {
> +			.name = "gpll8",
> +			.parent_data = &(const struct clk_parent_data) {
> +				.index = DT_BI_TCXO,
> +			},
> +			.num_parents = 1,
> +			.ops = &clk_alpha_pll_fixed_lucid_ole_ops,
> +		},
> +	},
> +};
> +
> +static const struct parent_map gcc_parent_map_0[] = {
> +	{ P_BI_TCXO, 0 },
> +	{ P_GPLL0_OUT_MAIN, 1 },
> +	{ P_GPLL0_OUT_EVEN, 6 },
> +};
> +
> +static const struct clk_parent_data gcc_parent_data_0[] = {
> +	{ .index = DT_BI_TCXO },
> +	{ .hw = &gpll0.clkr.hw },
> +	{ .hw = &gpll0_out_even.clkr.hw },
> +};
> +
> +static const struct parent_map gcc_parent_map_1[] = {
> +	{ P_BI_TCXO, 0 },
> +	{ P_GPLL0_OUT_MAIN, 1 },
> +	{ P_GPLL4_OUT_MAIN, 2 },
> +	{ P_GPLL5_OUT_MAIN, 5 },
> +	{ P_GPLL0_OUT_EVEN, 6 },
> +};
> +
> +static const struct clk_parent_data gcc_parent_data_1[] = {
> +	{ .index = DT_BI_TCXO },
> +	{ .hw = &gpll0.clkr.hw },
> +	{ .hw = &gpll4.clkr.hw },
> +	{ .hw = &gpll5.clkr.hw },
> +	{ .hw = &gpll0_out_even.clkr.hw },
> +};
> +
> +static const struct parent_map gcc_parent_map_2[] = {
> +	{ P_BI_TCXO, 0 },
> +	{ P_GPLL0_OUT_MAIN, 1 },
> +	{ P_SLEEP_CLK, 5 },
> +	{ P_GPLL0_OUT_EVEN, 6 },
> +};
> +
> +static const struct clk_parent_data gcc_parent_data_2[] = {
> +	{ .index = DT_BI_TCXO },
> +	{ .hw = &gpll0.clkr.hw },
> +	{ .index = DT_SLEEP_CLK },
> +	{ .hw = &gpll0_out_even.clkr.hw },
> +};
> +
> +static const struct parent_map gcc_parent_map_3[] = {
> +	{ P_BI_TCXO, 0 },
> +	{ P_SLEEP_CLK, 5 },
> +};
> +
> +static const struct clk_parent_data gcc_parent_data_3[] = {
> +	{ .index = DT_BI_TCXO },
> +	{ .index = DT_SLEEP_CLK },
> +};
> +
> +static const struct parent_map gcc_parent_map_4[] = {
> +	{ P_BI_TCXO, 0 },
> +	{ P_GPLL0_OUT_MAIN, 1 },
> +	{ P_SLEEP_CLK, 5 },
> +};
> +
> +static const struct clk_parent_data gcc_parent_data_4[] = {
> +	{ .index = DT_BI_TCXO },
> +	{ .hw = &gpll0.clkr.hw },
> +	{ .index = DT_SLEEP_CLK },
> +};
> +
> +static const struct parent_map gcc_parent_map_5[] = {
> +	{ P_EMAC0_SGMIIPHY_RCLK, 0 },
> +	{ P_BI_TCXO, 2 },
> +};
> +
> +static const struct clk_parent_data gcc_parent_data_5[] = {
> +	{ .fw_name = "emac0_sgmiiphy_rclk" },

So, this looks like a mixture of fw_name and index clocks. Please 
migrate all of fw_names to the .index usage.

> +	{ .index = DT_BI_TCXO },
> +};
> +
> +static const struct parent_map gcc_parent_map_6[] = {
> +	{ P_EMAC0_SGMIIPHY_TCLK, 0 },
> +	{ P_BI_TCXO, 2 },
> +};
> +
> +static const struct clk_parent_data gcc_parent_data_6[] = {
> +	{ .fw_name = "emac0_sgmiiphy_tclk" },
> +	{ .index = DT_BI_TCXO },
> +};
> +
> +static const struct parent_map gcc_parent_map_7[] = {
> +	{ P_EMAC0_SGMIIPHY_MAC_RCLK, 0 },
> +	{ P_BI_TCXO, 2 },
> +};
> +
> +static const struct clk_parent_data gcc_parent_data_7[] = {
> +	{ .fw_name = "emac0_sgmiiphy_mac_rclk" },
> +	{ .index = DT_BI_TCXO },
> +};
> +
> +static const struct parent_map gcc_parent_map_8[] = {
> +	{ P_EMAC0_SGMIIPHY_MAC_TCLK, 0 },
> +	{ P_BI_TCXO, 2 },
> +};
> +
> +static const struct clk_parent_data gcc_parent_data_8[] = {
> +	{ .fw_name = "emac0_sgmiiphy_mac_tclk" },
> +	{ .index = DT_BI_TCXO },
> +};
> +
> +static const struct parent_map gcc_parent_map_9[] = {
> +	{ P_EMAC1_SGMIIPHY_RCLK, 0 },
> +	{ P_BI_TCXO, 2 },
> +};
> +
> +static const struct clk_parent_data gcc_parent_data_9[] = {
> +	{ .fw_name = "emac1_sgmiiphy_rclk" },
> +	{ .index = DT_BI_TCXO },
> +};
> +
> +static const struct parent_map gcc_parent_map_10[] = {
> +	{ P_EMAC1_SGMIIPHY_TCLK, 0 },
> +	{ P_BI_TCXO, 2 },
> +};
> +
> +static const struct clk_parent_data gcc_parent_data_10[] = {
> +	{ .fw_name = "emac1_sgmiiphy_tclk" },
> +	{ .index = DT_BI_TCXO },
> +};
> +
> +static const struct parent_map gcc_parent_map_11[] = {
> +	{ P_EMAC1_SGMIIPHY_MAC_RCLK, 0 },
> +	{ P_BI_TCXO, 2 },
> +};
> +
> +static const struct clk_parent_data gcc_parent_data_11[] = {
> +	{ .fw_name = "emac1_sgmiiphy_mac_rclk" },
> +	{ .index = DT_BI_TCXO },
> +};
> +
> +static const struct parent_map gcc_parent_map_12[] = {
> +	{ P_EMAC1_SGMIIPHY_MAC_TCLK, 0 },
> +	{ P_BI_TCXO, 2 },
> +};
> +
> +static const struct clk_parent_data gcc_parent_data_12[] = {
> +	{ .fw_name = "emac1_sgmiiphy_mac_tclk" },
> +	{ .index = DT_BI_TCXO },
> +};
> +
> +static const struct parent_map gcc_parent_map_13[] = {
> +	{ P_PCIE_1_PIPE_CLK, 0 },
> +	{ P_BI_TCXO, 2 },
> +};
> +
> +static const struct clk_parent_data gcc_parent_data_13[] = {
> +	{ .fw_name = "pcie_1_pipe_clk" },
> +	{ .index = DT_BI_TCXO },
> +};
> +
> +static const struct parent_map gcc_parent_map_14[] = {
> +	{ P_PCIE_2_PIPE_CLK, 0 },
> +	{ P_BI_TCXO, 2 },
> +};
> +
> +static const struct clk_parent_data gcc_parent_data_14[] = {
> +	{ .fw_name = "pcie_2_pipe_clk" },
> +	{ .index = DT_BI_TCXO },
> +};
> +
> +static const struct parent_map gcc_parent_map_15[] = {
> +	{ P_PCIE20_PHY_AUX_CLK, 0 },
> +	{ P_BI_TCXO, 2 },
> +};
> +
> +static const struct clk_parent_data gcc_parent_data_15[] = {
> +	{ .fw_name = "pcie20_phy_aux_clk" },
> +	{ .index = DT_BI_TCXO },
> +};
> +
> +static const struct parent_map gcc_parent_map_16[] = {
> +	{ P_PCIE_PIPE_CLK, 0 },
> +	{ P_BI_TCXO, 2 },
> +};
> +
> +static const struct clk_parent_data gcc_parent_data_16[] = {
> +	{ .fw_name = "pcie_pipe_clk" },
> +	{ .index = DT_BI_TCXO },
> +};
> +
> +static const struct parent_map gcc_parent_map_17[] = {
> +	{ P_BI_TCXO, 0 },
> +	{ P_GPLL0_OUT_MAIN, 1 },
> +	{ P_GPLL6_OUT_MAIN, 2 },
> +	{ P_GPLL0_OUT_EVEN, 6 },
> +};
> +
> +static const struct clk_parent_data gcc_parent_data_17[] = {
> +	{ .index = DT_BI_TCXO },
> +	{ .hw = &gpll0.clkr.hw },
> +	{ .hw = &gpll6.clkr.hw },
> +	{ .hw = &gpll0_out_even.clkr.hw },
> +};
> +
> +static const struct parent_map gcc_parent_map_18[] = {
> +	{ P_BI_TCXO, 0 },
> +	{ P_GPLL0_OUT_MAIN, 1 },
> +	{ P_GPLL8_OUT_MAIN, 2 },
> +	{ P_GPLL0_OUT_EVEN, 6 },
> +};
> +
> +static const struct clk_parent_data gcc_parent_data_18[] = {
> +	{ .index = DT_BI_TCXO },
> +	{ .hw = &gpll0.clkr.hw },
> +	{ .hw = &gpll8.clkr.hw },
> +	{ .hw = &gpll0_out_even.clkr.hw },
> +};
> +
> +static const struct parent_map gcc_parent_map_19[] = {
> +	{ P_USB3_PHY_WRAPPER_GCC_USB30_PIPE_CLK, 0 },
> +	{ P_BI_TCXO, 2 },
> +};
> +
> +static const struct clk_parent_data gcc_parent_data_19[] = {
> +	{ .fw_name = "usb3_phy_wrapper_gcc_usb30_pipe_clk" },
> +	{ .index = DT_BI_TCXO },
> +};
> +
> +static struct clk_regmap_mux gcc_emac0_cc_sgmiiphy_rx_clk_src = {
> +	.reg = 0x71060,
> +	.shift = 0,
> +	.width = 2,
> +	.parent_map = gcc_parent_map_5,
> +	.clkr = {
> +		.hw.init = &(const struct clk_init_data) {
> +			.name = "gcc_emac0_cc_sgmiiphy_rx_clk_src",
> +			.parent_data = gcc_parent_data_5,
> +			.num_parents = ARRAY_SIZE(gcc_parent_data_5),
> +			.ops = &clk_regmap_mux_closest_ops,
> +		},
> +	},
> +};
> +
> +static struct clk_regmap_mux gcc_emac0_cc_sgmiiphy_tx_clk_src = {
> +	.reg = 0x71058,
> +	.shift = 0,
> +	.width = 2,
> +	.parent_map = gcc_parent_map_6,
> +	.clkr = {
> +		.hw.init = &(const struct clk_init_data) {
> +			.name = "gcc_emac0_cc_sgmiiphy_tx_clk_src",
> +			.parent_data = gcc_parent_data_6,
> +			.num_parents = ARRAY_SIZE(gcc_parent_data_6),
> +			.ops = &clk_regmap_mux_closest_ops,
> +		},
> +	},
> +};
> +
> +static struct clk_regmap_mux gcc_emac0_sgmiiphy_mac_rclk_src = {
> +	.reg = 0x71098,
> +	.shift = 0,
> +	.width = 2,
> +	.parent_map = gcc_parent_map_7,
> +	.clkr = {
> +		.hw.init = &(const struct clk_init_data) {
> +			.name = "gcc_emac0_sgmiiphy_mac_rclk_src",
> +			.parent_data = gcc_parent_data_7,
> +			.num_parents = ARRAY_SIZE(gcc_parent_data_7),
> +			.ops = &clk_regmap_mux_closest_ops,
> +		},
> +	},
> +};
> +
> +static struct clk_regmap_mux gcc_emac0_sgmiiphy_mac_tclk_src = {
> +	.reg = 0x71094,
> +	.shift = 0,
> +	.width = 2,
> +	.parent_map = gcc_parent_map_8,
> +	.clkr = {
> +		.hw.init = &(const struct clk_init_data) {
> +			.name = "gcc_emac0_sgmiiphy_mac_tclk_src",
> +			.parent_data = gcc_parent_data_8,
> +			.num_parents = ARRAY_SIZE(gcc_parent_data_8),
> +			.ops = &clk_regmap_mux_closest_ops,
> +		},
> +	},
> +};
> +
> +static struct clk_regmap_mux gcc_emac1_cc_sgmiiphy_rx_clk_src = {
> +	.reg = 0x72060,
> +	.shift = 0,
> +	.width = 2,
> +	.parent_map = gcc_parent_map_9,
> +	.clkr = {
> +		.hw.init = &(const struct clk_init_data) {
> +			.name = "gcc_emac1_cc_sgmiiphy_rx_clk_src",
> +			.parent_data = gcc_parent_data_9,
> +			.num_parents = ARRAY_SIZE(gcc_parent_data_9),
> +			.ops = &clk_regmap_mux_closest_ops,
> +		},
> +	},
> +};
> +
> +static struct clk_regmap_mux gcc_emac1_cc_sgmiiphy_tx_clk_src = {
> +	.reg = 0x72058,
> +	.shift = 0,
> +	.width = 2,
> +	.parent_map = gcc_parent_map_10,
> +	.clkr = {
> +		.hw.init = &(const struct clk_init_data) {
> +			.name = "gcc_emac1_cc_sgmiiphy_tx_clk_src",
> +			.parent_data = gcc_parent_data_10,
> +			.num_parents = ARRAY_SIZE(gcc_parent_data_10),
> +			.ops = &clk_regmap_mux_closest_ops,
> +		},
> +	},
> +};
> +
> +static struct clk_regmap_mux gcc_emac1_sgmiiphy_mac_rclk_src = {
> +	.reg = 0x72098,
> +	.shift = 0,
> +	.width = 2,
> +	.parent_map = gcc_parent_map_11,
> +	.clkr = {
> +		.hw.init = &(const struct clk_init_data) {
> +			.name = "gcc_emac1_sgmiiphy_mac_rclk_src",
> +			.parent_data = gcc_parent_data_11,
> +			.num_parents = ARRAY_SIZE(gcc_parent_data_11),
> +			.ops = &clk_regmap_mux_closest_ops,
> +		},
> +	},
> +};
> +
> +static struct clk_regmap_mux gcc_emac1_sgmiiphy_mac_tclk_src = {
> +	.reg = 0x72094,
> +	.shift = 0,
> +	.width = 2,
> +	.parent_map = gcc_parent_map_12,
> +	.clkr = {
> +		.hw.init = &(const struct clk_init_data) {
> +			.name = "gcc_emac1_sgmiiphy_mac_tclk_src",
> +			.parent_data = gcc_parent_data_12,
> +			.num_parents = ARRAY_SIZE(gcc_parent_data_12),
> +			.ops = &clk_regmap_mux_closest_ops,
> +		},
> +	},
> +};
> +
> +static struct clk_regmap_mux gcc_pcie_1_pipe_clk_src = {
> +	.reg = 0x67084,
> +	.shift = 0,
> +	.width = 2,
> +	.parent_map = gcc_parent_map_13,
> +	.clkr = {
> +		.hw.init = &(const struct clk_init_data) {
> +			.name = "gcc_pcie_1_pipe_clk_src",
> +			.parent_data = gcc_parent_data_13,
> +			.num_parents = ARRAY_SIZE(gcc_parent_data_13),
> +			.ops = &clk_regmap_mux_closest_ops,

Are these clocks a clk_regmap_mux_closest_ops in reality 
clk_regmap_phy_mux_ops?

> +		},
> +	},
> +};
> +
> +static struct clk_regmap_mux gcc_pcie_2_pipe_clk_src = {
> +	.reg = 0x68050,
> +	.shift = 0,
> +	.width = 2,
> +	.parent_map = gcc_parent_map_14,
> +	.clkr = {
> +		.hw.init = &(const struct clk_init_data) {
> +			.name = "gcc_pcie_2_pipe_clk_src",
> +			.parent_data = gcc_parent_data_14,
> +			.num_parents = ARRAY_SIZE(gcc_parent_data_14),
> +			.ops = &clk_regmap_mux_closest_ops,
> +		},
> +	},
> +};
> +
> +static struct clk_regmap_mux gcc_pcie_aux_clk_src = {
> +	.reg = 0x53074,
> +	.shift = 0,
> +	.width = 2,
> +	.parent_map = gcc_parent_map_15,
> +	.clkr = {
> +		.hw.init = &(const struct clk_init_data) {
> +			.name = "gcc_pcie_aux_clk_src",
> +			.parent_data = gcc_parent_data_15,
> +			.num_parents = ARRAY_SIZE(gcc_parent_data_15),
> +			.ops = &clk_regmap_mux_closest_ops,
> +		},
> +	},
> +};
> +
> +static struct clk_regmap_mux gcc_pcie_pipe_clk_src = {
> +	.reg = 0x53058,
> +	.shift = 0,
> +	.width = 2,
> +	.parent_map = gcc_parent_map_16,
> +	.clkr = {
> +		.hw.init = &(const struct clk_init_data) {
> +			.name = "gcc_pcie_pipe_clk_src",
> +			.parent_data = gcc_parent_data_16,
> +			.num_parents = ARRAY_SIZE(gcc_parent_data_16),
> +			.ops = &clk_regmap_mux_closest_ops,
> +		},
> +	},
> +};
> +
> +static struct clk_regmap_mux gcc_usb3_phy_pipe_clk_src = {
> +	.reg = 0x27070,
> +	.shift = 0,
> +	.width = 2,
> +	.parent_map = gcc_parent_map_19,
> +	.clkr = {
> +		.hw.init = &(const struct clk_init_data) {
> +			.name = "gcc_usb3_phy_pipe_clk_src",
> +			.parent_data = gcc_parent_data_19,
> +			.num_parents = ARRAY_SIZE(gcc_parent_data_19),
> +			.ops = &clk_regmap_mux_closest_ops,
> +		},
> +	},
> +};
> +

skipped the rest, looks good to me.

-- 
With best wishes
Dmitry

