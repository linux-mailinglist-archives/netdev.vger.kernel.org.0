Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB225522E8
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 19:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243470AbiFTRqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 13:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234534AbiFTRql (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 13:46:41 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1707E1AF15;
        Mon, 20 Jun 2022 10:46:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655747201; x=1687283201;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=y4PxMjDAoF2/1NyAMPOKsFhOJ3k2qjPJLBrH0OJLl54=;
  b=GoGFi9vHXjo7JhHOAMVZ6smEHxUPMwL11s9QEXvShTNkI5zFddMOHENB
   AmOCGZ4gkRJuKl8msctX/R89AHcTDkBw2d4zeSWZDdghyfeBkeBZHYUUz
   6FXgGnk5RZ5TRBj/Sa1B79AEG8eUSnJM+ljeXRPEIxOJ75eLFWhGks+Yh
   NyyjRF815xsBC58EUZdbmBkuy/qqLKGQy/ynRNNq2d6XK7Mf00woASzWP
   DUJ+Hrb54sLRVZm2m2g046Js4dv9418AyuLDgfmeG4yOhYeyXgDoc522K
   PCfdEDzRPDW2Dp45AgOxrmrfGiJ0BKEwc8iSl3gGkaBkXd+GT/a2brwrI
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10384"; a="279997808"
X-IronPort-AV: E=Sophos;i="5.92,207,1650956400"; 
   d="scan'208";a="279997808"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 10:46:40 -0700
X-IronPort-AV: E=Sophos;i="5.92,207,1650956400"; 
   d="scan'208";a="729482233"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 10:46:36 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1o3LTs-000kaG-NX;
        Mon, 20 Jun 2022 20:46:32 +0300
Date:   Mon, 20 Jun 2022 20:46:32 +0300
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
Subject: Re: [net-next: PATCH 05/12] net: core: switch to
 fwnode_find_net_device_by_node()
Message-ID: <YrCyeCe8sSd42Oni@smile.fi.intel.com>
References: <20220620150225.1307946-1-mw@semihalf.com>
 <20220620150225.1307946-6-mw@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220620150225.1307946-6-mw@semihalf.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 20, 2022 at 05:02:18PM +0200, Marcin Wojtas wrote:
> A helper function which allows getting the struct net_device pointer
> associated with a given device tree node can be more generic and
> also support alternative hardware description. Switch to fwnode_
> and update the only existing caller in DSA subsystem.

...

> +static int fwnode_dev_node_match(struct device *dev, const void *data)
>  {
>  	for (; dev; dev = dev->parent) {
> -		if (dev->of_node == data)

> +		if (dev->fwnode == data)


We have a helper in device/bus.h (?) device_match_fwnode().

>  			return 1;
>  	}

But this all sounds like a good candidate to be generic. Do we have more users
in the kernel of a such?

-- 
With Best Regards,
Andy Shevchenko


