Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE677441EB2
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 17:39:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232904AbhKAQlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 12:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233051AbhKAQjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 12:39:36 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E65C061195;
        Mon,  1 Nov 2021 09:36:14 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id f8so44728761edy.4;
        Mon, 01 Nov 2021 09:36:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HssHsmqFjyLJ0KkJ+2YjhTVNGMWrkrdOlYcK+sJHwYg=;
        b=oI2hz12aXhPIqcvQ0RKyFopXLh7UcLRN6cAS5imHDAZs8q79zA+qEwL+SITv7RLqQ4
         4bguY3lPfFn7CtPLKTOlqtvbhTXdeCKQ98EOyG0FfOAEp62vzNESk8AM8X47TAV6M8bD
         ZKbdTaZvpCWHvZmVfFcCXC4yGF2mdsvguzNe2qjPPgXeh8KYVxq0owMBocKvsooW4tKf
         +P60Cz++r4APHyJGocq6+CfiP61g590IHFrsotmiya74PUkt3e/YGmk4PCcjRnTxnewG
         ItUPf+ffjUdf8coedcE9XqQu2Zm5l3lahBCi4tY0Wd3yabBeSWUi+6SwcA4IjhCi9rUG
         rsWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HssHsmqFjyLJ0KkJ+2YjhTVNGMWrkrdOlYcK+sJHwYg=;
        b=vC4YsLork5niBKxxF9YBaCJvEkfPoFZQ/YaB7HCqAWpng3DM6ogGNN7X/uB6GE1rzi
         BdqteC9iN2CTLxGlel2rRSyEKjB979IXezKGeS5Jz5Zw596IK8lTOlHqfDyPeCnPiWFx
         6FDBnE9eav7zVRyrQ9n4m9FmhPL5+r3SIwIhKy2lUJL3+uju28hHTwtqwKkfopQonZeA
         Fyo2vvLwCTH9WY5KjHeRnG6N6fupUhlltDJwIcQwVNsiDNrt5fgBAd9W5KwuePvMpXXg
         UAeOQ+qpeKJztlc9tSudtEseMlhmz/cMTpNUz/u94vmWIvGOQgGi3HeAYppcOyIySK8I
         K9Aw==
X-Gm-Message-State: AOAM533bUjErpXADDU0dqygKwSXGy4LKtnJEajeHc7Dm6eikHZY0WSFY
        pJpF3zrbTeX5tH4fCbarGb8=
X-Google-Smtp-Source: ABdhPJy1P5Z25JkWfcjDz0lLAQbjII1Wm5RLiLHl8EW2i87fA8fqv6bZDiK73MRQ2Y/V0OcrFBwgkg==
X-Received: by 2002:a17:907:2d20:: with SMTP id gs32mr38828929ejc.472.1635784572591;
        Mon, 01 Nov 2021 09:36:12 -0700 (PDT)
Received: from ponky.lan ([2a04:241e:501:3870:f5f:2085:7f25:17c])
        by smtp.gmail.com with ESMTPSA id f25sm4124583edv.90.2021.11.01.09.36.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 09:36:12 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 25/25] selftests: net/fcnal: Initial tcp_authopt support
Date:   Mon,  1 Nov 2021 18:35:00 +0200
Message-Id: <93440f1b9cebae08c1a4bc22f79941c2f4905e28.1635784253.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1635784253.git.cdleonard@gmail.com>
References: <cover.1635784253.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tests are mostly copied from tcp_md5 with minor changes.

It covers VRF support but only based on binding multiple servers: not
multiple keys bound to different interfaces.

Also add a specific -t tcp_authopt to run only these tests specifically.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 tools/testing/selftests/net/fcnal-test.sh | 249 ++++++++++++++++++++++
 1 file changed, 249 insertions(+)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 3313566ce906..d7afd9f40848 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -800,10 +800,252 @@ ipv4_ping()
 }
 
 ################################################################################
 # IPv4 TCP
 
