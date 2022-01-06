Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4492E485E50
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 02:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344517AbiAFB56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 20:57:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344502AbiAFB5w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 20:57:52 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85BDAC061201;
        Wed,  5 Jan 2022 17:57:52 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id j16so1426727pll.10;
        Wed, 05 Jan 2022 17:57:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tjEyxmzWv+vv0x7VIz02gdNHRKgdP8+rFV7YB5P7KbE=;
        b=XATp67aaHuOeQ45p/5qCXdspV2waRAgs3jM/2D+BHbgvaOKAfdnHdnDbT/Eq6zq7Jm
         jELa+uD/cHYkK5waboBU96kLpj8+7Tzvt63tpJO0z+FNfklkjxLhyxGUX+zvuxFr4vOY
         UVZrLf+cO+u/uA6q3+CMRj+3DbmOz9L8qqTDCROV4tR+NFCfoHAe3sWM6FNzNOgvqCNZ
         G4urck57tM/gNPzppR0V/23wOZZEkLpGZ6jvVJ07jr55kOLGdGf5eRmIuW2yP35qfoNk
         B4LrxsfBjbO4eznb+tUlBUGG9dk1YkVZZ64c2Nh19/Lux0lY/qnkO9jJ/K3xOZwz1iR9
         M28Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tjEyxmzWv+vv0x7VIz02gdNHRKgdP8+rFV7YB5P7KbE=;
        b=wRDDu/E/kcisuD3FkuHorae2q0XgOq8VjDvTBAlsKflNKI226cN1Trmp5pA5s7iLMM
         sXLhnXIKgmlM1X3DtawBRh4c69ox+LjVJmp6tgSAP0f9Q8maNuwatFdD3m8non05PyN5
         4Rh/escY3WPLGDEn3k/HCx/pvGh4hRcQisrJWrZKQGQPE3Pf1UyBTwJJPzfkP0YUgZSV
         GVbDDPH8G/nq+KMdlmcZkvlWFa9kTf2Jab42U4m5X+B93xSTCzjXprFiXgFikSAOVhke
         pnVv/4klvukKAuy3rUbsqpu1RiC81T/Vf2wpuhhdm7RVU46JW8S6/7/RgWXe9B7cjduJ
         /Xng==
X-Gm-Message-State: AOAM530bVtg+gNi1XpEB630m1sPXdxejLiVW1VidkPdoCFe+DAMMKYbm
        valLfJCn3qXnFbW+rPVvJs8=
X-Google-Smtp-Source: ABdhPJy5+bW+xbLIxEMC0wi2uSHLEkeF5meysfOGrWVus+JgnhlcKnwsSeLO1YcrlWqRfiVSfo4vFA==
X-Received: by 2002:a17:902:be0e:b0:149:c124:6027 with SMTP id r14-20020a170902be0e00b00149c1246027mr12647192pls.20.1641434272070;
        Wed, 05 Jan 2022 17:57:52 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.9])
        by smtp.gmail.com with ESMTPSA id g21sm330910pfc.75.2022.01.05.17.57.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 17:57:51 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     kuba@kernel.org, edumazet@google.com
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        shuah@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, bpf@vger.kernel.org,
        Menglong Dong <imagedong@tencent.com>
Subject: [PATCH v4 net-next 2/3] bpf: selftests: add bind retry for post_bind{4, 6}
Date:   Thu,  6 Jan 2022 09:57:20 +0800
Message-Id: <20220106015721.3038819-3-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220106015721.3038819-1-imagedong@tencent.com>
References: <20220106015721.3038819-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

With previous patch, kernel is able to 'put_port' after sys_bind()
fails. Add the test for that case: rebind another port after
sys_bind() fails. If the bind success, it means previous bind
operation is already undoed.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 tools/testing/selftests/bpf/test_sock.c | 166 +++++++++++++++++++++---
 1 file changed, 146 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_sock.c b/tools/testing/selftests/bpf/test_sock.c
index e8edd3dd3ec2..68525d68d4e5 100644
--- a/tools/testing/selftests/bpf/test_sock.c
+++ b/tools/testing/selftests/bpf/test_sock.c
@@ -35,12 +35,15 @@ struct sock_test {
 	/* Endpoint to bind() to */
 	const char *ip;
 	unsigned short port;
+	unsigned short port_retry;
 	/* Expected test result */
 	enum {
 		LOAD_REJECT,
 		ATTACH_REJECT,
 		BIND_REJECT,
 		SUCCESS,
+		RETRY_SUCCESS,
+		RETRY_REJECT
 	} result;
 };
 
