Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CCE8465C4C
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 03:47:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354994AbhLBCvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 21:51:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354997AbhLBCvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 21:51:08 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD9C0C061748
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 18:47:46 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id gt5so19488010pjb.1
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 18:47:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TrstKECFk8gOGCbVkweAHPFWowtjG3x57DhZCA+QU+4=;
        b=peXH3V3D3f3qSX7MJ5nPTvdDYjBDjzT2ZVzkR0MktMAj/0bVqMpKGPEifiTVWobtAh
         R9A5HrOx+lZHSWyM3JNasjE2cmcRshkXC3On3JNgPNXiB9hgMpsSXUmcZxv1g5gevfFd
         rBFjAb9sVKD+HwZIO3xQ+7YoChtxZ9tFI2YKf8bGZnwSlQbUA/RV/tlSTTCjkGo1Z4e1
         wm4Xy3ow/QIXL4QTWRb1rz9reEpFZiKb94Xo5e8YO/gtC1ETdCW0tnHtKGr7og7NxWak
         emHVyfsU8Pk5UCXN6VnhZQ/s6YvDU6CI2/vTejAPKvL8rT+krFyfh3kgNVE0KbOHWcSx
         90Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TrstKECFk8gOGCbVkweAHPFWowtjG3x57DhZCA+QU+4=;
        b=thHChLXgsjEkgXgLC8cVnOocqlfNMpTUnYdVd/7Dus8qx30ilnDO4KZvDhq4ulyi3h
         WxkHjGYedos7D5KKr8M4FHhOq9cWraelmpbHJEExWmp9Wyr+VO2qrjpG7BCUzw1CB6u1
         WaC160Gjca2oJaWY5KYFhQgPmYwyOxM2NdHtaMgjS6iRq1/22lWwqphRRbEQ8NrtbnU4
         +hnaqRDKXkvLjMJgJUCe34o7jYMUY5oTy1y7ImGHhMDlGNY2lH13s1k7zFnXDG8kFq60
         vnB8nMe1wsmmFJusI+lsNgXtIzdvrFJ89bMtYiS0+Lx6nCySUnPtftLhPWr89Wm12qpy
         sUzg==
X-Gm-Message-State: AOAM531JZDHzoNhI0e7UYRD+XO2hUe92LLVPcVXFa8nHjqL5jd6TWsxw
        9sCHtp4LSOhbGT2Ftp/ACgGkb6IECHsCyg==
X-Google-Smtp-Source: ABdhPJzGQcSK4Jx3di9Fhv7welDN2/1EVcc462V0EjrPdLJDJBObxSWilDPoR+IVp8WYfwpccXoVmA==
X-Received: by 2002:a17:902:c412:b0:141:f716:e192 with SMTP id k18-20020a170902c41200b00141f716e192mr12075475plk.88.1638413265495;
        Wed, 01 Dec 2021 18:47:45 -0800 (PST)
Received: from localhost.localdomain ([111.204.182.106])
        by smtp.gmail.com with ESMTPSA id z10sm1183180pfh.188.2021.12.01.18.47.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 Dec 2021 18:47:45 -0800 (PST)
From:   xiangxia.m.yue@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, edumazet@google.com, atenart@kernel.org,
        alexandr.lobakin@intel.com, weiwan@google.com, arnd@arndb.de,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [net v4 3/3] selftests: bpf: add bpf_redirect to ifb
Date:   Thu,  2 Dec 2021 10:47:23 +0800
Message-Id: <20211202024723.76257-4-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20211202024723.76257-1-xiangxia.m.yue@gmail.com>
References: <20211202024723.76257-1-xiangxia.m.yue@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

ifb netdev is used for queueing incoming traffic for shaping.
we may run bpf progs in tc cls hook(ingress or egress), to
redirect the packets to ifb.

