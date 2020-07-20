Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C438F2259F5
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 10:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbgGTIZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 04:25:05 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:7791 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725815AbgGTIZE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 04:25:04 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 6B24CB213EBCD4C9FABF;
        Mon, 20 Jul 2020 16:25:02 +0800 (CST)
Received: from huawei.com (10.175.101.6) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.487.0; Mon, 20 Jul 2020
 16:24:52 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <jeffrey.t.kirsher@intel.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linmiaohe@huawei.com>
Subject: [PATCH] ixgbe: use eth_zero_addr() to clear mac address
Date:   Mon, 20 Jul 2020 16:27:41 +0800
Message-ID: <1595233661-13699-1-git-send-email-linmiaohe@huawei.com>
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
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
index d05a5690e66b..6e9097a0a36f 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
@@ -783,7 +783,7 @@ static int ixgbe_set_vf_mac(struct ixgbe_adapter *adapter,
 		memcpy(adapter->vfinfo[vf].vf_mac_addresses, mac_addr,
 		       ETH_ALEN);
 	else
-		memset(adapter->vfinfo[vf].vf_mac_addresses, 0, ETH_ALEN);
+		eth_zero_addr(adapter->vfinfo[vf].vf_mac_addresses);
 
 	return retval;
 }
-- 
2.19.1

