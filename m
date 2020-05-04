Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E78041C4AA6
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 01:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728551AbgEDXyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 19:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728482AbgEDXx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 19:53:58 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BAECC061A0F
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 16:53:58 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id v10so181502qvr.2
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 16:53:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=d/9GF7fGwRIqCk6Du1UKOadUaqr7KafAgxhMU9fZkoU=;
        b=UgoJ/n6ww+UMgFwyQHCKn8rgMm6w0uW8xyV5EnUYDDt5VoqjzjdoAtQOXZQCtv01t7
         ZpHlyPbEaURmvZQ0eSeeqlDfD+7gVHZUvlsWRFcDqq/zDUw9kJDrpOM/RrcM4pRflSvS
         o2Jg1N3eOSBoMCskiklFca8VyBSvxIIfvx+tqT93lqfSMA5hs4BsHQAnh0CU2oVs7uIU
         2PTG+8PHhp/G6oxi3NKaB8KjOML3Ggchh6wyID7EexF3eealZSJ1XlnFHgRtIuf8wV+A
         04CRE6jbie0/I92U+NVoDx0zelJLiA/3YpA5q2pCFxcP4OCGynetdsv+U/ajSbFjDJ09
         v6bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d/9GF7fGwRIqCk6Du1UKOadUaqr7KafAgxhMU9fZkoU=;
        b=B1AHY5D06Racx397gBAyFBpe+1ObHGChYaxLjta0/UpQESmhihDm2XGbJD/1lYWKl8
         zC870vOyyBCLT0G9KZx2QrYHHmNOgx7zWmkFM/nJ5TZzM6nmNDmodp+NxA8rdzrmhg3i
         ehaWghG5SKii1rI4WIh9goSFd04SjinmarRHmsIISk8hjX/RAb666yHKJ9PC5w+D7zQn
         svS1nzU1XdZqfcgq/Ut39FTb7Yod2yiV5y1erD6FXtwbdFR7J+JS6YD2xay4GLlbdjcl
         rZNP5heQMJn2PJ78AojxXBagMopzNfBB/cB/FqoBUzQowMjoKrjjV/pTV+dNy+yl5yHF
         omRA==
X-Gm-Message-State: AGi0PuYarf3hdo/ctSlQP50/VCtXUWNfM5RSY2yHA/sC+xrHdm4G7gaX
        P/zKYBNXlKm4JCW1VEWPJAi9uQ==
X-Google-Smtp-Source: APiQypKloUDbIE1xszOpiHPCeRygxLtLNdEXbfSMZ2rsM/aVi7Fpx3yBgEnxdb7alnZaF0/D2qWRVA==
X-Received: by 2002:a0c:b5dd:: with SMTP id o29mr129427qvf.87.1588636437509;
        Mon, 04 May 2020 16:53:57 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id z18sm296004qti.47.2020.05.04.16.53.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 16:53:57 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 5/5] net: ipa: kill ipa_cmd_dma_task_32b_addr_add()
Date:   Mon,  4 May 2020 18:53:45 -0500
Message-Id: <20200504235345.17118-6-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200504235345.17118-1-elder@linaro.org>
References: <20200504235345.17118-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A recent commit removed the only use of ipa_cmd_dma_task_32b_addr_add().
This function (and the IPA immediate command it implements) is no
longer needed, so get rid of it, along with all of the definitions
associated with it.  Isolate its removal in a commit so it can be
easily added back again if needed.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_cmd.c | 59 ---------------------------------------
 drivers/net/ipa/ipa_cmd.h | 11 --------
 2 files changed, 70 deletions(-)

diff --git a/drivers/net/ipa/ipa_cmd.c b/drivers/net/ipa/ipa_cmd.c
index d226b858742d..394f8a6df086 100644
--- a/drivers/net/ipa/ipa_cmd.c
+++ b/drivers/net/ipa/ipa_cmd.c
@@ -103,28 +103,6 @@ struct ipa_cmd_ip_packet_init {
 /* Field masks for ipa_cmd_ip_packet_init dest_endpoint field */
 #define IPA_PACKET_INIT_DEST_ENDPOINT_FMASK		GENMASK(4, 0)
 
-/* IPA_CMD_DMA_TASK_32B_ADDR */
-
-/* This opcode gets modified with a DMA operation count */
-
-#define DMA_TASK_32B_ADDR_OPCODE_COUNT_FMASK		GENMASK(15, 8)
-
-struct ipa_cmd_hw_dma_task_32b_addr {
-	__le16 flags;
-	__le16 size;
-	__le32 addr;
-	__le16 packet_size;
-	u8 reserved[6];
-};
-
-/* Field masks for ipa_cmd_hw_dma_task_32b_addr flags field */
-#define DMA_TASK_32B_ADDR_FLAGS_SW_RSVD_FMASK		GENMASK(10, 0)
-#define DMA_TASK_32B_ADDR_FLAGS_CMPLT_FMASK		GENMASK(11, 11)
-#define DMA_TASK_32B_ADDR_FLAGS_EOF_FMASK		GENMASK(12, 12)
-#define DMA_TASK_32B_ADDR_FLAGS_FLSH_FMASK		GENMASK(13, 13)
-#define DMA_TASK_32B_ADDR_FLAGS_LOCK_FMASK		GENMASK(14, 14)
-#define DMA_TASK_32B_ADDR_FLAGS_UNLOCK_FMASK		GENMASK(15, 15)
-
 /* IPA_CMD_DMA_SHARED_MEM */
 
 /* For IPA v4.0+, this opcode gets modified with pipeline clear options */
@@ -163,7 +141,6 @@ union ipa_cmd_payload {
 	struct ipa_cmd_hw_hdr_init_local hdr_init_local;
 	struct ipa_cmd_register_write register_write;
 	struct ipa_cmd_ip_packet_init ip_packet_init;
-	struct ipa_cmd_hw_dma_task_32b_addr dma_task_32b_addr;
 	struct ipa_cmd_hw_dma_mem_mem dma_shared_mem;
 	struct ipa_cmd_ip_packet_tag_status ip_packet_tag_status;
 };
@@ -508,42 +485,6 @@ static void ipa_cmd_ip_packet_init_add(struct gsi_trans *trans, u8 endpoint_id)
 			  direction, opcode);
 }
 
