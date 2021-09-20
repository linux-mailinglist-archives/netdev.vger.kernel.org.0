Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5914410E95
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 05:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232408AbhITDKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 23:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231156AbhITDKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Sep 2021 23:10:13 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 088C1C061766;
        Sun, 19 Sep 2021 20:08:47 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id n18so10093127plp.7;
        Sun, 19 Sep 2021 20:08:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l0RV9upSf8wGPcjVwJSGyhGah90Hq8k0EVM2Q6lwx6E=;
        b=N0HtU5lXTjygkZrS+geEd1RecpFbNG3anT3hTvAXky+XdazYyl5xqeNyczGRYiIQQF
         OyxTcQSjUEgAfpwXa9dFIQ+ZcaJ+lOPcW/ROrTfz5FhMpiH6lm/WqsfpglETdJ9pO6BW
         B36nL09zLOHc8jtctHcsLuNUSu4++yQQaOLR6SAzJXsz5AKSC7d7EGOszxzCjvcTexqH
         ISs3svHcJPAwXTiahqfvI4AZkyL9B4So33gettnoc1FXQVM5ZozWhfSBTNyiTeKostgs
         zzJl24qm0ap4mtaGTDjyRezfkG3a8vS3nRK6a119cj47Hb9vCShCpx8O0UyebmdZkmZS
         qNFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l0RV9upSf8wGPcjVwJSGyhGah90Hq8k0EVM2Q6lwx6E=;
        b=AjnVOovWhJCIVZl+U70avuuo408xWize6iYNYNlviGMHyto9Nb8rtUU/HaSmQfq+WE
         wUI8JFwgKxmP1vnBTJu/fDpz3W/WGl0HvfnMKbf2jJmUmGgVaLzf/w9udtyX8GVmYUnO
         yMKmkFXsJ6f6JvXuhmR86gum0/o4eunf5RzmgsVI66VDsIR2MdVFRayZNTRX7NmB4gHA
         rrUentFvlEViwkghQxinJfDmiff/Gkx7QJND/uk+prJVlW46ZhdKiQgzwda9Tw9Wi7ko
         ujWe4Y6lq4/a8AuC+lzy5HTQ1Dw8uw5LFuoPtaMfGPgdZYtUbOHB5e6Z6bsi2xP3F0nE
         CY0Q==
X-Gm-Message-State: AOAM5304s60db1pegtZFQau7qYNnUA6mFsEupO2gxbz5OWAczgSi6HPr
        fEXLnhov8FuFeRz4liQoBTxlLa4EBHwsAQDa
X-Google-Smtp-Source: ABdhPJy0HxBfROYETdVWfX905Z8zz2lXrC812H4jf7f9v+P8jVycfvK0cx6QvNjOTvTaCVJchTrSXw==
X-Received: by 2002:a17:90a:e7ca:: with SMTP id kb10mr35553804pjb.33.1632107326287;
        Sun, 19 Sep 2021 20:08:46 -0700 (PDT)
Received: from skynet-linux.local ([106.201.127.154])
        by smtp.googlemail.com with ESMTPSA id l11sm16295065pjg.22.2021.09.19.20.08.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Sep 2021 20:08:45 -0700 (PDT)
From:   Sireesh Kodali <sireeshkodali1@gmail.com>
To:     phone-devel@vger.kernel.org, ~postmarketos/upstreaming@lists.sr.ht,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, elder@kernel.org
Cc:     Vladimir Lypak <vladimir.lypak@gmail.com>,
        Sireesh Kodali <sireeshkodali1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC PATCH 02/17] net: ipa: revert to IPA_TABLE_ENTRY_SIZE for 32-bit IPA support
Date:   Mon, 20 Sep 2021 08:37:56 +0530
Message-Id: <20210920030811.57273-3-sireeshkodali1@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920030811.57273-1-sireeshkodali1@gmail.com>
References: <20210920030811.57273-1-sireeshkodali1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Lypak <vladimir.lypak@gmail.com>

IPA v2.x is 32 bit. Having an IPA_TABLE_ENTRY size makes it easier to
deal with supporting both 32 bit and 64 bit IPA versions

