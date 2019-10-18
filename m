Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03093DBC39
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 06:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407379AbfJRE61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 00:58:27 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:41552 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395367AbfJRE61 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 00:58:27 -0400
Received: by mail-pl1-f193.google.com with SMTP id t10so2238403plr.8;
        Thu, 17 Oct 2019 21:58:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HICHf2lFRFrLIdIYZu0hb5n6fSttUUKMQ4YCvonchCA=;
        b=HPTxPD7rANku4IkMuWjfQInEz9yxT550MOCx7UaYk/aLn5CzYuFFIqxUF6vk+uMANF
         0cKdqmRp0kiDalBryBu4eTrgEJ3GX0mZ9l0U7vLIYVuMt8UutPmmJjlQoLqzNzjhPxl9
         AgHFCPD4rdgtt0sFfkV7Q292aDPZJzqP8zijdmZlVnBnCnJXiyax8Tiz8abu0I7VvHjf
         8AaJ5hcbj5JWoeq4ktsZHN0XAfT+r74t4djelTc/bgY1p9uqKb9bbtQynWq7qvdiJQPt
         jUF95/6m3JDwuv/dX17E/yecTbm/OAuhxcFU4pKH3HrAD2yrAklkuHzHP5KSUqfLjv0d
         65eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HICHf2lFRFrLIdIYZu0hb5n6fSttUUKMQ4YCvonchCA=;
        b=eFEs1upaLy698nnT9cfWKsGeJ5BbW4Y7IdOBIoNCkiG80b7iAsupXKd4Iv1wErxxKB
         5mJO0BhrEbeHxVMWItrpTIXwZAWTkVICRL+poAdJQmwfSlJ3EkKZLgB4h50Lz6AKOGGr
         WaXK44nIjdswSjMuRfbelwc+DsIsU7UpuivpWgqr9++/zRZ8k6Rpq/sg8kMFuwJ7bX5Q
         x6bRzuBRl1wvxFeEEPBbXAMAPj9gLWdkiOD8MRvS+1gND9b4fsGHuhc5rsH3s+WHSO9V
         3ua6Zkh3fc6FdkvEIxXWPp7jO9GqcZ26b72B8ScJBq7EfgtPXHb2OXhRc/7n+aJ/LxBN
         nJDg==
X-Gm-Message-State: APjAAAVCmA3R1jnf/NBDwE8lp5cXkdOTIpSilB92iqrCSUCr9oQEMPNh
        finoqoUK0TapXCIxI7AZyjsHu8B/
X-Google-Smtp-Source: APXvYqwv8HykLmT11neueFQ7bIQVAXRDpzD2/K8c/pH6n1kuT+hVG3pyYs8w66GRzdcoowrgM8omZQ==
X-Received: by 2002:a17:902:14f:: with SMTP id 73mr7684854plb.87.1571371765474;
        Thu, 17 Oct 2019 21:09:25 -0700 (PDT)
Received: from z400-fedora29.kern.oss.ntt.co.jp ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id d11sm4341680pfo.104.2019.10.17.21.09.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 21:09:24 -0700 (PDT)
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Pravin B Shelar <pshelar@ovn.org>
Cc:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        William Tu <u9012063@gmail.com>,
        Stanislav Fomichev <sdf@fomichev.me>
Subject: [RFC PATCH v2 bpf-next 13/15] bpf, selftest: Add test for xdp_flow
Date:   Fri, 18 Oct 2019 13:07:46 +0900
Message-Id: <20191018040748.30593-14-toshiaki.makita1@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018040748.30593-1-toshiaki.makita1@gmail.com>
References: <20191018040748.30593-1-toshiaki.makita1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Check if TC flow offloading to XDP works.

Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
---
 tools/testing/selftests/bpf/Makefile         |   1 +
 tools/testing/selftests/bpf/test_xdp_flow.sh | 106 +++++++++++++++++++++++++++
 2 files changed, 107 insertions(+)
 create mode 100755 tools/testing/selftests/bpf/test_xdp_flow.sh

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 00d05c5..3db9819 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -55,6 +55,7 @@ TEST_PROGS := test_kmod.sh \
 	test_xdp_redirect.sh \
 	test_xdp_meta.sh \
 	test_xdp_veth.sh \
