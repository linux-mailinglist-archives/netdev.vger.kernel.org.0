Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E446866AFA9
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 08:18:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230478AbjAOHSA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 02:18:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbjAOHQy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 02:16:54 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 952D3B472;
        Sat, 14 Jan 2023 23:16:38 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id s67so17625361pgs.3;
        Sat, 14 Jan 2023 23:16:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ocnqdzwpiFm+OPG+OonsFNnUBEnRsSpKIXYgKGCflvM=;
        b=avku4lgBI86PlqIWq2y/K7eXXy2PIl42YwD3nvVmwTYZZNs9TiqB7Rh4kzSq/j62yh
         r0XWG0Fb22GzgGE1Ng1s/dRlSHD7eKbsMJ8+B3pbZ9QEIPXyHaaJd25j79MsinPTQ2Tu
         L2p4ww7RByq34+eyFC4dXZsbfRLuduXRXh5pyn1LG/uWpqjK8Se/404erVYTKyqBWmqL
         xuXRX0+msqVkupYpLBrED8LFsFWNIeJvnVbZhjrkVZZHaEuYKBSZqIODdg1bfGwDZMaW
         ByIxI5wjJiBUJUP3b0EiQptnqw98r0twcXGYR5kZbvGNlXUcynCuNE6iI6faHWDc+dBk
         pHJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ocnqdzwpiFm+OPG+OonsFNnUBEnRsSpKIXYgKGCflvM=;
        b=SJwD445wwcmnKT/ShlaDKstA58wQiwFd7sBwnMD2CAcTCt2hyoyk1xyVujhfXu2fHf
         sS2su2RCNay84gjaZec3EVr3MErURto14//uZ3tA4l/7jdJmpHzhPbGcneTLY7iWeYL5
         Ma/P/h/NsvIVU47MxkjQ8GoH4NzERZGaRqcpRYz0vK0ad5a702uyhjdyW3YT5gb7W1Z0
         uAvcTq+01uch/dhvw/OvGaovyjqZNAbG8rwB/UmvUMTjTOaBBgr8l2LficcqLxUbWqop
         axb4BuDKTqGXz3J3jJ1z+JywmrezBOauj8Mi+BMiuaUa/18Ib6JnIBphlLckr898VWBC
         Q6JQ==
X-Gm-Message-State: AFqh2kp2luwEcNlajEUcWlrVWMTotVNpAFawf33toZ+8SF1eWs4e0AoV
        YQE3FJNEtgbglJDBKHy0jw==
X-Google-Smtp-Source: AMrXdXvSYx/gnUhUc4jw5gULtOEwObzv6H6eMPXMjrqBkpO9MyisCKJH5Y43vpwhKmyGt632tW0ryw==
X-Received: by 2002:a62:58c1:0:b0:573:f869:2115 with SMTP id m184-20020a6258c1000000b00573f8692115mr82117503pfb.9.1673766998054;
        Sat, 14 Jan 2023 23:16:38 -0800 (PST)
Received: from WDIR.. ([182.209.58.25])
        by smtp.gmail.com with ESMTPSA id z13-20020aa7990d000000b0058a313f4e4esm10272796pff.149.2023.01.14.23.16.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Jan 2023 23:16:37 -0800 (PST)
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
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [bpf-next 05/10] samples/bpf: replace broken overhead microbenchmark with fib_table_lookup
Date:   Sun, 15 Jan 2023 16:16:08 +0900
Message-Id: <20230115071613.125791-6-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230115071613.125791-1-danieltimlee@gmail.com>
References: <20230115071613.125791-1-danieltimlee@gmail.com>
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

The test_overhead bpf program is designed to compare performance
between tracepoint and kprobe. Initially it used task_rename and
urandom_read tracepoint.

However, commit 14c174633f34 ("random: remove unused tracepoints")
removed urandom_read tracepoint, and for this reason the test_overhead
got broken.

This commit introduces new microbenchmark using fib_table_lookup.
This microbenchmark sends UDP packets to localhost in order to invoke
fib_table_lookup.

In a nutshell:
fd = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
addr.sin_addr.s_addr = inet_addr(DUMMY_IP);
addr.sin_port = htons(DUMMY_PORT);
for() {
    sendto(fd, buf, strlen(buf), 0,
            (struct sockaddr *)&addr, sizeof(addr));
}

on 4 cpus in parallel:
                                            lookup per sec
base (no tracepoints, no kprobes)               381k
with kprobe at fib_table_lookup()               325k
with tracepoint at fib:fib_table_lookup         330k
with raw_tracepoint at fib:fib_table_lookup     365k

Fixes: 14c174633f34 ("random: remove unused tracepoints")

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 samples/bpf/test_overhead_kprobe_kern.c |  2 +-
 samples/bpf/test_overhead_raw_tp_kern.c |  2 +-
 samples/bpf/test_overhead_tp_kern.c     | 26 ++++++++++++++++-------
 samples/bpf/test_overhead_user.c        | 28 +++++++++++++++++--------
 4 files changed, 40 insertions(+), 18 deletions(-)

diff --git a/samples/bpf/test_overhead_kprobe_kern.c b/samples/bpf/test_overhead_kprobe_kern.c
index 8fdd2c9c56b2..ba82949338c2 100644
--- a/samples/bpf/test_overhead_kprobe_kern.c
+++ b/samples/bpf/test_overhead_kprobe_kern.c
@@ -39,7 +39,7 @@ int prog(struct pt_regs *ctx)
 	return 0;
 }
 
