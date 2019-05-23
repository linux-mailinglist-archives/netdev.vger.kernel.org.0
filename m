Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B099927D54
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 14:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731032AbfEWMxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 08:53:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:39542 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730756AbfEWMxC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 08:53:02 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9C379AFA1;
        Thu, 23 May 2019 12:52:59 +0000 (UTC)
From:   Michal Rostecki <mrostecki@opensuse.org>
Cc:     Michal Rostecki <mrostecki@opensuse.org>,
        Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-kselftest@vger.kernel.org (open list:KERNEL SELFTEST FRAMEWORK),
        netdev@vger.kernel.org (open list:BPF (Safe dynamic programs and tools)),
        bpf@vger.kernel.org (open list:BPF (Safe dynamic programs and tools)),
        linux-kernel@vger.kernel.org (open list),
        xdp-newbies@vger.kernel.org (open list:XDP (eXpress Data Path))
Subject: [PATCH bpf-next v2 RESEND 2/2] samples: bpf: Do not define bpf_printk macro
Date:   Thu, 23 May 2019 14:53:55 +0200
Message-Id: <20190523125355.18437-3-mrostecki@opensuse.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523125355.18437-1-mrostecki@opensuse.org>
References: <20190523125355.18437-1-mrostecki@opensuse.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bpf_printk macro was moved to bpf_helpers.h which is included in all
example programs.

Signed-off-by: Michal Rostecki <mrostecki@opensuse.org>
---
 samples/bpf/hbm_kern.h             | 11 ++---------
 samples/bpf/tcp_basertt_kern.c     |  7 -------
 samples/bpf/tcp_bufs_kern.c        |  7 -------
 samples/bpf/tcp_clamp_kern.c       |  7 -------
 samples/bpf/tcp_cong_kern.c        |  7 -------
 samples/bpf/tcp_iw_kern.c          |  7 -------
 samples/bpf/tcp_rwnd_kern.c        |  7 -------
 samples/bpf/tcp_synrto_kern.c      |  7 -------
 samples/bpf/tcp_tos_reflect_kern.c |  7 -------
 samples/bpf/xdp_sample_pkts_kern.c |  7 -------
 10 files changed, 2 insertions(+), 72 deletions(-)

diff --git a/samples/bpf/hbm_kern.h b/samples/bpf/hbm_kern.h
index c5635d924193..41384be233b9 100644
--- a/samples/bpf/hbm_kern.h
+++ b/samples/bpf/hbm_kern.h
@@ -30,15 +30,8 @@
 #define ALLOW_PKT	1
 #define TCP_ECN_OK	1
 
