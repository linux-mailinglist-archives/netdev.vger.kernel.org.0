Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC81F2466AD
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 14:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728471AbgHQMwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 08:52:25 -0400
Received: from wnew3-smtp.messagingengine.com ([64.147.123.17]:40545 "EHLO
        wnew3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726265AbgHQMwT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 08:52:19 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.west.internal (Postfix) with ESMTP id 064B591A;
        Mon, 17 Aug 2020 08:52:16 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 17 Aug 2020 08:52:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=vRj7vivqnf1v+jiCT5U1Hl4dU1EvMWMoZLKfL7WV5xE=; b=EK5Auc/f
        kXYN1NxTc/I0Dxz0WHsVxRSO5z7kwV6zYC5OeNMjpYuay2H/bWI1FUcep3/6g5SZ
        6EMGDHLe2Dl6WISGAJoO7nNNdtQCBgHI/BmzHP1LBjrp2Nrbxs6IHPRIkwQKL2Ez
        LHZSKoDxLZpVBn9jEw5ZeK9ERG/TNCGMV0snxKcUMu5TX65/ntwJ3b/SQTjt2GJ7
        AParUsC/VKye2WnjyALHVcq+sDPZMCjzZCOBOce3iMqBiy78ZOg2PBgen+Zv7X/2
        8dxOs/0tvoqDJWSaZ1VYx7E0pfdAmV9J6DqxqVYXM3BagvpHUIg3+4rm7DhCuNMv
        QsShlSfId+skIA==
X-ME-Sender: <xms:gH06X1kMcaNjREw7Z41WNml1r5ZTrq4ida9kqNiyw7tictQMZzLkyQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtfedgheeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudekvddrieefrdegvden
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:gH06Xw1UPAD72bhVjLBpUX9UOjqJ-w5kloYKBMn6im38rxjmQQ3trg>
    <xmx:gH06X7rPjwa27vq7WBFtt0BuIQuNAkyvoX0zFUMRhIZLPgFlyOdU1w>
    <xmx:gH06X1n6NxAPrXnsR03JFFqPTqOEDZrITHbOp3EgVgdhegEps9O-vg>
    <xmx:gH06X61yX_ylgeAZtiAnf7K0UHObMKNIabsCzNYf9EU5MS4KJXo8ONFKECM>
Received: from localhost.localdomain (bzq-79-182-63-42.red.bezeqint.net [79.182.63.42])
        by mail.messagingengine.com (Postfix) with ESMTPA id 368623060067;
        Mon, 17 Aug 2020 08:52:02 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        amcohen@nvidia.com, danieller@nvidia.com, mlxsw@nvidia.com,
        roopa@nvidia.com, dsahern@gmail.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, saeedm@nvidia.com,
        tariqt@nvidia.com, ayal@nvidia.com, eranbe@nvidia.com,
        mkubecek@suse.cz, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 1/6] devlink: Add device metric infrastructure
Date:   Mon, 17 Aug 2020 15:50:54 +0300
Message-Id: <20200817125059.193242-2-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200817125059.193242-1-idosch@idosch.org>
References: <20200817125059.193242-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Add an infrastructure that allows device drivers to dynamically register
and unregister their supported metrics with devlink. The metrics and
their values are exposed to user space which can decide to group certain
metrics together. This allows user space to request a filtered dump of
only the metrics member in the provided group.

Currently, the only supported metric type is a counter, but histograms
will be added in the future for devices that implement histogram agents
in hardware.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../networking/devlink/devlink-metric.rst     |  26 ++
 Documentation/networking/devlink/index.rst    |   1 +
 include/net/devlink.h                         |  18 +
 include/uapi/linux/devlink.h                  |  19 +
 net/core/devlink.c                            | 346 ++++++++++++++++++
 5 files changed, 410 insertions(+)
 create mode 100644 Documentation/networking/devlink/devlink-metric.rst

