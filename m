Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5E232B2365
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 19:11:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbgKMSL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 13:11:26 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:34510 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725959AbgKMSLT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 13:11:19 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ADI6Dtk057822;
        Fri, 13 Nov 2020 18:10:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=MxHvzeabld3km1vihStJ5/q5EmID2rQ6TSWZBV8rYXc=;
 b=d/lqROMCxPjuJosy4jPlUoIs+C6EEBKhDPAFcnRkJDTjN2M3e9Lwm8vqwjFuDXZQLNjo
 GpqOzkAU05+ZYaCdvulVPfQOtPHbDXb0I0/6v9iO3F7intfooBxuZou2KpdRGTEvU1YX
 Rs31YDvBqGuBtRji/nVoVDG9/PM/TJeZTPWQmo7lDbabdAao2WvvAb65+/AwNpuM4EID
 Ks3iRxOgjwctYju5lHO5qeb7jZqeDMeWIKGCSbDozbPq5Hfjo6FBU3eCfv8HGQcpgzEZ
 SUl1TPTmd/E0mYxGl+Souj9U4hXvbN0IiWm1tmtXTbbDPZ2VXIX9hqnVzs75o+Zez/A5 vQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 34p72f1taw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 13 Nov 2020 18:10:33 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ADI52AE076327;
        Fri, 13 Nov 2020 18:10:32 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 34p5g58rq4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Nov 2020 18:10:32 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0ADIASB9032200;
        Fri, 13 Nov 2020 18:10:28 GMT
Received: from localhost.uk.oracle.com (/10.175.203.107)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 13 Nov 2020 10:10:28 -0800
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        rostedt@goodmis.org, mingo@redhat.com, haoluo@google.com,
        jolsa@kernel.org, quentin@isovalent.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [RFC bpf-next 3/3] selftests/bpf: verify module-specific types can be shown via bpf_snprintf_btf
Date:   Fri, 13 Nov 2020 18:10:13 +0000
Message-Id: <1605291013-22575-4-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1605291013-22575-1-git-send-email-alan.maguire@oracle.com>
References: <1605291013-22575-1-git-send-email-alan.maguire@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9804 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011130117
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9804 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 suspectscore=0 lowpriorityscore=0 adultscore=0 phishscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011130117
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Verify that specifying a module name in "struct btf_ptr *" along
with a type id of a module-specific type will succeed.

veth_stats_rx() is chosen because its function signature consists
of a module-specific type "struct veth_stats" and a kernel-specific
one "struct net_device".

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 .../selftests/bpf/prog_tests/snprintf_btf_mod.c    | 96 ++++++++++++++++++++++
 tools/testing/selftests/bpf/progs/btf_ptr.h        |  1 +
 tools/testing/selftests/bpf/progs/veth_stats_rx.c  | 73 ++++++++++++++++
 3 files changed, 170 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/snprintf_btf_mod.c
 create mode 100644 tools/testing/selftests/bpf/progs/veth_stats_rx.c

