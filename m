Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7FEFD8B
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 18:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbfD3QLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 12:11:30 -0400
Received: from mga03.intel.com ([134.134.136.65]:10625 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725942AbfD3QL3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 12:11:29 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Apr 2019 09:11:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,414,1549958400"; 
   d="scan'208";a="138757946"
Received: from smile.fi.intel.com (HELO smile) ([10.237.72.86])
  by orsmga008.jf.intel.com with ESMTP; 30 Apr 2019 09:11:25 -0700
Received: from andy by smile with local (Exim 4.92)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1hLVLo-0007fS-1f; Tue, 30 Apr 2019 19:11:24 +0300
Date:   Tue, 30 Apr 2019 19:11:24 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     "Tobin C. Harding" <tobin@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tyler Hicks <tyhicks@canonical.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Wang Hai <wanghai26@huawei.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] net-sysfs: Fix error path for kobject_init_and_add()
Message-ID: <20190430161124.GM9224@smile.fi.intel.com>
References: <20190430002817.10785-1-tobin@kernel.org>
 <20190430002817.10785-4-tobin@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190430002817.10785-4-tobin@kernel.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 30, 2019 at 10:28:17AM +1000, Tobin C. Harding wrote:
> Currently error return from kobject_init_and_add() is not followed by a
> call to kobject_put().  This means there is a memory leak.
> 
> Add call to kobject_put() in error path of kobject_init_and_add().

It's not obvious to me if this will help to fix what is stated in the
(reverted) commit 6b70fc94afd1 ("net-sysfs: Fix memory leak in
netdev_register_kobject")?

If so, perhaps we need to tell syzkaller guys about this.


-- 
With Best Regards,
Andy Shevchenko


