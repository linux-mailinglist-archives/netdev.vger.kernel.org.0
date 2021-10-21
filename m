Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F3FB436074
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 13:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbhJULoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 07:44:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26119 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229765AbhJULoD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 07:44:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634816507;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4VzWi77FQT/0Gb/rWzZ26Ywd1gYA6zkvj3gNqaGZ5jw=;
        b=DJK0DPlvS3axVnolr/3zMiaSGcXjl1RrR9OJfQDuaUdjAwITML3kmSGMBc59x6LZROCjvt
        HIEllICgoD5oN9O38CxIJXGOKpW2J9z7VARdkrygJ9rob/WPE1t80BTINZNsq/32vU7xoH
        yROHy/+bhbBwlBe3ceYDOLQFPekKi10=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-512-z_sOp0xJNyy5Q1cu23pJkg-1; Thu, 21 Oct 2021 07:41:46 -0400
X-MC-Unique: z_sOp0xJNyy5Q1cu23pJkg-1
Received: by mail-ed1-f70.google.com with SMTP id d11-20020a50cd4b000000b003da63711a8aso23938291edj.20
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 04:41:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4VzWi77FQT/0Gb/rWzZ26Ywd1gYA6zkvj3gNqaGZ5jw=;
        b=QryOBqCvdsh0w1hqSiS1LX0rpmFwpKrxTuYLIb4yz1i1EuVXnRRTQ9bbJ4ovYfeQiz
         0ktTQ9WsJp21cEDGjK/nBxsfz3KvjFj5g8L7wt6xk8+yXRrzp1v/+gOHCqb+wyNhPE8Y
         0JAMhZpA64iaMbAJT6OLD8YdLnNjM7Vk2y0EeKsLnSKnNvBTLl7pWNAE/HUGRPzQQpVt
         WF8vQIwp+N9OVUzm4NimnC+o7oD73INlyBtapBxxWWHWA+kiWyLqWX2iqP/4MFg63Rlx
         uNoy6z6Y9KJt687ykI15pbdV7EgsoTC56vV7pP7LT/foXKQIJa/RdrQSJKKyiti4MmdK
         ohkQ==
X-Gm-Message-State: AOAM53342rNRzxAwiUjGjLdQCitcm0yTbTD4JSe5+Z5QjSaG7gOGYy4/
        Q1bja6f9ZDxH3qOgVzDPjGBFHWc37yg3jGl6UHnW+xhrmcf0+eB1jaHJZqaLG7jT4926k3uYgCV
        VdDLtJTXIRKIy1e7j
X-Received: by 2002:a17:907:da4:: with SMTP id go36mr6647967ejc.481.1634816505371;
        Thu, 21 Oct 2021 04:41:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyxfhgxzZghIszbq115tCMVMynSxlyV6bGAGhLjOy2KiQidQEKdtYT2AiyJMPQvvZtUj9KbBQ==
X-Received: by 2002:a17:907:da4:: with SMTP id go36mr6647945ejc.481.1634816505217;
        Thu, 21 Oct 2021 04:41:45 -0700 (PDT)
Received: from krava.cust.in.nbox.cz ([83.240.63.48])
        by smtp.gmail.com with ESMTPSA id o10sm2725533edj.79.2021.10.21.04.41.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 04:41:44 -0700 (PDT)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: [PATCH bpf-next 2/3] selftests/bpf: Fix possible/online index mismatch in perf_buffer test
