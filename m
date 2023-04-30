Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21EDD6F29E9
	for <lists+netdev@lfdr.de>; Sun, 30 Apr 2023 19:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbjD3RS1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Apr 2023 13:18:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231251AbjD3RSR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Apr 2023 13:18:17 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 880A72706;
        Sun, 30 Apr 2023 10:18:15 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id 98e67ed59e1d1-24ba5c1be6dso1196891a91.2;
        Sun, 30 Apr 2023 10:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682875095; x=1685467095;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VUcX1u9Na09LWEG/YlEb5cTfwitTfjn6pv+M2nzybOg=;
        b=pRa6oNNkpLd1dXDPDAdnGEFDyudn68KHFh/2Ibj9peU1jYkYw+KCmHXKxDOQVmi6f7
         bvxqucMU/OlomYLoLnI27rw82VUeME69XiK+3JPmr3/qB/hJKPVCucAKNqR05cZuZ8vF
         gIIsbSCabbgbBgewuGivVkXrv4lbhgaH40GUryUTbNXuZ7QsKcfWah/ce5ut7N/YP0P7
         KKpv4dM+eXR//oWEgz6VUD2nu64ZMZCJTq/BppIvDyn7IbLS0SGl8FWBau83jOrSGnqV
         jJ+n4XNTfmvTSnnewnAvgeI+ud2/b8sEiWriCRSEAuUvz13spcUZhEt5FUKPKDoREY10
         kXuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682875095; x=1685467095;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VUcX1u9Na09LWEG/YlEb5cTfwitTfjn6pv+M2nzybOg=;
        b=bWMwl74Gnx63e3Wyr184orNYEzp3+TNk5wrilulDqIuqTNpf73V9isqANjTd86mlZ4
         BezNBtHM52gc5jvSjxv+2yKHOmfPBil2eLeV1NVub6j7pE31umRyywhKX3VjjldzT5Wt
         C/GBcL2aO5hfqwA1Dx7z1w0vsUe9qFEAeiRsiXoLYTMb6QHSmXuLJ/xL+N832V45akqs
         kfg+j/5b9F/okr5y331K9bi0MTK84Iga0h7we7swKRdps7xJMVi5USssNXk4mQkUM9AC
         M38f4/1LgN8FzvCnT5HMxd/VyMmIGOOqa+4XYNUtT3gcq4Vmhu9p5Elk4Xa52Yw79T6n
         kZ4g==
X-Gm-Message-State: AC+VfDx6SM/dS1sx4SofvHZc3bctoMl+aRUkO2wsoKvVHwaLT+AD7Bb8
        M2SzT3vyDw3nfzmvaDjPtGc=
X-Google-Smtp-Source: ACHHUZ738Ghtd4bVqUrJ1VjpR5sXBQOudiJXMTpSA+63jEgG4H+QovJPYAsOzNLRry1OYS3Mx9oRkw==
X-Received: by 2002:a17:902:d505:b0:1a9:9c5d:9fac with SMTP id b5-20020a170902d50500b001a99c5d9facmr14847770plg.33.1682875094901;
        Sun, 30 Apr 2023 10:18:14 -0700 (PDT)
Received: from localhost ([4.1.102.3])
        by smtp.gmail.com with ESMTPSA id jd9-20020a170903260900b001a681fb3e77sm16155349plb.44.2023.04.30.10.18.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Apr 2023 10:18:14 -0700 (PDT)
From:   Yury Norov <yury.norov@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Yury Norov <yury.norov@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Pawel Chmielewski <pawel.chmielewski@intel.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Barry Song <baohua@kernel.org>
Subject: [PATCH v3 2/8] lib/find: add find_next_and_andnot_bit()
Date:   Sun, 30 Apr 2023 10:18:03 -0700
Message-Id: <20230430171809.124686-3-yury.norov@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230430171809.124686-1-yury.norov@gmail.com>
References: <20230430171809.124686-1-yury.norov@gmail.com>
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

Similarly to find_nth_and_andnot_bit(), find_next_and_andnot_bit() is
a convenient helper that allows traversing bitmaps without storing
intermediate results in a temporary bitmap.

In the following patches the function is used to implement NUMA-aware
CPUs enumeration.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 include/linux/find.h | 43 +++++++++++++++++++++++++++++++++++++++++++
 lib/find_bit.c       | 12 ++++++++++++
 2 files changed, 55 insertions(+)

