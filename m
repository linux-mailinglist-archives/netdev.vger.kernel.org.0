Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD0D1BF20C
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 10:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbgD3IFl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 04:05:41 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:6774 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726770AbgD3IFh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 04:05:37 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03U852cL011045;
        Thu, 30 Apr 2020 01:05:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=SxK1lhRTlHfqST71J1QJtf14sOO8XKAzr7Cisz1W2Cw=;
 b=hX8hcn7EY4uQF8E7eqEKRMLUTvj08ZMvWbMNz/Y2s69meD+hQ8mnuWEgsxt77QauFHSz
 zJ1SJchB48EsIFGEDsxyVA1ALrICzC1sXH6CK1qONm0GkKW7gPy0RO5T95JQgkevXRUP
 o//K/yf5AhVO+wt3f3IuKGg7Q2LpLIQcyaEguOeY7+x3mSBcVYsP7QGlVJlj2TBnjp8z
 ViUTk/pv2EXoWNOhYKls+j5iYkeVkUl2zhK/n4+5/z2lLQi/v7q2Tuzn/zZiPyIp4nOp
 dOf961cD4VcqkVr9ZEKtHsh7cFPzmQ88BIDwQeoS8vwZExGCzJlsMoIqKSIn2tXsTjOt 4g== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 30mjjqnsmy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 30 Apr 2020 01:05:36 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 30 Apr
 2020 01:05:34 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 30 Apr 2020 01:05:34 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id C290B3F7041;
        Thu, 30 Apr 2020 01:05:32 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>,
        "Igor Russkikh" <irusskikh@marvell.com>
Subject: [PATCH v2 net-next 15/17] net: atlantic: common functions needed for basic A2 init/deinit hw_ops
Date:   Thu, 30 Apr 2020 11:04:43 +0300
Message-ID: <20200430080445.1142-16-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200430080445.1142-1-irusskikh@marvell.com>
References: <20200430080445.1142-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-30_02:2020-04-30,2020-04-30 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Bogdanov <dbogdanov@marvell.com>

This patch adds common functions (mostly FW-related), which are
needed for basic A2 HW initialization / deinitialization.

Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
Co-developed-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
---
 .../net/ethernet/aquantia/atlantic/Makefile   |   1 +
 .../aquantia/atlantic/hw_atl/hw_atl_utils.c   |   3 +-
 .../aquantia/atlantic/hw_atl/hw_atl_utils.h   |   2 +
 .../aquantia/atlantic/hw_atl2/hw_atl2_utils.c | 139 ++++++++++++++++++
 .../aquantia/atlantic/hw_atl2/hw_atl2_utils.h |   8 +
 .../atlantic/hw_atl2/hw_atl2_utils_fw.c       |  12 ++
 6 files changed, 163 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils.c

diff --git a/drivers/net/ethernet/aquantia/atlantic/Makefile b/drivers/net/ethernet/aquantia/atlantic/Makefile
index 23f0e5b5fcdb..130a105d03f3 100644
--- a/drivers/net/ethernet/aquantia/atlantic/Makefile
+++ b/drivers/net/ethernet/aquantia/atlantic/Makefile
@@ -26,6 +26,7 @@ atlantic-objs := aq_main.o \
 	hw_atl/hw_atl_utils_fw2x.o \
 	hw_atl/hw_atl_llh.o \
 	hw_atl2/hw_atl2.o \
+	hw_atl2/hw_atl2_utils.o \
 	hw_atl2/hw_atl2_utils_fw.o \
 	hw_atl2/hw_atl2_llh.o \
 	macsec/macsec_api.o
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
index 20655a2170cc..1100d40a0302 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
@@ -53,7 +53,6 @@ enum mcp_area {
 	MCP_AREA_SETTINGS = 0x20000000,
 };
 
-static int hw_atl_utils_ver_match(u32 ver_expected, u32 ver_actual);
 static int hw_atl_utils_mpi_set_state(struct aq_hw_s *self,
 				      enum hal_atl_utils_fw_state_e state);
 static u32 hw_atl_utils_get_mpi_mbox_tid(struct aq_hw_s *self);
@@ -434,7 +433,7 @@ int hw_atl_write_fwsettings_dwords(struct aq_hw_s *self, u32 offset, u32 *p,
 					     p, cnt, MCP_AREA_SETTINGS);
 }
 
