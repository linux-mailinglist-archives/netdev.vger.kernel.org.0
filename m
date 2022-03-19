Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49B974DE9AA
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 18:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243769AbiCSRcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 13:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243692AbiCSRcV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 13:32:21 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93FB946664;
        Sat, 19 Mar 2022 10:30:57 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id mj15-20020a17090b368f00b001c637aa358eso13051871pjb.0;
        Sat, 19 Mar 2022 10:30:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZbZuWBU2sc499QxzBGg0bo+ElRsdQRuA/wKM02GiSt0=;
        b=JDzhcgxLaOZ0V5gQyGN26pppLmf+IEka5KXyc+sYktuWOVw1iyjcmYwMhfau6fSgW0
         fr6qpqXP4nz1I9Wi3AdFDsrYzUoKQ5rcPKtdleHoqnbiEA1BR6lY5jMhpxNh/DZJLx1D
         pJqny+cak/5s+YheGaxZCKKrSId/jE5qRPEjX8k2Tsw4yLAiheUuhGnXs4JQDY/do6N4
         qD8kHpB00mbFSTf7EW7F2iGL8zO5+tc6YGyRebwiSnoNQLpxHnD9c17jbvdeE8S9rXFQ
         gECgFIUCTgYZav51XtHHKH3EI32BVcZ6u1LuyVTOByOIkBHO0ac7oQxNpfi5+1K0agaS
         IdJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZbZuWBU2sc499QxzBGg0bo+ElRsdQRuA/wKM02GiSt0=;
        b=az9JXMl7RWECzVh8MG4/gdJDAdREzkgGWssiFEW51oi/REl67+09nfvWWQzGVlxPXY
         oVrVo1FdDDXk61vz432KH9oKCpo4km7cvhIzcplcj3qCWog8M4RHI4bwg1y8t1L82UoR
         d0JRbLB4zZE60tHsgAUB1IabwfZpQjIjlxo2fh/ouTPYG4Xxsgr63dBwx6uq/FMPuoJT
         CjcBy0NejG+uscm3h4NjRsu7x1FwbQrmfNSbRqONM5kJseD+p/TZ7r4WBGnbrbPMXG1t
         ch6dd97JXCSw4H/+5w7rJ78adnO4mAHMptL0KMJl9OR99cdqG00NLb0pS0sGxuErhmtA
         Q8pQ==
X-Gm-Message-State: AOAM532bsDYBSp31dU+cjO22bmjQ02HkfSCqkxgQWDi76EHt8F/OVxBP
        lL1bIHPlbd/XNPVmLDlsHxg=
X-Google-Smtp-Source: ABdhPJxy2a+rHVqh1VHAdTv82D7TgvdaSm91ZkM3za+b6cl7Kt8elH7cuNexrX827Jw5FearElHdtg==
X-Received: by 2002:a17:902:8f96:b0:153:62bb:c4a3 with SMTP id z22-20020a1709028f9600b0015362bbc4a3mr5131018plo.154.1647711057087;
        Sat, 19 Mar 2022 10:30:57 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:4ab8:5400:3ff:fee9:a154])
        by smtp.gmail.com with ESMTPSA id k21-20020aa788d5000000b004f71bff2893sm12722136pff.67.2022.03.19.10.30.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Mar 2022 10:30:56 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     roman.gushchin@linux.dev, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, shuah@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH 13/14] bpf: selftests: Add test case for BPF_F_NO_CHARTE
Date:   Sat, 19 Mar 2022 17:30:35 +0000
Message-Id: <20220319173036.23352-14-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220319173036.23352-1-laoar.shao@gmail.com>
References: <20220319173036.23352-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BPF_F_NO_CHARTE test case for various maps. Below is the result,
$ ./test_maps
...
test_no_charge:PASS
...

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 .../selftests/bpf/map_tests/no_charg.c        | 79 +++++++++++++++++++
 1 file changed, 79 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/map_tests/no_charg.c

