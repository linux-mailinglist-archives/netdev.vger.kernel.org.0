Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 374315B640D
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 01:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbiILX0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 19:26:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbiILX0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 19:26:02 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A0650048;
        Mon, 12 Sep 2022 16:26:02 -0700 (PDT)
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28CMsWHo002159;
        Mon, 12 Sep 2022 23:25:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=qcppdkim1;
 bh=o7yVBGrqw8jg+SP/Ez0w5BIaDfIsIYCNzQ/K1VpRpHk=;
 b=g1MJGuCN+ZnAUSC9b7p/YxHoLygf5d+os5vrC9N6KcA/IlztIYxlENlVG6He+3qRsNHQ
 gEeMJUHvMBzOSYpzJfuUeDxDquX+B2ogxG4XhI7xuoyS//tcJK+2TBFS9j0ebCt92bXL
 /QacHzEUJBNhz/tsZj4JBcpBdiwCCNPfQy7cJGI9Q5VDP9W8ZLemdYFEh2X4TR5wbCv8
 3yIpXXEaS2G3DUevtscR30Y/W4O+WgrFTQEkUUcGXBZo5W68UEoN3jVmcX12UraSEOQI
 4YRoir2D3BMIvUociprKb7ju2AshzhlM+/G+3z3Jpp687CS1Kve2Cxty4UKrfaDX3O34 bQ== 
Received: from nalasppmta03.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3jgkve6j7c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Sep 2022 23:25:45 +0000
Received: from pps.filterd (NALASPPMTA03.qualcomm.com [127.0.0.1])
        by NALASPPMTA03.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTP id 28CNPiJt012128;
        Mon, 12 Sep 2022 23:25:44 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by NALASPPMTA03.qualcomm.com (PPS) with ESMTPS id 3jh430pdhj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Sep 2022 23:25:44 +0000
Received: from NALASPPMTA03.qualcomm.com (NALASPPMTA03.qualcomm.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28CNPho2012121;
        Mon, 12 Sep 2022 23:25:43 GMT
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA03.qualcomm.com (PPS) with ESMTPS id 28CNPhBA012120
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Sep 2022 23:25:43 +0000
Received: from quicinc.com (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Mon, 12 Sep
 2022 16:25:43 -0700
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
Subject: [PATCH 2/4] remoteproc: sysmon: Make QMI message rules const
Date:   Mon, 12 Sep 2022 16:25:24 -0700
Message-ID: <20220912232526.27427-3-quic_jjohnson@quicinc.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220912232526.27427-2-quic_jjohnson@quicinc.com>
References: <20220912232526.27427-1-quic_jjohnson@quicinc.com>
 <20220912232526.27427-2-quic_jjohnson@quicinc.com>
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
X-Proofpoint-ORIG-GUID: -IwzH6AuqDSir_IXeiBoqXHZj0LKz8Ht
X-Proofpoint-GUID: -IwzH6AuqDSir_IXeiBoqXHZj0LKz8Ht
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-12_14,2022-09-12_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 adultscore=0 mlxlogscore=989 spamscore=0 suspectscore=0 bulkscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
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
const, so do that for sysmon.

Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
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

