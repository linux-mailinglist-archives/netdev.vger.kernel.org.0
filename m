Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE3125989FB
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 19:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345438AbiHRRDZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 13:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345324AbiHRRCC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 13:02:02 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC769C743D
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 10:00:59 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id v7-20020a1cac07000000b003a6062a4f81so2899083wme.1
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 10:00:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=U38qHd/2cGlOOAg9pewo5FAQzc3pYM6VmdaPe+uIwj8=;
        b=RQd+UFIs0SItVBdpap6AY/bqtkLF6gQ7kPCFT2t/uc6OaxbIMNc0fvu2koX9/fZovt
         kIuNGj6aqCXoSc8Pzi+cALXicvAV59guElq29dlBWi8B0faouQKgng+Io6oF4tMSuv2Z
         psxmKmWudXEQLPwPArFDPDI6/ZfjzMA3wxrGk/yNBEHht93btOp7ak+N0Z3rrQudrBu+
         78qN25ylO3h/dWpdPV4R7sUujRI9hWAiBLXNc8LktmLNO1m5X1yoG2cfijbBsqqgJsvX
         74t7hbMLY3mBL+gdwmnnPdbSSCUs44TfhCTndomcjyu/0JF9s51rSlavFvGuO6JSHCf7
         QemA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=U38qHd/2cGlOOAg9pewo5FAQzc3pYM6VmdaPe+uIwj8=;
        b=2GdMSFTrYZiBGvGbCKToVFB/YJ3mcb811yiSoQAFHVQCT+7SX8/wvPAWR9wqOweiA3
         LyVuXTmRN7b2IdvwyctK0BtLdS8iQEHD45w8kzw302ie6ww10x8EaZVD1z7V5JAWWB5S
         UjgM2M7TtIReZGm0u3MP0Elx9DlKHii1HXxNfhFZR3drXyHIq+FJZERkf8weZcw3TjiO
         RHFuI16Bgh0J1/+lY5gDgK++zfh8vM17hmG1hBvr2ViCAp7WsPLUyL4+JeA5yV+Df09Z
         yBE6KzOdqdvxoXx/Scxuo8Rr7+i6pFgb+ltlgbK9WaePTjqsfK5ivzWud7kg6uVTDIIr
         i0kA==
X-Gm-Message-State: ACgBeo1qkGU99MjLDSUGQCcLbRLLxc/Yvf0cjCWdn8s9P14j9X5otQX6
        ETJftmTU0Pnv2VKfuu4vs1mLEw==
X-Google-Smtp-Source: AA6agR41YtCFfv/EsSG0bgllPR+qSDHdhEhW2gheQ0gifo1FbARk9CeevXX5xGmRsopK3bRFn2t8lw==
X-Received: by 2002:a1c:ed05:0:b0:3a5:3af:f5c3 with SMTP id l5-20020a1ced05000000b003a503aff5c3mr2495651wmh.52.1660842057922;
        Thu, 18 Aug 2022 10:00:57 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id be13-20020a05600c1e8d00b003a511e92abcsm2662169wmb.34.2022.08.18.10.00.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 10:00:57 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        David Ahern <dsahern@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH 30/31] selftests/tcp-ao: Add TCP-AO + TCP-MD5 + no sign listen socket tests
Date:   Thu, 18 Aug 2022 18:00:04 +0100
Message-Id: <20220818170005.747015-31-dima@arista.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220818170005.747015-1-dima@arista.com>
References: <20220818170005.747015-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The test plan was (most of tests have all 3 client types):
1. TCP-AO listen (INADDR_ANY)
2. TCP-MD5 listen (INADDR_ANY)
3. non-signed listen (INADDR_ANY)
4. TCP-AO + TCP-MD5 listen (prefix)
5. TCP-AO subprefix add failure [checked in setsockopt-closed.c]
6. TCP-AO out of prefix connect [checked in connect-deny.c]
7. TCP-AO + TCP-MD5 on connect()
8. TCP-AO intersect with TCP-MD5 failure
9. Established TCP-AO: add TCP-MD5 key
10. Established TCP-MD5: add TCP-AO key
11. Established non-signed: add TCP-AO key

