Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8502A8D864
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 18:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728349AbfHNQr5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 12:47:57 -0400
Received: from mail-qk1-f202.google.com ([209.85.222.202]:54043 "EHLO
        mail-qk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728327AbfHNQr4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 12:47:56 -0400
Received: by mail-qk1-f202.google.com with SMTP id d11so100110697qkb.20
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 09:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=VdatEzAwtdxRnHgxwHcBpEyz4fJTPa7g3XqVA9XHlDQ=;
        b=vs6H85nQzbsugBAmC/oFyZC2xjy9u26nLTaX6MXLkZT6Yl3HaMAN2b4ULh+r29KTe7
         6xWoulE38Oic2sEPSPamXaAUhmEEgyRRJkQEKlQWDD2W4R98IGo46Oo8Vn4KG5qKrNMa
         cXz+mqMkgWX+GLYYYt6V91E8M0nJNJsOE2spuhLUvi4VSjp/jfVRiq/Q99XK/pIYZkNJ
         wKxz2TvyiKSy7mS1NdmoqGb1z5rI291q958omtmyvTpliurb2OV5dYicAEacVj3TvcKl
         kY3ipb+slqut+zXhmgt3lZu6XsiBuyNAXc6KhOX/bu5Sv4vpwrGbs4/lFhqC2zktr95Q
         C8yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=VdatEzAwtdxRnHgxwHcBpEyz4fJTPa7g3XqVA9XHlDQ=;
        b=YMmYH3MfgFW7ZPJQH4RO5jIoDhv1+UMkwzLt+ME6FnpArzubY+VmpuyC5b4yzBrZeS
         JGMv+qxWM+3KnWKL2KlZOF10wkjBm821JmkIc+8OARsj6kXwSw0JXRSALrqizmvzIm7c
         dHK1A+TF11nZ0oO6oqR9oCSHwklyHinw9zKzkpQ+aG/rLEP1lDn6ncWiCgIExikGiM2K
         CtCi6pHj6bOH4LR7jbLGheKroPt8ZuG5L6cfqtTozoOF+pDXIZ7+QYdvqRntvfMnsGfB
         B03JFOIPNQbx8+MHcIoAxzFgZSJIma+oYet61AHYUikeCRRtX0V9Fpk/po/8YP1IPrth
         lwIw==
X-Gm-Message-State: APjAAAX527Q4Px8i/rQysC4FXV7CuCWuyefQcWQ+ONjmNw6vGX4o2qIj
        qIB8WH4CH7oEKtl6rBO8a4YTFdhXZW/NBe4JRTLby7NyE0DVkkR6f3P/dPQn2yYsn3QXb92ntnN
        aLKTlyt3C4P9yqtpdQqkXJ7W3+2q40cPQaMkfYvL9MwEZ23G5xL1AWQ==
X-Google-Smtp-Source: APXvYqwi02DDukEjRigwsxH/vw/nbocKWQ/LZzPiB4IJHQcEEbNitRjEu1BjtE6/s5L5PNZ76rQtw6c=
X-Received: by 2002:aed:2ca3:: with SMTP id g32mr248900qtd.359.1565801275252;
 Wed, 14 Aug 2019 09:47:55 -0700 (PDT)
Date:   Wed, 14 Aug 2019 09:47:42 -0700
In-Reply-To: <20190814164742.208909-1-sdf@google.com>
Message-Id: <20190814164742.208909-5-sdf@google.com>
Mime-Version: 1.0
References: <20190814164742.208909-1-sdf@google.com>
X-Mailer: git-send-email 2.23.0.rc1.153.gdeed80330f-goog
Subject: [PATCH bpf-next 4/4] selftests/bpf: test_progs: remove asserts from subtests
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Otherwise they can bring the whole process down.

Cc: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 .../selftests/bpf/prog_tests/bpf_obj_id.c     | 30 ++++++++++++++-----
 .../selftests/bpf/prog_tests/map_lock.c       | 20 ++++++++-----
 .../selftests/bpf/prog_tests/spinlock.c       | 10 ++++---
 .../bpf/prog_tests/stacktrace_build_id.c      | 11 +++++--
 .../bpf/prog_tests/stacktrace_build_id_nmi.c  | 11 +++++--
 5 files changed, 57 insertions(+), 25 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_obj_id.c b/tools/testing/selftests/bpf/prog_tests/bpf_obj_id.c
index f57e0c625de3..4ec8c4e9e9a1 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_obj_id.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_obj_id.c
@@ -48,16 +48,23 @@ void test_bpf_obj_id(void)
 		/* test_obj_id.o is a dumb prog. It should never fail
 		 * to load.
 		 */
-		if (err)
+		if (err) {
 			test__fail();
-		assert(!err);
+			continue;
+		}
 
 		/* Insert a magic value to the map */
 		map_fds[i] = bpf_find_map(__func__, objs[i], "test_map_id");
-		assert(map_fds[i] >= 0);
+		if (map_fds[i] < 0) {
+			test__fail();
+			goto done;
+		}
 		err = bpf_map_update_elem(map_fds[i], &array_key,
 					  &array_magic_value, 0);
-		assert(!err);
+		if (err) {
+			test__fail();
+			goto done;
+		}
 
 		/* Check getting map info */
 		info_len = sizeof(struct bpf_map_info) * 2;
@@ -96,9 +103,15 @@ void test_bpf_obj_id(void)
 		prog_infos[i].map_ids = ptr_to_u64(map_ids + i);
 		prog_infos[i].nr_map_ids = 2;
 		err = clock_gettime(CLOCK_REALTIME, &real_time_ts);
-		assert(!err);
+		if (err) {
+			test__fail();
+			goto done;
+		}
 		err = clock_gettime(CLOCK_BOOTTIME, &boot_time_ts);
-		assert(!err);
+		if (err) {
+			test__fail();
+			goto done;
+		}
 		err = bpf_obj_get_info_by_fd(prog_fds[i], &prog_infos[i],
 					     &info_len);
 		load_time = (real_time_ts.tv_sec - boot_time_ts.tv_sec)
@@ -224,7 +237,10 @@ void test_bpf_obj_id(void)
 		nr_id_found++;
 
 		err = bpf_map_lookup_elem(map_fd, &array_key, &array_value);
-		assert(!err);
+		if (err) {
+			test__fail();
+			goto done;
+		}
 
 		err = bpf_obj_get_info_by_fd(map_fd, &map_info, &info_len);
 		CHECK(err || info_len != sizeof(struct bpf_map_info) ||
diff --git a/tools/testing/selftests/bpf/prog_tests/map_lock.c b/tools/testing/selftests/bpf/prog_tests/map_lock.c
index 12123ff1f31f..e7663721fb57 100644
--- a/tools/testing/selftests/bpf/prog_tests/map_lock.c
+++ b/tools/testing/selftests/bpf/prog_tests/map_lock.c
@@ -56,17 +56,21 @@ void test_map_lock(void)
 	bpf_map_update_elem(map_fd[0], &key, vars, BPF_F_LOCK);
 
 	for (i = 0; i < 4; i++)
-		assert(pthread_create(&thread_id[i], NULL,
-				      &spin_lock_thread, &prog_fd) == 0);
+		if (pthread_create(&thread_id[i], NULL,
+				   &spin_lock_thread, &prog_fd))
+			goto close_prog;
 	for (i = 4; i < 6; i++)
-		assert(pthread_create(&thread_id[i], NULL,
-				      &parallel_map_access, &map_fd[i - 4]) == 0);
+		if (pthread_create(&thread_id[i], NULL,
+				   &parallel_map_access, &map_fd[i - 4]))
+			goto close_prog;
 	for (i = 0; i < 4; i++)
-		assert(pthread_join(thread_id[i], &ret) == 0 &&
-		       ret == (void *)&prog_fd);
+		if (pthread_join(thread_id[i], &ret) ||
+		    ret != (void *)&prog_fd)
+			goto close_prog;
 	for (i = 4; i < 6; i++)
-		assert(pthread_join(thread_id[i], &ret) == 0 &&
-		       ret == (void *)&map_fd[i - 4]);
+		if (pthread_join(thread_id[i], &ret) ||
+		    ret != (void *)&map_fd[i - 4])
+			goto close_prog;
 	goto close_prog_noerr;
 close_prog:
 	test__fail();
diff --git a/tools/testing/selftests/bpf/prog_tests/spinlock.c b/tools/testing/selftests/bpf/prog_tests/spinlock.c
index e843336713e8..5f32a913f732 100644
--- a/tools/testing/selftests/bpf/prog_tests/spinlock.c
+++ b/tools/testing/selftests/bpf/prog_tests/spinlock.c
@@ -16,11 +16,13 @@ void test_spinlock(void)
 		goto close_prog;
 	}
 	for (i = 0; i < 4; i++)
-		assert(pthread_create(&thread_id[i], NULL,
-				      &spin_lock_thread, &prog_fd) == 0);
+		if (pthread_create(&thread_id[i], NULL,
+				   &spin_lock_thread, &prog_fd))
+			goto close_prog;
+
 	for (i = 0; i < 4; i++)
-		assert(pthread_join(thread_id[i], &ret) == 0 &&
-		       ret == (void *)&prog_fd);
+		if (pthread_join(thread_id[i], &ret) || ret != (void *)&prog_fd)
+			goto close_prog;
 	goto close_prog_noerr;
 close_prog:
 	test__fail();
diff --git a/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id.c b/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id.c
index ac44fda84833..d74464faebd7 100644
--- a/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id.c
+++ b/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id.c
@@ -51,9 +51,14 @@ void test_stacktrace_build_id(void)
 		  "err %d errno %d\n", err, errno))
 		goto disable_pmu;
 
