Return-Path: <netdev+bounces-64-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B97706F4FBA
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 07:39:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8B6C61C20A05
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 05:39:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1299A49;
	Wed,  3 May 2023 05:39:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD10DA45
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 05:39:54 +0000 (UTC)
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9F312736;
	Tue,  2 May 2023 22:39:52 -0700 (PDT)
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 343523qM018166;
	Wed, 3 May 2023 05:39:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=qcppdkim1;
 bh=nbX9m9duY4Ccv7LjqF2S0/odDkqSyyaYinMSibystkI=;
 b=ET6NcRQgevVtZxWfNMn59q5H6+LnVEhA/ffC7mwRYjkSEpBz5vS8chIdQtjnev4FFF1a
 L3nF68+08vvNkkxqxNGPvHExAUqDxZtSRSqKD5tkEq5/F610b3tR6pVxqTUSy4/YKo5g
 jy4v8KHSO+575lb9S8F19Olxn/tD/NtIEE58odAiUfC6jcwurWjkcUuB5q/rCfKIipRz
 evMsxrJF5O6xrt+BVRgQSbA6bABfGSPHHs9Z6D1WH1Rkj6X/NrOTyFta4KXdA0OIeS7j
 Hvt7Z5vUl/QNXe4SLyoGHLREbvOL6uZv4cPmtMbu4mIOlAf3z0yY/rvT+PV3tw3R2aHX KA== 
Received: from apblrppmta02.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.18.19])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3qb4us9hkv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 03 May 2023 05:39:46 +0000
Received: from pps.filterd (APBLRPPMTA02.qualcomm.com [127.0.0.1])
	by APBLRPPMTA02.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTP id 3435dgiQ012674;
	Wed, 3 May 2023 05:39:42 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by APBLRPPMTA02.qualcomm.com (PPS) with ESMTP id 3q8vakyggy-1;
	Wed, 03 May 2023 05:39:42 +0000
