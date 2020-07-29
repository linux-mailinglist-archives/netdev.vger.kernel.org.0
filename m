Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83DC7231BB0
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 10:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbgG2I5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 04:57:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbgG2I5S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 04:57:18 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B8DAC061794
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 01:57:18 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id k27so13921746pgm.2
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 01:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IJ5LeaVHy5mQWJEER9wDxn8CpiD4h3uy/GMSnm1xT00=;
        b=HefZ9yJvvnvOKqX9aOuqhlYZ6wHIemEUR1kmO222RfMyjlhJwDgFpgehE4F6r98j2C
         a2ep29I/QO4BgbQhSwPvVhMduIs1UjLFl0N6uOEgV85ZDo0XU1+bSBVvLyM/496DM3fS
         o8rDRBA/cWLpcE25ZP3yPrg9skMC3svRlxmLc+VJ+o3AVtkFOZ0xN5v5wmjIUQRHAEi8
         k27ePPqVpnvc5NGx4YVQojhLBhbStW6fjJztpc8mhR9D+BL25eEEaWIsEph+MTJvU7i5
         KczoTmsdaObOtygYj5TTqaMI2rIsrErtIZIWfHeIUxjKLwO8WTve/1dq2BTxswW9VHCJ
         yx3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IJ5LeaVHy5mQWJEER9wDxn8CpiD4h3uy/GMSnm1xT00=;
        b=ZxRFWzNTLbYpffI9CJZrPb2nFuOQ5wNF4C1LqM881LYkYgzPpJqA10mTsHfgnGaNCZ
         WfxxD8ucLOd5HRETMr7IVLM771IwoCRp3A9mlFyEjp0wQScTNnj8ETnvxjYR+OPo10Ad
         ddxWokqbeMRMYvH7t8qnhEXXZIp/nRCov9AFs9y1rm6r9fJLIVdiP0dBh7jMLOvWvdwJ
         JF8ouuXan8HRKUeQmd8hn2g0He1ADOEF3m22n+YPiCxGQ2+l0d1ov2+cO7p7rFTWrkwq
         VvukT8/msJlNimrzOYTE5f7nkNucwEMb3ys4AnXTMZ0oJ5j21H3DHhSLHTxnj5UWMGeC
         x4mQ==
X-Gm-Message-State: AOAM530QACw/YrmKhEGHoIpmT+nUimcIVPjuZ6JE94dE+5yHrYfAsLJm
        SzzVo44ce0HnrcCLwE/hXSCcL7EbB7GIAw==
X-Google-Smtp-Source: ABdhPJx46sM0v+5WwB2x5qYdjy7a9SlKgvwmLDUhNixid1SiO6xeJIUFu4i/Ow7dIUXBSafbjoOxnw==
X-Received: by 2002:a63:5004:: with SMTP id e4mr28845685pgb.208.1596013037318;
        Wed, 29 Jul 2020 01:57:17 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o11sm1548916pfp.88.2020.07.29.01.57.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2020 01:57:16 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     William Tu <u9012063@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net] selftests/bpf: add xdpdrv mode for test_xdp_redirect
Date:   Wed, 29 Jul 2020 16:56:58 +0800
Message-Id: <20200729085658.403794-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add xdpdrv mode for test_xdp_redirect.sh since veth has
support native mode. After update here is the test result:

]# ./test_xdp_redirect.sh
selftests: test_xdp_redirect xdpgeneric [PASS]
selftests: test_xdp_redirect xdpdrv [PASS]

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 .../selftests/bpf/test_xdp_redirect.sh        | 84 ++++++++++++-------
 1 file changed, 52 insertions(+), 32 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_xdp_redirect.sh b/tools/testing/selftests/bpf/test_xdp_redirect.sh
index c4b17e08d431..dd80f0c84afb 100755
--- a/tools/testing/selftests/bpf/test_xdp_redirect.sh
+++ b/tools/testing/selftests/bpf/test_xdp_redirect.sh
@@ -10,52 +10,72 @@
 #     | xdp forwarding |
 #     ------------------
 
