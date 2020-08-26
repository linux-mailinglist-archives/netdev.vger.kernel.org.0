Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC80D252A1E
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 11:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728267AbgHZJe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 05:34:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728218AbgHZJeM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 05:34:12 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BB17C061796
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 02:34:07 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id t14so1075044wmi.3
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 02:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uwbCqiTBl/wKxh4DcTsocNb+vRBe+bY6F3lNqQhTk0s=;
        b=DJRPaWgTTIrZ0n3QQ+Am6nHcew+nES64DHCa3mD4TYh2BjYwbfXF1iWQMTCo1q4Lv2
         D3Q8tLVe8Eu9qrpuLAcUU0jbM2a8yXelCzXiQ5caz7Ctnn5rC0DXINCEcL+fuOFCoJsC
         OTTD6FbsUTPTfEEpRiox7e0NqdyYv6m4KiSWk4hudvOgWd5c0lTRFfC2qPMMbjKItvh3
         djxLse9kccPsQMFq53Q76Ca2PFXRECn0EN/JAf7iWEslf3K7XK6uvOFuI3moGGvDtI2/
         OP6LxVshT6ZXonfN9k6zzLBiwGd3FfRfp20Ow4dLZ/pyvn0E7O+RRiNqGlZYhs+IVs26
         dLrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uwbCqiTBl/wKxh4DcTsocNb+vRBe+bY6F3lNqQhTk0s=;
        b=dFHGoRlvku5FHfttJbfZ9KQG8FdUOz4U4j7nrdcKplbxfNtRBzsSaZiYOKnoaX/hYY
         rz17lbTub1XXa9lt7nepp6bL5JsLCNnvJ4cFlaK2Y1cPFGuIKuPfoJPuKqLFUhq2f8zQ
         SauP9G4sl8xJv8i0fp+FFMINOqybieGx7N4KOq8NsVAcBss7RvtQcfqcsGZpmjjrdcNy
         eJNzLTmL94dVO6+L3kkWy8NuwUPw6/2gufNFc05B9PIr6ZvnAM4GFgKiNgWIUU2trNj5
         GA/RaNmFgsqd3rShnRpyuA52dTufbQh4C6mui1yII1iZPkhJ3BvPhbo465SzUxqr6b4e
         UTRg==
X-Gm-Message-State: AOAM531zXUA7MxqP0nkPXfCp2ofDol2WCFIK/lO37k9dwE4gor2kSX3j
        Dk0VvVEolhdTWO8tHjmDhvoQ0A==
X-Google-Smtp-Source: ABdhPJzyH2bcspBXxsAw0cxlWjSOA9v1zC0baKrNmnG1lxjwVzdU31m46ydIEud/+UrtqV2AaECjMQ==
X-Received: by 2002:a1c:c913:: with SMTP id f19mr5943965wmb.173.1598434445831;
        Wed, 26 Aug 2020 02:34:05 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id u3sm3978759wml.44.2020.08.26.02.34.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 02:34:05 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>
Subject: [PATCH 01/30] wireless: marvell: mwifiex: pcie: Move tables to the only place they're used
Date:   Wed, 26 Aug 2020 10:33:32 +0100
Message-Id: <20200826093401.1458456-2-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200826093401.1458456-1-lee.jones@linaro.org>
References: <20200826093401.1458456-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Saves on 10's of complains about 'defined but not used' variables.