Output produced:
1..42
TAP version 13
ok 1 AO server (INADDR_ANY): AO client: connected
ok 2 AO server (INADDR_ANY): AO client: counter TCPAOGood increased 0 => 2
ok 3 AO server (INADDR_ANY): MD5 client
ok 4 AO server (INADDR_ANY): MD5 client: counter TCPMD5Unexpected increased 0 => 1
ok 5 AO server (INADDR_ANY): no sign client: counter TCPAORequired increased 0 => 1
ok 6 AO server (INADDR_ANY): unsigned client
ok 7 MD5 server (INADDR_ANY): AO client: counter TCPAOKeyNotFound increased 0 => 1
ok 8 MD5 server (INADDR_ANY): AO client
ok 9 MD5 server (INADDR_ANY): MD5 client: connected
ok 10 MD5 server (INADDR_ANY): no sign client: counter TCPMD5NotFound increased 0 => 1
ok 11 MD5 server (INADDR_ANY): no sign client
ok 12 no sign server: AO client
ok 13 no sign server: AO client: counter TCPAOKeyNotFound increased 1 => 2
ok 14 no sign server: MD5 client
ok 15 no sign server: MD5 client: counter TCPMD5Unexpected increased 1 => 2
ok 16 no sign server: no sign client: connected
ok 17 no sign server: no sign client: counter CurrEstab increased 0 => 1
ok 18 AO+MD5 server: AO client (matching): connected
ok 19 AO+MD5 server: AO client (matching): counter TCPAOGood increased 4 => 6
ok 20 AO+MD5 server: AO client (misconfig, matching MD5)
ok 21 AO+MD5 server: AO client (misconfig, matching MD5): counter TCPAOKeyNotFound increased 2 => 3
ok 22 AO+MD5 server: AO client (misconfig, non-matching): counter TCPAOKeyNotFound increased 3 => 4
ok 23 AO+MD5 server: AO client (misconfig, non-matching)
ok 24 AO+MD5 server: MD5 client (matching): connected
ok 25 AO+MD5 server: MD5 client (misconfig, matching AO)
ok 26 AO+MD5 server: MD5 client (misconfig, matching AO): counter TCPMD5Unexpected increased 2 => 3
ok 27 AO+MD5 server: MD5 client (misconfig, non-matching): counter TCPMD5Unexpected increased 3 => 4
ok 28 AO+MD5 server: MD5 client (misconfig, non-matching)
ok 29 AO+MD5 server: no sign client (unmatched): connected
ok 30 AO+MD5 server: no sign client (unmatched): counter CurrEstab increased 0 => 1
ok 31 AO+MD5 server: no sign client (misconfig, matching AO)
ok 32 AO+MD5 server: no sign client (misconfig, matching AO): counter TCPAORequired increased 1 => 2
ok 33 AO+MD5 server: no sign client (misconfig, matching MD5)
ok 34 AO+MD5 server: no sign client (misconfig, matching MD5): counter TCPMD5NotFound increased 1 => 2
ok 35 AO+MD5 server: client with both [TCP-MD5] and TCP-AO keys: connect() was prevented
ok 36 AO+MD5 server: client with both TCP-MD5 and [TCP-AO] keys: connect() was prevented
ok 37 TCP-AO established: add TCP-MD5 key: postfailed as expected
ok 38 TCP-AO established: add TCP-MD5 key: counter TCPAOGood increased 7 => 9
ok 39 TCP-MD5 established: add TCP-AO key: postfailed as expected
ok 40 non-signed established: add TCP-AO key: postfailed as expected
ok 41 non-signed established: add TCP-AO key: counter CurrEstab increased 0 => 1
ok 42 TCP-AO key intersects with TCP-MD5 key: prefailed as expected

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 tools/testing/selftests/net/tcp_ao/Makefile   |   2 +-
 .../selftests/net/tcp_ao/unsigned-md5.c       | 483 ++++++++++++++++++
 2 files changed, 484 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/net/tcp_ao/unsigned-md5.c

