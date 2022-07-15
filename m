Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16DA557675A
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 21:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230472AbiGOTZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 15:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbiGOTZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 15:25:50 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B58E474E8;
        Fri, 15 Jul 2022 12:25:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657913150; x=1689449150;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=JdfVHR10lo0JUuwh5Hg2jSl0DSPLHy6Ry8sIafkrYXg=;
  b=etsv1ZKRAFNKFW7bdWwAHmQJoQACyh2Id0utsSUZuedvQnLcgQ5V9McG
   QqbVJeNmNvlBTFgDzXbsEgfK+vKN0f2AnJ88GKcq730JWB/OiXwb6+hcw
   ugn2v4ntMEO3c1Y4NMuRAETHVxeuYhGOHz0IElOK/7OG6RZ7lb8Zpipjp
   QVFZHt7zCY246qu3FUgkJc8SxsCCYo+tSdfIIKu0LXwlpYiByMmdfQetJ
   pY3+/YrqEX+72gNkQKuCWBMNbuxxCsIaGQIVZSBRmioPsH1WeullWxTZ1
   CsmwTv1zxnqMwabqIencY7Rmgu6OXdlFHoVpKj/gDeTBqtnBu4FHu01P6
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10409"; a="285910235"
X-IronPort-AV: E=Sophos;i="5.92,274,1650956400"; 
   d="scan'208";a="285910235"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2022 12:25:49 -0700
X-IronPort-AV: E=Sophos;i="5.92,274,1650956400"; 
   d="scan'208";a="773088655"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2022 12:25:44 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1oCQwW-001JCM-1H;
        Fri, 15 Jul 2022 22:25:40 +0300
Date:   Fri, 15 Jul 2022 22:25:40 +0300
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
Subject: Re: [net-next: PATCH v2 3/8] net: dsa: switch to device_/fwnode_ APIs
Message-ID: <YtG/NFKC6a0oPTcd@smile.fi.intel.com>
References: <20220715085012.2630214-1-mw@semihalf.com>
 <20220715085012.2630214-4-mw@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220715085012.2630214-4-mw@semihalf.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 15, 2022 at 10:50:07AM +0200, Marcin Wojtas wrote:
> In order to support both ACPI and DT, modify the generic
> DSA code to use device_/fwnode_ equivalent routines.
> Drop using port's dn field and use only fwnode - update
> all dependent drivers.
> Because support for more generic fwnode is added,
> replace '_of' suffix with '_fw' in related routines.
> No functional change is introduced by this patch.

It's a bit too narrow text in the commit message, can you use more width?

...

> -		ret = of_get_phy_mode(dsa_to_port(ds, 5)->dn, &interface);
> +		ret = of_get_phy_mode(to_of_node(dsa_to_port(ds, 5)->fwnode), &interface);

So, I believe this is expected to be a temporary change and something like
fwnode_get_phy_mode() is on its way, correct?

...

> -			phy_handle = of_parse_phandle(dp->dn, "phy-handle", 0);
> +			phy_handle = of_parse_phandle(to_of_node(dp->fwnode), "phy-handle", 0);

This can be translated to fwnode_find_reference(), but it might require more
changes.

Actually you may start from converting drivers one-by-one to fwnode
APIs (as much as it's possible), and then do with a library call. Up to you.

-- 
With Best Regards,
Andy Shevchenko


