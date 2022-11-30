Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0633B63D4BD
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 12:38:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234019AbiK3Lig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 06:38:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232155AbiK3Lie (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 06:38:34 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 945D12ED60;
        Wed, 30 Nov 2022 03:38:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669808313; x=1701344313;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=TaijO37vvQN0R1RRGRvAfk8K4dWGe7fGsOg1uROklL0=;
  b=XasCGH4sAU5DPGcVmEyW0C6XUfhkjj4MA/YGvxwhDPI8YlmHtS0s45cH
   +v8S5Ldyk2BgyH2hkRfoFJ1MzC0lRH1pcm7iVJvrdezIB5/NAscWEmtZ3
   k8KPJAyt8PnhroSyfFvuBLvxbbFb9IUvmaCPmwSE49ydLFa9L+Z03WegC
   FsJR5ASdHQVH83A5X78KEWWv6sSndD8MOMJlIol4gEPx9Vwcce+Om//Cn
   M+gFtH9QODUTfHaOaI1B1Y3jgMzUGFDMD28uCRc1i7KCPM/uKmDVBQCqH
   ugLSYz+/S15YFBpwIJSM1H2UJi9IiJgeKjD9LRsXxNWjQo3FcHX1sTdUs
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="317223174"
X-IronPort-AV: E=Sophos;i="5.96,206,1665471600"; 
   d="scan'208";a="317223174"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 03:38:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="594634197"
X-IronPort-AV: E=Sophos;i="5.96,206,1665471600"; 
   d="scan'208";a="594634197"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga003.jf.intel.com with ESMTP; 30 Nov 2022 03:38:30 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1p0LQ4-002EqP-0q;
        Wed, 30 Nov 2022 13:38:28 +0200
Date:   Wed, 30 Nov 2022 13:38:27 +0200
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
Message-ID: <Y4dAs4SMb+ZHtJuC@smile.fi.intel.com>
References: <20221129161359.75792-1-andriy.shevchenko@linux.intel.com>
 <20221129161359.75792-2-andriy.shevchenko@linux.intel.com>
 <Y4cKSJI/TSQVMMJr@black.fi.intel.com>
 <Y4c1mtUlJfcxUQSi@smile.fi.intel.com>
 <Y4c6B/mj+g2BCwy9@black.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4c6B/mj+g2BCwy9@black.fi.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 30, 2022 at 01:09:59PM +0200, Mika Westerberg wrote:
> On Wed, Nov 30, 2022 at 12:51:06PM +0200, Andy Shevchenko wrote:
> > On Wed, Nov 30, 2022 at 09:46:16AM +0200, Mika Westerberg wrote:
> > > On Tue, Nov 29, 2022 at 06:13:59PM +0200, Andy Shevchenko wrote:
> > > > The same data type structure is used for bitwise operations and
> > > > regular ones. It makes sparse unhappy, for example:
> > > > 
> > > >   .../thunderbolt.c:718:23: warning: cast to restricted __le32
> > > > 
> > > >   .../thunderbolt.c:953:23: warning: incorrect type in initializer (different base types)
> > > >   .../thunderbolt.c:953:23:    expected restricted __wsum [usertype] wsum
> > > >   .../thunderbolt.c:953:23:    got restricted __be32 [usertype]
> > > > 
> > > > Split the header to bitwise one and specific for Rx to make sparse
> > > > happy. Assure the layout by involving static_assert() against size
> > > > and offsets of the member of the structures.
> > 
> > > I would much rather keep the humans reading this happy than add 20+
> > > lines just to silence a tool. Unless this of course is some kind of a
> > > real bug.
> > 
> > Actually, changing types to bitwise ones reduces the sparse noise
> > (I will double check this) without reducing readability.
> > Would it be accepted?
> 
> Sure if it makes it more readable and does not add too many lines :)

It replaces types u* by __le*, that's it: -4 +4 LoCs.

-- 
With Best Regards,
Andy Shevchenko


