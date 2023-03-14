Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67F416B8E31
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 10:11:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbjCNJKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 05:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbjCNJKr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 05:10:47 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47290900AA;
        Tue, 14 Mar 2023 02:10:45 -0700 (PDT)
Received: from [192.168.1.100] (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: kholk11)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id E27C46603009;
        Tue, 14 Mar 2023 09:10:42 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1678785043;
        bh=AzTZ2BxRqFcOVG5EJd3ZGhH//IxUcNMPjjCqWCgf6WE=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=i/P5Hv4fP2IZJuSCLEuiBPqWAz50uyoogFx4cq82uKIecGouuM3YtN5wDFsJfQOEH
         SN4ut40lCy1r5JPWnhOoDcTahEcqOuXocLX4hLeIfwn/MZXmqV0S+oBLPnw5iRbSCP
         ViY4HkuoWcpPN0zUkch5ZjfoSNDkNrPosJVtGHOdbxqLtOM1lXBJ8Qqyc4sblnRcd/
         Ha0CrFITv1p0WLj09uTOS9W7Q0/ptNx2kSnmq570b6dvAjzOyeoqmRQCfJVaAZiiDA
         SJOR10ZnNi6fKqwpj1hpLok8CPyT/m3p9dUs4Kc4eFxFh4SqwXE7NbDpx5zhtmG9qS
         WzCTNwwiXULlA==
Message-ID: <bf221312-ce85-8696-8b5a-f5b78206bd07@collabora.com>
Date:   Tue, 14 Mar 2023 10:10:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v6 03/19] clk: mediatek: Add MT8188 topckgen clock support
Content-Language: en-US
To:     "Garmin.Chang" <Garmin.Chang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     Project_Global_Chrome_Upstream_Group@mediatek.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-clk@vger.kernel.org, netdev@vger.kernel.org
References: <20230309135419.30159-1-Garmin.Chang@mediatek.com>
 <20230309135419.30159-4-Garmin.Chang@mediatek.com>
From:   AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
In-Reply-To: <20230309135419.30159-4-Garmin.Chang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Il 09/03/23 14:54, Garmin.Chang ha scritto:
> Add MT8188 topckgen clock controller which provides muxes, dividers
> to handle variety clock selection in other IP blocks.
> 
> Signed-off-by: Garmin.Chang <Garmin.Chang@mediatek.com>
> ---
>   drivers/clk/mediatek/Makefile              |    2 +-
>   drivers/clk/mediatek/clk-mt8188-topckgen.c | 1347 ++++++++++++++++++++
>   2 files changed, 1348 insertions(+), 1 deletion(-)
>   create mode 100644 drivers/clk/mediatek/clk-mt8188-topckgen.c
> 
> diff --git a/drivers/clk/mediatek/Makefile b/drivers/clk/mediatek/Makefile
> index 1f822fcf6084..d845bf7308c3 100644
> --- a/drivers/clk/mediatek/Makefile
> +++ b/drivers/clk/mediatek/Makefile
> @@ -91,7 +91,7 @@ obj-$(CONFIG_COMMON_CLK_MT8186) += clk-mt8186-mcu.o clk-mt8186-topckgen.o clk-mt
>   				   clk-mt8186-mfg.o clk-mt8186-mm.o clk-mt8186-wpe.o \
>   				   clk-mt8186-img.o clk-mt8186-vdec.o clk-mt8186-venc.o \
>   				   clk-mt8186-cam.o clk-mt8186-mdp.o clk-mt8186-ipe.o
> -obj-$(CONFIG_COMMON_CLK_MT8188) += clk-mt8188-apmixedsys.o
> +obj-$(CONFIG_COMMON_CLK_MT8188) += clk-mt8188-apmixedsys.o clk-mt8188-topckgen.o
>   obj-$(CONFIG_COMMON_CLK_MT8192) += clk-mt8192.o
>   obj-$(CONFIG_COMMON_CLK_MT8192_AUDSYS) += clk-mt8192-aud.o
>   obj-$(CONFIG_COMMON_CLK_MT8192_CAMSYS) += clk-mt8192-cam.o
> diff --git a/drivers/clk/mediatek/clk-mt8188-topckgen.c b/drivers/clk/mediatek/clk-mt8188-topckgen.c
> new file mode 100644
> index 000000000000..b3f9577de081
> --- /dev/null
> +++ b/drivers/clk/mediatek/clk-mt8188-topckgen.c
> @@ -0,0 +1,1347 @@

..snip..

