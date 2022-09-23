Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 463955E835D
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 22:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232971AbiIWURe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 16:17:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232799AbiIWUPa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 16:15:30 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7535135043
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 13:14:12 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id bq9so1583331wrb.4
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 13:14:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=AK4InlvF9B1QaPzw96JloJQ6G3mOJmIdQ9aUwWnWzUc=;
        b=LVXtBJy1Z/GJQVIKE2FDxWZ9hfhZJoY8eJ7OLcD0rbKsFpBj9gHpth4IpqE+WoZBAZ
         8MtIPl8VVCb8O11afBQ8kJpZwYfseGrP2UyOKpibm87wsH1fQkkklfySY4lOKDwI8OwP
         xWzuUQQWn3ruqaqXa8hO9pxbEiF7akSpkYv3P36+91RpMrjFYcEwzb7ex4vvNf+ttoPO
         viJAMw/pn/DwMbA3ehyhC0iI7TK7nyGvRfOKtqaE08MFc+zHwE92qXFhyugsc+25sar6
         v1FdrVUSSp+XMtAZ9xDmxcf2fX/erJUvsWOiKq5LgBiUZxnr0Wv2JLVQcq6NLJXWeXmY
         8Cew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=AK4InlvF9B1QaPzw96JloJQ6G3mOJmIdQ9aUwWnWzUc=;
        b=sqY4SXZvMf9ScbJVz8aUZI/CG4gpzb8Y2iYryzw3b1eXYrzJJ3Q14qsWnpmUYypeFx
         0bcwhe+iNBNiiA1cYvGnOyADZBgd8ygCyo9GKEvKd7RGKYYeUFN7peLvPDa4wUPvNZ+z
         LvVVqVuHmgwWUEIvTZWdT8kNuMNKuNQ/FduKpNCWhgs8B+XpQ4bb2JXtOlQbCkr3VFqQ
         F0osfvH8tOK4DrPN3hqeMwYlxp8hDMKJGyXF2tbDDesU9LeCdrYem5KlYgXO0aUk1k9u
         EzOKFQbLjpmjxNx87mFHphJWxnjA7tBXDTSmcqdcmiLesTfKFHtPh6gPxIHxpTOUcjgj
         JpGw==
X-Gm-Message-State: ACrzQf1sxgjuogVzmpbHmDXe3FHrFAus4hBYT8PuzSBCiVEcGkuz8X8z
        Rglpzqtv8RtCh6LHXbwPQIpAmA==
X-Google-Smtp-Source: AMsMyM412ce+3x41p2+xdKr69DMd17SdmUBcsHgqcKrP8N2/oRtXsN98o461kOv8KBQXmVXcIJP0lg==
X-Received: by 2002:a5d:6d0b:0:b0:22a:ca5b:a37e with SMTP id e11-20020a5d6d0b000000b0022aca5ba37emr6221812wrq.383.1663964052251;
        Fri, 23 Sep 2022 13:14:12 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id k11-20020a05600c0b4b00b003b492753826sm3281056wmr.43.2022.09.23.13.14.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 13:14:11 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
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
Subject: [PATCH v2 29/35] selftest/tcp-ao: Add test for TCP-AO add setsockopt() command
Date:   Fri, 23 Sep 2022 21:13:13 +0100
Message-Id: <20220923201319.493208-30-dima@arista.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220923201319.493208-1-dima@arista.com>
References: <20220923201319.493208-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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

