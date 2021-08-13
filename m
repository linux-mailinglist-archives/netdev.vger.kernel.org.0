Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 083523EB577
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 14:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240487AbhHMM2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 08:28:16 -0400
Received: from mga05.intel.com ([192.55.52.43]:12541 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233514AbhHMM2O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 08:28:14 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10074"; a="301137663"
X-IronPort-AV: E=Sophos;i="5.84,318,1620716400"; 
   d="scan'208";a="301137663"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2021 05:27:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,318,1620716400"; 
   d="scan'208";a="571790822"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga004.jf.intel.com with ESMTP; 13 Aug 2021 05:27:45 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 7A25E238; Fri, 13 Aug 2021 15:27:45 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH v1 net-next 3/3] ptp_ocp: use bits.h macros for all masks
Date:   Fri, 13 Aug 2021 15:27:37 +0300
Message-Id: <20210813122737.45860-3-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210813122737.45860-1-andriy.shevchenko@linux.intel.com>
References: <20210813122737.45860-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently we are using BIT(), but GENMASK(). Make use of the latter one
as well (far less error-prone, far more concise).

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/ptp/ptp_ocp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 5d0c0c0734f2..aad29b07c05b 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /* Copyright (c) 2020 Facebook */
 
+#include <linux/bits.h>
 #include <linux/err.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -60,10 +61,10 @@ struct tod_reg {
 #define TOD_CTRL_DISABLE_FMT_A	BIT(17)
 #define TOD_CTRL_DISABLE_FMT_B	BIT(16)
 #define TOD_CTRL_ENABLE		BIT(0)
-#define TOD_CTRL_GNSS_MASK	((1U << 4) - 1)
+#define TOD_CTRL_GNSS_MASK	GENMASK(3, 0)
 #define TOD_CTRL_GNSS_SHIFT	24
 
-#define TOD_STATUS_UTC_MASK	0xff
+#define TOD_STATUS_UTC_MASK	GENMASK(7, 0)
 #define TOD_STATUS_UTC_VALID	BIT(8)
 #define TOD_STATUS_LEAP_VALID	BIT(16)
 
-- 
2.30.2

