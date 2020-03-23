Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A51A18F574
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 14:15:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728463AbgCWNPQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 09:15:16 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:60362 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728426AbgCWNPP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 09:15:15 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02ND6MSr019129;
        Mon, 23 Mar 2020 06:15:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=2V/1/ETIXXpP5OFwVecp0yvjgsJRoZVyzovfzdf7kq8=;
 b=Za6Rr8Jet79Cl352yalIDwY1bJcQst4rwzm/PHDtolzKhni8Yd74CRk1lLUj0cHP4qvN
 vbBsUTevfCXtKp7vcMVz8BIgKecCleHLgZTfBcnbN23DMfTBoXPCDSqdgM3n7qA6WgzO
 a/HrKcS616vjCjluAmVrJ/51m8TBRkJ3uf5QPQOyDiPq7t7LD6y+1kcULbe8JidQGFWp
 G1RQzYH28F048H8/zVUNMkBLQqJHRdUFKomn3jd+cnXc65xJl9VpKb4IKzIWBn3FHshq
 um0XvGDk68wbPWWeHyL+jYiqBrGLdNqmt9vL3Ankwh+EqAtkoex8ngmwH6OEty1f61k9 cQ== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2ywvkqmn4s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 23 Mar 2020 06:15:07 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 23 Mar
 2020 06:15:05 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 23 Mar 2020 06:15:05 -0700
Received: from localhost.localdomain (unknown [10.9.16.91])
        by maili.marvell.com (Postfix) with ESMTP id 5A7733F7069;
        Mon, 23 Mar 2020 06:15:03 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     Mark Starovoytov <mstarovoitov@marvell.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "Dmitry Bogdanov" <dbogdanov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net-next 11/17] net: atlantic: MACSec egress offload HW bindings
Date:   Mon, 23 Mar 2020 16:13:42 +0300
Message-ID: <20200323131348.340-12-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200323131348.340-1-irusskikh@marvell.com>
References: <20200323131348.340-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-23_04:2020-03-21,2020-03-23 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Bogdanov <dbogdanov@marvell.com>

This patch adds the Atlantic HW-specific bindings for MACSec egress, e.g.
register addresses / structs, helper function, etc, which will be used by
actual callback implementations.

Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../net/ethernet/aquantia/atlantic/Makefile   |    3 +-
 .../atlantic/macsec/MSS_Egress_registers.h    |   73 ++
 .../aquantia/atlantic/macsec/macsec_api.c     | 1149 +++++++++++++++++
 .../aquantia/atlantic/macsec/macsec_api.h     |  128 ++
 .../aquantia/atlantic/macsec/macsec_struct.h  |  317 +++++
 5 files changed, 1669 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/aquantia/atlantic/macsec/MSS_Egress_registers.h
 create mode 100644 drivers/net/ethernet/aquantia/atlantic/macsec/macsec_api.c
 create mode 100644 drivers/net/ethernet/aquantia/atlantic/macsec/macsec_api.h
 create mode 100644 drivers/net/ethernet/aquantia/atlantic/macsec/macsec_struct.h

diff --git a/drivers/net/ethernet/aquantia/atlantic/Makefile b/drivers/net/ethernet/aquantia/atlantic/Makefile
index 2db5569d05cb..8b555665a33a 100644
--- a/drivers/net/ethernet/aquantia/atlantic/Makefile
+++ b/drivers/net/ethernet/aquantia/atlantic/Makefile
@@ -24,7 +24,8 @@ atlantic-objs := aq_main.o \
 	hw_atl/hw_atl_b0.o \
 	hw_atl/hw_atl_utils.o \
 	hw_atl/hw_atl_utils_fw2x.o \