diff --git a/include/linux/find.h b/include/linux/find.h
index 5e4f39ef2e72..90b68d76c073 100644
--- a/include/linux/find.h
+++ b/include/linux/find.h
@@ -16,6 +16,9 @@ unsigned long _find_next_andnot_bit(const unsigned long *addr1, const unsigned l
 					unsigned long nbits, unsigned long start);
 unsigned long _find_next_or_bit(const unsigned long *addr1, const unsigned long *addr2,
 					unsigned long nbits, unsigned long start);
+unsigned long _find_next_and_andnot_bit(const unsigned long *addr1, const unsigned long *addr2,
+					const unsigned long *addr3, unsigned long nbits,
+					unsigned long start);
 unsigned long _find_next_zero_bit(const unsigned long *addr, unsigned long nbits,
 					 unsigned long start);
 extern unsigned long _find_first_bit(const unsigned long *addr, unsigned long size);
@@ -159,6 +162,40 @@ unsigned long find_next_or_bit(const unsigned long *addr1,
 }
 #endif
 
+#ifndef find_next_and_andnot_bit
+/**
+ * find_next_and_andnot_bit - find the next bit set in *addr1 and *addr2,
+ *			      excluding all the bits in *addr3
+ * @addr1: The first address to base the search on
+ * @addr2: The second address to base the search on
+ * @addr3: The third address to base the search on
+ * @size: The bitmap size in bits
+ * @offset: The bitnumber to start searching at
+ *
+ * Return: the bit number for the next set bit
+ * If no bits are set, returns @size.
+ */
+static __always_inline
+unsigned long find_next_and_andnot_bit(const unsigned long *addr1,
+				   const unsigned long *addr2,
+				   const unsigned long *addr3,
+				   unsigned long size,
+				   unsigned long offset)
+{
+	if (small_const_nbits(size)) {
+		unsigned long val;
+
+		if (unlikely(offset >= size))
+			return size;
+
+		val = *addr1 & *addr2 & ~*addr3 & GENMASK(size - 1, offset);
+		return val ? __ffs(val) : size;
+	}
+
+	return _find_next_and_andnot_bit(addr1, addr2, addr3, size, offset);
+}
+#endif
+
 #ifndef find_next_zero_bit
 /**
  * find_next_zero_bit - find the next cleared bit in a memory region
@@ -568,6 +605,12 @@ unsigned long find_next_bit_le(const void *addr, unsigned
 	     (bit) = find_next_andnot_bit((addr1), (addr2), (size), (bit)), (bit) < (size);\
 	     (bit)++)
 
+#define for_each_and_andnot_bit(bit, addr1, addr2, addr3, size) \
+	for ((bit) = 0;									\
+	     (bit) = find_next_and_andnot_bit((addr1), (addr2), (addr3), (size), (bit)),\
+	     (bit) < (size);								\
+	     (bit)++)
+
 #define for_each_or_bit(bit, addr1, addr2, size) \
 	for ((bit) = 0;									\
 	     (bit) = find_next_or_bit((addr1), (addr2), (size), (bit)), (bit) < (size);\
diff --git a/lib/find_bit.c b/lib/find_bit.c
index 32f99e9a670e..4403e00890b1 100644
--- a/lib/find_bit.c
+++ b/lib/find_bit.c
@@ -182,6 +182,18 @@ unsigned long _find_next_andnot_bit(const unsigned long *addr1, const unsigned l
 EXPORT_SYMBOL(_find_next_andnot_bit);
 #endif
 
+#ifndef find_next_and_andnot_bit
+unsigned long _find_next_and_andnot_bit(const unsigned long *addr1,
+					const unsigned long *addr2,
+					const unsigned long *addr3,
+					unsigned long nbits,
+					unsigned long start)
+{
+	return FIND_NEXT_BIT(addr1[idx] & addr2[idx] & ~addr3[idx], /* nop */, nbits, start);
+}
+EXPORT_SYMBOL(_find_next_and_andnot_bit);
+#endif
+
 #ifndef find_next_or_bit
 unsigned long _find_next_or_bit(const unsigned long *addr1, const unsigned long *addr2,
 					unsigned long nbits, unsigned long start)
-- 
2.37.2

