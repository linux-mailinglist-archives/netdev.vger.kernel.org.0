Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5EE63D7D8
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 15:13:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbiK3ONJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 09:13:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbiK3OMw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 09:12:52 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7792B81382;
        Wed, 30 Nov 2022 06:11:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669817482; x=1701353482;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=yzmwxZgDr5S8U5t89iHsOd4kxIhVuBa4UeeGtP6f1KM=;
  b=GrOgDqlYz9uV4NZo/x3kP2RpKF6Abn9btr+JFBGrqndjLt5S0oPGJxZd
   hVEBjXpa0BmCA5Irrv3R5aYe5SyyaCZNGybboPiPnfWl5CzW/b8Y/TedA
   Z+kDaHf6tpf+lx0CZZwCLh33Efo2OEokQARTTzFLevJt9k/bGHwMDKUUi
   YQiTWP+5y00UC/JLm7R3xoDZ3feIUiPL6T2xDjVru2Ae+OMDb0/y50jSZ
   uE3ROzSNiAkH0dH/rwf9FtJVlCq1nQlAOnhX8umTlAmexgUGaYwu/zV96
   94OR3nakBkQfy4grM+VYJZFaSJpaT0Kx6jRGUnWsVDpO5E9QiWoTHEHz2
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="317251329"
X-IronPort-AV: E=Sophos;i="5.96,206,1665471600"; 
   d="scan'208";a="317251329"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 06:11:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="973116908"
X-IronPort-AV: E=Sophos;i="5.96,206,1665471600"; 
   d="scan'208";a="973116908"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga005.fm.intel.com with ESMTP; 30 Nov 2022 06:11:19 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1p0Nnx-002IQd-0P;
        Wed, 30 Nov 2022 16:11:17 +0200
Date:   Wed, 30 Nov 2022 16:11:16 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Mika Westerberg <mika.westerberg@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v3 2/2] net: thunderbolt: Use bitwise types in
 the struct thunderbolt_ip_frame_header
Message-ID: <Y4dkhPuQ03W6Tqy/@smile.fi.intel.com>
References: <20221130123613.20829-1-andriy.shevchenko@linux.intel.com>
 <20221130123613.20829-2-andriy.shevchenko@linux.intel.com>
 <Y4dTd1Ni2pIH1wbd@black.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4dTd1Ni2pIH1wbd@black.fi.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 30, 2022 at 02:58:31PM +0200, Mika Westerberg wrote:
> On Wed, Nov 30, 2022 at 02:36:13PM +0200, Andy Shevchenko wrote:
> > The main usage of the struct thunderbolt_ip_frame_header is to handle
> > the packets on the media layer. The header is bound to the protocol
> > in which the byte ordering is crucial. However the data type definition
> > doesn't use that and sparse is unhappy, for example (17 altogether):
> > 
> >   .../thunderbolt.c:718:23: warning: cast to restricted __le32
> > 
> >   .../thunderbolt.c:966:42: warning: incorrect type in assignment (different base types)
> >   .../thunderbolt.c:966:42:    expected unsigned int [usertype] frame_count
> >   .../thunderbolt.c:966:42:    got restricted __le32 [usertype]
> > 
> > Switch to the bitwise types in the struct thunderbolt_ip_frame_header to
> > reduce this, but not completely solving (9 left), because the same data
> > type is used for Rx header handled locally (in CPU byte order).
> > 
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
> Looks good to me. I assume you tested this against non-Linux OS to
> ensure nothing broke? ;-)

Oh, no. It's compile tested only. And since we are using leXX_to_cpu() against
fields in that data structure I assume that it won't be any functional issue
with this. It's all about strict type checking.

> Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Thank you!

-- 
With Best Regards,
Andy Shevchenko


