Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDF0A28AF6A
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 09:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727222AbgJLHoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 03:44:12 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.165]:35465 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbgJLHoL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 03:44:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1602488647;
        s=strato-dkim-0002; d=hartkopp.net;
        h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=u/E1IxE9ne5OFgbKjpbP+vsMZWV3Oorl8AaDNcFdAvg=;
        b=l5JDqZALWz4Ej5+Kh94p0yEU9ts7NC1SzEg82yJfHGSyzJctP47zk7xvYbWaEpKKVC
        gLhyMlUwsI2GsvOzbAQgOhmCMRejKV7mv5XjSdVm6aCBCumYXhGKZ9hnCzZaQkW849C+
        b4F6DRlw0LZ1H9d2KcEbSsPB3gg19ZL4vi6fl/QPOMbCI97y8dFA5KpCB1nBuM+lk3aP
        hs8J6aPVktJ3zzjlHdCR7ZfNl3fadgwXDs24J+DpzeWsP4DfgF2v4yUKQ/X1wuVA9R5p
        uI7Ai4psG9fofvtyTh9LFjdBJqAKE7b7Tx7Ri1NL6XORycxlPj1IRkBImF8liBoLqLn3
        2o7Q==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjGrp7owjzFK3JbFk1mS0k+8CejuVLzM8siqF"
X-RZG-CLASS-ID: mo00
Received: from silver.lan
        by smtp.strato.de (RZmta 47.2.1 DYNA|AUTH)
        with ESMTPSA id D0b41cw9C7i2OLO
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Mon, 12 Oct 2020 09:44:02 +0200 (CEST)
From:   Oliver Hartkopp <socketcan@hartkopp.net>
To:     kuba@kernel.org, netdev@vger.kernel.org
Cc:     mkl@pengutronix.de, davem@davemloft.net, linux-can@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>
Subject: [PATCH net-next v3 2/2] can: remove obsolete version strings
Date:   Mon, 12 Oct 2020 09:43:54 +0200
Message-Id: <20201012074354.25839-2-socketcan@hartkopp.net>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012074354.25839-1-socketcan@hartkopp.net>
References: <20201012074354.25839-1-socketcan@hartkopp.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As pointed out by Jakub Kicinski here:
http://lore.kernel.org/r/20201009175751.5c54097f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com
this patch removes the obsolete version information of the different
CAN protocols and the AF_CAN core module.

Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
---
 include/linux/can/core.h |  7 -------
 include/net/netns/can.h  |  1 -
 net/can/af_can.c         |  2 +-
 net/can/bcm.c            |  4 +---
 net/can/gw.c             |  4 +---
 net/can/isotp.c          |  4 +---
 net/can/proc.c           | 12 ------------
 net/can/raw.c            |  4 +---
 8 files changed, 5 insertions(+), 33 deletions(-)

diff --git a/include/linux/can/core.h b/include/linux/can/core.h
index 7da9f1f82e8e..5fb8d0e3f9c1 100644
--- a/include/linux/can/core.h
+++ b/include/linux/can/core.h
@@ -18,13 +18,6 @@
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
 
-#define CAN_VERSION "20170425"
-
-/* increment this number each time you change some user-space interface */
-#define CAN_ABI_VERSION "9"
-
-#define CAN_VERSION_STRING "rev " CAN_VERSION " abi " CAN_ABI_VERSION
-
 #define DNAME(dev) ((dev) ? (dev)->name : "any")
 
 /**
diff --git a/include/net/netns/can.h b/include/net/netns/can.h
index b6ab7d1530d7..52fbd8291a96 100644
--- a/include/net/netns/can.h
+++ b/include/net/netns/can.h
@@ -15,7 +15,6 @@ struct can_rcv_lists_stats;
 struct netns_can {
 #if IS_ENABLED(CONFIG_PROC_FS)
 	struct proc_dir_entry *proc_dir;
-	struct proc_dir_entry *pde_version;
 	struct proc_dir_entry *pde_stats;
 	struct proc_dir_entry *pde_reset_stats;
 	struct proc_dir_entry *pde_rcvlist_all;
diff --git a/net/can/af_can.c b/net/can/af_can.c
index b7d0f6500893..6373ab9c5507 100644
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -875,7 +875,7 @@ static __init int can_init(void)
 		     offsetof(struct can_frame, data) !=
 		     offsetof(struct canfd_frame, data));
 
-	pr_info("can: controller area network core (" CAN_VERSION_STRING ")\n");
+	pr_info("can: controller area network core\n");
 
 	rcv_cache = kmem_cache_create("can_receiver", sizeof(struct receiver),
 				      0, 0, NULL);
diff --git a/net/can/bcm.c b/net/can/bcm.c
index 4253915800e6..0e5c37be4a2b 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -81,8 +81,6 @@
 		     (CAN_EFF_MASK | CAN_EFF_FLAG | CAN_RTR_FLAG) : \
 		     (CAN_SFF_MASK | CAN_EFF_FLAG | CAN_RTR_FLAG))
 
-#define CAN_BCM_VERSION "20170425"
-
 MODULE_DESCRIPTION("PF_CAN broadcast manager protocol");
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Oliver Hartkopp <oliver.hartkopp@volkswagen.de>");
@@ -1696,7 +1694,7 @@ static int __init bcm_module_init(void)
 {
 	int err;
 
-	pr_info("can: broadcast manager protocol (rev " CAN_BCM_VERSION " t)\n");
+	pr_info("can: broadcast manager protocol\n");
 
 	err = can_proto_register(&bcm_can_proto);
 	if (err < 0) {
diff --git a/net/can/gw.c b/net/can/gw.c
index 49b4e3d91ad6..6b790b6ff8d2 100644
--- a/net/can/gw.c
+++ b/net/can/gw.c
@@ -59,7 +59,6 @@
 #include <net/net_namespace.h>
 #include <net/sock.h>
 
-#define CAN_GW_VERSION "20190810"
 #define CAN_GW_NAME "can-gw"
 
 MODULE_DESCRIPTION("PF_CAN netlink gateway");
@@ -1194,8 +1193,7 @@ static __init int cgw_module_init(void)
 	/* sanitize given module parameter */
 	max_hops = clamp_t(unsigned int, max_hops, CGW_MIN_HOPS, CGW_MAX_HOPS);
 
