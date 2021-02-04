Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7A730ED66
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 08:33:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234611AbhBDHcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 02:32:24 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:12397 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232977AbhBDHcW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 02:32:22 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DWVZP4q03z7f3s;
        Thu,  4 Feb 2021 15:30:21 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.498.0; Thu, 4 Feb 2021 15:31:31 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] net: Return the correct errno code
Date:   Thu, 4 Feb 2021 15:32:29 +0800
Message-ID: <20210204073229.18064-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When kalloc or kmemdup failed, should return ENOMEM rather than ENOBUF.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 net/mpls/af_mpls.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mpls/af_mpls.c b/net/mpls/af_mpls.c
index f2868a8a50c3..7e73611c48dd 100644
--- a/net/mpls/af_mpls.c
+++ b/net/mpls/af_mpls.c
@@ -1427,7 +1427,7 @@ static int mpls_dev_sysctl_register(struct net_device *dev,
 free:
 	kfree(table);
 out:
-	return -ENOBUFS;
+	return -ENOMEM;
 }
 
 static void mpls_dev_sysctl_unregister(struct net_device *dev,
-- 
2.22.0

