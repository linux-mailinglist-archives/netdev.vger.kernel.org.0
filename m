Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F41B92B553F
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 00:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731158AbgKPXi2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 18:38:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731134AbgKPXi2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 18:38:28 -0500
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAE2AC0613D2
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 15:38:27 -0800 (PST)
Received: by mail-il1-x144.google.com with SMTP id l12so16936883ilo.1
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 15:38:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gPSHm2IegGABhxbsjS6ulWC/OyRLSfppgHa9K5huxaw=;
        b=qx7o6o1Xt3M+G/COTov6y3f100W0O/h849Yu1hZPFLpZi0d2Rf7DXd6KuWDDUNXuMv
         Clzy5zldwh/LpTA6Ch5mO9OmkewnDC32/ubtu1BEN9z7J5IZQJnAgm6YhBPYk9mzmAxr
         iiA3sLpfkg91ivgDLWAJgInb2pccCTZ4fpDlmL3FlFMQ+NUVy65XhrSx3hywxqvqnxil
         vUIQlDUJA8AJIX5ZxUyZJcKATYhakH1mqXBNvAlIgejQTziuOimXTlrCc8Y4ajT3sPDu
         sCBuuD3Vq5BZd+rv3w1onbbHN8DDFOqe7jrRbkMINFLwdmHsVaXJK8ZDeWu6DM0zXqjv
         3gUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gPSHm2IegGABhxbsjS6ulWC/OyRLSfppgHa9K5huxaw=;
        b=qEoNpU1Sl1YfvmkVelJpHWaFy9j6IDsq95p+2M581NlppUvsFrLX/UOf0JTiJZ7OXT
         NoX2lQQqCVkyV9x2hgtxTPaPjrSae8bqE6aaRKqyt3lVF3BRHPYO3cIPHXyW4wuODhxB
         IpFnhRRvxKGnOZRSiiZpenC4Aja8zzx4TnMU6bvmCaScEwIiCA1h1t02yoLrrneWLRzP
         d05vhCH16To7yZ/a/bJm2cCTQsDRkVxrxZYYEwbqBTgXvlyQzrlBjQCIlZCP+2+dNHA7
         tqyPuYX6J1qj2ffh1eFXJxvGPXzfCbVfwk0UxT1eDcd1h0bpiphptGL3wEiFAzucKz46
         kZ1Q==
X-Gm-Message-State: AOAM533S91kPJ5tlSlvIIbvm7xKVvVovaPur4o6sUBDk/ti7bpJj1LjI
        TG4QcDNkH7eh/Bf6lUfU8kFmHw==
X-Google-Smtp-Source: ABdhPJx3/dudmvBLS59y/8frsK7RCWBIgBUbLcKQwkRwv/Zu91o5pSLBZTH6O1CmEjI4LkBM9SQzBQ==
X-Received: by 2002:a05:6e02:e0b:: with SMTP id a11mr5280255ilk.256.1605569907286;
        Mon, 16 Nov 2020 15:38:27 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id f18sm10180099ill.22.2020.11.16.15.38.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 15:38:26 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 11/11] net: ipa: a few last IPA register cleanups
Date:   Mon, 16 Nov 2020 17:38:05 -0600
Message-Id: <20201116233805.13775-12-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201116233805.13775-1-elder@linaro.org>
References: <20201116233805.13775-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some last cleanups for the existing IPA register definitions:
  - Remove the definition of IPA_REG_ENABLED_PIPES_OFFSET, because
    it is not used.
  - Use "IPA_" instead of "BAM_" as the prefix on fields associated
    with the FLAVOR_0 register.  We use GSI (not BAM), but the
    fields apply to both GSI and BAM.
  - Get rid of the definition of IPA_CS_RSVD; it is never used.
  - Add two missing field mask definitions for the INIT_DEAGGR
    endpoint register.
  - Eliminate a few of the defined sequencer types, because they
    are unused.  We can add them back when needed.
  - Add a field mask to indicate which bit causes an interrupt on
    the microcontroller.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c |  6 +++---
 drivers/net/ipa/ipa_reg.h      | 21 +++++++--------------
 drivers/net/ipa/ipa_uc.c       |  7 ++++++-
 3 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 3c9bbe2bf81c9..9707300457517 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -1545,8 +1545,8 @@ int ipa_endpoint_config(struct ipa *ipa)
 	val = ioread32(ipa->reg_virt + IPA_REG_FLAVOR_0_OFFSET);
 
 	/* Our RX is an IPA producer */
