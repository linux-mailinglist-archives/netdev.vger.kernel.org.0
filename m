Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE77B2BC5
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 17:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbfINPOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Sep 2019 11:14:01 -0400
Received: from mail-pg1-f171.google.com ([209.85.215.171]:42938 "EHLO
        mail-pg1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfINPOB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Sep 2019 11:14:01 -0400
Received: by mail-pg1-f171.google.com with SMTP id z12so5312128pgp.9
        for <netdev@vger.kernel.org>; Sat, 14 Sep 2019 08:14:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fmZmV3LEoKBavBhh1/wXQDTwcMfXci2KTIW/ghlrL/I=;
        b=tfmioC/+6P8L7rAwHZWzqbrIThNrVARMuIOg2Ybk8XneXm7xqOaJzCKQ6DjOBovGVK
         Xo3qMv4CBxzKUzLV/IOmlUCi4TEUKmOww2zbcGse3cpjFLUZefwi2o80pdJaQqNCfsFW
         jMtuQz0maEB02O6hmpPbjtYOMe9x6CjnoPNloBImf0ZNJhi7knspCGRttG3xkFRoHtL6
         pTIz/sU/SCKwcxYPWqVT2Qsnak6MuZSyS9xmV1fdSA93VmNIMhXh2ddxwZZDs+MmdTJL
         wiWTVHc8RdSghXuJ6Ye5EPxk+6vv7C4675d2Lfdnh2latDXlNG8lUGkbytnm0E+Kh44b
         Kaqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fmZmV3LEoKBavBhh1/wXQDTwcMfXci2KTIW/ghlrL/I=;
        b=bwXlMEsO8ijp6kMW8eLciNtOoBo3IO5LOocornE+7BVPeCgtE8T+Jhn5lzgkgF7Vco
         7qLd337MWwyC/p1U5+KWdxgnumQE6eYEPz17Zybnbr/98EXmHOl7bndG5kVS3vFzifol
         C0ivnW2Y8Wn9IjmyxSVoJnMPLbMzSfaU+t8tWTJJXPPeJU3qF4wQ1a8TRqZYplVcGeW5
         2usSN+t2b3iSwRq/QPbOY8m3s0lvhadVdPJ6rDLIs5/1MLRISH4kfo5jrLsoHKn5rUxh
         OerIbnHp3h8CbdTZw2CMbfMxaE4DQPV6qVN+Y84D+7hoC5cYAjEO0oF0sgiuUSnK5knj
         4IzQ==
X-Gm-Message-State: APjAAAUvjCsYLxW0NEEhVQrfEKHWEe2U/c7TR1k9PKS2C697uYtsnCC4
        kdYimkBQGdFe0f3ifCcK5ded4g4=
X-Google-Smtp-Source: APXvYqyS14HcXlSenP9lV1fkK4vvjowdWurYSsgiDeBjiLv3A78QpVbzz7ZZVsIgG1zDEE+OrheRYw==
X-Received: by 2002:a63:c008:: with SMTP id h8mr49761893pgg.427.1568474040491;
        Sat, 14 Sep 2019 08:14:00 -0700 (PDT)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id u69sm28408689pgu.77.2019.09.14.08.13.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Sep 2019 08:14:00 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Subject: [v3 1/3] samples: pktgen: make variable consistent with option
Date:   Sun, 15 Sep 2019 00:13:51 +0900
Message-Id: <20190914151353.18054-1-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit changes variable names that can cause confusion.

For example, variable DST_MIN is quite confusing since the
keyword 'udp_dst_min' and keyword 'dst_min' is used with pg_ctrl.

On the following commit, 'dst_min' will be used to set destination IP,
and the existing variable name DST_MIN should be changed.

Variable names are matched to the exact keyword used with pg_ctrl.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 .../pktgen_bench_xmit_mode_netif_receive.sh      |  8 ++++----
 .../pktgen/pktgen_bench_xmit_mode_queue_xmit.sh  |  8 ++++----
 samples/pktgen/pktgen_sample01_simple.sh         | 16 ++++++++--------
 samples/pktgen/pktgen_sample02_multiqueue.sh     | 16 ++++++++--------
 .../pktgen/pktgen_sample03_burst_single_flow.sh  |  8 ++++----
 samples/pktgen/pktgen_sample04_many_flows.sh     |  8 ++++----
 .../pktgen/pktgen_sample05_flow_per_thread.sh    |  8 ++++----
 ...en_sample06_numa_awared_queue_irq_affinity.sh | 16 ++++++++--------
 8 files changed, 44 insertions(+), 44 deletions(-)

diff --git a/samples/pktgen/pktgen_bench_xmit_mode_netif_receive.sh b/samples/pktgen/pktgen_bench_xmit_mode_netif_receive.sh
index e14b1a9144d9..9b74502c58f7 100755
--- a/samples/pktgen/pktgen_bench_xmit_mode_netif_receive.sh
+++ b/samples/pktgen/pktgen_bench_xmit_mode_netif_receive.sh
@@ -42,8 +42,8 @@ fi
 [ -z "$BURST" ] && BURST=1024
 [ -z "$COUNT" ] && COUNT="10000000" # Zero means indefinitely
 if [ -n "$DST_PORT" ]; then
-    read -r DST_MIN DST_MAX <<< $(parse_ports $DST_PORT)
-    validate_ports $DST_MIN $DST_MAX
+    read -r UDP_DST_MIN UDP_DST_MAX <<< $(parse_ports $DST_PORT)
+    validate_ports $UDP_DST_MIN $UDP_DST_MAX
 fi
 
 # Base Config
@@ -76,8 +76,8 @@ for ((thread = $F_THREAD; thread <= $L_THREAD; thread++)); do
     if [ -n "$DST_PORT" ]; then
 	# Single destination port or random port range
 	pg_set $dev "flag UDPDST_RND"
-	pg_set $dev "udp_dst_min $DST_MIN"
-	pg_set $dev "udp_dst_max $DST_MAX"
+	pg_set $dev "udp_dst_min $UDP_DST_MIN"
+	pg_set $dev "udp_dst_max $UDP_DST_MAX"
     fi
 
     # Inject packet into RX path of stack
diff --git a/samples/pktgen/pktgen_bench_xmit_mode_queue_xmit.sh b/samples/pktgen/pktgen_bench_xmit_mode_queue_xmit.sh
index 82c3e504e056..0f332555b40d 100755
--- a/samples/pktgen/pktgen_bench_xmit_mode_queue_xmit.sh
+++ b/samples/pktgen/pktgen_bench_xmit_mode_queue_xmit.sh
@@ -25,8 +25,8 @@ if [[ -n "$BURST" ]]; then
 fi
 [ -z "$COUNT" ] && COUNT="10000000" # Zero means indefinitely
 if [ -n "$DST_PORT" ]; then
-    read -r DST_MIN DST_MAX <<< $(parse_ports $DST_PORT)
-    validate_ports $DST_MIN $DST_MAX
+    read -r UDP_DST_MIN UDP_DST_MAX <<< $(parse_ports $DST_PORT)
+    validate_ports $UDP_DST_MIN $UDP_DST_MAX
 fi
 
 # Base Config
@@ -59,8 +59,8 @@ for ((thread = $F_THREAD; thread <= $L_THREAD; thread++)); do
     if [ -n "$DST_PORT" ]; then
 	# Single destination port or random port range
 	pg_set $dev "flag UDPDST_RND"
-	pg_set $dev "udp_dst_min $DST_MIN"
-	pg_set $dev "udp_dst_max $DST_MAX"
+	pg_set $dev "udp_dst_min $UDP_DST_MIN"
+	pg_set $dev "udp_dst_max $UDP_DST_MAX"
     fi
 
     # Inject packet into TX qdisc egress path of stack
diff --git a/samples/pktgen/pktgen_sample01_simple.sh b/samples/pktgen/pktgen_sample01_simple.sh
index d1702fdde8f3..063ec0998906 100755
--- a/samples/pktgen/pktgen_sample01_simple.sh
+++ b/samples/pktgen/pktgen_sample01_simple.sh
@@ -23,16 +23,16 @@ fi
 [ -z "$DST_MAC" ] && usage && err 2 "Must specify -m dst_mac"
 [ -z "$COUNT" ]   && COUNT="100000" # Zero means indefinitely
 if [ -n "$DST_PORT" ]; then
-    read -r DST_MIN DST_MAX <<< $(parse_ports $DST_PORT)
-    validate_ports $DST_MIN $DST_MAX
+    read -r UDP_DST_MIN UDP_DST_MAX <<< $(parse_ports $DST_PORT)
+    validate_ports $UDP_DST_MIN $UDP_DST_MAX
 fi
 
 # Base Config
 DELAY="0"        # Zero means max speed
 
 # Flow variation random source port between min and max
-UDP_MIN=9
-UDP_MAX=109
+UDP_SRC_MIN=9
+UDP_SRC_MAX=109
 
 # General cleanup everything since last run
 # (especially important if other threads were configured by other scripts)
@@ -66,14 +66,14 @@ pg_set $DEV "dst$IP6 $DEST_IP"
 if [ -n "$DST_PORT" ]; then
     # Single destination port or random port range
     pg_set $DEV "flag UDPDST_RND"
-    pg_set $DEV "udp_dst_min $DST_MIN"
-    pg_set $DEV "udp_dst_max $DST_MAX"
+    pg_set $DEV "udp_dst_min $UDP_DST_MIN"
+    pg_set $DEV "udp_dst_max $UDP_DST_MAX"
 fi
 
 # Setup random UDP port src range
 pg_set $DEV "flag UDPSRC_RND"
-pg_set $DEV "udp_src_min $UDP_MIN"
-pg_set $DEV "udp_src_max $UDP_MAX"
+pg_set $DEV "udp_src_min $UDP_SRC_MIN"
+pg_set $DEV "udp_src_max $UDP_SRC_MAX"
 
 # start_run
 echo "Running... ctrl^C to stop" >&2
diff --git a/samples/pktgen/pktgen_sample02_multiqueue.sh b/samples/pktgen/pktgen_sample02_multiqueue.sh
index 7f7a9a27548f..a4726fb50197 100755
--- a/samples/pktgen/pktgen_sample02_multiqueue.sh
+++ b/samples/pktgen/pktgen_sample02_multiqueue.sh
@@ -21,8 +21,8 @@ DELAY="0"        # Zero means max speed
 [ -z "$CLONE_SKB" ] && CLONE_SKB="0"
 
 # Flow variation random source port between min and max
-UDP_MIN=9
-UDP_MAX=109
+UDP_SRC_MIN=9
+UDP_SRC_MAX=109
 
 # (example of setting default params in your script)
 if [ -z "$DEST_IP" ]; then
@@ -30,8 +30,8 @@ if [ -z "$DEST_IP" ]; then
 fi
 [ -z "$DST_MAC" ] && DST_MAC="90:e2:ba:ff:ff:ff"
 if [ -n "$DST_PORT" ]; then
-    read -r DST_MIN DST_MAX <<< $(parse_ports $DST_PORT)
-    validate_ports $DST_MIN $DST_MAX
+    read -r UDP_DST_MIN UDP_DST_MAX <<< $(parse_ports $DST_PORT)
+    validate_ports $UDP_DST_MIN $UDP_DST_MAX
 fi
 
 # General cleanup everything since last run
@@ -67,14 +67,14 @@ for ((thread = $F_THREAD; thread <= $L_THREAD; thread++)); do
     if [ -n "$DST_PORT" ]; then
 	# Single destination port or random port range
 	pg_set $dev "flag UDPDST_RND"
-	pg_set $dev "udp_dst_min $DST_MIN"
-	pg_set $dev "udp_dst_max $DST_MAX"
+	pg_set $dev "udp_dst_min $UDP_DST_MIN"
+	pg_set $dev "udp_dst_max $UDP_DST_MAX"
     fi
 
     # Setup random UDP port src range
     pg_set $dev "flag UDPSRC_RND"
-    pg_set $dev "udp_src_min $UDP_MIN"
-    pg_set $dev "udp_src_max $UDP_MAX"
+    pg_set $dev "udp_src_min $UDP_SRC_MIN"
+    pg_set $dev "udp_src_max $UDP_SRC_MAX"
 done
 
 # start_run
diff --git a/samples/pktgen/pktgen_sample03_burst_single_flow.sh b/samples/pktgen/pktgen_sample03_burst_single_flow.sh
index b520637817ce..dfea91a09ccc 100755
--- a/samples/pktgen/pktgen_sample03_burst_single_flow.sh
+++ b/samples/pktgen/pktgen_sample03_burst_single_flow.sh
@@ -34,8 +34,8 @@ fi
 [ -z "$CLONE_SKB" ] && CLONE_SKB="0" # No need for clones when bursting
 [ -z "$COUNT" ]     && COUNT="0" # Zero means indefinitely
 if [ -n "$DST_PORT" ]; then
-    read -r DST_MIN DST_MAX <<< $(parse_ports $DST_PORT)
-    validate_ports $DST_MIN $DST_MAX
+    read -r UDP_DST_MIN UDP_DST_MAX <<< $(parse_ports $DST_PORT)
+    validate_ports $UDP_DST_MIN $UDP_DST_MAX
 fi
 
 # Base Config
@@ -67,8 +67,8 @@ for ((thread = $F_THREAD; thread <= $L_THREAD; thread++)); do
     if [ -n "$DST_PORT" ]; then
 	# Single destination port or random port range
 	pg_set $dev "flag UDPDST_RND"
-	pg_set $dev "udp_dst_min $DST_MIN"
-	pg_set $dev "udp_dst_max $DST_MAX"
+	pg_set $dev "udp_dst_min $UDP_DST_MIN"
+	pg_set $dev "udp_dst_max $UDP_DST_MAX"
     fi
 
     # Setup burst, for easy testing -b 0 disable bursting
diff --git a/samples/pktgen/pktgen_sample04_many_flows.sh b/samples/pktgen/pktgen_sample04_many_flows.sh
index 5b6e9d9cb5b5..7ea9b4a3acf6 100755
--- a/samples/pktgen/pktgen_sample04_many_flows.sh
+++ b/samples/pktgen/pktgen_sample04_many_flows.sh
@@ -18,8 +18,8 @@ source ${basedir}/parameters.sh
 [ -z "$CLONE_SKB" ] && CLONE_SKB="0"
 [ -z "$COUNT" ]     && COUNT="0" # Zero means indefinitely
 if [ -n "$DST_PORT" ]; then
-    read -r DST_MIN DST_MAX <<< $(parse_ports $DST_PORT)
-    validate_ports $DST_MIN $DST_MAX
+    read -r UDP_DST_MIN UDP_DST_MAX <<< $(parse_ports $DST_PORT)
+    validate_ports $UDP_DST_MIN $UDP_DST_MAX
 fi
 
 # NOTICE:  Script specific settings
@@ -63,8 +63,8 @@ for ((thread = $F_THREAD; thread <= $L_THREAD; thread++)); do
     if [ -n "$DST_PORT" ]; then
 	# Single destination port or random port range
 	pg_set $dev "flag UDPDST_RND"
-	pg_set $dev "udp_dst_min $DST_MIN"
-	pg_set $dev "udp_dst_max $DST_MAX"
+	pg_set $dev "udp_dst_min $UDP_DST_MIN"
+	pg_set $dev "udp_dst_max $UDP_DST_MAX"
     fi
 
     # Randomize source IP-addresses
diff --git a/samples/pktgen/pktgen_sample05_flow_per_thread.sh b/samples/pktgen/pktgen_sample05_flow_per_thread.sh
index 0c06e63fbe97..fbfafe029e11 100755
--- a/samples/pktgen/pktgen_sample05_flow_per_thread.sh
+++ b/samples/pktgen/pktgen_sample05_flow_per_thread.sh
@@ -23,8 +23,8 @@ source ${basedir}/parameters.sh
 [ -z "$BURST" ]     && BURST=32
 [ -z "$COUNT" ]     && COUNT="0" # Zero means indefinitely
 if [ -n "$DST_PORT" ]; then
-    read -r DST_MIN DST_MAX <<< $(parse_ports $DST_PORT)
-    validate_ports $DST_MIN $DST_MAX
+    read -r UDP_DST_MIN UDP_DST_MAX <<< $(parse_ports $DST_PORT)
+    validate_ports $UDP_DST_MIN $UDP_DST_MAX
 fi
 
 # Base Config
@@ -56,8 +56,8 @@ for ((thread = $F_THREAD; thread <= $L_THREAD; thread++)); do
     if [ -n "$DST_PORT" ]; then
 	# Single destination port or random port range
 	pg_set $dev "flag UDPDST_RND"
-	pg_set $dev "udp_dst_min $DST_MIN"
-	pg_set $dev "udp_dst_max $DST_MAX"
+	pg_set $dev "udp_dst_min $UDP_DST_MIN"
+	pg_set $dev "udp_dst_max $UDP_DST_MAX"
     fi
 
     # Setup source IP-addresses based on thread number
diff --git a/samples/pktgen/pktgen_sample06_numa_awared_queue_irq_affinity.sh b/samples/pktgen/pktgen_sample06_numa_awared_queue_irq_affinity.sh
index 97f0266c0356..755e662183f1 100755
--- a/samples/pktgen/pktgen_sample06_numa_awared_queue_irq_affinity.sh
+++ b/samples/pktgen/pktgen_sample06_numa_awared_queue_irq_affinity.sh
@@ -20,8 +20,8 @@ DELAY="0"        # Zero means max speed
 [ -z "$CLONE_SKB" ] && CLONE_SKB="0"
 
 # Flow variation random source port between min and max
-UDP_MIN=9
-UDP_MAX=109
+UDP_SRC_MIN=9
+UDP_SRC_MAX=109
 
 node=`get_iface_node $DEV`
 irq_array=(`get_iface_irqs $DEV`)
@@ -36,8 +36,8 @@ if [ -z "$DEST_IP" ]; then
 fi
 [ -z "$DST_MAC" ] && DST_MAC="90:e2:ba:ff:ff:ff"
 if [ -n "$DST_PORT" ]; then
-    read -r DST_MIN DST_MAX <<< $(parse_ports $DST_PORT)
-    validate_ports $DST_MIN $DST_MAX
+    read -r UDP_DST_MIN UDP_DST_MAX <<< $(parse_ports $DST_PORT)
+    validate_ports $UDP_DST_MIN $UDP_DST_MAX
 fi
 
 # General cleanup everything since last run
@@ -84,14 +84,14 @@ for ((i = 0; i < $THREADS; i++)); do
     if [ -n "$DST_PORT" ]; then
 	# Single destination port or random port range
 	pg_set $dev "flag UDPDST_RND"
-	pg_set $dev "udp_dst_min $DST_MIN"
-	pg_set $dev "udp_dst_max $DST_MAX"
+	pg_set $dev "udp_dst_min $UDP_DST_MIN"
+	pg_set $dev "udp_dst_max $UDP_DST_MAX"
     fi
 
     # Setup random UDP port src range
     pg_set $dev "flag UDPSRC_RND"
-    pg_set $dev "udp_src_min $UDP_MIN"
-    pg_set $dev "udp_src_max $UDP_MAX"
+    pg_set $dev "udp_src_min $UDP_SRC_MIN"
+    pg_set $dev "udp_src_max $UDP_SRC_MAX"
 done
 
 # start_run
-- 
2.20.1

