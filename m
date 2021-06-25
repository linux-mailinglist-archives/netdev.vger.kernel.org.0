Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 362613B4903
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 20:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbhFYS4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 14:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbhFYS4H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 14:56:07 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C727C061766
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 11:53:45 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id ot9so15601803ejb.8
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 11:53:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7fJhLBZkM9Qc9MkFpOt5UAWqWPZpX2U+ynK1wofjUvA=;
        b=l4nM9+yOxc5+ETXch06TiSgBmBglgtdIFf1qEmDK4MWAuZvB4DtP5NnQndZPpK0IBK
         oShFjDsFPsJfwMAv/o4PH0C+Z9vOhuzq/Kf4Fh6mAauw9I1deKktZ6GN5HJyIRgpX4xL
         x0P9kyHOrY7jJzzN4j1VEuaGbA22uBBOAsLfq3Nh5qCKMYLgf7heISMzPmOjVoTwqQC5
         B5Og4usZ8lT9uS/fziKuqle0/sBcVVCbATBwxJPUy993lSRRbFG6m4S7Pw5uHCbJE0mi
         oFYuHBpXV3bgz8wKceo4uFF+vvxhM7zdgT4QcCujqIo+kMsYmtMC4k6WCSnf7tbXbsuD
         xLiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7fJhLBZkM9Qc9MkFpOt5UAWqWPZpX2U+ynK1wofjUvA=;
        b=rF42cIb0xMR+IH52DUDzbzRsD1S/TbB48X1U3FVEIpUgr/ADl/SBa1V7TXB4lFLY4e
         /fbRDm73H/gEJmD/cMiU1MxF+5wYiLGhwlHaJoHqHEwqRDbJuXe6HhWOG04v+nMlPpWE
         A/W4AjvMMHksqR7E+VtyOIwMMMsFAH3vX0qNJx8/pLkZelbFYuTMCK2NgG0C396ZXSGn
         3HCjNLgyPLdUZT67xdhXFap5rNm6EQQZc19akVYG00HoL0Ho8jqx9DKI85uqBk97n/2y
         FLgpHTavN34AH0bGZlDQYgh+xVNIxBVh/ygJrONzGJSPvayG1vp95SwD5cwKUj7Rtfxc
         RQHg==
X-Gm-Message-State: AOAM530dqSKjMtLhStZuJ/dZremAjFl3BgZsCMT90VeSeWzmPPtEarwF
        AVYhsZBlV0pyaxjUBDrnI4k=
X-Google-Smtp-Source: ABdhPJxcf2akry00/9dqObBLH+s356DokhRS93qlKilvIsMZrzyzCo4VtISZoqJtpAG7B68TTZZEpg==
X-Received: by 2002:a17:907:2da0:: with SMTP id gt32mr12746482ejc.58.1624647223620;
        Fri, 25 Jun 2021 11:53:43 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id w2sm3094954ejn.118.2021.06.25.11.53.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jun 2021 11:53:43 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 7/7] net: dsa: replay a deletion of switchdev objects for ports leaving a bridged LAG
Date:   Fri, 25 Jun 2021 21:53:21 +0300
Message-Id: <20210625185321.626325-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210625185321.626325-1-olteanv@gmail.com>
References: <20210625185321.626325-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

When a DSA switch port leaves a bonding interface that is under a
bridge, there might be dangling switchdev objects on that port left
behind, because the bridge is not aware that its lower interface (the
bond) changed state in any way.

Call the bridge replay helpers with adding=false before changing
dp->bridge_dev to NULL, because we need to simulate to
dsa_slave_port_obj_del() that these notifications were emitted by the
bridge.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/port.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index 4e58d07ececd..787c0454f9bd 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -212,7 +212,22 @@ static int dsa_port_switchdev_sync(struct dsa_port *dp,
 	return 0;
 }
 
-static void dsa_port_switchdev_unsync(struct dsa_port *dp)
+static void dsa_port_switchdev_unsync_objs(struct dsa_port *dp)
+{
+	struct net_device *brport_dev = dsa_port_to_bridge_port(dp);
+	struct net_device *br = dp->bridge_dev;
+
+	/* Delete the switchdev objects left on this port */
+	br_mdb_replay(br, brport_dev, dp, false,
+		      &dsa_slave_switchdev_blocking_notifier, NULL);
+
+	br_fdb_replay(br, brport_dev, dp, false, &dsa_slave_switchdev_notifier);
+
+	br_vlan_replay(br, brport_dev, dp, false,
+		       &dsa_slave_switchdev_blocking_notifier, NULL);
+}
+
+static void dsa_port_switchdev_unsync_attrs(struct dsa_port *dp)
 {
 	/* Configure the port for standalone mode (no address learning,
 	 * flood everything).
@@ -288,6 +303,8 @@ void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br)
 	};
 	int err;
 
+	dsa_port_switchdev_unsync_objs(dp);
+
 	/* Here the port is already unbridged. Reflect the current configuration
 	 * so that drivers can program their chips accordingly.
 	 */
@@ -297,7 +314,7 @@ void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br)
 	if (err)
 		pr_err("DSA: failed to notify DSA_NOTIFIER_BRIDGE_LEAVE\n");
 
-	dsa_port_switchdev_unsync(dp);
+	dsa_port_switchdev_unsync_attrs(dp);
 }
 
 int dsa_port_lag_change(struct dsa_port *dp,
-- 
2.25.1

