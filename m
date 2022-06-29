Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D86A955FE50
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 13:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231745AbiF2LOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 07:14:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231786AbiF2LN6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 07:13:58 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5BB93B56D
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 04:13:57 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id k22so21920547wrd.6
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 04:13:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mQ9Pkufo93h2jiAsnlur3YeB1zq577JCU0eiJSFte4E=;
        b=RDTl+J8aUN3Nck+KpYu80XH50AYDa7lGMPUpPQjqDlyG8FfNjPYdpifR7RqXy8GZ3z
         +XzNTt4yGhZQgVuFua33RpRz26e6Iqj7fkLzrOMBjrBH0EPWh9aLIKLUjQ7mbUPEhFCb
         HOIOsbeVQpDWpSjWRBIDOXLwO+QRbNaAovfcnpH/ktWGffSZwShN21UVFcG+DJhrxKMO
         yKmCNxniwfX/WiIIt7GLcV54xR/wsrUxzyB4kqXDwHSBZecz4Iii8/b3F7hzdcGMKePy
         bPCPM7YIWNUoePbY8A1Dxbu22jVVh/AXYhw0mFxO7o1paF5dJKKXbq0rjF4ipkz01Q4L
         mwzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mQ9Pkufo93h2jiAsnlur3YeB1zq577JCU0eiJSFte4E=;
        b=I3XW/SGw0knCEy7jCdKQ6JsJTFhPg7oOkBw7I4LutKJygs8etnmKd4kx4XUY949KTn
         gJeavzOIjWIDKZI7gLwOWyXmj2GNB4QOtgJWaSp5C+vMEfjMeC/tnPoxefOaNidxTGJg
         gZxuY6lftyGzu58wb2yGSue3yFM9tHFOSI9pRcGfrIYgDUrI02bPy9MZCGo83CxPhKJG
         YkLeUKFfdPGvmmDrSAyrZfYVSF26ss7sN7zNzt4odEvjWy0BkBGJMA8WX04nEJFjLLYl
         nu5ybGSkixgxkObeI7JbesAtf/O0lE8ty+EQKGYru366eDKxuKSTOzyxf6pg1fTD2aVX
         G2Vg==
X-Gm-Message-State: AJIora/tO4tHeiY1O+J421hlPn6DQ6gx81tNSbhA2rXEbrto9u82Yc7x
        La38w7ngEHJ9ptDi33w5Kl5RC3dG0UaFhhVOWaU=
X-Google-Smtp-Source: AGRyM1sivzKFjhtKmFSjTL9yU8HAvn7/vCIhLqC0+QKy4j6Db4so60/UNL/1TiwYAx/VH3V3aCSgMQ==
X-Received: by 2002:adf:d841:0:b0:21d:2d0d:e704 with SMTP id k1-20020adfd841000000b0021d2d0de704mr1812185wrl.77.1656501236271;
        Wed, 29 Jun 2022 04:13:56 -0700 (PDT)
Received: from harfang.fritz.box ([51.155.200.13])
        by smtp.gmail.com with ESMTPSA id i4-20020a05600c354400b0039c5328ad92sm2960188wmq.41.2022.06.29.04.13.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 04:13:55 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Quentin Monnet <quentin@isovalent.com>,
        Stanislav Fomichev <sdf@google.com>,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next v2] bpftool: Probe for memcg-based accounting before bumping rlimit
Date:   Wed, 29 Jun 2022 12:13:51 +0100
Message-Id: <20220629111351.47699-1-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bpftool used to bump the memlock rlimit to make sure to be able to load
BPF objects. After the kernel has switched to memcg-based memory
accounting [0] in 5.11, bpftool has relied on libbpf to probe the system
for memcg-based accounting support and for raising the rlimit if
necessary [1]. But this was later reverted, because the probe would
sometimes fail, resulting in bpftool not being able to load all required
objects [2].

Here we add a more efficient probe, in bpftool itself. We first lower
the rlimit to 0, then we attempt to load a BPF object (and finally reset
the rlimit): if the load succeeds, then memcg-based memory accounting is
supported.

This approach was earlier proposed for the probe in libbpf itself [3],
but given that the library may be used in multithreaded applications,
the probe could have undesirable consequences if one thread attempts to
lock kernel memory while memlock rlimit is at 0. Since bpftool is
single-threaded and the rlimit is process-based, this is fine to do in
bpftool itself.

This probe was inspired by the similar one from the cilium/ebpf Go
library [4].

v2:
- Simply use sizeof(attr) instead of hardcoding a size via
  offsetofend().
- Set r0 = 0 before returning in sample program.

