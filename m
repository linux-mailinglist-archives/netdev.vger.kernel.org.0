Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01DA35989FC
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 19:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344845AbiHRRDY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 13:03:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344665AbiHRRCB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 13:02:01 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D60C2C12CB
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 10:00:56 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id k9so2455102wri.0
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 10:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=AK4InlvF9B1QaPzw96JloJQ6G3mOJmIdQ9aUwWnWzUc=;
        b=Teqsh9jPSj29w3+e49qn4nNQqQi4z/uIEiTsRPvsCiYpskb3bEEDMtTPBy37u608BW
         6UFd/eXMLnd1KcCJZDwj0HYeIgoh8P+aY5S5WAzqZjpDwGQr4MoZVRPCrxHW9ROETuUu
         74ZvD46I/z0z8Zg6Io0sjMB+uC5Y2LEx6vQass4g5heUtzd5W/6T+dGECVMwMFr27s30
         3ulendb0AxIcLWV+gY/u19K4dGTPHqtFGOTLQ0Eie6xfv5WKdVcfBnjQM4RdCeK7ozOk
         OCoxh8CdP5e02ibkREqywDH4hsK1cf3g6xvSek+hwDHM6JPYcG7aSPMDWdyRVtw72FDS
         yYVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=AK4InlvF9B1QaPzw96JloJQ6G3mOJmIdQ9aUwWnWzUc=;
        b=0X/xZiZ7yA6zRxRgrXEXC1p+UuJXqPiQA+jcUPYlTySVUT7DZM8uXCvuUNrOhY0OlF
         iRYYpgy/PDKTK9NqpNK6wAFasdMEvxbwO+lI3ncnkEAF6+4v0Rzsp4uQnU6dEQmLALSl
         i4ydWmxRosl0cSKS97HlqO18VaEmLdSDPRFtyHrtZRK5DpjlbcjrAyp/lH5SLkLSfG0/
         HSkrzw9hyBj7MdAv75QTquPWKkE1amATggu8CiI2Fyc3UJnBh6HQ73f42SjcjrBfM0kj
         Y14IDWsGAIPNcx9bu903vZk+8D4z3jZHj7jJ+RYvBCQJ7Pfq5mDhKiEs8Dgfb58N79Cg
         GT6g==
X-Gm-Message-State: ACgBeo0du+GVdC4oDE0+DXCSLM13OCdTwt+UiHHb3ahtBYQ43stjXeww
        JpgkLunWI6I/8Ji+wrtN5yWgIw==
X-Google-Smtp-Source: AA6agR7Vb0bFgoD2qJiyQ23BGlj3voGN/B5kPQxJYXQKMoOSwXHat4SDaw80B88oY6LOmPfkF+HSrQ==
X-Received: by 2002:a05:6000:178b:b0:222:c6c4:b42e with SMTP id e11-20020a056000178b00b00222c6c4b42emr2288254wrg.275.1660842056392;
        Thu, 18 Aug 2022 10:00:56 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id be13-20020a05600c1e8d00b003a511e92abcsm2662169wmb.34.2022.08.18.10.00.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 10:00:56 -0700 (PDT)
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
Subject: [PATCH 29/31] selftest/tcp-ao: Add test for TCP-AO add setsockopt() command
Date:   Thu, 18 Aug 2022 18:00:03 +0100
Message-Id: <20220818170005.747015-30-dima@arista.com>
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

Verify corner-cases for UAPI.
Sample output:
> # ./setsockopt-closed_ipv6
> 1..16
> # 9508[lib/setup.c:173] rand seed 1643819055
> TAP version 13
> ok 1 minimum size
> ok 2 extended size
> ok 3 bad algo
> ok 4 bad ao flags
> ok 5 empty prefix
> ok 6 prefix, any addr
> ok 7 no prefix, any addr
> ok 8 too short prefix
> ok 9 too big prefix
> ok 10 too big maclen
> ok 11 bad key flags
> ok 12 too big keylen
> not ok 13 duplicate: full copy: setsockopt() was expected to fail with 17
> ok 14 duplicate: any addr key on the socket
> ok 15 duplicate: add any addr key
> not ok 16 duplicate: add any addr for the same subnet: setsockopt() was expected to fail with 17

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 tools/testing/selftests/net/tcp_ao/Makefile   |   3 +-
 .../selftests/net/tcp_ao/setsockopt-closed.c  | 191 ++++++++++++++++++
 2 files changed, 193 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/net/tcp_ao/setsockopt-closed.c

