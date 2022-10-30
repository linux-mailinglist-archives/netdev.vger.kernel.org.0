Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 245F961269E
	for <lists+netdev@lfdr.de>; Sun, 30 Oct 2022 02:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbiJ3ASq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Oct 2022 20:18:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbiJ3ASk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Oct 2022 20:18:40 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8092724BE8
        for <netdev@vger.kernel.org>; Sat, 29 Oct 2022 17:18:39 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id l6so4729678ilq.3
        for <netdev@vger.kernel.org>; Sat, 29 Oct 2022 17:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lCQLB8py1X/NJwP3+BLi4r+G0VNoFsbUa3BWr+xCFoQ=;
        b=jmHp3teuCYigeQt5u903OOVQ/7tU565Ceuoo6r+WKRicQaxX9/qE2YA1qGRDG+YMdE
         7uRTAfkhzLe8y/gNNUeTDclMFbUWslOXbXddHaCasYQ0H4j9PvoHdq3yniv5koNpfQ/N
         lv08Elpb6jFc+MoRgQTFGSqSIfuG6nthwoytr5v06vdcDbTVmVQUXyoYs9qXpBDti4UD
         UdbVs62YN6Hm1wMry6Y5rNB8hI4RlnZwWHai+gBN3z31leL9xLKRXQO27zoOimEE59zJ
         lmEqqJn74/bGFEluyielEKYZ2Zt4G+npO5j081lqW4VCdDXX714kv2qMWva0t15zlE8p
         OhcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lCQLB8py1X/NJwP3+BLi4r+G0VNoFsbUa3BWr+xCFoQ=;
        b=GY4aljEPuD9teW1RgIETLaeCeuTEf9wu4o2KGQ35oz8lnWhDXQ+l2MSqqZH+U78U4D
         bg9+HIlPIs1nhWBeJr2Mshzityg6wM1y0eB+offb+5T3S91xry+ODclC1FeT23Z91AEx
         1EyYLLCm148Peh6mZme8cXWVtPjEvBvd/L3gQK+/HaHjpnyCXC3eNAjt6YrZMNkfh3gW
         o26lrVqo6Ba7ZsBuxbGrLEDm9ovsY/3WcyenpiWUT8eZwTXN01fwyauFKPu5fwjBTRzi
         Bbrs8ag5w424rq1mS+ZKqW5tPhyNyTOBjtdnsmJ05tGAZkqtaWSEtv9r6COx+SZkHBeL
         xg6w==
X-Gm-Message-State: ACrzQf1E2y/P9lz9Z/bcqSDH5SwuxlSII/Yy0ddNy0fCVD2HKPCgcy3Q
        qnIUiUJNGtIBpNMg2JGumDHcBQ==
X-Google-Smtp-Source: AMsMyM6EIm00YmB25FOtgOYgjH6uikIuOC+Pq/P6sBxKuuX68dFNmdAaiLVJtnaKh3ELsse7CxSNeA==
X-Received: by 2002:a05:6e02:152e:b0:2f9:e082:7fc7 with SMTP id i14-20020a056e02152e00b002f9e0827fc7mr3011352ilu.167.1667089118791;
        Sat, 29 Oct 2022 17:18:38 -0700 (PDT)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id co20-20020a0566383e1400b00375126ae55fsm1087519jab.58.2022.10.29.17.18.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Oct 2022 17:18:38 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/9] net: ipa: use ipa_table_mem() in ipa_table_reset_add()
Date:   Sat, 29 Oct 2022 19:18:21 -0500
Message-Id: <20221030001828.754010-3-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221030001828.754010-1-elder@linaro.org>
References: <20221030001828.754010-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to the previous commit, pass flags rather than a memory
region ID to ipa_table_reset_add(), and there use ipa_table_mem() to
look up the memory region affected based on those flags.

