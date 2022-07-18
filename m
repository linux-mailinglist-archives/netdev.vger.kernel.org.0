Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70E29578ACE
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 21:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236018AbiGRT3E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 15:29:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235942AbiGRT2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 15:28:52 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D90F6FE2;
        Mon, 18 Jul 2022 12:28:49 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id k7so6616102qkj.2;
        Mon, 18 Jul 2022 12:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=tW+JBzHw5uzW90VtxMVsK0vDh/ivXEOTk2ZO6iDHY3Y=;
        b=QfIBfiSefrMyF6U/utafae4Q2KqqgoV9UkXNUb/cNCDimVKBt0G1tfaL/mHBXzf1mQ
         jRw/wMkWn7yTRTAW5wqRwDMcLehBUnTyHP1bAf1Hapka0ilwXuG3pbwAsn/kLd8tfral
         jyOoXZ/TO57KVdLWf2b3SR/6OS0pvHPEJZCi69W4HoyaVwk/7o+Ed9CRJrGv/1O0uQZN
         HrF83DNgnBGRr4aYaIyOH8Av2zaMpfycUOm9pmFtDQvupTz59BQ/flMgqa+p4d0aFxQN
         P2jzNvocuGcejcl25q+JMXXR5RwO0bp5TXYdNVz4b2Y+gex8C66otzWU7VsXNaZNqpaz
         M+uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tW+JBzHw5uzW90VtxMVsK0vDh/ivXEOTk2ZO6iDHY3Y=;
        b=fQKdxWXpq+bElqIRWWN9kGkzjxCDvjDqC76Dy0L0MVYQ2kmxtsO0oSESlkJX1iiPI2
         g3FHKIytbIjW00ritista2SYuEECWQ46PwAf10h/I+fwFBhmCuSyMkfFuUQFWOXH9Z5e
         0Ok+t7RHg9eZnxIx73jbO28a0p2uHvm22yj66PP18QR+m3G9bmjMY4+nSVV58Sy/5tTu
         OzGd1wLzWagMs7CsyRKuGB+4yRALffbYqi6EM7NwH+O4WgNM8bf2/3xQVC5zyBSVpef1
         /Rby6GBQmyeIL1yHnOJdhSEP3Tf2KpXV3Irs3cDEakNPJ9NgPsGJWMHYxQie+/xlChzc
         iGtw==
X-Gm-Message-State: AJIora/Q8H16SpOjw/V29qSL+bSiNx0uQIfizuZeuDDl68ADbZPY4F+q
        IEvNQHRD1G4W4/SK1S1UwsWWkvCfF1L2xw==
X-Google-Smtp-Source: AGRyM1tin0DA+F/kE9pZ3f6UhK4Fjyxi8XCE6itTUh8vPN2OIeGacYVTcS32W6yBP+j3ajMQQ0HxIA==
X-Received: by 2002:a37:94b:0:b0:6b5:be32:4f2b with SMTP id 72-20020a37094b000000b006b5be324f2bmr17090382qkj.481.1658172528071;
        Mon, 18 Jul 2022 12:28:48 -0700 (PDT)
Received: from localhost ([2601:4c1:c100:1230:ab01:d009:465a:5ab1])
        by smtp.gmail.com with ESMTPSA id s11-20020a05620a0bcb00b006b5c5987ff2sm11273500qki.96.2022.07.18.12.28.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 12:28:47 -0700 (PDT)
From:   Yury Norov <yury.norov@gmail.com>
To:     linux-kernel@vger.kernel.org,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Alexey Klimov <aklimov@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Ben Segall <bsegall@google.com>,
        Christoph Lameter <cl@linux.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Dennis Zhou <dennis@kernel.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Eric Dumazet <edumazet@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Ingo Molnar <mingo@redhat.com>,
        Isabella Basso <isabbasso@riseup.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Juergen Gross <jgross@suse.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        KP Singh <kpsingh@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Mel Gorman <mgorman@suse.de>, Miroslav Benes <mbenes@suse.cz>,
        Nathan Chancellor <nathan@kernel.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Song Liu <songliubraving@fb.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Valentin Schneider <vschneid@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Vlastimil Babka <vbabka@suse.cz>, Yonghong Song <yhs@fb.com>,
        Yury Norov <yury.norov@gmail.com>, linux-mm@kvack.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH 01/16] lib/bitmap: add bitmap_check_params()
