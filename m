Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7871917D3
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 18:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbgCXRju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 13:39:50 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41379 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727223AbgCXRju (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 13:39:50 -0400
Received: by mail-pg1-f193.google.com with SMTP id b1so9376347pgm.8;
        Tue, 24 Mar 2020 10:39:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=JtO83ZOEmpDTgyFaqWGVdceCzq4R0vbr8mPKFhkjTNs=;
        b=nfvuE4nSrcAn5exWiIFY9djR8WDtzwpIH1hwDqYVMJNJFdxYWEi4WjJcSUTGXsxmLK
         Uf/67SJQXp/6hUFgFjTF4v4SQrvvf0T2MlbpqeiVVxrgm/o5wJyehKPnErpBRkXKHfdi
         EfzoqqXvBuHaqVu5N3MNdDgC8lZx8XRJAae3Re6/dAZkdAWnTvt8bo/3986KxqFQuy/W
         0vNh2kqQSpZSMHeUqS2vDP9MEnebkECc/eJs5Alct8jwetTj7JkLprgaK4BqzMf14Vkh
         2JxH7aOvDpJ8oyKYvla+WbTVFVaI8uGAfjY062ZzU2cKZSi0YnYqEiqXGhmRyUtBOz8O
         YXUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=JtO83ZOEmpDTgyFaqWGVdceCzq4R0vbr8mPKFhkjTNs=;
        b=qMyZoZxAoDKtOXlHZvY5AVylK8TLR+rOnHq/+bj9y4RzA3XZbPHzHCs6cj0brD3BoO
         EyzhOrnfDlz2dBU8sqLD3ZCpTZat36SXXtEcIpjl/Z341mldsQJw4i75mvciUaNspyNa
         9xgTAgHzkdmBzpzzwhcLyIsjewLWR8ZBAyXg4V+APGVBQkYU8ERvSNgcDnP0n8VSII1/
         demjk4kMN7zjAMAtEgC6LljctiILk+zZXMrfcOZFsOtCm6Xylj9NSgPJkwznDKXMk3rL
         YUlPQ3SmZSLthRpxiIic4cst3bj+pV82WL4AU+z28QUD2WIVkhAYYU/9L6HAGQTboAdy
         UBXQ==
X-Gm-Message-State: ANhLgQ3JRK1J888q5p+CeK03xJ3n9CUwWr6ZF+K7quRxedULPLJ3FDdv
        NdmQHbwsus2NnC8Ue2Z8VV4=
X-Google-Smtp-Source: ADFU+vt/Axe4Zmj+hAQKE5AUQHabqC5TgU1tV0+prvbpd9LOFHUS0JhU1+awD4Vti8Q3JFyE3d0dJA==
X-Received: by 2002:aa7:94a5:: with SMTP id a5mr31276990pfl.67.1585071588793;
        Tue, 24 Mar 2020 10:39:48 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id z6sm16411239pfn.212.2020.03.24.10.39.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Mar 2020 10:39:48 -0700 (PDT)
Subject: [bpf-next PATCH 06/10] bpf: test_progs,
 add test to catch retval refine error handling
From:   John Fastabend <john.fastabend@gmail.com>
To:     ecree@solarflare.com, yhs@fb.com, alexei.starovoitov@gmail.com,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Tue, 24 Mar 2020 10:39:36 -0700
Message-ID: <158507157618.15666.3720338936586861726.stgit@john-Precision-5820-Tower>
In-Reply-To: <158507130343.15666.8018068546764556975.stgit@john-Precision-5820-Tower>
References: <158507130343.15666.8018068546764556975.stgit@john-Precision-5820-Tower>
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

