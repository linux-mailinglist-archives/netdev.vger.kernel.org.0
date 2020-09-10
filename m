Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 310DE2646D2
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 15:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730684AbgIJNWW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 09:22:22 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:11789 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728971AbgIJNOp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 09:14:45 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 279F617A78B81BF1A243;
        Thu, 10 Sep 2020 21:14:43 +0800 (CST)
Received: from huawei.com (10.69.192.56) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0; Thu, 10 Sep 2020
 21:14:34 +0800
From:   Luo Jiaxing <luojiaxing@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <steve.glendinning@shawell.net>,
        <linuxarm@huawei.com>, <kuba@kernel.org>
Subject: [PATCH net-next] net: smc91x: Remove set but not used variable 'status' in smc_phy_configure()
Date:   Thu, 10 Sep 2020 21:12:16 +0800
Message-ID: <1599743536-65362-1-git-send-email-luojiaxing@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following warning when using W=1 to build kernel:

drivers/net/ethernet/smsc/smc91x.c: In function ‘smc_phy_configure’:
drivers/net/ethernet/smsc/smc91x.c:1039:6: warning: variable ‘status’ set but not used [-Wunused-but-set-variable]
  int status;

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
---
 drivers/net/ethernet/smsc/smc91x.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/smsc/smc91x.c b/drivers/net/ethernet/smsc/smc91x.c
index 1c4fea9..4492715 100644
--- a/drivers/net/ethernet/smsc/smc91x.c
+++ b/drivers/net/ethernet/smsc/smc91x.c
@@ -1036,7 +1036,6 @@ static void smc_phy_configure(struct work_struct *work)
 	int phyaddr = lp->mii.phy_id;
 	int my_phy_caps; /* My PHY capabilities */
 	int my_ad_caps; /* My Advertised capabilities */
-	int status;
 
 	DBG(3, dev, "smc_program_phy()\n");
 
@@ -1110,7 +1109,7 @@ static void smc_phy_configure(struct work_struct *work)
 	 * auto-negotiation is restarted, sometimes it isn't ready and
 	 * the link does not come up.
 	 */
-	status = smc_phy_read(dev, phyaddr, MII_ADVERTISE);
+	smc_phy_read(dev, phyaddr, MII_ADVERTISE);
 
 	DBG(2, dev, "phy caps=%x\n", my_phy_caps);
 	DBG(2, dev, "phy advertised caps=%x\n", my_ad_caps);
-- 
2.7.4

