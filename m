Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0E32ECD46
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 10:53:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727943AbhAGJvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 04:51:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727906AbhAGJvr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 04:51:47 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62CB4C0612FD
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 01:51:14 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id d17so8807108ejy.9
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 01:51:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZY8ji9fFG08blymAp9Y+P4geDkhw8vQUxrybxWKW3qs=;
        b=GEJ1kf+Ks1TUZNQcMn67KWGzsLJSAspBL/9c1SwcRXezRM/W134BYJLbqxkMBn6fUU
         aYmq7+k50UhlrD3gwzyWXFxCECIjyeDAp2Rf7Cla9MTSOs6QOLkpOW7lpce5l5/y/ZKN
         GlBp+pJ6LxzmkfGNBb49+YxMtpDBS/O7dXM+JZzvvcg+FtEHYk8+f8VZAKrLK61juAfB
         vDXhWaH2BA/56KHTDlczed0zsK1gGgxmtFKJ+Kn0/sR8SoKigcU6Oqtr4w2DSoIIJIGC
         z2v5OhN0oVz7S31kGviDUGlFctAJJh7tVh6bnGJdsRMjKFF3/Ir03ElNQXqwv06LJIxw
         jxYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZY8ji9fFG08blymAp9Y+P4geDkhw8vQUxrybxWKW3qs=;
        b=Z/cd7ue3L/P5Gk3oPuHysL+E/hDkc1hOQjafipy872YskcZSDsw2yl2fZU9AtZw7Zx
         L11IaPh5gImAWgjHLJOHZwgpsCQ9pA86rNSsWek8UBBJOmXdAwMjkh0q+8UBnLmw6ywo
         ZRsw6rD0xJ8ANYVHLy7xP6tmNqG7GmaWUZxpdLg29gATkH4K1q5R4wbzAvc5wGnmiDdx
         yiMEGxuXReXV3RxmGSky+D4NXSsECCGWqpq1UuVLjbEWXn3lO1D2eoEUmzQ3qRAQyiLi
         4aZZl3KK2ALRj94tJex6/1Ov2pDZz4ukOudsvqXZ+6jRQGXGC1ypYTWfg0ZXaoPePFiN
         KmzQ==
X-Gm-Message-State: AOAM530jhAW7j+RSOkMr6fPq1a5a8JJsaWG07M/z3+T6xWf1RJZ6Rl7b
        6vdqdY4MlKR428ki06HXmw4=
X-Google-Smtp-Source: ABdhPJyA1behA7NXwJ0YIyS1peKH1CCoP6WXTV5ZK39bP3NiTOffT6hW+PaWZvK8S+0fZRRpTQX74w==
X-Received: by 2002:a17:906:3a98:: with SMTP id y24mr5319017ejd.436.1610013073187;
        Thu, 07 Jan 2021 01:51:13 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id k15sm2251571ejc.79.2021.01.07.01.51.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 01:51:12 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Arnd Bergmann <arnd@arndb.de>, Taehee Yoo <ap420073@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, Florian Westphal <fw@strlen.de>
Subject: [PATCH v3 net-next 07/12] parisc/led: hold the netdev lists lock when retrieving device statistics
Date:   Thu,  7 Jan 2021 11:49:46 +0200
Message-Id: <20210107094951.1772183-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210107094951.1772183-1-olteanv@gmail.com>
References: <20210107094951.1772183-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

In the effort of making .ndo_get_stats64 be able to sleep, we need to
ensure the callers of dev_get_stats do not use atomic context.

The LED driver for HP-PARISC workstations uses a workqueue to
periodically check for updates in network interface statistics, and
flicker when those have changed (i.e. there has been activity on the
line). Ignoring the fact that this driver is completely duplicating
drivers/leds/trigger/ledtrig-netdev.c, there is an even bigger problem.
Now, the dev_get_stats call can sleep, and iterating through the list of
network interfaces still needs to ensure the integrity of list of
network interfaces. So that leaves us only one locking option given the
current design of the network stack, and that is the netns mutex.

Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Helge Deller <deller@gmx.de>
Cc: linux-parisc@vger.kernel.org
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
None.

Changes in v2:
None.

 drivers/parisc/led.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/parisc/led.c b/drivers/parisc/led.c
index 3cada632a4be..c8c6b2301dc9 100644
--- a/drivers/parisc/led.c
+++ b/drivers/parisc/led.c
@@ -38,7 +38,6 @@
 #include <linux/ctype.h>
 #include <linux/blkdev.h>
 #include <linux/workqueue.h>
-#include <linux/rcupdate.h>
 #include <asm/io.h>
 #include <asm/processor.h>
 #include <asm/hardware.h>
@@ -355,25 +354,29 @@ static __inline__ int led_get_net_activity(void)
 	int retval;
 
 	rx_total = tx_total = 0;
-	
-	/* we are running as a workqueue task, so we can use an RCU lookup */
-	rcu_read_lock();
-	for_each_netdev_rcu(&init_net, dev) {
+
+	/* we are running as a workqueue task, so we can sleep */
+	netif_lists_lock(&init_net);
+
+	for_each_netdev(&init_net, dev) {
+		struct in_device *in_dev = in_dev_get(dev);
 		const struct rtnl_link_stats64 *stats;
 		struct rtnl_link_stats64 temp;
-		struct in_device *in_dev = __in_dev_get_rcu(dev);
 
-		if (!in_dev || !in_dev->ifa_list)
+		if (!in_dev || !in_dev->ifa_list ||
+		    ipv4_is_loopback(in_dev->ifa_list->ifa_local)) {
+			in_dev_put(in_dev);
 			continue;
+		}
 
-		if (ipv4_is_loopback(in_dev->ifa_list->ifa_local))
-			continue;
+		in_dev_put(in_dev);
 
 		stats = dev_get_stats(dev, &temp);
 		rx_total += stats->rx_packets;
 		tx_total += stats->tx_packets;
 	}
-	rcu_read_unlock();
+
+	netif_lists_unlock(&init_net);
 
 	retval = 0;
 
-- 
2.25.1

