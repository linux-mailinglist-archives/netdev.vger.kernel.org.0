Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE90B471600
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 21:05:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbhLKUFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 15:05:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbhLKUFB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 15:05:01 -0500
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EBDBC061714
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 12:05:01 -0800 (PST)
Received: by mail-qk1-x72a.google.com with SMTP id a11so10817248qkh.13
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 12:05:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5CXPchkpK0vvvKJ00OVXwrqGNnfDOQPRx1wvvRuVKU4=;
        b=aaN42IhtoWDpvnD3Bz9LOMiXwNpDbp1+Hfd6yxvxQmSLpK98zN37tOZg9C+gbMNPQT
         HwKUcVLQtBj6yvsjFLCeBDAt2NMEqsgVlptv8j5jF60enWxgvZ9zdRa3DXShJtpVJS3V
         KVcQrxC0ZbpzBGepdOct8x7ozL+6NbYskATPEf9DoAYIqYTXdy0OBLvQz17DKM9MZO4D
         AoWVIvQ/YW3/68V+Y6a9dcqS+bVk1rBY7MDQjioi9/KE/VjaGnOzDXdbXc7rnA2Qekxx
         9zenW1LMH110KvDoq/VcemCKR2CoXW7Xxjd8L0CKfhopNCsZK7G6jM/TNCETIJb0w/Rk
         EGdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5CXPchkpK0vvvKJ00OVXwrqGNnfDOQPRx1wvvRuVKU4=;
        b=M4bifO7HxR3u+N1ziRy7Y/0lZKqP2Fd429pPgs7PbF96pjLujFUdczzrLdsUrrWnl+
         Ge5q8zYoq0OQvTRdJM+rTnAV90Q+PDcv6e2kVuPtbTPNv9bJB4fVVmdVF47oQC2TM0NB
         Va6GcpTwjoviAfnZS+UqVHtsroY+XZrxJ41+1JdwXluTC+knirgkLYcJi8v2aejYYAX4
         NYjxqVmyKNhWr6IaV4y4n3LMCUdHsabSSmAa/nclr9hjy3FTTElLl/CAXdkZYDjB5DhY
         xLziEmc5lTxsXVJVrNOC+JaZXdfC8Xbk6fS7+ITORnG0HI8Rj0zHocd1MFbCFEiNkuwd
         VvXg==
X-Gm-Message-State: AOAM532oFN+C/yM1sGuur+IgEJL/tkpsHDlf1Ljy2hFvIGyt9OagjLEF
        q1zpYEesd2yMq4dFhj7rG4psdWNBFVI=
X-Google-Smtp-Source: ABdhPJwe+m8kbcsYHNTELsW2blLgoh9KPVUdh2/kLjVIHyHIftp4qfO0yyuJsmCw77TAjmDKBd0dQA==
X-Received: by 2002:a37:88c4:: with SMTP id k187mr26541107qkd.718.1639253100427;
        Sat, 11 Dec 2021 12:05:00 -0800 (PST)
Received: from willemb.c.googlers.com.com (55.87.194.35.bc.googleusercontent.com. [35.194.87.55])
        by smtp.gmail.com with ESMTPSA id k85sm3381691qke.134.2021.12.11.12.05.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Dec 2021 12:05:00 -0800 (PST)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH net-next] selftests/net: expand gro with two machine test
Date:   Sat, 11 Dec 2021 15:04:57 -0500
Message-Id: <20211211200457.2243386-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

The test is currently run on a single host with private addresses,
either over veth or by setting a nic in loopback mode with macvlan.

Support running between two real devices. Allow overriding addresses.

Also cut timeout to fail faster on error and explicitly log success.

Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 tools/testing/selftests/net/gro.c | 38 +++++++++++++++++++------------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/net/gro.c b/tools/testing/selftests/net/gro.c
index cf37ce86b0fd..ee0b03f3dd06 100644
--- a/tools/testing/selftests/net/gro.c
+++ b/tools/testing/selftests/net/gro.c
@@ -64,10 +64,6 @@
 #define NUM_PACKETS 4
 #define START_SEQ 100
 #define START_ACK 100
-#define SIP6 "fdaa::2"
-#define DIP6 "fdaa::1"
-#define SIP4 "192.168.1.200"
-#define DIP4 "192.168.1.100"
 #define ETH_P_NONE 0
 #define TOTAL_HDR_LEN (ETH_HLEN + sizeof(struct ipv6hdr) + sizeof(struct tcphdr))
 #define MSS (4096 - sizeof(struct tcphdr) - sizeof(struct ipv6hdr))
@@ -75,6 +71,10 @@
 #define NUM_LARGE_PKT (MAX_PAYLOAD / MSS)
 #define MAX_HDR_LEN (ETH_HLEN + sizeof(struct ipv6hdr) + sizeof(struct tcphdr))
 
+static const char *addr6_src = "fdaa::2";
+static const char *addr6_dst = "fdaa::1";
+static const char *addr4_src = "192.168.1.200";
+static const char *addr4_dst = "192.168.1.100";
 static int proto = -1;
 static uint8_t src_mac[ETH_ALEN], dst_mac[ETH_ALEN];
 static char *testname = "data";
