Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40E3DA3159
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 09:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727889AbfH3Hmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 03:42:31 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:63036 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727595AbfH3Hma (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 03:42:30 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7U7dlu0026578;
        Fri, 30 Aug 2019 00:42:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=41hQPZAQkm6Da9Ya/uA7Uw+VfiZy2UXyu0/1b8ucmZE=;
 b=mDh1ompWXIS8I50jZj+5LHpRcPwJ49gKoj95JVDHxo8rEORG9Kz+zSGR+jEe/YpEkS8x
 Z+5wQJ7PWdobLV3IDaYy0ODc4z2UJIk5SzeJKGDgtKuAncN5CPvNBYzTB3EhbPcdNguj
 avFz6PTgUEQ16xwgt3obpv0AlZ8j7UQptPzOqxNIQIrdLlT1KSEd7hU2its09cXt7/es
 ByflmGitTMMBmRjgu+M/wcjXCn3Fj820gSIabHs0jkxo4uo9X+8dkZBg2TCM2qqpZHNQ
 SvaqDRhgNWOPsPYKK0wFV/r5/lTDbWtfLGCANW0H3+JmgO1W+rkSC2yxp70wHrV5JhB3 Iw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2upmepjc22-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 30 Aug 2019 00:42:28 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Fri, 30 Aug
 2019 00:42:26 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Fri, 30 Aug 2019 00:42:26 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 9A7293F704A;
        Fri, 30 Aug 2019 00:42:26 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x7U7gQmj008888;
        Fri, 30 Aug 2019 00:42:26 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x7U7gQWi008887;
        Fri, 30 Aug 2019 00:42:26 -0700
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <mkalderon@marvell.com>,
        <aelior@marvell.com>
Subject: [PATCH net-next 3/4] qed: Add APIs for configuring grc dump config flags.
Date:   Fri, 30 Aug 2019 00:42:05 -0700
Message-ID: <20190830074206.8836-4-skalluru@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20190830074206.8836-1-skalluru@marvell.com>
References: <20190830074206.8836-1-skalluru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-08-30_03:2019-08-29,2019-08-30 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch adds driver support for configuring the grc dump config flags.

Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_debug.c | 82 +++++++++++++++++++++++++++++
 drivers/net/ethernet/qlogic/qed/qed_hsi.h   | 15 ++++++
 drivers/net/ethernet/qlogic/qed/qed_main.c  | 21 ++++++++
 include/linux/qed/qed_if.h                  |  9 ++++
 4 files changed, 127 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_debug.c b/drivers/net/ethernet/qlogic/qed/qed_debug.c
index 5ea6c4f..859caa6 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_debug.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_debug.c
@@ -1756,6 +1756,15 @@ static u32 qed_read_unaligned_dword(u8 *buf)
 	return dword;
 }
 
+/* Sets the value of the specified GRC param */
+static void qed_grc_set_param(struct qed_hwfn *p_hwfn,
+			      enum dbg_grc_params grc_param, u32 val)
+{
+	struct dbg_tools_data *dev_data = &p_hwfn->dbg_info;
+
+	dev_data->grc.param_val[grc_param] = val;
+}
+
 /* Returns the value of the specified GRC param */
 static u32 qed_grc_get_param(struct qed_hwfn *p_hwfn,
 			     enum dbg_grc_params grc_param)
@@ -5119,6 +5128,69 @@ bool qed_read_fw_info(struct qed_hwfn *p_hwfn,
 	return false;
 }
 
