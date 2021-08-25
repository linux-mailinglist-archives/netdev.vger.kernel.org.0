Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 805E73F73D8
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 12:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240185AbhHYK6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 06:58:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240177AbhHYK6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 06:58:15 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0AEBC0613D9
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 03:57:28 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id e1so7156597plt.11
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 03:57:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oDPh1NSYq9s9R6R/5zo78Un8cgY2LQKnqbEpHJHNGIY=;
        b=BiKqFpAdkVMV/P2dgd7WoWgbAI6jGYWSOY+djxlUwENqHBYXz+PMHJ4Tn9iklE/fK8
         BSmo+XI6ot1tmcCMmL5Cw61kXbAkLdJszZOuzQybeXk0MjvsnUOzea7cNONYk/Z2LlID
         4drutbLVAehM0Ri/+RKGPKXWpPzonhK0vXVOGt0qxdYUvJMaQtZdzCQu88+wTmAGiJii
         lX5zKPJ1M0gKrLWsrKtOv13a41wvJJ7oRohCnV3UD+W640MV7RCkR7l3WMomiIQ4lIzZ
         n0N6bBJCoDb8ycc8s2/6prxDozgSZbxsyFczYwwr4t0aWmJ9adFyhROidippTyFw94T2
         uefg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oDPh1NSYq9s9R6R/5zo78Un8cgY2LQKnqbEpHJHNGIY=;
        b=EjHBHDThgYH4XDy6pBMerMNFqy2pY9wnu5H95LKuhnnPtvfmediJUUZZtETb/6evq7
         ltF5VxMnRnLSYo9UbKrKkJC2/EoYb9304s0qj07CziNQ8kKR9nDzwmEYPzNKY7KZuS2T
         uOJ30lBVB/XnqG54QsUqtD3Qm+v2+UGCArDiOFfZhfv5uHLtdUFgQtE4wkKbfHUsiwzC
         u7u91LdEtO6keUQgC3GnL/wAJOcfXsKuzGpZY+M/VHSY8sP0MQoL0D4x9qwKhtE68sts
         kP8DP5XPC9bz05OE83xmfzXjWx1nN9T1AKZmsAvRS7TvAe2YD7H9ersGCuk0KnTVmwOE
         DWMQ==
X-Gm-Message-State: AOAM531yCkrpCiiuEIn9oTbGk2F92D0ocY2vhuhc7Q0w7RgDbZTDKD6A
        2cKfM4xkE2p9TpyJMjg7alQ=
X-Google-Smtp-Source: ABdhPJy80pVC3II8ERNVUEVvN7k7GcJZGjwFdeImhx8yiQIN7z5hzXfPoWKjNTloTZ0b0ReVbyR/WQ==
X-Received: by 2002:a17:90a:7384:: with SMTP id j4mr9918837pjg.138.1629889048124;
        Wed, 25 Aug 2021 03:57:28 -0700 (PDT)
Received: from MASTER.. ([58.76.185.115])
        by smtp.gmail.com with ESMTPSA id 6sm5606191pjz.8.2021.08.25.03.57.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 03:57:27 -0700 (PDT)
From:   Juhee Kang <claudiajkang@gmail.com>
To:     hawk@kernel.org, davem@davemloft.net, toke@toke.dk
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 2/3] samples: pktgen: add trap SIGINT for printing execution result
Date:   Wed, 25 Aug 2021 19:57:16 +0900
Message-Id: <20210825105717.43195-3-claudiajkang@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210825105717.43195-1-claudiajkang@gmail.com>
References: <20210825105717.43195-1-claudiajkang@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All pktgen samples can send indefinitely num messages per thread by
setting the count option to 0(-n 0). If running sample with setting
count 0 and press Ctrl-C to stop this program, the program prints the
result of the execution so far. Currently, the samples besides
sample{3...5} don't work properly. Because Ctrl-C stops the script, not
just pktgen.