Fixes the following W=1 kernel build warning(s):

 In file included from drivers/net/wireless/marvell/mwifiex/main.h:57,
 from drivers/net/wireless/marvell/mwifiex/main.c:22:
 drivers/net/wireless/marvell/mwifiex/pcie.h:310:41: warning: ‘mwifiex_pcie8997’ defined but not used [-Wunused-const-variable=]
 310 | static const struct mwifiex_pcie_device mwifiex_pcie8997 = {
 | ^~~~~~~~~~~~~~~~
 drivers/net/wireless/marvell/mwifiex/pcie.h:300:41: warning: ‘mwifiex_pcie8897’ defined but not used [-Wunused-const-variable=]
 300 | static const struct mwifiex_pcie_device mwifiex_pcie8897 = {
 | ^~~~~~~~~~~~~~~~
 drivers/net/wireless/marvell/mwifiex/pcie.h:292:41: warning: ‘mwifiex_pcie8766’ defined but not used [-Wunused-const-variable=]
 292 | static const struct mwifiex_pcie_device mwifiex_pcie8766 = {
 | ^~~~~~~~~~~~~~~~

 NB: Repeats 10's of times - snipped for brevity.

Cc: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: Ganapathi Bhat <ganapathi.bhat@nxp.com>
Cc: Xinming Hu <huxinming820@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 149 ++++++++++++++++++++
 drivers/net/wireless/marvell/mwifiex/pcie.h | 149 --------------------
 2 files changed, 149 insertions(+), 149 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 87b4ccca4b9a2..a9173a88e6151 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -33,6 +33,155 @@
 
 static struct mwifiex_if_ops pcie_ops;
 
+static const struct mwifiex_pcie_card_reg mwifiex_reg_8766 = {
+	.cmd_addr_lo = PCIE_SCRATCH_0_REG,
+	.cmd_addr_hi = PCIE_SCRATCH_1_REG,
+	.cmd_size = PCIE_SCRATCH_2_REG,
+	.fw_status = PCIE_SCRATCH_3_REG,
+	.cmdrsp_addr_lo = PCIE_SCRATCH_4_REG,
+	.cmdrsp_addr_hi = PCIE_SCRATCH_5_REG,
+	.tx_rdptr = PCIE_SCRATCH_6_REG,
+	.tx_wrptr = PCIE_SCRATCH_7_REG,
+	.rx_rdptr = PCIE_SCRATCH_8_REG,
+	.rx_wrptr = PCIE_SCRATCH_9_REG,
+	.evt_rdptr = PCIE_SCRATCH_10_REG,
+	.evt_wrptr = PCIE_SCRATCH_11_REG,
+	.drv_rdy = PCIE_SCRATCH_12_REG,
+	.tx_start_ptr = 0,
+	.tx_mask = MWIFIEX_TXBD_MASK,
+	.tx_wrap_mask = 0,
+	.rx_mask = MWIFIEX_RXBD_MASK,
+	.rx_wrap_mask = 0,
+	.tx_rollover_ind = MWIFIEX_BD_FLAG_ROLLOVER_IND,
+	.rx_rollover_ind = MWIFIEX_BD_FLAG_ROLLOVER_IND,
+	.evt_rollover_ind = MWIFIEX_BD_FLAG_ROLLOVER_IND,
+	.ring_flag_sop = 0,
+	.ring_flag_eop = 0,
+	.ring_flag_xs_sop = 0,
+	.ring_flag_xs_eop = 0,
+	.ring_tx_start_ptr = 0,
+	.pfu_enabled = 0,
+	.sleep_cookie = 1,
+	.msix_support = 0,
+};
+
+static const struct mwifiex_pcie_card_reg mwifiex_reg_8897 = {
+	.cmd_addr_lo = PCIE_SCRATCH_0_REG,
+	.cmd_addr_hi = PCIE_SCRATCH_1_REG,
+	.cmd_size = PCIE_SCRATCH_2_REG,
+	.fw_status = PCIE_SCRATCH_3_REG,
+	.cmdrsp_addr_lo = PCIE_SCRATCH_4_REG,
+	.cmdrsp_addr_hi = PCIE_SCRATCH_5_REG,
+	.tx_rdptr = PCIE_RD_DATA_PTR_Q0_Q1,
+	.tx_wrptr = PCIE_WR_DATA_PTR_Q0_Q1,
+	.rx_rdptr = PCIE_WR_DATA_PTR_Q0_Q1,
+	.rx_wrptr = PCIE_RD_DATA_PTR_Q0_Q1,
+	.evt_rdptr = PCIE_SCRATCH_10_REG,
+	.evt_wrptr = PCIE_SCRATCH_11_REG,
+	.drv_rdy = PCIE_SCRATCH_12_REG,
+	.tx_start_ptr = 16,
+	.tx_mask = 0x03FF0000,
+	.tx_wrap_mask = 0x07FF0000,
+	.rx_mask = 0x000003FF,
+	.rx_wrap_mask = 0x000007FF,
+	.tx_rollover_ind = MWIFIEX_BD_FLAG_TX_ROLLOVER_IND,
+	.rx_rollover_ind = MWIFIEX_BD_FLAG_RX_ROLLOVER_IND,
+	.evt_rollover_ind = MWIFIEX_BD_FLAG_EVT_ROLLOVER_IND,
+	.ring_flag_sop = MWIFIEX_BD_FLAG_SOP,
+	.ring_flag_eop = MWIFIEX_BD_FLAG_EOP,
+	.ring_flag_xs_sop = MWIFIEX_BD_FLAG_XS_SOP,
+	.ring_flag_xs_eop = MWIFIEX_BD_FLAG_XS_EOP,
+	.ring_tx_start_ptr = MWIFIEX_BD_FLAG_TX_START_PTR,
+	.pfu_enabled = 1,
+	.sleep_cookie = 0,
+	.fw_dump_ctrl = PCIE_SCRATCH_13_REG,
+	.fw_dump_start = PCIE_SCRATCH_14_REG,
+	.fw_dump_end = 0xcff,
+	.fw_dump_host_ready = 0xee,
+	.fw_dump_read_done = 0xfe,
+	.msix_support = 0,
+};
+
+static const struct mwifiex_pcie_card_reg mwifiex_reg_8997 = {
+	.cmd_addr_lo = PCIE_SCRATCH_0_REG,
+	.cmd_addr_hi = PCIE_SCRATCH_1_REG,
+	.cmd_size = PCIE_SCRATCH_2_REG,
+	.fw_status = PCIE_SCRATCH_3_REG,
+	.cmdrsp_addr_lo = PCIE_SCRATCH_4_REG,
+	.cmdrsp_addr_hi = PCIE_SCRATCH_5_REG,
+	.tx_rdptr = 0xC1A4,
+	.tx_wrptr = 0xC174,
+	.rx_rdptr = 0xC174,
+	.rx_wrptr = 0xC1A4,
+	.evt_rdptr = PCIE_SCRATCH_10_REG,
+	.evt_wrptr = PCIE_SCRATCH_11_REG,
+	.drv_rdy = PCIE_SCRATCH_12_REG,
+	.tx_start_ptr = 16,
+	.tx_mask = 0x0FFF0000,
+	.tx_wrap_mask = 0x1FFF0000,
+	.rx_mask = 0x00000FFF,
+	.rx_wrap_mask = 0x00001FFF,
+	.tx_rollover_ind = BIT(28),
+	.rx_rollover_ind = BIT(12),
+	.evt_rollover_ind = MWIFIEX_BD_FLAG_EVT_ROLLOVER_IND,
+	.ring_flag_sop = MWIFIEX_BD_FLAG_SOP,
+	.ring_flag_eop = MWIFIEX_BD_FLAG_EOP,
+	.ring_flag_xs_sop = MWIFIEX_BD_FLAG_XS_SOP,
+	.ring_flag_xs_eop = MWIFIEX_BD_FLAG_XS_EOP,
+	.ring_tx_start_ptr = MWIFIEX_BD_FLAG_TX_START_PTR,
+	.pfu_enabled = 1,
+	.sleep_cookie = 0,
+	.fw_dump_ctrl = PCIE_SCRATCH_13_REG,
+	.fw_dump_start = PCIE_SCRATCH_14_REG,
+	.fw_dump_end = 0xcff,
+	.fw_dump_host_ready = 0xcc,
+	.fw_dump_read_done = 0xdd,
+	.msix_support = 0,
+};
+
+static struct memory_type_mapping mem_type_mapping_tbl_w8897[] = {
+	{"ITCM", NULL, 0, 0xF0},
+	{"DTCM", NULL, 0, 0xF1},
+	{"SQRAM", NULL, 0, 0xF2},
+	{"IRAM", NULL, 0, 0xF3},
+	{"APU", NULL, 0, 0xF4},
+	{"CIU", NULL, 0, 0xF5},
+	{"ICU", NULL, 0, 0xF6},
+	{"MAC", NULL, 0, 0xF7},
+};
+
+static struct memory_type_mapping mem_type_mapping_tbl_w8997[] = {
+	{"DUMP", NULL, 0, 0xDD},
+};
+
+static const struct mwifiex_pcie_device mwifiex_pcie8766 = {
+	.reg            = &mwifiex_reg_8766,
+	.blksz_fw_dl = MWIFIEX_PCIE_BLOCK_SIZE_FW_DNLD,
+	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K,
+	.can_dump_fw = false,
+	.can_ext_scan = true,
+};
+
+static const struct mwifiex_pcie_device mwifiex_pcie8897 = {
+	.reg            = &mwifiex_reg_8897,
+	.blksz_fw_dl = MWIFIEX_PCIE_BLOCK_SIZE_FW_DNLD,
+	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_4K,
+	.can_dump_fw = true,
+	.mem_type_mapping_tbl = mem_type_mapping_tbl_w8897,
+	.num_mem_types = ARRAY_SIZE(mem_type_mapping_tbl_w8897),
+	.can_ext_scan = true,
+};
+
+static const struct mwifiex_pcie_device mwifiex_pcie8997 = {
+	.reg            = &mwifiex_reg_8997,
+	.blksz_fw_dl = MWIFIEX_PCIE_BLOCK_SIZE_FW_DNLD,
+	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_4K,
+	.can_dump_fw = true,
+	.mem_type_mapping_tbl = mem_type_mapping_tbl_w8997,
+	.num_mem_types = ARRAY_SIZE(mem_type_mapping_tbl_w8997),
+	.can_ext_scan = true,
+};
+
 static const struct of_device_id mwifiex_pcie_of_match_table[] = {
 	{ .compatible = "pci11ab,2b42" },
 	{ .compatible = "pci1b4b,2b42" },
diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.h b/drivers/net/wireless/marvell/mwifiex/pcie.h
index fc59b522f6701..843d57eda8201 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.h
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.h
@@ -158,127 +158,6 @@ struct mwifiex_pcie_card_reg {
 	u8 msix_support;
 };
 
-static const struct mwifiex_pcie_card_reg mwifiex_reg_8766 = {
-	.cmd_addr_lo = PCIE_SCRATCH_0_REG,
-	.cmd_addr_hi = PCIE_SCRATCH_1_REG,
-	.cmd_size = PCIE_SCRATCH_2_REG,
-	.fw_status = PCIE_SCRATCH_3_REG,
-	.cmdrsp_addr_lo = PCIE_SCRATCH_4_REG,
-	.cmdrsp_addr_hi = PCIE_SCRATCH_5_REG,
-	.tx_rdptr = PCIE_SCRATCH_6_REG,
-	.tx_wrptr = PCIE_SCRATCH_7_REG,
-	.rx_rdptr = PCIE_SCRATCH_8_REG,
-	.rx_wrptr = PCIE_SCRATCH_9_REG,
-	.evt_rdptr = PCIE_SCRATCH_10_REG,
-	.evt_wrptr = PCIE_SCRATCH_11_REG,
-	.drv_rdy = PCIE_SCRATCH_12_REG,
-	.tx_start_ptr = 0,
-	.tx_mask = MWIFIEX_TXBD_MASK,
-	.tx_wrap_mask = 0,
-	.rx_mask = MWIFIEX_RXBD_MASK,
-	.rx_wrap_mask = 0,
-	.tx_rollover_ind = MWIFIEX_BD_FLAG_ROLLOVER_IND,
-	.rx_rollover_ind = MWIFIEX_BD_FLAG_ROLLOVER_IND,
-	.evt_rollover_ind = MWIFIEX_BD_FLAG_ROLLOVER_IND,
-	.ring_flag_sop = 0,
-	.ring_flag_eop = 0,
-	.ring_flag_xs_sop = 0,
-	.ring_flag_xs_eop = 0,
-	.ring_tx_start_ptr = 0,
-	.pfu_enabled = 0,
-	.sleep_cookie = 1,
-	.msix_support = 0,
-};
-
-static const struct mwifiex_pcie_card_reg mwifiex_reg_8897 = {
-	.cmd_addr_lo = PCIE_SCRATCH_0_REG,
-	.cmd_addr_hi = PCIE_SCRATCH_1_REG,
-	.cmd_size = PCIE_SCRATCH_2_REG,
-	.fw_status = PCIE_SCRATCH_3_REG,
-	.cmdrsp_addr_lo = PCIE_SCRATCH_4_REG,
-	.cmdrsp_addr_hi = PCIE_SCRATCH_5_REG,
-	.tx_rdptr = PCIE_RD_DATA_PTR_Q0_Q1,
-	.tx_wrptr = PCIE_WR_DATA_PTR_Q0_Q1,
-	.rx_rdptr = PCIE_WR_DATA_PTR_Q0_Q1,
-	.rx_wrptr = PCIE_RD_DATA_PTR_Q0_Q1,
-	.evt_rdptr = PCIE_SCRATCH_10_REG,
-	.evt_wrptr = PCIE_SCRATCH_11_REG,
-	.drv_rdy = PCIE_SCRATCH_12_REG,
-	.tx_start_ptr = 16,
-	.tx_mask = 0x03FF0000,
-	.tx_wrap_mask = 0x07FF0000,
-	.rx_mask = 0x000003FF,
-	.rx_wrap_mask = 0x000007FF,
-	.tx_rollover_ind = MWIFIEX_BD_FLAG_TX_ROLLOVER_IND,
-	.rx_rollover_ind = MWIFIEX_BD_FLAG_RX_ROLLOVER_IND,
-	.evt_rollover_ind = MWIFIEX_BD_FLAG_EVT_ROLLOVER_IND,
-	.ring_flag_sop = MWIFIEX_BD_FLAG_SOP,
-	.ring_flag_eop = MWIFIEX_BD_FLAG_EOP,
-	.ring_flag_xs_sop = MWIFIEX_BD_FLAG_XS_SOP,
-	.ring_flag_xs_eop = MWIFIEX_BD_FLAG_XS_EOP,
-	.ring_tx_start_ptr = MWIFIEX_BD_FLAG_TX_START_PTR,
-	.pfu_enabled = 1,
-	.sleep_cookie = 0,
-	.fw_dump_ctrl = PCIE_SCRATCH_13_REG,
-	.fw_dump_start = PCIE_SCRATCH_14_REG,
-	.fw_dump_end = 0xcff,
-	.fw_dump_host_ready = 0xee,
-	.fw_dump_read_done = 0xfe,
-	.msix_support = 0,
-};
-
-static const struct mwifiex_pcie_card_reg mwifiex_reg_8997 = {
-	.cmd_addr_lo = PCIE_SCRATCH_0_REG,
-	.cmd_addr_hi = PCIE_SCRATCH_1_REG,
-	.cmd_size = PCIE_SCRATCH_2_REG,
-	.fw_status = PCIE_SCRATCH_3_REG,
-	.cmdrsp_addr_lo = PCIE_SCRATCH_4_REG,
-	.cmdrsp_addr_hi = PCIE_SCRATCH_5_REG,
-	.tx_rdptr = 0xC1A4,
-	.tx_wrptr = 0xC174,
-	.rx_rdptr = 0xC174,
-	.rx_wrptr = 0xC1A4,
-	.evt_rdptr = PCIE_SCRATCH_10_REG,
-	.evt_wrptr = PCIE_SCRATCH_11_REG,
-	.drv_rdy = PCIE_SCRATCH_12_REG,
-	.tx_start_ptr = 16,
-	.tx_mask = 0x0FFF0000,
-	.tx_wrap_mask = 0x1FFF0000,
-	.rx_mask = 0x00000FFF,
-	.rx_wrap_mask = 0x00001FFF,
-	.tx_rollover_ind = BIT(28),
-	.rx_rollover_ind = BIT(12),
-	.evt_rollover_ind = MWIFIEX_BD_FLAG_EVT_ROLLOVER_IND,
-	.ring_flag_sop = MWIFIEX_BD_FLAG_SOP,
-	.ring_flag_eop = MWIFIEX_BD_FLAG_EOP,
-	.ring_flag_xs_sop = MWIFIEX_BD_FLAG_XS_SOP,
-	.ring_flag_xs_eop = MWIFIEX_BD_FLAG_XS_EOP,
-	.ring_tx_start_ptr = MWIFIEX_BD_FLAG_TX_START_PTR,
-	.pfu_enabled = 1,
-	.sleep_cookie = 0,
-	.fw_dump_ctrl = PCIE_SCRATCH_13_REG,
-	.fw_dump_start = PCIE_SCRATCH_14_REG,
-	.fw_dump_end = 0xcff,
-	.fw_dump_host_ready = 0xcc,
-	.fw_dump_read_done = 0xdd,
-	.msix_support = 0,
-};
-
-static struct memory_type_mapping mem_type_mapping_tbl_w8897[] = {
-	{"ITCM", NULL, 0, 0xF0},
-	{"DTCM", NULL, 0, 0xF1},
-	{"SQRAM", NULL, 0, 0xF2},
-	{"IRAM", NULL, 0, 0xF3},
-	{"APU", NULL, 0, 0xF4},
-	{"CIU", NULL, 0, 0xF5},
-	{"ICU", NULL, 0, 0xF6},
-	{"MAC", NULL, 0, 0xF7},
-};
-
-static struct memory_type_mapping mem_type_mapping_tbl_w8997[] = {
-	{"DUMP", NULL, 0, 0xDD},
-};
-
 struct mwifiex_pcie_device {
 	const struct mwifiex_pcie_card_reg *reg;
 	u16 blksz_fw_dl;
@@ -289,34 +168,6 @@ struct mwifiex_pcie_device {
 	bool can_ext_scan;
 };
 
-static const struct mwifiex_pcie_device mwifiex_pcie8766 = {
-	.reg            = &mwifiex_reg_8766,
-	.blksz_fw_dl = MWIFIEX_PCIE_BLOCK_SIZE_FW_DNLD,
-	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K,
-	.can_dump_fw = false,
-	.can_ext_scan = true,
-};
-
-static const struct mwifiex_pcie_device mwifiex_pcie8897 = {
-	.reg            = &mwifiex_reg_8897,
-	.blksz_fw_dl = MWIFIEX_PCIE_BLOCK_SIZE_FW_DNLD,
-	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_4K,
-	.can_dump_fw = true,
-	.mem_type_mapping_tbl = mem_type_mapping_tbl_w8897,
-	.num_mem_types = ARRAY_SIZE(mem_type_mapping_tbl_w8897),
-	.can_ext_scan = true,
-};
-
-static const struct mwifiex_pcie_device mwifiex_pcie8997 = {
-	.reg            = &mwifiex_reg_8997,
-	.blksz_fw_dl = MWIFIEX_PCIE_BLOCK_SIZE_FW_DNLD,
-	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_4K,
-	.can_dump_fw = true,
-	.mem_type_mapping_tbl = mem_type_mapping_tbl_w8997,
-	.num_mem_types = ARRAY_SIZE(mem_type_mapping_tbl_w8997),
-	.can_ext_scan = true,
-};
-
 struct mwifiex_evt_buf_desc {
 	u64 paddr;
 	u16 len;
-- 
2.25.1

