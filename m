Return-Path: <netdev+bounces-9335-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 39B4E72880F
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 21:18:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E1B4E28175B
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 19:18:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D40151F17C;
	Thu,  8 Jun 2023 19:18:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8FE168CE
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 19:18:18 +0000 (UTC)
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AC6935B3
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 12:17:41 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5695f6ebd85so11944537b3.3
        for <netdev@vger.kernel.org>; Thu, 08 Jun 2023 12:17:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686251859; x=1688843859;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=HuVCYMtQCfb3fFwJbupMko9qrCjiA8vSkiv106DBbrk=;
        b=6kdim1TNFl0iJCAnsXT2bdRwfYvG4QJI3BZKOvI6NsTy/2Yizw8/CWZG5KL5ZlafvT
         jsaVEIPnqplZDdLSO4lW0RU/Pk0nqOI7wOYZF0FzXLZHZqNksW4YoGQfZmCYplnjt6cW
         D/a9JZOumjuKEev0VEBdda/1XQsO0KyhELK9szllPDMl9UxpJn6yshT8ZYia1ln29MCm
         gp04dTl+IdBs9iSYf0yIBNq+MBHMJN07Lc6ehKw6gJXPJfiEoJLoF2ED9JgOl4yXBjLO
         9GBQIVVZS88D+g/XFToYIN30Jif/454MShim+nlK81wJYknNKaL6BBpFQfSQ1bqjvQ2H
         w/9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686251859; x=1688843859;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HuVCYMtQCfb3fFwJbupMko9qrCjiA8vSkiv106DBbrk=;
        b=YL7kHVmhw1N1Ogs/Yh5Ijuo9SjLRXMM9Y2BbTwZj9Prat6W4a4dPbJ4y6f7fzm3IbV
         kFfxsBz0h/MHn6JpoRqqAnDA9nYUFCv2Ho0ddFqBMYIZLAAwbRQ/OYZgJCopF31Dal5x
         DbovlDhOTQNJEBxd63uss1n84yrPD1rtJyBsYX8Y4rlf4qHuxNKoqDzwlBx+9eurYYkx
         YyQHWcyGxKFLyaBEeTAEbGNY+MptSga3SckKKMEFunrke+7vkeVL7BIH4/IGv3T6APUm
         5wbcZN/eyP19Qm4N2/P3Rmd4QNRDB2iI7XZ+5YeTK+UA9VOT7pZSrbG5t//IoZMPpMFe
         WRUQ==
X-Gm-Message-State: AC+VfDxrBFGKtD5ZitHR7dqkoL8ERSpCyqcibIaF207gIQrpX+mI2I7q
	XR7/nWyH0HBW94MUS561NDg2BofaTfnEZw==
X-Google-Smtp-Source: ACHHUZ7FrQFU3NExNBxVPGx5LSe75iOoffOE7cQFqi01msqUiOza5DLo5x3zOrXlboyFZuHVM1ubkHBmr26T6g==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:690c:70e:b0:568:ed32:67ec with SMTP
 id bs14-20020a05690c070e00b00568ed3267ecmr318160ywb.8.1686251859506; Thu, 08
 Jun 2023 12:17:39 -0700 (PDT)
Date: Thu,  8 Jun 2023 19:17:37 +0000
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230608191738.3947077-1-edumazet@google.com>
Subject: [PATCH net-next] net: move gso declarations and functions to their
 own files
From: Eric Dumazet <edumazet@google.com>
To: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, eric.dumazet@gmail.com, 
	Eric Dumazet <edumazet@google.com>, Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Move declarations into include/net/gso.h and code into net/core/gso.c

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Stanislav Fomichev <sdf@google.com>
---
 drivers/net/ethernet/broadcom/tg3.c           |   1 +
 .../net/ethernet/myricom/myri10ge/myri10ge.c  |   1 +
 drivers/net/ethernet/sfc/siena/tx_common.c    |   1 +
 drivers/net/ethernet/sfc/tx_common.c          |   1 +
 drivers/net/tap.c                             |   1 +
 drivers/net/usb/r8152.c                       |   1 +
 drivers/net/wireguard/device.c                |   1 +
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c   |   1 +
 include/linux/netdevice.h                     |  26 +-
 include/linux/skbuff.h                        |  71 -----
 include/net/gro.h                             |   1 +
 include/net/gso.h                             | 109 +++++++
 include/net/udp.h                             |   1 +
 net/core/Makefile                             |   2 +-
 net/core/dev.c                                |  70 +----
 net/core/gro.c                                |  59 +---
 net/core/gso.c                                | 273 ++++++++++++++++++
 net/core/skbuff.c                             | 142 +--------
 net/ipv4/af_inet.c                            |   1 +
 net/ipv4/esp4_offload.c                       |   1 +
 net/ipv4/gre_offload.c                        |   1 +
 net/ipv4/ip_output.c                          |   1 +
 net/ipv4/tcp_offload.c                        |   1 +
 net/ipv4/udp.c                                |   1 +
 net/ipv4/udp_offload.c                        |   1 +
 net/ipv6/esp6_offload.c                       |   1 +
 net/ipv6/ip6_offload.c                        |   1 +
 net/ipv6/ip6_output.c                         |   1 +
 net/ipv6/udp_offload.c                        |   1 +
 net/mac80211/tx.c                             |   1 +
 net/mpls/af_mpls.c                            |   1 +
 net/mpls/mpls_gso.c                           |   1 +
 net/netfilter/nf_flow_table_ip.c              |   1 +
 net/netfilter/nfnetlink_queue.c               |   1 +
 net/nsh/nsh.c                                 |   1 +
 net/openvswitch/actions.c                     |   1 +
 net/openvswitch/datapath.c                    |   1 +
 net/sched/act_police.c                        |   1 +
 net/sched/sch_cake.c                          |   1 +
 net/sched/sch_netem.c                         |   1 +
 net/sched/sch_taprio.c                        |   1 +
 net/sched/sch_tbf.c                           |   1 +
 net/sctp/offload.c                            |   1 +
 net/xfrm/xfrm_device.c                        |   1 +
 net/xfrm/xfrm_interface_core.c                |   1 +
 net/xfrm/xfrm_output.c                        |   1 +
 46 files changed, 425 insertions(+), 365 deletions(-)
 create mode 100644 include/net/gso.h
 create mode 100644 net/core/gso.c

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 58747292521d8199a85173cad8f2d8afc4473a99..5e68a6a4b2afb6dec58f8426de25f4bc091a4bb9 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -57,6 +57,7 @@
 #include <linux/crc32poly.h>
 
 #include <net/checksum.h>
+#include <net/gso.h>
 #include <net/ip.h>
 
 #include <linux/io.h>
diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index c5687d94ea88506e408fe7a89067f2ddbf005c35..7b7e1c5b00f4728cccfb693e2ab4e32b9613616e 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -66,6 +66,7 @@
 #include <linux/slab.h>
 #include <linux/prefetch.h>
 #include <net/checksum.h>
+#include <net/gso.h>
 #include <net/ip.h>
 #include <net/tcp.h>
 #include <asm/byteorder.h>
diff --git a/drivers/net/ethernet/sfc/siena/tx_common.c b/drivers/net/ethernet/sfc/siena/tx_common.c
index 93a32d61944f08fdb9434174bbb68054ae01c3a9..a7a9ab304e13686dbddbb8718d1af4df664c44e5 100644
--- a/drivers/net/ethernet/sfc/siena/tx_common.c
+++ b/drivers/net/ethernet/sfc/siena/tx_common.c
@@ -12,6 +12,7 @@
 #include "efx.h"
 #include "nic_common.h"
 #include "tx_common.h"
