Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 312BD68007B
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 18:36:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235168AbjA2Rg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 12:36:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232422AbjA2RgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 12:36:25 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A19D12D46
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 09:36:21 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id k8-20020a05600c1c8800b003dc57ea0dfeso604536wms.0
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 09:36:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2t9d/PFnAu76NCSByxhC2pLUkL7IDdlqzwyWR/4/cZQ=;
        b=g1gILyyE7aWCdvMCWprqIT5pQBIvK0jy2wQr5CYWIIjZeLtzNE0kV6684JWfL9Slsx
         FGt9cHMIhq20pn9/1jlcm5/1LX8aS0XkaccDA6YUQKfT2fAzX4muC+qYIS1UlkSYYAHk
         IDZuPepb2vg5C5YBCneEAYDWcIwX9ocIemc0Qr5o55Ow6Ga3MXeCaCJM1BREvRmYW/GJ
         wRkZsbOYyOlecusDW+8qXpOn7wV7UbYxOHdmW19323SMC0ox6mcPvkbbxNMYE3r4wL1c
         UZ8Hn3KRRC2VOa1k2KqOS2OjeHrJxnkqiuNKaRODZdgzhVKWKP/dQrujWTndkCeeTXyd
         w0cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2t9d/PFnAu76NCSByxhC2pLUkL7IDdlqzwyWR/4/cZQ=;
        b=qHZ2ghUIMs+6xNT51ciLo460zcJupC9NOJYsPkzLHmY1g9WA68bhVzgcRcO/DFDTa7
         rczAXlZdPdBMDUElu11TDm7e2yPVVXgXnwQpYZ+ypFjAyVfOtEEBQ8cvzvuLlP3pgUk5
         Seef8jIBPT/FrLBS1QOGEGb+03ntJsKVde3kgoGjrTJ8cW3j30V8W5nCJt7adIp1yiDe
         J7G+UnC0EIq5YMCSAhoH4dNkg0rGbj2cW0egcE3CZn703hPVMiC+SoDHNcb/Q14AKwVc
         4zb1ea984fiuIiggIdN7TeqP7nOQ/OhrdH98Zi9muUV1HK42n9FeL5RVIlrgzFiMdRRe
         35qw==
X-Gm-Message-State: AO0yUKWt5He9hNO5+xP+5WTbUHOyInnj6hra6laZtt0fgMh90OXwkKkd
        PsYpN4LRp/DvBMwxnRoRCwSVRAF5gd4DKNxW
X-Google-Smtp-Source: AK7set84I634bCcA5f5yHm3I7Mt3i3QNcDw7JuyBVOnZFuCMIXSqjwmdLt+8dHw3QMmkBxl7nsHG3w==
X-Received: by 2002:a05:600c:354b:b0:3dc:16d2:ae5e with SMTP id i11-20020a05600c354b00b003dc16d2ae5emr19968193wmq.32.1675013780186;
        Sun, 29 Jan 2023 09:36:20 -0800 (PST)
Received: from linaro.org ([94.52.112.99])
        by smtp.gmail.com with ESMTPSA id i27-20020a05600c4b1b00b003dc54d9aeeasm2036307wmp.36.2023.01.29.09.36.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Jan 2023 09:36:19 -0800 (PST)
Date:   Sun, 29 Jan 2023 19:36:18 +0200
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
Subject: Re: [PATCH v2 01/19] clk: imx: add clk-gpr-mux driver
Message-ID: <Y9aukmQwiwzpakYo@linaro.org>
References: <20230117061453.3723649-1-o.rempel@pengutronix.de>
 <20230117061453.3723649-2-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230117061453.3723649-2-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23-01-17 07:14:35, Oleksij Rempel wrote:
> Almost(?) every i'MX variant has clk mux for ethernet (rgmii/rmii) reference

i.MX

> clock located in the GPR1 register. So far this clk is configured in
> different ways:
> - mach-imx6q is doing mux configuration based on ptp vs enet_ref clk
>   comparison.
> - mach-imx7d is setting mux to PAD for all boards
> - mach-imx6ul is setting mux to internal clock for all boards.
> 
> Since we have imx7d and imx6ul board variants which do not work with
> configurations forced by kernel mach code, we need to implement this clk
> mux properly as part of the clk framework. Which is done by this patch.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Abel Vesa <abel.vesa@linaro.org>

