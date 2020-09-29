Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B67027C154
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 11:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728070AbgI2Jex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 05:34:53 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14770 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727841AbgI2Jew (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 05:34:52 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 8FBACE67106B21A83471;
        Tue, 29 Sep 2020 17:34:50 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.487.0; Tue, 29 Sep 2020 17:34:44 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 2/7] net: hns3: rename trace event hns3_over_8bd
Date:   Tue, 29 Sep 2020 17:32:00 +0800
Message-ID: <1601371925-49426-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1601371925-49426-1-git-send-email-tanhuazhong@huawei.com>
References: <1601371925-49426-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the maximun BD number may not be 8 now, so rename
hns3_over_8bd() to hns3_over_max_bd().

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c  | 4 ++--
 drivers/net/ethernet/hisilicon/hns3/hns3_trace.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index a393755..df52abb 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1283,7 +1283,7 @@ static int hns3_nic_maybe_stop_tx(struct hns3_enet_ring *ring,
 		if (bd_num <= HNS3_MAX_TSO_BD_NUM && skb_is_gso(skb) &&
 		    !hns3_skb_need_linearized(skb, bd_size, bd_num,
 					      max_non_tso_bd_num)) {
-			trace_hns3_over_8bd(skb);
+			trace_hns3_over_max_bd(skb);
 			goto out;
 		}
 
@@ -1294,7 +1294,7 @@ static int hns3_nic_maybe_stop_tx(struct hns3_enet_ring *ring,
 		if ((skb_is_gso(skb) && bd_num > HNS3_MAX_TSO_BD_NUM) ||
 		    (!skb_is_gso(skb) &&
 		     bd_num > max_non_tso_bd_num)) {
-			trace_hns3_over_8bd(skb);
+			trace_hns3_over_max_bd(skb);
 			return -ENOMEM;
 		}
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_trace.h b/drivers/net/ethernet/hisilicon/hns3/hns3_trace.h
index 7bddcca..5153e5d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_trace.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_trace.h
@@ -53,7 +53,7 @@ DECLARE_EVENT_CLASS(hns3_skb_template,
 	)
 );
 
-DEFINE_EVENT(hns3_skb_template, hns3_over_8bd,
+DEFINE_EVENT(hns3_skb_template, hns3_over_max_bd,
 	TP_PROTO(struct sk_buff *skb),
 	TP_ARGS(skb));
 
-- 
2.7.4

