Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4E793B9FBA
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 13:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231935AbhGBLXN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 07:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231933AbhGBLXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 07:23:11 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28F6EC0613DB;
        Fri,  2 Jul 2021 04:20:40 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id y4so8642802pfi.9;
        Fri, 02 Jul 2021 04:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Mu/JNqTDQqqkilde5SASiAsqtYxd9tc1IpCTmKR6mQk=;
        b=G834EleIUOSD+Ns5fRJ+dpHbVrKVpoY2XYPzTgZMXQVZrMkALyv1AdsGV9tOuR7+NE
         /04btzL8LhQiiFFGrfsSJcYXAwz8qZBLfTE6H99DYdcaeHdu/zDyBQvOdEL1q4RYJUb0
         LGcnON4B7tpx51TkyHDSFQ+t9mcoq2Lw02vrZOhAk6r3CV9x9TfVoEs5zmGWzLok8UzH
         G6ZHuDDD2Q//Fg+HkNGvucMnoISav39fyJUVr9eN5c0wKFF96DriJeaSSO/hUQwh6lm6
         Ml30XLT5+Sz4PPdWM+kFUuIP12KNmyNCiK5D9nUMrF7NlzWRAGj3MzFDhfrqWMwpQeDl
         FfjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Mu/JNqTDQqqkilde5SASiAsqtYxd9tc1IpCTmKR6mQk=;
        b=gF1dbmIRRQQjjU3D7/16TbXSAIA1RkhuemTQQQhThq5Ukr2GBUDZrA1KUoQmS3HKPT
         +DjLMjGNeu5z37GClXT+JRMJ57okAHZJohI4Rlhyd4K7tXX+txHCG96KqDj8f1624Q7s
         b60es+I04h6KAXJiRqW633+SQcUk+Dz9mAQBsjjuNVsRBiREG8MTAtqAnVk/NQxHglBD
         nDqogpIHwEmvPvSF4QHzOWDv9TDxkQDiFQ6zmh16G5s41v9MoI31JIXcZ25bkoWfniId
         /9wWo2POBwG8WtyNRshoxu++rEWgWNV7tGJN/hsihyie3QqcpKwjCYH9Bgmjz1qMaQ0L
         dxag==
X-Gm-Message-State: AOAM532kXhJKMJKVQTT33UaRPvAFDDj1yd46V/cUcE/0ZwoU2hBN55jB
        6oPq4fXsTxOME/Y5OzNrI5MfJjmmTzo=
X-Google-Smtp-Source: ABdhPJwJ1nFWVJNNayG/ZqMybPTRfTYhdUWAp38klAZuackCFckr3VBNWc/emvDFrQcAZiDdW6VswA==
X-Received: by 2002:a63:d211:: with SMTP id a17mr20061pgg.265.1625224839546;
        Fri, 02 Jul 2021 04:20:39 -0700 (PDT)
Received: from localhost ([2409:4063:4d83:c0b5:70cd:e919:ab0c:33ce])
        by smtp.gmail.com with ESMTPSA id u13sm3044439pfi.54.2021.07.02.04.20.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jul 2021 04:20:39 -0700 (PDT)
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
        Martin KaFai Lau <kafai@fb.com>,
        Eric Leblond <eric@regit.org>, bpf@vger.kernel.org
Subject: [PATCH net-next v6 5/5] bpf: tidy xdp attach selftests
Date:   Fri,  2 Jul 2021 16:48:25 +0530
Message-Id: <20210702111825.491065-6-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210702111825.491065-1-memxor@gmail.com>
References: <20210702111825.491065-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support for cpumap and devmap entry progs in previous commits means the
test needs to be updated for the new semantics. Also take this
opportunity to convert it from CHECK macros to the new ASSERT macros.

Since xdp_cpumap_attach has no subtest, put the sole test inside the
test_xdp_cpumap_attach function.

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

