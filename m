Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3362B5539
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 00:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731078AbgKPXiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 18:38:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730834AbgKPXiX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 18:38:23 -0500
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76AC3C0613D3
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 15:38:23 -0800 (PST)
Received: by mail-il1-x144.google.com with SMTP id y18so9648169ilp.13
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 15:38:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5GWeNKnEAfbeU0hlToQQvZDeaFXUCPIWMIn5c6zgFUw=;
        b=e+pGys2Z+2aLDxHl0goyABoSPjymonFk6wQXM7vacYdDJgKAckRTg/1E4g+bAbvQvt
         aTt2POk1PWT2MG7IUTLDdBNfKJAodP3jJ/yO1qB8zbNLeaf0k13GOgtmz0AkeUd9Wk+v
         aVKXvW/D+12b07mAKWMALcpoFAxvbnFQETDGTF+0K7hHOVcRBXJ5JQdQZd/Fy8wljppO
         p7jDhIKBT2nWOcxUliSY2NOizabcaBh1PeILSIxKZZRE8XPFTZV4tl3ssZ69E24nJ9kS
         dz77lWy3Gbs+zIxn47vwshrOetIB9PRWfrUsk+SsfFMKgrW7HjLyFPCdVMgrRUQpfZMQ
         w6nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5GWeNKnEAfbeU0hlToQQvZDeaFXUCPIWMIn5c6zgFUw=;
        b=DnBaN1Rnhb/ltN2PUgS72S3R+6wCwGr4IoDXRZjtD1uNnbS9Ot0IlYUrmiNd40mQwV
         neq4lsN5CjLJqdohE80NG6umee8t337IUl8IQAiDq5XZB0f3gqnBfjKVw+gmi1Q+WAmu
         Poh7oyVAhvnzVDvIWKVkwwP4itgDM5ypYvinIBycn8mhikZ2sBFMzg5mXUe/csQ7z0r8
         xQBwnDcG31gG/yx8QGhGewIe2LGW+EbVh4/w22mh7qy0s1dbqf//xsiigbKP6Gujrf1p
         hIfwQLJRcaJf4sjXCmzHW+/O5F7GZpM+lqxUWzDR25GwlhM6RxArEXPsEJrjcd61q6ad
         A+Mw==
X-Gm-Message-State: AOAM5315Efj0qlNQUVMkLB/DRyq1BHVxu9MzVHdoS0iHvnBG7/e0OHIL
        weuMJSVIhYj7hnvGhut5UIZVtw==
X-Google-Smtp-Source: ABdhPJwNy2x9+q0YUGJh9GPZIDIYkPmHBN92VfG+loWtFt+9LTqm16Hp7KNkO6FWAj8LwdsrsUTqNQ==
X-Received: by 2002:a92:85cd:: with SMTP id f196mr9404775ilh.92.1605569902807;
        Mon, 16 Nov 2020 15:38:22 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id f18sm10180099ill.22.2020.11.16.15.38.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 15:38:22 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 07/11] net: ipa: define enumerated types consistently
Date:   Mon, 16 Nov 2020 17:38:01 -0600
Message-Id: <20201116233805.13775-8-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201116233805.13775-1-elder@linaro.org>
References: <20201116233805.13775-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Consistently define numeric values for enumerated type members using
hexidecimal (rather than decimal) format values.  Align the values
assigned in the same column in each file.

Only assign values where they really matter, for example don't
assign IPA_ENDPOINT_AP_MODEM_TX the value 0.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.h           | 20 +++++++++---------
 drivers/net/ipa/gsi_reg.h       | 25 ++++++++++++++++-------
 drivers/net/ipa/ipa_cmd.c       |  6 +++---
 drivers/net/ipa/ipa_cmd.h       | 21 +++++++++----------
 drivers/net/ipa/ipa_endpoint.h  |  2 +-
 drivers/net/ipa/ipa_interrupt.h |  6 +++---
 drivers/net/ipa/ipa_qmi_msg.h   | 12 +++++------
 drivers/net/ipa/ipa_reg.h       | 36 ++++++++++++++++-----------------
 drivers/net/ipa/ipa_uc.c        | 36 ++++++++++++++++-----------------
 9 files changed, 87 insertions(+), 77 deletions(-)

