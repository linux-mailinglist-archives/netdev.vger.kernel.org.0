Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB79487EC8
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 23:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230441AbiAGWLY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 17:11:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:37257 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230409AbiAGWLY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 17:11:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641593483;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lDjSnWSJKmRxgKiKPbIJ63KDFOjFZvuZYRiZmSeBluE=;
        b=BFzRjX0FNn/ELuxZonJpg4Dkdr0vxtxsl5oErvZ0OPpUbd6Ju5OE4VnPy0hNBeYztCOWPJ
        g9eSTyjnGa8njpt6+CvivdWsMiWL2Mg5BU6hOWo1wp+07gyTqSD+mDyTkEEZAdaQEZofqh
        qb0c4E7KAPkBKbeJHiWt4ytJVgZplww=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-FP-W3eR1MyG8ERfbVJ0X1w-1; Fri, 07 Jan 2022 17:11:22 -0500
X-MC-Unique: FP-W3eR1MyG8ERfbVJ0X1w-1
Received: by mail-ed1-f72.google.com with SMTP id v18-20020a056402349200b003f8d3b7ee8dso5748066edc.23
        for <netdev@vger.kernel.org>; Fri, 07 Jan 2022 14:11:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lDjSnWSJKmRxgKiKPbIJ63KDFOjFZvuZYRiZmSeBluE=;
        b=ElBdkuE5XL7oKl4KZg+qLk1nnsIgS5YOxnOGqyBhdpxu9rh35dVyOgJJT4igDo9/0m
         2CpZY2H2gLsRXQqMSPiZbrUhfOtEWjQgsYXO/XA5uWGDH/NOwFXIdiE6vQ+KYNNcSoXZ
         +DmwnHlZks69kzgzxqTxZuFfL9uu/QgaSls/PEJgPd2N0+HYLTxBcacZJOqfPQSGpV/V
         5YHJVWMExkc//sUNhuVOfwCIqL/Z0cIsnOmNhli6IbQSLHzpqmItDhfBH+FZK9mBiVuN
         FZLrmNdCagt9Vauma0FhKo/glLEPih6pkrR8jk4vRo6JCexDBCn7efM20qXee/1cJAYI
         8Avw==
X-Gm-Message-State: AOAM532QUKURUoCYm7uOcprAyxnd7b34ylagF5oYyBUZAvAys5GiQYer
        el4ThejGuFgv/jOjddrMcFXcXFJr5aDGwU7NhOh6qzXqn3ShHlSWDosIOSJNrjXA8S8rYDbRwCa
        2fV5jBPMWXYZA/i5V
X-Received: by 2002:aa7:cc04:: with SMTP id q4mr42929016edt.313.1641593480485;
        Fri, 07 Jan 2022 14:11:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy1EdHnFGEQQrtlMaq4SdEv0CgZj6huekFI6+wJjDvqJps3II7hQ9oiRzFNR331tz9y5Puing==
X-Received: by 2002:aa7:cc04:: with SMTP id q4mr42928952edt.313.1641593479391;
        Fri, 07 Jan 2022 14:11:19 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id o8sm78453edc.85.2022.01.07.14.11.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jan 2022 14:11:18 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id DBBC2181F2C; Fri,  7 Jan 2022 23:11:16 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH bpf v2 2/3] bpf/selftests: convert xdp_link test to ASSERT_* macros
Date:   Fri,  7 Jan 2022 23:11:14 +0100
Message-Id: <20220107221115.326171-2-toke@redhat.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220107221115.326171-1-toke@redhat.com>
References: <20220107221115.326171-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the selftest to use the preferred ASSERT_* macros instead of the
deprecated CHECK().

v2:
- Don't add if statements around checks if they weren't there before.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 .../selftests/bpf/prog_tests/xdp_link.c       | 56 +++++++++----------
 1 file changed, 25 insertions(+), 31 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_link.c b/tools/testing/selftests/bpf/prog_tests/xdp_link.c
