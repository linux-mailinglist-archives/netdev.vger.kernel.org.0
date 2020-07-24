Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27B5622C700
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 15:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbgGXNsc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 09:48:32 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:34058 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726235AbgGXNsc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jul 2020 09:48:32 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 3035D55B06DFD5CAED3A;
        Fri, 24 Jul 2020 21:48:11 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.487.0; Fri, 24 Jul 2020
 21:48:03 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] net: hix5hd2_gmac: Remove unneeded cast from memory allocation
Date:   Fri, 24 Jul 2020 21:46:30 +0800
Message-ID: <20200724134630.15415-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove casting the values returned by memory allocation function.

Coccinelle emits WARNING:

./drivers/net/ethernet/hisilicon/hix5hd2_gmac.c:1027:9-23: WARNING:
 casting value returned by memory allocation function to (struct sg_desc *) is useless.

This issue was detected by using the Coccinelle software.

Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
index 4fb776920..8b2bf8503 100644
--- a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
+++ b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
@@ -1024,9 +1024,9 @@ static int hix5hd2_init_sg_desc_queue(struct hix5hd2_priv *priv)
 	struct sg_desc *desc;
 	dma_addr_t phys_addr;
 
-	desc = (struct sg_desc *)dma_alloc_coherent(priv->dev,
-				TX_DESC_NUM * sizeof(struct sg_desc),
-				&phys_addr, GFP_KERNEL);
+	desc = dma_alloc_coherent(priv->dev,
+				  TX_DESC_NUM * sizeof(struct sg_desc),
+				  &phys_addr, GFP_KERNEL);
 	if (!desc)
 		return -ENOMEM;
 
-- 
2.17.1