[0] commit 97306be45fbe ("Merge branch 'switch to memcg-based memory accounting'")
[1] commit a777e18f1bcd ("bpftool: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK")
[2] commit 6b4384ff1088 ("Revert "bpftool: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK"")
[3] https://lore.kernel.org/bpf/20220609143614.97837-1-quentin@isovalent.com/t/#u
[4] https://github.com/cilium/ebpf/blob/v0.9.0/rlimit/rlimit.go#L39

Cc: Stanislav Fomichev <sdf@google.com>
Cc: Yafang Shao <laoar.shao@gmail.com>
Suggested-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/bpf/bpftool/common.c | 71 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 68 insertions(+), 3 deletions(-)

diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
index a0d4acd7c54a..fc8172a4969a 100644
--- a/tools/bpf/bpftool/common.c
+++ b/tools/bpf/bpftool/common.c
@@ -13,14 +13,17 @@
 #include <stdlib.h>
 #include <string.h>
 #include <unistd.h>
-#include <linux/limits.h>
-#include <linux/magic.h>
 #include <net/if.h>
 #include <sys/mount.h>
 #include <sys/resource.h>
 #include <sys/stat.h>
 #include <sys/vfs.h>
 
+#include <linux/filter.h>
+#include <linux/limits.h>
+#include <linux/magic.h>
+#include <linux/unistd.h>
+
 #include <bpf/bpf.h>
 #include <bpf/hashmap.h>
 #include <bpf/libbpf.h> /* libbpf_num_possible_cpus */
@@ -73,11 +76,73 @@ static bool is_bpffs(char *path)
 	return (unsigned long)st_fs.f_type == BPF_FS_MAGIC;
 }
 
+/* Probe whether kernel switched from memlock-based (RLIMIT_MEMLOCK) to
+ * memcg-based memory accounting for BPF maps and programs. This was done in
+ * commit 97306be45fbe ("Merge branch 'switch to memcg-based memory
+ * accounting'"), in Linux 5.11.
+ *
+ * Libbpf also offers to probe for memcg-based accounting vs rlimit, but does
+ * so by checking for the availability of a given BPF helper and this has
+ * failed on some kernels with backports in the past, see commit 6b4384ff1088
+ * ("Revert "bpftool: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK"").
+ * Instead, we can probe by lowering the process-based rlimit to 0, trying to
+ * load a BPF object, and resetting the rlimit. If the load succeeds then
+ * memcg-based accounting is supported.
+ *
+ * This would be too dangerous to do in the library, because multithreaded
+ * applications might attempt to load items while the rlimit is at 0. Given
+ * that bpftool is single-threaded, this is fine to do here.
+ */
+static bool known_to_need_rlimit(void)
+{
+	struct rlimit rlim_init, rlim_cur_zero = {};
+	struct bpf_insn insns[] = {
+		BPF_MOV64_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	};
+	size_t insn_cnt = ARRAY_SIZE(insns);
+	union bpf_attr attr;
+	int prog_fd, err;
+
+	memset(&attr, 0, sizeof(attr));
+	attr.prog_type = BPF_PROG_TYPE_SOCKET_FILTER;
+	attr.insns = ptr_to_u64(insns);
+	attr.insn_cnt = insn_cnt;
+	attr.license = ptr_to_u64("GPL");
+
+	if (getrlimit(RLIMIT_MEMLOCK, &rlim_init))
+		return false;
+
+	/* Drop the soft limit to zero. We maintain the hard limit to its
+	 * current value, because lowering it would be a permanent operation
+	 * for unprivileged users.
+	 */
+	rlim_cur_zero.rlim_max = rlim_init.rlim_max;
+	if (setrlimit(RLIMIT_MEMLOCK, &rlim_cur_zero))
+		return false;
+
+	/* Do not use bpf_prog_load() from libbpf here, because it calls
+	 * bump_rlimit_memlock(), interfering with the current probe.
+	 */
+	prog_fd = syscall(__NR_bpf, BPF_PROG_LOAD, &attr, sizeof(attr));
+	err = errno;
+
+	/* reset soft rlimit to its initial value */
+	setrlimit(RLIMIT_MEMLOCK, &rlim_init);
+
+	if (prog_fd < 0)
+		return err == EPERM;
+
+	close(prog_fd);
+	return false;
+}
+
 void set_max_rlimit(void)
 {
 	struct rlimit rinf = { RLIM_INFINITY, RLIM_INFINITY };
 
-	setrlimit(RLIMIT_MEMLOCK, &rinf);
+	if (known_to_need_rlimit())
+		setrlimit(RLIMIT_MEMLOCK, &rinf);
 }
 
 static int
-- 
2.34.1

