Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 757F35B919D
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 02:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbiIOAX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 20:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbiIOAXY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 20:23:24 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 110B989906;
        Wed, 14 Sep 2022 17:23:20 -0700 (PDT)
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28ENq1LS007824;
        Thu, 15 Sep 2022 00:23:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=qcppdkim1;
 bh=VpRVLQpGCFW0cQEexkr1W3XtSZgIraY5Rwsrn8ytycU=;
 b=B7+H/BHiolm0SYRSLFVw3cSP7zURkkq5Qx6jhkrpsiREqceM7Hq7Z874vJoTw0iIBLQV
 csITYVmax+BorbXqhOZ7iyd7eDf0wsZk5h+Z+r8gmlfm3mq+CZCENMDqxZlN44Co60pS
 WeP0paBhBfhandh7+9Nq1bxB2yvCRBAM+Ud0tKZ4/wBNI1FLi0lOfpONgiY2LXwZrCkS
 pJUrv7WJRx0TA7FcJC9Nb+mh2ubpmSXsq2wYro2AUdHzFhVv1vJjWbROK6Qa8xeOW3Up
 7SQMTC1XzngmuH2zmmDw0FBk8UXZ3q75HJZmBMLfYFVWS8Tsnp+5cLpggamJnbo29Gcc gQ== 
Received: from nalasppmta05.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3jjxys4d0r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Sep 2022 00:23:09 +0000
Received: from pps.filterd (NALASPPMTA05.qualcomm.com [127.0.0.1])
        by NALASPPMTA05.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTP id 28F0N815000343;
        Thu, 15 Sep 2022 00:23:08 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by NALASPPMTA05.qualcomm.com (PPS) with ESMTPS id 3jjqbt792d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Sep 2022 00:23:08 +0000
Received: from NALASPPMTA05.qualcomm.com (NALASPPMTA05.qualcomm.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28F0N8u3000335;
        Thu, 15 Sep 2022 00:23:08 GMT
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA05.qualcomm.com (PPS) with ESMTPS id 28F0N8mj000330
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Sep 2022 00:23:08 +0000
Received: from quicinc.com (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 14 Sep
 2022 17:23:08 -0700
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
To:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     <ath11k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] wifi: ath11k: Make QMI message rules const
Date:   Wed, 14 Sep 2022 17:23:03 -0700
Message-ID: <20220915002303.12206-1-quic_jjohnson@quicinc.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220912221335.27520-1-quic_jjohnson@quicinc.com>
References: <20220912221335.27520-1-quic_jjohnson@quicinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.49.16.6]
X-ClientProxiedBy: nalasex01c.na.qualcomm.com (10.47.97.35) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: uAj7W2lfvKqduu-u0JRgavNWcT8hM16Z
X-Proofpoint-GUID: uAj7W2lfvKqduu-u0JRgavNWcT8hM16Z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-14_11,2022-09-14_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 impostorscore=0
 adultscore=0 mlxlogscore=999 spamscore=0 clxscore=1015 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2208220000 definitions=main-2209140117
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit ff6d365898d4 ("soc: qcom: qmi: use const for struct
qmi_elem_info") allows QMI message encoding/decoding rules to be
const, so do that for ath11k.

Compile tested only.

Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
---

v2:
- Added 12th digit to the hash in the commit text
- rebased, updated 2 more definitions added since v1:
  	   qmi_wlanfw_host_cap_req_msg_v01_ei[]
	   qmi_wlfw_fw_init_done_ind_msg_v01_ei[]

Depends-on: https://git.kernel.org/pub/scm/linux/kernel/git/qcom/linux.git/commit/?h=for-next&id=ff6d365898d4d31bd557954c7fc53f38977b491c

drivers/net/wireless/ath/ath11k/qmi.c | 72 +++++++++++++--------------
 1 file changed, 36 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/qmi.c b/drivers/net/wireless/ath/ath11k/qmi.c
index 2be45683260c..42f18c3bcfa3 100644
--- a/drivers/net/wireless/ath/ath11k/qmi.c
+++ b/drivers/net/wireless/ath/ath11k/qmi.c
@@ -28,7 +28,7 @@ module_param_named(cold_boot_cal, ath11k_cold_boot_cal, bool, 0644);
 MODULE_PARM_DESC(cold_boot_cal,
 		 "Decrease the channel switch time but increase the driver load time (Default: true)");
 
-static struct qmi_elem_info qmi_wlanfw_host_cap_req_msg_v01_ei[] = {
+static const struct qmi_elem_info qmi_wlanfw_host_cap_req_msg_v01_ei[] = {
 	{
 		.data_type	= QMI_OPT_FLAG,
 		.elem_len	= 1,
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
@@ -1696,7 +1696,7 @@ static struct qmi_elem_info qmi_wlanfw_wlan_ini_resp_msg_v01_ei[] = {
 	},
 };
 
-static struct qmi_elem_info qmi_wlfw_fw_init_done_ind_msg_v01_ei[] = {
+static const struct qmi_elem_info qmi_wlfw_fw_init_done_ind_msg_v01_ei[] = {
 	{
 		.data_type = QMI_EOTI,
 		.array_type = NO_ARRAY,
-- 
2.37.0

