Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66ACB22C5AE
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 15:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726455AbgGXNBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 09:01:46 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:8274 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726182AbgGXNBq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jul 2020 09:01:46 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 3A20C86C12CD86FEF3AF;
        Fri, 24 Jul 2020 21:01:40 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0; Fri, 24 Jul 2020
 21:01:33 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <dchickles@marvell.com>, <sburla@marvell.com>,
        <fmanlunas@marvell.com>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] liquidio: Remove unneeded cast from memory allocation
Date:   Fri, 24 Jul 2020 21:00:01 +0800
Message-ID: <20200724130001.71528-1-wanghai38@huawei.com>
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

./drivers/net/ethernet/cavium/liquidio/octeon_device.c:1155:14-36: WARNING:
 casting value returned by memory allocation function to (struct octeon_dispatch *) is useless.

Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 drivers/net/ethernet/cavium/liquidio/octeon_device.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/octeon_device.c b/drivers/net/ethernet/cavium/liquidio/octeon_device.c
index 934115d18..1473a669f 100644
--- a/drivers/net/ethernet/cavium/liquidio/octeon_device.c
+++ b/drivers/net/ethernet/cavium/liquidio/octeon_device.c
@@ -1152,8 +1152,7 @@ octeon_register_dispatch_fn(struct octeon_device *oct,
 
 		dev_dbg(&oct->pci_dev->dev,
 			"Adding opcode to dispatch list linked list\n");
-		dispatch = (struct octeon_dispatch *)
-			   vmalloc(sizeof(struct octeon_dispatch));
+		dispatch = vmalloc(sizeof(struct octeon_dispatch));
 		if (!dispatch) {
 			dev_err(&oct->pci_dev->dev,
 				"No memory to add dispatch function\n");
-- 
2.17.1

