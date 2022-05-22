Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E24452FFF6
	for <lists+netdev@lfdr.de>; Sun, 22 May 2022 02:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347927AbiEVAcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 20:32:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348078AbiEVAcj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 20:32:39 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E6F64133A
        for <netdev@vger.kernel.org>; Sat, 21 May 2022 17:32:34 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id y12so12136084ior.7
        for <netdev@vger.kernel.org>; Sat, 21 May 2022 17:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ym9OYI6aJ18dYi6ySu0CCwN+bayr/dGSVhve9l8ISjg=;
        b=KuZEmJbmTHrLdBEmn5boklpye3PNVq3z35R6zKUmXg0RlkAzsG4CyYTiCnzxkhkqGD
         GB6w7g6sV4ZBxzS2DwB5mWHtHfOfY3iJ2KZO/qf1VT7nwta5JOduxZD839yew9ZyoORR
         DzQCoF/MYvAolWkUap0ikBmrWT56h5dm8pYfeY9c7RBdfAc8Tf55y/Ycu5+PQAUw3Nq6
         Q41ljgvVNVdYiFZDvTZUxylfjFw5xqSuu//w2dXtPKdpYzNVMBVoqXqDHxFhYekZbwjT
         0DlXaZ1rS5+PQUnNyPwdMH82GK3S8xnMcewmPUqzc8H397VOluhoAxYhaOPcfGMMai1q
         aWpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ym9OYI6aJ18dYi6ySu0CCwN+bayr/dGSVhve9l8ISjg=;
        b=cKJhptDT6cmJifdB1dUXAvCEHmIh2WJwhbcgbrAV5ffh/dLCZDM3x6Mbyl1jo9wv9V
         savWcr9mo77gK/boQs7gsEEF9AzZaaBHMrj7XbWXgmDWOaQGT9MO67j87jk7P7A2OtL4
         api21zkvZmlu0o4QkIuTZG9yanhGEi1i1dFg5oVgUrNwOYPY4gMza5sjCAvPvCOI3PtZ
         GML5IgXvCe+ufI/H8u3qAO19cfIcjAfq7c3IalCDPj+MjrneOSdTnUkFJZDCJu+qXRN9
         xSjB/toem4IZ2t3/pL5FVUeCtVhxBGSQstFfx2ElT7SLDyalzmaFZjG8eMm6r66fqeHO
         QUoA==
X-Gm-Message-State: AOAM530kiz11yn8Gjkf3aXlqlgKV2HpIdTy/ZApAYHL9vIWUq+t3VOH0
        9eE5sYrTXGkpWh6myIFh1WHi2A==
X-Google-Smtp-Source: ABdhPJwsYrD8/1poPZZ1cPHP4HJ2D5y/ecdDDDexSDvrGYSpusV9+UR1gE5e4fKnjHr/t7A7IZEo5A==
X-Received: by 2002:a05:6638:1486:b0:32b:e870:b2a7 with SMTP id j6-20020a056638148600b0032be870b2a7mr8571202jak.200.1653179553820;
        Sat, 21 May 2022 17:32:33 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id g8-20020a02c548000000b0032b5e78bfcbsm1757115jaj.135.2022.05.21.17.32.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 May 2022 17:32:33 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 7/9] net: ipa: remove command direction argument
Date:   Sat, 21 May 2022 19:32:21 -0500
Message-Id: <20220522003223.1123705-8-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220522003223.1123705-1-elder@linaro.org>
References: <20220522003223.1123705-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We no longer use the direction argument for gsi_trans_cmd_add(), so
get rid of it in its definition, and in its seven callers.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi_trans.c |  3 +--
 drivers/net/ipa/gsi_trans.h |  4 +---
 drivers/net/ipa/ipa_cmd.c   | 22 +++++++---------------
 3 files changed, 9 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ipa/gsi_trans.c b/drivers/net/ipa/gsi_trans.c
