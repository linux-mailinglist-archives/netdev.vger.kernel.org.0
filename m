Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9FA5BBD09
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 11:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbiIRJvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 05:51:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbiIRJuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 05:50:20 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8701A14036
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 02:49:57 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MVjfD0pQMzHnnC;
        Sun, 18 Sep 2022 17:47:48 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 18 Sep 2022 17:49:54 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <ecree.xilinx@gmail.com>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [RFCv8 PATCH net-next 44/55] net: adjust the prototype fo xxx_gso_segment() family
Date:   Sun, 18 Sep 2022 09:43:25 +0000
Message-ID: <20220918094336.28958-45-shenjian15@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220918094336.28958-1-shenjian15@huawei.com>
References: <20220918094336.28958-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The xxx_gso_segment() functions using netdev_features_t as
parameters. For the prototype of netdev_features_t will
be extended to be larger than 8 bytes, so change the prototype
of the function, change the prototype of input features to
'netdev_features_t *'.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/ethernet/broadcom/tg3.c           |  2 +-
 .../net/ethernet/myricom/myri10ge/myri10ge.c  |  2 +-
 drivers/net/ethernet/sfc/siena/tx_common.c    |  2 +-
 drivers/net/ethernet/sfc/tx_common.c          |  2 +-
 drivers/net/ethernet/sun/sunvnet_common.c     |  2 +-
 drivers/net/tap.c                             |  2 +-
 drivers/net/usb/r8152.c                       |  2 +-
 drivers/net/wireguard/device.c                |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c   | 10 +++----
 include/linux/netdevice.h                     | 11 ++++----
 include/linux/skbuff.h                        |  6 +++--
 include/net/inet_common.h                     |  2 +-
 include/net/tcp.h                             |  2 +-
 include/net/udp.h                             |  6 ++---
 lib/test_bpf.c                                |  2 +-
 net/core/dev.c                                |  9 ++++---
 net/core/gro.c                                |  5 ++--
 net/core/skbuff.c                             | 12 +++++----
 net/ipv4/af_inet.c                            |  9 ++++---
 net/ipv4/esp4_offload.c                       | 23 ++++++++--------
 net/ipv4/gre_offload.c                        |  6 +++--
 net/ipv4/ip_output.c                          |  2 +-
 net/ipv4/tcp_offload.c                        |  8 +++---
 net/ipv4/udp_offload.c                        | 27 +++++++++++--------
 net/ipv6/esp6_offload.c                       | 23 ++++++++--------
 net/ipv6/ip6_offload.c                        | 12 +++++----
 net/ipv6/ip6_output.c                         |  2 +-
 net/ipv6/tcpv6_offload.c                      |  2 +-
 net/ipv6/udp_offload.c                        | 11 +++++---
 net/mac80211/tx.c                             |  2 +-
 net/mpls/mpls_gso.c                           |  6 ++---
 net/netfilter/nfnetlink_queue.c               |  2 +-
 net/nsh/nsh.c                                 |  6 ++---
 net/openvswitch/datapath.c                    |  2 +-
 net/sched/sch_cake.c                          |  2 +-
 net/sched/sch_netem.c                         |  2 +-
 net/sched/sch_taprio.c                        |  2 +-
 net/sched/sch_tbf.c                           |  2 +-
 net/sctp/offload.c                            | 10 +++----
 net/xfrm/xfrm_device.c                        |  2 +-
 net/xfrm/xfrm_output.c                        |  2 +-
 41 files changed, 137 insertions(+), 109 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index e4fa6f2fdc72..409e99c5de5c 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -7880,7 +7880,7 @@ static int tg3_tso_bug(struct tg3 *tp, struct tg3_napi *tnapi,
 
 	netdev_features_andnot(features, tp->dev->features,
 			       netdev_general_tso_features);
-	segs = skb_gso_segment(skb, features);
+	segs = skb_gso_segment(skb, &features);
 	if (IS_ERR(segs) || !segs)
 		goto tg3_tso_bug_end;
 
diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index 301edf3f6cc1..08b6dc477810 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -2898,7 +2898,7 @@ static netdev_tx_t myri10ge_sw_tso(struct sk_buff *skb,
 	netdev_tx_t status;
 
 	netdev_feature_del(NETIF_F_TSO6_BIT, features);
-	segs = skb_gso_segment(skb, features);
+	segs = skb_gso_segment(skb, &features);
 	if (IS_ERR(segs))
 		goto drop;
 
diff --git a/drivers/net/ethernet/sfc/siena/tx_common.c b/drivers/net/ethernet/sfc/siena/tx_common.c
index 58d87add9a46..08be81fc3779 100644
--- a/drivers/net/ethernet/sfc/siena/tx_common.c
+++ b/drivers/net/ethernet/sfc/siena/tx_common.c
@@ -435,7 +435,7 @@ int efx_siena_tx_tso_fallback(struct efx_tx_queue *tx_queue,
 	netdev_features_t feats;
 
 	netdev_features_zero(feats);
-	segments = skb_gso_segment(skb, feats);
+	segments = skb_gso_segment(skb, &feats);
 	if (IS_ERR(segments))
 		return PTR_ERR(segments);
 
diff --git a/drivers/net/ethernet/sfc/tx_common.c b/drivers/net/ethernet/sfc/tx_common.c
index 14fa2c65fc25..db9ceb5026bd 100644
--- a/drivers/net/ethernet/sfc/tx_common.c
+++ b/drivers/net/ethernet/sfc/tx_common.c
@@ -452,7 +452,7 @@ int efx_tx_tso_fallback(struct efx_tx_queue *tx_queue, struct sk_buff *skb)
 	netdev_features_t feats;
 
 	netdev_features_zero(feats);
-	segments = skb_gso_segment(skb, feats);
+	segments = skb_gso_segment(skb, &feats);
 	if (IS_ERR(segments))
 		return PTR_ERR(segments);
 
diff --git a/drivers/net/ethernet/sun/sunvnet_common.c b/drivers/net/ethernet/sun/sunvnet_common.c
index 9bdbaf691201..b0239b704e79 100644
--- a/drivers/net/ethernet/sun/sunvnet_common.c
+++ b/drivers/net/ethernet/sun/sunvnet_common.c
@@ -1276,7 +1276,7 @@ vnet_handle_offloads(struct vnet_port *port, struct sk_buff *skb,
 		skb_shinfo(skb)->gso_segs = gso_segs;
 	}
 	netdev_feature_del(NETIF_F_TSO_BIT, features);
-	segs = skb_gso_segment(skb, features);
+	segs = skb_gso_segment(skb, &features);
 	if (IS_ERR(segs))
 		goto out_dropped;
 
diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index ab8555799574..dfbfd8dfcf67 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -342,7 +342,7 @@ rx_handler_result_t tap_handle_frame(struct sk_buff **pskb)
 	if (q->flags & IFF_VNET_HDR)
 		netdev_features_set(features, tap->tap_features);
 	if (netif_needs_gso(skb, features)) {
-		struct sk_buff *segs = __skb_gso_segment(skb, features, false);
+		struct sk_buff *segs = __skb_gso_segment(skb, &features, false);
 		struct sk_buff *next;
 
 		if (IS_ERR(segs)) {
diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 5b4f73b7c023..d2936ac84774 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -2113,7 +2113,7 @@ static void r8152_csum_workaround(struct r8152 *tp, struct sk_buff *skb,
 		netdev_features_clear_set(features, NETIF_F_SG_BIT,
 					  NETIF_F_IPV6_CSUM_BIT,
 					  NETIF_F_TSO6_BIT);
-		segs = skb_gso_segment(skb, features);
+		segs = skb_gso_segment(skb, &features);
 		if (IS_ERR(segs) || !segs)
 			goto drop;
 
diff --git a/drivers/net/wireguard/device.c b/drivers/net/wireguard/device.c
index 6930f0882b0d..04145af755c9 100644
--- a/drivers/net/wireguard/device.c
+++ b/drivers/net/wireguard/device.c
@@ -180,7 +180,7 @@ static netdev_tx_t wg_xmit(struct sk_buff *skb, struct net_device *dev)
 		struct sk_buff *segs;
 
 		netdev_features_zero(feats);
-		segs = skb_gso_segment(skb, feats);
+		segs = skb_gso_segment(skb, &feats);
 		if (IS_ERR(segs)) {
 			ret = PTR_ERR(segs);
 			goto err_peer;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index bdb6a599aa9f..4ed95b179b45 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -814,7 +814,7 @@ unsigned int iwl_mvm_max_amsdu_size(struct iwl_mvm *mvm,
 
 static int
 iwl_mvm_tx_tso_segment(struct sk_buff *skb, unsigned int num_subframes,
-		       netdev_features_t netdev_flags,
+		       const netdev_features_t *netdev_flags,
 		       struct sk_buff_head *mpdus_skb)
 {
 	struct sk_buff *tmp, *next;
@@ -900,7 +900,7 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb,
 	if (!mvmsta->max_amsdu_len ||
 	    !ieee80211_is_data_qos(hdr->frame_control) ||
 	    !mvmsta->amsdu_enabled)
-		return iwl_mvm_tx_tso_segment(skb, 1, netdev_flags, mpdus_skb);
+		return iwl_mvm_tx_tso_segment(skb, 1, &netdev_flags, mpdus_skb);
 
 	/*
 	 * Do not build AMSDU for IPv6 with extension headers.
@@ -910,7 +910,7 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb,
 	    ((struct ipv6hdr *)skb_network_header(skb))->nexthdr !=
 	    IPPROTO_TCP) {
 		netdev_features_clear(netdev_flags, NETIF_F_CSUM_MASK);
-		return iwl_mvm_tx_tso_segment(skb, 1, netdev_flags, mpdus_skb);
+		return iwl_mvm_tx_tso_segment(skb, 1, &netdev_flags, mpdus_skb);
 	}
 
 	tid = ieee80211_get_tid(hdr);
@@ -924,7 +924,7 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb,
 	if ((info->flags & IEEE80211_TX_CTL_AMPDU &&
 	     !mvmsta->tid_data[tid].amsdu_in_ampdu_allowed) ||
 	    !(mvmsta->amsdu_enabled & BIT(tid)))
-		return iwl_mvm_tx_tso_segment(skb, 1, netdev_flags, mpdus_skb);
+		return iwl_mvm_tx_tso_segment(skb, 1, &netdev_flags, mpdus_skb);
 
 	/*
 	 * Take the min of ieee80211 station and mvm station
@@ -982,7 +982,7 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb,
 	 * Trick the segmentation function to make it
 	 * create SKBs that can fit into one A-MSDU.
 	 */
-	return iwl_mvm_tx_tso_segment(skb, num_subframes, netdev_flags,
+	return iwl_mvm_tx_tso_segment(skb, num_subframes, &netdev_flags,
 				      mpdus_skb);
 }
 #else /* CONFIG_INET */
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index d9e64b45298c..fb1f85274e3b 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2659,7 +2659,7 @@ struct packet_type {
 
 struct offload_callbacks {
 	struct sk_buff		*(*gso_segment)(struct sk_buff *skb,
-						netdev_features_t features);
+						const netdev_features_t *features);
 	struct sk_buff		*(*gro_receive)(struct list_head *head,
 						struct sk_buff *skb);
 	int			(*gro_complete)(struct sk_buff *skb, int nhoff);
@@ -4773,11 +4773,11 @@ int skb_csum_hwoffload_help(struct sk_buff *skb,
 			    const netdev_features_t *features);
 
 struct sk_buff *__skb_gso_segment(struct sk_buff *skb,
-				  netdev_features_t features, bool tx_path);
+				  const netdev_features_t *features, bool tx_path);
 struct sk_buff *skb_eth_gso_segment(struct sk_buff *skb,
-				    netdev_features_t features, __be16 type);
+				    const netdev_features_t *features, __be16 type);
 struct sk_buff *skb_mac_gso_segment(struct sk_buff *skb,
-				    netdev_features_t features);
+				    const netdev_features_t *features);
 
 struct netdev_bonding_info {
 	ifslave	slave;
@@ -4802,7 +4802,8 @@ static inline void ethtool_notify(struct net_device *dev, unsigned int cmd,
 #endif
 
 static inline
-struct sk_buff *skb_gso_segment(struct sk_buff *skb, netdev_features_t features)
+struct sk_buff *skb_gso_segment(struct sk_buff *skb,
+				const netdev_features_t *features)
 {
 	return __skb_gso_segment(skb, features, true);
 }
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 8b030517f4d3..2f163b12c54d 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3960,8 +3960,10 @@ int skb_shift(struct sk_buff *tgt, struct sk_buff *skb, int shiftlen);
 void skb_scrub_packet(struct sk_buff *skb, bool xnet);
 bool skb_gso_validate_network_len(const struct sk_buff *skb, unsigned int mtu);
 bool skb_gso_validate_mac_len(const struct sk_buff *skb, unsigned int len);
-struct sk_buff *skb_segment(struct sk_buff *skb, netdev_features_t features);
-struct sk_buff *skb_segment_list(struct sk_buff *skb, netdev_features_t features,
+struct sk_buff *skb_segment(struct sk_buff *skb,
+			    const netdev_features_t *features);
+struct sk_buff *skb_segment_list(struct sk_buff *skb,
+				 const netdev_features_t *features,
 				 unsigned int offset);
 struct sk_buff *skb_vlan_untag(struct sk_buff *skb);
 int skb_ensure_writable(struct sk_buff *skb, unsigned int write_len);
diff --git a/include/net/inet_common.h b/include/net/inet_common.h
index cec453c18f1d..013f52029899 100644
--- a/include/net/inet_common.h
+++ b/include/net/inet_common.h
@@ -63,7 +63,7 @@ int inet_recv_error(struct sock *sk, struct msghdr *msg, int len,
 struct sk_buff *inet_gro_receive(struct list_head *head, struct sk_buff *skb);
 int inet_gro_complete(struct sk_buff *skb, int nhoff);
 struct sk_buff *inet_gso_segment(struct sk_buff *skb,
-				 netdev_features_t features);
+				 const netdev_features_t *features);
 
 static inline void inet_ctl_sock_destroy(struct sock *sk)
 {
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 735e957f7f4b..cfcffe0e3109 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2024,7 +2024,7 @@ extern struct request_sock_ops tcp6_request_sock_ops;
 void tcp_v4_destroy_sock(struct sock *sk);
 
 struct sk_buff *tcp_gso_segment(struct sk_buff *skb,
-				netdev_features_t features);
+				const netdev_features_t *features);
 struct sk_buff *tcp_gro_receive(struct list_head *head, struct sk_buff *skb);
 INDIRECT_CALLABLE_DECLARE(int tcp4_gro_complete(struct sk_buff *skb, int thoff));
 INDIRECT_CALLABLE_DECLARE(struct sk_buff *tcp4_gro_receive(struct list_head *head, struct sk_buff *skb));
diff --git a/include/net/udp.h b/include/net/udp.h
index ecdf76e4318f..30f8dc9f852f 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -172,7 +172,7 @@ void udp_v6_early_demux(struct sk_buff *skb);
 INDIRECT_CALLABLE_DECLARE(int udpv6_rcv(struct sk_buff *));
 
 struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
-				  netdev_features_t features, bool is_ipv6);
+				  const netdev_features_t *features, bool is_ipv6);
 
 /* hash routines shared between UDPv4/6 and UDP-Litev4/6 */
 static inline int udp_lib_hash(struct sock *sk)
@@ -281,7 +281,7 @@ int __udp_disconnect(struct sock *sk, int flags);
 int udp_disconnect(struct sock *sk, int flags);
 __poll_t udp_poll(struct file *file, struct socket *sock, poll_table *wait);
 struct sk_buff *skb_udp_tunnel_segment(struct sk_buff *skb,
-				       netdev_features_t features,
+				       const netdev_features_t *features,
 				       bool is_ipv6);
 int udp_lib_getsockopt(struct sock *sk, int level, int optname,
 		       char __user *optval, int __user *optlen);
@@ -483,7 +483,7 @@ static inline struct sk_buff *udp_rcv_segment(struct sock *sk,
 	/* the GSO CB lays after the UDP one, no need to save and restore any
 	 * CB fragment
 	 */
-	segs = __skb_gso_segment(skb, features, false);
+	segs = __skb_gso_segment(skb, &features, false);
 	if (IS_ERR_OR_NULL(segs)) {
 		int segs_nr = skb_shinfo(skb)->gso_segs;
 
diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index 84073b768558..f9bfc52a6f81 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -14769,7 +14769,7 @@ static __init int test_skb_segment_single(const struct skb_segment_test *test)
 		goto done;
 	}
 
-	segs = skb_segment(skb, *test->features);
+	segs = skb_segment(skb, test->features);
 	if (!IS_ERR(segs)) {
 		kfree_skb_list(segs);
 		ret = 0;
diff --git a/net/core/dev.c b/net/core/dev.c
index e27a8322289b..ad6202d2543e 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3376,8 +3376,9 @@ static inline bool skb_needs_check(struct sk_buff *skb, bool tx_path)
  *	Segmentation preserves SKB_GSO_CB_OFFSET bytes of previous skb cb.
  */
 struct sk_buff *__skb_gso_segment(struct sk_buff *skb,
-				  netdev_features_t features, bool tx_path)
+				  const netdev_features_t *feats, bool tx_path)
 {
+	netdev_features_t features;
 	struct sk_buff *segs;
 
 	if (unlikely(skb_needs_check(skb, tx_path))) {
@@ -3389,6 +3390,8 @@ struct sk_buff *__skb_gso_segment(struct sk_buff *skb,
 			return ERR_PTR(err);
 	}
 
+	netdev_features_copy(features, *feats);
+
 	/* Only report GSO partial support if it will enable us to
 	 * support segmentation on this frame without needing additional
 	 * work.
@@ -3414,7 +3417,7 @@ struct sk_buff *__skb_gso_segment(struct sk_buff *skb,
 	skb_reset_mac_header(skb);
 	skb_reset_mac_len(skb);
 
-	segs = skb_mac_gso_segment(skb, features);
+	segs = skb_mac_gso_segment(skb, &features);
 
 	if (segs != skb && unlikely(skb_needs_check(skb, tx_path) && !IS_ERR(segs)))
 		skb_warn_bad_offload(skb);
@@ -3665,7 +3668,7 @@ static struct sk_buff *validate_xmit_skb(struct sk_buff *skb, struct net_device
 	if (netif_needs_gso(skb, features)) {
 		struct sk_buff *segs;
 
-		segs = skb_gso_segment(skb, features);
+		segs = skb_gso_segment(skb, &features);
 		if (IS_ERR(segs)) {
 			goto out_kfree_skb;
 		} else if (segs) {
diff --git a/net/core/gro.c b/net/core/gro.c
index b4190eb08467..28131d091a3f 100644
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -99,7 +99,8 @@ EXPORT_SYMBOL(dev_remove_offload);
  *	@type: Ethernet Protocol ID
  */
 struct sk_buff *skb_eth_gso_segment(struct sk_buff *skb,
-				    netdev_features_t features, __be16 type)
+				    const netdev_features_t *features,
+				    __be16 type)
 {
 	struct sk_buff *segs = ERR_PTR(-EPROTONOSUPPORT);
 	struct packet_offload *ptype;
@@ -123,7 +124,7 @@ EXPORT_SYMBOL(skb_eth_gso_segment);
  *	@features: features for the output path (see dev->features)
  */
 struct sk_buff *skb_mac_gso_segment(struct sk_buff *skb,
-				    netdev_features_t features)
+				    const netdev_features_t *features)
 {
 	struct sk_buff *segs = ERR_PTR(-EPROTONOSUPPORT);
 	struct packet_offload *ptype;
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 0e40de13de3f..b5916c98128b 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3915,7 +3915,7 @@ static inline skb_frag_t skb_head_frag_to_page_desc(struct sk_buff *frag_skb)
 }
 
 struct sk_buff *skb_segment_list(struct sk_buff *skb,
-				 netdev_features_t features,
+				 const netdev_features_t *features,
 				 unsigned int offset)
 {
 	struct sk_buff *list_skb = skb_shinfo(skb)->frag_list;
@@ -3973,7 +3973,7 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
 						 nskb->data - tnl_hlen,
 						 offset + tnl_hlen);
 
-		if (skb_needs_linearize(nskb, features) &&
+		if (skb_needs_linearize(nskb, *features) &&
 		    __skb_linearize(nskb))
 			goto err_linearize;
 
@@ -3987,7 +3987,7 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
 
 	skb->prev = tail;
 
-	if (skb_needs_linearize(skb, features) &&
+	if (skb_needs_linearize(skb, *features) &&
 	    __skb_linearize(skb))
 		goto err_linearize;
 
@@ -4005,14 +4005,14 @@ EXPORT_SYMBOL_GPL(skb_segment_list);
 /**
  *	skb_segment - Perform protocol segmentation on skb.
  *	@head_skb: buffer to segment
- *	@features: features for the output path (see dev->features)
+ *	@feats: features for the output path (see dev->features)
  *
  *	This function performs segmentation on the given skb.  It returns
  *	a pointer to the first in a list of new skbs for the segments.
  *	In case of error it returns ERR_PTR(err).
  */
 struct sk_buff *skb_segment(struct sk_buff *head_skb,
-			    netdev_features_t features)
+			    const netdev_features_t *feats)
 {
 	struct sk_buff *segs = NULL;
 	struct sk_buff *tail = NULL;
@@ -4029,10 +4029,12 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
 	__be16 proto;
 	bool csum, sg;
 	int nfrags = skb_shinfo(head_skb)->nr_frags;
+	netdev_features_t features;
 	int err = -ENOMEM;
 	int i = 0;
 	int pos;
 
+	netdev_features_copy(features, *feats);
 	if (list_skb && !list_skb->head_frag && skb_headlen(list_skb) &&
 	    (skb_shinfo(head_skb)->gso_type & SKB_GSO_DODGY)) {
 		/* gso_size is untrusted, and we have a frag_list with a linear
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 67f71417032a..ec9d50586204 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1343,11 +1343,12 @@ void inet_sk_state_store(struct sock *sk, int newstate)
 }
 
 struct sk_buff *inet_gso_segment(struct sk_buff *skb,
-				 netdev_features_t features)
+				 const netdev_features_t *feats)
 {
 	bool udpfrag = false, fixedid = false, gso_partial, encap;
 	struct sk_buff *segs = ERR_PTR(-EINVAL);
 	const struct net_offload *ops;
+	netdev_features_t features;
 	unsigned int offset = 0;
 	struct iphdr *iph;
 	int proto, tot_len;
@@ -1373,6 +1374,8 @@ struct sk_buff *inet_gso_segment(struct sk_buff *skb,
 		goto out;
 	__skb_pull(skb, ihl);
 
+	netdev_features_copy(features, *feats);
+
 	encap = SKB_GSO_CB(skb)->encap_level > 0;
 	if (encap)
 		netdev_features_mask(features, skb->dev->hw_enc_features);
@@ -1393,7 +1396,7 @@ struct sk_buff *inet_gso_segment(struct sk_buff *skb,
 
 	ops = rcu_dereference(inet_offloads[proto]);
 	if (likely(ops && ops->callbacks.gso_segment)) {
-		segs = ops->callbacks.gso_segment(skb, features);
+		segs = ops->callbacks.gso_segment(skb, &features);
 		if (!segs)
 			skb->network_header = skb_mac_header(skb) + nhoff - skb->head;
 	}
@@ -1442,7 +1445,7 @@ struct sk_buff *inet_gso_segment(struct sk_buff *skb,
 }
 
 static struct sk_buff *ipip_gso_segment(struct sk_buff *skb,
-					netdev_features_t features)
+					const netdev_features_t *features)
 {
 	if (!(skb_shinfo(skb)->gso_type & SKB_GSO_IPXIP4))
 		return ERR_PTR(-EINVAL);
diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index b3d5cc34e3ec..36d76cff3075 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -108,14 +108,14 @@ static void esp4_gso_encap(struct xfrm_state *x, struct sk_buff *skb)
 
 static struct sk_buff *xfrm4_tunnel_gso_segment(struct xfrm_state *x,
 						struct sk_buff *skb,
-						netdev_features_t features)
+						const netdev_features_t *features)
 {
 	return skb_eth_gso_segment(skb, features, htons(ETH_P_IP));
 }
 
 static struct sk_buff *xfrm4_transport_gso_segment(struct xfrm_state *x,
 						   struct sk_buff *skb,
-						   netdev_features_t features)
+						   const netdev_features_t *features)
 {
 	const struct net_offload *ops;
 	struct sk_buff *segs = ERR_PTR(-EINVAL);
@@ -131,7 +131,7 @@ static struct sk_buff *xfrm4_transport_gso_segment(struct xfrm_state *x,
 
 static struct sk_buff *xfrm4_beet_gso_segment(struct xfrm_state *x,
 					      struct sk_buff *skb,
-					      netdev_features_t features)
+					      const netdev_features_t *features)
 {
 	struct xfrm_offload *xo = xfrm_offload(skb);
 	struct sk_buff *segs = ERR_PTR(-EINVAL);
@@ -172,7 +172,7 @@ static struct sk_buff *xfrm4_beet_gso_segment(struct xfrm_state *x,
 
 static struct sk_buff *xfrm4_outer_mode_gso_segment(struct xfrm_state *x,
 						    struct sk_buff *skb,
-						    netdev_features_t features)
+						    const netdev_features_t *features)
 {
 	switch (x->outer_mode.encap) {
 	case XFRM_MODE_TUNNEL:
@@ -187,12 +187,12 @@ static struct sk_buff *xfrm4_outer_mode_gso_segment(struct xfrm_state *x,
 }
 
 static struct sk_buff *esp4_gso_segment(struct sk_buff *skb,
-				        netdev_features_t features)
+					const netdev_features_t *features)
 {
 	struct xfrm_state *x;
 	struct ip_esp_hdr *esph;
 	struct crypto_aead *aead;
-	netdev_features_t esp_features = features;
+	netdev_features_t esp_features;
 	struct xfrm_offload *xo = xfrm_offload(skb);
 	struct sec_path *sp;
 
@@ -217,22 +217,23 @@ static struct sk_buff *esp4_gso_segment(struct sk_buff *skb,
 
 	skb->encap_hdr_csum = 1;
 
+	netdev_features_copy(esp_features, *features);
 	if ((!netdev_gso_partial_feature_test(skb->dev, NETIF_F_HW_ESP_BIT) &&
-	     !netdev_feature_test(NETIF_F_HW_ESP_BIT, features)) || x->xso.dev != skb->dev) {
-		netdev_features_andnot(esp_features, features,
+	     !netdev_feature_test(NETIF_F_HW_ESP_BIT, *features)) || x->xso.dev != skb->dev) {
+		netdev_features_andnot(esp_features, *features,
 				       NETIF_F_CSUM_MASK);
 		netdev_feature_del(NETIF_F_SG_BIT, esp_features);
 		netdev_feature_del(NETIF_F_SCTP_CRC_BIT, esp_features);
-	} else if (!netdev_feature_test(NETIF_F_HW_ESP_TX_CSUM_BIT, features) &&
+	} else if (!netdev_feature_test(NETIF_F_HW_ESP_TX_CSUM_BIT, *features) &&
 		   !netdev_gso_partial_feature_test(skb->dev, NETIF_F_HW_ESP_TX_CSUM_BIT)) {
-		netdev_features_andnot(esp_features, features,
+		netdev_features_andnot(esp_features, *features,
 				       NETIF_F_CSUM_MASK);
 		netdev_feature_del(NETIF_F_SCTP_CRC_BIT, esp_features);
 	}
 
 	xo->flags |= XFRM_GSO_SEGMENT;
 
-	return xfrm4_outer_mode_gso_segment(x, skb, esp_features);
+	return xfrm4_outer_mode_gso_segment(x, skb, &esp_features);
 }
 
 static int esp_input_tail(struct xfrm_state *x, struct sk_buff *skb)
diff --git a/net/ipv4/gre_offload.c b/net/ipv4/gre_offload.c
index 2434e7099190..5a39a390ed55 100644
--- a/net/ipv4/gre_offload.c
+++ b/net/ipv4/gre_offload.c
@@ -13,7 +13,7 @@
 #include <net/gro.h>
 
 static struct sk_buff *gre_gso_segment(struct sk_buff *skb,
-				       netdev_features_t features)
+				       const netdev_features_t *feats)
 {
 	int tnl_hlen = skb_inner_mac_header(skb) - skb_transport_header(skb);
 	bool need_csum, offload_csum, gso_partial, need_ipsec;
@@ -22,6 +22,7 @@ static struct sk_buff *gre_gso_segment(struct sk_buff *skb,
 	__be16 protocol = skb->protocol;
 	u16 mac_len = skb->mac_len;
 	int gre_offset, outer_hlen;
+	netdev_features_t features;
 
 	if (!skb->encapsulation)
 		goto out;
@@ -44,6 +45,7 @@ static struct sk_buff *gre_gso_segment(struct sk_buff *skb,
 	need_csum = !!(skb_shinfo(skb)->gso_type & SKB_GSO_GRE_CSUM);
 	skb->encap_hdr_csum = need_csum;
 
+	netdev_features_copy(features, *feats);
 	netdev_features_mask(features, skb->dev->hw_enc_features);
 	if (need_csum)
 		netdev_feature_del(NETIF_F_SCTP_CRC_BIT, features);
@@ -54,7 +56,7 @@ static struct sk_buff *gre_gso_segment(struct sk_buff *skb,
 			  netdev_active_feature_test(skb->dev, NETIF_F_HW_CSUM_BIT));
 
 	/* segment inner packet. */
-	segs = skb_mac_gso_segment(skb, features);
+	segs = skb_mac_gso_segment(skb, &features);
 	if (IS_ERR_OR_NULL(segs)) {
 		skb_gso_error_unwind(skb, protocol, tnl_hlen, mac_offset,
 				     mac_len);
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 8e9993eae1a4..20371a2abd17 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -265,7 +265,7 @@ static int ip_finish_output_gso(struct net *net, struct sock *sk,
 	netif_skb_features(skb, &features);
 	BUILD_BUG_ON(sizeof(*IPCB(skb)) > SKB_GSO_CB_OFFSET);
 	netdev_features_clear(features, NETIF_F_GSO_MASK);
-	segs = skb_gso_segment(skb, features);
+	segs = skb_gso_segment(skb, &features);
 	if (IS_ERR_OR_NULL(segs)) {
 		kfree_skb(skb);
 		return -ENOMEM;
diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
index e5d161cb0810..930dfb9557ed 100644
--- a/net/ipv4/tcp_offload.c
+++ b/net/ipv4/tcp_offload.c
@@ -28,7 +28,7 @@ static void tcp_gso_tstamp(struct sk_buff *skb, unsigned int ts_seq,
 }
 
 static struct sk_buff *tcp4_gso_segment(struct sk_buff *skb,
-					netdev_features_t features)
+					const netdev_features_t *features)
 {
 	if (!(skb_shinfo(skb)->gso_type & SKB_GSO_TCPV4))
 		return ERR_PTR(-EINVAL);
@@ -53,7 +53,7 @@ static struct sk_buff *tcp4_gso_segment(struct sk_buff *skb,
 }
 
 struct sk_buff *tcp_gso_segment(struct sk_buff *skb,
-				netdev_features_t features)
+				const netdev_features_t *feats)
 {
 	struct sk_buff *segs = ERR_PTR(-EINVAL);
 	unsigned int sum_truesize = 0;
@@ -66,6 +66,7 @@ struct sk_buff *tcp_gso_segment(struct sk_buff *skb,
 	struct sk_buff *gso_skb = skb;
 	__sum16 newcheck;
 	bool ooo_okay, copy_destructor;
+	netdev_features_t features;
 
 	th = tcp_hdr(skb);
 	thlen = th->doff * 4;
@@ -82,6 +83,7 @@ struct sk_buff *tcp_gso_segment(struct sk_buff *skb,
 	if (unlikely(skb->len <= mss))
 		goto out;
 
+	netdev_features_copy(features, *feats);
 	netdev_feature_add(NETIF_F_GSO_ROBUST_BIT, features);
 	if (skb_gso_ok(skb, features)) {
 		/* Packet is from an untrusted source, reset gso_segs. */
@@ -97,7 +99,7 @@ struct sk_buff *tcp_gso_segment(struct sk_buff *skb,
 	/* All segments but the first should have ooo_okay cleared */
 	skb->ooo_okay = 0;
 
-	segs = skb_segment(skb, features);
+	segs = skb_segment(skb, &features);
 	if (IS_ERR(segs))
 		goto out;
 
diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index 107a80518f61..91be6ed356f3 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -13,9 +13,9 @@
 #include <net/inet_common.h>
 
 static struct sk_buff *__skb_udp_tunnel_segment(struct sk_buff *skb,
-	netdev_features_t features,
+	const netdev_features_t *feats,
 	struct sk_buff *(*gso_inner_segment)(struct sk_buff *skb,
-					     netdev_features_t features),
+					     const netdev_features_t *features),
 	__be16 new_protocol, bool is_ipv6)
 {
 	int tnl_hlen = skb_inner_mac_header(skb) - skb_transport_header(skb);
@@ -26,6 +26,7 @@ static struct sk_buff *__skb_udp_tunnel_segment(struct sk_buff *skb,
 	__be16 protocol = skb->protocol;
 	u16 mac_len = skb->mac_len;
 	int udp_offset, outer_hlen;
+	netdev_features_t features;
 	__wsum partial;
 	bool need_ipsec;
 
@@ -68,6 +69,7 @@ static struct sk_buff *__skb_udp_tunnel_segment(struct sk_buff *skb,
 			   (is_ipv6 ? netdev_active_feature_test(skb->dev, NETIF_F_IPV6_CSUM_BIT) :
 				      netdev_active_feature_test(skb->dev, NETIF_F_IP_CSUM_BIT))));
 
+	netdev_features_copy(features, *feats);
 	netdev_features_mask(features, skb->dev->hw_enc_features);
 	if (need_csum)
 		netdev_feature_del(NETIF_F_SCTP_CRC_BIT, features);
@@ -83,7 +85,7 @@ static struct sk_buff *__skb_udp_tunnel_segment(struct sk_buff *skb,
 	}
 
 	/* segment inner packet. */
-	segs = gso_inner_segment(skb, features);
+	segs = gso_inner_segment(skb, &features);
 	if (IS_ERR_OR_NULL(segs)) {
 		skb_gso_error_unwind(skb, protocol, tnl_hlen, mac_offset,
 				     mac_len);
@@ -150,7 +152,7 @@ static struct sk_buff *__skb_udp_tunnel_segment(struct sk_buff *skb,
 }
 
 struct sk_buff *skb_udp_tunnel_segment(struct sk_buff *skb,
-				       netdev_features_t features,
+				       const netdev_features_t *features,
 				       bool is_ipv6)
 {
 	const struct net_offload __rcu **offloads;
@@ -158,7 +160,7 @@ struct sk_buff *skb_udp_tunnel_segment(struct sk_buff *skb,
 	const struct net_offload *ops;
 	struct sk_buff *segs = ERR_PTR(-EINVAL);
 	struct sk_buff *(*gso_inner_segment)(struct sk_buff *skb,
-					     netdev_features_t features);
+					     const netdev_features_t *features);
 
 	rcu_read_lock();
 
@@ -247,7 +249,7 @@ static struct sk_buff *__udpv4_gso_segment_list_csum(struct sk_buff *segs)
 }
 
 static struct sk_buff *__udp_gso_segment_list(struct sk_buff *skb,
-					      netdev_features_t features,
+					      const netdev_features_t *features,
 					      bool is_ipv6)
 {
 	unsigned int mss = skb_shinfo(skb)->gso_size;
@@ -262,7 +264,7 @@ static struct sk_buff *__udp_gso_segment_list(struct sk_buff *skb,
 }
 
 struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
-				  netdev_features_t features, bool is_ipv6)
+				  const netdev_features_t *features, bool is_ipv6)
 {
 	struct sock *sk = gso_skb->sk;
 	unsigned int sum_truesize = 0;
@@ -366,18 +368,21 @@ struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
 EXPORT_SYMBOL_GPL(__udp_gso_segment);
 
 static struct sk_buff *udp4_ufo_fragment(struct sk_buff *skb,
-					 netdev_features_t features)
+					 const netdev_features_t *feats)
 {
 	struct sk_buff *segs = ERR_PTR(-EINVAL);
+	netdev_features_t features;
 	unsigned int mss;
 	__wsum csum;
 	struct udphdr *uh;
 	struct iphdr *iph;
 
+	netdev_features_copy(features, *feats);
+
 	if (skb->encapsulation &&
 	    (skb_shinfo(skb)->gso_type &
 	     (SKB_GSO_UDP_TUNNEL|SKB_GSO_UDP_TUNNEL_CSUM))) {
-		segs = skb_udp_tunnel_segment(skb, features, false);
+		segs = skb_udp_tunnel_segment(skb, &features, false);
 		goto out;
 	}
 
@@ -388,7 +393,7 @@ static struct sk_buff *udp4_ufo_fragment(struct sk_buff *skb,
 		goto out;
 
 	if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4)
-		return __udp_gso_segment(skb, features, false);
+		return __udp_gso_segment(skb, &features, false);
 
 	mss = skb_shinfo(skb)->gso_size;
 	if (unlikely(skb->len <= mss))
@@ -420,7 +425,7 @@ static struct sk_buff *udp4_ufo_fragment(struct sk_buff *skb,
 	/* Fragment the skb. IP headers of the fragments are updated in
 	 * inet_gso_segment()
 	 */
-	segs = skb_segment(skb, features);
+	segs = skb_segment(skb, &features);
 out:
 	return segs;
 }
diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index 5d8642b40a66..4956a83d409a 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -143,14 +143,14 @@ static void esp6_gso_encap(struct xfrm_state *x, struct sk_buff *skb)
 
 static struct sk_buff *xfrm6_tunnel_gso_segment(struct xfrm_state *x,
 						struct sk_buff *skb,
-						netdev_features_t features)
+						const netdev_features_t *features)
 {
 	return skb_eth_gso_segment(skb, features, htons(ETH_P_IPV6));
 }
 
 static struct sk_buff *xfrm6_transport_gso_segment(struct xfrm_state *x,
 						   struct sk_buff *skb,
-						   netdev_features_t features)
+						   const netdev_features_t *features)
 {
 	const struct net_offload *ops;
 	struct sk_buff *segs = ERR_PTR(-EINVAL);
@@ -166,7 +166,7 @@ static struct sk_buff *xfrm6_transport_gso_segment(struct xfrm_state *x,
 
 static struct sk_buff *xfrm6_beet_gso_segment(struct xfrm_state *x,
 					      struct sk_buff *skb,
-					      netdev_features_t features)
+					      const netdev_features_t *features)
 {
 	struct xfrm_offload *xo = xfrm_offload(skb);
 	struct sk_buff *segs = ERR_PTR(-EINVAL);
@@ -211,7 +211,7 @@ static struct sk_buff *xfrm6_beet_gso_segment(struct xfrm_state *x,
 
 static struct sk_buff *xfrm6_outer_mode_gso_segment(struct xfrm_state *x,
 						    struct sk_buff *skb,
-						    netdev_features_t features)
+						    const netdev_features_t *features)
 {
 	switch (x->outer_mode.encap) {
 	case XFRM_MODE_TUNNEL:
@@ -226,12 +226,12 @@ static struct sk_buff *xfrm6_outer_mode_gso_segment(struct xfrm_state *x,
 }
 
 static struct sk_buff *esp6_gso_segment(struct sk_buff *skb,
-				        netdev_features_t features)
+					const netdev_features_t *features)
 {
 	struct xfrm_state *x;
 	struct ip_esp_hdr *esph;
 	struct crypto_aead *aead;
-	netdev_features_t esp_features = features;
+	netdev_features_t esp_features;
 	struct xfrm_offload *xo = xfrm_offload(skb);
 	struct sec_path *sp;
 
@@ -256,20 +256,21 @@ static struct sk_buff *esp6_gso_segment(struct sk_buff *skb,
 
 	skb->encap_hdr_csum = 1;
 
-	if (!netdev_feature_test(NETIF_F_HW_ESP_BIT, features) || x->xso.dev != skb->dev) {
-		netdev_features_andnot(esp_features, features,
+	netdev_features_copy(esp_features, *features);
+	if (!netdev_feature_test(NETIF_F_HW_ESP_BIT, *features) || x->xso.dev != skb->dev) {
+		netdev_features_andnot(esp_features, *features,
 				       NETIF_F_CSUM_MASK);
 		netdev_feature_del(NETIF_F_SG_BIT, esp_features);
 		netdev_feature_del(NETIF_F_SCTP_CRC_BIT, esp_features);
-	} else if (!netdev_feature_test(NETIF_F_HW_ESP_TX_CSUM_BIT, features)) {
-		netdev_features_andnot(esp_features, features,
+	} else if (!netdev_feature_test(NETIF_F_HW_ESP_TX_CSUM_BIT, *features)) {
+		netdev_features_andnot(esp_features, *features,
 				       NETIF_F_CSUM_MASK);
 		netdev_feature_del(NETIF_F_SCTP_CRC_BIT, esp_features);
 	}
 
 	xo->flags |= XFRM_GSO_SEGMENT;
 
-	return xfrm6_outer_mode_gso_segment(x, skb, esp_features);
+	return xfrm6_outer_mode_gso_segment(x, skb, &esp_features);
 }
 
 static int esp6_input_tail(struct xfrm_state *x, struct sk_buff *skb)
diff --git a/net/ipv6/ip6_offload.c b/net/ipv6/ip6_offload.c
index db7737bac5c3..4206aed0bb6c 100644
--- a/net/ipv6/ip6_offload.c
+++ b/net/ipv6/ip6_offload.c
@@ -72,11 +72,12 @@ static int ipv6_gso_pull_exthdrs(struct sk_buff *skb, int proto)
 }
 
 static struct sk_buff *ipv6_gso_segment(struct sk_buff *skb,
-	netdev_features_t features)
+					const netdev_features_t *feats)
 {
 	struct sk_buff *segs = ERR_PTR(-EINVAL);
 	struct ipv6hdr *ipv6h;
 	const struct net_offload *ops;
+	netdev_features_t features;
 	int proto, nexthdr;
 	struct frag_hdr *fptr;
 	unsigned int payload_len;
@@ -113,6 +114,7 @@ static struct sk_buff *ipv6_gso_segment(struct sk_buff *skb,
 	if (unlikely(!pskb_may_pull(skb, sizeof(*ipv6h))))
 		goto out;
 
+	netdev_features_copy(features, *feats);
 	encap = SKB_GSO_CB(skb)->encap_level > 0;
 	if (encap)
 		netdev_features_mask(features, skb->dev->hw_enc_features);
@@ -135,7 +137,7 @@ static struct sk_buff *ipv6_gso_segment(struct sk_buff *skb,
 	ops = rcu_dereference(inet6_offloads[proto]);
 	if (likely(ops && ops->callbacks.gso_segment)) {
 		skb_reset_transport_header(skb);
-		segs = ops->callbacks.gso_segment(skb, features);
+		segs = ops->callbacks.gso_segment(skb, &features);
 		if (!segs)
 			skb->network_header = skb_mac_header(skb) + nhoff - skb->head;
 	}
@@ -419,7 +421,7 @@ static struct packet_offload ipv6_packet_offload __read_mostly = {
 };
 
 static struct sk_buff *sit_gso_segment(struct sk_buff *skb,
-				       netdev_features_t features)
+				       const netdev_features_t *features)
 {
 	if (!(skb_shinfo(skb)->gso_type & SKB_GSO_IPXIP4))
 		return ERR_PTR(-EINVAL);
@@ -428,7 +430,7 @@ static struct sk_buff *sit_gso_segment(struct sk_buff *skb,
 }
 
 static struct sk_buff *ip4ip6_gso_segment(struct sk_buff *skb,
-					  netdev_features_t features)
+					  const netdev_features_t *features)
 {
 	if (!(skb_shinfo(skb)->gso_type & SKB_GSO_IPXIP6))
 		return ERR_PTR(-EINVAL);
@@ -437,7 +439,7 @@ static struct sk_buff *ip4ip6_gso_segment(struct sk_buff *skb,
 }
 
 static struct sk_buff *ip6ip6_gso_segment(struct sk_buff *skb,
-					  netdev_features_t features)
+					  const netdev_features_t *features)
 {
 	if (!(skb_shinfo(skb)->gso_type & SKB_GSO_IPXIP6))
 		return ERR_PTR(-EINVAL);
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 0ac686957ab7..0343f9575d4c 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -150,7 +150,7 @@ ip6_finish_output_gso_slowpath_drop(struct net *net, struct sock *sk,
 	 */
 	netif_skb_features(skb, &features);
 	netdev_features_clear(features, NETIF_F_GSO_MASK);
-	segs = skb_gso_segment(skb, features);
+	segs = skb_gso_segment(skb, &features);
 	if (IS_ERR_OR_NULL(segs)) {
 		kfree_skb(skb);
 		return -ENOMEM;
diff --git a/net/ipv6/tcpv6_offload.c b/net/ipv6/tcpv6_offload.c
index 39db5a226855..a1f192fa9023 100644
--- a/net/ipv6/tcpv6_offload.c
+++ b/net/ipv6/tcpv6_offload.c
@@ -40,7 +40,7 @@ INDIRECT_CALLABLE_SCOPE int tcp6_gro_complete(struct sk_buff *skb, int thoff)
 }
 
 static struct sk_buff *tcp6_gso_segment(struct sk_buff *skb,
-					netdev_features_t features)
+					const netdev_features_t *features)
 {
 	struct tcphdr *th;
 
diff --git a/net/ipv6/udp_offload.c b/net/ipv6/udp_offload.c
index 77a0c17b1894..4ea3149a8b9d 100644
--- a/net/ipv6/udp_offload.c
+++ b/net/ipv6/udp_offload.c
@@ -16,7 +16,7 @@
 #include <net/gro.h>
 
 static struct sk_buff *udp6_ufo_fragment(struct sk_buff *skb,
-					 netdev_features_t features)
+					 const netdev_features_t *feats)
 {
 	struct sk_buff *segs = ERR_PTR(-EINVAL);
 	unsigned int mss;
@@ -25,13 +25,16 @@ static struct sk_buff *udp6_ufo_fragment(struct sk_buff *skb,
 	u8 *packet_start, *prevhdr;
 	u8 nexthdr;
 	u8 frag_hdr_sz = sizeof(struct frag_hdr);
+	netdev_features_t features;
 	__wsum csum;
 	int tnl_hlen;
 	int err;
 
+	netdev_features_copy(features, *feats);
+
 	if (skb->encapsulation && skb_shinfo(skb)->gso_type &
 	    (SKB_GSO_UDP_TUNNEL|SKB_GSO_UDP_TUNNEL_CSUM))
-		segs = skb_udp_tunnel_segment(skb, features, true);
+		segs = skb_udp_tunnel_segment(skb, &features, true);
 	else {
 		const struct ipv6hdr *ipv6h;
 		struct udphdr *uh;
@@ -43,7 +46,7 @@ static struct sk_buff *udp6_ufo_fragment(struct sk_buff *skb,
 			goto out;
 
 		if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4)
-			return __udp_gso_segment(skb, features, true);
+			return __udp_gso_segment(skb, &features, true);
 
 		mss = skb_shinfo(skb)->gso_size;
 		if (unlikely(skb->len <= mss))
@@ -105,7 +108,7 @@ static struct sk_buff *udp6_ufo_fragment(struct sk_buff *skb,
 		/* Fragment the skb. ipv6 header and the remaining fields of the
 		 * fragment header are updated in ipv6_gso_segment()
 		 */
-		segs = skb_segment(skb, features);
+		segs = skb_segment(skb, &features);
 	}
 
 out:
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 28ab258da6af..776e422e3a5a 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4207,7 +4207,7 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 		struct sk_buff *segs;
 
 		netdev_features_zero(feats);
-		segs = skb_gso_segment(skb, feats);
+		segs = skb_gso_segment(skb, &feats);
 		if (IS_ERR(segs)) {
 			goto out_free;
 		} else if (segs) {
diff --git a/net/mpls/mpls_gso.c b/net/mpls/mpls_gso.c
index 4cf6a6c2eaaa..34fd4efdf4cb 100644
--- a/net/mpls/mpls_gso.c
+++ b/net/mpls/mpls_gso.c
@@ -18,7 +18,7 @@
 #include <net/mpls.h>
 
 static struct sk_buff *mpls_gso_segment(struct sk_buff *skb,
-				       netdev_features_t features)
+				       const netdev_features_t *features)
 {
 	struct sk_buff *segs = ERR_PTR(-EINVAL);
 	u16 mac_offset = skb->mac_header;
@@ -44,8 +44,8 @@ static struct sk_buff *mpls_gso_segment(struct sk_buff *skb,
 	skb_reset_mac_header(skb);
 
 	/* Segment inner packet. */
-	netdev_features_and(mpls_features, skb->dev->mpls_features, features);
-	segs = skb_mac_gso_segment(skb, mpls_features);
+	netdev_features_and(mpls_features, skb->dev->mpls_features, *features);
+	segs = skb_mac_gso_segment(skb, &mpls_features);
 	if (IS_ERR_OR_NULL(segs)) {
 		skb_gso_error_unwind(skb, mpls_protocol, mpls_hlen, mac_offset,
 				     mac_len);
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 32644cc2b153..d3401fdb4b71 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -815,7 +815,7 @@ nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
 
 	nf_bridge_adjust_skb_data(skb);
 	netdev_features_zero(feats);
-	segs = skb_gso_segment(skb, feats);
+	segs = skb_gso_segment(skb, &feats);
 	/* Does not use PTR_ERR to limit the number of error codes that can be
 	 * returned by nf_queue.  For instance, callers rely on -ESRCH to
 	 * mean 'ignore this hook'.
diff --git a/net/nsh/nsh.c b/net/nsh/nsh.c
index cc38680a2982..6d06e079ef3a 100644
--- a/net/nsh/nsh.c
+++ b/net/nsh/nsh.c
@@ -75,7 +75,7 @@ int nsh_pop(struct sk_buff *skb)
 EXPORT_SYMBOL_GPL(nsh_pop);
 
 static struct sk_buff *nsh_gso_segment(struct sk_buff *skb,
-				       netdev_features_t features)
+				       const netdev_features_t *features)
 {
 	struct sk_buff *segs = ERR_PTR(-EINVAL);
 	unsigned int nsh_len, mac_len;
@@ -107,9 +107,9 @@ static struct sk_buff *nsh_gso_segment(struct sk_buff *skb,
 	skb->protocol = proto;
 
 	netdev_features_zero(feats);
-	if (netdev_feature_test(NETIF_F_SG_BIT, features))
+	if (netdev_feature_test(NETIF_F_SG_BIT, *features))
 		netdev_feature_add(NETIF_F_SG_BIT, feats);
-	segs = skb_mac_gso_segment(skb, feats);
+	segs = skb_mac_gso_segment(skb, &feats);
 	if (IS_ERR_OR_NULL(segs)) {
 		skb_gso_error_unwind(skb, htons(ETH_P_NSH), nsh_len,
 				     skb->network_header - nhoff,
diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 8885188e8e19..d516fadb02de 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -335,7 +335,7 @@ static int queue_gso_packets(struct datapath *dp, struct sk_buff *skb,
 	BUILD_BUG_ON(sizeof(*OVS_CB(skb)) > SKB_GSO_CB_OFFSET);
 	netdev_features_zero(features);
 	netdev_feature_add(NETIF_F_SG_BIT, features);
-	segs = __skb_gso_segment(skb, features, false);
+	segs = __skb_gso_segment(skb, &features, false);
 	if (IS_ERR(segs))
 		return PTR_ERR(segs);
 	if (segs == NULL)
diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index 837efd4c786f..be310b947270 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -1745,7 +1745,7 @@ static s32 cake_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 
 		netif_skb_features(skb, &features);
 		netdev_features_clear(features, NETIF_F_GSO_MASK);
-		segs = skb_gso_segment(skb, features);
+		segs = skb_gso_segment(skb, &features);
 		if (IS_ERR_OR_NULL(segs))
 			return qdisc_drop(skb, sch, to_free);
 
diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index cb253eb3a936..6ee054f00a74 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -417,7 +417,7 @@ static struct sk_buff *netem_segment(struct sk_buff *skb, struct Qdisc *sch,
 
 	netif_skb_features(skb, &features);
 	netdev_features_clear(features, NETIF_F_GSO_MASK);
-	segs = skb_gso_segment(skb, features);
+	segs = skb_gso_segment(skb, &features);
 
 	if (IS_ERR_OR_NULL(segs)) {
 		qdisc_drop(skb, sch, to_free);
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 96bff2fdeecb..b86c2eb285cb 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -465,7 +465,7 @@ static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 
 		netif_skb_features(skb, &features);
 		netdev_features_clear(features, NETIF_F_GSO_MASK);
-		segs = skb_gso_segment(skb, features);
+		segs = skb_gso_segment(skb, &features);
 		if (IS_ERR_OR_NULL(segs))
 			return qdisc_drop(skb, sch, to_free);
 
diff --git a/net/sched/sch_tbf.c b/net/sched/sch_tbf.c
index ce0bb68b02f3..12dd6e270632 100644
--- a/net/sched/sch_tbf.c
+++ b/net/sched/sch_tbf.c
@@ -213,7 +213,7 @@ static int tbf_segment(struct sk_buff *skb, struct Qdisc *sch,
 
 	netif_skb_features(skb, &features);
 	netdev_features_clear(features, NETIF_F_GSO_MASK);
-	segs = skb_gso_segment(skb, features);
+	segs = skb_gso_segment(skb, &features);
 
 	if (IS_ERR_OR_NULL(segs))
 		return qdisc_drop(skb, sch, to_free);
diff --git a/net/sctp/offload.c b/net/sctp/offload.c
index c3d81154771e..d4e1f70e32b8 100644
--- a/net/sctp/offload.c
+++ b/net/sctp/offload.c
@@ -36,10 +36,10 @@ static __le32 sctp_gso_make_checksum(struct sk_buff *skb)
 }
 
 static struct sk_buff *sctp_gso_segment(struct sk_buff *skb,
-					netdev_features_t features)
+					const netdev_features_t *features)
 {
 	struct sk_buff *segs = ERR_PTR(-EINVAL);
-	netdev_features_t tmp = features;
+	netdev_features_t tmp;
 	struct sctphdr *sh;
 
 	if (!skb_is_gso_sctp(skb))
@@ -70,15 +70,15 @@ static struct sk_buff *sctp_gso_segment(struct sk_buff *skb,
 		goto out;
 	}
 
-	tmp = features;
+	netdev_features_copy(tmp, *features);
 	netdev_feature_add(NETIF_F_HW_CSUM_BIT, tmp);
 	netdev_feature_del(NETIF_F_SG_BIT, tmp);
-	segs = skb_segment(skb, tmp);
+	segs = skb_segment(skb, &tmp);
 	if (IS_ERR(segs))
 		goto out;
 
 	/* All that is left is update SCTP CRC if necessary */
-	if (!netdev_feature_test(NETIF_F_SCTP_CRC_BIT, features)) {
+	if (!netdev_feature_test(NETIF_F_SCTP_CRC_BIT, *features)) {
 		for (skb = segs; skb; skb = skb->next) {
 			if (skb->ip_summed == CHECKSUM_PARTIAL) {
 				sh = sctp_hdr(skb);
diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index 0ec7a813fab3..b53f142b02de 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -144,7 +144,7 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
 		netdev_feature_del(NETIF_F_HW_ESP_BIT, esp_features);
 		netdev_feature_del(NETIF_F_GSO_ESP_BIT, esp_features);
 
-		segs = skb_gso_segment(skb, esp_features);
+		segs = skb_gso_segment(skb, &esp_features);
 		if (IS_ERR(segs)) {
 			kfree_skb(skb);
 			dev_core_stats_tx_dropped_inc(dev);
diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index 9ade97734543..bd1a1dcdc003 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -624,7 +624,7 @@ static int xfrm_output_gso(struct net *net, struct sock *sk, struct sk_buff *skb
 	BUILD_BUG_ON(sizeof(*IPCB(skb)) > SKB_GSO_CB_OFFSET);
 	BUILD_BUG_ON(sizeof(*IP6CB(skb)) > SKB_GSO_CB_OFFSET);
 	netdev_features_zero(feats);
-	segs = skb_gso_segment(skb, feats);
+	segs = skb_gso_segment(skb, &feats);
 	kfree_skb(skb);
 	if (IS_ERR(segs))
 		return PTR_ERR(segs);
-- 
2.33.0

