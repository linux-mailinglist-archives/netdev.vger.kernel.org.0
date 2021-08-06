Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C64EF3E26C6
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 11:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242767AbhHFJIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 05:08:23 -0400
Received: from mga18.intel.com ([134.134.136.126]:60275 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244091AbhHFJIP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Aug 2021 05:08:15 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10067"; a="201521022"
X-IronPort-AV: E=Sophos;i="5.84,300,1620716400"; 
   d="scan'208";a="201521022"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2021 02:07:59 -0700
X-IronPort-AV: E=Sophos;i="5.84,300,1620716400"; 
   d="scan'208";a="501933393"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2021 02:07:57 -0700
Received: from andy by smile with local (Exim 4.94.2)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1mBvpX-005lkH-8m; Fri, 06 Aug 2021 12:07:51 +0300
Date:   Fri, 6 Aug 2021 12:07:51 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v1 1/1] wwan: core: Avoid returning error pointer from
 wwan_create_dev()
Message-ID: <YQz75yaecp016zOb@smile.fi.intel.com>
References: <20210805183100.49071-1-andriy.shevchenko@linux.intel.com>
 <CAMZdPi_+GpG8h2tJ1AxOj6HaPiXXDh6aC2RvO=+zXRy_AQpWkg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMZdPi_+GpG8h2tJ1AxOj6HaPiXXDh6aC2RvO=+zXRy_AQpWkg@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 05, 2021 at 09:53:57PM +0200, Loic Poulain wrote:
> On Thu, 5 Aug 2021 at 20:38, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> >
> > wwan_create_dev() is expected to return either valid pointer or NULL,
> > In some cases it might return the error pointer. Prevent this by converting
> > it to NULL after wwan_dev_get_by_parent().
> 
> wwan_create_dev is called both from wwan_register_ops() and
> wwan_create_port(), one using IS_ERR and the other using NULL testing,
> they should be aligned as well.

Ah, good catch!

I just sent v2, but eventually I have decided to switch to error pointer since
it seems the most used pattern in the code.

-- 
With Best Regards,
Andy Shevchenko


