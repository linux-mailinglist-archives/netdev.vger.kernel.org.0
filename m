Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC5159D58
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 15:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbfF1N4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 09:56:11 -0400
Received: from packetmixer.de ([79.140.42.25]:52988 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726657AbfF1N4J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 09:56:09 -0400
Received: from kero.packetmixer.de (p4FD57BD9.dip0.t-ipconnect.de [79.213.123.217])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mail.packetmixer.de (Postfix) with ESMTPSA id 052A562071;
        Fri, 28 Jun 2019 15:56:07 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 04/10] batman-adv: Use includes instead of fwdecls
Date:   Fri, 28 Jun 2019 15:55:58 +0200
Message-Id: <20190628135604.11581-5-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190628135604.11581-1-sw@simonwunderlich.de>
References: <20190628135604.11581-1-sw@simonwunderlich.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

While it can be slightly beneficial for the build performance to use
forward declarations instead of includes, the handling of them together
with changes in the included headers makes it unnecessary complicated and
fragile. Just replace them with actual includes since some parts (hwmon,
..) of the kernel even request avoidance of forward declarations and net/
is mostly not using them in *.c file.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/bat_algo.h              | 7 +++----
 net/batman-adv/bat_v.c                 | 3 +--
 net/batman-adv/bat_v_elp.h             | 4 ++--
 net/batman-adv/bat_v_ogm.h             | 3 +--
 net/batman-adv/bridge_loop_avoidance.h | 9 ++++-----
 net/batman-adv/debugfs.h               | 4 ++--
 net/batman-adv/distributed-arp-table.h | 7 +++----
 net/batman-adv/fragmentation.h         | 3 +--
 net/batman-adv/gateway_client.h        | 9 ++++-----
 net/batman-adv/gateway_common.h        | 3 +--
 net/batman-adv/hard-interface.h        | 5 ++---
 net/batman-adv/hash.h                  | 3 +--
 net/batman-adv/icmp_socket.h           | 3 +--
 net/batman-adv/main.h                  | 9 ++++-----
 net/batman-adv/multicast.h             | 6 +++---
 net/batman-adv/netlink.c               | 3 +--
 net/batman-adv/netlink.h               | 3 +--
 net/batman-adv/network-coding.h        | 9 ++++-----
 net/batman-adv/originator.h            | 7 +++----
 net/batman-adv/routing.h               | 3 +--
 net/batman-adv/send.h                  | 3 +--
 net/batman-adv/soft-interface.c        | 1 +
 net/batman-adv/soft-interface.h        | 7 +++----
 net/batman-adv/sysfs.h                 | 5 ++---
 net/batman-adv/tp_meter.h              | 3 +--
 net/batman-adv/translation-table.h     | 9 ++++-----
 net/batman-adv/tvlv.h                  | 3 +--
 net/batman-adv/types.h                 | 6 ++++--
 28 files changed, 60 insertions(+), 80 deletions(-)

diff --git a/net/batman-adv/bat_algo.h b/net/batman-adv/bat_algo.h
index cb7d57d16c9d..37898da8ad48 100644
--- a/net/batman-adv/bat_algo.h
+++ b/net/batman-adv/bat_algo.h
@@ -9,12 +9,11 @@
 
 #include "main.h"
 
+#include <linux/netlink.h>
+#include <linux/seq_file.h>
+#include <linux/skbuff.h>
 #include <linux/types.h>
 
-struct netlink_callback;
-struct seq_file;
-struct sk_buff;
-
 extern char batadv_routing_algo[];
 extern struct list_head batadv_hardif_list;
 
diff --git a/net/batman-adv/bat_v.c b/net/batman-adv/bat_v.c
index 231b4aab4d8d..22672cb3e25d 100644
--- a/net/batman-adv/bat_v.c
+++ b/net/batman-adv/bat_v.c
@@ -21,6 +21,7 @@
 #include <linux/rculist.h>
 #include <linux/rcupdate.h>
 #include <linux/seq_file.h>
+#include <linux/skbuff.h>
 #include <linux/spinlock.h>
 #include <linux/stddef.h>
 #include <linux/types.h>
@@ -41,8 +42,6 @@
 #include "netlink.h"
 #include "originator.h"
 
