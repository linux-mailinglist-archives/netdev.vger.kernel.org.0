Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2498105EBF
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 03:54:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbfKVCyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 21:54:35 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:37110 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726335AbfKVCyf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Nov 2019 21:54:35 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id CC91417F34D28DAFA269;
        Fri, 22 Nov 2019 10:54:31 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.439.0; Fri, 22 Nov 2019 10:54:21 +0800
From:   Mao Wenan <maowenan@huawei.com>
To:     <claudiu.manoil@nxp.com>, <davem@davemloft.net>,
        <vladimir.oltean@nxp.com>, <po.liu@nxp.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, Mao Wenan <maowenan@huawei.com>
Subject: [PATCH -next] enetc: make enetc_setup_tc_mqprio static
Date:   Fri, 22 Nov 2019 10:52:40 +0800
Message-ID: <20191122025240.8226-1-maowenan@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While using ARCH=mips CROSS_COMPILE=mips-linux-gnu- command to compile,
make C=2 drivers/net/ethernet/freescale/enetc/enetc.o

one warning can be found:
drivers/net/ethernet/freescale/enetc/enetc.c:1439:5:
warning: symbol 'enetc_setup_tc_mqprio' was not declared.
Should it be static?

This patch make symbol enetc_setup_tc_mqprio static.
Fixes: 34c6adf1977b ("enetc: Configure the Time-Aware Scheduler via tc-taprio offload")
Signed-off-by: Mao Wenan <maowenan@huawei.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index f6b00c6..27f6fd1 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1436,7 +1436,7 @@ int enetc_close(struct net_device *ndev)
 	return 0;
 }
 
-int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
+static int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 	struct tc_mqprio_qopt *mqprio = type_data;
-- 
2.7.4