-	pr_info("can: netlink gateway (rev " CAN_GW_VERSION ") max_hops=%d\n",
-		max_hops);
+	pr_info("can: netlink gateway - max_hops=%d\n",	max_hops);
 
 	ret = register_pernet_subsys(&cangw_pernet_ops);
 	if (ret)
diff --git a/net/can/isotp.c b/net/can/isotp.c
index ca63061bb932..4c2062875893 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -72,8 +72,6 @@
 #include <net/sock.h>
 #include <net/net_namespace.h>
 
-#define CAN_ISOTP_VERSION "20200928"
-
 MODULE_DESCRIPTION("PF_CAN isotp 15765-2:2016 protocol");
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Oliver Hartkopp <socketcan@hartkopp.net>");
@@ -1408,7 +1406,7 @@ static __init int isotp_module_init(void)
 {
 	int err;
 
-	pr_info("can: isotp protocol (rev " CAN_ISOTP_VERSION ")\n");
+	pr_info("can: isotp protocol\n");
 
 	err = can_proto_register(&isotp_can_proto);
 	if (err < 0)
diff --git a/net/can/proc.c b/net/can/proc.c
index a4eb06c9eb70..550928b8b8a2 100644
--- a/net/can/proc.c
+++ b/net/can/proc.c
@@ -54,7 +54,6 @@
  * proc filenames for the PF_CAN core
  */
 
-#define CAN_PROC_VERSION     "version"
 #define CAN_PROC_STATS       "stats"
 #define CAN_PROC_RESET_STATS "reset_stats"
 #define CAN_PROC_RCVLIST_ALL "rcvlist_all"
@@ -293,12 +292,6 @@ static int can_reset_stats_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int can_version_proc_show(struct seq_file *m, void *v)
-{
-	seq_printf(m, "%s\n", CAN_VERSION_STRING);
-	return 0;
-}
-
 static inline void can_rcvlist_proc_show_one(struct seq_file *m, int idx,
 					     struct net_device *dev,
 					     struct can_dev_rcv_lists *dev_rcv_lists)
@@ -441,8 +434,6 @@ void can_init_proc(struct net *net)
 	}
 
 	/* own procfs entries from the AF_CAN core */
-	net->can.pde_version = proc_create_net_single(CAN_PROC_VERSION, 0644,
-			net->can.proc_dir, can_version_proc_show, NULL);
 	net->can.pde_stats = proc_create_net_single(CAN_PROC_STATS, 0644,
 			net->can.proc_dir, can_stats_proc_show, NULL);
 	net->can.pde_reset_stats = proc_create_net_single(CAN_PROC_RESET_STATS,
@@ -471,9 +462,6 @@ void can_init_proc(struct net *net)
  */
 void can_remove_proc(struct net *net)
 {
-	if (net->can.pde_version)
-		remove_proc_entry(CAN_PROC_VERSION, net->can.proc_dir);
-
 	if (net->can.pde_stats)
 		remove_proc_entry(CAN_PROC_STATS, net->can.proc_dir);
 
diff --git a/net/can/raw.c b/net/can/raw.c
index ea70850f9152..6ec8aa1d0da4 100644
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -55,8 +55,6 @@
 #include <net/sock.h>
 #include <net/net_namespace.h>
 
-#define CAN_RAW_VERSION CAN_VERSION
-
 MODULE_DESCRIPTION("PF_CAN raw protocol");
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Urs Thuermann <urs.thuermann@volkswagen.de>");
@@ -885,7 +883,7 @@ static __init int raw_module_init(void)
 {
 	int err;
 
-	pr_info("can: raw protocol (rev " CAN_RAW_VERSION ")\n");
+	pr_info("can: raw protocol\n");
 
 	err = can_proto_register(&raw_can_proto);
 	if (err < 0)
-- 
2.28.0

