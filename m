Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 639A44E6484
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 14:57:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346540AbiCXN6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 09:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350696AbiCXN6t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 09:58:49 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F878AC046
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 06:57:17 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id s11so4012094pfu.13
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 06:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cGjdAn3X5Xn7Njp4qqsz1FMGmZpYJRwbD19LSouBYgg=;
        b=XvDFIjjnOb9BPXwmsXDnbGsoHg4Zl8o5ATohsZyM7RQGE6i8xhi8v7MIrvepVeaNld
         ueP0ksRZcJSOACafBOBw58LONxIqSnrkAud4B3JRJrhGzZwUJmi95iJQEeZQapW6EidE
         7gRRQ9Bdt1oiPPEH7uLYM9MmkYCzfSk13pVtO6OSm4TdmqTbkCJsop8rF+zI1NdgfuOx
         HIududsh92gSdwScXLuS6f8tuhmyBPub5rI6On8KPsI2NVCNIEC6FcckPnW8rjAqRznS
         83UUlh9thmcDFLdQ6tQrkXQhwAVst7PNX1q25BIjBLIoNo+8HZzf4JE8oZFkG2mGrZ7w
         zzwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cGjdAn3X5Xn7Njp4qqsz1FMGmZpYJRwbD19LSouBYgg=;
        b=dV5AB9sDr/bw+qQE7oP9M4CDR/LNAUpwtrukvkHV6xMY1wAWTX8+epb6tiLJEljLVz
         fhGD1wuvEFBVZKNCzu5yma7dbcdskNtMDB2T2gk0oheidlMZad0MetMJuVUSeuzOLEof
         bbRanIOVFkOayieYZS5ssSEb30WqEFzuh+Ato/Mt+afZufQydumQpzJDCu75ffR/nh61
         OSXYwsEz/FofnmzElZRotFfWLVM7lSxSxUhMwwVoLRUrtBzvDChF1U57jOf2C62JodrX
         8joEZt0WZmSfY3OACbks4z0fksXSlRyQv23ZbzO2cuc8JnUblW0RvG2gJBfLP1sTRItm
         HN/Q==
X-Gm-Message-State: AOAM532kpiolivTtbZ0vxzEsE0IqV0CiyhXzFPI5onmAYgIIM3SWNbz+
        NQke4z+1deOKaQUpVdf+CUq2QLINfGg2qQ==
X-Google-Smtp-Source: ABdhPJx4/U0VItcyWk3H2+TST2M1RCeeleeY5fTHxyH0PedejDZNjU6PDeRAfcdWJFITVrgNL/wGUg==
X-Received: by 2002:a65:6a4a:0:b0:380:fd52:1677 with SMTP id o10-20020a656a4a000000b00380fd521677mr4052650pgu.597.1648130236711;
        Thu, 24 Mar 2022 06:57:16 -0700 (PDT)
Received: from localhost.localdomain ([111.204.182.106])
        by smtp.gmail.com with ESMTPSA id i9-20020a17090a2a0900b001c6e540fb6asm3282991pjd.13.2022.03.24.06.57.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Mar 2022 06:57:16 -0700 (PDT)
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
Subject: [net v6 2/2] selftests: bpf: add bpf_redirect to ifb
Date:   Thu, 24 Mar 2022 21:56:53 +0800
Message-Id: <20220324135653.2189-3-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20220324135653.2189-1-xiangxia.m.yue@gmail.com>
References: <20220324135653.2189-1-xiangxia.m.yue@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
 .../selftests/bpf/test_bpf_redirect_ifb.sh    | 64 +++++++++++++++++++
 3 files changed, 78 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/test_bpf_redirect_ifb.c
 create mode 100755 tools/testing/selftests/bpf/test_bpf_redirect_ifb.sh

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 3820608faf57..7de55ec0b0bb 100644
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
index 000000000000..c599aa0ec22e
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_bpf_redirect_ifb.sh
@@ -0,0 +1,64 @@
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
+echo OK
-- 
2.27.0

