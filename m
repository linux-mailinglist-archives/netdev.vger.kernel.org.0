Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57067318F4E
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 17:01:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231655AbhBKQAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 11:00:20 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:1256 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230269AbhBKP5a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 10:57:30 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11BFtFhr005091;
        Thu, 11 Feb 2021 07:56:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=bRVKV2+O7U0gKSUgFRoYEi4FQGxntALRns84s0V6EPo=;
 b=Q6sYleI2r/VxIJW0g3H7XfJPDDGONOSdgGThqgEUDQKbBVo3UrgXF3HN2UK4rnTpomBG
 67978efoxvb3G1mKARAETyqmtroAclO+lgpotTUcnwa3gNDglnsMeyt0VqE3HNtyT6hF
 5cgN//trcYQgZuPSBW+nxroBE8IzP8jH/ZjRCZNHj2FHY4shuj+L2H3j1xdBWb3cS/b7
 pqZvEfYtdlvNuQn0CycXlU+S/xxeZlfOuaOgyxIMzOCmkx2GGBF0R1rmBxCReMPAT8Mq
 vJIY342bPX8BirK9rfR30Zgud3VaH4p29o7pdvQNmKc1EWgdcX+5zTseq37PeYPaQSb4 EQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 36hugqf956-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 11 Feb 2021 07:56:41 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Feb
 2021 07:56:39 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Feb
 2021 07:56:39 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 11 Feb 2021 07:56:39 -0800
Received: from EL-LT0043.marvell.com (unknown [10.193.38.106])
        by maili.marvell.com (Postfix) with ESMTP id F387E3F703F;
        Thu, 11 Feb 2021 07:56:37 -0800 (PST)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     Jesper Dangaard Brouer <brouer@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH v2 net-next 2/2] samples: pktgen: new append mode
Date:   Thu, 11 Feb 2021 16:56:26 +0100
Message-ID: <20210211155626.25213-3-irusskikh@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210211155626.25213-1-irusskikh@marvell.com>
References: <20210211155626.25213-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-11_07:2021-02-11,2021-02-11 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To configure various complex flows we for sure can create custom
pktgen init scripts, but sometimes thats not that easy.

New "-a" (append) option in all the existing sample scripts allows
to append more "devices" into pktgen threads.

The most straightforward usecases for that are:
- using multiple devices. We have to generate full linerate on
all physical functions (ports) of our multiport device.
- pushing multiple flows (with different packet options)

Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 samples/pktgen/README.rst                     | 18 +++++++++++
 samples/pktgen/functions.sh                   |  7 ++++-
 samples/pktgen/parameters.sh                  |  7 ++++-
 samples/pktgen/pktgen_sample01_simple.sh      | 22 ++++++++------
 samples/pktgen/pktgen_sample02_multiqueue.sh  | 28 +++++++++--------
 .../pktgen_sample03_burst_single_flow.sh      | 12 +++++---
 samples/pktgen/pktgen_sample04_many_flows.sh  | 14 +++++----
 .../pktgen/pktgen_sample05_flow_per_thread.sh | 14 +++++----
 ...sample06_numa_awared_queue_irq_affinity.sh | 30 +++++++++++--------
 9 files changed, 102 insertions(+), 50 deletions(-)

diff --git a/samples/pktgen/README.rst b/samples/pktgen/README.rst
index f9c53ca5cf93..e1615bbfd386 100644
--- a/samples/pktgen/README.rst
+++ b/samples/pktgen/README.rst
@@ -28,10 +28,28 @@ across the sample scripts.  Usage example is printed on errors::
   -b : ($BURST)     HW level bursting of SKBs
   -v : ($VERBOSE)   verbose
   -x : ($DEBUG)     debug
+  -6 : ($IP6)       IPv6
+  -w : ($DELAY)     Tx Delay value (us)
+  -a : ($APPEND)    Script will not reset generator's state, but will append its config
 
 The global variable being set is also listed.  E.g. the required
 interface/device parameter "-i" sets variable $DEV.
 
+"-a" parameter may be used to create different flows simultaneously.
+In this mode script will keep the existing config, will append its settings.
+In this mode you'll have to manually run traffic with "pg_ctrl start".
+
+For example you may use:
+
+    source ./samples/pktgen/functions.sh
+    pg_ctrl reset
+    # add first device
+    ./pktgen_sample06_numa_awared_queue_irq_affinity.sh -a -i ens1f0 -m 34:80:0d:a3:fc:c9 -t 8
+    # add second device
+    ./pktgen_sample06_numa_awared_queue_irq_affinity.sh -a -i ens1f1 -m 34:80:0d:a3:fc:c9 -t 8
+    # run joint traffic on two devs
+    pg_ctrl start
+
 Common functions
 ----------------
 The functions.sh file provides; Three different shell functions for
