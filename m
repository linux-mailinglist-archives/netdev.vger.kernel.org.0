Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CBDF626B29
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 20:10:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235083AbiKLTJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 14:09:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234867AbiKLTJw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 14:09:52 -0500
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C13E518343;
        Sat, 12 Nov 2022 11:09:51 -0800 (PST)
Received: by mail-qk1-x733.google.com with SMTP id g10so5208830qkl.6;
        Sat, 12 Nov 2022 11:09:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MPqmuncXUCU3pW/zVD2ThZ+OJwOyZGXsie5WSsI5Oh8=;
        b=jqi0y5qkypc9adsfTZBBaaEM1uXQiP6cacGrIvjX+Yn7th7DyMhhn6WjwvLBDwm3UH
         Dr3CKiYhAZBYhPbC7UpI5jWEoxjIIIFg/JWGl1Eye/3a0CynIRpXFVg9TD1q6uopzRoJ
         Vsq33cZkSBCr4vnHE4HXBe573KZExdKOHUX7cXN/kCZki2p3TND1pkf9FlGpHDVADIik
         TxaaupPcIX25wyhXpg6M+zztPNyIPtJyui3q+T1Ka/CsVtxO75IDdujNAkUkZaakTnE1
         j+S2Pzj2Hdwy7k1OTOCRXL4hrBV1p/6ja7af6cva4pmW/8hY9EmnC/eSsXcWsPe9IVKA
         Y3aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MPqmuncXUCU3pW/zVD2ThZ+OJwOyZGXsie5WSsI5Oh8=;
        b=fbIIvag132HibuKlZ2EF5Z3A2bZuzqq9DnLkjK315yXx7m/8AxlmyeUEmKcGvZu5+w
         6oc23b42CpgdUro4iU8K2RM5eNjLS17uvPF/dIBFjAMgnRhoVNXY5VpndHpfIwRydYH0
         kVEZJ8RYUgv8yY01GinPRV3RxgLi3pM0CQbdZXIw5wbdFGrRV5AxjnbLp9yAE+dUMIkJ
         E22L9bBq4LYZtJztJz80mUI0VEtodKJ8YPEZOPYpR/OQAURnRLvYYEj9Vi0Ae1L0v3Vc
         Rm+1g3+80i/SwIrQKdWprpGJ4C3TrHCtWZDB12qUin2Y9LVr3mVkQk4+mjSu/Tww5TiW
         cbBg==
X-Gm-Message-State: ANoB5plkapyAN2cvPnOjgmYIqsiSsqXCK+KfLhA6VTU0p+KzmD2Ow8Ks
        xkcv80nKGNdNwc1kaVt5RXiv+zAN8CA=
X-Google-Smtp-Source: AA0mqf52dCCruD9AxaYmeiO4/LpirAsSd1f8y58a4DQKi1AgaAaoh3ZaiVGFak7D7QWwdSzq6HIXQg==
X-Received: by 2002:a37:95c2:0:b0:6fa:4749:cb87 with SMTP id x185-20020a3795c2000000b006fa4749cb87mr5742709qkd.619.1668280190642;
        Sat, 12 Nov 2022 11:09:50 -0800 (PST)
Received: from localhost (user-24-236-74-177.knology.net. [24.236.74.177])
        by smtp.gmail.com with ESMTPSA id bk40-20020a05620a1a2800b006fa4b111c76sm3551789qkb.36.2022.11.12.11.09.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Nov 2022 11:09:50 -0800 (PST)
From:   Yury Norov <yury.norov@gmail.com>
To:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Barry Song <baohua@kernel.org>,
        Ben Segall <bsegall@google.com>,
        haniel Bristot de Oliveira <bristot@redhat.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Gal Pressman <gal@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Mel Gorman <mgorman@suse.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Valentin Schneider <vschneid@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
