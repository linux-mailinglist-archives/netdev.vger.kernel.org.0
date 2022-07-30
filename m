Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49649585BF4
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 22:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235666AbiG3UHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jul 2022 16:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbiG3UHX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jul 2022 16:07:23 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E19D713D4F;
        Sat, 30 Jul 2022 13:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659211642; x=1690747642;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qVvlkCYGySw576yQ2Em/mAMLb51VdX062dlKlXivK7E=;
  b=JLfSiS9hb4WmPDHMEu0ZqJEoGYRZcF12vR+nME4XxcNcxWSLY7s+n8HQ
   KVJGidQCNhzIcTzfNgVdjsnMWDcqYO1doAO9CswdW4FWqw3jmRowLsXCS
   xrh0JZVuWGhwAZFztyXafTHwZwgRBXDRVr7sutchJzQQsetAWY8BSpqrz
   dpeuVsufShe40FZP++Nh71K93JAwtC6xLH/nkjeqX3XtPdir48d59jOCc
   P/obvEWrG2ioDmSwW9Cb/bRp1Muby5W50o/sOIavCwnfcp/sSiRNnH7kA
   XJaZuUOc36jFGxBVcFFavr3s62YLuaKXPy8XjV7CYcm8KfcUFLMOLOffF
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10424"; a="275837556"
X-IronPort-AV: E=Sophos;i="5.93,204,1654585200"; 
   d="scan'208";a="275837556"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2022 13:07:22 -0700
X-IronPort-AV: E=Sophos;i="5.93,204,1654585200"; 
   d="scan'208";a="577321545"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2022 13:07:18 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1oHsjz-001fWn-1J;
        Sat, 30 Jul 2022 23:07:15 +0300
Date:   Sat, 30 Jul 2022 23:07:15 +0300
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
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] stmmac: intel: Simplify intel_eth_pci_remove()
Message-ID: <YuWPc8Flkpm4Yt/z@smile.fi.intel.com>
References: <b5b44a0c025d0fdddd9b9d23153261363089a06a.1659204745.git.christophe.jaillet@wanadoo.fr>
 <9f82d58aa4a6c34ec3c734399a4792d3aa23297f.1659204745.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f82d58aa4a6c34ec3c734399a4792d3aa23297f.1659204745.git.christophe.jaillet@wanadoo.fr>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 30, 2022 at 08:20:02PM +0200, Christophe JAILLET wrote:
> There is no point to call pcim_iounmap_regions() in the remove function,
> this frees a managed resource that would be release by the framework
> anyway.

The patch is fully correct in my opinion. The iounmap() is called exactly in
the same order as if it's done implicitly by managed resources handlers, hence
no need to explicitly call it.

Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> This patch is speculative.
> Sometimes the order of releasing managed resources is tricky.
> 
> Just a few drivers have this pattern, while many call pcim_iomap_regions().
> If I'm right and this patch is reviewed and merged, I'll look at the
> other files if they also can be simplified a bit.
> ---
>  drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
> index 9f38642f86ce..f68d23051557 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
> @@ -1136,8 +1136,6 @@ static void intel_eth_pci_remove(struct pci_dev *pdev)
>  
>  	clk_disable_unprepare(plat->stmmac_clk);
>  	clk_unregister_fixed_rate(priv->plat->stmmac_clk);
> -
> -	pcim_iounmap_regions(pdev, BIT(0));
>  }
>  
>  static int __maybe_unused intel_eth_pci_suspend(struct device *dev)
> -- 
> 2.34.1
> 

-- 
With Best Regards,
Andy Shevchenko


