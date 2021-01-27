Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 413AD3053D7
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 08:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232688AbhA0HBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 02:01:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S317061AbhA0BB2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 20:01:28 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93E90C061756
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 17:00:46 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id l9so322231ejx.3
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 17:00:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0Am7SMgb71ydMP2EFwNgiIs4H5+omxj5hpCIEUTUG4s=;
        b=kjPLS3dmyXsv9Or6TCttKONkMhwbmLThaZD4705DkPfomBze7rafkfZBZo8FxXLDXG
         VKbxAzsjfbrHmYyEgVZz0PVrgMHPUiquOWb0EO3L7HfPysxOJRibLyobleAz/Ogk3f31
         J7nmHyeiktehnO5A8jLpiRrRlEMyafyMzA26Um0RCwDa4T8aCuGzXZ3UparEnLF2DPUW
         X+/B795Sv6OZwTPwJ9P5xfw8nkPJSIUDvsVYiWwAdkSP1ClDUqHn0n0w/tf1UKXu+yih
         Qt26JFcLqnmEHwynDI1ZpjCmQdQaDg09+y2cLFqW5UDJ2lHpE2UL589jiqBldpqE+ZsS
         40/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0Am7SMgb71ydMP2EFwNgiIs4H5+omxj5hpCIEUTUG4s=;
        b=dzoItyU9Pli0P+GwxeSzGHqiNWik46uGx4H6CD4B2/UQUQbq3895qwPIrJA/hGHqTg
         jLdTkUZFnAEGjKBTvvXWPoxFxFuSMJEsDbcU6XRTsI3lHWMYQNgFYvcESm+mMwuiS+pI
         TFnsF2emtqWClKHIPssy/0RPaYK4aHO0vayOl8X6bt8P+3cIdTSP7RrAf3NLICyHB702
         g/hOiyW+TDa7fY7TDSa2e1m7Wt9UhBO4FgB8DDQNqcLIb6G77IKhEFdVkFyBB8XTuW/+
         GklKCiN5lGHz/Q8ADACGvhN1VWL1/OzrUDfDVqGyei2hVXmjYg9U0bkqo55MB7q4BCPs
         cFnw==
X-Gm-Message-State: AOAM530p1tjuvZrHhfY3V2wdQQqIzHrZbMCtueaE7SAuLYHsxvFCntZy
        r9RIVZFlMrxgVzbNz6d61YM=
X-Google-Smtp-Source: ABdhPJxLdopwA1NqJIVc0amYlhERcHI/FCLUvlMYGhI8qi/A7ZS1oRe3iZPW/5NlB8816kvKL4bFxA==
X-Received: by 2002:a17:906:2a42:: with SMTP id k2mr4989797eje.118.1611709245387;
        Tue, 26 Jan 2021 17:00:45 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id ko23sm115897ejc.35.2021.01.26.17.00.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 17:00:44 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: [PATCH net-next 3/4] Revert "net: Have netpoll bring-up DSA management interface"
Date:   Wed, 27 Jan 2021 03:00:27 +0200
Message-Id: <20210127010028.1619443-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210127010028.1619443-1-olteanv@gmail.com>
References: <20210127010028.1619443-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This reverts commit 1532b9778478577152201adbafa7738b1e844868.

The above commit is good and it works, however it was meant as a bugfix
for stable kernels and now we have more self-contained ways in DSA to
handle the situation where the DSA master must be brought up.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/core/netpoll.c | 22 ++++------------------
 1 file changed, 4 insertions(+), 18 deletions(-)

diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 960948290001..c310c7c1cef7 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -29,7 +29,6 @@
 #include <linux/slab.h>
 #include <linux/export.h>
 #include <linux/if_vlan.h>
-#include <net/dsa.h>
 #include <net/tcp.h>
 #include <net/udp.h>
 #include <net/addrconf.h>
@@ -658,15 +657,15 @@ EXPORT_SYMBOL_GPL(__netpoll_setup);
 
 int netpoll_setup(struct netpoll *np)
 {
-	struct net_device *ndev = NULL, *dev = NULL;
-	struct net *net = current->nsproxy->net_ns;
+	struct net_device *ndev = NULL;
 	struct in_device *in_dev;
 	int err;
 
 	rtnl_lock();
-	if (np->dev_name[0])
+	if (np->dev_name[0]) {
+		struct net *net = current->nsproxy->net_ns;
 		ndev = __dev_get_by_name(net, np->dev_name);
-
+	}
 	if (!ndev) {
 		np_err(np, "%s doesn't exist, aborting\n", np->dev_name);
 		err = -ENODEV;
@@ -674,19 +673,6 @@ int netpoll_setup(struct netpoll *np)
 	}
 	dev_hold(ndev);
 
-	/* bring up DSA management network devices up first */
-	for_each_netdev(net, dev) {
-		if (!netdev_uses_dsa(dev))
-			continue;
-
-		err = dev_change_flags(dev, dev->flags | IFF_UP, NULL);
-		if (err < 0) {
-			np_err(np, "%s failed to open %s\n",
-			       np->dev_name, dev->name);
-			goto put;
-		}
-	}
-
 	if (netdev_master_upper_dev_get(ndev)) {
 		np_err(np, "%s is a slave device, aborting\n", np->dev_name);
 		err = -EBUSY;
-- 
2.25.1