-static int hw_atl_utils_ver_match(u32 ver_expected, u32 ver_actual)
+int hw_atl_utils_ver_match(u32 ver_expected, u32 ver_actual)
 {
 	const u32 dw_major_mask = 0xff000000U;
 	const u32 dw_minor_mask = 0x00ffffffU;
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h
index 5db57ea9a5bd..99c1b6644ec3 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h
@@ -634,6 +634,8 @@ int hw_atl_utils_fw_rpc_call(struct aq_hw_s *self, unsigned int rpc_size);
 int hw_atl_utils_fw_rpc_wait(struct aq_hw_s *self,
 			     struct hw_atl_utils_fw_rpc **rpc);
 
+int hw_atl_utils_ver_match(u32 ver_expected, u32 ver_actual);
+
 extern const struct aq_fw_ops aq_fw_1x_ops;
 extern const struct aq_fw_ops aq_fw_2x_ops;
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils.c
new file mode 100644
index 000000000000..85ccc9a011a0
--- /dev/null
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils.c
@@ -0,0 +1,139 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Atlantic Network Driver
+ * Copyright (C) 2020 Marvell International Ltd.
+ */
+
+#include <linux/iopoll.h>
+
+#include "aq_hw_utils.h"
+#include "hw_atl/hw_atl_utils.h"
+#include "hw_atl2_utils.h"
+#include "hw_atl2_llh.h"
+#include "hw_atl2_llh_internal.h"
+
+#define HW_ATL2_FW_VER_1X          0x01000000U
+
+#define AQ_A2_BOOT_STARTED         BIT(0x18)
+#define AQ_A2_CRASH_INIT           BIT(0x1B)
+#define AQ_A2_BOOT_CODE_FAILED     BIT(0x1C)
+#define AQ_A2_FW_INIT_FAILED       BIT(0x1D)
+#define AQ_A2_FW_INIT_COMP_SUCCESS BIT(0x1F)
+
+#define AQ_A2_FW_BOOT_FAILED_MASK (AQ_A2_CRASH_INIT | \
+				   AQ_A2_BOOT_CODE_FAILED | \
+				   AQ_A2_FW_INIT_FAILED)
+#define AQ_A2_FW_BOOT_COMPLETE_MASK (AQ_A2_FW_BOOT_FAILED_MASK | \
+				     AQ_A2_FW_INIT_COMP_SUCCESS)
+
+#define AQ_A2_FW_BOOT_REQ_REBOOT        BIT(0x0)
+#define AQ_A2_FW_BOOT_REQ_HOST_BOOT     BIT(0x8)
+#define AQ_A2_FW_BOOT_REQ_MAC_FAST_BOOT BIT(0xA)
+#define AQ_A2_FW_BOOT_REQ_PHY_FAST_BOOT BIT(0xB)
+
+int hw_atl2_utils_initfw(struct aq_hw_s *self, const struct aq_fw_ops **fw_ops)
+{
+	int err;
+
+	self->fw_ver_actual = hw_atl2_utils_get_fw_version(self);
+
+	if (hw_atl_utils_ver_match(HW_ATL2_FW_VER_1X,
+				   self->fw_ver_actual) == 0) {
+		*fw_ops = &aq_a2_fw_ops;
+	} else {
+		aq_pr_err("Bad FW version detected: %x, but continue\n",
+			  self->fw_ver_actual);
+		*fw_ops = &aq_a2_fw_ops;
+	}
+	aq_pr_trace("Detect ATL2FW %x\n", self->fw_ver_actual);
+	self->aq_fw_ops = *fw_ops;
+	err = self->aq_fw_ops->init(self);
+
+	self->chip_features |= ATL_HW_CHIP_ANTIGUA;
+
+	return err;
+}
+
+static bool hw_atl2_mcp_boot_complete(struct aq_hw_s *self)
+{
+	u32 rbl_status;
+
+	rbl_status = hw_atl2_mif_mcp_boot_reg_get(self);
+	if (rbl_status & AQ_A2_FW_BOOT_COMPLETE_MASK)
+		return true;
+
+	/* Host boot requested */
+	if (hw_atl2_mif_host_req_int_get(self) & HW_ATL2_MCP_HOST_REQ_INT_READY)
+		return true;
+
+	return false;
+}
+
+int hw_atl2_utils_soft_reset(struct aq_hw_s *self)
+{
+	bool rbl_complete = false;
+	u32 rbl_status = 0;
+	u32 rbl_request;
+	int err;
+
+	err = readx_poll_timeout_atomic(hw_atl2_mif_mcp_boot_reg_get, self,
+				rbl_status,
+				((rbl_status & AQ_A2_BOOT_STARTED) &&
+				 (rbl_status != 0xFFFFFFFFu)),
+				10, 500000);
+	if (err)
+		aq_pr_trace("Boot code probably hanged, reboot anyway");
+
+	hw_atl2_mif_host_req_int_clr(self, 0x01);
+	rbl_request = AQ_A2_FW_BOOT_REQ_REBOOT;
+#ifdef AQ_CFG_FAST_START
+	rbl_request |= AQ_A2_FW_BOOT_REQ_MAC_FAST_BOOT;
+#endif
+	hw_atl2_mif_mcp_boot_reg_set(self, rbl_request);
+
+	/* Wait for RBL boot */
+	err = readx_poll_timeout_atomic(hw_atl2_mif_mcp_boot_reg_get, self,
+				rbl_status,
+				((rbl_status & AQ_A2_BOOT_STARTED) &&
+				 (rbl_status != 0xFFFFFFFFu)),
+				10, 200000);
+	if (err) {
+		aq_pr_err("Boot code hanged");
+		goto err_exit;
+	}
+
+	err = readx_poll_timeout_atomic(hw_atl2_mcp_boot_complete, self,
+					rbl_complete,
+					rbl_complete,
+					10, 2000000);
+
+	if (err) {
+		aq_pr_err("FW Restart timed out");
+		goto err_exit;
+	}
+
+	rbl_status = hw_atl2_mif_mcp_boot_reg_get(self);
+
+	if (rbl_status & AQ_A2_FW_BOOT_FAILED_MASK) {
+		err = -EIO;
+		aq_pr_err("FW Restart failed");
+		goto err_exit;
+	}
+
+	if (hw_atl2_mif_host_req_int_get(self) &
+	    HW_ATL2_MCP_HOST_REQ_INT_READY) {
+		err = -EIO;
+		aq_pr_err("No FW detected. Dynamic FW load not implemented");
+		goto err_exit;
+	}
+
+	if (self->aq_fw_ops) {
+		err = self->aq_fw_ops->init(self);
+		if (err) {
+			aq_pr_err("FW Init failed");
+			goto err_exit;
+		}
+	}
+
+err_exit:
+	return err;
+}
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils.h
index 5421fbed3db5..2317dd8459d0 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils.h
@@ -6,6 +6,8 @@
 #ifndef HW_ATL2_UTILS_H
 #define HW_ATL2_UTILS_H
 
