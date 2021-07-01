Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 264213B8B4F
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 02:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238239AbhGAAcu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 20:32:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238236AbhGAAco (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 20:32:44 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1201C061756;
        Wed, 30 Jun 2021 17:30:14 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id 22-20020a17090a0c16b0290164a5354ad0so5793033pjs.2;
        Wed, 30 Jun 2021 17:30:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KfeZbHLaSagpSWbMcY2CgR88Lxlqz7ykXlSuHFuKJ+0=;
        b=CXeSyTs2kYg5SZQywjQPVPk4IAL2mP8UI3mV+Et62qf6pvOH9iJLnZ+Q7RGidz00kN
         x+qK8BZUS15siwMPM6ch4vu06Vo3T45T7DWxkoHbICEktxfGqTVqAf0kau7jpVOAm/MN
         BYW1m67bY+lPjtevKdyMwRCQZCmLHthK9JjQFPm94E7WMaLslkdj/wmF6XoEQ+BHPpLs
         Yr/gYObDkeNGoc7JjutV0kbhUZrgePCEsOx65OmrGJgrtCJEC63ouI3YoK2TWHOZ0++u
         WKPkskHAd4c2BQkwxwZbPKUYM7mBM+Fbk6ytyWBY0LaicSAl+Kd6nmokwKFpI1/8rJ+6
         NEcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KfeZbHLaSagpSWbMcY2CgR88Lxlqz7ykXlSuHFuKJ+0=;
        b=m6lLhvpodNXvmS2oEHVAqRnYjuux5y+xx4KbizDICkpSZ2wAp3cWkRWakeOzZezisg
         JvMC+74YRW7CudeJnrTbQdlrogvHcLBHOKhfeFvxUwTM7iStSrzQiJG5m7t/64wVSY5l
         Iu5pZCMq4F+mg73z/hfz6VsYQFeJbVy0pKbfVVuGHYQeohrHQRy8Heb2AsnspgwwVXec
         nOTxFFhHZg63kWlxLjeDLC2ERTBaMrjeuDSa3NXYaLG0a8chMd7+Oek/qwE/06ga1FkQ
         2ZXDg233c6sSCkoBeXKFeEoSisSFgxOhfWhlWf6HhA+PJkDHRo51/w7jDR6VihPYh+P+
         pprg==
X-Gm-Message-State: AOAM531RWwW7eiW0gJXmODHn2+csqgOBzh1CYM4/u7ZBgPwL9aw/YJTY
        McGBS9/tg/wfpbtFD7eUIVSFXLMHuwg=
X-Google-Smtp-Source: ABdhPJxiPjHyY13PeYJEmuShSJL69/6GqAcAI0fOVxfJTqP3Ub3856G9CvCNCYXkXJdiIbOtJcxbSQ==
X-Received: by 2002:a17:90b:1809:: with SMTP id lw9mr42269799pjb.128.1625099414238;
        Wed, 30 Jun 2021 17:30:14 -0700 (PDT)
Received: from localhost ([2402:3a80:11db:6f6:e6a8:37a6:1da7:fbc7])
        by smtp.gmail.com with ESMTPSA id o34sm25890345pgm.6.2021.06.30.17.30.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jun 2021 17:30:13 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org
Subject: [PATCH net-next v5 5/5] bpf: tidy xdp attach selftests
Date:   Thu,  1 Jul 2021 05:57:59 +0530
Message-Id: <20210701002759.381983-6-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210701002759.381983-1-memxor@gmail.com>
References: <20210701002759.381983-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support for cpumap and devmap entry progs in previous commits means the
test needs to be updated for the new semantics. Also take this
opportunity to convert it from CHECK macros to the new ASSERT macros.

Since xdp_cpumap_attach has no subtest, put the sole test inside
test_xdptest_xdp_cpumap_attach function.

Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 .../bpf/prog_tests/xdp_cpumap_attach.c        | 43 +++++++------------
 .../bpf/prog_tests/xdp_devmap_attach.c        | 39 +++++++----------
 2 files changed, 32 insertions(+), 50 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_cpumap_attach.c b/tools/testing/selftests/bpf/prog_tests/xdp_cpumap_attach.c
index 0176573fe4e7..8755effd80b0 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_cpumap_attach.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_cpumap_attach.c
@@ -7,64 +7,53 @@
 
 #define IFINDEX_LO	1
 
-void test_xdp_with_cpumap_helpers(void)
+void test_xdp_cpumap_attach(void)
 {
 	struct test_xdp_with_cpumap_helpers *skel;
 	struct bpf_prog_info info = {};
+	__u32 len = sizeof(info);
 	struct bpf_cpumap_val val = {
 		.qsize = 192,
 	};
-	__u32 duration = 0, idx = 0;
-	__u32 len = sizeof(info);
 	int err, prog_fd, map_fd;
+	__u32 idx = 0;
 
 	skel = test_xdp_with_cpumap_helpers__open_and_load();
-	if (CHECK_FAIL(!skel)) {
-		perror("test_xdp_with_cpumap_helpers__open_and_load");
+	if (!ASSERT_OK_PTR(skel, "test_xdp_with_cpumap_helpers__open_and_load"))
 		return;
-	}
 
-	/* can not attach program with cpumaps that allow programs
-	 * as xdp generic
-	 */
 	prog_fd = bpf_program__fd(skel->progs.xdp_redir_prog);
 	err = bpf_set_link_xdp_fd(IFINDEX_LO, prog_fd, XDP_FLAGS_SKB_MODE);
-	CHECK(err == 0, "Generic attach of program with 8-byte CPUMAP",
-	      "should have failed\n");
+	if (!ASSERT_OK(err, "Generic attach of program with 8-byte CPUMAP"))
+		goto out_close;
+
+	err = bpf_set_link_xdp_fd(IFINDEX_LO, -1, XDP_FLAGS_SKB_MODE);
+	ASSERT_OK(err, "XDP program detach");
 
 	prog_fd = bpf_program__fd(skel->progs.xdp_dummy_cm);
 	map_fd = bpf_map__fd(skel->maps.cpu_map);
 	err = bpf_obj_get_info_by_fd(prog_fd, &info, &len);
-	if (CHECK_FAIL(err))
+	if (!ASSERT_OK(err, "bpf_obj_get_info_by_fd"))
 		goto out_close;
 
 	val.bpf_prog.fd = prog_fd;
 	err = bpf_map_update_elem(map_fd, &idx, &val, 0);
-	CHECK(err, "Add program to cpumap entry", "err %d errno %d\n",
-	      err, errno);
+	ASSERT_OK(err, "Add program to cpumap entry");
 
 	err = bpf_map_lookup_elem(map_fd, &idx, &val);
-	CHECK(err, "Read cpumap entry", "err %d errno %d\n", err, errno);
-	CHECK(info.id != val.bpf_prog.id, "Expected program id in cpumap entry",
-	      "expected %u read %u\n", info.id, val.bpf_prog.id);
+	ASSERT_OK(err, "Read cpumap entry");
+	ASSERT_EQ(info.id, val.bpf_prog.id, "Match program id to cpumap entry prog_id");
 
 	/* can not attach BPF_XDP_CPUMAP program to a device */
 	err = bpf_set_link_xdp_fd(IFINDEX_LO, prog_fd, XDP_FLAGS_SKB_MODE);
-	CHECK(err == 0, "Attach of BPF_XDP_CPUMAP program",
-	      "should have failed\n");
+	if (!ASSERT_NEQ(err, 0, "Attach of BPF_XDP_CPUMAP program"))
+		bpf_set_link_xdp_fd(IFINDEX_LO, -1, XDP_FLAGS_SKB_MODE);
 
 	val.qsize = 192;
 	val.bpf_prog.fd = bpf_program__fd(skel->progs.xdp_dummy_prog);
 	err = bpf_map_update_elem(map_fd, &idx, &val, 0);
-	CHECK(err == 0, "Add non-BPF_XDP_CPUMAP program to cpumap entry",
-	      "should have failed\n");
+	ASSERT_NEQ(err, 0, "Add non-BPF_XDP_CPUMAP program to cpumap entry");
 
 out_close:
 	test_xdp_with_cpumap_helpers__destroy(skel);
 }
-
-void test_xdp_cpumap_attach(void)
-{
-	if (test__start_subtest("cpumap_with_progs"))
-		test_xdp_with_cpumap_helpers();
-}
diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c b/tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c
index 88ef3ec8ac4c..c72af030ff10 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c
@@ -16,50 +16,45 @@ void test_xdp_with_devmap_helpers(void)
 		.ifindex = IFINDEX_LO,
 	};
 	__u32 len = sizeof(info);
