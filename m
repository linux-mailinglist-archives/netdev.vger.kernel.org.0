Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF819117840
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 22:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbfLIVSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 16:18:51 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:45368 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726354AbfLIVSu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 16:18:50 -0500
Received: by mail-qt1-f195.google.com with SMTP id p5so570539qtq.12
        for <netdev@vger.kernel.org>; Mon, 09 Dec 2019 13:18:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lgqPv0K2Xn5itSPSBjrTChpwTD1HHRyxz08XfPrZ6E0=;
        b=WFBLNOf//G4qmT7LqCgUcqv7bDJvLQ2ouO9u05KRNSkTiBr6cY31ZeZA/vbjioZ7L3
         w4GKLIPRrzIpOpaFI9Ft1KmDGmPqhScSc/TSxxM8dMG4GmQevqysXAj4DvGzN7ZVCHry
         wMbykeaGA3SZO1Rwjnbcset3vybEJZaif3v4LTPqjRDTYM28qhSKh86gVlkbLZpEBJ0j
         Z0Pt4AL7XN8NlJlxZLcjSjF6lbJ/IecpIPDzmC9ME+qLW7NobtQ00xWuodDSrUzWZgWe
         RHv8WiURKBI8uK1GK9KCt/NXPOrnRmdlSiI0UGklS5/oGUivzD80SNGe8mAoErfVFi7V
         RtfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lgqPv0K2Xn5itSPSBjrTChpwTD1HHRyxz08XfPrZ6E0=;
        b=GaLRy5kjbFIdjL8S+ULk2xuvrVA5yP1CDpTZ0BAseWAG0Hrg3pU/k4HB6YfeN7GJj2
         c7+jszB/WbqoBa4/aStsEkvXyi6/DpjIKkSKvw9z4S1gIBk3Lcup3KamE+qNBnkpvYH2
         V6CSdQ//VNslOADKE1VBxmMUYGNHGIOp2cEwO0NzhOeolYWpI2WZsWMe7WfSW/AmFkcI
         lP/vETLpeqpARjXTPfuzx59yvtmx4D5d7zFEALW/M5HxJvEeOBfmSiwRcTuuGQb1Zl+p
         +29aVF6oLII4jJkB1F30zv0wS2wyy5RBGI+YeuJAMw+8RStIIMtVAE4qGxWTF1aLCgVV
         ajvw==
X-Gm-Message-State: APjAAAXKl2AlQtw5Tt+wd7KZMfa1p+J5JsNHe/HrY1iDAzbbMHGgkDhh
        utgY6cBqNciqzdY+wDvIfvv6MTsl
X-Google-Smtp-Source: APXvYqwRsVfsCTOaNJD7l9gAJkLjEboFRw3l+1+twjDyb3193CP0FcIwV6fQL7nEULXf7mTucC+xvA==
X-Received: by 2002:aed:33a3:: with SMTP id v32mr27235232qtd.269.1575926328921;
        Mon, 09 Dec 2019 13:18:48 -0800 (PST)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id w29sm316779qtc.72.2019.12.09.13.18.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 13:18:48 -0800 (PST)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next] net: bridge: add STP xstats
Date:   Mon,  9 Dec 2019 16:18:40 -0500
Message-Id: <20191209211841.1239497-1-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds rx_bpdu, tx_bpdu, rx_tcn, tx_tcn, transition_blk,
transition_fwd xstats counters to the bridge ports copied over via
netlink, providing useful information for STP.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 include/uapi/linux/if_bridge.h | 10 ++++++++++
 net/bridge/br_if.c             |  8 ++++++++
 net/bridge/br_netlink.c        |  9 +++++++++
 net/bridge/br_private.h        |  9 +++++++++
 net/bridge/br_stp.c            | 25 +++++++++++++++++++++++++
 net/bridge/br_stp_bpdu.c       | 12 ++++++++++++
 net/bridge/br_stp_if.c         | 27 +++++++++++++++++++++++++++
 7 files changed, 100 insertions(+)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index 1b3c2b643a02..e7f2bb782006 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -156,6 +156,15 @@ struct bridge_vlan_xstats {
 	__u32 pad2;
 };
 
