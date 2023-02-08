Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C02A68F11C
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 15:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231328AbjBHOrk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 09:47:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230416AbjBHOrj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 09:47:39 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E50E955B0;
        Wed,  8 Feb 2023 06:47:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675867656; x=1707403656;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=IL9BS/x/hi3IqWzw+B0hTG9kEdZhQqSru2NE30VZrrY=;
  b=Jn+YByxLgORjCHczK+ClrH7gd/q2ETlWxB4VXVtFjL3vjukeBvXx8ZYW
   ULsmybqcBKOkC9Xr7LKdM5h4IZEdreF3uKMfmO8wfougyUqArISON+7oC
   sL6Eyb8e2Ye8W+4Ensi3whx0Q0ZlsSEz8VGo90cwSvKR3oYZxCLQKhzXO
   TiEchQnkBDTAEe6Ku4DE92P3E4a44QaRoLJat+jeDatfXWXfDRPzP9bXw
   7MvBwNBk/z0PyGX7M3avRWzjviKjl7QvSVOn/mERyGeQGqRCChzCb98Zl
   UsgNDdGZwEuI1oE6zuKBryQOre1RH+BX7H4Ce2NvUTtUkSaDC5Uc/9yFZ
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="313453050"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="313453050"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2023 06:47:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="660670486"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="660670486"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga007.jf.intel.com with ESMTP; 08 Feb 2023 06:47:32 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1pPljN-004AEw-2x;
        Wed, 08 Feb 2023 16:47:29 +0200
Date:   Wed, 8 Feb 2023 16:47:29 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jakub Kicinski <kuba@kernel.org>, Xin Long <lucien.xin@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        dev@openvswitch.org, tipc-discussion@lists.sourceforge.net,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: Re: [PATCH net-next v3 1/3] string_helpers: Move string_is_valid()
 to the header
Message-ID: <Y+O2AdEZMAeUjEU5@smile.fi.intel.com>
References: <20230208133153.22528-1-andriy.shevchenko@linux.intel.com>
 <Y+O0+ngPHklhtx6k@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+O0+ngPHklhtx6k@nanopsycho>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 08, 2023 at 03:43:06PM +0100, Jiri Pirko wrote:
> Wed, Feb 08, 2023 at 02:31:51PM CET, andriy.shevchenko@linux.intel.com wrote:
> >Move string_is_valid() to the header for wider use.
> >
> >While at it, rename to string_is_terminated() to be
> >precise about its semantics.
> 
> While at it, you could drop the ternary operator and return memchr()
> directly.

Code generation will be the same, I won't modify too much the original,
the point of the change is just to have this helper to be available to
others.

> With or without it:
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>

Thank you!

-- 
With Best Regards,
Andy Shevchenko


