Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0B591C4F7D
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 09:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728552AbgEEHqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 03:46:35 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3789 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725320AbgEEHqf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 03:46:35 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 5A36C1C6834D5782B0F1;
        Tue,  5 May 2020 15:46:30 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0; Tue, 5 May 2020
 15:46:23 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <jcliburn@gmail.com>, <chris.snook@gmail.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>
Subject: [PATCH net-next] net: atheros: remove conversion to bool in atl1c_start_mac()
Date:   Tue, 5 May 2020 15:45:46 +0800
Message-ID: <20200505074546.22247-1-yanaijie@huawei.com>
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

No need to convert '==' expression to bool. This fixes the following
coccicheck warning:

drivers/net/ethernet/atheros/atl1c/atl1c_main.c:1189:63-68: WARNING:
conversion to bool not needed here

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index 00bd7bd55794..04bc53af12d9 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -1186,7 +1186,7 @@ static void atl1c_start_mac(struct atl1c_adapter *adapter)
 	struct atl1c_hw *hw = &adapter->hw;
 	u32 mac, txq, rxq;
 
-	hw->mac_duplex = adapter->link_duplex == FULL_DUPLEX ? true : false;
+	hw->mac_duplex = adapter->link_duplex == FULL_DUPLEX;
 	hw->mac_speed = adapter->link_speed == SPEED_1000 ?
 		atl1c_mac_speed_1000 : atl1c_mac_speed_10_100;
 
-- 
2.21.1

