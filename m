Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83FB71B08D3
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 14:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbgDTMId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 08:08:33 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:34732 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726470AbgDTMIc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 08:08:32 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id C46F9895216008B9E491;
        Mon, 20 Apr 2020 20:08:30 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.487.0; Mon, 20 Apr 2020
 20:08:24 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <jeffrey.t.kirsher@intel.com>, <davem@davemloft.net>,
        <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>
Subject: [PATCH] e1000: remove unneeded conversion to bool
Date:   Mon, 20 Apr 2020 20:35:06 +0800
Message-ID: <20200420123506.7716-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The '==' expression itself is bool, no need to convert it to bool again.
This fixes the following coccicheck warning:

drivers/net/ethernet/intel/e1000/e1000_main.c:1479:44-49: WARNING:
conversion to bool not needed here

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/net/ethernet/intel/e1000/e1000_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index ac5146d53c4c..05bc6e216bca 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -1476,7 +1476,7 @@ static bool e1000_check_64k_bound(struct e1000_adapter *adapter, void *start,
 	if (hw->mac_type == e1000_82545 ||
 	    hw->mac_type == e1000_ce4100 ||
 	    hw->mac_type == e1000_82546) {
-		return ((begin ^ (end - 1)) >> 16) != 0 ? false : true;
+		return ((begin ^ (end - 1)) >> 16) == 0;
 	}
 
 	return true;
-- 
2.21.1

