Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7938F323428
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 00:19:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233657AbhBWXSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 18:18:20 -0500
Received: from mo-csw1115.securemx.jp ([210.130.202.157]:51864 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233789AbhBWXOX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 18:14:23 -0500
Received: by mo-csw.securemx.jp (mx-mo-csw1115) id 11NNBZvb015639; Wed, 24 Feb 2021 08:11:35 +0900
X-Iguazu-Qid: 2wGqzdZmdWlkl6DMhf
X-Iguazu-QSIG: v=2; s=0; t=1614121895; q=2wGqzdZmdWlkl6DMhf; m=UNlr817M4TvvIjBZ8CwXvC0NvBivXhmHbbpNKdPAmwU=
Received: from imx2-a.toshiba.co.jp (imx2-a.toshiba.co.jp [106.186.93.35])
        by relay.securemx.jp (mx-mr1111) id 11NNBXDv000778
        (version=TLSv1.2 cipher=AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 24 Feb 2021 08:11:34 +0900
Received: from enc01.toshiba.co.jp (enc01.toshiba.co.jp [106.186.93.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by imx2-a.toshiba.co.jp (Postfix) with ESMTPS id BA2AC100096;
        Wed, 24 Feb 2021 08:11:33 +0900 (JST)
Received: from hop001.toshiba.co.jp ([133.199.164.63])
        by enc01.toshiba.co.jp  with ESMTP id 11NNBXDC009419;
        Wed, 24 Feb 2021 08:11:33 +0900
Date:   Wed, 24 Feb 2021 08:11:20 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     Wei Yongjun <weiyongjun1@huawei.com>
Cc:     Hulk Robot <hulkci@huawei.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] net: stmmac: Fix missing spin_lock_init in
 visconti_eth_dwmac_probe()
X-TSB-HOP: ON
Message-ID: <20210223231120.cwjwihml4zu2qnau@toshiba.co.jp>
References: <20210223104803.4047281-1-weiyongjun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210223104803.4047281-1-weiyongjun1@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, Feb 23, 2021 at 10:48:03AM +0000, Wei Yongjun wrote:
> The driver allocates the spinlock but not initialize it.
> Use spin_lock_init() on it to initialize it correctly.
> 
> Fixes: b38dd98ff8d0 ("net: stmmac: Add Toshiba Visconti SoCs glue driver")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Thanks for your fix.

Acked-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>

> ---
>  drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
> index b7a0c57dfbfb..d23be45a64e5 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
> @@ -218,6 +218,7 @@ static int visconti_eth_dwmac_probe(struct platform_device *pdev)
>  		goto remove_config;
>  	}
>  
> +	spin_lock_init(&dwmac->lock);
>  	dwmac->reg = stmmac_res.addr;
>  	plat_dat->bsp_priv = dwmac;
>  	plat_dat->fix_mac_speed = visconti_eth_fix_mac_speed;
> 
>

Best regards,
  Nobuhiro
