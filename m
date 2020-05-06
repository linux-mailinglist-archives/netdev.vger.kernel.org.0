Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7F6C1C764E
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 18:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730148AbgEFQap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 12:30:45 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:58216 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730088AbgEFQam (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 12:30:42 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 046GUbQr116952;
        Wed, 6 May 2020 11:30:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1588782637;
        bh=WUkEMGQJ1ceuXvJNGtjvE1feD30PJr30FrAJT23HCu0=;
        h=From:To:Subject:Date:In-Reply-To:References;
        b=U9k9VjMQAvw3ZmYjEQLwgd6OFu0yN4HKc55GxpcGNJmzuftBsPG0cYkIRiNrCPANK
         BHfBwoLoc+sDQJqkXnXdqO4EuG7khg+qA4ffV369XrLNepNgrzajkDe4s6B3NvynEs
         Et3FwRtKnbP6mlKozxG4H7PCt21qykTOcO+NKjRw=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 046GUbow021932
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 6 May 2020 11:30:37 -0500
Received: from DFLE115.ent.ti.com (10.64.6.36) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 6 May
 2020 11:30:37 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 6 May 2020 11:30:36 -0500
Received: from uda0868495.fios-router.home (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 046GUXDj119719;
        Wed, 6 May 2020 11:30:36 -0500
From:   Murali Karicheri <m-karicheri2@ti.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        <nsekhar@ti.com>, <grygorii.strashko@ti.com>
Subject: [net-next RFC PATCH 06/13] net: hsr: some renaming to introduce PRP driver support
Date:   Wed, 6 May 2020 12:30:26 -0400
Message-ID: <20200506163033.3843-7-m-karicheri2@ti.com>
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

This is a preparatory patch to introduce PRP device support.
PRP device is very much similar to HSR in terms of device
creation/removal, packet handling, etc. So this patch rename
the functions that can be reused for PRP with a hsr_prp prefix.
Common definitions and structure types are prefixed as well
per similar reason. Similarly all constants common to HSR and
PRP are prefixed with HSR_PRP.  Common code that uses hsr_dev
for function argument is changed to hsr_prp_dev or dev or
ndev depending on the existing usage and context.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
 net/hsr-prp/hsr_netlink.c      |  75 ++++-----
 net/hsr-prp/hsr_netlink.h      |  12 +-
 net/hsr-prp/hsr_prp_debugfs.c  |  60 ++++----
 net/hsr-prp/hsr_prp_device.c   | 271 +++++++++++++++++----------------
 net/hsr-prp/hsr_prp_device.h   |  20 +--
 net/hsr-prp/hsr_prp_forward.c  | 122 ++++++++-------
 net/hsr-prp/hsr_prp_forward.h  |   8 +-
 net/hsr-prp/hsr_prp_framereg.c | 209 +++++++++++++------------
 net/hsr-prp/hsr_prp_framereg.h |  74 ++++-----
 net/hsr-prp/hsr_prp_main.c     |  81 +++++-----
 net/hsr-prp/hsr_prp_main.h     |  85 ++++++-----
 net/hsr-prp/hsr_prp_slave.c    |  72 ++++-----
 net/hsr-prp/hsr_prp_slave.h    |  30 ++--
 13 files changed, 576 insertions(+), 543 deletions(-)

diff --git a/net/hsr-prp/hsr_netlink.c b/net/hsr-prp/hsr_netlink.c
index 727b5dc9f31b..fbfa98aee13c 100644
--- a/net/hsr-prp/hsr_netlink.c
+++ b/net/hsr-prp/hsr_netlink.c
@@ -25,7 +25,7 @@ static const struct nla_policy hsr_policy[IFLA_HSR_MAX + 1] = {
 };
 
 /* Here, it seems a netdevice has already been allocated for us, and the
- * hsr_dev_setup routine has been executed. Nice!
+ * hsr_prp_dev_setup routine has been executed. Nice!
  */
 static int hsr_newlink(struct net *src_net, struct net_device *dev,
 		       struct nlattr *tb[], struct nlattr *data[],
@@ -80,21 +80,22 @@ static int hsr_newlink(struct net *src_net, struct net_device *dev,
 		}
 	}
 
-	return hsr_dev_finalize(dev, link, multicast_spec, hsr_version, extack);
+	return hsr_prp_dev_finalize(dev, link, multicast_spec, hsr_version,
+				    extack);
 }
 
 static int hsr_fill_info(struct sk_buff *skb, const struct net_device *dev)
 {
-	struct hsr_priv *priv = netdev_priv(dev);
-	struct hsr_port *port;
+	struct hsr_prp_priv *priv = netdev_priv(dev);
+	struct hsr_prp_port *port;
 
-	port = hsr_prp_get_port(priv, HSR_PT_SLAVE_A);
+	port = hsr_prp_get_port(priv, HSR_PRP_PT_SLAVE_A);
 	if (port) {
 		if (nla_put_u32(skb, IFLA_HSR_SLAVE1, port->dev->ifindex))
 			goto nla_put_failure;
 	}
 
-	port = hsr_prp_get_port(priv, HSR_PT_SLAVE_B);
+	port = hsr_prp_get_port(priv, HSR_PRP_PT_SLAVE_B);
 	if (port) {
 		if (nla_put_u32(skb, IFLA_HSR_SLAVE2, port->dev->ifindex))
 			goto nla_put_failure;
@@ -115,8 +116,8 @@ static struct rtnl_link_ops hsr_link_ops __read_mostly = {
 	.kind		= "hsr",
 	.maxtype	= IFLA_HSR_MAX,
 	.policy		= hsr_policy,
-	.priv_size	= sizeof(struct hsr_priv),
-	.setup		= hsr_dev_setup,
+	.priv_size	= sizeof(struct hsr_prp_priv),
+	.setup		= hsr_prp_dev_setup,
 	.newlink	= hsr_newlink,
 	.fill_info	= hsr_fill_info,
 };
@@ -142,12 +143,13 @@ static const struct genl_multicast_group hsr_mcgrps[] = {
  * over one of the slave interfaces. This would indicate an open network ring
  * (i.e. a link has failed somewhere).
  */
-void hsr_nl_ringerror(struct hsr_priv *priv, unsigned char addr[ETH_ALEN],
-		      struct hsr_port *port)
+void hsr_nl_ringerror(struct hsr_prp_priv *priv,
+		      unsigned char addr[ETH_ALEN],
+		      struct hsr_prp_port *port)
 {
 	struct sk_buff *skb;
 	void *msg_head;
-	struct hsr_port *master;
+	struct hsr_prp_port *master;
 	int res;
 
 	skb = genlmsg_new(NLMSG_GOODSIZE, GFP_ATOMIC);
@@ -177,7 +179,7 @@ void hsr_nl_ringerror(struct hsr_priv *priv, unsigned char addr[ETH_ALEN],
 
 fail:
 	rcu_read_lock();
-	master = hsr_prp_get_port(priv, HSR_PT_MASTER);
+	master = hsr_prp_get_port(priv, HSR_PRP_PT_MASTER);
 	netdev_warn(master->dev, "Could not send HSR ring error message\n");
 	rcu_read_unlock();
 }
@@ -185,11 +187,12 @@ void hsr_nl_ringerror(struct hsr_priv *priv, unsigned char addr[ETH_ALEN],
 /* This is called when we haven't heard from the node with MAC address addr for
  * some time (just before the node is removed from the node table/list).
  */
-void hsr_nl_nodedown(struct hsr_priv *priv, unsigned char addr[ETH_ALEN])
+void hsr_nl_nodedown(struct hsr_prp_priv *priv,
+		     unsigned char addr[ETH_ALEN])
 {
 	struct sk_buff *skb;
 	void *msg_head;
-	struct hsr_port *master;
+	struct hsr_prp_port *master;
 	int res;
 
 	skb = genlmsg_new(NLMSG_GOODSIZE, GFP_ATOMIC);
@@ -214,7 +217,7 @@ void hsr_nl_nodedown(struct hsr_priv *priv, unsigned char addr[ETH_ALEN])
 
 fail:
 	rcu_read_lock();
-	master = hsr_prp_get_port(priv, HSR_PT_MASTER);
+	master = hsr_prp_get_port(priv, HSR_PRP_PT_MASTER);
 	netdev_warn(master->dev, "Could not send HSR node down\n");
 	rcu_read_unlock();
 }
@@ -236,9 +239,9 @@ static int hsr_get_node_status(struct sk_buff *skb_in, struct genl_info *info)
 	/* For sending */
 	struct sk_buff *skb_out;
 	void *msg_head;
-	struct hsr_priv *priv;
-	struct hsr_port *port;
-	unsigned char hsr_node_addr_b[ETH_ALEN];
+	struct hsr_prp_priv *priv;
+	struct hsr_prp_port *port;
+	unsigned char node_addr_b[ETH_ALEN];
 	int hsr_node_if1_age;
 	u16 hsr_node_if1_seq;
 	int hsr_node_if2_age;
@@ -261,7 +264,7 @@ static int hsr_get_node_status(struct sk_buff *skb_in, struct genl_info *info)
 				       nla_get_u32(info->attrs[HSR_A_IFINDEX]));
 	if (!hsr_dev)
 		goto rcu_unlock;
-	if (!is_hsr_master(hsr_dev))
+	if (!is_hsr_prp_master(hsr_dev))
 		goto rcu_unlock;
 
 	/* Send reply */
@@ -284,15 +287,15 @@ static int hsr_get_node_status(struct sk_buff *skb_in, struct genl_info *info)
 		goto nla_put_failure;
 
 	priv = netdev_priv(hsr_dev);
-	res = hsr_get_node_data(priv,
-				(unsigned char *)
-				nla_data(info->attrs[HSR_A_NODE_ADDR]),
-					 hsr_node_addr_b,
-					 &addr_b_ifindex,
-					 &hsr_node_if1_age,
-					 &hsr_node_if1_seq,
-					 &hsr_node_if2_age,
-					 &hsr_node_if2_seq);
+	res = hsr_prp_get_node_data(priv,
+				    (unsigned char *)
+				    nla_data(info->attrs[HSR_A_NODE_ADDR]),
+					     node_addr_b,
+					     &addr_b_ifindex,
+					     &hsr_node_if1_age,
+					     &hsr_node_if1_seq,
+					     &hsr_node_if2_age,
+					     &hsr_node_if2_seq);
 	if (res < 0)
 		goto nla_put_failure;
 
@@ -303,7 +306,7 @@ static int hsr_get_node_status(struct sk_buff *skb_in, struct genl_info *info)
 
 	if (addr_b_ifindex > -1) {
 		res = nla_put(skb_out, HSR_A_NODE_ADDR_B, ETH_ALEN,
-			      hsr_node_addr_b);
+			      node_addr_b);
 		if (res < 0)
 			goto nla_put_failure;
 
@@ -319,7 +322,7 @@ static int hsr_get_node_status(struct sk_buff *skb_in, struct genl_info *info)
 	res = nla_put_u16(skb_out, HSR_A_IF1_SEQ, hsr_node_if1_seq);
 	if (res < 0)
 		goto nla_put_failure;
-	port = hsr_prp_get_port(priv, HSR_PT_SLAVE_A);
+	port = hsr_prp_get_port(priv, HSR_PRP_PT_SLAVE_A);
 	if (port)
 		res = nla_put_u32(skb_out, HSR_A_IF1_IFINDEX,
 				  port->dev->ifindex);
@@ -332,7 +335,7 @@ static int hsr_get_node_status(struct sk_buff *skb_in, struct genl_info *info)
 	res = nla_put_u16(skb_out, HSR_A_IF2_SEQ, hsr_node_if2_seq);
 	if (res < 0)
 		goto nla_put_failure;
-	port = hsr_prp_get_port(priv, HSR_PT_SLAVE_B);
+	port = hsr_prp_get_port(priv, HSR_PRP_PT_SLAVE_B);
 	if (port)
 		res = nla_put_u32(skb_out, HSR_A_IF2_IFINDEX,
 				  port->dev->ifindex);
@@ -367,8 +370,8 @@ static int hsr_get_node_list(struct sk_buff *skb_in, struct genl_info *info)
 {
 	unsigned char addr[ETH_ALEN];
 	struct net_device *hsr_dev;
+	struct hsr_prp_priv *priv;
 	struct sk_buff *skb_out;
-	struct hsr_priv *priv;
 	bool restart = false;
 	struct nlattr *na;
 	void *pos = NULL;
@@ -387,7 +390,7 @@ static int hsr_get_node_list(struct sk_buff *skb_in, struct genl_info *info)
 				       nla_get_u32(info->attrs[HSR_A_IFINDEX]));
 	if (!hsr_dev)
 		goto rcu_unlock;
-	if (!is_hsr_master(hsr_dev))
+	if (!is_hsr_prp_master(hsr_dev))
 		goto rcu_unlock;
 
 restart:
@@ -415,7 +418,7 @@ static int hsr_get_node_list(struct sk_buff *skb_in, struct genl_info *info)
 	priv = netdev_priv(hsr_dev);
 
 	if (!pos)
-		pos = hsr_get_next_node(priv, NULL, addr);
+		pos = hsr_prp_get_next_node(priv, NULL, addr);
 	while (pos) {
 		res = nla_put(skb_out, HSR_A_NODE_ADDR, ETH_ALEN, addr);
 		if (res < 0) {
@@ -428,7 +431,7 @@ static int hsr_get_node_list(struct sk_buff *skb_in, struct genl_info *info)
 			}
 			goto nla_put_failure;
 		}
-		pos = hsr_get_next_node(priv, pos, addr);
+		pos = hsr_prp_get_next_node(priv, pos, addr);
 	}
 	rcu_read_unlock();
 
@@ -495,7 +498,7 @@ int __init hsr_netlink_init(void)
 	if (rc)
 		goto fail_genl_register_family;
 
-	hsr_debugfs_create_root();
+	hsr_prp_debugfs_create_root();
 	return 0;
 
 fail_genl_register_family:
diff --git a/net/hsr-prp/hsr_netlink.h b/net/hsr-prp/hsr_netlink.h
index 1121bb192a18..ae7a1c0de80d 100644
--- a/net/hsr-prp/hsr_netlink.h
+++ b/net/hsr-prp/hsr_netlink.h
@@ -12,15 +12,17 @@
 #include <linux/module.h>
 #include <uapi/linux/hsr_netlink.h>
 
-struct hsr_priv;
-struct hsr_port;
+struct hsr_prp_priv;
+struct hsr_prp_port;
 
 int __init hsr_netlink_init(void);
 void __exit hsr_netlink_exit(void);
 
-void hsr_nl_ringerror(struct hsr_priv *hsr, unsigned char addr[ETH_ALEN],
-		      struct hsr_port *port);
-void hsr_nl_nodedown(struct hsr_priv *hsr, unsigned char addr[ETH_ALEN]);
+void hsr_nl_ringerror(struct hsr_prp_priv *priv,
+		      unsigned char addr[ETH_ALEN],
+		      struct hsr_prp_port *port);
+void hsr_nl_nodedown(struct hsr_prp_priv *priv,
+		     unsigned char addr[ETH_ALEN]);
 void hsr_nl_framedrop(int dropcount, int dev_idx);
 void hsr_nl_linkdown(int dev_idx);
 
diff --git a/net/hsr-prp/hsr_prp_debugfs.c b/net/hsr-prp/hsr_prp_debugfs.c
index d37b44082e92..7d8dd5ab3afd 100644
--- a/net/hsr-prp/hsr_prp_debugfs.c
+++ b/net/hsr-prp/hsr_prp_debugfs.c
@@ -20,7 +20,7 @@
 #include "hsr_prp_main.h"
 #include "hsr_prp_framereg.h"
 
-static struct dentry *hsr_debugfs_root_dir;
+static struct dentry *hsr_prp_debugfs_root_dir;
 
 static void print_mac_address(struct seq_file *sfp, unsigned char *mac)
 {
@@ -28,12 +28,12 @@ static void print_mac_address(struct seq_file *sfp, unsigned char *mac)
 		   mac[0], mac[1], mac[2], mac[3], mac[4], mac[5]);
 }
 
-/* hsr_node_table_show - Formats and prints node_table entries */
+/* hsr_prp_node_table_show - Formats and prints node_table entries */
 static int
-hsr_node_table_show(struct seq_file *sfp, void *data)
+hsr_prp_node_table_show(struct seq_file *sfp, void *data)
 {
-	struct hsr_priv *priv = (struct hsr_priv *)sfp->private;
-	struct hsr_node *node;
+	struct hsr_prp_priv *priv = (struct hsr_prp_priv *)sfp->private;
+	struct hsr_prp_node *node;
 
 	seq_puts(sfp, "Node Table entries\n");
 	seq_puts(sfp, "MAC-Address-A,   MAC-Address-B, time_in[A], ");
@@ -41,62 +41,62 @@ hsr_node_table_show(struct seq_file *sfp, void *data)
 	rcu_read_lock();
 	list_for_each_entry_rcu(node, &priv->node_db, mac_list) {
 		/* skip self node */
-		if (hsr_addr_is_self(priv, node->macaddress_A))
+		if (hsr_prp_addr_is_self(priv, node->macaddress_A))
 			continue;
 		print_mac_address(sfp, &node->macaddress_A[0]);
 		seq_puts(sfp, " ");
 		print_mac_address(sfp, &node->macaddress_B[0]);
-		seq_printf(sfp, "0x%lx, ", node->time_in[HSR_PT_SLAVE_A]);
-		seq_printf(sfp, "0x%lx ", node->time_in[HSR_PT_SLAVE_B]);
+		seq_printf(sfp, "0x%lx, ", node->time_in[HSR_PRP_PT_SLAVE_A]);
+		seq_printf(sfp, "0x%lx ", node->time_in[HSR_PRP_PT_SLAVE_B]);
 		seq_printf(sfp, "0x%x\n", node->addr_B_port);
 	}
 	rcu_read_unlock();
 	return 0;
 }
 
-/* hsr_node_table_open - Open the node_table file
+/* hsr_prp_node_table_open - Open the node_table file
  *
  * Description:
  * This routine opens a debugfs file node_table of specific hsr device
  */
 static int
-hsr_node_table_open(struct inode *inode, struct file *filp)
+hsr_prp_node_table_open(struct inode *inode, struct file *filp)
 {
-	return single_open(filp, hsr_node_table_show, inode->i_private);
+	return single_open(filp, hsr_prp_node_table_show, inode->i_private);
 }
 
-void hsr_debugfs_rename(struct net_device *dev)
+void hsr_prp_debugfs_rename(struct net_device *dev)
 {
-	struct hsr_priv *priv = netdev_priv(dev);
+	struct hsr_prp_priv *priv = netdev_priv(dev);
 	struct dentry *d;
 
-	d = debugfs_rename(hsr_debugfs_root_dir, priv->node_tbl_root,
-			   hsr_debugfs_root_dir, dev->name);
+	d = debugfs_rename(hsr_prp_debugfs_root_dir, priv->node_tbl_root,
+			   hsr_prp_debugfs_root_dir, dev->name);
 	if (IS_ERR(d))
 		netdev_warn(dev, "failed to rename\n");
 	else
 		priv->node_tbl_root = d;
 }
 
-static const struct file_operations hsr_fops = {
-	.open	= hsr_node_table_open,
+static const struct file_operations hsr_prp_fops = {
+	.open	= hsr_prp_node_table_open,
 	.read	= seq_read,
 	.llseek = seq_lseek,
 	.release = single_release,
 };
 
-/* hsr_debugfs_init - create hsr node_table file for dumping
+/* hsr_prp_debugfs_init - create hsr node_table file for dumping
  * the node table
  *
  * Description:
  * When debugfs is configured this routine sets up the node_table file per
  * hsr device for dumping the node_table entries
  */
-void hsr_debugfs_init(struct hsr_priv *priv, struct net_device *hsr_dev)
+void hsr_prp_debugfs_init(struct hsr_prp_priv *priv, struct net_device *hsr_dev)
 {
 	struct dentry *de = NULL;
 
-	de = debugfs_create_dir(hsr_dev->name, hsr_debugfs_root_dir);
+	de = debugfs_create_dir(hsr_dev->name, hsr_prp_debugfs_root_dir);
 	if (IS_ERR(de)) {
 		pr_err("Cannot create hsr debugfs directory\n");
 		return;
@@ -106,7 +106,7 @@ void hsr_debugfs_init(struct hsr_priv *priv, struct net_device *hsr_dev)
 
 	de = debugfs_create_file("node_table", S_IFREG | 0444,
 				 priv->node_tbl_root, priv,
-				 &hsr_fops);
+				 &hsr_prp_fops);
 	if (IS_ERR(de)) {
 		pr_err("Cannot create hsr node_table file\n");
 		debugfs_remove(priv->node_tbl_root);
@@ -115,30 +115,30 @@ void hsr_debugfs_init(struct hsr_priv *priv, struct net_device *hsr_dev)
 	}
 }
 
-/* hsr_debugfs_term - Tear down debugfs intrastructure
+/* hsr_prp_debugfs_term - Tear down debugfs intrastructure
  *
  * Description:
  * When Debufs is configured this routine removes debugfs file system
  * elements that are specific to hsr
  */
 void
-hsr_debugfs_term(struct hsr_priv *priv)
+hsr_prp_debugfs_term(struct hsr_prp_priv *priv)
 {
 	debugfs_remove_recursive(priv->node_tbl_root);
 	priv->node_tbl_root = NULL;
 }
 
-void hsr_debugfs_create_root(void)
+void hsr_prp_debugfs_create_root(void)
 {
-	hsr_debugfs_root_dir = debugfs_create_dir("hsr", NULL);
-	if (IS_ERR(hsr_debugfs_root_dir)) {
-		pr_err("Cannot create hsr debugfs root directory\n");
-		hsr_debugfs_root_dir = NULL;
+	hsr_prp_debugfs_root_dir = debugfs_create_dir("hsr-prp", NULL);
+	if (IS_ERR(hsr_prp_debugfs_root_dir)) {
+		pr_err("Cannot create hsr-prp debugfs root directory\n");
+		hsr_prp_debugfs_root_dir = NULL;
 	}
 }
 
-void hsr_debugfs_remove_root(void)
+void hsr_prp_debugfs_remove_root(void)
 {
 	/* debugfs_remove() internally checks NULL and ERROR */
-	debugfs_remove(hsr_debugfs_root_dir);
+	debugfs_remove(hsr_prp_debugfs_root_dir);
 }
diff --git a/net/hsr-prp/hsr_prp_device.c b/net/hsr-prp/hsr_prp_device.c
index d8bc9a48b6f2..43269c204445 100644
--- a/net/hsr-prp/hsr_prp_device.c
+++ b/net/hsr-prp/hsr_prp_device.c
@@ -29,7 +29,7 @@ static bool is_slave_up(struct net_device *dev)
 	return dev && is_admin_up(dev) && netif_oper_up(dev);
 }
 
-static void __hsr_set_operstate(struct net_device *dev, int transition)
+static void __hsr_prp_set_operstate(struct net_device *dev, int transition)
 {
 	write_lock_bh(&dev_base_lock);
 	if (dev->operstate != transition) {
@@ -41,27 +41,27 @@ static void __hsr_set_operstate(struct net_device *dev, int transition)
 	}
 }
 
-static void hsr_set_operstate(struct hsr_port *master, bool has_carrier)
+static void hsr_prp_set_operstate(struct hsr_prp_port *master, bool has_carrier)
 {
 	if (!is_admin_up(master->dev)) {
-		__hsr_set_operstate(master->dev, IF_OPER_DOWN);
+		__hsr_prp_set_operstate(master->dev, IF_OPER_DOWN);
 		return;
 	}
 
 	if (has_carrier)
-		__hsr_set_operstate(master->dev, IF_OPER_UP);
+		__hsr_prp_set_operstate(master->dev, IF_OPER_UP);
 	else
-		__hsr_set_operstate(master->dev, IF_OPER_LOWERLAYERDOWN);
+		__hsr_prp_set_operstate(master->dev, IF_OPER_LOWERLAYERDOWN);
 }
 
-static bool hsr_check_carrier(struct hsr_port *master)
+static bool hsr_prp_check_carrier(struct hsr_prp_port *master)
 {
-	struct hsr_port *port;
+	struct hsr_prp_port *port;
 
 	ASSERT_RTNL();
 
-	hsr_for_each_port(master->priv, port) {
-		if (port->type != HSR_PT_MASTER && is_slave_up(port->dev)) {
+	hsr_prp_for_each_port(master->priv, port) {
+		if (port->type != HSR_PRP_PT_MASTER && is_slave_up(port->dev)) {
 			netif_carrier_on(master->dev);
 			return true;
 		}
@@ -72,65 +72,66 @@ static bool hsr_check_carrier(struct hsr_port *master)
 	return false;
 }
 
-static void hsr_check_announce(struct net_device *hsr_dev,
-			       unsigned char old_operstate)
+static void hsr_prp_check_announce(struct net_device *dev,
+				   unsigned char old_operstate)
 {
-	struct hsr_priv *priv;
+	struct hsr_prp_priv *priv;
 
-	priv = netdev_priv(hsr_dev);
+	priv = netdev_priv(dev);
 
-	if (hsr_dev->operstate == IF_OPER_UP && old_operstate != IF_OPER_UP) {
+	if (dev->operstate == IF_OPER_UP && old_operstate != IF_OPER_UP) {
 		/* Went up */
 		priv->announce_count = 0;
 		mod_timer(&priv->announce_timer,
-			  jiffies + msecs_to_jiffies(HSR_ANNOUNCE_INTERVAL));
+			  jiffies +
+			  msecs_to_jiffies(HSR_PRP_ANNOUNCE_INTERVAL));
 	}
 
-	if (hsr_dev->operstate != IF_OPER_UP && old_operstate == IF_OPER_UP)
+	if (dev->operstate != IF_OPER_UP && old_operstate == IF_OPER_UP)
 		/* Went down */
 		del_timer(&priv->announce_timer);
 }
 
-void hsr_check_carrier_and_operstate(struct hsr_priv *priv)
+void hsr_prp_check_carrier_and_operstate(struct hsr_prp_priv *priv)
 {
-	struct hsr_port *master;
+	struct hsr_prp_port *master;
 	unsigned char old_operstate;
 	bool has_carrier;
 
-	master = hsr_prp_get_port(priv, HSR_PT_MASTER);
+	master = hsr_prp_get_port(priv, HSR_PRP_PT_MASTER);
 	/* netif_stacked_transfer_operstate() cannot be used here since
 	 * it doesn't set IF_OPER_LOWERLAYERDOWN (?)
 	 */
 	old_operstate = master->dev->operstate;
-	has_carrier = hsr_check_carrier(master);
-	hsr_set_operstate(master, has_carrier);
-	hsr_check_announce(master->dev, old_operstate);
+	has_carrier = hsr_prp_check_carrier(master);
+	hsr_prp_set_operstate(master, has_carrier);
+	hsr_prp_check_announce(master->dev, old_operstate);
 }
 
-int hsr_get_max_mtu(struct hsr_priv *priv)
+int hsr_prp_get_max_mtu(struct hsr_prp_priv *priv)
 {
 	unsigned int mtu_max;
-	struct hsr_port *port;
+	struct hsr_prp_port *port;
 
 	mtu_max = ETH_DATA_LEN;
-	hsr_for_each_port(priv, port)
-		if (port->type != HSR_PT_MASTER)
+	hsr_prp_for_each_port(priv, port)
+		if (port->type != HSR_PRP_PT_MASTER)
 			mtu_max = min(port->dev->mtu, mtu_max);
 
-	if (mtu_max < HSR_HLEN)
+	if (mtu_max < HSR_PRP_HLEN)
 		return 0;
-	return mtu_max - HSR_HLEN;
+	return mtu_max - HSR_PRP_HLEN;
 }
 
-static int hsr_dev_change_mtu(struct net_device *dev, int new_mtu)
+static int hsr_prp_dev_change_mtu(struct net_device *dev, int new_mtu)
 {
-	struct hsr_priv *priv;
+	struct hsr_prp_priv *priv;
 
 	priv = netdev_priv(dev);
 
-	if (new_mtu > hsr_get_max_mtu(priv)) {
-		netdev_info(dev, "A HSR master's MTU cannot be greater than the smallest MTU of its slaves minus the HSR Tag length (%d octets).\n",
-			    HSR_HLEN);
+	if (new_mtu > hsr_prp_get_max_mtu(priv)) {
+		netdev_info(dev, "A HSR/PRP master's MTU cannot be greater than the smallest MTU of its slaves minus the HSR Tag length (%d octets).\n",
+			    HSR_PRP_HLEN);
 		return -EINVAL;
 	}
 
@@ -139,30 +140,30 @@ static int hsr_dev_change_mtu(struct net_device *dev, int new_mtu)
 	return 0;
 }
 
-static int hsr_dev_open(struct net_device *dev)
+static int hsr_prp_dev_open(struct net_device *dev)
 {
-	struct hsr_priv *priv;
-	struct hsr_port *port;
+	struct hsr_prp_priv *priv;
+	struct hsr_prp_port *port;
 	char designation;
 
 	priv = netdev_priv(dev);
 	designation = '\0';
 
-	hsr_for_each_port(priv, port) {
-		if (port->type == HSR_PT_MASTER)
+	hsr_prp_for_each_port(priv, port) {
+		if (port->type == HSR_PRP_PT_MASTER)
 			continue;
 		switch (port->type) {
-		case HSR_PT_SLAVE_A:
+		case HSR_PRP_PT_SLAVE_A:
 			designation = 'A';
 			break;
-		case HSR_PT_SLAVE_B:
+		case HSR_PRP_PT_SLAVE_B:
 			designation = 'B';
 			break;
 		default:
 			designation = '?';
 		}
 		if (!is_slave_up(port->dev))
-			netdev_warn(dev, "Slave %c (%s) is not up; please bring it up to get a fully working HSR network\n",
+			netdev_warn(dev, "Slave %c (%s) is not up; please bring it up to get a fully working HSR/PRP network\n",
 				    designation, port->dev->name);
 	}
 
@@ -172,17 +173,17 @@ static int hsr_dev_open(struct net_device *dev)
 	return 0;
 }
 
-static int hsr_dev_close(struct net_device *dev)
+static int hsr_prp_dev_close(struct net_device *dev)
 {
 	/* Nothing to do here. */
 	return 0;
 }
 
-static netdev_features_t hsr_features_recompute(struct hsr_priv *priv,
-						netdev_features_t features)
+static netdev_features_t hsr_prp_features_recompute(struct hsr_prp_priv *priv,
+						    netdev_features_t features)
 {
 	netdev_features_t mask;
-	struct hsr_port *port;
+	struct hsr_prp_port *port;
 
 	mask = features;
 
@@ -194,7 +195,7 @@ static netdev_features_t hsr_features_recompute(struct hsr_priv *priv,
 	 * may become enabled.
 	 */
 	features &= ~NETIF_F_ONE_FOR_ALL;
-	hsr_for_each_port(priv, port)
+	hsr_prp_for_each_port(priv, port)
 		features = netdev_increment_features(features,
 						     port->dev->features,
 						     mask);
@@ -202,23 +203,23 @@ static netdev_features_t hsr_features_recompute(struct hsr_priv *priv,
 	return features;
 }
 
-static netdev_features_t hsr_fix_features(struct net_device *dev,
-					  netdev_features_t features)
+static netdev_features_t hsr_prp_fix_features(struct net_device *dev,
+					      netdev_features_t features)
 {
-	struct hsr_priv *priv = netdev_priv(dev);
+	struct hsr_prp_priv *priv = netdev_priv(dev);
 
-	return hsr_features_recompute(priv, features);
+	return hsr_prp_features_recompute(priv, features);
 }
 
-static int hsr_dev_xmit(struct sk_buff *skb, struct net_device *dev)
+static int hsr_prp_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 {
-	struct hsr_priv *priv = netdev_priv(dev);
-	struct hsr_port *master;
+	struct hsr_prp_priv *priv = netdev_priv(dev);
+	struct hsr_prp_port *master;
 
-	master = hsr_prp_get_port(priv, HSR_PT_MASTER);
+	master = hsr_prp_get_port(priv, HSR_PRP_PT_MASTER);
 	if (master) {
 		skb->dev = master->dev;
-		hsr_forward_skb(skb, master);
+		hsr_prp_forward_skb(skb, master);
 	} else {
 		atomic_long_inc(&dev->tx_dropped);
 		dev_kfree_skb_any(skb);
@@ -226,26 +227,26 @@ static int hsr_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 	return NETDEV_TX_OK;
 }
 
-static const struct header_ops hsr_header_ops = {
+static const struct header_ops hsr_prp_header_ops = {
 	.create	 = eth_header,
 	.parse	 = eth_header_parse,
 };
 
-static void send_hsr_supervision_frame(struct hsr_port *master,
-				       u8 type, u8 hsr_ver)
+static void send_hsr_prp_supervision_frame(struct hsr_prp_port *master,
+					   u8 type, u8 proto_ver)
 {
 	struct sk_buff *skb;
 	int hlen, tlen;
 	struct hsr_tag *hsr_tag;
-	struct hsr_sup_tag *hsr_stag;
-	struct hsr_sup_payload *hsr_sp;
+	struct hsr_prp_sup_tag *hsr_stag;
+	struct hsr_prp_sup_payload *hsr_sp;
 	unsigned long irqflags;
 
 	hlen = LL_RESERVED_SPACE(master->dev);
 	tlen = master->dev->needed_tailroom;
 	skb = dev_alloc_skb(sizeof(struct hsr_tag) +
-			    sizeof(struct hsr_sup_tag) +
-			    sizeof(struct hsr_sup_payload) + hlen + tlen);
+			    sizeof(struct hsr_prp_sup_tag) +
+			    sizeof(struct hsr_prp_sup_payload) + hlen + tlen);
 
 	if (!skb)
 		return;
@@ -253,10 +254,10 @@ static void send_hsr_supervision_frame(struct hsr_port *master,
 	skb_reserve(skb, hlen);
 
 	skb->dev = master->dev;
-	skb->protocol = htons(hsr_ver ? ETH_P_HSR : ETH_P_PRP);
+	skb->protocol = htons(proto_ver ? ETH_P_HSR : ETH_P_PRP);
 	skb->priority = TC_PRIO_CONTROL;
 
-	if (dev_hard_header(skb, skb->dev, (hsr_ver ? ETH_P_HSR : ETH_P_PRP),
+	if (dev_hard_header(skb, skb->dev, (proto_ver ? ETH_P_HSR : ETH_P_PRP),
 			    master->priv->sup_multicast_addr,
 			    skb->dev->dev_addr, skb->len) <= 0)
 		goto out;
@@ -264,19 +265,19 @@ static void send_hsr_supervision_frame(struct hsr_port *master,
 	skb_reset_network_header(skb);
 	skb_reset_transport_header(skb);
 
-	if (hsr_ver > 0) {
+	if (proto_ver > 0) {
 		hsr_tag = skb_put(skb, sizeof(struct hsr_tag));
 		hsr_tag->encap_proto = htons(ETH_P_PRP);
 		set_hsr_tag_LSDU_size(hsr_tag, HSR_V1_SUP_LSDUSIZE);
 	}
 
-	hsr_stag = skb_put(skb, sizeof(struct hsr_sup_tag));
-	set_hsr_stag_path(hsr_stag, (hsr_ver ? 0x0 : 0xf));
-	set_hsr_stag_HSR_ver(hsr_stag, hsr_ver);
+	hsr_stag = skb_put(skb, sizeof(struct hsr_prp_sup_tag));
+	set_hsr_stag_path(hsr_stag, (proto_ver ? 0x0 : 0xf));
+	set_hsr_stag_HSR_ver(hsr_stag, proto_ver);
 
 	/* From HSRv1 on we have separate supervision sequence numbers. */
 	spin_lock_irqsave(&master->priv->seqnr_lock, irqflags);
-	if (hsr_ver > 0) {
+	if (proto_ver > 0) {
 		hsr_stag->sequence_nr = htons(master->priv->sup_sequence_nr);
 		hsr_tag->sequence_nr = htons(master->priv->sequence_nr);
 		master->priv->sup_sequence_nr++;
@@ -289,17 +290,17 @@ static void send_hsr_supervision_frame(struct hsr_port *master,
 
 	hsr_stag->HSR_TLV_type = type;
 	/* TODO: Why 12 in HSRv0? */
-	hsr_stag->HSR_TLV_length =
-				hsr_ver ? sizeof(struct hsr_sup_payload) : 12;
+	hsr_stag->HSR_TLV_length = proto_ver ?
+					sizeof(struct hsr_prp_sup_payload) : 12;
 
 	/* Payload: MacAddressA */
-	hsr_sp = skb_put(skb, sizeof(struct hsr_sup_payload));
+	hsr_sp = skb_put(skb, sizeof(struct hsr_prp_sup_payload));
 	ether_addr_copy(hsr_sp->macaddress_A, master->dev->dev_addr);
 
-	if (skb_put_padto(skb, ETH_ZLEN + HSR_HLEN))
+	if (skb_put_padto(skb, ETH_ZLEN + HSR_PRP_HLEN))
 		return;
 
-	hsr_forward_skb(skb, master);
+	hsr_prp_forward_skb(skb, master);
 	return;
 
 out:
@@ -309,28 +310,28 @@ static void send_hsr_supervision_frame(struct hsr_port *master,
 
 /* Announce (supervision frame) timer function
  */
-static void hsr_announce(struct timer_list *t)
+static void hsr_prp_announce(struct timer_list *t)
 {
-	struct hsr_priv *priv;
-	struct hsr_port *master;
+	struct hsr_prp_priv *priv;
+	struct hsr_prp_port *master;
 	unsigned long interval;
 
 	priv = from_timer(priv, t, announce_timer);
 
 	rcu_read_lock();
-	master = hsr_prp_get_port(priv, HSR_PT_MASTER);
+	master = hsr_prp_get_port(priv, HSR_PRP_PT_MASTER);
 
 	if (priv->announce_count < 3 && priv->prot_version == 0) {
-		send_hsr_supervision_frame(master, HSR_TLV_ANNOUNCE,
-					   priv->prot_version);
+		send_hsr_prp_supervision_frame(master, HSR_TLV_ANNOUNCE,
+					       priv->prot_version);
 		priv->announce_count++;
 
-		interval = msecs_to_jiffies(HSR_ANNOUNCE_INTERVAL);
+		interval = msecs_to_jiffies(HSR_PRP_ANNOUNCE_INTERVAL);
 	} else {
-		send_hsr_supervision_frame(master, HSR_TLV_LIFE_CHECK,
-					   priv->prot_version);
+		send_hsr_prp_supervision_frame(master, HSR_TLV_LIFE_CHECK,
+					       priv->prot_version);
 
-		interval = msecs_to_jiffies(HSR_LIFE_CHECK_INTERVAL);
+		interval = msecs_to_jiffies(HSR_PRP_LIFE_CHECK_INTERVAL);
 	}
 
 	if (is_admin_up(master->dev))
@@ -339,62 +340,62 @@ static void hsr_announce(struct timer_list *t)
 	rcu_read_unlock();
 }
 
-static void hsr_del_ports(struct hsr_priv *priv)
+static void hsr_prp_del_ports(struct hsr_prp_priv *priv)
 {
-	struct hsr_port *port;
+	struct hsr_prp_port *port;
 
-	port = hsr_prp_get_port(priv, HSR_PT_SLAVE_A);
+	port = hsr_prp_get_port(priv, HSR_PRP_PT_SLAVE_A);
 	if (port)
-		hsr_del_port(port);
+		hsr_prp_del_port(port);
 
-	port = hsr_prp_get_port(priv, HSR_PT_SLAVE_B);
+	port = hsr_prp_get_port(priv, HSR_PRP_PT_SLAVE_B);
 	if (port)
-		hsr_del_port(port);
+		hsr_prp_del_port(port);
 
-	port = hsr_prp_get_port(priv, HSR_PT_MASTER);
+	port = hsr_prp_get_port(priv, HSR_PRP_PT_MASTER);
 	if (port)
-		hsr_del_port(port);
+		hsr_prp_del_port(port);
 }
 
 /* This has to be called after all the readers are gone.
  * Otherwise we would have to check the return value of
  * hsr_prp_get_port().
  */
-static void hsr_dev_destroy(struct net_device *hsr_dev)
+static void hsr_prp_dev_destroy(struct net_device *dev)
 {
-	struct hsr_priv *priv = netdev_priv(hsr_dev);
+	struct hsr_prp_priv *priv = netdev_priv(dev);
 
-	hsr_debugfs_term(priv);
-	hsr_del_ports(priv);
+	hsr_prp_debugfs_term(priv);
+	hsr_prp_del_ports(priv);
 
 	del_timer_sync(&priv->prune_timer);
 	del_timer_sync(&priv->announce_timer);
 
-	hsr_del_self_node(priv);
-	hsr_del_nodes(&priv->node_db);
+	hsr_prp_del_self_node(priv);
+	hsr_prp_del_nodes(&priv->node_db);
 }
 
-static const struct net_device_ops hsr_device_ops = {
-	.ndo_change_mtu = hsr_dev_change_mtu,
-	.ndo_open = hsr_dev_open,
-	.ndo_stop = hsr_dev_close,
-	.ndo_start_xmit = hsr_dev_xmit,
-	.ndo_fix_features = hsr_fix_features,
-	.ndo_uninit = hsr_dev_destroy,
+static const struct net_device_ops hsr_prp_device_ops = {
+	.ndo_change_mtu = hsr_prp_dev_change_mtu,
+	.ndo_open = hsr_prp_dev_open,
+	.ndo_stop = hsr_prp_dev_close,
+	.ndo_start_xmit = hsr_prp_dev_xmit,
+	.ndo_fix_features = hsr_prp_fix_features,
+	.ndo_uninit = hsr_prp_dev_destroy,
 };
 
 static struct device_type hsr_type = {
 	.name = "hsr",
 };
 
-void hsr_dev_setup(struct net_device *dev)
+void hsr_prp_dev_setup(struct net_device *dev)
 {
 	eth_hw_addr_random(dev);
 
 	ether_setup(dev);
 	dev->min_mtu = 0;
-	dev->header_ops = &hsr_header_ops;
-	dev->netdev_ops = &hsr_device_ops;
+	dev->header_ops = &hsr_prp_header_ops;
+	dev->netdev_ops = &hsr_prp_device_ops;
 	SET_NETDEV_DEVTYPE(dev, &hsr_type);
 	dev->priv_flags |= IFF_NO_QUEUE;
 
@@ -420,9 +421,9 @@ void hsr_dev_setup(struct net_device *dev)
 
 /* Return true if dev is a HSR master; return false otherwise.
  */
-inline bool is_hsr_master(struct net_device *dev)
+inline bool is_hsr_prp_master(struct net_device *dev)
 {
-	return (dev->netdev_ops->ndo_start_xmit == hsr_dev_xmit);
+	return (dev->netdev_ops->ndo_start_xmit == hsr_prp_dev_xmit);
 }
 
 /* Default multicast address for HSR Supervision frames */
@@ -430,34 +431,35 @@ static const unsigned char def_multicast_addr[ETH_ALEN] __aligned(2) = {
 	0x01, 0x15, 0x4e, 0x00, 0x01, 0x00
 };
 
-int hsr_dev_finalize(struct net_device *hsr_dev, struct net_device *slave[2],
-		     unsigned char multicast_spec, u8 protocol_version,
-		     struct netlink_ext_ack *extack)
+int hsr_prp_dev_finalize(struct net_device *hsr_prp_dev,
+			 struct net_device *slave[2],
+			 unsigned char multicast_spec, u8 protocol_version,
+			 struct netlink_ext_ack *extack)
 {
-	struct hsr_priv *priv;
+	struct hsr_prp_priv *priv;
 	int res;
 
-	priv = netdev_priv(hsr_dev);
+	priv = netdev_priv(hsr_prp_dev);
 	INIT_LIST_HEAD(&priv->ports);
 	INIT_LIST_HEAD(&priv->node_db);
 	INIT_LIST_HEAD(&priv->self_node_db);
 	spin_lock_init(&priv->list_lock);
 
-	ether_addr_copy(hsr_dev->dev_addr, slave[0]->dev_addr);
+	ether_addr_copy(hsr_prp_dev->dev_addr, slave[0]->dev_addr);
 
 	/* Make sure we recognize frames from ourselves in hsr_rcv() */
-	res = hsr_create_self_node(priv, hsr_dev->dev_addr,
-				   slave[1]->dev_addr);
+	res = hsr_prp_create_self_node(priv, hsr_prp_dev->dev_addr,
+				       slave[1]->dev_addr);
 	if (res < 0)
 		return res;
 
 	spin_lock_init(&priv->seqnr_lock);
 	/* Overflow soon to find bugs easier: */
-	priv->sequence_nr = HSR_SEQNR_START;
-	priv->sup_sequence_nr = HSR_SUP_SEQNR_START;
+	priv->sequence_nr = HSR_PRP_SEQNR_START;
+	priv->sup_sequence_nr = HSR_PRP_SUP_SEQNR_START;
 
-	timer_setup(&priv->announce_timer, hsr_announce, 0);
-	timer_setup(&priv->prune_timer, hsr_prune_nodes, 0);
+	timer_setup(&priv->announce_timer, hsr_prp_announce, 0);
+	timer_setup(&priv->prune_timer, hsr_prp_prune_nodes, 0);
 
 	ether_addr_copy(priv->sup_multicast_addr, def_multicast_addr);
 	priv->sup_multicast_addr[ETH_ALEN - 1] = multicast_spec;
@@ -466,44 +468,45 @@ int hsr_dev_finalize(struct net_device *hsr_dev, struct net_device *slave[2],
 
 	/* FIXME: should I modify the value of these?
 	 *
-	 * - hsr_dev->flags - i.e.
+	 * - hsr_ptp_dev->flags - i.e.
 	 *			IFF_MASTER/SLAVE?
-	 * - hsr_dev->priv_flags - i.e.
+	 * - hsr_prp_dev->priv_flags - i.e.
 	 *			IFF_EBRIDGE?
 	 *			IFF_TX_SKB_SHARING?
 	 *			IFF_HSR_MASTER/SLAVE?
 	 */
 
 	/* Make sure the 1st call to netif_carrier_on() gets through */
-	netif_carrier_off(hsr_dev);
+	netif_carrier_off(hsr_prp_dev);
 
-	res = hsr_add_port(priv, hsr_dev, HSR_PT_MASTER, extack);
+	res = hsr_prp_add_port(priv, hsr_prp_dev, HSR_PRP_PT_MASTER, extack);
 	if (res)
 		goto err_add_master;
 
-	res = register_netdevice(hsr_dev);
+	res = register_netdevice(hsr_prp_dev);
 	if (res)
 		goto err_unregister;
 
-	res = hsr_add_port(priv, slave[0], HSR_PT_SLAVE_A, extack);
+	res = hsr_prp_add_port(priv, slave[0], HSR_PRP_PT_SLAVE_A, extack);
 	if (res)
 		goto err_add_slaves;
 
-	res = hsr_add_port(priv, slave[1], HSR_PT_SLAVE_B, extack);
+	res = hsr_prp_add_port(priv, slave[1], HSR_PRP_PT_SLAVE_B, extack);
 	if (res)
 		goto err_add_slaves;
 
-	hsr_debugfs_init(priv, hsr_dev);
-	mod_timer(&priv->prune_timer, jiffies + msecs_to_jiffies(PRUNE_PERIOD));
+	hsr_prp_debugfs_init(priv, hsr_prp_dev);
+	mod_timer(&priv->prune_timer,
+		  jiffies + msecs_to_jiffies(PRUNE_PERIOD));
 
 	return 0;
 
 err_add_slaves:
-	unregister_netdevice(hsr_dev);
+	unregister_netdevice(hsr_prp_dev);
 err_unregister:
-	hsr_del_ports(priv);
+	hsr_prp_del_ports(priv);
 err_add_master:
-	hsr_del_self_node(priv);
+	hsr_prp_del_self_node(priv);
 
 	return res;
 }
diff --git a/net/hsr-prp/hsr_prp_device.h b/net/hsr-prp/hsr_prp_device.h
index 91642845cdd2..4f734a36b2d6 100644
--- a/net/hsr-prp/hsr_prp_device.h
+++ b/net/hsr-prp/hsr_prp_device.h
@@ -5,18 +5,18 @@
  *	2011-2014 Arvid Brodin, arvid.brodin@alten.se
  */
 
-#ifndef __HSR_DEVICE_H
-#define __HSR_DEVICE_H
+#ifndef __HSR_PRP_DEVICE_H
+#define __HSR_PRP_DEVICE_H
 
 #include <linux/netdevice.h>
 #include "hsr_prp_main.h"
 
-void hsr_dev_setup(struct net_device *dev);
-int hsr_dev_finalize(struct net_device *hsr_dev, struct net_device *slave[2],
-		     unsigned char multicast_spec, u8 protocol_version,
-		     struct netlink_ext_ack *extack);
-void hsr_check_carrier_and_operstate(struct hsr_priv *priv);
-bool is_hsr_master(struct net_device *dev);
-int hsr_get_max_mtu(struct hsr_priv *priv);
+void hsr_prp_dev_setup(struct net_device *dev);
+int hsr_prp_dev_finalize(struct net_device *dev, struct net_device *slave[2],
+			 unsigned char multicast_spec, u8 protocol_version,
+			 struct netlink_ext_ack *extack);
+void hsr_prp_check_carrier_and_operstate(struct hsr_prp_priv *priv);
+bool is_hsr_prp_master(struct net_device *dev);
+int hsr_prp_get_max_mtu(struct hsr_prp_priv *priv);
 
-#endif /* __HSR_DEVICE_H */
+#endif /* __HSR_PRP_DEVICE_H */
diff --git a/net/hsr-prp/hsr_prp_forward.c b/net/hsr-prp/hsr_prp_forward.c
index 2b6abb09fe4b..59b33d711ea6 100644
--- a/net/hsr-prp/hsr_prp_forward.c
+++ b/net/hsr-prp/hsr_prp_forward.c
@@ -13,13 +13,13 @@
 #include "hsr_prp_main.h"
 #include "hsr_prp_framereg.h"
 
-struct hsr_node;
+struct hsr_prp_node;
 
-struct hsr_frame_info {
+struct hsr_prp_frame_info {
 	struct sk_buff *skb_std;
 	struct sk_buff *skb_hsr;
-	struct hsr_port *port_rcv;
-	struct hsr_node *node_src;
+	struct hsr_prp_port *port_rcv;
+	struct hsr_prp_node *node_src;
 	u16 sequence_nr;
 	bool is_supervision;
 	bool is_vlan;
@@ -42,10 +42,10 @@ struct hsr_frame_info {
  * 3) Allow different MAC addresses for the two slave interfaces, using the
  *    MacAddressA field.
  */
-static bool is_supervision_frame(struct hsr_priv *priv, struct sk_buff *skb)
+static bool is_supervision_frame(struct hsr_prp_priv *priv, struct sk_buff *skb)
 {
 	struct ethhdr *eth_hdr;
-	struct hsr_sup_tag *hsr_sup_tag;
+	struct hsr_prp_sup_tag *hsr_sup_tag;
 	struct hsrv1_ethhdr_sp *hsr_V1_hdr;
 
 	WARN_ON_ONCE(!skb_mac_header_was_set(skb));
@@ -77,29 +77,30 @@ static bool is_supervision_frame(struct hsr_priv *priv, struct sk_buff *skb)
 	    hsr_sup_tag->HSR_TLV_type != HSR_TLV_LIFE_CHECK)
 		return false;
 	if (hsr_sup_tag->HSR_TLV_length != 12 &&
-	    hsr_sup_tag->HSR_TLV_length != sizeof(struct hsr_sup_payload))
+	    hsr_sup_tag->HSR_TLV_length != sizeof(struct hsr_prp_sup_payload))
 		return false;
 
 	return true;
 }
 
 static struct sk_buff *create_stripped_skb(struct sk_buff *skb_in,
-					   struct hsr_frame_info *frame)
+					   struct hsr_prp_frame_info *frame)
 {
 	struct sk_buff *skb;
 	int copylen;
 	unsigned char *dst, *src;
 
-	skb_pull(skb_in, HSR_HLEN);
-	skb = __pskb_copy(skb_in, skb_headroom(skb_in) - HSR_HLEN, GFP_ATOMIC);
-	skb_push(skb_in, HSR_HLEN);
+	skb_pull(skb_in, HSR_PRP_HLEN);
+	skb = __pskb_copy(skb_in,
+			  skb_headroom(skb_in) - HSR_PRP_HLEN, GFP_ATOMIC);
+	skb_push(skb_in, HSR_PRP_HLEN);
 	if (!skb)
 		return NULL;
 
 	skb_reset_mac_header(skb);
 
 	if (skb->ip_summed == CHECKSUM_PARTIAL)
-		skb->csum_start -= HSR_HLEN;
+		skb->csum_start -= HSR_PRP_HLEN;
 
 	copylen = 2 * ETH_ALEN;
 	if (frame->is_vlan)
@@ -112,22 +113,22 @@ static struct sk_buff *create_stripped_skb(struct sk_buff *skb_in,
 	return skb;
 }
 
-static struct sk_buff *frame_get_stripped_skb(struct hsr_frame_info *frame,
-					      struct hsr_port *port)
+static struct sk_buff *frame_get_stripped_skb(struct hsr_prp_frame_info *frame,
+					      struct hsr_prp_port *port)
 {
 	if (!frame->skb_std)
 		frame->skb_std = create_stripped_skb(frame->skb_hsr, frame);
 	return skb_clone(frame->skb_std, GFP_ATOMIC);
 }
 
-static void hsr_fill_tag(struct sk_buff *skb, struct hsr_frame_info *frame,
-			 struct hsr_port *port, u8 proto_version)
+static void hsr_fill_tag(struct sk_buff *skb, struct hsr_prp_frame_info *frame,
+			 struct hsr_prp_port *port, u8 proto_version)
 {
 	struct hsr_ethhdr *hsr_ethhdr;
 	int lane_id;
 	int lsdu_size;
 
-	if (port->type == HSR_PT_SLAVE_A)
+	if (port->type == HSR_PRP_PT_SLAVE_A)
 		lane_id = 0;
 	else
 		lane_id = 1;
@@ -147,28 +148,29 @@ static void hsr_fill_tag(struct sk_buff *skb, struct hsr_frame_info *frame,
 }
 
 static struct sk_buff *create_tagged_skb(struct sk_buff *skb_o,
-					 struct hsr_frame_info *frame,
-					 struct hsr_port *port)
+					 struct hsr_prp_frame_info *frame,
+					 struct hsr_prp_port *port)
 {
 	int movelen;
 	unsigned char *dst, *src;
 	struct sk_buff *skb;
 
 	/* Create the new skb with enough headroom to fit the HSR tag */
-	skb = __pskb_copy(skb_o, skb_headroom(skb_o) + HSR_HLEN, GFP_ATOMIC);
+	skb = __pskb_copy(skb_o,
+			  skb_headroom(skb_o) + HSR_PRP_HLEN, GFP_ATOMIC);
 	if (!skb)
 		return NULL;
 	skb_reset_mac_header(skb);
 
 	if (skb->ip_summed == CHECKSUM_PARTIAL)
-		skb->csum_start += HSR_HLEN;
+		skb->csum_start += HSR_PRP_HLEN;
 
 	movelen = ETH_HLEN;
 	if (frame->is_vlan)
 		movelen += VLAN_HLEN;
 
 	src = skb_mac_header(skb);
-	dst = skb_push(skb, HSR_HLEN);
+	dst = skb_push(skb, HSR_PRP_HLEN);
 	memmove(dst, src, movelen);
 	skb_reset_mac_header(skb);
 
@@ -180,13 +182,14 @@ static struct sk_buff *create_tagged_skb(struct sk_buff *skb_o,
 /* If the original frame was an HSR tagged frame, just clone it to be sent
  * unchanged. Otherwise, create a private frame especially tagged for 'port'.
  */
-static struct sk_buff *frame_get_tagged_skb(struct hsr_frame_info *frame,
-					    struct hsr_port *port)
+static struct sk_buff *frame_get_tagged_skb(struct hsr_prp_frame_info *frame,
+					    struct hsr_prp_port *port)
 {
 	if (frame->skb_hsr)
 		return skb_clone(frame->skb_hsr, GFP_ATOMIC);
 
-	if (port->type != HSR_PT_SLAVE_A && port->type != HSR_PT_SLAVE_B) {
+	if (port->type != HSR_PRP_PT_SLAVE_A &&
+	    port->type != HSR_PRP_PT_SLAVE_B) {
 		WARN_ONCE(1, "HSR: Bug: trying to create a tagged frame for a non-ring port");
 		return NULL;
 	}
@@ -194,14 +197,14 @@ static struct sk_buff *frame_get_tagged_skb(struct hsr_frame_info *frame,
 	return create_tagged_skb(frame->skb_std, frame, port);
 }
 
-static void hsr_deliver_master(struct sk_buff *skb, struct net_device *dev,
-			       struct hsr_node *node_src)
+static void hsr_prp_deliver_master(struct sk_buff *skb, struct net_device *dev,
+				   struct hsr_prp_node *node_src)
 {
 	bool was_multicast_frame;
 	int res;
 
 	was_multicast_frame = (skb->pkt_type == PACKET_MULTICAST);
-	hsr_addr_subst_source(node_src, skb);
+	hsr_prp_addr_subst_source(node_src, skb);
 	skb_pull(skb, ETH_HLEN);
 	res = netif_rx(skb);
 	if (res == NET_RX_DROP) {
@@ -214,11 +217,11 @@ static void hsr_deliver_master(struct sk_buff *skb, struct net_device *dev,
 	}
 }
 
-static int hsr_xmit(struct sk_buff *skb, struct hsr_port *port,
-		    struct hsr_frame_info *frame)
+static int hsr_prp_xmit(struct sk_buff *skb, struct hsr_prp_port *port,
+			struct hsr_prp_frame_info *frame)
 {
-	if (frame->port_rcv->type == HSR_PT_MASTER) {
-		hsr_addr_subst_dest(frame->node_src, skb, port);
+	if (frame->port_rcv->type == HSR_PRP_PT_MASTER) {
+		hsr_prp_addr_subst_dest(frame->node_src, skb, port);
 
 		/* Address substitution (IEC62439-3 pp 26, 50): replace mac
 		 * address of outgoing frame with that of the outgoing slave's.
@@ -239,37 +242,38 @@ static int hsr_xmit(struct sk_buff *skb, struct hsr_port *port,
  * tags if they're of the non-HSR type (but only after duplicate discard). The
  * master device always strips HSR tags.
  */
-static void hsr_forward_do(struct hsr_frame_info *frame)
+static void hsr_prp_forward_do(struct hsr_prp_frame_info *frame)
 {
-	struct hsr_port *port;
+	struct hsr_prp_port *port;
 	struct sk_buff *skb;
 
-	hsr_for_each_port(frame->port_rcv->priv, port) {
+	hsr_prp_for_each_port(frame->port_rcv->priv, port) {
 		/* Don't send frame back the way it came */
 		if (port == frame->port_rcv)
 			continue;
 
 		/* Don't deliver locally unless we should */
-		if (port->type == HSR_PT_MASTER && !frame->is_local_dest)
+		if (port->type == HSR_PRP_PT_MASTER && !frame->is_local_dest)
 			continue;
 
 		/* Deliver frames directly addressed to us to master only */
-		if (port->type != HSR_PT_MASTER && frame->is_local_exclusive)
+		if (port->type != HSR_PRP_PT_MASTER &&
+		    frame->is_local_exclusive)
 			continue;
 
 		/* Don't send frame over port where it has been sent before */
-		if (hsr_register_frame_out(port, frame->node_src,
-					   frame->sequence_nr))
+		if (hsr_prp_register_frame_out(port, frame->node_src,
+					       frame->sequence_nr))
 			continue;
 
-		if (frame->is_supervision && port->type == HSR_PT_MASTER) {
-			hsr_handle_sup_frame(frame->skb_hsr,
-					     frame->node_src,
-					     frame->port_rcv);
+		if (frame->is_supervision && port->type == HSR_PRP_PT_MASTER) {
+			hsr_prp_handle_sup_frame(frame->skb_hsr,
+						 frame->node_src,
+						 frame->port_rcv);
 			continue;
 		}
 
-		if (port->type != HSR_PT_MASTER)
+		if (port->type != HSR_PRP_PT_MASTER)
 			skb = frame_get_tagged_skb(frame, port);
 		else
 			skb = frame_get_stripped_skb(frame, port);
@@ -279,17 +283,17 @@ static void hsr_forward_do(struct hsr_frame_info *frame)
 		}
 
 		skb->dev = port->dev;
-		if (port->type == HSR_PT_MASTER)
-			hsr_deliver_master(skb, port->dev, frame->node_src);
+		if (port->type == HSR_PRP_PT_MASTER)
+			hsr_prp_deliver_master(skb, port->dev, frame->node_src);
 		else
-			hsr_xmit(skb, port, frame);
+			hsr_prp_xmit(skb, port, frame);
 	}
 }
 
-static void check_local_dest(struct hsr_priv *priv, struct sk_buff *skb,
-			     struct hsr_frame_info *frame)
+static void check_local_dest(struct hsr_prp_priv *priv, struct sk_buff *skb,
+			     struct hsr_prp_frame_info *frame)
 {
-	if (hsr_addr_is_self(priv, eth_hdr(skb)->h_dest)) {
+	if (hsr_prp_addr_is_self(priv, eth_hdr(skb)->h_dest)) {
 		frame->is_local_exclusive = true;
 		skb->pkt_type = PACKET_HOST;
 	} else {
@@ -305,14 +309,14 @@ static void check_local_dest(struct hsr_priv *priv, struct sk_buff *skb,
 	}
 }
 
-static int hsr_fill_frame_info(struct hsr_frame_info *frame,
-			       struct sk_buff *skb, struct hsr_port *port)
+static int fill_frame_info(struct hsr_prp_frame_info *frame,
+			   struct sk_buff *skb, struct hsr_prp_port *port)
 {
 	struct ethhdr *ethhdr;
 	unsigned long irqflags;
 
 	frame->is_supervision = is_supervision_frame(port->priv, skb);
-	frame->node_src = hsr_get_node(port, skb, frame->is_supervision);
+	frame->node_src = hsr_prp_get_node(port, skb, frame->is_supervision);
 	if (!frame->node_src)
 		return -1; /* Unknown node and !is_supervision, or no mem */
 
@@ -345,9 +349,9 @@ static int hsr_fill_frame_info(struct hsr_frame_info *frame,
 }
 
 /* Must be called holding rcu read lock (because of the port parameter) */
-void hsr_forward_skb(struct sk_buff *skb, struct hsr_port *port)
+void hsr_prp_forward_skb(struct sk_buff *skb, struct hsr_prp_port *port)
 {
-	struct hsr_frame_info frame;
+	struct hsr_prp_frame_info frame;
 
 	if (skb_mac_header(skb) != skb->data) {
 		WARN_ONCE(1, "%s:%d: Malformed frame (port_src %s)\n",
@@ -355,14 +359,14 @@ void hsr_forward_skb(struct sk_buff *skb, struct hsr_port *port)
 		goto out_drop;
 	}
 
-	if (hsr_fill_frame_info(&frame, skb, port) < 0)
+	if (fill_frame_info(&frame, skb, port) < 0)
 		goto out_drop;
-	hsr_register_frame_in(frame.node_src, port, frame.sequence_nr);
-	hsr_forward_do(&frame);
+	hsr_prp_register_frame_in(frame.node_src, port, frame.sequence_nr);
+	hsr_prp_forward_do(&frame);
 	/* Gets called for ingress frames as well as egress from master port.
 	 * So check and increment stats for master port only here.
 	 */
-	if (port->type == HSR_PT_MASTER) {
+	if (port->type == HSR_PRP_PT_MASTER) {
 		port->dev->stats.tx_packets++;
 		port->dev->stats.tx_bytes += skb->len;
 	}
diff --git a/net/hsr-prp/hsr_prp_forward.h b/net/hsr-prp/hsr_prp_forward.h
index cbc0704cc14a..75ac419ddaff 100644
--- a/net/hsr-prp/hsr_prp_forward.h
+++ b/net/hsr-prp/hsr_prp_forward.h
@@ -5,12 +5,12 @@
  *	2011-2014 Arvid Brodin, arvid.brodin@alten.se
  */
 
-#ifndef __HSR_FORWARD_H
-#define __HSR_FORWARD_H
+#ifndef __HSR_PRP_FORWARD_H
+#define __HSR_PRP_FORWARD_H
 
 #include <linux/netdevice.h>
 #include "hsr_prp_main.h"
 
-void hsr_forward_skb(struct sk_buff *skb, struct hsr_port *port);
+void hsr_prp_forward_skb(struct sk_buff *skb, struct hsr_prp_port *port);
 
-#endif /* __HSR_FORWARD_H */
+#endif /* __HSR_PRP_FORWARD_H */
diff --git a/net/hsr-prp/hsr_prp_framereg.c b/net/hsr-prp/hsr_prp_framereg.c
index 102b0a85f440..d78d32d513ca 100644
--- a/net/hsr-prp/hsr_prp_framereg.c
+++ b/net/hsr-prp/hsr_prp_framereg.c
@@ -37,11 +37,11 @@ static bool seq_nr_after(u16 a, u16 b)
 #define seq_nr_before(a, b)		seq_nr_after((b), (a))
 #define seq_nr_before_or_eq(a, b)	(!seq_nr_after((a), (b)))
 
-bool hsr_addr_is_self(struct hsr_priv *priv, unsigned char *addr)
+bool hsr_prp_addr_is_self(struct hsr_prp_priv *priv, unsigned char *addr)
 {
-	struct hsr_node *node;
+	struct hsr_prp_node *node;
 
-	node = list_first_or_null_rcu(&priv->self_node_db, struct hsr_node,
+	node = list_first_or_null_rcu(&priv->self_node_db, struct hsr_prp_node,
 				      mac_list);
 	if (!node) {
 		WARN_ONCE(1, "HSR: No self node\n");
@@ -58,10 +58,11 @@ bool hsr_addr_is_self(struct hsr_priv *priv, unsigned char *addr)
 
 /* Search for mac entry. Caller must hold rcu read lock.
  */
-static struct hsr_node *find_node_by_addr_A(struct list_head *node_db,
-					    const unsigned char addr[ETH_ALEN])
+static struct hsr_prp_node *
+find_node_by_addr_A(struct list_head *node_db,
+		    const unsigned char addr[ETH_ALEN])
 {
-	struct hsr_node *node;
+	struct hsr_prp_node *node;
 
 	list_for_each_entry_rcu(node, node_db, mac_list) {
 		if (ether_addr_equal(node->macaddress_A, addr))
@@ -74,12 +75,12 @@ static struct hsr_node *find_node_by_addr_A(struct list_head *node_db,
 /* Helper for device init; the self_node_db is used in hsr_rcv() to recognize
  * frames from self that's been looped over the HSR ring.
  */
-int hsr_create_self_node(struct hsr_priv *priv,
-			 unsigned char addr_a[ETH_ALEN],
-			 unsigned char addr_b[ETH_ALEN])
+int hsr_prp_create_self_node(struct hsr_prp_priv *priv,
+			     unsigned char addr_a[ETH_ALEN],
+			     unsigned char addr_b[ETH_ALEN])
 {
 	struct list_head *self_node_db = &priv->self_node_db;
-	struct hsr_node *node, *oldnode;
+	struct hsr_prp_node *node, *oldnode;
 
 	node = kmalloc(sizeof(*node), GFP_KERNEL);
 	if (!node)
@@ -90,7 +91,7 @@ int hsr_create_self_node(struct hsr_priv *priv,
 
 	spin_lock_bh(&priv->list_lock);
 	oldnode = list_first_or_null_rcu(self_node_db,
-					 struct hsr_node, mac_list);
+					 struct hsr_prp_node, mac_list);
 	if (oldnode) {
 		list_replace_rcu(&oldnode->mac_list, &node->mac_list);
 		spin_unlock_bh(&priv->list_lock);
@@ -103,13 +104,14 @@ int hsr_create_self_node(struct hsr_priv *priv,
 	return 0;
 }
 
-void hsr_del_self_node(struct hsr_priv *priv)
+void hsr_prp_del_self_node(struct hsr_prp_priv *priv)
 {
 	struct list_head *self_node_db = &priv->self_node_db;
-	struct hsr_node *node;
+	struct hsr_prp_node *node;
 
 	spin_lock_bh(&priv->list_lock);
-	node = list_first_or_null_rcu(self_node_db, struct hsr_node, mac_list);
+	node = list_first_or_null_rcu(self_node_db, struct hsr_prp_node,
+				      mac_list);
 	if (node) {
 		list_del_rcu(&node->mac_list);
 		kfree_rcu(node, rcu_head);
@@ -117,10 +119,10 @@ void hsr_del_self_node(struct hsr_priv *priv)
 	spin_unlock_bh(&priv->list_lock);
 }
 
-void hsr_del_nodes(struct list_head *node_db)
+void hsr_prp_del_nodes(struct list_head *node_db)
 {
-	struct hsr_node *node;
-	struct hsr_node *tmp;
+	struct hsr_prp_node *node;
+	struct hsr_prp_node *tmp;
 
 	list_for_each_entry_safe(node, tmp, node_db, mac_list)
 		kfree(node);
@@ -130,12 +132,12 @@ void hsr_del_nodes(struct list_head *node_db)
  * seq_out is used to initialize filtering of outgoing duplicate frames
  * originating from the newly added node.
  */
-static struct hsr_node *hsr_add_node(struct hsr_priv *priv,
-				     struct list_head *node_db,
-				     unsigned char addr[],
-				     u16 seq_out)
+static struct hsr_prp_node *hsr_prp_add_node(struct hsr_prp_priv *priv,
+					     struct list_head *node_db,
+					     unsigned char addr[],
+					     u16 seq_out)
 {
-	struct hsr_node *new_node, *node;
+	struct hsr_prp_node *new_node, *node;
 	unsigned long now;
 	int i;
 
@@ -149,9 +151,9 @@ static struct hsr_node *hsr_add_node(struct hsr_priv *priv,
 	 * as initialization. (0 could trigger an spurious ring error warning).
 	 */
 	now = jiffies;
-	for (i = 0; i < HSR_PT_PORTS; i++)
+	for (i = 0; i < HSR_PRP_PT_PORTS; i++)
 		new_node->time_in[i] = now;
-	for (i = 0; i < HSR_PT_PORTS; i++)
+	for (i = 0; i < HSR_PRP_PT_PORTS; i++)
 		new_node->seq_out[i] = seq_out;
 
 	spin_lock_bh(&priv->list_lock);
@@ -173,12 +175,13 @@ static struct hsr_node *hsr_add_node(struct hsr_priv *priv,
 
 /* Get the hsr_node from which 'skb' was sent.
  */
-struct hsr_node *hsr_get_node(struct hsr_port *port, struct sk_buff *skb,
-			      bool is_sup)
+struct hsr_prp_node *hsr_prp_get_node(struct hsr_prp_port *port,
+				      struct sk_buff *skb,
+				      bool is_sup)
 {
 	struct list_head *node_db = &port->priv->node_db;
-	struct hsr_priv *priv = port->priv;
-	struct hsr_node *node;
+	struct hsr_prp_priv *priv = port->priv;
+	struct hsr_prp_node *node;
 	struct ethhdr *ethhdr;
 	u16 seq_out;
 
@@ -206,24 +209,25 @@ struct hsr_node *hsr_get_node(struct hsr_port *port, struct sk_buff *skb,
 		/* this is called also for frames from master port and
 		 * so warn only for non master ports
 		 */
-		if (port->type != HSR_PT_MASTER)
+		if (port->type != HSR_PRP_PT_MASTER)
 			WARN_ONCE(1, "%s: Non-HSR frame\n", __func__);
-		seq_out = HSR_SEQNR_START;
+		seq_out = HSR_PRP_SEQNR_START;
 	}
 
-	return hsr_add_node(priv, node_db, ethhdr->h_source, seq_out);
+	return hsr_prp_add_node(priv, node_db, ethhdr->h_source, seq_out);
 }
 
 /* Use the Supervision frame's info about an eventual macaddress_B for merging
  * nodes that has previously had their macaddress_B registered as a separate
  * node.
  */
-void hsr_handle_sup_frame(struct sk_buff *skb, struct hsr_node *node_curr,
-			  struct hsr_port *port_rcv)
+void hsr_prp_handle_sup_frame(struct sk_buff *skb,
+			      struct hsr_prp_node *node_curr,
+			      struct hsr_prp_port *port_rcv)
 {
-	struct hsr_priv *priv = port_rcv->priv;
-	struct hsr_sup_payload *hsr_sp;
-	struct hsr_node *node_real;
+	struct hsr_prp_priv *priv = port_rcv->priv;
+	struct hsr_prp_sup_payload *sp;
+	struct hsr_prp_node *node_real;
 	struct list_head *node_db;
 	struct ethhdr *ethhdr;
 	int i;
@@ -238,17 +242,17 @@ void hsr_handle_sup_frame(struct sk_buff *skb, struct hsr_node *node_curr,
 		skb_pull(skb, sizeof(struct hsr_tag));
 
 	/* And leave the HSR sup tag. */
-	skb_pull(skb, sizeof(struct hsr_sup_tag));
+	skb_pull(skb, sizeof(struct hsr_prp_sup_tag));
 
-	hsr_sp = (struct hsr_sup_payload *)skb->data;
+	sp = (struct hsr_prp_sup_payload *)skb->data;
 
 	/* Merge node_curr (registered on macaddress_B) into node_real */
 	node_db = &port_rcv->priv->node_db;
-	node_real = find_node_by_addr_A(node_db, hsr_sp->macaddress_A);
+	node_real = find_node_by_addr_A(node_db, sp->macaddress_A);
 	if (!node_real)
 		/* No frame received from AddrA of this node yet */
-		node_real = hsr_add_node(priv, node_db, hsr_sp->macaddress_A,
-					 HSR_SEQNR_START - 1);
+		node_real = hsr_prp_add_node(priv, node_db, sp->macaddress_A,
+					     HSR_PRP_SEQNR_START - 1);
 	if (!node_real)
 		goto done; /* No mem */
 	if (node_real == node_curr)
@@ -256,7 +260,7 @@ void hsr_handle_sup_frame(struct sk_buff *skb, struct hsr_node *node_curr,
 		goto done;
 
 	ether_addr_copy(node_real->macaddress_B, ethhdr->h_source);
-	for (i = 0; i < HSR_PT_PORTS; i++) {
+	for (i = 0; i < HSR_PRP_PT_PORTS; i++) {
 		if (!node_curr->time_in_stale[i] &&
 		    time_after(node_curr->time_in[i], node_real->time_in[i])) {
 			node_real->time_in[i] = node_curr->time_in[i];
@@ -283,7 +287,7 @@ void hsr_handle_sup_frame(struct sk_buff *skb, struct hsr_node *node_curr,
  * address with that node's "official" address (macaddress_A) so that upper
  * layers recognize where it came from.
  */
-void hsr_addr_subst_source(struct hsr_node *node, struct sk_buff *skb)
+void hsr_prp_addr_subst_source(struct hsr_prp_node *node, struct sk_buff *skb)
 {
 	if (!skb_mac_header_was_set(skb)) {
 		WARN_ONCE(1, "%s: Mac header not set\n", __func__);
@@ -302,10 +306,10 @@ void hsr_addr_subst_source(struct hsr_node *node, struct sk_buff *skb)
  * This is needed to keep the packets flowing through switches that learn on
  * which "side" the different interfaces are.
  */
-void hsr_addr_subst_dest(struct hsr_node *node_src, struct sk_buff *skb,
-			 struct hsr_port *port)
+void hsr_prp_addr_subst_dest(struct hsr_prp_node *node_src, struct sk_buff *skb,
+			     struct hsr_prp_port *port)
 {
-	struct hsr_node *node_dst;
+	struct hsr_prp_node *node_dst;
 
 	if (!skb_mac_header_was_set(skb)) {
 		WARN_ONCE(1, "%s: Mac header not set\n", __func__);
@@ -328,8 +332,9 @@ void hsr_addr_subst_dest(struct hsr_node *node_src, struct sk_buff *skb,
 	ether_addr_copy(eth_hdr(skb)->h_dest, node_dst->macaddress_B);
 }
 
-void hsr_register_frame_in(struct hsr_node *node, struct hsr_port *port,
-			   u16 sequence_nr)
+void hsr_prp_register_frame_in(struct hsr_prp_node *node,
+			       struct hsr_prp_port *port,
+			       u16 sequence_nr)
 {
 	/* Don't register incoming frames without a valid sequence number. This
 	 * ensures entries of restarted nodes gets pruned so that they can
@@ -350,8 +355,9 @@ void hsr_register_frame_in(struct hsr_node *node, struct hsr_port *port,
  *	 0 otherwise, or
  *	 negative error code on error
  */
-int hsr_register_frame_out(struct hsr_port *port, struct hsr_node *node,
-			   u16 sequence_nr)
+int hsr_prp_register_frame_out(struct hsr_prp_port *port,
+			       struct hsr_prp_node *node,
+			       u16 sequence_nr)
 {
 	if (seq_nr_before_or_eq(sequence_nr, node->seq_out[port->type]))
 		return 1;
@@ -360,35 +366,35 @@ int hsr_register_frame_out(struct hsr_port *port, struct hsr_node *node,
 	return 0;
 }
 
-static struct hsr_port *get_late_port(struct hsr_priv *priv,
-				      struct hsr_node *node)
+static struct hsr_prp_port *get_late_port(struct hsr_prp_priv *priv,
+					  struct hsr_prp_node *node)
 {
-	if (node->time_in_stale[HSR_PT_SLAVE_A])
-		return hsr_prp_get_port(priv, HSR_PT_SLAVE_A);
-	if (node->time_in_stale[HSR_PT_SLAVE_B])
-		return hsr_prp_get_port(priv, HSR_PT_SLAVE_B);
-
-	if (time_after(node->time_in[HSR_PT_SLAVE_B],
-		       node->time_in[HSR_PT_SLAVE_A] +
-					msecs_to_jiffies(MAX_SLAVE_DIFF)))
-		return hsr_prp_get_port(priv, HSR_PT_SLAVE_A);
-	if (time_after(node->time_in[HSR_PT_SLAVE_A],
-		       node->time_in[HSR_PT_SLAVE_B] +
-					msecs_to_jiffies(MAX_SLAVE_DIFF)))
-		return hsr_prp_get_port(priv, HSR_PT_SLAVE_B);
+	if (node->time_in_stale[HSR_PRP_PT_SLAVE_A])
+		return hsr_prp_get_port(priv, HSR_PRP_PT_SLAVE_A);
+	if (node->time_in_stale[HSR_PRP_PT_SLAVE_B])
+		return hsr_prp_get_port(priv, HSR_PRP_PT_SLAVE_B);
+
+	if (time_after(node->time_in[HSR_PRP_PT_SLAVE_B],
+		       node->time_in[HSR_PRP_PT_SLAVE_A] +
+				msecs_to_jiffies(HSR_PRP_MAX_SLAVE_DIFF)))
+		return hsr_prp_get_port(priv, HSR_PRP_PT_SLAVE_A);
+	if (time_after(node->time_in[HSR_PRP_PT_SLAVE_A],
+		       node->time_in[HSR_PRP_PT_SLAVE_B] +
+				msecs_to_jiffies(HSR_PRP_MAX_SLAVE_DIFF)))
+		return hsr_prp_get_port(priv, HSR_PRP_PT_SLAVE_B);
 
 	return NULL;
 }
 
 /* Remove stale sequence_nr records. Called by timer every
- * HSR_LIFE_CHECK_INTERVAL (two seconds or so).
+ * HSR_PRP_LIFE_CHECK_INTERVAL (two seconds or so).
  */
-void hsr_prune_nodes(struct timer_list *t)
+void hsr_prp_prune_nodes(struct timer_list *t)
 {
-	struct hsr_priv *priv = from_timer(priv, t, prune_timer);
-	struct hsr_node *node;
-	struct hsr_node *tmp;
-	struct hsr_port *port;
+	struct hsr_prp_priv *priv = from_timer(priv, t, prune_timer);
+	struct hsr_prp_node *node;
+	struct hsr_prp_node *tmp;
+	struct hsr_prp_port *port;
 	unsigned long timestamp;
 	unsigned long time_a, time_b;
 
@@ -399,32 +405,33 @@ void hsr_prune_nodes(struct timer_list *t)
 		 * the master port. Thus the master node will be repeatedly
 		 * pruned leading to packet loss.
 		 */
-		if (hsr_addr_is_self(priv, node->macaddress_A))
+		if (hsr_prp_addr_is_self(priv, node->macaddress_A))
 			continue;
 
 		/* Shorthand */
-		time_a = node->time_in[HSR_PT_SLAVE_A];
-		time_b = node->time_in[HSR_PT_SLAVE_B];
+		time_a = node->time_in[HSR_PRP_PT_SLAVE_A];
+		time_b = node->time_in[HSR_PRP_PT_SLAVE_B];
 
 		/* Check for timestamps old enough to risk wrap-around */
 		if (time_after(jiffies, time_a + MAX_JIFFY_OFFSET / 2))
-			node->time_in_stale[HSR_PT_SLAVE_A] = true;
+			node->time_in_stale[HSR_PRP_PT_SLAVE_A] = true;
 		if (time_after(jiffies, time_b + MAX_JIFFY_OFFSET / 2))
-			node->time_in_stale[HSR_PT_SLAVE_B] = true;
+			node->time_in_stale[HSR_PRP_PT_SLAVE_B] = true;
 
 		/* Get age of newest frame from node.
 		 * At least one time_in is OK here; nodes get pruned long
 		 * before both time_ins can get stale
 		 */
 		timestamp = time_a;
-		if (node->time_in_stale[HSR_PT_SLAVE_A] ||
-		    (!node->time_in_stale[HSR_PT_SLAVE_B] &&
+		if (node->time_in_stale[HSR_PRP_PT_SLAVE_A] ||
+		    (!node->time_in_stale[HSR_PRP_PT_SLAVE_B] &&
 		    time_after(time_b, time_a)))
 			timestamp = time_b;
 
 		/* Warn of ring error only as long as we get frames at all */
 		if (time_is_after_jiffies(timestamp +
-				msecs_to_jiffies(1.5 * MAX_SLAVE_DIFF))) {
+				msecs_to_jiffies(1.5 *
+						 HSR_PRP_MAX_SLAVE_DIFF))) {
 			rcu_read_lock();
 			port = get_late_port(priv, node);
 			if (port)
@@ -435,7 +442,7 @@ void hsr_prune_nodes(struct timer_list *t)
 
 		/* Prune old entries */
 		if (time_is_before_jiffies(timestamp +
-				msecs_to_jiffies(HSR_NODE_FORGET_TIME))) {
+				msecs_to_jiffies(HSR_PRP_NODE_FORGET_TIME))) {
 			hsr_nl_nodedown(priv, node->macaddress_A);
 			list_del_rcu(&node->mac_list);
 			/* Note that we need to free this entry later: */
@@ -449,14 +456,14 @@ void hsr_prune_nodes(struct timer_list *t)
 		  jiffies + msecs_to_jiffies(PRUNE_PERIOD));
 }
 
-void *hsr_get_next_node(struct hsr_priv *priv, void *_pos,
-			unsigned char addr[ETH_ALEN])
+void *hsr_prp_get_next_node(struct hsr_prp_priv *priv, void *_pos,
+			    unsigned char addr[ETH_ALEN])
 {
-	struct hsr_node *node;
+	struct hsr_prp_node *node;
 
 	if (!_pos) {
 		node = list_first_or_null_rcu(&priv->node_db,
-					      struct hsr_node, mac_list);
+					      struct hsr_prp_node, mac_list);
 		if (node)
 			ether_addr_copy(addr, node->macaddress_A);
 		return node;
@@ -471,17 +478,17 @@ void *hsr_get_next_node(struct hsr_priv *priv, void *_pos,
 	return NULL;
 }
 
-int hsr_get_node_data(struct hsr_priv *priv,
-		      const unsigned char *addr,
-		      unsigned char addr_b[ETH_ALEN],
-		      unsigned int *addr_b_ifindex,
-		      int *if1_age,
-		      u16 *if1_seq,
-		      int *if2_age,
-		      u16 *if2_seq)
+int hsr_prp_get_node_data(struct hsr_prp_priv *priv,
+			  const unsigned char *addr,
+			  unsigned char addr_b[ETH_ALEN],
+			  unsigned int *addr_b_ifindex,
+			  int *if1_age,
+			  u16 *if1_seq,
+			  int *if2_age,
+			  u16 *if2_seq)
 {
-	struct hsr_node *node;
-	struct hsr_port *port;
+	struct hsr_prp_node *node;
+	struct hsr_prp_port *port;
 	unsigned long tdiff;
 
 	node = find_node_by_addr_A(&priv->node_db, addr);
@@ -490,8 +497,8 @@ int hsr_get_node_data(struct hsr_priv *priv,
 
 	ether_addr_copy(addr_b, node->macaddress_B);
 
-	tdiff = jiffies - node->time_in[HSR_PT_SLAVE_A];
-	if (node->time_in_stale[HSR_PT_SLAVE_A])
+	tdiff = jiffies - node->time_in[HSR_PRP_PT_SLAVE_A];
+	if (node->time_in_stale[HSR_PRP_PT_SLAVE_A])
 		*if1_age = INT_MAX;
 #if HZ <= MSEC_PER_SEC
 	else if (tdiff > msecs_to_jiffies(INT_MAX))
@@ -500,8 +507,8 @@ int hsr_get_node_data(struct hsr_priv *priv,
 	else
 		*if1_age = jiffies_to_msecs(tdiff);
 
-	tdiff = jiffies - node->time_in[HSR_PT_SLAVE_B];
-	if (node->time_in_stale[HSR_PT_SLAVE_B])
+	tdiff = jiffies - node->time_in[HSR_PRP_PT_SLAVE_B];
+	if (node->time_in_stale[HSR_PRP_PT_SLAVE_B])
 		*if2_age = INT_MAX;
 #if HZ <= MSEC_PER_SEC
 	else if (tdiff > msecs_to_jiffies(INT_MAX))
@@ -511,10 +518,10 @@ int hsr_get_node_data(struct hsr_priv *priv,
 		*if2_age = jiffies_to_msecs(tdiff);
 
 	/* Present sequence numbers as if they were incoming on interface */
-	*if1_seq = node->seq_out[HSR_PT_SLAVE_B];
-	*if2_seq = node->seq_out[HSR_PT_SLAVE_A];
+	*if1_seq = node->seq_out[HSR_PRP_PT_SLAVE_B];
+	*if2_seq = node->seq_out[HSR_PRP_PT_SLAVE_A];
 
-	if (node->addr_B_port != HSR_PT_NONE) {
+	if (node->addr_B_port != HSR_PRP_PT_NONE) {
 		port = hsr_prp_get_port(priv, node->addr_B_port);
 		*addr_b_ifindex = port->dev->ifindex;
 	} else {
diff --git a/net/hsr-prp/hsr_prp_framereg.h b/net/hsr-prp/hsr_prp_framereg.h
index b29b685e444a..be52c55d9b6a 100644
--- a/net/hsr-prp/hsr_prp_framereg.h
+++ b/net/hsr-prp/hsr_prp_framereg.h
@@ -5,58 +5,58 @@
  *	2011-2014 Arvid Brodin, arvid.brodin@alten.se
  */
 
-#ifndef __HSR_FRAMEREG_H
-#define __HSR_FRAMEREG_H
+#ifndef __HSR_PRP_FRAMEREG_H
+#define __HSR_PRP_FRAMEREG_H
 
 #include "hsr_prp_main.h"
 
-struct hsr_node;
+struct hsr_prp_node;
 
-void hsr_del_self_node(struct hsr_priv *priv);
-void hsr_del_nodes(struct list_head *node_db);
-struct hsr_node *hsr_get_node(struct hsr_port *port, struct sk_buff *skb,
-			      bool is_sup);
-void hsr_handle_sup_frame(struct sk_buff *skb, struct hsr_node *node_curr,
-			  struct hsr_port *port);
-bool hsr_addr_is_self(struct hsr_priv *priv, unsigned char *addr);
+void hsr_prp_del_self_node(struct hsr_prp_priv *priv);
+void hsr_prp_del_nodes(struct list_head *node_db);
+struct hsr_prp_node *hsr_prp_get_node(struct hsr_prp_port *port,
+				      struct sk_buff *skb, bool is_sup);
+void hsr_prp_handle_sup_frame(struct sk_buff *skb,
+			      struct hsr_prp_node *node_curr,
+			      struct hsr_prp_port *port);
+bool hsr_prp_addr_is_self(struct hsr_prp_priv *priv, unsigned char *addr);
 
-void hsr_addr_subst_source(struct hsr_node *node, struct sk_buff *skb);
-void hsr_addr_subst_dest(struct hsr_node *node_src, struct sk_buff *skb,
-			 struct hsr_port *port);
+void hsr_prp_addr_subst_source(struct hsr_prp_node *node, struct sk_buff *skb);
+void hsr_prp_addr_subst_dest(struct hsr_prp_node *node_src, struct sk_buff *skb,
+			     struct hsr_prp_port *port);
 
-void hsr_register_frame_in(struct hsr_node *node, struct hsr_port *port,
-			   u16 sequence_nr);
-int hsr_register_frame_out(struct hsr_port *port, struct hsr_node *node,
-			   u16 sequence_nr);
+void hsr_prp_register_frame_in(struct hsr_prp_node *node,
+			       struct hsr_prp_port *port, u16 sequence_nr);
+int hsr_prp_register_frame_out(struct hsr_prp_port *port,
+			       struct hsr_prp_node *node, u16 sequence_nr);
 
-void hsr_prune_nodes(struct timer_list *t);
+void hsr_prp_prune_nodes(struct timer_list *t);
 
-int hsr_create_self_node(struct hsr_priv *priv,
-			 unsigned char addr_a[ETH_ALEN],
-			 unsigned char addr_b[ETH_ALEN]);
+int hsr_prp_create_self_node(struct hsr_prp_priv *priv,
+			     unsigned char addr_a[ETH_ALEN],
+			     unsigned char addr_b[ETH_ALEN]);
 
-void *hsr_get_next_node(struct hsr_priv *priv, void *_pos,
-			unsigned char addr[ETH_ALEN]);
+void *hsr_prp_get_next_node(struct hsr_prp_priv *priv, void *_pos,
+			    unsigned char addr[ETH_ALEN]);
 
-int hsr_get_node_data(struct hsr_priv *priv,
-		      const unsigned char *addr,
-		      unsigned char addr_b[ETH_ALEN],
-		      unsigned int *addr_b_ifindex,
-		      int *if1_age,
-		      u16 *if1_seq,
-		      int *if2_age,
-		      u16 *if2_seq);
+int hsr_prp_get_node_data(struct hsr_prp_priv *priv, const unsigned char *addr,
+			  unsigned char addr_b[ETH_ALEN],
+			  unsigned int *addr_b_ifindex,
+			  int *if1_age,
+			  u16 *if1_seq,
+			  int *if2_age,
+			  u16 *if2_seq);
 
-struct hsr_node {
+struct hsr_prp_node {
 	struct list_head	mac_list;
 	unsigned char		macaddress_A[ETH_ALEN];
 	unsigned char		macaddress_B[ETH_ALEN];
 	/* Local slave through which AddrB frames are received from this node */
-	enum hsr_port_type	addr_B_port;
-	unsigned long		time_in[HSR_PT_PORTS];
-	bool			time_in_stale[HSR_PT_PORTS];
-	u16			seq_out[HSR_PT_PORTS];
+	enum hsr_prp_port_type	addr_B_port;
+	unsigned long		time_in[HSR_PRP_PT_PORTS];
+	bool			time_in_stale[HSR_PRP_PT_PORTS];
+	u16			seq_out[HSR_PRP_PT_PORTS];
 	struct rcu_head		rcu_head;
 };
 
-#endif /* __HSR_FRAMEREG_H */
+#endif /* __HSR_PRP_FRAMEREG_H */
diff --git a/net/hsr-prp/hsr_prp_main.c b/net/hsr-prp/hsr_prp_main.c
index de85f42be6ee..4565744ce1a1 100644
--- a/net/hsr-prp/hsr_prp_main.c
+++ b/net/hsr-prp/hsr_prp_main.c
@@ -15,33 +15,33 @@
 #include "hsr_prp_framereg.h"
 #include "hsr_prp_slave.h"
 
-static bool hsr_slave_empty(struct hsr_priv *priv)
+static bool hsr_prp_slave_empty(struct hsr_prp_priv *priv)
 {
-	struct hsr_port *port;
+	struct hsr_prp_port *port;
 
-	hsr_for_each_port(priv, port)
-		if (port->type != HSR_PT_MASTER)
+	hsr_prp_for_each_port(priv, port)
+		if (port->type != HSR_PRP_PT_MASTER)
 			return false;
 	return true;
 }
 
-static int hsr_netdev_notify(struct notifier_block *nb, unsigned long event,
-			     void *ptr)
+static int hsr_prp_netdev_notify(struct notifier_block *nb, unsigned long event,
+				 void *ptr)
 {
-	struct hsr_port *port, *master;
+	struct hsr_prp_port *port, *master;
 	struct net_device *dev;
-	struct hsr_priv *priv;
+	struct hsr_prp_priv *priv;
 	LIST_HEAD(list_kill);
 	int mtu_max;
 	int res;
 
 	dev = netdev_notifier_info_to_dev(ptr);
-	port = hsr_port_get_rtnl(dev);
+	port = hsr_prp_port_get_rtnl(dev);
 	if (!port) {
-		if (!is_hsr_master(dev))
+		if (!is_hsr_prp_master(dev))
 			return NOTIFY_DONE;	/* Not an HSR device */
 		priv = netdev_priv(dev);
-		port = hsr_prp_get_port(priv, HSR_PT_MASTER);
+		port = hsr_prp_get_port(priv, HSR_PRP_PT_MASTER);
 		if (!port) {
 			/* Resend of notification concerning removed device? */
 			return NOTIFY_DONE;
@@ -54,14 +54,14 @@ static int hsr_netdev_notify(struct notifier_block *nb, unsigned long event,
 	case NETDEV_UP:		/* Administrative state DOWN */
 	case NETDEV_DOWN:	/* Administrative state UP */
 	case NETDEV_CHANGE:	/* Link (carrier) state changes */
-		hsr_check_carrier_and_operstate(priv);
+		hsr_prp_check_carrier_and_operstate(priv);
 		break;
 	case NETDEV_CHANGENAME:
-		if (is_hsr_master(dev))
-			hsr_debugfs_rename(dev);
+		if (is_hsr_prp_master(dev))
+			hsr_prp_debugfs_rename(dev);
 		break;
 	case NETDEV_CHANGEADDR:
-		if (port->type == HSR_PT_MASTER) {
+		if (port->type == HSR_PRP_PT_MASTER) {
 			/* This should not happen since there's no
 			 * ndo_set_mac_address() for HSR devices - i.e. not
 			 * supported.
@@ -69,37 +69,37 @@ static int hsr_netdev_notify(struct notifier_block *nb, unsigned long event,
 			break;
 		}
 
-		master = hsr_prp_get_port(priv, HSR_PT_MASTER);
+		master = hsr_prp_get_port(priv, HSR_PRP_PT_MASTER);
 
-		if (port->type == HSR_PT_SLAVE_A) {
+		if (port->type == HSR_PRP_PT_SLAVE_A) {
 			ether_addr_copy(master->dev->dev_addr, dev->dev_addr);
 			call_netdevice_notifiers(NETDEV_CHANGEADDR,
 						 master->dev);
 		}
 
 		/* Make sure we recognize frames from ourselves in hsr_rcv() */
-		port = hsr_prp_get_port(priv, HSR_PT_SLAVE_B);
-		res = hsr_create_self_node(priv,
-					   master->dev->dev_addr,
-					   port ?
-						port->dev->dev_addr :
-						master->dev->dev_addr);
+		port = hsr_prp_get_port(priv, HSR_PRP_PT_SLAVE_B);
+		res = hsr_prp_create_self_node(priv,
+					       master->dev->dev_addr,
+					       port ? port->dev->dev_addr :
+						      master->dev->dev_addr);
 		if (res)
 			netdev_warn(master->dev,
 				    "Could not update HSR node address.\n");
 		break;
 	case NETDEV_CHANGEMTU:
-		if (port->type == HSR_PT_MASTER)
+		if (port->type == HSR_PRP_PT_MASTER)
 			break; /* Handled in ndo_change_mtu() */
-		mtu_max = hsr_get_max_mtu(port->priv);
-		master = hsr_prp_get_port(port->priv, HSR_PT_MASTER);
+		mtu_max = hsr_prp_get_max_mtu(port->priv);
+		master = hsr_prp_get_port(port->priv, HSR_PRP_PT_MASTER);
 		master->dev->mtu = mtu_max;
 		break;
 	case NETDEV_UNREGISTER:
-		if (!is_hsr_master(dev)) {
-			master = hsr_prp_get_port(port->priv, HSR_PT_MASTER);
-			hsr_del_port(port);
-			if (hsr_slave_empty(master->priv)) {
+		if (!is_hsr_prp_master(dev)) {
+			master = hsr_prp_get_port(port->priv,
+						  HSR_PRP_PT_MASTER);
+			hsr_prp_del_port(port);
+			if (hsr_prp_slave_empty(master->priv)) {
 				unregister_netdevice_queue(master->dev,
 							   &list_kill);
 				unregister_netdevice_many(&list_kill);
@@ -116,25 +116,26 @@ static int hsr_netdev_notify(struct notifier_block *nb, unsigned long event,
 	return NOTIFY_DONE;
 }
 
-struct hsr_port *hsr_prp_get_port(struct hsr_priv *priv, enum hsr_port_type pt)
+struct hsr_prp_port *hsr_prp_get_port(struct hsr_prp_priv *priv,
+				      enum hsr_prp_port_type pt)
 {
-	struct hsr_port *port;
+	struct hsr_prp_port *port;
 
-	hsr_for_each_port(priv, port)
+	hsr_prp_for_each_port(priv, port)
 		if (port->type == pt)
 			return port;
 	return NULL;
 }
 
 static struct notifier_block hsr_nb = {
-	.notifier_call = hsr_netdev_notify,	/* Slave event notifications */
+	.notifier_call = hsr_prp_netdev_notify,	/* Slave event notifications */
 };
 
-static int __init hsr_init(void)
+static int __init hsr_prp_init(void)
 {
 	int res;
 
-	BUILD_BUG_ON(sizeof(struct hsr_tag) != HSR_HLEN);
+	BUILD_BUG_ON(sizeof(struct hsr_tag) != HSR_PRP_HLEN);
 
 	register_netdevice_notifier(&hsr_nb);
 	res = hsr_netlink_init();
@@ -142,13 +143,13 @@ static int __init hsr_init(void)
 	return res;
 }
 
-static void __exit hsr_exit(void)
+static void __exit hsr_prp_exit(void)
 {
 	unregister_netdevice_notifier(&hsr_nb);
 	hsr_netlink_exit();
-	hsr_debugfs_remove_root();
+	hsr_prp_debugfs_remove_root();
 }
 
-module_init(hsr_init);
-module_exit(hsr_exit);
+module_init(hsr_prp_init);
+module_exit(hsr_prp_exit);
 MODULE_LICENSE("GPL");
diff --git a/net/hsr-prp/hsr_prp_main.h b/net/hsr-prp/hsr_prp_main.h
index 5a99d0b12c66..7d9a3e009a2d 100644
--- a/net/hsr-prp/hsr_prp_main.h
+++ b/net/hsr-prp/hsr_prp_main.h
@@ -5,8 +5,8 @@
  *	2011-2014 Arvid Brodin, arvid.brodin@alten.se
  */
 
-#ifndef __HSR_PRIVATE_H
-#define __HSR_PRIVATE_H
+#ifndef __HSR_PRP_MAIN_H
+#define __HSR_PRP_MAIN_H
 
 #include <linux/netdevice.h>
 #include <linux/list.h>
@@ -15,19 +15,19 @@
  * Table 8.
  * All values in milliseconds.
  */
-#define HSR_LIFE_CHECK_INTERVAL		 2000 /* ms */
-#define HSR_NODE_FORGET_TIME		60000 /* ms */
-#define HSR_ANNOUNCE_INTERVAL		  100 /* ms */
+#define HSR_PRP_LIFE_CHECK_INTERVAL		 2000 /* ms */
+#define HSR_PRP_NODE_FORGET_TIME		60000 /* ms */
+#define HSR_PRP_ANNOUNCE_INTERVAL		  100 /* ms */
 
 /* By how much may slave1 and slave2 timestamps of latest received frame from
  * each node differ before we notify of communication problem?
  */
-#define MAX_SLAVE_DIFF			 3000 /* ms */
-#define HSR_SEQNR_START			(USHRT_MAX - 1024)
-#define HSR_SUP_SEQNR_START		(HSR_SEQNR_START / 2)
+#define HSR_PRP_MAX_SLAVE_DIFF			 3000 /* ms */
+#define HSR_PRP_SEQNR_START			(USHRT_MAX - 1024)
+#define HSR_PRP_SUP_SEQNR_START		(HSR_PRP_SEQNR_START / 2)
 
 /* How often shall we check for broken ring and remove node entries older than
- * HSR_NODE_FORGET_TIME?
+ * HSR_PRP_NODE_FORGET_TIME?
  */
 #define PRUNE_PERIOD			 3000 /* ms */
 
@@ -48,7 +48,7 @@ struct hsr_tag {
 	__be16		encap_proto;
 } __packed;
 
-#define HSR_HLEN	6
+#define HSR_PRP_HLEN	6
 
 #define HSR_V1_SUP_LSDUSIZE		52
 
@@ -83,55 +83,56 @@ struct hsr_ethhdr {
 /* HSR Supervision Frame data types.
  * Field names as defined in the IEC:2010 standard for HSR.
  */
-struct hsr_sup_tag {
+struct hsr_prp_sup_tag {
 	__be16		path_and_HSR_ver;
 	__be16		sequence_nr;
 	__u8		HSR_TLV_type;
 	__u8		HSR_TLV_length;
 } __packed;
 
-struct hsr_sup_payload {
+struct hsr_prp_sup_payload {
 	unsigned char	macaddress_A[ETH_ALEN];
 } __packed;
 
-static inline void set_hsr_stag_path(struct hsr_sup_tag *hst, u16 path)
+static inline void set_hsr_stag_path(struct hsr_prp_sup_tag *hst, u16 path)
 {
 	set_hsr_tag_path((struct hsr_tag *)hst, path);
 }
 
-static inline void set_hsr_stag_HSR_ver(struct hsr_sup_tag *hst, u16 HSR_ver)
+static inline void set_hsr_stag_HSR_ver(struct hsr_prp_sup_tag *hst,
+					u16 HSR_ver)
 {
 	set_hsr_tag_LSDU_size((struct hsr_tag *)hst, HSR_ver);
 }
 
 struct hsrv0_ethhdr_sp {
 	struct ethhdr		ethhdr;
-	struct hsr_sup_tag	hsr_sup;
+	struct hsr_prp_sup_tag	hsr_sup;
 } __packed;
 
 struct hsrv1_ethhdr_sp {
 	struct ethhdr		ethhdr;
 	struct hsr_tag		hsr;
-	struct hsr_sup_tag	hsr_sup;
+	struct hsr_prp_sup_tag	hsr_sup;
 } __packed;
 
-enum hsr_port_type {
-	HSR_PT_NONE = 0,	/* Must be 0, used by framereg */
-	HSR_PT_SLAVE_A,
-	HSR_PT_SLAVE_B,
-	HSR_PT_INTERLINK,
-	HSR_PT_MASTER,
-	HSR_PT_PORTS,	/* This must be the last item in the enum */
+enum hsr_prp_port_type {
+	HSR_PRP_PT_NONE = 0,	/* Must be 0, used by framereg */
+	HSR_PRP_PT_SLAVE_A,
+	HSR_PRP_PT_SLAVE_B,
+	HSR_PRP_PT_INTERLINK,
+	HSR_PRP_PT_MASTER,
+	HSR_PRP_PT_PORTS,	/* This must be the last item in the enum */
 };
 
-struct hsr_port {
+struct hsr_prp_port {
 	struct list_head	port_list;
 	struct net_device	*dev;
-	struct hsr_priv		*priv;
-	enum hsr_port_type	type;
+	struct hsr_prp_priv	*priv;
+	enum hsr_prp_port_type	type;
 };
 
-struct hsr_priv {
+struct hsr_prp_priv {
 	struct rcu_head		rcu_head;
 	struct list_head	ports;
 	struct list_head	node_db;	/* Known HSR nodes */
@@ -150,10 +151,11 @@ struct hsr_priv {
 #endif
 };
 
-#define hsr_for_each_port(priv, port) \
+#define hsr_prp_for_each_port(priv, port) \
 	list_for_each_entry_rcu((port), &(priv)->ports, port_list)
 
-struct hsr_port *hsr_prp_get_port(struct hsr_priv *priv, enum hsr_port_type pt);
+struct hsr_prp_port *hsr_prp_get_port(struct hsr_prp_priv *priv,
+				      enum hsr_prp_port_type pt);
 
 /* Caller must ensure skb is a valid HSR frame */
 static inline u16 hsr_get_skb_sequence_nr(struct sk_buff *skb)
@@ -165,24 +167,29 @@ static inline u16 hsr_get_skb_sequence_nr(struct sk_buff *skb)
 }
 
 #if IS_ENABLED(CONFIG_DEBUG_FS)
-void hsr_debugfs_rename(struct net_device *dev);
-void hsr_debugfs_init(struct hsr_priv *priv, struct net_device *hsr_dev);
-void hsr_debugfs_term(struct hsr_priv *priv);
-void hsr_debugfs_create_root(void);
-void hsr_debugfs_remove_root(void);
+void hsr_prp_debugfs_rename(struct net_device *dev);
+void hsr_prp_debugfs_init(struct hsr_prp_priv *priv, struct net_device *ndev);
+void hsr_prp_debugfs_term(struct hsr_prp_priv *priv);
+void hsr_prp_debugfs_create_root(void);
+void hsr_prp_debugfs_remove_root(void);
 #else
-static inline void hsr_debugfs_rename(struct net_device *dev)
+static inline void hsr_prp_debugfs_rename(struct net_device *dev)
 {
 }
-static inline void hsr_debugfs_init(struct hsr_priv *priv,
-				    struct net_device *hsr_dev)
+
+static inline void hsr_prp_debugfs_init(struct hsr_prp_priv *priv,
+					struct net_device *ndev)
 {}
-static inline void hsr_debugfs_term(struct hsr_priv *priv)
+
+static inline void hsr_prp_debugfs_term(struct hsr_prp_priv *priv)
 {}
+
 static inline void hsr_debugfs_create_root(void)
 {}
+
 static inline void hsr_debugfs_remove_root(void)
 {}
+
 #endif
 
-#endif /*  __HSR_PRIVATE_H */
+#endif /*  __HSR_PRP_MAIN_H */
diff --git a/net/hsr-prp/hsr_prp_slave.c b/net/hsr-prp/hsr_prp_slave.c
index 2c8832bf7a5f..63a8dafa1f68 100644
--- a/net/hsr-prp/hsr_prp_slave.c
+++ b/net/hsr-prp/hsr_prp_slave.c
@@ -14,10 +14,10 @@
 #include "hsr_prp_forward.h"
 #include "hsr_prp_framereg.h"
 
-static rx_handler_result_t hsr_handle_frame(struct sk_buff **pskb)
+static rx_handler_result_t hsr_prp_handle_frame(struct sk_buff **pskb)
 {
 	struct sk_buff *skb = *pskb;
-	struct hsr_port *port;
+	struct hsr_prp_port *port;
 	__be16 protocol;
 
 	if (!skb_mac_header_was_set(skb)) {
@@ -25,11 +25,11 @@ static rx_handler_result_t hsr_handle_frame(struct sk_buff **pskb)
 		return RX_HANDLER_PASS;
 	}
 
-	port = hsr_port_get_rcu(skb->dev);
+	port = hsr_prp_port_get_rcu(skb->dev);
 	if (!port)
 		goto finish_pass;
 
-	if (hsr_addr_is_self(port->priv, eth_hdr(skb)->h_source)) {
+	if (hsr_prp_addr_is_self(port->priv, eth_hdr(skb)->h_source)) {
 		/* Directly kill frames sent by ourselves */
 		kfree_skb(skb);
 		goto finish_consume;
@@ -41,7 +41,7 @@ static rx_handler_result_t hsr_handle_frame(struct sk_buff **pskb)
 
 	skb_push(skb, ETH_HLEN);
 
-	hsr_forward_skb(skb, port);
+	hsr_prp_forward_skb(skb, port);
 
 finish_consume:
 	return RX_HANDLER_CONSUMED;
@@ -50,13 +50,13 @@ static rx_handler_result_t hsr_handle_frame(struct sk_buff **pskb)
 	return RX_HANDLER_PASS;
 }
 
-bool hsr_port_exists(const struct net_device *dev)
+bool hsr_prp_port_exists(const struct net_device *dev)
 {
-	return rcu_access_pointer(dev->rx_handler) == hsr_handle_frame;
+	return rcu_access_pointer(dev->rx_handler) == hsr_prp_handle_frame;
 }
 
-static int hsr_check_dev_ok(struct net_device *dev,
-			    struct netlink_ext_ack *extack)
+static int hsr_prp_check_dev_ok(struct net_device *dev,
+				struct netlink_ext_ack *extack)
 {
 	/* Don't allow HSR on non-ethernet like devices */
 	if ((dev->flags & IFF_LOOPBACK) || dev->type != ARPHRD_ETHER ||
@@ -66,13 +66,13 @@ static int hsr_check_dev_ok(struct net_device *dev,
 	}
 
 	/* Don't allow enslaving hsr devices */
-	if (is_hsr_master(dev)) {
+	if (is_hsr_prp_master(dev)) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Cannot create trees of HSR devices.");
 		return -EINVAL;
 	}
 
-	if (hsr_port_exists(dev)) {
+	if (hsr_prp_port_exists(dev)) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "This device is already a HSR slave.");
 		return -EINVAL;
@@ -97,27 +97,28 @@ static int hsr_check_dev_ok(struct net_device *dev,
 }
 
 /* Setup device to be added to the HSR bridge. */
-static int hsr_portdev_setup(struct hsr_priv *priv, struct net_device *dev,
-			     struct hsr_port *port,
-			     struct netlink_ext_ack *extack)
+static int hsr_prp_portdev_setup(struct hsr_prp_priv *priv,
+				 struct net_device *dev,
+				 struct hsr_prp_port *port,
+				 struct netlink_ext_ack *extack)
 
 {
-	struct net_device *hsr_dev;
-	struct hsr_port *master;
+	struct net_device *hsr_prp_dev;
+	struct hsr_prp_port *master;
 	int res;
 
 	res = dev_set_promiscuity(dev, 1);
 	if (res)
 		return res;
 
-	master = hsr_prp_get_port(priv, HSR_PT_MASTER);
-	hsr_dev = master->dev;
+	master = hsr_prp_get_port(priv, HSR_PRP_PT_MASTER);
+	hsr_prp_dev = master->dev;
 
-	res = netdev_upper_dev_link(dev, hsr_dev, extack);
+	res = netdev_upper_dev_link(dev, hsr_prp_dev, extack);
 	if (res)
 		goto fail_upper_dev_link;
 
-	res = netdev_rx_handler_register(dev, hsr_handle_frame, port);
+	res = netdev_rx_handler_register(dev, hsr_prp_handle_frame, port);
 	if (res)
 		goto fail_rx_handler;
 	dev_disable_lro(dev);
@@ -125,20 +126,21 @@ static int hsr_portdev_setup(struct hsr_priv *priv, struct net_device *dev,
 	return 0;
 
 fail_rx_handler:
-	netdev_upper_dev_unlink(dev, hsr_dev);
+	netdev_upper_dev_unlink(dev, hsr_prp_dev);
 fail_upper_dev_link:
 	dev_set_promiscuity(dev, -1);
 	return res;
 }
 
-int hsr_add_port(struct hsr_priv *priv, struct net_device *dev,
-		 enum hsr_port_type type, struct netlink_ext_ack *extack)
+int hsr_prp_add_port(struct hsr_prp_priv *priv, struct net_device *dev,
+		     enum hsr_prp_port_type type,
+		     struct netlink_ext_ack *extack)
 {
-	struct hsr_port *port, *master;
+	struct hsr_prp_port *port, *master;
 	int res;
 
-	if (type != HSR_PT_MASTER) {
-		res = hsr_check_dev_ok(dev, extack);
+	if (type != HSR_PRP_PT_MASTER) {
+		res = hsr_prp_check_dev_ok(dev, extack);
 		if (res)
 			return res;
 	}
@@ -155,8 +157,8 @@ int hsr_add_port(struct hsr_priv *priv, struct net_device *dev,
 	port->dev = dev;
 	port->type = type;
 
-	if (type != HSR_PT_MASTER) {
-		res = hsr_portdev_setup(priv, dev, port, extack);
+	if (type != HSR_PRP_PT_MASTER) {
+		res = hsr_prp_portdev_setup(priv, dev, port, extack);
 		if (res)
 			goto fail_dev_setup;
 	}
@@ -164,9 +166,9 @@ int hsr_add_port(struct hsr_priv *priv, struct net_device *dev,
 	list_add_tail_rcu(&port->port_list, &priv->ports);
 	synchronize_rcu();
 
-	master = hsr_prp_get_port(priv, HSR_PT_MASTER);
+	master = hsr_prp_get_port(priv, HSR_PRP_PT_MASTER);
 	netdev_update_features(master->dev);
-	dev_set_mtu(master->dev, hsr_get_max_mtu(priv));
+	dev_set_mtu(master->dev, hsr_prp_get_max_mtu(priv));
 
 	return 0;
 
@@ -175,18 +177,18 @@ int hsr_add_port(struct hsr_priv *priv, struct net_device *dev,
 	return res;
 }
 
-void hsr_del_port(struct hsr_port *port)
+void hsr_prp_del_port(struct hsr_prp_port *port)
 {
-	struct hsr_priv *priv;
-	struct hsr_port *master;
+	struct hsr_prp_priv *priv;
+	struct hsr_prp_port *master;
 
 	priv = port->priv;
-	master = hsr_prp_get_port(priv, HSR_PT_MASTER);
+	master = hsr_prp_get_port(priv, HSR_PRP_PT_MASTER);
 	list_del_rcu(&port->port_list);
 
 	if (port != master) {
 		netdev_update_features(master->dev);
-		dev_set_mtu(master->dev, hsr_get_max_mtu(priv));
+		dev_set_mtu(master->dev, hsr_prp_get_max_mtu(priv));
 		netdev_rx_handler_unregister(port->dev);
 		dev_set_promiscuity(port->dev, -1);
 		netdev_upper_dev_unlink(port->dev, master->dev);
diff --git a/net/hsr-prp/hsr_prp_slave.h b/net/hsr-prp/hsr_prp_slave.h
index 85f292d88845..e12f3224ef16 100644
--- a/net/hsr-prp/hsr_prp_slave.h
+++ b/net/hsr-prp/hsr_prp_slave.h
@@ -4,30 +4,34 @@
  *	2011-2014 Arvid Brodin, arvid.brodin@alten.se
  */
 
-#ifndef __HSR_SLAVE_H
-#define __HSR_SLAVE_H
+#ifndef __HSR_PRP_SLAVE_H
+#define __HSR_PRP_SLAVE_H
 
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
 #include <linux/rtnetlink.h>
 #include "hsr_prp_main.h"
 
-int hsr_add_port(struct hsr_priv *priv, struct net_device *dev,
-		 enum hsr_port_type pt, struct netlink_ext_ack *extack);
-void hsr_del_port(struct hsr_port *port);
-bool hsr_port_exists(const struct net_device *dev);
+int hsr_prp_add_port(struct hsr_prp_priv *hsr, struct net_device *dev,
+		     enum hsr_prp_port_type pt, struct netlink_ext_ack *extack);
+void hsr_prp_del_port(struct hsr_prp_port *port);
+bool hsr_prp_port_exists(const struct net_device *dev);
 
-static inline struct hsr_port *hsr_port_get_rtnl(const struct net_device *dev)
+static inline
+struct hsr_prp_port *hsr_prp_port_get_rtnl(const struct net_device *dev)
 {
 	ASSERT_RTNL();
-	return hsr_port_exists(dev) ?
-				rtnl_dereference(dev->rx_handler_data) : NULL;
+	return hsr_prp_port_exists(dev) ?
+				   rtnl_dereference(dev->rx_handler_data) :
+				   NULL;
 }
 
-static inline struct hsr_port *hsr_port_get_rcu(const struct net_device *dev)
+static inline
+struct hsr_prp_port *hsr_prp_port_get_rcu(const struct net_device *dev)
 {
-	return hsr_port_exists(dev) ?
-				rcu_dereference(dev->rx_handler_data) : NULL;
+	return hsr_prp_port_exists(dev) ?
+				   rcu_dereference(dev->rx_handler_data) :
+				   NULL;
 }
 
-#endif /* __HSR_SLAVE_H */
+#endif /* __HSR_PRP_SLAVE_H */
-- 
2.17.1

