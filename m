Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 085AB39F62C
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 14:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232312AbhFHMRf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 08:17:35 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:8091 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231560AbhFHMRe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 08:17:34 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Fzpz74fQwzYrfZ;
        Tue,  8 Jun 2021 20:12:51 +0800 (CST)
Received: from dggemi762-chm.china.huawei.com (10.1.198.148) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 8 Jun 2021 20:15:40 +0800
Received: from linux-lmwb.huawei.com (10.175.103.112) by
 dggemi762-chm.china.huawei.com (10.1.198.148) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 8 Jun 2021 20:15:40 +0800
From:   Zou Wei <zou_wei@huawei.com>
To:     <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <intel-wired-lan@lists.osuosl.or>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Zou Wei <zou_wei@huawei.com>
Subject: [PATCH net-next] ixgbe: Convert list_for_each to entry variant
Date:   Tue, 8 Jun 2021 20:34:16 +0800
Message-ID: <1623155656-61873-1-git-send-email-zou_wei@huawei.com>
X-Mailer: git-send-email 2.6.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.103.112]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggemi762-chm.china.huawei.com (10.1.198.148)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

convert list_for_each() to list_for_each_entry() where
applicable.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
index 214a38d..9fa7bef 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
@@ -635,12 +635,10 @@ static int ixgbe_set_vf_macvlan(struct ixgbe_adapter *adapter,
 				int vf, int index, unsigned char *mac_addr)
 {
 	struct vf_macvlans *entry;
-	struct list_head *pos;
 	int retval = 0;
 
 	if (index <= 1) {
-		list_for_each(pos, &adapter->vf_mvs.l) {
-			entry = list_entry(pos, struct vf_macvlans, l);
+		list_for_each_entry(entry, &adapter->vf_mvs.l, l) {
 			if (entry->vf == vf) {
 				entry->vf = -1;
 				entry->free = true;
@@ -660,8 +658,7 @@ static int ixgbe_set_vf_macvlan(struct ixgbe_adapter *adapter,
 
 	entry = NULL;
 
-	list_for_each(pos, &adapter->vf_mvs.l) {
-		entry = list_entry(pos, struct vf_macvlans, l);
+	list_for_each_entry(entry, &adapter->vf_mvs.l, l) {
 		if (entry->free)
 			break;
 	}
-- 
2.6.2

