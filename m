Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 074473EB57C
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 14:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240468AbhHMM2P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 08:28:15 -0400
Received: from mga14.intel.com ([192.55.52.115]:5785 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229965AbhHMM2O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 08:28:14 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10074"; a="215280354"
X-IronPort-AV: E=Sophos;i="5.84,318,1620716400"; 
   d="scan'208";a="215280354"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2021 05:27:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,318,1620716400"; 
   d="scan'208";a="639793620"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga005.jf.intel.com with ESMTP; 13 Aug 2021 05:27:45 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 6087DF9; Fri, 13 Aug 2021 15:27:45 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH v1 net-next 1/3] ptp_ocp: Switch to use module_pci_driver() macro
Date:   Fri, 13 Aug 2021 15:27:35 +0300
Message-Id: <20210813122737.45860-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eliminate some boilerplate code by using module_pci_driver() instead of
init/exit, and, if needed, moving the salient bits from init into probe.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/ptp/ptp_ocp.c | 20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 0d1034e3ed0f..874ea7930079 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -4,7 +4,6 @@
 #include <linux/err.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/ptp_clock_kernel.h>
 
@@ -377,24 +376,7 @@ static struct pci_driver ptp_ocp_driver = {
 	.probe		= ptp_ocp_probe,
 	.remove		= ptp_ocp_remove,
 };
-
-static int __init
-ptp_ocp_init(void)
-{
-	int err;
-
-	err = pci_register_driver(&ptp_ocp_driver);
-	return err;
-}
-
-static void __exit
-ptp_ocp_fini(void)
-{
-	pci_unregister_driver(&ptp_ocp_driver);
-}
-
-module_init(ptp_ocp_init);
-module_exit(ptp_ocp_fini);
+module_pci_driver(ptp_ocp_driver);
 
 MODULE_DESCRIPTION("OpenCompute TimeCard driver");
 MODULE_LICENSE("GPL v2");
-- 
2.30.2

