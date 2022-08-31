Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0705A80DB
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 17:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231442AbiHaPFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 11:05:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiHaPFk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 11:05:40 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91EFD45F74;
        Wed, 31 Aug 2022 08:05:36 -0700 (PDT)
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27VE0CCr001221;
        Wed, 31 Aug 2022 15:05:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=qcppdkim1;
 bh=x18tvg708tn7J2KYRgkTcJE/lEyGrtOvCh5dRw9sCT4=;
 b=HMyw07fw7zFbVRu3wfwSl8P1jW3UI1ra1mTueWitjhbzJPbYfAm+Yb2YaF0KKOZJvL3U
 LJMj7FAtAkzC+mJFqrG6spkrc1/CnQsnMWP8WRUdZ/V8b3cFaIP6TabIKejspvHU4bDX
 S2leTxHUjdP3LLRjPQcuOzoKe9UGfWBRnqH0MyaaqriPWu4D+XScoUcaTcBP33yJRvls
 rNSg6uv+PHtik1A06sBx04fWe4OYixx02hkaaGtHbgGarjQzhRxtQoDttSXRD3O8aWvX
 UPw7RPC+2BLiUxgKSTEhx+wwkU87b3yOjyDMoV/I19YxnRMR+rnPmPQNKxqlacKaaudh tg== 
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3j9edcn4ce-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 Aug 2022 15:05:20 +0000
Received: from pps.filterd (NALASPPMTA01.qualcomm.com [127.0.0.1])
        by NALASPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTP id 27VF5JjR030741;
        Wed, 31 Aug 2022 15:05:19 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by NALASPPMTA01.qualcomm.com (PPS) with ESMTPS id 3j7cbkqt8n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 Aug 2022 15:05:19 +0000
