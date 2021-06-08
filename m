Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6211B39EFFC
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 09:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230324AbhFHH46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 03:56:58 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:5285 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbhFHH4z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 03:56:55 -0400
Received: from dggeme766-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Fzj824vlmz1BJZr;
        Tue,  8 Jun 2021 15:50:10 +0800 (CST)
Received: from huawei.com (10.175.113.133) by dggeme766-chm.china.huawei.com
 (10.3.19.112) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Tue, 8 Jun
 2021 15:55:00 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <ms@dev.tdt.de>
CC:     <linux-x25@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] net: x25: Use list_for_each_entry() to simplify code in x25_link.c
Date:   Tue, 8 Jun 2021 08:05:05 +0000
Message-ID: <20210608080505.32466-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
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
 net/x25/x25_link.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/x25/x25_link.c b/net/x25/x25_link.c
index 57a81100c5da..5460b9146dd8 100644
--- a/net/x25/x25_link.c
+++ b/net/x25/x25_link.c
@@ -332,12 +332,9 @@ void x25_link_device_down(struct net_device *dev)
 struct x25_neigh *x25_get_neigh(struct net_device *dev)
 {
 	struct x25_neigh *nb, *use = NULL;
-	struct list_head *entry;
 
 	read_lock_bh(&x25_neigh_list_lock);
-	list_for_each(entry, &x25_neigh_list) {
-		nb = list_entry(entry, struct x25_neigh, node);
-
+	list_for_each_entry(nb, &x25_neigh_list, node) {
 		if (nb->dev == dev) {
 			use = nb;
 			break;
-- 
2.17.1

