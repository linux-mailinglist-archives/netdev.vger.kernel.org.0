Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3500B42B7FA
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 08:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238155AbhJMGxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 02:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238124AbhJMGw7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 02:52:59 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEC59C061570;
        Tue, 12 Oct 2021 23:50:56 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id d3so5850159edp.3;
        Tue, 12 Oct 2021 23:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6N39G7ZGCVEFusy0Xx0rScelbxpLk6pfw5D48AWuodI=;
        b=iiGu5rUuqINXoeXJUal9rU7i/ufLOqi883k0R9zY26ivnP0Ey1Ial4tu3/Mr8csIx2
         AKVi6Yj7426iy8nJsbhyj5TJ5FZrwdgyQBmfivKhICpGJIZAWaBLo4xahssDdEnphTPN
         3qMrK8knr2tMoaTV+n0gRp20IYekBjqoQxYT55042Qzo4Vmz5IENiLuC4ntygeS9lWPQ
         LhFh50Mt7IA40Az8RuN8BBILGYP0Xq9WqslXNHfSbbEQGqkQ7yuy7wK8aplCAXcpcyhx
         PF8jMyFB+GZi/j1e0nY6l+21m3qejIQAuwOeEDn0u9NIpNmsH9dBb9qIpCk567OTYRDt
         RBmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6N39G7ZGCVEFusy0Xx0rScelbxpLk6pfw5D48AWuodI=;
        b=Vf9y3kJwvmHbeUuqNNt6uqGI/tdRrWt70EG/Ugv5vDLNAQ9nMD2Ucq6CbSItmWJ2by
         y5HT8PnhMHPM1ZB6e4ZHskVkSdF1wP0H6qlIEbXY78/FlfcFYynrYqG3Qm05Yu9jerCJ
         wHyS2+xzlwvGNqZcw9t8XZZ2aWdnb0aTY+3kK1jzHmoDWYFcnLqm8oWGZZN8b3Srfl0t
         1gNnD4SKRWg1ba+IhQuPg/FkDBsvsgWj9bJke6nhHGkm5cQVrCbrsfAmpmONPZ6B3q5w
         Mb6F4tGU9+O3w7YxqKP7vAbqrWgbgGzCWuyxgAhMg8dPlxlbLJEU2EVVrwBn/GBK9Cz2
         SDRQ==
X-Gm-Message-State: AOAM531qYIQIdNdOyN5ggcAb+6hu7c7XkN37Jt/YA8ftlhg83wbQbiyM
        FATP4i3VGwDxVnJa1WmKwa4=
X-Google-Smtp-Source: ABdhPJzuhPKi1h4s7u01kxsEHsUMUCyENeBE03vzAX0K7Wx/YZboJUVO9bSf2toSclju9qQ+6f0eDg==
X-Received: by 2002:a50:d84c:: with SMTP id v12mr6731644edj.201.1634107854528;
        Tue, 12 Oct 2021 23:50:54 -0700 (PDT)
Received: from ponky.lan ([2a04:241e:501:3870:6346:a6a3:f7ea:349e])
        by smtp.gmail.com with ESMTPSA id m15sm4568710edd.5.2021.10.12.23.50.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 23:50:54 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Yonghong Song <yhs@fb.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/4] selftests: nettest: Add --{do,no}-bind-key-ifindex
Date:   Wed, 13 Oct 2021 09:50:37 +0300
Message-Id: <122a68cd7fd28e9a5580f16f650826437f7397a1.1634107317.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1634107317.git.cdleonard@gmail.com>
References: <cover.1634107317.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These options allow explicit control over the TCP_MD5SIG_FLAG_IFINDEX
flag instead of always setting it based on binding to an interface.

Do this by converting to getopt_long because nettest has too many
single-character flags already and getopt_long is widely used in
selftests.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 tools/testing/selftests/net/nettest.c | 28 +++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/nettest.c b/tools/testing/selftests/net/nettest.c
index bd6288302094..acf5cd153eaf 100644
--- a/tools/testing/selftests/net/nettest.c
+++ b/tools/testing/selftests/net/nettest.c
@@ -26,10 +26,11 @@
 #include <stdlib.h>
 #include <string.h>
 #include <unistd.h>
 #include <time.h>
 #include <errno.h>
+#include <getopt.h>
 
 #include <linux/xfrm.h>
 #include <linux/ipsec.h>
 #include <linux/pfkeyv2.h>
 
