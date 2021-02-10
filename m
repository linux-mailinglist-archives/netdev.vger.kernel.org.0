Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD8C9316224
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 10:26:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbhBJJ0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 04:26:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbhBJJVS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 04:21:18 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7749FC0617AA;
        Wed, 10 Feb 2021 01:19:27 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id bl23so2828119ejb.5;
        Wed, 10 Feb 2021 01:19:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aF26U34aBL8K6bVtwaJCBU2DkCwMTfcd91sYoywprTY=;
        b=WCKQ+LtKE/UOlQrWFxrHn28+qeGzJlG6joOQzDOEXxMuc52/bvbwwIWCJfpSdEnemZ
         i9+ZCibdt0/ARIwOmkJfNQQx3wjQfdNwdri68i5YfKJC57taNHzwEPJoLse0GkTvHUBu
         d3oCV0gH5620B/1/yyQ4yYuEUQNqbhWqbJClWRwEJJRbT06RhSnIMfyV06exk1J9ZNrb
         Q64okac0fkO1ek5M9R7yG/XL04bchQfjJxOIQzLwwxD3ZPcwLvU0H4pEWMwA6HAWRpT2
         yRVark7GGOD3fhXGEPbP7xu6nHE/k6LJijyA0s/cg4QhLuCl+evXa7iYZk4tLFOupnen
         81KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aF26U34aBL8K6bVtwaJCBU2DkCwMTfcd91sYoywprTY=;
        b=NuL8WBwMWTr0nZUVmTni0gGobHiChQtd4WZx+/qI3prY1HqfgD2fxfpRzGWXY1t3fy
         gbAl9uEtCnN8qmBo9gdUtchrSgY7foXnVFLUjK/jH6Zp36hc8cpuE0EnjfPBTj5vDpn+
         7JOGvHPA+Zw8tZxwn1qqklnu7D15yHpGhh2++GsQp1VcVfzcYCbUi5uCHU2FE6mYuvG4
         tFbGScLHzSP/rq7sfjdQP8OyTQNyLZgwq202CAau5+LGFNfIq9UyiFHFFkU5qg6ADblf
         0v25fmjABWyy0p3TIEqhwrtJBM27fhFlXqVadG+E+N6v/QzlJiu0KchKj75NN73A7Y9n
         FPTw==
X-Gm-Message-State: AOAM532svIlG6suCMdYA+CoNwB+WMl20fYpwU1zSrQPiJijH1fXKKtZA
        G8XOqEF99xl5kg8BHa14KvZI03MeV0w=
X-Google-Smtp-Source: ABdhPJyOFyh2p51yy4aH1LdzJT0MofdRrOkRGV9M/hCkCO5WkB20mLsXy8PAiOIM/CjJqHRPKNce/w==
X-Received: by 2002:a17:906:4c85:: with SMTP id q5mr1987915eju.375.1612948766169;
        Wed, 10 Feb 2021 01:19:26 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id u2sm701801ejb.65.2021.02.10.01.19.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 01:19:25 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org
Subject: [PATCH v3 net-next 08/11] net: bridge: put SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS on the blocking call chain
Date:   Wed, 10 Feb 2021 11:14:42 +0200
Message-Id: <20210210091445.741269-9-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210210091445.741269-1-olteanv@gmail.com>
References: <20210210091445.741269-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Since we would like br_switchdev_set_port_flag to not use an atomic
notifier, it should be called from outside spinlock context.

We can temporarily drop br->lock, but that creates some concurrency
complications (example below is given for sysfs):
- There might be an "echo 1 > multicast_flood" simultaneous with an
  "echo 0 > multicast_flood". The result of this is nondeterministic
  either way, so I'm not too concerned as long as the result is
  consistent (no other flags have changed).
- There might be an "echo 1 > multicast_flood" simultaneous with an
  "echo 0 > learning". My expectation is that none of the two writes are
  "eaten", and the final flags contain BR_MCAST_FLOOD=1 and BR_LEARNING=0
  regardless of the order of execution. That is actually possible if, on
  the commit path, we don't do a trivial "p->flags = flags" which might
  overwrite bits outside of our mask, but instead we just change the
  flags corresponding to our mask.