+#include <net/gso.h>
 
 static unsigned int efx_tx_cb_page_count(struct efx_tx_queue *tx_queue)
 {
diff --git a/drivers/net/ethernet/sfc/tx_common.c b/drivers/net/ethernet/sfc/tx_common.c
index 67e789b96c437cb8f230b074c846d6b5884d62cc..4ce7d00e697d003ba39e92b0d1678da01150c2a8 100644
--- a/drivers/net/ethernet/sfc/tx_common.c
+++ b/drivers/net/ethernet/sfc/tx_common.c
@@ -12,6 +12,7 @@
 #include "efx.h"
 #include "nic_common.h"
 #include "tx_common.h"
+#include <net/gso.h>
 
 static unsigned int efx_tx_cb_page_count(struct efx_tx_queue *tx_queue)
 {
diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index d30d730ed5a71b8cc31880acc0f82d4b0f65f739..9137fb8c1c420a792211cb70105144e8c2d73bc9 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -18,6 +18,7 @@
 #include <linux/fs.h>
 #include <linux/uio.h>
 
+#include <net/gso.h>
 #include <net/net_namespace.h>
 #include <net/rtnetlink.h>
 #include <net/sock.h>
diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 0999a58ca9d26945db7c5991e1637597a4a5d2e7..0738baa5b82e42ef156fe6bab3982d5440bfbeb7 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -27,6 +27,7 @@
 #include <linux/firmware.h>
 #include <crypto/hash.h>
 #include <linux/usb/r8152.h>
+#include <net/gso.h>
 
 /* Information for net-next */
 #define NETNEXT_VERSION		"12"
diff --git a/drivers/net/wireguard/device.c b/drivers/net/wireguard/device.c
index d58e9f818d3b791bc181beb888ff2165a107dec1..258dcc1039216f311a223fd348295d4b5e03a3ed 100644
--- a/drivers/net/wireguard/device.c
+++ b/drivers/net/wireguard/device.c
@@ -20,6 +20,7 @@
 #include <linux/icmp.h>
 #include <linux/suspend.h>
 #include <net/dst_metadata.h>
+#include <net/gso.h>
 #include <net/icmp.h>
 #include <net/rtnetlink.h>
 #include <net/ip_tunnels.h>
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 00719e1304386454f350677322764e46483fab57..682733193d3de1d3dfcb10d1964cd15dd4cf7290 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -7,6 +7,7 @@
 #include <linux/ieee80211.h>
 #include <linux/etherdevice.h>
 #include <linux/tcp.h>
+#include <net/gso.h>
 #include <net/ip.h>
 #include <net/ipv6.h>
 
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index c2f0c6002a84b206b26a16c432920b92740391b4..2d6cb2bf2f05cf870fab33b2a47f32c113a581fe 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4827,13 +4827,6 @@ int skb_crc32c_csum_help(struct sk_buff *skb);
 int skb_csum_hwoffload_help(struct sk_buff *skb,
 			    const netdev_features_t features);
 
-struct sk_buff *__skb_gso_segment(struct sk_buff *skb,
-				  netdev_features_t features, bool tx_path);
-struct sk_buff *skb_eth_gso_segment(struct sk_buff *skb,
-				    netdev_features_t features, __be16 type);
-struct sk_buff *skb_mac_gso_segment(struct sk_buff *skb,
-				    netdev_features_t features);
-
 struct netdev_bonding_info {
 	ifslave	slave;
 	ifbond	master;
@@ -4856,11 +4849,6 @@ static inline void ethtool_notify(struct net_device *dev, unsigned int cmd,
 }
 #endif
 
-static inline
-struct sk_buff *skb_gso_segment(struct sk_buff *skb, netdev_features_t features)
-{
-	return __skb_gso_segment(skb, features, true);
-}
 __be16 skb_network_protocol(struct sk_buff *skb, int *depth);
 
 static inline bool can_checksum_protocol(netdev_features_t features,
@@ -4987,6 +4975,7 @@ netdev_features_t passthru_features_check(struct sk_buff *skb,
 					  struct net_device *dev,
 					  netdev_features_t features);
 netdev_features_t netif_skb_features(struct sk_buff *skb);
+void skb_warn_bad_offload(const struct sk_buff *skb);
 
 static inline bool net_gso_ok(netdev_features_t features, int gso_type)
 {
@@ -5035,19 +5024,6 @@ void netif_set_tso_max_segs(struct net_device *dev, unsigned int segs);
 void netif_inherit_tso_max(struct net_device *to,
 			   const struct net_device *from);
 
-static inline void skb_gso_error_unwind(struct sk_buff *skb, __be16 protocol,
-					int pulled_hlen, u16 mac_offset,
-					int mac_len)
-{
-	skb->protocol = protocol;
-	skb->encapsulation = 1;
-	skb_push(skb, pulled_hlen);
-	skb_reset_transport_header(skb);
-	skb->mac_header = mac_offset;
-	skb->network_header = skb->mac_header + mac_len;
-	skb->mac_len = mac_len;
-}
-
 static inline bool netif_is_macsec(const struct net_device *dev)
 {
 	return dev->priv_flags & IFF_MACSEC;
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index e2f48ddb2f7cff99a63bf141c6e0b189f3491f8c..91ed66952580a005181e34f4c576cf343d4579c9 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3974,8 +3974,6 @@ int skb_zerocopy(struct sk_buff *to, struct sk_buff *from,
 void skb_split(struct sk_buff *skb, struct sk_buff *skb1, const u32 len);
 int skb_shift(struct sk_buff *tgt, struct sk_buff *skb, int shiftlen);
 void skb_scrub_packet(struct sk_buff *skb, bool xnet);
-bool skb_gso_validate_network_len(const struct sk_buff *skb, unsigned int mtu);
-bool skb_gso_validate_mac_len(const struct sk_buff *skb, unsigned int len);
 struct sk_buff *skb_segment(struct sk_buff *skb, netdev_features_t features);
 struct sk_buff *skb_segment_list(struct sk_buff *skb, netdev_features_t features,
 				 unsigned int offset);
@@ -4841,75 +4839,6 @@ static inline struct sec_path *skb_sec_path(const struct sk_buff *skb)
 #endif
 }
 
-/* Keeps track of mac header offset relative to skb->head.
- * It is useful for TSO of Tunneling protocol. e.g. GRE.
- * For non-tunnel skb it points to skb_mac_header() and for
- * tunnel skb it points to outer mac header.
- * Keeps track of level of encapsulation of network headers.
- */
-struct skb_gso_cb {
-	union {
-		int	mac_offset;
-		int	data_offset;
-	};
-	int	encap_level;
-	__wsum	csum;
-	__u16	csum_start;
-};
-#define SKB_GSO_CB_OFFSET	32
-#define SKB_GSO_CB(skb) ((struct skb_gso_cb *)((skb)->cb + SKB_GSO_CB_OFFSET))
-
-static inline int skb_tnl_header_len(const struct sk_buff *inner_skb)
-{
-	return (skb_mac_header(inner_skb) - inner_skb->head) -
-		SKB_GSO_CB(inner_skb)->mac_offset;
-}
-
-static inline int gso_pskb_expand_head(struct sk_buff *skb, int extra)
-{
-	int new_headroom, headroom;
-	int ret;
-
-	headroom = skb_headroom(skb);
-	ret = pskb_expand_head(skb, extra, 0, GFP_ATOMIC);
-	if (ret)
-		return ret;
-
-	new_headroom = skb_headroom(skb);
-	SKB_GSO_CB(skb)->mac_offset += (new_headroom - headroom);
-	return 0;
-}
-
-static inline void gso_reset_checksum(struct sk_buff *skb, __wsum res)
-{
-	/* Do not update partial checksums if remote checksum is enabled. */
-	if (skb->remcsum_offload)
-		return;
-
-	SKB_GSO_CB(skb)->csum = res;
-	SKB_GSO_CB(skb)->csum_start = skb_checksum_start(skb) - skb->head;
-}
-
-/* Compute the checksum for a gso segment. First compute the checksum value
- * from the start of transport header to SKB_GSO_CB(skb)->csum_start, and
- * then add in skb->csum (checksum from csum_start to end of packet).
- * skb->csum and csum_start are then updated to reflect the checksum of the
- * resultant packet starting from the transport header-- the resultant checksum
- * is in the res argument (i.e. normally zero or ~ of checksum of a pseudo
- * header.
- */
-static inline __sum16 gso_make_checksum(struct sk_buff *skb, __wsum res)
-{
-	unsigned char *csum_start = skb_transport_header(skb);
-	int plen = (skb->head + SKB_GSO_CB(skb)->csum_start) - csum_start;
-	__wsum partial = SKB_GSO_CB(skb)->csum;
-
-	SKB_GSO_CB(skb)->csum = res;
-	SKB_GSO_CB(skb)->csum_start = csum_start - skb->head;
-
-	return csum_fold(csum_partial(csum_start, plen, partial));
-}
-
 static inline bool skb_is_gso(const struct sk_buff *skb)
 {
 	return skb_shinfo(skb)->gso_size;
diff --git a/include/net/gro.h b/include/net/gro.h
index 7b47dd6ce94ff00af946d2813df09018c6dc7db2..75efa6fb84413e79728ec0844cfe1d0c3858ac62 100644
--- a/include/net/gro.h
+++ b/include/net/gro.h
@@ -452,5 +452,6 @@ static inline void gro_normal_one(struct napi_struct *napi, struct sk_buff *skb,
 		gro_normal_list(napi);
 }
 
+extern struct list_head offload_base;
 
 #endif /* _NET_IPV6_GRO_H */
diff --git a/include/net/gso.h b/include/net/gso.h
new file mode 100644
index 0000000000000000000000000000000000000000..29975440cad51e667591ddb1d5df6f866d74c2ee
--- /dev/null
+++ b/include/net/gso.h
@@ -0,0 +1,109 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#ifndef _NET_GSO_H
+#define _NET_GSO_H
+
+#include <linux/skbuff.h>
+
+/* Keeps track of mac header offset relative to skb->head.
+ * It is useful for TSO of Tunneling protocol. e.g. GRE.
+ * For non-tunnel skb it points to skb_mac_header() and for
+ * tunnel skb it points to outer mac header.
+ * Keeps track of level of encapsulation of network headers.
+ */
+struct skb_gso_cb {
+	union {
+		int	mac_offset;
+		int	data_offset;
+	};
+	int	encap_level;
+	__wsum	csum;
+	__u16	csum_start;
+};
+#define SKB_GSO_CB_OFFSET	32
+#define SKB_GSO_CB(skb) ((struct skb_gso_cb *)((skb)->cb + SKB_GSO_CB_OFFSET))
+
+static inline int skb_tnl_header_len(const struct sk_buff *inner_skb)
+{
+	return (skb_mac_header(inner_skb) - inner_skb->head) -
+		SKB_GSO_CB(inner_skb)->mac_offset;
+}
+
+static inline int gso_pskb_expand_head(struct sk_buff *skb, int extra)
+{
+	int new_headroom, headroom;
+	int ret;
+
+	headroom = skb_headroom(skb);
+	ret = pskb_expand_head(skb, extra, 0, GFP_ATOMIC);
+	if (ret)
+		return ret;
+
+	new_headroom = skb_headroom(skb);
+	SKB_GSO_CB(skb)->mac_offset += (new_headroom - headroom);
+	return 0;
+}
+
+static inline void gso_reset_checksum(struct sk_buff *skb, __wsum res)
+{
+	/* Do not update partial checksums if remote checksum is enabled. */
+	if (skb->remcsum_offload)
+		return;
+
+	SKB_GSO_CB(skb)->csum = res;
+	SKB_GSO_CB(skb)->csum_start = skb_checksum_start(skb) - skb->head;
+}
+
+/* Compute the checksum for a gso segment. First compute the checksum value
+ * from the start of transport header to SKB_GSO_CB(skb)->csum_start, and
+ * then add in skb->csum (checksum from csum_start to end of packet).
+ * skb->csum and csum_start are then updated to reflect the checksum of the
+ * resultant packet starting from the transport header-- the resultant checksum
+ * is in the res argument (i.e. normally zero or ~ of checksum of a pseudo
+ * header.
+ */
+static inline __sum16 gso_make_checksum(struct sk_buff *skb, __wsum res)
+{
+	unsigned char *csum_start = skb_transport_header(skb);
+	int plen = (skb->head + SKB_GSO_CB(skb)->csum_start) - csum_start;
+	__wsum partial = SKB_GSO_CB(skb)->csum;
+
+	SKB_GSO_CB(skb)->csum = res;
+	SKB_GSO_CB(skb)->csum_start = csum_start - skb->head;
+
+	return csum_fold(csum_partial(csum_start, plen, partial));
+}
+
+struct sk_buff *__skb_gso_segment(struct sk_buff *skb,
+				  netdev_features_t features, bool tx_path);
+
+static inline struct sk_buff *skb_gso_segment(struct sk_buff *skb,
+					      netdev_features_t features)
+{
+	return __skb_gso_segment(skb, features, true);
+}
+
+struct sk_buff *skb_eth_gso_segment(struct sk_buff *skb,
+				    netdev_features_t features, __be16 type);
+
+struct sk_buff *skb_mac_gso_segment(struct sk_buff *skb,
+				    netdev_features_t features);
+
+bool skb_gso_validate_network_len(const struct sk_buff *skb, unsigned int mtu);
+
+bool skb_gso_validate_mac_len(const struct sk_buff *skb, unsigned int len);
+
+static inline void skb_gso_error_unwind(struct sk_buff *skb, __be16 protocol,
+					int pulled_hlen, u16 mac_offset,
+					int mac_len)
+{
+	skb->protocol = protocol;
+	skb->encapsulation = 1;
+	skb_push(skb, pulled_hlen);
+	skb_reset_transport_header(skb);
+	skb->mac_header = mac_offset;
+	skb->network_header = skb->mac_header + mac_len;
+	skb->mac_len = mac_len;
+}
+
+#endif /* _NET_GSO_H */
diff --git a/include/net/udp.h b/include/net/udp.h
index 5cad44318d71c11e179cecc748b0de6a66cf6fb6..944ebfd403685ed50d9e626cef3dc916ade2593d 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -21,6 +21,7 @@
 #include <linux/list.h>
 #include <linux/bug.h>
 #include <net/inet_sock.h>
+#include <net/gso.h>
 #include <net/sock.h>
 #include <net/snmp.h>
 #include <net/ip.h>
diff --git a/net/core/Makefile b/net/core/Makefile
index 8f367813bc681a53a3338c32763264e1a00aa6b4..731db2eaa61076b64b21e0d732cec8d8f89833d4 100644
--- a/net/core/Makefile
+++ b/net/core/Makefile
@@ -13,7 +13,7 @@ obj-y		     += dev.o dev_addr_lists.o dst.o netevent.o \
 			neighbour.o rtnetlink.o utils.o link_watch.o filter.o \
 			sock_diag.o dev_ioctl.o tso.o sock_reuseport.o \
 			fib_notifier.o xdp.o flow_offload.o gro.o \
-			netdev-genl.o netdev-genl-gen.o
+			netdev-genl.o netdev-genl-gen.o gso.o
 
 obj-$(CONFIG_NETDEV_ADDR_LIST_TEST) += dev_addr_lists_test.o
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 6d6f8a7fe6b4b8c3e08a9afe0d65f6249f69bef4..c2456b3667fe5fe89b78e8723ade6cf0b68f43e1 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3209,7 +3209,7 @@ static u16 skb_tx_hash(const struct net_device *dev,
 	return (u16) reciprocal_scale(skb_get_hash(skb), qcount) + qoffset;
 }
 
-static void skb_warn_bad_offload(const struct sk_buff *skb)
+void skb_warn_bad_offload(const struct sk_buff *skb)
 {
 	static const netdev_features_t null_features;
 	struct net_device *dev = skb->dev;
@@ -3338,74 +3338,6 @@ __be16 skb_network_protocol(struct sk_buff *skb, int *depth)
 	return vlan_get_protocol_and_depth(skb, type, depth);
 }
 
-/* openvswitch calls this on rx path, so we need a different check.
- */
-static inline bool skb_needs_check(struct sk_buff *skb, bool tx_path)
-{
-	if (tx_path)
-		return skb->ip_summed != CHECKSUM_PARTIAL &&
-		       skb->ip_summed != CHECKSUM_UNNECESSARY;
-
-	return skb->ip_summed == CHECKSUM_NONE;
-}
-
-/**
- *	__skb_gso_segment - Perform segmentation on skb.
- *	@skb: buffer to segment
- *	@features: features for the output path (see dev->features)
- *	@tx_path: whether it is called in TX path
- *
- *	This function segments the given skb and returns a list of segments.
- *
- *	It may return NULL if the skb requires no segmentation.  This is
- *	only possible when GSO is used for verifying header integrity.
- *
- *	Segmentation preserves SKB_GSO_CB_OFFSET bytes of previous skb cb.
- */
-struct sk_buff *__skb_gso_segment(struct sk_buff *skb,
-				  netdev_features_t features, bool tx_path)
-{
-	struct sk_buff *segs;
-
-	if (unlikely(skb_needs_check(skb, tx_path))) {
-		int err;
-
-		/* We're going to init ->check field in TCP or UDP header */
-		err = skb_cow_head(skb, 0);
-		if (err < 0)
-			return ERR_PTR(err);
-	}
-
-	/* Only report GSO partial support if it will enable us to
-	 * support segmentation on this frame without needing additional
-	 * work.
-	 */
-	if (features & NETIF_F_GSO_PARTIAL) {
-		netdev_features_t partial_features = NETIF_F_GSO_ROBUST;
-		struct net_device *dev = skb->dev;
-
-		partial_features |= dev->features & dev->gso_partial_features;
-		if (!skb_gso_ok(skb, features | partial_features))
-			features &= ~NETIF_F_GSO_PARTIAL;
-	}
-
-	BUILD_BUG_ON(SKB_GSO_CB_OFFSET +
-		     sizeof(*SKB_GSO_CB(skb)) > sizeof(skb->cb));
-
-	SKB_GSO_CB(skb)->mac_offset = skb_headroom(skb);
-	SKB_GSO_CB(skb)->encap_level = 0;
-
-	skb_reset_mac_header(skb);
-	skb_reset_mac_len(skb);
-
-	segs = skb_mac_gso_segment(skb, features);
-
-	if (segs != skb && unlikely(skb_needs_check(skb, tx_path) && !IS_ERR(segs)))
-		skb_warn_bad_offload(skb);
-
-	return segs;
-}
-EXPORT_SYMBOL(__skb_gso_segment);
 
 /* Take action when hardware reception checksum errors are detected. */
 #ifdef CONFIG_BUG
diff --git a/net/core/gro.c b/net/core/gro.c
index 4d45f78e2fac9d1e997dffc34bf3384e310d0382..dca800068e41a22c9cdc83dd50e635b6f22cdc52 100644
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -10,7 +10,7 @@
 #define GRO_MAX_HEAD (MAX_HEADER + 128)
 
 static DEFINE_SPINLOCK(offload_lock);
-static struct list_head offload_base __read_mostly = LIST_HEAD_INIT(offload_base);
+struct list_head offload_base __read_mostly = LIST_HEAD_INIT(offload_base);
 /* Maximum number of GRO_NORMAL skbs to batch up for list-RX */
 int gro_normal_batch __read_mostly = 8;
 
@@ -92,63 +92,6 @@ void dev_remove_offload(struct packet_offload *po)
 }
 EXPORT_SYMBOL(dev_remove_offload);
 
-/**
- *	skb_eth_gso_segment - segmentation handler for ethernet protocols.
- *	@skb: buffer to segment
- *	@features: features for the output path (see dev->features)
- *	@type: Ethernet Protocol ID
- */
-struct sk_buff *skb_eth_gso_segment(struct sk_buff *skb,
-				    netdev_features_t features, __be16 type)
-{
-	struct sk_buff *segs = ERR_PTR(-EPROTONOSUPPORT);
-	struct packet_offload *ptype;
-
-	rcu_read_lock();
-	list_for_each_entry_rcu(ptype, &offload_base, list) {
-		if (ptype->type == type && ptype->callbacks.gso_segment) {
-			segs = ptype->callbacks.gso_segment(skb, features);
-			break;
-		}
-	}
-	rcu_read_unlock();
-
-	return segs;
-}
-EXPORT_SYMBOL(skb_eth_gso_segment);
-
-/**
- *	skb_mac_gso_segment - mac layer segmentation handler.
- *	@skb: buffer to segment
- *	@features: features for the output path (see dev->features)
- */
-struct sk_buff *skb_mac_gso_segment(struct sk_buff *skb,
-				    netdev_features_t features)
-{
-	struct sk_buff *segs = ERR_PTR(-EPROTONOSUPPORT);
-	struct packet_offload *ptype;
-	int vlan_depth = skb->mac_len;
-	__be16 type = skb_network_protocol(skb, &vlan_depth);
-
-	if (unlikely(!type))
-		return ERR_PTR(-EINVAL);
-
-	__skb_pull(skb, vlan_depth);
-
-	rcu_read_lock();
-	list_for_each_entry_rcu(ptype, &offload_base, list) {
-		if (ptype->type == type && ptype->callbacks.gso_segment) {
-			segs = ptype->callbacks.gso_segment(skb, features);
-			break;
-		}
-	}
-	rcu_read_unlock();
-
-	__skb_push(skb, skb->data - skb_mac_header(skb));
-
-	return segs;
-}
-EXPORT_SYMBOL(skb_mac_gso_segment);
 
 int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
 {
diff --git a/net/core/gso.c b/net/core/gso.c
new file mode 100644
index 0000000000000000000000000000000000000000..9e1803bfc9c6cac2fe7054661f8995909a6c28d9
--- /dev/null
+++ b/net/core/gso.c
@@ -0,0 +1,273 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+#include <linux/skbuff.h>
+#include <linux/sctp.h>
+#include <net/gso.h>
+#include <net/gro.h>
+
+/**
+ *	skb_eth_gso_segment - segmentation handler for ethernet protocols.
+ *	@skb: buffer to segment
+ *	@features: features for the output path (see dev->features)
+ *	@type: Ethernet Protocol ID
+ */
+struct sk_buff *skb_eth_gso_segment(struct sk_buff *skb,
+				    netdev_features_t features, __be16 type)
+{
+	struct sk_buff *segs = ERR_PTR(-EPROTONOSUPPORT);
+	struct packet_offload *ptype;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(ptype, &offload_base, list) {
+		if (ptype->type == type && ptype->callbacks.gso_segment) {
+			segs = ptype->callbacks.gso_segment(skb, features);
+			break;
+		}
+	}
+	rcu_read_unlock();
+
+	return segs;
+}
+EXPORT_SYMBOL(skb_eth_gso_segment);
+
+/**
+ *	skb_mac_gso_segment - mac layer segmentation handler.
+ *	@skb: buffer to segment
+ *	@features: features for the output path (see dev->features)
+ */
+struct sk_buff *skb_mac_gso_segment(struct sk_buff *skb,
+				    netdev_features_t features)
+{
+	struct sk_buff *segs = ERR_PTR(-EPROTONOSUPPORT);
+	struct packet_offload *ptype;
+	int vlan_depth = skb->mac_len;
+	__be16 type = skb_network_protocol(skb, &vlan_depth);
+
+	if (unlikely(!type))
+		return ERR_PTR(-EINVAL);
+
+	__skb_pull(skb, vlan_depth);
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(ptype, &offload_base, list) {
+		if (ptype->type == type && ptype->callbacks.gso_segment) {
+			segs = ptype->callbacks.gso_segment(skb, features);
+			break;
+		}
+	}
+	rcu_read_unlock();
+
+	__skb_push(skb, skb->data - skb_mac_header(skb));
+
+	return segs;
+}
+EXPORT_SYMBOL(skb_mac_gso_segment);
+/* openvswitch calls this on rx path, so we need a different check.
+ */
+static bool skb_needs_check(const struct sk_buff *skb, bool tx_path)
+{
+	if (tx_path)
+		return skb->ip_summed != CHECKSUM_PARTIAL &&
+		       skb->ip_summed != CHECKSUM_UNNECESSARY;
+
+	return skb->ip_summed == CHECKSUM_NONE;
+}
+
+/**
+ *	__skb_gso_segment - Perform segmentation on skb.
+ *	@skb: buffer to segment
+ *	@features: features for the output path (see dev->features)
+ *	@tx_path: whether it is called in TX path
+ *
+ *	This function segments the given skb and returns a list of segments.
+ *
+ *	It may return NULL if the skb requires no segmentation.  This is
+ *	only possible when GSO is used for verifying header integrity.
+ *
+ *	Segmentation preserves SKB_GSO_CB_OFFSET bytes of previous skb cb.
+ */
+struct sk_buff *__skb_gso_segment(struct sk_buff *skb,
+				  netdev_features_t features, bool tx_path)
+{
+	struct sk_buff *segs;
+
+	if (unlikely(skb_needs_check(skb, tx_path))) {
+		int err;
+
+		/* We're going to init ->check field in TCP or UDP header */
+		err = skb_cow_head(skb, 0);
+		if (err < 0)
+			return ERR_PTR(err);
+	}
+
+	/* Only report GSO partial support if it will enable us to
+	 * support segmentation on this frame without needing additional
+	 * work.
+	 */
+	if (features & NETIF_F_GSO_PARTIAL) {
+		netdev_features_t partial_features = NETIF_F_GSO_ROBUST;
+		struct net_device *dev = skb->dev;
+
+		partial_features |= dev->features & dev->gso_partial_features;
+		if (!skb_gso_ok(skb, features | partial_features))
+			features &= ~NETIF_F_GSO_PARTIAL;
+	}
+
+	BUILD_BUG_ON(SKB_GSO_CB_OFFSET +
+		     sizeof(*SKB_GSO_CB(skb)) > sizeof(skb->cb));
+
+	SKB_GSO_CB(skb)->mac_offset = skb_headroom(skb);
+	SKB_GSO_CB(skb)->encap_level = 0;
+
+	skb_reset_mac_header(skb);
+	skb_reset_mac_len(skb);
+
+	segs = skb_mac_gso_segment(skb, features);
+
+	if (segs != skb && unlikely(skb_needs_check(skb, tx_path) && !IS_ERR(segs)))
+		skb_warn_bad_offload(skb);
+
+	return segs;
+}
+EXPORT_SYMBOL(__skb_gso_segment);
+
+/**
+ * skb_gso_transport_seglen - Return length of individual segments of a gso packet
+ *
+ * @skb: GSO skb
+ *
+ * skb_gso_transport_seglen is used to determine the real size of the
+ * individual segments, including Layer4 headers (TCP/UDP).
+ *
+ * The MAC/L2 or network (IP, IPv6) headers are not accounted for.
+ */
+static unsigned int skb_gso_transport_seglen(const struct sk_buff *skb)
+{
+	const struct skb_shared_info *shinfo = skb_shinfo(skb);
+	unsigned int thlen = 0;
+
+	if (skb->encapsulation) {
+		thlen = skb_inner_transport_header(skb) -
+			skb_transport_header(skb);
+
+		if (likely(shinfo->gso_type & (SKB_GSO_TCPV4 | SKB_GSO_TCPV6)))
+			thlen += inner_tcp_hdrlen(skb);
+	} else if (likely(shinfo->gso_type & (SKB_GSO_TCPV4 | SKB_GSO_TCPV6))) {
+		thlen = tcp_hdrlen(skb);
+	} else if (unlikely(skb_is_gso_sctp(skb))) {
+		thlen = sizeof(struct sctphdr);
+	} else if (shinfo->gso_type & SKB_GSO_UDP_L4) {
+		thlen = sizeof(struct udphdr);
+	}
+	/* UFO sets gso_size to the size of the fragmentation
+	 * payload, i.e. the size of the L4 (UDP) header is already
+	 * accounted for.
+	 */
+	return thlen + shinfo->gso_size;
+}
+
+/**
+ * skb_gso_network_seglen - Return length of individual segments of a gso packet
+ *
+ * @skb: GSO skb
+ *
+ * skb_gso_network_seglen is used to determine the real size of the
+ * individual segments, including Layer3 (IP, IPv6) and L4 headers (TCP/UDP).
+ *
+ * The MAC/L2 header is not accounted for.
+ */
+static unsigned int skb_gso_network_seglen(const struct sk_buff *skb)
+{
+	unsigned int hdr_len = skb_transport_header(skb) -
+			       skb_network_header(skb);
+
+	return hdr_len + skb_gso_transport_seglen(skb);
+}
+
+/**
+ * skb_gso_mac_seglen - Return length of individual segments of a gso packet
+ *
+ * @skb: GSO skb
+ *
+ * skb_gso_mac_seglen is used to determine the real size of the
+ * individual segments, including MAC/L2, Layer3 (IP, IPv6) and L4
+ * headers (TCP/UDP).
+ */
+static unsigned int skb_gso_mac_seglen(const struct sk_buff *skb)
+{
+	unsigned int hdr_len = skb_transport_header(skb) - skb_mac_header(skb);
+
+	return hdr_len + skb_gso_transport_seglen(skb);
+}
+
+/**
+ * skb_gso_size_check - check the skb size, considering GSO_BY_FRAGS
+ *
+ * There are a couple of instances where we have a GSO skb, and we
+ * want to determine what size it would be after it is segmented.
+ *
+ * We might want to check:
+ * -    L3+L4+payload size (e.g. IP forwarding)
+ * - L2+L3+L4+payload size (e.g. sanity check before passing to driver)
+ *
+ * This is a helper to do that correctly considering GSO_BY_FRAGS.
+ *
+ * @skb: GSO skb
+ *
+ * @seg_len: The segmented length (from skb_gso_*_seglen). In the
+ *           GSO_BY_FRAGS case this will be [header sizes + GSO_BY_FRAGS].
+ *
+ * @max_len: The maximum permissible length.
+ *
+ * Returns true if the segmented length <= max length.
+ */
+static inline bool skb_gso_size_check(const struct sk_buff *skb,
+				      unsigned int seg_len,
+				      unsigned int max_len) {
+	const struct skb_shared_info *shinfo = skb_shinfo(skb);
+	const struct sk_buff *iter;
+
+	if (shinfo->gso_size != GSO_BY_FRAGS)
+		return seg_len <= max_len;
+
+	/* Undo this so we can re-use header sizes */
+	seg_len -= GSO_BY_FRAGS;
+
+	skb_walk_frags(skb, iter) {
+		if (seg_len + skb_headlen(iter) > max_len)
+			return false;
+	}
+
+	return true;
+}
+
+/**
+ * skb_gso_validate_network_len - Will a split GSO skb fit into a given MTU?
+ *
+ * @skb: GSO skb
+ * @mtu: MTU to validate against
+ *
+ * skb_gso_validate_network_len validates if a given skb will fit a
+ * wanted MTU once split. It considers L3 headers, L4 headers, and the
+ * payload.
+ */
+bool skb_gso_validate_network_len(const struct sk_buff *skb, unsigned int mtu)
+{
+	return skb_gso_size_check(skb, skb_gso_network_seglen(skb), mtu);
+}
+EXPORT_SYMBOL_GPL(skb_gso_validate_network_len);
+
+/**
+ * skb_gso_validate_mac_len - Will a split GSO skb fit in a given length?
+ *
+ * @skb: GSO skb
+ * @len: length to validate against
+ *
+ * skb_gso_validate_mac_len validates if a given skb will fit a wanted
+ * length once split, including L2, L3 and L4 headers and the payload.
+ */
+bool skb_gso_validate_mac_len(const struct sk_buff *skb, unsigned int len)
+{
+	return skb_gso_size_check(skb, skb_gso_mac_seglen(skb), len);
+}
+EXPORT_SYMBOL_GPL(skb_gso_validate_mac_len);
+
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 7c4338221b173f83f5dbfa53a72bb9f184c00613..fee2b1c105fee451a0a8d8e9253d684465c85a8d 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -67,6 +67,7 @@
 #include <net/dst.h>
 #include <net/sock.h>
 #include <net/checksum.h>
+#include <net/gso.h>
 #include <net/ip6_checksum.h>
 #include <net/xfrm.h>
 #include <net/mpls.h>
@@ -5766,147 +5767,6 @@ void skb_scrub_packet(struct sk_buff *skb, bool xnet)
 }
 EXPORT_SYMBOL_GPL(skb_scrub_packet);
 
-/**
- * skb_gso_transport_seglen - Return length of individual segments of a gso packet
- *
- * @skb: GSO skb
- *
- * skb_gso_transport_seglen is used to determine the real size of the
- * individual segments, including Layer4 headers (TCP/UDP).
- *
- * The MAC/L2 or network (IP, IPv6) headers are not accounted for.
- */
-static unsigned int skb_gso_transport_seglen(const struct sk_buff *skb)
-{
-	const struct skb_shared_info *shinfo = skb_shinfo(skb);
-	unsigned int thlen = 0;
-
-	if (skb->encapsulation) {
-		thlen = skb_inner_transport_header(skb) -
-			skb_transport_header(skb);
-
-		if (likely(shinfo->gso_type & (SKB_GSO_TCPV4 | SKB_GSO_TCPV6)))
-			thlen += inner_tcp_hdrlen(skb);
-	} else if (likely(shinfo->gso_type & (SKB_GSO_TCPV4 | SKB_GSO_TCPV6))) {
-		thlen = tcp_hdrlen(skb);
-	} else if (unlikely(skb_is_gso_sctp(skb))) {
-		thlen = sizeof(struct sctphdr);
-	} else if (shinfo->gso_type & SKB_GSO_UDP_L4) {
-		thlen = sizeof(struct udphdr);
-	}
-	/* UFO sets gso_size to the size of the fragmentation
-	 * payload, i.e. the size of the L4 (UDP) header is already
-	 * accounted for.
-	 */
-	return thlen + shinfo->gso_size;
-}
-
-/**
- * skb_gso_network_seglen - Return length of individual segments of a gso packet
- *
- * @skb: GSO skb
- *
- * skb_gso_network_seglen is used to determine the real size of the
- * individual segments, including Layer3 (IP, IPv6) and L4 headers (TCP/UDP).
- *
- * The MAC/L2 header is not accounted for.
- */
-static unsigned int skb_gso_network_seglen(const struct sk_buff *skb)
-{
-	unsigned int hdr_len = skb_transport_header(skb) -
-			       skb_network_header(skb);
-
-	return hdr_len + skb_gso_transport_seglen(skb);
-}
-
-/**
- * skb_gso_mac_seglen - Return length of individual segments of a gso packet
- *
- * @skb: GSO skb
- *
- * skb_gso_mac_seglen is used to determine the real size of the
- * individual segments, including MAC/L2, Layer3 (IP, IPv6) and L4
- * headers (TCP/UDP).
- */
-static unsigned int skb_gso_mac_seglen(const struct sk_buff *skb)
-{
-	unsigned int hdr_len = skb_transport_header(skb) - skb_mac_header(skb);
-
-	return hdr_len + skb_gso_transport_seglen(skb);
-}
-
-/**
- * skb_gso_size_check - check the skb size, considering GSO_BY_FRAGS
- *
- * There are a couple of instances where we have a GSO skb, and we
- * want to determine what size it would be after it is segmented.
- *
- * We might want to check:
- * -    L3+L4+payload size (e.g. IP forwarding)
- * - L2+L3+L4+payload size (e.g. sanity check before passing to driver)
- *
- * This is a helper to do that correctly considering GSO_BY_FRAGS.
- *
- * @skb: GSO skb
- *
- * @seg_len: The segmented length (from skb_gso_*_seglen). In the
- *           GSO_BY_FRAGS case this will be [header sizes + GSO_BY_FRAGS].
- *
- * @max_len: The maximum permissible length.
- *
- * Returns true if the segmented length <= max length.
- */
-static inline bool skb_gso_size_check(const struct sk_buff *skb,
-				      unsigned int seg_len,
-				      unsigned int max_len) {
-	const struct skb_shared_info *shinfo = skb_shinfo(skb);
-	const struct sk_buff *iter;
-
-	if (shinfo->gso_size != GSO_BY_FRAGS)
-		return seg_len <= max_len;
-
-	/* Undo this so we can re-use header sizes */
-	seg_len -= GSO_BY_FRAGS;
-
-	skb_walk_frags(skb, iter) {
-		if (seg_len + skb_headlen(iter) > max_len)
-			return false;
-	}
-
-	return true;
-}
-
-/**
- * skb_gso_validate_network_len - Will a split GSO skb fit into a given MTU?
- *
- * @skb: GSO skb
- * @mtu: MTU to validate against
- *
- * skb_gso_validate_network_len validates if a given skb will fit a
- * wanted MTU once split. It considers L3 headers, L4 headers, and the
- * payload.
- */
-bool skb_gso_validate_network_len(const struct sk_buff *skb, unsigned int mtu)
-{
-	return skb_gso_size_check(skb, skb_gso_network_seglen(skb), mtu);
-}
-EXPORT_SYMBOL_GPL(skb_gso_validate_network_len);
-
-/**
- * skb_gso_validate_mac_len - Will a split GSO skb fit in a given length?
- *
- * @skb: GSO skb
- * @len: length to validate against
- *
- * skb_gso_validate_mac_len validates if a given skb will fit a wanted
- * length once split, including L2, L3 and L4 headers and the payload.
- */
-bool skb_gso_validate_mac_len(const struct sk_buff *skb, unsigned int len)
-{
-	return skb_gso_size_check(skb, skb_gso_mac_seglen(skb), len);
-}
-EXPORT_SYMBOL_GPL(skb_gso_validate_mac_len);
-
 static struct sk_buff *skb_reorder_vlan_header(struct sk_buff *skb)
 {
 	int mac_len, meta_len;
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index b5735b3551cfcd7cc7adbd3b3379931ce688d7ee..11c2f6c0bc04fb040360f1e89587f5fcc5a32188 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -100,6 +100,7 @@
 #include <net/ip_fib.h>
 #include <net/inet_connection_sock.h>
 #include <net/gro.h>
+#include <net/gso.h>
 #include <net/tcp.h>
 #include <net/udp.h>
 #include <net/udplite.h>
diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index 3969fa805679cd25f373526f5a7d0b7be7172040..12c5fb3c6e1e80979e0d23170e229030ba53d2a4 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -17,6 +17,7 @@
 #include <linux/err.h>
 #include <linux/module.h>
 #include <net/gro.h>
+#include <net/gso.h>
 #include <net/ip.h>
 #include <net/xfrm.h>
 #include <net/esp.h>
diff --git a/net/ipv4/gre_offload.c b/net/ipv4/gre_offload.c
index 2b9cb5398335bc1a0c7b48b638360016141e1ba5..311e70bfce407a2cadaa33fbef9a3976375711f4 100644
--- a/net/ipv4/gre_offload.c
+++ b/net/ipv4/gre_offload.c
@@ -11,6 +11,7 @@
 #include <net/protocol.h>
 #include <net/gre.h>
 #include <net/gro.h>
+#include <net/gso.h>
 
 static struct sk_buff *gre_gso_segment(struct sk_buff *skb,
 				       netdev_features_t features)
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 244fb9365d87d502c67d165471da73017960ab14..457598dfa12897cdaa50b25c059548fb1aee3bd8 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -73,6 +73,7 @@
 #include <net/arp.h>
 #include <net/icmp.h>
 #include <net/checksum.h>
+#include <net/gso.h>
 #include <net/inetpeer.h>
 #include <net/inet_ecn.h>
 #include <net/lwtunnel.h>
diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
index 05b38f58b404d775a5fed3c6b5f42010786942d2..8311c38267b55ba97e59924c3c1c5b59f133fdcd 100644
--- a/net/ipv4/tcp_offload.c
+++ b/net/ipv4/tcp_offload.c
@@ -9,6 +9,7 @@
 #include <linux/indirect_call_wrapper.h>
 #include <linux/skbuff.h>
 #include <net/gro.h>
+#include <net/gso.h>
 #include <net/tcp.h>
 #include <net/protocol.h>
 
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index fd3dae081f3a6ca22d9ba574d83f9a1ba1563698..80112110f77ea342b90327f75c89745373528260 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -103,6 +103,7 @@
 #include <net/ip_tunnels.h>
 #include <net/route.h>
 #include <net/checksum.h>
+#include <net/gso.h>
 #include <net/xfrm.h>
 #include <trace/events/udp.h>
 #include <linux/static_key.h>
diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index 1f01e15ca24fd9760382299f9327344aeaa1a8ab..75aa4de5b73113108bfcf7f34a61c507ac6054cc 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -8,6 +8,7 @@
 
 #include <linux/skbuff.h>
 #include <net/gro.h>
+#include <net/gso.h>
 #include <net/udp.h>
 #include <net/protocol.h>
 #include <net/inet_common.h>
diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index 75c02992c520f94e1f53de89ea6463acc842c331..b33c7de5bdbcff290b04b90fbd8e61dc1a4837b9 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -17,6 +17,7 @@
 #include <linux/err.h>
 #include <linux/module.h>
 #include <net/gro.h>
+#include <net/gso.h>
 #include <net/ip.h>
 #include <net/xfrm.h>
 #include <net/esp.h>
diff --git a/net/ipv6/ip6_offload.c b/net/ipv6/ip6_offload.c
index 00dc2e3b018451f40cccbff16b25c8f29ba1b110..d6314287338da1d7c80459899fca620833cd6dc9 100644
--- a/net/ipv6/ip6_offload.c
+++ b/net/ipv6/ip6_offload.c
@@ -16,6 +16,7 @@
 #include <net/tcp.h>
 #include <net/udp.h>
 #include <net/gro.h>
+#include <net/gso.h>
 
 #include "ip6_offload.h"
 
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index c722cb881b2dd9f52cd585a7e00134701e5794d5..c06ff7519f198055d90df10f6a20fa05acbe9fbb 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -42,6 +42,7 @@
 #include <net/sock.h>
 #include <net/snmp.h>
 
+#include <net/gso.h>
 #include <net/ipv6.h>
 #include <net/ndisc.h>
 #include <net/protocol.h>
diff --git a/net/ipv6/udp_offload.c b/net/ipv6/udp_offload.c
index c39c1e32f9804fcb364ac0fca03e7753b1836a2c..ad3b8726873e1e55d4c944f7c94103a84d156bec 100644
--- a/net/ipv6/udp_offload.c
+++ b/net/ipv6/udp_offload.c
@@ -14,6 +14,7 @@
 #include <net/ip6_checksum.h>
 #include "ip6_offload.h"
 #include <net/gro.h>
+#include <net/gso.h>
 
 static struct sk_buff *udp6_ufo_fragment(struct sk_buff *skb,
 					 netdev_features_t features)
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 7f1c7f67014bb496e27c50b42b7c3ce6d9c417ee..a8fef922b8316b225ed5354912f7cad25dd75ea1 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -26,6 +26,7 @@
 #include <net/codel_impl.h>
 #include <asm/unaligned.h>
 #include <net/fq_impl.h>
+#include <net/gso.h>
 
 #include "ieee80211_i.h"
 #include "driver-ops.h"
diff --git a/net/mpls/af_mpls.c b/net/mpls/af_mpls.c
index dc5165d3eec4e7c11e1a01a08c6fbea6b3ba59e3..bf6e81d562631cfe4919ab86bb43016b4a952734 100644
--- a/net/mpls/af_mpls.c
+++ b/net/mpls/af_mpls.c
@@ -12,6 +12,7 @@
 #include <linux/nospec.h>
 #include <linux/vmalloc.h>
 #include <linux/percpu.h>
+#include <net/gso.h>
 #include <net/ip.h>
 #include <net/dst.h>
 #include <net/sock.h>
diff --git a/net/mpls/mpls_gso.c b/net/mpls/mpls_gso.c
index 1482259de9b5d7a5e791f0deb34cedcb1f26bf21..533d082f0701e5dd0234db7cef4282710051af9f 100644
--- a/net/mpls/mpls_gso.c
+++ b/net/mpls/mpls_gso.c
@@ -14,6 +14,7 @@
 #include <linux/netdev_features.h>
 #include <linux/netdevice.h>
 #include <linux/skbuff.h>
+#include <net/gso.h>
 #include <net/mpls.h>
 
 static struct sk_buff *mpls_gso_segment(struct sk_buff *skb,
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index d248763917ad0444a6905b5de0bfb9c32b078458..d885d34edfe16e39d0c79b704a2a3e2f38904c8d 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -8,6 +8,7 @@
 #include <linux/ipv6.h>
 #include <linux/netdevice.h>
 #include <linux/if_ether.h>
+#include <net/gso.h>
 #include <net/ip.h>
 #include <net/ipv6.h>
 #include <net/ip6_route.h>
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index e311462f6d98d8028749dd512eb71b3b822d0118..556bc902af00f80aab5867b5ff9b2be5a502cd18 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -30,6 +30,7 @@
 #include <linux/netfilter/nf_conntrack_common.h>
 #include <linux/list.h>
 #include <linux/cgroup-defs.h>
+#include <net/gso.h>
 #include <net/sock.h>
 #include <net/tcp_states.h>
 #include <net/netfilter/nf_queue.h>
diff --git a/net/nsh/nsh.c b/net/nsh/nsh.c
index 0f23e5e8e03ebaaaefbc567153e3da531aecb3ca..f4a38bd6a7e04f5944f8fa3d7f3cdc43caffed41 100644
--- a/net/nsh/nsh.c
+++ b/net/nsh/nsh.c
@@ -8,6 +8,7 @@
 #include <linux/module.h>
 #include <linux/netdevice.h>
 #include <linux/skbuff.h>
+#include <net/gso.h>
 #include <net/nsh.h>
 #include <net/tun_proto.h>
 
diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index a8cf9a88758ef555743e3873648a1ea14b07c0a2..8074ea00d577ef905c0974521b17f1641ecb870b 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -17,6 +17,7 @@
 #include <linux/if_vlan.h>
 
 #include <net/dst.h>
+#include <net/gso.h>
 #include <net/ip.h>
 #include <net/ipv6.h>
 #include <net/ip6_fib.h>
diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 58f530f60172a6969d0bb81d774a84ad3b5b10aa..a6d2a0b1aa21eaae6041ec9a9321af2d615a5c38 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -35,6 +35,7 @@
 #include <linux/rculist.h>
 #include <linux/dmi.h>
 #include <net/genetlink.h>
+#include <net/gso.h>
 #include <net/net_namespace.h>
 #include <net/netns/generic.h>
 #include <net/pkt_cls.h>
diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index 2e9dce03d1eccf4666b40fd6d8c04ff40f2d0780..f3121c5a85e9f76bef80c34c02d224d826ecdb7b 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -16,6 +16,7 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <net/act_api.h>
+#include <net/gso.h>
 #include <net/netlink.h>
 #include <net/pkt_cls.h>
 #include <net/tc_act/tc_police.h>
diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index 891e007d5c0bf972a686b892c13d647e46b3274b..9cff99558694dc47c4d5f3aeff0bb465461558a3 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -65,6 +65,7 @@
 #include <linux/reciprocal_div.h>
 #include <net/netlink.h>
 #include <linux/if_vlan.h>
+#include <net/gso.h>
 #include <net/pkt_sched.h>
 #include <net/pkt_cls.h>
 #include <net/tcp.h>
diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index 6ef3021e1169a376494d610ac8c3f1c04fb911c5..0c9e93d66c506d1790cda96126b056b9bb4cb852 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -21,6 +21,7 @@
 #include <linux/reciprocal_div.h>
 #include <linux/rbtree.h>
 
+#include <net/gso.h>
 #include <net/netlink.h>
 #include <net/pkt_sched.h>
 #include <net/inet_ecn.h>
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 5076da103f633e4a383e23302be0e8028dfca5d5..4a4e6ff894c14a63d539d3a6c7f8574df541f3e7 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -20,6 +20,7 @@
 #include <linux/spinlock.h>
 #include <linux/rcupdate.h>
 #include <linux/time.h>
+#include <net/gso.h>
 #include <net/netlink.h>
 #include <net/pkt_sched.h>
 #include <net/pkt_cls.h>
diff --git a/net/sched/sch_tbf.c b/net/sched/sch_tbf.c
index 277ad11f4d6135373e0a196ed423e0beddec1470..17d2d00ddb182d1318a45cd30ed9e80e8eafb85c 100644
--- a/net/sched/sch_tbf.c
+++ b/net/sched/sch_tbf.c
@@ -13,6 +13,7 @@
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <linux/skbuff.h>
+#include <net/gso.h>
 #include <net/netlink.h>
 #include <net/sch_generic.h>
 #include <net/pkt_cls.h>
diff --git a/net/sctp/offload.c b/net/sctp/offload.c
index eb874e3c399a5b9934577e60fbbf2e2833a7969c..502095173d885636525f6dc100ef8060dc1ca9d1 100644
--- a/net/sctp/offload.c
+++ b/net/sctp/offload.c
@@ -22,6 +22,7 @@
 #include <net/sctp/sctp.h>
 #include <net/sctp/checksum.h>
 #include <net/protocol.h>
+#include <net/gso.h>
 
 static __le32 sctp_gso_make_checksum(struct sk_buff *skb)
 {
diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index 408f5e55744edd1c865fe679da6bc43e4413f2db..533697e2488f23c5433029335244fc302ff12b9f 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -15,6 +15,7 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <net/dst.h>
+#include <net/gso.h>
 #include <net/xfrm.h>
 #include <linux/notifier.h>
 
diff --git a/net/xfrm/xfrm_interface_core.c b/net/xfrm/xfrm_interface_core.c
index 1f99dc46902719e6716b0cb93f95d1087d2c8bd8..0ee864a7657978e4d9ca063aaa1321afbd219541 100644
--- a/net/xfrm/xfrm_interface_core.c
+++ b/net/xfrm/xfrm_interface_core.c
@@ -33,6 +33,7 @@
 #include <linux/uaccess.h>
 #include <linux/atomic.h>
 
+#include <net/gso.h>
 #include <net/icmp.h>
 #include <net/ip.h>
 #include <net/ipv6.h>
diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index 369e5de8558ffd2ad8a4dc2eb945ad8c15f72ab8..662c83beb345ed2037d146c976180b1b62c26794 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -13,6 +13,7 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <net/dst.h>
+#include <net/gso.h>
 #include <net/icmp.h>
 #include <net/inet_ecn.h>
 #include <net/xfrm.h>
-- 
2.41.0.162.gfafddb0af9-goog


