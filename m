Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB423607ED9
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 21:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbiJUTN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 15:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230304AbiJUTNw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 15:13:52 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0907615A8E2
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 12:13:49 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id 137so3102666iou.9
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 12:13:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HDw9482diyaFwRrAaQF5T4a7oZwEPZMJMihwz/4kzSA=;
        b=tnm4oyhAweSGNma6/aLaMtvbzON+bEe4uWFuVld2RiGTgLSBlMxLLQnfj0q9njaG3q
         PREJ0hi07Wy5hr8SRHgvU7m+NMLkXaZTt/3M9FzGAMx5jYElQUbFIZY80EsRCBn/hqpk
         z0OVESh2QlchZmHOxaxxWq2w6i+oLg5ItHMGa8FGvSvMXhbLgu7GdfnosNTMmCEoPF3Y
         niq+/dvYCZuOlKGpmEzsrJXqh/KINmV0nPZcQVVVG3NWZn1BckFAgcB+MWc9bMEWFj4F
         M6qjzvaqOM01Edf72LTircEzFozW1vNhM4N4C/q82CHa0dHssjfu0MVAB/BYwnaqngHb
         A28w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HDw9482diyaFwRrAaQF5T4a7oZwEPZMJMihwz/4kzSA=;
        b=MihFJJffmG5B3uRslZsbXHLBlqU7U5wbg3+LH9od85FJYl0P3s/05msUilPQ1RfWth
         UqfQstExUYGjJhyfwi8amiyiH0M2X9OiD2/dORJWQRaAxG/xH5rXCJf1Wbzex3JHLD2G
         GOPdFCJH+z236PnWkPAKfdcAxnM1xvWpzlySAoxXKiOp8LolMuJ0VJ1OuSOXWVp6mYmq
         /HccXetk03vJlNu33jF34coFEPi9nc0DadtGTsQtxO448C2Dybzh43K1fZt2eSLpc7TC
         0mkDBQLAOFgekxK16LkmU06TZEWuesfw3xdxo48LCmx/6OcSg8dBeeaNeny2JKlIfFti
         V4ig==
X-Gm-Message-State: ACrzQf0ioIgR6HCb5egF1ocI+NnHrwvnsqE8mATk2GhwIsUAUpE5GTAD
        PLhlX/lsaigb+6tNTm3NxpCPsA==
X-Google-Smtp-Source: AMsMyM6biL3DKsrUMTh7UtoDabhGgj+vePve7dXkfiCfaneymZI7RPlxMCdbcT4EF+knChOjbiMV2A==
X-Received: by 2002:a05:6638:490e:b0:363:c0fb:a5ea with SMTP id cx14-20020a056638490e00b00363c0fba5eamr14192375jab.285.1666379629399;
        Fri, 21 Oct 2022 12:13:49 -0700 (PDT)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id e3-20020a022103000000b00363c68aa348sm4439362jaa.72.2022.10.21.12.13.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 12:13:48 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/7] net: ipa: validate IPA table memory earlier
Date:   Fri, 21 Oct 2022 14:13:36 -0500
Message-Id: <20221021191340.4187935-4-elder@linaro.org>
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

Add checks in ipa_table_init() to ensure the memory regions defined
for IPA filter and routing tables are valid.

For routing tables, the checks ensure:
  - The non-hashed IPv4 and IPv6 routing tables are defined
  - The non-hashed IPv4 and IPv6 routing tables are the same size
  - The number entries in the non-hashed IPv4 routing table is enough
    to hold the number entries available to the modem, plus at least
    one usable by the AP.

For filter tables, the checks ensure:
  - The non-hashed IPv4 and IPv6 filter tables are defined
  - The non-hashed IPv4 and IPv6 filter tables are the same size
  - The number entries in the non-hashed IPv4 filter table is enough
    to hold the endpoint bitmap, plus an entry for each defined
    endpoint that supports filtering.

In addition, for both routing and filter tables:
  - If hashing isn't supported (IPA v4.2), hashed tables are zero size
  - If hashing *is* supported, all hashed tables are the same size as
    their non-hashed counterparts.

When validating the size of routing tables, require the AP to have
at least one entry (in addition to those used by the modem).

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_table.c | 98 +++++++++++++++++++++++++++++++++++--
 1 file changed, 94 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
index 74d7082b3c5aa..222362a7a2a8c 100644
--- a/drivers/net/ipa/ipa_table.c
+++ b/drivers/net/ipa/ipa_table.c
@@ -134,9 +134,25 @@ static void ipa_table_validate_build(void)
 	BUILD_BUG_ON(IPA_ROUTE_COUNT_MAX > 32);
 	/* The modem must be allotted at least one route table entry */
 	BUILD_BUG_ON(!IPA_ROUTE_MODEM_COUNT);