Signed-off-by: Vladimir Lypak <vladimir.lypak@gmail.com>
Signed-off-by: Sireesh Kodali <sireeshkodali1@gmail.com>
---
 drivers/net/ipa/ipa_qmi.c   | 10 ++++++----
 drivers/net/ipa/ipa_table.c | 29 +++++++++++++----------------
 drivers/net/ipa/ipa_table.h |  4 ++++
 3 files changed, 23 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ipa/ipa_qmi.c b/drivers/net/ipa/ipa_qmi.c
index 90f3aec55b36..7e2fe701cc4d 100644
--- a/drivers/net/ipa/ipa_qmi.c
+++ b/drivers/net/ipa/ipa_qmi.c
@@ -308,12 +308,12 @@ init_modem_driver_req(struct ipa_qmi *ipa_qmi)
 	mem = ipa_mem_find(ipa, IPA_MEM_V4_ROUTE);
 	req.v4_route_tbl_info_valid = 1;
 	req.v4_route_tbl_info.start = ipa->mem_offset + mem->offset;
-	req.v4_route_tbl_info.count = mem->size / sizeof(__le64);
+	req.v4_route_tbl_info.count = mem->size / IPA_TABLE_ENTRY_SIZE(ipa->version);
 
 	mem = ipa_mem_find(ipa, IPA_MEM_V6_ROUTE);
 	req.v6_route_tbl_info_valid = 1;
 	req.v6_route_tbl_info.start = ipa->mem_offset + mem->offset;
-	req.v6_route_tbl_info.count = mem->size / sizeof(__le64);
+	req.v6_route_tbl_info.count = mem->size / IPA_TABLE_ENTRY_SIZE(ipa->version);
 
 	mem = ipa_mem_find(ipa, IPA_MEM_V4_FILTER);
 	req.v4_filter_tbl_start_valid = 1;
@@ -352,7 +352,8 @@ init_modem_driver_req(struct ipa_qmi *ipa_qmi)
 		req.v4_hash_route_tbl_info_valid = 1;
 		req.v4_hash_route_tbl_info.start =
 				ipa->mem_offset + mem->offset;
-		req.v4_hash_route_tbl_info.count = mem->size / sizeof(__le64);
+		req.v4_hash_route_tbl_info.count =
+				mem->size / IPA_TABLE_ENTRY_SIZE(ipa->version);
 	}
 
 	mem = ipa_mem_find(ipa, IPA_MEM_V6_ROUTE_HASHED);
@@ -360,7 +361,8 @@ init_modem_driver_req(struct ipa_qmi *ipa_qmi)
 		req.v6_hash_route_tbl_info_valid = 1;
 		req.v6_hash_route_tbl_info.start =
 			ipa->mem_offset + mem->offset;
-		req.v6_hash_route_tbl_info.count = mem->size / sizeof(__le64);
+		req.v6_hash_route_tbl_info.count =
+				mem->size / IPA_TABLE_ENTRY_SIZE(ipa->version);
 	}
 
 	mem = ipa_mem_find(ipa, IPA_MEM_V4_FILTER_HASHED);
diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
index 1da334f54944..96c467c80a2e 100644
--- a/drivers/net/ipa/ipa_table.c
+++ b/drivers/net/ipa/ipa_table.c
@@ -118,7 +118,8 @@
  * 32-bit all-zero rule list terminator.  The "zero rule" is simply an
  * all-zero rule followed by the list terminator.
  */
-#define IPA_ZERO_RULE_SIZE		(2 * sizeof(__le32))
+#define IPA_ZERO_RULE_SIZE(version) \
+	 (IPA_IS_64BIT(version) ? 2 * sizeof(__le32) : sizeof(__le32))
 
 /* Check things that can be validated at build time. */
 static void ipa_table_validate_build(void)
@@ -132,12 +133,6 @@ static void ipa_table_validate_build(void)
 	 */
 	BUILD_BUG_ON(sizeof(dma_addr_t) > sizeof(__le64));
 
-	/* A "zero rule" is used to represent no filtering or no routing.
-	 * It is a 64-bit block of zeroed memory.  Code in ipa_table_init()
-	 * assumes that it can be written using a pointer to __le64.
-	 */
-	BUILD_BUG_ON(IPA_ZERO_RULE_SIZE != sizeof(__le64));
-
 	/* Impose a practical limit on the number of routes */
 	BUILD_BUG_ON(IPA_ROUTE_COUNT_MAX > 32);
 	/* The modem must be allotted at least one route table entry */