@@ -178,18 +178,18 @@ static uint16_t tcp_checksum(void *buf, int payload_len)
 	uint32_t sum = 0;
 
 	if (proto == PF_INET6) {
-		if (inet_pton(AF_INET6, SIP6, &ph6.saddr) != 1)
+		if (inet_pton(AF_INET6, addr6_src, &ph6.saddr) != 1)
 			error(1, errno, "inet_pton6 source ip pseudo");
-		if (inet_pton(AF_INET6, DIP6, &ph6.daddr) != 1)
+		if (inet_pton(AF_INET6, addr6_dst, &ph6.daddr) != 1)
 			error(1, errno, "inet_pton6 dest ip pseudo");
 		ph6.protocol = htons(IPPROTO_TCP);
 		ph6.payload_len = htons(sizeof(struct tcphdr) + payload_len);
 
 		sum = checksum_nofold(&ph6, sizeof(ph6), 0);
 	} else if (proto == PF_INET) {
-		if (inet_pton(AF_INET, SIP4, &ph4.saddr) != 1)
+		if (inet_pton(AF_INET, addr4_src, &ph4.saddr) != 1)
 			error(1, errno, "inet_pton source ip pseudo");
-		if (inet_pton(AF_INET, DIP4, &ph4.daddr) != 1)
+		if (inet_pton(AF_INET, addr4_dst, &ph4.daddr) != 1)
 			error(1, errno, "inet_pton dest ip pseudo");
 		ph4.protocol = htons(IPPROTO_TCP);
 		ph4.payload_len = htons(sizeof(struct tcphdr) + payload_len);
@@ -229,9 +229,9 @@ static void fill_networklayer(void *buf, int payload_len)
 		ip6h->payload_len = htons(sizeof(struct tcphdr) + payload_len);
 		ip6h->nexthdr = IPPROTO_TCP;
 		ip6h->hop_limit = 8;
-		if (inet_pton(AF_INET6, SIP6, &ip6h->saddr) != 1)
+		if (inet_pton(AF_INET6, addr6_src, &ip6h->saddr) != 1)
 			error(1, errno, "inet_pton source ip6");
-		if (inet_pton(AF_INET6, DIP6, &ip6h->daddr) != 1)
+		if (inet_pton(AF_INET6, addr6_dst, &ip6h->daddr) != 1)
 			error(1, errno, "inet_pton dest ip6");
 	} else if (proto == PF_INET) {
 		memset(iph, 0, sizeof(*iph));
@@ -243,9 +243,9 @@ static void fill_networklayer(void *buf, int payload_len)
 		iph->tot_len = htons(sizeof(struct tcphdr) +
 				payload_len + sizeof(struct iphdr));
 		iph->frag_off = htons(0x4000); /* DF = 1, MF = 0 */
-		if (inet_pton(AF_INET, SIP4, &iph->saddr) != 1)
+		if (inet_pton(AF_INET, addr4_src, &iph->saddr) != 1)
 			error(1, errno, "inet_pton source ip");
-		if (inet_pton(AF_INET, DIP4, &iph->daddr) != 1)
+		if (inet_pton(AF_INET, addr4_dst, &iph->daddr) != 1)
 			error(1, errno, "inet_pton dest ip");
 		iph->check = checksum_fold(buf, sizeof(struct iphdr), 0);
 	}
@@ -731,7 +731,7 @@ static void set_timeout(int fd)
 {
 	struct timeval timeout;
 
-	timeout.tv_sec = 120;
+	timeout.tv_sec = 3;
 	timeout.tv_usec = 0;
 	if (setsockopt(fd, SOL_SOCKET, SO_RCVTIMEO, (char *)&timeout,
 		       sizeof(timeout)) < 0)
@@ -1023,11 +1023,13 @@ static void gro_receiver(void)
 static void parse_args(int argc, char **argv)
 {
 	static const struct option opts[] = {
+		{ "daddr", required_argument, NULL, 'd' },
 		{ "dmac", required_argument, NULL, 'D' },
 		{ "iface", required_argument, NULL, 'i' },
 		{ "ipv4", no_argument, NULL, '4' },
 		{ "ipv6", no_argument, NULL, '6' },
 		{ "rx", no_argument, NULL, 'r' },
+		{ "saddr", required_argument, NULL, 's' },
 		{ "smac", required_argument, NULL, 'S' },
 		{ "test", required_argument, NULL, 't' },
 		{ "verbose", no_argument, NULL, 'v' },
@@ -1035,7 +1037,7 @@ static void parse_args(int argc, char **argv)
 	};
 	int c;
 
-	while ((c = getopt_long(argc, argv, "46D:i:rS:t:v", opts, NULL)) != -1) {
+	while ((c = getopt_long(argc, argv, "46d:D:i:rs:S:t:v", opts, NULL)) != -1) {
 		switch (c) {
 		case '4':
 			proto = PF_INET;
@@ -1045,6 +1047,9 @@ static void parse_args(int argc, char **argv)
 			proto = PF_INET6;
 			ethhdr_proto = htons(ETH_P_IPV6);
 			break;
+		case 'd':
+			addr4_dst = addr6_dst = optarg;
+			break;
 		case 'D':
 			dmac = optarg;
 			break;
@@ -1054,6 +1059,9 @@ static void parse_args(int argc, char **argv)
 		case 'r':
 			tx_socket = false;
 			break;
+		case 's':
+			addr4_src = addr6_src = optarg;
+			break;
 		case 'S':
 			smac = optarg;
 			break;
@@ -1091,5 +1099,7 @@ int main(int argc, char **argv)
 		gro_sender();
 	else
 		gro_receiver();
+
+	fprintf(stderr, "Gro::%s test passed.\n", testname);
 	return 0;
 }
-- 
2.34.1.173.g76aa8bc2d0-goog

