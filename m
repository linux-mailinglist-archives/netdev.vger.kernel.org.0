Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A081B6AC763
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 17:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbjCFQMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 11:12:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232834AbjCFQMD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 11:12:03 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F0B838B79;
        Mon,  6 Mar 2023 08:08:48 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id x11so6381112pln.12;
        Mon, 06 Mar 2023 08:08:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678118849;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FM1lIxzBxTQV7ok7VPz6lBRdsK456pDusIxuwYzkcv4=;
        b=E9qG/kRFTkvrs9snccj1cvb86saeOam5VaFR6MawtDhga1BKhqKQ9EYqTiLWp7M9GG
         BJUTmmhg9V3ahDIsVF7a3ZXfmkSmavFjiU0VPmbbKuBumFvxyed63ApWypWQj9b/wvhw
         ylamvdLwRR9+2n67Uz07H+iOa4ekqfebY430MWCOkNM5jkwPeqXadrIfvCfc57nt7sUN
         xPMoTVL3mw2tPz39tJug0hGe0PSP1gxQ+TUcb9mRAs1QDoqbbKj5bo9YlZKGkTYW/31C
         BQcxwYWIIK/HfUofAnPgNdbPdR8s71DBeezW+a84EZdVqBP6XUBp4nBga7JZefZLJF0T
         EWGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678118849;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FM1lIxzBxTQV7ok7VPz6lBRdsK456pDusIxuwYzkcv4=;
        b=s/KONnNCljW+9UwP0NLkiTlqd3H0eAyFUtGR8njBoJjKxYm1lmuXmnNVmyRP4kwDvC
         LtReeGSMZiLTl9CGEs5RhFA4zaJeAJBhq1FY5H2QELtE9x3zA2LzwBgpF6k0zl5KyNkO
         vSP23UACKbHHEsaYfk9LX1b8+WNpSOrNvl8sontCYkScMFiThQ+Yk7+vtN4lTxURzdQZ
         3mLJfqwDSYf7DCbWDnlXKCUYXecgUJHshdNuOYuQVQG+XMp4uaO+JOATx/fEwIudQPbQ
         RsGhWOb1s5ZUsUJkM94hQTxKL9upW46HHfEtksN+rkVxlv/YgIfER/7mgONcP5bB7oHW
         F0Dw==
X-Gm-Message-State: AO0yUKX5KVHVzp9a7NFMm0L/mJ/gIvM/7cQ/Oy6aIQ13RzSZZrLnk32w
        o8HZpxedvnhnhEJHWxLUlSc=
X-Google-Smtp-Source: AK7set+PZV6WMzfRWk4Gf3xHJ7wl7d9AHTIm8PuQMxtywxGOBbDomTl5Vex4hvxj2mK8Qmx4Faud8w==
X-Received: by 2002:a05:6a20:6a1c:b0:c7:61cc:11d4 with SMTP id p28-20020a056a206a1c00b000c761cc11d4mr13799160pzk.44.1678118847959;
        Mon, 06 Mar 2023 08:07:27 -0800 (PST)
Received: from vernon-pc.. ([49.67.2.142])
        by smtp.gmail.com with ESMTPSA id u6-20020aa78386000000b005d35695a66csm6465318pfm.137.2023.03.06.08.07.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 08:07:27 -0800 (PST)
From:   Vernon Yang <vernon2gm@gmail.com>
To:     torvalds@linux-foundation.org, tytso@mit.edu, Jason@zx2c4.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
        yury.norov@gmail.com, andriy.shevchenko@linux.intel.com,
        linux@rasmusvillemoes.dk, james.smart@broadcom.com,
        dick.kennedy@broadcom.com
Cc:     linux-kernel@vger.kernel.org, wireguard@lists.zx2c4.com,
        netdev@vger.kernel.org, linux-scsi@vger.kernel.org,
        Vernon Yang <vernon2gm@gmail.com>
Subject: [PATCH 5/5] cpumask: fix comment of cpumask_xxx
Date:   Tue,  7 Mar 2023 00:06:51 +0800
Message-Id: <20230306160651.2016767-6-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230306160651.2016767-1-vernon2gm@gmail.com>
References: <20230306160651.2016767-1-vernon2gm@gmail.com>
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

