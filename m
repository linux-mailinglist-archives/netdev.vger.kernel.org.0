Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B05F5580B7A
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 08:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237993AbiGZGVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 02:21:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237880AbiGZGTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 02:19:02 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8088A2AC6B;
        Mon, 25 Jul 2022 23:16:33 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id ez10so24187069ejc.13;
        Mon, 25 Jul 2022 23:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/2I8vovuVbRxCPpylldO814jP2anaEZuH9BAYw3aP+4=;
        b=WQXM/R5bH2awe/D27dAeBwQAK2lkM6Xm8S2VzAdm0FiT2N3Cj+sriqd7Ok8h7YbB9W
         zXBDYEds8M2cgX1euU1Yi8CCW4z3PDIxoXfHj/5gQmtulHuMKfF5T2CvYNSuxyjLeOut
         lICCBzT7gFFaB/w+d/EJp6X4Vtp4l/XdhdqnRLy/4rKkZsiR4+sx/Gvdom4NYeb/bRhO
         6XJ9bb7zBEYdxxll1D2u5c5W7IXWxKAR+StPNCKO/iZTY2G18DHrERz0QPh4Lnl1x0gQ
         SwifM4W/IUB0WvuouT92Vr9wDw+jX83PlZVZvMnBBEHA7lvtpbRIXgJDcMNcxiRx9GGk
         QjBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/2I8vovuVbRxCPpylldO814jP2anaEZuH9BAYw3aP+4=;
        b=fJfZzcZKTtn05nssc/AH0n/Kp2UxOCo4V7Tja8OdTTSgXGYu08x7vh9ie/8ggL2CG9
         0OK0C/niL1Zbdo61kgtYy73LovvQL1o4foN4ItGgkwrrkvCb6arNElmcKBa1NgVI9GwL
         QWtjJC604CysHoWzhqFcKV2KdImNHPBiGYfBME0gCAnqO4EFx8qL6HW97JMwe435lumD
         bQlyNRz74rqoifmXKLdaPGBhSj4uf8n8GlxjQ2ijh+PUjYjxMl6xTakpsvghgWUmrFVO
         vCOuN3YTNI46glbul55jcmDv+vqAnmfDaTQAYHr0EDbk0fgpJXsFd4rN8M1ou5XT7F+1
         vOGg==
X-Gm-Message-State: AJIora8eKpZHv9GIyTR/tyZCbmGVygXBeFqchp6pY1oPeEWySzbUOhwS
        7UXpsQ1vAGZdQlV1hvz7bgQ=
X-Google-Smtp-Source: AGRyM1vnDraVqAcsAZLhK3VEtuB2RqKnnh9qL8XOTcSAhwriyRhwihTxkFLJwVwUA9HqaQgdrnXpRg==
X-Received: by 2002:a17:907:3e9a:b0:72b:44d4:4482 with SMTP id hs26-20020a1709073e9a00b0072b44d44482mr12915426ejc.34.1658816178097;
        Mon, 25 Jul 2022 23:16:18 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:a080:2b68:36a:5a94:4ba1])
        by smtp.gmail.com with ESMTPSA id l23-20020a056402345700b0043ba7df7a42sm8133067edc.26.2022.07.25.23.16.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 23:16:17 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Philip Paeps <philip@trouble.is>
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Caowangbao <caowangbao@huawei.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 21/26] selftests: net/fcnal: Initial tcp_authopt support
Date:   Tue, 26 Jul 2022 09:15:23 +0300
Message-Id: <ad19d5c8a24054d48e1c35bb0ec92075b9f0dc6a.1658815925.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1658815925.git.cdleonard@gmail.com>
References: <cover.1658815925.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tests are mostly copied from tcp_md5 with minor changes.

It covers VRF support but only based on binding multiple servers: not
multiple keys bound to different interfaces.