This patch adds this test, for bpf.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Yonghong Song <yhs@fb.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: KP Singh <kpsingh@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Antoine Tenart <atenart@kernel.org>
Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
Cc: Wei Wang <weiwan@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 tools/testing/selftests/bpf/Makefile          |  1 +
 .../bpf/progs/test_bpf_redirect_ifb.c         | 13 ++++
 .../selftests/bpf/test_bpf_redirect_ifb.sh    | 73 +++++++++++++++++++
 3 files changed, 87 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/test_bpf_redirect_ifb.c
 create mode 100755 tools/testing/selftests/bpf/test_bpf_redirect_ifb.sh

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 5d42db2e129a..6ec8b97af0ea 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -65,6 +65,7 @@ TEST_PROGS := test_kmod.sh \
 	test_xdp_vlan_mode_native.sh \
 	test_lwt_ip_encap.sh \
 	test_tcp_check_syncookie.sh \
+	test_bpf_redirect_ifb.sh \
 	test_tc_tunnel.sh \
 	test_tc_edt.sh \
 	test_xdping.sh \
diff --git a/tools/testing/selftests/bpf/progs/test_bpf_redirect_ifb.c b/tools/testing/selftests/bpf/progs/test_bpf_redirect_ifb.c
new file mode 100644
index 000000000000..8b960cd8786b
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_bpf_redirect_ifb.c
@@ -0,0 +1,13 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 DiDi Global */
+
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+SEC("redirect_ifb")
+int redirect(struct __sk_buff *skb)
+{
+	return bpf_redirect(skb->ifindex + 1 /* ifbX */, 0);
+}
+
+char __license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/test_bpf_redirect_ifb.sh b/tools/testing/selftests/bpf/test_bpf_redirect_ifb.sh
new file mode 100755
index 000000000000..0933439696ab
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_bpf_redirect_ifb.sh
@@ -0,0 +1,73 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+
+# Topology:
+# ---------
+#      n1 namespace    |     n2 namespace
+#                      |
+#      -----------     |     ----------------
+#      |  veth0  | --------- |  veth1, ifb1 |
+#      -----------   peer    ----------------
+#
+
+readonly prefix="ns-$$-"
+readonly ns1="${prefix}1"
+readonly ns2="${prefix}2"
+readonly ns1_addr=192.168.1.1
+readonly ns2_addr=192.168.1.2
+
+setup() {
+	echo "Load ifb module"
+	if ! /sbin/modprobe -q -n ifb; then
+		echo "test_bpf_redirect ifb: module ifb is not found [SKIP]"
+		exit 4
+	fi
+
+	modprobe -q ifb numifbs=0
+
+	ip netns add "${ns1}"
+	ip netns add "${ns2}"
+
+	ip link add dev veth0 mtu 1500 netns "${ns1}" type veth \
+	      peer name veth1 mtu 1500 netns "${ns2}"
+	# ifb1 created after veth1
+	ip link add dev ifb1 mtu 1500 netns "${ns2}" type ifb
+
+	ip -netns "${ns1}" link set veth0 up
+	ip -netns "${ns2}" link set veth1 up
+	ip -netns "${ns2}" link set ifb1 up
+	ip -netns "${ns1}" -4 addr add "${ns1_addr}/24" dev veth0
+	ip -netns "${ns2}" -4 addr add "${ns2_addr}/24" dev veth1
+
+	ip netns exec "${ns2}" tc qdisc add dev veth1 clsact
+}
+
+cleanup() {
+	ip netns del "${ns2}" &>/dev/null
+	ip netns del "${ns1}" &>/dev/null
+	modprobe -r ifb
+}
+
+trap cleanup EXIT
+
+setup
+
+ip netns exec "${ns2}" tc filter add dev veth1 \
+	ingress bpf direct-action obj test_bpf_redirect_ifb.o sec redirect_ifb
+ip netns exec "${ns1}" ping -W 2 -c 2 -i 0.2 -q "${ns2_addr}" &>/dev/null
+if [ $? -ne 0 ]; then
+	echo "bpf redirect to ifb on ingress path [FAILED]"
+	exit 1
+fi
+
+ip netns exec "${ns2}" tc filter del dev veth1 ingress
+ip netns exec "${ns2}" tc filter add dev veth1 \
+	egress bpf direct-action obj test_bpf_redirect_ifb.o sec redirect_ifb
+ip netns exec "${ns1}" ping -W 2 -c 2 -i 0.2 -q "${ns2_addr}" &>/dev/null
+if [ $? -ne 0 ]; then
+	echo "bpf redirect to ifb on egress path [FAILED]"
+	exit 1
+fi
+
+echo OK
-- 
2.27.0

