Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1792E27BF53
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 10:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbgI2I0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 04:26:15 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:42853 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727736AbgI2I0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 04:26:07 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 9077C5807A4;
        Tue, 29 Sep 2020 04:16:59 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 29 Sep 2020 04:16:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=QoINI29ECUgOwi4u+OWA9z1Jr+7hBl0nsGW70fNgRUE=; b=QlyS024s
        HrJvs8omCmq8TJtyDw5lR2DxFrf3b2cpARqMzLgplJPCs9lVgW0LbWbxrk9XM/fM
        sS1w3PQeCOvUp/Q5cnUS7/K3JkcgdMlKQ4SWWEAPnxAiKhucsrFImMFzVp+Cw/K7
        L/ydR+qxQhhyTtlZcqxaszx813VET2/CkpouwsA+k9qMqq/ngjTVaf9aFCrumIiL
        fzB9PTpMhLzcG2Ys3YP0ngZb2qWBQiy6PUnYpxS3PDa6C/BUr47wGl1GkZ9xybVo
        Gb1B2xTgrX5IaYdZHohI1cZXK5DKuhfqnsD9bIdZeKMolMalrqF+b8pa5reyuze3
        mxWWhIIQBcBYzA==
X-ME-Sender: <xms:e-1yX30hKZA4WABaq8JC7y3LNMs5oS5V0HVb86jTOvDzkf_-Ut1BKA>
    <xme:e-1yX2Gsy-IxS0e5hv2GDPYGqmjfzFRYjIiQQDf4kGGJ8D81mB-mBBFbBGEQbodE9
    6NdK0LWTAa4KWE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdekgddtvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdefjedrudegkeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:e-1yX37jY4wTnDBwNAkHTm0x2RNf3ACFLJ6zyfqtDbcOiyWTtc6x1Q>
    <xmx:e-1yX8189sUYnfbbZ0jA15R40a97NIF5X-XgkiRx855VE5OvP6mx9A>
    <xmx:e-1yX6EVU82WW2F5-Z9cXhkCl2XPtHXD6GHdMgDNl0ISeWiH8cOgQQ>
    <xmx:e-1yX90QbZsigs8qAH0_Ix8GMlqxc5FUGLl2yBN8hHgpm_m9hPP_yw>
Received: from shredder.mtl.com (igld-84-229-37-148.inter.net.il [84.229.37.148])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1B725328005A;
        Tue, 29 Sep 2020 04:16:56 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, nhorman@tuxdriver.com,
        jiri@nvidia.com, roopa@nvidia.com, aroulin@nvidia.com,
        ayal@nvidia.com, masahiroy@kernel.org, mlxsw@nvidia.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 2/7] drop_monitor: Prepare probe functions for devlink tracepoint
Date:   Tue, 29 Sep 2020 11:15:51 +0300
Message-Id: <20200929081556.1634838-3-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200929081556.1634838-1-idosch@idosch.org>
References: <20200929081556.1634838-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Drop monitor supports two alerting modes: Summary and packet. Prepare a
probe function for each, so that they could be later registered on the
devlink tracepoint by calling register_trace_devlink_trap_report(),
based on the configured alerting mode.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 net/core/drop_monitor.c | 146 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 146 insertions(+)

diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 9704522b0872..03aba582c0b9 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -30,6 +30,7 @@
 #include <net/genetlink.h>
 #include <net/netevent.h>
 #include <net/flow_offload.h>
+#include <net/devlink.h>
 
 #include <trace/events/skb.h>
 #include <trace/events/napi.h>
