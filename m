Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1FA1C015B
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 18:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728220AbgD3QFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 12:05:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:50850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727103AbgD3QEj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 12:04:39 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 329A524969;
        Thu, 30 Apr 2020 16:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588262676;
        bh=ndPSdK70Z/eKCDwQ4HjVxQ8dfg86axtPMh33iuJPvoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ua0Fay3ByRY0KI/jocoMhJI5S8xzjaXCQHFzlsm4VY9+ynIGr3Kdh9sdu5OOuLzTP
         sVBL1DBQJQ8drQEVs2o5BNd7n+0bBFM/7+uWeN9W/doRf02WMMXprL84v7Br/P0+1D
         +EG5K8bhL/J/sstehBJtGHHSuSs6pAsEWhhqQBfI=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jUBfu-00AxFX-F2; Thu, 30 Apr 2020 18:04:34 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 18/37] docs: networking: convert pktgen.txt to ReST
Date:   Thu, 30 Apr 2020 18:04:13 +0200
Message-Id: <087ccb2cf7d8af562e55ac99afefc3b2255e42ff.1588261997.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1588261997.git.mchehab+huawei@kernel.org>
References: <cover.1588261997.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- add SPDX header;
- adjust title markup;
- use bold markups on a few places;
- mark code blocks and literals as such;
- adjust identation, whitespaces and blank lines where needed;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/index.rst            |   1 +
 .../networking/{pktgen.txt => pktgen.rst}     | 316 +++++++++---------
 net/Kconfig                                   |   2 +-
 net/core/pktgen.c                             |   2 +-
 samples/pktgen/README.rst                     |   2 +-
 5 files changed, 168 insertions(+), 155 deletions(-)
 rename Documentation/networking/{pktgen.txt => pktgen.rst} (62%)

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index e460026331c6..696181a96e3c 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -91,6 +91,7 @@ Contents:
    operstates
    packet_mmap
    phonet
+   pktgen
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/pktgen.txt b/Documentation/networking/pktgen.rst
similarity index 62%
rename from Documentation/networking/pktgen.txt
rename to Documentation/networking/pktgen.rst
index d2fd78f85aa4..7afa1c9f1183 100644
--- a/Documentation/networking/pktgen.txt
+++ b/Documentation/networking/pktgen.rst
@@ -1,7 +1,8 @@
+.. SPDX-License-Identifier: GPL-2.0
 
-
-                  HOWTO for the linux packet generator
-                  ------------------------------------
+====================================
+HOWTO for the linux packet generator
+====================================
 
 Enable CONFIG_NET_PKTGEN to compile and build pktgen either in-kernel
 or as a module.  A module is preferred; modprobe pktgen if needed.  Once
@@ -9,17 +10,18 @@ running, pktgen creates a thread for each CPU with affinity to that CPU.
 Monitoring and controlling is done via /proc.  It is easiest to select a
 suitable sample script and configure that.
 
-On a dual CPU:
+On a dual CPU::
 
-ps aux | grep pkt
-root       129  0.3  0.0     0    0 ?        SW    2003 523:20 [kpktgend_0]
-root       130  0.3  0.0     0    0 ?        SW    2003 509:50 [kpktgend_1]
+    ps aux | grep pkt
+    root       129  0.3  0.0     0    0 ?        SW    2003 523:20 [kpktgend_0]
+    root       130  0.3  0.0     0    0 ?        SW    2003 509:50 [kpktgend_1]
 
 
-For monitoring and control pktgen creates:
+For monitoring and control pktgen creates::
+
 	/proc/net/pktgen/pgctrl
 	/proc/net/pktgen/kpktgend_X
-        /proc/net/pktgen/ethX
+	/proc/net/pktgen/ethX
 
 
 Tuning NIC for max performance
@@ -28,7 +30,8 @@ Tuning NIC for max performance
 The default NIC settings are (likely) not tuned for pktgen's artificial
 overload type of benchmarking, as this could hurt the normal use-case.
 
-Specifically increasing the TX ring buffer in the NIC:
+Specifically increasing the TX ring buffer in the NIC::
+
  # ethtool -G ethX tx 1024
 
 A larger TX ring can improve pktgen's performance, while it can hurt
@@ -46,7 +49,8 @@ This cleanup issue is specifically the case for the driver ixgbe
 and the cleanup interval is affected by the ethtool --coalesce setting
 of parameter "rx-usecs".
 
