Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F1BB66CE95
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 19:16:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234110AbjAPSQU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 13:16:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234753AbjAPSPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 13:15:18 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E46516AF4;
        Mon, 16 Jan 2023 10:02:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673892157; x=1705428157;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Mjm60n7xCLcyGnAQhcWIofPMSbTPmkROv8KCynD2g6E=;
  b=l9g2/Y6k4t3smYlHbCiyi7lHHuxqOxT96QoyPLgq8oU6verLXr/SeWtv
   NDci/JQzQOEI4KcTHRaouon+3yI2cicpiOijBW+PSZpVZOwevrgViirvN
   2/CkJBG/QZZktfKZa2mMPBtBgm5vvmqC28xKb1ZcAivEmRn74vUlWR1kL
   v8t4T1QUlov4jRjAOfKLOvUSio+LATDTb501nZl4S12AGixlgmLhMrkAM
   HvIbFncOhMOvBbDGm7gRrqckOdQxX25E9rtiTgYxwMuosgcZS9pBY3U4X
   S0AG4sUeKXcNEnEDZ/gG2ZMCpmJjSQ9nYwctvoN35oVvq9Gbu18ABxHXc
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="325784096"
X-IronPort-AV: E=Sophos;i="5.97,221,1669104000"; 
   d="scan'208";a="325784096"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2023 10:01:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="904395780"
X-IronPort-AV: E=Sophos;i="5.97,221,1669104000"; 
   d="scan'208";a="904395780"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga006.fm.intel.com with ESMTP; 16 Jan 2023 10:01:28 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1pHTnR-00ACt7-2L;
        Mon, 16 Jan 2023 20:01:25 +0200
Date:   Mon, 16 Jan 2023 20:01:25 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, rafael@kernel.org, sean.wang@mediatek.com,
        Landen.Chao@mediatek.com, linus.walleij@linaro.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk, hkallweit1@gmail.com,
        jaz@semihalf.com, tn@semihalf.com, Samer.El-Haj-Mahmoud@arm.com
Subject: Re: [net-next: PATCH v4 4/8] net: mvpp2: initialize port fwnode
 pointer
Message-ID: <Y8WQ9T2O4hL3AmQB@smile.fi.intel.com>
References: <20230116173420.1278704-1-mw@semihalf.com>
 <20230116173420.1278704-5-mw@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230116173420.1278704-5-mw@semihalf.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 06:34:16PM +0100, Marcin Wojtas wrote:
> As a preparation to switch the DSA subsystem from using
> of_find_net_device_by_node() to its more generic fwnode_ equivalent,
> and later to allow ACPI description, update the port's device structure
> also with its fwnode pointer.

I believe this patch worth to be submitted even before core of this series.
FWIW,
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

> Signed-off-by: Marcin Wojtas <mw@semihalf.com>
> ---
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> index 5f89fcec07b1..a25e90791700 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -6884,7 +6884,7 @@ static int mvpp2_port_probe(struct platform_device *pdev,
>  	dev->min_mtu = ETH_MIN_MTU;
>  	/* 9704 == 9728 - 20 and rounding to 8 */
>  	dev->max_mtu = MVPP2_BM_JUMBO_PKT_SIZE;
> -	dev->dev.of_node = port_node;
> +	device_set_node(&dev->dev, port_fwnode);
>  
>  	port->pcs_gmac.ops = &mvpp2_phylink_gmac_pcs_ops;
>  	port->pcs_xlg.ops = &mvpp2_phylink_xlg_pcs_ops;
> -- 
> 2.29.0
> 

-- 
With Best Regards,
Andy Shevchenko


