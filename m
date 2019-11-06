Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF524F1943
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 16:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731842AbfKFPAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 10:00:20 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:6161 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728712AbfKFPAT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Nov 2019 10:00:19 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 611C6E494CCC75930C89;
        Wed,  6 Nov 2019 23:00:14 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Wed, 6 Nov 2019 23:00:07 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     Egor Pomozov <epomozov@marvell.com>,
        Igor Russkikh <igor.russkikh@aquantia.com>
CC:     Wei Yongjun <weiyongjun1@huawei.com>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH net-next] net: aquantia: fix return value check in aq_ptp_init()
Date:   Wed, 6 Nov 2019 14:59:21 +0000
Message-ID: <20191106145921.124814-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Function ptp_clock_register() returns ERR_PTR() and never returns
NULL. The NULL test should be removed.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_ptp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
index 3ec08415e53e..252a80b6d3b6 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
@@ -1205,7 +1205,7 @@ int aq_ptp_init(struct aq_nic_s *aq_nic, unsigned int idx_vec)
 	aq_ptp->ptp_info = aq_ptp_clock;
 	aq_ptp_gpio_init(&aq_ptp->ptp_info, &mbox.info);
 	clock = ptp_clock_register(&aq_ptp->ptp_info, &aq_nic->ndev->dev);
-	if (!clock || IS_ERR(clock)) {
+	if (IS_ERR(clock)) {
 		netdev_err(aq_nic->ndev, "ptp_clock_register failed\n");
 		err = PTR_ERR(clock);
 		goto err_exit;