Received: from NALASPPMTA01.qualcomm.com (NALASPPMTA01.qualcomm.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27VF0Rnt025664;
        Wed, 31 Aug 2022 15:05:19 GMT
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA01.qualcomm.com (PPS) with ESMTPS id 27VF5Jdo030733
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 Aug 2022 15:05:19 +0000
Received: from quicinc.com (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 31 Aug
 2022 08:05:19 -0700
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
To:     Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] wifi: ath10k: Make QMI message rules const
Date:   Wed, 31 Aug 2022 08:05:13 -0700
Message-ID: <20220831150513.27956-1-quic_jjohnson@quicinc.com>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.49.16.6]
X-ClientProxiedBy: nalasex01b.na.qualcomm.com (10.47.209.197) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: 2AQQqq_Cx5QCT-w4jnt0Ply8s294AN7Q
X-Proofpoint-ORIG-GUID: 2AQQqq_Cx5QCT-w4jnt0Ply8s294AN7Q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-31_09,2022-08-31_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 suspectscore=0 clxscore=1011 malwarescore=0 mlxlogscore=999 adultscore=0
 spamscore=0 phishscore=0 priorityscore=1501 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208310075
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change ff6d365898d ("soc: qcom: qmi: use const for struct
qmi_elem_info") allows QMI message encoding/decoding rules
to be const, so do that for ath10k.

Compile tested only.

Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
---
Depends-on: https://git.kernel.org/pub/scm/linux/kernel/git/qcom/linux.git/commit/?h=for-next&id=ff6d365898d4d31bd557954c7fc53f38977b491c

 drivers/net/wireless/ath/ath10k/qmi.c         |   2 +-
 .../net/wireless/ath/ath10k/qmi_wlfw_v01.c    | 126 +++++++++---------
 .../net/wireless/ath/ath10k/qmi_wlfw_v01.h    | 102 +++++++-------
 3 files changed, 115 insertions(+), 115 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/qmi.c b/drivers/net/wireless/ath/ath10k/qmi.c
index d7e406916bc8..28fafc0f0254 100644
--- a/drivers/net/wireless/ath/ath10k/qmi.c
+++ b/drivers/net/wireless/ath/ath10k/qmi.c
@@ -618,7 +618,7 @@ static int ath10k_qmi_host_cap_send_sync(struct ath10k_qmi *qmi)
 {
 	struct wlfw_host_cap_resp_msg_v01 resp = {};
 	struct wlfw_host_cap_req_msg_v01 req = {};
-	struct qmi_elem_info *req_ei;
+	const struct qmi_elem_info *req_ei;
 	struct ath10k *ar = qmi->ar;
 	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
 	struct qmi_txn txn;
diff --git a/drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.c b/drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.c
index 86fcf4e1de5f..1c81e454f943 100644
--- a/drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.c
+++ b/drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.c
@@ -7,7 +7,7 @@
 #include <linux/types.h>
 #include "qmi_wlfw_v01.h"
 
-static struct qmi_elem_info wlfw_ce_tgt_pipe_cfg_s_v01_ei[] = {
+static const struct qmi_elem_info wlfw_ce_tgt_pipe_cfg_s_v01_ei[] = {
 	{
 		.data_type      = QMI_UNSIGNED_4_BYTE,
 		.elem_len       = 1,
@@ -56,7 +56,7 @@ static struct qmi_elem_info wlfw_ce_tgt_pipe_cfg_s_v01_ei[] = {
 	{}
 };
 
-static struct qmi_elem_info wlfw_ce_svc_pipe_cfg_s_v01_ei[] = {
+static const struct qmi_elem_info wlfw_ce_svc_pipe_cfg_s_v01_ei[] = {
 	{
 		.data_type      = QMI_UNSIGNED_4_BYTE,
 		.elem_len       = 1,
@@ -87,7 +87,7 @@ static struct qmi_elem_info wlfw_ce_svc_pipe_cfg_s_v01_ei[] = {
 	{}
 };
 
-static struct qmi_elem_info wlfw_shadow_reg_cfg_s_v01_ei[] = {
+static const struct qmi_elem_info wlfw_shadow_reg_cfg_s_v01_ei[] = {
 	{
 		.data_type      = QMI_UNSIGNED_2_BYTE,
 		.elem_len       = 1,
@@ -109,7 +109,7 @@ static struct qmi_elem_info wlfw_shadow_reg_cfg_s_v01_ei[] = {
 	{}
 };
 
-static struct qmi_elem_info wlfw_shadow_reg_v2_cfg_s_v01_ei[] = {
+static const struct qmi_elem_info wlfw_shadow_reg_v2_cfg_s_v01_ei[] = {
 	{
 		.data_type      = QMI_UNSIGNED_4_BYTE,
 		.elem_len       = 1,
@@ -122,7 +122,7 @@ static struct qmi_elem_info wlfw_shadow_reg_v2_cfg_s_v01_ei[] = {
 	{}
 };
 
-static struct qmi_elem_info wlfw_memory_region_info_s_v01_ei[] = {
+static const struct qmi_elem_info wlfw_memory_region_info_s_v01_ei[] = {
 	{
 		.data_type      = QMI_UNSIGNED_8_BYTE,
 		.elem_len       = 1,
@@ -153,7 +153,7 @@ static struct qmi_elem_info wlfw_memory_region_info_s_v01_ei[] = {
 	{}
 };
 
-static struct qmi_elem_info wlfw_mem_cfg_s_v01_ei[] = {
+static const struct qmi_elem_info wlfw_mem_cfg_s_v01_ei[] = {
 	{
 		.data_type      = QMI_UNSIGNED_8_BYTE,
 		.elem_len       = 1,
@@ -184,7 +184,7 @@ static struct qmi_elem_info wlfw_mem_cfg_s_v01_ei[] = {
 	{}
 };
 
-static struct qmi_elem_info wlfw_mem_seg_s_v01_ei[] = {
+static const struct qmi_elem_info wlfw_mem_seg_s_v01_ei[] = {
 	{
 		.data_type      = QMI_UNSIGNED_4_BYTE,
 		.elem_len       = 1,
@@ -225,7 +225,7 @@ static struct qmi_elem_info wlfw_mem_seg_s_v01_ei[] = {
 	{}
 };
 
-static struct qmi_elem_info wlfw_mem_seg_resp_s_v01_ei[] = {
+static const struct qmi_elem_info wlfw_mem_seg_resp_s_v01_ei[] = {
 	{
 		.data_type      = QMI_UNSIGNED_8_BYTE,
 		.elem_len       = 1,
@@ -256,7 +256,7 @@ static struct qmi_elem_info wlfw_mem_seg_resp_s_v01_ei[] = {
 	{}
 };
 
-static struct qmi_elem_info wlfw_rf_chip_info_s_v01_ei[] = {
+static const struct qmi_elem_info wlfw_rf_chip_info_s_v01_ei[] = {
 	{
 		.data_type      = QMI_UNSIGNED_4_BYTE,
 		.elem_len       = 1,
@@ -278,7 +278,7 @@ static struct qmi_elem_info wlfw_rf_chip_info_s_v01_ei[] = {
 	{}
 };
 
-static struct qmi_elem_info wlfw_rf_board_info_s_v01_ei[] = {
+static const struct qmi_elem_info wlfw_rf_board_info_s_v01_ei[] = {
 	{
 		.data_type      = QMI_UNSIGNED_4_BYTE,
 		.elem_len       = 1,
@@ -291,7 +291,7 @@ static struct qmi_elem_info wlfw_rf_board_info_s_v01_ei[] = {
 	{}
 };
 
-static struct qmi_elem_info wlfw_soc_info_s_v01_ei[] = {
+static const struct qmi_elem_info wlfw_soc_info_s_v01_ei[] = {
 	{
 		.data_type      = QMI_UNSIGNED_4_BYTE,
 		.elem_len       = 1,
@@ -304,7 +304,7 @@ static struct qmi_elem_info wlfw_soc_info_s_v01_ei[] = {
 	{}
 };
 
-static struct qmi_elem_info wlfw_fw_version_info_s_v01_ei[] = {
+static const struct qmi_elem_info wlfw_fw_version_info_s_v01_ei[] = {
 	{
 		.data_type      = QMI_UNSIGNED_4_BYTE,
 		.elem_len       = 1,
@@ -326,7 +326,7 @@ static struct qmi_elem_info wlfw_fw_version_info_s_v01_ei[] = {
 	{}
 };
 
-struct qmi_elem_info wlfw_ind_register_req_msg_v01_ei[] = {
+const struct qmi_elem_info wlfw_ind_register_req_msg_v01_ei[] = {
 	{
 		.data_type      = QMI_OPT_FLAG,
 		.elem_len       = 1,
@@ -528,7 +528,7 @@ struct qmi_elem_info wlfw_ind_register_req_msg_v01_ei[] = {
 	{}
 };
 
-struct qmi_elem_info wlfw_ind_register_resp_msg_v01_ei[] = {
+const struct qmi_elem_info wlfw_ind_register_resp_msg_v01_ei[] = {
 	{
 		.data_type      = QMI_STRUCT,
 		.elem_len       = 1,
@@ -560,15 +560,15 @@ struct qmi_elem_info wlfw_ind_register_resp_msg_v01_ei[] = {
 	{}
 };
 
-struct qmi_elem_info wlfw_fw_ready_ind_msg_v01_ei[] = {
+const struct qmi_elem_info wlfw_fw_ready_ind_msg_v01_ei[] = {
 	{}
 };
 
-struct qmi_elem_info wlfw_msa_ready_ind_msg_v01_ei[] = {
+const struct qmi_elem_info wlfw_msa_ready_ind_msg_v01_ei[] = {
 	{}
 };
 
-struct qmi_elem_info wlfw_pin_connect_result_ind_msg_v01_ei[] = {
+const struct qmi_elem_info wlfw_pin_connect_result_ind_msg_v01_ei[] = {
 	{
 		.data_type      = QMI_OPT_FLAG,
 		.elem_len       = 1,
@@ -626,7 +626,7 @@ struct qmi_elem_info wlfw_pin_connect_result_ind_msg_v01_ei[] = {
 	{}
 };
 
-struct qmi_elem_info wlfw_wlan_mode_req_msg_v01_ei[] = {
+const struct qmi_elem_info wlfw_wlan_mode_req_msg_v01_ei[] = {
 	{
 		.data_type      = QMI_SIGNED_4_BYTE_ENUM,
 		.elem_len       = 1,
@@ -657,7 +657,7 @@ struct qmi_elem_info wlfw_wlan_mode_req_msg_v01_ei[] = {
 	{}
 };
 
-struct qmi_elem_info wlfw_wlan_mode_resp_msg_v01_ei[] = {
+const struct qmi_elem_info wlfw_wlan_mode_resp_msg_v01_ei[] = {
 	{
 		.data_type      = QMI_STRUCT,
 		.elem_len       = 1,
@@ -671,7 +671,7 @@ struct qmi_elem_info wlfw_wlan_mode_resp_msg_v01_ei[] = {
 	{}
 };
 
-struct qmi_elem_info wlfw_wlan_cfg_req_msg_v01_ei[] = {
+const struct qmi_elem_info wlfw_wlan_cfg_req_msg_v01_ei[] = {
 	{
 		.data_type      = QMI_OPT_FLAG,
 		.elem_len       = 1,
@@ -805,7 +805,7 @@ struct qmi_elem_info wlfw_wlan_cfg_req_msg_v01_ei[] = {
 	{}
 };
 
-struct qmi_elem_info wlfw_wlan_cfg_resp_msg_v01_ei[] = {
+const struct qmi_elem_info wlfw_wlan_cfg_resp_msg_v01_ei[] = {
 	{
 		.data_type      = QMI_STRUCT,
 		.elem_len       = 1,
@@ -819,11 +819,11 @@ struct qmi_elem_info wlfw_wlan_cfg_resp_msg_v01_ei[] = {
 	{}
 };
 
-struct qmi_elem_info wlfw_cap_req_msg_v01_ei[] = {
+const struct qmi_elem_info wlfw_cap_req_msg_v01_ei[] = {
 	{}
 };
 
-struct qmi_elem_info wlfw_cap_resp_msg_v01_ei[] = {
+const struct qmi_elem_info wlfw_cap_resp_msg_v01_ei[] = {
 	{
 		.data_type      = QMI_STRUCT,
 		.elem_len       = 1,
@@ -949,7 +949,7 @@ struct qmi_elem_info wlfw_cap_resp_msg_v01_ei[] = {
 	{}
 };
 
-struct qmi_elem_info wlfw_bdf_download_req_msg_v01_ei[] = {
+const struct qmi_elem_info wlfw_bdf_download_req_msg_v01_ei[] = {
 	{
 		.data_type      = QMI_UNSIGNED_1_BYTE,
 		.elem_len       = 1,
@@ -1079,7 +1079,7 @@ struct qmi_elem_info wlfw_bdf_download_req_msg_v01_ei[] = {
 	{}
 };
 
-struct qmi_elem_info wlfw_bdf_download_resp_msg_v01_ei[] = {
+const struct qmi_elem_info wlfw_bdf_download_resp_msg_v01_ei[] = {
 	{
 		.data_type      = QMI_STRUCT,
 		.elem_len       = 1,
@@ -1093,7 +1093,7 @@ struct qmi_elem_info wlfw_bdf_download_resp_msg_v01_ei[] = {
 	{}
 };
 
-struct qmi_elem_info wlfw_cal_report_req_msg_v01_ei[] = {
+const struct qmi_elem_info wlfw_cal_report_req_msg_v01_ei[] = {
 	{
 		.data_type      = QMI_DATA_LEN,
 		.elem_len       = 1,
@@ -1133,7 +1133,7 @@ struct qmi_elem_info wlfw_cal_report_req_msg_v01_ei[] = {
 	{}
 };
 
-struct qmi_elem_info wlfw_cal_report_resp_msg_v01_ei[] = {
+const struct qmi_elem_info wlfw_cal_report_resp_msg_v01_ei[] = {
 	{
 		.data_type      = QMI_STRUCT,
 		.elem_len       = 1,
@@ -1147,7 +1147,7 @@ struct qmi_elem_info wlfw_cal_report_resp_msg_v01_ei[] = {
 	{}
 };
 
-struct qmi_elem_info wlfw_initiate_cal_download_ind_msg_v01_ei[] = {
+const struct qmi_elem_info wlfw_initiate_cal_download_ind_msg_v01_ei[] = {
 	{
 		.data_type      = QMI_SIGNED_4_BYTE_ENUM,
 		.elem_len       = 1,
@@ -1160,7 +1160,7 @@ struct qmi_elem_info wlfw_initiate_cal_download_ind_msg_v01_ei[] = {
 	{}
 };
 
-struct qmi_elem_info wlfw_cal_download_req_msg_v01_ei[] = {
+const struct qmi_elem_info wlfw_cal_download_req_msg_v01_ei[] = {
 	{
 		.data_type      = QMI_UNSIGNED_1_BYTE,
 		.elem_len       = 1,
@@ -1272,7 +1272,7 @@ struct qmi_elem_info wlfw_cal_download_req_msg_v01_ei[] = {
 	{}
 };
 
-struct qmi_elem_info wlfw_cal_download_resp_msg_v01_ei[] = {
+const struct qmi_elem_info wlfw_cal_download_resp_msg_v01_ei[] = {
 	{
 		.data_type      = QMI_STRUCT,
 		.elem_len       = 1,
@@ -1286,7 +1286,7 @@ struct qmi_elem_info wlfw_cal_download_resp_msg_v01_ei[] = {
 	{}
 };
 
-struct qmi_elem_info wlfw_initiate_cal_update_ind_msg_v01_ei[] = {
+const struct qmi_elem_info wlfw_initiate_cal_update_ind_msg_v01_ei[] = {
 	{
 		.data_type      = QMI_SIGNED_4_BYTE_ENUM,
 		.elem_len       = 1,
@@ -1308,7 +1308,7 @@ struct qmi_elem_info wlfw_initiate_cal_update_ind_msg_v01_ei[] = {
 	{}
 };
 
-struct qmi_elem_info wlfw_cal_update_req_msg_v01_ei[] = {
+const struct qmi_elem_info wlfw_cal_update_req_msg_v01_ei[] = {
 	{
 		.data_type      = QMI_SIGNED_4_BYTE_ENUM,
 		.elem_len       = 1,
@@ -1330,7 +1330,7 @@ struct qmi_elem_info wlfw_cal_update_req_msg_v01_ei[] = {
 	{}
 };
 
-struct qmi_elem_info wlfw_cal_update_resp_msg_v01_ei[] = {
+const struct qmi_elem_info wlfw_cal_update_resp_msg_v01_ei[] = {
 	{
 		.data_type      = QMI_STRUCT,
 		.elem_len       = 1,
@@ -1443,7 +1443,7 @@ struct qmi_elem_info wlfw_cal_update_resp_msg_v01_ei[] = {
 	{}
 };
 
-struct qmi_elem_info wlfw_msa_info_req_msg_v01_ei[] = {
+const struct qmi_elem_info wlfw_msa_info_req_msg_v01_ei[] = {
 	{
 		.data_type      = QMI_UNSIGNED_8_BYTE,
 		.elem_len       = 1,
@@ -1465,7 +1465,7 @@ struct qmi_elem_info wlfw_msa_info_req_msg_v01_ei[] = {
 	{}
 };
 
-struct qmi_elem_info wlfw_msa_info_resp_msg_v01_ei[] = {
+const struct qmi_elem_info wlfw_msa_info_resp_msg_v01_ei[] = {
 	{
 		.data_type      = QMI_STRUCT,
 		.elem_len       = 1,
@@ -1498,11 +1498,11 @@ struct qmi_elem_info wlfw_msa_info_resp_msg_v01_ei[] = {
 	{}
 };
 
-struct qmi_elem_info wlfw_msa_ready_req_msg_v01_ei[] = {
+const struct qmi_elem_info wlfw_msa_ready_req_msg_v01_ei[] = {
 	{}
 };
 
-struct qmi_elem_info wlfw_msa_ready_resp_msg_v01_ei[] = {
+const struct qmi_elem_info wlfw_msa_ready_resp_msg_v01_ei[] = {
 	{
 		.data_type      = QMI_STRUCT,
 		.elem_len       = 1,
@@ -1516,7 +1516,7 @@ struct qmi_elem_info wlfw_msa_ready_resp_msg_v01_ei[] = {
 	{}
 };
 
-struct qmi_elem_info wlfw_ini_req_msg_v01_ei[] = {
+const struct qmi_elem_info wlfw_ini_req_msg_v01_ei[] = {
 	{
 		.data_type      = QMI_OPT_FLAG,
 		.elem_len       = 1,
@@ -1538,7 +1538,7 @@ struct qmi_elem_info wlfw_ini_req_msg_v01_ei[] = {
 	{}
 };
 
-struct qmi_elem_info wlfw_ini_resp_msg_v01_ei[] = {
+const struct qmi_elem_info wlfw_ini_resp_msg_v01_ei[] = {
 	{
 		.data_type      = QMI_STRUCT,
 		.elem_len       = 1,
@@ -1552,7 +1552,7 @@ struct qmi_elem_info wlfw_ini_resp_msg_v01_ei[] = {
 	{}
 };
 
-struct qmi_elem_info wlfw_athdiag_read_req_msg_v01_ei[] = {
+const struct qmi_elem_info wlfw_athdiag_read_req_msg_v01_ei[] = {
 	{
 		.data_type      = QMI_UNSIGNED_4_BYTE,
 		.elem_len       = 1,
@@ -1583,7 +1583,7 @@ struct qmi_elem_info wlfw_athdiag_read_req_msg_v01_ei[] = {
 	{}
 };
 
-struct qmi_elem_info wlfw_athdiag_read_resp_msg_v01_ei[] = {
+const struct qmi_elem_info wlfw_athdiag_read_resp_msg_v01_ei[] = {
 	{
 		.data_type      = QMI_STRUCT,
 		.elem_len       = 1,
@@ -1624,7 +1624,7 @@ struct qmi_elem_info wlfw_athdiag_read_resp_msg_v01_ei[] = {
 	{}
 };
 
-struct qmi_elem_info wlfw_athdiag_write_req_msg_v01_ei[] = {
+const struct qmi_elem_info wlfw_athdiag_write_req_msg_v01_ei[] = {
 	{
 		.data_type      = QMI_UNSIGNED_4_BYTE,
 		.elem_len       = 1,
@@ -1664,7 +1664,7 @@ struct qmi_elem_info wlfw_athdiag_write_req_msg_v01_ei[] = {
 	{}
 };
 
-struct qmi_elem_info wlfw_athdiag_write_resp_msg_v01_ei[] = {
+const struct qmi_elem_info wlfw_athdiag_write_resp_msg_v01_ei[] = {
 	{
 		.data_type      = QMI_STRUCT,
 		.elem_len       = 1,
@@ -1678,7 +1678,7 @@ struct qmi_elem_info wlfw_athdiag_write_resp_msg_v01_ei[] = {
 	{}
 };
 
-struct qmi_elem_info wlfw_vbatt_req_msg_v01_ei[] = {
+const struct qmi_elem_info wlfw_vbatt_req_msg_v01_ei[] = {
 	{
 		.data_type      = QMI_UNSIGNED_8_BYTE,
 		.elem_len       = 1,
@@ -1691,7 +1691,7 @@ struct qmi_elem_info wlfw_vbatt_req_msg_v01_ei[] = {
 	{}
 };
 
-struct qmi_elem_info wlfw_vbatt_resp_msg_v01_ei[] = {
+const struct qmi_elem_info wlfw_vbatt_resp_msg_v01_ei[] = {
 	{
 		.data_type      = QMI_STRUCT,
 		.elem_len       = 1,
@@ -1705,7 +1705,7 @@ struct qmi_elem_info wlfw_vbatt_resp_msg_v01_ei[] = {
 	{}
 };
 
-struct qmi_elem_info wlfw_mac_addr_req_msg_v01_ei[] = {
+const struct qmi_elem_info wlfw_mac_addr_req_msg_v01_ei[] = {
 	{
 		.data_type      = QMI_OPT_FLAG,
 		.elem_len       = 1,
@@ -1727,7 +1727,7 @@ struct qmi_elem_info wlfw_mac_addr_req_msg_v01_ei[] = {
 	{}
 };
 
-struct qmi_elem_info wlfw_mac_addr_resp_msg_v01_ei[] = {
+const struct qmi_elem_info wlfw_mac_addr_resp_msg_v01_ei[] = {
 	{
 		.data_type      = QMI_STRUCT,
 		.elem_len       = 1,
@@ -1741,7 +1741,7 @@ struct qmi_elem_info wlfw_mac_addr_resp_msg_v01_ei[] = {
 	{}
 };
 
-struct qmi_elem_info wlfw_host_cap_req_msg_v01_ei[] = {
+const struct qmi_elem_info wlfw_host_cap_req_msg_v01_ei[] = {
 	{
 		.data_type      = QMI_OPT_FLAG,
 		.elem_len       = 1,
@@ -1988,7 +1988,7 @@ struct qmi_elem_info wlfw_host_cap_req_msg_v01_ei[] = {
 	{}
 };
 
-struct qmi_elem_info wlfw_host_cap_8bit_req_msg_v01_ei[] = {
+const struct qmi_elem_info wlfw_host_cap_8bit_req_msg_v01_ei[] = {
 	{
 		.data_type      = QMI_OPT_FLAG,
 		.elem_len       = 1,
@@ -2010,7 +2010,7 @@ struct qmi_elem_info wlfw_host_cap_8bit_req_msg_v01_ei[] = {
 	{}
 };
 
-struct qmi_elem_info wlfw_host_cap_resp_msg_v01_ei[] = {
+const struct qmi_elem_info wlfw_host_cap_resp_msg_v01_ei[] = {
 	{
 		.data_type      = QMI_STRUCT,
 		.elem_len       = 1,
@@ -2024,7 +2024,7 @@ struct qmi_elem_info wlfw_host_cap_resp_msg_v01_ei[] = {
 	{}
 };
 
-struct qmi_elem_info wlfw_request_mem_ind_msg_v01_ei[] = {
+const struct qmi_elem_info wlfw_request_mem_ind_msg_v01_ei[] = {
 	{
 		.data_type      = QMI_DATA_LEN,
 		.elem_len       = 1,
@@ -2047,7 +2047,7 @@ struct qmi_elem_info wlfw_request_mem_ind_msg_v01_ei[] = {
 	{}
 };
 
-struct qmi_elem_info wlfw_respond_mem_req_msg_v01_ei[] = {
+const struct qmi_elem_info wlfw_respond_mem_req_msg_v01_ei[] = {
 	{
 		.data_type      = QMI_DATA_LEN,
 		.elem_len       = 1,
@@ -2070,7 +2070,7 @@ struct qmi_elem_info wlfw_respond_mem_req_msg_v01_ei[] = {
 	{}
 };
 
-struct qmi_elem_info wlfw_respond_mem_resp_msg_v01_ei[] = {
+const struct qmi_elem_info wlfw_respond_mem_resp_msg_v01_ei[] = {
 	{
 		.data_type      = QMI_STRUCT,
 		.elem_len       = 1,
@@ -2084,15 +2084,15 @@ struct qmi_elem_info wlfw_respond_mem_resp_msg_v01_ei[] = {
 	{}
 };
 
-struct qmi_elem_info wlfw_mem_ready_ind_msg_v01_ei[] = {
+const struct qmi_elem_info wlfw_mem_ready_ind_msg_v01_ei[] = {
 	{}
 };
 
-struct qmi_elem_info wlfw_fw_init_done_ind_msg_v01_ei[] = {
+const struct qmi_elem_info wlfw_fw_init_done_ind_msg_v01_ei[] = {
 	{}
 };
 
-struct qmi_elem_info wlfw_rejuvenate_ind_msg_v01_ei[] = {
+const struct qmi_elem_info wlfw_rejuvenate_ind_msg_v01_ei[] = {
 	{
 		.data_type      = QMI_OPT_FLAG,
 		.elem_len       = 1,
@@ -2168,11 +2168,11 @@ struct qmi_elem_info wlfw_rejuvenate_ind_msg_v01_ei[] = {
 	{}
 };
 
-struct qmi_elem_info wlfw_rejuvenate_ack_req_msg_v01_ei[] = {
+const struct qmi_elem_info wlfw_rejuvenate_ack_req_msg_v01_ei[] = {
 	{}
 };
 
-struct qmi_elem_info wlfw_rejuvenate_ack_resp_msg_v01_ei[] = {
+const struct qmi_elem_info wlfw_rejuvenate_ack_resp_msg_v01_ei[] = {
 	{
 		.data_type      = QMI_STRUCT,
 		.elem_len       = 1,
@@ -2186,7 +2186,7 @@ struct qmi_elem_info wlfw_rejuvenate_ack_resp_msg_v01_ei[] = {
 	{}
 };
 
-struct qmi_elem_info wlfw_dynamic_feature_mask_req_msg_v01_ei[] = {
+const struct qmi_elem_info wlfw_dynamic_feature_mask_req_msg_v01_ei[] = {
 	{
 		.data_type      = QMI_OPT_FLAG,
 		.elem_len       = 1,
@@ -2208,7 +2208,7 @@ struct qmi_elem_info wlfw_dynamic_feature_mask_req_msg_v01_ei[] = {
 	{}
 };
 
-struct qmi_elem_info wlfw_dynamic_feature_mask_resp_msg_v01_ei[] = {
+const struct qmi_elem_info wlfw_dynamic_feature_mask_resp_msg_v01_ei[] = {
 	{
 		.data_type      = QMI_STRUCT,
 		.elem_len       = 1,
@@ -2258,7 +2258,7 @@ struct qmi_elem_info wlfw_dynamic_feature_mask_resp_msg_v01_ei[] = {
 	{}
 };
 
-struct qmi_elem_info wlfw_m3_info_req_msg_v01_ei[] = {
+const struct qmi_elem_info wlfw_m3_info_req_msg_v01_ei[] = {
 	{
 		.data_type      = QMI_UNSIGNED_8_BYTE,
 		.elem_len       = 1,
@@ -2280,7 +2280,7 @@ struct qmi_elem_info wlfw_m3_info_req_msg_v01_ei[] = {
 	{}
 };
 
-struct qmi_elem_info wlfw_m3_info_resp_msg_v01_ei[] = {
+const struct qmi_elem_info wlfw_m3_info_resp_msg_v01_ei[] = {
 	{
 		.data_type      = QMI_STRUCT,
 		.elem_len       = 1,
@@ -2294,7 +2294,7 @@ struct qmi_elem_info wlfw_m3_info_resp_msg_v01_ei[] = {
 	{}
 };
 
-struct qmi_elem_info wlfw_xo_cal_ind_msg_v01_ei[] = {
+const struct qmi_elem_info wlfw_xo_cal_ind_msg_v01_ei[] = {
 	{
 		.data_type      = QMI_UNSIGNED_1_BYTE,
 		.elem_len       = 1,
diff --git a/drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.h b/drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.h
index 4d107e1364a8..f0db991408dc 100644
--- a/drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.h
+++ b/drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.h
@@ -215,7 +215,7 @@ struct wlfw_ind_register_req_msg_v01 {
 };
 
 #define WLFW_IND_REGISTER_REQ_MSG_V01_MAX_MSG_LEN 50
-extern struct qmi_elem_info wlfw_ind_register_req_msg_v01_ei[];
+extern const struct qmi_elem_info wlfw_ind_register_req_msg_v01_ei[];
 
 struct wlfw_ind_register_resp_msg_v01 {
 	struct qmi_response_type_v01 resp;
@@ -224,21 +224,21 @@ struct wlfw_ind_register_resp_msg_v01 {
 };
 
 #define WLFW_IND_REGISTER_RESP_MSG_V01_MAX_MSG_LEN 18
-extern struct qmi_elem_info wlfw_ind_register_resp_msg_v01_ei[];
+extern const struct qmi_elem_info wlfw_ind_register_resp_msg_v01_ei[];
 
 struct wlfw_fw_ready_ind_msg_v01 {
 	char placeholder;
 };
 
 #define WLFW_FW_READY_IND_MSG_V01_MAX_MSG_LEN 0
-extern struct qmi_elem_info wlfw_fw_ready_ind_msg_v01_ei[];
+extern const struct qmi_elem_info wlfw_fw_ready_ind_msg_v01_ei[];
 
 struct wlfw_msa_ready_ind_msg_v01 {
 	char placeholder;
 };
 
 #define WLFW_MSA_READY_IND_MSG_V01_MAX_MSG_LEN 0
-extern struct qmi_elem_info wlfw_msa_ready_ind_msg_v01_ei[];
+extern const struct qmi_elem_info wlfw_msa_ready_ind_msg_v01_ei[];
 
 struct wlfw_pin_connect_result_ind_msg_v01 {
 	u8 pwr_pin_result_valid;
@@ -250,7 +250,7 @@ struct wlfw_pin_connect_result_ind_msg_v01 {
 };
 
 #define WLFW_PIN_CONNECT_RESULT_IND_MSG_V01_MAX_MSG_LEN 21
-extern struct qmi_elem_info wlfw_pin_connect_result_ind_msg_v01_ei[];
+extern const struct qmi_elem_info wlfw_pin_connect_result_ind_msg_v01_ei[];
 
 struct wlfw_wlan_mode_req_msg_v01 {
 	enum wlfw_driver_mode_enum_v01 mode;
@@ -259,14 +259,14 @@ struct wlfw_wlan_mode_req_msg_v01 {
 };
 
 #define WLFW_WLAN_MODE_REQ_MSG_V01_MAX_MSG_LEN 11
-extern struct qmi_elem_info wlfw_wlan_mode_req_msg_v01_ei[];
+extern const struct qmi_elem_info wlfw_wlan_mode_req_msg_v01_ei[];
 
 struct wlfw_wlan_mode_resp_msg_v01 {
 	struct qmi_response_type_v01 resp;
 };
 
 #define WLFW_WLAN_MODE_RESP_MSG_V01_MAX_MSG_LEN 7
-extern struct qmi_elem_info wlfw_wlan_mode_resp_msg_v01_ei[];
+extern const struct qmi_elem_info wlfw_wlan_mode_resp_msg_v01_ei[];
 
 struct wlfw_wlan_cfg_req_msg_v01 {
 	u8 host_version_valid;
@@ -286,21 +286,21 @@ struct wlfw_wlan_cfg_req_msg_v01 {
 };
 
 #define WLFW_WLAN_CFG_REQ_MSG_V01_MAX_MSG_LEN 803
-extern struct qmi_elem_info wlfw_wlan_cfg_req_msg_v01_ei[];
+extern const struct qmi_elem_info wlfw_wlan_cfg_req_msg_v01_ei[];
 
 struct wlfw_wlan_cfg_resp_msg_v01 {
 	struct qmi_response_type_v01 resp;
 };
 
 #define WLFW_WLAN_CFG_RESP_MSG_V01_MAX_MSG_LEN 7
-extern struct qmi_elem_info wlfw_wlan_cfg_resp_msg_v01_ei[];
+extern const struct qmi_elem_info wlfw_wlan_cfg_resp_msg_v01_ei[];
 
 struct wlfw_cap_req_msg_v01 {
 	char placeholder;
 };
 
 #define WLFW_CAP_REQ_MSG_V01_MAX_MSG_LEN 0
-extern struct qmi_elem_info wlfw_cap_req_msg_v01_ei[];
+extern const struct qmi_elem_info wlfw_cap_req_msg_v01_ei[];
 
 struct wlfw_cap_resp_msg_v01 {
 	struct qmi_response_type_v01 resp;
@@ -319,7 +319,7 @@ struct wlfw_cap_resp_msg_v01 {
 };
 
 #define WLFW_CAP_RESP_MSG_V01_MAX_MSG_LEN 207
-extern struct qmi_elem_info wlfw_cap_resp_msg_v01_ei[];
+extern const struct qmi_elem_info wlfw_cap_resp_msg_v01_ei[];
 
 struct wlfw_bdf_download_req_msg_v01 {
 	u8 valid;
@@ -339,14 +339,14 @@ struct wlfw_bdf_download_req_msg_v01 {
 };
 
 #define WLFW_BDF_DOWNLOAD_REQ_MSG_V01_MAX_MSG_LEN 6182
-extern struct qmi_elem_info wlfw_bdf_download_req_msg_v01_ei[];
+extern const struct qmi_elem_info wlfw_bdf_download_req_msg_v01_ei[];
 
 struct wlfw_bdf_download_resp_msg_v01 {
 	struct qmi_response_type_v01 resp;
 };
 
 #define WLFW_BDF_DOWNLOAD_RESP_MSG_V01_MAX_MSG_LEN 7
-extern struct qmi_elem_info wlfw_bdf_download_resp_msg_v01_ei[];
+extern const struct qmi_elem_info wlfw_bdf_download_resp_msg_v01_ei[];
 
 struct wlfw_cal_report_req_msg_v01 {
 	u32 meta_data_len;
@@ -356,21 +356,21 @@ struct wlfw_cal_report_req_msg_v01 {
 };
 
 #define WLFW_CAL_REPORT_REQ_MSG_V01_MAX_MSG_LEN 28
-extern struct qmi_elem_info wlfw_cal_report_req_msg_v01_ei[];
+extern const struct qmi_elem_info wlfw_cal_report_req_msg_v01_ei[];
 
 struct wlfw_cal_report_resp_msg_v01 {
 	struct qmi_response_type_v01 resp;
 };
 
 #define WLFW_CAL_REPORT_RESP_MSG_V01_MAX_MSG_LEN 7
-extern struct qmi_elem_info wlfw_cal_report_resp_msg_v01_ei[];
+extern const struct qmi_elem_info wlfw_cal_report_resp_msg_v01_ei[];
 
 struct wlfw_initiate_cal_download_ind_msg_v01 {
 	enum wlfw_cal_temp_id_enum_v01 cal_id;
 };
 
 #define WLFW_INITIATE_CAL_DOWNLOAD_IND_MSG_V01_MAX_MSG_LEN 7
-extern struct qmi_elem_info wlfw_initiate_cal_download_ind_msg_v01_ei[];
+extern const struct qmi_elem_info wlfw_initiate_cal_download_ind_msg_v01_ei[];
 
 struct wlfw_cal_download_req_msg_v01 {
 	u8 valid;
@@ -388,14 +388,14 @@ struct wlfw_cal_download_req_msg_v01 {
 };
 
 #define WLFW_CAL_DOWNLOAD_REQ_MSG_V01_MAX_MSG_LEN 6178
-extern struct qmi_elem_info wlfw_cal_download_req_msg_v01_ei[];
+extern const struct qmi_elem_info wlfw_cal_download_req_msg_v01_ei[];
 
 struct wlfw_cal_download_resp_msg_v01 {
 	struct qmi_response_type_v01 resp;
 };
 
 #define WLFW_CAL_DOWNLOAD_RESP_MSG_V01_MAX_MSG_LEN 7
-extern struct qmi_elem_info wlfw_cal_download_resp_msg_v01_ei[];
+extern const struct qmi_elem_info wlfw_cal_download_resp_msg_v01_ei[];
 
 struct wlfw_initiate_cal_update_ind_msg_v01 {
 	enum wlfw_cal_temp_id_enum_v01 cal_id;
@@ -403,7 +403,7 @@ struct wlfw_initiate_cal_update_ind_msg_v01 {
 };
 
 #define WLFW_INITIATE_CAL_UPDATE_IND_MSG_V01_MAX_MSG_LEN 14
-extern struct qmi_elem_info wlfw_initiate_cal_update_ind_msg_v01_ei[];
+extern const struct qmi_elem_info wlfw_initiate_cal_update_ind_msg_v01_ei[];
 
 struct wlfw_cal_update_req_msg_v01 {
 	enum wlfw_cal_temp_id_enum_v01 cal_id;
@@ -411,7 +411,7 @@ struct wlfw_cal_update_req_msg_v01 {
 };
 
 #define WLFW_CAL_UPDATE_REQ_MSG_V01_MAX_MSG_LEN 14
-extern struct qmi_elem_info wlfw_cal_update_req_msg_v01_ei[];
+extern const struct qmi_elem_info wlfw_cal_update_req_msg_v01_ei[];
 
 struct wlfw_cal_update_resp_msg_v01 {
 	struct qmi_response_type_v01 resp;
@@ -429,7 +429,7 @@ struct wlfw_cal_update_resp_msg_v01 {
 };
 
 #define WLFW_CAL_UPDATE_RESP_MSG_V01_MAX_MSG_LEN 6181
-extern struct qmi_elem_info wlfw_cal_update_resp_msg_v01_ei[];
+extern const struct qmi_elem_info wlfw_cal_update_resp_msg_v01_ei[];
 
 struct wlfw_msa_info_req_msg_v01 {
 	u64 msa_addr;
@@ -437,7 +437,7 @@ struct wlfw_msa_info_req_msg_v01 {
 };
 
 #define WLFW_MSA_INFO_REQ_MSG_V01_MAX_MSG_LEN 18
-extern struct qmi_elem_info wlfw_msa_info_req_msg_v01_ei[];
+extern const struct qmi_elem_info wlfw_msa_info_req_msg_v01_ei[];
 
 struct wlfw_msa_info_resp_msg_v01 {
 	struct qmi_response_type_v01 resp;
@@ -446,21 +446,21 @@ struct wlfw_msa_info_resp_msg_v01 {
 };
 
 #define WLFW_MSA_INFO_RESP_MSG_V01_MAX_MSG_LEN 37
-extern struct qmi_elem_info wlfw_msa_info_resp_msg_v01_ei[];
+extern const struct qmi_elem_info wlfw_msa_info_resp_msg_v01_ei[];
 
 struct wlfw_msa_ready_req_msg_v01 {
 	char placeholder;
 };
 
 #define WLFW_MSA_READY_REQ_MSG_V01_MAX_MSG_LEN 0
-extern struct qmi_elem_info wlfw_msa_ready_req_msg_v01_ei[];
+extern const struct qmi_elem_info wlfw_msa_ready_req_msg_v01_ei[];
 
 struct wlfw_msa_ready_resp_msg_v01 {
 	struct qmi_response_type_v01 resp;
 };
 
 #define WLFW_MSA_READY_RESP_MSG_V01_MAX_MSG_LEN 7
-extern struct qmi_elem_info wlfw_msa_ready_resp_msg_v01_ei[];
+extern const struct qmi_elem_info wlfw_msa_ready_resp_msg_v01_ei[];
 
 struct wlfw_ini_req_msg_v01 {
 	u8 enablefwlog_valid;
@@ -468,14 +468,14 @@ struct wlfw_ini_req_msg_v01 {
 };
 
 #define WLFW_INI_REQ_MSG_V01_MAX_MSG_LEN 4
-extern struct qmi_elem_info wlfw_ini_req_msg_v01_ei[];
+extern const struct qmi_elem_info wlfw_ini_req_msg_v01_ei[];
 
 struct wlfw_ini_resp_msg_v01 {
 	struct qmi_response_type_v01 resp;
 };
 
 #define WLFW_INI_RESP_MSG_V01_MAX_MSG_LEN 7
-extern struct qmi_elem_info wlfw_ini_resp_msg_v01_ei[];
+extern const struct qmi_elem_info wlfw_ini_resp_msg_v01_ei[];
 
 struct wlfw_athdiag_read_req_msg_v01 {
 	u32 offset;
@@ -484,7 +484,7 @@ struct wlfw_athdiag_read_req_msg_v01 {
 };
 
 #define WLFW_ATHDIAG_READ_REQ_MSG_V01_MAX_MSG_LEN 21
-extern struct qmi_elem_info wlfw_athdiag_read_req_msg_v01_ei[];
+extern const struct qmi_elem_info wlfw_athdiag_read_req_msg_v01_ei[];
 
 struct wlfw_athdiag_read_resp_msg_v01 {
 	struct qmi_response_type_v01 resp;
@@ -494,7 +494,7 @@ struct wlfw_athdiag_read_resp_msg_v01 {
 };
 
 #define WLFW_ATHDIAG_READ_RESP_MSG_V01_MAX_MSG_LEN 6156
-extern struct qmi_elem_info wlfw_athdiag_read_resp_msg_v01_ei[];
+extern const struct qmi_elem_info wlfw_athdiag_read_resp_msg_v01_ei[];
 
 struct wlfw_athdiag_write_req_msg_v01 {
 	u32 offset;
@@ -504,28 +504,28 @@ struct wlfw_athdiag_write_req_msg_v01 {
 };
 
 #define WLFW_ATHDIAG_WRITE_REQ_MSG_V01_MAX_MSG_LEN 6163
-extern struct qmi_elem_info wlfw_athdiag_write_req_msg_v01_ei[];
+extern const struct qmi_elem_info wlfw_athdiag_write_req_msg_v01_ei[];
 
 struct wlfw_athdiag_write_resp_msg_v01 {
 	struct qmi_response_type_v01 resp;
 };
 
 #define WLFW_ATHDIAG_WRITE_RESP_MSG_V01_MAX_MSG_LEN 7
-extern struct qmi_elem_info wlfw_athdiag_write_resp_msg_v01_ei[];
+extern const struct qmi_elem_info wlfw_athdiag_write_resp_msg_v01_ei[];
 
 struct wlfw_vbatt_req_msg_v01 {
 	u64 voltage_uv;
 };
 
 #define WLFW_VBATT_REQ_MSG_V01_MAX_MSG_LEN 11
-extern struct qmi_elem_info wlfw_vbatt_req_msg_v01_ei[];
+extern const struct qmi_elem_info wlfw_vbatt_req_msg_v01_ei[];
 
 struct wlfw_vbatt_resp_msg_v01 {
 	struct qmi_response_type_v01 resp;
 };
 
 #define WLFW_VBATT_RESP_MSG_V01_MAX_MSG_LEN 7
-extern struct qmi_elem_info wlfw_vbatt_resp_msg_v01_ei[];
+extern const struct qmi_elem_info wlfw_vbatt_resp_msg_v01_ei[];
 
 struct wlfw_mac_addr_req_msg_v01 {
 	u8 mac_addr_valid;
@@ -533,14 +533,14 @@ struct wlfw_mac_addr_req_msg_v01 {
 };
 
 #define WLFW_MAC_ADDR_REQ_MSG_V01_MAX_MSG_LEN 9
-extern struct qmi_elem_info wlfw_mac_addr_req_msg_v01_ei[];
+extern const struct qmi_elem_info wlfw_mac_addr_req_msg_v01_ei[];
 
 struct wlfw_mac_addr_resp_msg_v01 {
 	struct qmi_response_type_v01 resp;
 };
 
 #define WLFW_MAC_ADDR_RESP_MSG_V01_MAX_MSG_LEN 7
-extern struct qmi_elem_info wlfw_mac_addr_resp_msg_v01_ei[];
+extern const struct qmi_elem_info wlfw_mac_addr_resp_msg_v01_ei[];
 
 #define QMI_WLFW_MAX_NUM_GPIO_V01 32
 struct wlfw_host_cap_req_msg_v01 {
@@ -574,15 +574,15 @@ struct wlfw_host_cap_req_msg_v01 {
 };
 
 #define WLFW_HOST_CAP_REQ_MSG_V01_MAX_MSG_LEN 189
-extern struct qmi_elem_info wlfw_host_cap_req_msg_v01_ei[];
-extern struct qmi_elem_info wlfw_host_cap_8bit_req_msg_v01_ei[];
+extern const struct qmi_elem_info wlfw_host_cap_req_msg_v01_ei[];
+extern const struct qmi_elem_info wlfw_host_cap_8bit_req_msg_v01_ei[];
 
 struct wlfw_host_cap_resp_msg_v01 {
 	struct qmi_response_type_v01 resp;
 };
 
 #define WLFW_HOST_CAP_RESP_MSG_V01_MAX_MSG_LEN 7
-extern struct qmi_elem_info wlfw_host_cap_resp_msg_v01_ei[];
+extern const struct qmi_elem_info wlfw_host_cap_resp_msg_v01_ei[];
 
 struct wlfw_request_mem_ind_msg_v01 {
 	u32 mem_seg_len;
@@ -590,7 +590,7 @@ struct wlfw_request_mem_ind_msg_v01 {
 };
 
 #define WLFW_REQUEST_MEM_IND_MSG_V01_MAX_MSG_LEN 564
-extern struct qmi_elem_info wlfw_request_mem_ind_msg_v01_ei[];
+extern const struct qmi_elem_info wlfw_request_mem_ind_msg_v01_ei[];
 
 struct wlfw_respond_mem_req_msg_v01 {
 	u32 mem_seg_len;
@@ -598,28 +598,28 @@ struct wlfw_respond_mem_req_msg_v01 {
 };
 
 #define WLFW_RESPOND_MEM_REQ_MSG_V01_MAX_MSG_LEN 260
-extern struct qmi_elem_info wlfw_respond_mem_req_msg_v01_ei[];
+extern const struct qmi_elem_info wlfw_respond_mem_req_msg_v01_ei[];
 
 struct wlfw_respond_mem_resp_msg_v01 {
 	struct qmi_response_type_v01 resp;
 };
 
 #define WLFW_RESPOND_MEM_RESP_MSG_V01_MAX_MSG_LEN 7
-extern struct qmi_elem_info wlfw_respond_mem_resp_msg_v01_ei[];
+extern const struct qmi_elem_info wlfw_respond_mem_resp_msg_v01_ei[];
 
 struct wlfw_mem_ready_ind_msg_v01 {
 	char placeholder;
 };
 
 #define WLFW_MEM_READY_IND_MSG_V01_MAX_MSG_LEN 0
-extern struct qmi_elem_info wlfw_mem_ready_ind_msg_v01_ei[];
+extern const struct qmi_elem_info wlfw_mem_ready_ind_msg_v01_ei[];
 
 struct wlfw_fw_init_done_ind_msg_v01 {
 	char placeholder;
 };
 
 #define WLFW_FW_INIT_DONE_IND_MSG_V01_MAX_MSG_LEN 0
-extern struct qmi_elem_info wlfw_fw_init_done_ind_msg_v01_ei[];
+extern const struct qmi_elem_info wlfw_fw_init_done_ind_msg_v01_ei[];
 
 struct wlfw_rejuvenate_ind_msg_v01 {
 	u8 cause_for_rejuvenation_valid;
@@ -633,21 +633,21 @@ struct wlfw_rejuvenate_ind_msg_v01 {
 };
 
 #define WLFW_REJUVENATE_IND_MSG_V01_MAX_MSG_LEN 144
-extern struct qmi_elem_info wlfw_rejuvenate_ind_msg_v01_ei[];
+extern const struct qmi_elem_info wlfw_rejuvenate_ind_msg_v01_ei[];
 
 struct wlfw_rejuvenate_ack_req_msg_v01 {
 	char placeholder;
 };
 
 #define WLFW_REJUVENATE_ACK_REQ_MSG_V01_MAX_MSG_LEN 0
-extern struct qmi_elem_info wlfw_rejuvenate_ack_req_msg_v01_ei[];
+extern const struct qmi_elem_info wlfw_rejuvenate_ack_req_msg_v01_ei[];
 
 struct wlfw_rejuvenate_ack_resp_msg_v01 {
 	struct qmi_response_type_v01 resp;
 };
 
 #define WLFW_REJUVENATE_ACK_RESP_MSG_V01_MAX_MSG_LEN 7
-extern struct qmi_elem_info wlfw_rejuvenate_ack_resp_msg_v01_ei[];
+extern const struct qmi_elem_info wlfw_rejuvenate_ack_resp_msg_v01_ei[];
 
 struct wlfw_dynamic_feature_mask_req_msg_v01 {
 	u8 mask_valid;
@@ -655,7 +655,7 @@ struct wlfw_dynamic_feature_mask_req_msg_v01 {
 };
 
 #define WLFW_DYNAMIC_FEATURE_MASK_REQ_MSG_V01_MAX_MSG_LEN 11
-extern struct qmi_elem_info wlfw_dynamic_feature_mask_req_msg_v01_ei[];
+extern const struct qmi_elem_info wlfw_dynamic_feature_mask_req_msg_v01_ei[];
 
 struct wlfw_dynamic_feature_mask_resp_msg_v01 {
 	struct qmi_response_type_v01 resp;
@@ -666,7 +666,7 @@ struct wlfw_dynamic_feature_mask_resp_msg_v01 {
 };
 
 #define WLFW_DYNAMIC_FEATURE_MASK_RESP_MSG_V01_MAX_MSG_LEN 29
-extern struct qmi_elem_info wlfw_dynamic_feature_mask_resp_msg_v01_ei[];
+extern const struct qmi_elem_info wlfw_dynamic_feature_mask_resp_msg_v01_ei[];
 
 struct wlfw_m3_info_req_msg_v01 {
 	u64 addr;
@@ -674,20 +674,20 @@ struct wlfw_m3_info_req_msg_v01 {
 };
 
 #define WLFW_M3_INFO_REQ_MSG_V01_MAX_MSG_LEN 18
-extern struct qmi_elem_info wlfw_m3_info_req_msg_v01_ei[];
+extern const struct qmi_elem_info wlfw_m3_info_req_msg_v01_ei[];
 
 struct wlfw_m3_info_resp_msg_v01 {
 	struct qmi_response_type_v01 resp;
 };
 
 #define WLFW_M3_INFO_RESP_MSG_V01_MAX_MSG_LEN 7
-extern struct qmi_elem_info wlfw_m3_info_resp_msg_v01_ei[];
+extern const struct qmi_elem_info wlfw_m3_info_resp_msg_v01_ei[];
 
 struct wlfw_xo_cal_ind_msg_v01 {
 	u8 xo_cal_data;
 };
 
 #define WLFW_XO_CAL_IND_MSG_V01_MAX_MSG_LEN 4
-extern struct qmi_elem_info wlfw_xo_cal_ind_msg_v01_ei[];
+extern const struct qmi_elem_info wlfw_xo_cal_ind_msg_v01_ei[];
 
 #endif
-- 
2.37.0