-For ixgbe use e.g. "30" resulting in approx 33K interrupts/sec (1/30*10^6):
+For ixgbe use e.g. "30" resulting in approx 33K interrupts/sec (1/30*10^6)::
+
  # ethtool -C ethX rx-usecs 30
 
 
@@ -55,7 +59,7 @@ Kernel threads
 Pktgen creates a thread for each CPU with affinity to that CPU.
 Which is controlled through procfile /proc/net/pktgen/kpktgend_X.
 
-Example: /proc/net/pktgen/kpktgend_0
+Example: /proc/net/pktgen/kpktgend_0::
 
  Running:
  Stopped: eth4@0
@@ -64,6 +68,7 @@ Example: /proc/net/pktgen/kpktgend_0
 Most important are the devices assigned to the thread.
 
 The two basic thread commands are:
+
  * add_device DEVICE@NAME -- adds a single device
  * rem_device_all         -- remove all associated devices
 
@@ -73,7 +78,7 @@ be unique.
 
 To support adding the same device to multiple threads, which is useful
 with multi queue NICs, the device naming scheme is extended with "@":
- device@something
+device@something
 
 The part after "@" can be anything, but it is custom to use the thread
 number.
@@ -83,30 +88,30 @@ Viewing devices
 
 The Params section holds configured information.  The Current section
 holds running statistics.  The Result is printed after a run or after
-interruption.  Example:
+interruption.  Example::
 
-/proc/net/pktgen/eth4@0
+    /proc/net/pktgen/eth4@0
 
- Params: count 100000  min_pkt_size: 60  max_pkt_size: 60
-     frags: 0  delay: 0  clone_skb: 64  ifname: eth4@0
-     flows: 0 flowlen: 0
-     queue_map_min: 0  queue_map_max: 0
-     dst_min: 192.168.81.2  dst_max:
-     src_min:   src_max:
-     src_mac: 90:e2:ba:0a:56:b4 dst_mac: 00:1b:21:3c:9d:f8
-     udp_src_min: 9  udp_src_max: 109  udp_dst_min: 9  udp_dst_max: 9
-     src_mac_count: 0  dst_mac_count: 0
-     Flags: UDPSRC_RND  NO_TIMESTAMP  QUEUE_MAP_CPU
- Current:
-     pkts-sofar: 100000  errors: 0
-     started: 623913381008us  stopped: 623913396439us idle: 25us
-     seq_num: 100001  cur_dst_mac_offset: 0  cur_src_mac_offset: 0
-     cur_saddr: 192.168.8.3  cur_daddr: 192.168.81.2
-     cur_udp_dst: 9  cur_udp_src: 42
-     cur_queue_map: 0
-     flows: 0
- Result: OK: 15430(c15405+d25) usec, 100000 (60byte,0frags)
-  6480562pps 3110Mb/sec (3110669760bps) errors: 0
+    Params: count 100000  min_pkt_size: 60  max_pkt_size: 60
+	frags: 0  delay: 0  clone_skb: 64  ifname: eth4@0
+	flows: 0 flowlen: 0
+	queue_map_min: 0  queue_map_max: 0
+	dst_min: 192.168.81.2  dst_max:
+	src_min:   src_max:
+	src_mac: 90:e2:ba:0a:56:b4 dst_mac: 00:1b:21:3c:9d:f8
+	udp_src_min: 9  udp_src_max: 109  udp_dst_min: 9  udp_dst_max: 9
+	src_mac_count: 0  dst_mac_count: 0
+	Flags: UDPSRC_RND  NO_TIMESTAMP  QUEUE_MAP_CPU
+    Current:
+	pkts-sofar: 100000  errors: 0
+	started: 623913381008us  stopped: 623913396439us idle: 25us
+	seq_num: 100001  cur_dst_mac_offset: 0  cur_src_mac_offset: 0
+	cur_saddr: 192.168.8.3  cur_daddr: 192.168.81.2
+	cur_udp_dst: 9  cur_udp_src: 42
+	cur_queue_map: 0
+	flows: 0
+    Result: OK: 15430(c15405+d25) usec, 100000 (60byte,0frags)
+    6480562pps 3110Mb/sec (3110669760bps) errors: 0
 
 
 Configuring devices
@@ -114,11 +119,12 @@ Configuring devices
 This is done via the /proc interface, and most easily done via pgset
 as defined in the sample scripts.
 You need to specify PGDEV environment variable to use functions from sample
