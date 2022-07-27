Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1323582448
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 12:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbiG0K2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 06:28:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbiG0K2o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 06:28:44 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DB0843332;
        Wed, 27 Jul 2022 03:28:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658917723; x=1690453723;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=RrV1tcJSu8Z7rFc6jziP1hGDQZbJGn8+5xabDMaGm1I=;
  b=Zx58KOKcnSK5uglwKp0vdA3HOfPf5sF9lGuh3dHORhG7FCTcCOAh95tq
   Qw/pfM8gdsetcK4TYFwErH2eyT5V/6YUQraJZw6gkCeiCCMnstsYIHZVd
   1TzcWHv4uzISzL+IhJKXkrvPSi8VHKdrjPfK02tmxm2PHuaooNpxgkdZH
   k1SBTKtfACs6fyiw/3f/yJbOAgbvHVqy1TigCPoqvMkm1RQnvwkY3V0g3
   0sTaQinwDm+B0v7MTPD/lZTMajcSMqar3p8ARDTP11lca0bJMnmuTm8DW
   2D/Sfy8N0h/O2sTdoKtxrvshJZZs0G5Jo91kXkwHnnkOkX2koFhfWs7Zw
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10420"; a="289392832"
X-IronPort-AV: E=Sophos;i="5.93,195,1654585200"; 
   d="scan'208";a="289392832"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2022 03:28:43 -0700
X-IronPort-AV: E=Sophos;i="5.93,195,1654585200"; 
   d="scan'208";a="742603318"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2022 03:28:37 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1oGeHK-001cRI-0x;
        Wed, 27 Jul 2022 13:28:34 +0300
Date:   Wed, 27 Jul 2022 13:28:34 +0300
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
Subject: Re: [net-next: PATCH v3 2/8] net: mdio: switch fixed-link PHYs API
 to fwnode_
Message-ID: <YuETUjgDzKjvM6lb@smile.fi.intel.com>
References: <20220727064321.2953971-1-mw@semihalf.com>
 <20220727064321.2953971-3-mw@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220727064321.2953971-3-mw@semihalf.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 27, 2022 at 08:43:15AM +0200, Marcin Wojtas wrote:
> fixed-link PHYs API is used by DSA and a number of drivers
> and was depending on of_. Switch to fwnode_ so to make it
> hardware description agnostic and allow to be used in ACPI
> world as well.

...

> +	/* Old binding */
> +	len = fwnode_property_count_u32(fwnode, "fixed-link");
> +	if (len == 5)
> +		return true;
> +
> +	return false;

Can be

	return len == 5;

or

	return fwnode_...(...) == 5;

Original also good, so up to you,

...

> +		if (fwnode_property_read_u32(fixed_link_node, "speed",
> +					     &status.speed)) {
> +			fwnode_handle_put(fixed_link_node);
> +			return -EINVAL;
> +		}

Why shadowing actual error code?

Either

	ret = fwnode_...(...);
	if (ret) {
		...
		return ret;
	}

or add a comment explaining the above magic transformations.

...

> +	/* Old binding */
> +	if (fwnode_property_read_u32_array(fwnode, "fixed-link", fixed_link_prop,
> +					   ARRAY_SIZE(fixed_link_prop)) == 0) {
> +		status.link = 1;
> +		status.duplex = fixed_link_prop[1];
> +		status.speed  = fixed_link_prop[2];
> +		status.pause  = fixed_link_prop[3];
> +		status.asym_pause = fixed_link_prop[4];
> +		goto register_phy;
> +	}
> +
> +	return -ENODEV;

Ditto.

-- 
With Best Regards,
Andy Shevchenko


