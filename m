Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1F952FFF3
	for <lists+netdev@lfdr.de>; Sun, 22 May 2022 02:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348280AbiEVAct (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 20:32:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348014AbiEVAci (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 20:32:38 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D09D4132F
        for <netdev@vger.kernel.org>; Sat, 21 May 2022 17:32:33 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id i74so5438523ioa.4
        for <netdev@vger.kernel.org>; Sat, 21 May 2022 17:32:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vSHRCF1zLoP2q/+UJGoTXeLZBLEijQ7Yq4ob+ptO93g=;
        b=iB7k+gP/BYojiNiJGmsLTKWyLiYiZe4T/k9oRUOCYCdxlbsD4IneL0be9ghqu1hItr
         co8BwQFyZd3oNiZh647qlXR1Mo00IGm+V/oSu568oNy8yKWNUl0KMKM9tUMuxquEsgLx
         JNip0o8vWKTHYlZdtCwsf8+REuPAGObOG5E6twpZOdnsPTk2tNv24SbSu1d+kRHBbr+R
         IHSULEYDDd8Ouq9cPU7JkPxWCsz9GbrmiV02NYV0gqpIYd20Qk9UpP8rCJf+5CRei7UY
         SR+hRizcba8KB8U2EqhPkUizrNfqwZnBCEDHqc4LnfJVCu5IYAZLX9A2i3sojTchWutS
         3p1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vSHRCF1zLoP2q/+UJGoTXeLZBLEijQ7Yq4ob+ptO93g=;
        b=eLOtbbMXrxzIVXGhFPY47jZ84Hqs2Xd6hc1nbHEo4ykIip1i2juZbGPiNGu1iDR6SG
         HnwLuNZuwHp17m82AYm3HUa0L6FoZFJfypJdJLhICYuOWTouzp9EqOoD4qR6P4bMluWX
         i9DE6xHylQEDOGvqoEVBCuYk6ehp1YGCibCHrYtz9/TxZZMsPcqfozsyeaZvypPMNLJ1
         wH91z2y5rok/d6TnSfKUAYv+lexDtCURMjPTIgD7/29gs5rRNr+7fu2e1m3zsX/x10/n
         Da8Q8jDJafCh3dO+o9Ty5FozsBPH3nESIiNx3c44/rRlj3m5T/fXFg8ADCY0fM8qoXZg
         YeFw==
X-Gm-Message-State: AOAM5333rMeACWZxgnIrUWQihwPPVhgSd3u+PK39PmZsb2puWulx2yzT
        b2o18lb4+sggJOF1oIpLSIxQxw==
X-Google-Smtp-Source: ABdhPJzD0BYBNArdMKVqWQ6eigVMGbyZEWe6N3RLCKQ4XXDUato0ebby29kpFim3TkXxl9zBUX4NyA==
X-Received: by 2002:a02:234a:0:b0:32a:f07c:e8 with SMTP id u71-20020a02234a000000b0032af07c00e8mr8363690jau.87.1653179552867;
        Sat, 21 May 2022 17:32:32 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id g8-20020a02c548000000b0032b5e78bfcbsm1757115jaj.135.2022.05.21.17.32.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 May 2022 17:32:32 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 6/9] net: ipa: get rid of ipa_cmd_info->direction
Date:   Sat, 21 May 2022 19:32:20 -0500
Message-Id: <20220522003223.1123705-7-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220522003223.1123705-1-elder@linaro.org>
References: <20220522003223.1123705-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The direction field of the ipa_cmd_info structure is set, but never
used.  It seems it might have been used for the DMA_SHARED_MEM
immediate command, but the DIRECTION flag is set based on the value
of the passed-in direction flag there.

Anyway, remove this unused field from the ipa_cmd_info structure.
This is done as a separate patch to make it very obvious that it's
not required.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi_trans.c | 5 +----
 drivers/net/ipa/ipa_cmd.h   | 2 --
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ipa/gsi_trans.c b/drivers/net/ipa/gsi_trans.c
index bf31ef3d56adc..cf8ee42373547 100644
--- a/drivers/net/ipa/gsi_trans.c
+++ b/drivers/net/ipa/gsi_trans.c
@@ -413,7 +413,6 @@ void gsi_trans_cmd_add(struct gsi_trans *trans, void *buf, u32 size,
 		       dma_addr_t addr, enum dma_data_direction direction,
 		       enum ipa_cmd_opcode opcode)
 {
-	struct ipa_cmd_info *info;
 	u32 which = trans->used++;
 	struct scatterlist *sg;
 
@@ -438,9 +437,7 @@ void gsi_trans_cmd_add(struct gsi_trans *trans, void *buf, u32 size,
 	sg_dma_address(sg) = addr;
 	sg_dma_len(sg) = size;
 
-	info = &trans->info[which];
-	info->opcode = opcode;
-	info->direction = direction;
+	trans->info[which].opcode = opcode;
 }
 
 /* Add a page transfer to a transaction.  It will fill the only TRE. */
diff --git a/drivers/net/ipa/ipa_cmd.h b/drivers/net/ipa/ipa_cmd.h
index 05ed7e42e1842..d4dbe2ce96dcd 100644
--- a/drivers/net/ipa/ipa_cmd.h
+++ b/drivers/net/ipa/ipa_cmd.h
@@ -50,11 +50,9 @@ enum ipa_cmd_opcode {
  * struct ipa_cmd_info - information needed for an IPA immediate command
  *
  * @opcode:	The command opcode.
- * @direction:	Direction of data transfer for DMA commands
  */
 struct ipa_cmd_info {
 	enum ipa_cmd_opcode opcode;
-	enum dma_data_direction direction;
 };
 
 /**
-- 
2.32.0

