Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D64D3607EE4
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 21:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbiJUTOJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 15:14:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbiJUTOB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 15:14:01 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0A44295B18
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 12:13:56 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id b79so3128197iof.5
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 12:13:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YuA9mKyzPMTQB96gOrAuldDGglDRxOANAMQpmF9JcZ0=;
        b=ZYGLvXfJXfOMImi9z8M402ao5MOo2atA26a8WtkT2ElDHxDj9qZwZJzhTS84cJWfgw
         MlaG8sgrcqNt8Wy6DqScoGjY95+B61HAHyxFIPeHm3+jzUUq3QrQDnQ+QF2rk8NzorO8
         76qfH7T+OZTx2/by5CdMlS2nSIa+YGMvMY24mGu3qJP3WtfQ9MwGkrJTESrvCg5Q09oV
         ofp+qHQMdyOdInjdsMWJd2i45AsHtCn3Pq/hRt+OorVtY+ixUvMBBncTSCl6FZhiXWjq
         Qr4z0Uf2ByE/bNTyU8cQ5YEdrpwgq+VNBl/2uZ49tidRenZR9+5H09lNuhje0hIPoObW
         /7wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YuA9mKyzPMTQB96gOrAuldDGglDRxOANAMQpmF9JcZ0=;
        b=h/ozK3waOgLpOWo6VbPy+pyiqZSPkodCMrJtfw26+Dzpi6h5VEeX4Tad6wWAUFh68W
         UYRsjYuG5yCAjZa76OTUyi3AOgi7WlhibzHtA4HPsqOEUhqZbjq3KPKsJNYHZWmgzCgf
         0nl+UlxlF+eEIOM6HE8qMTxmeUICguAaIR32VXkmI3Hn0OKNN/CkfHqIloeP3GB8b5sx
         q4P7yjthvAdSxVivE1PUyPkXNWihLFNXj7XIkSbe2FHMu1EKOWrxg/vTkop/wwgjU0ur
         ggmgnNnvRlb4zwV37Lj22nHIY+C9QzfP4NLysXBfSaBTQMvn2DorM4D6P8liikEjwkfU
         xQpQ==
X-Gm-Message-State: ACrzQf279haETXWEjqWlFjBRoYCrJCStlKBnIsxRoou8A455VYPhWmho
        9Dwdg1b+zyNDtmgjr0rfN3fFCA==
X-Google-Smtp-Source: AMsMyM4Mr38vbojIFmyHatZs5zCpt3+1MD2Si7V/jLApdu/VwpoCGIaHzAtD0YgXms6fJHqcPTyJMA==
X-Received: by 2002:a05:6602:2c4b:b0:6bc:ab20:2c28 with SMTP id x11-20020a0566022c4b00b006bcab202c28mr14765936iov.70.1666379635622;
        Fri, 21 Oct 2022 12:13:55 -0700 (PDT)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id e3-20020a022103000000b00363c68aa348sm4439362jaa.72.2022.10.21.12.13.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 12:13:55 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 7/7] net: ipa: check table memory regions earlier
Date:   Fri, 21 Oct 2022 14:13:40 -0500
Message-Id: <20221021191340.4187935-8-elder@linaro.org>
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

Verify that the sizes of the routing and filter table memory regions
are valid as part of memory initialization, rather than waiting for
table initialization.  The main reason to do this is that upcoming
patches use these memory region sizes to determine the number of
entries in these tables, and we'll want to know these sizes are good
sooner.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_mem.c   | 6 ++++++
 drivers/net/ipa/ipa_table.c | 7 +------
 drivers/net/ipa/ipa_table.h | 7 +++++++
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ipa/ipa_mem.c b/drivers/net/ipa/ipa_mem.c
index 4022ae01a1319..a3d2317452ac6 100644
--- a/drivers/net/ipa/ipa_mem.c
+++ b/drivers/net/ipa/ipa_mem.c
@@ -617,6 +617,12 @@ int ipa_mem_init(struct ipa *ipa, const struct ipa_mem_data *mem_data)
 	ipa->mem_count = mem_data->local_count;
 	ipa->mem = mem_data->local;
 
+	/* Check the route and filter table memory regions */
+	if (!ipa_table_mem_valid(ipa, 0))
+		return -EINVAL;
+	if (!ipa_table_mem_valid(ipa, IPA_ROUTE_MODEM_COUNT))
+		return -EINVAL;
+
 	ret = dma_set_mask_and_coherent(&ipa->pdev->dev, DMA_BIT_MASK(64));
 	if (ret) {
 		dev_err(dev, "error %d setting DMA mask\n", ret);
diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
index 7a60f2867de92..58a1a9da3133e 100644
--- a/drivers/net/ipa/ipa_table.c
+++ b/drivers/net/ipa/ipa_table.c
@@ -567,7 +567,7 @@ void ipa_table_config(struct ipa *ipa)
 }
 
 /* Zero modem_route_count means filter table memory check */
-static bool ipa_table_mem_valid(struct ipa *ipa, bool modem_route_count)
+bool ipa_table_mem_valid(struct ipa *ipa, bool modem_route_count)
 {
 	bool hash_support = ipa_table_hash_support(ipa);
 	bool filter = !modem_route_count;
@@ -688,11 +688,6 @@ int ipa_table_init(struct ipa *ipa)
 
 	ipa_table_validate_build();
 
-	if (!ipa_table_mem_valid(ipa, 0))
-		return -EINVAL;
-	if (!ipa_table_mem_valid(ipa, IPA_ROUTE_MODEM_COUNT))
-		return -EINVAL;
-
 	/* The IPA hardware requires route and filter table rules to be
 	 * aligned on a 128-byte boundary.  We put the "zero rule" at the
 	 * base of the table area allocated here.  The DMA address returned
diff --git a/drivers/net/ipa/ipa_table.h b/drivers/net/ipa/ipa_table.h
index 73ca8369c6352..65d96debd3917 100644
--- a/drivers/net/ipa/ipa_table.h
+++ b/drivers/net/ipa/ipa_table.h
@@ -78,4 +78,11 @@ int ipa_table_init(struct ipa *ipa);
  */
 void ipa_table_exit(struct ipa *ipa);
 
+/**
+ * ipa_table_mem_valid() - Validate sizes of table memory regions
+ * @ipa:	IPA pointer
+ * @modem_route_count:	Number of modem route table entries
+ */
+bool ipa_table_mem_valid(struct ipa *ipa, bool modem_route_count);
+
 #endif /* _IPA_TABLE_H_ */
-- 
2.34.1

