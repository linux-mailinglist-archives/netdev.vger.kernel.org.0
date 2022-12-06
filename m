Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D64E643F68
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 10:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234648AbiLFJJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 04:09:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234596AbiLFJJR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 04:09:17 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D15891EC74;
        Tue,  6 Dec 2022 01:09:13 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id bg10so10686022wmb.1;
        Tue, 06 Dec 2022 01:09:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8b19oLhfmkC05Kp/vt1nCFUxK8OkM5JEFuIMoo0rq8c=;
        b=FqMYEMOsmt4JQLVGNm5S1TSqezoy/Wm+21608BNqmG53N5coVTB9FaNMaRGmW5KepC
         GUWkoiQ/w1UCxg1hz7/l2nbQIhU77axi2aWrW7D+X3E8OcCTlSZpzCV21Qqk73el69vX
         8PX9as6iIZHqI+1tmrCaLMTjV7MdjDMCdO1PYLHiiGoS8XtG0lBeccdkccbXVSZXHe6f
         ZqP7Tvy+8VYGpMHwrDYhlhPB2uF9lCKXg5iEiBVMPOoTabNJ3K9WvzmobLiFEoboPqko
         KMH73kcdt4k3uB0D8QNAJGqAX/X4p7P+Ys3zfl032rPrfyN9kti7k7nJOmJPyQ4xwzDR
         L7dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8b19oLhfmkC05Kp/vt1nCFUxK8OkM5JEFuIMoo0rq8c=;
        b=DGLmtCwoy0B30kA1KUNExRSdeGI7iXiCponqrinyvuKxfHNkDodTmtj/vOWXybFj7I
         CP1Mv5GQeXh25cWHN6uyawWrW1odSOAIrBvm2hKChV2MXOvK1fHCRTMUJyfExFuVsYYZ
         VaNNaQDRRxjZL5NYUEqk8ILqGUe8LDKdSde/fkxyB3JYnFn1ErknfCUnMKuJk2zQziSX
         IX/24wqm5uT+6rBBGwPuOwHOtIuhfkvRNSrjVD8aYGGFjNz9qdfrzOqQjl0w0EbdIlcn
         x35ZyTxYAY+M6dqrhKXzAWoEr5Pe0qhQLERORfrRdzBiYHgrB4OALtQjfqYwPmobms1S
         LG3w==
X-Gm-Message-State: ANoB5pnB+kshMzAXC5IpFANOFuwHEgNTQMaX2oZ/rnwqolJGMBfZ0RpO
        vKngSsrT4Kq0RSah1IIKuGnVYbdTmQNddm3csc8=
X-Google-Smtp-Source: AA0mqf4Hml5ECg4VAreCLRaBheMncz/EoX4aQKJfRNK7I+JZFjCk4nm8uTjYlNHa73sDgKj0wN2S8A==
X-Received: by 2002:a05:600c:2119:b0:3d0:77f0:e3f5 with SMTP id u25-20020a05600c211900b003d077f0e3f5mr17538370wml.184.1670317751756;
        Tue, 06 Dec 2022 01:09:11 -0800 (PST)
Received: from localhost.localdomain (c-5eea761b-74736162.cust.telenor.se. [94.234.118.27])
        by smtp.gmail.com with ESMTPSA id j23-20020a05600c1c1700b003cf57329221sm25065690wms.14.2022.12.06.01.09.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Dec 2022 01:09:11 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org
Cc:     jonathan.lemon@gmail.com
Subject: [PATCH bpf-next 07/15] selftests/xsk: get rid of asm store/release implementations
Date:   Tue,  6 Dec 2022 10:08:18 +0100
Message-Id: <20221206090826.2957-8-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221206090826.2957-1-magnus.karlsson@gmail.com>
References: <20221206090826.2957-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Get rid of our own homegrown assembly store/release and load/acquire
implementations. Use the HW agnositic APIs the compiler offers
instead.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xsk.h | 80 ++-----------------------------
 1 file changed, 4 insertions(+), 76 deletions(-)