index 983ab0b47d30..eec0bf83546b 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_link.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_link.c
@@ -8,46 +8,47 @@
 
 void serial_test_xdp_link(void)
 {
-	__u32 duration = 0, id1, id2, id0 = 0, prog_fd1, prog_fd2, err;
 	DECLARE_LIBBPF_OPTS(bpf_xdp_set_link_opts, opts, .old_fd = -1);
 	struct test_xdp_link *skel1 = NULL, *skel2 = NULL;
+	__u32 id1, id2, id0 = 0, prog_fd1, prog_fd2;
 	struct bpf_link_info link_info;
 	struct bpf_prog_info prog_info;
 	struct bpf_link *link;
+	int err;
 	__u32 link_info_len = sizeof(link_info);
 	__u32 prog_info_len = sizeof(prog_info);
 
 	skel1 = test_xdp_link__open_and_load();
-	if (CHECK(!skel1, "skel_load", "skeleton open and load failed\n"))
+	if (!ASSERT_OK_PTR(skel1, "skel_load"))
 		goto cleanup;
 	prog_fd1 = bpf_program__fd(skel1->progs.xdp_handler);
 
 	skel2 = test_xdp_link__open_and_load();
-	if (CHECK(!skel2, "skel_load", "skeleton open and load failed\n"))
+	if (!ASSERT_OK_PTR(skel2, "skel_load"))
 		goto cleanup;
 	prog_fd2 = bpf_program__fd(skel2->progs.xdp_handler);
 
 	memset(&prog_info, 0, sizeof(prog_info));
 	err = bpf_obj_get_info_by_fd(prog_fd1, &prog_info, &prog_info_len);
-	if (CHECK(err, "fd_info1", "failed %d\n", -errno))
+	if (!ASSERT_OK(err, "fd_info1"))
 		goto cleanup;
 	id1 = prog_info.id;
 
 	memset(&prog_info, 0, sizeof(prog_info));
 	err = bpf_obj_get_info_by_fd(prog_fd2, &prog_info, &prog_info_len);
-	if (CHECK(err, "fd_info2", "failed %d\n", -errno))
+	if (!ASSERT_OK(err, "fd_info2"))
 		goto cleanup;
 	id2 = prog_info.id;
 
 	/* set initial prog attachment */
 	err = bpf_set_link_xdp_fd_opts(IFINDEX_LO, prog_fd1, XDP_FLAGS_REPLACE, &opts);
-	if (CHECK(err, "fd_attach", "initial prog attach failed: %d\n", err))
+	if (!ASSERT_OK(err, "fd_attach"))
 		goto cleanup;
 
 	/* validate prog ID */
 	err = bpf_get_link_xdp_id(IFINDEX_LO, &id0, 0);
-	CHECK(err || id0 != id1, "id1_check",
-	      "loaded prog id %u != id1 %u, err %d", id0, id1, err);
+	if (!ASSERT_OK(err, "id1_check_err") || !ASSERT_EQ(id0, id1, "id1_check_val"))
+		goto cleanup;
 
 	/* BPF link is not allowed to replace prog attachment */
 	link = bpf_program__attach_xdp(skel1->progs.xdp_handler, IFINDEX_LO);
@@ -62,7 +63,7 @@ void serial_test_xdp_link(void)
 	/* detach BPF program */
 	opts.old_fd = prog_fd1;
 	err = bpf_set_link_xdp_fd_opts(IFINDEX_LO, -1, XDP_FLAGS_REPLACE, &opts);
-	if (CHECK(err, "prog_detach", "failed %d\n", err))
+	if (!ASSERT_OK(err, "prog_detach"))
 		goto cleanup;
 
 	/* now BPF link should attach successfully */
@@ -73,24 +74,23 @@ void serial_test_xdp_link(void)
 
 	/* validate prog ID */
 	err = bpf_get_link_xdp_id(IFINDEX_LO, &id0, 0);
-	if (CHECK(err || id0 != id1, "id1_check",
-		  "loaded prog id %u != id1 %u, err %d", id0, id1, err))
+	if (!ASSERT_OK(err, "id1_check_err") || !ASSERT_EQ(id0, id1, "id1_check_val"))
 		goto cleanup;
 
 	/* BPF prog attach is not allowed to replace BPF link */
 	opts.old_fd = prog_fd1;
 	err = bpf_set_link_xdp_fd_opts(IFINDEX_LO, prog_fd2, XDP_FLAGS_REPLACE, &opts);
-	if (CHECK(!err, "prog_attach_fail", "unexpected success\n"))
+	if (!ASSERT_ERR(err, "prog_attach_fail"))
 		goto cleanup;
 
 	/* Can't force-update when BPF link is active */
 	err = bpf_set_link_xdp_fd(IFINDEX_LO, prog_fd2, 0);
-	if (CHECK(!err, "prog_update_fail", "unexpected success\n"))
+	if (!ASSERT_ERR(err, "prog_update_fail"))
 		goto cleanup;
 
 	/* Can't force-detach when BPF link is active */
 	err = bpf_set_link_xdp_fd(IFINDEX_LO, -1, 0);
-	if (CHECK(!err, "prog_detach_fail", "unexpected success\n"))
+	if (!ASSERT_ERR(err, "prog_detach_fail"))
 		goto cleanup;
 
 	/* BPF link is not allowed to replace another BPF link */
@@ -110,40 +110,34 @@ void serial_test_xdp_link(void)
 	skel2->links.xdp_handler = link;
 
 	err = bpf_get_link_xdp_id(IFINDEX_LO, &id0, 0);
-	if (CHECK(err || id0 != id2, "id2_check",
-		  "loaded prog id %u != id2 %u, err %d", id0, id1, err))
+	if (!ASSERT_OK(err, "id2_check_err") || !ASSERT_EQ(id0, id2, "id2_check_val"))
 		goto cleanup;
 
 	/* updating program under active BPF link works as expected */
 	err = bpf_link__update_program(link, skel1->progs.xdp_handler);
-	if (CHECK(err, "link_upd", "failed: %d\n", err))
+	if (!ASSERT_OK(err, "link_upd"))
 		goto cleanup;
 
 	memset(&link_info, 0, sizeof(link_info));
 	err = bpf_obj_get_info_by_fd(bpf_link__fd(link), &link_info, &link_info_len);
-	if (CHECK(err, "link_info", "failed: %d\n", err))
+	if (!ASSERT_OK(err, "link_info"))
 		goto cleanup;
 
-	CHECK(link_info.type != BPF_LINK_TYPE_XDP, "link_type",
-	      "got %u != exp %u\n", link_info.type, BPF_LINK_TYPE_XDP);
-	CHECK(link_info.prog_id != id1, "link_prog_id",
-	      "got %u != exp %u\n", link_info.prog_id, id1);
-	CHECK(link_info.xdp.ifindex != IFINDEX_LO, "link_ifindex",
-	      "got %u != exp %u\n", link_info.xdp.ifindex, IFINDEX_LO);
+	ASSERT_EQ(link_info.type, BPF_LINK_TYPE_XDP, "link_type");
+	ASSERT_EQ(link_info.prog_id, id1, "link_prog_id");
+	ASSERT_EQ(link_info.xdp.ifindex, IFINDEX_LO, "link_ifindex");
 
 	err = bpf_link__detach(link);
-	if (CHECK(err, "link_detach", "failed %d\n", err))
+	if (!ASSERT_OK(err, "link_detach"))
 		goto cleanup;
 
 	memset(&link_info, 0, sizeof(link_info));
 	err = bpf_obj_get_info_by_fd(bpf_link__fd(link), &link_info, &link_info_len);
-	if (CHECK(err, "link_info", "failed: %d\n", err))
-		goto cleanup;
-	CHECK(link_info.prog_id != id1, "link_prog_id",
-	      "got %u != exp %u\n", link_info.prog_id, id1);
+
+	ASSERT_OK(err, "link_info");
+	ASSERT_EQ(link_info.prog_id, id1, "link_prog_id");
 	/* ifindex should be zeroed out */
-	CHECK(link_info.xdp.ifindex != 0, "link_ifindex",
-	      "got %u != exp %u\n", link_info.xdp.ifindex, 0);
+	ASSERT_EQ(link_info.xdp.ifindex, 0, "link_ifindex");
 
 cleanup:
 	test_xdp_link__destroy(skel1);
-- 
2.34.1

