Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E202968909C
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 08:19:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231672AbjBCHRP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 02:17:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231705AbjBCHRO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 02:17:14 -0500
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7B3A6F73C
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 23:17:11 -0800 (PST)
Received: by mail-vs1-xe34.google.com with SMTP id 187so4450593vsv.10
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 23:17:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WP6MW/AxTXjVByX3Tw5+ZQ2b+cfJfjcOdQtYVTAliZk=;
        b=aKRsAKk3/tQQjWAq76ElA8GyUDDyLbiVUpOBYDhOFOOpN39NDlJDp7QhfjWvqLF6gQ
         NFl8GueeryM2GB3Cw+xJir/zhirD/tdS4tX5G3ZHNTtSvoCe6AW+fZ1qUD4b+wVAkylF
         1I6x7t4VPdTQIxwtQ4Scq7d1g8zvIrmj7qWqo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WP6MW/AxTXjVByX3Tw5+ZQ2b+cfJfjcOdQtYVTAliZk=;
        b=Mzk8mcfg1rZJ2wPLwIADJVwigeuXP7p3pON0CFctBrMgx5AMFd+jt+vBjy6MYTx6yd
         xvzWLPKbn4IwjKfHxANc4u/P7HT//2aO+lhF8zcLOqc949u5pKcRTfMTYtiV7WuqPtJ5
         Va6Y7kzrgrrcrx2aUUY7I4BHGIN4Nl3dns46tj7IVjfVySgmAZ9DSzHPEODadV9uuPbB
         TXkCEq5YD/NCEHXGoYwuxqEjI45OZXtVA/FLXjQYdAHMFhEuF4KqhDA5SrNLq93Aqf6G
         jfvDvVHzLAm6/NN4WnhAzdZOMreBDFPc+HpFrkvvELAjZK2NjzZko40U5/hejm2rka69
         LXFA==
X-Gm-Message-State: AO0yUKUT2rtJPUKfYTpgTppw+POwhS9CrPEya6BPeIIFeCXCP4b60qC8
        aYh4qn+cG0/R87df85wd44qwqSB750QEk4XZzilpag==
X-Google-Smtp-Source: AK7set+SibYPv5VxOZavVaTXiZ4zOO474EeZunS1fpxZm92G7Fj+lArt7EhMvgZpDSSJrbsgV1bpwWy/kPckgN38X5s=
X-Received: by 2002:a67:f551:0:b0:3e8:d5a8:3fbe with SMTP id
 z17-20020a67f551000000b003e8d5a83fbemr1543370vsn.9.1675408631029; Thu, 02 Feb
 2023 23:17:11 -0800 (PST)
MIME-Version: 1.0
References: <20230119124848.26364-1-Garmin.Chang@mediatek.com> <20230119124848.26364-12-Garmin.Chang@mediatek.com>
In-Reply-To: <20230119124848.26364-12-Garmin.Chang@mediatek.com>
From:   Chen-Yu Tsai <wenst@chromium.org>
Date:   Fri, 3 Feb 2023 15:17:00 +0800
Message-ID: <CAGXv+5HtzbrA5dpzXSoSXMFooHXoeX7iwJA9A1HJKQ09qm+Umw@mail.gmail.com>
Subject: Re: [PATCH v5 11/19] clk: mediatek: Add MT8188 vdecsys clock support
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

