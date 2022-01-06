Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5605148652A
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 14:21:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239460AbiAFNVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 08:21:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239502AbiAFNU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 08:20:58 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2F25C06118A;
        Thu,  6 Jan 2022 05:20:57 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id t187so2489384pfb.11;
        Thu, 06 Jan 2022 05:20:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TIlheWExIsI3HU7mhBfBiCGwxw5Bn+6mfDQrLPyXWAI=;
        b=i5cIpPfZaL6xYH85Ef94mdZHEpOJ2nKPST6yOIQINnCebwijXuMxxIv0qdQzJWsZRK
         aAr4DayQO01BQ1GvYp1oIXUiYManL61VCNTKP8vlpH1WNKTWl8TvO5fx5BkGZF/TNe4f
         SsKp3HBDYJ0Ec4uSamrzjhwAq86UrB8iHguv7OIf+78+7LNZRKYPM6nkH2Ym87cIAeAf
         E4rhhqluycCZUBidWrnwcDs1PHce9otgx8My90lTucOZ63elYoy87Jxborzw7w3C3HIK
         Wt2h8Fhak8QLzqeNIPoxDCzXRwSFoCtyc1eWAFPxd0N/KKw08zk+AFuRJf629kcf6pUz
         j/Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TIlheWExIsI3HU7mhBfBiCGwxw5Bn+6mfDQrLPyXWAI=;
        b=uZcZbfMnHmpAWcRj4rf5Hhwke5/HJqLK1VwOn8WCFIktLPOUG5xbQKrIRSVErJmW4V
         Jh3GBIWepCBjNyZgbUJ890QFtPYiVShqpP06jeT8YXDhkml8C3n2olynyD/9TJQpXh+/
         ZuMkeyLcbBLoMt6ZIRFJCuuiq492aQHX6BLZcG05ivRP8th+Pt09Ycl2FKnVBDEE8mu3
         V84HOG0sa5FGY8GW38vtUNkG9fdO2QxKo8tnN6Ew2dwTf2JMkAzYTivZgtH0crqJt5gP
         CuCiYxZSOREnpojhWQGDFiMnBZK7v/wPfA0X+aKniIybSvdbPYL8RbY+MPGWYJQIOh2/
         NuTA==
X-Gm-Message-State: AOAM532fLRNfTBWt2P5HSh/u0GC8juI13qrXa+EqFMWozOuYk7qF3/Aq
        /sb785a/Wr9XqMRP5SDcJqM=
X-Google-Smtp-Source: ABdhPJxL55xP9JnaBHttk3T1uGBhEb6frgTHfGHZvusYvtxVf5VOxVJXcgvBFCU9LR+l1KOX0gainQ==
X-Received: by 2002:a63:a552:: with SMTP id r18mr52264129pgu.288.1641475257235;
        Thu, 06 Jan 2022 05:20:57 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.9])
        by smtp.gmail.com with ESMTPSA id c11sm2777998pfv.85.2022.01.06.05.20.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 05:20:56 -0800 (PST)
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
Subject: [PATCH v5 net-next 2/3] bpf: selftests: use C99 initializers in test_sock.c
Date:   Thu,  6 Jan 2022 21:20:21 +0800
Message-Id: <20220106132022.3470772-3-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220106132022.3470772-1-imagedong@tencent.com>
References: <20220106132022.3470772-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

Use C99 initializers for the initialization of 'tests' in test_sock.c.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 tools/testing/selftests/bpf/test_sock.c | 220 ++++++++++--------------
 1 file changed, 92 insertions(+), 128 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_sock.c b/tools/testing/selftests/bpf/test_sock.c
