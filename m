Return-Path: <netdev+bounces-1515-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EF5C6FE0FE
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 17:01:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A64D71C20D8D
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 15:01:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A97B916408;
	Wed, 10 May 2023 15:00:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE8316400
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 15:00:46 +0000 (UTC)
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F595868B;
	Wed, 10 May 2023 08:00:40 -0700 (PDT)
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34AD9F1Y029424;
	Wed, 10 May 2023 15:00:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=qcppdkim1;
 bh=nVc+zh2rdQ75Vx3tAWpGjGf/HG/4wYMDsIhnVliqlWs=;
 b=eII9y5WmyX2QkhGvvuwsV+/WBrevsZUbAORGhEKUMYUR9Fpm094/NdHOwyLDAnJjS6JZ
 t71NSIgGiSexBnDNwOtZPYFr5JMTPYb0U6VyMCktaQhyAm7vNxR9BX12VZj5bY4Ndz37
 Mb7hcEqIlqOJ5rLFygjU9C6FpMlCjccqN+hQNop8lgOzGJpxc+EczXqO+L6y17M279Sf
 1oNfK53RyBqqYTKez/jLbGH/tEGPgECjj/R731eMNL2QEIZtF/GlWuJs1MIw2fWUsN1T
 g6kM2mpmvWYnmKWrIgl5/+jB6wynm+aOooDYz+hUpf4+hs2k5Xzfk/gIoDCbVRcsas0r 8A== 
Received: from apblrppmta01.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.18.19])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3qfuna2131-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 May 2023 15:00:31 +0000
Received: from pps.filterd (APBLRPPMTA01.qualcomm.com [127.0.0.1])
	by APBLRPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTP id 34AF0SIV024988;
	Wed, 10 May 2023 15:00:28 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by APBLRPPMTA01.qualcomm.com (PPS) with ESMTP id 3qdy59f6j7-1;
	Wed, 10 May 2023 15:00:28 +0000
