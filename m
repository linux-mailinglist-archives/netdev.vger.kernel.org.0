Return-Path: <netdev+bounces-67-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA0E56F4FC9
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 07:40:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 58848280DED
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 05:40:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 442F410F0;
	Wed,  3 May 2023 05:40:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CB44A49
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 05:40:00 +0000 (UTC)
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26715272A;
	Tue,  2 May 2023 22:39:55 -0700 (PDT)
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3434csJ8005836;
	Wed, 3 May 2023 05:39:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=qcppdkim1;
 bh=5tHHtVws8wwIKTj3y3AcY/IFfTHUrSMXIbOPI0yJVAA=;
 b=pt+w5difwUmmYJpL+3K2pC0UZ2aG5iK5zY8/W8/bCozoDYSdkzABRBVmGUXXuWqDrMSx
 0v5SuQE67Mndqe0GhBwislN2S+6cpK72kK0G0sIAw5tSKOFH1v004OGyvfJGKQZ9kgv8
 gqer+jNwIDM2OZ8Ox8zmp9ISk6Ea5+f9a68SMXiSrfSTKjsLnR9t2JUZXIugG9IQ8THR
 igQFMbUQB6/mE4elLXZnIDs39R3noKQlw2UZyJDc7/yuCJGunNn6lGVYlxGVJ/G/+ub9
 8f2goxldxqQPMxUr9kX4RT2uUORKJ39OZbkS4SkCPriTgFfsvvtE9yyi7p6cVrfqfawY vg== 
Received: from apblrppmta02.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.18.19])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3qb4us9hkw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 03 May 2023 05:39:46 +0000
Received: from pps.filterd (APBLRPPMTA02.qualcomm.com [127.0.0.1])
	by APBLRPPMTA02.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTP id 3435dheq012689;
	Wed, 3 May 2023 05:39:43 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by APBLRPPMTA02.qualcomm.com (PPS) with ESMTP id 3q8vakygh7-1;
	Wed, 03 May 2023 05:39:43 +0000