-	assert(system("dd if=/dev/urandom of=/dev/zero count=4 2> /dev/null")
-	       == 0);
-	assert(system("./urandom_read") == 0);
+	if (system("dd if=/dev/urandom of=/dev/zero count=4 2> /dev/null")) {
+		test__fail();
+		goto disable_pmu;
+	}
+	if (system("./urandom_read")) {
+		test__fail();
+		goto disable_pmu;
+	}
 	/* disable stack trace collection */
 	key = 0;
 	val = 1;
diff --git a/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c b/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c
index 9557b7dfb782..e886911928bc 100644
--- a/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c
+++ b/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c
@@ -82,9 +82,14 @@ void test_stacktrace_build_id_nmi(void)
 		  "err %d errno %d\n", err, errno))
 		goto disable_pmu;
 
-	assert(system("dd if=/dev/urandom of=/dev/zero count=4 2> /dev/null")
-	       == 0);
-	assert(system("taskset 0x1 ./urandom_read 100000") == 0);
+	if (system("dd if=/dev/urandom of=/dev/zero count=4 2> /dev/null")) {
+		test__fail();
+		goto disable_pmu;
+	}
+	if (system("taskset 0x1 ./urandom_read 100000")) {
+		test__fail();
+		goto disable_pmu;
+	}
 	/* disable stack trace collection */
 	key = 0;
 	val = 1;
-- 
2.23.0.rc1.153.gdeed80330f-goog

