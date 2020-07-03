Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBD16213FAD
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 20:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbgGCSxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 14:53:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726147AbgGCSxL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 14:53:11 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B658C061794
        for <netdev@vger.kernel.org>; Fri,  3 Jul 2020 11:53:10 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id b185so19007877qkg.1
        for <netdev@vger.kernel.org>; Fri, 03 Jul 2020 11:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FHdoMbsVLyly8PIUrDuKAS3JNiwkm095qfU0jAO1Mpk=;
        b=C55dCCty5JKTqVgqx9EIaGszTG5hiuxmlSHsK2/0b8KoJwdLtveiF+fD9/1X792qtK
         WDTNP31IUkR24b14B64enErl4jJP0kkXeJoFNoBAvNtnjQOJKQ5dsL5kp8oc8QvuLHjA
         cLGg219VE/ubjHhDryYX4jko1PSbIFSFNRB136aGrVbJw6uLi+WGLPeZFaS5kvVkkd0C
         ypQhG64/Af2FN/GWOVVirp0240NrVr3aFfMKZcLdVJaHIKGkYsmkJj9QOHldV85hIHpX
         /VEKR3IcoR6Vy7jKUjwf7f/WHqhAFi3uDGl1t3HtrW+bBhPV4dhPsnHTcvmC8tONqlBx
         GbmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FHdoMbsVLyly8PIUrDuKAS3JNiwkm095qfU0jAO1Mpk=;
        b=UuSkjDiGihc+/ShzMA47Kx4/hxmLJ7Ui/q+fGgYuy+SsmlagNRv3S8che7Htp0xZ89
         JSZZ/wNdc1UpXm32KJnvGOYuwLn4cBEPEGkFGusp28GiZNZmpPGp8izEkjBHo4VVkSs2
         74qlqvrhAq0EhXJ3IMA/nIOMyF6Lxsof59H0hijg5yp7rvQywTs2Tj6/GmmVP+x4tzBA
         f1xGAdrbaVJZwJXy+CvxDl8X+fwvaukJbn17Uwv+ijgrsEvZsVKANOxpoa6GJvJbVYLv
         /i8eZSGzK8bCne2GBi9NJXiRHRZRMnqCpas+TxBk2WC/jzLS5kvtqiTPJ7YiEMXLdYK6
         E9GQ==
X-Gm-Message-State: AOAM532UvUemq7HNl2crkzKGLOaEfrupGT/i5c7m6uJPhoKAkYnWRc+F
        kj6IqZZnCxt1RoA2g0OmRINcQbng
X-Google-Smtp-Source: ABdhPJzXUe9zLBuq16Yw4V0PIHsFa75MmcsCJhjcnvam7dSYu37GFjcirZ4HMmJzR9mDpiRxXwAB9A==
X-Received: by 2002:a05:620a:989:: with SMTP id x9mr27748175qkx.66.1593802389088;
        Fri, 03 Jul 2020 11:53:09 -0700 (PDT)
Received: from tannerlove.nyc.corp.google.com ([2620:0:1003:316:f693:9fff:feea:df57])
        by smtp.gmail.com with ESMTPSA id u6sm13130968qtk.9.2020.07.03.11.53.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jul 2020 11:53:08 -0700 (PDT)
From:   Tanner Love <tannerlove.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, tannerlove <tannerlove@google.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH net-next] selftests/net: add ipv6 test coverage in rxtimestamp test
Date:   Fri,  3 Jul 2020 14:53:06 -0400
Message-Id: <20200703185306.2858752-1-tannerlove.kernel@gmail.com>
X-Mailer: git-send-email 2.27.0.212.ge8ba1cc988-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: tannerlove <tannerlove@google.com>

Add the options --ipv4, --ipv6 to specify running over ipv4 and/or
ipv6. If neither is specified, then run both.

Signed-off-by: Tanner Love <tannerlove@google.com>
Acked-by: Willem de Bruijn <willemb@google.com>
---
 tools/testing/selftests/net/rxtimestamp.c | 85 ++++++++++++++++-------
 1 file changed, 59 insertions(+), 26 deletions(-)

diff --git a/tools/testing/selftests/net/rxtimestamp.c b/tools/testing/selftests/net/rxtimestamp.c
index d4ea86a13e52..c599d371cbbe 100644
--- a/tools/testing/selftests/net/rxtimestamp.c
+++ b/tools/testing/selftests/net/rxtimestamp.c
@@ -117,6 +117,8 @@ static struct option long_options[] = {
 	{ "udp", no_argument, 0, 'u' },
 	{ "ip", no_argument, 0, 'i' },
 	{ "strict", no_argument, 0, 'S' },
+	{ "ipv4", no_argument, 0, '4' },
+	{ "ipv6", no_argument, 0, '6' },
 	{ NULL, 0, NULL, 0 },
 };
 
@@ -272,37 +274,55 @@ void config_so_flags(int rcv, struct options o)
 		error(1, errno, "Failed to set SO_TIMESTAMPING");
 }
 
