Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E942A414A70
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 15:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232041AbhIVNX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 09:23:58 -0400
Received: from mga12.intel.com ([192.55.52.136]:64818 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230413AbhIVNXz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 09:23:55 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10114"; a="203083836"
X-IronPort-AV: E=Sophos;i="5.85,314,1624345200"; 
   d="scan'208";a="203083836"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2021 06:22:23 -0700
X-IronPort-AV: E=Sophos;i="5.85,314,1624345200"; 
   d="scan'208";a="435432088"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2021 06:22:19 -0700
Received: from andy by smile with local (Exim 4.95-RC2)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1mT2CW-004Bgc-2C;
        Wed, 22 Sep 2021 16:22:16 +0300
Date:   Wed, 22 Sep 2021 16:22:16 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Jonas =?iso-8859-1?Q?Dre=DFler?= <verdre@v0yd.nl>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Brian Norris <briannorris@chromium.org>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mwifiex: Use non-posted PCI write when setting TX
 ring write pointer
Message-ID: <YUsuCPSYsRhlCxwD@smile.fi.intel.com>
References: <20210914114813.15404-1-verdre@v0yd.nl>
 <20210914114813.15404-2-verdre@v0yd.nl>
 <YUsQ3jU1RuThUYn8@smile.fi.intel.com>
 <9293504f-f70d-61ac-b221-dd466f01b5df@v0yd.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9293504f-f70d-61ac-b221-dd466f01b5df@v0yd.nl>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 22, 2021 at 02:08:39PM +0200, Jonas Dreßler wrote:
> On 9/22/21 1:17 PM, Andy Shevchenko wrote:
> > On Tue, Sep 14, 2021 at 01:48:12PM +0200, Jonas Dreßler wrote:

...

> > Should it have a Fixes tag?
> > 
> 
> Don't think so, there's the infamous
> (https://bugzilla.kernel.org/show_bug.cgi?id=109681) Bugzilla bug it fixes
> though, I'll mention that in v3.

Good idea, use BugLink tag for that!

...

> Interesting, I haven't noticed that mwifiex_write_reg() always returns 0. So
> are you suggesting to remove that return value and get rid of all the "if
> (mwifiex_write_reg()) {}" checks in a separate commit?

Something like this, yes.

> As for why the dummy read/write functions exist, I have no idea. Looking at
> git history it seems they were always there (only change is that
> mwifiex_read_reg() started to handle read errors with commit
> af05148392f50490c662dccee6c502d9fcba33e2). My bet would be that they were
> created to be consistent with sdio.c which is the oldest supported bus type
> in mwifiex.

It has a check against all ones. Also your another patch mentioned wake up.
Perhaps the purpose is to wake up and return if device was/is in power off mode
(D3hot).

-- 
With Best Regards,
Andy Shevchenko


