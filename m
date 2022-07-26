Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2715A580B6F
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 08:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237970AbiGZGUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 02:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234878AbiGZGSh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 02:18:37 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27B982AC4A;
        Mon, 25 Jul 2022 23:16:29 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id oy13so24340015ejb.1;
        Mon, 25 Jul 2022 23:16:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RVPT2+h1JMxni3JUffui8/RQgc3zJLoReDrrKPMolQw=;
        b=UJePVQYo65M9v2USs8EFHDIFAH1XYBPB10fkxQ9aTwpgidrBI+zvqyXofyn5kWFiGP
         nQc0kakV0imfSUre859iZo/PHAXVXJyjPXdVs/+xVGdLEeDfVfcTkjKUaMBaAad6ckwO
         ttm1uTyUl1EpBvyqDVljePaspqKtH2oDdi45DlpHSQevWSNhC1hAOXaLgxnmkYL5zAvT
         gHZ6Ff2f80xs2Q2L9VIQEBSzXIA95jqj5hWKSR9jRBBBW+cy8VL3sRT0N0epHi16dBcM
         G9bv/lSy2f26xB6CsRfdnKl1x0SRnDBOSEvFKUZNTC/a0whMYFUR7bdIX9BetQeIEHdJ
         5PRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RVPT2+h1JMxni3JUffui8/RQgc3zJLoReDrrKPMolQw=;
        b=YNDSeYHO9HiOoxr8Yw7ex9DErRlHw3qFKNMJ9DCHLaMm6FUMMxv2TFoFnX7W47J+5T
         4rl+PArM5CQm/3J9Ukexhg26dmSyvlNp7Js5gUzfuWwTj19GuMCp02zYiKAZirqFvvGN
         0+qSd9pUDNrOKmQJejrI4RbiG3ey/bHwoNvBfjVsj9TrEkq83QKu3okaF9rpxgBeMdlR
         +UM+8rF3iPJoFRZ9kyOayVQIuXCU8hV7uRGEKmcwTZu0LMjY2ClipFB+puFw+04OEX7q
         Uwp4bNzbp6ejHUHLgQYsUloRt9ZX4ZarK11yyMZD0C8PBGE1IK+YIvsnxr725dr7wzDX
         RhRw==
X-Gm-Message-State: AJIora9BIS7XkRbImY0iB3oPuE3up5LNbXJygGlLF1KrRttcFIPblgwx
        qkMX45L6y8ryeEr760agtFI=
X-Google-Smtp-Source: AGRyM1udI1N3XZr7wRnMZyHTJFEQ1upWuDSWy4nGkfJ9oOIeeAUuG8UCEDdTH3syR5NF36A6gtA+nA==
X-Received: by 2002:a17:907:628a:b0:72f:678d:6047 with SMTP id nd10-20020a170907628a00b0072f678d6047mr12994888ejc.456.1658816174389;
        Mon, 25 Jul 2022 23:16:14 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:a080:2b68:36a:5a94:4ba1])
        by smtp.gmail.com with ESMTPSA id l23-20020a056402345700b0043ba7df7a42sm8133067edc.26.2022.07.25.23.16.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 23:16:13 -0700 (PDT)
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
Subject: [PATCH v6 19/26] selftests: nettest: Rename md5_prefix to key_addr_prefix
Date:   Tue, 26 Jul 2022 09:15:21 +0300
Message-Id: <081a8ad6f656f8ae4ab78403391fb509978c971a.1658815925.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1658815925.git.cdleonard@gmail.com>
References: <cover.1658815925.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is in preparation for reusing the same option for TCP-AO

Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 tools/testing/selftests/net/nettest.c | 50 +++++++++++++--------------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/tools/testing/selftests/net/nettest.c b/tools/testing/selftests/net/nettest.c
index d9a6fd2cd9d3..3841e5fec7c7 100644
--- a/tools/testing/selftests/net/nettest.c
+++ b/tools/testing/selftests/net/nettest.c
@@ -94,17 +94,17 @@ struct sock_args {
 	const char *clientns;
 	const char *serverns;
 
 	const char *password;
 	const char *client_pw;
-	/* prefix for MD5 password */
-	const char *md5_prefix_str;
+	/* prefix for MD5/AO*/
+	const char *key_addr_prefix_str;
 	union {
 		struct sockaddr_in v4;
 		struct sockaddr_in6 v6;
-	} md5_prefix;
-	unsigned int prefix_len;
+	} key_addr;
+	unsigned int key_addr_prefix_len;
 	/* 0: default, -1: force off, +1: force on */
 	int bind_key_ifindex;
 
 	/* expected addresses and device index for connection */
 	const char *expected_dev;
