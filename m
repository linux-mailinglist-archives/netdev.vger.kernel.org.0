Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4216061034C
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 22:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237160AbiJ0Utr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 16:49:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237017AbiJ0UsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 16:48:03 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0D0C388B
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 13:44:36 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id y16so4138722wrt.12
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 13:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+dNDpMZ6fkxvZpNHtx9aVoLiGrB6s55r98QT6/SQMCk=;
        b=UDIb+teWdBTTzpSz4KNaCmDTn/PcZjDBYNlVKwqDHo1CxlUUn9IKS+xK5ypQjZF65F
         hfNUj9e4eWzyPrR/C5WDI3ZW4MmT0JXLa6pygmZ+7adeJk12fkFfwISH4jzrLSalX5j7
         jSqkgWIhGre/XBs/GmQh9vLMCDDcJJfzicfj81+iQLMQejn/ZwfB73eNiqLNgZpk7b3+
         uOW7/S01YK9oZDObuinsRBS7xaAovzQliqF5jgA3e8v71hHYlwIDxojPRiZ+tomkQ0AN
         6omOy8BQFyrcnlukd02rxwd/0e8Hc6wpqVVdyAg2HQpsnGdJKQiQQkoAUPzumJCV4rzx
         0BZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+dNDpMZ6fkxvZpNHtx9aVoLiGrB6s55r98QT6/SQMCk=;
        b=ZFfNYNsUZLzBpzH89vybTy2WXmxHqY3hAy3KlT6w24g5hc7fGBdfcJATLkHtTj5ENJ
         FJwBbZ+qigrE27sOqE8+/nQNfS2QzWxslU4oOJifP81BV247hZj9it3yCbbxJCLkU3aF
         eMhno7soQD8CFZiGqC4hy2WraLgQtaZkPCNn/N+qaf+tDppMxAUNuAOfRlp227fjSb66
         hlGUyvzsaOHZ1dwozJlVQbEJ3ZPT6Nk3G2+BGlhF9qPCJ0TKfwqj6tH5CP2IucPeOQeR
         fFWqLyY4g/cb7tOlZjZfyTgH9Eg+qn1m42g0uEPO9QrwjAl8CgqVO4/EVrRobAabeYhT
         Kaww==
X-Gm-Message-State: ACrzQf0564vYB0eUyxdMkHBssh1Lj3E5jbejctRAlFHBhOm/w3nuT/gX
        zfx1IugolL8cYLefWpv5uahISw==
X-Google-Smtp-Source: AMsMyM4Nk3nTpr6hklDn4r8EEA6ikmLzfNDIdJvSTOzHysUPScBD+aQE6UXBqf/zAP9PtyR1JfJ7lA==
X-Received: by 2002:a5d:64c4:0:b0:231:3d94:6eb2 with SMTP id f4-20020a5d64c4000000b002313d946eb2mr32457144wri.580.1666903476174;
        Thu, 27 Oct 2022 13:44:36 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id n3-20020a5d6b83000000b00236644228besm1968739wrx.40.2022.10.27.13.44.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 13:44:35 -0700 (PDT)
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
Subject: [PATCH v3 27/36] selftests/net: Verify that TCP-AO complies with ignoring ICMPs
Date:   Thu, 27 Oct 2022 21:43:38 +0100
Message-Id: <20221027204347.529913-28-dima@arista.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027204347.529913-1-dima@arista.com>
References: <20221027204347.529913-1-dima@arista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hand-crafted ICMP packets are sent to the server, the server checks for
hard/soft errors and fails if any.