diff --git a/Documentation/networking/devlink/devlink-metric.rst b/Documentation/networking/devlink/devlink-metric.rst
new file mode 100644
index 000000000000..cf5c5b4e4077
--- /dev/null
+++ b/Documentation/networking/devlink/devlink-metric.rst
@@ -0,0 +1,26 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+==============
+Devlink Metric
+==============
+
+The ``devlink-metric`` mechanism allows device drivers to expose device metrics
+to user space in a standard and extensible fashion. It provides an alternative
+to the driver-specific debugfs interface.
+
+Metric Types
+============
+
+The ``devlink-metric`` mechanism supports the following metric types:
+
+  * ``counter``: Monotonically increasing. Cannot be reset.
+
+Metrics Documentation
+=====================
+
+All the metrics exposed by a device driver must be clearly documented in the
+driver-specific ``devlink`` documentation under
+``Documentation/networking/devlink/``.
+
+When possible, a selftest (under ``tools/testing/selftests/drivers/``) should
+also be provided to ensure the metrics are updated under the right conditions.
diff --git a/Documentation/networking/devlink/index.rst b/Documentation/networking/devlink/index.rst
index 7684ae5c4a4a..b6f353384968 100644
--- a/Documentation/networking/devlink/index.rst
+++ b/Documentation/networking/devlink/index.rst
@@ -21,6 +21,7 @@ general.
    devlink-region
    devlink-resource
    devlink-trap
