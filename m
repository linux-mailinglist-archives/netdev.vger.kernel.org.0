Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9B456B5E6
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 11:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237400AbiGHJqd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 05:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237111AbiGHJqc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 05:46:32 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 441C3796A6;
        Fri,  8 Jul 2022 02:46:26 -0700 (PDT)
X-UUID: f445e572e15c473aae8bf64039675d76-20220708
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.8,REQID:21ced59d-68bc-48e8-967d-0ed1acd4328b,OB:10,L
        OB:10,IP:0,URL:0,TC:0,Content:0,EDM:0,RT:0,SF:51,FILE:0,RULE:Release_Ham,A
        CTION:release,TS:51
X-CID-INFO: VERSION:1.1.8,REQID:21ced59d-68bc-48e8-967d-0ed1acd4328b,OB:10,LOB
        :10,IP:0,URL:0,TC:0,Content:0,EDM:0,RT:0,SF:51,FILE:0,RULE:Release_Ham,ACT
        ION:release,TS:51
X-CID-META: VersionHash:0f94e32,CLOUDID:bfd0f7d6-5d6d-4eaf-a635-828a3ee48b7c,C
        OID:3d2f4a1c2f7a,Recheck:0,SF:28|17|19|48,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:0,File:nil,QS:nil,BEC:nil,COL:0
X-UUID: f445e572e15c473aae8bf64039675d76-20220708
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw01.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1951850205; Fri, 08 Jul 2022 17:46:20 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Fri, 8 Jul 2022 17:46:18 +0800
Received: from mhfsdcap04 (10.17.3.154) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 8 Jul 2022 17:46:17 +0800
Message-ID: <410b8c62ea399b51c11021c4838bd6a62d542703.camel@mediatek.com>
Subject: Re: [PATCH net v3] stmmac: dwmac-mediatek: fix clock issue
From:   Biao Huang <biao.huang@mediatek.com>
To:     Matthias Brugger <matthias.bgg@gmail.com>,
        David Miller <davem@davemloft.net>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <macpaul.lin@mediatek.com>
Date:   Fri, 8 Jul 2022 17:46:17 +0800
In-Reply-To: <14bf5e6b-4230-fffc-4134-c3015cf4d262@gmail.com>
References: <20220708083937.27334-1-biao.huang@mediatek.com>
         <20220708083937.27334-2-biao.huang@mediatek.com>
         <14bf5e6b-4230-fffc-4134-c3015cf4d262@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-MTK:  N
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Mattias,
	Thanks for your comments.

On Fri, 2022-07-08 at 11:22 +0200, Matthias Brugger wrote:
> 
> On 08/07/2022 10:39, Biao Huang wrote:
> > Since clocks are handled in mediatek_dwmac_clks_config(),
> > remove the clocks configuration in init()/exit(), and
> > invoke mediatek_dwmac_clks_config instead.
> > 
> > This issue is found in suspend/resume test.
> > 
> 
> Commit message is rather confusing. Basically you are moving the
> clock enable 
> into probe instead of init and remove it from exit. That means,
> clocks get 
> enabled earlier and don't get disabled if the module gets unloaded.
> That doesn't 
> sound correct, I think we would at least need to disable the clocks
> in remove 
> function.
there is pm_runtime support in driver, and clocks will be
disabled/enabled in stmmac_runtime_suspend/stmmac_runtime_resume.

stmmac_dvr_probe() invoke pm_runtime_put(device) at the end, and
disable clocks, but no clock enable at the beginning.
so vendor's probe entry should enable clocks to ensure normal behavior.

As to clocks in remove function, we did not test it
We should implement a vendor specified remove function who will take
care of clocks rather than invoke stmmac_pltfr_remove directly.

