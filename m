Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B969E379446
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 18:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232073AbhEJQk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 12:40:59 -0400
Received: from mga11.intel.com ([192.55.52.93]:61841 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231845AbhEJQkf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 May 2021 12:40:35 -0400
IronPort-SDR: 7Q8ZQXxujheq6lxQB0rd2/DBuYhZbQIZ9x0EfD53lpvhi0HyVDwGTuyw9Ja+pLCE/NKb+kYl4A
 vsQgnOOZ/Dlg==
X-IronPort-AV: E=McAfee;i="6200,9189,9980"; a="196143301"
X-IronPort-AV: E=Sophos;i="5.82,287,1613462400"; 
   d="scan'208";a="196143301"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2021 09:39:29 -0700
IronPort-SDR: nolvwxO7Bpe1lD1/1yNNMUMN5agc1gYWDWo+6ZWdw+eQPsTEIevicq9EPhtmMgrIIi3v4QH5vw
 g2TZ6j3UjGKw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,287,1613462400"; 
   d="scan'208";a="470847071"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga001.jf.intel.com with ESMTP; 10 May 2021 09:39:17 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 0EAF3D7; Mon, 10 May 2021 19:39:36 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Flavio Suligoi <f.suligoi@asem.it>,
        Lee Jones <lee.jones@linaro.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 0/5] net: pch_gbe: fix and a few cleanups
Date:   Mon, 10 May 2021 19:39:26 +0300
Message-Id: <20210510163931.42417-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The series provides one fix (patch 1) for GPIO to be able to wait for
the GPIO driver to appear. This is separated from the conversion to
the GPIO descriptors (patch 2) in order to have a possibility for
backporting. Patches 3 and 4 fix minor warnings from Sparse while
moving to a new APIs. Patch 5 is MODULE_VERSION() clean up.

Tested on Intel Minnowboard (v1).

Since v3:
- rebased on top of v5.13-rc1
- added Tested-by (Flavio)
- added Reported-by to certain changes (LKP)

Since v2:
- added a few cleanups on top of the fix

Andy Shevchenko (5):
  net: pch_gbe: Propagate error from devm_gpio_request_one()
  net: pch_gbe: Convert to use GPIO descriptors
  net: pch_gbe: use readx_poll_timeout_atomic() variant
  net: pch_gbe: Use proper accessors to BE data in pch_ptp_match()
  net: pch_gbe: remove unneeded MODULE_VERSION() call

 .../net/ethernet/oki-semi/pch_gbe/pch_gbe.h   |   2 -
 .../oki-semi/pch_gbe/pch_gbe_ethtool.c        |   2 +
 .../ethernet/oki-semi/pch_gbe/pch_gbe_main.c  | 102 +++++++++---------
 3 files changed, 54 insertions(+), 52 deletions(-)

-- 
2.30.2

