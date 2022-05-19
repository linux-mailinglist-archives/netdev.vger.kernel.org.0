Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 877BF52D6F4
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 17:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240506AbiESPHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 11:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235070AbiESPGo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 11:06:44 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB1482C13F;
        Thu, 19 May 2022 08:06:42 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id v10so5307799pgl.11;
        Thu, 19 May 2022 08:06:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EucD8D1Hopx9myMTmlYjgrvRoh4xz50vqffBCpTlf4s=;
        b=HLb2/gkOCAtGsnmd/tHYpzeQNKrQwcnhkUrQOoA3qLFXMnX9uHH0Xwbjsv0OqX0TuS
         8VWMsmu2QrlHt9/aMusoRbhlCGPlVY62+AQ28zFaOyNMT77Ysiwmkyi3cz60AmUiKmQr
         MK6BY3YhY51Yuv/uTFrnB5APmzMseJUq/2WG2B7h4ebbRkad2HSLU4gBnoGXvCXZxw5E
         vvE+SA6997pIrJOBrHo+kBK6jglT7GpBZIKibhl08djLAEIE1/J73/CGo1v47Me8R9ti
         v0uCTY0JEtRPciErtZ5EzY2tLjpRzX8PSpo64/eOKih5zgPtSXuwYRTv0WeucnkpOEGW
         FAxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EucD8D1Hopx9myMTmlYjgrvRoh4xz50vqffBCpTlf4s=;
        b=DzsNVwgvlmAH2J0RPaNPchrsNIewb1ApVvJYJNTu7sItfj+7/Q4/LXUhmEXoiZ7rZ+
         Hd+alrwloag7eblWOs86whPGz7y2t/7PQePFH+QUx5CHa3SDHVAhjlykp8t7B7LlIDVw
         MSI+DnBfv/GWA9olUiP9rpAyGRzybozRHWCLoT7qOGTPI2U6Y2/6kgpSDJzd9MHFg8/g
         /+NP4JSKnJumPgjgHCM67J2qJqXLacUug+Wne8LA6aOgDWB4wVj/w7V3HrGRbANDEHe+
         1YRiVckN/xZfuox09MYush9rlZRdM7ieyK00f+rQysdVqK3ttsjgl6hr2CaoomNKVdpN
         ZEeg==
X-Gm-Message-State: AOAM5303ut4jQURr4R6CnpSTTte9VNG2vANAZFBkhPnU9ZCoVh7MCEQd
        9BXQCzG6A6l56r2LsZCFXSc=
X-Google-Smtp-Source: ABdhPJwS7q92N95rTBohYsdxSKlwUJWCJnPq9iyzHkSKMq4zkvXpHiLIZMhK9oAL2vGPJpFOZnfAFQ==
X-Received: by 2002:a63:6bc2:0:b0:3c2:13cc:1dec with SMTP id g185-20020a636bc2000000b003c213cc1decmr4316155pgc.263.1652972802133;
        Thu, 19 May 2022 08:06:42 -0700 (PDT)
Received: from localhost.localdomain ([223.212.58.71])
        by smtp.gmail.com with ESMTPSA id n22-20020a056a0007d600b0050dc7628139sm4536687pfu.19.2022.05.19.08.06.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 08:06:41 -0700 (PDT)
From:   Yuntao Wang <ytcoode@gmail.com>
To:     andrii.nakryiko@gmail.com
Cc:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com, jolsa@kernel.org,
        kafai@fb.com, kpsingh@kernel.org, kuifeng@fb.com,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, shuah@kernel.org, songliubraving@fb.com,
        sunyucong@gmail.com, toke@redhat.com, yhs@fb.com, ytcoode@gmail.com
Subject: [PATCH bpf-next v2] selftests/bpf: Add missing trampoline program type to trampoline_count test
Date:   Thu, 19 May 2022 23:06:10 +0800
Message-Id: <20220519150610.601313-1-ytcoode@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <CAEf4BzYr+RZ8A00Yn=Pamt6bk-AmoMyjUHxosgJmrTjkYMhShQ@mail.gmail.com>
References: <CAEf4BzYr+RZ8A00Yn=Pamt6bk-AmoMyjUHxosgJmrTjkYMhShQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the trampoline_count test doesn't include any fmod_ret bpf
programs, fix it to make the test cover all possible trampoline program
types.

Since fmod_ret bpf programs can't be attached to __set_task_comm function,
as it's neither whitelisted for error injection nor a security hook, change
it to bpf_modify_return_test.

