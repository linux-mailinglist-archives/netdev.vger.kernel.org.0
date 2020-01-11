Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62AE2137C6D
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 09:34:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728653AbgAKIeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 03:34:03 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:36816 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728637AbgAKIeD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Jan 2020 03:34:03 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 8C23FF10B66F0E865EA5;
        Sat, 11 Jan 2020 16:34:01 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.439.0; Sat, 11 Jan 2020 16:33:54 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 5/7] net: hns3: enlarge HCLGE_RESET_WAIT_CNT
Date:   Sat, 11 Jan 2020 16:33:51 +0800
Message-ID: <1578731633-10709-6-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1578731633-10709-1-git-send-email-tanhuazhong@huawei.com>
References: <1578731633-10709-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the load of firmware is high, its reset task may takes
more time(which will be as long as 35 seconds). So this
patch modifies HCLGE_RESET_WAIT_CNT to match the firmware's.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 89621b5..d81c976 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -3260,7 +3260,8 @@ static int hclge_notify_roce_client(struct hclge_dev *hdev,
 static int hclge_reset_wait(struct hclge_dev *hdev)
 {
 #define HCLGE_RESET_WATI_MS	100
-#define HCLGE_RESET_WAIT_CNT	200
+#define HCLGE_RESET_WAIT_CNT	350
+
 	u32 val, reg, reg_bit;
 	u32 cnt = 0;
 
-- 
2.7.4

