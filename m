Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2878D607EDC
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 21:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbiJUTOE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 15:14:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230381AbiJUTN6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 15:13:58 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA15715A8FE
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 12:13:53 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id i9so2151169ilv.9
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 12:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ffjwyYuCoS/NvlnxXJbOzVeqq5rZ9fCi3nXlY5yNU50=;
        b=PS/Wz4BQtvKmYXcEWIIMLP5lDWgUD+5jUBKHAwjBS8EZnQb5ieqXPwP90BrS9c/wGj
         EZrDcvMyvjQZAxHTVufBLSIqaFLp7l1tFdTEsKtOwhBMjejiX66CybROw9TycWE0mbnq
         o2lp1bB21+uxwlziKnlp3804hAlPyPr50u+eQ7ZrLqcyyuvdbrXayeQmiWEPduyzQUbE
         vFijDPYKo0XqvIwlaP/7V3zRkcvzowf2fvjH7BreI09Cqlu7r/aLjX3M+dbsBvOIZ5xn
         bQv35q4+RG0fkshuj92Ppn/BSO2VErX11J7KToQobkZEx6r///A3Hc+shIQYXw5aOmYZ
         DB0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ffjwyYuCoS/NvlnxXJbOzVeqq5rZ9fCi3nXlY5yNU50=;
        b=HIa0aKlKJB9qP5l7TpG1jTKD+4y+EgHtv63FgiGrDQpXUFXemrDPXt2AphkycKEoBt
         +3cRaSeFMTmfxvYZCCxALWVLvEI2jbEswBPHLV397axY/xuqDQgtOLnQCEwsPclYJAL4
         G3eK5Db6jWzrhtd+9movEL/B3GIaIPjOy6X19+c5H3yEvjJWyKC8Ow8HoZRJdDyr7cM1
         vsfvRWzPCd/bYFZJvDS43diD62CUvZdqlM68gluumrl6x96j38bwN4ZIOKQdrZYCRYV3
         PTEUQ8WB4WZLQIk1VDD3CLh7lzTocsKN+ju4W5alTxiM1q2Mytok/sM+/0o7cdFhF/ra
         XY+A==
X-Gm-Message-State: ACrzQf2q4t02vt8fkA+Fo9voUivBkCXDMzT6qmI22j37f4PlEvnVje4Z
        LDTLslOaYRG55lyN6buaKvHTug==
X-Google-Smtp-Source: AMsMyM74S5oCVbSQiZzB+2SByNiPav0J83U9dbdPgMMpXlANkb9qQTyg2OvcNU8P+u1AvDqUUfC8GA==
X-Received: by 2002:a92:4449:0:b0:2de:95f1:8b80 with SMTP id a9-20020a924449000000b002de95f18b80mr14985942ilm.232.1666379632612;
        Fri, 21 Oct 2022 12:13:52 -0700 (PDT)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id e3-20020a022103000000b00363c68aa348sm4439362jaa.72.2022.10.21.12.13.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 12:13:51 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 5/7] net: ipa: introduce ipa_cmd_init()
Date:   Fri, 21 Oct 2022 14:13:38 -0500
Message-Id: <20221021191340.4187935-6-elder@linaro.org>
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

Currently, ipa_cmd_data_valid() is called by ipa_mem_config().
Nothing it does requires access to hardware though, so it can be
done during the init phase of IPA driver startup.

Create a new function ipa_cmd_init(), whose purpose is to do early
initialization related to IPA immediate commands.  It will call the
build-time validation function, then will make the two calls made
previously by ipa_cmd_data_valid().  This make ipa_cmd_data_valid()
unnecessary, so get rid of it.

Rename ipa_cmd_header_valid() to be ipa_cmd_header_init_local_valid(),
so its name is clearer about which IPA immediate command it is
associated with.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_cmd.c | 31 +++++++++++++++----------------
 drivers/net/ipa/ipa_cmd.h | 10 ++++++++++
 drivers/net/ipa/ipa_mem.c |  4 ----
 3 files changed, 25 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ipa/ipa_cmd.c b/drivers/net/ipa/ipa_cmd.c