@@ -116,6 +117,9 @@ struct net_dm_alert_ops {
 	void (*hw_work_item_func)(struct work_struct *work);
 	void (*hw_probe)(struct sk_buff *skb,
 			 const struct net_dm_hw_metadata *hw_metadata);
+	void (*hw_trap_probe)(void *ignore, const struct devlink *devlink,
+			      struct sk_buff *skb,
+			      const struct devlink_trap_metadata *metadata);
 };
 
 struct net_dm_skb_cb {
@@ -474,12 +478,57 @@ net_dm_hw_summary_probe(struct sk_buff *skb,
 	spin_unlock_irqrestore(&hw_data->lock, flags);
 }
 
+static void
+net_dm_hw_trap_summary_probe(void *ignore, const struct devlink *devlink,
+			     struct sk_buff *skb,
+			     const struct devlink_trap_metadata *metadata)
+{
+	struct net_dm_hw_entries *hw_entries;
+	struct net_dm_hw_entry *hw_entry;
+	struct per_cpu_dm_data *hw_data;
+	unsigned long flags;
+	int i;
+
+	hw_data = this_cpu_ptr(&dm_hw_cpu_data);
+	spin_lock_irqsave(&hw_data->lock, flags);
+	hw_entries = hw_data->hw_entries;
+
+	if (!hw_entries)
+		goto out;
+
+	for (i = 0; i < hw_entries->num_entries; i++) {
+		hw_entry = &hw_entries->entries[i];
+		if (!strncmp(hw_entry->trap_name, metadata->trap_name,
+			     NET_DM_MAX_HW_TRAP_NAME_LEN - 1)) {
+			hw_entry->count++;
+			goto out;
+		}
+	}
+	if (WARN_ON_ONCE(hw_entries->num_entries == dm_hit_limit))
+		goto out;
+
+	hw_entry = &hw_entries->entries[hw_entries->num_entries];
+	strlcpy(hw_entry->trap_name, metadata->trap_name,
+		NET_DM_MAX_HW_TRAP_NAME_LEN - 1);
+	hw_entry->count = 1;
+	hw_entries->num_entries++;
+
+	if (!timer_pending(&hw_data->send_timer)) {
+		hw_data->send_timer.expires = jiffies + dm_delay * HZ;
+		add_timer(&hw_data->send_timer);
+	}
+
+out:
+	spin_unlock_irqrestore(&hw_data->lock, flags);
+}
+
 static const struct net_dm_alert_ops net_dm_alert_summary_ops = {
 	.kfree_skb_probe	= trace_kfree_skb_hit,
 	.napi_poll_probe	= trace_napi_poll_hit,
 	.work_item_func		= send_dm_alert,
 	.hw_work_item_func	= net_dm_hw_summary_work,
 	.hw_probe		= net_dm_hw_summary_probe,
+	.hw_trap_probe		= net_dm_hw_trap_summary_probe,
 };
 
 static void net_dm_packet_trace_kfree_skb_hit(void *ignore,
@@ -858,6 +907,54 @@ net_dm_hw_metadata_clone(const struct net_dm_hw_metadata *hw_metadata)
 	return NULL;
 }
 
+static struct net_dm_hw_metadata *
+net_dm_hw_metadata_copy(const struct devlink_trap_metadata *metadata)
+{
+	const struct flow_action_cookie *fa_cookie;
+	struct net_dm_hw_metadata *hw_metadata;
+	const char *trap_group_name;
+	const char *trap_name;
+
+	hw_metadata = kzalloc(sizeof(*hw_metadata), GFP_ATOMIC);
+	if (!hw_metadata)
+		return NULL;
+
+	trap_group_name = kstrdup(metadata->trap_group_name, GFP_ATOMIC);
+	if (!trap_group_name)
+		goto free_hw_metadata;
+	hw_metadata->trap_group_name = trap_group_name;
+
+	trap_name = kstrdup(metadata->trap_name, GFP_ATOMIC);
+	if (!trap_name)
+		goto free_trap_group;
+	hw_metadata->trap_name = trap_name;
+
+	if (metadata->fa_cookie) {
+		size_t cookie_size = sizeof(*fa_cookie) +
+				     metadata->fa_cookie->cookie_len;
+
+		fa_cookie = kmemdup(metadata->fa_cookie, cookie_size,
+				    GFP_ATOMIC);
+		if (!fa_cookie)
+			goto free_trap_name;
+		hw_metadata->fa_cookie = fa_cookie;
+	}
+
+	hw_metadata->input_dev = metadata->input_dev;
+	if (hw_metadata->input_dev)
+		dev_hold(hw_metadata->input_dev);
+
+	return hw_metadata;
+
+free_trap_name:
+	kfree(trap_name);
+free_trap_group:
+	kfree(trap_group_name);
+free_hw_metadata:
+	kfree(hw_metadata);
+	return NULL;
+}
+
 static void
 net_dm_hw_metadata_free(const struct net_dm_hw_metadata *hw_metadata)
 {
@@ -970,12 +1067,61 @@ net_dm_hw_packet_probe(struct sk_buff *skb,
 	consume_skb(nskb);
 }
 
+static void
+net_dm_hw_trap_packet_probe(void *ignore, const struct devlink *devlink,
+			    struct sk_buff *skb,
+			    const struct devlink_trap_metadata *metadata)
+{
+	struct net_dm_hw_metadata *n_hw_metadata;
+	ktime_t tstamp = ktime_get_real();
+	struct per_cpu_dm_data *hw_data;
+	struct sk_buff *nskb;
+	unsigned long flags;
+
+	if (!skb_mac_header_was_set(skb))
+		return;
+
+	nskb = skb_clone(skb, GFP_ATOMIC);
+	if (!nskb)
+		return;
+
+	n_hw_metadata = net_dm_hw_metadata_copy(metadata);
+	if (!n_hw_metadata)
+		goto free;
+
+	NET_DM_SKB_CB(nskb)->hw_metadata = n_hw_metadata;
+	nskb->tstamp = tstamp;
+
+	hw_data = this_cpu_ptr(&dm_hw_cpu_data);
+
+	spin_lock_irqsave(&hw_data->drop_queue.lock, flags);
+	if (skb_queue_len(&hw_data->drop_queue) < net_dm_queue_len)
+		__skb_queue_tail(&hw_data->drop_queue, nskb);
+	else
+		goto unlock_free;
+	spin_unlock_irqrestore(&hw_data->drop_queue.lock, flags);
+
+	schedule_work(&hw_data->dm_alert_work);
+
+	return;
+
+unlock_free:
+	spin_unlock_irqrestore(&hw_data->drop_queue.lock, flags);
+	u64_stats_update_begin(&hw_data->stats.syncp);
+	hw_data->stats.dropped++;
+	u64_stats_update_end(&hw_data->stats.syncp);
+	net_dm_hw_metadata_free(n_hw_metadata);
+free:
+	consume_skb(nskb);
+}
+
 static const struct net_dm_alert_ops net_dm_alert_packet_ops = {
 	.kfree_skb_probe	= net_dm_packet_trace_kfree_skb_hit,
 	.napi_poll_probe	= net_dm_packet_trace_napi_poll_hit,
 	.work_item_func		= net_dm_packet_work,
 	.hw_work_item_func	= net_dm_hw_packet_work,
 	.hw_probe		= net_dm_hw_packet_probe,
+	.hw_trap_probe		= net_dm_hw_trap_packet_probe,
 };
 
 static const struct net_dm_alert_ops *net_dm_alert_ops_arr[] = {
-- 
2.26.2

