Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D63F460E40
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 05:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232611AbhK2FBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 00:01:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239218AbhK2E7Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Nov 2021 23:59:24 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F977C0613DD
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 20:55:26 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id j6-20020a17090a588600b001a78a5ce46aso14591307pji.0
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 20:55:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2tgWJcHuCeT/qGLGpdTorajcshX7da/TcHZxbHFv3C8=;
        b=O/SaN7LxiPIneVD8135QuHux5XNs5Lj8yywGPXBL48DLLfAt8T6qkfOUna0dCjBkoe
         xK5AeV6uOTfmLGx5WZeMZyLB1/s4Q/cF/ea+nbFam7lYq7st95ed+M2KO9BXS5TiSIHN
         GbYjkbaXC8z3EaNWgCxvwXd9yCmhg6BBqpdxNwsFm9jhe2dQtEJJSJeUdAY8sYtgrXGg
         GUArqNCmlndWz7I2P0ai2+CciEPw+E6X7QkAbWVmUlNfbgQy6lbPoo6Mity9PlZRWeKn
         KavGl3CxQt0MCBGO7MNGm98b0J5/tLgOVz9sgPt467LJK7E9V0nZB6YZw8MIt2A/v6WE
         2xfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2tgWJcHuCeT/qGLGpdTorajcshX7da/TcHZxbHFv3C8=;
        b=XptD+MiEitAkqwpFsl1Wkhb6Dc98C4lokmPral9ti8PnDCpv1wnzc/5enP4DJSZkkV
         R+T0+gGURj6Ch1wFSl0ZFCBJbwSO2IDiBcgUBOXXJqPOgKAvB8n20J10NTxrt8USxoFi
         4T5bhrgS0BZiMLE65iXAx/2q1fxtU5d0ydi4dnQ7z0/SakGCoEKG89bzEqN+Ry/GFA6y
         z5hQ09DWqVhCL2Hl1BdFlsUcdcV1Ft76JnCO9RNvtwhZNpGRq/aCb97b8abRhnSU0nf3
         lj1vQx/fV+jXNGgoGaxTAVCmLlZdWav3/fiMmq8u79AAEebeYAvBUmOPBLia8vsalzst
         EJKA==
X-Gm-Message-State: AOAM532cdoUUb5w67unS3+PGnUtLIckdCclO+82ihU4YAts/NRIvDgu6
        zfD98FSxVARXuSqrktX0r32HfLT/E8iH4g==
X-Google-Smtp-Source: ABdhPJyY8wQlR84YHCVha2QjT6V+0E1NmVU+mzo1Ihph9IEdLVXmUALa2RwexsIZvN6j0akLkEivqQ==
X-Received: by 2002:a17:903:31d1:b0:141:f14b:6ebd with SMTP id v17-20020a17090331d100b00141f14b6ebdmr56959881ple.75.1638161725599;
        Sun, 28 Nov 2021 20:55:25 -0800 (PST)
Received: from localhost.localdomain ([111.204.182.106])
        by smtp.gmail.com with ESMTPSA id p33sm10781329pgm.85.2021.11.28.20.55.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 28 Nov 2021 20:55:25 -0800 (PST)
From:   xiangxia.m.yue@gmail.com
To:     netdev@vger.kernel.org
Cc:     Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
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
        Wei Wang <weiwan@google.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [net v3 3/3] selftests: bpf: add bpf_redirect to ifb
Date:   Mon, 29 Nov 2021 12:55:03 +0800
Message-Id: <20211129045503.20217-3-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20211129045503.20217-1-xiangxia.m.yue@gmail.com>
References: <20211129045503.20217-1-xiangxia.m.yue@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

ifb netdev is used for queueing incoming traffic for shaping.
we may run bpf progs in tc cls hook(ingress or egress), to
redirect the packets to ifb.

This patch adds this test, for bpf.

Cc: Willem de Bruijn <willemb@google.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>
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
Cc: "Björn Töpel" <bjorn@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 tools/testing/selftests/bpf/Makefile          |  1 +
 .../bpf/progs/test_bpf_redirect_ifb.c         | 10 +++
 .../selftests/bpf/test_bpf_redirect_ifb.sh    | 73 +++++++++++++++++++
 3 files changed, 84 insertions(+)
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
index 000000000000..d3205ad5e35a
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_bpf_redirect_ifb.c
@@ -0,0 +1,10 @@
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

