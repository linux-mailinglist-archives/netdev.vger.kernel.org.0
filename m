Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 595CA61036C
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 22:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237164AbiJ0Uwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 16:52:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237163AbiJ0Uvz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 16:51:55 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABB747AB12
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 13:45:24 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id k8so4194841wrh.1
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 13:45:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kP+SAh+F64ZkLFr52URQ+wzrGshBfXjUpIMRDp+w/YQ=;
        b=cjMFkXCN4OjefEPDADI83YvwiOmM1qytWHgGNelAN009vdYvGIkY/Q7uaAdtyFEzE8
         paYJTrR5gn0aUFKNDEsNIy1KbtVTChRSbBHjTOeXWj+IpauZaycnbpOJCwPuf9+wUxZm
         4NCYOREUuXnpfaOQX+letnek2oWN4OUe8Oq3uOhM7HE+m41ri79jqVH+JP/E1BtUkC/9
         H52jpASiiO4tr7hNkSVdD+AIl3AKLW0JkY7anJ7C6kT2AbDyUeX2cmMhHr9OIO9K1N+/
         vjsHW0ebaiPJa90XBql9eGGp0iVpEMGL94eO3d+xKkk+fn9mB7LBpji+Ex5hF4WBt6q5
         B1cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kP+SAh+F64ZkLFr52URQ+wzrGshBfXjUpIMRDp+w/YQ=;
        b=Bp1tmEOZVpaR4SGnA+OXSTjZ3WobM1fRYymxeUJ0qIm+XxlKgAlAuFG+pOfSBjLaUc
         6GxW/B/SLsAW28bMuPZCd+DiULD/uEXplZzDHLcQl02slQEun3bWnRjm9EuxcS9wqXa9
         7XmC3uVB6bKWVacyybO9fGkPXqR0g6UI/UOaUcoYA/UqHRtZYXLLZkEmjyWzkNVLMByN
         Ik6Ebu/w0bVQZf+JSOTEo9T3kb6q3ygMufyHyAAUzd22WZZjABCNxxn94mY7iolR1ddQ
         Is+X0Sjah8ZRmLXAf/IGzZA/s1I/asr/e/x3i7TeFh5SbPFQqtsAaBpcOnbPDsn2LJuU
         zW3w==
X-Gm-Message-State: ACrzQf0MDXs4oJVNJ+dMO8pcZmdSH/J1PRiQtDWHIokLnbxCfO/nyKO/
        0X/OdnHGCkutJpx98Ruk0aD2OA==
X-Google-Smtp-Source: AMsMyM5vCqk71RZPJ/r8tzBefdkb+G+uw3UohC97chYG1D+N0POj8bODmJ3NxPNdNtv2JPvA2He2eg==
X-Received: by 2002:a5d:590d:0:b0:236:4ddd:1869 with SMTP id v13-20020a5d590d000000b002364ddd1869mr23913510wrd.709.1666903477662;
        Thu, 27 Oct 2022 13:44:37 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id n3-20020a5d6b83000000b00236644228besm1968739wrx.40.2022.10.27.13.44.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 13:44:37 -0700 (PDT)
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
Subject: [PATCH v3 28/36] selftest/net: Add TCP-AO ICMPs accept test
Date:   Thu, 27 Oct 2022 21:43:39 +0100
Message-Id: <20221027204347.529913-29-dima@arista.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027204347.529913-1-dima@arista.com>
References: <20221027204347.529913-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reverse to icmps-discard test: the server accepts ICMPs, using
TCP_AO_CMDF_ACCEPT_ICMP and it is expected to fail under ICMP
flood from client. Test that the default pre-TCP-AO behaviour functions
when TCP_AO_CMDF_ACCEPT_ICMP is set.

