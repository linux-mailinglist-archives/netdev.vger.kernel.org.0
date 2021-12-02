Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42BF0465EFE
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 08:54:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232923AbhLBH6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 02:58:04 -0500
Received: from smtp23.cstnet.cn ([159.226.251.23]:39800 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230274AbhLBH6D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Dec 2021 02:58:03 -0500
Received: from localhost.localdomain (unknown [124.16.141.244])
        by APP-03 (Coremail) with SMTP id rQCowAA3UJKre6hh6VfeAA--.64066S2;
        Thu, 02 Dec 2021 15:54:20 +0800 (CST)
From:   Xu Wang <vulab@iscas.ac.cn>
To:     davem@davemloft.net, zkuba@kernel.org, trix@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ipvlan: Remove redundant if statements
Date:   Thu,  2 Dec 2021 07:53:59 +0000
Message-Id: <20211202075359.34291-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: rQCowAA3UJKre6hh6VfeAA--.64066S2
X-Coremail-Antispam: 1UD129KBjvJXoWruw47uFyfKr4UAw4xAFW5ZFb_yoW8JrWrpr
        4DtFy8CF4xKa1kJ34rAa1xXFy3K3Z7try2k3yDC3s5X3s5JF1jkFyjyF9rZF40qr45KF4a
        vF1Syry7G3W5JrUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUk2b7Iv0xC_KF4lb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
        A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xII
        jxv20xvEc7CjxVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I
        8E87Iv6xkF7I0E14v26F4UJVW0owAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
        0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr
        1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxkIecxEwVAFwVW8CwCF04k2
        0xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI
        8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41l
        IxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIx
        AIcVCF04k26cxKx2IYs7xG6Fyj6rWUJwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E
        87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUcG-eUUUUU
X-Originating-IP: [124.16.141.244]
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCQgDA102awiHrwAAsh
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 'if (dev)' statement already move into dev_{put , hold}, so remove
redundant if statements.

Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
---
 drivers/net/ipvlan/ipvlan_core.c | 3 +--
 drivers/net/ipvlan/ipvlan_main.c | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ipvlan/ipvlan_core.c b/drivers/net/ipvlan/ipvlan_core.c
index 6cd50106e611..c613900c3811 100644
--- a/drivers/net/ipvlan/ipvlan_core.c
+++ b/drivers/net/ipvlan/ipvlan_core.c
@@ -291,8 +291,7 @@ void ipvlan_process_multicast(struct work_struct *work)
 			else
 				kfree_skb(skb);
 		}
-		if (dev)
-			dev_put(dev);
+		dev_put(dev);
 		cond_resched();
 	}
 }
diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
index 1d2f4e7d7324..e90518952db9 100644
--- a/drivers/net/ipvlan/ipvlan_main.c
+++ b/drivers/net/ipvlan/ipvlan_main.c
@@ -100,8 +100,7 @@ static void ipvlan_port_destroy(struct net_device *dev)
 	netdev_rx_handler_unregister(dev);
 	cancel_work_sync(&port->wq);
 	while ((skb = __skb_dequeue(&port->backlog)) != NULL) {
-		if (skb->dev)
-			dev_put(skb->dev);
+		dev_put(skb->dev);
 		kfree_skb(skb);
 	}
 	ida_destroy(&port->ida);
-- 
2.25.1

