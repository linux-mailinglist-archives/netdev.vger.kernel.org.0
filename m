Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 189B1279367
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 23:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbgIYVZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 17:25:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45088 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729699AbgIYVZU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 17:25:20 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601069118;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LboutsSsYu7Eo5wvNL+GmdoAigg8sB4y8G5kV88Hp4I=;
        b=BuaZd/L8yxHlqa/q8yIgLmAlnViyRKGdxvQXOZEdDgI1+OekXQyyzX0AP02TPRKjZa/Rkj
        qU6VD/K9B1mOFNuFR5shbo/iFxaNzRz6ioEUcYV8l+d4NvW3OG3g0whpIKcJqXzePPYAQY
        kcs0YfOdgtAFq5/eMvGf4tQzBM6Xqyc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-302-s3l4LUbJMnKqOm_FrAqRMQ-1; Fri, 25 Sep 2020 17:25:16 -0400
X-MC-Unique: s3l4LUbJMnKqOm_FrAqRMQ-1
Received: by mail-wm1-f72.google.com with SMTP id y18so155280wma.4
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 14:25:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=LboutsSsYu7Eo5wvNL+GmdoAigg8sB4y8G5kV88Hp4I=;
        b=idZGe6tUjA8+dJ2xlvmse9YoNL5lnuB6drT48rznyXvGgFh88c27Jq7e7HWJkSLeRc
         UmE465jCvjL2NV/QGYNWE1HWubIEK/cIN1miT/zWnzzLIS1yxlCZJUXoXMi6FdKK422J
         hJrYM83ES6SFj+fNwOrwiHdcXmoTMLN/nd8y/xsV7flHXvkrW6UHn4PYnI/5HTEX20Y9
         zTdT/TiLtJGEWdoD/J3g/nWBMDIPXwa2FV4YrffBBhMEel3L0vOzkSErR7yvkfDnpQY1
         6CPptxYvcMz7Igj1tvAYSU6Kem0SfiHWFTP4rWGtup9oxc0mKL4ql+1oqX1wDbbzY9Uj
         cuTg==
X-Gm-Message-State: AOAM530uAcZvEwG6eyhnkaWdqkxRzpaw4Em2x7VAiqzMH9Mymy5F2xb5
        wAoKFtC772TRkZU/yVraGcfjrJ7VqACAynyVjI13HzF98KHjrL9xSxrx2b0gZopbPj1nQqsxfYH
        brrVa+TYHSX1mTP+X
X-Received: by 2002:adf:f88b:: with SMTP id u11mr6220609wrp.376.1601069114085;
        Fri, 25 Sep 2020 14:25:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwM7auFpJN1hDjNhgDSRmkB1BvaaAYGtLjJ0OB+E4nxxESEVaWliI0GHJN5XhJ2sQl3odCMYw==
X-Received: by 2002:adf:f88b:: with SMTP id u11mr6220587wrp.376.1601069113707;
        Fri, 25 Sep 2020 14:25:13 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id i83sm320627wma.22.2020.09.25.14.25.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 14:25:11 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 230CE183C5B; Fri, 25 Sep 2020 23:25:11 +0200 (CEST)
Subject: [PATCH bpf-next v9 11/11] selftests: Remove fmod_ret from
 test_overhead
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Fri, 25 Sep 2020 23:25:11 +0200
Message-ID: <160106911110.27725.7635772141267776622.stgit@toke.dk>
In-Reply-To: <160106909952.27725.8383447127582216829.stgit@toke.dk>
References: <160106909952.27725.8383447127582216829.stgit@toke.dk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

The test_overhead prog_test included an fmod_ret program that attached to
__set_task_comm() in the kernel. However, this function was never listed as
allowed for return modification, so this only worked because of the
verifier skipping tests when a trampoline already existed for the attach
point. Now that the verifier checks have been fixed, remove fmod_ret from
the test so it works again.

Fixes: 4eaf0b5c5e04 ("selftest/bpf: Fmod_ret prog and implement test_overhead as part of bench")
Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/testing/selftests/bpf/bench.c                |    3 ---
 tools/testing/selftests/bpf/benchs/bench_rename.c  |   17 -----------------
 .../selftests/bpf/prog_tests/test_overhead.c       |   14 +-------------
 tools/testing/selftests/bpf/progs/test_overhead.c  |    6 ------
 4 files changed, 1 insertion(+), 39 deletions(-)

diff --git a/tools/testing/selftests/bpf/bench.c b/tools/testing/selftests/bpf/bench.c
index 1a427685a8a8..332ed2f7b402 100644
--- a/tools/testing/selftests/bpf/bench.c
+++ b/tools/testing/selftests/bpf/bench.c
@@ -311,7 +311,6 @@ extern const struct bench bench_rename_kretprobe;
 extern const struct bench bench_rename_rawtp;
 extern const struct bench bench_rename_fentry;
 extern const struct bench bench_rename_fexit;
