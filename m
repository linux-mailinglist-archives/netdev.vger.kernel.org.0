Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B81BE4A355E
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 10:30:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354471AbiA3Jaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jan 2022 04:30:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354465AbiA3Jae (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jan 2022 04:30:34 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E697DC061714;
        Sun, 30 Jan 2022 01:30:33 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id g15-20020a17090a67cf00b001b7d5b6bedaso1551871pjm.4;
        Sun, 30 Jan 2022 01:30:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ueDBeTvh6E3uYQIJcGjSDWIJHO5uP2AyA8BgDmH0/x8=;
        b=XAnu+rkl3csF10DXVpN8bDe05Ux7nKR5lL63gaV21DqAS2Lj1ls2o1Cu5pH7ZpmZ4U
         J3MadUSTy0rG2LDOx2zHogcXGtRxrP4RAOUhpMZMglJYfBmWTgZMm9hjVmYEjAX0LTTw
         basatcDS5iq9Lndx1t49VWoKx0L3ycTw5nbvhbDZF71QrsdSi5FGNjbkruEvqRh27c8P
         G0ieH8ivE5JajurByZgm312WBAj03sJkaksquBSCzJdG3ISWNFEdwseT/lV4As3Qc8ON
         amVc8PJJmYaiHCunuSq+NT3MKcnlw+nMwW4gkkYiAMLqIEHXg5CYDofSnmqk7cn2+hbU
         +psA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ueDBeTvh6E3uYQIJcGjSDWIJHO5uP2AyA8BgDmH0/x8=;
        b=w5KG2jvfa4CyOXjFM9sDPUaG83v6bO9420T3/HMGmuE446qMFEqisQjnICWvA7cFV7
         yM0Fp8f0jlQc9ER+nk98mNNAFqIMxAb8RCG9nxhjDpmI19qktn0sJLW/fC0Cj43lNvfi
         cWfMweuKjXA6mVrR6FD8dum2V+eZSYVnlEYbQMnVp40WWHj3zgrLKHD6KyZ0KUEwn9ES
         YOgHSj69AG7Sbh5fe0OISkKhNn6GuS2Z3333Sc34Vrr75t5jrh3jsnrFOCIz0BQcAyg/
         Dnz/GtJP16Lky6Tvx4pmKvPefMFBWiJMdc0qGOR5zK9r4ZyAqOI1G5JdHZ8GyPyKOsL8
         TXQw==
X-Gm-Message-State: AOAM530bJnkN5ph04PQl2zkwpmfcStPf1vFM7WY8YOOpkfNr7+7V/zyM
        jU8UjGqsRypNFWkGbKriRLQ=
X-Google-Smtp-Source: ABdhPJxvClpGoupxFezGR1EJD5z2XSnsdE9wibhe+RrEz2KSCaDlkw1IP1xkBk9tmMVZw2wDkjXl5w==
X-Received: by 2002:a17:902:bcc6:: with SMTP id o6mr16526122pls.116.1643535033488;
        Sun, 30 Jan 2022 01:30:33 -0800 (PST)
Received: from localhost (61-223-193-169.dynamic-ip.hinet.net. [61.223.193.169])
        by smtp.gmail.com with ESMTPSA id o7sm13641025pfk.184.2022.01.30.01.30.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Jan 2022 01:30:32 -0800 (PST)
From:   Hou Tao <hotforest@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org, houtao1@huawei.com,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH bpf-next v3 3/3] selftests/bpf: check whether s32 is sufficient for kfunc offset
Date:   Sun, 30 Jan 2022 17:29:17 +0800
Message-Id: <20220130092917.14544-4-hotforest@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220130092917.14544-1-hotforest@gmail.com>
References: <20220130092917.14544-1-hotforest@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hou Tao <houtao1@huawei.com>

In add_kfunc_call(), bpf_kfunc_desc->imm with type s32 is used to
represent the offset of called kfunc from __bpf_call_base, so
add a test to ensure that the offset will not be overflowed.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 .../selftests/bpf/prog_tests/ksyms_module.c   | 42 +++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/ksyms_module.c b/tools/testing/selftests/bpf/prog_tests/ksyms_module.c
index 997aa90dea64..955a9ede4756 100644
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
@@ -55,6 +95,8 @@ static void test_ksyms_module_libbpf(void)
 
 void test_ksyms_module(void)
 {
+	if (test__start_subtest("valid_offset"))
+		test_ksyms_module_valid_offset();
 	if (test__start_subtest("lskel"))
 		test_ksyms_module_lskel();
 	if (test__start_subtest("libbpf"))
-- 
2.20.1

