Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B53A3410E3
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 00:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233448AbhCRXTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 19:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230480AbhCRXTA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 19:19:00 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99013C06174A;
        Thu, 18 Mar 2021 16:18:59 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id w18so8738925edc.0;
        Thu, 18 Mar 2021 16:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7JhQ2kQzidiQfTakouPVoSEYKgYJywL0dJdeDO35/Oo=;
        b=MxmrwRYXQ525YkLNK7v0HqyLjD4n7IIA1J7ocvk6uP80tzkk19KvL71GMMermYsxlN
         xrRDlEkMwAUBjCB/6HIJVARUe/A/582Kf+6BEPeB/0ww94+iKh+K6FGYtPeOI0FB7JoJ
         4T6ijcNbuBCL1zfSeybgGDmZPxW36z7clGnJ0M7JHysWHGdAiNp2lGpwtGqPZWR/ijLE
         XjNxUD9ZipjDVEYXsdFf4V6RDGr7lq1hpLkCCFN1jui3aKUiT2sxGqMorhOSdVOHxHQ2
         sgB25HvY5HWI0YcWABFOAJBJ1Wn0F6x0vTmgthCI25WOhAdWIk1+l1TH0W1lBNT9hjPx
         G5rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7JhQ2kQzidiQfTakouPVoSEYKgYJywL0dJdeDO35/Oo=;
        b=KV9Al3FbtCoKBVAiTIfWV2B66xGj3Y+L6CLamIZl2F4CTqGjvF08elovtIsJkF/uQd
         FCYbWMzjVJS5fHuX0aM8kqmoxUVwMcuuRIhCzYGEE7E5riHXukZtO7Ld5IWPvVaUc1eW
         QBftIzv7NxlMcGtmzCrDccM05lQPAkcM96O5OXnkE4CMizQjQ+s23DYN0xbzAoYwLD8H
         ip6ZVsUyajLXTy+y+KOV8QdjT/GlmI6IVhgYzgbE21qhESH+91bQxUtOW4QsPAc1ljid
         zKI2IjIK4akBjAqo4W4L+Zug9z1ZjH4oXWnRyD5tQgfprFbYMXgYMhYdu/FSaGrDLbMb
         qFog==
X-Gm-Message-State: AOAM530DI32v2TsHAP9CqX6qY699qm+WrEXkhd8nrtp8DZSzg6FkxLvF
        LRYJOkX7jNAP5q6iJG1lyrw=
X-Google-Smtp-Source: ABdhPJyQXAh0mO9Sv4qRIZn0DODzbA5wbdUbHyu4xa0cB0sYM288Vc4H7afM+RdnEJQCytGqm5vcJQ==
X-Received: by 2002:a50:cf48:: with SMTP id d8mr6755511edk.54.1616109538360;
        Thu, 18 Mar 2021 16:18:58 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id bx24sm2801131ejc.88.2021.03.18.16.18.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 16:18:58 -0700 (PDT)
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
Subject: [RFC PATCH v2 net-next 10/16] net: dsa: replay VLANs installed on port when joining the bridge
Date:   Fri, 19 Mar 2021 01:18:23 +0200
Message-Id: <20210318231829.3892920-11-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210318231829.3892920-1-olteanv@gmail.com>
References: <20210318231829.3892920-1-olteanv@gmail.com>
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
 include/linux/if_bridge.h | 10 ++++++
 net/bridge/br_vlan.c      | 71 +++++++++++++++++++++++++++++++++++++++
 net/dsa/port.c            |  6 ++++
 3 files changed, 87 insertions(+)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index 89596134e88f..ea176c508c0d 100644
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
+	return -EINVAL;
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
index 9850051071f2..6c3c357ac409 100644
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

