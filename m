Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6B336558DA
	for <lists+netdev@lfdr.de>; Sat, 24 Dec 2022 08:16:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbiLXHQI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Dec 2022 02:16:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbiLXHPz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Dec 2022 02:15:55 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 339FB101F1;
        Fri, 23 Dec 2022 23:15:51 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id v23so6726357pju.3;
        Fri, 23 Dec 2022 23:15:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YZV/Ygg5ZLK/icKlwhdiYUcrDkEBcDRF0QNzCkC6zPE=;
        b=acQhmTiKluTSuwLe020qKjGdnPpLInEv+Y+NnwUtPy7ahfRmb34z9Q33OR4nE1EDwz
         qvu4f45Tts3lgY/UrnxZr8iloVpODzv/f0DSe5hIWkuo/XFHMpzhLGkPRkYPoCCPP0bI
         2aUhyiUicc95vF7ZQ2s/ZTFCn9anOXkyoPQeTdfhPj3O+5JvPxM2UO45XIGWnqhpN02y
         p6tm/gqI9dziJWERA3YJLXChMctAS0c1srum6G2vygw+VZQzbxcWw6ADNIUDTp9qjJeb
         cMBv9fJjDAuHJnxclmnZZ72C9yryrrQwPKMnvkiAJL8TgNxtFRG1ZukcM8ECW/5Vcxdh
         bwow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YZV/Ygg5ZLK/icKlwhdiYUcrDkEBcDRF0QNzCkC6zPE=;
        b=WB/ob3g6C/VCxGzhPFHvMh3T8AyRtQXWBjVd6t6QTXF2/w7KOOEeWKGw8ofJfesbct
         MSjJC8VZxW8gXp8l6WgjGbasPV2n7AAOTUN5/V0lQl0MtVgKsRbFtOqyKkmsNzLAB3Wd
         MYvQ+ueLnl0KM7BmhdHoz5Ywq1z9Npt5JZNRz08BcJBJ68O/stjRzvgZ9iTKRNlrW5ye
         z9iQR9ecAP3VujXPx6nrjHTJKCXtYje5CzzYzDLRHI5gqZs2Td1M15vKXq/WbUvG1eYG
         RNjAPuYJwatSBHxMKnP6160LnAXgg5GYysqbxkQmt5ioVFmL1KQpHeUzGnQ44DqXXhU3
         DF3Q==
X-Gm-Message-State: AFqh2krHfsRC6dCKHBfrja+v9vfxSzdnpKyWS4UkSnuoLMsFZLps8VXh
        QpKAK3wtRhc9TgYyQr4KQw==
X-Google-Smtp-Source: AMrXdXtiJeGUuWOg1ZKA6oWVklXZECdTzdwD4CAIfymlccyTGQEQmvZcq4dgdzIm8aI1iGJFz1+22Q==
X-Received: by 2002:a17:902:a584:b0:18f:ac9f:29f6 with SMTP id az4-20020a170902a58400b0018fac9f29f6mr12393916plb.50.1671866150549;
        Fri, 23 Dec 2022 23:15:50 -0800 (PST)
Received: from WDIR.. ([182.209.58.25])
        by smtp.gmail.com with ESMTPSA id bf4-20020a170902b90400b00186b7443082sm3433222plb.195.2022.12.23.23.15.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Dec 2022 23:15:50 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [bpf-next v3 5/6] samples/bpf: use BPF_KSYSCALL macro in syscall tracing programs
Date:   Sat, 24 Dec 2022 16:15:26 +0900
Message-Id: <20221224071527.2292-6-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221224071527.2292-1-danieltimlee@gmail.com>
References: <20221224071527.2292-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit enhances the syscall tracing programs by using the
BPF_SYSCALL macro to reduce the inconvenience of parsing arguments from
pt_regs. By simplifying argument extraction, bpf program will become
clear to understand.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 samples/bpf/map_perf_test.bpf.c               | 26 ++++++++-----------
 .../bpf/test_current_task_under_cgroup.bpf.c  |  4 ++-
 samples/bpf/test_probe_write_user.bpf.c       | 12 ++++-----
 3 files changed, 19 insertions(+), 23 deletions(-)

diff --git a/samples/bpf/map_perf_test.bpf.c b/samples/bpf/map_perf_test.bpf.c
index 0c7885057ffe..3cdeba2afe12 100644
--- a/samples/bpf/map_perf_test.bpf.c
+++ b/samples/bpf/map_perf_test.bpf.c
@@ -101,7 +101,7 @@ struct {
 } lru_hash_lookup_map SEC(".maps");
 
 SEC("ksyscall/getuid")
-int stress_hmap(struct pt_regs *ctx)
+int BPF_KSYSCALL(stress_hmap)
 {
 	u32 key = bpf_get_current_pid_tgid();
 	long init_val = 1;
@@ -119,7 +119,7 @@ int stress_hmap(struct pt_regs *ctx)
 }
 
 SEC("ksyscall/geteuid")
-int stress_percpu_hmap(struct pt_regs *ctx)
+int BPF_KSYSCALL(stress_percpu_hmap)
 {
 	u32 key = bpf_get_current_pid_tgid();
 	long init_val = 1;
@@ -136,7 +136,7 @@ int stress_percpu_hmap(struct pt_regs *ctx)
 }
 
 SEC("ksyscall/getgid")
-int stress_hmap_alloc(struct pt_regs *ctx)
+int BPF_KSYSCALL(stress_hmap_alloc)
 {
 	u32 key = bpf_get_current_pid_tgid();
 	long init_val = 1;
@@ -153,7 +153,7 @@ int stress_hmap_alloc(struct pt_regs *ctx)
 }
 
 SEC("ksyscall/getegid")
