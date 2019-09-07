Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88EBCAC993
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 23:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393417AbfIGVpf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 17:45:35 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45234 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728292AbfIGVpf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Sep 2019 17:45:35 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x87Lck5N005522;
        Sat, 7 Sep 2019 21:42:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=RzwOxSydNXyFKI6PaoTuaIiUwrUkRUFmO7stOAVfgLs=;
 b=Mgitbd95uMb9APiFkswFW/Bj7melSd6hJ+qFR07jOzGl8wzx8lOEemgYYQAMr8WM9/QJ
 eKZ3CTx3znZk6pk3viLcH217RioSAhQ8BX8MFcOP3Lezd9KsD34rw09l4YNpbQTTKDuV
 e0e/B5wauX65dB2lkUibcXxfxg/o2N9ZecVX36Odr/4dNnvRtGuhhOgcnNUKufg/xbjO
 9LJsSqKZA0xy4mnfUppGf0H95nWWS3GfxYguD9mpneOa5CBWnpXAn5316V9MrZxjmFAW
 MxfnD1I+RcxTtItW0Sw1Pph4Mw68EzJlRNGsikQRSnatTmuggP1lzx/pGVAJLwaT02je uA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2uvme3r19a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 07 Sep 2019 21:42:54 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x87Lc91p176278;
        Sat, 7 Sep 2019 21:42:54 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2uve9b9rdt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 07 Sep 2019 21:42:54 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x87LgrtO005280;
        Sat, 7 Sep 2019 21:42:53 GMT
Received: from dhcp-10-175-169-153.vpn.oracle.com (/10.175.169.153)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 07 Sep 2019 14:42:51 -0700
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, davem@davemloft.net,
        jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, rostedt@goodmis.org, mingo@redhat.com,
        quentin.monnet@netronome.com, rdna@fb.com, joe@wand.net.nz,
        acme@redhat.com, jolsa@kernel.org, alexey.budankov@linux.intel.com,
        gregkh@linuxfoundation.org, namhyung@kernel.org, sdf@google.com,
        f.fainelli@gmail.com, shuah@kernel.org, peter@lekensteyn.nl,
        ivan@cloudflare.com, andriin@fb.com,
        bhole_prashant_q7@lab.ntt.co.jp, david.calavera@gmail.com,
        danieltimlee@gmail.com, ctakshak@fb.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     Alan Maguire <alan.maguire@oracle.com>
Subject: [RFC bpf-next 7/7] bpf: add tests for bpftool packet capture
Date:   Sat,  7 Sep 2019 22:40:44 +0100
Message-Id: <1567892444-16344-8-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1567892444-16344-1-git-send-email-alan.maguire@oracle.com>
References: <1567892444-16344-1-git-send-email-alan.maguire@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9373 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=4 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909070235
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9373 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=4 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909070235
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

add tests which verify packet capture works for tracing of
kprobes and raw tracepoints, and for capturing packets from
existing skb/xdp programs.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/testing/selftests/bpf/Makefile               |   3 +-
 .../testing/selftests/bpf/progs/bpftool_pcap_tc.c  |  41 +++++++
 .../testing/selftests/bpf/progs/bpftool_pcap_xdp.c |  39 ++++++
 tools/testing/selftests/bpf/test_bpftool_pcap.sh   | 132 +++++++++++++++++++++
 4 files changed, 214 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/progs/bpftool_pcap_tc.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpftool_pcap_xdp.c
 create mode 100755 tools/testing/selftests/bpf/test_bpftool_pcap.sh

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 7f3196a..1e8b68d 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -66,7 +66,8 @@ TEST_PROGS := test_kmod.sh \
 	test_tc_tunnel.sh \
 	test_tc_edt.sh \
 	test_xdping.sh \
-	test_bpftool_build.sh
+	test_bpftool_build.sh \
+	test_bpftool_pcap.sh
 
 TEST_PROGS_EXTENDED := with_addr.sh \
 	with_tunnels.sh \