@@ -264,16 +264,16 @@ static int tcp_md5sig(int sd, void *addr, socklen_t alen, struct sock_args *args
 	int rc;
 
 	md5sig.tcpm_keylen = keylen;
 	memcpy(md5sig.tcpm_key, args->password, keylen);
 
-	if (args->prefix_len) {
+	if (args->key_addr_prefix_len) {
 		opt = TCP_MD5SIG_EXT;
 		md5sig.tcpm_flags |= TCP_MD5SIG_FLAG_PREFIX;
 
-		md5sig.tcpm_prefixlen = args->prefix_len;
-		addr = &args->md5_prefix;
+		md5sig.tcpm_prefixlen = args->key_addr_prefix_len;
+		addr = &args->key_addr;
 	}
 	memcpy(&md5sig.tcpm_addr, addr, alen);
 
 	if ((args->ifindex && args->bind_key_ifindex >= 0) || args->bind_key_ifindex >= 1) {
 		opt = TCP_MD5SIG_EXT;
@@ -309,17 +309,17 @@ static int tcp_md5_remote(int sd, struct sock_args *args)
 	int alen;
 
 	switch (args->version) {
 	case AF_INET:
 		sin.sin_port = htons(args->port);
-		sin.sin_addr = args->md5_prefix.v4.sin_addr;
+		sin.sin_addr = args->key_addr.v4.sin_addr;
 		addr = &sin;
 		alen = sizeof(sin);
 		break;
 	case AF_INET6:
 		sin6.sin6_port = htons(args->port);
-		sin6.sin6_addr = args->md5_prefix.v6.sin6_addr;
+		sin6.sin6_addr = args->key_addr.v6.sin6_addr;
 		addr = &sin6;
 		alen = sizeof(sin6);
 		break;
 	default:
 		log_error("unknown address family\n");
@@ -705,11 +705,11 @@ enum addr_type {
 	ADDR_TYPE_LOCAL,
 	ADDR_TYPE_REMOTE,
 	ADDR_TYPE_MCAST,
 	ADDR_TYPE_EXPECTED_LOCAL,
 	ADDR_TYPE_EXPECTED_REMOTE,
-	ADDR_TYPE_MD5_PREFIX,
+	ADDR_TYPE_KEY_PREFIX,
 };
 
 static int convert_addr(struct sock_args *args, const char *_str,
 			enum addr_type atype)
 {
@@ -745,32 +745,32 @@ static int convert_addr(struct sock_args *args, const char *_str,
 		break;
 	case ADDR_TYPE_EXPECTED_REMOTE:
 		desc = "expected remote";
 		addr = &args->expected_raddr;
 		break;
-	case ADDR_TYPE_MD5_PREFIX:
-		desc = "md5 prefix";
+	case ADDR_TYPE_KEY_PREFIX:
+		desc = "key addr prefix";
 		if (family == AF_INET) {
-			args->md5_prefix.v4.sin_family = AF_INET;
-			addr = &args->md5_prefix.v4.sin_addr;
+			args->key_addr.v4.sin_family = AF_INET;
+			addr = &args->key_addr.v4.sin_addr;
 		} else if (family == AF_INET6) {
-			args->md5_prefix.v6.sin6_family = AF_INET6;
-			addr = &args->md5_prefix.v6.sin6_addr;
+			args->key_addr.v6.sin6_family = AF_INET6;
+			addr = &args->key_addr.v6.sin6_addr;
 		} else
 			return 1;
 
 		sep = strchr(str, '/');
 		if (sep) {
 			*sep = '\0';
 			sep++;
 			if (str_to_uint(sep, 1, pfx_len_max,
-					&args->prefix_len) != 0) {
-				fprintf(stderr, "Invalid port\n");
+					&args->key_addr_prefix_len) != 0) {
+				fprintf(stderr, "Invalid prefix\n");
 				return 1;
 			}
 		} else {
-			args->prefix_len = 0;
+			args->key_addr_prefix_len = 0;
 		}
 		break;
 	default:
 		log_error("unknown address type\n");
 		exit(1);
@@ -835,13 +835,13 @@ static int validate_addresses(struct sock_args *args)
 
 	if (args->remote_addr_str &&
 	    convert_addr(args, args->remote_addr_str, ADDR_TYPE_REMOTE) < 0)
 		return 1;
 
-	if (args->md5_prefix_str &&
-	    convert_addr(args, args->md5_prefix_str,
-			 ADDR_TYPE_MD5_PREFIX) < 0)
+	if (args->key_addr_prefix_str &&
+	    convert_addr(args, args->key_addr_prefix_str,
+			 ADDR_TYPE_KEY_PREFIX) < 0)
 		return 1;
 
 	if (args->expected_laddr_str &&
 	    convert_addr(args, args->expected_laddr_str,
 			 ADDR_TYPE_EXPECTED_LOCAL))
@@ -2020,11 +2020,11 @@ int main(int argc, char *argv[])
 			break;
 		case 'X':
 			args.client_pw = optarg;
 			break;
 		case 'm':
-			args.md5_prefix_str = optarg;
+			args.key_addr_prefix_str = optarg;
 			break;
 		case 'S':
 			args.use_setsockopt = 1;
 			break;
 		case 'f':
@@ -2079,17 +2079,17 @@ int main(int argc, char *argv[])
 			return 1;
 		}
 	}
 
 	if (args.password &&
-	    ((!args.has_remote_ip && !args.md5_prefix_str) ||
+	    ((!args.has_remote_ip && !args.key_addr_prefix_str) ||
 	      args.type != SOCK_STREAM)) {
 		log_error("MD5 passwords apply to TCP only and require a remote ip for the password\n");
 		return 1;
 	}
 
-	if (args.md5_prefix_str && !args.password) {
+	if (args.key_addr_prefix_str && !args.password) {
 		log_error("Prefix range for MD5 protection specified without a password\n");
 		return 1;
 	}
 
 	if (iter == 0) {
-- 
2.25.1

