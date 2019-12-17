Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 599531238F7
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 22:57:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbfLQV5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 16:57:40 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38451 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726569AbfLQV5j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 16:57:39 -0500
Received: by mail-wm1-f68.google.com with SMTP id u2so21794wmc.3
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 13:57:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Znn61YMXtttrGIektzWxjMHVzMhceBavE0nMBLBtEuU=;
        b=BjJT3jKlcpOKCmZP+V/6oSmkZaT36IHdDPY/pNQHqKxCdN6j95o/4/qO70RekCzSai
         PVNEdRX07DsyizNx25eQL1bCGtfgNCqVhtwtdKWLBkzlkkqTMZTDUvfdsc+Xm4FYFdV9
         McYCe0SrNGtJp5MfSw5GUTsTiMOjQW/wa+uRuPZ93JWf2IlZQZY2eVTK3mvj4zvKShBr
         ToCSwItHivoDyLbHotgEALHHZN3SxKGnp/QOObHZZ+KYCKu03Qvoa/AreZEAxrKXZwtG
         TjXsajZjXEXJhk0nGxsRuQeOqHXeN8k4E7mJBgKhjnRwspVFiUiK+VNX6hGMzje2P+WQ
         vlbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Znn61YMXtttrGIektzWxjMHVzMhceBavE0nMBLBtEuU=;
        b=AOBsjYWpSJX3uUHN1QkxW1fW782dcjwcGzPUuOc2kbF/yKIuZ/i8kPweJiSQfwxfs8
         AGh8XpBnOVBBRq7M8Lnc3doObGsXwn8dUd0EGcG35qwztDHFT5AMN0DHuXQ/s2jFOTYY
         mxmTO5+yWUjGGxwEyjE7gsI/4l7TVHc0i3LfRIlsC9+Q/kEnrtr5pGh7w55yxHqO/xAR
         qhe5bhaIy7r9zP7YaFTVWeAP61tJRjIEeNAj5xFpPBENgRKKhDnnoMqC/r6o7nm3xgAi
         Wd6yqZBCAwS3pZaxjil1zn4O9sANguuwsFIwaPK+BuDYClIOHUdRgY/Ofmc2ejR5WT9O
         qICw==
X-Gm-Message-State: APjAAAWl4rCJqhXAeBAG1x9y+Ck1nqEFAXPiV1zg7hauajD6lH+/FPPU
        KUYvw8NFTrYi35+tpW2Wk3bRdo52QtN+Rpj1Z/JKB8V7PGXG8ExHQZWCxTs/sdCZ3i3yY9LECAo
        dweApvKPPxavzeQnH2HAa62XkFExBOBXFT89jNinmq1gWmSFvF2eCR0hxfcP4LOHJD8ig4QRM5Q
        ==
X-Google-Smtp-Source: APXvYqy7q3W2wfLMRfsji6JJ8YjwdowxAIFOI9h3bifRv0RifCOOst6o5EBs6kO5RtKw5QdiXFt3Wg==
X-Received: by 2002:a1c:3189:: with SMTP id x131mr6618244wmx.59.1576619857124;
        Tue, 17 Dec 2019 13:57:37 -0800 (PST)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id u22sm157109wru.30.2019.12.17.13.57.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 17 Dec 2019 13:57:36 -0800 (PST)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     simon.horman@netronome.com, jakub.kicinski@netronome.com,
        oss-drivers@netronome.com, John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next v2 4/9] nfp: flower: offload list of IPv6 tunnel endpoint addresses
Date:   Tue, 17 Dec 2019 21:57:19 +0000
Message-Id: <1576619844-25413-5-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1576619844-25413-1-git-send-email-john.hurley@netronome.com>
References: <1576619844-25413-1-git-send-email-john.hurley@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fw requires a list of IPv6 addresses that are used as tunnel endpoints to
enable correct decap of tunneled packets.

Store a list of IPv6 endpoints used in rules with a ref counter to track
how many times it is in use. Offload the entire list any time a new IPv6
address is added or when an address is removed (ref count is 0).

Signed-off-by: John Hurley <john.hurley@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/flower/cmsg.h   |  1 +
 drivers/net/ethernet/netronome/nfp/flower/main.h   | 21 +++++
 drivers/net/ethernet/netronome/nfp/flower/match.c  | 24 ++++++
 .../net/ethernet/netronome/nfp/flower/offload.c    |  6 ++
 .../ethernet/netronome/nfp/flower/tunnel_conf.c    | 90 +++++++++++++++++++++-
 5 files changed, 141 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/cmsg.h b/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
