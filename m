Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9F8994DBA
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 21:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728409AbfHSTSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 15:18:05 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:41199 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728398AbfHSTSD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 15:18:03 -0400
Received: by mail-pg1-f202.google.com with SMTP id b18so3130144pgg.8
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 12:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=VTfes5EE6SjuBV3qP4ngRecz5KbbMAO8MyqjhFcnQlk=;
        b=cLWrvRIPV/g/z2CIUlBAvjAmYngAK0bHS0116eH6XMbYwa0RHpWCOwHWhI6NjdC7PX
         tatVoK+PUj+ylsKzeCcnra5gTzyNxaqHSgm0mybvtFEGG7/RW8+/c8H7ac7RP8S5ZK3u
         FhVqUYaz6XzytvoJcVxafRzBeV/H8lbR27SN74c//ddcIxmGCAqHUtmr7lkEFUiFd/ky
         qQ5Q8JZLjoN6G2IPfJfi+oYA8WeBfTjHRuKuUKZkmOmJBp9LIPY1otx2T25bIo9VjVtM
         PhMk7XgyrZe/GtlvOBhiaz9MBnj9h+boNAUlbJfnpAwWDuT551ozzsLmvBl4I4uykmbR
         4b4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=VTfes5EE6SjuBV3qP4ngRecz5KbbMAO8MyqjhFcnQlk=;
        b=MBueRGMPZpHK6yKrowUKoMR9D1cGRSOku1kaNtrOaTsRJe8qimFX2+hlP2dSsp0NwG
         DLYMTU0uKCgn1gLCaCVKvtF+5Nqr8dzdPtF9JFFpq5W/afIMy3JhciOCNPjNlYQKyU+a
         zA0HZvTe7xnqU3n6rtVT5+T/uz3gvX0QUPuLG2WdmCMQtqMY6OgyjGOXDj615LfULqR9
         JNADM5DXrKicKZh6caJMmVWrOf4/Dl9BQ+wi/oOy05D2C2LYd7qePCMkOjTnrk+u8JUa
         S95wUK7WGPgegkbuoAztoxszCwgbStyfZK1ptBh2rF52uYkX6OtkHvXp59Oo/t4lPwzh
         sK/Q==
X-Gm-Message-State: APjAAAVPkM9fNJoiwzo/xnEV0GXHyMikvGJQ1U6IVbg0Z4nxotMaC7NH
        YfOJ8Bjdf2JJTuTJciGC5POA2tAs/VrCxj1cZVGvIy2rS+tva1ImbpiWM6kH0kCwzl37hvKdSQa
        aPqlG3q8JzsI8JVb7OZ2TeBY8tuAJBfcBsvYwHfrlluLqThMVsSW51w==
X-Google-Smtp-Source: APXvYqyuOmMlCTr7mKsIIQmF/gc9Hgzou9nTW6fL5yhS2Iotd8CGs+qeiDCQWUk6NOrRDtNAC0LXOwQ=
X-Received: by 2002:a63:5920:: with SMTP id n32mr20607682pgb.352.1566242282597;
 Mon, 19 Aug 2019 12:18:02 -0700 (PDT)
Date:   Mon, 19 Aug 2019 12:17:51 -0700
In-Reply-To: <20190819191752.241637-1-sdf@google.com>
Message-Id: <20190819191752.241637-4-sdf@google.com>
Mime-Version: 1.0
References: <20190819191752.241637-1-sdf@google.com>
X-Mailer: git-send-email 2.23.0.rc1.153.gdeed80330f-goog
Subject: [PATCH bpf-next v2 3/4] selftests/bpf: test_progs: remove asserts
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
 .../selftests/bpf/prog_tests/bpf_obj_id.c     | 19 +++++++++++-------
 .../selftests/bpf/prog_tests/map_lock.c       | 20 +++++++++++--------
 .../selftests/bpf/prog_tests/spinlock.c       | 12 ++++++-----
 .../bpf/prog_tests/stacktrace_build_id.c      |  7 ++++---
 .../bpf/prog_tests/stacktrace_build_id_nmi.c  |  7 ++++---
 5 files changed, 39 insertions(+), 26 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_obj_id.c b/tools/testing/selftests/bpf/prog_tests/bpf_obj_id.c
index b9d0cd312839..acc2fc046b01 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_obj_id.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_obj_id.c
@@ -48,15 +48,17 @@ void test_bpf_obj_id(void)
 		/* test_obj_id.o is a dumb prog. It should never fail
 		 * to load.
 		 */
-		QCHECK(err);
-		assert(!err);
+		if (QCHECK(err))
+			continue;
 
 		/* Insert a magic value to the map */
 		map_fds[i] = bpf_find_map(__func__, objs[i], "test_map_id");
-		assert(map_fds[i] >= 0);
+		if (QCHECK(map_fds[i] < 0))
+			goto done;
 		err = bpf_map_update_elem(map_fds[i], &array_key,
 					  &array_magic_value, 0);
-		assert(!err);
+		if (QCHECK(err))
+			goto done;
 
 		/* Check getting map info */
 		info_len = sizeof(struct bpf_map_info) * 2;
