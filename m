Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A694AB7FE
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 14:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392034AbfIFMTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 08:19:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40133 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732863AbfIFMTg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 08:19:36 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1i6DD4-0002Bw-N2; Fri, 06 Sep 2019 12:19:26 +0000
From:   Colin King <colin.king@canonical.com>
To:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Roy Luo <royluo@google.com>, Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mt76: mt76x0e: make array mt76x0_chan_map static const, makes object smaller
Date:   Fri,  6 Sep 2019 13:19:26 +0100
Message-Id: <20190906121926.24080-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Don't populate the array mt76x0_chan_map on the stack but instead make it
static const. Makes the object code smaller by 80 bytes.

Before:
   text	   data	    bss	    dec	    hex	filename
   7685	   1192	      0	   8877	   22ad	mediatek/mt76/mt76x0/eeprom.o

After:
   text	   data	    bss	    dec	    hex	filename
   7541	   1256	      0	   8797	   225d	mediatek/mt76/mt76x0/eeprom.o

(gcc version 9.2.1, amd64)

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
index 9d4426f6905f..96368fac4228 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
@@ -212,7 +212,7 @@ void mt76x0_get_tx_power_per_rate(struct mt76x02_dev *dev,
 void mt76x0_get_power_info(struct mt76x02_dev *dev,
 			   struct ieee80211_channel *chan, s8 *tp)
 {
-	struct mt76x0_chan_map {
+	static const struct mt76x0_chan_map {
 		u8 chan;
 		u8 offset;
 	} chan_map[] = {
-- 
2.20.1

