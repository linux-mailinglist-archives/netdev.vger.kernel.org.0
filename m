Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8F68342FF1
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 23:36:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbhCTWfe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 18:35:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbhCTWfZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Mar 2021 18:35:25 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EF06C061574;
        Sat, 20 Mar 2021 15:35:24 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id y6so14983525eds.1;
        Sat, 20 Mar 2021 15:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=609vYmEBQlG9DIOzYR2UIfsCPKO7cez08yFjDbHyHrQ=;
        b=iDjVW0d4wIhntmW1WqjPYPeoJKWfA0uny+pd9ZFRkdlP2pJs5V26l52Top7p21yJDl
         DNdA+amzqMmLMk4dUrjt4ErVXXvr1UzGeL0TEQKLbyr4Ula0A7S8hL6SP8SMwK8Q8Mw6
         t7G24o72zcBqrhZDjgYrtlVtkHWJFPl0BqA1uHyQ8YzvdipVU6GecuhwusLVl9MpT2eY
         mfx/NO5PjoL2BmlGtEU+nhkkkwSkPSr9+mmF4t9ZtD6u+AynfdRWBQr1afgSxbxAVVSQ
         RqEgR/5R+nTuz9zZSWPO+ZQXWtGadtXJAWX35mZ4Wy58K5zQJAeMMHy4UVuMecD2qyhc
         iFWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=609vYmEBQlG9DIOzYR2UIfsCPKO7cez08yFjDbHyHrQ=;
        b=hx0BFye2+nGxu3clLqxMHu9n7Ul+U/zm61wEwZJF28H7XSWa1T8KzZWOPUYIDhMxYx
         AK5BaY18RERtBqxEqCkwuMUnR/Vpj9Pqm4lemizARMXMZH4sy2G52iULeu1Q5z5XQrdF
         sFFbNkhnUQe+vHCJFWQOPzIYZdPpPpgqZd7rfXlmK3J/VJGq9ur25qgw7mAGQC9Wo5o1
         Z4ZXC9S51SjUXghTAAw/xFtxcB/tmXobE+egdqLafMVzrMz75hJHQyPTuQMi64XA1dJc
         CzxvnFfANPdL2XFIEhVeZd2nPe3idLjOghCdVjDiqjCCeZCCSuVgkzQPpiSpfiPpgRHV
         guFw==
X-Gm-Message-State: AOAM5338NbDcY3RIewzKVOJk/4LhF6ohMyLQeZOD+tgYdwg2b0mDd5Qe
        n/a37IWmLsuLhR3/PiIPJgs=
X-Google-Smtp-Source: ABdhPJzvqEvaEivhnNPt7T8XkPrV2l7CH72BZMyQZ2hxG5PM0Gkapc7vz/LC8V0Lm9SB7aeqK087Mg==
X-Received: by 2002:a50:d753:: with SMTP id i19mr17580294edj.43.1616279723369;
        Sat, 20 Mar 2021 15:35:23 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id n2sm6090850ejl.1.2021.03.20.15.35.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Mar 2021 15:35:23 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Ivan Vecera <ivecera@redhat.com>,
        linux-omap@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v3 net-next 03/12] net: dsa: inherit the actual bridge port flags at join time
Date:   Sun, 21 Mar 2021 00:34:39 +0200
Message-Id: <20210320223448.2452869-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210320223448.2452869-1-olteanv@gmail.com>
References: <20210320223448.2452869-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

DSA currently assumes that the bridge port starts off with this
constellation of bridge port flags:

- learning on
- unicast flooding on
- multicast flooding on
- broadcast flooding on

just by virtue of code copy-pasta from the bridge layer (new_nbp).
This was a simple enough strategy thus far, because the 'bridge join'
moment always coincided with the 'bridge port creation' moment.

But with sandwiched interfaces, such as:

 br0
  |
bond0
  |
 swp0

it may happen that the user has had time to change the bridge port flags
of bond0 before enslaving swp0 to it. In that case, swp0 will falsely
assume that the bridge port flags are those determined by new_nbp, when
in fact this can happen:

ip link add br0 type bridge
ip link add bond0 type bond
ip link set bond0 master br0
ip link set bond0 type bridge_slave learning off
ip link set swp0 master br0

Now swp0 has learning enabled, bond0 has learning disabled. Not nice.

Fix this by "dumpster diving" through the actual bridge port flags with
br_port_flag_is_set, at bridge join time.

We use this opportunity to split dsa_port_change_brport_flags into two
distinct functions called dsa_port_inherit_brport_flags and
dsa_port_clear_brport_flags, now that the implementation for the two
cases is no longer similar.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
Rewrote dsa_port_clear_brport_flags to at least catch errors, and to use
the same "for" loop structure as dsa_port_inherit_brport_flags.

 net/dsa/port.c | 125 ++++++++++++++++++++++++++++++++-----------------
 1 file changed, 83 insertions(+), 42 deletions(-)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index fcbe5b1545b8..8dbc6e0db30c 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -122,26 +122,82 @@ void dsa_port_disable(struct dsa_port *dp)
 	rtnl_unlock();
 }
 
