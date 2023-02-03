Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5386890C0
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 08:26:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232056AbjBCH0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 02:26:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231426AbjBCH0F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 02:26:05 -0500
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 543C392EDC
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 23:25:52 -0800 (PST)
Received: by mail-vs1-xe34.google.com with SMTP id k4so4479049vsc.4
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 23:25:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qnqohepmJa02iQzv6KIF3XV1XpzLx8j7mEp5PrY56aY=;
        b=d1V4RalDykH+eYJ0ijdqMHKhTm9Br6Qy67RGt94My2LbwUpT2hKbh9NhJs/Q5WPKtJ
         p7B+9FPOZCJ5XgjJLmA0FyAi+1C1Q17gy0NMsJiDwj7HtLjowv1Ob7zPD+IicxWjAlSb
         BFuT/bx88qD9AGgcoGRekuLM3lnweBUz5C1x0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qnqohepmJa02iQzv6KIF3XV1XpzLx8j7mEp5PrY56aY=;
        b=VuLzva/wwHJokiUo7uYfAWG84o333M2hRZZectI+w9J+C2+7avNhrm8jo3pvG7Emy4
         y4bJKPl4jaDGpaunU4N6aGI7XuiMYbt10CQtjexC2rVAwLuzOc2xUKKZrfknPZdnkO9K
         9rCVjLcwbdVIIVAj+2y81UqUB/5nBMZu9DWaje1SwXGR8NZ/DuuVwQuJ27cb+stlS7fx
         LT2xbcZdQvFn59hipRsLFSiXZjVuxTKLpazwohI4b2ByLRj9A+PtFTNCZ1PQ26U8kHMY
         IQ30dTgvsagQsNW0sKog/XEQ4kLgFNyRe5Ir1FHTEznRtCTxH2vYg/xRT2jAzKV+6HWg
         USDw==
X-Gm-Message-State: AO0yUKW0GkqVBNKf9hiUphnJDjZlhbOmeT+KcZzMCZ7KhZdIrfKvgUXu
        YSxLWo2MTsGrTh2AccyOcp2uol52Q/p79KhVqm8z8Q==
X-Google-Smtp-Source: AK7set/QhhNfvDnI8ndzCui1EaYl9KSQkOZVYXLyNV4ahcE56o+jXFfQpW+COvR08tXJVdwmEFSkso5rv+20ss21tG4=
X-Received: by 2002:a05:6102:23f2:b0:3ed:89c7:4bd2 with SMTP id
 p18-20020a05610223f200b003ed89c74bd2mr1674741vsc.26.1675409151465; Thu, 02
 Feb 2023 23:25:51 -0800 (PST)
