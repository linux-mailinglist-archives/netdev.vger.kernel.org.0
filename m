Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA75E5C510
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 23:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726966AbfGAVjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 17:39:07 -0400
Received: from mail-qk1-f201.google.com ([209.85.222.201]:48855 "EHLO
        mail-qk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbfGAVjG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 17:39:06 -0400
Received: by mail-qk1-f201.google.com with SMTP id z13so14845421qka.15
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 14:39:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=XND7BWwKXkBnyW1GhGYJ6OdDkEnaIktIR9DB/vHtWb0=;
        b=buuvMhMab+zoZnFRscYKPoZEwsh1sFXw4HUCIYh+4fssdSdR1ymWQpEvqam6haSyG+
         ZPgrrZg0fASW6XGUb7zedW6drOzlQnBdJ1X7nYP/956BD7wSnrTj6wgmKIe9U6PNQ4EJ
         FqMn39DEAZOovBcYq5fMjx/3lYo1bHHz8jv/q2RNSMzV8P7HWxbTu6/B+TPtmKB4whkw
         jJJ+oMlpiCsJ8hymwxOVIrtaRayLe2NF0HQCh3b4Srd/jShm5ps7/DMTU0Y4ZBm4vz+/
         OUWrksWQvnK639wzJkEyPoec1T9CakAh+XihdZUpMxvdZGFhF94+z4tgSCU6RxWOeu8Y
         C7fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=XND7BWwKXkBnyW1GhGYJ6OdDkEnaIktIR9DB/vHtWb0=;
        b=ZupS58viT6cxPBcCXrhojX0/j6epfoCYLNE83m9Zg/YXjvX60tUnqlUinhxd+POx2i
         4tobPdNKKLOfycWGU1zYWh+hiQGlh8624wts78B2MK4dpmNwAnUqoLAbDDLv8hXLUbzH
         betJDnuSEhvyUXjwlxpxiftCl/K1DD7bDwBbKDJPkuGQvrdRGYPRKUSIESyIDwPXKpvQ
         8kCduCQdsII7wu3nztziAc1+4wnwLdDg2QwdqmUFzWDowaZc2T73pX1Ya7gMB/2JxWSL
         04YTHFJMtMVopeYHQ5EC/+vJp7WKe/GGqOPLBiijqZdg79TrfpjiQ3uXtC1m73Pwt0zy
         OK9w==
X-Gm-Message-State: APjAAAULGDWo3Uphsn9yW/QquwZ3Q6/fa7e0alj5HFGyw1cgyzrh+nwr
        bzwg/i8JbrV4AOg7xVQDL352Mr9jvB0YL2dx/ZaG/rujPx8KsNBbcvWYxm1q+ZMcP7LAEPTTZ2J
        iulptFrkajvNYc9qf85q+c5n2gwWcVmSK4ntfHcYuYMOxDfbsAH4iwf8UddiJGfJN
X-Google-Smtp-Source: APXvYqysxIv9CJX92gMfAJ0Jw4SDhcmvvE/gy45Wy38s/qKOUqMkGYzb+xsRnO1J4Pdd4nK1HzeGRcw/VvVI
X-Received: by 2002:ac8:303c:: with SMTP id f57mr22558649qte.294.1562017145523;
 Mon, 01 Jul 2019 14:39:05 -0700 (PDT)
Date:   Mon,  1 Jul 2019 14:39:01 -0700
Message-Id: <20190701213901.104160-1-maheshb@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCHv3 next 3/3] blackhole_dev: add a selftest
From:   Mahesh Bandewar <maheshb@google.com>
To:     Netdev <netdev@vger.kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Daniel Axtens <dja@axtens.net>,
        Mahesh Bandewar <mahesh@bandewar.net>,
        Mahesh Bandewar <maheshb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since this is not really a device with all capabilities, this test
ensures that it has *enough* to make it through the data path
without causing unwanted side-effects (read crash!).

Signed-off-by: Mahesh Bandewar <maheshb@google.com>
---
v1 -> v2
  fixed the conflict resolution in selftests Makefile
