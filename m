Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3D3A265695
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 03:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725779AbgIKBYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 21:24:03 -0400
Received: from mga03.intel.com ([134.134.136.65]:44532 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725294AbgIKBXr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 21:23:47 -0400
IronPort-SDR: 85t8z/elK16myxNqHlOVvtx3iJHB9LIFeGLxUNa6YrTdDDErYauAIB1iO/DVQEMyyQNuyd29sd
 47wp7p1aVhnw==
X-IronPort-AV: E=McAfee;i="6000,8403,9740"; a="158704643"
X-IronPort-AV: E=Sophos;i="5.76,413,1592895600"; 
   d="scan'208";a="158704643"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2020 18:23:46 -0700
IronPort-SDR: XoZoVaqVGq7OgLd+vgcp7Tq8ViOYy9lBwmRdumEVoL43gCqpSHK/U9xQz+ySCqPt4p0LMRoBy9
 3vgIEFpHjEEQ==
X-IronPort-AV: E=Sophos;i="5.76,413,1592895600"; 
   d="scan'208";a="449808151"
Received: from jbrandeb-desk.jf.intel.com ([10.166.244.152])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2020 18:23:45 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        intel-wired-lan@lists.osuosl.org
Subject: [RFC PATCH net-next v1 07/11] drivers/net/ethernet: rid ethernet of no-prototype warnings
Date:   Thu, 10 Sep 2020 18:23:33 -0700
Message-Id: <20200911012337.14015-8-jesse.brandeburg@intel.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200911012337.14015-1-jesse.brandeburg@intel.com>
References: <20200911012337.14015-1-jesse.brandeburg@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The W=1 builds showed a few files exporting functions
(non-static) that were not prototyped. What actually happened is
that there were prototypes, but the include file was forgotten in
the implementation file.

Add the include file and remove the warnings.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 drivers/net/ethernet/cavium/liquidio/cn68xx_device.c   | 1 +
 drivers/net/ethernet/cavium/liquidio/octeon_mem_ops.c  | 1 +
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c | 1 +
 3 files changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/cavium/liquidio/cn68xx_device.c b/drivers/net/ethernet/cavium/liquidio/cn68xx_device.c
index 50b533ff58e6..30254e4cf70f 100644
--- a/drivers/net/ethernet/cavium/liquidio/cn68xx_device.c
+++ b/drivers/net/ethernet/cavium/liquidio/cn68xx_device.c
@@ -25,6 +25,7 @@
 #include "octeon_main.h"
 #include "cn66xx_regs.h"
 #include "cn66xx_device.h"
+#include "cn68xx_device.h"
 #include "cn68xx_regs.h"
 
 static void lio_cn68xx_set_dpi_regs(struct octeon_device *oct)
diff --git a/drivers/net/ethernet/cavium/liquidio/octeon_mem_ops.c b/drivers/net/ethernet/cavium/liquidio/octeon_mem_ops.c
index 4c85ae643b7b..7ccab36143c1 100644
--- a/drivers/net/ethernet/cavium/liquidio/octeon_mem_ops.c
+++ b/drivers/net/ethernet/cavium/liquidio/octeon_mem_ops.c
@@ -22,6 +22,7 @@
 #include "octeon_iq.h"
 #include "response_manager.h"
 #include "octeon_device.h"
+#include "octeon_mem_ops.h"
 
 #define MEMOPS_IDX   BAR1_INDEX_DYNAMIC_MAP
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
index d6c3952aba04..f28b8f3df857 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
@@ -3,6 +3,7 @@
 
 #include "hclge_main.h"
 #include "hclge_tm.h"
+#include "hclge_dcb.h"
 #include "hnae3.h"
 
 #define BW_PERCENT	100
-- 
2.27.0