diff --git a/samples/pktgen/functions.sh b/samples/pktgen/functions.sh
index dae06d5b38fa..a335393157eb 100644
--- a/samples/pktgen/functions.sh
+++ b/samples/pktgen/functions.sh
@@ -108,7 +108,12 @@ function pgset() {
     fi
 }
 
-[[ $EUID -eq 0 ]] && trap 'pg_ctrl "reset"' EXIT
+if [[ -z "$APPEND" ]]; then
+	if [[ $EUID -eq 0 ]]; then
+		# Cleanup pktgen setup on exit if thats not "append mode"
+		trap 'pg_ctrl "reset"' EXIT
+	fi
+fi
 
 ## -- General shell tricks --
 
diff --git a/samples/pktgen/parameters.sh b/samples/pktgen/parameters.sh
index 70cc2878d479..d88c450d3f75 100644
--- a/samples/pktgen/parameters.sh
+++ b/samples/pktgen/parameters.sh
@@ -20,12 +20,13 @@ function usage() {
     echo "  -x : (\$DEBUG)     debug"
     echo "  -6 : (\$IP6)       IPv6"
     echo "  -w : (\$DELAY)     Tx Delay value (us)"
+    echo "  -a : (\$APPEND)    Script will not reset generator's state, but will append its config"
     echo ""
 }
 
 ##  --- Parse command line arguments / parameters ---
 ## echo "Commandline options:"
-while getopts "s:i:d:m:p:f:t:c:n:b:w:vxh6" option; do
+while getopts "s:i:d:m:p:f:t:c:n:b:w:vxh6a" option; do
     case $option in
         i) # interface
           export DEV=$OPTARG
@@ -83,6 +84,10 @@ while getopts "s:i:d:m:p:f:t:c:n:b:w:vxh6" option; do
 	  export IP6=6
 	  info "IP6: IP6=$IP6"
 	  ;;
+        a)
+          export APPEND=yes
+          info "Append mode: APPEND=$APPEND"
+          ;;
         h|?|*)
           usage;
           err 2 "[ERROR] Unknown parameters!!!"
diff --git a/samples/pktgen/pktgen_sample01_simple.sh b/samples/pktgen/pktgen_sample01_simple.sh
index c2ad1fa32d3f..a09f3422fbcc 100755
--- a/samples/pktgen/pktgen_sample01_simple.sh
+++ b/samples/pktgen/pktgen_sample01_simple.sh
@@ -37,11 +37,11 @@ UDP_SRC_MAX=109
 
 # General cleanup everything since last run
 # (especially important if other threads were configured by other scripts)
-pg_ctrl "reset"
+[ -z "$APPEND" ] && pg_ctrl "reset"
 
 # Add remove all other devices and add_device $DEV to thread 0
 thread=0
-pg_thread $thread "rem_device_all"
+[ -z "$APPEND" ] && pg_thread $thread "rem_device_all"
 pg_thread $thread "add_device" $DEV
 
 # How many packets to send (zero means indefinitely)
@@ -77,11 +77,15 @@ pg_set $DEV "flag UDPSRC_RND"
 pg_set $DEV "udp_src_min $UDP_SRC_MIN"
 pg_set $DEV "udp_src_max $UDP_SRC_MAX"
 
-# start_run
-echo "Running... ctrl^C to stop" >&2
-pg_ctrl "start"
-echo "Done" >&2
+if [ -z "$APPEND" ]; then
+    # start_run
+    echo "Running... ctrl^C to stop" >&2
+    pg_ctrl "start"
+    echo "Done" >&2
 
-# Print results
-echo "Result device: $DEV"
-cat /proc/net/pktgen/$DEV
+    # Print results
+    echo "Result device: $DEV"
+    cat /proc/net/pktgen/$DEV
+else
+    echo "Append mode: config done. Do more or use 'pg_ctrl start' to run"
+fi
\ No newline at end of file
diff --git a/samples/pktgen/pktgen_sample02_multiqueue.sh b/samples/pktgen/pktgen_sample02_multiqueue.sh
index 49e1e81a2945..acae8ede0d6c 100755
--- a/samples/pktgen/pktgen_sample02_multiqueue.sh
+++ b/samples/pktgen/pktgen_sample02_multiqueue.sh
@@ -38,7 +38,7 @@ if [ -n "$DST_PORT" ]; then
 fi
 
 # General cleanup everything since last run