Date:   Mon, 18 Jul 2022 12:28:29 -0700
Message-Id: <20220718192844.1805158-2-yury.norov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220718192844.1805158-1-yury.norov@gmail.com>
References: <20220718192844.1805158-1-yury.norov@gmail.com>
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

bitmap_check_params() takes all arguments passed into bitmap functions
and runs sanity checks. bitmap_check(), bitmap_check_op() and
bitmap_check_move() are convenient wrappers for frequent cases.

The following patches of this series clear all warnings found with
bitmap_check_params() for x86_64, arm64 and powerpc64.

The last patch introduces CONFIG_DEBUG_BITMAP option to let user enable
bitmap_check_params().

No functional changes for existing kernel users, and for the following
functions inline parameters checks removed:
 - bitmap_pos_to_ord;
 - bitmap_remap;
 - bitmap_onto;
 - bitmap_fold.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 include/linux/bitmap.h |  95 +++++++++++++++++++++++++++++++
 lib/bitmap.c           | 123 ++++++++++++++++++++++++++++++++++++++---
 2 files changed, 209 insertions(+), 9 deletions(-)

diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
index 035d4ac66641..6a0d9170c4f0 100644
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -8,9 +8,46 @@
 #include <linux/bitops.h>
 #include <linux/find.h>
 #include <linux/limits.h>
+#include <linux/printk.h>
 #include <linux/string.h>
 #include <linux/types.h>
 
