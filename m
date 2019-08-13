Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C28078C109
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 20:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728088AbfHMSsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 14:48:13 -0400
Received: from mail-vs1-f65.google.com ([209.85.217.65]:34045 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727144AbfHMSsM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 14:48:12 -0400
Received: by mail-vs1-f65.google.com with SMTP id b20so7418008vso.1;
        Tue, 13 Aug 2019 11:48:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=B7UxVIJSk+HZzaz/NLS+CiPotut10t0JXTdRJXbCJ3w=;
        b=Xn9FusrfnyRM2jl3Xko2iVFj7paHWXcKmFKh2bzMiFC5t14AN+CPbdp1/OQNPD8X5R
         01vtZSh+Mzbk+4Ka82zC0q8a0nSiWXbTjmL3Aa8Pcg0uqdBZMTFo6uxdHb+HgZQmXcCd
         d7wV0svPCuIanapid76r+rmufxqkSZZvgI52Ps/gHbVHwye32uLRnck7M08b8qSRGX1f
         D/O580JDNVg1GMsCT06H97pve70VmEwb0KNitsic/NhcZAzdrvfjwSVHubddZS+2+090
         +D60sLPOAcV7numKjMeLGz1iQXKNAyCocEe14zBxiDcSjRevamojkbshPOuxisjvQfVo
         nkEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=B7UxVIJSk+HZzaz/NLS+CiPotut10t0JXTdRJXbCJ3w=;
        b=qYATPCoJUxm9HAwBEo/7vKgvmPxz4d5pXDqiOhcYGjV+UIxJLVozKRcXPwWl/34BQu
         4LQMp/tVAGIjcROS9y334uAUgRLceA5BK/c7Lk3TBo9fODnKOfnDXtM1TAVRTdrPxh6X
         IUh6wK91rppy9DQKT9x5zBxi236Bez0vfdl6kPsP3d2kU5+OxePTJwhswW3veU3nCV5N
         z9ONsk9rmZUKuL96/YImlOgqAwHXam7URDSJoHGHvx8k0XJoEs5EqJ+mV5Mjrd3rVu3a
         1R2amUWOgC/8TASrX+zD/x0oHtifdizBpzUnAfom141nF5dZGwCuiGiRRFGpoAvHQ3i5
         8qvQ==
X-Gm-Message-State: APjAAAXZc0yAl0PHrqiQyEpvV2dPCGeMY2h6ciV4O2x6Pgnsp2QOiMGo
        m0y8mrcH+hroFxHJWF3e8CQ/4AakWqZfVQ==
X-Google-Smtp-Source: APXvYqzXlH0GHU7KFtcaNAtGRRwzsysilShCBNhdSczKEkFj3PcDzfop4zQi+g8BMiohyT1+ZXYoSw==
X-Received: by 2002:a67:e886:: with SMTP id x6mr28318483vsn.216.1565722090500;
        Tue, 13 Aug 2019 11:48:10 -0700 (PDT)
Received: from localhost.localdomain ([190.162.109.53])
        by smtp.googlemail.com with ESMTPSA id o9sm71767069vkd.27.2019.08.13.11.48.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Aug 2019 11:48:09 -0700 (PDT)
From:   Carlos Neira <cneirabustos@gmail.com>
To:     netdev@vger.kernel.org
Cc:     yhs@fb.com, ebiederm@xmission.com, brouer@redhat.com,
        cneirabustos@gmail.com, bpf@vger.kernel.org
Subject: [PATCH bpf-next V9 3/3] tools/testing/selftests/bpf: Add self-tests for new helper.
Date:   Tue, 13 Aug 2019 11:47:47 -0700
Message-Id: <20190813184747.12225-4-cneirabustos@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190813184747.12225-1-cneirabustos@gmail.com>
References: <20190813184747.12225-1-cneirabustos@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Carlos <cneirabustos@gmail.com>

Added self-tests for new helper bpf_get_current_pidns_info.

Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
---
 tools/include/uapi/linux/bpf.h                     |  31 ++++-
 tools/testing/selftests/bpf/Makefile               |   2 +-
 tools/testing/selftests/bpf/bpf_helpers.h          |   3 +
 .../testing/selftests/bpf/progs/test_pidns_kern.c  |  51 ++++++++
 tools/testing/selftests/bpf/test_pidns.c           | 138 +++++++++++++++++++++
 5 files changed, 223 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/test_pidns_kern.c
 create mode 100644 tools/testing/selftests/bpf/test_pidns.c

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 4393bd4b2419..db241857ec15 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -2741,6 +2741,28 @@ union bpf_attr {
  *		**-EOPNOTSUPP** kernel configuration does not enable SYN cookies
  *
  *		**-EPROTONOSUPPORT** IP packet version is not 4 or 6
+ *
+ * int bpf_get_current_pidns_info(struct bpf_pidns_info *pidns, u32 size_of_pidns)
+ *	Description
+ *		Copies into *pidns* pid, namespace id and tgid as seen by the
+ *		current namespace and also device from /proc/self/ns/pid.
+ *		*size_of_pidns* must be the size of *pidns*
+ *
+ *		This helper is used when pid filtering is needed inside a
+ *		container as bpf_get_current_tgid() helper returns always the
+ *		pid id as seen by the root namespace.
+ *	Return
+ *		0 on success
+ *
+ *		**-EINVAL** if *size_of_pidns* is not valid or unable to get ns, pid
+ *		or tgid of the current task.
+ *
+ *		**-ECHILD** if /proc/self/ns/pid does not exists.
+ *
+ *		**-ENOTDIR** if /proc/self/ns does not exists.
+ *
+ *		**-ENOMEM**  if allocation fails.
+ *
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -2853,7 +2875,8 @@ union bpf_attr {
 	FN(sk_storage_get),		\
 	FN(sk_storage_delete),		\
 	FN(send_signal),		\
-	FN(tcp_gen_syncookie),
+	FN(tcp_gen_syncookie),		\
+	FN(get_current_pidns_info),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
@@ -3604,4 +3627,10 @@ struct bpf_sockopt {
 	__s32	retval;
 };
 
+struct bpf_pidns_info {
+	__u32 dev;
+	__u32 nsid;
+	__u32 tgid;
+	__u32 pid;
+};
 #endif /* _UAPI__LINUX_BPF_H__ */
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 3bd0f4a0336a..1f97b571b581 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -29,7 +29,7 @@ TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test
 	test_cgroup_storage test_select_reuseport test_section_names \
 	test_netcnt test_tcpnotify_user test_sock_fields test_sysctl test_hashmap \
 	test_btf_dump test_cgroup_attach xdping test_sockopt test_sockopt_sk \
-	test_sockopt_multi test_tcp_rtt
+	test_sockopt_multi test_tcp_rtt test_pidns
 
 BPF_OBJ_FILES = $(patsubst %.c,%.o, $(notdir $(wildcard progs/*.c)))
 TEST_GEN_FILES = $(BPF_OBJ_FILES)
diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
index 8b503ea142f0..3fae3b9fcd2c 100644
--- a/tools/testing/selftests/bpf/bpf_helpers.h
+++ b/tools/testing/selftests/bpf/bpf_helpers.h
@@ -231,6 +231,9 @@ static int (*bpf_send_signal)(unsigned sig) = (void *)BPF_FUNC_send_signal;
 static long long (*bpf_tcp_gen_syncookie)(struct bpf_sock *sk, void *ip,
 					  int ip_len, void *tcp, int tcp_len) =
 	(void *) BPF_FUNC_tcp_gen_syncookie;
+static int (*bpf_get_current_pidns_info)(struct bpf_pidns_info *buf,
+					 unsigned int buf_size) =
+	(void *) BPF_FUNC_get_current_pidns_info;
 
 /* llvm builtin functions that eBPF C program may use to
  * emit BPF_LD_ABS and BPF_LD_IND instructions
diff --git a/tools/testing/selftests/bpf/progs/test_pidns_kern.c b/tools/testing/selftests/bpf/progs/test_pidns_kern.c
new file mode 100644
index 000000000000..e1d2facfa762
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_pidns_kern.c
@@ -0,0 +1,51 @@
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
+struct bpf_map_def SEC("maps") nsidmap = {
+	.type = BPF_MAP_TYPE_ARRAY,
+	.key_size = sizeof(__u32),
+	.value_size = sizeof(__u32),
+	.max_entries = 1,
+};
+
+struct bpf_map_def SEC("maps") pidmap = {
+	.type = BPF_MAP_TYPE_ARRAY,
+	.key_size = sizeof(__u32),
+	.value_size = sizeof(__u32),
+	.max_entries = 1,
+};
+
+SEC("tracepoint/syscalls/sys_enter_nanosleep")
+int trace(void *ctx)
+{
+	struct bpf_pidns_info nsinfo;
+	__u32 key = 0, *expected_pid, *val;
+	char fmt[] = "ERROR nspid:%d\n";
+
+	if (bpf_get_current_pidns_info(&nsinfo, sizeof(nsinfo)))
+		return -EINVAL;
+
+	expected_pid = bpf_map_lookup_elem(&pidmap, &key);
+
+
+	if (!expected_pid || *expected_pid != nsinfo.pid)
+		return 0;
+
+	val = bpf_map_lookup_elem(&nsidmap, &key);
+	if (val)
+		*val = nsinfo.nsid;
+
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
+__u32 _version SEC("version") = 1;
diff --git a/tools/testing/selftests/bpf/test_pidns.c b/tools/testing/selftests/bpf/test_pidns.c
new file mode 100644
index 000000000000..a7254055f294
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_pidns.c
@@ -0,0 +1,138 @@
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
+	int pidmap_fd, nsidmap_fd;
+	struct perf_event_attr attr = {};
+	struct bpf_object *obj;
+	__u32 knsid = 0;
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
+	if (CHECK(knsid != (__u32) st.st_ino, "compare_namespace_id",
+		  "kern knsid %u user unsid %u\n", knsid, (__u32) st.st_ino))
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

