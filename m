Return-Path: <netdev+bounces-2523-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C140D702534
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 08:46:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A87AD1C20A53
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 06:46:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73B6B6FC1;
	Mon, 15 May 2023 06:46:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 581F679EB
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 06:46:35 +0000 (UTC)
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC739D3;
	Sun, 14 May 2023 23:46:29 -0700 (PDT)
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34F6bmMM018953;
	Mon, 15 May 2023 06:46:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=qcppdkim1;
 bh=4MgtNytnxs57TacSYA5to9e9RxJzAEcN49uRSJyG2VQ=;
 b=mGm7W9rinfe+hF7kUZW0VKQdwZQVi89qXOkVzFZGcYI6ePa9Z0I+Gqg9WV5ofAbgxEuF
 rZ5g41J+cAAitcXd0QOZQe/ER1zPq2dCz0diBLE5p0PDCEFCOznZrIIQ/6wbc4wbI3Fr
 Z1rrYHnoV01Q1IJsQtA5BB2ZFhpsiGE34zDjyqwWhvNQhdx9zX2LNtg1/ztsCtKNjFAa
 4EFFaAlkLHo8lEW8cFcVlIw7OjENEY42ew6SgUEPYzQl0Czw7C8qv6FNLxWR1XqGLDwG
 zCI9YKuntgyXHKorjdunivZeMvDBwkd1L1RvzVwyjgQ5V3Hwh40jKDqS84M97P0P+8DW pQ== 
Received: from apblrppmta01.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.18.19])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3qj2sb2xqy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 May 2023 06:46:17 +0000
Received: from pps.filterd (APBLRPPMTA01.qualcomm.com [127.0.0.1])
	by APBLRPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTP id 34F6kDdk012971;
	Mon, 15 May 2023 06:46:13 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by APBLRPPMTA01.qualcomm.com (PPS) with ESMTP id 3qj3mkc3bu-1;
	Mon, 15 May 2023 06:46:13 +0000
