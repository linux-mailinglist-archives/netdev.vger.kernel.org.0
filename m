Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 118F24AA9B8
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 16:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380199AbiBEPkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Feb 2022 10:40:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378892AbiBEPkt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Feb 2022 10:40:49 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D335CC061348
        for <netdev@vger.kernel.org>; Sat,  5 Feb 2022 07:40:47 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id l13so7701433plg.9
        for <netdev@vger.kernel.org>; Sat, 05 Feb 2022 07:40:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Hn9n6eZepz2HeOoFpC1qT8EY1DaXJ1yMoDVWGfd8ntY=;
        b=XNzHbTvZ9dNjDjF+lF2qIWbC7+SrfE4Ao24XVEcr9iY+P96DBGdn10QT8+rXSaE36r
         FmiDk7fPfaL+sZFUiaOSmuz2ruv9cGwRFgWUXWMHVDzVvvtH7vMLBKMoZG+CVItZlVXL
         1gYLSCLIikT2Jvxwdj7v/km1kT6KqA081NprQ+wA0UfdVkL6MgkzFrKLf/QCGsUN3j+S
         cb7J7nurCn/SIuMRSg0ybJwBU4xeFfhjagG0dCfPjJz62mXPEzdOCgJv5TjugpTeGmZd
         Ob2on1nVxDAbJFGEKy/JjWHbNzuvMmuRMrwf8f+XmgybZrY1VTo+Fs3m2gxXn9Zny3iO
         IMdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Hn9n6eZepz2HeOoFpC1qT8EY1DaXJ1yMoDVWGfd8ntY=;
        b=DVR5S5TTsImc0jWvK/GQ2n6cAeRA/egTSlwGz7gTrornMCpT48bkeMbw+s+QHC9ajn
         7IEWVxGD0t4/czkGFA/e3vzKfbiM7B7460qEXf65JsVUS1aoVYO0v0t2wJgQ9tvilMrt
         I495jm3kB0Aj20oSNcdgD9+FQl+ErMNRdd0yh42eGV3Ci87G0Xkh3oZHXrKRDoPB1A4m
         sJqXFM2hTEpJMf1OBH3U+uo81WU8+FuYunARO+Fb7aCRvYNfAKL+g+H370hWim+8T2yR
         zydkjsparUiIOJymU5y5CrrUcNRMtA76lfOTmgylHHBcfP/CrNFxAjNy2A0mdYj3bdQU
         FlNQ==
X-Gm-Message-State: AOAM533lDW2kxQLfW8tqcdIuhNvaQa+0l76DWFAqywVf1A1OA0ov+tRB
        JHRog0xqvDumn/9yibQf23sz8ootIBHeHgl1lx0=
X-Google-Smtp-Source: ABdhPJwjEtN7hSbmPhBGG4WH3UxlX5Rfaoe8Pcor2O4IgFZHa3Kpg3y94qM19sasoogjMSCzS9umPA==
X-Received: by 2002:a17:90a:5d8d:: with SMTP id t13mr2482672pji.163.1644075646985;
        Sat, 05 Feb 2022 07:40:46 -0800 (PST)
Received: from localhost.localdomain ([58.76.185.115])
        by smtp.gmail.com with ESMTPSA id 207sm4220928pgh.32.2022.02.05.07.40.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Feb 2022 07:40:46 -0800 (PST)
From:   Juhee Kang <claudiajkang@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ennoerlangen@gmail.com, george.mccollister@gmail.com,
        olteanv@gmail.com, marco.wenzel@a-eberle.de,
        xiong.zhenwu@zte.com.cn
