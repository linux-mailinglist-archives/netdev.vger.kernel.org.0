Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 527875BD61D
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 23:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbiISVGj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 17:06:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbiISVGX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 17:06:23 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBF8B4AD4A;
        Mon, 19 Sep 2022 14:06:22 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id f26so432790qto.11;
        Mon, 19 Sep 2022 14:06:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date;
        bh=niDsSZ0B4tRMkQqyG3c14j4OPhIREF3CmeN5buhV29M=;
        b=Ch27sSQXSwnH+NUftLwAC/4CoQcRgvlBZg90Bfrz6v/yc1Q+GEgN2bNbahOcQXsOYW
         XLaMXx7XyH0yuq5/jExx5bSKaDrmHoZYvGNib4u/Hjuc/Qp/ZjUURSrnGxgGGlfMHoDA
         pMCRdhZ8flK1oX6mnbKKpX94PQ8oZwAuqtWMOGeInnaJetpqBUwUPWCEuvu5SR4cca/N
         X0+Lx/Oj2a56HfdInvLscNLRB95Z0WSJ9Vlak1EKHpzraxwvW7hkwPMVtF3HKzrTAEVP
         vxVDKkUGiz7/bMbxMEkmH+7z+QrPwHzu6wIDqXzlmpU5VX/yzzfPq4z1ee53QJ+2NQFw
         BaVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=niDsSZ0B4tRMkQqyG3c14j4OPhIREF3CmeN5buhV29M=;
        b=5F6waT0ZoANETQJu4W32LCWoX+HmrqcMDyQ2h1AaKcs1jnVUHJbAvJGxRvpiaWMF34
         D72U1hYOH1tDjY5HEH41gYmzQt5n4nBnc+FaksPhAXOpVwOG6p/FHUUMTbIlNCvYRR6t
         cKN78K+ujwkHUgO/QexuC5TxcjPMcmVk1MbR5FUu2EmmVRCxE2Bz11T2OFNOoC280ifF
         cbgS99EWPBBNOboPoFH2Q5ThID9Nenc4z5Oomd0o3bILyAfPGbwbh0NLskU/b6z1Rvb5
         pMpsGH/PTa8Gn6m5z94u4Ci2Ac9rkqv2o6loW5ddk/qtd+XZwQ0dMhn8GdHluuiEjrVR
         9GCA==
X-Gm-Message-State: ACrzQf23Z44wm2PEfglFmdY87BCq4HpnxKUW2ECqQav6hWIQCBD8R2PU
        C6KK5p4yo5iacn8LoK7DhTTFloNq7R0=
X-Google-Smtp-Source: AMsMyM6HpzGnWLWB9U8P7UD+3E9W0tuvCzoOs7/arzCwPYPy+2dtHuyHjlKlTUApV4tklUF6Dxjlbw==
X-Received: by 2002:a05:622a:2cb:b0:35c:c034:314f with SMTP id a11-20020a05622a02cb00b0035cc034314fmr16597733qtx.641.1663621581596;
        Mon, 19 Sep 2022 14:06:21 -0700 (PDT)
Received: from localhost ([2601:4c1:c100:2270:bb7d:3b54:df44:5476])
        by smtp.gmail.com with ESMTPSA id x5-20020a05620a258500b006bc1512986esm13793917qko.97.2022.09.19.14.06.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Sep 2022 14:06:21 -0700 (PDT)
From:   Yury Norov <yury.norov@gmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Yury Norov <yury.norov@gmail.com>
Subject: [PATCH 4/7] lib/find_bit: add find_next{,_and}_bit_wrap
Date:   Mon, 19 Sep 2022 14:05:56 -0700
Message-Id: <20220919210559.1509179-5-yury.norov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220919210559.1509179-1-yury.norov@gmail.com>
References: <20220919210559.1509179-1-yury.norov@gmail.com>
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

