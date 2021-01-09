Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B98D82F023A
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 18:29:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbhAIR2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 12:28:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbhAIR2n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jan 2021 12:28:43 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF8C9C0617A5
        for <netdev@vger.kernel.org>; Sat,  9 Jan 2021 09:27:29 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id u19so14506900edx.2
        for <netdev@vger.kernel.org>; Sat, 09 Jan 2021 09:27:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=u84TeGJaXfTDMnhIuYMOBv+8WC6ikVA8oDqJpLmIyoM=;
        b=no3UtteUB2UmggiV2TaEXxv56kdtZJxCaAAM4C0lNj11Fu70+aWQd1fttDsYWZRdgq
         AGQgknke41Pi14UO36DqmxF2IRPgUb8sfEqbW353y0GlS8SkX1GMscqnJlbQ8YI4A1dg
         1/aHvSIOM4oj86XIwOepdtL3VQtqt1igY7EeQoU+CboY0ZKZsCzRYx8fBWelSWzTVE3w
         hz2kwfefNVKnVNtaysSmyFETpaywf/IveWQJN9nOH7+NHBuO4ntRQfeYLtZSzt8xUTbz
         QfZbKNoBCIGaAJuIWb4FBS4aQbc44Qx0/zyUtQAuSL+3XNPRgzLTm/RhyuIy3PUNfd+o
         pFOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u84TeGJaXfTDMnhIuYMOBv+8WC6ikVA8oDqJpLmIyoM=;
        b=il775nDDhb+iZnlDHKDkMi/6MvnH96kR3XA23QYCcqPaaUihj4jkc2iQBO6+M8XTcL
         fo5LEwu3hNexzCoND8YnRugVeRe1kbKBcql0uTN008kWd6jTjAgpwY7FCQLS6rEsV/rx
         Z/WOM1b95xSvEjhtb6DbsbjzyuUtELYMuo1KT5kvC3VSgr7s3Sy7Zj6KCkfXnjAz9WCD
         cdD0AW4fmQL/4w5JBSR9vHtkXc2PocWekX2VSfR7Tuft24W2E7WTO6umHUbgMuD0aT4R
         gw1p4W6FbO3Zcx5py977TRBN+wT7zNMto2wYvFHQvPEF/MddUjtvwQ9gN9u0/yT66LgT
         QldA==
X-Gm-Message-State: AOAM531LT5lXHlfJ8n7AvjH0CfUmZVzpMWGYDn8dS1BOI5xVmL2W83JT
        kK8YNbKUwiwGU4O3Mz1JoXs=
X-Google-Smtp-Source: ABdhPJz5uPiqA7SGPE+urOaQpthPVBfsKMtSpkG1eGhBNZcPVGEwc1iwlMGrNcXPJxUnmCUU80exvg==
X-Received: by 2002:aa7:cccf:: with SMTP id y15mr9116436edt.112.1610213248668;
        Sat, 09 Jan 2021 09:27:28 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id h16sm4776714eji.110.2021.01.09.09.27.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Jan 2021 09:27:28 -0800 (PST)
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
Subject: [PATCH v6 net-next 05/15] s390/appldata_net_sum: hold the netdev lists lock when retrieving device statistics
Date:   Sat,  9 Jan 2021 19:26:14 +0200
Message-Id: <20210109172624.2028156-6-olteanv@gmail.com>
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
Changes in v6:
None.

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