Subject: [PATCH v4 net-next] net: hsr: use hlist_head instead of list_head for mac addresses
Date:   Sat,  5 Feb 2022 15:40:38 +0000
Message-Id: <20220205154038.2345-1-claudiajkang@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, HSR manages mac addresses of known HSR nodes by using list_head.
It takes a lot of time when there are a lot of registered nodes due to
finding specific mac address nodes by using linear search. We can be
reducing the time by using hlist. Thus, this patch moves list_head to
hlist_head for mac addresses and this allows for further improvement of
network performance.

    Condition: registered 10,000 known HSR nodes
    Before:
    # iperf3 -c 192.168.10.1 -i 1 -t 10
    Connecting to host 192.168.10.1, port 5201
    [  5] local 192.168.10.2 port 59442 connected to 192.168.10.1 port 5201
    [ ID] Interval           Transfer     Bitrate         Retr  Cwnd
    [  5]   0.00-1.49   sec  3.75 MBytes  21.1 Mbits/sec    0    158 KBytes
    [  5]   1.49-2.05   sec  1.25 MBytes  18.7 Mbits/sec    0    166 KBytes
    [  5]   2.05-3.06   sec  2.44 MBytes  20.3 Mbits/sec   56   16.9 KBytes
    [  5]   3.06-4.08   sec  1.43 MBytes  11.7 Mbits/sec   11   38.0 KBytes
    [  5]   4.08-5.00   sec   951 KBytes  8.49 Mbits/sec    0   56.3 KBytes

    After:
    # iperf3 -c 192.168.10.1 -i 1 -t 10
    Connecting to host 192.168.10.1, port 5201
    [  5] local 192.168.10.2 port 36460 connected to 192.168.10.1 port 5201
    [ ID] Interval           Transfer     Bitrate         Retr  Cwnd
    [  5]   0.00-1.00   sec  7.39 MBytes  62.0 Mbits/sec    3    130 KBytes
    [  5]   1.00-2.00   sec  5.06 MBytes  42.4 Mbits/sec   16    113 KBytes
    [  5]   2.00-3.00   sec  8.58 MBytes  72.0 Mbits/sec   42   94.3 KBytes
    [  5]   3.00-4.00   sec  7.44 MBytes  62.4 Mbits/sec    2    131 KBytes
    [  5]   4.00-5.07   sec  8.13 MBytes  63.5 Mbits/sec   38   92.9 KBytes

Signed-off-by: Juhee Kang <claudiajkang@gmail.com>
---
v4:
 - fix indent warnings

v3:
 - rebase current net-next tree

v2:
 - fix rcu warning

 net/hsr/hsr_debugfs.c  |  40 +++++----
 net/hsr/hsr_device.c   |  10 ++-
 net/hsr/hsr_forward.c  |   7 +-
 net/hsr/hsr_framereg.c | 200 ++++++++++++++++++++++++-----------------
 net/hsr/hsr_framereg.h |   8 +-
 net/hsr/hsr_main.h     |   9 +-
 net/hsr/hsr_netlink.c  |   4 +-
 7 files changed, 171 insertions(+), 107 deletions(-)

diff --git a/net/hsr/hsr_debugfs.c b/net/hsr/hsr_debugfs.c
index 99f3af1a9d4d..fe6094e9a2db 100644
--- a/net/hsr/hsr_debugfs.c
+++ b/net/hsr/hsr_debugfs.c
@@ -17,6 +17,7 @@
 #include <linux/module.h>
 #include <linux/errno.h>
 #include <linux/debugfs.h>
+#include <linux/jhash.h>
 #include "hsr_main.h"
 #include "hsr_framereg.h"
 
