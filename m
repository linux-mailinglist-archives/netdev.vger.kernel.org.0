Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 025454FF38A
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 11:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233170AbiDMJd5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 05:33:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbiDMJd4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 05:33:56 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ECCD52E5B;
        Wed, 13 Apr 2022 02:31:36 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id o5-20020a17090ad20500b001ca8a1dc47aso5721347pju.1;
        Wed, 13 Apr 2022 02:31:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GlQcG7f/Vl8ZIHjycVnnZm2xMXgzFIcpVLLW16d1xbM=;
        b=ccL1haMV8PNuUuRABj6cJSN32U45FB1xJNAJiigg74Xrbnaki/OTxQmNQJVL4oraY+
         Gjk3Ut3Q6UeGZQ+ctMSBMp9DlJpmk3Td0EyOx7Q7YcRUrxkUnIvfujBZHSz9D2RDSwBP
         4v4l+4diRBuQlBdSsd9zp+Ky8Jw6CWFB/Vm7+0WkuMBenm0nJ6aVzhM3LRczTENkXQJs
         awqdmNRqSe7wUKdQMe8bWk4i8VEAhOn5apCE0ULyaVOs4Uej0snr5+ez/k4BGAl7Xh1r
         IjmC1jNtLhFkLxI43ibEg0qpcOKXf+2Yufz/dYPQqsYKTpvuQS5P1MVpdHozzP5RIhDs
         DPmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GlQcG7f/Vl8ZIHjycVnnZm2xMXgzFIcpVLLW16d1xbM=;
        b=Lq6NJl5rtBlDwHTZ/8Ow4mQ1MDgliYIYQZls6IOr4eHZ1SbPeXESVotcFw2a8dUPzR
         hn+5G2UqjrIak5F7B6jCl//FvkhdSntUceoIMo3Tymu+EYCO1/fSJX6RljTyYMy8GEWi
         oHTmYIhcIj1ZohhhPGhtVFftP/qiNl9Veh0lqvLSmRY0knubeWzd1T9fnxzjObhFZS6f
         1OXHcW6Pm6iLbd0hea1ISUWltwq/PjHQrc2kAv/ixCnvUzRhAwehawk5ex1H5PqDDae+
         JMpUIUYmZSZ4BLFI+SLxdpMKugM1uy4wRMCp1ApaxtUJDZBdV9HcOq/S6nIPCbQlndZ7
         MVew==
X-Gm-Message-State: AOAM532Pj/f+cDMvw+Ev+u3zEpfM1u8mhelxMiFMYh1Af7mRY92jlZXN
        ZnKY3kxboAilU6CoZntCk0o=
X-Google-Smtp-Source: ABdhPJyMRx3ulLDXmiaULULRDKi4lNbdHeq1Ekq4sRZ+YN30OOK3gC6hDz38EYLjkOZxd9kMpIeaWw==
X-Received: by 2002:a17:902:dac5:b0:158:5db6:3503 with SMTP id q5-20020a170902dac500b001585db63503mr15351287plx.76.1649842295604;
        Wed, 13 Apr 2022 02:31:35 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id s20-20020aa78d54000000b004fac74c83b3sm40300363pfe.186.2022.04.13.02.31.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 02:31:34 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: lv.ruyi@zte.com.cn
To:     shuah@kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, joannekoong@fb.com,
        lv.ruyi@zte.com.cn, toke@redhat.com, houtao1@huawei.com,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] bpf/benchs: fix error check return value of bpf_program__attach()
Date:   Wed, 13 Apr 2022 09:31:23 +0000
Message-Id: <20220413093123.2538001-1-lv.ruyi@zte.com.cn>
X-Mailer: git-send-email 2.25.1
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

From: Lv Ruyi <lv.ruyi@zte.com.cn>

