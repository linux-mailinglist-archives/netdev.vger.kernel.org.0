Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F16442C68A
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 14:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727201AbfE1Mbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 08:31:36 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:34777 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726824AbfE1MbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 08:31:22 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 703412223;
        Tue, 28 May 2019 08:22:46 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 28 May 2019 08:22:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=AD6uzafDh4BmLukVTzUx4BX1sKNhOb/jsSRmQuiB7UQ=; b=AtRkCnBL
        OEpXLli3OiVZ1mDP8VbB0+lE/utYIIMIc6r6m8OJSGNNJbVQxqjWOX24/8mTAKyE
        9+nqiQ3JqcaWgbHv5www5ynWmXBD9QqkXQDzWBaBSJv40KZ1OZpdmCXxUp4proQd
        FP8rsZnbFkguILP4CT00cS5uHPTILuTrvBqZJef+v2elVC3OUVvWgX5GUwQ8bTjf
        TcDhS1v8P0kr4mochwKPl9C9YARHNXXXF/ZBsZKaSnlkmhut2flC4wKfJrjYvb6b
        gmmHWWxF6P4U0lbWQQ5kpJ7tzWwYR5bpPg8FrpRnHsBXDAUhYy6ehQmUasYo8vau
        bjNvLKBM2tmD6g==
X-ME-Sender: <xms:FijtXKqN_F56VJEk0qdp_dtPK-_zFG_qQRjc5EB47PdWaMXCBc03Cw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddvhedgheduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeeg
X-ME-Proxy: <xmx:FijtXJ6OYPlcLILq2CbRTG2sx_1kWtPOodMpt3mQhjw26KtyzcnNAw>
    <xmx:FijtXEhohrnXj7fhbImTHgpkykM2OdVfY_ynFmQJffjrz1yclBNZ-A>
    <xmx:FijtXH2ogyGSTij7AHaj_-YHOlxw4gRcRxf5tyzPPSIyz9J5UmWXow>
    <xmx:FijtXOblyUWv4K6r2HrKZ0bwHdPZOcd4MbWIP4fx1YY6-_SLfxjiUg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id BB9D3380073;
        Tue, 28 May 2019 08:22:43 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, andy@greyhouse.net,
        pablo@netfilter.org, jakub.kicinski@netronome.com,
        pieter.jansenvanvuuren@netronome.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@savoirfairelinux.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [RFC PATCH net-next 05/12] netdevsim: Add devlink-trap support
Date:   Tue, 28 May 2019 15:21:29 +0300
Message-Id: <20190528122136.30476-6-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190528122136.30476-1-idosch@idosch.org>
References: <20190528122136.30476-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Have netdevsim register its trap groups and traps with devlink during
initialization and periodically report trapped packets to devlink core.

Since netdevsim is not a real device, the trapped packets are emulated
using a workqueue that periodically reports a UDP packet with a random
5-tuple from each active packet trap and from each running netdev.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/netdevsim/dev.c       | 270 +++++++++++++++++++++++++++++-
 drivers/net/netdevsim/netdevsim.h |   1 +
 2 files changed, 270 insertions(+), 1 deletion(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index b509b941d5ca..0115a1ef1ca3 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -17,11 +17,21 @@
 
 #include <linux/debugfs.h>
 #include <linux/device.h>
+#include <linux/etherdevice.h>
+#include <linux/inet.h>
+#include <linux/jiffies.h>
+#include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/mutex.h>
 #include <linux/random.h>
+#include <linux/workqueue.h>
+#include <linux/random.h>
 #include <linux/rtnetlink.h>
 #include <net/devlink.h>
+#include <net/ip.h>
+#include <uapi/linux/devlink.h>
+#include <uapi/linux/ip.h>
+#include <uapi/linux/udp.h>
 
 #include "netdevsim.h"
 
@@ -194,6 +204,205 @@ static int nsim_dev_resources_register(struct devlink *devlink)
 	return err;
 }
 
