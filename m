Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F03B668973C
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 11:49:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232890AbjBCKtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 05:49:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231835AbjBCKtQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 05:49:16 -0500
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 055BDFF3D;
        Fri,  3 Feb 2023 02:49:14 -0800 (PST)
Received: from [192.168.1.100] (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: kholk11)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id A41A26602DD9;
        Fri,  3 Feb 2023 10:49:12 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1675421353;
        bh=OEAlKXvNZbN7zCP3R26EWPKYcVOYNKvfqjU+fbC8Rxk=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Ex4Gihtt0x0Mr8GaRT/cRrDvvvv79EE8h/QBWXa7GxQfagDXi19/r260L7hcuAhM1
         0Ub1fZhz0NjX/m6nxxoCV0CK67ZRDTaMbcUMDRM3KkmEzd515O3Hu8l+lY5HZfPJkz
         OlEXt5PYDIt1Ud12NTg2PChrFPsZmQpKZLWwltPZHRVSml8S0MuoEuIiFrzVp539pF
         5lJWOHEHjHsOavqRYXRVLm6Py/3SFi5wAMvEPHuV33dxxTa8WcQt9uSymA6zQpF6cO
         jB/+defNk0H4pRN3VDZ9tadpp8CiGjz3pWCs6rxrMOfFNl3VWZxMfzLOl8JmVz97Mg
         GuHZW44JsBqtA==
Message-ID: <76f33f1f-53ab-65a9-f6e8-23db4ca0e0b5@collabora.com>
Date:   Fri, 3 Feb 2023 11:49:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v5 12/19] clk: mediatek: Add MT8188 vdosys0 clock support
To:     Chen-Yu Tsai <wenst@chromium.org>,
        "Garmin.Chang" <Garmin.Chang@mediatek.com>
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
References: <20230119124848.26364-1-Garmin.Chang@mediatek.com>
 <20230119124848.26364-13-Garmin.Chang@mediatek.com>
 <CAGXv+5Fysy4iCvHEXWtf5oXCHkaKezPqcrGd8QzhnaTrYdyecA@mail.gmail.com>
