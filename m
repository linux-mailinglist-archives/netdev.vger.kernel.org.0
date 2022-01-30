Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E70E4A355A
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 10:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354459AbiA3Ja1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jan 2022 04:30:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234034AbiA3Ja0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jan 2022 04:30:26 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 869F0C061714;
        Sun, 30 Jan 2022 01:30:26 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id d187so10192189pfa.10;
        Sun, 30 Jan 2022 01:30:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YlVRxz39fY5cRLJn+loRiR0FbZ2jN676CvPNPpw0e+M=;
        b=Z8bDKdXGnZSNdZMBJsP78ZxDzyQ8c6cgyUV1W4+4PUW8JjCkqPkRP3iwOLKjT5Edpa
         tmNhUBe3z5KexUux9yAuKJzguTvrNtKFs1rM+24eULlsCqqoh+MG049e9KHTB/zaePx1
         EOCscBUkMpVO+5W6yPAaWvmMg0qSD2UbX28DufA6/KBhZdpw3jcW8CPw2UfqzHPBHnjh
         +8Zo+RjBZ1j8vgRRttsw7bGFxQxXHtdLlUDkc0CdjRCf/xLtfxTiaVn48Qptn0O+PGbm
         AiALGN8p7Vj8vJvdlMmQAGgtLeRrePYtUfLsytJJTAJqNqpDfy+h6moIh+TKn/jd3kC/
         S18A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YlVRxz39fY5cRLJn+loRiR0FbZ2jN676CvPNPpw0e+M=;
        b=Z6EDlmnm86YC3y2DRJm98yLSdE6qBEMzButkzjxsg4ul55WyxGLXVmiQEWmhv1JKGn
         jegEqBiX+vRXrrlhWJECuqFK0uAGj274Pamf66H8r0VBRgj/ZcVPQXY3Uv9bFI6PgbLv
         xJIylO4haU/4MfqC/t4gvfaiR/BvyU7xPlUizqdaHeQisa10bMxsRGRfZPWILYqNaSiZ
         T3tWMbPYKkIhnF5joJ3zY3ppoJoxW/jXhTpTKmFPPcZxZflKVN5Kcikxeu2MUmcimKtz
         lldJuV4ugNN44gVyqH2QHfC0l2NbCO5lDnHUhALCr2U3Eh38OLS4/VpBEKtSEzNxMPXG
         uLWg==
X-Gm-Message-State: AOAM53351soomB8Vc/wAp3ZnLcJYl/53ftg37XXlonJMKekGiLuMBjYi
        /GXoneDPJ7KqcEt5dUINFdc=
X-Google-Smtp-Source: ABdhPJz5sN9mXEcVRNmRul1bu2ljG6NHpaiOD+Mnw+OkBHrJQc6TnmXVJcIgEBiUd2tskW/Xudeftw==
X-Received: by 2002:a63:2326:: with SMTP id j38mr12839349pgj.346.1643535026074;
        Sun, 30 Jan 2022 01:30:26 -0800 (PST)
Received: from localhost (61-223-193-169.dynamic-ip.hinet.net. [61.223.193.169])
        by smtp.gmail.com with ESMTPSA id t11sm497032pgi.90.2022.01.30.01.30.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Jan 2022 01:30:25 -0800 (PST)
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
        linux-arm-kernel@lists.infradead.org, Hou Tao <hotforest@gmail.com>
Subject: [PATCH bpf-next v3 2/3] selftests/bpf: do not export subtest as standalone test
Date:   Sun, 30 Jan 2022 17:29:16 +0800
Message-Id: <20220130092917.14544-3-hotforest@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220130092917.14544-1-hotforest@gmail.com>
References: <20220130092917.14544-1-hotforest@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two subtests in ksyms_module.c are not qualified as static, so these
subtests are exported as standalone tests in tests.h and lead to
confusion for the output of "./test_progs -t ksyms_module".

