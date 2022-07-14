Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 156A75740EA
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 03:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231218AbiGNBTP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 21:19:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231499AbiGNBTL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 21:19:11 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 640C8DFC0;
        Wed, 13 Jul 2022 18:19:02 -0700 (PDT)
X-UUID: 838f550898a84d178dcdf8aefba2ddcc-20220714
X-CID-UNFAMILIAR: 1
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.8,REQID:3bb6d723-eaff-4165-9f88-3dd939a4c920,OB:10,L
        OB:0,IP:0,URL:0,TC:0,Content:0,EDM:0,RT:0,SF:54,FILE:0,RULE:Release_Ham,AC
        TION:release,TS:54
X-CID-INFO: VERSION:1.1.8,REQID:3bb6d723-eaff-4165-9f88-3dd939a4c920,OB:10,LOB
        :0,IP:0,URL:0,TC:0,Content:0,EDM:0,RT:0,SF:54,FILE:0,RULE:Release_HamU,ACT
        ION:release,TS:54
X-CID-META: VersionHash:0f94e32,CLOUDID:d1b66dd7-5d6d-4eaf-a635-828a3ee48b7c,C
        OID:d439a670ee54,Recheck:0,SF:28|16|19|48,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:0,File:nil,QS:nil,BEC:nil,COL:0
X-UUID: 838f550898a84d178dcdf8aefba2ddcc-20220714
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1557293866; Thu, 14 Jul 2022 09:18:56 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Thu, 14 Jul 2022 09:18:55 +0800
Received: from mhfsdcap04 (10.17.3.154) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 14 Jul 2022 09:18:54 +0800
Message-ID: <1d30edbe1761bea511f6619d934e550e05ac4f7a.camel@mediatek.com>
Subject: Re: [PATCH net v4 1/3] stmmac: dwmac-mediatek: fix clock issue
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
        <linux-mediatek@lists.infradead.org>, <macpaul.lin@mediatek.com>,
        Jisheng Zhang <jszhang@kernel.org>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
Date:   Thu, 14 Jul 2022 09:18:54 +0800
In-Reply-To: <c8fdfa7b-f4eb-8308-4064-b868ce945e3a@gmail.com>
References: <20220713101002.10970-1-biao.huang@mediatek.com>
         <20220713101002.10970-2-biao.huang@mediatek.com>
         <c8fdfa7b-f4eb-8308-4064-b868ce945e3a@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-MTK:  N
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,MAY_BE_FORGED,
        RCVD_IN_MSPIKE_H2,T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR,
        T_SPF_TEMPERROR,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Matthias,
	Thanks for your comments~

On Wed, 2022-07-13 at 14:11 +0200, Matthias Brugger wrote:
> 
> On 13/07/2022 12:10, Biao Huang wrote:
> > The pm_runtime takes care of the clock handling in current
> > stmmac drivers, and dwmac-mediatek implement the
> > mediatek_dwmac_clks_config() as the callback for pm_runtime.
> > 
> > Then, stripping duplicated clocks handling in old init()/exit()
> > to fix clock issue in suspend/resume test.
> > 
> > As to clocks in probe/remove, vendor need symmetric handling to
> > ensure clocks balance.
> > 
> > Test pass, including suspend/resume and ko insertion/remove.
> > 
> > Fixes: 3186bdad97d5 ("stmmac: dwmac-mediatek: add platform level
> > clocks management")
> > Signed-off-by: Biao Huang <biao.huang@mediatek.com>
> > ---
> >   .../ethernet/stmicro/stmmac/dwmac-mediatek.c  | 49 ++++++++----
> > -------
> >   1 file changed, 21 insertions(+), 28 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
> > b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
> > index 6ff88df58767..ca8ab290013c 100644
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
> > @@ -712,13 +686,32 @@ static int mediatek_dwmac_probe(struct
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
> > +}
> > +
> > +static int mediatek_dwmac_remove(struct platform_device *pdev)
> > +{
> > +	struct mediatek_dwmac_plat_data *priv_plat =
> > get_stmmac_bsp_priv(&pdev->dev);
> > +	int ret;
> > +
> > +	ret = stmmac_pltfr_remove(pdev);
> > +	mediatek_dwmac_clks_config(priv_plat, false);
> > +
> 
> We enalbe the clocks after calling stmmac_probe_config_dt(), so we
> should 
> disable them before calling stmmac_pltfr_remove(), correct?
> 
> Other then that:
> Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>

To ensure the hw configuration in stmmac_pltfr_remove behavior
normally, we should disable clocks after stmmac_pltfr_remove.

And there is no order requirement between clocks configured by 
stmmac_probe_config_dt/stmmac_remove_config_dt and clocks
configured by mediatek_dwmac_clks_config, so it's safe for
current snippet.

Best Regards!
Biao

> 
> > +	return ret;
> >   }
> >   
> >   static const struct of_device_id mediatek_dwmac_match[] = {
> > @@ -733,7 +726,7 @@ MODULE_DEVICE_TABLE(of, mediatek_dwmac_match);
> >   
> >   static struct platform_driver mediatek_dwmac_driver = {
> >   	.probe  = mediatek_dwmac_probe,
> > -	.remove = stmmac_pltfr_remove,
> > +	.remove = mediatek_dwmac_remove,
> >   	.driver = {
> >   		.name           = "dwmac-mediatek",
> >   		.pm		= &stmmac_pltfr_pm_ops,

