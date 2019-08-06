Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4ED1837A7
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 19:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387866AbfHFRJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 13:09:10 -0400
Received: from mail-yb1-f202.google.com ([209.85.219.202]:55736 "EHLO
        mail-yb1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733201AbfHFRJK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 13:09:10 -0400
Received: by mail-yb1-f202.google.com with SMTP id m4so4717010ybp.22
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 10:09:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=8tczlYcihDQNZRInDtQRXJyWux0eFEi/lCA124/01GU=;
        b=YsyRNjovnEWePqvWkNuLygcVjD8VlXtJwOr6b5ShO6VPdJq5DW0gjW1CgfDC4xalob
         QmyuYnsitl0Vgurbji/l/o5d8z+T+O9SxsuwohyGnq5X5G85DWYkdonYb5CwtlzG9t92
         yO9dDbuhuaC7pDXAQQI06qRXwmM8iUy5ZwJ2T3ZrFpH48VUC4U24msyTK+rqqL6mgmKp
         zTL12YP3ysRNU7hsSwTTBiy9+ku8UYSzlgOLEGM/TRwmgQHFakxRmTH4hLUUeDT1KnWz
         U6ktd1VAIL5YNKoTruqnGle+PgRsbJS4ZlAw0pY8yArJoZnI7zyF2JIFJ1wkuO9VlW5x
         NABg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=8tczlYcihDQNZRInDtQRXJyWux0eFEi/lCA124/01GU=;
        b=b+qR73oqT+j9j4TUzQDzzzZ6xlhWfk7iV7mj61Xd0rzABky3WgovdrrtRQjY446FaP
         nNLm2U+L5Q17Os03pHR6afX0f4fvRApb8t97TyqxmjmAc8/8MV8o1cNOdurQXXiqv/WI
         f3JK8jCer0EYIYIBJ4MLo1RE2eAWtbE2icR+emT+yayFbaS8mrOXvLB6rnRVs3Uhw4Hu
         XfL0dmw4whq6C8HroKS83T8BMyXuFYU9R3Ft24yWZ6IQ8VSetLPwPBO9KMbJIWraelxB
         TOHDzj6L+IpCW0FaPr6RqGI4sseLu2zrHOgKibOgkTLtE/1X28FRF/qmSxo0qpuVn3A4
         t77A==
X-Gm-Message-State: APjAAAUpHdzwXpp1hW/ZFJx6vbY+LdOfYnegITLa5fJOkSr8EkIIVs5C
        /J6/SlqahZCsr/QSxjtXABvpX5Kd4mcSfVh+0UtBvmlYkM42j5F4p48tyVEBFOxzR03EApsi2b1
        CCxD94a0F1zCKqEJYjeuH1VOj8lj+5svy07EteJLKcA2MUaeVMbc15g==
X-Google-Smtp-Source: APXvYqxT99ZDrZLvuZkSi7znM+s7B5PSl/ZdlIo/raWoVyxv0FMH6QnKt9fARhIuta5YWBvuE2PgGmI=
X-Received: by 2002:a81:23ca:: with SMTP id j193mr3080041ywj.332.1565111349035;
 Tue, 06 Aug 2019 10:09:09 -0700 (PDT)
Date:   Tue,  6 Aug 2019 10:09:00 -0700
In-Reply-To: <20190806170901.142264-1-sdf@google.com>
Message-Id: <20190806170901.142264-3-sdf@google.com>
Mime-Version: 1.0
References: <20190806170901.142264-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.770.g0f2c4a37fd-goog
Subject: [PATCH bpf-next v4 2/3] selftests/bpf: test_progs: test__printf -> printf
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

Now that test__printf is a simple wraper around printf, let's drop it
(and test__vprintf as well).

Cc: Andrii Nakryiko <andriin@fb.com>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 .../selftests/bpf/prog_tests/bpf_verif_scale.c   |  4 ++--
 .../testing/selftests/bpf/prog_tests/l4lb_all.c  |  2 +-
 .../testing/selftests/bpf/prog_tests/map_lock.c  | 10 +++++-----
 .../selftests/bpf/prog_tests/send_signal.c       |  4 ++--
 .../testing/selftests/bpf/prog_tests/spinlock.c  |  2 +-
 .../bpf/prog_tests/stacktrace_build_id.c         |  4 ++--
 .../bpf/prog_tests/stacktrace_build_id_nmi.c     |  4 ++--
 .../selftests/bpf/prog_tests/xdp_noinline.c      |  4 ++--
 tools/testing/selftests/bpf/test_progs.c         | 16 +---------------
 tools/testing/selftests/bpf/test_progs.h         | 10 ++++------
 10 files changed, 22 insertions(+), 38 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c b/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
index b4be96162ff4..3548ba2f24a8 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
@@ -5,13 +5,13 @@ static int libbpf_debug_print(enum libbpf_print_level level,
 			      const char *format, va_list args)
 {
 	if (level != LIBBPF_DEBUG) {
-		test__vprintf(format, args);
+		vprintf(format, args);
 		return 0;
 	}
 
 	if (!strstr(format, "verifier log"))
 		return 0;
-	test__vprintf("%s", args);
+	vprintf("%s", args);
 	return 0;
 }
 
diff --git a/tools/testing/selftests/bpf/prog_tests/l4lb_all.c b/tools/testing/selftests/bpf/prog_tests/l4lb_all.c
index 5ce572c03a5f..20ddca830e68 100644
--- a/tools/testing/selftests/bpf/prog_tests/l4lb_all.c
+++ b/tools/testing/selftests/bpf/prog_tests/l4lb_all.c
@@ -74,7 +74,7 @@ static void test_l4lb(const char *file)
 	}
 	if (bytes != MAGIC_BYTES * NUM_ITER * 2 || pkts != NUM_ITER * 2) {
 		error_cnt++;
-		test__printf("test_l4lb:FAIL:stats %lld %lld\n", bytes, pkts);
+		printf("test_l4lb:FAIL:stats %lld %lld\n", bytes, pkts);
 	}
 out:
 	bpf_object__close(obj);
