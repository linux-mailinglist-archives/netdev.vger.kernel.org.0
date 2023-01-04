Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2954E65D25F
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 13:20:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239109AbjADMTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 07:19:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239197AbjADMSx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 07:18:53 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 478C218E25;
        Wed,  4 Jan 2023 04:18:52 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id g10so11615232wmo.1;
        Wed, 04 Jan 2023 04:18:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K2Hhp8XXPwYUVFWAl9eTJ/uoEMdBr1GQD3ytaxh/CFg=;
        b=MmrIVgPyCIFMnqdTfYSQwh3oGLVfxKXk8QtQLFpNb4Qp3NAh5w+9illMad46XyenHg
         xFnbKgoGqNLmutg+2jl4/26cf+09KPTHfOi5VFCkmKI2cgHudkNgyitD4m0CA1AHv3sN
         FWH5F8w0QjQjZ7iT12DvOljA/quhtFM20vBaeOed/bpMOHBhCfD+PKq61zOHowm616gU
         bcKBnfVZmI+IQmRYkJaXh0eOBmjcELJw06O+6+11uDwTEtTeOdFuupaIvgDZLYtfA0xy
         WgkitffiecEcv13gJrP1XXGeer6UvdfJ2B1EyDDadwMiW+sSzhd6UfJT5HrLMFChGmsj
         avJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K2Hhp8XXPwYUVFWAl9eTJ/uoEMdBr1GQD3ytaxh/CFg=;
        b=3Fkgbfs7SNJPn3SXIJlVdGUPzfYYUCZd5VRl4EsRalAGPco8SIE+K1t0M2t/T/akWj
         4d0tvouqNd6MZM+TZtqyOBKr7uVatAmgl45FpDm3lpCYEDNoy07YGuH4gKcI/QAPcnzI
         jjsGJyEfwMLfb6ZCCPdTZ2SdTkup9WOnhgpNbLQFgGojO1yEuqhjycaIQUaGsWGaMEWQ
         YOs+E7jjpQRIOQiibNxg0wVuALidhH0xQ1QU1M3FPWvExSpnctcGNwfTc6zW8+hYsY4c
         YbCTk6zSEjCkNz2wsgO01DPnMpCE7B+elJo+rXe5F/7rljpmGvlZdCvEhvGV1fv7fal2
         zhuQ==
X-Gm-Message-State: AFqh2kpaTsRtyfenWV9S/SSyVUHl8tKWR8Hh8nOWXvfI9CDcH2+hQ7X5
        FMUei0y49DzdSm3c7A67Az4=
X-Google-Smtp-Source: AMrXdXudd9pyLO8ZEn7hD0T/DSP7drv7eStLHL3iZzCGl1lWcUDk3ZrEnsp4Li3oGjarsjfF1zHi3A==
X-Received: by 2002:a05:600c:3b90:b0:3d1:f0f1:ceb4 with SMTP id n16-20020a05600c3b9000b003d1f0f1ceb4mr33904985wms.19.1672834730630;
        Wed, 04 Jan 2023 04:18:50 -0800 (PST)
Received: from localhost.localdomain (h-176-10-254-193.A165.priv.bahnhof.se. [176.10.254.193])
        by smtp.gmail.com with ESMTPSA id w12-20020a05600c474c00b003d04e4ed873sm35013749wmo.22.2023.01.04.04.18.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Jan 2023 04:18:50 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, tirthendu.sarkar@intel.com
Cc:     jonathan.lemon@gmail.com
Subject: [PATCH bpf-next v2 07/15] selftests/xsk: replace asm acquire/release implementations
Date:   Wed,  4 Jan 2023 13:17:36 +0100
Message-Id: <20230104121744.2820-8-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230104121744.2820-1-magnus.karlsson@gmail.com>
References: <20230104121744.2820-1-magnus.karlsson@gmail.com>
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

