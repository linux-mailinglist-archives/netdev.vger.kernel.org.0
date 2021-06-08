Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B615939F05B
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 10:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbhFHIEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 04:04:52 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:8078 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbhFHIEw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 04:04:52 -0400
Received: from dggeme766-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FzjMX33YlzYqb4;
        Tue,  8 Jun 2021 16:00:08 +0800 (CST)
Received: from huawei.com (10.175.113.133) by dggeme766-chm.china.huawei.com
 (10.3.19.112) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Tue, 8 Jun
 2021 16:02:57 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <ms@dev.tdt.de>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux-x25@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] net: lapb: Use list_for_each_entry() to simplify code in lapb_iface.c
Date:   Tue, 8 Jun 2021 08:13:01 +0000
Message-ID: <20210608081301.15264-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
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
 net/lapb/lapb_iface.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/lapb/lapb_iface.c b/net/lapb/lapb_iface.c
index 1078e14f1acf..0971ca48ba15 100644
--- a/net/lapb/lapb_iface.c
+++ b/net/lapb/lapb_iface.c
@@ -80,11 +80,9 @@ static void __lapb_insert_cb(struct lapb_cb *lapb)
 
 static struct lapb_cb *__lapb_devtostruct(struct net_device *dev)
 {
-	struct list_head *entry;
 	struct lapb_cb *lapb, *use = NULL;
 
-	list_for_each(entry, &lapb_list) {
-		lapb = list_entry(entry, struct lapb_cb, node);
+	list_for_each_entry(lapb, &lapb_list, node) {
 		if (lapb->dev == dev) {
 			use = lapb;
 			break;
-- 
2.17.1

