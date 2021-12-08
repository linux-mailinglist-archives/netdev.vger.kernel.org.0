Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA02246D635
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 15:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235568AbhLHO65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 09:58:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235578AbhLHO6x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 09:58:53 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4E5BC061A32
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 06:55:21 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id h24so2100392pjq.2
        for <netdev@vger.kernel.org>; Wed, 08 Dec 2021 06:55:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TrstKECFk8gOGCbVkweAHPFWowtjG3x57DhZCA+QU+4=;
        b=dscF9LHcUsVaElCp7PtcObKJnL8j27bCpZl9ft2I7PmfBmRFubgfqZ4L5+4Sxer5Gu
         P1Pq367OAvl6JU7F6WwZ2WUnPXCw+ZKuVa3/NVlom3s9E3W6ysB2HS9DwIrCD39JmkUp
         pkVcd7G1nvtHaYu1X/9q5ofE4n/hTkd3qvSe9DT73gsgalpjcQA7BfakC0E1cwe5TKZG
         gh8tTupj5P5+KdAZcmf7VWpc11O3lSyymk4PaFJFpnOtGqyRDsSlryPgdI0ZqDOfK7La
         LNqPCA24m0lmLobRLB4B+cn4WgOo89jz3ZvYAkU054nl06kcmgHhmhkG1QDI0+337ksi
         vSUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TrstKECFk8gOGCbVkweAHPFWowtjG3x57DhZCA+QU+4=;
        b=b5+Zig0ad/uH2sHRTh2S5m3iCyLw1mZjU9smvO7Aeonn4vGs6gqXGtI9npCMZwhFLp
         fMC7mT8O6GA7CtdHGn5q1DAcirciy1gwRhOxP1GFnB2UcNoi2w8IR+wGExoLJWkTQ0FU
         /5p/UbZLUInjD6XFcz9CNyIChhPJlk3N4JjzLVpx3DglSPCwHkjdN1Rqn24NNHMLA6rB
         p2eqMH1Nx1E3uN7bCWJHEF4OoL81WjB9NJGtveTBc7IdMvHRwddQsbR1CEYp/D+flzvl
         IhMxBMmUaHWQADXvJbatIYnzbRunbsIDow14hLqFeM6ahjj9Rqjt3JitgKtmmBq4ULaA
         Iymg==
X-Gm-Message-State: AOAM533MxoNCq6QBcq+QnfIEXOdeR7r3TV/y17fm4UhNOxuoZ9Gj+yX6
        OFAZUQCJAg5rE/wRpyITKL77clt9bD+DVA==
X-Google-Smtp-Source: ABdhPJwmeDWpGZAnbSJuVIms8oErJt8T0/jXa+u5MSMMsNohPxEbGFQxh0fUutbR5Zwy/CKhjNRYHA==
X-Received: by 2002:a17:903:22c4:b0:141:deda:a744 with SMTP id y4-20020a17090322c400b00141dedaa744mr60416374plg.25.1638975321023;
        Wed, 08 Dec 2021 06:55:21 -0800 (PST)
Received: from bogon.xiaojukeji.com ([111.201.150.233])
        by smtp.gmail.com with ESMTPSA id kk7sm7562763pjb.19.2021.12.08.06.55.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Dec 2021 06:55:20 -0800 (PST)
From:   xiangxia.m.yue@gmail.com
To:     netdev@vger.kernel.org
Cc:     Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Antoine Tenart <atenart@kernel.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Wei Wang <weiwan@google.com>, Arnd Bergmann <arnd@arndb.de>
Subject: [net v5 3/3] selftests: bpf: add bpf_redirect to ifb
Date:   Wed,  8 Dec 2021 22:54:59 +0800
Message-Id: <20211208145459.9590-4-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20211208145459.9590-1-xiangxia.m.yue@gmail.com>
References: <20211208145459.9590-1-xiangxia.m.yue@gmail.com>
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

