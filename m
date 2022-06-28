Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6855155E757
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347137AbiF1OBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 10:01:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347130AbiF1OBI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 10:01:08 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98DF1369F6
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 07:01:06 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id 65so12058998pfw.11
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 07:01:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Pu5c/s8tN2EOWgET0uQyR/IwKTP0IajG/rgww1EnD4o=;
        b=NfLwl9loqYJ2lJtKFJUooems105/1q90D9jE+HV3wQqWcyiS/Dk5uuzZWDplN5Akki
         65+fE83RaHHfVy/lHQtPFjL3WR/3b5V+kJBSZh/eFEiC+zWCipbTk0UCZc4kAib5j1Dz
         Gbzf/e47CGpBVbBcxh0uf/fU8GeKjJbJuzqWHftUfmeGBZjicDR/VN87mIGBflaky0S0
         t5iF42NKHff1ImlDPL9TH5GOvPFOlTz2paoI8S1pC1tNAL/bY4JRlzZhuw79nrwnLx61
         Xc3H4Yj09dv27GdoV/H//Q9EZRV9qAkFDC94VrSMEjappicb3pWFNZVepM8BFa6OWRx/
         RA0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Pu5c/s8tN2EOWgET0uQyR/IwKTP0IajG/rgww1EnD4o=;
        b=di8oRf2ttZLv9wMlFSRTb0iK/t9SnVrHTD5sC1GZi14h/UNj5h19NOzKTomSF5ZXM3
         nuOBf9PRvpsclsxAflW3njzt+K16xholoFL928b5GJ53LISshPSV/mM5vuUwbx83A9FJ
         fqRLnpuku6QUmCNSW+lQEAtdZxdvNUjXAZs22V/8NElxNt6DYLsnwPfkxTDGOrXrhZfn
         xbYH5ZP0+2n0czcnd9guKz7DQyJQmnirxjSemUAHZ7sfsOS8BN2TKs/E51hoaG8uPv6u
         jPbBs6kGF+T0GXNgNUG/zE2yUgHQMFkpHxuyQsCRDj2mGlMdB3DRfqytLosN2+g1Dy3f
         +nIw==
X-Gm-Message-State: AJIora9KGchxbZWCNuLnxEgsnN8smx8jjmRI6QR+BIKCxKBoZlm9AE4J
        RXaHQP8ZwF9w/XMNZJinYE8D2Q==
X-Google-Smtp-Source: AGRyM1shZzm9RVgmmAI0COqEmL66affXff8K7Z4n2ZLls9QRdkETQ+6QIhrUjkuAPIwdXO8UTettMg==
X-Received: by 2002:a63:7a5e:0:b0:40c:f760:2f18 with SMTP id j30-20020a637a5e000000b0040cf7602f18mr17940630pgn.456.1656424865982;
        Tue, 28 Jun 2022 07:01:05 -0700 (PDT)
Received: from C02FG34NMD6R.bytedance.net ([139.177.225.251])
        by smtp.gmail.com with ESMTPSA id x34-20020a634a22000000b0040ca587fe0fsm9160877pga.63.2022.06.28.07.00.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Jun 2022 07:01:05 -0700 (PDT)
From:   Albert Huang <huangjie.albert@bytedance.com>
Cc:     "huangjie.albert" <huangjie.albert@bytedance.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        Petr Machata <petrm@nvidia.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Antoine Tenart <atenart@kernel.org>,
        Phil Auld <pauld@redhat.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Xin Long <lucien.xin@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net : rps : supoort a single flow to use rps
Date:   Tue, 28 Jun 2022 22:00:37 +0800
Message-Id: <20220628140044.65068-1-huangjie.albert@bytedance.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "huangjie.albert" <huangjie.albert@bytedance.com>

In some scenarios(ipsec) or products(VPN gateway),
we need to enable a single network stream to support RPS.
but In the current rps implementation, there is no support
for a single stream to utilize rps.

Introduce a hashtable to record flows that need to use rps.
For these flows, use round robin to put them on different CPUs
for further processing

