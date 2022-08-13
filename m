Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A49CA5917C0
	for <lists+netdev@lfdr.de>; Sat, 13 Aug 2022 02:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233658AbiHMAJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 20:09:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbiHMAJr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 20:09:47 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC2E5C9EB;
        Fri, 12 Aug 2022 17:09:46 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id r69so2033451pgr.2;
        Fri, 12 Aug 2022 17:09:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=QCoo4xxPRwybL2sxSPQ1iW5RKTF4ovgXlfByMe2GkbI=;
        b=jp6maD3fBFv6j10bcR86+lbrUBhGOg2ESRnNPxHs7PGDGEFqc4APFgGfHXmCDJ9+dI
         W1U04MMWXVcHUXzjghh2hoDpZWLjMc1JG4DMGJM3GfWGWCzBNst/73ed6A8E6gBvKl2h
         0ZfxMPrKTScZ2/SWEN+Alm9mgw4Dtu9cbPtnB2bc2y1hyUMvh1AMoNivQRaoeYHMy8lx
         Q2/unkbFy3m4aKz1bIJZKORvetjIWeSaho2GnDz+fwF7KfGJJy15pnxFCkzz/PAem3e8
         /rbyyIthTBqHu79vEitQLtqlgD1/Iia2NiWvdXjFXpimt6X4soyrDlSs2nNHtSIB8Oml
         zI1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=QCoo4xxPRwybL2sxSPQ1iW5RKTF4ovgXlfByMe2GkbI=;
        b=Immo2lr/tAYPfx4sWhwox3JLb5w0ZVYnZvRgMoKbMAPqxfSGR0avmi9ieppvjhYg1X
         odARnXoLgQmtIYb/MwzORLACHyNcZz8u7J6j+ehlpj1HjC+QeKAh26rfg0zfyP6urHHZ
         Y/+ByjOnvOgMkzBu/k2QvkGG+Fdnl8jbb6li1sC2xWsYykmKi5qOcj6MskukD+DzAVqk
         PH3Eba3LjOOqKPQk4mbOL1xkmJdoLpPBKk3wM3Gz6ORY0sgeOGeCRLjjm7wCJk8iXV32
         8fJvlm+JxwqdIQfWMjV/y8biVuc33eezL/muja1oSqi11qdyz2/kK0/XSFTA4nSqVgK4
         ZXlw==
X-Gm-Message-State: ACgBeo3y1aDz2iBfCw/jlgcBXifv1EPZYAgfIlXYY60273/HA3UzEcaH
        ksHGxYZb+GabD1VlRqSdlEKT1a55XkM=
X-Google-Smtp-Source: AA6agR4yTC76LP8n7ekTN0188JrN9YassrA3PajcVCSIk/YUvAQsSO+rt6w6LWNryozwIVVuU3i/FA==
X-Received: by 2002:a63:cd4b:0:b0:421:95f3:1431 with SMTP id a11-20020a63cd4b000000b0042195f31431mr5008338pgj.486.1660349385999;
        Fri, 12 Aug 2022 17:09:45 -0700 (PDT)
Received: from Leo-laptop-t470s.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v8-20020a170902b7c800b0016909be39e5sm2315052plz.177.2022.08.12.17.09.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Aug 2022 17:09:45 -0700 (PDT)
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
Subject: [PATCHv2 bpf-next] libbpf: making bpf_prog_load() ignore name if kernel doesn't support
Date:   Sat, 13 Aug 2022 08:09:36 +0800
Message-Id: <20220813000936.6464-1-liuhangbin@gmail.com>
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
also need to be exported in the libbpf_internal.h file.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
v2: move sys_bpf_prog_load definition to libbpf_internal.h. memset attr
    to 0 specifically to aviod padding.
---
 tools/lib/bpf/bpf.c             |  6 ++----
 tools/lib/bpf/libbpf.c          | 12 ++++++++++--
 tools/lib/bpf/libbpf_internal.h |  3 +++
 3 files changed, 15 insertions(+), 6 deletions(-)

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
 
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 3f01f5cd8a4c..4a351897bdcc 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4419,10 +4419,18 @@ static int probe_kern_prog_name(void)
 		BPF_MOV64_IMM(BPF_REG_0, 0),
 		BPF_EXIT_INSN(),
 	};
-	int ret, insn_cnt = ARRAY_SIZE(insns);
+	union bpf_attr attr;
+	int ret;
+
+	memset(&attr, 0, sizeof(attr));
+	attr.prog_type = BPF_PROG_TYPE_SOCKET_FILTER;
+	attr.license = ptr_to_u64("GPL");
+	attr.insns = ptr_to_u64(insns);
+	attr.insn_cnt = (__u32)ARRAY_SIZE(insns);
+	libbpf_strlcpy(attr.prog_name, "test", sizeof(attr.prog_name));
 
 	/* make sure loading with name works */
-	ret = bpf_prog_load(BPF_PROG_TYPE_SOCKET_FILTER, "test", "GPL", insns, insn_cnt, NULL);
+	ret = sys_bpf_prog_load(&attr, sizeof(attr), PROG_LOAD_ATTEMPTS);
 	return probe_fd(ret);
 }
 
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
index 4135ae0a2bc3..377642ff51fc 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -573,4 +573,7 @@ static inline bool is_pow_of_2(size_t x)
 	return x && (x & (x - 1)) == 0;
 }
 
+#define PROG_LOAD_ATTEMPTS 5
+int sys_bpf_prog_load(union bpf_attr *attr, unsigned int size, int attempts);
+
 #endif /* __LIBBPF_LIBBPF_INTERNAL_H */
-- 
2.31.1

