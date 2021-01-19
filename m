Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C208D2FC488
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 00:15:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729661AbhASXMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 18:12:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728514AbhASXJQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 18:09:16 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB1D7C0613ED
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 15:08:09 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id c6so16439061ede.0
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 15:08:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GBMsG2AQTyl4hgvb77tEu4dhQjWr/F7ZRTICs0MAY/E=;
        b=JoYjtKSVvRKAizq03WKVZO3XnSKuHn783B5P9Iqcg7/EaSYu4VdpNhLSdzBCdfuizT
         lQpDh0MCl0eX0Z2gSkAar3Qm7WpLEB+CVc0zitP6S5ZvY9AyELuB+SMbfwZa0MHfAH8D
         0zleZbL34L4EppWq0I49L5EocMVTBsIDNGrW8xbVVYNNOMuHCZ9wXgyaOOBPZvHfvunV
         4Z/zyFecJANj7SrIgKgH2rcnvLRD7hX9D8xr790A3kYFnRKEpp7zM+ZUwo+PyF6TRJtw
         Dl4dzo1SShbKyDJ7VCu0LQggPFW7v25m/5o25Kha7lNXUcMqSwaJuOjAC58KctnFCAfx
         Tigw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GBMsG2AQTyl4hgvb77tEu4dhQjWr/F7ZRTICs0MAY/E=;
        b=iLi/e5DvhbtWvHowNdCc3rFomZbDxM/gKQNcASvjb9bn1oXtxtWVrg4OpTTt/ckj1b
         kazq+HKKMlQDqXFKofkNYvjJdeK4uDiAMINOPYoi0dvRj1QmxAPfSgREPU+W1q5fD837
         0JAvxVhO139TmAVO95yn1J0YEu5ZA4+B9/pTsqfpf+DBetBPljh+94q2UP6i6UYOrAgP
         /5HSPKPJsuc/rdzDog6p/rsSFK74zjaFYn2NmwHopvUj/1YY4Gyv3gchhGb8rfSaZqOa
         f75HC96HQxs0vhAO1X1E7+zs7kn4Ht5oJpL9a7/zcJJAisiO4Ie554MTP5IOIgddVCVu
         lWew==
X-Gm-Message-State: AOAM5332wA6poNPoY7XJFJjCnzXVfU3LzZJ8zkjKId16sCAk/wabtz15
        KcdADjzavGesabmYK/2Pg7o=
X-Google-Smtp-Source: ABdhPJzLsf7J4OigpH8iyBYDNLkQ96tNOBvfJQk3ZGv5WwzowfxbF/q0cuNDG9uyezoL4voFBd4uxA==
X-Received: by 2002:a05:6402:1682:: with SMTP id a2mr5363226edv.30.1611097688494;
        Tue, 19 Jan 2021 15:08:08 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id lh26sm94197ejb.119.2021.01.19.15.08.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 15:08:07 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Po Liu <po.liu@nxp.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Eldar Gasanov <eldargasanov2@gmail.com>,
        Andrey L <al@b4comtech.com>, UNGLinuxDriver@microchip.com
Subject: [PATCH v4 net-next 06/16] net: dsa: allow changing the tag protocol via the "tagging" device attribute
Date:   Wed, 20 Jan 2021 01:07:39 +0200
Message-Id: <20210119230749.1178874-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210119230749.1178874-1-olteanv@gmail.com>
References: <20210119230749.1178874-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Currently DSA exposes the following sysfs:
$ cat /sys/class/net/eno2/dsa/tagging
ocelot

