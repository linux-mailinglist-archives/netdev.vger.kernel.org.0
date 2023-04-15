Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D26E26E32F4
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 19:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbjDORip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 13:38:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbjDORim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 13:38:42 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79A6B49EA
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 10:38:09 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id ffacd0b85a97d-2f939bea9ebso106081f8f.0
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 10:38:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.huji.ac.il; s=mailhuji; t=1681580281; x=1684172281;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=aS7fqmEfxb6b9S+kurYxA9PwyNtw0egsLUjINOP8XFo=;
        b=RrWluVHIrdyG7dEP4BEyRXGiJ105AMbvXy+7fAKRN+HHp1q96OffjcIRkLk0BkyRj4
         48WcDZgR2goAt+bCDw+YqdZD4YMbpt0u11y6Fw2P9yvS48mMu8STWeczi30AOrY23g4B
         a4sGWDzKte9rnHJIVodV0CZDCQvR9MAaaxgG4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681580281; x=1684172281;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aS7fqmEfxb6b9S+kurYxA9PwyNtw0egsLUjINOP8XFo=;
        b=VE748+j+tjN/j03XohRjaCrEQdDlCNAaEoqqrKG0Xfncx8Q0EBlapLhwIC0r7/QnVN
         MVzUv+jz8VbC/ziBXvGSwUplZfmeIrFCTAk00wnHZBG15zwrlEVilgOXqi7b6q+qMdnC
         JhC8QsKw7dCFCPvzvrhX6WvxTEE5WM2MScoKk7I78C7SP7t1vsCN2laBNXxLntA1Xzd2
         giCxa4q+9OcycihVh4nDyaPofcODnoZsBaZ77thxh1KJWk3qItXZ9c3+V3M8SpWj/oOo
         ssf6W+TBJsz38uFOOyaJD/lRYBZG4tbNguPvci0NqFmpGZgaSSJjdfQezaWdXtP3ZMDN
         YfQA==
X-Gm-Message-State: AAQBX9eKTbvy0GuSWwNgNGBHDWO8a0ZcQ0295henpW9B6X+tv1nKKvHL
        FYfyneIh7+Fo7mzDcQsqTefjdQ==
X-Google-Smtp-Source: AKy350bJmK2ML4dgbgzpw/2QKLKGNxIHZ+2MJbDbOC+EhwfCFOkxdIJocvSPfYlYxOTPIRms4oarmA==
X-Received: by 2002:a5d:4d48:0:b0:2f5:67c1:d70e with SMTP id a8-20020a5d4d48000000b002f567c1d70emr1903892wru.21.1681580280697;
        Sat, 15 Apr 2023 10:38:00 -0700 (PDT)
Received: from localhost.localdomain ([94.159.161.55])
        by smtp.gmail.com with ESMTPSA id jb11-20020a05600c54eb00b003f0a76e5ebbsm7196797wmb.13.2023.04.15.10.37.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Apr 2023 10:38:00 -0700 (PDT)
From:   david.keisarschm@mail.huji.ac.il
To:     linux-kernel@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Andrea Parri <parri.andrea@gmail.com>,
        Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Jade Alglave <j.alglave@ucl.ac.uk>,
        Luc Maranget <luc.maranget@inria.fr>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Akira Yokosawa <akiyks@gmail.com>,
        Daniel Lustig <dlustig@nvidia.com>,
        Joel Fernandes <joel@joelfernandes.org>
Cc:     Jason@zx2c4.com, keescook@chromium.org,
        David Keisar Schmidt <david.keisarschm@mail.huji.ac.il>,
        ilay.bahat1@gmail.com, aksecurity@gmail.com,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [PATCH v5 3/3] Replace invocation of weak PRNG
Date:   Sat, 15 Apr 2023 20:37:53 +0300
Message-Id: <20230415173756.5520-1-david.keisarschm@mail.huji.ac.il>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Keisar Schmidt <david.keisarschm@mail.huji.ac.il>

The memory randomization of the virtual address space
of kernel memory regions (physical memory mapping, vmalloc & vmemmap) inside
arch/x86/mm/kaslr.c is based on the function prandom_bytes_state which uses
the prandom_u32 PRNG.

However, the seeding here is done by calling prandom_seed_state,
which effectively uses only 32bits of the seed, which means that observing ONE
region's offset (say 30 bits) can provide the attacker with 2 possible seeds
(from which the attacker can calculate the remaining two regions)

In order to fix it,  we have replaced the two invocations of prandom_bytes_state and prandom_seed_state
with siphash, which is considered more secure.
Besides, the original code used the same pseudo-random number in every iteration, so to add some additional randomization
we call siphash every iteration, hashing the iteration index with the described key.

Signed-off-by: David Keisar Schmidt <david.keisarschm@mail.huji.ac.il>
---
Changes since v4:
* replaced the call to prandom_bytes_state and prandom_seed_state,
    with siphash.

Changes since v2:
* edited commit message.

 arch/x86/mm/kaslr.c                           |  18 +-
 include/uapi/linux/netfilter/xt_connmark.h    |  40 +-
 include/uapi/linux/netfilter/xt_dscp.h        |  27 +-
 include/uapi/linux/netfilter/xt_mark.h        |  17 +-
 include/uapi/linux/netfilter/xt_rateest.h     |  38 +-
 include/uapi/linux/netfilter/xt_tcpmss.h      |  13 +-
 include/uapi/linux/netfilter_ipv4/ipt_ecn.h   |  40 +-
 include/uapi/linux/netfilter_ipv4/ipt_ttl.h   |  14 +-
 include/uapi/linux/netfilter_ipv6/ip6t_hl.h   |  14 +-
 net/netfilter/xt_dscp.c                       | 149 ++++---
 net/netfilter/xt_hl.c                         | 164 +++++---
 net/netfilter/xt_rateest.c                    | 282 ++++++++-----
 net/netfilter/xt_tcpmss.c                     | 378 ++++++++++++++----
 ...Z6.0+pooncelock+pooncelock+pombonce.litmus |  12 +-
 14 files changed, 802 insertions(+), 404 deletions(-)

diff --git a/arch/x86/mm/kaslr.c b/arch/x86/mm/kaslr.c
index 557f0fe25..65714c917 100644
--- a/arch/x86/mm/kaslr.c
+++ b/arch/x86/mm/kaslr.c
@@ -25,6 +25,7 @@
 #include <linux/random.h>
 #include <linux/memblock.h>
 #include <linux/pgtable.h>
+#include <linux/siphash.h>
 
 #include <asm/setup.h>
 #include <asm/kaslr.h>
@@ -66,9 +67,14 @@ void __init kernel_randomize_memory(void)
 	size_t i;
 	unsigned long vaddr_start, vaddr;
 	unsigned long rand, memory_tb;
-	struct rnd_state rand_state;
 	unsigned long remain_entropy;
 	unsigned long vmemmap_size;
+	/*
+	 * Create a Siphash key. We use a mask of PI digits to add some
+	 * randomness to the key.
+	 */
+	u64 seed = (u64) kaslr_get_random_long("Memory");
+	siphash_key_t key = {{seed, seed ^ 0x3141592653589793UL}};
 
 	vaddr_start = pgtable_l5_enabled() ? __PAGE_OFFSET_BASE_L5 : __PAGE_OFFSET_BASE_L4;
 	vaddr = vaddr_start;
@@ -112,9 +118,6 @@ void __init kernel_randomize_memory(void)
 	remain_entropy = vaddr_end - vaddr_start;
 	for (i = 0; i < ARRAY_SIZE(kaslr_regions); i++)
 		remain_entropy -= get_padding(&kaslr_regions[i]);