index cf8ee42373547..472792992f866 100644
--- a/drivers/net/ipa/gsi_trans.c
+++ b/drivers/net/ipa/gsi_trans.c
@@ -410,8 +410,7 @@ void gsi_trans_free(struct gsi_trans *trans)
 
 /* Add an immediate command to a transaction */
 void gsi_trans_cmd_add(struct gsi_trans *trans, void *buf, u32 size,
-		       dma_addr_t addr, enum dma_data_direction direction,
-		       enum ipa_cmd_opcode opcode)
+		       dma_addr_t addr, enum ipa_cmd_opcode opcode)
 {
 	u32 which = trans->used++;
 	struct scatterlist *sg;
diff --git a/drivers/net/ipa/gsi_trans.h b/drivers/net/ipa/gsi_trans.h
index 387ea50dd039e..9a39909915ef5 100644
--- a/drivers/net/ipa/gsi_trans.h
+++ b/drivers/net/ipa/gsi_trans.h
@@ -165,12 +165,10 @@ void gsi_trans_free(struct gsi_trans *trans);
  * @buf:	Buffer pointer for command payload
  * @size:	Number of bytes in buffer
  * @addr:	DMA address for payload
- * @direction:	Direction of DMA transfer (or DMA_NONE if none required)
  * @opcode:	IPA immediate command opcode
  */
 void gsi_trans_cmd_add(struct gsi_trans *trans, void *buf, u32 size,
-		       dma_addr_t addr, enum dma_data_direction direction,
-		       enum ipa_cmd_opcode opcode);
+		       dma_addr_t addr, enum ipa_cmd_opcode opcode);
 
 /**
  * gsi_trans_page_add() - Add a page transfer to a transaction
diff --git a/drivers/net/ipa/ipa_cmd.c b/drivers/net/ipa/ipa_cmd.c
index 77b84cea6e68f..5fd74d7007044 100644
--- a/drivers/net/ipa/ipa_cmd.c
+++ b/drivers/net/ipa/ipa_cmd.c
@@ -402,7 +402,6 @@ void ipa_cmd_table_init_add(struct gsi_trans *trans,
 			    dma_addr_t hash_addr)
 {
 	struct ipa *ipa = container_of(trans->gsi, struct ipa, gsi);
-	enum dma_data_direction direction = DMA_TO_DEVICE;
 	struct ipa_cmd_hw_ip_fltrt_init *payload;
 	union ipa_cmd_payload *cmd_payload;
 	dma_addr_t payload_addr;
@@ -433,7 +432,7 @@ void ipa_cmd_table_init_add(struct gsi_trans *trans,
 	payload->nhash_rules_addr = cpu_to_le64(addr);
 
 	gsi_trans_cmd_add(trans, payload, sizeof(*payload), payload_addr,
-			  direction, opcode);
+			  opcode);
 }
 
 /* Initialize header space in IPA-local memory */
@@ -442,7 +441,6 @@ void ipa_cmd_hdr_init_local_add(struct gsi_trans *trans, u32 offset, u16 size,
 {
 	struct ipa *ipa = container_of(trans->gsi, struct ipa, gsi);
 	enum ipa_cmd_opcode opcode = IPA_CMD_HDR_INIT_LOCAL;
-	enum dma_data_direction direction = DMA_TO_DEVICE;
 	struct ipa_cmd_hw_hdr_init_local *payload;
 	union ipa_cmd_payload *cmd_payload;
 	dma_addr_t payload_addr;
@@ -464,7 +462,7 @@ void ipa_cmd_hdr_init_local_add(struct gsi_trans *trans, u32 offset, u16 size,
 	payload->flags = cpu_to_le32(flags);
 
 	gsi_trans_cmd_add(trans, payload, sizeof(*payload), payload_addr,
-			  direction, opcode);
+			  opcode);
 }
 
 void ipa_cmd_register_write_add(struct gsi_trans *trans, u32 offset, u32 value,
@@ -521,7 +519,7 @@ void ipa_cmd_register_write_add(struct gsi_trans *trans, u32 offset, u32 value,
 	payload->clear_options = cpu_to_le32(options);
 
 	gsi_trans_cmd_add(trans, payload, sizeof(*payload), payload_addr,
-			  DMA_NONE, opcode);
+			  opcode);
 }
 
 /* Skip IP packet processing on the next data transfer on a TX channel */
@@ -529,7 +527,6 @@ static void ipa_cmd_ip_packet_init_add(struct gsi_trans *trans, u8 endpoint_id)
 {
 	struct ipa *ipa = container_of(trans->gsi, struct ipa, gsi);
 	enum ipa_cmd_opcode opcode = IPA_CMD_IP_PACKET_INIT;
-	enum dma_data_direction direction = DMA_TO_DEVICE;
 	struct ipa_cmd_ip_packet_init *payload;
 	union ipa_cmd_payload *cmd_payload;
 	dma_addr_t payload_addr;
@@ -541,7 +538,7 @@ static void ipa_cmd_ip_packet_init_add(struct gsi_trans *trans, u8 endpoint_id)
 					IPA_PACKET_INIT_DEST_ENDPOINT_FMASK);
 
 	gsi_trans_cmd_add(trans, payload, sizeof(*payload), payload_addr,
-			  direction, opcode);
+			  opcode);
 }
 
 /* Use a DMA command to read or write a block of IPA-resident memory */
