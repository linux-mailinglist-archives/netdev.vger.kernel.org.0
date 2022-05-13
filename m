Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D59F525929
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 03:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359863AbiEMBBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 21:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359862AbiEMBB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 21:01:29 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EADCC369D2;
        Thu, 12 May 2022 18:01:27 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id a191so6102081pge.2;
        Thu, 12 May 2022 18:01:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8lNrBu7iRaQlA9BDLbcaT8Dxm63DhLNUJbaN6jF3jlE=;
        b=UPJLZXnBKLt9czR7ENUYjEwJqEmw9rAhwVuvoguL++3lwYpcIOb1bWngCyXrEdnaLL
         wCBQ9QbP6m9qh4IkUup/PfwsA3PDIXct9ZEFBBcaxFPZK7DtSipl7D9mJX282YVA/7VK
         GzHgiqv0ZXD09ZUkXw9VZOuJViTogGKBzCs/j7f0RXxVYXPf5oEwfsSG6i11GxpdDPZS
         tOET/USEMw5jxLB4Zu0Isr1REjZ2yg1Hw/1N+TI+2GER3jt2WtQVnDM1m33nvy+0D/4j
         sDlXvZJF8VGmf6Xk7BOaQgN6iyr8h8HRB+BgpopKAC2yPrLvjhUg5CRsQTUBlSrnrFat
         sV+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8lNrBu7iRaQlA9BDLbcaT8Dxm63DhLNUJbaN6jF3jlE=;
        b=MyI8VlNvRHdcA/rcWJNmMJJ9f4pRR8eLu3cVSvxo3x4HyuKBgSrpUEmIcJ/7gMC1n2
         tNejsSLugSkzYpNaCdNl91nKqAkTlmn6yGi3LdhM/yWEe/uppkt4ivD+GTJCiKBXexqF
         bFYJXMCMTLY7HPHYJR2i9m8lz9iAByP4Fqmt9k/d0TdgDDUyFA69PAjdEWxzxLiOAh0s
         d2R21I7ARRklVvIpN7sp7GU1gMnjb1Sa54Fyv6mbG1VihArNuJnvI39LluG6uK5TFk8t
         E8P8bq2oZ1yd7pnI7kqTdDLipoJmw6UWLAAmVL5l3Di3klM2B/feowiiEaFV0khFCxgN
         wLMQ==
X-Gm-Message-State: AOAM530g1N3e1+EgMpW12Bx3zf33QW4RhoSz71X7CEsyYAF4ClK6crzU
        w7j831tltNL0bDtoas1suwCPRME9BYSuTw==
X-Google-Smtp-Source: ABdhPJxkXpvj8MQvNuqXRlG72CStzSpu43zpYbso4FuDsX3NAJsyO6CQq9SejVpxlCy18DoXASV3cg==
X-Received: by 2002:aa7:84d1:0:b0:510:8796:4f38 with SMTP id x17-20020aa784d1000000b0051087964f38mr2010045pfn.8.1652403687276;
        Thu, 12 May 2022 18:01:27 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i7-20020a63cd07000000b003c14af5063esm323149pgg.86.2022.05.12.18.01.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 18:01:26 -0700 (PDT)
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
Subject: [PATCHv2 bpf-next 1/2] selftests/bpf: Fix build error with ima_setup.sh
Date:   Fri, 13 May 2022 09:01:09 +0800
Message-Id: <20220513010110.319061-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220513010110.319061-1-liuhangbin@gmail.com>
References: <20220513010110.319061-1-liuhangbin@gmail.com>
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

