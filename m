Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 969E15BDA2A
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 04:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbiITCdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 22:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiITCdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 22:33:22 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFDD25727D;
        Mon, 19 Sep 2022 19:33:13 -0700 (PDT)
X-UUID: f3b6d518f97e4a13a09733edc49a259b-20220920
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=t2S3HXzQLfmjdW8BymUDlC5D8EiXYe43lcRmSAgqZFE=;
        b=pS0GVsS0y0ICPgIcK0uLVFHXY64eh8VvmrXJiU+tCEX56//YEGnq+clhfQgCx07WQ/1NkEWtinThnXtkbG5A1k2MzrMEeOOTle0f+4v5nOPkeV1EzKV7k8SnUCIAWIj/L/VzPj5lejI66ayMdLE16hbAzslQq3j8kPiRhhQCk28=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.11,REQID:292d0791-03e7-42f7-b45b-2a16da7e7d47,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:22,FILE:0,BULK:0,RULE:Release_Ham,ACTION
        :release,TS:22
X-CID-INFO: VERSION:1.1.11,REQID:292d0791-03e7-42f7-b45b-2a16da7e7d47,IP:0,URL
        :0,TC:0,Content:0,EDM:0,RT:0,SF:22,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
        elease,TS:22
X-CID-META: VersionHash:39a5ff1,CLOUDID:fcb8355e-5ed4-4e28-8b00-66ed9f042fbd,B
        ulkID:220919161938HV8SMIES,BulkQuantity:416,Recheck:0,SF:28|100|17|19|48|1
        01|823|824,TC:nil,Content:0,EDM:-3,IP:nil,URL:0,File:nil,Bulk:40,QS:nil,BE
        C:nil,COL:0
X-UUID: f3b6d518f97e4a13a09733edc49a259b-20220920
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <jianguo.zhang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 526819015; Tue, 20 Sep 2022 10:33:09 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Tue, 20 Sep 2022 10:33:08 +0800
Received: from mhfsdcap04 (10.17.3.154) by mtkmbs11n2.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.792.15 via Frontend
 Transport; Tue, 20 Sep 2022 10:33:07 +0800
Message-ID: <20c47bd6742c08912c7b35e75c032c5b853fccde.camel@mediatek.com>
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
Date:   Tue, 20 Sep 2022 10:33:07 +0800
In-Reply-To: <b343e4c7-a247-28b8-3d16-cb7cea7ba36b@linaro.org>
References: <20220919080410.11270-1-jianguo.zhang@mediatek.com>
         <20220919080410.11270-2-jianguo.zhang@mediatek.com>
         <d28ce676-ed6e-98da-9761-ed46f2fa4a95@linaro.org>
         <4c537b63f609ae974dfb468ebc31225d45f785e8.camel@mediatek.com>
         <88412fcc-96be-cd9d-8805-086c7f09c03b@linaro.org>
         <f72e133e9aec70724702054e5f6a8712b649d34f.camel@mediatek.com>
         <b343e4c7-a247-28b8-3d16-cb7cea7ba36b@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-MTK:  N
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
        URIBL_CSS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Krzysztof,

	Thanks for your comment.

On Mon, 2022-09-19 at 12:06 +0200, Krzysztof Kozlowski wrote:
> On 19/09/2022 11:56, Jianguo Zhang wrote:
> > > No, this does not justify new entry. You need specific
> > > compatible,
> > > but
> > > not new entry.
> > > 
> > > > On the other hand, mt8188 and mt8195 have same ethernet design,
> > > > so
> > > > the
> > > > private data "mt8195_gmac_variant" can be resued to reduce
> > > > redundant
> > > > info in driver.
> > > 
> > > And you do not need new entry in the driver.
> > 
> > Do you mean that I can use "mediatek,mt8195-gmac" as compatible for
> > ethernet in mt8188 DTS file?
> 
> Yes, as a fallback. Example schema describes such case.
> 
OK, we will drop the changes in patch #1 and add MT8188 related info in
binding document in next version patches.
> Best regards,
> Krzysztof
> 
BRS
Jianguo