Date:   Thu, 21 Oct 2021 13:41:31 +0200
Message-Id: <20211021114132.8196-3-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211021114132.8196-1-jolsa@kernel.org>
References: <20211021114132.8196-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The perf_buffer fails on system with offline cpus:

  # test_progs -t perf_buffer
  serial_test_perf_buffer:PASS:nr_cpus 0 nsec
  serial_test_perf_buffer:PASS:nr_on_cpus 0 nsec
  serial_test_perf_buffer:PASS:skel_load 0 nsec
  serial_test_perf_buffer:PASS:attach_kprobe 0 nsec
  serial_test_perf_buffer:PASS:perf_buf__new 0 nsec
  serial_test_perf_buffer:PASS:epoll_fd 0 nsec
  skipping offline CPU #4
  serial_test_perf_buffer:PASS:perf_buffer__poll 0 nsec
  serial_test_perf_buffer:PASS:seen_cpu_cnt 0 nsec
  serial_test_perf_buffer:PASS:buf_cnt 0 nsec
  ...
  serial_test_perf_buffer:PASS:fd_check 0 nsec
  serial_test_perf_buffer:PASS:drain_buf 0 nsec
  serial_test_perf_buffer:PASS:consume_buf 0 nsec
  serial_test_perf_buffer:FAIL:cpu_seen cpu 5 not seen
  #88 perf_buffer:FAIL
  Summary: 0/0 PASSED, 0 SKIPPED, 1 FAILED

If the offline cpu is from the middle of the possible set,
we get mismatch with possible and online cpu buffers.

The perf buffer test calls perf_buffer__consume_buffer for
all 'possible' cpus, but the library holds only 'online'
cpu buffers and perf_buffer__consume_buffer returns them
based on index.

Adding extra (online) index to keep track of online buffers,
we need the original (possible) index to trigger trace on
proper cpu.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 .../testing/selftests/bpf/prog_tests/perf_buffer.c  | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/perf_buffer.c b/tools/testing/selftests/bpf/prog_tests/perf_buffer.c
index 877600392851..0b0cd045979b 100644
--- a/tools/testing/selftests/bpf/prog_tests/perf_buffer.c
+++ b/tools/testing/selftests/bpf/prog_tests/perf_buffer.c
@@ -45,7 +45,7 @@ int trigger_on_cpu(int cpu)
 
 void serial_test_perf_buffer(void)
 {
-	int err, on_len, nr_on_cpus = 0, nr_cpus, i;
+	int err, on_len, nr_on_cpus = 0, nr_cpus, i, j;
 	struct perf_buffer_opts pb_opts = {};
 	struct test_perf_buffer *skel;
 	cpu_set_t cpu_seen;
@@ -111,15 +111,15 @@ void serial_test_perf_buffer(void)
 		  "got %zu, expected %d\n", perf_buffer__buffer_cnt(pb), nr_on_cpus))
 		goto out_close;
 
-	for (i = 0; i < nr_cpus; i++) {
+	for (i = 0, j = 0; i < nr_cpus; i++) {
 		if (i >= on_len || !online[i])
 			continue;
 
-		fd = perf_buffer__buffer_fd(pb, i);
+		fd = perf_buffer__buffer_fd(pb, j);
 		CHECK(fd < 0 || last_fd == fd, "fd_check", "last fd %d == fd %d\n", last_fd, fd);
 		last_fd = fd;
 
-		err = perf_buffer__consume_buffer(pb, i);
+		err = perf_buffer__consume_buffer(pb, j);
 		if (CHECK(err, "drain_buf", "cpu %d, err %d\n", i, err))
 			goto out_close;
 
@@ -127,12 +127,13 @@ void serial_test_perf_buffer(void)
 		if (trigger_on_cpu(i))
 			goto out_close;
 
-		err = perf_buffer__consume_buffer(pb, i);
-		if (CHECK(err, "consume_buf", "cpu %d, err %d\n", i, err))
+		err = perf_buffer__consume_buffer(pb, j);
+		if (CHECK(err, "consume_buf", "cpu %d, err %d\n", j, err))
 			goto out_close;
 
 		if (CHECK(!CPU_ISSET(i, &cpu_seen), "cpu_seen", "cpu %d not seen\n", i))
 			goto out_close;
+		j++;
 	}
 
 out_free_pb:
-- 
2.31.1

