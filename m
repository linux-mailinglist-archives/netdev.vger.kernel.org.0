Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 417E56890F6
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 08:36:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbjBCHfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 02:35:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232102AbjBCHfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 02:35:38 -0500
Received: from mail-vk1-xa2d.google.com (mail-vk1-xa2d.google.com [IPv6:2607:f8b0:4864:20::a2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5004993AC7
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 23:35:32 -0800 (PST)
Received: by mail-vk1-xa2d.google.com with SMTP id s76so2145459vkb.9
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 23:35:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=AkKgrxVtZhQxSONi4mk383sSipaazdfy79UZwbu7LCA=;
        b=YaqaCciX+IQ7qb0JPqPL3F+olVqEx+rL8hmTtZvnveB/Z8JalKdSfRUj3PXehcPsjU
         ynh8xrrJXJH1Bo6LpaBCQDCv8+uE517ODLWpmqxqIQyJbF2ZOka159q3R0wsMwPaVQwb
         shkvQdaPVnxzLpEpS4UHk33pATTucXUJAzngc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AkKgrxVtZhQxSONi4mk383sSipaazdfy79UZwbu7LCA=;
        b=VZyTns7k9FvRlf+tV7yfTkSHhuyk1h4/88RGgbL+QdeW8P23SPF00bYwYS6kRSJ9iv
         JcgDHK+P0FJHX9SuuHFqRZQc48oiebRFO4bS/uSI/Qsf57y4vTBG3muMmvwk4sv5CxWc
         AQ0G4sUz6UWTnEYIitx0+2V3FFSP2bvNnjMv23kcxT0vWInjR5bQdDGvjoGdh26CupXu
         B6J7vCPRlOpxbAr1PsezUaHNv+e2j8IcYNl9SKcXKADIT6/YNz1qcM7U/iI86GTB/cIA
         YJLIYeQL6h0I7gyeEsq0Yz6VwiuanYTAC7pFY6RN0bzcbpkkfFXFT3+1NrDd8J9UTdfR
         1Omw==
X-Gm-Message-State: AO0yUKVXl6tUUmGTAi0ZeRnHQqnHmiWQ0w/uXwaGiDmkBsNbTclQS+KM
        XcxWJwkPzFqvfPwOcjpdQa4pdNNuTVQ1tiUSPJVTcg==
X-Google-Smtp-Source: AK7set+ydZo1xK08XzQiIdVMXeF86jeg+nEbaJ0PaU5MCzigQQoRvVh26Hknwek82Mxaj2Vv6qoXoTbhzZr2fHGzv9E=
X-Received: by 2002:a05:6122:131:b0:3e8:8f:f3a7 with SMTP id
 a17-20020a056122013100b003e8008ff3a7mr1333466vko.30.1675409731381; Thu, 02
 Feb 2023 23:35:31 -0800 (PST)
MIME-Version: 1.0
References: <20230119124848.26364-1-Garmin.Chang@mediatek.com> <20230119124848.26364-17-Garmin.Chang@mediatek.com>
In-Reply-To: <20230119124848.26364-17-Garmin.Chang@mediatek.com>
From:   Chen-Yu Tsai <wenst@chromium.org>
Date:   Fri, 3 Feb 2023 15:35:20 +0800
Message-ID: <CAGXv+5HD9PaCAJ-R8dmTkKV_-kc3+wvkZaAKPtcgmVZVqz7KhQ@mail.gmail.com>
Subject: Re: [PATCH v5 16/19] clk: mediatek: Add MT8188 vppsys1 clock support
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

On Thu, Jan 19, 2023 at 8:58 PM Garmin.Chang <Garmin.Chang@mediatek.com> wrote:
>
> Add MT8188 vppsys1 clock controller which provides clock gate
> controller for Video Processor Pipe.
>
> Signed-off-by: Garmin.Chang <Garmin.Chang@mediatek.com>
> ---
>  drivers/clk/mediatek/Makefile          |   2 +-
>  drivers/clk/mediatek/clk-mt8188-vpp1.c | 138 +++++++++++++++++++++++++
>  2 files changed, 139 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/clk/mediatek/clk-mt8188-vpp1.c
>
> diff --git a/drivers/clk/mediatek/Makefile b/drivers/clk/mediatek/Makefile
> index 48deecc6b520..37663de293bf 100644
> --- a/drivers/clk/mediatek/Makefile
> +++ b/drivers/clk/mediatek/Makefile
> @@ -88,7 +88,7 @@ obj-$(CONFIG_COMMON_CLK_MT8188) += clk-mt8188-apmixedsys.o clk-mt8188-topckgen.o
>                                    clk-mt8188-cam.o clk-mt8188-ccu.o clk-mt8188-img.o \
>                                    clk-mt8188-ipe.o clk-mt8188-mfg.o clk-mt8188-vdec.o \
>                                    clk-mt8188-vdo0.o clk-mt8188-vdo1.o clk-mt8188-venc.o \
> -                                  clk-mt8188-vpp0.o
> +                                  clk-mt8188-vpp0.o clk-mt8188-vpp1.o
>  obj-$(CONFIG_COMMON_CLK_MT8192) += clk-mt8192.o
>  obj-$(CONFIG_COMMON_CLK_MT8192_AUDSYS) += clk-mt8192-aud.o
>  obj-$(CONFIG_COMMON_CLK_MT8192_CAMSYS) += clk-mt8192-cam.o
> diff --git a/drivers/clk/mediatek/clk-mt8188-vpp1.c b/drivers/clk/mediatek/clk-mt8188-vpp1.c
> new file mode 100644
> index 000000000000..2bff3a52c93f
> --- /dev/null
> +++ b/drivers/clk/mediatek/clk-mt8188-vpp1.c
> @@ -0,0 +1,138 @@
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
> +static const struct mtk_gate_regs vpp1_0_cg_regs = {
> +       .set_ofs = 0x104,
> +       .clr_ofs = 0x108,
> +       .sta_ofs = 0x100,
> +};
> +
> +static const struct mtk_gate_regs vpp1_1_cg_regs = {
> +       .set_ofs = 0x114,
> +       .clr_ofs = 0x118,
> +       .sta_ofs = 0x110,
> +};
> +
> +#define GATE_VPP1_0(_id, _name, _parent, _shift)                       \
> +       GATE_MTK(_id, _name, _parent, &vpp1_0_cg_regs, _shift, &mtk_clk_gate_ops_setclr)
> +
> +#define GATE_VPP1_1(_id, _name, _parent, _shift)                       \
> +       GATE_MTK(_id, _name, _parent, &vpp1_1_cg_regs, _shift, &mtk_clk_gate_ops_setclr)
> +
> +static const struct mtk_gate vpp1_clks[] = {
> +       /* VPP1_0 */
> +       GATE_VPP1_0(CLK_VPP1_SVPP1_MDP_OVL, "vpp1_svpp1_mdp_ovl", "top_vpp", 0),
> +       GATE_VPP1_0(CLK_VPP1_SVPP1_MDP_TCC, "vpp1_svpp1_mdp_tcc", "top_vpp", 1),
> +       GATE_VPP1_0(CLK_VPP1_SVPP1_MDP_WROT, "vpp1_svpp1_mdp_wrot", "top_vpp", 2),
> +       GATE_VPP1_0(CLK_VPP1_SVPP1_VPP_PAD, "vpp1_svpp1_vpp_pad", "top_vpp", 3),
> +       GATE_VPP1_0(CLK_VPP1_SVPP2_MDP_WROT, "vpp1_svpp2_mdp_wrot", "top_vpp", 4),
> +       GATE_VPP1_0(CLK_VPP1_SVPP2_VPP_PAD, "vpp1_svpp2_vpp_pad", "top_vpp", 5),
> +       GATE_VPP1_0(CLK_VPP1_SVPP3_MDP_WROT, "vpp1_svpp3_mdp_wrot", "top_vpp", 6),
> +       GATE_VPP1_0(CLK_VPP1_SVPP3_VPP_PAD, "vpp1_svpp3_vpp_pad", "top_vpp", 7),
> +       GATE_VPP1_0(CLK_VPP1_SVPP1_MDP_RDMA, "vpp1_svpp1_mdp_rdma", "top_vpp", 8),
> +       GATE_VPP1_0(CLK_VPP1_SVPP1_MDP_FG, "vpp1_svpp1_mdp_fg", "top_vpp", 9),
> +       GATE_VPP1_0(CLK_VPP1_SVPP2_MDP_RDMA, "vpp1_svpp2_mdp_rdma", "top_vpp", 10),
> +       GATE_VPP1_0(CLK_VPP1_SVPP2_MDP_FG, "vpp1_svpp2_mdp_fg", "top_vpp", 11),
> +       GATE_VPP1_0(CLK_VPP1_SVPP3_MDP_RDMA, "vpp1_svpp3_mdp_rdma", "top_vpp", 12),
> +       GATE_VPP1_0(CLK_VPP1_SVPP3_MDP_FG, "vpp1_svpp3_mdp_fg", "top_vpp", 13),
> +       GATE_VPP1_0(CLK_VPP1_VPP_SPLIT, "vpp1_vpp_split", "top_vpp", 14),
> +       GATE_VPP1_0(CLK_VPP1_SVPP2_VDO0_DL_RELAY, "vpp1_svpp2_vdo0_dl_relay", "top_vpp", 15),
> +       GATE_VPP1_0(CLK_VPP1_SVPP1_MDP_RSZ, "vpp1_svpp1_mdp_rsz", "top_vpp", 16),
> +       GATE_VPP1_0(CLK_VPP1_SVPP1_MDP_TDSHP, "vpp1_svpp1_mdp_tdshp", "top_vpp", 17),
> +       GATE_VPP1_0(CLK_VPP1_SVPP1_MDP_COLOR, "vpp1_svpp1_mdp_color", "top_vpp", 18),
> +       GATE_VPP1_0(CLK_VPP1_SVPP3_VDO1_DL_RELAY, "vpp1_svpp3_vdo1_dl_relay", "top_vpp", 19),
> +       GATE_VPP1_0(CLK_VPP1_SVPP2_MDP_RSZ, "vpp1_svpp2_mdp_rsz", "top_vpp", 20),
> +       GATE_VPP1_0(CLK_VPP1_SVPP2_VPP_MERGE, "vpp1_svpp2_vpp_merge", "top_vpp", 21),
> +       GATE_VPP1_0(CLK_VPP1_SVPP2_MDP_TDSHP, "vpp1_svpp2_mdp_tdshp", "top_vpp", 22),
> +       GATE_VPP1_0(CLK_VPP1_SVPP2_MDP_COLOR, "vpp1_svpp2_mdp_color", "top_vpp", 23),
> +       GATE_VPP1_0(CLK_VPP1_SVPP3_MDP_RSZ, "vpp1_svpp3_mdp_rsz", "top_vpp", 24),
> +       GATE_VPP1_0(CLK_VPP1_SVPP3_VPP_MERGE, "vpp1_svpp3_vpp_merge", "top_vpp", 25),
> +       GATE_VPP1_0(CLK_VPP1_SVPP3_MDP_TDSHP, "vpp1_svpp3_mdp_tdshp", "top_vpp", 26),
> +       GATE_VPP1_0(CLK_VPP1_SVPP3_MDP_COLOR, "vpp1_svpp3_mdp_color", "top_vpp", 27),
> +       GATE_VPP1_0(CLK_VPP1_GALS5, "vpp1_gals5", "top_vpp", 28),
> +       GATE_VPP1_0(CLK_VPP1_GALS6, "vpp1_gals6", "top_vpp", 29),
> +       GATE_VPP1_0(CLK_VPP1_LARB5, "vpp1_larb5", "top_vpp", 30),
> +       GATE_VPP1_0(CLK_VPP1_LARB6, "vpp1_larb6", "top_vpp", 31),
> +       /* VPP1_1 */
> +       GATE_VPP1_1(CLK_VPP1_SVPP1_MDP_HDR, "vpp1_svpp1_mdp_hdr", "top_vpp", 0),
> +       GATE_VPP1_1(CLK_VPP1_SVPP1_MDP_AAL, "vpp1_svpp1_mdp_aal", "top_vpp", 1),
> +       GATE_VPP1_1(CLK_VPP1_SVPP2_MDP_HDR, "vpp1_svpp2_mdp_hdr", "top_vpp", 2),
> +       GATE_VPP1_1(CLK_VPP1_SVPP2_MDP_AAL, "vpp1_svpp2_mdp_aal", "top_vpp", 3),
> +       GATE_VPP1_1(CLK_VPP1_SVPP3_MDP_HDR, "vpp1_svpp3_mdp_hdr", "top_vpp", 4),
> +       GATE_VPP1_1(CLK_VPP1_SVPP3_MDP_AAL, "vpp1_svpp3_mdp_aal", "top_vpp", 5),
> +       GATE_VPP1_1(CLK_VPP1_DISP_MUTEX, "vpp1_disp_mutex", "top_vpp", 7),
> +       GATE_VPP1_1(CLK_VPP1_SVPP2_VDO1_DL_RELAY, "vpp1_svpp2_vdo1_dl_relay", "top_vpp", 8),
> +       GATE_VPP1_1(CLK_VPP1_SVPP3_VDO0_DL_RELAY, "vpp1_svpp3_vdo0_dl_relay", "top_vpp", 9),
> +       GATE_VPP1_1(CLK_VPP1_VPP0_DL_ASYNC, "vpp1_vpp0_dl_async", "top_vpp", 10),
> +       GATE_VPP1_1(CLK_VPP1_VPP0_DL1_RELAY, "vpp1_vpp0_dl1_relay", "top_vpp", 11),
> +       GATE_VPP1_1(CLK_VPP1_LARB5_FAKE_ENG, "vpp1_larb5_fake_eng", "top_vpp", 12),
> +       GATE_VPP1_1(CLK_VPP1_LARB6_FAKE_ENG, "vpp1_larb6_fake_eng", "top_vpp", 13),
> +       GATE_VPP1_1(CLK_VPP1_HDMI_META, "vpp1_hdmi_meta", "top_vpp", 16),
> +       GATE_VPP1_1(CLK_VPP1_VPP_SPLIT_HDMI, "vpp1_vpp_split_hdmi", "top_vpp", 17),
> +       GATE_VPP1_1(CLK_VPP1_DGI_IN, "vpp1_dgi_in", "top_vpp", 18),
> +       GATE_VPP1_1(CLK_VPP1_DGI_OUT, "vpp1_dgi_out", "top_vpp", 19),
> +       GATE_VPP1_1(CLK_VPP1_VPP_SPLIT_DGI, "vpp1_vpp_split_dgi", "top_vpp", 20),
> +       GATE_VPP1_1(CLK_VPP1_DL_CON_OCC, "vpp1_dl_con_occ", "top_vpp", 21),
> +       GATE_VPP1_1(CLK_VPP1_VPP_SPLIT_26M, "vpp1_vpp_split_26m", "top_vpp", 26),
> +};
> +
> +static int clk_mt8188_vpp1_probe(struct platform_device *pdev)
> +{
> +       struct device *dev = &pdev->dev;
> +       struct device_node *node = dev->parent->of_node;
> +       struct clk_hw_onecell_data *clk_data;
> +       int r;
> +
> +       clk_data = mtk_alloc_clk_data(CLK_VPP1_NR_CLK);
> +       if (!clk_data)
> +               return -ENOMEM;
> +
> +       r = mtk_clk_register_gates(node, vpp1_clks, ARRAY_SIZE(vpp1_clks), clk_data);

Same here. Please update.

Once fixed,

Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
