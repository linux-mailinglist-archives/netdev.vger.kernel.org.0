Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24AAA26CEDC
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 00:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbgIPWi2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 18:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726670AbgIPWiF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 18:38:05 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96C11C06178A
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 15:38:05 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id s9so101831plq.15
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 15:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=JLM5w5hYSsW0qJqRG7+lzcIWvPmux4DmpSItCWGXz70=;
        b=qI7T8dLXOKCOwJwgmjJBLFmkdLXsmVm1HiZ4fVRUOpEXr0ATFrW8sLP7IzvHUwqYE7
         gGLlgVir1Uc1MgDjaOasWtFa2kmKAHBGqZnmoJv6X3fQ11a3Xwy+yRmN5iHFeMD2Aucj
         OGJELx22XZMvLGUcV2sNmxHjTg4XBTKlNt1b7eJe0IZcDC8P5y4swGI3ConDDuLpVPfQ
         o8MrBLm6h/yLrd2Ochr8/Mz12/2ODJS5zKqE0rP7qbcTlJWo+Fe3R6oraCtOgb6RCyWB
         ZFA8dvivblHeDnUbBayFEd8p+GtzA2ErupKN4HAOX5PJWTdY17gvRLWQ9/45k39D8tOh
         tI2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=JLM5w5hYSsW0qJqRG7+lzcIWvPmux4DmpSItCWGXz70=;
        b=HggxKKS9ikAw6jw0p7+dG6gQLGtsGbKCf74n0m1mEzcLS5GosbQys9m06MvZZq4u6Z
         VWGkhSjMZDNVyw6V4T5ZMN2ZyXqmYwvedjKsrByDp+UBkN1+g1N8UpKWIVhRZRxqLf7q
         w9cylsYAKbMhVpjigYNtxXFG+ysDRdXxUxgrURAVlUFnoOUWM7o43qlUvNN2DhK17P6H
         WGJrqags0dICU0uZ/xw5kiceG7jEzGRqOgLQ86ExINRh0j1Eex54TiehurUiEL/XM5+I
         zldi07RyyUXxoUxqZFkZpgBtcwlohxyqP67nO5d/bWKHOSl2/bq0WcJa3mA17KGkY/og
         /DkA==
X-Gm-Message-State: AOAM530y5lsN1xevBqmrTGyfJ6aQbNP3hoVTotO+XbvDtwjQeC4yoZtU
        urK8BE1wJEW57gY9NcswhUd05DJ8N+Rbq29RmaEACG81UNEdVoa1cj9T0jTadO12AzgruFcG8WA
        1Q1qWGsEdCcNq7zehvFOgcunI6cTNEyd1MHXoP4PBDZZTyWU4obyxIliHdrIirg==
X-Google-Smtp-Source: ABdhPJw9SXIdnPt57d5YkKmEbaKIe1Qn3RB78m3mRl3ctmi/pAjjrb1/IoPFyMRXiaObUEN/l95F+JsfCaA=
X-Received: from haoluo.svl.corp.google.com ([2620:15c:2cd:202:f693:9fff:fef4:e444])
 (user=haoluo job=sendgmr) by 2002:a17:902:8c81:b029:d1:f369:1fe4 with SMTP id
 t1-20020a1709028c81b02900d1f3691fe4mr3355071plo.76.1600295884687; Wed, 16 Sep
 2020 15:38:04 -0700 (PDT)
Date:   Wed, 16 Sep 2020 15:35:12 -0700
In-Reply-To: <20200916223512.2885524-1-haoluo@google.com>
Message-Id: <20200916223512.2885524-7-haoluo@google.com>
Mime-Version: 1.0
References: <20200916223512.2885524-1-haoluo@google.com>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
Subject: [PATCH bpf-next v3 6/6] bpf/selftests: Test for bpf_per_cpu_ptr() and bpf_this_cpu_ptr()
From:   Hao Luo <haoluo@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Hao Luo <haoluo@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test bpf_per_cpu_ptr() and bpf_this_cpu_ptr(). Test two paths in the
kernel. If the base pointer points to a struct, the returned reg is
of type PTR_TO_BTF_ID. Direct pointer dereference can be applied on
the returned variable. If the base pointer isn't a struct, the
returned reg is of type PTR_TO_MEM, which also supports direct pointer
dereference.

Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Hao Luo <haoluo@google.com>
---
 .../selftests/bpf/prog_tests/ksyms_btf.c      | 18 +++++++++++
 .../selftests/bpf/progs/test_ksyms_btf.c      | 32 +++++++++++++++++++
 2 files changed, 50 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c b/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
