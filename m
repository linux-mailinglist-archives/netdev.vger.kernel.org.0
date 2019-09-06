Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3C0AABBDB
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 17:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732365AbfIFPKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 11:10:30 -0400
Received: from mail-vs1-f43.google.com ([209.85.217.43]:37884 "EHLO
        mail-vs1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726097AbfIFPKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 11:10:30 -0400
Received: by mail-vs1-f43.google.com with SMTP id q9so4277383vsl.4;
        Fri, 06 Sep 2019 08:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=tbLjd0GWnCrkVzbQZwQbrNlcK+9otrffbif6oMZlZqA=;
        b=Jm0MZRQ1w80kn2G1lk0c3Zwo9Zr2ZxhnEbunLzvKiA4rE/CJGkNinM+gcBz1lqtUck
         TpsnUreGtP9FXY738CABEpZoQE42UFHLj+i+pvyGOFMw8Q8vLG/jtnptuXW3yEotTf8f
         FEB59Kr+O50p+N5LL180GCzBuEVy0saN3DbHCfuTWosUzNf/FeMNhqt3eF6ioqfNIh62
         AyRmtZfyBzNuhWsc3HgDLoZi6r7kduS9vKGbDCmwA+GIdOnZ6EHGrvYDAGEbJP0B8Cfw
         E18kCwp5pDw/p6vfQJGHh5cYoo4xQreZUauInn0eFd+w+iZaYfSzXWi/IEZDHFlrWhto
         9DKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=tbLjd0GWnCrkVzbQZwQbrNlcK+9otrffbif6oMZlZqA=;
        b=WmQBHHqCYWi8F/K85JGpL/ABfNLcPHX6O2JWU2jY5zQHgMmkIO7UNu3iSnnt4ZBSIw
         eNV6P4Ozvz6mT7uiOr34fFlA5hTg3QKOo0i8zmzHBHbKlSwDA0TUW9hQAiMWxXLGWIK5
         uO1R0+m4mo6iC2yThrKehj5rjU26IhcvoYkJp0rd8+/qBYnJ0vqFVJLWYAdk27pbMquD
         On3l0AiepEfZJIiTdYWVArKEafU25unq5Xvag9PHKnumjA6qUKxlY0cdGKKein9pMbvx
         WeWKjZYCtlvuNVsbVf5bhl3VREtCCoicFicgXWfwWk14vJ7q/nGGLV/IbqLKbQLXb7q6
         Lh4w==
X-Gm-Message-State: APjAAAXgTo2zHAZSDNKohH8fksb3BBmAHO7zLwu89llHeDJHd62eCvj7
        yIUe2zdiDRf//CqJjiE5VB/lIrr+vmI=
X-Google-Smtp-Source: APXvYqxPnXyOBXSce2IMbXLF+3jllMrlnqDTCINWIghugf3XZB9anfkjYsP4+lTmMjXIAulAFmC+hA==
X-Received: by 2002:a05:6102:86:: with SMTP id t6mr1018127vsp.170.1567782628173;
        Fri, 06 Sep 2019 08:10:28 -0700 (PDT)
Received: from localhost.localdomain ([190.162.109.190])
        by smtp.googlemail.com with ESMTPSA id o15sm4833822vkc.38.2019.09.06.08.10.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 08:10:27 -0700 (PDT)
From:   Carlos Neira <cneirabustos@gmail.com>
To:     netdev@vger.kernel.org
Cc:     yhs@fb.com, ebiederm@xmission.com, brouer@redhat.com,
        cneirabustos@gmail.com, bpf@vger.kernel.org
Subject: [PATCH bpf-next v10 4/4] tools/testing/selftests/bpf: Add self-tests  for helper bpf_get_pidns_info.
Date:   Fri,  6 Sep 2019 11:09:52 -0400
Message-Id: <20190906150952.23066-5-cneirabustos@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190906150952.23066-1-cneirabustos@gmail.com>
References: <20190906150952.23066-1-cneirabustos@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added 2 selftest:

bpf_get_current_pidns_info helper is called in an interrupt
context and also in a non interrupt context.

Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
---
 tools/testing/selftests/bpf/Makefile               |   2 +-
 tools/testing/selftests/bpf/bpf_helpers.h          |   3 +
 .../testing/selftests/bpf/progs/test_pidns_kern.c  |  52 ++++++++
 .../selftests/bpf/progs/test_pidns_nmi_kern.c      |  52 ++++++++
 tools/testing/selftests/bpf/test_pidns.c           | 146 +++++++++++++++++++++
 tools/testing/selftests/bpf/test_pidns_nmi.c       | 139 ++++++++++++++++++++
 6 files changed, 393 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/progs/test_pidns_kern.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_pidns_nmi_kern.c
 create mode 100644 tools/testing/selftests/bpf/test_pidns.c
 create mode 100644 tools/testing/selftests/bpf/test_pidns_nmi.c

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 1faad0c3c3c9..8507c89141f5 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -29,7 +29,7 @@ TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test
 	test_cgroup_storage test_select_reuseport test_section_names \
 	test_netcnt test_tcpnotify_user test_sock_fields test_sysctl test_hashmap \
 	test_btf_dump test_cgroup_attach xdping test_sockopt test_sockopt_sk \
-	test_sockopt_multi test_sockopt_inherit test_tcp_rtt
+	test_sockopt_multi test_sockopt_inherit test_tcp_rtt test_pidns test_pidns_nmi
 
 BPF_OBJ_FILES = $(patsubst %.c,%.o, $(notdir $(wildcard progs/*.c)))
 TEST_GEN_FILES = $(BPF_OBJ_FILES)
diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
index 6c4930bc6e2e..30a70ebe583a 100644
--- a/tools/testing/selftests/bpf/bpf_helpers.h
+++ b/tools/testing/selftests/bpf/bpf_helpers.h
@@ -313,6 +313,9 @@ static unsigned int (*bpf_set_hash)(void *ctx, __u32 hash) =
 static int (*bpf_skb_adjust_room)(void *ctx, __s32 len_diff, __u32 mode,
 				  unsigned long long flags) =
 	(void *) BPF_FUNC_skb_adjust_room;
+static int (*bpf_get_current_pidns_info)(struct bpf_pidns_info *buf,
+					 unsigned int buf_size) =
+	(void *) BPF_FUNC_get_current_pidns_info;
 
 /* Scan the ARCH passed in from ARCH env variable (see Makefile) */
 #if defined(__TARGET_ARCH_x86)
diff --git a/tools/testing/selftests/bpf/progs/test_pidns_kern.c b/tools/testing/selftests/bpf/progs/test_pidns_kern.c
new file mode 100644
index 000000000000..a4c0bde1608b
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_pidns_kern.c
@@ -0,0 +1,52 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2018 Carlos Neira cneirabustos@gmail.com
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of version 2 of the GNU General Public
+ * License as published by the Free Software Foundation.
+ */
+
+#include <linux/bpf.h>
+#include <errno.h>
+#include "bpf_helpers.h"
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, __u32);
+	__type(value, struct bpf_pidns_info);
+} nsidmap SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, __u32);
+	__type(value, __u32);
+} pidmap SEC(".maps");
+
+SEC("tracepoint/syscalls/sys_enter_nanosleep")
+int trace(void *ctx)
+{
+	struct bpf_pidns_info nsinfo;
+	__u32 key = 0, *expected_pid;
+	struct bpf_pidns_info  *val;
+
+	if (bpf_get_current_pidns_info(&nsinfo, sizeof(nsinfo)))
+		return -EINVAL;
+
+	expected_pid = bpf_map_lookup_elem(&pidmap, &key);
+	__u64 tgid = bpf_get_current_pid_tgid();
+
+	if (!expected_pid || *expected_pid != nsinfo.pid ||
+			nsinfo.tgid != (__u32)tgid)
+		return 0;
+
+	val = bpf_map_lookup_elem(&nsidmap, &key);
+	if (val)
+		*val = nsinfo;
+
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
+__u32 _version SEC("version") = 1;
diff --git a/tools/testing/selftests/bpf/progs/test_pidns_nmi_kern.c b/tools/testing/selftests/bpf/progs/test_pidns_nmi_kern.c
new file mode 100644
index 000000000000..7f02e4e29021
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_pidns_nmi_kern.c
@@ -0,0 +1,52 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2018 Carlos Neira cneirabustos@gmail.com
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of version 2 of the GNU General Public
+ * License as published by the Free Software Foundation.
+ */
+
+#include <linux/bpf.h>
+#include <errno.h>
+#include "bpf_helpers.h"
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, __u32);
+	__type(value, struct bpf_pidns_info);
+} nsidmap SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, __u32);
+	__type(value, __u32);
+} pidmap SEC(".maps");
+
+SEC("tracepoint/net/netif_receive_skb")
+int trace(void *ctx)
+{
+	struct bpf_pidns_info nsinfo;
+	__u32 key = 0, *expected_pid;
+	struct bpf_pidns_info  *val;
+
+	if (bpf_get_current_pidns_info(&nsinfo, sizeof(nsinfo)))
+		return -EINVAL;
+
+	expected_pid = bpf_map_lookup_elem(&pidmap, &key);
+	__u64 tgid = bpf_get_current_pid_tgid();
+
+	if (!expected_pid || *expected_pid != nsinfo.pid ||
+			nsinfo.tgid != (__u32)tgid)
+		return 0;
+
+	val = bpf_map_lookup_elem(&nsidmap, &key);
+	if (val)
+		*val = nsinfo;
+
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
+__u32 _version SEC("version") = 1;
diff --git a/tools/testing/selftests/bpf/test_pidns.c b/tools/testing/selftests/bpf/test_pidns.c
new file mode 100644
index 000000000000..0c579305da53
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_pidns.c
@@ -0,0 +1,146 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2018 Carlos Neira cneirabustos@gmail.com
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of version 2 of the GNU General Public
+ * License as published by the Free Software Foundation.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <syscall.h>
+#include <unistd.h>
+#include <linux/perf_event.h>
+#include <sys/ioctl.h>
+#include <sys/time.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+
+#include <linux/bpf.h>
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+
+#include "cgroup_helpers.h"
+#include "bpf_rlimit.h"
+
+#define CHECK(condition, tag, format...) ({		\
+	int __ret = !!(condition);			\
+	if (__ret) {					\
+		printf("%s:FAIL:%s ", __func__, tag);	\
+		printf(format);				\
+	} else {					\
+		printf("%s:PASS:%s\n", __func__, tag);	\
+	}						\
+	__ret;						\
+})
+
+static int bpf_find_map(const char *test, struct bpf_object *obj,
+			const char *name)
+{
+	struct bpf_map *map;
+
+	map = bpf_object__find_map_by_name(obj, name);
+	if (!map)
+		return -1;
+	return bpf_map__fd(map);
+}
+
+
+int main(int argc, char **argv)
+{
+	const char *probe_name = "syscalls/sys_enter_nanosleep";
+	const char *file = "test_pidns_kern.o";
+	int err, bytes, efd, prog_fd, pmu_fd;
+	struct bpf_pidns_info knsid = {};
+	int pidmap_fd, nsidmap_fd;
+	struct perf_event_attr attr = {};
+	struct bpf_object *obj;
+	__u32 key = 0, pid;
+	int exit_code = 1;
+	struct stat st;
+	char buf[256];
+
+	err = bpf_prog_load(file, BPF_PROG_TYPE_TRACEPOINT, &obj, &prog_fd);
+	if (CHECK(err, "bpf_prog_load", "err %d errno %d\n", err, errno))
+		goto cleanup_cgroup_env;
+
+	nsidmap_fd = bpf_find_map(__func__, obj, "nsidmap");
+	if (CHECK(nsidmap_fd < 0, "bpf_find_map", "err %d errno %d\n",
+		  nsidmap_fd, errno))
+		goto close_prog;
+
+	pidmap_fd = bpf_find_map(__func__, obj, "pidmap");
+	if (CHECK(pidmap_fd < 0, "bpf_find_map", "err %d errno %d\n",
+		  pidmap_fd, errno))
+		goto close_prog;
+
+	pid = getpid();
+	bpf_map_update_elem(pidmap_fd, &key, &pid, 0);
+
+	snprintf(buf, sizeof(buf),
+		 "/sys/kernel/debug/tracing/events/%s/id", probe_name);
+	efd = open(buf, O_RDONLY, 0);
+	if (CHECK(efd < 0, "open", "err %d errno %d\n", efd, errno))
+		goto close_prog;
+	bytes = read(efd, buf, sizeof(buf));
+	close(efd);
+	if (CHECK(bytes <= 0 || bytes >= sizeof(buf), "read",
+		  "bytes %d errno %d\n", bytes, errno))
+		goto close_prog;
+
+	attr.config = strtol(buf, NULL, 0);
+	attr.type = PERF_TYPE_TRACEPOINT;
+	attr.sample_type = PERF_SAMPLE_RAW;
+	attr.sample_period = 1;
+	attr.wakeup_events = 1;
+
+	pmu_fd = syscall(__NR_perf_event_open, &attr, getpid(), -1, -1, 0);
+	if (CHECK(pmu_fd < 0, "perf_event_open", "err %d errno %d\n", pmu_fd,
+		  errno))
+		goto close_prog;
+
+	err = ioctl(pmu_fd, PERF_EVENT_IOC_ENABLE, 0);
+	if (CHECK(err, "perf_event_ioc_enable", "err %d errno %d\n", err,
+		  errno))
+		goto close_pmu;
+
+	err = ioctl(pmu_fd, PERF_EVENT_IOC_SET_BPF, prog_fd);
+	if (CHECK(err, "perf_event_ioc_set_bpf", "err %d errno %d\n", err,
+		  errno))
+		goto close_pmu;
+
+	/* trigger some syscalls */
+	sleep(1);
+
+	err = bpf_map_lookup_elem(nsidmap_fd, &key, &knsid);
+	if (CHECK(err, "bpf_map_lookup_elem", "err %d errno %d\n", err, errno))
+		goto close_pmu;
+
+	if (stat("/proc/self/ns/pid", &st))
+		goto close_pmu;
+
+	if (CHECK(knsid.nsid != (__u32) st.st_ino, "namespace id",
+		  "bpf %u user %u\n", knsid.nsid, (__u32) st.st_ino))
+		goto close_pmu;
+
+	if (CHECK(major(knsid.dev) != major(st.st_rdev), "dev major",
+		  "bpf %u user %u\n", major(knsid.dev), major(st.st_rdev)))
+		goto close_pmu;
+
+	if (CHECK(minor(knsid.dev) != minor(st.st_rdev), "dev minor",
+		  "bpf %u user %u\n", minor(knsid.dev), minor(st.st_rdev)))
+		goto close_pmu;
+
+	exit_code = 0;
+	printf("%s:PASS\n", argv[0]);
+
+close_pmu:
+	close(pmu_fd);
+close_prog:
+	bpf_object__close(obj);
+cleanup_cgroup_env:
+	return exit_code;
+}
diff --git a/tools/testing/selftests/bpf/test_pidns_nmi.c b/tools/testing/selftests/bpf/test_pidns_nmi.c
new file mode 100644
index 000000000000..bb8075bbe7d8
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_pidns_nmi.c
@@ -0,0 +1,139 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2018 Carlos Neira cneirabustos@gmail.com
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of version 2 of the GNU General Public
+ * License as published by the Free Software Foundation.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <syscall.h>
+#include <unistd.h>
+#include <linux/perf_event.h>
+#include <sys/ioctl.h>
+#include <sys/time.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+
+#include <linux/bpf.h>
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+
+#include "cgroup_helpers.h"
+#include "bpf_rlimit.h"
+
+#define CHECK(condition, tag, format...) ({		\
+	int __ret = !!(condition);			\
+	if (__ret) {					\
+		printf("%s:FAIL:%s ", __func__, tag);	\
+		printf(format);				\
+	} else {					\
+		printf("%s:PASS:%s\n", __func__, tag);	\
+	}						\
+	__ret;						\
+})
+
+static int bpf_find_map(const char *test, struct bpf_object *obj,
+			const char *name)
+{
+	struct bpf_map *map;
+
+	map = bpf_object__find_map_by_name(obj, name);
+	if (!map)
+		return -1;
+	return bpf_map__fd(map);
+}
+
+
+int main(int argc, char **argv)
+{
+	const char *probe_name = "net/netif_receive_skb";
+	const char *file = "test_pidns_kern.o";
+	int err, bytes, efd, prog_fd, pmu_fd;
+	struct bpf_pidns_info knsid = {};
+	int pidmap_fd, nsidmap_fd;
+	struct perf_event_attr attr = {};
+	struct bpf_object *obj;
+	__u32 key = 0, pid;
+	int exit_code = 1;
+	struct stat st;
+	char buf[256];
+
+	err = bpf_prog_load(file, BPF_PROG_TYPE_TRACEPOINT, &obj, &prog_fd);
+	if (CHECK(err, "bpf_prog_load", "err %d errno %d\n", err, errno))
+		goto cleanup_cgroup_env;
+
+	nsidmap_fd = bpf_find_map(__func__, obj, "nsidmap");
+	if (CHECK(nsidmap_fd < 0, "bpf_find_map", "err %d errno %d\n",
+		  nsidmap_fd, errno))
+		goto close_prog;
+
+	pidmap_fd = bpf_find_map(__func__, obj, "pidmap");
+	if (CHECK(pidmap_fd < 0, "bpf_find_map", "err %d errno %d\n",
+		  pidmap_fd, errno))
+		goto close_prog;
+
+	pid = getpid();
+	bpf_map_update_elem(pidmap_fd, &key, &pid, 0);
+
+	snprintf(buf, sizeof(buf),
+		 "/sys/kernel/debug/tracing/events/%s/id", probe_name);
+	efd = open(buf, O_RDONLY, 0);
+	if (CHECK(efd < 0, "open", "err %d errno %d\n", efd, errno))
+		goto close_prog;
+	bytes = read(efd, buf, sizeof(buf));
+	close(efd);
+	if (CHECK(bytes <= 0 || bytes >= sizeof(buf), "read",
+		  "bytes %d errno %d\n", bytes, errno))
+		goto close_prog;
+
+	attr.config = strtol(buf, NULL, 0);
+	attr.type = PERF_TYPE_TRACEPOINT;
+	attr.sample_type = PERF_SAMPLE_RAW;
+	attr.sample_period = 1;
+	attr.wakeup_events = 1;
+
+	pmu_fd = syscall(__NR_perf_event_open, &attr, getpid(), -1, -1, 0);
+	if (CHECK(pmu_fd < 0, "perf_event_open", "err %d errno %d\n", pmu_fd,
+		  errno))
+		goto close_prog;
+
+	err = ioctl(pmu_fd, PERF_EVENT_IOC_ENABLE, 0);
+	if (CHECK(err, "perf_event_ioc_enable", "err %d errno %d\n", err,
+		  errno))
+		goto close_pmu;
+
+	err = ioctl(pmu_fd, PERF_EVENT_IOC_SET_BPF, prog_fd);
+	if (CHECK(err, "perf_event_ioc_set_bpf", "err %d errno %d\n", err,
+		  errno))
+		goto close_pmu;
+
+	/* trigger some syscalls */
+	sleep(1);
+
+	err = bpf_map_lookup_elem(nsidmap_fd, &key, &knsid);
+	if (CHECK(err, "bpf_map_lookup_elem", "err %d errno %d\n", err, errno))
+		goto close_pmu;
+
+	if (stat("/proc/self/ns/pid", &st))
+		goto close_pmu;
+
+	if (CHECK(knsid.nsid != (__u32) st.st_ino, "namespace_id",
+				"Called in interrupt context bpf %u user %u\n",
+				knsid.nsid, (__u32) st.st_ino))
+		goto close_pmu;
+
+	exit_code = 0;
+	printf("%s:PASS\n", argv[0]);
+
+close_pmu:
+	close(pmu_fd);
+close_prog:
+	bpf_object__close(obj);
+cleanup_cgroup_env:
+	return exit_code;
+}
-- 
2.11.0

