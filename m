Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6010E610369
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 22:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237199AbiJ0Uwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 16:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237191AbiJ0Uvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 16:51:54 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD30C923DA
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 13:45:25 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id l14-20020a05600c1d0e00b003c6ecc94285so4502073wms.1
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 13:45:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lp2VxXZrnF/kw40YEQ4TVBQpSqwfLCviQOCTAxoI/HQ=;
        b=TY/MbBMiIMB3eZjGCYvQoY0BlWIrl7u4BfmqoJbw+su0aVxHFBVYk/5H9FIbQy9oeU
         grras9Br2xg6oTogFbxkBxqLVTH7zvbLMYu3TG5B81UhKzOCGuaESe9nI0LiH3ZhtDb5
         43+luKtGhD9QZFBRfzQqOIKc2b6ThuwrvI9whwmFNvaeO2QDyYX+prsMSZ/U7LENOFW2
         k7V9Bf27h/lhdxtCrWCKw8HGQ47d7C2AYzLE2uoXqOhns826Q+RLH0wtTnkzV7kNOU42
         P8OqTay2Y353lxY2KLQefhf6ROz0jWlzxnQ38kdHs3PxxoXkqhaERpf5bhTxZU9fThZP
         m44Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lp2VxXZrnF/kw40YEQ4TVBQpSqwfLCviQOCTAxoI/HQ=;
        b=B/Hc3Y/cgXStMzr1Ub3muD8+H+D+oEWpLTIIZ/6yICuELy2Ye8fyvMUiDz91hc1diR
         0JhHQH9VfaAn+FoxOcAJtiQ1OWxk3F9pqZclJE3NIMxLwi/S8F0zXxO3+eQtyBhnHrU1
         Tw2nMgOifCDYSCwB5EtWYZYkcDeNArYwoqGL/2oXaErwpD98znSxbc3E5I+zV3IC7Lym
         fgwvI6ZjitseBGgtJsIE0Gwkx1t0J3NfxSqerM6bras6H/2LlTuR/L90FJ+9flO+gsmH
         OVDJxLumeb/fOkWs2d7tV8nlwKhN0z3AbxD2poWG8NkbQvrPm1cI1fityG6LkatpaBlc
         Ijeg==
X-Gm-Message-State: ACrzQf25vQayaIQ7V5bsvpOHfu5Y0xZx6plp5a5T3X3HS318JBjATxqu
        iEQLdQprSUgrAJiv/rkBV3Yz+Q==
X-Google-Smtp-Source: AMsMyM4WOMAC/5xDPJPc5+fsnhnpk/mcZMNbCH7XTeLgtC4oI/4jA2tl34CfUIiOLYHbsSFmUQkhHw==
X-Received: by 2002:a1c:7215:0:b0:3c7:130c:a77f with SMTP id n21-20020a1c7215000000b003c7130ca77fmr7446309wmc.151.1666903479106;
        Thu, 27 Oct 2022 13:44:39 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id n3-20020a5d6b83000000b00236644228besm1968739wrx.40.2022.10.27.13.44.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 13:44:38 -0700 (PDT)
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
Subject: [PATCH v3 29/36] selftest/tcp-ao: Add a test for MKT matching
Date:   Thu, 27 Oct 2022 21:43:40 +0100
Message-Id: <20221027204347.529913-30-dima@arista.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027204347.529913-1-dima@arista.com>
References: <20221027204347.529913-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add TCP-AO tests on connect()/accept() pair.
SNMP counters exposed by kernel are very useful here to verify the
expected behavior of TCP-AO.

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 tools/testing/selftests/net/tcp_ao/Makefile   |   2 +-
 .../selftests/net/tcp_ao/connect-deny.c       | 217 ++++++++++++++++++
 2 files changed, 218 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/net/tcp_ao/connect-deny.c

diff --git a/tools/testing/selftests/net/tcp_ao/Makefile b/tools/testing/selftests/net/tcp_ao/Makefile
index a178bde0af08..5064e34ebe38 100644
--- a/tools/testing/selftests/net/tcp_ao/Makefile
+++ b/tools/testing/selftests/net/tcp_ao/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-TEST_BOTH_AF := connect icmps-discard icmps-accept
+TEST_BOTH_AF := connect icmps-discard icmps-accept connect-deny
 
 TEST_IPV4_PROGS := $(TEST_BOTH_AF:%=%_ipv4)
 TEST_IPV6_PROGS := $(TEST_BOTH_AF:%=%_ipv6)
