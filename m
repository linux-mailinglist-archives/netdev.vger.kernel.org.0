Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7326034CB
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 23:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbiJRVSV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 17:18:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbiJRVSC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 17:18:02 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 503BFC1D90;
        Tue, 18 Oct 2022 14:17:32 -0700 (PDT)
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29IJiA8X028392;
        Tue, 18 Oct 2022 21:17:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=qcppdkim1;
 bh=vcAI7+9if4L3ZSrPinubxP+3HGJgFOX/lKKsCDnDFK8=;
 b=NZ3uq10YZ4UIH8g9MKIrcxqXXbOuBPe491UBuKZEPXMb5M/zEkw/dGdYRDqKe6FSfEXB
 PuxeR4rD4hkCIf48hfSNC+PVnIvEKnFjyJ3TMtQtLAyhT/nbK1ns4g7xIrHnxn2FOM9+
 5MOYlaM0zvtYZww7S/asrYjG5U9pJI43ASqmJzx65TVzaPXG3E4w9dQA835V7qKWLtDY
 WjG0cq9x1pUaat/FAiepx0Ud3fin3L3H8FeygYCq1yRoueBoFordq50UPzzd6VhNSvUr
 boGEY2f5yOyOAWKaAyZJSyQWTU8A4Gj31LNrFUNskxDhUMplVX9/ns/YAFRubM7TUVcz ZA== 
Received: from nalasppmta03.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3k9gwebg9f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Oct 2022 21:17:26 +0000
Received: from pps.filterd (NALASPPMTA03.qualcomm.com [127.0.0.1])
        by NALASPPMTA03.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTP id 29ILHQGl018656;
        Tue, 18 Oct 2022 21:17:26 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by NALASPPMTA03.qualcomm.com (PPS) with ESMTPS id 3k7nxkqs3q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Oct 2022 21:17:26 +0000
