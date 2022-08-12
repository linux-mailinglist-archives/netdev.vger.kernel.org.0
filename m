Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2207590A59
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 04:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236723AbiHLCkv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 22:40:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235200AbiHLCku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 22:40:50 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1361113E04;
        Thu, 11 Aug 2022 19:40:49 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 24so2244187pgr.7;
        Thu, 11 Aug 2022 19:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=DIcwJvYXEEGxgAne15ybzf6JBPEATrgdBirQ9Ch5jbM=;
        b=I02CZkt3njve4du9UX9KyHovHhOV9kQZ4qS9rM/UOp+zF0v9+7s2dMngx/OeBIkEfb
         xU8+N/MV2TUOSWTT6CU+//NLmhWYjbTiQ0eq03AS+P0m6nyGMJQ5n4xW5s9VHBd91DJE
         39ielXTVZztWVWa99fSgga3SkOOz8L3A4CtoJhlE/Bw2/JjXXpNXQ4abrsmsqdb/BR/e
         v6YOYn5zZ7nl5j6/Rm06sMvZogoQPVEvlqGmmBGbmKRPZXgnxygDGZcc/eVPxHugTnGT
         psU0Raq8XGQpog3qBmd0KtxJHqqggSPhc5G7RzgRaiicnnRgr7MY6DFtvS4NEkKXQii0
         IclA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=DIcwJvYXEEGxgAne15ybzf6JBPEATrgdBirQ9Ch5jbM=;
        b=h1oSr7s6r2BxwVnl08HrrsgxFIIEItiGixmGYIPfHVhi1m0FLk5/SgTDY3RYb7Sct1
         eIvfedG98V3poBJ/QVkhW9FYZ5Ooc9xtqoGtI019cBgRRTC4IbhfyLlt53Q5HGOXWei8
         qECukkQMNmsDH1s2tYurwo8ada0kZVOQRFgZIyGjlnqZVtFClLD3GjdGXCzTUYP1vC5Y
         7VcfMkcOvIElrhcyWQG5oZ1rIxb7qPvtUij1+uJKiW49SLdnfl+boneBzj3X0NF+nQMX
         eGeY5Duqjb5cdhlkm1IcepiBBhpvhQi6gTR/cNOU8u6zJySzmrRB8fANnOUmuke6NSOf
         S8Yw==
X-Gm-Message-State: ACgBeo15r3tRptk4e7c+pM4GQeKhxAJrD0Okfe76tMTmZE7gk0ZGR5Ne
        /d8zSFh7XDbhHsrOb5ZGabYjMW0yQRk8Qw==
X-Google-Smtp-Source: AA6agR7dol9FIRvuy+F2aOAUGNCnwh8+KfBElb+iVjcXA9KRSAV/vUTHdofTWWZyz5BT8E+kbODJMQ==
X-Received: by 2002:a65:6bc4:0:b0:3c2:2f7c:cc74 with SMTP id e4-20020a656bc4000000b003c22f7ccc74mr1475973pgw.307.1660272048407;
        Thu, 11 Aug 2022 19:40:48 -0700 (PDT)
Received: from Leo-laptop-t470s.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b10-20020aa7950a000000b0052d3a442760sm399133pfp.161.2022.08.11.19.40.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Aug 2022 19:40:47 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Quentin Monnet <quentin@isovalent.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        bpf@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH bpf-next] libbpf: making bpf_prog_load() ignore name if kernel doesn't support
Date:   Fri, 12 Aug 2022 10:40:38 +0800
Message-Id: <20220812024038.7056-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
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

Similar with commit 10b62d6a38f7 ("libbpf: Add names for auxiliary maps"),
let's make bpf_prog_load() also ignore name if kernel doesn't support
program name.

To achieve this, we need to call sys_bpf_prog_load() directly in
probe_kern_prog_name() to avoid circular dependency. sys_bpf_prog_load()
also need to be exported in the bpf.h file.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/lib/bpf/bpf.c    |  6 ++----
 tools/lib/bpf/bpf.h    |  3 +++
 tools/lib/bpf/libbpf.c | 11 +++++++++--
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 6a96e665dc5d..575867d69496 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -84,9 +84,7 @@ static inline int sys_bpf_fd(enum bpf_cmd cmd, union bpf_attr *attr,
 	return ensure_good_fd(fd);
 }
 
-#define PROG_LOAD_ATTEMPTS 5
-
-static inline int sys_bpf_prog_load(union bpf_attr *attr, unsigned int size, int attempts)
+int sys_bpf_prog_load(union bpf_attr *attr, unsigned int size, int attempts)
 {
 	int fd;
 
@@ -263,7 +261,7 @@ int bpf_prog_load(enum bpf_prog_type prog_type,
 	attr.prog_ifindex = OPTS_GET(opts, prog_ifindex, 0);
 	attr.kern_version = OPTS_GET(opts, kern_version, 0);
 
-	if (prog_name)
+	if (prog_name && kernel_supports(NULL, FEAT_PROG_NAME))
 		libbpf_strlcpy(attr.prog_name, prog_name, sizeof(attr.prog_name));
 	attr.license = ptr_to_u64(license);
 
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index 9c50beabdd14..125c580e45f8 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -35,6 +35,9 @@
 extern "C" {
 #endif
 
+#define PROG_LOAD_ATTEMPTS 5
+int sys_bpf_prog_load(union bpf_attr *attr, unsigned int size, int attempts);
+
 int libbpf_set_memlock_rlim(size_t memlock_bytes);
 
 struct bpf_map_create_opts {
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 3f01f5cd8a4c..1bcb2735d3f1 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4419,10 +4419,17 @@ static int probe_kern_prog_name(void)
 		BPF_MOV64_IMM(BPF_REG_0, 0),
 		BPF_EXIT_INSN(),
 	};
-	int ret, insn_cnt = ARRAY_SIZE(insns);
+	union bpf_attr attr = {
+		.prog_type = BPF_PROG_TYPE_SOCKET_FILTER,
+		.prog_name = "test",
+		.license = ptr_to_u64("GPL"),
+		.insns = ptr_to_u64(insns),
+		.insn_cnt = (__u32)ARRAY_SIZE(insns),
+	};
+	int ret;
 
 	/* make sure loading with name works */
-	ret = bpf_prog_load(BPF_PROG_TYPE_SOCKET_FILTER, "test", "GPL", insns, insn_cnt, NULL);
+	ret = sys_bpf_prog_load(&attr, sizeof(attr), PROG_LOAD_ATTEMPTS);
 	return probe_fd(ret);
 }
 
-- 
2.31.1

