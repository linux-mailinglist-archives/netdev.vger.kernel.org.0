Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83FFC1E00C0
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 18:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387776AbgEXQvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 12:51:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387726AbgEXQvv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 May 2020 12:51:51 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31C5FC061A0E;
        Sun, 24 May 2020 09:51:51 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id z64so3325557pfb.1;
        Sun, 24 May 2020 09:51:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=P1MJ05uFAxDfNHMQqVnK1prcFqS5udLDYsJyc1jGlFg=;
        b=vVlkubaD3lePujFNIPeSe5q1u1In6QoLx1X5AMofE5Cgn3VlyGktPR9LOHVb3qahwQ
         RhrbPuJsY5qQjiborwMYWLWU2v4/WuXw6SjMc1yQQFNh+LV0nIEB1bRTB1+tjqNCMjYK
         1yHjlQXj4+/5msrn0ctyMs37CVhSIlHJbuY7VbRIMlwvoaV3JX3+5jkN32s1AjfP03f1
         B7bWTeSBpXD+LytEmcuGZAiAl2zy/vSronmk/L1qu5JXOKAJ0sQdCVkTtkYKdCMr3fh+
         LpvdQ975Ph6yW9D2EJuk3mNcsnNABq41YHSTn8ZJev0UO3fyYbzMKAYfIIw/RrMZGQT6
         ghVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=P1MJ05uFAxDfNHMQqVnK1prcFqS5udLDYsJyc1jGlFg=;
        b=l5AweIgMxGsw9vBJULtHPRMRapGwI3LlLoQbFoioPYGtycO4rYBLKfRnKZdOFXsaBG
         HTbHqABkEta+sBUXvvIwW6TKIJq+XM7zuIzoxCJVFPvs/l6pfBCKUnQQxoK/7R8T002l
         eCi3F9KUoYSflH1Ws1CEsFCbA/xEY8wykP4sB/xWSBiIyUcrbgqqh40VyL3ufJlgJR2F
         AJDELrA2mp7JQ+hq+ku2TBhNNA7qQP8qRPsPZIb4hG2FDIktfY3IjZgrqOdNIJicF7Z4
         cSioXky5Z8Y6LqqZJqSauFrTGsrpZVuvSiAhoQDKEF9t9Z0eITCDCXBR2T4rd5X1wyUM
         fjgA==
X-Gm-Message-State: AOAM5311beux7lc4AesG6gKB1QAQVnEiy1omZ30Rt3IvIlUFgOdZ0pUQ
        MZyGwGSqFGnH0x90Nxcu1Wk=
X-Google-Smtp-Source: ABdhPJyJ3n/qmbE1lmwe5QSBAwRG3ksaEMA0M+az/TuMIeiWzgNO3NmU167keHrdNrtKSdSMUsvKIw==
X-Received: by 2002:a62:ed02:: with SMTP id u2mr13717713pfh.60.1590339110757;
        Sun, 24 May 2020 09:51:50 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id l23sm10261865pgc.55.2020.05.24.09.51.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 May 2020 09:51:50 -0700 (PDT)
Subject: [bpf-next PATCH v5 4/5] bpf,
 selftests: add sk_msg helpers load and attach test
From:   John Fastabend <john.fastabend@gmail.com>
To:     yhs@fb.com, andrii.nakryiko@gmail.com, ast@kernel.org,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Sun, 24 May 2020 09:51:36 -0700
Message-ID: <159033909665.12355.6166415847337547879.stgit@john-Precision-5820-Tower>
In-Reply-To: <159033879471.12355.1236562159278890735.stgit@john-Precision-5820-Tower>
References: <159033879471.12355.1236562159278890735.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The test itself is not particularly useful but it encodes a common
pattern we have.

Namely do a sk storage lookup then depending on data here decide if
we need to do more work or alternatively allow packet to PASS. Then
if we need to do more work consult task_struct for more information
about the running task. Finally based on this additional information
drop or pass the data. In this case the suspicious check is not so
realisitic but it encodes the general pattern and uses the helpers
so we test the workflow.