diff --git a/tools/testing/selftests/net/tcp_ao/connect-deny.c b/tools/testing/selftests/net/tcp_ao/connect-deny.c
new file mode 100644
index 000000000000..8f1b067e611f
--- /dev/null
+++ b/tools/testing/selftests/net/tcp_ao/connect-deny.c
@@ -0,0 +1,217 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Author: Dmitry Safonov <dima@arista.com> */
+#include <inttypes.h>
+#include "aolib.h"
+
+typedef uint8_t fault_t;
+#define F_TIMEOUT	1
+#define F_KEYREJECT	2
+
+#define fault(type)	(inj == type)
+
+static void try_accept(const char *tst_name, unsigned int port, const char *pwd,
+		       union tcp_addr addr, uint8_t prefix,
+		       uint8_t sndid, uint8_t rcvid, const char *cnt_name,
+		       fault_t inj)
+{
+	uint64_t before_cnt, after_cnt;
+	int lsk, err, sk = 0;
+	time_t timeout;
+
+	lsk = test_listen_socket(this_ip_addr, port, 1);
+
+	if (pwd && test_set_ao(lsk, pwd, 0, addr, prefix, sndid, rcvid))
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
+static void *server_fn(void *arg)
+{
+	union tcp_addr wrong_addr, network_addr;
+	unsigned int port = test_server_port;
+
+	if (inet_pton(TEST_FAMILY, TEST_WRONG_IP, &wrong_addr) != 1)
+		test_error("Can't convert ip address %s", TEST_WRONG_IP);
+
+	try_accept("Non-AO server + AO client", port++, NULL,
+		this_ip_dest, -1, 100, 100, "TCPAOKeyNotFound", F_TIMEOUT);
+
+	try_accept("AO server + Non-AO client", port++, "password",
+		this_ip_dest, -1, 100, 100, "TCPAORequired", F_TIMEOUT);
+
+	try_accept("Wrong password", port++, "password2",
+		this_ip_dest, -1, 100, 100, "TCPAOBad", F_TIMEOUT);
+
+	try_accept("Wrong rcv id", port++, "password",
+		this_ip_dest, -1, 100, 101, "TCPAOKeyNotFound", F_TIMEOUT);
+
+	try_accept("Wrong snd id", port++, "password",
+		this_ip_dest, -1, 101, 100, "TCPAOGood", F_TIMEOUT);
+
+	try_accept("Server: Wrong addr", port++, "password",
+		wrong_addr, -1, 100, 100, "TCPAOKeyNotFound", F_TIMEOUT);
+
+	try_accept("Client: Wrong addr", port++, NULL,
+		this_ip_dest, -1, 100, 100, NULL, F_TIMEOUT);
+
+	try_accept("rcv id != snd id", port++, "password",
+		this_ip_dest, -1, 200, 100, "TCPAOGood", 0);
+
+	if (inet_pton(TEST_FAMILY, TEST_NETWORK, &network_addr) != 1)
+		test_error("Can't convert ip address %s", TEST_NETWORK);
+
+	try_accept("Server: prefix match", port++, "password",
+		network_addr, 16, 100, 100, "TCPAOGood", 0);
+
+	try_accept("Client: prefix match", port++, "password",
+		this_ip_dest, -1, 100, 100, "TCPAOGood", 0);
+
+	/* client exits */
+	synchronize_threads();
+	return NULL;
+}
+
+static void try_connect(const char *tst_name, unsigned int port,
+			const char *pwd, union tcp_addr addr, uint8_t prefix,
+			uint8_t sndid, uint8_t rcvid, fault_t inj)
+{
+	time_t timeout;
+	int sk, ret;
+
+	sk = socket(test_family, SOCK_STREAM, IPPROTO_TCP);
+	if (sk < 0)
+		test_error("socket()");
+
+	if (pwd && test_set_ao(sk, pwd, 0, addr, prefix, sndid, rcvid))
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
+
+	if (ret > 0)
+		close(sk);
+}
+
+static void *client_fn(void *arg)
+{
+	union tcp_addr wrong_addr, network_addr;
+	unsigned int port = test_server_port;
+
+	if (inet_pton(TEST_FAMILY, TEST_WRONG_IP, &wrong_addr) != 1)
+		test_error("Can't convert ip address %s", TEST_WRONG_IP);
+
+	try_connect("Non-AO server + AO client", port++, "password",
+			this_ip_dest, -1, 100, 100, F_TIMEOUT);
+
+	try_connect("AO server + Non-AO client", port++, NULL,
+			this_ip_dest, -1, 100, 100, F_TIMEOUT);
+
+	try_connect("Wrong password", port++, "password",
+			this_ip_dest, -1, 100, 100, F_TIMEOUT);
+
+	try_connect("Wrong rcv id", port++, "password",
+			this_ip_dest, -1, 100, 100, F_TIMEOUT);
+
+	try_connect("Wrong snd id", port++, "password",
+			this_ip_dest, -1, 100, 100, F_TIMEOUT);
+
+	try_connect("Server: Wrong addr", port++, "password",
+			this_ip_dest, -1, 100, 100, F_TIMEOUT);
+
+	try_connect("Client: Wrong addr", port++, "password",
+			wrong_addr, -1, 100, 100, F_KEYREJECT);
+
+	try_connect("rcv id != snd id", port++, "password",
+			this_ip_dest, -1, 100, 200, 0);
+
+	if (inet_pton(TEST_FAMILY, TEST_NETWORK, &network_addr) != 1)
+		test_error("Can't convert ip address %s", TEST_NETWORK);
+
+	try_connect("Server: prefix match", port++, "password",
+			this_ip_dest, -1, 100, 100, 0);
+
+	try_connect("Client: prefix match", port++, "password",
+			network_addr, 16, 100, 100, 0);
+
+	return NULL;
+}
+
+int main(int argc, char *argv[])
+{
+	test_init(19, server_fn, client_fn);
+	return 0;
+}
-- 
2.38.1