Expected output for ipv4 version:
> # ./icmps-discard_ipv4
> 1..3
> # 3164[lib/setup.c:166] rand seed 1642623745
> TAP version 13
> # 3164[lib/proc.c:207]    Snmp6             Ip6InReceives: 0 => 1
> # 3164[lib/proc.c:207]    Snmp6             Ip6InNoRoutes: 0 => 1
> # 3164[lib/proc.c:207]    Snmp6               Ip6InOctets: 0 => 76
> # 3164[lib/proc.c:207]    Snmp6            Ip6InNoECTPkts: 0 => 1
> # 3164[lib/proc.c:207]      Tcp                    InSegs: 2 => 203
> # 3164[lib/proc.c:207]      Tcp                   OutSegs: 1 => 202
> # 3164[lib/proc.c:207]  IcmpMsg                   InType3: 0 => 543
> # 3164[lib/proc.c:207]     Icmp                    InMsgs: 0 => 543
> # 3164[lib/proc.c:207]     Icmp            InDestUnreachs: 0 => 543
> # 3164[lib/proc.c:207]       Ip                InReceives: 2 => 746
> # 3164[lib/proc.c:207]       Ip                InDelivers: 2 => 746
> # 3164[lib/proc.c:207]       Ip               OutRequests: 1 => 202
> # 3164[lib/proc.c:207]    IpExt                  InOctets: 132 => 61684
> # 3164[lib/proc.c:207]    IpExt                 OutOctets: 68 => 31324
> # 3164[lib/proc.c:207]    IpExt               InNoECTPkts: 2 => 744
> # 3164[lib/proc.c:207]   TcpExt               TCPPureAcks: 1 => 2
> # 3164[lib/proc.c:207]   TcpExt           TCPOrigDataSent: 0 => 200
> # 3164[lib/proc.c:207]   TcpExt              TCPDelivered: 0 => 199
> # 3164[lib/proc.c:207]   TcpExt                 TCPAOGood: 2 => 203
> # 3164[lib/proc.c:207]   TcpExt         TCPAODroppedIcmps: 0 => 541
> ok 1 InDestUnreachs delivered 543
> ok 2 Server survived 20000 bytes of traffic
> ok 3 ICMPs ignored 541
> # Totals: pass:3 fail:0 xfail:0 xpass:0 skip:0 error:0

Expected output for ipv6 version:
> # ./icmps-discard_ipv6
> 1..3
> # 3186[lib/setup.c:166] rand seed 1642623803
> TAP version 13
> # 3186[lib/proc.c:207]    Snmp6             Ip6InReceives: 4 => 568
> # 3186[lib/proc.c:207]    Snmp6             Ip6InDelivers: 3 => 564
> # 3186[lib/proc.c:207]    Snmp6            Ip6OutRequests: 2 => 204
> # 3186[lib/proc.c:207]    Snmp6            Ip6InMcastPkts: 1 => 4
> # 3186[lib/proc.c:207]    Snmp6           Ip6OutMcastPkts: 0 => 1
> # 3186[lib/proc.c:207]    Snmp6               Ip6InOctets: 320 => 70420
> # 3186[lib/proc.c:207]    Snmp6              Ip6OutOctets: 160 => 35512
> # 3186[lib/proc.c:207]    Snmp6          Ip6InMcastOctets: 72 => 336
> # 3186[lib/proc.c:207]    Snmp6         Ip6OutMcastOctets: 0 => 76
> # 3186[lib/proc.c:207]    Snmp6            Ip6InNoECTPkts: 4 => 568
> # 3186[lib/proc.c:207]    Snmp6               Icmp6InMsgs: 1 => 361
> # 3186[lib/proc.c:207]    Snmp6              Icmp6OutMsgs: 1 => 2
> # 3186[lib/proc.c:207]    Snmp6       Icmp6InDestUnreachs: 0 => 360
> # 3186[lib/proc.c:207]    Snmp6      Icmp6OutMLDv2Reports: 0 => 1
> # 3186[lib/proc.c:207]    Snmp6              Icmp6InType1: 0 => 360
> # 3186[lib/proc.c:207]    Snmp6           Icmp6OutType143: 0 => 1
> # 3186[lib/proc.c:207]      Tcp                    InSegs: 2 => 203
> # 3186[lib/proc.c:207]      Tcp                   OutSegs: 1 => 202
> # 3186[lib/proc.c:207]   TcpExt               TCPPureAcks: 1 => 2
> # 3186[lib/proc.c:207]   TcpExt           TCPOrigDataSent: 0 => 200
> # 3186[lib/proc.c:207]   TcpExt              TCPDelivered: 0 => 199
> # 3186[lib/proc.c:207]   TcpExt                 TCPAOGood: 2 => 203
> # 3186[lib/proc.c:207]   TcpExt         TCPAODroppedIcmps: 0 => 360
> ok 1 Icmp6InDestUnreachs delivered 360
> ok 2 Server survived 20000 bytes of traffic
> ok 3 ICMPs ignored 360
> # Totals: pass:3 fail:0 xfail:0 xpass:0 skip:0 error:0

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 tools/testing/selftests/net/tcp_ao/Makefile   |   2 +-
 .../selftests/net/tcp_ao/icmps-discard.c      | 433 ++++++++++++++++++
 2 files changed, 434 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/net/tcp_ao/icmps-discard.c