index 8d12805..cbb94cf 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
@@ -568,6 +568,7 @@ enum nfp_flower_cmsg_type_port {
 	NFP_FLOWER_CMSG_TYPE_QOS_DEL =		19,
 	NFP_FLOWER_CMSG_TYPE_QOS_STATS =	20,
 	NFP_FLOWER_CMSG_TYPE_PRE_TUN_RULE =	21,
+	NFP_FLOWER_CMSG_TYPE_TUN_IPS_V6 =	22,
 	NFP_FLOWER_CMSG_TYPE_MAX =		32,
 };
 
diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.h b/drivers/net/ethernet/netronome/nfp/flower/main.h
index 386d629..bd288e2 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
@@ -63,8 +63,10 @@ struct nfp_fl_stats_id {
  * struct nfp_fl_tunnel_offloads - priv data for tunnel offloads
  * @offloaded_macs:	Hashtable of the offloaded MAC addresses
  * @ipv4_off_list:	List of IPv4 addresses to offload
+ * @ipv6_off_list:	List of IPv6 addresses to offload
  * @neigh_off_list:	List of neighbour offloads
  * @ipv4_off_lock:	Lock for the IPv4 address list
+ * @ipv6_off_lock:	Lock for the IPv6 address list
  * @neigh_off_lock:	Lock for the neighbour address list
  * @mac_off_ids:	IDA to manage id assignment for offloaded MACs
  * @neigh_nb:		Notifier to monitor neighbour state
@@ -72,8 +74,10 @@ struct nfp_fl_stats_id {
 struct nfp_fl_tunnel_offloads {
 	struct rhashtable offloaded_macs;
 	struct list_head ipv4_off_list;
+	struct list_head ipv6_off_list;
 	struct list_head neigh_off_list;
 	struct mutex ipv4_off_lock;
+	struct mutex ipv6_off_lock;
 	spinlock_t neigh_off_lock;
 	struct ida mac_off_ids;
 	struct notifier_block neigh_nb;
@@ -274,12 +278,25 @@ struct nfp_fl_stats {
 	u64 used;
 };
 
+/**
+ * struct nfp_ipv6_addr_entry - cached IPv6 addresses
+ * @ipv6_addr:	IP address
+ * @ref_count:	number of rules currently using this IP
+ * @list:	list pointer
+ */
+struct nfp_ipv6_addr_entry {
+	struct in6_addr ipv6_addr;
+	int ref_count;
+	struct list_head list;
+};
+
 struct nfp_fl_payload {
 	struct nfp_fl_rule_metadata meta;
 	unsigned long tc_flower_cookie;
 	struct rhash_head fl_node;
 	struct rcu_head rcu;
 	__be32 nfp_tun_ipv4_addr;
+	struct nfp_ipv6_addr_entry *nfp_tun_ipv6;
 	struct net_device *ingress_dev;
 	char *unmasked_data;
 	char *mask_data;
@@ -397,6 +414,10 @@ int nfp_tunnel_mac_event_handler(struct nfp_app *app,
 				 unsigned long event, void *ptr);
 void nfp_tunnel_del_ipv4_off(struct nfp_app *app, __be32 ipv4);
 void nfp_tunnel_add_ipv4_off(struct nfp_app *app, __be32 ipv4);
+void
+nfp_tunnel_put_ipv6_off(struct nfp_app *app, struct nfp_ipv6_addr_entry *entry);
+struct nfp_ipv6_addr_entry *
+nfp_tunnel_add_ipv6_off(struct nfp_app *app, struct in6_addr *ipv6);
 void nfp_tunnel_request_route(struct nfp_app *app, struct sk_buff *skb);
 void nfp_tunnel_keep_alive(struct nfp_app *app, struct sk_buff *skb);
 void nfp_flower_lag_init(struct nfp_fl_lag *lag);
diff --git a/drivers/net/ethernet/netronome/nfp/flower/match.c b/drivers/net/ethernet/netronome/nfp/flower/match.c
index 2410ead..546bc01 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/match.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/match.c
@@ -494,10 +494,22 @@ int nfp_flower_compile_flow_match(struct nfp_app *app,
 
 	if (key_ls->key_layer_two & NFP_FLOWER_LAYER2_GRE) {
 		if (key_ls->key_layer_two & NFP_FLOWER_LAYER2_TUN_IPV6) {
+			struct nfp_flower_ipv6_gre_tun *gre_match;
+			struct nfp_ipv6_addr_entry *entry;
+			struct in6_addr *dst;
+
 			nfp_flower_compile_ipv6_gre_tun((void *)ext,
 							(void *)msk, rule);
+			gre_match = (struct nfp_flower_ipv6_gre_tun *)ext;
+			dst = &gre_match->ipv6.dst;
 			ext += sizeof(struct nfp_flower_ipv6_gre_tun);
 			msk += sizeof(struct nfp_flower_ipv6_gre_tun);
+
+			entry = nfp_tunnel_add_ipv6_off(app, dst);
+			if (!entry)
+				return -EOPNOTSUPP;
+
+			nfp_flow->nfp_tun_ipv6 = entry;
 		} else {
 			__be32 dst;
 
@@ -518,10 +530,22 @@ int nfp_flower_compile_flow_match(struct nfp_app *app,
 	if (key_ls->key_layer & NFP_FLOWER_LAYER_VXLAN ||
 	    key_ls->key_layer_two & NFP_FLOWER_LAYER2_GENEVE) {
 		if (key_ls->key_layer_two & NFP_FLOWER_LAYER2_TUN_IPV6) {
+			struct nfp_flower_ipv6_udp_tun *udp_match;
+			struct nfp_ipv6_addr_entry *entry;
+			struct in6_addr *dst;
+
 			nfp_flower_compile_ipv6_udp_tun((void *)ext,
 							(void *)msk, rule);
+			udp_match = (struct nfp_flower_ipv6_udp_tun *)ext;
+			dst = &udp_match->ipv6.dst;
 			ext += sizeof(struct nfp_flower_ipv6_udp_tun);
 			msk += sizeof(struct nfp_flower_ipv6_udp_tun);
+
+			entry = nfp_tunnel_add_ipv6_off(app, dst);
+			if (!entry)
+				return -EOPNOTSUPP;
+
+			nfp_flow->nfp_tun_ipv6 = entry;
 		} else {
 			__be32 dst;
 
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 0997350..83ada1b 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -539,6 +539,7 @@ nfp_flower_allocate_new(struct nfp_fl_key_ls *key_layer)
 		goto err_free_mask;
 
 	flow_pay->nfp_tun_ipv4_addr = 0;
+	flow_pay->nfp_tun_ipv6 = NULL;
 	flow_pay->meta.flags = 0;
 	INIT_LIST_HEAD(&flow_pay->linked_flows);
 	flow_pay->in_hw = false;
@@ -1243,6 +1244,8 @@ nfp_flower_add_offload(struct nfp_app *app, struct net_device *netdev,
 err_release_metadata:
 	nfp_modify_flow_metadata(app, flow_pay);
 err_destroy_flow:
+	if (flow_pay->nfp_tun_ipv6)
+		nfp_tunnel_put_ipv6_off(app, flow_pay->nfp_tun_ipv6);
 	kfree(flow_pay->action_data);
 	kfree(flow_pay->mask_data);
 	kfree(flow_pay->unmasked_data);
@@ -1359,6 +1362,9 @@ nfp_flower_del_offload(struct nfp_app *app, struct net_device *netdev,
 	if (nfp_flow->nfp_tun_ipv4_addr)
 		nfp_tunnel_del_ipv4_off(app, nfp_flow->nfp_tun_ipv4_addr);
 
+	if (nfp_flow->nfp_tun_ipv6)
+		nfp_tunnel_put_ipv6_off(app, nfp_flow->nfp_tun_ipv6);
+
 	if (!nfp_flow->in_hw) {
 		err = 0;
 		goto err_free_merge_flow;
diff --git a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
index 2600ce4..eddb52d 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
@@ -116,6 +116,18 @@ struct nfp_ipv4_addr_entry {
 	struct list_head list;
 };
 
+#define NFP_FL_IPV6_ADDRS_MAX        4
+
+/**
+ * struct nfp_tun_ipv6_addr - set the IP address list on the NFP
+ * @count:	number of IPs populated in the array
+ * @ipv6_addr:	array of IPV6_ADDRS_MAX 128 bit IPv6 addresses
+ */
+struct nfp_tun_ipv6_addr {
+	__be32 count;
+	struct in6_addr ipv6_addr[NFP_FL_IPV6_ADDRS_MAX];
+};
+
 #define NFP_TUN_MAC_OFFLOAD_DEL_FLAG	0x2
 
 /**
@@ -502,6 +514,78 @@ void nfp_tunnel_del_ipv4_off(struct nfp_app *app, __be32 ipv4)
 	nfp_tun_write_ipv4_list(app);
 }
 
+static void nfp_tun_write_ipv6_list(struct nfp_app *app)
+{
+	struct nfp_flower_priv *priv = app->priv;
+	struct nfp_ipv6_addr_entry *entry;
+	struct nfp_tun_ipv6_addr payload;
+	int count = 0;
+
+	memset(&payload, 0, sizeof(struct nfp_tun_ipv6_addr));
+	mutex_lock(&priv->tun.ipv6_off_lock);
+	list_for_each_entry(entry, &priv->tun.ipv6_off_list, list) {
+		if (count >= NFP_FL_IPV6_ADDRS_MAX) {
+			nfp_flower_cmsg_warn(app, "Too many IPv6 tunnel endpoint addresses, some cannot be offloaded.\n");
+			break;
+		}
+		payload.ipv6_addr[count++] = entry->ipv6_addr;
+	}
+	mutex_unlock(&priv->tun.ipv6_off_lock);
+	payload.count = cpu_to_be32(count);
+
+	nfp_flower_xmit_tun_conf(app, NFP_FLOWER_CMSG_TYPE_TUN_IPS_V6,
+				 sizeof(struct nfp_tun_ipv6_addr),
+				 &payload, GFP_KERNEL);
+}
+
+struct nfp_ipv6_addr_entry *
+nfp_tunnel_add_ipv6_off(struct nfp_app *app, struct in6_addr *ipv6)
+{
+	struct nfp_flower_priv *priv = app->priv;
+	struct nfp_ipv6_addr_entry *entry;
+
+	mutex_lock(&priv->tun.ipv6_off_lock);
+	list_for_each_entry(entry, &priv->tun.ipv6_off_list, list)
+		if (!memcmp(&entry->ipv6_addr, ipv6, sizeof(*ipv6))) {
+			entry->ref_count++;
+			mutex_unlock(&priv->tun.ipv6_off_lock);
+			return entry;
+		}
+
+	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry) {
+		mutex_unlock(&priv->tun.ipv6_off_lock);
+		nfp_flower_cmsg_warn(app, "Mem error when offloading IP address.\n");
+		return NULL;
+	}
+	entry->ipv6_addr = *ipv6;
+	entry->ref_count = 1;
+	list_add_tail(&entry->list, &priv->tun.ipv6_off_list);
+	mutex_unlock(&priv->tun.ipv6_off_lock);
+
+	nfp_tun_write_ipv6_list(app);
+
+	return entry;
+}
+
+void
+nfp_tunnel_put_ipv6_off(struct nfp_app *app, struct nfp_ipv6_addr_entry *entry)
+{
+	struct nfp_flower_priv *priv = app->priv;
+	bool freed = false;
+
+	mutex_lock(&priv->tun.ipv6_off_lock);
+	if (!--entry->ref_count) {
+		list_del(&entry->list);
+		kfree(entry);
+		freed = true;
+	}
+	mutex_unlock(&priv->tun.ipv6_off_lock);
+
+	if (freed)
+		nfp_tun_write_ipv6_list(app);
+}
+
 static int
 __nfp_tunnel_offload_mac(struct nfp_app *app, u8 *mac, u16 idx, bool del)
 {
@@ -1013,9 +1097,11 @@ int nfp_tunnel_config_start(struct nfp_app *app)
 
 	ida_init(&priv->tun.mac_off_ids);
 
-	/* Initialise priv data for IPv4 offloading. */
+	/* Initialise priv data for IPv4/v6 offloading. */
 	mutex_init(&priv->tun.ipv4_off_lock);
 	INIT_LIST_HEAD(&priv->tun.ipv4_off_list);
+	mutex_init(&priv->tun.ipv6_off_lock);
+	INIT_LIST_HEAD(&priv->tun.ipv6_off_list);
 
 	/* Initialise priv data for neighbour offloading. */
 	spin_lock_init(&priv->tun.neigh_off_lock);
@@ -1050,6 +1136,8 @@ void nfp_tunnel_config_stop(struct nfp_app *app)
 		kfree(ip_entry);
 	}
 
+	mutex_destroy(&priv->tun.ipv6_off_lock);
+
 	/* Free any memory that may be occupied by the route list. */
 	list_for_each_safe(ptr, storage, &priv->tun.neigh_off_list) {
 		route_entry = list_entry(ptr, struct nfp_ipv4_route_entry,
-- 
2.7.4

