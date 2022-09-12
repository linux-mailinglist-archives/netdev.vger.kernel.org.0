Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A63F5B642B
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 01:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbiILXbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 19:31:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiILXbD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 19:31:03 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C631117E19;
        Mon, 12 Sep 2022 16:31:02 -0700 (PDT)
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28CN1iBG030048;
        Mon, 12 Sep 2022 23:30:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=qcppdkim1;
 bh=H4gkJ7lGhBwpNvavzob6IRQ3LblFZ9KJi9jYLAfVmVY=;
 b=IGCH03/PZYff36omPoq29fAZzh2ANWlX+NkoE3xvnUY393/m8F6dUmldCp8Lohdnhymk
 hM5tbvpv3vcoNm0Y1EL2mLTYcq787vNyGBYbTRLqR9t+bs/WF0elcmCDNXpyWLlO93pc
 mk8h0q33i9cQTGktMcuaw0o5ZCnyDHkLXhU1YqGZGC/C1qebwxoLKZLON58e2kX4R+7y
 /IISJfDxDgmjtJv3M2WBO/ffK/GmGfao0wqI0YUjvnRHEFNbWZRS0fazqOOtiOUD4MoZ
 3qbNi8Fnx8TvAE9ESuO1UYw/OlRPOIF9zcwH5GN0U5V/zXMwXotpQ+BJ3c7fnbcxPXlQ VQ== 
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3jgk2axmgu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Sep 2022 23:30:48 +0000
Received: from pps.filterd (NALASPPMTA02.qualcomm.com [127.0.0.1])
        by NALASPPMTA02.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTP id 28CNPk2t027949;
        Mon, 12 Sep 2022 23:25:46 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by NALASPPMTA02.qualcomm.com (PPS) with ESMTPS id 3jj1ubtpb8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Sep 2022 23:25:46 +0000
