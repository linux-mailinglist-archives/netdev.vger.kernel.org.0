Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 703F25AF2E1
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 19:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbiIFRlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 13:41:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbiIFRlG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 13:41:06 -0400
Received: from frasgout12.his.huawei.com (frasgout12.his.huawei.com [14.137.139.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B41BA5F8B;
        Tue,  6 Sep 2022 10:41:03 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.18.147.227])
        by frasgout12.his.huawei.com (SkyGuard) with ESMTP id 4MMWqZ2rtLz9xHMX;
        Wed,  7 Sep 2022 01:00:58 +0800 (CST)
Received: from huaweicloud.com (unknown [10.204.63.22])
        by APP1 (Coremail) with SMTP id LxC2BwA34JNSfRdjftYoAA--.8234S9;
        Tue, 06 Sep 2022 18:04:42 +0100 (CET)
From:   Roberto Sassu <roberto.sassu@huaweicloud.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, mykolal@fb.com,
        shuah@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, jakub@cloudflare.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, houtao1@huawei.com,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH 7/7] selftests/bpf: Add tests for _opts variants of libbpf
Date:   Tue,  6 Sep 2022 19:03:01 +0200
Message-Id: <20220906170301.256206-8-roberto.sassu@huaweicloud.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220906170301.256206-1-roberto.sassu@huaweicloud.com>
References: <20220906170301.256206-1-roberto.sassu@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: LxC2BwA34JNSfRdjftYoAA--.8234S9
X-Coremail-Antispam: 1UD129KBjvJXoW3XF48KFW3ZryfGw4UJw15CFg_yoW3Xw4Dpa
        9Ygryjkr1FqrW8u398Ja13Gr4xKF18W3WUt397WF15Zr18X3Z7W34xGF13tF9xZFZ5Cw4f
        Cw4ayrW8GrW7uFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUPvb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6r1S6rWUM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUAV
        Cq3wA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0
        rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267
        AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv6xkF7I0E
        14v26F4UJVW0owAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I
        80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCj
        c4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4
        kS14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E
        5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZV
        WrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r4j6ryUMIIF0xvE2Ix0cI8IcVCY
        1x0267AKxVW8Jr0_Cr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67
        AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26F4UJVW0obIYCTnIWIevJa73UjIFyTuY
        vjxUsS_MDUUUU
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAgAHBF1jj36uiQAAsp
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roberto Sassu <roberto.sassu@huawei.com>

Introduce the data_input map, write-protected with a small eBPF program
implementing the lsm/bpf_map hook.

Then, ensure that bpf_map_get_fd_by_id() and bpf_map_get_fd_by_id_opts()
with NULL opts don't succeed due to requesting read-write access to the
write-protected map. Also, ensure that bpf_map_get_fd_by_id_opts() with
flags in opts set to BPF_F_RDONLY instead succeeds.

After obtaining a read-only fd, ensure that only map lookup succeeds and
not update. Ensure that update works only with the read-write fd obtained
at program loading time, when the write protection was not yet enabled.

Finally, ensure that other _opts variants of libbpf don't work if the
BPF_F_RDONLY flag is set in opts (due to the kernel not handling the
open_flags member of bpf_attr).

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 .../bpf/prog_tests/libbpf_get_fd_opts.c       | 145 ++++++++++++++++++
 .../bpf/progs/test_libbpf_get_fd_opts.c       |  49 ++++++
 2 files changed, 194 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/libbpf_get_fd_opts.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_libbpf_get_fd_opts.c