-#define HBM_DEBUG 0  // Set to 1 to enable debugging
-#if HBM_DEBUG
-#define bpf_printk(fmt, ...)					\
-({								\
-	char ____fmt[] = fmt;					\
-	bpf_trace_printk(____fmt, sizeof(____fmt),		\
-			 ##__VA_ARGS__);			\
-})
-#else
+#ifndef HBM_DEBUG  // Define HBM_DEBUG to enable debugging
+#undef bpf_printk
 #define bpf_printk(fmt, ...)
 #endif
 
diff --git a/samples/bpf/tcp_basertt_kern.c b/samples/bpf/tcp_basertt_kern.c
index 6ef1625e8b2c..9dba48c2b920 100644
--- a/samples/bpf/tcp_basertt_kern.c
+++ b/samples/bpf/tcp_basertt_kern.c
@@ -21,13 +21,6 @@
 
 #define DEBUG 1
 
-#define bpf_printk(fmt, ...)					\
-({								\
-	       char ____fmt[] = fmt;				\
-	       bpf_trace_printk(____fmt, sizeof(____fmt),	\
-				##__VA_ARGS__);			\
-})
-
 SEC("sockops")
 int bpf_basertt(struct bpf_sock_ops *skops)
 {
diff --git a/samples/bpf/tcp_bufs_kern.c b/samples/bpf/tcp_bufs_kern.c
index e03e204739fa..af8486f33771 100644
--- a/samples/bpf/tcp_bufs_kern.c
+++ b/samples/bpf/tcp_bufs_kern.c
@@ -22,13 +22,6 @@
 
 #define DEBUG 1
 
-#define bpf_printk(fmt, ...)					\
-({								\
-	       char ____fmt[] = fmt;				\
-	       bpf_trace_printk(____fmt, sizeof(____fmt),	\
-				##__VA_ARGS__);			\
-})
-
 SEC("sockops")
 int bpf_bufs(struct bpf_sock_ops *skops)
 {
diff --git a/samples/bpf/tcp_clamp_kern.c b/samples/bpf/tcp_clamp_kern.c
index a0dc2d254aca..26c0fd091f3c 100644
--- a/samples/bpf/tcp_clamp_kern.c
+++ b/samples/bpf/tcp_clamp_kern.c
@@ -22,13 +22,6 @@
 
 #define DEBUG 1
 
-#define bpf_printk(fmt, ...)					\
-({								\
-	       char ____fmt[] = fmt;				\
-	       bpf_trace_printk(____fmt, sizeof(____fmt),	\
-				##__VA_ARGS__);			\
-})
-
 SEC("sockops")
 int bpf_clamp(struct bpf_sock_ops *skops)
 {
diff --git a/samples/bpf/tcp_cong_kern.c b/samples/bpf/tcp_cong_kern.c
index 4fd3ca979a06..6d4dc4c7dd1e 100644
--- a/samples/bpf/tcp_cong_kern.c
+++ b/samples/bpf/tcp_cong_kern.c
@@ -21,13 +21,6 @@
 
 #define DEBUG 1
 
-#define bpf_printk(fmt, ...)					\
-({								\
-	       char ____fmt[] = fmt;				\
-	       bpf_trace_printk(____fmt, sizeof(____fmt),	\
-				##__VA_ARGS__);			\
-})
-
 SEC("sockops")
 int bpf_cong(struct bpf_sock_ops *skops)
 {
diff --git a/samples/bpf/tcp_iw_kern.c b/samples/bpf/tcp_iw_kern.c
index 9b139ec69560..da61d53378b3 100644
--- a/samples/bpf/tcp_iw_kern.c
+++ b/samples/bpf/tcp_iw_kern.c
@@ -22,13 +22,6 @@
 
 #define DEBUG 1
 
-#define bpf_printk(fmt, ...)					\
-({								\
-	       char ____fmt[] = fmt;				\
-	       bpf_trace_printk(____fmt, sizeof(____fmt),	\
-				##__VA_ARGS__);			\
-})
-
 SEC("sockops")
 int bpf_iw(struct bpf_sock_ops *skops)
 {
diff --git a/samples/bpf/tcp_rwnd_kern.c b/samples/bpf/tcp_rwnd_kern.c
index cc71ee96e044..d011e38b80d2 100644
--- a/samples/bpf/tcp_rwnd_kern.c
+++ b/samples/bpf/tcp_rwnd_kern.c
@@ -21,13 +21,6 @@
 
 #define DEBUG 1
 
-#define bpf_printk(fmt, ...)					\
-({								\
-	       char ____fmt[] = fmt;				\
-	       bpf_trace_printk(____fmt, sizeof(____fmt),	\
-				##__VA_ARGS__);			\
-})
-
 SEC("sockops")
 int bpf_rwnd(struct bpf_sock_ops *skops)
 {
diff --git a/samples/bpf/tcp_synrto_kern.c b/samples/bpf/tcp_synrto_kern.c
index ca87ed34f896..720d1950322d 100644
--- a/samples/bpf/tcp_synrto_kern.c
+++ b/samples/bpf/tcp_synrto_kern.c
@@ -21,13 +21,6 @@
 
 #define DEBUG 1
 
-#define bpf_printk(fmt, ...)					\
-({								\
-	       char ____fmt[] = fmt;				\
-	       bpf_trace_printk(____fmt, sizeof(____fmt),	\
-				##__VA_ARGS__);			\
-})
-
 SEC("sockops")
 int bpf_synrto(struct bpf_sock_ops *skops)
 {
diff --git a/samples/bpf/tcp_tos_reflect_kern.c b/samples/bpf/tcp_tos_reflect_kern.c
index de788be6f862..369faca70a15 100644
--- a/samples/bpf/tcp_tos_reflect_kern.c
+++ b/samples/bpf/tcp_tos_reflect_kern.c
@@ -20,13 +20,6 @@
 
 #define DEBUG 1
 
-#define bpf_printk(fmt, ...)					\
-({								\
-	       char ____fmt[] = fmt;				\
-	       bpf_trace_printk(____fmt, sizeof(____fmt),	\
-				##__VA_ARGS__);			\
-})
-
 SEC("sockops")
 int bpf_basertt(struct bpf_sock_ops *skops)
 {
diff --git a/samples/bpf/xdp_sample_pkts_kern.c b/samples/bpf/xdp_sample_pkts_kern.c
index f7ca8b850978..6c7c7e0aaeda 100644
--- a/samples/bpf/xdp_sample_pkts_kern.c
+++ b/samples/bpf/xdp_sample_pkts_kern.c
@@ -7,13 +7,6 @@
 #define SAMPLE_SIZE 64ul
 #define MAX_CPUS 128
 
-#define bpf_printk(fmt, ...)					\
-({								\
-	       char ____fmt[] = fmt;				\
-	       bpf_trace_printk(____fmt, sizeof(____fmt),	\
-				##__VA_ARGS__);			\
-})
-
 struct bpf_map_def SEC("maps") my_map = {
 	.type = BPF_MAP_TYPE_PERF_EVENT_ARRAY,
 	.key_size = sizeof(int),
-- 
2.21.0