After commit 596ff4a09b89 ("cpumask: re-introduce constant-sized cpumask
optimizations"), the cpumask size is divided into three different case,
so fix comment of cpumask_xxx correctly.

Signed-off-by: Vernon Yang <vernon2gm@gmail.com>
---
 include/linux/cpumask.h | 46 ++++++++++++++++++++---------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index 8fbe76607965..248bdb1c50dc 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -155,7 +155,7 @@ static __always_inline unsigned int cpumask_check(unsigned int cpu)
  * cpumask_first - get the first cpu in a cpumask
  * @srcp: the cpumask pointer
  *
- * Returns >= nr_cpu_ids if no cpus set.
+ * Returns >= small_cpumask_bits if no cpus set.
  */
 static inline unsigned int cpumask_first(const struct cpumask *srcp)
 {
@@ -166,7 +166,7 @@ static inline unsigned int cpumask_first(const struct cpumask *srcp)
  * cpumask_first_zero - get the first unset cpu in a cpumask
  * @srcp: the cpumask pointer
  *
- * Returns >= nr_cpu_ids if all cpus are set.
+ * Returns >= small_cpumask_bits if all cpus are set.
  */
 static inline unsigned int cpumask_first_zero(const struct cpumask *srcp)
 {
@@ -178,7 +178,7 @@ static inline unsigned int cpumask_first_zero(const struct cpumask *srcp)
  * @src1p: the first input
  * @src2p: the second input
  *
- * Returns >= nr_cpu_ids if no cpus set in both.  See also cpumask_next_and().
+ * Returns >= small_cpumask_bits if no cpus set in both.  See also cpumask_next_and().
  */
 static inline
 unsigned int cpumask_first_and(const struct cpumask *srcp1, const struct cpumask *srcp2)
@@ -190,7 +190,7 @@ unsigned int cpumask_first_and(const struct cpumask *srcp1, const struct cpumask
  * cpumask_last - get the last CPU in a cpumask
  * @srcp:	- the cpumask pointer
  *
- * Returns	>= nr_cpumask_bits if no CPUs set.
+ * Returns	>= small_cpumask_bits if no CPUs set.
  */
 static inline unsigned int cpumask_last(const struct cpumask *srcp)
 {
@@ -202,7 +202,7 @@ static inline unsigned int cpumask_last(const struct cpumask *srcp)
  * @n: the cpu prior to the place to search (ie. return will be > @n)
  * @srcp: the cpumask pointer
  *
- * Returns >= nr_cpu_ids if no further cpus set.
+ * Returns >= small_cpumask_bits if no further cpus set.
  */
 static inline
 unsigned int cpumask_next(int n, const struct cpumask *srcp)
@@ -218,7 +218,7 @@ unsigned int cpumask_next(int n, const struct cpumask *srcp)
  * @n: the cpu prior to the place to search (ie. return will be > @n)
  * @srcp: the cpumask pointer
  *
- * Returns >= nr_cpu_ids if no further cpus unset.
+ * Returns >= small_cpumask_bits if no further cpus unset.
  */
 static inline unsigned int cpumask_next_zero(int n, const struct cpumask *srcp)
 {
@@ -258,7 +258,7 @@ unsigned int cpumask_any_distribute(const struct cpumask *srcp);
  * @src1p: the first cpumask pointer
  * @src2p: the second cpumask pointer
  *
- * Returns >= nr_cpu_ids if no further cpus set in both.
+ * Returns >= small_cpumask_bits if no further cpus set in both.
  */
 static inline
 unsigned int cpumask_next_and(int n, const struct cpumask *src1p,
@@ -276,7 +276,7 @@ unsigned int cpumask_next_and(int n, const struct cpumask *src1p,
  * @cpu: the (optionally unsigned) integer iterator
  * @mask: the cpumask pointer
  *
- * After the loop, cpu is >= nr_cpu_ids.
+ * After the loop, cpu is >= small_cpumask_bits.
  */
 #define for_each_cpu(cpu, mask)				\
 	for_each_set_bit(cpu, cpumask_bits(mask), small_cpumask_bits)
@@ -310,7 +310,7 @@ unsigned int __pure cpumask_next_wrap(int n, const struct cpumask *mask, int sta
  *
  * The implementation does not assume any bit in @mask is set (including @start).
  *
- * After the loop, cpu is >= nr_cpu_ids.
+ * After the loop, cpu is >= small_cpumask_bits.
  */
 #define for_each_cpu_wrap(cpu, mask, start)				\
 	for_each_set_bit_wrap(cpu, cpumask_bits(mask), small_cpumask_bits, start)
@@ -327,7 +327,7 @@ unsigned int __pure cpumask_next_wrap(int n, const struct cpumask *mask, int sta
  *	for_each_cpu(cpu, &tmp)
  *		...
  *
- * After the loop, cpu is >= nr_cpu_ids.
+ * After the loop, cpu is >= small_cpumask_bits.
  */
 #define for_each_cpu_and(cpu, mask1, mask2)				\
 	for_each_and_bit(cpu, cpumask_bits(mask1), cpumask_bits(mask2), small_cpumask_bits)
@@ -345,7 +345,7 @@ unsigned int __pure cpumask_next_wrap(int n, const struct cpumask *mask, int sta
  *	for_each_cpu(cpu, &tmp)
  *		...
  *
- * After the loop, cpu is >= nr_cpu_ids.
+ * After the loop, cpu is >= small_cpumask_bits.
  */
 #define for_each_cpu_andnot(cpu, mask1, mask2)				\
 	for_each_andnot_bit(cpu, cpumask_bits(mask1), cpumask_bits(mask2), small_cpumask_bits)
@@ -375,7 +375,7 @@ unsigned int cpumask_any_but(const struct cpumask *mask, unsigned int cpu)
  * @srcp: the cpumask pointer
  * @cpu: the N'th cpu to find, starting from 0
  *
- * Returns >= nr_cpu_ids if such cpu doesn't exist.
+ * Returns >= small_cpumask_bits if such cpu doesn't exist.
  */
 static inline unsigned int cpumask_nth(unsigned int cpu, const struct cpumask *srcp)
 {
@@ -388,7 +388,7 @@ static inline unsigned int cpumask_nth(unsigned int cpu, const struct cpumask *s
  * @srcp2: the cpumask pointer
  * @cpu: the N'th cpu to find, starting from 0
  *
- * Returns >= nr_cpu_ids if such cpu doesn't exist.
+ * Returns >= small_cpumask_bits if such cpu doesn't exist.
  */
 static inline
 unsigned int cpumask_nth_and(unsigned int cpu, const struct cpumask *srcp1,
@@ -404,7 +404,7 @@ unsigned int cpumask_nth_and(unsigned int cpu, const struct cpumask *srcp1,
  * @srcp2: the cpumask pointer
  * @cpu: the N'th cpu to find, starting from 0
  *
- * Returns >= nr_cpu_ids if such cpu doesn't exist.
+ * Returns >= small_cpumask_bits if such cpu doesn't exist.
  */
 static inline
 unsigned int cpumask_nth_andnot(unsigned int cpu, const struct cpumask *srcp1,
@@ -421,7 +421,7 @@ unsigned int cpumask_nth_andnot(unsigned int cpu, const struct cpumask *srcp1,
  * @srcp3: the cpumask pointer
  * @cpu: the N'th cpu to find, starting from 0
  *
- * Returns >= nr_cpu_ids if such cpu doesn't exist.
+ * Returns >= small_cpumask_bits if such cpu doesn't exist.
  */
 static __always_inline
 unsigned int cpumask_nth_and_andnot(unsigned int cpu, const struct cpumask *srcp1,
@@ -529,7 +529,7 @@ static inline void cpumask_setall(struct cpumask *dstp)
 }
 
 /**
- * cpumask_clear - clear all cpus (< nr_cpu_ids) in a cpumask
+ * cpumask_clear - clear all cpus (< large_cpumask_bits) in a cpumask
  * @dstp: the cpumask pointer
  */
 static inline void cpumask_clear(struct cpumask *dstp)
@@ -650,7 +650,7 @@ static inline bool cpumask_subset(const struct cpumask *src1p,
 
 /**
  * cpumask_empty - *srcp == 0
- * @srcp: the cpumask to that all cpus < nr_cpu_ids are clear.
+ * @srcp: the cpumask to that all cpus < small_cpumask_bits are clear.
  */
 static inline bool cpumask_empty(const struct cpumask *srcp)
 {
@@ -659,7 +659,7 @@ static inline bool cpumask_empty(const struct cpumask *srcp)
 
 /**
  * cpumask_full - *srcp == 0xFFFFFFFF...
- * @srcp: the cpumask to that all cpus < nr_cpu_ids are set.
+ * @srcp: the cpumask to that all cpus < nr_cpumask_bits are set.
  */
 static inline bool cpumask_full(const struct cpumask *srcp)
 {
@@ -668,7 +668,7 @@ static inline bool cpumask_full(const struct cpumask *srcp)
 
 /**
  * cpumask_weight - Count of bits in *srcp
- * @srcp: the cpumask to count bits (< nr_cpu_ids) in.
+ * @srcp: the cpumask to count bits (< small_cpumask_bits) in.
  */
 static inline unsigned int cpumask_weight(const struct cpumask *srcp)
 {
@@ -677,8 +677,8 @@ static inline unsigned int cpumask_weight(const struct cpumask *srcp)
 
 /**
  * cpumask_weight_and - Count of bits in (*srcp1 & *srcp2)
- * @srcp1: the cpumask to count bits (< nr_cpu_ids) in.
- * @srcp2: the cpumask to count bits (< nr_cpu_ids) in.
+ * @srcp1: the cpumask to count bits (< small_cpumask_bits) in.
+ * @srcp2: the cpumask to count bits (< small_cpumask_bits) in.
  */
 static inline unsigned int cpumask_weight_and(const struct cpumask *srcp1,
 						const struct cpumask *srcp2)
@@ -727,7 +727,7 @@ static inline void cpumask_copy(struct cpumask *dstp,
  * cpumask_any - pick a "random" cpu from *srcp
  * @srcp: the input cpumask
  *
- * Returns >= nr_cpu_ids if no cpus set.
+ * Returns >= small_cpumask_bits if no cpus set.
  */
 #define cpumask_any(srcp) cpumask_first(srcp)
 
@@ -736,7 +736,7 @@ static inline void cpumask_copy(struct cpumask *dstp,
  * @mask1: the first input cpumask
  * @mask2: the second input cpumask
  *
- * Returns >= nr_cpu_ids if no cpus set.
+ * Returns >= small_cpumask_bits if no cpus set.
  */
 #define cpumask_any_and(mask1, mask2) cpumask_first_and((mask1), (mask2))
 
-- 
2.34.1

