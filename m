Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C282377EC4
	for <lists+netdev@lfdr.de>; Sun, 28 Jul 2019 11:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725994AbfG1JZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jul 2019 05:25:28 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43862 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbfG1JZ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jul 2019 05:25:28 -0400
Received: by mail-wr1-f66.google.com with SMTP id p13so58584602wru.10
        for <netdev@vger.kernel.org>; Sun, 28 Jul 2019 02:25:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=QPjUt6Bidk8UplF80zHcbFucy6wiMx+xtg+7Ju9xl0k=;
        b=EwGRR7yFwCanssmgh0eshGkXKL/xWRwHMvvZk89gBoGd/Zha5J3n2bdETBjpK4GZrC
         zXIf/5N8gul6V+x+EluM2cswQ72CupJ/ffXul5GLBbEFgvBw0BR6oh3zjw3xKRg1liBF
         T105tCwWOxrM6AD6TLDx7UiuvJWm24CAg/PLaJxFyjBjbOkt0+DPSEWZAPmxUGtgQFSg
         XmyPHBJhWdT7fAxWGB2vgHEYlBU+BX27NjPUXqUKC8vuCRv58kzvVJu0FxBnfBa/iPTE
         mIRarhey7gIT1zd+UxF2jTktw3M0r/DOlFGjV3lUI9UX81DulnMs63hRE9n8QwaBPTNi
         QxuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=QPjUt6Bidk8UplF80zHcbFucy6wiMx+xtg+7Ju9xl0k=;
        b=hdHXCJ8P7SfkLnMBYlsyWTL26t1qJQXv8mr2xZ2V4Z5RzAXXhjbzyK1WwWUhQmvFJ8
         U3jOqST764nBowPmjyOwNCtP8tXfwVEiAEMZIjcnnbkzh/AVBWeG7YZCOCMEge5iMW0e
         tVH8V2vZX5bF46Ncctofd6+NjpE26MmJHfuLnC140lB5tHvx/cb7yitcf0qq7Fhq0QU7
         QI6x7lQICA2JbPmFsudlDwJ4SmfY9NhWC/GawzPLUhKZ52/Sy8ofVlVUb8Q5O30XbhY6
         x8l71NE56VDcWyI28+UWBdcxInEYNu1G0dDmzueP6DLHZXdKKKetD5qxNgDzHUfWZOJm
         Mkew==
X-Gm-Message-State: APjAAAUdQmXoACsF8ZdGSnmF1jGA6XEgwbQPUqxaPhQwtHfi+tnkB7c5
        shIYzh5InQhbp/Rz3vseM/E=
X-Google-Smtp-Source: APXvYqyR+L0cl0kK3AHNDOwNpj5lgebkGV2UDdLG2nTgx5GRAW9dSFnchv38pjKA8zK6ErJABHNv5Q==
X-Received: by 2002:adf:9ccf:: with SMTP id h15mr98260298wre.241.1564305926495;
        Sun, 28 Jul 2019 02:25:26 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f43:4200:e178:4192:2a76:5cf5? (p200300EA8F434200E17841922A765CF5.dip0.t-ipconnect.de. [2003:ea:8f43:4200:e178:4192:2a76:5cf5])
        by smtp.googlemail.com with ESMTPSA id o24sm63850842wmh.2.2019.07.28.02.25.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 28 Jul 2019 02:25:25 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        Eric Dumazet <edumazet@google.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: make use of xmit_more
Message-ID: <2950b2f7-7460-cce0-d964-ad654d897295@gmail.com>
Date:   Sun, 28 Jul 2019 11:25:19 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There was a previous attempt to use xmit_more, but the change had to be
reverted because under load sometimes a transmit timeout occurred [0].
Maybe this was caused by a missing memory barrier, the new attempt
keeps the memory barrier before the call to netif_stop_queue like it
is used by the driver as of today. The new attempt also changes the
order of some calls as suggested by Eric.

[0] https://lkml.org/lkml/2019/2/10/39

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 864ca529d..d9261e68f 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5637,6 +5637,8 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
 	struct device *d = tp_to_dev(tp);
 	dma_addr_t mapping;
 	u32 opts[2], len;
+	bool stop_queue;
+	bool door_bell;
 	int frags;
 
 	if (unlikely(!rtl_tx_slots_avail(tp, skb_shinfo(skb)->nr_frags))) {
@@ -5680,13 +5682,13 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
 
 	txd->opts2 = cpu_to_le32(opts[1]);
 
-	netdev_sent_queue(dev, skb->len);
-
 	skb_tx_timestamp(skb);
 
 	/* Force memory writes to complete before releasing descriptor */
 	dma_wmb();
 
+	door_bell = __netdev_sent_queue(dev, skb->len, netdev_xmit_more());
+
 	txd->opts1 = rtl8169_get_txd_opts1(opts[0], len, entry);
 
 	/* Force all memory writes to complete before notifying device */
@@ -5694,14 +5696,19 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
 
 	tp->cur_tx += frags + 1;
 
-	RTL_W8(tp, TxPoll, NPQ);
-
-	if (!rtl_tx_slots_avail(tp, MAX_SKB_FRAGS)) {
+	stop_queue = !rtl_tx_slots_avail(tp, MAX_SKB_FRAGS);
+	if (unlikely(stop_queue)) {
 		/* Avoid wrongly optimistic queue wake-up: rtl_tx thread must
 		 * not miss a ring update when it notices a stopped queue.
 		 */
 		smp_wmb();
 		netif_stop_queue(dev);
+	}
+
+	if (door_bell)
+		RTL_W8(tp, TxPoll, NPQ);
+
+	if (unlikely(stop_queue)) {
 		/* Sync with rtl_tx:
 		 * - publish queue status and cur_tx ring index (write barrier)
 		 * - refresh dirty_tx ring index (read barrier).
-- 
2.22.0

