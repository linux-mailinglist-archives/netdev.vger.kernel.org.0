Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E651F58F66F
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 05:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233645AbiHKDkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 23:40:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbiHKDke (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 23:40:34 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E5041CB19;
        Wed, 10 Aug 2022 20:40:34 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id o5-20020a17090a3d4500b001ef76490983so3969051pjf.2;
        Wed, 10 Aug 2022 20:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=Mk3j1i9fjva3zOn4D60tqeJdxJKrOKo4G/RmrY0teV8=;
        b=IKwV+B6G1N4PQzIEcp5Yq2XmnVU3ng7UhjBM7VRyqRt6Ug+yyLCE96ukuk8chUd0IS
         eAQzPW2KbdzGtchePxc1BfZ29DiXEQ0HLQA+iI42BvFnNegrdZOPFBXZPWpuyPx27PQT
         VmPY6SaTGD8C21vmFQo+QQNELnRce3IHK7FgsLyIgkrq3otgRsr/KSamnv3cJt9Z9VWw
         Zc7hwA+p+/2PqN7APfyS7zJwPVQ+lyUVFVguWTBN+qwd2EnR722ryBl+JL3oE2ZBYqAf
         9NNDe1k6yeDgb7L7nMCtkZx4rVXdHnrgzGzDf+yFLXmNtZhkJIERTZG1LspGFEn4E2gz
         nogQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=Mk3j1i9fjva3zOn4D60tqeJdxJKrOKo4G/RmrY0teV8=;
        b=tyyCibscMa8H4oLHT8SGkfNi5DPXXOZObzjlAKQDg6BQQNMNzZstrCIWR9fCg0UcFY
         4TD7Q8tgOyjpZccw7FJAF5Jh+LWSxIXLCjLzj4U7/Na0xIMXXSDgmDqnPSZCcwflXaZ5
         LhgrP0fIpe/DM4vW7HYKCtHIMEccyRVpVhQFCqFJ0bKrRK0N5uL9pSRho5+YfzXjhumV
         ogxbzr/XXv1vKnMIiWgBDzZOPq1SC+FUsMgyyhU7Mp8gaW6VoeQCYBZHoEjr18fyKl4i
         nUrtGpfKbwv9DI70SDAnGy3/S4vaWD1qP5tmfETYdZEKxYU15QvHThXabZ59xq+o9Nzp
         VnZQ==
X-Gm-Message-State: ACgBeo3XKA66bEXk+9YBy25wrx8mZzn+aYkQRaqQwl0LL6fiKXLur8vI
        8zgbObPQA6wxOBd06I2S+m5KAttjt8U=
X-Google-Smtp-Source: AA6agR4V2BtEtEDGSkZJrGHu61syc3ugZApTaNsb/bNiRKPFRrcCWCJ7cdn6sKp/YC79jGNNLDONHQ==
X-Received: by 2002:a17:90a:c402:b0:1f7:75ce:1206 with SMTP id i2-20020a17090ac40200b001f775ce1206mr6782355pjt.68.1660189233445;
        Wed, 10 Aug 2022 20:40:33 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i6-20020a654d06000000b0040df0c9a1aasm10433017pgt.14.2022.08.10.20.40.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 20:40:32 -0700 (PDT)
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
Subject: [PATCHv3 bpf-next] libbpf: Add names for auxiliary maps
Date:   Thu, 11 Aug 2022 11:40:20 +0800
Message-Id: <20220811034020.529685-1-liuhangbin@gmail.com>
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

The bpftool self-created maps can appear in final map show output due to
deferred removal in kernel. These maps don't have a name, which would make
users confused about where it comes from.

With a libbpf_ prefix name, users could know who created these maps.
It also could make some tests (like test_offload.py, which skip base maps
without names as a workaround) filter them out.

Kernel adds bpf prog/map name support in the same merge
commit fadad670a8ab ("Merge branch 'bpf-extend-info'"). So we can also use
kernel_supports(NULL, FEAT_PROG_NAME) to check if kernel supports map name.

As disscussed[1], Let's make bpf_map_create accept non-null
name string, and silently ignore the name if kernel doesn't support.

[1] https://lore.kernel.org/bpf/CAEf4BzYL1TQwo1231s83pjTdFPk9XWWhfZC5=KzkU-VO0k=0Ug@mail.gmail.com/

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
v3: let bpf_map_create ignore the name if kernel doesn't support
v2: rename the wrapper with proper name
---
 tools/lib/bpf/bpf.c    | 2 +-
 tools/lib/bpf/libbpf.c | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index efcc06dafbd9..6a96e665dc5d 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -183,7 +183,7 @@ int bpf_map_create(enum bpf_map_type map_type,
 		return libbpf_err(-EINVAL);
 
 	attr.map_type = map_type;
-	if (map_name)
+	if (map_name && kernel_supports(NULL, FEAT_PROG_NAME))
 		libbpf_strlcpy(attr.map_name, map_name, sizeof(attr.map_name));
 	attr.key_size = key_size;
 	attr.value_size = value_size;
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index f7364ea82ac1..a075211b3730 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4432,7 +4432,7 @@ static int probe_kern_global_data(void)
 	};
 	int ret, map, insn_cnt = ARRAY_SIZE(insns);
 
-	map = bpf_map_create(BPF_MAP_TYPE_ARRAY, NULL, sizeof(int), 32, 1, NULL);
+	map = bpf_map_create(BPF_MAP_TYPE_ARRAY, "libbpf_global", sizeof(int), 32, 1, NULL);
 	if (map < 0) {
 		ret = -errno;
 		cp = libbpf_strerror_r(ret, errmsg, sizeof(errmsg));
@@ -4565,7 +4565,7 @@ static int probe_kern_array_mmap(void)
 	LIBBPF_OPTS(bpf_map_create_opts, opts, .map_flags = BPF_F_MMAPABLE);
 	int fd;
 
-	fd = bpf_map_create(BPF_MAP_TYPE_ARRAY, NULL, sizeof(int), sizeof(int), 1, &opts);
+	fd = bpf_map_create(BPF_MAP_TYPE_ARRAY, "libbpf_mmap", sizeof(int), sizeof(int), 1, &opts);
 	return probe_fd(fd);
 }
 
@@ -4612,7 +4612,7 @@ static int probe_prog_bind_map(void)
 	};
 	int ret, map, prog, insn_cnt = ARRAY_SIZE(insns);
 
-	map = bpf_map_create(BPF_MAP_TYPE_ARRAY, NULL, sizeof(int), 32, 1, NULL);
+	map = bpf_map_create(BPF_MAP_TYPE_ARRAY, "libbpf_det_bind", sizeof(int), 32, 1, NULL);
 	if (map < 0) {
 		ret = -errno;
 		cp = libbpf_strerror_r(ret, errmsg, sizeof(errmsg));
-- 
2.35.3

