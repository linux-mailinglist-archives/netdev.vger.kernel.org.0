Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB7B6B5162
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 21:06:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbjCJUGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 15:06:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbjCJUGK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 15:06:10 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41C701241C5;
        Fri, 10 Mar 2023 12:06:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678478766; x=1710014766;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=GCX+SREOuUTF6DWJe6G4+KBSCJjSU2JwO0ekPKHb1t8=;
  b=bWOwQ60GwPznPkATBLbrXg1aRW8kLNqMvkqqZqFEwLF1wZdrFifFksZT
   +5txfSwWQLVVSIyk61RZG0Xo2Ka8jSWucO8D+qn9atVj7TcaTxZSBTVDp
   5RJcRQST4LAexrLANsn+DvFmaGY3Sjgn16XD2hpKbXJxX1JiNYwVcZc7G
   NOJveZbnqPstsKPnTtEEWKIgOJsYGZtd+2JufHWFO5IYYGh8Q+4ThVa70
   VILTHoDJQ8Z1Rx9yBk8bwAQM7Dx47VMyQj56U4JMZgQEO1oHe6t+7YNlI
   3TsIAnjhz+PoK3hPFtD8N3ptEmgmF4Wx0sJmZwmGPhbuVMRV1H+ZJNkhx
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10645"; a="338374049"
X-IronPort-AV: E=Sophos;i="5.98,250,1673942400"; 
   d="scan'208";a="338374049"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2023 12:06:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10645"; a="766943684"
X-IronPort-AV: E=Sophos;i="5.98,250,1673942400"; 
   d="scan'208";a="766943684"
Received: from smile.fi.intel.com ([10.237.72.54])
  by FMSMGA003.fm.intel.com with ESMTP; 10 Mar 2023 12:06:02 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1paj04-0017wX-0t;
        Fri, 10 Mar 2023 22:06:00 +0200
Date:   Fri, 10 Mar 2023 22:06:00 +0200
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
Message-ID: <ZAuNqChj3MUNbHqe@smile.fi.intel.com>
References: <20230310163855.21757-1-andriy.shevchenko@linux.intel.com>
 <ZAt0gqmOifS65Z91@corigine.com>
 <ZAt6dDGQ7stx36UC@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAt6dDGQ7stx36UC@smile.fi.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 10, 2023 at 08:44:05PM +0200, Andy Shevchenko wrote:
> On Fri, Mar 10, 2023 at 07:18:42PM +0100, Simon Horman wrote:
> > On Fri, Mar 10, 2023 at 06:38:55PM +0200, Andy Shevchenko wrote:

...

> > This seems to duplicate the logic in the earlier hunk of this patch.
> > Could it be moved into a helper?
> 
> It's possible, but in a separate patch as it's out of scope of this one.
> Do you want to create a such?

FWIW, I tried and it gives us +9 lines of code. So, what would be the point?
I can send as RFC in v6.

-- 
With Best Regards,
Andy Shevchenko


