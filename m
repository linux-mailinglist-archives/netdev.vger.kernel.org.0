Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 836DA130E25
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 08:47:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbgAFHrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 02:47:07 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:36184 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbgAFHrG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 02:47:06 -0500
Received: by mail-lf1-f68.google.com with SMTP id n12so35767646lfe.3
        for <netdev@vger.kernel.org>; Sun, 05 Jan 2020 23:47:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+s0c48Kgo5roPu4wR85XDyj7T2tKKEI2GilW6z2yixI=;
        b=eGTKXji0qBcjv/t49z5J3ROhNGHPJiThT0Ay5/ib6xzlvK2DQbjTrlf0nJjptkmP5t
         p3WZB09HTMfJZu0Z/OuXZk0b+de6Czl1QKdIdlynSzh6NRqSFL8Sa1pcx6KGD3K5C30C
         zJ5JI102rVUL/AKYfvKNZ3aIKaPJBZNu7dkSfkVKsHzaB4Y6S/i0DyeyDTQMiekTQefi
         BN0NqLKktqOkRlok4tk2itejfK2BwCZiQB7XkY4G7wiSC+5lvcL40XkycfHHf8mOVzoI
         KIog+N4meaXBCvmkcxNCN8B0aNXU7Q5xLiOytBA+rfWTp1TdcE+Xnx/VeHMMcuev8i19
         6w5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+s0c48Kgo5roPu4wR85XDyj7T2tKKEI2GilW6z2yixI=;
        b=s6ggB9WhB4kLT0jhc6S7bd2MCJm1daUjCf8yX+lPxXvpAdxz+xZ+XmEMicjGErlKYX
         jalBqKo1LHGUq5nsJYf+92+7OU7l57pOxoknt/xidrXSzkKM8CCNNp4N7SVlzZ28luEm
         GZ/+8vQEZYR/tELlefSqhk/RuOJZ28KjeyCvoYNuW0hkLX1oBjSUOjAFMT3sG414fmlE
         Eri6AeIXtc5TQ5LdvRGFwsDEwjd2/cuXd/YNVOPrOhKazRfnwZRp5vM/CGtH7xW56MuV
         W0uDcLK2/9GTn8MY28cupLBCdC7BfFrF1qR1M9QIcm8NOxs4fnsRoaGDPSbypWlTdnbm
         /EtA==
X-Gm-Message-State: APjAAAXYw7BZNnfNR1/VufwZnqxzVEEl1YRec+ziyd6aDIBNHxxMI1SW
        DimlokWw3QH0pTbj6Kh6NgycCOXcJG1Uuw==
X-Google-Smtp-Source: APXvYqzZtClJUlOHbWQoLXxySm9n6n5EwkyV5WN4EAGwU3WqxNs7gcsixMVn0M34VDQ7F2tEG9jwYg==
X-Received: by 2002:ac2:544f:: with SMTP id d15mr59290663lfn.126.1578296823491;
        Sun, 05 Jan 2020 23:47:03 -0800 (PST)
Received: from localhost.bredbandsbolaget (c-5ac9225c.014-348-6c756e10.bbcust.telenor.se. [92.34.201.90])
        by smtp.gmail.com with ESMTPSA id n14sm28625551lfe.5.2020.01.05.23.47.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jan 2020 23:47:02 -0800 (PST)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH net-next 7/9 v3] net: ehernet: ixp4xx: Use netdev_* messages
Date:   Mon,  6 Jan 2020 08:46:45 +0100
Message-Id: <20200106074647.23771-8-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200106074647.23771-1-linus.walleij@linaro.org>
References: <20200106074647.23771-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify and correct a bunch of messages using printk
directly to use the netdev_* macros. I have not changed
all of them, just the low-hanging fruit.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChanegLog v2->v3:
- Rebased on v5.5-rc1
ChangeLog v1->v2:
- Squashed the previous devm_* changes into the patch
  where the simplified errorpath is needed and renamed
  this patch to just be about the message.
