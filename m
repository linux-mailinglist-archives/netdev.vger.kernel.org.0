Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 993D632D32F
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 13:34:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240849AbhCDMdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 07:33:25 -0500
Received: from mga05.intel.com ([192.55.52.43]:28648 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240793AbhCDMdR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 07:33:17 -0500
IronPort-SDR: DY77keBVuFDQh+P3ooo494ZblgDX50DgcMAYm6GMlKuBixXPEX01E16vwszCc/jz2ZnKTgcdEQ
 jXJnxi+uWjYw==
X-IronPort-AV: E=McAfee;i="6000,8403,9912"; a="272407035"
X-IronPort-AV: E=Sophos;i="5.81,222,1610438400"; 
   d="scan'208";a="272407035"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2021 04:31:32 -0800
IronPort-SDR: ZMBkdcqeVaa10YyY/yZr1AIrzgTmoQQZDwHiDWdtyD+Gtlr8bxfEDcq5PHfQr4g/nh/b7cNXCh
 gzEIwyEztrZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,222,1610438400"; 
   d="scan'208";a="600508099"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga005.fm.intel.com with ESMTP; 04 Mar 2021 04:31:29 -0800
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id 729C83EA; Thu,  4 Mar 2021 14:31:26 +0200 (EET)
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     linux-usb@vger.kernel.org
Cc:     Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Andreas Noever <andreas.noever@gmail.com>,
        Isaac Hazan <isaac.hazan@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Lukas Wunner <lukas@wunner.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 07/18] thunderbolt: Use pseudo-random number as initial property block generation
Date:   Thu,  4 Mar 2021 15:31:14 +0300
Message-Id: <20210304123125.43630-8-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210304123125.43630-1-mika.westerberg@linux.intel.com>
References: <20210304123125.43630-1-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As recommended by USB4 inter-domain service spec use pseudo-random value
instead of zero as initial XDomain property block generation value.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/thunderbolt/xdomain.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/thunderbolt/xdomain.c b/drivers/thunderbolt/xdomain.c
index a1657663a95e..cfe6fa7e84f4 100644
--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -12,6 +12,7 @@
 #include <linux/kmod.h>
 #include <linux/module.h>
 #include <linux/pm_runtime.h>
+#include <linux/prandom.h>
 #include <linux/utsname.h>
 #include <linux/uuid.h>
 #include <linux/workqueue.h>
@@ -1880,6 +1881,7 @@ int tb_xdomain_init(void)
 	tb_property_add_immediate(xdomain_property_dir, "deviceid", 0x1);
 	tb_property_add_immediate(xdomain_property_dir, "devicerv", 0x80000100);
 
+	xdomain_property_block_gen = prandom_u32();
 	return 0;
 }
 
-- 
2.30.1