-SEC("kprobe/urandom_read")
+SEC("kprobe/fib_table_lookup")
 int prog2(struct pt_regs *ctx)
 {
 	return 0;
diff --git a/samples/bpf/test_overhead_raw_tp_kern.c b/samples/bpf/test_overhead_raw_tp_kern.c
index 8763181a32f3..3e29de0eca98 100644
--- a/samples/bpf/test_overhead_raw_tp_kern.c
+++ b/samples/bpf/test_overhead_raw_tp_kern.c
@@ -9,7 +9,7 @@ int prog(struct bpf_raw_tracepoint_args *ctx)
 	return 0;
 }
 
-SEC("raw_tracepoint/urandom_read")
+SEC("raw_tracepoint/fib_table_lookup")
 int prog2(struct bpf_raw_tracepoint_args *ctx)
 {
 	return 0;
diff --git a/samples/bpf/test_overhead_tp_kern.c b/samples/bpf/test_overhead_tp_kern.c
index 80edadacb692..f170e9b1ea21 100644
--- a/samples/bpf/test_overhead_tp_kern.c
+++ b/samples/bpf/test_overhead_tp_kern.c
@@ -22,15 +22,27 @@ int prog(struct task_rename *ctx)
 	return 0;
 }
 
-/* from /sys/kernel/debug/tracing/events/random/urandom_read/format */
-struct urandom_read {
+/* from /sys/kernel/debug/tracing/events/fib/fib_table_lookup/format */
+struct fib_table_lookup {
 	__u64 pad;
-	int got_bits;
-	int pool_left;
-	int input_left;
+	__u32 tb_id;
+	int err;
+	int oif;
+	int iif;
+	__u8 proto;
+	__u8 tos;
+	__u8 scope;
+	__u8 flags;
+	__u8 src[4];
+	__u8 dst[4];
+	__u8 gw4[4];
+	__u8 gw6[16];
+	__u16 sport;
+	__u16 dport;
+	char name[16];
 };
-SEC("tracepoint/random/urandom_read")
-int prog2(struct urandom_read *ctx)
+SEC("tracepoint/fib/fib_table_lookup")
+int prog2(struct fib_table_lookup *ctx)
 {
 	return 0;
 }
diff --git a/samples/bpf/test_overhead_user.c b/samples/bpf/test_overhead_user.c
index 88717f8ec6ac..ce28d30f852e 100644
--- a/samples/bpf/test_overhead_user.c
+++ b/samples/bpf/test_overhead_user.c
@@ -11,6 +11,8 @@
 #include <unistd.h>
 #include <assert.h>
 #include <sys/wait.h>
+#include <sys/socket.h>
+#include <arpa/inet.h>
 #include <stdlib.h>
 #include <signal.h>
 #include <linux/bpf.h>
@@ -20,6 +22,8 @@
 #include <bpf/libbpf.h>
 
 #define MAX_CNT 1000000
+#define DUMMY_IP "127.0.0.1"
+#define DUMMY_PORT 80
 
 static struct bpf_link *links[2];
 static struct bpf_object *obj;
@@ -35,8 +39,8 @@ static __u64 time_get_ns(void)
 
 static void test_task_rename(int cpu)
 {
-	__u64 start_time;
 	char buf[] = "test\n";
+	__u64 start_time;
 	int i, fd;
 
 	fd = open("/proc/self/comm", O_WRONLY|O_TRUNC);
@@ -57,26 +61,32 @@ static void test_task_rename(int cpu)
 	close(fd);
 }
 
-static void test_urandom_read(int cpu)
+static void test_fib_table_lookup(int cpu)
 {
+	struct sockaddr_in addr;
+	char buf[] = "test\n";
 	__u64 start_time;
-	char buf[4];
 	int i, fd;
 
-	fd = open("/dev/urandom", O_RDONLY);
+	fd = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
 	if (fd < 0) {
-		printf("couldn't open /dev/urandom\n");
+		printf("couldn't open socket\n");
 		exit(1);
 	}
+	memset((char *)&addr, 0, sizeof(addr));
+	addr.sin_addr.s_addr = inet_addr(DUMMY_IP);
+	addr.sin_port = htons(DUMMY_PORT);
+	addr.sin_family = AF_INET;
 	start_time = time_get_ns();
 	for (i = 0; i < MAX_CNT; i++) {
-		if (read(fd, buf, sizeof(buf)) < 0) {
-			printf("failed to read from /dev/urandom: %s\n", strerror(errno));
+		if (sendto(fd, buf, strlen(buf), 0,
+			   (struct sockaddr *)&addr, sizeof(addr)) < 0) {
+			printf("failed to start ping: %s\n", strerror(errno));
 			close(fd);
 			return;
 		}
 	}
-	printf("urandom_read:%d: %lld events per sec\n",
+	printf("fib_table_lookup:%d: %lld events per sec\n",
 	       cpu, MAX_CNT * 1000000000ll / (time_get_ns() - start_time));
 	close(fd);
 }
@@ -92,7 +102,7 @@ static void loop(int cpu, int flags)
 	if (flags & 1)
 		test_task_rename(cpu);
 	if (flags & 2)
-		test_urandom_read(cpu);
+		test_fib_table_lookup(cpu);
 }
 
 static void run_perf_test(int tasks, int flags)
-- 
2.34.1

