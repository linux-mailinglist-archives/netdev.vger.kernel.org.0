Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8036657BF
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 10:39:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbjAKJi6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 04:38:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230407AbjAKJh2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 04:37:28 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50A9E2733;
        Wed, 11 Jan 2023 01:36:12 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id h16so14401828wrz.12;
        Wed, 11 Jan 2023 01:36:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6VsYwaNATWs4Wq26v1/a3VAt398DLa94R7is0br73P8=;
        b=CQBlSMBsPcKUwmqXhYwGgGSBft81AtqE0IqVpK2WHfEX7r9bhUtj9LAORMO25/acK1
         u4DPASK2s5/pNtPnHfX5Ao4m+7Vg1TMTAWdGt9fqJtY5ePDaebCtEnAoVeOD5OjsRrk4
         7/sFrp/aWg9TzJyP8G59D0PFFll/MT3VL1WASUVyH0K1PiUTtZOnLi0dGBsLVPylEKh+
         aAMjSe+6HoovQLBsA8Fh2pCkRSTUrgIduPkFgw8n0TNw0L+MRgeUDdTMqviH2XLaFs3g
         sAWUAuWfCvsDWyuuR+Ug5HROyxXHvkODs+p0ph4xE6YoE9iKiexhJxBYAlXUFwife96v
         YqGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6VsYwaNATWs4Wq26v1/a3VAt398DLa94R7is0br73P8=;
        b=gumze0izjERBSfaGRk1dYqJzTau1EsXd5x65ymmrLvQLYCcXX5cUr+S9evL6eUnGRs
         Yi8UmAj3a9JI7DW0956gmspqiekXtEPdP6oxMaLR8qeGs6YZc2bAu6y/widqnVCoD7BD
         /NyQzCN93O/gmEACXRD2RSojpUvsKooOBEE32INuXYmY5tkfK5DQGV7t53EE0vD8gNyt
         qsRAZ/WdnjOM0yJoA90HQwNvlkvybzTiZhZlqywMdiyYwVlKK4QSd1Zrc4FfV5r8RdN2
         Noy1oU02kYvv5ZJrckuoVFYpEOrYy3S9aovypJlR3Geflm0fRbqB+FW7onXzvdCJtXSo
         RBdQ==
X-Gm-Message-State: AFqh2kog0nYA3S0Dy/ihlxwrsx3HYhoE9hi3+HHX2y1yYnH2srQhbWHj
        f83AVFvQpCY12u+zzZFWPBY=
X-Google-Smtp-Source: AMrXdXt3nOe2zmYdr2XR6ea5369hHChYcwCeiHdAd+ADqUx55Q3QlbdymI4V5t5eACYT472pky6Ojg==
X-Received: by 2002:a05:6000:18c9:b0:242:82a4:2bf4 with SMTP id w9-20020a05600018c900b0024282a42bf4mr42893009wrq.10.1673429771809;
        Wed, 11 Jan 2023 01:36:11 -0800 (PST)
Received: from localhost.localdomain (h-176-10-254-193.A165.priv.bahnhof.se. [176.10.254.193])
        by smtp.gmail.com with ESMTPSA id c18-20020adffb52000000b0025e86026866sm15553069wrs.0.2023.01.11.01.36.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Jan 2023 01:36:11 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, tirthendu.sarkar@intel.com
Cc:     jonathan.lemon@gmail.com
Subject: [PATCH bpf-next v3 07/15] selftests/xsk: replace asm acquire/release implementations
Date:   Wed, 11 Jan 2023 10:35:18 +0100
Message-Id: <20230111093526.11682-8-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230111093526.11682-1-magnus.karlsson@gmail.com>
References: <20230111093526.11682-1-magnus.karlsson@gmail.com>
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

From: Magnus Karlsson <magnus.karlsson@intel.com>

Replace our own homegrown assembly store/release and load/acquire
implementations with the HW agnositic atomic APIs C11 offers. This to
make the code more portable, easier to read, and reduce the
maintenance burden.

The original code used load-acquire and store-release barriers
hand-coded in assembly. Since C11, these kind of operations are
offered as built-ins in gcc and llvm. The load-acquire operation
prevents hoisting of non-atomic memory operations to before this
operation and it corresponds to the __ATOMIC_ACQUIRE operation in the
built-in atomics. The store-release operation prevents hoisting of
non-atomic memory operations to after this operation and it
corresponds to the __ATOMIC_RELEASE operation in the built-in atomics.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
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

