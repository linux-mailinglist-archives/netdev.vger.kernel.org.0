Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B06D60D4FB
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 21:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232509AbiJYTwB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 15:52:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232461AbiJYTv6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 15:51:58 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A2AD106E10
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 12:51:54 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id q75so1648483iod.7
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 12:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=edo2LzRaJRftF/iqZOQNJxw3dQUUkViR6y/aHrA9w2E=;
        b=T6Ycp3vIxUxmes1zXRChfYjP10CvMxnbVcBj1faRsM3tX7dTXttF7H4vVLpGnuqGRi
         m6X1geF/Jpn95cBDu+WpP/TbghIiZ7NuF5qKs7Ngo/5r4JXsanWFGfURZFhubnks/MaB
         9jxiMh/3oEyS0YY5xcLnAHIsaarLphlMBNegeVNdZh3rw8VRAJW5o0d7td8o7cGxEJXh
         RNf9xZAVllRoQnboHC5PcXU8I8oLo0ZOGXH4Dmybirs03GBZ8xoFqc1YvEvVX17t9jzY
         XkuVRqblDOYAaPbrZFxm1wR1vOVEsCLRlwQIc7sVNiYL7yLqMJo9naR1q3yllM+KNiS9
         GXrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=edo2LzRaJRftF/iqZOQNJxw3dQUUkViR6y/aHrA9w2E=;
        b=Q5e5Am4S844lcxmkp4KJAaktGYNqVnFDAsqhRGT9ngwHeEVDtfUby/P/1S4y3evCqD
         /a9st+qE+k5Xfmse0mWaJPHl2zBfRLmnz/nKR4JqOk6OtXI6C1QC9bKdNmTj4Z79ge46
         7vBQL6FDJ+XU5OigHq77ArR+Arqz3ZIZGV+Ej71eyEMl/uoE36e/O0WdWnLcTr/HmQAd
         hpU445fHmew1ZpysO+PeRFO8zWu8yJ3//ltQTx+t0fo6qtzss5czhfZL/lgh8/iClKs3
         as0stUTChvwAQKMDnI2NDta+E9S8FokGihMsodtepHoaln1RvX/YbuymLprrAk1ajtUx
         qx1w==
X-Gm-Message-State: ACrzQf0e/lGkLQx2f4sKWgluAoEVugeQst++Zn35KCalJGa4VTxd3yyf
        Uw4r/W3icudqGBXwShlIY+HFoQ==
X-Google-Smtp-Source: AMsMyM5Zqo5AtdY2yKJ45uK9uI6lNwB0myFWzjvW/4VsDq+n8s2UawfYneI8XQrq1JuDgNart12pQA==
X-Received: by 2002:a05:6602:491:b0:672:18ce:8189 with SMTP id y17-20020a056602049100b0067218ce8189mr24199288iov.170.1666727514041;
        Tue, 25 Oct 2022 12:51:54 -0700 (PDT)
Received: from localhost.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id y10-20020a056638014a00b00349d2d52f6asm1211719jao.37.2022.10.25.12.51.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 12:51:52 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/4] net: ipa: determine route table size from memory region
Date:   Tue, 25 Oct 2022 14:51:41 -0500
Message-Id: <20221025195143.255934-3-elder@linaro.org>
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

Currently we assume that any routing table contains a fixed number
of entries.  The number of entries in a routing table can actually
vary, depending only on the size of the IPA-local memory region used
to hold the table.

Stop assuming that a routing table has exactly 15 entries.  Instead,
determine the number of entries in a routing table by dividing its
memory region size by the size of an entry.

The number of entries is computed early, when ipa_table_mem_valid()
is called by ipa_table_init().

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_cmd.c   | 17 ++++++++---------
 drivers/net/ipa/ipa_table.c | 14 +++++---------
 drivers/net/ipa/ipa_table.h |  3 ---
 3 files changed, 13 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ipa/ipa_cmd.c b/drivers/net/ipa/ipa_cmd.c
