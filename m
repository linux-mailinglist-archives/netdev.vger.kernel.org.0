Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 748415AB96
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 15:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbfF2NeL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 09:34:11 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38634 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726785AbfF2NeK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jun 2019 09:34:10 -0400
Received: by mail-pf1-f194.google.com with SMTP id y15so4352510pfn.5
        for <netdev@vger.kernel.org>; Sat, 29 Jun 2019 06:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=B2aD0yS+yUjpaLgPrvkMMNviQ5TxjpjXAuiN4rCpeuI=;
        b=VY6R4S5PPu5JS3HTrJ9fEGQTXAD1mBzr2SEAc09QO/VWtpvSrmQPtrPlRenA4/5klm
         ZF7IfNG5Bjaot8NrtSCrhZTaT9JJ1lQx/50mV0Dmo51TK+G+8t3rRaMtsm31zK4e5fEu
         r+kWLzD46NYA4QYWDuN+Q7ng0GJFlD7862IeHnvRa1I3cN17Qf3c9xuw5ajkrOFBhU0x
         0gbNlCV82dzCfbMDHwCLmcBvj3yipFmr6U6lqBVxuzWICOFxlmAh4xZ3Y62nHNHu21hu
         uRKRFVDq1aDAwrNl6prTobAkfxa3zmtQAo0vdPIu5nTr78q8VcN0CULj54fHc6gwpkpq
         vM/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=B2aD0yS+yUjpaLgPrvkMMNviQ5TxjpjXAuiN4rCpeuI=;
        b=exdqTFnUVA18yJ2ZbbxBq47FHp+2bBd+wH44ekL0yfCWYJUYoiJ0DP8T8L9IUlmIsp
         HCv9laqgb5KCJsnjKsdw26zCAcjTKrfKv2ePfm3y2VADwizXtdGBwueE05t0QfdkXzA3
         PDjHj2ABtwTTTKb/+QXIF9JxiVdyc7r6ZOicw/XDyxfUEdR1KKCr5n+tRIIVpvHXeIAX
         T59EwStGu+ebqKPvJjNoKnIrpRVY3yheESIcXKfc/dkmdpJGOpCQ5mq2kz5gbumD3Qnr
         0d5DAJEwHuwRmsok58aqX6FVKx+6F3hKEa/wm6JyuhYcTqav8wiSx6lhj/dgmKgqTac7
         +NKg==
X-Gm-Message-State: APjAAAUI07sFoIoJclOufVK0i3NPM+RZHL3em0PZnqfbOGIWlRRChxw/
        rtz13CvRC8x76TNiSunWCTU+7pT2FA==
X-Google-Smtp-Source: APXvYqx7vQcXVFxPTt9BZpOneFRebt7ABMbi8obJdLkDFMYuXRP7T5XNT4KClxPZW3G8hYV5kjMiVQ==
X-Received: by 2002:a63:360d:: with SMTP id d13mr5343053pga.80.1561815249830;
        Sat, 29 Jun 2019 06:34:09 -0700 (PDT)
Received: from localhost.localdomain ([58.76.163.19])
        by smtp.gmail.com with ESMTPSA id d9sm4686148pgj.34.2019.06.29.06.34.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 29 Jun 2019 06:34:09 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Subject: [PATCH 2/2] samples: pktgen: allow to specify destination port
Date:   Sat, 29 Jun 2019 22:33:58 +0900
Message-Id: <20190629133358.8251-2-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190629133358.8251-1-danieltimlee@gmail.com>
References: <20190629133358.8251-1-danieltimlee@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, kernel pktgen has the feature to specify udp destination port
for sending packet. (e.g. pgset "udp_dst_min 9")

But on samples, each of the scripts doesn't have any option to achieve this.