Anyway, we miss the clock handling case in remove function,
and will
test it and feed back.
> 
> I suppose that suspend calls exit and that there was a problem when
> we disable 
> the clocks there. Is this a HW issue that has no other possible fix?
Not a HW issue. suspend/resume will disable/enable clocks by invoking 
stmmac_pltfr_noirq_suspend/stmmac_pltfr_noirq_resume --> 
pm_runtime_force_suspend/pm_runtime_force_resume--> 
mediatek_dwmac_clks_config, so old clock handling in init/exit is no
longer a proper choice.

Best Regards!
Biao

> 
> Regards,
> Matthias
> 
> > Fixes: 3186bdad97d5 ("stmmac: dwmac-mediatek: add platform level
> > clocks management")
> > Signed-off-by: Biao Huang <biao.huang@mediatek.com>
> > ---
> >   .../ethernet/stmicro/stmmac/dwmac-mediatek.c  | 36 +++++---------
> > -----
> >   1 file changed, 9 insertions(+), 27 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
> > b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
> > index 6ff88df58767..e86f3e125cb4 100644
> > --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
> > +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
> > @@ -576,32 +576,7 @@ static int mediatek_dwmac_init(struct
> > platform_device *pdev, void *priv)
> >   		}
> >   	}
> >   
> > -	ret = clk_bulk_prepare_enable(variant->num_clks, plat->clks);
> > -	if (ret) {
> > -		dev_err(plat->dev, "failed to enable clks, err = %d\n",
> > ret);
> > -		return ret;
> > -	}
> > -
> > -	ret = clk_prepare_enable(plat->rmii_internal_clk);
> > -	if (ret) {
> > -		dev_err(plat->dev, "failed to enable rmii internal clk,
> > err = %d\n", ret);
> > -		goto err_clk;
> > -	}
> > -
> >   	return 0;
> > -
> > -err_clk:
> > -	clk_bulk_disable_unprepare(variant->num_clks, plat->clks);
> > -	return ret;
> > -}
> > -
> > -static void mediatek_dwmac_exit(struct platform_device *pdev, void
> > *priv)
> > -{
> > -	struct mediatek_dwmac_plat_data *plat = priv;
> > -	const struct mediatek_dwmac_variant *variant = plat->variant;
> > -
> > -	clk_disable_unprepare(plat->rmii_internal_clk);
> > -	clk_bulk_disable_unprepare(variant->num_clks, plat->clks);
> >   }
> >   
> >   static int mediatek_dwmac_clks_config(void *priv, bool enabled)
> > @@ -643,7 +618,6 @@ static int mediatek_dwmac_common_data(struct
> > platform_device *pdev,
> >   	plat->addr64 = priv_plat->variant->dma_bit_mask;
> >   	plat->bsp_priv = priv_plat;
> >   	plat->init = mediatek_dwmac_init;
> > -	plat->exit = mediatek_dwmac_exit;
> >   	plat->clks_config = mediatek_dwmac_clks_config;
> >   	if (priv_plat->variant->dwmac_fix_mac_speed)
> >   		plat->fix_mac_speed = priv_plat->variant-
> > >dwmac_fix_mac_speed;
> > @@ -712,13 +686,21 @@ static int mediatek_dwmac_probe(struct
> > platform_device *pdev)
> >   	mediatek_dwmac_common_data(pdev, plat_dat, priv_plat);
> >   	mediatek_dwmac_init(pdev, priv_plat);
> >   
> > +	ret = mediatek_dwmac_clks_config(priv_plat, true);
> > +	if (ret)
> > +		return ret;
> > +
> >   	ret = stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
> >   	if (ret) {
> >   		stmmac_remove_config_dt(pdev, plat_dat);
> > -		return ret;
> > +		goto err_drv_probe;
> >   	}
> >   
> >   	return 0;
> > +
> > +err_drv_probe:
> > +	mediatek_dwmac_clks_config(priv_plat, false);
> > +	return ret;
> >   }
> >   
> >   static const struct of_device_id mediatek_dwmac_match[] = {

