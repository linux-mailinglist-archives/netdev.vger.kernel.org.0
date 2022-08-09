Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3AB58D736
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 12:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242003AbiHIKMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 06:12:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241979AbiHIKMv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 06:12:51 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A03BA23BE3;
        Tue,  9 Aug 2022 03:12:50 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id t22so11252084pjy.1;
        Tue, 09 Aug 2022 03:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=nqZuPWyUKDBczjfrPZXUe7GefybGLiQTHofEz305zjA=;
        b=GLnu6KX62PSwJ/S3BbxAvge02V+e4wMIf6UwMCoHY/ZnWO2DxSEMsEo5WkHIVBmIVT
         Pv3ACuyXCeQ521pGm0AIACVE6cGnCBPqXmz/XSMRfzS/qGyNdHvwS6k5bAYNIOL1bQ7J
         rDVcpU+hDAp2bXMSWyQBxhK6q/VO6jq3kDa4daa88x9VQDx8sl1Pd4Le8u5sqrbN5gel
         xwJqy4zvJ7X+kPdhYi4Sy8EO/QHi+5DbG+Y2VXnTvZOOk6oHIjWKPamWqi64hWsYOpaq
         CUGTbhA5ynl1nXumybCO2iC/fyJE1AaKonu/ueRja7wTaDUyxlRvK6YA1LIM1ynDmO+I
         f8rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=nqZuPWyUKDBczjfrPZXUe7GefybGLiQTHofEz305zjA=;
        b=0zNmZ7AqmoKEr3FK7VmPEJI21c6XCAg9o3eZ6JmhZzJHZrXLLmazuojuowR3Sfbh+Z
         dYRcnzkuqPKqyh2S3o/eaK39AdtHwuGvM95EDc8g99v1myjnxNea9s5mw/+XjCZMmj29
         pnEwkdmarRVleiTwRMfEtQuUpZbviDSfi0XJB99bU4hAbJjyolayGIVttctSDDblA9Ul
         AOx3u+oYRncroor09e67uEQGPL8ycq+ctmSmvM0DEwTx5L2f/b59/X0WU/XkDvPxDep+
         BZK0R4w78wY4iO1lGlwV8yHmnOzzUZY1aoi0nYqMuw2FuQEtykdjubiqqOsPjutLsOnP
         WGUg==
X-Gm-Message-State: ACgBeo0MRwBl+rPG4fQxMgAu0BO8WVXiIiqbBcUP/3VbQNfZhRmSvUNs
        2LRT8MPyeizoaQVybweA4tPb8sS7u1l0Kg==
X-Google-Smtp-Source: AA6agR4LnJQMVGgbSBBNkVRf3I0y0BSJpQl7tNjJvJbbJEW+hlquZ+Ut8L5640fooHfJp1nFPnzW8Q==
X-Received: by 2002:a17:90a:d783:b0:1f4:e30b:ece with SMTP id z3-20020a17090ad78300b001f4e30b0ecemr25561932pju.165.1660039969998;
        Tue, 09 Aug 2022 03:12:49 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y5-20020a17090322c500b0016dbe5f5308sm10507333plg.79.2022.08.09.03.12.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Aug 2022 03:12:49 -0700 (PDT)
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
Subject: [PATCHv2 bpf-next] libbpf: try to add a name for bpftool self-created maps
Date:   Tue,  9 Aug 2022 18:12:39 +0800
Message-Id: <20220809101239.205109-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.35.3
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

As discussed before[1], the bpftool self-created maps can appear in final
map show output due to deferred removal in kernel. These maps don't have
a name, which would make users confused about where it comes from.

Adding names for these maps could make users know what these maps used for.
It also could make some tests (like test_offload.py, which skip base maps
without names as a workaround) filter them out.

As Quentin suggested, add a small wrapper to fall back with no name
if kernel is not supported.

[1] https://lore.kernel.org/bpf/CAEf4BzY66WPKQbDe74AKZ6nFtZjq5e+G3Ji2egcVytB9R6_sGQ@mail.gmail.com/

Suggested-by: Quentin Monnet <quentin@isovalent.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
v2: rename the wrapper with proper name
---
 tools/lib/bpf/libbpf.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index f7364ea82ac1..a38bcf325198 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4421,6 +4421,22 @@ static int probe_kern_prog_name(void)
 	return probe_fd(ret);
 }
 
+static int map_create_adjust_name(enum bpf_map_type map_type,
+				  const char *map_name, __u32 key_size,
+				  __u32 value_size, __u32 max_entries,
+				  const struct bpf_map_create_opts *opts)
+{
+	int map;
+
+	map = bpf_map_create(map_type, map_name, key_size, value_size, max_entries, opts);
+	if (map < 0 && errno == EINVAL) {
+		/* Retry without name */
+		map = bpf_map_create(map_type, NULL, key_size, value_size, max_entries, opts);
+	}
+
+	return map;
+}
+
 static int probe_kern_global_data(void)
 {
 	char *cp, errmsg[STRERR_BUFSIZE];
@@ -4432,7 +4448,7 @@ static int probe_kern_global_data(void)
 	};
 	int ret, map, insn_cnt = ARRAY_SIZE(insns);
 
-	map = bpf_map_create(BPF_MAP_TYPE_ARRAY, NULL, sizeof(int), 32, 1, NULL);
+	map = map_create_adjust_name(BPF_MAP_TYPE_ARRAY, "libbpf_global", sizeof(int), 32, 1, NULL);
 	if (map < 0) {
 		ret = -errno;
 		cp = libbpf_strerror_r(ret, errmsg, sizeof(errmsg));
@@ -4565,7 +4581,7 @@ static int probe_kern_array_mmap(void)
 	LIBBPF_OPTS(bpf_map_create_opts, opts, .map_flags = BPF_F_MMAPABLE);
 	int fd;
 
-	fd = bpf_map_create(BPF_MAP_TYPE_ARRAY, NULL, sizeof(int), sizeof(int), 1, &opts);
+	fd = map_create_adjust_name(BPF_MAP_TYPE_ARRAY, "libbpf_mmap", sizeof(int), sizeof(int), 1, &opts);
 	return probe_fd(fd);
 }
 
@@ -4612,7 +4628,7 @@ static int probe_prog_bind_map(void)
 	};
 	int ret, map, prog, insn_cnt = ARRAY_SIZE(insns);
 
-	map = bpf_map_create(BPF_MAP_TYPE_ARRAY, NULL, sizeof(int), 32, 1, NULL);
+	map = map_create_adjust_name(BPF_MAP_TYPE_ARRAY, "libbpf_det_bind", sizeof(int), 32, 1, NULL);
 	if (map < 0) {
 		ret = -errno;
 		cp = libbpf_strerror_r(ret, errmsg, sizeof(errmsg));
-- 
2.35.3

