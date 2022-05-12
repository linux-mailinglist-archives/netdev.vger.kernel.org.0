Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 504A05246B7
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 09:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350863AbiELHSw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 03:18:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350871AbiELHSm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 03:18:42 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76B36BCE9C;
        Thu, 12 May 2022 00:18:38 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id c14so4034352pfn.2;
        Thu, 12 May 2022 00:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8lNrBu7iRaQlA9BDLbcaT8Dxm63DhLNUJbaN6jF3jlE=;
        b=kDbrU9IxXlNiyEhYINlb1IAJQLgxaiJZmRNpOdbv2L9BLIcMSljh+CGHR1ZCyPx46z
         CcMew3i3WX7EGkmMM8Ypr04ZrVpy2ipkVH5cPAhWfnp7Ti+vglGveqWm9akXb7UWnhbe
         oq3GPNHyPSMFi0g/PVNAxIZ8Pp46PrUx51sTO094AaJe09Hsp3EuKoIXXuNdWtAjPMeJ
         gcChVYUyjIhF+BcLV5dqc9QXDQopFVUGvmVPDHe4MJOvZlPXm06V/W0kU1ae/6ospQQ9
         nd2DPE3Ef543XDAOC9myJkUtKyM1+fI4tClQYj7VxXtz1osgvOk2OTZ2xKNc2YUyUY8W
         wIug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8lNrBu7iRaQlA9BDLbcaT8Dxm63DhLNUJbaN6jF3jlE=;
        b=6aqnKsYHuDZbXwfyfGvKRniDG+N5bwFzjjxTDm4vLC3Limi+PLwckVVW9Ms1S67zx/
         1D6HjBTeOMmCAZ8mi78CpquLdw7kAcvR8khd2K5mL/k4j2utKBnBSzc3sTtKVE/w4v0e
         hzOWXonfT74JOFInz7F+34MufdkzxyyPUV1eUoy8N1JY8XH4MBASTJ495ftpuaXXe7t0
         dx9zSU/iRx2tJf6gSBHenWiL9xl2YN9eWCnHN19gdl7Knfl6M3r0sLPN+yhPhSXvMrnL
         GSL+/LM+AN0PRDiVJeQto8gaSvAzd4ZsMqOU/l45QTJYJqmfitZf+QMnUozJ3eTu/trK
         Ed6Q==
X-Gm-Message-State: AOAM531w1/iDBSlW/NKwLx9zVGVIob02WB17yOECf85gzmGYaNLfXkSa
        MSiDY/lVb8d7oXdP/QLLVw1GEC/zOsPaBg==
X-Google-Smtp-Source: ABdhPJxd4/ut7jPbhH/ynuqhsjuPGADP8Imx5RLX0trUZ0jhawdbTJZzvXg9U/z+NRx8xCZKDPkZrQ==
X-Received: by 2002:a05:6a02:10d:b0:381:f4c8:ad26 with SMTP id bg13-20020a056a02010d00b00381f4c8ad26mr23922668pgb.135.1652339917710;
        Thu, 12 May 2022 00:18:37 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w17-20020a170902e89100b0015e8d4eb2b4sm3244533plg.254.2022.05.12.00.18.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 00:18:36 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        linux-kselftest@vger.kernel.org, bpf@vger.kernel.org,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net 1/2] selftests/bpf: Fix build error with ima_setup.sh
Date:   Thu, 12 May 2022 15:18:18 +0800
Message-Id: <20220512071819.199873-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220512071819.199873-1-liuhangbin@gmail.com>
References: <20220512071819.199873-1-liuhangbin@gmail.com>
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

KP fixed ima_setup.sh missing issue when build test_progs separately with
commit 854055c0cf30 ("selftests/bpf: Fix flavored variants of
test_ima"). But the fix is incorrect because the build will failed with
error:

  $ OUTPUT="/tmp/bpf" make test_progs
    [...]
  make: *** No rule to make target '/tmp/bpf/ima_setup.sh', needed by 'ima_setup.sh'.  Stop.

Fix it by adding a new variable TRUNNER_EXTRA_BUILD to build extra binaries.
Left TRUNNER_EXTRA_FILES only for copying files

Fixes: 854055c0cf30 ("selftests/bpf: Fix flavored variants of test_ima")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/testing/selftests/bpf/Makefile | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 3820608faf57..5944d3a8fff6 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -466,10 +466,10 @@ $(TRUNNER_EXTRA_OBJS): $(TRUNNER_OUTPUT)/%.o:				\
 
 # non-flavored in-srctree builds receive special treatment, in particular, we
 # do not need to copy extra resources (see e.g. test_btf_dump_case())
-$(TRUNNER_BINARY)-extras: $(TRUNNER_EXTRA_FILES) | $(TRUNNER_OUTPUT)
+$(TRUNNER_BINARY)-extras: $(TRUNNER_EXTRA_BUILD) | $(TRUNNER_OUTPUT)
 ifneq ($2:$(OUTPUT),:$(shell pwd))
 	$$(call msg,EXT-COPY,$(TRUNNER_BINARY),$(TRUNNER_EXTRA_FILES))
-	$(Q)rsync -aq $$^ $(TRUNNER_OUTPUT)/
+	$(Q)rsync -aq $(TRUNNER_EXTRA_FILES) $(TRUNNER_OUTPUT)/
 endif
 
 $(OUTPUT)/$(TRUNNER_BINARY): $(TRUNNER_TEST_OBJS)			\
@@ -490,9 +490,9 @@ TRUNNER_EXTRA_SOURCES := test_progs.c cgroup_helpers.c trace_helpers.c	\
 			 network_helpers.c testing_helpers.c		\
 			 btf_helpers.c flow_dissector_load.h		\
 			 cap_helpers.c
-TRUNNER_EXTRA_FILES := $(OUTPUT)/urandom_read $(OUTPUT)/bpf_testmod.ko	\
-		       ima_setup.sh					\
+TRUNNER_EXTRA_BUILD := $(OUTPUT)/urandom_read $(OUTPUT)/bpf_testmod.ko	\
 		       $(wildcard progs/btf_dump_test_case_*.c)
+TRUNNER_EXTRA_FILES := $(TRUNNER_EXTRA_BUILD) ima_setup.sh
 TRUNNER_BPF_BUILD_RULE := CLANG_BPF_BUILD_RULE
 TRUNNER_BPF_CFLAGS := $(BPF_CFLAGS) $(CLANG_CFLAGS) -DENABLE_ATOMICS_TESTS
 $(eval $(call DEFINE_TEST_RUNNER,test_progs))
@@ -513,6 +513,7 @@ endif
 TRUNNER_TESTS_DIR := map_tests
 TRUNNER_BPF_PROGS_DIR := progs
 TRUNNER_EXTRA_SOURCES := test_maps.c
+TRUNNER_EXTRA_BUILD :=
 TRUNNER_EXTRA_FILES :=
 TRUNNER_BPF_BUILD_RULE := $$(error no BPF objects should be built)
 TRUNNER_BPF_CFLAGS :=
-- 
2.35.1

