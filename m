Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11C96441EAD
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 17:39:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233137AbhKAQla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 12:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233035AbhKAQj1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 12:39:27 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CF72C0613B9;
        Mon,  1 Nov 2021 09:36:12 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id 5so65292411edw.7;
        Mon, 01 Nov 2021 09:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cKM41sVoSEOULipq/Jsu+V4CctF6IocazMeEiV2Ev3Y=;
        b=VqnyfqAq6XkeEcGOV6rRIscn0YAP4ypwn5bLpn0UjN1D+pmcDUIihHBpogRmSKkx1/
         DRkrPEp7nYEgRBxTf+BNqvYHZCYHPQhFLaf+oUntsaLGjm92jT9wAV6mldsUHMCjrV8W
         CVitp5kC1J3qQSn8IXA4W5QAJ+A6MFWIJL7KZPlwMl5/7OBBkyaO8MZU0QfCCsqj/L6L
         472TJByVWbYK8v95V9y+dXeI06zbdV0mVbcsfQ+QNPP6zIfmexoQoh1t0jAzMhkFmcg1
         isWUfjJVeJfTZr2rhwQZjyQNVxIm+IVtbsHGidCZ03jReF+TreSdLgxLRtDFxikuVOZ7
         49Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cKM41sVoSEOULipq/Jsu+V4CctF6IocazMeEiV2Ev3Y=;
        b=lowS7lNS4WU988GAxHB2p1urTlKU2RB9hh7Y8hCLVGv02aZh3KLcbyiDPYcCRvxPvY
         ZS+vAEYjR42a3+NBjnDmSRtz2xI69tHziiCKqqgUzq4NrT9c09rm4wgmQwba6K6ryttW
         5zvpdljb6uw3bXCFFwyuXcPRZt7ycEONQ2Gb1rfzvWnxIpicykgXo7dOqJSdIfS5KIVt
         9mSGsWTgblVc4db7AMyfMg71z1+bf3R4SwNP9gatOxH4/VfeOpFvvLdLNWHfPEVbMujQ
         flRz/jv7TYyJufXxwnkRbAUO4DYVl/b+vDQj2qN2bArlc9qyzjh2dJbLD1v2h/rBRBRO
         swOQ==
X-Gm-Message-State: AOAM530hQlKqmY6n1y0VLt/Orq7OZk5RuwB+Y2fvSDGW5yzzW3wgyg/P
        8DB3hpFPjrpSUISgN9vvYmU=
X-Google-Smtp-Source: ABdhPJy2rHu0FiBVkBvh18q7KIAOR9NkhQ6nSi25hXGdfSxlmfFECWJWKSdD0aw+CT/QQLRcJDycfw==
X-Received: by 2002:a17:906:2505:: with SMTP id i5mr37897275ejb.450.1635784570945;
        Mon, 01 Nov 2021 09:36:10 -0700 (PDT)
Received: from ponky.lan ([2a04:241e:501:3870:f5f:2085:7f25:17c])
        by smtp.gmail.com with ESMTPSA id f25sm4124583edv.90.2021.11.01.09.36.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 09:36:10 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 24/25] selftests: nettest: Initial tcp_authopt support
Date:   Mon,  1 Nov 2021 18:34:59 +0200
Message-Id: <0a89ec520bb406c046e76537ba7e218c882a2d2f.1635784253.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1635784253.git.cdleonard@gmail.com>
References: <cover.1635784253.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for configuring TCP Authentication Option. Only a single key
is supported with default options.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 tools/testing/selftests/net/nettest.c | 75 ++++++++++++++++++++++++---
 1 file changed, 69 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/net/nettest.c b/tools/testing/selftests/net/nettest.c
index 525a439ce3b3..837a45921845 100644
--- a/tools/testing/selftests/net/nettest.c
+++ b/tools/testing/selftests/net/nettest.c
@@ -103,10 +103,12 @@ struct sock_args {
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
 
@@ -253,10 +255,54 @@ static int switch_ns(const char *ns)
 	close(fd);
 
 	return ret;
 }
 
+static int tcp_set_authopt(int sd, struct sock_args *args)
+{
+	struct tcp_authopt_key key;
+	int rc;
+
+	memset(&key, 0, sizeof(key));
+	strcpy((char *)key.key, args->authopt_password);
+	key.keylen = strlen(args->authopt_password);
+	key.alg = TCP_AUTHOPT_ALG_HMAC_SHA_1_96;
+
+	if (args->key_addr_prefix_str) {
+		key.flags |= TCP_AUTHOPT_KEY_ADDR_BIND;
+		switch (args->version) {
+		case AF_INET:
+			memcpy(&key.addr, &args->key_addr.v4, sizeof(args->key_addr.v4));
+			break;
+		case AF_INET6:
+			memcpy(&key.addr, &args->key_addr.v6, sizeof(args->key_addr.v6));
+			break;
+		default:
+			log_error("unknown address family\n");
+			exit(1);
+		}
+		if (args->key_addr_prefix_len) {
+			log_error("TCP_AUTHOPT does not support prefix length\n");
+			exit(1);
+		}
+	}
+
+	if ((args->ifindex && args->bind_key_ifindex >= 0) || args->bind_key_ifindex >= 1) {
+		key.flags |= TCP_AUTHOPT_KEY_IFINDEX;
+		key.ifindex = args->ifindex;
+		log_msg("TCP_AUTHOPT_KEY_IFINDEX set ifindex=%d\n", key.ifindex);
+	} else {
+		log_msg("TCP_AUTHOPT_KEY_IFINDEX off\n", key.ifindex);
+	}
+
+	rc = setsockopt(sd, IPPROTO_TCP, TCP_AUTHOPT_KEY, &key, sizeof(key));
+	if (rc < 0)
+		log_err_errno("setsockopt(TCP_AUTHOPT_KEY)");
+
+	return rc;
+}
+
 static int tcp_md5sig(int sd, void *addr, socklen_t alen, struct sock_args *args)
 {
 	int keylen = strlen(args->password);
 	struct tcp_md5sig md5sig = {};
 	int opt = TCP_MD5SIG;
@@ -1514,10 +1560,15 @@ static int do_server(struct sock_args *args, int ipc_fd)
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
@@ -1636,10 +1687,13 @@ static int connectsock(void *addr, socklen_t alen, struct sock_args *args)
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
@@ -1825,11 +1879,11 @@ static int ipc_parent(int cpid, int fd, struct sock_args *args)
 
 	wait(&status);
 	return client_status;
 }
 
-#define GETOPT_STR  "sr:l:c:p:t:g:P:DRn:M:X:m:d:I:BN:O:SCi6xL:0:1:2:3:Fbq"
+#define GETOPT_STR  "sr:l:c:p:t:g:P:DRn:M:X:m:A:d:I:BN:O:SCi6xL:0:1:2:3:Fbq"
 #define OPT_FORCE_BIND_KEY_IFINDEX 1001
 #define OPT_NO_BIND_KEY_IFINDEX 1002
 
 static struct option long_opts[] = {
 	{"force-bind-key-ifindex", 0, 0, OPT_FORCE_BIND_KEY_IFINDEX},
@@ -1869,14 +1923,15 @@ static void print_usage(char *prog)
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
@@ -1994,10 +2049,13 @@ int main(int argc, char *argv[])
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
 		case 'C':
 			args.use_cmsg = 1;
@@ -2054,12 +2112,17 @@ int main(int argc, char *argv[])
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
-- 
2.25.1