-	hw_atl/hw_atl_llh.o
+	hw_atl/hw_atl_llh.o \
+	macsec/macsec_api.o
 
 atlantic-$(CONFIG_MACSEC) += aq_macsec.o
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/macsec/MSS_Egress_registers.h b/drivers/net/ethernet/aquantia/atlantic/macsec/MSS_Egress_registers.h
new file mode 100644
index 000000000000..71d08ea80b54
--- /dev/null
+++ b/drivers/net/ethernet/aquantia/atlantic/macsec/MSS_Egress_registers.h
@@ -0,0 +1,73 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Atlantic Network Driver
+ * Copyright (C) 2020 Marvell International Ltd.
+ */
+
+#ifndef MSS_EGRESS_REGS_HEADER
+#define MSS_EGRESS_REGS_HEADER
+
+#define MSS_EGRESS_CTL_REGISTER_ADDR 0x00005002
+#define MSS_EGRESS_SA_EXPIRED_STATUS_REGISTER_ADDR 0x00005060
+#define MSS_EGRESS_SA_THRESHOLD_EXPIRED_STATUS_REGISTER_ADDR 0x00005062
+#define MSS_EGRESS_LUT_ADDR_CTL_REGISTER_ADDR 0x00005080
+#define MSS_EGRESS_LUT_CTL_REGISTER_ADDR 0x00005081
+#define MSS_EGRESS_LUT_DATA_CTL_REGISTER_ADDR 0x000050A0
+
+struct mss_egress_ctl_register {
+	union {
+		struct {
+			unsigned int soft_reset : 1;
+			unsigned int drop_kay_packet : 1;
+			unsigned int drop_egprc_lut_miss : 1;
+			unsigned int gcm_start : 1;
+			unsigned int gcm_test_mode : 1;
+			unsigned int unmatched_use_sc_0 : 1;
+			unsigned int drop_invalid_sa_sc_packets : 1;
+			unsigned int reserved0 : 1;
+			/* Should always be set to 0. */
+			unsigned int external_classification_enable : 1;
+			unsigned int icv_lsb_8bytes_enable : 1;
+			unsigned int high_prio : 1;
+			unsigned int clear_counter : 1;
+			unsigned int clear_global_time : 1;
+			unsigned int ethertype_explicit_sectag_lsb : 3;
+		} bits_0;
+		unsigned short word_0;
+	};
+	union {
+		struct {
+			unsigned int ethertype_explicit_sectag_msb : 13;
+			unsigned int reserved0 : 3;
+		} bits_1;
+		unsigned short word_1;
+	};
+};
+
+struct mss_egress_lut_addr_ctl_register {
+	union {
+		struct {
+			unsigned int lut_addr : 9;
+			unsigned int reserved0 : 3;
+			/* 0x0 : Egress MAC Control FIlter (CTLF) LUT
+			 * 0x1 : Egress Classification LUT
+			 * 0x2 : Egress SC/SA LUT
+			 * 0x3 : Egress SMIB
+			 */
+			unsigned int lut_select : 4;
+		} bits_0;
+		unsigned short word_0;
+	};
+};
+
+struct mss_egress_lut_ctl_register {
+	union {
+		struct {
+			unsigned int reserved0 : 14;
+			unsigned int lut_read : 1;
+			unsigned int lut_write : 1;
+		} bits_0;
+		unsigned short word_0;
+	};
+};
+
+#endif /* MSS_EGRESS_REGS_HEADER */
diff --git a/drivers/net/ethernet/aquantia/atlantic/macsec/macsec_api.c b/drivers/net/ethernet/aquantia/atlantic/macsec/macsec_api.c
new file mode 100644
index 000000000000..8448df694770
--- /dev/null
+++ b/drivers/net/ethernet/aquantia/atlantic/macsec/macsec_api.c
@@ -0,0 +1,1149 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Atlantic Network Driver
+ * Copyright (C) 2020 Marvell International Ltd.
+ */
+
+#include "macsec_api.h"
+#include <linux/mdio.h>
+#include "MSS_Egress_registers.h"
+#include "aq_phy.h"
+
+#define AQ_API_CALL_SAFE(func, ...)                                            \
+({                                                                             \
+	int ret;                                                               \
+	do {                                                                   \
+		ret = aq_mss_mdio_sem_get(hw);                                 \
+		if (unlikely(ret))                                             \
+			break;                                                 \
+									       \
+		ret = func(__VA_ARGS__);                                       \
+									       \
+		aq_mss_mdio_sem_put(hw);                                       \
+	} while (0);                                                           \
+	ret;                                                                   \
+})
+
+/*******************************************************************************
+ *                               MDIO wrappers
+ ******************************************************************************/
+static int aq_mss_mdio_sem_get(struct aq_hw_s *hw)
+{
+	u32 val;
+
+	return readx_poll_timeout_atomic(hw_atl_sem_mdio_get, hw, val,
+					 val == 1U, 10U, 100000U);
+}
+
+static void aq_mss_mdio_sem_put(struct aq_hw_s *hw)
+{
+	hw_atl_reg_glb_cpu_sem_set(hw, 1U, HW_ATL_FW_SM_MDIO);
+}
+
+static int aq_mss_mdio_read(struct aq_hw_s *hw, u16 mmd, u16 addr, u16 *data)
+{
+	*data = aq_mdio_read_word(hw, mmd, addr);
+	return (*data != 0xffff) ? 0 : -ETIME;
+}
+
+static int aq_mss_mdio_write(struct aq_hw_s *hw, u16 mmd, u16 addr, u16 data)
+{
+	aq_mdio_write_word(hw, mmd, addr, data);
+	return 0;
+}
+
+/*******************************************************************************
+ *                          MACSEC config and status
+ ******************************************************************************/
+
+/*! Write packed_record to the specified Egress LUT table row. */
+static int set_raw_egress_record(struct aq_hw_s *hw, u16 *packed_record,
+				 u8 num_words, u8 table_id,
+				 u16 table_index)
+{
+	struct mss_egress_lut_addr_ctl_register lut_sel_reg;
+	struct mss_egress_lut_ctl_register lut_op_reg;
+
+	unsigned int i;
+
+	/* Write the packed record words to the data buffer registers. */
+	for (i = 0; i < num_words; i += 2) {
+		aq_mss_mdio_write(hw, MDIO_MMD_VEND1,
+				  MSS_EGRESS_LUT_DATA_CTL_REGISTER_ADDR + i,
+				  packed_record[i]);
+		aq_mss_mdio_write(hw, MDIO_MMD_VEND1,
+				  MSS_EGRESS_LUT_DATA_CTL_REGISTER_ADDR + i + 1,
+				  packed_record[i + 1]);
+	}
+
+	/* Clear out the unused data buffer registers. */
+	for (i = num_words; i < 28; i += 2) {
+		aq_mss_mdio_write(hw, MDIO_MMD_VEND1,
+				  MSS_EGRESS_LUT_DATA_CTL_REGISTER_ADDR + i, 0);
+		aq_mss_mdio_write(hw, MDIO_MMD_VEND1,
+				  MSS_EGRESS_LUT_DATA_CTL_REGISTER_ADDR + i + 1,
+				  0);
+	}
+
+	/* Select the table and row index to write to */
+	lut_sel_reg.bits_0.lut_select = table_id;
+	lut_sel_reg.bits_0.lut_addr = table_index;
+
+	lut_op_reg.bits_0.lut_read = 0;
+	lut_op_reg.bits_0.lut_write = 1;
+
+	aq_mss_mdio_write(hw, MDIO_MMD_VEND1,
+			  MSS_EGRESS_LUT_ADDR_CTL_REGISTER_ADDR,
+			  lut_sel_reg.word_0);
+	aq_mss_mdio_write(hw, MDIO_MMD_VEND1, MSS_EGRESS_LUT_CTL_REGISTER_ADDR,
+			  lut_op_reg.word_0);
+
+	return 0;
+}
+
+static int get_raw_egress_record(struct aq_hw_s *hw, u16 *packed_record,
+				 u8 num_words, u8 table_id,
+				 u16 table_index)
+{
+	struct mss_egress_lut_addr_ctl_register lut_sel_reg;
+	struct mss_egress_lut_ctl_register lut_op_reg;
+	int ret;
+
+	unsigned int i;
+
+	/* Select the table and row index to read */
+	lut_sel_reg.bits_0.lut_select = table_id;
+	lut_sel_reg.bits_0.lut_addr = table_index;
+
+	lut_op_reg.bits_0.lut_read = 1;
+	lut_op_reg.bits_0.lut_write = 0;
+
+	ret = aq_mss_mdio_write(hw, MDIO_MMD_VEND1,
+				MSS_EGRESS_LUT_ADDR_CTL_REGISTER_ADDR,
+				lut_sel_reg.word_0);
+	if (unlikely(ret))
+		return ret;
+	ret = aq_mss_mdio_write(hw, MDIO_MMD_VEND1,
+				MSS_EGRESS_LUT_CTL_REGISTER_ADDR,
+				lut_op_reg.word_0);
+	if (unlikely(ret))
+		return ret;
+
+	memset(packed_record, 0, sizeof(u16) * num_words);
+
+	for (i = 0; i < num_words; i += 2) {
+		ret = aq_mss_mdio_read(hw, MDIO_MMD_VEND1,
+				       MSS_EGRESS_LUT_DATA_CTL_REGISTER_ADDR +
+					       i,
+				       &packed_record[i]);
+		if (unlikely(ret))
+			return ret;
+		ret = aq_mss_mdio_read(hw, MDIO_MMD_VEND1,
+				       MSS_EGRESS_LUT_DATA_CTL_REGISTER_ADDR +
+					       i + 1,
+				       &packed_record[i + 1]);
+		if (unlikely(ret))
+			return ret;
+	}
+
+	return 0;
+}
+
+static int set_egress_ctlf_record(struct aq_hw_s *hw,
+				  const struct aq_mss_egress_ctlf_record *rec,
+				  u16 table_index)
+{
+	u16 packed_record[6];
+
+	if (table_index >= NUMROWS_EGRESSCTLFRECORD)
+		return -EINVAL;
+
+	memset(packed_record, 0, sizeof(u16) * 6);
+
+	packed_record[0] = (packed_record[0] & 0x0000) |
+			   (((rec->sa_da[0] >> 0) & 0xFFFF) << 0);
+	packed_record[1] = (packed_record[1] & 0x0000) |
+			   (((rec->sa_da[0] >> 16) & 0xFFFF) << 0);
+
+	packed_record[2] = (packed_record[2] & 0x0000) |
+			   (((rec->sa_da[1] >> 0) & 0xFFFF) << 0);
+
+	packed_record[3] = (packed_record[3] & 0x0000) |
+			   (((rec->eth_type >> 0) & 0xFFFF) << 0);
+
+	packed_record[4] = (packed_record[4] & 0x0000) |
+			   (((rec->match_mask >> 0) & 0xFFFF) << 0);
+
+	packed_record[5] = (packed_record[5] & 0xFFF0) |
+			   (((rec->match_type >> 0) & 0xF) << 0);
+
+	packed_record[5] =
+		(packed_record[5] & 0xFFEF) | (((rec->action >> 0) & 0x1) << 4);
+
+	return set_raw_egress_record(hw, packed_record, 6, 0,
+				     ROWOFFSET_EGRESSCTLFRECORD + table_index);
+}
+
+int aq_mss_set_egress_ctlf_record(struct aq_hw_s *hw,
+				  const struct aq_mss_egress_ctlf_record *rec,
+				  u16 table_index)
+{
+	return AQ_API_CALL_SAFE(set_egress_ctlf_record, hw, rec, table_index);
+}
+
+static int get_egress_ctlf_record(struct aq_hw_s *hw,
+				  struct aq_mss_egress_ctlf_record *rec,
+				  u16 table_index)
+{
+	u16 packed_record[6];
+	int ret;
+
+	if (table_index >= NUMROWS_EGRESSCTLFRECORD)
+		return -EINVAL;
+
+	/* If the row that we want to read is odd, first read the previous even
+	 * row, throw that value away, and finally read the desired row.
+	 */
+	if ((table_index % 2) > 0) {
+		ret = get_raw_egress_record(hw, packed_record, 6, 0,
+					    ROWOFFSET_EGRESSCTLFRECORD +
+						    table_index - 1);
+		if (unlikely(ret))
+			return ret;
+	}
+
+	ret = get_raw_egress_record(hw, packed_record, 6, 0,
+				    ROWOFFSET_EGRESSCTLFRECORD + table_index);
+	if (unlikely(ret))
+		return ret;
+
+	rec->sa_da[0] = (rec->sa_da[0] & 0xFFFF0000) |
+			(((packed_record[0] >> 0) & 0xFFFF) << 0);
+	rec->sa_da[0] = (rec->sa_da[0] & 0x0000FFFF) |
+			(((packed_record[1] >> 0) & 0xFFFF) << 16);
+
+	rec->sa_da[1] = (rec->sa_da[1] & 0xFFFF0000) |
+			(((packed_record[2] >> 0) & 0xFFFF) << 0);
+
+	rec->eth_type = (rec->eth_type & 0xFFFF0000) |
+			(((packed_record[3] >> 0) & 0xFFFF) << 0);
+
+	rec->match_mask = (rec->match_mask & 0xFFFF0000) |
+			  (((packed_record[4] >> 0) & 0xFFFF) << 0);
+
+	rec->match_type = (rec->match_type & 0xFFFFFFF0) |
+			  (((packed_record[5] >> 0) & 0xF) << 0);
+
+	rec->action = (rec->action & 0xFFFFFFFE) |
+		      (((packed_record[5] >> 4) & 0x1) << 0);
+
+	return 0;
+}
+
+int aq_mss_get_egress_ctlf_record(struct aq_hw_s *hw,
+				  struct aq_mss_egress_ctlf_record *rec,
+				  u16 table_index)
+{
+	memset(rec, 0, sizeof(*rec));
+
+	return AQ_API_CALL_SAFE(get_egress_ctlf_record, hw, rec, table_index);
+}
+
+static int set_egress_class_record(struct aq_hw_s *hw,
+				   const struct aq_mss_egress_class_record *rec,
+				   u16 table_index)
+{
+	u16 packed_record[28];
+
+	if (table_index >= NUMROWS_EGRESSCLASSRECORD)
+		return -EINVAL;
+
+	memset(packed_record, 0, sizeof(u16) * 28);
+
+	packed_record[0] = (packed_record[0] & 0xF000) |
+			   (((rec->vlan_id >> 0) & 0xFFF) << 0);
+
+	packed_record[0] = (packed_record[0] & 0x8FFF) |
+			   (((rec->vlan_up >> 0) & 0x7) << 12);
+
+	packed_record[0] = (packed_record[0] & 0x7FFF) |
+			   (((rec->vlan_valid >> 0) & 0x1) << 15);
+
+	packed_record[1] =
+		(packed_record[1] & 0xFF00) | (((rec->byte3 >> 0) & 0xFF) << 0);
+
+	packed_record[1] =
+		(packed_record[1] & 0x00FF) | (((rec->byte2 >> 0) & 0xFF) << 8);
+
+	packed_record[2] =
+		(packed_record[2] & 0xFF00) | (((rec->byte1 >> 0) & 0xFF) << 0);
+
+	packed_record[2] =
+		(packed_record[2] & 0x00FF) | (((rec->byte0 >> 0) & 0xFF) << 8);
+
+	packed_record[3] =
+		(packed_record[3] & 0xFF00) | (((rec->tci >> 0) & 0xFF) << 0);
+
+	packed_record[3] = (packed_record[3] & 0x00FF) |
+			   (((rec->sci[0] >> 0) & 0xFF) << 8);
+	packed_record[4] = (packed_record[4] & 0x0000) |
+			   (((rec->sci[0] >> 8) & 0xFFFF) << 0);
+	packed_record[5] = (packed_record[5] & 0xFF00) |
+			   (((rec->sci[0] >> 24) & 0xFF) << 0);
+
+	packed_record[5] = (packed_record[5] & 0x00FF) |
+			   (((rec->sci[1] >> 0) & 0xFF) << 8);
+	packed_record[6] = (packed_record[6] & 0x0000) |
+			   (((rec->sci[1] >> 8) & 0xFFFF) << 0);
+	packed_record[7] = (packed_record[7] & 0xFF00) |
+			   (((rec->sci[1] >> 24) & 0xFF) << 0);
+
+	packed_record[7] = (packed_record[7] & 0x00FF) |
+			   (((rec->eth_type >> 0) & 0xFF) << 8);
+	packed_record[8] = (packed_record[8] & 0xFF00) |
+			   (((rec->eth_type >> 8) & 0xFF) << 0);
+
+	packed_record[8] = (packed_record[8] & 0x00FF) |
+			   (((rec->snap[0] >> 0) & 0xFF) << 8);
+	packed_record[9] = (packed_record[9] & 0x0000) |
+			   (((rec->snap[0] >> 8) & 0xFFFF) << 0);
+	packed_record[10] = (packed_record[10] & 0xFF00) |
+			    (((rec->snap[0] >> 24) & 0xFF) << 0);
+
+	packed_record[10] = (packed_record[10] & 0x00FF) |
+			    (((rec->snap[1] >> 0) & 0xFF) << 8);
+
+	packed_record[11] = (packed_record[11] & 0x0000) |
+			    (((rec->llc >> 0) & 0xFFFF) << 0);
+	packed_record[12] =
+		(packed_record[12] & 0xFF00) | (((rec->llc >> 16) & 0xFF) << 0);
+
+	packed_record[12] = (packed_record[12] & 0x00FF) |
+			    (((rec->mac_sa[0] >> 0) & 0xFF) << 8);
+	packed_record[13] = (packed_record[13] & 0x0000) |
+			    (((rec->mac_sa[0] >> 8) & 0xFFFF) << 0);
+	packed_record[14] = (packed_record[14] & 0xFF00) |
+			    (((rec->mac_sa[0] >> 24) & 0xFF) << 0);
+
+	packed_record[14] = (packed_record[14] & 0x00FF) |
+			    (((rec->mac_sa[1] >> 0) & 0xFF) << 8);
+	packed_record[15] = (packed_record[15] & 0xFF00) |
+			    (((rec->mac_sa[1] >> 8) & 0xFF) << 0);
+
+	packed_record[15] = (packed_record[15] & 0x00FF) |
+			    (((rec->mac_da[0] >> 0) & 0xFF) << 8);
+	packed_record[16] = (packed_record[16] & 0x0000) |
+			    (((rec->mac_da[0] >> 8) & 0xFFFF) << 0);
+	packed_record[17] = (packed_record[17] & 0xFF00) |
+			    (((rec->mac_da[0] >> 24) & 0xFF) << 0);
+
+	packed_record[17] = (packed_record[17] & 0x00FF) |
+			    (((rec->mac_da[1] >> 0) & 0xFF) << 8);
+	packed_record[18] = (packed_record[18] & 0xFF00) |
+			    (((rec->mac_da[1] >> 8) & 0xFF) << 0);
+
+	packed_record[18] =
+		(packed_record[18] & 0x00FF) | (((rec->pn >> 0) & 0xFF) << 8);
+	packed_record[19] =
+		(packed_record[19] & 0x0000) | (((rec->pn >> 8) & 0xFFFF) << 0);
+	packed_record[20] =
+		(packed_record[20] & 0xFF00) | (((rec->pn >> 24) & 0xFF) << 0);
+
+	packed_record[20] = (packed_record[20] & 0xC0FF) |
+			    (((rec->byte3_location >> 0) & 0x3F) << 8);
+
+	packed_record[20] = (packed_record[20] & 0xBFFF) |
+			    (((rec->byte3_mask >> 0) & 0x1) << 14);
+
+	packed_record[20] = (packed_record[20] & 0x7FFF) |
+			    (((rec->byte2_location >> 0) & 0x1) << 15);
+	packed_record[21] = (packed_record[21] & 0xFFE0) |
+			    (((rec->byte2_location >> 1) & 0x1F) << 0);
+
+	packed_record[21] = (packed_record[21] & 0xFFDF) |
+			    (((rec->byte2_mask >> 0) & 0x1) << 5);
+
+	packed_record[21] = (packed_record[21] & 0xF03F) |
+			    (((rec->byte1_location >> 0) & 0x3F) << 6);
+
+	packed_record[21] = (packed_record[21] & 0xEFFF) |
+			    (((rec->byte1_mask >> 0) & 0x1) << 12);
+
+	packed_record[21] = (packed_record[21] & 0x1FFF) |
+			    (((rec->byte0_location >> 0) & 0x7) << 13);
+	packed_record[22] = (packed_record[22] & 0xFFF8) |
+			    (((rec->byte0_location >> 3) & 0x7) << 0);
+
+	packed_record[22] = (packed_record[22] & 0xFFF7) |
+			    (((rec->byte0_mask >> 0) & 0x1) << 3);
+
+	packed_record[22] = (packed_record[22] & 0xFFCF) |
+			    (((rec->vlan_id_mask >> 0) & 0x3) << 4);
+
+	packed_record[22] = (packed_record[22] & 0xFFBF) |
+			    (((rec->vlan_up_mask >> 0) & 0x1) << 6);
+
+	packed_record[22] = (packed_record[22] & 0xFF7F) |
+			    (((rec->vlan_valid_mask >> 0) & 0x1) << 7);
+
+	packed_record[22] = (packed_record[22] & 0x00FF) |
+			    (((rec->tci_mask >> 0) & 0xFF) << 8);
+
+	packed_record[23] = (packed_record[23] & 0xFF00) |
+			    (((rec->sci_mask >> 0) & 0xFF) << 0);
+
+	packed_record[23] = (packed_record[23] & 0xFCFF) |
+			    (((rec->eth_type_mask >> 0) & 0x3) << 8);
+
+	packed_record[23] = (packed_record[23] & 0x83FF) |
+			    (((rec->snap_mask >> 0) & 0x1F) << 10);
+
+	packed_record[23] = (packed_record[23] & 0x7FFF) |
+			    (((rec->llc_mask >> 0) & 0x1) << 15);
+	packed_record[24] = (packed_record[24] & 0xFFFC) |
+			    (((rec->llc_mask >> 1) & 0x3) << 0);
+
+	packed_record[24] = (packed_record[24] & 0xFF03) |
+			    (((rec->sa_mask >> 0) & 0x3F) << 2);
+
+	packed_record[24] = (packed_record[24] & 0xC0FF) |
+			    (((rec->da_mask >> 0) & 0x3F) << 8);
+
+	packed_record[24] = (packed_record[24] & 0x3FFF) |
+			    (((rec->pn_mask >> 0) & 0x3) << 14);
+	packed_record[25] = (packed_record[25] & 0xFFFC) |
+			    (((rec->pn_mask >> 2) & 0x3) << 0);
+
+	packed_record[25] = (packed_record[25] & 0xFFFB) |
+			    (((rec->eight02dot2 >> 0) & 0x1) << 2);
+
+	packed_record[25] = (packed_record[25] & 0xFFF7) |
+			    (((rec->tci_sc >> 0) & 0x1) << 3);
+
+	packed_record[25] = (packed_record[25] & 0xFFEF) |
+			    (((rec->tci_87543 >> 0) & 0x1) << 4);
+
+	packed_record[25] = (packed_record[25] & 0xFFDF) |
+			    (((rec->exp_sectag_en >> 0) & 0x1) << 5);
+
+	packed_record[25] = (packed_record[25] & 0xF83F) |
+			    (((rec->sc_idx >> 0) & 0x1F) << 6);
+
+	packed_record[25] = (packed_record[25] & 0xE7FF) |
+			    (((rec->sc_sa >> 0) & 0x3) << 11);
+
+	packed_record[25] = (packed_record[25] & 0xDFFF) |
+			    (((rec->debug >> 0) & 0x1) << 13);
+
+	packed_record[25] = (packed_record[25] & 0x3FFF) |
+			    (((rec->action >> 0) & 0x3) << 14);
+
+	packed_record[26] =
+		(packed_record[26] & 0xFFF7) | (((rec->valid >> 0) & 0x1) << 3);
+
+	return set_raw_egress_record(hw, packed_record, 28, 1,
+				     ROWOFFSET_EGRESSCLASSRECORD + table_index);
+}
+
+int aq_mss_set_egress_class_record(struct aq_hw_s *hw,
+				   const struct aq_mss_egress_class_record *rec,
+				   u16 table_index)
+{
+	return AQ_API_CALL_SAFE(set_egress_class_record, hw, rec, table_index);
+}
+
+static int get_egress_class_record(struct aq_hw_s *hw,
+				   struct aq_mss_egress_class_record *rec,
+				   u16 table_index)
+{
+	u16 packed_record[28];
+	int ret;
+
+	if (table_index >= NUMROWS_EGRESSCLASSRECORD)
+		return -EINVAL;
+
+	/* If the row that we want to read is odd, first read the previous even
+	 * row, throw that value away, and finally read the desired row.
+	 */
+	if ((table_index % 2) > 0) {
+		ret = get_raw_egress_record(hw, packed_record, 28, 1,
+					    ROWOFFSET_EGRESSCLASSRECORD +
+						    table_index - 1);
+		if (unlikely(ret))
+			return ret;
+	}
+
+	ret = get_raw_egress_record(hw, packed_record, 28, 1,
+				    ROWOFFSET_EGRESSCLASSRECORD + table_index);
+	if (unlikely(ret))
+		return ret;
+
+	rec->vlan_id = (rec->vlan_id & 0xFFFFF000) |
+		       (((packed_record[0] >> 0) & 0xFFF) << 0);
+
+	rec->vlan_up = (rec->vlan_up & 0xFFFFFFF8) |
+		       (((packed_record[0] >> 12) & 0x7) << 0);
+
+	rec->vlan_valid = (rec->vlan_valid & 0xFFFFFFFE) |
+			  (((packed_record[0] >> 15) & 0x1) << 0);
+
+	rec->byte3 = (rec->byte3 & 0xFFFFFF00) |
+		     (((packed_record[1] >> 0) & 0xFF) << 0);
+
+	rec->byte2 = (rec->byte2 & 0xFFFFFF00) |
+		     (((packed_record[1] >> 8) & 0xFF) << 0);
+
+	rec->byte1 = (rec->byte1 & 0xFFFFFF00) |
+		     (((packed_record[2] >> 0) & 0xFF) << 0);
+
+	rec->byte0 = (rec->byte0 & 0xFFFFFF00) |
+		     (((packed_record[2] >> 8) & 0xFF) << 0);
+
+	rec->tci = (rec->tci & 0xFFFFFF00) |
+		   (((packed_record[3] >> 0) & 0xFF) << 0);
+
+	rec->sci[0] = (rec->sci[0] & 0xFFFFFF00) |
+		      (((packed_record[3] >> 8) & 0xFF) << 0);
+	rec->sci[0] = (rec->sci[0] & 0xFF0000FF) |
+		      (((packed_record[4] >> 0) & 0xFFFF) << 8);
+	rec->sci[0] = (rec->sci[0] & 0x00FFFFFF) |
+		      (((packed_record[5] >> 0) & 0xFF) << 24);
+
+	rec->sci[1] = (rec->sci[1] & 0xFFFFFF00) |
+		      (((packed_record[5] >> 8) & 0xFF) << 0);
+	rec->sci[1] = (rec->sci[1] & 0xFF0000FF) |
+		      (((packed_record[6] >> 0) & 0xFFFF) << 8);
+	rec->sci[1] = (rec->sci[1] & 0x00FFFFFF) |
+		      (((packed_record[7] >> 0) & 0xFF) << 24);
+
+	rec->eth_type = (rec->eth_type & 0xFFFFFF00) |
+			(((packed_record[7] >> 8) & 0xFF) << 0);
+	rec->eth_type = (rec->eth_type & 0xFFFF00FF) |
+			(((packed_record[8] >> 0) & 0xFF) << 8);
+
+	rec->snap[0] = (rec->snap[0] & 0xFFFFFF00) |
+		       (((packed_record[8] >> 8) & 0xFF) << 0);
+	rec->snap[0] = (rec->snap[0] & 0xFF0000FF) |
+		       (((packed_record[9] >> 0) & 0xFFFF) << 8);
+	rec->snap[0] = (rec->snap[0] & 0x00FFFFFF) |
+		       (((packed_record[10] >> 0) & 0xFF) << 24);
+
+	rec->snap[1] = (rec->snap[1] & 0xFFFFFF00) |
+		       (((packed_record[10] >> 8) & 0xFF) << 0);
+
+	rec->llc = (rec->llc & 0xFFFF0000) |
+		   (((packed_record[11] >> 0) & 0xFFFF) << 0);
+	rec->llc = (rec->llc & 0xFF00FFFF) |
+		   (((packed_record[12] >> 0) & 0xFF) << 16);
+
+	rec->mac_sa[0] = (rec->mac_sa[0] & 0xFFFFFF00) |
+			 (((packed_record[12] >> 8) & 0xFF) << 0);
+	rec->mac_sa[0] = (rec->mac_sa[0] & 0xFF0000FF) |
+			 (((packed_record[13] >> 0) & 0xFFFF) << 8);
+	rec->mac_sa[0] = (rec->mac_sa[0] & 0x00FFFFFF) |
+			 (((packed_record[14] >> 0) & 0xFF) << 24);
+
+	rec->mac_sa[1] = (rec->mac_sa[1] & 0xFFFFFF00) |
+			 (((packed_record[14] >> 8) & 0xFF) << 0);
+	rec->mac_sa[1] = (rec->mac_sa[1] & 0xFFFF00FF) |
+			 (((packed_record[15] >> 0) & 0xFF) << 8);
+
+	rec->mac_da[0] = (rec->mac_da[0] & 0xFFFFFF00) |
+			 (((packed_record[15] >> 8) & 0xFF) << 0);
+	rec->mac_da[0] = (rec->mac_da[0] & 0xFF0000FF) |
+			 (((packed_record[16] >> 0) & 0xFFFF) << 8);
+	rec->mac_da[0] = (rec->mac_da[0] & 0x00FFFFFF) |
+			 (((packed_record[17] >> 0) & 0xFF) << 24);
+
+	rec->mac_da[1] = (rec->mac_da[1] & 0xFFFFFF00) |
+			 (((packed_record[17] >> 8) & 0xFF) << 0);
+	rec->mac_da[1] = (rec->mac_da[1] & 0xFFFF00FF) |
+			 (((packed_record[18] >> 0) & 0xFF) << 8);
+
+	rec->pn = (rec->pn & 0xFFFFFF00) |
+		  (((packed_record[18] >> 8) & 0xFF) << 0);
+	rec->pn = (rec->pn & 0xFF0000FF) |
+		  (((packed_record[19] >> 0) & 0xFFFF) << 8);
+	rec->pn = (rec->pn & 0x00FFFFFF) |
+		  (((packed_record[20] >> 0) & 0xFF) << 24);
+
+	rec->byte3_location = (rec->byte3_location & 0xFFFFFFC0) |
+			      (((packed_record[20] >> 8) & 0x3F) << 0);
+
+	rec->byte3_mask = (rec->byte3_mask & 0xFFFFFFFE) |
+			  (((packed_record[20] >> 14) & 0x1) << 0);
+
+	rec->byte2_location = (rec->byte2_location & 0xFFFFFFFE) |
+			      (((packed_record[20] >> 15) & 0x1) << 0);
+	rec->byte2_location = (rec->byte2_location & 0xFFFFFFC1) |
+			      (((packed_record[21] >> 0) & 0x1F) << 1);
+
+	rec->byte2_mask = (rec->byte2_mask & 0xFFFFFFFE) |
+			  (((packed_record[21] >> 5) & 0x1) << 0);
+
+	rec->byte1_location = (rec->byte1_location & 0xFFFFFFC0) |
+			      (((packed_record[21] >> 6) & 0x3F) << 0);
+
+	rec->byte1_mask = (rec->byte1_mask & 0xFFFFFFFE) |
+			  (((packed_record[21] >> 12) & 0x1) << 0);
+
+	rec->byte0_location = (rec->byte0_location & 0xFFFFFFF8) |
+			      (((packed_record[21] >> 13) & 0x7) << 0);
+	rec->byte0_location = (rec->byte0_location & 0xFFFFFFC7) |
+			      (((packed_record[22] >> 0) & 0x7) << 3);
+
+	rec->byte0_mask = (rec->byte0_mask & 0xFFFFFFFE) |
+			  (((packed_record[22] >> 3) & 0x1) << 0);
+
+	rec->vlan_id_mask = (rec->vlan_id_mask & 0xFFFFFFFC) |
+			    (((packed_record[22] >> 4) & 0x3) << 0);
+
+	rec->vlan_up_mask = (rec->vlan_up_mask & 0xFFFFFFFE) |
+			    (((packed_record[22] >> 6) & 0x1) << 0);
+
+	rec->vlan_valid_mask = (rec->vlan_valid_mask & 0xFFFFFFFE) |
+			       (((packed_record[22] >> 7) & 0x1) << 0);
+
+	rec->tci_mask = (rec->tci_mask & 0xFFFFFF00) |
+			(((packed_record[22] >> 8) & 0xFF) << 0);
+
+	rec->sci_mask = (rec->sci_mask & 0xFFFFFF00) |
+			(((packed_record[23] >> 0) & 0xFF) << 0);
+
+	rec->eth_type_mask = (rec->eth_type_mask & 0xFFFFFFFC) |
+			     (((packed_record[23] >> 8) & 0x3) << 0);
+
+	rec->snap_mask = (rec->snap_mask & 0xFFFFFFE0) |
+			 (((packed_record[23] >> 10) & 0x1F) << 0);
+
+	rec->llc_mask = (rec->llc_mask & 0xFFFFFFFE) |
+			(((packed_record[23] >> 15) & 0x1) << 0);
+	rec->llc_mask = (rec->llc_mask & 0xFFFFFFF9) |
+			(((packed_record[24] >> 0) & 0x3) << 1);
+
+	rec->sa_mask = (rec->sa_mask & 0xFFFFFFC0) |
+		       (((packed_record[24] >> 2) & 0x3F) << 0);
+
+	rec->da_mask = (rec->da_mask & 0xFFFFFFC0) |
+		       (((packed_record[24] >> 8) & 0x3F) << 0);
+
+	rec->pn_mask = (rec->pn_mask & 0xFFFFFFFC) |
+		       (((packed_record[24] >> 14) & 0x3) << 0);
+	rec->pn_mask = (rec->pn_mask & 0xFFFFFFF3) |
+		       (((packed_record[25] >> 0) & 0x3) << 2);
+
+	rec->eight02dot2 = (rec->eight02dot2 & 0xFFFFFFFE) |
+			   (((packed_record[25] >> 2) & 0x1) << 0);
+
+	rec->tci_sc = (rec->tci_sc & 0xFFFFFFFE) |
+		      (((packed_record[25] >> 3) & 0x1) << 0);
+
+	rec->tci_87543 = (rec->tci_87543 & 0xFFFFFFFE) |
+			 (((packed_record[25] >> 4) & 0x1) << 0);
+
+	rec->exp_sectag_en = (rec->exp_sectag_en & 0xFFFFFFFE) |
+			     (((packed_record[25] >> 5) & 0x1) << 0);
+
+	rec->sc_idx = (rec->sc_idx & 0xFFFFFFE0) |
+		      (((packed_record[25] >> 6) & 0x1F) << 0);
+
+	rec->sc_sa = (rec->sc_sa & 0xFFFFFFFC) |
+		     (((packed_record[25] >> 11) & 0x3) << 0);
+
+	rec->debug = (rec->debug & 0xFFFFFFFE) |
+		     (((packed_record[25] >> 13) & 0x1) << 0);
+
+	rec->action = (rec->action & 0xFFFFFFFC) |
+		      (((packed_record[25] >> 14) & 0x3) << 0);
+
+	rec->valid = (rec->valid & 0xFFFFFFFE) |
+		     (((packed_record[26] >> 3) & 0x1) << 0);
+
+	return 0;
+}
+
+int aq_mss_get_egress_class_record(struct aq_hw_s *hw,
+				   struct aq_mss_egress_class_record *rec,
+				   u16 table_index)
+{
+	memset(rec, 0, sizeof(*rec));
+
+	return AQ_API_CALL_SAFE(get_egress_class_record, hw, rec, table_index);
+}
+
+static int set_egress_sc_record(struct aq_hw_s *hw,
+				const struct aq_mss_egress_sc_record *rec,
+				u16 table_index)
+{
+	u16 packed_record[8];
+
+	if (table_index >= NUMROWS_EGRESSSCRECORD)
+		return -EINVAL;
+
+	memset(packed_record, 0, sizeof(u16) * 8);
+
+	packed_record[0] = (packed_record[0] & 0x0000) |
+			   (((rec->start_time >> 0) & 0xFFFF) << 0);
+	packed_record[1] = (packed_record[1] & 0x0000) |
+			   (((rec->start_time >> 16) & 0xFFFF) << 0);
+
+	packed_record[2] = (packed_record[2] & 0x0000) |
+			   (((rec->stop_time >> 0) & 0xFFFF) << 0);
+	packed_record[3] = (packed_record[3] & 0x0000) |
+			   (((rec->stop_time >> 16) & 0xFFFF) << 0);
+
+	packed_record[4] = (packed_record[4] & 0xFFFC) |
+			   (((rec->curr_an >> 0) & 0x3) << 0);
+
+	packed_record[4] = (packed_record[4] & 0xFFFB) |
+			   (((rec->an_roll >> 0) & 0x1) << 2);
+
+	packed_record[4] =
+		(packed_record[4] & 0xFE07) | (((rec->tci >> 0) & 0x3F) << 3);
+
+	packed_record[4] = (packed_record[4] & 0x01FF) |
+			   (((rec->enc_off >> 0) & 0x7F) << 9);
+	packed_record[5] = (packed_record[5] & 0xFFFE) |
+			   (((rec->enc_off >> 7) & 0x1) << 0);
+
+	packed_record[5] = (packed_record[5] & 0xFFFD) |
+			   (((rec->protect >> 0) & 0x1) << 1);
+
+	packed_record[5] =
+		(packed_record[5] & 0xFFFB) | (((rec->recv >> 0) & 0x1) << 2);
+
+	packed_record[5] =
+		(packed_record[5] & 0xFFF7) | (((rec->fresh >> 0) & 0x1) << 3);
+
+	packed_record[5] = (packed_record[5] & 0xFFCF) |
+			   (((rec->sak_len >> 0) & 0x3) << 4);
+
+	packed_record[7] =
+		(packed_record[7] & 0x7FFF) | (((rec->valid >> 0) & 0x1) << 15);
+
+	return set_raw_egress_record(hw, packed_record, 8, 2,
+				     ROWOFFSET_EGRESSSCRECORD + table_index);
+}
+
+int aq_mss_set_egress_sc_record(struct aq_hw_s *hw,
+				const struct aq_mss_egress_sc_record *rec,
+				u16 table_index)
+{
+	return AQ_API_CALL_SAFE(set_egress_sc_record, hw, rec, table_index);
+}
+
+static int get_egress_sc_record(struct aq_hw_s *hw,
+				struct aq_mss_egress_sc_record *rec,
+				u16 table_index)
+{
+	u16 packed_record[8];
+	int ret;
+
+	if (table_index >= NUMROWS_EGRESSSCRECORD)
+		return -EINVAL;
+
+	ret = get_raw_egress_record(hw, packed_record, 8, 2,
+				    ROWOFFSET_EGRESSSCRECORD + table_index);
+	if (unlikely(ret))
+		return ret;
+
+	rec->start_time = (rec->start_time & 0xFFFF0000) |
+			  (((packed_record[0] >> 0) & 0xFFFF) << 0);
+	rec->start_time = (rec->start_time & 0x0000FFFF) |
+			  (((packed_record[1] >> 0) & 0xFFFF) << 16);
+
+	rec->stop_time = (rec->stop_time & 0xFFFF0000) |
+			 (((packed_record[2] >> 0) & 0xFFFF) << 0);
+	rec->stop_time = (rec->stop_time & 0x0000FFFF) |
+			 (((packed_record[3] >> 0) & 0xFFFF) << 16);
+
+	rec->curr_an = (rec->curr_an & 0xFFFFFFFC) |
+		       (((packed_record[4] >> 0) & 0x3) << 0);
+
+	rec->an_roll = (rec->an_roll & 0xFFFFFFFE) |
+		       (((packed_record[4] >> 2) & 0x1) << 0);
+
+	rec->tci = (rec->tci & 0xFFFFFFC0) |
+		   (((packed_record[4] >> 3) & 0x3F) << 0);
+
+	rec->enc_off = (rec->enc_off & 0xFFFFFF80) |
+		       (((packed_record[4] >> 9) & 0x7F) << 0);
+	rec->enc_off = (rec->enc_off & 0xFFFFFF7F) |
+		       (((packed_record[5] >> 0) & 0x1) << 7);
+
+	rec->protect = (rec->protect & 0xFFFFFFFE) |
+		       (((packed_record[5] >> 1) & 0x1) << 0);
+
+	rec->recv = (rec->recv & 0xFFFFFFFE) |
+		    (((packed_record[5] >> 2) & 0x1) << 0);
+
+	rec->fresh = (rec->fresh & 0xFFFFFFFE) |
+		     (((packed_record[5] >> 3) & 0x1) << 0);
+
+	rec->sak_len = (rec->sak_len & 0xFFFFFFFC) |
+		       (((packed_record[5] >> 4) & 0x3) << 0);
+
+	rec->valid = (rec->valid & 0xFFFFFFFE) |
+		     (((packed_record[7] >> 15) & 0x1) << 0);
+
+	return 0;
+}
+
+int aq_mss_get_egress_sc_record(struct aq_hw_s *hw,
+				struct aq_mss_egress_sc_record *rec,
+				u16 table_index)
+{
+	memset(rec, 0, sizeof(*rec));
+
+	return AQ_API_CALL_SAFE(get_egress_sc_record, hw, rec, table_index);
+}
+
+static int set_egress_sa_record(struct aq_hw_s *hw,
+				const struct aq_mss_egress_sa_record *rec,
+				u16 table_index)
+{
+	u16 packed_record[8];
+
+	if (table_index >= NUMROWS_EGRESSSARECORD)
+		return -EINVAL;
+
+	memset(packed_record, 0, sizeof(u16) * 8);
+
+	packed_record[0] = (packed_record[0] & 0x0000) |
+			   (((rec->start_time >> 0) & 0xFFFF) << 0);
+	packed_record[1] = (packed_record[1] & 0x0000) |
+			   (((rec->start_time >> 16) & 0xFFFF) << 0);
+
+	packed_record[2] = (packed_record[2] & 0x0000) |
+			   (((rec->stop_time >> 0) & 0xFFFF) << 0);
+	packed_record[3] = (packed_record[3] & 0x0000) |
+			   (((rec->stop_time >> 16) & 0xFFFF) << 0);
+
+	packed_record[4] = (packed_record[4] & 0x0000) |
+			   (((rec->next_pn >> 0) & 0xFFFF) << 0);
+	packed_record[5] = (packed_record[5] & 0x0000) |
+			   (((rec->next_pn >> 16) & 0xFFFF) << 0);
+
+	packed_record[6] =
+		(packed_record[6] & 0xFFFE) | (((rec->sat_pn >> 0) & 0x1) << 0);
+
+	packed_record[6] =
+		(packed_record[6] & 0xFFFD) | (((rec->fresh >> 0) & 0x1) << 1);
+
+	packed_record[7] =
+		(packed_record[7] & 0x7FFF) | (((rec->valid >> 0) & 0x1) << 15);
+
+	return set_raw_egress_record(hw, packed_record, 8, 2,
+				     ROWOFFSET_EGRESSSARECORD + table_index);
+}
+
+int aq_mss_set_egress_sa_record(struct aq_hw_s *hw,
+				const struct aq_mss_egress_sa_record *rec,
+				u16 table_index)
+{
+	return AQ_API_CALL_SAFE(set_egress_sa_record, hw, rec, table_index);
+}
+
+static int get_egress_sa_record(struct aq_hw_s *hw,
+				struct aq_mss_egress_sa_record *rec,
+				u16 table_index)
+{
+	u16 packed_record[8];
+	int ret;
+
+	if (table_index >= NUMROWS_EGRESSSARECORD)
+		return -EINVAL;
+
+	ret = get_raw_egress_record(hw, packed_record, 8, 2,
+				    ROWOFFSET_EGRESSSARECORD + table_index);
+	if (unlikely(ret))
+		return ret;
+
+	rec->start_time = (rec->start_time & 0xFFFF0000) |
+			  (((packed_record[0] >> 0) & 0xFFFF) << 0);
+	rec->start_time = (rec->start_time & 0x0000FFFF) |
+			  (((packed_record[1] >> 0) & 0xFFFF) << 16);
+
+	rec->stop_time = (rec->stop_time & 0xFFFF0000) |
+			 (((packed_record[2] >> 0) & 0xFFFF) << 0);
+	rec->stop_time = (rec->stop_time & 0x0000FFFF) |
+			 (((packed_record[3] >> 0) & 0xFFFF) << 16);
+
+	rec->next_pn = (rec->next_pn & 0xFFFF0000) |
+		       (((packed_record[4] >> 0) & 0xFFFF) << 0);
+	rec->next_pn = (rec->next_pn & 0x0000FFFF) |
+		       (((packed_record[5] >> 0) & 0xFFFF) << 16);
+
+	rec->sat_pn = (rec->sat_pn & 0xFFFFFFFE) |
+		      (((packed_record[6] >> 0) & 0x1) << 0);
+
+	rec->fresh = (rec->fresh & 0xFFFFFFFE) |
+		     (((packed_record[6] >> 1) & 0x1) << 0);
+
+	rec->valid = (rec->valid & 0xFFFFFFFE) |
+		     (((packed_record[7] >> 15) & 0x1) << 0);
+
+	return 0;
+}
+
+int aq_mss_get_egress_sa_record(struct aq_hw_s *hw,
+				struct aq_mss_egress_sa_record *rec,
+				u16 table_index)
+{
+	memset(rec, 0, sizeof(*rec));
+
+	return AQ_API_CALL_SAFE(get_egress_sa_record, hw, rec, table_index);
+}
+
+static int set_egress_sakey_record(struct aq_hw_s *hw,
+				   const struct aq_mss_egress_sakey_record *rec,
+				   u16 table_index)
+{
+	u16 packed_record[16];
+	int ret;
+
+	if (table_index >= NUMROWS_EGRESSSAKEYRECORD)
+		return -EINVAL;
+
+	memset(packed_record, 0, sizeof(u16) * 16);
+
+	packed_record[0] = (packed_record[0] & 0x0000) |
+			   (((rec->key[0] >> 0) & 0xFFFF) << 0);
+	packed_record[1] = (packed_record[1] & 0x0000) |
+			   (((rec->key[0] >> 16) & 0xFFFF) << 0);
+
+	packed_record[2] = (packed_record[2] & 0x0000) |
+			   (((rec->key[1] >> 0) & 0xFFFF) << 0);
+	packed_record[3] = (packed_record[3] & 0x0000) |
+			   (((rec->key[1] >> 16) & 0xFFFF) << 0);
+
+	packed_record[4] = (packed_record[4] & 0x0000) |
+			   (((rec->key[2] >> 0) & 0xFFFF) << 0);
+	packed_record[5] = (packed_record[5] & 0x0000) |
+			   (((rec->key[2] >> 16) & 0xFFFF) << 0);
+
+	packed_record[6] = (packed_record[6] & 0x0000) |
+			   (((rec->key[3] >> 0) & 0xFFFF) << 0);
+	packed_record[7] = (packed_record[7] & 0x0000) |
+			   (((rec->key[3] >> 16) & 0xFFFF) << 0);
+
+	packed_record[8] = (packed_record[8] & 0x0000) |
+			   (((rec->key[4] >> 0) & 0xFFFF) << 0);
+	packed_record[9] = (packed_record[9] & 0x0000) |
+			   (((rec->key[4] >> 16) & 0xFFFF) << 0);
+
+	packed_record[10] = (packed_record[10] & 0x0000) |
+			    (((rec->key[5] >> 0) & 0xFFFF) << 0);
+	packed_record[11] = (packed_record[11] & 0x0000) |
+			    (((rec->key[5] >> 16) & 0xFFFF) << 0);
+
+	packed_record[12] = (packed_record[12] & 0x0000) |
+			    (((rec->key[6] >> 0) & 0xFFFF) << 0);
+	packed_record[13] = (packed_record[13] & 0x0000) |
+			    (((rec->key[6] >> 16) & 0xFFFF) << 0);
+
+	packed_record[14] = (packed_record[14] & 0x0000) |
+			    (((rec->key[7] >> 0) & 0xFFFF) << 0);
+	packed_record[15] = (packed_record[15] & 0x0000) |
+			    (((rec->key[7] >> 16) & 0xFFFF) << 0);
+
+	ret = set_raw_egress_record(hw, packed_record, 8, 2,
+				    ROWOFFSET_EGRESSSAKEYRECORD + table_index);
+	if (unlikely(ret))
+		return ret;
+	ret = set_raw_egress_record(hw, packed_record + 8, 8, 2,
+				    ROWOFFSET_EGRESSSAKEYRECORD + table_index -
+					    32);
+	if (unlikely(ret))
+		return ret;
+
+	return 0;
+}
+
+int aq_mss_set_egress_sakey_record(struct aq_hw_s *hw,
+				   const struct aq_mss_egress_sakey_record *rec,
+				   u16 table_index)
+{
+	return AQ_API_CALL_SAFE(set_egress_sakey_record, hw, rec, table_index);
+}
+
+static int get_egress_sakey_record(struct aq_hw_s *hw,
+				   struct aq_mss_egress_sakey_record *rec,
+				   u16 table_index)
+{
+	u16 packed_record[16];
+	int ret;
+
+	if (table_index >= NUMROWS_EGRESSSAKEYRECORD)
+		return -EINVAL;
+
+	ret = get_raw_egress_record(hw, packed_record, 8, 2,
+				    ROWOFFSET_EGRESSSAKEYRECORD + table_index);
+	if (unlikely(ret))
+		return ret;
+	ret = get_raw_egress_record(hw, packed_record + 8, 8, 2,
+				    ROWOFFSET_EGRESSSAKEYRECORD + table_index -
+					    32);
+	if (unlikely(ret))
+		return ret;
+
+	rec->key[0] = (rec->key[0] & 0xFFFF0000) |
+		      (((packed_record[0] >> 0) & 0xFFFF) << 0);
+	rec->key[0] = (rec->key[0] & 0x0000FFFF) |
+		      (((packed_record[1] >> 0) & 0xFFFF) << 16);
+
+	rec->key[1] = (rec->key[1] & 0xFFFF0000) |
+		      (((packed_record[2] >> 0) & 0xFFFF) << 0);
+	rec->key[1] = (rec->key[1] & 0x0000FFFF) |
+		      (((packed_record[3] >> 0) & 0xFFFF) << 16);
+
+	rec->key[2] = (rec->key[2] & 0xFFFF0000) |
+		      (((packed_record[4] >> 0) & 0xFFFF) << 0);
+	rec->key[2] = (rec->key[2] & 0x0000FFFF) |
+		      (((packed_record[5] >> 0) & 0xFFFF) << 16);
+
+	rec->key[3] = (rec->key[3] & 0xFFFF0000) |
+		      (((packed_record[6] >> 0) & 0xFFFF) << 0);
+	rec->key[3] = (rec->key[3] & 0x0000FFFF) |
+		      (((packed_record[7] >> 0) & 0xFFFF) << 16);
+
+	rec->key[4] = (rec->key[4] & 0xFFFF0000) |
+		      (((packed_record[8] >> 0) & 0xFFFF) << 0);
+	rec->key[4] = (rec->key[4] & 0x0000FFFF) |
+		      (((packed_record[9] >> 0) & 0xFFFF) << 16);
+
+	rec->key[5] = (rec->key[5] & 0xFFFF0000) |
+		      (((packed_record[10] >> 0) & 0xFFFF) << 0);
+	rec->key[5] = (rec->key[5] & 0x0000FFFF) |
+		      (((packed_record[11] >> 0) & 0xFFFF) << 16);
+
+	rec->key[6] = (rec->key[6] & 0xFFFF0000) |
+		      (((packed_record[12] >> 0) & 0xFFFF) << 0);
+	rec->key[6] = (rec->key[6] & 0x0000FFFF) |
+		      (((packed_record[13] >> 0) & 0xFFFF) << 16);
+
+	rec->key[7] = (rec->key[7] & 0xFFFF0000) |
+		      (((packed_record[14] >> 0) & 0xFFFF) << 0);
+	rec->key[7] = (rec->key[7] & 0x0000FFFF) |
+		      (((packed_record[15] >> 0) & 0xFFFF) << 16);
+
+	return 0;
+}
+
+int aq_mss_get_egress_sakey_record(struct aq_hw_s *hw,
+				   struct aq_mss_egress_sakey_record *rec,
+				   u16 table_index)
+{
+	memset(rec, 0, sizeof(*rec));
+
+	return AQ_API_CALL_SAFE(get_egress_sakey_record, hw, rec, table_index);
+}
+
+static int get_egress_sa_expired(struct aq_hw_s *hw, u32 *expired)
+{
+	u16 val;
+	int ret;
+
+	ret = aq_mss_mdio_read(hw, MDIO_MMD_VEND1,
+			       MSS_EGRESS_SA_EXPIRED_STATUS_REGISTER_ADDR,
+			       &val);
+	if (unlikely(ret))
+		return ret;
+
+	*expired = val;
+
+	ret = aq_mss_mdio_read(hw, MDIO_MMD_VEND1,
+			       MSS_EGRESS_SA_EXPIRED_STATUS_REGISTER_ADDR + 1,
+			       &val);
+	if (unlikely(ret))
+		return ret;
+
+	*expired |= val << 16;
+
+	return 0;
+}
+
+int aq_mss_get_egress_sa_expired(struct aq_hw_s *hw, u32 *expired)
+{
+	*expired = 0;
+
+	return AQ_API_CALL_SAFE(get_egress_sa_expired, hw, expired);
+}
+
+static int get_egress_sa_threshold_expired(struct aq_hw_s *hw,
+					   u32 *expired)
+{
+	u16 val;
+	int ret;
+
+	ret = aq_mss_mdio_read(hw, MDIO_MMD_VEND1,
+		MSS_EGRESS_SA_THRESHOLD_EXPIRED_STATUS_REGISTER_ADDR, &val);
+	if (unlikely(ret))
+		return ret;
+
+	*expired = val;
+
+	ret = aq_mss_mdio_read(hw, MDIO_MMD_VEND1,
+		MSS_EGRESS_SA_THRESHOLD_EXPIRED_STATUS_REGISTER_ADDR + 1, &val);
+	if (unlikely(ret))
+		return ret;
+
+	*expired |= val << 16;
+
+	return 0;
+}
+
+int aq_mss_get_egress_sa_threshold_expired(struct aq_hw_s *hw,
+					   u32 *expired)
+{
+	*expired = 0;
+
+	return AQ_API_CALL_SAFE(get_egress_sa_threshold_expired, hw, expired);
+}
+
+static int set_egress_sa_expired(struct aq_hw_s *hw, u32 expired)
+{
+	int ret;
+
+	ret = aq_mss_mdio_write(hw, MDIO_MMD_VEND1,
+				MSS_EGRESS_SA_EXPIRED_STATUS_REGISTER_ADDR,
+				expired & 0xFFFF);
+	if (unlikely(ret))
+		return ret;
+
+	ret = aq_mss_mdio_write(hw, MDIO_MMD_VEND1,
+				MSS_EGRESS_SA_EXPIRED_STATUS_REGISTER_ADDR + 1,
+				expired >> 16);
+	if (unlikely(ret))
+		return ret;
+
+	return 0;
+}
+
+int aq_mss_set_egress_sa_expired(struct aq_hw_s *hw, u32 expired)
+{
+	return AQ_API_CALL_SAFE(set_egress_sa_expired, hw, expired);
+}
+
+static int set_egress_sa_threshold_expired(struct aq_hw_s *hw, u32 expired)
+{
+	int ret;
+
+	ret = aq_mss_mdio_write(hw, MDIO_MMD_VEND1,
+		MSS_EGRESS_SA_THRESHOLD_EXPIRED_STATUS_REGISTER_ADDR,
+		expired & 0xFFFF);
+	if (unlikely(ret))
+		return ret;
+
+	ret = aq_mss_mdio_write(hw, MDIO_MMD_VEND1,
+		MSS_EGRESS_SA_THRESHOLD_EXPIRED_STATUS_REGISTER_ADDR + 1,
+		expired >> 16);
+	if (unlikely(ret))
+		return ret;
+
+	return 0;
+}
+
+int aq_mss_set_egress_sa_threshold_expired(struct aq_hw_s *hw, u32 expired)
+{
+	return AQ_API_CALL_SAFE(set_egress_sa_threshold_expired, hw, expired);
+}
diff --git a/drivers/net/ethernet/aquantia/atlantic/macsec/macsec_api.h b/drivers/net/ethernet/aquantia/atlantic/macsec/macsec_api.h
new file mode 100644
index 000000000000..cbc1226ae0d7
--- /dev/null
+++ b/drivers/net/ethernet/aquantia/atlantic/macsec/macsec_api.h
@@ -0,0 +1,128 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Atlantic Network Driver
+ * Copyright (C) 2020 Marvell International Ltd.
+ */
+
+#ifndef __MACSEC_API_H__
+#define __MACSEC_API_H__
+
+#include "aq_hw.h"
+#include "macsec_struct.h"
+
+#define NUMROWS_EGRESSCTLFRECORD 24
+#define ROWOFFSET_EGRESSCTLFRECORD 0
+
+#define NUMROWS_EGRESSCLASSRECORD 48
+#define ROWOFFSET_EGRESSCLASSRECORD 0
+
+#define NUMROWS_EGRESSSCRECORD 32
+#define ROWOFFSET_EGRESSSCRECORD 0
+
+#define NUMROWS_EGRESSSARECORD 32
+#define ROWOFFSET_EGRESSSARECORD 32
+
+#define NUMROWS_EGRESSSAKEYRECORD 32
+#define ROWOFFSET_EGRESSSAKEYRECORD 96
+
+/*!  Read the raw table data from the specified row of the Egress CTL
+ *   Filter table, and unpack it into the fields of rec.
+ *  rec - [OUT] The raw table row data will be unpacked into the fields of rec.
+ *  table_index - The table row to read (max 23).
+ */
+int aq_mss_get_egress_ctlf_record(struct aq_hw_s *hw,
+				  struct aq_mss_egress_ctlf_record *rec,
+				  u16 table_index);
+
+/*!  Pack the fields of rec, and write the packed data into the
+ *   specified row of the Egress CTL Filter table.
+ *  rec - [IN] The bitfield values to write to the table row.
+ *  table_index - The table row to write(max 23).
+ */
+int aq_mss_set_egress_ctlf_record(struct aq_hw_s *hw,
+				  const struct aq_mss_egress_ctlf_record *rec,
+				  u16 table_index);
+
+/*!  Read the raw table data from the specified row of the Egress
+ *   Packet Classifier table, and unpack it into the fields of rec.
+ *  rec - [OUT] The raw table row data will be unpacked into the fields of rec.
+ *  table_index - The table row to read (max 47).
+ */
+int aq_mss_get_egress_class_record(struct aq_hw_s *hw,
+				   struct aq_mss_egress_class_record *rec,
+				   u16 table_index);
+
+/*!  Pack the fields of rec, and write the packed data into the
+ *   specified row of the Egress Packet Classifier table.
+ *  rec - [IN] The bitfield values to write to the table row.
+ *  table_index - The table row to write (max 47).
+ */
+int aq_mss_set_egress_class_record(struct aq_hw_s *hw,
+				   const struct aq_mss_egress_class_record *rec,
+				   u16 table_index);
+
+/*!  Read the raw table data from the specified row of the Egress SC
+ *   Lookup table, and unpack it into the fields of rec.
+ *  rec - [OUT] The raw table row data will be unpacked into the fields of rec.
+ *  table_index - The table row to read (max 31).
+ */
+int aq_mss_get_egress_sc_record(struct aq_hw_s *hw,
+				struct aq_mss_egress_sc_record *rec,
+				u16 table_index);
+
+/*!  Pack the fields of rec, and write the packed data into the
+ *   specified row of the Egress SC Lookup table.
+ *  rec - [IN] The bitfield values to write to the table row.
+ *  table_index - The table row to write (max 31).
+ */
+int aq_mss_set_egress_sc_record(struct aq_hw_s *hw,
+				const struct aq_mss_egress_sc_record *rec,
+				u16 table_index);
+
+/*!  Read the raw table data from the specified row of the Egress SA
+ *   Lookup table, and unpack it into the fields of rec.
+ *  rec - [OUT] The raw table row data will be unpacked into the fields of rec.
+ *  table_index - The table row to read (max 31).
+ */
+int aq_mss_get_egress_sa_record(struct aq_hw_s *hw,
+				struct aq_mss_egress_sa_record *rec,
+				u16 table_index);
+
+/*!  Pack the fields of rec, and write the packed data into the
+ *   specified row of the Egress SA Lookup table.
+ *  rec  - [IN] The bitfield values to write to the table row.
+ *  table_index - The table row to write (max 31).
+ */
+int aq_mss_set_egress_sa_record(struct aq_hw_s *hw,
+				const struct aq_mss_egress_sa_record *rec,
+				u16 table_index);
+
+/*!  Read the raw table data from the specified row of the Egress SA
+ *   Key Lookup table, and unpack it into the fields of rec.
+ *  rec - [OUT] The raw table row data will be unpacked into the fields of rec.
+ *  table_index - The table row to read (max 31).
+ */
+int aq_mss_get_egress_sakey_record(struct aq_hw_s *hw,
+				   struct aq_mss_egress_sakey_record *rec,
+				   u16 table_index);
+
+/*!  Pack the fields of rec, and write the packed data into the
+ *   specified row of the Egress SA Key Lookup table.
+ *  rec - [IN] The bitfield values to write to the table row.
+ *  table_index - The table row to write (max 31).
+ */
+int aq_mss_set_egress_sakey_record(struct aq_hw_s *hw,
+				   const struct aq_mss_egress_sakey_record *rec,
+				   u16 table_index);
+
+/*!  Get Egress SA expired. */
+int aq_mss_get_egress_sa_expired(struct aq_hw_s *hw, u32 *expired);
+/*!  Get Egress SA threshold expired. */
+int aq_mss_get_egress_sa_threshold_expired(struct aq_hw_s *hw,
+					   u32 *expired);
+/*!  Set Egress SA expired. */
+int aq_mss_set_egress_sa_expired(struct aq_hw_s *hw, u32 expired);
+/*!  Set Egress SA threshold expired. */
+int aq_mss_set_egress_sa_threshold_expired(struct aq_hw_s *hw,
+					   u32 expired);
+
+#endif /* __MACSEC_API_H__ */
diff --git a/drivers/net/ethernet/aquantia/atlantic/macsec/macsec_struct.h b/drivers/net/ethernet/aquantia/atlantic/macsec/macsec_struct.h
new file mode 100644
index 000000000000..7232bec643db
--- /dev/null
+++ b/drivers/net/ethernet/aquantia/atlantic/macsec/macsec_struct.h
@@ -0,0 +1,317 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Atlantic Network Driver
+ * Copyright (C) 2020 Marvell International Ltd.
+ */
+
+#ifndef _MACSEC_STRUCT_H_
+#define _MACSEC_STRUCT_H_
+
+/*! Represents the bitfields of a single row in the Egress CTL Filter
+ *  table.
+ */
+struct aq_mss_egress_ctlf_record {
+	/*! This is used to store the 48 bit value used to compare SA, DA or
+	 *  halfDA+half SA value.
+	 */
+	u32 sa_da[2];
+	/*! This is used to store the 16 bit ethertype value used for
+	 *  comparison.
+	 */
+	u32 eth_type;
+	/*! The match mask is per-nibble. 0 means don't care, i.e. every value
+	 *  will match successfully. The total data is 64 bit, i.e. 16 nibbles
+	 *  masks.
+	 */
+	u32 match_mask;
+	/*! 0: No compare, i.e. This entry is not used
+	 *  1: compare DA only
+	 *  2: compare SA only
+	 *  3: compare half DA + half SA
+	 *  4: compare ether type only
+	 *  5: compare DA + ethertype
+	 *  6: compare SA + ethertype
+	 *  7: compare DA+ range.
+	 */
+	u32 match_type;
+	/*! 0: Bypass the remaining modules if matched.
+	 *  1: Forward to next module for more classifications.
+	 */
+	u32 action;
+};
+
+/*! Represents the bitfields of a single row in the Egress Packet
+ *  Classifier table.
+ */
+struct aq_mss_egress_class_record {
+	/*! VLAN ID field. */
+	u32 vlan_id;
+	/*! VLAN UP field. */
+	u32 vlan_up;
+	/*! VLAN Present in the Packet. */
+	u32 vlan_valid;
+	/*! The 8 bit value used to compare with extracted value for byte 3. */
+	u32 byte3;
+	/*! The 8 bit value used to compare with extracted value for byte 2. */
+	u32 byte2;
+	/*! The 8 bit value used to compare with extracted value for byte 1. */
+	u32 byte1;
+	/*! The 8 bit value used to compare with extracted value for byte 0. */
+	u32 byte0;
+	/*! The 8 bit TCI field used to compare with extracted value. */
+	u32 tci;
+	/*! The 64 bit SCI field in the SecTAG. */
+	u32 sci[2];
+	/*! The 16 bit Ethertype (in the clear) field used to compare with
+	 *  extracted value.
+	 */
+	u32 eth_type;
+	/*! This is to specify the 40bit SNAP header if the SNAP header's mask
+	 *  is enabled.
+	 */
+	u32 snap[2];
+	/*! This is to specify the 24bit LLC header if the LLC header's mask is
+	 *  enabled.
+	 */
+	u32 llc;
+	/*! The 48 bit MAC_SA field used to compare with extracted value. */
+	u32 mac_sa[2];
+	/*! The 48 bit MAC_DA field used to compare with extracted value. */
+	u32 mac_da[2];
+	/*! The 32 bit Packet number used to compare with extracted value. */
+	u32 pn;
+	/*! 0~63: byte location used extracted by packets comparator, which
+	 *  can be anything from the first 64 bytes of the MAC packets.
+	 *  This byte location counted from MAC' DA address. i.e. set to 0
+	 *  will point to byte 0 of DA address.
+	 */
+	u32 byte3_location;
+	/*! 0: don't care
+	 *  1: enable comparison of extracted byte pointed by byte 3 location.
+	 */
+	u32 byte3_mask;
+	/*! 0~63: byte location used extracted by packets comparator, which
+	 *  can be anything from the first 64 bytes of the MAC packets.
+	 *  This byte location counted from MAC' DA address. i.e. set to 0
+	 *  will point to byte 0 of DA address.
+	 */
+	u32 byte2_location;
+	/*! 0: don't care
+	 *  1: enable comparison of extracted byte pointed by byte 2 location.
+	 */
+	u32 byte2_mask;
+	/*! 0~63: byte location used extracted by packets comparator, which
+	 *  can be anything from the first 64 bytes of the MAC packets.
+	 *  This byte location counted from MAC' DA address. i.e. set to 0
+	 *  will point to byte 0 of DA address.
+	 */
+	u32 byte1_location;
+	/*! 0: don't care
+	 *  1: enable comparison of extracted byte pointed by byte 1 location.
+	 */
+	u32 byte1_mask;
+	/*! 0~63: byte location used extracted by packets comparator, which
+	 *  can be anything from the first 64 bytes of the MAC packets.
+	 *  This byte location counted from MAC' DA address. i.e. set to 0
+	 *  will point to byte 0 of DA address.
+	 */
+	u32 byte0_location;
+	/*! 0: don't care
+	 *  1: enable comparison of extracted byte pointed by byte 0 location.
+	 */
+	u32 byte0_mask;
+	/*! Mask is per-byte.
+	 *  0: don't care
+	 *  1: enable comparison of extracted VLAN ID field.
+	 */
+	u32 vlan_id_mask;
+	/*! 0: don't care
+	 *  1: enable comparison of extracted VLAN UP field.
+	 */
+	u32 vlan_up_mask;
+	/*! 0: don't care
+	 *  1: enable comparison of extracted VLAN Valid field.
+	 */
+	u32 vlan_valid_mask;
+	/*! This is bit mask to enable comparison the 8 bit TCI field,
+	 *  including the AN field.
+	 *  For explicit SECTAG, AN is hardware controlled. For sending
+	 *  packet w/ explicit SECTAG, rest of the TCI fields are directly
+	 *  from the SECTAG.
+	 */
+	u32 tci_mask;
+	/*! Mask is per-byte.
+	 *  0: don't care
+	 *  1: enable comparison of SCI
+	 *  Note: If this field is not 0, this means the input packet's
+	 *  SECTAG is explicitly tagged and MACSEC module will only update
+	 *  the MSDU.
+	 *  PN number is hardware controlled.
+	 */
+	u32 sci_mask;
+	/*! Mask is per-byte.
+	 *  0: don't care
+	 *  1: enable comparison of Ethertype.
+	 */
+	u32 eth_type_mask;
+	/*! Mask is per-byte.
+	 *  0: don't care and no SNAP header exist.
+	 *  1: compare the SNAP header.
+	 *  If this bit is set to 1, the extracted filed will assume the
+	 *  SNAP header exist as encapsulated in 802.3 (RFC 1042). I.E. the
+	 *  next 5 bytes after the the LLC header is SNAP header.
+	 */
+	u32 snap_mask;
+	/*! 0: don't care and no LLC header exist.
+	 *  1: compare the LLC header.
+	 *  If this bit is set to 1, the extracted filed will assume the
+	 *  LLC header exist as encapsulated in 802.3 (RFC 1042). I.E. the
+	 *  next three bytes after the 802.3MAC header is LLC header.
+	 */
+	u32 llc_mask;
+	/*! Mask is per-byte.
+	 *  0: don't care
+	 *  1: enable comparison of MAC_SA.
+	 */
+	u32 sa_mask;
+	/*! Mask is per-byte.
+	 *  0: don't care
+	 *  1: enable comparison of MAC_DA.
+	 */
+	u32 da_mask;
+	/*! Mask is per-byte. */
+	u32 pn_mask;
+	/*! Reserved. This bit should be always 0. */
+	u32 eight02dot2;
+	/*! 1: For explicit sectag case use TCI_SC from table
+	 *  0: use TCI_SC from explicit sectag.
+	 */
+	u32 tci_sc;
+	/*! 1: For explicit sectag case,use TCI_V,ES,SCB,E,C from table
+	 *  0: use TCI_V,ES,SCB,E,C from explicit sectag.
+	 */
+	u32 tci_87543;
+	/*! 1: indicates that incoming packet has explicit sectag. */
+	u32 exp_sectag_en;
+	/*! If packet matches and tagged as controlled-packet, this SC/SA
+	 *  index is used for later SC and SA table lookup.
+	 */
+	u32 sc_idx;
+	/*! This field is used to specify how many SA entries are
+	 *  associated with 1 SC entry.
+	 *  2'b00: 1 SC has 4 SA.
+	 *  SC index is equivalent to {SC_Index[4:2], 1'b0}.
+	 *  SA index is equivalent to {SC_Index[4:2], SC entry's current AN[1:0]
+	 *  2'b10: 1 SC has 2 SA.
+	 *  SC index is equivalent to SC_Index[4:1]
+	 *  SA index is equivalent to {SC_Index[4:1], SC entry's current AN[0]}
+	 *  2'b11: 1 SC has 1 SA. No SC entry exists for the specific SA.
+	 *  SA index is equivalent to SC_Index[4:0]
+	 *  Note: if specified as 2'b11, hardware AN roll over is not
+	 *  supported.
+	 */
+	u32 sc_sa;
+	/*! 0: the packets will be sent to MAC FIFO
+	 *  1: The packets will be sent to Debug/Loopback FIFO.
+	 *  If the above's action is drop, this bit has no meaning.
+	 */
+	u32 debug;
+	/*! 0: forward to remaining modules
+	 *  1: bypass the next encryption modules. This packet is considered
+	 *     un-control packet.
+	 *  2: drop
+	 *  3: Reserved.
+	 */
+	u32 action;
+	/*! 0: Not valid entry. This entry is not used
+	 *  1: valid entry.
+	 */
+	u32 valid;
+};
+
+/*! Represents the bitfields of a single row in the Egress SC Lookup table. */
+struct aq_mss_egress_sc_record {
+	/*! This is to specify when the SC was first used. Set by HW. */
+	u32 start_time;
+	/*! This is to specify when the SC was last used. Set by HW. */
+	u32 stop_time;
+	/*! This is to specify which of the SA entries are used by current HW.
+	 *  Note: This value need to be set by SW after reset.  It will be
+	 *  automatically updated by HW, if AN roll over is enabled.
+	 */
+	u32 curr_an;
+	/*! 0: Clear the SA Valid Bit after PN expiry.
+	 *  1: Do not Clear the SA Valid bit after PN expiry of the current SA.
+	 *  When the Enable AN roll over is set, S/W does not need to
+	 *  program the new SA's and the H/W will automatically roll over
+	 *  between the SA's without session expiry.
+	 *  For normal operation, Enable AN Roll over will be set to '0'
+	 *  and in which case, the SW needs to program the new SA values
+	 *  after the current PN expires.
+	 */
+	u32 an_roll;
+	/*! This is the TCI field used if packet is not explicitly tagged. */
+	u32 tci;
+	/*! This value indicates the offset where the decryption will start.
+	 *  [[Values of 0, 4, 8-50].
+	 */
+	u32 enc_off;
+	/*! 0: Do not protect frames, all the packets will be forwarded
+	 *     unchanged. MIB counter (OutPktsUntagged) will be updated.
+	 *  1: Protect.
+	 */
+	u32 protect;
+	/*! 0: when none of the SA related to SC has inUse set.
+	 *  1: when either of the SA related to the SC has inUse set.
+	 *  This bit is set by HW.
+	 */
+	u32 recv;
+	/*! 0: H/W Clears this bit on the first use.
+	 *  1: SW updates this entry, when programming the SC Table.
+	 */
+	u32 fresh;
+	/*! AES Key size
+	 *  00 - 128bits
+	 *  01 - 192bits
+	 *  10 - 256bits
+	 *  11 - Reserved.
+	 */
+	u32 sak_len;
+	/*! 0: Invalid SC
+	 *  1: Valid SC.
+	 */
+	u32 valid;
+};
+
+/*! Represents the bitfields of a single row in the Egress SA Lookup table. */
+struct aq_mss_egress_sa_record {
+	/*! This is to specify when the SC was first used. Set by HW. */
+	u32 start_time;
+	/*! This is to specify when the SC was last used. Set by HW. */
+	u32 stop_time;
+	/*! This is set by SW and updated by HW to store the Next PN number
+	 *  used for encryption.
+	 */
+	u32 next_pn;
+	/*! The Next_PN number is going to wrapped around from 0xFFFF_FFFF
+	 *  to 0. set by HW.
+	 */
+	u32 sat_pn;
+	/*! 0: This SA is in use.
+	 *  1: This SA is Fresh and set by SW.
+	 */
+	u32 fresh;
+	/*! 0: Invalid SA
+	 *  1: Valid SA.
+	 */
+	u32 valid;
+};
+
+/*! Represents the bitfields of a single row in the Egress SA Key
+ *  Lookup table.
+ */
+struct aq_mss_egress_sakey_record {
+	/*! Key for AES-GCM processing. */
+	u32 key[8];
+};
+
+#endif
-- 
2.17.1