This patch also does some other cleanups such as removing duplicate code,
dropping inconsistent comments, etc.

Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
Acked-by: Yonghong Song <yhs@fb.com>
---
v1->v2: call bpf_prog_test_run() to trigger bpf_modify_return_test in kernel

 include/linux/bpf.h                           |   2 +-
 .../bpf/prog_tests/trampoline_count.c         | 134 +++++++-----------
 .../bpf/progs/test_trampoline_count.c         |  16 ++-
 3 files changed, 61 insertions(+), 91 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index c107392b0ba7..cb01f247e05f 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -724,7 +724,7 @@ struct btf_func_model {
 #define BPF_TRAMP_F_RET_FENTRY_RET	BIT(4)
 
 /* Each call __bpf_prog_enter + call bpf_func + call __bpf_prog_exit is ~50
- * bytes on x86.  Pick a number to fit into BPF_IMAGE_SIZE / 2
+ * bytes on x86.
  */
 #define BPF_MAX_TRAMP_LINKS 38
 
diff --git a/tools/testing/selftests/bpf/prog_tests/trampoline_count.c b/tools/testing/selftests/bpf/prog_tests/trampoline_count.c
index 9c795ee52b7b..b0acbda6dbf5 100644
--- a/tools/testing/selftests/bpf/prog_tests/trampoline_count.c
+++ b/tools/testing/selftests/bpf/prog_tests/trampoline_count.c
@@ -1,126 +1,94 @@
 // SPDX-License-Identifier: GPL-2.0-only
 #define _GNU_SOURCE
-#include <sched.h>
-#include <sys/prctl.h>
 #include <test_progs.h>
 
 #define MAX_TRAMP_PROGS 38
 
 struct inst {
 	struct bpf_object *obj;
-	struct bpf_link   *link_fentry;
-	struct bpf_link   *link_fexit;
+	struct bpf_link   *link;
 };
 
-static int test_task_rename(void)
-{
-	int fd, duration = 0, err;
-	char buf[] = "test_overhead";
-
-	fd = open("/proc/self/comm", O_WRONLY|O_TRUNC);
-	if (CHECK(fd < 0, "open /proc", "err %d", errno))
-		return -1;
-	err = write(fd, buf, sizeof(buf));
-	if (err < 0) {
-		CHECK(err < 0, "task rename", "err %d", errno);
-		close(fd);
-		return -1;
-	}
-	close(fd);
-	return 0;
-}
-
-static struct bpf_link *load(struct bpf_object *obj, const char *name)
+static struct bpf_program *load_prog(char *file, char *name, struct inst *inst)
 {
+	struct bpf_object *obj;
 	struct bpf_program *prog;
-	int duration = 0;
+	int err;
+
+	obj = bpf_object__open_file(file, NULL);
+	if (!ASSERT_OK_PTR(obj, "obj_open_file"))
+		return NULL;
+
+	inst->obj = obj;
+
+	err = bpf_object__load(obj);
+	if (!ASSERT_OK(err, "obj_load"))
+		return NULL;
 
 	prog = bpf_object__find_program_by_name(obj, name);
-	if (CHECK(!prog, "find_probe", "prog '%s' not found\n", name))
-		return ERR_PTR(-EINVAL);
-	return bpf_program__attach_trace(prog);
+	if (!ASSERT_OK_PTR(prog, "obj_find_prog"))
+		return NULL;
+
+	return prog;
 }
 
 /* TODO: use different target function to run in concurrent mode */
 void serial_test_trampoline_count(void)
 {
-	const char *fentry_name = "prog1";
-	const char *fexit_name = "prog2";
-	const char *object = "test_trampoline_count.o";
-	struct inst inst[MAX_TRAMP_PROGS] = {};
-	int err, i = 0, duration = 0;
-	struct bpf_object *obj;
+	char *file = "test_trampoline_count.o";
+	char *const progs[] = { "fentry_test", "fmod_ret_test", "fexit_test" };
+	struct inst inst[MAX_TRAMP_PROGS + 1] = {};
+	struct bpf_program *prog;
 	struct bpf_link *link;
-	char comm[16] = {};
+	int prog_fd, err, i;
+	LIBBPF_OPTS(bpf_test_run_opts, opts);
 
 	/* attach 'allowed' trampoline programs */
 	for (i = 0; i < MAX_TRAMP_PROGS; i++) {
-		obj = bpf_object__open_file(object, NULL);
-		if (!ASSERT_OK_PTR(obj, "obj_open_file")) {
-			obj = NULL;
+		prog = load_prog(file, progs[i % ARRAY_SIZE(progs)], &inst[i]);
+		if (!prog)
 			goto cleanup;
-		}
 
-		err = bpf_object__load(obj);
-		if (CHECK(err, "obj_load", "err %d\n", err))
+		link = bpf_program__attach(prog);
+		if (!ASSERT_OK_PTR(link, "attach_prog"))
 			goto cleanup;
-		inst[i].obj = obj;
-		obj = NULL;
-
-		if (rand() % 2) {
-			link = load(inst[i].obj, fentry_name);
-			if (!ASSERT_OK_PTR(link, "attach_prog")) {
-				link = NULL;
-				goto cleanup;
-			}
-			inst[i].link_fentry = link;
-		} else {
-			link = load(inst[i].obj, fexit_name);
-			if (!ASSERT_OK_PTR(link, "attach_prog")) {
-				link = NULL;
-				goto cleanup;
-			}
-			inst[i].link_fexit = link;
-		}
+
+		inst[i].link = link;
 	}
 
 	/* and try 1 extra.. */
-	obj = bpf_object__open_file(object, NULL);
-	if (!ASSERT_OK_PTR(obj, "obj_open_file")) {
-		obj = NULL;
+	prog = load_prog(file, "fmod_ret_test", &inst[i]);
+	if (!prog)
 		goto cleanup;
-	}
-
-	err = bpf_object__load(obj);
-	if (CHECK(err, "obj_load", "err %d\n", err))
-		goto cleanup_extra;
 
 	/* ..that needs to fail */
-	link = load(obj, fentry_name);
-	err = libbpf_get_error(link);
-	if (!ASSERT_ERR_PTR(link, "cannot attach over the limit")) {
-		bpf_link__destroy(link);
-		goto cleanup_extra;
+	link = bpf_program__attach(prog);
+	if (!ASSERT_ERR_PTR(link, "attach_prog")) {
+		inst[i].link = link;
+		goto cleanup;
 	}
 
 	/* with E2BIG error */
-	ASSERT_EQ(err, -E2BIG, "proper error check");
-	ASSERT_EQ(link, NULL, "ptr_is_null");
+	if (!ASSERT_EQ(libbpf_get_error(link), -E2BIG, "E2BIG"))
+		goto cleanup;
+	if (!ASSERT_EQ(link, NULL, "ptr_is_null"))
+		goto cleanup;
 
 	/* and finaly execute the probe */
-	if (CHECK_FAIL(prctl(PR_GET_NAME, comm, 0L, 0L, 0L)))
-		goto cleanup_extra;
-	CHECK_FAIL(test_task_rename());
-	CHECK_FAIL(prctl(PR_SET_NAME, comm, 0L, 0L, 0L));
+	prog_fd = bpf_program__fd(prog);
+	if (!ASSERT_GE(prog_fd, 0, "bpf_program__fd"))
+		goto cleanup;
+
+	err = bpf_prog_test_run_opts(prog_fd, &opts);
+	if (!ASSERT_OK(err, "bpf_prog_test_run_opts"))
+		goto cleanup;
+
+	ASSERT_EQ(opts.retval & 0xffff, 4, "bpf_modify_return_test.result");
+	ASSERT_EQ(opts.retval >> 16, 1, "bpf_modify_return_test.side_effect");
 
-cleanup_extra:
-	bpf_object__close(obj);
 cleanup:
-	if (i >= MAX_TRAMP_PROGS)
-		i = MAX_TRAMP_PROGS - 1;
 	for (; i >= 0; i--) {
-		bpf_link__destroy(inst[i].link_fentry);
-		bpf_link__destroy(inst[i].link_fexit);
+		bpf_link__destroy(inst[i].link);
 		bpf_object__close(inst[i].obj);
 	}
 }
diff --git a/tools/testing/selftests/bpf/progs/test_trampoline_count.c b/tools/testing/selftests/bpf/progs/test_trampoline_count.c
index f030e469d05b..7765720da7d5 100644
--- a/tools/testing/selftests/bpf/progs/test_trampoline_count.c
+++ b/tools/testing/selftests/bpf/progs/test_trampoline_count.c
@@ -1,20 +1,22 @@
 // SPDX-License-Identifier: GPL-2.0
-#include <stdbool.h>
-#include <stddef.h>
 #include <linux/bpf.h>
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
 
-struct task_struct;
+SEC("fentry/bpf_modify_return_test")
+int BPF_PROG(fentry_test, int a, int *b)
+{
+	return 0;
+}
 
-SEC("fentry/__set_task_comm")
-int BPF_PROG(prog1, struct task_struct *tsk, const char *buf, bool exec)
+SEC("fmod_ret/bpf_modify_return_test")
+int BPF_PROG(fmod_ret_test, int a, int *b, int ret)
 {
 	return 0;
 }
 
-SEC("fexit/__set_task_comm")
-int BPF_PROG(prog2, struct task_struct *tsk, const char *buf, bool exec)
+SEC("fexit/bpf_modify_return_test")
+int BPF_PROG(fexit_test, int a, int *b, int ret)
 {
 	return 0;
 }
-- 
2.36.1

