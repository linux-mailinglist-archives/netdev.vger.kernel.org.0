Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37E533EEC62
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 14:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239882AbhHQMZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 08:25:36 -0400
Received: from mga18.intel.com ([134.134.136.126]:45836 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237197AbhHQMZf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 08:25:35 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10078"; a="203218621"
X-IronPort-AV: E=Sophos;i="5.84,328,1620716400"; 
   d="scan'208";a="203218621"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2021 05:25:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,328,1620716400"; 
   d="scan'208";a="510446479"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga004.fm.intel.com with ESMTP; 17 Aug 2021 05:24:58 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id CDDF9FE; Tue, 17 Aug 2021 15:24:58 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 net-next 1/1] ptp_ocp: use bits.h macros for all masks
Date:   Tue, 17 Aug 2021 15:24:54 +0300
Message-Id: <20210817122454.50616-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.32.0
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
index caf9b37c5eb1..922f92637db8 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /* Copyright (c) 2020 Facebook */
 
+#include <linux/bits.h>
 #include <linux/err.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -84,10 +85,10 @@ struct tod_reg {
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
2.32.0