Received: from NALASPPMTA02.qualcomm.com (NALASPPMTA02.qualcomm.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28CNPkcO027944;
        Mon, 12 Sep 2022 23:25:46 GMT
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA02.qualcomm.com (PPS) with ESMTPS id 28CNPkZl027943
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Sep 2022 23:25:46 +0000
Received: from quicinc.com (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Mon, 12 Sep
 2022 16:25:46 -0700
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
To:     Alex Elder <elder@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Kalle Valo <kvalo@kernel.org>, Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>
CC:     <linux-arm-msm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-remoteproc@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>,
        Jeff Johnson <quic_jjohnson@quicinc.com>
Subject: [PATCH 4/4] soc: qcom: pdr: Make QMI message rules const
Date:   Mon, 12 Sep 2022 16:25:26 -0700
Message-ID: <20220912232526.27427-5-quic_jjohnson@quicinc.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220912232526.27427-4-quic_jjohnson@quicinc.com>
References: <20220912232526.27427-1-quic_jjohnson@quicinc.com>
 <20220912232526.27427-2-quic_jjohnson@quicinc.com>
 <20220912232526.27427-3-quic_jjohnson@quicinc.com>
 <20220912232526.27427-4-quic_jjohnson@quicinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.49.16.6]
X-ClientProxiedBy: nalasex01a.na.qualcomm.com (10.47.209.196) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: z-_hmi1uk3OBcBIMU3qatUe_bQW--Boe
X-Proofpoint-GUID: z-_hmi1uk3OBcBIMU3qatUe_bQW--Boe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-12_14,2022-09-12_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 malwarescore=0 bulkscore=0 suspectscore=0 spamscore=0 clxscore=1015
 priorityscore=1501 mlxscore=0 adultscore=0 impostorscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209120082
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
const, so do that for QCOM PDR.

Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
---
 drivers/soc/qcom/pdr_internal.h | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/soc/qcom/pdr_internal.h b/drivers/soc/qcom/pdr_internal.h
index a30422214943..03c282b7f17e 100644
--- a/drivers/soc/qcom/pdr_internal.h
+++ b/drivers/soc/qcom/pdr_internal.h
@@ -28,7 +28,7 @@ struct servreg_location_entry {
 	u32 instance;
 };
 
-static struct qmi_elem_info servreg_location_entry_ei[] = {
+static const struct qmi_elem_info servreg_location_entry_ei[] = {
 	{
 		.data_type      = QMI_STRING,
 		.elem_len       = SERVREG_NAME_LENGTH + 1,
@@ -74,7 +74,7 @@ struct servreg_get_domain_list_req {
 	u32 domain_offset;
 };
 
-static struct qmi_elem_info servreg_get_domain_list_req_ei[] = {
+static const struct qmi_elem_info servreg_get_domain_list_req_ei[] = {
 	{
 		.data_type      = QMI_STRING,
 		.elem_len       = SERVREG_NAME_LENGTH + 1,
@@ -116,7 +116,7 @@ struct servreg_get_domain_list_resp {
 	struct servreg_location_entry domain_list[SERVREG_DOMAIN_LIST_LENGTH];
 };
 
-static struct qmi_elem_info servreg_get_domain_list_resp_ei[] = {
+static const struct qmi_elem_info servreg_get_domain_list_resp_ei[] = {
 	{
 		.data_type      = QMI_STRUCT,
 		.elem_len       = 1,
@@ -199,7 +199,7 @@ struct servreg_register_listener_req {
 	char service_path[SERVREG_NAME_LENGTH + 1];
 };
 
-static struct qmi_elem_info servreg_register_listener_req_ei[] = {
+static const struct qmi_elem_info servreg_register_listener_req_ei[] = {
 	{
 		.data_type      = QMI_UNSIGNED_1_BYTE,
 		.elem_len       = 1,
@@ -227,7 +227,7 @@ struct servreg_register_listener_resp {
 	enum servreg_service_state curr_state;
 };
 
-static struct qmi_elem_info servreg_register_listener_resp_ei[] = {
+static const struct qmi_elem_info servreg_register_listener_resp_ei[] = {
 	{
 		.data_type      = QMI_STRUCT,
 		.elem_len       = 1,
@@ -263,7 +263,7 @@ struct servreg_restart_pd_req {
 	char service_path[SERVREG_NAME_LENGTH + 1];
 };
 
-static struct qmi_elem_info servreg_restart_pd_req_ei[] = {
+static const struct qmi_elem_info servreg_restart_pd_req_ei[] = {
 	{
 		.data_type      = QMI_STRING,
 		.elem_len       = SERVREG_NAME_LENGTH + 1,
@@ -280,7 +280,7 @@ struct servreg_restart_pd_resp {
 	struct qmi_response_type_v01 resp;
 };
 
-static struct qmi_elem_info servreg_restart_pd_resp_ei[] = {
+static const struct qmi_elem_info servreg_restart_pd_resp_ei[] = {
 	{
 		.data_type      = QMI_STRUCT,
 		.elem_len       = 1,
@@ -300,7 +300,7 @@ struct servreg_state_updated_ind {
 	u16 transaction_id;
 };
 
-static struct qmi_elem_info servreg_state_updated_ind_ei[] = {
+static const struct qmi_elem_info servreg_state_updated_ind_ei[] = {
 	{
 		.data_type      = QMI_SIGNED_4_BYTE_ENUM,
 		.elem_len       = 1,
@@ -336,7 +336,7 @@ struct servreg_set_ack_req {
 	u16 transaction_id;
 };
 
-static struct qmi_elem_info servreg_set_ack_req_ei[] = {
+static const struct qmi_elem_info servreg_set_ack_req_ei[] = {
 	{
 		.data_type      = QMI_STRING,
 		.elem_len       = SERVREG_NAME_LENGTH + 1,
@@ -362,7 +362,7 @@ struct servreg_set_ack_resp {
 	struct qmi_response_type_v01 resp;
 };
 
-static struct qmi_elem_info servreg_set_ack_resp_ei[] = {
+static const struct qmi_elem_info servreg_set_ack_resp_ei[] = {
 	{
 		.data_type      = QMI_STRUCT,
 		.elem_len       = 1,
-- 
2.37.0