Received: from APBLRPPMTA01.qualcomm.com (APBLRPPMTA01.qualcomm.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34F6kDRh012962;
	Mon, 15 May 2023 06:46:13 GMT
Received: from hu-sgudaval-hyd.qualcomm.com (hu-rohiagar-hyd.qualcomm.com [10.213.106.138])
	by APBLRPPMTA01.qualcomm.com (PPS) with ESMTP id 34F6kDwK012955;
	Mon, 15 May 2023 06:46:13 +0000
Received: by hu-sgudaval-hyd.qualcomm.com (Postfix, from userid 3970568)
	id 876C45E98; Mon, 15 May 2023 12:16:12 +0530 (+0530)
From: Rohit Agarwal <quic_rohiagar@quicinc.com>
To: agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org,
        linus.walleij@linaro.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, richardcochran@gmail.com,
        manivannan.sadhasivam@linaro.org, andy.shevchenko@gmail.com
Cc: linux-arm-msm@vger.kernel.org, linux-gpio@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Rohit Agarwal <quic_rohiagar@quicinc.com>
Subject: [PATCH v2 2/2] pinctrl: qcom: Refactor generic qcom pinctrl driver
Date: Mon, 15 May 2023 12:16:10 +0530
Message-Id: <1684133170-18540-3-git-send-email-quic_rohiagar@quicinc.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1684133170-18540-1-git-send-email-quic_rohiagar@quicinc.com>
References: <1684133170-18540-1-git-send-email-quic_rohiagar@quicinc.com>
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: HlmweyYTCyuvvgQYP74_mTq7WW3EXFiY
X-Proofpoint-ORIG-GUID: HlmweyYTCyuvvgQYP74_mTq7WW3EXFiY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-15_04,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=998
 priorityscore=1501 lowpriorityscore=0 adultscore=0 malwarescore=0
 spamscore=0 bulkscore=0 impostorscore=0 clxscore=1015 mlxscore=0
 phishscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2304280000 definitions=main-2305150060
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>

Reuse the generic pingroup struct from pinctrl.h in msm_pingroup
along with the macro defined.

Signed-off-by: Rohit Agarwal <quic_rohiagar@quicinc.com>
Suggested-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
---
 drivers/pinctrl/qcom/pinctrl-apq8064.c  | 12 ++++++------
 drivers/pinctrl/qcom/pinctrl-apq8084.c  | 12 ++++++------
 drivers/pinctrl/qcom/pinctrl-ipq4019.c  |  6 +++---
 drivers/pinctrl/qcom/pinctrl-ipq5332.c  |  6 +++---
 drivers/pinctrl/qcom/pinctrl-ipq6018.c  |  6 +++---
 drivers/pinctrl/qcom/pinctrl-ipq8064.c  | 12 ++++++------
 drivers/pinctrl/qcom/pinctrl-ipq8074.c  |  6 +++---
 drivers/pinctrl/qcom/pinctrl-ipq9574.c  |  6 +++---
 drivers/pinctrl/qcom/pinctrl-mdm9607.c  | 12 ++++++------
 drivers/pinctrl/qcom/pinctrl-mdm9615.c  |  6 +++---
 drivers/pinctrl/qcom/pinctrl-msm.c      | 10 +++++-----
 drivers/pinctrl/qcom/pinctrl-msm.h      |  8 ++------
 drivers/pinctrl/qcom/pinctrl-msm8226.c  | 12 ++++++------
 drivers/pinctrl/qcom/pinctrl-msm8660.c  | 12 ++++++------
 drivers/pinctrl/qcom/pinctrl-msm8909.c  | 12 ++++++------
 drivers/pinctrl/qcom/pinctrl-msm8916.c  | 12 ++++++------
 drivers/pinctrl/qcom/pinctrl-msm8953.c  | 12 ++++++------
 drivers/pinctrl/qcom/pinctrl-msm8960.c  | 12 ++++++------
 drivers/pinctrl/qcom/pinctrl-msm8976.c  | 12 ++++++------
 drivers/pinctrl/qcom/pinctrl-msm8994.c  | 12 ++++++------
 drivers/pinctrl/qcom/pinctrl-msm8996.c  | 12 ++++++------
 drivers/pinctrl/qcom/pinctrl-msm8998.c  | 18 +++++++++---------
 drivers/pinctrl/qcom/pinctrl-msm8x74.c  | 18 +++++++++---------
 drivers/pinctrl/qcom/pinctrl-qcm2290.c  | 18 +++++++++---------
 drivers/pinctrl/qcom/pinctrl-qcs404.c   | 12 ++++++------
 drivers/pinctrl/qcom/pinctrl-qdf2xxx.c  |  6 +++---
 drivers/pinctrl/qcom/pinctrl-qdu1000.c  | 18 +++++++++---------
 drivers/pinctrl/qcom/pinctrl-sa8775p.c  | 18 +++++++++---------
 drivers/pinctrl/qcom/pinctrl-sc7180.c   | 18 +++++++++---------
 drivers/pinctrl/qcom/pinctrl-sc7280.c   | 18 +++++++++---------
 drivers/pinctrl/qcom/pinctrl-sc8180x.c  | 18 +++++++++---------
 drivers/pinctrl/qcom/pinctrl-sc8280xp.c | 18 +++++++++---------
 drivers/pinctrl/qcom/pinctrl-sdm660.c   | 12 ++++++------
 drivers/pinctrl/qcom/pinctrl-sdm670.c   | 24 ++++++++++++------------
 drivers/pinctrl/qcom/pinctrl-sdm845.c   | 18 +++++++++---------
 drivers/pinctrl/qcom/pinctrl-sdx55.c    | 12 ++++++------
 drivers/pinctrl/qcom/pinctrl-sdx65.c    | 18 +++++++++---------
 drivers/pinctrl/qcom/pinctrl-sm6115.c   | 18 +++++++++---------
 drivers/pinctrl/qcom/pinctrl-sm6125.c   | 18 +++++++++---------
 drivers/pinctrl/qcom/pinctrl-sm6350.c   | 18 +++++++++---------
 drivers/pinctrl/qcom/pinctrl-sm6375.c   | 18 +++++++++---------
 drivers/pinctrl/qcom/pinctrl-sm7150.c   | 18 +++++++++---------
 drivers/pinctrl/qcom/pinctrl-sm8150.c   | 18 +++++++++---------
 drivers/pinctrl/qcom/pinctrl-sm8250.c   | 18 +++++++++---------
 drivers/pinctrl/qcom/pinctrl-sm8350.c   | 18 +++++++++---------
 drivers/pinctrl/qcom/pinctrl-sm8450.c   | 18 +++++++++---------
 drivers/pinctrl/qcom/pinctrl-sm8550.c   | 18 +++++++++---------
 47 files changed, 325 insertions(+), 329 deletions(-)

diff --git a/drivers/pinctrl/qcom/pinctrl-apq8064.c b/drivers/pinctrl/qcom/pinctrl-apq8064.c
index 57b9a4a..20c3b90 100644
--- a/drivers/pinctrl/qcom/pinctrl-apq8064.c
+++ b/drivers/pinctrl/qcom/pinctrl-apq8064.c
@@ -210,9 +210,9 @@ static const unsigned int sdc3_data_pins[] = { 95 };
 
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7, f8, f9, f10) \
 	{						\
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio" #id, 	\
+			gpio##id##_pins, 		\
+			ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			APQ_MUX_gpio,			\
 			APQ_MUX_##f1,			\
@@ -251,9 +251,9 @@ static const unsigned int sdc3_data_pins[] = { 95 };
 
 #define SDC_PINGROUP(pg_name, ctl, pull, drv)		\
 	{						\
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, 	\
+			pg_name##_pins, 		\
+			ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-apq8084.c b/drivers/pinctrl/qcom/pinctrl-apq8084.c
index 7a9b6e9..3fc0a407 100644
--- a/drivers/pinctrl/qcom/pinctrl-apq8084.c
+++ b/drivers/pinctrl/qcom/pinctrl-apq8084.c
@@ -325,9 +325,9 @@ static const unsigned int sdc2_data_pins[] = { 152 };
 
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7)        \
 	{						\
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio" #id, 	\
+			gpio##id##_pins, 		\
+			ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			APQ_MUX_gpio,			\
 			APQ_MUX_##f1,			\
@@ -363,9 +363,9 @@ static const unsigned int sdc2_data_pins[] = { 152 };
 
 #define SDC_PINGROUP(pg_name, ctl, pull, drv)		\
 	{						\
-		.name = #pg_name,	                \
-		.pins = pg_name##_pins,                 \
-		.npins = ARRAY_SIZE(pg_name##_pins),    \
+		.grp = PINCTRL_PINGROUP(#pg_name, 	\
+			pg_name##_pins, 		\
+			ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,                         \
 		.io_reg = 0,                            \
 		.intr_cfg_reg = 0,                      \
diff --git a/drivers/pinctrl/qcom/pinctrl-ipq4019.c b/drivers/pinctrl/qcom/pinctrl-ipq4019.c
index 3ab859b..1f7944d 100644
--- a/drivers/pinctrl/qcom/pinctrl-ipq4019.c
+++ b/drivers/pinctrl/qcom/pinctrl-ipq4019.c
@@ -217,9 +217,9 @@ DECLARE_QCA_GPIO_PINS(99);
 
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, f11, f12, f13, f14) \
 	{					        \
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = (unsigned)ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio" #id, 	\
+			gpio##id##_pins, 		\
+			ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			qca_mux_gpio, /* gpio mode */	\
 			qca_mux_##f1,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-ipq5332.c b/drivers/pinctrl/qcom/pinctrl-ipq5332.c
index bc90c68..625f801 100644
--- a/drivers/pinctrl/qcom/pinctrl-ipq5332.c
+++ b/drivers/pinctrl/qcom/pinctrl-ipq5332.c
@@ -12,9 +12,9 @@
 #define REG_SIZE 0x1000
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7, f8, f9)	\
 	{					        \
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = (unsigned int)ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio" #id, 	\
+			gpio##id##_pins, 		\
+			ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio, /* gpio mode */	\
 			msm_mux_##f1,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-ipq6018.c b/drivers/pinctrl/qcom/pinctrl-ipq6018.c
index 1e1255c..0ad0864 100644
--- a/drivers/pinctrl/qcom/pinctrl-ipq6018.c
+++ b/drivers/pinctrl/qcom/pinctrl-ipq6018.c
@@ -12,9 +12,9 @@
 #define REG_SIZE 0x1000
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7, f8, f9)	\
 	{					        \
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = (unsigned int)ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio" #id, 	\
+			gpio##id##_pins, 		\
+			ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio, /* gpio mode */	\
 			msm_mux_##f1,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-ipq8064.c b/drivers/pinctrl/qcom/pinctrl-ipq8064.c
index 54cca32..e2bb94e 100644
--- a/drivers/pinctrl/qcom/pinctrl-ipq8064.c
+++ b/drivers/pinctrl/qcom/pinctrl-ipq8064.c
@@ -162,9 +162,9 @@ static const unsigned int sdc3_data_pins[] = { 71 };
 
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7, f8, f9, f10) \
 	{						\
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio" #id, 	\
+			gpio##id##_pins, 		\
+			ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			IPQ_MUX_gpio,			\
 			IPQ_MUX_##f1,			\
@@ -203,9 +203,9 @@ static const unsigned int sdc3_data_pins[] = { 71 };
 
 #define SDC_PINGROUP(pg_name, ctl, pull, drv)		\
 	{						\
-		.name = #pg_name,	                \
-		.pins = pg_name##_pins,                 \
-		.npins = ARRAY_SIZE(pg_name##_pins),    \
+		.grp = PINCTRL_PINGROUP(#pg_name, 	\
+			pg_name##_pins, 		\
+			ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,                         \
 		.io_reg = 0,                            \
 		.intr_cfg_reg = 0,                      \
diff --git a/drivers/pinctrl/qcom/pinctrl-ipq8074.c b/drivers/pinctrl/qcom/pinctrl-ipq8074.c
index 0d325aa..337f3a1 100644
--- a/drivers/pinctrl/qcom/pinctrl-ipq8074.c
+++ b/drivers/pinctrl/qcom/pinctrl-ipq8074.c
@@ -12,9 +12,9 @@
 #define REG_SIZE 0x1000
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7, f8, f9)	\
 	{					        \
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = (unsigned int)ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio" #id, 	\
+			gpio##id##_pins, 		\
+			ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio, /* gpio mode */	\
 			msm_mux_##f1,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-ipq9574.c b/drivers/pinctrl/qcom/pinctrl-ipq9574.c
index 59a8b52..e249161 100644
--- a/drivers/pinctrl/qcom/pinctrl-ipq9574.c
+++ b/drivers/pinctrl/qcom/pinctrl-ipq9574.c
@@ -12,9 +12,9 @@
 #define REG_SIZE 0x1000
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7, f8, f9)	\
 	{					        \
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = (unsigned int)ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio" #id, 	\
+			gpio##id##_pins, 		\
+			ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio, /* gpio mode */	\
 			msm_mux_##f1,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-mdm9607.c b/drivers/pinctrl/qcom/pinctrl-mdm9607.c
index 331d4c1..e7cd3ef 100644
--- a/drivers/pinctrl/qcom/pinctrl-mdm9607.c
+++ b/drivers/pinctrl/qcom/pinctrl-mdm9607.c
@@ -205,9 +205,9 @@ static const unsigned int qdsd_data3_pins[] = { 91 };
 
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7, f8, f9)	\
 	{							\
-		.name = "gpio" #id,				\
-		.pins = gpio##id##_pins,			\
-		.npins = ARRAY_SIZE(gpio##id##_pins),		\
+		.grp = PINCTRL_PINGROUP("gpio" #id, 	\
+			gpio##id##_pins, 		\
+			ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){				\
 			msm_mux_gpio,				\
 			msm_mux_##f1,				\
@@ -244,9 +244,9 @@ static const unsigned int qdsd_data3_pins[] = { 91 };
 
 #define SDC_PINGROUP(pg_name, ctl, pull, drv)	\
 	{					        \
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, 	\
+			pg_name##_pins, 		\
+			ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-mdm9615.c b/drivers/pinctrl/qcom/pinctrl-mdm9615.c
index 7278f45..0a2ae38 100644
--- a/drivers/pinctrl/qcom/pinctrl-mdm9615.c
+++ b/drivers/pinctrl/qcom/pinctrl-mdm9615.c
@@ -196,9 +196,9 @@ DECLARE_MSM_GPIO_PINS(87);
 
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, f11) \
 	{						\
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio" #id, 	\
+			gpio##id##_pins, 		\
+			ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio,			\
 			msm_mux_##f1,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-msm.c b/drivers/pinctrl/qcom/pinctrl-msm.c
index 94b984a..2585ef2 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm.c
@@ -120,7 +120,7 @@ static const char *msm_get_group_name(struct pinctrl_dev *pctldev,
 {
 	struct msm_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctldev);
 
-	return pctrl->soc->groups[group].name;
+	return pctrl->soc->groups[group].grp.name;
 }
 
 static int msm_get_group_pins(struct pinctrl_dev *pctldev,
@@ -130,8 +130,8 @@ static int msm_get_group_pins(struct pinctrl_dev *pctldev,
 {
 	struct msm_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctldev);
 
-	*pins = pctrl->soc->groups[group].pins;
-	*num_pins = pctrl->soc->groups[group].npins;
+	*pins = pctrl->soc->groups[group].grp.pins;
+	*num_pins = pctrl->soc->groups[group].grp.npins;
 	return 0;
 }
 
@@ -705,11 +705,11 @@ static void msm_gpio_dbg_show_one(struct seq_file *s,
 		val = !!(io_reg & BIT(g->in_bit));
 
 	if (egpio_enable) {
-		seq_printf(s, " %-8s: egpio\n", g->name);
+		seq_printf(s, " %-8s: egpio\n", g->grp.name);
 		return;
 	}
 
-	seq_printf(s, " %-8s: %-3s", g->name, is_out ? "out" : "in");
+	seq_printf(s, " %-8s: %-3s", g->grp.name, is_out ? "out" : "in");
 	seq_printf(s, " %-4s func%d", val ? "high" : "low", func);
 	seq_printf(s, " %dmA", msm_regval_to_drive(drive));
 	if (pctrl->soc->pull_no_keeper)
diff --git a/drivers/pinctrl/qcom/pinctrl-msm.h b/drivers/pinctrl/qcom/pinctrl-msm.h
index b9363e2..5e4410b 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm.h
+++ b/drivers/pinctrl/qcom/pinctrl-msm.h
@@ -36,9 +36,7 @@ struct pinctrl_pin_desc;
 
 /**
  * struct msm_pingroup - Qualcomm pingroup definition
- * @name:                 Name of the pingroup.
- * @pins:	          A list of pins assigned to this pingroup.
- * @npins:	          Number of entries in @pins.
+ * @grp:                  Generic data of the pin group (name and pins)
  * @funcs:                A list of pinmux functions that can be selected for
  *                        this group. The index of the selected function is used
  *                        for programming the function selector.
@@ -71,9 +69,7 @@ struct pinctrl_pin_desc;
  *                        otherwise 1.
  */
 struct msm_pingroup {
-	const char *name;
-	const unsigned *pins;
-	unsigned npins;
+	struct pingroup grp;
 
 	unsigned *funcs;
 	unsigned nfuncs;
diff --git a/drivers/pinctrl/qcom/pinctrl-msm8226.c b/drivers/pinctrl/qcom/pinctrl-msm8226.c
index cb8044b..9946198 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm8226.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm8226.c
@@ -264,9 +264,9 @@ static const unsigned int sdc2_data_pins[] = { 122 };
 
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7)	\
 	{						\
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio" #id, 	\
+			gpio##id##_pins, 		\
+			ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio,			\
 			msm_mux_##f1,			\
@@ -301,9 +301,9 @@ static const unsigned int sdc2_data_pins[] = { 122 };
 
 #define SDC_PINGROUP(pg_name, ctl, pull, drv)		\
 	{						\
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, 	\
+			pg_name##_pins, 		\
+			ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-msm8660.c b/drivers/pinctrl/qcom/pinctrl-msm8660.c
index 114c5b4..999a5f8 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm8660.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm8660.c
@@ -376,9 +376,9 @@ static const unsigned int sdc3_data_pins[] = { 178 };
 
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7) \
 	{						\
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio" #id, 	\
+			gpio##id##_pins, 		\
+			ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio,			\
 			msm_mux_##f1,			\
@@ -414,9 +414,9 @@ static const unsigned int sdc3_data_pins[] = { 178 };
 
 #define SDC_PINGROUP(pg_name, ctl, pull, drv)		\
 	{						\
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, 	\
+			pg_name##_pins, 		\
+			ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-msm8909.c b/drivers/pinctrl/qcom/pinctrl-msm8909.c
index fdf262f..756856d 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm8909.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm8909.c
@@ -13,9 +13,9 @@
 #define REG_SIZE 0x1000
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7, f8, f9)	\
 	{						\
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio" #id, 	\
+			gpio##id##_pins, 		\
+			ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio,			\
 			msm_mux_##f1,			\
@@ -52,9 +52,9 @@
 
 #define SDC_QDSD_PINGROUP(pg_name, ctl, pull, drv)	\
 	{						\
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, 	\
+			pg_name##_pins, 		\
+			ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-msm8916.c b/drivers/pinctrl/qcom/pinctrl-msm8916.c
index d3776a5..cea5c54 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm8916.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm8916.c
@@ -287,9 +287,9 @@ static const unsigned int qdsd_data3_pins[] = { 133 };
 
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7, f8, f9)	\
 	{							\
-		.name = "gpio" #id,				\
-		.pins = gpio##id##_pins,			\
-		.npins = ARRAY_SIZE(gpio##id##_pins),		\
+		.grp = PINCTRL_PINGROUP("gpio" #id, 	\
+			gpio##id##_pins, 		\
+			ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){				\
 			msm_mux_gpio,				\
 			msm_mux_##f1,				\
@@ -326,9 +326,9 @@ static const unsigned int qdsd_data3_pins[] = { 133 };
 
 #define SDC_PINGROUP(pg_name, ctl, pull, drv)	\
 	{					        \
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, 	\
+			pg_name##_pins, 		\
+			ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-msm8953.c b/drivers/pinctrl/qcom/pinctrl-msm8953.c
index 8969bb52..998351b 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm8953.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm8953.c
@@ -9,9 +9,9 @@
 
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7, f8, f9)	\
 	{							\
-		.name = "gpio" #id,				\
-		.pins = gpio##id##_pins,			\
-		.npins = ARRAY_SIZE(gpio##id##_pins),		\
+		.grp = PINCTRL_PINGROUP("gpio" #id, 	\
+			gpio##id##_pins, 		\
+			ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){				\
 			msm_mux_gpio, /* gpio mode */		\
 			msm_mux_##f1,				\
@@ -48,9 +48,9 @@
 
 #define SDC_QDSD_PINGROUP(pg_name, ctl, pull, drv)	\
 	{					        \
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, 	\
+			pg_name##_pins, 		\
+			ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-msm8960.c b/drivers/pinctrl/qcom/pinctrl-msm8960.c
index 615614e..ebe230b 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm8960.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm8960.c
@@ -335,9 +335,9 @@ static const unsigned int sdc3_data_pins[] = { 157 };
 
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, f11) \
 	{						\
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio" #id, 	\
+			gpio##id##_pins, 		\
+			ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio,			\
 			msm_mux_##f1,			\
@@ -377,9 +377,9 @@ static const unsigned int sdc3_data_pins[] = { 157 };
 
 #define SDC_PINGROUP(pg_name, ctl, pull, drv)		\
 	{						\
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, 	\
+			pg_name##_pins, 		\
+			ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-msm8976.c b/drivers/pinctrl/qcom/pinctrl-msm8976.c
index b2cad1d..c30d80e 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm8976.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm8976.c
@@ -15,9 +15,9 @@
 #define REG_SIZE 0x1000
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7, f8, f9)	\
 	{					        \
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio" #id, 	\
+			gpio##id##_pins, 		\
+			ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio, /* gpio mode */	\
 			msm_mux_##f1,			\
@@ -54,9 +54,9 @@
 
 #define SDC_QDSD_PINGROUP(pg_name, ctl, pull, drv)	\
 	{					        \
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, 	\
+			pg_name##_pins, 		\
+			ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-msm8994.c b/drivers/pinctrl/qcom/pinctrl-msm8994.c
index 73b2901..b1a6759 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm8994.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm8994.c
@@ -11,9 +11,9 @@
 
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, f11)	\
 	{						\
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio" #id, 	\
+			gpio##id##_pins, 		\
+			ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio,			\
 			msm_mux_##f1,			\
@@ -52,9 +52,9 @@
 
 #define SDC_PINGROUP(pg_name, ctl, pull, drv)		\
 	{						\
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, 	\
+			pg_name##_pins, 		\
+			ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-msm8996.c b/drivers/pinctrl/qcom/pinctrl-msm8996.c
index 9437305..46cc0b49 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm8996.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm8996.c
@@ -13,9 +13,9 @@
 #define REG_SIZE 0x1000
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7, f8, f9)	\
 	{					        \
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = (unsigned)ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio" #id, 	\
+			gpio##id##_pins, 		\
+			ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio, /* gpio mode */	\
 			msm_mux_##f1,			\
@@ -52,9 +52,9 @@
 
 #define SDC_QDSD_PINGROUP(pg_name, ctl, pull, drv)	\
 	{					        \
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, 	\
+			pg_name##_pins, 		\
+			ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-msm8998.c b/drivers/pinctrl/qcom/pinctrl-msm8998.c
index 4c1a551..b7cbf32 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm8998.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm8998.c
@@ -15,9 +15,9 @@
 
 #define PINGROUP(id, base, f1, f2, f3, f4, f5, f6, f7, f8, f9)	\
 	{					        \
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio" #id, 	\
+			gpio##id##_pins, 		\
+			ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio, /* gpio mode */	\
 			msm_mux_##f1,			\
@@ -54,9 +54,9 @@
 
 #define SDC_QDSD_PINGROUP(pg_name, ctl, pull, drv)	\
 	{					        \
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, 	\
+			pg_name##_pins, 		\
+			ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
@@ -79,9 +79,9 @@
 
 #define UFS_RESET(pg_name, offset)				\
 	{					        \
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, 	\
+			pg_name##_pins, 		\
+			ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = offset,			\
 		.io_reg = offset + 0x4,			\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-msm8x74.c b/drivers/pinctrl/qcom/pinctrl-msm8x74.c
index 5da17f2..d5fe629 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm8x74.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm8x74.c
@@ -326,9 +326,9 @@ static const unsigned int hsic_data_pins[] = { 153 };
 
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7)	\
 	{						\
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio" #id, 	\
+			gpio##id##_pins, 		\
+			ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio,			\
 			msm_mux_##f1,			\
@@ -363,9 +363,9 @@ static const unsigned int hsic_data_pins[] = { 153 };
 
 #define SDC_PINGROUP(pg_name, ctl, pull, drv)		\
 	{						\
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, 	\
+			pg_name##_pins, 		\
+			ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
@@ -389,9 +389,9 @@ static const unsigned int hsic_data_pins[] = { 153 };
 
 #define HSIC_PINGROUP(pg_name, ctl)			\
 	{						\
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, 	\
+			pg_name##_pins, 		\
+			ARRAY_SIZE(pg_name##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio,			\
 			msm_mux_hsic_ctl,		\
diff --git a/drivers/pinctrl/qcom/pinctrl-qcm2290.c b/drivers/pinctrl/qcom/pinctrl-qcm2290.c
index e252e6c..ba699ea 100644
--- a/drivers/pinctrl/qcom/pinctrl-qcm2290.c
+++ b/drivers/pinctrl/qcom/pinctrl-qcm2290.c
@@ -13,9 +13,9 @@
 
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7, f8, f9)	\
 	{						\
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = (unsigned int)ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio" #id, 	\
+			gpio##id##_pins, 		\
+			ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio, /* gpio mode */	\
 			msm_mux_##f1,			\
@@ -52,9 +52,9 @@
 
 #define SDC_QDSD_PINGROUP(pg_name, ctl, pull, drv)	\
 	{					        \
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, 	\
+			pg_name##_pins, 		\
+			ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
@@ -77,9 +77,9 @@
 
 #define UFS_RESET(pg_name, offset)				\
 	{					        \
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, 	\
+			pg_name##_pins, 		\
+			ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = offset,			\
 		.io_reg = offset + 0x4,			\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-qcs404.c b/drivers/pinctrl/qcom/pinctrl-qcs404.c
index 3820808..ae72240 100644
--- a/drivers/pinctrl/qcom/pinctrl-qcs404.c
+++ b/drivers/pinctrl/qcom/pinctrl-qcs404.c
@@ -23,9 +23,9 @@ enum {
 
 #define PINGROUP(id, _tile, f1, f2, f3, f4, f5, f6, f7, f8, f9)	\
 	{						\
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = (unsigned int)ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio" #id, 	\
+			gpio##id##_pins, 		\
+			ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio, /* gpio mode */	\
 			msm_mux_##f1,			\
@@ -63,9 +63,9 @@ enum {
 
 #define SDC_QDSD_PINGROUP(pg_name, ctl, pull, drv)	\
 	{						\
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, 	\
+			pg_name##_pins, 		\
+			ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-qdf2xxx.c b/drivers/pinctrl/qcom/pinctrl-qdf2xxx.c
index 43bd15f..b0f1b3d 100644
--- a/drivers/pinctrl/qcom/pinctrl-qdf2xxx.c
+++ b/drivers/pinctrl/qcom/pinctrl-qdf2xxx.c
@@ -90,17 +90,17 @@ static int qdf2xxx_pinctrl_probe(struct platform_device *pdev)
 	 */
 	for (i = 0; i < num_gpios; i++) {
 		pins[i].number = i;
-		groups[i].pins = &pins[i].number;
+		groups[i].grp.pins = &pins[i].number;
 	}
 
 	/* Populate the entries that are meant to be exposed as GPIOs. */
 	for (i = 0; i < avail_gpios; i++) {
 		unsigned int gpio = gpios[i];
 
-		groups[gpio].npins = 1;
+		groups[gpio].grp.npins = 1;
 		snprintf(names[i], NAME_SIZE, "gpio%u", gpio);
 		pins[gpio].name = names[i];
-		groups[gpio].name = names[i];
+		groups[gpio].grp.name = names[i];
 
 		groups[gpio].ctl_reg = 0x10000 * gpio;
 		groups[gpio].io_reg = 0x04 + 0x10000 * gpio;
diff --git a/drivers/pinctrl/qcom/pinctrl-qdu1000.c b/drivers/pinctrl/qcom/pinctrl-qdu1000.c
index d4670fe..47bc529 100644
--- a/drivers/pinctrl/qcom/pinctrl-qdu1000.c
+++ b/drivers/pinctrl/qcom/pinctrl-qdu1000.c
@@ -15,9 +15,9 @@
 
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7, f8, f9)	\
 	{					        \
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = (unsigned int)ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio" #id, 	\
+			gpio##id##_pins, 		\
+			ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio, /* gpio mode */	\
 			msm_mux_##f1,			\
@@ -54,9 +54,9 @@
 
 #define SDC_QDSD_PINGROUP(pg_name, ctl, pull, drv)	\
 	{					        \
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, 	\
+			pg_name##_pins, 		\
+			ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = REG_BASE + ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
@@ -79,9 +79,9 @@
 
 #define UFS_RESET(pg_name, offset)				\
 	{					        \
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, 	\
+			pg_name##_pins, 		\
+			ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = offset,			\
 		.io_reg = offset + 0x4,			\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-sa8775p.c b/drivers/pinctrl/qcom/pinctrl-sa8775p.c
index b0bf65c..81dd213 100644
--- a/drivers/pinctrl/qcom/pinctrl-sa8775p.c
+++ b/drivers/pinctrl/qcom/pinctrl-sa8775p.c
@@ -14,9 +14,9 @@
 #define REG_SIZE 0x1000
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7, f8, f9)\
 	{					        \
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = (unsigned int)ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio" #id, 	\
+			gpio##id##_pins, 		\
+			ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio, /* gpio mode */	\
 			msm_mux_##f1,			\
@@ -55,9 +55,9 @@
 
 #define SDC_QDSD_PINGROUP(pg_name, ctl, pull, drv)	\
 	{					        \
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, 	\
+			pg_name##_pins, 		\
+			ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
@@ -80,9 +80,9 @@
 
 #define UFS_RESET(pg_name, offset)				\
 	{					        \
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, 	\
+			pg_name##_pins, 		\
+			ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = offset,			\
 		.io_reg = offset + 0x4,			\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-sc7180.c b/drivers/pinctrl/qcom/pinctrl-sc7180.c
index 1bdd5ea..6eb0c73 100644
--- a/drivers/pinctrl/qcom/pinctrl-sc7180.c
+++ b/drivers/pinctrl/qcom/pinctrl-sc7180.c
@@ -21,9 +21,9 @@ enum {
 
 #define PINGROUP(id, _tile, f1, f2, f3, f4, f5, f6, f7, f8, f9)	\
 	{						\
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio" #id, 	\
+			gpio##id##_pins, 		\
+			ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio, /* gpio mode */	\
 			msm_mux_##f1,			\
@@ -61,9 +61,9 @@ enum {
 
 #define SDC_QDSD_PINGROUP(pg_name, ctl, pull, drv)	\
 	{						\
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, 	\
+			pg_name##_pins, 		\
+			ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
@@ -87,9 +87,9 @@ enum {
 
 #define UFS_RESET(pg_name, offset)				\
 	{						\
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, 	\
+			pg_name##_pins, 		\
+			ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = offset,			\
 		.io_reg = offset + 0x4,			\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-sc7280.c b/drivers/pinctrl/qcom/pinctrl-sc7280.c
index bb98afa..0c10eeb 100644
--- a/drivers/pinctrl/qcom/pinctrl-sc7280.c
+++ b/drivers/pinctrl/qcom/pinctrl-sc7280.c
@@ -11,9 +11,9 @@
 
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7, f8, f9)	\
 	{					        \
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = (unsigned int)ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio" #id, 	\
+			gpio##id##_pins, 		\
+			ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio, /* gpio mode */	\
 			msm_mux_##f1,			\
@@ -52,9 +52,9 @@
 
 #define SDC_QDSD_PINGROUP(pg_name, ctl, pull, drv)	\
 	{					        \
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, 	\
+			pg_name##_pins, 		\
+			ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
@@ -77,9 +77,9 @@
 
 #define UFS_RESET(pg_name, offset)				\
 	{					        \
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, 	\
+			pg_name##_pins, 		\
+			ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = offset,			\
 		.io_reg = offset + 0x4,			\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-sc8180x.c b/drivers/pinctrl/qcom/pinctrl-sc8180x.c
index 9b2876b0..f86b176 100644
--- a/drivers/pinctrl/qcom/pinctrl-sc8180x.c
+++ b/drivers/pinctrl/qcom/pinctrl-sc8180x.c
@@ -40,9 +40,9 @@ static const struct tile_info sc8180x_tile_info[] = {
 #define REG_SIZE 0x1000
 #define PINGROUP_OFFSET(id, _tile, offset, f1, f2, f3, f4, f5, f6, f7, f8, f9)	\
 	{						\
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = (unsigned int)ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio" #id, 	\
+			gpio##id##_pins, 		\
+			ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio, /* gpio mode */	\
 			msm_mux_##f1,			\
@@ -83,9 +83,9 @@ static const struct tile_info sc8180x_tile_info[] = {
 
 #define SDC_QDSD_PINGROUP(pg_name, ctl, pull, drv)	\
 	{						\
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, 	\
+			pg_name##_pins, 		\
+			ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
@@ -109,9 +109,9 @@ static const struct tile_info sc8180x_tile_info[] = {
 
 #define UFS_RESET(pg_name)				\
 	{						\
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, 	\
+			pg_name##_pins, 		\
+			ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = 0xb6000,			\
 		.io_reg = 0xb6004,			\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-sc8280xp.c b/drivers/pinctrl/qcom/pinctrl-sc8280xp.c
index 1ad1b2c..96f4fb5 100644
--- a/drivers/pinctrl/qcom/pinctrl-sc8280xp.c
+++ b/drivers/pinctrl/qcom/pinctrl-sc8280xp.c
@@ -13,9 +13,9 @@
 #define REG_SIZE 0x1000
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7)	\
 	{						\
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = (unsigned int)ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio" #id, 	\
+			gpio##id##_pins, 		\
+			ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio, /* gpio mode */	\
 			msm_mux_##f1,			\
@@ -52,9 +52,9 @@
 
 #define SDC_QDSD_PINGROUP(pg_name, ctl, pull, drv)	\
 	{						\
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, 	\
+			pg_name##_pins, 		\
+			ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
@@ -77,9 +77,9 @@
 
 #define UFS_RESET(pg_name, offset)				\
 	{						\
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, 	\
+			pg_name##_pins, 		\
+			ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = offset,			\
 		.io_reg = offset + 0x4,			\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-sdm660.c b/drivers/pinctrl/qcom/pinctrl-sdm660.c
index 863c8b1..c2e0d5c 100644
--- a/drivers/pinctrl/qcom/pinctrl-sdm660.c
+++ b/drivers/pinctrl/qcom/pinctrl-sdm660.c
@@ -26,9 +26,9 @@ enum {
 
 #define PINGROUP(id, _tile, f1, f2, f3, f4, f5, f6, f7, f8, f9)	\
 	{					        \
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = (unsigned)ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio" #id, 	\
+			gpio##id##_pins, 		\
+			ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio, /* gpio mode */	\
 			msm_mux_##f1,			\
@@ -66,9 +66,9 @@ enum {
 
 #define SDC_QDSD_PINGROUP(pg_name, ctl, pull, drv)	\
 	{					        \
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, 	\
+			pg_name##_pins, 		\
+			ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-sdm670.c b/drivers/pinctrl/qcom/pinctrl-sdm670.c
index e630460..cc3cce0 100644
--- a/drivers/pinctrl/qcom/pinctrl-sdm670.c
+++ b/drivers/pinctrl/qcom/pinctrl-sdm670.c
@@ -17,9 +17,9 @@
 #define REG_SIZE 0x1000
 #define PINGROUP(id, base, f1, f2, f3, f4, f5, f6, f7, f8, f9)	\
 	{						\
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio" #id, 	\
+			gpio##id##_pins, 		\
+			ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio, /* gpio mode */	\
 			msm_mux_##f1,			\
@@ -60,9 +60,9 @@
  */
 #define PINGROUP_DUMMY(id)				\
 	{						\
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio" #id, 	\
+			gpio##id##_pins, 		\
+			ARRAY_SIZE(gpio##id##_pins)),	\
 		.ctl_reg = 0,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
@@ -85,9 +85,9 @@
 
 #define SDC_QDSD_PINGROUP(pg_name, ctl, pull, drv)	\
 	{						\
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, 	\
+			pg_name##_pins, 		\
+			ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
@@ -110,9 +110,9 @@
 
 #define UFS_RESET(pg_name, offset)				\
 	{						\
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, 	\
+			pg_name##_pins, 		\
+			ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = offset,			\
 		.io_reg = offset + 0x4,			\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-sdm845.c b/drivers/pinctrl/qcom/pinctrl-sdm845.c
index f8cd74d..cc05c41 100644
--- a/drivers/pinctrl/qcom/pinctrl-sdm845.c
+++ b/drivers/pinctrl/qcom/pinctrl-sdm845.c
@@ -16,9 +16,9 @@
 #define REG_SIZE 0x1000
 #define PINGROUP(id, base, f1, f2, f3, f4, f5, f6, f7, f8, f9, f10)	\
 	{						\
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio" #id, 	\
+			gpio##id##_pins, 		\
+			ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio, /* gpio mode */	\
 			msm_mux_##f1,			\
@@ -56,9 +56,9 @@
 
 #define SDC_QDSD_PINGROUP(pg_name, ctl, pull, drv)	\
 	{						\
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, 	\
+			pg_name##_pins, 		\
+			ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
@@ -81,9 +81,9 @@
 
 #define UFS_RESET(pg_name, offset)				\
 	{						\
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, 	\
+			pg_name##_pins, 		\
+			ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = offset,			\
 		.io_reg = offset + 0x4,			\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-sdx55.c b/drivers/pinctrl/qcom/pinctrl-sdx55.c
index 64957e1..8826db9 100644
--- a/drivers/pinctrl/qcom/pinctrl-sdx55.c
+++ b/drivers/pinctrl/qcom/pinctrl-sdx55.c
@@ -13,9 +13,9 @@
 
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7, f8, f9)	\
 	{					        \
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = (unsigned int)ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio" #id, 	\
+			gpio##id##_pins, 		\
+			ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio, /* gpio mode */	\
 			msm_mux_##f1,			\
@@ -52,9 +52,9 @@
 
 #define SDC_PINGROUP(pg_name, ctl, pull, drv)	\
 	{					        \
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, 	\
+			pg_name##_pins, 		\
+			ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-sdx65.c b/drivers/pinctrl/qcom/pinctrl-sdx65.c
index d94de5b..f6f319c 100644
--- a/drivers/pinctrl/qcom/pinctrl-sdx65.c
+++ b/drivers/pinctrl/qcom/pinctrl-sdx65.c
@@ -13,9 +13,9 @@
 #define REG_SIZE 0x1000
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7, f8, f9)	\
 	{					        \
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = (unsigned int)ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio" #id, 	\
+			gpio##id##_pins, 		\
+			ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio, /* gpio mode */	\
 			msm_mux_##f1,			\
@@ -52,9 +52,9 @@
 
 #define SDC_QDSD_PINGROUP(pg_name, ctl, pull, drv)	\
 	{					        \
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, 	\
+			pg_name##_pins, 		\
+			ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
@@ -77,9 +77,9 @@
 
 #define UFS_RESET(pg_name, offset)				\
 	{					        \
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, 	\
+			pg_name##_pins, 		\
+			ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = offset,			\
 		.io_reg = offset + 0x4,			\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-sm6115.c b/drivers/pinctrl/qcom/pinctrl-sm6115.c
index 73408eb..2a06025 100644
--- a/drivers/pinctrl/qcom/pinctrl-sm6115.c
+++ b/drivers/pinctrl/qcom/pinctrl-sm6115.c
@@ -23,9 +23,9 @@ enum {
 
 #define PINGROUP(id, _tile, f1, f2, f3, f4, f5, f6, f7, f8, f9)	\
 	{						\
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = (unsigned int)ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio" #id, 	\
+			gpio##id##_pins, 		\
+			ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio, /* gpio mode */	\
 			msm_mux_##f1,			\
@@ -63,9 +63,9 @@ enum {
 
 #define SDC_QDSD_PINGROUP(pg_name, _tile, ctl, pull, drv)	\
 	{						\
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, 	\
+			pg_name##_pins, 		\
+			ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
@@ -89,9 +89,9 @@ enum {
 
 #define UFS_RESET(pg_name, offset)			\
 	{						\
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, 	\
+			pg_name##_pins, 		\
+			ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = offset,			\
 		.io_reg = offset + 0x4,			\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-sm6125.c b/drivers/pinctrl/qcom/pinctrl-sm6125.c
index f94d6da..d5e2b89 100644
--- a/drivers/pinctrl/qcom/pinctrl-sm6125.c
+++ b/drivers/pinctrl/qcom/pinctrl-sm6125.c
@@ -20,9 +20,9 @@ enum {
 
 #define PINGROUP(id, _tile, f1, f2, f3, f4, f5, f6, f7, f8, f9)	\
 	{						\
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = (unsigned int)ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio" #id, 	\
+			gpio##id##_pins, 		\
+			ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio, /* gpio mode */	\
 			msm_mux_##f1,			\
@@ -60,9 +60,9 @@ enum {
 
 #define SDC_QDSD_PINGROUP(pg_name, _tile, ctl, pull, drv)	\
 	{						\
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, 	\
+			pg_name##_pins, 		\
+			ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
@@ -86,9 +86,9 @@ enum {
 
 #define UFS_RESET(pg_name, offset)				\
 	{						\
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, 	\
+			pg_name##_pins, 		\
+			ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = offset,			\
 		.io_reg = offset + 0x4,			\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-sm6350.c b/drivers/pinctrl/qcom/pinctrl-sm6350.c
index 0193917..f3828c0 100644
--- a/drivers/pinctrl/qcom/pinctrl-sm6350.c
+++ b/drivers/pinctrl/qcom/pinctrl-sm6350.c
@@ -13,9 +13,9 @@
 #define REG_SIZE 0x1000
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7, f8, f9)	\
 	{					        \
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = (unsigned int)ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio" #id, 	\
+			gpio##id##_pins, 		\
+			ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio, /* gpio mode */	\
 			msm_mux_##f1,			\
@@ -52,9 +52,9 @@
 
 #define SDC_PINGROUP(pg_name, ctl, pull, drv)	\
 	{					        \
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, 	\
+			pg_name##_pins, 		\
+			ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
@@ -77,9 +77,9 @@
 
 #define UFS_RESET(pg_name, offset)				\
 	{					        \
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, 	\
+			pg_name##_pins, 		\
+			ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = offset,			\
 		.io_reg = offset + 0x4,			\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-sm6375.c b/drivers/pinctrl/qcom/pinctrl-sm6375.c
index 778f56e..c82c851 100644
--- a/drivers/pinctrl/qcom/pinctrl-sm6375.c
+++ b/drivers/pinctrl/qcom/pinctrl-sm6375.c
@@ -14,9 +14,9 @@
 #define REG_SIZE 0x1000
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7, f8, f9)	\
 	{					        \
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = (unsigned int)ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio" #id, 	\
+			gpio##id##_pins, 		\
+			ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio, /* gpio mode */	\
 			msm_mux_##f1,			\
@@ -55,9 +55,9 @@
 
 #define SDC_PINGROUP(pg_name, ctl, pull, drv)	\
 	{					        \
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, 	\
+			pg_name##_pins, 		\
+			ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
@@ -80,9 +80,9 @@
 
 #define UFS_RESET(pg_name, offset)				\
 	{					        \
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, 	\
+			pg_name##_pins, 		\
+			ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = offset,			\
 		.io_reg = offset + 0x4,			\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-sm7150.c b/drivers/pinctrl/qcom/pinctrl-sm7150.c
index 544c146..33657cf 100644
--- a/drivers/pinctrl/qcom/pinctrl-sm7150.c
+++ b/drivers/pinctrl/qcom/pinctrl-sm7150.c
@@ -27,9 +27,9 @@ enum {
 
 #define PINGROUP(id, _tile, f1, f2, f3, f4, f5, f6, f7, f8, f9) \
 	{						\
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio" #id, 	\
+			gpio##id##_pins, 		\
+			ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio, /* gpio mode */	\
 			msm_mux_##f1,			\
@@ -67,9 +67,9 @@ enum {
 
 #define SDC_QDSD_PINGROUP(pg_name, ctl, pull, drv)	\
 	{						\
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, 	\
+			pg_name##_pins, 		\
+			ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
@@ -93,9 +93,9 @@ enum {
 
 #define UFS_RESET(pg_name, offset)			\
 	{						\
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, 	\
+			pg_name##_pins, 		\
+			ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = offset,			\
 		.io_reg = offset + 0x4,			\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-sm8150.c b/drivers/pinctrl/qcom/pinctrl-sm8150.c
index c7df131..01aea9c 100644
--- a/drivers/pinctrl/qcom/pinctrl-sm8150.c
+++ b/drivers/pinctrl/qcom/pinctrl-sm8150.c
@@ -23,9 +23,9 @@ enum {
 
 #define PINGROUP(id, _tile, f1, f2, f3, f4, f5, f6, f7, f8, f9)	\
 	{						\
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = (unsigned int)ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio" #id, 	\
+			gpio##id##_pins, 		\
+			ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio, /* gpio mode */	\
 			msm_mux_##f1,			\
@@ -63,9 +63,9 @@ enum {
 
 #define SDC_QDSD_PINGROUP(pg_name, ctl, pull, drv)	\
 	{						\
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, 	\
+			pg_name##_pins, 		\
+			ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
@@ -89,9 +89,9 @@ enum {
 
 #define UFS_RESET(pg_name, offset)				\
 	{						\
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, 	\
+			pg_name##_pins, 		\
+			ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = offset,			\
 		.io_reg = offset + 0x4,			\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-sm8250.c b/drivers/pinctrl/qcom/pinctrl-sm8250.c
index 2d18588..e9961a4 100644
--- a/drivers/pinctrl/qcom/pinctrl-sm8250.c
+++ b/drivers/pinctrl/qcom/pinctrl-sm8250.c
@@ -24,9 +24,9 @@ enum {
 #define REG_SIZE 0x1000
 #define PINGROUP(id, _tile, f1, f2, f3, f4, f5, f6, f7, f8, f9) \
 	{						\
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = (unsigned int)ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio" #id, 	\
+			gpio##id##_pins, 		\
+			ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio, /* gpio mode */	\
 			msm_mux_##f1,			\
@@ -64,9 +64,9 @@ enum {
 
 #define SDC_PINGROUP(pg_name, ctl, pull, drv)	\
 	{						\
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, 	\
+			pg_name##_pins, 		\
+			ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
@@ -90,9 +90,9 @@ enum {
 
 #define UFS_RESET(pg_name, offset)				\
 	{						\
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, 	\
+			pg_name##_pins, 		\
+			ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = offset,			\
 		.io_reg = offset + 0x4,			\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-sm8350.c b/drivers/pinctrl/qcom/pinctrl-sm8350.c
index 6c402a1..9c69458 100644
--- a/drivers/pinctrl/qcom/pinctrl-sm8350.c
+++ b/drivers/pinctrl/qcom/pinctrl-sm8350.c
@@ -14,9 +14,9 @@
 
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7, f8, f9) \
 	{					        \
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = (unsigned int)ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio" #id, 	\
+			gpio##id##_pins, 		\
+			ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio, /* gpio mode */	\
 			msm_mux_##f1,			\
@@ -53,9 +53,9 @@
 
 #define SDC_PINGROUP(pg_name, ctl, pull, drv)	\
 	{					        \
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, 	\
+			pg_name##_pins, 		\
+			ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
@@ -78,9 +78,9 @@
 
 #define UFS_RESET(pg_name, offset)				\
 	{					        \
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, 	\
+			pg_name##_pins, 		\
+			ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = offset,			\
 		.io_reg = offset + 0x4,			\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-sm8450.c b/drivers/pinctrl/qcom/pinctrl-sm8450.c
index 5dcebea..d11bb1e 100644
--- a/drivers/pinctrl/qcom/pinctrl-sm8450.c
+++ b/drivers/pinctrl/qcom/pinctrl-sm8450.c
@@ -14,9 +14,9 @@
 
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7, f8, f9)	\
 	{					        \
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = (unsigned int)ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio" #id, 	\
+			gpio##id##_pins, 		\
+			ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio, /* gpio mode */	\
 			msm_mux_##f1,			\
@@ -55,9 +55,9 @@
 
 #define SDC_QDSD_PINGROUP(pg_name, ctl, pull, drv)	\
 	{					        \
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, 	\
+			pg_name##_pins, 		\
+			ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
@@ -80,9 +80,9 @@
 
 #define UFS_RESET(pg_name, offset)				\
 	{					        \
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, 	\
+			pg_name##_pins, 		\
+			ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = offset,			\
 		.io_reg = offset + 0x4,			\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-sm8550.c b/drivers/pinctrl/qcom/pinctrl-sm8550.c
index d69e702..3c847d9 100644
--- a/drivers/pinctrl/qcom/pinctrl-sm8550.c
+++ b/drivers/pinctrl/qcom/pinctrl-sm8550.c
@@ -15,9 +15,9 @@
 
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7, f8, f9)	\
 	{					        \
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = (unsigned int)ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio" #id, 	\
+			gpio##id##_pins, 		\
+			ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio, /* gpio mode */	\
 			msm_mux_##f1,			\
@@ -57,9 +57,9 @@
 
 #define SDC_QDSD_PINGROUP(pg_name, ctl, pull, drv)	\
 	{					        \
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, 	\
+			pg_name##_pins, 		\
+			ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
@@ -82,9 +82,9 @@
 
 #define UFS_RESET(pg_name, offset)				\
 	{					        \
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, 	\
+			pg_name##_pins, 		\
+			ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = offset,			\
 		.io_reg = offset + 0x4,			\
 		.intr_cfg_reg = 0,			\
-- 
2.7.4


