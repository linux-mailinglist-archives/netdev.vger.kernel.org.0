Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0AD2F0239
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 18:29:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726346AbhAIR2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 12:28:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725926AbhAIR2n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jan 2021 12:28:43 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8165CC0617A6
        for <netdev@vger.kernel.org>; Sat,  9 Jan 2021 09:27:31 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id p22so14381867edu.11
        for <netdev@vger.kernel.org>; Sat, 09 Jan 2021 09:27:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1LZnsJN1M+pkrehb1pvVSTb6lyQC3745w64XuTsV2c8=;
        b=JDAGyfSbmu9OX2ZGs7qD+yIZx94JrURb0YQdHvK2sufnOI37MwaFrtfuiLSGgF6qxF
         NRV/ZXS49Kee5BCI/o56b5GooGG/b0QxXZqkuM7uwgFwSYEDU8tQG7MANoMq3OnUTOmL
         7WgyHNWphGmISYS3jqnn/bAmUmVukdpXUs6nQWaUeoVcwhY/aRYblNAVP4jhKNoqIfJX
         wy1jUoOmF7bmjQvwvHc9yN074q96a/OCMWtFI/lKuDDDl6BLbA49rW9I370VCDDLLeYu
         TQ5Rv6uTDeBjEPrw8/cKJyAcF2xBm7GsuY+a2Uc6AwHlQwxeLlhgAk/Cfb0vXArahp24
         +3qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1LZnsJN1M+pkrehb1pvVSTb6lyQC3745w64XuTsV2c8=;
        b=pax5IbLYOLl3ZCbnxCevrRbfkKt7KNLIwLX+Bq4TH1XA6gkPVfLfMzVioZt/3lCpS7
         Bqk3NGtexFvfW60aKUP4afPkvRc7KjaZXhsSMSvOukw0J0HUSt0JndQCvZjhAb/sVNzT
         7mi24N+EPfylrzOjArEtteRk3p0wZjhcMo7cyaaYpZ6tWBwB8tTlP5Mdg+kHO7nTvGfW
         g+bPJRj1SR5SSdXmQfDC+YQmtMvnmB/Jcg7XEECruGcvI6xTUIcSzC1SOGEVBVeF9ZNN
         2GVcSEgkSJCPUWElmTO1Tm34SoW80fIdECyi6grHcVPLOiany8UC0Fp84pZYByBw4ZC5
         xn0g==
X-Gm-Message-State: AOAM533Iwj0Mu2x0zEeS8qCPgVF9bBFVQim2ESIMNdheE5GQhapvtU4j
        SFgnd2BMM+WjzUSUS9nhX7Y=
X-Google-Smtp-Source: ABdhPJz/D/ooYf07sEXAuHDPcyWlseRM5D8pjEL0ygLkm9abvg0YyuDOCXrV2QPU079WmFwXGKXdqg==
X-Received: by 2002:a05:6402:350:: with SMTP id r16mr8805364edw.176.1610213250245;
        Sat, 09 Jan 2021 09:27:30 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id h16sm4776714eji.110.2021.01.09.09.27.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Jan 2021 09:27:29 -0800 (PST)
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
Subject: [PATCH v6 net-next 06/15] parisc/led: hold the netdev lists lock when retrieving device statistics
Date:   Sat,  9 Jan 2021 19:26:15 +0200
Message-Id: <20210109172624.2028156-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210109172624.2028156-1-olteanv@gmail.com>
References: <20210109172624.2028156-1-olteanv@gmail.com>
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
Changes in v6:
None.

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

