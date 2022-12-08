Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC9164758F
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 19:31:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbiLHSbK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 13:31:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbiLHSbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 13:31:07 -0500
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD2B985D22;
        Thu,  8 Dec 2022 10:31:06 -0800 (PST)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-144bd860fdbso2851441fac.0;
        Thu, 08 Dec 2022 10:31:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7GKu6nYSg2QuKfSdnsbd4k37yUZL8bwLA3bRTzpoaPY=;
        b=Y15HafJbJTrLTuYdUm3i7HUjS0WiIKG+VAqL+nHDWm1wgXNnqc3nd5zCGz2jAnyQeM
         XFIktIRnVOzIO3UCKzZW6YSDDH6n51hFOzeH1I5n4a36lrPgccDOhu5s/tT0Ok4GNlyH
         r7+C4+igqjHDeDuej17Sqsivvjg+a7aexu/boogD3G4gUJmoYPcSx0xJXffDy0Qe8g4o
         LDjBHzHGX7WhtP3If+O4WjybNGkXsZpkEYbW0IkwL+Y1kQMztK3S0EnbX+a0Z5qpeDXK
         LPzmLfDhg2KRJUe12KECmbL4j4wrgIEfvgBGiWsR5h6DzOKzrTISjEqGsmJGXXc3Nh3d
         bRmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7GKu6nYSg2QuKfSdnsbd4k37yUZL8bwLA3bRTzpoaPY=;
        b=UUqMbC3zwlvg9o/o/IMRqwyMuZGNplB8CHZE05oB7mdtqr/zD6eYqtC4lGLkYVexHH
         SaUX4E5Itw21olMdC10jZYTj8r7+TenBLT/FGaW5y6+Tp6paw+WjJefioqlFv1znB62x
         +zzVFpzDw62gOy6Db/hRiKN0G4AvTIEeXx6Q9E5S0EdBjT1wog5uKcwK2D6xX4u31C+W
         rMpVN0V1HUmKjM4pAIasOkZKzO2nA+Rg3Al/i55edSQv4sTPQ4GFjeiwfowSm2prwcf/
         CKmVfxayb77uUBaVSCeYkf1VilGbmTPuBJD3ZpehuOT2udJsSuzKTD0IWBS7WYNmhjh0
         3QcA==
X-Gm-Message-State: ANoB5pkwJqSKQ2olZ2Mx1fCHHlMNj+VtI9dcPewgNyLwsxe2343poh4O
        ZmWARuhTNgYOPI0jHkrjuXhIcLpP8iU=
X-Google-Smtp-Source: AA0mqf4cS0omche0WusJuRsm1M++bRMWf4geAAW8C6lPPHTypaUr2hXdeM8VNGIGdX1In1C2oFr4RQ==
X-Received: by 2002:a05:6870:6088:b0:13b:85e:2a3a with SMTP id t8-20020a056870608800b0013b085e2a3amr1605938oae.12.1670524266217;
        Thu, 08 Dec 2022 10:31:06 -0800 (PST)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id d67-20020aca3646000000b0035a921f2093sm10834215oia.20.2022.12.08.10.31.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 10:31:05 -0800 (PST)
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
Subject: [PATCH v3 1/5] lib/find: introduce find_nth_and_andnot_bit
Date:   Thu,  8 Dec 2022 10:30:57 -0800
Message-Id: <20221208183101.1162006-2-yury.norov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221208183101.1162006-1-yury.norov@gmail.com>
References: <20221208183101.1162006-1-yury.norov@gmail.com>
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
index 3f59c2fbe438..b594207a0010 100644
--- a/include/linux/find.h
+++ b/include/linux/find.h
@@ -23,6 +23,9 @@ unsigned long __find_nth_and_bit(const unsigned long *addr1, const unsigned long
 				unsigned long size, unsigned long n);
 unsigned long __find_nth_andnot_bit(const unsigned long *addr1, const unsigned long *addr2,
 					unsigned long size, unsigned long n);
+unsigned long __find_nth_and_andnot_bit(const unsigned long *addr1, const unsigned long *addr2,
+					const unsigned long *addr3, unsigned long size,
+					unsigned long n);
 extern unsigned long _find_first_and_bit(const unsigned long *addr1,
 					 const unsigned long *addr2, unsigned long size);
 extern unsigned long _find_first_zero_bit(const unsigned long *addr, unsigned long size);
@@ -244,6 +247,36 @@ unsigned long find_nth_andnot_bit(const unsigned long *addr1, const unsigned lon
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
+static __always_inline
+unsigned long find_nth_and_andnot_bit(const unsigned long *addr1,
+					const unsigned long *addr2,
+					const unsigned long *addr3,
+					unsigned long size, unsigned long n)
+{
+	if (n >= size)
+		return size;
+
+	if (small_const_nbits(size)) {
+		unsigned long val =  *addr1 & *addr2 & (~*addr3) & GENMASK(size - 1, 0);
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

