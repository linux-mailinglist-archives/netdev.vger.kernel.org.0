Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC0EE6C903D
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 19:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbjCYSz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 14:55:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbjCYSz0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 14:55:26 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17CDD8A6B;
        Sat, 25 Mar 2023 11:55:25 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id s8so3615975ois.2;
        Sat, 25 Mar 2023 11:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679770524;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P8DARwyXB1+f8bu+p73b5c/Fp4Rp72nImACGHBPnqI8=;
        b=IdkxR+kxYgzj76LG+tvXbGzVQrTmA+weS+xDTfhfxO1G9+bJ7pznH6RtR9snmX9jwi
         g112eus5kfFOueYG3J811mzC9ykU6d5wloVvAaaDqfPQeAQpib+JsOT83HmdBV+dTNhK
         Sqv/Z5s68bM1OQ+iOK3QKAxn9LH0Qa5G7/yPPeClPsV3YyQioTtubyrTilr+qWi+JLw0
         q9AydQ/RERe54yNKnLRNiL0R07d7lgDMcUCNNnevaDvTvShTzMsiBPSQNs8MpNNcpnCd
         cQ9uXJbE9CK1cBeOiKjxea/FwJyRECQ0fstzFwglYaIVtwuUuBuL6a+E4u3U/M5pRxKt
         VvjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679770524;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P8DARwyXB1+f8bu+p73b5c/Fp4Rp72nImACGHBPnqI8=;
        b=H3wOFmBEtRfA/1jOlHcHXWQyIPxs2INlngGcyRKLvmyk9gc0ayrSsVciGe2ac//BpJ
         6o9WQwO9t3JzShaFfPUHBf8fB+3raV9Dbsa57+Za+zERER59Rg1BqK8WqDokcuFY++62
         E6/YmdO0OD79uMEQX1grNKzudPYZ6ot7M6dRNNG+t38B8pcCcgCoexpKA517ets9lc20
         hXtfM7Jjr0oDkEoSR+TDLBX7F0qZYdlMfDauAx2tShBQN7LKFL1J/eS19tAE0nqVHjLO
         JQmeVIY0AONp5ic6CEsPR01ntKBzU5zxrd8Y90//ATEtl7MYh0rdPg3ZF0MufkmXORtk
         yVgw==
X-Gm-Message-State: AO0yUKW4c6TXbQWqK5VWi+vxPk0Q3cCuMuKYaSVJ7YGrGOeZlLKX1c85
        3dhXWVLuWPVXtjdh6Y8G/2E=
X-Google-Smtp-Source: AK7set+UxP7Iq9OQ1/Cyls3NrcFxB4JDS701EemJFeg1cf2g7q33ne9kN5OpaqhZuvwMpJ73veQPfQ==
X-Received: by 2002:a05:6808:1584:b0:386:d1bd:8766 with SMTP id t4-20020a056808158400b00386d1bd8766mr4843928oiw.13.1679770524348;
        Sat, 25 Mar 2023 11:55:24 -0700 (PDT)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id o187-20020acaf0c4000000b0038476262f65sm9559710oih.33.2023.03.25.11.55.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Mar 2023 11:55:24 -0700 (PDT)
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
Subject: [PATCH 1/8] lib/find: add find_next_and_andnot_bit()
Date:   Sat, 25 Mar 2023 11:55:07 -0700
Message-Id: <20230325185514.425745-2-yury.norov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230325185514.425745-1-yury.norov@gmail.com>
References: <20230325185514.425745-1-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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
index 4647864a5ffd..bde0ba9fa59b 100644
--- a/include/linux/find.h
+++ b/include/linux/find.h
@@ -14,6 +14,9 @@ unsigned long _find_next_and_bit(const unsigned long *addr1, const unsigned long
 					unsigned long nbits, unsigned long start);
 unsigned long _find_next_andnot_bit(const unsigned long *addr1, const unsigned long *addr2,
 					unsigned long nbits, unsigned long start);
+unsigned long _find_next_and_andnot_bit(const unsigned long *addr1, const unsigned long *addr2,
+					const unsigned long *addr3, unsigned long nbits,
+					unsigned long start);
 unsigned long _find_next_zero_bit(const unsigned long *addr, unsigned long nbits,
 					 unsigned long start);
 extern unsigned long _find_first_bit(const unsigned long *addr, unsigned long size);
@@ -127,6 +130,40 @@ unsigned long find_next_andnot_bit(const unsigned long *addr1,
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
+ * Returns the bit number for the next set bit
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
@@ -536,6 +573,12 @@ unsigned long find_next_bit_le(const void *addr, unsigned
 	     (bit) = find_next_andnot_bit((addr1), (addr2), (size), (bit)), (bit) < (size);\
 	     (bit)++)
 
+#define for_each_and_andnot_bit(bit, addr1, addr2, addr3, size) \
+	for ((bit) = 0;									\
+	     (bit) = find_next_and_andnot_bit((addr1), (addr2), (addr3), (size), (bit)),\
+	     (bit) < (size);								\
+	     (bit)++)
+
 /* same as for_each_set_bit() but use bit as value to start with */
 #define for_each_set_bit_from(bit, addr, size) \
 	for (; (bit) = find_next_bit((addr), (size), (bit)), (bit) < (size); (bit)++)
diff --git a/lib/find_bit.c b/lib/find_bit.c
index c10920e66788..8e2a6b87262f 100644
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
 #ifndef find_next_zero_bit
 unsigned long _find_next_zero_bit(const unsigned long *addr, unsigned long nbits,
 					 unsigned long start)
-- 
2.34.1