-struct sk_buff;
-
 static void batadv_v_iface_activate(struct batadv_hard_iface *hard_iface)
 {
 	struct batadv_priv *bat_priv = netdev_priv(hard_iface->soft_iface);
diff --git a/net/batman-adv/bat_v_elp.h b/net/batman-adv/bat_v_elp.h
index bb3d40f73bfe..1a29505f4f66 100644
--- a/net/batman-adv/bat_v_elp.h
+++ b/net/batman-adv/bat_v_elp.h
@@ -9,8 +9,8 @@
 
 #include "main.h"
 
-struct sk_buff;
-struct work_struct;
+#include <linux/skbuff.h>
+#include <linux/workqueue.h>
 
 int batadv_v_elp_iface_enable(struct batadv_hard_iface *hard_iface);
 void batadv_v_elp_iface_disable(struct batadv_hard_iface *hard_iface);
diff --git a/net/batman-adv/bat_v_ogm.h b/net/batman-adv/bat_v_ogm.h
index 616bf2ea8755..2a50df7fc2bf 100644
--- a/net/batman-adv/bat_v_ogm.h
+++ b/net/batman-adv/bat_v_ogm.h
@@ -9,10 +9,9 @@
 
 #include "main.h"
 
+#include <linux/skbuff.h>
 #include <linux/types.h>
 
-struct sk_buff;
-
 int batadv_v_ogm_init(struct batadv_priv *bat_priv);
 void batadv_v_ogm_free(struct batadv_priv *bat_priv);
 int batadv_v_ogm_iface_enable(struct batadv_hard_iface *hard_iface);
diff --git a/net/batman-adv/bridge_loop_avoidance.h b/net/batman-adv/bridge_loop_avoidance.h
index 012d72c8d064..02b24a861a85 100644
--- a/net/batman-adv/bridge_loop_avoidance.h
+++ b/net/batman-adv/bridge_loop_avoidance.h
@@ -10,14 +10,13 @@
 #include "main.h"
 
 #include <linux/compiler.h>
+#include <linux/netdevice.h>
+#include <linux/netlink.h>
+#include <linux/seq_file.h>
+#include <linux/skbuff.h>
 #include <linux/stddef.h>
 #include <linux/types.h>
 
-struct net_device;
-struct netlink_callback;
-struct seq_file;
-struct sk_buff;
-
 /**
  * batadv_bla_is_loopdetect_mac() - check if the mac address is from a loop
  *  detect frame sent by bridge loop avoidance
diff --git a/net/batman-adv/debugfs.h b/net/batman-adv/debugfs.h
index 7fac680cf740..ed3343195466 100644
--- a/net/batman-adv/debugfs.h
+++ b/net/batman-adv/debugfs.h
@@ -9,8 +9,8 @@
 
 #include "main.h"
 
-struct file;
-struct net_device;
+#include <linux/fs.h>
+#include <linux/netdevice.h>
 
 #define BATADV_DEBUGFS_SUBDIR "batman_adv"
 
diff --git a/net/batman-adv/distributed-arp-table.h b/net/batman-adv/distributed-arp-table.h
index 110c27447d70..67c7729add55 100644
--- a/net/batman-adv/distributed-arp-table.h
+++ b/net/batman-adv/distributed-arp-table.h
@@ -11,15 +11,14 @@
 
 #include <linux/compiler.h>
 #include <linux/netdevice.h>
+#include <linux/netlink.h>
+#include <linux/seq_file.h>
+#include <linux/skbuff.h>
 #include <linux/types.h>
 #include <uapi/linux/batadv_packet.h>
 
 #include "originator.h"
 
-struct netlink_callback;
-struct seq_file;
-struct sk_buff;
-
 #ifdef CONFIG_BATMAN_ADV_DAT
 
 /* BATADV_DAT_ADDR_MAX - maximum address value in the DHT space */
diff --git a/net/batman-adv/fragmentation.h b/net/batman-adv/fragmentation.h
index d6074ba2ada7..abfe8c6556de 100644
--- a/net/batman-adv/fragmentation.h
+++ b/net/batman-adv/fragmentation.h
@@ -11,11 +11,10 @@
 
 #include <linux/compiler.h>
 #include <linux/list.h>
+#include <linux/skbuff.h>
 #include <linux/stddef.h>
 #include <linux/types.h>
 
-struct sk_buff;
-
 void batadv_frag_purge_orig(struct batadv_orig_node *orig,
 			    bool (*check_cb)(struct batadv_frag_table_entry *));
 bool batadv_frag_skb_fwd(struct sk_buff *skb,
diff --git a/net/batman-adv/gateway_client.h b/net/batman-adv/gateway_client.h
index 0e14026feebd..0be8e7178ec7 100644
--- a/net/batman-adv/gateway_client.h
+++ b/net/batman-adv/gateway_client.h
@@ -9,12 +9,11 @@
 
 #include "main.h"
 
+#include <linux/netlink.h>
+#include <linux/seq_file.h>
+#include <linux/skbuff.h>
 #include <linux/types.h>
-
-struct batadv_tvlv_gateway_data;
-struct netlink_callback;
-struct seq_file;
-struct sk_buff;
+#include <uapi/linux/batadv_packet.h>
 
 void batadv_gw_check_client_stop(struct batadv_priv *bat_priv);
 void batadv_gw_reselect(struct batadv_priv *bat_priv);
diff --git a/net/batman-adv/gateway_common.h b/net/batman-adv/gateway_common.h
index 5cf50736c635..211b14b37db8 100644
--- a/net/batman-adv/gateway_common.h
+++ b/net/batman-adv/gateway_common.h
@@ -9,10 +9,9 @@
 
 #include "main.h"
 
+#include <linux/netdevice.h>
 #include <linux/types.h>
 
-struct net_device;
-
 /**
  * enum batadv_bandwidth_units - bandwidth unit types
  */
diff --git a/net/batman-adv/hard-interface.h b/net/batman-adv/hard-interface.h
index c8ef6aa0e865..bbb8a6f18d6b 100644
--- a/net/batman-adv/hard-interface.h
+++ b/net/batman-adv/hard-interface.h
@@ -11,13 +11,12 @@
 
 #include <linux/compiler.h>
 #include <linux/kref.h>
+#include <linux/netdevice.h>
 #include <linux/notifier.h>
 #include <linux/rcupdate.h>
 #include <linux/stddef.h>
 #include <linux/types.h>
-
-struct net_device;
-struct net;
+#include <net/net_namespace.h>
 
 /**
  * enum batadv_hard_if_state - State of a hard interface
diff --git a/net/batman-adv/hash.h b/net/batman-adv/hash.h
index ceef171f7f98..57877f0b78e0 100644
--- a/net/batman-adv/hash.h
+++ b/net/batman-adv/hash.h
@@ -12,13 +12,12 @@
 #include <linux/atomic.h>
 #include <linux/compiler.h>
 #include <linux/list.h>
+#include <linux/lockdep.h>
 #include <linux/rculist.h>
 #include <linux/spinlock.h>
 #include <linux/stddef.h>
 #include <linux/types.h>
 
-struct lock_class_key;
-
 /* callback to a compare function.  should compare 2 element datas for their
  * keys
  *
diff --git a/net/batman-adv/icmp_socket.h b/net/batman-adv/icmp_socket.h
index 35eecbfd2e65..1fc0b0de290e 100644
--- a/net/batman-adv/icmp_socket.h
+++ b/net/batman-adv/icmp_socket.h
@@ -10,8 +10,7 @@
 #include "main.h"
 
 #include <linux/types.h>
-
-struct batadv_icmp_header;
+#include <uapi/linux/batadv_packet.h>
 
 #define BATADV_ICMP_SOCKET "socket"
 
diff --git a/net/batman-adv/main.h b/net/batman-adv/main.h
index 821a7de45256..3d4c04d87ff3 100644
--- a/net/batman-adv/main.h
+++ b/net/batman-adv/main.h
@@ -210,16 +210,15 @@ enum batadv_uev_type {
 #include <linux/etherdevice.h>
 #include <linux/if_vlan.h>
 #include <linux/jiffies.h>
+#include <linux/netdevice.h>
 #include <linux/percpu.h>
+#include <linux/seq_file.h>
+#include <linux/skbuff.h>
 #include <linux/types.h>
 #include <uapi/linux/batadv_packet.h>
 
 #include "types.h"
-
-struct net_device;
-struct packet_type;
-struct seq_file;
-struct sk_buff;
+#include "main.h"
 
 /**
  * batadv_print_vid() - return printable version of vid information
diff --git a/net/batman-adv/multicast.h b/net/batman-adv/multicast.h
index 653b9b76fabe..5d9e2bb29c97 100644
--- a/net/batman-adv/multicast.h
+++ b/net/batman-adv/multicast.h
@@ -9,9 +9,9 @@
 
 #include "main.h"
 
-struct netlink_callback;
-struct seq_file;
-struct sk_buff;
+#include <linux/netlink.h>
+#include <linux/seq_file.h>
+#include <linux/skbuff.h>
 
 /**
  * enum batadv_forw_mode - the way a packet should be forwarded as
diff --git a/net/batman-adv/netlink.c b/net/batman-adv/netlink.c
index 7253699c3151..6f08fd122a8d 100644
--- a/net/batman-adv/netlink.c
+++ b/net/batman-adv/netlink.c
@@ -31,6 +31,7 @@
 #include <linux/stddef.h>
 #include <linux/types.h>
 #include <net/genetlink.h>
+#include <net/net_namespace.h>
 #include <net/netlink.h>
 #include <net/sock.h>
 #include <uapi/linux/batadv_packet.h>
@@ -50,8 +51,6 @@
 #include "tp_meter.h"
 #include "translation-table.h"
 
-struct net;
-
 struct genl_family batadv_netlink_family;
 
 /* multicast groups */
diff --git a/net/batman-adv/netlink.h b/net/batman-adv/netlink.h
index d1e0681b8743..ddc674e47dbb 100644
--- a/net/batman-adv/netlink.h
+++ b/net/batman-adv/netlink.h
@@ -9,11 +9,10 @@
 
 #include "main.h"
 
+#include <linux/netlink.h>
 #include <linux/types.h>
 #include <net/genetlink.h>
 
-struct nlmsghdr;
-
 void batadv_netlink_register(void);
 void batadv_netlink_unregister(void);
 int batadv_netlink_get_ifindex(const struct nlmsghdr *nlh, int attrtype);
diff --git a/net/batman-adv/network-coding.h b/net/batman-adv/network-coding.h
index 74f56113a5d0..4801d0891cc8 100644
--- a/net/batman-adv/network-coding.h
+++ b/net/batman-adv/network-coding.h
@@ -9,12 +9,11 @@
 
 #include "main.h"
 
+#include <linux/netdevice.h>
+#include <linux/seq_file.h>
+#include <linux/skbuff.h>
 #include <linux/types.h>
-
-struct batadv_ogm_packet;
-struct net_device;
-struct seq_file;
-struct sk_buff;
+#include <uapi/linux/batadv_packet.h>
 
 #ifdef CONFIG_BATMAN_ADV_NC
 
diff --git a/net/batman-adv/originator.h b/net/batman-adv/originator.h
index 3829e26f9c5d..512a1f99dd75 100644
--- a/net/batman-adv/originator.h
+++ b/net/batman-adv/originator.h
@@ -12,12 +12,11 @@
 #include <linux/compiler.h>
 #include <linux/if_ether.h>
 #include <linux/jhash.h>
+#include <linux/netlink.h>
+#include <linux/seq_file.h>
+#include <linux/skbuff.h>
 #include <linux/types.h>
 
-struct netlink_callback;
-struct seq_file;
-struct sk_buff;
-
 bool batadv_compare_orig(const struct hlist_node *node, const void *data2);
 int batadv_originator_init(struct batadv_priv *bat_priv);
 void batadv_originator_free(struct batadv_priv *bat_priv);
diff --git a/net/batman-adv/routing.h b/net/batman-adv/routing.h
index b96c6d06d188..c20feac95107 100644
--- a/net/batman-adv/routing.h
+++ b/net/batman-adv/routing.h
@@ -9,10 +9,9 @@
 
 #include "main.h"
 
+#include <linux/skbuff.h>
 #include <linux/types.h>
 
-struct sk_buff;
-
 bool batadv_check_management_packet(struct sk_buff *skb,
 				    struct batadv_hard_iface *hard_iface,
 				    int header_len);
diff --git a/net/batman-adv/send.h b/net/batman-adv/send.h
index 5921ee4e107c..5fc0fd1e5d08 100644
--- a/net/batman-adv/send.h
+++ b/net/batman-adv/send.h
@@ -10,12 +10,11 @@
 #include "main.h"
 
 #include <linux/compiler.h>
+#include <linux/skbuff.h>
 #include <linux/spinlock.h>
 #include <linux/types.h>
 #include <uapi/linux/batadv_packet.h>
 
-struct sk_buff;
-
 void batadv_forw_packet_free(struct batadv_forw_packet *forw_packet,
 			     bool dropped);
 struct batadv_forw_packet *
diff --git a/net/batman-adv/soft-interface.c b/net/batman-adv/soft-interface.c
index a7677e1d000f..499afbce44dc 100644
--- a/net/batman-adv/soft-interface.c
+++ b/net/batman-adv/soft-interface.c
@@ -24,6 +24,7 @@
 #include <linux/list.h>
 #include <linux/lockdep.h>
 #include <linux/netdevice.h>
+#include <linux/netlink.h>
 #include <linux/percpu.h>
 #include <linux/printk.h>
 #include <linux/random.h>
diff --git a/net/batman-adv/soft-interface.h b/net/batman-adv/soft-interface.h
index 275442a7acb6..29139ad769fe 100644
--- a/net/batman-adv/soft-interface.h
+++ b/net/batman-adv/soft-interface.h
@@ -9,13 +9,12 @@
 
 #include "main.h"
 
+#include <linux/netdevice.h>
+#include <linux/skbuff.h>
 #include <linux/types.h>
+#include <net/net_namespace.h>
 #include <net/rtnetlink.h>
 
-struct net_device;
-struct net;
-struct sk_buff;
-
 int batadv_skb_head_push(struct sk_buff *skb, unsigned int len);
 void batadv_interface_rx(struct net_device *soft_iface,
 			 struct sk_buff *skb, int hdr_size,
diff --git a/net/batman-adv/sysfs.h b/net/batman-adv/sysfs.h
index 83fa808b1871..5e466093dfa5 100644
--- a/net/batman-adv/sysfs.h
+++ b/net/batman-adv/sysfs.h
@@ -9,12 +9,11 @@
 
 #include "main.h"
 
+#include <linux/kobject.h>
+#include <linux/netdevice.h>
 #include <linux/sysfs.h>
 #include <linux/types.h>
 
-struct kobject;
-struct net_device;
-
 #define BATADV_SYSFS_IF_MESH_SUBDIR "mesh"
 #define BATADV_SYSFS_IF_BAT_SUBDIR "batman_adv"
 /**
diff --git a/net/batman-adv/tp_meter.h b/net/batman-adv/tp_meter.h
index 604b3799c972..78d310da0ad3 100644
--- a/net/batman-adv/tp_meter.h
+++ b/net/batman-adv/tp_meter.h
@@ -9,10 +9,9 @@
 
 #include "main.h"
 
+#include <linux/skbuff.h>
 #include <linux/types.h>
 
-struct sk_buff;
-
 void batadv_tp_meter_init(void);
 void batadv_tp_start(struct batadv_priv *bat_priv, const u8 *dst,
 		     u32 test_length, u32 *cookie);
diff --git a/net/batman-adv/translation-table.h b/net/batman-adv/translation-table.h
index c8c48d62a430..4a98860d7f0e 100644
--- a/net/batman-adv/translation-table.h
+++ b/net/batman-adv/translation-table.h
@@ -9,13 +9,12 @@
 
 #include "main.h"
 
+#include <linux/netdevice.h>
+#include <linux/netlink.h>
+#include <linux/seq_file.h>
+#include <linux/skbuff.h>
 #include <linux/types.h>
 
-struct netlink_callback;
-struct net_device;
-struct seq_file;
-struct sk_buff;
-
 int batadv_tt_init(struct batadv_priv *bat_priv);
 bool batadv_tt_local_add(struct net_device *soft_iface, const u8 *addr,
 			 unsigned short vid, int ifindex, u32 mark);
diff --git a/net/batman-adv/tvlv.h b/net/batman-adv/tvlv.h
index 114ac01e06af..36985000a0a8 100644
--- a/net/batman-adv/tvlv.h
+++ b/net/batman-adv/tvlv.h
@@ -10,8 +10,7 @@
 #include "main.h"
 
 #include <linux/types.h>
-
-struct batadv_ogm_packet;
+#include <uapi/linux/batadv_packet.h>
 
 void batadv_tvlv_container_register(struct batadv_priv *bat_priv,
 				    u8 type, u8 version,
diff --git a/net/batman-adv/types.h b/net/batman-adv/types.h
index 74b644738a36..581f93c0e974 100644
--- a/net/batman-adv/types.h
+++ b/net/batman-adv/types.h
@@ -14,20 +14,22 @@
 #include <linux/average.h>
 #include <linux/bitops.h>
 #include <linux/compiler.h>
+#include <linux/if.h>
 #include <linux/if_ether.h>
 #include <linux/kref.h>
 #include <linux/netdevice.h>
 #include <linux/netlink.h>
 #include <linux/sched.h> /* for linux/wait.h */
+#include <linux/seq_file.h>
+#include <linux/skbuff.h>
 #include <linux/spinlock.h>
+#include <linux/timer.h>
 #include <linux/types.h>
 #include <linux/wait.h>
 #include <linux/workqueue.h>
 #include <uapi/linux/batadv_packet.h>
 #include <uapi/linux/batman_adv.h>
 
-struct seq_file;
-
 #ifdef CONFIG_BATMAN_ADV_DAT
 
 /**
-- 
2.11.0

