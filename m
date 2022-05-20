Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 777C652F380
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 20:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238515AbiETS57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 14:57:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353116AbiETSzz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 14:55:55 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 872C320D
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 11:55:45 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id a10so9610415ioe.9
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 11:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ym9OYI6aJ18dYi6ySu0CCwN+bayr/dGSVhve9l8ISjg=;
        b=mE+FkCxojjAto0pFAfUskYPevpNUQG3yxDugA73zttAEJrz6DJGHZKArIc3V/MyhKv
         7k6pO2FApKI9LHhi8FWZH27wUzriLdyafR9dMWTPTi70tJm5ux7RbaiIcgi2Q8bzB7z0
         JD6B9TXVXxuhZ8BGYew5OCIjqtPmYsIBU6QIWoGsyzGGqoeotGHMsbUP6mB23v36liYe
         KJVJenndZklSunzaJ/dnRYISLzB2YM4k6YfINWGXRMFgZhXWAJINb+s1iZuvTywL9WYW
         cJtuedFc6AZ2TXU3ZfNyGfl7gxuuiTKZd37Blt8HmQHpflBOxgr4qTnjoS/tU33vqZPK
         Bf6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ym9OYI6aJ18dYi6ySu0CCwN+bayr/dGSVhve9l8ISjg=;
        b=C5QvPusEZkXkVulhBVOqe60uaLgai6y37keD0A/sIv7cJ36HfGjCPUkQdJmoI5a9mu
         zI4vg5Ra35s1nvvFNQt2mnLQ9bxCPnxJAK1X+fxgQA/G+y2tS3YMCgUdkiobJWZ8WmV9
         C3lJgIi8yDf08SiE3cYDh//TzHQJEPJOB/8aI0Qb/M1/b7lf/2WW9zVEO8lbXAEgcbtJ
         7NR3BgZ47Z1WZkBvGWZSaerwwu7kxjAOLbawZgc/+clfjwwxA4CKtwF8o4tQYMo1J0/D
         uDyzRLEcapSWq2hpS9m9pMeLzIqYnFJ2ad7X2qpjmvq5wSaKXV/XdXtdnLrNGBz29VPA
         VmKA==
X-Gm-Message-State: AOAM5329pY6VjaMn85cPekd015GZaVmO6npm8dtmprOLs4eCBgGoIKoI
        UgK3luzosRZGajeKCmxpUNInZw==
X-Google-Smtp-Source: ABdhPJwxnJzi0Gfwnd1RtO8u/aF4fAFkuBnZF97qyGGsGw1fSKRBlgxTNSAfkSZjXiBbBX1hc3in3w==
X-Received: by 2002:a05:6602:2019:b0:65e:5056:1df4 with SMTP id y25-20020a056602201900b0065e50561df4mr3614967iod.203.1653072944806;
        Fri, 20 May 2022 11:55:44 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id a6-20020a056638058600b0032b3a7817acsm871958jar.112.2022.05.20.11.55.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 May 2022 11:55:44 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 6/8] net: ipa: remove command direction argument
Date:   Fri, 20 May 2022 13:55:31 -0500
Message-Id: <20220520185533.877920-7-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220520185533.877920-1-elder@linaro.org>
References: <20220520185533.877920-1-elder@linaro.org>
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

