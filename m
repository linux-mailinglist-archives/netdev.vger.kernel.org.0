Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58932270A22
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 04:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbgISCqD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 22:46:03 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:13318 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726129AbgISCqD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 22:46:03 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 5C7C961C1D7BBDBD9C59;
        Sat, 19 Sep 2020 10:46:01 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Sat, 19 Sep 2020 10:45:51 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] net: natsemi: Remove set but not used variable
Date:   Sat, 19 Sep 2020 10:46:44 +0800
Message-ID: <20200919024644.24179-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/ethernet/natsemi/ns83820.c: In function ns83820_get_link_ksettings:
drivers/net/ethernet/natsemi/ns83820.c:1210:11: warning: variable ‘tanar’ set but not used [-Wunused-but-set-variable]

`tanar` is never used, so remove it.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/ethernet/natsemi/ns83820.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/natsemi/ns83820.c b/drivers/net/ethernet/natsemi/ns83820.c
index 8e24c7acf79b..144feb2d2622 100644
--- a/drivers/net/ethernet/natsemi/ns83820.c
+++ b/drivers/net/ethernet/natsemi/ns83820.c
@@ -1207,7 +1207,7 @@ static int ns83820_get_link_ksettings(struct net_device *ndev,
 				      struct ethtool_link_ksettings *cmd)
 {
 	struct ns83820 *dev = PRIV(ndev);
-	u32 cfg, tanar, tbicr;
+	u32 cfg, tbicr;
 	int fullduplex   = 0;
 	u32 supported;
 
@@ -1226,8 +1226,8 @@ static int ns83820_get_link_ksettings(struct net_device *ndev,
 
 	/* read current configuration */
 	cfg   = readl(dev->base + CFG) ^ SPDSTS_POLARITY;
-	tanar = readl(dev->base + TANAR);
 	tbicr = readl(dev->base + TBICR);
+	readl(dev->base + TANAR);
 
 	fullduplex = (cfg & CFG_DUPSTS) ? 1 : 0;
 
-- 
2.17.1