index c6ef06c0629a..28e26bd3e0ca 100644
--- a/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
+++ b/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
@@ -11,6 +11,8 @@ static int duration;
 void test_ksyms_btf(void)
 {
 	__u64 runqueues_addr, bpf_prog_active_addr;
+	__u32 this_rq_cpu;
+	int this_bpf_prog_active;
 	struct test_ksyms_btf *skel = NULL;
 	struct test_ksyms_btf__data *data;
 	struct btf *btf;
@@ -64,6 +66,22 @@ void test_ksyms_btf(void)
 	      (unsigned long long)data->out__bpf_prog_active_addr,
 	      (unsigned long long)bpf_prog_active_addr);
 
+	CHECK(data->out__rq_cpu == -1, "rq_cpu",
+	      "got %u, exp != -1\n", data->out__rq_cpu);
+	CHECK(data->out__bpf_prog_active < 0, "bpf_prog_active",
+	      "got %d, exp >= 0\n", data->out__bpf_prog_active);
+	CHECK(data->out__cpu_0_rq_cpu != 0, "cpu_rq(0)->cpu",
+	      "got %u, exp 0\n", data->out__cpu_0_rq_cpu);
+
+	this_rq_cpu = data->out__this_rq_cpu;
+	CHECK(this_rq_cpu != data->out__rq_cpu, "this_rq_cpu",
+	      "got %u, exp %u\n", this_rq_cpu, data->out__rq_cpu);
+
+	this_bpf_prog_active = data->out__this_bpf_prog_active;
+	CHECK(this_bpf_prog_active != data->out__bpf_prog_active, "this_bpf_prog_active",
+	      "got %d, exp %d\n", this_bpf_prog_active,
+	      data->out__bpf_prog_active);
+
 cleanup:
 	btf__free(btf);
 	test_ksyms_btf__destroy(skel);
diff --git a/tools/testing/selftests/bpf/progs/test_ksyms_btf.c b/tools/testing/selftests/bpf/progs/test_ksyms_btf.c
index 7dde2082131d..bb8ea9270f29 100644
--- a/tools/testing/selftests/bpf/progs/test_ksyms_btf.c
+++ b/tools/testing/selftests/bpf/progs/test_ksyms_btf.c
@@ -8,15 +8,47 @@
 __u64 out__runqueues_addr = -1;
 __u64 out__bpf_prog_active_addr = -1;
 
+__u32 out__rq_cpu = -1; /* percpu struct fields */
+int out__bpf_prog_active = -1; /* percpu int */
+
+__u32 out__this_rq_cpu = -1;
+int out__this_bpf_prog_active = -1;
+
+__u32 out__cpu_0_rq_cpu = -1; /* cpu_rq(0)->cpu */
+
 extern const struct rq runqueues __ksym; /* struct type global var. */
 extern const int bpf_prog_active __ksym; /* int type global var. */
 
 SEC("raw_tp/sys_enter")
 int handler(const void *ctx)
 {
+	struct rq *rq;
+	int *active;
+	__u32 cpu;
+
 	out__runqueues_addr = (__u64)&runqueues;
 	out__bpf_prog_active_addr = (__u64)&bpf_prog_active;
 
+	cpu = bpf_get_smp_processor_id();
+
+	/* test bpf_per_cpu_ptr() */
+	rq = (struct rq *)bpf_per_cpu_ptr(&runqueues, cpu);
+	if (rq)
+		out__rq_cpu = rq->cpu;
+	active = (int *)bpf_per_cpu_ptr(&bpf_prog_active, cpu);
+	if (active)
+		out__bpf_prog_active = *active;
+
+	rq = (struct rq *)bpf_per_cpu_ptr(&runqueues, 0);
+	if (rq) /* should always be valid, but we can't spare the check. */
+		out__cpu_0_rq_cpu = rq->cpu;
+
+	/* test bpf_this_cpu_ptr */
+	rq = (struct rq *)bpf_this_cpu_ptr(&runqueues);
+	out__this_rq_cpu = rq->cpu;
+	active = (int *)bpf_this_cpu_ptr(&bpf_prog_active);
+	out__this_bpf_prog_active = *active;
+
 	return 0;
 }
 
-- 
2.28.0.618.gf4bc123cb7-goog

