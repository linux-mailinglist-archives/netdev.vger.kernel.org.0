Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE23345350
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 00:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231159AbhCVXwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 19:52:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230440AbhCVXwJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 19:52:09 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E7E2C061756;
        Mon, 22 Mar 2021 16:52:09 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id r12so24120800ejr.5;
        Mon, 22 Mar 2021 16:52:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=44nKq5GK8p1avKVpGd20iBhUXg7GP0c0cb6BGtUh5kw=;
        b=qa4xklvrmnrJV2Ttk9lrGnxmR7Yh2KtWJkfU4bihrCEwT9m//ROhgo0ZEaIwYaa4WW
         E4eYHOcpdKLA56kWXUcRpNT2KGB6/ZO0/+DHGSRGAdgK5vInfsaGB+NMtiB3h3QLwdVh
         vo/nQB23DH8y2ogK8l2zvup71PUQmsXxmHZTRmQOkDSo0AwrZVJ7z8OC/kfU3YE89NeL
         VuNP6yp11GTTSvAVZvRNpq1FQETH8AJstjDfRdY3737j+UbIrDHJdJk4X1QDrmsADgCJ
         RbdVACDDP1rNgA3e2ITgVCtMuExRlmQDysWXIe8bL+9oqEh2GQs0rkgn/i81fHoJIX6J
         m3fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=44nKq5GK8p1avKVpGd20iBhUXg7GP0c0cb6BGtUh5kw=;
        b=NNGQxSwKrohD4wQ93xxRdG0MoV6DTzJY6cmuXlCZJ4ersCFDLOM+7dS/kcr7bFElWB
         GfzA9WyFzgMMmcEqRTwA0Heg9lGf3EgfP78k2zCRELeIgaKiNuhCRqcqwgsKMdrmKq5V
         kbYkLPgcxUoHjr5KJI/zRE1glqiVajbvUr6w7SaCeB/ABNh5RFbeDIQElKkgEH7snf2U
         857MqrFZPygcCFpsSLB76w6cXC0vHwM7wDEPchCj0gaQtlYa1X+mii+xhOgCi6K1UVj1
         z8R0A8P3wjIv9meXN0oiM92jwQXa5Odb8a+d0Qz2WCRPTdOvEeVUPnoOvb46q6ETbiJB
         s3bw==
X-Gm-Message-State: AOAM5300q6V1zLt7iR0YMB0V1OiVeu4fe+ESZkPde7fWKJKa/qkQXDZ9
        SIzjo6MQHVHFSaMVFaBoexE=
X-Google-Smtp-Source: ABdhPJzxQThgz4Uk24h+6fhDOnCaHDbJKvw/02CMfzuczkl/rhDRi+H0mPdAxTN/o4mDXDH1xNz8lw==
X-Received: by 2002:a17:906:819:: with SMTP id e25mr2204566ejd.292.1616457127966;
        Mon, 22 Mar 2021 16:52:07 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id q16sm12436933edv.61.2021.03.22.16.52.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 16:52:07 -0700 (PDT)
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
Subject: [PATCH v4 net-next 05/11] net: bridge: add helper to replay VLANs installed on port
Date:   Tue, 23 Mar 2021 01:51:46 +0200
Message-Id: <20210322235152.268695-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210322235152.268695-1-olteanv@gmail.com>
References: <20210322235152.268695-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Currently this simple setup with DSA:

ip link add br0 type bridge vlan_filtering 1
ip link add bond0 type bond
ip link set bond0 master br0
ip link set swp0 master bond0

will not work because the bridge has created the PVID in br_add_if ->
nbp_vlan_init, and it has notified switchdev of the existence of VLAN 1,
but that was too early, since swp0 was not yet a lower of bond0, so it
had no reason to act upon that notification.

We need a helper in the bridge to replay the switchdev VLAN objects that
were notified since the bridge port creation, because some of them may
have been missed.

As opposed to the br_mdb_replay function, the vg->vlan_list write side
protection is offered by the rtnl_mutex which is sleepable, so we don't
need to queue up the objects in atomic context, we can replay them right
away.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/linux/if_bridge.h | 10 ++++++
 net/bridge/br_vlan.c      | 73 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 83 insertions(+)

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
index 8829f621b8ec..ca8daccff217 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1751,6 +1751,79 @@ void br_vlan_notify(const struct net_bridge *br,
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
+EXPORT_SYMBOL_GPL(br_vlan_replay);
+
 /* check if v_curr can enter a range ending in range_end */
 bool br_vlan_can_enter_range(const struct net_bridge_vlan *v_curr,
 			     const struct net_bridge_vlan *range_end)
-- 
2.25.1

