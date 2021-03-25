Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A73A8349822
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 18:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbhCYRea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 13:34:30 -0400
Received: from mga04.intel.com ([192.55.52.120]:30045 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230032AbhCYReO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 13:34:14 -0400
IronPort-SDR: nSQO/aHlX5e5YZIE+mGQAr7rtUxMF7MbH/pISel6hnxlERH5D46Vn6fv9w6CtmFzm+fe3q3s42
 Yv7htgI38Zcw==
X-IronPort-AV: E=McAfee;i="6000,8403,9934"; a="188689909"
X-IronPort-AV: E=Sophos;i="5.81,278,1610438400"; 
   d="scan'208";a="188689909"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2021 10:34:14 -0700
IronPort-SDR: wZA/nN+17E3sdKjnDhxLCeQ+mcCwXUuN4axZXAWWOvbdM+M6jfU9fXC/ugFXhvb7I/jfhvrMJ+
 VtUV4WmRqjOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,278,1610438400"; 
   d="scan'208";a="375160257"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga003.jf.intel.com with ESMTP; 25 Mar 2021 10:34:12 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 68885355; Thu, 25 Mar 2021 19:34:23 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Flavio Suligoi <f.suligoi@asem.it>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v2 5/5] net: pch_gbe: remove unneeded MODULE_VERSION() call
Date:   Thu, 25 Mar 2021 19:34:12 +0200
Message-Id: <20210325173412.82911-6-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325173412.82911-1-andriy.shevchenko@linux.intel.com>
References: <20210325173412.82911-1-andriy.shevchenko@linux.intel.com>
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
---
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe.h         | 2 --
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c | 2 ++
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c    | 4 ----
 3 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe.h b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe.h
index 55cef5b16aa5..0a89117a8fb4 100644
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
index b54e73c57d65..0c5c4fefc8af 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
@@ -16,9 +16,6 @@
 #include <linux/net_tstamp.h>
 #include <linux/ptp_classify.h>
 
-#define DRV_VERSION     "1.01"
-const char pch_driver_version[] = DRV_VERSION;
-
 #define PCH_GBE_MAR_ENTRIES		16
 #define PCH_GBE_SHORT_PKT		64
 #define DSC_INIT16			0xC000
@@ -2726,7 +2723,6 @@ module_pci_driver(pch_gbe_driver);
 MODULE_DESCRIPTION("EG20T PCH Gigabit ethernet Driver");
 MODULE_AUTHOR("LAPIS SEMICONDUCTOR, <tshimizu818@gmail.com>");
 MODULE_LICENSE("GPL");
-MODULE_VERSION(DRV_VERSION);
 MODULE_DEVICE_TABLE(pci, pch_gbe_pcidev_id);
 
 /* pch_gbe_main.c */
-- 
2.30.2