-int stress_percpu_hmap_alloc(struct pt_regs *ctx)
+int BPF_KSYSCALL(stress_percpu_hmap_alloc)
 {
 	u32 key = bpf_get_current_pid_tgid();
 	long init_val = 1;
@@ -168,11 +168,10 @@ int stress_percpu_hmap_alloc(struct pt_regs *ctx)
 	}
 	return 0;
 }
-
 SEC("ksyscall/connect")
-int stress_lru_hmap_alloc(struct pt_regs *ctx)
+int BPF_KSYSCALL(stress_lru_hmap_alloc, int fd, struct sockaddr_in *uservaddr,
+		 int addrlen)
 {
-	struct pt_regs *real_regs = (struct pt_regs *)PT_REGS_PARM1_CORE(ctx);
 	char fmt[] = "Failed at stress_lru_hmap_alloc. ret:%dn";
 	union {
 		u16 dst6[8];
@@ -185,14 +184,11 @@ int stress_lru_hmap_alloc(struct pt_regs *ctx)
 			u32 key;
 		};
 	} test_params;
-	struct sockaddr_in6 *in6;
+	struct sockaddr_in6 *in6 = (struct sockaddr_in6 *)uservaddr;
 	u16 test_case;
-	int addrlen, ret;
 	long val = 1;
 	u32 key = 0;
-
-	in6 = (struct sockaddr_in6 *)PT_REGS_PARM2_CORE(real_regs);
-	addrlen = (int)PT_REGS_PARM3_CORE(real_regs);
+	int ret;
 
 	if (addrlen != sizeof(*in6))
 		return 0;
@@ -250,7 +246,7 @@ int stress_lru_hmap_alloc(struct pt_regs *ctx)
 }
 
 SEC("ksyscall/gettid")
-int stress_lpm_trie_map_alloc(struct pt_regs *ctx)
+int BPF_KSYSCALL(stress_lpm_trie_map_alloc)
 {
 	union {
 		u32 b32[2];
@@ -272,7 +268,7 @@ int stress_lpm_trie_map_alloc(struct pt_regs *ctx)
 }
 
 SEC("ksyscall/getpgid")
-int stress_hash_map_lookup(struct pt_regs *ctx)
+int BPF_KSYSCALL(stress_hash_map_lookup)
 {
 	u32 key = 1, i;
 	long *value;
@@ -285,7 +281,7 @@ int stress_hash_map_lookup(struct pt_regs *ctx)
 }
 
 SEC("ksyscall/getppid")
-int stress_array_map_lookup(struct pt_regs *ctx)
+int BPF_KSYSCALL(stress_array_map_lookup)
 {
 	u32 key = 1, i;
 	long *value;
diff --git a/samples/bpf/test_current_task_under_cgroup.bpf.c b/samples/bpf/test_current_task_under_cgroup.bpf.c
index 0b059cee3cba..58b9cf7ed659 100644
--- a/samples/bpf/test_current_task_under_cgroup.bpf.c
+++ b/samples/bpf/test_current_task_under_cgroup.bpf.c
@@ -8,6 +8,8 @@
 #include "vmlinux.h"
 #include <linux/version.h>
 #include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+#include <bpf/bpf_core_read.h>
 
 struct {
 	__uint(type, BPF_MAP_TYPE_CGROUP_ARRAY);
@@ -25,7 +27,7 @@ struct {
 
 /* Writes the last PID that called sync to a map at index 0 */
 SEC("ksyscall/sync")
-int bpf_prog1(struct pt_regs *ctx)
+int BPF_KSYSCALL(bpf_prog1)
 {
 	u64 pid = bpf_get_current_pid_tgid();
 	int idx = 0;
diff --git a/samples/bpf/test_probe_write_user.bpf.c b/samples/bpf/test_probe_write_user.bpf.c
index a0f10c5ca273..a4f3798b7fb0 100644
--- a/samples/bpf/test_probe_write_user.bpf.c
+++ b/samples/bpf/test_probe_write_user.bpf.c
@@ -27,24 +27,22 @@ struct {
  * of course, across platforms, and over time, the ABI may change.
  */
 SEC("ksyscall/connect")
-int bpf_prog1(struct pt_regs *ctx)
+int BPF_KSYSCALL(bpf_prog1, int fd, struct sockaddr_in *uservaddr,
+		 int addrlen)
 {
-	struct pt_regs *real_regs = (struct pt_regs *)PT_REGS_PARM1_CORE(ctx);
-	void *sockaddr_arg = (void *)PT_REGS_PARM2_CORE(real_regs);
-	int sockaddr_len = (int)PT_REGS_PARM3_CORE(real_regs);
 	struct sockaddr_in new_addr, orig_addr = {};
 	struct sockaddr_in *mapped_addr;
 
-	if (sockaddr_len > sizeof(orig_addr))
+	if (addrlen > sizeof(orig_addr))
 		return 0;
 
-	if (bpf_probe_read_user(&orig_addr, sizeof(orig_addr), sockaddr_arg) != 0)
+	if (bpf_probe_read_user(&orig_addr, sizeof(orig_addr), uservaddr) != 0)
 		return 0;
 
 	mapped_addr = bpf_map_lookup_elem(&dnat_map, &orig_addr);
 	if (mapped_addr != NULL) {
 		memcpy(&new_addr, mapped_addr, sizeof(new_addr));
-		bpf_probe_write_user(sockaddr_arg, &new_addr,
+		bpf_probe_write_user(uservaddr, &new_addr,
 				     sizeof(new_addr));
 	}
 	return 0;
-- 
2.34.1