This commit adds the DST_PORT option to specify the target port(s) in the script.

    -p : ($DST_PORT)  destination PORT range (e.g. 433-444) is also allowed

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 samples/pktgen/README.rst                            |  1 +
 samples/pktgen/parameters.sh                         |  7 ++++++-
 .../pktgen/pktgen_bench_xmit_mode_netif_receive.sh   | 11 +++++++++++
 samples/pktgen/pktgen_bench_xmit_mode_queue_xmit.sh  | 11 +++++++++++
 samples/pktgen/pktgen_sample01_simple.sh             | 11 +++++++++++
 samples/pktgen/pktgen_sample02_multiqueue.sh         | 11 +++++++++++
 samples/pktgen/pktgen_sample03_burst_single_flow.sh  | 11 +++++++++++
 samples/pktgen/pktgen_sample04_many_flows.sh         | 11 +++++++++++
 samples/pktgen/pktgen_sample05_flow_per_thread.sh    | 12 +++++++++++-
 ...pktgen_sample06_numa_awared_queue_irq_affinity.sh | 11 +++++++++++
 10 files changed, 95 insertions(+), 2 deletions(-)

diff --git a/samples/pktgen/README.rst b/samples/pktgen/README.rst
index ff8929da61c5..fd39215db508 100644
--- a/samples/pktgen/README.rst
+++ b/samples/pktgen/README.rst
@@ -20,6 +20,7 @@ across the sample scripts.  Usage example is printed on errors::
   -s : ($PKT_SIZE)  packet size
   -d : ($DEST_IP)   destination IP
   -m : ($DST_MAC)   destination MAC-addr
+  -p : ($DST_PORT)  destination PORT range (e.g. 433-444) is also allowed
   -t : ($THREADS)   threads to start
   -f : ($F_THREAD)  index of first thread (zero indexed CPU number)
   -c : ($SKB_CLONE) SKB clones send before alloc new SKB
diff --git a/samples/pktgen/parameters.sh b/samples/pktgen/parameters.sh
index 72fc562876e2..a06b00a0c7b6 100644
--- a/samples/pktgen/parameters.sh
+++ b/samples/pktgen/parameters.sh
@@ -10,6 +10,7 @@ function usage() {
     echo "  -s : (\$PKT_SIZE)  packet size"
     echo "  -d : (\$DEST_IP)   destination IP"
     echo "  -m : (\$DST_MAC)   destination MAC-addr"
+    echo "  -p : (\$DST_PORT)  destination PORT range (e.g. 433-444) is also allowed"
     echo "  -t : (\$THREADS)   threads to start"
     echo "  -f : (\$F_THREAD)  index of first thread (zero indexed CPU number)"
     echo "  -c : (\$SKB_CLONE) SKB clones send before alloc new SKB"
@@ -23,7 +24,7 @@ function usage() {
 
 ##  --- Parse command line arguments / parameters ---
 ## echo "Commandline options:"
-while getopts "s:i:d:m:f:t:c:n:b:vxh6" option; do
+while getopts "s:i:d:m:p:f:t:c:n:b:vxh6" option; do
     case $option in
         i) # interface
           export DEV=$OPTARG
@@ -41,6 +42,10 @@ while getopts "s:i:d:m:f:t:c:n:b:vxh6" option; do
           export DST_MAC=$OPTARG
 	  info "Destination MAC set to: DST_MAC=$DST_MAC"
           ;;
+        p) # PORT
+          export DST_PORT=$OPTARG
+	  info "Destination PORT set to: DST_PORT=$DST_PORT"
+          ;;
         f)
 	  export F_THREAD=$OPTARG
 	  info "Index of first thread (zero indexed CPU number): $F_THREAD"
diff --git a/samples/pktgen/pktgen_bench_xmit_mode_netif_receive.sh b/samples/pktgen/pktgen_bench_xmit_mode_netif_receive.sh
index 2839f7d315cf..e14b1a9144d9 100755
--- a/samples/pktgen/pktgen_bench_xmit_mode_netif_receive.sh
+++ b/samples/pktgen/pktgen_bench_xmit_mode_netif_receive.sh
@@ -41,6 +41,10 @@ fi
 [ -z "$DST_MAC" ] && DST_MAC="90:e2:ba:ff:ff:ff"
 [ -z "$BURST" ] && BURST=1024
 [ -z "$COUNT" ] && COUNT="10000000" # Zero means indefinitely
