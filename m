Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80191138A8
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 12:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbfEDKUn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 06:20:43 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:7154 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726208AbfEDKUn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 May 2019 06:20:43 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id B9B73B0D760868D4156B;
        Sat,  4 May 2019 18:20:40 +0800 (CST)
Received: from localhost (10.177.31.96) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.439.0; Sat, 4 May 2019
 18:20:29 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <michal.simek@xilinx.com>,
        <esben@geanix.com>, <andrew@lunn.ch>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] net: ll_temac: Make some functions static
Date:   Sat, 4 May 2019 18:10:30 +0800
Message-ID: <20190504101030.37896-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix sparse warnings:

drivers/net/ethernet/xilinx/ll_temac_main.c:66:5: warning: symbol '_temac_ior_be' was not declared. Should it be static?
drivers/net/ethernet/xilinx/ll_temac_main.c:71:6: warning: symbol '_temac_iow_be' was not declared. Should it be static?
drivers/net/ethernet/xilinx/ll_temac_main.c:76:5: warning: symbol '_temac_ior_le' was not declared. Should it be static?
drivers/net/ethernet/xilinx/ll_temac_main.c:81:6: warning: symbol '_temac_iow_le' was not declared. Should it be static?
drivers/net/ethernet/xilinx/ll_temac_main.c:648:6: warning: symbol 'ptr_to_txbd' was not declared. Should it be static?
drivers/net/ethernet/xilinx/ll_temac_main.c:654:6: warning: symbol 'ptr_from_txbd' was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index ca95c72..530a525 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -63,22 +63,22 @@
  * Low level register access functions
  */
 
-u32 _temac_ior_be(struct temac_local *lp, int offset)
+static u32 _temac_ior_be(struct temac_local *lp, int offset)
 {
 	return ioread32be(lp->regs + offset);
 }
 
-void _temac_iow_be(struct temac_local *lp, int offset, u32 value)
+static void _temac_iow_be(struct temac_local *lp, int offset, u32 value)
 {
 	return iowrite32be(value, lp->regs + offset);
 }
 
-u32 _temac_ior_le(struct temac_local *lp, int offset)
+static u32 _temac_ior_le(struct temac_local *lp, int offset)
 {
 	return ioread32(lp->regs + offset);
 }
 
-void _temac_iow_le(struct temac_local *lp, int offset, u32 value)
+static void _temac_iow_le(struct temac_local *lp, int offset, u32 value)
 {
 	return iowrite32(value, lp->regs + offset);
 }
@@ -645,25 +645,25 @@ static void temac_adjust_link(struct net_device *ndev)
 
 #ifdef CONFIG_64BIT
 
-void ptr_to_txbd(void *p, struct cdmac_bd *bd)
+static void ptr_to_txbd(void *p, struct cdmac_bd *bd)
 {
 	bd->app3 = (u32)(((u64)p) >> 32);
 	bd->app4 = (u32)((u64)p & 0xFFFFFFFF);
 }
 
-void *ptr_from_txbd(struct cdmac_bd *bd)
+static void *ptr_from_txbd(struct cdmac_bd *bd)
 {
 	return (void *)(((u64)(bd->app3) << 32) | bd->app4);
 }
 
 #else
 
-void ptr_to_txbd(void *p, struct cdmac_bd *bd)
+static void ptr_to_txbd(void *p, struct cdmac_bd *bd)
 {
 	bd->app4 = (u32)p;
 }
 
-void *ptr_from_txbd(struct cdmac_bd *bd)
+static void *ptr_from_txbd(struct cdmac_bd *bd)
 {
 	return (void *)(bd->app4);
 }
-- 
2.7.4