@@ -28,6 +29,7 @@ hsr_node_table_show(struct seq_file *sfp, void *data)
 {
 	struct hsr_priv *priv = (struct hsr_priv *)sfp->private;
 	struct hsr_node *node;
+	int i;
 
 	seq_printf(sfp, "Node Table entries for (%s) device\n",
 		   (priv->prot_version == PRP_V1 ? "PRP" : "HSR"));
@@ -39,22 +41,28 @@ hsr_node_table_show(struct seq_file *sfp, void *data)
 		seq_puts(sfp, "DAN-H\n");
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(node, &priv->node_db, mac_list) {
-		/* skip self node */
-		if (hsr_addr_is_self(priv, node->macaddress_A))
-			continue;
-		seq_printf(sfp, "%pM ", &node->macaddress_A[0]);
-		seq_printf(sfp, "%pM ", &node->macaddress_B[0]);
-		seq_printf(sfp, "%10lx, ", node->time_in[HSR_PT_SLAVE_A]);
-		seq_printf(sfp, "%10lx, ", node->time_in[HSR_PT_SLAVE_B]);
-		seq_printf(sfp, "%14x, ", node->addr_B_port);
-
-		if (priv->prot_version == PRP_V1)
-			seq_printf(sfp, "%5x, %5x, %5x\n",
-				   node->san_a, node->san_b,
-				   (node->san_a == 0 && node->san_b == 0));
-		else
-			seq_printf(sfp, "%5x\n", 1);
+
+	for (i = 0 ; i < priv->hash_buckets; i++) {
+		hlist_for_each_entry_rcu(node, &priv->node_db[i], mac_list) {
+			/* skip self node */
+			if (hsr_addr_is_self(priv, node->macaddress_A))
+				continue;
+			seq_printf(sfp, "%pM ", &node->macaddress_A[0]);
+			seq_printf(sfp, "%pM ", &node->macaddress_B[0]);
+			seq_printf(sfp, "%10lx, ",
+				   node->time_in[HSR_PT_SLAVE_A]);
+			seq_printf(sfp, "%10lx, ",
+				   node->time_in[HSR_PT_SLAVE_B]);
+			seq_printf(sfp, "%14x, ", node->addr_B_port);
+
+			if (priv->prot_version == PRP_V1)
+				seq_printf(sfp, "%5x, %5x, %5x\n",
+					   node->san_a, node->san_b,
+					   (node->san_a == 0 &&
+					    node->san_b == 0));
+			else
+				seq_printf(sfp, "%5x\n", 1);
+		}
 	}
 	rcu_read_unlock();
 	return 0;
diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index e57fdad9ef94..7f250216433d 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -485,12 +485,16 @@ int hsr_dev_finalize(struct net_device *hsr_dev, struct net_device *slave[2],
 {
 	bool unregister = false;
 	struct hsr_priv *hsr;
-	int res;
+	int res, i;
 
 	hsr = netdev_priv(hsr_dev);
 	INIT_LIST_HEAD(&hsr->ports);
-	INIT_LIST_HEAD(&hsr->node_db);
-	INIT_LIST_HEAD(&hsr->self_node_db);
+	INIT_HLIST_HEAD(&hsr->self_node_db);
+	hsr->hash_buckets = HSR_HSIZE;
+	get_random_bytes(&hsr->hash_seed, sizeof(hsr->hash_seed));
+	for (i = 0; i < hsr->hash_buckets; i++)
+		INIT_HLIST_HEAD(&hsr->node_db[i]);
+
 	spin_lock_init(&hsr->list_lock);
 
 	eth_hw_addr_set(hsr_dev, slave[0]->dev_addr);
diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
index e59cbb4f0cd1..5bf357734b11 100644
--- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -570,20 +570,23 @@ static int fill_frame_info(struct hsr_frame_info *frame,
 	struct ethhdr *ethhdr;
 	__be16 proto;
 	int ret;
+	u32 hash;
 
 	/* Check if skb contains ethhdr */
 	if (skb->mac_len < sizeof(struct ethhdr))
 		return -EINVAL;
 
 	memset(frame, 0, sizeof(*frame));
+
+	ethhdr = (struct ethhdr *)skb_mac_header(skb);
+	hash = hsr_mac_hash(port->hsr, ethhdr->h_source);
 	frame->is_supervision = is_supervision_frame(port->hsr, skb);
-	frame->node_src = hsr_get_node(port, &hsr->node_db, skb,
+	frame->node_src = hsr_get_node(port, &hsr->node_db[hash], skb,
 				       frame->is_supervision,
 				       port->type);
 	if (!frame->node_src)
 		return -1; /* Unknown node and !is_supervision, or no mem */
 
-	ethhdr = (struct ethhdr *)skb_mac_header(skb);
 	frame->is_vlan = false;
 	proto = ethhdr->h_proto;
 
diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
index 0775f0f95dbf..b3c6ffa1894d 100644
--- a/net/hsr/hsr_framereg.c
+++ b/net/hsr/hsr_framereg.c
@@ -15,11 +15,28 @@
 #include <linux/etherdevice.h>
 #include <linux/slab.h>
 #include <linux/rculist.h>
+#include <linux/jhash.h>
 #include "hsr_main.h"
 #include "hsr_framereg.h"
 #include "hsr_netlink.h"
 
-/*	TODO: use hash lists for mac addresses (linux/jhash.h)?    */
+u32 hsr_mac_hash(struct hsr_priv *hsr, const unsigned char *addr)
+{
+	u32 hash = jhash(addr, ETH_ALEN, hsr->hash_seed);
+
+	return reciprocal_scale(hash, hsr->hash_buckets);
+}
+
+struct hsr_node *hsr_node_get_first(struct hlist_head *head)
+{
+	struct hlist_node *first;
+
+	first = rcu_dereference(hlist_first_rcu(head));
+	if (first)
+		return hlist_entry(first, struct hsr_node, mac_list);
+
+	return NULL;
+}
 
 /* seq_nr_after(a, b) - return true if a is after (higher in sequence than) b,
  * false otherwise.
@@ -42,8 +59,7 @@ bool hsr_addr_is_self(struct hsr_priv *hsr, unsigned char *addr)
 {
 	struct hsr_node *node;
 
-	node = list_first_or_null_rcu(&hsr->self_node_db, struct hsr_node,
-				      mac_list);
+	node = hsr_node_get_first(&hsr->self_node_db);
 	if (!node) {
 		WARN_ONCE(1, "HSR: No self node\n");
 		return false;
@@ -59,12 +75,12 @@ bool hsr_addr_is_self(struct hsr_priv *hsr, unsigned char *addr)
 
 /* Search for mac entry. Caller must hold rcu read lock.
  */
-static struct hsr_node *find_node_by_addr_A(struct list_head *node_db,
+static struct hsr_node *find_node_by_addr_A(struct hlist_head *node_db,
 					    const unsigned char addr[ETH_ALEN])
 {
 	struct hsr_node *node;
 
-	list_for_each_entry_rcu(node, node_db, mac_list) {
+	hlist_for_each_entry_rcu(node, node_db, mac_list) {
 		if (ether_addr_equal(node->macaddress_A, addr))
 			return node;
 	}
@@ -79,7 +95,7 @@ int hsr_create_self_node(struct hsr_priv *hsr,
 			 const unsigned char addr_a[ETH_ALEN],
 			 const unsigned char addr_b[ETH_ALEN])
 {
-	struct list_head *self_node_db = &hsr->self_node_db;
+	struct hlist_head *self_node_db = &hsr->self_node_db;
 	struct hsr_node *node, *oldnode;
 
 	node = kmalloc(sizeof(*node), GFP_KERNEL);
@@ -90,14 +106,13 @@ int hsr_create_self_node(struct hsr_priv *hsr,
 	ether_addr_copy(node->macaddress_B, addr_b);
 
 	spin_lock_bh(&hsr->list_lock);
-	oldnode = list_first_or_null_rcu(self_node_db,
-					 struct hsr_node, mac_list);
+	oldnode = hsr_node_get_first(self_node_db);
 	if (oldnode) {
-		list_replace_rcu(&oldnode->mac_list, &node->mac_list);
+		hlist_replace_rcu(&oldnode->mac_list, &node->mac_list);
 		spin_unlock_bh(&hsr->list_lock);
 		kfree_rcu(oldnode, rcu_head);
 	} else {
-		list_add_tail_rcu(&node->mac_list, self_node_db);
+		hlist_add_tail_rcu(&node->mac_list, self_node_db);
 		spin_unlock_bh(&hsr->list_lock);
 	}
 
@@ -106,25 +121,25 @@ int hsr_create_self_node(struct hsr_priv *hsr,
 
 void hsr_del_self_node(struct hsr_priv *hsr)
 {
-	struct list_head *self_node_db = &hsr->self_node_db;
+	struct hlist_head *self_node_db = &hsr->self_node_db;
 	struct hsr_node *node;
 
 	spin_lock_bh(&hsr->list_lock);
-	node = list_first_or_null_rcu(self_node_db, struct hsr_node, mac_list);
+	node = hsr_node_get_first(self_node_db);
 	if (node) {
-		list_del_rcu(&node->mac_list);
+		hlist_del_rcu(&node->mac_list);
 		kfree_rcu(node, rcu_head);
 	}
 	spin_unlock_bh(&hsr->list_lock);
 }
 
-void hsr_del_nodes(struct list_head *node_db)
+void hsr_del_nodes(struct hlist_head *node_db)
 {
 	struct hsr_node *node;
-	struct hsr_node *tmp;
+	struct hlist_node *tmp;
 
-	list_for_each_entry_safe(node, tmp, node_db, mac_list)
-		kfree(node);
+	hlist_for_each_entry_safe(node, tmp, node_db, mac_list)
+		kfree_rcu(node, rcu_head);
 }
 
 void prp_handle_san_frame(bool san, enum hsr_port_type port,
@@ -145,7 +160,7 @@ void prp_handle_san_frame(bool san, enum hsr_port_type port,
  * originating from the newly added node.
  */
 static struct hsr_node *hsr_add_node(struct hsr_priv *hsr,
-				     struct list_head *node_db,
+				     struct hlist_head *node_db,
 				     unsigned char addr[],
 				     u16 seq_out, bool san,
 				     enum hsr_port_type rx_port)
@@ -175,14 +190,14 @@ static struct hsr_node *hsr_add_node(struct hsr_priv *hsr,
 		hsr->proto_ops->handle_san_frame(san, rx_port, new_node);
 
 	spin_lock_bh(&hsr->list_lock);
-	list_for_each_entry_rcu(node, node_db, mac_list,
-				lockdep_is_held(&hsr->list_lock)) {
+	hlist_for_each_entry_rcu(node, node_db, mac_list,
+				 lockdep_is_held(&hsr->list_lock)) {
 		if (ether_addr_equal(node->macaddress_A, addr))
 			goto out;
 		if (ether_addr_equal(node->macaddress_B, addr))
 			goto out;
 	}
-	list_add_tail_rcu(&new_node->mac_list, node_db);
+	hlist_add_tail_rcu(&new_node->mac_list, node_db);
 	spin_unlock_bh(&hsr->list_lock);
 	return new_node;
 out:
@@ -202,7 +217,7 @@ void prp_update_san_info(struct hsr_node *node, bool is_sup)
 
 /* Get the hsr_node from which 'skb' was sent.
  */
-struct hsr_node *hsr_get_node(struct hsr_port *port, struct list_head *node_db,
+struct hsr_node *hsr_get_node(struct hsr_port *port, struct hlist_head *node_db,
 			      struct sk_buff *skb, bool is_sup,
 			      enum hsr_port_type rx_port)
 {
@@ -218,7 +233,7 @@ struct hsr_node *hsr_get_node(struct hsr_port *port, struct list_head *node_db,
 
 	ethhdr = (struct ethhdr *)skb_mac_header(skb);
 
-	list_for_each_entry_rcu(node, node_db, mac_list) {
+	hlist_for_each_entry_rcu(node, node_db, mac_list) {
 		if (ether_addr_equal(node->macaddress_A, ethhdr->h_source)) {
 			if (hsr->proto_ops->update_san_info)
 				hsr->proto_ops->update_san_info(node, is_sup);
@@ -268,11 +283,12 @@ void hsr_handle_sup_frame(struct hsr_frame_info *frame)
 	struct hsr_sup_tlv *hsr_sup_tlv;
 	struct hsr_node *node_real;
 	struct sk_buff *skb = NULL;
-	struct list_head *node_db;
+	struct hlist_head *node_db;
 	struct ethhdr *ethhdr;
 	int i;
 	unsigned int pull_size = 0;
 	unsigned int total_pull_size = 0;
+	u32 hash;
 
 	/* Here either frame->skb_hsr or frame->skb_prp should be
 	 * valid as supervision frame always will have protocol
@@ -310,11 +326,13 @@ void hsr_handle_sup_frame(struct hsr_frame_info *frame)
 	hsr_sp = (struct hsr_sup_payload *)skb->data;
 
 	/* Merge node_curr (registered on macaddress_B) into node_real */
-	node_db = &port_rcv->hsr->node_db;
-	node_real = find_node_by_addr_A(node_db, hsr_sp->macaddress_A);
+	node_db = port_rcv->hsr->node_db;
+	hash = hsr_mac_hash(hsr, hsr_sp->macaddress_A);
+	node_real = find_node_by_addr_A(&node_db[hash], hsr_sp->macaddress_A);
 	if (!node_real)
 		/* No frame received from AddrA of this node yet */
-		node_real = hsr_add_node(hsr, node_db, hsr_sp->macaddress_A,
+		node_real = hsr_add_node(hsr, &node_db[hash],
+					 hsr_sp->macaddress_A,
 					 HSR_SEQNR_START - 1, true,
 					 port_rcv->type);
 	if (!node_real)
@@ -348,7 +366,8 @@ void hsr_handle_sup_frame(struct hsr_frame_info *frame)
 		hsr_sp = (struct hsr_sup_payload *)skb->data;
 
 		/* Check if redbox mac and node mac are equal. */
-		if (!ether_addr_equal(node_real->macaddress_A, hsr_sp->macaddress_A)) {
+		if (!ether_addr_equal(node_real->macaddress_A,
+				      hsr_sp->macaddress_A)) {
 			/* This is a redbox supervision frame for a VDAN! */
 			goto done;
 		}
@@ -368,7 +387,7 @@ void hsr_handle_sup_frame(struct hsr_frame_info *frame)
 	node_real->addr_B_port = port_rcv->type;
 
 	spin_lock_bh(&hsr->list_lock);
-	list_del_rcu(&node_curr->mac_list);
+	hlist_del_rcu(&node_curr->mac_list);
 	spin_unlock_bh(&hsr->list_lock);
 	kfree_rcu(node_curr, rcu_head);
 
@@ -406,6 +425,7 @@ void hsr_addr_subst_dest(struct hsr_node *node_src, struct sk_buff *skb,
 			 struct hsr_port *port)
 {
 	struct hsr_node *node_dst;
+	u32 hash;
 
 	if (!skb_mac_header_was_set(skb)) {
 		WARN_ONCE(1, "%s: Mac header not set\n", __func__);
@@ -415,7 +435,8 @@ void hsr_addr_subst_dest(struct hsr_node *node_src, struct sk_buff *skb,
 	if (!is_unicast_ether_addr(eth_hdr(skb)->h_dest))
 		return;
 
-	node_dst = find_node_by_addr_A(&port->hsr->node_db,
+	hash = hsr_mac_hash(port->hsr, eth_hdr(skb)->h_dest);
+	node_dst = find_node_by_addr_A(&port->hsr->node_db[hash],
 				       eth_hdr(skb)->h_dest);
 	if (!node_dst) {
 		if (net_ratelimit())
@@ -491,59 +512,73 @@ static struct hsr_port *get_late_port(struct hsr_priv *hsr,
 void hsr_prune_nodes(struct timer_list *t)
 {
 	struct hsr_priv *hsr = from_timer(hsr, t, prune_timer);
+	struct hlist_node *tmp;
 	struct hsr_node *node;
-	struct hsr_node *tmp;
 	struct hsr_port *port;
 	unsigned long timestamp;
 	unsigned long time_a, time_b;
+	int i;
 
 	spin_lock_bh(&hsr->list_lock);
-	list_for_each_entry_safe(node, tmp, &hsr->node_db, mac_list) {
-		/* Don't prune own node. Neither time_in[HSR_PT_SLAVE_A]
-		 * nor time_in[HSR_PT_SLAVE_B], will ever be updated for
-		 * the master port. Thus the master node will be repeatedly
-		 * pruned leading to packet loss.
-		 */
-		if (hsr_addr_is_self(hsr, node->macaddress_A))
-			continue;
-
-		/* Shorthand */
-		time_a = node->time_in[HSR_PT_SLAVE_A];
-		time_b = node->time_in[HSR_PT_SLAVE_B];
-
-		/* Check for timestamps old enough to risk wrap-around */
-		if (time_after(jiffies, time_a + MAX_JIFFY_OFFSET / 2))
-			node->time_in_stale[HSR_PT_SLAVE_A] = true;
-		if (time_after(jiffies, time_b + MAX_JIFFY_OFFSET / 2))
-			node->time_in_stale[HSR_PT_SLAVE_B] = true;
-
-		/* Get age of newest frame from node.
-		 * At least one time_in is OK here; nodes get pruned long
-		 * before both time_ins can get stale
-		 */
-		timestamp = time_a;
-		if (node->time_in_stale[HSR_PT_SLAVE_A] ||
-		    (!node->time_in_stale[HSR_PT_SLAVE_B] &&
-		    time_after(time_b, time_a)))
-			timestamp = time_b;
-
-		/* Warn of ring error only as long as we get frames at all */
-		if (time_is_after_jiffies(timestamp +
-				msecs_to_jiffies(1.5 * MAX_SLAVE_DIFF))) {
-			rcu_read_lock();
-			port = get_late_port(hsr, node);
-			if (port)
-				hsr_nl_ringerror(hsr, node->macaddress_A, port);
-			rcu_read_unlock();
-		}
 
-		/* Prune old entries */
-		if (time_is_before_jiffies(timestamp +
-				msecs_to_jiffies(HSR_NODE_FORGET_TIME))) {
-			hsr_nl_nodedown(hsr, node->macaddress_A);
-			list_del_rcu(&node->mac_list);
-			/* Note that we need to free this entry later: */
-			kfree_rcu(node, rcu_head);
+	for (i = 0; i < hsr->hash_buckets; i++) {
+		hlist_for_each_entry_safe(node, tmp, &hsr->node_db[i],
+					  mac_list) {
+			/* Don't prune own node.
+			 * Neither time_in[HSR_PT_SLAVE_A]
+			 * nor time_in[HSR_PT_SLAVE_B], will ever be updated
+			 * for the master port. Thus the master node will be
+			 * repeatedly pruned leading to packet loss.
+			 */
+			if (hsr_addr_is_self(hsr, node->macaddress_A))
+				continue;
+
+			/* Shorthand */
+			time_a = node->time_in[HSR_PT_SLAVE_A];
+			time_b = node->time_in[HSR_PT_SLAVE_B];
+
+			/* Check for timestamps old enough to
+			 * risk wrap-around
+			 */
+			if (time_after(jiffies, time_a + MAX_JIFFY_OFFSET / 2))
+				node->time_in_stale[HSR_PT_SLAVE_A] = true;
+			if (time_after(jiffies, time_b + MAX_JIFFY_OFFSET / 2))
+				node->time_in_stale[HSR_PT_SLAVE_B] = true;
+
+			/* Get age of newest frame from node.
+			 * At least one time_in is OK here; nodes get pruned
+			 * long before both time_ins can get stale
+			 */
+			timestamp = time_a;
+			if (node->time_in_stale[HSR_PT_SLAVE_A] ||
+			    (!node->time_in_stale[HSR_PT_SLAVE_B] &&
+			     time_after(time_b, time_a)))
+				timestamp = time_b;
+
+			/* Warn of ring error only as long as we get
+			 * frames at all
+			 */
+			if (time_is_after_jiffies(timestamp +
+						  msecs_to_jiffies(1.5 * MAX_SLAVE_DIFF))) {
+				rcu_read_lock();
+				port = get_late_port(hsr, node);
+				if (port)
+					hsr_nl_ringerror(hsr,
+							 node->macaddress_A,
+							 port);
+				rcu_read_unlock();
+			}
+
+			/* Prune old entries */
+			if (time_is_before_jiffies(timestamp +
+						   msecs_to_jiffies(HSR_NODE_FORGET_TIME))) {
+				hsr_nl_nodedown(hsr, node->macaddress_A);
+				hlist_del_rcu(&node->mac_list);
+				/* Note that we need to free this
+				 * entry later:
+				 */
+				kfree_rcu(node, rcu_head);
+			}
 		}
 	}
 	spin_unlock_bh(&hsr->list_lock);
@@ -557,17 +592,19 @@ void *hsr_get_next_node(struct hsr_priv *hsr, void *_pos,
 			unsigned char addr[ETH_ALEN])
 {
 	struct hsr_node *node;
+	u32 hash;
+
+	hash = hsr_mac_hash(hsr, addr);
 
 	if (!_pos) {
-		node = list_first_or_null_rcu(&hsr->node_db,
-					      struct hsr_node, mac_list);
+		node = hsr_node_get_first(&hsr->node_db[hash]);
 		if (node)
 			ether_addr_copy(addr, node->macaddress_A);
 		return node;
 	}
 
 	node = _pos;
-	list_for_each_entry_continue_rcu(node, &hsr->node_db, mac_list) {
+	hlist_for_each_entry_continue_rcu(node, mac_list) {
 		ether_addr_copy(addr, node->macaddress_A);
 		return node;
 	}
@@ -587,8 +624,11 @@ int hsr_get_node_data(struct hsr_priv *hsr,
 	struct hsr_node *node;
 	struct hsr_port *port;
 	unsigned long tdiff;
+	u32 hash;
+
+	hash = hsr_mac_hash(hsr, addr);
 
-	node = find_node_by_addr_A(&hsr->node_db, addr);
+	node = find_node_by_addr_A(&hsr->node_db[hash], addr);
 	if (!node)
 		return -ENOENT;
 
diff --git a/net/hsr/hsr_framereg.h b/net/hsr/hsr_framereg.h
index bdbb8c822ba1..d7cce6b161e3 100644
--- a/net/hsr/hsr_framereg.h
+++ b/net/hsr/hsr_framereg.h
@@ -28,9 +28,11 @@ struct hsr_frame_info {
 	bool is_from_san;
 };
 
+u32 hsr_mac_hash(struct hsr_priv *hsr, const unsigned char *addr);
+struct hsr_node *hsr_node_get_first(struct hlist_head *head);
 void hsr_del_self_node(struct hsr_priv *hsr);
-void hsr_del_nodes(struct list_head *node_db);
-struct hsr_node *hsr_get_node(struct hsr_port *port, struct list_head *node_db,
+void hsr_del_nodes(struct hlist_head *node_db);
+struct hsr_node *hsr_get_node(struct hsr_port *port, struct hlist_head *node_db,
 			      struct sk_buff *skb, bool is_sup,
 			      enum hsr_port_type rx_port);
 void hsr_handle_sup_frame(struct hsr_frame_info *frame);
@@ -68,7 +70,7 @@ void prp_handle_san_frame(bool san, enum hsr_port_type port,
 void prp_update_san_info(struct hsr_node *node, bool is_sup);
 
 struct hsr_node {
-	struct list_head	mac_list;
+	struct hlist_node	mac_list;
 	unsigned char		macaddress_A[ETH_ALEN];
 	unsigned char		macaddress_B[ETH_ALEN];
 	/* Local slave through which AddrB frames are received from this node */
diff --git a/net/hsr/hsr_main.h b/net/hsr/hsr_main.h
index ff9ec7634218..ca556bda3467 100644
--- a/net/hsr/hsr_main.h
+++ b/net/hsr/hsr_main.h
@@ -63,6 +63,9 @@ struct hsr_tag {
 
 #define HSR_V1_SUP_LSDUSIZE		52
 
+#define HSR_HSIZE_SHIFT	8
+#define HSR_HSIZE	BIT(HSR_HSIZE_SHIFT)
+
 /* The helper functions below assumes that 'path' occupies the 4 most
  * significant bits of the 16-bit field shared by 'path' and 'LSDU_size' (or
  * equivalently, the 4 most significant bits of HSR tag byte 14).
@@ -201,8 +204,8 @@ struct hsr_proto_ops {
 struct hsr_priv {
 	struct rcu_head		rcu_head;
 	struct list_head	ports;
-	struct list_head	node_db;	/* Known HSR nodes */
-	struct list_head	self_node_db;	/* MACs of slaves */
+	struct hlist_head	node_db[HSR_HSIZE];	/* Known HSR nodes */
+	struct hlist_head	self_node_db;	/* MACs of slaves */
 	struct timer_list	announce_timer;	/* Supervision frame dispatch */
 	struct timer_list	prune_timer;
 	int announce_count;
@@ -212,6 +215,8 @@ struct hsr_priv {
 	spinlock_t seqnr_lock;	/* locking for sequence_nr */
 	spinlock_t list_lock;	/* locking for node list */
 	struct hsr_proto_ops	*proto_ops;
+	u32 hash_buckets;
+	u32 hash_seed;
 #define PRP_LAN_ID	0x5     /* 0x1010 for A and 0x1011 for B. Bit 0 is set
 				 * based on SLAVE_A or SLAVE_B
 				 */
diff --git a/net/hsr/hsr_netlink.c b/net/hsr/hsr_netlink.c
index f3c8f91dbe2c..1405c037cf7a 100644
--- a/net/hsr/hsr_netlink.c
+++ b/net/hsr/hsr_netlink.c
@@ -105,6 +105,7 @@ static int hsr_newlink(struct net *src_net, struct net_device *dev,
 static void hsr_dellink(struct net_device *dev, struct list_head *head)
 {
 	struct hsr_priv *hsr = netdev_priv(dev);
+	int i;
 
 	del_timer_sync(&hsr->prune_timer);
 	del_timer_sync(&hsr->announce_timer);
@@ -113,7 +114,8 @@ static void hsr_dellink(struct net_device *dev, struct list_head *head)
 	hsr_del_ports(hsr);
 
 	hsr_del_self_node(hsr);
-	hsr_del_nodes(&hsr->node_db);
+	for (i = 0; i < hsr->hash_buckets; i++)
+		hsr_del_nodes(&hsr->node_db[i]);
 
 	unregister_netdevice_queue(dev, head);
 }
-- 
2.25.1

