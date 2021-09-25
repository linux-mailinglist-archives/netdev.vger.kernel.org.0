Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E02A41826D
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 15:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245691AbhIYNmB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 09:42:01 -0400
Received: from mx22.baidu.com ([220.181.50.185]:50162 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245603AbhIYNmA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Sep 2021 09:42:00 -0400
Received: from BC-Mail-Ex11.internal.baidu.com (unknown [172.31.51.51])
        by Forcepoint Email with ESMTPS id 58FE0390121CA6420987;
        Sat, 25 Sep 2021 21:40:22 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BC-Mail-Ex11.internal.baidu.com (172.31.51.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.12; Sat, 25 Sep 2021 21:40:22 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.63.8) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Sat, 25 Sep 2021 21:40:21 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <caihuoqing@baidu.com>
CC:     Chris Snook <chris.snook@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Francois Romieu <romieu@fr.zoreil.com>,
        "Steve Glendinning" <steve.glendinning@shawell.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 1/4] net: atl1c: Fix a function name in print messages
Date:   Sat, 25 Sep 2021 21:40:10 +0800
Message-ID: <20210925134014.251-1-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BC-Mail-Ex31.internal.baidu.com (172.31.51.25) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use dma_map_single() instead of pci_map_single(),
because the pci function wrappers are not called here.

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
---
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index 20c032ab631b..1c258e4ddc96 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -1847,7 +1847,7 @@ static int atl1c_alloc_rx_buffer(struct atl1c_adapter *adapter, u32 queue,
 			buffer_info->skb = NULL;
 			buffer_info->length = 0;
 			ATL1C_SET_BUFFER_STATE(buffer_info, ATL1C_BUFFER_FREE);
-			netif_warn(adapter, rx_err, adapter->netdev, "RX pci_map_single failed");
+			netif_warn(adapter, rx_err, adapter->netdev, "RX dma_map_single failed");
 			break;
 		}
 		buffer_info->dma = mapping;
-- 
2.25.1

