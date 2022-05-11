Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C029522FA5
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 11:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242161AbiEKJmA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 05:42:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232455AbiEKJkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 05:40:14 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C413D994EA
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 02:39:45 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d25so1483848pfo.10
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 02:39:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/fUBFqLThKL0/oaZ4altcxEM2SUwyrO5ldQGIQjCN9A=;
        b=eCKuPbS3/VRMucuQKW3fV3J1Ax7JRz48UTyPqJ9d4QLXXrpHG/NK7WY8d+A+AM8hUp
         Z4WF3/AniPqFxeK7V7vGG0KrAQOCPyoLla6A1/xTMjxb72DJ+iiSG8IAdYNvzyFhb2zz
         f9UhYYkuakC1b6i/a/7nPdTssHoc63E0sv6onRn2fTnILoEc7Rs1Sutf09ywHPeXbcqL
         ErX0tg0HrFzZqIpEd44dcclLS5hYBENT77DOYHQ2l9HGeaSAsor+OqzpHZFKISFSHQ1u
         EwFScclZw++t3uWQxi2MjTgm82PAnmpAlaEAePYCgZYHtgbGezKLQ7hsXlgLaKg7L30Y
         m2MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/fUBFqLThKL0/oaZ4altcxEM2SUwyrO5ldQGIQjCN9A=;
        b=midJDKPnQKofUPqfF+ac2zf/lVaEEjkH6sMY1PMc9X+n8j6n0yYiibiCVtHOUbWa0u
         n0/NQe7gLJCngwxXTaNz3MIYMPvBjCq6EgbumZzdlbRR2y7hNbh9L2AiX+Hf5IxMKOec
         cwdFLiSxRVS8nrc9zLXYh5MmdVsRufHNIJYgOPacZnpc2RtEdm2ofFppts9OtGFJyUM0
         ZqKccQvheYlppCnjrOW1JzK4+otwi09T0PoFQzL05EJK7WfzAvLDOEdCpPFQcF/HNg6E
         C6Bss0pqGNYXqllz+INMh66o3b9C0NDrIW/Y0NZ/vzKcX7k5elKnqSEX1JiV3CGQefYD
         nkzg==
X-Gm-Message-State: AOAM532uywES4F8QTDmmhTVXPcfrQt3cbtA2zqf6MkrId/mj7SDqspbQ
        7eNJBIDWsGaevFY9VAKQphbhng==
X-Google-Smtp-Source: ABdhPJwDMbRMxkaPKPPiBYE8YkF1nY3WaIESUDRv3AovB82URlFnnq3Oon+lU4rIHVhBZMZRCGVZmw==
X-Received: by 2002:a63:6904:0:b0:3c6:5a3c:64bd with SMTP id e4-20020a636904000000b003c65a3c64bdmr3032831pgc.371.1652261985323;
        Wed, 11 May 2022 02:39:45 -0700 (PDT)
Received: from C02F52LSML85.bytedance.net ([139.177.225.241])
        by smtp.gmail.com with ESMTPSA id k4-20020aa790c4000000b0050dc76281cdsm1159834pfk.167.2022.05.11.02.39.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 May 2022 02:39:45 -0700 (PDT)
From:   Feng zhou <zhoufeng.zf@bytedance.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, rostedt@goodmis.org,
        mingo@redhat.com, jolsa@kernel.org, davemarchevsky@fb.com,
        joannekoong@fb.com, geliang.tang@suse.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, duanxiongchun@bytedance.com,
        songmuchun@bytedance.com, wangdongdong.6@bytedance.com,
        cong.wang@bytedance.com, zhouchengming@bytedance.com,
        zhoufeng.zf@bytedance.com, yosryahmed@google.com
Subject: [PATCH bpf-next v2 2/2] selftests/bpf: add test case for bpf_map_lookup_percpu_elem
Date:   Wed, 11 May 2022 17:38:54 +0800
Message-Id: <20220511093854.411-3-zhoufeng.zf@bytedance.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20220511093854.411-1-zhoufeng.zf@bytedance.com>
References: <20220511093854.411-1-zhoufeng.zf@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Feng Zhou <zhoufeng.zf@bytedance.com>

