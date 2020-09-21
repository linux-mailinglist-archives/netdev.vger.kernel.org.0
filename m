Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CAC7272520
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 15:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727496AbgIUNOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 09:14:23 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:13799 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727102AbgIUNJz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 09:09:55 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 65A39CAC0A471D010BDA;
        Mon, 21 Sep 2020 21:09:52 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Mon, 21 Sep 2020 21:09:42 +0800
From:   Qinglang Miao <miaoqinglang@huawei.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Qinglang Miao <miaoqinglang@huawei.com>
Subject: [PATCH -next] connector: simplify the return expression of cn_add_callback()
Date:   Mon, 21 Sep 2020 21:10:06 +0800
Message-ID: <20200921131006.91100-1-miaoqinglang@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify the return expression.

Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
---
 drivers/connector/connector.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/connector/connector.c b/drivers/connector/connector.c
index 2d22d6bf5..7d59d18c6 100644
--- a/drivers/connector/connector.c
+++ b/drivers/connector/connector.c
@@ -197,17 +197,12 @@ int cn_add_callback(struct cb_id *id, const char *name,
 		    void (*callback)(struct cn_msg *,
 				     struct netlink_skb_parms *))
 {
-	int err;
 	struct cn_dev *dev = &cdev;
 
 	if (!cn_already_initialized)
 		return -EAGAIN;
 
-	err = cn_queue_add_callback(dev->cbdev, name, id, callback);
-	if (err)
-		return err;
-
-	return 0;
+	return cn_queue_add_callback(dev->cbdev, name, id, callback);
 }
 EXPORT_SYMBOL_GPL(cn_add_callback);
 
-- 
2.23.0