which is a read-only device attribute, introduced in the kernel as
commit 98cdb4807123 ("net: dsa: Expose tagging protocol to user-space"),
and used by libpcap since its commit 993db3800d7d ("Add support for DSA
link-layer types").

It would be nice if we could extend this device attribute by making it
writable:
$ echo ocelot-8021q > /sys/class/net/eno2/dsa/tagging

This is useful with DSA switches that can make use of more than one
tagging protocol. It may be useful in dsa_loop in the future too, to
perform offline testing of various taggers.

In terms of implementation, drivers can now move their tagging protocol
configuration outside of .setup/.teardown, and into .set_tag_protocol
and .del_tag_protocol. The calling order is:

.setup -> [.set_tag_protocol -> .del_tag_protocol]+ -> .teardown

There was one more contract between the DSA framework and drivers, which
is that if a CPU port needs to account for the tagger overhead in its
MTU configuration, it must do that privately. Which means it needs the
information about what tagger it uses before we call its MTU
configuration function. That promise is still held.

Writing to the tagging sysfs will first tear down the tagging protocol
for all switches in the tree attached to that DSA master, then will
attempt setup with the new tagger.

Writing will fail quickly with -EOPNOTSUPP for drivers that don't
support .set_tag_protocol, since that is checked during the deletion
phase. It is assumed that all switches within the same DSA tree use the
same driver, and therefore either all have .set_tag_protocol implemented,
or none do.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v4:
Patch is new.

 include/net/dsa.h  | 17 ++++++++
 net/dsa/dsa.c      | 20 ++++++++++
 net/dsa/dsa2.c     | 84 ++++++++++++++++++++++++++++++++++++++--
 net/dsa/dsa_priv.h | 18 +++++++++
 net/dsa/master.c   | 26 ++++++++++++-
 net/dsa/port.c     | 10 ++++-
 net/dsa/slave.c    | 35 +++++++++++------
 net/dsa/switch.c   | 96 ++++++++++++++++++++++++++++++++++++++++++++++
 8 files changed, 289 insertions(+), 17 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 2f5435d3d1db..aa0ba41e42d6 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -333,6 +333,8 @@ struct dsa_switch {
 	/* devlink used to represent this switch device */
 	struct devlink		*devlink;
 
+	struct mutex		tagger_lock;
+
 	/* Number of switch port queues */
 	unsigned int		num_tx_queues;
 
@@ -480,9 +482,24 @@ static inline bool dsa_port_is_vlan_filtering(const struct dsa_port *dp)
 typedef int dsa_fdb_dump_cb_t(const unsigned char *addr, u16 vid,
 			      bool is_static, void *data);
 struct dsa_switch_ops {
+	/*
+	 * Tagging protocol helpers.
+	 * Switches that support a single tagging protocol should implement
+	 * only @get_tag_protocol and hardcode the protocol that they support.
+	 * Switches which can operate using multiple tagging protocols should
+	 * report in @get_tag_protocol the tagger in current use. They can
+	 * optionally set up the tagging protocol in @set_tag_protocol and
+	 * perform teardown (memory deallocation, etc) in @del_tag_protocol.
+	 * The framework guarantees paired calls to the last two functions.
+	 * For all of these helpers, @port is the CPU port that gets set up.
+	 */
 	enum dsa_tag_protocol (*get_tag_protocol)(struct dsa_switch *ds,
 						  int port,
 						  enum dsa_tag_protocol mprot);
+	int	(*set_tag_protocol)(struct dsa_switch *ds, int port,
+				    enum dsa_tag_protocol proto);
+	void	(*del_tag_protocol)(struct dsa_switch *ds, int port,
+				    enum dsa_tag_protocol proto);
 
 	int	(*setup)(struct dsa_switch *ds);
 	void	(*teardown)(struct dsa_switch *ds);
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index f4ce3c5826a0..aa23736685ba 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -84,6 +84,26 @@ const char *dsa_tag_protocol_to_str(const struct dsa_device_ops *ops)
 	return ops->name;
 };
 
+const struct dsa_device_ops *dsa_find_tagger_by_name(const char *buf)
+{
+	const struct dsa_device_ops *ops = NULL;
+	struct dsa_tag_driver *dsa_tag_driver;
+
+	mutex_lock(&dsa_tag_drivers_lock);
+	list_for_each_entry(dsa_tag_driver, &dsa_tag_drivers_list, list) {
+		const struct dsa_device_ops *tmp = dsa_tag_driver->ops;
+
+		if (!sysfs_streq(buf, tmp->name))
+			continue;
+
+		ops = tmp;
+		break;
+	}
+	mutex_unlock(&dsa_tag_drivers_lock);
+
+	return ops;
+}
+
 const struct dsa_device_ops *dsa_tag_driver_get(int tag_protocol)
 {
 	struct dsa_tag_driver *dsa_tag_driver;
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index cc13549120e5..ec8b9e458d53 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -664,6 +664,11 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 		}
 	}
 
+	/* The DSA_NOTIFIER_TAG_PROTO_* notifiers use this mutex,
+	 * so initialize it first.
+	 */
+	mutex_init(&ds->tagger_lock);
+
 	err = dsa_switch_register_notifier(ds);
 	if (err)
 		goto unregister_devlink_ports;
@@ -674,6 +679,22 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 	if (err < 0)
 		goto unregister_notifier;
 
+	/* Iterate through ports list again, so that we notify the switch of
+	 * its tagging protocol after setup(), but before we start registering
+	 * the user ports, whose MTU configuration will depend upon the tagger.
+	 */
+	list_for_each_entry(dp, &ds->dst->ports, list) {
+		if (dp->ds != ds || !dsa_is_cpu_port(ds, dp->index))
+			continue;
+
+		if (ds->ops->set_tag_protocol) {
+			err = ds->ops->set_tag_protocol(ds, dp->index,
+							dp->tag_ops->proto);
+			if (err)
+				goto teardown;
+		}
+	}
+
 	devlink_params_publish(ds->devlink);
 
 	if (!ds->slave_mii_bus && ds->ops->phy_read) {
@@ -694,6 +715,9 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 
 	return 0;
 
+teardown:
+	if (ds->ops->teardown)
+		ds->ops->teardown(ds);
 unregister_notifier:
 	dsa_switch_unregister_notifier(ds);
 unregister_devlink_ports:
@@ -718,6 +742,15 @@ static void dsa_switch_teardown(struct dsa_switch *ds)
 	if (ds->slave_mii_bus && ds->ops->phy_read)
 		mdiobus_unregister(ds->slave_mii_bus);
 
+	list_for_each_entry(dp, &ds->dst->ports, list) {
+		if (dp->ds != ds || !dsa_is_cpu_port(ds, dp->index))
+			continue;
+
+		if (ds->ops->del_tag_protocol)
+			ds->ops->del_tag_protocol(ds, dp->index,
+						  dp->tag_ops->proto);
+	}
+
 	dsa_switch_unregister_notifier(ds);
 
 	if (ds->ops->teardown)
@@ -898,6 +931,53 @@ static void dsa_tree_teardown(struct dsa_switch_tree *dst)
 	dst->setup = false;
 }
 
+/* Since the dsa/tagging sysfs device attribute is per master, the assumption
+ * is that all DSA switches within a tree share the same tagger, otherwise
+ * they would have formed disjoint trees (different "dsa,member" values).
+ */
+int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
+			      struct net_device *master,
+			      const struct dsa_device_ops *tag_ops,
+			      const struct dsa_device_ops *old_tag_ops)
+{
+	struct dsa_notifier_tag_proto_info info = {
+		.tree_index = dst->index,
+	};
+	struct dsa_port *dp;
+	int err;
+
+	/* At the moment we don't allow changing the tag protocol under
+	 * traffic. May revisit in the future.
+	 */
+	if (master->flags & IFF_UP)
+		return -EBUSY;
+
+	list_for_each_entry(dp, &dst->ports, list) {
+		if (!dsa_is_user_port(dp->ds, dp->index))
+			continue;
+
+		if (dp->slave->flags & IFF_UP)
+			return -EBUSY;
+	}
+
+	info.tag_ops = old_tag_ops;
+	err = dsa_broadcast(DSA_NOTIFIER_TAG_PROTO_DEL, &info);
+	if (err)
+		return err;
+
+	info.tag_ops = tag_ops;
+	err = dsa_broadcast(DSA_NOTIFIER_TAG_PROTO_SET, &info);
+	if (err)
+		goto out_unwind_tagger;
+
+	return 0;
+
+out_unwind_tagger:
+	info.tag_ops = old_tag_ops;
+	dsa_broadcast(DSA_NOTIFIER_TAG_PROTO_SET, &info);
+	return err;
+}
+
 static struct dsa_port *dsa_port_touch(struct dsa_switch *ds, int index)
 {
 	struct dsa_switch_tree *dst = ds->dst;
@@ -983,10 +1063,8 @@ static int dsa_port_parse_cpu(struct dsa_port *dp, struct net_device *master)
 
 	dp->master = master;
 	dp->type = DSA_PORT_TYPE_CPU;
-	dp->filter = tag_ops->filter;
-	dp->rcv = tag_ops->rcv;
-	dp->tag_ops = tag_ops;
 	dp->dst = dst;
+	dsa_port_set_tag_protocol(dp, tag_ops);
 
 	return 0;
 }
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 2ce46bb87703..637ad8684e4f 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -28,6 +28,8 @@ enum {
 	DSA_NOTIFIER_VLAN_ADD,
 	DSA_NOTIFIER_VLAN_DEL,
 	DSA_NOTIFIER_MTU,
+	DSA_NOTIFIER_TAG_PROTO_SET,
+	DSA_NOTIFIER_TAG_PROTO_DEL,
 };
 
 /* DSA_NOTIFIER_AGEING_TIME */
