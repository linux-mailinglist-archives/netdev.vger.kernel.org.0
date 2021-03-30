Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC3E434E7F2
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 14:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232002AbhC3Mwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 08:52:55 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:15827 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232023AbhC3Mwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 08:52:30 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4F8q6l0tKnz9tNK;
        Tue, 30 Mar 2021 20:50:23 +0800 (CST)
Received: from huawei.com (10.175.103.91) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.498.0; Tue, 30 Mar 2021
 20:52:22 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>
Subject: [PATCH -next] net: mhi: remove pointless conditional before kfree_skb()
Date:   Tue, 30 Mar 2021 20:55:39 +0800
Message-ID: <20210330125539.1049093-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It already has null pointer check in kfree_skb(),
remove pointless pointer check before kfree_skb().

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/mhi/net.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/mhi/net.c b/drivers/net/mhi/net.c
index f59960876083..8b44c674db1b 100644
--- a/drivers/net/mhi/net.c
+++ b/drivers/net/mhi/net.c
@@ -359,8 +359,7 @@ static void mhi_net_remove(struct mhi_device *mhi_dev)
 
 	mhi_unprepare_from_transfer(mhi_netdev->mdev);
 
-	if (mhi_netdev->skbagg_head)
-		kfree_skb(mhi_netdev->skbagg_head);
+	kfree_skb(mhi_netdev->skbagg_head);
 
 	free_netdev(mhi_netdev->ndev);
 }
-- 
2.25.1

