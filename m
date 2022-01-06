Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1105485E53
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 02:58:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344561AbiAFB6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 20:58:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344518AbiAFB56 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 20:57:58 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96403C061245;
        Wed,  5 Jan 2022 17:57:58 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id q14so1451787plx.4;
        Wed, 05 Jan 2022 17:57:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EDiwLfl33t3eIEe2RIAMhmqwazpn93cyKzjwy0cp3Eg=;
        b=QLarUZZUFNCMKc4gLUqcyWzHSwf1pGNw7TAnSaaBEW/0MD3cSQwsNyc5xUhI2M+iI2
         bJljBNgyg3Zo0Tm06PVpyr1U2XY/M03zPDNNFsgKxvX5q+d/g0qc+HV6sWZ73fqA2UmF
         7aVnjM+arAbBji7cKF1og5u0I0uxOejX4NidehfvJi3hEv2uIsn0/iUMs5vZzf9YNvY4
         xyccTfiavMohL4M6R52/hO8bCJ4e4kKvHdHDrSWzNyAWINLQKCKLZf9Ac3LhhNXhLq7X
         a9BSsW+jC1ydRGAyGV+3SIanE6/XWnQk3BJbFfdy61P52xm1m/kvqS3dQMaOKDjFPb5z
         CsWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EDiwLfl33t3eIEe2RIAMhmqwazpn93cyKzjwy0cp3Eg=;
        b=RXHI9+dcX79ePIph6ysNQyq98hIDUIufRkjw5lLpenWHg/ldyNRaEglQqWLCdg8sjQ
         NwqH0O96BYoikKg8hLvvaHgsI3hynjd5ldhGkmZ3asGSEuZ+5QXrinWmYJo7NrOBRV5k
         tKTlWsG88mLDjT3ISuvkRo1Sb4RHG2khorNbml1nQUnaXPJbBuQ5TUFzCDRrQPsAph5M
         I7uE4C8GrqQvngkwrpD952FO65r/b0mtlQaxGJLFqJBNRhnpkIO9lApmH8grMQHhmEGH
         /llv3eA2Wurk1NrT+wGmEQAYYxrAbOYkrujIGttUfN1xkCa+qmWIa7Hvr2zcwMKp2/a3
         rS9w==
X-Gm-Message-State: AOAM5328rZG4rl3Ef25wWt62xNwY2fPLZgOQw7zZ7Q7XIlCnEjRiMO3j
        u+4VYw42rNy5TOfYVTqEB44=
X-Google-Smtp-Source: ABdhPJxCy5b4EVE/xXYqTs37a+QAUl8exJ46XAOTygbStsgUv1tNcaMoOMipdKXq83OZZ5vhg1A7hA==
X-Received: by 2002:a17:90b:1d8b:: with SMTP id pf11mr1139584pjb.119.1641434278191;
        Wed, 05 Jan 2022 17:57:58 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.9])
        by smtp.gmail.com with ESMTPSA id g21sm330910pfc.75.2022.01.05.17.57.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 17:57:57 -0800 (PST)
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
Subject: [PATCH v4 net-next 3/3] bpf: selftests: use C99 initializers in test_sock.c
Date:   Thu,  6 Jan 2022 09:57:21 +0800
Message-Id: <20220106015721.3038819-4-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220106015721.3038819-1-imagedong@tencent.com>
References: <20220106015721.3038819-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

Use C99 initializers for the initialization of 'tests' in test_sock.c.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 tools/testing/selftests/bpf/test_sock.c | 290 ++++++++++--------------
 1 file changed, 119 insertions(+), 171 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_sock.c b/tools/testing/selftests/bpf/test_sock.c