-scripts, i.e.:
-export PGDEV=/proc/net/pktgen/eth4@0
-source samples/pktgen/functions.sh
+scripts, i.e.::
 
-Examples:
+    export PGDEV=/proc/net/pktgen/eth4@0
+    source samples/pktgen/functions.sh
+
+Examples::
 
  pg_ctrl start           starts injection.
  pg_ctrl stop            aborts injection. Also, ^C aborts generator.
@@ -126,17 +132,17 @@ Examples:
  pgset "clone_skb 1"     sets the number of copies of the same packet
  pgset "clone_skb 0"     use single SKB for all transmits
  pgset "burst 8"         uses xmit_more API to queue 8 copies of the same
-                         packet and update HW tx queue tail pointer once.
-                         "burst 1" is the default
+			 packet and update HW tx queue tail pointer once.
+			 "burst 1" is the default
  pgset "pkt_size 9014"   sets packet size to 9014
  pgset "frags 5"         packet will consist of 5 fragments
  pgset "count 200000"    sets number of packets to send, set to zero
-                         for continuous sends until explicitly stopped.
+			 for continuous sends until explicitly stopped.
 
  pgset "delay 5000"      adds delay to hard_start_xmit(). nanoseconds
 
  pgset "dst 10.0.0.1"    sets IP destination address
-                         (BEWARE! This generator is very aggressive!)
+			 (BEWARE! This generator is very aggressive!)
 
  pgset "dst_min 10.0.0.1"            Same as dst
  pgset "dst_max 10.0.0.254"          Set the maximum destination IP.
@@ -149,46 +155,46 @@ Examples:
 
  pgset "queue_map_min 0" Sets the min value of tx queue interval
  pgset "queue_map_max 7" Sets the max value of tx queue interval, for multiqueue devices
-                         To select queue 1 of a given device,
-                         use queue_map_min=1 and queue_map_max=1
+			 To select queue 1 of a given device,
+			 use queue_map_min=1 and queue_map_max=1
 
  pgset "src_mac_count 1" Sets the number of MACs we'll range through.
-                         The 'minimum' MAC is what you set with srcmac.
+			 The 'minimum' MAC is what you set with srcmac.
 
  pgset "dst_mac_count 1" Sets the number of MACs we'll range through.
-                         The 'minimum' MAC is what you set with dstmac.
+			 The 'minimum' MAC is what you set with dstmac.
 
  pgset "flag [name]"     Set a flag to determine behaviour.  Current flags
-                         are: IPSRC_RND # IP source is random (between min/max)
-                              IPDST_RND # IP destination is random
-                              UDPSRC_RND, UDPDST_RND,
-                              MACSRC_RND, MACDST_RND
-                              TXSIZE_RND, IPV6,
-                              MPLS_RND, VID_RND, SVID_RND
-                              FLOW_SEQ,
-                              QUEUE_MAP_RND # queue map random
-                              QUEUE_MAP_CPU # queue map mirrors smp_processor_id()
-                              UDPCSUM,
-                              IPSEC # IPsec encapsulation (needs CONFIG_XFRM)
-                              NODE_ALLOC # node specific memory allocation
-                              NO_TIMESTAMP # disable timestamping
+			 are: IPSRC_RND # IP source is random (between min/max)
+			      IPDST_RND # IP destination is random
+			      UDPSRC_RND, UDPDST_RND,
+			      MACSRC_RND, MACDST_RND
+			      TXSIZE_RND, IPV6,
+			      MPLS_RND, VID_RND, SVID_RND
+			      FLOW_SEQ,
+			      QUEUE_MAP_RND # queue map random
+			      QUEUE_MAP_CPU # queue map mirrors smp_processor_id()
+			      UDPCSUM,
+			      IPSEC # IPsec encapsulation (needs CONFIG_XFRM)
+			      NODE_ALLOC # node specific memory allocation
+			      NO_TIMESTAMP # disable timestamping
  pgset 'flag ![name]'    Clear a flag to determine behaviour.
-                         Note that you might need to use single quote in
-                         interactive mode, so that your shell wouldn't expand
-                         the specified flag as a history command.
+			 Note that you might need to use single quote in
+			 interactive mode, so that your shell wouldn't expand
+			 the specified flag as a history command.
 
  pgset "spi [SPI_VALUE]" Set specific SA used to transform packet.
 
  pgset "udp_src_min 9"   set UDP source port min, If < udp_src_max, then