+if [ -n "$DST_PORT" ]; then
+    read -r DST_MIN DST_MAX <<< $(parse_ports $DST_PORT)
+    validate_ports $DST_MIN $DST_MAX
+fi
 
 # Base Config
 DELAY="0"        # Zero means max speed
@@ -69,6 +73,13 @@ for ((thread = $F_THREAD; thread <= $L_THREAD; thread++)); do
     pg_set $dev "dst_mac $DST_MAC"
     pg_set $dev "dst$IP6 $DEST_IP"
 
+    if [ -n "$DST_PORT" ]; then
+	# Single destination port or random port range
+	pg_set $dev "flag UDPDST_RND"
+	pg_set $dev "udp_dst_min $DST_MIN"
+	pg_set $dev "udp_dst_max $DST_MAX"
+    fi
+
     # Inject packet into RX path of stack
     pg_set $dev "xmit_mode netif_receive"
 
diff --git a/samples/pktgen/pktgen_bench_xmit_mode_queue_xmit.sh b/samples/pktgen/pktgen_bench_xmit_mode_queue_xmit.sh
index e1ee54465def..82c3e504e056 100755
--- a/samples/pktgen/pktgen_bench_xmit_mode_queue_xmit.sh
+++ b/samples/pktgen/pktgen_bench_xmit_mode_queue_xmit.sh
@@ -24,6 +24,10 @@ if [[ -n "$BURST" ]]; then
     err 1 "Bursting not supported for this mode"
 fi
 [ -z "$COUNT" ] && COUNT="10000000" # Zero means indefinitely
+if [ -n "$DST_PORT" ]; then
+    read -r DST_MIN DST_MAX <<< $(parse_ports $DST_PORT)
+    validate_ports $DST_MIN $DST_MAX
+fi
 
 # Base Config
 DELAY="0"        # Zero means max speed
@@ -52,6 +56,13 @@ for ((thread = $F_THREAD; thread <= $L_THREAD; thread++)); do
     pg_set $dev "dst_mac $DST_MAC"
     pg_set $dev "dst$IP6 $DEST_IP"
 
+    if [ -n "$DST_PORT" ]; then
+	# Single destination port or random port range
+	pg_set $dev "flag UDPDST_RND"
+	pg_set $dev "udp_dst_min $DST_MIN"
+	pg_set $dev "udp_dst_max $DST_MAX"
+    fi
+
     # Inject packet into TX qdisc egress path of stack
     pg_set $dev "xmit_mode queue_xmit"
 done
diff --git a/samples/pktgen/pktgen_sample01_simple.sh b/samples/pktgen/pktgen_sample01_simple.sh
index e9ab4edba2d7..d1702fdde8f3 100755
--- a/samples/pktgen/pktgen_sample01_simple.sh
+++ b/samples/pktgen/pktgen_sample01_simple.sh
@@ -22,6 +22,10 @@ fi
 # Example enforce param "-m" for dst_mac
 [ -z "$DST_MAC" ] && usage && err 2 "Must specify -m dst_mac"
 [ -z "$COUNT" ]   && COUNT="100000" # Zero means indefinitely
+if [ -n "$DST_PORT" ]; then
+    read -r DST_MIN DST_MAX <<< $(parse_ports $DST_PORT)
+    validate_ports $DST_MIN $DST_MAX
+fi
 
 # Base Config
 DELAY="0"        # Zero means max speed
@@ -59,6 +63,13 @@ pg_set $DEV "flag NO_TIMESTAMP"
 pg_set $DEV "dst_mac $DST_MAC"
 pg_set $DEV "dst$IP6 $DEST_IP"
 
+if [ -n "$DST_PORT" ]; then
+    # Single destination port or random port range
+    pg_set $DEV "flag UDPDST_RND"
+    pg_set $DEV "udp_dst_min $DST_MIN"
+    pg_set $DEV "udp_dst_max $DST_MAX"
+fi
+
 # Setup random UDP port src range
 pg_set $DEV "flag UDPSRC_RND"
 pg_set $DEV "udp_src_min $UDP_MIN"
