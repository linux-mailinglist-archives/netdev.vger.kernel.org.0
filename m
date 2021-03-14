Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17C0633A4B2
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 13:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235358AbhCNMUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 08:20:55 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:60231 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235314AbhCNMU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 08:20:26 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 77E725808B9;
        Sun, 14 Mar 2021 08:20:25 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 14 Mar 2021 08:20:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=SVxoCbaPktjRtjNgzaccfypQp7Z82/u8w0Kn7kQZQEA=; b=HScJ9bZI
        xaLHzhE3TTMy+ofjfROsDb29R7Jm/3HsqvedHid9ARh5Vsrlrj36WMmjzHdar8Od
        JRnNBbpXA7qU2iylp75Qe4d+V29JjggrX7cqAXA1iOx88iC9e88yok9aF6iaqDnY
        j+LXmlMvE/+lDEsMcndaArf8pLBUvb4HfTP5IsmV7zyBkUsuS8J7o0BkSWFwVB3U
        jNXfL5qAlgRLZi4uof54qr7Eq3ZgELeFTUX8GpDHecHvlv9ZJcyxLWgMdmVdzp95
        ep27YRHvqGI72SG9BxWtXz9HlV2qvh3hvrMqOKgg1mZvZMOat7Riww8optBWsAxj
        WsCcwqLvuum/4w==
X-ME-Sender: <xms:if9NYLbnOGEsHCZfcLn7jjux87A8l-CZfRQvSkQPedYB2QGfWBhYUQ>
    <xme:if9NYKZIJj0eOhUHUygznAgzpe3hOgqb67EwsZF1a1UcTYmcgS0XQFW7dvQGtwaZI
    sag7TczE6MVHEM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvjedgudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:if9NYN9q-lLKx9hqqpYQ1HoVlQA2XalJh5IcWg0ujWz0J-RS05vB3A>
    <xmx:if9NYBpHG32-4RfyCpEYkXrFkYQ0TMd9BpYIijoUAkKrPRHzMwKJHA>
    <xmx:if9NYGpmuhom__Ikw5j3EX6G5XKU7LzfkwmtwgnIsG0pW7Wxw9G9KQ>
    <xmx:if9NYCfJJUseoLHROtvXk0OVui0Yc4e5j8X9PsljnaCimyMbLZludQ>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8D11F240057;
        Sun, 14 Mar 2021 08:20:22 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        yotam.gi@gmail.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        roopa@nvidia.com, peter.phaal@inmon.com, neil.mckee@inmon.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 03/11] netdevsim: Add dummy psample implementation
Date:   Sun, 14 Mar 2021 14:19:32 +0200
Message-Id: <20210314121940.2807621-4-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210314121940.2807621-1-idosch@idosch.org>
References: <20210314121940.2807621-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Allow netdevsim to report "sampled" packets to the psample module by
periodically generating packets from a work queue. The behavior can be
enabled / disabled (default) and the various meta data attributes can be
controlled via debugfs knobs.

This implementation enables both testing of the psample module with all
the optional attributes as well as development of user space
applications on top of psample such as hsflowd and a Wireshark dissector
for psample generic netlink packets.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/Kconfig               |   1 +
 drivers/net/netdevsim/Makefile    |   4 +
 drivers/net/netdevsim/dev.c       |  17 +-
 drivers/net/netdevsim/netdevsim.h |  15 ++
 drivers/net/netdevsim/psample.c   | 264 ++++++++++++++++++++++++++++++
 5 files changed, 299 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/netdevsim/psample.c

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index bcd31f458d1a..5895905b6aa1 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -579,6 +579,7 @@ config NETDEVSIM
 	depends on DEBUG_FS
 	depends on INET
 	depends on IPV6 || IPV6=n
+	depends on PSAMPLE || PSAMPLE=n
 	select NET_DEVLINK
 	help
 	  This driver is a developer testing tool and software model that can
diff --git a/drivers/net/netdevsim/Makefile b/drivers/net/netdevsim/Makefile
index ade086eed955..a1cbfa44a1e1 100644
--- a/drivers/net/netdevsim/Makefile
+++ b/drivers/net/netdevsim/Makefile
@@ -13,3 +13,7 @@ endif
 ifneq ($(CONFIG_XFRM_OFFLOAD),)
 netdevsim-objs += ipsec.o
 endif
