Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66CFF5BD621
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 23:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbiISVGq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 17:06:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbiISVGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 17:06:38 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 062A74BD0F;
        Mon, 19 Sep 2022 14:06:25 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id h21so463026qta.3;
        Mon, 19 Sep 2022 14:06:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date;
        bh=r1QhdmpQMtQJBGpWdt2iusBbJ4ttfhaPUaZeWLw+GG0=;
        b=mEeyLqlfr55mb2JcVs/ZosA+TBgy5vzCnkDmfOcpXEKyA/zSocITWoem8z7/tCZGFu
         32eh53Q3USw/qICJFtqRSsYz10rB6adBQzWse7v/T+yJT95HxKzDENOZSsgHq8X1CMKo
         VkYFrNO/GuPfY6KcxPQU4mdU66Tt8Gi4ox+xTNudTR96BeDixPCtLbnUhjaKsCh5ORGv
         cgGrbiypRNki7eTYMQY+mGSjDBvTGbtsYmsXEUrwTXHvyfzgjwuIBSveXdYgcNbx5Eh+
         dJ06Xk0tbYvYQMX/atnotG0wgpujUVGPA+kLNYGKuwqwW4crS7VnvU8qd0jOHDMZ1GKR
         0DOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=r1QhdmpQMtQJBGpWdt2iusBbJ4ttfhaPUaZeWLw+GG0=;
        b=sZeUya/lJhg7KYeca5i/DS0ev7rTXmzVkVV4sAiFg1Lu8LCpK8jTJqpR8Ke4Td4i6z
         8OMOENxOIUJC/jwMMQ5e74WINbvPfRiTc7KccqiSCtSj5A4g+7bb242/UfZPOLEy0yZk
         hrwQx+kKw7iJYRO+pdfA3F0Lm8ujHG76LDoUB76Y37fdhe1WIgmSKpG9P+JsjNlilwGj
         X1Ta/Z+PHCX+R1SCc6SuBmHpisPCbhzE9evPl5048pqUlkX+lSXK7YUJiRXiISs5SxoM
         29F72sU6BKJADqpA4B6DW+NkrowHrM7UTYnRlD22sdunHB4WyWZU/Q+AodmkbP6+3WZQ
         bnGw==
X-Gm-Message-State: ACrzQf1ObeEZZq6jGimxnglPzKGcn0EE6ls39mGmtGqL50h30LWGTZNP
        nFRK7QtpBINvhcZtzkGSGzw+c24xtZw=
X-Google-Smtp-Source: AMsMyM4CWs5pUhSs/w1xKR/4awngwmZN0BzrowmW69c1gT2PfdCuWsI2k0OqeWPE4iZgLiD91iipww==
X-Received: by 2002:a05:622a:1185:b0:35c:e2c4:7a4e with SMTP id m5-20020a05622a118500b0035ce2c47a4emr7849335qtk.241.1663621584571;
        Mon, 19 Sep 2022 14:06:24 -0700 (PDT)
Received: from localhost ([2601:4c1:c100:2270:bb7d:3b54:df44:5476])
        by smtp.gmail.com with ESMTPSA id i67-20020a37b846000000b006ce7d9dea7asm12993993qkf.13.2022.09.19.14.06.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Sep 2022 14:06:24 -0700 (PDT)
From:   Yury Norov <yury.norov@gmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Yury Norov <yury.norov@gmail.com>
Subject: [PATCH 7/7] lib/bitmap: add tests for for_each() loops
Date:   Mon, 19 Sep 2022 14:05:59 -0700
Message-Id: <20220919210559.1509179-8-yury.norov@gmail.com>
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

We have a test for test_for_each_set_clump8 only. Add basic tests for
the others.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 lib/test_bitmap.c | 244 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 243 insertions(+), 1 deletion(-)

diff --git a/lib/test_bitmap.c b/lib/test_bitmap.c
index da52dc759c95..a8005ad3bd58 100644
--- a/lib/test_bitmap.c
+++ b/lib/test_bitmap.c
@@ -726,6 +726,239 @@ static void __init test_for_each_set_clump8(void)
 		expect_eq_clump8(start, CLUMP_EXP_NUMBITS, clump_exp, &clump);
 }
 
