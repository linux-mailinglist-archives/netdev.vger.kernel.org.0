Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D28D03F6B36
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 23:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238063AbhHXVgw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 17:36:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235328AbhHXVgb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 17:36:31 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 646B3C06179A;
        Tue, 24 Aug 2021 14:35:46 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id s25so21094307edw.0;
        Tue, 24 Aug 2021 14:35:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6bd81ZzhYWDXtU8irtzbLufy7NFGe2+2aZRj+xbH9LY=;
        b=VvpbOLzHuJV0qVGp2TZFFqBj4nOT/cRzpuw5llLiqFVRs4smuJPNtk8wifK6aUeqgf
         yGS5tkIodOa77+WAjinpDM+FB+t+5d0D9hryEc/ONDRnuSukNzGdp9T08SgpwzQ3GMkd
         PEi7RHP8mpfb3/5ue7ZXoO2t8zBT6COrlceDfhs9U2942WK6BYZlbO438NEJ1Nlf09xQ
         cgsGpJ1oRlTylgT2DOdNnDdoNFwyzNm9rGqar4pDM0qtltmu23FPjX2ywk+u3obJteZU
         xrg03Yi6IdAOZNCGjw62wSb4wtADDOuR6xGOymrdAqWodBglA6pVISxb+XgP2dQsMw69
         GH4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6bd81ZzhYWDXtU8irtzbLufy7NFGe2+2aZRj+xbH9LY=;
        b=HKj2zW0DmCtO+nUj762ME5KBPBQEsr67HM7k6BuC6ZTYW1jhGA3k2xRPWLuDidTesm
         wdEg9kkpEDA5KhYJbY2PTmKpqcrNZxSwdhqIycnroHREA/Quv95tnA6DdYzRL8LvNGVv
         nBmpDk7NNMvCPWluCoCLs/AR7LD8kxeWWlGiwzE46mRxsNeu9s/Z2o8pjI60NcuRpUzn
         mc+1xxGZUJOJrSNvhK6EjeHq09ASELfm/YFCKOYZB9o5FFlUxRmG7vZ1du+mM6iCGolV
         sroGRUNoHer3Vv/ZKWnTOF6QuWNcjEpHBeot1BWbuAdXj1gniR9OQ4HpInDdbLfdt0+a
         FuvQ==
X-Gm-Message-State: AOAM5317EcVJqIuvZD4D8pxvUXnIiE44lCh9DPajinGQHK0QAQXtfqCn
        eUwINneSwVMXc7ZZsJLIXdo=
X-Google-Smtp-Source: ABdhPJw2h/zsATj/PM2KnkDUUvABR/JO5sAETUzkR9T9OxDhBQtLjlkFgCpjGw8rIdwyD/2Yji1Meg==
X-Received: by 2002:aa7:c7c2:: with SMTP id o2mr45234701eds.166.1629840945054;
        Tue, 24 Aug 2021 14:35:45 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:1d80:ed0a:7326:fbac:b4c])
        by smtp.gmail.com with ESMTPSA id d16sm12348357edu.8.2021.08.24.14.35.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 14:35:44 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     Dmitry Safonov <0x7f454c46@gmail.com>,
        David Ahern <dsahern@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
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
        Priyaranjan Jha <priyarjha@google.com>,
        Menglong Dong <dong.menglong@zte.com.cn>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFCv3 11/15] selftests: Initial tcp_authopt support for nettest
Date:   Wed, 25 Aug 2021 00:34:44 +0300
Message-Id: <9d1e6b5f20a09ade3e5110d39353713c8ce210fe.1629840814.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1629840814.git.cdleonard@gmail.com>
References: <cover.1629840814.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for configuring TCP Authentication Option. Only a single key
with default options.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 tools/testing/selftests/net/nettest.c | 34 ++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/nettest.c b/tools/testing/selftests/net/nettest.c
index bd6288302094..f04c6af79129 100644
--- a/tools/testing/selftests/net/nettest.c
+++ b/tools/testing/selftests/net/nettest.c
@@ -100,10 +100,12 @@ struct sock_args {
 		struct sockaddr_in v4;
 		struct sockaddr_in6 v6;
 	} md5_prefix;
 	unsigned int prefix_len;
 
+	const char *authopt_password;
+
 	/* expected addresses and device index for connection */
 	const char *expected_dev;
 	const char *expected_server_dev;
 	int expected_ifindex;
 
@@ -250,10 +252,27 @@ static int switch_ns(const char *ns)
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
@@ -1508,10 +1527,15 @@ static int do_server(struct sock_args *args, int ipc_fd)
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
@@ -1630,10 +1654,13 @@ static int connectsock(void *addr, socklen_t alen, struct sock_args *args)
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
@@ -1819,11 +1846,11 @@ static int ipc_parent(int cpid, int fd, struct sock_args *args)
 
 	wait(&status);
 	return client_status;
 }
 
-#define GETOPT_STR  "sr:l:c:p:t:g:P:DRn:M:X:m:d:I:BN:O:SCi6xL:0:1:2:3:Fbq"
+#define GETOPT_STR  "sr:l:c:p:t:g:P:DRn:M:X:m:A:d:I:BN:O:SCi6xL:0:1:2:3:Fbq"
 
 static void print_usage(char *prog)
 {
 	printf(
 	"usage: %s OPTS\n"
@@ -1856,10 +1883,12 @@ static void print_usage(char *prog)
 	"    -n num        number of times to send message\n"
 	"\n"
 	"    -M password   use MD5 sum protection\n"
 	"    -X password   MD5 password for client mode\n"
 	"    -m prefix/len prefix and length to use for MD5 key\n"
+	"    -A password   use RFC5925 TCP Authentication option\n"
+	"\n"
 	"    -g grp        multicast group (e.g., 239.1.1.1)\n"
 	"    -i            interactive mode (default is echo and terminate)\n"
 	"\n"
 	"    -0 addr       Expected local address\n"
 	"    -1 addr       Expected remote address\n"
@@ -1970,10 +1999,13 @@ int main(int argc, char *argv[])
 			args.client_pw = optarg;
 			break;
 		case 'm':
 			args.md5_prefix_str = optarg;
 			break;
+		case 'A':
+			args.authopt_password = optarg;
+			break;
 		case 'S':
 			args.use_setsockopt = 1;
 			break;
 		case 'C':
 			args.use_cmsg = 1;
-- 
2.25.1

