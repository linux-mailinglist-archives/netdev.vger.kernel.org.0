Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA2631E74F6
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 06:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbgE2Eiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 00:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbgE2Eiv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 00:38:51 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E165C08C5C8;
        Thu, 28 May 2020 21:38:50 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id p30so760596pgl.11;
        Thu, 28 May 2020 21:38:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=plPcOGJkngUHvZULyPr9+E00356bjfIfQWtyn5pM3iU=;
        b=oFoHjG4Nx5pHh+tFBgaX601DZrDZUiiRHLEpb4RRSnj6D4sDXuFryf3+yxkcbawtWj
         /w2qJMBZpIsIeWMXhGGJxrLai4BPz/wd+3A3cyS0F2/9o6fubvJNo8bc5t8grMc/whq9
         Md5Vd1VAvUntyVGsyEKf19q0dIK5Hng1QMQ6XxI9x0Vd+pOGcTP6mQx1UiNYhO4YTXzN
         RzSIN7uqesiEfsVQXpq6X2W27C9zEup+X0N0sJJnS7I9nwdX3pjLGiAJon8VyamWorh2
         e8B/6LMvR8naNKm5CX8E4faM0s9PjmG156GQnV2uxMyo7aYqLaBWolqJE2SRR0n3zp/8
         +2vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=plPcOGJkngUHvZULyPr9+E00356bjfIfQWtyn5pM3iU=;
        b=VV8XTK9Lnk4nXEz00mkiVCFsWRLtbEdVrKNCe3M1E7gcoADO26FXBVvE5KRbDiIC8a
         bbNxVRLtDgzemP+19gvEHwE+BwXwCOZjfE/VyqbtgTFeanD66q36OIEGTraZ1pu+EE7O
         YLE4iwtjG2ohfUQ82ZbZtpFcADLaWcaRG7BJmNTIBdH/1JGVsDHPkyL7/NfIhXf7/fpe
         7X/UkHaYTAvbplA0XbZLIE47PPIKydcAUdyXnks9y4ctd3hO/O/JX69mXA4ZwJVI9zOp
         v30z7n/ir+e9ASGt3slM9R0LLHk5Cx7abV3qMgKyScAj9RaIy1Ptm4aJKGqYsXHwTdck
         n/Vw==
X-Gm-Message-State: AOAM530QLADI+kGxtqUE9yIxM+czyTBdbavDWTR8pPU9CwRQhC6IXlTq
        06b1YJag9aWuSCXztq5h7FUbNPpP
X-Google-Smtp-Source: ABdhPJw5CP1k8d/s5ZCzF+u7ssqAxEYFuPcqRtSiNJ320PucaPKiEpxqzVgq1dLpNnrHYHJJ5wMSFw==
X-Received: by 2002:a63:af5c:: with SMTP id s28mr6459185pgo.380.1590727129654;
        Thu, 28 May 2020 21:38:49 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id w73sm6288777pfd.113.2020.05.28.21.38.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 28 May 2020 21:38:48 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH v2 bpf-next 4/4] selftests/bpf: basic sleepable tests
Date:   Thu, 28 May 2020 21:38:39 -0700
Message-Id: <20200529043839.15824-5-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20200529043839.15824-1-alexei.starovoitov@gmail.com>
References: <20200529043839.15824-1-alexei.starovoitov@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Modify few tests to sanity test sleepable bpf functionality.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: KP Singh <kpsingh@google.com>
---
 tools/testing/selftests/bpf/bench.c             |  2 ++
 .../selftests/bpf/benchs/bench_trigger.c        | 17 +++++++++++++++++
 tools/testing/selftests/bpf/progs/lsm.c         |  9 +++++++--
 .../testing/selftests/bpf/progs/trigger_bench.c |  7 +++++++
 4 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/bench.c b/tools/testing/selftests/bpf/bench.c
index 14390689ef90..f6a75cd47f01 100644
--- a/tools/testing/selftests/bpf/bench.c
+++ b/tools/testing/selftests/bpf/bench.c
@@ -309,6 +309,7 @@ extern const struct bench bench_trig_tp;
 extern const struct bench bench_trig_rawtp;
 extern const struct bench bench_trig_kprobe;
 extern const struct bench bench_trig_fentry;
