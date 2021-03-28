Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3BB34BD32
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 18:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231285AbhC1QNH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 12:13:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231267AbhC1QMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 12:12:50 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E6ADC061756;
        Sun, 28 Mar 2021 09:12:50 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id x27so5365142qvd.2;
        Sun, 28 Mar 2021 09:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qXmHrbHu9PXmGzGPke8kvh2otPX8784lz/uhZrxhb0s=;
        b=SEBiMH8veeK98mZf/ElkiXuyU7wccCcwyKk+TvsrFcw7we9IBJCXRgxGwVu7rkPSZE
         OAHrd4Aho7MsoRmIdtW8l4hzLciFeadbbnukGTKgAachM8ivlB5Ea458Z5JgEMdYNwdu
         VDlVph5VD05RLGKl8bsl+UlX5F/JvDEALgCFoSkM7Dsr3SGreKJ1qQqw5yk+Cc1oojaF
         0YeNsaYWTpAXv0TPSd5DTqq+Ix4b7DWKw7lm3RFMYNRf/NGiN+neYscnLtm2kCt8xrjB
         evkvFziVq9PpthKnG3sv313lZvuGOjGg0AONzWr6V5JPUhyd5OVSWYoz9lW+SMm8Imck
         Sckg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qXmHrbHu9PXmGzGPke8kvh2otPX8784lz/uhZrxhb0s=;
        b=RyDY06X71m7jCEnQRe2lIsr8j8BPWdO0vU5W2PUCjaxHrJrjNsjsvm82ojY4tMi3V1
         f8JR9S2eMEt0YZfiu9EksCZajxVEd0yAc9gVnC35NC+Off+sPvLVHY3pz17/m41180Fx
         j6nY+0/+FU0sQq/CrLHCieIoRZmVMwNdo7BDSOObMlMx/HxHHDm3tVNQjRLedDDfcMGl
         p4pZn+jhXZ+Nq5y1zcMSdirMB8oW/rKVU72Hw8lQXUTeXUE/z3CsHFp4U+FYXPlJCMRX
         xjMkqIwgt0IYD1LQWXkHmVX2nfIFt8/NSf4UifyHrdjXL6omkrvS9H1aApxPPr2l0ere
         ofhg==
X-Gm-Message-State: AOAM5305lNIZZ7P6j+sZrnSu6W5MoOR22+2n6Wm8anvgNbvB7/H+1apY
        MiB2rAzN1ARtBFu43cDATew=
X-Google-Smtp-Source: ABdhPJzqwZ5fFfYMfRCqam1gLDp2CihG/fofezRvoS8Klq8XMjPuVoohYQqPTPlB63wsjus335SJxw==
X-Received: by 2002:a0c:e8c5:: with SMTP id m5mr21535174qvo.13.1616947969594;
        Sun, 28 Mar 2021 09:12:49 -0700 (PDT)
Received: from localhost.localdomain ([179.218.4.27])
        by smtp.gmail.com with ESMTPSA id o7sm11275232qkb.104.2021.03.28.09.12.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Mar 2021 09:12:49 -0700 (PDT)
From:   Pedro Tammela <pctammela@gmail.com>
X-Google-Original-From: Pedro Tammela <pctammela@mojatatu.com>
Cc:     Pedro Tammela <pctammela@mojatatu.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Joe Stringer <joe@cilium.io>,
        Quentin Monnet <quentin@isovalent.com>,
        Yang Li <yang.lee@linux.alibaba.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH bpf-next] libbpf: Add '_wait()' and '_nowait()' macros for 'bpf_ring_buffer__poll()'
Date:   Sun, 28 Mar 2021 13:10:32 -0300
Message-Id: <20210328161055.257504-3-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210328161055.257504-1-pctammela@mojatatu.com>
References: <20210328161055.257504-1-pctammela@mojatatu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'bpf_ring_buffer__poll()' abstracts the polling method, so abstract the
constants that make the implementation don't wait or wait indefinetly
for data.

Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 tools/lib/bpf/libbpf.h                                 | 3 +++
 tools/testing/selftests/bpf/benchs/bench_ringbufs.c    | 2 +-
 tools/testing/selftests/bpf/prog_tests/ringbuf.c       | 6 +++---
 tools/testing/selftests/bpf/prog_tests/ringbuf_multi.c | 4 ++--
 4 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index f500621d28e5..3817d84f91c6 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -540,6 +540,9 @@ LIBBPF_API int ring_buffer__poll(struct ring_buffer *rb, int timeout_ms);
 LIBBPF_API int ring_buffer__consume(struct ring_buffer *rb);
 LIBBPF_API int ring_buffer__epoll_fd(const struct ring_buffer *rb);
 