@@ -82,6 +84,12 @@ struct dsa_notifier_mtu_info {
 	int mtu;
 };
 
+/* DSA_NOTIFIER_TAG_PROTO_* */
+struct dsa_notifier_tag_proto_info {
+	int tree_index;
+	const struct dsa_device_ops *tag_ops;
+};
+
 struct dsa_switchdev_event_work {
 	struct dsa_switch *ds;
 	int port;
@@ -115,6 +123,7 @@ struct dsa_slave_priv {
 /* dsa.c */
 const struct dsa_device_ops *dsa_tag_driver_get(int tag_protocol);
 void dsa_tag_driver_put(const struct dsa_device_ops *ops);
+const struct dsa_device_ops *dsa_find_tagger_by_name(const char *buf);
 
 bool dsa_schedule_work(struct work_struct *work);
 const char *dsa_tag_protocol_to_str(const struct dsa_device_ops *ops);
@@ -139,6 +148,9 @@ static inline struct net_device *dsa_master_find_slave(struct net_device *dev,
 }
 
 /* port.c */
+int dsa_broadcast(unsigned long e, void *v);
+void dsa_port_set_tag_protocol(struct dsa_port *cpu_dp,
+			       const struct dsa_device_ops *tag_ops);
 int dsa_port_set_state(struct dsa_port *dp, u8 state);
 int dsa_port_enable_rt(struct dsa_port *dp, struct phy_device *phy);
 int dsa_port_enable(struct dsa_port *dp, struct phy_device *phy);
@@ -201,6 +213,8 @@ int dsa_slave_suspend(struct net_device *slave_dev);
 int dsa_slave_resume(struct net_device *slave_dev);
 int dsa_slave_register_notifier(void);
 void dsa_slave_unregister_notifier(void);
+void dsa_slave_setup_tagger(struct net_device *slave);
+int dsa_slave_change_mtu(struct net_device *dev, int new_mtu);
 
 static inline struct dsa_port *dsa_slave_to_port(const struct net_device *dev)
 {
@@ -283,6 +297,10 @@ void dsa_switch_unregister_notifier(struct dsa_switch *ds);
 /* dsa2.c */
 void dsa_lag_map(struct dsa_switch_tree *dst, struct net_device *lag);
 void dsa_lag_unmap(struct dsa_switch_tree *dst, struct net_device *lag);
+int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
+			      struct net_device *master,
+			      const struct dsa_device_ops *tag_ops,
+			      const struct dsa_device_ops *old_tag_ops);
 
 extern struct list_head dsa_tree_list;
 
diff --git a/net/dsa/master.c b/net/dsa/master.c
index cb3a5cf99b25..6c0068fbecda 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -280,7 +280,31 @@ static ssize_t tagging_show(struct device *d, struct device_attribute *attr,
 	return sprintf(buf, "%s\n",
 		       dsa_tag_protocol_to_str(cpu_dp->tag_ops));
 }
-static DEVICE_ATTR_RO(tagging);
+
+static ssize_t tagging_store(struct device *d, struct device_attribute *attr,
+			     const char *buf, size_t count)
+{
+	struct net_device *dev = to_net_dev(d);
+	struct dsa_port *cpu_dp = dev->dsa_ptr;
+	const struct dsa_device_ops *ops;
+	int err;
+
+	ops = dsa_find_tagger_by_name(buf);
+	/* Bad tagger name, or module is not loaded? */
+	if (!ops)
+		return -ENOENT;
+
+	if (ops == cpu_dp->tag_ops)
+		goto out;
+
+	err = dsa_tree_change_tag_proto(cpu_dp->ds->dst, dev, ops,
+					cpu_dp->tag_ops);
+	if (err)
+		return err;
+out:
+	return count;
+}
+static DEVICE_ATTR_RW(tagging);
 
 static struct attribute *dsa_slave_attrs[] = {
 	&dev_attr_tagging.attr,
diff --git a/net/dsa/port.c b/net/dsa/port.c
index f5b0f72ee7cd..d48f3a588d9d 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -13,7 +13,7 @@
 
 #include "dsa_priv.h"
 
-static int dsa_broadcast(unsigned long e, void *v)
+int dsa_broadcast(unsigned long e, void *v)
 {
 	struct dsa_switch_tree *dst;
 	int err = 0;
@@ -536,6 +536,14 @@ int dsa_port_vlan_del(struct dsa_port *dp,
 	return dsa_port_notify(dp, DSA_NOTIFIER_VLAN_DEL, &info);
 }
 
+void dsa_port_set_tag_protocol(struct dsa_port *cpu_dp,
+			       const struct dsa_device_ops *tag_ops)
+{
+	cpu_dp->filter = tag_ops->filter;
+	cpu_dp->rcv = tag_ops->rcv;
+	cpu_dp->tag_ops = tag_ops;
+}
+
 static struct phy_device *dsa_port_get_phy_device(struct dsa_port *dp)
 {
 	struct device_node *phy_dn;
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index f2fb433f3828..b0571ab4e5a7 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1430,7 +1430,7 @@ static void dsa_bridge_mtu_normalization(struct dsa_port *dp)
 	dsa_hw_port_list_free(&hw_port_list);
 }
 
-static int dsa_slave_change_mtu(struct net_device *dev, int new_mtu)
+int dsa_slave_change_mtu(struct net_device *dev, int new_mtu)
 {
 	struct net_device *master = dsa_slave_to_master(dev);
 	struct dsa_port *dp = dsa_slave_to_port(dev);
@@ -1708,6 +1708,27 @@ static int dsa_slave_phy_setup(struct net_device *slave_dev)
 	return ret;
 }
 
+void dsa_slave_setup_tagger(struct net_device *slave)
+{
+	struct dsa_port *dp = dsa_slave_to_port(slave);
+	struct dsa_slave_priv *p = netdev_priv(slave);
+	const struct dsa_port *cpu_dp = dp->cpu_dp;
+	struct net_device *master = cpu_dp->master;
+
+	if (cpu_dp->tag_ops->tail_tag)
+		slave->needed_tailroom = cpu_dp->tag_ops->overhead;
+	else
+		slave->needed_headroom = cpu_dp->tag_ops->overhead;
+	/* Try to save one extra realloc later in the TX path (in the master)
+	 * by also inheriting the master's needed headroom and tailroom.
+	 * The 8021q driver also does this.
+	 */
+	slave->needed_headroom += master->needed_headroom;
+	slave->needed_tailroom += master->needed_tailroom;
+
+	p->xmit = cpu_dp->tag_ops->xmit;
+}
+
 static struct lock_class_key dsa_slave_netdev_xmit_lock_key;
 static void dsa_slave_set_lockdep_class_one(struct net_device *dev,
 					    struct netdev_queue *txq,
@@ -1782,16 +1803,6 @@ int dsa_slave_create(struct dsa_port *port)
 	slave_dev->netdev_ops = &dsa_slave_netdev_ops;
 	if (ds->ops->port_max_mtu)
 		slave_dev->max_mtu = ds->ops->port_max_mtu(ds, port->index);
-	if (cpu_dp->tag_ops->tail_tag)
-		slave_dev->needed_tailroom = cpu_dp->tag_ops->overhead;
-	else
-		slave_dev->needed_headroom = cpu_dp->tag_ops->overhead;
-	/* Try to save one extra realloc later in the TX path (in the master)
-	 * by also inheriting the master's needed headroom and tailroom.
-	 * The 8021q driver also does this.
-	 */
-	slave_dev->needed_headroom += master->needed_headroom;
-	slave_dev->needed_tailroom += master->needed_tailroom;
 	SET_NETDEV_DEVTYPE(slave_dev, &dsa_type);
 
 	netdev_for_each_tx_queue(slave_dev, dsa_slave_set_lockdep_class_one,
@@ -1814,8 +1825,8 @@ int dsa_slave_create(struct dsa_port *port)
 
 	p->dp = port;
 	INIT_LIST_HEAD(&p->mall_tc_list);
-	p->xmit = cpu_dp->tag_ops->xmit;
 	port->slave = slave_dev;
+	dsa_slave_setup_tagger(slave_dev);
 
 	rtnl_lock();
 	ret = dsa_slave_change_mtu(slave_dev, ETH_DATA_LEN);
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index cc0b25f3adea..6bd048cac445 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -297,6 +297,96 @@ static int dsa_switch_vlan_del(struct dsa_switch *ds,
 	return 0;
 }
 
+static bool dsa_switch_tag_proto_match(struct dsa_switch *ds, int port,
+				       struct dsa_notifier_tag_proto_info *info)
+{
+	if (ds->dst->index == info->tree_index && dsa_is_cpu_port(ds, port))
+		return true;
+
+	return false;
+}
+
+static int dsa_switch_tag_proto_del(struct dsa_switch *ds,
+				    struct dsa_notifier_tag_proto_info *info)
+{
+	int err = 0, port;
+
+	mutex_lock(&ds->tagger_lock);
+
+	for (port = 0; port < ds->num_ports; port++) {
+		if (!dsa_switch_tag_proto_match(ds, port, info))
+			continue;
+
+		/* Check early if we can replace it, so we don't delete it
+		 * for nothing and leave the switch dangling.
+		 */
+		if (!ds->ops->set_tag_protocol) {
+			err = -EOPNOTSUPP;
+			break;
+		}
+
+		/* The delete method is optional, just the setter
+		 * is mandatory
+		 */
+		if (ds->ops->del_tag_protocol)
+			ds->ops->del_tag_protocol(ds, port,
+						  info->tag_ops->proto);
+	}
+
+	mutex_unlock(&ds->tagger_lock);
+
+	return err;
+}
+
+static int dsa_switch_tag_proto_set(struct dsa_switch *ds,
+				    struct dsa_notifier_tag_proto_info *info)
+{
+	bool proto_changed = false;
+	int port, err = 0;
+
+	mutex_lock(&ds->tagger_lock);
+
+	for (port = 0; port < ds->num_ports; port++) {
+		struct dsa_port *cpu_dp = dsa_to_port(ds, port);
+
+		if (!dsa_switch_tag_proto_match(ds, port, info))
+			continue;
+
+		err = ds->ops->set_tag_protocol(ds, cpu_dp->index,
+						info->tag_ops->proto);
+		if (err)
+			goto out;
+
+		dsa_port_set_tag_protocol(cpu_dp, info->tag_ops);
+		proto_changed = true;
+	}
+
+	if (!proto_changed)
+		goto out;
+
+	/* Now that changing the tag protocol can no longer fail, let's update
+	 * the remaining bits which are "duplicated for faster access", and the
+	 * bits that depend on the tagger, such as the MTU.
+	 */
+	for (port = 0; port < ds->num_ports; port++) {
+		struct net_device *slave;
+
+		if (!dsa_is_user_port(ds, port))
+			continue;
+
+		slave = dsa_to_port(ds, port)->slave;
+		dsa_slave_setup_tagger(slave);
+
+		rtnl_lock();
+		dsa_slave_change_mtu(slave, slave->mtu);
+		rtnl_unlock();
+	}
+out:
+	mutex_unlock(&ds->tagger_lock);
+
+	return err;
+}
+
 static int dsa_switch_event(struct notifier_block *nb,
 			    unsigned long event, void *info)
 {
@@ -343,6 +433,12 @@ static int dsa_switch_event(struct notifier_block *nb,
 	case DSA_NOTIFIER_MTU:
 		err = dsa_switch_mtu(ds, info);
 		break;
+	case DSA_NOTIFIER_TAG_PROTO_SET:
+		err = dsa_switch_tag_proto_set(ds, info);
+		break;
+	case DSA_NOTIFIER_TAG_PROTO_DEL:
+		err = dsa_switch_tag_proto_del(ds, info);
+		break;
 	default:
 		err = -EOPNOTSUPP;
 		break;
-- 
2.25.1