-/* Use a 32-bit DMA command to zero a block of memory */
-void ipa_cmd_dma_task_32b_addr_add(struct gsi_trans *trans, u16 size,
-				   dma_addr_t addr, bool toward_ipa)
-{
-	struct ipa *ipa = container_of(trans->gsi, struct ipa, gsi);
-	enum ipa_cmd_opcode opcode = IPA_CMD_DMA_TASK_32B_ADDR;
-	struct ipa_cmd_hw_dma_task_32b_addr *payload;
-	union ipa_cmd_payload *cmd_payload;
-	enum dma_data_direction direction;
-	dma_addr_t payload_addr;
-	u16 flags;
-
-	/* assert(addr <= U32_MAX); */
-	addr &= GENMASK_ULL(31, 0);
-
-	/* The opcode encodes the number of DMA operations in the high byte */
-	opcode |= u16_encode_bits(1, DMA_TASK_32B_ADDR_OPCODE_COUNT_FMASK);
-
-	direction = toward_ipa ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
-
-	/* complete: 0 = don't interrupt; eof: 0 = don't assert eot */
-	flags = DMA_TASK_32B_ADDR_FLAGS_FLSH_FMASK;
-	/* lock: 0 = don't lock endpoint; unlock: 0 = don't unlock */
-
-	cmd_payload = ipa_cmd_payload_alloc(ipa, &payload_addr);
-	payload = &cmd_payload->dma_task_32b_addr;
-
-	payload->flags = cpu_to_le16(flags);
-	payload->size = cpu_to_le16(size);
-	payload->addr = cpu_to_le32((u32)addr);
-	payload->packet_size = cpu_to_le16(size);
-
-	gsi_trans_cmd_add(trans, payload, sizeof(*payload), payload_addr,
-			  direction, opcode);
-}
-
 /* Use a DMA command to read or write a block of IPA-resident memory */
 void ipa_cmd_dma_shared_mem_add(struct gsi_trans *trans, u32 offset, u16 size,
 				dma_addr_t addr, bool toward_ipa)
diff --git a/drivers/net/ipa/ipa_cmd.h b/drivers/net/ipa/ipa_cmd.h
index 4917525b3a47..e440aa69c8b5 100644
--- a/drivers/net/ipa/ipa_cmd.h
+++ b/drivers/net/ipa/ipa_cmd.h
@@ -35,7 +35,6 @@ enum ipa_cmd_opcode {
 	IPA_CMD_HDR_INIT_LOCAL		= 9,
 	IPA_CMD_REGISTER_WRITE		= 12,
 	IPA_CMD_IP_PACKET_INIT		= 16,
-	IPA_CMD_DMA_TASK_32B_ADDR	= 17,
 	IPA_CMD_DMA_SHARED_MEM		= 19,
 	IPA_CMD_IP_PACKET_TAG_STATUS	= 20,
 };
@@ -147,16 +146,6 @@ void ipa_cmd_hdr_init_local_add(struct gsi_trans *trans, u32 offset, u16 size,
 void ipa_cmd_register_write_add(struct gsi_trans *trans, u32 offset, u32 value,
 				u32 mask, bool clear_full);
 
-/**
- * ipa_cmd_dma_task_32b_addr_add() - Add a 32-bit DMA command to a transaction
- * @trans:	GSi transaction
- * @size:	Number of bytes to be memory to be transferred
- * @addr:	DMA address of buffer to be read into or written from
- * @toward_ipa:	true means write to IPA memory; false means read
- */
-void ipa_cmd_dma_task_32b_addr_add(struct gsi_trans *trans, u16 size,
-				   dma_addr_t addr, bool toward_ipa);
-
 /**
  * ipa_cmd_dma_shared_mem_add() - Add a DMA memory command to a transaction
  * @trans:	GSI transaction
-- 
2.20.1

