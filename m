Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA3D2F0237
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 18:29:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbhAIR2I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 12:28:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725926AbhAIR2H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jan 2021 12:28:07 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B17A9C0617A3
        for <netdev@vger.kernel.org>; Sat,  9 Jan 2021 09:27:26 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id j16so14528225edr.0
        for <netdev@vger.kernel.org>; Sat, 09 Jan 2021 09:27:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9m3oKGvCSeWHdPInnGbCMaa6M732P3ZHcFpaYA/9tjc=;
        b=nZs1Sf5Ks5o97y3DH1rodjHLm8LbgfWAALJgwURcCeg1J1DTpZueNEmeJ6cnTy9Qcx
         YNDqN6ovAhvpeJrJt4XdNwD7XRib/RqwQIcfx4durYqNsjxJQ6R3HPwpU76EeA5n3JFi
         KT81ROsoVFL8jeDwPMKo29BDqblhwFP3HwkXP/VEOZA9m3h1SKyCZQ71FThlOM7weICy
         Qi8d6lIr025cn65F0+sRdVhsr/No+zg0mtlfRaYmbR1FCDQXbe7yQEAUk3/hhgS2G1ht
         vcv5+VGw9hCKEWEYSbuJ/E5Gpiu9oV22FIVISI7ezkNd6PN31yIg+550rjpJ19ZEeRSm
         oxHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9m3oKGvCSeWHdPInnGbCMaa6M732P3ZHcFpaYA/9tjc=;
        b=rS7gBLvO8yrALCAR/s5eC9KKc+sYdWA32BWf6s4Xl71pK2dFgCpuAx50zFViPRm5aS
         +A/k6HjUY3+OMe5zhPea6/eez9Pdz04GbqgFKKhTL8PDH7gXiLy9fnhogplfR0lICEWS
         W1fmYXt8dYFCXjKJJZiux35UO8wIUMzea7XPBlkNjPI8dD6olRaJmpqYGhReqyBd8bfS
         dlh9l787VII0yMGGGovE54lnn44MQFnN26boBfH58zJGsOjT1xRaa0PVYCpSdaYc/QU1
         S20S+YeJ7FopUo6kbbetxzK62M71SMW7/e0geFZPUpCYJw043eFQ8lNRGFvY0gZF6UbE
         CnKg==
X-Gm-Message-State: AOAM530f6gWRUco6EOsZjuu6jVcB3Vq/2MPQIOOfpYgVKROj1wrRoLpk
        49QpPGa0VSeCQDEGA8Mh0a4=
X-Google-Smtp-Source: ABdhPJzTCI4g2QX+ye8xRp4yRL7H6IN+mf90dRw2oXticPElMVgeLA1k4C8W8t80xT9gtRcyChAHiA==
X-Received: by 2002:a50:9dc9:: with SMTP id l9mr9051970edk.377.1610213245490;
        Sat, 09 Jan 2021 09:27:25 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id h16sm4776714eji.110.2021.01.09.09.27.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Jan 2021 09:27:24 -0800 (PST)
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
Subject: [PATCH v6 net-next 03/15] net: procfs: hold netif_lists_lock when retrieving device statistics
Date:   Sat,  9 Jan 2021 19:26:12 +0200
Message-Id: <20210109172624.2028156-4-olteanv@gmail.com>
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

The /proc/net/dev file uses an RCU read-side critical section to ensure
the integrity of the list of network interfaces, because it iterates
through all net devices in the netns to show their statistics.

To offer the equivalent protection against an interface registering or
deregistering, while also remaining in sleepable context, we can use the
netns mutex for the interface lists.

Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Eric Dumazet <edumazet@google.com>
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

 net/core/net-procfs.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/core/net-procfs.c b/net/core/net-procfs.c
index c714e6a9dad4..4784703c1e39 100644
--- a/net/core/net-procfs.c
+++ b/net/core/net-procfs.c
@@ -21,7 +21,7 @@ static inline struct net_device *dev_from_same_bucket(struct seq_file *seq, loff
 	unsigned int count = 0, offset = get_offset(*pos);
 
 	h = &net->dev_index_head[get_bucket(*pos)];
-	hlist_for_each_entry_rcu(dev, h, index_hlist) {
+	hlist_for_each_entry(dev, h, index_hlist) {
 		if (++count == offset)
 			return dev;
 	}
@@ -51,9 +51,11 @@ static inline struct net_device *dev_from_bucket(struct seq_file *seq, loff_t *p
  *	in detail.
  */
 static void *dev_seq_start(struct seq_file *seq, loff_t *pos)
-	__acquires(RCU)
 {
-	rcu_read_lock();
+	struct net *net = seq_file_net(seq);
+
+	netif_lists_lock(net);
+
 	if (!*pos)
 		return SEQ_START_TOKEN;
 
@@ -70,9 +72,10 @@ static void *dev_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 }
 
 static void dev_seq_stop(struct seq_file *seq, void *v)
-	__releases(RCU)
 {
-	rcu_read_unlock();
+	struct net *net = seq_file_net(seq);
+
+	netif_lists_unlock(net);
 }
 
 static void dev_seq_printf_stats(struct seq_file *seq, struct net_device *dev)
-- 
2.25.1

