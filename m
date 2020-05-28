Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BDA71E593E
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 09:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbgE1Ho1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 03:44:27 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:5298 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725811AbgE1Ho1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 03:44:27 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id D494069D223870CB3645;
        Thu, 28 May 2020 15:44:24 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Thu, 28 May 2020 15:44:15 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        "Kalle Valo" <kvalo@codeaurora.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "Matthias Brugger" <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>
CC:     YueHaibing <yuehaibing@huawei.com>,
        <linux-wireless@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH] mt76: mt7615: Use kmemdup in mt7615_queue_key_update()
Date:   Thu, 28 May 2020 07:48:56 +0000
Message-ID: <20200528074856.118279-1-yuehaibing@huawei.com>
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

Use kmemdup rather than duplicating its implementation

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/mediatek/mt76/mt7615/main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/main.c b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
index 2e9e9d3519d7..c32f06c85f0f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
@@ -289,12 +289,11 @@ mt7615_queue_key_update(struct mt7615_dev *dev, enum set_key_cmd cmd,
 	wd->type = MT7615_WTBL_KEY_DESC;
 	wd->sta = msta;
 
-	wd->key.key = kzalloc(key->keylen, GFP_KERNEL);
+	wd->key.key = kmemdup(key->key, key->keylen, GFP_KERNEL);
 	if (!wd->key.key) {
 		kfree(wd);
 		return -ENOMEM;
 	}
-	memcpy(wd->key.key, key->key, key->keylen);
 	wd->key.cipher = key->cipher;
 	wd->key.keyidx = key->keyidx;
 	wd->key.keylen = key->keylen;