This is results of samples:

    # DEV=eth0 DEST_IP=10.1.0.1 DST_MAC=00:11:22:33:44:55 ./pktgen_sample04_many_flows.sh -n 0
    Running... ctrl^C to stop
    ^CDevice: eth0@0
    Result: OK: 569657(c569538+d118) usec, 84650 (60byte,0frags)
    148597pps 71Mb/sec (71326560bps) errors: 0

    # DEV=eth0 DEST_IP=10.1.0.1 DST_MAC=00:11:22:33:44:55 ./pktgen_sample01_simple.sh -n 0
    Running... ctrl^C to stop
    ^C

In order to solve this, this commit adds trap SIGINT. Also, this commit
changes control_c function to print_result to maintain consistency with
other samples.

Signed-off-by: Juhee Kang <claudiajkang@gmail.com>
---
 .../pktgen_bench_xmit_mode_netif_receive.sh   | 19 +++++++++++++------
 .../pktgen_bench_xmit_mode_queue_xmit.sh      | 19 +++++++++++++------
 samples/pktgen/pktgen_sample01_simple.sh      | 13 ++++++++++---
 samples/pktgen/pktgen_sample02_multiqueue.sh  | 19 +++++++++++++------
 ...sample06_numa_awared_queue_irq_affinity.sh | 19 +++++++++++++------
 5 files changed, 62 insertions(+), 27 deletions(-)

diff --git a/samples/pktgen/pktgen_bench_xmit_mode_netif_receive.sh b/samples/pktgen/pktgen_bench_xmit_mode_netif_receive.sh
index 30a610b541ad..99ec0688b044 100755
--- a/samples/pktgen/pktgen_bench_xmit_mode_netif_receive.sh
+++ b/samples/pktgen/pktgen_bench_xmit_mode_netif_receive.sh
@@ -89,14 +89,21 @@ for ((thread = $F_THREAD; thread <= $L_THREAD; thread++)); do
     pg_set $dev "burst $BURST"
 done

+# Run if user hits control-c
+function print_result() {
+    # Print results
+    for ((thread = $F_THREAD; thread <= $L_THREAD; thread++)); do
+        dev=${DEV}@${thread}
+        echo "Device: $dev"
+        cat /proc/net/pktgen/$dev | grep -A2 "Result:"
+    done
+}
+# trap keyboard interrupt (Ctrl-C)
+trap true SIGINT
+
 # start_run
 echo "Running... ctrl^C to stop" >&2
 pg_ctrl "start"
 echo "Done" >&2

-# Print results
-for ((thread = $F_THREAD; thread <= $L_THREAD; thread++)); do
-    dev=${DEV}@${thread}
-    echo "Device: $dev"
-    cat /proc/net/pktgen/$dev | grep -A2 "Result:"
-done
+print_result
diff --git a/samples/pktgen/pktgen_bench_xmit_mode_queue_xmit.sh b/samples/pktgen/pktgen_bench_xmit_mode_queue_xmit.sh
index a6195bd77532..04b0dd0c36d6 100755
--- a/samples/pktgen/pktgen_bench_xmit_mode_queue_xmit.sh
+++ b/samples/pktgen/pktgen_bench_xmit_mode_queue_xmit.sh
@@ -69,14 +69,21 @@ for ((thread = $F_THREAD; thread <= $L_THREAD; thread++)); do
     pg_set $dev "xmit_mode queue_xmit"
 done

+# Run if user hits control-c
+function print_result {
+    # Print results
+    for ((thread = $F_THREAD; thread <= $L_THREAD; thread++)); do
+        dev=${DEV}@${thread}
+        echo "Device: $dev"
+        cat /proc/net/pktgen/$dev | grep -A2 "Result:"
+    done
+}
+# trap keyboard interrupt (Ctrl-C)
+trap true SIGINT
+
 # start_run
 echo "Running... ctrl^C to stop" >&2
 pg_ctrl "start"
 echo "Done" >&2

-# Print results
-for ((thread = $F_THREAD; thread <= $L_THREAD; thread++)); do
-    dev=${DEV}@${thread}
-    echo "Device: $dev"
-    cat /proc/net/pktgen/$dev | grep -A2 "Result:"
-done
+print_result
diff --git a/samples/pktgen/pktgen_sample01_simple.sh b/samples/pktgen/pktgen_sample01_simple.sh
index 246cfe02bb82..09a92ea963f9 100755
--- a/samples/pktgen/pktgen_sample01_simple.sh
+++ b/samples/pktgen/pktgen_sample01_simple.sh
@@ -79,15 +79,22 @@ pg_set $DEV "flag UDPSRC_RND"
 pg_set $DEV "udp_src_min $UDP_SRC_MIN"
 pg_set $DEV "udp_src_max $UDP_SRC_MAX"