@@ -552,7 +549,6 @@ void ipa_cmd_dma_shared_mem_add(struct gsi_trans *trans, u32 offset, u16 size,
 	enum ipa_cmd_opcode opcode = IPA_CMD_DMA_SHARED_MEM;
 	struct ipa_cmd_hw_dma_mem_mem *payload;
 	union ipa_cmd_payload *cmd_payload;
-	enum dma_data_direction direction;
 	dma_addr_t payload_addr;
 	u16 flags;
 
@@ -583,17 +579,14 @@ void ipa_cmd_dma_shared_mem_add(struct gsi_trans *trans, u32 offset, u16 size,
 	payload->flags = cpu_to_le16(flags);
 	payload->system_addr = cpu_to_le64(addr);
 
-	direction = toward_ipa ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
-
 	gsi_trans_cmd_add(trans, payload, sizeof(*payload), payload_addr,
-			  direction, opcode);
+			  opcode);
 }
 
 static void ipa_cmd_ip_tag_status_add(struct gsi_trans *trans)
 {
 	struct ipa *ipa = container_of(trans->gsi, struct ipa, gsi);
 	enum ipa_cmd_opcode opcode = IPA_CMD_IP_PACKET_TAG_STATUS;
-	enum dma_data_direction direction = DMA_TO_DEVICE;
 	struct ipa_cmd_ip_packet_tag_status *payload;
 	union ipa_cmd_payload *cmd_payload;
 	dma_addr_t payload_addr;
@@ -604,14 +597,13 @@ static void ipa_cmd_ip_tag_status_add(struct gsi_trans *trans)
 	payload->tag = le64_encode_bits(0, IP_PACKET_TAG_STATUS_TAG_FMASK);
 
 	gsi_trans_cmd_add(trans, payload, sizeof(*payload), payload_addr,
-			  direction, opcode);
+			  opcode);
 }
 
 /* Issue a small command TX data transfer */
 static void ipa_cmd_transfer_add(struct gsi_trans *trans)
 {
 	struct ipa *ipa = container_of(trans->gsi, struct ipa, gsi);
-	enum dma_data_direction direction = DMA_TO_DEVICE;
 	enum ipa_cmd_opcode opcode = IPA_CMD_NONE;
 	union ipa_cmd_payload *payload;
 	dma_addr_t payload_addr;
@@ -620,7 +612,7 @@ static void ipa_cmd_transfer_add(struct gsi_trans *trans)
 	payload = ipa_cmd_payload_alloc(ipa, &payload_addr);
 
 	gsi_trans_cmd_add(trans, payload, sizeof(*payload), payload_addr,
-			  direction, opcode);
+			  opcode);
 }
 
 /* Add immediate commands to a transaction to clear the hardware pipeline */
-- 
2.32.0

