Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77310607EE0
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 21:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbiJUTOH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 15:14:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230385AbiJUTN6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 15:13:58 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6846B2906AA
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 12:13:55 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id 8so2160928ilj.4
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 12:13:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qAM1egPVWVrike9dFWQzNQN7PoIv5TOv3JuxtoXyqE4=;
        b=tKJZ9iQBwxdnhWesKo8avmic9dyQA85QgCdk0ZvCuN+PgentQO+5dk6cYu0zc/5pzM
         xQCE5VWlKy0kEG6jC2eWdvDx0vlxzzllmRDPNXGktN6DKf4jpnS5tANWx9dPivslbV0B
         Wp8KULKmHLFfwmOzb58r1ag5hyHuFVgKD97HjhMlq01Bz96t8tbha/P8fjAx9maH+JXr
         MotJLvZhB0ileRiweiugeyqH5TNppfOLyByU52u+Y3O6JBHkRMhvkdEM3XAOHOSLM6Sg
         0SXxteXEYePjK/EwK4/QbPK16mvHs5sTzYI6tiVkQE/6fWkfWFW8teJB0eWOaRxEQUCD
         rgXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qAM1egPVWVrike9dFWQzNQN7PoIv5TOv3JuxtoXyqE4=;
        b=DMtsUMr7wwrd6e+pTy6d+pmmg7Ucj4MKzgw1wrTv8KesCrU69c95je/buOfRDmn2f0
         IXe9PtX5fyFWqawq9f55eivy05Drt29J88yYG6r653izHnSaELMsW0EvW6UwHfN8lIRG
         nxmlmocksL7BdQIhUWHFB2ad+fgC+nn28KVebEPdxyMIbJ5Ckri9Yx3SJapc0yqXPEjV
         2+aYP4/41AJA24wMPI+yb2Lx2uZNrqx4EtM5L0Pm9eqYkGhW/HyHwgP9mHvWRURF+eLA
         IOb9vDkch4TrAiwHMc4EwJRerA1GjaTpOKej2cN4+jHk//YjpD8p5OR9PslaryLyMaoU
         kOjA==
X-Gm-Message-State: ACrzQf0vJWI4PCSR9tQKjtDYEZ1NKRJzy/QzZEtCgr9JkMVin+yUE83h
        8plc5nMh9RJx2o22GGS3As8joA==
X-Google-Smtp-Source: AMsMyM4ps6WPNtvO7/MoNxXDzmwb/EUEe+C7RSS86haMC+P2edoivR5PKDQoOVJdDvJGM880djsG0A==
X-Received: by 2002:a05:6e02:170d:b0:2fc:3e76:b262 with SMTP id u13-20020a056e02170d00b002fc3e76b262mr14803311ill.152.1666379634210;
        Fri, 21 Oct 2022 12:13:54 -0700 (PDT)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id e3-20020a022103000000b00363c68aa348sm4439362jaa.72.2022.10.21.12.13.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 12:13:53 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 6/7] net: ipa: kill ipa_table_valid()
Date:   Fri, 21 Oct 2022 14:13:39 -0500
Message-Id: <20221021191340.4187935-7-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221021191340.4187935-1-elder@linaro.org>
References: <20221021191340.4187935-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

What ipa_table_valid() (and ipa_table_valid_one(), which it calls)
does is ensure that the memory regions that hold routing and filter
tables have reasonable size.  Specifically, it checks that the size
of a region is sufficient (or rather, exactly the right size) to
hold the maximum number of entries supported by the driver.  (There
is an additional check that's erroneous, but in practice it is never
reached.)

Recently ipa_table_mem_valid() was added, which is called by
ipa_table_init().  That function verifies that all table memory
regions are of sufficient size, and requires hashed tables to have
zero size if hashing is not supported.  It only ensures the filter
table is large enough to hold the number of endpoints that support
filtering, but that is adequate.

Therefore everything that ipa_table_valid() does is redundant, so
get rid of it.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_mem.c   |  4 ---
 drivers/net/ipa/ipa_table.c | 50 -------------------------------------
 drivers/net/ipa/ipa_table.h |  8 ------
 3 files changed, 62 deletions(-)