-
-	prandom_seed_state(&rand_state, kaslr_get_random_long("Memory"));
-
 	for (i = 0; i < ARRAY_SIZE(kaslr_regions); i++) {
 		unsigned long entropy;
 
@@ -123,7 +126,12 @@ void __init kernel_randomize_memory(void)
 		 * available.
 		 */
 		entropy = remain_entropy / (ARRAY_SIZE(kaslr_regions) - i);
-		prandom_bytes_state(&rand_state, &rand, sizeof(rand));
+
+		/*
+                 * Use Siphash to generate a pseudo-random number every
+                 * iteration
+                 * */
+		rand = siphash_1u64(i, &key);
 		entropy = (rand % (entropy + 1)) & PUD_MASK;
 		vaddr += entropy;
 		*kaslr_regions[i].base = vaddr;
diff --git a/include/uapi/linux/netfilter/xt_connmark.h b/include/uapi/linux/netfilter/xt_connmark.h
index 41b578ccd..36cc956ea 100644
--- a/include/uapi/linux/netfilter/xt_connmark.h
+++ b/include/uapi/linux/netfilter/xt_connmark.h
@@ -1,37 +1,7 @@
-/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
-/* Copyright (C) 2002,2004 MARA Systems AB <https://www.marasystems.com>
- * by Henrik Nordstrom <hno@marasystems.com>
- */
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _XT_CONNMARK_H_target
+#define _XT_CONNMARK_H_target
 
-#ifndef _XT_CONNMARK_H
-#define _XT_CONNMARK_H
+#include <linux/netfilter/xt_connmark.h>
 
-#include <linux/types.h>
-
-enum {
-	XT_CONNMARK_SET = 0,
-	XT_CONNMARK_SAVE,
-	XT_CONNMARK_RESTORE
-};
-
-enum {
-	D_SHIFT_LEFT = 0,
-	D_SHIFT_RIGHT,
-};
-
-struct xt_connmark_tginfo1 {
-	__u32 ctmark, ctmask, nfmask;
-	__u8 mode;
-};
-
-struct xt_connmark_tginfo2 {
-	__u32 ctmark, ctmask, nfmask;
-	__u8 shift_dir, shift_bits, mode;
-};
-
-struct xt_connmark_mtinfo1 {
-	__u32 mark, mask;
-	__u8 invert;
-};
-
-#endif /*_XT_CONNMARK_H*/
+#endif /*_XT_CONNMARK_H_target*/
diff --git a/include/uapi/linux/netfilter/xt_dscp.h b/include/uapi/linux/netfilter/xt_dscp.h
index 7594e4df8..223d635e8 100644
--- a/include/uapi/linux/netfilter/xt_dscp.h
+++ b/include/uapi/linux/netfilter/xt_dscp.h
@@ -1,32 +1,27 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
-/* x_tables module for matching the IPv4/IPv6 DSCP field
+/* x_tables module for setting the IPv4/IPv6 DSCP field
  *
  * (C) 2002 Harald Welte <laforge@gnumonks.org>
+ * based on ipt_FTOS.c (C) 2000 by Matthew G. Marsh <mgm@paktronix.com>
  * This software is distributed under GNU GPL v2, 1991
  *
  * See RFC2474 for a description of the DSCP field within the IP Header.
  *
- * xt_dscp.h,v 1.3 2002/08/05 19:00:21 laforge Exp
+ * xt_DSCP.h,v 1.7 2002/03/14 12:03:13 laforge Exp
 */
-#ifndef _XT_DSCP_H
-#define _XT_DSCP_H
-
+#ifndef _XT_DSCP_TARGET_H
+#define _XT_DSCP_TARGET_H
+#include <linux/netfilter/xt_dscp.h>
 #include <linux/types.h>
 
-#define XT_DSCP_MASK	0xfc	/* 11111100 */
-#define XT_DSCP_SHIFT	2
-#define XT_DSCP_MAX	0x3f	/* 00111111 */
-
-/* match info */
-struct xt_dscp_info {
+/* target info */
+struct xt_DSCP_info {
 	__u8 dscp;
-	__u8 invert;
 };
 
-struct xt_tos_match_info {
-	__u8 tos_mask;
+struct xt_tos_target_info {
 	__u8 tos_value;
-	__u8 invert;
+	__u8 tos_mask;
 };
 
-#endif /* _XT_DSCP_H */
+#endif /* _XT_DSCP_TARGET_H */
diff --git a/include/uapi/linux/netfilter/xt_mark.h b/include/uapi/linux/netfilter/xt_mark.h
index 9d0526ced..f1fe2b4be 100644
--- a/include/uapi/linux/netfilter/xt_mark.h
+++ b/include/uapi/linux/netfilter/xt_mark.h
@@ -1,16 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
-#ifndef _XT_MARK_H
-#define _XT_MARK_H
+#ifndef _XT_MARK_H_target
+#define _XT_MARK_H_target
 
-#include <linux/types.h>
+#include <linux/netfilter/xt_mark.h>
 
-struct xt_mark_tginfo2 {
-	__u32 mark, mask;
-};
-
-struct xt_mark_mtinfo1 {
-	__u32 mark, mask;
-	__u8 invert;
-};
-
-#endif /*_XT_MARK_H*/
+#endif /*_XT_MARK_H_target */
diff --git a/include/uapi/linux/netfilter/xt_rateest.h b/include/uapi/linux/netfilter/xt_rateest.h
index 52a37bdc1..2b87a71e6 100644
--- a/include/uapi/linux/netfilter/xt_rateest.h
+++ b/include/uapi/linux/netfilter/xt_rateest.h
@@ -1,39 +1,17 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
-#ifndef _XT_RATEEST_MATCH_H
-#define _XT_RATEEST_MATCH_H
+#ifndef _XT_RATEEST_TARGET_H
+#define _XT_RATEEST_TARGET_H
 
 #include <linux/types.h>
 #include <linux/if.h>
 
-enum xt_rateest_match_flags {
-	XT_RATEEST_MATCH_INVERT	= 1<<0,
-	XT_RATEEST_MATCH_ABS	= 1<<1,
-	XT_RATEEST_MATCH_REL	= 1<<2,
-	XT_RATEEST_MATCH_DELTA	= 1<<3,
-	XT_RATEEST_MATCH_BPS	= 1<<4,
-	XT_RATEEST_MATCH_PPS	= 1<<5,
-};
-
-enum xt_rateest_match_mode {
-	XT_RATEEST_MATCH_NONE,
-	XT_RATEEST_MATCH_EQ,
-	XT_RATEEST_MATCH_LT,
-	XT_RATEEST_MATCH_GT,
-};
-
-struct xt_rateest_match_info {
-	char			name1[IFNAMSIZ];
-	char			name2[IFNAMSIZ];
-	__u16		flags;
-	__u16		mode;
-	__u32		bps1;
-	__u32		pps1;
-	__u32		bps2;
-	__u32		pps2;
+struct xt_rateest_target_info {
+	char			name[IFNAMSIZ];
+	__s8			interval;
+	__u8		ewma_log;
 
 	/* Used internally by the kernel */
-	struct xt_rateest	*est1 __attribute__((aligned(8)));
-	struct xt_rateest	*est2 __attribute__((aligned(8)));
+	struct xt_rateest	*est __attribute__((aligned(8)));
 };
 
-#endif /* _XT_RATEEST_MATCH_H */
+#endif /* _XT_RATEEST_TARGET_H */
diff --git a/include/uapi/linux/netfilter/xt_tcpmss.h b/include/uapi/linux/netfilter/xt_tcpmss.h
index 2268f58b4..65ea6c9da 100644
--- a/include/uapi/linux/netfilter/xt_tcpmss.h
+++ b/include/uapi/linux/netfilter/xt_tcpmss.h
@@ -1,12 +1,13 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
-#ifndef _XT_TCPMSS_MATCH_H
-#define _XT_TCPMSS_MATCH_H
+#ifndef _XT_TCPMSS_H
+#define _XT_TCPMSS_H
 
 #include <linux/types.h>
 
-struct xt_tcpmss_match_info {
-    __u16 mss_min, mss_max;
-    __u8 invert;
+struct xt_tcpmss_info {
+	__u16 mss;
 };
 
-#endif /*_XT_TCPMSS_MATCH_H*/
+#define XT_TCPMSS_CLAMP_PMTU 0xffff
+
+#endif /* _XT_TCPMSS_H */
diff --git a/include/uapi/linux/netfilter_ipv4/ipt_ecn.h b/include/uapi/linux/netfilter_ipv4/ipt_ecn.h
index 8121bec47..e3630fd04 100644
--- a/include/uapi/linux/netfilter_ipv4/ipt_ecn.h
+++ b/include/uapi/linux/netfilter_ipv4/ipt_ecn.h
@@ -1,16 +1,34 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
-#ifndef _IPT_ECN_H
-#define _IPT_ECN_H
+/* Header file for iptables ipt_ECN target
+ *
+ * (C) 2002 by Harald Welte <laforge@gnumonks.org>
+ *
+ * This software is distributed under GNU GPL v2, 1991
+ * 
+ * ipt_ECN.h,v 1.3 2002/05/29 12:17:40 laforge Exp
+*/
+#ifndef _IPT_ECN_TARGET_H
+#define _IPT_ECN_TARGET_H
 
-#include <linux/netfilter/xt_ecn.h>
-#define ipt_ecn_info xt_ecn_info
+#include <linux/types.h>
+#include <linux/netfilter/xt_DSCP.h>
 
-enum {
-	IPT_ECN_IP_MASK       = XT_ECN_IP_MASK,
-	IPT_ECN_OP_MATCH_IP   = XT_ECN_OP_MATCH_IP,
-	IPT_ECN_OP_MATCH_ECE  = XT_ECN_OP_MATCH_ECE,
-	IPT_ECN_OP_MATCH_CWR  = XT_ECN_OP_MATCH_CWR,
-	IPT_ECN_OP_MATCH_MASK = XT_ECN_OP_MATCH_MASK,
+#define IPT_ECN_IP_MASK	(~XT_DSCP_MASK)
+
+#define IPT_ECN_OP_SET_IP	0x01	/* set ECN bits of IPv4 header */
+#define IPT_ECN_OP_SET_ECE	0x10	/* set ECE bit of TCP header */
+#define IPT_ECN_OP_SET_CWR	0x20	/* set CWR bit of TCP header */
+
+#define IPT_ECN_OP_MASK		0xce
+
+struct ipt_ECN_info {
+	__u8 operation;	/* bitset of operations */
+	__u8 ip_ect;	/* ECT codepoint of IPv4 header, pre-shifted */
+	union {
+		struct {
+			__u8 ece:1, cwr:1; /* TCP ECT bits */
+		} tcp;
+	} proto;
 };
 
-#endif /* IPT_ECN_H */
+#endif /* _IPT_ECN_TARGET_H */
diff --git a/include/uapi/linux/netfilter_ipv4/ipt_ttl.h b/include/uapi/linux/netfilter_ipv4/ipt_ttl.h
index ad0226a86..57d2fc67a 100644
--- a/include/uapi/linux/netfilter_ipv4/ipt_ttl.h
+++ b/include/uapi/linux/netfilter_ipv4/ipt_ttl.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
-/* IP tables module for matching the value of the TTL
- * (C) 2000 by Harald Welte <laforge@gnumonks.org> */
+/* TTL modification module for IP tables
+ * (C) 2000 by Harald Welte <laforge@netfilter.org> */
 
 #ifndef _IPT_TTL_H
 #define _IPT_TTL_H
@@ -8,14 +8,14 @@
 #include <linux/types.h>
 
 enum {
-	IPT_TTL_EQ = 0,		/* equals */
-	IPT_TTL_NE,		/* not equals */
-	IPT_TTL_LT,		/* less than */
-	IPT_TTL_GT,		/* greater than */
+	IPT_TTL_SET = 0,
+	IPT_TTL_INC,
+	IPT_TTL_DEC
 };
 
+#define IPT_TTL_MAXMODE	IPT_TTL_DEC
 
-struct ipt_ttl_info {
+struct ipt_TTL_info {
 	__u8	mode;
 	__u8	ttl;
 };
diff --git a/include/uapi/linux/netfilter_ipv6/ip6t_hl.h b/include/uapi/linux/netfilter_ipv6/ip6t_hl.h
index 6b62f9418..eaed56a28 100644
--- a/include/uapi/linux/netfilter_ipv6/ip6t_hl.h
+++ b/include/uapi/linux/netfilter_ipv6/ip6t_hl.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
-/* ip6tables module for matching the Hop Limit value
+/* Hop Limit modification module for ip6tables
  * Maciej Soltysiak <solt@dns.toxicfilms.tv>
- * Based on HW's ttl module */
+ * Based on HW's TTL module */
 
 #ifndef _IP6T_HL_H
 #define _IP6T_HL_H
@@ -9,14 +9,14 @@
 #include <linux/types.h>
 
 enum {
-	IP6T_HL_EQ = 0,		/* equals */
-	IP6T_HL_NE,		/* not equals */
-	IP6T_HL_LT,		/* less than */
-	IP6T_HL_GT,		/* greater than */
+	IP6T_HL_SET = 0,
+	IP6T_HL_INC,
+	IP6T_HL_DEC
 };
 
+#define IP6T_HL_MAXMODE	IP6T_HL_DEC
 
-struct ip6t_hl_info {
+struct ip6t_HL_info {
 	__u8	mode;
 	__u8	hop_limit;
 };
diff --git a/net/netfilter/xt_dscp.c b/net/netfilter/xt_dscp.c
index fb0169a8f..cfa44515a 100644
--- a/net/netfilter/xt_dscp.c
+++ b/net/netfilter/xt_dscp.c
@@ -1,8 +1,11 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/* IP tables module for matching the value of the IPv4/IPv6 DSCP field
+/* x_tables module for setting the IPv4/IPv6 DSCP field, Version 1.8
  *
  * (C) 2002 by Harald Welte <laforge@netfilter.org>
- */
+ * based on ipt_FTOS.c (C) 2000 by Matthew G. Marsh <mgm@paktronix.com>
+ *
+ * See RFC2474 for a description of the DSCP field within the IP Header.
+*/
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #include <linux/module.h>
 #include <linux/skbuff.h>
@@ -11,100 +14,148 @@
 #include <net/dsfield.h>
 
 #include <linux/netfilter/x_tables.h>
-#include <linux/netfilter/xt_dscp.h>
+#include <linux/netfilter/xt_DSCP.h>
 
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
-MODULE_DESCRIPTION("Xtables: DSCP/TOS field match");
+MODULE_DESCRIPTION("Xtables: DSCP/TOS field modification");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS("ipt_dscp");
-MODULE_ALIAS("ip6t_dscp");
-MODULE_ALIAS("ipt_tos");
-MODULE_ALIAS("ip6t_tos");
+MODULE_ALIAS("ipt_DSCP");
+MODULE_ALIAS("ip6t_DSCP");
+MODULE_ALIAS("ipt_TOS");
+MODULE_ALIAS("ip6t_TOS");
+
+#define XT_DSCP_ECN_MASK	3u
 
-static bool
-dscp_mt(const struct sk_buff *skb, struct xt_action_param *par)
+static unsigned int
+dscp_tg(struct sk_buff *skb, const struct xt_action_param *par)
 {
-	const struct xt_dscp_info *info = par->matchinfo;
+	const struct xt_DSCP_info *dinfo = par->targinfo;
 	u_int8_t dscp = ipv4_get_dsfield(ip_hdr(skb)) >> XT_DSCP_SHIFT;
 
-	return (dscp == info->dscp) ^ !!info->invert;
+	if (dscp != dinfo->dscp) {
+		if (skb_ensure_writable(skb, sizeof(struct iphdr)))
+			return NF_DROP;
+
+		ipv4_change_dsfield(ip_hdr(skb), XT_DSCP_ECN_MASK,
+				    dinfo->dscp << XT_DSCP_SHIFT);
+
+	}
+	return XT_CONTINUE;
 }
 
-static bool
-dscp_mt6(const struct sk_buff *skb, struct xt_action_param *par)
+static unsigned int
+dscp_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 {
-	const struct xt_dscp_info *info = par->matchinfo;
+	const struct xt_DSCP_info *dinfo = par->targinfo;
 	u_int8_t dscp = ipv6_get_dsfield(ipv6_hdr(skb)) >> XT_DSCP_SHIFT;
 
-	return (dscp == info->dscp) ^ !!info->invert;
+	if (dscp != dinfo->dscp) {
+		if (skb_ensure_writable(skb, sizeof(struct ipv6hdr)))
+			return NF_DROP;
+
+		ipv6_change_dsfield(ipv6_hdr(skb), XT_DSCP_ECN_MASK,
+				    dinfo->dscp << XT_DSCP_SHIFT);
+	}
+	return XT_CONTINUE;
 }
 
-static int dscp_mt_check(const struct xt_mtchk_param *par)
+static int dscp_tg_check(const struct xt_tgchk_param *par)
 {
-	const struct xt_dscp_info *info = par->matchinfo;
+	const struct xt_DSCP_info *info = par->targinfo;
 
 	if (info->dscp > XT_DSCP_MAX)
 		return -EDOM;
-
 	return 0;
 }
 
-static bool tos_mt(const struct sk_buff *skb, struct xt_action_param *par)
+static unsigned int
+tos_tg(struct sk_buff *skb, const struct xt_action_param *par)
 {
-	const struct xt_tos_match_info *info = par->matchinfo;
-
-	if (xt_family(par) == NFPROTO_IPV4)
-		return ((ip_hdr(skb)->tos & info->tos_mask) ==
-		       info->tos_value) ^ !!info->invert;
-	else
-		return ((ipv6_get_dsfield(ipv6_hdr(skb)) & info->tos_mask) ==
-		       info->tos_value) ^ !!info->invert;
+	const struct xt_tos_target_info *info = par->targinfo;
+	struct iphdr *iph = ip_hdr(skb);
+	u_int8_t orig, nv;
+
+	orig = ipv4_get_dsfield(iph);
+	nv   = (orig & ~info->tos_mask) ^ info->tos_value;
+
+	if (orig != nv) {
+		if (skb_ensure_writable(skb, sizeof(struct iphdr)))
+			return NF_DROP;
+		iph = ip_hdr(skb);
+		ipv4_change_dsfield(iph, 0, nv);
+	}
+
+	return XT_CONTINUE;
+}
+
+static unsigned int
+tos_tg6(struct sk_buff *skb, const struct xt_action_param *par)
+{
+	const struct xt_tos_target_info *info = par->targinfo;
+	struct ipv6hdr *iph = ipv6_hdr(skb);
+	u_int8_t orig, nv;
+
+	orig = ipv6_get_dsfield(iph);
+	nv   = (orig & ~info->tos_mask) ^ info->tos_value;
+
+	if (orig != nv) {
+		if (skb_ensure_writable(skb, sizeof(struct iphdr)))
+			return NF_DROP;
+		iph = ipv6_hdr(skb);
+		ipv6_change_dsfield(iph, 0, nv);
+	}
+
+	return XT_CONTINUE;
 }
 
-static struct xt_match dscp_mt_reg[] __read_mostly = {
+static struct xt_target dscp_tg_reg[] __read_mostly = {
 	{
-		.name		= "dscp",
+		.name		= "DSCP",
 		.family		= NFPROTO_IPV4,
-		.checkentry	= dscp_mt_check,
-		.match		= dscp_mt,
-		.matchsize	= sizeof(struct xt_dscp_info),
+		.checkentry	= dscp_tg_check,
+		.target		= dscp_tg,
+		.targetsize	= sizeof(struct xt_DSCP_info),
+		.table		= "mangle",
 		.me		= THIS_MODULE,
 	},
 	{
-		.name		= "dscp",
+		.name		= "DSCP",
 		.family		= NFPROTO_IPV6,
-		.checkentry	= dscp_mt_check,
-		.match		= dscp_mt6,
-		.matchsize	= sizeof(struct xt_dscp_info),
+		.checkentry	= dscp_tg_check,
+		.target		= dscp_tg6,
+		.targetsize	= sizeof(struct xt_DSCP_info),
+		.table		= "mangle",
 		.me		= THIS_MODULE,
 	},
 	{
-		.name		= "tos",
+		.name		= "TOS",
 		.revision	= 1,
 		.family		= NFPROTO_IPV4,
-		.match		= tos_mt,
-		.matchsize	= sizeof(struct xt_tos_match_info),
+		.table		= "mangle",
+		.target		= tos_tg,
+		.targetsize	= sizeof(struct xt_tos_target_info),
 		.me		= THIS_MODULE,
 	},
 	{
-		.name		= "tos",
+		.name		= "TOS",
 		.revision	= 1,
 		.family		= NFPROTO_IPV6,
-		.match		= tos_mt,
-		.matchsize	= sizeof(struct xt_tos_match_info),
+		.table		= "mangle",
+		.target		= tos_tg6,
+		.targetsize	= sizeof(struct xt_tos_target_info),
 		.me		= THIS_MODULE,
 	},
 };
 
-static int __init dscp_mt_init(void)
+static int __init dscp_tg_init(void)
 {
-	return xt_register_matches(dscp_mt_reg, ARRAY_SIZE(dscp_mt_reg));
+	return xt_register_targets(dscp_tg_reg, ARRAY_SIZE(dscp_tg_reg));
 }
 
-static void __exit dscp_mt_exit(void)
+static void __exit dscp_tg_exit(void)
 {
-	xt_unregister_matches(dscp_mt_reg, ARRAY_SIZE(dscp_mt_reg));
+	xt_unregister_targets(dscp_tg_reg, ARRAY_SIZE(dscp_tg_reg));
 }
 
-module_init(dscp_mt_init);
-module_exit(dscp_mt_exit);
+module_init(dscp_tg_init);
+module_exit(dscp_tg_exit);
diff --git a/net/netfilter/xt_hl.c b/net/netfilter/xt_hl.c
index c1a70f8f0..7873b834c 100644
--- a/net/netfilter/xt_hl.c
+++ b/net/netfilter/xt_hl.c
@@ -1,93 +1,159 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * IP tables module for matching the value of the TTL
- * (C) 2000,2001 by Harald Welte <laforge@netfilter.org>
+ * TTL modification target for IP tables
+ * (C) 2000,2005 by Harald Welte <laforge@netfilter.org>
  *
- * Hop Limit matching module
- * (C) 2001-2002 Maciej Soltysiak <solt@dns.toxicfilms.tv>
+ * Hop Limit modification target for ip6tables
+ * Maciej Soltysiak <solt@dns.toxicfilms.tv>
  */
-
-#include <linux/ip.h>
-#include <linux/ipv6.h>
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #include <linux/module.h>
 #include <linux/skbuff.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <net/checksum.h>
 
 #include <linux/netfilter/x_tables.h>
-#include <linux/netfilter_ipv4/ipt_ttl.h>
-#include <linux/netfilter_ipv6/ip6t_hl.h>
+#include <linux/netfilter_ipv4/ipt_TTL.h>
+#include <linux/netfilter_ipv6/ip6t_HL.h>
 
+MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
 MODULE_AUTHOR("Maciej Soltysiak <solt@dns.toxicfilms.tv>");
-MODULE_DESCRIPTION("Xtables: Hoplimit/TTL field match");
+MODULE_DESCRIPTION("Xtables: Hoplimit/TTL Limit field modification target");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS("ipt_ttl");
-MODULE_ALIAS("ip6t_hl");
 
-static bool ttl_mt(const struct sk_buff *skb, struct xt_action_param *par)
+static unsigned int
+ttl_tg(struct sk_buff *skb, const struct xt_action_param *par)
 {
-	const struct ipt_ttl_info *info = par->matchinfo;
-	const u8 ttl = ip_hdr(skb)->ttl;
+	struct iphdr *iph;
+	const struct ipt_TTL_info *info = par->targinfo;
+	int new_ttl;
+
+	if (skb_ensure_writable(skb, sizeof(*iph)))
+		return NF_DROP;
+
+	iph = ip_hdr(skb);
 
 	switch (info->mode) {
-	case IPT_TTL_EQ:
-		return ttl == info->ttl;
-	case IPT_TTL_NE:
-		return ttl != info->ttl;
-	case IPT_TTL_LT:
-		return ttl < info->ttl;
-	case IPT_TTL_GT:
-		return ttl > info->ttl;
+	case IPT_TTL_SET:
+		new_ttl = info->ttl;
+		break;
+	case IPT_TTL_INC:
+		new_ttl = iph->ttl + info->ttl;
+		if (new_ttl > 255)
+			new_ttl = 255;
+		break;
+	case IPT_TTL_DEC:
+		new_ttl = iph->ttl - info->ttl;
+		if (new_ttl < 0)
+			new_ttl = 0;
+		break;
+	default:
+		new_ttl = iph->ttl;
+		break;
 	}
 
-	return false;
+	if (new_ttl != iph->ttl) {
+		csum_replace2(&iph->check, htons(iph->ttl << 8),
+					   htons(new_ttl << 8));
+		iph->ttl = new_ttl;
+	}
+
+	return XT_CONTINUE;
 }
 
-static bool hl_mt6(const struct sk_buff *skb, struct xt_action_param *par)
+static unsigned int
+hl_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 {
-	const struct ip6t_hl_info *info = par->matchinfo;
-	const struct ipv6hdr *ip6h = ipv6_hdr(skb);
+	struct ipv6hdr *ip6h;
+	const struct ip6t_HL_info *info = par->targinfo;
+	int new_hl;
+
+	if (skb_ensure_writable(skb, sizeof(*ip6h)))
+		return NF_DROP;
+
+	ip6h = ipv6_hdr(skb);
 
 	switch (info->mode) {
-	case IP6T_HL_EQ:
-		return ip6h->hop_limit == info->hop_limit;
-	case IP6T_HL_NE:
-		return ip6h->hop_limit != info->hop_limit;
-	case IP6T_HL_LT:
-		return ip6h->hop_limit < info->hop_limit;
-	case IP6T_HL_GT:
-		return ip6h->hop_limit > info->hop_limit;
+	case IP6T_HL_SET:
+		new_hl = info->hop_limit;
+		break;
+	case IP6T_HL_INC:
+		new_hl = ip6h->hop_limit + info->hop_limit;
+		if (new_hl > 255)
+			new_hl = 255;
+		break;
+	case IP6T_HL_DEC:
+		new_hl = ip6h->hop_limit - info->hop_limit;
+		if (new_hl < 0)
+			new_hl = 0;
+		break;
+	default:
+		new_hl = ip6h->hop_limit;
+		break;
 	}
 
-	return false;
+	ip6h->hop_limit = new_hl;
+
+	return XT_CONTINUE;
+}
+
+static int ttl_tg_check(const struct xt_tgchk_param *par)
+{
+	const struct ipt_TTL_info *info = par->targinfo;
+
+	if (info->mode > IPT_TTL_MAXMODE)
+		return -EINVAL;
+	if (info->mode != IPT_TTL_SET && info->ttl == 0)
+		return -EINVAL;
+	return 0;
+}
+
+static int hl_tg6_check(const struct xt_tgchk_param *par)
+{
+	const struct ip6t_HL_info *info = par->targinfo;
+
+	if (info->mode > IP6T_HL_MAXMODE)
+		return -EINVAL;
+	if (info->mode != IP6T_HL_SET && info->hop_limit == 0)
+		return -EINVAL;
+	return 0;
 }
 
-static struct xt_match hl_mt_reg[] __read_mostly = {
+static struct xt_target hl_tg_reg[] __read_mostly = {
 	{
-		.name       = "ttl",
+		.name       = "TTL",
 		.revision   = 0,
 		.family     = NFPROTO_IPV4,
-		.match      = ttl_mt,
-		.matchsize  = sizeof(struct ipt_ttl_info),
+		.target     = ttl_tg,
+		.targetsize = sizeof(struct ipt_TTL_info),
+		.table      = "mangle",
+		.checkentry = ttl_tg_check,
 		.me         = THIS_MODULE,
 	},
 	{
-		.name       = "hl",
+		.name       = "HL",
 		.revision   = 0,
 		.family     = NFPROTO_IPV6,
-		.match      = hl_mt6,
-		.matchsize  = sizeof(struct ip6t_hl_info),
+		.target     = hl_tg6,
+		.targetsize = sizeof(struct ip6t_HL_info),
+		.table      = "mangle",
+		.checkentry = hl_tg6_check,
 		.me         = THIS_MODULE,
 	},
 };
 
-static int __init hl_mt_init(void)
+static int __init hl_tg_init(void)
 {
-	return xt_register_matches(hl_mt_reg, ARRAY_SIZE(hl_mt_reg));
+	return xt_register_targets(hl_tg_reg, ARRAY_SIZE(hl_tg_reg));
 }
 
-static void __exit hl_mt_exit(void)
+static void __exit hl_tg_exit(void)
 {
-	xt_unregister_matches(hl_mt_reg, ARRAY_SIZE(hl_mt_reg));
+	xt_unregister_targets(hl_tg_reg, ARRAY_SIZE(hl_tg_reg));
 }
 
-module_init(hl_mt_init);
-module_exit(hl_mt_exit);
+module_init(hl_tg_init);
+module_exit(hl_tg_exit);
+MODULE_ALIAS("ipt_TTL");
+MODULE_ALIAS("ip6t_HL");
diff --git a/net/netfilter/xt_rateest.c b/net/netfilter/xt_rateest.c
index 72324bd97..80f6624e2 100644
--- a/net/netfilter/xt_rateest.c
+++ b/net/netfilter/xt_rateest.c
@@ -5,149 +5,229 @@
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/gen_stats.h>
+#include <linux/jhash.h>
+#include <linux/rtnetlink.h>
+#include <linux/random.h>
+#include <linux/slab.h>
+#include <net/gen_stats.h>
+#include <net/netlink.h>
+#include <net/netns/generic.h>
 
 #include <linux/netfilter/x_tables.h>
-#include <linux/netfilter/xt_rateest.h>
+#include <linux/netfilter/xt_RATEEST.h>
 #include <net/netfilter/xt_rateest.h>
 
+#define RATEEST_HSIZE	16
 
-static bool
-xt_rateest_mt(const struct sk_buff *skb, struct xt_action_param *par)
+struct xt_rateest_net {
+	struct mutex hash_lock;
+	struct hlist_head hash[RATEEST_HSIZE];
+};
+
+static unsigned int xt_rateest_id;
+
+static unsigned int jhash_rnd __read_mostly;
+
+static unsigned int xt_rateest_hash(const char *name)
 {
-	const struct xt_rateest_match_info *info = par->matchinfo;
-	struct gnet_stats_rate_est64 sample = {0};
-	u_int32_t bps1, bps2, pps1, pps2;
-	bool ret = true;
-
-	gen_estimator_read(&info->est1->rate_est, &sample);
-
-	if (info->flags & XT_RATEEST_MATCH_DELTA) {
-		bps1 = info->bps1 >= sample.bps ? info->bps1 - sample.bps : 0;
-		pps1 = info->pps1 >= sample.pps ? info->pps1 - sample.pps : 0;
-	} else {
-		bps1 = sample.bps;
-		pps1 = sample.pps;
-	}
+	return jhash(name, sizeof_field(struct xt_rateest, name), jhash_rnd) &
+	       (RATEEST_HSIZE - 1);
+}
+
+static void xt_rateest_hash_insert(struct xt_rateest_net *xn,
+				   struct xt_rateest *est)
+{
+	unsigned int h;
+
+	h = xt_rateest_hash(est->name);
+	hlist_add_head(&est->list, &xn->hash[h]);
+}
 
-	if (info->flags & XT_RATEEST_MATCH_ABS) {
-		bps2 = info->bps2;
-		pps2 = info->pps2;
-	} else {
-		gen_estimator_read(&info->est2->rate_est, &sample);
-
-		if (info->flags & XT_RATEEST_MATCH_DELTA) {
-			bps2 = info->bps2 >= sample.bps ? info->bps2 - sample.bps : 0;
-			pps2 = info->pps2 >= sample.pps ? info->pps2 - sample.pps : 0;
-		} else {
-			bps2 = sample.bps;
-			pps2 = sample.pps;
+static struct xt_rateest *__xt_rateest_lookup(struct xt_rateest_net *xn,
+					      const char *name)
+{
+	struct xt_rateest *est;
+	unsigned int h;
+
+	h = xt_rateest_hash(name);
+	hlist_for_each_entry(est, &xn->hash[h], list) {
+		if (strcmp(est->name, name) == 0) {
+			est->refcnt++;
+			return est;
 		}
 	}
 
-	switch (info->mode) {
-	case XT_RATEEST_MATCH_LT:
-		if (info->flags & XT_RATEEST_MATCH_BPS)
-			ret &= bps1 < bps2;
-		if (info->flags & XT_RATEEST_MATCH_PPS)
-			ret &= pps1 < pps2;
-		break;
-	case XT_RATEEST_MATCH_GT:
-		if (info->flags & XT_RATEEST_MATCH_BPS)
-			ret &= bps1 > bps2;
-		if (info->flags & XT_RATEEST_MATCH_PPS)
-			ret &= pps1 > pps2;
-		break;
-	case XT_RATEEST_MATCH_EQ:
-		if (info->flags & XT_RATEEST_MATCH_BPS)
-			ret &= bps1 == bps2;
-		if (info->flags & XT_RATEEST_MATCH_PPS)
-			ret &= pps1 == pps2;
-		break;
-	}
+	return NULL;
+}
 
-	ret ^= info->flags & XT_RATEEST_MATCH_INVERT ? true : false;
-	return ret;
+struct xt_rateest *xt_rateest_lookup(struct net *net, const char *name)
+{
+	struct xt_rateest_net *xn = net_generic(net, xt_rateest_id);
+	struct xt_rateest *est;
+
+	mutex_lock(&xn->hash_lock);
+	est = __xt_rateest_lookup(xn, name);
+	mutex_unlock(&xn->hash_lock);
+	return est;
 }
+EXPORT_SYMBOL_GPL(xt_rateest_lookup);
 
-static int xt_rateest_mt_checkentry(const struct xt_mtchk_param *par)
+void xt_rateest_put(struct net *net, struct xt_rateest *est)
 {
-	struct xt_rateest_match_info *info = par->matchinfo;
-	struct xt_rateest *est1, *est2;
-	int ret = -EINVAL;
+	struct xt_rateest_net *xn = net_generic(net, xt_rateest_id);
+
+	mutex_lock(&xn->hash_lock);
+	if (--est->refcnt == 0) {
+		hlist_del(&est->list);
+		gen_kill_estimator(&est->rate_est);
+		/*
+		 * gen_estimator est_timer() might access est->lock or bstats,
+		 * wait a RCU grace period before freeing 'est'
+		 */
+		kfree_rcu(est, rcu);
+	}
+	mutex_unlock(&xn->hash_lock);
+}
+EXPORT_SYMBOL_GPL(xt_rateest_put);
 
-	if (hweight32(info->flags & (XT_RATEEST_MATCH_ABS |
-				     XT_RATEEST_MATCH_REL)) != 1)
-		goto err1;
+static unsigned int
+xt_rateest_tg(struct sk_buff *skb, const struct xt_action_param *par)
+{
+	const struct xt_rateest_target_info *info = par->targinfo;
+	struct gnet_stats_basic_sync *stats = &info->est->bstats;
 
-	if (!(info->flags & (XT_RATEEST_MATCH_BPS | XT_RATEEST_MATCH_PPS)))
-		goto err1;
+	spin_lock_bh(&info->est->lock);
+	u64_stats_add(&stats->bytes, skb->len);
+	u64_stats_inc(&stats->packets);
+	spin_unlock_bh(&info->est->lock);
 
-	switch (info->mode) {
-	case XT_RATEEST_MATCH_EQ:
-	case XT_RATEEST_MATCH_LT:
-	case XT_RATEEST_MATCH_GT:
-		break;
-	default:
-		goto err1;
+	return XT_CONTINUE;
+}
+
+static int xt_rateest_tg_checkentry(const struct xt_tgchk_param *par)
+{
+	struct xt_rateest_net *xn = net_generic(par->net, xt_rateest_id);
+	struct xt_rateest_target_info *info = par->targinfo;
+	struct xt_rateest *est;
+	struct {
+		struct nlattr		opt;
+		struct gnet_estimator	est;
+	} cfg;
+	int ret;
+
+	if (strnlen(info->name, sizeof(est->name)) >= sizeof(est->name))
+		return -ENAMETOOLONG;
+
+	net_get_random_once(&jhash_rnd, sizeof(jhash_rnd));
+
+	mutex_lock(&xn->hash_lock);
+	est = __xt_rateest_lookup(xn, info->name);
+	if (est) {
+		mutex_unlock(&xn->hash_lock);
+		/*
+		 * If estimator parameters are specified, they must match the
+		 * existing estimator.
+		 */
+		if ((!info->interval && !info->ewma_log) ||
+		    (info->interval != est->params.interval ||
+		     info->ewma_log != est->params.ewma_log)) {
+			xt_rateest_put(par->net, est);
+			return -EINVAL;
+		}
+		info->est = est;
+		return 0;
 	}
 
-	ret  = -ENOENT;
-	est1 = xt_rateest_lookup(par->net, info->name1);
-	if (!est1)
+	ret = -ENOMEM;
+	est = kzalloc(sizeof(*est), GFP_KERNEL);
+	if (!est)
 		goto err1;
 
-	est2 = NULL;
-	if (info->flags & XT_RATEEST_MATCH_REL) {
-		est2 = xt_rateest_lookup(par->net, info->name2);
-		if (!est2)
-			goto err2;
-	}
-
-	info->est1 = est1;
-	info->est2 = est2;
+	gnet_stats_basic_sync_init(&est->bstats);
+	strscpy(est->name, info->name, sizeof(est->name));
+	spin_lock_init(&est->lock);
+	est->refcnt		= 1;
+	est->params.interval	= info->interval;
+	est->params.ewma_log	= info->ewma_log;
+
+	cfg.opt.nla_len		= nla_attr_size(sizeof(cfg.est));
+	cfg.opt.nla_type	= TCA_STATS_RATE_EST;
+	cfg.est.interval	= info->interval;
+	cfg.est.ewma_log	= info->ewma_log;
+
+	ret = gen_new_estimator(&est->bstats, NULL, &est->rate_est,
+				&est->lock, NULL, &cfg.opt);
+	if (ret < 0)
+		goto err2;
+
+	info->est = est;
+	xt_rateest_hash_insert(xn, est);
+	mutex_unlock(&xn->hash_lock);
 	return 0;
 
 err2:
-	xt_rateest_put(par->net, est1);
+	kfree(est);
 err1:
+	mutex_unlock(&xn->hash_lock);
 	return ret;
 }
 
-static void xt_rateest_mt_destroy(const struct xt_mtdtor_param *par)
+static void xt_rateest_tg_destroy(const struct xt_tgdtor_param *par)
 {
-	struct xt_rateest_match_info *info = par->matchinfo;
+	struct xt_rateest_target_info *info = par->targinfo;
 
-	xt_rateest_put(par->net, info->est1);
-	if (info->est2)
-		xt_rateest_put(par->net, info->est2);
+	xt_rateest_put(par->net, info->est);
 }
 
-static struct xt_match xt_rateest_mt_reg __read_mostly = {
-	.name       = "rateest",
+static struct xt_target xt_rateest_tg_reg __read_mostly = {
+	.name       = "RATEEST",
 	.revision   = 0,
 	.family     = NFPROTO_UNSPEC,
-	.match      = xt_rateest_mt,
-	.checkentry = xt_rateest_mt_checkentry,
-	.destroy    = xt_rateest_mt_destroy,
-	.matchsize  = sizeof(struct xt_rateest_match_info),
-	.usersize   = offsetof(struct xt_rateest_match_info, est1),
+	.target     = xt_rateest_tg,
+	.checkentry = xt_rateest_tg_checkentry,
+	.destroy    = xt_rateest_tg_destroy,
+	.targetsize = sizeof(struct xt_rateest_target_info),
+	.usersize   = offsetof(struct xt_rateest_target_info, est),
 	.me         = THIS_MODULE,
 };
 
-static int __init xt_rateest_mt_init(void)
+static __net_init int xt_rateest_net_init(struct net *net)
 {
-	return xt_register_match(&xt_rateest_mt_reg);
+	struct xt_rateest_net *xn = net_generic(net, xt_rateest_id);
+	int i;
+
+	mutex_init(&xn->hash_lock);
+	for (i = 0; i < ARRAY_SIZE(xn->hash); i++)
+		INIT_HLIST_HEAD(&xn->hash[i]);
+	return 0;
 }
 
-static void __exit xt_rateest_mt_fini(void)
+static struct pernet_operations xt_rateest_net_ops = {
+	.init = xt_rateest_net_init,
+	.id   = &xt_rateest_id,
+	.size = sizeof(struct xt_rateest_net),
+};
+
+static int __init xt_rateest_tg_init(void)
 {
-	xt_unregister_match(&xt_rateest_mt_reg);
+	int err = register_pernet_subsys(&xt_rateest_net_ops);
+
+	if (err)
+		return err;
+	return xt_register_target(&xt_rateest_tg_reg);
 }
 
+static void __exit xt_rateest_tg_fini(void)
+{
+	xt_unregister_target(&xt_rateest_tg_reg);
+	unregister_pernet_subsys(&xt_rateest_net_ops);
+}
+
+
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
 MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("xtables rate estimator match");
-MODULE_ALIAS("ipt_rateest");
-MODULE_ALIAS("ip6t_rateest");
-module_init(xt_rateest_mt_init);
-module_exit(xt_rateest_mt_fini);
+MODULE_DESCRIPTION("Xtables: packet rate estimator");
+MODULE_ALIAS("ipt_RATEEST");
+MODULE_ALIAS("ip6t_RATEEST");
+module_init(xt_rateest_tg_init);
+module_exit(xt_rateest_tg_fini);
diff --git a/net/netfilter/xt_tcpmss.c b/net/netfilter/xt_tcpmss.c
index 37704ab01..116a885ad 100644
--- a/net/netfilter/xt_tcpmss.c
+++ b/net/netfilter/xt_tcpmss.c
@@ -1,107 +1,345 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/* Kernel module to match TCP MSS values. */
-
-/* Copyright (C) 2000 Marc Boucher <marc@mbsi.ca>
- * Portions (C) 2005 by Harald Welte <laforge@netfilter.org>
+/*
+ * This is a module which is used for setting the MSS option in TCP packets.
+ *
+ * Copyright (C) 2000 Marc Boucher <marc@mbsi.ca>
+ * Copyright (C) 2007 Patrick McHardy <kaber@trash.net>
  */
-
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #include <linux/module.h>
 #include <linux/skbuff.h>
+#include <linux/ip.h>
+#include <linux/gfp.h>
+#include <linux/ipv6.h>
+#include <linux/tcp.h>
+#include <net/dst.h>
+#include <net/flow.h>
+#include <net/ipv6.h>
+#include <net/route.h>
 #include <net/tcp.h>
 
-#include <linux/netfilter/xt_tcpmss.h>
-#include <linux/netfilter/x_tables.h>
-
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_tcpudp.h>
+#include <linux/netfilter/xt_TCPMSS.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Marc Boucher <marc@mbsi.ca>");
-MODULE_DESCRIPTION("Xtables: TCP MSS match");
-MODULE_ALIAS("ipt_tcpmss");
-MODULE_ALIAS("ip6t_tcpmss");
+MODULE_DESCRIPTION("Xtables: TCP Maximum Segment Size (MSS) adjustment");
+MODULE_ALIAS("ipt_TCPMSS");
+MODULE_ALIAS("ip6t_TCPMSS");
 
-static bool
-tcpmss_mt(const struct sk_buff *skb, struct xt_action_param *par)
+static inline unsigned int
+optlen(const u_int8_t *opt, unsigned int offset)
 {
-	const struct xt_tcpmss_match_info *info = par->matchinfo;
-	const struct tcphdr *th;
-	struct tcphdr _tcph;
-	/* tcp.doff is only 4 bits, ie. max 15 * 4 bytes */
-	const u_int8_t *op;
-	u8 _opt[15 * 4 - sizeof(_tcph)];
-	unsigned int i, optlen;
-
-	/* If we don't have the whole header, drop packet. */
-	th = skb_header_pointer(skb, par->thoff, sizeof(_tcph), &_tcph);
-	if (th == NULL)
-		goto dropit;
-
-	/* Malformed. */
-	if (th->doff*4 < sizeof(*th))
-		goto dropit;
-
-	optlen = th->doff*4 - sizeof(*th);
-	if (!optlen)
-		goto out;
-
-	/* Truncated options. */
-	op = skb_header_pointer(skb, par->thoff + sizeof(*th), optlen, _opt);
-	if (op == NULL)
-		goto dropit;
-
-	for (i = 0; i < optlen; ) {
-		if (op[i] == TCPOPT_MSS
-		    && (optlen - i) >= TCPOLEN_MSS
-		    && op[i+1] == TCPOLEN_MSS) {
-			u_int16_t mssval;
-
-			mssval = (op[i+2] << 8) | op[i+3];
-
-			return (mssval >= info->mss_min &&
-				mssval <= info->mss_max) ^ info->invert;
+	/* Beware zero-length options: make finite progress */
+	if (opt[offset] <= TCPOPT_NOP || opt[offset+1] == 0)
+		return 1;
+	else
+		return opt[offset+1];
+}
+
+static u_int32_t tcpmss_reverse_mtu(struct net *net,
+				    const struct sk_buff *skb,
+				    unsigned int family)
+{
+	struct flowi fl;
+	struct rtable *rt = NULL;
+	u_int32_t mtu     = ~0U;
+
+	if (family == PF_INET) {
+		struct flowi4 *fl4 = &fl.u.ip4;
+		memset(fl4, 0, sizeof(*fl4));
+		fl4->daddr = ip_hdr(skb)->saddr;
+	} else {
+		struct flowi6 *fl6 = &fl.u.ip6;
+
+		memset(fl6, 0, sizeof(*fl6));
+		fl6->daddr = ipv6_hdr(skb)->saddr;
+	}
+
+	nf_route(net, (struct dst_entry **)&rt, &fl, false, family);
+	if (rt != NULL) {
+		mtu = dst_mtu(&rt->dst);
+		dst_release(&rt->dst);
+	}
+	return mtu;
+}
+
+static int
+tcpmss_mangle_packet(struct sk_buff *skb,
+		     const struct xt_action_param *par,
+		     unsigned int family,
+		     unsigned int tcphoff,
+		     unsigned int minlen)
+{
+	const struct xt_tcpmss_info *info = par->targinfo;
+	struct tcphdr *tcph;
+	int len, tcp_hdrlen;
+	unsigned int i;
+	__be16 oldval;
+	u16 newmss;
+	u8 *opt;
+
+	/* This is a fragment, no TCP header is available */
+	if (par->fragoff != 0)
+		return 0;
+
+	if (skb_ensure_writable(skb, skb->len))
+		return -1;
+
+	len = skb->len - tcphoff;
+	if (len < (int)sizeof(struct tcphdr))
+		return -1;
+
+	tcph = (struct tcphdr *)(skb_network_header(skb) + tcphoff);
+	tcp_hdrlen = tcph->doff * 4;
+
+	if (len < tcp_hdrlen || tcp_hdrlen < sizeof(struct tcphdr))
+		return -1;
+
+	if (info->mss == XT_TCPMSS_CLAMP_PMTU) {
+		struct net *net = xt_net(par);
+		unsigned int in_mtu = tcpmss_reverse_mtu(net, skb, family);
+		unsigned int min_mtu = min(dst_mtu(skb_dst(skb)), in_mtu);
+
+		if (min_mtu <= minlen) {
+			net_err_ratelimited("unknown or invalid path-MTU (%u)\n",
+					    min_mtu);
+			return -1;
+		}
+		newmss = min_mtu - minlen;
+	} else
+		newmss = info->mss;
+
+	opt = (u_int8_t *)tcph;
+	for (i = sizeof(struct tcphdr); i <= tcp_hdrlen - TCPOLEN_MSS; i += optlen(opt, i)) {
+		if (opt[i] == TCPOPT_MSS && opt[i+1] == TCPOLEN_MSS) {
+			u_int16_t oldmss;
+
+			oldmss = (opt[i+2] << 8) | opt[i+3];
+
+			/* Never increase MSS, even when setting it, as
+			 * doing so results in problems for hosts that rely
+			 * on MSS being set correctly.
+			 */
+			if (oldmss <= newmss)
+				return 0;
+
+			opt[i+2] = (newmss & 0xff00) >> 8;
+			opt[i+3] = newmss & 0x00ff;
+
+			inet_proto_csum_replace2(&tcph->check, skb,
+						 htons(oldmss), htons(newmss),
+						 false);
+			return 0;
 		}
-		if (op[i] < 2)
-			i++;
-		else
-			i += op[i+1] ? : 1;
 	}
-out:
-	return info->invert;
 
-dropit:
-	par->hotdrop = true;
+	/* There is data after the header so the option can't be added
+	 * without moving it, and doing so may make the SYN packet
+	 * itself too large. Accept the packet unmodified instead.
+	 */
+	if (len > tcp_hdrlen)
+		return 0;
+
+	/* tcph->doff has 4 bits, do not wrap it to 0 */
+	if (tcp_hdrlen >= 15 * 4)
+		return 0;
+
+	/*
+	 * MSS Option not found ?! add it..
+	 */
+	if (skb_tailroom(skb) < TCPOLEN_MSS) {
+		if (pskb_expand_head(skb, 0,
+				     TCPOLEN_MSS - skb_tailroom(skb),
+				     GFP_ATOMIC))
+			return -1;
+		tcph = (struct tcphdr *)(skb_network_header(skb) + tcphoff);
+	}
+
+	skb_put(skb, TCPOLEN_MSS);
+
+	/*
+	 * IPv4: RFC 1122 states "If an MSS option is not received at
+	 * connection setup, TCP MUST assume a default send MSS of 536".
+	 * IPv6: RFC 2460 states IPv6 has a minimum MTU of 1280 and a minimum
+	 * length IPv6 header of 60, ergo the default MSS value is 1220
+	 * Since no MSS was provided, we must use the default values
+	 */
+	if (xt_family(par) == NFPROTO_IPV4)
+		newmss = min(newmss, (u16)536);
+	else
+		newmss = min(newmss, (u16)1220);
+
+	opt = (u_int8_t *)tcph + sizeof(struct tcphdr);
+	memmove(opt + TCPOLEN_MSS, opt, len - sizeof(struct tcphdr));
+
+	inet_proto_csum_replace2(&tcph->check, skb,
+				 htons(len), htons(len + TCPOLEN_MSS), true);
+	opt[0] = TCPOPT_MSS;
+	opt[1] = TCPOLEN_MSS;
+	opt[2] = (newmss & 0xff00) >> 8;
+	opt[3] = newmss & 0x00ff;
+
+	inet_proto_csum_replace4(&tcph->check, skb, 0, *((__be32 *)opt), false);
+
+	oldval = ((__be16 *)tcph)[6];
+	tcph->doff += TCPOLEN_MSS/4;
+	inet_proto_csum_replace2(&tcph->check, skb,
+				 oldval, ((__be16 *)tcph)[6], false);
+	return TCPOLEN_MSS;
+}
+
+static unsigned int
+tcpmss_tg4(struct sk_buff *skb, const struct xt_action_param *par)
+{
+	struct iphdr *iph = ip_hdr(skb);
+	__be16 newlen;
+	int ret;
+
+	ret = tcpmss_mangle_packet(skb, par,
+				   PF_INET,
+				   iph->ihl * 4,
+				   sizeof(*iph) + sizeof(struct tcphdr));
+	if (ret < 0)
+		return NF_DROP;
+	if (ret > 0) {
+		iph = ip_hdr(skb);
+		newlen = htons(ntohs(iph->tot_len) + ret);
+		csum_replace2(&iph->check, iph->tot_len, newlen);
+		iph->tot_len = newlen;
+	}
+	return XT_CONTINUE;
+}
+
+#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
+static unsigned int
+tcpmss_tg6(struct sk_buff *skb, const struct xt_action_param *par)
+{
+	struct ipv6hdr *ipv6h = ipv6_hdr(skb);
+	u8 nexthdr;
+	__be16 frag_off, oldlen, newlen;
+	int tcphoff;
+	int ret;
+
+	nexthdr = ipv6h->nexthdr;
+	tcphoff = ipv6_skip_exthdr(skb, sizeof(*ipv6h), &nexthdr, &frag_off);
+	if (tcphoff < 0)
+		return NF_DROP;
+	ret = tcpmss_mangle_packet(skb, par,
+				   PF_INET6,
+				   tcphoff,
+				   sizeof(*ipv6h) + sizeof(struct tcphdr));
+	if (ret < 0)
+		return NF_DROP;
+	if (ret > 0) {
+		ipv6h = ipv6_hdr(skb);
+		oldlen = ipv6h->payload_len;
+		newlen = htons(ntohs(oldlen) + ret);
+		if (skb->ip_summed == CHECKSUM_COMPLETE)
+			skb->csum = csum_add(csum_sub(skb->csum, (__force __wsum)oldlen),
+					     (__force __wsum)newlen);
+		ipv6h->payload_len = newlen;
+	}
+	return XT_CONTINUE;
+}
+#endif
+
+/* Must specify -p tcp --syn */
+static inline bool find_syn_match(const struct xt_entry_match *m)
+{
+	const struct xt_tcp *tcpinfo = (const struct xt_tcp *)m->data;
+
+	if (strcmp(m->u.kernel.match->name, "tcp") == 0 &&
+	    tcpinfo->flg_cmp & TCPHDR_SYN &&
+	    !(tcpinfo->invflags & XT_TCP_INV_FLAGS))
+		return true;
+
 	return false;
 }
 
-static struct xt_match tcpmss_mt_reg[] __read_mostly = {
+static int tcpmss_tg4_check(const struct xt_tgchk_param *par)
+{
+	const struct xt_tcpmss_info *info = par->targinfo;
+	const struct ipt_entry *e = par->entryinfo;
+	const struct xt_entry_match *ematch;
+
+	if (info->mss == XT_TCPMSS_CLAMP_PMTU &&
+	    (par->hook_mask & ~((1 << NF_INET_FORWARD) |
+			   (1 << NF_INET_LOCAL_OUT) |
+			   (1 << NF_INET_POST_ROUTING))) != 0) {
+		pr_info_ratelimited("path-MTU clamping only supported in FORWARD, OUTPUT and POSTROUTING hooks\n");
+		return -EINVAL;
+	}
+	if (par->nft_compat)
+		return 0;
+
+	xt_ematch_foreach(ematch, e)
+		if (find_syn_match(ematch))
+			return 0;
+	pr_info_ratelimited("Only works on TCP SYN packets\n");
+	return -EINVAL;
+}
+
+#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
+static int tcpmss_tg6_check(const struct xt_tgchk_param *par)
+{
+	const struct xt_tcpmss_info *info = par->targinfo;
+	const struct ip6t_entry *e = par->entryinfo;
+	const struct xt_entry_match *ematch;
+
+	if (info->mss == XT_TCPMSS_CLAMP_PMTU &&
+	    (par->hook_mask & ~((1 << NF_INET_FORWARD) |
+			   (1 << NF_INET_LOCAL_OUT) |
+			   (1 << NF_INET_POST_ROUTING))) != 0) {
+		pr_info_ratelimited("path-MTU clamping only supported in FORWARD, OUTPUT and POSTROUTING hooks\n");
+		return -EINVAL;
+	}
+	if (par->nft_compat)
+		return 0;
+
+	xt_ematch_foreach(ematch, e)
+		if (find_syn_match(ematch))
+			return 0;
+	pr_info_ratelimited("Only works on TCP SYN packets\n");
+	return -EINVAL;
+}
+#endif
+
+static struct xt_target tcpmss_tg_reg[] __read_mostly = {
 	{
-		.name		= "tcpmss",
 		.family		= NFPROTO_IPV4,
-		.match		= tcpmss_mt,
-		.matchsize	= sizeof(struct xt_tcpmss_match_info),
+		.name		= "TCPMSS",
+		.checkentry	= tcpmss_tg4_check,
+		.target		= tcpmss_tg4,
+		.targetsize	= sizeof(struct xt_tcpmss_info),
 		.proto		= IPPROTO_TCP,
 		.me		= THIS_MODULE,
 	},
+#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
 	{
-		.name		= "tcpmss",
 		.family		= NFPROTO_IPV6,
-		.match		= tcpmss_mt,
-		.matchsize	= sizeof(struct xt_tcpmss_match_info),
+		.name		= "TCPMSS",
+		.checkentry	= tcpmss_tg6_check,
+		.target		= tcpmss_tg6,
+		.targetsize	= sizeof(struct xt_tcpmss_info),
 		.proto		= IPPROTO_TCP,
 		.me		= THIS_MODULE,
 	},
+#endif
 };
 
-static int __init tcpmss_mt_init(void)
+static int __init tcpmss_tg_init(void)
 {
-	return xt_register_matches(tcpmss_mt_reg, ARRAY_SIZE(tcpmss_mt_reg));
+	return xt_register_targets(tcpmss_tg_reg, ARRAY_SIZE(tcpmss_tg_reg));
 }
 
-static void __exit tcpmss_mt_exit(void)
+static void __exit tcpmss_tg_exit(void)
 {
-	xt_unregister_matches(tcpmss_mt_reg, ARRAY_SIZE(tcpmss_mt_reg));
+	xt_unregister_targets(tcpmss_tg_reg, ARRAY_SIZE(tcpmss_tg_reg));
 }
 
-module_init(tcpmss_mt_init);
-module_exit(tcpmss_mt_exit);
+module_init(tcpmss_tg_init);
+module_exit(tcpmss_tg_exit);
diff --git a/tools/memory-model/litmus-tests/Z6.0+pooncelock+pooncelock+pombonce.litmus b/tools/memory-model/litmus-tests/Z6.0+pooncelock+pooncelock+pombonce.litmus
index 10a2aa04c..415248fb6 100644
--- a/tools/memory-model/litmus-tests/Z6.0+pooncelock+pooncelock+pombonce.litmus
+++ b/tools/memory-model/litmus-tests/Z6.0+pooncelock+pooncelock+pombonce.litmus
@@ -1,11 +1,12 @@
-C Z6.0+pooncelock+pooncelock+pombonce
+C Z6.0+pooncelock+poonceLock+pombonce
 
 (*
- * Result: Sometimes
+ * Result: Never
  *
- * This example demonstrates that a pair of accesses made by different
- * processes each while holding a given lock will not necessarily be
- * seen as ordered by a third process not holding that lock.
+ * This litmus test demonstrates how smp_mb__after_spinlock() may be
+ * used to ensure that accesses in different critical sections for a
+ * given lock running on different CPUs are nevertheless seen in order
+ * by CPUs not holding that lock.
  *)
 
 {}
@@ -23,6 +24,7 @@ P1(int *y, int *z, spinlock_t *mylock)
 	int r0;
 
 	spin_lock(mylock);
+	smp_mb__after_spinlock();
 	r0 = READ_ONCE(*y);
 	WRITE_ONCE(*z, 1);
 	spin_unlock(mylock);
-- 
2.37.3

