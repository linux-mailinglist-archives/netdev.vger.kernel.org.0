Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 944543410C8
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 00:19:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233299AbhCRXS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 19:18:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230381AbhCRXSt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 19:18:49 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 183A2C06174A;
        Thu, 18 Mar 2021 16:18:49 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id b7so6645938ejv.1;
        Thu, 18 Mar 2021 16:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xspX7ABWeM360yFqUudhIP/3s39DM5Fl+zdKTT8mo5I=;
        b=MZlD2H82t7kJs5bupZQj74IJE5yONocozA77v+F2sKTTdM4TAtTmTDyb9Wclf5+QBh
         2E5YgmCiu5bAqBvjMUsuWGbDY9vXNWROk3JtRPLDlMQjLWylHjr0k3Y+HfXLa/dGnsp2
         q0qZ85bWP28V9CtQuWMDvk/zaIgOjfzRcrYWCTb6MBjiW4oxRNK46G2keL9uG4aSIteP
         szBNZ9irIOWcQKVrpSFWOvcLOeTD8E7eHsnR3YAhAlGvl/47Bm06VgH0hI3LIX7HuvRA
         EvEBCk3V28C4uqHYMQV02MK49CuaTIw6wgGORTLVjzsnnWdTam2GZzHP+FuydeSFHz/h
         g8Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xspX7ABWeM360yFqUudhIP/3s39DM5Fl+zdKTT8mo5I=;
        b=Oynt8SHuAjf9VqsmuAxj16QiyXQGJdlQ2kGbG/SNhvEBHrUOv4aZR0gl6kGJ4QTgcl
         Cwj/OKGcGds4f9Kxd0cGVOLdmXjmuxjwYl1W0hmNpu/gmT7IVo5j5zhkZF4Id2lilhUf
         vw5qA9z3KbEc71jWWv8YIQ0H64xeNLzh9xYcdzeZwr/07cNdti8DuDYYcVyz7pIjO4Mv
         wh3nb3mkrI76Jvwc+DfovrtIcev6MJ8PDISUuBOzgywtTdFufMfybEpH1xWorFqGsDsH
         acG7frBTSz4+NhIYBDXUYjwvd861XMRHlPgOt7PcuYsg+r6VKASF4xxyb9UbTTOINq4o
         5wjw==
X-Gm-Message-State: AOAM5334N+yghuIrrVDY6/z/Mzl9f/aY1VouEFq4iGvqoFJq56nj1rbP
        q+u3xN5jsjdM8RldS35r5PI=
X-Google-Smtp-Source: ABdhPJz98z7ZhsOicYqnx0/OGR/IbqxeNHUIjL56BIVfEzT/SbEI9jCEMojhs93263TH/eUr6lUMJQ==
X-Received: by 2002:a17:906:33d9:: with SMTP id w25mr1121798eja.413.1616109527862;
        Thu, 18 Mar 2021 16:18:47 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id bx24sm2801131ejc.88.2021.03.18.16.18.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 16:18:47 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC PATCH v2 net-next 03/16] net: dsa: inherit the actual bridge port flags at join time
Date:   Fri, 19 Mar 2021 01:18:16 +0200
Message-Id: <20210318231829.3892920-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210318231829.3892920-1-olteanv@gmail.com>
References: <20210318231829.3892920-1-olteanv@gmail.com>
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
 net/dsa/port.c | 123 ++++++++++++++++++++++++++++++++-----------------
 1 file changed, 82 insertions(+), 41 deletions(-)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index fcbe5b1545b8..346c50467810 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -122,26 +122,82 @@ void dsa_port_disable(struct dsa_port *dp)
 	rtnl_unlock();
 }
 
-static void dsa_port_change_brport_flags(struct dsa_port *dp,
-					 bool bridge_offload)
+static void dsa_port_clear_brport_flags(struct dsa_port *dp,
+					struct netlink_ext_ack *extack)
 {
 	struct switchdev_brport_flags flags;
-	int flag;
 
-	flags.mask = BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD | BR_BCAST_FLOOD;
-	if (bridge_offload)
-		flags.val = flags.mask;
-	else
-		flags.val = flags.mask & ~BR_LEARNING;
+	flags.mask = BR_LEARNING;
+	flags.val = 0;
+	dsa_port_bridge_flags(dp, flags, extack);
+
+	flags.mask = BR_FLOOD;
+	flags.val = BR_FLOOD;
+	dsa_port_bridge_flags(dp, flags, extack);
+
+	flags.mask = BR_MCAST_FLOOD;
+	flags.val = BR_MCAST_FLOOD;
+	dsa_port_bridge_flags(dp, flags, extack);
+
+	flags.mask = BR_BCAST_FLOOD;
+	flags.val = BR_BCAST_FLOOD;
+	dsa_port_bridge_flags(dp, flags, extack);
+}
+
+static int dsa_port_inherit_brport_flags(struct dsa_port *dp,
+					 struct netlink_ext_ack *extack)
+{
+	const unsigned long mask = BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD |
+				   BR_BCAST_FLOOD;
+	struct net_device *brport_dev = dsa_port_to_bridge_port(dp);
+	int flag, err;
+
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

