Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08A371E43E3
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 15:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388330AbgE0Nhc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 09:37:32 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:60557 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387682AbgE0Nhb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 09:37:31 -0400
Received: from localhost.localdomain ([149.172.98.151]) by
 mrelayeu.kundenserver.de (mreue012 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MelWf-1j437k3y2n-00aqFI; Wed, 27 May 2020 15:36:58 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, Ryder Lee <ryder.lee@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Chih-Min Chen <chih-min.chen@mediatek.com>,
        Shihwei Lin <shihwei.lin@mediatek.com>,
        Yiwei Chung <yiwei.chung@mediatek.com>,
        YF Luo <yf.luo@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        YueHaibing <yuehaibing@huawei.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [wireless-next] mt75: fix enum type mismatch
Date:   Wed, 27 May 2020 15:36:30 +0200
Message-Id: <20200527133655.617357-1-arnd@arndb.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:2xsdauHeCgoTJqtAjoy1w439KhbI5AyVOuAxW1IHW47YA4Gorsi
 Uh4YCVjbYsbddzHdqSL/9Nyka228g3hOyRaepN6TWoIe5HUzp67ihrRMluLbPYi2hFTnxyw
 1JRB8qLO9BliOGYOZdkWVaHW2CucwMbhaxuLQUo9QhEp3DP9AIG3a/U+jSsmX/6lg/tAn8j
 7jHNArva+RLoRfuAuh3Cw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:FtVcgZauz7o=:scUFGVl1oIETlCqq2XG30+
 BY+OSB/p/C2PHbQV8moxHzruH1uP9Hs2Cmkfuzt1pzAyXtW82VPL+i6XhfkL4Kzn7fV4xIawJ
 A2HAq5Il64nn45Q6XqxowsRnC3JKSDVcU6+/hxjOI0t5GljWTrL92TJl527WU8NnDHJS4Tsmr
 KsgZU4nD98sSiKPVkTHHG6nMcDBR3BIOtqB5sWIH6/bz3j+ogz/P1rSXjrKE0QGmIvpjlYWua
 3SS7ZaIIfPGwxYYgrFIJ+K+IdIdOXXvEY8bX+OteZNxdWkg2RjR6bBm/P/yo4S8qC8nEl6Bow
 YJpUhM/w7lN9lF3hGTidifdzL9moxS+mjIcV6NaE77kl9pTr1m1pdb19VurLWicwiNgTE2fgG
 6wGAv4DAXmgkb6c6AwimTkBPyjXRsaK2gl5t/gWIv5dz++WZzoYVa+r+a2J4ZpwrK6K6pH5EU
 Z5Dy7USzvBQWE/JgGDaFqcG+Zk8lbixikSTtHW+LPnfyiDbiKHjlimzlMGpd4+NVXmrgc8uJd
 YgMB9mM3nsWcahk0NbkhXZsVMe14iaKWstbUlaF/zFJ1TnQC3bPfKIooWLd7eSJkNYMY6dJ41
 zAneqRyKhsqVGB16LHOiS9GXVxbBwaemmq2+f9F08NizeJDLOrW4MAY0hLNAQ5WzoMC9RUliB
 vSvJiyC5p01107GyNrmS7vC+Nfi31gg21wIlE8ej7ZltRD0sM09YzWVBnr5fkky8ZBGd4pQfE
 YxO/L8TcnJlj9bmltBSZuOTgEL8rM/nVk034s2QC/YfSrq20qSaPTCrGtTgxQncP9Ds0LSwdn
 lOjGQJNACJeHLPwBGXaDbUg2u7n3XaDiXVfLbhmQB6Wp7qadf4=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The __mt7915_mcu_msg_send() calls a generic function that expects a mt76_txq_id
rather than mt7915_txq_id, and it also uses the values according to that
type, which are different from the similarly named MT7915_TXQ_ constants:

drivers/net/wireless/mediatek/mt76/mt7915/mcu.c:232:9: error: implicit conversion from enumeration type 'enum mt76_txq_id' to different enumeration type 'enum mt7915_txq_id' [-Werror,-Wenum-conversion]
                txq = MT_TXQ_FWDL;
                    ~ ^~~~~~~~~~~
drivers/net/wireless/mediatek/mt76/mt7915/mcu.c:287:36: error: implicit conversion from enumeration type 'enum mt7915_txq_id' to different enumeration type 'enum mt76_txq_id' [-Werror,-Wenum-conversion]
        return mt76_tx_queue_skb_raw(dev, txq, skb, 0);
               ~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~
drivers/net/wireless/mediatek/mt76/mt7915/../mt76.h:668:97: note: expanded from macro 'mt76_tx_queue_skb_raw'

Use the mt76 types consistently.

Fixes: e57b7901469f ("mt76: add mac80211 driver for MT7915 PCIe-based chipsets")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index 99eeea42478f..001b3078c48e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -220,7 +220,7 @@ static int __mt7915_mcu_msg_send(struct mt7915_dev *dev, struct sk_buff *skb,
 {
 	struct mt7915_mcu_txd *mcu_txd;
 	u8 seq, pkt_fmt, qidx;
-	enum mt7915_txq_id txq;
+	enum mt76_txq_id txq;
 	__le32 *txd;
 	u32 val;
 
-- 
2.26.2