@@ -99,10 +100,12 @@ struct sock_args {
 	union {
 		struct sockaddr_in v4;
 		struct sockaddr_in6 v6;
 	} md5_prefix;
 	unsigned int prefix_len;
+	/* 0: default, -1: force off, +1: force on */
+	int bind_key_ifindex;
 
 	/* expected addresses and device index for connection */
 	const char *expected_dev;
 	const char *expected_server_dev;
 	int expected_ifindex;
@@ -269,15 +272,18 @@ static int tcp_md5sig(int sd, void *addr, socklen_t alen, struct sock_args *args
 		md5sig.tcpm_prefixlen = args->prefix_len;
 		addr = &args->md5_prefix;
 	}
 	memcpy(&md5sig.tcpm_addr, addr, alen);
 
-	if (args->ifindex) {
+	if ((args->ifindex && args->bind_key_ifindex >= 0) || args->bind_key_ifindex >= 1) {
 		opt = TCP_MD5SIG_EXT;
 		md5sig.tcpm_flags |= TCP_MD5SIG_FLAG_IFINDEX;
 
 		md5sig.tcpm_ifindex = args->ifindex;
+		log_msg("TCP_MD5SIG_FLAG_IFINDEX set tcpm_ifindex=%d\n", md5sig.tcpm_ifindex);
+	} else {
+		log_msg("TCP_MD5SIG_FLAG_IFINDEX off\n", md5sig.tcpm_ifindex);
 	}
 
 	rc = setsockopt(sd, IPPROTO_TCP, opt, &md5sig, sizeof(md5sig));
 	if (rc < 0) {
 		/* ENOENT is harmless. Returned when a password is cleared */
@@ -1820,10 +1826,18 @@ static int ipc_parent(int cpid, int fd, struct sock_args *args)
 	wait(&status);
 	return client_status;
 }
 
 #define GETOPT_STR  "sr:l:c:p:t:g:P:DRn:M:X:m:d:I:BN:O:SCi6xL:0:1:2:3:Fbq"
+#define OPT_DO_BIND_KEY_IFINDEX 1001
+#define OPT_NO_BIND_KEY_IFINDEX 1002
+
+static struct option long_opts[] = {
+	{"do-bind-key-ifindex", 0, 0, OPT_DO_BIND_KEY_IFINDEX},
+	{"no-bind-key-ifindex", 0, 0, OPT_NO_BIND_KEY_IFINDEX},
+	{0, 0, 0, 0}
+};
 
 static void print_usage(char *prog)
 {
 	printf(
 	"usage: %s OPTS\n"
@@ -1856,10 +1870,14 @@ static void print_usage(char *prog)
 	"    -n num        number of times to send message\n"
 	"\n"
 	"    -M password   use MD5 sum protection\n"
 	"    -X password   MD5 password for client mode\n"
 	"    -m prefix/len prefix and length to use for MD5 key\n"
+	"    --no-bind-key-ifindex: Force TCP_MD5SIG_FLAG_IFINDEX off\n"
+	"    --do-bind-key-ifindex: Force TCP_MD5SIG_FLAG_IFINDEX on\n"
+	"        (default: only if -I is passed)\n"
+	"\n"
 	"    -g grp        multicast group (e.g., 239.1.1.1)\n"
 	"    -i            interactive mode (default is echo and terminate)\n"
 	"\n"
 	"    -0 addr       Expected local address\n"
 	"    -1 addr       Expected remote address\n"
@@ -1891,11 +1909,11 @@ int main(int argc, char *argv[])
 
 	/*
 	 * process input args
 	 */
 
-	while ((rc = getopt(argc, argv, GETOPT_STR)) != -1) {
+	while ((rc = getopt_long(argc, argv, GETOPT_STR, long_opts, NULL)) != -1) {
 		switch (rc) {
 		case 'B':
 			both_mode = 1;
 			break;
 		case 's':
@@ -1964,10 +1982,16 @@ int main(int argc, char *argv[])
 			msg = random_msg(atoi(optarg));
 			break;
 		case 'M':
 			args.password = optarg;
 			break;
+		case OPT_DO_BIND_KEY_IFINDEX:
+			args.bind_key_ifindex = 1;
+			break;
+		case OPT_NO_BIND_KEY_IFINDEX:
+			args.bind_key_ifindex = -1;
+			break;
 		case 'X':
 			args.client_pw = optarg;
 			break;
 		case 'm':
 			args.md5_prefix_str = optarg;
-- 
2.25.1

