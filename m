Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF661D5C13
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 00:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbgEOWHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 18:07:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726226AbgEOWHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 18:07:14 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05208C061A0C;
        Fri, 15 May 2020 15:07:14 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id f3so4406090ioj.1;
        Fri, 15 May 2020 15:07:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=57P6zNk9VRKEbYCoGncmEzqStuJNuPNTToulDQComAo=;
        b=YBV7DQLWPq1kGY6bkodhpKjsaUNmMxw0DSLFrdgd+sFphf5WPUWNZXW8dmINzJp+EG
         4X1K702cX5c/tqO+PttZQqhk42CYbrGsIe2rQEeiiWufVvLJ+lWrwYidH9t9O5XimD0h
         X72kTkIq8pKUKb/0ITvDwg8PfChNNF3tb691Wk0OBF06cZP+FunqQFXumA3TcOOx0teI
         1e/1233loTB/Efr7c7Lla9XpNEuQb03pqHTq2jYo1eShAqdtDTJhjpINWGIsRFLUKODW
         tnTvOB3MdSrsE3iCGdINoti0KOxjGTmPcYXM43DMV3WndPZxzwA7LhcS0dQY0M1fJaIF
         QJcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=57P6zNk9VRKEbYCoGncmEzqStuJNuPNTToulDQComAo=;
        b=JW2ITNSwLUOlZq1zt7ZtaUYCMneb8gYcq94eoIYGUp6IyVVobE4h5LjcnuvQ0oAxJA
         8om2NVJOCKGQsXXJNDTZZKhIgMzZXxuO/+66MbEnKZDCTg8inty+5MBvNSZWQJ5O6sWg
         2lugPgE62OfUsFweG3o1cikCKnis8Ckw6m1w9ol1lQt3T1AI/wg0Lg4reZmRmagwWpb7
         FlUpI1c5PRMCrKXjn4hbdISrrxqQDPD1T+6l+/g8PrcqOJClcrdNl45UAX201x/VJl2b
         WrPkTcHrWFUoZXhw1zsmoRMMN2QHqHHARzFPIIc/Zwng1EM4wfh2DZIIfqZ+jHnJqmEN
         /7vA==
X-Gm-Message-State: AOAM5310+JzQCrk4wZpp/RLPpqEilaCd3fwY5v7jQSpikqWuD518kTsZ
        LZXVf6+ipgVMzOxsLPWc7yo=
X-Google-Smtp-Source: ABdhPJwCmp/M422Dajxxjn5HjCey1xk7T3QYypoec41xnc+VOqeedzBgyuf273Sr+5C21q7zWejUdw==
X-Received: by 2002:a05:6602:2dca:: with SMTP id l10mr4839032iow.163.1589580433395;
        Fri, 15 May 2020 15:07:13 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id z24sm757901ioe.18.2020.05.15.15.07.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 May 2020 15:07:12 -0700 (PDT)
Subject: [bpf-next PATCH v2 4/5] bpf: selftests,
 add sk_msg helpers load and attach test
From:   John Fastabend <john.fastabend@gmail.com>
To:     yhs@fb.com, ast@kernel.org, daniel@iogearbox.net
Cc:     lmb@cloudflare.com, bpf@vger.kernel.org, john.fastabend@gmail.com,
        jakub@cloudflare.com, netdev@vger.kernel.org
Date:   Fri, 15 May 2020 15:06:58 -0700
Message-ID: <158958041855.12532.1433164462914547063.stgit@john-Precision-5820-Tower>
In-Reply-To: <158958022865.12532.5430684453474460041.stgit@john-Precision-5820-Tower>
References: <158958022865.12532.5430684453474460041.stgit@john-Precision-5820-Tower>
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
 tools/include/uapi/linux/bpf.h                     |    2 +
 .../selftests/bpf/prog_tests/sockmap_basic.c       |   57 ++++++++++++++++++++
 .../selftests/bpf/progs/test_skmsg_load_helpers.c  |   48 +++++++++++++++++
 3 files changed, 107 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/test_skmsg_load_helpers.c

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 146c742..b95bb16 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3641,6 +3641,8 @@ struct sk_msg_md {
 	__u32 remote_port;	/* Stored in network byte order */
 	__u32 local_port;	/* stored in host byte order */
 	__u32 size;		/* Total size of sk_msg */
+
+	__bpf_md_ptr(struct bpf_sock *, sk); /* current socket */
 };
 
 struct sk_reuseport_md {
diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
index aa43e0b..cacb4ad 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
@@ -1,13 +1,46 @@
 // SPDX-License-Identifier: GPL-2.0
 // Copyright (c) 2020 Cloudflare
+#include <error.h>
 
 #include "test_progs.h"
+#include "test_skmsg_load_helpers.skel.h"
 
 #define TCP_REPAIR		19	/* TCP sock is under repair right now */
 
 #define TCP_REPAIR_ON		1
 #define TCP_REPAIR_OFF_NO_WP	-1	/* Turn off without window probes */
 
+#define _FAIL(errnum, fmt...)                                                  \
+	({                                                                     \
+		error_at_line(0, (errnum), __func__, __LINE__, fmt);           \
+		CHECK_FAIL(true);                                              \
+	})
+#define FAIL(fmt...) _FAIL(0, fmt)
+#define FAIL_ERRNO(fmt...) _FAIL(errno, fmt)
+#define FAIL_LIBBPF(err, msg)                                                  \
+	({                                                                     \
+		char __buf[MAX_STRERR_LEN];                                    \
+		libbpf_strerror((err), __buf, sizeof(__buf));                  \
+		FAIL("%s: %s", (msg), __buf);                                  \
+	})
+
+#define xbpf_prog_attach(prog, target, type, flags)                            \
+	({                                                                     \
+		int __ret =                                                    \
+			bpf_prog_attach((prog), (target), (type), (flags));    \
+		if (__ret == -1)                                               \
+			FAIL_ERRNO("prog_attach(" #type ")");                  \
+		__ret;                                                         \
+	})
+
+#define xbpf_prog_detach2(prog, target, type)                                  \
+	({                                                                     \
+		int __ret = bpf_prog_detach2((prog), (target), (type));        \
+		if (__ret == -1)                                               \
+			FAIL_ERRNO("prog_detach2(" #type ")");                 \
+		__ret;                                                         \
+	})
+
 static int connected_socket_v4(void)
 {
 	struct sockaddr_in addr = {
@@ -70,10 +103,34 @@ static void test_sockmap_create_update_free(enum bpf_map_type map_type)
 	close(s);
 }
 
+static void test_skmsg_helpers(enum bpf_map_type map_type)
+{
+	struct test_skmsg_load_helpers *skel;
+	int err, map, verdict;
+
+	skel = test_skmsg_load_helpers__open_and_load();
+	if (!skel) {
+		FAIL("skeleton open/load failed");
+		return;
+	}
+
+	verdict = bpf_program__fd(skel->progs.prog_msg_verdict);
+	map = bpf_map__fd(skel->maps.sock_map);
+
+	err = xbpf_prog_attach(verdict, map, BPF_SK_MSG_VERDICT, 0);
+	if (err)
+		return;
+	xbpf_prog_detach2(verdict, map, BPF_SK_MSG_VERDICT);
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
index 0000000..b68eb6c
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_skmsg_load_helpers.c
@@ -0,0 +1,48 @@
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
+int _version SEC("version") = 1;
+char _license[] SEC("license") = "GPL";

