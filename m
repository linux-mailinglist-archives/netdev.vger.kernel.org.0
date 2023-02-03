Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02C7868912A
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 08:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232103AbjBCHop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 02:44:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230372AbjBCHoo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 02:44:44 -0500
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB189530E1
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 23:44:42 -0800 (PST)
Received: by mail-vs1-xe34.google.com with SMTP id i185so4516538vsc.6
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 23:44:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vAOaUx7T7Cu+LAftmHHRVB4VKcZ+Xc3uW8+s1X+hVZw=;
        b=gq5MUrSJ/9JtIgYyV4JN/4/n6VuMG6198scgG+JIkoi8kmWUXwxGjjSNARrolmvhZn
         3IyjSgrRNP8+a511vwEdpLF2Gh4Q7HjwFowxQAGr6KXocKOdqJYeSA0U2Vx5YMzbANJb
         gediuIB8q0cH3IN0PkzEhpxtvVA8Cu8H+WCUs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vAOaUx7T7Cu+LAftmHHRVB4VKcZ+Xc3uW8+s1X+hVZw=;
        b=Nmfs7W/AOwFL8LZc7agUqaEcxIP6kmO6kylFW5MknsieaJk0aV0EiDHN7+7+jzzF9d
         Xm2caUgWbg0+9jO7pHPSD5FOGQJODLnnZ5pjl3y00qbDSsrCuQ1xDtVlcZHLBvpvl1Ta
         2fCLNBc3qKx1/zZU1anVI6FFx+SE6+cqS1oC2Qjf9DqCivHsrldDxm7mp0ek9rezf1F9
         BSvHGJTVrluUjfdJymi0RAVNuOxsZG5jse1TztEY3jUJ4lBOkpMdseYGt+nfuoLmzdQM
         iBiLqcrqQY31AMOZV259YtG7pEsa3V/E6rtxb5smK6KT1OjiAA5CyqCaSlYgpNsAhyXz
         30BA==
X-Gm-Message-State: AO0yUKV01Ihc2dET2tWv8JwcSiEe+X5UH91k/Xzqn49yUWgmL84oFYWg
        NCO5+4NvXbJJjqWhjY9/DIozGNl5tAHdq0wuTvDdIw==
X-Google-Smtp-Source: AK7set9CUantc+6n4V8N9/P3Re52vaOGFzASoC6rAwLJRywAMVfCLbAqy5Q1tFyIRU7hq97adRki14ON3Yk4OLLgar4=
X-Received: by 2002:a05:6102:23f2:b0:3ed:89c7:4bd2 with SMTP id
 p18-20020a05610223f200b003ed89c74bd2mr1682282vsc.26.1675410282031; Thu, 02
 Feb 2023 23:44:42 -0800 (PST)
