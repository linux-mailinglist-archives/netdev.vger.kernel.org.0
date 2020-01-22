Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 086F21458C0
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 16:27:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729075AbgAVP1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 10:27:12 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:2060 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728992AbgAVP1J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 10:27:09 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00MFQJ8A024737;
        Wed, 22 Jan 2020 07:27:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=FRL7K/xNx6bO/jAYv1B55i51wQjhsg9xJcNfgLda6Wc=;
 b=GoB4IxWDq39jrV9wkF3njE5sCnfqMi/WZlceQ1m/AezLX1+8x/o/YG22mG321xivsFNH
 oOj24Ho5xsy2xi7eVSR9Fu24zh2+0I/IaK3jYT9QeHxkk9zHV5WAHZL8PCbZ0M3zBGIO
 7/gkdlWAl7QKvnFQ9LBSSTTzKpmzpxeUFt3lTbGnb3BT2Ff3s5fkuZ2GMPkfuvX3Z+LT
 XHtbrBWSGO9g783UVRuGbRGvow4fFLNYhTuj6rGM1Evgyu7EnXC5d1+n+uHgYm/fxb0t
 UfSb22sclxFn0ok4dKGSXOZHDMiPi4y87VSQB/3An3yS30+vDqeYoDNc70MB3JHEHWTD 1g== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2xpm9015u2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 22 Jan 2020 07:27:01 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 22 Jan
 2020 07:26:59 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 22 Jan 2020 07:26:59 -0800
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id 352793F7040;
        Wed, 22 Jan 2020 07:26:57 -0800 (PST)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <michal.kalderon@marvell.com>, <ariel.elior@marvell.com>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
Subject: [PATCH net-next 13/14] qed: FW 8.42.2.0 debug features
Date:   Wed, 22 Jan 2020 17:26:26 +0200
Message-ID: <20200122152627.14903-14-michal.kalderon@marvell.com>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20200122152627.14903-1-michal.kalderon@marvell.com>
References: <20200122152627.14903-1-michal.kalderon@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-17_05:2020-01-16,2020-01-17 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add to debug dump more information on the platform it was collected
from (kernel version, epoch, pci func, path id).
Provide human readable reg fifo erros.

Removed static debug arrays from HSI Functions, and move them to
the hwfn.

Some structures were slightly changed (removing reserved chip id
for example) which lead to many long initializations being modified
with one parameter less during initialization. This leads to a
some long diffs that don't really change anything.

Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed.h       |    8 +
 drivers/net/ethernet/qlogic/qed/qed_debug.c | 3408 +++++++++++----------------
 drivers/net/ethernet/qlogic/qed/qed_debug.h |    2 +
 drivers/net/ethernet/qlogic/qed/qed_dev.c   |   14 +-
 drivers/net/ethernet/qlogic/qed/qed_hsi.h   |  661 ++----
 drivers/net/ethernet/qlogic/qed/qed_main.c  |    7 +-
 include/linux/qed/qed_if.h                  |    9 +
 7 files changed, 1572 insertions(+), 2537 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed.h b/drivers/net/ethernet/qlogic/qed/qed.h
index a6dc40681a32..8b6d6f884245 100644
--- a/drivers/net/ethernet/qlogic/qed/qed.h
+++ b/drivers/net/ethernet/qlogic/qed/qed.h
@@ -666,6 +666,7 @@ struct qed_hwfn {
 
 	struct dbg_tools_data		dbg_info;
 	void				*dbg_user_info;
+	struct virt_mem_desc		dbg_arrays[MAX_BIN_DBG_BUFFER_TYPE];
 
 	/* PWM region specific data */
 	u16				wid_count;
@@ -877,6 +878,7 @@ struct qed_dev {
 	struct qed_cb_ll2_info		*ll2;
 	u8				ll2_mac_address[ETH_ALEN];
 #endif
+	struct qed_dbg_feature dbg_features[DBG_FEATURE_NUM];
 	bool disable_ilt_dump;
 	DECLARE_HASHTABLE(connections, 10);
 	const struct firmware		*firmware;
@@ -991,6 +993,11 @@ void qed_db_recovery_dp(struct qed_hwfn *p_hwfn);
 void qed_db_recovery_execute(struct qed_hwfn *p_hwfn);
 bool qed_edpm_enabled(struct qed_hwfn *p_hwfn);
 
+/* qed_set_platform_str - Set the debug dump platform string.
+ * Write the qed version and device's string to the given buffer.
+ */
+void qed_set_platform_str(struct qed_hwfn *p_hwfn, char *buf_str, u32 buf_size);
+
 /* Other Linux specific common definitions */
 #define DP_NAME(cdev) ((cdev)->name)
 
@@ -1032,4 +1039,5 @@ int qed_mfw_fill_tlv_data(struct qed_hwfn *hwfn,
 void qed_hw_info_set_offload_tc(struct qed_hw_info *p_info, u8 tc);
 
 void qed_periodic_db_rec_start(struct qed_hwfn *p_hwfn);
+unsigned long qed_get_epoch_time(void);
 #endif /* _QED_H */
diff --git a/drivers/net/ethernet/qlogic/qed/qed_debug.c b/drivers/net/ethernet/qlogic/qed/qed_debug.c
index dbe917daa04b..7b575ef5d69b 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_debug.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_debug.c
@@ -6,6 +6,7 @@
 #include <linux/module.h>
 #include <linux/vmalloc.h>
 #include <linux/crc32.h>
+#include <linux/version.h>
 #include "qed.h"
 #include "qed_cxt.h"
 #include "qed_hsi.h"
@@ -23,27 +24,28 @@ enum mem_groups {
 	MEM_GROUP_BRB_RAM,
 	MEM_GROUP_BRB_MEM,
 	MEM_GROUP_PRS_MEM,
+	MEM_GROUP_SDM_MEM,
+	MEM_GROUP_PBUF,
 	MEM_GROUP_IOR,
+	MEM_GROUP_RAM,
 	MEM_GROUP_BTB_RAM,
+	MEM_GROUP_RDIF_CTX,
+	MEM_GROUP_TDIF_CTX,
+	MEM_GROUP_CFC_MEM,
 	MEM_GROUP_CONN_CFC_MEM,
-	MEM_GROUP_TASK_CFC_MEM,
 	MEM_GROUP_CAU_PI,
 	MEM_GROUP_CAU_MEM,
+	MEM_GROUP_CAU_MEM_EXT,
 	MEM_GROUP_PXP_ILT,
-	MEM_GROUP_TM_MEM,
-	MEM_GROUP_SDM_MEM,
-	MEM_GROUP_PBUF,
-	MEM_GROUP_RAM,
 	MEM_GROUP_MULD_MEM,
 	MEM_GROUP_BTB_MEM,
-	MEM_GROUP_RDIF_CTX,
-	MEM_GROUP_TDIF_CTX,
-	MEM_GROUP_CFC_MEM,
 	MEM_GROUP_IGU_MEM,
 	MEM_GROUP_IGU_MSIX,
 	MEM_GROUP_CAU_SB,
 	MEM_GROUP_BMB_RAM,
 	MEM_GROUP_BMB_MEM,
+	MEM_GROUP_TM_MEM,
+	MEM_GROUP_TASK_CFC_MEM,
 	MEM_GROUPS_NUM
 };
 
@@ -57,27 +59,28 @@ static const char * const s_mem_group_names[] = {
 	"BRB_RAM",
 	"BRB_MEM",
 	"PRS_MEM",
+	"SDM_MEM",
+	"PBUF",
 	"IOR",
+	"RAM",
 	"BTB_RAM",
+	"RDIF_CTX",
+	"TDIF_CTX",
+	"CFC_MEM",
 	"CONN_CFC_MEM",
-	"TASK_CFC_MEM",
 	"CAU_PI",
 	"CAU_MEM",
+	"CAU_MEM_EXT",
 	"PXP_ILT",
-	"TM_MEM",
-	"SDM_MEM",
-	"PBUF",
-	"RAM",
 	"MULD_MEM",
 	"BTB_MEM",
-	"RDIF_CTX",
-	"TDIF_CTX",
-	"CFC_MEM",
 	"IGU_MEM",
 	"IGU_MSIX",
 	"CAU_SB",
 	"BMB_RAM",
 	"BMB_MEM",
+	"TM_MEM",
+	"TASK_CFC_MEM",
 };
 
 /* Idle check conditions */
@@ -171,14 +174,38 @@ static u32(*cond_arr[]) (const u32 *r, const u32 *imm) = {
 	cond13,
 };
 
+#define NUM_PHYS_BLOCKS 84
+
+#define NUM_DBG_RESET_REGS 8
+
 /******************************* Data Types **********************************/
 
-enum platform_ids {
-	PLATFORM_ASIC,
+enum hw_types {
+	HW_TYPE_ASIC,
 	PLATFORM_RESERVED,
 	PLATFORM_RESERVED2,
 	PLATFORM_RESERVED3,
-	MAX_PLATFORM_IDS
+	PLATFORM_RESERVED4,
+	MAX_HW_TYPES
+};
+
+/* CM context types */
+enum cm_ctx_types {
+	CM_CTX_CONN_AG,
+	CM_CTX_CONN_ST,
+	CM_CTX_TASK_AG,
+	CM_CTX_TASK_ST,
+	NUM_CM_CTX_TYPES
+};
+
+/* Debug bus frame modes */
+enum dbg_bus_frame_modes {
+	DBG_BUS_FRAME_MODE_4ST = 0,	/* 4 Storm dwords (no HW) */
+	DBG_BUS_FRAME_MODE_2ST_2HW = 1,	/* 2 Storm dwords, 2 HW dwords */
+	DBG_BUS_FRAME_MODE_1ST_3HW = 2,	/* 1 Storm dwords, 3 HW dwords */
+	DBG_BUS_FRAME_MODE_4HW = 3,	/* 4 HW dwords (no Storms) */
+	DBG_BUS_FRAME_MODE_8HW = 4,	/* 8 HW dwords (no Storms) */
+	DBG_BUS_NUM_FRAME_MODES
 };
 
 /* Chip constant definitions */
@@ -187,20 +214,26 @@ struct chip_defs {
 	u32 num_ilt_pages;
 };
 
-/* Platform constant definitions */
-struct platform_defs {
+/* HW type constant definitions */
+struct hw_type_defs {
 	const char *name;
 	u32 delay_factor;
 	u32 dmae_thresh;
 	u32 log_thresh;
 };
 
+/* RBC reset definitions */
+struct rbc_reset_defs {
+	u32 reset_reg_addr;
+	u32 reset_val[MAX_CHIP_IDS];
+};
+
 /* Storm constant definitions.
  * Addresses are in bytes, sizes are in quad-regs.
  */
 struct storm_defs {
 	char letter;
-	enum block_id block_id;
+	enum block_id sem_block_id;
 	enum dbg_bus_clients dbg_client_id[MAX_CHIP_IDS];
 	bool has_vfc;
 	u32 sem_fast_mem_addr;
@@ -209,47 +242,26 @@ struct storm_defs {
 	u32 sem_slow_mode_addr;
 	u32 sem_slow_mode1_conf_addr;
 	u32 sem_sync_dbg_empty_addr;
-	u32 sem_slow_dbg_empty_addr;
+	u32 sem_gpre_vect_addr;
 	u32 cm_ctx_wr_addr;
-	u32 cm_conn_ag_ctx_lid_size;
-	u32 cm_conn_ag_ctx_rd_addr;
-	u32 cm_conn_st_ctx_lid_size;
-	u32 cm_conn_st_ctx_rd_addr;
-	u32 cm_task_ag_ctx_lid_size;
-	u32 cm_task_ag_ctx_rd_addr;
-	u32 cm_task_st_ctx_lid_size;
-	u32 cm_task_st_ctx_rd_addr;
+	u32 cm_ctx_rd_addr[NUM_CM_CTX_TYPES];
+	u32 cm_ctx_lid_sizes[MAX_CHIP_IDS][NUM_CM_CTX_TYPES];
 };
 
-/* Block constant definitions */
-struct block_defs {
-	const char *name;
-	bool exists[MAX_CHIP_IDS];
-	bool associated_to_storm;
-
-	/* Valid only if associated_to_storm is true */
-	u32 storm_id;
-	enum dbg_bus_clients dbg_client_id[MAX_CHIP_IDS];
-	u32 dbg_select_addr;
-	u32 dbg_enable_addr;
-	u32 dbg_shift_addr;
-	u32 dbg_force_valid_addr;
-	u32 dbg_force_frame_addr;
-	bool has_reset_bit;
-
-	/* If true, block is taken out of reset before dump */
-	bool unreset;
-	enum dbg_reset_regs reset_reg;
-
-	/* Bit offset in reset register */
-	u8 reset_bit_offset;
+/* Debug Bus Constraint operation constant definitions */
+struct dbg_bus_constraint_op_defs {
+	u8 hw_op_val;
+	bool is_cyclic;
 };
 
-/* Reset register definitions */
-struct reset_reg_defs {
-	u32 addr;
+/* Storm Mode definitions */
+struct storm_mode_defs {
+	const char *name;
+	bool is_fast_dbg;
+	u8 id_in_hw;
+	u32 src_disable_reg_addr;
+	u32 src_enable_val;
 	bool exists[MAX_CHIP_IDS];
-	u32 unreset_val[MAX_CHIP_IDS];
 };
 
 struct grc_param_defs {
@@ -259,7 +271,7 @@ struct grc_param_defs {
 	bool is_preset;
 	bool is_persistent;
 	u32 exclude_all_preset_val;
-	u32 crash_preset_val;
+	u32 crash_preset_val[MAX_CHIP_IDS];
 };
 
 /* Address is in 128b units. Width is in bits. */
@@ -316,15 +328,7 @@ struct split_type_defs {
 
 /******************************** Constants **********************************/
 
-#define MAX_LCIDS			320
-#define MAX_LTIDS			320
-
-#define NUM_IOR_SETS			2
-#define IORS_PER_SET			176
-#define IOR_SET_OFFSET(set_id)		((set_id) * 256)
-
 #define BYTES_IN_DWORD			sizeof(u32)
-
 /* In the macros below, size and offset are specified in bits */
 #define CEIL_DWORDS(size)		DIV_ROUND_UP(size, 32)
 #define FIELD_BIT_OFFSET(type, field)	type ## _ ## field ## _ ## OFFSET
@@ -350,20 +354,17 @@ struct split_type_defs {
 			qed_wr(dev, ptt, addr,	(arr)[i]); \
 	} while (0)
 
-#define ARR_REG_RD(dev, ptt, addr, arr, arr_size) \
-	do { \
-		for (i = 0; i < (arr_size); i++) \
-			(arr)[i] = qed_rd(dev, ptt, addr); \
-	} while (0)
-
 #define DWORDS_TO_BYTES(dwords)		((dwords) * BYTES_IN_DWORD)
 #define BYTES_TO_DWORDS(bytes)		((bytes) / BYTES_IN_DWORD)
 
-/* Extra lines include a signature line + optional latency events line */
-#define NUM_EXTRA_DBG_LINES(block_desc) \
-	(1 + ((block_desc)->has_latency_events ? 1 : 0))
-#define NUM_DBG_LINES(block_desc) \
-	((block_desc)->num_of_lines + NUM_EXTRA_DBG_LINES(block_desc))
+/* extra lines include a signature line + optional latency events line */
+#define NUM_EXTRA_DBG_LINES(block) \
+	(GET_FIELD((block)->flags, DBG_BLOCK_CHIP_HAS_LATENCY_EVENTS) ? 2 : 1)
+#define NUM_DBG_LINES(block) \
+	((block)->num_of_dbg_bus_lines + NUM_EXTRA_DBG_LINES(block))
+
+#define USE_DMAE			true
+#define PROTECT_WIDE_BUS		true
 
 #define RAM_LINES_TO_DWORDS(lines)	((lines) * 2)
 #define RAM_LINES_TO_BYTES(lines) \
@@ -430,7 +431,9 @@ struct split_type_defs {
 
 #define STATIC_DEBUG_LINE_DWORDS	9
 
-#define NUM_COMMON_GLOBAL_PARAMS	8
+#define NUM_COMMON_GLOBAL_PARAMS	11
+
+#define MAX_RECURSION_DEPTH		10
 
 #define FW_IMG_MAIN			1
 
@@ -454,19 +457,13 @@ struct split_type_defs {
 	(MCP_REG_SCRATCH + \
 	 offsetof(struct static_init, sections[SPAD_SECTION_TRACE]))
 
+#define MAX_SW_PLTAFORM_STR_SIZE	64
+
 #define EMPTY_FW_VERSION_STR		"???_???_???_???"
 #define EMPTY_FW_IMAGE_STR		"???????????????"
 
 /***************************** Constant Arrays *******************************/
 
-struct dbg_array {
-	const u32 *ptr;
-	u32 size_in_dwords;
-};
-
-/* Debug arrays */
-static struct dbg_array s_dbg_arrays[MAX_BIN_DBG_BUFFER_TYPE] = { {NULL} };
-
 /* Chip constant definitions array */
 static struct chip_defs s_chip_defs[MAX_CHIP_IDS] = {
 	{"bb", PSWRQ2_REG_ILT_MEMORY_SIZE_BB / 2},
@@ -477,1030 +474,104 @@ static struct chip_defs s_chip_defs[MAX_CHIP_IDS] = {
 static struct storm_defs s_storm_defs[] = {
 	/* Tstorm */
 	{'T', BLOCK_TSEM,
-	 {DBG_BUS_CLIENT_RBCT, DBG_BUS_CLIENT_RBCT,
-	  DBG_BUS_CLIENT_RBCT}, true,
-	 TSEM_REG_FAST_MEMORY,
-	 TSEM_REG_DBG_FRAME_MODE_BB_K2, TSEM_REG_SLOW_DBG_ACTIVE_BB_K2,
-	 TSEM_REG_SLOW_DBG_MODE_BB_K2, TSEM_REG_DBG_MODE1_CFG_BB_K2,
-	 TSEM_REG_SYNC_DBG_EMPTY, TSEM_REG_SLOW_DBG_EMPTY_BB_K2,
-	 TCM_REG_CTX_RBC_ACCS,
-	 4, TCM_REG_AGG_CON_CTX,
-	 16, TCM_REG_SM_CON_CTX,
-	 2, TCM_REG_AGG_TASK_CTX,
-	 4, TCM_REG_SM_TASK_CTX},
+		{DBG_BUS_CLIENT_RBCT, DBG_BUS_CLIENT_RBCT},
+		true,
+		TSEM_REG_FAST_MEMORY,
+		TSEM_REG_DBG_FRAME_MODE_BB_K2, TSEM_REG_SLOW_DBG_ACTIVE_BB_K2,
+		TSEM_REG_SLOW_DBG_MODE_BB_K2, TSEM_REG_DBG_MODE1_CFG_BB_K2,
+		TSEM_REG_SYNC_DBG_EMPTY, TSEM_REG_DBG_GPRE_VECT,
+		TCM_REG_CTX_RBC_ACCS,
+		{TCM_REG_AGG_CON_CTX, TCM_REG_SM_CON_CTX, TCM_REG_AGG_TASK_CTX,
+		 TCM_REG_SM_TASK_CTX},
+		{{4, 16, 2, 4}, {4, 16, 2, 4}} /* {bb} {k2} */
+	},
 
 	/* Mstorm */
 	{'M', BLOCK_MSEM,
-	 {DBG_BUS_CLIENT_RBCT, DBG_BUS_CLIENT_RBCM,
-	  DBG_BUS_CLIENT_RBCM}, false,
-	 MSEM_REG_FAST_MEMORY,
-	 MSEM_REG_DBG_FRAME_MODE_BB_K2, MSEM_REG_SLOW_DBG_ACTIVE_BB_K2,
-	 MSEM_REG_SLOW_DBG_MODE_BB_K2, MSEM_REG_DBG_MODE1_CFG_BB_K2,
-	 MSEM_REG_SYNC_DBG_EMPTY, MSEM_REG_SLOW_DBG_EMPTY_BB_K2,
-	 MCM_REG_CTX_RBC_ACCS,
-	 1, MCM_REG_AGG_CON_CTX,
-	 10, MCM_REG_SM_CON_CTX,
-	 2, MCM_REG_AGG_TASK_CTX,
-	 7, MCM_REG_SM_TASK_CTX},
+		{DBG_BUS_CLIENT_RBCT, DBG_BUS_CLIENT_RBCM},
+		false,
+		MSEM_REG_FAST_MEMORY,
+		MSEM_REG_DBG_FRAME_MODE_BB_K2,
+		MSEM_REG_SLOW_DBG_ACTIVE_BB_K2,
+		MSEM_REG_SLOW_DBG_MODE_BB_K2,
+		MSEM_REG_DBG_MODE1_CFG_BB_K2,
+		MSEM_REG_SYNC_DBG_EMPTY,
+		MSEM_REG_DBG_GPRE_VECT,
+		MCM_REG_CTX_RBC_ACCS,
+		{MCM_REG_AGG_CON_CTX, MCM_REG_SM_CON_CTX, MCM_REG_AGG_TASK_CTX,
+		 MCM_REG_SM_TASK_CTX },
+		{{1, 10, 2, 7}, {1, 10, 2, 7}} /* {bb} {k2}*/
+	},
 
 	/* Ustorm */
 	{'U', BLOCK_USEM,
-	 {DBG_BUS_CLIENT_RBCU, DBG_BUS_CLIENT_RBCU,
-	  DBG_BUS_CLIENT_RBCU}, false,
-	 USEM_REG_FAST_MEMORY,
-	 USEM_REG_DBG_FRAME_MODE_BB_K2, USEM_REG_SLOW_DBG_ACTIVE_BB_K2,
-	 USEM_REG_SLOW_DBG_MODE_BB_K2, USEM_REG_DBG_MODE1_CFG_BB_K2,
-	 USEM_REG_SYNC_DBG_EMPTY, USEM_REG_SLOW_DBG_EMPTY_BB_K2,
-	 UCM_REG_CTX_RBC_ACCS,
-	 2, UCM_REG_AGG_CON_CTX,
-	 13, UCM_REG_SM_CON_CTX,
-	 3, UCM_REG_AGG_TASK_CTX,
-	 3, UCM_REG_SM_TASK_CTX},
+		{DBG_BUS_CLIENT_RBCU, DBG_BUS_CLIENT_RBCU},
+		false,
+		USEM_REG_FAST_MEMORY,
+		USEM_REG_DBG_FRAME_MODE_BB_K2,
+		USEM_REG_SLOW_DBG_ACTIVE_BB_K2,
+		USEM_REG_SLOW_DBG_MODE_BB_K2,
+		USEM_REG_DBG_MODE1_CFG_BB_K2,
+		USEM_REG_SYNC_DBG_EMPTY,
+		USEM_REG_DBG_GPRE_VECT,
+		UCM_REG_CTX_RBC_ACCS,
+		{UCM_REG_AGG_CON_CTX, UCM_REG_SM_CON_CTX, UCM_REG_AGG_TASK_CTX,
+		 UCM_REG_SM_TASK_CTX},
+		{{2, 13, 3, 3}, {2, 13, 3, 3}} /* {bb} {k2} */
+	},
 
 	/* Xstorm */
 	{'X', BLOCK_XSEM,
-	 {DBG_BUS_CLIENT_RBCX, DBG_BUS_CLIENT_RBCX,
-	  DBG_BUS_CLIENT_RBCX}, false,
-	 XSEM_REG_FAST_MEMORY,
-	 XSEM_REG_DBG_FRAME_MODE_BB_K2, XSEM_REG_SLOW_DBG_ACTIVE_BB_K2,
-	 XSEM_REG_SLOW_DBG_MODE_BB_K2, XSEM_REG_DBG_MODE1_CFG_BB_K2,
-	 XSEM_REG_SYNC_DBG_EMPTY, XSEM_REG_SLOW_DBG_EMPTY_BB_K2,
-	 XCM_REG_CTX_RBC_ACCS,
-	 9, XCM_REG_AGG_CON_CTX,
-	 15, XCM_REG_SM_CON_CTX,
-	 0, 0,
-	 0, 0},
+		{DBG_BUS_CLIENT_RBCX, DBG_BUS_CLIENT_RBCX},
+		false,
+		XSEM_REG_FAST_MEMORY,
+		XSEM_REG_DBG_FRAME_MODE_BB_K2,
+		XSEM_REG_SLOW_DBG_ACTIVE_BB_K2,
+		XSEM_REG_SLOW_DBG_MODE_BB_K2,
+		XSEM_REG_DBG_MODE1_CFG_BB_K2,
+		XSEM_REG_SYNC_DBG_EMPTY,
+		XSEM_REG_DBG_GPRE_VECT,
+		XCM_REG_CTX_RBC_ACCS,
+		{XCM_REG_AGG_CON_CTX, XCM_REG_SM_CON_CTX, 0, 0},
+		{{9, 15, 0, 0}, {9, 15,	0, 0}} /* {bb} {k2} */
+	},
 
 	/* Ystorm */
 	{'Y', BLOCK_YSEM,
-	 {DBG_BUS_CLIENT_RBCX, DBG_BUS_CLIENT_RBCY,
-	  DBG_BUS_CLIENT_RBCY}, false,
-	 YSEM_REG_FAST_MEMORY,
-	 YSEM_REG_DBG_FRAME_MODE_BB_K2, YSEM_REG_SLOW_DBG_ACTIVE_BB_K2,
-	 YSEM_REG_SLOW_DBG_MODE_BB_K2, YSEM_REG_DBG_MODE1_CFG_BB_K2,
-	 YSEM_REG_SYNC_DBG_EMPTY, TSEM_REG_SLOW_DBG_EMPTY_BB_K2,
-	 YCM_REG_CTX_RBC_ACCS,
-	 2, YCM_REG_AGG_CON_CTX,
-	 3, YCM_REG_SM_CON_CTX,
-	 2, YCM_REG_AGG_TASK_CTX,
-	 12, YCM_REG_SM_TASK_CTX},
+		{DBG_BUS_CLIENT_RBCX, DBG_BUS_CLIENT_RBCY},
+		false,
+		YSEM_REG_FAST_MEMORY,
+		YSEM_REG_DBG_FRAME_MODE_BB_K2,
+		YSEM_REG_SLOW_DBG_ACTIVE_BB_K2,
+		YSEM_REG_SLOW_DBG_MODE_BB_K2,
+		YSEM_REG_DBG_MODE1_CFG_BB_K2,
+		YSEM_REG_SYNC_DBG_EMPTY,
+		YSEM_REG_DBG_GPRE_VECT,
+		YCM_REG_CTX_RBC_ACCS,
+		{YCM_REG_AGG_CON_CTX, YCM_REG_SM_CON_CTX, YCM_REG_AGG_TASK_CTX,
+		 YCM_REG_SM_TASK_CTX},
+		{{2, 3, 2, 12}, {2, 3, 2, 12}} /* {bb} {k2} */
+	},
 
 	/* Pstorm */
 	{'P', BLOCK_PSEM,
-	 {DBG_BUS_CLIENT_RBCS, DBG_BUS_CLIENT_RBCS,
-	  DBG_BUS_CLIENT_RBCS}, true,
-	 PSEM_REG_FAST_MEMORY,
-	 PSEM_REG_DBG_FRAME_MODE_BB_K2, PSEM_REG_SLOW_DBG_ACTIVE_BB_K2,
-	 PSEM_REG_SLOW_DBG_MODE_BB_K2, PSEM_REG_DBG_MODE1_CFG_BB_K2,
-	 PSEM_REG_SYNC_DBG_EMPTY, PSEM_REG_SLOW_DBG_EMPTY_BB_K2,
-	 PCM_REG_CTX_RBC_ACCS,
-	 0, 0,
-	 10, PCM_REG_SM_CON_CTX,
-	 0, 0,
-	 0, 0}
-};
-
-/* Block definitions array */
-
-static struct block_defs block_grc_defs = {
-	"grc",
-	{true, true, true}, false, 0,
-	{DBG_BUS_CLIENT_RBCN, DBG_BUS_CLIENT_RBCN, DBG_BUS_CLIENT_RBCN},
-	GRC_REG_DBG_SELECT, GRC_REG_DBG_DWORD_ENABLE,
-	GRC_REG_DBG_SHIFT, GRC_REG_DBG_FORCE_VALID,
-	GRC_REG_DBG_FORCE_FRAME,
-	true, false, DBG_RESET_REG_MISC_PL_UA, 1
-};
-
-static struct block_defs block_miscs_defs = {
-	"miscs", {true, true, true}, false, 0,
-	{MAX_DBG_BUS_CLIENTS, MAX_DBG_BUS_CLIENTS, MAX_DBG_BUS_CLIENTS},
-	0, 0, 0, 0, 0,
-	false, false, MAX_DBG_RESET_REGS, 0
-};
-
-static struct block_defs block_misc_defs = {
-	"misc", {true, true, true}, false, 0,
-	{MAX_DBG_BUS_CLIENTS, MAX_DBG_BUS_CLIENTS, MAX_DBG_BUS_CLIENTS},
-	0, 0, 0, 0, 0,
-	false, false, MAX_DBG_RESET_REGS, 0
-};
-
-static struct block_defs block_dbu_defs = {
-	"dbu", {true, true, true}, false, 0,
-	{MAX_DBG_BUS_CLIENTS, MAX_DBG_BUS_CLIENTS, MAX_DBG_BUS_CLIENTS},
-	0, 0, 0, 0, 0,
-	false, false, MAX_DBG_RESET_REGS, 0
-};
-
-static struct block_defs block_pglue_b_defs = {
-	"pglue_b",
-	{true, true, true}, false, 0,
-	{DBG_BUS_CLIENT_RBCH, DBG_BUS_CLIENT_RBCH, DBG_BUS_CLIENT_RBCH},
-	PGLUE_B_REG_DBG_SELECT, PGLUE_B_REG_DBG_DWORD_ENABLE,
-	PGLUE_B_REG_DBG_SHIFT, PGLUE_B_REG_DBG_FORCE_VALID,
-	PGLUE_B_REG_DBG_FORCE_FRAME,
-	true, false, DBG_RESET_REG_MISCS_PL_HV, 1
-};
-
-static struct block_defs block_cnig_defs = {
-	"cnig",
-	{true, true, true}, false, 0,
-	{MAX_DBG_BUS_CLIENTS, DBG_BUS_CLIENT_RBCW,
-	 DBG_BUS_CLIENT_RBCW},
-	CNIG_REG_DBG_SELECT_K2_E5, CNIG_REG_DBG_DWORD_ENABLE_K2_E5,
-	CNIG_REG_DBG_SHIFT_K2_E5, CNIG_REG_DBG_FORCE_VALID_K2_E5,
-	CNIG_REG_DBG_FORCE_FRAME_K2_E5,
-	true, false, DBG_RESET_REG_MISCS_PL_HV, 0
-};
-
-static struct block_defs block_cpmu_defs = {
-	"cpmu", {true, true, true}, false, 0,
-	{MAX_DBG_BUS_CLIENTS, MAX_DBG_BUS_CLIENTS, MAX_DBG_BUS_CLIENTS},
-	0, 0, 0, 0, 0,
-	true, false, DBG_RESET_REG_MISCS_PL_HV, 8
-};
-
-static struct block_defs block_ncsi_defs = {
-	"ncsi",
-	{true, true, true}, false, 0,
-	{DBG_BUS_CLIENT_RBCZ, DBG_BUS_CLIENT_RBCZ, DBG_BUS_CLIENT_RBCZ},
-	NCSI_REG_DBG_SELECT, NCSI_REG_DBG_DWORD_ENABLE,
-	NCSI_REG_DBG_SHIFT, NCSI_REG_DBG_FORCE_VALID,
-	NCSI_REG_DBG_FORCE_FRAME,
-	true, false, DBG_RESET_REG_MISCS_PL_HV, 5
-};
-
-static struct block_defs block_opte_defs = {
-	"opte", {true, true, false}, false, 0,
-	{MAX_DBG_BUS_CLIENTS, MAX_DBG_BUS_CLIENTS, MAX_DBG_BUS_CLIENTS},
-	0, 0, 0, 0, 0,
-	true, false, DBG_RESET_REG_MISCS_PL_HV, 4
-};
-
-static struct block_defs block_bmb_defs = {
-	"bmb",
-	{true, true, true}, false, 0,
-	{DBG_BUS_CLIENT_RBCZ, DBG_BUS_CLIENT_RBCB, DBG_BUS_CLIENT_RBCB},
-	BMB_REG_DBG_SELECT, BMB_REG_DBG_DWORD_ENABLE,
-	BMB_REG_DBG_SHIFT, BMB_REG_DBG_FORCE_VALID,
-	BMB_REG_DBG_FORCE_FRAME,
-	true, false, DBG_RESET_REG_MISCS_PL_UA, 7
-};
-
-static struct block_defs block_pcie_defs = {
-	"pcie",
-	{true, true, true}, false, 0,
-	{MAX_DBG_BUS_CLIENTS, DBG_BUS_CLIENT_RBCH,
-	 DBG_BUS_CLIENT_RBCH},
-	PCIE_REG_DBG_COMMON_SELECT_K2_E5,
-	PCIE_REG_DBG_COMMON_DWORD_ENABLE_K2_E5,
-	PCIE_REG_DBG_COMMON_SHIFT_K2_E5,
-	PCIE_REG_DBG_COMMON_FORCE_VALID_K2_E5,
-	PCIE_REG_DBG_COMMON_FORCE_FRAME_K2_E5,
-	false, false, MAX_DBG_RESET_REGS, 0
-};
-
-static struct block_defs block_mcp_defs = {
-	"mcp", {true, true, true}, false, 0,
-	{MAX_DBG_BUS_CLIENTS, MAX_DBG_BUS_CLIENTS, MAX_DBG_BUS_CLIENTS},
-	0, 0, 0, 0, 0,
-	false, false, MAX_DBG_RESET_REGS, 0
-};
-
-static struct block_defs block_mcp2_defs = {
-	"mcp2",
-	{true, true, true}, false, 0,
-	{DBG_BUS_CLIENT_RBCZ, DBG_BUS_CLIENT_RBCZ, DBG_BUS_CLIENT_RBCZ},
-	MCP2_REG_DBG_SELECT, MCP2_REG_DBG_DWORD_ENABLE,
-	MCP2_REG_DBG_SHIFT, MCP2_REG_DBG_FORCE_VALID,
-	MCP2_REG_DBG_FORCE_FRAME,
-	false, false, MAX_DBG_RESET_REGS, 0
-};
-
-static struct block_defs block_pswhst_defs = {
-	"pswhst",
-	{true, true, true}, false, 0,
-	{DBG_BUS_CLIENT_RBCP, DBG_BUS_CLIENT_RBCP, DBG_BUS_CLIENT_RBCP},
-	PSWHST_REG_DBG_SELECT, PSWHST_REG_DBG_DWORD_ENABLE,
-	PSWHST_REG_DBG_SHIFT, PSWHST_REG_DBG_FORCE_VALID,
-	PSWHST_REG_DBG_FORCE_FRAME,
-	true, false, DBG_RESET_REG_MISC_PL_HV, 0
-};
-
-static struct block_defs block_pswhst2_defs = {
-	"pswhst2",
-	{true, true, true}, false, 0,
-	{DBG_BUS_CLIENT_RBCP, DBG_BUS_CLIENT_RBCP, DBG_BUS_CLIENT_RBCP},
-	PSWHST2_REG_DBG_SELECT, PSWHST2_REG_DBG_DWORD_ENABLE,
-	PSWHST2_REG_DBG_SHIFT, PSWHST2_REG_DBG_FORCE_VALID,
-	PSWHST2_REG_DBG_FORCE_FRAME,
-	true, false, DBG_RESET_REG_MISC_PL_HV, 0
-};
-
-static struct block_defs block_pswrd_defs = {
-	"pswrd",
-	{true, true, true}, false, 0,
-	{DBG_BUS_CLIENT_RBCP, DBG_BUS_CLIENT_RBCP, DBG_BUS_CLIENT_RBCP},
-	PSWRD_REG_DBG_SELECT, PSWRD_REG_DBG_DWORD_ENABLE,
-	PSWRD_REG_DBG_SHIFT, PSWRD_REG_DBG_FORCE_VALID,
-	PSWRD_REG_DBG_FORCE_FRAME,
-	true, false, DBG_RESET_REG_MISC_PL_HV, 2
-};
-
-static struct block_defs block_pswrd2_defs = {
-	"pswrd2",
-	{true, true, true}, false, 0,
-	{DBG_BUS_CLIENT_RBCP, DBG_BUS_CLIENT_RBCP, DBG_BUS_CLIENT_RBCP},
-	PSWRD2_REG_DBG_SELECT, PSWRD2_REG_DBG_DWORD_ENABLE,
-	PSWRD2_REG_DBG_SHIFT, PSWRD2_REG_DBG_FORCE_VALID,
-	PSWRD2_REG_DBG_FORCE_FRAME,
-	true, false, DBG_RESET_REG_MISC_PL_HV, 2
-};
-
-static struct block_defs block_pswwr_defs = {
-	"pswwr",
-	{true, true, true}, false, 0,
-	{DBG_BUS_CLIENT_RBCP, DBG_BUS_CLIENT_RBCP, DBG_BUS_CLIENT_RBCP},
-	PSWWR_REG_DBG_SELECT, PSWWR_REG_DBG_DWORD_ENABLE,
-	PSWWR_REG_DBG_SHIFT, PSWWR_REG_DBG_FORCE_VALID,
-	PSWWR_REG_DBG_FORCE_FRAME,
-	true, false, DBG_RESET_REG_MISC_PL_HV, 3
-};
-
-static struct block_defs block_pswwr2_defs = {
-	"pswwr2", {true, true, true}, false, 0,
-	{MAX_DBG_BUS_CLIENTS, MAX_DBG_BUS_CLIENTS, MAX_DBG_BUS_CLIENTS},
-	0, 0, 0, 0, 0,
-	true, false, DBG_RESET_REG_MISC_PL_HV, 3
-};
-
-static struct block_defs block_pswrq_defs = {
-	"pswrq",
-	{true, true, true}, false, 0,
-	{DBG_BUS_CLIENT_RBCP, DBG_BUS_CLIENT_RBCP, DBG_BUS_CLIENT_RBCP},
-	PSWRQ_REG_DBG_SELECT, PSWRQ_REG_DBG_DWORD_ENABLE,
-	PSWRQ_REG_DBG_SHIFT, PSWRQ_REG_DBG_FORCE_VALID,
-	PSWRQ_REG_DBG_FORCE_FRAME,
-	true, false, DBG_RESET_REG_MISC_PL_HV, 1
-};
-
-static struct block_defs block_pswrq2_defs = {
-	"pswrq2",
-	{true, true, true}, false, 0,
-	{DBG_BUS_CLIENT_RBCP, DBG_BUS_CLIENT_RBCP, DBG_BUS_CLIENT_RBCP},
-	PSWRQ2_REG_DBG_SELECT, PSWRQ2_REG_DBG_DWORD_ENABLE,
-	PSWRQ2_REG_DBG_SHIFT, PSWRQ2_REG_DBG_FORCE_VALID,
-	PSWRQ2_REG_DBG_FORCE_FRAME,
-	true, false, DBG_RESET_REG_MISC_PL_HV, 1
-};
-
-static struct block_defs block_pglcs_defs = {
-	"pglcs",
-	{true, true, true}, false, 0,
-	{MAX_DBG_BUS_CLIENTS, DBG_BUS_CLIENT_RBCH,
-	 DBG_BUS_CLIENT_RBCH},
-	PGLCS_REG_DBG_SELECT_K2_E5, PGLCS_REG_DBG_DWORD_ENABLE_K2_E5,
-	PGLCS_REG_DBG_SHIFT_K2_E5, PGLCS_REG_DBG_FORCE_VALID_K2_E5,
-	PGLCS_REG_DBG_FORCE_FRAME_K2_E5,
-	true, false, DBG_RESET_REG_MISCS_PL_HV, 2
-};
-
-static struct block_defs block_ptu_defs = {
-	"ptu",
-	{true, true, true}, false, 0,
-	{DBG_BUS_CLIENT_RBCP, DBG_BUS_CLIENT_RBCP, DBG_BUS_CLIENT_RBCP},
-	PTU_REG_DBG_SELECT, PTU_REG_DBG_DWORD_ENABLE,
-	PTU_REG_DBG_SHIFT, PTU_REG_DBG_FORCE_VALID,
-	PTU_REG_DBG_FORCE_FRAME,
-	true, true, DBG_RESET_REG_MISC_PL_PDA_VMAIN_2, 20
-};
-
-static struct block_defs block_dmae_defs = {
-	"dmae",
-	{true, true, true}, false, 0,
-	{DBG_BUS_CLIENT_RBCP, DBG_BUS_CLIENT_RBCP, DBG_BUS_CLIENT_RBCP},
-	DMAE_REG_DBG_SELECT, DMAE_REG_DBG_DWORD_ENABLE,
-	DMAE_REG_DBG_SHIFT, DMAE_REG_DBG_FORCE_VALID,
-	DMAE_REG_DBG_FORCE_FRAME,
-	true, true, DBG_RESET_REG_MISC_PL_PDA_VMAIN_1, 28
-};
-
-static struct block_defs block_tcm_defs = {
-	"tcm",
-	{true, true, true}, true, DBG_TSTORM_ID,
-	{DBG_BUS_CLIENT_RBCT, DBG_BUS_CLIENT_RBCT, DBG_BUS_CLIENT_RBCT},
-	TCM_REG_DBG_SELECT, TCM_REG_DBG_DWORD_ENABLE,
-	TCM_REG_DBG_SHIFT, TCM_REG_DBG_FORCE_VALID,
-	TCM_REG_DBG_FORCE_FRAME,
-	true, true, DBG_RESET_REG_MISC_PL_PDA_VMAIN_1, 5
-};
-
-static struct block_defs block_mcm_defs = {
-	"mcm",
-	{true, true, true}, true, DBG_MSTORM_ID,
-	{DBG_BUS_CLIENT_RBCT, DBG_BUS_CLIENT_RBCM, DBG_BUS_CLIENT_RBCM},
-	MCM_REG_DBG_SELECT, MCM_REG_DBG_DWORD_ENABLE,
-	MCM_REG_DBG_SHIFT, MCM_REG_DBG_FORCE_VALID,
-	MCM_REG_DBG_FORCE_FRAME,
-	true, true, DBG_RESET_REG_MISC_PL_PDA_VMAIN_2, 3
-};
-
-static struct block_defs block_ucm_defs = {
-	"ucm",
-	{true, true, true}, true, DBG_USTORM_ID,
-	{DBG_BUS_CLIENT_RBCU, DBG_BUS_CLIENT_RBCU, DBG_BUS_CLIENT_RBCU},
-	UCM_REG_DBG_SELECT, UCM_REG_DBG_DWORD_ENABLE,
-	UCM_REG_DBG_SHIFT, UCM_REG_DBG_FORCE_VALID,
-	UCM_REG_DBG_FORCE_FRAME,
-	true, true, DBG_RESET_REG_MISC_PL_PDA_VMAIN_1, 8
-};
-
-static struct block_defs block_xcm_defs = {
-	"xcm",
-	{true, true, true}, true, DBG_XSTORM_ID,
-	{DBG_BUS_CLIENT_RBCX, DBG_BUS_CLIENT_RBCX, DBG_BUS_CLIENT_RBCX},
-	XCM_REG_DBG_SELECT, XCM_REG_DBG_DWORD_ENABLE,
-	XCM_REG_DBG_SHIFT, XCM_REG_DBG_FORCE_VALID,
-	XCM_REG_DBG_FORCE_FRAME,
-	true, true, DBG_RESET_REG_MISC_PL_PDA_VMAIN_1, 19
-};
-
-static struct block_defs block_ycm_defs = {
-	"ycm",
-	{true, true, true}, true, DBG_YSTORM_ID,
-	{DBG_BUS_CLIENT_RBCX, DBG_BUS_CLIENT_RBCY, DBG_BUS_CLIENT_RBCY},
-	YCM_REG_DBG_SELECT, YCM_REG_DBG_DWORD_ENABLE,
-	YCM_REG_DBG_SHIFT, YCM_REG_DBG_FORCE_VALID,
-	YCM_REG_DBG_FORCE_FRAME,
-	true, true, DBG_RESET_REG_MISC_PL_PDA_VMAIN_2, 5
-};
-
-static struct block_defs block_pcm_defs = {
-	"pcm",
-	{true, true, true}, true, DBG_PSTORM_ID,
-	{DBG_BUS_CLIENT_RBCS, DBG_BUS_CLIENT_RBCS, DBG_BUS_CLIENT_RBCS},
-	PCM_REG_DBG_SELECT, PCM_REG_DBG_DWORD_ENABLE,
-	PCM_REG_DBG_SHIFT, PCM_REG_DBG_FORCE_VALID,
-	PCM_REG_DBG_FORCE_FRAME,
-	true, true, DBG_RESET_REG_MISC_PL_PDA_VMAIN_2, 4
-};
-
-static struct block_defs block_qm_defs = {
-	"qm",
-	{true, true, true}, false, 0,
-	{DBG_BUS_CLIENT_RBCP, DBG_BUS_CLIENT_RBCQ, DBG_BUS_CLIENT_RBCQ},
-	QM_REG_DBG_SELECT, QM_REG_DBG_DWORD_ENABLE,
-	QM_REG_DBG_SHIFT, QM_REG_DBG_FORCE_VALID,
-	QM_REG_DBG_FORCE_FRAME,
-	true, true, DBG_RESET_REG_MISC_PL_PDA_VMAIN_1, 16
-};
-
-static struct block_defs block_tm_defs = {
-	"tm",
-	{true, true, true}, false, 0,
-	{DBG_BUS_CLIENT_RBCS, DBG_BUS_CLIENT_RBCS, DBG_BUS_CLIENT_RBCS},
-	TM_REG_DBG_SELECT, TM_REG_DBG_DWORD_ENABLE,
-	TM_REG_DBG_SHIFT, TM_REG_DBG_FORCE_VALID,
-	TM_REG_DBG_FORCE_FRAME,
-	true, true, DBG_RESET_REG_MISC_PL_PDA_VMAIN_1, 17
-};
-
-static struct block_defs block_dorq_defs = {
-	"dorq",
-	{true, true, true}, false, 0,
-	{DBG_BUS_CLIENT_RBCX, DBG_BUS_CLIENT_RBCY, DBG_BUS_CLIENT_RBCY},
-	DORQ_REG_DBG_SELECT, DORQ_REG_DBG_DWORD_ENABLE,
-	DORQ_REG_DBG_SHIFT, DORQ_REG_DBG_FORCE_VALID,
-	DORQ_REG_DBG_FORCE_FRAME,
-	true, true, DBG_RESET_REG_MISC_PL_PDA_VMAIN_1, 18
-};
-
-static struct block_defs block_brb_defs = {
-	"brb",
-	{true, true, true}, false, 0,
-	{DBG_BUS_CLIENT_RBCR, DBG_BUS_CLIENT_RBCR, DBG_BUS_CLIENT_RBCR},
-	BRB_REG_DBG_SELECT, BRB_REG_DBG_DWORD_ENABLE,
-	BRB_REG_DBG_SHIFT, BRB_REG_DBG_FORCE_VALID,
-	BRB_REG_DBG_FORCE_FRAME,
-	true, true, DBG_RESET_REG_MISC_PL_PDA_VMAIN_1, 0
-};
-
-static struct block_defs block_src_defs = {
-	"src",
-	{true, true, true}, false, 0,
-	{DBG_BUS_CLIENT_RBCF, DBG_BUS_CLIENT_RBCF, DBG_BUS_CLIENT_RBCF},
-	SRC_REG_DBG_SELECT, SRC_REG_DBG_DWORD_ENABLE,
-	SRC_REG_DBG_SHIFT, SRC_REG_DBG_FORCE_VALID,
-	SRC_REG_DBG_FORCE_FRAME,
-	true, true, DBG_RESET_REG_MISC_PL_PDA_VMAIN_1, 2
-};
-
-static struct block_defs block_prs_defs = {
-	"prs",
-	{true, true, true}, false, 0,
-	{DBG_BUS_CLIENT_RBCR, DBG_BUS_CLIENT_RBCR, DBG_BUS_CLIENT_RBCR},
-	PRS_REG_DBG_SELECT, PRS_REG_DBG_DWORD_ENABLE,
-	PRS_REG_DBG_SHIFT, PRS_REG_DBG_FORCE_VALID,
-	PRS_REG_DBG_FORCE_FRAME,
-	true, true, DBG_RESET_REG_MISC_PL_PDA_VMAIN_1, 1
-};
-
-static struct block_defs block_tsdm_defs = {
-	"tsdm",
-	{true, true, true}, true, DBG_TSTORM_ID,
-	{DBG_BUS_CLIENT_RBCT, DBG_BUS_CLIENT_RBCT, DBG_BUS_CLIENT_RBCT},
-	TSDM_REG_DBG_SELECT, TSDM_REG_DBG_DWORD_ENABLE,
-	TSDM_REG_DBG_SHIFT, TSDM_REG_DBG_FORCE_VALID,
-	TSDM_REG_DBG_FORCE_FRAME,
-	true, true, DBG_RESET_REG_MISC_PL_PDA_VMAIN_1, 3
-};
-
-static struct block_defs block_msdm_defs = {
-	"msdm",
-	{true, true, true}, true, DBG_MSTORM_ID,
-	{DBG_BUS_CLIENT_RBCT, DBG_BUS_CLIENT_RBCM, DBG_BUS_CLIENT_RBCM},
-	MSDM_REG_DBG_SELECT, MSDM_REG_DBG_DWORD_ENABLE,
-	MSDM_REG_DBG_SHIFT, MSDM_REG_DBG_FORCE_VALID,
-	MSDM_REG_DBG_FORCE_FRAME,
-	true, true, DBG_RESET_REG_MISC_PL_PDA_VMAIN_2, 6
-};
-
-static struct block_defs block_usdm_defs = {
-	"usdm",
-	{true, true, true}, true, DBG_USTORM_ID,
-	{DBG_BUS_CLIENT_RBCU, DBG_BUS_CLIENT_RBCU, DBG_BUS_CLIENT_RBCU},
-	USDM_REG_DBG_SELECT, USDM_REG_DBG_DWORD_ENABLE,
-	USDM_REG_DBG_SHIFT, USDM_REG_DBG_FORCE_VALID,
-	USDM_REG_DBG_FORCE_FRAME,
-	true, true, DBG_RESET_REG_MISC_PL_PDA_VMAIN_1, 7
-};
-
-static struct block_defs block_xsdm_defs = {
-	"xsdm",
-	{true, true, true}, true, DBG_XSTORM_ID,
-	{DBG_BUS_CLIENT_RBCX, DBG_BUS_CLIENT_RBCX, DBG_BUS_CLIENT_RBCX},
-	XSDM_REG_DBG_SELECT, XSDM_REG_DBG_DWORD_ENABLE,
-	XSDM_REG_DBG_SHIFT, XSDM_REG_DBG_FORCE_VALID,
-	XSDM_REG_DBG_FORCE_FRAME,
-	true, true, DBG_RESET_REG_MISC_PL_PDA_VMAIN_1, 20
-};
-
-static struct block_defs block_ysdm_defs = {
-	"ysdm",
-	{true, true, true}, true, DBG_YSTORM_ID,
-	{DBG_BUS_CLIENT_RBCX, DBG_BUS_CLIENT_RBCY, DBG_BUS_CLIENT_RBCY},
-	YSDM_REG_DBG_SELECT, YSDM_REG_DBG_DWORD_ENABLE,
-	YSDM_REG_DBG_SHIFT, YSDM_REG_DBG_FORCE_VALID,
-	YSDM_REG_DBG_FORCE_FRAME,
-	true, true, DBG_RESET_REG_MISC_PL_PDA_VMAIN_2, 8
-};
-
-static struct block_defs block_psdm_defs = {
-	"psdm",
-	{true, true, true}, true, DBG_PSTORM_ID,
-	{DBG_BUS_CLIENT_RBCS, DBG_BUS_CLIENT_RBCS, DBG_BUS_CLIENT_RBCS},
-	PSDM_REG_DBG_SELECT, PSDM_REG_DBG_DWORD_ENABLE,
-	PSDM_REG_DBG_SHIFT, PSDM_REG_DBG_FORCE_VALID,
-	PSDM_REG_DBG_FORCE_FRAME,
-	true, true, DBG_RESET_REG_MISC_PL_PDA_VMAIN_2, 7
-};
-
-static struct block_defs block_tsem_defs = {
-	"tsem",
-	{true, true, true}, true, DBG_TSTORM_ID,
-	{DBG_BUS_CLIENT_RBCT, DBG_BUS_CLIENT_RBCT, DBG_BUS_CLIENT_RBCT},
-	TSEM_REG_DBG_SELECT, TSEM_REG_DBG_DWORD_ENABLE,
-	TSEM_REG_DBG_SHIFT, TSEM_REG_DBG_FORCE_VALID,
-	TSEM_REG_DBG_FORCE_FRAME,
-	true, true, DBG_RESET_REG_MISC_PL_PDA_VMAIN_1, 4
-};
-
-static struct block_defs block_msem_defs = {
-	"msem",
-	{true, true, true}, true, DBG_MSTORM_ID,
-	{DBG_BUS_CLIENT_RBCT, DBG_BUS_CLIENT_RBCM, DBG_BUS_CLIENT_RBCM},
-	MSEM_REG_DBG_SELECT, MSEM_REG_DBG_DWORD_ENABLE,
-	MSEM_REG_DBG_SHIFT, MSEM_REG_DBG_FORCE_VALID,
-	MSEM_REG_DBG_FORCE_FRAME,
-	true, true, DBG_RESET_REG_MISC_PL_PDA_VMAIN_2, 9
-};
-
-static struct block_defs block_usem_defs = {
-	"usem",
-	{true, true, true}, true, DBG_USTORM_ID,
-	{DBG_BUS_CLIENT_RBCU, DBG_BUS_CLIENT_RBCU, DBG_BUS_CLIENT_RBCU},
-	USEM_REG_DBG_SELECT, USEM_REG_DBG_DWORD_ENABLE,
-	USEM_REG_DBG_SHIFT, USEM_REG_DBG_FORCE_VALID,
-	USEM_REG_DBG_FORCE_FRAME,
-	true, true, DBG_RESET_REG_MISC_PL_PDA_VMAIN_1, 9
-};
-
-static struct block_defs block_xsem_defs = {
-	"xsem",
-	{true, true, true}, true, DBG_XSTORM_ID,
-	{DBG_BUS_CLIENT_RBCX, DBG_BUS_CLIENT_RBCX, DBG_BUS_CLIENT_RBCX},
-	XSEM_REG_DBG_SELECT, XSEM_REG_DBG_DWORD_ENABLE,
-	XSEM_REG_DBG_SHIFT, XSEM_REG_DBG_FORCE_VALID,
-	XSEM_REG_DBG_FORCE_FRAME,
-	true, true, DBG_RESET_REG_MISC_PL_PDA_VMAIN_1, 21
-};
-
-static struct block_defs block_ysem_defs = {
-	"ysem",
-	{true, true, true}, true, DBG_YSTORM_ID,
-	{DBG_BUS_CLIENT_RBCX, DBG_BUS_CLIENT_RBCY, DBG_BUS_CLIENT_RBCY},
-	YSEM_REG_DBG_SELECT, YSEM_REG_DBG_DWORD_ENABLE,
-	YSEM_REG_DBG_SHIFT, YSEM_REG_DBG_FORCE_VALID,
-	YSEM_REG_DBG_FORCE_FRAME,
-	true, true, DBG_RESET_REG_MISC_PL_PDA_VMAIN_2, 11
-};
-
-static struct block_defs block_psem_defs = {
-	"psem",
-	{true, true, true}, true, DBG_PSTORM_ID,
-	{DBG_BUS_CLIENT_RBCS, DBG_BUS_CLIENT_RBCS, DBG_BUS_CLIENT_RBCS},
-	PSEM_REG_DBG_SELECT, PSEM_REG_DBG_DWORD_ENABLE,
-	PSEM_REG_DBG_SHIFT, PSEM_REG_DBG_FORCE_VALID,
-	PSEM_REG_DBG_FORCE_FRAME,
-	true, true, DBG_RESET_REG_MISC_PL_PDA_VMAIN_2, 10
-};
-
-static struct block_defs block_rss_defs = {
-	"rss",
-	{true, true, true}, false, 0,
-	{DBG_BUS_CLIENT_RBCT, DBG_BUS_CLIENT_RBCT, DBG_BUS_CLIENT_RBCT},
-	RSS_REG_DBG_SELECT, RSS_REG_DBG_DWORD_ENABLE,
-	RSS_REG_DBG_SHIFT, RSS_REG_DBG_FORCE_VALID,
-	RSS_REG_DBG_FORCE_FRAME,
-	true, true, DBG_RESET_REG_MISC_PL_PDA_VMAIN_2, 18
-};
-
-static struct block_defs block_tmld_defs = {
-	"tmld",
-	{true, true, true}, false, 0,
-	{DBG_BUS_CLIENT_RBCT, DBG_BUS_CLIENT_RBCM, DBG_BUS_CLIENT_RBCM},
-	TMLD_REG_DBG_SELECT, TMLD_REG_DBG_DWORD_ENABLE,
-	TMLD_REG_DBG_SHIFT, TMLD_REG_DBG_FORCE_VALID,
-	TMLD_REG_DBG_FORCE_FRAME,
-	true, true, DBG_RESET_REG_MISC_PL_PDA_VMAIN_2, 13
-};
-
-static struct block_defs block_muld_defs = {
-	"muld",
-	{true, true, true}, false, 0,
-	{DBG_BUS_CLIENT_RBCU, DBG_BUS_CLIENT_RBCU, DBG_BUS_CLIENT_RBCU},
-	MULD_REG_DBG_SELECT, MULD_REG_DBG_DWORD_ENABLE,
-	MULD_REG_DBG_SHIFT, MULD_REG_DBG_FORCE_VALID,
-	MULD_REG_DBG_FORCE_FRAME,
-	true, true, DBG_RESET_REG_MISC_PL_PDA_VMAIN_2, 14
-};
-
-static struct block_defs block_yuld_defs = {
-	"yuld",
-	{true, true, false}, false, 0,
-	{DBG_BUS_CLIENT_RBCU, DBG_BUS_CLIENT_RBCU,
-	 MAX_DBG_BUS_CLIENTS},
-	YULD_REG_DBG_SELECT_BB_K2, YULD_REG_DBG_DWORD_ENABLE_BB_K2,
-	YULD_REG_DBG_SHIFT_BB_K2, YULD_REG_DBG_FORCE_VALID_BB_K2,
-	YULD_REG_DBG_FORCE_FRAME_BB_K2,
-	true, true, DBG_RESET_REG_MISC_PL_PDA_VMAIN_2,
-	15
-};
-
-static struct block_defs block_xyld_defs = {
-	"xyld",
-	{true, true, true}, false, 0,
-	{DBG_BUS_CLIENT_RBCX, DBG_BUS_CLIENT_RBCX, DBG_BUS_CLIENT_RBCX},
-	XYLD_REG_DBG_SELECT, XYLD_REG_DBG_DWORD_ENABLE,
-	XYLD_REG_DBG_SHIFT, XYLD_REG_DBG_FORCE_VALID,
-	XYLD_REG_DBG_FORCE_FRAME,
-	true, true, DBG_RESET_REG_MISC_PL_PDA_VMAIN_2, 12
-};
-
-static struct block_defs block_ptld_defs = {
-	"ptld",
-	{false, false, true}, false, 0,
-	{MAX_DBG_BUS_CLIENTS, MAX_DBG_BUS_CLIENTS, DBG_BUS_CLIENT_RBCT},
-	PTLD_REG_DBG_SELECT_E5, PTLD_REG_DBG_DWORD_ENABLE_E5,
-	PTLD_REG_DBG_SHIFT_E5, PTLD_REG_DBG_FORCE_VALID_E5,
-	PTLD_REG_DBG_FORCE_FRAME_E5,
-	true, true, DBG_RESET_REG_MISC_PL_PDA_VMAIN_2,
-	28
-};
-
-static struct block_defs block_ypld_defs = {
-	"ypld",
-	{false, false, true}, false, 0,
-	{MAX_DBG_BUS_CLIENTS, MAX_DBG_BUS_CLIENTS, DBG_BUS_CLIENT_RBCS},
-	YPLD_REG_DBG_SELECT_E5, YPLD_REG_DBG_DWORD_ENABLE_E5,
-	YPLD_REG_DBG_SHIFT_E5, YPLD_REG_DBG_FORCE_VALID_E5,
-	YPLD_REG_DBG_FORCE_FRAME_E5,
-	true, true, DBG_RESET_REG_MISC_PL_PDA_VMAIN_2,
-	27
-};
-
-static struct block_defs block_prm_defs = {
-	"prm",
-	{true, true, true}, false, 0,
-	{DBG_BUS_CLIENT_RBCT, DBG_BUS_CLIENT_RBCM, DBG_BUS_CLIENT_RBCM},
-	PRM_REG_DBG_SELECT, PRM_REG_DBG_DWORD_ENABLE,
-	PRM_REG_DBG_SHIFT, PRM_REG_DBG_FORCE_VALID,
-	PRM_REG_DBG_FORCE_FRAME,
-	true, true, DBG_RESET_REG_MISC_PL_PDA_VMAIN_2, 21
-};
-
-static struct block_defs block_pbf_pb1_defs = {
-	"pbf_pb1",
-	{true, true, true}, false, 0,
-	{DBG_BUS_CLIENT_RBCS, DBG_BUS_CLIENT_RBCV, DBG_BUS_CLIENT_RBCV},
-	PBF_PB1_REG_DBG_SELECT, PBF_PB1_REG_DBG_DWORD_ENABLE,
-	PBF_PB1_REG_DBG_SHIFT, PBF_PB1_REG_DBG_FORCE_VALID,
-	PBF_PB1_REG_DBG_FORCE_FRAME,
-	true, true, DBG_RESET_REG_MISC_PL_PDA_VMAIN_1,
-	11
-};
-
-static struct block_defs block_pbf_pb2_defs = {
-	"pbf_pb2",
-	{true, true, true}, false, 0,
-	{DBG_BUS_CLIENT_RBCS, DBG_BUS_CLIENT_RBCV, DBG_BUS_CLIENT_RBCV},
-	PBF_PB2_REG_DBG_SELECT, PBF_PB2_REG_DBG_DWORD_ENABLE,
-	PBF_PB2_REG_DBG_SHIFT, PBF_PB2_REG_DBG_FORCE_VALID,
-	PBF_PB2_REG_DBG_FORCE_FRAME,
-	true, true, DBG_RESET_REG_MISC_PL_PDA_VMAIN_1,
-	12
-};
-
-static struct block_defs block_rpb_defs = {
-	"rpb",
-	{true, true, true}, false, 0,
-	{DBG_BUS_CLIENT_RBCT, DBG_BUS_CLIENT_RBCM, DBG_BUS_CLIENT_RBCM},
-	RPB_REG_DBG_SELECT, RPB_REG_DBG_DWORD_ENABLE,
-	RPB_REG_DBG_SHIFT, RPB_REG_DBG_FORCE_VALID,
-	RPB_REG_DBG_FORCE_FRAME,
-	true, true, DBG_RESET_REG_MISC_PL_PDA_VMAIN_1, 13
-};
-
-static struct block_defs block_btb_defs = {
-	"btb",
-	{true, true, true}, false, 0,
-	{DBG_BUS_CLIENT_RBCR, DBG_BUS_CLIENT_RBCV, DBG_BUS_CLIENT_RBCV},
-	BTB_REG_DBG_SELECT, BTB_REG_DBG_DWORD_ENABLE,
-	BTB_REG_DBG_SHIFT, BTB_REG_DBG_FORCE_VALID,
-	BTB_REG_DBG_FORCE_FRAME,
-	true, true, DBG_RESET_REG_MISC_PL_PDA_VMAIN_1, 10
-};
-
-static struct block_defs block_pbf_defs = {
-	"pbf",
-	{true, true, true}, false, 0,
-	{DBG_BUS_CLIENT_RBCS, DBG_BUS_CLIENT_RBCV, DBG_BUS_CLIENT_RBCV},
-	PBF_REG_DBG_SELECT, PBF_REG_DBG_DWORD_ENABLE,
-	PBF_REG_DBG_SHIFT, PBF_REG_DBG_FORCE_VALID,
-	PBF_REG_DBG_FORCE_FRAME,
-	true, true, DBG_RESET_REG_MISC_PL_PDA_VMAIN_1, 15
-};
-
-static struct block_defs block_rdif_defs = {
-	"rdif",
-	{true, true, true}, false, 0,
-	{DBG_BUS_CLIENT_RBCT, DBG_BUS_CLIENT_RBCM, DBG_BUS_CLIENT_RBCM},
-	RDIF_REG_DBG_SELECT, RDIF_REG_DBG_DWORD_ENABLE,
-	RDIF_REG_DBG_SHIFT, RDIF_REG_DBG_FORCE_VALID,
-	RDIF_REG_DBG_FORCE_FRAME,
-	true, true, DBG_RESET_REG_MISC_PL_PDA_VMAIN_2, 16
-};
-
-static struct block_defs block_tdif_defs = {
-	"tdif",
-	{true, true, true}, false, 0,
-	{DBG_BUS_CLIENT_RBCS, DBG_BUS_CLIENT_RBCS, DBG_BUS_CLIENT_RBCS},
-	TDIF_REG_DBG_SELECT, TDIF_REG_DBG_DWORD_ENABLE,
-	TDIF_REG_DBG_SHIFT, TDIF_REG_DBG_FORCE_VALID,
-	TDIF_REG_DBG_FORCE_FRAME,
-	true, true, DBG_RESET_REG_MISC_PL_PDA_VMAIN_2, 17
-};
-
-static struct block_defs block_cdu_defs = {
-	"cdu",
-	{true, true, true}, false, 0,
-	{DBG_BUS_CLIENT_RBCF, DBG_BUS_CLIENT_RBCF, DBG_BUS_CLIENT_RBCF},
-	CDU_REG_DBG_SELECT, CDU_REG_DBG_DWORD_ENABLE,
-	CDU_REG_DBG_SHIFT, CDU_REG_DBG_FORCE_VALID,
-	CDU_REG_DBG_FORCE_FRAME,
-	true, true, DBG_RESET_REG_MISC_PL_PDA_VMAIN_1, 23
-};
-
-static struct block_defs block_ccfc_defs = {
-	"ccfc",
-	{true, true, true}, false, 0,
-	{DBG_BUS_CLIENT_RBCF, DBG_BUS_CLIENT_RBCF, DBG_BUS_CLIENT_RBCF},
-	CCFC_REG_DBG_SELECT, CCFC_REG_DBG_DWORD_ENABLE,
-	CCFC_REG_DBG_SHIFT, CCFC_REG_DBG_FORCE_VALID,
-	CCFC_REG_DBG_FORCE_FRAME,
-	true, true, DBG_RESET_REG_MISC_PL_PDA_VMAIN_1, 24
-};
-
-static struct block_defs block_tcfc_defs = {
-	"tcfc",
-	{true, true, true}, false, 0,
-	{DBG_BUS_CLIENT_RBCF, DBG_BUS_CLIENT_RBCF, DBG_BUS_CLIENT_RBCF},
-	TCFC_REG_DBG_SELECT, TCFC_REG_DBG_DWORD_ENABLE,
-	TCFC_REG_DBG_SHIFT, TCFC_REG_DBG_FORCE_VALID,
-	TCFC_REG_DBG_FORCE_FRAME,
-	true, true, DBG_RESET_REG_MISC_PL_PDA_VMAIN_1, 25
-};
-
-static struct block_defs block_igu_defs = {
-	"igu",
-	{true, true, true}, false, 0,
-	{DBG_BUS_CLIENT_RBCP, DBG_BUS_CLIENT_RBCP, DBG_BUS_CLIENT_RBCP},
-	IGU_REG_DBG_SELECT, IGU_REG_DBG_DWORD_ENABLE,
-	IGU_REG_DBG_SHIFT, IGU_REG_DBG_FORCE_VALID,
-	IGU_REG_DBG_FORCE_FRAME,
-	true, true, DBG_RESET_REG_MISC_PL_PDA_VMAIN_1, 27
-};
-
-static struct block_defs block_cau_defs = {
-	"cau",
-	{true, true, true}, false, 0,
-	{DBG_BUS_CLIENT_RBCP, DBG_BUS_CLIENT_RBCP, DBG_BUS_CLIENT_RBCP},
-	CAU_REG_DBG_SELECT, CAU_REG_DBG_DWORD_ENABLE,
-	CAU_REG_DBG_SHIFT, CAU_REG_DBG_FORCE_VALID,
-	CAU_REG_DBG_FORCE_FRAME,
-	true, true, DBG_RESET_REG_MISC_PL_PDA_VMAIN_2, 19
-};
-
-static struct block_defs block_rgfs_defs = {
-	"rgfs", {false, false, true}, false, 0,
-	{MAX_DBG_BUS_CLIENTS, MAX_DBG_BUS_CLIENTS, MAX_DBG_BUS_CLIENTS},
-	0, 0, 0, 0, 0,
-	true, true, DBG_RESET_REG_MISC_PL_PDA_VMAIN_2, 29
-};
-
-static struct block_defs block_rgsrc_defs = {
-	"rgsrc",
-	{false, false, true}, false, 0,
-	{MAX_DBG_BUS_CLIENTS, MAX_DBG_BUS_CLIENTS, DBG_BUS_CLIENT_RBCH},
-	RGSRC_REG_DBG_SELECT_E5, RGSRC_REG_DBG_DWORD_ENABLE_E5,
-	RGSRC_REG_DBG_SHIFT_E5, RGSRC_REG_DBG_FORCE_VALID_E5,
-	RGSRC_REG_DBG_FORCE_FRAME_E5,
-	true, true, DBG_RESET_REG_MISC_PL_PDA_VMAIN_1,
-	30
-};
-
-static struct block_defs block_tgfs_defs = {
-	"tgfs", {false, false, true}, false, 0,
-	{MAX_DBG_BUS_CLIENTS, MAX_DBG_BUS_CLIENTS, MAX_DBG_BUS_CLIENTS},
-	0, 0, 0, 0, 0,
-	true, true, DBG_RESET_REG_MISC_PL_PDA_VMAIN_2, 30
-};
-
-static struct block_defs block_tgsrc_defs = {
-	"tgsrc",
-	{false, false, true}, false, 0,
-	{MAX_DBG_BUS_CLIENTS, MAX_DBG_BUS_CLIENTS, DBG_BUS_CLIENT_RBCV},
-	TGSRC_REG_DBG_SELECT_E5, TGSRC_REG_DBG_DWORD_ENABLE_E5,
-	TGSRC_REG_DBG_SHIFT_E5, TGSRC_REG_DBG_FORCE_VALID_E5,
-	TGSRC_REG_DBG_FORCE_FRAME_E5,
-	true, true, DBG_RESET_REG_MISC_PL_PDA_VMAIN_1,
-	31
-};
-
-static struct block_defs block_umac_defs = {
-	"umac",
-	{true, true, true}, false, 0,
-	{MAX_DBG_BUS_CLIENTS, DBG_BUS_CLIENT_RBCZ,
-	 DBG_BUS_CLIENT_RBCZ},
-	UMAC_REG_DBG_SELECT_K2_E5, UMAC_REG_DBG_DWORD_ENABLE_K2_E5,
-	UMAC_REG_DBG_SHIFT_K2_E5, UMAC_REG_DBG_FORCE_VALID_K2_E5,
-	UMAC_REG_DBG_FORCE_FRAME_K2_E5,
-	true, false, DBG_RESET_REG_MISCS_PL_HV, 6
-};
-
-static struct block_defs block_xmac_defs = {
-	"xmac", {true, false, false}, false, 0,
-	{MAX_DBG_BUS_CLIENTS, MAX_DBG_BUS_CLIENTS, MAX_DBG_BUS_CLIENTS},
-	0, 0, 0, 0, 0,
-	false, false, MAX_DBG_RESET_REGS, 0
-};
-
-static struct block_defs block_dbg_defs = {
-	"dbg", {true, true, true}, false, 0,
-	{MAX_DBG_BUS_CLIENTS, MAX_DBG_BUS_CLIENTS, MAX_DBG_BUS_CLIENTS},
-	0, 0, 0, 0, 0,
-	true, true, DBG_RESET_REG_MISC_PL_PDA_VAUX, 3
-};
-
-static struct block_defs block_nig_defs = {
-	"nig",
-	{true, true, true}, false, 0,
-	{DBG_BUS_CLIENT_RBCN, DBG_BUS_CLIENT_RBCN, DBG_BUS_CLIENT_RBCN},
-	NIG_REG_DBG_SELECT, NIG_REG_DBG_DWORD_ENABLE,
-	NIG_REG_DBG_SHIFT, NIG_REG_DBG_FORCE_VALID,
-	NIG_REG_DBG_FORCE_FRAME,
-	true, true, DBG_RESET_REG_MISC_PL_PDA_VAUX, 0
-};
-
-static struct block_defs block_wol_defs = {
-	"wol",
-	{false, true, true}, false, 0,
-	{MAX_DBG_BUS_CLIENTS, DBG_BUS_CLIENT_RBCZ, DBG_BUS_CLIENT_RBCZ},
-	WOL_REG_DBG_SELECT_K2_E5, WOL_REG_DBG_DWORD_ENABLE_K2_E5,
-	WOL_REG_DBG_SHIFT_K2_E5, WOL_REG_DBG_FORCE_VALID_K2_E5,
-	WOL_REG_DBG_FORCE_FRAME_K2_E5,
-	true, true, DBG_RESET_REG_MISC_PL_PDA_VAUX, 7
-};
-
-static struct block_defs block_bmbn_defs = {
-	"bmbn",
-	{false, true, true}, false, 0,
-	{MAX_DBG_BUS_CLIENTS, DBG_BUS_CLIENT_RBCB,
-	 DBG_BUS_CLIENT_RBCB},
-	BMBN_REG_DBG_SELECT_K2_E5, BMBN_REG_DBG_DWORD_ENABLE_K2_E5,
-	BMBN_REG_DBG_SHIFT_K2_E5, BMBN_REG_DBG_FORCE_VALID_K2_E5,
-	BMBN_REG_DBG_FORCE_FRAME_K2_E5,
-	false, false, MAX_DBG_RESET_REGS, 0
-};
-
-static struct block_defs block_ipc_defs = {
-	"ipc", {true, true, true}, false, 0,
-	{MAX_DBG_BUS_CLIENTS, MAX_DBG_BUS_CLIENTS, MAX_DBG_BUS_CLIENTS},
-	0, 0, 0, 0, 0,
-	true, false, DBG_RESET_REG_MISCS_PL_UA, 8
-};
-
-static struct block_defs block_nwm_defs = {
-	"nwm",
-	{false, true, true}, false, 0,
-	{MAX_DBG_BUS_CLIENTS, DBG_BUS_CLIENT_RBCW, DBG_BUS_CLIENT_RBCW},
-	NWM_REG_DBG_SELECT_K2_E5, NWM_REG_DBG_DWORD_ENABLE_K2_E5,
-	NWM_REG_DBG_SHIFT_K2_E5, NWM_REG_DBG_FORCE_VALID_K2_E5,
-	NWM_REG_DBG_FORCE_FRAME_K2_E5,
-	true, false, DBG_RESET_REG_MISCS_PL_HV_2, 0
-};
-
-static struct block_defs block_nws_defs = {
-	"nws",
-	{false, true, true}, false, 0,
-	{MAX_DBG_BUS_CLIENTS, DBG_BUS_CLIENT_RBCW, DBG_BUS_CLIENT_RBCW},
-	NWS_REG_DBG_SELECT_K2_E5, NWS_REG_DBG_DWORD_ENABLE_K2_E5,
-	NWS_REG_DBG_SHIFT_K2_E5, NWS_REG_DBG_FORCE_VALID_K2_E5,
-	NWS_REG_DBG_FORCE_FRAME_K2_E5,
-	true, false, DBG_RESET_REG_MISCS_PL_HV, 12
-};
-
-static struct block_defs block_ms_defs = {
-	"ms",
-	{false, true, true}, false, 0,
-	{MAX_DBG_BUS_CLIENTS, DBG_BUS_CLIENT_RBCZ, DBG_BUS_CLIENT_RBCZ},
-	MS_REG_DBG_SELECT_K2_E5, MS_REG_DBG_DWORD_ENABLE_K2_E5,
-	MS_REG_DBG_SHIFT_K2_E5, MS_REG_DBG_FORCE_VALID_K2_E5,
-	MS_REG_DBG_FORCE_FRAME_K2_E5,
-	true, false, DBG_RESET_REG_MISCS_PL_HV, 13
-};
-
-static struct block_defs block_phy_pcie_defs = {
-	"phy_pcie",
-	{false, true, true}, false, 0,
-	{MAX_DBG_BUS_CLIENTS, DBG_BUS_CLIENT_RBCH,
-	 DBG_BUS_CLIENT_RBCH},
-	PCIE_REG_DBG_COMMON_SELECT_K2_E5,
-	PCIE_REG_DBG_COMMON_DWORD_ENABLE_K2_E5,
-	PCIE_REG_DBG_COMMON_SHIFT_K2_E5,
-	PCIE_REG_DBG_COMMON_FORCE_VALID_K2_E5,
-	PCIE_REG_DBG_COMMON_FORCE_FRAME_K2_E5,
-	false, false, MAX_DBG_RESET_REGS, 0
-};
-
-static struct block_defs block_led_defs = {
-	"led", {false, true, true}, false, 0,
-	{MAX_DBG_BUS_CLIENTS, MAX_DBG_BUS_CLIENTS, MAX_DBG_BUS_CLIENTS},
-	0, 0, 0, 0, 0,
-	true, false, DBG_RESET_REG_MISCS_PL_HV, 14
-};
-
-static struct block_defs block_avs_wrap_defs = {
-	"avs_wrap", {false, true, false}, false, 0,
-	{MAX_DBG_BUS_CLIENTS, MAX_DBG_BUS_CLIENTS, MAX_DBG_BUS_CLIENTS},
-	0, 0, 0, 0, 0,
-	true, false, DBG_RESET_REG_MISCS_PL_UA, 11
-};
-
-static struct block_defs block_pxpreqbus_defs = {
-	"pxpreqbus", {false, false, false}, false, 0,
-	{MAX_DBG_BUS_CLIENTS, MAX_DBG_BUS_CLIENTS, MAX_DBG_BUS_CLIENTS},
-	0, 0, 0, 0, 0,
-	false, false, MAX_DBG_RESET_REGS, 0
-};
-
-static struct block_defs block_misc_aeu_defs = {
-	"misc_aeu", {true, true, true}, false, 0,
-	{MAX_DBG_BUS_CLIENTS, MAX_DBG_BUS_CLIENTS, MAX_DBG_BUS_CLIENTS},
-	0, 0, 0, 0, 0,
-	false, false, MAX_DBG_RESET_REGS, 0
-};
-
-static struct block_defs block_bar0_map_defs = {
-	"bar0_map", {true, true, true}, false, 0,
-	{MAX_DBG_BUS_CLIENTS, MAX_DBG_BUS_CLIENTS, MAX_DBG_BUS_CLIENTS},
-	0, 0, 0, 0, 0,
-	false, false, MAX_DBG_RESET_REGS, 0
-};
-
-static struct block_defs *s_block_defs[MAX_BLOCK_ID] = {
-	&block_grc_defs,
-	&block_miscs_defs,
-	&block_misc_defs,
-	&block_dbu_defs,
-	&block_pglue_b_defs,
-	&block_cnig_defs,
-	&block_cpmu_defs,
-	&block_ncsi_defs,
-	&block_opte_defs,
-	&block_bmb_defs,
-	&block_pcie_defs,
-	&block_mcp_defs,
-	&block_mcp2_defs,
-	&block_pswhst_defs,
-	&block_pswhst2_defs,
-	&block_pswrd_defs,
-	&block_pswrd2_defs,
-	&block_pswwr_defs,
-	&block_pswwr2_defs,
-	&block_pswrq_defs,
-	&block_pswrq2_defs,
-	&block_pglcs_defs,
-	&block_dmae_defs,
-	&block_ptu_defs,
-	&block_tcm_defs,
-	&block_mcm_defs,
-	&block_ucm_defs,
-	&block_xcm_defs,
-	&block_ycm_defs,
-	&block_pcm_defs,
-	&block_qm_defs,
-	&block_tm_defs,
-	&block_dorq_defs,
-	&block_brb_defs,
-	&block_src_defs,
-	&block_prs_defs,
-	&block_tsdm_defs,
-	&block_msdm_defs,
-	&block_usdm_defs,
-	&block_xsdm_defs,
-	&block_ysdm_defs,
-	&block_psdm_defs,
-	&block_tsem_defs,
-	&block_msem_defs,
-	&block_usem_defs,
-	&block_xsem_defs,
-	&block_ysem_defs,
-	&block_psem_defs,
-	&block_rss_defs,
-	&block_tmld_defs,
-	&block_muld_defs,
-	&block_yuld_defs,
-	&block_xyld_defs,
-	&block_ptld_defs,
-	&block_ypld_defs,
-	&block_prm_defs,
-	&block_pbf_pb1_defs,
-	&block_pbf_pb2_defs,
-	&block_rpb_defs,
-	&block_btb_defs,
-	&block_pbf_defs,
-	&block_rdif_defs,
-	&block_tdif_defs,
-	&block_cdu_defs,
-	&block_ccfc_defs,
-	&block_tcfc_defs,
-	&block_igu_defs,
-	&block_cau_defs,
-	&block_rgfs_defs,
-	&block_rgsrc_defs,
-	&block_tgfs_defs,
-	&block_tgsrc_defs,
-	&block_umac_defs,
-	&block_xmac_defs,
-	&block_dbg_defs,
-	&block_nig_defs,
-	&block_wol_defs,
-	&block_bmbn_defs,
-	&block_ipc_defs,
-	&block_nwm_defs,
-	&block_nws_defs,
-	&block_ms_defs,
-	&block_phy_pcie_defs,
-	&block_led_defs,
-	&block_avs_wrap_defs,
-	&block_pxpreqbus_defs,
-	&block_misc_aeu_defs,
-	&block_bar0_map_defs,
-};
-
-static struct platform_defs s_platform_defs[] = {
+		{DBG_BUS_CLIENT_RBCS, DBG_BUS_CLIENT_RBCS},
+		true,
+		PSEM_REG_FAST_MEMORY,
+		PSEM_REG_DBG_FRAME_MODE_BB_K2,
+		PSEM_REG_SLOW_DBG_ACTIVE_BB_K2,
+		PSEM_REG_SLOW_DBG_MODE_BB_K2,
+		PSEM_REG_DBG_MODE1_CFG_BB_K2,
+		PSEM_REG_SYNC_DBG_EMPTY,
+		PSEM_REG_DBG_GPRE_VECT,
+		PCM_REG_CTX_RBC_ACCS,
+		{0, PCM_REG_SM_CON_CTX, 0, 0},
+		{{0, 10, 0, 0}, {0, 10, 0, 0}} /* {bb} {k2} */
+	},
+};
+
+static struct hw_type_defs s_hw_type_defs[] = {
+	/* HW_TYPE_ASIC */
 	{"asic", 1, 256, 32768},
 	{"reserved", 0, 0, 0},
 	{"reserved2", 0, 0, 0},
@@ -1509,161 +580,159 @@ static struct platform_defs s_platform_defs[] = {
 
 static struct grc_param_defs s_grc_param_defs[] = {
 	/* DBG_GRC_PARAM_DUMP_TSTORM */
-	{{1, 1, 1}, 0, 1, false, false, 1, 1},
+	{{1, 1}, 0, 1, false, false, 1, {1, 1}},
 
 	/* DBG_GRC_PARAM_DUMP_MSTORM */
-	{{1, 1, 1}, 0, 1, false, false, 1, 1},
+	{{1, 1}, 0, 1, false, false, 1, {1, 1}},
 
 	/* DBG_GRC_PARAM_DUMP_USTORM */
-	{{1, 1, 1}, 0, 1, false, false, 1, 1},
+	{{1, 1}, 0, 1, false, false, 1, {1, 1}},
 
 	/* DBG_GRC_PARAM_DUMP_XSTORM */
-	{{1, 1, 1}, 0, 1, false, false, 1, 1},
+	{{1, 1}, 0, 1, false, false, 1, {1, 1}},
 
 	/* DBG_GRC_PARAM_DUMP_YSTORM */
-	{{1, 1, 1}, 0, 1, false, false, 1, 1},
+	{{1, 1}, 0, 1, false, false, 1, {1, 1}},
 
 	/* DBG_GRC_PARAM_DUMP_PSTORM */
-	{{1, 1, 1}, 0, 1, false, false, 1, 1},
+	{{1, 1}, 0, 1, false, false, 1, {1, 1}},
 
 	/* DBG_GRC_PARAM_DUMP_REGS */
-	{{1, 1, 1}, 0, 1, false, false, 0, 1},
+	{{1, 1}, 0, 1, false, false, 0, {1, 1}},
 
 	/* DBG_GRC_PARAM_DUMP_RAM */
-	{{1, 1, 1}, 0, 1, false, false, 0, 1},
+	{{1, 1}, 0, 1, false, false, 0, {1, 1}},
 
 	/* DBG_GRC_PARAM_DUMP_PBUF */
-	{{1, 1, 1}, 0, 1, false, false, 0, 1},
+	{{1, 1}, 0, 1, false, false, 0, {1, 1}},
 
 	/* DBG_GRC_PARAM_DUMP_IOR */
-	{{0, 0, 0}, 0, 1, false, false, 0, 1},
+	{{0, 0}, 0, 1, false, false, 0, {1, 1}},
 
 	/* DBG_GRC_PARAM_DUMP_VFC */
-	{{0, 0, 0}, 0, 1, false, false, 0, 1},
+	{{0, 0}, 0, 1, false, false, 0, {1, 1}},
 
 	/* DBG_GRC_PARAM_DUMP_CM_CTX */
-	{{1, 1, 1}, 0, 1, false, false, 0, 1},
+	{{1, 1}, 0, 1, false, false, 0, {1, 1}},
 
 	/* DBG_GRC_PARAM_DUMP_ILT */
-	{{1, 1, 1}, 0, 1, false, false, 0, 1},
+	{{1, 1}, 0, 1, false, false, 0, {1, 1}},
 
 	/* DBG_GRC_PARAM_DUMP_RSS */
-	{{1, 1, 1}, 0, 1, false, false, 0, 1},
+	{{1, 1}, 0, 1, false, false, 0, {1, 1}},
 
 	/* DBG_GRC_PARAM_DUMP_CAU */
-	{{1, 1, 1}, 0, 1, false, false, 0, 1},
+	{{1, 1}, 0, 1, false, false, 0, {1, 1}},
 
 	/* DBG_GRC_PARAM_DUMP_QM */
-	{{1, 1, 1}, 0, 1, false, false, 0, 1},
+	{{1, 1}, 0, 1, false, false, 0, {1, 1}},
 
 	/* DBG_GRC_PARAM_DUMP_MCP */
-	{{1, 1, 1}, 0, 1, false, false, 0, 1},
+	{{1, 1}, 0, 1, false, false, 0, {1, 1}},
 
-	/* DBG_GRC_PARAM_MCP_TRACE_META_SIZE */
-	{{1, 1, 1}, 1, 0xffffffff, false, true, 0, 1},
+	/* DBG_GRC_PARAM_DUMP_DORQ */
+	{{1, 1}, 0, 1, false, false, 0, {1, 1}},
 
 	/* DBG_GRC_PARAM_DUMP_CFC */
-	{{1, 1, 1}, 0, 1, false, false, 0, 1},
+	{{1, 1}, 0, 1, false, false, 0, {1, 1}},
 
 	/* DBG_GRC_PARAM_DUMP_IGU */
-	{{1, 1, 1}, 0, 1, false, false, 0, 1},
+	{{1, 1}, 0, 1, false, false, 0, {1, 1}},
 
 	/* DBG_GRC_PARAM_DUMP_BRB */
-	{{0, 0, 0}, 0, 1, false, false, 0, 1},
+	{{0, 0}, 0, 1, false, false, 0, {1, 1}},
 
 	/* DBG_GRC_PARAM_DUMP_BTB */
-	{{0, 0, 0}, 0, 1, false, false, 0, 1},
+	{{0, 0}, 0, 1, false, false, 0, {1, 1}},
 
 	/* DBG_GRC_PARAM_DUMP_BMB */
-	{{0, 0, 0}, 0, 1, false, false, 0, 0},
+	{{0, 0}, 0, 1, false, false, 0, {0, 0}},
 
-	/* DBG_GRC_PARAM_DUMP_NIG */
-	{{1, 1, 1}, 0, 1, false, false, 0, 1},
+	/* DBG_GRC_PARAM_RESERVED1 */
+	{{0, 0}, 0, 1, false, false, 0, {0, 0}},
 
 	/* DBG_GRC_PARAM_DUMP_MULD */
-	{{1, 1, 1}, 0, 1, false, false, 0, 1},
+	{{1, 1}, 0, 1, false, false, 0, {1, 1}},
 
 	/* DBG_GRC_PARAM_DUMP_PRS */
-	{{1, 1, 1}, 0, 1, false, false, 0, 1},
+	{{1, 1}, 0, 1, false, false, 0, {1, 1}},
 
 	/* DBG_GRC_PARAM_DUMP_DMAE */
-	{{1, 1, 1}, 0, 1, false, false, 0, 1},
+	{{1, 1}, 0, 1, false, false, 0, {1, 1}},
 
 	/* DBG_GRC_PARAM_DUMP_TM */
-	{{1, 1, 1}, 0, 1, false, false, 0, 1},
+	{{1, 1}, 0, 1, false, false, 0, {1, 1}},
 
 	/* DBG_GRC_PARAM_DUMP_SDM */
-	{{1, 1, 1}, 0, 1, false, false, 0, 1},
+	{{1, 1}, 0, 1, false, false, 0, {1, 1}},
 
 	/* DBG_GRC_PARAM_DUMP_DIF */
-	{{1, 1, 1}, 0, 1, false, false, 0, 1},
+	{{1, 1}, 0, 1, false, false, 0, {1, 1}},
 
 	/* DBG_GRC_PARAM_DUMP_STATIC */
-	{{1, 1, 1}, 0, 1, false, false, 0, 1},
+	{{1, 1}, 0, 1, false, false, 0, {1, 1}},
 
 	/* DBG_GRC_PARAM_UNSTALL */
-	{{0, 0, 0}, 0, 1, false, false, 0, 0},
+	{{0, 0}, 0, 1, false, false, 0, {0, 0}},
 
-	/* DBG_GRC_PARAM_NUM_LCIDS */
-	{{MAX_LCIDS, MAX_LCIDS, MAX_LCIDS}, 1, MAX_LCIDS, false, false,
-	 MAX_LCIDS, MAX_LCIDS},
+	/* DBG_GRC_PARAM_RESERVED2 */
+	{{0, 0}, 0, 1, false, false, 0, {0, 0}},
 
-	/* DBG_GRC_PARAM_NUM_LTIDS */
-	{{MAX_LTIDS, MAX_LTIDS, MAX_LTIDS}, 1, MAX_LTIDS, false, false,
-	 MAX_LTIDS, MAX_LTIDS},
+	/* DBG_GRC_PARAM_MCP_TRACE_META_SIZE */
+	{{0, 0}, 1, 0xffffffff, false, true, 0, {0, 0}},
 
 	/* DBG_GRC_PARAM_EXCLUDE_ALL */
-	{{0, 0, 0}, 0, 1, true, false, 0, 0},
+	{{0, 0}, 0, 1, true, false, 0, {0, 0}},
 
 	/* DBG_GRC_PARAM_CRASH */
-	{{0, 0, 0}, 0, 1, true, false, 0, 0},
+	{{0, 0}, 0, 1, true, false, 0, {0, 0}},
 
 	/* DBG_GRC_PARAM_PARITY_SAFE */
-	{{0, 0, 0}, 0, 1, false, false, 1, 0},
+	{{0, 0}, 0, 1, false, false, 0, {0, 0}},
 
 	/* DBG_GRC_PARAM_DUMP_CM */
-	{{1, 1, 1}, 0, 1, false, false, 0, 1},
+	{{1, 1}, 0, 1, false, false, 0, {1, 1}},
 
 	/* DBG_GRC_PARAM_DUMP_PHY */
-	{{1, 1, 1}, 0, 1, false, false, 0, 1},
+	{{0, 0}, 0, 1, false, false, 0, {0, 0}},
 
 	/* DBG_GRC_PARAM_NO_MCP */
-	{{0, 0, 0}, 0, 1, false, false, 0, 0},
+	{{0, 0}, 0, 1, false, false, 0, {0, 0}},
 
 	/* DBG_GRC_PARAM_NO_FW_VER */
-	{{0, 0, 0}, 0, 1, false, false, 0, 0},
+	{{0, 0}, 0, 1, false, false, 0, {0, 0}},
 
 	/* DBG_GRC_PARAM_RESERVED3 */
-	{{0, 0, 0}, 0, 1, false, false, 0, 0},
+	{{0, 0}, 0, 1, false, false, 0, {0, 0}},
 
 	/* DBG_GRC_PARAM_DUMP_MCP_HW_DUMP */
-	{{0, 1, 1}, 0, 1, false, false, 0, 0},
+	{{0, 1}, 0, 1, false, false, 0, {0, 1}},
 
 	/* DBG_GRC_PARAM_DUMP_ILT_CDUC */
-	{{1, 1, 1}, 0, 1, false, false, 0, 0},
+	{{1, 1}, 0, 1, false, false, 0, {0, 0}},
 
 	/* DBG_GRC_PARAM_DUMP_ILT_CDUT */
-	{{1, 1, 1}, 0, 1, false, false, 0, 0},
+	{{1, 1}, 0, 1, false, false, 0, {0, 0}},
 
 	/* DBG_GRC_PARAM_DUMP_CAU_EXT */
-	{{0, 0, 0}, 0, 1, false, false, 0, 1}
+	{{0, 0}, 0, 1, false, false, 0, {1, 1}}
 };
 
 static struct rss_mem_defs s_rss_mem_defs[] = {
-	{ "rss_mem_cid", "rss_cid", 0, 32,
-	  {256, 320, 512} },
+	{"rss_mem_cid", "rss_cid", 0, 32,
+	 {256, 320}},
 
-	{ "rss_mem_key_msb", "rss_key", 1024, 256,
-	  {128, 208, 257} },
+	{"rss_mem_key_msb", "rss_key", 1024, 256,
+	 {128, 208}},
 
-	{ "rss_mem_key_lsb", "rss_key", 2048, 64,
-	  {128, 208, 257} },
+	{"rss_mem_key_lsb", "rss_key", 2048, 64,
+	 {128, 208}},
 
-	{ "rss_mem_info", "rss_info", 3072, 16,
-	  {128, 208, 256} },
+	{"rss_mem_info", "rss_info", 3072, 16,
+	 {128, 208}},
 
-	{ "rss_mem_ind", "rss_ind", 4096, 16,
-	  {16384, 26624, 32768} }
+	{"rss_mem_ind", "rss_ind", 4096, 16,
+	 {16384, 26624}}
 };
 
 static struct vfc_ram_defs s_vfc_ram_defs[] = {
@@ -1674,54 +743,31 @@ static struct vfc_ram_defs s_vfc_ram_defs[] = {
 };
 
 static struct big_ram_defs s_big_ram_defs[] = {
-	{ "BRB", MEM_GROUP_BRB_MEM, MEM_GROUP_BRB_RAM, DBG_GRC_PARAM_DUMP_BRB,
-	  BRB_REG_BIG_RAM_ADDRESS, BRB_REG_BIG_RAM_DATA,
-	  MISC_REG_BLOCK_256B_EN, {0, 0, 0},
-	  {153600, 180224, 282624} },
-
-	{ "BTB", MEM_GROUP_BTB_MEM, MEM_GROUP_BTB_RAM, DBG_GRC_PARAM_DUMP_BTB,
-	  BTB_REG_BIG_RAM_ADDRESS, BTB_REG_BIG_RAM_DATA,
-	  MISC_REG_BLOCK_256B_EN, {0, 1, 1},
-	  {92160, 117760, 168960} },
-
-	{ "BMB", MEM_GROUP_BMB_MEM, MEM_GROUP_BMB_RAM, DBG_GRC_PARAM_DUMP_BMB,
-	  BMB_REG_BIG_RAM_ADDRESS, BMB_REG_BIG_RAM_DATA,
-	  MISCS_REG_BLOCK_256B_EN, {0, 0, 0},
-	  {36864, 36864, 36864} }
-};
-
-static struct reset_reg_defs s_reset_regs_defs[] = {
-	/* DBG_RESET_REG_MISCS_PL_UA */
-	{ MISCS_REG_RESET_PL_UA,
-	  {true, true, true}, {0x0, 0x0, 0x0} },
-
-	/* DBG_RESET_REG_MISCS_PL_HV */
-	{ MISCS_REG_RESET_PL_HV,
-	  {true, true, true}, {0x0, 0x400, 0x600} },
-
-	/* DBG_RESET_REG_MISCS_PL_HV_2 */
-	{ MISCS_REG_RESET_PL_HV_2_K2_E5,
-	  {false, true, true}, {0x0, 0x0, 0x0} },
-
-	/* DBG_RESET_REG_MISC_PL_UA */
-	{ MISC_REG_RESET_PL_UA,
-	  {true, true, true}, {0x0, 0x0, 0x0} },
-
-	/* DBG_RESET_REG_MISC_PL_HV */
-	{ MISC_REG_RESET_PL_HV,
-	  {true, true, true}, {0x0, 0x0, 0x0} },
+	{"BRB", MEM_GROUP_BRB_MEM, MEM_GROUP_BRB_RAM, DBG_GRC_PARAM_DUMP_BRB,
+	 BRB_REG_BIG_RAM_ADDRESS, BRB_REG_BIG_RAM_DATA,
+	 MISC_REG_BLOCK_256B_EN, {0, 0},
+	 {153600, 180224}},
 
-	/* DBG_RESET_REG_MISC_PL_PDA_VMAIN_1 */
-	{ MISC_REG_RESET_PL_PDA_VMAIN_1,
-	  {true, true, true}, {0x4404040, 0x4404040, 0x404040} },
+	{"BTB", MEM_GROUP_BTB_MEM, MEM_GROUP_BTB_RAM, DBG_GRC_PARAM_DUMP_BTB,
+	 BTB_REG_BIG_RAM_ADDRESS, BTB_REG_BIG_RAM_DATA,
+	 MISC_REG_BLOCK_256B_EN, {0, 1},
+	 {92160, 117760}},
 
-	/* DBG_RESET_REG_MISC_PL_PDA_VMAIN_2 */
-	{ MISC_REG_RESET_PL_PDA_VMAIN_2,
-	  {true, true, true}, {0x7, 0x7c00007, 0x5c08007} },
+	{"BMB", MEM_GROUP_BMB_MEM, MEM_GROUP_BMB_RAM, DBG_GRC_PARAM_DUMP_BMB,
+	 BMB_REG_BIG_RAM_ADDRESS, BMB_REG_BIG_RAM_DATA,
+	 MISCS_REG_BLOCK_256B_EN, {0, 0},
+	 {36864, 36864}}
+};
 
-	/* DBG_RESET_REG_MISC_PL_PDA_VAUX */
-	{ MISC_REG_RESET_PL_PDA_VAUX,
-	  {true, true, true}, {0x2, 0x2, 0x2} },
+static struct rbc_reset_defs s_rbc_reset_defs[] = {
+	{MISCS_REG_RESET_PL_HV,
+	 {0x0, 0x400}},
+	{MISC_REG_RESET_PL_PDA_VMAIN_1,
+	 {0x4404040, 0x4404040}},
+	{MISC_REG_RESET_PL_PDA_VMAIN_2,
+	 {0x7, 0x7c00007}},
+	{MISC_REG_RESET_PL_PDA_VAUX,
+	 {0x2, 0x2}},
 };
 
 static struct phy_defs s_phy_defs[] = {
@@ -1804,9 +850,19 @@ static void qed_dbg_grc_init_params(struct qed_hwfn *p_hwfn)
 	}
 }
 
+/* Sets pointer and size for the specified binary buffer type */
+static void qed_set_dbg_bin_buf(struct qed_hwfn *p_hwfn,
+				enum bin_dbg_buffer_type buf_type,
+				const u32 *ptr, u32 size)
+{
+	struct virt_mem_desc *buf = &p_hwfn->dbg_arrays[buf_type];
+
+	buf->ptr = (void *)ptr;
+	buf->size = size;
+}
+
 /* Initializes debug data for the specified device */
-static enum dbg_status qed_dbg_dev_init(struct qed_hwfn *p_hwfn,
-					struct qed_ptt *p_ptt)
+static enum dbg_status qed_dbg_dev_init(struct qed_hwfn *p_hwfn)
 {
 	struct dbg_tools_data *dev_data = &p_hwfn->dbg_info;
 	u8 num_pfs = 0, max_pfs_per_port = 0;
@@ -1831,26 +887,25 @@ static enum dbg_status qed_dbg_dev_init(struct qed_hwfn *p_hwfn,
 		return DBG_STATUS_UNKNOWN_CHIP;
 	}
 
-	/* Set platofrm */
-	dev_data->platform_id = PLATFORM_ASIC;
+	/* Set HW type */
+	dev_data->hw_type = HW_TYPE_ASIC;
 	dev_data->mode_enable[MODE_ASIC] = 1;
 
 	/* Set port mode */
-	switch (qed_rd(p_hwfn, p_ptt, MISC_REG_PORT_MODE)) {
-	case 0:
+	switch (p_hwfn->cdev->num_ports_in_engine) {
+	case 1:
 		dev_data->mode_enable[MODE_PORTS_PER_ENG_1] = 1;
 		break;
-	case 1:
+	case 2:
 		dev_data->mode_enable[MODE_PORTS_PER_ENG_2] = 1;
 		break;
-	case 2:
+	case 4:
 		dev_data->mode_enable[MODE_PORTS_PER_ENG_4] = 1;
 		break;
 	}
 
 	/* Set 100G mode */
-	if (dev_data->chip_id == CHIP_BB &&
-	    qed_rd(p_hwfn, p_ptt, CNIG_REG_NW_PORT_MODE_BB) == 2)
+	if (QED_IS_CMT(p_hwfn->cdev))
 		dev_data->mode_enable[MODE_100G] = 1;
 
 	/* Set number of ports */
@@ -1876,14 +931,36 @@ static enum dbg_status qed_dbg_dev_init(struct qed_hwfn *p_hwfn,
 	return DBG_STATUS_OK;
 }
 
-static struct dbg_bus_block *get_dbg_bus_block_desc(struct qed_hwfn *p_hwfn,
-						    enum block_id block_id)
+static const struct dbg_block *get_dbg_block(struct qed_hwfn *p_hwfn,
+					     enum block_id block_id)
+{
+	const struct dbg_block *dbg_block;
+
+	dbg_block = p_hwfn->dbg_arrays[BIN_BUF_DBG_BLOCKS].ptr;
+	return dbg_block + block_id;
+}
+
+static const struct dbg_block_chip *qed_get_dbg_block_per_chip(struct qed_hwfn
+							       *p_hwfn,
+							       enum block_id
+							       block_id)
+{
+	struct dbg_tools_data *dev_data = &p_hwfn->dbg_info;
+
+	return (const struct dbg_block_chip *)
+	    p_hwfn->dbg_arrays[BIN_BUF_DBG_BLOCKS_CHIP_DATA].ptr +
+	    block_id * MAX_CHIP_IDS + dev_data->chip_id;
+}
+
+static const struct dbg_reset_reg *qed_get_dbg_reset_reg(struct qed_hwfn
+							 *p_hwfn,
+							 u8 reset_reg_id)
 {
 	struct dbg_tools_data *dev_data = &p_hwfn->dbg_info;
 
-	return (struct dbg_bus_block *)&dbg_bus_blocks[block_id *
-						       MAX_CHIP_IDS +
-						       dev_data->chip_id];
+	return (const struct dbg_reset_reg *)
+	    p_hwfn->dbg_arrays[BIN_BUF_DBG_RESET_REGS].ptr +
+	    reset_reg_id * MAX_CHIP_IDS + dev_data->chip_id;
 }
 
 /* Reads the FW info structure for the specified Storm from the chip,
@@ -1904,8 +981,9 @@ static void qed_read_storm_fw_info(struct qed_hwfn *p_hwfn,
 	 * The address is located in the last line of the Storm RAM.
 	 */
 	addr = storm->sem_fast_mem_addr + SEM_FAST_REG_INT_RAM +
-	       DWORDS_TO_BYTES(SEM_FAST_REG_INT_RAM_SIZE_BB_K2) -
-	       sizeof(fw_info_location);
+	    DWORDS_TO_BYTES(SEM_FAST_REG_INT_RAM_SIZE) -
+	    sizeof(fw_info_location);
+
 	dest = (u32 *)&fw_info_location;
 
 	for (i = 0; i < BYTES_TO_DWORDS(sizeof(fw_info_location));
@@ -2100,6 +1178,29 @@ static u32 qed_dump_mfw_ver_param(struct qed_hwfn *p_hwfn,
 	return qed_dump_str_param(dump_buf, dump, "mfw-version", mfw_ver_str);
 }
 
+/* Reads the chip revision from the chip and writes it as a param to the
+ * specified buffer. Returns the dumped size in dwords.
+ */
+static u32 qed_dump_chip_revision_param(struct qed_hwfn *p_hwfn,
+					struct qed_ptt *p_ptt,
+					u32 *dump_buf, bool dump)
+{
+	struct dbg_tools_data *dev_data = &p_hwfn->dbg_info;
+	char param_str[3] = "??";
+
+	if (dev_data->hw_type == HW_TYPE_ASIC) {
+		u32 chip_rev, chip_metal;
+
+		chip_rev = qed_rd(p_hwfn, p_ptt, MISCS_REG_CHIP_REV);
+		chip_metal = qed_rd(p_hwfn, p_ptt, MISCS_REG_CHIP_METAL);
+
+		param_str[0] = 'a' + (u8)chip_rev;
+		param_str[1] = '0' + (u8)chip_metal;
+	}
+
+	return qed_dump_str_param(dump_buf, dump, "chip-revision", param_str);
+}
+
 /* Writes a section header to the specified buffer.
  * Returns the dumped size in dwords.
  */
@@ -2119,11 +1220,16 @@ static u32 qed_dump_common_global_params(struct qed_hwfn *p_hwfn,
 					 u8 num_specific_global_params)
 {
 	struct dbg_tools_data *dev_data = &p_hwfn->dbg_info;
+	char sw_platform_str[MAX_SW_PLTAFORM_STR_SIZE];
 	u32 offset = 0;
 	u8 num_params;
 
+	/* Fill platform string */
+	qed_set_platform_str(p_hwfn, sw_platform_str, MAX_SW_PLTAFORM_STR_SIZE);
+
 	/* Dump global params section header */
-	num_params = NUM_COMMON_GLOBAL_PARAMS + num_specific_global_params;
+	num_params = NUM_COMMON_GLOBAL_PARAMS + num_specific_global_params +
+		(dev_data->chip_id == CHIP_BB ? 1 : 0);
 	offset += qed_dump_section_hdr(dump_buf + offset,
 				       dump, "global_params", num_params);
 
@@ -2131,6 +1237,8 @@ static u32 qed_dump_common_global_params(struct qed_hwfn *p_hwfn,
 	offset += qed_dump_fw_ver_param(p_hwfn, p_ptt, dump_buf + offset, dump);
 	offset += qed_dump_mfw_ver_param(p_hwfn,
 					 p_ptt, dump_buf + offset, dump);
+	offset += qed_dump_chip_revision_param(p_hwfn,
+					       p_ptt, dump_buf + offset, dump);
 	offset += qed_dump_num_param(dump_buf + offset,
 				     dump, "tools-version", TOOLS_VERSION);
 	offset += qed_dump_str_param(dump_buf + offset,
@@ -2140,11 +1248,16 @@ static u32 qed_dump_common_global_params(struct qed_hwfn *p_hwfn,
 	offset += qed_dump_str_param(dump_buf + offset,
 				     dump,
 				     "platform",
-				     s_platform_defs[dev_data->platform_id].
-				     name);
-	offset +=
-	    qed_dump_num_param(dump_buf + offset, dump, "pci-func",
-			       p_hwfn->abs_pf_id);
+				     s_hw_type_defs[dev_data->hw_type].name);
+	offset += qed_dump_str_param(dump_buf + offset,
+				     dump, "sw-platform", sw_platform_str);
+	offset += qed_dump_num_param(dump_buf + offset,
+				     dump, "pci-func", p_hwfn->abs_pf_id);
+	offset += qed_dump_num_param(dump_buf + offset,
+				     dump, "epoch", qed_get_epoch_time());
+	if (dev_data->chip_id == CHIP_BB)
+		offset += qed_dump_num_param(dump_buf + offset,
+					     dump, "path", QED_PATH_ID(p_hwfn));
 
 	return offset;
 }
@@ -2175,24 +1288,87 @@ static void qed_update_blocks_reset_state(struct qed_hwfn *p_hwfn,
 					  struct qed_ptt *p_ptt)
 {
 	struct dbg_tools_data *dev_data = &p_hwfn->dbg_info;
-	u32 reg_val[MAX_DBG_RESET_REGS] = { 0 };
-	u32 i;
+	u32 reg_val[NUM_DBG_RESET_REGS] = { 0 };
+	u8 rst_reg_id;
+	u32 blk_id;
 
 	/* Read reset registers */
-	for (i = 0; i < MAX_DBG_RESET_REGS; i++)
-		if (s_reset_regs_defs[i].exists[dev_data->chip_id])
-			reg_val[i] = qed_rd(p_hwfn,
-					    p_ptt, s_reset_regs_defs[i].addr);
+	for (rst_reg_id = 0; rst_reg_id < NUM_DBG_RESET_REGS; rst_reg_id++) {
+		const struct dbg_reset_reg *rst_reg;
+		bool rst_reg_removed;
+		u32 rst_reg_addr;
+
+		rst_reg = qed_get_dbg_reset_reg(p_hwfn, rst_reg_id);
+		rst_reg_removed = GET_FIELD(rst_reg->data,
+					    DBG_RESET_REG_IS_REMOVED);
+		rst_reg_addr = DWORDS_TO_BYTES(GET_FIELD(rst_reg->data,
+							 DBG_RESET_REG_ADDR));
+
+		if (!rst_reg_removed)
+			reg_val[rst_reg_id] = qed_rd(p_hwfn, p_ptt,
+						     rst_reg_addr);
+	}
 
 	/* Check if blocks are in reset */
-	for (i = 0; i < MAX_BLOCK_ID; i++) {
-		struct block_defs *block = s_block_defs[i];
+	for (blk_id = 0; blk_id < NUM_PHYS_BLOCKS; blk_id++) {
+		const struct dbg_block_chip *blk;
+		bool has_rst_reg;
+		bool is_removed;
+
+		blk = qed_get_dbg_block_per_chip(p_hwfn, (enum block_id)blk_id);
+		is_removed = GET_FIELD(blk->flags, DBG_BLOCK_CHIP_IS_REMOVED);
+		has_rst_reg = GET_FIELD(blk->flags,
+					DBG_BLOCK_CHIP_HAS_RESET_REG);
+
+		if (!is_removed && has_rst_reg)
+			dev_data->block_in_reset[blk_id] =
+			    !(reg_val[blk->reset_reg_id] &
+			      BIT(blk->reset_reg_bit_offset));
+	}
+}
+
+/* is_mode_match recursive function */
+static bool qed_is_mode_match_rec(struct qed_hwfn *p_hwfn,
+				  u16 *modes_buf_offset, u8 rec_depth)
+{
+	struct dbg_tools_data *dev_data = &p_hwfn->dbg_info;
+	u8 *dbg_array;
+	bool arg1, arg2;
+	u8 tree_val;
+
+	if (rec_depth > MAX_RECURSION_DEPTH) {
+		DP_NOTICE(p_hwfn,
+			  "Unexpected error: is_mode_match_rec exceeded the max recursion depth. This is probably due to a corrupt init/debug buffer.\n");
+		return false;
+	}
+
+	/* Get next element from modes tree buffer */
+	dbg_array = p_hwfn->dbg_arrays[BIN_BUF_DBG_MODE_TREE].ptr;
+	tree_val = dbg_array[(*modes_buf_offset)++];
 
-		dev_data->block_in_reset[i] = block->has_reset_bit &&
-		    !(reg_val[block->reset_reg] & BIT(block->reset_bit_offset));
+	switch (tree_val) {
+	case INIT_MODE_OP_NOT:
+		return !qed_is_mode_match_rec(p_hwfn,
+					      modes_buf_offset, rec_depth + 1);
+	case INIT_MODE_OP_OR:
+	case INIT_MODE_OP_AND:
+		arg1 = qed_is_mode_match_rec(p_hwfn,
+					     modes_buf_offset, rec_depth + 1);
+		arg2 = qed_is_mode_match_rec(p_hwfn,
+					     modes_buf_offset, rec_depth + 1);
+		return (tree_val == INIT_MODE_OP_OR) ? (arg1 ||
+							arg2) : (arg1 && arg2);
+	default:
+		return dev_data->mode_enable[tree_val - MAX_INIT_MODE_OPS] > 0;
 	}
 }
 
+/* Returns true if the mode (specified using modes_buf_offset) is enabled */
+static bool qed_is_mode_match(struct qed_hwfn *p_hwfn, u16 *modes_buf_offset)
+{
+	return qed_is_mode_match_rec(p_hwfn, modes_buf_offset, 0);
+}
+
 /* Enable / disable the Debug block */
 static void qed_bus_enable_dbg_block(struct qed_hwfn *p_hwfn,
 				     struct qed_ptt *p_ptt, bool enable)
@@ -2204,23 +1380,21 @@ static void qed_bus_enable_dbg_block(struct qed_hwfn *p_hwfn,
 static void qed_bus_reset_dbg_block(struct qed_hwfn *p_hwfn,
 				    struct qed_ptt *p_ptt)
 {
-	u32 dbg_reset_reg_addr, old_reset_reg_val, new_reset_reg_val;
-	struct block_defs *dbg_block = s_block_defs[BLOCK_DBG];
+	u32 reset_reg_addr, old_reset_reg_val, new_reset_reg_val;
+	const struct dbg_reset_reg *reset_reg;
+	const struct dbg_block_chip *block;
 
-	dbg_reset_reg_addr = s_reset_regs_defs[dbg_block->reset_reg].addr;
-	old_reset_reg_val = qed_rd(p_hwfn, p_ptt, dbg_reset_reg_addr);
-	new_reset_reg_val =
-	    old_reset_reg_val & ~BIT(dbg_block->reset_bit_offset);
+	block = qed_get_dbg_block_per_chip(p_hwfn, BLOCK_DBG);
+	reset_reg = qed_get_dbg_reset_reg(p_hwfn, block->reset_reg_id);
+	reset_reg_addr =
+	    DWORDS_TO_BYTES(GET_FIELD(reset_reg->data, DBG_RESET_REG_ADDR));
 
-	qed_wr(p_hwfn, p_ptt, dbg_reset_reg_addr, new_reset_reg_val);
-	qed_wr(p_hwfn, p_ptt, dbg_reset_reg_addr, old_reset_reg_val);
-}
+	old_reset_reg_val = qed_rd(p_hwfn, p_ptt, reset_reg_addr);
+	new_reset_reg_val =
+	    old_reset_reg_val & ~BIT(block->reset_reg_bit_offset);
 
-static void qed_bus_set_framing_mode(struct qed_hwfn *p_hwfn,
-				     struct qed_ptt *p_ptt,
-				     enum dbg_bus_frame_modes mode)
-{
-	qed_wr(p_hwfn, p_ptt, DBG_REG_FRAMING_MODE, (u8)mode);
+	qed_wr(p_hwfn, p_ptt, reset_reg_addr, new_reset_reg_val);
+	qed_wr(p_hwfn, p_ptt, reset_reg_addr, old_reset_reg_val);
 }
 
 /* Enable / disable Debug Bus clients according to the specified mask
@@ -2232,28 +1406,65 @@ static void qed_bus_enable_clients(struct qed_hwfn *p_hwfn,
 	qed_wr(p_hwfn, p_ptt, DBG_REG_CLIENT_ENABLE, client_mask);
 }
 
-static bool qed_is_mode_match(struct qed_hwfn *p_hwfn, u16 *modes_buf_offset)
+static void qed_bus_config_dbg_line(struct qed_hwfn *p_hwfn,
+				    struct qed_ptt *p_ptt,
+				    enum block_id block_id,
+				    u8 line_id,
+				    u8 enable_mask,
+				    u8 right_shift,
+				    u8 force_valid_mask, u8 force_frame_mask)
+{
+	const struct dbg_block_chip *block =
+		qed_get_dbg_block_per_chip(p_hwfn, block_id);
+
+	qed_wr(p_hwfn, p_ptt, DWORDS_TO_BYTES(block->dbg_select_reg_addr),
+	       line_id);
+	qed_wr(p_hwfn, p_ptt, DWORDS_TO_BYTES(block->dbg_dword_enable_reg_addr),
+	       enable_mask);
+	qed_wr(p_hwfn, p_ptt, DWORDS_TO_BYTES(block->dbg_shift_reg_addr),
+	       right_shift);
+	qed_wr(p_hwfn, p_ptt, DWORDS_TO_BYTES(block->dbg_force_valid_reg_addr),
+	       force_valid_mask);
+	qed_wr(p_hwfn, p_ptt, DWORDS_TO_BYTES(block->dbg_force_frame_reg_addr),
+	       force_frame_mask);
+}
+
+/* Disable debug bus in all blocks */
+static void qed_bus_disable_blocks(struct qed_hwfn *p_hwfn,
+				   struct qed_ptt *p_ptt)
 {
 	struct dbg_tools_data *dev_data = &p_hwfn->dbg_info;
-	bool arg1, arg2;
-	const u32 *ptr;
-	u8 tree_val;
+	u32 block_id;
 
-	/* Get next element from modes tree buffer */
-	ptr = s_dbg_arrays[BIN_BUF_DBG_MODE_TREE].ptr;
-	tree_val = ((u8 *)ptr)[(*modes_buf_offset)++];
+	/* Disable all blocks */
+	for (block_id = 0; block_id < MAX_BLOCK_ID; block_id++) {
+		const struct dbg_block_chip *block_per_chip =
+		    qed_get_dbg_block_per_chip(p_hwfn,
+					       (enum block_id)block_id);
 
-	switch (tree_val) {
-	case INIT_MODE_OP_NOT:
-		return !qed_is_mode_match(p_hwfn, modes_buf_offset);
-	case INIT_MODE_OP_OR:
-	case INIT_MODE_OP_AND:
-		arg1 = qed_is_mode_match(p_hwfn, modes_buf_offset);
-		arg2 = qed_is_mode_match(p_hwfn, modes_buf_offset);
-		return (tree_val == INIT_MODE_OP_OR) ? (arg1 ||
-							arg2) : (arg1 && arg2);
-	default:
-		return dev_data->mode_enable[tree_val - MAX_INIT_MODE_OPS] > 0;
+		if (GET_FIELD(block_per_chip->flags,
+			      DBG_BLOCK_CHIP_IS_REMOVED) ||
+		    dev_data->block_in_reset[block_id])
+			continue;
+
+		/* Disable debug bus */
+		if (GET_FIELD(block_per_chip->flags,
+			      DBG_BLOCK_CHIP_HAS_DBG_BUS)) {
+			u32 dbg_en_addr =
+				block_per_chip->dbg_dword_enable_reg_addr;
+			u16 modes_buf_offset =
+			    GET_FIELD(block_per_chip->dbg_bus_mode.data,
+				      DBG_MODE_HDR_MODES_BUF_OFFSET);
+			bool eval_mode =
+			    GET_FIELD(block_per_chip->dbg_bus_mode.data,
+				      DBG_MODE_HDR_EVAL_MODE) > 0;
+
+			if (!eval_mode ||
+			    qed_is_mode_match(p_hwfn, &modes_buf_offset))
+				qed_wr(p_hwfn, p_ptt,
+				       DWORDS_TO_BYTES(dbg_en_addr),
+				       0);
+		}
 	}
 }
 
@@ -2266,6 +1477,20 @@ static bool qed_grc_is_included(struct qed_hwfn *p_hwfn,
 	return qed_grc_get_param(p_hwfn, grc_param) > 0;
 }
 
+/* Returns the storm_id that matches the specified Storm letter,
+ * or MAX_DBG_STORMS if invalid storm letter.
+ */
+static enum dbg_storms qed_get_id_from_letter(char storm_letter)
+{
+	u8 storm_id;
+
+	for (storm_id = 0; storm_id < MAX_DBG_STORMS; storm_id++)
+		if (s_storm_defs[storm_id].letter == storm_letter)
+			return (enum dbg_storms)storm_id;
+
+	return MAX_DBG_STORMS;
+}
+
 /* Returns true of the specified Storm should be included in the dump, false
  * otherwise.
  */
@@ -2281,14 +1506,20 @@ static bool qed_grc_is_storm_included(struct qed_hwfn *p_hwfn,
 static bool qed_grc_is_mem_included(struct qed_hwfn *p_hwfn,
 				    enum block_id block_id, u8 mem_group_id)
 {
-	struct block_defs *block = s_block_defs[block_id];
+	const struct dbg_block *block;
 	u8 i;
 
-	/* Check Storm match */
-	if (block->associated_to_storm &&
-	    !qed_grc_is_storm_included(p_hwfn,
-				       (enum dbg_storms)block->storm_id))
-		return false;
+	block = get_dbg_block(p_hwfn, block_id);
+
+	/* If the block is associated with a Storm, check Storm match */
+	if (block->associated_storm_letter) {
+		enum dbg_storms associated_storm_id =
+		    qed_get_id_from_letter(block->associated_storm_letter);
+
+		if (associated_storm_id == MAX_DBG_STORMS ||
+		    !qed_grc_is_storm_included(p_hwfn, associated_storm_id))
+			return false;
+	}
 
 	for (i = 0; i < NUM_BIG_RAM_TYPES; i++) {
 		struct big_ram_defs *big_ram = &s_big_ram_defs[i];
@@ -2310,6 +1541,8 @@ static bool qed_grc_is_mem_included(struct qed_hwfn *p_hwfn,
 	case MEM_GROUP_CAU_SB:
 	case MEM_GROUP_CAU_PI:
 		return qed_grc_is_included(p_hwfn, DBG_GRC_PARAM_DUMP_CAU);
+	case MEM_GROUP_CAU_MEM_EXT:
+		return qed_grc_is_included(p_hwfn, DBG_GRC_PARAM_DUMP_CAU_EXT);
 	case MEM_GROUP_QM_MEM:
 		return qed_grc_is_included(p_hwfn, DBG_GRC_PARAM_DUMP_QM);
 	case MEM_GROUP_CFC_MEM:
@@ -2317,6 +1550,8 @@ static bool qed_grc_is_mem_included(struct qed_hwfn *p_hwfn,
 	case MEM_GROUP_TASK_CFC_MEM:
 		return qed_grc_is_included(p_hwfn, DBG_GRC_PARAM_DUMP_CFC) ||
 		       qed_grc_is_included(p_hwfn, DBG_GRC_PARAM_DUMP_CM_CTX);
+	case MEM_GROUP_DORQ_MEM:
+		return qed_grc_is_included(p_hwfn, DBG_GRC_PARAM_DUMP_DORQ);
 	case MEM_GROUP_IGU_MEM:
 	case MEM_GROUP_IGU_MSIX:
 		return qed_grc_is_included(p_hwfn, DBG_GRC_PARAM_DUMP_IGU);
@@ -2362,64 +1597,104 @@ static void qed_grc_stall_storms(struct qed_hwfn *p_hwfn,
 	msleep(STALL_DELAY_MS);
 }
 
-/* Takes all blocks out of reset */
+/* Takes all blocks out of reset. If rbc_only is true, only RBC clients are
+ * taken out of reset.
+ */
 static void qed_grc_unreset_blocks(struct qed_hwfn *p_hwfn,
-				   struct qed_ptt *p_ptt)
+				   struct qed_ptt *p_ptt, bool rbc_only)
 {
 	struct dbg_tools_data *dev_data = &p_hwfn->dbg_info;
-	u32 reg_val[MAX_DBG_RESET_REGS] = { 0 };
-	u32 block_id, i;
+	u8 chip_id = dev_data->chip_id;
+	u32 i;
 
-	/* Fill reset regs values */
-	for (block_id = 0; block_id < MAX_BLOCK_ID; block_id++) {
-		struct block_defs *block = s_block_defs[block_id];
+	/* Take RBCs out of reset */
+	for (i = 0; i < ARRAY_SIZE(s_rbc_reset_defs); i++)
+		if (s_rbc_reset_defs[i].reset_val[dev_data->chip_id])
+			qed_wr(p_hwfn,
+			       p_ptt,
+			       s_rbc_reset_defs[i].reset_reg_addr +
+			       RESET_REG_UNRESET_OFFSET,
+			       s_rbc_reset_defs[i].reset_val[chip_id]);
 
-		if (block->exists[dev_data->chip_id] && block->has_reset_bit &&
-		    block->unreset)
-			reg_val[block->reset_reg] |=
-			    BIT(block->reset_bit_offset);
-	}
+	if (!rbc_only) {
+		u32 reg_val[NUM_DBG_RESET_REGS] = { 0 };
+		u8 reset_reg_id;
+		u32 block_id;
 
-	/* Write reset registers */
-	for (i = 0; i < MAX_DBG_RESET_REGS; i++) {
-		if (!s_reset_regs_defs[i].exists[dev_data->chip_id])
-			continue;
+		/* Fill reset regs values */
+		for (block_id = 0; block_id < NUM_PHYS_BLOCKS; block_id++) {
+			bool is_removed, has_reset_reg, unreset_before_dump;
+			const struct dbg_block_chip *block;
+
+			block = qed_get_dbg_block_per_chip(p_hwfn,
+							   (enum block_id)
+							   block_id);
+			is_removed =
+			    GET_FIELD(block->flags, DBG_BLOCK_CHIP_IS_REMOVED);
+			has_reset_reg =
+			    GET_FIELD(block->flags,
+				      DBG_BLOCK_CHIP_HAS_RESET_REG);
+			unreset_before_dump =
+			    GET_FIELD(block->flags,
+				      DBG_BLOCK_CHIP_UNRESET_BEFORE_DUMP);
+
+			if (!is_removed && has_reset_reg && unreset_before_dump)
+				reg_val[block->reset_reg_id] |=
+				    BIT(block->reset_reg_bit_offset);
+		}
 
-		reg_val[i] |=
-			s_reset_regs_defs[i].unreset_val[dev_data->chip_id];
+		/* Write reset registers */
+		for (reset_reg_id = 0; reset_reg_id < NUM_DBG_RESET_REGS;
+		     reset_reg_id++) {
+			const struct dbg_reset_reg *reset_reg;
+			u32 reset_reg_addr;
 
-		if (reg_val[i])
-			qed_wr(p_hwfn,
-			       p_ptt,
-			       s_reset_regs_defs[i].addr +
-			       RESET_REG_UNRESET_OFFSET, reg_val[i]);
+			reset_reg = qed_get_dbg_reset_reg(p_hwfn, reset_reg_id);
+
+			if (GET_FIELD
+			    (reset_reg->data, DBG_RESET_REG_IS_REMOVED))
+				continue;
+
+			if (reg_val[reset_reg_id]) {
+				reset_reg_addr =
+				    GET_FIELD(reset_reg->data,
+					      DBG_RESET_REG_ADDR);
+				qed_wr(p_hwfn,
+				       p_ptt,
+				       DWORDS_TO_BYTES(reset_reg_addr) +
+				       RESET_REG_UNRESET_OFFSET,
+				       reg_val[reset_reg_id]);
+			}
+		}
 	}
 }
 
 /* Returns the attention block data of the specified block */
 static const struct dbg_attn_block_type_data *
-qed_get_block_attn_data(enum block_id block_id, enum dbg_attn_type attn_type)
+qed_get_block_attn_data(struct qed_hwfn *p_hwfn,
+			enum block_id block_id, enum dbg_attn_type attn_type)
 {
 	const struct dbg_attn_block *base_attn_block_arr =
-		(const struct dbg_attn_block *)
-		s_dbg_arrays[BIN_BUF_DBG_ATTN_BLOCKS].ptr;
+	    (const struct dbg_attn_block *)
+	    p_hwfn->dbg_arrays[BIN_BUF_DBG_ATTN_BLOCKS].ptr;
 
 	return &base_attn_block_arr[block_id].per_type_data[attn_type];
 }
 
 /* Returns the attention registers of the specified block */
 static const struct dbg_attn_reg *
-qed_get_block_attn_regs(enum block_id block_id, enum dbg_attn_type attn_type,
+qed_get_block_attn_regs(struct qed_hwfn *p_hwfn,
+			enum block_id block_id, enum dbg_attn_type attn_type,
 			u8 *num_attn_regs)
 {
 	const struct dbg_attn_block_type_data *block_type_data =
-		qed_get_block_attn_data(block_id, attn_type);
+	    qed_get_block_attn_data(p_hwfn, block_id, attn_type);
 
 	*num_attn_regs = block_type_data->num_regs;
 
-	return &((const struct dbg_attn_reg *)
-		 s_dbg_arrays[BIN_BUF_DBG_ATTN_REGS].ptr)[block_type_data->
-							  regs_offset];
+	return (const struct dbg_attn_reg *)
+		p_hwfn->dbg_arrays[BIN_BUF_DBG_ATTN_REGS].ptr +
+		block_type_data->regs_offset;
 }
 
 /* For each block, clear the status of all parities */
@@ -2431,11 +1706,12 @@ static void qed_grc_clear_all_prty(struct qed_hwfn *p_hwfn,
 	u8 reg_idx, num_attn_regs;
 	u32 block_id;
 
-	for (block_id = 0; block_id < MAX_BLOCK_ID; block_id++) {
+	for (block_id = 0; block_id < NUM_PHYS_BLOCKS; block_id++) {
 		if (dev_data->block_in_reset[block_id])
 			continue;
 
-		attn_reg_arr = qed_get_block_attn_regs((enum block_id)block_id,
+		attn_reg_arr = qed_get_block_attn_regs(p_hwfn,
+						       (enum block_id)block_id,
 						       ATTN_TYPE_PARITY,
 						       &num_attn_regs);
 
@@ -2463,22 +1739,20 @@ static void qed_grc_clear_all_prty(struct qed_hwfn *p_hwfn,
 }
 
 /* Dumps GRC registers section header. Returns the dumped size in dwords.
- * The following parameters are dumped:
+ * the following parameters are dumped:
  * - count: no. of dumped entries
  * - split_type: split type
  * - split_id: split ID (dumped only if split_id != SPLIT_TYPE_NONE)
- * - param_name: user parameter value (dumped only if param_name != NULL
- *		 and param_val != NULL).
+ * - reg_type_name: register type name (dumped only if reg_type_name != NULL)
  */
 static u32 qed_grc_dump_regs_hdr(u32 *dump_buf,
 				 bool dump,
 				 u32 num_reg_entries,
 				 enum init_split_types split_type,
-				 u8 split_id,
-				 const char *param_name, const char *param_val)
+				 u8 split_id, const char *reg_type_name)
 {
 	u8 num_params = 2 +
-	    (split_type != SPLIT_TYPE_NONE ? 1 : 0) + (param_name ? 1 : 0);
+	    (split_type != SPLIT_TYPE_NONE ? 1 : 0) + (reg_type_name ? 1 : 0);
 	u32 offset = 0;
 
 	offset += qed_dump_section_hdr(dump_buf + offset,
@@ -2491,9 +1765,9 @@ static u32 qed_grc_dump_regs_hdr(u32 *dump_buf,
 	if (split_type != SPLIT_TYPE_NONE)
 		offset += qed_dump_num_param(dump_buf + offset,
 					     dump, "id", split_id);
-	if (param_name && param_val)
+	if (reg_type_name)
 		offset += qed_dump_str_param(dump_buf + offset,
-					     dump, param_name, param_val);
+					     dump, "type", reg_type_name);
 
 	return offset;
 }
@@ -2523,21 +1797,12 @@ static u32 qed_grc_dump_addr_range(struct qed_hwfn *p_hwfn,
 {
 	struct dbg_tools_data *dev_data = &p_hwfn->dbg_info;
 	u8 port_id = 0, pf_id = 0, vf_id = 0, fid = 0;
+	bool read_using_dmae = false;
+	u32 thresh;
 
 	if (!dump)
 		return len;
 
-	/* Print log if needed */
-	dev_data->num_regs_read += len;
-	if (dev_data->num_regs_read >=
-	    s_platform_defs[dev_data->platform_id].log_thresh) {
-		DP_VERBOSE(p_hwfn,
-			   QED_MSG_DEBUG,
-			   "Dumping %d registers...\n",
-			   dev_data->num_regs_read);
-		dev_data->num_regs_read = 0;
-	}
-
 	switch (split_type) {
 	case SPLIT_TYPE_PORT:
 		port_id = split_id;
@@ -2557,39 +1822,78 @@ static u32 qed_grc_dump_addr_range(struct qed_hwfn *p_hwfn,
 		break;
 	}
 
-	/* Try reading using DMAE */
-	if (dev_data->use_dmae && split_type == SPLIT_TYPE_NONE &&
-	    (len >= s_platform_defs[dev_data->platform_id].dmae_thresh ||
-	     wide_bus)) {
-		if (!qed_dmae_grc2host(p_hwfn, p_ptt, DWORDS_TO_BYTES(addr),
-				       (u64)(uintptr_t)(dump_buf), len, NULL))
-			return len;
-		dev_data->use_dmae = 0;
-		DP_VERBOSE(p_hwfn,
-			   QED_MSG_DEBUG,
-			   "Failed reading from chip using DMAE, using GRC instead\n");
+	/* Try reading using DMAE */
+	if (dev_data->use_dmae && split_type != SPLIT_TYPE_VF &&
+	    (len >= s_hw_type_defs[dev_data->hw_type].dmae_thresh ||
+	     (PROTECT_WIDE_BUS && wide_bus))) {
+		struct qed_dmae_params dmae_params;
+
+		/* Set DMAE params */
+		memset(&dmae_params, 0, sizeof(dmae_params));
+		SET_FIELD(dmae_params.flags, QED_DMAE_PARAMS_COMPLETION_DST, 1);
+		switch (split_type) {
+		case SPLIT_TYPE_PORT:
+			SET_FIELD(dmae_params.flags, QED_DMAE_PARAMS_PORT_VALID,
+				  1);
+			dmae_params.port_id = port_id;
+			break;
+		case SPLIT_TYPE_PF:
+			SET_FIELD(dmae_params.flags,
+				  QED_DMAE_PARAMS_SRC_PF_VALID, 1);
+			dmae_params.src_pfid = pf_id;
+			break;
+		case SPLIT_TYPE_PORT_PF:
+			SET_FIELD(dmae_params.flags, QED_DMAE_PARAMS_PORT_VALID,
+				  1);
+			SET_FIELD(dmae_params.flags,
+				  QED_DMAE_PARAMS_SRC_PF_VALID, 1);
+			dmae_params.port_id = port_id;
+			dmae_params.src_pfid = pf_id;
+			break;
+		default:
+			break;
+		}
+
+		/* Execute DMAE command */
+		read_using_dmae = !qed_dmae_grc2host(p_hwfn,
+						     p_ptt,
+						     DWORDS_TO_BYTES(addr),
+						     (u64)(uintptr_t)(dump_buf),
+						     len, &dmae_params);
+		if (!read_using_dmae) {
+			dev_data->use_dmae = 0;
+			DP_VERBOSE(p_hwfn,
+				   QED_MSG_DEBUG,
+				   "Failed reading from chip using DMAE, using GRC instead\n");
+		}
 	}
 
+	if (read_using_dmae)
+		goto print_log;
+
 	/* If not read using DMAE, read using GRC */
 
 	/* Set pretend */
-	if (split_type != dev_data->pretend.split_type || split_id !=
-	    dev_data->pretend.split_id) {
+	if (split_type != dev_data->pretend.split_type ||
+	    split_id != dev_data->pretend.split_id) {
 		switch (split_type) {
 		case SPLIT_TYPE_PORT:
 			qed_port_pretend(p_hwfn, p_ptt, port_id);
 			break;
 		case SPLIT_TYPE_PF:
-			fid = pf_id << PXP_PRETEND_CONCRETE_FID_PFID_SHIFT;
+			fid = FIELD_VALUE(PXP_PRETEND_CONCRETE_FID_PFID,
+					  pf_id);
 			qed_fid_pretend(p_hwfn, p_ptt, fid);
 			break;
 		case SPLIT_TYPE_PORT_PF:
-			fid = pf_id << PXP_PRETEND_CONCRETE_FID_PFID_SHIFT;
+			fid = FIELD_VALUE(PXP_PRETEND_CONCRETE_FID_PFID,
+					  pf_id);
 			qed_port_fid_pretend(p_hwfn, p_ptt, port_id, fid);
 			break;
 		case SPLIT_TYPE_VF:
-			fid = BIT(PXP_PRETEND_CONCRETE_FID_VFVALID_SHIFT) |
-			      (vf_id << PXP_PRETEND_CONCRETE_FID_VFID_SHIFT);
+			fid = FIELD_VALUE(PXP_PRETEND_CONCRETE_FID_VFVALID, 1)
+			      | FIELD_VALUE(PXP_PRETEND_CONCRETE_FID_VFID,
+					  vf_id);
 			qed_fid_pretend(p_hwfn, p_ptt, fid);
 			break;
 		default:
@@ -2603,6 +1907,16 @@ static u32 qed_grc_dump_addr_range(struct qed_hwfn *p_hwfn,
 	/* Read registers using GRC */
 	qed_read_regs(p_hwfn, p_ptt, dump_buf, addr, len);
 
+print_log:
+	/* Print log */
+	dev_data->num_regs_read += len;
+	thresh = s_hw_type_defs[dev_data->hw_type].log_thresh;
+	if ((dev_data->num_regs_read / thresh) >
+	    ((dev_data->num_regs_read - len) / thresh))
+		DP_VERBOSE(p_hwfn,
+			   QED_MSG_DEBUG,
+			   "Dumped %d registers...\n", dev_data->num_regs_read);
+
 	return len;
 }
 
@@ -2687,7 +2001,7 @@ static u32 qed_grc_dump_reg_entry_skip(struct qed_hwfn *p_hwfn,
 /* Dumps GRC registers entries. Returns the dumped size in dwords. */
 static u32 qed_grc_dump_regs_entries(struct qed_hwfn *p_hwfn,
 				     struct qed_ptt *p_ptt,
-				     struct dbg_array input_regs_arr,
+				     struct virt_mem_desc input_regs_arr,
 				     u32 *dump_buf,
 				     bool dump,
 				     enum init_split_types split_type,
@@ -2700,10 +2014,10 @@ static u32 qed_grc_dump_regs_entries(struct qed_hwfn *p_hwfn,
 
 	*num_dumped_reg_entries = 0;
 
-	while (input_offset < input_regs_arr.size_in_dwords) {
+	while (input_offset < BYTES_TO_DWORDS(input_regs_arr.size)) {
 		const struct dbg_dump_cond_hdr *cond_hdr =
 		    (const struct dbg_dump_cond_hdr *)
-		    &input_regs_arr.ptr[input_offset++];
+		    input_regs_arr.ptr + input_offset++;
 		u16 modes_buf_offset;
 		bool eval_mode;
 
@@ -2726,7 +2040,7 @@ static u32 qed_grc_dump_regs_entries(struct qed_hwfn *p_hwfn,
 		for (i = 0; i < cond_hdr->data_size; i++, input_offset++) {
 			const struct dbg_dump_reg *reg =
 			    (const struct dbg_dump_reg *)
-			    &input_regs_arr.ptr[input_offset];
+			    input_regs_arr.ptr + input_offset;
 			u32 addr, len;
 			bool wide_bus;
 
@@ -2751,14 +2065,12 @@ static u32 qed_grc_dump_regs_entries(struct qed_hwfn *p_hwfn,
 /* Dumps GRC registers entries. Returns the dumped size in dwords. */
 static u32 qed_grc_dump_split_data(struct qed_hwfn *p_hwfn,
 				   struct qed_ptt *p_ptt,
-				   struct dbg_array input_regs_arr,
+				   struct virt_mem_desc input_regs_arr,
 				   u32 *dump_buf,
 				   bool dump,
 				   bool block_enable[MAX_BLOCK_ID],
 				   enum init_split_types split_type,
-				   u8 split_id,
-				   const char *param_name,
-				   const char *param_val)
+				   u8 split_id, const char *reg_type_name)
 {
 	struct dbg_tools_data *dev_data = &p_hwfn->dbg_info;
 	enum init_split_types hdr_split_type = split_type;
@@ -2776,7 +2088,7 @@ static u32 qed_grc_dump_split_data(struct qed_hwfn *p_hwfn,
 				       false,
 				       0,
 				       hdr_split_type,
-				       hdr_split_id, param_name, param_val);
+				       hdr_split_id, reg_type_name);
 
 	/* Dump registers */
 	offset += qed_grc_dump_regs_entries(p_hwfn,
@@ -2795,7 +2107,7 @@ static u32 qed_grc_dump_split_data(struct qed_hwfn *p_hwfn,
 				      dump,
 				      num_dumped_reg_entries,
 				      hdr_split_type,
-				      hdr_split_id, param_name, param_val);
+				      hdr_split_id, reg_type_name);
 
 	return num_dumped_reg_entries > 0 ? offset : 0;
 }
@@ -2808,32 +2120,33 @@ static u32 qed_grc_dump_registers(struct qed_hwfn *p_hwfn,
 				  u32 *dump_buf,
 				  bool dump,
 				  bool block_enable[MAX_BLOCK_ID],
-				  const char *param_name, const char *param_val)
+				  const char *reg_type_name)
 {
+	struct virt_mem_desc *dbg_buf =
+	    &p_hwfn->dbg_arrays[BIN_BUF_DBG_DUMP_REG];
 	struct dbg_tools_data *dev_data = &p_hwfn->dbg_info;
 	u32 offset = 0, input_offset = 0;
-	u16 fid;
-	while (input_offset <
-	       s_dbg_arrays[BIN_BUF_DBG_DUMP_REG].size_in_dwords) {
+
+	while (input_offset < BYTES_TO_DWORDS(dbg_buf->size)) {
 		const struct dbg_dump_split_hdr *split_hdr;
-		struct dbg_array curr_input_regs_arr;
+		struct virt_mem_desc curr_input_regs_arr;
 		enum init_split_types split_type;
 		u16 split_count = 0;
 		u32 split_data_size;
 		u8 split_id;
 
 		split_hdr =
-			(const struct dbg_dump_split_hdr *)
-			&s_dbg_arrays[BIN_BUF_DBG_DUMP_REG].ptr[input_offset++];
+		    (const struct dbg_dump_split_hdr *)
+		    dbg_buf->ptr + input_offset++;
 		split_type =
-			GET_FIELD(split_hdr->hdr,
-				  DBG_DUMP_SPLIT_HDR_SPLIT_TYPE_ID);
-		split_data_size =
-			GET_FIELD(split_hdr->hdr,
-				  DBG_DUMP_SPLIT_HDR_DATA_SIZE);
+		    GET_FIELD(split_hdr->hdr,
+			      DBG_DUMP_SPLIT_HDR_SPLIT_TYPE_ID);
+		split_data_size = GET_FIELD(split_hdr->hdr,
+					    DBG_DUMP_SPLIT_HDR_DATA_SIZE);
 		curr_input_regs_arr.ptr =
-			&s_dbg_arrays[BIN_BUF_DBG_DUMP_REG].ptr[input_offset];
-		curr_input_regs_arr.size_in_dwords = split_data_size;
+		    (u32 *)p_hwfn->dbg_arrays[BIN_BUF_DBG_DUMP_REG].ptr +
+		    input_offset;
+		curr_input_regs_arr.size = DWORDS_TO_BYTES(split_data_size);
 
 		switch (split_type) {
 		case SPLIT_TYPE_NONE:
@@ -2861,16 +2174,16 @@ static u32 qed_grc_dump_registers(struct qed_hwfn *p_hwfn,
 							  dump, block_enable,
 							  split_type,
 							  split_id,
-							  param_name,
-							  param_val);
+							  reg_type_name);
 
 		input_offset += split_data_size;
 	}
 
 	/* Cancel pretends (pretend to original PF) */
 	if (dump) {
-		fid = p_hwfn->rel_pf_id << PXP_PRETEND_CONCRETE_FID_PFID_SHIFT;
-		qed_fid_pretend(p_hwfn, p_ptt, fid);
+		qed_fid_pretend(p_hwfn, p_ptt,
+				FIELD_VALUE(PXP_PRETEND_CONCRETE_FID_PFID,
+					    p_hwfn->rel_pf_id));
 		dev_data->pretend.split_type = SPLIT_TYPE_NONE;
 		dev_data->pretend.split_id = 0;
 	}
@@ -2883,26 +2196,32 @@ static u32 qed_grc_dump_reset_regs(struct qed_hwfn *p_hwfn,
 				   struct qed_ptt *p_ptt,
 				   u32 *dump_buf, bool dump)
 {
-	struct dbg_tools_data *dev_data = &p_hwfn->dbg_info;
-	u32 i, offset = 0, num_regs = 0;
+	u32 offset = 0, num_regs = 0;
+	u8 reset_reg_id;
 
 	/* Calculate header size */
 	offset += qed_grc_dump_regs_hdr(dump_buf,
-					false, 0,
-					SPLIT_TYPE_NONE, 0, NULL, NULL);
+					false,
+					0, SPLIT_TYPE_NONE, 0, "RESET_REGS");
 
 	/* Write reset registers */
-	for (i = 0; i < MAX_DBG_RESET_REGS; i++) {
-		if (!s_reset_regs_defs[i].exists[dev_data->chip_id])
+	for (reset_reg_id = 0; reset_reg_id < NUM_DBG_RESET_REGS;
+	     reset_reg_id++) {
+		const struct dbg_reset_reg *reset_reg;
+		u32 reset_reg_addr;
+
+		reset_reg = qed_get_dbg_reset_reg(p_hwfn, reset_reg_id);
+
+		if (GET_FIELD(reset_reg->data, DBG_RESET_REG_IS_REMOVED))
 			continue;
 
+		reset_reg_addr = GET_FIELD(reset_reg->data, DBG_RESET_REG_ADDR);
 		offset += qed_grc_dump_reg_entry(p_hwfn,
 						 p_ptt,
 						 dump_buf + offset,
 						 dump,
-						 BYTES_TO_DWORDS
-						 (s_reset_regs_defs[i].addr), 1,
-						 false, SPLIT_TYPE_NONE, 0);
+						 reset_reg_addr,
+						 1, false, SPLIT_TYPE_NONE, 0);
 		num_regs++;
 	}
 
@@ -2910,7 +2229,7 @@ static u32 qed_grc_dump_reset_regs(struct qed_hwfn *p_hwfn,
 	if (dump)
 		qed_grc_dump_regs_hdr(dump_buf,
 				      true, num_regs, SPLIT_TYPE_NONE,
-				      0, NULL, NULL);
+				      0, "RESET_REGS");
 
 	return offset;
 }
@@ -2923,21 +2242,23 @@ static u32 qed_grc_dump_modified_regs(struct qed_hwfn *p_hwfn,
 				      u32 *dump_buf, bool dump)
 {
 	struct dbg_tools_data *dev_data = &p_hwfn->dbg_info;
-	u32 block_id, offset = 0, num_reg_entries = 0;
+	u32 block_id, offset = 0, stall_regs_offset;
 	const struct dbg_attn_reg *attn_reg_arr;
 	u8 storm_id, reg_idx, num_attn_regs;
+	u32 num_reg_entries = 0;
 
-	/* Calculate header size */
+	/* Write empty header for attention registers */
 	offset += qed_grc_dump_regs_hdr(dump_buf,
-					false, 0, SPLIT_TYPE_NONE,
-					0, NULL, NULL);
+					false,
+					0, SPLIT_TYPE_NONE, 0, "ATTN_REGS");
 
 	/* Write parity registers */
-	for (block_id = 0; block_id < MAX_BLOCK_ID; block_id++) {
+	for (block_id = 0; block_id < NUM_PHYS_BLOCKS; block_id++) {
 		if (dev_data->block_in_reset[block_id] && dump)
 			continue;
 
-		attn_reg_arr = qed_get_block_attn_regs((enum block_id)block_id,
+		attn_reg_arr = qed_get_block_attn_regs(p_hwfn,
+						       (enum block_id)block_id,
 						       ATTN_TYPE_PARITY,
 						       &num_attn_regs);
 
@@ -2980,16 +2301,29 @@ static u32 qed_grc_dump_modified_regs(struct qed_hwfn *p_hwfn,
 		}
 	}
 
+	/* Overwrite header for attention registers */
+	if (dump)
+		qed_grc_dump_regs_hdr(dump_buf,
+				      true,
+				      num_reg_entries,
+				      SPLIT_TYPE_NONE, 0, "ATTN_REGS");
+
+	/* Write empty header for stall registers */
+	stall_regs_offset = offset;
+	offset += qed_grc_dump_regs_hdr(dump_buf,
+					false, 0, SPLIT_TYPE_NONE, 0, "REGS");
+
 	/* Write Storm stall status registers */
-	for (storm_id = 0; storm_id < MAX_DBG_STORMS; storm_id++) {
+	for (storm_id = 0, num_reg_entries = 0; storm_id < MAX_DBG_STORMS;
+	     storm_id++) {
 		struct storm_defs *storm = &s_storm_defs[storm_id];
 		u32 addr;
 
-		if (dev_data->block_in_reset[storm->block_id] && dump)
+		if (dev_data->block_in_reset[storm->sem_block_id] && dump)
 			continue;
 
 		addr =
-		    BYTES_TO_DWORDS(s_storm_defs[storm_id].sem_fast_mem_addr +
+		    BYTES_TO_DWORDS(storm->sem_fast_mem_addr +
 				    SEM_FAST_REG_STALLED);
 		offset += qed_grc_dump_reg_entry(p_hwfn,
 						 p_ptt,
@@ -3001,12 +2335,12 @@ static u32 qed_grc_dump_modified_regs(struct qed_hwfn *p_hwfn,
 		num_reg_entries++;
 	}
 
-	/* Write header */
+	/* Overwrite header for stall registers */
 	if (dump)
-		qed_grc_dump_regs_hdr(dump_buf,
+		qed_grc_dump_regs_hdr(dump_buf + stall_regs_offset,
 				      true,
-				      num_reg_entries, SPLIT_TYPE_NONE,
-				      0, NULL, NULL);
+				      num_reg_entries,
+				      SPLIT_TYPE_NONE, 0, "REGS");
 
 	return offset;
 }
@@ -3019,8 +2353,7 @@ static u32 qed_grc_dump_special_regs(struct qed_hwfn *p_hwfn,
 	u32 offset = 0, addr;
 
 	offset += qed_grc_dump_regs_hdr(dump_buf,
-					dump, 2, SPLIT_TYPE_NONE, 0,
-					NULL, NULL);
+					dump, 2, SPLIT_TYPE_NONE, 0, "REGS");
 
 	/* Dump R/TDIF_REG_DEBUG_ERROR_INFO_SIZE (every 8'th register should be
 	 * skipped).
@@ -3068,8 +2401,7 @@ static u32 qed_grc_dump_mem_hdr(struct qed_hwfn *p_hwfn,
 				u32 len,
 				u32 bit_width,
 				bool packed,
-				const char *mem_group,
-				bool is_storm, char storm_letter)
+				const char *mem_group, char storm_letter)
 {
 	u8 num_params = 3;
 	u32 offset = 0;
@@ -3090,7 +2422,7 @@ static u32 qed_grc_dump_mem_hdr(struct qed_hwfn *p_hwfn,
 
 	if (name) {
 		/* Dump name */
-		if (is_storm) {
+		if (storm_letter) {
 			strcpy(buf, "?STORM_");
 			buf[0] = storm_letter;
 			strcpy(buf + strlen(buf), name);
@@ -3122,7 +2454,7 @@ static u32 qed_grc_dump_mem_hdr(struct qed_hwfn *p_hwfn,
 					     dump, "packed", 1);
 
 	/* Dump reg type */
-	if (is_storm) {
+	if (storm_letter) {
 		strcpy(buf, "?STORM_");
 		buf[0] = storm_letter;
 		strcpy(buf + strlen(buf), mem_group);
@@ -3149,8 +2481,7 @@ static u32 qed_grc_dump_mem(struct qed_hwfn *p_hwfn,
 			    bool wide_bus,
 			    u32 bit_width,
 			    bool packed,
-			    const char *mem_group,
-			    bool is_storm, char storm_letter)
+			    const char *mem_group, char storm_letter)
 {
 	u32 offset = 0;
 
@@ -3161,8 +2492,7 @@ static u32 qed_grc_dump_mem(struct qed_hwfn *p_hwfn,
 				       addr,
 				       len,
 				       bit_width,
-				       packed,
-				       mem_group, is_storm, storm_letter);
+				       packed, mem_group, storm_letter);
 	offset += qed_grc_dump_addr_range(p_hwfn,
 					  p_ptt,
 					  dump_buf + offset,
@@ -3175,20 +2505,21 @@ static u32 qed_grc_dump_mem(struct qed_hwfn *p_hwfn,
 /* Dumps GRC memories entries. Returns the dumped size in dwords. */
 static u32 qed_grc_dump_mem_entries(struct qed_hwfn *p_hwfn,
 				    struct qed_ptt *p_ptt,
-				    struct dbg_array input_mems_arr,
+				    struct virt_mem_desc input_mems_arr,
 				    u32 *dump_buf, bool dump)
 {
 	u32 i, offset = 0, input_offset = 0;
 	bool mode_match = true;
 
-	while (input_offset < input_mems_arr.size_in_dwords) {
+	while (input_offset < BYTES_TO_DWORDS(input_mems_arr.size)) {
 		const struct dbg_dump_cond_hdr *cond_hdr;
 		u16 modes_buf_offset;
 		u32 num_entries;
 		bool eval_mode;
 
-		cond_hdr = (const struct dbg_dump_cond_hdr *)
-			   &input_mems_arr.ptr[input_offset++];
+		cond_hdr =
+		    (const struct dbg_dump_cond_hdr *)input_mems_arr.ptr +
+		    input_offset++;
 		num_entries = cond_hdr->data_size / MEM_DUMP_ENTRY_SIZE_DWORDS;
 
 		/* Check required mode */
@@ -3210,24 +2541,25 @@ static u32 qed_grc_dump_mem_entries(struct qed_hwfn *p_hwfn,
 		for (i = 0; i < num_entries;
 		     i++, input_offset += MEM_DUMP_ENTRY_SIZE_DWORDS) {
 			const struct dbg_dump_mem *mem =
-				(const struct dbg_dump_mem *)
-				&input_mems_arr.ptr[input_offset];
-			u8 mem_group_id = GET_FIELD(mem->dword0,
-						    DBG_DUMP_MEM_MEM_GROUP_ID);
-			bool is_storm = false, mem_wide_bus;
-			enum dbg_grc_params grc_param;
-			char storm_letter = 'a';
-			enum block_id block_id;
+			    (const struct dbg_dump_mem *)((u32 *)
+							  input_mems_arr.ptr
+							  + input_offset);
+			const struct dbg_block *block;
+			char storm_letter = 0;
 			u32 mem_addr, mem_len;
+			bool mem_wide_bus;
+			u8 mem_group_id;
 
+			mem_group_id = GET_FIELD(mem->dword0,
+						 DBG_DUMP_MEM_MEM_GROUP_ID);
 			if (mem_group_id >= MEM_GROUPS_NUM) {
 				DP_NOTICE(p_hwfn, "Invalid mem_group_id\n");
 				return 0;
 			}
 
-			block_id = (enum block_id)cond_hdr->block_id;
 			if (!qed_grc_is_mem_included(p_hwfn,
-						     block_id,
+						     (enum block_id)
+						     cond_hdr->block_id,
 						     mem_group_id))
 				continue;
 
@@ -3236,42 +2568,14 @@ static u32 qed_grc_dump_mem_entries(struct qed_hwfn *p_hwfn,
 			mem_wide_bus = GET_FIELD(mem->dword1,
 						 DBG_DUMP_MEM_WIDE_BUS);
 
-			/* Update memory length for CCFC/TCFC memories
-			 * according to number of LCIDs/LTIDs.
-			 */
-			if (mem_group_id == MEM_GROUP_CONN_CFC_MEM) {
-				if (mem_len % MAX_LCIDS) {
-					DP_NOTICE(p_hwfn,
-						  "Invalid CCFC connection memory size\n");
-					return 0;
-				}
-
-				grc_param = DBG_GRC_PARAM_NUM_LCIDS;
-				mem_len = qed_grc_get_param(p_hwfn, grc_param) *
-					  (mem_len / MAX_LCIDS);
-			} else if (mem_group_id == MEM_GROUP_TASK_CFC_MEM) {
-				if (mem_len % MAX_LTIDS) {
-					DP_NOTICE(p_hwfn,
-						  "Invalid TCFC task memory size\n");
-					return 0;
-				}
-
-				grc_param = DBG_GRC_PARAM_NUM_LTIDS;
-				mem_len = qed_grc_get_param(p_hwfn, grc_param) *
-					  (mem_len / MAX_LTIDS);
-			}
+			block = get_dbg_block(p_hwfn,
+					      cond_hdr->block_id);
 
-			/* If memory is associated with Storm, update Storm
-			 * details.
+			/* If memory is associated with Storm,
+			 * update storm details
 			 */
-			if (s_block_defs
-			    [cond_hdr->block_id]->associated_to_storm) {
-				is_storm = true;
-				storm_letter =
-				    s_storm_defs[s_block_defs
-						 [cond_hdr->block_id]->
-						 storm_id].letter;
-			}
+			if (block->associated_storm_letter)
+				storm_letter = block->associated_storm_letter;
 
 			/* Dump memory */
 			offset += qed_grc_dump_mem(p_hwfn,
@@ -3285,7 +2589,6 @@ static u32 qed_grc_dump_mem_entries(struct qed_hwfn *p_hwfn,
 						0,
 						false,
 						s_mem_group_names[mem_group_id],
-						is_storm,
 						storm_letter);
 		}
 	}
@@ -3300,26 +2603,25 @@ static u32 qed_grc_dump_memories(struct qed_hwfn *p_hwfn,
 				 struct qed_ptt *p_ptt,
 				 u32 *dump_buf, bool dump)
 {
+	struct virt_mem_desc *dbg_buf =
+	    &p_hwfn->dbg_arrays[BIN_BUF_DBG_DUMP_MEM];
 	u32 offset = 0, input_offset = 0;
 
-	while (input_offset <
-	       s_dbg_arrays[BIN_BUF_DBG_DUMP_MEM].size_in_dwords) {
+	while (input_offset < BYTES_TO_DWORDS(dbg_buf->size)) {
 		const struct dbg_dump_split_hdr *split_hdr;
-		struct dbg_array curr_input_mems_arr;
+		struct virt_mem_desc curr_input_mems_arr;
 		enum init_split_types split_type;
 		u32 split_data_size;
 
-		split_hdr = (const struct dbg_dump_split_hdr *)
-			&s_dbg_arrays[BIN_BUF_DBG_DUMP_MEM].ptr[input_offset++];
-		split_type =
-			GET_FIELD(split_hdr->hdr,
-				  DBG_DUMP_SPLIT_HDR_SPLIT_TYPE_ID);
-		split_data_size =
-			GET_FIELD(split_hdr->hdr,
-				  DBG_DUMP_SPLIT_HDR_DATA_SIZE);
-		curr_input_mems_arr.ptr =
-			&s_dbg_arrays[BIN_BUF_DBG_DUMP_MEM].ptr[input_offset];
-		curr_input_mems_arr.size_in_dwords = split_data_size;
+		split_hdr =
+		    (const struct dbg_dump_split_hdr *)dbg_buf->ptr +
+		    input_offset++;
+		split_type = GET_FIELD(split_hdr->hdr,
+				       DBG_DUMP_SPLIT_HDR_SPLIT_TYPE_ID);
+		split_data_size = GET_FIELD(split_hdr->hdr,
+					    DBG_DUMP_SPLIT_HDR_DATA_SIZE);
+		curr_input_mems_arr.ptr = (u32 *)dbg_buf->ptr + input_offset;
+		curr_input_mems_arr.size = DWORDS_TO_BYTES(split_data_size);
 
 		if (split_type == SPLIT_TYPE_NONE)
 			offset += qed_grc_dump_mem_entries(p_hwfn,
@@ -3347,17 +2649,19 @@ static u32 qed_grc_dump_ctx_data(struct qed_hwfn *p_hwfn,
 				 bool dump,
 				 const char *name,
 				 u32 num_lids,
-				 u32 lid_size,
-				 u32 rd_reg_addr,
-				 u8 storm_id)
+				 enum cm_ctx_types ctx_type, u8 storm_id)
 {
+	struct dbg_tools_data *dev_data = &p_hwfn->dbg_info;
 	struct storm_defs *storm = &s_storm_defs[storm_id];
-	u32 i, lid, total_size, offset = 0;
+	u32 i, lid, lid_size, total_size;
+	u32 rd_reg_addr, offset = 0;
+
+	/* Convert quad-regs to dwords */
+	lid_size = storm->cm_ctx_lid_sizes[dev_data->chip_id][ctx_type] * 4;
 
 	if (!lid_size)
 		return 0;
 
-	lid_size *= BYTES_IN_DWORD;
 	total_size = num_lids * lid_size;
 
 	offset += qed_grc_dump_mem_hdr(p_hwfn,
@@ -3367,18 +2671,26 @@ static u32 qed_grc_dump_ctx_data(struct qed_hwfn *p_hwfn,
 				       0,
 				       total_size,
 				       lid_size * 32,
-				       false, name, true, storm->letter);
+				       false, name, storm->letter);
 
 	if (!dump)
 		return offset + total_size;
 
+	rd_reg_addr = BYTES_TO_DWORDS(storm->cm_ctx_rd_addr[ctx_type]);
+
 	/* Dump context data */
 	for (lid = 0; lid < num_lids; lid++) {
-		for (i = 0; i < lid_size; i++, offset++) {
+		for (i = 0; i < lid_size; i++) {
 			qed_wr(p_hwfn,
 			       p_ptt, storm->cm_ctx_wr_addr, (i << 9) | lid);
-			*(dump_buf + offset) = qed_rd(p_hwfn,
-						      p_ptt, rd_reg_addr);
+			offset += qed_grc_dump_addr_range(p_hwfn,
+							  p_ptt,
+							  dump_buf + offset,
+							  dump,
+							  rd_reg_addr,
+							  1,
+							  false,
+							  SPLIT_TYPE_NONE, 0);
 		}
 	}
 
@@ -3389,115 +2701,126 @@ static u32 qed_grc_dump_ctx_data(struct qed_hwfn *p_hwfn,
 static u32 qed_grc_dump_ctx(struct qed_hwfn *p_hwfn,
 			    struct qed_ptt *p_ptt, u32 *dump_buf, bool dump)
 {
-	enum dbg_grc_params grc_param;
 	u32 offset = 0;
 	u8 storm_id;
 
 	for (storm_id = 0; storm_id < MAX_DBG_STORMS; storm_id++) {
-		struct storm_defs *storm = &s_storm_defs[storm_id];
-
 		if (!qed_grc_is_storm_included(p_hwfn,
 					       (enum dbg_storms)storm_id))
 			continue;
 
 		/* Dump Conn AG context size */
-		grc_param = DBG_GRC_PARAM_NUM_LCIDS;
-		offset +=
-			qed_grc_dump_ctx_data(p_hwfn,
-					      p_ptt,
-					      dump_buf + offset,
-					      dump,
-					      "CONN_AG_CTX",
-					      qed_grc_get_param(p_hwfn,
-								grc_param),
-					      storm->cm_conn_ag_ctx_lid_size,
-					      storm->cm_conn_ag_ctx_rd_addr,
-					      storm_id);
+		offset += qed_grc_dump_ctx_data(p_hwfn,
+						p_ptt,
+						dump_buf + offset,
+						dump,
+						"CONN_AG_CTX",
+						NUM_OF_LCIDS,
+						CM_CTX_CONN_AG, storm_id);
 
 		/* Dump Conn ST context size */
-		grc_param = DBG_GRC_PARAM_NUM_LCIDS;
-		offset +=
-			qed_grc_dump_ctx_data(p_hwfn,
-					      p_ptt,
-					      dump_buf + offset,
-					      dump,
-					      "CONN_ST_CTX",
-					      qed_grc_get_param(p_hwfn,
-								grc_param),
-					      storm->cm_conn_st_ctx_lid_size,
-					      storm->cm_conn_st_ctx_rd_addr,
-					      storm_id);
+		offset += qed_grc_dump_ctx_data(p_hwfn,
+						p_ptt,
+						dump_buf + offset,
+						dump,
+						"CONN_ST_CTX",
+						NUM_OF_LCIDS,
+						CM_CTX_CONN_ST, storm_id);
 
 		/* Dump Task AG context size */
-		grc_param = DBG_GRC_PARAM_NUM_LTIDS;
-		offset +=
-			qed_grc_dump_ctx_data(p_hwfn,
-					      p_ptt,
-					      dump_buf + offset,
-					      dump,
-					      "TASK_AG_CTX",
-					      qed_grc_get_param(p_hwfn,
-								grc_param),
-					      storm->cm_task_ag_ctx_lid_size,
-					      storm->cm_task_ag_ctx_rd_addr,
-					      storm_id);
+		offset += qed_grc_dump_ctx_data(p_hwfn,
+						p_ptt,
+						dump_buf + offset,
+						dump,
+						"TASK_AG_CTX",
+						NUM_OF_LTIDS,
+						CM_CTX_TASK_AG, storm_id);
 
 		/* Dump Task ST context size */
-		grc_param = DBG_GRC_PARAM_NUM_LTIDS;
-		offset +=
-			qed_grc_dump_ctx_data(p_hwfn,
-					      p_ptt,
-					      dump_buf + offset,
-					      dump,
-					      "TASK_ST_CTX",
-					      qed_grc_get_param(p_hwfn,
-								grc_param),
-					      storm->cm_task_st_ctx_lid_size,
-					      storm->cm_task_st_ctx_rd_addr,
-					      storm_id);
+		offset += qed_grc_dump_ctx_data(p_hwfn,
+						p_ptt,
+						dump_buf + offset,
+						dump,
+						"TASK_ST_CTX",
+						NUM_OF_LTIDS,
+						CM_CTX_TASK_ST, storm_id);
 	}
 
 	return offset;
 }
 
-/* Dumps GRC IORs data. Returns the dumped size in dwords. */
-static u32 qed_grc_dump_iors(struct qed_hwfn *p_hwfn,
-			     struct qed_ptt *p_ptt, u32 *dump_buf, bool dump)
-{
-	char buf[10] = "IOR_SET_?";
-	u32 addr, offset = 0;
-	u8 storm_id, set_id;
+#define VFC_STATUS_RESP_READY_BIT	0
+#define VFC_STATUS_BUSY_BIT		1
+#define VFC_STATUS_SENDING_CMD_BIT	2
 
-	for (storm_id = 0; storm_id < MAX_DBG_STORMS; storm_id++) {
-		struct storm_defs *storm = &s_storm_defs[storm_id];
+#define VFC_POLLING_DELAY_MS	1
+#define VFC_POLLING_COUNT		20
 
-		if (!qed_grc_is_storm_included(p_hwfn,
-					       (enum dbg_storms)storm_id))
-			continue;
+/* Reads data from VFC. Returns the number of dwords read (0 on error).
+ * Sizes are specified in dwords.
+ */
+static u32 qed_grc_dump_read_from_vfc(struct qed_hwfn *p_hwfn,
+				      struct qed_ptt *p_ptt,
+				      struct storm_defs *storm,
+				      u32 *cmd_data,
+				      u32 cmd_size,
+				      u32 *addr_data,
+				      u32 addr_size,
+				      u32 resp_size, u32 *dump_buf)
+{
+	struct dbg_tools_data *dev_data = &p_hwfn->dbg_info;
+	u32 vfc_status, polling_ms, polling_count = 0, i;
+	u32 reg_addr, sem_base;
+	bool is_ready = false;
+
+	sem_base = storm->sem_fast_mem_addr;
+	polling_ms = VFC_POLLING_DELAY_MS *
+	    s_hw_type_defs[dev_data->hw_type].delay_factor;
+
+	/* Write VFC command */
+	ARR_REG_WR(p_hwfn,
+		   p_ptt,
+		   sem_base + SEM_FAST_REG_VFC_DATA_WR,
+		   cmd_data, cmd_size);
+
+	/* Write VFC address */
+	ARR_REG_WR(p_hwfn,
+		   p_ptt,
+		   sem_base + SEM_FAST_REG_VFC_ADDR,
+		   addr_data, addr_size);
+
+	/* Read response */
+	for (i = 0; i < resp_size; i++) {
+		/* Poll until ready */
+		do {
+			reg_addr = sem_base + SEM_FAST_REG_VFC_STATUS;
+			qed_grc_dump_addr_range(p_hwfn,
+						p_ptt,
+						&vfc_status,
+						true,
+						BYTES_TO_DWORDS(reg_addr),
+						1,
+						false, SPLIT_TYPE_NONE, 0);
+			is_ready = vfc_status & BIT(VFC_STATUS_RESP_READY_BIT);
+
+			if (!is_ready) {
+				if (polling_count++ == VFC_POLLING_COUNT)
+					return 0;
 
-		for (set_id = 0; set_id < NUM_IOR_SETS; set_id++) {
-			addr = BYTES_TO_DWORDS(storm->sem_fast_mem_addr +
-					       SEM_FAST_REG_STORM_REG_FILE) +
-			       IOR_SET_OFFSET(set_id);
-			if (strlen(buf) > 0)
-				buf[strlen(buf) - 1] = '0' + set_id;
-			offset += qed_grc_dump_mem(p_hwfn,
-						   p_ptt,
-						   dump_buf + offset,
-						   dump,
-						   buf,
-						   addr,
-						   IORS_PER_SET,
-						   false,
-						   32,
-						   false,
-						   "ior",
-						   true,
-						   storm->letter);
-		}
+				msleep(polling_ms);
+			}
+		} while (!is_ready);
+
+		reg_addr = sem_base + SEM_FAST_REG_VFC_DATA_RD;
+		qed_grc_dump_addr_range(p_hwfn,
+					p_ptt,
+					dump_buf + i,
+					true,
+					BYTES_TO_DWORDS(reg_addr),
+					1, false, SPLIT_TYPE_NONE, 0);
 	}
 
-	return offset;
+	return resp_size;
 }
 
 /* Dump VFC CAM. Returns the dumped size in dwords. */
@@ -3509,7 +2832,7 @@ static u32 qed_grc_dump_vfc_cam(struct qed_hwfn *p_hwfn,
 	struct storm_defs *storm = &s_storm_defs[storm_id];
 	u32 cam_addr[VFC_CAM_ADDR_DWORDS] = { 0 };
 	u32 cam_cmd[VFC_CAM_CMD_DWORDS] = { 0 };
-	u32 row, i, offset = 0;
+	u32 row, offset = 0;
 
 	offset += qed_grc_dump_mem_hdr(p_hwfn,
 				       dump_buf + offset,
@@ -3518,7 +2841,7 @@ static u32 qed_grc_dump_vfc_cam(struct qed_hwfn *p_hwfn,
 				       0,
 				       total_size,
 				       256,
-				       false, "vfc_cam", true, storm->letter);
+				       false, "vfc_cam", storm->letter);
 
 	if (!dump)
 		return offset + total_size;
@@ -3526,26 +2849,18 @@ static u32 qed_grc_dump_vfc_cam(struct qed_hwfn *p_hwfn,
 	/* Prepare CAM address */
 	SET_VAR_FIELD(cam_addr, VFC_CAM_ADDR, OP, VFC_OPCODE_CAM_RD);
 
-	for (row = 0; row < VFC_CAM_NUM_ROWS;
-	     row++, offset += VFC_CAM_RESP_DWORDS) {
-		/* Write VFC CAM command */
+	/* Read VFC CAM data */
+	for (row = 0; row < VFC_CAM_NUM_ROWS; row++) {
 		SET_VAR_FIELD(cam_cmd, VFC_CAM_CMD, ROW, row);
-		ARR_REG_WR(p_hwfn,
-			   p_ptt,
-			   storm->sem_fast_mem_addr + SEM_FAST_REG_VFC_DATA_WR,
-			   cam_cmd, VFC_CAM_CMD_DWORDS);
-
-		/* Write VFC CAM address */
-		ARR_REG_WR(p_hwfn,
-			   p_ptt,
-			   storm->sem_fast_mem_addr + SEM_FAST_REG_VFC_ADDR,
-			   cam_addr, VFC_CAM_ADDR_DWORDS);
-
-		/* Read VFC CAM read response */
-		ARR_REG_RD(p_hwfn,
-			   p_ptt,
-			   storm->sem_fast_mem_addr + SEM_FAST_REG_VFC_DATA_RD,
-			   dump_buf + offset, VFC_CAM_RESP_DWORDS);
+		offset += qed_grc_dump_read_from_vfc(p_hwfn,
+						     p_ptt,
+						     storm,
+						     cam_cmd,
+						     VFC_CAM_CMD_DWORDS,
+						     cam_addr,
+						     VFC_CAM_ADDR_DWORDS,
+						     VFC_CAM_RESP_DWORDS,
+						     dump_buf + offset);
 	}
 
 	return offset;
@@ -3562,7 +2877,7 @@ static u32 qed_grc_dump_vfc_ram(struct qed_hwfn *p_hwfn,
 	struct storm_defs *storm = &s_storm_defs[storm_id];
 	u32 ram_addr[VFC_RAM_ADDR_DWORDS] = { 0 };
 	u32 ram_cmd[VFC_RAM_CMD_DWORDS] = { 0 };
-	u32 row, i, offset = 0;
+	u32 row, offset = 0;
 
 	offset += qed_grc_dump_mem_hdr(p_hwfn,
 				       dump_buf + offset,
@@ -3573,35 +2888,27 @@ static u32 qed_grc_dump_vfc_ram(struct qed_hwfn *p_hwfn,
 				       256,
 				       false,
 				       ram_defs->type_name,
-				       true, storm->letter);
-
-	/* Prepare RAM address */
-	SET_VAR_FIELD(ram_addr, VFC_RAM_ADDR, OP, VFC_OPCODE_RAM_RD);
+				       storm->letter);
 
 	if (!dump)
 		return offset + total_size;
 
+	/* Prepare RAM address */
+	SET_VAR_FIELD(ram_addr, VFC_RAM_ADDR, OP, VFC_OPCODE_RAM_RD);
+
+	/* Read VFC RAM data */
 	for (row = ram_defs->base_row;
-	     row < ram_defs->base_row + ram_defs->num_rows;
-	     row++, offset += VFC_RAM_RESP_DWORDS) {
-		/* Write VFC RAM command */
-		ARR_REG_WR(p_hwfn,
-			   p_ptt,
-			   storm->sem_fast_mem_addr + SEM_FAST_REG_VFC_DATA_WR,
-			   ram_cmd, VFC_RAM_CMD_DWORDS);
-
-		/* Write VFC RAM address */
+	     row < ram_defs->base_row + ram_defs->num_rows; row++) {
 		SET_VAR_FIELD(ram_addr, VFC_RAM_ADDR, ROW, row);
-		ARR_REG_WR(p_hwfn,
-			   p_ptt,
-			   storm->sem_fast_mem_addr + SEM_FAST_REG_VFC_ADDR,
-			   ram_addr, VFC_RAM_ADDR_DWORDS);
-
-		/* Read VFC RAM read response */
-		ARR_REG_RD(p_hwfn,
-			   p_ptt,
-			   storm->sem_fast_mem_addr + SEM_FAST_REG_VFC_DATA_RD,
-			   dump_buf + offset, VFC_RAM_RESP_DWORDS);
+		offset += qed_grc_dump_read_from_vfc(p_hwfn,
+						     p_ptt,
+						     storm,
+						     ram_cmd,
+						     VFC_RAM_CMD_DWORDS,
+						     ram_addr,
+						     VFC_RAM_ADDR_DWORDS,
+						     VFC_RAM_RESP_DWORDS,
+						     dump_buf + offset);
 	}
 
 	return offset;
@@ -3611,16 +2918,13 @@ static u32 qed_grc_dump_vfc_ram(struct qed_hwfn *p_hwfn,
 static u32 qed_grc_dump_vfc(struct qed_hwfn *p_hwfn,
 			    struct qed_ptt *p_ptt, u32 *dump_buf, bool dump)
 {
-	struct dbg_tools_data *dev_data = &p_hwfn->dbg_info;
 	u8 storm_id, i;
 	u32 offset = 0;
 
 	for (storm_id = 0; storm_id < MAX_DBG_STORMS; storm_id++) {
 		if (!qed_grc_is_storm_included(p_hwfn,
 					       (enum dbg_storms)storm_id) ||
-		    !s_storm_defs[storm_id].has_vfc ||
-		    (storm_id == DBG_PSTORM_ID && dev_data->platform_id !=
-		     PLATFORM_ASIC))
+		    !s_storm_defs[storm_id].has_vfc)
 			continue;
 
 		/* Read CAM */
@@ -3670,7 +2974,7 @@ static u32 qed_grc_dump_rss(struct qed_hwfn *p_hwfn,
 					       total_dwords,
 					       rss_defs->entry_width,
 					       packed,
-					       rss_defs->type_name, false, 0);
+					       rss_defs->type_name, 0);
 
 		/* Dump RSS data */
 		if (!dump) {
@@ -3730,7 +3034,7 @@ static u32 qed_grc_dump_big_ram(struct qed_hwfn *p_hwfn,
 				       0,
 				       ram_size,
 				       block_size * 8,
-				       false, type_name, false, 0);
+				       false, type_name, 0);
 
 	/* Read and dump Big RAM data */
 	if (!dump)
@@ -3756,6 +3060,7 @@ static u32 qed_grc_dump_big_ram(struct qed_hwfn *p_hwfn,
 	return offset;
 }
 
+/* Dumps MCP scratchpad. Returns the dumped size in dwords. */
 static u32 qed_grc_dump_mcp(struct qed_hwfn *p_hwfn,
 			    struct qed_ptt *p_ptt, u32 *dump_buf, bool dump)
 {
@@ -3777,8 +3082,8 @@ static u32 qed_grc_dump_mcp(struct qed_hwfn *p_hwfn,
 				   dump,
 				   NULL,
 				   BYTES_TO_DWORDS(MCP_REG_SCRATCH),
-				   MCP_REG_SCRATCH_SIZE_BB_K2,
-				   false, 0, false, "MCP", false, 0);
+				   MCP_REG_SCRATCH_SIZE,
+				   false, 0, false, "MCP", 0);
 
 	/* Dump MCP cpu_reg_file */
 	offset += qed_grc_dump_mem(p_hwfn,
@@ -3788,19 +3093,19 @@ static u32 qed_grc_dump_mcp(struct qed_hwfn *p_hwfn,
 				   NULL,
 				   BYTES_TO_DWORDS(MCP_REG_CPU_REG_FILE),
 				   MCP_REG_CPU_REG_FILE_SIZE,
-				   false, 0, false, "MCP", false, 0);
+				   false, 0, false, "MCP", 0);
 
 	/* Dump MCP registers */
 	block_enable[BLOCK_MCP] = true;
 	offset += qed_grc_dump_registers(p_hwfn,
 					 p_ptt,
 					 dump_buf + offset,
-					 dump, block_enable, "block", "MCP");
+					 dump, block_enable, "MCP");
 
 	/* Dump required non-MCP registers */
 	offset += qed_grc_dump_regs_hdr(dump_buf + offset,
 					dump, 1, SPLIT_TYPE_NONE, 0,
-					"block", "MCP");
+					"MCP");
 	addr = BYTES_TO_DWORDS(MISC_REG_SHARED_MEM_ADDR);
 	offset += qed_grc_dump_reg_entry(p_hwfn,
 					 p_ptt,
@@ -3817,7 +3122,9 @@ static u32 qed_grc_dump_mcp(struct qed_hwfn *p_hwfn,
 	return offset;
 }
 
-/* Dumps the tbus indirect memory for all PHYs. */
+/* Dumps the tbus indirect memory for all PHYs.
+ * Returns the dumped size in dwords.
+ */
 static u32 qed_grc_dump_phy(struct qed_hwfn *p_hwfn,
 			    struct qed_ptt *p_ptt, u32 *dump_buf, bool dump)
 {
@@ -3851,7 +3158,7 @@ static u32 qed_grc_dump_phy(struct qed_hwfn *p_hwfn,
 					       mem_name,
 					       0,
 					       PHY_DUMP_SIZE_DWORDS,
-					       16, true, mem_name, false, 0);
+					       16, true, mem_name, 0);
 
 		if (!dump) {
 			offset += PHY_DUMP_SIZE_DWORDS;
@@ -3882,21 +3189,58 @@ static u32 qed_grc_dump_phy(struct qed_hwfn *p_hwfn,
 	return offset;
 }
 
-static void qed_config_dbg_line(struct qed_hwfn *p_hwfn,
-				struct qed_ptt *p_ptt,
-				enum block_id block_id,
-				u8 line_id,
-				u8 enable_mask,
-				u8 right_shift,
-				u8 force_valid_mask, u8 force_frame_mask)
+static enum dbg_status qed_find_nvram_image(struct qed_hwfn *p_hwfn,
+					    struct qed_ptt *p_ptt,
+					    u32 image_type,
+					    u32 *nvram_offset_bytes,
+					    u32 *nvram_size_bytes);
+
+static enum dbg_status qed_nvram_read(struct qed_hwfn *p_hwfn,
+				      struct qed_ptt *p_ptt,
+				      u32 nvram_offset_bytes,
+				      u32 nvram_size_bytes, u32 *ret_buf);
+
+/* Dumps the MCP HW dump from NVRAM. Returns the dumped size in dwords. */
+static u32 qed_grc_dump_mcp_hw_dump(struct qed_hwfn *p_hwfn,
+				    struct qed_ptt *p_ptt,
+				    u32 *dump_buf, bool dump)
 {
-	struct block_defs *block = s_block_defs[block_id];
+	u32 hw_dump_offset_bytes = 0, hw_dump_size_bytes = 0;
+	u32 hw_dump_size_dwords = 0, offset = 0;
+	enum dbg_status status;
+
+	/* Read HW dump image from NVRAM */
+	status = qed_find_nvram_image(p_hwfn,
+				      p_ptt,
+				      NVM_TYPE_HW_DUMP_OUT,
+				      &hw_dump_offset_bytes,
+				      &hw_dump_size_bytes);
+	if (status != DBG_STATUS_OK)
+		return 0;
+
+	hw_dump_size_dwords = BYTES_TO_DWORDS(hw_dump_size_bytes);
+
+	/* Dump HW dump image section */
+	offset += qed_dump_section_hdr(dump_buf + offset,
+				       dump, "mcp_hw_dump", 1);
+	offset += qed_dump_num_param(dump_buf + offset,
+				     dump, "size", hw_dump_size_dwords);
+
+	/* Read MCP HW dump image into dump buffer */
+	if (dump && hw_dump_size_dwords) {
+		status = qed_nvram_read(p_hwfn,
+					p_ptt,
+					hw_dump_offset_bytes,
+					hw_dump_size_bytes, dump_buf + offset);
+		if (status != DBG_STATUS_OK) {
+			DP_NOTICE(p_hwfn,
+				  "Failed to read MCP HW Dump image from NVRAM\n");
+			return 0;
+		}
+	}
+	offset += hw_dump_size_dwords;
 
-	qed_wr(p_hwfn, p_ptt, block->dbg_select_addr, line_id);
-	qed_wr(p_hwfn, p_ptt, block->dbg_enable_addr, enable_mask);
-	qed_wr(p_hwfn, p_ptt, block->dbg_shift_addr, right_shift);
-	qed_wr(p_hwfn, p_ptt, block->dbg_force_valid_addr, force_valid_mask);
-	qed_wr(p_hwfn, p_ptt, block->dbg_force_frame_addr, force_frame_mask);
+	return offset;
 }
 
 /* Dumps Static Debug data. Returns the dumped size in dwords. */
@@ -3905,26 +3249,19 @@ static u32 qed_grc_dump_static_debug(struct qed_hwfn *p_hwfn,
 				     u32 *dump_buf, bool dump)
 {
 	struct dbg_tools_data *dev_data = &p_hwfn->dbg_info;
-	u32 block_id, line_id, offset = 0;
+	u32 block_id, line_id, offset = 0, addr, len;
 
 	/* Don't dump static debug if a debug bus recording is in progress */
 	if (dump && qed_rd(p_hwfn, p_ptt, DBG_REG_DBG_BLOCK_ON))
 		return 0;
 
 	if (dump) {
-		/* Disable all blocks debug output */
-		for (block_id = 0; block_id < MAX_BLOCK_ID; block_id++) {
-			struct block_defs *block = s_block_defs[block_id];
-
-			if (block->dbg_client_id[dev_data->chip_id] !=
-			    MAX_DBG_BUS_CLIENTS)
-				qed_wr(p_hwfn, p_ptt, block->dbg_enable_addr,
-				       0);
-		}
+		/* Disable debug bus in all blocks */
+		qed_bus_disable_blocks(p_hwfn, p_ptt);
 
 		qed_bus_reset_dbg_block(p_hwfn, p_ptt);
-		qed_bus_set_framing_mode(p_hwfn,
-					 p_ptt, DBG_BUS_FRAME_MODE_8HW_0ST);
+		qed_wr(p_hwfn,
+		       p_ptt, DBG_REG_FRAMING_MODE, DBG_BUS_FRAME_MODE_8HW);
 		qed_wr(p_hwfn,
 		       p_ptt, DBG_REG_DEBUG_TARGET, DBG_BUS_TARGET_ID_INT_BUF);
 		qed_wr(p_hwfn, p_ptt, DBG_REG_FULL_MODE, 1);
@@ -3933,28 +3270,48 @@ static u32 qed_grc_dump_static_debug(struct qed_hwfn *p_hwfn,
 
 	/* Dump all static debug lines for each relevant block */
 	for (block_id = 0; block_id < MAX_BLOCK_ID; block_id++) {
-		struct block_defs *block = s_block_defs[block_id];
-		struct dbg_bus_block *block_desc;
-		u32 block_dwords, addr, len;
-		u8 dbg_client_id;
+		const struct dbg_block_chip *block_per_chip;
+		const struct dbg_block *block;
+		bool is_removed, has_dbg_bus;
+		u16 modes_buf_offset;
+		u32 block_dwords;
 
-		if (block->dbg_client_id[dev_data->chip_id] ==
-		    MAX_DBG_BUS_CLIENTS)
+		block_per_chip =
+		    qed_get_dbg_block_per_chip(p_hwfn, (enum block_id)block_id);
+		is_removed = GET_FIELD(block_per_chip->flags,
+				       DBG_BLOCK_CHIP_IS_REMOVED);
+		has_dbg_bus = GET_FIELD(block_per_chip->flags,
+					DBG_BLOCK_CHIP_HAS_DBG_BUS);
+
+		/* read+clear for NWS parity is not working, skip NWS block */
+		if (block_id == BLOCK_NWS)
+			continue;
+
+		if (!is_removed && has_dbg_bus &&
+		    GET_FIELD(block_per_chip->dbg_bus_mode.data,
+			      DBG_MODE_HDR_EVAL_MODE) > 0) {
+			modes_buf_offset =
+			    GET_FIELD(block_per_chip->dbg_bus_mode.data,
+				      DBG_MODE_HDR_MODES_BUF_OFFSET);
+			if (!qed_is_mode_match(p_hwfn, &modes_buf_offset))
+				has_dbg_bus = false;
+		}
+
+		if (is_removed || !has_dbg_bus)
 			continue;
 
-		block_desc = get_dbg_bus_block_desc(p_hwfn,
-						    (enum block_id)block_id);
-		block_dwords = NUM_DBG_LINES(block_desc) *
+		block_dwords = NUM_DBG_LINES(block_per_chip) *
 			       STATIC_DEBUG_LINE_DWORDS;
 
 		/* Dump static section params */
+		block = get_dbg_block(p_hwfn, (enum block_id)block_id);
 		offset += qed_grc_dump_mem_hdr(p_hwfn,
 					       dump_buf + offset,
 					       dump,
 					       block->name,
 					       0,
 					       block_dwords,
-					       32, false, "STATIC", false, 0);
+					       32, false, "STATIC", 0);
 
 		if (!dump) {
 			offset += block_dwords;
@@ -3970,20 +3327,19 @@ static u32 qed_grc_dump_static_debug(struct qed_hwfn *p_hwfn,
 		}
 
 		/* Enable block's client */
-		dbg_client_id = block->dbg_client_id[dev_data->chip_id];
 		qed_bus_enable_clients(p_hwfn,
 				       p_ptt,
-				       BIT(dbg_client_id));
+				       BIT(block_per_chip->dbg_client_id));
 
 		addr = BYTES_TO_DWORDS(DBG_REG_CALENDAR_OUT_DATA);
 		len = STATIC_DEBUG_LINE_DWORDS;
-		for (line_id = 0; line_id < (u32)NUM_DBG_LINES(block_desc);
+		for (line_id = 0; line_id < (u32)NUM_DBG_LINES(block_per_chip);
 		     line_id++) {
 			/* Configure debug line ID */
-			qed_config_dbg_line(p_hwfn,
-					    p_ptt,
-					    (enum block_id)block_id,
-					    (u8)line_id, 0xf, 0, 0, 0);
+			qed_bus_config_dbg_line(p_hwfn,
+						p_ptt,
+						(enum block_id)block_id,
+						(u8)line_id, 0xf, 0, 0, 0);
 
 			/* Read debug line info */
 			offset += qed_grc_dump_addr_range(p_hwfn,
@@ -3998,7 +3354,8 @@ static u32 qed_grc_dump_static_debug(struct qed_hwfn *p_hwfn,
 
 		/* Disable block's client and debug output */
 		qed_bus_enable_clients(p_hwfn, p_ptt, 0);
-		qed_wr(p_hwfn, p_ptt, block->dbg_enable_addr, 0);
+		qed_bus_config_dbg_line(p_hwfn, p_ptt,
+					(enum block_id)block_id, 0, 0, 0, 0, 0);
 	}
 
 	if (dump) {
@@ -4018,8 +3375,8 @@ static enum dbg_status qed_grc_dump(struct qed_hwfn *p_hwfn,
 				    bool dump, u32 *num_dumped_dwords)
 {
 	struct dbg_tools_data *dev_data = &p_hwfn->dbg_info;
+	u32 dwords_read, offset = 0;
 	bool parities_masked = false;
-	u32 offset = 0;
 	u8 i;
 
 	*num_dumped_dwords = 0;
@@ -4038,13 +3395,11 @@ static enum dbg_status qed_grc_dump(struct qed_hwfn *p_hwfn,
 	offset += qed_dump_num_param(dump_buf + offset,
 				     dump,
 				     "num-lcids",
-				     qed_grc_get_param(p_hwfn,
-						DBG_GRC_PARAM_NUM_LCIDS));
+				     NUM_OF_LCIDS);
 	offset += qed_dump_num_param(dump_buf + offset,
 				     dump,
 				     "num-ltids",
-				     qed_grc_get_param(p_hwfn,
-						DBG_GRC_PARAM_NUM_LTIDS));
+				     NUM_OF_LTIDS);
 	offset += qed_dump_num_param(dump_buf + offset,
 				     dump, "num-ports", dev_data->num_ports);
 
@@ -4056,7 +3411,7 @@ static enum dbg_status qed_grc_dump(struct qed_hwfn *p_hwfn,
 
 	/* Take all blocks out of reset (using reset registers) */
 	if (dump) {
-		qed_grc_unreset_blocks(p_hwfn, p_ptt);
+		qed_grc_unreset_blocks(p_hwfn, p_ptt, false);
 		qed_update_blocks_reset_state(p_hwfn, p_ptt);
 	}
 
@@ -4099,7 +3454,7 @@ static enum dbg_status qed_grc_dump(struct qed_hwfn *p_hwfn,
 						 dump_buf +
 						 offset,
 						 dump,
-						 block_enable, NULL, NULL);
+						 block_enable, NULL);
 
 		/* Dump special registers */
 		offset += qed_grc_dump_special_regs(p_hwfn,
@@ -4133,23 +3488,29 @@ static enum dbg_status qed_grc_dump(struct qed_hwfn *p_hwfn,
 						       dump_buf + offset,
 						       dump, i);
 
-	/* Dump IORs */
-	if (qed_grc_is_included(p_hwfn, DBG_GRC_PARAM_DUMP_IOR))
-		offset += qed_grc_dump_iors(p_hwfn,
-					    p_ptt, dump_buf + offset, dump);
-
 	/* Dump VFC */
-	if (qed_grc_is_included(p_hwfn, DBG_GRC_PARAM_DUMP_VFC))
-		offset += qed_grc_dump_vfc(p_hwfn,
-					   p_ptt, dump_buf + offset, dump);
+	if (qed_grc_is_included(p_hwfn, DBG_GRC_PARAM_DUMP_VFC)) {
+		dwords_read = qed_grc_dump_vfc(p_hwfn,
+					       p_ptt, dump_buf + offset, dump);
+		offset += dwords_read;
+		if (!dwords_read)
+			return DBG_STATUS_VFC_READ_ERROR;
+	}
 
 	/* Dump PHY tbus */
 	if (qed_grc_is_included(p_hwfn,
 				DBG_GRC_PARAM_DUMP_PHY) && dev_data->chip_id ==
-	    CHIP_K2 && dev_data->platform_id == PLATFORM_ASIC)
+	    CHIP_K2 && dev_data->hw_type == HW_TYPE_ASIC)
 		offset += qed_grc_dump_phy(p_hwfn,
 					   p_ptt, dump_buf + offset, dump);
 
+	/* Dump MCP HW Dump */
+	if (qed_grc_is_included(p_hwfn, DBG_GRC_PARAM_DUMP_MCP_HW_DUMP) &&
+	    !qed_grc_get_param(p_hwfn, DBG_GRC_PARAM_NO_MCP) && 1)
+		offset += qed_grc_dump_mcp_hw_dump(p_hwfn,
+						   p_ptt,
+						   dump_buf + offset, dump);
+
 	/* Dump static debug data (only if not during debug bus recording) */
 	if (qed_grc_is_included(p_hwfn,
 				DBG_GRC_PARAM_DUMP_STATIC) &&
@@ -4200,8 +3561,9 @@ static u32 qed_idle_chk_dump_failure(struct qed_hwfn *p_hwfn,
 	u8 reg_id;
 
 	hdr = (struct dbg_idle_chk_result_hdr *)dump_buf;
-	regs = &((const union dbg_idle_chk_reg *)
-		 s_dbg_arrays[BIN_BUF_DBG_IDLE_CHK_REGS].ptr)[rule->reg_offset];
+	regs = (const union dbg_idle_chk_reg *)
+		p_hwfn->dbg_arrays[BIN_BUF_DBG_IDLE_CHK_REGS].ptr +
+		rule->reg_offset;
 	cond_regs = &regs[0].cond_reg;
 	info_regs = &regs[rule->num_cond_regs].info_reg;
 
@@ -4221,8 +3583,8 @@ static u32 qed_idle_chk_dump_failure(struct qed_hwfn *p_hwfn,
 		const struct dbg_idle_chk_cond_reg *reg = &cond_regs[reg_id];
 		struct dbg_idle_chk_result_reg_hdr *reg_hdr;
 
-		reg_hdr = (struct dbg_idle_chk_result_reg_hdr *)
-			  (dump_buf + offset);
+		reg_hdr =
+		    (struct dbg_idle_chk_result_reg_hdr *)(dump_buf + offset);
 
 		/* Write register header */
 		if (!dump) {
@@ -4339,12 +3701,13 @@ qed_idle_chk_dump_rule_entries(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt,
 		const u32 *imm_values;
 
 		rule = &input_rules[i];
-		regs = &((const union dbg_idle_chk_reg *)
-			 s_dbg_arrays[BIN_BUF_DBG_IDLE_CHK_REGS].ptr)
-			[rule->reg_offset];
+		regs = (const union dbg_idle_chk_reg *)
+			p_hwfn->dbg_arrays[BIN_BUF_DBG_IDLE_CHK_REGS].ptr +
+			rule->reg_offset;
 		cond_regs = &regs[0].cond_reg;
-		imm_values = &s_dbg_arrays[BIN_BUF_DBG_IDLE_CHK_IMMS].ptr
-			     [rule->imm_offset];
+		imm_values =
+		    (u32 *)p_hwfn->dbg_arrays[BIN_BUF_DBG_IDLE_CHK_IMMS].ptr +
+		    rule->imm_offset;
 
 		/* Check if all condition register blocks are out of reset, and
 		 * find maximal number of entries (all condition registers that
@@ -4462,10 +3825,12 @@ qed_idle_chk_dump_rule_entries(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt,
 static u32 qed_idle_chk_dump(struct qed_hwfn *p_hwfn,
 			     struct qed_ptt *p_ptt, u32 *dump_buf, bool dump)
 {
-	u32 num_failing_rules_offset, offset = 0, input_offset = 0;
-	u32 num_failing_rules = 0;
+	struct virt_mem_desc *dbg_buf =
+	    &p_hwfn->dbg_arrays[BIN_BUF_DBG_IDLE_CHK_RULES];
+	u32 num_failing_rules_offset, offset = 0,
+	    input_offset = 0, num_failing_rules = 0;
 
-	/* Dump global params */
+	/* Dump global params  - 1 must match below amount of params */
 	offset += qed_dump_common_global_params(p_hwfn,
 						p_ptt,
 						dump_buf + offset, dump, 1);
@@ -4477,12 +3842,10 @@ static u32 qed_idle_chk_dump(struct qed_hwfn *p_hwfn,
 	num_failing_rules_offset = offset;
 	offset += qed_dump_num_param(dump_buf + offset, dump, "num_rules", 0);
 
-	while (input_offset <
-	       s_dbg_arrays[BIN_BUF_DBG_IDLE_CHK_RULES].size_in_dwords) {
+	while (input_offset < BYTES_TO_DWORDS(dbg_buf->size)) {
 		const struct dbg_idle_chk_cond_hdr *cond_hdr =
-			(const struct dbg_idle_chk_cond_hdr *)
-			&s_dbg_arrays[BIN_BUF_DBG_IDLE_CHK_RULES].ptr
-			[input_offset++];
+		    (const struct dbg_idle_chk_cond_hdr *)dbg_buf->ptr +
+		    input_offset++;
 		bool eval_mode, mode_match = true;
 		u32 curr_failing_rules;
 		u16 modes_buf_offset;
@@ -4499,16 +3862,21 @@ static u32 qed_idle_chk_dump(struct qed_hwfn *p_hwfn,
 		}
 
 		if (mode_match) {
+			const struct dbg_idle_chk_rule *rule =
+			    (const struct dbg_idle_chk_rule *)((u32 *)
+							       dbg_buf->ptr
+							       + input_offset);
+			u32 num_input_rules =
+				cond_hdr->data_size / IDLE_CHK_RULE_SIZE_DWORDS;
 			offset +=
 			    qed_idle_chk_dump_rule_entries(p_hwfn,
-				p_ptt,
-				dump_buf + offset,
-				dump,
-				(const struct dbg_idle_chk_rule *)
-				&s_dbg_arrays[BIN_BUF_DBG_IDLE_CHK_RULES].
-				ptr[input_offset],
-				cond_hdr->data_size / IDLE_CHK_RULE_SIZE_DWORDS,
-				&curr_failing_rules);
+							   p_ptt,
+							   dump_buf +
+							   offset,
+							   dump,
+							   rule,
+							   num_input_rules,
+							   &curr_failing_rules);
 			num_failing_rules += curr_failing_rules;
 		}
 
@@ -4575,7 +3943,7 @@ static enum dbg_status qed_nvram_read(struct qed_hwfn *p_hwfn,
 {
 	u32 ret_mcp_resp, ret_mcp_param, ret_read_size, bytes_to_copy;
 	s32 bytes_left = nvram_size_bytes;
-	u32 read_offset = 0;
+	u32 read_offset = 0, param = 0;
 
 	DP_VERBOSE(p_hwfn,
 		   QED_MSG_DEBUG,
@@ -4588,14 +3956,14 @@ static enum dbg_status qed_nvram_read(struct qed_hwfn *p_hwfn,
 		     MCP_DRV_NVM_BUF_LEN) ? MCP_DRV_NVM_BUF_LEN : bytes_left;
 
 		/* Call NVRAM read command */
+		SET_MFW_FIELD(param,
+			      DRV_MB_PARAM_NVM_OFFSET,
+			      nvram_offset_bytes + read_offset);
+		SET_MFW_FIELD(param, DRV_MB_PARAM_NVM_LEN, bytes_to_copy);
 		if (qed_mcp_nvm_rd_cmd(p_hwfn, p_ptt,
-				       DRV_MSG_CODE_NVM_READ_NVRAM,
-				       (nvram_offset_bytes +
-					read_offset) |
-				       (bytes_to_copy <<
-					DRV_MB_PARAM_NVM_LEN_OFFSET),
-				       &ret_mcp_resp, &ret_mcp_param,
-				       &ret_read_size,
+				       DRV_MSG_CODE_NVM_READ_NVRAM, param,
+				       &ret_mcp_resp,
+				       &ret_mcp_param, &ret_read_size,
 				       (u32 *)((u8 *)ret_buf + read_offset)))
 			return DBG_STATUS_NVRAM_READ_FAILED;
 
@@ -4733,12 +4101,12 @@ static enum dbg_status qed_mcp_trace_dump(struct qed_hwfn *p_hwfn,
 	u32 trace_meta_size_dwords = 0, running_bundle_id, offset = 0;
 	u32 trace_meta_offset_bytes = 0, trace_meta_size_bytes = 0;
 	enum dbg_status status;
-	bool mcp_access;
 	int halted = 0;
+	bool use_mfw;
 
 	*num_dumped_dwords = 0;
 
-	mcp_access = !qed_grc_get_param(p_hwfn, DBG_GRC_PARAM_NO_MCP);
+	use_mfw = !qed_grc_get_param(p_hwfn, DBG_GRC_PARAM_NO_MCP);
 
 	/* Get trace data info */
 	status = qed_mcp_trace_get_data_info(p_hwfn,
@@ -4759,7 +4127,7 @@ static enum dbg_status qed_mcp_trace_dump(struct qed_hwfn *p_hwfn,
 	 * consistent. if halt fails, MCP trace is taken anyway, with a small
 	 * risk that it may be corrupt.
 	 */
-	if (dump && mcp_access) {
+	if (dump && use_mfw) {
 		halted = !qed_mcp_halt(p_hwfn, p_ptt);
 		if (!halted)
 			DP_NOTICE(p_hwfn, "MCP halt failed!\n");
@@ -4799,17 +4167,15 @@ static enum dbg_status qed_mcp_trace_dump(struct qed_hwfn *p_hwfn,
 	 */
 	trace_meta_size_bytes =
 		qed_grc_get_param(p_hwfn, DBG_GRC_PARAM_MCP_TRACE_META_SIZE);
-	if ((!trace_meta_size_bytes || dump) && mcp_access) {
+	if ((!trace_meta_size_bytes || dump) && use_mfw)
 		status = qed_mcp_trace_get_meta_info(p_hwfn,
 						     p_ptt,
 						     trace_data_size_bytes,
 						     &running_bundle_id,
 						     &trace_meta_offset_bytes,
 						     &trace_meta_size_bytes);
-		if (status == DBG_STATUS_OK)
-			trace_meta_size_dwords =
-				BYTES_TO_DWORDS(trace_meta_size_bytes);
-	}
+	if (status == DBG_STATUS_OK)
+		trace_meta_size_dwords = BYTES_TO_DWORDS(trace_meta_size_bytes);
 
 	/* Dump trace meta size param */
 	offset += qed_dump_num_param(dump_buf + offset,
@@ -4833,7 +4199,7 @@ static enum dbg_status qed_mcp_trace_dump(struct qed_hwfn *p_hwfn,
 	/* If no mcp access, indicate that the dump doesn't contain the meta
 	 * data from NVRAM.
 	 */
-	return mcp_access ? status : DBG_STATUS_NVRAM_GET_IMAGE_FAILED;
+	return use_mfw ? status : DBG_STATUS_NVRAM_GET_IMAGE_FAILED;
 }
 
 /* Dump GRC FIFO */
@@ -5058,7 +4424,7 @@ static u32 qed_fw_asserts_dump(struct qed_hwfn *p_hwfn,
 		struct storm_defs *storm = &s_storm_defs[storm_id];
 		u32 last_list_idx, addr;
 
-		if (dev_data->block_in_reset[storm->block_id])
+		if (dev_data->block_in_reset[storm->sem_block_id])
 			continue;
 
 		/* Read FW info for the current Storm */
@@ -5453,18 +4819,18 @@ static u32 qed_ilt_dump(struct qed_hwfn *p_hwfn,
 
 /***************************** Public Functions *******************************/
 
-enum dbg_status qed_dbg_set_bin_ptr(const u8 * const bin_ptr)
+enum dbg_status qed_dbg_set_bin_ptr(struct qed_hwfn *p_hwfn,
+				    const u8 * const bin_ptr)
 {
-	struct bin_buffer_hdr *buf_array = (struct bin_buffer_hdr *)bin_ptr;
+	struct bin_buffer_hdr *buf_hdrs = (struct bin_buffer_hdr *)bin_ptr;
 	u8 buf_id;
 
-	/* convert binary data to debug arrays */
-	for (buf_id = 0; buf_id < MAX_BIN_DBG_BUFFER_TYPE; buf_id++) {
-		s_dbg_arrays[buf_id].ptr =
-		    (u32 *)(bin_ptr + buf_array[buf_id].offset);
-		s_dbg_arrays[buf_id].size_in_dwords =
-		    BYTES_TO_DWORDS(buf_array[buf_id].length);
-	}
+	/* Convert binary data to debug arrays */
+	for (buf_id = 0; buf_id < MAX_BIN_DBG_BUFFER_TYPE; buf_id++)
+		qed_set_dbg_bin_buf(p_hwfn,
+				    buf_id,
+				    (u32 *)(bin_ptr + buf_hdrs[buf_id].offset),
+				    buf_hdrs[buf_id].length);
 
 	return DBG_STATUS_OK;
 }
@@ -5479,7 +4845,7 @@ bool qed_read_fw_info(struct qed_hwfn *p_hwfn,
 		struct storm_defs *storm = &s_storm_defs[storm_id];
 
 		/* Skip Storm if it's in reset */
-		if (dev_data->block_in_reset[storm->block_id])
+		if (dev_data->block_in_reset[storm->sem_block_id])
 			continue;
 
 		/* Read FW info for the current Storm */
@@ -5492,16 +4858,17 @@ bool qed_read_fw_info(struct qed_hwfn *p_hwfn,
 }
 
 enum dbg_status qed_dbg_grc_config(struct qed_hwfn *p_hwfn,
-				   struct qed_ptt *p_ptt,
 				   enum dbg_grc_params grc_param, u32 val)
 {
+	struct dbg_tools_data *dev_data = &p_hwfn->dbg_info;
 	enum dbg_status status;
 	int i;
 
-	DP_VERBOSE(p_hwfn, QED_MSG_DEBUG,
+	DP_VERBOSE(p_hwfn,
+		   QED_MSG_DEBUG,
 		   "dbg_grc_config: paramId = %d, val = %d\n", grc_param, val);
 
-	status = qed_dbg_dev_init(p_hwfn, p_ptt);
+	status = qed_dbg_dev_init(p_hwfn);
 	if (status != DBG_STATUS_OK)
 		return status;
 
@@ -5527,24 +4894,23 @@ enum dbg_status qed_dbg_grc_config(struct qed_hwfn *p_hwfn,
 
 		/* Update all params with the preset values */
 		for (i = 0; i < MAX_DBG_GRC_PARAMS; i++) {
+			struct grc_param_defs *defs = &s_grc_param_defs[i];
 			u32 preset_val;
-
 			/* Skip persistent params */
-			if (s_grc_param_defs[i].is_persistent)
+			if (defs->is_persistent)
 				continue;
 
 			/* Find preset value */
 			if (grc_param == DBG_GRC_PARAM_EXCLUDE_ALL)
 				preset_val =
-				    s_grc_param_defs[i].exclude_all_preset_val;
+				    defs->exclude_all_preset_val;
 			else if (grc_param == DBG_GRC_PARAM_CRASH)
 				preset_val =
-				    s_grc_param_defs[i].crash_preset_val;
+				    defs->crash_preset_val[dev_data->chip_id];
 			else
 				return DBG_STATUS_INVALID_ARGS;
 
-			qed_grc_set_param(p_hwfn,
-					  (enum dbg_grc_params)i, preset_val);
+			qed_grc_set_param(p_hwfn, i, preset_val);
 		}
 	} else {
 		/* Regular param - set its value */
@@ -5570,18 +4936,18 @@ enum dbg_status qed_dbg_grc_get_dump_buf_size(struct qed_hwfn *p_hwfn,
 					      struct qed_ptt *p_ptt,
 					      u32 *buf_size)
 {
-	enum dbg_status status = qed_dbg_dev_init(p_hwfn, p_ptt);
+	enum dbg_status status = qed_dbg_dev_init(p_hwfn);
 
 	*buf_size = 0;
 
 	if (status != DBG_STATUS_OK)
 		return status;
 
-	if (!s_dbg_arrays[BIN_BUF_DBG_MODE_TREE].ptr ||
-	    !s_dbg_arrays[BIN_BUF_DBG_DUMP_REG].ptr ||
-	    !s_dbg_arrays[BIN_BUF_DBG_DUMP_MEM].ptr ||
-	    !s_dbg_arrays[BIN_BUF_DBG_ATTN_BLOCKS].ptr ||
-	    !s_dbg_arrays[BIN_BUF_DBG_ATTN_REGS].ptr)
+	if (!p_hwfn->dbg_arrays[BIN_BUF_DBG_MODE_TREE].ptr ||
+	    !p_hwfn->dbg_arrays[BIN_BUF_DBG_DUMP_REG].ptr ||
+	    !p_hwfn->dbg_arrays[BIN_BUF_DBG_DUMP_MEM].ptr ||
+	    !p_hwfn->dbg_arrays[BIN_BUF_DBG_ATTN_BLOCKS].ptr ||
+	    !p_hwfn->dbg_arrays[BIN_BUF_DBG_ATTN_REGS].ptr)
 		return DBG_STATUS_DBG_ARRAY_NOT_SET;
 
 	return qed_grc_dump(p_hwfn, p_ptt, NULL, false, buf_size);
@@ -5621,20 +4987,19 @@ enum dbg_status qed_dbg_idle_chk_get_dump_buf_size(struct qed_hwfn *p_hwfn,
 						   u32 *buf_size)
 {
 	struct dbg_tools_data *dev_data = &p_hwfn->dbg_info;
-	struct idle_chk_data *idle_chk;
+	struct idle_chk_data *idle_chk = &dev_data->idle_chk;
 	enum dbg_status status;
 
-	idle_chk = &dev_data->idle_chk;
 	*buf_size = 0;
 
-	status = qed_dbg_dev_init(p_hwfn, p_ptt);
+	status = qed_dbg_dev_init(p_hwfn);
 	if (status != DBG_STATUS_OK)
 		return status;
 
-	if (!s_dbg_arrays[BIN_BUF_DBG_MODE_TREE].ptr ||
-	    !s_dbg_arrays[BIN_BUF_DBG_IDLE_CHK_REGS].ptr ||
-	    !s_dbg_arrays[BIN_BUF_DBG_IDLE_CHK_IMMS].ptr ||
-	    !s_dbg_arrays[BIN_BUF_DBG_IDLE_CHK_RULES].ptr)
+	if (!p_hwfn->dbg_arrays[BIN_BUF_DBG_MODE_TREE].ptr ||
+	    !p_hwfn->dbg_arrays[BIN_BUF_DBG_IDLE_CHK_REGS].ptr ||
+	    !p_hwfn->dbg_arrays[BIN_BUF_DBG_IDLE_CHK_IMMS].ptr ||
+	    !p_hwfn->dbg_arrays[BIN_BUF_DBG_IDLE_CHK_RULES].ptr)
 		return DBG_STATUS_DBG_ARRAY_NOT_SET;
 
 	if (!idle_chk->buf_size_set) {
@@ -5669,6 +5034,7 @@ enum dbg_status qed_dbg_idle_chk_dump(struct qed_hwfn *p_hwfn,
 		return DBG_STATUS_DUMP_BUF_TOO_SMALL;
 
 	/* Update reset state */
+	qed_grc_unreset_blocks(p_hwfn, p_ptt, true);
 	qed_update_blocks_reset_state(p_hwfn, p_ptt);
 
 	/* Idle Check Dump */
@@ -5684,7 +5050,7 @@ enum dbg_status qed_dbg_mcp_trace_get_dump_buf_size(struct qed_hwfn *p_hwfn,
 						    struct qed_ptt *p_ptt,
 						    u32 *buf_size)
 {
-	enum dbg_status status = qed_dbg_dev_init(p_hwfn, p_ptt);
+	enum dbg_status status = qed_dbg_dev_init(p_hwfn);
 
 	*buf_size = 0;
 
@@ -5731,7 +5097,7 @@ enum dbg_status qed_dbg_reg_fifo_get_dump_buf_size(struct qed_hwfn *p_hwfn,
 						   struct qed_ptt *p_ptt,
 						   u32 *buf_size)
 {
-	enum dbg_status status = qed_dbg_dev_init(p_hwfn, p_ptt);
+	enum dbg_status status = qed_dbg_dev_init(p_hwfn);
 
 	*buf_size = 0;
 
@@ -5777,7 +5143,7 @@ enum dbg_status qed_dbg_igu_fifo_get_dump_buf_size(struct qed_hwfn *p_hwfn,
 						   struct qed_ptt *p_ptt,
 						   u32 *buf_size)
 {
-	enum dbg_status status = qed_dbg_dev_init(p_hwfn, p_ptt);
+	enum dbg_status status = qed_dbg_dev_init(p_hwfn);
 
 	*buf_size = 0;
 
@@ -5823,7 +5189,7 @@ qed_dbg_protection_override_get_dump_buf_size(struct qed_hwfn *p_hwfn,
 					      struct qed_ptt *p_ptt,
 					      u32 *buf_size)
 {
-	enum dbg_status status = qed_dbg_dev_init(p_hwfn, p_ptt);
+	enum dbg_status status = qed_dbg_dev_init(p_hwfn);
 
 	*buf_size = 0;
 
@@ -5873,7 +5239,7 @@ enum dbg_status qed_dbg_fw_asserts_get_dump_buf_size(struct qed_hwfn *p_hwfn,
 						     struct qed_ptt *p_ptt,
 						     u32 *buf_size)
 {
-	enum dbg_status status = qed_dbg_dev_init(p_hwfn, p_ptt);
+	enum dbg_status status = qed_dbg_dev_init(p_hwfn);
 
 	*buf_size = 0;
 
@@ -5921,7 +5287,7 @@ enum dbg_status qed_dbg_ilt_get_dump_buf_size(struct qed_hwfn *p_hwfn,
 					      struct qed_ptt *p_ptt,
 					      u32 *buf_size)
 {
-	enum dbg_status status = qed_dbg_dev_init(p_hwfn, p_ptt);
+	enum dbg_status status = qed_dbg_dev_init(p_hwfn);
 
 	*buf_size = 0;
 
@@ -5968,19 +5334,20 @@ enum dbg_status qed_dbg_read_attn(struct qed_hwfn *p_hwfn,
 				  bool clear_status,
 				  struct dbg_attn_block_result *results)
 {
-	enum dbg_status status = qed_dbg_dev_init(p_hwfn, p_ptt);
+	enum dbg_status status = qed_dbg_dev_init(p_hwfn);
 	u8 reg_idx, num_attn_regs, num_result_regs = 0;
 	const struct dbg_attn_reg *attn_reg_arr;
 
 	if (status != DBG_STATUS_OK)
 		return status;
 
-	if (!s_dbg_arrays[BIN_BUF_DBG_MODE_TREE].ptr ||
-	    !s_dbg_arrays[BIN_BUF_DBG_ATTN_BLOCKS].ptr ||
-	    !s_dbg_arrays[BIN_BUF_DBG_ATTN_REGS].ptr)
+	if (!p_hwfn->dbg_arrays[BIN_BUF_DBG_MODE_TREE].ptr ||
+	    !p_hwfn->dbg_arrays[BIN_BUF_DBG_ATTN_BLOCKS].ptr ||
+	    !p_hwfn->dbg_arrays[BIN_BUF_DBG_ATTN_REGS].ptr)
 		return DBG_STATUS_DBG_ARRAY_NOT_SET;
 
-	attn_reg_arr = qed_get_block_attn_regs(block_id,
+	attn_reg_arr = qed_get_block_attn_regs(p_hwfn,
+					       block_id,
 					       attn_type, &num_attn_regs);
 
 	for (reg_idx = 0; reg_idx < num_attn_regs; reg_idx++) {
@@ -6025,7 +5392,7 @@ enum dbg_status qed_dbg_read_attn(struct qed_hwfn *p_hwfn,
 
 	results->block_id = (u8)block_id;
 	results->names_offset =
-	    qed_get_block_attn_data(block_id, attn_type)->names_offset;
+	    qed_get_block_attn_data(p_hwfn, block_id, attn_type)->names_offset;
 	SET_FIELD(results->data, DBG_ATTN_BLOCK_RESULT_ATTN_TYPE, attn_type);
 	SET_FIELD(results->data,
 		  DBG_ATTN_BLOCK_RESULT_NUM_REGS, num_result_regs);
@@ -6035,11 +5402,6 @@ enum dbg_status qed_dbg_read_attn(struct qed_hwfn *p_hwfn,
 
 /******************************* Data Types **********************************/
 
-struct block_info {
-	const char *name;
-	enum block_id id;
-};
-
 /* REG fifo element */
 struct reg_fifo_element {
 	u64 data;
@@ -6063,6 +5425,12 @@ struct reg_fifo_element {
 #define REG_FIFO_ELEMENT_ERROR_MASK		0x1f
 };
 
+/* REG fifo error element */
+struct reg_fifo_err {
+	u32 err_code;
+	const char *err_msg;
+};
+
 /* IGU fifo element */
 struct igu_fifo_element {
 	u32 dword0;
@@ -6162,20 +5530,6 @@ struct igu_fifo_addr_data {
 	enum igu_fifo_addr_types type;
 };
 
-struct mcp_trace_meta {
-	u32 modules_num;
-	char **modules;
-	u32 formats_num;
-	struct mcp_trace_format *formats;
-	bool is_allocated;
-};
-
-/* Debug Tools user data */
-struct dbg_tools_user_data {
-	struct mcp_trace_meta mcp_trace_meta;
-	const u32 *mcp_trace_user_meta_buf;
-};
-
 /******************************** Constants **********************************/
 
 #define MAX_MSG_LEN				1024
@@ -6183,7 +5537,7 @@ struct dbg_tools_user_data {
 #define MCP_TRACE_MAX_MODULE_LEN		8
 #define MCP_TRACE_FORMAT_MAX_PARAMS		3
 #define MCP_TRACE_FORMAT_PARAM_WIDTH \
-	(MCP_TRACE_FORMAT_P2_SIZE_SHIFT - MCP_TRACE_FORMAT_P1_SIZE_SHIFT)
+	(MCP_TRACE_FORMAT_P2_SIZE_OFFSET - MCP_TRACE_FORMAT_P1_SIZE_OFFSET)
 
 #define REG_FIFO_ELEMENT_ADDR_FACTOR		4
 #define REG_FIFO_ELEMENT_IS_PF_VF_VAL		127
@@ -6192,107 +5546,6 @@ struct dbg_tools_user_data {
 
 /***************************** Constant Arrays *******************************/
 
-struct user_dbg_array {
-	const u32 *ptr;
-	u32 size_in_dwords;
-};
-
-/* Debug arrays */
-static struct user_dbg_array
-s_user_dbg_arrays[MAX_BIN_DBG_BUFFER_TYPE] = { {NULL} };
-
-/* Block names array */
-static struct block_info s_block_info_arr[] = {
-	{"grc", BLOCK_GRC},
-	{"miscs", BLOCK_MISCS},
-	{"misc", BLOCK_MISC},
-	{"dbu", BLOCK_DBU},
-	{"pglue_b", BLOCK_PGLUE_B},
-	{"cnig", BLOCK_CNIG},
-	{"cpmu", BLOCK_CPMU},
-	{"ncsi", BLOCK_NCSI},
-	{"opte", BLOCK_OPTE},
-	{"bmb", BLOCK_BMB},
-	{"pcie", BLOCK_PCIE},
-	{"mcp", BLOCK_MCP},
-	{"mcp2", BLOCK_MCP2},
-	{"pswhst", BLOCK_PSWHST},
-	{"pswhst2", BLOCK_PSWHST2},
-	{"pswrd", BLOCK_PSWRD},
-	{"pswrd2", BLOCK_PSWRD2},
-	{"pswwr", BLOCK_PSWWR},
-	{"pswwr2", BLOCK_PSWWR2},
-	{"pswrq", BLOCK_PSWRQ},
-	{"pswrq2", BLOCK_PSWRQ2},
-	{"pglcs", BLOCK_PGLCS},
-	{"ptu", BLOCK_PTU},
-	{"dmae", BLOCK_DMAE},
-	{"tcm", BLOCK_TCM},
-	{"mcm", BLOCK_MCM},
-	{"ucm", BLOCK_UCM},
-	{"xcm", BLOCK_XCM},
-	{"ycm", BLOCK_YCM},
-	{"pcm", BLOCK_PCM},
-	{"qm", BLOCK_QM},
-	{"tm", BLOCK_TM},
-	{"dorq", BLOCK_DORQ},
-	{"brb", BLOCK_BRB},
-	{"src", BLOCK_SRC},
-	{"prs", BLOCK_PRS},
-	{"tsdm", BLOCK_TSDM},
-	{"msdm", BLOCK_MSDM},
-	{"usdm", BLOCK_USDM},
-	{"xsdm", BLOCK_XSDM},
-	{"ysdm", BLOCK_YSDM},
-	{"psdm", BLOCK_PSDM},
-	{"tsem", BLOCK_TSEM},
-	{"msem", BLOCK_MSEM},
-	{"usem", BLOCK_USEM},
-	{"xsem", BLOCK_XSEM},
-	{"ysem", BLOCK_YSEM},
-	{"psem", BLOCK_PSEM},
-	{"rss", BLOCK_RSS},
-	{"tmld", BLOCK_TMLD},
-	{"muld", BLOCK_MULD},
-	{"yuld", BLOCK_YULD},
-	{"xyld", BLOCK_XYLD},
-	{"ptld", BLOCK_PTLD},
-	{"ypld", BLOCK_YPLD},
-	{"prm", BLOCK_PRM},
-	{"pbf_pb1", BLOCK_PBF_PB1},
-	{"pbf_pb2", BLOCK_PBF_PB2},
-	{"rpb", BLOCK_RPB},
-	{"btb", BLOCK_BTB},
-	{"pbf", BLOCK_PBF},
-	{"rdif", BLOCK_RDIF},
-	{"tdif", BLOCK_TDIF},
-	{"cdu", BLOCK_CDU},
-	{"ccfc", BLOCK_CCFC},
-	{"tcfc", BLOCK_TCFC},
-	{"igu", BLOCK_IGU},
-	{"cau", BLOCK_CAU},
-	{"rgfs", BLOCK_RGFS},
-	{"rgsrc", BLOCK_RGSRC},
-	{"tgfs", BLOCK_TGFS},
-	{"tgsrc", BLOCK_TGSRC},
-	{"umac", BLOCK_UMAC},
-	{"xmac", BLOCK_XMAC},
-	{"dbg", BLOCK_DBG},
-	{"nig", BLOCK_NIG},
-	{"wol", BLOCK_WOL},
-	{"bmbn", BLOCK_BMBN},
-	{"ipc", BLOCK_IPC},
-	{"nwm", BLOCK_NWM},
-	{"nws", BLOCK_NWS},
-	{"ms", BLOCK_MS},
-	{"phy_pcie", BLOCK_PHY_PCIE},
-	{"led", BLOCK_LED},
-	{"avs_wrap", BLOCK_AVS_WRAP},
-	{"pxpreqbus", BLOCK_PXPREQBUS},
-	{"misc_aeu", BLOCK_MISC_AEU},
-	{"bar0_map", BLOCK_BAR0_MAP}
-};
-
 /* Status string array */
 static const char * const s_status_str[] = {
 	/* DBG_STATUS_OK */
@@ -6322,14 +5575,12 @@ static const char * const s_status_str[] = {
 	/* DBG_STATUS_PCI_BUF_NOT_ALLOCATED */
 	"A PCI buffer wasn't allocated",
 
-	/* DBG_STATUS_TOO_MANY_INPUTS */
-	"Too many inputs were enabled. Enabled less inputs, or set 'unifyInputs' to true",
+	/* DBG_STATUS_INVALID_FILTER_TRIGGER_DWORDS */
+	"The filter/trigger constraint dword offsets are not enabled for recording",
 
-	/* DBG_STATUS_INPUT_OVERLAP */
-	"Overlapping debug bus inputs",
 
-	/* DBG_STATUS_HW_ONLY_RECORDING */
-	"Cannot record Storm data since the entire recording cycle is used by HW",
+	/* DBG_STATUS_VFC_READ_ERROR */
+	"Error reading from VFC",
 
 	/* DBG_STATUS_STORM_ALREADY_ENABLED */
 	"The Storm was already enabled",
@@ -6346,8 +5597,8 @@ static const char * const s_status_str[] = {
 	/* DBG_STATUS_NO_INPUT_ENABLED */
 	"No input was enabled for recording",
 
-	/* DBG_STATUS_NO_FILTER_TRIGGER_64B */
-	"Filters and triggers are not allowed when recording in 64b units",
+	/* DBG_STATUS_NO_FILTER_TRIGGER_256B */
+	"Filters and triggers are not allowed in E4 256-bit mode",
 
 	/* DBG_STATUS_FILTER_ALREADY_ENABLED */
 	"The filter was already enabled",
@@ -6421,8 +5672,8 @@ static const char * const s_status_str[] = {
 	/* DBG_STATUS_MCP_COULD_NOT_RESUME */
 	"Failed to resume MCP after halt",
 
-	/* DBG_STATUS_RESERVED2 */
-	"Reserved debug status - shouldn't be returned",
+	/* DBG_STATUS_RESERVED0 */
+	"",
 
 	/* DBG_STATUS_SEMI_FIFO_NOT_EMPTY */
 	"Failed to empty SEMI sync FIFO",
@@ -6445,17 +5696,32 @@ static const char * const s_status_str[] = {
 	/* DBG_STATUS_DBG_ARRAY_NOT_SET */
 	"Debug arrays were not set (when using binary files, dbg_set_bin_ptr must be called)",
 
-	/* DBG_STATUS_FILTER_BUG */
-	"Debug Bus filtering requires the -unifyInputs option (due to a HW bug)",
+	/* DBG_STATUS_RESERVED1 */
+	"",
 
 	/* DBG_STATUS_NON_MATCHING_LINES */
-	"Non-matching debug lines - all lines must be of the same type (either 128b or 256b)",
+	"Non-matching debug lines - in E4, all lines must be of the same type (either 128b or 256b)",
 
-	/* DBG_STATUS_INVALID_TRIGGER_DWORD_OFFSET */
-	"The selected trigger dword offset wasn't enabled in the recorded HW block",
+	/* DBG_STATUS_INSUFFICIENT_HW_IDS */
+	"Insufficient HW IDs. Try to record less Storms/blocks",
 
 	/* DBG_STATUS_DBG_BUS_IN_USE */
-	"The debug bus is in use"
+	"The debug bus is in use",
+
+	/* DBG_STATUS_INVALID_STORM_DBG_MODE */
+	"The storm debug mode is not supported in the current chip",
+
+	/* DBG_STATUS_OTHER_ENGINE_BB_ONLY */
+	"Other engine is supported only in BB",
+
+	/* DBG_STATUS_FILTER_SINGLE_HW_ID */
+	"The configured filter mode requires a single Storm/block input",
+
+	/* DBG_STATUS_TRIGGER_SINGLE_HW_ID */
+	"The configured filter mode requires that all the constraints of a single trigger state will be defined on a single Storm/block input",
+
+	/* DBG_STATUS_MISSING_TRIGGER_STATE_STORM */
+	"When triggering on Storm data, the Storm to trigger on must be specified"
 };
 
 /* Idle check severity names array */
@@ -6511,7 +5777,7 @@ static const char * const s_master_strs[] = {
 	"xsdm",
 	"dbu",
 	"dmae",
-	"???",
+	"jdap",
 	"???",
 	"???",
 	"???",
@@ -6519,12 +5785,13 @@ static const char * const s_master_strs[] = {
 };
 
 /* REG FIFO error messages array */
-static const char * const s_reg_fifo_error_strs[] = {
-	"grc timeout",
-	"address doesn't belong to any block",
-	"reserved address in block or write to read-only address",
-	"privilege/protection mismatch",
-	"path isolation error"
+static struct reg_fifo_err s_reg_fifo_errors[] = {
+	{1, "grc timeout"},
+	{2, "address doesn't belong to any block"},
+	{4, "reserved address in block or write to read-only address"},
+	{8, "privilege/protection mismatch"},
+	{16, "path isolation error"},
+	{17, "RSL error"}
 };
 
 /* IGU FIFO sources array */
@@ -6764,8 +6031,21 @@ static u32 qed_print_section_params(u32 *dump_buf,
 	return dump_offset;
 }
 
-static struct dbg_tools_user_data *
-qed_dbg_get_user_data(struct qed_hwfn *p_hwfn)
+/* Returns the block name that matches the specified block ID,
+ * or NULL if not found.
+ */
+static const char *qed_dbg_get_block_name(struct qed_hwfn *p_hwfn,
+					  enum block_id block_id)
+{
+	const struct dbg_block_user *block =
+	    (const struct dbg_block_user *)
+	    p_hwfn->dbg_arrays[BIN_BUF_DBG_BLOCKS_USER_DATA].ptr + block_id;
+
+	return (const char *)block->name;
+}
+
+static struct dbg_tools_user_data *qed_dbg_get_user_data(struct qed_hwfn
+							 *p_hwfn)
 {
 	return (struct dbg_tools_user_data *)p_hwfn->dbg_user_info;
 }
@@ -6773,7 +6053,8 @@ qed_dbg_get_user_data(struct qed_hwfn *p_hwfn)
 /* Parses the idle check rules and returns the number of characters printed.
  * In case of parsing error, returns 0.
  */
-static u32 qed_parse_idle_chk_dump_rules(u32 *dump_buf,
+static u32 qed_parse_idle_chk_dump_rules(struct qed_hwfn *p_hwfn,
+					 u32 *dump_buf,
 					 u32 *dump_buf_end,
 					 u32 num_rules,
 					 bool print_fw_idle_chk,
@@ -6801,19 +6082,18 @@ static u32 qed_parse_idle_chk_dump_rules(u32 *dump_buf,
 
 		hdr = (struct dbg_idle_chk_result_hdr *)dump_buf;
 		rule_parsing_data =
-			(const struct dbg_idle_chk_rule_parsing_data *)
-			&s_user_dbg_arrays[BIN_BUF_DBG_IDLE_CHK_PARSING_DATA].
-			ptr[hdr->rule_id];
+		    (const struct dbg_idle_chk_rule_parsing_data *)
+		    p_hwfn->dbg_arrays[BIN_BUF_DBG_IDLE_CHK_PARSING_DATA].ptr +
+		    hdr->rule_id;
 		parsing_str_offset =
-			GET_FIELD(rule_parsing_data->data,
-				  DBG_IDLE_CHK_RULE_PARSING_DATA_STR_OFFSET);
+		    GET_FIELD(rule_parsing_data->data,
+			      DBG_IDLE_CHK_RULE_PARSING_DATA_STR_OFFSET);
 		has_fw_msg =
-			GET_FIELD(rule_parsing_data->data,
-				DBG_IDLE_CHK_RULE_PARSING_DATA_HAS_FW_MSG) > 0;
-		parsing_str =
-			&((const char *)
-			s_user_dbg_arrays[BIN_BUF_DBG_PARSING_STRINGS].ptr)
-			[parsing_str_offset];
+		    GET_FIELD(rule_parsing_data->data,
+			      DBG_IDLE_CHK_RULE_PARSING_DATA_HAS_FW_MSG) > 0;
+		parsing_str = (const char *)
+		    p_hwfn->dbg_arrays[BIN_BUF_DBG_PARSING_STRINGS].ptr +
+		    parsing_str_offset;
 		lsi_msg = parsing_str;
 		curr_reg_id = 0;
 
@@ -6917,7 +6197,8 @@ static u32 qed_parse_idle_chk_dump_rules(u32 *dump_buf,
  * parsed_results_bytes.
  * The parsing status is returned.
  */
-static enum dbg_status qed_parse_idle_chk_dump(u32 *dump_buf,
+static enum dbg_status qed_parse_idle_chk_dump(struct qed_hwfn *p_hwfn,
+					       u32 *dump_buf,
 					       u32 num_dumped_dwords,
 					       char *results_buf,
 					       u32 *parsed_results_bytes,
@@ -6935,8 +6216,8 @@ static enum dbg_status qed_parse_idle_chk_dump(u32 *dump_buf,
 	*num_errors = 0;
 	*num_warnings = 0;
 
-	if (!s_user_dbg_arrays[BIN_BUF_DBG_PARSING_STRINGS].ptr ||
-	    !s_user_dbg_arrays[BIN_BUF_DBG_IDLE_CHK_PARSING_DATA].ptr)
+	if (!p_hwfn->dbg_arrays[BIN_BUF_DBG_PARSING_STRINGS].ptr ||
+	    !p_hwfn->dbg_arrays[BIN_BUF_DBG_IDLE_CHK_PARSING_DATA].ptr)
 		return DBG_STATUS_DBG_ARRAY_NOT_SET;
 
 	/* Read global_params section */
@@ -6969,7 +6250,8 @@ static enum dbg_status qed_parse_idle_chk_dump(u32 *dump_buf,
 					    results_offset),
 			    "FW_IDLE_CHECK:\n");
 		rules_print_size =
-			qed_parse_idle_chk_dump_rules(dump_buf,
+			qed_parse_idle_chk_dump_rules(p_hwfn,
+						      dump_buf,
 						      dump_buf_end,
 						      num_rules,
 						      true,
@@ -6989,7 +6271,8 @@ static enum dbg_status qed_parse_idle_chk_dump(u32 *dump_buf,
 					    results_offset),
 			    "\nLSI_IDLE_CHECK:\n");
 		rules_print_size =
-			qed_parse_idle_chk_dump_rules(dump_buf,
+			qed_parse_idle_chk_dump_rules(p_hwfn,
+						      dump_buf,
 						      dump_buf_end,
 						      num_rules,
 						      false,
@@ -7101,9 +6384,8 @@ qed_mcp_trace_alloc_meta_data(struct qed_hwfn *p_hwfn,
 
 		format_ptr->data = qed_read_dword_from_buf(meta_buf_bytes,
 							   &offset);
-		format_len =
-		    (format_ptr->data &
-		     MCP_TRACE_FORMAT_LEN_MASK) >> MCP_TRACE_FORMAT_LEN_SHIFT;
+		format_len = GET_MFW_FIELD(format_ptr->data,
+					   MCP_TRACE_FORMAT_LEN);
 		format_ptr->format_str = kzalloc(format_len, GFP_KERNEL);
 		if (!format_ptr->format_str) {
 			/* Update number of modules to be released */
@@ -7126,7 +6408,7 @@ qed_mcp_trace_alloc_meta_data(struct qed_hwfn *p_hwfn,
  * trace_buf - MCP trace cyclic buffer
  * trace_buf_size - MCP trace cyclic buffer size in bytes
  * data_offset - offset in bytes of the data to parse in the MCP trace cyclic
- *               buffer.
+ *		 buffer.
  * data_size - size in bytes of data to parse.
  * parsed_buf - destination buffer for parsed data.
  * parsed_results_bytes - size of parsed data in bytes.
@@ -7171,9 +6453,8 @@ static enum dbg_status qed_parse_mcp_trace_buf(struct qed_hwfn *p_hwfn,
 
 		/* Skip message if its index doesn't exist in the meta data */
 		if (format_idx >= meta->formats_num) {
-			u8 format_size =
-				(u8)((header & MFW_TRACE_PRM_SIZE_MASK) >>
-				     MFW_TRACE_PRM_SIZE_SHIFT);
+			u8 format_size = (u8)GET_MFW_FIELD(header,
+							   MFW_TRACE_PRM_SIZE);
 
 			if (data_size < format_size)
 				return DBG_STATUS_MCP_TRACE_BAD_DATA;
@@ -7188,11 +6469,10 @@ static enum dbg_status qed_parse_mcp_trace_buf(struct qed_hwfn *p_hwfn,
 		format_ptr = &meta->formats[format_idx];
 
 		for (i = 0,
-		     param_mask = MCP_TRACE_FORMAT_P1_SIZE_MASK,
-		     param_shift = MCP_TRACE_FORMAT_P1_SIZE_SHIFT;
+		     param_mask = MCP_TRACE_FORMAT_P1_SIZE_MASK, param_shift =
+		     MCP_TRACE_FORMAT_P1_SIZE_OFFSET;
 		     i < MCP_TRACE_FORMAT_MAX_PARAMS;
-		     i++,
-		     param_mask <<= MCP_TRACE_FORMAT_PARAM_WIDTH,
+		     i++, param_mask <<= MCP_TRACE_FORMAT_PARAM_WIDTH,
 		     param_shift += MCP_TRACE_FORMAT_PARAM_WIDTH) {
 			/* Extract param size (0..3) */
 			u8 param_size = (u8)((format_ptr->data & param_mask) >>
@@ -7220,12 +6500,10 @@ static enum dbg_status qed_parse_mcp_trace_buf(struct qed_hwfn *p_hwfn,
 			data_size -= param_size;
 		}
 
-		format_level = (u8)((format_ptr->data &
-				     MCP_TRACE_FORMAT_LEVEL_MASK) >>
-				    MCP_TRACE_FORMAT_LEVEL_SHIFT);
-		format_module = (u8)((format_ptr->data &
-				      MCP_TRACE_FORMAT_MODULE_MASK) >>
-				     MCP_TRACE_FORMAT_MODULE_SHIFT);
+		format_level = (u8)GET_MFW_FIELD(format_ptr->data,
+						 MCP_TRACE_FORMAT_LEVEL);
+		format_module = (u8)GET_MFW_FIELD(format_ptr->data,
+						  MCP_TRACE_FORMAT_MODULE);
 		if (format_level >= ARRAY_SIZE(s_mcp_trace_level_str))
 			return DBG_STATUS_MCP_TRACE_BAD_DATA;
 
@@ -7367,7 +6645,7 @@ static enum dbg_status qed_parse_reg_fifo_dump(u32 *dump_buf,
 	const char *section_name, *param_name, *param_str_val;
 	u32 param_num_val, num_section_params, num_elements;
 	struct reg_fifo_element *elements;
-	u8 i, j, err_val, vf_val;
+	u8 i, j, err_code, vf_val;
 	u32 results_offset = 0;
 	char vf_str[4];
 
@@ -7398,7 +6676,7 @@ static enum dbg_status qed_parse_reg_fifo_dump(u32 *dump_buf,
 
 	/* Decode elements */
 	for (i = 0; i < num_elements; i++) {
-		bool err_printed = false;
+		const char *err_msg = NULL;
 
 		/* Discover if element belongs to a VF or a PF */
 		vf_val = GET_FIELD(elements[i].data, REG_FIFO_ELEMENT_VF);
@@ -7407,11 +6685,17 @@ static enum dbg_status qed_parse_reg_fifo_dump(u32 *dump_buf,
 		else
 			sprintf(vf_str, "%d", vf_val);
 
+		/* Find error message */
+		err_code = GET_FIELD(elements[i].data, REG_FIFO_ELEMENT_ERROR);
+		for (j = 0; j < ARRAY_SIZE(s_reg_fifo_errors) && !err_msg; j++)
+			if (err_code == s_reg_fifo_errors[j].err_code)
+				err_msg = s_reg_fifo_errors[j].err_msg;
+
 		/* Add parsed element to parsed buffer */
 		results_offset +=
 		    sprintf(qed_get_buf_ptr(results_buf,
 					    results_offset),
-			    "raw: 0x%016llx, address: 0x%07x, access: %-5s, pf: %2d, vf: %s, port: %d, privilege: %-3s, protection: %-12s, master: %-4s, errors: ",
+			    "raw: 0x%016llx, address: 0x%07x, access: %-5s, pf: %2d, vf: %s, port: %d, privilege: %-3s, protection: %-12s, master: %-4s, error: %s\n",
 			    elements[i].data,
 			    (u32)GET_FIELD(elements[i].data,
 					   REG_FIFO_ELEMENT_ADDRESS) *
@@ -7428,30 +6712,8 @@ static enum dbg_status qed_parse_reg_fifo_dump(u32 *dump_buf,
 			    s_protection_strs[GET_FIELD(elements[i].data,
 						REG_FIFO_ELEMENT_PROTECTION)],
 			    s_master_strs[GET_FIELD(elements[i].data,
-						REG_FIFO_ELEMENT_MASTER)]);
-
-		/* Print errors */
-		for (j = 0,
-		     err_val = GET_FIELD(elements[i].data,
-					 REG_FIFO_ELEMENT_ERROR);
-		     j < ARRAY_SIZE(s_reg_fifo_error_strs);
-		     j++, err_val >>= 1) {
-			if (err_val & 0x1) {
-				if (err_printed)
-					results_offset +=
-					    sprintf(qed_get_buf_ptr
-						    (results_buf,
-						     results_offset), ", ");
-				results_offset +=
-				    sprintf(qed_get_buf_ptr
-					    (results_buf, results_offset), "%s",
-					    s_reg_fifo_error_strs[j]);
-				err_printed = true;
-			}
-		}
-
-		results_offset +=
-		    sprintf(qed_get_buf_ptr(results_buf, results_offset), "\n");
+						    REG_FIFO_ELEMENT_MASTER)],
+			    err_msg ? err_msg : "unknown error code");
 	}
 
 	results_offset += sprintf(qed_get_buf_ptr(results_buf,
@@ -7805,27 +7067,28 @@ static enum dbg_status qed_parse_fw_asserts_dump(u32 *dump_buf,
 
 /***************************** Public Functions *******************************/
 
-enum dbg_status qed_dbg_user_set_bin_ptr(const u8 * const bin_ptr)
+enum dbg_status qed_dbg_user_set_bin_ptr(struct qed_hwfn *p_hwfn,
+					 const u8 * const bin_ptr)
 {
-	struct bin_buffer_hdr *buf_array = (struct bin_buffer_hdr *)bin_ptr;
+	struct bin_buffer_hdr *buf_hdrs = (struct bin_buffer_hdr *)bin_ptr;
 	u8 buf_id;
 
 	/* Convert binary data to debug arrays */
-	for (buf_id = 0; buf_id < MAX_BIN_DBG_BUFFER_TYPE; buf_id++) {
-		s_user_dbg_arrays[buf_id].ptr =
-			(u32 *)(bin_ptr + buf_array[buf_id].offset);
-		s_user_dbg_arrays[buf_id].size_in_dwords =
-			BYTES_TO_DWORDS(buf_array[buf_id].length);
-	}
+	for (buf_id = 0; buf_id < MAX_BIN_DBG_BUFFER_TYPE; buf_id++)
+		qed_set_dbg_bin_buf(p_hwfn,
+				    (enum bin_dbg_buffer_type)buf_id,
+				    (u32 *)(bin_ptr + buf_hdrs[buf_id].offset),
+				    buf_hdrs[buf_id].length);
 
 	return DBG_STATUS_OK;
 }
 
-enum dbg_status qed_dbg_alloc_user_data(struct qed_hwfn *p_hwfn)
+enum dbg_status qed_dbg_alloc_user_data(struct qed_hwfn *p_hwfn,
+					void **user_data_ptr)
 {
-	p_hwfn->dbg_user_info = kzalloc(sizeof(struct dbg_tools_user_data),
-					GFP_KERNEL);
-	if (!p_hwfn->dbg_user_info)
+	*user_data_ptr = kzalloc(sizeof(struct dbg_tools_user_data),
+				 GFP_KERNEL);
+	if (!(*user_data_ptr))
 		return DBG_STATUS_VIRT_MEM_ALLOC_FAILED;
 
 	return DBG_STATUS_OK;
@@ -7844,7 +7107,8 @@ enum dbg_status qed_get_idle_chk_results_buf_size(struct qed_hwfn *p_hwfn,
 {
 	u32 num_errors, num_warnings;
 
-	return qed_parse_idle_chk_dump(dump_buf,
+	return qed_parse_idle_chk_dump(p_hwfn,
+				       dump_buf,
 				       num_dumped_dwords,
 				       NULL,
 				       results_buf_size,
@@ -7860,7 +7124,8 @@ enum dbg_status qed_print_idle_chk_results(struct qed_hwfn *p_hwfn,
 {
 	u32 parsed_buf_size;
 
-	return qed_parse_idle_chk_dump(dump_buf,
+	return qed_parse_idle_chk_dump(p_hwfn,
+				       dump_buf,
 				       num_dumped_dwords,
 				       results_buf,
 				       &parsed_buf_size,
@@ -8031,25 +7296,28 @@ enum dbg_status qed_print_fw_asserts_results(struct qed_hwfn *p_hwfn,
 enum dbg_status qed_dbg_parse_attn(struct qed_hwfn *p_hwfn,
 				   struct dbg_attn_block_result *results)
 {
-	struct user_dbg_array *block_attn, *pstrings;
 	const u32 *block_attn_name_offsets;
-	enum dbg_attn_type attn_type;
+	const char *attn_name_base;
 	const char *block_name;
+	enum dbg_attn_type attn_type;
 	u8 num_regs, i, j;
 
 	num_regs = GET_FIELD(results->data, DBG_ATTN_BLOCK_RESULT_NUM_REGS);
-	attn_type = (enum dbg_attn_type)
-		    GET_FIELD(results->data,
-			      DBG_ATTN_BLOCK_RESULT_ATTN_TYPE);
-	block_name = s_block_info_arr[results->block_id].name;
-
-	if (!s_user_dbg_arrays[BIN_BUF_DBG_ATTN_INDEXES].ptr ||
-	    !s_user_dbg_arrays[BIN_BUF_DBG_ATTN_NAME_OFFSETS].ptr ||
-	    !s_user_dbg_arrays[BIN_BUF_DBG_PARSING_STRINGS].ptr)
+	attn_type = GET_FIELD(results->data, DBG_ATTN_BLOCK_RESULT_ATTN_TYPE);
+	block_name = qed_dbg_get_block_name(p_hwfn, results->block_id);
+	if (!block_name)
+		return DBG_STATUS_INVALID_ARGS;
+
+	if (!p_hwfn->dbg_arrays[BIN_BUF_DBG_ATTN_INDEXES].ptr ||
+	    !p_hwfn->dbg_arrays[BIN_BUF_DBG_ATTN_NAME_OFFSETS].ptr ||
+	    !p_hwfn->dbg_arrays[BIN_BUF_DBG_PARSING_STRINGS].ptr)
 		return DBG_STATUS_DBG_ARRAY_NOT_SET;
 
-	block_attn = &s_user_dbg_arrays[BIN_BUF_DBG_ATTN_NAME_OFFSETS];
-	block_attn_name_offsets = &block_attn->ptr[results->names_offset];
+	block_attn_name_offsets =
+	    (u32 *)p_hwfn->dbg_arrays[BIN_BUF_DBG_ATTN_NAME_OFFSETS].ptr +
+	    results->names_offset;
+
+	attn_name_base = p_hwfn->dbg_arrays[BIN_BUF_DBG_PARSING_STRINGS].ptr;
 
 	/* Go over registers with a non-zero attention status */
 	for (i = 0; i < num_regs; i++) {
@@ -8060,18 +7328,17 @@ enum dbg_status qed_dbg_parse_attn(struct qed_hwfn *p_hwfn,
 		reg_result = &results->reg_results[i];
 		num_reg_attn = GET_FIELD(reg_result->data,
 					 DBG_ATTN_REG_RESULT_NUM_REG_ATTN);
-		block_attn = &s_user_dbg_arrays[BIN_BUF_DBG_ATTN_INDEXES];
-		bit_mapping = &((struct dbg_attn_bit_mapping *)
-				block_attn->ptr)[reg_result->block_attn_offset];
-
-		pstrings = &s_user_dbg_arrays[BIN_BUF_DBG_PARSING_STRINGS];
+		bit_mapping = (struct dbg_attn_bit_mapping *)
+		    p_hwfn->dbg_arrays[BIN_BUF_DBG_ATTN_INDEXES].ptr +
+		    reg_result->block_attn_offset;
 
 		/* Go over attention status bits */
-		for (j = 0; j < num_reg_attn; j++) {
+		for (j = 0; j < num_reg_attn; j++, bit_idx++) {
 			u16 attn_idx_val = GET_FIELD(bit_mapping[j].data,
 						     DBG_ATTN_BIT_MAPPING_VAL);
 			const char *attn_name, *attn_type_str, *masked_str;
-			u32 attn_name_offset, sts_addr;
+			u32 attn_name_offset;
+			u32 sts_addr;
 
 			/* Check if bit mask should be advanced (due to unused
 			 * bits).
@@ -8083,18 +7350,19 @@ enum dbg_status qed_dbg_parse_attn(struct qed_hwfn *p_hwfn,
 			}
 
 			/* Check current bit index */
-			if (!(reg_result->sts_val & BIT(bit_idx))) {
-				bit_idx++;
+			if (!(reg_result->sts_val & BIT(bit_idx)))
 				continue;
-			}
 
-			/* Find attention name */
+			/* An attention bit with value=1 was found
+			 * Find attention name
+			 */
 			attn_name_offset =
 				block_attn_name_offsets[attn_idx_val];
-			attn_name = &((const char *)
-				      pstrings->ptr)[attn_name_offset];
-			attn_type_str = attn_type == ATTN_TYPE_INTERRUPT ?
-					"Interrupt" : "Parity";
+			attn_name = attn_name_base + attn_name_offset;
+			attn_type_str =
+				(attn_type ==
+				 ATTN_TYPE_INTERRUPT ? "Interrupt" :
+				 "Parity");
 			masked_str = reg_result->mask_val & BIT(bit_idx) ?
 				     " [masked]" : "";
 			sts_addr = GET_FIELD(reg_result->data,
@@ -8102,15 +7370,15 @@ enum dbg_status qed_dbg_parse_attn(struct qed_hwfn *p_hwfn,
 			DP_NOTICE(p_hwfn,
 				  "%s (%s) : %s [address 0x%08x, bit %d]%s\n",
 				  block_name, attn_type_str, attn_name,
-				  sts_addr, bit_idx, masked_str);
-
-			bit_idx++;
+				  sts_addr * 4, bit_idx, masked_str);
 		}
 	}
 
 	return DBG_STATUS_OK;
 }
 
+static DEFINE_MUTEX(qed_dbg_lock);
+
 /* Wrapper for unifying the idle_chk and mcp_trace api */
 static enum dbg_status
 qed_print_idle_chk_results_wrapper(struct qed_hwfn *p_hwfn,
@@ -8287,6 +7555,17 @@ static enum dbg_status qed_dbg_dump(struct qed_hwfn *p_hwfn,
 						       &buf_size_dwords);
 	if (rc != DBG_STATUS_OK && rc != DBG_STATUS_NVRAM_GET_IMAGE_FAILED)
 		return rc;
+
+	if (buf_size_dwords > MAX_DBG_FEATURE_SIZE_DWORDS) {
+		feature->buf_size = 0;
+		DP_NOTICE(p_hwfn->cdev,
+			  "Debug feature [\"%s\"] size (0x%x dwords) exceeds maximum size (0x%x dwords)\n",
+			  qed_features_lookup[feature_idx].name,
+			  buf_size_dwords, MAX_DBG_FEATURE_SIZE_DWORDS);
+
+		return DBG_STATUS_OK;
+	}
+
 	feature->buf_size = buf_size_dwords * sizeof(u32);
 	feature->dump_buf = vmalloc(feature->buf_size);
 	if (!feature->dump_buf)
@@ -8487,15 +7766,23 @@ enum debug_print_features {
 	ILT_DUMP = 13,
 };
 
-static u32 qed_calc_regdump_header(enum debug_print_features feature,
+static u32 qed_calc_regdump_header(struct qed_dev *cdev,
+				   enum debug_print_features feature,
 				   int engine, u32 feature_size, u8 omit_engine)
 {
-	/* Insert the engine, feature and mode inside the header and combine it
-	 * with feature size.
-	 */
-	return feature_size | (feature << REGDUMP_HEADER_FEATURE_SHIFT) |
-	       (omit_engine << REGDUMP_HEADER_OMIT_ENGINE_SHIFT) |
-	       (engine << REGDUMP_HEADER_ENGINE_SHIFT);
+	u32 res = 0;
+
+	SET_FIELD(res, REGDUMP_HEADER_SIZE, feature_size);
+	if (res != feature_size)
+		DP_NOTICE(cdev,
+			  "Feature %d is too large (size 0x%x) and will corrupt the dump\n",
+			  feature, feature_size);
+
+	SET_FIELD(res, REGDUMP_HEADER_FEATURE, feature);
+	SET_FIELD(res, REGDUMP_HEADER_OMIT_ENGINE, omit_engine);
+	SET_FIELD(res, REGDUMP_HEADER_ENGINE, engine);
+
+	return res;
 }
 
 int qed_dbg_all_data(struct qed_dev *cdev, void *buffer)
@@ -8511,9 +7798,11 @@ int qed_dbg_all_data(struct qed_dev *cdev, void *buffer)
 	for (i = 0; i < MAX_DBG_GRC_PARAMS; i++)
 		grc_params[i] = dev_data->grc.param_val[i];
 
-	if (cdev->num_hwfns == 1)
+	if (!QED_IS_CMT(cdev))
 		omit_engine = 1;
 
+	mutex_lock(&qed_dbg_lock);
+
 	org_engine = qed_get_debug_engine(cdev);
 	for (cur_engine = 0; cur_engine < cdev->num_hwfns; cur_engine++) {
 		/* Collect idle_chks and grcDump for each hw function */
@@ -8526,7 +7815,7 @@ int qed_dbg_all_data(struct qed_dev *cdev, void *buffer)
 				      REGDUMP_HEADER_SIZE, &feature_size);
 		if (!rc) {
 			*(u32 *)((u8 *)buffer + offset) =
-			    qed_calc_regdump_header(IDLE_CHK, cur_engine,
+			    qed_calc_regdump_header(cdev, IDLE_CHK, cur_engine,
 						    feature_size, omit_engine);
 			offset += (feature_size + REGDUMP_HEADER_SIZE);
 		} else {
@@ -8538,7 +7827,7 @@ int qed_dbg_all_data(struct qed_dev *cdev, void *buffer)
 				      REGDUMP_HEADER_SIZE, &feature_size);
 		if (!rc) {
 			*(u32 *)((u8 *)buffer + offset) =
-			    qed_calc_regdump_header(IDLE_CHK, cur_engine,
+			    qed_calc_regdump_header(cdev, IDLE_CHK, cur_engine,
 						    feature_size, omit_engine);
 			offset += (feature_size + REGDUMP_HEADER_SIZE);
 		} else {
@@ -8550,7 +7839,7 @@ int qed_dbg_all_data(struct qed_dev *cdev, void *buffer)
 				      REGDUMP_HEADER_SIZE, &feature_size);
 		if (!rc) {
 			*(u32 *)((u8 *)buffer + offset) =
-			    qed_calc_regdump_header(REG_FIFO, cur_engine,
+			    qed_calc_regdump_header(cdev, REG_FIFO, cur_engine,
 						    feature_size, omit_engine);
 			offset += (feature_size + REGDUMP_HEADER_SIZE);
 		} else {
@@ -8562,7 +7851,7 @@ int qed_dbg_all_data(struct qed_dev *cdev, void *buffer)
 				      REGDUMP_HEADER_SIZE, &feature_size);
 		if (!rc) {
 			*(u32 *)((u8 *)buffer + offset) =
-			    qed_calc_regdump_header(IGU_FIFO, cur_engine,
+			    qed_calc_regdump_header(cdev, IGU_FIFO, cur_engine,
 						    feature_size, omit_engine);
 			offset += (feature_size + REGDUMP_HEADER_SIZE);
 		} else {
@@ -8575,7 +7864,7 @@ int qed_dbg_all_data(struct qed_dev *cdev, void *buffer)
 						 &feature_size);
 		if (!rc) {
 			*(u32 *)((u8 *)buffer + offset) =
-			    qed_calc_regdump_header(PROTECTION_OVERRIDE,
+			    qed_calc_regdump_header(cdev, PROTECTION_OVERRIDE,
 						    cur_engine,
 						    feature_size, omit_engine);
 			offset += (feature_size + REGDUMP_HEADER_SIZE);
@@ -8590,8 +7879,9 @@ int qed_dbg_all_data(struct qed_dev *cdev, void *buffer)
 					REGDUMP_HEADER_SIZE, &feature_size);
 		if (!rc) {
 			*(u32 *)((u8 *)buffer + offset) =
-			    qed_calc_regdump_header(FW_ASSERTS, cur_engine,
-						    feature_size, omit_engine);
+			    qed_calc_regdump_header(cdev, FW_ASSERTS,
+						    cur_engine, feature_size,
+						    omit_engine);
 			offset += (feature_size + REGDUMP_HEADER_SIZE);
 		} else {
 			DP_ERR(cdev, "qed_dbg_fw_asserts failed. rc = %d\n",
@@ -8605,7 +7895,7 @@ int qed_dbg_all_data(struct qed_dev *cdev, void *buffer)
 					 REGDUMP_HEADER_SIZE, &feature_size);
 			if (!rc) {
 				*(u32 *)((u8 *)buffer + offset) =
-				    qed_calc_regdump_header(ILT_DUMP,
+				    qed_calc_regdump_header(cdev, ILT_DUMP,
 							    cur_engine,
 							    feature_size,
 							    omit_engine);
@@ -8619,11 +7909,15 @@ int qed_dbg_all_data(struct qed_dev *cdev, void *buffer)
 		/* GRC dump - must be last because when mcp stuck it will
 		 * clutter idle_chk, reg_fifo, ...
 		 */
+		for (i = 0; i < MAX_DBG_GRC_PARAMS; i++)
+			dev_data->grc.param_val[i] = grc_params[i];
+
 		rc = qed_dbg_grc(cdev, (u8 *)buffer + offset +
 				 REGDUMP_HEADER_SIZE, &feature_size);
 		if (!rc) {
 			*(u32 *)((u8 *)buffer + offset) =
-			    qed_calc_regdump_header(GRC_DUMP, cur_engine,
+			    qed_calc_regdump_header(cdev, GRC_DUMP,
+						    cur_engine,
 						    feature_size, omit_engine);
 			offset += (feature_size + REGDUMP_HEADER_SIZE);
 		} else {
@@ -8632,12 +7926,13 @@ int qed_dbg_all_data(struct qed_dev *cdev, void *buffer)
 	}
 
 	qed_set_debug_engine(cdev, org_engine);
+
 	/* mcp_trace */
 	rc = qed_dbg_mcp_trace(cdev, (u8 *)buffer + offset +
 			       REGDUMP_HEADER_SIZE, &feature_size);
 	if (!rc) {
 		*(u32 *)((u8 *)buffer + offset) =
-		    qed_calc_regdump_header(MCP_TRACE, cur_engine,
+		    qed_calc_regdump_header(cdev, MCP_TRACE, cur_engine,
 					    feature_size, omit_engine);
 		offset += (feature_size + REGDUMP_HEADER_SIZE);
 	} else {
@@ -8646,11 +7941,12 @@ int qed_dbg_all_data(struct qed_dev *cdev, void *buffer)
 
 	/* nvm cfg1 */
 	rc = qed_dbg_nvm_image(cdev,
-			       (u8 *)buffer + offset + REGDUMP_HEADER_SIZE,
-			       &feature_size, QED_NVM_IMAGE_NVM_CFG1);
+			       (u8 *)buffer + offset +
+			       REGDUMP_HEADER_SIZE, &feature_size,
+			       QED_NVM_IMAGE_NVM_CFG1);
 	if (!rc) {
 		*(u32 *)((u8 *)buffer + offset) =
-		    qed_calc_regdump_header(NVM_CFG1, cur_engine,
+		    qed_calc_regdump_header(cdev, NVM_CFG1, cur_engine,
 					    feature_size, omit_engine);
 		offset += (feature_size + REGDUMP_HEADER_SIZE);
 	} else if (rc != -ENOENT) {
@@ -8665,7 +7961,7 @@ int qed_dbg_all_data(struct qed_dev *cdev, void *buffer)
 			       &feature_size, QED_NVM_IMAGE_DEFAULT_CFG);
 	if (!rc) {
 		*(u32 *)((u8 *)buffer + offset) =
-		    qed_calc_regdump_header(DEFAULT_CFG, cur_engine,
+		    qed_calc_regdump_header(cdev, DEFAULT_CFG, cur_engine,
 					    feature_size, omit_engine);
 		offset += (feature_size + REGDUMP_HEADER_SIZE);
 	} else if (rc != -ENOENT) {
@@ -8681,8 +7977,8 @@ int qed_dbg_all_data(struct qed_dev *cdev, void *buffer)
 			       &feature_size, QED_NVM_IMAGE_NVM_META);
 	if (!rc) {
 		*(u32 *)((u8 *)buffer + offset) =
-		    qed_calc_regdump_header(NVM_META, cur_engine,
-					    feature_size, omit_engine);
+			qed_calc_regdump_header(cdev, NVM_META, cur_engine,
+						feature_size, omit_engine);
 		offset += (feature_size + REGDUMP_HEADER_SIZE);
 	} else if (rc != -ENOENT) {
 		DP_ERR(cdev,
@@ -8696,7 +7992,7 @@ int qed_dbg_all_data(struct qed_dev *cdev, void *buffer)
 			       QED_NVM_IMAGE_MDUMP);
 	if (!rc) {
 		*(u32 *)((u8 *)buffer + offset) =
-			qed_calc_regdump_header(MDUMP, cur_engine,
+			qed_calc_regdump_header(cdev, MDUMP, cur_engine,
 						feature_size, omit_engine);
 		offset += (feature_size + REGDUMP_HEADER_SIZE);
 	} else if (rc != -ENOENT) {
@@ -8705,6 +8001,8 @@ int qed_dbg_all_data(struct qed_dev *cdev, void *buffer)
 		       QED_NVM_IMAGE_MDUMP, "QED_NVM_IMAGE_MDUMP", rc);
 	}
 
+	mutex_unlock(&qed_dbg_lock);
+
 	return 0;
 }
 
@@ -8715,6 +8013,7 @@ int qed_dbg_all_data_size(struct qed_dev *cdev)
 	u32 regs_len = 0, image_len = 0, ilt_len = 0, total_ilt_len = 0;
 	u8 cur_engine, org_engine;
 
+	cdev->disable_ilt_dump = false;
 	org_engine = qed_get_debug_engine(cdev);
 	for (cur_engine = 0; cur_engine < cdev->num_hwfns; cur_engine++) {
 		/* Engine specific */
@@ -8806,9 +8105,8 @@ int qed_dbg_feature_size(struct qed_dev *cdev, enum qed_dbg_features feature)
 {
 	struct qed_hwfn *p_hwfn =
 		&cdev->hwfns[cdev->dbg_params.engine_for_debug];
+	struct qed_dbg_feature *qed_feature = &cdev->dbg_features[feature];
 	struct qed_ptt *p_ptt = qed_ptt_acquire(p_hwfn);
-	struct qed_dbg_feature *qed_feature =
-		&cdev->dbg_params.features[feature];
 	u32 buf_size_dwords;
 	enum dbg_status rc;
 
@@ -8843,14 +8141,21 @@ void qed_set_debug_engine(struct qed_dev *cdev, int engine_number)
 
 void qed_dbg_pf_init(struct qed_dev *cdev)
 {
-	const u8 *dbg_values;
+	const u8 *dbg_values = NULL;
+	int i;
 
 	/* Debug values are after init values.
 	 * The offset is the first dword of the file.
 	 */
 	dbg_values = cdev->firmware->data + *(u32 *)cdev->firmware->data;
-	qed_dbg_set_bin_ptr((u8 *)dbg_values);
-	qed_dbg_user_set_bin_ptr((u8 *)dbg_values);
+
+	for_each_hwfn(cdev, i) {
+		qed_dbg_set_bin_ptr(&cdev->hwfns[i], dbg_values);
+		qed_dbg_user_set_bin_ptr(&cdev->hwfns[i], dbg_values);
+	}
+
+	/* Set the hwfn to be 0 as default */
+	cdev->dbg_params.engine_for_debug = 0;
 }
 
 void qed_dbg_pf_exit(struct qed_dev *cdev)
@@ -8858,14 +8163,23 @@ void qed_dbg_pf_exit(struct qed_dev *cdev)
 	struct qed_dbg_feature *feature = NULL;
 	enum qed_dbg_features feature_idx;
 
-	/* Debug features' buffers may be allocated if debug feature was used
-	 * but dump wasn't called.
+	/* debug features' buffers may be allocated if debug feature was used
+	 * but dump wasn't called
 	 */
 	for (feature_idx = 0; feature_idx < DBG_FEATURE_NUM; feature_idx++) {
-		feature = &cdev->dbg_params.features[feature_idx];
+		feature = &cdev->dbg_features[feature_idx];
 		if (feature->dump_buf) {
 			vfree(feature->dump_buf);
 			feature->dump_buf = NULL;
 		}
 	}
 }
+
+void qed_set_platform_str_linux(struct qed_hwfn *p_hwfn,
+				char *buf_str, u32 buf_size)
+{
+	snprintf(buf_str, buf_size, "Kernel %d.%d.%d.",
+		 (LINUX_VERSION_CODE & 0xf0000) >> 16,
+		 (LINUX_VERSION_CODE & 0x0ff00) >> 8,
+		 (LINUX_VERSION_CODE & 0x000ff));
+}
diff --git a/drivers/net/ethernet/qlogic/qed/qed_debug.h b/drivers/net/ethernet/qlogic/qed/qed_debug.h
index edf99d296bd1..935b1ce04682 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_debug.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_debug.h
@@ -52,6 +52,8 @@ int qed_dbg_feature(struct qed_dev *cdev, void *buffer,
 		    enum qed_dbg_features feature, u32 *num_dumped_bytes);
 int qed_dbg_feature_size(struct qed_dev *cdev, enum qed_dbg_features feature);
 
+void qed_set_platform_str_linux(struct qed_hwfn *p_hwfn, char *buf_str,
+				u32 buf_size);
 void qed_dbg_pf_init(struct qed_dev *cdev);
 void qed_dbg_pf_exit(struct qed_dev *cdev);
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index 3fb73ce8c1d6..8bd101806acb 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -2346,7 +2346,7 @@ int qed_resc_alloc(struct qed_dev *cdev)
 		if (rc)
 			goto alloc_err;
 
-		rc = qed_dbg_alloc_user_data(p_hwfn);
+		rc = qed_dbg_alloc_user_data(p_hwfn, &p_hwfn->dbg_user_info);
 		if (rc)
 			goto alloc_err;
 	}
@@ -5519,3 +5519,15 @@ void qed_set_fw_mac_addr(__le16 *fw_msb,
 	((u8 *)fw_lsb)[0] = mac[5];
 	((u8 *)fw_lsb)[1] = mac[4];
 }
+
+void qed_set_platform_str(struct qed_hwfn *p_hwfn, char *buf_str, u32 buf_size)
+{
+	u32 len;
+
+	snprintf(buf_str, buf_size, "QED %d.%d.%d.%d. ",
+		 QED_MAJOR_VERSION, QED_MINOR_VERSION,
+		 QED_REVISION_VERSION, QED_ENGINEERING_VERSION);
+
+	len = strlen(buf_str);
+	qed_set_platform_str_linux(p_hwfn, &buf_str[len], buf_size - len);
+}
diff --git a/drivers/net/ethernet/qlogic/qed/qed_hsi.h b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
index af4e4d535fed..91cdb7c190dc 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_hsi.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
@@ -1860,98 +1860,6 @@ struct virt_mem_desc {
 /* Debug Tools HSI constants and macros */
 /****************************************/
 
-enum block_addr {
-	GRCBASE_GRC = 0x50000,
-	GRCBASE_MISCS = 0x9000,
-	GRCBASE_MISC = 0x8000,
-	GRCBASE_DBU = 0xa000,
-	GRCBASE_PGLUE_B = 0x2a8000,
-	GRCBASE_CNIG = 0x218000,
-	GRCBASE_CPMU = 0x30000,
-	GRCBASE_NCSI = 0x40000,
-	GRCBASE_OPTE = 0x53000,
-	GRCBASE_BMB = 0x540000,
-	GRCBASE_PCIE = 0x54000,
-	GRCBASE_MCP = 0xe00000,
-	GRCBASE_MCP2 = 0x52000,
-	GRCBASE_PSWHST = 0x2a0000,
-	GRCBASE_PSWHST2 = 0x29e000,
-	GRCBASE_PSWRD = 0x29c000,
-	GRCBASE_PSWRD2 = 0x29d000,
-	GRCBASE_PSWWR = 0x29a000,
-	GRCBASE_PSWWR2 = 0x29b000,
-	GRCBASE_PSWRQ = 0x280000,
-	GRCBASE_PSWRQ2 = 0x240000,
-	GRCBASE_PGLCS = 0x0,
-	GRCBASE_DMAE = 0xc000,
-	GRCBASE_PTU = 0x560000,
-	GRCBASE_TCM = 0x1180000,
-	GRCBASE_MCM = 0x1200000,
-	GRCBASE_UCM = 0x1280000,
-	GRCBASE_XCM = 0x1000000,
-	GRCBASE_YCM = 0x1080000,
-	GRCBASE_PCM = 0x1100000,
-	GRCBASE_QM = 0x2f0000,
-	GRCBASE_TM = 0x2c0000,
-	GRCBASE_DORQ = 0x100000,
-	GRCBASE_BRB = 0x340000,
-	GRCBASE_SRC = 0x238000,
-	GRCBASE_PRS = 0x1f0000,
-	GRCBASE_TSDM = 0xfb0000,
-	GRCBASE_MSDM = 0xfc0000,
-	GRCBASE_USDM = 0xfd0000,
-	GRCBASE_XSDM = 0xf80000,
-	GRCBASE_YSDM = 0xf90000,
-	GRCBASE_PSDM = 0xfa0000,
-	GRCBASE_TSEM = 0x1700000,
-	GRCBASE_MSEM = 0x1800000,
-	GRCBASE_USEM = 0x1900000,
-	GRCBASE_XSEM = 0x1400000,
-	GRCBASE_YSEM = 0x1500000,
-	GRCBASE_PSEM = 0x1600000,
-	GRCBASE_RSS = 0x238800,
-	GRCBASE_TMLD = 0x4d0000,
-	GRCBASE_MULD = 0x4e0000,
-	GRCBASE_YULD = 0x4c8000,
-	GRCBASE_XYLD = 0x4c0000,
-	GRCBASE_PTLD = 0x5a0000,
-	GRCBASE_YPLD = 0x5c0000,
-	GRCBASE_PRM = 0x230000,
-	GRCBASE_PBF_PB1 = 0xda0000,
-	GRCBASE_PBF_PB2 = 0xda4000,
-	GRCBASE_RPB = 0x23c000,
-	GRCBASE_BTB = 0xdb0000,
-	GRCBASE_PBF = 0xd80000,
-	GRCBASE_RDIF = 0x300000,
-	GRCBASE_TDIF = 0x310000,
-	GRCBASE_CDU = 0x580000,
-	GRCBASE_CCFC = 0x2e0000,
-	GRCBASE_TCFC = 0x2d0000,
-	GRCBASE_IGU = 0x180000,
-	GRCBASE_CAU = 0x1c0000,
-	GRCBASE_RGFS = 0xf00000,
-	GRCBASE_RGSRC = 0x320000,
-	GRCBASE_TGFS = 0xd00000,
-	GRCBASE_TGSRC = 0x322000,
-	GRCBASE_UMAC = 0x51000,
-	GRCBASE_XMAC = 0x210000,
-	GRCBASE_DBG = 0x10000,
-	GRCBASE_NIG = 0x500000,
-	GRCBASE_WOL = 0x600000,
-	GRCBASE_BMBN = 0x610000,
-	GRCBASE_IPC = 0x20000,
-	GRCBASE_NWM = 0x800000,
-	GRCBASE_NWS = 0x700000,
-	GRCBASE_MS = 0x6a0000,
-	GRCBASE_PHY_PCIE = 0x620000,
-	GRCBASE_LED = 0x6b8000,
-	GRCBASE_AVS_WRAP = 0x6b0000,
-	GRCBASE_PXPREQBUS = 0x56000,
-	GRCBASE_MISC_AEU = 0x8000,
-	GRCBASE_BAR0_MAP = 0x1c00000,
-	MAX_BLOCK_ADDR
-};
-
 enum block_id {
 	BLOCK_GRC,
 	BLOCK_MISCS,
@@ -2006,8 +1914,6 @@ enum block_id {
 	BLOCK_MULD,
 	BLOCK_YULD,
 	BLOCK_XYLD,
-	BLOCK_PTLD,
-	BLOCK_YPLD,
 	BLOCK_PRM,
 	BLOCK_PBF_PB1,
 	BLOCK_PBF_PB2,
@@ -2021,12 +1927,9 @@ enum block_id {
 	BLOCK_TCFC,
 	BLOCK_IGU,
 	BLOCK_CAU,
-	BLOCK_RGFS,
-	BLOCK_RGSRC,
-	BLOCK_TGFS,
-	BLOCK_TGSRC,
 	BLOCK_UMAC,
 	BLOCK_XMAC,
+	BLOCK_MSTAT,
 	BLOCK_DBG,
 	BLOCK_NIG,
 	BLOCK_WOL,
@@ -2039,8 +1942,17 @@ enum block_id {
 	BLOCK_LED,
 	BLOCK_AVS_WRAP,
 	BLOCK_PXPREQBUS,
-	BLOCK_MISC_AEU,
 	BLOCK_BAR0_MAP,
+	BLOCK_MCP_FIO,
+	BLOCK_LAST_INIT,
+	BLOCK_PRS_FC,
+	BLOCK_PBF_FC,
+	BLOCK_NIG_LB_FC,
+	BLOCK_NIG_LB_FC_PLLH,
+	BLOCK_NIG_TX_FC_PLLH,
+	BLOCK_NIG_TX_FC,
+	BLOCK_NIG_RX_FC_PLLH,
+	BLOCK_NIG_RX_FC,
 	MAX_BLOCK_ID
 };
 
@@ -2057,10 +1969,13 @@ enum bin_dbg_buffer_type {
 	BIN_BUF_DBG_ATTN_REGS,
 	BIN_BUF_DBG_ATTN_INDEXES,
 	BIN_BUF_DBG_ATTN_NAME_OFFSETS,
-	BIN_BUF_DBG_BUS_BLOCKS,
+	BIN_BUF_DBG_BLOCKS,
+	BIN_BUF_DBG_BLOCKS_CHIP_DATA,
 	BIN_BUF_DBG_BUS_LINES,
-	BIN_BUF_DBG_BUS_BLOCKS_USER_DATA,
+	BIN_BUF_DBG_BLOCKS_USER_DATA,
+	BIN_BUF_DBG_BLOCKS_CHIP_USER_DATA,
 	BIN_BUF_DBG_BUS_LINE_NAME_OFFSETS,
+	BIN_BUF_DBG_RESET_REGS,
 	BIN_BUF_DBG_PARSING_STRINGS,
 	MAX_BIN_DBG_BUFFER_TYPE
 };
@@ -2144,20 +2059,54 @@ enum dbg_attn_type {
 	MAX_DBG_ATTN_TYPE
 };
 
-/* Debug Bus block data */
-struct dbg_bus_block {
-	u8 num_of_lines;
-	u8 has_latency_events;
-	u16 lines_offset;
+/* Block debug data */
+struct dbg_block {
+	u8 name[15];
+	u8 associated_storm_letter;
 };
 
-/* Debug Bus block user data */
-struct dbg_bus_block_user_data {
-	u8 num_of_lines;
+/* Chip-specific block debug data */
+struct dbg_block_chip {
+	u8 flags;
+#define DBG_BLOCK_CHIP_IS_REMOVED_MASK		 0x1
+#define DBG_BLOCK_CHIP_IS_REMOVED_SHIFT		 0
+#define DBG_BLOCK_CHIP_HAS_RESET_REG_MASK	 0x1
+#define DBG_BLOCK_CHIP_HAS_RESET_REG_SHIFT	 1
+#define DBG_BLOCK_CHIP_UNRESET_BEFORE_DUMP_MASK  0x1
+#define DBG_BLOCK_CHIP_UNRESET_BEFORE_DUMP_SHIFT 2
+#define DBG_BLOCK_CHIP_HAS_DBG_BUS_MASK		 0x1
+#define DBG_BLOCK_CHIP_HAS_DBG_BUS_SHIFT	 3
+#define DBG_BLOCK_CHIP_HAS_LATENCY_EVENTS_MASK	 0x1
+#define DBG_BLOCK_CHIP_HAS_LATENCY_EVENTS_SHIFT  4
+#define DBG_BLOCK_CHIP_RESERVED0_MASK		 0x7
+#define DBG_BLOCK_CHIP_RESERVED0_SHIFT		 5
+	u8 dbg_client_id;
+	u8 reset_reg_id;
+	u8 reset_reg_bit_offset;
+	struct dbg_mode_hdr dbg_bus_mode;
+	u16 reserved1;
+	u8 reserved2;
+	u8 num_of_dbg_bus_lines;
+	u16 dbg_bus_lines_offset;
+	u32 dbg_select_reg_addr;
+	u32 dbg_dword_enable_reg_addr;
+	u32 dbg_shift_reg_addr;
+	u32 dbg_force_valid_reg_addr;
+	u32 dbg_force_frame_reg_addr;
+};
+
+/* Chip-specific block user debug data */
+struct dbg_block_chip_user {
+	u8 num_of_dbg_bus_lines;
 	u8 has_latency_events;
 	u16 names_offset;
 };
 
+/* Block user debug data */
+struct dbg_block_user {
+	u8 name[16];
+};
+
 /* Block Debug line data */
 struct dbg_bus_line {
 	u8 data;
@@ -2310,22 +2259,33 @@ enum dbg_idle_chk_severity_types {
 	MAX_DBG_IDLE_CHK_SEVERITY_TYPES
 };
 
+/* Reset register */
+struct dbg_reset_reg {
+	u32 data;
+#define DBG_RESET_REG_ADDR_MASK        0xFFFFFF
+#define DBG_RESET_REG_ADDR_SHIFT       0
+#define DBG_RESET_REG_IS_REMOVED_MASK  0x1
+#define DBG_RESET_REG_IS_REMOVED_SHIFT 24
+#define DBG_RESET_REG_RESERVED_MASK    0x7F
+#define DBG_RESET_REG_RESERVED_SHIFT   25
+};
+
 /* Debug Bus block data */
 struct dbg_bus_block_data {
-	u16 data;
-#define DBG_BUS_BLOCK_DATA_ENABLE_MASK_MASK		0xF
-#define DBG_BUS_BLOCK_DATA_ENABLE_MASK_SHIFT		0
-#define DBG_BUS_BLOCK_DATA_RIGHT_SHIFT_MASK		0xF
-#define DBG_BUS_BLOCK_DATA_RIGHT_SHIFT_SHIFT		4
-#define DBG_BUS_BLOCK_DATA_FORCE_VALID_MASK_MASK	0xF
-#define DBG_BUS_BLOCK_DATA_FORCE_VALID_MASK_SHIFT	8
-#define DBG_BUS_BLOCK_DATA_FORCE_FRAME_MASK_MASK	0xF
-#define DBG_BUS_BLOCK_DATA_FORCE_FRAME_MASK_SHIFT	12
+	u8 enable_mask;
+	u8 right_shift;
+	u8 force_valid_mask;
+	u8 force_frame_mask;
+	u8 dword_mask;
 	u8 line_num;
 	u8 hw_id;
+	u8 flags;
+#define DBG_BUS_BLOCK_DATA_IS_256B_LINE_MASK  0x1
+#define DBG_BUS_BLOCK_DATA_IS_256B_LINE_SHIFT 0
+#define DBG_BUS_BLOCK_DATA_RESERVED_MASK      0x7F
+#define DBG_BUS_BLOCK_DATA_RESERVED_SHIFT     1
 };
 
-/* Debug Bus Clients */
 enum dbg_bus_clients {
 	DBG_BUS_CLIENT_RBCN,
 	DBG_BUS_CLIENT_RBCP,
@@ -2366,11 +2326,10 @@ enum dbg_bus_constraint_ops {
 
 /* Debug Bus trigger state data */
 struct dbg_bus_trigger_state_data {
-	u8 data;
-#define DBG_BUS_TRIGGER_STATE_DATA_BLOCK_SHIFTED_ENABLE_MASK_MASK	0xF
-#define DBG_BUS_TRIGGER_STATE_DATA_BLOCK_SHIFTED_ENABLE_MASK_SHIFT	0
-#define DBG_BUS_TRIGGER_STATE_DATA_CONSTRAINT_DWORD_MASK_MASK		0xF
-#define DBG_BUS_TRIGGER_STATE_DATA_CONSTRAINT_DWORD_MASK_SHIFT		4
+	u8 msg_len;
+	u8 constraint_dword_mask;
+	u8 storm_id;
+	u8 reserved;
 };
 
 /* Debug Bus memory address */
@@ -2420,8 +2379,7 @@ struct dbg_bus_storm_data {
 struct dbg_bus_data {
 	u32 app_version;
 	u8 state;
-	u8 hw_dwords;
-	u16 hw_id_mask;
+	u8 mode_256b_en;
 	u8 num_enabled_blocks;
 	u8 num_enabled_storms;
 	u8 target;
@@ -2432,67 +2390,21 @@ struct dbg_bus_data {
 	u8 adding_filter;
 	u8 filter_pre_trigger;
 	u8 filter_post_trigger;
-	u16 reserved;
 	u8 trigger_en;
-	struct dbg_bus_trigger_state_data trigger_states[3];
+	u8 filter_constraint_dword_mask;
 	u8 next_trigger_state;
 	u8 next_constraint_id;
-	u8 unify_inputs;
+	struct dbg_bus_trigger_state_data trigger_states[3];
+	u8 filter_msg_len;
 	u8 rcv_from_other_engine;
+	u8 blocks_dword_mask;
+	u8 blocks_dword_overlap;
+	u32 hw_id_mask;
 	struct dbg_bus_pci_buf_data pci_buf;
-	struct dbg_bus_block_data blocks[88];
+	struct dbg_bus_block_data blocks[132];
 	struct dbg_bus_storm_data storms[6];
 };
 
-/* Debug bus filter types */
-enum dbg_bus_filter_types {
-	DBG_BUS_FILTER_TYPE_OFF,
-	DBG_BUS_FILTER_TYPE_PRE,
-	DBG_BUS_FILTER_TYPE_POST,
-	DBG_BUS_FILTER_TYPE_ON,
-	MAX_DBG_BUS_FILTER_TYPES
-};
-
-/* Debug bus frame modes */
-enum dbg_bus_frame_modes {
-	DBG_BUS_FRAME_MODE_0HW_4ST = 0, /* 0 HW dwords, 4 Storm dwords */
-	DBG_BUS_FRAME_MODE_4HW_0ST = 3, /* 4 HW dwords, 0 Storm dwords */
-	DBG_BUS_FRAME_MODE_8HW_0ST = 4, /* 8 HW dwords, 0 Storm dwords */
-	MAX_DBG_BUS_FRAME_MODES
-};
-
-/* Debug bus other engine mode */
-enum dbg_bus_other_engine_modes {
-	DBG_BUS_OTHER_ENGINE_MODE_NONE,
-	DBG_BUS_OTHER_ENGINE_MODE_DOUBLE_BW_TX,
-	DBG_BUS_OTHER_ENGINE_MODE_DOUBLE_BW_RX,
-	DBG_BUS_OTHER_ENGINE_MODE_CROSS_ENGINE_TX,
-	DBG_BUS_OTHER_ENGINE_MODE_CROSS_ENGINE_RX,
-	MAX_DBG_BUS_OTHER_ENGINE_MODES
-};
-
-/* Debug bus post-trigger recording types */
-enum dbg_bus_post_trigger_types {
-	DBG_BUS_POST_TRIGGER_RECORD,
-	DBG_BUS_POST_TRIGGER_DROP,
-	MAX_DBG_BUS_POST_TRIGGER_TYPES
-};
-
-/* Debug bus pre-trigger recording types */
-enum dbg_bus_pre_trigger_types {
-	DBG_BUS_PRE_TRIGGER_START_FROM_ZERO,
-	DBG_BUS_PRE_TRIGGER_NUM_CHUNKS,
-	DBG_BUS_PRE_TRIGGER_DROP,
-	MAX_DBG_BUS_PRE_TRIGGER_TYPES
-};
-
-/* Debug bus SEMI frame modes */
-enum dbg_bus_semi_frame_modes {
-	DBG_BUS_SEMI_FRAME_MODE_0SLOW_4FAST = 0,
-	DBG_BUS_SEMI_FRAME_MODE_4SLOW_0FAST = 3,
-	MAX_DBG_BUS_SEMI_FRAME_MODES
-};
-
 /* Debug bus states */
 enum dbg_bus_states {
 	DBG_BUS_STATE_IDLE,
@@ -2510,7 +2422,9 @@ enum dbg_bus_storm_modes {
 	DBG_BUS_STORM_MODE_DRA_W,
 	DBG_BUS_STORM_MODE_LD_ST_ADDR,
 	DBG_BUS_STORM_MODE_DRA_FSM,
+	DBG_BUS_STORM_MODE_FAST_DBGMUX,
 	DBG_BUS_STORM_MODE_RH,
+	DBG_BUS_STORM_MODE_RH_WITH_STORE,
 	DBG_BUS_STORM_MODE_FOC,
 	DBG_BUS_STORM_MODE_EXT_STORE,
 	MAX_DBG_BUS_STORM_MODES
@@ -2551,13 +2465,13 @@ enum dbg_grc_params {
 	DBG_GRC_PARAM_DUMP_CAU,
 	DBG_GRC_PARAM_DUMP_QM,
 	DBG_GRC_PARAM_DUMP_MCP,
-	DBG_GRC_PARAM_MCP_TRACE_META_SIZE,
+	DBG_GRC_PARAM_DUMP_DORQ,
 	DBG_GRC_PARAM_DUMP_CFC,
 	DBG_GRC_PARAM_DUMP_IGU,
 	DBG_GRC_PARAM_DUMP_BRB,
 	DBG_GRC_PARAM_DUMP_BTB,
 	DBG_GRC_PARAM_DUMP_BMB,
-	DBG_GRC_PARAM_DUMP_NIG,
+	DBG_GRC_PARAM_RESERVD1,
 	DBG_GRC_PARAM_DUMP_MULD,
 	DBG_GRC_PARAM_DUMP_PRS,
 	DBG_GRC_PARAM_DUMP_DMAE,
@@ -2566,8 +2480,8 @@ enum dbg_grc_params {
 	DBG_GRC_PARAM_DUMP_DIF,
 	DBG_GRC_PARAM_DUMP_STATIC,
 	DBG_GRC_PARAM_UNSTALL,
-	DBG_GRC_PARAM_NUM_LCIDS,
-	DBG_GRC_PARAM_NUM_LTIDS,
+	DBG_GRC_PARAM_RESERVED2,
+	DBG_GRC_PARAM_MCP_TRACE_META_SIZE,
 	DBG_GRC_PARAM_EXCLUDE_ALL,
 	DBG_GRC_PARAM_CRASH,
 	DBG_GRC_PARAM_PARITY_SAFE,
@@ -2583,19 +2497,6 @@ enum dbg_grc_params {
 	MAX_DBG_GRC_PARAMS
 };
 
-/* Debug reset registers */
-enum dbg_reset_regs {
-	DBG_RESET_REG_MISCS_PL_UA,
-	DBG_RESET_REG_MISCS_PL_HV,
-	DBG_RESET_REG_MISCS_PL_HV_2,
-	DBG_RESET_REG_MISC_PL_UA,
-	DBG_RESET_REG_MISC_PL_HV,
-	DBG_RESET_REG_MISC_PL_PDA_VMAIN_1,
-	DBG_RESET_REG_MISC_PL_PDA_VMAIN_2,
-	DBG_RESET_REG_MISC_PL_PDA_VAUX,
-	MAX_DBG_RESET_REGS
-};
-
 /* Debug status codes */
 enum dbg_status {
 	DBG_STATUS_OK,
@@ -2607,15 +2508,15 @@ enum dbg_status {
 	DBG_STATUS_INVALID_PCI_BUF_SIZE,
 	DBG_STATUS_PCI_BUF_ALLOC_FAILED,
 	DBG_STATUS_PCI_BUF_NOT_ALLOCATED,
-	DBG_STATUS_TOO_MANY_INPUTS,
-	DBG_STATUS_INPUT_OVERLAP,
-	DBG_STATUS_HW_ONLY_RECORDING,
+	DBG_STATUS_INVALID_FILTER_TRIGGER_DWORDS,
+	DBG_STATUS_NO_MATCHING_FRAMING_MODE,
+	DBG_STATUS_VFC_READ_ERROR,
 	DBG_STATUS_STORM_ALREADY_ENABLED,
 	DBG_STATUS_STORM_NOT_ENABLED,
 	DBG_STATUS_BLOCK_ALREADY_ENABLED,
 	DBG_STATUS_BLOCK_NOT_ENABLED,
 	DBG_STATUS_NO_INPUT_ENABLED,
-	DBG_STATUS_NO_FILTER_TRIGGER_64B,
+	DBG_STATUS_NO_FILTER_TRIGGER_256B,
 	DBG_STATUS_FILTER_ALREADY_ENABLED,
 	DBG_STATUS_TRIGGER_ALREADY_ENABLED,
 	DBG_STATUS_TRIGGER_NOT_ENABLED,
@@ -2640,7 +2541,7 @@ enum dbg_status {
 	DBG_STATUS_MCP_TRACE_NO_META,
 	DBG_STATUS_MCP_COULD_NOT_HALT,
 	DBG_STATUS_MCP_COULD_NOT_RESUME,
-	DBG_STATUS_RESERVED2,
+	DBG_STATUS_RESERVED0,
 	DBG_STATUS_SEMI_FIFO_NOT_EMPTY,
 	DBG_STATUS_IGU_FIFO_BAD_DATA,
 	DBG_STATUS_MCP_COULD_NOT_MASK_PRTY,
@@ -2648,10 +2549,15 @@ enum dbg_status {
 	DBG_STATUS_REG_FIFO_BAD_DATA,
 	DBG_STATUS_PROTECTION_OVERRIDE_BAD_DATA,
 	DBG_STATUS_DBG_ARRAY_NOT_SET,
-	DBG_STATUS_FILTER_BUG,
+	DBG_STATUS_RESERVED1,
 	DBG_STATUS_NON_MATCHING_LINES,
-	DBG_STATUS_INVALID_TRIGGER_DWORD_OFFSET,
+	DBG_STATUS_INSUFFICIENT_HW_IDS,
 	DBG_STATUS_DBG_BUS_IN_USE,
+	DBG_STATUS_INVALID_STORM_DBG_MODE,
+	DBG_STATUS_OTHER_ENGINE_BB_ONLY,
+	DBG_STATUS_FILTER_SINGLE_HW_ID,
+	DBG_STATUS_TRIGGER_SINGLE_HW_ID,
+	DBG_STATUS_MISSING_TRIGGER_STATE_STORM,
 	MAX_DBG_STATUS
 };
 
@@ -2687,9 +2593,9 @@ struct dbg_tools_data {
 	struct dbg_bus_data bus;
 	struct idle_chk_data idle_chk;
 	u8 mode_enable[40];
-	u8 block_in_reset[88];
+	u8 block_in_reset[132];
 	u8 chip_id;
-	u8 platform_id;
+	u8 hw_type;
 	u8 num_ports;
 	u8 num_pfs_per_port;
 	u8 num_vfs;
@@ -2808,7 +2714,6 @@ struct init_qm_vport_params {
 enum chip_ids {
 	CHIP_BB,
 	CHIP_K2,
-	CHIP_RESERVED,
 	MAX_CHIP_IDS
 };
 
@@ -3135,9 +3040,11 @@ struct iro {
  * @brief qed_dbg_set_bin_ptr - Sets a pointer to the binary data with debug
  *	arrays.
  *
+ * @param p_hwfn -	    HW device data
  * @param bin_ptr - a pointer to the binary data with debug arrays.
  */
-enum dbg_status qed_dbg_set_bin_ptr(const u8 * const bin_ptr);
+enum dbg_status qed_dbg_set_bin_ptr(struct qed_hwfn *p_hwfn,
+				    const u8 * const bin_ptr);
 
 /**
  * @brief qed_read_regs - Reads registers into a buffer (using GRC).
@@ -3181,7 +3088,6 @@ bool qed_read_fw_info(struct qed_hwfn *p_hwfn,
  *	- val is outside the allowed boundaries
  */
 enum dbg_status qed_dbg_grc_config(struct qed_hwfn *p_hwfn,
-				   struct qed_ptt *p_ptt,
 				   enum dbg_grc_params grc_param, u32 val);
 
 /**
@@ -3502,20 +3408,36 @@ enum dbg_status qed_dbg_print_attn(struct qed_hwfn *p_hwfn,
 struct mcp_trace_format {
 	u32 data;
 #define MCP_TRACE_FORMAT_MODULE_MASK	0x0000ffff
-#define MCP_TRACE_FORMAT_MODULE_SHIFT	0
+#define MCP_TRACE_FORMAT_MODULE_OFFSET	0
 #define MCP_TRACE_FORMAT_LEVEL_MASK	0x00030000
-#define MCP_TRACE_FORMAT_LEVEL_SHIFT	16
+#define MCP_TRACE_FORMAT_LEVEL_OFFSET	16
 #define MCP_TRACE_FORMAT_P1_SIZE_MASK	0x000c0000
-#define MCP_TRACE_FORMAT_P1_SIZE_SHIFT	18
+#define MCP_TRACE_FORMAT_P1_SIZE_OFFSET 18
 #define MCP_TRACE_FORMAT_P2_SIZE_MASK	0x00300000
-#define MCP_TRACE_FORMAT_P2_SIZE_SHIFT	20
+#define MCP_TRACE_FORMAT_P2_SIZE_OFFSET 20
 #define MCP_TRACE_FORMAT_P3_SIZE_MASK	0x00c00000
-#define MCP_TRACE_FORMAT_P3_SIZE_SHIFT	22
+#define MCP_TRACE_FORMAT_P3_SIZE_OFFSET 22
 #define MCP_TRACE_FORMAT_LEN_MASK	0xff000000
-#define MCP_TRACE_FORMAT_LEN_SHIFT	24
+#define MCP_TRACE_FORMAT_LEN_OFFSET	24
+
 	char *format_str;
 };
 
+/* MCP Trace Meta data structure */
+struct mcp_trace_meta {
+	u32 modules_num;
+	char **modules;
+	u32 formats_num;
+	struct mcp_trace_format *formats;
+	bool is_allocated;
+};
+
+/* Debug Tools user data */
+struct dbg_tools_user_data {
+	struct mcp_trace_meta mcp_trace_meta;
+	const u32 *mcp_trace_user_meta_buf;
+};
+
 /******************************** Constants **********************************/
 
 #define MAX_NAME_LEN	16
@@ -3526,16 +3448,20 @@ struct mcp_trace_format {
  * @brief qed_dbg_user_set_bin_ptr - Sets a pointer to the binary data with
  *	debug arrays.
  *
+ * @param p_hwfn - HW device data
  * @param bin_ptr - a pointer to the binary data with debug arrays.
  */
-enum dbg_status qed_dbg_user_set_bin_ptr(const u8 * const bin_ptr);
+enum dbg_status qed_dbg_user_set_bin_ptr(struct qed_hwfn *p_hwfn,
+					 const u8 * const bin_ptr);
 
 /**
  * @brief qed_dbg_alloc_user_data - Allocates user debug data.
  *
  * @param p_hwfn -		 HW device data
+ * @param user_data_ptr - OUT: a pointer to the allocated memory.
  */
-enum dbg_status qed_dbg_alloc_user_data(struct qed_hwfn *p_hwfn);
+enum dbg_status qed_dbg_alloc_user_data(struct qed_hwfn *p_hwfn,
+					void **user_data_ptr);
 
 /**
  * @brief qed_dbg_get_status_str - Returns a string for the specified status.
@@ -3808,271 +3734,6 @@ enum dbg_status qed_print_fw_asserts_results(struct qed_hwfn *p_hwfn,
 enum dbg_status qed_dbg_parse_attn(struct qed_hwfn *p_hwfn,
 				   struct dbg_attn_block_result *results);
 
-/* Debug Bus blocks */
-static const u32 dbg_bus_blocks[] = {
-	0x0000000f,		/* grc, bb, 15 lines */
-	0x0000000f,		/* grc, k2, 15 lines */
-	0x00000000,
-	0x00000000,		/* miscs, bb, 0 lines */
-	0x00000000,		/* miscs, k2, 0 lines */
-	0x00000000,
-	0x00000000,		/* misc, bb, 0 lines */
-	0x00000000,		/* misc, k2, 0 lines */
-	0x00000000,
-	0x00000000,		/* dbu, bb, 0 lines */
-	0x00000000,		/* dbu, k2, 0 lines */
-	0x00000000,
-	0x000f0127,		/* pglue_b, bb, 39 lines */
-	0x0036012a,		/* pglue_b, k2, 42 lines */
-	0x00000000,
-	0x00000000,		/* cnig, bb, 0 lines */
-	0x00120102,		/* cnig, k2, 2 lines */
-	0x00000000,
-	0x00000000,		/* cpmu, bb, 0 lines */
-	0x00000000,		/* cpmu, k2, 0 lines */
-	0x00000000,
-	0x00000001,		/* ncsi, bb, 1 lines */
-	0x00000001,		/* ncsi, k2, 1 lines */
-	0x00000000,
-	0x00000000,		/* opte, bb, 0 lines */
-	0x00000000,		/* opte, k2, 0 lines */
-	0x00000000,
-	0x00600085,		/* bmb, bb, 133 lines */
-	0x00600085,		/* bmb, k2, 133 lines */
-	0x00000000,
-	0x00000000,		/* pcie, bb, 0 lines */
-	0x00e50033,		/* pcie, k2, 51 lines */
-	0x00000000,
-	0x00000000,		/* mcp, bb, 0 lines */
-	0x00000000,		/* mcp, k2, 0 lines */
-	0x00000000,
-	0x01180009,		/* mcp2, bb, 9 lines */
-	0x01180009,		/* mcp2, k2, 9 lines */
-	0x00000000,
-	0x01210104,		/* pswhst, bb, 4 lines */
-	0x01210104,		/* pswhst, k2, 4 lines */
-	0x00000000,
-	0x01250103,		/* pswhst2, bb, 3 lines */
-	0x01250103,		/* pswhst2, k2, 3 lines */
-	0x00000000,
-	0x00340101,		/* pswrd, bb, 1 lines */
-	0x00340101,		/* pswrd, k2, 1 lines */
-	0x00000000,
-	0x01280119,		/* pswrd2, bb, 25 lines */
-	0x01280119,		/* pswrd2, k2, 25 lines */
-	0x00000000,
-	0x01410109,		/* pswwr, bb, 9 lines */
-	0x01410109,		/* pswwr, k2, 9 lines */
-	0x00000000,
-	0x00000000,		/* pswwr2, bb, 0 lines */
-	0x00000000,		/* pswwr2, k2, 0 lines */
-	0x00000000,
-	0x001c0001,		/* pswrq, bb, 1 lines */
-	0x001c0001,		/* pswrq, k2, 1 lines */
-	0x00000000,
-	0x014a0015,		/* pswrq2, bb, 21 lines */
-	0x014a0015,		/* pswrq2, k2, 21 lines */
-	0x00000000,
-	0x00000000,		/* pglcs, bb, 0 lines */
-	0x00120006,		/* pglcs, k2, 6 lines */
-	0x00000000,
-	0x00100001,		/* dmae, bb, 1 lines */
-	0x00100001,		/* dmae, k2, 1 lines */
-	0x00000000,
-	0x015f0105,		/* ptu, bb, 5 lines */
-	0x015f0105,		/* ptu, k2, 5 lines */
-	0x00000000,
-	0x01640120,		/* tcm, bb, 32 lines */
-	0x01640120,		/* tcm, k2, 32 lines */
-	0x00000000,
-	0x01640120,		/* mcm, bb, 32 lines */
-	0x01640120,		/* mcm, k2, 32 lines */
-	0x00000000,
-	0x01640120,		/* ucm, bb, 32 lines */
-	0x01640120,		/* ucm, k2, 32 lines */
-	0x00000000,
-	0x01640120,		/* xcm, bb, 32 lines */
-	0x01640120,		/* xcm, k2, 32 lines */
-	0x00000000,
-	0x01640120,		/* ycm, bb, 32 lines */
-	0x01640120,		/* ycm, k2, 32 lines */
-	0x00000000,
-	0x01640120,		/* pcm, bb, 32 lines */
-	0x01640120,		/* pcm, k2, 32 lines */
-	0x00000000,
-	0x01840062,		/* qm, bb, 98 lines */
-	0x01840062,		/* qm, k2, 98 lines */
-	0x00000000,
-	0x01e60021,		/* tm, bb, 33 lines */
-	0x01e60021,		/* tm, k2, 33 lines */
-	0x00000000,
-	0x02070107,		/* dorq, bb, 7 lines */
-	0x02070107,		/* dorq, k2, 7 lines */
-	0x00000000,
-	0x00600185,		/* brb, bb, 133 lines */
-	0x00600185,		/* brb, k2, 133 lines */
-	0x00000000,
-	0x020e0019,		/* src, bb, 25 lines */
-	0x020c001a,		/* src, k2, 26 lines */
-	0x00000000,
-	0x02270104,		/* prs, bb, 4 lines */
-	0x02270104,		/* prs, k2, 4 lines */
-	0x00000000,
-	0x022b0133,		/* tsdm, bb, 51 lines */
-	0x022b0133,		/* tsdm, k2, 51 lines */
-	0x00000000,
-	0x022b0133,		/* msdm, bb, 51 lines */
-	0x022b0133,		/* msdm, k2, 51 lines */
-	0x00000000,
-	0x022b0133,		/* usdm, bb, 51 lines */
-	0x022b0133,		/* usdm, k2, 51 lines */
-	0x00000000,
-	0x022b0133,		/* xsdm, bb, 51 lines */
-	0x022b0133,		/* xsdm, k2, 51 lines */
-	0x00000000,
-	0x022b0133,		/* ysdm, bb, 51 lines */
-	0x022b0133,		/* ysdm, k2, 51 lines */
-	0x00000000,
-	0x022b0133,		/* psdm, bb, 51 lines */
-	0x022b0133,		/* psdm, k2, 51 lines */
-	0x00000000,
-	0x025e010c,		/* tsem, bb, 12 lines */
-	0x025e010c,		/* tsem, k2, 12 lines */
-	0x00000000,
-	0x025e010c,		/* msem, bb, 12 lines */
-	0x025e010c,		/* msem, k2, 12 lines */
-	0x00000000,
-	0x025e010c,		/* usem, bb, 12 lines */
-	0x025e010c,		/* usem, k2, 12 lines */
-	0x00000000,
-	0x025e010c,		/* xsem, bb, 12 lines */
-	0x025e010c,		/* xsem, k2, 12 lines */
-	0x00000000,
-	0x025e010c,		/* ysem, bb, 12 lines */
-	0x025e010c,		/* ysem, k2, 12 lines */
-	0x00000000,
-	0x025e010c,		/* psem, bb, 12 lines */
-	0x025e010c,		/* psem, k2, 12 lines */
-	0x00000000,
-	0x026a000d,		/* rss, bb, 13 lines */
-	0x026a000d,		/* rss, k2, 13 lines */
-	0x00000000,
-	0x02770106,		/* tmld, bb, 6 lines */
-	0x02770106,		/* tmld, k2, 6 lines */
-	0x00000000,
-	0x027d0106,		/* muld, bb, 6 lines */
-	0x027d0106,		/* muld, k2, 6 lines */
-	0x00000000,
-	0x02770005,		/* yuld, bb, 5 lines */
-	0x02770005,		/* yuld, k2, 5 lines */
-	0x00000000,
-	0x02830107,		/* xyld, bb, 7 lines */
-	0x027d0107,		/* xyld, k2, 7 lines */
-	0x00000000,
-	0x00000000,		/* ptld, bb, 0 lines */
-	0x00000000,		/* ptld, k2, 0 lines */
-	0x00000000,
-	0x00000000,		/* ypld, bb, 0 lines */
-	0x00000000,		/* ypld, k2, 0 lines */
-	0x00000000,
-	0x028a010e,		/* prm, bb, 14 lines */
-	0x02980110,		/* prm, k2, 16 lines */
-	0x00000000,
-	0x02a8000d,		/* pbf_pb1, bb, 13 lines */
-	0x02a8000d,		/* pbf_pb1, k2, 13 lines */
-	0x00000000,
-	0x02a8000d,		/* pbf_pb2, bb, 13 lines */
-	0x02a8000d,		/* pbf_pb2, k2, 13 lines */
-	0x00000000,
-	0x02a8000d,		/* rpb, bb, 13 lines */
-	0x02a8000d,		/* rpb, k2, 13 lines */
-	0x00000000,
-	0x00600185,		/* btb, bb, 133 lines */
-	0x00600185,		/* btb, k2, 133 lines */
-	0x00000000,
-	0x02b50117,		/* pbf, bb, 23 lines */
-	0x02b50117,		/* pbf, k2, 23 lines */
-	0x00000000,
-	0x02cc0006,		/* rdif, bb, 6 lines */
-	0x02cc0006,		/* rdif, k2, 6 lines */
-	0x00000000,
-	0x02d20006,		/* tdif, bb, 6 lines */
-	0x02d20006,		/* tdif, k2, 6 lines */
-	0x00000000,
-	0x02d80003,		/* cdu, bb, 3 lines */
-	0x02db000e,		/* cdu, k2, 14 lines */
-	0x00000000,
-	0x02e9010d,		/* ccfc, bb, 13 lines */
-	0x02f60117,		/* ccfc, k2, 23 lines */
-	0x00000000,
-	0x02e9010d,		/* tcfc, bb, 13 lines */
-	0x02f60117,		/* tcfc, k2, 23 lines */
-	0x00000000,
-	0x030d0133,		/* igu, bb, 51 lines */
-	0x030d0133,		/* igu, k2, 51 lines */
-	0x00000000,
-	0x03400106,		/* cau, bb, 6 lines */
-	0x03400106,		/* cau, k2, 6 lines */
-	0x00000000,
-	0x00000000,		/* rgfs, bb, 0 lines */
-	0x00000000,		/* rgfs, k2, 0 lines */
-	0x00000000,
-	0x00000000,		/* rgsrc, bb, 0 lines */
-	0x00000000,		/* rgsrc, k2, 0 lines */
-	0x00000000,
-	0x00000000,		/* tgfs, bb, 0 lines */
-	0x00000000,		/* tgfs, k2, 0 lines */
-	0x00000000,
-	0x00000000,		/* tgsrc, bb, 0 lines */
-	0x00000000,		/* tgsrc, k2, 0 lines */
-	0x00000000,
-	0x00000000,		/* umac, bb, 0 lines */
-	0x00120006,		/* umac, k2, 6 lines */
-	0x00000000,
-	0x00000000,		/* xmac, bb, 0 lines */
-	0x00000000,		/* xmac, k2, 0 lines */
-	0x00000000,
-	0x00000000,		/* dbg, bb, 0 lines */
-	0x00000000,		/* dbg, k2, 0 lines */
-	0x00000000,
-	0x0346012b,		/* nig, bb, 43 lines */
-	0x0346011d,		/* nig, k2, 29 lines */
-	0x00000000,
-	0x00000000,		/* wol, bb, 0 lines */
-	0x001c0002,		/* wol, k2, 2 lines */
-	0x00000000,
-	0x00000000,		/* bmbn, bb, 0 lines */
-	0x00210008,		/* bmbn, k2, 8 lines */
-	0x00000000,
-	0x00000000,		/* ipc, bb, 0 lines */
-	0x00000000,		/* ipc, k2, 0 lines */
-	0x00000000,
-	0x00000000,		/* nwm, bb, 0 lines */
-	0x0371000b,		/* nwm, k2, 11 lines */
-	0x00000000,
-	0x00000000,		/* nws, bb, 0 lines */
-	0x037c0009,		/* nws, k2, 9 lines */
-	0x00000000,
-	0x00000000,		/* ms, bb, 0 lines */
-	0x00120004,		/* ms, k2, 4 lines */
-	0x00000000,
-	0x00000000,		/* phy_pcie, bb, 0 lines */
-	0x00e5001a,		/* phy_pcie, k2, 26 lines */
-	0x00000000,
-	0x00000000,		/* led, bb, 0 lines */
-	0x00000000,		/* led, k2, 0 lines */
-	0x00000000,
-	0x00000000,		/* avs_wrap, bb, 0 lines */
-	0x00000000,		/* avs_wrap, k2, 0 lines */
-	0x00000000,
-	0x00000000,		/* bar0_map, bb, 0 lines */
-	0x00000000,		/* bar0_map, k2, 0 lines */
-	0x00000000,
-	0x00000000,		/* bar0_map, bb, 0 lines */
-	0x00000000,		/* bar0_map, k2, 0 lines */
-	0x00000000,
-};
-
 /* Win 2 */
 #define GTT_BAR0_MAP_REG_IGU_CMD	0x00f000UL
 
@@ -4086,22 +3747,28 @@ static const u32 dbg_bus_blocks[] = {
 #define GTT_BAR0_MAP_REG_MSDM_RAM_1024	0x012000UL
 
 /* Win 6 */
-#define GTT_BAR0_MAP_REG_USDM_RAM	0x013000UL
+#define GTT_BAR0_MAP_REG_MSDM_RAM_2048	0x013000UL
 
 /* Win 7 */
-#define GTT_BAR0_MAP_REG_USDM_RAM_1024	0x014000UL
+#define GTT_BAR0_MAP_REG_USDM_RAM	0x014000UL
 
 /* Win 8 */
-#define GTT_BAR0_MAP_REG_USDM_RAM_2048	0x015000UL
+#define GTT_BAR0_MAP_REG_USDM_RAM_1024	0x015000UL
 
 /* Win 9 */
-#define GTT_BAR0_MAP_REG_XSDM_RAM	0x016000UL
+#define GTT_BAR0_MAP_REG_USDM_RAM_2048	0x016000UL
 
 /* Win 10 */
-#define GTT_BAR0_MAP_REG_YSDM_RAM	0x017000UL
+#define GTT_BAR0_MAP_REG_XSDM_RAM	0x017000UL
 
 /* Win 11 */
-#define GTT_BAR0_MAP_REG_PSDM_RAM	0x018000UL
+#define GTT_BAR0_MAP_REG_XSDM_RAM_1024	0x018000UL
+
+/* Win 12 */
+#define GTT_BAR0_MAP_REG_YSDM_RAM	0x019000UL
+
+/* Win 13 */
+#define GTT_BAR0_MAP_REG_PSDM_RAM	0x01a000UL
 
 /**
  * @brief qed_qm_pf_mem_size - prepare QM ILT sizes
@@ -11914,7 +11581,7 @@ struct e4_ystorm_iscsi_conn_ag_ctx {
 /* The trace in the buffer */
 #define MFW_TRACE_EVENTID_MASK          0x00ffff
 #define MFW_TRACE_PRM_SIZE_MASK         0x0f0000
-#define MFW_TRACE_PRM_SIZE_SHIFT        16
+#define MFW_TRACE_PRM_SIZE_OFFSET	16
 #define MFW_TRACE_ENTRY_SIZE            3
 
 struct mcp_trace {
@@ -12867,7 +12534,10 @@ struct public_drv_mb {
 #define DRV_MB_PARAM_DCBX_NOTIFY_SHIFT		3
 
 #define DRV_MB_PARAM_NVM_PUT_FILE_BEGIN_MBI     0x3
+#define DRV_MB_PARAM_NVM_OFFSET_OFFSET          0
+#define DRV_MB_PARAM_NVM_OFFSET_MASK            0x00FFFFFF
 #define DRV_MB_PARAM_NVM_LEN_OFFSET		24
+#define DRV_MB_PARAM_NVM_LEN_MASK               0xFF000000
 
 #define DRV_MB_PARAM_CFG_VF_MSIX_VF_ID_SHIFT	0
 #define DRV_MB_PARAM_CFG_VF_MSIX_VF_ID_MASK	0x000000FF
@@ -13628,6 +13298,21 @@ enum nvm_image_type {
 	NVM_TYPE_FCOE_CFG = 0x1f,
 	NVM_TYPE_ETH_PHY_FW1 = 0x20,
 	NVM_TYPE_ETH_PHY_FW2 = 0x21,
+	NVM_TYPE_BDN = 0x22,
+	NVM_TYPE_8485X_PHY_FW = 0x23,
+	NVM_TYPE_PUB_KEY = 0x24,
+	NVM_TYPE_RECOVERY = 0x25,
+	NVM_TYPE_PLDM = 0x26,
+	NVM_TYPE_UPK1 = 0x27,
+	NVM_TYPE_UPK2 = 0x28,
+	NVM_TYPE_MASTER_KC = 0x29,
+	NVM_TYPE_BACKUP_KC = 0x2a,
+	NVM_TYPE_HW_DUMP = 0x2b,
+	NVM_TYPE_HW_DUMP_OUT = 0x2c,
+	NVM_TYPE_BIN_NVM_META = 0x30,
+	NVM_TYPE_ROM_TEST = 0xf0,
+	NVM_TYPE_88X33X0_PHY_FW = 0x31,
+	NVM_TYPE_88X33X0_PHY_SLAVE_FW = 0x32,
 	NVM_TYPE_MAX,
 };
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index 38f7f40b3a4d..0fcad4bf667c 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -447,6 +447,11 @@ static void qed_devlink_unregister(struct qed_dev *cdev)
 	devlink_free(cdev->dl);
 }
 
+unsigned long qed_get_epoch_time(void)
+{
+	return ktime_get_real_seconds();
+}
+
 /* probing */
 static struct qed_dev *qed_probe(struct pci_dev *pdev,
 				 struct qed_probe_params *params)
@@ -2637,7 +2642,7 @@ static int qed_set_grc_config(struct qed_dev *cdev, u32 cfg_id, u32 val)
 	if (!ptt)
 		return -EAGAIN;
 
-	rc = qed_dbg_grc_config(hwfn, ptt, cfg_id, val);
+	rc = qed_dbg_grc_config(hwfn, cfg_id, val);
 
 	qed_ptt_release(hwfn, ptt);
 
diff --git a/include/linux/qed/qed_if.h b/include/linux/qed/qed_if.h
index 1b27c22d39af..8f29e0d8a7b3 100644
--- a/include/linux/qed/qed_if.h
+++ b/include/linux/qed/qed_if.h
@@ -1178,6 +1178,15 @@ struct qed_common_ops {
 #define GET_FIELD(value, name) \
 	(((value) >> (name ## _SHIFT)) & name ## _MASK)
 
+#define GET_MFW_FIELD(name, field) \
+	(((name) & (field ## _MASK)) >> (field ## _OFFSET))
+
+#define SET_MFW_FIELD(name, field, value)				 \
+	do {								 \
+		(name) &= ~(field ## _MASK);				 \
+		(name) |= (((value) << (field ## _OFFSET)) & (field ## _MASK));\
+	} while (0)
+
 #define DB_ADDR_SHIFT(addr) ((addr) << DB_PWM_ADDR_OFFSET_SHIFT)
 
 /* Debug print definitions */
-- 
2.14.5

