Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECBDB3E4E9C
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 23:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236687AbhHIVgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 17:36:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236517AbhHIVgY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 17:36:24 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F10ABC0617A4;
        Mon,  9 Aug 2021 14:36:00 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id f13so26778619edq.13;
        Mon, 09 Aug 2021 14:36:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uG3oHTASBquJceLiOdEfcWQQkF/eH5moDohL/r9HsUw=;
        b=rcgmuQw6H5q2JM/IgIbadWTq3WVWGRiwykKjM/MnB18T5J2L2R+Vj9MAujuT+uedO4
         ChMLLu1nKya6brD5LiIMGPVoTNpTnC6UnxzfgJNq7tRuwYL5RFDxzJq79BglW8BHVpke
         avUQEeUQ0pb2pCJKp9UNjJ79KaXeusdkw7zSTsg9aMYKYyKKhiqgnOTINpfn98U7uR6M
         PCd8RDtZv9CgUijpeT0MO3KaVsXy4casrSuZbz0EtZfS65SuV/KvXWkEJ5Boce4BTK9a
         2VEWY+px19NfwLPo3qOkJQcoeJgFA1QKpOD8WHi3cSeEoijMOEpOyKETPyBDzYjFLt2g
         JVBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uG3oHTASBquJceLiOdEfcWQQkF/eH5moDohL/r9HsUw=;
        b=Q5F0mK/EzZR6oRs89SsCMA7uJ6u0bCWCVdMgS5wvEL+gTV2mdbCNa069hQ5DA5B0x3
         45MN4RMqO/eLxBusrRqi2YMJB/0HHqTjEIZaRE1UXYwWmd2GMgOHg4y5pf6qLgj7ulMq
         0yPAXxjhl6PrNHorPF8aCz6LHiGXM+8pskGrb3tqpmYZsMJ14sn1rEFwhKSNF1no9wJ9
         kDQAAAMmyrwN5KivT7gMJCUqGGWXedwEdWafQeez/65j76jCRO37T2ETpcvTxNC+esXM
         aN/vDKvexvr6RY4nJieoTsqj9mMuE/IhVooJm3SVzlb/b8V0gbqQLBF6Yg0e//Gs5XeP
         97Ug==
X-Gm-Message-State: AOAM53206pcGKAh95sYarvCALHeQ3FsPNrMhvGsYq0qpUQt3xsbObCoh
        lGxL6F+aWcAxFZ+lnWR6l0M=
X-Google-Smtp-Source: ABdhPJztgoQQKUJPRwBdJwQhSt0StxMgyBLPlqwpdUm4g094eDhkMGxjkrGSRVLyk0L48ZyioC3LCQ==
X-Received: by 2002:a50:ac82:: with SMTP id x2mr461232edc.350.1628544959642;
        Mon, 09 Aug 2021 14:35:59 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:1d80:688d:23e:82c6:84aa])
        by smtp.gmail.com with ESMTPSA id v24sm5542932edt.41.2021.08.09.14.35.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 14:35:59 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        David Ahern <dsahern@kernel.org>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Menglong Dong <dong.menglong@zte.com.cn>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [RFCv2 8/9] selftests: Initial TCP-AO support for nettest
Date:   Tue, 10 Aug 2021 00:35:37 +0300
Message-Id: <909135b0313fc7b4bb8dbbd7686770483887ccc1.1628544649.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1628544649.git.cdleonard@gmail.com>
References: <cover.1628544649.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 tools/testing/selftests/net/nettest.c | 43 ++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/nettest.c b/tools/testing/selftests/net/nettest.c
index bd6288302094..48d8f3a6eb27 100644
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
 
@@ -250,10 +252,36 @@ static int switch_ns(const char *ns)
 	close(fd);
 
 	return ret;
 }
 
+static int tcp_set_authopt(int sd, struct sock_args *args)
+{
+	struct tcp_authopt info;
+	struct tcp_authopt_key key;
+	int rc;
+
+	memset(&info, 0, sizeof(info));
+	info.local_send_id = 1;
+
+	rc = setsockopt(sd, IPPROTO_TCP, TCP_AUTHOPT, &info, sizeof(info));
+	if (rc < 0)
+		log_err_errno("setsockopt(TCP_AUHTOPT_KEY)");
+
+	memset(&key, 0, sizeof(key));
+	strcpy((char *)key.key, args->authopt_password);
+	key.keylen = strlen(args->authopt_password);
+	key.alg = TCP_AUTHOPT_ALG_HMAC_SHA_1_96;
+	key.local_id = 1;
+
+	rc = setsockopt(sd, IPPROTO_TCP, TCP_AUTHOPT_KEY, &key, sizeof(key));
+	if (rc < 0)
+		log_err_errno("setsockopt(TCP_AUHTOPT_KEY)");
+
+	return rc;
+}
+
 static int tcp_md5sig(int sd, void *addr, socklen_t alen, struct sock_args *args)
 {
 	int keylen = strlen(args->password);
 	struct tcp_md5sig md5sig = {};
 	int opt = TCP_MD5SIG;
@@ -1508,10 +1536,15 @@ static int do_server(struct sock_args *args, int ipc_fd)
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
@@ -1630,10 +1663,13 @@ static int connectsock(void *addr, socklen_t alen, struct sock_args *args)
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
@@ -1819,11 +1855,11 @@ static int ipc_parent(int cpid, int fd, struct sock_args *args)
 
 	wait(&status);
 	return client_status;
 }
 
-#define GETOPT_STR  "sr:l:c:p:t:g:P:DRn:M:X:m:d:I:BN:O:SCi6xL:0:1:2:3:Fbq"
+#define GETOPT_STR  "sr:l:c:p:t:g:P:DRn:M:X:m:A:d:I:BN:O:SCi6xL:0:1:2:3:Fbq"
 
 static void print_usage(char *prog)
 {
 	printf(
 	"usage: %s OPTS\n"
@@ -1856,10 +1892,12 @@ static void print_usage(char *prog)
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
@@ -1970,10 +2008,13 @@ int main(int argc, char *argv[])
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