index de2cd86aa9e28..08e3f395a9453 100644
--- a/drivers/net/ipa/ipa_cmd.c
+++ b/drivers/net/ipa/ipa_cmd.c
@@ -145,18 +145,15 @@ union ipa_cmd_payload {
 
 static void ipa_cmd_validate_build(void)
 {
-	/* The sizes of a filter and route tables need to fit into fields
-	 * in the ipa_cmd_hw_ip_fltrt_init structure.  Although hashed tables
+	/* The size of a filter table needs to fit into fields in the
+	 * ipa_cmd_hw_ip_fltrt_init structure.  Although hashed tables
 	 * might not be used, non-hashed and hashed tables have the same
 	 * maximum size.  IPv4 and IPv6 filter tables have the same number
-	 * of entries, as and IPv4 and IPv6 route tables have the same number
 	 * of entries.
 	 */
-#define TABLE_SIZE	(TABLE_COUNT_MAX * sizeof(__le64))
-#define TABLE_COUNT_MAX	max_t(u32, IPA_ROUTE_COUNT_MAX, IPA_FILTER_COUNT_MAX)
+#define TABLE_SIZE	(IPA_FILTER_COUNT_MAX * sizeof(__le64))
 	BUILD_BUG_ON(TABLE_SIZE > field_max(IP_FLTRT_FLAGS_HASH_SIZE_FMASK));
 	BUILD_BUG_ON(TABLE_SIZE > field_max(IP_FLTRT_FLAGS_NHASH_SIZE_FMASK));
-#undef TABLE_COUNT_MAX
 #undef TABLE_SIZE
 
 	/* Hashed and non-hashed fields are assumed to be the same size */
@@ -178,12 +175,14 @@ bool ipa_cmd_table_init_valid(struct ipa *ipa, const struct ipa_mem *mem,
 	u32 size_max = field_max(IP_FLTRT_FLAGS_NHASH_SIZE_FMASK);
 	const char *table = route ? "route" : "filter";
 	struct device *dev = &ipa->pdev->dev;
+	u32 size;
+
+	size = route ? ipa->route_count * sizeof(__le64) : mem->size;
 
 	/* Size must fit in the immediate command field that holds it */
-	if (mem->size > size_max) {
+	if (size > size_max) {
 		dev_err(dev, "%s table region size too large\n", table);
-		dev_err(dev, "    (0x%04x > 0x%04x)\n",
-			mem->size, size_max);
+		dev_err(dev, "    (0x%04x > 0x%04x)\n", size, size_max);
 
 		return false;
 	}
diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
index 0815c8967e914..23d3f081ac8e1 100644
--- a/drivers/net/ipa/ipa_table.c
+++ b/drivers/net/ipa/ipa_table.c
@@ -130,12 +130,8 @@ static void ipa_table_validate_build(void)
 	 */
 	BUILD_BUG_ON(IPA_ZERO_RULE_SIZE != sizeof(__le64));
 
-	/* Impose a practical limit on the number of routes */
-	BUILD_BUG_ON(IPA_ROUTE_COUNT_MAX > 32);
 	/* The modem must be allotted at least one route table entry */
 	BUILD_BUG_ON(!IPA_ROUTE_MODEM_COUNT);
-	/* AP must too, but we can't use more than what is available */
-	BUILD_BUG_ON(IPA_ROUTE_MODEM_COUNT >= IPA_ROUTE_COUNT_MAX);
 }
 
 static const struct ipa_mem *
@@ -593,18 +589,18 @@ bool ipa_table_mem_valid(struct ipa *ipa, bool modem_route_count)
 	if (mem_ipv4->size != mem_ipv6->size)
 		return false;
 
-	/* Record the number of routing table entries */
+	/* Compute the number of entries, and for routing tables, record it */
+	count = mem_ipv4->size / sizeof(__le64);
+	if (count < 2)
+		return false;
 	if (!filter)
-		ipa->route_count = IPA_ROUTE_COUNT_MAX;
+		ipa->route_count = count;
 
 	/* Table offset and size must fit in TABLE_INIT command fields */
 	if (!ipa_cmd_table_init_valid(ipa, mem_ipv4, !filter))
 		return false;
 
 	/* Make sure the regions are big enough */
-	count = mem_ipv4->size / sizeof(__le64);
-	if (count < 2)
-		return false;
 	if (filter) {
 		/* Filter tables must able to hold the endpoint bitmap plus
 		 * an entry for each endpoint that supports filtering
diff --git a/drivers/net/ipa/ipa_table.h b/drivers/net/ipa/ipa_table.h
index 65d96debd3917..31363292dc1db 100644
--- a/drivers/net/ipa/ipa_table.h
+++ b/drivers/net/ipa/ipa_table.h
@@ -16,9 +16,6 @@ struct ipa;
 /* The number of route table entries allotted to the modem */
 #define IPA_ROUTE_MODEM_COUNT	8
 
-/* The maximum number of route table entries (IPv4, IPv6; hashed or not) */
-#define IPA_ROUTE_COUNT_MAX	15
-
 /**
  * ipa_filter_map_valid() - Validate a filter table endpoint bitmap
  * @ipa:	IPA pointer
-- 
2.34.1