-pg_ctrl "reset"
+[ -z "$APPEND" ] && pg_ctrl "reset"
 
 # Threads are specified with parameter -t value in $THREADS
 for ((thread = $F_THREAD; thread <= $L_THREAD; thread++)); do
@@ -47,7 +47,7 @@ for ((thread = $F_THREAD; thread <= $L_THREAD; thread++)); do
     dev=${DEV}@${thread}
 
     # Add remove all other devices and add_device $dev to thread
-    pg_thread $thread "rem_device_all"
+    [ -z "$APPEND" ] && pg_thread $thread "rem_device_all"
     pg_thread $thread "add_device" $dev
 
     # Notice config queue to map to cpu (mirrors smp_processor_id())
@@ -81,14 +81,18 @@ for ((thread = $F_THREAD; thread <= $L_THREAD; thread++)); do
     pg_set $dev "udp_src_max $UDP_SRC_MAX"
 done
 
-# start_run
-echo "Running... ctrl^C to stop" >&2
-pg_ctrl "start"
-echo "Done" >&2
+if [ -z "$APPEND" ]; then
+    # start_run
+    echo "Running... ctrl^C to stop" >&2
+    pg_ctrl "start"
+    echo "Done" >&2
 
-# Print results
-for ((thread = $F_THREAD; thread <= $L_THREAD; thread++)); do
-    dev=${DEV}@${thread}
-    echo "Device: $dev"
-    cat /proc/net/pktgen/$dev | grep -A2 "Result:"
-done
+    # Print results
+    for ((thread = $F_THREAD; thread <= $L_THREAD; thread++)); do
+        dev=${DEV}@${thread}
+        echo "Device: $dev"
+        cat /proc/net/pktgen/$dev | grep -A2 "Result:"
+    done
+else
+    echo "Append mode: config done. Do more or use 'pg_ctrl start' to run"
+fi
diff --git a/samples/pktgen/pktgen_sample03_burst_single_flow.sh b/samples/pktgen/pktgen_sample03_burst_single_flow.sh
index f9b67affb567..5adcf954de73 100755
--- a/samples/pktgen/pktgen_sample03_burst_single_flow.sh
+++ b/samples/pktgen/pktgen_sample03_burst_single_flow.sh
@@ -43,14 +43,14 @@ if [ -n "$DST_PORT" ]; then
 fi
 
 # General cleanup everything since last run
-pg_ctrl "reset"
+[ -z "$APPEND" ] && pg_ctrl "reset"
 
 # Threads are specified with parameter -t value in $THREADS
 for ((thread = $F_THREAD; thread <= $L_THREAD; thread++)); do
     dev=${DEV}@${thread}
 
     # Add remove all other devices and add_device $dev to thread
-    pg_thread $thread "rem_device_all"
+    [ -z "$APPEND" ] && pg_thread $thread "rem_device_all"
     pg_thread $thread "add_device" $dev
 
     # Base config
