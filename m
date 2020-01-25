Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25A86149493
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 11:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730219AbgAYKo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 05:44:27 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:44387 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729868AbgAYKn0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jan 2020 05:43:26 -0500
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1ivIu5-0008V2-8j; Sat, 25 Jan 2020 11:43:01 +0100
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 74CF51C1A72;
        Sat, 25 Jan 2020 11:42:48 +0100 (CET)
Date:   Sat, 25 Jan 2020 10:42:48 -0000
From:   "tip-bot2 for Paul E. McKenney" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: core/rcu] wireless/mediatek: Replace rcu_swap_protected() with
 rcu_replace_pointer()
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Roy Luo <royluo@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <157994896823.396.3709123757914257242.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following commit has been merged into the core/rcu branch of tip:

Commit-ID:     a191c9e9f73a78e8801b5eeb3d43bbd6fd73b86f
Gitweb:        https://git.kernel.org/tip/a191c9e9f73a78e8801b5eeb3d43bbd6fd73b86f
Author:        Paul E. McKenney <paulmck@kernel.org>
AuthorDate:    Wed, 11 Dec 2019 10:30:21 -08:00
Committer:     Paul E. McKenney <paulmck@kernel.org>
CommitterDate: Thu, 12 Dec 2019 10:20:51 -08:00

wireless/mediatek: Replace rcu_swap_protected() with rcu_replace_pointer()

This commit replaces the use of rcu_swap_protected() with the more
intuitively appealing rcu_replace_pointer() as a step towards removing
rcu_swap_protected().

Link: https://lore.kernel.org/lkml/CAHk-=wiAsJLw1egFEE=Z7-GGtM6wcvtyytXZA1+BHqta4gg6Hw@mail.gmail.com/
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Reported-by: "Martin K. Petersen" <martin.petersen@oracle.com>
[ paulmck: Apply Matthias Brugger feedback. ]
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Reviewed-by: "Martin K. Petersen" <martin.petersen@oracle.com>
Acked-by: Kalle Valo <kvalo@codeaurora.org>
Cc: Felix Fietkau <nbd@nbd.name>
Cc: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc: Ryder Lee <ryder.lee@mediatek.com>
Cc: Roy Luo <royluo@google.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: <linux-wireless@vger.kernel.org>
Cc: <netdev@vger.kernel.org>
Cc: <linux-arm-kernel@lists.infradead.org>
Cc: <linux-mediatek@lists.infradead.org>
---
 drivers/net/wireless/mediatek/mt76/agg-rx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/agg-rx.c b/drivers/net/wireless/mediatek/mt76/agg-rx.c
index 53b5a4b..59c1878 100644
--- a/drivers/net/wireless/mediatek/mt76/agg-rx.c
+++ b/drivers/net/wireless/mediatek/mt76/agg-rx.c
@@ -281,8 +281,8 @@ void mt76_rx_aggr_stop(struct mt76_dev *dev, struct mt76_wcid *wcid, u8 tidno)
 {
 	struct mt76_rx_tid *tid = NULL;
 
-	rcu_swap_protected(wcid->aggr[tidno], tid,
-			   lockdep_is_held(&dev->mutex));
+	tid = rcu_replace_pointer(wcid->aggr[tidno], tid,
+				  lockdep_is_held(&dev->mutex));
 	if (tid) {
 		mt76_rx_aggr_shutdown(dev, tid);
 		kfree_rcu(tid, rcu_head);