Received: from NALASPPMTA03.qualcomm.com (NALASPPMTA03.qualcomm.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29ILHQ0v018569;
        Tue, 18 Oct 2022 21:17:26 GMT
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA03.qualcomm.com (PPS) with ESMTPS id 29ILHQdw018557
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Oct 2022 21:17:26 +0000
Received: from quicinc.com (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Tue, 18 Oct
 2022 14:17:25 -0700
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
To:     Alex Elder <elder@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jeff Johnson <quic_jjohnson@quicinc.com>,
        Alex Elder <elder@linaro.org>,
        Sibi Sankar <quic_sibis@quicinc.com>
Subject: [RESEND PATCH net-next] net: ipa: Make QMI message rules const
Date:   Tue, 18 Oct 2022 14:17:18 -0700
Message-ID: <20221018211718.23628-1-quic_jjohnson@quicinc.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220914234705.28405-2-quic_jjohnson@quicinc.com>
References: <20220914234705.28405-2-quic_jjohnson@quicinc.com>
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
X-Proofpoint-GUID: pvKY-tqUf2KE6dyM6JMGyhh9BInEEFq5
X-Proofpoint-ORIG-GUID: pvKY-tqUf2KE6dyM6JMGyhh9BInEEFq5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-18_07,2022-10-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 phishscore=0
 spamscore=0 impostorscore=0 adultscore=0 mlxscore=0 priorityscore=1501
 mlxlogscore=953 lowpriorityscore=0 suspectscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210180119
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit ff6d365898d4 ("soc: qcom: qmi: use const for struct
qmi_elem_info") allows QMI message encoding/decoding rules to be
const, so do that for IPA.

Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Reviewed-by: Alex Elder <elder@linaro.org>
Reviewed-by: Sibi Sankar <quic_sibis@quicinc.com>
---
This patch was last sent as part of the series:
[PATCH v2 0/4] Make QMI message rules const
https://lore.kernel.org/linux-arm-msm/20220914234705.28405-1-quic_jjohnson@quicinc.com/

As

[PATCH v2 1/4] net: ipa: Make QMI message rules const
https://lore.kernel.org/linux-arm-msm/20220914234705.28405-2-quic_jjohnson@quicinc.com/

Since the individual patches in the series will land in separate
trees, and since there are no dependencies between them, they are
being resent separately when the following dependent change has landed
in the destination tree
ff6d365898d4 ("soc: qcom: qmi: use const for struct qmi_elem_info")

That dependent change has landed in netdev/net-next.git so this patch
is now ready to be consumed.

 drivers/net/ipa/ipa_qmi_msg.c | 20 ++++++++++----------
 drivers/net/ipa/ipa_qmi_msg.h | 20 ++++++++++----------
 2 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ipa/ipa_qmi_msg.c b/drivers/net/ipa/ipa_qmi_msg.c
index 97c0befe8d86..894f99517233 100644
--- a/drivers/net/ipa/ipa_qmi_msg.c
+++ b/drivers/net/ipa/ipa_qmi_msg.c
@@ -9,7 +9,7 @@
 #include "ipa_qmi_msg.h"
 
 /* QMI message structure definition for struct ipa_indication_register_req */
-struct qmi_elem_info ipa_indication_register_req_ei[] = {
+const struct qmi_elem_info ipa_indication_register_req_ei[] = {
 	{
 		.data_type	= QMI_OPT_FLAG,
 		.elem_len	= 1,
@@ -116,7 +116,7 @@ struct qmi_elem_info ipa_indication_register_req_ei[] = {
 };
 
 /* QMI message structure definition for struct ipa_indication_register_rsp */
-struct qmi_elem_info ipa_indication_register_rsp_ei[] = {
+const struct qmi_elem_info ipa_indication_register_rsp_ei[] = {
 	{
 		.data_type	= QMI_STRUCT,
 		.elem_len	= 1,
@@ -134,7 +134,7 @@ struct qmi_elem_info ipa_indication_register_rsp_ei[] = {
 };
 
 /* QMI message structure definition for struct ipa_driver_init_complete_req */
-struct qmi_elem_info ipa_driver_init_complete_req_ei[] = {
+const struct qmi_elem_info ipa_driver_init_complete_req_ei[] = {
 	{
 		.data_type	= QMI_UNSIGNED_1_BYTE,
 		.elem_len	= 1,
@@ -151,7 +151,7 @@ struct qmi_elem_info ipa_driver_init_complete_req_ei[] = {
 };
 
 /* QMI message structure definition for struct ipa_driver_init_complete_rsp */
-struct qmi_elem_info ipa_driver_init_complete_rsp_ei[] = {
+const struct qmi_elem_info ipa_driver_init_complete_rsp_ei[] = {
 	{
 		.data_type	= QMI_STRUCT,
 		.elem_len	= 1,
@@ -169,7 +169,7 @@ struct qmi_elem_info ipa_driver_init_complete_rsp_ei[] = {
 };
 
 /* QMI message structure definition for struct ipa_init_complete_ind */
-struct qmi_elem_info ipa_init_complete_ind_ei[] = {
+const struct qmi_elem_info ipa_init_complete_ind_ei[] = {
 	{
 		.data_type	= QMI_STRUCT,
 		.elem_len	= 1,
@@ -187,7 +187,7 @@ struct qmi_elem_info ipa_init_complete_ind_ei[] = {
 };
 
 /* QMI message structure definition for struct ipa_mem_bounds */
-struct qmi_elem_info ipa_mem_bounds_ei[] = {
+const struct qmi_elem_info ipa_mem_bounds_ei[] = {
 	{
 		.data_type	= QMI_UNSIGNED_4_BYTE,
 		.elem_len	= 1,
@@ -208,7 +208,7 @@ struct qmi_elem_info ipa_mem_bounds_ei[] = {
 };
 
 /* QMI message structure definition for struct ipa_mem_array */
-struct qmi_elem_info ipa_mem_array_ei[] = {
+const struct qmi_elem_info ipa_mem_array_ei[] = {
 	{
 		.data_type	= QMI_UNSIGNED_4_BYTE,
 		.elem_len	= 1,
@@ -229,7 +229,7 @@ struct qmi_elem_info ipa_mem_array_ei[] = {
 };
 
 /* QMI message structure definition for struct ipa_mem_range */
-struct qmi_elem_info ipa_mem_range_ei[] = {
+const struct qmi_elem_info ipa_mem_range_ei[] = {
 	{
 		.data_type	= QMI_UNSIGNED_4_BYTE,
 		.elem_len	= 1,
@@ -250,7 +250,7 @@ struct qmi_elem_info ipa_mem_range_ei[] = {
 };
 
 /* QMI message structure definition for struct ipa_init_modem_driver_req */
-struct qmi_elem_info ipa_init_modem_driver_req_ei[] = {
+const struct qmi_elem_info ipa_init_modem_driver_req_ei[] = {
 	{
 		.data_type	= QMI_OPT_FLAG,
 		.elem_len	= 1,
@@ -645,7 +645,7 @@ struct qmi_elem_info ipa_init_modem_driver_req_ei[] = {
 };
 
 /* QMI message structure definition for struct ipa_init_modem_driver_rsp */
-struct qmi_elem_info ipa_init_modem_driver_rsp_ei[] = {
+const struct qmi_elem_info ipa_init_modem_driver_rsp_ei[] = {
 	{
 		.data_type	= QMI_STRUCT,
 		.elem_len	= 1,
diff --git a/drivers/net/ipa/ipa_qmi_msg.h b/drivers/net/ipa/ipa_qmi_msg.h
index e29663965f43..b73503552c4d 100644
--- a/drivers/net/ipa/ipa_qmi_msg.h
+++ b/drivers/net/ipa/ipa_qmi_msg.h
@@ -247,15 +247,15 @@ struct ipa_init_modem_driver_rsp {
 };
 
 /* Message structure definitions defined in "ipa_qmi_msg.c" */
-extern struct qmi_elem_info ipa_indication_register_req_ei[];
-extern struct qmi_elem_info ipa_indication_register_rsp_ei[];
-extern struct qmi_elem_info ipa_driver_init_complete_req_ei[];
-extern struct qmi_elem_info ipa_driver_init_complete_rsp_ei[];
-extern struct qmi_elem_info ipa_init_complete_ind_ei[];
-extern struct qmi_elem_info ipa_mem_bounds_ei[];
-extern struct qmi_elem_info ipa_mem_array_ei[];
-extern struct qmi_elem_info ipa_mem_range_ei[];
-extern struct qmi_elem_info ipa_init_modem_driver_req_ei[];
-extern struct qmi_elem_info ipa_init_modem_driver_rsp_ei[];
+extern const struct qmi_elem_info ipa_indication_register_req_ei[];
+extern const struct qmi_elem_info ipa_indication_register_rsp_ei[];
+extern const struct qmi_elem_info ipa_driver_init_complete_req_ei[];
+extern const struct qmi_elem_info ipa_driver_init_complete_rsp_ei[];
+extern const struct qmi_elem_info ipa_init_complete_ind_ei[];
+extern const struct qmi_elem_info ipa_mem_bounds_ei[];
+extern const struct qmi_elem_info ipa_mem_array_ei[];
+extern const struct qmi_elem_info ipa_mem_range_ei[];
+extern const struct qmi_elem_info ipa_init_modem_driver_req_ei[];
+extern const struct qmi_elem_info ipa_init_modem_driver_rsp_ei[];
 
 #endif /* !_IPA_QMI_MSG_H_ */
-- 
2.37.3

