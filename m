Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4352EEA4D
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 01:22:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729581AbhAHAVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 19:21:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728954AbhAHAVq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 19:21:46 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3D9FC0612FC
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 16:20:34 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id j16so9552001edr.0
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 16:20:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NWtlC2pRbs7Vuh1iGh0EBnavfB9JKI0yPpfyWj9/vXM=;
        b=SyivryvtAOrIQF4Di6q4ZXNgrDiypv8PtYOCXhanRRE1JfmPRBBrxihEm/eXOorIXg
         dvQlaIJ6GESefnL3Ruz13iBKCFugrCXYINsJNKMlJKTW8qbLe/BRS5p6K2Few6YajUCI
         f6uN5KgSNShYW03MW6bbH7Uo8F0gkeVvCqL0Op+IOhyh2isHeHhKM9aX9ha92SnbKH5w
         AGHCaXEB75ZGeBSnsoDYAIAxoS3ZRC3HpOvPW0BoN5UE85ey0TpgY1xMKVmJJ5l9V9F5
         bUGtphC+1ce7kEW0UNExrTOmk2CEvN79qAYOo3CGA/9pXUARfBzkeW6O6ENR24ohNyi2
         R+Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NWtlC2pRbs7Vuh1iGh0EBnavfB9JKI0yPpfyWj9/vXM=;
        b=Inw7sOaeSz6aHGHs4ddkbENX8QsteivmwfDejIdExbPKybFbafIIshjgrBfiyjf/FB
         Oupy59FByiMBUktataW/10S1E4ttF+VpEsa8mW83T0fhzyB5YPOOKXEeVfp6AjddFRgj
         L8n2ZJy614lb4g4W8Ox/VenTGPIVeemjqj4XSP5OdDZNK8oEs7/N5P0yz8ZtpmkCf1Km
         ycK6Bsc2NzQK4xtS4+Rs22lCi8eQUfba4cb4Dg3f5ZqTm1hdjNdz28QfpgtKj07pHCbA
         SMQJ4dnW87KCkAEiXXZMeuyehNuBhWdh+iuobxD0lu9RIwiqec/wQ5J3GVpHlRsXyZ4T
         6O0g==
X-Gm-Message-State: AOAM530qXdVzDVI/kFMENIWnrixdDrGuDQWL1fliYm/yuLC6hbKy6z2I
        6fHUdkfYxvHXX3Bp4GAME9Y=
X-Google-Smtp-Source: ABdhPJxsZS0qj8UnxUqXAcUAgXlVBcBe8VCFTjTDK+gFQFoRLEuK9PANxTVB2u8mwpL7DLzIUW1k+w==
X-Received: by 2002:a05:6402:1caa:: with SMTP id cz10mr3438561edb.345.1610065233665;
        Thu, 07 Jan 2021 16:20:33 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id rk12sm2981691ejb.75.2021.01.07.16.20.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 16:20:33 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
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
Subject: [PATCH v4 net-next 07/18] parisc/led: hold the netdev lists lock when retrieving device statistics
Date:   Fri,  8 Jan 2021 02:19:54 +0200
Message-Id: <20210108002005.3429956-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210108002005.3429956-1-olteanv@gmail.com>
References: <20210108002005.3429956-1-olteanv@gmail.com>
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
Changes in v4:
None.

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