+struct nsim_trap_item {
+	void *trap_ctx;
+	enum devlink_trap_action action;
+};
+
+struct nsim_trap_data {
+	struct delayed_work trap_report_dw;
+	struct nsim_trap_item *trap_items_arr;
+	struct nsim_dev *nsim_dev;
+	spinlock_t trap_lock;	/* Protects trap_items_arr */
+};
+
+enum {
+	NSIM_TRAP_ID_BASE = DEVLINK_TRAP_GENERIC_ID_MAX,
+	NSIM_TRAP_ID_FID_MISS_EXCEPTION,
+};
+
+#define NSIM_TRAP_NAME_FID_MISS_EXCEPTION "fid_miss_exception"
+
+#define NSIM_TRAP_METADATA DEVLINK_TRAP_METADATA_TYPE_F_IN_PORT
+
+#define NSIM_TRAP_DROP(_id, _group_id)					      \
+	DEVLINK_TRAP_GENERIC(DROP, DROP, _id,				      \
+			     DEVLINK_TRAP_GROUP_GENERIC(_group_id),	      \
+			     NSIM_TRAP_METADATA)
+#define NSIM_TRAP_EXCEPTION(_id, _group_id)				      \
+	DEVLINK_TRAP_GENERIC(EXCEPTION, TRAP, _id,			      \
+			     DEVLINK_TRAP_GROUP_GENERIC(_group_id),	      \
+			     NSIM_TRAP_METADATA)
+#define NSIM_TRAP_DRIVER_EXCEPTION(_id, _group_id)			      \
+	DEVLINK_TRAP_DRIVER(EXCEPTION, TRAP, NSIM_TRAP_ID_##_id,	      \
+			    NSIM_TRAP_NAME_##_id,			      \
+			    DEVLINK_TRAP_GROUP_GENERIC(_group_id),	      \
+			    NSIM_TRAP_METADATA)
+
+static const struct devlink_trap nsim_traps_arr[] = {
+	NSIM_TRAP_DROP(INGRESS_SMAC_MC_DROP, L2_DROPS),
+	NSIM_TRAP_DROP(INGRESS_VLAN_TAG_ALLOW_DROP, L2_DROPS),
+	NSIM_TRAP_DROP(INGRESS_VLAN_FILTER_DROP, L2_DROPS),
+	NSIM_TRAP_DROP(INGRESS_STP_FILTER_DROP, L2_DROPS),
+	NSIM_TRAP_DROP(UC_EMPTY_TX_LIST_DROP, L2_DROPS),
+	NSIM_TRAP_DROP(MC_EMPTY_TX_LIST_DROP, L2_DROPS),
+	NSIM_TRAP_DROP(UC_LOOPBACK_FILTER_DROP, L2_DROPS),
+	NSIM_TRAP_DRIVER_EXCEPTION(FID_MISS_EXCEPTION, L2_DROPS),
+	NSIM_TRAP_DROP(BLACKHOLE_ROUTE_DROP, L3_DROPS),
+	NSIM_TRAP_EXCEPTION(TTL_ERROR_EXCEPTION, L3_DROPS),
+	NSIM_TRAP_DROP(TAIL_DROP, BUFFER_DROPS),
+	NSIM_TRAP_DROP(EARLY_DROP, BUFFER_DROPS),
+};
+
+static struct sk_buff *nsim_dev_trap_skb_build(void)
+{
+	int tot_len, data_len = 100;
+	struct sk_buff *skb;
+	struct udphdr *udph;
+	struct ethhdr *eth;
+	struct iphdr *iph;
+
+	skb = alloc_skb(NLMSG_GOODSIZE, GFP_ATOMIC);
+	if (!skb)
+		return NULL;
+	tot_len = sizeof(struct iphdr) + sizeof(struct udphdr) + data_len;
+
+	eth = skb_put(skb, sizeof(struct ethhdr));
+	eth_random_addr(eth->h_dest);
+	eth_random_addr(eth->h_source);
+	eth->h_proto = htons(ETH_P_IP);
+	skb->protocol = htons(ETH_P_IP);
+
+	iph = skb_put(skb, sizeof(struct iphdr));
+	iph->protocol = IPPROTO_UDP;
+	iph->saddr = in_aton("192.0.2.1");
+	iph->daddr = in_aton("198.51.100.1");
+	iph->version = 0x4;
+	iph->frag_off = 0;
+	iph->ihl = 0x5;
+	iph->tot_len = htons(tot_len);
+	ip_send_check(iph);
+
+	udph = skb_put_zero(skb, sizeof(struct udphdr) + data_len);
+	get_random_bytes(&udph->source, sizeof(u16));
+	get_random_bytes(&udph->dest, sizeof(u16));
+	udph->len = htons(sizeof(struct udphdr) + data_len);
+
+	return skb;
+}
+
+static void nsim_dev_trap_report(struct nsim_dev_port *nsim_dev_port)
+{
+	struct nsim_dev *nsim_dev = nsim_dev_port->ns->nsim_dev;
+	struct nsim_trap_data *nsim_trap_data = nsim_dev->trap_data;
+	struct devlink *devlink = priv_to_devlink(nsim_dev);
+	int i;
+
+	spin_lock(&nsim_trap_data->trap_lock);
+	for (i = 0; i < ARRAY_SIZE(nsim_traps_arr); i++) {
+		struct nsim_trap_item *nsim_trap_item;
+		struct sk_buff *skb;
+
+		nsim_trap_item = &nsim_trap_data->trap_items_arr[i];
+		if (nsim_trap_item->action == DEVLINK_TRAP_ACTION_DROP)
+			continue;
+
+		skb = nsim_dev_trap_skb_build();
+		if (!skb)
+			continue;
+		skb->dev = nsim_dev_port->ns->netdev;
+
+		devlink_trap_report(devlink, skb, nsim_trap_item->trap_ctx,
+				    &nsim_dev_port->devlink_port);
+		consume_skb(skb);
+	}
+	spin_unlock(&nsim_trap_data->trap_lock);
+}
+
+#define NSIM_TRAP_REPORT_INTERVAL_MS	1000
+
+static void nsim_dev_trap_report_work(struct work_struct *work)
+{
+	struct nsim_trap_data *nsim_trap_data;
+	struct nsim_dev_port *nsim_dev_port;
+	struct nsim_dev *nsim_dev;
+
+	nsim_trap_data = container_of(work, struct nsim_trap_data,
+				      trap_report_dw.work);
+	nsim_dev = nsim_trap_data->nsim_dev;
+
+	/* For each running port and enabled packet trap, generate a UDP
+	 * packet with a random 5-tuple and report it.
+	 */
+	mutex_lock(&nsim_dev->port_list_lock);
+	list_for_each_entry(nsim_dev_port, &nsim_dev->port_list, list) {
+		if (!netif_running(nsim_dev_port->ns->netdev))
+			continue;
+
+		nsim_dev_trap_report(nsim_dev_port);
+	}
+	mutex_unlock(&nsim_dev->port_list_lock);
+
+	schedule_delayed_work(&nsim_dev->trap_data->trap_report_dw,
+			      msecs_to_jiffies(NSIM_TRAP_REPORT_INTERVAL_MS));
+}
+
+static int nsim_dev_traps_init(struct devlink *devlink)
+{
+	struct nsim_dev *nsim_dev = devlink_priv(devlink);
+	struct nsim_trap_data *nsim_trap_data;
+	int err;
+
+	nsim_trap_data = kzalloc(sizeof(*nsim_trap_data), GFP_KERNEL);
+	if (!nsim_trap_data)
+		return -ENOMEM;
+
+	nsim_trap_data->trap_items_arr = kcalloc(ARRAY_SIZE(nsim_traps_arr),
+						 sizeof(struct nsim_trap_item),
+						 GFP_KERNEL);
+	if (!nsim_trap_data->trap_items_arr) {
+		err = -ENOMEM;
+		goto err_trap_data_free;
+	}
+
+	/* The lock is used to protect the action state of the registered
+	 * traps. The value is written by user and read in delayed work when
+	 * iterating over all the traps.
+	 */
+	spin_lock_init(&nsim_trap_data->trap_lock);
+	nsim_trap_data->nsim_dev = nsim_dev;
+	nsim_dev->trap_data = nsim_trap_data;
+
+	err = devlink_traps_register(devlink, nsim_traps_arr,
+				     ARRAY_SIZE(nsim_traps_arr), NULL);
+	if (err)
+		goto err_trap_items_free;
+
+	INIT_DELAYED_WORK(&nsim_dev->trap_data->trap_report_dw,
+			  nsim_dev_trap_report_work);
+	schedule_delayed_work(&nsim_dev->trap_data->trap_report_dw,
+			      msecs_to_jiffies(NSIM_TRAP_REPORT_INTERVAL_MS));
+
+	return 0;
+
+err_trap_items_free:
+	kfree(nsim_trap_data->trap_items_arr);
+err_trap_data_free:
+	kfree(nsim_trap_data);
+	return err;
+}
+
+static void nsim_dev_traps_exit(struct devlink *devlink)
+{
+	struct nsim_dev *nsim_dev = devlink_priv(devlink);
+
+	cancel_delayed_work_sync(&nsim_dev->trap_data->trap_report_dw);
+	devlink_traps_unregister(devlink, nsim_traps_arr,
+				 ARRAY_SIZE(nsim_traps_arr));
+	kfree(nsim_dev->trap_data->trap_items_arr);
+	kfree(nsim_dev->trap_data);
+}
+
 static int nsim_dev_reload(struct devlink *devlink,
 			   struct netlink_ext_ack *extack)
 {
@@ -220,8 +429,60 @@ static int nsim_dev_reload(struct devlink *devlink,
 	return 0;
 }
 
+static struct nsim_trap_item *
+nsim_dev_trap_item_lookup(struct nsim_dev *nsim_dev, u16 trap_id)
+{
+	struct nsim_trap_data *nsim_trap_data = nsim_dev->trap_data;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(nsim_traps_arr); i++) {
+		if (nsim_traps_arr[i].id == trap_id)
+			return &nsim_trap_data->trap_items_arr[i];
+	}
+
+	return NULL;
+}
+
+static int nsim_dev_devlink_trap_init(struct devlink *devlink,
+				      const struct devlink_trap *trap,
+				      void *trap_ctx)
+{
+	struct nsim_dev *nsim_dev = devlink_priv(devlink);
+	struct nsim_trap_item *nsim_trap_item;
+
+	nsim_trap_item = nsim_dev_trap_item_lookup(nsim_dev, trap->id);
+	if (WARN_ON(!nsim_trap_item))
+		return -ENOENT;
+
+	nsim_trap_item->trap_ctx = trap_ctx;
+	nsim_trap_item->action = trap->init_action;
+
+	return 0;
+}
+
+static int
+nsim_dev_devlink_trap_action_set(struct devlink *devlink,
+				 const struct devlink_trap *trap,
+				 enum devlink_trap_action action)
+{
+	struct nsim_dev *nsim_dev = devlink_priv(devlink);
+	struct nsim_trap_item *nsim_trap_item;
+
+	nsim_trap_item = nsim_dev_trap_item_lookup(nsim_dev, trap->id);
+	if (WARN_ON(!nsim_trap_item))
+		return -ENOENT;
+
+	spin_lock(&nsim_dev->trap_data->trap_lock);
+	nsim_trap_item->action = action;
+	spin_unlock(&nsim_dev->trap_data->trap_lock);
+
+	return 0;
+}
+
 static const struct devlink_ops nsim_dev_devlink_ops = {
 	.reload = nsim_dev_reload,
+	.trap_init = nsim_dev_devlink_trap_init,
+	.trap_action_set = nsim_dev_devlink_trap_action_set,
 };
 
 static struct nsim_dev *