v2 -> v3
  fixed lib/Kconfig.debug tristate text / string.

 lib/Kconfig.debug                             |   9 ++
 lib/Makefile                                  |   1 +
 lib/test_blackhole_dev.c                      | 100 ++++++++++++++++++
 tools/testing/selftests/net/Makefile          |   2 +-
 tools/testing/selftests/net/config            |   1 +
 .../selftests/net/test_blackhole_dev.sh       |  11 ++
 6 files changed, 123 insertions(+), 1 deletion(-)
 create mode 100644 lib/test_blackhole_dev.c
 create mode 100755 tools/testing/selftests/net/test_blackhole_dev.sh

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index cbdfae379896..99272b5dd980 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1909,6 +1909,15 @@ config TEST_BPF
 
 	  If unsure, say N.
 
+config TEST_BLACKHOLE_DEV
+	tristate "Test blackhole netdev functionality"
+	depends on m && NET
+	help
+	  This builds the "test_blackhole_dev" module that validates the
+	  data path through this blackhole netdev.
+
+	  If unsure, say N.
+
 config FIND_BIT_BENCHMARK
 	tristate "Test find_bit functions"
 	help
diff --git a/lib/Makefile b/lib/Makefile
index dcb558c7554d..6ac44fe2a37f 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -91,6 +91,7 @@ obj-$(CONFIG_TEST_DEBUG_VIRTUAL) += test_debug_virtual.o
 obj-$(CONFIG_TEST_MEMCAT_P) += test_memcat_p.o
 obj-$(CONFIG_TEST_OBJAGG) += test_objagg.o
 obj-$(CONFIG_TEST_STACKINIT) += test_stackinit.o
+obj-$(CONFIG_TEST_BLACKHOLE_DEV) += test_blackhole_dev.o
 
 obj-$(CONFIG_TEST_LIVEPATCH) += livepatch/
 