- Fixed a bunch more prints.
---
 drivers/net/ethernet/xscale/ixp4xx_eth.c | 52 +++++++++++-------------
 1 file changed, 23 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
index 05ab8426bb8d..f7edf8b38dea 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -572,8 +572,8 @@ static void ixp4xx_adjust_link(struct net_device *dev)
 		__raw_writel(DEFAULT_TX_CNTRL0 | TX_CNTRL0_HALFDUPLEX,
 			     &port->regs->tx_control[0]);
 
-	printk(KERN_INFO "%s: link up, speed %u Mb/s, %s duplex\n",
-	       dev->name, port->speed, port->duplex ? "full" : "half");
+	netdev_info(dev, "%s: link up, speed %u Mb/s, %s duplex\n",
+		    dev->name, port->speed, port->duplex ? "full" : "half");
 }
 
 
@@ -583,7 +583,7 @@ static inline void debug_pkt(struct net_device *dev, const char *func,
 #if DEBUG_PKT_BYTES
 	int i;
 
-	printk(KERN_DEBUG "%s: %s(%i) ", dev->name, func, len);
+	netdev_debug(dev, "%s(%i) ", func, len);
 	for (i = 0; i < len; i++) {
 		if (i >= DEBUG_PKT_BYTES)
 			break;
@@ -674,7 +674,7 @@ static int eth_poll(struct napi_struct *napi, int budget)
 	int received = 0;
 
 #if DEBUG_RX
-	printk(KERN_DEBUG "%s: eth_poll\n", dev->name);
+	netdev_debug(dev, "eth_poll\n");
 #endif
 
 	while (received < budget) {
@@ -688,23 +688,20 @@ static int eth_poll(struct napi_struct *napi, int budget)
 
 		if ((n = queue_get_desc(rxq, port, 0)) < 0) {
 #if DEBUG_RX
-			printk(KERN_DEBUG "%s: eth_poll napi_complete\n",
-			       dev->name);
+			netdev_debug(dev, "eth_poll napi_complete\n");
 #endif
 			napi_complete(napi);
 			qmgr_enable_irq(rxq);
 			if (!qmgr_stat_below_low_watermark(rxq) &&
 			    napi_reschedule(napi)) { /* not empty again */
 #if DEBUG_RX
-				printk(KERN_DEBUG "%s: eth_poll napi_reschedule succeeded\n",
-				       dev->name);
+				netdev_debug(dev, "eth_poll napi_reschedule succeeded\n");
 #endif
 				qmgr_disable_irq(rxq);
 				continue;
 			}
 #if DEBUG_RX
-			printk(KERN_DEBUG "%s: eth_poll all done\n",
-			       dev->name);
+			netdev_debug(dev, "eth_poll all done\n");
 #endif
 			return received; /* all work done */
 		}
@@ -769,7 +766,7 @@ static int eth_poll(struct napi_struct *napi, int budget)
 	}
 
 #if DEBUG_RX
-	printk(KERN_DEBUG "eth_poll(): end, not all work done\n");
+	netdev_debug(dev, "eth_poll(): end, not all work done\n");
 #endif
 	return received;		/* not all work done */
 }
@@ -833,7 +830,7 @@ static int eth_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct desc *desc;
 
 #if DEBUG_TX
-	printk(KERN_DEBUG "%s: eth_xmit\n", dev->name);
+	netdev_debug(dev, "eth_xmit\n");
 #endif
 
 	if (unlikely(skb->len > MAX_MRU)) {
@@ -888,22 +885,21 @@ static int eth_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	if (qmgr_stat_below_low_watermark(txreadyq)) { /* empty */
 #if DEBUG_TX
-		printk(KERN_DEBUG "%s: eth_xmit queue full\n", dev->name);
+		netdev_debug(dev, "eth_xmit queue full\n");
 #endif
 		netif_stop_queue(dev);
 		/* we could miss TX ready interrupt */
 		/* really empty in fact */
 		if (!qmgr_stat_below_low_watermark(txreadyq)) {
 #if DEBUG_TX
-			printk(KERN_DEBUG "%s: eth_xmit ready again\n",
-			       dev->name);
+			netdev_debug(dev, "eth_xmit ready again\n");
 #endif
 			netif_wake_queue(dev);
 		}
 	}
 
 #if DEBUG_TX
-	printk(KERN_DEBUG "%s: eth_xmit end\n", dev->name);
+	netdev_debug(dev, "eth_xmit end\n");
 #endif
 
 	ixp_tx_timestamp(port, skb);
@@ -1177,8 +1173,7 @@ static int eth_open(struct net_device *dev)
 			return err;
 
 		if (npe_recv_message(npe, &msg, "ETH_GET_STATUS")) {
-			printk(KERN_ERR "%s: %s not responding\n", dev->name,
-			       npe_name(npe));
+			netdev_err(dev, "%s not responding\n", npe_name(npe));
 			return -EIO;
 		}
 		port->firmware[0] = msg.byte4;
@@ -1290,7 +1285,7 @@ static int eth_close(struct net_device *dev)
 	msg.eth_id = port->id;
 	msg.byte3 = 1;
 	if (npe_send_recv_message(port->npe, &msg, "ETH_ENABLE_LOOPBACK"))
-		printk(KERN_CRIT "%s: unable to enable loopback\n", dev->name);
+		netdev_crit(dev, "unable to enable loopback\n");
 
 	i = 0;
 	do {			/* drain RX buffers */
@@ -1314,11 +1309,11 @@ static int eth_close(struct net_device *dev)
 	} while (++i < MAX_CLOSE_WAIT);
 
 	if (buffs)
-		printk(KERN_CRIT "%s: unable to drain RX queue, %i buffer(s)"
-		       " left in NPE\n", dev->name, buffs);
+		netdev_crit(dev, "unable to drain RX queue, %i buffer(s)"
+			    " left in NPE\n", buffs);
 #if DEBUG_CLOSE
 	if (!buffs)
-		printk(KERN_DEBUG "Draining RX queue took %i cycles\n", i);
+		netdev_debug(dev, "draining RX queue took %i cycles\n", i);
 #endif
 
 	buffs = TX_DESCS;
@@ -1334,17 +1329,16 @@ static int eth_close(struct net_device *dev)
 	} while (++i < MAX_CLOSE_WAIT);
 
 	if (buffs)
-		printk(KERN_CRIT "%s: unable to drain TX queue, %i buffer(s) "
-		       "left in NPE\n", dev->name, buffs);
+		netdev_crit(dev, "unable to drain TX queue, %i buffer(s) "
+			    "left in NPE\n", buffs);
 #if DEBUG_CLOSE
 	if (!buffs)
-		printk(KERN_DEBUG "Draining TX queues took %i cycles\n", i);
+		netdev_debug(dev, "draining TX queues took %i cycles\n", i);
 #endif
 
 	msg.byte3 = 0;
 	if (npe_send_recv_message(port->npe, &msg, "ETH_DISABLE_LOOPBACK"))
-		printk(KERN_CRIT "%s: unable to disable loopback\n",
-		       dev->name);
+		netdev_crit(dev, "unable to disable loopback\n");
 
 	phy_stop(dev->phydev);
 
@@ -1476,8 +1470,8 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 	if ((err = register_netdev(ndev)))
 		goto err_phy_dis;
 
-	printk(KERN_INFO "%s: MII PHY %i on %s\n", ndev->name, plat->phy,
-	       npe_name(port->npe));
+	netdev_info(ndev, "%s: MII PHY %i on %s\n", ndev->name, plat->phy,
+		    npe_name(port->npe));
 
 	return 0;
 
-- 
2.21.0

