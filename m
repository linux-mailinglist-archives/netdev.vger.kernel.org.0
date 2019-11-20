Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0548103163
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 03:07:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727407AbfKTCG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 21:06:57 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:40104 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727082AbfKTCG5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Nov 2019 21:06:57 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 0E84D99C2FC016237E10;
        Wed, 20 Nov 2019 10:06:55 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.439.0; Wed, 20 Nov 2019 10:06:47 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net] net: hns3: fix a wrong reset interrupt status mask
Date:   Wed, 20 Nov 2019 10:07:15 +0800
Message-ID: <1574215635-43836-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to hardware user manual, bits5~7 in register
HCLGE_MISC_VECTOR_INT_STS means reset interrupts status,
but HCLGE_RESET_INT_M is defined as bits0~2 now. So it
will make hclge_reset_err_handle() read the wrong reset
interrupt status.

This patch fixes this wrong bit mask.

Fixes: 2336f19d7892 ("net: hns3: check reset interrupt status when reset fails")
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
Change log:
V1->V2: fixes comment from David Miller.
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 59b8243..615cde1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -166,7 +166,7 @@ enum HLCGE_PORT_TYPE {
 #define HCLGE_GLOBAL_RESET_BIT		0
 #define HCLGE_CORE_RESET_BIT		1
 #define HCLGE_IMP_RESET_BIT		2
-#define HCLGE_RESET_INT_M		GENMASK(2, 0)
+#define HCLGE_RESET_INT_M		GENMASK(7, 5)
 #define HCLGE_FUN_RST_ING		0x20C00
 #define HCLGE_FUN_RST_ING_B		0
 
-- 
2.7.4

