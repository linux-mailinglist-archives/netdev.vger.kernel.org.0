Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D98D346D2A2
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 12:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233217AbhLHLnw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 06:43:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232744AbhLHLnA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 06:43:00 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1242BC079797;
        Wed,  8 Dec 2021 03:38:31 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id y12so7244707eda.12;
        Wed, 08 Dec 2021 03:38:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Z/6Jjle9VKxjdiEALibfU5pwCYQ5kKTnkqqezPzIfas=;
        b=oEVk5ce3KTsWNzZoP2/t13G0CqrChIjN7ryG0tRwI5Na5Qn0xlGfQVcV3IlNmpu6lx
         R+7+UbOY0MeF+56z6qYRPqtR3HrOE4r50Xe8zgKPBGEjQi8k8nzNO5ii22DzATz2e4Gq
         PTANAuLNeq3S264H6R8FyKXh43pS5+yyLhYp7GAOLH/bxFYmRbmHzmLl4h+p8PI8gjiT
         zIpHg+bsFHk5zYkmgB7/CXMc7UcKoHimrx+GQpTR/+DBvjQODxM1pK3B9FiXEtY+0AuF
         AJ7mcjkg/8ln765BJhbsCZANfFO4jjGCh23AHGZqnnYHYUwEJXP+uzm4wR2fazR6MqOq
         17tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z/6Jjle9VKxjdiEALibfU5pwCYQ5kKTnkqqezPzIfas=;
        b=Vdyrgeaai+/C6TC+eTYJNajQWSDE91gRLjWrlVhGilLdcCWJJRPcdF+trvHqW70aEt
         fO++pg9D/TBFmuF7m3vjJ5pPESCPFWdWPhmSo1gPubVpucsy7fO/QuEwORmlcwvb2o0m
         40MHBcRuxb3Trdjb5QqfuaJPHCq+UUV040o8AYnEm/82sgmipb4Qx4SAr1Ur2Cu7J0I8
         2XWRfMLl/3gQ9/fKb4NRu4cFjLZxmgW3/YSXBPzKVJakQdzhf1FyTi8Uh2VgVAGou+TT
         CgnRQSz+j/ieh997S8JWqVQJjK7YnvCOrQYFq4MNB/96xujY3WWmFUO1XogcwaBLZpAW
         bw6w==
X-Gm-Message-State: AOAM533d60QLJyT5QNG/c55EfHXn8++1DhSE9P1HdlRIX56NM/saP/xn
        7s0Std4FdBWM7HEwjiNi++c=
X-Google-Smtp-Source: ABdhPJzShdk89Bpgr3WBylG4KP/u+N9tcr8eFK4X0GXimP0LdeTKQ+zQz3vV+Z2I58gtecGwvgdOqA==
X-Received: by 2002:a17:906:4bcf:: with SMTP id x15mr6937221ejv.273.1638963506144;
        Wed, 08 Dec 2021 03:38:26 -0800 (PST)
Received: from ponky.lan ([2a04:241e:501:3870:3c9f:e05b:4dff:43ba])
        by smtp.gmail.com with ESMTPSA id g11sm1883810edz.53.2021.12.08.03.38.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 03:38:25 -0800 (PST)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Francesco Ruggeri <fruggeri@arista.com>,
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
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 17/18] selftests: nettest: Initial tcp_authopt support
Date:   Wed,  8 Dec 2021 13:37:32 +0200
Message-Id: <cebc0cb03459482c111dd6d529cdcef34523d153.1638962992.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1638962992.git.cdleonard@gmail.com>
References: <cover.1638962992.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for configuring TCP Authentication Option. Only a single key
is supported with default options.

Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 tools/testing/selftests/net/nettest.c | 75 ++++++++++++++++++++++++---
 1 file changed, 69 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/net/nettest.c b/tools/testing/selftests/net/nettest.c
index 3841e5fec7c7..5fe7354c40cf 100644
--- a/tools/testing/selftests/net/nettest.c
+++ b/tools/testing/selftests/net/nettest.c
@@ -104,10 +104,12 @@ struct sock_args {
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
 
@@ -254,10 +256,54 @@ static int switch_ns(const char *ns)
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
+			key.flags |= TCP_AUTHOPT_KEY_PREFIXLEN;
+			key.prefixlen = args->key_addr_prefix_len;
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
@@ -1541,10 +1587,15 @@ static int do_server(struct sock_args *args, int ipc_fd)
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
@@ -1663,10 +1714,13 @@ static int connectsock(void *addr, socklen_t alen, struct sock_args *args)
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
@@ -1852,11 +1906,11 @@ static int ipc_parent(int cpid, int fd, struct sock_args *args)
 
 	wait(&status);
 	return client_status;
 }
 
-#define GETOPT_STR  "sr:l:c:p:t:g:P:DRn:M:X:m:d:I:BN:O:SCi6xL:0:1:2:3:Fbqf"
+#define GETOPT_STR  "sr:l:c:p:t:g:P:DRn:M:X:m:A:d:I:BN:O:SCi6xL:0:1:2:3:Fbqf"
 #define OPT_FORCE_BIND_KEY_IFINDEX 1001
 #define OPT_NO_BIND_KEY_IFINDEX 1002
 
 static struct option long_opts[] = {
 	{"force-bind-key-ifindex", 0, 0, OPT_FORCE_BIND_KEY_IFINDEX},
@@ -1897,14 +1951,15 @@ static void print_usage(char *prog)
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
@@ -2022,10 +2077,13 @@ int main(int argc, char *argv[])
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
@@ -2085,12 +2143,17 @@ int main(int argc, char *argv[])
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