index 68525d68d4e5..fe10f8134278 100644
--- a/tools/testing/selftests/bpf/test_sock.c
+++ b/tools/testing/selftests/bpf/test_sock.c
@@ -49,7 +49,7 @@ struct sock_test {
 
 static struct sock_test tests[] = {
 	{
-		"bind4 load with invalid access: src_ip6",
+		.descr = "bind4 load with invalid access: src_ip6",
 		.insns = {
 			BPF_MOV64_REG(BPF_REG_6, BPF_REG_1),
 			BPF_LDX_MEM(BPF_W, BPF_REG_7, BPF_REG_6,
@@ -57,17 +57,12 @@ static struct sock_test tests[] = {
 			BPF_MOV64_IMM(BPF_REG_0, 1),
 			BPF_EXIT_INSN(),
 		},
-		BPF_CGROUP_INET4_POST_BIND,
-		BPF_CGROUP_INET4_POST_BIND,
-		0,
-		0,
-		NULL,
-		0,
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
@@ -75,17 +70,12 @@ static struct sock_test tests[] = {
 			BPF_MOV64_IMM(BPF_REG_0, 1),
 			BPF_EXIT_INSN(),
 		},
-		BPF_CGROUP_INET4_POST_BIND,
-		BPF_CGROUP_INET4_POST_BIND,
-		0,
-		0,
-		NULL,
-		0,
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
@@ -93,17 +83,12 @@ static struct sock_test tests[] = {
 			BPF_MOV64_IMM(BPF_REG_0, 1),
 			BPF_EXIT_INSN(),
 		},
-		BPF_CGROUP_INET6_POST_BIND,
-		BPF_CGROUP_INET6_POST_BIND,
-		0,
-		0,
-		NULL,
-		0,
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
@@ -111,137 +96,106 @@ static struct sock_test tests[] = {
 			BPF_MOV64_IMM(BPF_REG_0, 1),
 			BPF_EXIT_INSN(),
 		},
-		BPF_CGROUP_INET_SOCK_CREATE,
-		BPF_CGROUP_INET_SOCK_CREATE,
-		0,
-		0,
-		NULL,
-		0,
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
-		0,
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
-		0,
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
 
@@ -262,17 +216,16 @@ static struct sock_test tests[] = {
 			BPF_MOV64_IMM(BPF_REG_0, 1),
 			BPF_EXIT_INSN(),
 		},
-		BPF_CGROUP_INET6_POST_BIND,
-		BPF_CGROUP_INET6_POST_BIND,
-		AF_INET6,
-		SOCK_STREAM,
-		"::1",
-		8193,
-		0,
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
 
@@ -293,17 +246,16 @@ static struct sock_test tests[] = {
 			BPF_MOV64_IMM(BPF_REG_0, 0),
 			BPF_EXIT_INSN(),
 		},
-		BPF_CGROUP_INET4_POST_BIND,
-		BPF_CGROUP_INET4_POST_BIND,
-		AF_INET,
-		SOCK_STREAM,
-		"127.0.0.1",
-		4098,
-		0,
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
-		"bind4 deny specific IP & port of TCP, and retry",
+		.descr = "bind4 deny specific IP & port of TCP, and retry",
 		.insns = {
 			BPF_MOV64_REG(BPF_REG_6, BPF_REG_1),
 
@@ -324,17 +276,17 @@ static struct sock_test tests[] = {
 			BPF_MOV64_IMM(BPF_REG_0, 1),
 			BPF_EXIT_INSN(),
 		},
-		BPF_CGROUP_INET4_POST_BIND,
-		BPF_CGROUP_INET4_POST_BIND,
-		AF_INET,
-		SOCK_STREAM,
-		"127.0.0.1",
-		4098,
-		5000,
-		RETRY_SUCCESS,
+		.expected_attach_type = BPF_CGROUP_INET4_POST_BIND,
+		.attach_type = BPF_CGROUP_INET4_POST_BIND,
+		.domain = AF_INET,
+		.type = SOCK_STREAM,
+		.ip = "127.0.0.1",
+		.port = 4098,
+		.port_retry = 5000,
+		.result = RETRY_SUCCESS,
 	},
 	{
-		"bind4 deny specific IP & port of UDP, and retry",
+		.descr = "bind4 deny specific IP & port of UDP, and retry",
 		.insns = {
 			BPF_MOV64_REG(BPF_REG_6, BPF_REG_1),
 
@@ -355,17 +307,17 @@ static struct sock_test tests[] = {
 			BPF_MOV64_IMM(BPF_REG_0, 1),
 			BPF_EXIT_INSN(),
 		},
-		BPF_CGROUP_INET4_POST_BIND,
-		BPF_CGROUP_INET4_POST_BIND,
-		AF_INET,
-		SOCK_DGRAM,
-		"127.0.0.1",
-		4098,
-		5000,
-		RETRY_SUCCESS,
+		.expected_attach_type = BPF_CGROUP_INET4_POST_BIND,
+		.attach_type = BPF_CGROUP_INET4_POST_BIND,
+		.domain = AF_INET,
+		.type = SOCK_DGRAM,
+		.ip = "127.0.0.1",
+		.port = 4098,
+		.port_retry = 5000,
+		.result = RETRY_SUCCESS,
 	},
 	{
-		"bind6 deny specific IP & port, and retry",
+		.descr = "bind6 deny specific IP & port, and retry",
 		.insns = {
 			BPF_MOV64_REG(BPF_REG_6, BPF_REG_1),
 
@@ -386,44 +338,40 @@ static struct sock_test tests[] = {
 			BPF_MOV64_IMM(BPF_REG_0, 1),
 			BPF_EXIT_INSN(),
 		},
-		BPF_CGROUP_INET6_POST_BIND,
-		BPF_CGROUP_INET6_POST_BIND,
-		AF_INET6,
-		SOCK_STREAM,
-		"::1",
-		8193,
-		9000,
-		RETRY_SUCCESS,
+		.expected_attach_type = BPF_CGROUP_INET6_POST_BIND,
+		.attach_type = BPF_CGROUP_INET6_POST_BIND,
+		.domain = AF_INET6,
+		.type = SOCK_STREAM,
+		.ip = "::1",
+		.port = 8193,
+		.port_retry = 9000,
+		.result = RETRY_SUCCESS,
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

