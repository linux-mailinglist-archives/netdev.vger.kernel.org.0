Return-Path: <netdev+bounces-3203-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EBD8705F50
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 07:28:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6817D1C20E76
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 05:28:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D15AA10964;
	Wed, 17 May 2023 05:23:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C558310962;
	Wed, 17 May 2023 05:23:18 +0000 (UTC)
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D61E40DF;
	Tue, 16 May 2023 22:23:09 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1aaf21bb42bso3243625ad.2;
        Tue, 16 May 2023 22:23:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684300989; x=1686892989;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kLga20o0ypa3YZ6F5VBKmdyV1GP+jP4eW2M1n6l95P8=;
        b=fRLg58MRNnyWoRLuV4giuh+LjjNYg9+YonTVCPP8f6LGQFEudwGW4XmCEFsGak9fA8
         k+7oxpDYyOrrXxNCt35fXpktXlZiM9Ra0UoYo8nfxAukl76Okx+875OSIJuNYcieGUzu
         RDGjP4i7FVYMQeVNJDOmT3WekW99+5jYLfedjUPwyfWETVKd2AK/D24T6YXGRNrln9jR
         +BeKZ8Uj3hULOeHSZ+tw1aIp7Y1Zn/jNQDr+biNADP+S+N2O+3ECKrmSbEFa29QJ2RK3
         1yzyL33vCUnmAoJXx38gHPtKrhzITkWmr3vqma7ri3cJl9qNUlIjVIqQSg71jW51YnsX
         7N4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684300989; x=1686892989;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kLga20o0ypa3YZ6F5VBKmdyV1GP+jP4eW2M1n6l95P8=;
        b=FFB7kHU5kv5iDepm+nN9FWqCp4K8DSnK1JfUWBmqKf6wV416Lrjm/67Yr0M5gMAmwF
         bf7Dj/8Aoeo262XdRJMmx1Rtr84XoH8U1LcWdILLw0sHzuzdk48PTMEskJTeMnBWrw4f
         wWFL8bJiCCN33BY1p1Txu884ng1WwReMuR0g9WNl5jNgwPxlUA08A8WC+xzgSLcDpiUG
         vSwTPRh86Iko0pV8yqn8zyomMMjtVZUegw6CDv7taTs8QAhbVp2O/NYpTghMJ4jjJae2
         8ddzMKvUAHdcXuNsEIUrpS5XPDbhP8O2vG4KB3awOXgNjGBMk48Af4b39/3eeN1Pkd2H
         Dp/A==
X-Gm-Message-State: AC+VfDwtAV7rZMt9TRGiG4u7pRehkVPATl+6AlxO7JWo4X24tLPpbvtv
	b2odk1jy5zR/JfnPe/YvZ+A=
X-Google-Smtp-Source: ACHHUZ5b2oHuUS86sIhShQ9epkTfhJEIRUH9MSjG4uLxVwWQU2fwvz7zLiVGI9eoECpf+8/0uF/FPA==
X-Received: by 2002:a17:902:d50c:b0:1ae:1659:bfe2 with SMTP id b12-20020a170902d50c00b001ae1659bfe2mr11619827plg.34.1684300988849;
        Tue, 16 May 2023 22:23:08 -0700 (PDT)
Received: from john.lan ([98.97.37.198])
        by smtp.gmail.com with ESMTPSA id n11-20020a17090a2fcb00b0023cfdbb6496sm581779pjm.1.2023.05.16.22.23.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 22:23:08 -0700 (PDT)
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
Subject: [PATCH bpf v8 11/13] bpf: sockmap, test shutdown() correctly exits epoll and recv()=0
Date: Tue, 16 May 2023 22:22:42 -0700
Message-Id: <20230517052244.294755-12-john.fastabend@gmail.com>
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
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

When session gracefully shutdowns epoll needs to wake up and any recv()
readers should return 0 not the -EAGAIN they previously returned.

Note we use epoll instead of select to test the epoll wake on shutdown
event as well.

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 .../selftests/bpf/prog_tests/sockmap_basic.c  | 62 +++++++++++++++++++
 .../bpf/progs/test_sockmap_pass_prog.c        | 32 ++++++++++
 2 files changed, 94 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_pass_prog.c

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
index 0ce25a967481..615a8164c8f0 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
@@ -2,6 +2,7 @@
 // Copyright (c) 2020 Cloudflare
 #include <error.h>
 #include <netinet/tcp.h>
