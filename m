Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03A2E4CAA62
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 17:35:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242753AbiCBQgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 11:36:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242700AbiCBQgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 11:36:11 -0500
Received: from simonwunderlich.de (simonwunderlich.de [23.88.38.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50E2CCE920
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 08:35:27 -0800 (PST)
Received: from kero.packetmixer.de (p200300c597470FC0D439fbE5C3508408.dip0.t-ipconnect.de [IPv6:2003:c5:9747:fc0:d439:fbe5:c350:8408])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id D2886FA74F;
        Wed,  2 Mar 2022 17:35:25 +0100 (CET)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 3/4] batman-adv: Migrate to linux/container_of.h
Date:   Wed,  2 Mar 2022 17:35:21 +0100
Message-Id: <20220302163522.102842-4-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220302163522.102842-1-sw@simonwunderlich.de>
References: <20220302163522.102842-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

The commit d2a8ebbf8192 ("kernel.h: split out container_of() and
typeof_member() macros")  introduced a new header for the container_of
related macros from (previously) linux/kernel.h.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/bat_iv_ogm.c            | 2 +-
 net/batman-adv/bat_v_elp.c             | 2 +-
 net/batman-adv/bat_v_ogm.c             | 2 +-
 net/batman-adv/bridge_loop_avoidance.c | 1 +
 net/batman-adv/distributed-arp-table.c | 2 +-
 net/batman-adv/gateway_client.c        | 1 +
 net/batman-adv/hard-interface.c        | 2 +-
 net/batman-adv/main.c                  | 1 +
 net/batman-adv/multicast.c             | 1 +
 net/batman-adv/network-coding.c        | 2 +-
 net/batman-adv/originator.c            | 2 +-
 net/batman-adv/send.c                  | 2 +-
 net/batman-adv/soft-interface.c        | 2 +-
 net/batman-adv/tp_meter.c              | 2 +-
 net/batman-adv/translation-table.c     | 2 +-
 net/batman-adv/tvlv.c                  | 2 +-
 16 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/net/batman-adv/bat_iv_ogm.c b/net/batman-adv/bat_iv_ogm.c
index f94f538fa382..7f6a7c96ac92 100644
--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -13,13 +13,13 @@
 #include <linux/bug.h>
 #include <linux/byteorder/generic.h>
 #include <linux/cache.h>
+#include <linux/container_of.h>
 #include <linux/errno.h>
 #include <linux/etherdevice.h>
 #include <linux/gfp.h>
 #include <linux/if_ether.h>
 #include <linux/init.h>
 #include <linux/jiffies.h>
-#include <linux/kernel.h>
 #include <linux/kref.h>
 #include <linux/list.h>
 #include <linux/lockdep.h>
diff --git a/net/batman-adv/bat_v_elp.c b/net/batman-adv/bat_v_elp.c
index 71999e13f729..b6db999abf75 100644
--- a/net/batman-adv/bat_v_elp.c
+++ b/net/batman-adv/bat_v_elp.c
@@ -10,13 +10,13 @@
 #include <linux/atomic.h>
 #include <linux/bitops.h>
 #include <linux/byteorder/generic.h>
+#include <linux/container_of.h>
 #include <linux/errno.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
 #include <linux/gfp.h>
 #include <linux/if_ether.h>
 #include <linux/jiffies.h>
-#include <linux/kernel.h>
 #include <linux/kref.h>
 #include <linux/minmax.h>
 #include <linux/netdevice.h>
diff --git a/net/batman-adv/bat_v_ogm.c b/net/batman-adv/bat_v_ogm.c
index 1d750f3cb2e4..033639df96d8 100644
--- a/net/batman-adv/bat_v_ogm.c
+++ b/net/batman-adv/bat_v_ogm.c
@@ -9,12 +9,12 @@
 
 #include <linux/atomic.h>
 #include <linux/byteorder/generic.h>
+#include <linux/container_of.h>
 #include <linux/errno.h>
 #include <linux/etherdevice.h>
 #include <linux/gfp.h>
 #include <linux/if_ether.h>
 #include <linux/jiffies.h>
-#include <linux/kernel.h>
 #include <linux/kref.h>
 #include <linux/list.h>
 #include <linux/lockdep.h>
diff --git a/net/batman-adv/bridge_loop_avoidance.c b/net/batman-adv/bridge_loop_avoidance.c
index 2ed9496fc41f..337e20b6586d 100644
--- a/net/batman-adv/bridge_loop_avoidance.c
+++ b/net/batman-adv/bridge_loop_avoidance.c
@@ -10,6 +10,7 @@
 #include <linux/atomic.h>
 #include <linux/byteorder/generic.h>
 #include <linux/compiler.h>
+#include <linux/container_of.h>
 #include <linux/crc16.h>
 #include <linux/errno.h>
 #include <linux/etherdevice.h>
diff --git a/net/batman-adv/distributed-arp-table.c b/net/batman-adv/distributed-arp-table.c
index 2f008e329007..fefb51a5f606 100644
--- a/net/batman-adv/distributed-arp-table.c
+++ b/net/batman-adv/distributed-arp-table.c
@@ -11,6 +11,7 @@
 #include <linux/atomic.h>
 #include <linux/bitops.h>
 #include <linux/byteorder/generic.h>
+#include <linux/container_of.h>
 #include <linux/errno.h>
 #include <linux/etherdevice.h>
 #include <linux/gfp.h>
@@ -20,7 +21,6 @@
 #include <linux/in.h>
 #include <linux/ip.h>
 #include <linux/jiffies.h>
-#include <linux/kernel.h>
 #include <linux/kref.h>
 #include <linux/list.h>
 #include <linux/netlink.h>
diff --git a/net/batman-adv/gateway_client.c b/net/batman-adv/gateway_client.c
index b7466136e292..d26124bc27e1 100644
--- a/net/batman-adv/gateway_client.c
+++ b/net/batman-adv/gateway_client.c
@@ -9,6 +9,7 @@
 
 #include <linux/atomic.h>
 #include <linux/byteorder/generic.h>
+#include <linux/container_of.h>
 #include <linux/errno.h>
 #include <linux/etherdevice.h>
 #include <linux/gfp.h>
diff --git a/net/batman-adv/hard-interface.c b/net/batman-adv/hard-interface.c
index 8a2b78f9c4b2..59d19097a54c 100644
--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -9,11 +9,11 @@
 
 #include <linux/atomic.h>
 #include <linux/byteorder/generic.h>
+#include <linux/container_of.h>
 #include <linux/gfp.h>
 #include <linux/if.h>
 #include <linux/if_arp.h>
 #include <linux/if_ether.h>
-#include <linux/kernel.h>
 #include <linux/kref.h>
 #include <linux/limits.h>
 #include <linux/list.h>
diff --git a/net/batman-adv/main.c b/net/batman-adv/main.c
index 8f1b724d0412..e8a449915566 100644
--- a/net/batman-adv/main.c
+++ b/net/batman-adv/main.c
@@ -9,6 +9,7 @@
 #include <linux/atomic.h>
 #include <linux/build_bug.h>
 #include <linux/byteorder/generic.h>
+#include <linux/container_of.h>
 #include <linux/crc32c.h>
 #include <linux/device.h>
 #include <linux/errno.h>
diff --git a/net/batman-adv/multicast.c b/net/batman-adv/multicast.c
index f4004cf0ff6f..1860de735661 100644
--- a/net/batman-adv/multicast.c
+++ b/net/batman-adv/multicast.c
@@ -11,6 +11,7 @@
 #include <linux/bitops.h>
 #include <linux/bug.h>
 #include <linux/byteorder/generic.h>
+#include <linux/container_of.h>
 #include <linux/errno.h>
 #include <linux/etherdevice.h>
 #include <linux/gfp.h>
diff --git a/net/batman-adv/network-coding.c b/net/batman-adv/network-coding.c
index 974d726fabb9..5f4aeeb60dc4 100644
--- a/net/batman-adv/network-coding.c
+++ b/net/batman-adv/network-coding.c
@@ -11,6 +11,7 @@
 #include <linux/bitops.h>
 #include <linux/byteorder/generic.h>
 #include <linux/compiler.h>
+#include <linux/container_of.h>
 #include <linux/errno.h>
 #include <linux/etherdevice.h>
 #include <linux/gfp.h>
@@ -19,7 +20,6 @@
 #include <linux/init.h>
 #include <linux/jhash.h>
 #include <linux/jiffies.h>
-#include <linux/kernel.h>
 #include <linux/kref.h>
 #include <linux/list.h>
 #include <linux/lockdep.h>
diff --git a/net/batman-adv/originator.c b/net/batman-adv/originator.c
index aadc653ca1d8..34903df4fe93 100644
--- a/net/batman-adv/originator.c
+++ b/net/batman-adv/originator.c
@@ -8,11 +8,11 @@
 #include "main.h"
 
 #include <linux/atomic.h>
+#include <linux/container_of.h>
 #include <linux/errno.h>
 #include <linux/etherdevice.h>
 #include <linux/gfp.h>
 #include <linux/jiffies.h>
-#include <linux/kernel.h>
 #include <linux/kref.h>
 #include <linux/list.h>
 #include <linux/lockdep.h>
diff --git a/net/batman-adv/send.c b/net/batman-adv/send.c
index 477d85a3b558..0379b126865d 100644
--- a/net/batman-adv/send.c
+++ b/net/batman-adv/send.c
@@ -10,13 +10,13 @@
 #include <linux/atomic.h>
 #include <linux/bug.h>
 #include <linux/byteorder/generic.h>
+#include <linux/container_of.h>
 #include <linux/errno.h>
 #include <linux/etherdevice.h>
 #include <linux/gfp.h>
 #include <linux/if.h>
 #include <linux/if_ether.h>
 #include <linux/jiffies.h>
-#include <linux/kernel.h>
 #include <linux/kref.h>
 #include <linux/list.h>
 #include <linux/netdevice.h>
diff --git a/net/batman-adv/soft-interface.c b/net/batman-adv/soft-interface.c
index 2dbbe6c19609..0f5c0679b55a 100644
--- a/net/batman-adv/soft-interface.c
+++ b/net/batman-adv/soft-interface.c
@@ -11,6 +11,7 @@
 #include <linux/byteorder/generic.h>
 #include <linux/cache.h>
 #include <linux/compiler.h>
+#include <linux/container_of.h>
 #include <linux/cpumask.h>
 #include <linux/errno.h>
 #include <linux/etherdevice.h>
@@ -19,7 +20,6 @@
 #include <linux/if_ether.h>
 #include <linux/if_vlan.h>
 #include <linux/jiffies.h>
-#include <linux/kernel.h>
 #include <linux/kref.h>
 #include <linux/list.h>
 #include <linux/lockdep.h>
diff --git a/net/batman-adv/tp_meter.c b/net/batman-adv/tp_meter.c
index 93730d30af54..7f3dd3c393e0 100644
--- a/net/batman-adv/tp_meter.c
+++ b/net/batman-adv/tp_meter.c
@@ -12,13 +12,13 @@
 #include <linux/byteorder/generic.h>
 #include <linux/cache.h>
 #include <linux/compiler.h>
+#include <linux/container_of.h>
 #include <linux/err.h>
 #include <linux/etherdevice.h>
 #include <linux/gfp.h>
 #include <linux/if_ether.h>
 #include <linux/init.h>
 #include <linux/jiffies.h>
-#include <linux/kernel.h>
 #include <linux/kref.h>
 #include <linux/kthread.h>
 #include <linux/limits.h>
diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
index 4b7ad6684bc4..8478034d3abf 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -13,6 +13,7 @@
 #include <linux/byteorder/generic.h>
 #include <linux/cache.h>
 #include <linux/compiler.h>
+#include <linux/container_of.h>
 #include <linux/crc32c.h>
 #include <linux/errno.h>
 #include <linux/etherdevice.h>
@@ -21,7 +22,6 @@
 #include <linux/init.h>
 #include <linux/jhash.h>
 #include <linux/jiffies.h>
-#include <linux/kernel.h>
 #include <linux/kref.h>
 #include <linux/list.h>
 #include <linux/lockdep.h>
diff --git a/net/batman-adv/tvlv.c b/net/batman-adv/tvlv.c
index 0cb58eb04093..7ec2e2343884 100644
--- a/net/batman-adv/tvlv.c
+++ b/net/batman-adv/tvlv.c
@@ -7,10 +7,10 @@
 #include "main.h"
 
 #include <linux/byteorder/generic.h>
+#include <linux/container_of.h>
 #include <linux/etherdevice.h>
 #include <linux/gfp.h>
 #include <linux/if_ether.h>
-#include <linux/kernel.h>
 #include <linux/kref.h>
 #include <linux/list.h>
 #include <linux/lockdep.h>
-- 
2.30.2

