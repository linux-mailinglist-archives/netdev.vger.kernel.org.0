Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D867C1CBFCB
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 11:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727993AbgEIJ25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 05:28:57 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4376 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726946AbgEIJ24 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 05:28:56 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 4EC35A1440E92959CC12;
        Sat,  9 May 2020 17:28:55 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.487.0; Sat, 9 May 2020 17:28:49 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 2/5] net: hns3: modify two uncorrect macro names
Date:   Sat, 9 May 2020 17:27:38 +0800
Message-ID: <1589016461-10130-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1589016461-10130-1-git-send-email-tanhuazhong@huawei.com>
References: <1589016461-10130-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to the UM, command 0x0B03 and 0x0B13 are used to
query the statistics about TX and RX, not the status, so
modifies the unsuitable macro name of these two command.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h  | 4 ++--
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 9a9d752..e3bab8f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -184,11 +184,11 @@ enum hclge_opcode_type {
 	/* TQP commands */
 	HCLGE_OPC_CFG_TX_QUEUE		= 0x0B01,
 	HCLGE_OPC_QUERY_TX_POINTER	= 0x0B02,
-	HCLGE_OPC_QUERY_TX_STATUS	= 0x0B03,
+	HCLGE_OPC_QUERY_TX_STATS	= 0x0B03,
 	HCLGE_OPC_TQP_TX_QUEUE_TC	= 0x0B04,
 	HCLGE_OPC_CFG_RX_QUEUE		= 0x0B11,
 	HCLGE_OPC_QUERY_RX_POINTER	= 0x0B12,
-	HCLGE_OPC_QUERY_RX_STATUS	= 0x0B13,
+	HCLGE_OPC_QUERY_RX_STATS	= 0x0B13,
 	HCLGE_OPC_STASH_RX_QUEUE_LRO	= 0x0B16,
 	HCLGE_OPC_CFG_RX_QUEUE_LRO	= 0x0B17,
 	HCLGE_OPC_CFG_COM_TQP_QUEUE	= 0x0B20,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index f0b1dc9..3ad6a6a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -552,7 +552,7 @@ static int hclge_tqps_update_stats(struct hnae3_handle *handle)
 		queue = handle->kinfo.tqp[i];
 		tqp = container_of(queue, struct hclge_tqp, q);
 		/* command : HCLGE_OPC_QUERY_IGU_STAT */
-		hclge_cmd_setup_basic_desc(&desc[0], HCLGE_OPC_QUERY_RX_STATUS,
+		hclge_cmd_setup_basic_desc(&desc[0], HCLGE_OPC_QUERY_RX_STATS,
 					   true);
 
 		desc[0].data[0] = cpu_to_le32((tqp->index & 0x1ff));
@@ -572,7 +572,7 @@ static int hclge_tqps_update_stats(struct hnae3_handle *handle)
 		tqp = container_of(queue, struct hclge_tqp, q);
 		/* command : HCLGE_OPC_QUERY_IGU_STAT */
 		hclge_cmd_setup_basic_desc(&desc[0],
-					   HCLGE_OPC_QUERY_TX_STATUS,
+					   HCLGE_OPC_QUERY_TX_STATS,
 					   true);
 
 		desc[0].data[0] = cpu_to_le32((tqp->index & 0x1ff));
-- 
2.7.4

