Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D05C5BC5E2
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 11:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbiISJ4s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 05:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230098AbiISJ4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 05:56:45 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE7A30B;
        Mon, 19 Sep 2022 02:56:37 -0700 (PDT)
X-UUID: 101d3b21a1dc457199d685683f194011-20220919
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=dPMTiREpH/Df3NZCKHTlKTh2R54/xEmjH9I8g+NM+/4=;
        b=KE0V/xRyxbGADXlo3T21L8BshSv1CfdKR5VJRseYYDa4VRdcgdwxJryrF8WI9mAPfbKjzSJXhHAB9ZRxJzVJ6MmJKSBMGRepnJYO6uAVf7rW1NPhRmNqp54v5PCjguDf5Pz/qLba533JCqcNGGWC7EBiQqgwwDPfi8AGWf5Y+Mk=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.11,REQID:5b87dbec-6f38-4589-8e94-6d8670d076a5,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:22,FILE:0,BULK:0,RULE:Release_Ham,ACTION
        :release,TS:22
X-CID-INFO: VERSION:1.1.11,REQID:5b87dbec-6f38-4589-8e94-6d8670d076a5,IP:0,URL
        :0,TC:0,Content:0,EDM:0,RT:0,SF:22,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
        elease,TS:22
X-CID-META: VersionHash:39a5ff1,CLOUDID:915bdc18-0314-4ae7-b2d1-7295be49255e,B
        ulkID:220919161938HV8SMIES,BulkQuantity:277,Recheck:0,SF:28|100|17|19|48|1
        01|823|824,TC:nil,Content:0,EDM:-3,IP:nil,URL:0,File:nil,Bulk:40,QS:nil,BE
        C:nil,COL:0
X-UUID: 101d3b21a1dc457199d685683f194011-20220919
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw01.mediatek.com
        (envelope-from <jianguo.zhang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1207044010; Mon, 19 Sep 2022 17:56:33 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Mon, 19 Sep 2022 17:56:31 +0800
Received: from mhfsdcap04 (10.17.3.154) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 19 Sep 2022 17:56:31 +0800
Message-ID: <f72e133e9aec70724702054e5f6a8712b649d34f.camel@mediatek.com>
Subject: Re: [PATCH 1/2] stmmac: dwmac-mediatek: add support for mt8188
From:   Jianguo Zhang <jianguo.zhang@mediatek.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>
CC:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "Biao Huang" <biao.huang@mediatek.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>
Date:   Mon, 19 Sep 2022 17:56:30 +0800
In-Reply-To: <88412fcc-96be-cd9d-8805-086c7f09c03b@linaro.org>
References: <20220919080410.11270-1-jianguo.zhang@mediatek.com>
         <20220919080410.11270-2-jianguo.zhang@mediatek.com>
         <d28ce676-ed6e-98da-9761-ed46f2fa4a95@linaro.org>
         <4c537b63f609ae974dfb468ebc31225d45f785e8.camel@mediatek.com>
         <88412fcc-96be-cd9d-8805-086c7f09c03b@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-MTK:  N
X-Spam-Status: No, score=-0.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,MAY_BE_FORGED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        T_SPF_TEMPERROR,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Krzysztof,

On Mon, 2022-09-19 at 11:27 +0200, Krzysztof Kozlowski wrote:
> On 19/09/2022 10:37, Jianguo Zhang wrote:
> > Dear Krzysztof,
> > 
> > 	Thanks for your comments.
> > 
> > 
> > On Mon, 2022-09-19 at 10:19 +0200, Krzysztof Kozlowski wrote:
> > > On 19/09/2022 10:04, Jianguo Zhang wrote:
> > > > Add ethernet support for MediaTek SoCs from mt8188 family.
> > > > As mt8188 and mt8195 have same ethernet design, so private data
> > > > "mt8195_gmac_variant" can be reused for mt8188.
> > > > 
> > > > Signed-off-by: Jianguo Zhang <jianguo.zhang@mediatek.com>
> > > > ---
> > > >  drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c | 2 ++
> > > >  1 file changed, 2 insertions(+)
> > > > 
> > > > diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-
> > > > mediatek.c
> > > > b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
> > > > index d42e1afb6521..f45be440b6d0 100644
> > > > --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
> > > > +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
> > > > @@ -720,6 +720,8 @@ static const struct of_device_id
> > > > mediatek_dwmac_match[] = {
> > > >  	  .data = &mt2712_gmac_variant },
> > > >  	{ .compatible = "mediatek,mt8195-gmac",
> > > >  	  .data = &mt8195_gmac_variant },
> > > > +	{ .compatible = "mediatek,mt8188-gmac",
> > > > +	  .data = &mt8195_gmac_variant },
> > > 
> > > It's the same. No need for new entry.
> > > 
> > 
> > mt8188 and mt8195 are different SoCs and we need to distinguish
> > mt8188
> > from mt8195, so I think a new entry is needed for mt8188 with the
> > specific "compatiable".
> 
> No, this does not justify new entry. You need specific compatible,
> but
> not new entry.
> 
> > On the other hand, mt8188 and mt8195 have same ethernet design, so
> > the
> > private data "mt8195_gmac_variant" can be resued to reduce
> > redundant
> > info in driver.
> 
> And you do not need new entry in the driver.
Do you mean that I can use "mediatek,mt8195-gmac" as compatible for
ethernet in mt8188 DTS file?
> 
> Best regards,
> Krzysztof

BRS
Jianguo