-static void dsa_port_change_brport_flags(struct dsa_port *dp,
-					 bool bridge_offload)
+static int dsa_port_inherit_brport_flags(struct dsa_port *dp,
+					 struct netlink_ext_ack *extack)
 {
-	struct switchdev_brport_flags flags;
-	int flag;
+	const unsigned long mask = BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD |
+				   BR_BCAST_FLOOD;
+	struct net_device *brport_dev = dsa_port_to_bridge_port(dp);
+	int flag, err;
 
-	flags.mask = BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD | BR_BCAST_FLOOD;
-	if (bridge_offload)
-		flags.val = flags.mask;
-	else
-		flags.val = flags.mask & ~BR_LEARNING;
+	for_each_set_bit(flag, &mask, 32) {
+		struct switchdev_brport_flags flags = {0};
 
-	for_each_set_bit(flag, &flags.mask, 32) {
-		struct switchdev_brport_flags tmp;
+		flags.mask = BIT(flag);
 
-		tmp.val = flags.val & BIT(flag);
-		tmp.mask = BIT(flag);
+		if (br_port_flag_is_set(brport_dev, BIT(flag)))
+			flags.val = BIT(flag);
 
-		dsa_port_bridge_flags(dp, tmp, NULL);
+		err = dsa_port_bridge_flags(dp, flags, extack);
+		if (err && err != -EOPNOTSUPP)
+			return err;
 	}
+
+	return 0;
+}
+
+static void dsa_port_clear_brport_flags(struct dsa_port *dp,
+					struct netlink_ext_ack *extack)
+{
+	const unsigned long val = BR_FLOOD | BR_MCAST_FLOOD | BR_BCAST_FLOOD;
+	const unsigned long mask = BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD |
+				   BR_BCAST_FLOOD;
+	int flag, err;
+
+	for_each_set_bit(flag, &mask, 32) {
+		struct switchdev_brport_flags flags = {0};
+
+		flags.mask = BIT(flag);
+		flags.val = val & BIT(flag);
+
+		err = dsa_port_bridge_flags(dp, flags, extack);
+		if (err && err != -EOPNOTSUPP)
+			dev_err(dp->ds->dev,
+				"failed to clear bridge port flag %d: %d (%pe)\n",
+				flags.val, err, ERR_PTR(err));
+	}
+}
+
+static int dsa_port_switchdev_sync(struct dsa_port *dp,
+				   struct netlink_ext_ack *extack)
+{
+	int err;
+
+	err = dsa_port_inherit_brport_flags(dp, extack);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+/* Configure the port for standalone mode (no address learning, flood
+ * everything, BR_STATE_FORWARDING, etc).
+ * The bridge only emits SWITCHDEV_ATTR_ID_PORT_* events when the user
+ * requests it through netlink or sysfs, but not automatically at port
+ * join or leave, so we need to handle resetting the brport flags ourselves.
+ * But we even prefer it that way, because otherwise, some setups might never
+ * get the notification they need, for example, when a port leaves a LAG that
+ * offloads the bridge, it becomes standalone, but as far as the bridge is
+ * concerned, no port ever left.
+ */
+static void dsa_port_switchdev_unsync(struct dsa_port *dp)
+{
+	dsa_port_clear_brport_flags(dp, NULL);
+
+	/* Port left the bridge, put in BR_STATE_DISABLED by the bridge layer,
+	 * so allow it to be in BR_STATE_FORWARDING to be kept functional
+	 */
+	dsa_port_set_state_now(dp, BR_STATE_FORWARDING);
 }
 
 int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
@@ -155,24 +211,25 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
 	};
 	int err;
 
-	/* Notify the port driver to set its configurable flags in a way that
-	 * matches the initial settings of a bridge port.
-	 */
-	dsa_port_change_brport_flags(dp, true);
-
 	/* Here the interface is already bridged. Reflect the current
 	 * configuration so that drivers can program their chips accordingly.
 	 */
 	dp->bridge_dev = br;
 
 	err = dsa_broadcast(DSA_NOTIFIER_BRIDGE_JOIN, &info);
+	if (err)
+		goto out_rollback;
 
-	/* The bridging is rolled back on error */
-	if (err) {
-		dsa_port_change_brport_flags(dp, false);
-		dp->bridge_dev = NULL;
-	}
+	err = dsa_port_switchdev_sync(dp, extack);
+	if (err)
+		goto out_rollback_unbridge;
 
+	return 0;
+
+out_rollback_unbridge:
+	dsa_broadcast(DSA_NOTIFIER_BRIDGE_LEAVE, &info);
+out_rollback:
+	dp->bridge_dev = NULL;
 	return err;
 }
 
@@ -186,6 +243,8 @@ void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br)
 	};
 	int err;
 
+	dsa_port_switchdev_unsync(dp);
+
 	/* Here the port is already unbridged. Reflect the current configuration
 	 * so that drivers can program their chips accordingly.
 	 */
@@ -194,24 +253,6 @@ void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br)
 	err = dsa_broadcast(DSA_NOTIFIER_BRIDGE_LEAVE, &info);
 	if (err)
 		pr_err("DSA: failed to notify DSA_NOTIFIER_BRIDGE_LEAVE\n");
-
-	/* Configure the port for standalone mode (no address learning,
-	 * flood everything).
-	 * The bridge only emits SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS events
-	 * when the user requests it through netlink or sysfs, but not
-	 * automatically at port join or leave, so we need to handle resetting
-	 * the brport flags ourselves. But we even prefer it that way, because
-	 * otherwise, some setups might never get the notification they need,
-	 * for example, when a port leaves a LAG that offloads the bridge,
-	 * it becomes standalone, but as far as the bridge is concerned, no
-	 * port ever left.
-	 */
-	dsa_port_change_brport_flags(dp, false);
-
-	/* Port left the bridge, put in BR_STATE_DISABLED by the bridge layer,
-	 * so allow it to be in BR_STATE_FORWARDING to be kept functional
-	 */
-	dsa_port_set_state_now(dp, BR_STATE_FORWARDING);
 }
 
 int dsa_port_lag_change(struct dsa_port *dp,
-- 
2.25.1

