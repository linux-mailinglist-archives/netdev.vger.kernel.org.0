Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD9F12EF5CF
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 17:33:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728352AbhAHQdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 11:33:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbhAHQdH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 11:33:07 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E25B8C06129D
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 08:32:26 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id cw27so11796553edb.5
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 08:32:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nWee4KpFbXrnfWRrreVtff9vSyduFCVI9av5RdVizU0=;
        b=IfdvAJrxigF9mbShzC1YYZn5DDYBclFRLJqqiHZQkobni2ND4k5ueplKm6QiaVk1T9
         p9pWPQcLLdO+O6QWg/Ut8jiaZFc9V7iPJM8POHNk1Xx3DwO1vLXp2GNSAMiBVTOYzz/q
         cIiOENC/FVM14EGmfw4exhBlhRfoBKXe9jCKnhLhzi74OvOrdlRLQ1jtCNeSJSKW636Y
         ifH+DDyU4SAznssMquntJKks6LRWDhBnVCtK+JPggIZcC/P6t81MRF+hSPQ+UtVqHicL
         0LP/hJmQKxLKJZFQT9pPqZsFowYFt8XvGhCrooyp+FzYPFRpiQSQhRAyQd2khdRuYz59
         l91w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nWee4KpFbXrnfWRrreVtff9vSyduFCVI9av5RdVizU0=;
        b=sak7IIxbxhi7JVUmWS7nIVupNQ7i0mUqic/MJMYFdw1S5R3Yer7wi2LXhWEJGpoin5
         FyWNH598JAuZGy0SoarNuhY8Wc686HvNCRb4pXPpITA+kmUlWNlYv31BkGUO8IEbPyIJ
         HzmXaOI0ZocDvqHUflkS7uNUmAwq3VIkdxrYZ7cyy57XtSRuYIOPNXJJrB2hIMlZC/JF
         A1Qgw0jh/73Ild/58Va1yLqQa1z0Lg3EheSQUaVy+FeLGrZusdJFyd1tML1010obO03F
         75uXHimHFwZGtLURbiAsWTR9tXIKKHcLsaHXDvIT3eoyeMsu2b691qXJIyT/nLajE0lz
         IpAQ==
X-Gm-Message-State: AOAM533Lmhgwul2HH/1hdnVhnCfuslXxJPYzkALsYNK0NWY5Y2Otdswi
        szKm6pojkFnpg25tmgM0qEI=
X-Google-Smtp-Source: ABdhPJz+UuMSQ8Z7bY+bBWEoeenWVh6yPfNJsnSdovJpl/gCo4sObCuZTXKbOPSp0ho4NS0UKA5Faw==
X-Received: by 2002:aa7:dc4b:: with SMTP id g11mr6028980edu.379.1610123545700;
        Fri, 08 Jan 2021 08:32:25 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id x6sm3957737edl.67.2021.01.08.08.32.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 08:32:25 -0800 (PST)
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
Subject: [PATCH v5 net-next 05/16] s390/appldata_net_sum: hold the netdev lists lock when retrieving device statistics
Date:   Fri,  8 Jan 2021 18:31:48 +0200
Message-Id: <20210108163159.358043-6-olteanv@gmail.com>
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

In the case of the appldata driver, an RCU read-side critical section is
used to ensure the integrity of the list of network interfaces, because
the driver iterates through all net devices in the netns to aggregate
statistics. We still need some protection against an interface
registering or deregistering, and the writer-side lock, the netns's
mutex, is fine for that, because it offers sleepable context.

The ops->callback function is called from under appldata_ops_mutex
protection, so this is proof that the context is sleepable and holding
a mutex is therefore fine.

Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: linux-s390@vger.kernel.org
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v5:
None.

Changes in v4:
None.

Changes in v3:
None.

Changes in v2:
None.

 arch/s390/appldata/appldata_net_sum.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/s390/appldata/appldata_net_sum.c b/arch/s390/appldata/appldata_net_sum.c
index 59c282ca002f..4db886980cba 100644
--- a/arch/s390/appldata/appldata_net_sum.c
+++ b/arch/s390/appldata/appldata_net_sum.c
@@ -78,8 +78,9 @@ static void appldata_get_net_sum_data(void *data)
 	tx_dropped = 0;
 	collisions = 0;
 
-	rcu_read_lock();
-	for_each_netdev_rcu(&init_net, dev) {
+	netif_lists_lock(&init_net);
+
+	for_each_netdev(&init_net, dev) {
 		const struct rtnl_link_stats64 *stats;
 		struct rtnl_link_stats64 temp;
 
@@ -95,7 +96,8 @@ static void appldata_get_net_sum_data(void *data)
 		collisions += stats->collisions;
 		i++;
 	}
-	rcu_read_unlock();
+
+	netif_lists_unlock(&init_net);
 
 	net_data->nr_interfaces = i;
 	net_data->rx_packets = rx_packets;
-- 
2.25.1