diff --git a/tools/testing/selftests/net/tcp_ao/Makefile b/tools/testing/selftests/net/tcp_ao/Makefile
index 5064e34ebe38..a001dc2aed4e 100644
--- a/tools/testing/selftests/net/tcp_ao/Makefile
+++ b/tools/testing/selftests/net/tcp_ao/Makefile
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
-TEST_BOTH_AF := connect icmps-discard icmps-accept connect-deny
+TEST_BOTH_AF := connect icmps-discard icmps-accept connect-deny \
+		setsockopt-closed
 
 TEST_IPV4_PROGS := $(TEST_BOTH_AF:%=%_ipv4)
 TEST_IPV6_PROGS := $(TEST_BOTH_AF:%=%_ipv6)
diff --git a/tools/testing/selftests/net/tcp_ao/setsockopt-closed.c b/tools/testing/selftests/net/tcp_ao/setsockopt-closed.c
new file mode 100644
index 000000000000..be2cbc407f60
--- /dev/null
+++ b/tools/testing/selftests/net/tcp_ao/setsockopt-closed.c
@@ -0,0 +1,191 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Author: Dmitry Safonov <dima@arista.com> */
+#include <inttypes.h>
+#include "../../../../include/linux/kernel.h"
+#include "aolib.h"
+
+static void clean_ao(int sk, struct tcp_ao *ao)
+{
+	struct tcp_ao_del ao_del = {};
+
+	ao_del.tcpa_sndid = ao->tcpa_sndid;
+	ao_del.tcpa_rcvid = ao->tcpa_rcvid;
+	ao_del.tcpa_prefix = ao->tcpa_prefix;
+	memcpy(&ao_del.tcpa_addr, &ao->tcpa_addr, sizeof(ao->tcpa_addr));
+
+	if (setsockopt(sk, IPPROTO_TCP, TCP_AO_DEL, &ao_del, sizeof(ao_del)))
+		test_error("setsockopt(TCP_AO_DEL) failed to clean");
+	close(sk);
+}
+
+static void setsockopt_checked(int sk, int optname, struct tcp_ao *ao,
+			       int err, const char *tst)
+{
+	int ret;
+
+	errno = 0;
+	ret = setsockopt(sk, IPPROTO_TCP, optname, ao, sizeof(*ao));
+	if (ret == -1) {
+		if (errno == err) {
+			test_ok("%s", tst);
+			return;
+		}
+		test_fail("%s: setsockopt() returned %d", tst, err);
+		return;
+	}
+
+	if (err) {
+		test_fail("%s: setsockopt() was expected to fail with %d", tst, err);
+	} else {
+		test_ok("%s", tst);
+		test_verify_socket_ao(sk, ao);
+	}
+	clean_ao(sk, ao);
+}
+
+static int prepare_defs(struct tcp_ao *ao)
+{
+	int sk = socket(test_family, SOCK_STREAM, IPPROTO_TCP);
+
+	if (sk < 0)
+		test_error("socket()");
+
+	if (test_prepare_def_ao(ao, "password", 0, this_ip_dest, -1, 100, 100))
+		test_error("prepare default tcp_ao");
+
+	return sk;
+}
+
+static void test_extend(void)
+{
+	struct tcp_ao ao;
+	struct {
+		struct tcp_ao ao;
+		char *extend[100];
+	} ao_big = {};
+	int ret, sk;
+
+	sk = prepare_defs(&ao);
+	errno = 0;
+	ret = setsockopt(sk, IPPROTO_TCP, TCP_AO,
+			&ao, offsetof(struct tcp_ao, tcpa_key));
+	if (!ret) {
+		test_fail("minminum size: accepted invalid size");
+		clean_ao(sk, &ao);
+	} else if (errno != EINVAL) {
+		test_fail("minminum size: failed with %d", errno);
+	} else {
+		test_ok("minimum size");
+	}
+
+	sk = prepare_defs(&ao_big.ao);
+	errno = 0;
+	ret = setsockopt(sk, IPPROTO_TCP, TCP_AO, &ao_big.ao, sizeof(ao_big));
+	if (ret) {
+		test_fail("extended size: returned %d", ret);
+	} else {
+		test_ok("extended size");
+		clean_ao(sk, &ao_big.ao);
+	}
+}
+
+static void einval_tests(void)
+{
+	struct tcp_ao ao;
+	int sk;
+
+	sk = prepare_defs(&ao);
+	strcpy(ao.tcpa_alg_name, "imaginary hash algo");
+	setsockopt_checked(sk, TCP_AO, &ao, ENOENT, "bad algo");
+
+	sk = prepare_defs(&ao);
+	ao.tcpa_flags = (uint16_t)(-1);
+	setsockopt_checked(sk, TCP_AO, &ao, EINVAL, "bad ao flags");
+
+	sk = prepare_defs(&ao);
+	ao.tcpa_prefix = 0;
+	setsockopt_checked(sk, TCP_AO, &ao, EINVAL, "empty prefix");
+
+	sk = prepare_defs(&ao);
+	ao.tcpa_prefix = 32;
+	memcpy(&ao.tcpa_addr, &SOCKADDR_ANY, sizeof(SOCKADDR_ANY));
+	setsockopt_checked(sk, TCP_AO, &ao, EINVAL, "prefix, any addr");
+
+	sk = prepare_defs(&ao);
+	ao.tcpa_prefix = 0;
+	memcpy(&ao.tcpa_addr, &SOCKADDR_ANY, sizeof(SOCKADDR_ANY));
+	setsockopt_checked(sk, TCP_AO, &ao, 0, "no prefix, any addr");
+
+	sk = prepare_defs(&ao);
+	ao.tcpa_prefix = 2;
+	setsockopt_checked(sk, TCP_AO, &ao, EINVAL, "too short prefix");
+
+	sk = prepare_defs(&ao);
+	ao.tcpa_prefix = 129;
+	setsockopt_checked(sk, TCP_AO, &ao, EINVAL, "too big prefix");
+
+	sk = prepare_defs(&ao);
+	ao.tcpa_maclen = 100;
+	setsockopt_checked(sk, TCP_AO, &ao, EMSGSIZE, "too big maclen");
+
+	sk = prepare_defs(&ao);
+	ao.tcpa_keyflags = (uint8_t)(-1);
+	setsockopt_checked(sk, TCP_AO, &ao, EINVAL, "bad key flags");
+
+	sk = prepare_defs(&ao);
+	ao.tcpa_keylen = TCP_AO_MAXKEYLEN + 1;
+	setsockopt_checked(sk, TCP_AO, &ao, EINVAL, "too big keylen");
+}
+
+static void duplicate_tests(void)
+{
+	union tcp_addr network_dup;
+	struct tcp_ao ao, ao2;
+	int sk;
+
+	sk = prepare_defs(&ao);
+	if (setsockopt(sk, IPPROTO_TCP, TCP_AO, &ao, sizeof(ao)))
+		test_error("setsockopt()");
+	setsockopt_checked(sk, TCP_AO, &ao, EEXIST, "duplicate: full copy");
+
+	sk = prepare_defs(&ao);
+	ao2 = ao;
+	memcpy(&ao2.tcpa_addr, &SOCKADDR_ANY, sizeof(SOCKADDR_ANY));
+	ao2.tcpa_prefix = 0;
+	if (setsockopt(sk, IPPROTO_TCP, TCP_AO, &ao2, sizeof(ao)))
+		test_error("setsockopt()");
+	setsockopt_checked(sk, TCP_AO, &ao, EEXIST, "duplicate: any addr key on the socket");
+
+	sk = prepare_defs(&ao);
+	if (setsockopt(sk, IPPROTO_TCP, TCP_AO, &ao, sizeof(ao)))
+		test_error("setsockopt()");
+	memcpy(&ao.tcpa_addr, &SOCKADDR_ANY, sizeof(SOCKADDR_ANY));
+	ao.tcpa_prefix = 0;
+	setsockopt_checked(sk, TCP_AO, &ao, EEXIST, "duplicate: add any addr key");
+
+
+	if (inet_pton(TEST_FAMILY, TEST_NETWORK, &network_dup) != 1)
+		test_error("Can't convert ip address %s", TEST_NETWORK);
+	sk = prepare_defs(&ao);
+	if (setsockopt(sk, IPPROTO_TCP, TCP_AO, &ao, sizeof(ao)))
+		test_error("setsockopt()");
+	if (test_prepare_def_ao(&ao, "password", 0, network_dup, 16, 100, 100))
+		test_error("prepare default tcp_ao");
+	setsockopt_checked(sk, TCP_AO, &ao, EEXIST, "duplicate: add any addr for the same subnet");
+}
+
+
+static void *client_fn(void *arg)
+{
+	test_extend();
+	einval_tests();
+	duplicate_tests();
+
+	return NULL;
+}
+
+int main(int argc, char *argv[])
+{
+	test_init(16, client_fn, NULL);
+	return 0;
+}
-- 
2.37.2