-extern const struct bench bench_rename_fmodret;
 extern const struct bench bench_trig_base;
 extern const struct bench bench_trig_tp;
 extern const struct bench bench_trig_rawtp;
@@ -333,7 +332,6 @@ static const struct bench *benchs[] = {
 	&bench_rename_rawtp,
 	&bench_rename_fentry,
 	&bench_rename_fexit,
-	&bench_rename_fmodret,
 	&bench_trig_base,
 	&bench_trig_tp,
 	&bench_trig_rawtp,
@@ -464,4 +462,3 @@ int main(int argc, char **argv)
 
 	return 0;
 }
-
diff --git a/tools/testing/selftests/bpf/benchs/bench_rename.c b/tools/testing/selftests/bpf/benchs/bench_rename.c
index e74cff40f4fe..a967674098ad 100644
--- a/tools/testing/selftests/bpf/benchs/bench_rename.c
+++ b/tools/testing/selftests/bpf/benchs/bench_rename.c
@@ -106,12 +106,6 @@ static void setup_fexit()
 	attach_bpf(ctx.skel->progs.prog5);
 }
 
-static void setup_fmodret()
-{
-	setup_ctx();
-	attach_bpf(ctx.skel->progs.prog6);
-}
-
 static void *consumer(void *input)
 {
 	return NULL;
@@ -182,14 +176,3 @@ const struct bench bench_rename_fexit = {
 	.report_progress = hits_drops_report_progress,
 	.report_final = hits_drops_report_final,
 };
-
-const struct bench bench_rename_fmodret = {
-	.name = "rename-fmodret",
-	.validate = validate,
-	.setup = setup_fmodret,
-	.producer_thread = producer,
-	.consumer_thread = consumer,
-	.measure = measure,
-	.report_progress = hits_drops_report_progress,
-	.report_final = hits_drops_report_final,
-};
diff --git a/tools/testing/selftests/bpf/prog_tests/test_overhead.c b/tools/testing/selftests/bpf/prog_tests/test_overhead.c
index 2702df2b2343..9966685866fd 100644
--- a/tools/testing/selftests/bpf/prog_tests/test_overhead.c
+++ b/tools/testing/selftests/bpf/prog_tests/test_overhead.c
@@ -61,10 +61,9 @@ void test_test_overhead(void)
 	const char *raw_tp_name = "raw_tp/task_rename";
 	const char *fentry_name = "fentry/__set_task_comm";
 	const char *fexit_name = "fexit/__set_task_comm";
-	const char *fmodret_name = "fmod_ret/__set_task_comm";
 	const char *kprobe_func = "__set_task_comm";
 	struct bpf_program *kprobe_prog, *kretprobe_prog, *raw_tp_prog;
-	struct bpf_program *fentry_prog, *fexit_prog, *fmodret_prog;
+	struct bpf_program *fentry_prog, *fexit_prog;
 	struct bpf_object *obj;
 	struct bpf_link *link;
 	int err, duration = 0;
@@ -97,11 +96,6 @@ void test_test_overhead(void)
 	if (CHECK(!fexit_prog, "find_probe",
 		  "prog '%s' not found\n", fexit_name))
 		goto cleanup;
-	fmodret_prog = bpf_object__find_program_by_title(obj, fmodret_name);
-	if (CHECK(!fmodret_prog, "find_probe",
-		  "prog '%s' not found\n", fmodret_name))
-		goto cleanup;
-
 	err = bpf_object__load(obj);
 	if (CHECK(err, "obj_load", "err %d\n", err))
 		goto cleanup;
@@ -148,12 +142,6 @@ void test_test_overhead(void)
 	test_run("fexit");
 	bpf_link__destroy(link);
 
-	/* attach fmod_ret */
-	link = bpf_program__attach_trace(fmodret_prog);
-	if (CHECK(IS_ERR(link), "attach fmod_ret", "err %ld\n", PTR_ERR(link)))
-		goto cleanup;
-	test_run("fmod_ret");
-	bpf_link__destroy(link);
 cleanup:
 	prctl(PR_SET_NAME, comm, 0L, 0L, 0L);
 	bpf_object__close(obj);
diff --git a/tools/testing/selftests/bpf/progs/test_overhead.c b/tools/testing/selftests/bpf/progs/test_overhead.c
index 42403d088abc..abb7344b531f 100644
--- a/tools/testing/selftests/bpf/progs/test_overhead.c
+++ b/tools/testing/selftests/bpf/progs/test_overhead.c
@@ -39,10 +39,4 @@ int BPF_PROG(prog5, struct task_struct *tsk, const char *buf, bool exec)
 	return 0;
 }
 
-SEC("fmod_ret/__set_task_comm")
-int BPF_PROG(prog6, struct task_struct *tsk, const char *buf, bool exec)
-{
-	return !tsk;
-}
-
 char _license[] SEC("license") = "GPL";

