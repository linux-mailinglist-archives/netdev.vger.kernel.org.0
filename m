Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F98D6DDA28
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 13:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbjDKL62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 07:58:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbjDKL62 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 07:58:28 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A1981BC8
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 04:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681214307; x=1712750307;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=vlWzYaEXp+6FT2jS2g8ghy2hsaGVgaqThYJLUECGT64=;
  b=S1VM9U3tq+6tutO+sxA8TQsXqJC2q71Yek91qkx3b4t++jdIwb1GKJ3U
   wS7xGlf+0C+OtRZskJmyvEFiVrlnDxjTjo6ONsRlX2i7+TJguc9XtA0FM
   rlQzQtYWvUpVyvh+VF7/+IqhYZ2XHOv+1V9chfYPXPCLlXGB8hVUsNvFR
   7wwQkwh7IXolcXE3dwcBcqnfYccli21eNH8VwfORh8+2Jn7I/7mIbb6Hi
   pBaF8iqya8FuIPBMrL8wHzhtgnJOYNmaVXkm+S/euCX5sgr+QHCBOhYLf
   k5jTUt79FXpu3XUJqqcKzO0QCbZ36B6h0LPVUU2Y2hFt0vPCTpEHLtx3R
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="332282836"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="332282836"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2023 04:58:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="799885777"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="799885777"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga002.fm.intel.com with ESMTP; 11 Apr 2023 04:58:24 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1pmCdi-00FFWd-0L;
        Tue, 11 Apr 2023 14:58:22 +0300
Date:   Tue, 11 Apr 2023 14:58:21 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Mika Westerberg <mika.westerberg@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v2 2/3] net: thunderbolt: Fix sparse warnings in
 tbnet_xmit_csum_and_map()
Message-ID: <ZDVLXQ/8O7YxTHRv@smile.fi.intel.com>
References: <20230411091049.12998-1-mika.westerberg@linux.intel.com>
 <20230411091049.12998-3-mika.westerberg@linux.intel.com>
 <ZDVJeJd3mM0kBdE4@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZDVJeJd3mM0kBdE4@corigine.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 01:50:16PM +0200, Simon Horman wrote:
> On Tue, Apr 11, 2023 at 12:10:48PM +0300, Mika Westerberg wrote:
> > Fixes the following warning when the driver is built with sparse checks
> > enabled:
> > 
> > main.c:993:23: warning: incorrect type in initializer (different base types)
> > main.c:993:23:    expected restricted __wsum [usertype] wsum
> > main.c:993:23:    got restricted __be32 [usertype]
> > 
> > No functional changes intended.
> 
> This seems nice.
> 
> After you posted v1 I was wondering if, as a follow-up, it would be worth
> creating a helper for this, say cpu_to_wsum(), as I think this pattern
> occurs a few times. I'm thinking of a trivial wrapper around cpu_to_be32().

But it looks like it makes sense to have a standalone series for that matter.
I.o.w. it doesn't belong to Thunderbolt (only).

-- 
With Best Regards,
Andy Shevchenko


