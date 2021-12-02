Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53ABC465E2E
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 07:25:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236683AbhLBG1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 01:27:19 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:60778 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231690AbhLBG1T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 01:27:19 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1B20XtrY024926;
        Wed, 1 Dec 2021 22:23:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=6BfIxUjZeO5DJKQhaZZ0/6ESj4ZyuLtMV0zobrKmXac=;
 b=dpKj5pnioC+jhJsJ52Drg7O9wrOSENIIxG8MVWCTcDMsk04ztesYRrw1ZbhIodqI9Nuy
 QyhHRpH617pk3YIgbM4IYqoVMQn+KINJzLfldxsw98KZ+m+0gqq4nSDmifgau2oxZSVB
 ySSFTG1mVJzgZBLMqHR6Muky/qu2qkkbPzCputVO0cSynjJHOh50Bbnc5YJW3frkue/e
 t61R1uC+4RvplHzVtPml04AphAxkSa7crLn5r/ZFuR9Ya+PSP5RmrhDbes2F5ZDNOCpU
 5CRQq8Hc9n5eW57vtwWE+fNN71QwFDt4dvqio+TS3gyImu3BQfWbu63ZzGGOD9364ann Mw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3cpkq3s6cf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 01 Dec 2021 22:23:45 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 1 Dec
 2021 22:23:43 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 1 Dec 2021 22:23:43 -0800
Received: from alpha-dell-r720.punelab.qlogic.com032qlogic.org032qlogic.com032mv.qlogic.com032av.na032marvell.com (unknown [10.30.46.139])
        by maili.marvell.com (Postfix) with ESMTP id AD9283F705A;
        Wed,  1 Dec 2021 22:23:41 -0800 (PST)
From:   Alok Prasad <palok@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <palok@marvell.com>, <aelior@marvell.com>, <pkushwaha@marvell.com>,
        <prabhakar.pkin@gmail.com>
Subject: [PATCH] qed: Enhance rammod debug prints to provide pretty details
Date:   Thu, 2 Dec 2021 06:23:39 +0000
Message-ID: <20211202062339.10533-1-palok@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: DXSXy2P0m4NYvCFMF2GboyBxZZrcW9Om
X-Proofpoint-ORIG-GUID: DXSXy2P0m4NYvCFMF2GboyBxZZrcW9Om
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-30_10,2021-12-01_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Prabhakar Kushwaha <pkushwaha@marvell.com>

Instead of printing numbers of protocol IDs and rammod commands,
enhance debug prints to provide names. s_protocol_types[] and
s_ramrod_cmd_ids arrays[] are added to support along with APIs.

Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Alok Prasad <palok@marvell.com>
Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_hsi.h     |  17 +++
 .../ethernet/qlogic/qed/qed_init_fw_funcs.c   | 102 ++++++++++++++++++
 .../net/ethernet/qlogic/qed/qed_sp_commands.c |  10 +-
 drivers/net/ethernet/qlogic/qed/qed_spq.c     |  42 ++++++--
 4 files changed, 156 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_hsi.h b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
index f2cedbd9489c..1dbd4f016e07 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_hsi.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
@@ -2720,6 +2720,23 @@ void qed_memset_task_ctx(void *p_ctx_mem, u32 ctx_size, u8 ctx_type);
 
 #define NUM_STORMS 6
 