+#define ring_buffer__poll_wait(rb) ring_buffer__poll(rb, -1)
+#define ring_buffer__poll_nowait(rb) ring_buffer__poll(rb, 0)
+
 /* Perf buffer APIs */
 struct perf_buffer;
 
diff --git a/tools/testing/selftests/bpf/benchs/bench_ringbufs.c b/tools/testing/selftests/bpf/benchs/bench_ringbufs.c
index bde6c9d4cbd4..82db2cc9bab3 100644
--- a/tools/testing/selftests/bpf/benchs/bench_ringbufs.c
+++ b/tools/testing/selftests/bpf/benchs/bench_ringbufs.c
@@ -191,7 +191,7 @@ static void *ringbuf_libbpf_consumer(void *input)
 {
 	struct ringbuf_libbpf_ctx *ctx = &ringbuf_libbpf_ctx;
 
-	while (ring_buffer__poll(ctx->ringbuf, -1) >= 0) {
+	while (ring_buffer__poll_wait(ctx->ringbuf) >= 0) {
 		if (args.back2back)
 			bufs_trigger_batch();
 	}
diff --git a/tools/testing/selftests/bpf/prog_tests/ringbuf.c b/tools/testing/selftests/bpf/prog_tests/ringbuf.c
index fddbc5db5d6a..321c646a0685 100644
--- a/tools/testing/selftests/bpf/prog_tests/ringbuf.c
+++ b/tools/testing/selftests/bpf/prog_tests/ringbuf.c
@@ -121,7 +121,7 @@ void test_ringbuf(void)
 	      3L * rec_sz, skel->bss->prod_pos);
 
 	/* poll for samples */
-	err = ring_buffer__poll(ringbuf, -1);
+	err = ring_buffer__poll_wait(ringbuf);
 
 	/* -EDONE is used as an indicator that we are done */
 	if (CHECK(err != -EDONE, "err_done", "done err: %d\n", err))
@@ -130,7 +130,7 @@ void test_ringbuf(void)
 	CHECK(cnt != 2, "cnt", "exp %d samples, got %d\n", 2, cnt);
 
 	/* we expect extra polling to return nothing */
-	err = ring_buffer__poll(ringbuf, 0);
+	err = ring_buffer__poll_nowait(ringbuf);
 	if (CHECK(err != 0, "extra_samples", "poll result: %d\n", err))
 		goto cleanup;
 	cnt = atomic_xchg(&sample_cnt, 0);
@@ -148,7 +148,7 @@ void test_ringbuf(void)
 	CHECK(skel->bss->cons_pos != 3 * rec_sz,
 	      "err_cons_pos", "exp %ld, got %ld\n",
 	      3L * rec_sz, skel->bss->cons_pos);
-	err = ring_buffer__poll(ringbuf, -1);
+	err = ring_buffer__poll_wait(ringbuf);
 	CHECK(err <= 0, "poll_err", "err %d\n", err);
 	cnt = atomic_xchg(&sample_cnt, 0);
 	CHECK(cnt != 2, "cnt", "exp %d samples, got %d\n", 2, cnt);
diff --git a/tools/testing/selftests/bpf/prog_tests/ringbuf_multi.c b/tools/testing/selftests/bpf/prog_tests/ringbuf_multi.c
index d37161e59bb2..65ba0a3472f1 100644
--- a/tools/testing/selftests/bpf/prog_tests/ringbuf_multi.c
+++ b/tools/testing/selftests/bpf/prog_tests/ringbuf_multi.c
@@ -80,12 +80,12 @@ void test_ringbuf_multi(void)
 	syscall(__NR_getpgid);
 
 	/* poll for samples, should get 2 ringbufs back */
-	err = ring_buffer__poll(ringbuf, -1);
+	err = ring_buffer__poll_wait(ringbuf);
 	if (CHECK(err != 2, "poll_res", "expected 2 records, got %d\n", err))
 		goto cleanup;
 
 	/* expect extra polling to return nothing */
-	err = ring_buffer__poll(ringbuf, 0);
+	err = ring_buffer__poll_nowait(ringbuf);
 	if (CHECK(err < 0, "extra_samples", "poll result: %d\n", err))
 		goto cleanup;
 
-- 
2.25.1