+#include "aq_hw.h"
+
 /* F W    A P I */
 
 struct link_options_s {
@@ -590,6 +592,12 @@ struct fw_interface_out {
 #define  AQ_HOST_MODE_LOW_POWER    3U
 #define  AQ_HOST_MODE_SHUTDOWN     4U
 
+int hw_atl2_utils_initfw(struct aq_hw_s *self, const struct aq_fw_ops **fw_ops);
+
+int hw_atl2_utils_soft_reset(struct aq_hw_s *self);
+
+u32 hw_atl2_utils_get_fw_version(struct aq_hw_s *self);
+
 int hw_atl2_utils_get_action_resolve_table_caps(struct aq_hw_s *self,
 						u8 *base_index, u8 *count);
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
index c3e0e5575810..f5fb4b11f51a 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
@@ -301,6 +301,18 @@ static int aq_a2_fw_renegotiate(struct aq_hw_s *self)
 	return err;
 }
 
+u32 hw_atl2_utils_get_fw_version(struct aq_hw_s *self)
+{
+	struct version_s version;
+
+	hw_atl2_shared_buffer_read_safe(self, version, &version);
+
+	/* A2 FW version is stored in reverse order */
+	return version.mac.major << 24 |
+	       version.mac.minor << 16 |
+	       version.mac.build;
+}
+
 int hw_atl2_utils_get_action_resolve_table_caps(struct aq_hw_s *self,
 						u8 *base_index, u8 *count)
 {
-- 
2.20.1

