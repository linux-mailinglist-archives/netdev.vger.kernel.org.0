Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60FE326FDC7
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 15:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbgIRNFM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 09:05:12 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:13262 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726672AbgIRNFJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 09:05:09 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id D37D17E9AFEE64CA1AD0;
        Fri, 18 Sep 2020 21:05:06 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.487.0; Fri, 18 Sep 2020
 21:05:05 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <dchickles@marvell.com>, <sburla@marvell.com>,
        <fmanlunas@marvell.com>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] liquidio: Fix -Wmissing-prototypes warnings for liquidio
Date:   Fri, 18 Sep 2020 21:02:10 +0800
Message-ID: <20200918130210.16902-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.113.133]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the header file containing a function's prototype isn't included by
the sourcefile containing the associated function, the build system
complains of missing prototypes.

Fixes the following W=1 kernel build warning(s):

drivers/net/ethernet/cavium/liquidio/cn68xx_device.c:124:5: warning: no previous prototype for ‘lio_setup_cn68xx_octeon_device’ [-Wmissing-prototypes]
drivers/net/ethernet/cavium/liquidio/octeon_mem_ops.c:159:1: warning: no previous prototype for ‘octeon_pci_read_core_mem’ [-Wmissing-prototypes]
drivers/net/ethernet/cavium/liquidio/octeon_mem_ops.c:168:1: warning: no previous prototype for ‘octeon_pci_write_core_mem’ [-Wmissing-prototypes]
drivers/net/ethernet/cavium/liquidio/octeon_mem_ops.c:176:5: warning: no previous prototype for ‘octeon_read_device_mem64’ [-Wmissing-prototypes]
drivers/net/ethernet/cavium/liquidio/octeon_mem_ops.c:185:5: warning: no previous prototype for ‘octeon_read_device_mem32’ [-Wmissing-prototypes]
drivers/net/ethernet/cavium/liquidio/octeon_mem_ops.c:194:6: warning: no previous prototype for ‘octeon_write_device_mem32’ [-Wmissing-prototypes]

Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 drivers/net/ethernet/cavium/liquidio/cn68xx_device.c  | 1 +
 drivers/net/ethernet/cavium/liquidio/octeon_mem_ops.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/cavium/liquidio/cn68xx_device.c b/drivers/net/ethernet/cavium/liquidio/cn68xx_device.c
index 50b533ff58e6..cd5d5d6e7e5e 100644
--- a/drivers/net/ethernet/cavium/liquidio/cn68xx_device.c
+++ b/drivers/net/ethernet/cavium/liquidio/cn68xx_device.c
@@ -26,6 +26,7 @@
 #include "cn66xx_regs.h"
 #include "cn66xx_device.h"
 #include "cn68xx_regs.h"
+#include "cn68xx_device.h"
 
 static void lio_cn68xx_set_dpi_regs(struct octeon_device *oct)
 {
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
 
-- 
2.17.1