diff --git a/samples/pktgen/pktgen_sample02_multiqueue.sh b/samples/pktgen/pktgen_sample02_multiqueue.sh
index 99f740ae9857..7f7a9a27548f 100755
--- a/samples/pktgen/pktgen_sample02_multiqueue.sh
+++ b/samples/pktgen/pktgen_sample02_multiqueue.sh
@@ -29,6 +29,10 @@ if [ -z "$DEST_IP" ]; then
     [ -z "$IP6" ] && DEST_IP="198.18.0.42" || DEST_IP="FD00::1"
 fi
 [ -z "$DST_MAC" ] && DST_MAC="90:e2:ba:ff:ff:ff"
+if [ -n "$DST_PORT" ]; then
+    read -r DST_MIN DST_MAX <<< $(parse_ports $DST_PORT)
+    validate_ports $DST_MIN $DST_MAX
+fi
 
 # General cleanup everything since last run
 pg_ctrl "reset"
@@ -60,6 +64,13 @@ for ((thread = $F_THREAD; thread <= $L_THREAD; thread++)); do
     pg_set $dev "dst_mac $DST_MAC"
     pg_set $dev "dst$IP6 $DEST_IP"
 
+    if [ -n "$DST_PORT" ]; then
+	# Single destination port or random port range
+	pg_set $dev "flag UDPDST_RND"
+	pg_set $dev "udp_dst_min $DST_MIN"
+	pg_set $dev "udp_dst_max $DST_MAX"
+    fi
+
     # Setup random UDP port src range
     pg_set $dev "flag UDPSRC_RND"
     pg_set $dev "udp_src_min $UDP_MIN"
diff --git a/samples/pktgen/pktgen_sample03_burst_single_flow.sh b/samples/pktgen/pktgen_sample03_burst_single_flow.sh
index 8fdd36722d9e..b520637817ce 100755
--- a/samples/pktgen/pktgen_sample03_burst_single_flow.sh
+++ b/samples/pktgen/pktgen_sample03_burst_single_flow.sh
@@ -33,6 +33,10 @@ fi
 [ -z "$BURST" ]     && BURST=32
 [ -z "$CLONE_SKB" ] && CLONE_SKB="0" # No need for clones when bursting
 [ -z "$COUNT" ]     && COUNT="0" # Zero means indefinitely
+if [ -n "$DST_PORT" ]; then
+    read -r DST_MIN DST_MAX <<< $(parse_ports $DST_PORT)
+    validate_ports $DST_MIN $DST_MAX
+fi
 
 # Base Config
 DELAY="0"  # Zero means max speed
@@ -60,6 +64,13 @@ for ((thread = $F_THREAD; thread <= $L_THREAD; thread++)); do
     pg_set $dev "dst_mac $DST_MAC"
     pg_set $dev "dst$IP6 $DEST_IP"
 
+    if [ -n "$DST_PORT" ]; then
+	# Single destination port or random port range
+	pg_set $dev "flag UDPDST_RND"
+	pg_set $dev "udp_dst_min $DST_MIN"
+	pg_set $dev "udp_dst_max $DST_MAX"
+    fi
+
     # Setup burst, for easy testing -b 0 disable bursting
     # (internally in pktgen default and minimum burst=1)
     if [[ ${BURST} -ne 0 ]]; then
diff --git a/samples/pktgen/pktgen_sample04_many_flows.sh b/samples/pktgen/pktgen_sample04_many_flows.sh
index 4df92b7176da..5b6e9d9cb5b5 100755
--- a/samples/pktgen/pktgen_sample04_many_flows.sh
+++ b/samples/pktgen/pktgen_sample04_many_flows.sh
@@ -17,6 +17,10 @@ source ${basedir}/parameters.sh
 [ -z "$DST_MAC" ]   && DST_MAC="90:e2:ba:ff:ff:ff"
 [ -z "$CLONE_SKB" ] && CLONE_SKB="0"
 [ -z "$COUNT" ]     && COUNT="0" # Zero means indefinitely
+if [ -n "$DST_PORT" ]; then
+    read -r DST_MIN DST_MAX <<< $(parse_ports $DST_PORT)
+    validate_ports $DST_MIN $DST_MAX
+fi
 
 # NOTICE:  Script specific settings
 # =======