diff --git a/drivers/net/ipa/gsi.h b/drivers/net/ipa/gsi.h
index 758125737c8e9..ecc784e3a8127 100644
--- a/drivers/net/ipa/gsi.h
+++ b/drivers/net/ipa/gsi.h
@@ -33,10 +33,10 @@ struct ipa_gsi_endpoint_data;
 
 /* Execution environment IDs */
 enum gsi_ee_id {
-	GSI_EE_AP	= 0,
-	GSI_EE_MODEM	= 1,
-	GSI_EE_UC	= 2,
-	GSI_EE_TZ	= 3,
+	GSI_EE_AP				= 0x0,
+	GSI_EE_MODEM				= 0x1,
+	GSI_EE_UC				= 0x2,
+	GSI_EE_TZ				= 0x3,
 };
 
 struct gsi_ring {
@@ -96,12 +96,12 @@ struct gsi_trans_info {
 
 /* Hardware values signifying the state of a channel */
 enum gsi_channel_state {
-	GSI_CHANNEL_STATE_NOT_ALLOCATED	= 0x0,
-	GSI_CHANNEL_STATE_ALLOCATED	= 0x1,
-	GSI_CHANNEL_STATE_STARTED	= 0x2,
-	GSI_CHANNEL_STATE_STOPPED	= 0x3,
-	GSI_CHANNEL_STATE_STOP_IN_PROC	= 0x4,
-	GSI_CHANNEL_STATE_ERROR		= 0xf,
+	GSI_CHANNEL_STATE_NOT_ALLOCATED		= 0x0,
+	GSI_CHANNEL_STATE_ALLOCATED		= 0x1,
+	GSI_CHANNEL_STATE_STARTED		= 0x2,
+	GSI_CHANNEL_STATE_STOPPED		= 0x3,
+	GSI_CHANNEL_STATE_STOP_IN_PROC		= 0x4,
+	GSI_CHANNEL_STATE_ERROR			= 0xf,
 };
 
 /* We only care about channels between IPA and AP */
diff --git a/drivers/net/ipa/gsi_reg.h b/drivers/net/ipa/gsi_reg.h
index 8e3a7ffd19479..c1799d1e8a837 100644
--- a/drivers/net/ipa/gsi_reg.h
+++ b/drivers/net/ipa/gsi_reg.h
@@ -71,6 +71,7 @@
 #define ERINDEX_FMASK			GENMASK(18, 14)
 #define CHSTATE_FMASK			GENMASK(23, 20)
 #define ELEMENT_SIZE_FMASK		GENMASK(31, 24)
+
 /** enum gsi_channel_type - CHTYPE_PROTOCOL field values in CH_C_CNTXT_0 */
 enum gsi_channel_type {
 	GSI_CHANNEL_TYPE_MHI			= 0x0,
@@ -223,6 +224,7 @@ enum gsi_channel_type {
 			(0x0001f008 + 0x4000 * (ee))
 #define CH_CHID_FMASK			GENMASK(7, 0)
 #define CH_OPCODE_FMASK			GENMASK(31, 24)
+
 /** enum gsi_ch_cmd_opcode - CH_OPCODE field values in CH_CMD */
 enum gsi_ch_cmd_opcode {
 	GSI_CH_ALLOCATE				= 0x0,
@@ -238,6 +240,7 @@ enum gsi_ch_cmd_opcode {
 			(0x0001f010 + 0x4000 * (ee))
 #define EV_CHID_FMASK			GENMASK(7, 0)
 #define EV_OPCODE_FMASK			GENMASK(31, 24)
+
 /** enum gsi_evt_cmd_opcode - EV_OPCODE field values in EV_CH_CMD */
 enum gsi_evt_cmd_opcode {
 	GSI_EVT_ALLOCATE			= 0x0,
@@ -252,6 +255,7 @@ enum gsi_evt_cmd_opcode {
 #define GENERIC_OPCODE_FMASK		GENMASK(4, 0)
 #define GENERIC_CHID_FMASK		GENMASK(9, 5)
 #define GENERIC_EE_FMASK		GENMASK(13, 10)
+
 /** enum gsi_generic_cmd_opcode - GENERIC_OPCODE field values in GENERIC_CMD */
 enum gsi_generic_cmd_opcode {
 	GSI_GENERIC_HALT_CHANNEL		= 0x1,
@@ -275,6 +279,7 @@ enum gsi_generic_cmd_opcode {
 /* Fields below are present for IPA v4.2 and above */
 #define GSI_USE_RD_WR_ENG_FMASK		GENMASK(30, 30)
 #define GSI_USE_INTER_EE_FMASK		GENMASK(31, 31)
+
 /** enum gsi_iram_size - IRAM_SIZE field values in HW_PARAM_2 */
 enum gsi_iram_size {
 	IRAM_SIZE_ONE_KB			= 0x0,
@@ -293,15 +298,16 @@ enum gsi_iram_size {
 			GSI_EE_N_CNTXT_TYPE_IRQ_MSK_OFFSET(GSI_EE_AP)
 #define GSI_EE_N_CNTXT_TYPE_IRQ_MSK_OFFSET(ee) \
 			(0x0001f088 + 0x4000 * (ee))
+
 /* Values here are bit positions in the TYPE_IRQ and TYPE_IRQ_MSK registers */
 enum gsi_irq_type_id {
-	GSI_CH_CTRL		= 0,	/* channel allocation, etc.  */
-	GSI_EV_CTRL		= 1,	/* event ring allocation, etc. */
-	GSI_GLOB_EE		= 2,	/* global/general event */
-	GSI_IEOB		= 3,	/* TRE completion */
-	GSI_INTER_EE_CH_CTRL	= 4,	/* remote-issued stop/reset (unused) */
-	GSI_INTER_EE_EV_CTRL	= 5,	/* remote-issued event reset (unused) */
-	GSI_GENERAL		= 6,	/* general-purpose event */
+	GSI_CH_CTRL		= 0x0,	/* channel allocation, etc.  */
+	GSI_EV_CTRL		= 0x1,	/* event ring allocation, etc. */
+	GSI_GLOB_EE		= 0x2,	/* global/general event */
+	GSI_IEOB		= 0x3,	/* TRE completion */
+	GSI_INTER_EE_CH_CTRL	= 0x4,	/* remote-issued stop/reset (unused) */
+	GSI_INTER_EE_EV_CTRL	= 0x5,	/* remote-issued event reset (unused) */
+	GSI_GENERAL		= 0x6,	/* general-purpose event */
 };
 
 #define GSI_CNTXT_SRC_CH_IRQ_OFFSET \
@@ -406,6 +412,7 @@ enum gsi_general_id {
 #define ERR_VIRT_IDX_FMASK		GENMASK(23, 19)
 #define ERR_TYPE_FMASK			GENMASK(27, 24)
 #define ERR_EE_FMASK			GENMASK(31, 28)
+
 /** enum gsi_err_code - ERR_CODE field values in EE_ERR_LOG */
 enum gsi_err_code {
 	GSI_INVALID_TRE				= 0x1,
@@ -417,6 +424,7 @@ enum gsi_err_code {
 	/* 7 is not assigned */
 	GSI_HWO_1				= 0x8,
 };
+
 /** enum gsi_err_type - ERR_TYPE field values in EE_ERR_LOG */
 enum gsi_err_type {
 	GSI_ERR_TYPE_GLOB			= 0x1,
@@ -435,6 +443,8 @@ enum gsi_err_type {
 			(0x0001f400 + 0x4000 * (ee))
 #define INTER_EE_RESULT_FMASK		GENMASK(2, 0)
 #define GENERIC_EE_RESULT_FMASK		GENMASK(7, 5)
+
+/** enum gsi_generic_ee_result - GENERIC_EE_RESULT field values in SCRATCH_0 */
 enum gsi_generic_ee_result {
 	GENERIC_EE_SUCCESS			= 0x1,
 	GENERIC_EE_CHANNEL_NOT_RUNNING		= 0x2,
@@ -444,6 +454,7 @@ enum gsi_generic_ee_result {
 	GENERIC_EE_RETRY			= 0x6,
 	GENERIC_EE_NO_RESOURCES			= 0x7,
 };
+
 #define USB_MAX_PACKET_FMASK		GENMASK(15, 15)	/* 0: HS; 1: SS */
 #define MHI_BASE_CHANNEL_FMASK		GENMASK(31, 24)
 
diff --git a/drivers/net/ipa/ipa_cmd.c b/drivers/net/ipa/ipa_cmd.c
index d92dd3f09b735..002e514485100 100644
--- a/drivers/net/ipa/ipa_cmd.c
+++ b/drivers/net/ipa/ipa_cmd.c
@@ -38,9 +38,9 @@
 
 /* Some commands can wait until indicated pipeline stages are clear */
 enum pipeline_clear_options {
-	pipeline_clear_hps	= 0,
-	pipeline_clear_src_grp	= 1,
-	pipeline_clear_full	= 2,
+	pipeline_clear_hps		= 0x0,
+	pipeline_clear_src_grp		= 0x1,
+	pipeline_clear_full		= 0x2,
 };
 
 /* IPA_CMD_IP_V{4,6}_{FILTER,ROUTING}_INIT */
diff --git a/drivers/net/ipa/ipa_cmd.h b/drivers/net/ipa/ipa_cmd.h
index f7e6f87facf79..4ed09c486abc1 100644
--- a/drivers/net/ipa/ipa_cmd.h
+++ b/drivers/net/ipa/ipa_cmd.h
@@ -27,16 +27,16 @@ struct gsi_channel;
  * a request is *not* an immediate command.
  */
 enum ipa_cmd_opcode {
-	IPA_CMD_NONE			= 0,
-	IPA_CMD_IP_V4_FILTER_INIT	= 3,
-	IPA_CMD_IP_V6_FILTER_INIT	= 4,
-	IPA_CMD_IP_V4_ROUTING_INIT	= 7,
-	IPA_CMD_IP_V6_ROUTING_INIT	= 8,
-	IPA_CMD_HDR_INIT_LOCAL		= 9,
-	IPA_CMD_REGISTER_WRITE		= 12,
-	IPA_CMD_IP_PACKET_INIT		= 16,
-	IPA_CMD_DMA_SHARED_MEM		= 19,
-	IPA_CMD_IP_PACKET_TAG_STATUS	= 20,
+	IPA_CMD_NONE			= 0x0,
+	IPA_CMD_IP_V4_FILTER_INIT	= 0x3,
+	IPA_CMD_IP_V6_FILTER_INIT	= 0x4,
+	IPA_CMD_IP_V4_ROUTING_INIT	= 0x7,
+	IPA_CMD_IP_V6_ROUTING_INIT	= 0x8,
+	IPA_CMD_HDR_INIT_LOCAL		= 0x9,
+	IPA_CMD_REGISTER_WRITE		= 0xc,
+	IPA_CMD_IP_PACKET_INIT		= 0x10,
+	IPA_CMD_DMA_SHARED_MEM		= 0x13,
+	IPA_CMD_IP_PACKET_TAG_STATUS	= 0x14,
 };
 
 /**
@@ -50,7 +50,6 @@ struct ipa_cmd_info {
 	enum dma_data_direction direction;
 };
 
-
 #ifdef IPA_VALIDATE
 
 /**
diff --git a/drivers/net/ipa/ipa_endpoint.h b/drivers/net/ipa/ipa_endpoint.h
index 58a245de488e8..881ecc27bd6e3 100644
--- a/drivers/net/ipa/ipa_endpoint.h
+++ b/drivers/net/ipa/ipa_endpoint.h
@@ -25,7 +25,7 @@ struct ipa_gsi_endpoint_data;
 #define IPA_MTU			ETH_DATA_LEN
 
 enum ipa_endpoint_name {
-	IPA_ENDPOINT_AP_MODEM_TX	= 0,
+	IPA_ENDPOINT_AP_MODEM_TX,
 	IPA_ENDPOINT_MODEM_LAN_TX,
 	IPA_ENDPOINT_MODEM_COMMAND_TX,
 	IPA_ENDPOINT_AP_COMMAND_TX,
diff --git a/drivers/net/ipa/ipa_interrupt.h b/drivers/net/ipa/ipa_interrupt.h
index 727e9c5044d1e..b59e03a9f8e7f 100644
--- a/drivers/net/ipa/ipa_interrupt.h
+++ b/drivers/net/ipa/ipa_interrupt.h
@@ -22,9 +22,9 @@ struct ipa_interrupt;
  * for an AP RX endpoint whose underlying GSI channel is suspended/stopped.
  */
 enum ipa_irq_id {
-	IPA_IRQ_UC_0		= 2,
-	IPA_IRQ_UC_1		= 3,
-	IPA_IRQ_TX_SUSPEND	= 14,
+	IPA_IRQ_UC_0		= 0x2,
+	IPA_IRQ_UC_1		= 0x3,
+	IPA_IRQ_TX_SUSPEND	= 0xe,
 	IPA_IRQ_COUNT,		/* Number of interrupt types (not an index) */
 };
 
diff --git a/drivers/net/ipa/ipa_qmi_msg.h b/drivers/net/ipa/ipa_qmi_msg.h
index cfac456cea0ca..12b6621f4b0e6 100644
--- a/drivers/net/ipa/ipa_qmi_msg.h
+++ b/drivers/net/ipa/ipa_qmi_msg.h
@@ -74,12 +74,12 @@ struct ipa_init_complete_ind {
 
 /* The AP tells the modem its platform type.  We assume Android. */
 enum ipa_platform_type {
-	IPA_QMI_PLATFORM_TYPE_INVALID		= 0,	/* Invalid */
-	IPA_QMI_PLATFORM_TYPE_TN		= 1,	/* Data card */
-	IPA_QMI_PLATFORM_TYPE_LE		= 2,	/* Data router */
-	IPA_QMI_PLATFORM_TYPE_MSM_ANDROID	= 3,	/* Android MSM */
-	IPA_QMI_PLATFORM_TYPE_MSM_WINDOWS	= 4,	/* Windows MSM */
-	IPA_QMI_PLATFORM_TYPE_MSM_QNX_V01	= 5,	/* QNX MSM */
+	IPA_QMI_PLATFORM_TYPE_INVALID		= 0x0,	/* Invalid */
+	IPA_QMI_PLATFORM_TYPE_TN		= 0x1,	/* Data card */
+	IPA_QMI_PLATFORM_TYPE_LE		= 0x2,	/* Data router */
+	IPA_QMI_PLATFORM_TYPE_MSM_ANDROID	= 0x3,	/* Android MSM */
+	IPA_QMI_PLATFORM_TYPE_MSM_WINDOWS	= 0x4,	/* Windows MSM */
+	IPA_QMI_PLATFORM_TYPE_MSM_QNX_V01	= 0x5,	/* QNX MSM */
 };
 
 /* This defines the start and end offset of a range of memory.  Both
diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
index a05684785e577..4bc00d30ff774 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -481,36 +481,36 @@ static inline u32 rsrc_grp_encoded(enum ipa_version version, u32 rsrc_grp)
 
 /** enum ipa_cs_offload_en - checksum offload field in ENDP_INIT_CFG_N */
 enum ipa_cs_offload_en {
-	IPA_CS_OFFLOAD_NONE	= 0,
-	IPA_CS_OFFLOAD_UL	= 1,
-	IPA_CS_OFFLOAD_DL	= 2,
-	IPA_CS_RSVD
+	IPA_CS_OFFLOAD_NONE		= 0x0,
+	IPA_CS_OFFLOAD_UL		= 0x1,
+	IPA_CS_OFFLOAD_DL		= 0x2,
+	IPA_CS_RSVD			= 0x3,
 };
 
 /** enum ipa_aggr_en - aggregation enable field in ENDP_INIT_AGGR_N */
 enum ipa_aggr_en {
-	IPA_BYPASS_AGGR		= 0,
-	IPA_ENABLE_AGGR		= 1,
-	IPA_ENABLE_DEAGGR	= 2,
+	IPA_BYPASS_AGGR			= 0x0,
+	IPA_ENABLE_AGGR			= 0x1,
+	IPA_ENABLE_DEAGGR		= 0x2,
 };
 
 /** enum ipa_aggr_type - aggregation type field in in_ENDP_INIT_AGGR_N */
 enum ipa_aggr_type {
-	IPA_MBIM_16	= 0,
-	IPA_HDLC	= 1,
-	IPA_TLP		= 2,
-	IPA_RNDIS	= 3,
-	IPA_GENERIC	= 4,
-	IPA_COALESCE	= 5,
-	IPA_QCMAP	= 6,
+	IPA_MBIM_16			= 0x0,
+	IPA_HDLC			= 0x1,
+	IPA_TLP				= 0x2,
+	IPA_RNDIS			= 0x3,
+	IPA_GENERIC			= 0x4,
+	IPA_COALESCE			= 0x5,
+	IPA_QCMAP			= 0x6,
 };
 
 /** enum ipa_mode - mode field in ENDP_INIT_MODE_N */
 enum ipa_mode {
-	IPA_BASIC			= 0,
-	IPA_ENABLE_FRAMING_HDLC		= 1,
-	IPA_ENABLE_DEFRAMING_HDLC	= 2,
-	IPA_DMA				= 3,
+	IPA_BASIC			= 0x0,
+	IPA_ENABLE_FRAMING_HDLC		= 0x1,
+	IPA_ENABLE_DEFRAMING_HDLC	= 0x2,
+	IPA_DMA				= 0x3,
 };
 
 /**
diff --git a/drivers/net/ipa/ipa_uc.c b/drivers/net/ipa/ipa_uc.c
index 15bb357f3cfb1..be55f8a192d16 100644
--- a/drivers/net/ipa/ipa_uc.c
+++ b/drivers/net/ipa/ipa_uc.c
@@ -86,32 +86,32 @@ struct ipa_uc_mem_area {
 
 /** enum ipa_uc_command - commands from the AP to the microcontroller */
 enum ipa_uc_command {
-	IPA_UC_COMMAND_NO_OP		= 0,
-	IPA_UC_COMMAND_UPDATE_FLAGS	= 1,
-	IPA_UC_COMMAND_DEBUG_RUN_TEST	= 2,
-	IPA_UC_COMMAND_DEBUG_GET_INFO	= 3,
-	IPA_UC_COMMAND_ERR_FATAL	= 4,
-	IPA_UC_COMMAND_CLK_GATE		= 5,
-	IPA_UC_COMMAND_CLK_UNGATE	= 6,
-	IPA_UC_COMMAND_MEMCPY		= 7,
-	IPA_UC_COMMAND_RESET_PIPE	= 8,
-	IPA_UC_COMMAND_REG_WRITE	= 9,
-	IPA_UC_COMMAND_GSI_CH_EMPTY	= 10,
+	IPA_UC_COMMAND_NO_OP		= 0x0,
+	IPA_UC_COMMAND_UPDATE_FLAGS	= 0x1,
+	IPA_UC_COMMAND_DEBUG_RUN_TEST	= 0x2,
+	IPA_UC_COMMAND_DEBUG_GET_INFO	= 0x3,
+	IPA_UC_COMMAND_ERR_FATAL	= 0x4,
+	IPA_UC_COMMAND_CLK_GATE		= 0x5,
+	IPA_UC_COMMAND_CLK_UNGATE	= 0x6,
+	IPA_UC_COMMAND_MEMCPY		= 0x7,
+	IPA_UC_COMMAND_RESET_PIPE	= 0x8,
+	IPA_UC_COMMAND_REG_WRITE	= 0x9,
+	IPA_UC_COMMAND_GSI_CH_EMPTY	= 0xa,
 };
 
 /** enum ipa_uc_response - microcontroller response codes */
 enum ipa_uc_response {
-	IPA_UC_RESPONSE_NO_OP		= 0,
-	IPA_UC_RESPONSE_INIT_COMPLETED	= 1,
-	IPA_UC_RESPONSE_CMD_COMPLETED	= 2,
-	IPA_UC_RESPONSE_DEBUG_GET_INFO	= 3,
+	IPA_UC_RESPONSE_NO_OP		= 0x0,
+	IPA_UC_RESPONSE_INIT_COMPLETED	= 0x1,
+	IPA_UC_RESPONSE_CMD_COMPLETED	= 0x2,
+	IPA_UC_RESPONSE_DEBUG_GET_INFO	= 0x3,
 };
 
 /** enum ipa_uc_event - common cpu events reported by the microcontroller */
 enum ipa_uc_event {
-	IPA_UC_EVENT_NO_OP     = 0,
-	IPA_UC_EVENT_ERROR     = 1,
-	IPA_UC_EVENT_LOG_INFO  = 2,
+	IPA_UC_EVENT_NO_OP		= 0x0,
+	IPA_UC_EVENT_ERROR		= 0x1,
+	IPA_UC_EVENT_LOG_INFO		= 0x2,
 };
 
 static struct ipa_uc_mem_area *ipa_uc_shared(struct ipa *ipa)
-- 
2.20.1