-	__u32 duration = 0, idx = 0;
 	int err, dm_fd, map_fd;
+	__u32 idx = 0;
 
 
 	skel = test_xdp_with_devmap_helpers__open_and_load();
-	if (CHECK_FAIL(!skel)) {
-		perror("test_xdp_with_devmap_helpers__open_and_load");
+	if (!ASSERT_OK_PTR(skel, "test_xdp_with_devmap_helpers__open_and_load"))
 		return;
-	}
 
-	/* can not attach program with DEVMAPs that allow programs
-	 * as xdp generic
-	 */
 	dm_fd = bpf_program__fd(skel->progs.xdp_redir_prog);
 	err = bpf_set_link_xdp_fd(IFINDEX_LO, dm_fd, XDP_FLAGS_SKB_MODE);
-	CHECK(err == 0, "Generic attach of program with 8-byte devmap",
-	      "should have failed\n");
+	if (!ASSERT_OK(err, "Generic attach of program with 8-byte devmap"))
+		goto out_close;
+
+	err = bpf_set_link_xdp_fd(IFINDEX_LO, -1, XDP_FLAGS_SKB_MODE);
+	ASSERT_OK(err, "XDP program detach");
 
 	dm_fd = bpf_program__fd(skel->progs.xdp_dummy_dm);
 	map_fd = bpf_map__fd(skel->maps.dm_ports);
 	err = bpf_obj_get_info_by_fd(dm_fd, &info, &len);