-bool run_test_case(struct socket_type s, struct test_case t)
+bool run_test_case(struct socket_type *s, int test_num, char ip_version,
+		   bool strict)
 {
-	int port = (s.type == SOCK_RAW) ? 0 : next_port++;
+	union {
+		struct sockaddr_in6 addr6;
+		struct sockaddr_in addr4;
+		struct sockaddr addr_un;
+	} addr;
 	int read_size = op_size;
-	struct sockaddr_in addr;
+	int src, dst, rcv, port;
+	socklen_t addr_size;
 	bool failed = false;
-	int src, dst, rcv;
 
-	src = socket(AF_INET, s.type, s.protocol);
+	port = (s->type == SOCK_RAW) ? 0 : next_port++;
+	memset(&addr, 0, sizeof(addr));
+	if (ip_version == '4') {
+		addr.addr4.sin_family = AF_INET;
+		addr.addr4.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
+		addr.addr4.sin_port = htons(port);
+		addr_size = sizeof(addr.addr4);
+		if (s->type == SOCK_RAW)
+			read_size += 20;  /* for IPv4 header */
+	} else {
+		addr.addr6.sin6_family = AF_INET6;
+		addr.addr6.sin6_addr = in6addr_loopback;
+		addr.addr6.sin6_port = htons(port);
+		addr_size = sizeof(addr.addr6);
+	}
+	printf("Starting testcase %d over ipv%c...\n", test_num, ip_version);
+	src = socket(addr.addr_un.sa_family, s->type,
+		     s->protocol);
 	if (src < 0)
 		error(1, errno, "Failed to open src socket");
 
-	dst = socket(AF_INET, s.type, s.protocol);
+	dst = socket(addr.addr_un.sa_family, s->type,
+		     s->protocol);
 	if (dst < 0)
 		error(1, errno, "Failed to open dst socket");
 
-	memset(&addr, 0, sizeof(addr));
-	addr.sin_family = AF_INET;
-	addr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
-	addr.sin_port = htons(port);
-
-	if (bind(dst, (struct sockaddr *)&addr, sizeof(addr)) < 0)
+	if (bind(dst, &addr.addr_un, addr_size) < 0)
 		error(1, errno, "Failed to bind to port %d", port);
 
-	if (s.type == SOCK_STREAM && (listen(dst, 1) < 0))
+	if (s->type == SOCK_STREAM && (listen(dst, 1) < 0))
 		error(1, errno, "Failed to listen");
 
-	if (connect(src, (struct sockaddr *)&addr, sizeof(addr)) < 0)
+	if (connect(src, &addr.addr_un, addr_size) < 0)
 		error(1, errno, "Failed to connect");
 
-	if (s.type == SOCK_STREAM) {
+	if (s->type == SOCK_STREAM) {
 		rcv = accept(dst, NULL, NULL);
 		if (rcv < 0)
 			error(1, errno, "Failed to accept");
@@ -311,17 +331,22 @@ bool run_test_case(struct socket_type s, struct test_case t)
 		rcv = dst;
 	}
 
-	config_so_flags(rcv, t.sockopt);
+	config_so_flags(rcv, test_cases[test_num].sockopt);
 	usleep(20000); /* setsockopt for SO_TIMESTAMPING is asynchronous */
 	do_send(src);
 
-	if (s.type == SOCK_RAW)
-		read_size += 20;  /* for IP header */
-	failed = do_recv(rcv, read_size, t.expected);
+	failed = do_recv(rcv, read_size, test_cases[test_num].expected);
 
 	close(rcv);
 	close(src);
 
+	if (failed) {
+		printf("FAILURE in testcase %d over ipv%c ", test_num,
+		       ip_version);
+		print_test_case(&test_cases[test_num]);
+		if (!strict && test_cases[test_num].warn_on_fail)
+			failed = false;
+	}
 	return failed;
 }
 
@@ -329,6 +354,8 @@ int main(int argc, char **argv)
 {
 	bool all_protocols = true;
 	bool all_tests = true;
+	bool cfg_ipv4 = false;
+	bool cfg_ipv6 = false;
 	bool strict = false;
 	int arg_index = 0;
 	int failures = 0;
@@ -369,6 +396,12 @@ int main(int argc, char **argv)
 		case 'S':
 			strict = true;
 			break;
+		case '4':
+			cfg_ipv4 = true;
+			break;
+		case '6':
+			cfg_ipv6 = true;
+			break;
 		default:
 			error(1, 0, "Failed to parse parameters.");
 		}
@@ -382,14 +415,14 @@ int main(int argc, char **argv)
 		for (t = 0; t < ARRAY_SIZE(test_cases); t++) {
 			if (!all_tests && !test_cases[t].enabled)
 				continue;
-
-			printf("Starting testcase %d...\n", t);
-			if (run_test_case(socket_types[s], test_cases[t])) {
-				if (strict || !test_cases[t].warn_on_fail)
+			if (cfg_ipv4 || !cfg_ipv6)
+				if (run_test_case(&socket_types[s], t, '4',
+						  strict))
+					failures++;
+			if (cfg_ipv6 || !cfg_ipv4)
+				if (run_test_case(&socket_types[s], t, '6',
+						  strict))
 					failures++;
-				printf("FAILURE in test case ");
-				print_test_case(&test_cases[t]);
-			}
 		}
 	}
 	if (!failures)
-- 
2.27.0.212.ge8ba1cc988-goog

