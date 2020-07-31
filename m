Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6C452343B2
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 11:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732413AbgGaJuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 05:50:06 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:8744 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732134AbgGaJuF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 05:50:05 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id B63862F8C1D4E834E11B;
        Fri, 31 Jul 2020 17:50:00 +0800 (CST)
Received: from huawei.com (10.174.28.241) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.487.0; Fri, 31 Jul 2020
 17:49:55 +0800
From:   Bixuan Cui <cuibixuan@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <jeffrey.t.kirsher@intel.com>, <intel-wired-lan@lists.osuosl.org>,
        <netdev@vger.kernel.org>, <linux-next@vger.kernel.org>
Subject: [PATCH -next] net: ice: Fix pointer cast warnings
Date:   Fri, 31 Jul 2020 18:57:21 +0800
Message-ID: <20200731105721.18511-1-cuibixuan@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.28.241]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pointers should be casted to unsigned long to avoid
-Wpointer-to-int-cast warnings:

drivers/net/ethernet/intel/ice/ice_flow.h:197:33: warning:
    cast from pointer to integer of different size

Signed-off-by: Bixuan Cui <cuibixuan@huawei.com>
---
 drivers/net/ethernet/intel/ice/ice_flow.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_flow.h b/drivers/net/ethernet/intel/ice/ice_flow.h
index 3913da2116d2..b9a5c208e484 100644
--- a/drivers/net/ethernet/intel/ice/ice_flow.h
+++ b/drivers/net/ethernet/intel/ice/ice_flow.h
@@ -194,7 +194,7 @@ struct ice_flow_entry {
 	u16 entry_sz;
 };

-#define ICE_FLOW_ENTRY_HNDL(e)	((u64)e)
+#define ICE_FLOW_ENTRY_HNDL(e)	((uintptr_t)e)
 #define ICE_FLOW_ENTRY_PTR(h)	((struct ice_flow_entry *)(h))

 struct ice_flow_prof {
--
2.17.1

