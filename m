Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1FB62EF5D5
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 17:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728379AbhAHQdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 11:33:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbhAHQdP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 11:33:15 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E188C06129E
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 08:32:28 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id jx16so15240924ejb.10
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 08:32:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=E9iRmSVoF8I/r13cuXGMViMMER2pxnrCkc9beiQWXCE=;
        b=MXmQNuLSBhvuKHVstCHaARNpfEnlOOBX8lUCS8RHJPaqpvz65FPfvQRgy4fGmOOBXt
         ecNt2DVVd2mmz1TfQq9NanTxonyqW35V7LTyVw+I01rc61yMdEMGkaIkuaHy1eh3rSCO
         dhixMnwbT3Yl29YJ5VLm7Wa07EEThKtWaAukMJtMQSF05j66Ygmv8DGPYWkq4erQYwlO
         H9ubnAzHFQwv5ptYvFbbGQIhtGNDLNCCq6dvt+wfnSG+cgI+qjETJykcGj8C4IBWXKg+
         jSqIhgy8Cm7HJuoQi5R29bAaYyzClL7gSpGgcG5uf9PguAs2cfufCJG0O+TXcEf9XiqB
         EHkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E9iRmSVoF8I/r13cuXGMViMMER2pxnrCkc9beiQWXCE=;
        b=T94/Hw7cmDSCxudH0jR7/wFhFTz4zMt0QzjVLji0POQkO/HVmVlRFSPW6hfRN6I5JI
         hH8nIHGnc/Qjggb7+zaj62tVkCmxczgeBgkRWllMuKY9LunkFEIkesORDNY5Tppxexm+
         M/FrHHXek2jI6LM0nMt1Y7qg2ZvMKpQGhoVbeQsqbQ7nc+guUHKM0J5YbWxAHMENgHhO
         4yg4TVaA0QkIcjESykWk6cWyAtM14PwJGYe/kXBCbvsQ4YCi86hJGZmoQLHR9MMPnnpe
         KoKLm/2LHbcazk9I8m0wl4CipgiQLHB/p9fWx84KU6pzje1zM9Qhd6nUoq7Bmxz1sKGS
         BZxw==
X-Gm-Message-State: AOAM5337q/B5Y0Iheuc5kZokwKh0Eg5WOr5pU0GF6JsI5zyq3o8AA2GJ
        rsQNSNIAwfaDCeqLpWVJobA=
X-Google-Smtp-Source: ABdhPJykD7cNF0ItuaDKkzQBupAjMR/LBWYjAwznpuaqF6NW7wgyMCD4Xb8/pQF8028v5wtDcgGcYA==
X-Received: by 2002:a17:906:d93c:: with SMTP id rn28mr3150306ejb.50.1610123547211;
        Fri, 08 Jan 2021 08:32:27 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id x6sm3957737edl.67.2021.01.08.08.32.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 08:32:26 -0800 (PST)
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
        Jiri Pirko <jiri@resnulli.us>, Florian Westphal <fw@strlen.de>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH v5 net-next 06/16] parisc/led: hold the netdev lists lock when retrieving device statistics
Date:   Fri,  8 Jan 2021 18:31:49 +0200
Message-Id: <20210108163159.358043-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210108163159.358043-1-olteanv@gmail.com>
References: <20210108163159.358043-1-olteanv@gmail.com>
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

This patch also reindents the code that gathers device statistics, since
the standard in the Linux kernel is to use one tab character per
indentation level.

Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Helge Deller <deller@gmx.de>
Cc: linux-parisc@vger.kernel.org
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v5:
Squashed with the reindenting of the code.

Changes in v4:
None.

Changes in v3:
None.

Changes in v2:
None.

 drivers/parisc/led.c | 38 ++++++++++++++++++++++----------------
 1 file changed, 22 insertions(+), 16 deletions(-)

diff --git a/drivers/parisc/led.c b/drivers/parisc/led.c
index 36c6613f7a36..c8c6b2301dc9 100644
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
@@ -355,22 +354,29 @@ static __inline__ int led_get_net_activity(void)
 	int retval;
 
 	rx_total = tx_total = 0;
-	
-	/* we are running as a workqueue task, so we can use an RCU lookup */
-	rcu_read_lock();
-	for_each_netdev_rcu(&init_net, dev) {
-	    const struct rtnl_link_stats64 *stats;
-	    struct rtnl_link_stats64 temp;
-	    struct in_device *in_dev = __in_dev_get_rcu(dev);
-	    if (!in_dev || !in_dev->ifa_list)
-		continue;
-	    if (ipv4_is_loopback(in_dev->ifa_list->ifa_local))
-		continue;
-	    stats = dev_get_stats(dev, &temp);
-	    rx_total += stats->rx_packets;
-	    tx_total += stats->tx_packets;
+
+	/* we are running as a workqueue task, so we can sleep */
+	netif_lists_lock(&init_net);
+
+	for_each_netdev(&init_net, dev) {
+		struct in_device *in_dev = in_dev_get(dev);
+		const struct rtnl_link_stats64 *stats;
+		struct rtnl_link_stats64 temp;
+
+		if (!in_dev || !in_dev->ifa_list ||
+		    ipv4_is_loopback(in_dev->ifa_list->ifa_local)) {
+			in_dev_put(in_dev);
+			continue;
+		}
+
+		in_dev_put(in_dev);
+
+		stats = dev_get_stats(dev, &temp);
+		rx_total += stats->rx_packets;
+		tx_total += stats->tx_packets;
 	}
-	rcu_read_unlock();
+
+	netif_lists_unlock(&init_net);
 
 	retval = 0;
 
-- 
2.25.1

