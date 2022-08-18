Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41005598D43
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 22:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345275AbiHRUDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 16:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345830AbiHRUCY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 16:02:24 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75DCAD1E16;
        Thu, 18 Aug 2022 13:00:54 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id k26so5190599ejx.5;
        Thu, 18 Aug 2022 13:00:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=UNC6gkaevkv7hTgw1A05+yNvh+7oeAOZgb9Vvub/3OM=;
        b=iqG9wupwVNeFx5XpjRbv9mLh8V+7NeDUoZNx8H5VSYqAH80hdSoqjUEOt/NSW4fAvr
         P1JtL2+ToZypoy+Y57FnUbgQc2EAezJiWHALRfqmmuNsprYotzd222zpmUwshUWJsBcc
         vusUi6ypHuOO9BfF2hEFO2n0KRTv+sCL+BoFv1lFFjwNpUQlWaC7zsXdbr2+gVkT4Kes
         reV/KePnaF0Yt20l2Qgim0I4l1Lo4zjm4QbDRduh/a1S3IbDMOfmHYKigHm0bhzL0BLG
         TWPOxG+76qt2uat8RPpLhb1+Fe2t5XKzVr5yLZ0TODRDm1tglVBy3XUiM6XlOVINq3/a
         feeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=UNC6gkaevkv7hTgw1A05+yNvh+7oeAOZgb9Vvub/3OM=;
        b=Fe9ISY2v4JTtB2UW78snq/166YL2tTI+fC+oGvBFU1lcqYj2uu5/NfOToesh4yMdN5
         BnnvxiQSUyhzq+6J7hPTsFh/L/YZDZ4fapU9/XTt6FQdarT25mSBbHJp5U0K5/oGxjXG
         I8p5pf2Z8hQxWUjGMoBReQcfpCpY11EXb0di7dAB57zzzx6cQRdHC1p47WixqWyydjhJ
         QgQvbV8YY+iRGH2OrSvnOdIZ2QGmXI/RjYbujY9U6HOPuTKOW0wiCeXpvi3d4HZeDivy
         JWYJd95KLvoDn0zuan1CbKbg5SRjaJAETG5Icx41HI2en4+GOzySUaY1RP4+QpH1+Evw
         fpTg==
X-Gm-Message-State: ACgBeo05f7ik9nJPlTSuIObN0JlHpDB67+z/VNWOgCftZBXPDY3Djs+l
        V5KB5c/9PBMlAyN41BmN9t0=
X-Google-Smtp-Source: AA6agR7ATsEvgV5Yi6/QRKQvLzm4i8wFztXiDdhmKryyIufbDiQmWrMrR6GkQDaKOL6uUYnZlwZl3g==
X-Received: by 2002:a17:907:3f95:b0:733:1e1f:d75c with SMTP id hr21-20020a1709073f9500b007331e1fd75cmr2890115ejc.727.1660852854050;
        Thu, 18 Aug 2022 13:00:54 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:a080:17c8:ba1c:b6f3:3fe0])
        by smtp.gmail.com with ESMTPSA id fw30-20020a170907501e00b00722e4bab163sm1215087ejc.200.2022.08.18.13.00.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 13:00:53 -0700 (PDT)
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
Subject: [PATCH v7 20/26] selftests: nettest: Initial tcp_authopt support
Date:   Thu, 18 Aug 2022 22:59:54 +0300
Message-Id: <9f9cbf15ca0651ccc177080434739e15cea4c47a.1660852705.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1660852705.git.cdleonard@gmail.com>
References: <cover.1660852705.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for configuring TCP Authentication Option. Only a single key
is supported with default options.

Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 tools/testing/selftests/net/nettest.c | 156 ++++++++++++++++++++++++--
 1 file changed, 145 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/net/nettest.c b/tools/testing/selftests/net/nettest.c
index 3841e5fec7c7..9615489230f8 100644
--- a/tools/testing/selftests/net/nettest.c
+++ b/tools/testing/selftests/net/nettest.c
@@ -27,10 +27,11 @@
 #include <string.h>
 #include <unistd.h>
 #include <time.h>
 #include <errno.h>
 #include <getopt.h>
+#include <stdbool.h>
 
 #include <linux/xfrm.h>
 #include <linux/ipsec.h>
 #include <linux/pfkeyv2.h>
 
@@ -104,10 +105,12 @@ struct sock_args {
 	} key_addr;
 	unsigned int key_addr_prefix_len;
 	/* 0: default, -1: force off, +1: force on */
 	int bind_key_ifindex;
 
+	const char *authopt_password;
+
 	/* expected addresses and device index for connection */
 	const char *expected_dev;
 	const char *expected_server_dev;
 	int expected_ifindex;
 
@@ -254,10 +257,75 @@ static int switch_ns(const char *ns)
 	close(fd);
 
 	return ret;
 }
 
