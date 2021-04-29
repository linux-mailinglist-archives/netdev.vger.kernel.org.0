Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2535236E891
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 12:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239916AbhD2KUn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 06:20:43 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3095 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232629AbhD2KUj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 06:20:39 -0400
Received: from dggeml708-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FWBGc04XwzWcQ9;
        Thu, 29 Apr 2021 18:15:52 +0800 (CST)
Received: from dggpemm500008.china.huawei.com (7.185.36.136) by
 dggeml708-chm.china.huawei.com (10.3.17.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 29 Apr 2021 18:19:50 +0800
Received: from localhost (10.174.242.151) by dggpemm500008.china.huawei.com
 (7.185.36.136) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Thu, 29 Apr
 2021 18:19:50 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     <kuba@kernel.org>, <davem@davemloft.net>
CC:     <vyasevich@gmail.com>, <nhorman@tuxdriver.com>,
        <marcelo.leitner@gmail.com>, <linux-sctp@vger.kernel.org>,
        <netdev@vger.kernel.org>, <dingxiaoxiong@huawei.com>,
        Yunjian Wang <wangyunjian@huawei.com>
Subject: [PATCH net-next] sctp: Remove redundant skb_list null check
Date:   Thu, 29 Apr 2021 18:19:49 +0800
Message-ID: <1619691589-4776-1-git-send-email-wangyunjian@huawei.com>
X-Mailer: git-send-email 1.9.5.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.242.151]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500008.china.huawei.com (7.185.36.136)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunjian Wang <wangyunjian@huawei.com>

The skb_list cannot be NULL here since its already being accessed
before. Remove the redundant null check.

Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
---
 net/sctp/ulpqueue.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/sctp/ulpqueue.c b/net/sctp/ulpqueue.c
index 407fed46931b..6f3685f0e700 100644
--- a/net/sctp/ulpqueue.c
+++ b/net/sctp/ulpqueue.c
@@ -259,10 +259,7 @@ int sctp_ulpq_tail_event(struct sctp_ulpq *ulpq, struct sk_buff_head *skb_list)
 	return 1;
 
 out_free:
-	if (skb_list)
-		sctp_queue_purge_ulpevents(skb_list);
-	else
-		sctp_ulpevent_free(event);
+	sctp_queue_purge_ulpevents(skb_list);
 
 	return 0;
 }
-- 
2.23.0