+#
+# TCP Authentication Option Tests
+#
+
+# try to enable tcp_authopt sysctl
+enable_tcp_authopt()
+{
+	if [[ -e /proc/sys/net/ipv4/tcp_authopt ]]; then
+		sysctl -w net.ipv4.tcp_authopt=1
+	fi
+}
+
+# check if tcp_authopt is compiled with a client-side bind test
+has_tcp_authopt()
+{
+	run_cmd_nsb nettest -b -A ${MD5_PW} -r ${NSA_IP}
+}
+
+ipv4_tcp_authopt_novrf()
+{
+	enable_tcp_authopt
+	if ! has_tcp_authopt; then
+		echo "TCP-AO appears to be missing, skip"
+		return 0
+	fi
+
+	log_start
+	run_cmd nettest -s -A ${MD5_PW} -m ${NSB_IP} &
+	sleep 1
+	run_cmd_nsb nettest -r ${NSA_IP} -A ${MD5_PW}
+	log_test $? 0 "AO: Single address config"
+
+	log_start
+	run_cmd nettest -s  &
+	sleep 1
+	run_cmd_nsb nettest -r ${NSA_IP} -A ${MD5_PW}
+	log_test $? 2 "AO: Server no config, client uses password"
+
+	log_start
+	run_cmd nettest -s -A ${MD5_PW} -m ${NSB_IP} &
+	sleep 1
+	run_cmd_nsb nettest -r ${NSA_IP} -A ${MD5_WRONG_PW}
+	log_test $? 2 "AO: Client uses wrong password"
+
+	log_start
+	run_cmd nettest -s -A ${MD5_PW} -m ${NSB_LO_IP} &
+	sleep 1
+	run_cmd_nsb nettest -r ${NSA_IP} -A ${MD5_PW}
+	log_test $? 2 "AO: Client address does not match address configured on server"
+
+	# no prefixlen for AO yet
+}
+
+ipv6_tcp_authopt_novrf()
+{
+	enable_tcp_authopt
+	if ! has_tcp_authopt; then
+		echo "TCP-AO appears to be missing, skip"
+		return 0
+	fi
+
+	log_start
+	run_cmd nettest -6 -s -A ${MD5_PW} &
+	sleep 1
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -A ${MD5_PW}
+	log_test $? 0 "AO: Simple correct config"
+
+	log_start
+	run_cmd nettest -6 -s
+	sleep 1
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -A ${MD5_PW}
+	log_test $? 2 "AO: Server no config, client uses password"
+
+	log_start
+	run_cmd nettest -6 -s -A ${MD5_PW} -m ${NSB_IP6} &
+	sleep 1
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -A ${MD5_WRONG_PW}
+	log_test $? 2 "AO: Client uses wrong password"
+
+	log_start
+	run_cmd nettest -6 -s -A ${MD5_PW} -m ${NSB_LO_IP6} &
+	sleep 1
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -A ${MD5_PW}
+	log_test $? 2 "AO: Client address does not match address configured on server"
+
+	# no prefixlen for AO yet
+}
+
+ipv4_tcp_authopt_vrf()
+{
+	enable_tcp_authopt
+	if ! has_tcp_authopt; then
+		echo "TCP-AO appears to be missing, skip"
+		return 0
+	fi
+
+	log_start
+	run_cmd nettest -s -I ${VRF} -A ${MD5_PW} &
+	sleep 1
+	run_cmd_nsb nettest -r ${NSA_IP} -A ${MD5_PW}
+	log_test $? 0 "AO: VRF: Simple config"
+
+	#
+	# duplicate config between default VRF and a VRF
+	#
+
+	log_start
+	run_cmd nettest -s -I ${VRF} -A ${MD5_PW} -m ${NSB_IP} &
+	run_cmd nettest -s -A ${MD5_WRONG_PW} -m ${NSB_IP} &
+	sleep 1
+	run_cmd_nsb nettest -r ${NSA_IP} -A ${MD5_PW}
+	log_test $? 0 "AO: VRF: Servers in default-VRF and VRF, client in VRF"
+
+	log_start
+	run_cmd nettest -s -I ${VRF} -A ${MD5_PW} -m ${NSB_IP} &
+	run_cmd nettest -s -A ${MD5_WRONG_PW} -m ${NSB_IP} &
+	sleep 1
+	run_cmd_nsc nettest -r ${NSA_IP} -A ${MD5_WRONG_PW}
+	log_test $? 0 "AO: VRF: Servers in default-VRF and VRF, client in default-VRF"
+
+	log_start
+	show_hint "Should timeout since client in default VRF uses VRF password"
+	run_cmd nettest -s -I ${VRF} -A ${MD5_PW} -m ${NSB_IP} &
+	run_cmd nettest -s -A ${MD5_WRONG_PW} -m ${NSB_IP} &
+	sleep 1
+	run_cmd_nsc nettest -r ${NSA_IP} -A ${MD5_PW}
+	log_test $? 2 "AO: VRF: Servers in default VRF and VRF, conn in default-VRF with VRF pw"
+
+	log_start
+	show_hint "Should timeout since client in VRF uses default VRF password"
+	run_cmd nettest -s -I ${VRF} -A ${MD5_PW} -m ${NSB_IP} &
+	run_cmd nettest -s -A ${MD5_WRONG_PW} -m ${NSB_IP} &
+	sleep 1
+	run_cmd_nsb nettest -r ${NSA_IP} -A ${MD5_WRONG_PW}
+	log_test $? 2 "AO: VRF: Servers in default VRF and VRF, conn in VRF with default-VRF pw"
+
+	test_ipv4_tcp_authopt_vrf__global_server__bind_ifindex0
+}
+
+test_ipv4_tcp_authopt_vrf__global_server__bind_ifindex0()
+{
+	# This particular test needs tcp_l3mdev_accept=1 for Global server to accept VRF connections
+	local old_tcp_l3mdev_accept
+	old_tcp_l3mdev_accept=$(get_sysctl net.ipv4.tcp_l3mdev_accept)
+	set_sysctl net.ipv4.tcp_l3mdev_accept=1
+
+	log_start
+	run_cmd nettest -s -A ${MD5_PW} --force-bind-key-ifindex &
+	sleep 1
+	run_cmd_nsb nettest -r ${NSA_IP} -A ${MD5_PW}
+	log_test $? 2 "AO: VRF: Global server, Key bound to ifindex=0 rejects VRF connection"
+
+	log_start
+	run_cmd nettest -s -A ${MD5_PW} --force-bind-key-ifindex &
+	sleep 1
+	run_cmd_nsc nettest -r ${NSA_IP} -A ${MD5_PW}
+	log_test $? 0 "AO: VRF: Global server, key bound to ifindex=0 accepts non-VRF connection"
+	log_start
+
+	run_cmd nettest -s -A ${MD5_PW} --no-bind-key-ifindex &
+	sleep 1
+	run_cmd_nsb nettest -r ${NSA_IP} -A ${MD5_PW}
+	log_test $? 0 "AO: VRF: Global server, key not bound to ifindex accepts VRF connection"
+
+	log_start
+	run_cmd nettest -s -A ${MD5_PW} --no-bind-key-ifindex &
+	sleep 1
+	run_cmd_nsc nettest -r ${NSA_IP} -A ${MD5_PW}
+	log_test $? 0 "AO: VRF: Global server, key not bound to ifindex accepts non-VRF connection"
+
+	# restore value
+	set_sysctl net.ipv4.tcp_l3mdev_accept="$old_tcp_l3mdev_accept"
+}
+
+ipv6_tcp_authopt_vrf()
+{
+	enable_tcp_authopt
+	if ! has_tcp_authopt; then
+		echo "TCP-AO appears to be missing, skip"
+		return 0
+	fi
+
+	log_start
+	run_cmd nettest -6 -s -I ${VRF} -A ${MD5_PW} &
+	sleep 1
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -A ${MD5_PW}
+	log_test $? 0 "AO: VRF: Simple config"
+
+	#
+	# duplicate config between default VRF and a VRF
+	#
+
+	log_start
+	run_cmd nettest -6 -s -I ${VRF} -A ${MD5_PW} -m ${NSB_IP6} &
+	run_cmd nettest -6 -s -A ${MD5_WRONG_PW} -m ${NSB_IP6} &
+	sleep 1
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -A ${MD5_PW}
+	log_test $? 0 "AO: VRF: Servers in default-VRF and VRF, client in VRF"
+
+	log_start
+	run_cmd nettest -6 -s -I ${VRF} -A ${MD5_PW} -m ${NSB_IP6} &
+	run_cmd nettest -6 -s -A ${MD5_WRONG_PW} -m ${NSB_IP6} &
+	sleep 1
+	run_cmd_nsc nettest -6 -r ${NSA_IP6} -A ${MD5_WRONG_PW}
+	log_test $? 0 "AO: VRF: Servers in default-VRF and VRF, client in default-VRF"
+
+	log_start
+	show_hint "Should timeout since client in default VRF uses VRF password"
+	run_cmd nettest -6 -s -I ${VRF} -A ${MD5_PW} -m ${NSB_IP6} &
+	run_cmd nettest -6 -s -A ${MD5_WRONG_PW} -m ${NSB_IP6} &
+	sleep 1
+	run_cmd_nsc nettest -6 -r ${NSA_IP6} -A ${MD5_PW}
+	log_test $? 2 "AO: VRF: Servers in default VRF and VRF, conn in default-VRF with VRF pw"
+
+	log_start
+	show_hint "Should timeout since client in VRF uses default VRF password"
+	run_cmd nettest -6 -s -I ${VRF} -A ${MD5_PW} -m ${NSB_IP6} &
+	run_cmd nettest -6 -s -A ${MD5_WRONG_PW} -m ${NSB_IP6} &
+	sleep 1
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -A ${MD5_WRONG_PW}
+	log_test $? 2 "AO: VRF: Servers in default VRF and VRF, conn in VRF with default-VRF pw"
+}
+
+only_tcp_authopt()
+{
+	log_section "TCP Authentication Option"
+
+	setup
+	set_sysctl net.ipv4.tcp_l3mdev_accept=0
+	log_subsection "TCP-AO IPv4 no VRF"
+	ipv4_tcp_authopt_novrf
+	log_subsection "TCP-AO IPv6 no VRF"
+	ipv6_tcp_authopt_novrf
+
+	setup "yes"
+	set_sysctl net.ipv4.tcp_l3mdev_accept=0
+	log_subsection "TCP-AO IPv4 VRF"
+	ipv4_tcp_authopt_vrf
+	log_subsection "TCP-AO IPv6 VRF"
+	ipv6_tcp_authopt_vrf
+}
+
 #
 # MD5 tests without VRF
 #
 ipv4_tcp_md5_novrf()
 {
@@ -1185,10 +1427,11 @@ ipv4_tcp_novrf()
 	show_hint "Should fail 'Connection refused'"
 	run_cmd nettest -d ${NSA_DEV} -r ${a}
 	log_test_addr ${a} $? 1 "No server, device client, local conn"
 
 	ipv4_tcp_md5_novrf
+	ipv4_tcp_authopt_novrf
 }
 
 ipv4_tcp_vrf()
 {
 	local a
@@ -1239,10 +1482,12 @@ ipv4_tcp_vrf()
 	run_cmd nettest -r ${a} -d ${NSA_DEV}
 	log_test_addr ${a} $? 1 "Global server, local connection"
 
 	# run MD5 tests
 	ipv4_tcp_md5
+	# run AO tests
+	ipv6_tcp_md5_vrf
 
 	#
 	# enable VRF global server
 	#
 	log_subsection "VRF Global server enabled"
@@ -2648,10 +2893,11 @@ ipv6_tcp_novrf()
 		run_cmd nettest -6 -d ${NSA_DEV} -r ${a}
 		log_test_addr ${a} $? 1 "No server, device client, local conn"
 	done
 
 	ipv6_tcp_md5_novrf
+	ipv6_tcp_authopt_novrf
 }
 
 ipv6_tcp_vrf()
 {
 	local a
@@ -2718,10 +2964,12 @@ ipv6_tcp_vrf()
 	run_cmd nettest -6 -r ${a} -d ${NSA_DEV}
 	log_test_addr ${a} $? 1 "Global server, local connection"
 
 	# run MD5 tests
 	ipv6_tcp_md5
+	# run AO tests
+	ipv6_tcp_authopt_vrf
 
 	#
 	# enable VRF global server
 	#
 	log_subsection "VRF Global server enabled"
@@ -4062,10 +4310,11 @@ do
 	ipv6_bind|bind6) ipv6_addr_bind;;
 	ipv6_runtime)    ipv6_runtime;;
 	ipv6_netfilter)  ipv6_netfilter;;
 
 	use_cases)       use_cases;;
+	tcp_authopt)     only_tcp_authopt;;
 
 	# setup namespaces and config, but do not run any tests
 	setup)		 setup; exit 0;;
 	vrf_setup)	 setup "yes"; exit 0;;
 
-- 
2.25.1

