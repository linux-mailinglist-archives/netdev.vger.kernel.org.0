Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9A91C767B
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 18:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730408AbgEFQb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 12:31:56 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:46338 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730043AbgEFQal (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 12:30:41 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 046GUaaw025570;
        Wed, 6 May 2020 11:30:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1588782636;
        bh=6d4JNAt994JYzQJRkFmtlsGnhRr/B6NpUoAkvom6ldY=;
        h=From:To:Subject:Date:In-Reply-To:References;
        b=CNc/YjfrGESpqiUyzUGFEG5QayBOJYD4VTgewQoGUOUPHwxy3xfk5IXwWhvLuUKMB
         FDa4h/cxO0sTSzfRrwigNp5GykSZ9J9Sllo4dN0HuiViuKA29oGxCJ+jhnh75hyavG
         2ekJ4k9uRYfSATKW6SbBNDiEsEzjTjPlWqouIcko=
Received: from DLEE111.ent.ti.com (dlee111.ent.ti.com [157.170.170.22])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 046GUaJZ063273
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 6 May 2020 11:30:36 -0500
Received: from DLEE114.ent.ti.com (157.170.170.25) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 6 May
 2020 11:30:36 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 6 May 2020 11:30:36 -0500
Received: from uda0868495.fios-router.home (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 046GUXDi119719;
        Wed, 6 May 2020 11:30:36 -0500
From:   Murali Karicheri <m-karicheri2@ti.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        <nsekhar@ti.com>, <grygorii.strashko@ti.com>
Subject: [net-next RFC PATCH 05/13] net: hsr: rename hsr_port_get_hsr() to hsr_prp_get_port()
Date:   Wed, 6 May 2020 12:30:25 -0400
Message-ID: <20200506163033.3843-6-m-karicheri2@ti.com>
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

hsr_port_get_hsr() actually gets port struct ptr from the priv. So
rename it to reflect the same. hsr_prp prefix is chosen as this
can be re-used for PRP driver as well.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
 net/hsr-prp/hsr_netlink.c      | 12 ++++++------
 net/hsr-prp/hsr_prp_device.c   | 14 +++++++-------
 net/hsr-prp/hsr_prp_framereg.c | 10 +++++-----
 net/hsr-prp/hsr_prp_main.c     | 12 ++++++------
 net/hsr-prp/hsr_prp_main.h     |  2 +-
 net/hsr-prp/hsr_prp_slave.c    |  8 ++++----
 6 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/net/hsr-prp/hsr_netlink.c b/net/hsr-prp/hsr_netlink.c
index 9e3f6eda69f5..727b5dc9f31b 100644
--- a/net/hsr-prp/hsr_netlink.c
+++ b/net/hsr-prp/hsr_netlink.c
@@ -88,13 +88,13 @@ static int hsr_fill_info(struct sk_buff *skb, const struct net_device *dev)
 	struct hsr_priv *priv = netdev_priv(dev);
 	struct hsr_port *port;
 
-	port = hsr_port_get_hsr(priv, HSR_PT_SLAVE_A);
+	port = hsr_prp_get_port(priv, HSR_PT_SLAVE_A);
 	if (port) {
 		if (nla_put_u32(skb, IFLA_HSR_SLAVE1, port->dev->ifindex))
 			goto nla_put_failure;
 	}
 
-	port = hsr_port_get_hsr(priv, HSR_PT_SLAVE_B);
+	port = hsr_prp_get_port(priv, HSR_PT_SLAVE_B);
 	if (port) {
 		if (nla_put_u32(skb, IFLA_HSR_SLAVE2, port->dev->ifindex))
 			goto nla_put_failure;
@@ -177,7 +177,7 @@ void hsr_nl_ringerror(struct hsr_priv *priv, unsigned char addr[ETH_ALEN],
 
 fail:
 	rcu_read_lock();
-	master = hsr_port_get_hsr(priv, HSR_PT_MASTER);
+	master = hsr_prp_get_port(priv, HSR_PT_MASTER);
 	netdev_warn(master->dev, "Could not send HSR ring error message\n");
 	rcu_read_unlock();
 }
@@ -214,7 +214,7 @@ void hsr_nl_nodedown(struct hsr_priv *priv, unsigned char addr[ETH_ALEN])
 
 fail:
 	rcu_read_lock();
-	master = hsr_port_get_hsr(priv, HSR_PT_MASTER);
+	master = hsr_prp_get_port(priv, HSR_PT_MASTER);
 	netdev_warn(master->dev, "Could not send HSR node down\n");
 	rcu_read_unlock();
 }
@@ -319,7 +319,7 @@ static int hsr_get_node_status(struct sk_buff *skb_in, struct genl_info *info)
 	res = nla_put_u16(skb_out, HSR_A_IF1_SEQ, hsr_node_if1_seq);
 	if (res < 0)
 		goto nla_put_failure;
-	port = hsr_port_get_hsr(priv, HSR_PT_SLAVE_A);
+	port = hsr_prp_get_port(priv, HSR_PT_SLAVE_A);
 	if (port)
 		res = nla_put_u32(skb_out, HSR_A_IF1_IFINDEX,
 				  port->dev->ifindex);
@@ -332,7 +332,7 @@ static int hsr_get_node_status(struct sk_buff *skb_in, struct genl_info *info)
 	res = nla_put_u16(skb_out, HSR_A_IF2_SEQ, hsr_node_if2_seq);
 	if (res < 0)
 		goto nla_put_failure;
-	port = hsr_port_get_hsr(priv, HSR_PT_SLAVE_B);
+	port = hsr_prp_get_port(priv, HSR_PT_SLAVE_B);
 	if (port)
 		res = nla_put_u32(skb_out, HSR_A_IF2_IFINDEX,
 				  port->dev->ifindex);
diff --git a/net/hsr-prp/hsr_prp_device.c b/net/hsr-prp/hsr_prp_device.c
index df85b8f7f007..d8bc9a48b6f2 100644
--- a/net/hsr-prp/hsr_prp_device.c
+++ b/net/hsr-prp/hsr_prp_device.c
@@ -97,7 +97,7 @@ void hsr_check_carrier_and_operstate(struct hsr_priv *priv)
 	unsigned char old_operstate;
 	bool has_carrier;
 
-	master = hsr_port_get_hsr(priv, HSR_PT_MASTER);
+	master = hsr_prp_get_port(priv, HSR_PT_MASTER);
 	/* netif_stacked_transfer_operstate() cannot be used here since
 	 * it doesn't set IF_OPER_LOWERLAYERDOWN (?)
 	 */
@@ -215,7 +215,7 @@ static int hsr_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct hsr_priv *priv = netdev_priv(dev);
 	struct hsr_port *master;
 
-	master = hsr_port_get_hsr(priv, HSR_PT_MASTER);
+	master = hsr_prp_get_port(priv, HSR_PT_MASTER);
 	if (master) {
 		skb->dev = master->dev;
 		hsr_forward_skb(skb, master);
@@ -318,7 +318,7 @@ static void hsr_announce(struct timer_list *t)
 	priv = from_timer(priv, t, announce_timer);
 
 	rcu_read_lock();
-	master = hsr_port_get_hsr(priv, HSR_PT_MASTER);
+	master = hsr_prp_get_port(priv, HSR_PT_MASTER);
 
 	if (priv->announce_count < 3 && priv->prot_version == 0) {
 		send_hsr_supervision_frame(master, HSR_TLV_ANNOUNCE,
@@ -343,22 +343,22 @@ static void hsr_del_ports(struct hsr_priv *priv)
 {
 	struct hsr_port *port;
 
-	port = hsr_port_get_hsr(priv, HSR_PT_SLAVE_A);
+	port = hsr_prp_get_port(priv, HSR_PT_SLAVE_A);
 	if (port)
 		hsr_del_port(port);
 
-	port = hsr_port_get_hsr(priv, HSR_PT_SLAVE_B);
+	port = hsr_prp_get_port(priv, HSR_PT_SLAVE_B);
 	if (port)
 		hsr_del_port(port);
 
-	port = hsr_port_get_hsr(priv, HSR_PT_MASTER);
+	port = hsr_prp_get_port(priv, HSR_PT_MASTER);
 	if (port)
 		hsr_del_port(port);
 }
 
 /* This has to be called after all the readers are gone.
  * Otherwise we would have to check the return value of
- * hsr_port_get_hsr().
+ * hsr_prp_get_port().
  */
 static void hsr_dev_destroy(struct net_device *hsr_dev)
 {
diff --git a/net/hsr-prp/hsr_prp_framereg.c b/net/hsr-prp/hsr_prp_framereg.c
index 854338352e93..102b0a85f440 100644
--- a/net/hsr-prp/hsr_prp_framereg.c
+++ b/net/hsr-prp/hsr_prp_framereg.c
@@ -364,18 +364,18 @@ static struct hsr_port *get_late_port(struct hsr_priv *priv,
 				      struct hsr_node *node)
 {
 	if (node->time_in_stale[HSR_PT_SLAVE_A])
-		return hsr_port_get_hsr(priv, HSR_PT_SLAVE_A);
+		return hsr_prp_get_port(priv, HSR_PT_SLAVE_A);
 	if (node->time_in_stale[HSR_PT_SLAVE_B])
-		return hsr_port_get_hsr(priv, HSR_PT_SLAVE_B);
+		return hsr_prp_get_port(priv, HSR_PT_SLAVE_B);
 
 	if (time_after(node->time_in[HSR_PT_SLAVE_B],
 		       node->time_in[HSR_PT_SLAVE_A] +
 					msecs_to_jiffies(MAX_SLAVE_DIFF)))
-		return hsr_port_get_hsr(priv, HSR_PT_SLAVE_A);
+		return hsr_prp_get_port(priv, HSR_PT_SLAVE_A);
 	if (time_after(node->time_in[HSR_PT_SLAVE_A],
 		       node->time_in[HSR_PT_SLAVE_B] +
 					msecs_to_jiffies(MAX_SLAVE_DIFF)))
-		return hsr_port_get_hsr(priv, HSR_PT_SLAVE_B);
+		return hsr_prp_get_port(priv, HSR_PT_SLAVE_B);
 
 	return NULL;
 }
@@ -515,7 +515,7 @@ int hsr_get_node_data(struct hsr_priv *priv,
 	*if2_seq = node->seq_out[HSR_PT_SLAVE_A];
 
 	if (node->addr_B_port != HSR_PT_NONE) {
-		port = hsr_port_get_hsr(priv, node->addr_B_port);
+		port = hsr_prp_get_port(priv, node->addr_B_port);
 		*addr_b_ifindex = port->dev->ifindex;
 	} else {
 		*addr_b_ifindex = -1;
diff --git a/net/hsr-prp/hsr_prp_main.c b/net/hsr-prp/hsr_prp_main.c
index caa544d0af42..de85f42be6ee 100644
--- a/net/hsr-prp/hsr_prp_main.c
+++ b/net/hsr-prp/hsr_prp_main.c
@@ -41,7 +41,7 @@ static int hsr_netdev_notify(struct notifier_block *nb, unsigned long event,
 		if (!is_hsr_master(dev))
 			return NOTIFY_DONE;	/* Not an HSR device */
 		priv = netdev_priv(dev);
-		port = hsr_port_get_hsr(priv, HSR_PT_MASTER);
+		port = hsr_prp_get_port(priv, HSR_PT_MASTER);
 		if (!port) {
 			/* Resend of notification concerning removed device? */
 			return NOTIFY_DONE;
@@ -69,7 +69,7 @@ static int hsr_netdev_notify(struct notifier_block *nb, unsigned long event,
 			break;
 		}
 
-		master = hsr_port_get_hsr(priv, HSR_PT_MASTER);
+		master = hsr_prp_get_port(priv, HSR_PT_MASTER);
 
 		if (port->type == HSR_PT_SLAVE_A) {
 			ether_addr_copy(master->dev->dev_addr, dev->dev_addr);
@@ -78,7 +78,7 @@ static int hsr_netdev_notify(struct notifier_block *nb, unsigned long event,
 		}
 
 		/* Make sure we recognize frames from ourselves in hsr_rcv() */
-		port = hsr_port_get_hsr(priv, HSR_PT_SLAVE_B);
+		port = hsr_prp_get_port(priv, HSR_PT_SLAVE_B);
 		res = hsr_create_self_node(priv,
 					   master->dev->dev_addr,
 					   port ?
@@ -92,12 +92,12 @@ static int hsr_netdev_notify(struct notifier_block *nb, unsigned long event,
 		if (port->type == HSR_PT_MASTER)
 			break; /* Handled in ndo_change_mtu() */
 		mtu_max = hsr_get_max_mtu(port->priv);
-		master = hsr_port_get_hsr(port->priv, HSR_PT_MASTER);
+		master = hsr_prp_get_port(port->priv, HSR_PT_MASTER);
 		master->dev->mtu = mtu_max;
 		break;
 	case NETDEV_UNREGISTER:
 		if (!is_hsr_master(dev)) {
-			master = hsr_port_get_hsr(port->priv, HSR_PT_MASTER);
+			master = hsr_prp_get_port(port->priv, HSR_PT_MASTER);
 			hsr_del_port(port);
 			if (hsr_slave_empty(master->priv)) {
 				unregister_netdevice_queue(master->dev,
@@ -116,7 +116,7 @@ static int hsr_netdev_notify(struct notifier_block *nb, unsigned long event,
 	return NOTIFY_DONE;
 }
 
-struct hsr_port *hsr_port_get_hsr(struct hsr_priv *priv, enum hsr_port_type pt)
+struct hsr_port *hsr_prp_get_port(struct hsr_priv *priv, enum hsr_port_type pt)
 {
 	struct hsr_port *port;
 
diff --git a/net/hsr-prp/hsr_prp_main.h b/net/hsr-prp/hsr_prp_main.h
index d11a9f0b696f..5a99d0b12c66 100644
--- a/net/hsr-prp/hsr_prp_main.h
+++ b/net/hsr-prp/hsr_prp_main.h
@@ -153,7 +153,7 @@ struct hsr_priv {
 #define hsr_for_each_port(priv, port) \
 	list_for_each_entry_rcu((port), &(priv)->ports, port_list)
 
-struct hsr_port *hsr_port_get_hsr(struct hsr_priv *priv, enum hsr_port_type pt);
+struct hsr_port *hsr_prp_get_port(struct hsr_priv *priv, enum hsr_port_type pt);
 
 /* Caller must ensure skb is a valid HSR frame */
 static inline u16 hsr_get_skb_sequence_nr(struct sk_buff *skb)
diff --git a/net/hsr-prp/hsr_prp_slave.c b/net/hsr-prp/hsr_prp_slave.c
index 96de8d15db00..2c8832bf7a5f 100644
--- a/net/hsr-prp/hsr_prp_slave.c
+++ b/net/hsr-prp/hsr_prp_slave.c
@@ -110,7 +110,7 @@ static int hsr_portdev_setup(struct hsr_priv *priv, struct net_device *dev,
 	if (res)
 		return res;
 
-	master = hsr_port_get_hsr(priv, HSR_PT_MASTER);
+	master = hsr_prp_get_port(priv, HSR_PT_MASTER);
 	hsr_dev = master->dev;
 
 	res = netdev_upper_dev_link(dev, hsr_dev, extack);
@@ -143,7 +143,7 @@ int hsr_add_port(struct hsr_priv *priv, struct net_device *dev,
 			return res;
 	}
 
-	port = hsr_port_get_hsr(priv, type);
+	port = hsr_prp_get_port(priv, type);
 	if (port)
 		return -EBUSY;	/* This port already exists */
 
@@ -164,7 +164,7 @@ int hsr_add_port(struct hsr_priv *priv, struct net_device *dev,
 	list_add_tail_rcu(&port->port_list, &priv->ports);
 	synchronize_rcu();
 
-	master = hsr_port_get_hsr(priv, HSR_PT_MASTER);
+	master = hsr_prp_get_port(priv, HSR_PT_MASTER);
 	netdev_update_features(master->dev);
 	dev_set_mtu(master->dev, hsr_get_max_mtu(priv));
 
@@ -181,7 +181,7 @@ void hsr_del_port(struct hsr_port *port)
 	struct hsr_port *master;
 
 	priv = port->priv;
-	master = hsr_port_get_hsr(priv, HSR_PT_MASTER);
+	master = hsr_prp_get_port(priv, HSR_PT_MASTER);
 	list_del_rcu(&port->port_list);
 
 	if (port != master) {
-- 
2.17.1