Received: from APBLRPPMTA02.qualcomm.com (APBLRPPMTA02.qualcomm.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3435dhXB012679;
	Wed, 3 May 2023 05:39:43 GMT
Received: from hu-sgudaval-hyd.qualcomm.com (hu-rohiagar-hyd.qualcomm.com [10.213.106.138])
	by APBLRPPMTA02.qualcomm.com (PPS) with ESMTP id 3435dgS1012672;
	Wed, 03 May 2023 05:39:43 +0000
Received: by hu-sgudaval-hyd.qualcomm.com (Postfix, from userid 3970568)
	id 4CA9550FD; Wed,  3 May 2023 11:09:42 +0530 (+0530)
From: Rohit Agarwal <quic_rohiagar@quicinc.com>
To: agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org,
        linus.walleij@linaro.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, richardcochran@gmail.com,
        manivannan.sadhasivam@linaro.org, andy.shevchenko@gmail.com
Cc: linux-arm-msm@vger.kernel.org, linux-gpio@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Rohit Agarwal <quic_rohiagar@quicinc.com>
Subject: [PATCH v5 2/3] pinctrl: qcom: Refactor target specific pinctrl driver
Date: Wed,  3 May 2023 11:09:39 +0530
Message-Id: <1683092380-29551-3-git-send-email-quic_rohiagar@quicinc.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1683092380-29551-1-git-send-email-quic_rohiagar@quicinc.com>
References: <1683092380-29551-1-git-send-email-quic_rohiagar@quicinc.com>
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: 5hIavDEGwlR1UMuvS54lCG1zjuFRk_AK
X-Proofpoint-ORIG-GUID: 5hIavDEGwlR1UMuvS54lCG1zjuFRk_AK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-03_02,2023-04-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 adultscore=0 priorityscore=1501 phishscore=0
 impostorscore=0 mlxlogscore=846 spamscore=0 malwarescore=0 clxscore=1015
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

Update the msm_function and msm_pingroup structure to reuse the generic
pinfunction and pingroup structures. Also refactor pinctrl drivers to adjust
the new macro and updated structure defined in pinctrl.h and pinctrl_msm.h
respectively.

Signed-off-by: Rohit Agarwal <quic_rohiagar@quicinc.com>
Suggested-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/pinctrl/qcom/pinctrl-apq8064.c  | 19 ++++++++-----------
 drivers/pinctrl/qcom/pinctrl-apq8084.c  | 17 +++++++----------
 drivers/pinctrl/qcom/pinctrl-ipq4019.c  | 12 +++++-------
 drivers/pinctrl/qcom/pinctrl-ipq5332.c  | 12 +++++-------
 drivers/pinctrl/qcom/pinctrl-ipq6018.c  | 12 +++++-------
 drivers/pinctrl/qcom/pinctrl-ipq8064.c  | 17 +++++++----------
 drivers/pinctrl/qcom/pinctrl-ipq8074.c  | 12 +++++-------
 drivers/pinctrl/qcom/pinctrl-mdm9607.c  | 17 +++++++----------
 drivers/pinctrl/qcom/pinctrl-mdm9615.c  | 12 +++++-------
 drivers/pinctrl/qcom/pinctrl-msm.c      | 18 +++++++++---------
 drivers/pinctrl/qcom/pinctrl-msm.h      | 17 +++++------------
 drivers/pinctrl/qcom/pinctrl-msm8226.c  | 17 +++++++----------
 drivers/pinctrl/qcom/pinctrl-msm8660.c  | 17 +++++++----------
 drivers/pinctrl/qcom/pinctrl-msm8909.c  | 17 +++++++----------
 drivers/pinctrl/qcom/pinctrl-msm8916.c  | 17 +++++++----------
 drivers/pinctrl/qcom/pinctrl-msm8953.c  | 17 +++++++----------
 drivers/pinctrl/qcom/pinctrl-msm8960.c  | 17 +++++++----------
 drivers/pinctrl/qcom/pinctrl-msm8976.c  | 17 +++++++----------
 drivers/pinctrl/qcom/pinctrl-msm8994.c  | 17 +++++++----------
 drivers/pinctrl/qcom/pinctrl-msm8996.c  | 17 +++++++----------
 drivers/pinctrl/qcom/pinctrl-msm8998.c  | 21 +++++++++------------
 drivers/pinctrl/qcom/pinctrl-msm8x74.c  | 22 +++++++++-------------
 drivers/pinctrl/qcom/pinctrl-qcm2290.c  | 22 +++++++++-------------
 drivers/pinctrl/qcom/pinctrl-qcs404.c   | 17 +++++++----------
 drivers/pinctrl/qcom/pinctrl-qdf2xxx.c  |  6 +++---
 drivers/pinctrl/qcom/pinctrl-qdu1000.c  | 22 +++++++++-------------
 drivers/pinctrl/qcom/pinctrl-sa8775p.c  | 22 +++++++++-------------
 drivers/pinctrl/qcom/pinctrl-sc7180.c   | 22 +++++++++-------------
 drivers/pinctrl/qcom/pinctrl-sc7280.c   | 22 +++++++++-------------
 drivers/pinctrl/qcom/pinctrl-sc8180x.c  | 22 +++++++++-------------
 drivers/pinctrl/qcom/pinctrl-sc8280xp.c | 22 +++++++++-------------
 drivers/pinctrl/qcom/pinctrl-sdm660.c   | 17 +++++++----------
 drivers/pinctrl/qcom/pinctrl-sdm670.c   | 27 +++++++++++----------------
 drivers/pinctrl/qcom/pinctrl-sdm845.c   | 22 +++++++++-------------
 drivers/pinctrl/qcom/pinctrl-sdx55.c    | 17 +++++++----------
 drivers/pinctrl/qcom/pinctrl-sdx65.c    | 22 +++++++++-------------
 drivers/pinctrl/qcom/pinctrl-sm6115.c   | 22 +++++++++-------------
 drivers/pinctrl/qcom/pinctrl-sm6125.c   | 22 +++++++++-------------
 drivers/pinctrl/qcom/pinctrl-sm6350.c   | 22 +++++++++-------------
 drivers/pinctrl/qcom/pinctrl-sm6375.c   | 21 +++++++++------------
 drivers/pinctrl/qcom/pinctrl-sm8150.c   | 22 +++++++++-------------
 drivers/pinctrl/qcom/pinctrl-sm8250.c   | 22 +++++++++-------------
 drivers/pinctrl/qcom/pinctrl-sm8350.c   | 22 +++++++++-------------
 drivers/pinctrl/qcom/pinctrl-sm8450.c   | 22 +++++++++-------------
 drivers/pinctrl/qcom/pinctrl-sm8550.c   | 22 +++++++++-------------
 45 files changed, 346 insertions(+), 494 deletions(-)

diff --git a/drivers/pinctrl/qcom/pinctrl-apq8064.c b/drivers/pinctrl/qcom/pinctrl-apq8064.c
index d40ad4e..1f2d2b2 100644
--- a/drivers/pinctrl/qcom/pinctrl-apq8064.c
+++ b/drivers/pinctrl/qcom/pinctrl-apq8064.c
@@ -6,7 +6,6 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
-#include <linux/pinctrl/pinctrl.h>
 
 #include "pinctrl-msm.h"
 
@@ -211,16 +210,15 @@ static const unsigned int sdc3_data_pins[] = { 95 };
 
 #define FUNCTION(fname)					\
 	[APQ_MUX_##fname] = {				\
-		.name = #fname,				\
-		.groups = fname##_groups,		\
-		.ngroups = ARRAY_SIZE(fname##_groups),	\
-	}
+		.func = PINCTRL_PINFUNCTION(#fname,			\
+					fname##_groups,			\
+					ARRAY_SIZE(fname##_groups))		\
+			}
 
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7, f8, f9, f10) \
 	{						\
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio"#id, gpio##id##_pins,	\
+			(unsigned int)ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			APQ_MUX_gpio,			\
 			APQ_MUX_##f1,			\
@@ -259,9 +257,8 @@ static const unsigned int sdc3_data_pins[] = { 95 };
 
 #define SDC_PINGROUP(pg_name, ctl, pull, drv)		\
 	{						\
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, pg_name##_pins,	\
+			(unsigned int)ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-apq8084.c b/drivers/pinctrl/qcom/pinctrl-apq8084.c
index f83153a..9c6c33c 100644
--- a/drivers/pinctrl/qcom/pinctrl-apq8084.c
+++ b/drivers/pinctrl/qcom/pinctrl-apq8084.c
@@ -6,7 +6,6 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
-#include <linux/pinctrl/pinctrl.h>
 
 #include "pinctrl-msm.h"
 
@@ -326,16 +325,15 @@ static const unsigned int sdc2_data_pins[] = { 152 };
 
 #define FUNCTION(fname)					\
 	[APQ_MUX_##fname] = {				\
-		.name = #fname,				\
-		.groups = fname##_groups,		\
-		.ngroups = ARRAY_SIZE(fname##_groups),	\
+		.func = PINCTRL_PINFUNCTION(#fname,			\
+					fname##_groups,			\
+					ARRAY_SIZE(fname##_groups))		\
 	}
 
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7)        \
 	{						\
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio"#id, gpio##id##_pins,	\
+			(unsigned int)ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			APQ_MUX_gpio,			\
 			APQ_MUX_##f1,			\
@@ -371,9 +369,8 @@ static const unsigned int sdc2_data_pins[] = { 152 };
 
 #define SDC_PINGROUP(pg_name, ctl, pull, drv)		\
 	{						\
-		.name = #pg_name,	                \
-		.pins = pg_name##_pins,                 \
-		.npins = ARRAY_SIZE(pg_name##_pins),    \
+		.grp = PINCTRL_PINGROUP(#pg_name, pg_name##_pins,	\
+			(unsigned int)ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,                         \
 		.io_reg = 0,                            \
 		.intr_cfg_reg = 0,                      \
diff --git a/drivers/pinctrl/qcom/pinctrl-ipq4019.c b/drivers/pinctrl/qcom/pinctrl-ipq4019.c
index 63915cb..dbf7514 100644
--- a/drivers/pinctrl/qcom/pinctrl-ipq4019.c
+++ b/drivers/pinctrl/qcom/pinctrl-ipq4019.c
@@ -6,7 +6,6 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
-#include <linux/pinctrl/pinctrl.h>
 
 #include "pinctrl-msm.h"
 
@@ -218,16 +217,15 @@ DECLARE_QCA_GPIO_PINS(99);
 
 #define FUNCTION(fname)			                \
 	[qca_mux_##fname] = {		                \
-		.name = #fname,				\
-		.groups = fname##_groups,               \
-		.ngroups = ARRAY_SIZE(fname##_groups),	\
+		.func = PINCTRL_PINFUNCTION(#fname,			\
+					fname##_groups,			\
+					ARRAY_SIZE(fname##_groups))		\
 	}
 
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, f11, f12, f13, f14) \
 	{					        \
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = (unsigned)ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio"#id, gpio##id##_pins,	\
+			(unsigned int)ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			qca_mux_gpio, /* gpio mode */	\
 			qca_mux_##f1,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-ipq5332.c b/drivers/pinctrl/qcom/pinctrl-ipq5332.c
index e78d112..32507fa 100644
--- a/drivers/pinctrl/qcom/pinctrl-ipq5332.c
+++ b/drivers/pinctrl/qcom/pinctrl-ipq5332.c
@@ -6,23 +6,21 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
-#include <linux/pinctrl/pinctrl.h>
 
 #include "pinctrl-msm.h"
 
 #define FUNCTION(fname)			                \
 	[msm_mux_##fname] = {		                \
-		.name = #fname,				\
-		.groups = fname##_groups,               \
-		.ngroups = ARRAY_SIZE(fname##_groups),	\
+		.func = PINCTRL_PINFUNCTION(#fname,			\
+					fname##_groups,			\
+					ARRAY_SIZE(fname##_groups))		\
 	}
 
 #define REG_SIZE 0x1000
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7, f8, f9)	\
 	{					        \
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = (unsigned int)ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio"#id, gpio##id##_pins,	\
+			(unsigned int)ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio, /* gpio mode */	\
 			msm_mux_##f1,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-ipq6018.c b/drivers/pinctrl/qcom/pinctrl-ipq6018.c
index ec50a3b4..bfd4c20 100644
--- a/drivers/pinctrl/qcom/pinctrl-ipq6018.c
+++ b/drivers/pinctrl/qcom/pinctrl-ipq6018.c
@@ -6,23 +6,21 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
-#include <linux/pinctrl/pinctrl.h>
 
 #include "pinctrl-msm.h"
 
 #define FUNCTION(fname)			                \
 	[msm_mux_##fname] = {		                \
-		.name = #fname,				\
-		.groups = fname##_groups,               \
-		.ngroups = ARRAY_SIZE(fname##_groups),	\
+		.func = PINCTRL_PINFUNCTION(#fname,			\
+					fname##_groups,			\
+					ARRAY_SIZE(fname##_groups))		\
 	}
 
 #define REG_SIZE 0x1000
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7, f8, f9)	\
 	{					        \
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = (unsigned int)ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio"#id, gpio##id##_pins,	\
+			(unsigned int)ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio, /* gpio mode */	\
 			msm_mux_##f1,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-ipq8064.c b/drivers/pinctrl/qcom/pinctrl-ipq8064.c
index ac717ee..b33d637 100644
--- a/drivers/pinctrl/qcom/pinctrl-ipq8064.c
+++ b/drivers/pinctrl/qcom/pinctrl-ipq8064.c
@@ -6,7 +6,6 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
-#include <linux/pinctrl/pinctrl.h>
 
 #include "pinctrl-msm.h"
 
@@ -163,16 +162,15 @@ static const unsigned int sdc3_data_pins[] = { 71 };
 
 #define FUNCTION(fname)					\
 	[IPQ_MUX_##fname] = {				\
-		.name = #fname,				\
-		.groups = fname##_groups,		\
-		.ngroups = ARRAY_SIZE(fname##_groups),	\
+		.func = PINCTRL_PINFUNCTION(#fname,			\
+					fname##_groups,			\
+					ARRAY_SIZE(fname##_groups))		\
 	}
 
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7, f8, f9, f10) \
 	{						\
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio"#id, gpio##id##_pins,	\
+			(unsigned int)ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			IPQ_MUX_gpio,			\
 			IPQ_MUX_##f1,			\
@@ -211,9 +209,8 @@ static const unsigned int sdc3_data_pins[] = { 71 };
 
 #define SDC_PINGROUP(pg_name, ctl, pull, drv)		\
 	{						\
-		.name = #pg_name,	                \
-		.pins = pg_name##_pins,                 \
-		.npins = ARRAY_SIZE(pg_name##_pins),    \
+		.grp = PINCTRL_PINGROUP(#pg_name, pg_name##_pins,	\
+			(unsigned int)ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,                         \
 		.io_reg = 0,                            \
 		.intr_cfg_reg = 0,                      \
diff --git a/drivers/pinctrl/qcom/pinctrl-ipq8074.c b/drivers/pinctrl/qcom/pinctrl-ipq8074.c
index aec68b1..2148311 100644
--- a/drivers/pinctrl/qcom/pinctrl-ipq8074.c
+++ b/drivers/pinctrl/qcom/pinctrl-ipq8074.c
@@ -6,23 +6,21 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
-#include <linux/pinctrl/pinctrl.h>
 
 #include "pinctrl-msm.h"
 
 #define FUNCTION(fname)			                \
 	[msm_mux_##fname] = {		                \
-		.name = #fname,				\
-		.groups = fname##_groups,               \
-		.ngroups = ARRAY_SIZE(fname##_groups),	\
+		.func = PINCTRL_PINFUNCTION(#fname,			\
+					fname##_groups,			\
+					ARRAY_SIZE(fname##_groups))		\
 	}
 
 #define REG_SIZE 0x1000
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7, f8, f9)	\
 	{					        \
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = (unsigned int)ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio"#id, gpio##id##_pins,	\
+			(unsigned int)ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio, /* gpio mode */	\
 			msm_mux_##f1,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-mdm9607.c b/drivers/pinctrl/qcom/pinctrl-mdm9607.c
index d622b3d..e8d71f7 100644
--- a/drivers/pinctrl/qcom/pinctrl-mdm9607.c
+++ b/drivers/pinctrl/qcom/pinctrl-mdm9607.c
@@ -8,7 +8,6 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
-#include <linux/pinctrl/pinctrl.h>
 
 #include "pinctrl-msm.h"
 
@@ -206,16 +205,15 @@ static const unsigned int qdsd_data3_pins[] = { 91 };
 
 #define FUNCTION(fname)			                \
 	[msm_mux_##fname] = {		                \
-		.name = #fname,				\
-		.groups = fname##_groups,               \
-		.ngroups = ARRAY_SIZE(fname##_groups),	\
+		.func = PINCTRL_PINFUNCTION(#fname,			\
+					fname##_groups,			\
+					ARRAY_SIZE(fname##_groups))		\
 	}
 
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7, f8, f9)	\
 	{							\
-		.name = "gpio" #id,				\
-		.pins = gpio##id##_pins,			\
-		.npins = ARRAY_SIZE(gpio##id##_pins),		\
+		.grp = PINCTRL_PINGROUP("gpio"#id, gpio##id##_pins,	\
+			(unsigned int)ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){				\
 			msm_mux_gpio,				\
 			msm_mux_##f1,				\
@@ -252,9 +250,8 @@ static const unsigned int qdsd_data3_pins[] = { 91 };
 
 #define SDC_PINGROUP(pg_name, ctl, pull, drv)	\
 	{					        \
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, pg_name##_pins,	\
+			(unsigned int)ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-mdm9615.c b/drivers/pinctrl/qcom/pinctrl-mdm9615.c
index 24a4e43..72a7241 100644
--- a/drivers/pinctrl/qcom/pinctrl-mdm9615.c
+++ b/drivers/pinctrl/qcom/pinctrl-mdm9615.c
@@ -8,7 +8,6 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
-#include <linux/pinctrl/pinctrl.h>
 #include <linux/pinctrl/pinmux.h>
 
 #include "pinctrl-msm.h"
@@ -197,16 +196,15 @@ DECLARE_MSM_GPIO_PINS(87);
 
 #define FUNCTION(fname)					\
 	[MSM_MUX_##fname] = {				\
-		.name = #fname,				\
-		.groups = fname##_groups,		\
-		.ngroups = ARRAY_SIZE(fname##_groups),	\
+		.func = PINCTRL_PINFUNCTION(#fname,			\
+					fname##_groups,			\
+					ARRAY_SIZE(fname##_groups))		\
 	}
 
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, f11) \
 	{						\
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio"#id, gpio##id##_pins,	\
+			(unsigned int)ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			MSM_MUX_gpio,			\
 			MSM_MUX_##f1,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-msm.c b/drivers/pinctrl/qcom/pinctrl-msm.c
index daeb79a..a152b8a 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm.c
@@ -121,7 +121,7 @@ static const char *msm_get_group_name(struct pinctrl_dev *pctldev,
 {
 	struct msm_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctldev);
 
-	return pctrl->soc->groups[group].name;
+	return pctrl->soc->groups[group].grp.name;
 }
 
 static int msm_get_group_pins(struct pinctrl_dev *pctldev,
@@ -131,8 +131,8 @@ static int msm_get_group_pins(struct pinctrl_dev *pctldev,
 {
 	struct msm_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctldev);
 
-	*pins = pctrl->soc->groups[group].pins;
-	*num_pins = pctrl->soc->groups[group].npins;
+	*pins = pctrl->soc->groups[group].grp.pins;
+	*num_pins = pctrl->soc->groups[group].grp.npins;
 	return 0;
 }
 
@@ -164,7 +164,7 @@ static const char *msm_get_function_name(struct pinctrl_dev *pctldev,
 {
 	struct msm_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctldev);
 
-	return pctrl->soc->functions[function].name;
+	return pctrl->soc->functions[function].func.name;
 }
 
 static int msm_get_function_groups(struct pinctrl_dev *pctldev,
@@ -174,8 +174,8 @@ static int msm_get_function_groups(struct pinctrl_dev *pctldev,
 {
 	struct msm_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctldev);
 
-	*groups = pctrl->soc->functions[function].groups;
-	*num_groups = pctrl->soc->functions[function].ngroups;
+	*groups = pctrl->soc->functions[function].func.groups;
+	*num_groups = pctrl->soc->functions[function].func.ngroups;
 	return 0;
 }
 
@@ -680,11 +680,11 @@ static void msm_gpio_dbg_show_one(struct seq_file *s,
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
@@ -1419,7 +1419,7 @@ static void msm_pinctrl_setup_pm_reset(struct msm_pinctrl *pctrl)
 	const struct msm_function *func = pctrl->soc->functions;
 
 	for (i = 0; i < pctrl->soc->nfunctions; i++)
-		if (!strcmp(func[i].name, "ps_hold")) {
+		if (!strcmp(func[i].func.name, "ps_hold")) {
 			pctrl->restart_nb.notifier_call = msm_ps_hold_restart;
 			pctrl->restart_nb.priority = 128;
 			if (register_restart_handler(&pctrl->restart_nb))
diff --git a/drivers/pinctrl/qcom/pinctrl-msm.h b/drivers/pinctrl/qcom/pinctrl-msm.h
index 985eced..22ea1b3 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm.h
+++ b/drivers/pinctrl/qcom/pinctrl-msm.h
@@ -5,6 +5,7 @@
 #ifndef __PINCTRL_MSM_H__
 #define __PINCTRL_MSM_H__
 
+#include <linux/pinctrl/pinctrl.h>
 #include <linux/pm.h>
 #include <linux/types.h>
 
@@ -14,21 +15,15 @@ struct pinctrl_pin_desc;
 
 /**
  * struct msm_function - a pinmux function
- * @name:    Name of the pinmux function.
- * @groups:  List of pingroups for this function.
- * @ngroups: Number of entries in @groups.
+ * @func: Generic data of the pin function (name and groups of pins)
  */
 struct msm_function {
-	const char *name;
-	const char * const *groups;
-	unsigned ngroups;
+	struct pinfunction func;
 };
 
 /**
  * struct msm_pingroup - Qualcomm pingroup definition
- * @name:                 Name of the pingroup.
- * @pins:	          A list of pins assigned to this pingroup.
- * @npins:	          Number of entries in @pins.
+ * @grp:                  Generic data of the pin group (name and pins)
  * @funcs:                A list of pinmux functions that can be selected for
  *                        this group. The index of the selected function is used
  *                        for programming the function selector.
@@ -61,9 +56,7 @@ struct msm_function {
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
index 0f05725..12a7878 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm8226.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm8226.c
@@ -6,7 +6,6 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
-#include <linux/pinctrl/pinctrl.h>
 
 #include "pinctrl-msm.h"
 
@@ -265,16 +264,15 @@ static const unsigned int sdc2_data_pins[] = { 122 };
 
 #define FUNCTION(fname)					\
 	[MSM_MUX_##fname] = {				\
-		.name = #fname,				\
-		.groups = fname##_groups,		\
-		.ngroups = ARRAY_SIZE(fname##_groups),	\
+		.func = PINCTRL_PINFUNCTION(#fname,			\
+					fname##_groups,			\
+					ARRAY_SIZE(fname##_groups))		\
 	}
 
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7)	\
 	{						\
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio"#id, gpio##id##_pins,	\
+			(unsigned int)ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			MSM_MUX_gpio,			\
 			MSM_MUX_##f1,			\
@@ -309,9 +307,8 @@ static const unsigned int sdc2_data_pins[] = { 122 };
 
 #define SDC_PINGROUP(pg_name, ctl, pull, drv)		\
 	{						\
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, pg_name##_pins,	\
+			(unsigned int)ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-msm8660.c b/drivers/pinctrl/qcom/pinctrl-msm8660.c
index 16e562e..886a230 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm8660.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm8660.c
@@ -6,7 +6,6 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
-#include <linux/pinctrl/pinctrl.h>
 
 #include "pinctrl-msm.h"
 
@@ -377,16 +376,15 @@ static const unsigned int sdc3_data_pins[] = { 178 };
 
 #define FUNCTION(fname)					\
 	[MSM_MUX_##fname] = {				\
-		.name = #fname,				\
-		.groups = fname##_groups,		\
-		.ngroups = ARRAY_SIZE(fname##_groups),	\
+		.func = PINCTRL_PINFUNCTION(#fname,			\
+					fname##_groups,			\
+					ARRAY_SIZE(fname##_groups))		\
 	}
 
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7) \
 	{						\
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio"#id, gpio##id##_pins,	\
+			(unsigned int)ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			MSM_MUX_gpio,			\
 			MSM_MUX_##f1,			\
@@ -422,9 +420,8 @@ static const unsigned int sdc3_data_pins[] = { 178 };
 
 #define SDC_PINGROUP(pg_name, ctl, pull, drv)		\
 	{						\
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, pg_name##_pins,	\
+			(unsigned int)ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-msm8909.c b/drivers/pinctrl/qcom/pinctrl-msm8909.c
index 6dd15b9..b481aab 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm8909.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm8909.c
@@ -7,23 +7,21 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
-#include <linux/pinctrl/pinctrl.h>
 
 #include "pinctrl-msm.h"
 
 #define FUNCTION(fname)					\
 	[msm_mux_##fname] = {				\
-		.name = #fname,				\
-		.groups = fname##_groups,		\
-		.ngroups = ARRAY_SIZE(fname##_groups),	\
+		.func = PINCTRL_PINFUNCTION(#fname,			\
+					fname##_groups,			\
+					ARRAY_SIZE(fname##_groups))		\
 	}
 
 #define REG_SIZE 0x1000
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7, f8, f9)	\
 	{						\
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio"#id, gpio##id##_pins,	\
+			(unsigned int)ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio,			\
 			msm_mux_##f1,			\
@@ -60,9 +58,8 @@
 
 #define SDC_QDSD_PINGROUP(pg_name, ctl, pull, drv)	\
 	{						\
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, pg_name##_pins,	\
+			(unsigned int)ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-msm8916.c b/drivers/pinctrl/qcom/pinctrl-msm8916.c
index bf68913..bb2fb98 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm8916.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm8916.c
@@ -6,7 +6,6 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
-#include <linux/pinctrl/pinctrl.h>
 
 #include "pinctrl-msm.h"
 
@@ -288,16 +287,15 @@ static const unsigned int qdsd_data3_pins[] = { 133 };
 
 #define FUNCTION(fname)			                \
 	[MSM_MUX_##fname] = {		                \
-		.name = #fname,				\
-		.groups = fname##_groups,               \
-		.ngroups = ARRAY_SIZE(fname##_groups),	\
+		.func = PINCTRL_PINFUNCTION(#fname,			\
+					fname##_groups,			\
+					ARRAY_SIZE(fname##_groups))		\
 	}
 
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7, f8, f9)	\
 	{							\
-		.name = "gpio" #id,				\
-		.pins = gpio##id##_pins,			\
-		.npins = ARRAY_SIZE(gpio##id##_pins),		\
+		.grp = PINCTRL_PINGROUP("gpio"#id, gpio##id##_pins,	\
+			(unsigned int)ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){				\
 			MSM_MUX_gpio,				\
 			MSM_MUX_##f1,				\
@@ -334,9 +332,8 @@ static const unsigned int qdsd_data3_pins[] = { 133 };
 
 #define SDC_PINGROUP(pg_name, ctl, pull, drv)	\
 	{					        \
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, pg_name##_pins,	\
+			(unsigned int)ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-msm8953.c b/drivers/pinctrl/qcom/pinctrl-msm8953.c
index e0c939f..e5aa63d 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm8953.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm8953.c
@@ -4,22 +4,20 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
-#include <linux/pinctrl/pinctrl.h>
 
 #include "pinctrl-msm.h"
 
 #define FUNCTION(fname)					\
 	[msm_mux_##fname] = {				\
-		.name = #fname,				\
-		.groups = fname##_groups,               \
-		.ngroups = ARRAY_SIZE(fname##_groups),	\
+		.func = PINCTRL_PINFUNCTION(#fname,			\
+					fname##_groups,			\
+					ARRAY_SIZE(fname##_groups))		\
 	}
 
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7, f8, f9)	\
 	{							\
-		.name = "gpio" #id,				\
-		.pins = gpio##id##_pins,			\
-		.npins = ARRAY_SIZE(gpio##id##_pins),		\
+		.grp = PINCTRL_PINGROUP("gpio"#id, gpio##id##_pins,	\
+			(unsigned int)ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){				\
 			msm_mux_gpio, /* gpio mode */		\
 			msm_mux_##f1,				\
@@ -56,9 +54,8 @@
 
 #define SDC_QDSD_PINGROUP(pg_name, ctl, pull, drv)	\
 	{					        \
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, pg_name##_pins,	\
+			(unsigned int)ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-msm8960.c b/drivers/pinctrl/qcom/pinctrl-msm8960.c
index e3928f5f..107b79b 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm8960.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm8960.c
@@ -6,7 +6,6 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
-#include <linux/pinctrl/pinctrl.h>
 #include <linux/pinctrl/pinmux.h>
 
 #include "pinctrl-msm.h"
@@ -336,16 +335,15 @@ static const unsigned int sdc3_data_pins[] = { 157 };
 
 #define FUNCTION(fname)					\
 	[MSM_MUX_##fname] = {				\
-		.name = #fname,				\
-		.groups = fname##_groups,		\
-		.ngroups = ARRAY_SIZE(fname##_groups),	\
+		.func = PINCTRL_PINFUNCTION(#fname,			\
+					fname##_groups,			\
+					ARRAY_SIZE(fname##_groups))		\
 	}
 
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, f11) \
 	{						\
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio"#id, gpio##id##_pins,	\
+			(unsigned int)ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			MSM_MUX_gpio,			\
 			MSM_MUX_##f1,			\
@@ -385,9 +383,8 @@ static const unsigned int sdc3_data_pins[] = { 157 };
 
 #define SDC_PINGROUP(pg_name, ctl, pull, drv)		\
 	{						\
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, pg_name##_pins,	\
+			(unsigned int)ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-msm8976.c b/drivers/pinctrl/qcom/pinctrl-msm8976.c
index e11d845..feb7de4 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm8976.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm8976.c
@@ -8,24 +8,22 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
-#include <linux/pinctrl/pinctrl.h>
 
 #include "pinctrl-msm.h"
 
 #define FUNCTION(fname)			                \
 	[msm_mux_##fname] = {		                \
-		.name = #fname,				\
-		.groups = fname##_groups,               \
-		.ngroups = ARRAY_SIZE(fname##_groups),	\
+		.func = PINCTRL_PINFUNCTION(#fname,			\
+					fname##_groups,			\
+					ARRAY_SIZE(fname##_groups))		\
 	}
 
 #define REG_BASE 0x0
 #define REG_SIZE 0x1000
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7, f8, f9)	\
 	{					        \
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio"#id, gpio##id##_pins,	\
+			(unsigned int)ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio, /* gpio mode */	\
 			msm_mux_##f1,			\
@@ -62,9 +60,8 @@
 
 #define SDC_QDSD_PINGROUP(pg_name, ctl, pull, drv)	\
 	{					        \
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, pg_name##_pins,	\
+			(unsigned int)ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-msm8994.c b/drivers/pinctrl/qcom/pinctrl-msm8994.c
index 0ec8865..f80a838 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm8994.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm8994.c
@@ -6,22 +6,20 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
-#include <linux/pinctrl/pinctrl.h>
 
 #include "pinctrl-msm.h"
 
 #define FUNCTION(fname)					\
 	[MSM_MUX_##fname] = {				\
-		.name = #fname,				\
-		.groups = fname##_groups,		\
-		.ngroups = ARRAY_SIZE(fname##_groups),	\
+		.func = PINCTRL_PINFUNCTION(#fname,			\
+					fname##_groups,			\
+					ARRAY_SIZE(fname##_groups))		\
 	}
 
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, f11)	\
 	{						\
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio"#id, gpio##id##_pins,	\
+			(unsigned int)ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			MSM_MUX_gpio,			\
 			MSM_MUX_##f1,			\
@@ -60,9 +58,8 @@
 
 #define SDC_PINGROUP(pg_name, ctl, pull, drv)		\
 	{						\
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, pg_name##_pins,	\
+			(unsigned int)ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-msm8996.c b/drivers/pinctrl/qcom/pinctrl-msm8996.c
index 05812df..0e71fa7 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm8996.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm8996.c
@@ -6,24 +6,22 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
-#include <linux/pinctrl/pinctrl.h>
 
 #include "pinctrl-msm.h"
 
 #define FUNCTION(fname)			                \
 	[msm_mux_##fname] = {		                \
-		.name = #fname,				\
-		.groups = fname##_groups,               \
-		.ngroups = ARRAY_SIZE(fname##_groups),	\
+		.func = PINCTRL_PINFUNCTION(#fname,			\
+					fname##_groups,			\
+					ARRAY_SIZE(fname##_groups))		\
 	}
 
 #define REG_BASE 0x0
 #define REG_SIZE 0x1000
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7, f8, f9)	\
 	{					        \
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = (unsigned)ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio"#id, gpio##id##_pins,	\
+			(unsigned int)ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio, /* gpio mode */	\
 			msm_mux_##f1,			\
@@ -60,9 +58,8 @@
 
 #define SDC_QDSD_PINGROUP(pg_name, ctl, pull, drv)	\
 	{					        \
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, pg_name##_pins,	\
+			(unsigned int)ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-msm8998.c b/drivers/pinctrl/qcom/pinctrl-msm8998.c
index a05f41f..34de9fa 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm8998.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm8998.c
@@ -16,16 +16,15 @@
 
 #define FUNCTION(fname)					\
 	[msm_mux_##fname] = {				\
-		.name = #fname,				\
-		.groups = fname##_groups,               \
-		.ngroups = ARRAY_SIZE(fname##_groups),	\
+		.func = PINCTRL_PINFUNCTION(#fname,			\
+					fname##_groups,			\
+					ARRAY_SIZE(fname##_groups))		\
 	}
 
 #define PINGROUP(id, base, f1, f2, f3, f4, f5, f6, f7, f8, f9)	\
 	{					        \
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio"#id, gpio##id##_pins,	\
+			(unsigned int)ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio, /* gpio mode */	\
 			msm_mux_##f1,			\
@@ -62,9 +61,8 @@
 
 #define SDC_QDSD_PINGROUP(pg_name, ctl, pull, drv)	\
 	{					        \
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, pg_name##_pins,	\
+			(unsigned int)ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
@@ -87,9 +85,8 @@
 
 #define UFS_RESET(pg_name, offset)				\
 	{					        \
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, pg_name##_pins,	\
+			(unsigned int)ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = offset,			\
 		.io_reg = offset + 0x4,			\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-msm8x74.c b/drivers/pinctrl/qcom/pinctrl-msm8x74.c
index 3d193ac..625068d 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm8x74.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm8x74.c
@@ -6,7 +6,6 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
-#include <linux/pinctrl/pinctrl.h>
 
 #include "pinctrl-msm.h"
 
@@ -327,16 +326,15 @@ static const unsigned int hsic_data_pins[] = { 153 };
 
 #define FUNCTION(fname)					\
 	[MSM_MUX_##fname] = {				\
-		.name = #fname,				\
-		.groups = fname##_groups,		\
-		.ngroups = ARRAY_SIZE(fname##_groups),	\
+		.func = PINCTRL_PINFUNCTION(#fname,			\
+					fname##_groups,			\
+					ARRAY_SIZE(fname##_groups))		\
 	}
 
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7)	\
 	{						\
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio"#id, gpio##id##_pins,	\
+			(unsigned int)ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			MSM_MUX_gpio,			\
 			MSM_MUX_##f1,			\
@@ -371,9 +369,8 @@ static const unsigned int hsic_data_pins[] = { 153 };
 
 #define SDC_PINGROUP(pg_name, ctl, pull, drv)		\
 	{						\
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, pg_name##_pins,	\
+			(unsigned int)ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
@@ -397,9 +394,8 @@ static const unsigned int hsic_data_pins[] = { 153 };
 
 #define HSIC_PINGROUP(pg_name, ctl)			\
 	{						\
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, pg_name##_pins,	\
+			(unsigned int)ARRAY_SIZE(pg_name##_pins)),	\
 		.funcs = (int[]){			\
 			MSM_MUX_gpio,			\
 			MSM_MUX_hsic_ctl,		\
diff --git a/drivers/pinctrl/qcom/pinctrl-qcm2290.c b/drivers/pinctrl/qcom/pinctrl-qcm2290.c
index aa9325f..a0a64fd 100644
--- a/drivers/pinctrl/qcom/pinctrl-qcm2290.c
+++ b/drivers/pinctrl/qcom/pinctrl-qcm2290.c
@@ -6,24 +6,22 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
-#include <linux/pinctrl/pinctrl.h>
 
 #include "pinctrl-msm.h"
 
 #define FUNCTION(fname)					\
 	[msm_mux_##fname] = {				\
-		.name = #fname,				\
-		.groups = fname##_groups,		\
-		.ngroups = ARRAY_SIZE(fname##_groups),	\
+		.func = PINCTRL_PINFUNCTION(#fname,			\
+					fname##_groups,			\
+					ARRAY_SIZE(fname##_groups))		\
 	}
 
 #define REG_SIZE 0x1000
 
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7, f8, f9)	\
 	{						\
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = (unsigned int)ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio"#id, gpio##id##_pins,	\
+			(unsigned int)ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio, /* gpio mode */	\
 			msm_mux_##f1,			\
@@ -60,9 +58,8 @@
 
 #define SDC_QDSD_PINGROUP(pg_name, ctl, pull, drv)	\
 	{					        \
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, pg_name##_pins,	\
+			(unsigned int)ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
@@ -85,9 +82,8 @@
 
 #define UFS_RESET(pg_name, offset)				\
 	{					        \
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, pg_name##_pins,	\
+			(unsigned int)ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = offset,			\
 		.io_reg = offset + 0x4,			\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-qcs404.c b/drivers/pinctrl/qcom/pinctrl-qcs404.c
index 1c6ba97..f0ae362 100644
--- a/drivers/pinctrl/qcom/pinctrl-qcs404.c
+++ b/drivers/pinctrl/qcom/pinctrl-qcs404.c
@@ -6,7 +6,6 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
-#include <linux/pinctrl/pinctrl.h>
 
 #include "pinctrl-msm.h"
 
@@ -24,16 +23,15 @@ enum {
 
 #define FUNCTION(fname)					\
 	[msm_mux_##fname] = {				\
-		.name = #fname,				\
-		.groups = fname##_groups,		\
-		.ngroups = ARRAY_SIZE(fname##_groups),	\
+		.func = PINCTRL_PINFUNCTION(#fname,			\
+					fname##_groups,			\
+					ARRAY_SIZE(fname##_groups))		\
 	}
 
 #define PINGROUP(id, _tile, f1, f2, f3, f4, f5, f6, f7, f8, f9)	\
 	{						\
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = (unsigned int)ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio"#id, gpio##id##_pins,	\
+			(unsigned int)ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio, /* gpio mode */	\
 			msm_mux_##f1,			\
@@ -71,9 +69,8 @@ enum {
 
 #define SDC_QDSD_PINGROUP(pg_name, ctl, pull, drv)	\
 	{						\
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, pg_name##_pins,	\
+			(unsigned int)ARRAY_SIZE(pg_name##_pins)),	\
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
index b1d7674..d4f18f1 100644
--- a/drivers/pinctrl/qcom/pinctrl-qdu1000.c
+++ b/drivers/pinctrl/qcom/pinctrl-qdu1000.c
@@ -7,24 +7,22 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
-#include <linux/pinctrl/pinctrl.h>
 
 #include "pinctrl-msm.h"
 
 #define FUNCTION(fname)			                \
 	[msm_mux_##fname] = {		                \
-		.name = #fname,				\
-		.groups = fname##_groups,               \
-		.ngroups = ARRAY_SIZE(fname##_groups),	\
+		.func = PINCTRL_PINFUNCTION(#fname,			\
+					fname##_groups,			\
+					ARRAY_SIZE(fname##_groups))		\
 	}
 
 #define REG_BASE 0x100000
 #define REG_SIZE 0x1000
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7, f8, f9)	\
 	{					        \
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = (unsigned int)ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio"#id, gpio##id##_pins,	\
+			(unsigned int)ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio, /* gpio mode */	\
 			msm_mux_##f1,			\
@@ -61,9 +59,8 @@
 
 #define SDC_QDSD_PINGROUP(pg_name, ctl, pull, drv)	\
 	{					        \
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, pg_name##_pins,	\
+			(unsigned int)ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = REG_BASE + ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
@@ -86,9 +83,8 @@
 
 #define UFS_RESET(pg_name, offset)				\
 	{					        \
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, pg_name##_pins,	\
+			(unsigned int)ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = offset,			\
 		.io_reg = offset + 0x4,			\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-sa8775p.c b/drivers/pinctrl/qcom/pinctrl-sa8775p.c
index 2ae7cdc..57c88c2 100644
--- a/drivers/pinctrl/qcom/pinctrl-sa8775p.c
+++ b/drivers/pinctrl/qcom/pinctrl-sa8775p.c
@@ -7,24 +7,22 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
-#include <linux/pinctrl/pinctrl.h>
 
 #include "pinctrl-msm.h"
 
 #define FUNCTION(fname)			                \
 	[msm_mux_##fname] = {		                \
-		.name = #fname,				\
-		.groups = fname##_groups,               \
-		.ngroups = ARRAY_SIZE(fname##_groups),	\
+		.func = PINCTRL_PINFUNCTION(#fname,			\
+					fname##_groups,			\
+					ARRAY_SIZE(fname##_groups))		\
 	}
 
 #define REG_BASE 0x100000
 #define REG_SIZE 0x1000
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7, f8, f9)\
 	{					        \
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = (unsigned int)ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio"#id, gpio##id##_pins,	\
+			(unsigned int)ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio, /* gpio mode */	\
 			msm_mux_##f1,			\
@@ -63,9 +61,8 @@
 
 #define SDC_QDSD_PINGROUP(pg_name, ctl, pull, drv)	\
 	{					        \
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, pg_name##_pins,	\
+			(unsigned int)ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
@@ -88,9 +85,8 @@
 
 #define UFS_RESET(pg_name, offset)				\
 	{					        \
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, pg_name##_pins,	\
+			(unsigned int)ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = offset,			\
 		.io_reg = offset + 0x4,			\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-sc7180.c b/drivers/pinctrl/qcom/pinctrl-sc7180.c
index 1d9acad..a9822fc 100644
--- a/drivers/pinctrl/qcom/pinctrl-sc7180.c
+++ b/drivers/pinctrl/qcom/pinctrl-sc7180.c
@@ -4,7 +4,6 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
-#include <linux/pinctrl/pinctrl.h>
 
 #include "pinctrl-msm.h"
 
@@ -22,16 +21,15 @@ enum {
 
 #define FUNCTION(fname)					\
 	[msm_mux_##fname] = {				\
-		.name = #fname,				\
-		.groups = fname##_groups,		\
-		.ngroups = ARRAY_SIZE(fname##_groups),	\
+		.func = PINCTRL_PINFUNCTION(#fname,			\
+					fname##_groups,			\
+					ARRAY_SIZE(fname##_groups))		\
 	}
 
 #define PINGROUP(id, _tile, f1, f2, f3, f4, f5, f6, f7, f8, f9)	\
 	{						\
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio"#id, gpio##id##_pins,	\
+			(unsigned int)ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio, /* gpio mode */	\
 			msm_mux_##f1,			\
@@ -69,9 +67,8 @@ enum {
 
 #define SDC_QDSD_PINGROUP(pg_name, ctl, pull, drv)	\
 	{						\
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, pg_name##_pins,	\
+			(unsigned int)ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
@@ -95,9 +92,8 @@ enum {
 
 #define UFS_RESET(pg_name, offset)				\
 	{						\
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, pg_name##_pins,	\
+			(unsigned int)ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = offset,			\
 		.io_reg = offset + 0x4,			\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-sc7280.c b/drivers/pinctrl/qcom/pinctrl-sc7280.c
index 31df55c..1a360e1 100644
--- a/drivers/pinctrl/qcom/pinctrl-sc7280.c
+++ b/drivers/pinctrl/qcom/pinctrl-sc7280.c
@@ -6,22 +6,20 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
-#include <linux/pinctrl/pinctrl.h>
 
 #include "pinctrl-msm.h"
 
 #define FUNCTION(fname)			                \
 	[msm_mux_##fname] = {		                \
-		.name = #fname,				\
-		.groups = fname##_groups,               \
-		.ngroups = ARRAY_SIZE(fname##_groups),	\
+		.func = PINCTRL_PINFUNCTION(#fname,			\
+					fname##_groups,			\
+					ARRAY_SIZE(fname##_groups))		\
 	}
 
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7, f8, f9)	\
 	{					        \
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = (unsigned int)ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio"#id, gpio##id##_pins,	\
+			(unsigned int)ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio, /* gpio mode */	\
 			msm_mux_##f1,			\
@@ -60,9 +58,8 @@
 
 #define SDC_QDSD_PINGROUP(pg_name, ctl, pull, drv)	\
 	{					        \
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, pg_name##_pins,	\
+			(unsigned int)ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
@@ -85,9 +82,8 @@
 
 #define UFS_RESET(pg_name, offset)				\
 	{					        \
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, pg_name##_pins,	\
+			(unsigned int)ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = offset,			\
 		.io_reg = offset + 0x4,			\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-sc8180x.c b/drivers/pinctrl/qcom/pinctrl-sc8180x.c
index 704a99d..c63b38d 100644
--- a/drivers/pinctrl/qcom/pinctrl-sc8180x.c
+++ b/drivers/pinctrl/qcom/pinctrl-sc8180x.c
@@ -7,7 +7,6 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
-#include <linux/pinctrl/pinctrl.h>
 
 #include "pinctrl-msm.h"
 
@@ -40,17 +39,16 @@ static const struct tile_info sc8180x_tile_info[] = {
 
 #define FUNCTION(fname)					\
 	[msm_mux_##fname] = {				\
-		.name = #fname,				\
-		.groups = fname##_groups,		\
-		.ngroups = ARRAY_SIZE(fname##_groups),	\
+		.func = PINCTRL_PINFUNCTION(#fname,			\
+					fname##_groups,			\
+					ARRAY_SIZE(fname##_groups))		\
 	}
 
 #define REG_SIZE 0x1000
 #define PINGROUP_OFFSET(id, _tile, offset, f1, f2, f3, f4, f5, f6, f7, f8, f9)	\
 	{						\
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = (unsigned int)ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio"#id, gpio##id##_pins,	\
+			(unsigned int)ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio, /* gpio mode */	\
 			msm_mux_##f1,			\
@@ -91,9 +89,8 @@ static const struct tile_info sc8180x_tile_info[] = {
 
 #define SDC_QDSD_PINGROUP(pg_name, ctl, pull, drv)	\
 	{						\
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, pg_name##_pins,	\
+			(unsigned int)ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
@@ -117,9 +114,8 @@ static const struct tile_info sc8180x_tile_info[] = {
 
 #define UFS_RESET(pg_name)				\
 	{						\
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, pg_name##_pins,	\
+			(unsigned int)ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = 0xb6000,			\
 		.io_reg = 0xb6004,			\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-sc8280xp.c b/drivers/pinctrl/qcom/pinctrl-sc8280xp.c
index e96c006..8598391 100644
--- a/drivers/pinctrl/qcom/pinctrl-sc8280xp.c
+++ b/drivers/pinctrl/qcom/pinctrl-sc8280xp.c
@@ -7,23 +7,21 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
-#include <linux/pinctrl/pinctrl.h>
 
 #include "pinctrl-msm.h"
 
 #define FUNCTION(fname)					\
 	[msm_mux_##fname] = {				\
-		.name = #fname,				\
-		.groups = fname##_groups,		\
-		.ngroups = ARRAY_SIZE(fname##_groups),	\
+		.func = PINCTRL_PINFUNCTION(#fname,			\
+					fname##_groups,			\
+					ARRAY_SIZE(fname##_groups))		\
 	}
 
 #define REG_SIZE 0x1000
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7)	\
 	{						\
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = (unsigned int)ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio"#id, gpio##id##_pins,	\
+			(unsigned int)ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio, /* gpio mode */	\
 			msm_mux_##f1,			\
@@ -60,9 +58,8 @@
 
 #define SDC_QDSD_PINGROUP(pg_name, ctl, pull, drv)	\
 	{						\
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, pg_name##_pins,	\
+			(unsigned int)ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
@@ -85,9 +82,8 @@
 
 #define UFS_RESET(pg_name, offset)				\
 	{						\
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, pg_name##_pins,	\
+			(unsigned int)ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = offset,			\
 		.io_reg = offset + 0x4,			\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-sdm660.c b/drivers/pinctrl/qcom/pinctrl-sdm660.c
index 1bfb0ae..ba263459 100644
--- a/drivers/pinctrl/qcom/pinctrl-sdm660.c
+++ b/drivers/pinctrl/qcom/pinctrl-sdm660.c
@@ -7,7 +7,6 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
-#include <linux/pinctrl/pinctrl.h>
 
 #include "pinctrl-msm.h"
 
@@ -27,17 +26,16 @@ enum {
 
 #define FUNCTION(fname)					\
 	[msm_mux_##fname] = {		                \
-		.name = #fname,				\
-		.groups = fname##_groups,               \
-		.ngroups = ARRAY_SIZE(fname##_groups),	\
+		.func = PINCTRL_PINFUNCTION(#fname,			\
+					fname##_groups,			\
+					ARRAY_SIZE(fname##_groups))		\
 	}
 
 
 #define PINGROUP(id, _tile, f1, f2, f3, f4, f5, f6, f7, f8, f9)	\
 	{					        \
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = (unsigned)ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio"#id, gpio##id##_pins,	\
+			(unsigned int)ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio, /* gpio mode */	\
 			msm_mux_##f1,			\
@@ -75,9 +73,8 @@ enum {
 
 #define SDC_QDSD_PINGROUP(pg_name, ctl, pull, drv)	\
 	{					        \
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, pg_name##_pins,	\
+			(unsigned int)ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-sdm670.c b/drivers/pinctrl/qcom/pinctrl-sdm670.c
index b888bca..8878e6b 100644
--- a/drivers/pinctrl/qcom/pinctrl-sdm670.c
+++ b/drivers/pinctrl/qcom/pinctrl-sdm670.c
@@ -7,15 +7,14 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
-#include <linux/pinctrl/pinctrl.h>
 
 #include "pinctrl-msm.h"
 
 #define FUNCTION(fname)					\
 	[msm_mux_##fname] = {				\
-		.name = #fname,				\
-		.groups = fname##_groups,		\
-		.ngroups = ARRAY_SIZE(fname##_groups),	\
+		.func = PINCTRL_PINFUNCTION(#fname,			\
+					fname##_groups,			\
+					ARRAY_SIZE(fname##_groups))		\
 	}
 
 #define NORTH	0x00500000
@@ -25,9 +24,8 @@
 #define REG_SIZE 0x1000
 #define PINGROUP(id, base, f1, f2, f3, f4, f5, f6, f7, f8, f9)	\
 	{						\
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio"#id, gpio##id##_pins,	\
+			(unsigned int)ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio, /* gpio mode */	\
 			msm_mux_##f1,			\
@@ -68,9 +66,8 @@
  */
 #define PINGROUP_DUMMY(id)				\
 	{						\
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio"#id, gpio##id##_pins,	\
+			(unsigned int)ARRAY_SIZE(gpio##id##_pins)),	\
 		.ctl_reg = 0,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
@@ -93,9 +90,8 @@
 
 #define SDC_QDSD_PINGROUP(pg_name, ctl, pull, drv)	\
 	{						\
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, pg_name##_pins,	\
+			(unsigned int)ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
@@ -118,9 +114,8 @@
 
 #define UFS_RESET(pg_name, offset)				\
 	{						\
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, pg_name##_pins,	\
+			(unsigned int)ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = offset,			\
 		.io_reg = offset + 0x4,			\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-sdm845.c b/drivers/pinctrl/qcom/pinctrl-sdm845.c
index fdfd7b8..e2d9856 100644
--- a/drivers/pinctrl/qcom/pinctrl-sdm845.c
+++ b/drivers/pinctrl/qcom/pinctrl-sdm845.c
@@ -7,15 +7,14 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
-#include <linux/pinctrl/pinctrl.h>
 
 #include "pinctrl-msm.h"
 
 #define FUNCTION(fname)					\
 	[msm_mux_##fname] = {				\
-		.name = #fname,				\
-		.groups = fname##_groups,		\
-		.ngroups = ARRAY_SIZE(fname##_groups),	\
+		.func = PINCTRL_PINFUNCTION(#fname,			\
+					fname##_groups,			\
+					ARRAY_SIZE(fname##_groups))		\
 	}
 
 #define NORTH	0x00500000
@@ -24,9 +23,8 @@
 #define REG_SIZE 0x1000
 #define PINGROUP(id, base, f1, f2, f3, f4, f5, f6, f7, f8, f9, f10)	\
 	{						\
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio"#id, gpio##id##_pins,	\
+			(unsigned int)ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio, /* gpio mode */	\
 			msm_mux_##f1,			\
@@ -64,9 +62,8 @@
 
 #define SDC_QDSD_PINGROUP(pg_name, ctl, pull, drv)	\
 	{						\
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, pg_name##_pins,	\
+			(unsigned int)ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
@@ -89,9 +86,8 @@
 
 #define UFS_RESET(pg_name, offset)				\
 	{						\
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, pg_name##_pins,	\
+			(unsigned int)ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = offset,			\
 		.io_reg = offset + 0x4,			\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-sdx55.c b/drivers/pinctrl/qcom/pinctrl-sdx55.c
index 0bb4931..0667094 100644
--- a/drivers/pinctrl/qcom/pinctrl-sdx55.c
+++ b/drivers/pinctrl/qcom/pinctrl-sdx55.c
@@ -6,24 +6,22 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
-#include <linux/pinctrl/pinctrl.h>
 
 #include "pinctrl-msm.h"
 
 #define FUNCTION(fname)			                \
 	[msm_mux_##fname] = {		                \
-		.name = #fname,				\
-		.groups = fname##_groups,               \
-		.ngroups = ARRAY_SIZE(fname##_groups),	\
+		.func = PINCTRL_PINFUNCTION(#fname,			\
+					fname##_groups,			\
+					ARRAY_SIZE(fname##_groups))		\
 	}
 
 #define REG_SIZE 0x1000
 
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7, f8, f9)	\
 	{					        \
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = (unsigned int)ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio"#id, gpio##id##_pins,	\
+			(unsigned int)ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio, /* gpio mode */	\
 			msm_mux_##f1,			\
@@ -60,9 +58,8 @@
 
 #define SDC_PINGROUP(pg_name, ctl, pull, drv)	\
 	{					        \
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, pg_name##_pins,	\
+			(unsigned int)ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-sdx65.c b/drivers/pinctrl/qcom/pinctrl-sdx65.c
index e793ea7..0b3693b 100644
--- a/drivers/pinctrl/qcom/pinctrl-sdx65.c
+++ b/drivers/pinctrl/qcom/pinctrl-sdx65.c
@@ -6,24 +6,22 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
-#include <linux/pinctrl/pinctrl.h>
 
 #include "pinctrl-msm.h"
 
 #define FUNCTION(fname)			                \
 	[msm_mux_##fname] = {		                \
-		.name = #fname,				\
-		.groups = fname##_groups,               \
-		.ngroups = ARRAY_SIZE(fname##_groups),	\
+		.func = PINCTRL_PINFUNCTION(#fname,			\
+					fname##_groups,			\
+					ARRAY_SIZE(fname##_groups))		\
 	}
 
 #define REG_BASE 0x0
 #define REG_SIZE 0x1000
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7, f8, f9)	\
 	{					        \
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = (unsigned int)ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio"#id, gpio##id##_pins,	\
+			(unsigned int)ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio, /* gpio mode */	\
 			msm_mux_##f1,			\
@@ -60,9 +58,8 @@
 
 #define SDC_QDSD_PINGROUP(pg_name, ctl, pull, drv)	\
 	{					        \
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, pg_name##_pins,	\
+			(unsigned int)ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
@@ -85,9 +82,8 @@
 
 #define UFS_RESET(pg_name, offset)				\
 	{					        \
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, pg_name##_pins,	\
+			(unsigned int)ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = offset,			\
 		.io_reg = offset + 0x4,			\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-sm6115.c b/drivers/pinctrl/qcom/pinctrl-sm6115.c
index b3a0161..d4a557e 100644
--- a/drivers/pinctrl/qcom/pinctrl-sm6115.c
+++ b/drivers/pinctrl/qcom/pinctrl-sm6115.c
@@ -6,7 +6,6 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
-#include <linux/pinctrl/pinctrl.h>
 
 #include "pinctrl-msm.h"
 
@@ -24,16 +23,15 @@ enum {
 
 #define FUNCTION(fname)					\
 	[msm_mux_##fname] = {				\
-		.name = #fname,				\
-		.groups = fname##_groups,		\
-		.ngroups = ARRAY_SIZE(fname##_groups),	\
+		.func = PINCTRL_PINFUNCTION(#fname,			\
+					fname##_groups,			\
+					ARRAY_SIZE(fname##_groups))		\
 	}
 
 #define PINGROUP(id, _tile, f1, f2, f3, f4, f5, f6, f7, f8, f9)	\
 	{						\
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = (unsigned int)ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio"#id, gpio##id##_pins,	\
+			(unsigned int)ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio, /* gpio mode */	\
 			msm_mux_##f1,			\
@@ -71,9 +69,8 @@ enum {
 
 #define SDC_QDSD_PINGROUP(pg_name, _tile, ctl, pull, drv)	\
 	{						\
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, pg_name##_pins,	\
+			(unsigned int)ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
@@ -97,9 +94,8 @@ enum {
 
 #define UFS_RESET(pg_name, offset)			\
 	{						\
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, pg_name##_pins,	\
+			(unsigned int)ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = offset,			\
 		.io_reg = offset + 0x4,			\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-sm6125.c b/drivers/pinctrl/qcom/pinctrl-sm6125.c
index 170d4ff..162e4ee 100644
--- a/drivers/pinctrl/qcom/pinctrl-sm6125.c
+++ b/drivers/pinctrl/qcom/pinctrl-sm6125.c
@@ -3,7 +3,6 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
-#include <linux/pinctrl/pinctrl.h>
 
 #include "pinctrl-msm.h"
 
@@ -21,16 +20,15 @@ enum {
 
 #define FUNCTION(fname)					\
 	[msm_mux_##fname] = {				\
-		.name = #fname,				\
-		.groups = fname##_groups,		\
-		.ngroups = ARRAY_SIZE(fname##_groups),	\
+		.func = PINCTRL_PINFUNCTION(#fname,			\
+					fname##_groups,			\
+					ARRAY_SIZE(fname##_groups))		\
 	}
 
 #define PINGROUP(id, _tile, f1, f2, f3, f4, f5, f6, f7, f8, f9)	\
 	{						\
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = (unsigned int)ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio"#id, gpio##id##_pins,	\
+			(unsigned int)ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio, /* gpio mode */	\
 			msm_mux_##f1,			\
@@ -68,9 +66,8 @@ enum {
 
 #define SDC_QDSD_PINGROUP(pg_name, _tile, ctl, pull, drv)	\
 	{						\
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, pg_name##_pins,	\
+			(unsigned int)ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
@@ -94,9 +91,8 @@ enum {
 
 #define UFS_RESET(pg_name, offset)				\
 	{						\
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, pg_name##_pins,	\
+			(unsigned int)ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = offset,			\
 		.io_reg = offset + 0x4,			\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-sm6350.c b/drivers/pinctrl/qcom/pinctrl-sm6350.c
index a91a866..0616302 100644
--- a/drivers/pinctrl/qcom/pinctrl-sm6350.c
+++ b/drivers/pinctrl/qcom/pinctrl-sm6350.c
@@ -7,23 +7,21 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
-#include <linux/pinctrl/pinctrl.h>
 
 #include "pinctrl-msm.h"
 
 #define FUNCTION(fname)			                \
 	[msm_mux_##fname] = {		                \
-		.name = #fname,				\
-		.groups = fname##_groups,               \
-		.ngroups = ARRAY_SIZE(fname##_groups),	\
+		.func = PINCTRL_PINFUNCTION(#fname,			\
+					fname##_groups,			\
+					ARRAY_SIZE(fname##_groups))		\
 	}
 
 #define REG_SIZE 0x1000
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7, f8, f9)	\
 	{					        \
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = (unsigned int)ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio"#id, gpio##id##_pins,	\
+			(unsigned int)ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio, /* gpio mode */	\
 			msm_mux_##f1,			\
@@ -60,9 +58,8 @@
 
 #define SDC_PINGROUP(pg_name, ctl, pull, drv)	\
 	{					        \
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, pg_name##_pins,	\
+			(unsigned int)ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
@@ -85,9 +82,8 @@
 
 #define UFS_RESET(pg_name, offset)				\
 	{					        \
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, pg_name##_pins,	\
+			(unsigned int)ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = offset,			\
 		.io_reg = offset + 0x4,			\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-sm6375.c b/drivers/pinctrl/qcom/pinctrl-sm6375.c
index 1138e68..5129d75 100644
--- a/drivers/pinctrl/qcom/pinctrl-sm6375.c
+++ b/drivers/pinctrl/qcom/pinctrl-sm6375.c
@@ -13,18 +13,17 @@
 
 #define FUNCTION(fname)			                \
 	[msm_mux_##fname] = {		                \
-		.name = #fname,				\
-		.groups = fname##_groups,               \
-		.ngroups = ARRAY_SIZE(fname##_groups),	\
+		.func = PINCTRL_PINFUNCTION(#fname,			\
+					fname##_groups,			\
+					ARRAY_SIZE(fname##_groups))		\
 	}
 
 #define REG_BASE 0x100000
 #define REG_SIZE 0x1000
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7, f8, f9)	\
 	{					        \
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = (unsigned int)ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio"#id, gpio##id##_pins,	\
+			(unsigned int)ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio, /* gpio mode */	\
 			msm_mux_##f1,			\
@@ -63,9 +62,8 @@
 
 #define SDC_PINGROUP(pg_name, ctl, pull, drv)	\
 	{					        \
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, pg_name##_pins,	\
+			(unsigned int)ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
@@ -88,9 +86,8 @@
 
 #define UFS_RESET(pg_name, offset)				\
 	{					        \
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, pg_name##_pins,	\
+			(unsigned int)ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = offset,			\
 		.io_reg = offset + 0x4,			\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-sm8150.c b/drivers/pinctrl/qcom/pinctrl-sm8150.c
index 1cc6226..4efa4b2 100644
--- a/drivers/pinctrl/qcom/pinctrl-sm8150.c
+++ b/drivers/pinctrl/qcom/pinctrl-sm8150.c
@@ -4,7 +4,6 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
-#include <linux/pinctrl/pinctrl.h>
 
 #include "pinctrl-msm.h"
 
@@ -24,16 +23,15 @@ enum {
 
 #define FUNCTION(fname)					\
 	[msm_mux_##fname] = {				\
-		.name = #fname,				\
-		.groups = fname##_groups,		\
-		.ngroups = ARRAY_SIZE(fname##_groups),	\
+		.func = PINCTRL_PINFUNCTION(#fname,			\
+					fname##_groups,			\
+					ARRAY_SIZE(fname##_groups))		\
 	}
 
 #define PINGROUP(id, _tile, f1, f2, f3, f4, f5, f6, f7, f8, f9)	\
 	{						\
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = (unsigned int)ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio"#id, gpio##id##_pins,	\
+			(unsigned int)ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio, /* gpio mode */	\
 			msm_mux_##f1,			\
@@ -71,9 +69,8 @@ enum {
 
 #define SDC_QDSD_PINGROUP(pg_name, ctl, pull, drv)	\
 	{						\
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, pg_name##_pins,	\
+			(unsigned int)ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
@@ -97,9 +94,8 @@ enum {
 
 #define UFS_RESET(pg_name, offset)				\
 	{						\
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, pg_name##_pins,	\
+			(unsigned int)ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = offset,			\
 		.io_reg = offset + 0x4,			\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-sm8250.c b/drivers/pinctrl/qcom/pinctrl-sm8250.c
index 3bd7f9f..8d54920 100644
--- a/drivers/pinctrl/qcom/pinctrl-sm8250.c
+++ b/drivers/pinctrl/qcom/pinctrl-sm8250.c
@@ -6,7 +6,6 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
-#include <linux/pinctrl/pinctrl.h>
 
 #include "pinctrl-msm.h"
 
@@ -24,17 +23,16 @@ enum {
 
 #define FUNCTION(fname)					\
 	[msm_mux_##fname] = {				\
-		.name = #fname,				\
-		.groups = fname##_groups,		\
-		.ngroups = ARRAY_SIZE(fname##_groups),	\
+		.func = PINCTRL_PINFUNCTION(#fname,			\
+					fname##_groups,			\
+					ARRAY_SIZE(fname##_groups))		\
 	}
 
 #define REG_SIZE 0x1000
 #define PINGROUP(id, _tile, f1, f2, f3, f4, f5, f6, f7, f8, f9) \
 	{						\
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = (unsigned int)ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio"#id, gpio##id##_pins,	\
+			(unsigned int)ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio, /* gpio mode */	\
 			msm_mux_##f1,			\
@@ -72,9 +70,8 @@ enum {
 
 #define SDC_PINGROUP(pg_name, ctl, pull, drv)	\
 	{						\
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, pg_name##_pins,	\
+			(unsigned int)ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
@@ -98,9 +95,8 @@ enum {
 
 #define UFS_RESET(pg_name, offset)				\
 	{						\
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, pg_name##_pins,	\
+			(unsigned int)ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = offset,			\
 		.io_reg = offset + 0x4,			\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-sm8350.c b/drivers/pinctrl/qcom/pinctrl-sm8350.c
index 1c042d3..cd22811 100644
--- a/drivers/pinctrl/qcom/pinctrl-sm8350.c
+++ b/drivers/pinctrl/qcom/pinctrl-sm8350.c
@@ -7,24 +7,22 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
-#include <linux/pinctrl/pinctrl.h>
 
 #include "pinctrl-msm.h"
 
 #define FUNCTION(fname)			                \
 	[msm_mux_##fname] = {		                \
-		.name = #fname,				\
-		.groups = fname##_groups,               \
-		.ngroups = ARRAY_SIZE(fname##_groups),	\
+		.func = PINCTRL_PINFUNCTION(#fname,			\
+					fname##_groups,			\
+					ARRAY_SIZE(fname##_groups))		\
 	}
 
 #define REG_SIZE 0x1000
 
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7, f8, f9) \
 	{					        \
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = (unsigned int)ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio"#id, gpio##id##_pins,	\
+			(unsigned int)ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio, /* gpio mode */	\
 			msm_mux_##f1,			\
@@ -61,9 +59,8 @@
 
 #define SDC_PINGROUP(pg_name, ctl, pull, drv)	\
 	{					        \
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, pg_name##_pins,	\
+			(unsigned int)ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
@@ -86,9 +83,8 @@
 
 #define UFS_RESET(pg_name, offset)				\
 	{					        \
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, pg_name##_pins,	\
+			(unsigned int)ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = offset,			\
 		.io_reg = offset + 0x4,			\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-sm8450.c b/drivers/pinctrl/qcom/pinctrl-sm8450.c
index 3110d7b..5247eea 100644
--- a/drivers/pinctrl/qcom/pinctrl-sm8450.c
+++ b/drivers/pinctrl/qcom/pinctrl-sm8450.c
@@ -7,24 +7,22 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
-#include <linux/pinctrl/pinctrl.h>
 
 #include "pinctrl-msm.h"
 
 #define FUNCTION(fname)			                \
 	[msm_mux_##fname] = {		                \
-		.name = #fname,				\
-		.groups = fname##_groups,               \
-		.ngroups = ARRAY_SIZE(fname##_groups),	\
+		.func = PINCTRL_PINFUNCTION(#fname,			\
+					fname##_groups,			\
+					ARRAY_SIZE(fname##_groups))		\
 	}
 
 #define REG_SIZE 0x1000
 
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7, f8, f9)	\
 	{					        \
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = (unsigned int)ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio"#id, gpio##id##_pins,	\
+			(unsigned int)ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio, /* gpio mode */	\
 			msm_mux_##f1,			\
@@ -63,9 +61,8 @@
 
 #define SDC_QDSD_PINGROUP(pg_name, ctl, pull, drv)	\
 	{					        \
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, pg_name##_pins,	\
+			(unsigned int)ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
@@ -88,9 +85,8 @@
 
 #define UFS_RESET(pg_name, offset)				\
 	{					        \
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, pg_name##_pins,	\
+			(unsigned int)ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = offset,			\
 		.io_reg = offset + 0x4,			\
 		.intr_cfg_reg = 0,			\
diff --git a/drivers/pinctrl/qcom/pinctrl-sm8550.c b/drivers/pinctrl/qcom/pinctrl-sm8550.c
index c9d0380..7b9124d 100644
--- a/drivers/pinctrl/qcom/pinctrl-sm8550.c
+++ b/drivers/pinctrl/qcom/pinctrl-sm8550.c
@@ -8,24 +8,22 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
-#include <linux/pinctrl/pinctrl.h>
 
 #include "pinctrl-msm.h"
 
 #define FUNCTION(fname)			                \
 	[msm_mux_##fname] = {		                \
-		.name = #fname,				\
-		.groups = fname##_groups,               \
-		.ngroups = ARRAY_SIZE(fname##_groups),	\
+		.func = PINCTRL_PINFUNCTION(#fname,			\
+					fname##_groups,			\
+					ARRAY_SIZE(fname##_groups))		\
 	}
 
 #define REG_SIZE 0x1000
 
 #define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7, f8, f9)	\
 	{					        \
-		.name = "gpio" #id,			\
-		.pins = gpio##id##_pins,		\
-		.npins = (unsigned int)ARRAY_SIZE(gpio##id##_pins),	\
+		.grp = PINCTRL_PINGROUP("gpio"#id, gpio##id##_pins,	\
+			(unsigned int)ARRAY_SIZE(gpio##id##_pins)),	\
 		.funcs = (int[]){			\
 			msm_mux_gpio, /* gpio mode */	\
 			msm_mux_##f1,			\
@@ -65,9 +63,8 @@
 
 #define SDC_QDSD_PINGROUP(pg_name, ctl, pull, drv)	\
 	{					        \
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, pg_name##_pins,	\
+			(unsigned int)ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = ctl,				\
 		.io_reg = 0,				\
 		.intr_cfg_reg = 0,			\
@@ -90,9 +87,8 @@
 
 #define UFS_RESET(pg_name, offset)				\
 	{					        \
-		.name = #pg_name,			\
-		.pins = pg_name##_pins,			\
-		.npins = (unsigned int)ARRAY_SIZE(pg_name##_pins),	\
+		.grp = PINCTRL_PINGROUP(#pg_name, pg_name##_pins,	\
+			(unsigned int)ARRAY_SIZE(pg_name##_pins)),	\
 		.ctl_reg = offset,			\
 		.io_reg = offset + 0x4,			\
 		.intr_cfg_reg = 0,			\
-- 
2.7.4


