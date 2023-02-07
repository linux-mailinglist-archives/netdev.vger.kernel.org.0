Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F40B368D460
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 11:34:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231631AbjBGKeQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 05:34:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231529AbjBGKeB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 05:34:01 -0500
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6D212E0FA;
        Tue,  7 Feb 2023 02:33:26 -0800 (PST)
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 317ACp1B001411;
        Tue, 7 Feb 2023 10:33:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=qcppdkim1;
 bh=E/fAdF/zkHo45BBMEQJvly0JrNdpGoTOtqVn/he4rmM=;
 b=O7wsVV3DeJvlrTP19R0VlrEu7/tziaT3755k3lDS75vSOdsmYAp+/yXn9We8ert+NQsU
 WBthX9hwBRDUs14MEW0S6B26dhU46pSEEg7hgSJ/uRBKnvx3xfwQuNLhyWCqHcxdnEMp
 iIwtsvXk1RoYJwdxVqiHPzrF8y6iDmWBNoj0DGNP3EIRsk2GYV//sZmN8zmwUVj5+rGO
 FNl8+IhQ5XE4KcjgkXWvT5XhzQt4W0Ugaxi0b78FhoGcEWulivkU3lao7IGAoSDpx+Ao
 /krCvYXONpbusFsU47bmi7L4QgzuDBntd6CIJ2crlhtObOcAYBeHWaDIVCBA0vO9a534 fQ== 
Received: from nalasppmta05.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3nkgafgpmc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Feb 2023 10:33:15 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA05.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 317AXD6o002710
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 7 Feb 2023 10:33:13 GMT
Received: from youghand-linux.qualcomm.com (10.80.80.8) by
 nalasex01a.na.qualcomm.com (10.47.209.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Tue, 7 Feb 2023 02:33:10 -0800
From:   Youghandhar Chintala <quic_youghand@quicinc.com>
To:     <kvalo@kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>
CC:     <ath11k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Youghandhar Chintala <quic_youghand@quicinc.com>
Subject: [PATCH v3 2/2] wifi: ath11k: PMIC XO cal data support
Date:   Tue, 7 Feb 2023 16:02:07 +0530
Message-ID: <20230207103207.759-4-quic_youghand@quicinc.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230207103207.759-1-quic_youghand@quicinc.com>
References: <20230207103207.759-1-quic_youghand@quicinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: FZSx19-Ylg1D7_nhWf9MkyRHawd5neX9
X-Proofpoint-ORIG-GUID: FZSx19-Ylg1D7_nhWf9MkyRHawd5neX9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-07_02,2023-02-06_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0 spamscore=0
 mlxlogscore=999 mlxscore=0 priorityscore=1501 suspectscore=0
 impostorscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2302070092
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PMIC XO is the clock source for Wi-Fi RF clock in integrated Wi-Fi
chipset ex: WCN6750. Due to board layout errors XO frequency drifts
can cause Wi-Fi RF clock inaccuracy.
XO calibration test tree in Factory Test Mode is used to find the
best frequency offset(for example +/-2 KHz )by programming XO trim
register. This ensure system clock stays within required 20 ppm
WLAN RF clock.

Retrieve the XO trim offset via system firmware (e.g., device tree),
especially in the case where the device doesn't have a useful EEPROM
on which to store the calibrated XO offset (e.g., for integrated Wi-Fi).
Calibrated XO offset is sent to firmware, which compensate the clock drift
by programing the XO trim register.

Tested-on: WCN6750 hw1.0 AHB WLAN.MSL.1.0.1-00887-QCAMSLSWPLZ-1

Signed-off-by: Youghandhar Chintala <quic_youghand@quicinc.com>
---
 drivers/net/wireless/ath/ath11k/ahb.c  |  8 ++++++++
 drivers/net/wireless/ath/ath11k/core.h |  3 +++
 drivers/net/wireless/ath/ath11k/qmi.c  | 24 ++++++++++++++++++++++++
 drivers/net/wireless/ath/ath11k/qmi.h  |  4 +++-
 4 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/ahb.c b/drivers/net/wireless/ath/ath11k/ahb.c
index d34a4d6325b2..89580b4e47a9 100644
--- a/drivers/net/wireless/ath/ath11k/ahb.c
+++ b/drivers/net/wireless/ath/ath11k/ahb.c
@@ -1039,6 +1039,14 @@ static int ath11k_ahb_fw_resources_init(struct ath11k_base *ab)
 	ab_ahb->fw.iommu_domain = iommu_dom;
 	of_node_put(node);
 
+	ret = of_property_read_u32(pdev->dev.of_node, "xo-cal-data", &ab->xo_cal_data);
+	if (ret) {
+		ath11k_dbg(ab, ATH11K_DBG_AHB, "failed to get xo-cal-data property\n");
+		return 0;
+	}
+	ab->xo_cal_supported = true;
+	ath11k_dbg(ab, ATH11K_DBG_AHB, "xo cal data 0x%x\n", ab->xo_cal_data);
+
 	return 0;
 
 err_iommu_unmap:
diff --git a/drivers/net/wireless/ath/ath11k/core.h b/drivers/net/wireless/ath/ath11k/core.h
index 22460b0abf03..783398e98915 100644
--- a/drivers/net/wireless/ath/ath11k/core.h
+++ b/drivers/net/wireless/ath/ath11k/core.h
@@ -969,6 +969,9 @@ struct ath11k_base {
 		const struct ath11k_pci_ops *ops;
 	} pci;
 
+	bool xo_cal_supported;
+	u32 xo_cal_data;
+
 	/* must be last */
 	u8 drv_priv[] __aligned(sizeof(void *));
 };