-	/* But it can't have more than what is available */
-	BUILD_BUG_ON(IPA_ROUTE_MODEM_COUNT > IPA_ROUTE_COUNT_MAX);
+	/* AP must too, but we can't use more than what is available */
+	BUILD_BUG_ON(IPA_ROUTE_MODEM_COUNT >= IPA_ROUTE_COUNT_MAX);
+}
 
+static const struct ipa_mem *
+ipa_table_mem(struct ipa *ipa, bool filter, bool hashed, bool ipv6)
+{
+	enum ipa_mem_id mem_id;
+
+	mem_id = filter ? hashed ? ipv6 ? IPA_MEM_V6_FILTER_HASHED
+					: IPA_MEM_V4_FILTER_HASHED
+				 : ipv6 ? IPA_MEM_V6_FILTER
+					: IPA_MEM_V4_FILTER
+			: hashed ? ipv6 ? IPA_MEM_V6_ROUTE_HASHED
+					: IPA_MEM_V4_ROUTE_HASHED
+				 : ipv6 ? IPA_MEM_V6_ROUTE
+					: IPA_MEM_V4_ROUTE;
+
+	return ipa_mem_find(ipa, mem_id);
 }
 
 static bool
@@ -604,8 +620,77 @@ void ipa_table_config(struct ipa *ipa)
 	ipa_route_config(ipa, true);
 }
 
-/*
- * Initialize a coherent DMA allocation containing initialized filter and
+/* Zero modem_route_count means filter table memory check */
+static bool ipa_table_mem_valid(struct ipa *ipa, bool modem_route_count)
+{
+	bool hash_support = ipa_table_hash_support(ipa);
+	bool filter = !modem_route_count;
+	const struct ipa_mem *mem_hashed;
+	const struct ipa_mem *mem_ipv4;
+	const struct ipa_mem *mem_ipv6;
+	u32 count;
+
+	/* IPv4 and IPv6 non-hashed tables are expected to be defined and
+	 * have the same size.  Both must have at least two entries (and
+	 * would normally have more than that).
+	 */
+	mem_ipv4 = ipa_table_mem(ipa, filter, false, false);
+	if (!mem_ipv4)
+		return false;
+
+	mem_ipv6 = ipa_table_mem(ipa, filter, false, true);
+	if (!mem_ipv6)
+		return false;
+
+	if (mem_ipv4->size != mem_ipv6->size)
+		return false;
+
+	/* Make sure the regions are big enough */
+	count = mem_ipv4->size / sizeof(__le64);
+	if (count < 2)
+		return false;
+	if (filter) {
+		/* Filter tables must able to hold the endpoint bitmap plus
+		 * an entry for each endpoint that supports filtering
+		 */
+		if (count < 1 + hweight32(ipa->filter_map))
+			return false;
+	} else {
+		/* Routing tables must be able to hold all modem entries,
+		 * plus at least one entry for the AP.
+		 */
+		if (count < modem_route_count + 1)
+			return false;
+	}
+
+	/* If hashing is supported, hashed tables are expected to be defined,
+	 * and have the same size as non-hashed tables.  If hashing is not
+	 * supported, hashed tables are expected to have zero size (or not
+	 * be defined).
+	 */
+	mem_hashed = ipa_table_mem(ipa, filter, true, false);
+	if (hash_support) {
+		if (!mem_hashed || mem_hashed->size != mem_ipv4->size)
+			return false;
+	} else {
+		if (mem_hashed && mem_hashed->size)
+			return false;
+	}
+
+	/* Same check for IPv6 tables */
+	mem_hashed = ipa_table_mem(ipa, filter, true, true);
+	if (hash_support) {
+		if (!mem_hashed || mem_hashed->size != mem_ipv6->size)
+			return false;
+	} else {
+		if (mem_hashed && mem_hashed->size)
+			return false;
+	}
+
+	return true;
+}
+
+/* Initialize a coherent DMA allocation containing initialized filter and
  * route table data.  This is used when initializing or resetting the IPA
  * filter or route table.
  *
@@ -653,6 +738,11 @@ int ipa_table_init(struct ipa *ipa)
 
 	ipa_table_validate_build();
 
+	if (!ipa_table_mem_valid(ipa, 0))
+		return -EINVAL;
+	if (!ipa_table_mem_valid(ipa, IPA_ROUTE_MODEM_COUNT))
+		return -EINVAL;
+
 	/* The IPA hardware requires route and filter table rules to be
 	 * aligned on a 128-byte boundary.  We put the "zero rule" at the
 	 * base of the table area allocated here.  The DMA address returned
-- 
2.34.1

