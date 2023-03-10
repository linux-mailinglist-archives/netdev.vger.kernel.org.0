Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4B666B5041
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 19:44:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbjCJSoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 13:44:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbjCJSoO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 13:44:14 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DB4E123CD1;
        Fri, 10 Mar 2023 10:44:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678473851; x=1710009851;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=4UnjfyA94w7k9y2k9qSpn2LQxXEIB43/q+hQC/kcjZg=;
  b=etRX8miTeSgq5T835vPDYRsnKh9EF47LdvlL5xvGUERUeVROzM0sftd9
   ZS+NP6WGsZY8hQfxCP2jJX7XsYnHbrm4haeNft9FHze/P1KjeMPuSVHoY
   mFb2FfMJBem+VgYkhOJwHlBM0sx8SOzf3YlTbJnRcJa0UhS8zjnuz7tmK
   //qTfIlztw9iZbELU1m9y/EosxZk6y3JXeZn+vSNQKr3px31C8biZSgJC
   27bUFyWZmHGg/7FwofS9MVaw1NAESHLX3x3ebwpdvaVXrLB2HXpz3c+8A
   U1AXk59pP3NoEj0w0lju2bnCU5m2AOFPII67puaM979pZ1s4Y7ilAtyNc
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10645"; a="401662447"
X-IronPort-AV: E=Sophos;i="5.98,250,1673942400"; 
   d="scan'208";a="401662447"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2023 10:44:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10645"; a="821162397"
X-IronPort-AV: E=Sophos;i="5.98,250,1673942400"; 
   d="scan'208";a="821162397"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga001.fm.intel.com with ESMTP; 10 Mar 2023 10:44:07 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1pahin-0015TV-0N;
        Fri, 10 Mar 2023 20:44:05 +0200
Date:   Fri, 10 Mar 2023 20:44:04 +0200
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
Message-ID: <ZAt6dDGQ7stx36UC@smile.fi.intel.com>
References: <20230310163855.21757-1-andriy.shevchenko@linux.intel.com>
 <ZAt0gqmOifS65Z91@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAt0gqmOifS65Z91@corigine.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 10, 2023 at 07:18:42PM +0100, Simon Horman wrote:
> On Fri, Mar 10, 2023 at 06:38:55PM +0200, Andy Shevchenko wrote:

...

> > +		hellcreek->led_sync_good.brightness =
> > +				hellcreek_get_brightness(hellcreek, STATUS_OUT_SYNC_GOOD);
> 
> nit: I think < 80 columns wide is still preferred for network code

I can do it if it's a strict rule here.

...

> This seems to duplicate the logic in the earlier hunk of this patch.
> Could it be moved into a helper?

It's possible, but in a separate patch as it's out of scope of this one.
Do you want to create a such?

-- 
With Best Regards,
Andy Shevchenko


