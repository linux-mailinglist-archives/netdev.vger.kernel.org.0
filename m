Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A80022ECD44
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 10:53:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727924AbhAGJvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 04:51:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727903AbhAGJvq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 04:51:46 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B22BC061257
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 01:51:11 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id g20so8937147ejb.1
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 01:51:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0lIb6M9mgiYZY3hRKhHnSuCWG9h9HMO9fL86gPEBXrk=;
        b=WxvOVyjpUGzb2w35wYJGGUpLJ/e6rgZHMPza23pE2a5jOMUomQt6SarMAshUbmDmCt
         jKOztPdRw1oSLDD/kQ9GGOWmvcXgyux9KX46EEZj4bYRnsINRncR1m/Pq+NMoPHNlB8Y
         izlSacERS5Nlp6r8hckhTWqYgwozgVNNKVDz6s6ankBIiD2P0c2CwVNqjaEXds/1azft
         Rd9II9fbn1hl5V+8lCCFCV73A5sz1dks0hgf5U5+LKRLmoywRie+/jgMQgLYr1C9fLme
         s9OxQrhFWROZO2LJA1g4C9PHELdSF4PibUq1GVs9PtzebC+zrY0+chZ89gejGUg5VAdt
         DubQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0lIb6M9mgiYZY3hRKhHnSuCWG9h9HMO9fL86gPEBXrk=;
        b=BUg7JZBwGUiXQmTvEpH+LAAOZ15xDpft9aQd39gyfUtj9nof80P9K2Nk8NxCN8edPZ
         2/hvfL9hScj/SnTGhEDrHfnpj4MIO9HHOVmMj5lCcuCMN48LU8jc1gGrCBLyPIg8DQ8s
         kDUZsHKjTCR9sVBSHvNYcMrGfKGYR0CQ3WAKyBCpE+qgZxC1blpDEyXZIjUgyMuDekQR
         5ZwFSt+DhCKjBFQcZ11OsL6zzfgS7yzF0FtFt5Js/fMW4B47yowR5M6jX9w6zMv445UY
         nkpiG3YwewtEwhpUodi2X0VSaAYRGEbnJnV8AAKjUkadUB6tbpsdQmTxb9wg+VTrqzjy
         p3cA==
X-Gm-Message-State: AOAM531e01WoSKIYXmuoNF5APBjdNke/GLOeUIvVke22m2aYhUP1hsv8
        MhQwyD/aEdSAwC/8W3ZaE8g=
X-Google-Smtp-Source: ABdhPJxy43sPMdDo4ftMVGMLK1FBqpRFE28YB0T+rAgSZaq1RJNqoYU4CcqYdAHKzpr4Jmk0JvcIlw==
X-Received: by 2002:a17:906:9382:: with SMTP id l2mr6013251ejx.162.1610013070160;
        Thu, 07 Jan 2021 01:51:10 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id k15sm2251571ejc.79.2021.01.07.01.51.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 01:51:09 -0800 (PST)
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
Subject: [PATCH v3 net-next 05/12] s390/appldata_net_sum: hold the netdev lists lock when retrieving device statistics
Date:   Thu,  7 Jan 2021 11:49:44 +0200
Message-Id: <20210107094951.1772183-6-olteanv@gmail.com>
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

