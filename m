Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3F24AADB3
	for <lists+netdev@lfdr.de>; Sun,  6 Feb 2022 05:31:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbiBFEbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Feb 2022 23:31:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiBFEbf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Feb 2022 23:31:35 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E63A8C06173B;
        Sat,  5 Feb 2022 20:31:34 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id x3so8637320pll.3;
        Sat, 05 Feb 2022 20:31:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HWpaV52CFXtpMmeyOKvkd4QdQDgXAkRobYFYRX1+T1g=;
        b=AY+sYZvXYhNdqDKEHqv8z7zAtdaEM1J4sNJf16XVYvVeglpSeKzyhXxxYCSPnA5vLc
         d8Ez5Qtt1Sa1OeQahm+Xo/oXrnX6pY+U6LUSzMT+vkU7Rn+IBtYAv/c82ebDNB3tGGY+
         gnHe7/tDs4Mk/6SnZiasz6vCLvOOAS/v4W5HmC4WCEqPSqKMwW7dTwlTm+Azm4XsjOM9
         WoVNmdElncTs9/b5pekfiuY2gzkW+phFU4h15zVBkogSSdjKPG26zujGMX7a377blLSp
         oo6l/fsclFjskI/iMfEuQ4sNm0i1bmyq2VB3Sndguwon068eYPQgy7wOBHFFIjuCOP+G
         H8pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HWpaV52CFXtpMmeyOKvkd4QdQDgXAkRobYFYRX1+T1g=;
        b=bPOY6cJ+PgASeFbLgHFvOwaU07/fHWny5GkNNYPPWA8d6veuYWpbEbQAf3eFLpaE0L
         FOMVm/akA+BN5XWl19/ZhFKwjQVRDwgrk5gJ0zOL/WvlGn3z9xrvnVgC8DPbVnqq9Dj2
         6yQEZqJuEdo3xkE+46vkuuktOHovvYppIrXC6vjTSKs5ik20L2H7HcrAa81BCna8AgIB
         TKTRbpuj8TXIrjaI2ajv+6vlVuZqZjCnD8Coh48aBSVd3VuVY1vDYOoa16UNWzeZZ2y/
         Hux2FxEFQK6Izn2v57QySoLhWc6g5OWxzmaZMP21C/HBA9WCjTXgrzNikZ80oO/Auq6o
         mfKg==
X-Gm-Message-State: AOAM5300FslHL4iCLmvP4fa2k2J91ehXr5QQPV0yy0+4Mzsmn1K/OrxH
        9mTvTwwttDMvQbPvPmuek/w=
X-Google-Smtp-Source: ABdhPJzeOlONbi2yyRPUtWwg+wqRRFlXbSns0S0ZOjh/C9JmHJLF5Xjl2kvzmY3x1fDUTKUSue6kyg==
X-Received: by 2002:a17:90b:4d11:: with SMTP id mw17mr11466648pjb.9.1644121894470;
        Sat, 05 Feb 2022 20:31:34 -0800 (PST)
Received: from localhost (61-224-163-139.dynamic-ip.hinet.net. [61.224.163.139])
        by smtp.gmail.com with ESMTPSA id z13sm7619983pfe.20.2022.02.05.20.31.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Feb 2022 20:31:33 -0800 (PST)
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
Subject: [PATCH bpf-next v4 1/2] selftests/bpf: do not export subtest as standalone test
Date:   Sun,  6 Feb 2022 12:31:06 +0800
Message-Id: <20220206043107.18549-2-houtao1@huawei.com>
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

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 tools/testing/selftests/bpf/prog_tests/ksyms_module.c      | 4 ++--
 tools/testing/selftests/bpf/prog_tests/xdp_adjust_frags.c  | 6 ------
 tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c   | 4 ++--
 tools/testing/selftests/bpf/prog_tests/xdp_cpumap_attach.c | 4 ++--
 tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c | 2 +-
 5 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/ksyms_module.c b/tools/testing/selftests/bpf/prog_tests/ksyms_module.c
index ecc58c9e7631..a1ebac70ec29 100644
--- a/tools/testing/selftests/bpf/prog_tests/ksyms_module.c
+++ b/tools/testing/selftests/bpf/prog_tests/ksyms_module.c
@@ -6,7 +6,7 @@
 #include "test_ksyms_module.lskel.h"
 #include "test_ksyms_module.skel.h"
 
-void test_ksyms_module_lskel(void)
+static void test_ksyms_module_lskel(void)
 {
 	struct test_ksyms_module_lskel *skel;
 	int err;
@@ -33,7 +33,7 @@ void test_ksyms_module_lskel(void)
 	test_ksyms_module_lskel__destroy(skel);
 }
 
-void test_ksyms_module_libbpf(void)
+static void test_ksyms_module_libbpf(void)
 {
 	struct test_ksyms_module *skel;
 	int err;
diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_frags.c b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_frags.c
index 134d0ac32f59..fc2d8fa8dac5 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_frags.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_frags.c
@@ -102,9 +102,3 @@ void test_xdp_update_frags(void)
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
index 528a8c387720..21ceac24e174 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
@@ -133,7 +133,7 @@ static void test_xdp_adjust_tail_grow2(void)
 	bpf_object__close(obj);
 }
 
-void test_xdp_adjust_frags_tail_shrink(void)
+static void test_xdp_adjust_frags_tail_shrink(void)
 {
 	const char *file = "./test_xdp_adjust_tail_shrink.o";
 	__u32 exp_size;
@@ -200,7 +200,7 @@ void test_xdp_adjust_frags_tail_shrink(void)
 	bpf_object__close(obj);
 }
 
-void test_xdp_adjust_frags_tail_grow(void)
+static void test_xdp_adjust_frags_tail_grow(void)
 {
 	const char *file = "./test_xdp_adjust_tail_grow.o";
 	__u32 exp_size;
diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_cpumap_attach.c b/tools/testing/selftests/bpf/prog_tests/xdp_cpumap_attach.c
index b353e1f3acb5..f775a1613833 100644
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
index 463a72fc3e70..ead40016c324 100644
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
2.35.1