Now that br_switchdev_set_port_flag is never called from under br->lock,
it runs in sleepable context.

All switchdev drivers handle SWITCHDEV_PORT_ATTR_SET as both blocking
and atomic, so no changes are needed on that front.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
- Drop the br->lock around br_switchdev_set_port_flag in this patch, for
  both sysfs and netlink.
- Only set/restore the masked bits in p->flags to avoid concurrency
  issues.

Changes in v2:
Patch is new.

 net/bridge/br_netlink.c   | 10 +++++++---
 net/bridge/br_switchdev.c |  5 ++---
 net/bridge/br_sysfs_if.c  | 22 ++++++++++++++--------
 3 files changed, 23 insertions(+), 14 deletions(-)

diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index b7731614c036..8f09106966c4 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -869,7 +869,7 @@ static void br_set_port_flag(struct net_bridge_port *p, struct nlattr *tb[],
 static int br_setport(struct net_bridge_port *p, struct nlattr *tb[],
 		      struct netlink_ext_ack *extack)
 {
-	unsigned long old_flags, changed_mask;
+	unsigned long flags, old_flags, changed_mask;
 	bool br_vlan_tunnel_old;
 	int err;
 
@@ -896,10 +896,14 @@ static int br_setport(struct net_bridge_port *p, struct nlattr *tb[],
 	br_set_port_flag(p, tb, IFLA_BRPORT_ISOLATED, BR_ISOLATED);
 
 	changed_mask = old_flags ^ p->flags;
+	flags = p->flags;
 
-	err = br_switchdev_set_port_flag(p, p->flags, changed_mask, extack);
+	spin_unlock_bh(&p->br->lock);
+	err = br_switchdev_set_port_flag(p, flags, changed_mask, extack);
+	spin_lock_bh(&p->br->lock);
 	if (err) {
-		p->flags = old_flags;
+		p->flags &= ~changed_mask;
+		p->flags |= (old_flags & changed_mask);
 		goto out;
 	}
 
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index dbd94156960f..a79164ee65b9 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -79,9 +79,8 @@ int br_switchdev_set_port_flag(struct net_bridge_port *p,
 	attr.u.brport_flags.val = flags & mask;
 	attr.u.brport_flags.mask = mask;
 
-	/* We run from atomic context here */
-	err = call_switchdev_notifiers(SWITCHDEV_PORT_ATTR_SET, p->dev,
-				       &info.info, extack);
+	err = call_switchdev_blocking_notifiers(SWITCHDEV_PORT_ATTR_SET, p->dev,
+						&info.info, extack);
 	err = notifier_to_errno(err);
 	if (err == -EOPNOTSUPP)
 		return 0;
diff --git a/net/bridge/br_sysfs_if.c b/net/bridge/br_sysfs_if.c
index 72e92376eef1..3f21fdd1cdaa 100644
--- a/net/bridge/br_sysfs_if.c
+++ b/net/bridge/br_sysfs_if.c
@@ -68,16 +68,22 @@ static int store_flag(struct net_bridge_port *p, unsigned long v,
 	else
 		flags &= ~mask;
 
-	if (flags != p->flags) {
-		err = br_switchdev_set_port_flag(p, flags, mask, &extack);
-		if (err) {
-			netdev_err(p->dev, "%s\n", extack._msg);
-			return err;
-		}
+	if (flags == p->flags)
+		return 0;
 
-		p->flags = flags;
-		br_port_flags_change(p, mask);
+	spin_unlock_bh(&p->br->lock);
+	err = br_switchdev_set_port_flag(p, flags, mask, &extack);
+	spin_lock_bh(&p->br->lock);
+	if (err) {
+		netdev_err(p->dev, "%s\n", extack._msg);
+		return err;
 	}
+
+	p->flags &= ~mask;
+	p->flags |= (flags & mask);
+
+	br_port_flags_change(p, mask);
+
 	return 0;
 }
 
-- 
2.25.1

