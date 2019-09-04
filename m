Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3597A78F9
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 04:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727914AbfIDCmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 22:42:16 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:5746 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727381AbfIDCmQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Sep 2019 22:42:16 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id F2AD8AE122B36680B73C;
        Wed,  4 Sep 2019 10:42:14 +0800 (CST)
Received: from linux-ibm.site (10.175.102.37) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.439.0; Wed, 4 Sep 2019 10:42:08 +0800
From:   zhong jiang <zhongjiang@huawei.com>
To:     <davem@davemloft.net>, <anna.schumaker@netapp.com>,
        <trond.myklebust@hammerspace.com>
CC:     <zhongjiang@huawei.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] net: mpoa: Use kzfree rather than its implementation.
Date:   Wed, 4 Sep 2019 10:39:12 +0800
Message-ID: <1567564752-6430-4-git-send-email-zhongjiang@huawei.com>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <1567564752-6430-1-git-send-email-zhongjiang@huawei.com>
References: <1567564752-6430-1-git-send-email-zhongjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.102.37]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use kzfree instead of memset() + kfree().

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 net/atm/mpoa_caches.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/atm/mpoa_caches.c b/net/atm/mpoa_caches.c
index 4bb4183..3286f9d 100644
--- a/net/atm/mpoa_caches.c
+++ b/net/atm/mpoa_caches.c
@@ -180,8 +180,7 @@ static int cache_hit(in_cache_entry *entry, struct mpoa_client *mpc)
 static void in_cache_put(in_cache_entry *entry)
 {
 	if (refcount_dec_and_test(&entry->use)) {
-		memset(entry, 0, sizeof(in_cache_entry));
-		kfree(entry);
+		kzfree(entry);
 	}
 }
 
@@ -416,8 +415,7 @@ static eg_cache_entry *eg_cache_get_by_src_ip(__be32 ipaddr,
 static void eg_cache_put(eg_cache_entry *entry)
 {
 	if (refcount_dec_and_test(&entry->use)) {
-		memset(entry, 0, sizeof(eg_cache_entry));
-		kfree(entry);
+		kzfree(entry);
 	}
 }
 
-- 
1.7.12.4

