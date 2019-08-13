Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E74EA8B1A8
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 09:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728053AbfHMH4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 03:56:12 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:36699 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728030AbfHMH4L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 03:56:11 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 2ED6B2FEF;
        Tue, 13 Aug 2019 03:56:11 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 13 Aug 2019 03:56:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=OzB96tySEXXmx8dIO4JUAiKd5PAuQdYgAw17S9g2t4M=; b=FUTLfZkw
        q3BNHZmGjQIxVmlWtfoPnJGgE1Hkvd1sPPR3J5zz95sJjwkHTt/rWN3uhlEOZlkp
        tIGDHY5CPgMDWABGlwrGrzNKu8bEDuAQz5M28JO/VGWJORIpRZTLPcToPW48UduK
        g/02f3jWVYPbROItwKtdJECOib/HWObj8rTKPL3QScH8RFzEecYDf69JlSkqkiMW
        6X0rDx/JHpkT9rYxPXoQo6KJNO7J4ff8o3YM6LqkW34awKlb6CsZQ5oaPQDr6K3L
        l3qaVXGsrwi7y52RCaTgnV6YdeN63smXvKYFBcGflk1bPrvEg0DYSVzI+8YZAvcZ
        lqFc46erjtIIVQ==
X-ME-Sender: <xms:Gm1SXQ3xZJk6MVEYZHXMXwPqxQ6UiPejzKVIzLApMaYa1ueO9--VKA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddvhedguddvhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgv
    rhfuihiivgepge
X-ME-Proxy: <xmx:G21SXVxWNV3UlnhaJnOa-clE2KGjYp4Veq4oZJOOin_fOoulztmoGQ>
    <xmx:G21SXRk3nq35zE7gXw41oPiUe5n0eT5Ri8NxkdKTo4fmvKfGDEdyWw>
    <xmx:G21SXQ-O30TfWoMwhjVMIcjpLjOv3us0j_K_Cp7S8fpveLP8z98yJQ>
    <xmx:G21SXfp9emLooj0TnuuwAwhEcdxxrBE4HRBMVORswCW7QHKYF05lUA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 859178005B;
        Tue, 13 Aug 2019 03:56:07 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, jiri@mellanox.com,
        toke@redhat.com, dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        andy@greyhouse.net, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 07/14] drop_monitor: Allow user to start monitoring hardware drops
Date:   Tue, 13 Aug 2019 10:53:53 +0300
Message-Id: <20190813075400.11841-8-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190813075400.11841-1-idosch@idosch.org>
References: <20190813075400.11841-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Drop monitor has start and stop commands, but so far these were only
used to start and stop monitoring of software drops.

Now that drop monitor can also monitor hardware drops, we should allow
the user to control these as well.

Do that by adding SW and HW flags to these commands. If no flag is
specified, then only start / stop monitoring software drops. This is
done in order to maintain backward-compatibility with existing user
space applications.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 include/uapi/linux/net_dropmon.h |   2 +
 net/core/drop_monitor.c          | 124 ++++++++++++++++++++++++++++++-
 2 files changed, 123 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/net_dropmon.h b/include/uapi/linux/net_dropmon.h