+	test_xdp_flow.sh \
 	test_offload.py \
 	test_sock_addr.sh \
 	test_tunnel.sh \
diff --git a/tools/testing/selftests/bpf/test_xdp_flow.sh b/tools/testing/selftests/bpf/test_xdp_flow.sh
new file mode 100755
index 0000000..6937454
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_xdp_flow.sh
@@ -0,0 +1,106 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+#
+# Create 2 namespaces with 2 veth peers, and
+# forward packets in-between using xdp_flow
+#
+# NS1(veth11)        NS2(veth22)
+#      |                  |
+#      |                  |
+#   (veth1)            (veth2)
+#      ^                  ^
+#      |     xdp_flow     |
+#      --------------------
+
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+
+TESTNAME=xdp_flow
+
+_cleanup()
+{
+	set +e
+	ip link del veth1 2> /dev/null
+	ip link del veth2 2> /dev/null
+	ip netns del ns1 2> /dev/null
+	ip netns del ns2 2> /dev/null
+}
+
+cleanup_skip()
+{
+	echo "selftests: $TESTNAME [SKIP]"
+	_cleanup
+
+	exit $ksft_skip
+}
+
+cleanup()
+{
+	if [ "$?" = 0 ]; then
+		echo "selftests: $TESTNAME [PASS]"
+	else
+		echo "selftests: $TESTNAME [FAILED]"
+	fi
+	_cleanup
+}
+
+if [ $(id -u) -ne 0 ]; then
+	echo "selftests: $TESTNAME [SKIP] Need root privileges"
+	exit $ksft_skip
+fi
+
+if ! ip link set dev lo xdp off > /dev/null 2>&1; then
+	echo "selftests: $TESTNAME [SKIP] Could not run test without the ip xdp support"
+	exit $ksft_skip
+fi
+
+set -e
+
+trap cleanup_skip EXIT
+
+ip netns add ns1
+ip netns add ns2
+
+ip link add veth1 type veth peer name veth11 netns ns1
+ip link add veth2 type veth peer name veth22 netns ns2
+
+ip link set veth1 up
+ip link set veth2 up
+
+ip -n ns1 addr add 10.1.1.11/24 dev veth11
+ip -n ns2 addr add 10.1.1.22/24 dev veth22
+
+ip -n ns1 link set dev veth11 up
+ip -n ns2 link set dev veth22 up
+
+ip -n ns1 link set dev veth11 xdp obj xdp_dummy.o sec xdp_dummy
+ip -n ns2 link set dev veth22 xdp obj xdp_dummy.o sec xdp_dummy
+
+ethtool -K veth1 flow-offload-xdp on
+ethtool -K veth2 flow-offload-xdp on
+
+trap cleanup EXIT
+
+# Adding clsact or ingress will trigger loading bpf prog in UMH
+tc qdisc add dev veth1 clsact
+tc qdisc add dev veth2 clsact
+
+# Adding filter will have UMH populate flow table map
+tc filter add dev veth1 ingress protocol ip flower \
+	dst_ip 10.1.1.0/24 action mirred egress redirect dev veth2
+tc filter add dev veth2 ingress protocol ip flower \
+	dst_ip 10.1.1.0/24 action mirred egress redirect dev veth1
+
+# flows should be offloaded when 'flow-offload-xdp' is enabled on veth
+tc filter show dev veth1 ingress | grep -q not_in_hw && false
+tc filter show dev veth2 ingress | grep -q not_in_hw && false
+
+# ARP is not supported so add filters after in_hw check
+tc filter add dev veth1 ingress protocol arp flower \
+	arp_tip 10.1.1.0/24 action mirred egress redirect dev veth2
+tc filter add dev veth2 ingress protocol arp flower \
+	arp_sip 10.1.1.0/24 action mirred egress redirect dev veth1
+
+ip netns exec ns1 ping -c 1 -W 1 10.1.1.22
+
+exit 0
-- 
1.8.3.1