diff --git a/lib/test_blackhole_dev.c b/lib/test_blackhole_dev.c
new file mode 100644
index 000000000000..4c40580a99a3
--- /dev/null
+++ b/lib/test_blackhole_dev.c
@@ -0,0 +1,100 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * This module tests the blackhole_dev that is created during the
+ * net subsystem initialization. The test this module performs is
+ * by injecting an skb into the stack with skb->dev as the
+ * blackhole_dev and expects kernel to behave in a sane manner
+ * (in other words, *not crash*)!
+ *
+ * Copyright (c) 2018, Mahesh Bandewar <maheshb@google.com>
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/printk.h>
+#include <linux/skbuff.h>
+#include <linux/netdevice.h>
+#include <linux/udp.h>
+#include <linux/ipv6.h>
+
+#include <net/dst.h>
+
+#define SKB_SIZE  256
+#define HEAD_SIZE (14+40+8)	/* Ether + IPv6 + UDP */
+#define TAIL_SIZE 32		/* random tail-room */
+
+#define UDP_PORT 1234
+
+static int __init test_blackholedev_init(void)
+{
+	struct ipv6hdr *ip6h;
+	struct sk_buff *skb;
+	struct ethhdr *ethh;
+	struct udphdr *uh;
+	int data_len;
+	int ret;
+
+	skb = alloc_skb(SKB_SIZE, GFP_KERNEL);
+	if (!skb)
+		return -ENOMEM;
+
+	/* Reserve head-room for the headers */
+	skb_reserve(skb, HEAD_SIZE);
+
+	/* Add data to the skb */
+	data_len = SKB_SIZE - (HEAD_SIZE + TAIL_SIZE);
+	memset(__skb_put(skb, data_len), 0xf, data_len);
+
+	/* Add protocol data */
+	/* (Transport) UDP */
+	uh = (struct udphdr *)skb_push(skb, sizeof(struct udphdr));
+	skb_set_transport_header(skb, 0);
+	uh->source = uh->dest = htons(UDP_PORT);
+	uh->len = htons(data_len);
+	uh->check = 0;
+	/* (Network) IPv6 */
+	ip6h = (struct ipv6hdr *)skb_push(skb, sizeof(struct ipv6hdr));
+	skb_set_network_header(skb, 0);
+	ip6h->hop_limit = 32;
+	ip6h->payload_len = data_len + sizeof(struct udphdr);
+	ip6h->nexthdr = IPPROTO_UDP;
+	ip6h->saddr = in6addr_loopback;
+	ip6h->daddr = in6addr_loopback;
+	/* Ether */
+	ethh = (struct ethhdr *)skb_push(skb, sizeof(struct ethhdr));
+	skb_set_mac_header(skb, 0);
+
+	skb->protocol = htons(ETH_P_IPV6);
+	skb->pkt_type = PACKET_HOST;
+	skb->dev = blackhole_netdev;
+
+	/* Now attempt to send the packet */
+	ret = dev_queue_xmit(skb);
+
+	switch (ret) {
+	case NET_XMIT_SUCCESS:
+		pr_warn("dev_queue_xmit() returned NET_XMIT_SUCCESS\n");
+		break;
+	case NET_XMIT_DROP:
+		pr_warn("dev_queue_xmit() returned NET_XMIT_DROP\n");
+		break;
+	case NET_XMIT_CN:
+		pr_warn("dev_queue_xmit() returned NET_XMIT_CN\n");
+		break;
+	default:
+		pr_err("dev_queue_xmit() returned UNKNOWN(%d)\n", ret);
+	}
+
+	return 0;
+}
+
+static void __exit test_blackholedev_exit(void)
+{
+	pr_warn("test_blackholedev module terminating.\n");
+}
+
+module_init(test_blackholedev_init);
+module_exit(test_blackholedev_exit);
+
+MODULE_AUTHOR("Mahesh Bandewar <maheshb@google.com>");
+MODULE_LICENSE("GPL");
diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 9a275d932fd5..1b24e36b4047 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -5,7 +5,7 @@ CFLAGS =  -Wall -Wl,--no-as-needed -O2 -g
 CFLAGS += -I../../../../usr/include/
 
 TEST_PROGS := run_netsocktests run_afpackettests test_bpf.sh netdevice.sh \
-	      rtnetlink.sh xfrm_policy.sh
+	      rtnetlink.sh xfrm_policy.sh test_blackhole_dev.sh
 TEST_PROGS += fib_tests.sh fib-onlink-tests.sh pmtu.sh udpgso.sh ip_defrag.sh
 TEST_PROGS += udpgso_bench.sh fib_rule_tests.sh msg_zerocopy.sh psock_snd.sh
 TEST_PROGS += udpgro_bench.sh udpgro.sh test_vxlan_under_vrf.sh reuseport_addr_any.sh
diff --git a/tools/testing/selftests/net/config b/tools/testing/selftests/net/config
index 89f84b5118bf..e4b878d95ba0 100644
--- a/tools/testing/selftests/net/config
+++ b/tools/testing/selftests/net/config
@@ -27,3 +27,4 @@ CONFIG_NFT_CHAIN_NAT_IPV6=m
 CONFIG_NFT_CHAIN_NAT_IPV4=m
 CONFIG_NET_SCH_FQ=m
 CONFIG_NET_SCH_ETF=m
+CONFIG_TEST_BLACKHOLE_DEV=m
diff --git a/tools/testing/selftests/net/test_blackhole_dev.sh b/tools/testing/selftests/net/test_blackhole_dev.sh
new file mode 100755
index 000000000000..3119b80e711f
--- /dev/null
+++ b/tools/testing/selftests/net/test_blackhole_dev.sh
@@ -0,0 +1,11 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+# Runs blackhole-dev test using blackhole-dev kernel module
+
+if /sbin/modprobe -q test_blackhole_dev ; then
+	/sbin/modprobe -q -r test_blackhole_dev;
+	echo "test_blackhole_dev: ok";
+else
+	echo "test_blackhole_dev: [FAIL]";
+	exit 1;
+fi
-- 
2.22.0.410.gd8fdbe21b5-goog

