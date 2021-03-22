Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0786345354
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 00:52:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbhCVXw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 19:52:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbhCVXwN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 19:52:13 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23A1FC061574;
        Mon, 22 Mar 2021 16:52:13 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id w3so24120203ejc.4;
        Mon, 22 Mar 2021 16:52:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LYURHPgoUHC+LuUEXW8Qp3cwYVxWxmcSv0S5vH1KiMo=;
        b=Czc3j3n86SuF6zos4QC7IEGjnEGaD1SdHQ4QFZwNWFW2i2XjavCmgz7otxPfwkNtPe
         mKm0fQQ36iPvjryHqd0ruod7onfmzRJ0Z1OttMDh8t5OGn2A8agvL+NMGLj9AwR2Wun4
         u/jimS+PPIUNS44Ic4YGmFmiuYyPDlBvrjH8rWLke3IkkLQJHq5/eH1y/XYUfz9QDH4/
         yb4C67/6ITkTjbrZ7q6v16GWXn1DM85Y6bsnBzWl6WTYVIPu4yXxXQJ4V7rl5idkaFkw
         1dP4aaPMKr9G24BKhS7CLnwGPv74FhGXUz7JsZgzL2maGJBwQXw2K2vzDDwmcXXf7HNs
         kL/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LYURHPgoUHC+LuUEXW8Qp3cwYVxWxmcSv0S5vH1KiMo=;
        b=RrefFUmhaPQZ2ixo/4QviQeoUgGa4P3JWsmIAdYwpXv4eqDIJ36xKyqGQYbtsolA84
         CXGzaAX3wdG4EBdVtvD66dLWqkgbqtGYtl07uYYiFqyqbmZv1mqlt1HscUCnsO8D6IsE
         rqelEhUopJFg5FS+pv8wDVTjU8rOK/ytft1iB3n5cCvhAmxUxsbAbb7w47ObPdLHvrRl
         BTaVeggR1z1avwSylZDoI/DG+mKJfnDnsYxUUSYIHLFsycnWI9StErP4gi4MxCvnfhYi
         7UxZnt/jx3UYK8kz1EC6wXmdNlAY8ciSR49IRB47tv+nFea+kHS4k+9akh54O62BoxRq
         G1dw==
X-Gm-Message-State: AOAM533SOiyMBqsUiGAjCMKK0mMnWZOv5IrMjUpj058eEBJDBaoZ5nyY
        ZNmkwZ/NuXA+uK/A0owdNdVdSuR3NPk=
X-Google-Smtp-Source: ABdhPJyRKLvWj8cb75kIQ16q/PoFigip0G4FDV7Bhk2TiBlIgJx7upiJwqRK1L1pRruT2H+w0G/hWA==
X-Received: by 2002:a17:906:f56:: with SMTP id h22mr2187552ejj.494.1616457131882;
        Mon, 22 Mar 2021 16:52:11 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id q16sm12436933edv.61.2021.03.22.16.52.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 16:52:11 -0700 (PDT)
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
Subject: [PATCH v4 net-next 08/11] net: dsa: inherit the actual bridge port flags at join time
Date:   Tue, 23 Mar 2021 01:51:49 +0200
Message-Id: <20210322235152.268695-9-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210322235152.268695-1-olteanv@gmail.com>
References: <20210322235152.268695-1-olteanv@gmail.com>
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
cases is no longer similar. This patch also creates two functions called
dsa_port_switchdev_sync and dsa_port_switchdev_unsync which collect what
we have so far, even if that's asymmetrical. More is going to be added
in the next patch.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/port.c | 123 ++++++++++++++++++++++++++++++++-----------------
 1 file changed, 82 insertions(+), 41 deletions(-)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index fcbe5b1545b8..c712bf3da0a0 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -122,28 +122,84 @@ void dsa_port_disable(struct dsa_port *dp)
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
+
+		flags.mask = BIT(flag);
 
-	for_each_set_bit(flag, &flags.mask, 32) {
-		struct switchdev_brport_flags tmp;
+		if (br_port_flag_is_set(brport_dev, BIT(flag)))
+			flags.val = BIT(flag);
+
+		err = dsa_port_bridge_flags(dp, flags, extack);
+		if (err && err != -EOPNOTSUPP)
+			return err;
+	}
 
-		tmp.val = flags.val & BIT(flag);
-		tmp.mask = BIT(flag);
+	return 0;
+}
 
-		dsa_port_bridge_flags(dp, tmp, NULL);
+static void dsa_port_clear_brport_flags(struct dsa_port *dp)
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
+		err = dsa_port_bridge_flags(dp, flags, NULL);
+		if (err && err != -EOPNOTSUPP)
+			dev_err(dp->ds->dev,
+				"failed to clear bridge port flag %lu: %pe\n",
+				flags.val, ERR_PTR(err));
 	}
 }
 
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
+static void dsa_port_switchdev_unsync(struct dsa_port *dp)
+{
+	/* Configure the port for standalone mode (no address learning,
+	 * flood everything).
+	 * The bridge only emits SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS events
+	 * when the user requests it through netlink or sysfs, but not
+	 * automatically at port join or leave, so we need to handle resetting
+	 * the brport flags ourselves. But we even prefer it that way, because
+	 * otherwise, some setups might never get the notification they need,
+	 * for example, when a port leaves a LAG that offloads the bridge,
+	 * it becomes standalone, but as far as the bridge is concerned, no
+	 * port ever left.
+	 */
+	dsa_port_clear_brport_flags(dp);
+
+	/* Port left the bridge, put in BR_STATE_DISABLED by the bridge layer,
+	 * so allow it to be in BR_STATE_FORWARDING to be kept functional
+	 */
+	dsa_port_set_state_now(dp, BR_STATE_FORWARDING);
+}
+
 int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
 			 struct netlink_ext_ack *extack)
 {
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
 
@@ -195,23 +252,7 @@ void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br)
 	if (err)
 		pr_err("DSA: failed to notify DSA_NOTIFIER_BRIDGE_LEAVE\n");
 
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
+	dsa_port_switchdev_unsync(dp);
 }
 
 int dsa_port_lag_change(struct dsa_port *dp,
-- 
2.25.1