Content-Language: en-US
From:   AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
In-Reply-To: <CAGXv+5Fysy4iCvHEXWtf5oXCHkaKezPqcrGd8QzhnaTrYdyecA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Il 03/02/23 08:19, Chen-Yu Tsai ha scritto:
> On Thu, Jan 19, 2023 at 8:54 PM Garmin.Chang <Garmin.Chang@mediatek.com> wrote:
>>
>> Add MT8188 vdosys0 clock controller which provides clock gate
>> control in video system. This is integrated with mtk-mmsys
>> driver which will populate device by platform_device_register_data
>> to start vdosys clock driver.
>>
>> Signed-off-by: Garmin.Chang <Garmin.Chang@mediatek.com>
>> ---
>>   drivers/clk/mediatek/Makefile          |   3 +-
>>   drivers/clk/mediatek/clk-mt8188-vdo0.c | 134 +++++++++++++++++++++++++
>>   2 files changed, 136 insertions(+), 1 deletion(-)
>>   create mode 100644 drivers/clk/mediatek/clk-mt8188-vdo0.c
>>
>> diff --git a/drivers/clk/mediatek/Makefile b/drivers/clk/mediatek/Makefile
>> index 7d09e9fc6538..df78c0777fef 100644
>> --- a/drivers/clk/mediatek/Makefile
>> +++ b/drivers/clk/mediatek/Makefile
>> @@ -86,7 +86,8 @@ obj-$(CONFIG_COMMON_CLK_MT8186) += clk-mt8186-mcu.o clk-mt8186-topckgen.o clk-mt
>>   obj-$(CONFIG_COMMON_CLK_MT8188) += clk-mt8188-apmixedsys.o clk-mt8188-topckgen.o \
>>                                     clk-mt8188-peri_ao.o clk-mt8188-infra_ao.o \
>>                                     clk-mt8188-cam.o clk-mt8188-ccu.o clk-mt8188-img.o \
>> -                                  clk-mt8188-ipe.o clk-mt8188-mfg.o clk-mt8188-vdec.o
>> +                                  clk-mt8188-ipe.o clk-mt8188-mfg.o clk-mt8188-vdec.o \
>> +                                  clk-mt8188-vdo0.o
>>   obj-$(CONFIG_COMMON_CLK_MT8192) += clk-mt8192.o
>>   obj-$(CONFIG_COMMON_CLK_MT8192_AUDSYS) += clk-mt8192-aud.o
>>   obj-$(CONFIG_COMMON_CLK_MT8192_CAMSYS) += clk-mt8192-cam.o
>> diff --git a/drivers/clk/mediatek/clk-mt8188-vdo0.c b/drivers/clk/mediatek/clk-mt8188-vdo0.c
>> new file mode 100644
>> index 000000000000..30dd64374ace
>> --- /dev/null
>> +++ b/drivers/clk/mediatek/clk-mt8188-vdo0.c
>> @@ -0,0 +1,134 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +//
>> +// Copyright (c) 2022 MediaTek Inc.
>> +// Author: Garmin Chang <garmin.chang@mediatek.com>
>> +
>> +#include <linux/clk-provider.h>
>> +#include <linux/platform_device.h>
>> +#include <dt-bindings/clock/mediatek,mt8188-clk.h>
>> +
>> +#include "clk-gate.h"
>> +#include "clk-mtk.h"
>> +
>> +static const struct mtk_gate_regs vdo0_0_cg_regs = {
>> +       .set_ofs = 0x104,
>> +       .clr_ofs = 0x108,
>> +       .sta_ofs = 0x100,
>> +};
>> +
>> +static const struct mtk_gate_regs vdo0_1_cg_regs = {
>> +       .set_ofs = 0x114,
>> +       .clr_ofs = 0x118,
>> +       .sta_ofs = 0x110,
>> +};
>> +
>> +static const struct mtk_gate_regs vdo0_2_cg_regs = {
>> +       .set_ofs = 0x124,
>> +       .clr_ofs = 0x128,
>> +       .sta_ofs = 0x120,
>> +};
>> +
>> +#define GATE_VDO0_0(_id, _name, _parent, _shift)                       \
>> +       GATE_MTK(_id, _name, _parent, &vdo0_0_cg_regs, _shift, &mtk_clk_gate_ops_setclr)
>> +
>> +#define GATE_VDO0_1(_id, _name, _parent, _shift)                       \
>> +       GATE_MTK(_id, _name, _parent, &vdo0_1_cg_regs, _shift, &mtk_clk_gate_ops_setclr)
>> +
>> +#define GATE_VDO0_2(_id, _name, _parent, _shift)                       \
>> +       GATE_MTK(_id, _name, _parent, &vdo0_2_cg_regs, _shift, &mtk_clk_gate_ops_setclr)
>> +
>> +#define GATE_VDO0_2_FLAGS(_id, _name, _parent, _shift, _flags)         \
>> +       GATE_MTK_FLAGS(_id, _name, _parent, &vdo0_2_cg_regs, _shift,    \
>> +       &mtk_clk_gate_ops_setclr, _flags)
>> +
>> +static const struct mtk_gate vdo0_clks[] = {
>> +       /* VDO0_0 */
>> +       GATE_VDO0_0(CLK_VDO0_DISP_OVL0, "vdo0_disp_ovl0", "top_vpp", 0),
>> +       GATE_VDO0_0(CLK_VDO0_FAKE_ENG0, "vdo0_fake_eng0", "top_vpp", 2),
>> +       GATE_VDO0_0(CLK_VDO0_DISP_CCORR0, "vdo0_disp_ccorr0", "top_vpp", 4),
>> +       GATE_VDO0_0(CLK_VDO0_DISP_MUTEX0, "vdo0_disp_mutex0", "top_vpp", 6),
>> +       GATE_VDO0_0(CLK_VDO0_DISP_GAMMA0, "vdo0_disp_gamma0", "top_vpp", 8),
>> +       GATE_VDO0_0(CLK_VDO0_DISP_DITHER0, "vdo0_disp_dither0", "top_vpp", 10),
>> +       GATE_VDO0_0(CLK_VDO0_DISP_WDMA0, "vdo0_disp_wdma0", "top_vpp", 17),
>> +       GATE_VDO0_0(CLK_VDO0_DISP_RDMA0, "vdo0_disp_rdma0", "top_vpp", 19),
>> +       GATE_VDO0_0(CLK_VDO0_DSI0, "vdo0_dsi0", "top_vpp", 21),
>> +       GATE_VDO0_0(CLK_VDO0_DSI1, "vdo0_dsi1", "top_vpp", 22),
>> +       GATE_VDO0_0(CLK_VDO0_DSC_WRAP0, "vdo0_dsc_wrap0", "top_vpp", 23),
>> +       GATE_VDO0_0(CLK_VDO0_VPP_MERGE0, "vdo0_vpp_merge0", "top_vpp", 24),
>> +       GATE_VDO0_0(CLK_VDO0_DP_INTF0, "vdo0_dp_intf0", "top_vpp", 25),
>> +       GATE_VDO0_0(CLK_VDO0_DISP_AAL0, "vdo0_disp_aal0", "top_vpp", 26),
>> +       GATE_VDO0_0(CLK_VDO0_INLINEROT0, "vdo0_inlinerot0", "top_vpp", 27),
>> +       GATE_VDO0_0(CLK_VDO0_APB_BUS, "vdo0_apb_bus", "top_vpp", 28),
>> +       GATE_VDO0_0(CLK_VDO0_DISP_COLOR0, "vdo0_disp_color0", "top_vpp", 29),
>> +       GATE_VDO0_0(CLK_VDO0_MDP_WROT0, "vdo0_mdp_wrot0", "top_vpp", 30),
>> +       GATE_VDO0_0(CLK_VDO0_DISP_RSZ0, "vdo0_disp_rsz0", "top_vpp", 31),
>> +       /* VDO0_1 */
>> +       GATE_VDO0_1(CLK_VDO0_DISP_POSTMASK0, "vdo0_disp_postmask0", "top_vpp", 0),
>> +       GATE_VDO0_1(CLK_VDO0_FAKE_ENG1, "vdo0_fake_eng1", "top_vpp", 1),
>> +       GATE_VDO0_1(CLK_VDO0_DL_ASYNC2, "vdo0_dl_async2", "top_vpp", 5),
>> +       GATE_VDO0_1(CLK_VDO0_DL_RELAY3, "vdo0_dl_relay3", "top_vpp", 6),
>> +       GATE_VDO0_1(CLK_VDO0_DL_RELAY4, "vdo0_dl_relay4", "top_vpp", 7),
>> +       GATE_VDO0_1(CLK_VDO0_SMI_GALS, "vdo0_smi_gals", "top_vpp", 10),
>> +       GATE_VDO0_1(CLK_VDO0_SMI_COMMON, "vdo0_smi_common", "top_vpp", 11),
>> +       GATE_VDO0_1(CLK_VDO0_SMI_EMI, "vdo0_smi_emi", "top_vpp", 12),
>> +       GATE_VDO0_1(CLK_VDO0_SMI_IOMMU, "vdo0_smi_iommu", "top_vpp", 13),
>> +       GATE_VDO0_1(CLK_VDO0_SMI_LARB, "vdo0_smi_larb", "top_vpp", 14),
>> +       GATE_VDO0_1(CLK_VDO0_SMI_RSI, "vdo0_smi_rsi", "top_vpp", 15),
>> +       /* VDO0_2 */
>> +       GATE_VDO0_2(CLK_VDO0_DSI0_DSI, "vdo0_dsi0_dsi", "top_dsi_occ", 0),
>> +       GATE_VDO0_2(CLK_VDO0_DSI1_DSI, "vdo0_dsi1_dsi", "top_dsi_occ", 8),
>> +       GATE_VDO0_2_FLAGS(CLK_VDO0_DP_INTF0_DP_INTF, "vdo0_dp_intf0_dp_intf",
>> +               "top_edp", 16, CLK_SET_RATE_PARENT),
>> +};
>> +
>> +static int clk_mt8188_vdo0_probe(struct platform_device *pdev)
>> +{
>> +       struct device *dev = &pdev->dev;
>> +       struct device_node *node = dev->parent->of_node;
>> +       struct clk_hw_onecell_data *clk_data;
>> +       int r;
>> +
>> +       clk_data = mtk_alloc_clk_data(CLK_VDO0_NR_CLK);
>> +       if (!clk_data)
>> +               return -ENOMEM;
>> +
>> +       r = mtk_clk_register_gates(node, vdo0_clks, ARRAY_SIZE(vdo0_clks), clk_data);
> 
> This API was changed. Please rebase onto the latest -next and update.
> 
> Angelo (CC-ed) also mentioned a new simple probe variant for non-DT
> clock drivers is being developed. He didn't mention a timeline though.

I've already tested the new simple probe variant for non-DT clock drivers and
it works fine on MT8173, MT8192 and MT8195.

Timeline - I should be able to push the part 2 series next week, which will include
more conversion to simple probe and almost all clock drivers changed to allow
building as modules.

Cheers,
Angelo