index abee6cc018a27..de2cd86aa9e28 100644
--- a/drivers/net/ipa/ipa_cmd.c
+++ b/drivers/net/ipa/ipa_cmd.c
@@ -202,7 +202,7 @@ bool ipa_cmd_table_init_valid(struct ipa *ipa, const struct ipa_mem *mem,
 }
 
 /* Validate the memory region that holds headers */
-static bool ipa_cmd_header_valid(struct ipa *ipa)
+static bool ipa_cmd_header_init_local_valid(struct ipa *ipa)
 {
 	struct device *dev = &ipa->pdev->dev;
 	const struct ipa_mem *mem;
@@ -318,26 +318,11 @@ static bool ipa_cmd_register_write_valid(struct ipa *ipa)
 	return true;
 }
 
-bool ipa_cmd_data_valid(struct ipa *ipa)
-{
-	if (!ipa_cmd_header_valid(ipa))
-		return false;
-
-	if (!ipa_cmd_register_write_valid(ipa))
-		return false;
-
-	return true;
-}
-
-
 int ipa_cmd_pool_init(struct gsi_channel *channel, u32 tre_max)
 {
 	struct gsi_trans_info *trans_info = &channel->trans_info;
 	struct device *dev = channel->gsi->dev;
 
-	/* This is as good a place as any to validate build constants */
-	ipa_cmd_validate_build();
-
 	/* Command payloads are allocated one at a time, but a single
 	 * transaction can require up to the maximum supported by the
 	 * channel; treat them as if they were allocated all at once.
@@ -637,3 +622,17 @@ struct gsi_trans *ipa_cmd_trans_alloc(struct ipa *ipa, u32 tre_count)
 	return gsi_channel_trans_alloc(&ipa->gsi, endpoint->channel_id,
 				       tre_count, DMA_NONE);
 }
+
+/* Init function for immediate commands; there is no ipa_cmd_exit() */
+int ipa_cmd_init(struct ipa *ipa)
+{
+	ipa_cmd_validate_build();
+
+	if (!ipa_cmd_header_init_local_valid(ipa))
+		return -EINVAL;
+
+	if (!ipa_cmd_register_write_valid(ipa))
+		return -EINVAL;
+
+	return 0;
+}
diff --git a/drivers/net/ipa/ipa_cmd.h b/drivers/net/ipa/ipa_cmd.h
index d03cc619e2c31..e2cf1c2b0ef24 100644
--- a/drivers/net/ipa/ipa_cmd.h
+++ b/drivers/net/ipa/ipa_cmd.h
@@ -162,4 +162,14 @@ void ipa_cmd_pipeline_clear_wait(struct ipa *ipa);
  */
 struct gsi_trans *ipa_cmd_trans_alloc(struct ipa *ipa, u32 tre_count);
 
+/**
+ * ipa_cmd_init() - Initialize IPA immediate commands
+ * @ipa:	- IPA pointer
+ *
+ * Return:	0 if successful, or a negative error code
+ *
+ * There is no need for a matching ipa_cmd_exit() function.
+ */
+int ipa_cmd_init(struct ipa *ipa);
+
 #endif /* _IPA_CMD_H_ */
diff --git a/drivers/net/ipa/ipa_mem.c b/drivers/net/ipa/ipa_mem.c
index f84c6830495a4..2238dac2af07e 100644
--- a/drivers/net/ipa/ipa_mem.c
+++ b/drivers/net/ipa/ipa_mem.c
@@ -370,10 +370,6 @@ int ipa_mem_config(struct ipa *ipa)
 	if (!ipa_table_valid(ipa))
 		goto err_dma_free;
 
-	/* Validate memory-related properties relevant to immediate commands */
-	if (!ipa_cmd_data_valid(ipa))
-		goto err_dma_free;
-
 	/* Verify the microcontroller ring alignment (if defined) */
 	mem = ipa_mem_find(ipa, IPA_MEM_UC_EVENT_RING);
 	if (mem && mem->offset % 1024) {
-- 
2.34.1