diff --git a/tools/testing/selftests/bpf/map_tests/no_charg.c b/tools/testing/selftests/bpf/map_tests/no_charg.c
new file mode 100644
index 000000000000..db18685a53f7
--- /dev/null
+++ b/tools/testing/selftests/bpf/map_tests/no_charg.c
@@ -0,0 +1,79 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <sys/syscall.h>
+#include <linux/bpf.h>
+#include <string.h>
+#include <unistd.h>
+#include <stdio.h>
+#include <errno.h>
+
+#include <test_maps.h>
+
+struct map_attr {
+	__u32 map_type;
+	char *map_name;
+	__u32 key_size;
+	__u32 value_size;
+	__u32 max_entries;
+	__u32 map_flags;
+};
+
+static struct map_attr attrs[] = {
+	{BPF_MAP_TYPE_HASH, "BPF_MAP_TYPE_HASH", 4, 4, 10},
+	{BPF_MAP_TYPE_ARRAY, "BPF_MAP_TYPE_ARRAY", 4, 4, 10},
+	{BPF_MAP_TYPE_PROG_ARRAY, "BPF_MAP_TYPE_PROG_ARRAY", 4, 4, 10},
+	{BPF_MAP_TYPE_PERF_EVENT_ARRAY, "BPF_MAP_TYPE_PERF_EVENT_ARRAY", 4, 4, 10},
+	{BPF_MAP_TYPE_PERCPU_HASH, "BPF_MAP_TYPE_PERCPU_HASH", 4, 4, 10},
+	{BPF_MAP_TYPE_PERCPU_ARRAY, "BPF_MAP_TYPE_PERCPU_ARRAY", 4, 4, 10},
+	{BPF_MAP_TYPE_STACK_TRACE, "BPF_MAP_TYPE_STACK_TRACE", 4, 8, 10},
+	{BPF_MAP_TYPE_CGROUP_ARRAY, "BPF_MAP_TYPE_CGROUP_ARRAY", 4, 4, 10},
+	{BPF_MAP_TYPE_LRU_HASH, "BPF_MAP_TYPE_LRU_HASH", 4, 4, 10},
+	{BPF_MAP_TYPE_LRU_PERCPU_HASH, "BPF_MAP_TYPE_LRU_PERCPU_HASH", 4, 4, 10},
+	{BPF_MAP_TYPE_LPM_TRIE, "BPF_MAP_TYPE_LPM_TRIE", 32, 4, 10, BPF_F_NO_PREALLOC},
+	{BPF_MAP_TYPE_DEVMAP, "BPF_MAP_TYPE_DEVMAP", 4, 4, 10},
+	{BPF_MAP_TYPE_SOCKMAP, "BPF_MAP_TYPE_SOCKMAP", 4, 4, 10},
+	{BPF_MAP_TYPE_CPUMAP, "BPF_MAP_TYPE_CPUMAP", 4, 4, 10},
+	{BPF_MAP_TYPE_XSKMAP, "BPF_MAP_TYPE_XSKMAP", 4, 4, 10},
+	{BPF_MAP_TYPE_SOCKHASH, "BPF_MAP_TYPE_SOCKHASH", 4, 4, 10},
+	{BPF_MAP_TYPE_REUSEPORT_SOCKARRAY, "BPF_MAP_TYPE_REUSEPORT_SOCKARRAY", 4, 4, 10},
+	{BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE, "BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE", 8, 4, 0},
+	{BPF_MAP_TYPE_QUEUE, "BPF_MAP_TYPE_QUEUE", 0, 4, 10},
+	{BPF_MAP_TYPE_DEVMAP_HASH, "BPF_MAP_TYPE_DEVMAP_HASH", 4, 4, 10},
+	{BPF_MAP_TYPE_RINGBUF, "BPF_MAP_TYPE_RINGBUF", 0, 0, 4096},
+	{BPF_MAP_TYPE_BLOOM_FILTER, "BPF_MAP_TYPE_BLOOM_FILTER", 0, 4, 10},
+};
+
+static __u32 flags[] = {
+	BPF_F_NO_CHARGE,
+};
+
+void test_map_flags(union bpf_attr *attr, char *name)
+{
+	int mfd;
+
+	mfd = syscall(SYS_bpf, BPF_MAP_CREATE, attr, sizeof(*attr));
+	CHECK(mfd <= 0 && mfd != -EPERM, "no_charge", "%s error: %s\n",
+		name, strerror(errno));
+
+	if (mfd > 0)
+		close(mfd);
+}
+
+void test_no_charge(void)
+{
+	union bpf_attr attr;
+	int i, j;
+
+	memset(&attr, 0, sizeof(attr));
+	for (i = 0; i < sizeof(flags) / sizeof(__u32); i++) {
+		for (j = 0; j < sizeof(attrs) / sizeof(struct map_attr); j++) {
+			attr.map_type = attrs[j].map_type;
+			attr.key_size = attrs[j].key_size;
+			attr.value_size = attrs[j].value_size;
+			attr.max_entries = attrs[j].max_entries;
+			attr.map_flags = attrs[j].map_flags | flags[i];
+			test_map_flags(&attr, attrs[j].map_name);
+		}
+	}
+
+	printf("%s:PASS\n", __func__);
+}
-- 
2.17.1