diff --git a/tools/testing/selftests/bpf/prog_tests/snprintf_btf_mod.c b/tools/testing/selftests/bpf/prog_tests/snprintf_btf_mod.c
new file mode 100644
index 0000000..f1b12df
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/snprintf_btf_mod.c
@@ -0,0 +1,96 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include <linux/btf.h>
+#include <bpf/btf.h>
+#include "veth_stats_rx.skel.h"
+
+#define VETH_NAME	"bpfveth0"
+
+/* Demonstrate that bpf_snprintf_btf succeeds for both module-specific
+ * and kernel-defined data structures; veth_stats_rx() is used as
+ * it has both module-specific and kernel-defined data as arguments.
+ * This test assumes that veth is built as a module and will skip if not.
+ */
+void test_snprintf_btf_mod(void)
+{
+	struct btf *vmlinux_btf = NULL, *veth_btf = NULL;
+	struct veth_stats_rx *skel = NULL;
+	struct veth_stats_rx__bss *bss;
+	int err, duration = 0;
+	__u32 id;
+
+	err = system("ip link add name " VETH_NAME " type veth");
+	if (CHECK(err, "system", "ip link add veth failed: %d\n", err))
+		return;
+
+	vmlinux_btf = btf__parse_raw("/sys/kernel/btf/vmlinux");
+	err = libbpf_get_error(vmlinux_btf);
+	if (CHECK(err, "parse vmlinux BTF", "failed parsing vmlinux BTF: %d\n",
+		  err))
+		goto cleanup;
+	veth_btf = btf__parse_raw_split("/sys/kernel/btf/veth", vmlinux_btf);
+	err = libbpf_get_error(veth_btf);
+	if (err == -ENOENT) {
+		printf("%s:SKIP:no BTF info for veth\n", __func__);
+		test__skip();
+                goto cleanup;
+	}
+
+	if (CHECK(err, "parse veth BTF", "failed parsing veth BTF: %d\n", err))
+		goto cleanup;
+
+	skel = veth_stats_rx__open();
+	if (CHECK(!skel, "skel_open", "failed to open skeleton\n"))
+		goto cleanup;
+
+	err = veth_stats_rx__load(skel);
+	if (CHECK(err, "skel_load", "failed to load skeleton: %d\n", err))
+		goto cleanup;
+
+	bss = skel->bss;
+
+	bss->veth_stats_btf_id = btf__find_by_name(veth_btf, "veth_stats");
+
+	if (CHECK(bss->veth_stats_btf_id <= 0, "find 'struct veth_stats'",
+		  "could not find 'struct veth_stats' in veth BTF: %d",
+		  bss->veth_stats_btf_id))
+		goto cleanup;
+
+	err = veth_stats_rx__attach(skel);
+	if (CHECK(err, "skel_attach", "skeleton attach failed: %d\n", err))
+		goto cleanup;
+
+	/* generate stats event, then delete; this ensures the program
+	 * triggers prior to reading status.
+	 */
+	err = system("ethtool -S " VETH_NAME " > /dev/null");
+	if (CHECK(err, "system", "ethtool -S failed: %d\n", err))
+		goto cleanup;
+
+	system("ip link delete " VETH_NAME);
+
+	/*
+	 * Make sure veth_stats_rx program was triggered and it set
+	 * expected return values from bpf_trace_printk()s and all
+	 * tests ran.
+	 */
+	if (CHECK(bss->ret <= 0,
+		  "bpf_snprintf_btf: got return value",
+		  "ret <= 0 %ld test %d\n", bss->ret, bss->ran_subtests))
+		goto cleanup;
+
+	if (CHECK(bss->ran_subtests == 0, "check if subtests ran",
+		  "no subtests ran, did BPF program run?"))
+		goto cleanup;
+
+	if (CHECK(bss->num_subtests != bss->ran_subtests,
+		  "check all subtests ran",
+		  "only ran %d of %d tests\n", bss->num_subtests,
+		  bss->ran_subtests))
+		goto cleanup;
+
+cleanup:
+	system("ip link delete " VETH_NAME ">/dev/null 2>&1");
+	if (skel)
+		veth_stats_rx__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/btf_ptr.h b/tools/testing/selftests/bpf/progs/btf_ptr.h
index c3c9797..afef9b3 100644
--- a/tools/testing/selftests/bpf/progs/btf_ptr.h
+++ b/tools/testing/selftests/bpf/progs/btf_ptr.h
@@ -17,6 +17,7 @@ struct btf_ptr {
 	void *ptr;
 	__u32 type_id;
 	__u32 flags;
+	const char *module;
 };
 
 enum {
diff --git a/tools/testing/selftests/bpf/progs/veth_stats_rx.c b/tools/testing/selftests/bpf/progs/veth_stats_rx.c
new file mode 100644
index 0000000..6ec7ce2
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/veth_stats_rx.c
@@ -0,0 +1,73 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020, Oracle and/or its affiliates. */
+
+#include "btf_ptr.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+#include <bpf/bpf_core_read.h>
+
+#include <errno.h>
+
+long ret = 0;
+int num_subtests = 0;
+int ran_subtests = 0;
+s32 veth_stats_btf_id = 0;
+
+#define STRSIZE			2048
+
+#ifndef ARRAY_SIZE
+#define ARRAY_SIZE(x)	(sizeof(x) / sizeof((x)[0]))
+#endif
+
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, __u32);
+	__type(value, char[STRSIZE]);
+} strdata SEC(".maps");
+
+SEC("kprobe/veth_stats_rx")
+int veth_stats_rx(struct pt_regs *ctx)
+{
+	static __u64 flags[] = { 0, BTF_F_COMPACT, BTF_F_ZERO, BTF_F_PTR_RAW,
+				 BTF_F_NONAME, BTF_F_COMPACT | BTF_F_ZERO |
+				 BTF_F_PTR_RAW | BTF_F_NONAME };
+	static const char mod[] = "veth";
+	const char *mods[] = { mod, 0 };
+	static struct btf_ptr p = { };
+	__u32 btf_ids[] = { 0, 0 };
+	void *ptrs[] = { 0, 0 };
+	__u32 key = 0;
+	int i, j;
+	char *str;
+
+	btf_ids[0] = veth_stats_btf_id;
+	ptrs[0] = (void *)PT_REGS_PARM1_CORE(ctx);
+#if __has_builtin(__builtin_btf_type_id)
+	btf_ids[1] = bpf_core_type_id_kernel(struct net_device);
+	ptrs[1] = (void *)PT_REGS_PARM2_CORE(ctx);
+#endif
+	str = bpf_map_lookup_elem(&strdata, &key);
+	if (!str)
+		return 0;
+
+	for (i = 0; i < ARRAY_SIZE(btf_ids); i++) {
+		if (btf_ids[i] == 0)
+			continue;
+		p.type_id = btf_ids[i];
+		p.ptr = ptrs[i];
+		p.module = mods[i];
+		for (j = 0; j < ARRAY_SIZE(flags); j++) {
+			++num_subtests;
+			ret = bpf_snprintf_btf(str, STRSIZE, &p, sizeof(p), 0);
+			if (ret < 0)
+				bpf_printk("returned %d when writing id %d",
+					   ret, p.type_id);
+			++ran_subtests;
+		}
+	}
+
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
1.8.3.1

