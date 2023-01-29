Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8533368006E
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 18:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235137AbjA2Rch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 12:32:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbjA2Rcg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 12:32:36 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B47451715A
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 09:32:34 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id l41-20020a05600c1d2900b003daf986faaeso6697623wms.3
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 09:32:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=svBQPr2zX0vFiU+LA7iax7V/PhrzFNFTfrWbUoO2TSw=;
        b=cR3YvBTaYwhGqCyjjGubNcmvmbO4XoRSValanLITu7buhqQUE07Yy8qvWafi+u1Elq
         GuuvHyw/coGkwtUHZQOSxuot2090eSRZfC85Vuu0UHxH6EiQSo0m1Pw3TlZP5CLMI/25
         +s42ZyK1f77GeMLJ9Jg7j2mOWym5CZ0mB0qvK0GEg9wUeFdYuY8CqRgF5+8nOIdQAKBN
         LeQRliY446QZ2SbJOdK478vJf4Q4PLi6czHSLLO8Ojo9D6QyFNfYJzGIbyPWq1ZkniD4
         3BuHH4hL9nQpJLw9R7MGQ320PAbI//jS2PsOcF7alUNrHSNygzcY+DoojF8eTTQW70dh
         dp+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=svBQPr2zX0vFiU+LA7iax7V/PhrzFNFTfrWbUoO2TSw=;
        b=dsWu55jzWGhyALmZRQ2zbSAXLVwudFH5BYWanPEj77hnlpQpwKPRT1LPiUVQuxEJuL
         ArfqAp6s7YX1zlqrQqxCKR5OFLs9097kCAyzyy8MRuGrqmHAsiAvFXtYAF1bW0D86oC1
         0AAMpWuAFkX/nMYFCz08a2LSu1liElgGREvltuEpwDo8Fr7bHKS9Q/r0RjfQAdLaFRPR
         BaiquEnYGaJyj2oy5ECMFIotIGjwzX/osVzSguRPtpmP4as33rr7ii0iInhpbDxkB65Y
         ZYjRjN1SrXj+hN+nVzjBpkYzcPRNoFgtG0huy+roLdKTqDizqVxOCJ0bXgL/q8ShltOM
         k34w==
X-Gm-Message-State: AFqh2kqc3WMZLjJClyCgVRlkS3KokE4Wvgv/yiUNFACopUwWnC8iKD35
        tafYQBvgfcKgmup5yofkmCJNbw==
X-Google-Smtp-Source: AMrXdXuCRWw0PhIRZDURJ2EcI4hCQ+5zmHLbibzPPtLZT+byUsUimkjL5sq3fKVpF0v/9rHAi9vGQA==
X-Received: by 2002:a05:600c:c85:b0:3db:1a41:6629 with SMTP id fj5-20020a05600c0c8500b003db1a416629mr40964122wmb.22.1675013553228;
        Sun, 29 Jan 2023 09:32:33 -0800 (PST)
Received: from linaro.org ([94.52.112.99])
        by smtp.gmail.com with ESMTPSA id u11-20020a05600c19cb00b003d9fb04f658sm15110616wmq.4.2023.01.29.09.32.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Jan 2023 09:32:32 -0800 (PST)
Date:   Sun, 29 Jan 2023 19:32:31 +0200
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
Subject: Re: [PATCH v2 15/19] clk: imx6ul: fix enet1 gate configuration
Message-ID: <Y9atr+Gn60+m4nOg@linaro.org>
References: <20230117061453.3723649-1-o.rempel@pengutronix.de>
 <20230117061453.3723649-16-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230117061453.3723649-16-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23-01-17 07:14:49, Oleksij Rempel wrote:
> According to the "i.MX 6UltraLite Applications Processor Reference Manual,
> Rev. 2, 03/2017", BIT(13) is ENET1_125M_EN which is not controlling root
> of PLL6. It is controlling ENET1 separately.
> 
> So, instead of this picture (implementation before this patch):
> fec1 <- enet_ref (divider) <---------------------------,
>                                                        |- pll6_enet (gate)
> fec2 <- enet2_ref_125m (gate) <- enet2_ref (divider) <-´
> 
> we should have this one (after this patch):
> fec1 <- enet1_ref_125m (gate) <- enet1_ref (divider) <-,
>                                                        |- pll6_enet
> fec2 <- enet2_ref_125m (gate) <- enet2_ref (divider) <-´
> 
> With this fix, the RMII reference clock will be turned off, after
> setting network interface down on each separate interface
> (ip l s dev eth0 down). Which was not working before, on system with both
> FECs enabled.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

I'm OK with this. Maybe a fixes tag ?

Reviewed-by: Abel Vesa <abel.vesa@linaro.org>

