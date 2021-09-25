Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C284418213
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 14:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245409AbhIYMwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 08:52:34 -0400
Received: from mx24.baidu.com ([111.206.215.185]:43234 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244795AbhIYMw1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Sep 2021 08:52:27 -0400
Received: from BC-Mail-Ex06.internal.baidu.com (unknown [172.31.51.46])
        by Forcepoint Email with ESMTPS id E40CD237CB2DABF10104;
        Sat, 25 Sep 2021 20:50:51 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BC-Mail-Ex06.internal.baidu.com (172.31.51.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.12; Sat, 25 Sep 2021 20:50:51 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.63.8) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Sat, 25 Sep 2021 20:50:51 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <caihuoqing@baidu.com>
CC:     Chris Snook <chris.snook@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Francois Romieu <romieu@fr.zoreil.com>,
        "Steve Glendinning" <steve.glendinning@shawell.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4] net: atl1c: Fix a function name in print messages
Date:   Sat, 25 Sep 2021 20:50:38 +0800
Message-ID: <20210925125042.1629-1-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BJHW-Mail-Ex01.internal.baidu.com (10.127.64.11) To
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