MIME-Version: 1.0
References: <20230119124848.26364-1-Garmin.Chang@mediatek.com> <20230119124848.26364-3-Garmin.Chang@mediatek.com>
In-Reply-To: <20230119124848.26364-3-Garmin.Chang@mediatek.com>
From:   Chen-Yu Tsai <wenst@chromium.org>
Date:   Fri, 3 Feb 2023 15:44:31 +0800
Message-ID: <CAGXv+5FwJ-bO760bd=dz4K60KUsKV6M66MGribg_B9T0pcb0cQ@mail.gmail.com>
Subject: Re: [PATCH v5 02/19] clk: mediatek: Add MT8188 apmixedsys clock support
To:     "Garmin.Chang" <Garmin.Chang@mediatek.com>
Cc:     Matthias Brugger <matthias.bgg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Project_Global_Chrome_Upstream_Group@mediatek.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-clk@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 19, 2023 at 8:54 PM Garmin.Chang <Garmin.Chang@mediatek.com> wrote:
>
> Add MT8188 apmixedsys clock controller which provides Plls
> generated from SoC 26m and ssusb clock gate control.
>
> Signed-off-by: Garmin.Chang <Garmin.Chang@mediatek.com>
> ---
>  drivers/clk/mediatek/Kconfig                 |  11 ++
>  drivers/clk/mediatek/Makefile                |   1 +
>  drivers/clk/mediatek/clk-mt8188-apmixedsys.c | 154 +++++++++++++++++++
>  3 files changed, 166 insertions(+)
>  create mode 100644 drivers/clk/mediatek/clk-mt8188-apmixedsys.c
>
> diff --git a/drivers/clk/mediatek/Kconfig b/drivers/clk/mediatek/Kconfig
> index 22e8e79475ee..f02b679f71d0 100644
> --- a/drivers/clk/mediatek/Kconfig
> +++ b/drivers/clk/mediatek/Kconfig
> @@ -565,6 +565,17 @@ config COMMON_CLK_MT8186
>         help
>           This driver supports MediaTek MT8186 clocks.
>
> +config COMMON_CLK_MT8188
> +       bool "Clock driver for MediaTek MT8188"
> +       depends on ARM64 || COMPILE_TEST
> +       select COMMON_CLK_MEDIATEK
> +       default ARCH_MEDIATEK
> +       help
> +         This driver supports MediaTek MT8188 basic clocks and clocks
> +         required for various peripheral found on MediaTek. Choose
> +         M or Y here if you want to use clocks such as peri_ao,
> +         infra_ao, etc.
> +
>  config COMMON_CLK_MT8192
>         bool "Clock driver for MediaTek MT8192"
>         depends on ARM64 || COMPILE_TEST
> diff --git a/drivers/clk/mediatek/Makefile b/drivers/clk/mediatek/Makefile
> index e24080fd6e7f..13ab8deb362c 100644
> --- a/drivers/clk/mediatek/Makefile
> +++ b/drivers/clk/mediatek/Makefile
> @@ -83,6 +83,7 @@ obj-$(CONFIG_COMMON_CLK_MT8186) += clk-mt8186-mcu.o clk-mt8186-topckgen.o clk-mt
>                                    clk-mt8186-mfg.o clk-mt8186-mm.o clk-mt8186-wpe.o \
>                                    clk-mt8186-img.o clk-mt8186-vdec.o clk-mt8186-venc.o \
>                                    clk-mt8186-cam.o clk-mt8186-mdp.o clk-mt8186-ipe.o
> +obj-$(CONFIG_COMMON_CLK_MT8188) += clk-mt8188-apmixedsys.o
>  obj-$(CONFIG_COMMON_CLK_MT8192) += clk-mt8192.o
>  obj-$(CONFIG_COMMON_CLK_MT8192_AUDSYS) += clk-mt8192-aud.o
>  obj-$(CONFIG_COMMON_CLK_MT8192_CAMSYS) += clk-mt8192-cam.o
> diff --git a/drivers/clk/mediatek/clk-mt8188-apmixedsys.c b/drivers/clk/mediatek/clk-mt8188-apmixedsys.c
> new file mode 100644
> index 000000000000..8d73ae3a0da8
> --- /dev/null
> +++ b/drivers/clk/mediatek/clk-mt8188-apmixedsys.c
> @@ -0,0 +1,154 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +//
> +// Copyright (c) 2022 MediaTek Inc.
> +// Author: Garmin Chang <garmin.chang@mediatek.com>
> +
> +#include <linux/of_device.h>
> +#include <linux/platform_device.h>
> +#include <dt-bindings/clock/mediatek,mt8188-clk.h>
> +
> +#include "clk-gate.h"
> +#include "clk-mtk.h"
> +#include "clk-pll.h"
> +
> +static const struct mtk_gate_regs apmixed_cg_regs = {
> +       .set_ofs = 0x8,
> +       .clr_ofs = 0x8,
> +       .sta_ofs = 0x8,
> +};
> +
> +#define GATE_APMIXED(_id, _name, _parent, _shift)                      \
> +       GATE_MTK(_id, _name, _parent, &apmixed_cg_regs, _shift, &mtk_clk_gate_ops_no_setclr_inv)
> +
> +static const struct mtk_gate apmixed_clks[] = {
> +       GATE_APMIXED(CLK_APMIXED_PLL_SSUSB26M_EN, "pll_ssusb26m_en", "clk26m", 1),
> +};
> +
> +#define MT8188_PLL_FMAX                (3800UL * MHZ)
> +#define MT8188_PLL_FMIN                (1500UL * MHZ)
> +#define MT8188_INTEGER_BITS    8
> +
> +#define PLL(_id, _name, _reg, _pwr_reg, _en_mask, _flags,              \
> +           _rst_bar_mask, _pcwbits, _pd_reg, _pd_shift,                \
> +           _tuner_reg, _tuner_en_reg, _tuner_en_bit,                   \
> +           _pcw_reg, _pcw_shift, _pcw_chg_reg,                         \
> +           _en_reg, _pll_en_bit) {                                     \
> +               .id = _id,                                              \
> +               .name = _name,                                          \
> +               .reg = _reg,                                            \
> +               .pwr_reg = _pwr_reg,                                    \
> +               .en_mask = _en_mask,                                    \
> +               .flags = _flags,                                        \
> +               .rst_bar_mask = _rst_bar_mask,                          \
> +               .fmax = MT8188_PLL_FMAX,                                \
> +               .fmin = MT8188_PLL_FMIN,                                \
> +               .pcwbits = _pcwbits,                                    \
> +               .pcwibits = MT8188_INTEGER_BITS,                        \
> +               .pd_reg = _pd_reg,                                      \
> +               .pd_shift = _pd_shift,                                  \
> +               .tuner_reg = _tuner_reg,                                \
> +               .tuner_en_reg = _tuner_en_reg,                          \
> +               .tuner_en_bit = _tuner_en_bit,                          \
> +               .pcw_reg = _pcw_reg,                                    \
> +               .pcw_shift = _pcw_shift,                                \
> +               .pcw_chg_reg = _pcw_chg_reg,                            \
> +               .en_reg = _en_reg,                                      \
> +               .pll_en_bit = _pll_en_bit,                              \
> +       }
> +
> +static const struct mtk_pll_data plls[] = {
> +       PLL(CLK_APMIXED_ETHPLL, "ethpll", 0x044C, 0x0458, 0,
> +           0, 0, 22, 0x0450, 24, 0, 0, 0, 0x0450, 0, 0, 0, 9),
> +       PLL(CLK_APMIXED_MSDCPLL, "msdcpll", 0x0514, 0x0520, 0,
> +           0, 0, 22, 0x0518, 24, 0, 0, 0, 0x0518, 0, 0, 0, 9),
> +       PLL(CLK_APMIXED_TVDPLL1, "tvdpll1", 0x0524, 0x0530, 0,
> +           0, 0, 22, 0x0528, 24, 0, 0, 0, 0x0528, 0, 0, 0, 9),
> +       PLL(CLK_APMIXED_TVDPLL2, "tvdpll2", 0x0534, 0x0540, 0,
> +           0, 0, 22, 0x0538, 24, 0, 0, 0, 0x0538, 0, 0, 0, 9),
> +       PLL(CLK_APMIXED_MMPLL, "mmpll", 0x0544, 0x0550, 0xff000000,
> +           HAVE_RST_BAR, BIT(23), 22, 0x0548, 24, 0, 0, 0, 0x0548, 0, 0, 0, 9),
> +       PLL(CLK_APMIXED_MAINPLL, "mainpll", 0x045C, 0x0468, 0xff000000,
> +           HAVE_RST_BAR, BIT(23), 22, 0x0460, 24, 0, 0, 0, 0x0460, 0, 0, 0, 9),
> +       PLL(CLK_APMIXED_IMGPLL, "imgpll", 0x0554, 0x0560, 0,
> +           0, 0, 22, 0x0558, 24, 0, 0, 0, 0x0558, 0, 0, 0, 9),
> +       PLL(CLK_APMIXED_UNIVPLL, "univpll", 0x0504, 0x0510, 0xff000000,
> +           HAVE_RST_BAR, BIT(23), 22, 0x0508, 24, 0, 0, 0, 0x0508, 0, 0, 0, 9),
> +       PLL(CLK_APMIXED_ADSPPLL, "adsppll", 0x042C, 0x0438, 0,
> +           0, 0, 22, 0x0430, 24, 0, 0, 0, 0x0430, 0, 0, 0, 9),
> +       PLL(CLK_APMIXED_APLL1, "apll1", 0x0304, 0x0314, 0,
> +           0, 0, 32, 0x0308, 24, 0x0034, 0x0000, 12, 0x030C, 0, 0, 0, 9),
> +       PLL(CLK_APMIXED_APLL2, "apll2", 0x0318, 0x0328, 0,
> +           0, 0, 32, 0x031C, 24, 0x0038, 0x0000, 13, 0x0320, 0, 0, 0, 9),
> +       PLL(CLK_APMIXED_APLL3, "apll3", 0x032C, 0x033C, 0,
> +           0, 0, 32, 0x0330, 24, 0x003C, 0x0000, 14, 0x0334, 0, 0, 0, 9),
> +       PLL(CLK_APMIXED_APLL4, "apll4", 0x0404, 0x0414, 0,
> +           0, 0, 32, 0x0408, 24, 0x0040, 0x0000, 15, 0x040C, 0, 0, 0, 9),
> +       PLL(CLK_APMIXED_APLL5, "apll5", 0x0418, 0x0428, 0,
> +           0, 0, 32, 0x041C, 24, 0x0044, 0x0000, 16, 0x0420, 0, 0, 0, 9),
> +       PLL(CLK_APMIXED_MFGPLL, "mfgpll", 0x0340, 0x034C, 0,
> +           0, 0, 22, 0x0344, 24, 0, 0, 0, 0x0344, 0, 0, 0, 9),
> +};
> +
> +static const struct of_device_id of_match_clk_mt8188_apmixed[] = {
> +       { .compatible = "mediatek,mt8188-apmixedsys", },
> +       {}
> +};
> +
> +static int clk_mt8188_apmixed_probe(struct platform_device *pdev)
> +{
> +       struct clk_hw_onecell_data *clk_data;
> +       struct device_node *node = pdev->dev.of_node;
> +       int r;
> +
> +       clk_data = mtk_alloc_clk_data(CLK_APMIXED_NR_CLK);
> +       if (!clk_data)
> +               return -ENOMEM;
> +
> +       r = mtk_clk_register_plls(node, plls, ARRAY_SIZE(plls), clk_data);
> +       if (r)
> +               goto free_apmixed_data;
> +
> +       r = mtk_clk_register_gates_with_dev(node, apmixed_clks,
> +               ARRAY_SIZE(apmixed_clks), clk_data, NULL);

This API is gone. Please replace it with mtk_clk_register_clks. And please
pass in the |struct device| pointer.

ChenYu
