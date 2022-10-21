Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13FDC607EDA
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 21:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbiJUTOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 15:14:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230375AbiJUTN4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 15:13:56 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A78015A8ED
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 12:13:51 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id i65so3176491ioa.0
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 12:13:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CfoX9tfQsNUSpvuUR71Krd80FmBYfkKGaSPZGza3z4Q=;
        b=WttBQ15gvxH0FqkWstCC5tRK4HP+SPLOgo6U9mrNAVLQjqwIy+iA2SZz/RkWjBbQbe
         IfhkQ8ZrzIBvli28qBixTlATAsWltvP0dE96hld/23qwBSiDsDJNokkk6acqes9vco/B
         QWdhnV3QwMg0Ocis6rOo8AGoZfpSQSDysgLXQi171z26LTnH7TB84sp2h9KNkqrfY9/i
         iYJaCNvWwMfiGIHkKRGtc+VgEEu6f7So/9Fq1hiAM4U+UFjKebkR+5D3k1P2wF2ywSZ3
         4ONxW0bQtNLKlBTjifgvWYCCledj6M2ppP/sfCQCar0sFnnUjMdTLynmYFuqzl2tngQI
         x9aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CfoX9tfQsNUSpvuUR71Krd80FmBYfkKGaSPZGza3z4Q=;
        b=vl0yFvKWhN4vkkc1hXZqgN9+7+MlyQ/4T/A7g5FBUhJEvxvLt/TYogOPTaeBLT51NT
         Bz6JPYdnWRksriOYBsdy1QqRtgRVV+uPenGehQQhq7Cm8+UYmDmsNcubXqRcUzmRohQz
         lePTy5UbIInr0mUlqhJ3k3U94qK3X+K+RkPdcZGwag8X6QvPaEznm1dcaO7vo+Q2CQUm
         pnZBc35DVuYc6Vlf60/0AAjeNL999OkCnPAQW9yjynQEz2VGbYhqR2jD8z6kGBWm3Pnm
         bjrgw+t+qDqv5vv7006k0ru8Fb78CECkBuD1bRVcwsdE0d3ExNyz0qH4yNc00qDtdB0e
         pAtA==
X-Gm-Message-State: ACrzQf1BRqEDH9ZVBHIBq4pHBru1XXO2hXKkFJVf68ELiNckR8mXL53c
        X27C/PioS2jT6+DfBeXTuapYmA==
X-Google-Smtp-Source: AMsMyM780wMhNaP2jQHOh1suUf1Km8cAhIjpaYfFIEAKZ6Hy2GpueoZ4XAmzHjdCWQH1Xnxbmy7aAg==
X-Received: by 2002:a5d:9393:0:b0:6bc:be5a:2ce6 with SMTP id c19-20020a5d9393000000b006bcbe5a2ce6mr14732319iol.214.1666379631003;
        Fri, 21 Oct 2022 12:13:51 -0700 (PDT)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id e3-20020a022103000000b00363c68aa348sm4439362jaa.72.2022.10.21.12.13.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 12:13:50 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/7] net: ipa: verify table sizes fit in commands early
Date:   Fri, 21 Oct 2022 14:13:37 -0500
Message-Id: <20221021191340.4187935-5-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221021191340.4187935-1-elder@linaro.org>
References: <20221021191340.4187935-1-elder@linaro.org>
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

We currently verify the table size and offset fit in the immediate
command fields that must encode them in ipa_table_valid_one().  We
can now make this check earlier, in ipa_table_mem_valid().

The non-hashed IPv4 filter and route tables will always exist, and
their sizes will match the IPv6 tables, as well as the hashed tables
(if supported).  So it's sufficient to verify the offset and size of
the IPv4 non-hashed tables fit into these fields.

Rename the function ipa_cmd_table_init_valid(), to reinforce that
it is the TABLE_INIT immediate command fields we're checking.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_cmd.c   | 3 ++-
 drivers/net/ipa/ipa_cmd.h   | 6 +++---
 drivers/net/ipa/ipa_table.c | 8 ++++----
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ipa/ipa_cmd.c b/drivers/net/ipa/ipa_cmd.c
index e46e8f80b1743..abee6cc018a27 100644
--- a/drivers/net/ipa/ipa_cmd.c
+++ b/drivers/net/ipa/ipa_cmd.c
@@ -171,7 +171,8 @@ static void ipa_cmd_validate_build(void)
 }
 
 /* Validate a memory region holding a table */
-bool ipa_cmd_table_valid(struct ipa *ipa, const struct ipa_mem *mem, bool route)
+bool ipa_cmd_table_init_valid(struct ipa *ipa, const struct ipa_mem *mem,
+			      bool route)
 {
 	u32 offset_max = field_max(IP_FLTRT_FLAGS_NHASH_ADDR_FMASK);
 	u32 size_max = field_max(IP_FLTRT_FLAGS_NHASH_SIZE_FMASK);
diff --git a/drivers/net/ipa/ipa_cmd.h b/drivers/net/ipa/ipa_cmd.h
index 8e4243c1f0bbe..d03cc619e2c31 100644
--- a/drivers/net/ipa/ipa_cmd.h
+++ b/drivers/net/ipa/ipa_cmd.h
@@ -47,15 +47,15 @@ enum ipa_cmd_opcode {
 };
 
 /**
- * ipa_cmd_table_valid() - Validate a memory region holding a table
+ * ipa_cmd_table_init_valid() - Validate a memory region holding a table
  * @ipa:	- IPA pointer
  * @mem:	- IPA memory region descriptor
  * @route:	- Whether the region holds a route or filter table
  *
  * Return:	true if region is valid, false otherwise
  */
-bool ipa_cmd_table_valid(struct ipa *ipa, const struct ipa_mem *mem,
-			    bool route);
+bool ipa_cmd_table_init_valid(struct ipa *ipa, const struct ipa_mem *mem,
+			      bool route);
 
 /**
  * ipa_cmd_data_valid() - Validate command-realted configuration is valid
diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
index 222362a7a2a8c..9822b18d9ed39 100644
--- a/drivers/net/ipa/ipa_table.c
+++ b/drivers/net/ipa/ipa_table.c
@@ -166,10 +166,6 @@ ipa_table_valid_one(struct ipa *ipa, enum ipa_mem_id mem_id, bool route)
 		size = IPA_ROUTE_COUNT_MAX * sizeof(__le64);
 	else
 		size = (1 + IPA_FILTER_COUNT_MAX) * sizeof(__le64);
-
-	if (!ipa_cmd_table_valid(ipa, mem, route))
-		return false;
-
 	/* mem->size >= size is sufficient, but we'll demand more */
 	if (mem->size == size)
 		return true;
@@ -645,6 +641,10 @@ static bool ipa_table_mem_valid(struct ipa *ipa, bool modem_route_count)
 	if (mem_ipv4->size != mem_ipv6->size)
 		return false;
 
+	/* Table offset and size must fit in TABLE_INIT command fields */
+	if (!ipa_cmd_table_init_valid(ipa, mem_ipv4, !filter))
+		return false;
+
 	/* Make sure the regions are big enough */
 	count = mem_ipv4->size / sizeof(__le64);
 	if (count < 2)
-- 
2.34.1

