Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AFB95ACC61
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 09:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237503AbiIEHJM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 03:09:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237246AbiIEHHX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 03:07:23 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D60CD3F301;
        Mon,  5 Sep 2022 00:06:59 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id fc24so6122187ejc.3;
        Mon, 05 Sep 2022 00:06:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=98GgOyqU5SrtHpoos/tsrBVNkiKisI1bgI0QIXoU8SI=;
        b=C1sHaDlVhBLan4E8rmySPM/erJ9Ts4H1nx7fU2PfCypqGUCAS9Y+1fwfTTvmw2Cuz6
         45RGQJR2MWMdIv1Mfk7+3dDZ4ujonxoUoUlz4eCHPf/IUphXEDXoeXPyZbO6v8eWh1kl
         xNvlngzGYAXKuLeEbUkmC1/yaxenqVYI0wHTNT9dJhHT8zPTFCNFq/U8rn50UpuCtFjQ
         CjCrUjAR5uc3EboIQLibhA+xEucfGOkdVxz6izA5MssuuPnCQsV9k1lnIQeEXzRGtyAD
         Dzvog53dzebxvYCKa9SCM5E3TOdtYeEV0s6siyTHQp6TzjRGn5LzcwHQRFV4R36kg4Ur
         737w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=98GgOyqU5SrtHpoos/tsrBVNkiKisI1bgI0QIXoU8SI=;
        b=YUPQdeLtkRPYmxM3Yj4udGiG9OetiH+K5Jham+16lf+3qA3nokeq6yZUtCPk/tqzNH
         PVUmJmowWtZ38ux+/J+5QG1sv3eXsbUBLajhAWfJ+fvsqhawsaqkx8fCGjslgR31HkZ6
         6jI4kbknWaQOnb/SImy5QtteIsjPfJLSIjL+PhE3tbjNO3oAuFqEMJ+c8Mq/4/waGO73
         7MBMpdX5XcyAzAYapVl/o77/AGuQM+CdBz4mozc47cgIRv63gWJSQ7KY5bJoCCEJcJvP
         MSXRWWYkXpZi5WVzmt7E1qIF/UUSy5Gu21dcR/uHmAbEeuvxYa9yT8PqxIyOrmDMeyhX
         OKRw==
X-Gm-Message-State: ACgBeo2gtrTTINN+n5hDTbMdqhaoqc4LYA2rm5Ql7MSnhaFzZDAloKIZ
        OvURI0WVR5DCVPTOj36qrbw=
X-Google-Smtp-Source: AA6agR714QiF8X3Omg/SwqXHtNKikjxJd9CPHCNYrCsjMH1/P2u6qDGGm/A1p0XVUmKtudFMEg3pLw==
X-Received: by 2002:a17:907:7f9f:b0:73d:6e87:17ce with SMTP id qk31-20020a1709077f9f00b0073d6e8717cemr34291766ejc.366.1662361618466;
        Mon, 05 Sep 2022 00:06:58 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:a080:40ec:9f50:387:3cfb])
        by smtp.gmail.com with ESMTPSA id n27-20020a056402515b00b0043cf2e0ce1csm5882775edd.48.2022.09.05.00.06.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 00:06:57 -0700 (PDT)
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
Subject: [PATCH v8 24/26] selftests: nettest: Rename md5_prefix to key_addr_prefix
Date:   Mon,  5 Sep 2022 10:06:00 +0300
Message-Id: <1ac40bbe7d5746608c771ed0fd9f6f0fea7366cc.1662361354.git.cdleonard@gmail.com>
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

This is in preparation for reusing the same option for TCP-AO

Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 tools/testing/selftests/net/nettest.c | 50 +++++++++++++--------------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/tools/testing/selftests/net/nettest.c b/tools/testing/selftests/net/nettest.c
index 7900fa98eccb..30585050e00a 100644
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
@@ -267,16 +267,16 @@ static int tcp_md5sig(int sd, void *addr, socklen_t alen, struct sock_args *args
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
@@ -312,17 +312,17 @@ static int tcp_md5_remote(int sd, struct sock_args *args)
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
@@ -708,11 +708,11 @@ enum addr_type {
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
@@ -748,32 +748,32 @@ static int convert_addr(struct sock_args *args, const char *_str,
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
@@ -838,13 +838,13 @@ static int validate_addresses(struct sock_args *args)
 
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
@@ -2029,11 +2029,11 @@ int main(int argc, char *argv[])
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
@@ -2091,17 +2091,17 @@ int main(int argc, char *argv[])
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