@@ -60,6 +63,7 @@ static struct sock_test tests[] = {
 		0,
 		NULL,
 		0,
+		0,
 		LOAD_REJECT,
 	},
 	{
@@ -77,6 +81,7 @@ static struct sock_test tests[] = {
 		0,
 		NULL,
 		0,
+		0,
 		LOAD_REJECT,
 	},
 	{
@@ -94,6 +99,7 @@ static struct sock_test tests[] = {
 		0,
 		NULL,
 		0,
+		0,
 		LOAD_REJECT,
 	},
 	{
@@ -111,6 +117,7 @@ static struct sock_test tests[] = {
 		0,
 		NULL,
 		0,
+		0,
 		LOAD_REJECT,
 	},
 	{
@@ -125,6 +132,7 @@ static struct sock_test tests[] = {
 		SOCK_STREAM,
 		"127.0.0.1",
 		8097,
+		0,
 		SUCCESS,
 	},
 	{
@@ -139,6 +147,7 @@ static struct sock_test tests[] = {
 		SOCK_STREAM,
 		"127.0.0.1",
 		8097,
+		0,
 		SUCCESS,
 	},
 	{
@@ -153,6 +162,7 @@ static struct sock_test tests[] = {
 		0,
 		NULL,
 		0,
+		0,
 		ATTACH_REJECT,
 	},
 	{
@@ -167,6 +177,7 @@ static struct sock_test tests[] = {
 		0,
 		NULL,
 		0,
+		0,
 		ATTACH_REJECT,
 	},
 	{
@@ -181,6 +192,7 @@ static struct sock_test tests[] = {
 		0,
 		NULL,
 		0,
+		0,
 		ATTACH_REJECT,
 	},
 	{
@@ -195,6 +207,7 @@ static struct sock_test tests[] = {
 		0,
 		NULL,
 		0,
+		0,
 		ATTACH_REJECT,
 	},
 	{
@@ -209,6 +222,7 @@ static struct sock_test tests[] = {
 		SOCK_STREAM,
 		"0.0.0.0",
 		0,
+		0,
 		BIND_REJECT,
 	},
 	{
@@ -223,6 +237,7 @@ static struct sock_test tests[] = {
 		SOCK_STREAM,
 		"::",
 		0,
+		0,
 		BIND_REJECT,
 	},
 	{
@@ -253,6 +268,7 @@ static struct sock_test tests[] = {
 		SOCK_STREAM,
 		"::1",
 		8193,
+		0,
 		BIND_REJECT,
 	},
 	{
@@ -283,8 +299,102 @@ static struct sock_test tests[] = {
 		SOCK_STREAM,
 		"127.0.0.1",
 		4098,
+		0,
 		SUCCESS,
 	},
+	{
+		"bind4 deny specific IP & port of TCP, and retry",
+		.insns = {
+			BPF_MOV64_REG(BPF_REG_6, BPF_REG_1),
+
+			/* if (ip == expected && port == expected) */
+			BPF_LDX_MEM(BPF_W, BPF_REG_7, BPF_REG_6,
+				    offsetof(struct bpf_sock, src_ip4)),
+			BPF_JMP_IMM(BPF_JNE, BPF_REG_7,
+				    __bpf_constant_ntohl(0x7F000001), 4),
+			BPF_LDX_MEM(BPF_W, BPF_REG_7, BPF_REG_6,
+				    offsetof(struct bpf_sock, src_port)),
+			BPF_JMP_IMM(BPF_JNE, BPF_REG_7, 0x1002, 2),
+
+			/* return DENY; */
+			BPF_MOV64_IMM(BPF_REG_0, 0),
+			BPF_JMP_A(1),
+
+			/* else return ALLOW; */
+			BPF_MOV64_IMM(BPF_REG_0, 1),
+			BPF_EXIT_INSN(),
+		},
+		BPF_CGROUP_INET4_POST_BIND,
+		BPF_CGROUP_INET4_POST_BIND,
+		AF_INET,
+		SOCK_STREAM,
+		"127.0.0.1",
+		4098,
+		5000,
+		RETRY_SUCCESS,
+	},
+	{
+		"bind4 deny specific IP & port of UDP, and retry",
+		.insns = {
+			BPF_MOV64_REG(BPF_REG_6, BPF_REG_1),
+
+			/* if (ip == expected && port == expected) */
+			BPF_LDX_MEM(BPF_W, BPF_REG_7, BPF_REG_6,
+				    offsetof(struct bpf_sock, src_ip4)),
+			BPF_JMP_IMM(BPF_JNE, BPF_REG_7,
+				    __bpf_constant_ntohl(0x7F000001), 4),
+			BPF_LDX_MEM(BPF_W, BPF_REG_7, BPF_REG_6,
+				    offsetof(struct bpf_sock, src_port)),
+			BPF_JMP_IMM(BPF_JNE, BPF_REG_7, 0x1002, 2),
+
+			/* return DENY; */
+			BPF_MOV64_IMM(BPF_REG_0, 0),
+			BPF_JMP_A(1),
+
+			/* else return ALLOW; */
+			BPF_MOV64_IMM(BPF_REG_0, 1),
+			BPF_EXIT_INSN(),
+		},
+		BPF_CGROUP_INET4_POST_BIND,
+		BPF_CGROUP_INET4_POST_BIND,
+		AF_INET,
+		SOCK_DGRAM,
+		"127.0.0.1",
+		4098,
+		5000,
+		RETRY_SUCCESS,
+	},
+	{
+		"bind6 deny specific IP & port, and retry",
+		.insns = {
+			BPF_MOV64_REG(BPF_REG_6, BPF_REG_1),
+
+			/* if (ip == expected && port == expected) */
+			BPF_LDX_MEM(BPF_W, BPF_REG_7, BPF_REG_6,
+				    offsetof(struct bpf_sock, src_ip6[3])),
+			BPF_JMP_IMM(BPF_JNE, BPF_REG_7,
+				    __bpf_constant_ntohl(0x00000001), 4),
+			BPF_LDX_MEM(BPF_W, BPF_REG_7, BPF_REG_6,
+				    offsetof(struct bpf_sock, src_port)),
+			BPF_JMP_IMM(BPF_JNE, BPF_REG_7, 0x2001, 2),
+
+			/* return DENY; */
+			BPF_MOV64_IMM(BPF_REG_0, 0),
+			BPF_JMP_A(1),
+
+			/* else return ALLOW; */
+			BPF_MOV64_IMM(BPF_REG_0, 1),
+			BPF_EXIT_INSN(),
+		},
+		BPF_CGROUP_INET6_POST_BIND,
+		BPF_CGROUP_INET6_POST_BIND,
+		AF_INET6,
+		SOCK_STREAM,
+		"::1",
+		8193,
+		9000,
+		RETRY_SUCCESS,
+	},
 	{
 		"bind4 allow all",
 		.insns = {
@@ -297,6 +407,7 @@ static struct sock_test tests[] = {
 		SOCK_STREAM,
 		"0.0.0.0",
 		0,
+		0,
 		SUCCESS,
 	},
 	{
@@ -311,6 +422,7 @@ static struct sock_test tests[] = {
 		SOCK_STREAM,
 		"::",
 		0,
+		0,
 		SUCCESS,
 	},
 };
@@ -351,14 +463,15 @@ static int attach_sock_prog(int cgfd, int progfd,
 	return bpf_prog_attach(progfd, cgfd, attach_type, BPF_F_ALLOW_OVERRIDE);
 }
 
-static int bind_sock(int domain, int type, const char *ip, unsigned short port)
+static int bind_sock(int domain, int type, const char *ip,
+		     unsigned short port, unsigned short port_retry)
 {
 	struct sockaddr_storage addr;
 	struct sockaddr_in6 *addr6;
 	struct sockaddr_in *addr4;
 	int sockfd = -1;
 	socklen_t len;
-	int err = 0;
+	int res = SUCCESS;
 
 	sockfd = socket(domain, type, 0);
 	if (sockfd < 0)
@@ -384,21 +497,44 @@ static int bind_sock(int domain, int type, const char *ip, unsigned short port)
 		goto err;
 	}
 
-	if (bind(sockfd, (const struct sockaddr *)&addr, len) == -1)
-		goto err;
+	if (bind(sockfd, (const struct sockaddr *)&addr, len) == -1) {
+		/* sys_bind() may fail for different reasons, errno has to be
+		 * checked to confirm that BPF program rejected it.
+		 */
+		if (errno != EPERM)
+			goto err;
+		if (port_retry)
+			goto retry;
+		res = BIND_REJECT;
+		goto out;
+	}
 
+	goto out;
+retry:
+	if (domain == AF_INET)
+		addr4->sin_port = htons(port_retry);
+	else
+		addr6->sin6_port = htons(port_retry);
+	if (bind(sockfd, (const struct sockaddr *)&addr, len) == -1) {
+		if (errno != EPERM)
+			goto err;
+		res = RETRY_REJECT;
+	} else {
+		res = RETRY_SUCCESS;
+	}
 	goto out;
 err:
-	err = -1;
+	res = -1;
 out:
 	close(sockfd);
-	return err;
+	return res;
 }
 
 static int run_test_case(int cgfd, const struct sock_test *test)
 {
 	int progfd = -1;
 	int err = 0;
+	int res;
 
 	printf("Test case: %s .. ", test->descr);
 	progfd = load_sock_prog(test->insns, test->expected_attach_type);
@@ -416,21 +552,11 @@ static int run_test_case(int cgfd, const struct sock_test *test)
 			goto err;
 	}
 
-	if (bind_sock(test->domain, test->type, test->ip, test->port) == -1) {
-		/* sys_bind() may fail for different reasons, errno has to be
-		 * checked to confirm that BPF program rejected it.
-		 */
-		if (test->result == BIND_REJECT && errno == EPERM)
-			goto out;
-		else
-			goto err;
-	}
-
+	res = bind_sock(test->domain, test->type, test->ip, test->port,
+			test->port_retry);
+	if (res > 0 && test->result == res)
+		goto out;
 
-	if (test->result != SUCCESS)
-		goto err;
-
-	goto out;
 err:
 	err = -1;
 out:
-- 
2.30.2

