Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AEC4582569
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 13:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230459AbiG0LaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 07:30:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231430AbiG0LaK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 07:30:10 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C2D5481F3;
        Wed, 27 Jul 2022 04:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658921405; x=1690457405;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=XPTr1oCZhpKzQckO4AnCHv7mocNz5VPet32kxXw3ndA=;
  b=nAcems6VJynBPj/o8Cksjsag5FPFtXulemepugrhlGt4zwTgunQhHEW/
   gBhyonrq0tLfhnnzrPtSbFKDGIJcsmnxNtjut4yTi3Rn6rVJJ7ehHHQCS
   /FqKdPOvRPcJGnic1ExndSOcZSkb0/aLsy7mHI3RDFJOo04gUPMhO4XeJ
   fpxXDJ99+S18c6dCkaQslPHPoxAP8zjCbPZ9yG07cw26jUDh2PJkbAEY2
   4FuPAnJQyJmkSvz3A83ft6azAR2yS5YflzuZiKwIQ7MaIsbGWBlz32D3H
   aWfCa7TeGYDbZIwv9sJCX3lp5rmw8vOTKKl/9Q0eGG9pSbtKI5RsPeZGe
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10420"; a="267976633"
X-IronPort-AV: E=Sophos;i="5.93,195,1654585200"; 
   d="scan'208";a="267976633"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2022 04:30:03 -0700
X-IronPort-AV: E=Sophos;i="5.93,195,1654585200"; 
   d="scan'208";a="668298396"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2022 04:29:58 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1oGfEg-001cVp-3D;
        Wed, 27 Jul 2022 14:29:54 +0300
Date:   Wed, 27 Jul 2022 14:29:54 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, rafael@kernel.org, sean.wang@mediatek.com,
        Landen.Chao@mediatek.com, linus.walleij@linaro.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk, hkallweit1@gmail.com,
        gjb@semihalf.com, jaz@semihalf.com, tn@semihalf.com,
        Samer.El-Haj-Mahmoud@arm.com, upstream@semihalf.com
Subject: Re: [net-next: PATCH v3 3/8] net: dsa: switch to device_/fwnode_ APIs
Message-ID: <YuEhsqjq5eN6gGO6@smile.fi.intel.com>
References: <20220727064321.2953971-1-mw@semihalf.com>
 <20220727064321.2953971-4-mw@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220727064321.2953971-4-mw@semihalf.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 27, 2022 at 08:43:16AM +0200, Marcin Wojtas wrote:
> In order to support both DT and ACPI in future, modify the generic DSA
> code to use device_/fwnode_ equivalent routines. Drop using port's 'dn'
> field and use only fwnode - update all dependent drivers.
> 
> Because support for more generic fwnode is added, replace '_of' suffix
> with '_fw' in related routines. No functional change is introduced by
> this patch.

...

>  static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
>  {
> -	struct device_node *phy_handle = NULL;
> +	struct fwnode_handle *phy_handle = NULL;
>  	struct dsa_switch *ds = chip->ds;
>  	phy_interface_t mode;
>  	struct dsa_port *dp;
> @@ -3499,15 +3499,15 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
>  
>  	if (chip->info->ops->serdes_set_tx_amplitude) {
>  		if (dp)
> -			phy_handle = of_parse_phandle(dp->dn, "phy-handle", 0);
> +			phy_handle = fwnode_find_reference(dp->fwnode, "phy-handle", 0);
>  
> -		if (phy_handle && !of_property_read_u32(phy_handle,
> -							"tx-p2p-microvolt",
> -							&tx_amp))
> +		if (!IS_ERR(phy_handle) && !fwnode_property_read_u32(phy_handle,
> +								     "tx-p2p-microvolt",
> +								     &tx_amp))
>  			err = chip->info->ops->serdes_set_tx_amplitude(chip,
>  								port, tx_amp);
> -		if (phy_handle) {
> -			of_node_put(phy_handle);
> +		if (!IS_ERR(phy_handle)) {
> +			fwnode_handle_put(phy_handle);
>  			if (err)
>  				return err;
>  		}

I believe after 002752af7b89 ("device property: Allow error pointer to be
passed to fwnode APIs") you may simplify above like:

		if (!fwnode_property_read_u32(phy_handle, "tx-p2p-microvolt",
					      &tx_amp))
			err = chip->info->ops->serdes_set_tx_amplitude(chip,
								port, tx_amp);
		else
			err = 0;
		fwnode_handle_put(phy_handle);
		if (err)
			return err;

It also possible you can do refactoring before/after this one.

-- 
With Best Regards,
Andy Shevchenko