The helper is better optimized for the worst case: in case of empty
cpumask, current code traverses 2 * size:

  next = cpumask_next_and(prev, src1p, src2p);
  if (next >= nr_cpu_ids)
  	next = cpumask_first_and(src1p, src2p);

At bitmap level we can stop earlier after checking 'size + offset' bits.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 include/linux/find.h | 46 ++++++++++++++++++++++++++++++++++++++++++++
 lib/cpumask.c        | 12 +++---------
 2 files changed, 49 insertions(+), 9 deletions(-)

diff --git a/include/linux/find.h b/include/linux/find.h
index 128615a3f93e..77c087b7a451 100644
--- a/include/linux/find.h
+++ b/include/linux/find.h
@@ -290,6 +290,52 @@ unsigned long find_last_bit(const unsigned long *addr, unsigned long size)
 }
 #endif
 
+/**
+ * find_next_and_bit_wrap - find the next set bit in both memory regions
+ * @addr1: The first address to base the search on
+ * @addr2: The second address to base the search on
+ * @size: The bitmap size in bits
+ * @offset: The bitnumber to start searching at
+ *
+ * Returns the bit number for the next set bit, or first set bit up to @offset
+ * If no bits are set, returns @size.
+ */
+static inline
+unsigned long find_next_and_bit_wrap(const unsigned long *addr1,
+					const unsigned long *addr2,
+					unsigned long size, unsigned long offset)
+{
+	unsigned long bit = find_next_and_bit(addr1, addr2, size, offset);
+
+	if (bit < size)
+		return bit;
+
+	bit = find_first_and_bit(addr1, addr2, offset);
+	return bit < offset ? bit : size;
+}
+
+/**
+ * find_next_bit_wrap - find the next set bit in both memory regions
+ * @addr: The first address to base the search on
+ * @size: The bitmap size in bits
+ * @offset: The bitnumber to start searching at
+ *
+ * Returns the bit number for the next set bit, or first set bit up to @offset
+ * If no bits are set, returns @size.
+ */
+static inline
+unsigned long find_next_bit_wrap(const unsigned long *addr,
+					unsigned long size, unsigned long offset)
+{
+	unsigned long bit = find_next_bit(addr, size, offset);
+
+	if (bit < size)
+		return bit;
+
+	bit = find_first_bit(addr, offset);
+	return bit < offset ? bit : size;
+}
+
 /**
  * find_next_clump8 - find next 8-bit clump with set bits in a memory region
  * @clump: location to store copy of found clump
diff --git a/lib/cpumask.c b/lib/cpumask.c
index 2c4a63b6f03f..c7c392514fd3 100644
--- a/lib/cpumask.c
+++ b/lib/cpumask.c
@@ -166,10 +166,8 @@ unsigned int cpumask_any_and_distribute(const struct cpumask *src1p,
 	/* NOTE: our first selection will skip 0. */
 	prev = __this_cpu_read(distribute_cpu_mask_prev);
 
-	next = cpumask_next_and(prev, src1p, src2p);
-	if (next >= nr_cpu_ids)
-		next = cpumask_first_and(src1p, src2p);
-
+	next = find_next_and_bit_wrap(cpumask_bits(src1p), cpumask_bits(src2p),
+					nr_cpumask_bits, prev + 1);
 	if (next < nr_cpu_ids)
 		__this_cpu_write(distribute_cpu_mask_prev, next);
 
@@ -183,11 +181,7 @@ unsigned int cpumask_any_distribute(const struct cpumask *srcp)
 
 	/* NOTE: our first selection will skip 0. */
 	prev = __this_cpu_read(distribute_cpu_mask_prev);
-
-	next = cpumask_next(prev, srcp);
-	if (next >= nr_cpu_ids)
-		next = cpumask_first(srcp);
-
+	next = find_next_bit_wrap(cpumask_bits(srcp), nr_cpumask_bits, prev + 1);
 	if (next < nr_cpu_ids)
 		__this_cpu_write(distribute_cpu_mask_prev, next);
 
-- 
2.34.1

