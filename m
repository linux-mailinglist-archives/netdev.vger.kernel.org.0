Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC2331DDEE3
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 06:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727995AbgEVEZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 00:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726286AbgEVEZY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 00:25:24 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 152A9C061A0E;
        Thu, 21 May 2020 21:25:24 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id s10so4435726pgm.0;
        Thu, 21 May 2020 21:25:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=P1MJ05uFAxDfNHMQqVnK1prcFqS5udLDYsJyc1jGlFg=;
        b=n1TWrpNJZmdBlO7ubJPEI57aDbYEJ5DrAAJ7t8xGQ2+ToJc3m3G+dope/ZwK8dEdMk
         tXDEK6sYbh0cPv5VsIqh3xM47k4Lc1wG9JCeQEXczGfF0H4Z+23VtZbnLKXLeExhmXvT
         BEJmgqNA0eppJN+mfM3fGbXZkbOLt51YCAnVOhIR0d2wIt5xFRfcpKYyv4iTfScuafW0
         SzHil8c85fPTGIyBM1K/2Fc6eRjl/Qf+rzyUiei31XAOvC7C7yYcVkYsAxiZNxMMa66C
         YWO4tzcUHkn8RBwTYPwAzuI2wjkcBk6ceBA3niKhi3mfqlj/aensn3tVmD44/CUoeEW8
         K4xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=P1MJ05uFAxDfNHMQqVnK1prcFqS5udLDYsJyc1jGlFg=;
        b=GNbKtoT8gNDGMhRhQWN5DdYNDlZSjw/UanVy0wFgwzTKgdWcqkt2/7cm8xjBqFojVx
         zlkmp0R+T3h5JfY9xrCF/lWSz4b6gFguTUVEjArfj5DVigHE62DgXRfvxbq0/aXlIsh9
         JqwA1+w3tqWCLEfJfVgLgCe8+nZmwhEMHD5R9ZrpyWr+UPikpuS/O5Iu82D80T03Qvx7
         4P9laXva/FbNv+TVs6zOXhzxeZVWwAU6LEr9hgukExkgCOfgAwgvKgpF/IvB+JpRRlr4
         09BqcDuSXvi/UWPeQmn+rOhgLa54Uue9sw57G17SG4bhZ7AFcg1x1d9F9Wln9BFVISWg
         MH2Q==
X-Gm-Message-State: AOAM531gweQsYkQeyUtIULg+FRRsu237ekFGcxORjTWJyHIoo8xz+T2k
        s4tcBTdH0gwErhyiHJB01aVAZRgp
X-Google-Smtp-Source: ABdhPJyqZjwxHNMljaXZ4pOVqBtfS3sZEnlI7EMTkLGcm6YVfoss+FAZbDqR8bwJjgD7Z+94RmIfow==
X-Received: by 2002:a17:90a:714c:: with SMTP id g12mr2293417pjs.31.1590121523641;
        Thu, 21 May 2020 21:25:23 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id g9sm5134354pgj.89.2020.05.21.21.25.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 May 2020 21:25:22 -0700 (PDT)
Subject: [bpf-next PATCH v4 4/5] bpf: selftests,
 add sk_msg helpers load and attach test
From:   John Fastabend <john.fastabend@gmail.com>
To:     yhs@fb.com, andrii.nakryiko@gmail.com, ast@kernel.org,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com, jakub@cloudflare.com, lmb@cloudflare.com
Date:   Thu, 21 May 2020 21:25:06 -0700
Message-ID: <159012150674.14791.15054968668193084791.stgit@john-Precision-5820-Tower>
In-Reply-To: <159012108670.14791.18091717338621259928.stgit@john-Precision-5820-Tower>
References: <159012108670.14791.18091717338621259928.stgit@john-Precision-5820-Tower>
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