-cleanup()
+ret=0
+
+setup()
 {
-	if [ "$?" = "0" ]; then
-		echo "selftests: test_xdp_redirect [PASS]";
-	else
-		echo "selftests: test_xdp_redirect [FAILED]";
-	fi
 
-	set +e
+	local xdpmode=$1
+
+	ip netns add ns1
+	ip netns add ns2
+
+	ip link add veth1 index 111 type veth peer name veth11 netns ns1
+	ip link add veth2 index 222 type veth peer name veth22 netns ns2
+
+	ip link set veth1 up
+	ip link set veth2 up
+	ip -n ns1 link set dev veth11 up
+	ip -n ns2 link set dev veth22 up
+
+	ip -n ns1 addr add 10.1.1.11/24 dev veth11
+	ip -n ns2 addr add 10.1.1.22/24 dev veth22
+}
+
+cleanup()
+{
 	ip link del veth1 2> /dev/null
 	ip link del veth2 2> /dev/null
 	ip netns del ns1 2> /dev/null
 	ip netns del ns2 2> /dev/null
 }
 
-ip link set dev lo xdpgeneric off 2>/dev/null > /dev/null
-if [ $? -ne 0 ];then
-	echo "selftests: [SKIP] Could not run test without the ip xdpgeneric support"
-	exit 0
-fi
-set -e
-
-ip netns add ns1
-ip netns add ns2
+test_xdp_redirect()
+{
+	local xdpmode=$1
 
-trap cleanup 0 2 3 6 9
+	setup
 
-ip link add veth1 index 111 type veth peer name veth11
-ip link add veth2 index 222 type veth peer name veth22
+	ip link set dev veth1 $xdpmode off &> /dev/null
+	if [ $? -ne 0 ];then
+		echo "selftests: test_xdp_redirect $xdpmode [SKIP]"
+		return 0
+	fi
 
-ip link set veth11 netns ns1
-ip link set veth22 netns ns2
+	ip -n ns1 link set veth11 $xdpmode obj xdp_dummy.o sec xdp_dummy &> /dev/null
+	ip -n ns2 link set veth22 $xdpmode obj xdp_dummy.o sec xdp_dummy &> /dev/null
+	ip link set dev veth1 $xdpmode obj test_xdp_redirect.o sec redirect_to_222 &> /dev/null
+	ip link set dev veth2 $xdpmode obj test_xdp_redirect.o sec redirect_to_111 &> /dev/null
 
-ip link set veth1 up
-ip link set veth2 up
+	ip netns exec ns1 ping -c 1 10.1.1.22 &> /dev/null
+	local ret1=$?
+	ip netns exec ns2 ping -c 1 10.1.1.11 &> /dev/null
+	local ret2=$?
 
-ip netns exec ns1 ip addr add 10.1.1.11/24 dev veth11
-ip netns exec ns2 ip addr add 10.1.1.22/24 dev veth22
+	if [ $ret1 -eq 0 -a $ret2 -eq 0 ]; then
+		echo "selftests: test_xdp_redirect $xdpmode [PASS]";
+	else
+		ret=1
+		echo "selftests: test_xdp_redirect $xdpmode [FAILED]";
+	fi
 
-ip netns exec ns1 ip link set dev veth11 up
-ip netns exec ns2 ip link set dev veth22 up
+	cleanup
+}
 
-ip link set dev veth1 xdpgeneric obj test_xdp_redirect.o sec redirect_to_222
-ip link set dev veth2 xdpgeneric obj test_xdp_redirect.o sec redirect_to_111
+set -e
+trap cleanup 2 3 6 9
 
-ip netns exec ns1 ping -c 1 10.1.1.22
-ip netns exec ns2 ping -c 1 10.1.1.11
+test_xdp_redirect xdpgeneric
+test_xdp_redirect xdpdrv
 
-exit 0
+exit $ret
-- 
2.25.4