+#include <sys/epoll.h>
 
 #include "test_progs.h"
 #include "test_skmsg_load_helpers.skel.h"
@@ -9,8 +10,11 @@
 #include "test_sockmap_invalid_update.skel.h"
 #include "test_sockmap_skb_verdict_attach.skel.h"
 #include "test_sockmap_progs_query.skel.h"
+#include "test_sockmap_pass_prog.skel.h"
 #include "bpf_iter_sockmap.skel.h"
 
+#include "sockmap_helpers.h"
+
 #define TCP_REPAIR		19	/* TCP sock is under repair right now */
 
 #define TCP_REPAIR_ON		1
@@ -350,6 +354,62 @@ static void test_sockmap_progs_query(enum bpf_attach_type attach_type)
 	test_sockmap_progs_query__destroy(skel);
 }
 
+#define MAX_EVENTS 10
+static void test_sockmap_skb_verdict_shutdown(void)
+{
+	struct epoll_event ev, events[MAX_EVENTS];
+	int n, err, map, verdict, s, c1, p1;
+	struct test_sockmap_pass_prog *skel;
+	int epollfd;
+	int zero = 0;
+	char b;
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
+	if (s < 0)
+		goto out;
+	err = create_pair(s, AF_INET, SOCK_STREAM, &c1, &p1);
+	if (err < 0)
+		goto out;
+
+	err = bpf_map_update_elem(map, &zero, &c1, BPF_NOEXIST);
+	if (err < 0)
+		goto out_close;
+
+	shutdown(p1, SHUT_WR);
+
+	ev.events = EPOLLIN;
+	ev.data.fd = c1;
+
+	epollfd = epoll_create1(0);
+	if (!ASSERT_GT(epollfd, -1, "epoll_create(0)"))
+		goto out_close;
+	err = epoll_ctl(epollfd, EPOLL_CTL_ADD, c1, &ev);
+	if (!ASSERT_OK(err, "epoll_ctl(EPOLL_CTL_ADD)"))
+		goto out_close;
+	err = epoll_wait(epollfd, events, MAX_EVENTS, -1);
+	if (!ASSERT_EQ(err, 1, "epoll_wait(fd)"))
+		goto out_close;
+
+	n = recv(c1, &b, 1, SOCK_NONBLOCK);
+	ASSERT_EQ(n, 0, "recv_timeout(fin)");
+out_close:
+	close(c1);
+	close(p1);
+out:
+	test_sockmap_pass_prog__destroy(skel);
+}
+
 void test_sockmap_basic(void)
 {
 	if (test__start_subtest("sockmap create_update_free"))
@@ -384,4 +444,6 @@ void test_sockmap_basic(void)
 		test_sockmap_progs_query(BPF_SK_SKB_STREAM_VERDICT);
 	if (test__start_subtest("sockmap skb_verdict progs query"))
 		test_sockmap_progs_query(BPF_SK_SKB_VERDICT);
+	if (test__start_subtest("sockmap skb_verdict shutdown"))
+		test_sockmap_skb_verdict_shutdown();
 }
diff --git a/tools/testing/selftests/bpf/progs/test_sockmap_pass_prog.c b/tools/testing/selftests/bpf/progs/test_sockmap_pass_prog.c
new file mode 100644
index 000000000000..1d86a717a290
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_sockmap_pass_prog.c
@@ -0,0 +1,32 @@
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
+
+struct {
+	__uint(type, BPF_MAP_TYPE_SOCKMAP);
+	__uint(max_entries, 20);
+	__type(key, int);
+	__type(value, int);
+} sock_map_rx SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_SOCKMAP);
+	__uint(max_entries, 20);
+	__type(key, int);
+	__type(value, int);
+} sock_map_tx SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_SOCKMAP);
+	__uint(max_entries, 20);
+	__type(key, int);
+	__type(value, int);
+} sock_map_msg SEC(".maps");
+
+SEC("sk_skb")
+int prog_skb_verdict(struct __sk_buff *skb)
+{
+	return SK_PASS;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.33.0