+
+ifneq ($(CONFIG_PSAMPLE),)
+netdevsim-objs += psample.o
+endif
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index dbeb29fa16e8..6189a4c0d39e 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -1032,10 +1032,14 @@ static int nsim_dev_reload_create(struct nsim_dev *nsim_dev,
 	if (err)
 		goto err_fib_destroy;
 
-	err = nsim_dev_port_add_all(nsim_dev, nsim_bus_dev->port_count);
+	err = nsim_dev_psample_init(nsim_dev);
 	if (err)
 		goto err_health_exit;
 
+	err = nsim_dev_port_add_all(nsim_dev, nsim_bus_dev->port_count);
+	if (err)
+		goto err_psample_exit;
+
 	nsim_dev->take_snapshot = debugfs_create_file("take_snapshot",
 						      0200,
 						      nsim_dev->ddir,
@@ -1043,6 +1047,8 @@ static int nsim_dev_reload_create(struct nsim_dev *nsim_dev,
 						&nsim_dev_take_snapshot_fops);
 	return 0;
 
+err_psample_exit:
+	nsim_dev_psample_exit(nsim_dev);
 err_health_exit:
 	nsim_dev_health_exit(nsim_dev);
 err_fib_destroy:
@@ -1118,14 +1124,20 @@ int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev)
 	if (err)
 		goto err_health_exit;
 
-	err = nsim_dev_port_add_all(nsim_dev, nsim_bus_dev->port_count);
+	err = nsim_dev_psample_init(nsim_dev);
 	if (err)
 		goto err_bpf_dev_exit;
 
+	err = nsim_dev_port_add_all(nsim_dev, nsim_bus_dev->port_count);
+	if (err)
+		goto err_psample_exit;
+
 	devlink_params_publish(devlink);
 	devlink_reload_enable(devlink);
 	return 0;
 
+err_psample_exit:
+	nsim_dev_psample_exit(nsim_dev);
 err_bpf_dev_exit:
 	nsim_bpf_dev_exit(nsim_dev);
 err_health_exit:
@@ -1158,6 +1170,7 @@ static void nsim_dev_reload_destroy(struct nsim_dev *nsim_dev)
 		return;
 	debugfs_remove(nsim_dev->take_snapshot);
 	nsim_dev_port_del_all(nsim_dev);
+	nsim_dev_psample_exit(nsim_dev);
 	nsim_dev_health_exit(nsim_dev);
 	nsim_fib_destroy(devlink, nsim_dev->fib_data);
 	nsim_dev_traps_exit(devlink);
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 48163c5f2ec9..d735c21def4b 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -180,6 +180,20 @@ struct nsim_dev_health {
 int nsim_dev_health_init(struct nsim_dev *nsim_dev, struct devlink *devlink);
 void nsim_dev_health_exit(struct nsim_dev *nsim_dev);
 
+#if IS_ENABLED(CONFIG_PSAMPLE)
+int nsim_dev_psample_init(struct nsim_dev *nsim_dev);
+void nsim_dev_psample_exit(struct nsim_dev *nsim_dev);
+#else
+static inline int nsim_dev_psample_init(struct nsim_dev *nsim_dev)
+{
+	return 0;
+}
+
+static inline void nsim_dev_psample_exit(struct nsim_dev *nsim_dev)
+{
+}
+#endif
+
 struct nsim_dev_port {
 	struct list_head list;
 	struct devlink_port devlink_port;
@@ -229,6 +243,7 @@ struct nsim_dev {
 		bool static_iana_vxlan;
 		u32 sleep;
 	} udp_ports;
+	struct nsim_dev_psample *psample;
 };
 
 static inline struct net *nsim_dev_net(struct nsim_dev *nsim_dev)
diff --git a/drivers/net/netdevsim/psample.c b/drivers/net/netdevsim/psample.c
new file mode 100644
index 000000000000..5ec3bd7f891b
--- /dev/null
+++ b/drivers/net/netdevsim/psample.c
@@ -0,0 +1,264 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Mellanox Technologies. All rights reserved */
+
+#include <linux/debugfs.h>
+#include <linux/err.h>
+#include <linux/etherdevice.h>
+#include <linux/inet.h>
+#include <linux/kernel.h>
+#include <linux/random.h>
+#include <linux/slab.h>
+#include <net/devlink.h>
+#include <net/ip.h>
+#include <net/psample.h>
+#include <uapi/linux/ip.h>
+#include <uapi/linux/udp.h>
+
+#include "netdevsim.h"
+
+#define NSIM_PSAMPLE_REPORT_INTERVAL_MS	100
+#define NSIM_PSAMPLE_INVALID_TC		0xFFFF
+#define NSIM_PSAMPLE_L4_DATA_LEN	100
+
+struct nsim_dev_psample {
+	struct delayed_work psample_dw;
+	struct dentry *ddir;
+	struct psample_group *group;
+	u32 rate;
+	u32 group_num;
+	u32 trunc_size;
+	int in_ifindex;
+	int out_ifindex;
+	u16 out_tc;
+	u64 out_tc_occ_max;
+	u64 latency_max;
+	bool is_active;
+};
+
+static struct sk_buff *nsim_dev_psample_skb_build(void)
+{
+	int tot_len, data_len = NSIM_PSAMPLE_L4_DATA_LEN;
+	struct sk_buff *skb;
+	struct udphdr *udph;
+	struct ethhdr *eth;
+	struct iphdr *iph;
+
+	skb = alloc_skb(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (!skb)
+		return NULL;
+	tot_len = sizeof(struct iphdr) + sizeof(struct udphdr) + data_len;
+
+	skb_reset_mac_header(skb);
+	eth = skb_put(skb, sizeof(struct ethhdr));
+	eth_random_addr(eth->h_dest);
+	eth_random_addr(eth->h_source);
+	eth->h_proto = htons(ETH_P_IP);
+	skb->protocol = htons(ETH_P_IP);
+
+	skb_set_network_header(skb, skb->len);
+	iph = skb_put(skb, sizeof(struct iphdr));
+	iph->protocol = IPPROTO_UDP;
+	iph->saddr = in_aton("192.0.2.1");
+	iph->daddr = in_aton("198.51.100.1");
+	iph->version = 0x4;
+	iph->frag_off = 0;
+	iph->ihl = 0x5;
+	iph->tot_len = htons(tot_len);
+	iph->id = 0;
+	iph->ttl = 100;
+	iph->check = 0;
+	iph->check = ip_fast_csum((unsigned char *)iph, iph->ihl);
+
+	skb_set_transport_header(skb, skb->len);
+	udph = skb_put_zero(skb, sizeof(struct udphdr) + data_len);
+	get_random_bytes(&udph->source, sizeof(u16));
+	get_random_bytes(&udph->dest, sizeof(u16));
+	udph->len = htons(sizeof(struct udphdr) + data_len);
+
+	return skb;
+}
+
+static void nsim_dev_psample_md_prepare(const struct nsim_dev_psample *psample,
+					struct psample_metadata *md)
+{
+	md->trunc_size = psample->trunc_size;
+	md->in_ifindex = psample->in_ifindex;
+	md->out_ifindex = psample->out_ifindex;
+
+	if (psample->out_tc != NSIM_PSAMPLE_INVALID_TC) {
+		md->out_tc = psample->out_tc;
+		md->out_tc_valid = 1;
+	}
+
+	if (psample->out_tc_occ_max) {
+		u64 out_tc_occ;
+
+		get_random_bytes(&out_tc_occ, sizeof(u64));
+		md->out_tc_occ = out_tc_occ & (psample->out_tc_occ_max - 1);
+		md->out_tc_occ_valid = 1;
+	}
+
+	if (psample->latency_max) {
+		u64 latency;
+
+		get_random_bytes(&latency, sizeof(u64));
+		md->latency = latency & (psample->latency_max - 1);
+		md->latency_valid = 1;
+	}
+}
+
+static void nsim_dev_psample_report_work(struct work_struct *work)
+{
+	struct nsim_dev_psample *psample;
+	struct psample_metadata md = {};
+	struct sk_buff *skb;
+	unsigned long delay;
+
+	psample = container_of(work, struct nsim_dev_psample, psample_dw.work);
+
+	skb = nsim_dev_psample_skb_build();
+	if (!skb)
+		goto out;
+
+	nsim_dev_psample_md_prepare(psample, &md);
+	psample_sample_packet(psample->group, skb, psample->rate, &md);
+	consume_skb(skb);
+
+out:
+	delay = msecs_to_jiffies(NSIM_PSAMPLE_REPORT_INTERVAL_MS);
+	schedule_delayed_work(&psample->psample_dw, delay);
+}
+
+static int nsim_dev_psample_enable(struct nsim_dev *nsim_dev)
+{
+	struct nsim_dev_psample *psample = nsim_dev->psample;
+	struct devlink *devlink;
+	unsigned long delay;
+
+	if (psample->is_active)
+		return -EBUSY;
+
+	devlink = priv_to_devlink(nsim_dev);
+	psample->group = psample_group_get(devlink_net(devlink),
+					   psample->group_num);
+	if (!psample->group)
+		return -EINVAL;
+
+	delay = msecs_to_jiffies(NSIM_PSAMPLE_REPORT_INTERVAL_MS);
+	schedule_delayed_work(&psample->psample_dw, delay);
+
+	psample->is_active = true;
+
+	return 0;
+}
+
+static int nsim_dev_psample_disable(struct nsim_dev *nsim_dev)
+{
+	struct nsim_dev_psample *psample = nsim_dev->psample;
+
+	if (!psample->is_active)
+		return -EINVAL;
+
+	psample->is_active = false;
+
+	cancel_delayed_work_sync(&psample->psample_dw);
+	psample_group_put(psample->group);
+
+	return 0;
+}
+
+static ssize_t nsim_dev_psample_enable_write(struct file *file,
+					     const char __user *data,
+					     size_t count, loff_t *ppos)
+{
+	struct nsim_dev *nsim_dev = file->private_data;
+	bool enable;
+	int err;
+
+	err = kstrtobool_from_user(data, count, &enable);
+	if (err)
+		return err;
+
+	if (enable)
+		err = nsim_dev_psample_enable(nsim_dev);
+	else
+		err = nsim_dev_psample_disable(nsim_dev);
+
+	return err ? err : count;
+}
+
+static const struct file_operations nsim_psample_enable_fops = {
+	.open = simple_open,
+	.write = nsim_dev_psample_enable_write,
+	.llseek = generic_file_llseek,
+	.owner = THIS_MODULE,
+};
+
+int nsim_dev_psample_init(struct nsim_dev *nsim_dev)
+{
+	struct nsim_dev_psample *psample;
+	int err;
+
+	psample = kzalloc(sizeof(*psample), GFP_KERNEL);
+	if (!psample)
+		return -ENOMEM;
+	nsim_dev->psample = psample;
+
+	INIT_DELAYED_WORK(&psample->psample_dw, nsim_dev_psample_report_work);
+
+	psample->ddir = debugfs_create_dir("psample", nsim_dev->ddir);
+	if (IS_ERR(psample->ddir)) {
+		err = PTR_ERR(psample->ddir);
+		goto err_psample_free;
+	}
+
+	/* Populate sampling parameters with sane defaults. */
+	psample->rate = 100;
+	debugfs_create_u32("rate", 0600, psample->ddir, &psample->rate);
+
+	psample->group_num = 10;
+	debugfs_create_u32("group_num", 0600, psample->ddir,
+			   &psample->group_num);
+
+	psample->trunc_size = 0;
+	debugfs_create_u32("trunc_size", 0600, psample->ddir,
+			   &psample->trunc_size);
+
+	psample->in_ifindex = 1;
+	debugfs_create_u32("in_ifindex", 0600, psample->ddir,
+			   &psample->in_ifindex);
+
+	psample->out_ifindex = 2;
+	debugfs_create_u32("out_ifindex", 0600, psample->ddir,
+			   &psample->out_ifindex);
+
+	psample->out_tc = 0;
+	debugfs_create_u16("out_tc", 0600, psample->ddir, &psample->out_tc);
+
+	psample->out_tc_occ_max = 10000;
+	debugfs_create_u64("out_tc_occ_max", 0600, psample->ddir,
+			   &psample->out_tc_occ_max);
+
+	psample->latency_max = 50;
+	debugfs_create_u64("latency_max", 0600, psample->ddir,
+			   &psample->latency_max);
+
+	debugfs_create_file("enable", 0200, psample->ddir, nsim_dev,
+			    &nsim_psample_enable_fops);
+
+	return 0;
+
+err_psample_free:
+	kfree(nsim_dev->psample);
+	return err;
+}
+
+void nsim_dev_psample_exit(struct nsim_dev *nsim_dev)
+{
+	debugfs_remove_recursive(nsim_dev->psample->ddir);
+	if (nsim_dev->psample->is_active) {
+		cancel_delayed_work_sync(&nsim_dev->psample->psample_dw);
+		psample_group_put(nsim_dev->psample->group);
+	}
+	kfree(nsim_dev->psample);
+}
-- 
2.29.2

