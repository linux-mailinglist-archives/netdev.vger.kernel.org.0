Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BFE25B6373
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 00:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbiILWPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 18:15:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230292AbiILWOk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 18:14:40 -0400
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 498454E848;
        Mon, 12 Sep 2022 15:14:00 -0700 (PDT)
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28CK012t007156;
        Mon, 12 Sep 2022 22:13:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=qcppdkim1;
 bh=DRxI8WtvP7N6NAkSiy/KPGp6Kl2U9dUfyD4FiVUj7rU=;
 b=FTR5Coedskovmd6TNt0kqIDGUjqgbennARYfP/lf7luknVymlGVp8P8v3WIHpqVXdbMu
 o3H3SLRaH/fxHfrwMb+VDqfDqXM+lPmYmjP5GUKY9WRtr+zdvZ3C9EPtojRx/tn6ZL4N
 eW6deFNvjeiz2jvIPbFYHfkAVviqRB0/WKIe5HnMc0L7YV/LVo7Xnz591GtgD5/7VOFG
 XY+40JflFZQs8vE9J0njVTcgAIIwA+kAg0g617zNWi6HPqCfd2kBy5NIze325cxmdIav
 iFgCcynEuQqH2Spe9CbqYLJvYQ4OXxWT8nLw93gphPe3MG2Vn5vMw7tLFANOvc6kiqdK 1w== 
Received: from nalasppmta04.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3jgkgknc8g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Sep 2022 22:13:43 +0000
Received: from pps.filterd (NALASPPMTA04.qualcomm.com [127.0.0.1])
        by NALASPPMTA04.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTP id 28CMDfsc016239;
        Mon, 12 Sep 2022 22:13:41 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by NALASPPMTA04.qualcomm.com (PPS) with ESMTPS id 3jh43se8b0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Sep 2022 22:13:41 +0000
