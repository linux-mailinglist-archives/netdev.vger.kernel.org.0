Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5952A4494
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 12:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728737AbgKCLxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 06:53:20 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:7453 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727109AbgKCLxT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 06:53:19 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4CQSpj0R9fzhfP1;
        Tue,  3 Nov 2020 19:53:17 +0800 (CST)
Received: from linux-lmwb.huawei.com (10.175.103.112) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Tue, 3 Nov 2020 19:53:07 +0800
From:   Zou Wei <zou_wei@huawei.com>
To:     <madalin.bucur@nxp.com>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Zou Wei <zou_wei@huawei.com>
Subject: [PATCH -next] dpaa_eth: use false and true for bool variables
Date:   Tue, 3 Nov 2020 20:05:00 +0800
Message-ID: <1604405100-33255-1-git-send-email-zou_wei@huawei.com>
X-Mailer: git-send-email 2.6.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.103.112]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix coccicheck warnings:

./dpaa_eth.c:2549:2-22: WARNING: Assignment of 0/1 to bool variable
./dpaa_eth.c:2562:2-22: WARNING: Assignment of 0/1 to bool variable

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index d9c2859..31407c1 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -2546,7 +2546,7 @@ static void dpaa_eth_napi_enable(struct dpaa_priv *priv)
 	for_each_online_cpu(i) {
 		percpu_priv = per_cpu_ptr(priv->percpu_priv, i);
 
-		percpu_priv->np.down = 0;
+		percpu_priv->np.down = false;
 		napi_enable(&percpu_priv->np.napi);
 	}
 }
@@ -2559,7 +2559,7 @@ static void dpaa_eth_napi_disable(struct dpaa_priv *priv)
 	for_each_online_cpu(i) {
 		percpu_priv = per_cpu_ptr(priv->percpu_priv, i);
 
-		percpu_priv->np.down = 1;
+		percpu_priv->np.down = true;
 		napi_disable(&percpu_priv->np.napi);
 	}
 }
-- 
2.6.2