bpf_program__attach() returns error ptr when it fails, so we should use
IS_ERR() to check it in error handling path. The patch fix all the same
problems in the bpf/benchs/*.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
---
 .../selftests/bpf/benchs/bench_bloom_filter_map.c      | 10 +++++-----
 tools/testing/selftests/bpf/benchs/bench_bpf_loop.c    |  2 +-
 tools/testing/selftests/bpf/benchs/bench_rename.c      |  2 +-
 tools/testing/selftests/bpf/benchs/bench_ringbufs.c    |  6 +++---
 tools/testing/selftests/bpf/benchs/bench_strncmp.c     |  2 +-
 tools/testing/selftests/bpf/benchs/bench_trigger.c     |  2 +-
 6 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/bpf/benchs/bench_bloom_filter_map.c b/tools/testing/selftests/bpf/benchs/bench_bloom_filter_map.c
index 5bcb8a8cdeb2..fd1be1042516 100644
--- a/tools/testing/selftests/bpf/benchs/bench_bloom_filter_map.c
+++ b/tools/testing/selftests/bpf/benchs/bench_bloom_filter_map.c
@@ -309,7 +309,7 @@ static void bloom_lookup_setup(void)
 	populate_maps();
 
 	link = bpf_program__attach(ctx.skel->progs.bloom_lookup);
-	if (!link) {
+	if (IS_ERR(link)) {
 		fprintf(stderr, "failed to attach program!\n");
 		exit(1);
 	}
@@ -326,7 +326,7 @@ static void bloom_update_setup(void)
 	populate_maps();
 
 	link = bpf_program__attach(ctx.skel->progs.bloom_update);
-	if (!link) {
+	if (IS_ERR(link)) {
 		fprintf(stderr, "failed to attach program!\n");
 		exit(1);
 	}
@@ -345,7 +345,7 @@ static void false_positive_setup(void)
 	populate_maps();
 
 	link = bpf_program__attach(ctx.skel->progs.bloom_hashmap_lookup);
-	if (!link) {
+	if (IS_ERR(link)) {
 		fprintf(stderr, "failed to attach program!\n");
 		exit(1);
 	}
@@ -363,7 +363,7 @@ static void hashmap_with_bloom_setup(void)
 	populate_maps();
 
 	link = bpf_program__attach(ctx.skel->progs.bloom_hashmap_lookup);
-	if (!link) {
+	if (IS_ERR(link)) {
 		fprintf(stderr, "failed to attach program!\n");
 		exit(1);
 	}
@@ -380,7 +380,7 @@ static void hashmap_no_bloom_setup(void)
 	populate_maps();
 
 	link = bpf_program__attach(ctx.skel->progs.bloom_hashmap_lookup);
-	if (!link) {
+	if (IS_ERR(link)) {
 		fprintf(stderr, "failed to attach program!\n");
 		exit(1);
 	}
diff --git a/tools/testing/selftests/bpf/benchs/bench_bpf_loop.c b/tools/testing/selftests/bpf/benchs/bench_bpf_loop.c
index d0a6572bfab6..8dbdc28d26c8 100644
--- a/tools/testing/selftests/bpf/benchs/bench_bpf_loop.c
+++ b/tools/testing/selftests/bpf/benchs/bench_bpf_loop.c
@@ -85,7 +85,7 @@ static void setup(void)
 	}
 
 	link = bpf_program__attach(ctx.skel->progs.benchmark);
-	if (!link) {
+	if (IS_ERR(link)) {
 		fprintf(stderr, "failed to attach program!\n");
 		exit(1);
 	}
diff --git a/tools/testing/selftests/bpf/benchs/bench_rename.c b/tools/testing/selftests/bpf/benchs/bench_rename.c
index 3c203b6d6a6e..66d63b92a28a 100644
--- a/tools/testing/selftests/bpf/benchs/bench_rename.c
+++ b/tools/testing/selftests/bpf/benchs/bench_rename.c
@@ -65,7 +65,7 @@ static void attach_bpf(struct bpf_program *prog)
 	struct bpf_link *link;
 
 	link = bpf_program__attach(prog);
-	if (!link) {
+	if (IS_ERR(link)) {
 		fprintf(stderr, "failed to attach program!\n");
 		exit(1);
 	}
diff --git a/tools/testing/selftests/bpf/benchs/bench_ringbufs.c b/tools/testing/selftests/bpf/benchs/bench_ringbufs.c
index c2554f9695ff..fff24ca82dc0 100644
--- a/tools/testing/selftests/bpf/benchs/bench_ringbufs.c
+++ b/tools/testing/selftests/bpf/benchs/bench_ringbufs.c
@@ -181,7 +181,7 @@ static void ringbuf_libbpf_setup(void)
 	}
 
 	link = bpf_program__attach(ctx->skel->progs.bench_ringbuf);
-	if (!link) {
+	if (IS_ERR(link)) {
 		fprintf(stderr, "failed to attach program!\n");
 		exit(1);
 	}
@@ -271,7 +271,7 @@ static void ringbuf_custom_setup(void)
 	}
 
 	link = bpf_program__attach(ctx->skel->progs.bench_ringbuf);
-	if (!link) {
+	if (IS_ERR(link)) {
 		fprintf(stderr, "failed to attach program\n");
 		exit(1);
 	}
@@ -426,7 +426,7 @@ static void perfbuf_libbpf_setup(void)
 	}
 
 	link = bpf_program__attach(ctx->skel->progs.bench_perfbuf);
-	if (!link) {
+	if (IS_ERR(link)) {
 		fprintf(stderr, "failed to attach program\n");
 		exit(1);
 	}
diff --git a/tools/testing/selftests/bpf/benchs/bench_strncmp.c b/tools/testing/selftests/bpf/benchs/bench_strncmp.c
index 494b591c0289..dcb9ce5ffcb0 100644
--- a/tools/testing/selftests/bpf/benchs/bench_strncmp.c
+++ b/tools/testing/selftests/bpf/benchs/bench_strncmp.c
@@ -103,7 +103,7 @@ static void strncmp_attach_prog(struct bpf_program *prog)
 	struct bpf_link *link;
 
 	link = bpf_program__attach(prog);
-	if (!link) {
+	if (IS_ERR(link)) {
 		fprintf(stderr, "failed to attach program!\n");
 		exit(1);
 	}
diff --git a/tools/testing/selftests/bpf/benchs/bench_trigger.c b/tools/testing/selftests/bpf/benchs/bench_trigger.c
index 0c481de2833d..bda930a8153c 100644
--- a/tools/testing/selftests/bpf/benchs/bench_trigger.c
+++ b/tools/testing/selftests/bpf/benchs/bench_trigger.c
@@ -61,7 +61,7 @@ static void attach_bpf(struct bpf_program *prog)
 	struct bpf_link *link;
 
 	link = bpf_program__attach(prog);
-	if (!link) {
+	if (IS_ERR(link)) {
 		fprintf(stderr, "failed to attach program!\n");
 		exit(1);
 	}
-- 
2.25.1

