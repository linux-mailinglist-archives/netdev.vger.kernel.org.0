Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD64363D3BE
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 11:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbiK3KvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 05:51:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiK3KvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 05:51:12 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 257AC716C1;
        Wed, 30 Nov 2022 02:51:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669805472; x=1701341472;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=yhIEfje7scP4uHE/V4Mj7IrqqEE1cET9PfIRw9AAsgM=;
  b=Y1d2o2XR9DrFKt2vzA9JQeSxtyMKipFfrI1N8j1/xurYxhVzOoMZjVT0
   cesNcQlyXWW4pUlrvqBHuRWOR1+YqWNkiAWZL7x5sjSxuoUk1+VWf2RnA
   KNi0LPr18LxPMoHO6b/elSJ3E0y0jzJOZqmbYtZaVCFawLNdb3ZLWhCFB
   TfNLNnjj/peBMWvTVTlvK5S5NsibJnRUMYLJp8T7ZVl8lc2L11t/pR8Hp
   rmJCKO/NrFkKRouAbfnkzuVXSqs9i7nXJZdrCQWmQfZ/0g/EnIoFpqEKo
   2ilGjCRCGWN4dBT9HnTQIXfeJTeVPv9iEUYoiIxz3ENxTx/ttVPPSQ3K2
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="302968581"
X-IronPort-AV: E=Sophos;i="5.96,206,1665471600"; 
   d="scan'208";a="302968581"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 02:51:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="818585158"
X-IronPort-AV: E=Sophos;i="5.96,206,1665471600"; 
   d="scan'208";a="818585158"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga005.jf.intel.com with ESMTP; 30 Nov 2022 02:51:09 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1p0KgE-002Dib-37;
        Wed, 30 Nov 2022 12:51:06 +0200
Date:   Wed, 30 Nov 2022 12:51:06 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Mika Westerberg <mika.westerberg@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [resend, PATCH net-next v1 2/2] net: thunderbolt: Use separate
 header data type for the Rx
Message-ID: <Y4c1mtUlJfcxUQSi@smile.fi.intel.com>
References: <20221129161359.75792-1-andriy.shevchenko@linux.intel.com>
 <20221129161359.75792-2-andriy.shevchenko@linux.intel.com>
 <Y4cKSJI/TSQVMMJr@black.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4cKSJI/TSQVMMJr@black.fi.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 30, 2022 at 09:46:16AM +0200, Mika Westerberg wrote:
> On Tue, Nov 29, 2022 at 06:13:59PM +0200, Andy Shevchenko wrote:
> > The same data type structure is used for bitwise operations and
> > regular ones. It makes sparse unhappy, for example:
> > 
> >   .../thunderbolt.c:718:23: warning: cast to restricted __le32
> > 
> >   .../thunderbolt.c:953:23: warning: incorrect type in initializer (different base types)
> >   .../thunderbolt.c:953:23:    expected restricted __wsum [usertype] wsum
> >   .../thunderbolt.c:953:23:    got restricted __be32 [usertype]
> > 
> > Split the header to bitwise one and specific for Rx to make sparse
> > happy. Assure the layout by involving static_assert() against size
> > and offsets of the member of the structures.

> I would much rather keep the humans reading this happy than add 20+
> lines just to silence a tool. Unless this of course is some kind of a
> real bug.

Actually, changing types to bitwise ones reduces the sparse noise
(I will double check this) without reducing readability.
Would it be accepted?

-- 
With Best Regards,
Andy Shevchenko