diff --git a/tools/testing/selftests/bpf/xsk.h b/tools/testing/selftests/bpf/xsk.h
index 997723b0bfb2..24ee765aded3 100644
--- a/tools/testing/selftests/bpf/xsk.h
+++ b/tools/testing/selftests/bpf/xsk.h
@@ -23,77 +23,6 @@
 extern "C" {
 #endif
 
-/* This whole API has been deprecated and moved to libxdp that can be found at
- * https://github.com/xdp-project/xdp-tools. The APIs are exactly the same so
- * it should just be linking with libxdp instead of libbpf for this set of
- * functionality. If not, please submit a bug report on the aforementioned page.
- */
-
-/* Load-Acquire Store-Release barriers used by the XDP socket
- * library. The following macros should *NOT* be considered part of
- * the xsk.h API, and is subject to change anytime.
- *
- * LIBRARY INTERNAL
- */
-
-#define __XSK_READ_ONCE(x) (*(volatile typeof(x) *)&x)
-#define __XSK_WRITE_ONCE(x, v) (*(volatile typeof(x) *)&x) = (v)
-
-#if defined(__i386__) || defined(__x86_64__)
-# define libbpf_smp_store_release(p, v)					\
-	do {								\
-		asm volatile("" : : : "memory");			\
-		__XSK_WRITE_ONCE(*p, v);				\
-	} while (0)
-# define libbpf_smp_load_acquire(p)					\
-	({								\
-		typeof(*p) ___p1 = __XSK_READ_ONCE(*p);			\
-		asm volatile("" : : : "memory");			\
-		___p1;							\
-	})
-#elif defined(__aarch64__)
-# define libbpf_smp_store_release(p, v)					\
-		asm volatile ("stlr %w1, %0" : "=Q" (*p) : "r" (v) : "memory")
-# define libbpf_smp_load_acquire(p)					\
-	({								\
-		typeof(*p) ___p1;					\
-		asm volatile ("ldar %w0, %1"				\
-			      : "=r" (___p1) : "Q" (*p) : "memory");	\
-		___p1;							\
-	})
-#elif defined(__riscv)
-# define libbpf_smp_store_release(p, v)					\
-	do {								\
-		asm volatile ("fence rw,w" : : : "memory");		\
-		__XSK_WRITE_ONCE(*p, v);				\
-	} while (0)
-# define libbpf_smp_load_acquire(p)					\
-	({								\
-		typeof(*p) ___p1 = __XSK_READ_ONCE(*p);			\
-		asm volatile ("fence r,rw" : : : "memory");		\
-		___p1;							\
-	})
-#endif
-
-#ifndef libbpf_smp_store_release
-#define libbpf_smp_store_release(p, v)					\
-	do {								\
-		__sync_synchronize();					\
-		__XSK_WRITE_ONCE(*p, v);				\
-	} while (0)
-#endif
-
-#ifndef libbpf_smp_load_acquire
-#define libbpf_smp_load_acquire(p)					\
-	({								\
-		typeof(*p) ___p1 = __XSK_READ_ONCE(*p);			\
-		__sync_synchronize();					\
-		___p1;							\
-	})
-#endif
-
-/* LIBRARY INTERNAL -- END */
-
 /* Do not access these members directly. Use the functions below. */
 #define DEFINE_XSK_RING(name) \
 struct name { \
@@ -168,7 +97,7 @@ static inline __u32 xsk_prod_nb_free(struct xsk_ring_prod *r, __u32 nb)
 	 * this function. Without this optimization it whould have been
 	 * free_entries = r->cached_prod - r->cached_cons + r->size.
 	 */
-	r->cached_cons = libbpf_smp_load_acquire(r->consumer);
+	r->cached_cons = __atomic_load_n(r->consumer, __ATOMIC_ACQUIRE);
 	r->cached_cons += r->size;
 
 	return r->cached_cons - r->cached_prod;
@@ -179,7 +108,7 @@ static inline __u32 xsk_cons_nb_avail(struct xsk_ring_cons *r, __u32 nb)
 	__u32 entries = r->cached_prod - r->cached_cons;
 
 	if (entries == 0) {
-		r->cached_prod = libbpf_smp_load_acquire(r->producer);
+		r->cached_prod = __atomic_load_n(r->producer, __ATOMIC_ACQUIRE);
 		entries = r->cached_prod - r->cached_cons;
 	}
 
@@ -202,7 +131,7 @@ static inline void xsk_ring_prod__submit(struct xsk_ring_prod *prod, __u32 nb)
 	/* Make sure everything has been written to the ring before indicating
 	 * this to the kernel by writing the producer pointer.
 	 */
-	libbpf_smp_store_release(prod->producer, *prod->producer + nb);
+	__atomic_store_n(prod->producer, *prod->producer + nb, __ATOMIC_RELEASE);
 }
 
 static inline __u32 xsk_ring_cons__peek(struct xsk_ring_cons *cons, __u32 nb, __u32 *idx)
@@ -227,8 +156,7 @@ static inline void xsk_ring_cons__release(struct xsk_ring_cons *cons, __u32 nb)
 	/* Make sure data has been read before indicating we are done
 	 * with the entries by updating the consumer pointer.
 	 */
-	libbpf_smp_store_release(cons->consumer, *cons->consumer + nb);
-
+	__atomic_store_n(cons->consumer, *cons->consumer + nb, __ATOMIC_RELEASE);
 }
 
 static inline void *xsk_umem__get_data(void *umem_area, __u64 addr)
-- 
2.34.1