Currently all eight of these table memory regions are assumed to
exist, because they all have canaries within them.  Stop assuming
that will always be the case, and in ipa_table_reset_add() allow
these memory regions to be non-existent.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_table.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
index 94bb7611e574b..3a14465bf8a64 100644
--- a/drivers/net/ipa/ipa_table.c
+++ b/drivers/net/ipa/ipa_table.c
@@ -200,16 +200,17 @@ static dma_addr_t ipa_table_addr(struct ipa *ipa, bool filter_mask, u16 count)
 }
 
 static void ipa_table_reset_add(struct gsi_trans *trans, bool filter,
-				u16 first, u16 count, enum ipa_mem_id mem_id)
+				bool hashed, bool ipv6, u16 first, u16 count)
 {
 	struct ipa *ipa = container_of(trans->gsi, struct ipa, gsi);
-	const struct ipa_mem *mem = ipa_mem_find(ipa, mem_id);
+	const struct ipa_mem *mem;
 	dma_addr_t addr;
 	u32 offset;
 	u16 size;
 
-	/* Nothing to do if the table memory region is empty */
-	if (!mem->size)
+	/* Nothing to do if the memory region is doesn't exist or is empty */
+	mem = ipa_table_mem(ipa, filter, hashed, ipv6);
+	if (!mem || !mem->size)
 		return;
 
 	if (filter)
@@ -227,7 +228,7 @@ static void ipa_table_reset_add(struct gsi_trans *trans, bool filter,
  * for the IPv4 and IPv6 non-hashed and hashed filter tables.
  */
 static int
-ipa_filter_reset_table(struct ipa *ipa, enum ipa_mem_id mem_id, bool modem)
+ipa_filter_reset_table(struct ipa *ipa, bool hashed, bool ipv6, bool modem)
 {
 	u32 ep_mask = ipa->filter_map;
 	u32 count = hweight32(ep_mask);
@@ -253,7 +254,7 @@ ipa_filter_reset_table(struct ipa *ipa, enum ipa_mem_id mem_id, bool modem)
 		if (endpoint->ee_id != ee_id)
 			continue;
 
-		ipa_table_reset_add(trans, true, endpoint_id, 1, mem_id);
+		ipa_table_reset_add(trans, true, hashed, ipv6, endpoint_id, 1);
 	}
 
 	gsi_trans_commit_wait(trans);
@@ -269,18 +270,18 @@ static int ipa_filter_reset(struct ipa *ipa, bool modem)
 {
 	int ret;
 
-	ret = ipa_filter_reset_table(ipa, IPA_MEM_V4_FILTER, modem);
+	ret = ipa_filter_reset_table(ipa, false, false, modem);
 	if (ret)
 		return ret;
 
-	ret = ipa_filter_reset_table(ipa, IPA_MEM_V4_FILTER_HASHED, modem);
+	ret = ipa_filter_reset_table(ipa, true, false, modem);
 	if (ret)
 		return ret;
 
-	ret = ipa_filter_reset_table(ipa, IPA_MEM_V6_FILTER, modem);
+	ret = ipa_filter_reset_table(ipa, false, true, modem);
 	if (ret)
 		return ret;
-	ret = ipa_filter_reset_table(ipa, IPA_MEM_V6_FILTER_HASHED, modem);
+	ret = ipa_filter_reset_table(ipa, true, true, modem);
 
 	return ret;
 }
@@ -312,13 +313,11 @@ static int ipa_route_reset(struct ipa *ipa, bool modem)
 		count = ipa->route_count - modem_route_count;
 	}
 
-	ipa_table_reset_add(trans, false, first, count, IPA_MEM_V4_ROUTE);
-	ipa_table_reset_add(trans, false, first, count,
-			    IPA_MEM_V4_ROUTE_HASHED);
+	ipa_table_reset_add(trans, false, false, false, first, count);
+	ipa_table_reset_add(trans, false, true, false, first, count);
 
-	ipa_table_reset_add(trans, false, first, count, IPA_MEM_V6_ROUTE);
-	ipa_table_reset_add(trans, false, first, count,
-			    IPA_MEM_V6_ROUTE_HASHED);
+	ipa_table_reset_add(trans, false, false, true, first, count);
+	ipa_table_reset_add(trans, false, true, true, first, count);
 
 	gsi_trans_commit_wait(trans);
 
-- 
2.34.1

