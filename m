Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22873179025
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 13:19:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387929AbgCDMTq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 07:19:46 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:10723 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729118AbgCDMTq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 07:19:46 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id BB74A70B5BC42A7D5B3D;
        Wed,  4 Mar 2020 20:19:38 +0800 (CST)
Received: from euler.huawei.com (10.175.104.193) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.439.0; Wed, 4 Mar 2020 20:19:30 +0800
From:   Chen Wandun <chenwandun@huawei.com>
To:     <nbd@nbd.name>, <lorenzo.bianconi83@gmail.com>,
        <ryder.lee@mediatek.com>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     <chenwandun@huawei.com>
Subject: [PATCH] mt76: remove variable 'val' set but not used
Date:   Wed, 4 Mar 2020 20:34:11 +0800
Message-ID: <20200304123411.33499-1-chenwandun@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.104.193]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/wireless/mediatek/mt76/mt76x0/phy.c: In function mt76x0_phy_rf_init:
drivers/net/wireless/mediatek/mt76/mt76x0/phy.c:1158:5: warning: variable val set but not used [-Wunused-but-set-variable]

Fixes: 10de7a8b4ab9 ("mt76x0: phy files")
Signed-off-by: Chen Wandun <chenwandun@huawei.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index b56397c05218..09f34deb6ba1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -1155,7 +1155,6 @@ static void mt76x0_rf_patch_reg_array(struct mt76x02_dev *dev,
 static void mt76x0_phy_rf_init(struct mt76x02_dev *dev)
 {
 	int i;
-	u8 val;
 
 	mt76x0_rf_patch_reg_array(dev, mt76x0_rf_central_tab,
 				  ARRAY_SIZE(mt76x0_rf_central_tab));
@@ -1188,7 +1187,7 @@ static void mt76x0_phy_rf_init(struct mt76x02_dev *dev)
 	 */
 	mt76x0_rf_wr(dev, MT_RF(0, 22),
 		     min_t(u8, dev->cal.rx.freq_offset, 0xbf));
-	val = mt76x0_rf_rr(dev, MT_RF(0, 22));
+	mt76x0_rf_rr(dev, MT_RF(0, 22));
 
 	/* Reset procedure DAC during power-up:
 	 * - set B0.R73<7>
-- 
2.17.1

