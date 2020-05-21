Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 047261DD013
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 16:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729807AbgEUOgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 10:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729803AbgEUOgM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 10:36:12 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4685C061A0E;
        Thu, 21 May 2020 07:36:12 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id x11so1913571plv.9;
        Thu, 21 May 2020 07:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=Aqdq7+lLx+adJ9TsISxEH7PJjD2IvsSgtDZKtoQ6VUI=;
        b=TeaUsMxPT/TSAuSkMFwLM5sYF709Fac5zkWrhqsqVASSLKhqnFg0mc/yFmgNevOwXy
         sQqJfR6uMFrOOASm++zn0ekZmLpzAXM7+sBpnORVPHDFSv7S/aV9+DHcsSDrOz8txjwp
         KWo24AI/rw6DdDkbR65MriPa1MXow1tGTwkF+TJQ1Ii97fd1ICdYSsOTDYmh8l1MhKQr
         xwo2y4SNCdKoeUlRVjWXFiwKFHirzdK4tEdqQF7A9S7y4R+k764tBTauLFPXhboiZLDQ
         Vz4Z2z/qHTR5eWY/vwptUT/q2U5Wc5KlqXsp5OI2Uv3tdEcYyL8O9f5BFs+Ep6PqsqsC
         roGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Aqdq7+lLx+adJ9TsISxEH7PJjD2IvsSgtDZKtoQ6VUI=;
        b=qrD/VLC12b80fQ0s96ajHpOijDDJms/abcrudktPcL+/nKvytJuumdAKR/fCPBD14Y
         erC7Kpb60OZRsQQV+WP15ezOhKdUn/bvf6Xx/wdSPb0hvFhWK2A7BpYnTvWUvKDpvvx/
         lIIee2g2VBUDl1Zrm/v1HTrBs0vsqbeh0WOcJ09X7ItSMorzRh67hokCZ8zDUveAH0O4
         pAnu54IH1e7nZvJVAgqpLglpyH9VncpML2wsv4DOADb3nZKyGc++m6vLz+w53zmnqxoM
         +WOioajiT6UASqpQgkAPqbgCFRA4ekOweGMuPht9c4EctKjBx6JzKcGj5Z7xWvBzAsGq
         AjcQ==
X-Gm-Message-State: AOAM5306S0SJ3BTbgV0n/WQXsPaudpgboNGDKQ7Zz8za0U60sgw/Z2g9
        n3BzWCRmhpFA1GK7X44iB2NRCkhb
X-Google-Smtp-Source: ABdhPJwvFkEBfSWDRWWfhsV6v7/VHuXg9TttOn0/m+/qFXZA/wnCmDi/oLElJuDCr6oKzK3HSOghNw==
X-Received: by 2002:a17:90a:7062:: with SMTP id f89mr11956672pjk.42.1590071772387;
        Thu, 21 May 2020 07:36:12 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id r2sm4813687pfq.194.2020.05.21.07.36.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 May 2020 07:36:11 -0700 (PDT)
Subject: [bpf-next PATCH v3 4/5] bpf: selftests,
 add sk_msg helpers load and attach test
From:   John Fastabend <john.fastabend@gmail.com>
To:     yhs@fb.com, ast@kernel.org, daniel@iogearbox.net
Cc:     lmb@cloudflare.com, bpf@vger.kernel.org, john.fastabend@gmail.com,
        jakub@cloudflare.com, netdev@vger.kernel.org
Date:   Thu, 21 May 2020 07:35:57 -0700
Message-ID: <159007175735.10695.9639519610473734809.stgit@john-Precision-5820-Tower>
In-Reply-To: <159007153289.10695.12380087259405383510.stgit@john-Precision-5820-Tower>
References: <159007153289.10695.12380087259405383510.stgit@john-Precision-5820-Tower>
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
 .../selftests/bpf/prog_tests/sockmap_basic.c       |   57 ++++++++++++++++++++
 .../selftests/bpf/progs/test_skmsg_load_helpers.c  |   48 +++++++++++++++++
 2 files changed, 105 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/test_skmsg_load_helpers.c

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