-                         cycle through the port range.
+			 cycle through the port range.
 
  pgset "udp_src_max 9"   set UDP source port max.
  pgset "udp_dst_min 9"   set UDP destination port min, If < udp_dst_max, then
-                         cycle through the port range.
+			 cycle through the port range.
  pgset "udp_dst_max 9"   set UDP destination port max.
 
  pgset "mpls 0001000a,0002000a,0000000a" set MPLS labels (in this example
-                                         outer label=16,middle label=32,
+					 outer label=16,middle label=32,
 					 inner label=0 (IPv4 NULL)) Note that
 					 there must be no spaces between the
 					 arguments. Leading zeros are required.
@@ -232,10 +238,14 @@ A collection of tutorial scripts and helpers for pktgen is in the
 samples/pktgen directory. The helper parameters.sh file support easy
 and consistent parameter parsing across the sample scripts.
 
-Usage example and help:
+Usage example and help::
+
  ./pktgen_sample01_simple.sh -i eth4 -m 00:1B:21:3C:9D:F8 -d 192.168.8.2
 
-Usage: ./pktgen_sample01_simple.sh [-vx] -i ethX
+Usage:::
+
+  ./pktgen_sample01_simple.sh [-vx] -i ethX
+
   -i : ($DEV)       output interface/device (required)
   -s : ($PKT_SIZE)  packet size
   -d : ($DEST_IP)   destination IP
@@ -250,13 +260,13 @@ The global variables being set are also listed.  E.g. the required
 interface/device parameter "-i" sets variable $DEV.  Copy the
 pktgen_sampleXX scripts and modify them to fit your own needs.
 
-The old scripts:
+The old scripts::
 
-pktgen.conf-1-2                  # 1 CPU 2 dev
-pktgen.conf-1-1-rdos             # 1 CPU 1 dev w. route DoS 
-pktgen.conf-1-1-ip6              # 1 CPU 1 dev ipv6
-pktgen.conf-1-1-ip6-rdos         # 1 CPU 1 dev ipv6  w. route DoS
-pktgen.conf-1-1-flows            # 1 CPU 1 dev multiple flows.
+    pktgen.conf-1-2                  # 1 CPU 2 dev
+    pktgen.conf-1-1-rdos             # 1 CPU 1 dev w. route DoS
+    pktgen.conf-1-1-ip6              # 1 CPU 1 dev ipv6
+    pktgen.conf-1-1-ip6-rdos         # 1 CPU 1 dev ipv6  w. route DoS
+    pktgen.conf-1-1-flows            # 1 CPU 1 dev multiple flows.
 
 
 Interrupt affinity
@@ -271,10 +281,10 @@ to the running threads CPU (directly from smp_processor_id()).
 Enable IPsec
 ============
 Default IPsec transformation with ESP encapsulation plus transport mode
-can be enabled by simply setting:
+can be enabled by simply setting::
 
-pgset "flag IPSEC"
-pgset "flows 1"
+    pgset "flag IPSEC"
+    pgset "flows 1"
 
 To avoid breaking existing testbed scripts for using AH type and tunnel mode,
 you can use "pgset spi SPI_VALUE" to specify which transformation mode
@@ -284,115 +294,117 @@ to employ.
 Current commands and configuration options
 ==========================================
 
-** Pgcontrol commands:
+**Pgcontrol commands**::
 
-start
-stop
-reset
+    start
+    stop
+    reset
 
-** Thread commands:
+**Thread commands**::
 
-add_device
-rem_device_all
+    add_device
+    rem_device_all
 
 
-** Device commands:
+**Device commands**::
 
-count
-clone_skb
-burst
-debug
+    count
+    clone_skb
+    burst
+    debug
 
-frags
-delay
+    frags
+    delay
 
-src_mac_count
-dst_mac_count
+    src_mac_count
+    dst_mac_count
 
-pkt_size
-min_pkt_size
-max_pkt_size
+    pkt_size
+    min_pkt_size
+    max_pkt_size
 
-queue_map_min
-queue_map_max
-skb_priority
+    queue_map_min
+    queue_map_max
+    skb_priority
 
-tos           (ipv4)
-traffic_class (ipv6)
+    tos           (ipv4)
+    traffic_class (ipv6)
 
-mpls
+    mpls
 
-udp_src_min
-udp_src_max
+    udp_src_min
+    udp_src_max
 
-udp_dst_min
-udp_dst_max
+    udp_dst_min
+    udp_dst_max
 
-node
+    node
 