By using the following command:

  grep "^void \(serial_\)\?test_[a-zA-Z0-9_]\+(\(void\)\?)" \
      tools/testing/selftests/bpf/prog_tests/*.c | \
	awk -F : '{print $1}' | sort | uniq -c | awk '$1 != 1'

Find out that other tests also have the similar problem, so fix
these tests by marking subtests in these tests as static. For
xdp_adjust_frags.c, there is just one subtest, so just export
the subtest directly.

Signed-off-by: Hou Tao <hotforest@gmail.com>
---
 tools/testing/selftests/bpf/prog_tests/ksyms_module.c      | 4 ++--
 tools/testing/selftests/bpf/prog_tests/xdp_adjust_frags.c  | 6 ------
 tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c   | 4 ++--
 tools/testing/selftests/bpf/prog_tests/xdp_cpumap_attach.c | 4 ++--
 tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c | 2 +-
 5 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/ksyms_module.c b/tools/testing/selftests/bpf/prog_tests/ksyms_module.c
index d490ad80eccb..997aa90dea64 100644
--- a/tools/testing/selftests/bpf/prog_tests/ksyms_module.c
+++ b/tools/testing/selftests/bpf/prog_tests/ksyms_module.c
@@ -6,7 +6,7 @@
 #include "test_ksyms_module.lskel.h"
 #include "test_ksyms_module.skel.h"
 
-void test_ksyms_module_lskel(void)
+static void test_ksyms_module_lskel(void)
 {
 	struct test_ksyms_module_lskel *skel;
 	int retval;
@@ -30,7 +30,7 @@ void test_ksyms_module_lskel(void)
 	test_ksyms_module_lskel__destroy(skel);
 }
 
-void test_ksyms_module_libbpf(void)
+static void test_ksyms_module_libbpf(void)
 {
 	struct test_ksyms_module *skel;
 	int retval, err;
diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_frags.c b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_frags.c
index 31c188666e81..6ca3582bb056 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_frags.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_frags.c
@@ -96,9 +96,3 @@ void test_xdp_update_frags(void)
 out:
 	bpf_object__close(obj);
 }
-
-void test_xdp_adjust_frags(void)
-{
-	if (test__start_subtest("xdp_adjust_frags"))
-		test_xdp_update_frags();
-}
diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
index ccc9e63254a8..a254c54c3ada 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
@@ -118,7 +118,7 @@ static void test_xdp_adjust_tail_grow2(void)
 	bpf_object__close(obj);
 }
 
-void test_xdp_adjust_frags_tail_shrink(void)
+static void test_xdp_adjust_frags_tail_shrink(void)
 {
 	const char *file = "./test_xdp_adjust_tail_shrink.o";
 	__u32 duration, retval, size, exp_size;
@@ -180,7 +180,7 @@ void test_xdp_adjust_frags_tail_shrink(void)
 	bpf_object__close(obj);
 }
 
-void test_xdp_adjust_frags_tail_grow(void)
+static void test_xdp_adjust_frags_tail_grow(void)
 {
 	const char *file = "./test_xdp_adjust_tail_grow.o";
 	__u32 duration, retval, size, exp_size;
diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_cpumap_attach.c b/tools/testing/selftests/bpf/prog_tests/xdp_cpumap_attach.c
index 13aabb3b6cf2..15e48098c8b8 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_cpumap_attach.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_cpumap_attach.c
@@ -8,7 +8,7 @@
 
 #define IFINDEX_LO	1
 
-void test_xdp_with_cpumap_helpers(void)
+static void test_xdp_with_cpumap_helpers(void)
 {
 	struct test_xdp_with_cpumap_helpers *skel;
 	struct bpf_prog_info info = {};
@@ -68,7 +68,7 @@ void test_xdp_with_cpumap_helpers(void)
 	test_xdp_with_cpumap_helpers__destroy(skel);
 }
 
-void test_xdp_with_cpumap_frags_helpers(void)
+static void test_xdp_with_cpumap_frags_helpers(void)
 {
 	struct test_xdp_with_cpumap_frags_helpers *skel;
 	struct bpf_prog_info info = {};
diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c b/tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c
index 2a784ccd3136..08d074ec471d 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c
@@ -81,7 +81,7 @@ static void test_neg_xdp_devmap_helpers(void)
 	}
 }
 
-void test_xdp_with_devmap_frags_helpers(void)
+static void test_xdp_with_devmap_frags_helpers(void)
 {
 	struct test_xdp_with_devmap_frags_helpers *skel;
 	struct bpf_prog_info info = {};
-- 
2.20.1