+struct bridge_stp_xstats {
+	__u64 transition_blk;
+	__u64 transition_fwd;
+	__u64 rx_bpdu;
+	__u64 tx_bpdu;
+	__u64 rx_tcn;
+	__u64 tx_tcn;
+};
+
 /* Bridge multicast database attributes
  * [MDBA_MDB] = {
  *     [MDBA_MDB_ENTRY] = {
@@ -261,6 +270,7 @@ enum {
 	BRIDGE_XSTATS_UNSPEC,
 	BRIDGE_XSTATS_VLAN,
 	BRIDGE_XSTATS_MCAST,
+	BRIDGE_XSTATS_STP,
 	BRIDGE_XSTATS_PAD,
 	__BRIDGE_XSTATS_MAX
 };
diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index 4fe30b182ee7..3eb214ef9763 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -250,6 +250,7 @@ static void release_nbp(struct kobject *kobj)
 {
 	struct net_bridge_port *p
 		= container_of(kobj, struct net_bridge_port, kobj);
+	free_percpu(p->stp_stats);
 	kfree(p);
 }
 
@@ -419,6 +420,12 @@ static struct net_bridge_port *new_nbp(struct net_bridge *br,
 	if (p == NULL)
 		return ERR_PTR(-ENOMEM);
 
+	p->stp_stats = netdev_alloc_pcpu_stats(struct br_stp_stats);
+	if (!p->stp_stats) {
+		kfree(p);
+		return ERR_PTR(-ENOMEM);
+	}
+
 	p->br = br;
 	dev_hold(dev);
 	p->dev = dev;
@@ -432,6 +439,7 @@ static struct net_bridge_port *new_nbp(struct net_bridge *br,
 	err = br_multicast_add_port(p);
 	if (err) {
 		dev_put(dev);
+		free_percpu(p->stp_stats);
 		kfree(p);
 		p = ERR_PTR(err);
 	}
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index a0a54482aabc..03aced1f862b 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -1597,6 +1597,15 @@ static int br_fill_linkxstats(struct sk_buff *skb,
 		}
 	}
 
+	if (p) {
+		struct bridge_stp_xstats xstats;
+
+		br_stp_get_xstats(p, &xstats);
+
+		if (nla_put(skb, BRIDGE_XSTATS_STP, sizeof(xstats), &xstats))
+			goto nla_put_failure;
+	}
+
 #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
 	if (++vl_idx >= *prividx) {
 		nla = nla_reserve_64bit(skb, BRIDGE_XSTATS_MCAST,
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 36b0367ca1e0..af5f28f0f2ef 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -95,6 +95,11 @@ struct br_vlan_stats {
 	struct u64_stats_sync syncp;
 };
 
+struct br_stp_stats {
+	struct bridge_stp_xstats xstats;
+	struct u64_stats_sync syncp;
+};
+
 struct br_tunnel_info {
 	__be64			tunnel_id;
 	struct metadata_dst	*tunnel_dst;
@@ -283,6 +288,8 @@ struct net_bridge_port {
 #endif
 	u16				group_fwd_mask;
 	u16				backup_redirected_cnt;
+
+	struct br_stp_stats		__percpu *stp_stats;
 };
 
 #define kobj_to_brport(obj)	container_of(obj, struct net_bridge_port, kobj)
@@ -1146,6 +1153,8 @@ void br_stp_change_bridge_id(struct net_bridge *br, const unsigned char *a);
 void br_stp_set_bridge_priority(struct net_bridge *br, u16 newprio);
 int br_stp_set_port_priority(struct net_bridge_port *p, unsigned long newprio);
 int br_stp_set_path_cost(struct net_bridge_port *p, unsigned long path_cost);
+void br_stp_get_xstats(const struct net_bridge_port *p,
+		       struct bridge_stp_xstats *xstats);
 ssize_t br_show_bridge_id(char *buf, const struct bridge_id *id);
 
 /* br_stp_bpdu.c */
diff --git a/net/bridge/br_stp.c b/net/bridge/br_stp.c
index 1f1410f8d312..8bcdab29442d 100644
--- a/net/bridge/br_stp.c
+++ b/net/bridge/br_stp.c
@@ -45,6 +45,18 @@ void br_set_state(struct net_bridge_port *p, unsigned int state)
 		br_info(p->br, "port %u(%s) entered %s state\n",
 				(unsigned int) p->port_no, p->dev->name,
 				br_port_state_names[p->state]);
+
+	if (p->br->stp_enabled == BR_KERNEL_STP) {
+		struct br_stp_stats *stats;
+
+		stats = this_cpu_ptr(p->stp_stats);
+		u64_stats_update_begin(&stats->syncp);
+		if (p->state == BR_STATE_BLOCKING)
+			stats->xstats.transition_blk++;
+		else if (p->state == BR_STATE_FORWARDING)
+			stats->xstats.transition_fwd++;
+		u64_stats_update_end(&stats->syncp);
+	}
 }
 
 /* called under bridge lock */
