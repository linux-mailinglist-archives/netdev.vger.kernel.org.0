Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 425D734BDB0
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 19:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231566AbhC1Rbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 13:31:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231441AbhC1RbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 13:31:22 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68F87C061762
        for <netdev@vger.kernel.org>; Sun, 28 Mar 2021 10:31:22 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id k25so10470461iob.6
        for <netdev@vger.kernel.org>; Sun, 28 Mar 2021 10:31:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SNiUzqwIGoJ8Lmz4c1CZDsu491SmbNxBdZwDX7gQyfE=;
        b=B+L802KGDYd9n4sIfhgP3o8NraIvIStaKhExGlvIr+TuyVfaZARHGqFZ78fA67OzUQ
         3IVqqja3LM0tmT4QlWrYh9zWBfFKDt9aw42Htsa9Ai3czUGtAJn4dkFmuNJrf7yODgBX
         v/ArR5IvQmnUjd5OG2RU1zYkPNUT/bSVsJ8InFJWoFROpmEZt1c8tTRu/vkhyVQPWgF5
         TQ9PXfBGd8OslUZi+YQ+atTdAQCX4R+wF62SXP7lgpEd+bNpSfFA7l4D9I5ESyZVSVRt
         FY3UBujr4dynHRisEqPt+HzAJ7jYc7DKX6dU0eGnRrFg6QEgwZUrW4kJcEmL+k05Qsil
         BSrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SNiUzqwIGoJ8Lmz4c1CZDsu491SmbNxBdZwDX7gQyfE=;
        b=ibVlzD/abzYOY/NtrAlh516I2vOaNDYPbkJXGgnAE4NrH8BHkrdtdkETLQGyoncVIJ
         E1JezMBzk7Bv5DRa9wQjYg4P2QAEt0BPMY/nQ58v/9heV/grS2cfwqjCsVPYsQI9L+mw
         u1Jt5hIunvjBQA5wVyob/rQmjU5MJtXMYLgi+e19hxTI75IjmGl6ouBBm75MSAXQ2eUD
         ZLtYJ3sQ/ak1qglwHWxuPaYYSyHcEWBPMOouNha37zFGUwwGy0srUP2sZDWtUaqC9FgB
         6C5eTuT4QiMo9CQRGSaB+ngP7a6JsTCFCakIXHn/MDGg6E5Ac6jmDVb+m351B/Vc3hxl
         gkaA==
X-Gm-Message-State: AOAM530aIt7OJqAMUsdQ+8BO0IScbL+lbu8SyE+q1LWHLOc5AwANSQrY
        P0t8oUyLiWwuSy2pcAUQBpbv7A==
X-Google-Smtp-Source: ABdhPJxadUfZ/HPbHomcMB8/OGaWHbx1sbb4rsTbAQVFmJ3r0YDkGiDOrk6uYoMtFCE0jSss/SNN6Q==
X-Received: by 2002:a6b:bf07:: with SMTP id p7mr5739440iof.15.1616952681770;
        Sun, 28 Mar 2021 10:31:21 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id d22sm8014422iof.48.2021.03.28.10.31.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Mar 2021 10:31:21 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 7/7] net: ipa: kill IPA_TABLE_ENTRY_SIZE
Date:   Sun, 28 Mar 2021 12:31:11 -0500
Message-Id: <20210328173111.3399063-8-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210328173111.3399063-1-elder@linaro.org>
References: <20210328173111.3399063-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Entries in an IPA route or filter table are 64-bit little-endian
addresses, each of which refers to a routing or filtering rule.

The format of these table slots are fixed, but IPA_TABLE_ENTRY_SIZE
is used to define their size.  This symbol doesn't really add value,
and I think it unnecessarily obscures what a table entry *is*.

So get rid of IPA_TABLE_ENTRY_SIZE, and just use sizeof(__le64) in
its place throughout the code.