@@ -56,6 +60,13 @@ for ((thread = $F_THREAD; thread <= $L_THREAD; thread++)); do
     pg_set $dev "dst_mac $DST_MAC"
     pg_set $dev "dst $DEST_IP"
 
+    if [ -n "$DST_PORT" ]; then
+	# Single destination port or random port range
+	pg_set $dev "flag UDPDST_RND"
+	pg_set $dev "udp_dst_min $DST_MIN"
+	pg_set $dev "udp_dst_max $DST_MAX"
+    fi
+
     # Randomize source IP-addresses
     pg_set $dev "flag IPSRC_RND"
     pg_set $dev "src_min 198.18.0.0"
diff --git a/samples/pktgen/pktgen_sample05_flow_per_thread.sh b/samples/pktgen/pktgen_sample05_flow_per_thread.sh
index 7f8b5e59f01e..0c06e63fbe97 100755
--- a/samples/pktgen/pktgen_sample05_flow_per_thread.sh
+++ b/samples/pktgen/pktgen_sample05_flow_per_thread.sh
@@ -22,7 +22,10 @@ source ${basedir}/parameters.sh
 [ -z "$CLONE_SKB" ] && CLONE_SKB="0"
 [ -z "$BURST" ]     && BURST=32
 [ -z "$COUNT" ]     && COUNT="0" # Zero means indefinitely
-
+if [ -n "$DST_PORT" ]; then
+    read -r DST_MIN DST_MAX <<< $(parse_ports $DST_PORT)
+    validate_ports $DST_MIN $DST_MAX
+fi
 
 # Base Config
 DELAY="0"  # Zero means max speed
@@ -50,6 +53,13 @@ for ((thread = $F_THREAD; thread <= $L_THREAD; thread++)); do
     pg_set $dev "dst_mac $DST_MAC"
     pg_set $dev "dst $DEST_IP"
 
+    if [ -n "$DST_PORT" ]; then
+	# Single destination port or random port range
+	pg_set $dev "flag UDPDST_RND"
+	pg_set $dev "udp_dst_min $DST_MIN"
+	pg_set $dev "udp_dst_max $DST_MAX"
+    fi
+
     # Setup source IP-addresses based on thread number
     pg_set $dev "src_min 198.18.$((thread+1)).1"
     pg_set $dev "src_max 198.18.$((thread+1)).1"
diff --git a/samples/pktgen/pktgen_sample06_numa_awared_queue_irq_affinity.sh b/samples/pktgen/pktgen_sample06_numa_awared_queue_irq_affinity.sh
index 353adc17205e..97f0266c0356 100755
--- a/samples/pktgen/pktgen_sample06_numa_awared_queue_irq_affinity.sh
+++ b/samples/pktgen/pktgen_sample06_numa_awared_queue_irq_affinity.sh
@@ -35,6 +35,10 @@ if [ -z "$DEST_IP" ]; then
     [ -z "$IP6" ] && DEST_IP="198.18.0.42" || DEST_IP="FD00::1"
 fi
 [ -z "$DST_MAC" ] && DST_MAC="90:e2:ba:ff:ff:ff"
+if [ -n "$DST_PORT" ]; then
+    read -r DST_MIN DST_MAX <<< $(parse_ports $DST_PORT)
+    validate_ports $DST_MIN $DST_MAX
+fi
 
 # General cleanup everything since last run
 pg_ctrl "reset"
@@ -77,6 +81,13 @@ for ((i = 0; i < $THREADS; i++)); do
     pg_set $dev "dst_mac $DST_MAC"
     pg_set $dev "dst$IP6 $DEST_IP"
 
+    if [ -n "$DST_PORT" ]; then
+	# Single destination port or random port range
+	pg_set $dev "flag UDPDST_RND"
+	pg_set $dev "udp_dst_min $DST_MIN"
+	pg_set $dev "udp_dst_max $DST_MAX"
+    fi
+
     # Setup random UDP port src range
     pg_set $dev "flag UDPSRC_RND"
     pg_set $dev "udp_src_min $UDP_MIN"
-- 
2.17.1