index e8edd3dd3ec2..94f9b126f5ed 100644
--- a/tools/testing/selftests/bpf/test_sock.c
+++ b/tools/testing/selftests/bpf/test_sock.c
@@ -46,7 +46,7 @@ struct sock_test {
 
 static struct sock_test tests[] = {
 	{
-		"bind4 load with invalid access: src_ip6",
+		.descr = "bind4 load with invalid access: src_ip6",
 		.insns = {
 			BPF_MOV64_REG(BPF_REG_6, BPF_REG_1),
 			BPF_LDX_MEM(BPF_W, BPF_REG_7, BPF_REG_6,
@@ -54,16 +54,12 @@ static struct sock_test tests[] = {
 			BPF_MOV64_IMM(BPF_REG_0, 1),
 			BPF_EXIT_INSN(),
 		},
-		BPF_CGROUP_INET4_POST_BIND,
-		BPF_CGROUP_INET4_POST_BIND,
-		0,
-		0,
-		NULL,
-		0,
-		LOAD_REJECT,
+		.expected_attach_type = BPF_CGROUP_INET4_POST_BIND,
+		.attach_type = BPF_CGROUP_INET4_POST_BIND,
+		.result = LOAD_REJECT,
 	},
 	{
-		"bind4 load with invalid access: mark",
+		.descr = "bind4 load with invalid access: mark",
 		.insns = {
 			BPF_MOV64_REG(BPF_REG_6, BPF_REG_1),
 			BPF_LDX_MEM(BPF_W, BPF_REG_7, BPF_REG_6,
@@ -71,16 +67,12 @@ static struct sock_test tests[] = {
 			BPF_MOV64_IMM(BPF_REG_0, 1),
 			BPF_EXIT_INSN(),
 		},
-		BPF_CGROUP_INET4_POST_BIND,
-		BPF_CGROUP_INET4_POST_BIND,
-		0,
-		0,
-		NULL,
-		0,
-		LOAD_REJECT,
+		.expected_attach_type = BPF_CGROUP_INET4_POST_BIND,
+		.attach_type = BPF_CGROUP_INET4_POST_BIND,
+		.result = LOAD_REJECT,
 	},
 	{
-		"bind6 load with invalid access: src_ip4",
+		.descr = "bind6 load with invalid access: src_ip4",
 		.insns = {
 			BPF_MOV64_REG(BPF_REG_6, BPF_REG_1),
 			BPF_LDX_MEM(BPF_W, BPF_REG_7, BPF_REG_6,
@@ -88,16 +80,12 @@ static struct sock_test tests[] = {
 			BPF_MOV64_IMM(BPF_REG_0, 1),
 			BPF_EXIT_INSN(),
 		},
-		BPF_CGROUP_INET6_POST_BIND,
-		BPF_CGROUP_INET6_POST_BIND,
-		0,
-		0,
-		NULL,
-		0,
-		LOAD_REJECT,
+		.expected_attach_type = BPF_CGROUP_INET6_POST_BIND,
+		.attach_type = BPF_CGROUP_INET6_POST_BIND,
+		.result = LOAD_REJECT,
 	},
 	{
-		"sock_create load with invalid access: src_port",
+		.descr = "sock_create load with invalid access: src_port",
 		.insns = {
 			BPF_MOV64_REG(BPF_REG_6, BPF_REG_1),
 			BPF_LDX_MEM(BPF_W, BPF_REG_7, BPF_REG_6,
@@ -105,128 +93,106 @@ static struct sock_test tests[] = {
 			BPF_MOV64_IMM(BPF_REG_0, 1),
 			BPF_EXIT_INSN(),
 		},
-		BPF_CGROUP_INET_SOCK_CREATE,
-		BPF_CGROUP_INET_SOCK_CREATE,
-		0,
-		0,
-		NULL,
-		0,
-		LOAD_REJECT,
+		.expected_attach_type = BPF_CGROUP_INET_SOCK_CREATE,
+		.attach_type = BPF_CGROUP_INET_SOCK_CREATE,
+		.result = LOAD_REJECT,
 	},
 	{
-		"sock_create load w/o expected_attach_type (compat mode)",
+		.descr = "sock_create load w/o expected_attach_type (compat mode)",
 		.insns = {
 			BPF_MOV64_IMM(BPF_REG_0, 1),
 			BPF_EXIT_INSN(),
 		},
-		0,
-		BPF_CGROUP_INET_SOCK_CREATE,
-		AF_INET,
-		SOCK_STREAM,
-		"127.0.0.1",
-		8097,
-		SUCCESS,
+		.expected_attach_type = 0,
+		.attach_type = BPF_CGROUP_INET_SOCK_CREATE,
+		.domain = AF_INET,
+		.type = SOCK_STREAM,
+		.ip = "127.0.0.1",
+		.port = 8097,
+		.result = SUCCESS,
 	},
 	{
-		"sock_create load w/ expected_attach_type",
+		.descr = "sock_create load w/ expected_attach_type",
 		.insns = {
 			BPF_MOV64_IMM(BPF_REG_0, 1),
 			BPF_EXIT_INSN(),
 		},
-		BPF_CGROUP_INET_SOCK_CREATE,
-		BPF_CGROUP_INET_SOCK_CREATE,
-		AF_INET,
-		SOCK_STREAM,
-		"127.0.0.1",
-		8097,
-		SUCCESS,
+		.expected_attach_type = BPF_CGROUP_INET_SOCK_CREATE,
+		.attach_type = BPF_CGROUP_INET_SOCK_CREATE,
+		.domain = AF_INET,
+		.type = SOCK_STREAM,
+		.ip = "127.0.0.1",
+		.port = 8097,
+		.result = SUCCESS,
 	},
 	{
-		"attach type mismatch bind4 vs bind6",
+		.descr = "attach type mismatch bind4 vs bind6",
 		.insns = {
 			BPF_MOV64_IMM(BPF_REG_0, 1),
 			BPF_EXIT_INSN(),
 		},
-		BPF_CGROUP_INET4_POST_BIND,
-		BPF_CGROUP_INET6_POST_BIND,
-		0,
-		0,
-		NULL,
-		0,
-		ATTACH_REJECT,
+		.expected_attach_type = BPF_CGROUP_INET4_POST_BIND,
+		.attach_type = BPF_CGROUP_INET6_POST_BIND,
+		.result = ATTACH_REJECT,
 	},
 	{
-		"attach type mismatch bind6 vs bind4",
+		.descr = "attach type mismatch bind6 vs bind4",
 		.insns = {
 			BPF_MOV64_IMM(BPF_REG_0, 1),
 			BPF_EXIT_INSN(),
 		},
-		BPF_CGROUP_INET6_POST_BIND,
-		BPF_CGROUP_INET4_POST_BIND,
-		0,
-		0,
-		NULL,
-		0,
-		ATTACH_REJECT,
+		.expected_attach_type = BPF_CGROUP_INET6_POST_BIND,
+		.attach_type = BPF_CGROUP_INET4_POST_BIND,
+		.result = ATTACH_REJECT,
 	},
 	{
-		"attach type mismatch default vs bind4",
+		.descr = "attach type mismatch default vs bind4",
 		.insns = {
 			BPF_MOV64_IMM(BPF_REG_0, 1),
 			BPF_EXIT_INSN(),
 		},
-		0,
-		BPF_CGROUP_INET4_POST_BIND,
-		0,
-		0,
-		NULL,
-		0,
-		ATTACH_REJECT,
+		.expected_attach_type = 0,
+		.attach_type = BPF_CGROUP_INET4_POST_BIND,
+		.result = ATTACH_REJECT,
 	},
 	{
-		"attach type mismatch bind6 vs sock_create",
+		.descr = "attach type mismatch bind6 vs sock_create",
 		.insns = {
 			BPF_MOV64_IMM(BPF_REG_0, 1),
 			BPF_EXIT_INSN(),
 		},
-		BPF_CGROUP_INET6_POST_BIND,
-		BPF_CGROUP_INET_SOCK_CREATE,
-		0,
-		0,
-		NULL,
-		0,
-		ATTACH_REJECT,
+		.expected_attach_type = BPF_CGROUP_INET6_POST_BIND,
+		.attach_type = BPF_CGROUP_INET_SOCK_CREATE,
+		.result = ATTACH_REJECT,
 	},
 	{
-		"bind4 reject all",
+		.descr = "bind4 reject all",
 		.insns = {
 			BPF_MOV64_IMM(BPF_REG_0, 0),
 			BPF_EXIT_INSN(),
 		},
-		BPF_CGROUP_INET4_POST_BIND,
-		BPF_CGROUP_INET4_POST_BIND,
-		AF_INET,
-		SOCK_STREAM,
-		"0.0.0.0",
-		0,
-		BIND_REJECT,
+		.expected_attach_type = BPF_CGROUP_INET4_POST_BIND,
+		.attach_type = BPF_CGROUP_INET4_POST_BIND,
+		.domain = AF_INET,
+		.type = SOCK_STREAM,
+		.ip = "0.0.0.0",
+		.result = BIND_REJECT,
 	},
 	{
-		"bind6 reject all",
+		.descr = "bind6 reject all",
 		.insns = {
 			BPF_MOV64_IMM(BPF_REG_0, 0),
 			BPF_EXIT_INSN(),
 		},
-		BPF_CGROUP_INET6_POST_BIND,
-		BPF_CGROUP_INET6_POST_BIND,
-		AF_INET6,
-		SOCK_STREAM,
-		"::",
-		0,
-		BIND_REJECT,
+		.expected_attach_type = BPF_CGROUP_INET6_POST_BIND,
+		.attach_type = BPF_CGROUP_INET6_POST_BIND,
+		.domain = AF_INET6,
+		.type = SOCK_STREAM,
+		.ip = "::",
+		.result = BIND_REJECT,
 	},
 	{
-		"bind6 deny specific IP & port",
+		.descr = "bind6 deny specific IP & port",
 		.insns = {
 			BPF_MOV64_REG(BPF_REG_6, BPF_REG_1),
 
@@ -247,16 +213,16 @@ static struct sock_test tests[] = {
 			BPF_MOV64_IMM(BPF_REG_0, 1),
 			BPF_EXIT_INSN(),
 		},
-		BPF_CGROUP_INET6_POST_BIND,
-		BPF_CGROUP_INET6_POST_BIND,
-		AF_INET6,
-		SOCK_STREAM,
-		"::1",
-		8193,
-		BIND_REJECT,
+		.expected_attach_type = BPF_CGROUP_INET6_POST_BIND,
+		.attach_type = BPF_CGROUP_INET6_POST_BIND,
+		.domain = AF_INET6,
+		.type = SOCK_STREAM,
+		.ip = "::1",
+		.port = 8193,
+		.result = BIND_REJECT,
 	},
 	{
-		"bind4 allow specific IP & port",
+		.descr = "bind4 allow specific IP & port",
 		.insns = {
 			BPF_MOV64_REG(BPF_REG_6, BPF_REG_1),
 
@@ -277,41 +243,39 @@ static struct sock_test tests[] = {
 			BPF_MOV64_IMM(BPF_REG_0, 0),
 			BPF_EXIT_INSN(),
 		},
-		BPF_CGROUP_INET4_POST_BIND,
-		BPF_CGROUP_INET4_POST_BIND,
-		AF_INET,
-		SOCK_STREAM,
-		"127.0.0.1",
-		4098,
-		SUCCESS,
+		.expected_attach_type = BPF_CGROUP_INET4_POST_BIND,
+		.attach_type = BPF_CGROUP_INET4_POST_BIND,
+		.domain = AF_INET,
+		.type = SOCK_STREAM,
+		.ip = "127.0.0.1",
+		.port = 4098,
+		.result = SUCCESS,
 	},
 	{
-		"bind4 allow all",
+		.descr = "bind4 allow all",
 		.insns = {
 			BPF_MOV64_IMM(BPF_REG_0, 1),
 			BPF_EXIT_INSN(),
 		},
-		BPF_CGROUP_INET4_POST_BIND,
-		BPF_CGROUP_INET4_POST_BIND,
-		AF_INET,
-		SOCK_STREAM,
-		"0.0.0.0",
-		0,
-		SUCCESS,
+		.expected_attach_type = BPF_CGROUP_INET4_POST_BIND,
+		.attach_type = BPF_CGROUP_INET4_POST_BIND,
+		.domain = AF_INET,
+		.type = SOCK_STREAM,
+		.ip = "0.0.0.0",
+		.result = SUCCESS,
 	},
 	{
-		"bind6 allow all",
+		.descr = "bind6 allow all",
 		.insns = {
 			BPF_MOV64_IMM(BPF_REG_0, 1),
 			BPF_EXIT_INSN(),
 		},
-		BPF_CGROUP_INET6_POST_BIND,
-		BPF_CGROUP_INET6_POST_BIND,
-		AF_INET6,
-		SOCK_STREAM,
-		"::",
-		0,
-		SUCCESS,
+		.expected_attach_type = BPF_CGROUP_INET6_POST_BIND,
+		.attach_type = BPF_CGROUP_INET6_POST_BIND,
+		.domain = AF_INET6,
+		.type = SOCK_STREAM,
+		.ip = "::",
+		.result = SUCCESS,
 	},
 };
 
-- 
2.30.2