@@ -481,9 +493,15 @@ static void br_topology_change_acknowledge(struct net_bridge_port *p)
 void br_received_config_bpdu(struct net_bridge_port *p,
 			     const struct br_config_bpdu *bpdu)
 {
+	struct br_stp_stats *stats;
 	struct net_bridge *br;
 	int was_root;
 
+	stats = this_cpu_ptr(p->stp_stats);
+	u64_stats_update_begin(&stats->syncp);
+	stats->xstats.rx_bpdu++;
+	u64_stats_update_end(&stats->syncp);
+
 	br = p->br;
 	was_root = br_is_root_bridge(br);
 
@@ -517,6 +535,13 @@ void br_received_config_bpdu(struct net_bridge_port *p,
 /* called under bridge lock */
 void br_received_tcn_bpdu(struct net_bridge_port *p)
 {
+	struct br_stp_stats *stats;
+
+	stats = this_cpu_ptr(p->stp_stats);
+	u64_stats_update_begin(&stats->syncp);
+	stats->xstats.rx_tcn++;
+	u64_stats_update_end(&stats->syncp);
+
 	if (br_is_designated_port(p)) {
 		br_info(p->br, "port %u(%s) received tcn bpdu\n",
 			(unsigned int) p->port_no, p->dev->name);
diff --git a/net/bridge/br_stp_bpdu.c b/net/bridge/br_stp_bpdu.c
index 7796dd9d42d7..2dbd11e21f2a 100644
--- a/net/bridge/br_stp_bpdu.c
+++ b/net/bridge/br_stp_bpdu.c
@@ -78,6 +78,7 @@ static inline int br_get_ticks(const unsigned char *src)
 /* called under bridge lock */
 void br_send_config_bpdu(struct net_bridge_port *p, struct br_config_bpdu *bpdu)
 {
+	struct br_stp_stats *stats;
 	unsigned char buf[35];
 
 	if (p->br->stp_enabled != BR_KERNEL_STP)
@@ -118,11 +119,17 @@ void br_send_config_bpdu(struct net_bridge_port *p, struct br_config_bpdu *bpdu)
 	br_set_ticks(buf+33, bpdu->forward_delay);
 
 	br_send_bpdu(p, buf, 35);
+
+	stats = this_cpu_ptr(p->stp_stats);
+	u64_stats_update_begin(&stats->syncp);
+	stats->xstats.tx_bpdu++;
+	u64_stats_update_end(&stats->syncp);
 }
 
 /* called under bridge lock */
 void br_send_tcn_bpdu(struct net_bridge_port *p)
 {
+	struct br_stp_stats *stats;
 	unsigned char buf[4];
 
 	if (p->br->stp_enabled != BR_KERNEL_STP)
@@ -133,6 +140,11 @@ void br_send_tcn_bpdu(struct net_bridge_port *p)
 	buf[2] = 0;
 	buf[3] = BPDU_TYPE_TCN;
 	br_send_bpdu(p, buf, 4);
+
+	stats = this_cpu_ptr(p->stp_stats);
+	u64_stats_update_begin(&stats->syncp);
+	stats->xstats.tx_tcn++;
+	u64_stats_update_end(&stats->syncp);
 }
 
 /*
diff --git a/net/bridge/br_stp_if.c b/net/bridge/br_stp_if.c
index d174d3a566aa..cbce7d0e40b9 100644
--- a/net/bridge/br_stp_if.c
+++ b/net/bridge/br_stp_if.c
@@ -333,6 +333,33 @@ int br_stp_set_path_cost(struct net_bridge_port *p, unsigned long path_cost)
 	return 0;
 }
 
+void br_stp_get_xstats(const struct net_bridge_port *p,
+		       struct bridge_stp_xstats *xstats)
+{
+	int i;
+
+	memset(xstats, 0, sizeof(*xstats));
+
+	for_each_possible_cpu(i) {
+		struct bridge_stp_xstats cpu_xstats;
+		struct br_stp_stats *stats;
+		unsigned int start;
+
+		stats = per_cpu_ptr(p->stp_stats, i);
+		do {
+			start = u64_stats_fetch_begin_irq(&stats->syncp);
+			memcpy(&cpu_xstats, &stats->xstats, sizeof(cpu_xstats));
+		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
+
+		xstats->transition_blk += cpu_xstats.transition_blk;
+		xstats->transition_fwd += cpu_xstats.transition_fwd;
+		xstats->rx_bpdu += cpu_xstats.rx_bpdu;
+		xstats->tx_bpdu += cpu_xstats.tx_bpdu;
+		xstats->rx_tcn += cpu_xstats.rx_tcn;
+		xstats->tx_tcn += cpu_xstats.tx_tcn;
+	}
+}
+
 ssize_t br_show_bridge_id(char *buf, const struct bridge_id *id)
 {
 	return sprintf(buf, "%.2x%.2x.%.2x%.2x%.2x%.2x%.2x%.2x\n",
-- 
2.24.0

