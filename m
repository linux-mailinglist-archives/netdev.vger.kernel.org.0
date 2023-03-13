Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 789DA6B867A
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 00:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbjCMX7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 19:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbjCMX7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 19:59:08 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 026397D080;
        Mon, 13 Mar 2023 16:59:03 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id x11so14762112pln.12;
        Mon, 13 Mar 2023 16:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678751943;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nlkU9N2SG/AbcwmYI206kiozQXDShvHpsyCvMGKViBI=;
        b=m6j/Seq56Oc/gUxZIDiLvvmUF/5kygdpl83xVs9abWQaec/G+NFakARqjM6RVU0/Ac
         Ln5A2XKOu90P0WVdkrO614dFB1j7t+Io0ligNOYQ8tXvisNI1/z9ZqNlT7oYI5gNOJXZ
         zeVyCnJtDo7LAdMNgROmRLiWLJBZt0wrNi8tCbptdGuPvBBv3u7taXSYHCwSGgpJE3zO
         mWXm/o93CbWvGcVlo3NDG3wjgcPaPHCkbnbnwdSnAjBX4TIKywGU1Nksf79VFQikSOGI
         8KKtyJoegLNcyrTqo6gnuJl+Wvx7/DaLRHsJNPQyDNxcOygKw34OgVtbusYm7wqOtdGt
         TvRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678751943;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nlkU9N2SG/AbcwmYI206kiozQXDShvHpsyCvMGKViBI=;
        b=q1Nree+TJSGNb8F5ZZqeB0N+9TGGpWpZfB5NwbZiAXOs9CA1oG4uiWflBonq/HlEJv
         MOzPtm1KaRgIXyCm2FiLSQbLRgOSRH6FeKAPOnqp8At3sirK2uhX01RWOEkkXYSGD4V9
         nqkDxHPrlM1F8sp72vNp8RWuLJkJyt+qNE+R++mrPZwu8oKiNlLPRV+p8zoBtqJCXB2M
         TwXp2VUf4ODZuRCJnyXVWbs1LNb0iyvjbrhiJW8s71A/gjId4ftG+BdSGlg6fkUGf5Zu
         +PqwK5AyHeu0YzbXMfm57JlWyhF4VR/R2G28LSUdLTwdOOtgu3a8nHhCoUDauwGZ4o7E
         MYpQ==
X-Gm-Message-State: AO0yUKUUGd4CG/j2gMoIgMJUqe51JjmSUrPSiAIhs9/DLpPzI5Gki0VU
        AO9GkRLz0YvEbcbSSSrG8WU=
X-Google-Smtp-Source: AK7set9TUuW1z2+5+1fYtrk1omDX2eJp1Wa2CLuxI81Q8aIGwTNp/xL3WgJiFXoheU/A1hzZXdFJHw==
X-Received: by 2002:a05:6a20:1448:b0:c7:770a:557f with SMTP id a8-20020a056a20144800b000c7770a557fmr44481039pzi.50.1678751943311;
        Mon, 13 Mar 2023 16:59:03 -0700 (PDT)
Received: from dhcp-172-26-102-232.DHCP.thefacebook.com ([2620:10d:c090:400::5:ad6b])
        by smtp.gmail.com with ESMTPSA id q25-20020a62e119000000b005d6999eec90sm258546pfh.120.2023.03.13.16.59.01
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 13 Mar 2023 16:59:02 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        void@manifault.com, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH bpf-next 3/3] selftests/bpf: Add various tests to check helper access into ptr_to_btf_id.
Date:   Mon, 13 Mar 2023 16:58:45 -0700
Message-Id: <20230313235845.61029-4-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20230313235845.61029-1-alexei.starovoitov@gmail.com>
References: <20230313235845.61029-1-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Add various tests to check helper access into ptr_to_btf_id.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 .../selftests/bpf/progs/task_kfunc_failure.c  | 36 +++++++++++++++++++
 .../selftests/bpf/progs/task_kfunc_success.c  |  4 +++
 2 files changed, 40 insertions(+)

diff --git a/tools/testing/selftests/bpf/progs/task_kfunc_failure.c b/tools/testing/selftests/bpf/progs/task_kfunc_failure.c
index 002c7f69e47f..27994d6b2914 100644
--- a/tools/testing/selftests/bpf/progs/task_kfunc_failure.c
+++ b/tools/testing/selftests/bpf/progs/task_kfunc_failure.c
@@ -301,3 +301,39 @@ int BPF_PROG(task_kfunc_from_lsm_task_free, struct task_struct *task)
 	bpf_task_release(acquired);
 	return 0;
 }
+
+SEC("tp_btf/task_newtask")
+__failure __msg("access beyond the end of member comm")
+int BPF_PROG(task_access_comm1, struct task_struct *task, u64 clone_flags)
+{
+	bpf_strncmp(task->comm, 17, "foo");
+	return 0;
+}
+
+SEC("tp_btf/task_newtask")
+__failure __msg("access beyond the end of member comm")
+int BPF_PROG(task_access_comm2, struct task_struct *task, u64 clone_flags)
+{
+	bpf_strncmp(task->comm + 1, 16, "foo");
+	return 0;
+}
+
+SEC("tp_btf/task_newtask")
+__failure __msg("write into memory")
+int BPF_PROG(task_access_comm3, struct task_struct *task, u64 clone_flags)
+{
+	bpf_probe_read_kernel(task->comm, 16, task->comm);
+	return 0;
+}
+
+SEC("fentry/__set_task_comm")
+__failure __msg("R1 type=ptr_ expected")
+int BPF_PROG(task_access_comm4, struct task_struct *task, const char *buf, bool exec)
+{
+	/*
+	 * task->comm is a legacy ptr_to_btf_id. The verifier cannot guarantee
+	 * its safety. Hence it cannot be accessed with normal load insns.
+	 */
+	bpf_strncmp(task->comm, 16, "foo");
+	return 0;
+}
diff --git a/tools/testing/selftests/bpf/progs/task_kfunc_success.c b/tools/testing/selftests/bpf/progs/task_kfunc_success.c
index aebc4bb14e7d..4f61596b0242 100644
--- a/tools/testing/selftests/bpf/progs/task_kfunc_success.c
+++ b/tools/testing/selftests/bpf/progs/task_kfunc_success.c
@@ -207,6 +207,10 @@ int BPF_PROG(test_task_from_pid_invalid, struct task_struct *task, u64 clone_fla
 	if (!is_test_kfunc_task())
 		return 0;
 
+	bpf_strncmp(task->comm, 12, "foo");
+	bpf_strncmp(task->comm, 16, "foo");
+	bpf_strncmp(&task->comm[8], 4, "foo");
+
 	if (is_pid_lookup_valid(-1)) {
 		err = 1;
 		return 0;
-- 
2.34.1

