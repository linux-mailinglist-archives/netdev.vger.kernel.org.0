Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABDEE34300A
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 23:39:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbhCTWgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 18:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbhCTWfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Mar 2021 18:35:36 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CA96C061574;
        Sat, 20 Mar 2021 15:35:33 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id z1so14979419edb.8;
        Sat, 20 Mar 2021 15:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xWcQ7RaEO5zW7dzwffFPpzvRes4Xyw0t8vNMvTuHyTA=;
        b=hK4qF18kD0P7ssMqzZnhjI8G1voEfGMsHAARj6Jwbyg44ogdrcaCggY30HkPYfyLja
         CmBDW0jIY0wlfvgTe5Pu6GUCJYMSEOaNxdubPgGE+N2SclPQTZO/8kpiR2aAG6oDD0O0
         wHJPbshs6Patjly1uXSa/gSmhmM8Y8qcRceBRZpgeqmyvoTqUFoZR6O7mLfBGO1TissO
         JFD+IZPG8K8jGNsgZ9HToTbU/XFNucJunOct7USMPz0e9BNOBLnkYyuQgIAXBYd2r67j
         nxOAZOEWGbAkisLHxmVccX7fc1WBMVqe/1/dbqSsyA7/5Yuv43kfSohBXUUkBQ+fg8iE
         EHGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xWcQ7RaEO5zW7dzwffFPpzvRes4Xyw0t8vNMvTuHyTA=;
        b=ecjlWpqOQVpma5fZ4erkI8zpydhFWyq0uC5ZuB8qntHhEptLHdUXslzAy56HuMnrsc
         Pj7xRVWeAlBAOJD9AU3gxmcqRcFzmbuJSoaNl20kTexNz0PGAHRVmnJSKbBjS8jiLiES
         o5MWMrTvhQZS6w8k5DDiytBHvAYrASlPi3yAsWloyOA8n8vl+9qpAfrJJUbGTRDmYeEM
         N5D98au6Ud9PIV1ymq4JU8xq45rcuhCxllKQwzK1ik8XPDyjPQ1BDSZ75UWKi2/Ul7LC
         UmP/BxnRr4/yEIkl3zGQDQ1l9lbMvnKkGnnPq+++8JvptM3rXXCX3f/iptJBugqpJQAO
         Yzbw==
X-Gm-Message-State: AOAM531cz0aaT4D1KUOES6DydjUbZHiU2+a0Y+E/lKSg7By1rbfKerj7
        W/A+2xFMXnsWz7qfs2eKOvg=
X-Google-Smtp-Source: ABdhPJwWSxX4TIvV2zSoRNHcGqjJnQP1Qq4/RIe1QanUPFARL6ufUDUz9HyOol/LRUoISrptmBQkJg==
X-Received: by 2002:aa7:c3c1:: with SMTP id l1mr17763729edr.208.1616279732359;
        Sat, 20 Mar 2021 15:35:32 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id n2sm6090850ejl.1.2021.03.20.15.35.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Mar 2021 15:35:32 -0700 (PDT)
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
Subject: [PATCH v3 net-next 10/12] net: dsa: replay VLANs installed on port when joining the bridge
Date:   Sun, 21 Mar 2021 00:34:46 +0200
Message-Id: <20210320223448.2452869-11-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210320223448.2452869-1-olteanv@gmail.com>
References: <20210320223448.2452869-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Currently this simple setup:

ip link add br0 type bridge vlan_filtering 1
ip link add bond0 type bond
ip link set bond0 master br0
ip link set swp0 master bond0

will not work because the bridge has created the PVID in br_add_if ->
nbp_vlan_init, and it has notified switchdev of the existence of VLAN 1,
but that was too early, since swp0 was not yet a lower of bond0, so it
had no reason to act upon that notification.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
Made the br_vlan_replay shim return -EOPNOTSUPP.

 include/linux/if_bridge.h | 10 ++++++
 net/bridge/br_vlan.c      | 71 +++++++++++++++++++++++++++++++++++++++
 net/dsa/port.c            |  6 ++++
 3 files changed, 87 insertions(+)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index b564c4486a45..2cc35038a8ca 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -111,6 +111,8 @@ int br_vlan_get_pvid_rcu(const struct net_device *dev, u16 *p_pvid);
 int br_vlan_get_proto(const struct net_device *dev, u16 *p_proto);
 int br_vlan_get_info(const struct net_device *dev, u16 vid,
 		     struct bridge_vlan_info *p_vinfo);