Received: from APBLRPPMTA01.qualcomm.com (APBLRPPMTA01.qualcomm.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34AF0SDH024977;
	Wed, 10 May 2023 15:00:28 GMT
Received: from hu-sgudaval-hyd.qualcomm.com (hu-rohiagar-hyd.qualcomm.com [10.213.106.138])
	by APBLRPPMTA01.qualcomm.com (PPS) with ESMTP id 34AF0RZd024969;
	Wed, 10 May 2023 15:00:28 +0000
Received: by hu-sgudaval-hyd.qualcomm.com (Postfix, from userid 3970568)
	id 4F2FF5129; Wed, 10 May 2023 20:30:27 +0530 (+0530)
From: Rohit Agarwal <quic_rohiagar@quicinc.com>
To: agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org,
        linus.walleij@linaro.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, richardcochran@gmail.com,
        manivannan.sadhasivam@linaro.org, andy.shevchenko@gmail.com
Cc: linux-arm-msm@vger.kernel.org, linux-gpio@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Rohit Agarwal <quic_rohiagar@quicinc.com>
Subject: [PATCH v7 4/4] pinctrl: qcom: Add SDX75 pincontrol driver
Date: Wed, 10 May 2023 20:30:25 +0530
Message-Id: <1683730825-15668-5-git-send-email-quic_rohiagar@quicinc.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1683730825-15668-1-git-send-email-quic_rohiagar@quicinc.com>
References: <1683730825-15668-1-git-send-email-quic_rohiagar@quicinc.com>
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: g2hCMzN2gtDZji3686gCQ0qTNNow8kz4
X-Proofpoint-GUID: g2hCMzN2gtDZji3686gCQ0qTNNow8kz4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-10_04,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 lowpriorityscore=0 spamscore=0 impostorscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 clxscore=1015 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305100121
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>

Add initial Qualcomm SDX75 pinctrl driver to support pin configuration
with pinctrl framework for SDX75 SoC.
While at it, reordering the SDX65 entry.

Signed-off-by: Rohit Agarwal <quic_rohiagar@quicinc.com>
---
 drivers/pinctrl/qcom/Kconfig         |   30 +-
 drivers/pinctrl/qcom/Makefile        |    3 +-
 drivers/pinctrl/qcom/pinctrl-sdx75.c | 1595 ++++++++++++++++++++++++++++++++++
 3 files changed, 1617 insertions(+), 11 deletions(-)
 create mode 100644 drivers/pinctrl/qcom/pinctrl-sdx75.c

diff --git a/drivers/pinctrl/qcom/Kconfig b/drivers/pinctrl/qcom/Kconfig
index 62d4810..1f6ba22 100644
--- a/drivers/pinctrl/qcom/Kconfig
+++ b/drivers/pinctrl/qcom/Kconfig
@@ -367,6 +367,26 @@ config PINCTRL_SDX55
 	 Qualcomm Technologies Inc TLMM block found on the Qualcomm
 	 Technologies Inc SDX55 platform.
 
+config PINCTRL_SDX65
+        tristate "Qualcomm Technologies Inc SDX65 pin controller driver"
+        depends on GPIOLIB && OF
+        depends on ARM || COMPILE_TEST
+        depends on PINCTRL_MSM
+        help
+         This is the pinctrl, pinmux, pinconf and gpiolib driver for the
+         Qualcomm Technologies Inc TLMM block found on the Qualcomm
+         Technologies Inc SDX65 platform.
+
+config PINCTRL_SDX75
+        tristate "Qualcomm Technologies Inc SDX75 pin controller driver"
+        depends on GPIOLIB && OF
+        depends on ARM64 || COMPILE_TEST
+        depends on PINCTRL_MSM
+        help
+         This is the pinctrl, pinmux, pinconf and gpiolib driver for the
+         Qualcomm Technologies Inc TLMM block found on the Qualcomm
+         Technologies Inc SDX75 platform.
+
 config PINCTRL_SM6115
 	tristate "Qualcomm Technologies Inc SM6115,SM4250 pin controller driver"
 	depends on GPIOLIB && OF
@@ -407,16 +427,6 @@ config PINCTRL_SM6375
 	 Qualcomm Technologies Inc TLMM block found on the Qualcomm
 	 Technologies Inc SM6375 platform.
 
-config PINCTRL_SDX65
-	tristate "Qualcomm Technologies Inc SDX65 pin controller driver"
-	depends on GPIOLIB && OF
-	depends on ARM || COMPILE_TEST
-	depends on PINCTRL_MSM
-	help
-	 This is the pinctrl, pinmux, pinconf and gpiolib driver for the
-	 Qualcomm Technologies Inc TLMM block found on the Qualcomm
-	 Technologies Inc SDX65 platform.
-
 config PINCTRL_SM8150
 	tristate "Qualcomm Technologies Inc SM8150 pin controller driver"
 	depends on OF
diff --git a/drivers/pinctrl/qcom/Makefile b/drivers/pinctrl/qcom/Makefile
index bea53b5..d956ac47 100644
--- a/drivers/pinctrl/qcom/Makefile
+++ b/drivers/pinctrl/qcom/Makefile
@@ -39,11 +39,12 @@ obj-$(CONFIG_PINCTRL_SDM660)   += pinctrl-sdm660.o
 obj-$(CONFIG_PINCTRL_SDM670) += pinctrl-sdm670.o
 obj-$(CONFIG_PINCTRL_SDM845) += pinctrl-sdm845.o
 obj-$(CONFIG_PINCTRL_SDX55) += pinctrl-sdx55.o
+obj-$(CONFIG_PINCTRL_SDX65) += pinctrl-sdx65.o
+obj-$(CONFIG_PINCTRL_SDX75) += pinctrl-sdx75.o
 obj-$(CONFIG_PINCTRL_SM6115) += pinctrl-sm6115.o
 obj-$(CONFIG_PINCTRL_SM6125) += pinctrl-sm6125.o
 obj-$(CONFIG_PINCTRL_SM6350) += pinctrl-sm6350.o
 obj-$(CONFIG_PINCTRL_SM6375) += pinctrl-sm6375.o
-obj-$(CONFIG_PINCTRL_SDX65) += pinctrl-sdx65.o
 obj-$(CONFIG_PINCTRL_SM8150) += pinctrl-sm8150.o
 obj-$(CONFIG_PINCTRL_SM8250) += pinctrl-sm8250.o
 obj-$(CONFIG_PINCTRL_SM8250_LPASS_LPI) += pinctrl-sm8250-lpass-lpi.o
diff --git a/drivers/pinctrl/qcom/pinctrl-sdx75.c b/drivers/pinctrl/qcom/pinctrl-sdx75.c
new file mode 100644
index 0000000..6f95c0a
--- /dev/null
+++ b/drivers/pinctrl/qcom/pinctrl-sdx75.c
@@ -0,0 +1,1595 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2023 Qualcomm Innovation Center, Inc. All rights reserved.
+ */
+
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/platform_device.h>
+#include "pinctrl-msm.h"
+
+#define REG_BASE 0x100000
+#define REG_SIZE 0x1000
+
+#define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7, f8, f9, f10)		\
+	{								\
+		.grp = PINCTRL_PINGROUP("gpio"#id, gpio##id##_pins,	\
+			(unsigned int)ARRAY_SIZE(gpio##id##_pins)),	\
+		.ctl_reg = REG_BASE + REG_SIZE * id,			\
+		.io_reg = REG_BASE + 0x4 + REG_SIZE * id,		\
+		.intr_cfg_reg = REG_BASE + 0x8 + REG_SIZE * id,		\
+		.intr_status_reg = REG_BASE + 0xc + REG_SIZE * id,	\
+		.intr_target_reg = REG_BASE + 0x8 + REG_SIZE * id,	\
+		.mux_bit = 2,						\
+		.pull_bit = 0,						\
+		.drv_bit = 6,						\
+		.egpio_enable = 12,					\
+		.egpio_present = 11,					\
+		.oe_bit = 9,						\
+		.in_bit = 0,						\
+		.out_bit = 1,						\
+		.intr_enable_bit = 0,					\
+		.intr_status_bit = 0,					\
+		.intr_target_bit = 5,					\
+		.intr_target_kpss_val = 3,				\
+		.intr_raw_status_bit = 4,				\
+		.intr_polarity_bit = 1,					\
+		.intr_detection_bit = 2,				\
+		.intr_detection_width = 2,				\
+		.funcs = (int[]){					\
+			msm_mux_gpio, /* gpio mode */			\
+			msm_mux_##f1,					\
+			msm_mux_##f2,					\
+			msm_mux_##f3,					\
+			msm_mux_##f4,					\
+			msm_mux_##f5,					\
+			msm_mux_##f6,					\
+			msm_mux_##f7,					\
+			msm_mux_##f8,					\
+			msm_mux_##f9,					\
+			msm_mux_##f10					\
+		},							\
+		.nfuncs = 11,						\
+	}
+
+#define SDC_QDSD_PINGROUP(pg_name, ctl, pull, drv)			\
+	{								\
+		.grp = PINCTRL_PINGROUP(#pg_name, pg_name##_pins,	\
+			(unsigned int)ARRAY_SIZE(pg_name##_pins)),	\
+		.ctl_reg = ctl,						\
+		.io_reg = 0,						\
+		.intr_cfg_reg = 0,					\
+		.intr_status_reg = 0,					\
+		.intr_target_reg = 0,					\
+		.mux_bit = -1,						\
+		.pull_bit = pull,					\
+		.drv_bit = drv,						\
+		.oe_bit = -1,						\
+		.in_bit = -1,						\
+		.out_bit = -1,						\
+		.intr_enable_bit = -1,					\
+		.intr_status_bit = -1,					\
+		.intr_target_bit = -1,					\
+		.intr_raw_status_bit = -1,				\
+		.intr_polarity_bit = -1,				\
+		.intr_detection_bit = -1,				\
+		.intr_detection_width = -1,				\
+	}
+
+static const struct pinctrl_pin_desc sdx75_pins[] = {
+	PINCTRL_PIN(0, "GPIO_0"),
+	PINCTRL_PIN(1, "GPIO_1"),
+	PINCTRL_PIN(2, "GPIO_2"),
+	PINCTRL_PIN(3, "GPIO_3"),
+	PINCTRL_PIN(4, "GPIO_4"),
+	PINCTRL_PIN(5, "GPIO_5"),
+	PINCTRL_PIN(6, "GPIO_6"),
+	PINCTRL_PIN(7, "GPIO_7"),
+	PINCTRL_PIN(8, "GPIO_8"),
+	PINCTRL_PIN(9, "GPIO_9"),
+	PINCTRL_PIN(10, "GPIO_10"),
+	PINCTRL_PIN(11, "GPIO_11"),
+	PINCTRL_PIN(12, "GPIO_12"),
+	PINCTRL_PIN(13, "GPIO_13"),
+	PINCTRL_PIN(14, "GPIO_14"),
+	PINCTRL_PIN(15, "GPIO_15"),
+	PINCTRL_PIN(16, "GPIO_16"),
+	PINCTRL_PIN(17, "GPIO_17"),
+	PINCTRL_PIN(18, "GPIO_18"),
+	PINCTRL_PIN(19, "GPIO_19"),
+	PINCTRL_PIN(20, "GPIO_20"),
+	PINCTRL_PIN(21, "GPIO_21"),
+	PINCTRL_PIN(22, "GPIO_22"),
+	PINCTRL_PIN(23, "GPIO_23"),
+	PINCTRL_PIN(24, "GPIO_24"),
+	PINCTRL_PIN(25, "GPIO_25"),
+	PINCTRL_PIN(26, "GPIO_26"),
+	PINCTRL_PIN(27, "GPIO_27"),
+	PINCTRL_PIN(28, "GPIO_28"),
+	PINCTRL_PIN(29, "GPIO_29"),
+	PINCTRL_PIN(30, "GPIO_30"),
+	PINCTRL_PIN(31, "GPIO_31"),
+	PINCTRL_PIN(32, "GPIO_32"),
+	PINCTRL_PIN(33, "GPIO_33"),
+	PINCTRL_PIN(34, "GPIO_34"),
+	PINCTRL_PIN(35, "GPIO_35"),
+	PINCTRL_PIN(36, "GPIO_36"),
+	PINCTRL_PIN(37, "GPIO_37"),
+	PINCTRL_PIN(38, "GPIO_38"),
+	PINCTRL_PIN(39, "GPIO_39"),
+	PINCTRL_PIN(40, "GPIO_40"),
+	PINCTRL_PIN(41, "GPIO_41"),
+	PINCTRL_PIN(42, "GPIO_42"),
+	PINCTRL_PIN(43, "GPIO_43"),
+	PINCTRL_PIN(44, "GPIO_44"),
+	PINCTRL_PIN(45, "GPIO_45"),
+	PINCTRL_PIN(46, "GPIO_46"),
+	PINCTRL_PIN(47, "GPIO_47"),
+	PINCTRL_PIN(48, "GPIO_48"),
+	PINCTRL_PIN(49, "GPIO_49"),
+	PINCTRL_PIN(50, "GPIO_50"),
+	PINCTRL_PIN(51, "GPIO_51"),
+	PINCTRL_PIN(52, "GPIO_52"),
+	PINCTRL_PIN(53, "GPIO_53"),
+	PINCTRL_PIN(54, "GPIO_54"),
+	PINCTRL_PIN(55, "GPIO_55"),
+	PINCTRL_PIN(56, "GPIO_56"),
+	PINCTRL_PIN(57, "GPIO_57"),
+	PINCTRL_PIN(58, "GPIO_58"),
+	PINCTRL_PIN(59, "GPIO_59"),
+	PINCTRL_PIN(60, "GPIO_60"),
+	PINCTRL_PIN(61, "GPIO_61"),
+	PINCTRL_PIN(62, "GPIO_62"),
+	PINCTRL_PIN(63, "GPIO_63"),
+	PINCTRL_PIN(64, "GPIO_64"),
+	PINCTRL_PIN(65, "GPIO_65"),
+	PINCTRL_PIN(66, "GPIO_66"),
+	PINCTRL_PIN(67, "GPIO_67"),
+	PINCTRL_PIN(68, "GPIO_68"),
+	PINCTRL_PIN(69, "GPIO_69"),
+	PINCTRL_PIN(70, "GPIO_70"),
+	PINCTRL_PIN(71, "GPIO_71"),
+	PINCTRL_PIN(72, "GPIO_72"),
+	PINCTRL_PIN(73, "GPIO_73"),
+	PINCTRL_PIN(74, "GPIO_74"),
+	PINCTRL_PIN(75, "GPIO_75"),
+	PINCTRL_PIN(76, "GPIO_76"),
+	PINCTRL_PIN(77, "GPIO_77"),
+	PINCTRL_PIN(78, "GPIO_78"),
+	PINCTRL_PIN(79, "GPIO_79"),
+	PINCTRL_PIN(80, "GPIO_80"),
+	PINCTRL_PIN(81, "GPIO_81"),
+	PINCTRL_PIN(82, "GPIO_82"),
+	PINCTRL_PIN(83, "GPIO_83"),
+	PINCTRL_PIN(84, "GPIO_84"),
+	PINCTRL_PIN(85, "GPIO_85"),
+	PINCTRL_PIN(86, "GPIO_86"),
+	PINCTRL_PIN(87, "GPIO_87"),
+	PINCTRL_PIN(88, "GPIO_88"),
+	PINCTRL_PIN(89, "GPIO_89"),
+	PINCTRL_PIN(90, "GPIO_90"),
+	PINCTRL_PIN(91, "GPIO_91"),
+	PINCTRL_PIN(92, "GPIO_92"),
+	PINCTRL_PIN(93, "GPIO_93"),
+	PINCTRL_PIN(94, "GPIO_94"),
+	PINCTRL_PIN(95, "GPIO_95"),
+	PINCTRL_PIN(96, "GPIO_96"),
+	PINCTRL_PIN(97, "GPIO_97"),
+	PINCTRL_PIN(98, "GPIO_98"),
+	PINCTRL_PIN(99, "GPIO_99"),
+	PINCTRL_PIN(100, "GPIO_100"),
+	PINCTRL_PIN(101, "GPIO_101"),
+	PINCTRL_PIN(102, "GPIO_102"),
+	PINCTRL_PIN(103, "GPIO_103"),
+	PINCTRL_PIN(104, "GPIO_104"),
+	PINCTRL_PIN(105, "GPIO_105"),
+	PINCTRL_PIN(106, "GPIO_106"),
+	PINCTRL_PIN(107, "GPIO_107"),
+	PINCTRL_PIN(108, "GPIO_108"),
+	PINCTRL_PIN(109, "GPIO_109"),
+	PINCTRL_PIN(110, "GPIO_110"),
+	PINCTRL_PIN(111, "GPIO_111"),
+	PINCTRL_PIN(112, "GPIO_112"),
+	PINCTRL_PIN(113, "GPIO_113"),
+	PINCTRL_PIN(114, "GPIO_114"),
+	PINCTRL_PIN(115, "GPIO_115"),
+	PINCTRL_PIN(116, "GPIO_116"),
+	PINCTRL_PIN(117, "GPIO_117"),
+	PINCTRL_PIN(118, "GPIO_118"),
+	PINCTRL_PIN(119, "GPIO_119"),
+	PINCTRL_PIN(120, "GPIO_120"),
+	PINCTRL_PIN(121, "GPIO_121"),
+	PINCTRL_PIN(122, "GPIO_122"),
+	PINCTRL_PIN(123, "GPIO_123"),
+	PINCTRL_PIN(124, "GPIO_124"),
+	PINCTRL_PIN(125, "GPIO_125"),
+	PINCTRL_PIN(126, "GPIO_126"),
+	PINCTRL_PIN(127, "GPIO_127"),
+	PINCTRL_PIN(128, "GPIO_128"),
+	PINCTRL_PIN(129, "GPIO_129"),
+	PINCTRL_PIN(130, "GPIO_130"),
+	PINCTRL_PIN(131, "GPIO_131"),
+	PINCTRL_PIN(132, "GPIO_132"),
+	PINCTRL_PIN(133, "SDC1_RCLK"),
+	PINCTRL_PIN(134, "SDC1_CLK"),
+	PINCTRL_PIN(135, "SDC1_CMD"),
+	PINCTRL_PIN(136, "SDC1_DATA"),
+	PINCTRL_PIN(137, "SDC2_CLK"),
+	PINCTRL_PIN(138, "SDC2_CMD"),
+	PINCTRL_PIN(139, "SDC2_DATA"),
+};
+
+#define DECLARE_MSM_GPIO_PINS(pin)			 \
+	static const unsigned int gpio##pin##_pins[] = {pin}
+DECLARE_MSM_GPIO_PINS(0);
+DECLARE_MSM_GPIO_PINS(1);
+DECLARE_MSM_GPIO_PINS(2);
+DECLARE_MSM_GPIO_PINS(3);
+DECLARE_MSM_GPIO_PINS(4);
+DECLARE_MSM_GPIO_PINS(5);
+DECLARE_MSM_GPIO_PINS(6);
+DECLARE_MSM_GPIO_PINS(7);
+DECLARE_MSM_GPIO_PINS(8);
+DECLARE_MSM_GPIO_PINS(9);
+DECLARE_MSM_GPIO_PINS(10);
+DECLARE_MSM_GPIO_PINS(11);
+DECLARE_MSM_GPIO_PINS(12);
+DECLARE_MSM_GPIO_PINS(13);
+DECLARE_MSM_GPIO_PINS(14);
+DECLARE_MSM_GPIO_PINS(15);
+DECLARE_MSM_GPIO_PINS(16);
+DECLARE_MSM_GPIO_PINS(17);
+DECLARE_MSM_GPIO_PINS(18);
+DECLARE_MSM_GPIO_PINS(19);
+DECLARE_MSM_GPIO_PINS(20);
+DECLARE_MSM_GPIO_PINS(21);
+DECLARE_MSM_GPIO_PINS(22);
+DECLARE_MSM_GPIO_PINS(23);
+DECLARE_MSM_GPIO_PINS(24);
+DECLARE_MSM_GPIO_PINS(25);
+DECLARE_MSM_GPIO_PINS(26);
+DECLARE_MSM_GPIO_PINS(27);
+DECLARE_MSM_GPIO_PINS(28);
+DECLARE_MSM_GPIO_PINS(29);
+DECLARE_MSM_GPIO_PINS(30);
+DECLARE_MSM_GPIO_PINS(31);
+DECLARE_MSM_GPIO_PINS(32);
+DECLARE_MSM_GPIO_PINS(33);
+DECLARE_MSM_GPIO_PINS(34);
+DECLARE_MSM_GPIO_PINS(35);
+DECLARE_MSM_GPIO_PINS(36);
+DECLARE_MSM_GPIO_PINS(37);
+DECLARE_MSM_GPIO_PINS(38);
+DECLARE_MSM_GPIO_PINS(39);
+DECLARE_MSM_GPIO_PINS(40);
+DECLARE_MSM_GPIO_PINS(41);
+DECLARE_MSM_GPIO_PINS(42);
+DECLARE_MSM_GPIO_PINS(43);
+DECLARE_MSM_GPIO_PINS(44);
+DECLARE_MSM_GPIO_PINS(45);
+DECLARE_MSM_GPIO_PINS(46);
+DECLARE_MSM_GPIO_PINS(47);
+DECLARE_MSM_GPIO_PINS(48);
+DECLARE_MSM_GPIO_PINS(49);
+DECLARE_MSM_GPIO_PINS(50);
+DECLARE_MSM_GPIO_PINS(51);
+DECLARE_MSM_GPIO_PINS(52);
+DECLARE_MSM_GPIO_PINS(53);
+DECLARE_MSM_GPIO_PINS(54);
+DECLARE_MSM_GPIO_PINS(55);
+DECLARE_MSM_GPIO_PINS(56);
+DECLARE_MSM_GPIO_PINS(57);
+DECLARE_MSM_GPIO_PINS(58);
+DECLARE_MSM_GPIO_PINS(59);
+DECLARE_MSM_GPIO_PINS(60);
+DECLARE_MSM_GPIO_PINS(61);
+DECLARE_MSM_GPIO_PINS(62);
+DECLARE_MSM_GPIO_PINS(63);
+DECLARE_MSM_GPIO_PINS(64);
+DECLARE_MSM_GPIO_PINS(65);
+DECLARE_MSM_GPIO_PINS(66);
+DECLARE_MSM_GPIO_PINS(67);
+DECLARE_MSM_GPIO_PINS(68);
+DECLARE_MSM_GPIO_PINS(69);
+DECLARE_MSM_GPIO_PINS(70);
+DECLARE_MSM_GPIO_PINS(71);
+DECLARE_MSM_GPIO_PINS(72);
+DECLARE_MSM_GPIO_PINS(73);
+DECLARE_MSM_GPIO_PINS(74);
+DECLARE_MSM_GPIO_PINS(75);
+DECLARE_MSM_GPIO_PINS(76);
+DECLARE_MSM_GPIO_PINS(77);
+DECLARE_MSM_GPIO_PINS(78);
+DECLARE_MSM_GPIO_PINS(79);
+DECLARE_MSM_GPIO_PINS(80);
+DECLARE_MSM_GPIO_PINS(81);
+DECLARE_MSM_GPIO_PINS(82);
+DECLARE_MSM_GPIO_PINS(83);
+DECLARE_MSM_GPIO_PINS(84);
+DECLARE_MSM_GPIO_PINS(85);
+DECLARE_MSM_GPIO_PINS(86);
+DECLARE_MSM_GPIO_PINS(87);
+DECLARE_MSM_GPIO_PINS(88);
+DECLARE_MSM_GPIO_PINS(89);
+DECLARE_MSM_GPIO_PINS(90);
+DECLARE_MSM_GPIO_PINS(91);
+DECLARE_MSM_GPIO_PINS(92);
+DECLARE_MSM_GPIO_PINS(93);
+DECLARE_MSM_GPIO_PINS(94);
+DECLARE_MSM_GPIO_PINS(95);
+DECLARE_MSM_GPIO_PINS(96);
+DECLARE_MSM_GPIO_PINS(97);
+DECLARE_MSM_GPIO_PINS(98);
+DECLARE_MSM_GPIO_PINS(99);
+DECLARE_MSM_GPIO_PINS(100);
+DECLARE_MSM_GPIO_PINS(101);
+DECLARE_MSM_GPIO_PINS(102);
+DECLARE_MSM_GPIO_PINS(103);
+DECLARE_MSM_GPIO_PINS(104);
+DECLARE_MSM_GPIO_PINS(105);
+DECLARE_MSM_GPIO_PINS(106);
+DECLARE_MSM_GPIO_PINS(107);
+DECLARE_MSM_GPIO_PINS(108);
+DECLARE_MSM_GPIO_PINS(109);
+DECLARE_MSM_GPIO_PINS(110);
+DECLARE_MSM_GPIO_PINS(111);
+DECLARE_MSM_GPIO_PINS(112);
+DECLARE_MSM_GPIO_PINS(113);
+DECLARE_MSM_GPIO_PINS(114);
+DECLARE_MSM_GPIO_PINS(115);
+DECLARE_MSM_GPIO_PINS(116);
+DECLARE_MSM_GPIO_PINS(117);
+DECLARE_MSM_GPIO_PINS(118);
+DECLARE_MSM_GPIO_PINS(119);
+DECLARE_MSM_GPIO_PINS(120);
+DECLARE_MSM_GPIO_PINS(121);
+DECLARE_MSM_GPIO_PINS(122);
+DECLARE_MSM_GPIO_PINS(123);
+DECLARE_MSM_GPIO_PINS(124);
+DECLARE_MSM_GPIO_PINS(125);
+DECLARE_MSM_GPIO_PINS(126);
+DECLARE_MSM_GPIO_PINS(127);
+DECLARE_MSM_GPIO_PINS(128);
+DECLARE_MSM_GPIO_PINS(129);
+DECLARE_MSM_GPIO_PINS(130);
+DECLARE_MSM_GPIO_PINS(131);
+DECLARE_MSM_GPIO_PINS(132);
+
+static const unsigned int sdc1_rclk_pins[] = {133};
+static const unsigned int sdc1_clk_pins[] = {134};
+static const unsigned int sdc1_cmd_pins[] = {135};
+static const unsigned int sdc1_data_pins[] = {136};
+static const unsigned int sdc2_clk_pins[] = {137};
+static const unsigned int sdc2_cmd_pins[] = {138};
+static const unsigned int sdc2_data_pins[] = {139};
+
+enum sdx75_functions {
+	msm_mux_gpio,
+	msm_mux_eth0_mdc,
+	msm_mux_eth0_mdio,
+	msm_mux_eth1_mdc,
+	msm_mux_eth1_mdio,
+	msm_mux_qlink0_wmss,
+	msm_mux_qlink1_wmss,
+	msm_mux_rgmii_rxc,
+	msm_mux_rgmii_rxd0,
+	msm_mux_rgmii_rxd1,
+	msm_mux_rgmii_rxd2,
+	msm_mux_rgmii_rxd3,
+	msm_mux_rgmii_rx_ctl,
+	msm_mux_rgmii_txc,
+	msm_mux_rgmii_txd0,
+	msm_mux_rgmii_txd1,
+	msm_mux_rgmii_txd2,
+	msm_mux_rgmii_txd3,
+	msm_mux_rgmii_tx_ctl,
+	msm_mux_sd_card,
+	msm_mux_adsp_ext,
+	msm_mux_atest_char0,
+	msm_mux_atest_char1,
+	msm_mux_atest_char2,
+	msm_mux_atest_char3,
+	msm_mux_atest_char_start,
+	msm_mux_audio_ref_clk,
+	msm_mux_bimc_dte0,
+	msm_mux_bimc_dte1,
+	msm_mux_char_exec_pending,
+	msm_mux_char_exec_release,
+	msm_mux_coex_uart2,
+	msm_mux_coex_uart_rx,
+	msm_mux_coex_uart_tx,
+	msm_mux_cri_trng,
+	msm_mux_cri_trng0,
+	msm_mux_cri_trng1,
+	msm_mux_dbg_out_clk,
+	msm_mux_ddr_bist_complete,
+	msm_mux_ddr_bist_fail,
+	msm_mux_ddr_bist_start,
+	msm_mux_ddr_bist_stop,
+	msm_mux_ddr_pxi0,
+	msm_mux_ebi0_wrcdc,
+	msm_mux_ebi2_a,
+	msm_mux_ebi2_lcd,
+	msm_mux_ebi2_lcd_te,
+	msm_mux_emac0_mcg0,
+	msm_mux_emac0_mcg1,
+	msm_mux_emac0_mcg2,
+	msm_mux_emac0_mcg3,
+	msm_mux_emac0_ptp,
+	msm_mux_emac1_mcg0,
+	msm_mux_emac1_mcg1,
+	msm_mux_emac1_mcg2,
+	msm_mux_emac1_mcg3,
+	msm_mux_emac1_ptp0,
+	msm_mux_emac1_ptp1,
+	msm_mux_emac1_ptp2,
+	msm_mux_emac1_ptp3,
+	msm_mux_emac_cdc0,
+	msm_mux_emac_cdc1,
+	msm_mux_emac_pps_in,
+	msm_mux_ext_dbg,
+	msm_mux_gcc_125_clk,
+	msm_mux_gcc_gp1_clk,
+	msm_mux_gcc_gp2_clk,
+	msm_mux_gcc_gp3_clk,
+	msm_mux_gcc_plltest_bypassnl,
+	msm_mux_gcc_plltest_resetn,
+	msm_mux_i2s_mclk,
+	msm_mux_jitter_bist,
+	msm_mux_ldo_en,
+	msm_mux_ldo_update,
+	msm_mux_m_voc,
+	msm_mux_mgpi_clk,
+	msm_mux_native_char_start,
+	msm_mux_native_char_status0,
+	msm_mux_native_char_status1,
+	msm_mux_native_char_status2,
+	msm_mux_native_char_status3,
+	msm_mux_native_tsens,
+	msm_mux_native_tsense,
+	msm_mux_nav_dr_sync,
+	msm_mux_nav_gpio_0,
+	msm_mux_nav_gpio_1,
+	msm_mux_nav_gpio_2,
+	msm_mux_nav_gpio_3,
+	msm_mux_pa_indicator,
+	msm_mux_pci_e,
+	msm_mux_pcie0_clkreq_n,
+	msm_mux_pcie1_clkreq_n,
+	msm_mux_pcie2_clkreq_n,
+	msm_mux_pll_bist_sync,
+	msm_mux_pll_clk_aux,
+	msm_mux_pll_ref_clk,
+	msm_mux_pri_mi2s_data0,
+	msm_mux_pri_mi2s_data1,
+	msm_mux_pri_mi2s_sck,
+	msm_mux_pri_mi2s_ws,
+	msm_mux_prng_rosc0,
+	msm_mux_prng_rosc1,
+	msm_mux_prng_rosc2,
+	msm_mux_prng_rosc3,
+	msm_mux_qdss_cti,
+	msm_mux_qdss_gpio,
+	msm_mux_qdss_gpio0,
+	msm_mux_qdss_gpio1,
+	msm_mux_qdss_gpio10,
+	msm_mux_qdss_gpio11,
+	msm_mux_qdss_gpio12,
+	msm_mux_qdss_gpio13,
+	msm_mux_qdss_gpio14,
+	msm_mux_qdss_gpio15,
+	msm_mux_qdss_gpio2,
+	msm_mux_qdss_gpio3,
+	msm_mux_qdss_gpio4,
+	msm_mux_qdss_gpio5,
+	msm_mux_qdss_gpio6,
+	msm_mux_qdss_gpio7,
+	msm_mux_qdss_gpio8,
+	msm_mux_qdss_gpio9,
+	msm_mux_qlink0_b_en,
+	msm_mux_qlink0_b_req,
+	msm_mux_qlink0_l_en,
+	msm_mux_qlink0_l_req,
+	msm_mux_qlink1_l_en,
+	msm_mux_qlink1_l_req,
+	msm_mux_qup_se0_l0,
+	msm_mux_qup_se0_l1,
+	msm_mux_qup_se0_l2,
+	msm_mux_qup_se0_l3,
+	msm_mux_qup_se1_l2_mira,
+	msm_mux_qup_se1_l2_mirb,
+	msm_mux_qup_se1_l3_mira,
+	msm_mux_qup_se1_l3_mirb,
+	msm_mux_qup_se2_l0,
+	msm_mux_qup_se2_l1,
+	msm_mux_qup_se2_l2,
+	msm_mux_qup_se2_l3,
+	msm_mux_qup_se3_l0,
+	msm_mux_qup_se3_l1,
+	msm_mux_qup_se3_l2,
+	msm_mux_qup_se3_l3,
+	msm_mux_qup_se4_l2,
+	msm_mux_qup_se4_l3,
+	msm_mux_qup_se5_l0,
+	msm_mux_qup_se5_l1,
+	msm_mux_qup_se6_l0,
+	msm_mux_qup_se6_l1,
+	msm_mux_qup_se6_l2,
+	msm_mux_qup_se6_l3,
+	msm_mux_qup_se7_l0,
+	msm_mux_qup_se7_l1,
+	msm_mux_qup_se7_l2,
+	msm_mux_qup_se7_l3,
+	msm_mux_qup_se8_l2,
+	msm_mux_qup_se8_l3,
+	msm_mux_sdc1_tb,
+	msm_mux_sdc2_tb_trig,
+	msm_mux_sec_mi2s_data0,
+	msm_mux_sec_mi2s_data1,
+	msm_mux_sec_mi2s_sck,
+	msm_mux_sec_mi2s_ws,
+	msm_mux_sgmii_phy_intr0_n,
+	msm_mux_sgmii_phy_intr1_n,
+	msm_mux_spmi_coex_clk,
+	msm_mux_spmi_coex_data,
+	msm_mux_spmi_vgi,
+	msm_mux_tgu_ch0_trigout,
+	msm_mux_tmess_prng0,
+	msm_mux_tmess_prng1,
+	msm_mux_tmess_prng2,
+	msm_mux_tmess_prng3,
+	msm_mux_tri_mi2s_data0,
+	msm_mux_tri_mi2s_data1,
+	msm_mux_tri_mi2s_sck,
+	msm_mux_tri_mi2s_ws,
+	msm_mux_uim1_clk,
+	msm_mux_uim1_data,
+	msm_mux_uim1_present,
+	msm_mux_uim1_reset,
+	msm_mux_uim2_clk,
+	msm_mux_uim2_data,
+	msm_mux_uim2_present,
+	msm_mux_uim2_reset,
+	msm_mux_usb2phy_ac_en,
+	msm_mux_vsense_trigger_mirnat,
+	msm_mux__,
+};
+
+static const char *const gpio_groups[] = {
+	"gpio0", "gpio1", "gpio2", "gpio3", "gpio4", "gpio5", "gpio6",
+	"gpio7", "gpio8", "gpio9", "gpio10", "gpio11", "gpio12", "gpio13",
+	"gpio14", "gpio15", "gpio16", "gpio17", "gpio18", "gpio19", "gpio20",
+	"gpio21", "gpio22", "gpio23", "gpio24", "gpio25", "gpio26", "gpio27",
+	"gpio28", "gpio29", "gpio30", "gpio31", "gpio32", "gpio33", "gpio34",
+	"gpio35", "gpio36", "gpio37", "gpio38", "gpio39", "gpio40", "gpio41",
+	"gpio42", "gpio43", "gpio44", "gpio45", "gpio46", "gpio47", "gpio48",
+	"gpio49", "gpio50", "gpio51", "gpio52", "gpio53", "gpio54", "gpio55",
+	"gpio56", "gpio57", "gpio58", "gpio59", "gpio60", "gpio61", "gpio62",
+	"gpio63", "gpio64", "gpio65", "gpio66", "gpio67", "gpio68", "gpio69",
+	"gpio70", "gpio71", "gpio72", "gpio73", "gpio74", "gpio75", "gpio76",
+	"gpio77", "gpio78", "gpio79", "gpio80", "gpio81", "gpio82", "gpio83",
+	"gpio84", "gpio85", "gpio86", "gpio87", "gpio88", "gpio89", "gpio90",
+	"gpio91", "gpio92", "gpio93", "gpio94", "gpio95", "gpio96", "gpio97",
+	"gpio98", "gpio99", "gpio100", "gpio101", "gpio102", "gpio103", "gpio104",
+	"gpio105", "gpio106", "gpio107", "gpio108", "gpio109", "gpio110", "gpio111",
+	"gpio112", "gpio113", "gpio114", "gpio115", "gpio116", "gpio117", "gpio118",
+	"gpio119", "gpio120", "gpio121", "gpio122", "gpio123", "gpio124", "gpio125",
+	"gpio126", "gpio127", "gpio128", "gpio129", "gpio130", "gpio131", "gpio132",
+};
+static const char *const eth0_mdc_groups[] = {
+	"gpio94",
+};
+static const char *const eth0_mdio_groups[] = {
+	"gpio95",
+};
+static const char *const eth1_mdc_groups[] = {
+	"gpio106",
+};
+static const char *const eth1_mdio_groups[] = {
+	"gpio107",
+};
+static const char *const qlink0_wmss_groups[] = {
+	"gpio39",
+};
+static const char *const qlink1_wmss_groups[] = {
+	"gpio28",
+};
+static const char *const rgmii_rxc_groups[] = {
+	"gpio88",
+};
+static const char *const rgmii_rxd0_groups[] = {
+	"gpio89",
+};
+static const char *const rgmii_rxd1_groups[] = {
+	"gpio90",
+};
+static const char *const rgmii_rxd2_groups[] = {
+	"gpio91",
+};
+static const char *const rgmii_rxd3_groups[] = {
+	"gpio92",
+};
+static const char *const rgmii_rx_ctl_groups[] = {
+	"gpio93",
+};
+static const char *const rgmii_txc_groups[] = {
+	"gpio82",
+};
+static const char *const rgmii_txd0_groups[] = {
+	"gpio83",
+};
+static const char *const rgmii_txd1_groups[] = {
+	"gpio84",
+};
+static const char *const rgmii_txd2_groups[] = {
+	"gpio85",
+};
+static const char *const rgmii_txd3_groups[] = {
+	"gpio86",
+};
+static const char *const rgmii_tx_ctl_groups[] = {
+	"gpio87",
+};
+static const char *const sd_card_groups[] = {
+	"gpio105",
+};
+static const char *const adsp_ext_groups[] = {
+	"gpio59", "gpio68",
+};
+static const char *const atest_char0_groups[] = {
+	"gpio26",
+};
+static const char *const atest_char1_groups[] = {
+	"gpio41",
+};
+static const char *const atest_char2_groups[] = {
+	"gpio25",
+};
+static const char *const atest_char3_groups[] = {
+	"gpio24",
+};
+static const char *const atest_char_start_groups[] = {
+	"gpio63",
+};
+static const char *const audio_ref_clk_groups[] = {
+	"gpio126",
+};
+static const char *const bimc_dte0_groups[] = {
+	"gpio14", "gpio59",
+};
+static const char *const bimc_dte1_groups[] = {
+	"gpio15", "gpio61",
+};
+static const char *const char_exec_pending_groups[] = {
+	"gpio6",
+};
+static const char *const char_exec_release_groups[] = {
+	"gpio7",
+};
+static const char *const coex_uart2_groups[] = {
+	"gpio48", "gpio49", "gpio90", "gpio91",
+};
+static const char *const coex_uart_rx_groups[] = {
+	"gpio47",
+};
+static const char *const coex_uart_tx_groups[] = {
+	"gpio46",
+};
+static const char *const cri_trng_groups[] = {
+	"gpio36",
+};
+static const char *const cri_trng0_groups[] = {
+	"gpio31",
+};
+static const char *const cri_trng1_groups[] = {
+	"gpio32",
+};
+static const char *const dbg_out_clk_groups[] = {
+	"gpio26",
+};
+static const char *const ddr_bist_complete_groups[] = {
+	"gpio46",
+};
+static const char *const ddr_bist_fail_groups[] = {
+	"gpio47",
+};
+static const char *const ddr_bist_start_groups[] = {
+	"gpio48",
+};
+static const char *const ddr_bist_stop_groups[] = {
+	"gpio49",
+};
+static const char *const ddr_pxi0_groups[] = {
+	"gpio45", "gpio46",
+};
+static const char *const ebi0_wrcdc_groups[] = {
+	"gpio0", "gpio2",
+};
+static const char *const ebi2_a_groups[] = {
+	"gpio100",
+};
+static const char *const ebi2_lcd_groups[] = {
+	"gpio99", "gpio101",
+};
+static const char *const ebi2_lcd_te_groups[] = {
+	"gpio98",
+};
+static const char *const emac0_mcg0_groups[] = {
+	"gpio83",
+};
+static const char *const emac0_mcg1_groups[] = {
+	"gpio89",
+};
+static const char *const emac0_mcg2_groups[] = {
+	"gpio84",
+};
+static const char *const emac0_mcg3_groups[] = {
+	"gpio85",
+};
+static const char *const emac0_ptp_groups[] = {
+	"gpio35", "gpio83", "gpio84", "gpio85", "gpio89", "gpio119", "gpio123",
+};
+static const char *const emac1_mcg0_groups[] = {
+	"gpio90",
+};
+static const char *const emac1_mcg1_groups[] = {
+	"gpio93",
+};
+static const char *const emac1_mcg2_groups[] = {
+	"gpio122",
+};
+static const char *const emac1_mcg3_groups[] = {
+	"gpio92",
+};
+static const char *const emac1_ptp0_groups[] = {
+	"gpio112",
+};
+static const char *const emac1_ptp1_groups[] = {
+	"gpio113",
+};
+static const char *const emac1_ptp2_groups[] = {
+	"gpio114",
+};
+static const char *const emac1_ptp3_groups[] = {
+	"gpio115",
+};
+static const char *const emac_cdc0_groups[] = {
+	"gpio39",
+};
+static const char *const emac_cdc1_groups[] = {
+	"gpio38",
+};
+static const char *const emac_pps_in_groups[] = {
+	"gpio127",
+};
+static const char *const ext_dbg_groups[] = {
+	"gpio12", "gpio13", "gpio14", "gpio15",
+};
+static const char *const gcc_125_clk_groups[] = {
+	"gpio25",
+};
+static const char *const gcc_gp1_clk_groups[] = {
+	"gpio39",
+};
+static const char *const gcc_gp2_clk_groups[] = {
+	"gpio40",
+};
+static const char *const gcc_gp3_clk_groups[] = {
+	"gpio41",
+};
+static const char *const gcc_plltest_bypassnl_groups[] = {
+	"gpio81",
+};
+static const char *const gcc_plltest_resetn_groups[] = {
+	"gpio82",
+};
+static const char *const i2s_mclk_groups[] = {
+	"gpio74",
+};
+static const char *const jitter_bist_groups[] = {
+	"gpio41",
+};
+static const char *const ldo_en_groups[] = {
+	"gpio8",
+};
+static const char *const ldo_update_groups[] = {
+	"gpio62",
+};
+static const char *const m_voc_groups[] = {
+	"gpio62", "gpio63", "gpio64", "gpio65", "gpio71",
+};
+static const char *const mgpi_clk_groups[] = {
+	"gpio39", "gpio40",
+};
+static const char *const native_char_start_groups[] = {
+	"gpio57",
+};
+static const char *const native_char_status0_groups[] = {
+	"gpio33",
+};
+static const char *const native_char_status1_groups[] = {
+	"gpio66",
+};
+static const char *const native_char_status2_groups[] = {
+	"gpio29",
+};
+static const char *const native_char_status3_groups[] = {
+	"gpio67",
+};
+static const char *const native_tsens_groups[] = {
+	"gpio38",
+};
+static const char *const native_tsense_groups[] = {
+	"gpio64", "gpio76",
+};
+static const char *const nav_dr_sync_groups[] = {
+	"gpio36",
+};
+static const char *const nav_gpio_0_groups[] = {
+	"gpio36",
+};
+static const char *const nav_gpio_1_groups[] = {
+	"gpio35",
+};
+static const char *const nav_gpio_2_groups[] = {
+	"gpio104",
+};
+static const char *const nav_gpio_3_groups[] = {
+	"gpio36",
+};
+static const char *const pa_indicator_groups[] = {
+	"gpio58",
+};
+static const char *const pci_e_groups[] = {
+	"gpio42",
+};
+static const char *const pcie0_clkreq_n_groups[] = {
+	"gpio43",
+};
+static const char *const pcie1_clkreq_n_groups[] = {
+	"gpio124",
+};
+static const char *const pcie2_clkreq_n_groups[] = {
+	"gpio121",
+};
+static const char *const pll_bist_sync_groups[] = {
+	"gpio38",
+};
+static const char *const pll_clk_aux_groups[] = {
+	"gpio40",
+};
+static const char *const pll_ref_clk_groups[] = {
+	"gpio37",
+};
+static const char *const pri_mi2s_data0_groups[] = {
+	"gpio17",
+};
+static const char *const pri_mi2s_data1_groups[] = {
+	"gpio18",
+};
+static const char *const pri_mi2s_sck_groups[] = {
+	"gpio19",
+};
+static const char *const pri_mi2s_ws_groups[] = {
+	"gpio16",
+};
+static const char *const prng_rosc0_groups[] = {
+	"gpio27",
+};
+static const char *const prng_rosc1_groups[] = {
+	"gpio36",
+};
+static const char *const prng_rosc2_groups[] = {
+	"gpio37",
+};
+static const char *const prng_rosc3_groups[] = {
+	"gpio38",
+};
+static const char *const qdss_cti_groups[] = {
+	"gpio16", "gpio17", "gpio52", "gpio53", "gpio56",
+	"gpio57", "gpio59", "gpio60", "gpio78", "gpio79",
+};
+static const char *const qdss_gpio_groups[] = {
+	"gpio116", "gpio117",
+};
+static const char *const qdss_gpio0_groups[] = {
+	"gpio118",
+};
+static const char *const qdss_gpio1_groups[] = {
+	"gpio119",
+};
+static const char *const qdss_gpio10_groups[] = {
+	"gpio114",
+};
+static const char *const qdss_gpio11_groups[] = {
+	"gpio115",
+};
+static const char *const qdss_gpio12_groups[] = {
+	"gpio83",
+};
+static const char *const qdss_gpio13_groups[] = {
+	"gpio82",
+};
+static const char *const qdss_gpio14_groups[] = {
+	"gpio84",
+};
+static const char *const qdss_gpio15_groups[] = {
+	"gpio85",
+};
+static const char *const qdss_gpio2_groups[] = {
+	"gpio94",
+};
+static const char *const qdss_gpio3_groups[] = {
+	"gpio95",
+};
+static const char *const qdss_gpio4_groups[] = {
+	"gpio96",
+};
+static const char *const qdss_gpio5_groups[] = {
+	"gpio97",
+};
+static const char *const qdss_gpio6_groups[] = {
+	"gpio110",
+};
+static const char *const qdss_gpio7_groups[] = {
+	"gpio111",
+};
+static const char *const qdss_gpio8_groups[] = {
+	"gpio112",
+};
+static const char *const qdss_gpio9_groups[] = {
+	"gpio113",
+};
+static const char *const qlink0_b_en_groups[] = {
+	"gpio40",
+};
+static const char *const qlink0_b_req_groups[] = {
+	"gpio41",
+};
+static const char *const qlink0_l_en_groups[] = {
+	"gpio37",
+};
+static const char *const qlink0_l_req_groups[] = {
+	"gpio38",
+};
+static const char *const qlink1_l_en_groups[] = {
+	"gpio26",
+};
+static const char *const qlink1_l_req_groups[] = {
+	"gpio27",
+};
+static const char *const qup_se0_l0_groups[] = {
+	"gpio8",
+};
+static const char *const qup_se0_l1_groups[] = {
+	"gpio9",
+};
+static const char *const qup_se0_l2_groups[] = {
+	"gpio10",
+};
+static const char *const qup_se0_l3_groups[] = {
+	"gpio11",
+};
+static const char *const qup_se1_l2_mira_groups[] = {
+	"gpio12",
+};
+static const char *const qup_se1_l2_mirb_groups[] = {
+	"gpio16",
+};
+static const char *const qup_se1_l3_mira_groups[] = {
+	"gpio13",
+};
+static const char *const qup_se1_l3_mirb_groups[] = {
+	"gpio17",
+};
+static const char *const qup_se2_l0_groups[] = {
+	"gpio14",
+};
+static const char *const qup_se2_l1_groups[] = {
+	"gpio15",
+};
+static const char *const qup_se2_l2_groups[] = {
+	"gpio16",
+};
+static const char *const qup_se2_l3_groups[] = {
+	"gpio17",
+};
+static const char *const qup_se3_l0_groups[] = {
+	"gpio52",
+};
+static const char *const qup_se3_l1_groups[] = {
+	"gpio53",
+};
+static const char *const qup_se3_l2_groups[] = {
+	"gpio54",
+};
+static const char *const qup_se3_l3_groups[] = {
+	"gpio55",
+};
+static const char *const qup_se4_l2_groups[] = {
+	"gpio64",
+};
+static const char *const qup_se4_l3_groups[] = {
+	"gpio65",
+};
+static const char *const qup_se5_l0_groups[] = {
+	"gpio110",
+};
+static const char *const qup_se5_l1_groups[] = {
+	"gpio111",
+};
+static const char *const qup_se6_l0_groups[] = {
+	"gpio112",
+};
+static const char *const qup_se6_l1_groups[] = {
+	"gpio113",
+};
+static const char *const qup_se6_l2_groups[] = {
+	"gpio114",
+};
+static const char *const qup_se6_l3_groups[] = {
+	"gpio115",
+};
+static const char *const qup_se7_l0_groups[] = {
+	"gpio116",
+};
+static const char *const qup_se7_l1_groups[] = {
+	"gpio117",
+};
+static const char *const qup_se7_l2_groups[] = {
+	"gpio118",
+};
+static const char *const qup_se7_l3_groups[] = {
+	"gpio119",
+};
+static const char *const qup_se8_l2_groups[] = {
+	"gpio124",
+};
+static const char *const qup_se8_l3_groups[] = {
+	"gpio125",
+};
+static const char *const sdc1_tb_groups[] = {
+	"gpio84", "gpio130",
+};
+static const char *const sdc2_tb_trig_groups[] = {
+	"gpio129",
+};
+static const char *const sec_mi2s_data0_groups[] = {
+	"gpio21",
+};
+static const char *const sec_mi2s_data1_groups[] = {
+	"gpio22",
+};
+static const char *const sec_mi2s_sck_groups[] = {
+	"gpio23",
+};
+static const char *const sec_mi2s_ws_groups[] = {
+	"gpio20",
+};
+static const char *const sgmii_phy_intr0_n_groups[] = {
+	"gpio97",
+};
+static const char *const sgmii_phy_intr1_n_groups[] = {
+	"gpio109",
+};
+static const char *const spmi_coex_clk_groups[] = {
+	"gpio49",
+};
+static const char *const spmi_coex_data_groups[] = {
+	"gpio48",
+};
+static const char *const spmi_vgi_groups[] = {
+	"gpio50", "gpio51",
+};
+static const char *const tgu_ch0_trigout_groups[] = {
+	"gpio55",
+};
+static const char *const tmess_prng0_groups[] = {
+	"gpio28",
+};
+static const char *const tmess_prng1_groups[] = {
+	"gpio29",
+};
+static const char *const tmess_prng2_groups[] = {
+	"gpio30",
+};
+static const char *const tmess_prng3_groups[] = {
+	"gpio31",
+};
+static const char *const tri_mi2s_data0_groups[] = {
+	"gpio99",
+};
+static const char *const tri_mi2s_data1_groups[] = {
+	"gpio100",
+};
+static const char *const tri_mi2s_sck_groups[] = {
+	"gpio101",
+};
+static const char *const tri_mi2s_ws_groups[] = {
+	"gpio98",
+};
+static const char *const uim1_clk_groups[] = {
+	"gpio7",
+};
+static const char *const uim1_data_groups[] = {
+	"gpio4",
+};
+static const char *const uim1_present_groups[] = {
+	"gpio5",
+};
+static const char *const uim1_reset_groups[] = {
+	"gpio6",
+};
+static const char *const uim2_clk_groups[] = {
+	"gpio3",
+};
+static const char *const uim2_data_groups[] = {
+	"gpio0",
+};
+static const char *const uim2_present_groups[] = {
+	"gpio1",
+};
+static const char *const uim2_reset_groups[] = {
+	"gpio2",
+};
+static const char *const usb2phy_ac_en_groups[] = {
+	"gpio80",
+};
+static const char *const vsense_trigger_mirnat_groups[] = {
+	"gpio37",
+};
+
+static const struct pinfunction sdx75_functions[] = {
+	MSM_PIN_FUNCTION(gpio),
+	MSM_PIN_FUNCTION(eth0_mdc),
+	MSM_PIN_FUNCTION(eth0_mdio),
+	MSM_PIN_FUNCTION(eth1_mdc),
+	MSM_PIN_FUNCTION(eth1_mdio),
+	MSM_PIN_FUNCTION(qlink0_wmss),
+	MSM_PIN_FUNCTION(qlink1_wmss),
+	MSM_PIN_FUNCTION(rgmii_rxc),
+	MSM_PIN_FUNCTION(rgmii_rxd0),
+	MSM_PIN_FUNCTION(rgmii_rxd1),
+	MSM_PIN_FUNCTION(rgmii_rxd2),
+	MSM_PIN_FUNCTION(rgmii_rxd3),
+	MSM_PIN_FUNCTION(rgmii_rx_ctl),
+	MSM_PIN_FUNCTION(rgmii_txc),
+	MSM_PIN_FUNCTION(rgmii_txd0),
+	MSM_PIN_FUNCTION(rgmii_txd1),
+	MSM_PIN_FUNCTION(rgmii_txd2),
+	MSM_PIN_FUNCTION(rgmii_txd3),
+	MSM_PIN_FUNCTION(rgmii_tx_ctl),
+	MSM_PIN_FUNCTION(sd_card),
+	MSM_PIN_FUNCTION(adsp_ext),
+	MSM_PIN_FUNCTION(atest_char0),
+	MSM_PIN_FUNCTION(atest_char1),
+	MSM_PIN_FUNCTION(atest_char2),
+	MSM_PIN_FUNCTION(atest_char3),
+	MSM_PIN_FUNCTION(atest_char_start),
+	MSM_PIN_FUNCTION(audio_ref_clk),
+	MSM_PIN_FUNCTION(bimc_dte0),
+	MSM_PIN_FUNCTION(bimc_dte1),
+	MSM_PIN_FUNCTION(char_exec_pending),
+	MSM_PIN_FUNCTION(char_exec_release),
+	MSM_PIN_FUNCTION(coex_uart2),
+	MSM_PIN_FUNCTION(coex_uart_rx),
+	MSM_PIN_FUNCTION(coex_uart_tx),
+	MSM_PIN_FUNCTION(cri_trng),
+	MSM_PIN_FUNCTION(cri_trng0),
+	MSM_PIN_FUNCTION(cri_trng1),
+	MSM_PIN_FUNCTION(dbg_out_clk),
+	MSM_PIN_FUNCTION(ddr_bist_complete),
+	MSM_PIN_FUNCTION(ddr_bist_fail),
+	MSM_PIN_FUNCTION(ddr_bist_start),
+	MSM_PIN_FUNCTION(ddr_bist_stop),
+	MSM_PIN_FUNCTION(ddr_pxi0),
+	MSM_PIN_FUNCTION(ebi0_wrcdc),
+	MSM_PIN_FUNCTION(ebi2_a),
+	MSM_PIN_FUNCTION(ebi2_lcd),
+	MSM_PIN_FUNCTION(ebi2_lcd_te),
+	MSM_PIN_FUNCTION(emac0_mcg0),
+	MSM_PIN_FUNCTION(emac0_mcg1),
+	MSM_PIN_FUNCTION(emac0_mcg2),
+	MSM_PIN_FUNCTION(emac0_mcg3),
+	MSM_PIN_FUNCTION(emac0_ptp),
+	MSM_PIN_FUNCTION(emac1_mcg0),
+	MSM_PIN_FUNCTION(emac1_mcg1),
+	MSM_PIN_FUNCTION(emac1_mcg2),
+	MSM_PIN_FUNCTION(emac1_mcg3),
+	MSM_PIN_FUNCTION(emac1_ptp0),
+	MSM_PIN_FUNCTION(emac1_ptp1),
+	MSM_PIN_FUNCTION(emac1_ptp2),
+	MSM_PIN_FUNCTION(emac1_ptp3),
+	MSM_PIN_FUNCTION(emac_cdc0),
+	MSM_PIN_FUNCTION(emac_cdc1),
+	MSM_PIN_FUNCTION(emac_pps_in),
+	MSM_PIN_FUNCTION(ext_dbg),
+	MSM_PIN_FUNCTION(gcc_125_clk),
+	MSM_PIN_FUNCTION(gcc_gp1_clk),
+	MSM_PIN_FUNCTION(gcc_gp2_clk),
+	MSM_PIN_FUNCTION(gcc_gp3_clk),
+	MSM_PIN_FUNCTION(gcc_plltest_bypassnl),
+	MSM_PIN_FUNCTION(gcc_plltest_resetn),
+	MSM_PIN_FUNCTION(i2s_mclk),
+	MSM_PIN_FUNCTION(jitter_bist),
+	MSM_PIN_FUNCTION(ldo_en),
+	MSM_PIN_FUNCTION(ldo_update),
+	MSM_PIN_FUNCTION(m_voc),
+	MSM_PIN_FUNCTION(mgpi_clk),
+	MSM_PIN_FUNCTION(native_char_start),
+	MSM_PIN_FUNCTION(native_char_status0),
+	MSM_PIN_FUNCTION(native_char_status1),
+	MSM_PIN_FUNCTION(native_char_status2),
+	MSM_PIN_FUNCTION(native_char_status3),
+	MSM_PIN_FUNCTION(native_tsens),
+	MSM_PIN_FUNCTION(native_tsense),
+	MSM_PIN_FUNCTION(nav_dr_sync),
+	MSM_PIN_FUNCTION(nav_gpio_0),
+	MSM_PIN_FUNCTION(nav_gpio_1),
+	MSM_PIN_FUNCTION(nav_gpio_2),
+	MSM_PIN_FUNCTION(nav_gpio_3),
+	MSM_PIN_FUNCTION(pa_indicator),
+	MSM_PIN_FUNCTION(pci_e),
+	MSM_PIN_FUNCTION(pcie0_clkreq_n),
+	MSM_PIN_FUNCTION(pcie1_clkreq_n),
+	MSM_PIN_FUNCTION(pcie2_clkreq_n),
+	MSM_PIN_FUNCTION(pll_bist_sync),
+	MSM_PIN_FUNCTION(pll_clk_aux),
+	MSM_PIN_FUNCTION(pll_ref_clk),
+	MSM_PIN_FUNCTION(pri_mi2s_data0),
+	MSM_PIN_FUNCTION(pri_mi2s_data1),
+	MSM_PIN_FUNCTION(pri_mi2s_sck),
+	MSM_PIN_FUNCTION(pri_mi2s_ws),
+	MSM_PIN_FUNCTION(prng_rosc0),
+	MSM_PIN_FUNCTION(prng_rosc1),
+	MSM_PIN_FUNCTION(prng_rosc2),
+	MSM_PIN_FUNCTION(prng_rosc3),
+	MSM_PIN_FUNCTION(qdss_cti),
+	MSM_PIN_FUNCTION(qdss_gpio),
+	MSM_PIN_FUNCTION(qdss_gpio0),
+	MSM_PIN_FUNCTION(qdss_gpio1),
+	MSM_PIN_FUNCTION(qdss_gpio10),
+	MSM_PIN_FUNCTION(qdss_gpio11),
+	MSM_PIN_FUNCTION(qdss_gpio12),
+	MSM_PIN_FUNCTION(qdss_gpio13),
+	MSM_PIN_FUNCTION(qdss_gpio14),
+	MSM_PIN_FUNCTION(qdss_gpio15),
+	MSM_PIN_FUNCTION(qdss_gpio2),
+	MSM_PIN_FUNCTION(qdss_gpio3),
+	MSM_PIN_FUNCTION(qdss_gpio4),
+	MSM_PIN_FUNCTION(qdss_gpio5),
+	MSM_PIN_FUNCTION(qdss_gpio6),
+	MSM_PIN_FUNCTION(qdss_gpio7),
+	MSM_PIN_FUNCTION(qdss_gpio8),
+	MSM_PIN_FUNCTION(qdss_gpio9),
+	MSM_PIN_FUNCTION(qlink0_b_en),
+	MSM_PIN_FUNCTION(qlink0_b_req),
+	MSM_PIN_FUNCTION(qlink0_l_en),
+	MSM_PIN_FUNCTION(qlink0_l_req),
+	MSM_PIN_FUNCTION(qlink1_l_en),
+	MSM_PIN_FUNCTION(qlink1_l_req),
+	MSM_PIN_FUNCTION(qup_se0_l0),
+	MSM_PIN_FUNCTION(qup_se0_l1),
+	MSM_PIN_FUNCTION(qup_se0_l2),
+	MSM_PIN_FUNCTION(qup_se0_l3),
+	MSM_PIN_FUNCTION(qup_se1_l2_mira),
+	MSM_PIN_FUNCTION(qup_se1_l2_mirb),
+	MSM_PIN_FUNCTION(qup_se1_l3_mira),
+	MSM_PIN_FUNCTION(qup_se1_l3_mirb),
+	MSM_PIN_FUNCTION(qup_se2_l0),
+	MSM_PIN_FUNCTION(qup_se2_l1),
+	MSM_PIN_FUNCTION(qup_se2_l2),
+	MSM_PIN_FUNCTION(qup_se2_l3),
+	MSM_PIN_FUNCTION(qup_se3_l0),
+	MSM_PIN_FUNCTION(qup_se3_l1),
+	MSM_PIN_FUNCTION(qup_se3_l2),
+	MSM_PIN_FUNCTION(qup_se3_l3),
+	MSM_PIN_FUNCTION(qup_se4_l2),
+	MSM_PIN_FUNCTION(qup_se4_l3),
+	MSM_PIN_FUNCTION(qup_se5_l0),
+	MSM_PIN_FUNCTION(qup_se5_l1),
+	MSM_PIN_FUNCTION(qup_se6_l0),
+	MSM_PIN_FUNCTION(qup_se6_l1),
+	MSM_PIN_FUNCTION(qup_se6_l2),
+	MSM_PIN_FUNCTION(qup_se6_l3),
+	MSM_PIN_FUNCTION(qup_se7_l0),
+	MSM_PIN_FUNCTION(qup_se7_l1),
+	MSM_PIN_FUNCTION(qup_se7_l2),
+	MSM_PIN_FUNCTION(qup_se7_l3),
+	MSM_PIN_FUNCTION(qup_se8_l2),
+	MSM_PIN_FUNCTION(qup_se8_l3),
+	MSM_PIN_FUNCTION(sdc1_tb),
+	MSM_PIN_FUNCTION(sdc2_tb_trig),
+	MSM_PIN_FUNCTION(sec_mi2s_data0),
+	MSM_PIN_FUNCTION(sec_mi2s_data1),
+	MSM_PIN_FUNCTION(sec_mi2s_sck),
+	MSM_PIN_FUNCTION(sec_mi2s_ws),
+	MSM_PIN_FUNCTION(sgmii_phy_intr0_n),
+	MSM_PIN_FUNCTION(sgmii_phy_intr1_n),
+	MSM_PIN_FUNCTION(spmi_coex_clk),
+	MSM_PIN_FUNCTION(spmi_coex_data),
+	MSM_PIN_FUNCTION(spmi_vgi),
+	MSM_PIN_FUNCTION(tgu_ch0_trigout),
+	MSM_PIN_FUNCTION(tmess_prng0),
+	MSM_PIN_FUNCTION(tmess_prng1),
+	MSM_PIN_FUNCTION(tmess_prng2),
+	MSM_PIN_FUNCTION(tmess_prng3),
+	MSM_PIN_FUNCTION(tri_mi2s_data0),
+	MSM_PIN_FUNCTION(tri_mi2s_data1),
+	MSM_PIN_FUNCTION(tri_mi2s_sck),
+	MSM_PIN_FUNCTION(tri_mi2s_ws),
+	MSM_PIN_FUNCTION(uim1_clk),
+	MSM_PIN_FUNCTION(uim1_data),
+	MSM_PIN_FUNCTION(uim1_present),
+	MSM_PIN_FUNCTION(uim1_reset),
+	MSM_PIN_FUNCTION(uim2_clk),
+	MSM_PIN_FUNCTION(uim2_data),
+	MSM_PIN_FUNCTION(uim2_present),
+	MSM_PIN_FUNCTION(uim2_reset),
+	MSM_PIN_FUNCTION(usb2phy_ac_en),
+	MSM_PIN_FUNCTION(vsense_trigger_mirnat),
+};
+
+/* Every pin is maintained as a single group, and missing or non-existing pin
+ * would be maintained as dummy group to synchronize pin group index with
+ * pin descriptor registered with pinctrl core.
+ * Clients would not be able to request these dummy pin groups.
+ */
+static const struct msm_pingroup sdx75_groups[] = {
+	[0] = PINGROUP(0, uim2_data, ebi0_wrcdc, _, _, _, _, _, _, _, _),
+	[1] = PINGROUP(1, uim2_present, _, _, _, _, _, _, _, _, _),
+	[2] = PINGROUP(2, uim2_reset, ebi0_wrcdc, _, _, _, _, _, _, _, _),
+	[3] = PINGROUP(3, uim2_clk, _, _, _, _, _, _, _, _, _),
+	[4] = PINGROUP(4, uim1_data, _, _, _, _, _, _, _, _, _),
+	[5] = PINGROUP(5, uim1_present, _, _, _, _, _, _, _, _, _),
+	[6] = PINGROUP(6, uim1_reset, char_exec_pending, _, _, _, _, _, _, _, _),
+	[7] = PINGROUP(7, uim1_clk, char_exec_release, _, _, _, _, _, _, _, _),
+	[8] = PINGROUP(8, qup_se0_l0, ldo_en, _, _, _, _, _, _, _, _),
+	[9] = PINGROUP(9, qup_se0_l1, _, _, _, _, _, _, _, _, _),
+	[10] = PINGROUP(10, qup_se0_l2, _, _, _, _, _, _, _, _, _),
+	[11] = PINGROUP(11, qup_se0_l3, _, _, _, _, _, _, _, _, _),
+	[12] = PINGROUP(12, qup_se1_l2_mira, ext_dbg, _, _, _, _, _, _, _, _),
+	[13] = PINGROUP(13, qup_se1_l3_mira, ext_dbg, _, _, _, _, _, _,	_, _),
+	[14] = PINGROUP(14, qup_se2_l0, ext_dbg, bimc_dte0, _, _, _, _, _, _, _),
+	[15] = PINGROUP(15, qup_se2_l1, ext_dbg, bimc_dte1, _, _, _, _, _, _, _),
+	[16] = PINGROUP(16, pri_mi2s_ws, qup_se2_l2, qup_se1_l2_mirb, qdss_cti,
+			qdss_cti, _, _, _, _, _),
+	[17] = PINGROUP(17, pri_mi2s_data0, qup_se2_l3, qup_se1_l3_mirb,
+			qdss_cti, qdss_cti, _, _, _, _, _),
+	[18] = PINGROUP(18, pri_mi2s_data1, _, _, _, _, _, _, _, _, _),
+	[19] = PINGROUP(19, pri_mi2s_sck, _, _, _, _, _, _, _, _, _),
+	[20] = PINGROUP(20, sec_mi2s_ws, _, _, _, _, _, _, _, _, _),
+	[21] = PINGROUP(21, sec_mi2s_data0, _, _, _, _, _, _, _, _, _),
+	[22] = PINGROUP(22, sec_mi2s_data1, _, _, _, _, _, _, _, _, _),
+	[23] = PINGROUP(23, sec_mi2s_sck, _, _, _, _, _, _, _, _, _),
+	[24] = PINGROUP(24, _, atest_char3, _, _, _, _, _, _, _, _),
+	[25] = PINGROUP(25, gcc_125_clk, _, atest_char2, _, _, _, _, _,	_, _),
+	[26] = PINGROUP(26, _, _, qlink1_l_en, dbg_out_clk, atest_char0, _, _,
+			_, _, _),
+	[27] = PINGROUP(27, _, _, qlink1_l_req, prng_rosc0, _, _, _, _,	_, _),
+	[28] = PINGROUP(28, _, qlink1_wmss, tmess_prng0, _, _, _, _, _,	_, _),
+	[29] = PINGROUP(29, _, _, _, native_char_status2, tmess_prng1, _, _, _,
+			_, _),
+	[30] = PINGROUP(30, _, _, _, tmess_prng2, _, _, _, _, _, _),
+	[31] = PINGROUP(31, _, _, cri_trng0, _, tmess_prng3, _, _, _, _, _),
+	[32] = PINGROUP(32, _, _, cri_trng1, _, _, _, _, _, _, _),
+	[33] = PINGROUP(33, _, _, native_char_status0, _, _, _, _, _, _, _),
+	[34] = PINGROUP(34, _, _, _, _, _, _, _, _, _, _),
+	[35] = PINGROUP(35, nav_gpio_1, emac0_ptp, emac0_ptp, _, _, _, _,
+			_, _, _),
+	[36] = PINGROUP(36, nav_gpio_3, nav_dr_sync, nav_gpio_0, cri_trng,
+			prng_rosc1, _, _, _, _, _),
+	[37] = PINGROUP(37, qlink0_l_en, _, pll_ref_clk, prng_rosc2,
+			vsense_trigger_mirnat, _, _, _, _, _),
+	[38] = PINGROUP(38, qlink0_l_req, _, pll_bist_sync, prng_rosc3, _,
+			emac_cdc1, _, native_tsens, _, _),
+	[39] = PINGROUP(39, qlink0_wmss, _, mgpi_clk, gcc_gp1_clk, _,
+			emac_cdc0, _, _, _, _),
+	[40] = PINGROUP(40, qlink0_b_en, _, mgpi_clk, pll_clk_aux, gcc_gp2_clk,
+			_, _, _, _, _),
+	[41] = PINGROUP(41, qlink0_b_req, _, jitter_bist, gcc_gp3_clk, _, _,
+			atest_char1, _, _, _),
+	[42] = PINGROUP(42, pci_e, _, _, _, _, _, _, _, _, _),
+	[43] = PINGROUP(43, pcie0_clkreq_n, _, _, _, _, _, _, _, _, _),
+	[44] = PINGROUP(44, _, _, _, _, _, _, _, _, _, _),
+	[45] = PINGROUP(45, ddr_pxi0, _, _, _, _, _, _, _, _, _),
+	[46] = PINGROUP(46, coex_uart_tx, ddr_bist_complete, ddr_pxi0, _, _,
+			_, _, _, _, _),
+	[47] = PINGROUP(47, coex_uart_rx, ddr_bist_fail, _, _, _, _, _, _, _, _),
+	[48] = PINGROUP(48, coex_uart2, spmi_coex_data, ddr_bist_start, _, _,
+			_, _, _, _, _),
+	[49] = PINGROUP(49, coex_uart2, spmi_coex_clk, ddr_bist_stop, _, _,
+			_, _, _, _, _),
+	[50] = PINGROUP(50, spmi_vgi, _, _, _, _, _, _, _, _, _),
+	[51] = PINGROUP(51, spmi_vgi, _, _, _, _, _, _, _, _, _),
+	[52] = PINGROUP(52, qup_se3_l0, qdss_cti, qdss_cti, _, _, _, _, _,
+			_, _),
+	[53] = PINGROUP(53, qup_se3_l1, qdss_cti, qdss_cti, _, _, _, _, _,
+			_, _),
+	[54] = PINGROUP(54, qup_se3_l2, _, _, _, _, _, _, _, _, _),
+	[55] = PINGROUP(55, qup_se3_l3, tgu_ch0_trigout, _, _, _, _, _, _,
+			_, _),
+	[56] = PINGROUP(56, qdss_cti, qdss_cti, _, _, _, _, _, _, _, _),
+	[57] = PINGROUP(57, qdss_cti, qdss_cti, _, native_char_start, _, _,
+			_, _, _, _),
+	[58] = PINGROUP(58, _, pa_indicator, _, _, _, _, _, _, _, _),
+	[59] = PINGROUP(59, adsp_ext, qdss_cti, _, bimc_dte0, _, _, _, _,
+			_, _),
+	[60] = PINGROUP(60, qdss_cti, _, _, _, _, _, _, _, _, _),
+	[61] = PINGROUP(61, _, bimc_dte1, _, _, _, _, _, _, _, _),
+	[62] = PINGROUP(62, m_voc, ldo_update, _, _, _, _, _, _, _, _),
+	[63] = PINGROUP(63, m_voc, _, atest_char_start, _, _, _, _, _, _, _),
+	[64] = PINGROUP(64, qup_se4_l2, m_voc, _, native_tsense, _, _, _,
+			_, _, _),
+	[65] = PINGROUP(65, qup_se4_l3, m_voc, _, _, _, _, _, _, _, _),
+	[66] = PINGROUP(66, _, native_char_status1, _, _, _, _, _, _, _, _),
+	[67] = PINGROUP(67, _, native_char_status3, _, _, _, _, _, _, _, _),
+	[68] = PINGROUP(68, adsp_ext, _, _, _, _, _, _, _, _, _),
+	[69] = PINGROUP(69, _, _, _, _, _, _, _, _, _, _),
+	[70] = PINGROUP(70, _, _, _, _, _, _, _, _, _, _),
+	[71] = PINGROUP(71, m_voc, _, _, _, _, _, _, _, _, _),
+	[72] = PINGROUP(72, _, _, _, _, _, _, _, _, _, _),
+	[73] = PINGROUP(73, _, _, _, _, _, _, _, _, _, _),
+	[74] = PINGROUP(74, i2s_mclk, _, _, _, _, _, _, _, _, _),
+	[75] = PINGROUP(75, _, _, _, _, _, _, _, _, _, _),
+	[76] = PINGROUP(76, native_tsense, _, _, _, _, _, _, _, _, _),
+	[77] = PINGROUP(77, _, _, _, _, _, _, _, _, _, _),
+	[78] = PINGROUP(78, qdss_cti, qdss_cti, _, _, _, _, _, _, _, _),
+	[79] = PINGROUP(79, qdss_cti, qdss_cti, _, _, _, _, _, _, _, _),
+	[80] = PINGROUP(80, usb2phy_ac_en, _, _, _, _, _, _, _, _, _),
+	[81] = PINGROUP(81, gcc_plltest_bypassnl, _, _, _, _, _, _, _, _, _),
+	[82] = PINGROUP(82, rgmii_txc, gcc_plltest_resetn, qdss_gpio13, _, _,
+			_, _, _, _, _),
+	[83] = PINGROUP(83, rgmii_txd0, emac0_ptp, emac0_ptp, emac0_mcg0,
+			qdss_gpio12, _, _, _, _, _),
+	[84] = PINGROUP(84, rgmii_txd1, emac0_ptp, emac0_mcg2, qdss_gpio14, _,
+			sdc1_tb, _, _, _, _),
+	[85] = PINGROUP(85, rgmii_txd2, emac0_ptp, emac0_mcg3, qdss_gpio15, _,
+			_, _, _, _, _),
+	[86] = PINGROUP(86, rgmii_txd3, _, _, _, _, _, _, _, _, _),
+	[87] = PINGROUP(87, rgmii_tx_ctl, _, _, _, _, _, _, _, _, _),
+	[88] = PINGROUP(88, rgmii_rxc, _, _, _, _, _, _, _, _, _),
+	[89] = PINGROUP(89, rgmii_rxd0, emac0_ptp, emac0_ptp, emac0_mcg1, _,
+			_, _, _, _, _),
+	[90] = PINGROUP(90, rgmii_rxd1, coex_uart2, emac1_mcg0, _, _, _, _,
+			_, _, _),
+	[91] = PINGROUP(91, rgmii_rxd2, coex_uart2, _, _, _, _, _, _, _, _),
+	[92] = PINGROUP(92, rgmii_rxd3, emac1_mcg3, _, _, _, _, _, _, _, _),
+	[93] = PINGROUP(93, rgmii_rx_ctl, emac1_mcg1, _, _, _, _, _, _, _, _),
+	[94] = PINGROUP(94, eth0_mdc, qdss_gpio2, _, _, _, _, _, _, _, _),
+	[95] = PINGROUP(95, eth0_mdio, qdss_gpio3, _, _, _, _, _, _, _, _),
+	[96] = PINGROUP(96, qdss_gpio4, _, _, _, _, _, _, _, _, _),
+	[97] = PINGROUP(97, sgmii_phy_intr0_n, _, qdss_gpio5, _, _, _, _, _, _,
+			_),
+	[98] = PINGROUP(98, tri_mi2s_ws, ebi2_lcd_te, _, _, _, _, _, _,
+			_, _),
+	[99] = PINGROUP(99, tri_mi2s_data0, ebi2_lcd, _, _, _, _, _, _,
+			_, _),
+	[100] = PINGROUP(100, tri_mi2s_data1, ebi2_a, _, _, _, _, _, _,
+			 _, _),
+	[101] = PINGROUP(101, tri_mi2s_sck, ebi2_lcd, _, _, _, _, _, _,
+			 _, _),
+	[102] = PINGROUP(102, _, _, _, _, _, _, _, _, _, _),
+	[103] =	PINGROUP(103, _, _, _, _, _, _, _, _, _, _),
+	[104] = PINGROUP(104, nav_gpio_2, _, _, _, _, _, _, _, _, _),
+	[105] = PINGROUP(105, sd_card, _, _, _, _, _, _, _, _, _),
+	[106] = PINGROUP(106, eth1_mdc, _, _, _, _, _, _, _, _, _),
+	[107] = PINGROUP(107, eth1_mdio, _, _, _, _, _, _, _, _, _),
+	[108] =	PINGROUP(108, _, _, _, _, _, _, _, _, _, _),
+	[109] = PINGROUP(109, sgmii_phy_intr1_n, _, _, _, _, _, _, _, _, _),
+	[110] = PINGROUP(110, qup_se5_l0, qdss_gpio6, _, _, _, _, _, _,
+			 _, _),
+	[111] = PINGROUP(111, qup_se5_l1, qdss_gpio7, _, _, _, _, _, _,
+			 _, _),
+	[112] = PINGROUP(112, qup_se6_l0, emac1_ptp0, emac1_ptp0, qdss_gpio8,
+			 _, _, _, _, _, _),
+	[113] = PINGROUP(113, qup_se6_l1, emac1_ptp1, emac1_ptp1, qdss_gpio9,
+			 _, _, _, _, _, _),
+	[114] = PINGROUP(114, qup_se6_l2, emac1_ptp2, emac1_ptp2, qdss_gpio10,
+			 _, _, _, _, _, _),
+	[115] = PINGROUP(115, qup_se6_l3, emac1_ptp3, emac1_ptp3, qdss_gpio11,
+			 _, _, _, _, _, _),
+	[116] = PINGROUP(116, qup_se7_l0, qdss_gpio, _, _, _, _, _, _, _,
+			 _),
+	[117] = PINGROUP(117, qup_se7_l1, qdss_gpio, _, _, _, _, _, _, _,
+			 _),
+	[118] = PINGROUP(118, qup_se7_l2, qdss_gpio0, _, _, _, _, _, _,
+			 _, _),
+	[119] = PINGROUP(119, qup_se7_l3, emac0_ptp, qdss_gpio1, _, _, _, _,
+			 _, _, _),
+	[120] = PINGROUP(120, _, _, _, _, _, _, _, _, _, _),
+	[121] = PINGROUP(121, pcie2_clkreq_n, _, _, _, _, _, _, _, _, _),
+	[122] = PINGROUP(122, emac1_mcg2, _, _, _, _, _, _, _, _, _),
+	[123] = PINGROUP(123, emac0_ptp, emac0_ptp, emac0_ptp, emac0_ptp, _,
+			 _, _, _, _, _),
+	[124] = PINGROUP(124, pcie1_clkreq_n, qup_se8_l2, _, _, _, _, _,
+			 _, _, _),
+	[125] = PINGROUP(125, qup_se8_l3, _, _, _, _, _, _, _, _, _),
+	[126] = PINGROUP(126, audio_ref_clk, _, _, _, _, _, _, _, _, _),
+	[127] = PINGROUP(127, emac_pps_in, _, _, _, _, _, _, _, _, _),
+	[128] =	PINGROUP(128, _, _, _, _, _, _, _, _, _, _),
+	[129] = PINGROUP(129, sdc2_tb_trig, _, _, _, _, _, _, _, _, _),
+	[130] = PINGROUP(130, sdc1_tb, _, _, _, _, _, _, _, _, _),
+	[131] = PINGROUP(131, _, _, _, _, _, _, _, _, _, _),
+	[132] =	PINGROUP(132, _, _, _, _, _, _, _, _, _, _),
+	[133] = SDC_QDSD_PINGROUP(sdc1_rclk, 0x19A000, 16, 0),
+	[134] = SDC_QDSD_PINGROUP(sdc1_clk, 0x19A000, 14, 6),
+	[135] = SDC_QDSD_PINGROUP(sdc1_cmd, 0x19A000, 11, 3),
+	[136] = SDC_QDSD_PINGROUP(sdc1_data, 0x19A000, 9, 0),
+	[137] = SDC_QDSD_PINGROUP(sdc2_clk, 0x19B000, 14, 6),
+	[138] = SDC_QDSD_PINGROUP(sdc2_cmd, 0x19B000, 11, 3),
+	[139] = SDC_QDSD_PINGROUP(sdc2_data, 0x19B000, 9, 0),
+};
+
+static const struct msm_gpio_wakeirq_map sdx75_pdc_map[] = {
+	{ 1, 57 }, { 2, 91 }, {5, 52 }, { 6, 109 }, { 9, 129 }, { 11, 62 },
+	{ 13, 84 }, { 15, 87 }, { 17, 88 }, { 18, 89 }, { 19, 90 }, { 20, 92 },
+	{ 21, 93 }, { 22, 94 }, { 23, 95 }, { 25, 96 }, { 27, 97 }, { 35, 58 },
+	{ 36, 53 }, { 38, 98 }, { 39, 99 }, { 40, 100 }, { 41, 101 }, { 42, 54 },
+	{ 43, 56 }, { 44, 71 }, { 46, 60 }, { 47, 61 }, { 49, 47 }, { 50, 126 },
+	{ 51, 55 }, { 52, 102 }, { 53, 141 }, { 54, 104 }, { 55, 105 }, { 56, 106 },
+	{ 57, 107 }, { 59, 108 }, { 60, 110 }, { 62, 111 }, { 63, 112 }, { 64, 113 },
+	{ 65, 114 }, { 67, 115 }, { 68, 116 }, { 69, 117 }, { 70, 118 }, { 71, 119 },
+	{ 72, 120 }, { 75, 121 }, { 76, 122 }, { 78, 123 }, { 79, 124 }, { 80, 125 },
+	{ 81, 50 }, { 85, 127 }, { 87, 128 }, { 91, 130 }, { 92, 131 }, { 93, 132 },
+	{ 94, 133 }, { 95, 134 }, { 97, 135 }, { 98, 136 }, { 101, 64 }, { 103, 51 },
+	{ 105, 65 }, { 106, 66 }, { 107, 67 }, { 108, 68 }, { 109, 69 }, { 111, 70 },
+	{ 113, 59 }, { 115, 72 }, { 116, 73 }, { 117, 74 }, { 118, 75 }, { 119, 76 },
+	{ 120, 77 }, { 121, 78 }, { 123, 79 }, { 124, 80 }, { 125, 63 }, { 127, 81 },
+	{ 128, 82 }, { 129, 83 }, { 130, 85 }, { 132, 86 },
+};
+
+static const struct msm_pinctrl_soc_data sdx75_pinctrl = {
+	.pins = sdx75_pins,
+	.npins = ARRAY_SIZE(sdx75_pins),
+	.functions = sdx75_functions,
+	.nfunctions = ARRAY_SIZE(sdx75_functions),
+	.groups = sdx75_groups,
+	.ngroups = ARRAY_SIZE(sdx75_groups),
+	.ngpios = 133,
+	.wakeirq_map = sdx75_pdc_map,
+	.nwakeirq_map = ARRAY_SIZE(sdx75_pdc_map),
+};
+
+static const struct of_device_id sdx75_pinctrl_of_match[] = {
+	{ .compatible = "qcom,sdx75-tlmm", .data = &sdx75_pinctrl },
+	{ }
+};
+
+static int sdx75_pinctrl_probe(struct platform_device *pdev)
+{
+	const struct msm_pinctrl_soc_data *pinctrl_data;
+	struct device *dev = &pdev->dev;
+
+	pinctrl_data = of_device_get_match_data(dev);
+	if (!pinctrl_data)
+		return -EINVAL;
+
+	return msm_pinctrl_probe(pdev, pinctrl_data);
+}
+
+static struct platform_driver sdx75_pinctrl_driver = {
+	.driver = {
+		.name = "sdx75-tlmm",
+		.of_match_table = sdx75_pinctrl_of_match,
+	},
+	.probe = sdx75_pinctrl_probe,
+	.remove = msm_pinctrl_remove,
+};
+
+static int __init sdx75_pinctrl_init(void)
+{
+	return platform_driver_register(&sdx75_pinctrl_driver);
+}
+arch_initcall(sdx75_pinctrl_init);
+
+static void __exit sdx75_pinctrl_exit(void)
+{
+	platform_driver_unregister(&sdx75_pinctrl_driver);
+}
+module_exit(sdx75_pinctrl_exit);
+
+MODULE_DESCRIPTION("QTI sdx75 pinctrl driver");
+MODULE_LICENSE("GPL");
+MODULE_DEVICE_TABLE(of, sdx75_pinctrl_of_match);
-- 
2.7.4


