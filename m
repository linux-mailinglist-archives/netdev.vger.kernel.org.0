Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C32621E343B
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 03:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727878AbgE0BAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 21:00:47 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5343 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727811AbgE0BAp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 21:00:45 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id DA0EFCB0F61D4C4A5F25;
        Wed, 27 May 2020 09:00:41 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Wed, 27 May 2020 09:00:34 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 3/4] net: hns3: remove unnecessary MAC enable in app loopback
Date:   Wed, 27 May 2020 08:59:16 +0800
Message-ID: <1590541157-6803-4-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1590541157-6803-1-git-send-email-tanhuazhong@huawei.com>
References: <1590541157-6803-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

Packets will not pass through MAC during app loopback.
Therefore, it is meaningless to enable MAC while doing
app loopback. This patch removes this unnecessary action.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 6e1e2cf..7c9f2ba 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -6583,8 +6583,6 @@ static int hclge_set_app_loopback(struct hclge_dev *hdev, bool en)
 	/* 2 Then setup the loopback flag */
 	loop_en = le32_to_cpu(req->txrx_pad_fcs_loop_en);
 	hnae3_set_bit(loop_en, HCLGE_MAC_APP_LP_B, en ? 1 : 0);
-	hnae3_set_bit(loop_en, HCLGE_MAC_TX_EN_B, en ? 1 : 0);
-	hnae3_set_bit(loop_en, HCLGE_MAC_RX_EN_B, en ? 1 : 0);
 
 	req->txrx_pad_fcs_loop_en = cpu_to_le32(loop_en);
 
-- 
2.7.4

