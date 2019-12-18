Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C17F6124F88
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 18:38:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727462AbfLRRit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 12:38:49 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45241 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727031AbfLRRit (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 12:38:49 -0500
Received: by mail-pf1-f194.google.com with SMTP id 2so1579894pfg.12;
        Wed, 18 Dec 2019 09:38:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ll2XUGPtS1DGsRu7y7Hq5A+fQ0XX0UH+KolA2vHqi/U=;
        b=cQJeSggR70rBCXPHqVoivz6FWxkUplAQr+SqV+arKhXzuKM4fGvn4B/lGHAQhcwudD
         /jEb+ujVMCXNPggqifD/0V9c28UuoZ2h9oDGOHH9N2IVQoJ0sBUax2DF7JTfT2WVrDjD
         SFY0JvV5ZoFUvTx4eUuMocrwoWF2Mk+RR0LPX4j8+w+E4c3XqxI0IbryVBTvyXJlNBNG
         6zJRmq9kNgY4rCD/Qrl2K+lwTAZm9XBMt/dvb3uMMeovTwj9cQAxdFiEIqgnzt9hFi9f
         E6shDb7ZEeHcC8WKt6ru/n6MVQFH7x4hbqZPRr/7IhAu8J92d2CRnstTc4/0FYYKKMaI
         Jvxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ll2XUGPtS1DGsRu7y7Hq5A+fQ0XX0UH+KolA2vHqi/U=;
        b=Nfst4mKUg3lFqkgdH6C+ssEtzi1+oR4TYYXgZDPWFlgWNfN/hf4Yrfby3FqMWWSCpP
         3GiPEhMpUvbxAOg0hUnttt2fs5p6VfY8Pp25cZMaxEElfGxVpB/j8x5ErtETKYu89nf9
         i/MIEiKbPvEGHCK3VZZTGlLkOGWiuuQBTzie/+Sd4xnWsF4onYB8M7AsIrHWObINN/Gl
         i61JbUKDFTCFheyA+ENRCMUnumGXapeCZa8jluymFjEzXfseBbEer3SprMw2N0eJUfHD
         cJzFWb21ldbCwVZa3BrepcCoHqbe5ItCN5GhHcTZ8inj20jAseFu+yDpiTyeMG9TFMa8
         h0bA==
X-Gm-Message-State: APjAAAWT6y7RyfzKLPPCOeUL7iHDB5198oXu94KqDuStXzeon3W8/vQK
        E869PjJyZqta+mfFtZnxcFApJhAgsNc=
X-Google-Smtp-Source: APXvYqz0F5JLI7Oy7llKdrzKPfe4F8ftkLar9M2Ik5iTZ1b1j+EWhOtydPE4o3FoaCLGwbBiuj7wEg==
X-Received: by 2002:a62:aa09:: with SMTP id e9mr4342927pff.154.1576690727770;
        Wed, 18 Dec 2019 09:38:47 -0800 (PST)
Received: from bpf-kern-dev.byteswizards.com (pc-184-104-160-190.cm.vtr.net. [190.160.104.184])
        by smtp.googlemail.com with ESMTPSA id s15sm3991925pgq.4.2019.12.18.09.38.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 09:38:47 -0800 (PST)
From:   Carlos Neira <cneirabustos@gmail.com>
To:     netdev@vger.kernel.org
Cc:     yhs@fb.com, ebiederm@xmission.com, brouer@redhat.com,
        bpf@vger.kernel.org, cneirabustos@gmail.com
Subject: [PATCH v16 4/5] tools/testing/selftests/bpf: Add self-tests for new helper bpf_get_ns_current_pid_tgid.
Date:   Wed, 18 Dec 2019 14:38:26 -0300
Message-Id: <20191218173827.20584-5-cneirabustos@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191218173827.20584-1-cneirabustos@gmail.com>
References: <20191218173827.20584-1-cneirabustos@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Self tests added for new helper bpf_get_ns_current_pid_tgid

Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
---
 .../bpf/prog_tests/ns_current_pid_tgid.c      | 88 +++++++++++++++++++
 .../bpf/progs/test_ns_current_pid_tgid.c      | 37 ++++++++
 2 files changed, 125 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_ns_current_pid_tgid.c

diff --git a/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c b/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
new file mode 100644
index 000000000000..afd4a19dda14
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
@@ -0,0 +1,88 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019 Carlos Neira cneirabustos@gmail.com */
+#include <test_progs.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <unistd.h>
+#include <sys/syscall.h>
+
+struct bss {
+	__u64 dev;
+	__u64 ino;
+	__u64 pid_tgid;
+	__u64 user_pid_tgid;
+};
+
+void test_ns_current_pid_tgid(void)
+{
+	const char *probe_name = "raw_tracepoint/sys_enter";
+	const char *file = "test_ns_current_pid_tgid.o";
+	int err, key = 0, duration = 0;
+	struct bpf_link *link = NULL;
+	struct bpf_program *prog;
+	struct bpf_map *bss_map;
+	struct bpf_object *obj;
+	struct bss bss;
+	struct stat st;
+	__u64 id;
+
+	obj = bpf_object__open_file(file, NULL);
+	if (CHECK(IS_ERR(obj), "obj_open", "err %ld\n", PTR_ERR(obj)))
+		return;
+
+	err = bpf_object__load(obj);
+	if (CHECK(err, "obj_load", "err %d errno %d\n", err, errno))
+		goto cleanup;
+
+	bss_map = bpf_object__find_map_by_name(obj, "test_ns_.bss");
+	if (CHECK(!bss_map, "find_bss_map", "failed\n"))
+		goto cleanup;
+
+	prog = bpf_object__find_program_by_title(obj, probe_name);
+	if (CHECK(!prog, "find_prog", "prog '%s' not found\n",
+		  probe_name))
+		goto cleanup;
+
+	memset(&bss, 0, sizeof(bss));
+	pid_t tid = syscall(SYS_gettid);
+	pid_t pid = getpid();
+
+	id = (__u64) tid << 32 | pid;
+	bss.user_pid_tgid = id;
+
+	if (CHECK_FAIL(stat("/proc/self/ns/pid", &st))) {
+		perror("Failed to stat /proc/self/ns/pid");
+		goto cleanup;
+	}
+
+	bss.dev = st.st_dev;
+	bss.ino = st.st_ino;
+
+	err = bpf_map_update_elem(bpf_map__fd(bss_map), &key, &bss, 0);
+	if (CHECK(err, "setting_bss", "failed to set bss : %d\n", err))
+		goto cleanup;
+
+	link = bpf_program__attach_raw_tracepoint(prog, "sys_enter");
+	if (CHECK(IS_ERR(link), "attach_raw_tp", "err %ld\n",
+		  PTR_ERR(link))) {
+		link = NULL;
+		goto cleanup;
+	}
+
+	/* trigger some syscalls */
+	usleep(1);
+
+	err = bpf_map_lookup_elem(bpf_map__fd(bss_map), &key, &bss);
+	if (CHECK(err, "set_bss", "failed to get bss : %d\n", err))
+		goto cleanup;
+
+	if (CHECK(id != bss.pid_tgid, "Compare user pid/tgid vs. bpf pid/tgid",
+		  "User pid/tgid %llu BPF pid/tgid %llu\n", id, bss.pid_tgid))
+		goto cleanup;
+cleanup:
+	if (!link) {
+		bpf_link__destroy(link);
+		link = NULL;
+	}
+	bpf_object__close(obj);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_ns_current_pid_tgid.c b/tools/testing/selftests/bpf/progs/test_ns_current_pid_tgid.c
new file mode 100644
index 000000000000..cdb77eb1a4fb
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_ns_current_pid_tgid.c
@@ -0,0 +1,37 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019 Carlos Neira cneirabustos@gmail.com */
+
+#include <linux/bpf.h>
+#include <stdint.h>
+#include "bpf_helpers.h"
+
+static volatile struct {
+	__u64 dev;
+	__u64 ino;
+	__u64 pid_tgid;
+	__u64 user_pid_tgid;
+} res;
+
+SEC("raw_tracepoint/sys_enter")
+int trace(void *ctx)
+{
+	__u64  ns_pid_tgid, expected_pid;
+	struct bpf_pidns_info nsdata;
+	__u32 key = 0;
+
+	if (bpf_get_ns_current_pid_tgid(res.dev, res.ino, &nsdata,
+		   sizeof(struct bpf_pidns_info)))
+		return 0;
+
+	ns_pid_tgid = (__u64)nsdata.tgid << 32 | nsdata.pid;
+	expected_pid = res.user_pid_tgid;
+
+	if (expected_pid != ns_pid_tgid)
+		return 0;
+
+	res.pid_tgid = ns_pid_tgid;
+
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.20.1