@@ -94,5 +94,9 @@ function control_c() {
 # trap keyboard interrupt (Ctrl-C)
 trap control_c SIGINT
 
-echo "Running... ctrl^C to stop" >&2
-pg_ctrl "start"
+if [ -z "$APPEND" ]; then
+    echo "Running... ctrl^C to stop" >&2
+    pg_ctrl "start"
+else
+    echo "Append mode: config done. Do more or use 'pg_ctrl start' to run"
+fi
diff --git a/samples/pktgen/pktgen_sample04_many_flows.sh b/samples/pktgen/pktgen_sample04_many_flows.sh
index ac2d037a6160..ddce876635aa 100755
--- a/samples/pktgen/pktgen_sample04_many_flows.sh
+++ b/samples/pktgen/pktgen_sample04_many_flows.sh
@@ -42,14 +42,14 @@ fi
 read -r SRC_MIN SRC_MAX <<< $(parse_addr 198.18.0.0/15)
 
 # General cleanup everything since last run
-pg_ctrl "reset"
+[ -z "$APPEND" ] && pg_ctrl "reset"
 
 # Threads are specified with parameter -t value in $THREADS
 for ((thread = $F_THREAD; thread <= $L_THREAD; thread++)); do
     dev=${DEV}@${thread}
 
     # Add remove all other devices and add_device $dev to thread
-    pg_thread $thread "rem_device_all"
+    [ -z "$APPEND" ] && pg_thread $thread "rem_device_all"
     pg_thread $thread "add_device" $dev
 
     # Base config
@@ -104,7 +104,11 @@ function print_result() {
 # trap keyboard interrupt (Ctrl-C)
 trap true SIGINT
 
-echo "Running... ctrl^C to stop" >&2
-pg_ctrl "start"
+if [ -z "$APPEND" ]; then
+    echo "Running... ctrl^C to stop" >&2
+    pg_ctrl "start"
 
-print_result
+    print_result
+else
+    echo "Append mode: config done. Do more or use 'pg_ctrl start' to run"
+fi
diff --git a/samples/pktgen/pktgen_sample05_flow_per_thread.sh b/samples/pktgen/pktgen_sample05_flow_per_thread.sh
index 85256484c86f..4a65fe2fcee9 100755
--- a/samples/pktgen/pktgen_sample05_flow_per_thread.sh
+++ b/samples/pktgen/pktgen_sample05_flow_per_thread.sh
@@ -32,14 +32,14 @@ if [ -n "$DST_PORT" ]; then
 fi
 
 # General cleanup everything since last run
-pg_ctrl "reset"
+[ -z "$APPEND" ] && pg_ctrl "reset"
 
 # Threads are specified with parameter -t value in $THREADS
 for ((thread = $F_THREAD; thread <= $L_THREAD; thread++)); do
     dev=${DEV}@${thread}
 
     # Add remove all other devices and add_device $dev to thread
-    pg_thread $thread "rem_device_all"
+    [ -z "$APPEND" ] && pg_thread $thread "rem_device_all"
     pg_thread $thread "add_device" $dev
 
     # Base config
@@ -88,7 +88,11 @@ function print_result() {
 # trap keyboard interrupt (Ctrl-C)
 trap true SIGINT
 
-echo "Running... ctrl^C to stop" >&2
-pg_ctrl "start"
+if [ -z "$APPEND" ]; then
+    echo "Running... ctrl^C to stop" >&2
+    pg_ctrl "start"
 
-print_result
+    print_result
+else
+    echo "Append mode: config done. Do more or use 'pg_ctrl start' to run"
+fi
diff --git a/samples/pktgen/pktgen_sample06_numa_awared_queue_irq_affinity.sh b/samples/pktgen/pktgen_sample06_numa_awared_queue_irq_affinity.sh
index 7c73ab8fbe3c..10f1da571f40 100755
--- a/samples/pktgen/pktgen_sample06_numa_awared_queue_irq_affinity.sh
+++ b/samples/pktgen/pktgen_sample06_numa_awared_queue_irq_affinity.sh
@@ -44,7 +44,7 @@ if [ -n "$DST_PORT" ]; then
 fi
 
 # General cleanup everything since last run
-pg_ctrl "reset"
+[ -z "$APPEND" ] && pg_ctrl "reset"
 
 # Threads are specified with parameter -t value in $THREADS
 for ((i = 0; i < $THREADS; i++)); do
@@ -58,7 +58,7 @@ for ((i = 0; i < $THREADS; i++)); do
     info "irq ${irq_array[$i]} is set affinity to `cat /proc/irq/${irq_array[$i]}/smp_affinity_list`"
 
     # Add remove all other devices and add_device $dev to thread
-    pg_thread $thread "rem_device_all"
+    [ -z "$APPEND" ] && pg_thread $thread "rem_device_all"
     pg_thread $thread "add_device" $dev
 
     # select queue and bind the queue and $dev in 1:1 relationship
@@ -99,14 +99,18 @@ for ((i = 0; i < $THREADS; i++)); do
 done
 
 # start_run
-echo "Running... ctrl^C to stop" >&2
-pg_ctrl "start"
-echo "Done" >&2
-
-# Print results
-for ((i = 0; i < $THREADS; i++)); do
-    thread=${cpu_array[$((i+F_THREAD))]}
-    dev=${DEV}@${thread}
-    echo "Device: $dev"
-    cat /proc/net/pktgen/$dev | grep -A2 "Result:"
-done
+if [ -z "$APPEND" ]; then
+    echo "Running... ctrl^C to stop" >&2
+    pg_ctrl "start"
+    echo "Done" >&2
+
+    # Print results
+    for ((i = 0; i < $THREADS; i++)); do
+        thread=${cpu_array[$((i+F_THREAD))]}
+        dev=${DEV}@${thread}
+        echo "Device: $dev"
+        cat /proc/net/pktgen/$dev | grep -A2 "Result:"
+    done
+else
+    echo "Append mode: config done. Do more or use 'pg_ctrl start' to run"
+fi
-- 
2.25.1

