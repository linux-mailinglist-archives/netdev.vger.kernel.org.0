Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9012C9880C
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 01:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729830AbfHUXok (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 19:44:40 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:37269 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729326AbfHUXoj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 19:44:39 -0400
Received: by mail-pf1-f201.google.com with SMTP id w30so2696857pfj.4
        for <netdev@vger.kernel.org>; Wed, 21 Aug 2019 16:44:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=z+5ByJPSx2fYp/vFidCtik+eb5mPYbwTE8A7Ig9nZ/Q=;
        b=iCsO3vPDTtSsL4nEpYD4MbcqWSZoUNz1RRokMknPscRSJCfki1tvCYTltLDbvLLyGQ
         5Dy9TkpMTTwozod+FeUncu8pfEWMFruNYEw2qA+opQEUfQQiPH3JTeWZOgVTH1qum2FX
         il2awg7cqFRLaMR3ZxQTzF705rPXWYahbya9KdP4Tzm+vya5YGVf68r8qyhf1TN++P4y
         C9vikI20IDagMXyGzBx9Uuy4mpPd0L1BEQrE80uXBop6/uyh+aG2yEpapKCwy2vVVJ8f
         Lddgms9teSu/D8xyYS0NvZMedsAMQKJ++bqV5FJAmmSNo8HVPO4LB4BY57qACdWrVAg1
         V93A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=z+5ByJPSx2fYp/vFidCtik+eb5mPYbwTE8A7Ig9nZ/Q=;
        b=KZoxQYn+RgXi4kMqJNaAJhnmT+9UY3hqhTyHlprIy/O4JYPvrf1GMa/fjLaHDhDjAX
         4mo2x03K7+pKelSyJ5fE6twWr7qeMLkpL8hMzB6WLLCuYxISMGnAnAaY7xeUJ1F+5P83
         Bc7O8rfMSid9S4a3+G2hgYMZzTi39KCcRqglpMHuy9TRZY387IWBugmCp82Xg6V2ioDE
         1PrgFuBTg2ShH3bAq39z1G4pnTQfegUmS2PTyBhGCIh/xu0AW1ddYtN/Z/+yUWcKmVBf
         WK1OCj1+RqOvmC2MkbbV+x/VRgRLDyD5XChlb/11AWycP5uFaiYT3XCK9kO7DxlzznrU
         Dq5g==
X-Gm-Message-State: APjAAAUmiBkSA17CXI/tQmumIfriFKI3FDVIloHh0WOFAcLmQIbbRyCe
        x1y484sXPVK8cCYK440qh7MRgpneqvobTGzXAqO1JEDZlzKL3Z7L5EuAX4XcNMItVQ6iMvCmWrK
        sO+Z9lcamwaPzEMjIh3yviUPitKPgxqAXCOlkwNW9y5+RLqATccCsbw==
X-Google-Smtp-Source: APXvYqxrxa77MEqfSTcVyyvKTA1ixKyi+2j4Yu9ZI1uznDDU1hcOSgLVgKEyeU1awCmCD8PgSJ/VCSQ=
X-Received: by 2002:a63:9318:: with SMTP id b24mr31046060pge.31.1566431077698;
 Wed, 21 Aug 2019 16:44:37 -0700 (PDT)
Date:   Wed, 21 Aug 2019 16:44:26 -0700
In-Reply-To: <20190821234427.179886-1-sdf@google.com>
Message-Id: <20190821234427.179886-4-sdf@google.com>
Mime-Version: 1.0
References: <20190821234427.179886-1-sdf@google.com>
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
Subject: [PATCH bpf-next v3 3/4] selftests/bpf: test_progs: remove asserts
 from subtests
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
 .../selftests/bpf/prog_tests/bpf_obj_id.c     | 19 ++++++++++-------
 .../selftests/bpf/prog_tests/map_lock.c       | 21 ++++++++++++-------
 .../selftests/bpf/prog_tests/spinlock.c       | 12 ++++++-----
 .../bpf/prog_tests/stacktrace_build_id.c      |  7 ++++---
 .../bpf/prog_tests/stacktrace_build_id_nmi.c  |  7 ++++---
 5 files changed, 40 insertions(+), 26 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_obj_id.c b/tools/testing/selftests/bpf/prog_tests/bpf_obj_id.c
index 5dd6ca1255d0..f10029821e16 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_obj_id.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_obj_id.c
@@ -48,15 +48,17 @@ void test_bpf_obj_id(void)
 		/* test_obj_id.o is a dumb prog. It should never fail
 		 * to load.
 		 */
-		CHECK_FAIL(err);
-		assert(!err);
+		if (CHECK_FAIL(err))
+			continue;
 
 		/* Insert a magic value to the map */
 		map_fds[i] = bpf_find_map(__func__, objs[i], "test_map_id");
-		assert(map_fds[i] >= 0);
+		if (CHECK_FAIL(map_fds[i] < 0))
+			goto done;
 		err = bpf_map_update_elem(map_fds[i], &array_key,
 					  &array_magic_value, 0);
-		assert(!err);
+		if (CHECK_FAIL(err))
+			goto done;
 
 		/* Check getting map info */
 		info_len = sizeof(struct bpf_map_info) * 2;
@@ -95,9 +97,11 @@ void test_bpf_obj_id(void)
 		prog_infos[i].map_ids = ptr_to_u64(map_ids + i);
 		prog_infos[i].nr_map_ids = 2;
 		err = clock_gettime(CLOCK_REALTIME, &real_time_ts);
-		assert(!err);
+		if (CHECK_FAIL(err))
+			goto done;
 		err = clock_gettime(CLOCK_BOOTTIME, &boot_time_ts);
-		assert(!err);
+		if (CHECK_FAIL(err))
+			goto done;
 		err = bpf_obj_get_info_by_fd(prog_fds[i], &prog_infos[i],
 					     &info_len);
 		load_time = (real_time_ts.tv_sec - boot_time_ts.tv_sec)
@@ -223,7 +227,8 @@ void test_bpf_obj_id(void)
 		nr_id_found++;
 
 		err = bpf_map_lookup_elem(map_fd, &array_key, &array_value);
-		assert(!err);
+		if (CHECK_FAIL(err))
+			goto done;
 
 		err = bpf_obj_get_info_by_fd(map_fd, &map_info, &info_len);
 		CHECK(err || info_len != sizeof(struct bpf_map_info) ||
diff --git a/tools/testing/selftests/bpf/prog_tests/map_lock.c b/tools/testing/selftests/bpf/prog_tests/map_lock.c
index 15993b6a194b..8f91f1881d11 100644
--- a/tools/testing/selftests/bpf/prog_tests/map_lock.c
+++ b/tools/testing/selftests/bpf/prog_tests/map_lock.c
@@ -54,17 +54,22 @@ void test_map_lock(void)
 	bpf_map_update_elem(map_fd[0], &key, vars, BPF_F_LOCK);
 
 	for (i = 0; i < 4; i++)
-		assert(pthread_create(&thread_id[i], NULL,
-				      &spin_lock_thread, &prog_fd) == 0);
+		if (CHECK_FAIL(pthread_create(&thread_id[i], NULL,
+					      &spin_lock_thread, &prog_fd)))
+			goto close_prog;
 	for (i = 4; i < 6; i++)
-		assert(pthread_create(&thread_id[i], NULL,
-				      &parallel_map_access, &map_fd[i - 4]) == 0);
+		if (CHECK_FAIL(pthread_create(&thread_id[i], NULL,
+					      &parallel_map_access,
+					      &map_fd[i - 4])))
+			goto close_prog;
 	for (i = 0; i < 4; i++)
-		assert(pthread_join(thread_id[i], &ret) == 0 &&
-		       ret == (void *)&prog_fd);
+		if (CHECK_FAIL(pthread_join(thread_id[i], &ret) ||
+			       ret != (void *)&prog_fd))
+			goto close_prog;
 	for (i = 4; i < 6; i++)
-		assert(pthread_join(thread_id[i], &ret) == 0 &&
-		       ret == (void *)&map_fd[i - 4]);
+		if (CHECK_FAIL(pthread_join(thread_id[i], &ret) ||
+			       ret != (void *)&map_fd[i - 4]))
+			goto close_prog;
 close_prog:
 	bpf_object__close(obj);
 }
diff --git a/tools/testing/selftests/bpf/prog_tests/spinlock.c b/tools/testing/selftests/bpf/prog_tests/spinlock.c
index d71fb3dda376..1ae00cd3174e 100644
--- a/tools/testing/selftests/bpf/prog_tests/spinlock.c
+++ b/tools/testing/selftests/bpf/prog_tests/spinlock.c
@@ -16,12 +16,14 @@ void test_spinlock(void)
 		goto close_prog;
 	}
 	for (i = 0; i < 4; i++)