> ---
>  drivers/clk/imx/Makefile      |   1 +
>  drivers/clk/imx/clk-gpr-mux.c | 119 ++++++++++++++++++++++++++++++++++
>  drivers/clk/imx/clk.h         |   5 ++
>  3 files changed, 125 insertions(+)
>  create mode 100644 drivers/clk/imx/clk-gpr-mux.c
> 
> diff --git a/drivers/clk/imx/Makefile b/drivers/clk/imx/Makefile
> index e8aacb0ee6ac..a75d59f7cb8a 100644
> --- a/drivers/clk/imx/Makefile
> +++ b/drivers/clk/imx/Makefile
> @@ -22,6 +22,7 @@ mxc-clk-objs += clk-pllv3.o
>  mxc-clk-objs += clk-pllv4.o
>  mxc-clk-objs += clk-pll14xx.o
>  mxc-clk-objs += clk-sscg-pll.o
> +mxc-clk-objs += clk-gpr-mux.o
>  obj-$(CONFIG_MXC_CLK) += mxc-clk.o
>  
>  obj-$(CONFIG_CLK_IMX8MM) += clk-imx8mm.o
> diff --git a/drivers/clk/imx/clk-gpr-mux.c b/drivers/clk/imx/clk-gpr-mux.c
> new file mode 100644
> index 000000000000..47a3e3cdcc82
> --- /dev/null
> +++ b/drivers/clk/imx/clk-gpr-mux.c
> @@ -0,0 +1,119 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + */
> +
> +#define pr_fmt(fmt) "imx:clk-gpr-mux: " fmt
> +
> +#include <linux/module.h>
> +
> +#include <linux/clk-provider.h>
> +#include <linux/errno.h>
> +#include <linux/export.h>
> +#include <linux/io.h>
> +#include <linux/slab.h>
> +#include <linux/regmap.h>
> +#include <linux/mfd/syscon.h>
> +
> +#include "clk.h"
> +
> +struct imx_clk_gpr {
> +	struct clk_hw hw;
> +	struct regmap *regmap;
> +	u32 mask;
> +	u32 reg;
> +	const u32 *mux_table;
> +};
> +
> +static struct imx_clk_gpr *to_imx_clk_gpr(struct clk_hw *hw)
> +{
> +	return container_of(hw, struct imx_clk_gpr, hw);
> +}
> +
> +static u8 imx_clk_gpr_mux_get_parent(struct clk_hw *hw)
> +{
> +	struct imx_clk_gpr *priv = to_imx_clk_gpr(hw);
> +	unsigned int val;
> +	int ret;
> +
> +	ret = regmap_read(priv->regmap, priv->reg, &val);
> +	if (ret)
> +		goto get_parent_err;
> +
> +	val &= priv->mask;
> +
> +	ret = clk_mux_val_to_index(hw, priv->mux_table, 0, val);
> +	if (ret < 0)
> +		goto get_parent_err;
> +
> +	return ret;
> +
> +get_parent_err:
> +	pr_err("failed to get parent (%pe)\n", ERR_PTR(ret));
> +
> +	/* return some realistic non negative value. Potentially we could
> +	 * give index to some dummy error parent.
> +	 */
> +	return 0;
> +}
> +
> +static int imx_clk_gpr_mux_set_parent(struct clk_hw *hw, u8 index)
> +{
> +	struct imx_clk_gpr *priv = to_imx_clk_gpr(hw);
> +	unsigned int val = clk_mux_index_to_val(priv->mux_table, 0, index);
> +
> +	return regmap_update_bits(priv->regmap, priv->reg, priv->mask, val);
> +}
> +
> +static int imx_clk_gpr_mux_determine_rate(struct clk_hw *hw,
> +					 struct clk_rate_request *req)
> +{
> +	return clk_mux_determine_rate_flags(hw, req, 0);
> +}
> +
> +const struct clk_ops imx_clk_gpr_mux_ops = {
> +	.get_parent = imx_clk_gpr_mux_get_parent,
> +	.set_parent = imx_clk_gpr_mux_set_parent,
> +	.determine_rate = imx_clk_gpr_mux_determine_rate,
> +};
> +
> +struct clk_hw *imx_clk_gpr_mux(const char *name, const char *compatible,
> +			       u32 reg, const char **parent_names,
> +			       u8 num_parents, const u32 *mux_table, u32 mask)
> +{
> +	struct clk_init_data init  = { };
> +	struct imx_clk_gpr *priv;
> +	struct regmap *regmap;
> +	struct clk_hw *hw;
> +	int ret;
> +
> +	regmap = syscon_regmap_lookup_by_compatible(compatible);
> +	if (IS_ERR(regmap)) {
> +		pr_err("failed to find %s regmap\n", compatible);
> +		return ERR_CAST(regmap);
> +	}
> +
> +	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return ERR_PTR(-ENOMEM);
> +
> +	init.name = name;
> +	init.ops = &imx_clk_gpr_mux_ops;
> +	init.parent_names = parent_names;
> +	init.num_parents = num_parents;
> +	init.flags = CLK_SET_RATE_GATE | CLK_SET_PARENT_GATE;
> +
> +	priv->hw.init = &init;
> +	priv->regmap = regmap;
> +	priv->mux_table = mux_table;
> +	priv->reg = reg;
> +	priv->mask = mask;
> +
> +	hw = &priv->hw;
> +	ret = clk_hw_register(NULL, &priv->hw);
> +	if (ret) {
> +		kfree(priv);
> +		hw = ERR_PTR(ret);
> +	}
> +
> +	return hw;
> +}
> diff --git a/drivers/clk/imx/clk.h b/drivers/clk/imx/clk.h
> index 689b3ad927c0..801213109697 100644
> --- a/drivers/clk/imx/clk.h
> +++ b/drivers/clk/imx/clk.h
> @@ -458,4 +458,9 @@ struct clk_hw *imx_clk_hw_divider_gate(const char *name, const char *parent_name
>  		unsigned long flags, void __iomem *reg, u8 shift, u8 width,
>  		u8 clk_divider_flags, const struct clk_div_table *table,
>  		spinlock_t *lock);
> +
> +struct clk_hw *imx_clk_gpr_mux(const char *name, const char *compatible,
> +			       u32 reg, const char **parent_names,
> +			       u8 num_parents, const u32 *mux_table, u32 mask);
> +
>  #endif
> -- 
> 2.30.2
> 