This is a load test to ensure verifier correctly handles this case.

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 .../selftests/bpf/prog_tests/sockmap_basic.c       |   35 +++++++++++++++
 .../selftests/bpf/progs/test_skmsg_load_helpers.c  |   47 ++++++++++++++++++++
 2 files changed, 82 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/test_skmsg_load_helpers.c

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
index aa43e0b..96e7b7f 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
@@ -1,7 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0
 // Copyright (c) 2020 Cloudflare
+#include <error.h>
 
 #include "test_progs.h"
+#include "test_skmsg_load_helpers.skel.h"
 
 #define TCP_REPAIR		19	/* TCP sock is under repair right now */
 
@@ -70,10 +72,43 @@ static void test_sockmap_create_update_free(enum bpf_map_type map_type)
 	close(s);
 }
 
+static void test_skmsg_helpers(enum bpf_map_type map_type)
+{
+	struct test_skmsg_load_helpers *skel;
+	int err, map, verdict;
+
+	skel = test_skmsg_load_helpers__open_and_load();
+	if (CHECK_FAIL(!skel)) {
+		perror("test_skmsg_load_helpers__open_and_load");
+		return;
+	}
+
+	verdict = bpf_program__fd(skel->progs.prog_msg_verdict);
+	map = bpf_map__fd(skel->maps.sock_map);
+
+	err = bpf_prog_attach(verdict, map, BPF_SK_MSG_VERDICT, 0);
+	if (CHECK_FAIL(err)) {
+		perror("bpf_prog_attach");
+		goto out;
+	}
+
+	err = bpf_prog_detach2(verdict, map, BPF_SK_MSG_VERDICT);
+	if (CHECK_FAIL(err)) {
+		perror("bpf_prog_detach2");
+		goto out;
+	}
+out:
+	test_skmsg_load_helpers__destroy(skel);
+}
+
 void test_sockmap_basic(void)
 {
 	if (test__start_subtest("sockmap create_update_free"))
 		test_sockmap_create_update_free(BPF_MAP_TYPE_SOCKMAP);
 	if (test__start_subtest("sockhash create_update_free"))
 		test_sockmap_create_update_free(BPF_MAP_TYPE_SOCKHASH);
+	if (test__start_subtest("sockmap sk_msg load helpers"))
+		test_skmsg_helpers(BPF_MAP_TYPE_SOCKMAP);
+	if (test__start_subtest("sockhash sk_msg load helpers"))
+		test_skmsg_helpers(BPF_MAP_TYPE_SOCKHASH);
 }
diff --git a/tools/testing/selftests/bpf/progs/test_skmsg_load_helpers.c b/tools/testing/selftests/bpf/progs/test_skmsg_load_helpers.c
new file mode 100644
index 0000000..45e8fc7
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_skmsg_load_helpers.c
@@ -0,0 +1,47 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2020 Isovalent, Inc.
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+
+struct {
+	__uint(type, BPF_MAP_TYPE_SOCKMAP);
+	__uint(max_entries, 2);
+	__type(key, __u32);
+	__type(value, __u64);
+} sock_map SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_SOCKHASH);
+	__uint(max_entries, 2);
+	__type(key, __u32);
+	__type(value, __u64);
+} sock_hash SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_SK_STORAGE);
+	__uint(map_flags, BPF_F_NO_PREALLOC);
+	__type(key, __u32);
+	__type(value, __u64);
+} socket_storage SEC(".maps");
+
+SEC("sk_msg")
+int prog_msg_verdict(struct sk_msg_md *msg)
+{
+	struct task_struct *task = (struct task_struct *)bpf_get_current_task();
+	int verdict = SK_PASS;
+	__u32 pid, tpid;
+	__u64 *sk_stg;
+
+	pid = bpf_get_current_pid_tgid() >> 32;
+	sk_stg = bpf_sk_storage_get(&socket_storage, msg->sk, 0, BPF_SK_STORAGE_GET_F_CREATE);
+	if (!sk_stg)
+		return SK_DROP;
+	*sk_stg = pid;
+	bpf_probe_read_kernel(&tpid , sizeof(tpid), &task->tgid);
+	if (pid != tpid)
+		verdict = SK_DROP;
+	bpf_sk_storage_delete(&socket_storage, (void *)msg->sk);
+	return verdict;
+}
+
+char _license[] SEC("license") = "GPL";