+/**
+ * qed_get_protocol_type_str(): Get a string for Protocol type.
+ * @param protocol_type: Protocol type (using enum protocol_type).
+ *
+ * Return: String, representing the Protocol type.
+ */
+const char *qed_get_protocol_type_str(u32 protocol_type);
+
+/**
+ * qed_get_ramrod_cmd_id_str(): Get a string for Ramrod command ID.
+ * @param protocol_type: Protocol type (using enum protocol_type).
+ * @param ramrod_cmd_id: Ramrod command ID (using per-protocol enum <protocol>_ramrod_cmd_id)
+ *
+ * Return: String, representing the Ramrod command ID.
+ */
+const char *qed_get_ramrod_cmd_id_str(u32 protocol_type, u32 ramrod_cmd_id);
+
 /**
  * qed_set_rdma_error_level(): Sets the RDMA assert level.
  *                             If the severity of the error will be
diff --git a/drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c b/drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c
index 321c43408153..0ce37f2460a4 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c
@@ -210,6 +210,82 @@ static u16 task_region_offsets[1][NUM_OF_CONNECTION_TYPES] = {
 	(XSEM_REG_FAST_MEMORY + SEM_FAST_REG_INT_RAM + \
 	XSTORM_PQ_INFO_OFFSET(pq_id))
 
+static const char * const s_protocol_types[] = {
+	"PROTOCOLID_ISCSI", "PROTOCOLID_FCOE", "PROTOCOLID_ROCE",
+	"PROTOCOLID_CORE", "PROTOCOLID_ETH", "PROTOCOLID_IWARP",
+	"PROTOCOLID_TOE", "PROTOCOLID_PREROCE", "PROTOCOLID_COMMON",
+	"PROTOCOLID_TCP", "PROTOCOLID_RDMA", "PROTOCOLID_SCSI",
+};
+
+static const char *s_ramrod_cmd_ids[][28] = {
+	{
+	"ISCSI_RAMROD_CMD_ID_UNUSED", "ISCSI_RAMROD_CMD_ID_INIT_FUNC",
+	 "ISCSI_RAMROD_CMD_ID_DESTROY_FUNC",
+	 "ISCSI_RAMROD_CMD_ID_OFFLOAD_CONN",
+	 "ISCSI_RAMROD_CMD_ID_UPDATE_CONN",
+	 "ISCSI_RAMROD_CMD_ID_TERMINATION_CONN",
+	 "ISCSI_RAMROD_CMD_ID_CLEAR_SQ", "ISCSI_RAMROD_CMD_ID_MAC_UPDATE",
+	 "ISCSI_RAMROD_CMD_ID_CONN_STATS", },
+	{ "FCOE_RAMROD_CMD_ID_INIT_FUNC", "FCOE_RAMROD_CMD_ID_DESTROY_FUNC",
+	 "FCOE_RAMROD_CMD_ID_STAT_FUNC",
+	 "FCOE_RAMROD_CMD_ID_OFFLOAD_CONN",
+	 "FCOE_RAMROD_CMD_ID_TERMINATE_CONN", },
+	{ "RDMA_RAMROD_UNUSED", "RDMA_RAMROD_FUNC_INIT",
+	 "RDMA_RAMROD_FUNC_CLOSE", "RDMA_RAMROD_REGISTER_MR",
+	 "RDMA_RAMROD_DEREGISTER_MR", "RDMA_RAMROD_CREATE_CQ",
+	 "RDMA_RAMROD_RESIZE_CQ", "RDMA_RAMROD_DESTROY_CQ",
+	 "RDMA_RAMROD_CREATE_SRQ", "RDMA_RAMROD_MODIFY_SRQ",
+	 "RDMA_RAMROD_DESTROY_SRQ", "RDMA_RAMROD_START_NS_TRACKING",
+	 "RDMA_RAMROD_STOP_NS_TRACKING", "ROCE_RAMROD_CREATE_QP",
+	 "ROCE_RAMROD_MODIFY_QP", "ROCE_RAMROD_QUERY_QP",
+	 "ROCE_RAMROD_DESTROY_QP", "ROCE_RAMROD_CREATE_UD_QP",
+	 "ROCE_RAMROD_DESTROY_UD_QP", "ROCE_RAMROD_FUNC_UPDATE",
+	 "ROCE_RAMROD_SUSPEND_QP", "ROCE_RAMROD_QUERY_SUSPENDED_QP",
+	 "ROCE_RAMROD_CREATE_SUSPENDED_QP", "ROCE_RAMROD_RESUME_QP",
+	 "ROCE_RAMROD_SUSPEND_UD_QP", "ROCE_RAMROD_RESUME_UD_QP",
+	 "ROCE_RAMROD_CREATE_SUSPENDED_UD_QP", "ROCE_RAMROD_FLUSH_DPT_QP", },
+	{ "CORE_RAMROD_UNUSED", "CORE_RAMROD_RX_QUEUE_START",
+	 "CORE_RAMROD_TX_QUEUE_START", "CORE_RAMROD_RX_QUEUE_STOP",
+	 "CORE_RAMROD_TX_QUEUE_STOP",
+	 "CORE_RAMROD_RX_QUEUE_FLUSH",
+	 "CORE_RAMROD_TX_QUEUE_UPDATE", "CORE_RAMROD_QUEUE_STATS_QUERY", },
+	{ "ETH_RAMROD_UNUSED", "ETH_RAMROD_VPORT_START",
+	 "ETH_RAMROD_VPORT_UPDATE", "ETH_RAMROD_VPORT_STOP",
+	 "ETH_RAMROD_RX_QUEUE_START", "ETH_RAMROD_RX_QUEUE_STOP",
+	 "ETH_RAMROD_TX_QUEUE_START", "ETH_RAMROD_TX_QUEUE_STOP",
+	 "ETH_RAMROD_FILTERS_UPDATE", "ETH_RAMROD_RX_QUEUE_UPDATE",
+	 "ETH_RAMROD_RX_CREATE_OPENFLOW_ACTION",
+	 "ETH_RAMROD_RX_ADD_OPENFLOW_FILTER",
+	 "ETH_RAMROD_RX_DELETE_OPENFLOW_FILTER",
+	 "ETH_RAMROD_RX_ADD_UDP_FILTER",
+	 "ETH_RAMROD_RX_DELETE_UDP_FILTER",
+	 "ETH_RAMROD_RX_CREATE_GFT_ACTION",
+	 "ETH_RAMROD_RX_UPDATE_GFT_FILTER", "ETH_RAMROD_TX_QUEUE_UPDATE",
+	 "ETH_RAMROD_RGFS_FILTER_ADD", "ETH_RAMROD_RGFS_FILTER_DEL",
+	 "ETH_RAMROD_TGFS_FILTER_ADD", "ETH_RAMROD_TGFS_FILTER_DEL",
+	 "ETH_RAMROD_GFS_COUNTERS_REPORT_REQUEST", },
+	{ "RDMA_RAMROD_UNUSED", "RDMA_RAMROD_FUNC_INIT",
+	 "RDMA_RAMROD_FUNC_CLOSE", "RDMA_RAMROD_REGISTER_MR",
+	 "RDMA_RAMROD_DEREGISTER_MR", "RDMA_RAMROD_CREATE_CQ",
+	 "RDMA_RAMROD_RESIZE_CQ", "RDMA_RAMROD_DESTROY_CQ",
+	 "RDMA_RAMROD_CREATE_SRQ", "RDMA_RAMROD_MODIFY_SRQ",
+	 "RDMA_RAMROD_DESTROY_SRQ", "RDMA_RAMROD_START_NS_TRACKING",
+	 "RDMA_RAMROD_STOP_NS_TRACKING",
+	 "IWARP_RAMROD_CMD_ID_TCP_OFFLOAD",
+	 "IWARP_RAMROD_CMD_ID_MPA_OFFLOAD",
+	 "IWARP_RAMROD_CMD_ID_MPA_OFFLOAD_SEND_RTR",
+	 "IWARP_RAMROD_CMD_ID_CREATE_QP", "IWARP_RAMROD_CMD_ID_QUERY_QP",
+	 "IWARP_RAMROD_CMD_ID_MODIFY_QP",
+	 "IWARP_RAMROD_CMD_ID_DESTROY_QP",
+	 "IWARP_RAMROD_CMD_ID_ABORT_TCP_OFFLOAD", },
+	{ NULL }, /*TOE*/
+	{ NULL }, /*PREROCE*/
+	{ "COMMON_RAMROD_UNUSED", "COMMON_RAMROD_PF_START",
+	     "COMMON_RAMROD_PF_STOP", "COMMON_RAMROD_VF_START",
+	     "COMMON_RAMROD_VF_STOP", "COMMON_RAMROD_PF_UPDATE",
+	     "COMMON_RAMROD_RL_UPDATE", "COMMON_RAMROD_EMPTY", }
+};
+
 /******************** INTERNAL IMPLEMENTATION *********************/
 
 /* Returns the external VOQ number */
