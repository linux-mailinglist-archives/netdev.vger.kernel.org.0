Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73C8A60D500
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 21:52:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232579AbiJYTwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 15:52:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232496AbiJYTwA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 15:52:00 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEF9F106A7E
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 12:51:58 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id 11so648036iou.0
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 12:51:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kzxGUpzbXxImm84chnls9JcE5FMkEnfBOo4eTdKEFsk=;
        b=d7vJizjehnoLsN4v+Aizmx7Y1q2iL54jeFUJWrbcm4/2ynOw1RDegLc409znFarKsw
         HE9OKWnp9eW4nJnTnie9nMmTs+2rO4s2vMBmcmG7yaFlbqIBxdK8pUOh6ygb+d4M6qxy
         ljle91MMhrF1omsAOxXQJJvBcA7JTAvRMQUrJA0Zpehe7rSrEKQOMGB+6k/TTmxdB5Ox
         8rmLW0Q89Ta5FD10PT/GpJOcbdsgBq3IsiTVnIBHyyxDwd7+ulg9orZkRoUh0vhRs4Ke
         O9B4Xi4a7aBDBFAMagF2rgxg8zYoLO2aPJzKJnxg/RW9/kERYCV+qxKY7wsJrDr5AqE2
         kAzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kzxGUpzbXxImm84chnls9JcE5FMkEnfBOo4eTdKEFsk=;
        b=vgtwOQGWo4URis3ACTNxNn2Gk88J9t62tL70Aq7G6g17yKQRGfXxSnmxL+yfOt2dLG
         ro1UJGKIerP0i1ya2mvVJoZeMnsgQTAQ8H6a8WoeFGBQU7qHxuyNhGClH3sDEqfViCWy
         TXkn+4iGd0YlwS/WpeQ6Vhfjn+98pBLTvs3o+ReeCR3x70XqVhUsQRu/mrClK2p4wMhd
         xQQHtAmZyBZ6GrERNjYOt3ByOCM06BTJ26RVt3tf39hoMttKRYdjWYvd8GHFBbRPliyb
         ag+9EU+Oc2abDU06UNNO8sg8yH00ceiPSilvi+RvA8qYi2JoqgS4z8PWMWLwjjZuzY+L
         nqXw==
X-Gm-Message-State: ACrzQf1ouwYWQEjIP/9tRGPAjW1MIEIhZV8/F9iCuaRR2Zrjl98v0kGQ
        Z2WS73FOEsI3CkGKoDHMKk19zg==
X-Google-Smtp-Source: AMsMyM5ljODGAxjMX1WHPCX8qeMMu35WtxFHsuESq6U44Gy7kpGxTVEzLOVKi7fg8V97Z2L5irPFQw==
X-Received: by 2002:a05:6638:1687:b0:374:fbbd:6617 with SMTP id f7-20020a056638168700b00374fbbd6617mr4754988jat.201.1666727518613;
        Tue, 25 Oct 2022 12:51:58 -0700 (PDT)
Received: from localhost.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id y10-20020a056638014a00b00349d2d52f6asm1211719jao.37.2022.10.25.12.51.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 12:51:57 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/4] net: ipa: determine filter table size from memory region
Date:   Tue, 25 Oct 2022 14:51:43 -0500
Message-Id: <20221025195143.255934-5-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221025195143.255934-1-elder@linaro.org>
References: <20221025195143.255934-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently we assume that any filter table contains a fixed number
of entries.  Like routing tables, the number of entries in a filter
table is limited only by the size of the IPA-local memory region
used to hold the table.

Stop assuming that a filter table has exactly 14 entries.  Instead,
determine the number of entries in a routing table by dividing its
memory region size by the size of an entry.  (Note that the first
"entry" in a filter table contains an endpoint bitmap.)

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa.h       |  2 ++
 drivers/net/ipa/ipa_cmd.c   |  8 ++------
 drivers/net/ipa/ipa_table.c | 20 +++++++++++---------
 drivers/net/ipa/ipa_table.h |  3 ---
 4 files changed, 15 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ipa/ipa.h b/drivers/net/ipa/ipa.h
index 5c95acc70bb33..82225316a2e25 100644
--- a/drivers/net/ipa/ipa.h
+++ b/drivers/net/ipa/ipa.h
@@ -41,6 +41,7 @@ struct ipa_interrupt;
  * @table_virt:		Virtual address of filter/route table content
  * @route_count:	Total number of entries in a routing table
  * @modem_route_count:	Number of modem entries in a routing table
+ * @filter_count:	Maximum number of entries in a filter table
  * @interrupt:		IPA Interrupt information
  * @uc_powered:		true if power is active by proxy for microcontroller
  * @uc_loaded:		true after microcontroller has reported it's ready
