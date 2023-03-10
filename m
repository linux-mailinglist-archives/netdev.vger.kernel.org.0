Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 788396B51BE
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 21:23:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231383AbjCJUXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 15:23:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbjCJUXn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 15:23:43 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A6B822DDB;
        Fri, 10 Mar 2023 12:23:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678479811; x=1710015811;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=lNsPROUXvmiYBE2ivrrQFx+FveC84WickxXkXqMEeH4=;
  b=ltoHE4RG8EODUODe2bR+eamzEuHodSbnVc2z1MMht49+mn3zuLuFBKr5
   QznouC62qssDgnEYutwiZCctqVjHWguOBhsvSSGXUTXawqzL9TwQSHqGQ
   0m4schwL0Py6XquVWNCtSNTCK/fI1FpyTRTUXmZYBaeMWkHrM16eRtl+p
   8b5Nqws7bISLhr2rYVOknmZ45P26Qq9fxLGlOcKoSvsL8AG93BkZNwDDw
   rWGCrJgovKfp70F2BZGFfbUzVKuQr5X3NjgC28WGa/ym7i5019z2Yh8/3
   maRtpnbk//aZG3S2Pzp4DJjlDgs0LxsNpZnQ2RHCr7da/Z/g9B5MDHvaa
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10645"; a="423088046"
X-IronPort-AV: E=Sophos;i="5.98,250,1673942400"; 
   d="scan'208";a="423088046"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2023 12:23:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10645"; a="923804632"
X-IronPort-AV: E=Sophos;i="5.98,250,1673942400"; 
   d="scan'208";a="923804632"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga006.fm.intel.com with ESMTP; 10 Mar 2023 12:23:27 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1pajGv-0018Z7-2D;
        Fri, 10 Mar 2023 22:23:25 +0200
Date:   Fri, 10 Mar 2023 22:23:25 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v5 1/1] net: dsa: hellcreek: Get rid of custom
 led_init_default_state_get()
Message-ID: <ZAuRvXral/eNexYD@smile.fi.intel.com>
References: <20230310163855.21757-1-andriy.shevchenko@linux.intel.com>
 <ZAt0gqmOifS65Z91@corigine.com>
 <ZAt6dDGQ7stx36UC@smile.fi.intel.com>
 <ZAuNqChj3MUNbHqe@smile.fi.intel.com>
 <ZAuQHdPHNYB8/Von@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAuQHdPHNYB8/Von@corigine.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 10, 2023 at 09:16:29PM +0100, Simon Horman wrote:
> On Fri, Mar 10, 2023 at 10:06:00PM +0200, Andy Shevchenko wrote:
> > On Fri, Mar 10, 2023 at 08:44:05PM +0200, Andy Shevchenko wrote:
> > > On Fri, Mar 10, 2023 at 07:18:42PM +0100, Simon Horman wrote:
> > > > On Fri, Mar 10, 2023 at 06:38:55PM +0200, Andy Shevchenko wrote:

...

> > > > This seems to duplicate the logic in the earlier hunk of this patch.
> > > > Could it be moved into a helper?
> > > 
> > > It's possible, but in a separate patch as it's out of scope of this one.
> > > Do you want to create a such?
> > 
> > FWIW, I tried and it gives us +9 lines of code. So, what would be the point?
> > I can send as RFC in v6.
> 
> Less duplication is good, IMHO. But it's not a hard requirement from my side.

With what I see as PoC it becomes:
a) longer (+9 LoCs);
b) less understandable.

So, I would wait for maintainers to tell me if I need this at all.

Thank you for the review!

-- 
With Best Regards,
Andy Shevchenko


