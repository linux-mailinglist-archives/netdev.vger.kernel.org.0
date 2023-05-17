Return-Path: <netdev+bounces-3204-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C2F3D705F55
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 07:28:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BC04A1C20E8C
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 05:28:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7222611181;
	Wed, 17 May 2023 05:23:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B2E10962;
	Wed, 17 May 2023 05:23:19 +0000 (UTC)
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BF9340C0;
	Tue, 16 May 2023 22:23:11 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 41be03b00d2f7-52c30fa5271so145836a12.0;
        Tue, 16 May 2023 22:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684300990; x=1686892990;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BJKVFV10Wskzd6UgwZOel3wsQif2pwvMqBZ8BBnsjqM=;
        b=dtU52kCpBoaGzd6sHE3ViPe409KnwWhWsI4OvILkD8HSUuFcotZMhghV2ie8qDEvvw
         H191c32E6HMTKOjLZFC8ynxmdlAn7myWSjoJojMY3/MFFvK4xLs6F68p+GCIW+xES32y
         133wpkJZZi4mWN/KcEpOibGtg6ftXh4UCPIo6Ni1yWExwz5oNORfz6MxYrl76DTPZVjV
         IG1dHJpX6HO6T1i8GaM4lRsuOHKqZKxycmE6Te0fQIzO2V/3ZFSqoRZpwR6Oj+ZuttiA
         /EWWdZPI0bMk06jUxLkicu9pVpXzBWCIy24OyFsPwXkQlSyRx6xa2jIRyLw08VyME9xY
         c8JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684300990; x=1686892990;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BJKVFV10Wskzd6UgwZOel3wsQif2pwvMqBZ8BBnsjqM=;
        b=hKmdM4D8npRjfihF0kzykR40uqop9hjptzIZ3qZpcXrJ2W4tiKQcXG7FNByfuFD2p5
         pLHi/15oHh4sQ5oykbJMniNdqmNNp7Xln3KckQWVsSeKMEjv0vnGY7DMnHKmLkPK8koI
         QdvhFETenX7DadoIAUciRkaE0szGtdQQi94d8qxbkHpnjseC6rw4AaQjusqnk9SiC66+
         CiZMk8fR6GuFeNaCUFDHTvJXs0Sd7fAu0yUPDAfqa2eqTMR6pTv0XYCxUSrn1PHmZrKM
         jfGv2TIGGJq9LGR1tSJv46hz3dji4ZC1iXMByGstt2CLQFvAIAa87zu0n1S7yKW7Xyh8
         7GTw==
X-Gm-Message-State: AC+VfDzDiGhIOMdzofdr608kB1OP2l+XoQhbSmB6R1FQ9aZX0eIHi2lB
	x6TIauZOGaP2B9WP+Qfu+uo=
X-Google-Smtp-Source: ACHHUZ7mpqF014ghYwAe/9SoN1iZQNDj/2u6jlECXTmuTSpaTTAb+XVnWiDCwhgp8u7IUdOipEEUzQ==
X-Received: by 2002:a05:6a20:938f:b0:102:a593:a165 with SMTP id x15-20020a056a20938f00b00102a593a165mr33557286pzh.27.1684300990641;
        Tue, 16 May 2023 22:23:10 -0700 (PDT)
Received: from john.lan ([98.97.37.198])
        by smtp.gmail.com with ESMTPSA id n11-20020a17090a2fcb00b0023cfdbb6496sm581779pjm.1.2023.05.16.22.23.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 22:23:09 -0700 (PDT)
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
Subject: [PATCH bpf v8 12/13] bpf: sockmap, test FIONREAD returns correct bytes in rx buffer
Date: Tue, 16 May 2023 22:22:43 -0700
Message-Id: <20230517052244.294755-13-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230517052244.294755-1-john.fastabend@gmail.com>
References: <20230517052244.294755-1-john.fastabend@gmail.com>
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


