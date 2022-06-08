Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECB2D542FAE
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 14:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238602AbiFHMEE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 08:04:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238541AbiFHMD7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 08:03:59 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F069232A54;
        Wed,  8 Jun 2022 05:03:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654689838; x=1686225838;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Q1sMptKRWmaXA4p2CjVpRnL0Jw2fDyzc4hN56hJsYXo=;
  b=S1B2CwuXUVBqThm8xUjUd+9AarMmGGyE1Aae/XUQ9L6o6rZm5hkd7GIt
   ObnS1nEEFehbkQGbuB6Uo0chFUog+GJHPxBDWmsT3MEkh1MHX0M8b/jXT
   Ee16iejsiNgJVApPayMUhiRhDFYB08yu5DgIw7JRe0niZIFvxFX25CmQ6
   M41ZoGXtCYIOFE0tV3MM3f0G9w7OJxWZ482Te7ZnlBZfWHAJFJ/n4fFS9
   m7BPjXiRTUm5jbFq7/zqz/qkXLPEhHGiCyKbtHmcvnel5tgHJApNbMyTE
   ZzLmTvPhE3LE9FmAJJEX3Gxl4ak1Ucq9z1yKqu67yJ/Gwcgt5cM9xlSNZ
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10371"; a="257302986"
X-IronPort-AV: E=Sophos;i="5.91,286,1647327600"; 
   d="scan'208";a="257302986"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2022 05:03:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,286,1647327600"; 
   d="scan'208";a="615357877"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga001.jf.intel.com with ESMTP; 08 Jun 2022 05:03:56 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id B74D0343; Wed,  8 Jun 2022 15:03:59 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 net-next 2/5] ptp_ocp: use bits.h macros for all masks
Date:   Wed,  8 Jun 2022 15:03:55 +0300
Message-Id: <20220608120358.81147-3-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220608120358.81147-1-andriy.shevchenko@linux.intel.com>
References: <20220608120358.81147-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently we are using BIT(), but GENMASK(). Make use of the latter one
as well (far less error-prone, far more concise).

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/ptp/ptp_ocp.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 17930762fde9..926add7be9a2 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /* Copyright (c) 2020 Facebook */
 
+#include <linux/bits.h>
 #include <linux/err.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -88,10 +89,10 @@ struct tod_reg {
 #define TOD_CTRL_DISABLE_FMT_A	BIT(17)
 #define TOD_CTRL_DISABLE_FMT_B	BIT(16)
 #define TOD_CTRL_ENABLE		BIT(0)
-#define TOD_CTRL_GNSS_MASK	((1U << 4) - 1)
+#define TOD_CTRL_GNSS_MASK	GENMASK(3, 0)
 #define TOD_CTRL_GNSS_SHIFT	24
 
-#define TOD_STATUS_UTC_MASK		0xff
+#define TOD_STATUS_UTC_MASK		GENMASK(7, 0)
 #define TOD_STATUS_UTC_VALID		BIT(8)
 #define TOD_STATUS_LEAP_ANNOUNCE	BIT(12)
 #define TOD_STATUS_LEAP_VALID		BIT(16)
@@ -205,7 +206,7 @@ struct frequency_reg {
 #define FREQ_STATUS_VALID	BIT(31)
 #define FREQ_STATUS_ERROR	BIT(30)
 #define FREQ_STATUS_OVERRUN	BIT(29)
-#define FREQ_STATUS_MASK	(BIT(24) - 1)
+#define FREQ_STATUS_MASK	GENMASK(23, 0)
 
 struct ptp_ocp_flash_info {
 	const char *name;
@@ -674,9 +675,9 @@ static const struct ocp_selector ptp_ocp_clock[] = {
 	{ }
 };
 
+#define SMA_DISABLE		BIT(16)
 #define SMA_ENABLE		BIT(15)
-#define SMA_SELECT_MASK		((1U << 15) - 1)
-#define SMA_DISABLE		0x10000
+#define SMA_SELECT_MASK		GENMASK(14, 0)
 
 static const struct ocp_selector ptp_ocp_sma_in[] = {
 	{ .name = "10Mhz",	.value = 0x0000 },
@@ -3440,7 +3441,7 @@ ptp_ocp_tod_status_show(struct seq_file *s, void *data)
 
 	val = ioread32(&bp->tod->utc_status);
 	seq_printf(s, "UTC status register: 0x%08X\n", val);
-	seq_printf(s, "UTC offset: %d  valid:%d\n",
+	seq_printf(s, "UTC offset: %ld  valid:%d\n",
 		val & TOD_STATUS_UTC_MASK, val & TOD_STATUS_UTC_VALID ? 1 : 0);
 	seq_printf(s, "Leap second info valid:%d, Leap second announce %d\n",
 		val & TOD_STATUS_LEAP_VALID ? 1 : 0,
-- 
2.35.1