MIME-Version: 1.0
References: <20230119124848.26364-1-Garmin.Chang@mediatek.com> <20230119124848.26364-15-Garmin.Chang@mediatek.com>
In-Reply-To: <20230119124848.26364-15-Garmin.Chang@mediatek.com>
From:   Chen-Yu Tsai <wenst@chromium.org>
Date:   Fri, 3 Feb 2023 15:25:40 +0800
Message-ID: <CAGXv+5ECLKewj1_sU9WzJA9Z8pRyKBo6fxBLrogoBH76Y5f32w@mail.gmail.com>
Subject: Re: [PATCH v5 14/19] clk: mediatek: Add MT8188 vencsys clock support
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
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 19, 2023 at 8:55 PM Garmin.Chang <Garmin.Chang@mediatek.com> wrote:
>
> Add MT8188 vencsys clock controllers which provide clock gate
> control for video encoder.
>
> Signed-off-by: Garmin.Chang <Garmin.Chang@mediatek.com>
> ---
>  drivers/clk/mediatek/Makefile          |  2 +-
>  drivers/clk/mediatek/clk-mt8188-venc.c | 52 ++++++++++++++++++++++++++
>  2 files changed, 53 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/clk/mediatek/clk-mt8188-venc.c
>
> diff --git a/drivers/clk/mediatek/Makefile b/drivers/clk/mediatek/Makefile
> index c654f4288e09..22a3840160fc 100644
> --- a/drivers/clk/mediatek/Makefile
> +++ b/drivers/clk/mediatek/Makefile
> @@ -87,7 +87,7 @@ obj-$(CONFIG_COMMON_CLK_MT8188) += clk-mt8188-apmixedsys.o clk-mt8188-topckgen.o
>                                    clk-mt8188-peri_ao.o clk-mt8188-infra_ao.o \
>                                    clk-mt8188-cam.o clk-mt8188-ccu.o clk-mt8188-img.o \
>                                    clk-mt8188-ipe.o clk-mt8188-mfg.o clk-mt8188-vdec.o \
> -                                  clk-mt8188-vdo0.o clk-mt8188-vdo1.o
> +                                  clk-mt8188-vdo0.o clk-mt8188-vdo1.o clk-mt8188-venc.o
>  obj-$(CONFIG_COMMON_CLK_MT8192) += clk-mt8192.o
>  obj-$(CONFIG_COMMON_CLK_MT8192_AUDSYS) += clk-mt8192-aud.o
>  obj-$(CONFIG_COMMON_CLK_MT8192_CAMSYS) += clk-mt8192-cam.o
> diff --git a/drivers/clk/mediatek/clk-mt8188-venc.c b/drivers/clk/mediatek/clk-mt8188-venc.c
> new file mode 100644
> index 000000000000..375ef99e2349
> --- /dev/null
> +++ b/drivers/clk/mediatek/clk-mt8188-venc.c
> @@ -0,0 +1,52 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +//
> +// Copyright (c) 2022 MediaTek Inc.
> +// Author: Garmin Chang <garmin.chang@mediatek.com>
> +
> +#include <linux/clk-provider.h>
> +#include <linux/platform_device.h>
> +#include <dt-bindings/clock/mediatek,mt8188-clk.h>
> +
> +#include "clk-gate.h"
> +#include "clk-mtk.h"
> +
> +static const struct mtk_gate_regs ven1_cg_regs = {

Like the vdecsys patch, please change "ven" to "venc" to be consistent
with usages elsewhere.

> +       .set_ofs = 0x4,
> +       .clr_ofs = 0x8,
> +       .sta_ofs = 0x0,
> +};
> +
> +#define GATE_VEN1(_id, _name, _parent, _shift)                 \
> +       GATE_MTK(_id, _name, _parent, &ven1_cg_regs, _shift, &mtk_clk_gate_ops_setclr_inv)
> +
> +static const struct mtk_gate ven1_clks[] = {
> +       GATE_VEN1(CLK_VEN1_CKE0_LARB, "ven1_cke0_larb", "top_venc", 0),
> +       GATE_VEN1(CLK_VEN1_CKE1_VENC, "ven1_cke1_venc", "top_venc", 4),
> +       GATE_VEN1(CLK_VEN1_CKE2_JPGENC, "ven1_cke2_jpgenc", "top_venc", 8),
> +       GATE_VEN1(CLK_VEN1_CKE3_JPGDEC, "ven1_cke3_jpgdec", "top_venc", 12),
> +       GATE_VEN1(CLK_VEN1_CKE4_JPGDEC_C1, "ven1_cke4_jpgdec_c1", "top_venc", 16),
> +       GATE_VEN1(CLK_VEN1_CKE5_GALS, "ven1_cke5_gals", "top_venc", 28),
> +       GATE_VEN1(CLK_VEN1_CKE6_GALS_SRAM, "ven1_cke6_gals_sram", "top_venc", 31),

Is ckeN in both the macro name and clock name necessary? We don't really
care about the index.

ChenYu

> +};
> +
> +static const struct mtk_clk_desc ven1_desc = {
> +       .clks = ven1_clks,
> +       .num_clks = ARRAY_SIZE(ven1_clks),
> +};
> +
> +static const struct of_device_id of_match_clk_mt8188_ven1[] = {
> +       { .compatible = "mediatek,mt8188-vencsys", .data = &ven1_desc },
> +       { /* sentinel */ }
> +};
> +
> +static struct platform_driver clk_mt8188_ven1_drv = {
> +       .probe = mtk_clk_simple_probe,
> +       .remove = mtk_clk_simple_remove,
> +       .driver = {
> +               .name = "clk-mt8188-ven1",
> +               .of_match_table = of_match_clk_mt8188_ven1,
> +       },
> +};
> +
> +builtin_platform_driver(clk_mt8188_ven1_drv);
> +MODULE_LICENSE("GPL");
> --
> 2.18.0
>
>
