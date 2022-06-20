Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B48D552375
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 20:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244423AbiFTSDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 14:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243532AbiFTSDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 14:03:01 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E65605FEA;
        Mon, 20 Jun 2022 11:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655748181; x=1687284181;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=x8BZ6rEd02p7RqBzPoWUxgCGm2AKrcMcXu+ufZqgmgI=;
  b=kB5hgjCtCn1nWVe+PuCLyl+9+YtXGURv5UYEYpqRTysSD7vqFkqOVBgd
   Iq04jOTBrA2fsE3EauuFxhu7BV7c1FNKY7wVoqP1Bfs7CMpgybtST+HH4
   6Z0Qlt6RQlgx7CphuE6E0OdO5HeGZXgFjXf4vkcZuLWMy7OKnuBO6M7oY
   zAqA640y7SFv1nBO6Jd39GSneeFkwSF6k7jPr+AJeP4yo7w43aZPbIRQ0
   TqP4J2xyGaVE5paAuScMj3XD8HEv5JYE/b6z/qQ3stPuLnXoQb1QYjOS5
   QtmQeHbmqEP3DXzg1BLsrK87085kFgZVGn6vzuPJNkM7WxfU/mjS8W/TN
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10384"; a="281006164"
X-IronPort-AV: E=Sophos;i="5.92,207,1650956400"; 
   d="scan'208";a="281006164"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 11:03:00 -0700
X-IronPort-AV: E=Sophos;i="5.92,207,1650956400"; 
   d="scan'208";a="654783673"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 11:02:55 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1o3Lha-000kay-VH;
        Mon, 20 Jun 2022 21:00:42 +0300
Date:   Mon, 20 Jun 2022 21:00:42 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, rafael@kernel.org, lenb@kernel.org,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux@armlinux.org.uk,
        hkallweit1@gmail.com, gjb@semihalf.com, jaz@semihalf.com,
        tn@semihalf.com, Samer.El-Haj-Mahmoud@arm.com,
        upstream@semihalf.com
Subject: Re: [net-next: PATCH 11/12] net: dsa: mv88e6xxx: switch to
 device_/fwnode_ APIs
Message-ID: <YrC1ymfSJ3nxWw4B@smile.fi.intel.com>
References: <20220620150225.1307946-1-mw@semihalf.com>
 <20220620150225.1307946-12-mw@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220620150225.1307946-12-mw@semihalf.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 20, 2022 at 05:02:24PM +0200, Marcin Wojtas wrote:
> In order to support both ACPI and DT, modify the generic
> DSA code to use device_/fwnode_ equivalent routines.
> No functional change is introduced by this patch.

...

>  	int err;
>  
> -	if (!np && !pdata)
> +	if (!fwnode && !pdata)
>  		return -EINVAL;

Sounds like redundant check

	if (pdata)
		...
	else
		compat_info = ...
	if (!compat_info)
		return -EINVAL

?

> -	if (np)
> -		compat_info = of_device_get_match_data(dev);
> +	if (fwnode)
> +		compat_info = device_get_match_data(dev);
>  
>  	if (pdata) {

Missed 'else' even in the original code (see above)?

>  		compat_info = pdata_device_get_match_data(dev);


-- 
With Best Regards,
Andy Shevchenko