> +
> +static const struct of_device_id of_match_clk_mt8188_topck[] = {
> +	{ .compatible = "mediatek,mt8188-topckgen", },

	{ .compatible = "mediatek,mt8188-topckgen" },
	{ /* sentinel */ }

> +	{}
> +};
> +
> +/* Register mux notifier for MFG mux */
> +static int clk_mt8188_reg_mfg_mux_notifier(struct device *dev, struct clk *clk)
> +{
> +	struct mtk_mux_nb *mfg_mux_nb;
> +
> +	mfg_mux_nb = devm_kzalloc(dev, sizeof(*mfg_mux_nb), GFP_KERNEL);
> +	if (!mfg_mux_nb)
> +		return -ENOMEM;
> +
> +	mfg_mux_nb->ops = &clk_mux_ops;
> +	mfg_mux_nb->bypass_index = 0; /* Bypass to TOP_MFG_CORE_TMP */
> +
> +	return devm_mtk_clk_mux_notifier_register(dev, clk, mfg_mux_nb);
> +}
> +
> +static int clk_mt8188_topck_probe(struct platform_device *pdev)
> +{
> +	struct clk_hw_onecell_data *top_clk_data;
> +	struct device_node *node = pdev->dev.of_node;
> +	struct clk_hw *hw;
> +	int r;
> +	void __iomem *base;
> +
> +	top_clk_data = mtk_alloc_clk_data(CLK_TOP_NR_CLK);
> +	if (!top_clk_data)
> +		return -ENOMEM;
> +
> +	base = devm_platform_ioremap_resource(pdev, 0);
> +	if (IS_ERR(base)) {
> +		r = PTR_ERR(base);
> +		goto free_top_data;
> +	}
> +
> +	r = mtk_clk_register_fixed_clks(top_fixed_clks, ARRAY_SIZE(top_fixed_clks),
> +					top_clk_data);
> +	if (r)
> +		goto free_top_data;
> +
> +	r = mtk_clk_register_factors(top_divs, ARRAY_SIZE(top_divs), top_clk_data);
> +	if (r)
> +		goto unregister_fixed_clks;
> +
> +	r = mtk_clk_register_muxes(&pdev->dev, top_mtk_muxes,
> +				   ARRAY_SIZE(top_mtk_muxes), node,
> +				   &mt8188_clk_lock, top_clk_data);
> +	if (r)
> +		goto unregister_factors;
> +
> +	hw = devm_clk_hw_register_mux(&pdev->dev, "mfg_ck_fast_ref", mfg_fast_ref_parents,
> +				      ARRAY_SIZE(mfg_fast_ref_parents), CLK_SET_RATE_PARENT,
> +				      (base + 0x250), 8, 1, 0, &mt8188_clk_lock);

If you make this a mtk mux and put it in top_mtk_muxes, you can migrate topckgen to
the simple_probe() mechanism, greatly reducing the size of this file.

> +	if (IS_ERR(hw)) {
> +		r = PTR_ERR(hw);
> +		goto unregister_muxes;
> +	}
> +	top_clk_data->hws[CLK_TOP_MFG_CK_FAST_REF] = hw;
> +
> +	r = clk_mt8188_reg_mfg_mux_notifier(&pdev->dev,
> +					    top_clk_data->hws[CLK_TOP_MFG_CK_FAST_REF]->clk);
> +	if (r)
> +		goto unregister_muxes;
> +
> +	r = mtk_clk_register_composites(&pdev->dev, top_adj_divs,
> +					ARRAY_SIZE(top_adj_divs), base,
> +					&mt8188_clk_lock, top_clk_data);
> +	if (r)
> +		goto unregister_muxes;
> +
> +	r = mtk_clk_register_gates(&pdev->dev, node, top_clks,
> +				   ARRAY_SIZE(top_clks), top_clk_data);
> +	if (r)
> +		goto unregister_composite_divs;
> +
> +	r = of_clk_add_hw_provider(node, of_clk_hw_onecell_get, top_clk_data);
> +	if (r)
> +		goto unregister_gates;
> +
> +	platform_set_drvdata(pdev, top_clk_data);
> +
> +	return r;
> +
> +unregister_gates:
> +	mtk_clk_unregister_gates(top_clks, ARRAY_SIZE(top_clks), top_clk_data);
> +unregister_composite_divs:
> +	mtk_clk_unregister_composites(top_adj_divs, ARRAY_SIZE(top_adj_divs), top_clk_data);
> +unregister_muxes:
> +	mtk_clk_unregister_muxes(top_mtk_muxes, ARRAY_SIZE(top_mtk_muxes), top_clk_data);
> +unregister_factors:
> +	mtk_clk_unregister_factors(top_divs, ARRAY_SIZE(top_divs), top_clk_data);
> +unregister_fixed_clks:
> +	mtk_clk_unregister_fixed_clks(top_fixed_clks, ARRAY_SIZE(top_fixed_clks), top_clk_data);
> +free_top_data:
> +	mtk_free_clk_data(top_clk_data);
> +	return r;
> +}
> +
> +static int clk_mt8188_topck_remove(struct platform_device *pdev)
> +{
> +	struct clk_hw_onecell_data *top_clk_data = platform_get_drvdata(pdev);
> +	struct device_node *node = pdev->dev.of_node;
> +
> +	of_clk_del_provider(node);
> +	mtk_clk_unregister_gates(top_clks, ARRAY_SIZE(top_clks), top_clk_data);
> +	mtk_clk_unregister_composites(top_adj_divs, ARRAY_SIZE(top_adj_divs), top_clk_data);
> +	mtk_clk_unregister_muxes(top_mtk_muxes, ARRAY_SIZE(top_mtk_muxes), top_clk_data);
> +	mtk_clk_unregister_factors(top_divs, ARRAY_SIZE(top_divs), top_clk_data);
> +	mtk_clk_unregister_fixed_clks(top_fixed_clks, ARRAY_SIZE(top_fixed_clks), top_clk_data);
> +	mtk_free_clk_data(top_clk_data);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver clk_mt8188_topck_drv = {
> +	.probe = clk_mt8188_topck_probe,
> +	.remove = clk_mt8188_topck_remove,
> +	.driver = {
> +		.name = "clk-mt8188-topck",
> +		.of_match_table = of_match_clk_mt8188_topck,
> +	},
> +};
> +builtin_platform_driver(clk_mt8188_topck_drv);

module_platform_driver....
MODULE_LICENSE....