-		assert(pthread_create(&thread_id[i], NULL,
-				      &spin_lock_thread, &prog_fd) == 0);
-	for (i = 0; i < 4; i++)
-		assert(pthread_join(thread_id[i], &ret) == 0 &&
-		       ret == (void *)&prog_fd);
+		if (CHECK_FAIL(pthread_create(&thread_id[i], NULL,
+					      &spin_lock_thread, &prog_fd)))
+			goto close_prog;
 
+	for (i = 0; i < 4; i++)
+		if (CHECK_FAIL(pthread_join(thread_id[i], &ret) ||
+			       ret != (void *)&prog_fd))
+			goto close_prog;
 close_prog:
 	bpf_object__close(obj);
 }
diff --git a/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id.c b/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id.c
index ac44fda84833..d841dced971f 100644
--- a/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id.c
+++ b/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id.c
@@ -51,9 +51,10 @@ void test_stacktrace_build_id(void)
 		  "err %d errno %d\n", err, errno))
 		goto disable_pmu;
 
-	assert(system("dd if=/dev/urandom of=/dev/zero count=4 2> /dev/null")
-	       == 0);
-	assert(system("./urandom_read") == 0);
+	if (CHECK_FAIL(system("dd if=/dev/urandom of=/dev/zero count=4 2> /dev/null")))
+		goto disable_pmu;
+	if (CHECK_FAIL(system("./urandom_read")))
+		goto disable_pmu;
 	/* disable stack trace collection */
 	key = 0;
 	val = 1;
diff --git a/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c b/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c
index 9557b7dfb782..f62aa0eb959b 100644
--- a/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c
+++ b/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c
@@ -82,9 +82,10 @@ void test_stacktrace_build_id_nmi(void)
 		  "err %d errno %d\n", err, errno))
 		goto disable_pmu;
 
-	assert(system("dd if=/dev/urandom of=/dev/zero count=4 2> /dev/null")
-	       == 0);
-	assert(system("taskset 0x1 ./urandom_read 100000") == 0);
+	if (CHECK_FAIL(system("dd if=/dev/urandom of=/dev/zero count=4 2> /dev/null")))
+		goto disable_pmu;
+	if (CHECK_FAIL(system("taskset 0x1 ./urandom_read 100000")))
+		goto disable_pmu;
 	/* disable stack trace collection */
 	key = 0;
 	val = 1;
-- 
2.23.0.187.g17f5b7556c-goog