-flag
-  IPSRC_RND
-  IPDST_RND
-  UDPSRC_RND
-  UDPDST_RND
-  MACSRC_RND
-  MACDST_RND
-  TXSIZE_RND
-  IPV6
-  MPLS_RND
-  VID_RND
-  SVID_RND
-  FLOW_SEQ
-  QUEUE_MAP_RND
-  QUEUE_MAP_CPU
-  UDPCSUM
-  IPSEC
-  NODE_ALLOC
-  NO_TIMESTAMP
+    flag
+    IPSRC_RND
+    IPDST_RND
+    UDPSRC_RND
+    UDPDST_RND
+    MACSRC_RND
+    MACDST_RND
+    TXSIZE_RND
+    IPV6
+    MPLS_RND
+    VID_RND
+    SVID_RND
+    FLOW_SEQ
+    QUEUE_MAP_RND
+    QUEUE_MAP_CPU
+    UDPCSUM
+    IPSEC
+    NODE_ALLOC
+    NO_TIMESTAMP
 
-spi (ipsec)
+    spi (ipsec)
 
-dst_min
-dst_max
+    dst_min
+    dst_max
 
-src_min
-src_max
+    src_min
+    src_max
 
-dst_mac
-src_mac
+    dst_mac
+    src_mac
 
-clear_counters
+    clear_counters
 
-src6
-dst6
-dst6_max
-dst6_min
+    src6
+    dst6
+    dst6_max
+    dst6_min
 
-flows
-flowlen
+    flows
+    flowlen
 
-rate
-ratep
+    rate
+    ratep
 
-xmit_mode <start_xmit|netif_receive>
+    xmit_mode <start_xmit|netif_receive>
 
-vlan_cfi
-vlan_id
-vlan_p
+    vlan_cfi
+    vlan_id
+    vlan_p
 
-svlan_cfi
-svlan_id
-svlan_p
+    svlan_cfi
+    svlan_id
+    svlan_p
 
 
 References:
-ftp://robur.slu.se/pub/Linux/net-development/pktgen-testing/
-ftp://robur.slu.se/pub/Linux/net-development/pktgen-testing/examples/
+
+- ftp://robur.slu.se/pub/Linux/net-development/pktgen-testing/
+- tp://robur.slu.se/pub/Linux/net-development/pktgen-testing/examples/
 
 Paper from Linux-Kongress in Erlangen 2004.
-ftp://robur.slu.se/pub/Linux/net-development/pktgen-testing/pktgen_paper.pdf
+- ftp://robur.slu.se/pub/Linux/net-development/pktgen-testing/pktgen_paper.pdf
 
 Thanks to:
+
 Grant Grundler for testing on IA-64 and parisc, Harald Welte,  Lennert Buytenhek
 Stephen Hemminger, Andi Kleen, Dave Miller and many others.
 
diff --git a/net/Kconfig b/net/Kconfig
index 8b1f85820a6b..c5ba2d180c43 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -344,7 +344,7 @@ config NET_PKTGEN
 	  what was just said, you don't need it: say N.
 
 	  Documentation on how to use the packet generator can be found
-	  at <file:Documentation/networking/pktgen.txt>.
+	  at <file:Documentation/networking/pktgen.rst>.
 
 	  To compile this code as a module, choose M here: the
 	  module will be called pktgen.
diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index 08e2811b5274..b53b6d38c4df 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -56,7 +56,7 @@
  * Integrated to 2.5.x 021029 --Lucio Maciel (luciomaciel@zipmail.com.br)
  *
  * 021124 Finished major redesign and rewrite for new functionality.
- * See Documentation/networking/pktgen.txt for how to use this.
+ * See Documentation/networking/pktgen.rst for how to use this.
  *
  * The new operation:
  * For each CPU one thread/process is created at start. This process checks
diff --git a/samples/pktgen/README.rst b/samples/pktgen/README.rst
index 3f6483e8b2df..f9c53ca5cf93 100644
--- a/samples/pktgen/README.rst
+++ b/samples/pktgen/README.rst
@@ -3,7 +3,7 @@ Sample and benchmark scripts for pktgen (packet generator)
 This directory contains some pktgen sample and benchmark scripts, that
 can easily be copied and adjusted for your own use-case.
 
-General doc is located in kernel: Documentation/networking/pktgen.txt
+General doc is located in kernel: Documentation/networking/pktgen.rst
 
 Helper include files
 ====================
-- 
2.25.4

