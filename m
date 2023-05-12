Return-Path: <netdev+bounces-2143-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 99C587007CE
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 14:25:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 516BB281A94
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 12:25:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C375D536;
	Fri, 12 May 2023 12:25:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0D31078D
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 12:25:12 +0000 (UTC)
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E6BC14360;
	Fri, 12 May 2023 05:24:56 -0700 (PDT)
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34CB4G1O007234;
	Fri, 12 May 2023 12:24:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=qcppdkim1;
 bh=tkJIcgPvLt+FXvEGDdQDjw42Vv00XI3JSeoSUH3TTCo=;
 b=XA63UEI6Zj+t3EidzQeN0iF7ddnSoJygzbAxTkmB1U5Y6VokiCyZGbjWQn28eM4sIzUn
 BmVH22JA99g7yNdD/iHdUkiZyos++pwwzmMo9E59odLRy3kDTW/vlVJPor9slOeDTtZT
 wG9G6wos/tQSvCH1Cqxabud3JQwkK63Rpn0S5wtOCeF8PkZ/N3QDSZi5XSY5zUoDBsmr
 30Y7+KNBzmMSt/m8zh+bNn01ZWe3d8MngiNFUq8TAteLK0/zVbWFJ9ud5jVQOmqkWx5r
 psLOd16zjqwtGozVjIZSqoQf8oON61HUyPLXueWn6WPpgkYgH3ePvfkLN4KMVm1s3mM3 FQ== 
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3qh8hm1hrr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 May 2023 12:24:36 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 34CCOZJ2019886
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 May 2023 12:24:35 GMT
Received: from hu-tdas-hyd.qualcomm.com (10.80.80.8) by
 nalasex01a.na.qualcomm.com (10.47.209.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.42; Fri, 12 May 2023 05:24:30 -0700
From: Taniya Das <quic_tdas@quicinc.com>
To: Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd
	<sboyd@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski
	<krzysztof.kozlowski+dt@linaro.org>,
        Richard Cochran
	<richardcochran@gmail.com>,
        Conor Dooley <conor+dt@kernel.org>, Andy Gross
	<agross@kernel.org>
CC: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio
	<konrad.dybcio@linaro.org>,
        Imran Shaik <quic_imrashai@quicinc.com>,
        <linux-arm-msm@vger.kernel.org>, <linux-clk@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <jkona@quicinc.com>,
        <quic_rohiagar@quicinc.com>, Taniya Das <quic_tdas@quicinc.com>
Subject: [PATCH V2 2/5] dt-bindings: clock: qcom: Add GCC clocks for SDX75
Date: Fri, 12 May 2023 17:53:44 +0530
Message-ID: <20230512122347.1219-3-quic_tdas@quicinc.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230512122347.1219-1-quic_tdas@quicinc.com>
References: <20230512122347.1219-1-quic_tdas@quicinc.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: ZhC-0ULO88C5v9dB5TE4l5GG4P0TJRKv
X-Proofpoint-ORIG-GUID: ZhC-0ULO88C5v9dB5TE4l5GG4P0TJRKv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-12_08,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 mlxscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 spamscore=0 adultscore=0 impostorscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305120104
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Imran Shaik <quic_imrashai@quicinc.com>

Add support for qcom global clock controller bindings for SDX75 platform.

Signed-off-by: Imran Shaik <quic_imrashai@quicinc.com>
Signed-off-by: Taniya Das <quic_tdas@quicinc.com>
---
Changes since V1:
 - Updated the naming convention as SoC-IP.
 - Removed the clock-names property.
 - Added the RPMHCC bindings in a separate patch.

 .../bindings/clock/qcom,sdx75-gcc.yaml        |  65 ++++++
 include/dt-bindings/clock/qcom,sdx75-gcc.h    | 193 ++++++++++++++++++
 2 files changed, 258 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/qcom,sdx75-gcc.yaml
 create mode 100644 include/dt-bindings/clock/qcom,sdx75-gcc.h

diff --git a/Documentation/devicetree/bindings/clock/qcom,sdx75-gcc.yaml b/Documentation/devicetree/bindings/clock/qcom,sdx75-gcc.yaml
new file mode 100644
index 000000000000..98921fa236b1
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/qcom,sdx75-gcc.yaml
@@ -0,0 +1,65 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/clock/qcom,sdx75-gcc.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Qualcomm Global Clock & Reset Controller on SDX75
+
+maintainers:
+  - Imran Shaik <quic_imrashai@quicinc.com>
+  - Taniya Das <quic_tdas@quicinc.com>
+
+description: |
+  Qualcomm global clock control module provides the clocks, resets and power
+  domains on SDX75
+
+  See also:: include/dt-bindings/clock/qcom,sdx75-gcc.h
+
+properties:
+  compatible:
+    const: qcom,sdx75-gcc
+
+  clocks:
+    items:
+      - description: Board XO source
+      - description: Sleep clock source
+      - description: EMAC0 sgmiiphy mac rclk source
+      - description: EMAC0 sgmiiphy mac tclk source
+      - description: EMAC0 sgmiiphy rclk source
+      - description: EMAC0 sgmiiphy tclk source
+      - description: EMAC1 sgmiiphy mac rclk source
+      - description: EMAC1 sgmiiphy mac tclk source
+      - description: EMAC1 sgmiiphy rclk source
+      - description: EMAC1 sgmiiphy tclk source
+      - description: PCIE20 phy aux clock source
+      - description: PCIE_1 Pipe clock source
+      - description: PCIE_2 Pipe clock source
+      - description: PCIE Pipe clock source
+      - description: USB3 phy wrapper pipe clock source
+
+required:
+  - compatible
+  - clocks
+
+allOf:
+  - $ref: qcom,gcc.yaml#
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/clock/qcom,rpmh.h>
+    clock-controller@80000 {
+      compatible = "qcom,sdx75-gcc";
+      reg = <0x80000 0x1f7400>;
+      clocks = <&rpmhcc RPMH_CXO_CLK>, <&sleep_clk>, <&emac0_sgmiiphy_mac_rclk>,
+               <&emac0_sgmiiphy_mac_tclk>, <&emac0_sgmiiphy_rclk>, <&emac0_sgmiiphy_tclk>,
+               <&emac1_sgmiiphy_mac_rclk>, <&emac1_sgmiiphy_mac_tclk>, <&emac1_sgmiiphy_rclk>,
+               <&emac1_sgmiiphy_tclk>, <&pcie20_phy_aux_clk>, <&pcie_1_pipe_clk>,
+               <&pcie_2_pipe_clk>, <&pcie_pipe_clk>, <&usb3_phy_wrapper_gcc_usb30_pipe_clk>;
+      #clock-cells = <1>;
+      #reset-cells = <1>;
+      #power-domain-cells = <1>;
+    };
+...
diff --git a/include/dt-bindings/clock/qcom,sdx75-gcc.h b/include/dt-bindings/clock/qcom,sdx75-gcc.h
new file mode 100644
index 000000000000..a470e8c4fd41
--- /dev/null
+++ b/include/dt-bindings/clock/qcom,sdx75-gcc.h
@@ -0,0 +1,193 @@
+/* SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause) */
+/*
+ * Copyright (c) 2022-2023, Qualcomm Innovation Center, Inc. All rights reserved.
+ */
+
+#ifndef _DT_BINDINGS_CLK_QCOM_GCC_SDX75_H
+#define _DT_BINDINGS_CLK_QCOM_GCC_SDX75_H
+
+/* GCC clocks */
+#define GPLL0							0
+#define GPLL0_OUT_EVEN						1
+#define GPLL4							2
+#define GPLL5							3
+#define GPLL6							4
+#define GPLL8							5
+#define GCC_AHB_PCIE_LINK_CLK					6
+#define GCC_BOOT_ROM_AHB_CLK					7
+#define GCC_EEE_EMAC0_CLK					8
+#define GCC_EEE_EMAC0_CLK_SRC					9
+#define GCC_EEE_EMAC1_CLK					10
+#define GCC_EEE_EMAC1_CLK_SRC					11
+#define GCC_EMAC0_AXI_CLK					12
+#define GCC_EMAC0_CC_SGMIIPHY_RX_CLK				13
+#define GCC_EMAC0_CC_SGMIIPHY_RX_CLK_SRC			14
+#define GCC_EMAC0_CC_SGMIIPHY_TX_CLK				15
+#define GCC_EMAC0_CC_SGMIIPHY_TX_CLK_SRC			16
+#define GCC_EMAC0_PHY_AUX_CLK					17
+#define GCC_EMAC0_PHY_AUX_CLK_SRC				18
+#define GCC_EMAC0_PTP_CLK					19
+#define GCC_EMAC0_PTP_CLK_SRC					20
+#define GCC_EMAC0_RGMII_CLK					21
+#define GCC_EMAC0_RGMII_CLK_SRC					22
+#define GCC_EMAC0_RPCS_RX_CLK					23
+#define GCC_EMAC0_RPCS_TX_CLK					24
+#define GCC_EMAC0_SGMIIPHY_MAC_RCLK_SRC				25
+#define GCC_EMAC0_SGMIIPHY_MAC_TCLK_SRC				26
+#define GCC_EMAC0_SLV_AHB_CLK					27
+#define GCC_EMAC0_XGXS_RX_CLK					28
+#define GCC_EMAC0_XGXS_TX_CLK					29
+#define GCC_EMAC1_AXI_CLK					30
+#define GCC_EMAC1_CC_SGMIIPHY_RX_CLK				31
+#define GCC_EMAC1_CC_SGMIIPHY_RX_CLK_SRC			32
+#define GCC_EMAC1_CC_SGMIIPHY_TX_CLK				33
+#define GCC_EMAC1_CC_SGMIIPHY_TX_CLK_SRC			34
+#define GCC_EMAC1_PHY_AUX_CLK					35
+#define GCC_EMAC1_PHY_AUX_CLK_SRC				36
+#define GCC_EMAC1_PTP_CLK					37
+#define GCC_EMAC1_PTP_CLK_SRC					38
+#define GCC_EMAC1_RGMII_CLK					39
+#define GCC_EMAC1_RGMII_CLK_SRC					40
+#define GCC_EMAC1_RPCS_RX_CLK					41
+#define GCC_EMAC1_RPCS_TX_CLK					42
+#define GCC_EMAC1_SGMIIPHY_MAC_RCLK_SRC				43
+#define GCC_EMAC1_SGMIIPHY_MAC_TCLK_SRC				44
+#define GCC_EMAC1_SLV_AHB_CLK					45
+#define GCC_EMAC1_XGXS_RX_CLK					46
+#define GCC_EMAC1_XGXS_TX_CLK					47
+#define GCC_EMAC_0_CLKREF_EN					48
+#define GCC_EMAC_1_CLKREF_EN					49
+#define GCC_GP1_CLK						50
+#define GCC_GP1_CLK_SRC						51
+#define GCC_GP2_CLK						52
+#define GCC_GP2_CLK_SRC						53
+#define GCC_GP3_CLK						54
+#define GCC_GP3_CLK_SRC						55
+#define GCC_PCIE_0_CLKREF_EN					56
+#define GCC_PCIE_1_AUX_CLK					57
+#define GCC_PCIE_1_AUX_PHY_CLK_SRC				58
+#define GCC_PCIE_1_CFG_AHB_CLK					59
+#define GCC_PCIE_1_CLKREF_EN					60
+#define GCC_PCIE_1_MSTR_AXI_CLK					61
+#define GCC_PCIE_1_PHY_RCHNG_CLK				62
+#define GCC_PCIE_1_PHY_RCHNG_CLK_SRC				63
+#define GCC_PCIE_1_PIPE_CLK					64
+#define GCC_PCIE_1_PIPE_CLK_SRC					65
+#define GCC_PCIE_1_PIPE_DIV2_CLK				66
+#define GCC_PCIE_1_PIPE_DIV2_CLK_SRC				67
+#define GCC_PCIE_1_SLV_AXI_CLK					68
+#define GCC_PCIE_1_SLV_Q2A_AXI_CLK				69
+#define GCC_PCIE_2_AUX_CLK					70
+#define GCC_PCIE_2_AUX_PHY_CLK_SRC				71
+#define GCC_PCIE_2_CFG_AHB_CLK					72
+#define GCC_PCIE_2_CLKREF_EN					73
+#define GCC_PCIE_2_MSTR_AXI_CLK					74
+#define GCC_PCIE_2_PHY_RCHNG_CLK				75
+#define GCC_PCIE_2_PHY_RCHNG_CLK_SRC				76
+#define GCC_PCIE_2_PIPE_CLK					77
+#define GCC_PCIE_2_PIPE_CLK_SRC					78
+#define GCC_PCIE_2_PIPE_DIV2_CLK				79
+#define GCC_PCIE_2_PIPE_DIV2_CLK_SRC				80
+#define GCC_PCIE_2_SLV_AXI_CLK					81
+#define GCC_PCIE_2_SLV_Q2A_AXI_CLK				82
+#define GCC_PCIE_AUX_CLK					83
+#define GCC_PCIE_AUX_CLK_SRC					84
+#define GCC_PCIE_AUX_PHY_CLK_SRC				85
+#define GCC_PCIE_CFG_AHB_CLK					86
+#define GCC_PCIE_MSTR_AXI_CLK					87
+#define GCC_PCIE_PIPE_CLK					88
+#define GCC_PCIE_PIPE_CLK_SRC					89
+#define GCC_PCIE_RCHNG_PHY_CLK					90
+#define GCC_PCIE_RCHNG_PHY_CLK_SRC				91
+#define GCC_PCIE_SLEEP_CLK					92
+#define GCC_PCIE_SLV_AXI_CLK					93
+#define GCC_PCIE_SLV_Q2A_AXI_CLK				94
+#define GCC_PDM2_CLK						95
+#define GCC_PDM2_CLK_SRC					96
+#define GCC_PDM_AHB_CLK						97
+#define GCC_PDM_XO4_CLK						98
+#define GCC_QUPV3_WRAP0_CORE_2X_CLK				99
+#define GCC_QUPV3_WRAP0_CORE_CLK				100
+#define GCC_QUPV3_WRAP0_S0_CLK					101
+#define GCC_QUPV3_WRAP0_S0_CLK_SRC				102
+#define GCC_QUPV3_WRAP0_S1_CLK					103
+#define GCC_QUPV3_WRAP0_S1_CLK_SRC				104
+#define GCC_QUPV3_WRAP0_S2_CLK					105
+#define GCC_QUPV3_WRAP0_S2_CLK_SRC				106
+#define GCC_QUPV3_WRAP0_S3_CLK					107
+#define GCC_QUPV3_WRAP0_S3_CLK_SRC				108
+#define GCC_QUPV3_WRAP0_S4_CLK					109
+#define GCC_QUPV3_WRAP0_S4_CLK_SRC				110
+#define GCC_QUPV3_WRAP0_S5_CLK					111
+#define GCC_QUPV3_WRAP0_S5_CLK_SRC				112
+#define GCC_QUPV3_WRAP0_S6_CLK					113
+#define GCC_QUPV3_WRAP0_S6_CLK_SRC				114
+#define GCC_QUPV3_WRAP0_S7_CLK					115
+#define GCC_QUPV3_WRAP0_S7_CLK_SRC				116
+#define GCC_QUPV3_WRAP0_S8_CLK					117
+#define GCC_QUPV3_WRAP0_S8_CLK_SRC				118
+#define GCC_QUPV3_WRAP_0_M_AHB_CLK				119
+#define GCC_QUPV3_WRAP_0_S_AHB_CLK				120
+#define GCC_SDCC1_AHB_CLK					121
+#define GCC_SDCC1_APPS_CLK					122
+#define GCC_SDCC1_APPS_CLK_SRC					123
+#define GCC_SDCC2_AHB_CLK					124
+#define GCC_SDCC2_APPS_CLK					125
+#define GCC_SDCC2_APPS_CLK_SRC					126
+#define GCC_USB2_CLKREF_EN					127
+#define GCC_USB30_MASTER_CLK					128
+#define GCC_USB30_MASTER_CLK_SRC				129
+#define GCC_USB30_MOCK_UTMI_CLK					130
+#define GCC_USB30_MOCK_UTMI_CLK_SRC				131
+#define GCC_USB30_MOCK_UTMI_POSTDIV_CLK_SRC			132
+#define GCC_USB30_MSTR_AXI_CLK					133
+#define GCC_USB30_SLEEP_CLK					134
+#define GCC_USB30_SLV_AHB_CLK					135
+#define GCC_USB3_PHY_AUX_CLK					136
+#define GCC_USB3_PHY_AUX_CLK_SRC				137
+#define GCC_USB3_PHY_PIPE_CLK					138
+#define GCC_USB3_PHY_PIPE_CLK_SRC				139
+#define GCC_USB3_PRIM_CLKREF_EN					140
+#define GCC_USB_PHY_CFG_AHB2PHY_CLK				141
+#define GCC_XO_PCIE_LINK_CLK					142
+
+/* GCC power domains */
+#define GCC_EMAC0_GDSC						0
+#define GCC_EMAC1_GDSC						1
+#define GCC_PCIE_1_GDSC						2
+#define GCC_PCIE_1_PHY_GDSC					3
+#define GCC_PCIE_2_GDSC						4
+#define GCC_PCIE_2_PHY_GDSC					5
+#define GCC_PCIE_GDSC						6
+#define GCC_PCIE_PHY_GDSC					7
+#define GCC_USB30_GDSC						8
+#define GCC_USB3_PHY_GDSC					9
+
+/* GCC resets */
+#define GCC_EMAC0_BCR						0
+#define GCC_EMAC1_BCR						1
+#define GCC_EMMC_BCR						2
+#define GCC_PCIE_1_BCR						3
+#define GCC_PCIE_1_LINK_DOWN_BCR				4
+#define GCC_PCIE_1_NOCSR_COM_PHY_BCR				5
+#define GCC_PCIE_1_PHY_BCR					6
+#define GCC_PCIE_2_BCR						7
+#define GCC_PCIE_2_LINK_DOWN_BCR				8
+#define GCC_PCIE_2_NOCSR_COM_PHY_BCR				9
+#define GCC_PCIE_2_PHY_BCR					10
+#define GCC_PCIE_BCR						11
+#define GCC_PCIE_LINK_DOWN_BCR					12
+#define GCC_PCIE_NOCSR_COM_PHY_BCR				13
+#define GCC_PCIE_PHY_BCR					14
+#define GCC_PCIE_PHY_CFG_AHB_BCR				15
+#define GCC_PCIE_PHY_COM_BCR					16
+#define GCC_PCIE_PHY_NOCSR_COM_PHY_BCR				17
+#define GCC_QUSB2PHY_BCR					18
+#define GCC_TCSR_PCIE_BCR					19
+#define GCC_USB30_BCR						20
+#define GCC_USB3_PHY_BCR					21
+#define GCC_USB3PHY_PHY_BCR					22
+#define GCC_USB_PHY_CFG_AHB2PHY_BCR				23
+#define GCC_EMAC0_RGMII_CLK_ARES				24
+
+#endif
-- 
2.17.1


