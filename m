Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B15B689007
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 08:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231903AbjBCHDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 02:03:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231261AbjBCHDK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 02:03:10 -0500
Received: from mail-vk1-xa29.google.com (mail-vk1-xa29.google.com [IPv6:2607:f8b0:4864:20::a29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DD26911AD
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 23:02:33 -0800 (PST)
Received: by mail-vk1-xa29.google.com with SMTP id 6so2126316vko.7
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 23:02:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZHxnq4NIAvqcaAQqKPv9unLZ6dk9i+ul3lPvliSm8to=;
        b=i+piRv4aM1OJLjMLD6b35atiMLDBkWlgdjMTQx2ceBe7f2oj2MubVl2GOeYz8svWBL
         JCj0B5LIykOnqKn1Xzvx0lbNKW5MiDYo4R6gEjjpfX9UxpMYpTu3fny1wERq2gd70BU+
         wy/PsccjJ2lZMarPhrYApiZegzi/vuPR6d/r0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZHxnq4NIAvqcaAQqKPv9unLZ6dk9i+ul3lPvliSm8to=;
        b=wJ5p9+pA/C3L+1alye88b2Pn71bFv+NuZKnV6hFwEakeD0sGA+G0U/zn+TKAShnHH6
         gdMpmCCXynJBDG3FVDphyG5A0d0wEvL6GsaJgfEwiz5f75Eq72gM8QOU7EDSU2mDwm8M
         kAUcH87HzD+VzwNploX8kHfTMRLTErgGpP7+Rzxfir/67D37mGZcZtZ2u/kCbhvQS0vw
         OXlPUfb4tSK+I7pugTdDe2vqu0DooUIpZmfSs/R65IuKSxmXJg0YDIjysXluaOU+1hWE
         ijFnTX7mhwlzeeKciK29EtoawjWRjIGgksDxefNZ5/KIMMdqZS7i3ZPXuuZazmz066zC
         JTJw==
X-Gm-Message-State: AO0yUKXPwNs7HngbIYKsxvRrBADtPbjOWQB1KT4IrGRBCCKF+HvnBO0k
        ba2e4soLXcyp0EEpXOGZZ7DkJulNkwAASC81ht/Xrg==
X-Google-Smtp-Source: AK7set+aTOijar/puEUL78ABZvo/AOqIKUR8h1vEUaV4Q1CRoGlXDNr1x4ZpVZTctOHPDyk/5tzwRCQVHGrQ0dN6omE=
X-Received: by 2002:a05:6122:131:b0:3e8:8f:f3a7 with SMTP id
 a17-20020a056122013100b003e8008ff3a7mr1321932vko.30.1675407752112; Thu, 02
 Feb 2023 23:02:32 -0800 (PST)
MIME-Version: 1.0
References: <20230119124848.26364-1-Garmin.Chang@mediatek.com> <20230119124848.26364-11-Garmin.Chang@mediatek.com>
In-Reply-To: <20230119124848.26364-11-Garmin.Chang@mediatek.com>
From:   Chen-Yu Tsai <wenst@chromium.org>
Date:   Fri, 3 Feb 2023 15:02:21 +0800
Message-ID: <CAGXv+5FGCVSihGu5diCQ1Q=jPRHz7RQ2KrXk-13LL4z1wbkfjg@mail.gmail.com>
Subject: Re: [PATCH v5 10/19] clk: mediatek: Add MT8188 mfgcfg clock support
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

On Thu, Jan 19, 2023 at 8:50 PM Garmin.Chang <Garmin.Chang@mediatek.com> wrote:
>
> Add MT8188 mfg clock controller which provides clock gate
> control for GPU.
>
> Signed-off-by: Garmin.Chang <Garmin.Chang@mediatek.com>
> ---
>  drivers/clk/mediatek/Makefile         |  2 +-
>  drivers/clk/mediatek/clk-mt8188-mfg.c | 47 +++++++++++++++++++++++++++
>  2 files changed, 48 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/clk/mediatek/clk-mt8188-mfg.c
>
> diff --git a/drivers/clk/mediatek/Makefile b/drivers/clk/mediatek/Makefile
> index 4a599122f761..a0fd87a882b5 100644
> --- a/drivers/clk/mediatek/Makefile
> +++ b/drivers/clk/mediatek/Makefile
> @@ -86,7 +86,7 @@ obj-$(CONFIG_COMMON_CLK_MT8186) += clk-mt8186-mcu.o clk-mt8186-topckgen.o clk-mt
>  obj-$(CONFIG_COMMON_CLK_MT8188) += clk-mt8188-apmixedsys.o clk-mt8188-topckgen.o \
>                                    clk-mt8188-peri_ao.o clk-mt8188-infra_ao.o \
>                                    clk-mt8188-cam.o clk-mt8188-ccu.o clk-mt8188-img.o \
> -                                  clk-mt8188-ipe.o
> +                                  clk-mt8188-ipe.o clk-mt8188-mfg.o
>  obj-$(CONFIG_COMMON_CLK_MT8192) += clk-mt8192.o
>  obj-$(CONFIG_COMMON_CLK_MT8192_AUDSYS) += clk-mt8192-aud.o
>  obj-$(CONFIG_COMMON_CLK_MT8192_CAMSYS) += clk-mt8192-cam.o
> diff --git a/drivers/clk/mediatek/clk-mt8188-mfg.c b/drivers/clk/mediatek/clk-mt8188-mfg.c
> new file mode 100644
> index 000000000000..57b0afb5f4df
> --- /dev/null
> +++ b/drivers/clk/mediatek/clk-mt8188-mfg.c
> @@ -0,0 +1,47 @@
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
> +static const struct mtk_gate_regs mfgcfg_cg_regs = {
> +       .set_ofs = 0x4,
> +       .clr_ofs = 0x8,
> +       .sta_ofs = 0x0,
> +};
> +
> +#define GATE_MFG(_id, _name, _parent, _shift)                          \
> +       GATE_MTK_FLAGS(_id, _name, _parent, &mfgcfg_cg_regs, _shift,    \
> +                      &mtk_clk_gate_ops_setclr, CLK_SET_RATE_PARENT)
> +
> +static const struct mtk_gate mfgcfg_clks[] = {
> +       GATE_MFG(CLK_MFGCFG_BG3D, "mfgcfg_bg3d", "top_mfg_core_tmp", 0),

Are you sure the parent isn't "mfg_ck_fast_ref"?

ChenYu
