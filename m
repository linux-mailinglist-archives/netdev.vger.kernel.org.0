Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5C62D3E71
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 10:20:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728798AbgLIJU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 04:20:26 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9043 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726672AbgLIJU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 04:20:26 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CrWh82s2Kzhk7B;
        Wed,  9 Dec 2020 17:19:04 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.487.0; Wed, 9 Dec 2020 17:19:29 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     <kuba@kernel.org>, <linux-kernel@vger.kernel.org>,
        Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] net: emulex: benet: simplify the return expression of be_if_create()
Date:   Wed, 9 Dec 2020 17:19:57 +0800
Message-ID: <20201209091957.20203-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify the return expression.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/ethernet/emulex/benet/be_main.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index 676e437d78f6..d402d83d9edd 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -4677,7 +4677,6 @@ static int be_if_create(struct be_adapter *adapter)
 {
 	u32 en_flags = BE_IF_FLAGS_RSS | BE_IF_FLAGS_DEFQ_RSS;
 	u32 cap_flags = be_if_cap_flags(adapter);
-	int status;
 
 	/* alloc required memory for other filtering fields */
 	adapter->pmac_id = kcalloc(be_max_uc(adapter),
@@ -4700,13 +4699,8 @@ static int be_if_create(struct be_adapter *adapter)
 
 	en_flags &= cap_flags;
 	/* will enable all the needed filter flags in be_open() */
-	status = be_cmd_if_create(adapter, be_if_cap_flags(adapter), en_flags,
+	return be_cmd_if_create(adapter, be_if_cap_flags(adapter), en_flags,
 				  &adapter->if_handle, 0);
-
-	if (status)
-		return status;
-
-	return 0;
 }
 
 int be_update_queues(struct be_adapter *adapter)
-- 
2.22.0

