Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D62EC5ACC5D
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 09:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237534AbiIEHJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 03:09:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237260AbiIEHHX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 03:07:23 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D78D43DBF3;
        Mon,  5 Sep 2022 00:07:01 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id u9so15139967ejy.5;
        Mon, 05 Sep 2022 00:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=c3ef1tCSBk5Pu55gvggQWHWrSDlx5j3fySb3nMqt3xE=;
        b=XQ3o8DZp95KOnn8pS91CDDJlw14RiHfqLyja6ovYs1u8hnWUmnbJSftkdKojgs6Zxe
         2h7Q2Jmo0K2dQgDXv/efSk4BJTr1Dh8DPE7zX0eiC7/RMZZX84sYvifEok05TiqZ8PYr
         S+V26gkyuqnGb3cpQV9bc4aQavkOMbOWYymVBQ7Q2R3MbWTIy347oNnd2Y70N7Crv0t3
         XYKO2PgCZqXGHSAhfNi6o0gp/fVXMqOf6L0Qu+BT812Z3ie7bGfTgOWjX1fiTLRy3rmG
         PmTlW56NxdroCWgC7CHC0vtR+gjBlQFZPEZPRhKdYzF64F+pomvlQ+PwQYM7b4OISx7l
         7xlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=c3ef1tCSBk5Pu55gvggQWHWrSDlx5j3fySb3nMqt3xE=;
        b=3j2dYOlDEpB9cgEu46Dgn6lvrklM0gxrCJIoNegKIOJbKbEUf4Sdjsj7RiLF3Ub7mK
         E6qasnq+Mpf3jdedFOtVJVy/Ky/7WcKNAtk6bq9365NbXRua7r6sVsjX6+j5l5GxR4Tr
         n2pfvuhNLT203e1o9mkp6DkNFXq4V57PwL7KLU9rrYakWuytiKTrhBhRWOepTo5s8tYY
         E7lqCMemFuYwHVq57Zr/Zo2yn00aE1J9xytdIjOzqdR2cOcyu18ZH6/mXuvPMBAdNRmV
         qPWhfYdjb1EZSMbIGjJyF4ALwTtd5yLAE1J21ronv09FH/af1aORWHYO4KRi/ANRWe6U
         ffYw==
X-Gm-Message-State: ACgBeo3HLqHTIGDj2qY/rtG+2/Ny/V1kMC7alMAaX/GMGfzXPmSF/Cxe
        QYPQ6MkqzAFR9zeWhtfhbGM=
X-Google-Smtp-Source: AA6agR68/L3T/QJiZSlSd+rQr99Sa8HwT96+t8fahpALnT8jeLrRV1SU73yIn3D56Ecbiii3UTI5vQ==
X-Received: by 2002:a17:907:6e14:b0:730:a229:f747 with SMTP id sd20-20020a1709076e1400b00730a229f747mr35890567ejc.202.1662361620379;
        Mon, 05 Sep 2022 00:07:00 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:a080:40ec:9f50:387:3cfb])
        by smtp.gmail.com with ESMTPSA id n27-20020a056402515b00b0043cf2e0ce1csm5882775edd.48.2022.09.05.00.06.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 00:06:59 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>
Cc:     Francesco Ruggeri <fruggeri@arista.com>,
        Salam Noureddine <noureddine@arista.com>,
        Philip Paeps <philip@trouble.is>,
        Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Caowangbao <caowangbao@huawei.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v8 25/26] selftests: nettest: Initial tcp_authopt support
Date:   Mon,  5 Sep 2022 10:06:01 +0300
Message-Id: <54b0df9dcde5747e003b3b21b2290ae1d79d42a1.1662361354.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1662361354.git.cdleonard@gmail.com>
References: <cover.1662361354.git.cdleonard@gmail.com>
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
index 30585050e00a..c5faabf6ba34 100644
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
 
@@ -257,10 +260,75 @@ static int switch_ns(const char *ns)
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
@@ -1549,10 +1617,15 @@ static int do_server(struct sock_args *args, int ipc_fd)
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
@@ -1671,10 +1744,13 @@ static int connectsock(void *addr, socklen_t alen, struct sock_args *args)
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
@@ -1860,11 +1936,11 @@ static int ipc_parent(int cpid, int fd, struct sock_args *args)
 
 	wait(&status);
 	return client_status;
 }
 
-#define GETOPT_STR  "sr:l:c:p:t:g:P:DRn:M:X:m:d:I:BN:O:SUCi6xL:0:1:2:3:Fbqf"
+#define GETOPT_STR  "sr:l:c:p:t:g:P:DRn:M:X:m:A:d:I:BN:O:SUCi6xL:0:1:2:3:Fbqf"
 #define OPT_FORCE_BIND_KEY_IFINDEX 1001
 #define OPT_NO_BIND_KEY_IFINDEX 1002
 
 static struct option long_opts[] = {
 	{"force-bind-key-ifindex", 0, 0, OPT_FORCE_BIND_KEY_IFINDEX},
@@ -1906,14 +1982,15 @@ static void print_usage(char *prog)
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
@@ -1924,17 +2001,64 @@ static void print_usage(char *prog)
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
@@ -2031,10 +2155,13 @@ int main(int argc, char *argv[])
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
@@ -2097,12 +2224,17 @@ int main(int argc, char *argv[])
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
@@ -2125,10 +2257,12 @@ int main(int argc, char *argv[])
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