@@ -88,6 +89,7 @@ struct ipa {
 	__le64 *table_virt;
 	u32 route_count;
 	u32 modem_route_count;
+	u32 filter_count;
 
 	struct ipa_interrupt *interrupt;
 	bool uc_powered;
diff --git a/drivers/net/ipa/ipa_cmd.c b/drivers/net/ipa/ipa_cmd.c
index 08e3f395a9453..bb3dfa9a2bc81 100644
--- a/drivers/net/ipa/ipa_cmd.c
+++ b/drivers/net/ipa/ipa_cmd.c
@@ -151,11 +151,6 @@ static void ipa_cmd_validate_build(void)
 	 * maximum size.  IPv4 and IPv6 filter tables have the same number
 	 * of entries.
 	 */
-#define TABLE_SIZE	(IPA_FILTER_COUNT_MAX * sizeof(__le64))
-	BUILD_BUG_ON(TABLE_SIZE > field_max(IP_FLTRT_FLAGS_HASH_SIZE_FMASK));
-	BUILD_BUG_ON(TABLE_SIZE > field_max(IP_FLTRT_FLAGS_NHASH_SIZE_FMASK));
-#undef TABLE_SIZE
-
 	/* Hashed and non-hashed fields are assumed to be the same size */
 	BUILD_BUG_ON(field_max(IP_FLTRT_FLAGS_HASH_SIZE_FMASK) !=
 		     field_max(IP_FLTRT_FLAGS_NHASH_SIZE_FMASK));
@@ -177,7 +172,8 @@ bool ipa_cmd_table_init_valid(struct ipa *ipa, const struct ipa_mem *mem,
 	struct device *dev = &ipa->pdev->dev;
 	u32 size;
 
-	size = route ? ipa->route_count * sizeof(__le64) : mem->size;
+	size = route ? ipa->route_count : ipa->filter_count + 1;
+	size *= sizeof(__le64);
 
 	/* Size must fit in the immediate command field that holds it */
 	if (size > size_max) {
diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
index c9ab6a3fabbc3..db1992eaafaa9 100644
--- a/drivers/net/ipa/ipa_table.c
+++ b/drivers/net/ipa/ipa_table.c
@@ -160,9 +160,9 @@ bool ipa_filter_map_valid(struct ipa *ipa, u32 filter_map)
 	}
 
 	count = hweight32(filter_map);
-	if (count > IPA_FILTER_COUNT_MAX) {
+	if (count > ipa->filter_count) {
 		dev_err(dev, "too many filtering endpoints (%u, max %u)\n",
-			count, IPA_FILTER_COUNT_MAX);
+			count, ipa->filter_count);
 
 		return false;
 	}
@@ -178,7 +178,7 @@ static dma_addr_t ipa_table_addr(struct ipa *ipa, bool filter_mask, u16 count)
 	if (!count)
 		return 0;
 
-	WARN_ON(count > max_t(u32, IPA_FILTER_COUNT_MAX, ipa->route_count));
+	WARN_ON(count > max_t(u32, ipa->filter_count, ipa->route_count));
 
 	/* Skip over the zero rule and possibly the filter mask */
 	skip = filter_mask ? 1 : 2;
@@ -586,11 +586,13 @@ bool ipa_table_mem_valid(struct ipa *ipa, bool filter)
 	if (mem_ipv4->size != mem_ipv6->size)
 		return false;
 
-	/* Compute the number of entries, and for routing tables, record it */
+	/* Compute and record the number of entries for each table type */
 	count = mem_ipv4->size / sizeof(__le64);
 	if (count < 2)
 		return false;
-	if (!filter)
+	if (filter)
+		ipa->filter_count = count - 1;	/* Filter map in first entry */
+	else
 		ipa->route_count = count;
 
 	/* Table offset and size must fit in TABLE_INIT command fields */
@@ -645,7 +647,7 @@ bool ipa_table_mem_valid(struct ipa *ipa, bool filter)
  *
  * The first entry in a filter table contains a bitmap indicating which
  * endpoints contain entries in the table.  In addition to that first entry,
- * there are at most IPA_FILTER_COUNT_MAX entries that follow.  Filter table
+ * there is a fixed maximum number of entries that follow.  Filter table
  * entries are 64 bits wide, and (other than the bitmap) contain the DMA
  * address of a filter rule.  A "zero rule" indicates no filtering, and
  * consists of 64 bits of zeroes.  When a filter table is initialized (or
@@ -669,7 +671,7 @@ bool ipa_table_mem_valid(struct ipa *ipa, bool filter)
  *	|\   |-------------------|
  *	| ---- zero rule address | \
  *	|\   |-------------------|  |
- *	| ---- zero rule address |  |	IPA_FILTER_COUNT_MAX
+ *	| ---- zero rule address |  |	Max IPA filter count
  *	|    |-------------------|   >	or IPA route count,
  *	|	      ...	    |	whichever is greater
  *	 \   |-------------------|  |
@@ -687,7 +689,7 @@ int ipa_table_init(struct ipa *ipa)
 
 	ipa_table_validate_build();
 
-	count = max_t(u32, IPA_FILTER_COUNT_MAX, ipa->route_count);
+	count = max_t(u32, ipa->filter_count, ipa->route_count);
 
 	/* The IPA hardware requires route and filter table rules to be
 	 * aligned on a 128-byte boundary.  We put the "zero rule" at the
@@ -723,7 +725,7 @@ int ipa_table_init(struct ipa *ipa)
 
 void ipa_table_exit(struct ipa *ipa)
 {
-	u32 count = max_t(u32, 1 + IPA_FILTER_COUNT_MAX, ipa->route_count);
+	u32 count = max_t(u32, 1 + ipa->filter_count, ipa->route_count);
 	struct device *dev = &ipa->pdev->dev;
 	size_t size;
 
diff --git a/drivers/net/ipa/ipa_table.h b/drivers/net/ipa/ipa_table.h
index 79583b16f363f..8a4dcd7df4c0f 100644
--- a/drivers/net/ipa/ipa_table.h
+++ b/drivers/net/ipa/ipa_table.h
@@ -10,9 +10,6 @@
 
 struct ipa;
 
-/* The maximum number of filter table entries (IPv4, IPv6; hashed or not) */
-#define IPA_FILTER_COUNT_MAX	14
-
 /**
  * ipa_filter_map_valid() - Validate a filter table endpoint bitmap
  * @ipa:	IPA pointer
-- 
2.34.1