test_progs:
Tests new ebpf helpers bpf_map_lookup_percpu_elem.

Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
---
 .../bpf/prog_tests/map_lookup_percpu_elem.c   | 46 ++++++++++++++++
 .../bpf/progs/test_map_lookup_percpu_elem.c   | 54 +++++++++++++++++++
 2 files changed, 100 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/map_lookup_percpu_elem.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_map_lookup_percpu_elem.c

diff --git a/tools/testing/selftests/bpf/prog_tests/map_lookup_percpu_elem.c b/tools/testing/selftests/bpf/prog_tests/map_lookup_percpu_elem.c
new file mode 100644
index 000000000000..58b24c2112b0
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/map_lookup_percpu_elem.c
@@ -0,0 +1,46 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2022 Bytedance
+
+#include <test_progs.h>
+
+#include "test_map_lookup_percpu_elem.skel.h"
+
+#define TEST_VALUE  1
+
+void test_map_lookup_percpu_elem(void)
+{
+	struct test_map_lookup_percpu_elem *skel;
+	int key = 0, ret;
+	int nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
+	int *buf;
+
+	buf = (int *)malloc(nr_cpus*sizeof(int));
+	if (!ASSERT_OK_PTR(buf, "malloc"))
+		return;
+	memset(buf, 0, nr_cpus*sizeof(int));
+	buf[0] = TEST_VALUE;
+
+	skel = test_map_lookup_percpu_elem__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "test_map_lookup_percpu_elem__open_and_load"))
+		return;
+	ret = test_map_lookup_percpu_elem__attach(skel);
+	ASSERT_OK(ret, "test_map_lookup_percpu_elem__attach");
+
+	ret = bpf_map_update_elem(bpf_map__fd(skel->maps.percpu_array_map), &key, buf, 0);
+	ASSERT_OK(ret, "percpu_array_map update");
+
+	ret = bpf_map_update_elem(bpf_map__fd(skel->maps.percpu_hash_map), &key, buf, 0);
+	ASSERT_OK(ret, "percpu_hash_map update");
+
+	ret = bpf_map_update_elem(bpf_map__fd(skel->maps.percpu_lru_hash_map), &key, buf, 0);
+	ASSERT_OK(ret, "percpu_lru_hash_map update");
+
+	syscall(__NR_getuid);
+
+	ret = skel->bss->percpu_array_elem_val == TEST_VALUE &&
+	      skel->bss->percpu_hash_elem_val == TEST_VALUE &&
+	      skel->bss->percpu_lru_hash_elem_val == TEST_VALUE;
+	ASSERT_OK(!ret, "bpf_map_lookup_percpu_elem success");
+
+	test_map_lookup_percpu_elem__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_map_lookup_percpu_elem.c b/tools/testing/selftests/bpf/progs/test_map_lookup_percpu_elem.c
new file mode 100644
index 000000000000..5d4ef86cbf48
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_map_lookup_percpu_elem.c
@@ -0,0 +1,54 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2022 Bytedance
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+
+int percpu_array_elem_val = 0;
+int percpu_hash_elem_val = 0;
+int percpu_lru_hash_elem_val = 0;
+
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, __u32);
+	__type(value, __u32);
+} percpu_array_map SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_HASH);
+	__uint(max_entries, 1);
+	__type(key, __u32);
+	__type(value, __u32);
+} percpu_hash_map SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_LRU_PERCPU_HASH);
+	__uint(max_entries, 1);
+	__type(key, __u32);
+	__type(value, __u32);
+} percpu_lru_hash_map SEC(".maps");
+
+SEC("tp/syscalls/sys_enter_getuid")
+int sysenter_getuid(const void *ctx)
+{
+	__u32 key = 0;
+	__u32 cpu = 0;
+	__u32 *value;
+
+	value = bpf_map_lookup_percpu_elem(&percpu_array_map, &key, cpu);
+	if (value)
+		percpu_array_elem_val = *value;
+
+	value = bpf_map_lookup_percpu_elem(&percpu_hash_map, &key, cpu);
+	if (value)
+		percpu_hash_elem_val = *value;
+
+	value = bpf_map_lookup_percpu_elem(&percpu_lru_hash_map, &key, cpu);
+	if (value)
+		percpu_lru_hash_elem_val = *value;
+
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.20.1

