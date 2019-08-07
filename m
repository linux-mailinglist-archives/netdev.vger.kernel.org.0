Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71C4C84C7B
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 15:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388089AbfHGNJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 09:09:28 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:59940 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387976AbfHGNJ2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Aug 2019 09:09:28 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id A2F31EF230E704A7E5D3;
        Wed,  7 Aug 2019 21:09:25 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.439.0; Wed, 7 Aug 2019
 21:09:16 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <olteanv@gmail.com>, <andrew@lunn.ch>,
        <vivien.didelot@gmail.com>, <f.fainelli@gmail.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] net: dsa: sja1105: remove set but not used variables 'tx_vid' and 'rx_vid'
Date:   Wed, 7 Aug 2019 21:08:56 +0800
Message-ID: <20190807130856.60792-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/dsa/sja1105/sja1105_main.c: In function sja1105_fdb_dump:
drivers/net/dsa/sja1105/sja1105_main.c:1226:14: warning:
 variable tx_vid set but not used [-Wunused-but-set-variable]
drivers/net/dsa/sja1105/sja1105_main.c:1226:6: warning:
 variable rx_vid set but not used [-Wunused-but-set-variable]

They are not used since commit 6d7c7d948a2e ("net: dsa:
sja1105: Fix broken learning with vlan_filtering disabled")

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index d073baf..df976b25 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1223,12 +1223,8 @@ static int sja1105_fdb_dump(struct dsa_switch *ds, int port,
 {
 	struct sja1105_private *priv = ds->priv;
 	struct device *dev = ds->dev;
-	u16 rx_vid, tx_vid;
 	int i;
 
-	rx_vid = dsa_8021q_rx_vid(ds, port);
-	tx_vid = dsa_8021q_tx_vid(ds, port);
-
 	for (i = 0; i < SJA1105_MAX_L2_LOOKUP_COUNT; i++) {
 		struct sja1105_l2_lookup_entry l2_lookup = {0};
 		u8 macaddr[ETH_ALEN];
-- 
2.7.4


