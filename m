Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88EA458B04
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 21:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbfF0TnO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 15:43:14 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:52740 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726441AbfF0TnO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 15:43:14 -0400
Received: by mail-pg1-f201.google.com with SMTP id a13so1824242pgw.19
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 12:43:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=bOfc1i4cJ+0OyQJgUqhzaYp4v4An8v8V80psElK1Qt4=;
        b=r07q6QjgH5h2sh4dXF3sH5WvSqyg+2ZlaB5XBLQBxKWqbMGNA2w2MZnlgbGu/V8WAi
         kj8fvxVHzcU3ZcISgF+vwhLydqJRbeqCQ/AffPNTa1CQGNQatL9VhIt3IhqOBT9+Vikd
         QMU+Xi3Ckz5L5VZjvrQoTId1fE2O6QINdGPZPEirSD/++Xhqg9Bo1eURUEx/O1NxAxwc
         4G8fjkPZzsPH5mwVGnRHcuNRfdmJfcZ4C4SzyEvWsSB5Y3+6xO+EE0CHtjfWLkbGqSFA
         nSknNk1TvQsoIqE+bJlkh7v3SeqZ0A8gPEFHfE5lSmmLSr7yYMXW2WBRDHawr+yEK1zO
         sDPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=bOfc1i4cJ+0OyQJgUqhzaYp4v4An8v8V80psElK1Qt4=;
        b=ESCXVwMEG6OG7wg1ig5hBnXvNG6posbOOXEWJ8kEZG3Kj5+z2LXF7bINcUY2+5Gvq0
         aIMajLGqbIDW5hAv0tfib00LGm6rYXv7fflDDw517LN1h156fvxm5Ijx9VgCZFg0OK8G
         JO2EY3eUsSPSDXv+sshWYtSvWPpo5AbDGSGsQPfZY79krUfpXMHLfLCJWAZQCOAT5W+k
         yoo2H+kvptz96d8LA/PTikO01nDg8SASHFmkbQNZinJ6qKrpSMWq9rnrD8wVeGZmJXBY
         GyRJacvXSq+AYCUdnGv2tSisQGaYJPgu9ojaoYo300Kgo4pZS9ZiVPbEtPBcLsQANvCK
         YGTw==
X-Gm-Message-State: APjAAAU6WGlBkEQ+7kmARGiXpWUSKwotsazdX9B3HklkoUxEzWLhiGJl
        7nQ61tBpMaqh1wJS47+gq2b1omrScRHeRdt/HyDD5WZJE6HfizCbbZO+MrwRX6Sqv3KpsRfZGYq
        Jcy9zSsmnKd7LH7lRBX94Bi9EvoJjGeg+8Ah/6RaIuLCjM+uCd7MeWYT/wN8bFe4u
X-Google-Smtp-Source: APXvYqyVXahd8rY2KEozodT1tVnA223EdRuiS9C3eomDz7AYA+AshQiqO6pxGDUzs44o8wOUaBQX+ic/u+SP
X-Received: by 2002:a63:c302:: with SMTP id c2mr5107327pgd.300.1561664592684;
 Thu, 27 Jun 2019 12:43:12 -0700 (PDT)
Date:   Thu, 27 Jun 2019 12:43:09 -0700
Message-Id: <20190627194309.94291-1-maheshb@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCHv2 next 3/3] blackhole_dev: add a selftest
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
index cbdfae379896..79d96e1614f5 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1909,6 +1909,15 @@ config TEST_BPF
 
 	  If unsure, say N.
 
+config TEST_BLACKHOLE_DEV
+	tristate "Test BPF filter functionality"
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
index fb7697031a79..c293624d3664 100644
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