Received: from NALASPPMTA04.qualcomm.com (NALASPPMTA04.qualcomm.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28CMDf8R016233;
        Mon, 12 Sep 2022 22:13:41 GMT
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA04.qualcomm.com (PPS) with ESMTPS id 28CMDfmM016232
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Sep 2022 22:13:41 +0000
Received: from quicinc.com (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Mon, 12 Sep
 2022 15:13:41 -0700
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
To:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     <ath11k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] wifi: ath11k: Make QMI message rules const
Date:   Mon, 12 Sep 2022 15:13:35 -0700
Message-ID: <20220912221335.27520-1-quic_jjohnson@quicinc.com>
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
X-Proofpoint-GUID: fLMHrxkRrfkpg6lWYgDZpKnPn-Q-8KQF
X-Proofpoint-ORIG-GUID: fLMHrxkRrfkpg6lWYgDZpKnPn-Q-8KQF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-12_14,2022-09-12_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 lowpriorityscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209120076
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit ff6d365898d ("soc: qcom: qmi: use const for struct
qmi_elem_info") allows QMI message encoding/decoding rules to be
const, so do that for ath11k.

Compile tested only.

Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
---
Depends-on: https://git.kernel.org/pub/scm/linux/kernel/git/qcom/linux.git/commit/?h=for-next&id=ff6d365898d4d31bd557954c7fc53f38977b491c

 drivers/net/wireless/ath/ath11k/qmi.c | 68 +++++++++++++--------------
 1 file changed, 34 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/qmi.c b/drivers/net/wireless/ath/ath11k/qmi.c
index 2be45683260c..fa6c21a4897d 100644
--- a/drivers/net/wireless/ath/ath11k/qmi.c
+++ b/drivers/net/wireless/ath/ath11k/qmi.c
@@ -279,7 +279,7 @@ static struct qmi_elem_info qmi_wlanfw_host_cap_req_msg_v01_ei[] = {
 	},
 };
 
-static struct qmi_elem_info qmi_wlanfw_host_cap_resp_msg_v01_ei[] = {
+static const struct qmi_elem_info qmi_wlanfw_host_cap_resp_msg_v01_ei[] = {
 	{
 		.data_type	= QMI_STRUCT,
 		.elem_len	= 1,
@@ -296,7 +296,7 @@ static struct qmi_elem_info qmi_wlanfw_host_cap_resp_msg_v01_ei[] = {
 	},
 };
 
-static struct qmi_elem_info qmi_wlanfw_ind_register_req_msg_v01_ei[] = {
+static const struct qmi_elem_info qmi_wlanfw_ind_register_req_msg_v01_ei[] = {
 	{
 		.data_type	= QMI_OPT_FLAG,
 		.elem_len	= 1,
@@ -521,7 +521,7 @@ static struct qmi_elem_info qmi_wlanfw_ind_register_req_msg_v01_ei[] = {
 	},
 };
 
-static struct qmi_elem_info qmi_wlanfw_ind_register_resp_msg_v01_ei[] = {
+static const struct qmi_elem_info qmi_wlanfw_ind_register_resp_msg_v01_ei[] = {
 	{
 		.data_type	= QMI_STRUCT,
 		.elem_len	= 1,
@@ -557,7 +557,7 @@ static struct qmi_elem_info qmi_wlanfw_ind_register_resp_msg_v01_ei[] = {
 	},
 };
 
-static struct qmi_elem_info qmi_wlanfw_mem_cfg_s_v01_ei[] = {
+static const struct qmi_elem_info qmi_wlanfw_mem_cfg_s_v01_ei[] = {
 	{
 		.data_type	= QMI_UNSIGNED_8_BYTE,
 		.elem_len	= 1,
@@ -589,7 +589,7 @@ static struct qmi_elem_info qmi_wlanfw_mem_cfg_s_v01_ei[] = {
 	},
 };
 
-static struct qmi_elem_info qmi_wlanfw_mem_seg_s_v01_ei[] = {
+static const struct qmi_elem_info qmi_wlanfw_mem_seg_s_v01_ei[] = {
 	{
 		.data_type	= QMI_UNSIGNED_4_BYTE,
 		.elem_len	= 1,
@@ -631,7 +631,7 @@ static struct qmi_elem_info qmi_wlanfw_mem_seg_s_v01_ei[] = {
 	},
 };
 
-static struct qmi_elem_info qmi_wlanfw_request_mem_ind_msg_v01_ei[] = {
+static const struct qmi_elem_info qmi_wlanfw_request_mem_ind_msg_v01_ei[] = {
 	{
 		.data_type	= QMI_DATA_LEN,
 		.elem_len	= 1,
@@ -658,7 +658,7 @@ static struct qmi_elem_info qmi_wlanfw_request_mem_ind_msg_v01_ei[] = {
 	},
 };
 
-static struct qmi_elem_info qmi_wlanfw_mem_seg_resp_s_v01_ei[] = {
+static const struct qmi_elem_info qmi_wlanfw_mem_seg_resp_s_v01_ei[] = {
 	{
 		.data_type	= QMI_UNSIGNED_8_BYTE,
 		.elem_len	= 1,
@@ -698,7 +698,7 @@ static struct qmi_elem_info qmi_wlanfw_mem_seg_resp_s_v01_ei[] = {
 	},
 };
 
-static struct qmi_elem_info qmi_wlanfw_respond_mem_req_msg_v01_ei[] = {
+static const struct qmi_elem_info qmi_wlanfw_respond_mem_req_msg_v01_ei[] = {
 	{
 		.data_type	= QMI_DATA_LEN,
 		.elem_len	= 1,
@@ -725,7 +725,7 @@ static struct qmi_elem_info qmi_wlanfw_respond_mem_req_msg_v01_ei[] = {
 	},
 };
 
-static struct qmi_elem_info qmi_wlanfw_respond_mem_resp_msg_v01_ei[] = {
+static const struct qmi_elem_info qmi_wlanfw_respond_mem_resp_msg_v01_ei[] = {
 	{
 		.data_type	= QMI_STRUCT,
 		.elem_len	= 1,
@@ -743,7 +743,7 @@ static struct qmi_elem_info qmi_wlanfw_respond_mem_resp_msg_v01_ei[] = {
 	},
 };
 
-static struct qmi_elem_info qmi_wlanfw_cap_req_msg_v01_ei[] = {
+static const struct qmi_elem_info qmi_wlanfw_cap_req_msg_v01_ei[] = {
 	{
 		.data_type	= QMI_EOTI,
 		.array_type	= NO_ARRAY,
@@ -751,7 +751,7 @@ static struct qmi_elem_info qmi_wlanfw_cap_req_msg_v01_ei[] = {
 	},
 };
 
-static struct qmi_elem_info qmi_wlanfw_device_info_req_msg_v01_ei[] = {
+static const struct qmi_elem_info qmi_wlanfw_device_info_req_msg_v01_ei[] = {
 	{
 		.data_type      = QMI_EOTI,
 		.array_type     = NO_ARRAY,
@@ -759,7 +759,7 @@ static struct qmi_elem_info qmi_wlanfw_device_info_req_msg_v01_ei[] = {
 	},
 };
 
-static struct qmi_elem_info qmi_wlfw_device_info_resp_msg_v01_ei[] = {
+static const struct qmi_elem_info qmi_wlfw_device_info_resp_msg_v01_ei[] = {
 	{
 		.data_type	= QMI_STRUCT,
 		.elem_len	= 1,
@@ -813,7 +813,7 @@ static struct qmi_elem_info qmi_wlfw_device_info_resp_msg_v01_ei[] = {
 	},
 };
 
-static struct qmi_elem_info qmi_wlanfw_rf_chip_info_s_v01_ei[] = {
+static const struct qmi_elem_info qmi_wlanfw_rf_chip_info_s_v01_ei[] = {
 	{
 		.data_type	= QMI_UNSIGNED_4_BYTE,
 		.elem_len	= 1,
@@ -839,7 +839,7 @@ static struct qmi_elem_info qmi_wlanfw_rf_chip_info_s_v01_ei[] = {
 	},
 };
 
-static struct qmi_elem_info qmi_wlanfw_rf_board_info_s_v01_ei[] = {
+static const struct qmi_elem_info qmi_wlanfw_rf_board_info_s_v01_ei[] = {
 	{
 		.data_type	= QMI_UNSIGNED_4_BYTE,
 		.elem_len	= 1,
@@ -856,7 +856,7 @@ static struct qmi_elem_info qmi_wlanfw_rf_board_info_s_v01_ei[] = {
 	},
 };
 
-static struct qmi_elem_info qmi_wlanfw_soc_info_s_v01_ei[] = {
+static const struct qmi_elem_info qmi_wlanfw_soc_info_s_v01_ei[] = {
 	{
 		.data_type	= QMI_UNSIGNED_4_BYTE,
 		.elem_len	= 1,
@@ -872,7 +872,7 @@ static struct qmi_elem_info qmi_wlanfw_soc_info_s_v01_ei[] = {
 	},
 };
 
-static struct qmi_elem_info qmi_wlanfw_fw_version_info_s_v01_ei[] = {
+static const struct qmi_elem_info qmi_wlanfw_fw_version_info_s_v01_ei[] = {
 	{
 		.data_type	= QMI_UNSIGNED_4_BYTE,
 		.elem_len	= 1,
@@ -898,7 +898,7 @@ static struct qmi_elem_info qmi_wlanfw_fw_version_info_s_v01_ei[] = {
 	},
 };
 
-static struct qmi_elem_info qmi_wlanfw_cap_resp_msg_v01_ei[] = {
+static const struct qmi_elem_info qmi_wlanfw_cap_resp_msg_v01_ei[] = {
 	{
 		.data_type	= QMI_STRUCT,
 		.elem_len	= 1,
@@ -1099,7 +1099,7 @@ static struct qmi_elem_info qmi_wlanfw_cap_resp_msg_v01_ei[] = {
 	},
 };
 
-static struct qmi_elem_info qmi_wlanfw_bdf_download_req_msg_v01_ei[] = {
+static const struct qmi_elem_info qmi_wlanfw_bdf_download_req_msg_v01_ei[] = {
 	{
 		.data_type	= QMI_UNSIGNED_1_BYTE,
 		.elem_len	= 1,
@@ -1234,7 +1234,7 @@ static struct qmi_elem_info qmi_wlanfw_bdf_download_req_msg_v01_ei[] = {
 	},
 };
 
-static struct qmi_elem_info qmi_wlanfw_bdf_download_resp_msg_v01_ei[] = {
+static const struct qmi_elem_info qmi_wlanfw_bdf_download_resp_msg_v01_ei[] = {
 	{
 		.data_type	= QMI_STRUCT,
 		.elem_len	= 1,
@@ -1252,7 +1252,7 @@ static struct qmi_elem_info qmi_wlanfw_bdf_download_resp_msg_v01_ei[] = {
 	},
 };
 
-static struct qmi_elem_info qmi_wlanfw_m3_info_req_msg_v01_ei[] = {
+static const struct qmi_elem_info qmi_wlanfw_m3_info_req_msg_v01_ei[] = {
 	{
 		.data_type	= QMI_UNSIGNED_8_BYTE,
 		.elem_len	= 1,
@@ -1276,7 +1276,7 @@ static struct qmi_elem_info qmi_wlanfw_m3_info_req_msg_v01_ei[] = {
 	},
 };
 
-static struct qmi_elem_info qmi_wlanfw_m3_info_resp_msg_v01_ei[] = {
+static const struct qmi_elem_info qmi_wlanfw_m3_info_resp_msg_v01_ei[] = {
 	{
 		.data_type	= QMI_STRUCT,
 		.elem_len	= 1,
@@ -1293,7 +1293,7 @@ static struct qmi_elem_info qmi_wlanfw_m3_info_resp_msg_v01_ei[] = {
 	},
 };
 
-static struct qmi_elem_info qmi_wlanfw_ce_tgt_pipe_cfg_s_v01_ei[] = {
+static const struct qmi_elem_info qmi_wlanfw_ce_tgt_pipe_cfg_s_v01_ei[] = {
 	{
 		.data_type	= QMI_UNSIGNED_4_BYTE,
 		.elem_len	= 1,
@@ -1346,7 +1346,7 @@ static struct qmi_elem_info qmi_wlanfw_ce_tgt_pipe_cfg_s_v01_ei[] = {
 	},
 };
 
-static struct qmi_elem_info qmi_wlanfw_ce_svc_pipe_cfg_s_v01_ei[] = {
+static const struct qmi_elem_info qmi_wlanfw_ce_svc_pipe_cfg_s_v01_ei[] = {
 	{
 		.data_type	= QMI_UNSIGNED_4_BYTE,
 		.elem_len	= 1,
@@ -1381,7 +1381,7 @@ static struct qmi_elem_info qmi_wlanfw_ce_svc_pipe_cfg_s_v01_ei[] = {
 	},
 };
 
-static struct qmi_elem_info qmi_wlanfw_shadow_reg_cfg_s_v01_ei[] = {
+static const struct qmi_elem_info qmi_wlanfw_shadow_reg_cfg_s_v01_ei[] = {
 	{
 		.data_type	= QMI_UNSIGNED_2_BYTE,
 		.elem_len	= 1,
@@ -1405,7 +1405,7 @@ static struct qmi_elem_info qmi_wlanfw_shadow_reg_cfg_s_v01_ei[] = {
 	},
 };
 
-static struct qmi_elem_info qmi_wlanfw_shadow_reg_v2_cfg_s_v01_ei[] = {
+static const struct qmi_elem_info qmi_wlanfw_shadow_reg_v2_cfg_s_v01_ei[] = {
 	{
 		.data_type	= QMI_UNSIGNED_4_BYTE,
 		.elem_len	= 1,
@@ -1422,7 +1422,7 @@ static struct qmi_elem_info qmi_wlanfw_shadow_reg_v2_cfg_s_v01_ei[] = {
 	},
 };
 
-static struct qmi_elem_info qmi_wlanfw_wlan_mode_req_msg_v01_ei[] = {
+static const struct qmi_elem_info qmi_wlanfw_wlan_mode_req_msg_v01_ei[] = {
 	{
 		.data_type	= QMI_UNSIGNED_4_BYTE,
 		.elem_len	= 1,
@@ -1457,7 +1457,7 @@ static struct qmi_elem_info qmi_wlanfw_wlan_mode_req_msg_v01_ei[] = {
 	},
 };
 
-static struct qmi_elem_info qmi_wlanfw_wlan_mode_resp_msg_v01_ei[] = {
+static const struct qmi_elem_info qmi_wlanfw_wlan_mode_resp_msg_v01_ei[] = {
 	{
 		.data_type	= QMI_STRUCT,
 		.elem_len	= 1,
@@ -1475,7 +1475,7 @@ static struct qmi_elem_info qmi_wlanfw_wlan_mode_resp_msg_v01_ei[] = {
 	},
 };
 
-static struct qmi_elem_info qmi_wlanfw_wlan_cfg_req_msg_v01_ei[] = {
+static const struct qmi_elem_info qmi_wlanfw_wlan_cfg_req_msg_v01_ei[] = {
 	{
 		.data_type	= QMI_OPT_FLAG,
 		.elem_len	= 1,
@@ -1614,7 +1614,7 @@ static struct qmi_elem_info qmi_wlanfw_wlan_cfg_req_msg_v01_ei[] = {
 	},
 };
 
-static struct qmi_elem_info qmi_wlanfw_wlan_cfg_resp_msg_v01_ei[] = {
+static const struct qmi_elem_info qmi_wlanfw_wlan_cfg_resp_msg_v01_ei[] = {
 	{
 		.data_type	= QMI_STRUCT,
 		.elem_len	= 1,
@@ -1631,28 +1631,28 @@ static struct qmi_elem_info qmi_wlanfw_wlan_cfg_resp_msg_v01_ei[] = {
 	},
 };
 
-static struct qmi_elem_info qmi_wlanfw_mem_ready_ind_msg_v01_ei[] = {
+static const struct qmi_elem_info qmi_wlanfw_mem_ready_ind_msg_v01_ei[] = {
 	{
 		.data_type = QMI_EOTI,
 		.array_type = NO_ARRAY,
 	},
 };
 
-static struct qmi_elem_info qmi_wlanfw_fw_ready_ind_msg_v01_ei[] = {
+static const struct qmi_elem_info qmi_wlanfw_fw_ready_ind_msg_v01_ei[] = {
 	{
 		.data_type = QMI_EOTI,
 		.array_type = NO_ARRAY,
 	},
 };
 
-static struct qmi_elem_info qmi_wlanfw_cold_boot_cal_done_ind_msg_v01_ei[] = {
+static const struct qmi_elem_info qmi_wlanfw_cold_boot_cal_done_ind_msg_v01_ei[] = {
 	{
 		.data_type = QMI_EOTI,
 		.array_type = NO_ARRAY,
 	},
 };
 
-static struct qmi_elem_info qmi_wlanfw_wlan_ini_req_msg_v01_ei[] = {
+static const struct qmi_elem_info qmi_wlanfw_wlan_ini_req_msg_v01_ei[] = {
 	{
 		.data_type	= QMI_OPT_FLAG,
 		.elem_len	= 1,
@@ -1678,7 +1678,7 @@ static struct qmi_elem_info qmi_wlanfw_wlan_ini_req_msg_v01_ei[] = {
 	},
 };
 
-static struct qmi_elem_info qmi_wlanfw_wlan_ini_resp_msg_v01_ei[] = {
+static const struct qmi_elem_info qmi_wlanfw_wlan_ini_resp_msg_v01_ei[] = {
 	{
 		.data_type	= QMI_STRUCT,
 		.elem_len	= 1,
-- 
2.37.0

