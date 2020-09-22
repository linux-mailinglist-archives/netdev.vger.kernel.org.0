Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3556A27484E
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 20:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgIVSjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 14:39:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59788 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726786AbgIVSi6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 14:38:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600799935;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xcr0+UvsflTVbUW44smNMOidT11rijOfD1nExHbIGaQ=;
        b=XQKeqSlih07qW1dH2+D5TXEudq2PO9GPv+UkFMHtZYh4DFxqqt8d9/qvi6MiiLO9vX1j6h
        EXX0dRu8mAgwdTvgzAyw9Hl1N29H6OeaHfzjSxVs0ZbMn/k6auhqhxOcLdn+uLv2d2Ek5I
        0TuF+u88ZBYoIDkWctGyOtP72duSjkk=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-1-P6M69QiCMQC3Oe1dgD34sA-1; Tue, 22 Sep 2020 14:38:54 -0400
X-MC-Unique: P6M69QiCMQC3Oe1dgD34sA-1
Received: by mail-pj1-f71.google.com with SMTP id o11so2961504pjj.9
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 11:38:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Xcr0+UvsflTVbUW44smNMOidT11rijOfD1nExHbIGaQ=;
        b=sxZZyC9ykg7Tni5egdhLUwpypjhYLuyzBIPgFJZMJuVNpvSI/sbxdkvqhnUyiXaxIZ
         1n2eJa1q/QQRNrYnW2Czkuk6h68lSdg0wn8jvG4LKDQcQV80vElgM1gHpaPdv8IeKqAH
         7FzvpntcW1OGRcj3ho3V235Rh7RNDbl2QgknP+br+r8t3HpOieUcc35G2ucJJPNZ1BkP
         8Dps/0opQuIDXEX+ayCBBesccUnb4l7gHPnhAa1kSIXCaMDnHk6W776js5nSja9mVjcq
         TDyliYg4GnhEoHMc0NvFaV3qiwXRJY/Dkq3l08DW19J7XxN92qErUJwOiMyablOseRWY
         UjSw==
X-Gm-Message-State: AOAM530EjZ19HW7FEdAtNPubrw670A+UmHsAxk3rejunLEXHTihTswYY
        GfAiSc7wnRSJ/WZFZYThZIP5o9O3UpfwDQ+n7EPcw7pucZVuTxlUdrDJRhXhyTwLXuZ5haaqsdY
        dZcYc02fjEpUCgRHz
X-Received: by 2002:a62:3786:0:b029:150:e5d9:1e51 with SMTP id e128-20020a6237860000b0290150e5d91e51mr4512842pfa.77.1600799931867;
        Tue, 22 Sep 2020 11:38:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxcvPpYbzvWNUj71bSnIwAL0HS+H2efVEsiAVAWRh9V+qSOPdqVq1cSpTqTokqpY79Lh+l3mg==
X-Received: by 2002:a62:3786:0:b029:150:e5d9:1e51 with SMTP id e128-20020a6237860000b0290150e5d91e51mr4512815pfa.77.1600799931469;
        Tue, 22 Sep 2020 11:38:51 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id l79sm16385916pfd.210.2020.09.22.11.38.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 11:38:50 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id A9834183A90; Tue, 22 Sep 2020 20:38:45 +0200 (CEST)
Subject: [PATCH bpf-next v8 11/11] selftests: Remove fmod_ret from benchmarks
 and test_overhead
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
Date:   Tue, 22 Sep 2020 20:38:45 +0200
Message-ID: <160079992560.8301.11225602391403157558.stgit@toke.dk>
In-Reply-To: <160079991372.8301.10648588027560707258.stgit@toke.dk>
References: <160079991372.8301.10648588027560707258.stgit@toke.dk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

The benchmark code and the test_overhead prog_test included fmod_ret
programs that attached to various functions in the kernel. However, these
functions were never listed as allowed for return modification, so this
only worked because of the verifier skipping tests when a trampoline
already existed for the attach point. Now that the verifier checks have
been fixed, remove fmod_ret from the affected tests so they all work again.