Also add a specific -t tcp_authopt to run only these tests specifically.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 tools/testing/selftests/net/fcnal-test.sh | 329 +++++++++++++++++++++-
 1 file changed, 327 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 03b586760164..6b443aa0d89e 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -830,10 +830,330 @@ ipv4_ping()
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
+# Verify /proc/net/tcp_authopt is empty in all namespaces
+check_tcp_authopt_key_leak()
+{
+	local ns cnt
+
+	for ns in $NSA $NSB $NSC; do
+		if ! ip netns list | grep -q $ns; then
+			continue
+		fi
+		cnt=$(ip netns exec "$ns" cat /proc/net/tcp_authopt | wc -l)
+		if [[ $cnt != 1 ]]; then
+			echo "FAIL: leaked tcp_authopt keys in netns $ns"
+			ip netns exec $ns cat /proc/net/tcp_authopt
+			return 1
+		fi
+	done
+}
+
+log_check_tcp_authopt_key_leak()
+{
+	check_tcp_authopt_key_leak
+	log_test $? 0 "TCP-AO: Key leak check"
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
+	log_check_tcp_authopt_key_leak
+
+	log_start
+	run_cmd nettest -s -A ${MD5_PW} -m ${NSB_LO_IP} &
+	sleep 1
+	run_cmd_nsb nettest -r ${NSA_IP} -A ${MD5_PW}
+	log_test $? 2 "AO: Client address does not match address configured on server"
+	log_check_tcp_authopt_key_leak
+
+	# client in prefix
+	log_start
+	run_cmd nettest -s -A ${MD5_PW} -m ${NS_NET} &
+	sleep 1
+	run_cmd_nsb nettest -r ${NSA_IP} -A ${MD5_PW}
+	log_test $? 0 "AO: Prefix config"
+
+	# client in prefix, wrong password
+	log_start
+	show_hint "Should timeout since client uses wrong password"
+	run_cmd nettest -s -A ${MD5_PW} -m ${NS_NET} &
+	sleep 1
+	run_cmd_nsb nettest -r ${NSA_IP} -A ${MD5_WRONG_PW}
+	log_test $? 2 "AO: Prefix config, client uses wrong password"
+	log_check_tcp_authopt_key_leak
+
+	# client outside of prefix
+	log_start
+	show_hint "Should timeout due to MD5 mismatch"
+	run_cmd nettest -s -A ${MD5_PW} -m ${NS_NET} &
+	sleep 1
+	run_cmd_nsb nettest -c ${NSB_LO_IP} -r ${NSA_IP} -A ${MD5_PW}
+	log_test $? 2 "AO: Prefix config, client address not in configured prefix"
+	log_check_tcp_authopt_key_leak
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
+	log_test $? 0 "AO: VRF: Servers in default VRF and VRF, client in VRF"
+
+	log_start
+	run_cmd nettest -s -I ${VRF} -A ${MD5_PW} -m ${NSB_IP} &
+	run_cmd nettest -s -A ${MD5_WRONG_PW} -m ${NSB_IP} &
+	sleep 1
+	run_cmd_nsc nettest -r ${NSA_IP} -A ${MD5_WRONG_PW}
+	log_test $? 0 "AO: VRF: Servers in default VRF and VRF, client in default VRF"
+
+	log_start
+	show_hint "Should timeout since client in default VRF uses VRF password"
+	run_cmd nettest -s -I ${VRF} -A ${MD5_PW} -m ${NSB_IP} &
+	run_cmd nettest -s -A ${MD5_WRONG_PW} -m ${NSB_IP} &
+	sleep 1
+	run_cmd_nsc nettest -r ${NSA_IP} -A ${MD5_PW}
+	log_test $? 2 "AO: VRF: Servers in default VRF and VRF, conn in default VRF with VRF pw"
+
+	log_start
+	show_hint "Should timeout since client in VRF uses default VRF password"
+	run_cmd nettest -s -I ${VRF} -A ${MD5_PW} -m ${NSB_IP} &
+	run_cmd nettest -s -A ${MD5_WRONG_PW} -m ${NSB_IP} &
+	sleep 1
+	run_cmd_nsb nettest -r ${NSA_IP} -A ${MD5_WRONG_PW}
+	log_test $? 2 "AO: VRF: Servers in default VRF and VRF, conn in VRF with default VRF pw"
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
+	log_test $? 0 "AO: VRF: Servers in default VRF and VRF, client in VRF"
+
+	log_start
+	run_cmd nettest -6 -s -I ${VRF} -A ${MD5_PW} -m ${NSB_IP6} &
+	run_cmd nettest -6 -s -A ${MD5_WRONG_PW} -m ${NSB_IP6} &
+	sleep 1
+	run_cmd_nsc nettest -6 -r ${NSA_IP6} -A ${MD5_WRONG_PW}
+	log_test $? 0 "AO: VRF: Servers in default VRF and VRF, client in default VRF"
+
+	log_start
+	show_hint "Should timeout since client in default VRF uses VRF password"
+	run_cmd nettest -6 -s -I ${VRF} -A ${MD5_PW} -m ${NSB_IP6} &
+	run_cmd nettest -6 -s -A ${MD5_WRONG_PW} -m ${NSB_IP6} &
+	sleep 1
+	run_cmd_nsc nettest -6 -r ${NSA_IP6} -A ${MD5_PW}
+	log_test $? 2 "AO: VRF: Servers in default VRF and VRF, conn in default VRF with VRF pw"
+
+	log_start
+	show_hint "Should timeout since client in VRF uses default VRF password"
+	run_cmd nettest -6 -s -I ${VRF} -A ${MD5_PW} -m ${NSB_IP6} &
+	run_cmd nettest -6 -s -A ${MD5_WRONG_PW} -m ${NSB_IP6} &
+	sleep 1
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -A ${MD5_WRONG_PW}
+	log_test $? 2 "AO: VRF: Servers in default VRF and VRF, conn in VRF with default VRF pw"
+
+	log_start
+	run_cmd nettest -6 -s -I ${VRF} -A ${MD5_PW} -m ${NS_NET6} &
+	run_cmd nettest -6 -s -A ${MD5_WRONG_PW} -m ${NS_NET6} &
+	sleep 1
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -A ${MD5_PW}
+	log_test $? 0 "AO: VRF: Prefix config in default VRF and VRF, conn in VRF"
+
+	log_start
+	run_cmd nettest -6 -s -I ${VRF} -A ${MD5_PW} -m ${NS_NET6} &
+	run_cmd nettest -6 -s -A ${MD5_WRONG_PW} -m ${NS_NET6} &
+	sleep 1
+	run_cmd_nsc nettest -6 -r ${NSA_IP6} -A ${MD5_WRONG_PW}
+	log_test $? 0 "AO: VRF: Prefix config in default VRF and VRF, conn in default VRF"
+
+	log_start
+	show_hint "Should timeout since client in default VRF uses VRF password"
+	run_cmd nettest -6 -s -I ${VRF} -A ${MD5_PW} -m ${NS_NET6} &
+	run_cmd nettest -6 -s -A ${MD5_WRONG_PW} -m ${NS_NET6} &
+	sleep 1
+	run_cmd_nsc nettest -6 -r ${NSA_IP6} -A ${MD5_PW}
+	log_test $? 2 "AO: VRF: Prefix config in def VRF and VRF, conn in def VRF with VRF pw"
+
+	log_start
+	show_hint "Should timeout since client in VRF uses default VRF password"
+	run_cmd nettest -6 -s -I ${VRF} -A ${MD5_PW} -m ${NS_NET6} &
+	run_cmd nettest -6 -s -A ${MD5_WRONG_PW} -m ${NS_NET6} &
+	sleep 1
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -A ${MD5_WRONG_PW}
+	log_test $? 2 "AO: VRF: Prefix config in dev VRF and VRF, conn in VRF with def VRF pw"
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
+	setup_vrf_dup
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
@@ -1215,10 +1535,11 @@ ipv4_tcp_novrf()
 	show_hint "Should fail 'Connection refused'"
 	run_cmd nettest -d ${NSA_DEV} -r ${a}
 	log_test_addr ${a} $? 1 "No server, device client, local conn"
 
 	ipv4_tcp_md5_novrf
+	ipv4_tcp_authopt_novrf
 }
 
 ipv4_tcp_vrf()
 {
 	local a
@@ -1267,13 +1588,14 @@ ipv4_tcp_vrf()
 	run_cmd nettest -s &
 	sleep 1
 	run_cmd nettest -r ${a} -d ${NSA_DEV}
 	log_test_addr ${a} $? 1 "Global server, local connection"
 
-	# run MD5 tests
+	# run MD5+AO tests
 	setup_vrf_dup
 	ipv4_tcp_md5
+	ipv6_tcp_md5_vrf
 	cleanup_vrf_dup
 
 	#
 	# enable VRF global server
 	#
@@ -2748,10 +3070,11 @@ ipv6_tcp_novrf()
 		run_cmd nettest -6 -d ${NSA_DEV} -r ${a}
 		log_test_addr ${a} $? 1 "No server, device client, local conn"
 	done
 
 	ipv6_tcp_md5_novrf
+	ipv6_tcp_authopt_novrf
 }
 
 ipv6_tcp_vrf()
 {
 	local a
@@ -2816,13 +3139,14 @@ ipv6_tcp_vrf()
 	run_cmd nettest -6 -s &
 	sleep 1
 	run_cmd nettest -6 -r ${a} -d ${NSA_DEV}
 	log_test_addr ${a} $? 1 "Global server, local connection"
 
-	# run MD5 tests
+	# run MD5+AO tests
 	setup_vrf_dup
 	ipv6_tcp_md5
+	ipv6_tcp_authopt_vrf
 	cleanup_vrf_dup
 
 	#
 	# enable VRF global server
 	#
@@ -4191,10 +4515,11 @@ do
 	ipv6_bind|bind6) ipv6_addr_bind;;
 	ipv6_runtime)    ipv6_runtime;;
 	ipv6_netfilter)  ipv6_netfilter;;
 
 	use_cases)       use_cases;;
+	tcp_authopt)     only_tcp_authopt;;
 
 	# setup namespaces and config, but do not run any tests
 	setup)		 setup; exit 0;;
 	vrf_setup)	 setup "yes"; exit 0;;
 	esac
-- 
2.25.1