+   devlink-metric
 
 Driver-specific documentation
 -----------------------------
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 8f3c8a443238..f4754075dc43 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -36,6 +36,7 @@ struct devlink {
 	struct list_head trap_list;
 	struct list_head trap_group_list;
 	struct list_head trap_policer_list;
+	struct list_head metric_list;
 	const struct devlink_ops *ops;
 	struct xarray snapshot_ids;
 	struct device *dev;
@@ -990,6 +991,16 @@ enum devlink_trap_group_generic_id {
 		.min_burst = _min_burst,				      \
 	}
 
+struct devlink_metric;
+
+/**
+ * struct devlink_metric_ops - Metric operations.
+ * @counter_get: Get the counter value. Cannot be NULL when counter.
+ */
+struct devlink_metric_ops {
+	int (*counter_get)(struct devlink_metric *metric, u64 *p_val);
+};
+
 struct devlink_ops {
 	int (*reload_down)(struct devlink *devlink, bool netns_change,
 			   struct netlink_ext_ack *extack);
@@ -1405,6 +1416,13 @@ devlink_trap_policers_unregister(struct devlink *devlink,
 				 const struct devlink_trap_policer *policers,
 				 size_t policers_count);
 
+void *devlink_metric_priv(struct devlink_metric *metric);
+struct devlink_metric *
+devlink_metric_counter_create(struct devlink *devlink, const char *name,
+			      const struct devlink_metric_ops *ops, void *priv);
+void devlink_metric_destroy(struct devlink *devlink,
+			    struct devlink_metric *metric);
+
 #if IS_ENABLED(CONFIG_NET_DEVLINK)
 
 void devlink_compat_running_version(struct net_device *dev,
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index cfef4245ea5a..ebb555cb7cf7 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -122,6 +122,11 @@ enum devlink_command {
 	DEVLINK_CMD_TRAP_POLICER_NEW,
 	DEVLINK_CMD_TRAP_POLICER_DEL,
 
+	DEVLINK_CMD_METRIC_GET,		/* can dump */
+	DEVLINK_CMD_METRIC_SET,
+	DEVLINK_CMD_METRIC_NEW,
+	DEVLINK_CMD_METRIC_DEL,
+
 	/* add new commands above here */
 	__DEVLINK_CMD_MAX,
 	DEVLINK_CMD_MAX = __DEVLINK_CMD_MAX - 1
@@ -272,6 +277,14 @@ enum {
 	DEVLINK_ATTR_TRAP_METADATA_TYPE_FA_COOKIE,
 };
 
+/**
+ * enum devlink_metric_type - Metric type.
+ * @DEVLINK_METRIC_TYPE_COUNTER: Counter. Monotonically increasing.
+ */
+enum devlink_metric_type {
+	DEVLINK_METRIC_TYPE_COUNTER,
+};
+
 enum devlink_attr {
 	/* don't change the order or add anything between, this is ABI! */
 	DEVLINK_ATTR_UNSPEC,
@@ -458,6 +471,12 @@ enum devlink_attr {
 	DEVLINK_ATTR_PORT_LANES,			/* u32 */
 	DEVLINK_ATTR_PORT_SPLITTABLE,			/* u8 */
 
+	DEVLINK_ATTR_METRIC_NAME,		/* string */
+	/* enum devlink_metric_type */
+	DEVLINK_ATTR_METRIC_TYPE,		/* u8 */
+	DEVLINK_ATTR_METRIC_COUNTER_VALUE,	/* u64 */
+	DEVLINK_ATTR_METRIC_GROUP,		/* u32 */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index e674f0f46dc2..94c0a1e09242 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -6994,6 +6994,218 @@ static int devlink_nl_cmd_trap_policer_set_doit(struct sk_buff *skb,
 	return devlink_trap_policer_set(devlink, policer_item, info);
 }
 
+/**
+ * struct devlink_metric - Metric attributes.
+ * @name: Metric name.
+ * @ops: Metric operations.
+ * @list: Member of 'metric_list'
+ * @type: Metric type.
+ * @group: Group number. '0' is the default group number.
+ * @priv: Metric private information.
+ */
+struct devlink_metric {
+	const char *name;
+	const struct devlink_metric_ops *ops;
+	struct list_head list;
+	enum devlink_metric_type type;
+	u32 group;
+	void *priv;
+};
+
+static struct devlink_metric *
+devlink_metric_lookup(struct devlink *devlink, const char *name)
+{
+	struct devlink_metric *metric;
+
+	list_for_each_entry(metric, &devlink->metric_list, list) {
+		if (!strcmp(metric->name, name))
+			return metric;
+	}
+
+	return NULL;
+}
+
+static struct devlink_metric *
+devlink_metric_get_from_info(struct devlink *devlink, struct genl_info *info)
+{
+	struct nlattr *attr;
+
+	if (!info->attrs[DEVLINK_ATTR_METRIC_NAME])
+		return NULL;
+	attr = info->attrs[DEVLINK_ATTR_METRIC_NAME];
+
+	return devlink_metric_lookup(devlink, nla_data(attr));
+}
+
+static int devlink_nl_metric_counter_fill(struct sk_buff *msg,
+					  struct devlink_metric *metric)
+{
+	u64 val;
+	int err;
+
+	err = metric->ops->counter_get(metric, &val);
+	if (err)
+		return err;
+
+	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_METRIC_COUNTER_VALUE, val,
+			      DEVLINK_ATTR_PAD))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+static int
+devlink_nl_metric_fill(struct sk_buff *msg, struct devlink *devlink,
+		       struct devlink_metric *metric, enum devlink_command cmd,
+		       u32 portid, u32 seq, int flags)
+{
+	void *hdr;
+
+	hdr = genlmsg_put(msg, portid, seq, &devlink_nl_family, flags, cmd);
+	if (!hdr)
+		return -EMSGSIZE;
+
+	if (devlink_nl_put_handle(msg, devlink))
+		goto nla_put_failure;
+
+	if (nla_put_string(msg, DEVLINK_ATTR_METRIC_NAME, metric->name))
+		goto nla_put_failure;
+
+	if (nla_put_u8(msg, DEVLINK_ATTR_METRIC_TYPE, metric->type))
+		goto nla_put_failure;
+
+	if (metric->type == DEVLINK_METRIC_TYPE_COUNTER &&
+	    devlink_nl_metric_counter_fill(msg, metric))
+		goto nla_put_failure;
+
+	if (nla_put_u32(msg, DEVLINK_ATTR_METRIC_GROUP, metric->group))
+		goto nla_put_failure;
+
+	genlmsg_end(msg, hdr);
+
+	return 0;
+
+nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	return -EMSGSIZE;
+}
+
+static int devlink_nl_cmd_metric_get_doit(struct sk_buff *skb,
+					  struct genl_info *info)
+{
+	struct netlink_ext_ack *extack = info->extack;
+	struct devlink *devlink = info->user_ptr[0];
+	struct devlink_metric *metric;
+	struct sk_buff *msg;
+	int err;
+
+	if (list_empty(&devlink->metric_list))
+		return -EOPNOTSUPP;
+
+	metric = devlink_metric_get_from_info(devlink, info);
+	if (!metric) {
+		NL_SET_ERR_MSG_MOD(extack, "Device did not register this metric");
+		return -ENOENT;
+	}
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	err = devlink_nl_metric_fill(msg, devlink, metric,
+				     DEVLINK_CMD_METRIC_NEW, info->snd_portid,
+				     info->snd_seq, 0);
+	if (err)
+		goto err_metric_fill;
+
+	return genlmsg_reply(msg, info);
+
+err_metric_fill:
+	nlmsg_free(msg);
+	return err;
+}
+
+static int devlink_nl_cmd_metric_get_dumpit(struct sk_buff *msg,
+					    struct netlink_callback *cb)
+{
+	const struct genl_dumpit_info *info = genl_dumpit_info(cb);
+	enum devlink_command cmd = DEVLINK_CMD_METRIC_NEW;
+	u32 portid = NETLINK_CB(cb->skb).portid;
+	struct devlink_metric *metric;
+	struct devlink *devlink;
+	int start = cb->args[0];
+	int flags = NLM_F_MULTI;
+	u32 group = 0;
+	int idx = 0;
+	int err;
+
+	if (info->attrs[DEVLINK_ATTR_METRIC_GROUP]) {
+		group = nla_get_u32(info->attrs[DEVLINK_ATTR_METRIC_GROUP]);
+		flags |= NLM_F_DUMP_FILTERED;
+	}
+
+	mutex_lock(&devlink_mutex);
+	list_for_each_entry(devlink, &devlink_list, list) {
+		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
+			continue;
+		mutex_lock(&devlink->lock);
+		list_for_each_entry(metric, &devlink->metric_list, list) {
+			if (idx < start) {
+				idx++;
+				continue;
+			}
+			if (group && metric->group != group) {
+				idx++;
+				continue;
+			}
+			err = devlink_nl_metric_fill(msg, devlink, metric, cmd,
+						     portid, cb->nlh->nlmsg_seq,
+						     flags);
+			if (err) {
+				mutex_unlock(&devlink->lock);
+				goto out;
+			}
+			idx++;
+		}
+		mutex_unlock(&devlink->lock);
+	}
+out:
+	mutex_unlock(&devlink_mutex);
+
+	cb->args[0] = idx;
+	return msg->len;
+}
+
+static void devlink_metric_group_set(struct devlink_metric *metric,
+				     struct genl_info *info)
+{
+	if (!info->attrs[DEVLINK_ATTR_METRIC_GROUP])
+		return;
+
+	metric->group = nla_get_u32(info->attrs[DEVLINK_ATTR_METRIC_GROUP]);
+}
+
+static int devlink_nl_cmd_metric_set_doit(struct sk_buff *skb,
+					  struct genl_info *info)
+{
+	struct netlink_ext_ack *extack = info->extack;
+	struct devlink *devlink = info->user_ptr[0];
+	struct devlink_metric *metric;
+
+	if (list_empty(&devlink->metric_list))
+		return -EOPNOTSUPP;
+
+	metric = devlink_metric_get_from_info(devlink, info);
+	if (!metric) {
+		NL_SET_ERR_MSG_MOD(extack, "Device did not register this metric");
+		return -ENOENT;
+	}
+
+	devlink_metric_group_set(metric, info);
+
+	return 0;
+}
+
 static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_UNSPEC] = { .strict_start_type =
 		DEVLINK_ATTR_TRAP_POLICER_ID },
@@ -7039,6 +7251,9 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_TRAP_POLICER_RATE] = { .type = NLA_U64 },
 	[DEVLINK_ATTR_TRAP_POLICER_BURST] = { .type = NLA_U64 },
 	[DEVLINK_ATTR_PORT_FUNCTION] = { .type = NLA_NESTED },
+	[DEVLINK_ATTR_METRIC_NAME] = { .type = NLA_NUL_STRING },
+	[DEVLINK_ATTR_METRIC_TYPE] = { .type = NLA_U8 },
+	[DEVLINK_ATTR_METRIC_GROUP] = { .type = NLA_U32 },
 };
 
 static const struct genl_ops devlink_nl_ops[] = {
@@ -7347,6 +7562,17 @@ static const struct genl_ops devlink_nl_ops[] = {
 		.doit = devlink_nl_cmd_trap_policer_set_doit,
 		.flags = GENL_ADMIN_PERM,
 	},
+	{
+		.cmd = DEVLINK_CMD_METRIC_GET,
+		.doit = devlink_nl_cmd_metric_get_doit,
+		.dumpit = devlink_nl_cmd_metric_get_dumpit,
+		/* can be retrieved by unprivileged users */
+	},
+	{
+		.cmd = DEVLINK_CMD_METRIC_SET,
+		.doit = devlink_nl_cmd_metric_set_doit,
+		.flags = GENL_ADMIN_PERM,
+	},
 };
 
 static struct genl_family devlink_nl_family __ro_after_init = {
@@ -7396,6 +7622,7 @@ struct devlink *devlink_alloc(const struct devlink_ops *ops, size_t priv_size)
 	INIT_LIST_HEAD(&devlink->trap_list);
 	INIT_LIST_HEAD(&devlink->trap_group_list);
 	INIT_LIST_HEAD(&devlink->trap_policer_list);
+	INIT_LIST_HEAD(&devlink->metric_list);
 	mutex_init(&devlink->lock);
 	mutex_init(&devlink->reporters_lock);
 	return devlink;
@@ -7480,6 +7707,7 @@ void devlink_free(struct devlink *devlink)
 {
 	mutex_destroy(&devlink->reporters_lock);
 	mutex_destroy(&devlink->lock);
+	WARN_ON(!list_empty(&devlink->metric_list));
 	WARN_ON(!list_empty(&devlink->trap_policer_list));
 	WARN_ON(!list_empty(&devlink->trap_group_list));
 	WARN_ON(!list_empty(&devlink->trap_list));
@@ -9484,6 +9712,124 @@ devlink_trap_policers_unregister(struct devlink *devlink,
 }
 EXPORT_SYMBOL_GPL(devlink_trap_policers_unregister);
 
+/**
+ * devlink_metric_priv - Return metric private information.
+ * @metric: Metric.
+ *
+ * Return: Metric private information that was passed from device-driver
+ * during metric creation.
+ */
+void *devlink_metric_priv(struct devlink_metric *metric)
+{
+	return metric->priv;
+}
+EXPORT_SYMBOL_GPL(devlink_metric_priv);
+
+static void devlink_metric_notify(struct devlink *devlink,
+				  struct devlink_metric *metric,
+				  enum devlink_command cmd)
+{
+	struct sk_buff *msg;
+	int err;
+
+	WARN_ON_ONCE(cmd != DEVLINK_CMD_METRIC_NEW &&
+		     cmd != DEVLINK_CMD_METRIC_DEL);
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return;
+
+	err = devlink_nl_metric_fill(msg, devlink, metric, cmd, 0, 0, 0);
+	if (err) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	genlmsg_multicast_netns(&devlink_nl_family, devlink_net(devlink),
+				msg, 0, DEVLINK_MCGRP_CONFIG, GFP_KERNEL);
+}
+
+/**
+ * devlink_metric_counter_create - Create metric of counter type.
+ * @devlink: devlink.
+ * @name: Metric name.
+ * @ops: Metric operations.
+ * @priv: Metric private information.
+ *
+ * All metrics must be documented in the per-device documentation under
+ * Documentation/networking/devlink/.
+ *
+ * Return: Error pointer on failure.
+ */
+struct devlink_metric *
+devlink_metric_counter_create(struct devlink *devlink, const char *name,
+			      const struct devlink_metric_ops *ops, void *priv)
+{
+	struct devlink_metric *metric;
+	int err;
+
+	if (!ops || !ops->counter_get || !name)
+		return ERR_PTR(-EINVAL);
+
+	mutex_lock(&devlink->lock);
+
+	if (devlink_metric_lookup(devlink, name)) {
+		err = -EEXIST;
+		goto err_exists;
+	}
+
+	metric = kzalloc(sizeof(*metric), GFP_KERNEL);
+	if (!metric) {
+		err = -ENOMEM;
+		goto err_alloc_metric;
+	}
+
+	metric->name = kstrdup(name, GFP_KERNEL);
+	if (!metric->name) {
+		err = -ENOMEM;
+		goto err_alloc_metric_name;
+	}
+
+	metric->ops = ops;
+	metric->type = DEVLINK_METRIC_TYPE_COUNTER;
+	metric->group = 0;
+	metric->priv = priv;
+
+	list_add_tail(&metric->list, &devlink->metric_list);
+	devlink_metric_notify(devlink, metric, DEVLINK_CMD_METRIC_NEW);
+
+	mutex_unlock(&devlink->lock);
+
+	return metric;
+
+err_alloc_metric_name:
+	kfree(metric);
+err_alloc_metric:
+err_exists:
+	mutex_unlock(&devlink->lock);
+	return ERR_PTR(err);
+}
+EXPORT_SYMBOL_GPL(devlink_metric_counter_create);
+
+/**
+ * devlink_metric_destroy - Destroy metric.
+ * @devlink: devlink.
+ * @metric: Metric.
+ */
+void devlink_metric_destroy(struct devlink *devlink,
+			    struct devlink_metric *metric)
+{
+	mutex_lock(&devlink->lock);
+
+	devlink_metric_notify(devlink, metric, DEVLINK_CMD_METRIC_DEL);
+	list_del(&metric->list);
+	kfree(metric->name);
+	kfree(metric);
+
+	mutex_unlock(&devlink->lock);
+}
+EXPORT_SYMBOL_GPL(devlink_metric_destroy);
+
 static void __devlink_compat_running_version(struct devlink *devlink,
 					     char *buf, size_t len)
 {
-- 
2.26.2