diff --git a/tools/testing/selftests/net/tcp_ao/Makefile b/tools/testing/selftests/net/tcp_ao/Makefile
index a001dc2aed4e..da44966f3687 100644
--- a/tools/testing/selftests/net/tcp_ao/Makefile
+++ b/tools/testing/selftests/net/tcp_ao/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 TEST_BOTH_AF := connect icmps-discard icmps-accept connect-deny \
-		setsockopt-closed
+		setsockopt-closed unsigned-md5
 
 TEST_IPV4_PROGS := $(TEST_BOTH_AF:%=%_ipv4)
 TEST_IPV6_PROGS := $(TEST_BOTH_AF:%=%_ipv6)
diff --git a/tools/testing/selftests/net/tcp_ao/unsigned-md5.c b/tools/testing/selftests/net/tcp_ao/unsigned-md5.c
new file mode 100644
index 000000000000..d62c47617dbf
--- /dev/null
+++ b/tools/testing/selftests/net/tcp_ao/unsigned-md5.c
@@ -0,0 +1,483 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Author: Dmitry Safonov <dima@arista.com> */
+#include <inttypes.h>
+#include "aolib.h"
+#include "../../../../include/linux/bits.h"
+
+typedef uint8_t fault_t;
+#define F_TIMEOUT	1
+#define F_KEYREJECT	2
+#define F_PREINSTALL	3
+#define F_POSTINSTALL	4
+
+#define fault(type)	(inj == type)
+
+static const char *md5_password = "Some evil genius, enemy to mankind, must have been the first contriver.";
+static const char *ao_password = "In this hour, I do not believe that any darkness will endure.";
+
+static union tcp_addr client2;
+static union tcp_addr client3;
+
+static int test_set_md5(int sk, const union tcp_addr in_addr, uint8_t prefix)
+{
+	size_t pwd_len = strlen(md5_password);
+	struct tcp_md5sig md5sig = {};
+#ifdef IPV6_TEST
+	struct sockaddr_in6 addr = {
+		.sin6_family	= AF_INET6,
+		.sin6_port	= 0,
+		.sin6_addr	= in_addr.a6,
+	};
+#else
+	struct sockaddr_in addr = {
+		.sin_family	= AF_INET,
+		.sin_port	= 0,
+		.sin_addr	= in_addr.a4,
+	};
+#endif
+
+	if (prefix > DEFAULT_TEST_PREFIX)
+		prefix = DEFAULT_TEST_PREFIX;
+
+	md5sig.tcpm_keylen = pwd_len;
+	memcpy(md5sig.tcpm_key, md5_password, pwd_len);
+	md5sig.tcpm_flags = TCP_MD5SIG_FLAG_PREFIX;
+	md5sig.tcpm_prefixlen = prefix;
+	memcpy(&md5sig.tcpm_addr, &addr, sizeof(addr));
+
+	return setsockopt(sk, IPPROTO_TCP, TCP_MD5SIG_EXT,
+			  &md5sig, sizeof(md5sig));
+}
+
+static void try_accept(const char *tst_name, unsigned port,
+		       union tcp_addr *md5_addr, uint8_t md5_prefix,
+		       union tcp_addr *ao_addr, uint8_t ao_prefix,
+		       uint8_t sndid, uint8_t rcvid, const char *cnt_name,
+		       fault_t inj)
+{
+	uint64_t before_cnt, after_cnt;
+	int lsk, err, sk = 0;
+	time_t timeout;
+
+	lsk = test_listen_socket(this_ip_addr, port, 1);
+
+	if (md5_addr && test_set_md5(lsk, *md5_addr, md5_prefix))
+		test_error("setsockopt(TCP_MD5SIG_EXT)");
+
+	if (ao_addr && test_set_ao(lsk, ao_password, 0, *ao_addr,
+				   ao_prefix, sndid, rcvid))
+		test_error("setsockopt(TCP_AO)");
+
+	if (cnt_name)
+		before_cnt = netstat_get_one(cnt_name, NULL);
+
+	synchronize_threads(); /* preparations done */
+
+	timeout = fault(F_TIMEOUT) ? TEST_RETRANSMIT_SEC : TEST_TIMEOUT_SEC;
+	err = test_wait_fd(lsk, timeout, 0);
+	if (err < 0)
+		test_error("test_wait_fd()");
+	else if (!err) {
+		if (!fault(F_TIMEOUT))
+			test_fail("timeouted for accept()");
+	} else {
+		if (fault(F_TIMEOUT))
+			test_fail("ready to accept");
+
+		sk = accept(lsk, NULL, NULL);
+		if (sk < 0) {
+			test_error("accept()");
+		} else {
+			if (fault(F_TIMEOUT))
+				test_fail("%s: accepted", tst_name);
+		}
+	}
+
+	close(lsk);
+
+	if (!cnt_name)
+		goto out;
+
+	after_cnt = netstat_get_one(cnt_name, NULL);
+
+	if (after_cnt <= before_cnt) {
+		test_fail("%s: %s counter did not increase: %zu <= %zu",
+				tst_name, cnt_name, after_cnt, before_cnt);
+	} else {
+		test_ok("%s: counter %s increased %zu => %zu",
+			tst_name, cnt_name, before_cnt, after_cnt);
+	}
+
+out:
+	synchronize_threads(); /* close() */
+	if (sk > 0)
+		close(sk);
+}
+
+static void server_add_routes(void)
+{
+	int family = TEST_FAMILY;
+
+	synchronize_threads(); /* client_add_ips() */
+
+	if (ip_route_add(veth_name, family, this_ip_addr, client2))
+		test_error("Failed to add route");
+	if (ip_route_add(veth_name, family, this_ip_addr, client3))
+		test_error("Failed to add route");
+}
+
+static void server_add_fail_tests(unsigned *port)
+{
+	union tcp_addr addr_any = {};
+
+	try_accept("TCP-AO established: add TCP-MD5 key", (*port)++, NULL, 0,
+		   &addr_any, 0, 100, 100, "TCPAOGood", 0);
+	try_accept("TCP-MD5 established: add TCP-AO key", (*port)++, &addr_any, 0,
+		   NULL, 0, 0, 0, NULL, 0);
+	try_accept("non-signed established: add TCP-AO key", (*port)++, NULL, 0,
+		   NULL, 0, 0, 0, "CurrEstab", 0);
+}
+
+static void *server_fn(void *arg)
+{
+	unsigned port = test_server_port;
+	union tcp_addr addr_any = {};
+
+	server_add_routes();
+
+	try_accept("AO server (INADDR_ANY): AO client", port++, NULL, 0,
+		   &addr_any, 0, 100, 100, "TCPAOGood", 0);
+	try_accept("AO server (INADDR_ANY): MD5 client", port++, NULL, 0,
+		   &addr_any, 0, 100, 100, "TCPMD5Unexpected", F_TIMEOUT);
+	try_accept("AO server (INADDR_ANY): no sign client", port++, NULL, 0,
+		   &addr_any, 0, 100, 100, "TCPAORequired", F_TIMEOUT);
+
+	try_accept("MD5 server (INADDR_ANY): AO client", port++, &addr_any, 0,
+		   NULL, 0, 0, 0, "TCPAOKeyNotFound", F_TIMEOUT);
+	try_accept("MD5 server (INADDR_ANY): MD5 client", port++, &addr_any, 0,
+		   NULL, 0, 0, 0, NULL, 0);
+	try_accept("MD5 server (INADDR_ANY): no sign client", port++, &addr_any, 0,
+		   NULL, 0, 0, 0, "TCPMD5NotFound", F_TIMEOUT);
+
+	try_accept("no sign server: AO client", port++, NULL, 0,
+		   NULL, 0, 0, 0, "TCPAOKeyNotFound", F_TIMEOUT);
+	try_accept("no sign server: MD5 client", port++, NULL, 0,
+		   NULL, 0, 0, 0, "TCPMD5Unexpected", F_TIMEOUT);
+	try_accept("no sign server: no sign client", port++, NULL, 0,
+		   NULL, 0, 0, 0, "CurrEstab", 0);
+
+	try_accept("AO+MD5 server: AO client (matching)", port++,
+		&this_ip_dest, TEST_PREFIX, &client2, TEST_PREFIX,
+		100, 100, "TCPAOGood", 0);
+	try_accept("AO+MD5 server: AO client (misconfig, matching MD5)", port++,
+		&this_ip_dest, TEST_PREFIX, &client2, TEST_PREFIX,
+		100, 100, "TCPAOKeyNotFound", F_TIMEOUT);
+	try_accept("AO+MD5 server: AO client (misconfig, non-matching)", port++,
+		&this_ip_dest, TEST_PREFIX, &client2, TEST_PREFIX,
+		100, 100, "TCPAOKeyNotFound", F_TIMEOUT);
+	try_accept("AO+MD5 server: MD5 client (matching)", port++,
+		&this_ip_dest, TEST_PREFIX, &client2, TEST_PREFIX,
+		100, 100, NULL, 0);
+	try_accept("AO+MD5 server: MD5 client (misconfig, matching AO)", port++,
+		&this_ip_dest, TEST_PREFIX, &client2, TEST_PREFIX,
+		100, 100, "TCPMD5Unexpected", F_TIMEOUT);
+	try_accept("AO+MD5 server: MD5 client (misconfig, non-matching)", port++,
+		&this_ip_dest, TEST_PREFIX, &client2, TEST_PREFIX,
+		100, 100, "TCPMD5Unexpected", F_TIMEOUT);
+	try_accept("AO+MD5 server: no sign client (unmatched)", port++,
+		&this_ip_dest, TEST_PREFIX, &client2, TEST_PREFIX,
+		100, 100, "CurrEstab", 0);
+	try_accept("AO+MD5 server: no sign client (misconfig, matching AO)",
+		port++, &this_ip_dest, TEST_PREFIX, &client2, TEST_PREFIX,
+		100, 100, "TCPAORequired", F_TIMEOUT);
+	try_accept("AO+MD5 server: no sign client (misconfig, matching MD5)",
+		port++, &this_ip_dest, TEST_PREFIX, &client2, TEST_PREFIX,
+		100, 100, "TCPMD5NotFound", F_TIMEOUT);
+
+	try_accept("AO+MD5 server: client with both [TCP-MD5] and TCP-AO keys",
+		port++, &this_ip_dest, TEST_PREFIX, &client2, TEST_PREFIX,
+		100, 100, NULL, F_TIMEOUT);
+	try_accept("AO+MD5 server: client with both TCP-MD5 and [TCP-AO] keys",
+		port++, &this_ip_dest, TEST_PREFIX, &client2, TEST_PREFIX,
+		100, 100, NULL, F_TIMEOUT);
+
+	server_add_fail_tests(&port);
+
+	/* client exits */
+	synchronize_threads();
+	return NULL;
+}
+
+static int client_bind(int sk, union tcp_addr bind_addr)
+{
+#ifdef IPV6_TEST
+	struct sockaddr_in6 addr = {
+		.sin6_family	= AF_INET6,
+		.sin6_port	= 0,
+		.sin6_addr	= bind_addr.a6,
+	};
+#else
+	struct sockaddr_in addr = {
+		.sin_family	= AF_INET,
+		.sin_port	= 0,
+		.sin_addr	= bind_addr.a4,
+	};
+#endif
+	return bind(sk, &addr, sizeof(addr));
+}
+
+static void try_connect(const char *tst_name, unsigned port,
+		       union tcp_addr *md5_addr, uint8_t md5_prefix,
+		       union tcp_addr *ao_addr, uint8_t ao_prefix,
+		       uint8_t sndid, uint8_t rcvid, fault_t inj,
+		       union tcp_addr *bind_addr)
+{
+	time_t timeout;
+	int sk, ret;
+
+	sk = socket(test_family, SOCK_STREAM, IPPROTO_TCP);
+	if (sk < 0)
+		test_error("socket()");
+
+	if (bind_addr && client_bind(sk, *bind_addr))
+		test_error("bind()");
+
+	if (md5_addr && test_set_md5(sk, *md5_addr, md5_prefix))
+		test_error("setsockopt(TCP_MD5SIG_EXT)");
+
+	if (ao_addr && test_set_ao(sk, ao_password, 0, *ao_addr,
+				   ao_prefix, sndid, rcvid))
+		test_error("setsockopt(TCP_AO)");
+
+	synchronize_threads(); /* preparations done */
+
+	timeout = fault(F_TIMEOUT) ? TEST_RETRANSMIT_SEC : TEST_TIMEOUT_SEC;
+	ret = _test_connect_socket(sk, this_ip_dest, port, timeout);
+
+	if (ret < 0) {
+		if (fault(F_KEYREJECT) && ret == -EKEYREJECTED) {
+			test_ok("%s: connect() was prevented", tst_name);
+			goto out;
+		} else if (ret == -ECONNREFUSED &&
+				(fault(F_TIMEOUT) || fault(F_KEYREJECT))) {
+			test_ok("%s: refused to connect", tst_name);
+			goto out;
+		} else {
+			test_error("%s: connect() returned %d", tst_name, ret);
+		}
+	}
+
+	if (ret == 0) {
+		if (fault(F_TIMEOUT))
+			test_ok("%s", tst_name);
+		else
+			test_fail("%s: failed to connect()", tst_name);
+	} else {
+		if (fault(F_TIMEOUT) || fault(F_KEYREJECT))
+			test_fail("%s: connected", tst_name);
+		else
+			test_ok("%s: connected", tst_name);
+	}
+
+out:
+	synchronize_threads(); /* close() */
+	/* _test_connect_socket() cleans up on failure */
+	if (ret > 0)
+		close(sk);
+}
+
+#define PREINSTALL_MD5	BIT(1)
+#define POSTINSTALL_MD5	BIT(2)
+#define PREINSTALL_AO	BIT(3)
+#define POSTINSTALL_AO	BIT(4)
+
+static void try_to_add(const char *tst_name, unsigned port,
+		       unsigned strategy,
+		       union tcp_addr md5_addr, uint8_t md5_prefix,
+		       union tcp_addr ao_addr, uint8_t ao_prefix,
+		       uint8_t sndid, uint8_t rcvid, fault_t inj)
+{
+	time_t timeout;
+	int sk, ret;
+
+	sk = socket(test_family, SOCK_STREAM, IPPROTO_TCP);
+	if (sk < 0)
+		test_error("socket()");
+
+	if (client_bind(sk, this_ip_addr))
+		test_error("bind()");
+
+	if (strategy & PREINSTALL_MD5) {
+		if (test_set_md5(sk, md5_addr, md5_prefix))
+			test_error("setsockopt(TCP_MD5SIG_EXT)");
+	}
+
+	if (strategy & PREINSTALL_AO) {
+		if (test_set_ao(sk, ao_password, 0, ao_addr,
+				ao_prefix, sndid, rcvid)) {
+			if (fault(F_PREINSTALL)) {
+				test_ok("%s: prefailed as expected", tst_name);
+				goto out_no_sync;
+			} else {
+				test_error("setsockopt(TCP_AO)");
+			}
+		} else if (fault(F_PREINSTALL)) {
+			test_fail("%s: setsockopt()s were expected to fail", tst_name);
+			goto out_no_sync;
+		}
+	}
+
+	synchronize_threads(); /* preparations done */
+
+	timeout = fault(F_TIMEOUT) ? TEST_RETRANSMIT_SEC : TEST_TIMEOUT_SEC;
+	ret = _test_connect_socket(sk, this_ip_dest, port, timeout);
+
+	if (ret <= 0) {
+		test_error("%s: connect() returned %d", tst_name, ret);
+		goto out;
+	}
+
+	if (strategy & POSTINSTALL_MD5) {
+		if (test_set_md5(sk, md5_addr, md5_prefix)) {
+			if (fault(F_POSTINSTALL)) {
+				test_ok("%s: postfailed as expected", tst_name);
+				goto out;
+			} else {
+				test_error("setsockopt(TCP_MD5SIG_EXT)");
+			}
+		} else if (fault(F_POSTINSTALL)) {
+			test_fail("%s: post setsockopt() was expected to fail", tst_name);
+			goto out;
+		}
+	}
+
+	if (strategy & POSTINSTALL_AO) {
+		if (test_set_ao(sk, ao_password, 0, ao_addr,
+				ao_prefix, sndid, rcvid)) {
+			if (fault(F_POSTINSTALL)) {
+				test_ok("%s: postfailed as expected", tst_name);
+				goto out;
+			} else {
+				test_error("setsockopt(TCP_AO)");
+			}
+		} else if (fault(F_POSTINSTALL)) {
+			test_fail("%s: post setsockopt() was expected to fail", tst_name);
+			goto out;
+		}
+	}
+
+out:
+	synchronize_threads(); /* close() */
+out_no_sync:
+	/* _test_connect_socket() cleans up on failure */
+	if (ret > 0)
+		close(sk);
+}
+
+static void client_add_ip(union tcp_addr *client, const char *ip)
+{
+	int family = TEST_FAMILY;
+
+	if (inet_pton(family, ip, client) != 1)
+		test_error("Can't convert ip address %s", ip);
+
+	if (ip_addr_add(veth_name, family, *client, TEST_PREFIX))
+		test_error("Failed to add ip address");
+	if (ip_route_add(veth_name, family, *client, this_ip_dest))
+		test_error("Failed to add route");
+}
+
+static void client_add_ips(void)
+{
+	client_add_ip(&client2, __TEST_CLIENT_IP(2));
+	client_add_ip(&client3, __TEST_CLIENT_IP(3));
+	synchronize_threads(); /* server_add_routes() */
+}
+
+static void client_add_fail_tests(unsigned *port)
+{
+	try_to_add("TCP-AO established: add TCP-MD5 key",
+		   (*port)++, POSTINSTALL_MD5 | PREINSTALL_AO,
+		   this_ip_dest, TEST_PREFIX, this_ip_dest, TEST_PREFIX,
+		   100, 100, F_POSTINSTALL);
+	try_to_add("TCP-MD5 established: add TCP-AO key",
+		   (*port)++, PREINSTALL_MD5 | POSTINSTALL_AO,
+		   this_ip_dest, TEST_PREFIX, this_ip_dest, TEST_PREFIX,
+		   100, 100, F_POSTINSTALL);
+	try_to_add("non-signed established: add TCP-AO key",
+		   (*port)++, POSTINSTALL_AO,
+		   this_ip_dest, TEST_PREFIX, this_ip_dest, TEST_PREFIX,
+		   100, 100, F_POSTINSTALL);
+
+	try_to_add("TCP-AO key intersects with TCP-MD5 key",
+		   (*port), PREINSTALL_MD5 | PREINSTALL_AO,
+		   this_ip_addr, TEST_PREFIX, this_ip_addr, TEST_PREFIX,
+		   100, 100, F_PREINSTALL);
+}
+
+static void *client_fn(void *arg)
+{
+	unsigned port = test_server_port;
+	union tcp_addr addr_any = {};
+
+	client_add_ips();
+
+	try_connect("AO server (INADDR_ANY): AO client", port++, NULL, 0,
+		    &addr_any, 0, 100, 100, 0, &this_ip_addr);
+	try_connect("AO server (INADDR_ANY): MD5 client", port++, &addr_any, 0,
+		    NULL, 0, 100, 100, F_TIMEOUT, &this_ip_addr);
+	try_connect("AO server (INADDR_ANY): unsigned client", port++, NULL, 0,
+		    NULL, 0, 100, 100, F_TIMEOUT, &this_ip_addr);
+
+	try_connect("MD5 server (INADDR_ANY): AO client", port++, NULL, 0,
+		   &addr_any, 0, 100, 100, F_TIMEOUT, &this_ip_addr);
+	try_connect("MD5 server (INADDR_ANY): MD5 client", port++, &addr_any, 0,
+		   NULL, 0, 100, 100, 0, &this_ip_addr);
+	try_connect("MD5 server (INADDR_ANY): no sign client", port++, NULL, 0,
+		   NULL, 0, 100, 100, F_TIMEOUT, &this_ip_addr);
+
+	try_connect("no sign server: AO client", port++, NULL, 0,
+		   &addr_any, 0, 100, 100, F_TIMEOUT, &this_ip_addr);
+	try_connect("no sign server: MD5 client", port++, &addr_any, 0,
+		   NULL, 0, 100, 100, F_TIMEOUT, &this_ip_addr);
+	try_connect("no sign server: no sign client", port++, NULL, 0,
+		   NULL, 0, 100, 100, 0, &this_ip_addr);
+
+	try_connect("AO+MD5 server: AO client (matching)", port++, NULL, 0,
+		   &addr_any, 0, 100, 100, 0, &client2);
+	try_connect("AO+MD5 server: AO client (misconfig, matching MD5)",
+		   port++, NULL, 0, &addr_any, 0, 100, 100,
+		   F_TIMEOUT, &this_ip_addr);
+	try_connect("AO+MD5 server: AO client (misconfig, non-matching)",
+		   port++, NULL, 0, &addr_any, 0, 100, 100,
+		   F_TIMEOUT, &client3);
+	try_connect("AO+MD5 server: MD5 client (matching)", port++, &addr_any, 0,
+		   NULL, 0, 100, 100, 0, &this_ip_addr);
+	try_connect("AO+MD5 server: MD5 client (misconfig, matching AO)",
+		   port++, &addr_any, 0, NULL, 0, 100, 100, F_TIMEOUT, &client2);
+	try_connect("AO+MD5 server: MD5 client (misconfig, non-matching)",
+		   port++, &addr_any, 0, NULL, 0, 100, 100, F_TIMEOUT, &client3);
+	try_connect("AO+MD5 server: no sign client (unmatched)",
+		   port++, NULL, 0, NULL, 0, 100, 100, 0, &client3);
+	try_connect("AO+MD5 server: no sign client (misconfig, matching AO)",
+		   port++, NULL, 0, NULL, 0, 100, 100, F_TIMEOUT, &client2);
+	try_connect("AO+MD5 server: no sign client (misconfig, matching MD5)",
+		   port++, NULL, 0, NULL, 0, 100, 100, F_TIMEOUT, &this_ip_addr);
+
+	try_connect("AO+MD5 server: client with both [TCP-MD5] and TCP-AO keys",
+		   port++, &this_ip_addr, TEST_PREFIX,
+		   &client2, TEST_PREFIX, 100, 100, F_KEYREJECT, &this_ip_addr);
+	try_connect("AO+MD5 server: client with both TCP-MD5 and [TCP-AO] keys",
+		   port++, &this_ip_addr, TEST_PREFIX,
+		   &client2, TEST_PREFIX, 100, 100, F_KEYREJECT, &client2);
+
+	client_add_fail_tests(&port);
+
+	return NULL;
+}
+
+int main(int argc, char *argv[])
+{
+	test_init(42, server_fn, client_fn);
+	return 0;
+}
-- 
2.37.2