On Thu, Jan 19, 2023 at 8:49 PM Garmin.Chang <Garmin.Chang@mediatek.com> wrote:
>
> Add MT8188 vdec clock controllers which provide clock gate
> control for video decoder.
>
> Signed-off-by: Garmin.Chang <Garmin.Chang@mediatek.com>
> ---
>  drivers/clk/mediatek/Makefile          |  2 +-
>  drivers/clk/mediatek/clk-mt8188-vdec.c | 90 ++++++++++++++++++++++++++
>  2 files changed, 91 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/clk/mediatek/clk-mt8188-vdec.c
>
> diff --git a/drivers/clk/mediatek/Makefile b/drivers/clk/mediatek/Makefile
> index a0fd87a882b5..7d09e9fc6538 100644
> --- a/drivers/clk/mediatek/Makefile
> +++ b/drivers/clk/mediatek/Makefile
> @@ -86,7 +86,7 @@ obj-$(CONFIG_COMMON_CLK_MT8186) += clk-mt8186-mcu.o clk-mt8186-topckgen.o clk-mt
>  obj-$(CONFIG_COMMON_CLK_MT8188) += clk-mt8188-apmixedsys.o clk-mt8188-topckgen.o \
>                                    clk-mt8188-peri_ao.o clk-mt8188-infra_ao.o \
>                                    clk-mt8188-cam.o clk-mt8188-ccu.o clk-mt8188-img.o \
> -                                  clk-mt8188-ipe.o clk-mt8188-mfg.o
> +                                  clk-mt8188-ipe.o clk-mt8188-mfg.o clk-mt8188-vdec.o
>  obj-$(CONFIG_COMMON_CLK_MT8192) += clk-mt8192.o
>  obj-$(CONFIG_COMMON_CLK_MT8192_AUDSYS) += clk-mt8192-aud.o
>  obj-$(CONFIG_COMMON_CLK_MT8192_CAMSYS) += clk-mt8192-cam.o
> diff --git a/drivers/clk/mediatek/clk-mt8188-vdec.c b/drivers/clk/mediatek/clk-mt8188-vdec.c
> new file mode 100644
> index 000000000000..e05a27957136
> --- /dev/null
> +++ b/drivers/clk/mediatek/clk-mt8188-vdec.c
> @@ -0,0 +1,90 @@
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
> +static const struct mtk_gate_regs vde0_cg_regs = {

Could you replace all instances of "vde" (both upper and lower case)
with "vdec" to be consistent with usages elsewhere?

> +       .set_ofs = 0x0,
> +       .clr_ofs = 0x4,
> +       .sta_ofs = 0x0,
> +};
> +
> +static const struct mtk_gate_regs vde1_cg_regs = {
> +       .set_ofs = 0x200,
> +       .clr_ofs = 0x204,
> +       .sta_ofs = 0x200,
> +};
> +
> +static const struct mtk_gate_regs vde2_cg_regs = {
> +       .set_ofs = 0x8,
> +       .clr_ofs = 0xc,
> +       .sta_ofs = 0x8,
> +};
> +
> +#define GATE_VDE0(_id, _name, _parent, _shift)                 \
> +       GATE_MTK(_id, _name, _parent, &vde0_cg_regs, _shift, &mtk_clk_gate_ops_setclr_inv)
> +
> +#define GATE_VDE1(_id, _name, _parent, _shift)                 \
> +       GATE_MTK(_id, _name, _parent, &vde1_cg_regs, _shift, &mtk_clk_gate_ops_setclr_inv)
> +
> +#define GATE_VDE2(_id, _name, _parent, _shift)                 \
> +       GATE_MTK(_id, _name, _parent, &vde2_cg_regs, _shift, &mtk_clk_gate_ops_setclr_inv)
> +
> +static const struct mtk_gate vde1_clks[] = {
> +       /* VDE1_0 */
> +       GATE_VDE0(CLK_VDE1_SOC_VDEC, "vde1_soc_vdec", "top_vdec", 0),
> +       GATE_VDE0(CLK_VDE1_SOC_VDEC_ACTIVE, "vde1_soc_vdec_active", "top_vdec", 4),
> +       GATE_VDE0(CLK_VDE1_SOC_VDEC_ENG, "vde1_soc_vdec_eng", "top_vdec", 8),
> +       /* VDE1_1 */
> +       GATE_VDE1(CLK_VDE1_SOC_LAT, "vde1_soc_lat", "top_vdec", 0),
> +       GATE_VDE1(CLK_VDE1_SOC_LAT_ACTIVE, "vde1_soc_lat_active", "top_vdec", 4),
> +       GATE_VDE1(CLK_VDE1_SOC_LAT_ENG, "vde1_soc_lat_eng", "top_vdec", 8),
> +       /* VDE12 */

Add an underscore like the above?

ChenYu

> +       GATE_VDE2(CLK_VDE1_SOC_LARB1, "vde1_soc_larb1", "top_vdec", 0),
> +};
> +
> +static const struct mtk_gate vde2_clks[] = {
> +       /* VDE2_0 */
> +       GATE_VDE0(CLK_VDE2_VDEC, "vde2_vdec", "top_vdec", 0),
> +       GATE_VDE0(CLK_VDE2_VDEC_ACTIVE, "vde2_vdec_active", "top_vdec", 4),
> +       GATE_VDE0(CLK_VDE2_VDEC_ENG, "vde2_vdec_eng", "top_vdec", 8),
> +       /* VDE2_1 */
> +       GATE_VDE1(CLK_VDE2_LAT, "vde2_lat", "top_vdec", 0),
> +       /* VDE2_2 */
> +       GATE_VDE2(CLK_VDE2_LARB1, "vde2_larb1", "top_vdec", 0),
> +};
> +
> +static const struct mtk_clk_desc vde1_desc = {
> +       .clks = vde1_clks,
> +       .num_clks = ARRAY_SIZE(vde1_clks),
> +};
> +
> +static const struct mtk_clk_desc vde2_desc = {
> +       .clks = vde2_clks,
> +       .num_clks = ARRAY_SIZE(vde2_clks),
> +};
> +
> +static const struct of_device_id of_match_clk_mt8188_vde[] = {
> +       { .compatible = "mediatek,mt8188-vdecsys-soc", .data = &vde1_desc },
> +       { .compatible = "mediatek,mt8188-vdecsys", .data = &vde2_desc },
> +       { /* sentinel */ }
> +};
> +
> +static struct platform_driver clk_mt8188_vde_drv = {
> +       .probe = mtk_clk_simple_probe,
> +       .remove = mtk_clk_simple_remove,
> +       .driver = {
> +               .name = "clk-mt8188-vde",
> +               .of_match_table = of_match_clk_mt8188_vde,
> +       },
> +};
> +
> +builtin_platform_driver(clk_mt8188_vde_drv);
> +MODULE_LICENSE("GPL");
> --
> 2.18.0
>
>
