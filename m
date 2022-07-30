Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF7CE585C04
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 22:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235325AbiG3USG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jul 2022 16:18:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbiG3USF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jul 2022 16:18:05 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C440413F26;
        Sat, 30 Jul 2022 13:18:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659212284; x=1690748284;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=cd3syrwIXsSarb0bdUv6tHAADb63fWwB5Q5t7g/Spnw=;
  b=n13ImsCcVTxUhddVgSjiCxIYQ7OJctvF5lV5+OWdnrtVnwPmcH0C/mEW
   6uwFZqI7SyvUudNTUpVSxyknJ89sgcmokBm7B8jdd+RYCexrOhTDRseNR
   XgI4ydVflOsjI1/seOr3iA9/tCcplwG/O1De0Dbd6pwetnYvy3agvF66q
   ebzzHYfVcr6EMBld2tcSpKOal/0CuqbM8KK9exIfP0IN9EIv3KrccDgYm
   A0VrwPzhhUpdG8I/dXiObTuI8fhnc4wwsgYNcNEh2ewY+Dk1r50w+lkTp
   W2fXJpjpMWNfB3j1h359E3Xqypsskbvm1blJELR0Dfmyy2t4oLcIMYLDU
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10424"; a="269326967"
X-IronPort-AV: E=Sophos;i="5.93,204,1654585200"; 
   d="scan'208";a="269326967"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2022 13:18:04 -0700
X-IronPort-AV: E=Sophos;i="5.93,204,1654585200"; 
   d="scan'208";a="728059168"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2022 13:18:00 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1oHsuK-001fXT-16;
        Sat, 30 Jul 2022 23:17:56 +0300
Date:   Sat, 30 Jul 2022 23:17:56 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     vee.khee.wong@intel.com, weifeng.voon@intel.com,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] stmmac: intel: Add a missing clk_disable_unprepare()
 call in intel_eth_pci_remove()
Message-ID: <YuWR9I8y9cWlLG3O@smile.fi.intel.com>
References: <b5b44a0c025d0fdddd9b9d23153261363089a06a.1659204745.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b5b44a0c025d0fdddd9b9d23153261363089a06a.1659204745.git.christophe.jaillet@wanadoo.fr>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 30, 2022 at 08:19:47PM +0200, Christophe JAILLET wrote:
> Commit 09f012e64e4b ("stmmac: intel: Fix clock handling on error and remove
> paths") removed this clk_disable_unprepare()
> 
> This was partly revert by commit ac322f86b56c ("net: stmmac: Fix clock
> handling on remove path") which removed this clk_disable_unprepare()
> because:
> "
>    While unloading the dwmac-intel driver, clk_disable_unprepare() is
>    being called twice in stmmac_dvr_remove() and
>    intel_eth_pci_remove(). This causes kernel panic on the second call.
> "
> 
> However later on, commit 5ec55823438e8 ("net: stmmac: add clocks management
> for gmac driver") has updated stmmac_dvr_remove() which do not call
> clk_disable_unprepare() anymore.
> 
> So this call should now be called from intel_eth_pci_remove().

The correct way of fixing it (which might be very well end up functionally
the same as this patch), is to introduce ->quit() in struct stmmac_pci_info
and assign it correctly, because not all platforms enable clocks.

Perhaps, we may leave this patch as is (for the sake of easy backporting) and
apply another one as I explained above to avoid similar mistakes in the future.

Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

> Fixes: 5ec55823438e8 ("net: stmmac: add clocks management for gmac driver")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> /!\     This patch is HIGHLY speculative.     /!\
> 
> The corresponding clk_disable_unprepare() is still called within the pm
> related stmmac_bus_clks_config() function.
> 
> However, with my limited understanding of the pm API, I think it that the
> patch is valid.
> (in other word, does the pm_runtime_put() and/or pm_runtime_disable()
> and/or stmmac_dvr_remove() can end up calling .runtime_suspend())
> 
> So please review with care, as I'm not able to test the change by myself.
> 
> 
> If I'm wrong, maybe a comment explaining why it is safe to have this
> call in the error handling path of the probe and not in the remove function
> would avoid erroneous patches generated from static code analyzer to be
> sent.
> ---
>  drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
> index 52f9ed8db9c9..9f38642f86ce 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
> @@ -1134,6 +1134,7 @@ static void intel_eth_pci_remove(struct pci_dev *pdev)
>  
>  	stmmac_dvr_remove(&pdev->dev);
>  
> +	clk_disable_unprepare(plat->stmmac_clk);
>  	clk_unregister_fixed_rate(priv->plat->stmmac_clk);
>  
>  	pcim_iounmap_regions(pdev, BIT(0));
> -- 
> 2.34.1
> 

-- 
With Best Regards,
Andy Shevchenko