Cc:     Yury Norov <yury.norov@gmail.com>, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH v2 1/4] lib/find: introduce find_nth_and_andnot_bit
Date:   Sat, 12 Nov 2022 11:09:43 -0800
Message-Id: <20221112190946.728270-2-yury.norov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221112190946.728270-1-yury.norov@gmail.com>
References: <20221112190946.728270-1-yury.norov@gmail.com>
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

The function is used to implement in-place bitmaps traversing without
storing intermediate result in temporary bitmaps, in the following patches.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 include/linux/find.h | 33 +++++++++++++++++++++++++++++++++
 lib/find_bit.c       |  9 +++++++++
 2 files changed, 42 insertions(+)

diff --git a/include/linux/find.h b/include/linux/find.h
index ccaf61a0f5fd..7a97b492b447 100644
--- a/include/linux/find.h
+++ b/include/linux/find.h
@@ -22,6 +22,9 @@ unsigned long __find_nth_and_bit(const unsigned long *addr1, const unsigned long
 				unsigned long size, unsigned long n);
 unsigned long __find_nth_andnot_bit(const unsigned long *addr1, const unsigned long *addr2,
 					unsigned long size, unsigned long n);
+unsigned long __find_nth_and_andnot_bit(const unsigned long *addr1, const unsigned long *addr2,
+					const unsigned long *addr3, unsigned long size,
+					unsigned long n);
 extern unsigned long _find_first_and_bit(const unsigned long *addr1,
 					 const unsigned long *addr2, unsigned long size);
 extern unsigned long _find_first_zero_bit(const unsigned long *addr, unsigned long size);
@@ -255,6 +258,36 @@ unsigned long find_nth_andnot_bit(const unsigned long *addr1, const unsigned lon
 	return __find_nth_andnot_bit(addr1, addr2, size, n);
 }
 
+/**
+ * find_nth_and_andnot_bit - find N'th set bit in 2 memory regions,
+ *			     excluding those set in 3rd region
+ * @addr1: The 1st address to start the search at
+ * @addr2: The 2nd address to start the search at
+ * @addr3: The 3rd address to start the search at
+ * @size: The maximum number of bits to search
+ * @n: The number of set bit, which position is needed, counting from 0
+ *
+ * Returns the bit number of the N'th set bit.
+ * If no such, returns @size.
+ */
+static inline
+unsigned long find_nth_and_andnot_bit(const unsigned long *addr1,
+					const unsigned long *addr2,
+					const unsigned long *addr3,
+					unsigned long size, unsigned long n)
+{
+	if (n >= size)
+		return size;
+
+	if (small_const_nbits(size)) {
+		unsigned long val =  *addr1 & *addr2 & (~*addr2) & GENMASK(size - 1, 0);
+
+		return val ? fns(val, n) : size;
+	}
+
+	return __find_nth_and_andnot_bit(addr1, addr2, addr3, size, n);
+}
+
 #ifndef find_first_and_bit
 /**
  * find_first_and_bit - find the first set bit in both memory regions
diff --git a/lib/find_bit.c b/lib/find_bit.c
index 18bc0a7ac8ee..c10920e66788 100644
--- a/lib/find_bit.c
+++ b/lib/find_bit.c
@@ -155,6 +155,15 @@ unsigned long __find_nth_andnot_bit(const unsigned long *addr1, const unsigned l
 }
 EXPORT_SYMBOL(__find_nth_andnot_bit);
 
+unsigned long __find_nth_and_andnot_bit(const unsigned long *addr1,
+					const unsigned long *addr2,
+					const unsigned long *addr3,
+					unsigned long size, unsigned long n)
+{
+	return FIND_NTH_BIT(addr1[idx] & addr2[idx] & ~addr3[idx], size, n);
+}
+EXPORT_SYMBOL(__find_nth_and_andnot_bit);
+
 #ifndef find_next_and_bit
 unsigned long _find_next_and_bit(const unsigned long *addr1, const unsigned long *addr2,
 					unsigned long nbits, unsigned long start)
-- 
2.34.1