+#define CHECK_B2		BIT(0)
+#define CHECK_B3		BIT(1)
+#define CHECK_START		BIT(2)
+#define CHECK_OFF		BIT(3)
+#define CHECK_OVERLAP12		BIT(4)
+#define CHECK_OVERLAP13		BIT(5)
+#define CHECK_OVERLAP23		BIT(6)
+#define CHECK_OFF_EQ_0		BIT(7)
+#define CHECK_START_LE_OFF	BIT(8)
+
+#define NBITS_MAX	(INT_MAX-1)
+
+#ifdef CONFIG_DEBUG_BITMAP
+#define bitmap_check_params(b1, b2, b3, nbits, start, off, flags)		\
+	do {									\
+		if (__bitmap_check_params((b1), (b2), (b3), (nbits),		\
+						(start), (off), (flags))) {	\
+			pr_warn("Bitmap: parameters check failed");		\
+			pr_warn("%s [%d]: %s\n", __FILE__, __LINE__, __func__);	\
+		}								\
+	} while (0)
+
+bool __bitmap_check_params(const unsigned long *b1, const unsigned long *b2,
+				const unsigned long *b3, const unsigned long nbits,
+				const unsigned long start, const unsigned long off,
+				const unsigned long flags);
+#else
+#define bitmap_check_params(b1, b2, b3, nbits, start, off, flags)
+#endif
+
+#define bitmap_check(buf, nbits) bitmap_check_params(buf, NULL, NULL, nbits, 0, 0, 0)
+#define bitmap_check_op(dst, src1, src2, nbits) \
+	bitmap_check_params(dst, src1, src2, nbits, 0, 0, CHECK_B2 | CHECK_B3 | CHECK_OVERLAP23)
+#define bitmap_check_move(dst, src, nbits) \
+	bitmap_check_params(dst, src, NULL, nbits, 0, 0, CHECK_B2 | CHECK_OVERLAP12)
+
 struct device;
 
 /*
@@ -239,6 +276,8 @@ static inline void bitmap_zero(unsigned long *dst, unsigned int nbits)
 {
 	unsigned int len = BITS_TO_LONGS(nbits) * sizeof(unsigned long);
 
+	bitmap_check(dst, nbits);
+
 	if (small_const_nbits(nbits))
 		*dst = 0;
 	else
@@ -249,6 +288,8 @@ static inline void bitmap_fill(unsigned long *dst, unsigned int nbits)
 {
 	unsigned int len = BITS_TO_LONGS(nbits) * sizeof(unsigned long);
 
+	bitmap_check(dst, nbits);
+
 	if (small_const_nbits(nbits))
 		*dst = ~0UL;
 	else
@@ -260,6 +301,8 @@ static inline void bitmap_copy(unsigned long *dst, const unsigned long *src,
 {
 	unsigned int len = BITS_TO_LONGS(nbits) * sizeof(unsigned long);
 
+	bitmap_check_move(dst, src, nbits);
+
 	if (small_const_nbits(nbits))
 		*dst = *src;
 	else
@@ -318,6 +361,8 @@ void bitmap_to_arr64(u64 *buf, const unsigned long *bitmap, unsigned int nbits);
 static inline bool bitmap_and(unsigned long *dst, const unsigned long *src1,
 			const unsigned long *src2, unsigned int nbits)
 {
+	bitmap_check_op(dst, src1, src2, nbits);
+
 	if (small_const_nbits(nbits))
 		return (*dst = *src1 & *src2 & BITMAP_LAST_WORD_MASK(nbits)) != 0;
 	return __bitmap_and(dst, src1, src2, nbits);
@@ -326,6 +371,8 @@ static inline bool bitmap_and(unsigned long *dst, const unsigned long *src1,
 static inline void bitmap_or(unsigned long *dst, const unsigned long *src1,
 			const unsigned long *src2, unsigned int nbits)
 {
+	bitmap_check_op(dst, src1, src2, nbits);
+
 	if (small_const_nbits(nbits))
 		*dst = *src1 | *src2;
 	else
@@ -335,6 +382,8 @@ static inline void bitmap_or(unsigned long *dst, const unsigned long *src1,
 static inline void bitmap_xor(unsigned long *dst, const unsigned long *src1,
 			const unsigned long *src2, unsigned int nbits)
 {
+	bitmap_check_op(dst, src1, src2, nbits);
+
 	if (small_const_nbits(nbits))
 		*dst = *src1 ^ *src2;
 	else
@@ -344,6 +393,8 @@ static inline void bitmap_xor(unsigned long *dst, const unsigned long *src1,
 static inline bool bitmap_andnot(unsigned long *dst, const unsigned long *src1,
 			const unsigned long *src2, unsigned int nbits)
 {
+	bitmap_check_op(dst, src1, src2, nbits);
+
 	if (small_const_nbits(nbits))
 		return (*dst = *src1 & ~(*src2) & BITMAP_LAST_WORD_MASK(nbits)) != 0;
 	return __bitmap_andnot(dst, src1, src2, nbits);
@@ -352,6 +403,8 @@ static inline bool bitmap_andnot(unsigned long *dst, const unsigned long *src1,
 static inline void bitmap_complement(unsigned long *dst, const unsigned long *src,
 			unsigned int nbits)
 {
+	bitmap_check_move(dst, src, nbits);
+
 	if (small_const_nbits(nbits))
 		*dst = ~(*src);
 	else
@@ -368,6 +421,8 @@ static inline void bitmap_complement(unsigned long *dst, const unsigned long *sr
 static inline bool bitmap_equal(const unsigned long *src1,
 				const unsigned long *src2, unsigned int nbits)
 {
+	bitmap_check_move(src1, src2, nbits);
+
 	if (small_const_nbits(nbits))
 		return !((*src1 ^ *src2) & BITMAP_LAST_WORD_MASK(nbits));
 	if (__builtin_constant_p(nbits & BITMAP_MEM_MASK) &&
@@ -390,6 +445,9 @@ static inline bool bitmap_or_equal(const unsigned long *src1,
 				   const unsigned long *src3,
 				   unsigned int nbits)
 {
+	bitmap_check_params(src1, src2, src3, nbits, 0, 0, CHECK_B2 | CHECK_B3 |
+				CHECK_OVERLAP12 | CHECK_OVERLAP13 | CHECK_OVERLAP23);
+
 	if (!small_const_nbits(nbits))
 		return __bitmap_or_equal(src1, src2, src3, nbits);
 
@@ -400,6 +458,8 @@ static inline bool bitmap_intersects(const unsigned long *src1,
 				     const unsigned long *src2,
 				     unsigned int nbits)
 {
+	bitmap_check_move(src1, src2, nbits);
+
 	if (small_const_nbits(nbits))
 		return ((*src1 & *src2) & BITMAP_LAST_WORD_MASK(nbits)) != 0;
 	else
@@ -409,6 +469,8 @@ static inline bool bitmap_intersects(const unsigned long *src1,
 static inline bool bitmap_subset(const unsigned long *src1,
 				 const unsigned long *src2, unsigned int nbits)
 {
+	bitmap_check_move(src1, src2, nbits);
+
 	if (small_const_nbits(nbits))
 		return ! ((*src1 & ~(*src2)) & BITMAP_LAST_WORD_MASK(nbits));
 	else
@@ -417,6 +479,8 @@ static inline bool bitmap_subset(const unsigned long *src1,
 
 static inline bool bitmap_empty(const unsigned long *src, unsigned nbits)
 {
+	bitmap_check(src, nbits);
+
 	if (small_const_nbits(nbits))
 		return ! (*src & BITMAP_LAST_WORD_MASK(nbits));
 
@@ -425,6 +489,8 @@ static inline bool bitmap_empty(const unsigned long *src, unsigned nbits)
 
 static inline bool bitmap_full(const unsigned long *src, unsigned int nbits)
 {
+	bitmap_check(src, nbits);
+
 	if (small_const_nbits(nbits))
 		return ! (~(*src) & BITMAP_LAST_WORD_MASK(nbits));
 
@@ -434,6 +500,8 @@ static inline bool bitmap_full(const unsigned long *src, unsigned int nbits)
 static __always_inline
 unsigned long bitmap_weight(const unsigned long *src, unsigned int nbits)
 {
+	bitmap_check(src, nbits);
+
 	if (small_const_nbits(nbits))
 		return hweight_long(*src & BITMAP_LAST_WORD_MASK(nbits));
 	return __bitmap_weight(src, nbits);
@@ -442,6 +510,9 @@ unsigned long bitmap_weight(const unsigned long *src, unsigned int nbits)
 static __always_inline void bitmap_set(unsigned long *map, unsigned int start,
 		unsigned int nbits)
 {
+	bitmap_check_params(map, NULL, NULL, start + nbits, start, nbits,
+				CHECK_START | CHECK_OFF | CHECK_OFF_EQ_0);
+
 	if (__builtin_constant_p(nbits) && nbits == 1)
 		__set_bit(start, map);
 	else if (small_const_nbits(start + nbits))
@@ -458,6 +529,9 @@ static __always_inline void bitmap_set(unsigned long *map, unsigned int start,
 static __always_inline void bitmap_clear(unsigned long *map, unsigned int start,
 		unsigned int nbits)
 {
+	bitmap_check_params(map, NULL, NULL, start + nbits, start, nbits,
+				CHECK_START | CHECK_OFF | CHECK_OFF_EQ_0);
+
 	if (__builtin_constant_p(nbits) && nbits == 1)
 		__clear_bit(start, map);
 	else if (small_const_nbits(start + nbits))
@@ -474,6 +548,8 @@ static __always_inline void bitmap_clear(unsigned long *map, unsigned int start,
 static inline void bitmap_shift_right(unsigned long *dst, const unsigned long *src,
 				unsigned int shift, unsigned int nbits)
 {
+	bitmap_check_params(dst, src, NULL, nbits, shift, 0, CHECK_START);
+
 	if (small_const_nbits(nbits))
 		*dst = (*src & BITMAP_LAST_WORD_MASK(nbits)) >> shift;
 	else
@@ -483,6 +559,8 @@ static inline void bitmap_shift_right(unsigned long *dst, const unsigned long *s
 static inline void bitmap_shift_left(unsigned long *dst, const unsigned long *src,
 				unsigned int shift, unsigned int nbits)
 {
+	bitmap_check_params(dst, src, NULL, nbits, shift, 0, CHECK_START);
+
 	if (small_const_nbits(nbits))
 		*dst = (*src << shift) & BITMAP_LAST_WORD_MASK(nbits);
 	else
@@ -495,6 +573,10 @@ static inline void bitmap_replace(unsigned long *dst,
 				  const unsigned long *mask,
 				  unsigned int nbits)
 {
+	bitmap_check_op(dst, old, mask, nbits);
+	bitmap_check_op(dst, new, mask, nbits);
+	bitmap_check_op(dst, old, new, nbits);
+
 	if (small_const_nbits(nbits))
 		*dst = (*old & ~(*mask)) | (*new & *mask);
 	else
@@ -505,6 +587,8 @@ static inline void bitmap_next_set_region(unsigned long *bitmap,
 					  unsigned int *rs, unsigned int *re,
 					  unsigned int end)
 {
+	bitmap_check(bitmap, end);
+
 	*rs = find_next_bit(bitmap, end, *rs);
 	*re = find_next_zero_bit(bitmap, end, *rs + 1);
 }
@@ -571,6 +655,11 @@ static inline unsigned long bitmap_get_value8(const unsigned long *map,
 	const size_t index = BIT_WORD(start);
 	const unsigned long offset = start % BITS_PER_LONG;
 
+#ifdef DEBUG_BITMAP
+	bitmap_check_params(map, NULL, NULL, start + 8, start, 0, CHECK_START);
+	WARN_ON(start % 8);
+#endif
+
 	return (map[index] >> offset) & 0xFF;
 }
 
@@ -586,6 +675,12 @@ static inline void bitmap_set_value8(unsigned long *map, unsigned long value,
 	const size_t index = BIT_WORD(start);
 	const unsigned long offset = start % BITS_PER_LONG;
 
+#ifdef DEBUG_BITMAP
+	bitmap_check_params(map, NULL, NULL, start + 8, start, 0, CHECK_START);
+	WARN_ON(start % 8);
+	WARN_ON(value > 0xFFUL);
+#endif
+
 	map[index] &= ~(0xFFUL << offset);
 	map[index] |= value << offset;
 }
diff --git a/lib/bitmap.c b/lib/bitmap.c
index 2b67cd657692..cd4dd848ea6a 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -22,6 +22,71 @@
 
 #include "kstrtox.h"
 
+#ifdef CONFIG_DEBUG_BITMAP
+static inline const bool check_overlap(const unsigned long *b1, const unsigned long *b2,
+			  unsigned long nbits)
+{
+	return min(b1, b2) + DIV_ROUND_UP(nbits, BITS_PER_LONG) > max(b1, b2);
+}
+
+bool __bitmap_check_params(const unsigned long *b1, const unsigned long *b2,
+				const unsigned long *b3, const unsigned long nbits,
+				const unsigned long start, const unsigned long off,
+				const unsigned long flags)
+{
+	bool warn = false;
+
+	warn |= WARN_ON(b1 == NULL);
+	warn |= WARN_ON(nbits == 0);
+	warn |= WARN_ON(nbits > NBITS_MAX);
+
+	if (flags & CHECK_B2) {
+		warn |= WARN_ON(b2 == NULL);
+		warn |= WARN_ON(flags & CHECK_OVERLAP12 &&
+				check_overlap(b1, b2, nbits));
+	}
+
+	if (flags & CHECK_B3) {
+		warn |= WARN_ON(b3 == NULL);
+		warn |= WARN_ON(flags & CHECK_OVERLAP13 &&
+				check_overlap(b1, b3, nbits));
+	}
+
+	if (flags & CHECK_OVERLAP23)
+		warn |= WARN_ON(check_overlap(b2, b3, nbits));
+
+	if (flags & CHECK_START)
+		warn |= WARN_ON(start >= nbits);
+
+	if (flags & CHECK_OFF)
+		warn |= WARN_ON(off > nbits);
+
+	if (flags & CHECK_OFF_EQ_0)
+		warn |= WARN_ON(off == 0);
+
+	if (flags & CHECK_START_LE_OFF)
+		warn |= WARN_ON(start > off);
+
+	if (flags & CHECK_B2 && flags & CHECK_B3)
+		warn |= WARN_ON(b2 == b3);
+
+	if (warn) {
+		/*
+		 * Convert kernel addresses to unsigned long because
+		 * %pK hides actual values with the lack of randomization.
+		 */
+		pr_warn("b1:\t\t%lx\n", (unsigned long)b1);
+		pr_warn("b2:\t\t%lx\n", (unsigned long)b2);
+		pr_warn("b3:\t\t%lx\n", (unsigned long)b3);
+		pr_warn("nbits:\t%lu\n", nbits);
+		pr_warn("start:\t%lu\n", start);
+		pr_warn("off:\t%lu\n", off);
+	}
+	return warn;
+}
+EXPORT_SYMBOL(__bitmap_check_params);
+#endif
+
 /**
  * DOC: bitmap introduction
  *
@@ -214,6 +279,9 @@ void bitmap_cut(unsigned long *dst, const unsigned long *src,
 	unsigned long keep = 0, carry;
 	int i;
 
+	bitmap_check_params(dst, src, NULL, nbits, first, first + cut,
+				CHECK_B2 | CHECK_START | CHECK_OFF);
+
 	if (first % BITS_PER_LONG) {
 		keep = src[first / BITS_PER_LONG] &
 		       (~0UL >> (BITS_PER_LONG - first % BITS_PER_LONG));
@@ -410,6 +478,10 @@ unsigned long bitmap_find_next_zero_area_off(unsigned long *map,
 					     unsigned long align_offset)
 {
 	unsigned long index, end, i;
+
+	bitmap_check_params(map, NULL, NULL, size, start, start + nr,
+				CHECK_START | CHECK_OFF | CHECK_START_LE_OFF);
+
 again:
 	index = find_next_zero_bit(map, size, start);
 
@@ -797,6 +869,8 @@ int bitmap_parselist(const char *buf, unsigned long *maskp, int nmaskbits)
 	struct region r;
 	long ret;
 
+	bitmap_check(maskp, nmaskbits);
+
 	r.nbits = nmaskbits;
 	bitmap_zero(maskp, r.nbits);
 
@@ -900,6 +974,8 @@ int bitmap_parse(const char *start, unsigned int buflen,
 	int unset_bit;
 	int chunk;
 
+	bitmap_check(maskp, nmaskbits);
+
 	for (chunk = 0; ; chunk++) {
 		end = bitmap_find_region_reverse(start, end);
 		if (start > end)
@@ -950,7 +1026,9 @@ EXPORT_SYMBOL(bitmap_parse);
  */
 static int bitmap_pos_to_ord(const unsigned long *buf, unsigned int pos, unsigned int nbits)
 {
-	if (pos >= nbits || !test_bit(pos, buf))
+	bitmap_check_params(buf, NULL, NULL, nbits, pos, 0, CHECK_START);
+
+	if (!test_bit(pos, buf))
 		return -1;
 
 	return __bitmap_weight(buf, pos);
@@ -1024,8 +1102,13 @@ void bitmap_remap(unsigned long *dst, const unsigned long *src,
 {
 	unsigned int oldbit, w;
 
-	if (dst == src)		/* following doesn't handle inplace remaps */
-		return;
+	bitmap_check_params(dst, src, old, nbits, 0, 0,
+				CHECK_B2 | CHECK_B3 | CHECK_OVERLAP12 |
+				CHECK_OVERLAP13 | CHECK_OVERLAP23);
+	bitmap_check_params(dst, src, new, nbits, 0, 0,
+				CHECK_B2 | CHECK_B3 | CHECK_OVERLAP12 |
+				CHECK_OVERLAP13 | CHECK_OVERLAP23);
+
 	bitmap_zero(dst, nbits);
 
 	w = bitmap_weight(new, nbits);
@@ -1069,8 +1152,13 @@ EXPORT_SYMBOL(bitmap_remap);
 int bitmap_bitremap(int oldbit, const unsigned long *old,
 				const unsigned long *new, int bits)
 {
-	int w = bitmap_weight(new, bits);
-	int n = bitmap_pos_to_ord(old, oldbit, bits);
+	int w, n;
+
+	bitmap_check_params(old, new, NULL, bits, oldbit, 0, CHECK_B2 |
+				CHECK_START | CHECK_OVERLAP12);
+
+	w = bitmap_weight(new, bits);
+	n = bitmap_pos_to_ord(old, oldbit, bits);
 	if (n < 0 || w == 0)
 		return oldbit;
 	else
@@ -1190,8 +1278,9 @@ void bitmap_onto(unsigned long *dst, const unsigned long *orig,
 {
 	unsigned int n, m;	/* same meaning as in above comment */
 
-	if (dst == orig)	/* following doesn't handle inplace mappings */
-		return;
+	bitmap_check_params(dst, orig, relmap, bits, 0, 0, CHECK_B2 | CHECK_B3 |
+				CHECK_OVERLAP12 | CHECK_OVERLAP13 | CHECK_OVERLAP23);
+
 	bitmap_zero(dst, bits);
 
 	/*
@@ -1229,8 +1318,8 @@ void bitmap_fold(unsigned long *dst, const unsigned long *orig,
 {
 	unsigned int oldbit;
 
-	if (dst == orig)	/* following doesn't handle inplace mappings */
-		return;
+	bitmap_check_move(dst, orig, sz);
+
 	bitmap_zero(dst, nbits);
 
 	for_each_set_bit(oldbit, orig, nbits)
@@ -1332,6 +1421,8 @@ int bitmap_find_free_region(unsigned long *bitmap, unsigned int bits, int order)
 {
 	unsigned int pos, end;		/* scans bitmap by regions of size order */
 
+	bitmap_check_params(bitmap, NULL, NULL, bits, (1 << order), 0, CHECK_OFF);
+
 	for (pos = 0 ; (end = pos + (1U << order)) <= bits; pos = end) {
 		if (!__reg_op(bitmap, pos, order, REG_OP_ISFREE))
 			continue;
@@ -1355,6 +1446,8 @@ EXPORT_SYMBOL(bitmap_find_free_region);
  */
 void bitmap_release_region(unsigned long *bitmap, unsigned int pos, int order)
 {
+	bitmap_check_params(bitmap, NULL, NULL, pos + (1 << order), pos, pos + (1 << order),
+				CHECK_START | CHECK_OFF);
 	__reg_op(bitmap, pos, order, REG_OP_RELEASE);
 }
 EXPORT_SYMBOL(bitmap_release_region);
@@ -1372,6 +1465,8 @@ EXPORT_SYMBOL(bitmap_release_region);
  */
 int bitmap_allocate_region(unsigned long *bitmap, unsigned int pos, int order)
 {
+	bitmap_check_params(bitmap, NULL, NULL, pos + (1 << order), pos, pos + (1 << order),
+				CHECK_START | CHECK_OFF);
 	if (!__reg_op(bitmap, pos, order, REG_OP_ISFREE))
 		return -EBUSY;
 	return __reg_op(bitmap, pos, order, REG_OP_ALLOC);
@@ -1391,6 +1486,8 @@ void bitmap_copy_le(unsigned long *dst, const unsigned long *src, unsigned int n
 {
 	unsigned int i;
 
+	bitmap_check_move(dst, src, nbits);
+
 	for (i = 0; i < nbits/BITS_PER_LONG; i++) {
 		if (BITS_PER_LONG == 64)
 			dst[i] = cpu_to_le64(src[i]);
@@ -1476,6 +1573,8 @@ void bitmap_from_arr32(unsigned long *bitmap, const u32 *buf, unsigned int nbits
 {
 	unsigned int i, halfwords;
 
+	bitmap_check_move(bitmap, (unsigned long *)buf, nbits);
+
 	halfwords = DIV_ROUND_UP(nbits, 32);
 	for (i = 0; i < halfwords; i++) {
 		bitmap[i/2] = (unsigned long) buf[i];
@@ -1499,6 +1598,8 @@ void bitmap_to_arr32(u32 *buf, const unsigned long *bitmap, unsigned int nbits)
 {
 	unsigned int i, halfwords;
 
+	bitmap_check_move(bitmap, (unsigned long *)buf, nbits);
+
 	halfwords = DIV_ROUND_UP(nbits, 32);
 	for (i = 0; i < halfwords; i++) {
 		buf[i] = (u32) (bitmap[i/2] & UINT_MAX);
@@ -1524,6 +1625,8 @@ void bitmap_from_arr64(unsigned long *bitmap, const u64 *buf, unsigned int nbits
 {
 	int n;
 
+	bitmap_check_move(bitmap, (unsigned long *)buf, nbits);
+
 	for (n = nbits; n > 0; n -= 64) {
 		u64 val = *buf++;
 
@@ -1554,6 +1657,8 @@ void bitmap_to_arr64(u64 *buf, const unsigned long *bitmap, unsigned int nbits)
 {
 	const unsigned long *end = bitmap + BITS_TO_LONGS(nbits);
 
+	bitmap_check_move(bitmap, (unsigned long *)buf, nbits);
+
 	while (bitmap < end) {
 		*buf = *bitmap++;
 		if (bitmap < end)
-- 
2.34.1

