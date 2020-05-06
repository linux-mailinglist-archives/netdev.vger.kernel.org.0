Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 420AF1C7674
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 18:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730361AbgEFQb1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 12:31:27 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:46334 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729980AbgEFQam (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 12:30:42 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 046GUanM025565;
        Wed, 6 May 2020 11:30:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1588782636;
        bh=XBbAdSs+7w2F8cv39wmxyojU1UOwbXJcZeUOhLfMjE0=;
        h=From:To:Subject:Date:In-Reply-To:References;
        b=n3/WAlFNCfD6POhD/w7U8g3c7KdTiLuOc4HF3l4OIb6wnAAUd47KQKgkNMm6mXXwb
         fZU9ZJCdb7rpUwlDLOZG9t60hze1bDdG8t77Hn2H0Gj13uOgfhWcOl1dijEEQFBMsc
         R8QehELu0hAchcV+0UDJBNpKxilRtPBhNzVG9nKc=
Received: from DLEE114.ent.ti.com (dlee114.ent.ti.com [157.170.170.25])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 046GUaUn021901
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 6 May 2020 11:30:36 -0500
Received: from DLEE104.ent.ti.com (157.170.170.34) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 6 May
 2020 11:30:36 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 6 May 2020 11:30:36 -0500
Received: from uda0868495.fios-router.home (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 046GUXDh119719;
        Wed, 6 May 2020 11:30:35 -0500
From:   Murali Karicheri <m-karicheri2@ti.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        <nsekhar@ti.com>, <grygorii.strashko@ti.com>
Subject: [net-next RFC PATCH 04/13] net: hsr: rename hsr variable inside struct hsr_port to priv
Date:   Wed, 6 May 2020 12:30:24 -0400
Message-ID: <20200506163033.3843-5-m-karicheri2@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200506163033.3843-1-m-karicheri2@ti.com>
References: <20200506163033.3843-1-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The struct hsr_port has a variable pointing to the private struct
of the driver. This should have been named priv instead of hsr
to be clean. This would be needed as it is planned to re-use the
code for prp and then priv variable is more appropriate than hsr.
So fix it by search and replace of all instances within the driver.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
 net/hsr-prp/hsr_netlink.c      |  36 ++++-----
 net/hsr-prp/hsr_prp_device.c   | 144 ++++++++++++++++-----------------
 net/hsr-prp/hsr_prp_device.h   |   4 +-
 net/hsr-prp/hsr_prp_forward.c  |  24 +++---
 net/hsr-prp/hsr_prp_framereg.c |  91 ++++++++++-----------
 net/hsr-prp/hsr_prp_framereg.h |  10 +--
 net/hsr-prp/hsr_prp_main.c     |  32 ++++----
 net/hsr-prp/hsr_prp_main.h     |   8 +-
 net/hsr-prp/hsr_prp_slave.c    |  28 +++----
 net/hsr-prp/hsr_prp_slave.h    |   2 +-
 10 files changed, 190 insertions(+), 189 deletions(-)

diff --git a/net/hsr-prp/hsr_netlink.c b/net/hsr-prp/hsr_netlink.c
index 9791d4d89aef..9e3f6eda69f5 100644
--- a/net/hsr-prp/hsr_netlink.c
+++ b/net/hsr-prp/hsr_netlink.c
@@ -85,24 +85,24 @@ static int hsr_newlink(struct net *src_net, struct net_device *dev,
 
 static int hsr_fill_info(struct sk_buff *skb, const struct net_device *dev)
 {
-	struct hsr_priv *hsr = netdev_priv(dev);
+	struct hsr_priv *priv = netdev_priv(dev);
 	struct hsr_port *port;
 
-	port = hsr_port_get_hsr(hsr, HSR_PT_SLAVE_A);
+	port = hsr_port_get_hsr(priv, HSR_PT_SLAVE_A);
 	if (port) {
 		if (nla_put_u32(skb, IFLA_HSR_SLAVE1, port->dev->ifindex))
 			goto nla_put_failure;
 	}
 
-	port = hsr_port_get_hsr(hsr, HSR_PT_SLAVE_B);
+	port = hsr_port_get_hsr(priv, HSR_PT_SLAVE_B);
 	if (port) {
 		if (nla_put_u32(skb, IFLA_HSR_SLAVE2, port->dev->ifindex))
 			goto nla_put_failure;
 	}
 
 	if (nla_put(skb, IFLA_HSR_SUPERVISION_ADDR, ETH_ALEN,
-		    hsr->sup_multicast_addr) ||
-	    nla_put_u16(skb, IFLA_HSR_SEQ_NR, hsr->sequence_nr))
+		    priv->sup_multicast_addr) ||
+	    nla_put_u16(skb, IFLA_HSR_SEQ_NR, priv->sequence_nr))
 		goto nla_put_failure;
 
 	return 0;
@@ -142,7 +142,7 @@ static const struct genl_multicast_group hsr_mcgrps[] = {
  * over one of the slave interfaces. This would indicate an open network ring
  * (i.e. a link has failed somewhere).
  */
-void hsr_nl_ringerror(struct hsr_priv *hsr, unsigned char addr[ETH_ALEN],
+void hsr_nl_ringerror(struct hsr_priv *priv, unsigned char addr[ETH_ALEN],
 		      struct hsr_port *port)
 {
 	struct sk_buff *skb;
@@ -177,7 +177,7 @@ void hsr_nl_ringerror(struct hsr_priv *hsr, unsigned char addr[ETH_ALEN],
 
 fail:
 	rcu_read_lock();
-	master = hsr_port_get_hsr(hsr, HSR_PT_MASTER);
+	master = hsr_port_get_hsr(priv, HSR_PT_MASTER);
 	netdev_warn(master->dev, "Could not send HSR ring error message\n");
 	rcu_read_unlock();
 }
@@ -185,7 +185,7 @@ void hsr_nl_ringerror(struct hsr_priv *hsr, unsigned char addr[ETH_ALEN],
 /* This is called when we haven't heard from the node with MAC address addr for
  * some time (just before the node is removed from the node table/list).
  */
-void hsr_nl_nodedown(struct hsr_priv *hsr, unsigned char addr[ETH_ALEN])
+void hsr_nl_nodedown(struct hsr_priv *priv, unsigned char addr[ETH_ALEN])
 {
 	struct sk_buff *skb;
 	void *msg_head;
@@ -214,7 +214,7 @@ void hsr_nl_nodedown(struct hsr_priv *hsr, unsigned char addr[ETH_ALEN])
 
 fail:
 	rcu_read_lock();
-	master = hsr_port_get_hsr(hsr, HSR_PT_MASTER);
+	master = hsr_port_get_hsr(priv, HSR_PT_MASTER);
 	netdev_warn(master->dev, "Could not send HSR node down\n");
 	rcu_read_unlock();
 }
@@ -236,7 +236,7 @@ static int hsr_get_node_status(struct sk_buff *skb_in, struct genl_info *info)
 	/* For sending */
 	struct sk_buff *skb_out;
 	void *msg_head;
-	struct hsr_priv *hsr;
+	struct hsr_priv *priv;
 	struct hsr_port *port;
 	unsigned char hsr_node_addr_b[ETH_ALEN];
 	int hsr_node_if1_age;
@@ -283,8 +283,8 @@ static int hsr_get_node_status(struct sk_buff *skb_in, struct genl_info *info)
 	if (res < 0)
 		goto nla_put_failure;
 
-	hsr = netdev_priv(hsr_dev);
-	res = hsr_get_node_data(hsr,
+	priv = netdev_priv(hsr_dev);
+	res = hsr_get_node_data(priv,
 				(unsigned char *)
 				nla_data(info->attrs[HSR_A_NODE_ADDR]),
 					 hsr_node_addr_b,
@@ -319,7 +319,7 @@ static int hsr_get_node_status(struct sk_buff *skb_in, struct genl_info *info)
 	res = nla_put_u16(skb_out, HSR_A_IF1_SEQ, hsr_node_if1_seq);
 	if (res < 0)
 		goto nla_put_failure;
-	port = hsr_port_get_hsr(hsr, HSR_PT_SLAVE_A);
+	port = hsr_port_get_hsr(priv, HSR_PT_SLAVE_A);
 	if (port)
 		res = nla_put_u32(skb_out, HSR_A_IF1_IFINDEX,
 				  port->dev->ifindex);
@@ -332,7 +332,7 @@ static int hsr_get_node_status(struct sk_buff *skb_in, struct genl_info *info)
 	res = nla_put_u16(skb_out, HSR_A_IF2_SEQ, hsr_node_if2_seq);
 	if (res < 0)
 		goto nla_put_failure;
-	port = hsr_port_get_hsr(hsr, HSR_PT_SLAVE_B);
+	port = hsr_port_get_hsr(priv, HSR_PT_SLAVE_B);
 	if (port)
 		res = nla_put_u32(skb_out, HSR_A_IF2_IFINDEX,
 				  port->dev->ifindex);
@@ -368,7 +368,7 @@ static int hsr_get_node_list(struct sk_buff *skb_in, struct genl_info *info)
 	unsigned char addr[ETH_ALEN];
 	struct net_device *hsr_dev;
 	struct sk_buff *skb_out;
-	struct hsr_priv *hsr;
+	struct hsr_priv *priv;
 	bool restart = false;
 	struct nlattr *na;
 	void *pos = NULL;
@@ -412,10 +412,10 @@ static int hsr_get_node_list(struct sk_buff *skb_in, struct genl_info *info)
 			goto nla_put_failure;
 	}
 
-	hsr = netdev_priv(hsr_dev);
+	priv = netdev_priv(hsr_dev);
 
 	if (!pos)
-		pos = hsr_get_next_node(hsr, NULL, addr);
+		pos = hsr_get_next_node(priv, NULL, addr);
 	while (pos) {
 		res = nla_put(skb_out, HSR_A_NODE_ADDR, ETH_ALEN, addr);
 		if (res < 0) {
@@ -428,7 +428,7 @@ static int hsr_get_node_list(struct sk_buff *skb_in, struct genl_info *info)
 			}
 			goto nla_put_failure;
 		}
-		pos = hsr_get_next_node(hsr, pos, addr);
+		pos = hsr_get_next_node(priv, pos, addr);
 	}
 	rcu_read_unlock();
 
diff --git a/net/hsr-prp/hsr_prp_device.c b/net/hsr-prp/hsr_prp_device.c
index ed50022849cb..df85b8f7f007 100644
--- a/net/hsr-prp/hsr_prp_device.c
+++ b/net/hsr-prp/hsr_prp_device.c
@@ -60,7 +60,7 @@ static bool hsr_check_carrier(struct hsr_port *master)
 
 	ASSERT_RTNL();
 
-	hsr_for_each_port(master->hsr, port) {
+	hsr_for_each_port(master->priv, port) {
 		if (port->type != HSR_PT_MASTER && is_slave_up(port->dev)) {
 			netif_carrier_on(master->dev);
 			return true;
@@ -75,29 +75,29 @@ static bool hsr_check_carrier(struct hsr_port *master)
 static void hsr_check_announce(struct net_device *hsr_dev,
 			       unsigned char old_operstate)
 {
-	struct hsr_priv *hsr;
+	struct hsr_priv *priv;
 
-	hsr = netdev_priv(hsr_dev);
+	priv = netdev_priv(hsr_dev);
 
 	if (hsr_dev->operstate == IF_OPER_UP && old_operstate != IF_OPER_UP) {
 		/* Went up */
-		hsr->announce_count = 0;
-		mod_timer(&hsr->announce_timer,
+		priv->announce_count = 0;
+		mod_timer(&priv->announce_timer,
 			  jiffies + msecs_to_jiffies(HSR_ANNOUNCE_INTERVAL));
 	}
 
 	if (hsr_dev->operstate != IF_OPER_UP && old_operstate == IF_OPER_UP)
 		/* Went down */
-		del_timer(&hsr->announce_timer);
+		del_timer(&priv->announce_timer);
 }
 
-void hsr_check_carrier_and_operstate(struct hsr_priv *hsr)
+void hsr_check_carrier_and_operstate(struct hsr_priv *priv)
 {
 	struct hsr_port *master;
 	unsigned char old_operstate;
 	bool has_carrier;
 
-	master = hsr_port_get_hsr(hsr, HSR_PT_MASTER);
+	master = hsr_port_get_hsr(priv, HSR_PT_MASTER);
 	/* netif_stacked_transfer_operstate() cannot be used here since
 	 * it doesn't set IF_OPER_LOWERLAYERDOWN (?)
 	 */
@@ -107,13 +107,13 @@ void hsr_check_carrier_and_operstate(struct hsr_priv *hsr)
 	hsr_check_announce(master->dev, old_operstate);
 }
 
-int hsr_get_max_mtu(struct hsr_priv *hsr)
+int hsr_get_max_mtu(struct hsr_priv *priv)
 {
 	unsigned int mtu_max;
 	struct hsr_port *port;
 
 	mtu_max = ETH_DATA_LEN;
-	hsr_for_each_port(hsr, port)
+	hsr_for_each_port(priv, port)
 		if (port->type != HSR_PT_MASTER)
 			mtu_max = min(port->dev->mtu, mtu_max);
 
@@ -124,11 +124,11 @@ int hsr_get_max_mtu(struct hsr_priv *hsr)
 
 static int hsr_dev_change_mtu(struct net_device *dev, int new_mtu)
 {
-	struct hsr_priv *hsr;
+	struct hsr_priv *priv;
 
-	hsr = netdev_priv(dev);
+	priv = netdev_priv(dev);
 
-	if (new_mtu > hsr_get_max_mtu(hsr)) {
+	if (new_mtu > hsr_get_max_mtu(priv)) {
 		netdev_info(dev, "A HSR master's MTU cannot be greater than the smallest MTU of its slaves minus the HSR Tag length (%d octets).\n",
 			    HSR_HLEN);
 		return -EINVAL;
@@ -141,14 +141,14 @@ static int hsr_dev_change_mtu(struct net_device *dev, int new_mtu)
 
 static int hsr_dev_open(struct net_device *dev)
 {
-	struct hsr_priv *hsr;
+	struct hsr_priv *priv;
 	struct hsr_port *port;
 	char designation;
 
-	hsr = netdev_priv(dev);
+	priv = netdev_priv(dev);
 	designation = '\0';
 
-	hsr_for_each_port(hsr, port) {
+	hsr_for_each_port(priv, port) {
 		if (port->type == HSR_PT_MASTER)
 			continue;
 		switch (port->type) {
@@ -178,7 +178,7 @@ static int hsr_dev_close(struct net_device *dev)
 	return 0;
 }
 
-static netdev_features_t hsr_features_recompute(struct hsr_priv *hsr,
+static netdev_features_t hsr_features_recompute(struct hsr_priv *priv,
 						netdev_features_t features)
 {
 	netdev_features_t mask;
@@ -194,7 +194,7 @@ static netdev_features_t hsr_features_recompute(struct hsr_priv *hsr,
 	 * may become enabled.
 	 */
 	features &= ~NETIF_F_ONE_FOR_ALL;
-	hsr_for_each_port(hsr, port)
+	hsr_for_each_port(priv, port)
 		features = netdev_increment_features(features,
 						     port->dev->features,
 						     mask);
@@ -205,17 +205,17 @@ static netdev_features_t hsr_features_recompute(struct hsr_priv *hsr,
 static netdev_features_t hsr_fix_features(struct net_device *dev,
 					  netdev_features_t features)
 {
-	struct hsr_priv *hsr = netdev_priv(dev);
+	struct hsr_priv *priv = netdev_priv(dev);
 
-	return hsr_features_recompute(hsr, features);
+	return hsr_features_recompute(priv, features);
 }
 
 static int hsr_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 {
-	struct hsr_priv *hsr = netdev_priv(dev);
+	struct hsr_priv *priv = netdev_priv(dev);
 	struct hsr_port *master;
 
-	master = hsr_port_get_hsr(hsr, HSR_PT_MASTER);
+	master = hsr_port_get_hsr(priv, HSR_PT_MASTER);
 	if (master) {
 		skb->dev = master->dev;
 		hsr_forward_skb(skb, master);
@@ -257,7 +257,7 @@ static void send_hsr_supervision_frame(struct hsr_port *master,
 	skb->priority = TC_PRIO_CONTROL;
 
 	if (dev_hard_header(skb, skb->dev, (hsr_ver ? ETH_P_HSR : ETH_P_PRP),
-			    master->hsr->sup_multicast_addr,
+			    master->priv->sup_multicast_addr,
 			    skb->dev->dev_addr, skb->len) <= 0)
 		goto out;
 	skb_reset_mac_header(skb);
@@ -275,17 +275,17 @@ static void send_hsr_supervision_frame(struct hsr_port *master,
 	set_hsr_stag_HSR_ver(hsr_stag, hsr_ver);
 
 	/* From HSRv1 on we have separate supervision sequence numbers. */
-	spin_lock_irqsave(&master->hsr->seqnr_lock, irqflags);
+	spin_lock_irqsave(&master->priv->seqnr_lock, irqflags);
 	if (hsr_ver > 0) {
-		hsr_stag->sequence_nr = htons(master->hsr->sup_sequence_nr);
-		hsr_tag->sequence_nr = htons(master->hsr->sequence_nr);
-		master->hsr->sup_sequence_nr++;
-		master->hsr->sequence_nr++;
+		hsr_stag->sequence_nr = htons(master->priv->sup_sequence_nr);
+		hsr_tag->sequence_nr = htons(master->priv->sequence_nr);
+		master->priv->sup_sequence_nr++;
+		master->priv->sequence_nr++;
 	} else {
-		hsr_stag->sequence_nr = htons(master->hsr->sequence_nr);
-		master->hsr->sequence_nr++;
+		hsr_stag->sequence_nr = htons(master->priv->sequence_nr);
+		master->priv->sequence_nr++;
 	}
-	spin_unlock_irqrestore(&master->hsr->seqnr_lock, irqflags);
+	spin_unlock_irqrestore(&master->priv->seqnr_lock, irqflags);
 
 	hsr_stag->HSR_TLV_type = type;
 	/* TODO: Why 12 in HSRv0? */
@@ -311,47 +311,47 @@ static void send_hsr_supervision_frame(struct hsr_port *master,
  */
 static void hsr_announce(struct timer_list *t)
 {
-	struct hsr_priv *hsr;
+	struct hsr_priv *priv;
 	struct hsr_port *master;
 	unsigned long interval;
 
-	hsr = from_timer(hsr, t, announce_timer);
+	priv = from_timer(priv, t, announce_timer);
 
 	rcu_read_lock();
-	master = hsr_port_get_hsr(hsr, HSR_PT_MASTER);
+	master = hsr_port_get_hsr(priv, HSR_PT_MASTER);
 
-	if (hsr->announce_count < 3 && hsr->prot_version == 0) {
+	if (priv->announce_count < 3 && priv->prot_version == 0) {
 		send_hsr_supervision_frame(master, HSR_TLV_ANNOUNCE,
-					   hsr->prot_version);
-		hsr->announce_count++;
+					   priv->prot_version);
+		priv->announce_count++;
 
 		interval = msecs_to_jiffies(HSR_ANNOUNCE_INTERVAL);
 	} else {
 		send_hsr_supervision_frame(master, HSR_TLV_LIFE_CHECK,
-					   hsr->prot_version);
+					   priv->prot_version);
 
 		interval = msecs_to_jiffies(HSR_LIFE_CHECK_INTERVAL);
 	}
 
 	if (is_admin_up(master->dev))
-		mod_timer(&hsr->announce_timer, jiffies + interval);
+		mod_timer(&priv->announce_timer, jiffies + interval);
 
 	rcu_read_unlock();
 }
 
-static void hsr_del_ports(struct hsr_priv *hsr)
+static void hsr_del_ports(struct hsr_priv *priv)
 {
 	struct hsr_port *port;
 
-	port = hsr_port_get_hsr(hsr, HSR_PT_SLAVE_A);
+	port = hsr_port_get_hsr(priv, HSR_PT_SLAVE_A);
 	if (port)
 		hsr_del_port(port);
 
-	port = hsr_port_get_hsr(hsr, HSR_PT_SLAVE_B);
+	port = hsr_port_get_hsr(priv, HSR_PT_SLAVE_B);
 	if (port)
 		hsr_del_port(port);
 
-	port = hsr_port_get_hsr(hsr, HSR_PT_MASTER);
+	port = hsr_port_get_hsr(priv, HSR_PT_MASTER);
 	if (port)
 		hsr_del_port(port);
 }
@@ -362,16 +362,16 @@ static void hsr_del_ports(struct hsr_priv *hsr)
  */
 static void hsr_dev_destroy(struct net_device *hsr_dev)
 {
-	struct hsr_priv *hsr = netdev_priv(hsr_dev);
+	struct hsr_priv *priv = netdev_priv(hsr_dev);
 
-	hsr_debugfs_term(hsr);
-	hsr_del_ports(hsr);
+	hsr_debugfs_term(priv);
+	hsr_del_ports(priv);
 
-	del_timer_sync(&hsr->prune_timer);
-	del_timer_sync(&hsr->announce_timer);
+	del_timer_sync(&priv->prune_timer);
+	del_timer_sync(&priv->announce_timer);
 
-	hsr_del_self_node(hsr);
-	hsr_del_nodes(&hsr->node_db);
+	hsr_del_self_node(priv);
+	hsr_del_nodes(&priv->node_db);
 }
 
 static const struct net_device_ops hsr_device_ops = {
@@ -434,35 +434,35 @@ int hsr_dev_finalize(struct net_device *hsr_dev, struct net_device *slave[2],
 		     unsigned char multicast_spec, u8 protocol_version,
 		     struct netlink_ext_ack *extack)
 {
-	struct hsr_priv *hsr;
+	struct hsr_priv *priv;
 	int res;
 
-	hsr = netdev_priv(hsr_dev);
-	INIT_LIST_HEAD(&hsr->ports);
-	INIT_LIST_HEAD(&hsr->node_db);
-	INIT_LIST_HEAD(&hsr->self_node_db);
-	spin_lock_init(&hsr->list_lock);
+	priv = netdev_priv(hsr_dev);
+	INIT_LIST_HEAD(&priv->ports);
+	INIT_LIST_HEAD(&priv->node_db);
+	INIT_LIST_HEAD(&priv->self_node_db);
+	spin_lock_init(&priv->list_lock);
 
 	ether_addr_copy(hsr_dev->dev_addr, slave[0]->dev_addr);
 
 	/* Make sure we recognize frames from ourselves in hsr_rcv() */
-	res = hsr_create_self_node(hsr, hsr_dev->dev_addr,
+	res = hsr_create_self_node(priv, hsr_dev->dev_addr,
 				   slave[1]->dev_addr);
 	if (res < 0)
 		return res;
 
-	spin_lock_init(&hsr->seqnr_lock);
+	spin_lock_init(&priv->seqnr_lock);
 	/* Overflow soon to find bugs easier: */
-	hsr->sequence_nr = HSR_SEQNR_START;
-	hsr->sup_sequence_nr = HSR_SUP_SEQNR_START;
+	priv->sequence_nr = HSR_SEQNR_START;
+	priv->sup_sequence_nr = HSR_SUP_SEQNR_START;
 
-	timer_setup(&hsr->announce_timer, hsr_announce, 0);
-	timer_setup(&hsr->prune_timer, hsr_prune_nodes, 0);
+	timer_setup(&priv->announce_timer, hsr_announce, 0);
+	timer_setup(&priv->prune_timer, hsr_prune_nodes, 0);
 
-	ether_addr_copy(hsr->sup_multicast_addr, def_multicast_addr);
-	hsr->sup_multicast_addr[ETH_ALEN - 1] = multicast_spec;
+	ether_addr_copy(priv->sup_multicast_addr, def_multicast_addr);
+	priv->sup_multicast_addr[ETH_ALEN - 1] = multicast_spec;
 
-	hsr->prot_version = protocol_version;
+	priv->prot_version = protocol_version;
 
 	/* FIXME: should I modify the value of these?
 	 *
@@ -477,7 +477,7 @@ int hsr_dev_finalize(struct net_device *hsr_dev, struct net_device *slave[2],
 	/* Make sure the 1st call to netif_carrier_on() gets through */
 	netif_carrier_off(hsr_dev);
 
-	res = hsr_add_port(hsr, hsr_dev, HSR_PT_MASTER, extack);
+	res = hsr_add_port(priv, hsr_dev, HSR_PT_MASTER, extack);
 	if (res)
 		goto err_add_master;
 
@@ -485,25 +485,25 @@ int hsr_dev_finalize(struct net_device *hsr_dev, struct net_device *slave[2],
 	if (res)
 		goto err_unregister;
 
-	res = hsr_add_port(hsr, slave[0], HSR_PT_SLAVE_A, extack);
+	res = hsr_add_port(priv, slave[0], HSR_PT_SLAVE_A, extack);
 	if (res)
 		goto err_add_slaves;
 
-	res = hsr_add_port(hsr, slave[1], HSR_PT_SLAVE_B, extack);
+	res = hsr_add_port(priv, slave[1], HSR_PT_SLAVE_B, extack);
 	if (res)
 		goto err_add_slaves;
 
-	hsr_debugfs_init(hsr, hsr_dev);
-	mod_timer(&hsr->prune_timer, jiffies + msecs_to_jiffies(PRUNE_PERIOD));
+	hsr_debugfs_init(priv, hsr_dev);
+	mod_timer(&priv->prune_timer, jiffies + msecs_to_jiffies(PRUNE_PERIOD));
 
 	return 0;
 
 err_add_slaves:
 	unregister_netdevice(hsr_dev);
 err_unregister:
-	hsr_del_ports(hsr);
+	hsr_del_ports(priv);
 err_add_master:
-	hsr_del_self_node(hsr);
+	hsr_del_self_node(priv);
 
 	return res;
 }
diff --git a/net/hsr-prp/hsr_prp_device.h b/net/hsr-prp/hsr_prp_device.h
index 4cf3db603174..91642845cdd2 100644
--- a/net/hsr-prp/hsr_prp_device.h
+++ b/net/hsr-prp/hsr_prp_device.h
@@ -15,8 +15,8 @@ void hsr_dev_setup(struct net_device *dev);
 int hsr_dev_finalize(struct net_device *hsr_dev, struct net_device *slave[2],
 		     unsigned char multicast_spec, u8 protocol_version,
 		     struct netlink_ext_ack *extack);
-void hsr_check_carrier_and_operstate(struct hsr_priv *hsr);
+void hsr_check_carrier_and_operstate(struct hsr_priv *priv);
 bool is_hsr_master(struct net_device *dev);
-int hsr_get_max_mtu(struct hsr_priv *hsr);
+int hsr_get_max_mtu(struct hsr_priv *priv);
 
 #endif /* __HSR_DEVICE_H */
diff --git a/net/hsr-prp/hsr_prp_forward.c b/net/hsr-prp/hsr_prp_forward.c
index 5ff0efba5db5..2b6abb09fe4b 100644
--- a/net/hsr-prp/hsr_prp_forward.c
+++ b/net/hsr-prp/hsr_prp_forward.c
@@ -42,7 +42,7 @@ struct hsr_frame_info {
  * 3) Allow different MAC addresses for the two slave interfaces, using the
  *    MacAddressA field.
  */
-static bool is_supervision_frame(struct hsr_priv *hsr, struct sk_buff *skb)
+static bool is_supervision_frame(struct hsr_priv *priv, struct sk_buff *skb)
 {
 	struct ethhdr *eth_hdr;
 	struct hsr_sup_tag *hsr_sup_tag;
@@ -53,7 +53,7 @@ static bool is_supervision_frame(struct hsr_priv *hsr, struct sk_buff *skb)
 
 	/* Correct addr? */
 	if (!ether_addr_equal(eth_hdr->h_dest,
-			      hsr->sup_multicast_addr))
+			      priv->sup_multicast_addr))
 		return false;
 
 	/* Correct ether type?. */
@@ -172,7 +172,7 @@ static struct sk_buff *create_tagged_skb(struct sk_buff *skb_o,
 	memmove(dst, src, movelen);
 	skb_reset_mac_header(skb);
 
-	hsr_fill_tag(skb, frame, port, port->hsr->prot_version);
+	hsr_fill_tag(skb, frame, port, port->priv->prot_version);
 
 	return skb;
 }
@@ -244,7 +244,7 @@ static void hsr_forward_do(struct hsr_frame_info *frame)
 	struct hsr_port *port;
 	struct sk_buff *skb;
 
-	hsr_for_each_port(frame->port_rcv->hsr, port) {
+	hsr_for_each_port(frame->port_rcv->priv, port) {
 		/* Don't send frame back the way it came */
 		if (port == frame->port_rcv)
 			continue;
@@ -286,10 +286,10 @@ static void hsr_forward_do(struct hsr_frame_info *frame)
 	}
 }
 
-static void check_local_dest(struct hsr_priv *hsr, struct sk_buff *skb,
+static void check_local_dest(struct hsr_priv *priv, struct sk_buff *skb,
 			     struct hsr_frame_info *frame)
 {
-	if (hsr_addr_is_self(hsr, eth_hdr(skb)->h_dest)) {
+	if (hsr_addr_is_self(priv, eth_hdr(skb)->h_dest)) {
 		frame->is_local_exclusive = true;
 		skb->pkt_type = PACKET_HOST;
 	} else {
@@ -311,7 +311,7 @@ static int hsr_fill_frame_info(struct hsr_frame_info *frame,
 	struct ethhdr *ethhdr;
 	unsigned long irqflags;
 
-	frame->is_supervision = is_supervision_frame(port->hsr, skb);
+	frame->is_supervision = is_supervision_frame(port->priv, skb);
 	frame->node_src = hsr_get_node(port, skb, frame->is_supervision);
 	if (!frame->node_src)
 		return -1; /* Unknown node and !is_supervision, or no mem */
@@ -332,14 +332,14 @@ static int hsr_fill_frame_info(struct hsr_frame_info *frame,
 		frame->skb_std = skb;
 		frame->skb_hsr = NULL;
 		/* Sequence nr for the master node */
-		spin_lock_irqsave(&port->hsr->seqnr_lock, irqflags);
-		frame->sequence_nr = port->hsr->sequence_nr;
-		port->hsr->sequence_nr++;
-		spin_unlock_irqrestore(&port->hsr->seqnr_lock, irqflags);
+		spin_lock_irqsave(&port->priv->seqnr_lock, irqflags);
+		frame->sequence_nr = port->priv->sequence_nr;
+		port->priv->sequence_nr++;
+		spin_unlock_irqrestore(&port->priv->seqnr_lock, irqflags);
 	}
 
 	frame->port_rcv = port;
-	check_local_dest(port->hsr, skb, frame);
+	check_local_dest(port->priv, skb, frame);
 
 	return 0;
 }
diff --git a/net/hsr-prp/hsr_prp_framereg.c b/net/hsr-prp/hsr_prp_framereg.c
index b02a2a0ca0ff..854338352e93 100644
--- a/net/hsr-prp/hsr_prp_framereg.c
+++ b/net/hsr-prp/hsr_prp_framereg.c
@@ -37,11 +37,11 @@ static bool seq_nr_after(u16 a, u16 b)
 #define seq_nr_before(a, b)		seq_nr_after((b), (a))
 #define seq_nr_before_or_eq(a, b)	(!seq_nr_after((a), (b)))
 
-bool hsr_addr_is_self(struct hsr_priv *hsr, unsigned char *addr)
+bool hsr_addr_is_self(struct hsr_priv *priv, unsigned char *addr)
 {
 	struct hsr_node *node;
 
-	node = list_first_or_null_rcu(&hsr->self_node_db, struct hsr_node,
+	node = list_first_or_null_rcu(&priv->self_node_db, struct hsr_node,
 				      mac_list);
 	if (!node) {
 		WARN_ONCE(1, "HSR: No self node\n");
@@ -74,11 +74,11 @@ static struct hsr_node *find_node_by_addr_A(struct list_head *node_db,
 /* Helper for device init; the self_node_db is used in hsr_rcv() to recognize
  * frames from self that's been looped over the HSR ring.
  */
-int hsr_create_self_node(struct hsr_priv *hsr,
+int hsr_create_self_node(struct hsr_priv *priv,
 			 unsigned char addr_a[ETH_ALEN],
 			 unsigned char addr_b[ETH_ALEN])
 {
-	struct list_head *self_node_db = &hsr->self_node_db;
+	struct list_head *self_node_db = &priv->self_node_db;
 	struct hsr_node *node, *oldnode;
 
 	node = kmalloc(sizeof(*node), GFP_KERNEL);
@@ -88,33 +88,33 @@ int hsr_create_self_node(struct hsr_priv *hsr,
 	ether_addr_copy(node->macaddress_A, addr_a);
 	ether_addr_copy(node->macaddress_B, addr_b);
 
-	spin_lock_bh(&hsr->list_lock);
+	spin_lock_bh(&priv->list_lock);
 	oldnode = list_first_or_null_rcu(self_node_db,
 					 struct hsr_node, mac_list);
 	if (oldnode) {
 		list_replace_rcu(&oldnode->mac_list, &node->mac_list);
-		spin_unlock_bh(&hsr->list_lock);
+		spin_unlock_bh(&priv->list_lock);
 		kfree_rcu(oldnode, rcu_head);
 	} else {
 		list_add_tail_rcu(&node->mac_list, self_node_db);
-		spin_unlock_bh(&hsr->list_lock);
+		spin_unlock_bh(&priv->list_lock);
 	}
 
 	return 0;
 }
 
-void hsr_del_self_node(struct hsr_priv *hsr)
+void hsr_del_self_node(struct hsr_priv *priv)
 {
-	struct list_head *self_node_db = &hsr->self_node_db;
+	struct list_head *self_node_db = &priv->self_node_db;
 	struct hsr_node *node;
 
-	spin_lock_bh(&hsr->list_lock);
+	spin_lock_bh(&priv->list_lock);
 	node = list_first_or_null_rcu(self_node_db, struct hsr_node, mac_list);
 	if (node) {
 		list_del_rcu(&node->mac_list);
 		kfree_rcu(node, rcu_head);
 	}
-	spin_unlock_bh(&hsr->list_lock);
+	spin_unlock_bh(&priv->list_lock);
 }
 
 void hsr_del_nodes(struct list_head *node_db)
@@ -130,7 +130,7 @@ void hsr_del_nodes(struct list_head *node_db)
  * seq_out is used to initialize filtering of outgoing duplicate frames
  * originating from the newly added node.
  */
-static struct hsr_node *hsr_add_node(struct hsr_priv *hsr,
+static struct hsr_node *hsr_add_node(struct hsr_priv *priv,
 				     struct list_head *node_db,
 				     unsigned char addr[],
 				     u16 seq_out)
@@ -154,19 +154,19 @@ static struct hsr_node *hsr_add_node(struct hsr_priv *hsr,
 	for (i = 0; i < HSR_PT_PORTS; i++)
 		new_node->seq_out[i] = seq_out;
 
-	spin_lock_bh(&hsr->list_lock);
+	spin_lock_bh(&priv->list_lock);
 	list_for_each_entry_rcu(node, node_db, mac_list,
-				lockdep_is_held(&hsr->list_lock)) {
+				lockdep_is_held(&priv->list_lock)) {
 		if (ether_addr_equal(node->macaddress_A, addr))
 			goto out;
 		if (ether_addr_equal(node->macaddress_B, addr))
 			goto out;
 	}
 	list_add_tail_rcu(&new_node->mac_list, node_db);
-	spin_unlock_bh(&hsr->list_lock);
+	spin_unlock_bh(&priv->list_lock);
 	return new_node;
 out:
-	spin_unlock_bh(&hsr->list_lock);
+	spin_unlock_bh(&priv->list_lock);
 	kfree(new_node);
 	return node;
 }
@@ -176,8 +176,8 @@ static struct hsr_node *hsr_add_node(struct hsr_priv *hsr,
 struct hsr_node *hsr_get_node(struct hsr_port *port, struct sk_buff *skb,
 			      bool is_sup)
 {
-	struct list_head *node_db = &port->hsr->node_db;
-	struct hsr_priv *hsr = port->hsr;
+	struct list_head *node_db = &port->priv->node_db;
+	struct hsr_priv *priv = port->priv;
 	struct hsr_node *node;
 	struct ethhdr *ethhdr;
 	u16 seq_out;
@@ -211,7 +211,7 @@ struct hsr_node *hsr_get_node(struct hsr_port *port, struct sk_buff *skb,
 		seq_out = HSR_SEQNR_START;
 	}
 
-	return hsr_add_node(hsr, node_db, ethhdr->h_source, seq_out);
+	return hsr_add_node(priv, node_db, ethhdr->h_source, seq_out);
 }
 
 /* Use the Supervision frame's info about an eventual macaddress_B for merging
@@ -221,7 +221,7 @@ struct hsr_node *hsr_get_node(struct hsr_port *port, struct sk_buff *skb,
 void hsr_handle_sup_frame(struct sk_buff *skb, struct hsr_node *node_curr,
 			  struct hsr_port *port_rcv)
 {
-	struct hsr_priv *hsr = port_rcv->hsr;
+	struct hsr_priv *priv = port_rcv->priv;
 	struct hsr_sup_payload *hsr_sp;
 	struct hsr_node *node_real;
 	struct list_head *node_db;
@@ -243,11 +243,11 @@ void hsr_handle_sup_frame(struct sk_buff *skb, struct hsr_node *node_curr,
 	hsr_sp = (struct hsr_sup_payload *)skb->data;
 
 	/* Merge node_curr (registered on macaddress_B) into node_real */
-	node_db = &port_rcv->hsr->node_db;
+	node_db = &port_rcv->priv->node_db;
 	node_real = find_node_by_addr_A(node_db, hsr_sp->macaddress_A);
 	if (!node_real)
 		/* No frame received from AddrA of this node yet */
-		node_real = hsr_add_node(hsr, node_db, hsr_sp->macaddress_A,
+		node_real = hsr_add_node(priv, node_db, hsr_sp->macaddress_A,
 					 HSR_SEQNR_START - 1);
 	if (!node_real)
 		goto done; /* No mem */
@@ -268,9 +268,9 @@ void hsr_handle_sup_frame(struct sk_buff *skb, struct hsr_node *node_curr,
 	}
 	node_real->addr_B_port = port_rcv->type;
 
-	spin_lock_bh(&hsr->list_lock);
+	spin_lock_bh(&priv->list_lock);
 	list_del_rcu(&node_curr->mac_list);
-	spin_unlock_bh(&hsr->list_lock);
+	spin_unlock_bh(&priv->list_lock);
 	kfree_rcu(node_curr, rcu_head);
 
 done:
@@ -315,7 +315,7 @@ void hsr_addr_subst_dest(struct hsr_node *node_src, struct sk_buff *skb,
 	if (!is_unicast_ether_addr(eth_hdr(skb)->h_dest))
 		return;
 
-	node_dst = find_node_by_addr_A(&port->hsr->node_db,
+	node_dst = find_node_by_addr_A(&port->priv->node_db,
 				       eth_hdr(skb)->h_dest);
 	if (!node_dst) {
 		if (net_ratelimit())
@@ -360,22 +360,22 @@ int hsr_register_frame_out(struct hsr_port *port, struct hsr_node *node,
 	return 0;
 }
 
-static struct hsr_port *get_late_port(struct hsr_priv *hsr,
+static struct hsr_port *get_late_port(struct hsr_priv *priv,
 				      struct hsr_node *node)
 {
 	if (node->time_in_stale[HSR_PT_SLAVE_A])
-		return hsr_port_get_hsr(hsr, HSR_PT_SLAVE_A);
+		return hsr_port_get_hsr(priv, HSR_PT_SLAVE_A);
 	if (node->time_in_stale[HSR_PT_SLAVE_B])
-		return hsr_port_get_hsr(hsr, HSR_PT_SLAVE_B);
+		return hsr_port_get_hsr(priv, HSR_PT_SLAVE_B);
 
 	if (time_after(node->time_in[HSR_PT_SLAVE_B],
 		       node->time_in[HSR_PT_SLAVE_A] +
 					msecs_to_jiffies(MAX_SLAVE_DIFF)))
-		return hsr_port_get_hsr(hsr, HSR_PT_SLAVE_A);
+		return hsr_port_get_hsr(priv, HSR_PT_SLAVE_A);
 	if (time_after(node->time_in[HSR_PT_SLAVE_A],
 		       node->time_in[HSR_PT_SLAVE_B] +
 					msecs_to_jiffies(MAX_SLAVE_DIFF)))
-		return hsr_port_get_hsr(hsr, HSR_PT_SLAVE_B);
+		return hsr_port_get_hsr(priv, HSR_PT_SLAVE_B);
 
 	return NULL;
 }
@@ -385,21 +385,21 @@ static struct hsr_port *get_late_port(struct hsr_priv *hsr,
  */
 void hsr_prune_nodes(struct timer_list *t)
 {
-	struct hsr_priv *hsr = from_timer(hsr, t, prune_timer);
+	struct hsr_priv *priv = from_timer(priv, t, prune_timer);
 	struct hsr_node *node;
 	struct hsr_node *tmp;
 	struct hsr_port *port;
 	unsigned long timestamp;
 	unsigned long time_a, time_b;
 
-	spin_lock_bh(&hsr->list_lock);
-	list_for_each_entry_safe(node, tmp, &hsr->node_db, mac_list) {
+	spin_lock_bh(&priv->list_lock);
+	list_for_each_entry_safe(node, tmp, &priv->node_db, mac_list) {
 		/* Don't prune own node. Neither time_in[HSR_PT_SLAVE_A]
 		 * nor time_in[HSR_PT_SLAVE_B], will ever be updated for
 		 * the master port. Thus the master node will be repeatedly
 		 * pruned leading to packet loss.
 		 */
-		if (hsr_addr_is_self(hsr, node->macaddress_A))
+		if (hsr_addr_is_self(priv, node->macaddress_A))
 			continue;
 
 		/* Shorthand */
@@ -426,35 +426,36 @@ void hsr_prune_nodes(struct timer_list *t)
 		if (time_is_after_jiffies(timestamp +
 				msecs_to_jiffies(1.5 * MAX_SLAVE_DIFF))) {
 			rcu_read_lock();
-			port = get_late_port(hsr, node);
+			port = get_late_port(priv, node);
 			if (port)
-				hsr_nl_ringerror(hsr, node->macaddress_A, port);
+				hsr_nl_ringerror(priv,
+						 node->macaddress_A, port);
 			rcu_read_unlock();
 		}
 
 		/* Prune old entries */
 		if (time_is_before_jiffies(timestamp +
 				msecs_to_jiffies(HSR_NODE_FORGET_TIME))) {
-			hsr_nl_nodedown(hsr, node->macaddress_A);
+			hsr_nl_nodedown(priv, node->macaddress_A);
 			list_del_rcu(&node->mac_list);
 			/* Note that we need to free this entry later: */
 			kfree_rcu(node, rcu_head);
 		}
 	}
-	spin_unlock_bh(&hsr->list_lock);
+	spin_unlock_bh(&priv->list_lock);
 
 	/* Restart timer */
-	mod_timer(&hsr->prune_timer,
+	mod_timer(&priv->prune_timer,
 		  jiffies + msecs_to_jiffies(PRUNE_PERIOD));
 }
 
-void *hsr_get_next_node(struct hsr_priv *hsr, void *_pos,
+void *hsr_get_next_node(struct hsr_priv *priv, void *_pos,
 			unsigned char addr[ETH_ALEN])
 {
 	struct hsr_node *node;
 
 	if (!_pos) {
-		node = list_first_or_null_rcu(&hsr->node_db,
+		node = list_first_or_null_rcu(&priv->node_db,
 					      struct hsr_node, mac_list);
 		if (node)
 			ether_addr_copy(addr, node->macaddress_A);
@@ -462,7 +463,7 @@ void *hsr_get_next_node(struct hsr_priv *hsr, void *_pos,
 	}
 
 	node = _pos;
-	list_for_each_entry_continue_rcu(node, &hsr->node_db, mac_list) {
+	list_for_each_entry_continue_rcu(node, &priv->node_db, mac_list) {
 		ether_addr_copy(addr, node->macaddress_A);
 		return node;
 	}
@@ -470,7 +471,7 @@ void *hsr_get_next_node(struct hsr_priv *hsr, void *_pos,
 	return NULL;
 }
 
-int hsr_get_node_data(struct hsr_priv *hsr,
+int hsr_get_node_data(struct hsr_priv *priv,
 		      const unsigned char *addr,
 		      unsigned char addr_b[ETH_ALEN],
 		      unsigned int *addr_b_ifindex,
@@ -483,7 +484,7 @@ int hsr_get_node_data(struct hsr_priv *hsr,
 	struct hsr_port *port;
 	unsigned long tdiff;
 
-	node = find_node_by_addr_A(&hsr->node_db, addr);
+	node = find_node_by_addr_A(&priv->node_db, addr);
 	if (!node)
 		return -ENOENT;
 
@@ -514,7 +515,7 @@ int hsr_get_node_data(struct hsr_priv *hsr,
 	*if2_seq = node->seq_out[HSR_PT_SLAVE_A];
 
 	if (node->addr_B_port != HSR_PT_NONE) {
-		port = hsr_port_get_hsr(hsr, node->addr_B_port);
+		port = hsr_port_get_hsr(priv, node->addr_B_port);
 		*addr_b_ifindex = port->dev->ifindex;
 	} else {
 		*addr_b_ifindex = -1;
diff --git a/net/hsr-prp/hsr_prp_framereg.h b/net/hsr-prp/hsr_prp_framereg.h
index c7a2a975aca0..b29b685e444a 100644
--- a/net/hsr-prp/hsr_prp_framereg.h
+++ b/net/hsr-prp/hsr_prp_framereg.h
@@ -12,13 +12,13 @@
 
 struct hsr_node;
 
-void hsr_del_self_node(struct hsr_priv *hsr);
+void hsr_del_self_node(struct hsr_priv *priv);
 void hsr_del_nodes(struct list_head *node_db);
 struct hsr_node *hsr_get_node(struct hsr_port *port, struct sk_buff *skb,
 			      bool is_sup);
 void hsr_handle_sup_frame(struct sk_buff *skb, struct hsr_node *node_curr,
 			  struct hsr_port *port);
-bool hsr_addr_is_self(struct hsr_priv *hsr, unsigned char *addr);
+bool hsr_addr_is_self(struct hsr_priv *priv, unsigned char *addr);
 
 void hsr_addr_subst_source(struct hsr_node *node, struct sk_buff *skb);
 void hsr_addr_subst_dest(struct hsr_node *node_src, struct sk_buff *skb,
@@ -31,14 +31,14 @@ int hsr_register_frame_out(struct hsr_port *port, struct hsr_node *node,
 
 void hsr_prune_nodes(struct timer_list *t);
 
-int hsr_create_self_node(struct hsr_priv *hsr,
+int hsr_create_self_node(struct hsr_priv *priv,
 			 unsigned char addr_a[ETH_ALEN],
 			 unsigned char addr_b[ETH_ALEN]);
 
-void *hsr_get_next_node(struct hsr_priv *hsr, void *_pos,
+void *hsr_get_next_node(struct hsr_priv *priv, void *_pos,
 			unsigned char addr[ETH_ALEN]);
 
-int hsr_get_node_data(struct hsr_priv *hsr,
+int hsr_get_node_data(struct hsr_priv *priv,
 		      const unsigned char *addr,
 		      unsigned char addr_b[ETH_ALEN],
 		      unsigned int *addr_b_ifindex,
diff --git a/net/hsr-prp/hsr_prp_main.c b/net/hsr-prp/hsr_prp_main.c
index d0b7117bf5f9..caa544d0af42 100644
--- a/net/hsr-prp/hsr_prp_main.c
+++ b/net/hsr-prp/hsr_prp_main.c
@@ -15,11 +15,11 @@
 #include "hsr_prp_framereg.h"
 #include "hsr_prp_slave.h"
 
-static bool hsr_slave_empty(struct hsr_priv *hsr)
+static bool hsr_slave_empty(struct hsr_priv *priv)
 {
 	struct hsr_port *port;
 
-	hsr_for_each_port(hsr, port)
+	hsr_for_each_port(priv, port)
 		if (port->type != HSR_PT_MASTER)
 			return false;
 	return true;
@@ -30,7 +30,7 @@ static int hsr_netdev_notify(struct notifier_block *nb, unsigned long event,
 {
 	struct hsr_port *port, *master;
 	struct net_device *dev;
-	struct hsr_priv *hsr;
+	struct hsr_priv *priv;
 	LIST_HEAD(list_kill);
 	int mtu_max;
 	int res;
@@ -40,21 +40,21 @@ static int hsr_netdev_notify(struct notifier_block *nb, unsigned long event,
 	if (!port) {
 		if (!is_hsr_master(dev))
 			return NOTIFY_DONE;	/* Not an HSR device */
-		hsr = netdev_priv(dev);
-		port = hsr_port_get_hsr(hsr, HSR_PT_MASTER);
+		priv = netdev_priv(dev);
+		port = hsr_port_get_hsr(priv, HSR_PT_MASTER);
 		if (!port) {
 			/* Resend of notification concerning removed device? */
 			return NOTIFY_DONE;
 		}
 	} else {
-		hsr = port->hsr;
+		priv = port->priv;
 	}
 
 	switch (event) {
 	case NETDEV_UP:		/* Administrative state DOWN */
 	case NETDEV_DOWN:	/* Administrative state UP */
 	case NETDEV_CHANGE:	/* Link (carrier) state changes */
-		hsr_check_carrier_and_operstate(hsr);
+		hsr_check_carrier_and_operstate(priv);
 		break;
 	case NETDEV_CHANGENAME:
 		if (is_hsr_master(dev))
@@ -69,7 +69,7 @@ static int hsr_netdev_notify(struct notifier_block *nb, unsigned long event,
 			break;
 		}
 
-		master = hsr_port_get_hsr(hsr, HSR_PT_MASTER);
+		master = hsr_port_get_hsr(priv, HSR_PT_MASTER);
 
 		if (port->type == HSR_PT_SLAVE_A) {
 			ether_addr_copy(master->dev->dev_addr, dev->dev_addr);
@@ -78,8 +78,8 @@ static int hsr_netdev_notify(struct notifier_block *nb, unsigned long event,
 		}
 
 		/* Make sure we recognize frames from ourselves in hsr_rcv() */
-		port = hsr_port_get_hsr(hsr, HSR_PT_SLAVE_B);
-		res = hsr_create_self_node(hsr,
+		port = hsr_port_get_hsr(priv, HSR_PT_SLAVE_B);
+		res = hsr_create_self_node(priv,
 					   master->dev->dev_addr,
 					   port ?
 						port->dev->dev_addr :
@@ -91,15 +91,15 @@ static int hsr_netdev_notify(struct notifier_block *nb, unsigned long event,
 	case NETDEV_CHANGEMTU:
 		if (port->type == HSR_PT_MASTER)
 			break; /* Handled in ndo_change_mtu() */
-		mtu_max = hsr_get_max_mtu(port->hsr);
-		master = hsr_port_get_hsr(port->hsr, HSR_PT_MASTER);
+		mtu_max = hsr_get_max_mtu(port->priv);
+		master = hsr_port_get_hsr(port->priv, HSR_PT_MASTER);
 		master->dev->mtu = mtu_max;
 		break;
 	case NETDEV_UNREGISTER:
 		if (!is_hsr_master(dev)) {
-			master = hsr_port_get_hsr(port->hsr, HSR_PT_MASTER);
+			master = hsr_port_get_hsr(port->priv, HSR_PT_MASTER);
 			hsr_del_port(port);
-			if (hsr_slave_empty(master->hsr)) {
+			if (hsr_slave_empty(master->priv)) {
 				unregister_netdevice_queue(master->dev,
 							   &list_kill);
 				unregister_netdevice_many(&list_kill);
@@ -116,11 +116,11 @@ static int hsr_netdev_notify(struct notifier_block *nb, unsigned long event,
 	return NOTIFY_DONE;
 }
 
-struct hsr_port *hsr_port_get_hsr(struct hsr_priv *hsr, enum hsr_port_type pt)
+struct hsr_port *hsr_port_get_hsr(struct hsr_priv *priv, enum hsr_port_type pt)
 {
 	struct hsr_port *port;
 
-	hsr_for_each_port(hsr, port)
+	hsr_for_each_port(priv, port)
 		if (port->type == pt)
 			return port;
 	return NULL;
diff --git a/net/hsr-prp/hsr_prp_main.h b/net/hsr-prp/hsr_prp_main.h
index f74193465bf5..d11a9f0b696f 100644
--- a/net/hsr-prp/hsr_prp_main.h
+++ b/net/hsr-prp/hsr_prp_main.h
@@ -127,7 +127,7 @@ enum hsr_port_type {
 struct hsr_port {
 	struct list_head	port_list;
 	struct net_device	*dev;
-	struct hsr_priv		*hsr;
+	struct hsr_priv		*priv;
 	enum hsr_port_type	type;
 };
 
@@ -150,10 +150,10 @@ struct hsr_priv {
 #endif
 };
 
-#define hsr_for_each_port(hsr, port) \
-	list_for_each_entry_rcu((port), &(hsr)->ports, port_list)
+#define hsr_for_each_port(priv, port) \
+	list_for_each_entry_rcu((port), &(priv)->ports, port_list)
 
-struct hsr_port *hsr_port_get_hsr(struct hsr_priv *hsr, enum hsr_port_type pt);
+struct hsr_port *hsr_port_get_hsr(struct hsr_priv *priv, enum hsr_port_type pt);
 
 /* Caller must ensure skb is a valid HSR frame */
 static inline u16 hsr_get_skb_sequence_nr(struct sk_buff *skb)
diff --git a/net/hsr-prp/hsr_prp_slave.c b/net/hsr-prp/hsr_prp_slave.c
index fad8fef783cc..96de8d15db00 100644
--- a/net/hsr-prp/hsr_prp_slave.c
+++ b/net/hsr-prp/hsr_prp_slave.c
@@ -29,7 +29,7 @@ static rx_handler_result_t hsr_handle_frame(struct sk_buff **pskb)
 	if (!port)
 		goto finish_pass;
 
-	if (hsr_addr_is_self(port->hsr, eth_hdr(skb)->h_source)) {
+	if (hsr_addr_is_self(port->priv, eth_hdr(skb)->h_source)) {
 		/* Directly kill frames sent by ourselves */
 		kfree_skb(skb);
 		goto finish_consume;
@@ -97,7 +97,7 @@ static int hsr_check_dev_ok(struct net_device *dev,
 }
 
 /* Setup device to be added to the HSR bridge. */
-static int hsr_portdev_setup(struct hsr_priv *hsr, struct net_device *dev,
+static int hsr_portdev_setup(struct hsr_priv *priv, struct net_device *dev,
 			     struct hsr_port *port,
 			     struct netlink_ext_ack *extack)
 
@@ -110,7 +110,7 @@ static int hsr_portdev_setup(struct hsr_priv *hsr, struct net_device *dev,
 	if (res)
 		return res;
 
-	master = hsr_port_get_hsr(hsr, HSR_PT_MASTER);
+	master = hsr_port_get_hsr(priv, HSR_PT_MASTER);
 	hsr_dev = master->dev;
 
 	res = netdev_upper_dev_link(dev, hsr_dev, extack);
@@ -131,7 +131,7 @@ static int hsr_portdev_setup(struct hsr_priv *hsr, struct net_device *dev,
 	return res;
 }
 
-int hsr_add_port(struct hsr_priv *hsr, struct net_device *dev,
+int hsr_add_port(struct hsr_priv *priv, struct net_device *dev,
 		 enum hsr_port_type type, struct netlink_ext_ack *extack)
 {
 	struct hsr_port *port, *master;
@@ -143,7 +143,7 @@ int hsr_add_port(struct hsr_priv *hsr, struct net_device *dev,
 			return res;
 	}
 
-	port = hsr_port_get_hsr(hsr, type);
+	port = hsr_port_get_hsr(priv, type);
 	if (port)
 		return -EBUSY;	/* This port already exists */
 
@@ -151,22 +151,22 @@ int hsr_add_port(struct hsr_priv *hsr, struct net_device *dev,
 	if (!port)
 		return -ENOMEM;
 
-	port->hsr = hsr;
+	port->priv = priv;
 	port->dev = dev;
 	port->type = type;
 
 	if (type != HSR_PT_MASTER) {
-		res = hsr_portdev_setup(hsr, dev, port, extack);
+		res = hsr_portdev_setup(priv, dev, port, extack);
 		if (res)
 			goto fail_dev_setup;
 	}
 
-	list_add_tail_rcu(&port->port_list, &hsr->ports);
+	list_add_tail_rcu(&port->port_list, &priv->ports);
 	synchronize_rcu();
 
-	master = hsr_port_get_hsr(hsr, HSR_PT_MASTER);
+	master = hsr_port_get_hsr(priv, HSR_PT_MASTER);
 	netdev_update_features(master->dev);
-	dev_set_mtu(master->dev, hsr_get_max_mtu(hsr));
+	dev_set_mtu(master->dev, hsr_get_max_mtu(priv));
 
 	return 0;
 
@@ -177,16 +177,16 @@ int hsr_add_port(struct hsr_priv *hsr, struct net_device *dev,
 
 void hsr_del_port(struct hsr_port *port)
 {
-	struct hsr_priv *hsr;
+	struct hsr_priv *priv;
 	struct hsr_port *master;
 
-	hsr = port->hsr;
-	master = hsr_port_get_hsr(hsr, HSR_PT_MASTER);
+	priv = port->priv;
+	master = hsr_port_get_hsr(priv, HSR_PT_MASTER);
 	list_del_rcu(&port->port_list);
 
 	if (port != master) {
 		netdev_update_features(master->dev);
-		dev_set_mtu(master->dev, hsr_get_max_mtu(hsr));
+		dev_set_mtu(master->dev, hsr_get_max_mtu(priv));
 		netdev_rx_handler_unregister(port->dev);
 		dev_set_promiscuity(port->dev, -1);
 		netdev_upper_dev_unlink(port->dev, master->dev);
diff --git a/net/hsr-prp/hsr_prp_slave.h b/net/hsr-prp/hsr_prp_slave.h
index c0360b111151..85f292d88845 100644
--- a/net/hsr-prp/hsr_prp_slave.h
+++ b/net/hsr-prp/hsr_prp_slave.h
@@ -12,7 +12,7 @@
 #include <linux/rtnetlink.h>
 #include "hsr_prp_main.h"
 
-int hsr_add_port(struct hsr_priv *hsr, struct net_device *dev,
+int hsr_add_port(struct hsr_priv *priv, struct net_device *dev,
 		 enum hsr_port_type pt, struct netlink_ext_ack *extack);
 void hsr_del_port(struct hsr_port *port);
 bool hsr_port_exists(const struct net_device *dev);
-- 
2.17.1

