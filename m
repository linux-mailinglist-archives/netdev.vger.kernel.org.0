Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86FC0680076
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 18:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235162AbjA2Rek (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 12:34:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235107AbjA2Rej (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 12:34:39 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FB9F1E2BF
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 09:34:37 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id m14so8646646wrg.13
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 09:34:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5LhB+v37p+76x1E2O4Pvsff4S6wO2BA5elPpc0Squig=;
        b=BwJw9IqWegGmspNRnIEFiRkjyDbVKhKZr3x1pF0UtFZAvY9bV1tjRnTwaco1KESWnw
         wX5+qDQXPlq+8udFSMHVqmIPvr6v8k2sarIpSMXY4/qfw88hJ90g5/1iMY7Lv/t+PW3T
         z5ndUGgQHTXglZmhVtZ8F4rR4xzXQcEeYuny8xX4dFH0azcYd9aU+lfDBkE1ndTfNnY+
         k1sxQD5FfpKqZXvuvA/A+IFHR86XzYXCsP/MDRpjnArzXUtl/4lInbAEmGWMAKUkPSjC
         3gRiIL3l9eQk0y6uxGVCC1nzGT3F1uyUhleLVdvc9Gj8bueM3t//OllU8gvarEo4YEpt
         4bJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5LhB+v37p+76x1E2O4Pvsff4S6wO2BA5elPpc0Squig=;
        b=4ar5G8nBTfGUBWuoYLu8RYaEEbwuDlM94X1zcpCouSklATIYkccbeS9ztTGbeG7NoC
         gcwklS0FQNNBZVdeg9HLIKbFynd9to8EpUadSyUsShGyFFxTsqSkJ4RGXP2CSQQmf8uu
         E9ihW2boJzV9lBQeL+Q/W9RldZlDVPxMAEKQmR5x/NmF88SGLthFrwuJDEsbHiCYMCF9
         /f3veAqoVwHjD4B+ai+NwVwCSmUs4hU98lE3VIi0ph5EzK8sBk4rcfTyWh4cBd7UDq+0
         zjocIT9F4v8Af/ZgkPTbhHfDBGUECLijE85R3ec2mldyToj8GVMjEcYLVvrdEOuLi/vT
         JOuA==
X-Gm-Message-State: AO0yUKW0VqGU/lVK5HwvLf3w/RmCzqODtezmlHeaceao7NHD3KiAINIb
        o+PKvEYVZKfwwpFr0KdFEtWqKw==
X-Google-Smtp-Source: AK7set/ZqihGuUM8OBQtuR4yZAH6ZIXEV2MFHJy4fHsVKq1uTCbc0+HmZ8iyEmGyP3IWZMI7ncYHJQ==
X-Received: by 2002:a05:6000:a17:b0:2bf:e766:90f4 with SMTP id co23-20020a0560000a1700b002bfe76690f4mr3119965wrb.68.1675013675608;
        Sun, 29 Jan 2023 09:34:35 -0800 (PST)
Received: from linaro.org ([94.52.112.99])
        by smtp.gmail.com with ESMTPSA id d3-20020adfe2c3000000b002bc7fcf08ddsm9389546wrj.103.2023.01.29.09.34.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Jan 2023 09:34:35 -0800 (PST)
Date:   Sun, 29 Jan 2023 19:34:33 +0200
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
        kernel@pengutronix.de, Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Russell King <linux@armlinux.org.uk>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-clk@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 02/19] clk: imx6q: add ethernet refclock mux support
Message-ID: <Y9auKU6xS4eiEuVy@linaro.org>
References: <20230117061453.3723649-1-o.rempel@pengutronix.de>
 <20230117061453.3723649-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230117061453.3723649-3-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23-01-17 07:14:36, Oleksij Rempel wrote:
> Add ethernet refclock mux support and set it to internal clock by
> default. This configuration will not affect existing boards since
> machine code currently overwrites this default.
> 
> The machine code will be fixed in a separate patch.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Abel Vesa <abel.vesa@linaro.org>

> ---
>  drivers/clk/imx/clk-imx6q.c               | 13 +++++++++++++
>  include/dt-bindings/clock/imx6qdl-clock.h |  4 +++-
>  2 files changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/clk/imx/clk-imx6q.c b/drivers/clk/imx/clk-imx6q.c
> index de36f58d551c..22b464ca22c8 100644
> --- a/drivers/clk/imx/clk-imx6q.c
> +++ b/drivers/clk/imx/clk-imx6q.c
> @@ -12,6 +12,7 @@
>  #include <linux/clk-provider.h>
>  #include <linux/err.h>
>  #include <linux/io.h>
> +#include <linux/mfd/syscon/imx6q-iomuxc-gpr.h>
>  #include <linux/of.h>
>  #include <linux/of_address.h>
>  #include <linux/of_irq.h>
> @@ -115,6 +116,10 @@ static struct clk_div_table video_div_table[] = {
>  	{ /* sentinel */ }
>  };
>  
> +static const char * enet_ref_sels[] = { "enet_ref", "enet_ref_pad", };
> +static const u32 enet_ref_sels_table[] = { IMX6Q_GPR1_ENET_CLK_SEL_ANATOP, IMX6Q_GPR1_ENET_CLK_SEL_PAD };
> +static const u32 enet_ref_sels_table_mask = IMX6Q_GPR1_ENET_CLK_SEL_ANATOP;
> +
>  static unsigned int share_count_esai;
>  static unsigned int share_count_asrc;
>  static unsigned int share_count_ssi1;
> @@ -908,6 +913,12 @@ static void __init imx6q_clocks_init(struct device_node *ccm_node)
>  	if (clk_on_imx6q() && imx_get_soc_revision() == IMX_CHIP_REVISION_1_0)
>  		hws[IMX6QDL_CLK_GPT_3M] = hws[IMX6QDL_CLK_GPT_IPG_PER];
>  
> +	hws[IMX6QDL_CLK_ENET_REF_PAD] = imx6q_obtain_fixed_clk_hw(ccm_node, "enet_ref_pad", 0);
> +
> +	hws[IMX6QDL_CLK_ENET_REF_SEL] = imx_clk_gpr_mux("enet_ref_sel", "fsl,imx6q-iomuxc-gpr",
> +				IOMUXC_GPR1, enet_ref_sels, ARRAY_SIZE(enet_ref_sels),
> +				enet_ref_sels_table, enet_ref_sels_table_mask);
> +
>  	imx_check_clk_hws(hws, IMX6QDL_CLK_END);
>  
>  	of_clk_add_hw_provider(np, of_clk_hw_onecell_get, clk_hw_data);
> @@ -974,6 +985,8 @@ static void __init imx6q_clocks_init(struct device_node *ccm_node)
>  			       hws[IMX6QDL_CLK_PLL3_USB_OTG]->clk);
>  	}
>  
> +	clk_set_parent(hws[IMX6QDL_CLK_ENET_REF_SEL]->clk, hws[IMX6QDL_CLK_ENET_REF]->clk);
> +
>  	imx_register_uart_clocks(2);
>  }
>  CLK_OF_DECLARE(imx6q, "fsl,imx6q-ccm", imx6q_clocks_init);
> diff --git a/include/dt-bindings/clock/imx6qdl-clock.h b/include/dt-bindings/clock/imx6qdl-clock.h
> index e20c43cc36f6..e5b2a1ba02bc 100644
> --- a/include/dt-bindings/clock/imx6qdl-clock.h
> +++ b/include/dt-bindings/clock/imx6qdl-clock.h
> @@ -273,6 +273,8 @@
>  #define IMX6QDL_CLK_MMDC_P0_IPG			263
>  #define IMX6QDL_CLK_DCIC1			264
>  #define IMX6QDL_CLK_DCIC2			265
> -#define IMX6QDL_CLK_END				266
> +#define IMX6QDL_CLK_ENET_REF_SEL		266
> +#define IMX6QDL_CLK_ENET_REF_PAD		267
> +#define IMX6QDL_CLK_END				268
>  
>  #endif /* __DT_BINDINGS_CLOCK_IMX6QDL_H */
> -- 
> 2.30.2
> 
