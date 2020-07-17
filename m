Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8F6C223929
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 12:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726229AbgGQKXO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 06:23:14 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:52850 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725864AbgGQKXN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jul 2020 06:23:13 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id CA0E9DFE89BF877B1CE9;
        Fri, 17 Jul 2020 18:23:11 +0800 (CST)
Received: from localhost.localdomain (10.175.112.70) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Fri, 17 Jul 2020 18:23:10 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
To:     <rmody@marvell.com>, <skalluru@marvell.com>,
        <GR-Linux-NIC-Dev@marvell.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] net: bna: Remove unused variable 't'
Date:   Fri, 17 Jul 2020 18:23:04 +0800
Message-ID: <1594981384-30489-1-git-send-email-zhangchangzhong@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Gcc report warning as follows:

drivers/net/ethernet/brocade/bna/bfa_ioc.c:1538:6: warning:
 variable 't' set but not used [-Wunused-but-set-variable]
 1538 |  u32 t;
      |      ^

After commit c107ba171f3d ("bna: Firmware Patch Simplification"),
't' is never used, so removing it to avoid build warning.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
---
 drivers/net/ethernet/brocade/bna/bfa_ioc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/brocade/bna/bfa_ioc.c b/drivers/net/ethernet/brocade/bna/bfa_ioc.c
index e17bfc8..49358d4 100644
--- a/drivers/net/ethernet/brocade/bna/bfa_ioc.c
+++ b/drivers/net/ethernet/brocade/bna/bfa_ioc.c
@@ -1535,7 +1535,6 @@ enum bfa_flash_err {
 bfa_flash_fifo_flush(void __iomem *pci_bar)
 {
 	u32 i;
-	u32 t;
 	union bfa_flash_dev_status_reg dev_status;
 
 	dev_status.i = readl(pci_bar + FLI_DEV_STATUS_REG);
@@ -1545,7 +1544,7 @@ enum bfa_flash_err {
 
 	/* fifo counter in terms of words */
 	for (i = 0; i < dev_status.r.fifo_cnt; i++)
-		t = readl(pci_bar + FLI_RDDATA_REG);
+		readl(pci_bar + FLI_RDDATA_REG);
 
 	/* Check the device status. It may take some time. */
 	for (i = 0; i < BFA_FLASH_CHECK_MAX; i++) {
-- 
1.8.3.1