Update the comments in "ipa_table.c" to provide a little better
explanation of these table slots.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_cmd.c   |  2 +-
 drivers/net/ipa/ipa_qmi.c   | 10 +++----
 drivers/net/ipa/ipa_table.c | 59 +++++++++++++++++++++----------------
 drivers/net/ipa/ipa_table.h |  3 --
 4 files changed, 39 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ipa/ipa_cmd.c b/drivers/net/ipa/ipa_cmd.c
index 2ac6dd8413dee..525cdf28d9ea7 100644
--- a/drivers/net/ipa/ipa_cmd.c
+++ b/drivers/net/ipa/ipa_cmd.c
@@ -153,7 +153,7 @@ static void ipa_cmd_validate_build(void)
 	 * of entries, as and IPv4 and IPv6 route tables have the same number
 	 * of entries.
 	 */
-#define TABLE_SIZE	(TABLE_COUNT_MAX * IPA_TABLE_ENTRY_SIZE)
+#define TABLE_SIZE	(TABLE_COUNT_MAX * sizeof(__le64))
 #define TABLE_COUNT_MAX	max_t(u32, IPA_ROUTE_COUNT_MAX, IPA_FILTER_COUNT_MAX)
 	BUILD_BUG_ON(TABLE_SIZE > field_max(IP_FLTRT_FLAGS_HASH_SIZE_FMASK));
 	BUILD_BUG_ON(TABLE_SIZE > field_max(IP_FLTRT_FLAGS_NHASH_SIZE_FMASK));
diff --git a/drivers/net/ipa/ipa_qmi.c b/drivers/net/ipa/ipa_qmi.c
index ccdb4a6a4c75b..593665efbcf99 100644
--- a/drivers/net/ipa/ipa_qmi.c
+++ b/drivers/net/ipa/ipa_qmi.c
@@ -308,12 +308,12 @@ init_modem_driver_req(struct ipa_qmi *ipa_qmi)
 	mem = &ipa->mem[IPA_MEM_V4_ROUTE];
 	req.v4_route_tbl_info_valid = 1;
 	req.v4_route_tbl_info.start = ipa->mem_offset + mem->offset;
-	req.v4_route_tbl_info.count = mem->size / IPA_TABLE_ENTRY_SIZE;
+	req.v4_route_tbl_info.count = mem->size / sizeof(__le64);
 
 	mem = &ipa->mem[IPA_MEM_V6_ROUTE];
 	req.v6_route_tbl_info_valid = 1;
 	req.v6_route_tbl_info.start = ipa->mem_offset + mem->offset;
-	req.v6_route_tbl_info.count = mem->size / IPA_TABLE_ENTRY_SIZE;
+	req.v6_route_tbl_info.count = mem->size / sizeof(__le64);
 
 	mem = &ipa->mem[IPA_MEM_V4_FILTER];
 	req.v4_filter_tbl_start_valid = 1;
@@ -352,8 +352,7 @@ init_modem_driver_req(struct ipa_qmi *ipa_qmi)
 		req.v4_hash_route_tbl_info_valid = 1;
 		req.v4_hash_route_tbl_info.start =
 				ipa->mem_offset + mem->offset;
-		req.v4_hash_route_tbl_info.count =
-				mem->size / IPA_TABLE_ENTRY_SIZE;
+		req.v4_hash_route_tbl_info.count = mem->size / sizeof(__le64);
 	}
 
 	mem = &ipa->mem[IPA_MEM_V6_ROUTE_HASHED];
@@ -361,8 +360,7 @@ init_modem_driver_req(struct ipa_qmi *ipa_qmi)
 		req.v6_hash_route_tbl_info_valid = 1;
 		req.v6_hash_route_tbl_info.start =
 			ipa->mem_offset + mem->offset;
-		req.v6_hash_route_tbl_info.count =
-			mem->size / IPA_TABLE_ENTRY_SIZE;
+		req.v6_hash_route_tbl_info.count = mem->size / sizeof(__le64);
 	}
 
 	mem = &ipa->mem[IPA_MEM_V4_FILTER_HASHED];
diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
index d9538661755f4..401b568df6a34 100644
--- a/drivers/net/ipa/ipa_table.c
+++ b/drivers/net/ipa/ipa_table.c
@@ -27,28 +27,38 @@
 /**
  * DOC: IPA Filter and Route Tables
  *
- * The IPA has tables defined in its local shared memory that define filter
- * and routing rules.  Each entry in these tables contains a 64-bit DMA
- * address that refers to DRAM (system memory) containing a rule definition.
+ * The IPA has tables defined in its local (IPA-resident) memory that define
+ * filter and routing rules.  An entry in either of these tables is a little
+ * endian 64-bit "slot" that holds the address of a rule definition.  (The
+ * size of these slots is 64 bits regardless of the host DMA address size.)
+ *
+ * Separate tables (both filter and route) used for IPv4 and IPv6.  There
+ * are normally another set of "hashed" filter and route tables, which are
+ * used with a hash of message metadata.  Hashed operation is not supported
+ * by all IPA hardware (IPA v4.2 doesn't support hashed tables).
+ *
+ * Rules can be in local memory or in DRAM (system memory).  The offset of
+ * an object (such as a route or filter table) in IPA-resident memory must
+ * 128-byte aligned.  An object in system memory (such as a route or filter
+ * rule) must be at an 8-byte aligned address.  We currently only place
+ * route or filter rules in system memory.
+ *
  * A rule consists of a contiguous block of 32-bit values terminated with
  * 32 zero bits.  A special "zero entry" rule consisting of 64 zero bits
  * represents "no filtering" or "no routing," and is the reset value for
- * filter or route table rules.  Separate tables (both filter and route)
- * used for IPv4 and IPv6.  Additionally, there can be hashed filter or
- * route tables, which are used when a hash of message metadata matches.
- * Hashed operation is not supported by all IPA hardware.
+ * filter or route table rules.
  *
  * Each filter rule is associated with an AP or modem TX endpoint, though
- * not all TX endpoints support filtering.  The first 64-bit entry in a
+ * not all TX endpoints support filtering.  The first 64-bit slot in a
  * filter table is a bitmap indicating which endpoints have entries in
  * the table.  The low-order bit (bit 0) in this bitmap represents a
  * special global filter, which applies to all traffic.  This is not
  * used in the current code.  Bit 1, if set, indicates that there is an
- * entry (i.e. a DMA address referring to a rule) for endpoint 0 in the
- * table.  Bit 2, if set, indicates there is an entry for endpoint 1,
- * and so on.  Space is set aside in IPA local memory to hold as many
- * filter table entries as might be required, but typically they are not
- * all used.
+ * entry (i.e. slot containing a system address referring to a rule) for
+ * endpoint 0 in the table.  Bit 3, if set, indicates there is an entry
+ * for endpoint 2, and so on.  Space is set aside in IPA local memory to
+ * hold as many filter table entries as might be required, but typically
+ * they are not all used.
  *
  * The AP initializes all entries in a filter table to refer to a "zero"
  * entry.  Once initialized the modem and AP update the entries for
@@ -122,8 +132,7 @@ static void ipa_table_validate_build(void)
 	 * code in ipa_table_init() uses a pointer to __le64 to
 	 * initialize tables.
 	 */
-	BUILD_BUG_ON(sizeof(dma_addr_t) > IPA_TABLE_ENTRY_SIZE);
-	BUILD_BUG_ON(sizeof(__le64) != IPA_TABLE_ENTRY_SIZE);
+	BUILD_BUG_ON(sizeof(dma_addr_t) > sizeof(__le64));
 
 	/* A "zero rule" is used to represent no filtering or no routing.
 	 * It is a 64-bit block of zeroed memory.  Code in ipa_table_init()
@@ -154,7 +163,7 @@ ipa_table_valid_one(struct ipa *ipa, bool route, bool ipv6, bool hashed)
 		else
 			mem = hashed ? &ipa->mem[IPA_MEM_V4_ROUTE_HASHED]
 				     : &ipa->mem[IPA_MEM_V4_ROUTE];
-		size = IPA_ROUTE_COUNT_MAX * IPA_TABLE_ENTRY_SIZE;
+		size = IPA_ROUTE_COUNT_MAX * sizeof(__le64);
 	} else {
 		if (ipv6)
 			mem = hashed ? &ipa->mem[IPA_MEM_V6_FILTER_HASHED]
@@ -162,7 +171,7 @@ ipa_table_valid_one(struct ipa *ipa, bool route, bool ipv6, bool hashed)
 		else
 			mem = hashed ? &ipa->mem[IPA_MEM_V4_FILTER_HASHED]
 				     : &ipa->mem[IPA_MEM_V4_FILTER];
-		size = (1 + IPA_FILTER_COUNT_MAX) * IPA_TABLE_ENTRY_SIZE;
+		size = (1 + IPA_FILTER_COUNT_MAX) * sizeof(__le64);
 	}
 
 	if (!ipa_cmd_table_valid(ipa, mem, route, ipv6, hashed))
@@ -261,8 +270,8 @@ static void ipa_table_reset_add(struct gsi_trans *trans, bool filter,
 	if (filter)
 		first++;	/* skip over bitmap */
 