Fixes: 4eaf0b5c5e04 ("selftest/bpf: Fmod_ret prog and implement test_overhead as part of bench")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/testing/selftests/bpf/bench.c                |    5 -----
 tools/testing/selftests/bpf/benchs/bench_rename.c  |   17 -----------------
 tools/testing/selftests/bpf/benchs/bench_trigger.c |   17 -----------------
 .../selftests/bpf/prog_tests/test_overhead.c       |   14 +-------------
 tools/testing/selftests/bpf/progs/test_overhead.c  |    6 ------
 tools/testing/selftests/bpf/progs/trigger_bench.c  |    7 -------
 6 files changed, 1 insertion(+), 65 deletions(-)

diff --git a/tools/testing/selftests/bpf/bench.c b/tools/testing/selftests/bpf/bench.c
index 1a427685a8a8..d1a4a55335f8 100644
--- a/tools/testing/selftests/bpf/bench.c
+++ b/tools/testing/selftests/bpf/bench.c
@@ -311,14 +311,12 @@ extern const struct bench bench_rename_kretprobe;
 extern const struct bench bench_rename_rawtp;
 extern const struct bench bench_rename_fentry;
 extern const struct bench bench_rename_fexit;
-extern const struct bench bench_rename_fmodret;
 extern const struct bench bench_trig_base;
 extern const struct bench bench_trig_tp;
 extern const struct bench bench_trig_rawtp;
 extern const struct bench bench_trig_kprobe;
 extern const struct bench bench_trig_fentry;
 extern const struct bench bench_trig_fentry_sleep;
-extern const struct bench bench_trig_fmodret;
 extern const struct bench bench_rb_libbpf;
 extern const struct bench bench_rb_custom;
 extern const struct bench bench_pb_libbpf;
@@ -333,14 +331,12 @@ static const struct bench *benchs[] = {
 	&bench_rename_rawtp,
 	&bench_rename_fentry,
 	&bench_rename_fexit,
-	&bench_rename_fmodret,
 	&bench_trig_base,
 	&bench_trig_tp,
 	&bench_trig_rawtp,
 	&bench_trig_kprobe,
 	&bench_trig_fentry,
 	&bench_trig_fentry_sleep,
-	&bench_trig_fmodret,
 	&bench_rb_libbpf,
 	&bench_rb_custom,
 	&bench_pb_libbpf,
@@ -464,4 +460,3 @@ int main(int argc, char **argv)
 
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
diff --git a/tools/testing/selftests/bpf/benchs/bench_trigger.c b/tools/testing/selftests/bpf/benchs/bench_trigger.c
index 2a0b6c9885a4..93ab7b280b25 100644
--- a/tools/testing/selftests/bpf/benchs/bench_trigger.c
+++ b/tools/testing/selftests/bpf/benchs/bench_trigger.c
@@ -96,12 +96,6 @@ static void trigger_fentry_sleep_setup()
 	attach_bpf(ctx.skel->progs.bench_trigger_fentry_sleep);
 }
 
-static void trigger_fmodret_setup()
-{
-	setup_ctx();
-	attach_bpf(ctx.skel->progs.bench_trigger_fmodret);
-}
-
 static void *trigger_consumer(void *input)
 {
 	return NULL;
@@ -171,14 +165,3 @@ const struct bench bench_trig_fentry_sleep = {
 	.report_progress = hits_drops_report_progress,
 	.report_final = hits_drops_report_final,
 };
-
-const struct bench bench_trig_fmodret = {
-	.name = "trig-fmodret",
-	.validate = trigger_validate,
-	.setup = trigger_fmodret_setup,
-	.producer_thread = trigger_producer,
-	.consumer_thread = trigger_consumer,
-	.measure = trigger_measure,
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
diff --git a/tools/testing/selftests/bpf/progs/trigger_bench.c b/tools/testing/selftests/bpf/progs/trigger_bench.c
index 9a4d09590b3d..1af23ac0c37c 100644
--- a/tools/testing/selftests/bpf/progs/trigger_bench.c
+++ b/tools/testing/selftests/bpf/progs/trigger_bench.c
@@ -45,10 +45,3 @@ int bench_trigger_fentry_sleep(void *ctx)
 	__sync_add_and_fetch(&hits, 1);
 	return 0;
 }
-
-SEC("fmod_ret/__x64_sys_getpgid")
-int bench_trigger_fmodret(void *ctx)
-{
-	__sync_add_and_fetch(&hits, 1);
-	return -22;
-}