-	rx_base = u32_get_bits(val, BAM_PROD_LOWEST_FMASK);
-	max = rx_base + u32_get_bits(val, BAM_MAX_PROD_PIPES_FMASK);
+	rx_base = u32_get_bits(val, IPA_PROD_LOWEST_FMASK);
+	max = rx_base + u32_get_bits(val, IPA_MAX_PROD_PIPES_FMASK);
 	if (max > IPA_ENDPOINT_MAX) {
 		dev_err(dev, "too many endpoints (%u > %u)\n",
 			max, IPA_ENDPOINT_MAX);
@@ -1555,7 +1555,7 @@ int ipa_endpoint_config(struct ipa *ipa)
 	rx_mask = GENMASK(max - 1, rx_base);
 
 	/* Our TX is an IPA consumer */
-	max = u32_get_bits(val, BAM_MAX_CONS_PIPES_FMASK);
+	max = u32_get_bits(val, IPA_MAX_CONS_PIPES_FMASK);
 	tx_mask = GENMASK(max - 1, 0);
 
 	ipa->available = rx_mask | tx_mask;
diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
index a3c1300b680bb..d02e7ecc6fc01 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -65,8 +65,6 @@ struct ipa;
  * of valid bits for the register.
  */
 
-#define IPA_REG_ENABLED_PIPES_OFFSET			0x00000038
-
 /* The next field is not supported for IPA v4.1 */
 #define IPA_REG_COMP_CFG_OFFSET				0x0000003c
 #define ENABLE_FMASK				GENMASK(0, 0)
@@ -248,10 +246,10 @@ static inline u32 ipa_aggr_granularity_val(u32 usec)
 #define SSPND_PA_NO_BQ_STATE_FMASK		GENMASK(19, 19)
 
 #define IPA_REG_FLAVOR_0_OFFSET				0x00000210
-#define BAM_MAX_PIPES_FMASK			GENMASK(4, 0)
-#define BAM_MAX_CONS_PIPES_FMASK		GENMASK(12, 8)
-#define BAM_MAX_PROD_PIPES_FMASK		GENMASK(20, 16)
-#define BAM_PROD_LOWEST_FMASK			GENMASK(27, 24)
+#define IPA_MAX_PIPES_FMASK			GENMASK(3, 0)
+#define IPA_MAX_CONS_PIPES_FMASK		GENMASK(12, 8)
+#define IPA_MAX_PROD_PIPES_FMASK		GENMASK(20, 16)
+#define IPA_PROD_LOWEST_FMASK			GENMASK(27, 24)
 
 static inline u32 ipa_reg_idle_indication_cfg_offset(enum ipa_version version)
 {
@@ -338,7 +336,6 @@ enum ipa_cs_offload_en {
 	IPA_CS_OFFLOAD_NONE		= 0x0,
 	IPA_CS_OFFLOAD_UL		= 0x1,
 	IPA_CS_OFFLOAD_DL		= 0x2,
-	IPA_CS_RSVD			= 0x3,
 };
 
 #define IPA_REG_ENDP_INIT_HDR_N_OFFSET(ep) \
@@ -429,8 +426,10 @@ enum ipa_aggr_type {
 #define IPA_REG_ENDP_INIT_DEAGGR_N_OFFSET(txep) \
 					(0x00000834 + 0x0070 * (txep))
 #define DEAGGR_HDR_LEN_FMASK			GENMASK(5, 0)
+#define SYSPIPE_ERR_DETECTION_FMASK		GENMASK(6, 6)
 #define PACKET_OFFSET_VALID_FMASK		GENMASK(7, 7)
 #define PACKET_OFFSET_LOCATION_FMASK		GENMASK(13, 8)
+#define IGNORE_MIN_PKT_ERR_FMASK		GENMASK(14, 14)
 #define MAX_PACKET_LEN_FMASK			GENMASK(31, 16)
 
 #define IPA_REG_ENDP_INIT_RSRC_GRP_N_OFFSET(ep) \
@@ -457,12 +456,8 @@ static inline u32 rsrc_grp_encoded(enum ipa_version version, u32 rsrc_grp)
 /**
  * enum ipa_seq_type - HPS and DPS sequencer type fields in ENDP_INIT_SEQ_N
  * @IPA_SEQ_DMA_ONLY:		only DMA is performed
- * @IPA_SEQ_PKT_PROCESS_NO_DEC_UCP:
- *	packet processing + no decipher + microcontroller (Ethernet Bridging)
  * @IPA_SEQ_2ND_PKT_PROCESS_PASS_NO_DEC_UCP:
  *	second packet processing pass + no decipher + microcontroller
- * @IPA_SEQ_DMA_DEC:		DMA + cipher/decipher
- * @IPA_SEQ_DMA_COMP_DECOMP:	DMA + compression/decompression
  * @IPA_SEQ_PKT_PROCESS_NO_DEC_NO_UCP_DMAP:
  *	packet processing + no decipher + no uCP + HPS REP DMA parser
  * @IPA_SEQ_INVALID:		invalid sequencer type
@@ -472,10 +467,7 @@ static inline u32 rsrc_grp_encoded(enum ipa_version version, u32 rsrc_grp)
  */
 enum ipa_seq_type {
 	IPA_SEQ_DMA_ONLY			= 0x0000,
-	IPA_SEQ_PKT_PROCESS_NO_DEC_UCP		= 0x0002,
 	IPA_SEQ_2ND_PKT_PROCESS_PASS_NO_DEC_UCP	= 0x0004,
-	IPA_SEQ_DMA_DEC				= 0x0011,
-	IPA_SEQ_DMA_COMP_DECOMP			= 0x0020,
 	IPA_SEQ_PKT_PROCESS_NO_DEC_NO_UCP_DMAP	= 0x0806,
 	IPA_SEQ_INVALID				= 0xffff,
 };
@@ -565,6 +557,7 @@ enum ipa_irq_id {
 				IPA_REG_IRQ_UC_EE_N_OFFSET(GSI_EE_AP)
 #define IPA_REG_IRQ_UC_EE_N_OFFSET(ee) \
 					(0x0000301c + 0x1000 * (ee))
+#define UC_INTR_FMASK				GENMASK(0, 0)
 
 /* ipa->available defines the valid bits in the SUSPEND_INFO register */
 #define IPA_REG_IRQ_SUSPEND_INFO_OFFSET \
diff --git a/drivers/net/ipa/ipa_uc.c b/drivers/net/ipa/ipa_uc.c
index be55f8a192d16..dee58a6596d41 100644
--- a/drivers/net/ipa/ipa_uc.c
+++ b/drivers/net/ipa/ipa_uc.c
@@ -192,14 +192,19 @@ void ipa_uc_teardown(struct ipa *ipa)
 static void send_uc_command(struct ipa *ipa, u32 command, u32 command_param)
 {
 	struct ipa_uc_mem_area *shared = ipa_uc_shared(ipa);
+	u32 val;
 
+	/* Fill in the command data */
 	shared->command = command;
 	shared->command_param = cpu_to_le32(command_param);
 	shared->command_param_hi = 0;
 	shared->response = 0;
 	shared->response_param = 0;
 
-	iowrite32(1, ipa->reg_virt + IPA_REG_IRQ_UC_OFFSET);
+	/* Use an interrupt to tell the microcontroller the command is ready */
+	val = u32_encode_bits(1, UC_INTR_FMASK);
+
+	iowrite32(val, ipa->reg_virt + IPA_REG_IRQ_UC_OFFSET);
 }
 
 /* Tell the microcontroller the AP is shutting down */
-- 
2.20.1

