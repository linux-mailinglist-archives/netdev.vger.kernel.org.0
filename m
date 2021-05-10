Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4E0379449
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 18:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232023AbhEJQlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 12:41:35 -0400
Received: from mga12.intel.com ([192.55.52.136]:26605 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232051AbhEJQk5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 May 2021 12:40:57 -0400
IronPort-SDR: 0qPyj8bzM/8fBey+uF4BKBQBqrJXPVfsfdI0EB6kfBgSM0+Omiy3Iy5zUeY8cUyMNk7d6DFZJI
 Pb5FheVwg7zA==
X-IronPort-AV: E=McAfee;i="6200,9189,9980"; a="178824403"
X-IronPort-AV: E=Sophos;i="5.82,287,1613462400"; 
   d="scan'208";a="178824403"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2021 09:39:38 -0700
IronPort-SDR: ozFvMfKLipogd+EXmH0iFxuHik4tZax1qk1mYt0y8g4cK7ajX0k5Ceno/C/o7CSW/nAFJ12dm0
 Tpa/cvWHQK6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,287,1613462400"; 
   d="scan'208";a="470847113"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga001.jf.intel.com with ESMTP; 10 May 2021 09:39:26 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id ECFF3202; Mon, 10 May 2021 19:39:45 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Flavio Suligoi <f.suligoi@asem.it>,
        Lee Jones <lee.jones@linaro.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 5/5] net: pch_gbe: remove unneeded MODULE_VERSION() call
Date:   Mon, 10 May 2021 19:39:31 +0300
Message-Id: <20210510163931.42417-6-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210510163931.42417-1-andriy.shevchenko@linux.intel.com>
References: <20210510163931.42417-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove MODULE_VERSION(), as it doesn't seem to serve any practical purpose.
For in-tree drivers, the kernel version matters. The code received lots of
changes, but module version remained constant, since the driver landed in
mainline. So, this version doesn't seem have any practical meaning anymore.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Flavio Suligoi <f.suligoi@asem.it>
---
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe.h         | 2 --
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c | 2 ++
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c    | 4 ----
 3 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe.h b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe.h
index a6823c4d355d..108f312bc542 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe.h
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe.h
@@ -596,8 +596,6 @@ struct pch_gbe_adapter {
 
 #define pch_gbe_hw_to_adapter(hw)	container_of(hw, struct pch_gbe_adapter, hw)
 
-extern const char pch_driver_version[];
-
 /* pch_gbe_main.c */
 int pch_gbe_up(struct pch_gbe_adapter *adapter);
 void pch_gbe_down(struct pch_gbe_adapter *adapter);
diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c
index a58f14aca10c..660b07cb5b92 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c
@@ -8,6 +8,8 @@
 #include "pch_gbe.h"
 #include "pch_gbe_phy.h"
 
+static const char pch_driver_version[] = "1.01";
+
 /*
  * pch_gbe_stats - Stats item information
  */
diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
index 5e8acf76410d..e351f3d1608f 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
@@ -18,9 +18,6 @@
 #include <linux/ptp_pch.h>
 #include <linux/gpio.h>
 
-#define DRV_VERSION     "1.01"
-const char pch_driver_version[] = DRV_VERSION;
-
 #define PCH_GBE_MAR_ENTRIES		16
 #define PCH_GBE_SHORT_PKT		64
 #define DSC_INIT16			0xC000
@@ -2728,7 +2725,6 @@ module_pci_driver(pch_gbe_driver);
 MODULE_DESCRIPTION("EG20T PCH Gigabit ethernet Driver");
 MODULE_AUTHOR("LAPIS SEMICONDUCTOR, <tshimizu818@gmail.com>");
 MODULE_LICENSE("GPL");
-MODULE_VERSION(DRV_VERSION);
 MODULE_DEVICE_TABLE(pci, pch_gbe_pcidev_id);
 
 /* pch_gbe_main.c */
-- 
2.30.2