-	offset = mem->offset + first * IPA_TABLE_ENTRY_SIZE;
-	size = count * IPA_TABLE_ENTRY_SIZE;
+	offset = mem->offset + first * sizeof(__le64);
+	size = count * sizeof(__le64);
 	addr = ipa_table_addr(ipa, false, count);
 
 	ipa_cmd_dma_shared_mem_add(trans, offset, size, addr, true);
@@ -444,11 +453,11 @@ static void ipa_table_init_add(struct gsi_trans *trans, bool filter,
 		count = hweight32(ipa->filter_map);
 		hash_count = hash_mem->size ? count : 0;
 	} else {
-		count = mem->size / IPA_TABLE_ENTRY_SIZE;
-		hash_count = hash_mem->size / IPA_TABLE_ENTRY_SIZE;
+		count = mem->size / sizeof(__le64);
+		hash_count = hash_mem->size / sizeof(__le64);
 	}
-	size = count * IPA_TABLE_ENTRY_SIZE;
-	hash_size = hash_count * IPA_TABLE_ENTRY_SIZE;
+	size = count * sizeof(__le64);
+	hash_size = hash_count * sizeof(__le64);
 
 	addr = ipa_table_addr(ipa, filter, count);
 	hash_addr = ipa_table_addr(ipa, filter, hash_count);
@@ -655,7 +664,7 @@ int ipa_table_init(struct ipa *ipa)
 	 * by dma_alloc_coherent() is guaranteed to be a power-of-2 number
 	 * of pages, which satisfies the rule alignment requirement.
 	 */
-	size = IPA_ZERO_RULE_SIZE + (1 + count) * IPA_TABLE_ENTRY_SIZE;
+	size = IPA_ZERO_RULE_SIZE + (1 + count) * sizeof(__le64);
 	virt = dma_alloc_coherent(dev, size, &addr, GFP_KERNEL);
 	if (!virt)
 		return -ENOMEM;
@@ -687,7 +696,7 @@ void ipa_table_exit(struct ipa *ipa)
 	struct device *dev = &ipa->pdev->dev;
 	size_t size;
 
-	size = IPA_ZERO_RULE_SIZE + (1 + count) * IPA_TABLE_ENTRY_SIZE;
+	size = IPA_ZERO_RULE_SIZE + (1 + count) * sizeof(__le64);
 
 	dma_free_coherent(dev, size, ipa->table_virt, ipa->table_addr);
 	ipa->table_addr = 0;
diff --git a/drivers/net/ipa/ipa_table.h b/drivers/net/ipa/ipa_table.h
index e14108ed62bdd..018045b95aad8 100644
--- a/drivers/net/ipa/ipa_table.h
+++ b/drivers/net/ipa/ipa_table.h
@@ -10,9 +10,6 @@
 
 struct ipa;
 
-/* The size of a filter or route table entry */
-#define IPA_TABLE_ENTRY_SIZE	sizeof(__le64)	/* Holds a physical address */
-
 /* The maximum number of filter table entries (IPv4, IPv6; hashed or not) */
 #define IPA_FILTER_COUNT_MAX	14
 
-- 
2.27.0