+/* Fill key identification fields: address and ifindex */
+static void tcp_authopt_key_fill_id(struct tcp_authopt_key *key, struct sock_args *args)
+{
+	if (args->key_addr_prefix_str) {
+		key->flags |= TCP_AUTHOPT_KEY_ADDR_BIND;
+		switch (args->version) {
+		case AF_INET:
+			memcpy(&key->addr, &args->key_addr.v4, sizeof(args->key_addr.v4));
+			break;
+		case AF_INET6:
+			memcpy(&key->addr, &args->key_addr.v6, sizeof(args->key_addr.v6));
+			break;
+		default:
+			log_error("unknown address family\n");
+			exit(1);
+		}
+		if (args->key_addr_prefix_len) {
+			key->flags |= TCP_AUTHOPT_KEY_PREFIXLEN;
+			key->prefixlen = args->key_addr_prefix_len;
+		}
+	}
+
+	if ((args->ifindex && args->bind_key_ifindex >= 0) || args->bind_key_ifindex >= 1) {
+		key->flags |= TCP_AUTHOPT_KEY_IFINDEX;
+		key->ifindex = args->ifindex;
+		log_msg("TCP_AUTHOPT_KEY_IFINDEX set ifindex=%d\n", key->ifindex);
+	} else {
+		log_msg("TCP_AUTHOPT_KEY_IFINDEX off\n", key->ifindex);
+	}
+}
+
+static int tcp_del_authopt(int sd, struct sock_args *args)
+{
+	struct tcp_authopt_key key;
+	int rc;
+
+	memset(&key, 0, sizeof(key));
+	key.flags |= TCP_AUTHOPT_KEY_DEL;
+	tcp_authopt_key_fill_id(&key, args);
+
+	rc = setsockopt(sd, IPPROTO_TCP, TCP_AUTHOPT_KEY, &key, sizeof(key));
+	if (rc < 0)
+		log_err_errno("setsockopt(TCP_AUTHOPT_KEY) del fail");
+
+	return rc;
+}
+
+static int tcp_set_authopt(int sd, struct sock_args *args)
+{
+	struct tcp_authopt_key key;
+	int rc;
+
+	memset(&key, 0, sizeof(key));
+	strcpy((char *)key.key, args->authopt_password);
+	key.keylen = strlen(args->authopt_password);
+	key.alg = TCP_AUTHOPT_ALG_HMAC_SHA_1_96;
+	tcp_authopt_key_fill_id(&key, args);
+
+	rc = setsockopt(sd, IPPROTO_TCP, TCP_AUTHOPT_KEY, &key, sizeof(key));
+	if (rc < 0)
+		log_err_errno("setsockopt(TCP_AUTHOPT_KEY) add fail");
+
+	return rc;
+}
+
 static int tcp_md5sig(int sd, void *addr, socklen_t alen, struct sock_args *args)
 {
 	int keylen = strlen(args->password);
 	struct tcp_md5sig md5sig = {};
 	int opt = TCP_MD5SIG;
@@ -1541,10 +1609,15 @@ static int do_server(struct sock_args *args, int ipc_fd)
 	if (args->password && tcp_md5_remote(lsd, args)) {
 		close(lsd);
 		goto err_exit;
 	}
 
+	if (args->authopt_password && tcp_set_authopt(lsd, args)) {
+		close(lsd);
+		goto err_exit;
+	}
+
 	ipc_write(ipc_fd, 1);
 	while (1) {
 		log_msg("waiting for client connection.\n");
 		FD_ZERO(&rfds);
 		FD_SET(lsd, &rfds);
@@ -1663,10 +1736,13 @@ static int connectsock(void *addr, socklen_t alen, struct sock_args *args)
 		goto out;
 
 	if (args->password && tcp_md5sig(sd, addr, alen, args))
 		goto err;
 
+	if (args->authopt_password && tcp_set_authopt(sd, args))
+		goto err;
+
 	if (args->bind_test_only)
 		goto out;
 
 	if (connect(sd, addr, alen) < 0) {
 		if (errno != EINPROGRESS) {
@@ -1852,11 +1928,11 @@ static int ipc_parent(int cpid, int fd, struct sock_args *args)
 
 	wait(&status);
 	return client_status;
 }
 
-#define GETOPT_STR  "sr:l:c:p:t:g:P:DRn:M:X:m:d:I:BN:O:SCi6xL:0:1:2:3:Fbqf"
+#define GETOPT_STR  "sr:l:c:p:t:g:P:DRn:M:X:m:A:d:I:BN:O:SCi6xL:0:1:2:3:Fbqf"
 #define OPT_FORCE_BIND_KEY_IFINDEX 1001
 #define OPT_NO_BIND_KEY_IFINDEX 1002
 
 static struct option long_opts[] = {
 	{"force-bind-key-ifindex", 0, 0, OPT_FORCE_BIND_KEY_IFINDEX},
@@ -1897,14 +1973,15 @@ static void print_usage(char *prog)
 	"    -L len        send random message of given length\n"
 	"    -n num        number of times to send message\n"
 	"\n"
 	"    -M password   use MD5 sum protection\n"
 	"    -X password   MD5 password for client mode\n"
-	"    -m prefix/len prefix and length to use for MD5 key\n"
-	"    --no-bind-key-ifindex: Force TCP_MD5SIG_FLAG_IFINDEX off\n"
-	"    --force-bind-key-ifindex: Force TCP_MD5SIG_FLAG_IFINDEX on\n"
+	"    -m prefix/len prefix and length to use for MD5/AO key\n"
+	"    --no-bind-key-ifindex: Force disable binding key to ifindex\n"
+	"    --force-bind-key-ifindex: Force enable binding key to ifindex\n"
 	"        (default: only if -I is passed)\n"
+	"    -A password   use RFC5925 TCP Authentication Option with password\n"
 	"\n"
 	"    -g grp        multicast group (e.g., 239.1.1.1)\n"
 	"    -i            interactive mode (default is echo and terminate)\n"
 	"\n"
 	"    -0 addr       Expected local address\n"
@@ -1915,17 +1992,64 @@ static void print_usage(char *prog)
 	"    -b            Bind test only.\n"
 	"    -q            Be quiet. Run test without printing anything.\n"
 	, prog, DEFAULT_PORT);
 }
 
-int main(int argc, char *argv[])
+/* Needs explicit cleanup because keys are global per-namespace */
+void cleanup_tcp_authopt(struct sock_args *args)
+{
+	int fd;
+
+	if (!args->authopt_password)
+		return;
+
+	fd = socket(AF_INET, SOCK_STREAM, 0);
+	if (fd < 0) {
+		log_err_errno("Failed to create socket");
+		return;
+	}
+	tcp_del_authopt(fd, args);
+	close(fd);
+}
+
+static bool cleanup_done;
+static struct sock_args args = {
+	.version = AF_INET,
+	.type    = SOCK_STREAM,
+	.port    = DEFAULT_PORT,
+};
+
+void cleanup(void)
+{
+	if (cleanup_done)
+		return;
+	cleanup_done = true;
+	cleanup_tcp_authopt(&args);
+}
+
+void signal_handler(int num)
+{
+	cleanup();
+}
+
+void atexit_handler(void)
+{
+	cleanup();
+}
+
+/* Explicit cleanup is required for TCP-AO because keys are global. */
+static void register_cleanup(void)
 {
-	struct sock_args args = {
-		.version = AF_INET,
-		.type    = SOCK_STREAM,
-		.port    = DEFAULT_PORT,
+	struct sigaction sa = {
+		.sa_handler = signal_handler,
 	};
+	sigaction(SIGINT, &sa, NULL);
+	atexit(atexit_handler);
+}
+
+int main(int argc, char *argv[])
+{
 	struct protoent *pe;
 	int both_mode = 0;
 	unsigned int tmp;
 	int forever = 0;
 	int fd[2];
@@ -2022,10 +2146,13 @@ int main(int argc, char *argv[])
 			args.client_pw = optarg;
 			break;
 		case 'm':
 			args.key_addr_prefix_str = optarg;
 			break;
+		case 'A':
+			args.authopt_password = optarg;
+			break;
 		case 'S':
 			args.use_setsockopt = 1;
 			break;
 		case 'f':
 			args.use_freebind = 1;
@@ -2085,12 +2212,17 @@ int main(int argc, char *argv[])
 	      args.type != SOCK_STREAM)) {
 		log_error("MD5 passwords apply to TCP only and require a remote ip for the password\n");
 		return 1;
 	}
 
-	if (args.key_addr_prefix_str && !args.password) {
-		log_error("Prefix range for MD5 protection specified without a password\n");
+	if (args.key_addr_prefix_str && !args.password && !args.authopt_password) {
+		log_error("Prefix range for authentication requires -M or -A\n");
+		return 1;
+	}
+
+	if (args.key_addr_prefix_len && args.authopt_password) {
+		log_error("TCP-AO does not support prefix match, only full address\n");
 		return 1;
 	}
 
 	if (iter == 0) {
 		fprintf(stderr, "Invalid number of messages to send\n");
@@ -2113,10 +2245,12 @@ int main(int argc, char *argv[])
 		fprintf(stderr,
 			"Local (server mode) or remote IP (client IP) required\n");
 		return 1;
 	}
 
+	register_cleanup();
+
 	if (interactive) {
 		prog_timeout = 0;
 		msg = NULL;
 	}
 
-- 
2.25.1