diff --git a/drivers/net/ipa/ipa_mem.c b/drivers/net/ipa/ipa_mem.c
index 2238dac2af07e..4022ae01a1319 100644
--- a/drivers/net/ipa/ipa_mem.c
+++ b/drivers/net/ipa/ipa_mem.c
@@ -366,10 +366,6 @@ int ipa_mem_config(struct ipa *ipa)
 		while (--canary_count);
 	}
 
-	/* Make sure filter and route table memory regions are valid */
-	if (!ipa_table_valid(ipa))
-		goto err_dma_free;
-
 	/* Verify the microcontroller ring alignment (if defined) */
 	mem = ipa_mem_find(ipa, IPA_MEM_UC_EVENT_RING);
 	if (mem && mem->offset % 1024) {
diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
index 9822b18d9ed39..7a60f2867de92 100644
--- a/drivers/net/ipa/ipa_table.c
+++ b/drivers/net/ipa/ipa_table.c
@@ -155,56 +155,6 @@ ipa_table_mem(struct ipa *ipa, bool filter, bool hashed, bool ipv6)
 	return ipa_mem_find(ipa, mem_id);
 }
 
-static bool
-ipa_table_valid_one(struct ipa *ipa, enum ipa_mem_id mem_id, bool route)
-{
-	const struct ipa_mem *mem = ipa_mem_find(ipa, mem_id);
-	struct device *dev = &ipa->pdev->dev;
-	u32 size;
-
-	if (route)
-		size = IPA_ROUTE_COUNT_MAX * sizeof(__le64);
-	else
-		size = (1 + IPA_FILTER_COUNT_MAX) * sizeof(__le64);
-	/* mem->size >= size is sufficient, but we'll demand more */
-	if (mem->size == size)
-		return true;
-
-	/* Hashed table regions can be zero size if hashing is not supported */
-	if (ipa_table_hash_support(ipa) && !mem->size)
-		return true;
-
-	dev_err(dev, "%s table region %u size 0x%02x, expected 0x%02x\n",
-		route ? "route" : "filter", mem_id, mem->size, size);
-
-	return false;
-}
-
-/* Verify the filter and route table memory regions are the expected size */
-bool ipa_table_valid(struct ipa *ipa)
-{
-	bool valid;
-
-	valid = ipa_table_valid_one(ipa, IPA_MEM_V4_FILTER, false);
-	valid = valid && ipa_table_valid_one(ipa, IPA_MEM_V6_FILTER, false);
-	valid = valid && ipa_table_valid_one(ipa, IPA_MEM_V4_ROUTE, true);
-	valid = valid && ipa_table_valid_one(ipa, IPA_MEM_V6_ROUTE, true);
-
-	if (!ipa_table_hash_support(ipa))
-		return valid;
-
-	valid = valid && ipa_table_valid_one(ipa, IPA_MEM_V4_FILTER_HASHED,
-					     false);
-	valid = valid && ipa_table_valid_one(ipa, IPA_MEM_V6_FILTER_HASHED,
-					     false);
-	valid = valid && ipa_table_valid_one(ipa, IPA_MEM_V4_ROUTE_HASHED,
-					     true);
-	valid = valid && ipa_table_valid_one(ipa, IPA_MEM_V6_ROUTE_HASHED,
-					     true);
-
-	return valid;
-}
-
 bool ipa_filter_map_valid(struct ipa *ipa, u32 filter_map)
 {
 	struct device *dev = &ipa->pdev->dev;
diff --git a/drivers/net/ipa/ipa_table.h b/drivers/net/ipa/ipa_table.h
index 395189f75d784..73ca8369c6352 100644
--- a/drivers/net/ipa/ipa_table.h
+++ b/drivers/net/ipa/ipa_table.h
@@ -19,14 +19,6 @@ struct ipa;
 /* The maximum number of route table entries (IPv4, IPv6; hashed or not) */
 #define IPA_ROUTE_COUNT_MAX	15
 
-/**
- * ipa_table_valid() - Validate route and filter table memory regions
- * @ipa:	IPA pointer
- *
- * Return:	true if all regions are valid, false otherwise
- */
-bool ipa_table_valid(struct ipa *ipa);
-
 /**
  * ipa_filter_map_valid() - Validate a filter table endpoint bitmap
  * @ipa:	IPA pointer
-- 
2.34.1

