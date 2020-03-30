Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A32901986AA
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 23:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729088AbgC3Vhf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 17:37:35 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:37258 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728471AbgC3Vhf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 17:37:35 -0400
Received: by mail-pj1-f67.google.com with SMTP id o12so174180pjs.2;
        Mon, 30 Mar 2020 14:37:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=JtO83ZOEmpDTgyFaqWGVdceCzq4R0vbr8mPKFhkjTNs=;
        b=GXhWgzq5PErXWV6e86RM5ILaYj47g7s1bxMf4y5vSUpl26DDSaFtH9mqdC36L/Rws4
         4H5QxlEFn1W3P2g+SIsSVvePD07bZ/SkOwhZ8iz0fnc8V9yf7caDVfSwCBY2nfjEeI5Y
         j/QrQH2UWKjsRRte/e9MYq1zczuj+FIWHSTH8hJmUmXk8tJVTIgzPKtZX0Pdf0D0ENnW
         5gyLaGaBkb1VWjeypnaAJLN0LNNOmeR1t4OG1PvH1Ay5dgiYDqJIlUkGvZHCW2ZQqTzb
         b7CLq9UcQXG5zf6hn+7VZqKDxYpkX2VrR7jOLSLO+g9idCFxZ5Jotl1V/lPdN+Kk8Okh
         SAiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=JtO83ZOEmpDTgyFaqWGVdceCzq4R0vbr8mPKFhkjTNs=;
        b=kXkleiKPp4AI1P8UyvkrqgCLb2H4xlUEfYVxh+kP/84WELYC/RKOjizEj7g09xaZ0f
         OzPhidvxb3EY4C71WGs/q0e1waUz0Ttgo5gT01wduWiu24/hDPYIRZSDGm7nNaknydnF
         oB0XGCdinkZA2UxwAiqvqvnRa1MlovdLIKBqSC8qSRyA+fnr1TW6sXVj9TdVolAlTVfk
         vfp5mo/mFwaITgRr/WMjzHS+6HJO2HV/L9xg9U4ZvoNAJm1ZrBDoJLTqAXlV5ClaeOE2
         xnsoh/Ke8ueUXB3xdGntd5HBgbKXhK1OhIekwu8WuNDLcOTkxFJE4BoCx/cNcN0cGZRC
         fMBQ==
X-Gm-Message-State: AGi0PuaPL9cwppZBwQHGsMQB3BsOs1WLe8Ab2SD8L8zm4KRTmbN1Y62O
        rJqfhAV3H9v5MvePYHFban14XFMzMn4=
X-Google-Smtp-Source: APiQypJV+JGAWLrtwrjY3ORYkMq53/GB6nbIvYBWeP6oREQvaAZgxxF/2Ny+2y4616rEkl9cA0G0+g==
X-Received: by 2002:a17:90a:db54:: with SMTP id u20mr157914pjx.140.1585604254142;
        Mon, 30 Mar 2020 14:37:34 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id q8sm402849pjq.28.2020.03.30.14.37.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Mar 2020 14:37:33 -0700 (PDT)
Subject: [bpf-next PATCH v2 4/7] bpf: test_progs,
 add test to catch retval refine error handling
From:   John Fastabend <john.fastabend@gmail.com>
To:     ecree@solarflare.com, yhs@fb.com, alexei.starovoitov@gmail.com,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Mon, 30 Mar 2020 14:37:19 -0700
Message-ID: <158560423908.10843.11783152347709008373.stgit@john-Precision-5820-Tower>
In-Reply-To: <158560409224.10843.3588655801186916301.stgit@john-Precision-5820-Tower>
References: <158560409224.10843.3588655801186916301.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before this series the verifier would clamp return bounds of
bpf_get_stack() to [0, X] and this led the verifier to believe
that a JMP_JSLT 0 would be false and so would prune that path.

The result is anything hidden behind that JSLT would be unverified.
Add a test to catch this case by hiding an goto pc-1 behind the
check which will cause an infinite loop if not rejected.

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 .../selftests/bpf/prog_tests/get_stack_raw_tp.c    |    5 ++++
 .../selftests/bpf/progs/test_get_stack_rawtp_err.c |   26 ++++++++++++++++++++
 2 files changed, 31 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/test_get_stack_rawtp_err.c

diff --git a/tools/testing/selftests/bpf/prog_tests/get_stack_raw_tp.c b/tools/testing/selftests/bpf/prog_tests/get_stack_raw_tp.c
index eba9a97..9257222 100644
--- a/tools/testing/selftests/bpf/prog_tests/get_stack_raw_tp.c
+++ b/tools/testing/selftests/bpf/prog_tests/get_stack_raw_tp.c
@@ -82,6 +82,7 @@ static void get_stack_print_output(void *ctx, int cpu, void *data, __u32 size)
 void test_get_stack_raw_tp(void)
 {
 	const char *file = "./test_get_stack_rawtp.o";
+	const char *file_err = "./test_get_stack_rawtp_err.o";
 	const char *prog_name = "raw_tracepoint/sys_enter";
 	int i, err, prog_fd, exp_cnt = MAX_CNT_RAWTP;
 	struct perf_buffer_opts pb_opts = {};
@@ -93,6 +94,10 @@ void test_get_stack_raw_tp(void)
 	struct bpf_map *map;
 	cpu_set_t cpu_set;
 
+	err = bpf_prog_load(file_err, BPF_PROG_TYPE_RAW_TRACEPOINT, &obj, &prog_fd);
+	if (CHECK(err >= 0, "prog_load raw tp", "err %d errno %d\n", err, errno))
+		return;
+
 	err = bpf_prog_load(file, BPF_PROG_TYPE_RAW_TRACEPOINT, &obj, &prog_fd);
 	if (CHECK(err, "prog_load raw tp", "err %d errno %d\n", err, errno))
 		return;
diff --git a/tools/testing/selftests/bpf/progs/test_get_stack_rawtp_err.c b/tools/testing/selftests/bpf/progs/test_get_stack_rawtp_err.c
new file mode 100644
index 0000000..8941a41
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_get_stack_rawtp_err.c
@@ -0,0 +1,26 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+#define MAX_STACK_RAWTP 10
+
+SEC("raw_tracepoint/sys_enter")
+int bpf_prog2(void *ctx)
+{
+	__u64 stack[MAX_STACK_RAWTP];
+	int error;
+
+	/* set all the flags which should return -EINVAL */
+	error = bpf_get_stack(ctx, stack, 0, -1);
+	if (error < 0)
+		goto loop;
+
+	return error;
+loop:
+	while (1) {
+		error++;
+	}
+}
+
+char _license[] SEC("license") = "GPL";