@@ -236,7 +231,7 @@ static dma_addr_t ipa_table_addr(struct ipa *ipa, bool filter_mask, u16 count)
 	/* Skip over the zero rule and possibly the filter mask */
 	skip = filter_mask ? 1 : 2;
 
-	return ipa->table_addr + skip * sizeof(*ipa->table_virt);
+	return ipa->table_addr + skip * IPA_TABLE_ENTRY_SIZE(ipa->version);
 }
 
 static void ipa_table_reset_add(struct gsi_trans *trans, bool filter,
@@ -255,8 +250,8 @@ static void ipa_table_reset_add(struct gsi_trans *trans, bool filter,
 	if (filter)
 		first++;	/* skip over bitmap */
 
-	offset = mem->offset + first * sizeof(__le64);
-	size = count * sizeof(__le64);
+	offset = mem->offset + first * IPA_TABLE_ENTRY_SIZE(ipa->version);
+	size = count * IPA_TABLE_ENTRY_SIZE(ipa->version);
 	addr = ipa_table_addr(ipa, false, count);
 
 	ipa_cmd_dma_shared_mem_add(trans, offset, size, addr, true);
@@ -434,11 +429,11 @@ static void ipa_table_init_add(struct gsi_trans *trans, bool filter,
 		count = 1 + hweight32(ipa->filter_map);
 		hash_count = hash_mem->size ? count : 0;
 	} else {
-		count = mem->size / sizeof(__le64);
-		hash_count = hash_mem->size / sizeof(__le64);
+		count = mem->size / IPA_TABLE_ENTRY_SIZE(ipa->version);
+		hash_count = hash_mem->size / IPA_TABLE_ENTRY_SIZE(ipa->version);
 	}
-	size = count * sizeof(__le64);
-	hash_size = hash_count * sizeof(__le64);
+	size = count * IPA_TABLE_ENTRY_SIZE(ipa->version);
+	hash_size = hash_count * IPA_TABLE_ENTRY_SIZE(ipa->version);
 
 	addr = ipa_table_addr(ipa, filter, count);
 	hash_addr = ipa_table_addr(ipa, filter, hash_count);
@@ -621,7 +616,8 @@ int ipa_table_init(struct ipa *ipa)
 	 * by dma_alloc_coherent() is guaranteed to be a power-of-2 number
 	 * of pages, which satisfies the rule alignment requirement.
 	 */
-	size = IPA_ZERO_RULE_SIZE + (1 + count) * sizeof(__le64);
+	size = IPA_ZERO_RULE_SIZE(ipa->version) +
+	       (1 + count) * IPA_TABLE_ENTRY_SIZE(ipa->version);
 	virt = dma_alloc_coherent(dev, size, &addr, GFP_KERNEL);
 	if (!virt)
 		return -ENOMEM;
@@ -653,7 +649,8 @@ void ipa_table_exit(struct ipa *ipa)
 	struct device *dev = &ipa->pdev->dev;
 	size_t size;
 
-	size = IPA_ZERO_RULE_SIZE + (1 + count) * sizeof(__le64);
+	size = IPA_ZERO_RULE_SIZE(ipa->version) +
+	       (1 + count) * IPA_TABLE_ENTRY_SIZE(ipa->version);
 
 	dma_free_coherent(dev, size, ipa->table_virt, ipa->table_addr);
 	ipa->table_addr = 0;
diff --git a/drivers/net/ipa/ipa_table.h b/drivers/net/ipa/ipa_table.h
index b6a9a0d79d68..78a168ce6558 100644
--- a/drivers/net/ipa/ipa_table.h
+++ b/drivers/net/ipa/ipa_table.h
@@ -10,6 +10,10 @@
 
 struct ipa;
 
+/* The size of a filter or route table entry */
+#define IPA_TABLE_ENTRY_SIZE(version)	\
+	(IPA_IS_64BIT(version) ? sizeof(__le64) : sizeof(__le32))
+
 /* The maximum number of filter table entries (IPv4, IPv6; hashed or not) */
 #define IPA_FILTER_COUNT_MAX	14
 
-- 
2.33.0

