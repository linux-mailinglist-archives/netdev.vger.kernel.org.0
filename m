Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56F284AADB5
	for <lists+netdev@lfdr.de>; Sun,  6 Feb 2022 05:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbiBFEbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Feb 2022 23:31:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbiBFEbj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Feb 2022 23:31:39 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29C77C0612A4;
        Sat,  5 Feb 2022 20:31:39 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id g15-20020a17090a67cf00b001b7d5b6bedaso10048777pjm.4;
        Sat, 05 Feb 2022 20:31:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vC14xuAwLUgO0ZY1RnnsKKL6V5krh89PI7ayQM1Ks3s=;
        b=okezRA0Grqz/tzghW4Wy1w/9fqEZi2qYKrGWDc6NzvQky0EW7kqlFKvBkgcftNAa7k
         DX5FiOvqMknoEtuKPub0bwYxp63bqa7Aam1lvNRMQOYyf247k34Ylres9c2QxgovL8U6
         xoWX4111jzWJT1Zeim0ytqxXVdJqUyeno+yOnr2ygBJSEr22dicX4Sh+c4rkdQhPKig9
         +3f7zJZXvQyQFU0oJod44bOrNWSEN4iV5IwQC/KTiEfvwytZa+z3/+onIZmX25+MJzK9
         UYftrtGdmaGMy/qemm+/sWefF9Lk+F1R+n4a43vk3slPIhGMoQ4lLaxNIOzICOxBTOAE
         HXGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vC14xuAwLUgO0ZY1RnnsKKL6V5krh89PI7ayQM1Ks3s=;
        b=10+PdTE6YIzkgTSZS1kTndoZ7h0dhBOluQ1m/2w0uCSxEfcSOyBJVybo4ty5L7vt2m
         6zFu89gpN3QCaFvWxytAP+3PTPrcSuUaV7nCOoCoCgRB2/Zq/gBDhsG0jvNumxlbsfBW
         bl+vPg/tyIpRadk3laO6B8XgNdxJNsZU630Bg1w9+/yIDbyHh2UaHe/XfbzrH9gJfRnz
         CiJivkD3WIX+YkZFLa4uMB/C//7AxS1QGirhjeWb4q8norJ2iirOWtRgNCjROXFp/Je8
         F8DJm0cuDLM1JWocM1azRFm2OUvfqSQmu0deVh1Crxi5RVPPnb7IUcwTF9YcbnV7VXbi
         8MFA==
X-Gm-Message-State: AOAM530zPX2SEWEQaEN2D26ZYdFB9vktGbbPvY6OQnwwU+1BwyJ7CliR
        K2uhR4VtAW4Etz3sNe2M3Ec=
X-Google-Smtp-Source: ABdhPJxHemv7/4d2TTNW99w74pq5dNA87ejaG5CQ+pJwq+F1Tg/hbMbjVv+k9a2PdXXdmmgKdlikog==
X-Received: by 2002:a17:90a:c095:: with SMTP id o21mr8327250pjs.117.1644121898710;
        Sat, 05 Feb 2022 20:31:38 -0800 (PST)
Received: from localhost (61-224-163-139.dynamic-ip.hinet.net. [61.224.163.139])
        by smtp.gmail.com with ESMTPSA id y8sm5069938pgs.31.2022.02.05.20.31.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Feb 2022 20:31:38 -0800 (PST)
From:   Hou Tao <hotforest@gmail.com>
X-Google-Original-From: Hou Tao <houtao1@huawei.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org, houtao1@huawei.com
Subject: [PATCH bpf-next v4 2/2] selftests/bpf: check whether s32 is sufficient for kfunc offset
Date:   Sun,  6 Feb 2022 12:31:07 +0800
Message-Id: <20220206043107.18549-3-houtao1@huawei.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220206043107.18549-1-houtao1@huawei.com>
References: <20220206043107.18549-1-houtao1@huawei.com>
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

In add_kfunc_call(), bpf_kfunc_desc->imm with type s32 is used to
represent the offset of called kfunc from __bpf_call_base, so
add a test to ensure that the offset will not be overflowed.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 .../selftests/bpf/prog_tests/ksyms_module.c   | 42 +++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/ksyms_module.c b/tools/testing/selftests/bpf/prog_tests/ksyms_module.c
index a1ebac70ec29..8055fbbf720b 100644
--- a/tools/testing/selftests/bpf/prog_tests/ksyms_module.c
+++ b/tools/testing/selftests/bpf/prog_tests/ksyms_module.c
@@ -3,9 +3,49 @@
 
 #include <test_progs.h>
 #include <network_helpers.h>
+#include <trace_helpers.h>
 #include "test_ksyms_module.lskel.h"
 #include "test_ksyms_module.skel.h"
 
+/*
+ * Check whether or not s32 in bpf_kfunc_desc is sufficient
+ * to represent the offset between bpf_testmod_test_mod_kfunc
+ * and __bpf_call_base.
+ */
+static void test_ksyms_module_valid_offset(void)
+{
+	struct test_ksyms_module *skel;
+	unsigned long long kfunc_addr;
+	unsigned long long base_addr;
+	long long actual_offset;
+	int used_offset;
+	int err;
+
+	if (!env.has_testmod) {
+		test__skip();
+		return;
+	}
+
+	/* Ensure kfunc call is supported */
+	skel = test_ksyms_module__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "test_ksyms_module__open"))
+		return;
+
+	err = kallsyms_find("bpf_testmod_test_mod_kfunc", &kfunc_addr);
+	if (!ASSERT_OK(err, "find kfunc addr"))
+		goto cleanup;
+
+	err = kallsyms_find("__bpf_call_base", &base_addr);
+	if (!ASSERT_OK(err, "find base addr"))
+		goto cleanup;
+
+	used_offset = kfunc_addr - base_addr;
+	actual_offset = kfunc_addr - base_addr;
+	ASSERT_EQ((long long)used_offset, actual_offset, "kfunc offset overflowed");
+cleanup:
+	test_ksyms_module__destroy(skel);
+}
+
 static void test_ksyms_module_lskel(void)
 {
 	struct test_ksyms_module_lskel *skel;
@@ -62,6 +102,8 @@ static void test_ksyms_module_libbpf(void)
 
 void test_ksyms_module(void)
 {
+	if (test__start_subtest("valid_offset"))
+		test_ksyms_module_valid_offset();
 	if (test__start_subtest("lskel"))
 		test_ksyms_module_lskel();
 	if (test__start_subtest("libbpf"))
-- 
2.35.1

