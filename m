Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43DC31B08EF
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 14:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726850AbgDTMLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 08:11:15 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:58936 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726262AbgDTMLP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 08:11:15 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 45F981E40B820A929010;
        Mon, 20 Apr 2020 20:11:13 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.487.0; Mon, 20 Apr 2020
 20:11:03 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <kvalo@codeaurora.org>, <davem@davemloft.net>,
        <colin.king@canonical.com>, <ath11k@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>
Subject: [PATCH] ath11k: remove conversion to bool in ath11k_debug_fw_stats_process()
Date:   Mon, 20 Apr 2020 20:37:45 +0800
Message-ID: <20200420123745.4159-1-yanaijie@huawei.com>
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

drivers/net/wireless/ath/ath11k/debug.c:198:57-62: WARNING: conversion
to bool not needed here
drivers/net/wireless/ath/ath11k/debug.c:218:58-63: WARNING: conversion
to bool not needed here

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/net/wireless/ath/ath11k/debug.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/debug.c b/drivers/net/wireless/ath/ath11k/debug.c
index 8d485171b0b3..69db298e16fb 100644
--- a/drivers/net/wireless/ath/ath11k/debug.c
+++ b/drivers/net/wireless/ath/ath11k/debug.c
@@ -195,7 +195,7 @@ void ath11k_debug_fw_stats_process(struct ath11k_base *ab, struct sk_buff *skb)
 				total_vdevs_started += ar->num_started_vdevs;
 		}
 
-		is_end = ((++num_vdev) == total_vdevs_started ? true : false);
+		is_end = ((++num_vdev) == total_vdevs_started);
 
 		list_splice_tail_init(&stats.vdevs,
 				      &ar->debug.fw_stats.vdevs);
@@ -215,7 +215,7 @@ void ath11k_debug_fw_stats_process(struct ath11k_base *ab, struct sk_buff *skb)
 		/* Mark end until we reached the count of all started VDEVs
 		 * within the PDEV
 		 */
-		is_end = ((++num_bcn) == ar->num_started_vdevs ? true : false);
+		is_end = ((++num_bcn) == ar->num_started_vdevs);
 
 		list_splice_tail_init(&stats.bcn,
 				      &ar->debug.fw_stats.bcn);
-- 
2.21.1