@@ -95,9 +97,11 @@ void test_bpf_obj_id(void)
 		prog_infos[i].map_ids = ptr_to_u64(map_ids + i);
 		prog_infos[i].nr_map_ids = 2;
 		err = clock_gettime(CLOCK_REALTIME, &real_time_ts);
-		assert(!err);
+		if (QCHECK(err))
+			goto done;
 		err = clock_gettime(CLOCK_BOOTTIME, &boot_time_ts);
-		assert(!err);
+		if (QCHECK(err))
+			goto done;
 		err = bpf_obj_get_info_by_fd(prog_fds[i], &prog_infos[i],
 					     &info_len);
 		load_time = (real_time_ts.tv_sec - boot_time_ts.tv_sec)
@@ -223,7 +227,8 @@ void test_bpf_obj_id(void)
 		nr_id_found++;
 
 		err = bpf_map_lookup_elem(map_fd, &array_key, &array_value);
-		assert(!err);
+		if (QCHECK(err))
+			goto done;
 
 		err = bpf_obj_get_info_by_fd(map_fd, &map_info, &info_len);
 		CHECK(err || info_len != sizeof(struct bpf_map_info) ||
diff --git a/tools/testing/selftests/bpf/prog_tests/map_lock.c b/tools/testing/selftests/bpf/prog_tests/map_lock.c
index c1bddc433a5a..7a12129def9a 100644
--- a/tools/testing/selftests/bpf/prog_tests/map_lock.c
+++ b/tools/testing/selftests/bpf/prog_tests/map_lock.c
@@ -54,17 +54,21 @@ void test_map_lock(void)
 	bpf_map_update_elem(map_fd[0], &key, vars, BPF_F_LOCK);
 
 	for (i = 0; i < 4; i++)
-		assert(pthread_create(&thread_id[i], NULL,
-				      &spin_lock_thread, &prog_fd) == 0);
+		if (QCHECK(pthread_create(&thread_id[i], NULL,
+					  &spin_lock_thread, &prog_fd)))
+			goto close_prog;
 	for (i = 4; i < 6; i++)
-		assert(pthread_create(&thread_id[i], NULL,
-				      &parallel_map_access, &map_fd[i - 4]) == 0);
+		if (QCHECK(pthread_create(&thread_id[i], NULL,
+					  &parallel_map_access, &map_fd[i - 4])))
+			goto close_prog;
 	for (i = 0; i < 4; i++)
-		assert(pthread_join(thread_id[i], &ret) == 0 &&
-		       ret == (void *)&prog_fd);
+		if (QCHECK(pthread_join(thread_id[i], &ret) ||
+			   ret != (void *)&prog_fd))
+			goto close_prog;
 	for (i = 4; i < 6; i++)
-		assert(pthread_join(thread_id[i], &ret) == 0 &&
-		       ret == (void *)&map_fd[i - 4]);
+		if (QCHECK(pthread_join(thread_id[i], &ret) ||
+			   ret != (void *)&map_fd[i - 4]))
+			goto close_prog;
 close_prog:
 	bpf_object__close(obj);
 }
diff --git a/tools/testing/selftests/bpf/prog_tests/spinlock.c b/tools/testing/selftests/bpf/prog_tests/spinlock.c
index e4294a7fdf1a..00b4ed1734e0 100644
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
+		if (QCHECK(pthread_create(&thread_id[i], NULL,
+					  &spin_lock_thread, &prog_fd)))
+			goto close_prog;
 
+	for (i = 0; i < 4; i++)
+		if (QCHECK(pthread_join(thread_id[i], &ret) ||
+			   ret != (void *)&prog_fd))
+			goto close_prog;
 close_prog:
 	bpf_object__close(obj);
 }
diff --git a/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id.c b/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id.c
index ac44fda84833..552e07e7800c 100644
--- a/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id.c
+++ b/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id.c
@@ -51,9 +51,10 @@ void test_stacktrace_build_id(void)
 		  "err %d errno %d\n", err, errno))
 		goto disable_pmu;
 
-	assert(system("dd if=/dev/urandom of=/dev/zero count=4 2> /dev/null")
-	       == 0);
-	assert(system("./urandom_read") == 0);
+	if (QCHECK(system("dd if=/dev/urandom of=/dev/zero count=4 2> /dev/null")))
+		goto disable_pmu;
+	if (QCHECK(system("./urandom_read")))
+		goto disable_pmu;
 	/* disable stack trace collection */
 	key = 0;
 	val = 1;
diff --git a/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c b/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c
index 9557b7dfb782..1553c848edc5 100644
--- a/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c
+++ b/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c
@@ -82,9 +82,10 @@ void test_stacktrace_build_id_nmi(void)
 		  "err %d errno %d\n", err, errno))
 		goto disable_pmu;
 
-	assert(system("dd if=/dev/urandom of=/dev/zero count=4 2> /dev/null")
-	       == 0);
-	assert(system("taskset 0x1 ./urandom_read 100000") == 0);
+	if (QCHECK(system("dd if=/dev/urandom of=/dev/zero count=4 2> /dev/null")))
+		goto disable_pmu;
+	if (QCHECK(system("taskset 0x1 ./urandom_read 100000")))
+		goto disable_pmu;
 	/* disable stack trace collection */
 	key = 0;
 	val = 1;
-- 
2.23.0.rc1.153.gdeed80330f-goog