index 3bddc9ec978c..75a35dccb675 100644
--- a/include/uapi/linux/net_dropmon.h
+++ b/include/uapi/linux/net_dropmon.h
@@ -90,6 +90,8 @@ enum net_dm_attr {
 	NET_DM_ATTR_HW_ENTRIES,			/* nested */
 	NET_DM_ATTR_HW_ENTRY,			/* nested */
 	NET_DM_ATTR_HW_TRAP_COUNT,		/* u32 */
+	NET_DM_ATTR_SW_DROPS,			/* flag */
+	NET_DM_ATTR_HW_DROPS,			/* flag */
 
 	__NET_DM_ATTR_MAX,
 	NET_DM_ATTR_MAX = __NET_DM_ATTR_MAX - 1
diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 807c79d606aa..bfc024024aa3 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -952,13 +952,82 @@ static const struct net_dm_alert_ops *net_dm_alert_ops_arr[] = {
 void net_dm_hw_report(struct sk_buff *skb,
 		      const struct net_dm_hw_metadata *hw_metadata)
 {
+	rcu_read_lock();
+
 	if (!monitor_hw)
-		return;
+		goto out;
 
 	net_dm_alert_ops_arr[net_dm_alert_mode]->hw_probe(skb, hw_metadata);
+
+out:
+	rcu_read_unlock();
 }
 EXPORT_SYMBOL_GPL(net_dm_hw_report);
 
+static int net_dm_hw_monitor_start(struct netlink_ext_ack *extack)
+{
+	const struct net_dm_alert_ops *ops;
+	int cpu;
+
+	if (monitor_hw) {
+		NL_SET_ERR_MSG_MOD(extack, "Hardware monitoring already enabled");
+		return -EAGAIN;
+	}
+
+	ops = net_dm_alert_ops_arr[net_dm_alert_mode];
+
+	if (!try_module_get(THIS_MODULE)) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to take reference on module");
+		return -ENODEV;
+	}
+
+	for_each_possible_cpu(cpu) {
+		struct per_cpu_dm_data *hw_data = &per_cpu(dm_hw_cpu_data, cpu);
+		struct net_dm_hw_entries *hw_entries;
+
+		INIT_WORK(&hw_data->dm_alert_work, ops->hw_work_item_func);
+		timer_setup(&hw_data->send_timer, sched_send_work, 0);
+		hw_entries = net_dm_hw_reset_per_cpu_data(hw_data);
+		kfree(hw_entries);
+	}
+
+	monitor_hw = true;
+
+	return 0;
+}
+
+static void net_dm_hw_monitor_stop(struct netlink_ext_ack *extack)
+{
+	int cpu;
+
+	if (!monitor_hw)
+		NL_SET_ERR_MSG_MOD(extack, "Hardware monitoring already disabled");
+
+	monitor_hw = false;
+
+	/* After this call returns we are guaranteed that no CPU is processing
+	 * any hardware drops.
+	 */
+	synchronize_rcu();
+
+	for_each_possible_cpu(cpu) {
+		struct per_cpu_dm_data *hw_data = &per_cpu(dm_hw_cpu_data, cpu);
+		struct sk_buff *skb;
+
+		del_timer_sync(&hw_data->send_timer);
+		cancel_work_sync(&hw_data->dm_alert_work);
+		while ((skb = __skb_dequeue(&hw_data->drop_queue))) {
+			struct net_dm_hw_metadata *hw_metadata;
+
+			hw_metadata = NET_DM_SKB_CB(skb)->hw_metadata;
+			net_dm_hw_metadata_free(hw_metadata);
+			consume_skb(skb);
+		}
+	}
+
+	module_put(THIS_MODULE);
+}
+
 static int net_dm_trace_on_set(struct netlink_ext_ack *extack)
 {
 	const struct net_dm_alert_ops *ops;
@@ -1153,14 +1222,61 @@ static int net_dm_cmd_config(struct sk_buff *skb,
 	return 0;
 }
 
+static int net_dm_monitor_start(bool set_sw, bool set_hw,
+				struct netlink_ext_ack *extack)
+{
+	bool sw_set = false;
+	int rc;
+
+	if (set_sw) {
+		rc = set_all_monitor_traces(TRACE_ON, extack);
+		if (rc)
+			return rc;
+		sw_set = true;
+	}
+
+	if (set_hw) {
+		rc = net_dm_hw_monitor_start(extack);
+		if (rc)
+			goto err_monitor_hw;
+	}
+
+	return 0;
+
+err_monitor_hw:
+	if (sw_set)
+		set_all_monitor_traces(TRACE_OFF, extack);
+	return rc;
+}
+
+static void net_dm_monitor_stop(bool set_sw, bool set_hw,
+				struct netlink_ext_ack *extack)
+{
+	if (set_hw)
+		net_dm_hw_monitor_stop(extack);
+	if (set_sw)
+		set_all_monitor_traces(TRACE_OFF, extack);
+}
+
 static int net_dm_cmd_trace(struct sk_buff *skb,
 			struct genl_info *info)
 {
+	bool set_sw = !!info->attrs[NET_DM_ATTR_SW_DROPS];
+	bool set_hw = !!info->attrs[NET_DM_ATTR_HW_DROPS];
+	struct netlink_ext_ack *extack = info->extack;
+
+	/* To maintain backward compatibility, we start / stop monitoring of
+	 * software drops if no flag is specified.
+	 */
+	if (!set_sw && !set_hw)
+		set_sw = true;
+
 	switch (info->genlhdr->cmd) {
 	case NET_DM_CMD_START:
-		return set_all_monitor_traces(TRACE_ON, info->extack);
+		return net_dm_monitor_start(set_sw, set_hw, extack);
 	case NET_DM_CMD_STOP:
-		return set_all_monitor_traces(TRACE_OFF, info->extack);
+		net_dm_monitor_stop(set_sw, set_hw, extack);
+		return 0;
 	}
 
 	return -EOPNOTSUPP;
@@ -1392,6 +1508,8 @@ static const struct nla_policy net_dm_nl_policy[NET_DM_ATTR_MAX + 1] = {
 	[NET_DM_ATTR_ALERT_MODE] = { .type = NLA_U8 },
 	[NET_DM_ATTR_TRUNC_LEN] = { .type = NLA_U32 },
 	[NET_DM_ATTR_QUEUE_LEN] = { .type = NLA_U32 },
+	[NET_DM_ATTR_SW_DROPS]	= {. type = NLA_FLAG },
+	[NET_DM_ATTR_HW_DROPS]	= {. type = NLA_FLAG },
 };
 
 static const struct genl_ops dropmon_ops[] = {
-- 
2.21.0

