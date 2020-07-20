Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCA92225A01
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 10:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbgGTI0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 04:26:35 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:33636 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727863AbgGTI0f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 04:26:35 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 00BE0729A02F365A998C;
        Mon, 20 Jul 2020 16:26:33 +0800 (CST)
Received: from huawei.com (10.175.101.6) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Mon, 20 Jul 2020
 16:26:25 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <jeffrey.t.kirsher@intel.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linmiaohe@huawei.com>
Subject: [PATCH] igb: use eth_zero_addr() to clear mac address
Date:   Mon, 20 Jul 2020 16:29:14 +0800
Message-ID: <1595233754-13765-1-git-send-email-linmiaohe@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

Use eth_zero_addr() to clear mac address insetad of memset().

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 8bb3db2cbd41..adedd98f1e3e 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -7168,7 +7168,7 @@ static void igb_flush_mac_table(struct igb_adapter *adapter)
 
 	for (i = 0; i < hw->mac.rar_entry_count; i++) {
 		adapter->mac_table[i].state &= ~IGB_MAC_STATE_IN_USE;
-		memset(adapter->mac_table[i].addr, 0, ETH_ALEN);
+		eth_zero_addr(adapter->mac_table[i].addr);
 		adapter->mac_table[i].queue = 0;
 		igb_rar_set_index(adapter, i);
 	}
@@ -7317,7 +7317,7 @@ static int igb_del_mac_filter_flags(struct igb_adapter *adapter,
 		} else {
 			adapter->mac_table[i].state = 0;
 			adapter->mac_table[i].queue = 0;
-			memset(adapter->mac_table[i].addr, 0, ETH_ALEN);
+			eth_zero_addr(adapter->mac_table[i].addr);
 		}
 
 		igb_rar_set_index(adapter, i);
-- 
2.19.1

