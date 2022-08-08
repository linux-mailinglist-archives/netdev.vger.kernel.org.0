Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F98658C5AF
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 11:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242439AbiHHJeK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 05:34:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242453AbiHHJdz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 05:33:55 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9DC614091;
        Mon,  8 Aug 2022 02:33:26 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id w14so8016023plp.9;
        Mon, 08 Aug 2022 02:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=Z1uT8jklHzFs+Qqg2Bpkc6FzIfa51gNhe/3K3u4H3l4=;
        b=kjDKEHbnBXOOG4rch5CW2yG327rd0Egjstadj1AnPQW6FXY3kOTx+EcY4o+vhTLNTk
         GBfRXwO+f5PjaLj1X+uogcStK/EcR0YE/LZBWULcRJ/IbdBlc3yUe6Y595LegSW3RldD
         cx6LEfMewq/HKayzmwWPh1I8L1H2snOI7KQ9S3ACv4N2Eh2Y0ViyKKk6ZWEMsJijUC1C
         BU29M9SKXMkqg3TAqfpM9snWONv8NVRZf4nJQ4OHr/WrT4IYyOFSYy4l8qVKjeXM4obg
         V3JQWzux3xg1ADNbF9WHXjF0eLRf9ojGvCIXj9mufocgQMN78LGsn4qqZ1SjxPvIMplI
         I9pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=Z1uT8jklHzFs+Qqg2Bpkc6FzIfa51gNhe/3K3u4H3l4=;
        b=WM8McTUW8syq1/qNwsotuaT0a4nHnvBh3+P1gUjjluEK3VX3MgqMeMlhppn+wdRVx6
         kvbjYb48t0u9XoDDe2QCl5wBDlHYciT2iUi1p0VANPouYQX4VHwQB19d0luoNvW4PIWJ
         TE7TRRjBhcN23Xcg7GcF7I8RY90jKTXC+5Vw0ooFfwCQL6BedZSltUTEBTMhnEMI+h1+
         yMyOtEuD2ZSFO8N6qCZ03yojzCVOhP0X5QYN8Oos/V13DZgt96wDNSmJPUIHJxV0QZlC
         KWJZAIpvAK3+Fi72dL4VmZTFvk8DMcexAelaQUx2SDAbT1Vnw2tjqqPb9s32jXXT+eeU
         X7jg==
X-Gm-Message-State: ACgBeo3YcC2uXiJr+q5KOARZcIRARHDQzpA0vBjeEdKi6GmitqsQZWei
        aYIgtg5owV69s/rqIcpWJbRdOYJAJlP/4Q==
X-Google-Smtp-Source: AA6agR4kqtyhCiVuxOX4UvLanuXtrQ1hJyKGHp2I1OFz9hPAfhHqXOPgG7h47Ye6F8H+4Dwt9BLFcg==
X-Received: by 2002:a17:90a:d585:b0:1f4:f9a5:22a9 with SMTP id v5-20020a17090ad58500b001f4f9a522a9mr28677272pju.49.1659951205996;
        Mon, 08 Aug 2022 02:33:25 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id n4-20020a63e044000000b00415320bc31dsm5878286pgj.32.2022.08.08.02.33.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Aug 2022 02:33:25 -0700 (PDT)
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
Subject: [PATCH bpf-next] libbpf: try to add a name for bpftool self-created maps
Date:   Mon,  8 Aug 2022 17:33:04 +0800
Message-Id: <20220808093304.46291-1-liuhangbin@gmail.com>
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
 tools/lib/bpf/libbpf.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 77e3797cf75a..db4f1a02b9e0 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4423,6 +4423,22 @@ static int probe_kern_prog_name(void)
 	return probe_fd(ret);
 }
 
+static int probe_kern_map_name(enum bpf_map_type map_type,
+			       const char *map_name, __u32 key_size,
+			       __u32 value_size, __u32 max_entries,
+			       const struct bpf_map_create_opts *opts)
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
@@ -4434,7 +4450,7 @@ static int probe_kern_global_data(void)
 	};
 	int ret, map, insn_cnt = ARRAY_SIZE(insns);
 
-	map = bpf_map_create(BPF_MAP_TYPE_ARRAY, NULL, sizeof(int), 32, 1, NULL);
+	map = probe_kern_map_name(BPF_MAP_TYPE_ARRAY, "global_data", sizeof(int), 32, 1, NULL);
 	if (map < 0) {
 		ret = -errno;
 		cp = libbpf_strerror_r(ret, errmsg, sizeof(errmsg));
@@ -4567,7 +4583,7 @@ static int probe_kern_array_mmap(void)
 	LIBBPF_OPTS(bpf_map_create_opts, opts, .map_flags = BPF_F_MMAPABLE);
 	int fd;
 
-	fd = bpf_map_create(BPF_MAP_TYPE_ARRAY, NULL, sizeof(int), sizeof(int), 1, &opts);
+	fd = probe_kern_map_name(BPF_MAP_TYPE_ARRAY, "array_mmap", sizeof(int), sizeof(int), 1, &opts);
 	return probe_fd(fd);
 }
 
@@ -4614,7 +4630,7 @@ static int probe_prog_bind_map(void)
 	};
 	int ret, map, prog, insn_cnt = ARRAY_SIZE(insns);
 
-	map = bpf_map_create(BPF_MAP_TYPE_ARRAY, NULL, sizeof(int), 32, 1, NULL);
+	map = probe_kern_map_name(BPF_MAP_TYPE_ARRAY, "bind_map_detect", sizeof(int), 32, 1, NULL);
 	if (map < 0) {
 		ret = -errno;
 		cp = libbpf_strerror_r(ret, errmsg, sizeof(errmsg));
-- 
2.35.3