+extern const struct bench bench_trig_fentry_sleep;
 extern const struct bench bench_trig_fmodret;
 
 static const struct bench *benchs[] = {
@@ -326,6 +327,7 @@ static const struct bench *benchs[] = {
 	&bench_trig_rawtp,
 	&bench_trig_kprobe,
 	&bench_trig_fentry,
+	&bench_trig_fentry_sleep,
 	&bench_trig_fmodret,
 };
 
diff --git a/tools/testing/selftests/bpf/benchs/bench_trigger.c b/tools/testing/selftests/bpf/benchs/bench_trigger.c
index 49c22832f216..2a0b6c9885a4 100644
--- a/tools/testing/selftests/bpf/benchs/bench_trigger.c
+++ b/tools/testing/selftests/bpf/benchs/bench_trigger.c
@@ -90,6 +90,12 @@ static void trigger_fentry_setup()
 	attach_bpf(ctx.skel->progs.bench_trigger_fentry);
 }
 
+static void trigger_fentry_sleep_setup()
+{
+	setup_ctx();
+	attach_bpf(ctx.skel->progs.bench_trigger_fentry_sleep);
+}
+
 static void trigger_fmodret_setup()
 {
 	setup_ctx();
@@ -155,6 +161,17 @@ const struct bench bench_trig_fentry = {
 	.report_final = hits_drops_report_final,
 };
 
+const struct bench bench_trig_fentry_sleep = {
+	.name = "trig-fentry-sleep",
+	.validate = trigger_validate,
+	.setup = trigger_fentry_sleep_setup,
+	.producer_thread = trigger_producer,
+	.consumer_thread = trigger_consumer,
+	.measure = trigger_measure,
+	.report_progress = hits_drops_report_progress,
+	.report_final = hits_drops_report_final,
+};
+
 const struct bench bench_trig_fmodret = {
 	.name = "trig-fmodret",
 	.validate = trigger_validate,
diff --git a/tools/testing/selftests/bpf/progs/lsm.c b/tools/testing/selftests/bpf/progs/lsm.c
index b4598d4bc4f7..de03ac37d5ee 100644
--- a/tools/testing/selftests/bpf/progs/lsm.c
+++ b/tools/testing/selftests/bpf/progs/lsm.c
@@ -15,7 +15,7 @@ int monitored_pid = 0;
 int mprotect_count = 0;
 int bprm_count = 0;
 
-SEC("lsm/file_mprotect")
+SEC("lsm.s/file_mprotect")
 int BPF_PROG(test_int_hook, struct vm_area_struct *vma,
 	     unsigned long reqprot, unsigned long prot, int ret)
 {
@@ -36,7 +36,7 @@ int BPF_PROG(test_int_hook, struct vm_area_struct *vma,
 	return ret;
 }
 
-SEC("lsm/bprm_committed_creds")
+SEC("lsm.s/bprm_committed_creds")
 int BPF_PROG(test_void_hook, struct linux_binprm *bprm)
 {
 	__u32 pid = bpf_get_current_pid_tgid() >> 32;
@@ -46,3 +46,8 @@ int BPF_PROG(test_void_hook, struct linux_binprm *bprm)
 
 	return 0;
 }
+SEC("lsm/task_free") /* lsm/ is ok, lsm.s/ fails */
+int BPF_PROG(test_task_free, struct task_struct *task)
+{
+	return 0;
+}
diff --git a/tools/testing/selftests/bpf/progs/trigger_bench.c b/tools/testing/selftests/bpf/progs/trigger_bench.c
index 8b36b6640e7e..9a4d09590b3d 100644
--- a/tools/testing/selftests/bpf/progs/trigger_bench.c
+++ b/tools/testing/selftests/bpf/progs/trigger_bench.c
@@ -39,6 +39,13 @@ int bench_trigger_fentry(void *ctx)
 	return 0;
 }
 
+SEC("fentry.s/__x64_sys_getpgid")
+int bench_trigger_fentry_sleep(void *ctx)
+{
+	__sync_add_and_fetch(&hits, 1);
+	return 0;
+}
+
 SEC("fmod_ret/__x64_sys_getpgid")
 int bench_trigger_fmodret(void *ctx)
 {
-- 
2.23.0