-	if (CHECK_FAIL(err))
+	if (!ASSERT_OK(err, "bpf_obj_get_info_by_fd"))
 		goto out_close;
 
 	val.bpf_prog.fd = dm_fd;
 	err = bpf_map_update_elem(map_fd, &idx, &val, 0);
-	CHECK(err, "Add program to devmap entry",
-	      "err %d errno %d\n", err, errno);
+	ASSERT_OK(err, "Add program to devmap entry");
 
 	err = bpf_map_lookup_elem(map_fd, &idx, &val);
-	CHECK(err, "Read devmap entry", "err %d errno %d\n", err, errno);
-	CHECK(info.id != val.bpf_prog.id, "Expected program id in devmap entry",
-	      "expected %u read %u\n", info.id, val.bpf_prog.id);
+	ASSERT_OK(err, "Read devmap entry");
+	ASSERT_EQ(info.id, val.bpf_prog.id, "Match program id to devmap entry prog_id");
 
 	/* can not attach BPF_XDP_DEVMAP program to a device */
 	err = bpf_set_link_xdp_fd(IFINDEX_LO, dm_fd, XDP_FLAGS_SKB_MODE);
-	CHECK(err == 0, "Attach of BPF_XDP_DEVMAP program",
-	      "should have failed\n");
+	if (!ASSERT_NEQ(err, 0, "Attach of BPF_XDP_DEVMAP program"))
+		bpf_set_link_xdp_fd(IFINDEX_LO, -1, XDP_FLAGS_SKB_MODE);
 
 	val.ifindex = 1;
 	val.bpf_prog.fd = bpf_program__fd(skel->progs.xdp_dummy_prog);
 	err = bpf_map_update_elem(map_fd, &idx, &val, 0);
-	CHECK(err == 0, "Add non-BPF_XDP_DEVMAP program to devmap entry",
-	      "should have failed\n");
+	ASSERT_NEQ(err, 0, "Add non-BPF_XDP_DEVMAP program to devmap entry");
 
 out_close:
 	test_xdp_with_devmap_helpers__destroy(skel);
@@ -68,12 +63,10 @@ void test_xdp_with_devmap_helpers(void)
 void test_neg_xdp_devmap_helpers(void)
 {
 	struct test_xdp_devmap_helpers *skel;
-	__u32 duration = 0;
 
 	skel = test_xdp_devmap_helpers__open_and_load();
-	if (CHECK(skel,
-		  "Load of XDP program accessing egress ifindex without attach type",
-		  "should have failed\n")) {
+	if (!ASSERT_EQ(skel, NULL,
+		    "Load of XDP program accessing egress ifindex without attach type")) {
 		test_xdp_devmap_helpers__destroy(skel);
 	}
 }
-- 
2.31.1

