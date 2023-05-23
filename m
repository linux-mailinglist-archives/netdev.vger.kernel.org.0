Return-Path: <netdev+bounces-4501-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BE3970D21E
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 05:02:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0C1B81C20CA0
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 03:02:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E4C817AD8;
	Tue, 23 May 2023 02:56:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E4D417AAF;
	Tue, 23 May 2023 02:56:44 +0000 (UTC)
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5232120;
	Mon, 22 May 2023 19:56:41 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1ae85b71141so36220125ad.0;
        Mon, 22 May 2023 19:56:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684810601; x=1687402601;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BJKVFV10Wskzd6UgwZOel3wsQif2pwvMqBZ8BBnsjqM=;
        b=TGiMWH8oOjGdaGxXWdTktUofbsjfQA9dvJpZlTDqU9knz/nWodCkyGjHw40QjG+A5T
         m3lfGyyT86C4o233T+tFuQHDmpcvjP7DYo79ckwX/7KpN5tL1IW2Pi1iRczhqURlvdFt
         /Cjh4+HI4XmXmyealPrDz2U4wY2kpDGTtTkWjCEhsNY66oyC1jeT/PqpZfeTBUfSrf9d
         5KC/Rw3W33f2yUfO7R6oLRNiUJKgQHe1FVXb/bJFnlUkhV1cxA8g5EtXy6TY3EcDNnZ/
         3MhW9CVudkUBGu4XLRNHB/oQPIHebFvs/8UJixjoj4cZ0ebJjpPLtWFoeFAKAL2vC9lt
         WFJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684810601; x=1687402601;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BJKVFV10Wskzd6UgwZOel3wsQif2pwvMqBZ8BBnsjqM=;
        b=DOGH7an81wa1kdpAaDadKK3XybAxvdi/fjK2CDC3usuHGlHkygOZQYP4hxClPFRQy5
         lrVLcU+/vwebSYWzX4X7eq/ryHi+0cAPoxG5+hyrJpv6BcFOwV76LxykmV23uOrr8kmF
         TuKloNzIVal4bqcTKYVu9MjvooCIhP+sFuQKlRCHk7jUdXcyFroUJwpGUCi2cHB/sQz0
         OdMFOfjpNYt95Olyz0zqFCXj1uz1Jj4QKJekoLr4aWAXsRTl/fyJmdINImoL8fg23kYn
         MnPKxWWsCvKUmk7amFehy1Ow1LzVKp/70X0FogAdWOb5k/s3dCOVgv0RkU+q9S8p7OQP
         g/cQ==
X-Gm-Message-State: AC+VfDx73AzC9F24Hrj3dd/hxOc+VdUVqr1/iL0npEmf7/qWDK+zh9S6
	u+KUrAdhc3DrrOI8PHQhEGk=
X-Google-Smtp-Source: ACHHUZ5MUayufWANFEFDxs67/6lBqVLCAlx7vwnDiIet1czscqdlStTaVlGiB12EJ7I9/KVmTRLSHw==
X-Received: by 2002:a17:902:680d:b0:1a5:5e7:a1cc with SMTP id h13-20020a170902680d00b001a505e7a1ccmr10002855plk.58.1684810601251;
        Mon, 22 May 2023 19:56:41 -0700 (PDT)
Received: from john.lan ([2605:59c8:148:ba10:82a6:5b19:9c99:3aad])
        by smtp.gmail.com with ESMTPSA id h10-20020a170902748a00b001a67759f9f8sm5508285pll.106.2023.05.22.19.56.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 19:56:40 -0700 (PDT)
From: John Fastabend <john.fastabend@gmail.com>
To: jakub@cloudflare.com,
	daniel@iogearbox.net
Cc: john.fastabend@gmail.com,
	bpf@vger.kernel.org,
	netdev@vger.kernel.org,
	edumazet@google.com,
	ast@kernel.org,
	andrii@kernel.org,
	will@isovalent.com
Subject: [PATCH bpf v10 12/14] bpf: sockmap, test FIONREAD returns correct bytes in rx buffer
Date: Mon, 22 May 2023 19:56:16 -0700
Message-Id: <20230523025618.113937-13-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230523025618.113937-1-john.fastabend@gmail.com>
References: <20230523025618.113937-1-john.fastabend@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

A bug was reported where ioctl(FIONREAD) returned zero even though the
socket with a SK_SKB verdict program attached had bytes in the msg
queue. The result is programs may hang or more likely try to recover,
but use suboptimal buffer sizes.

Add a test to check that ioctl(FIONREAD) returns the correct number of
bytes.

Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 .../selftests/bpf/prog_tests/sockmap_basic.c  | 48 +++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
index 615a8164c8f0..fe56049f6568 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
@@ -410,6 +410,52 @@ static void test_sockmap_skb_verdict_shutdown(void)
 	test_sockmap_pass_prog__destroy(skel);
 }
 
+static void test_sockmap_skb_verdict_fionread(void)
+{
+	int err, map, verdict, s, c0, c1, p0, p1;
+	struct test_sockmap_pass_prog *skel;
+	int zero = 0, sent, recvd, avail;
+	char buf[256] = "0123456789";
+
+	skel = test_sockmap_pass_prog__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "open_and_load"))
+		return;
+
+	verdict = bpf_program__fd(skel->progs.prog_skb_verdict);
+	map = bpf_map__fd(skel->maps.sock_map_rx);
+
+	err = bpf_prog_attach(verdict, map, BPF_SK_SKB_STREAM_VERDICT, 0);
+	if (!ASSERT_OK(err, "bpf_prog_attach"))
+		goto out;
+
+	s = socket_loopback(AF_INET, SOCK_STREAM);
+	if (!ASSERT_GT(s, -1, "socket_loopback(s)"))
+		goto out;
+	err = create_socket_pairs(s, AF_INET, SOCK_STREAM, &c0, &c1, &p0, &p1);
+	if (!ASSERT_OK(err, "create_socket_pairs(s)"))
+		goto out;
+
+	err = bpf_map_update_elem(map, &zero, &c1, BPF_NOEXIST);
+	if (!ASSERT_OK(err, "bpf_map_update_elem(c1)"))
+		goto out_close;
+
+	sent = xsend(p1, &buf, sizeof(buf), 0);
+	ASSERT_EQ(sent, sizeof(buf), "xsend(p0)");
+	err = ioctl(c1, FIONREAD, &avail);
+	ASSERT_OK(err, "ioctl(FIONREAD) error");
+	ASSERT_EQ(avail, sizeof(buf), "ioctl(FIONREAD)");
+	recvd = recv_timeout(c1, &buf, sizeof(buf), SOCK_NONBLOCK, IO_TIMEOUT_SEC);
+	ASSERT_EQ(recvd, sizeof(buf), "recv_timeout(c0)");
+
+out_close:
+	close(c0);
+	close(p0);
+	close(c1);
+	close(p1);
+out:
+	test_sockmap_pass_prog__destroy(skel);
+}
+
 void test_sockmap_basic(void)
 {
 	if (test__start_subtest("sockmap create_update_free"))
@@ -446,4 +492,6 @@ void test_sockmap_basic(void)
 		test_sockmap_progs_query(BPF_SK_SKB_VERDICT);
 	if (test__start_subtest("sockmap skb_verdict shutdown"))
 		test_sockmap_skb_verdict_shutdown();
+	if (test__start_subtest("sockmap skb_verdict fionread"))
+		test_sockmap_skb_verdict_fionread();
 }
-- 
2.33.0