@@ -1647,6 +1723,32 @@ void qed_enable_context_validation(struct qed_hwfn *p_hwfn,
 	qed_wr(p_hwfn, p_ptt, CDU_REG_TCFC_CTX_VALID0, ctx_validation);
 }
 
+const char *qed_get_protocol_type_str(u32 protocol_type)
+{
+	if (protocol_type >= ARRAY_SIZE(s_protocol_types))
+		return "Invalid protocol type";
+
+	return s_protocol_types[protocol_type];
+}
+
+const char *qed_get_ramrod_cmd_id_str(u32 protocol_type, u32 ramrod_cmd_id)
+{
+	const char *ramrod_cmd_id_str;
+
+	if (protocol_type >= ARRAY_SIZE(s_ramrod_cmd_ids))
+		return "Invalid protocol type";
+
+	if (ramrod_cmd_id >= ARRAY_SIZE(s_ramrod_cmd_ids[0]))
+		return "Invalid Ramrod command ID";
+
+	ramrod_cmd_id_str = s_ramrod_cmd_ids[protocol_type][ramrod_cmd_id];
+
+	if (!ramrod_cmd_id_str)
+		return "Invalid Ramrod command ID";
+
+	return ramrod_cmd_id_str;
+}
+
 static u32 qed_get_rdma_assert_ram_addr(struct qed_hwfn *p_hwfn, u8 storm_id)
 {
 	switch (storm_id) {
diff --git a/drivers/net/ethernet/qlogic/qed/qed_sp_commands.c b/drivers/net/ethernet/qlogic/qed/qed_sp_commands.c
index 648176dfb871..3b54da963554 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_sp_commands.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_sp_commands.c
@@ -85,10 +85,12 @@ int qed_sp_init_request(struct qed_hwfn *p_hwfn,
 		goto err;
 	}
 
-	DP_VERBOSE(p_hwfn, QED_MSG_SPQ,
-		   "Initialized: CID %08x cmd %02x protocol %02x data_addr %lu comp_mode [%s]\n",
-		   opaque_cid, cmd, protocol,
-		   (unsigned long)&p_ent->ramrod,
+	DP_VERBOSE(p_hwfn,
+		   QED_MSG_SPQ,
+		   "Initialized: CID %08x %s:[%02x] %s:%02x data_addr %llx comp_mode [%s]\n",
+		   opaque_cid, qed_get_ramrod_cmd_id_str(protocol, cmd),
+		   cmd, qed_get_protocol_type_str(protocol), protocol,
+		   (unsigned long long)(uintptr_t)&p_ent->ramrod,
 		   D_TRINE(p_ent->comp_mode, QED_SPQ_MODE_EBLOCK,
 			   QED_SPQ_MODE_BLOCK, "MODE_EBLOCK", "MODE_BLOCK",
 			   "MODE_CB"));
diff --git a/drivers/net/ethernet/qlogic/qed/qed_spq.c b/drivers/net/ethernet/qlogic/qed/qed_spq.c
index e0473729b161..d01b9245f811 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_spq.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_spq.c
@@ -139,10 +139,13 @@ static int qed_spq_block(struct qed_hwfn *p_hwfn,
 	if (!p_ptt)
 		return -EBUSY;
 	qed_hw_err_notify(p_hwfn, p_ptt, QED_HW_ERR_RAMROD_FAIL,
-			  "Ramrod is stuck [CID %08x cmd %02x protocol %02x echo %04x]\n",
+			  "Ramrod is stuck [CID %08x %s:%02x %s:%02x echo %04x]\n",
 			  le32_to_cpu(p_ent->elem.hdr.cid),
+			  qed_get_ramrod_cmd_id_str(p_ent->elem.hdr.protocol_id,
+						    p_ent->elem.hdr.cmd_id),
 			  p_ent->elem.hdr.cmd_id,
-			  p_ent->elem.hdr.protocol_id,
+			  qed_get_protocol_type_str(p_ent->elem.hdr.protocol_id),
+						    p_ent->elem.hdr.protocol_id,
 			  le16_to_cpu(p_ent->elem.hdr.echo));
 	qed_ptt_release(p_hwfn, p_ptt);
 
@@ -170,13 +173,16 @@ static int qed_spq_fill_entry(struct qed_hwfn *p_hwfn,
 		return -EINVAL;
 	}
 
-	DP_VERBOSE(p_hwfn, QED_MSG_SPQ,
-		   "Ramrod header: [CID 0x%08x CMD 0x%02x protocol 0x%02x] Data pointer: [%08x:%08x] Completion Mode: %s\n",
+	DP_VERBOSE(p_hwfn,
+		   QED_MSG_SPQ,
+		   "Ramrod hdr: [CID 0x%08x %s:0x%02x %s:0x%02x] Data ptr: [%08x:%08x] Cmpltion Mode: %s\n",
 		   p_ent->elem.hdr.cid,
+		   qed_get_ramrod_cmd_id_str(p_ent->elem.hdr.protocol_id,
+					     p_ent->elem.hdr.cmd_id),
 		   p_ent->elem.hdr.cmd_id,
-		   p_ent->elem.hdr.protocol_id,
-		   p_ent->elem.data_ptr.hi,
-		   p_ent->elem.data_ptr.lo,
+		   qed_get_protocol_type_str(p_ent->elem.hdr.protocol_id),
+					     p_ent->elem.hdr.protocol_id,
+		   p_ent->elem.data_ptr.hi, p_ent->elem.data_ptr.lo,
 		   D_TRINE(p_ent->comp_mode, QED_SPQ_MODE_EBLOCK,
 			   QED_SPQ_MODE_BLOCK, "MODE_EBLOCK", "MODE_BLOCK",
 			   "MODE_CB"));
@@ -271,17 +277,27 @@ qed_async_event_completion(struct qed_hwfn *p_hwfn,
 {
 	qed_spq_async_comp_cb cb;
 
-	if (!p_hwfn->p_spq || (p_eqe->protocol_id >= MAX_PROTOCOL_TYPE))
+	if (!p_hwfn->p_spq)
 		return -EINVAL;
 
+	if (p_eqe->protocol_id >= MAX_PROTOCOL_TYPE) {
+		DP_ERR(p_hwfn, "Wrong protocol: %s:%d\n",
+		       qed_get_protocol_type_str(p_eqe->protocol_id),
+		       p_eqe->protocol_id);
+
+		return -EINVAL;
+	}
+
 	cb = p_hwfn->p_spq->async_comp_cb[p_eqe->protocol_id];
 	if (cb) {
 		return cb(p_hwfn, p_eqe->opcode, p_eqe->echo,
 			  &p_eqe->data, p_eqe->fw_return_code);
 	} else {
 		DP_NOTICE(p_hwfn,
-			  "Unknown Async completion for protocol: %d\n",
+			  "Unknown Async completion for %s:%d\n",
+			  qed_get_protocol_type_str(p_eqe->protocol_id),
 			  p_eqe->protocol_id);
+
 		return -EINVAL;
 	}
 }
@@ -830,8 +846,12 @@ int qed_spq_post(struct qed_hwfn *p_hwfn,
 	if (p_hwfn->cdev->recov_in_prog) {
 		DP_VERBOSE(p_hwfn,
 			   QED_MSG_SPQ,
-			   "Recovery is in progress. Skip spq post [cmd %02x protocol %02x]\n",
-			   p_ent->elem.hdr.cmd_id, p_ent->elem.hdr.protocol_id);
+			   "Recovery is in progress. Skip spq post [%s:%02x %s:%02x]\n",
+			   qed_get_ramrod_cmd_id_str(p_ent->elem.hdr.protocol_id,
+						     p_ent->elem.hdr.cmd_id),
+			   p_ent->elem.hdr.cmd_id,
+			   qed_get_protocol_type_str(p_ent->elem.hdr.protocol_id),
+			   p_ent->elem.hdr.protocol_id);
 
 		/* Let the flow complete w/o any error handling */
 		qed_spq_recov_set_ret_code(p_ent, fw_return_code);
-- 
2.27.0

