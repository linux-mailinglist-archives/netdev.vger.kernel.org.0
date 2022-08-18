Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC352598D34
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 22:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345862AbiHRUCf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 16:02:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345778AbiHRUBg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 16:01:36 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6B4DD1E0E;
        Thu, 18 Aug 2022 13:00:53 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id z20so3181857edb.9;
        Thu, 18 Aug 2022 13:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=RVPT2+h1JMxni3JUffui8/RQgc3zJLoReDrrKPMolQw=;
        b=pTVYu+4O9MrblgqeRcoLgWbDtcYs5qt3MXxmppuzOGQaYE7wBEPJvVkhBNhyqKOL5I
         ng7/ffkWnnOt1Kt6JdsBOPkPfH/rOj2N/Gu+t0XYAnrPZ4HY4LWVGNNfd0ALj/epROn2
         Aw3G1SUm3X5Rx59W1rksTJZu849ufYk3r9SbLs0ovm6S0KHtprMSoKHCwewquG9R32Qw
         HY/xpMqTdKMg5gSbDyqKFHnGFAECDonMCU3laIsGa14Lrur1KHPOTvIKQODDlMYdfl10
         NKjmvaqL5Pl9HPz5m0q6tCJatJgo4eUHArZtbfl4PLK269W7V+xXogYhQt0GS0e0NfPu
         KxGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=RVPT2+h1JMxni3JUffui8/RQgc3zJLoReDrrKPMolQw=;
        b=6P+wC+vZGAy3F6nkU1TA4y95ECFT7voApVtuuPcnVhATIU3L3Vjs5+uB53fRTVUpD0
         vp60NJll7Gi1MV0A+dhGpnQRHdRMbZMRSydSCtlstwNJ3l/y3f8QK+YpnRwIi6Le3qGc
         GA/tuiTV+T9ICsr4ehQg7EwQPQu41Dba0F3fwlvZDmigbrxL4cRVCTW9Ge/gmIPiCggr
         3HAJ576Kt+mIXbpH98FN9hJX6YYKEFioaO8mLh6NVrX2F2xPuFJtIjYjZzsir941+6iO
         BUFLKixihtQrCxeKfUH+6U/hDxJHSZPKhF7lnbAak2Y3YnXDbYPtOqOAaqAyZ2vZX/wK
         HfaQ==
X-Gm-Message-State: ACgBeo3VEokDX8v9FmKSfe/o/6hu/ftm5rvupQg59Peu0Ee0yXdBxHl7
        BQADU00rb+/aMH41sai39nU=
X-Google-Smtp-Source: AA6agR5r9PaAY2cY9tjV9YqGGQzMZNVniRLwNoGn8NOAJSMqMpGjRyoyNop4MEw0AXlW00iRGdDvQQ==
X-Received: by 2002:a05:6402:438d:b0:43d:b383:660f with SMTP id o13-20020a056402438d00b0043db383660fmr3424941edc.283.1660852852074;
        Thu, 18 Aug 2022 13:00:52 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:a080:17c8:ba1c:b6f3:3fe0])
        by smtp.gmail.com with ESMTPSA id fw30-20020a170907501e00b00722e4bab163sm1215087ejc.200.2022.08.18.13.00.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 13:00:51 -0700 (PDT)
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
Subject: [PATCH v7 19/26] selftests: nettest: Rename md5_prefix to key_addr_prefix
Date:   Thu, 18 Aug 2022 22:59:53 +0300
Message-Id: <5a4ba7da8e1f28997e5bc46a83a862e2f4084f1d.1660852705.git.cdleonard@gmail.com>
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