diff --git a/drivers/net/wireless/ath/ath11k/qmi.c b/drivers/net/wireless/ath/ath11k/qmi.c
index 145f20a681bd..67f386b001ab 100644
--- a/drivers/net/wireless/ath/ath11k/qmi.c
+++ b/drivers/net/wireless/ath/ath11k/qmi.c
@@ -1451,6 +1451,24 @@ static struct qmi_elem_info qmi_wlanfw_wlan_mode_req_msg_v01_ei[] = {
 		.offset		= offsetof(struct qmi_wlanfw_wlan_mode_req_msg_v01,
 					   hw_debug),
 	},
+	{
+		.data_type  = QMI_OPT_FLAG,
+		.elem_len   = 1,
+		.elem_size  = sizeof(u8),
+		.array_type = NO_ARRAY,
+		.tlv_type   = 0x11,
+		.offset     = offsetof(struct qmi_wlanfw_wlan_mode_req_msg_v01,
+				       xo_cal_data_valid),
+	},
+	{
+		.data_type  = QMI_UNSIGNED_1_BYTE,
+		.elem_len   = 1,
+		.elem_size  = sizeof(u8),
+		.array_type = NO_ARRAY,
+		.tlv_type   = 0x11,
+		.offset     = offsetof(struct qmi_wlanfw_wlan_mode_req_msg_v01,
+				       xo_cal_data),
+	},
 	{
 		.data_type	= QMI_EOTI,
 		.array_type	= NO_ARRAY,
@@ -2610,6 +2628,12 @@ static int ath11k_qmi_wlanfw_mode_send(struct ath11k_base *ab,
 	req.hw_debug_valid = 1;
 	req.hw_debug = 0;
 
+	if (ab->xo_cal_supported) {
+		req.xo_cal_data_valid = 1;
+		req.xo_cal_data = ab->xo_cal_data;
+	}
+	ath11k_dbg(ab, ATH11K_DBG_QMI, "xo_cal_supported %d\n", ab->xo_cal_supported);
+
 	ret = qmi_txn_init(&ab->qmi.handle, &txn,
 			   qmi_wlanfw_wlan_mode_resp_msg_v01_ei, &resp);
 	if (ret < 0)
diff --git a/drivers/net/wireless/ath/ath11k/qmi.h b/drivers/net/wireless/ath/ath11k/qmi.h
index 2ec56a34fa81..db61ce0d5689 100644
--- a/drivers/net/wireless/ath/ath11k/qmi.h
+++ b/drivers/net/wireless/ath/ath11k/qmi.h
@@ -450,7 +450,7 @@ struct qmi_wlanfw_m3_info_resp_msg_v01 {
 	struct qmi_response_type_v01 resp;
 };
 
-#define QMI_WLANFW_WLAN_MODE_REQ_MSG_V01_MAX_LEN	11
+#define QMI_WLANFW_WLAN_MODE_REQ_MSG_V01_MAX_LEN	17
 #define QMI_WLANFW_WLAN_MODE_RESP_MSG_V01_MAX_LEN	7
 #define QMI_WLANFW_WLAN_CFG_REQ_MSG_V01_MAX_LEN		803
 #define QMI_WLANFW_WLAN_CFG_RESP_MSG_V01_MAX_LEN	7
@@ -470,6 +470,8 @@ struct qmi_wlanfw_wlan_mode_req_msg_v01 {
 	u32 mode;
 	u8 hw_debug_valid;
 	u8 hw_debug;
+	u8 xo_cal_data_valid;
+	u8 xo_cal_data;
 };
 
 struct qmi_wlanfw_wlan_mode_resp_msg_v01 {
-- 
2.38.0

