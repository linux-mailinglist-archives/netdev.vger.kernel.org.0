Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 303C53A906A
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 06:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbhFPEYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 00:24:15 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:10084 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhFPEYO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 00:24:14 -0400
Received: from dggeme766-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G4X4q0PG1zZdXn;
        Wed, 16 Jun 2021 12:19:07 +0800 (CST)
Received: from huawei.com (10.175.104.82) by dggeme766-chm.china.huawei.com
 (10.3.19.112) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Wed, 16
 Jun 2021 12:22:00 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <shshaikh@marvell.com>,
        <manishc@marvell.com>
CC:     <GR-Linux-NIC-Dev@marvell.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] qlcnic: Use list_for_each_entry() to simplify code in qlcnic_main.c
Date:   Wed, 16 Jun 2021 12:21:06 +0800
Message-ID: <20210616042106.314433-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggeme766-chm.china.huawei.com (10.3.19.112)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert list_for_each() to list_for_each_entry() where
applicable. This simplifies the code.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
index 96b947fde646..8a31ce29ecfc 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
@@ -319,10 +319,8 @@ int qlcnic_read_mac_addr(struct qlcnic_adapter *adapter)
 static void qlcnic_delete_adapter_mac(struct qlcnic_adapter *adapter)
 {
 	struct qlcnic_mac_vlan_list *cur;
-	struct list_head *head;
 
-	list_for_each(head, &adapter->mac_list) {
-		cur = list_entry(head, struct qlcnic_mac_vlan_list, list);
+	list_for_each_entry(cur, &adapter->mac_list, list) {
 		if (ether_addr_equal_unaligned(adapter->mac_addr, cur->mac_addr)) {
 			qlcnic_sre_macaddr_change(adapter, cur->mac_addr,
 						  0, QLCNIC_MAC_DEL);
-- 
2.17.1

