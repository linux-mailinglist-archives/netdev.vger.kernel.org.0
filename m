Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7731C4FC2
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 09:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728220AbgEEH7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 03:59:36 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3791 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725766AbgEEH7g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 03:59:36 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 78D0221E5617A8F09920;
        Tue,  5 May 2020 15:59:33 +0800 (CST)
Received: from localhost (10.173.251.152) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Tue, 5 May 2020
 15:59:27 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <jerry.lilijun@huawei.com>,
        <xudingke@huawei.com>, Yunjian Wang <wangyunjian@huawei.com>
Subject: [PATCH net-next] net: ni: Fix use correct return type for ndo_start_xmit()
Date:   Tue, 5 May 2020 15:59:26 +0800
Message-ID: <1588665566-84216-1-git-send-email-wangyunjian@huawei.com>
X-Mailer: git-send-email 1.9.5.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.173.251.152]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunjian Wang <wangyunjian@huawei.com>

The method ndo_start_xmit() returns a value of type netdev_tx_t. Fix
the ndo function to use the correct type.

Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
---
 drivers/net/ethernet/ni/nixge.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ni/nixge.c b/drivers/net/ethernet/ni/nixge.c
index 2fdd075..d2708a5 100644
--- a/drivers/net/ethernet/ni/nixge.c
+++ b/drivers/net/ethernet/ni/nixge.c
@@ -502,7 +502,8 @@ static int nixge_check_tx_bd_space(struct nixge_priv *priv,
 	return 0;
 }
 
-static int nixge_start_xmit(struct sk_buff *skb, struct net_device *ndev)
+static netdev_tx_t nixge_start_xmit(struct sk_buff *skb,
+				    struct net_device *ndev)
 {
 	struct nixge_priv *priv = netdev_priv(ndev);
 	struct nixge_hw_dma_bd *cur_p;
-- 
1.8.3.1