diff --git a/tools/testing/selftests/bpf/progs/bpftool_pcap_tc.c b/tools/testing/selftests/bpf/progs/bpftool_pcap_tc.c
new file mode 100644
index 0000000..b51f8fc
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpftool_pcap_tc.c
@@ -0,0 +1,41 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved. */
+
+#include <stddef.h>
+#include <linux/ptrace.h>
+#include <linux/bpf.h>
+#include <linux/pkt_cls.h>
+
+#include <bpf_helpers.h>
+
+#define KBUILD_MODNAME "foo"
+
+struct bpf_map_def SEC("maps") pcap_data_map = {
+	.type = BPF_MAP_TYPE_PERF_EVENT_ARRAY,
+	.key_size = sizeof(int),
+	.value_size = sizeof(int),
+	.max_entries = 1024,
+};
+
+struct bpf_map_def SEC("maps") pcap_conf_map = {
+	.type = BPF_MAP_TYPE_ARRAY,
+	.key_size = sizeof(int),
+	.value_size = sizeof(struct bpf_pcap_hdr),
+	.max_entries = 1,
+};
+
+SEC("tc_pcap")
+int tc_pcap(struct __sk_buff *skb)
+{
+	struct bpf_pcap_hdr *conf;
+	int key = 0;
+
+	conf = bpf_map_lookup_elem(&pcap_conf_map, &key);
+	if (!conf)
+		return 0;
+
+	bpf_pcap(skb, conf->cap_len, &pcap_data_map, conf->protocol,
+		 conf->flags);
+
+	return TC_ACT_OK;
+}
diff --git a/tools/testing/selftests/bpf/progs/bpftool_pcap_xdp.c b/tools/testing/selftests/bpf/progs/bpftool_pcap_xdp.c
new file mode 100644
index 0000000..a7d6866
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpftool_pcap_xdp.c
@@ -0,0 +1,39 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved. */
+
+#include <stddef.h>
+#include <linux/bpf.h>
+
+#include <bpf_helpers.h>
+
+#define KBUILD_MODNAME "foo"
+
+struct bpf_map_def SEC("maps") pcap_data_map = {
+	.type = BPF_MAP_TYPE_PERF_EVENT_ARRAY,
+	.key_size = sizeof(int),
+	.value_size = sizeof(int),
+	.max_entries = 1024,
+};
+
+struct bpf_map_def SEC("maps") pcap_conf_map = {
+	.type = BPF_MAP_TYPE_ARRAY,
+	.key_size = sizeof(int),
+	.value_size = sizeof(struct bpf_pcap_hdr),
+	.max_entries = 1,
+};
+
+SEC("xdp_pcap")
+int xdp_pcap(struct xdp_md *ctx)
+{
+	struct bpf_pcap_hdr *conf;
+	int key = 0;
+
+	conf = bpf_map_lookup_elem(&pcap_conf_map, &key);
+	if (!conf)
+		return 0;
+
+	bpf_pcap(ctx, conf->cap_len, &pcap_data_map, conf->protocol,
+		 conf->flags);
+
+	return XDP_PASS;
+}
diff --git a/tools/testing/selftests/bpf/test_bpftool_pcap.sh b/tools/testing/selftests/bpf/test_bpftool_pcap.sh
new file mode 100755
index 0000000..92b5438
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_bpftool_pcap.sh
@@ -0,0 +1,132 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved.
+
+readonly src="../../../../"
+readonly bpftool="${src}/tools/bpf/bpftool/bpftool"
+readonly capfile="/tmp/cap.$$"
+readonly ns="ns-$$"
+readonly badport="5555"
+readonly addr1="192.168.1.1"
+readonly addr2="192.168.1.2"
+readonly pinpath="/sys/fs/bpf/"
+readonly veth1="${ns}-veth1"
+readonly veth2="${ns}-veth2"
+# 24 bytes for the pcap header
+readonly cap_minsize=24
+readonly caplens="0 8192"
+readonly addrs="127.0.0.1 ::1"
+readonly devs="none lo"
+
+cleanup() {
+  iptables -D INPUT -p tcp --dport $badport -j DROP
+  ip6tables -D INPUT -p tcp --dport $badport -j DROP
+  ip netns del $ns 2>/dev/null
+  rm -f $capfile
+}
+
+verify_capture() {
+  capsize=$(stat -c '%s' $capfile)
+  if [[ $capsize -le $cap_minsize ]]; then
+    exit 1
+  fi
+  if [[ $no_tcpdump == 0 ]]; then
+    count=$(tcpdump -lnr $capfile $1 2>/dev/null)
+    if [[ -z "$count" ]]; then
+      exit 1
+    fi
+  fi
+}
+
+which tcpdump 2>&1 > /dev/null
+no_tcpdump=$?
+
+pcap_supported=$(bpftool pcap help >/dev/null 2>&1)
+if [[ $? -ne 0 ]]; then
+	echo "no pcap support in bpftool, cannot test feature."
+	exit 0
+fi
+
+set -e
+
+trap cleanup EXIT
+
+iptables -A INPUT -p tcp --dport $badport -j DROP
+ip6tables -A INPUT -p tcp --dport $badport -j DROP
+
+# Test "bpftool pcap trace" - kprobe, tracepoint tracing
+for probe in kprobe tracepoint; do
+  for dev in $devs; do
+    devarg=
+    if [[ $dev != "none" ]]; then
+      devarg="dev $dev"
+    fi
+    args="$probe:kfree_skb proto ip data_out $capfile $devarg"
+    echo "Test trace $args"
+    for caplen in $caplens ; do
+      for progname in none $probe ; do
+        progpath=
+        if [[ $progname != "none" ]]; then
+          progpath=${bpftool}_pcap_${probe}.o
+        fi
+        allargs="$progpath $args len $caplen"
+        for addr in $addrs ; do
+          $bpftool pcap trace $allargs &
+          bpftool_pid=$!
+          set +e
+          timeout 2 nc $addr $badport 2>/dev/null
+          kill -TERM $bpftool_pid
+          set -e
+          sleep 1
+          verify_capture "host $addr and port $badport"
+          rm -f $capfile
+        done
+      done
+    done
+    echo "Test trace $args: PASS"
+  done
+done
+
+# Test "bpftool pcap prog" - skb, xdp program tracing
+ip netns add $ns
+ip link add dev $veth2 netns $ns type veth peer name $veth1
+ip link set $veth1 up
+ip addr add ${addr1}/24 dev $veth1
+ip -netns $ns link set $veth2 up
+ip netns exec $ns ip addr add ${addr2}/24 dev $veth2
+
+for prog in tc xdp ; do
+  if [[ $prog == tc ]]; then
+    ip netns exec $ns tc qdisc add dev $veth2 clsact
+    ip netns exec $ns tc filter add dev $veth2 ingress bpf da \
+      obj bpftool_pcap_${prog}.o sec ${prog}_pcap
+    id=$(ip netns exec $ns tc filter show dev $veth2 ingress | \
+         awk '/direct-action/ { for(i=1;i<=NF;i++)if($i=="id")print $(i+1)}')
+  else
+    ip netns exec $ns ip link set dev $veth2 xdp obj bpftool_pcap_${prog}.o \
+      sec ${prog}_pcap
+    id=$(ip netns exec $ns ip link show $veth2 | awk '/prog\/xdp/ { print $3 }')
+    sleep 5
+  fi
+  args="id $id data_out $capfile"
+  echo "Test prog $args"
+  for caplen in $caplens ; do
+    allargs="$args len $caplen"
+    $bpftool pcap prog $allargs &
+    bpftool_pid=$!
+    set +e
+    ping -q -c 5 $addr2 1>/dev/null
+    kill -TERM $bpftool_pid
+    set -e
+    sleep 1
+    verify_capture "host $addr1"
+    rm -f $capfile
+  done
+  if [[ $prog == tc ]]; then
+    ip netns exec $ns tc qdisc del dev $veth2 clsact
+    sleep 1
+  else
+    ip netns exec $ns ip link set dev $veth2 xdp off
+  fi
+  echo "Test trace $args: PASS"
+done
-- 
1.8.3.1