+enum dbg_status qed_dbg_grc_config(struct qed_hwfn *p_hwfn,
+				   struct qed_ptt *p_ptt,
+				   enum dbg_grc_params grc_param, u32 val)
+{
+	enum dbg_status status;
+	int i;
+
+	DP_VERBOSE(p_hwfn, QED_MSG_DEBUG,
+		   "dbg_grc_config: paramId = %d, val = %d\n", grc_param, val);
+
+	status = qed_dbg_dev_init(p_hwfn, p_ptt);
+	if (status != DBG_STATUS_OK)
+		return status;
+
+	/* Initializes the GRC parameters (if not initialized). Needed in order
+	 * to set the default parameter values for the first time.
+	 */
+	qed_dbg_grc_init_params(p_hwfn);
+
+	if (grc_param >= MAX_DBG_GRC_PARAMS)
+		return DBG_STATUS_INVALID_ARGS;
+	if (val < s_grc_param_defs[grc_param].min ||
+	    val > s_grc_param_defs[grc_param].max)
+		return DBG_STATUS_INVALID_ARGS;
+
+	if (s_grc_param_defs[grc_param].is_preset) {
+		/* Preset param */
+
+		/* Disabling a preset is not allowed. Call
+		 * dbg_grc_set_params_default instead.
+		 */
+		if (!val)
+			return DBG_STATUS_INVALID_ARGS;
+
+		/* Update all params with the preset values */
+		for (i = 0; i < MAX_DBG_GRC_PARAMS; i++) {
+			u32 preset_val;
+
+			/* Skip persistent params */
+			if (s_grc_param_defs[i].is_persistent)
+				continue;
+
+			/* Find preset value */
+			if (grc_param == DBG_GRC_PARAM_EXCLUDE_ALL)
+				preset_val =
+				    s_grc_param_defs[i].exclude_all_preset_val;
+			else if (grc_param == DBG_GRC_PARAM_CRASH)
+				preset_val =
+				    s_grc_param_defs[i].crash_preset_val;
+			else
+				return DBG_STATUS_INVALID_ARGS;
+
+			qed_grc_set_param(p_hwfn,
+					  (enum dbg_grc_params)i, preset_val);
+		}
+	} else {
+		/* Regular param - set its value */
+		qed_grc_set_param(p_hwfn, grc_param, val);
+	}
+
+	return DBG_STATUS_OK;
+}
+
 /* Assign default GRC param values */
 void qed_dbg_grc_set_params_default(struct qed_hwfn *p_hwfn)
 {
@@ -7997,9 +8069,16 @@ static u32 qed_calc_regdump_header(enum debug_print_features feature,
 int qed_dbg_all_data(struct qed_dev *cdev, void *buffer)
 {
 	u8 cur_engine, omit_engine = 0, org_engine;
+	struct qed_hwfn *p_hwfn =
+		&cdev->hwfns[cdev->dbg_params.engine_for_debug];
+	struct dbg_tools_data *dev_data = &p_hwfn->dbg_info;
+	int grc_params[MAX_DBG_GRC_PARAMS], i;
 	u32 offset = 0, feature_size;
 	int rc;
 
+	for (i = 0; i < MAX_DBG_GRC_PARAMS; i++)
+		grc_params[i] = dev_data->grc.param_val[i];
+
 	if (cdev->num_hwfns == 1)
 		omit_engine = 1;
 
@@ -8087,6 +8166,9 @@ int qed_dbg_all_data(struct qed_dev *cdev, void *buffer)
 			       rc);
 		}
 
+		for (i = 0; i < MAX_DBG_GRC_PARAMS; i++)
+			dev_data->grc.param_val[i] = grc_params[i];
+
 		/* GRC dump - must be last because when mcp stuck it will
 		 * clutter idle_chk, reg_fifo, ...
 		 */
diff --git a/drivers/net/ethernet/qlogic/qed/qed_hsi.h b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
index 557a12e..cf3ceb6 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_hsi.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
@@ -3024,6 +3024,21 @@ void qed_read_regs(struct qed_hwfn *p_hwfn,
  */
 bool qed_read_fw_info(struct qed_hwfn *p_hwfn,
 		      struct qed_ptt *p_ptt, struct fw_info *fw_info);
+/**
+ * @brief qed_dbg_grc_config - Sets the value of a GRC parameter.
+ *
+ * @param p_hwfn -	HW device data
+ * @param grc_param -	GRC parameter
+ * @param val -		Value to set.
+ *
+ * @return error if one of the following holds:
+ *	- the version wasn't set
+ *	- grc_param is invalid
+ *	- val is outside the allowed boundaries
+ */
+enum dbg_status qed_dbg_grc_config(struct qed_hwfn *p_hwfn,
+				   struct qed_ptt *p_ptt,
+				   enum dbg_grc_params grc_param, u32 val);
 
 /**
  * @brief qed_dbg_grc_set_params_default - Reverts all GRC parameters to their
diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index c9a7571..ac1511a8 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -2583,6 +2583,26 @@ static int qed_read_module_eeprom(struct qed_dev *cdev, char *buf,
 	return rc;
 }
 
+static int qed_set_grc_config(struct qed_dev *cdev, u32 cfg_id, u32 val)
+{
+	struct qed_hwfn *hwfn = QED_LEADING_HWFN(cdev);
+	struct qed_ptt *ptt;
+	int rc = 0;
+
+	if (IS_VF(cdev))
+		return 0;
+
+	ptt = qed_ptt_acquire(hwfn);
+	if (!ptt)
+		return -EAGAIN;
+
+	rc = qed_dbg_grc_config(hwfn, ptt, cfg_id, val);
+
+	qed_ptt_release(hwfn, ptt);
+
+	return rc;
+}
+
 static u8 qed_get_affin_hwfn_idx(struct qed_dev *cdev)
 {
 	return QED_AFFIN_HWFN_IDX(cdev);
@@ -2637,6 +2657,7 @@ static u8 qed_get_affin_hwfn_idx(struct qed_dev *cdev)
 	.read_module_eeprom = &qed_read_module_eeprom,
 	.get_affin_hwfn_idx = &qed_get_affin_hwfn_idx,
 	.read_nvm_cfg = &qed_nvm_flash_cfg_read,
+	.set_grc_config = &qed_set_grc_config,
 };
 
 void qed_get_protocol_stats(struct qed_dev *cdev,
diff --git a/include/linux/qed/qed_if.h b/include/linux/qed/qed_if.h
index 06fd958..e354638 100644
--- a/include/linux/qed/qed_if.h
+++ b/include/linux/qed/qed_if.h
@@ -1143,6 +1143,15 @@ struct qed_common_ops {
  */
 	int (*read_nvm_cfg)(struct qed_dev *cdev, u8 **buf, u32 cmd,
 			    u32 entity_id);
+
+/**
+ * @brief set_grc_config - Configure value for grc config id.
+ * @param cdev
+ * @param cfg_id - grc config id
+ * @param val - grc config value
+ *
+ */
+	int (*set_grc_config)(struct qed_dev *cdev, u32 cfg_id, u32 val);
 };
 
 #define MASK_FIELD(_name, _value) \
-- 
1.8.3.1

