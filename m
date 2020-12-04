Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4572CF100
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 16:47:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725987AbgLDPrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 10:47:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730626AbgLDPrS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 10:47:18 -0500
Received: from simonwunderlich.de (packetmixer.de [IPv6:2001:4d88:2000:24::c0de])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A20EC061A56
        for <netdev@vger.kernel.org>; Fri,  4 Dec 2020 07:46:38 -0800 (PST)
Received: from kero.packetmixer.de (p200300c59716c1e0c1b6a3b925be22c4.dip0.t-ipconnect.de [IPv6:2003:c5:9716:c1e0:c1b6:a3b9:25be:22c4])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id 9EA3F174061;
        Fri,  4 Dec 2020 16:46:33 +0100 (CET)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 2/8] batman-adv: Add new include for min/max helpers
Date:   Fri,  4 Dec 2020 16:46:25 +0100
Message-Id: <20201204154631.21063-3-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201204154631.21063-1-sw@simonwunderlich.de>
References: <20201204154631.21063-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

The commit b296a6d53339 ("kernel.h: split out min()/max() et al. helpers")
moved the min/max helper functionality from kernel.h to minmax.h. Adjust
the kernel code accordingly to avoid fragile indirect includes.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/bat_v.c          | 1 +
 net/batman-adv/bat_v_elp.c      | 1 +
 net/batman-adv/bat_v_ogm.c      | 1 +
 net/batman-adv/fragmentation.c  | 2 +-
 net/batman-adv/hard-interface.c | 1 +
 net/batman-adv/icmp_socket.c    | 1 +
 net/batman-adv/main.c           | 1 +
 net/batman-adv/netlink.c        | 1 +
 net/batman-adv/tp_meter.c       | 1 +
 9 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/batman-adv/bat_v.c b/net/batman-adv/bat_v.c
index 0ecaf1bb0068..e91d2c0720c4 100644
--- a/net/batman-adv/bat_v.c
+++ b/net/batman-adv/bat_v.c
@@ -16,6 +16,7 @@
 #include <linux/kernel.h>
 #include <linux/kref.h>
 #include <linux/list.h>
+#include <linux/minmax.h>
 #include <linux/netdevice.h>
 #include <linux/netlink.h>
 #include <linux/rculist.h>
diff --git a/net/batman-adv/bat_v_elp.c b/net/batman-adv/bat_v_elp.c
index 79a7dfc32e76..0512ea6cd818 100644
--- a/net/batman-adv/bat_v_elp.c
+++ b/net/batman-adv/bat_v_elp.c
@@ -18,6 +18,7 @@
 #include <linux/jiffies.h>
 #include <linux/kernel.h>
 #include <linux/kref.h>
+#include <linux/minmax.h>
 #include <linux/netdevice.h>
 #include <linux/nl80211.h>
 #include <linux/prandom.h>
diff --git a/net/batman-adv/bat_v_ogm.c b/net/batman-adv/bat_v_ogm.c
index 8c1148fc73d7..798d659855d0 100644
--- a/net/batman-adv/bat_v_ogm.c
+++ b/net/batman-adv/bat_v_ogm.c
@@ -18,6 +18,7 @@
 #include <linux/kref.h>
 #include <linux/list.h>
 #include <linux/lockdep.h>
+#include <linux/minmax.h>
 #include <linux/mutex.h>
 #include <linux/netdevice.h>
 #include <linux/prandom.h>
diff --git a/net/batman-adv/fragmentation.c b/net/batman-adv/fragmentation.c
index 1f1f5b0873b2..59ebd73125bf 100644
--- a/net/batman-adv/fragmentation.c
+++ b/net/batman-adv/fragmentation.c
@@ -14,8 +14,8 @@
 #include <linux/gfp.h>
 #include <linux/if_ether.h>
 #include <linux/jiffies.h>
-#include <linux/kernel.h>
 #include <linux/lockdep.h>
+#include <linux/minmax.h>
 #include <linux/netdevice.h>
 #include <linux/skbuff.h>
 #include <linux/slab.h>
diff --git a/net/batman-adv/hard-interface.c b/net/batman-adv/hard-interface.c
index 33904595fc56..3838a6165c5e 100644
--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -18,6 +18,7 @@
 #include <linux/kref.h>
 #include <linux/limits.h>
 #include <linux/list.h>
+#include <linux/minmax.h>
 #include <linux/mutex.h>
 #include <linux/netdevice.h>
 #include <linux/printk.h>
diff --git a/net/batman-adv/icmp_socket.c b/net/batman-adv/icmp_socket.c
index 8bdabc03b0b2..56de4bf21aa5 100644
--- a/net/batman-adv/icmp_socket.c
+++ b/net/batman-adv/icmp_socket.c
@@ -20,6 +20,7 @@
 #include <linux/if_ether.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
+#include <linux/minmax.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
 #include <linux/pkt_sched.h>
diff --git a/net/batman-adv/main.c b/net/batman-adv/main.c
index 70fee9b42e25..293c62edd9ed 100644
--- a/net/batman-adv/main.c
+++ b/net/batman-adv/main.c
@@ -23,6 +23,7 @@
 #include <linux/kobject.h>
 #include <linux/kref.h>
 #include <linux/list.h>
+#include <linux/minmax.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
 #include <linux/printk.h>
diff --git a/net/batman-adv/netlink.c b/net/batman-adv/netlink.c
index c7a55647b520..97bcf149633d 100644
--- a/net/batman-adv/netlink.c
+++ b/net/batman-adv/netlink.c
@@ -23,6 +23,7 @@
 #include <linux/kernel.h>
 #include <linux/limits.h>
 #include <linux/list.h>
+#include <linux/minmax.h>
 #include <linux/netdevice.h>
 #include <linux/netlink.h>
 #include <linux/printk.h>
diff --git a/net/batman-adv/tp_meter.c b/net/batman-adv/tp_meter.c
index db7e3774825b..d4e10005df6c 100644
--- a/net/batman-adv/tp_meter.c
+++ b/net/batman-adv/tp_meter.c
@@ -23,6 +23,7 @@
 #include <linux/kthread.h>
 #include <linux/limits.h>
 #include <linux/list.h>
+#include <linux/minmax.h>
 #include <linux/netdevice.h>
 #include <linux/param.h>
 #include <linux/printk.h>
-- 
2.20.1

