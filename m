Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2252A25FBE7
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 16:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729769AbgIGOOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 10:14:45 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:38474 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729549AbgIGONW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 10:13:22 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 936D919DCD516F507D67;
        Mon,  7 Sep 2020 22:12:44 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.487.0; Mon, 7 Sep 2020
 22:12:40 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <nbd@nbd.name>, <lorenzo.bianconi83@gmail.com>,
        <ryder.lee@mediatek.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <matthias.bgg@gmail.com>,
        <mcoquelin.stm32@gmail.com>, <alexandre.torgue@st.com>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH net-next] mt76: mt7615: Remove set but unused variable 'index'
Date:   Mon, 7 Sep 2020 22:10:02 +0800
Message-ID: <20200907141002.10745-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.113.133]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/wireless/mediatek/mt76/mt7615/testmode.c: In function mt7615_tm_set_tx_power
drivers/net/wireless/mediatek/mt76/mt7615/testmode.c:83:7: warning: variable ‘index’ set but not used [-Wunused-but-set-variable]=

commit 4f0bce1c8888 ("mt76: mt7615: implement testmode support")
involved this unused variable, remove it.

Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 drivers/net/wireless/mediatek/mt76/mt7615/testmode.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/testmode.c b/drivers/net/wireless/mediatek/mt76/mt7615/testmode.c
index 1730751133aa..de39ea8adb96 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/testmode.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/testmode.c
@@ -80,13 +80,10 @@ mt7615_tm_set_tx_power(struct mt7615_phy *phy)
 
 	target_chains = mt7615_ext_pa_enabled(dev, band) ? 1 : n_chains;
 	for (i = 0; i < target_chains; i++) {
-		int index;
-
 		ret = mt7615_eeprom_get_target_power_index(dev, chandef->chan, i);
 		if (ret < 0)
 			return -EINVAL;
 
-		index = ret - MT_EE_NIC_CONF_0;
 		if (tx_power && tx_power[i])
 			data[ret - MT_EE_NIC_CONF_0] = tx_power[i];
 	}
-- 
2.17.1