Expected output for ipv4 version (in case it receives ICMP_PROT_UNREACH):
> # ./icmps-accept_ipv4
> 1..3
> # 3209[lib/setup.c:166] rand seed 1642623870
> TAP version 13
> # 3209[lib/proc.c:207]    Snmp6             Ip6InReceives: 0 => 1
> # 3209[lib/proc.c:207]    Snmp6             Ip6InNoRoutes: 0 => 1
> # 3209[lib/proc.c:207]    Snmp6               Ip6InOctets: 0 => 76
> # 3209[lib/proc.c:207]    Snmp6            Ip6InNoECTPkts: 0 => 1
> # 3209[lib/proc.c:207]      Tcp                    InSegs: 3 => 23
> # 3209[lib/proc.c:207]      Tcp                   OutSegs: 2 => 22
> # 3209[lib/proc.c:207]  IcmpMsg                   InType3: 0 => 4
> # 3209[lib/proc.c:207]     Icmp                    InMsgs: 0 => 4
> # 3209[lib/proc.c:207]     Icmp            InDestUnreachs: 0 => 4
> # 3209[lib/proc.c:207]       Ip                InReceives: 3 => 27
> # 3209[lib/proc.c:207]       Ip                InDelivers: 3 => 27
> # 3209[lib/proc.c:207]       Ip               OutRequests: 2 => 22
> # 3209[lib/proc.c:207]    IpExt                  InOctets: 288 => 3420
> # 3209[lib/proc.c:207]    IpExt                 OutOctets: 124 => 3244
> # 3209[lib/proc.c:207]    IpExt               InNoECTPkts: 3 => 25
> # 3209[lib/proc.c:207]   TcpExt               TCPPureAcks: 1 => 2
> # 3209[lib/proc.c:207]   TcpExt           TCPOrigDataSent: 0 => 20
> # 3209[lib/proc.c:207]   TcpExt              TCPDelivered: 0 => 19
> # 3209[lib/proc.c:207]   TcpExt                 TCPAOGood: 3 => 23
> ok 1 InDestUnreachs delivered 4
> ok 2 server failed with -92: Protocol not available
> ok 3 TCPAODroppedIcmps counter didn't change: 0 >= 0
> # Totals: pass:3 fail:0 xfail:0 xpass:0 skip:0 error:0

Expected output for ipv6 version (in case it receives ADM_PROHIBITED):
> # ./icmps-accept_ipv6
> 1..3
> # 3277[lib/setup.c:166] rand seed 1642624035
> TAP version 13
> # 3277[lib/proc.c:207]    Snmp6             Ip6InReceives: 6 => 31
> # 3277[lib/proc.c:207]    Snmp6             Ip6InDelivers: 4 => 29
> # 3277[lib/proc.c:207]    Snmp6            Ip6OutRequests: 4 => 24
> # 3277[lib/proc.c:207]    Snmp6               Ip6InOctets: 592 => 4492
> # 3277[lib/proc.c:207]    Snmp6              Ip6OutOctets: 332 => 3852
> # 3277[lib/proc.c:207]    Snmp6            Ip6InNoECTPkts: 6 => 31
> # 3277[lib/proc.c:207]    Snmp6               Icmp6InMsgs: 1 => 6
> # 3277[lib/proc.c:207]    Snmp6       Icmp6InDestUnreachs: 0 => 5
> # 3277[lib/proc.c:207]    Snmp6              Icmp6InType1: 0 => 5
> # 3277[lib/proc.c:207]      Tcp                    InSegs: 3 => 23
> # 3277[lib/proc.c:207]      Tcp                   OutSegs: 2 => 22
> # 3277[lib/proc.c:207]   TcpExt               TCPPureAcks: 1 => 2
> # 3277[lib/proc.c:207]   TcpExt           TCPOrigDataSent: 0 => 20
> # 3277[lib/proc.c:207]   TcpExt              TCPDelivered: 0 => 19
> # 3277[lib/proc.c:207]   TcpExt                 TCPAOGood: 3 => 23
> ok 1 Icmp6InDestUnreachs delivered 5
> ok 2 server failed with -13: Permission denied
> ok 3 TCPAODroppedIcmps counter didn't change: 0 >= 0
> # Totals: pass:3 fail:0 xfail:0 xpass:0 skip:0 error:0