diff --git a/tools/testing/selftests/net/tcp_ao/Makefile b/tools/testing/selftests/net/tcp_ao/Makefile
index cb23d67944d7..9acfd782c20f 100644
--- a/tools/testing/selftests/net/tcp_ao/Makefile
+++ b/tools/testing/selftests/net/tcp_ao/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-TEST_BOTH_AF := connect
+TEST_BOTH_AF := connect icmps-discard
 
 TEST_IPV4_PROGS := $(TEST_BOTH_AF:%=%_ipv4)
 TEST_IPV6_PROGS := $(TEST_BOTH_AF:%=%_ipv6)
diff --git a/tools/testing/selftests/net/tcp_ao/icmps-discard.c b/tools/testing/selftests/net/tcp_ao/icmps-discard.c
new file mode 100644
index 000000000000..07eba1308b4e
--- /dev/null
+++ b/tools/testing/selftests/net/tcp_ao/icmps-discard.c
@@ -0,0 +1,433 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Selftest that verifies that incomping ICMPs are ignored,
+ * the TCP connection stays alive, no hard or soft errors get reported
+ * to the usespace and the counter for ignored ICMPs is updated.
+ *
+ * RFC5925, 7.8:
+ * >> A TCP-AO implementation MUST default to ignore incoming ICMPv4
+ * messages of Type 3 (destination unreachable), Codes 2-4 (protocol
+ * unreachable, port unreachable, and fragmentation needed -- ’hard
+ * errors’), and ICMPv6 Type 1 (destination unreachable), Code 1
+ * (administratively prohibited) and Code 4 (port unreachable) intended
+ * for connections in synchronized states (ESTABLISHED, FIN-WAIT-1, FIN-
+ * WAIT-2, CLOSE-WAIT, CLOSING, LAST-ACK, TIME-WAIT) that match MKTs.
+ *
+ * Author: Dmitry Safonov <dima@arista.com>
+ */
+#include <inttypes.h>
+#include <linux/icmp.h>
+#include <linux/icmpv6.h>
+#include <linux/ipv6.h>
+#include <netinet/in.h>
+#include <netinet/ip.h>
+#include <sys/socket.h>
+#include "aolib.h"
+
+#ifndef SOL_TCP
+/* can't include <netinet/tcp.h> as including <linux/tcp.h> */
+# define SOL_TCP		6	/* TCP level */
+#endif
+
+const size_t packets_nr = 20;
+const size_t packet_size = 100;
+const char *tcpao_icmps	= "TCPAODroppedIcmps";
+
+#ifdef IPV6_TEST
+const char *dst_unreach	= "Icmp6InDestUnreachs";
+const int sk_ip_level	= SOL_IPV6;
+const int sk_recverr	= IPV6_RECVERR;
+#else
+const char *dst_unreach	= "InDestUnreachs";
+const int sk_ip_level	= SOL_IP;
+const int sk_recverr	= IP_RECVERR;
+#endif
+
+#define test_icmps_fail test_fail
+#define test_icmps_ok test_ok
+
+static void serve_interfered(int sk)
+{
+	ssize_t test_quota = packet_size * packets_nr * 10;
+	uint64_t dest_unreach_a, dest_unreach_b;
+	uint64_t icmp_ignored_a, icmp_ignored_b;
+	bool counter_not_found;
+	struct netstat *ns_after, *ns_before;
+	ssize_t bytes;
+
+	ns_before = netstat_read();
+	dest_unreach_a = netstat_get(ns_before, dst_unreach, NULL);
+	icmp_ignored_a = netstat_get(ns_before, tcpao_icmps, NULL);
+	bytes = test_server_run(sk, test_quota, 0);
+	ns_after = netstat_read();
+	netstat_print_diff(ns_before, ns_after);
+	dest_unreach_b = netstat_get(ns_after, dst_unreach, NULL);
+	icmp_ignored_b = netstat_get(ns_after, tcpao_icmps,
+					&counter_not_found);
+
+	netstat_free(ns_before);
+	netstat_free(ns_after);
+
+	if (dest_unreach_a >= dest_unreach_b) {
+		test_fail("%s counter didn't change: %" PRIu64 " >= %" PRIu64,
+				dst_unreach, dest_unreach_a, dest_unreach_b);
+		return;
+	}
+	test_ok("%s delivered %" PRIu64,
+		dst_unreach, dest_unreach_b - dest_unreach_a);
+	if (bytes < 0)
+		test_icmps_fail("Server failed with %zd: %s", bytes, strerrordesc_np(-bytes));
+	else
+		test_icmps_ok("Server survived %zd bytes of traffic", test_quota);
+	if (counter_not_found) {
+		test_fail("Not found %s counter", tcpao_icmps);
+		return;
+	}
+	if (icmp_ignored_a >= icmp_ignored_b) {
+		test_icmps_fail("%s counter didn't change: %" PRIu64 " >= %" PRIu64,
+				tcpao_icmps, icmp_ignored_a, icmp_ignored_b);
+		return;
+	}
+	test_icmps_ok("ICMPs ignored %" PRIu64, icmp_ignored_b - icmp_ignored_a);
+}
+
+static void *server_fn(void *arg)
+{
+	int val, err, sk, lsk;
+	uint16_t flags = 0;
+
+	lsk = test_listen_socket(this_ip_addr, test_server_port, 1);
+
+	if (test_set_ao(lsk, "password", flags, this_ip_dest, -1, 100, 100))
+		test_error("setsockopt(TCP_AO)");
+	synchronize_threads();
+
+	err = test_wait_fd(lsk, TEST_TIMEOUT_SEC, 0);
+	if (!err)
+		test_error("timeouted for accept()");
+	else if (err < 0)
+		test_error("test_wait_fd()");
+
+	sk = accept(lsk, NULL, NULL);
+	if (sk < 0)
+		test_error("accept()");
+
+	/* Fail on hard ip errors, such as dest unreachable (RFC1122) */
+	val = 1;
+	if (setsockopt(sk, sk_ip_level, sk_recverr, &val, sizeof(val)))
+		test_error("setsockopt()");
+
+	synchronize_threads();
+
+	serve_interfered(sk);
+	return NULL;
+}
+
+static size_t packets_sent;
+static size_t icmps_sent;
+
+static uint32_t checksum4_nofold(void *data, size_t len, uint32_t sum)
+{
+	uint16_t *words = data;
+	size_t i;
+
+	for (i = 0; i < len / sizeof(uint16_t); i++)
+		sum += words[i];
+	if (len & 1)
+		sum += ((char *)data)[len - 1];
+	return sum;
+}
+
+static uint16_t checksum4_fold(void *data, size_t len, uint32_t sum)
+{
+	sum = checksum4_nofold(data, len, sum);
+	while (sum > 0xFFFF)
+		sum = (sum & 0xFFFF) + (sum >> 16);
+	return ~sum;
+}
+
+static void set_ip4hdr(struct iphdr *iph, size_t packet_len, int proto,
+		struct sockaddr_in *src, struct sockaddr_in *dst)
+{
+	iph->version	= 4;
+	iph->ihl	= 5;
+	iph->tos	= 0;
+	iph->tot_len	= htons(packet_len);
+	iph->ttl	= 2;
+	iph->protocol	= proto;
+	iph->saddr	= src->sin_addr.s_addr;
+	iph->daddr	= dst->sin_addr.s_addr;
+	iph->check	= checksum4_fold((void *)iph, iph->ihl << 1, 0);
+}
+
+static void icmp_interfere4(uint8_t type, uint8_t code, uint32_t rcv_nxt,
+		struct sockaddr_in *src, struct sockaddr_in *dst)
+{
+	int sk = socket(AF_INET, SOCK_RAW, IPPROTO_RAW);
+	struct {
+		struct iphdr iph;
+		struct icmphdr icmph;
+		struct iphdr iphe;
+		struct {
+			uint16_t sport;
+			uint16_t dport;
+			uint32_t seq;
+		} tcph;
+	} packet = {};
+	size_t packet_len;
+	ssize_t bytes;
+
+	if (sk < 0)
+		test_error("socket(AF_INET, SOCK_RAW, IPPROTO_RAW)");
+
+	packet_len = sizeof(packet);
+	set_ip4hdr(&packet.iph, packet_len, IPPROTO_ICMP, src, dst);
+
+	packet.icmph.type = type;
+	packet.icmph.code = code;
+	if (code == ICMP_FRAG_NEEDED) {
+		randomize_buffer(&packet.icmph.un.frag.mtu,
+				sizeof(packet.icmph.un.frag.mtu));
+	}
+
+	packet_len = sizeof(packet.iphe) + sizeof(packet.tcph);
+	set_ip4hdr(&packet.iphe, packet_len, IPPROTO_TCP, dst, src);
+
+	packet.tcph.sport = dst->sin_port;
+	packet.tcph.dport = src->sin_port;
+	packet.tcph.seq = htonl(rcv_nxt);
+
+	packet_len = sizeof(packet) - sizeof(packet.iph);
+	packet.icmph.checksum = checksum4_fold((void *)&packet.icmph,
+						packet_len, 0);
+
+	bytes = sendto(sk, &packet, sizeof(packet), 0,
+		       (struct sockaddr *)dst, sizeof(*dst));
+	if (bytes != sizeof(packet))
+		test_error("send(): %zd", bytes);
+	icmps_sent++;
+
+	close(sk);
+}
+
+static void set_ip6hdr(struct ipv6hdr *iph, size_t packet_len, int proto,
+		struct sockaddr_in6 *src, struct sockaddr_in6 *dst)
+{
+	iph->version		= 6;
+	iph->payload_len	= htons(packet_len);
+	iph->nexthdr		= proto;
+	iph->hop_limit		= 2;
+	iph->saddr		= src->sin6_addr;
+	iph->daddr		= dst->sin6_addr;
+}
+
+static inline uint16_t csum_fold(uint32_t csum)
+{
+	uint32_t sum = csum;
+
+	sum = (sum & 0xffff) + (sum >> 16);
+	sum = (sum & 0xffff) + (sum >> 16);
+	return (uint16_t)~sum;
+}
+
+static inline uint32_t csum_add(uint32_t csum, uint32_t addend)
+{
+	uint32_t res = csum;
+
+	res += addend;
+	return res + (res < addend);
+}
+
+__attribute__ ((noinline)) uint32_t checksum6_nofold(void *data, size_t len, uint32_t sum)
+{
+	uint16_t *words = data;
+	size_t i;
+
+	for (i = 0; i < len / sizeof(uint16_t); i++)
+		sum = csum_add(sum, words[i]);
+	if (len & 1)
+		sum = csum_add(sum, ((char *)data)[len - 1]);
+	return sum;
+}
+
+__attribute__ ((noinline)) uint16_t icmp6_checksum(struct sockaddr_in6 *src,
+			struct sockaddr_in6 *dst,
+			void *ptr, size_t len, uint8_t proto)
+{
+	struct {
+		struct in6_addr saddr;
+		struct in6_addr daddr;
+		uint32_t payload_len;
+		uint8_t zero[3];
+		uint8_t nexthdr;
+	} pseudo_header = {};
+	uint32_t sum;
+
+	pseudo_header.saddr		= src->sin6_addr;
+	pseudo_header.daddr		= dst->sin6_addr;
+	pseudo_header.payload_len	= htonl(len);
+	pseudo_header.nexthdr		= proto;
+
+	sum = checksum6_nofold(&pseudo_header, sizeof(pseudo_header), 0);
+	sum = checksum6_nofold(ptr, len, sum);
+
+	return csum_fold(sum);
+}
+
+static void icmp6_interfere(int type, int code, uint32_t rcv_nxt,
+		struct sockaddr_in6 *src, struct sockaddr_in6 *dst)
+{
+	int sk = socket(AF_INET6, SOCK_RAW, IPPROTO_RAW);
+	struct sockaddr_in6 dst_raw = *dst;
+	struct {
+		struct ipv6hdr iph;
+		struct icmp6hdr icmph;
+		struct ipv6hdr iphe;
+		struct {
+			uint16_t sport;
+			uint16_t dport;
+			uint32_t seq;
+		} tcph;
+	} packet = {};
+	size_t packet_len;
+	ssize_t bytes;
+
+
+	if (sk < 0)
+		test_error("socket(AF_INET6, SOCK_RAW, IPPROTO_RAW)");
+
+	packet_len = sizeof(packet) - sizeof(packet.iph);
+	set_ip6hdr(&packet.iph, packet_len, IPPROTO_ICMPV6, src, dst);
+
+	packet.icmph.icmp6_type = type;
+	packet.icmph.icmp6_code = code;
+
+	packet_len = sizeof(packet.iphe) + sizeof(packet.tcph);
+	set_ip6hdr(&packet.iphe, packet_len, IPPROTO_TCP, dst, src);
+
+	packet.tcph.sport = dst->sin6_port;
+	packet.tcph.dport = src->sin6_port;
+	packet.tcph.seq = htonl(rcv_nxt);
+
+	packet_len = sizeof(packet) - sizeof(packet.iph);
+
+	packet.icmph.icmp6_cksum = icmp6_checksum(src, dst,
+			(void *)&packet.icmph, packet_len, IPPROTO_ICMPV6);
+
+	dst_raw.sin6_port = htons(IPPROTO_RAW);
+	bytes = sendto(sk, &packet, sizeof(packet), 0,
+		       (struct sockaddr *)&dst_raw, sizeof(dst_raw));
+	if (bytes != sizeof(packet))
+		test_error("send(): %zd", bytes);
+	icmps_sent++;
+
+	close(sk);
+}
+
+static uint32_t get_rcv_nxt(int sk)
+{
+	int val = TCP_REPAIR_ON;
+	uint32_t ret;
+	socklen_t sz = sizeof(ret);
+
+	if (setsockopt(sk, SOL_TCP, TCP_REPAIR, &val, sizeof(val)))
+		test_error("setsockopt(TCP_REPAIR)");
+	val = TCP_RECV_QUEUE;
+	if (setsockopt(sk, SOL_TCP, TCP_REPAIR_QUEUE, &val, sizeof(val)))
+		test_error("setsockopt(TCP_REPAIR_QUEUE)");
+	if (getsockopt(sk, SOL_TCP, TCP_QUEUE_SEQ, &ret, &sz))
+		test_error("getsockopt(TCP_QUEUE_SEQ)");
+	val = TCP_REPAIR_OFF_NO_WP;
+	if (setsockopt(sk, SOL_TCP, TCP_REPAIR, &val, sizeof(val)))
+		test_error("setsockopt(TCP_REPAIR)");
+	return ret;
+}
+
+static void icmp_interfere(const size_t nr, uint32_t rcv_nxt, void *src, void *dst)
+{
+	struct sockaddr_in *saddr4 = src;
+	struct sockaddr_in *daddr4 = dst;
+	struct sockaddr_in6 *saddr6 = src;
+	struct sockaddr_in6 *daddr6 = dst;
+	size_t i;
+
+	if (saddr4->sin_family != daddr4->sin_family)
+		test_error("Different address families");
+
+	for (i = 0; i < nr; i++) {
+		if (saddr4->sin_family == AF_INET) {
+			icmp_interfere4(ICMP_DEST_UNREACH, ICMP_PROT_UNREACH,
+					rcv_nxt, saddr4, daddr4);
+			icmp_interfere4(ICMP_DEST_UNREACH, ICMP_PORT_UNREACH,
+					rcv_nxt, saddr4, daddr4);
+			icmp_interfere4(ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
+					rcv_nxt, saddr4, daddr4);
+			icmps_sent += 3;
+		} else if (saddr4->sin_family == AF_INET6) {
+			icmp6_interfere(ICMPV6_DEST_UNREACH,
+					ICMPV6_ADM_PROHIBITED,
+					rcv_nxt, saddr6, daddr6);
+			icmp6_interfere(ICMPV6_DEST_UNREACH,
+					ICMPV6_PORT_UNREACH,
+					rcv_nxt, saddr6, daddr6);
+			icmps_sent += 2;
+		} else {
+			test_error("Not ip address family");
+		}
+	}
+}
+
+static void send_interfered(int sk)
+{
+	const unsigned int timeout = TEST_TIMEOUT_SEC;
+	struct sockaddr_in6 src, dst;
+	socklen_t addr_sz;
+
+	addr_sz = sizeof(src);
+	if (getsockname(sk, &src, &addr_sz))
+		test_error("getsockname()");
+	addr_sz = sizeof(dst);
+	if (getpeername(sk, &dst, &addr_sz))
+		test_error("getpeername()");
+
+	while (1) {
+		uint32_t rcv_nxt;
+
+		if (test_client_verify(sk, packet_size, packets_nr, timeout)) {
+			test_fail("client: connection is broken");
+			return;
+		}
+		packets_sent += packets_nr;
+		rcv_nxt = get_rcv_nxt(sk);
+		icmp_interfere(packets_nr, rcv_nxt, (void *)&src, (void *)&dst);
+	}
+}
+
+static void *client_fn(void *arg)
+{
+	int sk = socket(test_family, SOCK_STREAM, IPPROTO_TCP);
+
+	if (sk < 0)
+		test_error("socket()");
+
+	if (test_set_ao(sk, "password", 0, this_ip_dest, -1, 100, 100))
+		test_error("setsockopt(TCP_AO)");
+
+	synchronize_threads();
+	if (test_connect_socket(sk, this_ip_dest, test_server_port) <= 0)
+		test_error("failed to connect()");
+	synchronize_threads();
+
+	send_interfered(sk);
+
+	/* Not expecting client to quit */
+	test_fail("client disconnected");
+
+	return NULL;
+}
+
+int main(int argc, char *argv[])
+{
+	test_init(3, server_fn, client_fn);
+	return 0;
+}
-- 
2.38.1