+int br_vlan_replay(struct net_device *br_dev, struct net_device *dev,
+		   struct notifier_block *nb, struct netlink_ext_ack *extack);
 #else
 static inline bool br_vlan_enabled(const struct net_device *dev)
 {
@@ -137,6 +139,14 @@ static inline int br_vlan_get_info(const struct net_device *dev, u16 vid,
 {
 	return -EINVAL;
 }
+
+static inline int br_vlan_replay(struct net_device *br_dev,
+				 struct net_device *dev,
+				 struct notifier_block *nb,
+				 struct netlink_ext_ack *extack)
+{
+	return -EOPNOTSUPP;
+}
 #endif
 
 #if IS_ENABLED(CONFIG_BRIDGE)
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 8829f621b8ec..45a4eac1b217 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1751,6 +1751,77 @@ void br_vlan_notify(const struct net_bridge *br,
 	kfree_skb(skb);
 }
 
+static int br_vlan_replay_one(struct notifier_block *nb,
+			      struct net_device *dev,
+			      struct switchdev_obj_port_vlan *vlan,
+			      struct netlink_ext_ack *extack)
+{
+	struct switchdev_notifier_port_obj_info obj_info = {
+		.info = {
+			.dev = dev,
+			.extack = extack,
+		},
+		.obj = &vlan->obj,
+	};
+	int err;
+
+	err = nb->notifier_call(nb, SWITCHDEV_PORT_OBJ_ADD, &obj_info);
+	return notifier_to_errno(err);
+}
+
+int br_vlan_replay(struct net_device *br_dev, struct net_device *dev,
+		   struct notifier_block *nb, struct netlink_ext_ack *extack)
+{
+	struct net_bridge_vlan_group *vg;
+	struct net_bridge_vlan *v;
+	struct net_bridge_port *p;
+	struct net_bridge *br;
+	int err = 0;
+	u16 pvid;
+
+	ASSERT_RTNL();
+
+	if (!netif_is_bridge_master(br_dev))
+		return -EINVAL;
+
+	if (!netif_is_bridge_master(dev) && !netif_is_bridge_port(dev))
+		return -EINVAL;
+
+	if (netif_is_bridge_master(dev)) {
+		br = netdev_priv(dev);
+		vg = br_vlan_group(br);
+		p = NULL;
+	} else {
+		p = br_port_get_rtnl(dev);
+		if (WARN_ON(!p))
+			return -EINVAL;
+		vg = nbp_vlan_group(p);
+		br = p->br;
+	}
+
+	if (!vg)
+		return 0;
+
+	pvid = br_get_pvid(vg);
+
+	list_for_each_entry(v, &vg->vlan_list, vlist) {
+		struct switchdev_obj_port_vlan vlan = {
+			.obj.orig_dev = dev,
+			.obj.id = SWITCHDEV_OBJ_ID_PORT_VLAN,
+			.flags = br_vlan_flags(v, pvid),
+			.vid = v->vid,
+		};
+
+		if (!br_vlan_should_use(v))
+			continue;
+
+		br_vlan_replay_one(nb, dev, &vlan, extack);
+		if (err)
+			return err;
+	}
+
+	return err;
+}
 /* check if v_curr can enter a range ending in range_end */
 bool br_vlan_can_enter_range(const struct net_bridge_vlan *v_curr,
 			     const struct net_bridge_vlan *range_end)
diff --git a/net/dsa/port.c b/net/dsa/port.c
index d21a511f1e16..84775e253ee8 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -209,6 +209,12 @@ static int dsa_port_switchdev_sync(struct dsa_port *dp,
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
+	err = br_vlan_replay(br, brport_dev,
+			     &dsa_slave_switchdev_blocking_notifier,
+			     extack);
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
 	return 0;
 }
 
-- 
2.25.1