@@ -255,10 +516,14 @@ nsim_dev_create(struct nsim_bus_dev *nsim_bus_dev, unsigned int port_count)
 	if (err)
 		goto err_resources_unregister;
 
-	err = nsim_dev_debugfs_init(nsim_dev);
+	err = nsim_dev_traps_init(devlink);
 	if (err)
 		goto err_dl_unregister;
 
+	err = nsim_dev_debugfs_init(nsim_dev);
+	if (err)
+		goto err_traps_exit;
+
 	err = nsim_bpf_dev_init(nsim_dev);
 	if (err)
 		goto err_debugfs_exit;
@@ -267,6 +532,8 @@ nsim_dev_create(struct nsim_bus_dev *nsim_bus_dev, unsigned int port_count)
 
 err_debugfs_exit:
 	nsim_dev_debugfs_exit(nsim_dev);
+err_traps_exit:
+	nsim_dev_traps_exit(devlink);
 err_dl_unregister:
 	devlink_unregister(devlink);
 err_resources_unregister:
@@ -284,6 +551,7 @@ static void nsim_dev_destroy(struct nsim_dev *nsim_dev)
 
 	nsim_bpf_dev_exit(nsim_dev);
 	nsim_dev_debugfs_exit(nsim_dev);
+	nsim_dev_traps_exit(devlink);
 	devlink_unregister(devlink);
 	devlink_resources_unregister(devlink, NULL);
 	nsim_fib_destroy(nsim_dev->fib_data);
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 3f398797c2bc..59eafe529363 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -145,6 +145,7 @@ struct nsim_dev_port {
 struct nsim_dev {
 	struct nsim_bus_dev *nsim_bus_dev;
 	struct nsim_fib_data *fib_data;
+	struct nsim_trap_data *trap_data;
 	struct dentry *ddir;
 	struct dentry *ports_ddir;
 	struct bpf_offload_dev *bpf_dev;
-- 
2.20.1