diff --git a/tools/testing/selftests/bpf/prog_tests/map_lock.c b/tools/testing/selftests/bpf/prog_tests/map_lock.c
index 2e78217ed3fd..ee99368c595c 100644
--- a/tools/testing/selftests/bpf/prog_tests/map_lock.c
+++ b/tools/testing/selftests/bpf/prog_tests/map_lock.c
@@ -9,12 +9,12 @@ static void *parallel_map_access(void *arg)
 	for (i = 0; i < 10000; i++) {
 		err = bpf_map_lookup_elem_flags(map_fd, &key, vars, BPF_F_LOCK);
 		if (err) {
-			test__printf("lookup failed\n");
+			printf("lookup failed\n");
 			error_cnt++;
 			goto out;
 		}
 		if (vars[0] != 0) {
-			test__printf("lookup #%d var[0]=%d\n", i, vars[0]);
+			printf("lookup #%d var[0]=%d\n", i, vars[0]);
 			error_cnt++;
 			goto out;
 		}
@@ -22,8 +22,8 @@ static void *parallel_map_access(void *arg)
 		for (j = 2; j < 17; j++) {
 			if (vars[j] == rnd)
 				continue;
-			test__printf("lookup #%d var[1]=%d var[%d]=%d\n",
-				     i, rnd, j, vars[j]);
+			printf("lookup #%d var[1]=%d var[%d]=%d\n",
+			       i, rnd, j, vars[j]);
 			error_cnt++;
 			goto out;
 		}
@@ -43,7 +43,7 @@ void test_map_lock(void)
 
 	err = bpf_prog_load(file, BPF_PROG_TYPE_CGROUP_SKB, &obj, &prog_fd);
 	if (err) {
-		test__printf("test_map_lock:bpf_prog_load errno %d\n", errno);
+		printf("test_map_lock:bpf_prog_load errno %d\n", errno);
 		goto close_prog;
 	}
 	map_fd[0] = bpf_find_map(__func__, obj, "hash_map");
diff --git a/tools/testing/selftests/bpf/prog_tests/send_signal.c b/tools/testing/selftests/bpf/prog_tests/send_signal.c
index 461b423d0584..1575f0a1f586 100644
--- a/tools/testing/selftests/bpf/prog_tests/send_signal.c
+++ b/tools/testing/selftests/bpf/prog_tests/send_signal.c
@@ -202,8 +202,8 @@ static int test_send_signal_nmi(void)
 			 -1 /* cpu */, -1 /* group_fd */, 0 /* flags */);
 	if (pmu_fd == -1) {
 		if (errno == ENOENT) {
-			test__printf("%s:SKIP:no PERF_COUNT_HW_CPU_CYCLES\n",
-				     __func__);
+			printf("%s:SKIP:no PERF_COUNT_HW_CPU_CYCLES\n",
+			       __func__);
 			return 0;
 		}
 		/* Let the test fail with a more informative message */
diff --git a/tools/testing/selftests/bpf/prog_tests/spinlock.c b/tools/testing/selftests/bpf/prog_tests/spinlock.c
index deb2db5b85b0..114ebe6a438e 100644
--- a/tools/testing/selftests/bpf/prog_tests/spinlock.c
+++ b/tools/testing/selftests/bpf/prog_tests/spinlock.c
@@ -12,7 +12,7 @@ void test_spinlock(void)
 
 	err = bpf_prog_load(file, BPF_PROG_TYPE_CGROUP_SKB, &obj, &prog_fd);
 	if (err) {
-		test__printf("test_spin_lock:bpf_prog_load errno %d\n", errno);
+		printf("test_spin_lock:bpf_prog_load errno %d\n", errno);
 		goto close_prog;
 	}
 	for (i = 0; i < 4; i++)
diff --git a/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id.c b/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id.c
index 356d2c017a9c..ac44fda84833 100644
--- a/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id.c
+++ b/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id.c
@@ -109,8 +109,8 @@ void test_stacktrace_build_id(void)
 	if (build_id_matches < 1 && retry--) {
 		bpf_link__destroy(link);
 		bpf_object__close(obj);
-		test__printf("%s:WARN:Didn't find expected build ID from the map, retrying\n",
-			     __func__);
+		printf("%s:WARN:Didn't find expected build ID from the map, retrying\n",
+		       __func__);
 		goto retry;
 	}
 
diff --git a/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c b/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c
index f44f2c159714..9557b7dfb782 100644
--- a/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c
+++ b/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c
@@ -140,8 +140,8 @@ void test_stacktrace_build_id_nmi(void)
 	if (build_id_matches < 1 && retry--) {
 		bpf_link__destroy(link);
 		bpf_object__close(obj);
-		test__printf("%s:WARN:Didn't find expected build ID from the map, retrying\n",
-			     __func__);
+		printf("%s:WARN:Didn't find expected build ID from the map, retrying\n",
+		       __func__);
 		goto retry;
 	}
 
diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_noinline.c b/tools/testing/selftests/bpf/prog_tests/xdp_noinline.c
index b5404494b8aa..15f7c272edb0 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_noinline.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_noinline.c
@@ -75,8 +75,8 @@ void test_xdp_noinline(void)
 	}
 	if (bytes != MAGIC_BYTES * NUM_ITER * 2 || pkts != NUM_ITER * 2) {
 		error_cnt++;
-		test__printf("test_xdp_noinline:FAIL:stats %lld %lld\n",
-			     bytes, pkts);
+		printf("test_xdp_noinline:FAIL:stats %lld %lld\n",
+		       bytes, pkts);
 	}
 out:
 	bpf_object__close(obj);
diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index 9556439c607c..963912008042 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -105,20 +105,6 @@ void test__force_log() {
 	env.test->force_log = true;
 }
 
-void test__vprintf(const char *fmt, va_list args)
-{
-	vprintf(fmt, args);
-}
-
-void test__printf(const char *fmt, ...)
-{
-	va_list args;
-
-	va_start(args, fmt);
-	test__vprintf(fmt, args);
-	va_end(args);
-}
-
 struct ipv4_packet pkt_v4 = {
 	.eth.h_proto = __bpf_constant_htons(ETH_P_IP),
 	.iph.ihl = 5,
@@ -310,7 +296,7 @@ static int libbpf_print_fn(enum libbpf_print_level level,
 {
 	if (!env.very_verbose && level == LIBBPF_DEBUG)
 		return 0;
-	test__vprintf(format, args);
+	vprintf(format, args);
 	return 0;
 }
 
diff --git a/tools/testing/selftests/bpf/test_progs.h b/tools/testing/selftests/bpf/test_progs.h
index 541f9eab5eed..37d427f5a1e5 100644
--- a/tools/testing/selftests/bpf/test_progs.h
+++ b/tools/testing/selftests/bpf/test_progs.h
@@ -70,8 +70,6 @@ extern int error_cnt;
 extern int pass_cnt;
 extern struct test_env env;
 
-extern void test__printf(const char *fmt, ...);
-extern void test__vprintf(const char *fmt, va_list args);
 extern void test__force_log();
 extern bool test__start_subtest(const char *name);
 
@@ -97,12 +95,12 @@ extern struct ipv6_packet pkt_v6;
 	int __ret = !!(condition);					\
 	if (__ret) {							\
 		error_cnt++;						\
-		test__printf("%s:FAIL:%s ", __func__, tag);		\
-		test__printf(format);					\
+		printf("%s:FAIL:%s ", __func__, tag);			\
+		printf(format);						\
 	} else {							\
 		pass_cnt++;						\
-		test__printf("%s:PASS:%s %d nsec\n",			\
-			      __func__, tag, duration);			\
+		printf("%s:PASS:%s %d nsec\n",				\
+		       __func__, tag, duration);			\
 	}								\
 	__ret;								\
 })
-- 
2.22.0.770.g0f2c4a37fd-goog

