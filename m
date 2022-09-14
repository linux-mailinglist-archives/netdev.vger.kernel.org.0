Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4AB75B9120
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 01:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbiINXrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 19:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbiINXru (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 19:47:50 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA1B97DF5E;
        Wed, 14 Sep 2022 16:47:48 -0700 (PDT)
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28ENTwUX010379;
        Wed, 14 Sep 2022 23:47:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=qcppdkim1;
 bh=0aMgS5bbhXvHC3fjpUDumFtvyEEpODQdLtUgHKiRKwg=;
 b=pwL6qAYSiNy5lDf1ruQN0wNw8ZBPVtUrUu7P1aK5CH8Nkrx34CSC9BDO8HWKIDVNqScZ
 YkBH4KoKcKwYPjQW7WMyiNazw2MiVxM23txeoy71WxqY//7PgzzBJPuespVeLmtB5q+2
 jWMFWS19t0mqkPuOdkRJ0RVvSuX3I9z7LgSg7y9rzcOUC/Ft6gRCvM+SjBDqc3JkR2ol
 nFhlSJlfSiHUYvFKyNdh1NDutdnspTe1wvXC+uhxWVezQm78rPo8QL4EiiqUJTREnbUk
 Fm7LHuZ/Kly5uXW4DOFknl0g38p+oAfUaXviJfNSc8NzrK5AHk8TLFsiJwFPCU9j08z0 uQ== 
Received: from nalasppmta05.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3jjxyvma4d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Sep 2022 23:47:26 +0000
Received: from pps.filterd (NALASPPMTA05.qualcomm.com [127.0.0.1])
        by NALASPPMTA05.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTP id 28ENlPT1030195;
        Wed, 14 Sep 2022 23:47:25 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by NALASPPMTA05.qualcomm.com (PPS) with ESMTPS id 3jjqbt76e6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Sep 2022 23:47:25 +0000
Received: from NALASPPMTA05.qualcomm.com (NALASPPMTA05.qualcomm.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28ENlOWw030188;
        Wed, 14 Sep 2022 23:47:24 GMT
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA05.qualcomm.com (PPS) with ESMTPS id 28ENlOn5030187
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Sep 2022 23:47:24 +0000
Received: from quicinc.com (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 14 Sep
 2022 16:47:24 -0700
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
Subject: [PATCH v2 2/4] remoteproc: sysmon: Make QMI message rules const
Date:   Wed, 14 Sep 2022 16:47:03 -0700
Message-ID: <20220914234705.28405-3-quic_jjohnson@quicinc.com>
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
X-Proofpoint-GUID: T-5NCdNHJHJwu7A_EMwvogdcWRdL5W6L
X-Proofpoint-ORIG-GUID: T-5NCdNHJHJwu7A_EMwvogdcWRdL5W6L
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-14_09,2022-09-14_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 priorityscore=1501
 suspectscore=0 mlxlogscore=999 clxscore=1011 bulkscore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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
const, so do that for sysmon.

Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Reviewed-by: Alex Elder <elder@linaro.org>
Reviewed-by: Sibi Sankar <quic_sibis@quicinc.com>
---
 drivers/remoteproc/qcom_sysmon.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/remoteproc/qcom_sysmon.c b/drivers/remoteproc/qcom_sysmon.c
index 57dde2a69b9d..3992bb61d2ec 100644
--- a/drivers/remoteproc/qcom_sysmon.c
+++ b/drivers/remoteproc/qcom_sysmon.c
@@ -190,7 +190,7 @@ struct ssctl_shutdown_resp {
 	struct qmi_response_type_v01 resp;
 };
 
-static struct qmi_elem_info ssctl_shutdown_resp_ei[] = {
+static const struct qmi_elem_info ssctl_shutdown_resp_ei[] = {
 	{
 		.data_type	= QMI_STRUCT,
 		.elem_len	= 1,
@@ -211,7 +211,7 @@ struct ssctl_subsys_event_req {
 	u32 evt_driven;
 };
 
-static struct qmi_elem_info ssctl_subsys_event_req_ei[] = {
+static const struct qmi_elem_info ssctl_subsys_event_req_ei[] = {
 	{
 		.data_type	= QMI_DATA_LEN,
 		.elem_len	= 1,
@@ -269,7 +269,7 @@ struct ssctl_subsys_event_resp {
 	struct qmi_response_type_v01 resp;
 };
 
-static struct qmi_elem_info ssctl_subsys_event_resp_ei[] = {
+static const struct qmi_elem_info ssctl_subsys_event_resp_ei[] = {
 	{
 		.data_type	= QMI_STRUCT,
 		.elem_len	= 1,
@@ -283,7 +283,7 @@ static struct qmi_elem_info ssctl_subsys_event_resp_ei[] = {
 	{}
 };
 
-static struct qmi_elem_info ssctl_shutdown_ind_ei[] = {
+static const struct qmi_elem_info ssctl_shutdown_ind_ei[] = {
 	{}
 };
 
-- 
2.37.0