> ---
>  drivers/clk/imx/clk-imx6ul.c             | 7 ++++---
>  include/dt-bindings/clock/imx6ul-clock.h | 3 ++-
>  2 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/clk/imx/clk-imx6ul.c b/drivers/clk/imx/clk-imx6ul.c
> index 67a7a77ca540..c3c465c1b0e7 100644
> --- a/drivers/clk/imx/clk-imx6ul.c
> +++ b/drivers/clk/imx/clk-imx6ul.c
> @@ -176,7 +176,7 @@ static void __init imx6ul_clocks_init(struct device_node *ccm_node)
>  	hws[IMX6UL_CLK_PLL3_USB_OTG]	= imx_clk_hw_gate("pll3_usb_otg",	"pll3_bypass", base + 0x10, 13);
>  	hws[IMX6UL_CLK_PLL4_AUDIO]	= imx_clk_hw_gate("pll4_audio",	"pll4_bypass", base + 0x70, 13);
>  	hws[IMX6UL_CLK_PLL5_VIDEO]	= imx_clk_hw_gate("pll5_video",	"pll5_bypass", base + 0xa0, 13);
> -	hws[IMX6UL_CLK_PLL6_ENET]	= imx_clk_hw_gate("pll6_enet",	"pll6_bypass", base + 0xe0, 13);
> +	hws[IMX6UL_CLK_PLL6_ENET]	= imx_clk_hw_fixed_factor("pll6_enet",	"pll6_bypass", 1, 1);
>  	hws[IMX6UL_CLK_PLL7_USB_HOST]	= imx_clk_hw_gate("pll7_usb_host",	"pll7_bypass", base + 0x20, 13);
>  
>  	/*
> @@ -205,12 +205,13 @@ static void __init imx6ul_clocks_init(struct device_node *ccm_node)
>  	hws[IMX6UL_CLK_PLL3_PFD2] = imx_clk_hw_pfd("pll3_pfd2_508m", "pll3_usb_otg", base + 0xf0,	 2);
>  	hws[IMX6UL_CLK_PLL3_PFD3] = imx_clk_hw_pfd("pll3_pfd3_454m", "pll3_usb_otg", base + 0xf0,	 3);
>  
> -	hws[IMX6UL_CLK_ENET_REF] = clk_hw_register_divider_table(NULL, "enet_ref", "pll6_enet", 0,
> +	hws[IMX6UL_CLK_ENET_REF] = clk_hw_register_divider_table(NULL, "enet1_ref", "pll6_enet", 0,
>  			base + 0xe0, 0, 2, 0, clk_enet_ref_table, &imx_ccm_lock);
>  	hws[IMX6UL_CLK_ENET2_REF] = clk_hw_register_divider_table(NULL, "enet2_ref", "pll6_enet", 0,
>  			base + 0xe0, 2, 2, 0, clk_enet_ref_table, &imx_ccm_lock);
>  
> -	hws[IMX6UL_CLK_ENET2_REF_125M] = imx_clk_hw_gate("enet_ref_125m", "enet2_ref", base + 0xe0, 20);
> +	hws[IMX6UL_CLK_ENET1_REF_125M] = imx_clk_hw_gate("enet1_ref_125m", "enet1_ref", base + 0xe0, 13);
> +	hws[IMX6UL_CLK_ENET2_REF_125M] = imx_clk_hw_gate("enet2_ref_125m", "enet2_ref", base + 0xe0, 20);
>  	hws[IMX6UL_CLK_ENET_PTP_REF]	= imx_clk_hw_fixed_factor("enet_ptp_ref", "pll6_enet", 1, 20);
>  	hws[IMX6UL_CLK_ENET_PTP]	= imx_clk_hw_gate("enet_ptp", "enet_ptp_ref", base + 0xe0, 21);
>  
> diff --git a/include/dt-bindings/clock/imx6ul-clock.h b/include/dt-bindings/clock/imx6ul-clock.h
> index 79094338e6f1..b44920f1edb0 100644
> --- a/include/dt-bindings/clock/imx6ul-clock.h
> +++ b/include/dt-bindings/clock/imx6ul-clock.h
> @@ -256,7 +256,8 @@
>  #define IMX6UL_CLK_GPIO4		247
>  #define IMX6UL_CLK_GPIO5		248
>  #define IMX6UL_CLK_MMDC_P1_IPG		249
> +#define IMX6UL_CLK_ENET1_REF_125M	250
>  
> -#define IMX6UL_CLK_END			250
> +#define IMX6UL_CLK_END			251
>  
>  #endif /* __DT_BINDINGS_CLOCK_IMX6UL_H */
> -- 
> 2.30.2
> 