how to use:
echo xxx > /sys/class/net/xxx/queues/rx-x/rps_cpus
echo 1 > /sys/class/net/xxx/queues/rx-x/rps_single_flow
and create a flow node with the function:
rps_flow_node_create

This patch can improve the performance of a single stream,
for example: On my virtual machine (4 vcpu + 8g), a single
ipsec stream (3des encryption) can improve throughput by 3-4 times:
before           after
212 Mbits/sec    698 Mbits/sec

Signed-off-by: huangjie.albert <huangjie.albert@bytedance.com>
---
 include/linux/netdevice.h |  15 +++
 net/core/dev.c            | 187 ++++++++++++++++++++++++++++++++++++++
 net/core/net-sysfs.c      |  36 ++++++++
 3 files changed, 238 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index f615a66c89e9..36412d0e0255 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -743,6 +743,7 @@ bool rps_may_expire_flow(struct net_device *dev, u16 rxq_index, u32 flow_id,
 struct netdev_rx_queue {
 	struct xdp_rxq_info		xdp_rxq;
 #ifdef CONFIG_RPS
+	bool   rps_single_flow_enable;
 	struct rps_map __rcu		*rps_map;
 	struct rps_dev_flow_table __rcu	*rps_flow_table;
 #endif
@@ -811,6 +812,20 @@ struct xps_dev_maps {
 #define XPS_RXQ_DEV_MAPS_SIZE(_tcs, _rxqs) (sizeof(struct xps_dev_maps) +\
 	(_rxqs * (_tcs) * sizeof(struct xps_map *)))
 
+
+/* define for rps_single_flow */
+struct rps_flow_info_node {
+	__be32 saddr;
+	__be32 daddr;
+	__u8 protocol;
+	u64  jiffies; /* keep the time update entry */
+	struct hlist_node node;
+};
+#define MAX_MAINTENANCE_TIME (2000)
+#define PERIODIC_AGEING_TIME (10000)
+bool rps_flow_node_create(__be32 saddr, __be32 daddr, __u8 protocol);
+void rps_single_flow_set(bool enable);
+
 #endif /* CONFIG_XPS */
 
 #define TC_MAX_QUEUE	16
diff --git a/net/core/dev.c b/net/core/dev.c
index 08ce317fcec8..da3eb184fca1 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4433,6 +4433,142 @@ set_rps_cpu(struct net_device *dev, struct sk_buff *skb,
  * CPU from the RPS map of the receiving queue for a given skb.
  * rcu_read_lock must be held on entry.
  */
+#define DEFAULT_HASH_BUKET_BIT (3)
+#define DEFAULT_QUOTA_PER_CPU (64)
+static unsigned int  quota_per_cpu = DEFAULT_QUOTA_PER_CPU;
+static atomic_t rps_flow_queue_enable_count = ATOMIC_INIT(0);
+static u64 last_aging_jiffies;
+static DEFINE_HASHTABLE(rps_flow_info_htable, DEFAULT_HASH_BUKET_BIT);
+static DEFINE_RWLOCK(rps_flow_rwlock);
+
+/* create rps flow node if not exist.
+ * update Timestamp for rps flow node if exist
+ */
+bool rps_flow_node_create(__be32 saddr, __be32 daddr, __u8 protocol)
+{
+	/* hash key */
+	u32 hash_key = saddr ^ daddr ^ protocol;
+	struct rps_flow_info_node *p_rps_flow_info = NULL;
+
+	/* no rps_single_flow_enable */
+	if (!atomic_read(&rps_flow_queue_enable_count))
+		return false;
+
+	/* find if the node already  exist */
+	read_lock(&rps_flow_rwlock);
+	hash_for_each_possible(rps_flow_info_htable, p_rps_flow_info, node, hash_key) {
+		if ((saddr == p_rps_flow_info->saddr) && (daddr == p_rps_flow_info->daddr)
+			&& (protocol == p_rps_flow_info->protocol)) {
+			p_rps_flow_info->jiffies = jiffies;
+			read_unlock(&rps_flow_rwlock);
+			return true;
+		}
+	}
+	read_unlock(&rps_flow_rwlock);
+
+	/*if not exist. get a new one */
+	p_rps_flow_info = kmalloc(sizeof(*p_rps_flow_info), GFP_KERNEL);
+	if (!p_rps_flow_info)
+		return false;
+
+	memset(p_rps_flow_info, 0, sizeof(struct rps_flow_info_node));
+	p_rps_flow_info->saddr = saddr;
+	p_rps_flow_info->daddr = daddr;
+	p_rps_flow_info->protocol = protocol;
+	p_rps_flow_info->jiffies = jiffies;
+
+	/*add the hash nodee*/
+	write_lock(&rps_flow_rwlock);
+	hash_add(rps_flow_info_htable, &p_rps_flow_info->node, hash_key);
+	write_unlock(&rps_flow_rwlock);
+	return true;
+}
+EXPORT_SYMBOL(rps_flow_node_create);
+
+static void rps_flow_node_clear(void)
+{
+	u32 bkt = 0;
+	struct rps_flow_info_node *p_rps_flow_entry = NULL;
+	struct hlist_node *tmp;
+
+	write_lock(&rps_flow_rwlock);
+	hash_for_each_safe(rps_flow_info_htable, bkt, tmp, p_rps_flow_entry, node) {
+		hash_del(&p_rps_flow_entry->node);
+		kfree(p_rps_flow_entry);
+	}
+	write_unlock(&rps_flow_rwlock);
+}
+
+void rps_single_flow_set(bool enable)
+{
+	if (enable) {
+		atomic_inc(&rps_flow_queue_enable_count);
+	} else {
+		atomic_dec(&rps_flow_queue_enable_count);
+		if (!atomic_read(&rps_flow_queue_enable_count))
+			rps_flow_node_clear();
+	}
+}
+EXPORT_SYMBOL(rps_single_flow_set);
+
+/* compute hash */
+static inline u32 rps_flow_hash_update(void)
+{
+	static u32 packet_count;
+	static u32 hash_count;
+
+	packet_count++;
+	if (packet_count % quota_per_cpu) {
+		packet_count = 0;
+		hash_count++;
+		if (hash_count == U32_MAX)
+			hash_count = 0;
+	}
+	return hash_count;
+}
+
+/* delete aging rps_flow  */
+static inline bool rps_flow_node_aging_period(void)
+{
+	u32 bkt = 0;
+	struct rps_flow_info_node *p_rps_flow_entry = NULL;
+	struct hlist_node *tmp;
+
+	if (jiffies_to_msecs(jiffies - last_aging_jiffies) < PERIODIC_AGEING_TIME)
+		return false;
+
+	last_aging_jiffies = jiffies;
+	write_lock(&rps_flow_rwlock);
+	hash_for_each_safe(rps_flow_info_htable, bkt, tmp, p_rps_flow_entry, node) {
+		if (jiffies_to_msecs(jiffies - p_rps_flow_entry->jiffies) >= MAX_MAINTENANCE_TIME) {
+			hash_del(&p_rps_flow_entry->node);
+			kfree(p_rps_flow_entry);
+		}
+	}
+	write_unlock(&rps_flow_rwlock);
+	return true;
+}
+
+/*  find vailed rps_flow */
+static inline struct rps_flow_info_node *rps_flow_find_vailed_node(__be32 saddr,
+		__be32 daddr, __u8 protocol)
+{
+	struct rps_flow_info_node *p_rps_flow_info = NULL;
+	u32 hash_key = saddr ^ daddr ^ protocol;
+
+	read_lock(&rps_flow_rwlock);
+	hash_for_each_possible(rps_flow_info_htable, p_rps_flow_info, node, hash_key) {
+		if ((saddr == p_rps_flow_info->saddr) && (daddr == p_rps_flow_info->daddr)
+		&& (protocol == p_rps_flow_info->protocol)
+		&& (jiffies_to_msecs(jiffies - p_rps_flow_info->jiffies) < MAX_MAINTENANCE_TIME)) {
+			read_unlock(&rps_flow_rwlock);
+			return p_rps_flow_info;
+		}
+	}
+	read_unlock(&rps_flow_rwlock);
+	return NULL;
+}
+
 static int get_rps_cpu(struct net_device *dev, struct sk_buff *skb,
 		       struct rps_dev_flow **rflowp)
 {
@@ -4465,6 +4601,57 @@ static int get_rps_cpu(struct net_device *dev, struct sk_buff *skb,
 		goto done;
 
 	skb_reset_network_header(skb);
+	/* this is to set rps for single flow */
+	if (unlikely(rxqueue->rps_single_flow_enable)) {
+		/* clean the old node */
+		rps_flow_node_aging_period();
+
+		/* no rps ,skip it*/
+		if (!map)
+			goto orgin_rps;
+
+		/* skip vlan first  */
+		if (skb_vlan_tag_present(skb))
+			goto done;
+
+		switch (skb->protocol) {
+		/*  ipv4  */
+		case htons(ETH_P_IP): {
+			const struct iphdr *iph;
+			struct rps_flow_info_node *p_flow;
+
+			iph = (struct iphdr *)skb_network_header(skb);
+			/* hash map to match the src and dest ipaddr */
+			p_flow = rps_flow_find_vailed_node(iph->saddr, iph->daddr, iph->protocol);
+			/* check if vailed */
+			if (p_flow) {
+				pr_debug("single flow rps,flow info: saddr = %pI4, daddr =%pI4, proto=%d\n",
+						&p_flow->saddr,
+						&p_flow->daddr,
+						p_flow->protocol);
+			} else {
+				goto orgin_rps;
+			}
+		}
+		break;
+		/* to do, ipv6 */
+		default:
+			goto orgin_rps;
+
+		}
+
+		/* get the target cpu */
+		u32 hash_single_flow = rps_flow_hash_update();
+
+		tcpu = map->cpus[hash_single_flow % map->len];
+		if (cpu_online(tcpu)) {
+			cpu = tcpu;
+			pr_debug("single flow rps, target cpuid = %d\n", cpu);
+			return cpu;
+		}
+	}
+
+orgin_rps:
 	hash = skb_get_hash(skb);
 	if (!hash)
 		goto done;
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index e319e242dddf..c72ce20081e8 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -978,6 +978,41 @@ static ssize_t store_rps_dev_flow_table_cnt(struct netdev_rx_queue *queue,
 	return len;
 }
 
+static ssize_t show_rps_single_flow(struct netdev_rx_queue *queue, char *buf)
+{
+	unsigned long val = 0;
+
+	val = queue->rps_single_flow_enable;
+	return sprintf(buf, "%lu\n", val);
+}
+
+static ssize_t store_rps_single_flow(struct netdev_rx_queue *queue, const char *buf, size_t len)
+{
+	int rc;
+	unsigned long enable;
+	bool rps_single_flow_enable = false;
+
+	if (!capable(CAP_NET_ADMIN))
+		return -EPERM;
+
+	rc = kstrtoul(buf, 0, &enable);
+	if (rc < 0)
+		return rc;
+
+	rps_single_flow_enable = !!enable;
+
+	/* if changed, store the new one */
+	if (rps_single_flow_enable != queue->rps_single_flow_enable) {
+		queue->rps_single_flow_enable = rps_single_flow_enable;
+		rps_single_flow_set(rps_single_flow_enable);
+	}
+
+	return len;
+}
+
+static struct rx_queue_attribute rps_single_flow_attribute  __ro_after_init
+	= __ATTR(rps_single_flow, 0644, show_rps_single_flow, store_rps_single_flow);
+
 static struct rx_queue_attribute rps_cpus_attribute __ro_after_init
 	= __ATTR(rps_cpus, 0644, show_rps_map, store_rps_map);
 
@@ -988,6 +1023,7 @@ static struct rx_queue_attribute rps_dev_flow_table_cnt_attribute __ro_after_ini
 
 static struct attribute *rx_queue_default_attrs[] __ro_after_init = {
 #ifdef CONFIG_RPS
+	&rps_single_flow_attribute.attr,
 	&rps_cpus_attribute.attr,
 	&rps_dev_flow_table_cnt_attribute.attr,
 #endif
-- 
2.31.1