Received: from APBLRPPMTA02.qualcomm.com (APBLRPPMTA02.qualcomm.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3435dgP0012661;
	Wed, 3 May 2023 05:39:42 GMT
Received: from hu-sgudaval-hyd.qualcomm.com (hu-rohiagar-hyd.qualcomm.com [10.213.106.138])
	by APBLRPPMTA02.qualcomm.com (PPS) with ESMTP id 3435dgue012659;
	Wed, 03 May 2023 05:39:42 +0000
Received: by hu-sgudaval-hyd.qualcomm.com (Postfix, from userid 3970568)
	id 0AB6350F9; Wed,  3 May 2023 11:09:42 +0530 (+0530)
From: Rohit Agarwal <quic_rohiagar@quicinc.com>
To: agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org,
        linus.walleij@linaro.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, richardcochran@gmail.com,
        manivannan.sadhasivam@linaro.org, andy.shevchenko@gmail.com
Cc: linux-arm-msm@vger.kernel.org, linux-gpio@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Rohit Agarwal <quic_rohiagar@quicinc.com>
Subject: [PATCH v5 1/3] dt-bindings: pinctrl: qcom: Add SDX75 pinctrl devicetree compatible
Date: Wed,  3 May 2023 11:09:38 +0530
Message-Id: <1683092380-29551-2-git-send-email-quic_rohiagar@quicinc.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1683092380-29551-1-git-send-email-quic_rohiagar@quicinc.com>
References: <1683092380-29551-1-git-send-email-quic_rohiagar@quicinc.com>
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: TjcCzt3H-1QFQN35FrIdwwVJIsOQgIOZ
X-Proofpoint-ORIG-GUID: TjcCzt3H-1QFQN35FrIdwwVJIsOQgIOZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-03_02,2023-04-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 adultscore=0 priorityscore=1501 phishscore=0
 impostorscore=0 mlxlogscore=999 spamscore=0 malwarescore=0 clxscore=1015
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305030044
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>

Add device tree binding Documentation details for Qualcomm SDX75
pinctrl driver.

Signed-off-by: Rohit Agarwal <quic_rohiagar@quicinc.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 .../bindings/pinctrl/qcom,sdx75-tlmm.yaml          | 169 +++++++++++++++++++++
 1 file changed, 169 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/qcom,sdx75-tlmm.yaml

diff --git a/Documentation/devicetree/bindings/pinctrl/qcom,sdx75-tlmm.yaml b/Documentation/devicetree/bindings/pinctrl/qcom,sdx75-tlmm.yaml
new file mode 100644
index 0000000..7ebc69d
--- /dev/null
+++ b/Documentation/devicetree/bindings/pinctrl/qcom,sdx75-tlmm.yaml
@@ -0,0 +1,169 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/pinctrl/qcom,sdx75-tlmm.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Qualcomm Technologies, Inc. SDX75 TLMM block
+
+maintainers:
+  - Rohit Agarwal <quic_rohiagar@quicinc.com>
+
+description:
+  Top Level Mode Multiplexer pin controller in Qualcomm SDX75 SoC.
+
+allOf:
+  - $ref: /schemas/pinctrl/qcom,tlmm-common.yaml#
+
+properties:
+  compatible:
+    const: qcom,sdx75-tlmm
+
+  reg:
+    maxItems: 1
+
+  interrupts: true
+  interrupt-controller: true
+  "#interrupt-cells": true
+  gpio-controller: true
+
+  gpio-reserved-ranges:
+    minItems: 1
+    maxItems: 67
+
+  gpio-line-names:
+    maxItems: 133
+
+  "#gpio-cells": true
+  gpio-ranges: true
+  wakeup-parent: true
+
+patternProperties:
+  "-state$":
+    oneOf:
+      - $ref: "#/$defs/qcom-sdx75-tlmm-state"
+      - patternProperties:
+          "-pins$":
+            $ref: "#/$defs/qcom-sdx75-tlmm-state"
+        additionalProperties: false
+
+$defs:
+  qcom-sdx75-tlmm-state:
+    type: object
+    description:
+      Pinctrl node's client devices use subnodes for desired pin configuration.
+      Client device subnodes use below standard properties.
+    $ref: qcom,tlmm-common.yaml#/$defs/qcom-tlmm-state
+    unevaluatedProperties: false
+
+    properties:
+      pins:
+        description:
+          List of gpio pins affected by the properties specified in this
+          subnode.
+        items:
+          oneOf:
+            - pattern: "^gpio([0-9]|[1-9][0-9]|1[0-2][0-9]|13[0-2])$"
+            - enum: [ sdc1_clk, sdc1_cmd, sdc1_data, sdc1_rclk, sdc2_clk, sdc2_cmd, sdc2_data ]
+        minItems: 1
+        maxItems: 36
+
+      function:
+        description:
+          Specify the alternative function to be configured for the specified
+          pins.
+        enum: [ gpio, eth0_mdc, eth0_mdio, eth1_mdc, eth1_mdio,
+                qlink0_wmss_reset, qlink1_wmss_reset, rgmii_rxc, rgmii_rxd0,
+                rgmii_rxd1, rgmii_rxd2, rgmii_rxd3, rgmii_rx_ctl, rgmii_txc,
+                rgmii_txd0, rgmii_txd1, rgmii_txd2, rgmii_txd3, rgmii_tx_ctl,
+                adsp_ext_vfr, atest_char_start, atest_char_status0,
+                atest_char_status1, atest_char_status2, atest_char_status3,
+                audio_ref_clk, bimc_dte_test0, bimc_dte_test1,
+                char_exec_pending, char_exec_release, coex_uart2_rx,
+                coex_uart2_tx, coex_uart_rx, coex_uart_tx, cri_trng_rosc,
+                cri_trng_rosc0, cri_trng_rosc1, dbg_out_clk, ddr_bist_complete,
+                ddr_bist_fail, ddr_bist_start, ddr_bist_stop, ddr_pxi0_test,
+                ebi0_wrcdc_dq2, ebi0_wrcdc_dq3, ebi2_a_d, ebi2_lcd_cs,
+                ebi2_lcd_reset, ebi2_lcd_te, emac0_mcg_pst0, emac0_mcg_pst1,
+                emac0_mcg_pst2, emac0_mcg_pst3, emac0_ptp_aux, emac0_ptp_pps,
+                emac1_mcg_pst0, emac1_mcg_pst1, emac1_mcg_pst2, emac1_mcg_pst3,
+                emac1_ptp_aux0, emac1_ptp_aux1, emac1_ptp_aux2, emac1_ptp_aux3,
+                emac1_ptp_pps0, emac1_ptp_pps1, emac1_ptp_pps2, emac1_ptp_pps3,
+                emac_cdc_dtest0, emac_cdc_dtest1, emac_pps_in, ext_dbg_uart,
+                gcc_125_clk, gcc_gp1_clk, gcc_gp2_clk, gcc_gp3_clk,
+                gcc_plltest_bypassnl, gcc_plltest_resetn, i2s_mclk,
+                jitter_bist_ref, ldo_en, ldo_update, m_voc_ext, mgpi_clk_req,
+                native0, native1, native2, native3, native_char_start,
+                native_tsens_osc, native_tsense_pwm1, nav_dr_sync, nav_gpio_0,
+                nav_gpio_1, nav_gpio_2, nav_gpio_3, pa_indicator_1, pci_e_rst,
+                pcie0_clkreq_n, pcie1_clkreq_n, pcie2_clkreq_n, pll_bist_sync,
+                pll_clk_aux, pll_ref_clk, pri_mi2s_data0, pri_mi2s_data1,
+                pri_mi2s_sck, pri_mi2s_ws, prng_rosc_test0, prng_rosc_test1,
+                prng_rosc_test2, prng_rosc_test3, qdss_cti_trig0,
+                qdss_cti_trig1, qdss_gpio_traceclk, qdss_gpio_tracectl,
+                qdss_gpio_tracedata0, qdss_gpio_tracedata1,
+                qdss_gpio_tracedata10, qdss_gpio_tracedata11,
+                qdss_gpio_tracedata12, qdss_gpio_tracedata13,
+                qdss_gpio_tracedata14, qdss_gpio_tracedata15,
+                qdss_gpio_tracedata2, qdss_gpio_tracedata3,
+                qdss_gpio_tracedata4, qdss_gpio_tracedata5,
+                qdss_gpio_tracedata6, qdss_gpio_tracedata7,
+                qdss_gpio_tracedata8, qdss_gpio_tracedata9, qlink0_b_en,
+                qlink0_b_req, qlink0_l_en, qlink0_l_req, qlink1_l_en,
+                qlink1_l_req, qup_se0_l0, qup_se0_l1, qup_se0_l2, qup_se0_l3,
+                qup_se1_l2, qup_se1_l3, qup_se2_l0, qup_se2_l1, qup_se2_l2,
+                qup_se2_l3, qup_se3_l0, qup_se3_l1, qup_se3_l2, qup_se3_l3,
+                qup_se4_l2, qup_se4_l3, qup_se5_l0, qup_se5_l1, qup_se6_l0,
+                qup_se6_l1, qup_se6_l2, qup_se6_l3, qup_se7_l0, qup_se7_l1,
+                qup_se7_l2, qup_se7_l3, qup_se8_l2, qup_se8_l3, qup_se1_l2_mira,
+                qup_se1_l2_mirb, qup_se1_l3_mira, qup_se1_l3_mirb, sdc1_tb_trig,
+                sdc2_tb_trig, sec_mi2s_data0, sec_mi2s_data1, sec_mi2s_sck,
+                sec_mi2s_ws, sgmii_phy_intr0, sgmii_phy_intr1, spmi_coex_clk,
+                spmi_coex_data, spmi_vgi_hwevent, tgu_ch0_trigout,
+                tri_mi2s_data0, tri_mi2s_data1, tri_mi2s_sck, tri_mi2s_ws,
+                uim1_clk, uim1_data, uim1_present, uim1_reset, uim2_clk,
+                uim2_data, uim2_present, uim2_reset, usb2phy_ac_en,
+                vsense_trigger_mirnat]
+
+    required:
+      - pins
+
+required:
+  - compatible
+  - reg
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    tlmm: pinctrl@f100000 {
+        compatible = "qcom,sdx75-tlmm";
+        reg = <0x0f100000 0x300000>;
+        gpio-controller;
+        #gpio-cells = <2>;
+        gpio-ranges = <&tlmm 0 0 133>;
+        interrupt-controller;
+        #interrupt-cells = <2>;
+        interrupts = <GIC_SPI 208 IRQ_TYPE_LEVEL_HIGH>;
+
+        gpio-wo-state {
+            pins = "gpio1";
+            function = "gpio";
+        };
+
+        uart-w-state {
+            rx-pins {
+                pins = "gpio12";
+                function = "qup_se1_l2_mira";
+                bias-disable;
+            };
+
+            tx-pins {
+                pins = "gpio13";
+                function = "qup_se1_l3_mira";
+                bias-disable;
+            };
+        };
+    };
+...
-- 
2.7.4