diff --git a/tools/testing/selftests/bpf/prog_tests/libbpf_get_fd_opts.c b/tools/testing/selftests/bpf/prog_tests/libbpf_get_fd_opts.c
new file mode 100644
index 000000000000..8ea1c44f979e
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/libbpf_get_fd_opts.c
@@ -0,0 +1,145 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (C) 2022 Huawei Technologies Duesseldorf GmbH
+ *
+ * Author: Roberto Sassu <roberto.sassu@huawei.com>
+ */
+
+#include <test_progs.h>
+
+#include "test_libbpf_get_fd_opts.skel.h"
+
+void test_libbpf_get_fd_opts(void)
+{
+	DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
+	struct test_libbpf_get_fd_opts *skel;
+	struct bpf_map_info info_m = { 0 };
+	__u32 len = sizeof(info_m), value;
+	union bpf_iter_link_info linfo;
+	struct bpf_link *link;
+	struct bpf_map *map;
+	char buf[16];
+	int ret, zero = 0, fd = -1, iter_fd;
+
+	DECLARE_LIBBPF_OPTS(bpf_get_fd_opts, fd_opts_rdonly,
+		.open_flags = BPF_F_RDONLY,
+	);
+
+	skel = test_libbpf_get_fd_opts__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "test_libbpf_get_fd_opts__open_and_load"))
+		return;
+
+	bpf_program__set_autoattach(skel->progs.write_bpf_array_map, false);
+
+	ret = test_libbpf_get_fd_opts__attach(skel);
+	if (!ASSERT_OK(ret, "test_libbpf_get_fd_opts__attach"))
+		goto close_prog;
+
+	map = bpf_object__find_map_by_name(skel->obj, "data_input");
+	if (!ASSERT_OK_PTR(map, "bpf_object__find_map_by_name"))
+		goto close_prog;
+
+	ret = bpf_obj_get_info_by_fd(bpf_map__fd(map), &info_m, &len);
+	if (!ASSERT_OK(ret, "bpf_obj_get_info_by_fd"))
+		goto close_prog;
+
+	fd = bpf_map_get_fd_by_id(info_m.id);
+	if (!ASSERT_LT(fd, 0, "bpf_map_get_fd_by_id"))
+		goto close_prog;
+
+	fd = bpf_map_get_fd_by_id_opts(info_m.id, NULL);
+	if (!ASSERT_LT(fd, 0, "bpf_map_get_fd_by_id_opts"))
+		goto close_prog;
+
+	fd = bpf_map_get_fd_by_id_opts(info_m.id, &fd_opts_rdonly);
+	if (!ASSERT_GE(fd, 0, "bpf_map_get_fd_by_id_opts"))
+		goto close_prog;
+
+	/* Map lookup should work with read-only fd. */
+	ret = bpf_map_lookup_elem(fd, &zero, &value);
+	if (!ASSERT_OK(ret, "bpf_map_lookup_elem"))
+		goto close_prog;
+
+	if (!ASSERT_EQ(value, 0, "map value mismatch"))
+		goto close_prog;
+
+	/* Map update should not work with read-only fd. */
+	ret = bpf_map_update_elem(fd, &zero, &len, BPF_ANY);
+	if (!ASSERT_LT(ret, 0, "bpf_map_update_elem"))
+		goto close_prog;
+
+	/* Map update through map iterator should not work with read-only fd. */
+	memset(&linfo, 0, sizeof(linfo));
+	linfo.map.map_fd = fd;
+	opts.link_info = &linfo;
+	opts.link_info_len = sizeof(linfo);
+	link = bpf_program__attach_iter(skel->progs.write_bpf_array_map, &opts);
+	if (!ASSERT_ERR_PTR(link, "bpf_program__attach_iter")) {
+		/*
+		 * Faulty path, this should never happen if fd modes check is
+		 * added for map iterators.
+		 */
+		iter_fd = bpf_iter_create(bpf_link__fd(link));
+		bpf_link__destroy(link);
+
+		if (!ASSERT_GE(iter_fd, 0, "bpf_iter_create (faulty path)"))
+			goto close_prog;
+
+		read(iter_fd, buf, sizeof(buf));
+		close(iter_fd);
+
+		ret = bpf_map_lookup_elem(fd, &zero, &value);
+		if (!ASSERT_OK(ret, "bpf_map_lookup_elem (faulty path)"))
+			goto close_prog;
+
+		if (!ASSERT_EQ(value, 5,
+			       "unauthorized map update (faulty path)"))
+			goto close_prog;
+	}
+
+	/* Map update should work with read-write fd. */
+	ret = bpf_map_update_elem(bpf_map__fd(map), &zero, &len, BPF_ANY);
+	if (!ASSERT_OK(ret, "bpf_map_update_elem"))
+		goto close_prog;
+
+	/* Map update through map iterator should work with read-write fd. */
+	linfo.map.map_fd = bpf_map__fd(map);
+	link = bpf_program__attach_iter(skel->progs.write_bpf_array_map, &opts);
+	if (!ASSERT_OK_PTR(link, "bpf_program__attach_iter"))
+		goto close_prog;
+
+	iter_fd = bpf_iter_create(bpf_link__fd(link));
+	bpf_link__destroy(link);
+
+	if (!ASSERT_GE(iter_fd, 0, "bpf_iter_create"))
+		goto close_prog;
+
+	read(iter_fd, buf, sizeof(buf));
+	close(iter_fd);
+
+	ret = bpf_map_lookup_elem(fd, &zero, &value);
+	if (!ASSERT_OK(ret, "bpf_map_lookup_elem"))
+		goto close_prog;
+
+	if (!ASSERT_EQ(value, 5, "map value mismatch"))
+		goto close_prog;
+
+	/* Prog get fd with opts set should not work (no kernel support). */
+	ret = bpf_prog_get_fd_by_id_opts(0, &fd_opts_rdonly);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_prog_get_fd_by_id_opts"))
+		goto close_prog;
+
+	/* Link get fd with opts set should not work (no kernel support). */
+	ret = bpf_link_get_fd_by_id_opts(0, &fd_opts_rdonly);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_link_get_fd_by_id_opts"))
+		goto close_prog;
+
+	/* BTF get fd with opts set should not work (no kernel support). */
+	ret = bpf_btf_get_fd_by_id_opts(0, &fd_opts_rdonly);
+	ASSERT_EQ(ret, -EINVAL, "bpf_btf_get_fd_by_id_opts");
+
+close_prog:
+	close(fd);
+	test_libbpf_get_fd_opts__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_libbpf_get_fd_opts.c b/tools/testing/selftests/bpf/progs/test_libbpf_get_fd_opts.c
new file mode 100644
index 000000000000..83366024023f
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_libbpf_get_fd_opts.c
@@ -0,0 +1,49 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (C) 2022 Huawei Technologies Duesseldorf GmbH
+ *
+ * Author: Roberto Sassu <roberto.sassu@huawei.com>
+ */
+
+#include "vmlinux.h"
+#include <errno.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+/* From include/linux/mm.h. */
+#define FMODE_WRITE	0x2
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, __u32);
+	__type(value, __u32);
+} data_input SEC(".maps");
+
+char _license[] SEC("license") = "GPL";
+
+SEC("lsm/bpf_map")
+int BPF_PROG(check_access, struct bpf_map *map, fmode_t fmode)
+{
+	if (map != (struct bpf_map *)&data_input)
+		return 0;
+
+	if (fmode & FMODE_WRITE)
+		return -EACCES;
+
+	return 0;
+}
+
+SEC("iter/bpf_map_elem")
+int write_bpf_array_map(struct bpf_iter__bpf_map_elem *ctx)
+{
+	u32 *key = ctx->key;
+	u32 *val = ctx->value;
+
+	if (key == NULL || val == NULL)
+		return 0;
+
+	*val = 5;
+	return 0;
+}
-- 
2.25.1

