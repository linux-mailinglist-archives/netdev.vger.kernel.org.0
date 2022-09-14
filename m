Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4127F5B911B
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 01:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbiINXrt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 19:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiINXrr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 19:47:47 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9896C7DF6D;
        Wed, 14 Sep 2022 16:47:46 -0700 (PDT)
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28ENaxEF025185;
        Wed, 14 Sep 2022 23:47:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=qcppdkim1;
 bh=aPr17ekLylROd1PS0yNaW1fdPCsIX5fCTRdl33vZyL8=;
 b=BkjQ14GpPF95LvaQhg8aFJ07I/Ngyg+6e6lgYldb/BPA8WDRneKRVNnavvSDb5+orz2D
 Yzzwlycgc+EggXnr4SsGn1Te1p153eUpwJrvleH5mdD01HFv44ZQAZru3xpo8TUEwU/W
 G37tLUQ1I2D3RY70kdxigm25licdLcrGX3XlUdfnYn+X09/fg/T4zS6m2c2dT3Kl4xMr
 U+jvum1jNzl3GQK85AZobOyhZ8EwaNmxl5ut01c8KyGHew/FQtCYM2iaQG+UZJpm/CGG
 i6ffrLpbvbHbBiFlerx2NobYA5upyTrj4yYH/i4jFkvxRTvDyQdjdtvYt4KwpIRrU+Yy 1g== 
Received: from nalasppmta05.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3jkd9ht39j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Sep 2022 23:47:26 +0000
Received: from pps.filterd (NALASPPMTA05.qualcomm.com [127.0.0.1])
        by NALASPPMTA05.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTP id 28ENlPLq030209;
        Wed, 14 Sep 2022 23:47:25 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by NALASPPMTA05.qualcomm.com (PPS) with ESMTPS id 3jjqbt76ea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Sep 2022 23:47:25 +0000
Received: from NALASPPMTA05.qualcomm.com (NALASPPMTA05.qualcomm.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28ENlPKp030201;
        Wed, 14 Sep 2022 23:47:25 GMT
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA05.qualcomm.com (PPS) with ESMTPS id 28ENlPVX030200
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Sep 2022 23:47:25 +0000
Received: from quicinc.com (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 14 Sep
 2022 16:47:25 -0700
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
To:     Alex Elder <elder@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Kalle Valo <kvalo@kernel.org>, Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>
CC:     <linux-arm-msm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-remoteproc@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>,
        Jeff Johnson <quic_jjohnson@quicinc.com>,
        Alex Elder <elder@linaro.org>,
        Sibi Sankar <quic_sibis@quicinc.com>
Subject: [PATCH v2 4/4] soc: qcom: pdr: Make QMI message rules const
Date:   Wed, 14 Sep 2022 16:47:05 -0700
Message-ID: <20220914234705.28405-5-quic_jjohnson@quicinc.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220914234705.28405-1-quic_jjohnson@quicinc.com>
References: <20220912232526.27427-1-quic_jjohnson@quicinc.com>
 <20220914234705.28405-1-quic_jjohnson@quicinc.com>
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
X-Proofpoint-ORIG-GUID: RK265g3xtEexPLOOdY72v2kPE-gTUU8w
X-Proofpoint-GUID: RK265g3xtEexPLOOdY72v2kPE-gTUU8w
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-14_10,2022-09-14_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 phishscore=0 impostorscore=0 bulkscore=0 lowpriorityscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 mlxlogscore=999 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2208220000 definitions=main-2209140113
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
const, so do that for QCOM PDR.

Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Reviewed-by: Alex Elder <elder@linaro.org>
Reviewed-by: Sibi Sankar <quic_sibis@quicinc.com>
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

