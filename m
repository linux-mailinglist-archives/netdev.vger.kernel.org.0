Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A102430C46
	for <lists+netdev@lfdr.de>; Sun, 17 Oct 2021 23:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344623AbhJQVRM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 17:17:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41715 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232561AbhJQVRL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 17:17:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634505300;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=FRy9bwvZsJvWv4Af9Z5HsgohV/baKvxzAPxWjKJBPXI=;
        b=e3Aa4A/l6iiCr90PSHbmi2tl9Ky7XppRz8TQm9qw/ciX7+oVoQki+vd0qG9jlz2kupN3W6
        x0utiTdBfj8XYZxhJ5x/pEoDcC8Z6LHD313RQSuuhaUbU9xnk9F3tRPdbZ8u8d1wWSYn+8
        0wCySNNPvcNmnah514uwB0vHbrbk4QM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-366-Jz0KEk7TP_a8l7wgVk7mrw-1; Sun, 17 Oct 2021 17:14:59 -0400
X-MC-Unique: Jz0KEk7TP_a8l7wgVk7mrw-1
Received: by mail-wr1-f69.google.com with SMTP id r16-20020adfb1d0000000b00160bf8972ceso7889139wra.13
        for <netdev@vger.kernel.org>; Sun, 17 Oct 2021 14:14:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FRy9bwvZsJvWv4Af9Z5HsgohV/baKvxzAPxWjKJBPXI=;
        b=IPzL9Sz3+sd4iOtOvJsP3wdV0jyh72BUDQGvr9FM3+gYrrxtrYhPPJsEx6rm0jrL8K
         4GRDb+p6m7NYXQMyRBJt44qw67pA0+067ynhDBCtgpkeNjeqAR21KXRCk9ASd1IbeWIK
         bDe3WFrZ6ysTukNpAE+kn0+zTJumdnN75ERE2xCm/HFnS/2BpusbWhL08PucKJ6rOH7E
         nPUpWBIvaGxO8XxGL0UY/DXPrSQr2e7zNvY7SaMQU6mLXuFpRMM7EjV4zJPl3CjYGQfP
         RutWAbzrysO1KSyq3Z8ygvLQ3Xz0INq1fNzF/cOosVRsusd+EyZN08tqI9kCfaCjY2tq
         d+xw==
X-Gm-Message-State: AOAM530XKs/4ulI3gOAvrAHWhgysDi6qkbq99/916XzOVKZyCv7+XGFp
        d8s+nnU2B6QWusAqY1JJhbSEOLdpMHa/HTgA1Bttij9J43/ZLAaS3gLHYqKDxnHux6hqVV4ae4y
        znTourA+5JZLzHeKx
X-Received: by 2002:adf:9791:: with SMTP id s17mr30276206wrb.122.1634505298404;
        Sun, 17 Oct 2021 14:14:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw0JZXfKOigWsN3W5rdhjJNq/c+D3QKjRn7R5w5HK6ebUis5XeuRhpaedp/NVgzsSOO7QhOfQ==
X-Received: by 2002:adf:9791:: with SMTP id s17mr30276191wrb.122.1634505298233;
        Sun, 17 Oct 2021 14:14:58 -0700 (PDT)
Received: from krava.cust.in.nbox.cz ([83.240.63.48])
        by smtp.gmail.com with ESMTPSA id t11sm10788829wrz.65.2021.10.17.14.14.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Oct 2021 14:14:57 -0700 (PDT)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: [PATCH bpf-next 1/3] selftests/bpf: Fix perf_buffer test on system with offline cpus
Date:   Sun, 17 Oct 2021 23:14:55 +0200
Message-Id: <20211017211457.343768-1-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The perf_buffer fails on system with offline cpus:

  # test_progs -t perf_buffer
  test_perf_buffer:PASS:nr_cpus 0 nsec
  test_perf_buffer:PASS:nr_on_cpus 0 nsec
  test_perf_buffer:PASS:skel_load 0 nsec
  test_perf_buffer:PASS:attach_kprobe 0 nsec
  test_perf_buffer:PASS:perf_buf__new 0 nsec
  test_perf_buffer:PASS:epoll_fd 0 nsec
  skipping offline CPU #24
  skipping offline CPU #25
  skipping offline CPU #26
  skipping offline CPU #27
  skipping offline CPU #28
  skipping offline CPU #29
  skipping offline CPU #30
  skipping offline CPU #31
  test_perf_buffer:PASS:perf_buffer__poll 0 nsec
  test_perf_buffer:PASS:seen_cpu_cnt 0 nsec
  test_perf_buffer:FAIL:buf_cnt got 24, expected 32
  Summary: 0/0 PASSED, 0 SKIPPED, 1 FAILED

Changing the test to check online cpus instead of possible.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/perf_buffer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/perf_buffer.c b/tools/testing/selftests/bpf/prog_tests/perf_buffer.c
index 6979aff4aab2..877600392851 100644
--- a/tools/testing/selftests/bpf/prog_tests/perf_buffer.c
+++ b/tools/testing/selftests/bpf/prog_tests/perf_buffer.c
@@ -107,8 +107,8 @@ void serial_test_perf_buffer(void)
 		  "expect %d, seen %d\n", nr_on_cpus, CPU_COUNT(&cpu_seen)))
 		goto out_free_pb;
 
-	if (CHECK(perf_buffer__buffer_cnt(pb) != nr_cpus, "buf_cnt",
-		  "got %zu, expected %d\n", perf_buffer__buffer_cnt(pb), nr_cpus))
+	if (CHECK(perf_buffer__buffer_cnt(pb) != nr_on_cpus, "buf_cnt",
+		  "got %zu, expected %d\n", perf_buffer__buffer_cnt(pb), nr_on_cpus))
 		goto out_close;
 
 	for (i = 0; i < nr_cpus; i++) {
-- 
2.31.1

