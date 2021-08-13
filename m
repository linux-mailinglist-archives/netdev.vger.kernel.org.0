Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27C9A3EB58C
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 14:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240597AbhHMMa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 08:30:27 -0400
Received: from mga12.intel.com ([192.55.52.136]:18567 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240539AbhHMMaQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 08:30:16 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10074"; a="195137571"
X-IronPort-AV: E=Sophos;i="5.84,318,1620716400"; 
   d="scan'208";a="195137571"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2021 05:29:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,318,1620716400"; 
   d="scan'208";a="674339323"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga006.fm.intel.com with ESMTP; 13 Aug 2021 05:29:40 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id B5BFE373; Fri, 13 Aug 2021 15:29:37 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH v1 net-next 6/7] ptp_pch: Remove unused pch_pm_ops
Date:   Fri, 13 Aug 2021 15:29:31 +0300
Message-Id: <20210813122932.46152-6-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210813122932.46152-1-andriy.shevchenko@linux.intel.com>
References: <20210813122932.46152-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The default values for hooks in the driver.pm are NULLs.
Hence drop unused pch_pm_ops.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/ptp/ptp_pch.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/ptp/ptp_pch.c b/drivers/ptp/ptp_pch.c
index 29f793b04f2f..13c3fb7e1fbe 100644
--- a/drivers/ptp/ptp_pch.c
+++ b/drivers/ptp/ptp_pch.c
@@ -447,9 +447,6 @@ static const struct ptp_clock_info ptp_pch_caps = {
 	.enable		= ptp_pch_enable,
 };
 
-#define pch_suspend NULL
-#define pch_resume NULL
-
 static void pch_remove(struct pci_dev *pdev)
 {
 	struct pch_dev *chip = pci_get_drvdata(pdev);
@@ -539,14 +536,11 @@ static const struct pci_device_id pch_ieee1588_pcidev_id[] = {
 	{0}
 };
 
-static SIMPLE_DEV_PM_OPS(pch_pm_ops, pch_suspend, pch_resume);
-
 static struct pci_driver pch_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = pch_ieee1588_pcidev_id,
 	.probe = pch_probe,
 	.remove = pch_remove,
-	.driver.pm = &pch_pm_ops,
 };
 module_pci_driver(pch_driver);
 
-- 
2.30.2