+static void __init test_for_each_set_bit_wrap(void)
+{
+	DECLARE_BITMAP(orig, 500);
+	DECLARE_BITMAP(copy, 500);
+	unsigned int wr, bit;
+
+	bitmap_zero(orig, 500);
+
+	/* Set individual bits */
+	for (bit = 0; bit < 500; bit += 10)
+		bitmap_set(orig, bit, 1);
+
+	/* Set range of bits */
+	bitmap_set(orig, 100, 50);
+
+	for (wr = 0; wr < 500; wr++) {
+		bitmap_zero(copy, 500);
+
+		for_each_set_bit_wrap(bit, orig, 500, wr)
+			bitmap_set(copy, bit, 1);
+
+		expect_eq_bitmap(orig, copy, 500);
+	}
+}
+
+static void __init test_for_each_set_bit(void)
+{
+	DECLARE_BITMAP(orig, 500);
+	DECLARE_BITMAP(copy, 500);
+	unsigned int bit;
+
+	bitmap_zero(orig, 500);
+	bitmap_zero(copy, 500);
+
+	/* Set individual bits */
+	for (bit = 0; bit < 500; bit += 10)
+		bitmap_set(orig, bit, 1);
+
+	/* Set range of bits */
+	bitmap_set(orig, 100, 50);
+
+	for_each_set_bit(bit, orig, 500)
+		bitmap_set(copy, bit, 1);
+
+	expect_eq_bitmap(orig, copy, 500);
+}
+
+static void __init test_for_each_set_bit_from(void)
+{
+	DECLARE_BITMAP(orig, 500);
+	DECLARE_BITMAP(copy, 500);
+	unsigned int wr, bit;
+
+	bitmap_zero(orig, 500);
+
+	/* Set individual bits */
+	for (bit = 0; bit < 500; bit += 10)
+		bitmap_set(orig, bit, 1);
+
+	/* Set range of bits */
+	bitmap_set(orig, 100, 50);
+
+	for (wr = 0; wr < 500; wr++) {
+		DECLARE_BITMAP(tmp, 500);
+
+		bitmap_zero(copy, 500);
+		bit = wr;
+
+		for_each_set_bit_from(bit, orig, 500)
+			bitmap_set(copy, bit, 1);
+
+		bitmap_copy(tmp, orig, 500);
+		bitmap_clear(tmp, 0, wr);
+		expect_eq_bitmap(tmp, copy, 500);
+	}
+}
+
+static void __init test_for_each_clear_bit(void)
+{
+	DECLARE_BITMAP(orig, 500);
+	DECLARE_BITMAP(copy, 500);
+	unsigned int bit;
+
+	bitmap_fill(orig, 500);
+	bitmap_fill(copy, 500);
+
+	/* Set individual bits */
+	for (bit = 0; bit < 500; bit += 10)
+		bitmap_clear(orig, bit, 1);
+
+	/* Set range of bits */
+	bitmap_clear(orig, 100, 50);
+
+	for_each_clear_bit(bit, orig, 500)
+		bitmap_clear(copy, bit, 1);
+
+	expect_eq_bitmap(orig, copy, 500);
+}
+
+static void __init test_for_each_clear_bit_from(void)
+{
+	DECLARE_BITMAP(orig, 500);
+	DECLARE_BITMAP(copy, 500);
+	unsigned int wr, bit;
+
+	bitmap_fill(orig, 500);
+
+	/* Set individual bits */
+	for (bit = 0; bit < 500; bit += 10)
+		bitmap_clear(orig, bit, 1);
+
+	/* Set range of bits */
+	bitmap_clear(orig, 100, 50);
+
+	for (wr = 0; wr < 500; wr++) {
+		DECLARE_BITMAP(tmp, 500);
+
+		bitmap_fill(copy, 500);
+		bit = wr;
+
+		for_each_clear_bit_from(bit, orig, 500)
+			bitmap_clear(copy, bit, 1);
+
+		bitmap_copy(tmp, orig, 500);
+		bitmap_set(tmp, 0, wr);
+		expect_eq_bitmap(tmp, copy, 500);
+	}
+}
+
+static void __init test_for_each_set_bitrange(void)
+{
+	DECLARE_BITMAP(orig, 500);
+	DECLARE_BITMAP(copy, 500);
+	unsigned int s, e;
+
+	bitmap_zero(orig, 500);
+	bitmap_zero(copy, 500);
+
+	/* Set individual bits */
+	for (s = 0; s < 500; s += 10)
+		bitmap_set(orig, s, 1);
+
+	/* Set range of bits */
+	bitmap_set(orig, 100, 50);
+
+	for_each_set_bitrange(s, e, orig, 500)
+		bitmap_set(copy, s, e-s);
+
+	expect_eq_bitmap(orig, copy, 500);
+}
+
+static void __init test_for_each_clear_bitrange(void)
+{
+	DECLARE_BITMAP(orig, 500);
+	DECLARE_BITMAP(copy, 500);
+	unsigned int s, e;
+
+	bitmap_fill(orig, 500);
+	bitmap_fill(copy, 500);
+
+	/* Set individual bits */
+	for (s = 0; s < 500; s += 10)
+		bitmap_clear(orig, s, 1);
+
+	/* Set range of bits */
+	bitmap_clear(orig, 100, 50);
+
+	for_each_clear_bitrange(s, e, orig, 500)
+		bitmap_clear(copy, s, e-s);
+
+	expect_eq_bitmap(orig, copy, 500);
+}
+
+static void __init test_for_each_set_bitrange_from(void)
+{
+	DECLARE_BITMAP(orig, 500);
+	DECLARE_BITMAP(copy, 500);
+	unsigned int wr, s, e;
+
+	bitmap_zero(orig, 500);
+
+	/* Set individual bits */
+	for (s = 0; s < 500; s += 10)
+		bitmap_set(orig, s, 1);
+
+	/* Set range of bits */
+	bitmap_set(orig, 100, 50);
+
+	for (wr = 0; wr < 500; wr++) {
+		DECLARE_BITMAP(tmp, 500);
+
+		bitmap_zero(copy, 500);
+		s = wr;
+
+		for_each_set_bitrange_from(s, e, orig, 500)
+			bitmap_set(copy, s, e - s);
+
+		bitmap_copy(tmp, orig, 500);
+		bitmap_clear(tmp, 0, wr);
+		expect_eq_bitmap(tmp, copy, 500);
+	}
+}
+
+static void __init test_for_each_clear_bitrange_from(void)
+{
+	DECLARE_BITMAP(orig, 500);
+	DECLARE_BITMAP(copy, 500);
+	unsigned int wr, s, e;
+
+	bitmap_fill(orig, 500);
+
+	/* Set individual bits */
+	for (s = 0; s < 500; s += 10)
+		bitmap_clear(orig, s, 1);
+
+	/* Set range of bits */
+	bitmap_set(orig, 100, 50);
+
+	for (wr = 0; wr < 500; wr++) {
+		DECLARE_BITMAP(tmp, 500);
+
+		bitmap_fill(copy, 500);
+		s = wr;
+
+		for_each_clear_bitrange_from(s, e, orig, 500)
+			bitmap_clear(copy, s, e - s);
+
+		bitmap_copy(tmp, orig, 500);
+		bitmap_set(tmp, 0, wr);
+		expect_eq_bitmap(tmp, copy, 500);
+	}
+}
+
 struct test_bitmap_cut {
 	unsigned int first;
 	unsigned int cut;
@@ -989,12 +1222,21 @@ static void __init selftest(void)
 	test_bitmap_parselist();
 	test_bitmap_printlist();
 	test_mem_optimisations();
-	test_for_each_set_clump8();
 	test_bitmap_cut();
 	test_bitmap_print_buf();
 	test_bitmap_const_eval();
 
 	test_find_nth_bit();
+	test_for_each_set_bit();
+	test_for_each_set_bit_from();
+	test_for_each_clear_bit();
+	test_for_each_clear_bit_from();
+	test_for_each_set_bitrange();
+	test_for_each_clear_bitrange();
+	test_for_each_set_bitrange_from();
+	test_for_each_clear_bitrange_from();
+	test_for_each_set_clump8();
+	test_for_each_set_bit_wrap();
 }
 
 KSTM_MODULE_LOADERS(test_bitmap);
-- 
2.34.1

