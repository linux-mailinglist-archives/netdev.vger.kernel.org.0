Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F21225AC9E
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 16:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727935AbgIBOLl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 10:11:41 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:34372 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727990AbgIBOK7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Sep 2020 10:10:59 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id B87EA5D84FDB52B783ED;
        Wed,  2 Sep 2020 22:10:25 +0800 (CST)
Received: from localhost (10.174.179.108) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.487.0; Wed, 2 Sep 2020
 22:10:14 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <amitkarwar@gmail.com>, <ganapathi.bhat@nxp.com>,
        <huxinming820@gmail.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <christophe.jaillet@wanadoo.fr>, <yuehaibing@huawei.com>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] mwifiex: pcie: Fix -Wunused-const-variable warnings
Date:   Wed, 2 Sep 2020 22:09:33 +0800
Message-ID: <20200902140933.25852-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.108]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These variables only used in pcie.c, move them to .c file
can silence these warnings:

In file included from drivers/net/wireless/marvell/mwifiex/main.h:57:0,
                 from drivers/net/wireless/marvell/mwifiex/init.c:24:
drivers/net/wireless/marvell/mwifiex/pcie.h:310:41: warning: mwifiex_pcie8997 defined but not used [-Wunused-const-variable=]
 static const struct mwifiex_pcie_device mwifiex_pcie8997 = {
                                         ^~~~~~~~~~~~~~~~
drivers/net/wireless/marvell/mwifiex/pcie.h:300:41: warning: mwifiex_pcie8897 defined but not used [-Wunused-const-variable=]
 static const struct mwifiex_pcie_device mwifiex_pcie8897 = {
                                         ^~~~~~~~~~~~~~~~
drivers/net/wireless/marvell/mwifiex/pcie.h:292:41: warning: mwifiex_pcie8766 defined but not used [-Wunused-const-variable=]
 static const struct mwifiex_pcie_device mwifiex_pcie8766 = {
                                         ^~~~~~~~~~~~~~~~

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 149 ++++++++++++++++++++
 drivers/net/wireless/marvell/mwifiex/pcie.h | 149 --------------------
 2 files changed, 149 insertions(+), 149 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 3c1ad0be70a8..04739cbb74f2 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -39,6 +39,155 @@ static const struct of_device_id mwifiex_pcie_of_match_table[] = {
 	{ }
 };
 
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
 static int mwifiex_pcie_probe_of(struct device *dev)
 {
 	if (!of_match_node(mwifiex_pcie_of_match_table, dev->of_node)) {
diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.h b/drivers/net/wireless/marvell/mwifiex/pcie.h
index fc59b522f670..843d57eda820 100644
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
2.17.1


