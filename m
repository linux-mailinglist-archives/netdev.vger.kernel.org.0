Return-Path: <netdev+bounces-11219-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B78D73203C
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 20:57:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 860BD28148F
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 18:57:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A34D32E0FE;
	Thu, 15 Jun 2023 18:57:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94682374
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 18:57:04 +0000 (UTC)
Received: from mail-oa1-x2c.google.com (mail-oa1-x2c.google.com [IPv6:2001:4860:4864:20::2c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 609101715
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 11:56:59 -0700 (PDT)
Received: by mail-oa1-x2c.google.com with SMTP id 586e51a60fabf-1a98cf01151so15865fac.2
        for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 11:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686855418; x=1689447418;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZSA/9dQ8GbeKS/icH6iBxTs7gqJHBqPLXaYJLRAF7ZA=;
        b=o/Dki13NUAs/e8CC37RBUd1Xly8eF5ZDmj/caw1pIZuiG4Sacv4l6YYX3+u+nKkAkZ
         s45zf5NLnTx2rwfVn782wIBiNncyV7SqHw3KXhUcMi6vhzxwz/Bmp+HEmMo+sadqCUGb
         YG2YgG4hM7s3SfFq8d+fyVtO8xRArShLcCARQ8uAEUponNWBUB3PFOilM1CfnGBdjaAH
         /H/m15KkM4ZHDqPyHkat5ZZde86XjOx5GKzBnBF5i2R/l8h0bdnHNp0hTiyyIWf3lvl5
         +PD3KJ1Ux+rY9nMgPOkMSFLfVlC2AIhaMhpt5Ra2OMZ7j3be63+cublYUhC2vUSps0nv
         cccQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686855418; x=1689447418;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZSA/9dQ8GbeKS/icH6iBxTs7gqJHBqPLXaYJLRAF7ZA=;
        b=Pv6B+Oj7DJI+CA00Wo4gvV1G/ohS+gG2WnY12ZpCUoaExw7e9G8hoEDOHFo9eIUryi
         XvMdNhlvTMYf7VvFCYnq/xqiIwOqATJlaW9wSUNFA5OcqRuzDEA6X2YjiNyndgp5XaLv
         /HttL7Z0LsTFNsOnSzBdhP94M553rkETg7drjxQzacPGVN9MNWDLn8a9AGW1q22a10ji
         HHWCczKmMCpgv7EajcQMZVMOpVsOtmDlci59ZqorTGjGScALsyjUBbPlpyv1Ca4OkEiV
         vuLlgU02G98KhQEAP1QT9LRfW1JmuoOELkPZqm+2D3wb9RMBmyF0AIdxAZfxx1/4AXvr
         3A6Q==
X-Gm-Message-State: AC+VfDyzI4FL162/lOoID1cJiMpMLBC61z/jGoib0G2vbyQYU12VNeuS
	j5PncuTkixGkq8va3LlwyKkuFWPyDVM=
X-Google-Smtp-Source: ACHHUZ59WJGbWGOxvBGzFnToPRQEDKJOLPEpHiH568bFwZBu6W9G3dn8za9oRJgqNMqSHAUY9e4JEQ==
X-Received: by 2002:a05:6870:4353:b0:196:4cb3:7b7 with SMTP id x19-20020a056870435300b001964cb307b7mr14802135oah.43.1686855418153;
        Thu, 15 Jun 2023 11:56:58 -0700 (PDT)
Received: from phantasmagoria.svl.corp.google.com ([2620:15c:2c4:200:d18e:fd0e:7d89:7ec9])
        by smtp.gmail.com with ESMTPSA id e5-20020aa78c45000000b0063d2989d5b4sm4934657pfd.45.2023.06.15.11.56.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jun 2023 11:56:57 -0700 (PDT)
From: Arjun Roy <arjunroy.kdev@gmail.com>
To: netdev@vger.kernel.org
Cc: arjunroy@google.com,
	edumazet@google.com,
	soheil@google.com
Subject: [net-next] tcp: Use per-vma locking for receive zerocopy
Date: Thu, 15 Jun 2023 11:55:17 -0700
Message-ID: <20230615185516.3738855-2-arjunroy.kdev@gmail.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Arjun Roy <arjunroy@google.com>

Per-VMA locking allows us to lock a struct vm_area_struct without
taking the process-wide mmap lock in read mode.

Consider a process workload where the mmap lock is taken constantly in
write mode. In this scenario, all zerocopy receives are periodically
blocked during that period of time - though in principle, the memory
ranges being used by TCP are not touched by the operations that need
the mmap write lock. This results in performance degradation.

Now consider another workload where the mmap lock is never taken in
write mode, but there are many TCP connections using receive zerocopy
that are concurrently receiving. These connections all take the mmap
lock in read mode, but this does induce a lot of contention and atomic
ops for this process-wide lock. This results in additional CPU
overhead caused by contending on the cache line for this lock.

However, with per-vma locking, both of these problems can be avoided.

As a test, I ran an RPC-style request/response workload with 4KB
payloads and receive zerocopy enabled, with 100 simultaneous TCP
connections. I measured perf cycles within the
find_tcp_vma/mmap_read_lock/mmap_read_unlock codepath, with and
without per-vma locking enabled.

When using process-wide mmap semaphore read locking, about 1% of
measured perf cycles were within this path. With per-VMA locking, this
value dropped to about 0.45%.

Signed-off-by: Arjun Roy <arjunroy@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
---
 MAINTAINERS            |  1 +
 include/linux/net_mm.h |  8 ++++++++
 include/net/tcp.h      |  1 +
 mm/memory.c            |  7 ++++---
 net/ipv4/tcp.c         | 45 ++++++++++++++++++++++++++++++++++--------
 5 files changed, 51 insertions(+), 11 deletions(-)
 create mode 100644 include/linux/net_mm.h

diff --git a/MAINTAINERS b/MAINTAINERS
index c6fa6ed454f4..a7c495e3323b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14727,6 +14727,7 @@ NETWORKING [TCP]
 M:	Eric Dumazet <edumazet@google.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	include/linux/net_mm.h
 F:	include/linux/tcp.h
 F:	include/net/tcp.h
 F:	include/trace/events/tcp.h
diff --git a/include/linux/net_mm.h b/include/linux/net_mm.h
new file mode 100644
index 000000000000..a4a3301e05be
--- /dev/null
+++ b/include/linux/net_mm.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifdef CONFIG_MMU
+extern const struct vm_operations_struct tcp_vm_ops;
+static inline bool vma_is_tcp(const struct vm_area_struct *vma)
+{
+	return vma->vm_ops == &tcp_vm_ops;
+}
+#endif
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 5066e4586cf0..bfa5e27205ba 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -45,6 +45,7 @@
 #include <linux/memcontrol.h>
 #include <linux/bpf-cgroup.h>
 #include <linux/siphash.h>
+#include <linux/net_mm.h>
 
 extern struct inet_hashinfo tcp_hashinfo;
 
diff --git a/mm/memory.c b/mm/memory.c
index f69fbc251198..3e46b4d881dc 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -77,6 +77,7 @@
 #include <linux/ptrace.h>
 #include <linux/vmalloc.h>
 #include <linux/sched/sysctl.h>
+#include <linux/net_mm.h>
 
 #include <trace/events/kmem.h>
 
@@ -5280,12 +5281,12 @@ struct vm_area_struct *lock_vma_under_rcu(struct mm_struct *mm,
 	if (!vma)
 		goto inval;
 
-	/* Only anonymous vmas are supported for now */
-	if (!vma_is_anonymous(vma))
+	/* Only anonymous and tcp vmas are supported for now */
+	if (!vma_is_anonymous(vma) && !vma_is_tcp(vma))
 		goto inval;
 
 	/* find_mergeable_anon_vma uses adjacent vmas which are not locked */
-	if (!vma->anon_vma)
+	if (!vma->anon_vma && !vma_is_tcp(vma))
 		goto inval;
 
 	if (!vma_start_read(vma))
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 8d20d9221238..6240d81476b8 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1877,7 +1877,7 @@ void tcp_update_recv_tstamps(struct sk_buff *skb,
 }
 
 #ifdef CONFIG_MMU
-static const struct vm_operations_struct tcp_vm_ops = {
+const struct vm_operations_struct tcp_vm_ops = {
 };
 
 int tcp_mmap(struct file *file, struct socket *sock,
@@ -2176,6 +2176,34 @@ static void tcp_zc_finalize_rx_tstamp(struct sock *sk,
 	}
 }
 
+static struct vm_area_struct *find_tcp_vma(struct mm_struct *mm,
+					   unsigned long address,
+					   bool *mmap_locked)
+{
+	struct vm_area_struct *vma = NULL;
+
+#ifdef CONFIG_PER_VMA_LOCK
+	vma = lock_vma_under_rcu(mm, address);
+#endif
+	if (vma) {
+		if (!vma_is_tcp(vma)) {
+			vma_end_read(vma);
+			return NULL;
+		}
+		*mmap_locked = false;
+		return vma;
+	}
+
+	mmap_read_lock(mm);
+	vma = vma_lookup(mm, address);
+	if (!vma || !vma_is_tcp(vma)) {
+		mmap_read_unlock(mm);
+		return NULL;
+	}
+	*mmap_locked = true;
+	return vma;
+}
+
 #define TCP_ZEROCOPY_PAGE_BATCH_SIZE 32
 static int tcp_zerocopy_receive(struct sock *sk,
 				struct tcp_zerocopy_receive *zc,
@@ -2193,6 +2221,7 @@ static int tcp_zerocopy_receive(struct sock *sk,
 	u32 seq = tp->copied_seq;
 	u32 total_bytes_to_map;
 	int inq = tcp_inq(sk);
+	bool mmap_locked;
 	int ret;
 
 	zc->copybuf_len = 0;
@@ -2217,13 +2246,10 @@ static int tcp_zerocopy_receive(struct sock *sk,
 		return 0;
 	}
 
-	mmap_read_lock(current->mm);
-
-	vma = vma_lookup(current->mm, address);
-	if (!vma || vma->vm_ops != &tcp_vm_ops) {
-		mmap_read_unlock(current->mm);
+	vma = find_tcp_vma(current->mm, address, &mmap_locked);
+	if (!vma)
 		return -EINVAL;
-	}
+
 	vma_len = min_t(unsigned long, zc->length, vma->vm_end - address);
 	avail_len = min_t(u32, vma_len, inq);
 	total_bytes_to_map = avail_len & ~(PAGE_SIZE - 1);
@@ -2297,7 +2323,10 @@ static int tcp_zerocopy_receive(struct sock *sk,
 						   zc, total_bytes_to_map);
 	}
 out:
-	mmap_read_unlock(current->mm);
+	if (mmap_locked)
+		mmap_read_unlock(current->mm);
+	else
+		vma_end_read(vma);
 	/* Try to copy straggler data. */
 	if (!ret)
 		copylen = tcp_zc_handle_leftover(zc, sk, skb, &seq, copybuf_len, tss);
-- 
2.41.0.162.gfafddb0af9-goog