With some luck the server may fail with ECONNREFUSED (depending on what
icmp packet was delivered firstly).
For the kernel error handlers see: tab_unreach[] and icmp_err_convert[].

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 tools/testing/selftests/net/tcp_ao/Makefile     |  4 +++-
 .../testing/selftests/net/tcp_ao/icmps-accept.c |  1 +
 .../selftests/net/tcp_ao/icmps-discard.c        | 17 +++++++++++++++--
 3 files changed, 19 insertions(+), 3 deletions(-)
 create mode 120000 tools/testing/selftests/net/tcp_ao/icmps-accept.c

diff --git a/tools/testing/selftests/net/tcp_ao/Makefile b/tools/testing/selftests/net/tcp_ao/Makefile
index 9acfd782c20f..a178bde0af08 100644
--- a/tools/testing/selftests/net/tcp_ao/Makefile
+++ b/tools/testing/selftests/net/tcp_ao/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-TEST_BOTH_AF := connect icmps-discard
+TEST_BOTH_AF := connect icmps-discard icmps-accept
 
 TEST_IPV4_PROGS := $(TEST_BOTH_AF:%=%_ipv4)
 TEST_IPV6_PROGS := $(TEST_BOTH_AF:%=%_ipv6)
@@ -43,3 +43,5 @@ $(OUTPUT)/%_ipv4: %.c
 $(OUTPUT)/%_ipv6: %.c
 	$(LINK.c) -DIPV6_TEST $^ $(LDLIBS) -o $@
 
+$(OUTPUT)/icmps-accept_ipv4: CFLAGS+= -DTEST_ICMPS_ACCEPT
+$(OUTPUT)/icmps-accept_ipv6: CFLAGS+= -DTEST_ICMPS_ACCEPT
diff --git a/tools/testing/selftests/net/tcp_ao/icmps-accept.c b/tools/testing/selftests/net/tcp_ao/icmps-accept.c
new file mode 120000
index 000000000000..0a5bb85eb260
--- /dev/null
+++ b/tools/testing/selftests/net/tcp_ao/icmps-accept.c
@@ -0,0 +1 @@
+icmps-discard.c
\ No newline at end of file
diff --git a/tools/testing/selftests/net/tcp_ao/icmps-discard.c b/tools/testing/selftests/net/tcp_ao/icmps-discard.c
index 07eba1308b4e..d90017dfc20d 100644
--- a/tools/testing/selftests/net/tcp_ao/icmps-discard.c
+++ b/tools/testing/selftests/net/tcp_ao/icmps-discard.c
@@ -43,8 +43,17 @@ const int sk_ip_level	= SOL_IP;
 const int sk_recverr	= IP_RECVERR;
 #endif
 
-#define test_icmps_fail test_fail
-#define test_icmps_ok test_ok
+/*
+ * Server is expected to fail with hard error if
+ * TCP_AO_CMDF_ACCEPT_ICMP is set
+ */
+#ifdef TEST_ICMPS_ACCEPT
+# define test_icmps_fail test_ok
+# define test_icmps_ok test_fail
+#else
+# define test_icmps_fail test_fail
+# define test_icmps_ok test_ok
+#endif
 
 static void serve_interfered(int sk)
 {
@@ -98,6 +107,10 @@ static void *server_fn(void *arg)
 
 	lsk = test_listen_socket(this_ip_addr, test_server_port, 1);
 
+#ifdef TEST_ICMPS_ACCEPT
+	flags = TCP_AO_CMDF_ACCEPT_ICMP;
+#endif
+
 	if (test_set_ao(lsk, "password", flags, this_ip_dest, -1, 100, 100))
 		test_error("setsockopt(TCP_AO)");
 	synchronize_threads();
-- 
2.38.1