+# Run if user hits control-c
+function print_result() {
+    # Print results
+    echo "Result device: $DEV"
+    cat /proc/net/pktgen/$DEV
+}
+# trap keyboard interrupt (Ctrl-C)
+trap true SIGINT
+
 if [ -z "$APPEND" ]; then
     # start_run
     echo "Running... ctrl^C to stop" >&2
     pg_ctrl "start"
     echo "Done" >&2

-    # Print results
-    echo "Result device: $DEV"
-    cat /proc/net/pktgen/$DEV
+    print_result
 else
     echo "Append mode: config done. Do more or use 'pg_ctrl start' to run"
 fi
\ No newline at end of file
diff --git a/samples/pktgen/pktgen_sample02_multiqueue.sh b/samples/pktgen/pktgen_sample02_multiqueue.sh
index c6af3d9d5171..7fa41c84c32f 100755
--- a/samples/pktgen/pktgen_sample02_multiqueue.sh
+++ b/samples/pktgen/pktgen_sample02_multiqueue.sh
@@ -83,18 +83,25 @@ for ((thread = $F_THREAD; thread <= $L_THREAD; thread++)); do
     pg_set $dev "udp_src_max $UDP_SRC_MAX"
 done

-if [ -z "$APPEND" ]; then
-    # start_run
-    echo "Running... ctrl^C to stop" >&2
-    pg_ctrl "start"
-    echo "Done" >&2
-
+# Run if user hits control-c
+function print_result() {
     # Print results
     for ((thread = $F_THREAD; thread <= $L_THREAD; thread++)); do
         dev=${DEV}@${thread}
         echo "Device: $dev"
         cat /proc/net/pktgen/$dev | grep -A2 "Result:"
     done
+}
+# trap keyboard interrupt (Ctrl-C)
+trap true SIGINT
+
+if [ -z "$APPEND" ]; then
+    # start_run
+    echo "Running... ctrl^C to stop" >&2
+    pg_ctrl "start"
+    echo "Done" >&2
+
+    print_result
 else
     echo "Append mode: config done. Do more or use 'pg_ctrl start' to run"
 fi
diff --git a/samples/pktgen/pktgen_sample06_numa_awared_queue_irq_affinity.sh b/samples/pktgen/pktgen_sample06_numa_awared_queue_irq_affinity.sh
index 7c27923083a6..264cc5db9c49 100755
--- a/samples/pktgen/pktgen_sample06_numa_awared_queue_irq_affinity.sh
+++ b/samples/pktgen/pktgen_sample06_numa_awared_queue_irq_affinity.sh
@@ -100,12 +100,8 @@ for ((i = 0; i < $THREADS; i++)); do
     pg_set $dev "udp_src_max $UDP_SRC_MAX"
 done

-# start_run
-if [ -z "$APPEND" ]; then
-    echo "Running... ctrl^C to stop" >&2
-    pg_ctrl "start"
-    echo "Done" >&2
-
+# Run if user hits control-c
+function print_result() {
     # Print results
     for ((i = 0; i < $THREADS; i++)); do
         thread=${cpu_array[$((i+F_THREAD))]}
@@ -113,6 +109,17 @@ if [ -z "$APPEND" ]; then
         echo "Device: $dev"
         cat /proc/net/pktgen/$dev | grep -A2 "Result:"
     done
+}
+# trap keyboard interrupt (Ctrl-C)
+trap true SIGINT
+
+# start_run
+if [ -z "$APPEND" ]; then
+    echo "Running... ctrl^C to stop" >&2
+    pg_ctrl "start"
+    echo "Done" >&2
+
+    print_result
 else
     echo "Append mode: config done. Do more or use 'pg_ctrl start' to run"
 fi
--
2.30.2

